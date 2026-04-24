"""Temporarily disable .strat2 bank-routing patch to isolate crash cause."""
from pathlib import Path
p = Path('SF2/PATH/PATHKERN.ASM')
b = p.read_bytes()
# original 4 lines we added, comment them out
old = (b'\tlda\tal_collobjptr_obsolete,x\r\n'
       b'\tbne\t.useobjectbank\r\n'
       b'\tlda\t#pathbank\r\n'
       b'.useobjectbank\r\n')
new = (b';TEST\tlda\tal_collobjptr_obsolete,x\r\n'
       b';TEST\tbne\t.useobjectbank\r\n'
       b'\tlda\t#pathbank\r\n'
       b';TEST\t.useobjectbank\r\n')
n = b.count(old)
print(f'matches={n}')
assert n == 1
p.write_bytes(b.replace(old, new))
print('patched: .strat2 bank routing disabled, forced pathbank')
