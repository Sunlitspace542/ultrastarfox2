"""Add al_pathbankext field; rename al_collobjptr_obsolete -> al_pathbankext in patched code; restore nintendopresents qxspawn."""
from pathlib import Path

# 1. STRUCTS.INC: add new field before `struct al_size,0`
p = Path('SF2/INC/STRUCTS.INC')
b = p.read_bytes()
old = b'\tdefal\toz,2\r\n\tstruct\tal_size,0\r\n'
new = b'\tdefal\toz,2\r\n\tdefal\tpathbankext,1\t; per-object path bank for cross-bank execution\r\n\tstruct\tal_size,0\r\n'
n = b.count(old)
print(f'STRUCTS old matches={n}')
assert n == 1
p.write_bytes(b.replace(old, new))

# 2. Rename al_collobjptr_obsolete -> al_pathbankext in 3 files
for path_s in ['SF2/PATH/PATHKERN.ASM', 'SF2/ASM/PLAYER.ASM', 'SF2/ASM/WORLD.ASM']:
    pp = Path(path_s)
    bb = pp.read_bytes()
    cnt = bb.count(b'al_collobjptr_obsolete')
    print(f'{path_s}: {cnt} occurrences')
    pp.write_bytes(bb.replace(b'al_collobjptr_obsolete', b'al_pathbankext'))

# 3. Restore nintendopresents qxspawn in PATH3DAT.ASM
p3 = Path('SF2/PATH/PATH3DAT.ASM')
b3 = p3.read_bytes()
old3 = b';SKIP\tp_Qspawn\tnullshape,nintendopresents,1,1\t; SKIPPED FOR TEST'
new3 = b'\tp_qxspawn\tnullshape,nintendopresents,1,1\t; cross-bank: lives in BPATHDAT ($44)'
n3 = b3.count(old3)
print(f'PATH3DAT skip matches={n3}')
assert n3 == 1
p3.write_bytes(b3.replace(old3, new3))

print('done')
