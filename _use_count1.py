"""Revert STRUCTS.INC; rename al_pathbankext -> al_count1."""
from pathlib import Path

# 1. Revert STRUCTS.INC
p = Path('SF2/INC/STRUCTS.INC')
b = p.read_bytes()
new_line = b'\tdefal\toz,2\r\n\tdefal\tpathbankext,1\t; per-object path bank for cross-bank execution\r\n\tstruct\tal_size,0\r\n'
orig = b'\tdefal\toz,2\r\n\tstruct\tal_size,0\r\n'
n = b.count(new_line)
print(f'STRUCTS pathbankext line matches={n}')
assert n == 1
p.write_bytes(b.replace(new_line, orig))

# 2. Rename al_pathbankext -> al_count1 in 3 files
for path_s in ['SF2/PATH/PATHKERN.ASM', 'SF2/ASM/PLAYER.ASM', 'SF2/ASM/WORLD.ASM']:
    pp = Path(path_s)
    bb = pp.read_bytes()
    cnt = bb.count(b'al_pathbankext')
    print(f'{path_s}: {cnt} occurrences')
    pp.write_bytes(bb.replace(b'al_pathbankext', b'al_count1'))

print('done')
