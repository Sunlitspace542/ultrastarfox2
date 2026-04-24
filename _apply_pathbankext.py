"""Add al_pathbankext field; route bank via it instead of al_count1."""
from pathlib import Path

# 1. STRUCTS.INC: bump limit 63->64, add defal pathbankext,1
p = Path('SF2/INC/STRUCTS.INC')
b = p.read_bytes()
old_lim = b'\tIF\tal_size>63\r\n\terror\t<Alien blocks are too large (64 bytes max)>'
new_lim = b'\tIF\tal_size>64\r\n\terror\t<Alien blocks are too large (65 bytes max)>'
assert b.count(old_lim) == 1, b.count(old_lim)
b = b.replace(old_lim, new_lim)

old_oz = b'\tdefal\toz,2\r\n\tstruct\tal_size,0\r\n'
new_oz = b'\tdefal\toz,2\r\n\tdefal\tpathbankext,1\t; per-object path bank for cross-bank execution\r\n\tstruct\tal_size,0\r\n'
assert b.count(old_oz) == 1, b.count(old_oz)
b = b.replace(old_oz, new_oz)
p.write_bytes(b)
print('STRUCTS.INC patched')

# 2. PATHKERN.ASM: replace 8 specific al_count1 sites with al_pathbankext
p = Path('SF2/PATH/PATHKERN.ASM')
b = p.read_bytes()
edits = [
    # Dispatcher
    (b'\tlda\tal_sword2,x\r\n\tsta\tpath_pcptr\r\n\ta8\r\n\tlda\tal_count1,x\r\n\tbne\t.useobjectbank\r\n\tlda\t#pathbank\r\n.useobjectbank\r\n\tsta\tpath_pcptr+2\r\n',
     b'\tlda\tal_sword2,x\r\n\tsta\tpath_pcptr\r\n\ta8\r\n\tlda\tal_pathbankext,x\r\n\tbne\t.useobjectbank\r\n\tlda\t#pathbank\r\n.useobjectbank\r\n\tsta\tpath_pcptr+2\r\n'),
    # .spawnlink path inheritance (in spawn handler before spawnlink)
    (b'\tlda\t\tal_area,x\r\n\tsta.w\t\tal_area,y\r\n\tlda\tal_count1,x\r\n\tsta.w\tal_count1,y\r\n\r\n; path map:\r\n',
     b'\tlda\t\tal_area,x\r\n\tsta.w\t\tal_area,y\r\n\tlda\tal_pathbankext,x\r\n\tsta.w\tal_pathbankext,y\r\n\r\n; path map:\r\n'),
    # .qspawn
    (b'\tlda\tal_area,x\r\n\tsta.w\tal_area,y\r\n\tlda\tal_count1,x\r\n\tsta.w\tal_count1,y\r\n\r\n\tjmp\t_padd7\r\n',
     b'\tlda\tal_area,x\r\n\tsta.w\tal_area,y\r\n\tlda\tal_pathbankext,x\r\n\tsta.w\tal_pathbankext,y\r\n\r\n\tjmp\t_padd7\r\n'),
    # .qxspawn (writes getparam 7 to al_count1,y)
    (b'\tlda\tal_area,x\r\n\tsta.w\tal_area,y\r\n\tgetparam\t7\t; per-target bank byte\r\n\tsta.w\tal_count1,y\r\n\r\n\tjmp\t_padd8\r\n',
     b'\tlda\tal_area,x\r\n\tsta.w\tal_area,y\r\n\tgetparam\t7\t; per-target bank byte\r\n\tsta.w\tal_pathbankext,y\r\n\r\n\tjmp\t_padd8\r\n'),
    # .makeit
    (b'\tlda\t\tal_area,x\r\n\tsta.w\t\tal_area,y\t; inherit mother\'s area\r\n\tlda\tal_count1,x\r\n\tsta.w\tal_count1,y\r\n',
     b'\tlda\t\tal_area,x\r\n\tsta.w\t\tal_area,y\t; inherit mother\'s area\r\n\tlda\tal_pathbankext,x\r\n\tsta.w\tal_pathbankext,y\r\n'),
]
for old, new in edits:
    n = b.count(old)
    print(f'PATHKERN: pattern (len {len(old)}) matches={n}')
    assert n == 1, f'expected 1 got {n}'
    b = b.replace(old, new)
p.write_bytes(b)

# 3. PLAYER.ASM: 1 occurrence
p = Path('SF2/ASM/PLAYER.ASM')
b = p.read_bytes()
n = b.count(b'al_count1')
print(f'PLAYER.ASM al_count1 total occurrences: {n}')
# Replace ONLY the bank routing one. Identified by surrounding context.
old = b'\ta8\r\n\tlda\tx1\r\n\tsta.w\tal_count1,y\r\n'
new = b'\ta8\r\n\tlda\tx1\r\n\tsta.w\tal_pathbankext,y\r\n'
n = b.count(old)
print(f'PLAYER.ASM bank-route matches={n}')
assert n == 1
p.write_bytes(b.replace(old, new))

# 4. WORLD.ASM: 1 occurrence (mapsetpathbdo)
p = Path('SF2/ASM/WORLD.ASM')
b = p.read_bytes()
n = b.count(b'al_count1')
print(f'WORLD.ASM al_count1 total occurrences: {n}')
# We need to find the exact one we added. Let's search context.
import re
hits = [(m.start(), m.group()) for m in re.finditer(rb'.{120}al_count1.{40}', b, re.DOTALL)]
for off, snippet in hits:
    print(f'-- @{off}:')
    print(snippet)
print('done analysis')
