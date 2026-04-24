-- minimal smoke test
emu.log("hello from lua")
local f = io.open("C:\\Editor Test\\sf2_smoke.txt", "w")
f:write("script started\n")
f:close()
local n = 0
emu.addEventCallback(function()
  n = n + 1
  if n >= 60 then
    local f = io.open("C:\\Editor Test\\sf2_smoke.txt", "a")
    f:write("frame "..n.." reached\n")
    f:close()
    emu.stop(0)
  end
end, emu.eventType.endFrame)
