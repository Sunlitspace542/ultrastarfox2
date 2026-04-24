"""Bank-aware triggers + cross-bank gosub - corrected patterns."""
from pathlib import Path

# DALCS already patched; check
p = Path('SF2/INC/DALCS.INC'); b = p.read_bytes()
if b.count(b'pathtrigsavebank') == 0:
    old = b'\txalc\tpathgosubcount,1\r\n\talc\tpathparam,2\r\n'
    new = b'\txalc\tpathgosubcount,1\r\n\talc\tpathparam,2\r\n\talc\tpathtrigsavebank,1\r\n\talc\tpathx4,1\r\n'
    assert b.count(old) == 1
    p.write_bytes(b.replace(old, new))
    print('DALCS patched')
else:
    print('DALCS already has pathtrigsavebank')

# PATHKERN.ASM
p = Path('SF2/PATH/PATHKERN.ASM'); b = p.read_bytes()

def repl(old, new, label):
    global b
    n = b.count(old)
    assert n == 1, f'{label}: matches={n}'
    b = b.replace(old, new)
    print(f'{label}: ok')

repl(
    b'.gosub\tPATHCMD\r\n\tinc\tpathgosubcount\r\n\ts_mpush\t\tW,x,x,al_sword2\r\n\tjmp\t\t_pjump1\r\n',
    b'.gosub\tPATHCMD\r\n\tinc\tpathgosubcount\r\n\ts_mpush\t\tW,x,x,al_sword2\r\n\ts_mpush\t\tB,x,x,al_pathbankext\r\n\tjmp\t\t_pjump1\r\n',
    '.gosub')

repl(
    b'.gosubalvar\tPATHCMD\r\n\tinc\tpathgosubcount\r\n\r\n\taddalvaroffset\t1\r\n\ts_dec_alvar\tW,x,al_sword2\r\n\ts_mpush\t\tW,x,x,al_sword2\r\n',
    b'.gosubalvar\tPATHCMD\r\n\tinc\tpathgosubcount\r\n\r\n\taddalvaroffset\t1\r\n\ts_dec_alvar\tW,x,al_sword2\r\n\ts_mpush\t\tW,x,x,al_sword2\r\n\ts_mpush\t\tB,x,x,al_pathbankext\r\n',
    '.gosubalvar')

repl(
    b'.nottrigger\r\n\ts_mpull\t\tW,x,x,al_sword2\r\n\tjmp\t\t_padd3\r\n',
    b'.nottrigger\r\n\ts_mpull\t\tB,x,x,al_pathbankext\r\n\ts_mpull\t\tW,x,x,al_sword2\r\n\tjmp\t\t_padd3\r\n',
    '.nottrigger')

repl(
    b'\ts_mode_entry\t.qxspawn,ep_qxspawn\t; cross-bank Qspawn (added at end to preserve other mode numbers)\r\n',
    b'\ts_mode_entry\t.qxspawn,ep_qxspawn\t; cross-bank Qspawn (added at end to preserve other mode numbers)\r\n\ts_mode_entry\t.qxgosub,ep_qxgosub\t; cross-bank gosub\r\n',
    '.qxgosub mode entry')

repl(
    b'.trigalways\tPATHCMD\r\n\tstz\tpathx3\r\n\tlda\t#trigger_always\r\n\tsta\tpathy3\r\n\tjsr\t.always_in\r\n\tbrl\t_padd3\r\n',
    b'.trigalways\tPATHCMD\r\n\tstz\tpathx3\r\n\tlda\t#trigger_always\r\n\tsta\tpathy3\r\n\tgetparam\t3\r\n\tsta\tpathx4\t; bank byte\r\n\tjsr\t.always_in\r\n\tbrl\t_padd4\r\n',
    '.trigalways')

repl(
    b'.alwayscnt\r\n\tPATHCMD\r\n\tgetparam\t3\r\n\tsta\tpathy3\r\n\tgetparam\t4\r\n\tinc\ta\r\n\tsta\tpathx3\r\n\tjsr\t.always_in\r\n\tbrl\t_padd5\r\n',
    b'.alwayscnt\r\n\tPATHCMD\r\n\tgetparam\t3\r\n\tsta\tpathy3\r\n\tgetparam\t4\r\n\tinc\ta\r\n\tsta\tpathx3\r\n\tgetparam\t5\r\n\tsta\tpathx4\t; bank byte\r\n\tjsr\t.always_in\r\n\tbrl\t_padd6\r\n',
    '.alwayscnt')

repl(
    b'.always\tPATHCMD\r\n\tstz\tpathx3\r\n\tgetparam\t3\r\n\tsta\tpathy3\r\n\tjsr\t.always_in\r\n\tbrl\t_padd4\r\n',
    b'.always\tPATHCMD\r\n\tstz\tpathx3\r\n\tgetparam\t3\r\n\tsta\tpathy3\r\n\tgetparam\t4\r\n\tsta\tpathx4\t; bank byte\r\n\tjsr\t.always_in\r\n\tbrl\t_padd5\r\n',
    '.always')

repl(
    b'\ts_jmp_alvarNOTZERO\tW,x,al_stratmem,.freeit\r\n\ts_alloc\t\t\tx,y,#5\r\n\tlda\t#1\r\n\tsta\theap,y\t\t; one routine stored\r\n\ta16\r\n\tlda\tpathz3\r\n;;;;\tgetparam\t1\r\n\tsta\theap+1,y\t; store the address\r\n\ta8\r\n\tlda\tpathy3\r\n\tsta\theap+3,y\t; store trigger\r\n\tlda\tpathx3\r\n\tsta\theap+4,y\t; store the count\r\n',
    b'\ts_jmp_alvarNOTZERO\tW,x,al_stratmem,.freeit\r\n\ts_alloc\t\t\tx,y,#6\r\n\tlda\t#1\r\n\tsta\theap,y\t\t; one routine stored\r\n\ta16\r\n\tlda\tpathz3\r\n;;;;\tgetparam\t1\r\n\tsta\theap+1,y\t; store the address\r\n\ta8\r\n\tlda\tpathy3\r\n\tsta\theap+3,y\t; store trigger\r\n\tlda\tpathx3\r\n\tsta\theap+4,y\t; store the count\r\n\tlda\tpathx4\r\n\tsta\theap+5,y\t; store the bank\r\n',
    '.always_in alloc')

repl(
    b'.freeit\r\n\tldy\tal_stratmem,x\r\n\tlda\theap,y\r\n\tinc\ta\t\t; allow one more entry\r\n;;\tsta\tpathz1\r\n\tasl\ta\t\t; *4\r\n\tasl\ta\t\t; *4\r\n;;\tclc\r\n;;\tadc\tpathz1\r\n\tinc\ta\t\t; allow count byte\r\n\tsta\tpathx1\r\n\tstz\tpathx1+1\r\n',
    b'.freeit\r\n\tldy\tal_stratmem,x\r\n\tlda\theap,y\r\n\tinc\ta\t\t; allow one more entry\r\n\tsta\tpathz1\r\n\tasl\ta\t\t; *4\r\n\tasl\ta\t\t; *4 -> +pathz1 = *5\r\n\tclc\r\n\tadc\tpathz1\r\n\tinc\ta\t\t; allow count byte\r\n\tsta\tpathx1\r\n\tstz\tpathx1+1\r\n',
    '.freeit resize')

repl(
    b'.nxtcopy\r\n\tlda\theap,y\r\n\tsta\theap,x\r\n\tlda\theap+1,y\r\n\tsta\theap+1,x\t; copy address\r\n\tlda\theap+2,y\r\n\tsta\theap+2,x\t; and trigger flag\r\n\tlda\theap+3,y\r\n\tsta\theap+3,x\t; and count value\r\n\tinx\r\n\tinx\r\n\tinx\r\n\tinx\r\n\tiny\r\n\tiny\r\n\tiny\r\n\tiny\r\n\tdec\tpathx1\r\n\tbne\t.nxtcopy\r\n',
    b'.nxtcopy\r\n\tlda\theap,y\r\n\tsta\theap,x\r\n\tlda\theap+1,y\r\n\tsta\theap+1,x\t; copy address\r\n\tlda\theap+2,y\r\n\tsta\theap+2,x\t; and trigger flag\r\n\tlda\theap+3,y\r\n\tsta\theap+3,x\t; and count value\r\n\tlda\theap+4,y\r\n\tsta\theap+4,x\t; and bank\r\n\tinx\r\n\tinx\r\n\tinx\r\n\tinx\r\n\tinx\r\n\tiny\r\n\tiny\r\n\tiny\r\n\tiny\r\n\tiny\r\n\tdec\tpathx1\r\n\tbne\t.nxtcopy\r\n',
    '.nxtcopy')

repl(
    b'\ta16\r\n\tlda\tpathz3\r\n;;;;\tgetparam\t1\r\n\tldy\tpathy1\r\n\tsta\theap,y\r\n\ta8\r\n\tlda\tpathy3\r\n\tsta\theap+2,y\t; store the trigger\r\n\tlda\tpathx3\r\n\tsta\theap+3,y\t; clear the count\r\n\trts\r\n',
    b'\ta16\r\n\tlda\tpathz3\r\n;;;;\tgetparam\t1\r\n\tldy\tpathy1\r\n\tsta\theap,y\r\n\ta8\r\n\tlda\tpathy3\r\n\tsta\theap+2,y\t; store the trigger\r\n\tlda\tpathx3\r\n\tsta\theap+3,y\t; clear the count\r\n\tlda\tpathx4\r\n\tsta\theap+4,y\t; store the bank\r\n\trts\r\n',
    '.freeit last write')

repl(
    b".gosubit\r\n\tplx\r\n\tphx\r\n\r\n\tpnastyon\r\n\r\n\tstz\tpathforced\r\n\tlda\t#1\r\n\tsta\tpathgosubcount\r\n\r\n;\ta16\r\n;\tlda\t\t#-1\r\n;\ts_mpush\t\tW,x,A\t; store return address\r\n\ta16\r\n\tlda\t\theap,y\t; get gosub routine's addr\r\n\tsta\t\tal_sword2,x\r\n\ta8\r\n\tjmp\tpm.strat\t\t; do it!\r\n",
    b".gosubit\r\n\tplx\r\n\tphx\r\n\r\n\tpnastyon\r\n\r\n\tstz\tpathforced\r\n\tlda\t#1\r\n\tsta\tpathgosubcount\r\n\r\n\tlda\tal_pathbankext,x\r\n\tsta\tpathtrigsavebank\t; save current bank for restore\r\n\tlda\theap+4,y\t\t; trigger target bank\r\n\tbeq\t.notrigsetbank\t; 0 = same bank, leave alone\r\n\tsta\tal_pathbankext,x\r\n.notrigsetbank\r\n\ta16\r\n\tlda\t\theap,y\t; get gosub routine's addr\r\n\tsta\t\tal_sword2,x\r\n\ta8\r\n\tjmp\tpm.strat\t\t; do it!\r\n",
    '.gosubit')

repl(
    b'.finishedtrigger\r\n.dontgosubit\r\n\tplx\r\n',
    b'.finishedtrigger\r\n\tlda\tpathtrigsavebank\r\n\tsta\tal_pathbankext,x\r\n.dontgosubit\r\n\tplx\r\n',
    '.finishedtrigger')

repl(
    b'.nxtone\r\n\tldy\ttriggerloopptr\r\n\tiny\r\n\tiny\r\n\tiny\r\n\tiny\r\n\ta8\r\n\tlda\ttriggerloopcnt\r\n',
    b'.nxtone\r\n\tldy\ttriggerloopptr\r\n\tiny\r\n\tiny\r\n\tiny\r\n\tiny\r\n\tiny\r\n\ta8\r\n\tlda\ttriggerloopcnt\r\n',
    '.nxtone iny')

repl(
    b'.qxcantdo\ts_pull_var\tW,allst\r\n\tjmp\t_padd8\r\n',
    b'.qxcantdo\ts_pull_var\tW,allst\r\n\tjmp\t_padd8\r\n\r\n;**********\r\n.qxgosub\tPATHCMD\r\n\tinc\tpathgosubcount\r\n\ts_mpush\t\tW,x,x,al_sword2\r\n\ts_mpush\t\tB,x,x,al_pathbankext\r\n\ta8\r\n\tgetparam\t3\r\n\tsta\tal_pathbankext,x\r\n\ta16\r\n\tgetparam\t1\r\n\tsta\tal_sword2,x\r\n\ta8\r\n\tjmp\tpm.strat2\r\n',
    '.qxgosub handler')

p.write_bytes(b)
print('PATHKERN.ASM patched')

# PATHMACS.INC
p = Path('SF2/INC/PATHMACS.INC'); b = p.read_bytes()

def repl2(old, new, label):
    global b
    n = b.count(old)
    assert n == 1, f'{label}: matches={n}'
    b = b.replace(old, new)
    print(f'{label}: ok')

repl2(
    b'P_GOSUB\t\tMACRO\t[addr]\r\n\tpathmac_start\r\nMYNARG\t=\tNARG\r\n\tPNARG\t1\r\n\tIFD\tal_{addr}\r\n\tPCHKSIZE\t{addr},2\r\n\tpathcode\tgosubalvar\r\n\tPALVAROFFSET\t{addr}\r\n\tELSEIF\r\n\tpathcode\tgosub\r\n\tPADDR\t{addr}\r\n\tENDC\r\n\tpathmac_end\r\n\t\tENDM\r\n',
    b'P_GOSUB\t\tMACRO\t[addr]\r\n\tpathmac_start\r\nMYNARG\t=\tNARG\r\n\tPNARG\t1\r\n\tIFD\tal_{addr}\r\n\tPCHKSIZE\t{addr},2\r\n\tpathcode\tgosubalvar\r\n\tPALVAROFFSET\t{addr}\r\n\tELSEIF\r\n\tpathcode\tgosub\r\n\tPADDR\t{addr}\r\n\tENDC\r\n\tpathmac_end\r\n\t\tENDM\r\n;--------------------------------------------------------------------\r\n; cross-bank gosub: includes target path bank byte\r\nP_QXGOSUB\tMACRO\t[addr]\r\n\tpathmac_start\r\nMYNARG\t=\tNARG\r\n\tPNARG\t1\r\n\tpathcode\tqxgosub\r\n\tPADDR\t{addr}\r\n\tdb\tpathbank_{addr}\r\n\tpathmac_end\r\n\t\tENDM\r\n',
    'P_QXGOSUB macro')

repl2(
    b'\tIFEQ\tMYNARG-2\r\n\tIFEQ\ttrigger_always-trigger_{trigger}\r\n\tpathcode\ttrigalways\r\n\tPADDR\t{addr}\r\n\tELSEIF\r\n\tpathcode\talways\r\n\tPADDR\t{addr}\r\n\tdb\ttrigger_{trigger}\r\n\tENDC\r\n\tELSEIF\r\n\r\n\tpathcode\talwayscnt\r\n\tPADDR\t{addr}\r\n\tdb\ttrigger_{trigger}\r\n\tdb\t{cnt}\r\n\tENDC\r\n',
    b'\tIFEQ\tMYNARG-2\r\n\tIFEQ\ttrigger_always-trigger_{trigger}\r\n\tpathcode\ttrigalways\r\n\tPADDR\t{addr}\r\n\tdb\tpathbank_{addr}\r\n\tELSEIF\r\n\tpathcode\talways\r\n\tPADDR\t{addr}\r\n\tdb\ttrigger_{trigger}\r\n\tdb\tpathbank_{addr}\r\n\tENDC\r\n\tELSEIF\r\n\r\n\tpathcode\talwayscnt\r\n\tPADDR\t{addr}\r\n\tdb\ttrigger_{trigger}\r\n\tdb\t{cnt}\r\n\tdb\tpathbank_{addr}\r\n\tENDC\r\n',
    'P_TRIGGER macro')

p.write_bytes(b)
print('PATHMACS.INC patched')

# PATHKERN.EXT
p = Path('SF2/EXT/PATHKERN.EXT'); b = p.read_bytes()
if b'ep_qxgosub' not in b:
    old = b'\tglobal\tep_qxspawn\r\n'
    new = b'\tglobal\tep_qxspawn\r\n\tglobal\tep_qxgosub\r\n'
    assert b.count(old) == 1
    p.write_bytes(b.replace(old, new))
    print('PATHKERN.EXT patched')

# PATH3DAT.ASM
p = Path('SF2/PATH/PATH3DAT.ASM'); b = p.read_bytes()
n = b.count(b'p_gosub\tPes0_cam.pos')
print(f'PATH3DAT cross-bank gosubs: {n}')
b = b.replace(b'p_gosub\tPes0_cam.pos', b'p_qxgosub\tPes0_cam.pos')
p.write_bytes(b)

print('done')
