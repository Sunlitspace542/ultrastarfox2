"""Re-enable .strat2 bank routing (keep nintendopresents skipped)."""
from pathlib import Path
p = Path('SF2/PATH/PATHKERN.ASM')
b = p.read_bytes()
old = (b';TEST\tlda\tal_collobjptr_obsolete,x\r\n'
       b';TEST\tbne\t.useobjectbank\r\n'
       b'\tlda\t#pathbank\r\n'
       b';TEST\t.useobjectbank\r\n')
new = (b'\tlda\tal_collobjptr_obsolete,x\r\n'
       b'\tbne\t.useobjectbank\r\n'
       b'\tlda\t#pathbank\r\n'
       b'.useobjectbank\r\n')
n = b.count(old)
print(f'matches={n}')
assert n == 1
p.write_bytes(b.replace(old, new))
print('restored: .strat2 bank routing active again')
