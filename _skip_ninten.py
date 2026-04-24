"""Skip nintendopresents Qspawn entirely - test if path execution itself is the crash."""
from pathlib import Path
p = Path('SF2/PATH/PATH3DAT.ASM')
b = p.read_bytes()
old = b'\tp_Qspawn\tnullshape,nintendopresents,1,1\t; ROLLBACK TEST'
new = b';SKIP\tp_Qspawn\tnullshape,nintendopresents,1,1\t; SKIPPED FOR TEST'
n = b.count(old)
print(f'matches={n}')
assert n == 1
p.write_bytes(b.replace(old, new))
print('patched: nintendopresents Qspawn commented out')
