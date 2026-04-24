-- SF2 softlock tracer for Mesen2 (load in Script Window, then play to the black screen)
-- Detects:
--   * PPU forced blank held for >120 frames
--   * Path engine state (pathptr, gosubcount, object sword2 set) unchanged for >300 frames
-- On detection, dumps state + last 256 path-engine entries to sf2_softlock_dump.txt.
-- Also draws a live HUD overlay so you can watch the engine in real time.

local OUT_PATH = "C:\\Editor Test\\sf2_softlock_dump.txt"
local ERR_PATH = "C:\\Editor Test\\sf2_softlock_err.txt"

do local f = io.open(ERR_PATH, "w"); if f then f:write("script started\n"); f:close() end end
local function logErr(msg)
  local f = io.open(ERR_PATH, "a"); if f then f:write(tostring(msg).."\n"); f:close() end
  emu.log(tostring(msg))
end
local function safe(fn) return function(...)
  local ok,err = pcall(fn, ...); if not ok then logErr("CALLBACK ERR: "..tostring(err)) end
end end

----------------------------------------------------------------------
-- Tunables
----------------------------------------------------------------------
local FORCED_BLANK_LIMIT = 120    -- frames of forced blank => softlock
local STALL_LIMIT        = 600    -- 10s of no path-engine change => softlock
local MAX_FRAMES         = 36000  -- 10min hard cap for headless runs
local TRACE_LEN          = 1024

-- Forward declarations so snapshot() can see curFrame / DP cache
local curFrame = 0
local cachedDP = 0

----------------------------------------------------------------------
-- Symbols
----------------------------------------------------------------------
local PM_STRAT       = 0x7F7E53
local PM_STRAT2      = 0x7F7E75
local PM_TRIGGERS    = 0x7F9BD0
local DP_PATH_PCPTR  = 0x00EF
local PATHPTR        = 0x7EB256
local PATHGOSUBCOUNT = 0x7E6A06
local PATHGOSUBPTR   = 0x7EB258
local PATHFORCED     = 0x7EB25A
local ALBLKS_DP      = 0x03C0
local NUMACTORS      = 0x7E6A04   -- guess; fall back to scanning
local AL_SWORD2      = 0x2B
local AL_HP          = 0x2D
local AL_AP          = 0x2E
local AL_PATHBANKEXT = 0x3F
local AL_SIZE        = 0x40

local PATHS = {
  [0x9BC10] = "es0_cam", [0x9BDAA] = "es0_cam.pos",
  [0x9C5EC] = "cds_chika", [0x9C621] = "cds_chika.exp",
  [0x2582EE] = "title_ship_explode_0",
  [0x25831E] = "title_ship_explode_l",
  [0x25834E] = "cds_chika_xb (trampoline)",
  [0x258186] = "title_watch2",
  [0x2583C4] = "superdragon_demo",
}

----------------------------------------------------------------------
-- Trace ring
----------------------------------------------------------------------
local trace = {}
local trace_idx = 0
for i=1,TRACE_LEN do trace[i] = "" end
local function push(line)
  trace_idx = (trace_idx % TRACE_LEN) + 1
  trace[trace_idx] = line
end

----------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------
local function rd(a)  return emu.read(a, emu.memType.snesMemory, false) end
local function rdw(a) return rd(a) | (rd(a+1)<<8) end
local function rdl(a) return rd(a) | (rd(a+1)<<8) | (rd(a+2)<<16) end

local function pathName(bank, sword2)
  local key = ((bank & 1)*0x8000) | (sword2 & 0x7FFF) | (((bank-0x40)//2)*0x10000)
  return PATHS[key] or "?"
end

local function snapshot(label, pc24)
  local x = (curX or 0) & 0xFFFF
  local sp = (curSP or 0)
  local objBase = cachedDP + ALBLKS_DP + x
  local bank = rd(objBase + AL_PATHBANKEXT)
  local sword2 = rdw(objBase + AL_SWORD2)
  local pcptr = rdl(cachedDP + DP_PATH_PCPTR)
  local op = rd(pcptr)
  local pp = rdw(PATHPTR)
  local gc = rd(PATHGOSUBCOUNT)
  return string.format(
    "f=%-6d [%s pc=%06X sp=%04X] X=%04X bank=%02X sword2=%04X pcptr=%06X op=%02X pp=%04X gc=%02X (%s)",
    curFrame, label, pc24 or 0, sp, x, bank, sword2, pcptr, op, pp, gc, pathName(bank, sword2))
end

----------------------------------------------------------------------
-- Softlock detection state
----------------------------------------------------------------------
local stopped = false

-- PPU forced-blank streak
local blankStreak = 0
local maxBlankStreak = 0

-- Path engine stall detection: hash of pathptr + gosubcount + first 16 obj sword2s
local lastSig = nil
local sigSameStreak = 0
local maxStallStreak = 0

-- Per-callback hit counters (so we can see them on the HUD)
local hitStrat2, hitStrat, hitTrig = 0, 0, 0
local nmiCount = 0
local sampleCount = 0

-- PC sampler
local pcHist = {}
local lastPC = 0
local function pcSample()
  sampleCount = sampleCount + 1
  local st = emu.getState()
  if not (st and st.cpu) then return end
  local k = st.cpu.k or 0
  local pc = st.cpu.pc or 0
  lastPC = (k << 16) | pc
  -- bucket = bank << 8 | high byte of page (so 256 buckets per bank)
  local bucket = (k << 8) | ((pc >> 8) & 0xFF)
  pcHist[bucket] = (pcHist[bucket] or 0) + 1
end

-- Wide exec sampler: sample every Nth call from a hot region
local execSamples = {}
local execSampleStep = 256
local execSampleCounter = 0
local function execSampler(addr, value)
  execSampleCounter = execSampleCounter + 1
  if (execSampleCounter & (execSampleStep-1)) ~= 0 then return end
  -- record this exec address
  execSamples[addr] = (execSamples[addr] or 0) + 1
end

-- Significant write log (PPU regs + path engine state) - circular
local WLOG_LEN = 64
local wlog = {}
local wlog_idx = 0
for i=1,WLOG_LEN do wlog[i] = "" end
local function wpush(line)
  wlog_idx = (wlog_idx % WLOG_LEN) + 1
  wlog[wlog_idx] = line
end

local function curPC24()
  local st = emu.getState()
  if st and st.cpu then return ((st.cpu.k or 0) << 16) | (st.cpu.pc or 0) end
  return 0
end

local function pathSig()
  local s = string.format("%04X:%02X:%02X:%04X",
    rdw(PATHPTR), rd(PATHGOSUBCOUNT), rd(PATHFORCED), rdw(PATHGOSUBPTR))
  -- include sword2 + pathbankext for first 16 actor slots, using DP-relative base
  local base = cachedDP + ALBLKS_DP
  for i = 0, 15 do
    local b = base + i*AL_SIZE
    s = s .. string.format(":%04X.%02X", rdw(b+AL_SWORD2), rd(b+AL_PATHBANKEXT))
  end
  return s
end

----------------------------------------------------------------------
-- Dump
----------------------------------------------------------------------
local function dumpAndStop(reason)
  if stopped then return end
  stopped = true
  local f = io.open(OUT_PATH, "w")
  if not f then logErr("FAILED to open "..OUT_PATH); return end
  f:write("=== SF2 softlock dump ===\n")
  f:write("Reason: "..reason.."\n")
  f:write(string.format("frame=%d  blankStreakMax=%d  stallStreakMax=%d\n",
    curFrame, maxBlankStreak, maxStallStreak))
  f:write(string.format("hookHits: STRAT2=%d STRAT=%d TRIG=%d\n", hitStrat2, hitStrat, hitTrig))

  pcall(function()
    local st = emu.getState()
    if st and st.cpu then
      f:write(string.format("\nCPU: PC=%02X:%04X DB=%02X D=%04X SP=%04X A=%04X X=%04X Y=%04X P=%02X\n",
        st.cpu.k or 0, st.cpu.pc or 0, st.cpu.dbr or 0, st.cpu.d or 0, st.cpu.sp or 0,
        st.cpu.a or 0, st.cpu.x or 0, st.cpu.y or 0, st.cpu.ps or 0))
    end
    if st and st.ppu then
      f:write(string.format("PPU: forcedBlank=%s scanline=%s bgMode=%s\n",
        tostring(st.ppu.forcedBlank), tostring(st.ppu.scanline), tostring(st.ppu.bgMode)))
    end
  end)

  pcall(function()
    f:write("\n--- path engine state ---\n")
    f:write(string.format("pathptr=%04X gosubcount=%02X pathforced=%02X gosubptr=%04X DP=%04X\n",
      rdw(PATHPTR), rd(PATHGOSUBCOUNT), rd(PATHFORCED), rdw(PATHGOSUBPTR), cachedDP))
    f:write("\n--- object slots (sword2/bank/hp/ap) ---\n")
    local base = cachedDP + ALBLKS_DP
    for i = 0, 31 do
      local b = base + i*AL_SIZE
      local sw2 = rdw(b+AL_SWORD2)
      local bk  = rd(b+AL_PATHBANKEXT)
      local hp  = rd(b+AL_HP)
      local ap  = rd(b+AL_AP)
      if (sw2 ~= 0 and sw2 ~= 0xFFFF) or (bk ~= 0 and bk ~= 0xFF) then
        f:write(string.format("  slot %02d @%04X  sword2=%04X bank=%02X hp=%02X ap=%02X (%s)\n",
          i, b, sw2, bk, hp, ap, pathName(bk, sw2)))
      end
    end
  end)

  pcall(function()
    f:write("\n--- $0000-$01FF (DP+stack) ---\n")
    for row=0,31 do
      local base = row*16
      f:write(string.format("\n%04X: ", base))
      for c=0,15 do f:write(string.format("%02X ", rd(base+c))) end
    end
    f:write("\n")
  end)

  pcall(function()
    f:write("\n--- recent path engine trace (oldest -> newest) ---\n")
    for i=1,TRACE_LEN do
      local idx = ((trace_idx + i - 1) % TRACE_LEN) + 1
      local s = trace[idx]
      if s ~= "" then f:write(s.."\n") end
    end
  end)

  pcall(function()
    f:write("\n--- recent significant writes (oldest -> newest) ---\n")
    for i=1,WLOG_LEN do
      local idx = ((wlog_idx + i - 1) % WLOG_LEN) + 1
      local s = wlog[idx]
      if s ~= "" then f:write(s.."\n") end
    end
  end)

  pcall(function()
    f:write(string.format("\n--- sampleCount=%d  (frames=%d) lastSampledPC=%06X ---\n",
      sampleCount, curFrame, lastPC))
    -- Top 30 PC buckets
    local pairs_arr = {}
    for bucket, count in pairs(pcHist) do
      table.insert(pairs_arr, {bucket=bucket, count=count})
    end
    table.sort(pairs_arr, function(a,b) return a.count > b.count end)
    f:write("--- top start/end-frame PC buckets ---\n")
    for i = 1, math.min(30, #pairs_arr) do
      local b = pairs_arr[i]
      local k    = (b.bucket >> 8) & 0xFF
      local page = b.bucket & 0xFF
      f:write(string.format("  %02X:%02Xxx  hits=%d (%.1f%%)\n",
        k, page, b.count, 100*b.count/math.max(1,sampleCount)))
    end
    -- Top exec sample addresses
    local exec_arr = {}
    for a, c in pairs(execSamples) do table.insert(exec_arr, {addr=a, count=c}) end
    table.sort(exec_arr, function(a,b) return a.count > b.count end)
    f:write(string.format("--- top exec sampler addresses (every %dth hit) ---\n", execSampleStep))
    for i = 1, math.min(30, #exec_arr) do
      local b = exec_arr[i]
      f:write(string.format("  %06X  hits=%d\n", b.addr, b.count))
    end
  end)

  f:close()
  logErr("DUMPED ("..reason..") -> "..OUT_PATH)
  pcall(emu.displayMessage, "SF2", "Softlock dump written: "..reason)
  emu.stop(0)
end

----------------------------------------------------------------------
-- Hooks: path engine entry points
----------------------------------------------------------------------
local function captureCpu()
  local st = emu.getState()
  if st and st.cpu then
    curX  = st.cpu.x or 0
    curSP = st.cpu.sp or 0
    cachedDP = st.cpu.d or cachedDP
  end
end

local function hookStrat2(addr,v)   captureCpu(); hitStrat2 = hitStrat2 + 1; push(snapshot("STRAT2", addr)) end
local function hookStrat (addr,v)   captureCpu(); hitStrat  = hitStrat  + 1; push(snapshot("STRAT ", addr)) end
local function hookTrig  (addr,v)   captureCpu(); hitTrig   = hitTrig   + 1; push(snapshot("TRIG  ", addr)) end

----------------------------------------------------------------------
-- Per-frame: detect softlock
----------------------------------------------------------------------
local function frameTick()
  curFrame = curFrame + 1

  -- DP cache: updated whenever a path-engine hook fires (via captureCpu).
  -- For the first frames before any hook, fall back to known SF2 DP.
  if cachedDP == 0 then cachedDP = 0x1FD8 end

  -- Forced-blank streak
  local st = emu.getState()
  local fb = st and st.ppu and st.ppu.forcedBlank
  if fb then
    blankStreak = blankStreak + 1
    if blankStreak > maxBlankStreak then maxBlankStreak = blankStreak end
  else
    blankStreak = 0
  end

  -- Path-engine stall streak
  local sig = pathSig()
  if sig == lastSig then
    sigSameStreak = sigSameStreak + 1
    if sigSameStreak > maxStallStreak then maxStallStreak = sigSameStreak end
  else
    sigSameStreak = 0
    lastSig = sig
  end

  if not stopped then
    if blankStreak >= FORCED_BLANK_LIMIT then
      dumpAndStop(string.format("PPU forcedBlank held %d frames", blankStreak))
    elseif sigSameStreak >= STALL_LIMIT then
      dumpAndStop(string.format("Path engine stalled %d frames (sig unchanged)", sigSameStreak))
    elseif curFrame >= MAX_FRAMES then
      dumpAndStop(string.format("MAX_FRAMES (%d) reached without softlock", MAX_FRAMES))
    end
  end

  -- progress log every 600 frames so headless runs show life
  if curFrame % 600 == 0 then
    logErr(string.format("frame %d  S2=%d S=%d T=%d  blank=%d  stall=%d",
      curFrame, hitStrat2, hitStrat, hitTrig, blankStreak, sigSameStreak))
  end

  -- HUD (only meaningful in GUI; safe in headless)
  pcall(function()
    local s = string.format("f=%d  S2=%d S=%d T=%d  blank=%d/%d  stall=%d/%d",
      curFrame, hitStrat2, hitStrat, hitTrig,
      blankStreak, FORCED_BLANK_LIMIT,
      sigSameStreak, STALL_LIMIT)
    emu.drawString(2, 2,  s, 0xFFFFFF, 0x80000000)
    local last = trace[trace_idx]
    if last and last ~= "" then
      emu.drawString(2, 12, last:sub(1, 70), 0xFFFF80, 0x80000000)
    end
    if stopped then
      emu.drawString(2, 22, "DUMPED -> sf2_softlock_dump.txt", 0xFF8080, 0x80000000)
    end
  end)
end

----------------------------------------------------------------------
-- Register
----------------------------------------------------------------------
emu.addMemoryCallback(safe(hookStrat2), emu.callbackType.exec, PM_STRAT2)
emu.addMemoryCallback(safe(hookStrat),  emu.callbackType.exec, PM_STRAT)
emu.addMemoryCallback(safe(hookTrig),   emu.callbackType.exec, PM_TRIGGERS)

-- Watch writes to INIDISP ($2100) and TM ($212C) -- screen visibility
local function watchInidisp(addr, value)
  wpush(string.format("f=%-6d INIDISP<-%02X  pc=%06X", curFrame, value, curPC24()))
end
local function watchTM(addr, value)
  wpush(string.format("f=%-6d TM<-%02X      pc=%06X", curFrame, value, curPC24()))
end
-- Watch writes to path-engine state
local function watchPathptr(addr, value)
  wpush(string.format("f=%-6d PATHPTR[%X]<-%02X pc=%06X", curFrame, addr&0xFFFF, value, curPC24()))
end
local function watchGosub(addr, value)
  wpush(string.format("f=%-6d GOSUBCNT<-%02X pc=%06X", curFrame, value, curPC24()))
end
local function watchForced(addr, value)
  wpush(string.format("f=%-6d PATHFORCED<-%02X pc=%06X", curFrame, value, curPC24()))
end

emu.addMemoryCallback(safe(watchInidisp), emu.callbackType.write, 0x002100)
emu.addMemoryCallback(safe(watchTM),      emu.callbackType.write, 0x00212C)
emu.addMemoryCallback(safe(watchPathptr), emu.callbackType.write, PATHPTR, PATHPTR+1)
emu.addMemoryCallback(safe(watchGosub),   emu.callbackType.write, PATHGOSUBCOUNT)
emu.addMemoryCallback(safe(watchForced),  emu.callbackType.write, PATHFORCED)

-- Wide exec sampler over the main game code area
-- bank $00 $8000-$FFFF (LoROM), bank $7E (one-shot stuff lives here?), bank $7F (path engine)
emu.addMemoryCallback(safe(execSampler), emu.callbackType.exec, 0x008000, 0x00FFFF)
emu.addMemoryCallback(safe(execSampler), emu.callbackType.exec, 0x018000, 0x01FFFF)
emu.addMemoryCallback(safe(execSampler), emu.callbackType.exec, 0x7E0000, 0x7EFFFF)
emu.addMemoryCallback(safe(execSampler), emu.callbackType.exec, 0x7F0000, 0x7FFFFF)

emu.addEventCallback(safe(frameTick),   emu.eventType.endFrame)
emu.addEventCallback(safe(pcSample),    emu.eventType.startFrame)
emu.addEventCallback(safe(pcSample),    emu.eventType.endFrame)

logErr("[sf2_softlock_trace] armed.  Play through the intro until softlock.")
pcall(emu.displayMessage, "SF2", "Softlock tracer armed")
