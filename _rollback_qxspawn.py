from pathlib import Path
p = Path('SF2/PATH/PATH3DAT.ASM')
b = p.read_bytes()
old = b'\tp_qxspawn\tnullshape,nintendopresents,1,1\t; cross-bank: lives in BPATHDAT ($44)'
new = b'\tp_Qspawn\tnullshape,nintendopresents,1,1\t; ROLLBACK TEST'
n = b.count(old)
print(f'matches={n}')
assert n == 1
p.write_bytes(b.replace(old, new))
print('patched')
