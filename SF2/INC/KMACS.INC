;*********************************************************************
;*								*
;*		Kawaguchi MACRO Definition			*
;* FILE:		KMACS.INC					*
;* AUTHOR:		YASUHIRO KAWAGUCHI				*
;* DATE CREATED:	7-5-1993					*
;*********************************************************************
;=====================================================================
;*			SASM Macros				*
;=====================================================================
dl	macro	[address]
	dw	({address})&WM
	db	({address})>>16
	endm

;=====================================================================
;*		Memory Macros					*
;=====================================================================
;*** Memory Allocate ***
;km_zalc		macro	[label,size]
;km_alc		macro	[label,size]
;km_xalc		macro	[label,size]
;km_xxalc		macro	[label,size]
;km_malc		macro	[label,size]

;**** Label & Flag Macros ***
;km_alclabel		macro	[label]		;kw_label	equ	wmempt
;km_alclabelstart	macro	[label]		;kw_labelSTART	equ	wmempt
;km_alclabelend	macro	[label]		;kw_labelEND	equ	wmempt
;km_xalclabel	macro	[label]		;kx_label	equ	xmempt
;km_xalclabelstart	macro	[label]		;kx_labelSTART	equ	xmempt
;km_xalclabelend	macro	[label]		;kx_labelEND	equ	xmempt
;km_malclabel	macro	[label]		;km_label	equ	mmempt
;km_malclabelstart	macro	[label]		;km_labelSTART	equ	mmempt
;km_malclabelend	macro	[label]		;km_labelEND	equ	mmempt

;km_labelstart	macro	([numlab])	;$ = 0 or (number or label)
;km_label		macro	[name,(size)]	;name	equ 0,1,2,...
;km_labellen		macro	[label]		;label	equ length

;km_flagstart	macro	([num])		;$ = 0,1,2,3,4,5,...
;km_flag		macro	[name]		;name	equ	1<<$

;km_gmlabelstart	macro	[codename,(startnum)]	;$ = 0 or (number or label)
;km_gmlabel		macro	[name,(step)]		;name	equ	0,1,2,...
;km_gmlabellen	macro	[label]			;label	equ	list length

;km_gmflagstart	macro	[codename,(startnum)]	;$ = 0 or (number or label)
;km_gmflag		macro	[name,(step)]		;name	equ	1,2,4,8,...

;km_worklabel	macro	[size,label]	;size ... B/W
;km_workgroup	macro	[size,label]
;km_worklabelstart	macro	[base]	;base = number or label
;km_worklabellen	macro	[label]	;label equ length
;km_worklabelend	macro	[base]
;km_workvalcheck	macro	[max]
;km_worksizestart	macro
;km_worksize		macro	[label]
;km_workstart	macro	[topname,base]	;[kw,kxwork]
;km_work		macro	[name,len]	;[name,10]

;****** Data Macro ********
;km_datasize	macro	[label]		  ;1 unit data size
;km_datacnt	macro	[size,startlabel] ;size = Byte/Word :counter wo fukumanai data length
;km_datalen	macro	[label]		  ;{label}LEN equ {label}END-{label} :Data Length
;*** MEMORY MODE CHECK ***
;km_memcheck		macro
;km_memchecka8	macro
;km_memchecki16	macro
;km_memchecka8i8	macro
;km_memchecka8i16	macro
;km_memchecka16	macro
;km_memchecka16i8	macro
;km_memchecka16i16	macro

;*** MEMORY MODE CHANGE (If need) ****
;km_CHG_MODE		macro	[size]	;Byte/Word :Mem mode change
;km_CHG_MODEBACK	macro		;Return Mem mode

;km_chga8		macro	;moshi hituyounara a8  ni suru
;km_chga16		macro	;moshi hituyounara a16 ni suru
;km_reta8		macro	;moshi hituyounara a8  ni modosu
;km_reta16		macro	;moshi hituyounara a16 ni modosu

;km_chgi8		macro	;moshi hituyounara i8  ni suru
;km_chgi16		macro	;moshi hituyounara i16 ni suru
;km_reti8		macro	;moshi hituyounara i8  ni modosu
;km_reti16		macro	;moshi hituyounara i16 ni modosu

;km_chkly	macro
;*** Register PUSH & PULL ****
;km_PUSHAllReg		macro
;km_PULLAllReg		macro

;=====================================================================
;*			Debug Macros				*
;=====================================================================
;kbug1	macro	:7f ffff <--- 1
;kbug2	macro	:7f ffff <--- 2
;kbug3	macro	:7f ffff <--- 3
;kbug4	macro	:7f ffff <--- 4
;kbug5	macro	:7f ffff <--- 5
;kbug6	macro	:7f ffff <--- 6
;kbug7	macro	:7f ffff <--- 7
;kbug8	macro	:7f ffff <--- 8
;kbug9	macro	:7f ffff <--- 9

;km_blink		macro
;km_nastycheck

;kprintD		macro	[x,y]
;km_printByte	macro	[x,y]
;km_printBinary	macro	[x,y]

;=====================================================================
;*		Special	Debug Command				*
;=====================================================================
;km_Debug_reset	macro

;=====================================================================
;*			RAM Work Macros				*
;=====================================================================

;km_clralc		macro	[addr]		;work 0 RAM clear
;km_clrxalc		macro	[addr]		;work 0 RAM clear
;km_clrWRAM		macro	[addr,len]	;work 0 RAM clear
;km_clrKAWARAM	macro			;kawaguchi work RAM clear

;km_DRAMCLEAR	macro	[address,value]

;=====================================================================
;*			General Macros				*
;=====================================================================
;* WARNING :kono MACRO wa hokano MACRO no nakadewa tukaenai *
;db0	macro	:data bank <--- 0	;(In 8 bit mode) :Acc Not Keep
;db7e	macro	:data bank <--- 7e	;(In 8 bit mode) :Acc Not Keep
;db7f	macro	:data bank <--- 7f	;(In 8 bit mode) :Acc Not Keep

;km_db0	macro	:data bank <--- 0	;(save mode) :Acc Keep
;km_db7e	macro	:data bank <--- 7e	;(save mode) :Acc Keep
;km_db7f	macro	:data bank <--- 7f	;(save mode) :Acc Keep
;----------------------------------------------------------------------------
;asr		macro	{A}	;Acc <--- Acc/2 (fugou ari)
;km_hib0		macro		;Acc (Hi Byte <-- 0)
;km_loba		macro		;Acc <--- Acc (HI  Byte =0)
;km_hiba		macro		;Acc <--- Acc (Low Byte =0)
;km_lobswapa		macro		;Acc <--- Acc (HI  <-- Low, Low Byte =0)
;km_hibswapa		macro		;Acc <--- Acc (Low <-- HI , HI  Byte =0)
;km_sexa		macro		;Acc wo fugou kakutyou
;km_asra		macro		;Acc <--- Acc/2 (fugou ari)
;km_nega		macro		;Acc <---  - Acc
;km_andcmpval	macro	[val]	;Acc cmp #val (Acc <--- Acc&#val)

;km_loblda		macro	[var,(reg)]	;Acc <--- var (Hi byte = 0)
;km_hiblda		macro	[var,(reg)]	;Acc <--- var (Low Byte =0)
;km_lobswaplda	macro	[var,(reg)]	;Acc <--- var (HI <-- Low,Low Byte =0)
;km_hibswaplda	macro	[var,(reg)]	;Acc <--- var (Low<-- Hi ,HI  Byte =0)
;km_ldasla		macro	[var,(reg)]	;Acc <--- var *2 (16bit)
;km_lldasla		macro	[var,(reg)]	;Acc <--- var *2 (16bit <-- 8bit)
;km_sexvar		macro	[var,(reg)]	;Acc <--- var (fugou kakutyou)
;km_addvar		macro	[var,addvar]	;Acc <--- var+addvar
;km_addval		macro	[var,val,(reg)]	;Acc <--- var+#val
;km_subvar		macro	[var,subvar,(reg)]	;Acc <--- var-subvar
;km_abssubvar	macro	[var,subvar,(reg)]	;Acc <--- �var-subvar�
;km_subval		macro	[var,val,(reg)]	;Acc <--- var-#val

;km_cmpvarval	macro	[var,val,(reg)]	;Var cmp #val
;km_andcmpvarval	macro	[var,val,(reg)]	;Var andcmp #val

;km_lobsta		macro	[var,(reg)]	;var <--- Acc (Hi byte = 0)
;km_hibsta		macro	[var,(reg)]	;var <--- Acc (Low byte = 0)
;km_lobswapsta	macro	[var,(reg)]	;var <--- Acc (HI <-- Low,Low byte = 0)
;km_hibswapsta	macro	[var,(reg)]	;var <--- Acc (Low<-- Hi,Hi byte = 0)

;km_setval(km_staval)macro	[var,val,(reg)]	;var <--- lda #val
;km_stxval		macro	[var,val]	;var <--- ldx #val
;km_styval		macro	[var,val]	;var <--- ldy #val

;km_setvar(km_stavar)macro	[dest,(sour)]	;var <--- lda	var
;km_stxvar		macro	[dest,(sour)]	;var <--- ldx	var
;km_styvar		macro	[dest,(sour)]	;var <--- ldy	var
;km_lobstavar	macro	[dest,(sour)]	;var <--- lda var (Hi byte = 0)
;km_hibstavar	macro	[dest,(sour)]	;var <--- lda var (Low byte = 0)
;km_lobswapstavar	macro	[dest,(sour)]	;var <--- lda var (HI <-- Low,Low byte = 0)
;km_hibswapstavar	macro	[dest,(sour)]	;var <--- lda var (Low<-- Hi,Hi byte = 0)
;km_sexstavar	macro	[dest,(sour)]	;var <--- lda var (fugou kakutyou)
;km_negstavar	macro	[dest,(sour)]	;var = -(var)
;km_negstavar	macro	[dest,(sour)]	;var <--- neg var
;km_negswapsta	macro	[dest,(sour)]	:(var,var+1) = -(var+1,var) 
;km_absstavar	macro	[dest,(sour)]	;var <--- �var�
;km_aslsta		macro	[dest,(sour)]	;var <--- var*2
;km_lsrsta		macro	[dest,(sour)]	;var <--- var/2

;km_addstavarvar 	macro	[dest,addvar,(sour)]	;var <--- var+addvar
;km_substavarvar	macro	[dest,subvar,(sour)]	;var <--- var+subvar
;km_addstavarval 	macro	[dest,addval,(sour)]	;var <--- var+#addval
;km_substavarval	macro	[dest,subval,(sour)]	;var <--- var+#subval

;km_addstaval	macro	[var,val,(reg)]		;var <--- var+#val
;km_substaval	macro	[var,val,(reg)]		;var <--- var-#val
;km_orastaval	macro	[var,val,(reg)]		;var <--- var or #val

;km_addmax (!)	macro	[var,val,max,(reg)]	;var <--- var+#val (until var = max) :(val no atai ni kiotukete!!)
;km_addgtumax	macro	[var,val,max,(reg)]	;var <--- var+#val (if var > max then var = max) :(unsin)
;km_addgtsmax	macro	[var,val,max,(reg)]	;var <--- var+#val (if var > max then var = max) :(sin)
;km_addmaxtomin	macro	[var,val,max,min]	;var <--- var+#val (if var  = max then var = min)
;km_addgeumaxtomin	macro	[var,val,max,min]	;var <--- var+#val (if var >= max then var = min) :(unsin)
;km_addgesmaxtomin	macro	[var,val,max,min]	;var <--- var+#val (if var >= max then var = min) :(sin)
;km_subvarto0	macro	[var,(reg)]		;var <--- var-1 (until var = 0)
;km_submin (!)	macro	[var,val,(min)]		;var <--- var-#val (until var = min) ,if (min) = 0
;km_subltumin	macro	[var,val,min]		;var <--- var-#val (if var < min then var = min) :(unsin)
;km_substavarltsmin	macro	[var,var2,min]		;var <--- var-var2 (if var < min then var = min) :(sin)
;km_substavalltsmin	macro	[var,val,min]		;var <--- var-#val (if var < min then var = min) :(sin)
;km_submintomax   	macro [var,val,min,max]		;var <--- var-#val (if var = min then var = max)
;km_subltumintomax	macro [var,val,min,max]		;var <--- var-#val (if var < min then var = max) :(unsin)
;km_subltsmintomax	macro [var,val,min,max]		;var <--- var-#val (if var < min then var = max) :(sin)

;km_aslreg	macro	[reg]			;Reg  <---- Acc*2

;km_lldx	macro	[work]			;X reg <--- work(8bit)
;km_lldy	macro	[work]			;Y reg <--- work(8bit)
;km_ldatbl_i8x	macro	[tbl,ptr]	;Acc <--- tbl,x (x = ptr:8bit)

;km_ldaslx	macro	[var,(reg)]		;X reg <--- work(16bit)*2
;km_lldaslx	macro	[var,(reg)]		;X reg <--- work(8bit)*2
;km_lldm4x	macro	[var,(reg)]		;X reg <--- work(8bit)*4
;km_ldasly	macro	[var,(reg)]		;Y reg <--- work(16bit)*2
;km_lldasly	macro	[var,(reg)]		;Y reg <--- work(8bit)*2

;km_bne	macro	[addr]			;long jump
;km_beq	macro	[addr]			;long jump
;km_bpl	macro	[addr]			;long jump
;km_bmi	macro	[addr]			;long jump
;km_bcc	macro	[addr]			;long jump
;km_bcs	macro	[addr]			;long jump

;km_setflag		macro	[var,flag,(reg)]	;VAR <---VAR  ORA #FLAG
;km_setflag8		macro	[var,flag,(reg)]	;VAR <---VAR  ORA #FLAG
;km_setflag16	macro	[var,flag,(reg)]	;VAR <---VAR  ORA #FLAG
;km_andflag		macro	[var,flag,(reg)]	;VAR <---VAR  AND #FLAG
;km_eorflag		macro	[var,flag,(reg)]	;VAR <---VAR  EOR #FLAG
;km_eorflag16	macro	[var,flag,(reg)]	;VAR <---VAR  EOR #FLAG
;km_clrflag		macro	[var,flag,(reg)]	;VAR <---VAR  AND #FLAG^(-1)
;km_clrflag16	macro	[var,flag,(reg)];VAR <---VAR  AND #FLAG^(-1)

;km_bitcheck		macro	[var,val,(reg)]		;VAR bit #VAL	(beq/bne)
;km_bitcheckflag	macro	[var,flag,(reg)]	;VAR BIT #FLAG
;km_bitcheckflag16	macro	[var,flag,(reg)]	;VAR BIT #FLAG
;km_andcmpcheck	macro	[var,flags,(reg)]	;VAR BIT #FLAGS
;km_andcmpcheckflag	macro	[var,flags,(reg)]	;VAR BIT #FLAGS
;km_cmpcheck		macro	[var,val,(reg)]		;VAR cmp #VAL	(beq/bne)
;km_cmpcheckval	macro	[var,val,(reg)]		;VAR cmp #VAL	(beq/bne)
;km_cmpcheckflag	macro	[var,flag,(reg)]	;VAR CMP #FLAG
;km_andcheckflag 	macro	[var,flag,(reg)]	;VAR AND #FLAG

;km_checknotflag	macro	[var,flag,(reg)]	;VAR AND #VAL^(-1)
;km_bitchecknotflag	macro	[var,flag,(reg)]	;VAR BIT #VAL^(-1)
;km_cmpchecknotflag	macro	[var,flag,(reg)]	;VAR CMP #FLAG^(-1)

;km_jmpflag		macro	[var,flag,jmp_adr,(reg)];jump addr {VAR AND #VAL = not 0}
;km_jmpnotflag	macro	[var,flag,jmp_adr,(reg)];jump addr {VAR AND #VAL = 0}
;km_jmpflag_a	macro	[flag,jmp_adr]		;jump addr {Acc AND #VAL = not 0}
;km_jmpnotflag_a	macro	[flag_val,jmp_adr]	;jump addr {Acc AND #VAL = not 0}

;* Heap Ram sub routine call *
;km_jmpind		macro	[addr,reg]		;jmp (addr,x),jmp (addr,y)
;km_jsr		macro	[addr]			;jsr addr
;km_jsrind		macro	[addr,reg]		;jsr (addr,x),jmp (addr,y)
;km_jsl		macro	[addr]			;jsl addr

;km_braareaout	macro	[(#)min,(#)max,addr]
;km_brlareaout	macro	[(#)min,(#)max,addr]

;km_fdecsta_alvar	macro	[size,obj1,alvar,flag]
;km_fdec_alvar	macro	[size,obj1,alvar,flag]
;km_fdecbne_alvar	macro	[size,obj1,alvar,flag,addr]
;----------------------------------------------------------------------------
;* DATA TENSOU *
;BlockCopy		macro	[size,source,dest]	;Loop de tada STA surudake!!
;BlockCopyOffset	macro	[sizesource,dest,hosei]

;km_mvn		macro	[moto,saki]
;km_blocktrans	macro	[source_adr,dest_adr,trans_value]
;km_blocktransX	macro	[sourcebase,dest,trans_value]
;km_blocktransY	macro	[source,destbase,trans_value]
;km_blocktransXY	macro	[sourcebase,destbase,trans_value]
;blocktrans_sub	macro	[source_adr,dest_adr,trans_value]

;=====================================================================
;*			GAME Macros				*
;=====================================================================
;*********** game mode ************
;km_gamemodelist	macro			;kmodept = 0
;km_gamemode		macro	[addr]		;jump_{addr},screen_{addr},sound_{addr},ksf_{addr}

;* imwa tukatteinai *
;km_gameptr		macro	[addr]		;kmode_{addr}:(sequence pointer)
;km_gamescreenmode	macro	[addr]		;dw screen_{addr}&WM
;km_gamesoundmode	macro	[flag]		;db ksf_{flag}

;km_ldagamemode	macro			;Acc  <--- kw_GameMode
;km_stagamemode	macro	(Acc)		;kw_GameMode <--- Acc
;km_stagamemode_NoFl	macro	(Acc)		;kw_GameMode <--- Acc,syorigae nashi
;km_setgamemode	macro	[flag]		;kw_GameMode <--- #[flag]
;km_cmpcheckgamemode	macro	[flag]		;kw_GameMode cmp #flag

;km_statmpgamemode	macro	(Acc)		;kw_TmpGameMode <--- Acc
;km_settmpgamemode	macro	[flag]		;kw_TmpGameMode <--- #[flag]
;km_setnextgamemode	macro			;kw_GameMode <--- kw_TmpGameMode
;km_setsndmode	macro			;kw_setsndaddr <--- snd table address

;km_ldxgamemode	macro			;Xreg <--- kw_GameMode
;km_ldygamemode	macro			;Yreg <--- kw_GameMode
;km_ldxaslgamemode	macro			;Xreg <--- kw_GameMode*2
;km_ldyaslgamemode	macro			;Yreg <--- kw_GameMode*2

;km_ldxsequenceptr	macro			;Xreg <--- kw_GameMode*6
;km_ldxsoundtblptr	macro			;Xreg <--- kgamesequence+4,x

;km_setgamestage	macro	[label]		;KGameMapPtr <--- Stage No

;km_setgamesyori	macro	[flag]		;kw_GameSyori <--- flag
;(kw_GameSyori) :0.. rts
;	   :1.. main
;	   :2.. pause
;km_cmpcheckgamesyori macro	[flag]		;kw_GameSyori cmp #{flag}
;km_ldaslxgamesyori	macro			;Xreg <--- kw_GameSyori*2
;km_statmpgamesyori	macro	(Acc)		;kw_TmpGameSyori <--- Acc
;km_settmpgamesyori	macro	[flag]		;kw_TmpGameSyori <--- #[flag]
;km_setnextgamesyori	macro			;kw_GameSyori <--- kw_TmpGameSyori
;km_pushgamesyori	macro			;kw_TmpGameSyori <--- kw_GameSyori
;km_pullgamesyori	macro			;kw_GameSyori    <--- kw_TmpGameSyori

;*** demo ***
;km_setdemonumber		macro	[label]
;km_cmpcheckdemonumber	macro	[label]

;*** Total Flag ***
;km_settotalflag		macro	[flag]		;kw_totalflag <--- [flag] on
;km_clrtotalflag		macro	[flag]		;kw_totalflag <--- [flag] off
;km_eortotalflag		macro	[flag]		;kw_totalflag <--- [flag] eor #flag
;km_bitchecktotalflag	macro	[flag]		;kw_totalflag

;*** mission total flag *
;km_setmistotalflag		macro	[flag]		;kw_mistotalflag <--- [flag] on
;km_clrmsitotalflag		macro	[flag]		;kw_mistotalflag <--- [flag] off
;km_eormistotalflag		macro	[flag]		;kw_mistotalflag <--- [flag] eor #flag
;km_bitcheckmistotalflag	macro	[flag]		;kw_mistotalflag

;*** game main ***
;km_gameflptr	macro	[flag]		;kgf_[flag]

;km_setgameflag	macro	[flag]		;kw_gameflag <--- [flag] on
;km_clrgameflag	macro	[flag]		;kw_gameflag <--- [flag] off
;km_eorgameflag	macro	[flag]		;kw_gameflag <--- [flag] eor #flag
;km_bitcheckgameflag	macro	[flag]		;kw_gameflag
;km_jmpgameflag	macro	[flag,jmp_adr]
;km_jmpnotgameflag	macro	[flag,jmp_adr]

;****** MissionMap *******
;km_setmismapsyori	macro	[syori]		;kw_MisMapSyori <--- syori
;(kw_MisMapSyori) :0.. demo 
;	     :1.. main
;	     :2.. replay
;km_cmpcheckmismapsyori macro	[syori]		;kw_MisMapSyori cmp #{syori}

;km_setmismapflag	macro	[flag]		;kw_mismapflag <--- [flag] on
;km_clrmismapflag	macro	[flag]		;kw_mismapflag <--- [flag] off
;km_eormismapflag	macro	[flag]		;kw_mismapflag <--- [flag] eor #flag
;km_bitcheckmismapflag	macro	[flag]

;km_setmismapflag2	macro	[flag]		;kw_mismapflag2 <--- [flag] on
;km_clrmismapfla2	macro	[flag]		;kw_mismapflag2 <--- [flag] off
;km_eormismapfla2	macro	[flag]		;kw_mismapflag2 <--- [flag] eor #flag
;km_bitcheckmismapflag2	macro	[flag]

;km_setmismapfzflag	macro	[flag]		;kw_mismapfreezeflag <--- [flag] on
;km_clrmismapfzflag	macro	[flag]		;kw_mismapfreezeflag <--- [flag] off
;km_eormismapfzflag	macro	[flag]		;kw_mismapfreezeflag <--- [flag] eor #flag
;km_bitcheckmismapfzflag	macro	[flag]

;km_setmismapevflag	macro	[flag]		;kw_MisMapEventFlag <--- [flag] on
;km_clrmismapevflag	macro	[flag]		;kw_MisMapEventFlag <--- [flag] off
;km_eormismapevflag	macro	[flag]		;kw_MisMapEventFlag <--- [flag] eor #flag
;km_bitcheckmimapevflag	macro	[flag]

;km_setmismapstflag	macro	[flag]		;kw_mismapstateflag <--- [flag] on
;km_clrmismapstflag	macro	[flag]		;kw_mismapstateflag <--- [flag] off
;km_eormismapstflag	macro	[flag]		;kw_mismapstateflag <--- [flag] eor #flag
;km_bitcheckmismapstflag	macro	[flag]

;km_setmismaptrflag	macro	[flag]		;kx_MisMapTriggerFlag <--- [flag] on
;km_clrmismaptrflag	macro	[flag]		;kx_MisMapTriggerFlag <--- [flag] off
;km_eormismaptrflag	macro	[flag]		;kx_MisMapTriggerFlag <--- [flag] eor #flag
;km_bitcheckmismaptrflag	macro	[flag]

;km_setmismapchflag	macro	[flag]		;kx_MisMapChartFlag <--- [flag] on
;km_clrmismapchflag	macro	[flag]		;kx_MisMapChartFlag <--- [flag] off
;km_eormismapchflag	macro	[flag]		;kx_MisMapChartFlag <--- [flag] eor #flag
;km_bitcheckmismapchflag	macro	[flag]

;km_setmismapdemoflag	macro	[flag]		;kw_mismapdemoflag <--- [flag] on
;km_clrmismapdemoflag	macro	[flag]		;kw_mismapdemoflag <--- [flag] off
;km_eormismapdemoflag	macro	[flag]		;kw_mismapdemoflag <--- [flag] eor #flag
;km_bitcheckmismapdemoflag	macro	[flag]

;km_setplanetflag	macro	[flag,reg]
;km_clrplanetflag	macro	[flag,reg]
;km_setenemyflag	macro	[flag,reg]
;km_clrenemyflag	macro	[flag,reg]

;km_setstepupmode	macro	[mode,reg]
;km_incstepupmode	macro	[reg]
;km_setsosmode	macro	[mode,reg]
;km_incsosmode	macro	[reg]

;*** mission ***
;km_setmisionsyori	macro	[flag]		;kw_MissionSyori <--- label

;km_setmissionflag	macro	[flag]		;kw_missionflag <--- [flag] on
;km_clrmissionflag	macro	[flag]		;kw_missionflag <--- [flag] off
;km_eormissionflag	macro	[flag]		;kw_missionflag <--- [flag] eor #flag
;km_bitcheckmissionflag	macro	[flag]	;kw_missionflag
;km_jmpmissionflag	macro	[flag,jmp_adr]
;km_jmpnotmissionflag	macro	[flag,jmp_adr]

;*** battle ***
;km_setbattlesyori	macro	[flag]		;kw_BattleSyori <--- label

;km_setbattleflag	macro	[flag]		;kw_battleflag <--- [flag] on
;km_clrbattleflag	macro	[flag]		;kw_battleflag <--- [flag] off
;km_eormssionflag	macro	[flag]		;kw_battleflag <--- [flag] eor #flag
;km_bitcheckbattleflag	macro	[flag]	;kw_battleflag
;km_jmpbattleflag	macro	[flag,jmp_adr]
;km_jmpnotbattleflag	macro	[flag,jmp_adr]

;km_setgameoverflag		macro	[flag]	;kgameover <--- [flag] on
;km_clrgameoverflag		macro	[flag]	;kgameover <--- [flag] off
;km_eorgameoverflag		macro	[flag]	;kgameover <--- [flag] eor #flag
;km_bitcheckgameoverflag	macro	[flag]	;kgameover bit #[flag]

;km_setgamestage	macro	[stage]		;kgamestage <--- [stage] & flag 
;km_stagamestage	macro	[stage]		;kgamestage <--- Acc
;-------------------------------------------------------------------------
;******** Display (screen) Flag *******
;km_ldascreenflag	macro	[flag]		;Acc <---- kw_screenflag
;km_setscreenflag	macro	[flag]		;kw_screenflag <-- bit set
;km_clrscreenflag	macro	[flag]		;kw_screenflag <-- bit clear
;km_eorscreenflag	macro	[flag]		;kw_screenflag <--- [flag] eor #flag
;km_bitcheckscreenflag	macro	[flag]	;kscreen mode no bit check
;km_jmpscreenflag	macro	[flag,jmp_adr]
;km_jmpnotscreenflag	macro	[flag,jmp_adr]

;********** window flag ***************
;km_setwindowflag	macro	[flag]		;kw_windowflag <-- bit set
;km_clrwindowflag	macro	[flag]		;kw_windowflag <-- bit clear
;km_eorwindowflag	macro	[flag]		;kw_windowflag <--- [flag] eor #flag
;km_bitcheckwindowflag	macro	[flag]	;kwindow mode no bit check

;********** Sound Flag ****************
;km_setsndflag	macro	[flag]		;kw_soundflag <-- #ksf_flag 
;km_clrsndflag	macro	[flag]		;kw_soundflag <-- (#ksf_flag)^
;km_bitchecksndflag	macro	[flag]
;********** sprites ***********
;(Entry:mission,battle,selectbattlefield,selectbattleplayer)
;km_spriteptrlist	macro			;ksprpt = 0
;km_gamespritemode	macro	[addr]		;dw sprites_{addr}_l&WM
;km_ldxspritemode	macro			;Xreg <--- kw_spritemode*2
;km_setspritemode	macro	[flag]		;kw_spritemode <--- #[flag]
;km_pushspritemode	macro			;kw_TmpGameSyori <--- kw_GameSyori
;km_pullspritemode	macro			;kw_GameSyori    <--- kw_TmpGameSyori

;*********** screen ***************
;(ENTRY :hvscroll,colpalchange)
;km_screenptrlist	macro			;ksprpt = 0
;km_gamescreenmode	macro	[addr]		;dw screens_{addr}_l&WM
;km_ldxscreenmode	macro			;Xreg <--- kscreensmode*2
;km_setscreenmode	macro	[flag]		;kscreensmode <--- #[flag]

;************ player **************
;km_lda_playertype	macro	[player]
;km_sta_playertype	macro	[player]
;km_set_playertype	macro	[player,playername]
;km_bitcheck_playertype	macro	[player,playername] ;{fox,falco,peppy,slippy,gal1,gal2}
;km_bitcheck_arwingtype	macro	[player,arwingtype] ;{FF,SP,GG}

;km_player		macro	[player,reg]	;Register <--- player alien pointer
;km_plheapptr	macro	[player,reg]	;Register <--- player HEAP  pointer
;km_plheapptrSD	macro	[soureg,destreg];DestReg (player heap pointer) <--- SourReg (player alien pointer)


;=====================================================================
;*			JOY PAD Macros				*
;	bne	.push						*
;	beq	.nopush						*
;=====================================================================
;km_readkeydown	macro			;key (L) read
;km_readkeydown_h	macro			;key (H) read
;km_readjoypad	macro			;trig (L) read
;km_readjoypad_h	macro			;trig (H) read

;km_testkeydown(2)	macro	[keyflag]	;key check (normal)
;km_testjoypad(2)	macro	[keyflag]	;key check (trigger)

;km_cmpkeydown	macro	[keyflag]	;cmp key check beq ... OK
;km_cmpkeydown2	macro	[keyflag]	;cmp key check beq ... OK
;km_cmpjoypad	macro	[keyflag]	;cmp key check beq ... OK
;km_acmpkeydown	macro	[keyflag]	;and&cmp key check beq... OK
;km_acmpjoypad	macro	[keyflag]	;and&cmp key check beq... OK
;km_acmpkeydown2	macro	[keyflag]	;and&cmp key check beq... OK
;km_acmpjoypad2	macro	[keyflag]	;and&cmp key check beq... OK

;km_tmpautotrigread	macro			;autotrig <--- key states
;km_testtmpautotrig	macro

;km_autotrigread(2)	macro			;autotrig0/1 <--- key states
;km_testautotrig(2)	macro	[keyflag]	;key check (auto trigger0,1)

;km_setkeystates	macro	[cont]		;[cont]..0/1
;km_checkjoypad	macro	[keyflag]	;key check [cont1,2 kyoutuu]
;(kono macro wa arakajime key states wo set shite okanakereba naranai)


;km_setgmkeydown	macro			;mmw_keydown <--- key states
;km_setgmjoypad	macro			;mmw_trigger <--- trigger states
;km_clrgmkeydown	macro			;mmw_keydown <---- 0
;km_clrgmjoypad	macro			;mmw_trigger <---- 0
;km_testgmjoypad	macro	[keyflag]	;key check
;=====================================================================
;*			CPU Macros				*
;=====================================================================
;km_waittrans	macro
;kwaitvbl		macro
;km_Vcountread	macro		:out put Acc
;km_Vcountstart	macro
;km_Vcountend	macro		;Out Put Acc

;km_irqenable	macro	[flag,(vcnt)]	;IRQ ON
;km_irqdisable	macro
;km_SyoriOverCheckStart	macro
;km_SyoriOverCheckEnd	macro
;=====================================================================
;*			PPU Macros				*
;=====================================================================
;km_wipewait_l	macro
;km_wipewait		macro
;km_wipefadewait_l	macro
;km_wipefadewait	macro
;km_screenfade	macro	[(time)]
;km_screenON		macro		;SCREEN Blankiing Shinai
;km_screenOFF	macro		;SCREEN Blankiing Suru

;km_screenblack	macro		;fadedir <--- -1,FADE <--- 0

;km_fademin		macro		;FADE <--- 0
;km_fademax		macro		;FADE <--- $0f
;km_nofade		macro		;fadedir <--- 0
;km_fadestepup	macro		;fadedir <--- 1
;km_fadestepdown	macro		;fadedir <--- -1
;km_qfadestepup	macro		;fadedir <--- 2
;km_sfadestepup	macro	[time]  ;fadedir <--- 3 (slow fade up)
;km_qfadestepdown	macro		;fadedir <--- -2
;km_fadedownwait	macro		;Wait until FADE = 0
;km_fadeupwait	macro		;Wait until FADE = f
;km_fadeup		macro		;normal fade up		[wait]
;km_fadedown		macro		;normal fade down	[wait]
;km_qfadeup		macro		;quick fade up		[wait]
;km_qfadedown	macro		;quick fade down	[wait]
;km_fadedowncheck	macro		;beq/bne ... fade down finish /fade continue
;km_fadeupcheck	macro		;beq/bne ... fade up finish /fade continue

;=====================================================================
;*			Mario Chip Macros			*
;=====================================================================
;km_waitmario		macro

;=====================================================================
;*			Window Macros				*
;=====================================================================
;*** Wipe ***
;km_initwipeopen	macro	[label]
;km_initwipeclose	macro	[label]

;km_clrwipeclose	macro

;*** h-dma tabs set ***
;km_setrepeatflag		macro	[obj1]	;hdma data repeat flag on

;km_sethdmatabs_reptwin	macro	[mode,left,right]
;km_sethdmatabs_circwin	macro	[val,left,right,top]

;=====================================================================
;*			Scroll Macros				*
;=====================================================================
;km_hdmatabsHscrmode		macro	[mode,addr]	;mode :direct/indirect
;km_hdmatabsVscrmode		macro	[mode,addr]	;mode :direct/indirect

;km_ldascrollflag	macro	[flag]
;km_setscrollflag	macro	[flag,place]	;place = raster place
;km_clrscrollflag	macro	[flag]
;km_bitcheckscrollflag	macro	[flag]
;km_setrastermode	macro	[mode]
;km_setrasterptr	macro
;=====================================================================
;*			Sprites Macros				*
;=====================================================================
;---- Initial ----
;oamclear		macro	;for single buffer
;oamclear_DB		macro	;for double buffer (katahou)
;oamallclear		macro	;for double buffer (ryouhou)
;oamsuballon		macro	;oam sub switch all on (H postion display area in)

;SetSpriteXYOffset	macro	[x,y]	;Sprite (X,Y) zahyou Offset value set

;* 16 chr (4*4) mode *
;Spr16AddrStart	MACRO
;Spr16Addr		MACRO	[label]

;* block data *
;SprBlockAnimeAddrStart	MACRO
;SprBlockAnime		MACRO	[pattern,time]
;SprBlockAnimeEnd		MACRO
;SprBlockAnimeWait		MACRO
;SprBlockAnimeJump		MACRO	[addr]

;SprBlockAddrStart		MACRO
;SprBlockAddr		MACRO	[label]

;---- Sprites Data ---
;SpriteDataB		MACRO	[x,y,char,color,prio,flip,(offset)]
;SpriteDataW		MACRO	[x,y,char,color,prio,flip,(offset)]
;SprXYDataB		MACRO	[x,y]
;SprXYDataW		MACRO	[x,y]
;SprChrDataB		MACRO	[char,color,prio,flip,(offset)]
;SprChrDataW		MACRO	[char,color,prio,flip,(offset)]

;=========== OAM set =============
;km_ldasprchr	macro	[obj,color,prio,flip,offset]	;Acc <--- Character&Att
;km_adcsprchr	macro	[obj,color,prio,flip,offset]	;Acc <--- Acc+Character&Att
;km_setsprchr	macro	[var,obj,color,prio,flip,offset];Var <--- Character&Att

;---- temporary OAM set ----
;km_SetSprite	macro	[((#)para)]	:sprites,y <---- Acc,var,#value

;---- (X,Y) postion set ----
;km_SetSpriteX	macro	[((#)x)]	;sprites,y <---- Acc,var,#value
;km_SetSpriteY	macro	[((#)y)]	;sprites,y <---- Acc,var,#value
;km_SetSpriteC4X	macro	[(x)]		;sprites,y <---- Acc,var
;km_SetSpriteC4Y	macro	[(y)]		;sprites,y <---- Acc,var
;km_SetSpriteC4XY	macro	[x,y]		;sprites,y <---- var (x,y)

;km_SetSpriteXY		macro	[(x,(y))]	;sprites,y <---- Acc,XY,(x,y)
;km_SetSpriteXY_ImOff	macro	[x,y,xoff,yoff]	;sprites,y <---- (x,y)+#offset

;km_SetSpriteImXY		macro	[x,y]		;sprites,y <---- (#x,#y)
;km_SetSpriteImXY_Off	macro	[x,y]		;sprites,y <---- (#x,#y)+offset
;km_SetSpriteImXY_ImOff	macro	[xy,xyoff]	;sprites,y <---- (#x,#y)+#offset

;---- character,color,pri,flip set ----- 
;km_SetSpriteChrVar	macro	[var,chrbase,color,prio,flip,(offset)]	;sprites,y <-- var
;km_SetSpriteChrA	macro	[chrbase,color,prio,flip,(offset)]	;sprites,y <-- Acc
;km_SetSpriteChrVal	macro	[val,color,prio,flip,(offset)] 		;sprites,y <-- #value

;km_SetSpriteChrVar_Off	macro	[var,color,prio,flip,(offset)] ;sprites,y <-- var+offset
;km_SetSpriteChrA_Off	macro	[color,prio,flip,(offset)] ;sprites,y <-- Acc+offset
;km_SetSpriteChrVal_Off	macro	[val,color,prio,flip,(offset)] ;sprites,y <-- #value+offset

;km_SetSpriteChrCol	macro	[base,prio,flip,(offset)]	;sprites <-- Acc (chr,col)
;km_SetSpriteCol	macro	[char,prio,flip,(offset)] ;Init:Acc <--- Color No (0~7)

;km_SetSpriteAtt	macro	[char,(offset)] 	;sprites <-- Acc (Att)

;---- (X,Y),character,pri,color,filp SET -----
;SetSprXYChr		macro	[x,y,character,color,prio,flip,(offset)]
;SetSprXYChr_Im	macro	[x,y,character,color,prio,flip,(offset)]
;SetSprXYOffChr_Im	macro	[x,y,character,color,prio,flip,(offset)]

;---- Dummy Set ----
;SetSprDummy		macro

;---- Sprites size set -----
;km_SetSpriteSize		macro	;4 chara mode only :{For Single}
;km_setspritesize1		macro	;4 chara mode only :{For Single}

;km_setspritesizesb1		macro	;sprites flag (1 bit) ON {Single}
;km_setspritesizesb2		macro	;sprites flag (2 bit) ON {Single}
;km_setspritesizesb3		macro	;sprites flag (3 bit) ON {Single}
;km_setspritesizesb4		macro	;sprites flag (4 bit) ON {Single}

;km_setspritesizedb1		macro	;sprites flag (1 bit) ON {Double}
;km_setspritesizedb2		macro	;sprites flag (2 bit) ON {Double}
;km_setspritesizedb3		macro	;sprites flag (3 bit) ON {Double}
;km_setspritesizedb4		macro	;sprites flag (4 bit) ON {Double}

;km_SetSpriteSizeDouble_l	macro	;sprites flag (1 bit) ON :(for double buffer)
;---- Block transfersprites data ---
;BlockTransSPrites		macro	[sourceadr]	;8*8 chr mode
;BlockTransSpritesBig	macro	[sourceadr]	;16*16 chr mode
;BlockTransSpritesBigDouble	macro	[sourceadr]	;16*16 chr mode (Double buffer)
;BlockTransSpritesOffset	macro	[sourceadr]

;BlockCopySprites	macro	[source]
;BlockCopySprOff	macro	[source,hosei(x,y hosei)]
;BlockCopySprOffBig	macro	[source,hosei(x,y hosei)]

;----------------------------------------------------------------------
;* RADAR *
;km_radarscale	[scale]
;----------------------------------------------------------------------
;=====================================================================
;*			BG Macros				*
;=====================================================================
;============================== Tmp ==================================

;============================== CGX ==================================
;kbetascr_l		macro	[vram,adr,val]	
;kbetascr_h		macro	[vram,adr,val]
;calcbgchar		macro	[label,char,color,prio,flip]
;calcscrchar		macro	[label,char]
;calcbgchar_a	macro

;============================== SCR ==================================
;calcscrchar_a	macro
;calcMcharDAdr	macro	[label,char]
;ConvMChraNo2MChrAdr	macro
;kcopyIntChr		macro	[source,dest]
;KcopyBitmapFixChr	macro	[source,dest,val]
;KcopyRdScChr	macro	[source,dest,val]
;KcopyBitmapChr_a	macro	[source,dest,val]
;KcopyBitmapChr_xy	macro	[val]
;KcopyBitmapChrXY	macro	[source,dest,val]
;---------------------------------------------------------------------
;km_dmaromram	macro	[channel,source,dest,length]
;km_dmaromXram	macro	[channel,source,dest,length]

;km_dmaWRAMClear	macro	[channel,dest,length]	;Work RAM Clear
;km_dmaVRAMClear	macro	[channel,dest,length]	;VRAM Clear
;km_dmaMRAMClear	macro	[channel,dest,length]	;Mario RAM Clear

;km_dmaromVRAM	macro	[channel,source,dest,length]
;km_dmaXromVRAM	macro	[channel,sbase,dest,length]   ;source addr = sbase+ Xreg
;km_dmaXromYVRAM	macro	[channel,sbase,dbase,length]  ;source:Xreg,dest:Yreg
;km_VRAMclear	macro	;moshi kono macro wo tukau baai ha tyuui
			;decvram no macro ga suguushiro ni arutoki ha
			;wait wo oku

;km_dmacgx4VRAM	macro	[channel,CPUadr,VRAMadr,number(character kazu)] 
;km_dmaXcgx4VRAM	macro	[channel,CPUBaseAdr,VRAMadr,number(character kazu)]
;			;(Source Address = Xreg+CPU Base Address)
;km_dmascrw 		macro	[channel,vbase,vx,vy,rambuf,val]
;km_dmascrl 		macro	[channel,vbase,vx,vy,rambuf,val]

;( For Irq Special Dma)
;km_IRQdmaromVRAM		macro	[source,dest,length]
;km_IRQdmaXromVRAM		macro	[sbase,dest,length]
;km_IRQdmaxvram		macro	[sbase,length]
;km_IRQdmaYXVRAM		macro	[sbase,length]
;km_IRQdmaoaram		macro	[source,length]
;km_IRQdmasprbufclr		macro
;km_IRQdmatranscolpal	macro	[moto,saki,kazu] :moto = work,saki=0~15,kazu=1~16
;km_IRQdmaRAMtoCGRAM		macro	[RAMadr,CGRAMadr,length] :CGRAMadr = 0~$ff,length =0~$200
;km_IRQdmaRAMtoColBuf	macro	[file,kazu,(start)] :file name,kazu = 1~16,start=0~15
;km_IRQdmaROMtoRAM		macro	[source,dest,length]
;km_IRQdmaRAMtoRAM		macro	[source,dest,length]
;km_IRQdmaMRAMtoRAM		macro	[source,dest,length] :From mario ram To sfx ram

;km_convSCRaddr_32X		macro	;Input :(x,y) = 0~1f OutPut :Xreg(0~$7ff)
;km_convSCRCheckaddr_32X	macro	;Input :(x,y) = 0~1f OutPut :Xreg(0~$3ff)

;km_convVRAMSCRaddr_32	macro	[x,y,(base)]	;Input :(x,y) = 0~1f OutPut :Acc (0~$3ff)
;km_convVRAMSCRaddr_256	macro	[x,y,(base)]	;Input :(x,y) = 0~ff OutPut :Acc (0~$3ff)
;km_convVRAMSCRaddr_256X	macro	[x,y,(base)]	;Input :(x,y) = 0~ff OutPut :Xreg(0~$3ff) 
;km_convVRAMSCRaddr_256Y	macro	[x,y,(base)]	;Input :(x,y) = 0~ff OutPut :Yreg(0~$3ff)

;SCRCH		macro	[SCR,xpos,ypos,chNo]

;km_set_misstage4	macro
;============================ COLOUR =================================
;ColChange		macro	[type,palette,colNo,buffer]
;km_dmatranscolpal	macro	[moto,saki,kazu] :(saki = palette No)
;km_dmaCGRAMtoRAM	macro	[channel,CGRAMadr,RAMadr,length]

;km_gamepal		macro	[pal]
;km_setgamepal	macro	[(pal)]
;km_palette		macro	[name,len,start]
;km_setdepth		macro	[depthmode]	;mode = {night,mist,desert,marine}


;========================== DECRUNCH =================================
;km_decrunchcgx	macro	[label,(offset)] ;mario address = dec_base+{offset}
;km_decrunchscr	macro	[label,(offset)] ;mario address = dec_base+{offset}
;km_decrunchpal	macro

;=====================================================================
;*			Sound Macros				*
;=====================================================================
;----- label define ----
;km_port2labelstart	macro
;km_port2label	macro	{label}
;km_port2smlabel	macro	{label}
;km_port3labelstart	macro
;km_port3label	macro	{label}
;km_port3SMlabel	macro	{label}

;----- sound tensou -----
;KSoundTrans		macro	[address,(player)]
;KSoundTransWait	macro

;KBGMAddr		macro	[addr]	;tensou BGM File address
;KBGMInterrupt	macro	[addr]	;totyuu tensou trigger

;KSoundProgTrans	macro	[address]
;KSoundBGMTrans	macro
;KSoundPlayerTrans	macro

;km_soundwait	macro		;Sound Set Wait
;----- port 0 -------
;KBGM		macro	[label]	;{BGM lavel,streo,monoral}
;KBGM_a		macro		;{BGM lavel,streo,monoral} <-- Acc
;KBGMWAIT		macro

;km_setsndplace	macro
;km_pushsndplace	macro	[label]
;km_pullsndplace	macro

;km_readport0	macro		;Acc <--- apu_port0

;---- port1 -----
;km_setsoundp1	macro	[label]
;km_readport1	macro	;Acc <--- apu_port1
;km_setsoundport1		macro	[label]

;---- port2 -----
;km_sndport2		macro	[reg,label]

;**** memo :konoato wa OLD Version ***
;km_setsoundport2		macro	[label(,dist,pos)]
;km_setsoundport2_dist	macro	[dist]
;km_setsoundport2_pos	macro	[pos]

;km_readport2	macro	;Acc <--- apu_port2

;---- port3 ----
;Ksound		macro	[name,flag,player]
;Ksound_a		macro			;(Center ,Near)Sound Only
;ksoundwork		macro	[name,work]	;work ni flag wo set
;Kplsound		macro	[obj,label,(flag)] ;label = (name or a),obj = player ptr (x,y)

;km_readport3	macro	;Acc <--- apu_port3
;km_waitport3	macro	;port 3 no sound wo zenbu narasumade wait

;---- bug report ---
;kbugapuport		macro	;sound port0,1,2,3 display 
;kbugapuport0	macro	;sound port0 display
;kbugapuport_MIS	macro	;sound port0,1,2,3 display 
;kbugapuport_BAT	macro	;sound port0,1,2,3 display 

;---- sound table ----
;sndtbldata		macro		;sound table data
;sndspaddr		macro	[addr]	;special sound address table  
;sndsptbldata	macro		;special sound data table

;=====================================================================
;*			Radar Maps Macros			*
;=====================================================================
;km_setrdmap		macro	[stage]
;km_setrdmapptr	macro	[stage]
;km_ldxrdmapptr	macro
;km_rdmapstart	macro	[stage]
;km_rdmapend		macro	[stage]
;km_rdmap		macro	[x,y,chara]
;=====================================================================
;*			Pointer Macro				*
;=====================================================================
;km_incptr		macro	[size,var,(#)end]
;km_incincptr	macro	[size,var,(#)end]
;km_decptr		macro	[size,var,(#)init]
;km_decdecptr	macro	[size,var,(#)init]
;=====================================================================
;*			Soft Ware Timer				*
;=====================================================================
;INCTIMER	macro	[mem,start,end]
;DECTIMER	macro	[mem,start,end]

;km_dectimer0	macro	[timer]
;km_inctimer		macro	[timer,cmpval]
;km_addtimer		macro	[timer,val,cmpval]

;=====================================================================
;*		Calculation Macros				*
;=====================================================================
;******************** multiply **********************

;km_cpumultu8u8	macro	[reg]		;reg(16bit) or Acc (16bit) <--- Acc(8bit) * reg(8bit)
;km_cpumultu8uf8	macro	[reg,val]	;reg(16bit) <--- Acc(8bit) * #value(8bit)
;km_cpumults8s8	macro			;kz_x1(16 bit) <--- kz_x1*kz_x2
;km_cpumults8s8_X	macro			;Xreg (16 bit)_<--- kz_x1*kz_x2

;km_ppumults15s7	macro	[reg]		;(Acc,Reg)24bit <--- Acc(8bit)*reg(16bit)
;km_ppumults15sf7	macro	[reg,val]	;(Acc,Reg)24bit <--- #val(8bit)*reg(16bit)

;km_multa3		macro			;Acc <-- Acc*3
;km_multvar3		macro	[var,(reg)]	;var (reg)<-- var*3

;km_shiftLUA2	macro			;Acc <-- Acc*4
;km_multa4		macro			;Acc <-- Acc*4
;km_multvar4	macro	[var,reg]		;var (reg)<-- var*4

;km_multa5		macro			;Acc <-- Acc*5
;km_multvar5		macro	[var,reg]	;var (reg)<-- var*5

;km_multa6		macro			;Acc <-- Acc*6
;km_multvar6		macro	[var,reg]	;var (reg)<-- var*6

;km_shiftLUA3	macro			;Acc <-- Acc*8
;km_multa8		macro			;Acc <-- Acc*8

;km_shiftLUA4	macro			;Acc <-- Acc*16
;km_multa16		macro			;Acc <-- Acc*16

;km_shiftLUA5	macro			;Acc <-- Acc*32
;km_multa32		macro			;Acc <-- Acc*32
;*********************** division *****************************
;km_shiftRUA2	macro			;Acc <---Acc/4
;km_divu4		macro			;Acc <---Acc/4

;km_shiftRUA3	macro			;Acc <---Acc/8
;km_divu8		macro			;Acc <---Acc/8

;km_shiftRUA4	macro			;Acc <---Acc/16
;km_divu16		macro			;Acc <---Acc/16

;km_shiftRUA5	macro			;Acc <---Acc/32
;km_divu32		macro			;Acc <---Acc/32

;km_shiftRSA2	macro			;Acc <---Acc/8	(sin bit)
;km_divs4		macro			;Acc <---Acc/8	(sin bit)

;km_shiftRSA3	macro			;Acc <---Acc/8	(sin bit)
;km_divs8		macro			;Acc <---Acc/8	(sin bit)

;km_shiftRSA4	macro			;Acc <---Acc/16	(sin bit)
;km_divs16		macro			;Acc <---Acc/16	(sin bit)

;** divisor (waru kazu),dividend (warareru kazu)
;km_cpudivs15u8	macro	[reg]		   ;reg(16bit) <--- Acc(16bit) / Reg(8bit)
;km_cpudivs15uf8	macro	[val]		   ;Acc(16bit) <--- Acc(16bit) / #val(8bit)
;km_cpudivu16uf8_XY		macro	[val]	   :(x,y) <--- Acc(16 bit) / #val(8bit)
;km_cpudivu16uf8_work	macro	[val]	   :(ksyou,kamari)  <--- Acc(16 bit) / #val(8bit)
;km_cpudivu16u8_XY	macro	[(#)divisor,(#)dividend] :(x,y) <--- Acc or dividend /(#)divisor
;km_cpudivu16u8_work macro	[(#)divisor,(#)dividend] :(ksyou,kamari) <--- Acc or dividend /(#)divisor

;*** angle ****
;km_obj2field_rotY	macro	[size,obj1,var]	;zahyou kara angle wo motomeru.
;kplm_obj2field_rotY	macro	[size,obj1,var]	;modore modere mark mark

;=====================================================================
;*								*
;*		Memory Mode Macros				*
;*								*
;=====================================================================
;----------------------------------------------------------------------
km_zalc	macro	[label,size]
	chkalc
kz_{label}	equ	zmempt
zmempt	=	zmempt+{size}
	endm
;----------------------------------------------------------------------
km_alc	macro	[label,size]
	chkalc
kw_{label}	equ	wmempt
wmempt	=	wmempt+{size}
	endm
;----------------------------------------------------------------------
km_xalc	macro	[label,size]
	chkalc
kx_{label}	equ	xmempt
xmempt	=	xmempt+{size}
	endm
;----------------------------------------------------------------------
km_xxalc	macro	[label,size]
	chkalc
kxx_{label}	equ	xxmempt
xxmempt	=	xxmempt+{size}
	endm
;----------------------------------------------------------------------
km_malc	macro	[label,size]
	chkalc
km_{label}	equ	mmempt
mmempt	=	mmempt+{size}
	endm
;----------------------------------------------------------------------
km_alclabel	macro	[label]
kw_{label}	equ	wmempt
	endm
;----------------------------------------------------------------------
km_xalclabel	macro	[label]
kx_{label}	equ	xmempt
	endm
;----------------------------------------------------------------------
km_malclabel	macro	[label]
km_{label}	equ	mmempt
	endm
;----------------------------------------------------------------------
km_alclabelstart	macro	[label]
kw_{label}start	equ	wmempt
	endm
;----------------------------------------------------------------------
km_alclabelend	macro	[label]
kw_{label}end	equ	wmempt
	endm
;----------------------------------------------------------------------
km_xalclabelstart	macro	[label]
kx_{label}start	equ	xmempt
	endm
;----------------------------------------------------------------------
km_xalclabelend	macro	[label]
kx_{label}end	equ	xmempt
	endm
;----------------------------------------------------------------------
km_malclabelstart	macro	[label]
km_{label}start	equ	mmempt
	endm
;----------------------------------------------------------------------
km_malclabelend	macro	[label]
km_{label}end	equ	mmempt
	endm
;----------------------------------------------------------------------
km_labelstart	macro	[numlab]

	ifeq	NARG
_listptr = 0
	elseif
_listptr = {numlab}
	endc

_listlen = 0
	endm
;----------------------------------------------------------------------
km_label	macro	[name,size]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1
{name}	equ	_listptr
_listptr = _listptr+1
_listlen = _listlen+1
	elseif
{name}	equ	_listptr
_listptr = _listptr+{size}
_listlen = _listlen+{size}
	endc

	endm
;----------------------------------------------------------------------
km_labellen	macro	[label]
{label} equ	_listlen
	endm

;---------------------------------------------------------------------------
	string	gmlb[80]
km_gmlabelstart	macro	[codename,startnum]
MYNARG	=	NARG
	CHK_NARG	1,2

	defs	gmlb,"{codename}"

	ifeq	narg-1
_gmlb	=	0
	elseif
_gmlb	=	{startnum}
	endc

_gmlistlen = 0
		endm
;----------------------------------------------------------------------
km_gmlabel		macro	[name,step]
MYNARG	=	NARG
	CHK_NARG	1,2

	run	"%$gmlb","_{name}	equ	_gmlb"

	ifeq	narg-1
_gmlb	=	_gmlb+1
_gmlistlen	=	_gmlistlen+1
	elseif
_gmlb	=	_gmlb+{step}
_gmlistlen	=	_gmlistlen+{step}
	endc
	endm
;----------------------------------------------------------------------
km_gmlabellen	macro	[label]
{label} equ	_gmlistlen
	endm
;---------------------------------------------------------------------------
	string	gmfl[80]
km_gmflagstart	macro	[codename,startnum]
MYNARG	=	NARG
	CHK_NARG	1,2

	defs	gmfl,"{codename}"

	ifeq	narg-1
_gmfl	=	0
	elseif
_gmfl	=	{startnum}
	endc
		endm
;----------------------------------------------------------------------
km_gmflag		macro	[name,step]
MYNARG	=	NARG
	CHK_NARG	1,2

	run	"%$gmfl","_{name}	equ	1<<(_gmfl)"

	ifeq	narg-1
_gmfl	=	_gmfl+1
	elseif
_gmfl	=	_gmfl+{step}
	endc
	endm
;----------------------------------------------------------------------
km_worklabelstart	macro	[base]
MYNARG	=	NARG
	CHK_NARG	1
	defs	2,"{base}"
_wls	=	{base}
_kworkptr = 0
	endm
;--------------------------------------------------------------------
km_worklabelend		macro
	run	"%$2","END	equ	_wls+_kworkptr"
	endm
;--------------------------------------------------------------------
km_worklabel	macro	[size,label]
MYNARG	=	NARG
	CHK_NARG	2

_tmpwklb = 0
_tmpwklb_b = 1
_tmpwklb_w = 2

	ifd	_tmpwklb_{size}
	ifeq	_tmpwklb_{size}-_tmpwklb_b
_tmpwklb = 1
	elseif
_tmpwklb = 2
	endc

	elseif

;* bug check 1 *
	printf	"Error:Should set B(b) or W(w)\n"
	error+
	endc

;* bug check 2 *
	ifeq	_tmpwklb
	printf	"Error:Should set B(b) or W(w)\n"
	error+
	endc

{label}	equ	_wls+_kworkptr
_kworkptr = _kworkptr+_tmpwklb
_kworkptr2 = _kworkptr2+_tmpwklb

	ENDM
;--------------------------------------------------------------------
km_workgroup	macro	[size,label]
MYNARG	=	NARG
	CHK_NARG	2

{label}	equ	_wls+_kworkptr
_kworkptr = _kworkptr+{size}
_kworkptr2 = _kworkptr2+{size}

	ENDM
;--------------------------------------------------------------------
km_worklabellen	macro	[label]
MYNARG	=	NARG
	CHK_NARG	1

{label}	equ	_kworkptr

	endm
;--------------------------------------------------------------------
km_workvalcheck	macro	[max]
	IFLT	{max}-_kworkptr
	printf	"** %q%f%q: (%l) Error: Work Memory Over (kawaguchi) !!%n"
	error+

	ENDC
	endm
;--------------------------------------------------------------------
km_worksizestart	macro
_kworkptr2 = 0
	endm
;--------------------------------------------------------------------
km_worksize	macro	[label]
MYNARG	=	NARG
	CHK_NARG	1
{label}	equ	_kworkptr2
	endm
;---------------------------------------------------------------------------
	string	kawa1[80]
km_workstart		macro	[topname,base]
	defs	kawa1,"{topname}"
_ws	=	{base}
		endm
;----------------------------------------------------------------------
km_work		macro	[name,len]
	run	"%$kawa1","_{name}	equ	_ws"
_ws	=	_ws+{len}
		endm

;**** For Example ***
	ifeq	1
	km_workstart	kw,kxswork
	km_work		arwing,1
	km_work		arwing2,2
	km_work		arwing3,1
	km_work		arwing4,1

kw_arwing	equ	kxswork+0
kw_arwing2	equ	kxswork+1
kw_arwing3	equ	kxswork+3
kw_arwing4	equ	kxswork+4
	endc

;=====================================================================
;*			Data Macros				*	
;=====================================================================
;---------------------------------------------------------------------
km_datasize	macro	[label]
MYNARG	=	NARG
	CHK_NARG	1
{label}size	equ	{label}SZ-{label}
	endm
;---------------------------------------------------------------------
km_datalen	macro	[label]
MYNARG	=	NARG
	CHK_NARG	1
{label}len	equ	{label}END-{label}
	endm
;---------------------------------------------------------------------
km_datacnt	macro	[size,startlabel]
MYNARG	=	NARG
	CHK_NARG	2
_tmpsize = 0

	ifc	"b","{size}"
_tmpsize = 1
	endc	

	ifc	"B","{size}"
_tmpsize = 1
	endc	

	ifc	"w","{size}"
_tmpsize = 2
	endc	
	ifc	"W","{size}"
_tmpsize = 2
	endc	

	ifeq	_tmpsize
	printf	"Error:Should set B(b) or W(w)\n"
	error+
	endc

	d{size}	({startlabel}END-{startlabel}-(_tmpsize))&{size}M

	endm
;---------------------------------------------------------------------
km_datacntBig	macro	[size,startlabel]
MYNARG	=	NARG
	CHK_NARG	2
_tmpsize = 0

	ifc	"b","{size}"
_tmpsize = 1
	endc	

	ifc	"B","{size}"
_tmpsize = 1
	endc	

	ifc	"w","{size}"
_tmpsize = 2
	endc	
	ifc	"W","{size}"
_tmpsize = 2
	endc	

	ifeq	_tmpsize
	printf	"Error:Should set B(b) or W(w)\n"
	error+
	endc

	d{size}	(({startlabel}END-{startlabel}-(_tmpsize))+$8000)&{size}M

	endm

;----------------------------------------------------------------------
km_flagstart	macro	[num]

	ifeq	NARG
_flnum = 0
	elseif
_flnum = {num}
	endc

	endm
;----------------------------------------------------------------------
km_flag	macro	[name]
_flptr  = 1<<_flnum

{name}	equ	_flptr

_flnum = _flnum+1
	endm
;----------------------------------------------------------------------
km_size	macro	[label]
{label} equ	_flnum
	endm
;----------------------------------------------------------------------
km_memcheck	macro
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in shortA mode%n"
	error+
	ENDC
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in longI mode%n"
	error+
	ENDC
	endm
;----------------------------------------------------------------------
km_memchecka8	macro
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in shortA mode%n"
	error+
	ENDC
	endm
;----------------------------------------------------------------------
km_memchecki16	macro
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in longI mode%n"
	error+
	ENDC
	endm
;----------------------------------------------------------------------
km_memchecka8i8	macro
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in shortA mode%n"
	error+
	ENDC
	IFNE	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in shortI mode%n"
	error+
	ENDC
	endm
;----------------------------------------------------------------------
km_memchecka8i16	macro
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in shortA mode%n"
	error+
	ENDC

	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in longI mode%n"
	error+
	ENDC
	endm
;----------------------------------------------------------------------
km_memchecka16	macro
	IFEQ	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in longA mode%n"
	error+
	ENDC
	endm
;----------------------------------------------------------------------
km_memchecka16i8	macro
	IFEQ	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in longA mode%n"
	error+
	ENDC

	IFNE	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in shortI mode%n"
	error+
	ENDC
	endm
;----------------------------------------------------------------------
km_memchecka16i16	macro
	IFEQ	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in longA mode%n"
	error+
	ENDC
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in longI mode%n"
	error+
	ENDC
	endm
;----------------------------------------------------------------------
km_chga8		macro
_kmemret = 0
	IFNE	LONGA
_kmemret = 1
	a8
	ENDC

	ENDM
;----------------------------------------------------------------------
km_chga16		macro
_kmemret = 1
	IFEQ	LONGA
_kmemret = 0
	a16
	ENDC

	ENDM
;----------------------------------------------------------------------
km_reta8		macro

	IFEQ	_kmemret
	a8
	ENDC

	ENDM
;----------------------------------------------------------------------
km_reta16	macro

	IFNE	_kmemret
	a16
	ENDC
	ENDM
;----------------------------------------------------------------------
km_chgi8		macro
_kidxret = 0
	IFNE	LONGI
_kidxret = 1
	i8
	ENDC

	ENDM
;----------------------------------------------------------------------
km_chgi16		macro
_kidxret = 1
	IFNE	LONGI
_kidxret = 0
	i16
	ENDC

	ENDM
;----------------------------------------------------------------------
km_reti8		macro

	IFEQ	_kidxret
	i8
	ENDC

	ENDM
;----------------------------------------------------------------------
km_reti16	macro

	IFNE	_kidxret
	i16
	ENDC
	ENDM
;----------------------------------------------------------------------
km_chkly	macro
__chk_l	=	1234
	ifnd	__chk_\0
	error	<unknown suffix>
	mexit
	endc
	ifeq	__chk_\0-__chk_l
	error	<Sorry Can't do .l with Y>
	endc
	ENDC
	endm
;----------------------------------------------------------------------
km_CHG_MODE		MACRO	[size]
ksize = 0

	ifc	"b","{size}"
ksize = 1
	endc

	ifc	"B","{size}"
ksize = 1
	endc

	ifc	"w","{size}"
ksize = 2
	endc

	ifc	"W","{size}"
ksize = 2
	endc

;* SIZE SET CHECK *
	ifeq	ksize
	printf	"Error:Should set B(b) or W(w)\n"
	error+
	endc

;* Memory Mode Check *
ksizeflag = 0

;* B *
	IFEQ	ksize-1

	ifne	longa
	a8
ksizeflag = 1
	endc

	ELSEIF
;* W *
	ifeq	longa
	a16
ksizeflag = 1
	endc
	ENDC
	ENDM
;----------------------------------------------------------------------
km_CHG_MODEBACK	MACRO
;* B *
;* ksize = 1 *
	IFEQ	ksize-1

	ifne	ksizeflag
	a16
	endc

	ELSEIF
;* W *
;* ksize = 2 *
	ifne	ksizeflag
	a8
	endc
	ENDC

	ENDM
;----------------------------------------------------------------------
km_PushAllReg	macro
	pha
	phx
	phy
	phb
	php
	endm
;----------------------------------------------------------------------
km_PullAllReg	macro
	plp
	plb
	ply
	plx
	pla
	endm

;----------------------------------------------------------------------

;=====================================================================
;*								*
;*			Debagu mode				*
;*								*
;=====================================================================
kbug1	macro
	ifne	kbugsw
	pha
	lda	#$01
	sta.l	$7ffffe		;kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
kbug2	macro
	ifne	kbugsw
	pha
	lda	#$02
	sta.l	kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
kbug3	macro
	ifne	kbugsw
	pha
	lda	#$03
	sta.l	kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
kbug4	macro
	ifne	kbugsw
	pha
	lda	#$04
	sta.l	kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
kbug5	macro
	ifne	kbugsw
	pha
	lda	#$05
	sta.l	kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
kbug6	macro
	ifne	kbugsw
	pha
	lda	#$06
	sta.l	$7ffffe		;kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
kbug7	macro
	ifne	kbugsw
	pha
	lda	#$07
	sta.l	kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
kbug8	macro
	ifne	kbugsw
	pha
	lda	#$08
	sta.l	kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
kbug9	macro
	ifne	kbugsw
	pha
	lda	#$09
	sta.l	kbugbreak
	pla
	endc
	endm
;---------------------------------------------------------------------
km_blink	macro
	ifne	kblinksw
	blink
	endc
	endm
;---------------------------------------------------------------------
km_nastycheck	macro
	IFNE	kblinksw
	jsl	knastycheck_l
	ENDC
	endm
;---------------------------------------------------------------------
;*		Print Display Words				*
;* Init : Acc							*
;---------------------------------------------------------------------
km_printByte	macro	[x,y]
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecka8i16

	pha
	pha
	km_SetSpriteImXY	{x}*8,{y}*8
	pla
	km_divu16
	km_SetSpriteChrA	0,colpal0,pri3,noflip

	km_SetSpriteImXY	{x}*8+8,{y}*8
	pla
	and	#$0f
	km_SetSpriteChrA	0,colpal0,pri3,noflip
	endm
;---------------------------------------------------------------------
km_printBinary	macro	[x,y]
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecka8i16

	phx
	ldx	#{x}*8+({y}*8)<<8-1
	jsl	printbinary_l
	plx
	endm
;---------------------------------------------------------------------
;* Init : Acc							*
;---------------------------------------------------------------------
kprintD	macro	[x,y]
	phb
	phx
	phy
	pha
	savemode

	i16

	IFEQ	LONGA
	a16
	sexa
	endc

	sta	kwork+0		;val

	a8
	lda	#0
	pha
	plb			;Data Bank 0

	ai16
	ldx	sprpointer

	lda	#({x}+(({y}-1)<<8))
	clc
	adc	#$0020
	sta	kwork+2		;(x,y) offset

	jsl	disp_alvar_l

	stx	sprpointer

	returnmode
	pla
	ply
	plx
	plb
	endm
;=====================================================================
;*		Special	Debug Command				*
;=====================================================================
km_Debug_reset	macro
	ifne	kbugsw
	km_cmpkeydown	RESET	;TL,TR,select,start
	bne	.noreset\@
	jml	restart
.noreset\@
	endc
	endm
;=====================================================================
;*			RAM Work Macros				*
;=====================================================================
km_DRAMCLEAR		macro	[address,value]
MYNARG	=	NARG
	CHK_NARG	2

	km_memchecka8i16

tmprcl	=	({address}>>16)&01
	phb
	pha
	phx

	lda	#0
	pha
	plb

	ldx	#{address}&WM
	stx	wmaddl		;RAM address

	lda	#tmprcl
	sta	wmaddh		;RAM bank

	lda	#%00001000	;1 adr only write ,Abus -->B bus,adr FIX
	sta	ch0params

	lda	#$80
	sta	ch0addrb	;DRAM WRITE

;* tensou moto address *
	ldx	#clear_data&WM
	stx	ch0addra1tl
	lda	#clear_data>>16
	sta	ch0atbank
;* tensou value *
	ldx	#{value}&WM
	stx	ch0dataddrl
;* dma start *
	lda	#1
	sta	mdmaen

	plx
	pla
	plb
	ENDM
;---------------------------------------------------------------------

;=====================================================================
;*								*
;*			General Macro				*
;*								*
;=====================================================================
db0	macro
	ifeq	longa
		lda	#0
		pha
		plb
	elseif
		lda	#0
		pha
		plb
		plb
	endc
	endm
;--------------------------
db7e	macro
	ifeq	longa
		lda	#$7e
		pha
		plb
	elseif
		lda	#$7e7e
		pha
		plb
		plb
	endc
	endm
;--------------------------
db7f	macro
	ifeq	longa
		lda	#$7f
		pha
		plb
	elseif
		lda	#$7f7f
		pha
		plb
		plb
	endc
	endm
;--------------------------
km_db0	macro
	km_chga8
	PHA
		lda	#0
		pha
		plb
	PLA
	km_reta16
	endm
;-------------------------
km_db7e	macro
	km_chga8
	PHA
		lda	#$7e
		pha
		plb
	PLA
	km_reta16
	endm
;------------------------------
km_db7f	macro
	km_chga8
	PHA
		lda	#$7f
		pha
		plb
	PLA
	km_reta16
	endm
;--------------------------------------------------------------------
km_hib0	macro
	lda	#0
	xba
	endm
;--------------------------------------------------------------------
km_loba	macro
	km_chga16
	and	#$00ff
	km_reta8
	endm
;--------------------------------------------------------------------
km_hiba	macro
	km_chga16
	and	#$ff00
	km_reta8
	endm
;--------------------------------------------------------------------
km_lobswapa	macro
	km_chga16
	and	#$00ff
	xba
	km_reta8
	endm
;--------------------------------------------------------------------
km_hibswapa	macro
	km_chga16
	and	#$ff00
	xba
	km_reta8
	endm
;--------------------------------------------------------------------
km_ldasla		macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
	ifeq	narg-1
	lda.\0	{var}
	elseif
	lda.\0	{var},{reg}
	endc
	asl	a
	endm
;--------------------------------------------------------------------
km_lldasla		macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
	ifeq	narg-1
	lda.\0	{var}
	elseif
	lda.\0	{var},{reg}
	endc
	and	#$00ff
	asl	a
	endm
;--------------------------------------------------------------------
km_sexa	macro
	km_chga16
	bit	#$0080
	beq	.plas\@
	ora	#$ff00
	bra	.end\@
.plas\@
	and	#$00ff
.end\@
	km_reta8
	endm
;--------------------------------------------------------------------
km_asra	macro
	cmp #(longa&$7f80)+128
	ror a
	endm
;--------------------------------------------------------------------
asr	macro	[a]
_tmpasra = 0

	ifc	"a","{a}"
_tmpasra = 1
	endc

	ifc	"A","{a}"
_tmpasra = 1
	endc

	ifeq	_tmpasra
	printf	"Error:Should set a or A \n"
	error+
	endc

	cmp #(longa&$7f80)+128
	ror {a}
	endm
;--------------------------------------------------------------------
km_nega	macro
	eor #-1
	inc a
	endm
;--------------------------------------------------------------------
km_andcmpval	macro	[val]
	and	#{val}
	cmp	#{val}
	endm
;--------------------------------------------------------------------
km_cmpvarval	macro	[var,val,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG<3
	lda.\0	{var}
	cmp	#({val})
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	cmp	#({val})
	endc
	endm
;--------------------------------------------------------------------
km_andcmpvarval	macro	[var,val,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	ifeq	narg-2
	lda.\0	{var}
	elseif
	lda.\0	{var},{reg}
	endc
	and	#{val}
	cmp	#{val}
	endm
;--------------------------------------------------------------------
km_loblda	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{var}
	and	#$ff
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#$ff
	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_hiblda	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{var}
	and	#$ff00
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#$ff00
	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_lobsta	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
	km_chga16

	ifeq	narg-1
	and	#$ff
	sta.\0	{var}

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	and	#$ff
	sta.\0	{var},{reg}
	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_hibsta	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16
	ifeq	narg-1
	and	#$ff00
	sta.\0	{var}
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	and	#$ff00
	sta.\0	{var},{reg}
	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_lobswaplda	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{var}
	and	#$ff
	xba
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#$ff
	xba
	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_hibswaplda	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{var}
	and	#$ff00
	xba
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#$ff00
	xba
	endc
	km_reta8
	endm

;--------------------------------------------------------------------
km_lobswapsta	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16
	ifeq	narg-1
	and	#$ff
	xba
	sta.\0	{var}
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	and	#$ff
	xba
	sta.\0	{var},{reg}
	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_hibswapsta	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
	km_chga16

	ifeq	narg-1
	and	#$ff00
	xba
	sta.\0	{var}

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	and	#$ff00
	xba
	sta.\0	{var},{reg}
	endc

	km_reta8
	endm
;--------------------------------------------------------------------
km_sexvar	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{var}
	bit	#$0080
	beq	.plas\@
	ora	#$ff00
	bra	.end\@
.plas\@
	and	#$00ff
.end\@
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	bit	#$0080
	beq	.plas\@
	ora	#$ff00
	bra	.end\@
.plas\@
	and	#$00ff
.end\@
	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_addvar 	macro	[var,addvar]
	lda.\0	{var}
	clc
	adc.\0	{addvar}
	endm
;--------------------------------------------------------------------
km_addval	macro	[var,val,reg]
	IFNE	NARG<3

	lda.\0	{var}
	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	ELSEIF


_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc
	ENDC
	endm
;--------------------------------------------------------------------
km_subvar	macro	[var,subvar,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3

	lda.\0	{var}
	sec
	sbc.\0	{subvar}

	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	sec
	sbc.\0	{subvar}
	ENDC
	endm
;--------------------------------------------------------------------
km_abssubvar	macro	[var,subvar,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3

	lda.\0	{var}
	sec
	sbc.\0	{subvar}
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	sec
	sbc.\0	{subvar}
	ENDC

	bpl	.plas\@
	eor	#-1
	inc	a
.plas\@
	endm
;--------------------------------------------------------------------
km_subval	macro	[var,val,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG<3

	lda.\0	{var}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC
	

	lda.\0	{var},{reg}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	ENDC
	endm
;--------------------------------------------------------------------
km_setvar	macro	[dest,sour]
	lda.\0	{sour}
	sta.\0	{dest}
	endm
;--------------------------------------------------------------------
km_setvar16	macro	[dest,sour]
	km_chga16
	lda.\0	{sour}
	sta.\0	{dest}
	km_reta8
	endm
;--------------------------------------------------------------------
km_stavar	macro	[dest,sour]
	lda.\0	{sour}
	sta.\0	{dest}
	endm
;--------------------------------------------------------------------
km_stxvar	macro	[dest,sour]
	ldx	{sour}
	stx	{dest}
	endm
;--------------------------------------------------------------------
km_styvar	macro	[dest,sour]
	ldy	{sour}
	sty	{dest}
	endm
;--------------------------------------------------------------------
km_setval	macro	[var,val,reg]
	IFNE	NARG<3

	ifc	"{val}","0"

		ifnc	"\0","L"
		stz	{var}

		elseif

		lda	#0
		sta.\0	{var}

		endc
	elseif

	lda	#{val}
	sta.\0	{var}
	endc

	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda	#{val}
	sta.\0	{var},{reg}

	ENDC
	endm
;--------------------------------------------------------------------
km_staval	macro	[var,val,reg]
	km_setval	{var},{val},{reg}
	endm
;--------------------------------------------------------------------
km_stxval	macro	[var,val]
	ldx	#{val}
	stx	{var}
	endm
;--------------------------------------------------------------------
km_styval	macro	[var,val]
	ldy	#{val}
	sty	{var}
	endm
;--------------------------------------------------------------------
km_lobstavar	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{dest}
	and	#$ff
	sta.\0	{dest}

	elseif

	lda.\0	{sour}
	and	#$ff
	sta.\0	{dest}

	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_hibstavar	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{dest}
	and	#$ff00
	sta.\0	{dest}

	elseif

	lda.\0	{sour}
	and	#$ff00
	sta.\0	{dest}

	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_lobswapstavar	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{dest}
	and	#$ff
	xba
	sta.\0	{dest}

	elseif

	lda.\0	{sour}
	and	#$ff
	xba
	sta.\0	{dest}

	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_hibswapstavar	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1
	lda.\0	{dest}
	and	#$ff00
	xba
	sta.\0	{dest}

	elseif

	lda.\0	{sour}
	and	#$ff00
	xba
	sta.\0	{dest}

	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_sexstavar	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_chga16

	ifeq	narg-1

	lda.\0	{dest}
	bit	#$0080
	beq	.plas\@
	ora	#$ff00
	bra	.end\@
.plas\@
	and	#$00ff
.end\@
	sta.\0	{dest}

	elseif

	lda.\0	{sour}
	bit	#$0080
	beq	.plas\@
	ora	#$ff00
	bra	.end\@
.plas\@
	and	#$00ff
.end\@
	sta.\0	{dest}

	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_negstavar	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1
	lda.\0	{dest}
	nega
	sta.\0	{dest}

	elseif

	lda.\0	{sour}
	nega
	sta.\0	{dest}
	endc
	endm
;--------------------------------------------------------------------
km_negswapsta	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1
	lda.\0	{dest}
	nega
	xba
	sta.\0	{dest}

	elseif

	lda.\0	{sour}
	nega
	xba
	sta.\0	{dest}

	endc
	endm
;--------------------------------------------------------------------
km_absstavar	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1

	lda.\0	{dest}
	bpl	.skip\@
	nega
	sta.\0	{dest}
.skip\@
	elseif
	lda.\0	{sour}
	bpl	.skip\@
	nega
.skip\@
	sta.\0	{dest}

	endc
	endm
;--------------------------------------------------------------------
km_addstavarvar 	macro	[dest,addvar,sour]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-2
	lda.\0	{dest}
	clc
	adc.\0	{addvar}
	sta.\0	{dest}
	ELSEIF
	lda.\0	{sour}
	clc
	adc.\0	{addvar}
	sta.\0	{dest}
	ENDC
	endm
;--------------------------------------------------------------------
km_substavarvar	macro	[dest,subvar,sour]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFEQ	NARG-2
	lda.\0	{dest}
	sec
	sbc.\0	{subvar}
	sta.\0	{dest}
	ELSEIF
	lda.\0	{sour}
	sec
	sbc.\0	{subvar}
	sta.\0	{dest}
	ENDC
	ENDM

;	IFEQ	1
;_tmpreg_{reg} = 0
;_tmpreg_y = 1
;	IFEQ	_tmpreg_{reg}-_tmpreg_y
;	ifc	"\0","L"
;	error	<Sorry Can't do .l with Y>
;	endc
;	ENDC
;
;	lda.\0	{var},{reg}
;	sec
;	sbc.\0	{subvar}
;	sta.\0	{var},{reg}
;	ENDC
;
;	endm
;--------------------------------------------------------------------
km_addstavarval 	macro	[dest,addval,sour]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-2
	lda.\0	{dest}
	clc
	adc	#{addval}
	sta.\0	{dest}
	ELSEIF
	lda.\0	{sour}
	clc
	adc	#{addval}
	sta.\0	{dest}
	ENDC
	endm
;--------------------------------------------------------------------
km_substavarval	macro	[dest,subval,sour]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFEQ	NARG-2
	lda.\0	{dest}
	sec
	sbc	#{subval}
	sta.\0	{dest}
	ELSEIF
	lda.\0	{sour}
	sec
	sbc	#{subval}
	sta.\0	{dest}
	ENDC
	ENDM
;--------------------------------------------------------------------
km_addstaval	macro	[var,val,reg]
	IFNE	NARG<3

	lda.\0	{var}
	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc
	sta.\0	{var}

	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	sta.\0	{var},{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_substaval	macro	[var,val,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG<3

	lda.\0	{var}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	sta.\0	{var}

	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	sta.\0	{var},{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_orastaval	macro	[var,val,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG<3

	lda.\0	{var}
	ora	#{val}
	sta.\0	{var}

	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	ora	#{val}
	sta.\0	{var},{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_addmax	macro	[var,val,max,reg]
MYNARG	=	NARG
	CHK_NARG	3,4
; !! val no atai wo kiotukenaito owaranaku naru !!

	IFNE	NARG<4
	lda.\0	{var}
	cmp	#{max}
	beq	.nosetval\@

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	sta.\0	{var}
.nosetval\@
;* register version *
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC


	lda.\0	{var},{reg}
	cmp	#{max}
	beq	.nosetval\@

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	sta.\0	{var},{reg}
.nosetval\@
	ENDC
	endm
;--------------------------------------------------------------------
km_addgtumax	macro	[var,val,max,reg]
MYNARG	=	NARG
	CHK_NARG	3,4

	IFNE	NARG<4
	lda.\0	{var}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc
	cmp	#{max}
	bcc	.staval\@
	lda	#{max}
.staval\@
	sta.\0	{var}

;* register version *
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	cmp	#{max}
	bcc	.staval\@
	lda	#{max}
.staval\@
	sta.\0	{var},{reg}

	ENDC
	endm
;--------------------------------------------------------------------
km_addgtsmax	macro	[var,val,max,reg]
MYNARG	=	NARG
	CHK_NARG	3,4

	IFNE	NARG<4
	lda.\0	{var}
	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc
	cmp	#{max}
	bmi	.staval\@
	lda	#{max}
.staval\@
	sta.\0	{var}

;* register version *
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC


	lda.\0	{var},{reg}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	cmp	#{max}
	bmi	.staval\@
	lda	#{max}
.staval\@
	sta.\0	{var},{reg}

	ENDC
	endm


;--------------------------------------------------------------------
km_addmaxtomin	macro	[var,val,max,min,reg]
MYNARG	=	NARG
	CHK_NARG	4,5

	IFNE	NARG<5

	lda.\0	{var}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	cmp	#{max}
	bne	.notmax\@
	lda	#{min}
.notmax\@
	sta.\0	{var}
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC


	lda.\0	{var},{reg}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	cmp	#{max}
	bne	.notmax\@
	lda	#{min}
.notmax\@
	sta.\0	{var},{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_addgeumaxtomin	macro	[var,val,max,min,reg]
MYNARG	=	NARG
	CHK_NARG	4,5

	IFNE	NARG<5

	lda.\0	{var}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	cmp	#{max}
	bcc	.notmax\@
	lda	#{min}
.notmax\@
	sta.\0	{var}
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	cmp	#{max}
	bcc	.notmax\@
	lda	#{min}
.notmax\@
	sta.\0	{var},{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_addgesmaxtomin	macro	[var,val,max,min,reg]
MYNARG	=	NARG
	CHK_NARG	4,5

	km_memchecka8i16
	IFNE	NARG<5

	lda.\0	{var}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	cmp	#{max}
	bmi	.notmax\@
	lda	#{min}
.notmax\@
	sta.\0	{var}
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}

	ifc	"1","{val}"
	inc	a
	elseif
	clc
	adc	#{val}
	endc

	cmp	#{max}
	bmi	.notmax\@
	lda	#{min}
.notmax\@
	sta.\0	{var},{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_subvarto0	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1
	lda.\0	{var}
	beq	.skip\@
	dec	a
	sta.\0	{var}
.skip\@
	elseif
	lda.\0	{var},{reg}
	beq	.skip\@
	dec	a
	sta.\0	{var},{reg}
.skip\@
	endc

	endm
;--------------------------------------------------------------------
km_submin	macro	[var,val,min]
MYNARG	=	NARG
	CHK_NARG	3

	lda.\0	{var}

	ifeq	narg-3
	ifnc	"0","{min}"
	cmp	#{min}
	endc
	endc

	beq	.noset\@
	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	sta.\0	{var}
.noset\@
	endm
;--------------------------------------------------------------------
km_subltumin	macro	[var,val,min]
MYNARG	=	NARG
	CHK_NARG	3

	lda.\0	{var}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc
	cmp	#{min}
	bcs	.set\@
	lda	#{min}
.set\@
	sta.\0	{var}
	endm
;--------------------------------------------------------------------
km_substavarltsmin	macro	[var,var2,min]
MYNARG	=	NARG
	CHK_NARG	3

	lda.\0	{var}
	sec
	sbc.\0	{var2}
	cmp	#{min}
	bpl	.set\@
	lda	#{min}
.set\@
	sta.\0	{var}
	endm
;--------------------------------------------------------------------
km_substavalltsmin	macro	[var,val,min]
MYNARG	=	NARG
	CHK_NARG	3

	lda.\0	{var}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	cmp	#{min}
	bpl	.set\@
	lda	#{min}
.set\@
	sta.\0	{var}
	endm
;--------------------------------------------------------------------
km_submintomax	macro	[var,val,min,max,reg]
MYNARG	=	NARG
	CHK_NARG	4,5

	IFNE	NARG<5
	lda.\0	{var}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	cmp	#{min}
	bne	.notmin\@
	lda	#{max}
.notmin\@
	sta.\0	{var}
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC


	lda.\0	{var},{reg}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	cmp	#{min}
	bne	.notmin\@
	lda	#{max}
.notmin\@
	sta.\0	{var},{reg}

	ENDC
	endm
;--------------------------------------------------------------------
km_subltumintomax	macro	[var,val,min,max,reg]
MYNARG	=	NARG
	CHK_NARG	4,5

	IFNE	NARG<5
	lda.\0	{var}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	cmp	#{min}
	bcs	.notmin\@
	lda	#{max}
.notmin\@
	sta.\0	{var}
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC


	lda.\0	{var},{reg}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	cmp	#{min}
	bcs	.notmin\@
.min\@
	lda	#{max}
.notmin\@
	sta.\0	{var},{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_subltsmintomax	macro	[var,val,min,max,reg]
MYNARG	=	NARG
	CHK_NARG	4,5

	IFNE	NARG<5
	lda.\0	{var}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	cmp	#{min}
	bpl	.notmin\@
	lda	#{max}
.notmin\@
	sta.\0	{var}
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC


	lda.\0	{var},{reg}

	ifc	"1","{val}"
	dec	a
	elseif
	sec
	sbc	#{val}
	endc

	cmp	#{min}
	bpl	.notmin\@
.min\@
	lda	#{max}
.notmin\@
	sta.\0	{var},{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_aslsta	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2
	IFEQ	NARG-1
	lda.\0	{dest}
	asl	a
	sta.\0	{dest}
	ELSEIF
	lda.\0	{sour}
	asl	a
	sta.\0	{dest}
	ENDC
	endm
;--------------------------------------------------------------------
km_lsrsta	macro	[dest,sour]
MYNARG	=	NARG
	CHK_NARG	1,2
	IFEQ	NARG-1
	lda.\0	{dest}
	lsr	a
	sta.\0	{dest}
	ELSEIF
	lda.\0	{sour}
	lsr	a
	sta.\0	{dest}
	ENDC
	endm
;--------------------------------------------------------------------
km_aslreg	macro	[reg]
;Init :Acc
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in long I mode%n"
	error+
	ENDC

	IFEQ	LONGA
	a16
	and	#$00ff
	asl	a
	ta{reg}
	a8

	elseif
	asl	a
	ta{reg}
	ENDC
	endm
;--------------------------------------------------------------------
km_lldx	macro	[work]

	IFEQ	LONGA

	ifeq	LONGI
;mem8,idx8
	lda.\0	{work}
	tax
	elseif
;mem8,idx16
	lda	#0
	xba
	lda.\0	{work}
	tax
	endc

	ELSEIF

	ifeq	LONGI
;mem16,idx8
	lda.\0	{work}
	tax
	elseif
;mem16,idx16
	lda.\0	{work}
	and	#$ff
	tax
	endc

	ENDC
	endm
;--------------------------------------------------------------------
km_ldaslx	macro	[work,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
;Init :Acc
	km_memchecka16
	ifeq	narg-1
	lda.\0	{work}
	elseif
	km_chkly
	lda.\0	{work},{reg}
	endc
	asl	a
	tax
	endm
;--------------------------------------------------------------------
km_lldaslx	macro	[work,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
;Init :Acc
	ifeq	narg-1
	lda.\0	{work}
	elseif
	km_chkly
	lda.\0	{work},{reg}
	endc

	km_chga16
	and	#$ff
	asl	a
	tax
	km_reta8
	endm
;--------------------------------------------------------------------
km_lldm4x	macro	[work,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
;Init :Acc
	ifeq	narg-1
	lda.\0	{work}
	elseif
	km_chkly
	lda.\0	{work},{reg}
	endc

	km_chga16
	and	#$ff
	asl	a
	asl	a
	tax
	km_reta8
	endm
;--------------------------------------------------------------------
km_ldatbl_i8x	macro	[tbl,ptr]
	km_chgi8
	ldx	{ptr}
	lda.l	{tbl},x
	km_reti16
	endm
;--------------------------------------------------------------------
km_lldy	macro	[work]
	IFEQ	LONGA

	ifeq	LONGI
;mem8,idx8
	lda.\0	{work}
	tay
	elseif
;mem8,idx16
	lda	#0
	xba
	lda.\0	{work}
	tay
	endc

	ELSEIF

	ifeq	LONGI
;mem16,idx8
	lda.\0	{work}
	tay

	elseif
;mem16,idx16
	lda.\0	{work}
	and	#$ff
	tay
	endc

	ENDC
	endm
;--------------------------------------------------------------------
km_ldasly	macro	[work,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
;Init :Acc
	km_memchecka16
	ifeq	narg-1
	lda.\0	{work}
	elseif
	km_chkly
	lda.\0	{work},{reg}
	endc
	asl	a
	tay
	endm
;--------------------------------------------------------------------
km_lldasly	macro	[work,reg]
MYNARG	=	NARG
	CHK_NARG	1,2
;Init :Acc
	ifeq	narg-1
	lda.\0	{work}
	elseif
	km_chkly
	lda.\0	{work},{reg}
	endc

	km_chga16
	and	#$ff
	asl	a
	tay
	km_reta8
	endm
;--------------------------------------------------------------------
km_bne	macro	[addr]
	beq	.skip\@
	brl	{addr}
.skip\@
	endm
;--------------------------------------------------------------------
km_beq	macro	[addr]
	bne	.skip\@
	brl	{addr}
.skip\@
	endm
;--------------------------------------------------------------------
km_bpl	macro	[addr]
	bmi	.skip\@
	brl	{addr}
.skip\@
	endm
;--------------------------------------------------------------------
km_bmi	macro	[addr]
	bpl	.skip\@
	brl	{addr}
.skip\@
	endm
;--------------------------------------------------------------------
km_bcc	macro	[addr]
	bcs	.skip\@
	brl	{addr}
.skip\@
	endm
;--------------------------------------------------------------------
km_bcs	macro	[addr]
	bcc	.skip\@
	brl	{addr}
.skip\@
	endm
;--------------------------------------------------------------------
km_setflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG<3

	IFNC	"\0","L"

	lda	#({flag})
	tsb	{var}

	ELSEIF

	lda.\0	{var}
	ora	#({flag})
	sta.\0	{var}
	ENDC

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	ora	#({flag})
	sta.\0	{var},{reg}
	endc
	endm
;--------------------------------------------------------------------
km_setflag8	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	km_chga8
	IFNE	NARG<3

	IFNC	"\0","L"

	lda	#({flag})
	tsb	{var}

	ELSEIF

	lda.\0	{var}
	ora	#({flag})
	sta.\0	{var}
	ENDC

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	ora	#({flag})
	sta.\0	{var},{reg}
	endc
	km_reta16

	endm
;--------------------------------------------------------------------
km_setflag16	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	km_chga16
	IFNE	NARG<3

	IFNC	"\0","L"

	lda	#({flag})
	tsb	{var}

	ELSEIF

	lda.\0	{var}
	ora	#({flag})
	sta.\0	{var}
	ENDC

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	ora	#({flag})
	sta.\0	{var},{reg}
	endc
	km_reta8

	endm
;--------------------------------------------------------------------
km_clrflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG<3

		IFNC	"\0","L"

	lda	#({flag})
	trb	{var}

		ELSEIF

	lda.\0	{var}
	and	#({flag})^(-1)
	sta.\0	{var}
		ENDC

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#({flag})^(-1)
	sta.\0	{var},{reg}
	endc	
	endm
;--------------------------------------------------------------------
km_clrflag16	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	km_chga16
	IFNE	NARG<3
		IFNC	"\0","L"

	lda	#({flag})
	trb	{var}

		ELSEIF

	lda.\0	{var}
	and	#({flag})^(-1)
	sta.\0	{var}
		ENDC

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#({flag})^(-1)
	sta.\0	{var},{reg}
	endc	
	km_reta8
	endm
;--------------------------------------------------------------------
km_andflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	and	#({flag})
	sta.\0	{var}

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#({flag})
	sta.\0	{var},{reg}
	endc	
	endm
;--------------------------------------------------------------------
km_eorflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG<3

	lda.\0	{var}
	eor	#({flag})
	sta.\0	{var}

	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	eor	#({flag})
	sta.\0	{var},{reg}

	ENDC

	endm
;--------------------------------------------------------------------
km_eorflag16	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	km_chga16
	IFNE	NARG<3

	lda.\0	{var}
	eor	#({flag})
	sta.\0	{var}
	ELSEIF

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	eor	#({flag})
	sta.\0	{var},{reg}

	ENDC
	km_reta8

	endm
;--------------------------------------------------------------------
km_bitcheck	macro	[var,val,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	bit	#{val}

	elseif
_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	bit	#{val}
	endc
	endm
;--------------------------------------------------------------------
km_bitcheckflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	bit	#({flag})

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	bit	#({flag})
	endc
	endm
;--------------------------------------------------------------------
km_bitcheckflag16	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	km_chga16

	IFNE	NARG<3
	lda.\0	{var}
	bit	#({flag})

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	bit	#({flag})
	endc
	km_reta8
	endm
;--------------------------------------------------------------------
km_cmpcheck	macro	[var,val,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	cmp	#({val})
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	cmp	#({val})
	endc
	endm
;--------------------------------------------------------------------
km_cmpcheckval	macro	[var,val,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	cmp	#({val})
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	cmp	#({val})
	endc
	endm
;--------------------------------------------------------------------
km_andcmpcheck	macro	[var,flags,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	and	#({flags})
	cmp	#({flags})
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#({flags})
	cmp	#({flags})
	endc
	endm
;--------------------------------------------------------------------
km_andcmpcheckflag	macro	[var,flags,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	and	#({flags})
	cmp	#({flags})
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#({flags})
	cmp	#({flags})
	endc
	endm
;--------------------------------------------------------------------
km_cmpcheckflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	cmp	#({flag})
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	cmp	#({flag})
	endc
	endm
;--------------------------------------------------------------------
km_andcheckflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	and	#({flag})

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#({flag})
	endc
	endm
;--------------------------------------------------------------------
km_checknotflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	and	#({flag})^(-1)

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	and	#({flag})^(-1)
	endc
	endm
;--------------------------------------------------------------------
km_bitchecknotflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3
	IFNE	NARG<3
	lda.\0	{var}
	bit	#({flag})^(-1)

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	bit	#({flag})^(-1)
	endc
	endm
;--------------------------------------------------------------------
km_cmpchecknotflag	macro	[var,flag,reg]
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG<3
	lda.\0	{var}
	cmp	#({flag})^(-1)

	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	cmp	#({flag})^(-1)
	endc
	endm
;--------------------------------------------------------------------
km_jmpflag	macro	[var,flag,jmp_adr,reg]
	IFNE	NARG<4
	lda.\0	{var}
	bit	#({flag})
	beq	.skip\@
	jmp	{jmp_adr}
.skip\@
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	bit	#({flag})
	beq	.skip\@
	jmp	{jmp_adr}
.skip\@
	endc
	endm
;--------------------------------------------------------------------
km_jmpnotflag	macro	[var,flag,jmp_adr,reg]
	IFNE	NARG<4
	lda.\0	{var}
	bit	#({flag})
	bne	.skip\@
	jmp	{jmp_adr}
.skip\@
	elseif

_tmpreg_{reg} = 0
_tmpreg_y = 1
	IFEQ	_tmpreg_{reg}-_tmpreg_y
	ifc	"\0","L"
	error	<Sorry Can't do .l with Y>
	endc
	ENDC

	lda.\0	{var},{reg}
	bit	#({flag})
	bne	.skip\@
	jmp	{jmp_adr}
.skip\@
	endc
	endm
;--------------------------------------------------------------------
km_jmpflag_a	macro	[flag,jmp_adr]
	bit	#({flag})
	beq	.skip\@
	jmp	{jmp_adr}
.skip\@
	endm
;--------------------------------------------------------------------
km_jmpnotflag_a	macro	[flag,jmp_adr]
	bit	#({flag})
	bne	.skip\@
	jmp	{jmp_adr}
.skip\@
	endm
;--------------------------------------------------------------------
km_jmpind	macro	[addr,reg]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	t{reg}a
	clc
	adc	mmx_ramprogptr
	clc
	adc	#{addr}&WM
	ta{reg}
	lda.w	0,{reg}
	clc
	adc	mmx_ramprogptr
	sta	kmwork
	km_reta8
	jmp	(kmwork)
	endm
;--------------------------------------------------------------------
km_jsr	macro	[addr]
	per	(.rts\@)-1
	brl	{addr}
.rts\@
	endm
;--------------------------------------------------------------------
km_jsrind	macro	[addr,reg]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	t{reg}a
	clc
	adc	mmx_ramprogptr
	clc
	adc	#{addr}&WM
	ta{reg}
	lda.w	0,{reg}
	clc
	adc	mmx_ramprogptr
	sta	kmwork
	km_reta8
	per	(.rts\@)-1
	jmp	(kmwork)
.rts\@
	endm
;--------------------------------------------------------------------
km_jsl	macro	[addr]
;* ROM Access wo shinai jsl *
_rambank = $7e
	sta	kmwork	;pha
	km_chga8
	lda	#_rambank
	pha
	per	(.ret\@-1)

	lda	#({addr})>>16
	pha
	pea	({addr}-1)&WM
	km_reta16
	lda	kmwork	;pla
	rtl
.ret\@
	endm
;--------------------------------------------------------------------
km_braareaout	macro	[min,max,addr]
;0=< var+min < max   (area IN)  :max = 2*min
;!!!! 0< var < $3fff (16383)!!!!
MYNARG	=	NARG
	CHK_NARG	3
	clc
	adc	{min}
	bmi	{addr}
;;;	beq	{addr}
	cmp	{max}
	bpl	{addr}
	endm
;--------------------------------------------------------------------
km_brlareaout	macro	[min,max,addr]
;0=< var+min < max   (area IN)  :max = 2*min
;!!!! 0< min < $3fff (16383)!!!!
MYNARG	=	NARG
	CHK_NARG	3
	clc
	adc	{min}
	bmi	.areaout\@
	cmp	{max}
	bmi	.areain\@
.areaout\@
	brl	{addr}
.areain\@
	endm
;--------------------------------------------------------------------
km_fdecsta_alvar	macro	[size,obj1,alvar,flag]
MYNARG	=	NARG
	CHK_NARG	4
	CHK_OBJ		{obj1}
	CHG_MODE	{size}
	s_lda	{alvar},{obj1}
	and	#({flag})^(-1)
	dec	a
	ora	#({flag})
	s_sta	{alvar},{obj1}
	CHG_MODEBACK	{size}
	endm
;--------------------------------------------------------------------
km_fdec_alvar	macro	[size,obj1,alvar,flag]
MYNARG	=	NARG
	CHK_NARG	4
	CHK_OBJ		{obj1}
	CHG_MODE	{size}
	s_lda	{alvar},{obj1}
	and	#({flag})^(-1)
	dec	a
	CHG_MODEBACK	{size}
	endm
;--------------------------------------------------------------------
km_fdecbne_alvar	macro	[size,obj1,alvar,flag,addr]
MYNARG	=	NARG
	CHK_NARG	5
	CHK_OBJ		{obj1}
	CHG_MODE	{size}
	s_lda	{alvar},{obj1}
	and	#({flag})^(-1)
	dec	a
	ora	#({flag})
	s_sta	{alvar},{obj1}
	rlbne	{addr}
	CHG_MODEBACK	{size}
	endm
;--------------------------------------------------------------------
BlockCopy	macro	[size,source,dest]
;Init
;Xreg :dtata pointer
;Yreg :sprites pointer

MYNARG	=	NARG
	CHK_NARG	3
knumber = 0

	ifc	"b","{size}"
knumber = 1
	endc

	ifc	"B","{size}"
knumber = 1
	endc

	ifc	"w","{size}"
knumber = 2
	endc
	ifc	"W","{size}"
knumber = 2
	endc

	ifeq	knumber
	printf	"Error:Should set B(b) or W(w)\n"
	error+
	endc

	savemode
	ifeq	knumber-1
	a16
	lda.l	{source},x
	sta	kmwork		;transfer Value
	a8
.loop\@
	lda.l	{source}+2,x
	sta	{dest},y
	inx
	iny

	dec	kmwork
	bne	.loop\@

	elseif

	a16
	lda.l	{source},x
	sta	kmwork		;transfer Value
.loop\@
	lda.l	{source}+2,x
	sta	{dest},y
	inx
	inx
	iny
	iny
	dec	kmwork
	dec	kmwork
	bne	.loop\@
	endc

	returnmode
	endm
;--------------------------------------------------------------------
BlockCopyOffset	macro	[size,source,dest,hosei]
MYNARG	=	NARG
	CHK_NARG	4
;Init
;Xreg :dtata pointer
;Yreg :sprites pointer
knumber = 0

	ifc	"b","{size}"
knumber = 1
	endc

	ifc	"B","{size}"
knumber = 1
	endc

	ifc	"w","{size}"
knumber = 2
	endc
	ifc	"W","{size}"
knumber = 2
	endc

	ifeq	knumber
	printf	"Error:Should set B(b) or W(w)\n"
	error+
	endc

	savemode
	ifeq	knumber-1
	a16
	lda.l	{source},x
	sta	kmwork		;transfer Value
	a8
.loop\@
	lda.l	{source}+2,x
	clc
	adc	{hosei}
	sta	{dest},y
	inx
	iny

	dec	kmwork
	bne	.loop\@

	elseif

	a16
	lda.l	{source},x
	sta	kmwork		;transfer Value
.loop\@
	lda.l	{source}+2,x
	clc
	adc	{hosei}
	sta	{dest},y
	inx
	inx
	iny
	iny
	dec	kmwork
	dec	kmwork
	bne	.loop\@
	endc

	returnmode
	endm
;--------------------------------------------------------------------
km_mvn	macro	[moto,saki]
	phb
	db	$54
	db	({saki})>>16
	db	({moto})>>16
	plb
	endm
;--------------------------------------------------------------------
km_blocktrans macro	[source_adr,dest_adr,trans_value]

;* mario RAM address niwa tukaenai *
;;;_sbank	=	({source_adr})>>16
;;;_dbank	=	({dest_adr})>>16

	phy
	phx
	pha

	savemode
	ai16
	ldx	#({source_adr})&WM
	ldy	#({dest_adr})&WM
	lda	#({trans_value})-1
	phb
	db	$54
	db	({dest_adr})>>16
	db	({source_adr})>>16
	plb
	returnmode

	pla
	plx
	ply
	endm
;--------------------------------------------------------------------
km_blocktransX macro	[source_adr,dest_adr,trans_value]
_sbank	=	({source_adr})>>16
_dbank	=	({dest_adr})>>16
;* Init :Xreg :source pointer
	phy
	phx
	pha

	savemode

	ai16
	txa
	clc
	adc	#({source_adr})&WM
	tax	

	ldy	#({dest_adr})&WM
	lda	#({trans_value})-1
	phb
	db	$54
	db	_dbank
	db	_sbank
	plb
	returnmode

	pla
	plx
	ply
	endm
;--------------------------------------------------------------------
km_blocktransY macro	[source_adr,dest_adr,trans_value]
_sbank	=	({source_adr})>>16
_dbank	=	({dest_adr})>>16
;* Init :Yreg :dest pointer
	phy
	phx
	pha

	savemode

	ai16
	ldx	#({source_adr})&WM
	tya
	clc
	adc	#({dest_adr})&WM
	tay
	lda	#({trans_value})-1
	phb
	db	$54
	db	_dbank
	db	_sbank
	plb
	returnmode

	pla
	plx
	ply
	endm
;--------------------------------------------------------------------
km_blocktransXY macro	[source_adr,dest_adr,trans_value]
_sbank	=	({source_adr})>>16
_dbank	=	({dest_adr})>>16
;* Init :Xreg :source pointer
	phy
	phx
	pha

	savemode

	ai16
	txa
	clc
	adc	#({source_adr})&WM
	tax

	tya
	clc
	adc	#({dest_adr})&WM
	tay	

	lda	#({trans_value})-1
	phb
	db	$54
	db	_dbank
	db	_sbank
	plb
	returnmode

	pla
	plx
	ply
	endm
;--------------------------------------------------------------------
blocktrans_sub	macro	[source_adr,dest_adr,trans_value]
_sbank	=	({source_adr})>>16
_dbank	=	({dest_adr})>>16

	ldx	#({source_adr})&WM
	ldy	#({dest_adr})&WM
	lda	#({trans_value})-1
	phb
	db	$54
	db	_dbank
	db	_sbank
	plb
	endm
;--------------------------------------------------------------------
km_clralc	macro	[addr]
	savemode
	AI16
	stz	{addr}start

	ldx	#({addr}start)&WM
	ldy	#({addr}start+1)&WM
	lda	#{addr}end-{addr}start-1-1
	phb
	db	$54
	db	0
	db	0
	plb
	returnmode
	endm

;--------------------------------------------------------------------
km_clrxalc	macro	[addr]
	savemode
	AI16
	lda	#0
	sta.l	{addr}start

	ldx	#({addr}start)&WM
	ldy	#({addr}start+1)&WM
	lda	#{addr}end-{addr}start-1-1

	phb
	db	$54
	db	$7e
	db	$7e
	plb

	returnmode
	endm
;* RAM CLEAR no QUICK VERSION (tadashi 8 no baisuu ni kagiru) *

	ifeq	1
	ai16
	ldx	#0
	ldy	#({addr}end-{addr}start+1)/8

	lda	#0
.loop\@
	sta.l	{addr}start+0,x
	sta.l	{addr}start+2,x
	sta.l	{addr}start+4,x
	sta.l	{addr}start+6,x

	dey
	beq	.end\@
	txa
	clc
	adc	#8
	tax
	bra	.loop\@
.end\@
	endc

;--------------------------------------------------------------------
km_clrWRAM	macro	[addr,len]
	savemode
	AI16
	lda	#0
	sta.l	{addr}

	ldx	#{addr}&WM
	ldy	#({addr}+1)&WM
	lda	#{len}-1-1

	phb
	db	$54
	db	{addr}>>16
	db	{addr}>>16
	plb
	returnmode
	endm
;--------------------------------------------------------------------
km_clrKAWARAM	macro			;kawaguchi work RAM clear
	jsl	clear_kawaram_l	;(intro.asm)
	endm

;*********************************************************************
;*								*
;*			JOY PAD MACROS				*
;*								*
;*********************************************************************
km_readkeydown	macro
	lda	cont0
	endm
;----------------------------------------------------------------------
km_readkeydown_h	macro
	km_memchecka8
	lda	cont0+1
	endm
;----------------------------------------------------------------------
km_readjoypad	macro
	lda	trig0
	endm
;----------------------------------------------------------------------
km_readjoypad_h	macro
	km_memchecka8
	lda	trig0+1
	endm
;----------------------------------------------------------------------
km_testkeydown	macro	[keyflag]
	km_chga16
	lda	cont0
	bit	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_testkeydown2	macro	[keyflag]
	km_chga16
	lda	cont1
	bit	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_testjoypad	macro	[keyflag]
	km_chga16
	lda	trig0
	bit	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_testjoypad2	macro	[keyflag]
	km_chga16
	lda	trig1
	bit	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_cmpkeydown	macro	[keyflag]
	km_chga16
	lda	cont0
	cmp	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_cmpkeydown2	macro	[keyflag]
	km_chga16
	lda	cont1
	cmp	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_cmpjoypad	macro	[keyflag]
	km_chga16
	lda	trig0
	cmp	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_acmpkeydown	macro	[keyflag]
	km_chga16
	lda	cont0
	and	#pad_{keyflag}
	cmp	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_acmpjoypad	macro	[keyflag]
	km_chga16
	lda	trig0
	and	#pad_{keyflag}
	cmp	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_acmpkeydown2	macro	[keyflag]
	km_chga16
	lda	cont1
	and	#pad_{keyflag}
	cmp	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_acmpjoypad2	macro	[keyflag]
	km_chga16
	lda	trig1
	and	#pad_{keyflag}
	cmp	#pad_{keyflag}
	km_reta8
	endm
;----------------------------------------------------------------------
km_setkeystates	macro	[cont]
	savemode

	IFEQ	LONGA
	a16
	endc

	lda	trig{cont}
	and	#$f0ff
	sta	keystates		;A,X,B,Y,sel,start

;* trigger flag check *
	lda	autotrig{cont}
	bit	#$0080
	beq	.notrigger\@
	and	#$0f
	xba				;jyuuji key
	bra	.set\@
.notrigger\@
	lda	#0
.set\@
	ora	keystates
	sta	keystates
	returnmode
	endm
;----------------------------------------------------------------------
km_checkjoypad	macro	[keyflag]
;Init :keystates wo arakajime set shiteoku 
	IFEQ	LONGA
	a16
	lda	keystates
	bit	#pad_{keyflag}
	a8
	ELSEIF
	lda	keystates
	bit	#pad_{keyflag}
	ENDC
	endm
;----------------------------------------------------------------------
km_testautotrig	macro	[keyflag]

	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short A mode%n"
	error+
	ENDC

	km_bitcheckflag	autotrig0,triggerflag
	beq	.end\@		;moshi trig ga tatteinakattara
	km_bitcheckflag	autotrig0,padl_{keyflag}
.end\@
	endm
;----------------------------------------------------------------------
km_testautotrig2	macro	[keyflag]

	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short A mode%n"
	error+
	ENDC

	km_bitcheckflag	autotrig1,triggerflag
	beq	.end\@		;moshi trig ga tatteinakattara
	km_bitcheckflag	autotrig1,padl_{keyflag}
.end\@
	endm
;----------------------------------------------------------------------
km_autotrigread	macro
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short A mode%n"
	error+
	ENDC

	lda	cont0+1
	sta	keystates
	lda	autokeytm1
	sta	autokeytm
	lda	autotrig0
	sta	autotrig

	jsl	autotrigger_l

	lda	autokeytm
	sta	autokeytm1
	lda	autotrig
	sta	autotrig0
	endm
;----------------------------------------------------------------------
km_autotrigread2	macro
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short A mode%n"
	error+
	ENDC

	lda	cont1+1
	sta	keystates
	lda	autokeytm2
	sta	autokeytm
	lda	autotrig1
	sta	autotrig

	jsl	autotrigger_l

	lda	autokeytm
	sta	autokeytm2
	lda	autotrig
	sta	autotrig1
	endm
;----------------------------------------------------------------------
km_setgmkeydown	macro
	km_memchecka16
	lda	cont0
	ora	mmw_keydown
	sta	mmw_keydown
	endm
;----------------------------------------------------------------------
km_setgmjoypad	macro
	km_memchecka16
	lda	trig0
	ora	mmw_trigger
	sta	mmw_trigger
	endm
;----------------------------------------------------------------------
km_clrgmkeydown	macro
	km_memchecka16
	stz	mmw_keydown
	endm
;----------------------------------------------------------------------
km_clrgmjoypad	macro
	km_memchecka16
	stz	mmw_trigger
	endm
;----------------------------------------------------------------------
km_testgmjoypad	macro	[keyflag]
	km_chga16
	lda	mmw_trigger
	bit	#pad_{keyflag}
	km_reta8
	endm
;*********************************************************************
;*			CPU Macros				*
;*********************************************************************
km_waittrans	macro
.\@	lda	trans_flag
;;;;	cmp	#iv_irqkawablank
	bne	.\@
	endm
;---------------------------------------------------------------------
kwaitvbl	macro
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in SHORTA mode%n"
	error+
	ENDC
.wait\@
	lda	hvbjoyr
	bit	#128
	beq	.wait\@
	endm
;---------------------------------------------------------------------
km_Vcountread	macro
;Out put :Acc
	km_memchecka8i16

	lda.l	slhvr
	lda.l	opvctr
	xba

	lda.l	opvctr
	and	#1
	xba
	sta.l	kbugwork
	endm
;---------------------------------------------------------------------
km_Vcountstart	macro
	km_Vcountread
	tax
	stx	kw_vtimestart
	endm
;---------------------------------------------------------------------
km_Vcountend	macro
	km_Vcountread
	a16
	sec
	sbc	kw_vtimestart
	bpl	.skip\@
	clc
	adc	#262
.skip\@	sta	kw_vtimeend
	a8
	endm

;---------------------------------------------------------------------
km_IRQenable	macro	[flag,vcnt]
MYNARG	=	NARG
	CHK_NARG	1,2
	km_memchecka8i16

	lda	#iv_{flag}
	sta	trans_flag	;[irq flag]

	ifeq	narg-1
	ldx	#240
	stx	vtimel		;irq V pos
	stx	kw_vtimel

	elseif

	ldx	#{vcnt}
	stx	vtimel		;irq V pos
	stx	kw_vtimel
	endc

	lda	#%00110001	;NMI Not Useing
	sta	nmitimen	;cont auto scan,HVcount Timer

	km_setgameflag	kawairq	;Normal IRQ

	lda	hdmaen_gc
	sta	hdmaen		;H-DMA Switch ON

	enable
	endm
;---------------------------------------------------------------------
km_irqdisable	macro

	disable

	endm
;---------------------------------------------------------------------
km_fademin	macro
	km_memchecka8
	lda	#0
	sta	FADE	;kw_screenfade
	endm
;---------------------------------------------------------------------
km_fademax	macro
	km_memchecka8
	lda	#$0f
	sta	FADE	;kw_screenfade
	endm
;---------------------------------------------------------------------
km_nofade	macro
	km_memchecka8
	stz	fadedir
	endm
;---------------------------------------------------------------------
km_fadestepup	macro
	km_memchecka8
	lda	#1
	sta	fadedir
	endm
;---------------------------------------------------------------------
km_fadestepdown	macro
	km_memchecka8
	lda	#-1
	sta	fadedir
	endm
;---------------------------------------------------------------------
km_qfadestepup	macro
	km_memchecka8
	lda	#2
	sta	fadedir
	endm
;---------------------------------------------------------------------
km_sfadestepup	macro	[time]
	km_memchecka8
	lda	#3
	sta	fadedir
	lda	#{time}
	sta	kw_fadetm
	sta	kw_fadetmcmp
	endm
;---------------------------------------------------------------------
km_qfadestepdown	macro
	km_memchecka8
	lda	#-2
	sta	fadedir
	endm
;---------------------------------------------------------------------
km_fadedownwait	macro
	km_memchecka8
.wait\@	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]

	lda	fade
	bne	.wait\@

	endm
;---------------------------------------------------------------------
km_fadeupwait	macro
	km_memchecka8
.wait\@	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]

	lda	fade
	cmp	#$0f
	bne	.wait\@

	endm
;---------------------------------------------------------------------
km_fadeup	macro
	km_memchecka8
	km_fademin
	km_fadestepup
	km_fadeupwait
	endm
;---------------------------------------------------------------------
km_fadedown	macro
	km_memchecka8
	km_fademax
	km_fadestepdown
	km_fadedownwait
	endm
;---------------------------------------------------------------------
km_qfadeup	macro
	km_memchecka8
	km_fademin
	km_qfadestepup
	km_fadeupwait
	endm
;---------------------------------------------------------------------
km_qfadedown	macro
	km_memchecka8
	km_fademax
	km_qfadestepdown
	km_fadedownwait
	endm
;---------------------------------------------------------------------
km_fadedowncheck	macro
	km_memchecka8

	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]
	lda	fade

	endm
;---------------------------------------------------------------------
km_fadeupcheck	macro
	km_memchecka8
	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]

	lda	fade
	cmp	#$0f

	endm
;---------------------------------------------------------------------
km_wipewait_l	macro
	km_memchecka8i16
	jsl	kwipewait_l
	endm
;---------------------------------------------------------------------
km_wipewait	macro
	km_memchecka8i16
	jsr	kwipewait
	endm
;---------------------------------------------------------------------
km_wipefadewait_l	macro
	km_memchecka8i16
	jsl	kwipefadewait_l
	endm
;---------------------------------------------------------------------
km_wipefadewait	macro
	km_memchecka8i16
	jsr	kwipefadewait
	endm
;---------------------------------------------------------------------
km_screenfade	macro	[timer]
	km_memchecka8i16
	ldx	#{timer}
	jsl	KBGMFade_l
	endm
;---------------------------------------------------------------------
km_screenon	macro
	km_memchecka8
	lda	#1
	sta	fadedir

	lda	#$0e
	sta	FADE	;kw_screenfade

	endm
;---------------------------------------------------------------------
km_screenoff	macro
	km_memcheck
;* IRQ syori wait *
;;;	km_waittrans

	phb
	pha

	lda	#0
	pha
	plb			;data bank 0

	stz	hdmaen		;HDMA OFF
	stz	hdmaen_gc

	disable			;IRQ Disable
	km_clrgameflag	kawairq	;Blank IRQ (Normal)
	stz	trans_flag	;IRQ Flag Off

;***** V-Blank Wait *****
.wait1\@
	lda	hvbjoyr
	bit	#128
	bne	.wait1\@
.wait2\@
	lda	hvbjoyr
	bit	#128
	beq	.wait2\@

	lda	#$8F
	sta	INIDISP
	sta	FADE


	pla
	plb
	endm

;---------------------------------------------------------------------
km_screenblack	macro		;fadedir <--- -1,FADE <--- 0
	km_memchecka8
	lda	#-1
	sta	fadedir
	lda	#0
	sta	FADE
	endm
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;*********************************************************************
;*			PPU Macros				*
;*********************************************************************
km_SyoriOverCheckStart	macro
	km_memchecka8i16
	phb
	lda	#0
	pha
	plb		;data bank 0

	km_testjoypad	select
	beq	.skip\@
	km_eorflag.l	kx_coladdflag,1
.skip\@
	lda.l	kx_coladdflag
	beq	.nocoladd\@

	stz	cgswsel
	lda	#%00100111
	sta	coldata
	lda	#%00001111
	sta	cgadsub

	bra	.coladdend\@
.nocoladd\@

	lda	#0
	sta	coldata
	lda	#0
	sta	cgadsub
.coladdend\@
	plb
	endm

km_SyoriOverCheckEnd		macro
	km_memchecka8i16
	phb
	lda	#0
	pha
	plb	;data bank 0

.wait2\@
	lda	hvbjoyr
	bit	#64
	beq	.wait2\@

	lda	#0
	sta	coldata
	sta	cgadsub
	plb
	endm
;---------------------------------------------------------------------
kbetascr_l	macro	[vram,adr,val]
	shorta
	longi
	lda	#$0
	sta	vmainc

	ldx	#{vram}
	stx	vmaddl

	lda	#%00001000
	sta	ch0params

	lda	#$18
	sta	ch0addrb

	ldx	#({adr})&WM
	stx	ch0addra1tl

	lda	#({adr})>>16
	sta	ch0atbank

	ldx	#{val}
	stx	ch0dataddrl

	lda	#%00000001
	sta	mdmaen
	endm
;---------------------------------------------------------------------
kbetascr_h	macro	[vram,adr,val]
	shorta
	longi
	lda	#$80
	sta	vmainc

	ldx	#{vram}
	stx	vmaddl

	lda	#%00001000
	sta	ch0params

	lda	#$19
	sta	ch0addrb

	ldx	#({adr})&WM
	stx	ch0addra1tl

	lda	#({adr})>>16
	sta	ch0atbank

	ldx	#{val}
	stx	ch0dataddrl

	lda	#%00000001
	sta	mdmaen
	endm
;*********************************************************************
;*			Mario Chip Macros			*
;*********************************************************************
km_waitmario		macro
.dowait\@	lda.l	m_sfr	;3030h
	and	#$20
	bne	.dowait\@
	endm
;*********************************************************************
;*								*
;*		SCROLL Macros					*
;*********************************************************************
km_hdmatabsHscrmode	macro	[mode,addr]
MYNARG	=	NARG
_hsm_{mode}	=	0
_hsm_direct	=	%00000010
_hsm_indirect =	%01000010

	CHK_NARG	2
	km_memchecka8i16

	ifeq	_hsm_{mode}
	printf	"Error:Should set (direct or indirect)\n"
	error+
	endc

	lda	#_hsm_{mode}
	sta	kw_hscrollmode
	ldx	#{addr}&WM
	stx	kw_hdma_hscrolladdr
	lda	#{addr}>>16
	sta	kw_hdma_hscrollbank
	endm
;----------------------------------------------------------------------
km_hdmatabsVscrmode	macro	[mode,addr]
MYNARG	=	NARG
_vsm_{mode}	=	0
_vsm_direct	=	%00000010
_vsm_indirect =	%01000010
	CHK_NARG	2

	km_memchecka8i16
	ifeq	_vsm_{mode}
	printf	"Error:Should set (direct or indirect)\n"
	error+
	endc

	lda	#_vsm_{mode}
	sta	kw_vscrollmode
	ldx	#{addr}&WM
	stx	kw_hdma_vscrolladdr
	lda	#{addr}>>16
	sta	kw_hdma_vscrollbank
	endm
;----------------------------------------------------------------------
km_hdmatabsHlength	macro	[rept]
_hsl_{rept} = 1
_hsl_repeat = 0
_hsl_notrepeat = %10000000

	km_memchecka8i16

	ifeq	_hsml_{rept}-1
	printf	"Error:Should set (repeat or notrepeat)\n"
	error+
	endc

	lda.l	xh_hscrolllength1
	and	#$7f
	ora	#_hdl_{rept}
	sta.l	xh_hscrolllength1

	lda.l	xh_hscrolllength2
	and	#$7f
	ora	#_hdl_{rept}
	sta.l	xh_hscrolllength2
	endm
;----------------------------------------------------------------------
km_ldascrollflag	macro	[flag]

	km_chga8
	lda	kw_scrollflag
	km_reta16
	endm
;----------------------------------------------------------------------
km_setscrollflag	macro	[flag,place]
MYNARG	=	NARG
	CHK_NARG	1,2
	km_chga8
;* scroll flag set *
	lda	#khvsf_{flag}
	tsb	kw_scrollflag

;* raster place set *
	ifeq	narg-2
	ifd	krsf_{place}
	lda	#krsf_{place}
	sta	kw_rastermode
	endc
	endc

	km_reta16
	endm
;----------------------------------------------------------------------
km_clrscrollflag	macro	[flag]

	km_chga8
	lda	#khvsf_{flag}
	trb	kw_scrollflag

	ifeq	1
	lda	kw_scrollflag
	and	#khvsf_{flag}^(-1)
	sta	kw_scrollflag
	endc
	km_reta16
	endm
;----------------------------------------------------------------------
km_eorscrollflag	macro	[flag]
	km_chga16
	lda	kw_scrollflag
	eor	#khvsf_{flag}
	sta	kw_scrollflag
	km_reta8
	endm
;----------------------------------------------------------------------
km_bitcheckscrollflag	macro	[flag]
	km_chga8
	lda	kw_scrollflag
	bit	#khvsf_{flag}
	km_reta16

	ENDM
;---------------------------------------------------------------------
km_setrastermode	macro	[mode]
	km_memchecka8
	lda	#krsf_{mode}
	sta	kw_rastermode
	endm
;-----------------------------------------------------------
km_setrasterptr	macro	[mode]
	km_chga16
	lda	kw_rastermode
	and	#$ff
	asl	a
	tax
	km_reta8
	a8
	endm
;*********************************************************************
;*								*
;*			GAME Macros				*
;*								*
;*********************************************************************
;=============================================================
;*		Game Data macro				*
;=============================================================
km_gamemodelist	macro
kmodept	=	0
	endm
;-------------------------------------------------------------
km_gamemode	macro	[addr,nosnd]
;;;kmode_{addr}	equ	kmodept
;;;kmodept	=	kmodept+1
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1
	dw	jump_{addr}&WM			;0 :sequence mode
	dw	(sound_{addr}-SoundTransTbl)&WM	;4 :sound mode

	elseif
	dw	jump_{addr}&WM			;0 :sequence mode
	dw	(sound_nodata-SoundTransTbl)&WM	;4 :sound mode
	endc
	endm
;-------------------------------------------------------------
km_gameptr	macro	[addr]
kmode_{addr}	equ	kmodept
kmodept	=	kmodept+1
	endm
;-------------------------------------------------------------
km_gameseqptr	macro	[addr]
	dw	jump_{addr}&WM
	endm
;-------------------------------------------------------------
km_gamescreenptr	macro	[addr]
	dw	screen_{addr}&WM
	endm
;-------------------------------------------------------------
km_gamesoundptr	macro	[addr]
	dw	(sound_{addr}-SoundTransTbl)&WM	;4 :sound mode
	endm
;=====================================================================
;*								*
;*			Game Mode Macro				*
;=====================================================================
;---------------------------------------------------------------------
;* MEMO								*
;* kw_GameMode :(WORK)Game Sequence Pointer (Max 256)		*
;---------------------------------------------------------------------
km_ldagamemode	macro
	lda	kw_GameMode
	endm
;-------------------------------------------------------------
km_ldxgamemode	macro
	ldx	kw_GameMode
	endm
;-------------------------------------------------------------
km_ldygamemode	macro
	ldy	kw_GameMode
	endm
;-------------------------------------------------------------
km_ldxaslgamemode	macro
	km_chga16
	lda	kw_GameMode
	asl	a
	tax
	km_reta8
	endm
;-------------------------------------------------------------
km_ldyaslgamemode	macro
	km_chga16
	lda	kw_GameMode
	asl	a
	tay
	km_reta8
	endm
;-------------------------------------------------------------
km_ldxsequenceptr	macro
;EXIT :Xreg	:Sequence Pointer
	km_chga16
	lda	kw_GameMode
	asl	a
	asl	a
	tax
	km_reta8
	endm
;-------------------------------------------------------------
km_stagamemode	macro
;* syoriga flag ari *
	sta	kw_GameMode
;;;	km_setgameflag	syorigae
	endm
;-------------------------------------------------------------
km_stagamemode_NoFl	macro
;* syoriga flag nashi *
	sta	kw_GameMode
	endm
;-------------------------------------------------------------
km_setgamemode	macro	[flag]
;* syoriga flag ari *
	lda	#kmode_{flag}
	sta	kw_GameMode
;;;	km_setgameflag	syorigae
	endm
;-------------------------------------------------------------
km_cmpcheckgamemode	macro	[flag]
	lda	kw_GameMode
	cmp	#kmode_{flag}
	endm
;-------------------------------------------------------------
km_statmpgamemode	macro
	sta	kw_TmpGameMode
	endm
;-------------------------------------------------------------
km_settmpgamemode	macro	[flag]
	lda	#kmode_{flag}
	sta	kw_TmpGameMode
	endm
;-------------------------------------------------------------
km_setnextgamemode	macro
	lda	kw_TmpGameMode
	sta	kw_GameMode
;;;	km_setgameflag	syorigae
	endm

;=====================================================================
;*								*
;*			Game Stage Macro			*
;=====================================================================
;-------------------------------------------------------------
km_setgamestage	macro	[label]		;KGameMapPtr <--- Stage No
	lda	#stg_{label}
	sta	KGameMapPtr
	endm
;-------------------------------------------------------------
km_cmpcheckgamestage	macro	[flag]
	lda	kGameMapPtr
	cmp	#stg_{flag}
	endm
;=====================================================================
;*								*
;*			Game Syori Macro			*
;=====================================================================
;-------------------------------------------------------------
km_setgamesyori	macro	[flag]
	lda	#kgamef_{flag}
	sta	kw_GameSyori
	endm
;-------------------------------------------------------------
km_cmpcheckgamesyori	macro	[flag]
	lda	kw_GameSyori
	cmp	#kgamef_{flag}
	endm
;-------------------------------------------------------------
km_ldaslxgamesyori	macro
	ifeq	1
	lda	#0		;2 cycle
	xba			;3 cycle
	lda	kw_GameSyori	;4 cycle
	a16			;2 cycle
	asl	a
	tax
	endc

	km_chga16
	lda	kw_GameSyori	;4 cycle
	and	#$ff		;2 cycle
	asl	a
	tax
	km_reta8
	endm
;-------------------------------------------------------------
km_statmpgamesyori	macro
	sta	kw_TmpGamesyori
	endm
;-------------------------------------------------------------
km_settmpgamesyori	macro	[flag]
	lda	#kgamef_{flag}
	sta	kw_TmpGamesyori
	endm
;-------------------------------------------------------------
km_setnextgamesyori	macro
	lda	kw_TmpGamesyori
	sta	kw_GameSyori
	endm
;-------------------------------------------------------------
km_pushgamesyori	macro
	lda	kw_GameSyori
	sta	kw_TmpGamesyori
	endm
;-------------------------------------------------------------
km_pullgamesyori	macro
	lda	kw_TmpGamesyori
	sta	kw_GameSyori
	endm

;=====================================================================
;*								*
;*			Demo Stage Macro			*
;=====================================================================
;-------------------------------------------------------------
km_setdemonumber	macro	[label]
;* syoriga flag ari *
	lda	#kdemo_{label}
	sta	kw_DemoNumber

	lda	#kmode_demo
	sta	kw_TmpGameMode
	endm
;-------------------------------------------------------------
km_cmpcheckdemonumber	macro	[label]
	lda	kw_DemoNumber
	cmp	#kdemo_{label}
	endm
;-------------------------------------------------------------
;=====================================================================
;*								*
;*			Game Flag Macro				*
;=====================================================================
;-------------------------------------------------------------
km_settotalflag	macro	[flag]
	km_chga16

	ifnc	"\0","L"

	lda	#ktof_{flag}
	tsb	kw_totalflag

	elseif

	lda.\0	kw_totalflag
	ora	#ktof_{flag}
	sta.\0	kw_totalflag
	endc

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrtotalflag	macro	[flag]
	km_chga16

	ifnc	"\0","L"

	lda	#ktof_{flag}
	trb	kw_totalflag

	elseif

	lda.\0	kw_totalflag
	and	#ktof_{flag}^(-1)
	sta.\0	kw_totalflag

	endc
	km_reta8
	endm
;----------------------------------------------------------------------
km_eortotalflag	macro	[flag]
	km_chga16

	lda.\0	kw_totalflag
	eor	#ktof_{flag}
	sta.\0	kw_totalflag

	km_reta8
	endm
;---------------------------------------------------------------------
km_bitchecktotalflag	macro	[flag]
	km_chga16
	lda.\0	kw_totalflag
	bit	#ktof_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmistotalflag	macro	[flag]
	km_chga16

	ifnc	"\0","L"

	lda	#kmtof_{flag}
	tsb	kw_mistotalflag

	elseif

	lda.\0	kw_mistotalflag
	ora	#kmtof_{flag}
	sta.\0	kw_mistotalflag
	endc

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmistotalflag	macro	[flag]
	km_chga16

	ifnc	"\0","L"

	lda	#kmtof_{flag}
	trb	kw_mistotalflag

	elseif

	lda.\0	kw_mistotalflag
	and	#(kmtof_{flag})^(-1)
	sta.\0	kw_mistotalflag

	endc
	km_reta8
	endm
;----------------------------------------------------------------------
km_eormistotalflag	macro	[flag]
	km_chga16

	lda.\0	kw_mistotalflag
	eor	#kmtof_{flag}
	sta.\0	kw_mistotalflag

	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmistotalflag	macro	[flag]
	km_chga16
	lda.\0	kw_mistotalflag
	bit	#kmtof_{flag}
	km_reta8
	endm

;-------------------------------------------------------------
km_setgameflag	macro	[flag]
	km_chga16

	ifnc	"\0","L"

	lda	#kgf_{flag}
	tsb	kw_gameflag

	elseif

	lda.\0	kw_gameflag
	ora	#kgf_{flag}
	sta.\0	kw_gameflag
	endc

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrgameflag	macro	[flag]
	km_chga16

	ifnc	"\0","L"

	lda	#kgf_{flag}
	trb	kw_gameflag

	elseif

	lda.\0	kw_gameflag
	and	#(kgf_{flag})^(-1)
	sta.\0	kw_gameflag

	endc
	km_reta8
	endm
;----------------------------------------------------------------------
km_eorgameflag	macro	[flag]
	km_chga16

	lda.\0	kw_gameflag
	eor	#kgf_{flag}
	sta.\0	kw_gameflag

	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckgameflag	macro	[flag]
	IFEQ	LONGA
	a16
	lda.\0	kw_gameflag
	bit	#kgf_{flag}
	a8
	ELSEIF
	lda.\0	kw_gameflag
	bit	#kgf_{flag}
	ENDC
	endm
;--------------------------------------------------------------------
km_jmpgameflag	macro	[flag,jmp_adr]
MYNARG	=	NARG
	CHK_NARG	2
	IFEQ	LONGA
	a16
	lda.\0	kw_gameflag
	bit	#kgf_{flag}
	a8
	beq	.skip\@
	jmp	{jmp_adr}
.skip\@
	ELSEIF
	lda.\0	kw_gameflag
	bit	#kgf_{flag}
	beq	.skip\@
	jmp	{jmp_adr}
.skip\@

	ENDC
	endm
;--------------------------------------------------------------------
km_jmpnotgameflag	macro	[flag,jmp_adr]
MYNARG	=	NARG
	CHK_NARG	2
	IFEQ	LONGA
	a16
	lda.\0	kw_gameflag
	bit	#kgf_{flag}
	a8
	bne	.skip\@
	jmp	{jmp_adr}
.skip\@
	ELSEIF
	lda.\0	kw_gameflag
	bit	#kgf_{flag}
	bne	.skip\@
	jmp	{jmp_adr}
.skip\@

	ENDC
	endm
;=====================================================================
;*								*
;*		Mission Player Flag Macro			*
;=====================================================================
;-------------------------------------------------------------
km_setmisplflag	macro	[flag]
	km_chga16

	lda	#kmiplf_{flag}
	tsb	kw_misplayerflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmisplflag	macro	[flag]
	km_chga16
	lda	#kmiplf_{flag}
	trb	kw_misplayerflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormisplayerflag	macro	[flag]
	km_chga16
	lda	kw_misplayerflag
	eor	#kmiplf_{flag}
	sta	kw_misplayerflag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmisplflag	macro	[flag]
	km_chga16
	lda	kw_misplayerflag
	bit	#kmiplf_{flag}
	km_reta8
	endm
;=====================================================================
;*								*
;*		Mission Map Syori Flag Macro			*
;=====================================================================
;-------------------------------------------------------------
km_setmismapsyori	macro	[syori]
	km_chga16
	lda	#mmsy_{syori}
	sta	kw_MisMapSyori
	km_reta8
	endm
;-------------------------------------------------------------
km_cmpcheckmismapsyori	macro	[syori]
	km_chga16
	lda	kw_MisMapSyori
	cmp	#mmsy_{syori}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmismapflag	macro	[flag]
	km_chga16

	lda	#kmimpf_{flag}
	tsb	kw_mismapflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmismapflag	macro	[flag]
	km_chga16
	lda	#kmimpf_{flag}
	trb	kw_mismapflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormismapflag	macro	[flag]
	km_chga16
	lda	kw_mismapflag
	eor	#kmimpf_{flag}
	sta	kw_mismapflag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmismapflag	macro	[flag]
	km_chga16
	lda	kw_mismapflag
	bit	#kmimpf_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmismapflag2	macro	[flag]
	km_chga16

	lda	#kmimpf2_{flag}
	tsb	kw_mismapflag2

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmismapflag2	macro	[flag]
	km_chga16
	lda	#kmimpf2_{flag}
	trb	kw_mismapflag2

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormismapflag2	macro	[flag]
	km_chga16
	lda	kw_mismapflag2
	eor	#kmimpf2_{flag}
	sta	kw_mismapflag2
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmismapflag2	macro	[flag]
	km_chga16
	lda	kw_mismapflag2
	bit	#kmimpf2_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmismapfzflag	macro	[flag]
	km_chga16

	lda	#kfz_{flag}
	tsb	kw_mismapfreezeflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmismapfzflag	macro	[flag]
	km_chga16
	lda	#kfz_{flag}
	trb	kw_mismapfreezeflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormismapfzflag	macro	[flag]
	km_chga16
	lda	kw_mismapfreezeflag
	eor	#kfz_{flag}
	fza	kw_mismapfreezeflag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmismapfzflag	macro	[flag]
	km_chga16
	lda	kw_mismapfreezeflag
	bit	#kfz_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmismapevflag	macro	[flag]
	km_chga16

	lda	#kev_{flag}
	tsb	kw_mismapeventflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmismapevflag	macro	[flag]
	km_chga16
	lda	#kev_{flag}
	trb	kw_mismapeventflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormismapevflag	macro	[flag]
	km_chga16
	lda	kw_mismapeventflag
	eor	#kev_{flag}
	sta	kw_mismapeventflag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmismapevflag	macro	[flag]
	km_chga16
	lda	kw_mismapeventflag
	bit	#kev_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmismapstflag	macro	[flag]
	km_chga16

	lda	#kmimpstf_{flag}
	tsb	kw_mismapstateflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmismapstflag	macro	[flag]
	km_chga16
	lda	#kmimpstf_{flag}
	trb	kw_mismapstateflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormismapstflag	macro	[flag]
	km_chga16
	lda	kw_mismapstateflag
	eor	#kmimpstf_{flag}
	sta	kw_mismapstateflag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmismapstflag	macro	[flag]
	km_chga16
	lda	kw_mismapstateflag
	bit	#kmimpstf_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmismaptrflag	macro	[flag]
	km_chga16

	lda	#ktrf_{flag}
	tsb	kx_MisMapTrigFlag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmismaptrflag	macro	[flag]
	km_chga16
	lda	#ktrf_{flag}
	trb	kx_MisMapTrigFlag

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormismaptrflag	macro	[flag]
	km_chga16
	lda	kx_MisMapTrigFlag
	eor	#ktrf_{flag}
	sta	kx_MisMapTrigFlag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmismaptrflag	macro	[flag]
	km_chga16
	lda	kx_MisMapTrigFlag
	bit	#ktrf_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmismapchflag	macro	[flag]
	km_chga16

	lda	#kchf_{flag}
	tsb	kx_MisMapChartFlag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmismapchflag	macro	[flag]
	km_chga16
	lda	#kchf_{flag}
	trb	kx_MisMapChartFlag

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormismapchflag	macro	[flag]
	km_chga16
	lda	kx_MisMapChartFlag
	eor	#kchf_{flag}
	sta	kx_MisMapChartFlag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmismapchflag	macro	[flag]
	km_chga16
	lda	kx_MisMapChartFlag
	bit	#kchf_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmismapdemoflag	macro	[flag]
	km_chga16

	lda	#kmdmf_{flag}
	tsb	kw_mismapdemoflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmismapdemoflag	macro	[flag]
	km_chga16
	lda	#kmdmf_{flag}
	trb	kw_mismapdemoflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_eormismapdemoflag	macro	[flag]
	km_chga16
	lda	kw_mismapdemoflag
	eor	#kmdmf_{flag}
	sta	kw_mismapdemoflag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmismapdemoflag	macro	[flag]
	km_chga16
	lda	kw_mismapdemoflag
	bit	#kmdmf_{flag}
	km_reta8
	endm
;-------------------------------------------------------------
km_setmissionsyori	macro	[label]
	lda	#msy_{label}
	sta	kw_MissionSyori
	endm
;-------------------------------------------------------------
km_cmpcheckmissionsyori	macro	[flag]
	lda	kw_MissionSyori
	cmp	#msy_{flag}
	endm
;-------------------------------------------------------------
km_setmissionflag	macro	[flag]
	km_chga16

	lda	#kmif_{flag}
	tsb	kw_missionflag

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrmissionflag	macro	[flag]
	km_chga16
	lda	#kmif_{flag}
	trb	kw_missionflag
	km_reta8
	endm
;----------------------------------------------------------------------
km_eormissionflag	macro	[flag]
	km_chga16
	lda	kw_missionflag
	eor	#kmif_{flag}
	sta	kw_missionflag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckmissionflag	macro	[flag]
	km_chga16
	lda	kw_missionflag
	bit	#kmif_{flag}
	km_reta8
	endm
;--------------------------------------------------------------------
km_jmpmissionflag	macro	[flag,jmp_adr]
MYNARG	=	NARG
	CHK_NARG	2
	km_memcheck
	a16
	lda	kw_missionflag
	bit	#kmif_{flag}
	a8
	beq	.skip\@
	jmp	{jmp_adr}
.skip\@
	endm
;--------------------------------------------------------------------
km_jmpnotmissionflag	macro	[flag,jmp_adr]
MYNARG	=	NARG
	CHK_NARG	2
	km_memcheck
	a16
	lda	kw_missionflag
	bit	#kmif_{flag}
	a8
	bne	.skip\@
	jmp	{jmp_adr}
.skip\@
	endm
;-------------------------------------------------------------
km_setbattlesyori	macro	[label]
	lda	#bsy_{label}
	sta	kw_BattleSyori
	endm
;-------------------------------------------------------------
km_setbattleflag	macro	[flag]

	km_chga16
	lda	#kbtf_{flag}
	tsb	kw_battleflag

	ifeq	1
	lda	kw_battleflag
	ora	#kbtf_{flag}
	sta	kw_battleflag
	endc

	km_reta8
	endm
;----------------------------------------------------------------------
km_clrbattleflag	macro	[flag]
	km_chga16

	lda	#kbtf_{flag}
	trb	kw_battleflag

	ifeq	1
	lda	kw_battleflag
	and	#kbtf_{flag}^(-1)
	sta	kw_battleflag
	endc
	km_reta8
	endm
;----------------------------------------------------------------------
km_eorbattleflag	macro	[flag]
	km_chga16

	lda	kw_battleflag
	eor	#kbtf_{flag}
	sta	kw_battleflag

	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckbattleflag	macro	[flag]
	km_chga16
	lda	kw_battleflag
	bit	#kbtf_{flag}
	km_reta8
	endm
;--------------------------------------------------------------------
km_jmpbattleflag	macro	[flag,jmp_adr]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	lda	kw_battleflag
	bit	#kbtf_{flag}
	km_reta8
	beq	.skip\@
	jmp	{jmp_adr}
.skip\@
	endm
;--------------------------------------------------------------------
km_jmpnotbattleflag	macro	[flag,jmp_adr]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	lda	kw_battleflag
	bit	#kbtf_{flag}
	km_reta8
	bne	.skip\@
	jmp	{jmp_adr}
.skip\@
	endm

;---------------------------------------------------------------------
km_setgameoverflag	macro	[flag]
	km_chga16
	lda	#kgof_{flag}
	tsb	kw_gameoverflag
	km_reta8

	ifeq	1
	lda	kgameover
	ora	#kgof_{flag}
	sta	kgameover
	endc
	endm
;----------------------------------------------------------------------
km_clrgameoverflag	macro	[flag]
	km_chga16
	lda	#kgof_{flag}
	trb	kw_gameoverflag
	km_reta8

	ifeq	1
	lda	kgameover
	and	#kgof_{flag}^(-1)
	sta	kgameover
	endc
	endm
;----------------------------------------------------------------------
km_eorgameoverflag	macro	[flag]
	km_chga16
	lda	kw_gameoverflag
	eor	#kgof_{flag}
	sta	kw_gameoverflag
	km_reta8
	endm
;---------------------------------------------------------------------
km_bitcheckgameoverflag	macro	[flag]
	km_chga16
	lda	kw_gameoverflag
	and	#kgof_{flag}
	km_reta8
	endm
;=====================================================================
;*		Sprite Mode Macros				*
;=====================================================================
km_radarscale	macro	[scale]
MYNARG	=	NARG
	CHK_NARG	1
_tmprdsl_{scale} = 0
_tmprdsl_128 = 1
_tmprdsl_512 = 2

	ifd	_tmprdsl_{scale}
	ifeq	_tmprdsl_{scale}-_tmprdsl_128
	asl	a
	endc

	ifeq	_tmprdsl_{scale}-_tmprdsl_512
	km_asra
	endc
	endc
	endm
;-------------------------------------------------------------
km_spriteptrlist	macro
ksprpt	=	0
	endm
;-------------------------------------------------------------
km_spriteptr	macro	[pointer]
ksprf_{pointer}	equ	ksprpt
ksprpt	=	ksprpt+1
	endm
;-------------------------------------------------------------
km_gamespritemode	macro	[addr]
	dw	sprites_{addr}_l&WM
	endm
;-------------------------------------------------------------
km_ldxspritemode	macro
	km_chga16
	lda	kw_spritemode
	and	#$ff
	asl	a
	tax
	km_reta8
	endm
;-------------------------------------------------------------
km_setspritemode	macro	[flag]
	lda	#ksprf_{flag}
	sta	kw_spritemode
	endm
;-------------------------------------------------------------
km_pushspritemode	macro
	lda	kw_spritemode
	sta	kw_spritetmpmode
	endm
;-------------------------------------------------------------
km_pullspritemode	macro
	lda	kw_spritetmpmode
	sta	kw_spritemode
	endm
;-------------------------------------------------------------
;-------------------------------------------------------------
;*			screen mode macros		*
;-------------------------------------------------------------
;*********************** SCREEN MODE *************************
km_screenptrlist	macro
kscrpt	=	0
	endm
;-------------------------------------------------------------
km_screenptr	macro	[pointer]
kscmf_{pointer}	equ	kscrpt
kscrpt	=	kscrpt+1
	endm
;-------------------------------------------------------------
km_gamescreenmode	macro	[addr]
	dw	screen_{addr}_l&WM
	endm
;-------------------------------------------------------------
km_ldxscreenmode	macro
	km_memchecka8i16

	a16
	lda	kw_screenmode
	and	#$ff
	asl	a
	tax
	a8
	endm
;-------------------------------------------------------------
km_setscreenmode	macro	[flag]
	km_memchecka8

	lda	#kscmf_{flag}
	sta	kw_screenmode
	endm

;*********************** SCREEN FLAG *************************
km_ldascreenflag	MACRO	[flag]

	ifeq	longa
	a16
	lda	kw_screenflag
	a8
	elseif
	lda	kw_screenflag
	endc
	ENDM

;---------------------------------------------------------------
km_setscreenflag	MACRO	[flag]
	km_chga16

	lda	#kscf_{flag}
	tsb	kw_screenflag

	ifeq	1
	lda	kw_screenflag
	ora	#kscf_{flag}
	sta	kw_screenflag
	endc
	km_reta8
	ENDM
;---------------------------------------------------------------
km_clrscreenflag	MACRO	[flag]

	km_chga16

	lda	#kscf_{flag}
	trb	kw_screenflag

	ifeq	1
	lda	kw_screenflag
	and	#kscf_{flag}^(-1)
	sta	kw_screenflag
	endc
	km_reta8
	ENDM
;----------------------------------------------------------------------
km_eorscreenflag	macro	[flag]
	km_chga16
	lda	kw_screenflag
	eor	#kscf_{flag}
	sta	kw_screenflag
	km_reta8
	endm
;---------------------------------------------------------------
km_bitcheckscreenflag	MACRO	[flag]
	km_chga16
	lda	kw_screenflag
	bit	#kscf_{flag}
	km_reta8
	ENDM
;--------------------------------------------------------------------
km_jmpscreenflag	macro	[flag,jmp_adr]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	lda	kw_screenflag
	bit	#kscf_{flag}
	km_reta8
	beq	.skip\@
	brl	{jmp_adr}
.skip\@
	endm
;--------------------------------------------------------------------
km_jmpnotscreenflag	macro	[flag,jmp_adr]
MYNARG	=	NARG
	CHK_NARG	2

	km_chga16
	lda	kw_screenflag
	bit	#kscf_{flag}
	km_reta8
	bne	.skip\@
	brl	{jmp_adr}
.skip\@
	endm
;-------------------------------------------------------------
;*			WindowFlag			*
;-------------------------------------------------------------
km_setwindowflag	MACRO	[flag]
	km_chga16
	lda	#kwinf_{flag}
	tsb	kw_windowflag
	km_reta8
	ENDM
;---------------------------------------------------------------
km_clrwindowflag	MACRO	[flag]

	km_chga16
	lda	#kwinf_{flag}
	trb	kw_windowflag
	km_reta8
	ENDM
;----------------------------------------------------------------------
km_eorwindowflag	macro	[flag]
	km_chga16
	lda	kw_windowflag
	eor	#kwinf_{flag}
	sta	kw_windowflag
	km_reta8
	endm
;---------------------------------------------------------------
km_bitcheckwindowflag	MACRO	[flag]
	km_chga16
	lda	kw_windowflag
	bit	#kwinf_{flag}
	km_reta8
	ENDM

;-------------------------------------------------------------
;*			SoundFlag			*
;-------------------------------------------------------------
km_setsndflag	MACRO	[flag]
	km_chga8
	lda	#ksf_{flag}
	tsb	kw_soundflag
	km_reta16
	ENDM
;---------------------------------------------------------------
km_clrsndflag	MACRO	[flag]
	km_chga8
	lda	#ksf_{flag}
	trb	kw_soundflag
	km_reta16
	ENDM
;----------------------------------------------------------------------
km_bitchecksndflag	MACRO	[flag]
	km_chga8
	lda	kw_soundflag
	bit	#ksf_{flag}
	km_reta16
	ENDM
;=====================================================================
;*			PLAYER MACROS				*
;=====================================================================
km_lda_playertype	macro	[player]
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short mode%n"
	error+
	ENDC

	lda	karpltype{player}
	endm

km_sta_playertype	macro	[player]
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short mode%n"
	error+
	ENDC
	sta	karpltype{player}
	endm

km_set_playertype	macro	[player,playername]
MYNARG	=	NARG
	CHK_NARG	2

	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short mode%n"
	error+
	ENDC
	lda	#kpltyf_{playername}
	sta	karpltype{player}
	endm
km_bitcheck_playertype	macro	[player,name]
MYNARG	=	NARG
	CHK_NARG	2

	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short mode%n"
	error+
	ENDC

	lda	karpltype{player}
	bit	#kpltyf_{name}
	endm

km_bitcheck_arwingtype	macro	[player,arwingtype]
MYNARG	=	NARG
	CHK_NARG	2
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in short mode%n"
	error+
	ENDC

	lda	karpltype{player}
	bit	#kawtyf_{arwingtype}
	endm
;----------------------------------------------------------------------
km_player	macro	[player,reg]
	pha
	savemode
	a16
;(a)
;	ld{reg}	playpt1

;(b)
;	ld{reg}	#viewblk{player}
;	lda.w	al_ptr,{reg}
;	ta{reg}

	s_set_objtobeplayer{player}	{reg}
	returnmode
	pla
	endm
;--------------------------------------------------------------------
km_plheapptr	macro	[player,reg]
	km_memchecki16
	s_set_objtobeplayer{player}	{reg}

	km_chga16
	lda.w	al_sword2,{reg}
	ta{reg}
	km_reta8
	endm
;--------------------------------------------------------------------
km_plheapptrSD	macro	[soureg,destreg]
	pha
	IFEQ	longa
	a16
	lda.w	al_sword2,{soureg}
	ta{destreg}
	a8
	elseif
	lda.w	al_sword2,{soureg}
	ta{destreg}
	ENDC
	pla
	endm
;--------------------------------------------------------------------
km_setplanetflag	macro	[flag,reg]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	lda.w	mmx_planetflag,{reg}
	ora	#mmpnf_{flag}
	sta.w	mmx_planetflag,{reg}
	km_reta8
	endm
;--------------------------------------------------------------------
km_setenemyflag	macro	[flag,reg]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	lda.w	mmx_enflags,{reg}
	ora	#enfl_{flag}
	sta.w	mmx_enflags,{reg}
	km_reta8
	endm
;--------------------------------------------------------------------
km_clrplanetflag	macro	[flag,reg]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	lda.w	mmx_planetflag,{reg}
	and	#(mmpnf_{flag})^(-1)
	sta.w	mmx_planetflag,{reg}
	km_reta8
	endm
;--------------------------------------------------------------------
km_clrenemyflag	macro	[flag,reg]
MYNARG	=	NARG
	CHK_NARG	2
	km_chga16
	lda.w	mmx_enflags,{reg}
	and	#(enfl_{flag})^(-1)
	sta.w	mmx_enflags,{reg}
	km_reta8
	endm
;--------------------------------------------------------------------
;--------------------------------------------------------------------
km_setstepupmode	macro	[mode,reg]
MYNARG	=	NARG
	CHK_NARG	2

	km_chga16
	lda	#stup_{mode}
	sta.w	mmx_pstepup,{reg}
	km_reta8
	endm
;--------------------------------------------------------------------
km_incstepupmode	macro	[reg]
MYNARG	=	NARG
	CHK_NARG	1
	km_chga16
	inc.w	mmx_pstepup,{reg}
	km_reta8
	endm
;--------------------------------------------------------------------
km_setsosmode	macro	[mode,reg]
MYNARG	=	NARG
	CHK_NARG	2

	km_chga16
	lda	#sos_{mode}
	sta.w	mmx_psos,{reg}
	km_reta8
	endm
;--------------------------------------------------------------------
km_incsosmode	macro	[reg]
MYNARG	=	NARG
	CHK_NARG	1

	km_chga16
	inc.w	mmx_psos,{reg}
	km_reta8
	endm

;*********************************************************************
;*			BG Macros				*
;*********************************************************************
;================== Polygon BG Screen Data Change ==================== 
km_bg1marioscrlabel	macro	[label,char,color,prio,flip]
;BG1 SCR Data (Polygon)<---- ROM CGX No,Color,Priority,Flip
_cbc	= (bg1_firstchar+(({char}&%111111100)<<2)+({char}&3)+bitmapvheight)

{label}	= _cbc!{color}!{flip}!{prio}

	endm
;---------------------------------------------------------------------
km_mariocgxlabel	macro	[label,char]
;Mario CGX No (Polygon)<---- ROM CGX No
_cbc	=	{char}

{label}	= (((_cbc&%111111100)<<2)+(_cbc&3)+bitmapvheight)

	endm
;---------------------------------------------------------------------
km_bg1mariocgx_a	macro
;BG1 Mario CGX No (Polygon)<---- ROM CGX No
	IFEQ	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in LONGA mode%n"
	error+
	ENDC

	sta	x1
	and	#%1111110000000000
	sta	x2

	lda	x1
	and	#%0000001111111111
	sta	x1

	and	#%11
	sta	y1

	lda	x1
	km_multa4
	and	#%1111110000

	clc
	adc	y1

	clc
	adc	#bg1_firstchar+bitmapvheight
	ora	x2

	endm
;---------------------------------------------------------------------
km_mariocgx_a	macro
;Mario CGX No (Polygon)<---- ROM CGX No
	IFEQ	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in LONGA mode%n"
	error+
	ENDC

	and	#%0000001111111111
	sta	x1

	and	#%11
	sta	y1

	lda	x1
	km_multa4
	and	#%1111110000

	clc
	adc	y1

	clc
	adc	#bitmapvheight
	endm
;================== Polygon BG Character Data Change ==================== 
calcMcharDAdr	macro	[label,char]
;Mario RAM Character Data Destination Address 
_cbc	=	{char}

{label}	= bitmapbase+bitmap1+((_cbc&%111111100)<<2+_cbc&3+bitmapvheight)*32
	endm
;--------------------------------------------------------------------
ConvMChraNo2MChrAdr	macro
;Convert Mario Character Number to Mario Ram Address
;Init :Acc Mario Character No
	sta	kmwork
	and	#%11111100
	asl	a
	asl	a
	sta	kmwork+2

	lda	kmwork
	and	#%000000011
	clc
	adc	kmwork+2
	clc
	adc	#bitmapvheight
	km_multa32
	clc
	adc	#cockpitbase&WM
	endm

;--------------------------------------------------------------------
km_TransCockpitCGX	macro	[sourceNo,destNo,counter]

	km_memchecka16i16

	lda	#{destNo}
	ldx	#(bg11_cgx+{sourceNo}*32)&WM
	ldy	#{counter}
	jsr	ktranscockpitCGX
	endm
;--------------------------------------------------------------------
;* ROM Data wo XXRAM (cockpitcgx_buf) ni COPY *
kcopyIntChr	macro	[source,dest]

	IFEQ	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in LONGA mode%n"
	error+
	ENDC
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in LONGI mode%n"
	error+
	ENDC

	ldx	#(bg11_cgx+({source})*32)&WM
	ldy	#(cockpitcgx_buf+({dest})*32)&WM
	jsr	kcopyIntChr_sub
	endm
;---------------------------------------------------------------------
KcopyBitmapFixChr	macro	[source,dest,val]
_cbc	=	{dest}
_p1	=	{dest}
_p2	=	{dest}+(p2bmbase_cgx-p1bmbase_cgx)
	savemode
	phx
	phy
	ai16
	ldx	#(bg11_cgx+({source})*32)&WM
;;;;	ldy	#(bitmapbase+bitmap1+((_cbc&%111111100)<<2+_cbc&3+bitmapvheight)*32)&WM
;------------------------------------
; player Hosei
	lda	kplayer
	and	#$00ff
	bne	.player2\@
	ldy	#(cockpitbase+((_p1&%111111100)<<2+_p1&3+bitmapvheight)*32)&WM
	bra	.skip\@
.player2\@
	ldy	#(cockpitbase+((_p2&%111111100)<<2+_p2&3+bitmapvheight)*32)&WM

.skip\@
;------------------------------------
	lda	#{val}-1
	phb
	db	$54
	db	bitmapbase>>16
	db	bg11_cgx>>16
	plb
	returnmode
	ply
	plx
	endm
;---------------------------------------------------------------------
KcopyRdScChr	macro	[source,dest,val]
_cbc	=	{dest}

	IFEQ	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in LONGA mode%n"
	error+
	ENDC
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in LONGI mode%n"
	error+
	ENDC

	ldx	#(bg11_cgx+{source}*32)&WM
	ldy	#(bitmapbase+bitmap1+((_cbc&%111111100)<<2+_cbc&3+bitmapvheight)*32)&WM
	jsr	KcopyRdScChr_sub
	endm
;---------------------------------------------------------------------
KcopyBitmapChr_a	macro	[source,dest,val]
;Init	:Acc
;Exit	:Nothing
_p1	=	{dest}
_p2	=	{dest}+(p2bmbase_cgx-p1bmbase_cgx)
	phx
	phy
	savemode

	a16
	km_multa32
	clc
	adc	#(bg11_cgx+{source}*32)&WM
	tax

;	ldy	#(bitmapbase+bitmap1+((_cbc&%111111100)<<2+_cbc&3+bitmapvheight)*32)&WM

;------------------------------------
; player Hosei
	lda	kplayer
	and	#$00ff
	bne	.player2\@
	ldy	#(cockpitbase+((_p1&%111111100)<<2+_p1&3+bitmapvheight)*32)&WM
	bra	.skip\@
.player2\@
	ldy	#(cockpitbase+((_p2&%111111100)<<2+_p2&3+bitmapvheight)*32)&WM

.skip\@
;------------------------------------
	lda	#{val}-1
	km_mvn	bg11_cgx,bitmapbase

	returnmode
	ply
	plx
	endm
;---------------------------------------------------------------------
KcopyBitmapChr_xy	macro	[val]
;Copy ROM character to Mario RAM
;Init	:xreg (source) ROM Character No
;	:yreg (dest)   Mario Ram Character No
;Exit	:Nothing

	savemode
	ai16
	txa
	km_multa32
	clc
	adc	#(bg11_cgx)&WM
	tax	;dono character wo

;------------------------------------
; player Hosei
	lda	kplayer
	and	#1
	beq	.skip\@

	tya
	clc
	adc	#p2bmbase_hosei
	tay
.skip\@
	tya
	ConvMChraNo2MChrAdr
	tay	;doconi copy
;------------------------------------
	lda	#{val}-1
	km_mvn	bg11_cgx,bitmapbase

	returnmode
	endm
;---------------------------------------------------------------------
KcopyBitmapChrXY	macro	[source,dest,val]
;Init	:X:source address Y:dest address
;Exit	:Nothing
	savemode

	ai16
;--- source address ----
	txa
	km_shiftLUA32
	clc
	adc	#(bg11_cgx+{source}*32)&WM
	tax

;--- destination address ----
	tya
	clc
	adc	#{dest}
	calcscrchar_a
	km_shiftLUA32
	clc
	adc	#(bitmapbase+bitmap1)&WM
	tay

	lda	#{val}-1
	km_mvn	bg11_cgx,bitmapbase
	returnmode
	endm
;---------------------------------------------------------------------
km_convSCRaddr_32X	macro
;* Init :kz_x1	:x zahyou (0~$1f)
;       :kz_y1	:y zahyou (0~$1f)
;* Out  :Xreg	:address  (0~$7ff)
	jsr	KconvSCRAddr32X
	endm
;---------------------------------------------------------------------
km_convSCRCheckAddr_32X	macro
;* Init :kz_x1	:x zahyou (0~$1f)
;       :kz_y1	:y zahyou (0~$1f)
;* Out  :Xreg	:address  (0~$3ff)
	jsr	KconvSCRCheckAddr32X
	endm
;---------------------------------------------------------------------
km_convVRAMSCRaddr_32	macro	[x,y,base]
;* Init :kz_x1	:x zahyou (0~$1f)
;       :kz_y1	:y zahyou (0~$1f)
;* Out  :Acc	:address  (0~$3ff)
MYNARG	=	NARG
	CHK_NARG	2,3

	savemode
	a8
	lda	{y}
	sta.l	wrmpya
	lda	#$20*2/2	;VRAM Screen Address
	sta.l	wrmpyb
	nop	;wait
	nop	;wait
	nop	;wait
	nop	;wait

	a16
	lda	{x}
	and	#$ff
	clc
	adc.l	rdmpylr

	IFEQ	narg-3
	clc
	adc	#{base}
	ENDC

	returnmode

	endm
;------------------------------------------------------------------------
km_convVRAMSCRaddr_256	macro	[x,y,base]
;* Init :kz_x1	:x zahyou (0~$ff)
;       :kz_y1	:y zahyou (0~$ff)
;* Out :Acc (0~3ff)
MYNARG	=	NARG
	CHK_NARG	2,3

	savemode
	a8
	lda	{y}
	lsr	a
	lsr	a
	lsr	a
	sta.l	wrmpya
	lda	#$20*2/2	;VRAM Screen Address
	sta.l	wrmpyb
	nop	;wait
	nop	;wait
	nop	;wait
	nop	;wait

	a16
	lda	{x}
	and	#$ff
	lsr	a
	lsr	a
	lsr	a
	clc
	adc.l	rdmpylr

	IFEQ	narg-3
	clc
	adc	#{base}
	ENDC

	returnmode

	endm
;------------------------------------------------------------------------
km_convVRAMSCRaddr_256X	macro	[x,y,base]
;* Init :kz_x1	:x zahyou (0~$ff)
;       :kz_y1	:y zahyou (0~$ff)
;* Out :Xreg (0~3ff)
MYNARG	=	NARG
	CHK_NARG	2,3

	savemode
	a8
	lda	{y}
	lsr	a
	lsr	a
	lsr	a
	sta.l	wrmpya
	lda	#$20*2/2	;VRAM Screen Address
	sta.l	wrmpyb
	nop	;wait
	nop	;wait
	nop	;wait
	nop	;wait

	a16
	lda	{x}
	and	#$ff
	lsr	a
	lsr	a
	lsr	a
	clc
	adc.l	rdmpylr

	IFEQ	narg-3
	clc
	adc	#{base}
	ENDC
	tax
	returnmode
	endm
;------------------------------------------------------------------------
km_convVRAMSCRaddr_256Y	macro	[x,y,base]
;* Init :kz_x1	:x zahyou (0~$ff)
;       :kz_y1	:y zahyou (0~$ff)
;* Out  :Yreg (0~3ff)
MYNARG	=	NARG
	CHK_NARG	2,3

	savemode
	a8
	lda	{y}
	lsr	a
	lsr	a
	lsr	a
	sta.l	wrmpya
	lda	#$20*2/2	;VRAM Screen Address
	sta.l	wrmpyb
	nop	;wait
	nop	;wait
	nop	;wait
	nop	;wait

	a16
	lda	{x}
	and	#$ff
	lsr	a
	lsr	a
	lsr	a
	clc
	adc.l	rdmpylr

	IFEQ	narg-3
	clc
	adc	#{base}
	ENDC
	tay
	returnmode

	endm
;------------------------------------------------------------------------
km_set_misstage4	macro
	lda	#iv_misstage4
	sta	trans_flag
	waittrans
	endm
;------------------------------------------------------------------------
km_dmaromram	macro	[channel,source,dest,length]
;[ROM data--->Extend RAM data(7E or 7F)	]
;[source: #ROM Address,dest: #RAM address	]

	km_memchecka8i16
	ifd	{dest}
	ifne	$7e0000-{dest}&$ff0000
	ifne	$7f0000-{dest}&$ff0000
	error	<Destination must be in extended RAM>
	endc
	endc
	endc

	phb
;* data Bank 0 *
	lda	#0
	pha
	plb

	lda	#(wmdata&$ff)
	sta	ch{channel}addrb

	ldx	#{dest}&WM
	stx	wmaddl
	lda	#({dest}>>16)&1
	sta	wmaddh

	ldx	#({source}&WM)
	stx	ch{channel}addra1tl
	lda	#({source}>>16)
	sta	ch{channel}atbank

	ldx	#{length}
	stx	ch{channel}dataddrl
	stz	ch{channel}params
	lda	#1<<({channel})
	sta	mdmaen

	plb
	endm
;------------------------------------------------------------------------
km_dmaromXram	macro	[channel,source,dest,length]
;[ROAM data--->Extend RAM data(7E or 7F)	]
;[source: #ROM Address,dest: #RAM address	]

MYNARG	=	NARG
	CHK_NARG	4
_tmpdmx_{dest} = 0
_tmpdmx_heap = 1

	km_memchecka8i16

		ifeq	_tmpdmx_{dest}-_tmpdmx_heap
_tmpbank = 0

		elseif

			ifne	$7e0000-{dest}&$ff0000
			ifne	$7f0000-{dest}&$ff0000
			error	<Destination must be in extended RAM>
			endc
			endc
_tmpbank = ({dest}>>16)&1
		endc

;* data Bank 0 *
	phb
	lda	#0
	pha
	plb

	lda	#(wmdata&$ff)
	sta	ch{channel}addrb

	a16
	txa
	clc
	adc	#{dest}&WM
	sta	wmaddl
	a8

	lda	#_tmpbank
	sta	wmaddh

	ldx	#({source}&WM)
	stx	ch{channel}addra1tl
	lda	#({source}>>16)
	sta	ch{channel}atbank

	ldx	#{length}
	stx	ch{channel}dataddrl
	stz	ch{channel}params
	lda	#1<<({channel})
	sta	mdmaen

	plb
	endm

;------------------------------------------------------------------------
km_dmaWRAMclear	macro	[channel,dest,length]
MYNARG	=	NARG
	CHK_NARG	3

	km_memchecki16

_destbnk	=	({dest}>>16)&01
	phb
	pha
	phx

	km_chga8

	lda	#0
	pha
	plb

	ldx	#{dest}&WM
	stx	wmaddl		;RAM address

	lda	#_destbnk
	sta	wmaddh		;RAM bank

	lda	#%00001000	;1 adr only write ,Abus -->B bus,adr FIX
	sta	ch{channel}params

	lda	#$80
	sta	ch{channel}addrb	;DRAM WRITE

;* tensou moto address *
	ldx	#clear_data&WM
	stx	ch{channel}addra1tl
	lda	#clear_data>>16
	sta	ch{channel}atbank
;* tensou value *
	ldx	#{length}&WM
	stx	ch{channel}dataddrl
;* dma start *
	lda	#1
	sta	mdmaen

	km_reta16
	plx
	pla
	plb
	endm
;---------------------------------------------------------------------
km_VRAMclear	macro
;kanarazu Data Bank ha 0 dearukoto
	km_memchecka8i16
; clear video RAM:(screen.asm) 
	screen_off
	stz	cgadd
	stz	vmaddl
	stz	vmaddh
	lda	#$8f
	sta	inidisp
	sta	vmainc

; clear VRAM
	lda	#0
	ldx	#127*256
.li\@	sta	vmdatal
	dex
	bne	.li\@
	endm

;------------------------------------------------------------------------
km_dmaVRAMClear	macro	[channel,dest,length]
MYNARG	=	NARG
	CHK_NARG	3
	km_memchecka8i16
	lda	#%10000000
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch{channel}addrb
	ldx	#({dest})
	stx	vmaddl

	lda	#%00001001
	sta	ch{channel}params
	ldx	#data0&WM
	stx	ch{channel}addra1tl
	lda	#data0>>16
	sta	ch{channel}atbank
	ldx	#{length}
	stx	ch{channel}dataddrl
	lda	#1<<{channel}
	sta	mdmaen
	endm
;------------------------------------------------------------------------
km_dmaMRAMClear	macro	[channel,dest,length]
MYNARG	=	NARG
	CHK_NARG	3
	km_memchecka8i16
	stz	m7a
	stz	m7a
	stz	m7b

	lda	#%10000000
	sta	ch{channel}params
	lda	#mpylr&$ff
	sta	ch{channel}addrb

	ldx	#({dest})&WM
	stx	ch{channel}addra1tl
	lda	#({dest})>>16
	sta	ch{channel}atbank
	ldx	#{length}
	stx	ch{channel}dataddrl
	lda	#1<<{channel}
	sta	mdmaen
	endm
;------------------------------------------------------------------------
km_dmaromVRAM	macro	[channel,source,dest,length]

MYNARG	=	NARG
	CHK_NARG	4
	km_memchecka8i16
	phb
;* data Bank 0 *
	lda	#0
	pha
	plb

	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch{channel}addrb
	ldx	#{dest}
	stx	vmaddl

	lda	#%00000001
	sta	ch{channel}params
	ldx	#{source}&WM
	stx	ch{channel}addra1tl
	lda	#{source}>>16
	sta	ch{channel}atbank
	ldx	#{length}
	stx	ch{channel}dataddrl
	lda	#1<<{channel}
	sta	mdmaen
	plb
	endm
;------------------------------------------------------------------------
km_dmaXromVRAM	macro	[channel,sbase,dest,length]
MYNARG	=	NARG
	CHK_NARG	4
	km_memchecka8i16
	phb
;* data Bank 0 *
	lda	#0
	pha
	plb

	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch{channel}addrb

	a16
	lda	#{dest}
	sta	vmaddl

	txa
	clc
	adc	#({sbase})&WM
	sta	ch{channel}addra1tl
	a8
	lda	#({sbase})>>16
	sta	ch{channel}atbank

	lda	#%00000001
	sta	ch{channel}params
	ldx	#{length}
	stx	ch{channel}dataddrl
	lda	#1<<{channel}
	sta	mdmaen

	plb
	endm
;------------------------------------------------------------------------
km_dmaXromYVRAM	macro	[channel,sbase,dbase,length]
MYNARG	=	NARG
	CHK_NARG	4
	km_memchecka8i16
	phb
;* data Bank 0 *
	lda	#0
	pha
	plb

	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch{channel}addrb

	a16
	tya
	clc
	adc	#{dbase}
	sta	vmaddl

	txa
	clc
	adc	#({sbase})&WM
	sta	ch{channel}addra1tl
	a8
	lda	#({sbase})>>16
	sta	ch{channel}atbank

	lda	#%00000001
	sta	ch{channel}params
	ldx	#{length}
	stx	ch{channel}dataddrl
	lda	#1<<{channel}
	sta	mdmaen

	plb
	endm
;------------------------------------------------------------------------
km_dmacgx4VRAM		macro	[channel,CPUadr,VRAMadr,number]
MYNARG	=	NARG
	CHK_NARG	4
	km_memchecka8i16

	phb
;* data Bank 0 *
	lda	#0
	pha
	plb

	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch{channel}addrb
	ldx	#{VRAMadr}
	stx	vmaddl
	ldx	#({CPUadr})&WM
	stx	ch{channel}addra1tl
	lda	#(({CPUadr})>>16)
	sta	ch{channel}atbank
	ldx	#({number})*$20
	stx	ch{channel}dataddrl
	lda	#1
	sta	ch{channel}params
	lda	#1<<{channel}
	sta	mdmaen
	plb
	endm
;---------------------------------------------------------------------------
km_dmaXcgx4VRAM		macro	[channel,CPUBaseAdr,VRAMadr,number]
MYNARG	=	NARG
_tmpdmc4v_{CPUBaseAdr} = 0
_tmpdmc4v_heap = 1
	CHK_NARG	4
	km_memchecka8i16
	phb
;* data Bank 0 *
	lda	#0
	pha
	plb

;Yreg :Address

	a16
	txa
	clc
	adc	#({CPUBaseAdr})&WM
	sta	ch{channel}addra1tl
	a8

	ifeq	_tmpdmc4v_{CPUBaseAdr}-_tmpdmc4v_heap
	lda	#$7e
	sta	ch{channel}atbank

	elseif

	lda	#({CPUBaseAdr})>>16
	sta	ch{channel}atbank
	endc

	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch{channel}addrb
	ldx	#{VRAMadr}
	stx	vmaddl
	ldx	#({number})*$20
	stx	ch{channel}dataddrl
	lda	#1
	sta	ch{channel}params
	lda	#1<<{channel}
	sta	mdmaen
	plb
	endm
;---------------------------------------------------------------------------
km_dmascrw 	macro	[channel,vbase,vx,vy,rambuf,val]
	km_memchecka8i16

	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch{channel}addrb
	ldx	#(({vbase}+({vy})*32+{vx})&WM)
	stx	vmaddl
	ldx	#{rambuf}&WM
	stx	ch{channel}addra1tl
	lda	#(({rambuf})>>16)
	sta	ch{channel}atbank
	ldx	#{val}
	stx	ch{channel}dataddrl
	lda	#1
	sta	ch{channel}params
	lda	#1<<{channel}
	sta	mdmaen
	endm
;------------------------------------------------------------------------
km_dmascrl 	macro	[channel,vbase,vx,vy,rambuf,val]
	km_memchecka8i16

	lda	#0
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch{channel}addrb
	ldx	#(({vbase}+({vy})*32+{vx})&WM)
	stx	vmaddl
	ldx	#{rambuf}&WM
	stx	ch{channel}addra1tl
	lda	#(({rambuf})>>16)
	sta	ch{channel}atbank
	ldx	#{val}
	stx	ch{channel}dataddrl
	lda	#0
	sta	ch{channel}params
	lda	#1<<{channel}
	sta	mdmaen
	endm
;------------------------------------------------------------------------
ColChange	macro	[type,palette,colNo,buffer]
_cc_BG	=	0
_cc_OBJ	=	1

	IFD	_cc_{type}
	IFEQ	_cc_{type}-_cc_BG
; type = BG
_cc_label	=	$0

	ELSEIF
; type = OBJ
_cc_label	=	$80
	ENDC

	lda	#({palette}*$10)+{colNo}+_cc_label
	sta	cgadd
	lda.l	{buffer}+0
	sta	cgdata
	lda.l	{buffer}+1
	sta	cgdata

	ELSEIF
	printf	"Error: BG or OBJ needed\n"
	error+
	ENDC
	endm
;------------------------------------------------------------------------
km_dmatranscolpal	macro	[moto,saki,kazu]
MYNARG	=	NARG
	CHK_NARG	3
	km_memcheck

	lda	#{saki}*$10
	sta	cgadd		;2121h
	lda	#%00000010
	sta	ch0params
	lda	#(cgdata&$ff)	;2122h
	sta	ch0addrb
	a16
	lda.\0	{moto}+0		;colour data address (l)
	sta	ch0addra1tl
	a8
	lda.\0	{moto}+2		;colour data bank
	sta	ch0atbank
	ldx	#{kazu}*2*16		;pallet no kazu
	stx	ch0dataddrl
	lda	#1
	sta	mdmaen		;dma switch
	endm
;------------------------------------------------------------------------
km_dmaRAMtoCGRAM	macro	[channel,RAMadr,CGRAMadr,length]
MYNARG	=	NARG
	CHK_NARG	4
	km_memcheck

	lda	#{CGRAMadr}
	sta	cgadd		;2121h

	lda	#%00000010
	sta	ch0params

	lda	#(cgdata&$ff)	;2122h
	sta	ch0addrb
	a16
	lda	#({RAMadr})&WM		;colour data address (l)
	sta	ch0addra1tl
	a8
	lda	#({RAMadr})>>16		;colour data bank
	sta	ch0atbank

	ldx	#{length}
	stx	ch0dataddrl
	lda	#1
	sta	mdmaen		;dma switch
	endm
;------------------------------------------------------------------------
km_dmaCGRAMtoRAM	macro	[channel,CGRAMadr,RAMadr,length]
MYNARG	=	NARG
	CHK_NARG	4
	km_memcheck

	lda	#{CGRAMadr}
	sta	cgadd		;2121h

	lda	#%10000010
	sta	ch0params

	lda	#(cgdatar&$ff)	;213bh
	sta	ch0addrb

	ldx	#({RAMadr})&WM		;colour data address (l)
	stx	ch0addra1tl

	lda	#({RAMadr})>>16		;colour data bank
	sta	ch0atbank

	ldx	#{length}
	stx	ch0dataddrl

	lda	#1<<{channel}
	sta	mdmaen		;dma switch
	endm
;------------------------------------------------------------------------
km_IRQdmaromVRAM	macro	[source,dest,length]
MYNARG	=	NARG
	CHK_NARG	3
	km_memchecka8i16
	ldx	#{dest}
	stx	vmaddl
	ldx	#{source}&WM
	lda	#{source}>>16
	ldy	#{length}
	jsl	SetDmaVramParams_l
	endm
;------------------------------------------------------------------------
km_IRQdmaXromVRAM	macro	[sbase,dest,length]
MYNARG	=	NARG
	CHK_NARG	3
	km_memchecka8i16
	a16
	lda	#({dest})
	sta	vmaddl
	txa
	clc
	adc	#({sbase})&WM
	tax
	a8
	lda	#({sbase})>>16
	ldy	#({length})
	jsl	SetDmaVramParams_l
	endm
;------------------------------------------------------------------------
km_IRQdmaxvram macro	[sbase,length]
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecka8i16
	stx	vmaddl
	ldx	#({sbase})&WM
	lda	#({sbase})>>16
	ldy	#{length}
	jsl	SetDmaVramParams_l
	endm
;------------------------------------------------------------------------
km_IRQdmaYXVRAM	macro	[sbase,length]
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecka8i16
	stx	vmaddl

	a16
	tya
	clc
	adc	#({sbase})&WM
	tax
	a8
	lda	#({sbase})>>16
	ldy	#({length})
	jsl	SetDmaVramParams_l
	endm
;------------------------------------------------------------------------
km_IRQdmaoaram	macro	[source,length]
	lda	#({source})>>16
	ldx	#({source})&WM
	ldy	#{length}
	jsl	SetDmaOARAMParams_l
	endm	
;------------------------------------------------------------------------
km_IRQdmasprbufclr		macro
	jsl	SetDmaOARAMClrParams_l
	ENDM
;------------------------------------------------------------------------
km_IRQdmaRAMtoCGRAM	macro	[RAMadr,CGRAMadr,length]
MYNARG	=	NARG
	CHK_NARG	3
	km_memcheck

	lda	#{CGRAMadr}
	sta	cgadd		;2121h
	lda	#({RAMadr})>>16		;colour data bank
	ldx	#({RAMadr})&WM		;colour data address (l,h)
	ldy	#{length}		;colour data length
	jsl	SetDmaCOLAdrLen_l
	endm
;------------------------------------------------------------------------
km_IRQdmaRAMtoColBuf	macro	[file,kazu,start]
MYNARG	=	NARG
	CHK_NARG	2,3
	km_memcheck
	ifeq	NARG-2
	lda	#0
	sta	palettestart
	elseif
	lda	#{start}*16
	sta	palettestart
	endc

	lda	#({file})>>16
	sta	vram3addr+2
	ldx	#({file})&WM
	stx	vram3addr
	ldx	#{kazu}*32
	stx	vram3len
	jsl	SetDmaColRAMParams_l
	endm
;------------------------------------------------------------------------
km_IRQdmatranscolpal	macro	[moto,saki,kazu]
MYNARG	=	NARG
	CHK_NARG	3
	km_memcheck

	lda	#{saki}*$10
	sta	cgadd		;2121h
	a16
	lda.\0	{moto}+0		;colour data address (l)
	tax
	a8
	lda.\0	{moto}+2		;colour data bank
	ldy	#{kazu}*2*16		;pallet no kazu
	jsl	SetDmaCOLAdrLen_l
	endm
;------------------------------------------------------------------------
km_IRQdmaRomtoRAM	macro	[source,dest,length]
MYNARG	=	NARG
	CHK_NARG	3
	km_memchecka8i16
	lda	#({source})>>16
	sta	vram3addr+2
	ldx	#({source})&WM
	stx	vram3addr
	ldx	#{length}
	stx	vram3len
	lda	#(({dest})>>16)&1
	ldx	#({dest})&WM
	jsl	SetDmaRomRamParams_l
	endm
;------------------------------------------------------------------------
km_IRQdmaRAMtoRAM	macro	[source,dest,length]
MYNARG	=	NARG
	CHK_NARG	3
	km_memchecka8i16
	lda	#({source})>>16
	sta	vram3addr+2
	ldx	#({source})&WM
	stx	vram3addr
	ldx	#{length}
	stx	vram3len
	lda	#(({dest})>>16)&1
	ldx	#({dest})&WM
	jsl	SetDmaRamRamParams_l
	endm
;------------------------------------------------------------------------
km_IRQdmaMRAMtoRAM	macro	[source,dest,length]
MYNARG	=	NARG
	CHK_NARG	3
	km_memchecka8i16
	lda	#({source})>>16		;mario ram
	sta	vram3addr+2
	ldx	#({source})&WM		;mario ram
	stx	vram3addr
	ldx	#{length}
	stx	vram3len
	lda	#(({dest})>>16)&1
	ldx	#({dest})&WM
	jsl	SetDmaMRamRamParams_l
	endm
;------------------------------------------------------------------------
km_decrunchpal	macro
	jsl	kdecrunchpal_l
	endm
;------------------------------------------------------------------------
km_gamepal	macro	[pal]
	km_memchecka8
	lda	#gamepal_{pal}
	sta	gamepal
	endm
;------------------------------------------------------------------------
km_setgamepal	macro	[pal]
MYNARG	=	NARG
	CHK_NARG	0,1

	ifeq	narg-1
	lda	#gamepal_{pal}
	sta	gamepal
	jsl	setgamepal_l
	elseif
	lda	gamepal
	jsl	setgamepal_l
	endc

	endm

;------------------------------------------------------------------------
km_palette		macro	[name,len,stapal,stapac]
MYNARG	=	NARG
	km_memchecka8i16

_len	=	4*32
_stapal	=	0
_name	=	{name}_pac

	ifge	narg-2
_len	=	{len}*32
	endc

	IFGE	NARG-3
_stapal	=	{stapal}*16
	ENDC

	IFGE	NARG-4
_name	=	{name}_pac+({stapac}*32)
	ENDC

	ldx	#(_name)&WM
	stx	vram3addr
	lda	#(_name)>>16
	sta	vram3addr+2
	ldx	#_len
	stx	vram3len
	ldx	#_stapal
	stx	palettestart
	endm
;------------------------------------------------------------------------
km_paletteX		macro	[name,len,stapal,stapac]
MYNARG	=	NARG
	km_memchecka8i16

_len	=	4*32
_stapal	=	0
_name	=	{name}_pac

	ifge	narg-2
_len	=	{len}*32
	endc

	IFGE	NARG-3
_stapal	=	{stapal}*16
	ENDC

	IFGE	NARG-4
_name	=	{name}_pac+({stapac}*32)
	ENDC

	a16
	txa
	km_multa32
	clc
	adc	#(_name)&WM
	sta	vram3addr
	a8

	lda	#(_name)>>16
	sta	vram3addr+2
	ldx	#_len
	stx	vram3len
	ldx	#_stapal
	stx	palettestart
	endm
;------------------------------------------------------------------------

km_setdepth	macro	[depthmode]
	IFEQ	LONGA
	lda	#{depthmode}&BM
	sta.l	m_depthstab
	lda	#({depthmode}>>8)&BM
	sta.l	m_depthstab+1
	ELSEIF
	lda	#{depthmode}&WM
	sta.l	m_depthstab
	ENDC
	endm

;========================== DECRUNCH =================================
km_decrunchcgx	macro	[label,offset]
MYNARG	=	NARG
	CHK_NARG	1,2

;{offset} wa marioram no top address offset wo kuwaeru!! 
	savemode
	ai16
	phx
	lda	#{label}_ccr&WM
	sta.l	m_enddata		;compress data address

	IFEQ	NARG-1
	lda	#(dec_base)&WM
	elseif
	lda	#(dec_base+{offset})&WM
	ENDC

	sta.l	m_decaddr		;mario RAM top address
	lda	#0
	sta.l	m_decoffset		;for screen data
	a8
	lda	#{label}_ccr>>16
	sta.l	m_enddatabnk		;compress data bank

	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l
	plx
	returnmode
		endm
;--------------------------------------------------------------------------
km_decrunchscr	macro	[label,offset]
MYNARG	=	NARG
	CHK_NARG	1,2
;{offset} wa marioram no top address offset wo kuwaeru!! 
	savemode
	ai16
	phx
	lda	#{label}_pcr&WM
	sta.l	m_enddata		;compress data address

	IFEQ	NARG-1
	lda	#(dec_base)&WM
	elseif
	lda	#(dec_base+{offset})&WM
	ENDC

	sta.l	m_decaddr		;mario RAM top address
	lda	#0
	sta.l	m_decoffset		;for screen data
	a8
	lda	#{label}_pcr>>16
	sta.l	m_enddatabnk		;compress data bank

	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l
	plx
	returnmode
		endm

;*********************************************************************
;*			Window Macros				*
;*********************************************************************
km_initwipeopen	macro	[label]
MYNARG	=	NARG
	CHK_NARG	1

	jsl	wipeinit_l
	jsl	{label}open_l
	a16
	sta	kw_wipetimer	;wipe open timer
	a8
	km_setwindowflag	wipeopen
;;;;;	km_stxval	kw_wipetimer,{label}opentm
	endm
;------------------------------------------------------------------------
km_initwipeclose	macro	[label]
MYNARG	=	NARG
	CHK_NARG	1

	jsl	wipeinit_l
	jsl	{label}close_l
	a16
	sta	kw_wipetimer	;wipe close timer
	a8
	km_setwindowflag	wipeclose

;;;	km_stxval	kw_wipetimer,{label}closetm
	endm
;------------------------------------------------------------------------
km_decwipetimer	macro
	km_memchecki16

	ldx	kw_wipetimer
	dex
	stx	kw_wipetimer
	endm
;------------------------------------------------------------------------
km_clrwipeclose	macro
	savemode
	a16
	stz	windowmode1
	stz	windowmode2
	stz	windowptr1
	stz	windowptr2
	km_clrwindowflag	wipeclose
	returnmode
	endm
;------------------------------------------------------------------------
km_SetRepeatflag	macro	[obj1]
	lda	wm_flags,{obj1}
	ora	#wf_datarepeat
	sta	wm_flags,{obj1}	;window repeat flag on
	endm
;------------------------------------------------------------------------
km_sethdmatabs_reptwin	macro	[mode,left,right]
MYNARG	=	NARG
	CHK_NARG	3
_tmp_{mode} = 0
_tmp_mission = 1
_tmp_battle = 2

	ifeq	_tmp_{mode}
	error	<Should set mission or battle>
	endc
	savemode
	a16

	ifeq	_tmp_{mode}-1
	lda	#{left}+({right}<<8)
	sta	[kz_tempaddrl],y
	iny
	iny
	sta	[kz_tempaddrl],y

	elseif

	lda	#{left}+({right}<<8)
	sta	[kz_tempaddrl],y
	iny
	iny
	endc
	returnmode
	endm
;---------------------------------------------------------------------
km_sethdmatabs_circwin	macro	[val,left,right,top]
MYNARG	=	NARG
	CHK_NARG	4

	savemode
	phx
	ldx	#{top}*2			;INIT Pointer (Cilcle Data)
	a8
	lda	#{val}
	sta	kcounter		;HDMA Data Value

	lda	#{left}
	sta	kclipsx			;clip start X
	lda	#{right}-1
	sta	kclipex			;clip end Y

	jsr	HDMACircle_sub
	plx
	returnmode
	ENDM
;---------------------------------------------------------------
KHDMATbl_BT	macro	[reg,left,right,table]
MYNARG	=	NARG

	CHK_NARG	4

	km_memchecka8i16

	phb
	lda	#$7f
	pha
	plb

	lda	{left}
	clc
	adc.l	kwindowoffx
	sta.w	xhdma_{table},{reg}
	in{reg}

	lda	{right}
	clc
	adc.l	kwindowoffx
	sta.w	xhdma_{table},{reg}
	in{reg}
	plb
	endm
;--------------------------------------------------------------------------
KHDMATbl	macro	[reg,val,left,right,table]

	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in SHORTA mode%n"
	error+
	ENDC
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in LONGI mode%n"
	error+
	ENDC

	phb
	lda	#$7F
	pha
	plb

	lda	{val}
	sta.w	xhdma_{table},{reg}
	in{reg}

	lda	{left}
	sta.w	xhdma_{table},{reg}
	in{reg}

	lda	{right}
	sta.w	xhdma_{table},{reg}
	in{reg}
	plb
	endm
;---------------------------------------------------------------------
KHDMATblEND	macro	[reg,table]

	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in SHORTA mode%n"
	error+
	ENDC
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in LONGI mode%n"
	error+
	ENDC

	phb
	lda	#$7F
	pha
	plb
	lda	#1
	sta	xhdma_{table},{reg}
	in{reg}

	lda	#1
	sta.w	xhdma_{table},{reg}
	in{reg}

	lda	#0
	sta.w	xhdma_{table},{reg}
	in{reg}

	lda	#0
	sta.w	xhdma_{table},{reg}
	plb
	endm
;---------------------------------------------------------------------
KHDMACilcleTbl_Direct	macro	[val,clipsx,clipex,clipsy,clipey,table]

	km_memchecka8i16

	phb
	lda	#$7F
	pha
	plb

	ldx	{clipsy}*2		;Cilcle Data Fast Pointer
	lda	{val}
	sta	kmwork			;Data Set Counter

	lda	{val}+$80
	sta	xhdma_{table},y		;HDMA Data Value
	iny
.loop\@
	lda.l	m_circlebuf,x
	sec
	sbc.l	m_circlebuf2,x		;(right side) -(left side) >=0
	bcs	.clip\@
	beq	.clip\@
;---------------------------------------
;(right side) < (left side) Case 

	lda.l	m_circlebuf2,x
	sta	xhdma_{table},y	;left side data
	iny
	lda.l	m_circlebuf,x
	sta	xhdma_{table},y	;right side data
	iny
	bra	.notclip\@
;---------------------------------------
;(Left Side)
.clip\@
	lda.l	m_circlebuf2,x
	cmp	{clipsx}
	bcs	.notclipSX\@	;if SX clip not need (left side >= sx)

	lda	{clipsx}
.notclipSX\@
	sta	xhdma_{table},y
	iny
;---------------------------------------
;(Right Side)
	lda.l	m_circlebuf,x
	cmp	{clipex}
	bcc	.notclipex\@	;(Right side < ex)
	lda	{clipex}
.notclipex\@
	sta	xhdma_{table},y
	iny
;---------------------------------------
.notclip\@
	inx
	inx
	dec	kmwork
	bne	.loop\@		;if Data Set End ===> jmp End
.End\@
	plb
	endm
;---------------------------------------------------------------------
KHDMACilcleTbl_Indirect	macro	[mode,val,clipsx,clipex,table,clipsy]
MYNARG	=	NARG

_cc_mission	=	0
_cc_battle	=	1

	IFD	_cc_{mode}

	km_memchecka8i16

	ifne	_cc_{mode}-_cc_mission
;If Battle Mode
	phx
	phy
	endc

	ifeq	NARG-6
	ldx	#{clipsy}*2		;INIT Pointer (Cilcle Data)
	endc

	phx
	ldx	#xhdma_{table}&WM
	stx	address			;HDMA ADDRESS SET
	plx
	lda	#xhdma_{table}>>16
	sta	address+2		;HDMA BANK SET

	lda	#{val}
	sta	kcounter		;HDMA Data Value

	lda	#{clipsx}
	sta	kclipsx			;clip start X
	lda	#{clipex}
	sta	kclipex			;clip end Y

	jsr	HDMACircle_sub

;If Battle Mode
	ifne	_cc_{mode}-_cc_mission
	ply
	plx
	endc

	ELSEIF

	printf	"Error: mission or battle needed\n"
	error+
	ENDC

	endm
;---------------------------------------------------------------------
KHDMACilcleTbl_BT	macro	[mode,val,clipsx,clipex,clipsy,table]
_cc_mission	=	0
_cc_battle	=	1

	IFD	_cc_{mode}
;Init Yreg : HDMA Table Pointer
	IFNE	LONGA
	printf	"** %q%f%q: (%l) Error: Should be in SHORTA mode%n"
	error+
	ENDC
	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in LONGI mode%n"
	error+
	ENDC

	IFNE	_cc_{mode}-_cc_mission
	phx
	phy
	endc

	phb
	lda	#$7f
	pha
	plb
	ldx	{clipsy}*2		;Cilcle Data Fast Pointer

	lda	{val}
	sta	kmwork			;Data Set Counter

.loop\@
	lda.l	m_circlebuf,x
	sec
	sbc.l	m_circlebuf2,x		;(right side) -(left side) >=0
	bcs	.clip\@
	beq	.clip\@
;---------------------------------------
;(right side) < (left side) Case 

	lda.l	m_circlebuf2,x
	sta	xhdma_{table},y	;left side data
	iny
	lda.l	m_circlebuf,x
	sta	xhdma_{table},y	;right side data
	iny
	bra	.notclip\@
;---------------------------------------
;(Left Side)
.clip\@
	lda.l	m_circlebuf2,x
	cmp	{clipsx}
	bcs	.notclipSX\@	;if SX clip not need (left side >= sx)

	lda	{clipsx}
.notclipSX\@
	sta	xhdma_{table},y
	iny
;---------------------------------------
;(Right Side)
	lda.l	m_circlebuf,x
	cmp	{clipex}
	bcc	.notclipex\@	;(Right side < ex)
	lda	{clipex}
.notclipex\@
	sta	xhdma_{table},y
	iny
;---------------------------------------
.notclip\@
	inx
	inx
	dec	kmwork
	bne	.loop\@		;if Data Set End ===> jmp End
.End\@
	plb

	IFNE	_cc_{mode}-_cc_mission
	ply
	plx
	endc

	ELSEIF
	printf	"Error: mission or battle needed\n"
	error+
	ENDC
	endm
;*********************************************************************
;*								*
;*			Sprites Macro				*
;*								*
;*********************************************************************
;========================= Sprite Initial ============================
oamclear_SG	macro
	km_memcheck

	jsl	oamclear_SG_l

	ENDM

	ifeq	1
	ai16
	ldy	#(obj_val-8)*4
.loop\@
	lda	#$0f8f8		;3 cycle
	sta	sprites+0,y	;6 cycle
	sta	sprites+4,y	;6 cycle
	sta	sprites+8,y	;6 cycle
	sta	sprites+12,y	;6 cycle
	sta	sprites+16,y	;6 cycle
	sta	sprites+20,y	;6 cycle
	sta	sprites+24,y	;6 cycle
	sta	sprites+28,y	;6 cycle

	tya			;2 cycle
	sec			;2 cycle
	sbc	#32		;3 cycle
	tay			;2 cycle
	bpl	.loop\@		;4 cycle	;64*16 cycle=1024
	endc
;--------------------------------------------------------------------
oamsuballon	macro
	km_memcheck
	jsl	oamsuballon_l
	endm
;--------------------------------------------------------------------
oamclear_DB	macro
	km_memcheck
	jsl	oamclear_DB_l
	endm
;--------------------------------------------------------------------
oamallclear	macro
	km_memcheck


	a16
	ldy	#(sprites)&WM
	jsl	oamallclear_l
	ldy	#(sprites+128*4+128/4)&WM
	jsl	oamallclear_l
	a8

	ENDM
;---------------------------------------------------------------------
SetSpriteXYOffset	macro	[x,y]
	lda	#{x}
	sta	ksproffx
	lda	#{y}
	sta	ksproffy
	endm

;========================= Sprite Data ============================

Spr32x32AddrStart	MACRO	[label]
_spr32x32ptr = 0
	ENDM

Spr32x32Addr	MACRO	[label]
spr32x32_{label}	equ	_spr32x32ptr
	DW	(Spr{label}Data-Sprite32x32Data)
_spr32x32ptr = _spr32x32ptr+2
	ENDM
;-----------------------------------------------------------------
SprBlockAnimeAddrStart	MACRO	[label]
_sprblockanmptr = 2
	DW	0	;dummy
	ENDM

SprBlockAnimeAddr	MACRO	[label]
sprblockanm_{label}	equ	_sprblockanmptr
	DW	(BlockAnime_{label}-SpriteBlockAnime)
_sprblockanmptr = _sprblockanmptr+2
	ENDM

SprBlockAnime	MACRO	[time,pattern]
	DW	{time}
	DW	sprblock_{pattern}
	ENDM

SprBlockAnimeEnd	MACRO
	DW	-1
	ENDM

SprBlockAnimeWait	MACRO
	DW	-3
	ENDM

SprBlockAnimeJump	MACRO	[addr]
	DW	-4
	dw	({addr}-SpriteBlockAnime)&WM
	ENDM
;-----------------------------------------------------------------
SprBlockAddrStart	MACRO	[label]
_sprblockptr = 0
	ENDM

SprBlockAddr	MACRO	[label]
sprblock_{label}	equ	_sprblockptr
	DW	(Spr{label}Data-SpriteBlockData)
_sprblockptr = _sprblockptr+2
	ENDM

;-----------------------------------------------------------------
SpriteDataB	MACRO	[x,y,obj,color,prio,flip,offset]
MYNARG	=	NARG
	CHK_NARG	6,7

	IFEQ	NARG-6
objnam	=	{obj}+obj_offset
	ELSEIF
objnam	=	{obj}+{offset}
	ENDC

	db	{x},{y}-1
	db	objnam&BM,({color}<<1)!((objnam&$100)>>8)!({flip}<<6)!({prio}<<4)
	ENDM
;--------------------------------------------------------------------
SpriteDataW	MACRO	[x,y,obj,color,prio,flip,offset]
MYNARG	=	NARG
	CHK_NARG	6,7

	IFEQ	NARG-6
objnam	=	{obj}+obj_offset
	ELSEIF
objnam	=	{obj}+{offset}
	ENDC

	dw	(({x})&BM)+(({y}-1)<<8)
	dw	objnam!({color}<<9)!({flip}<<14)!({prio}<<12)
	ENDM
;--------------------------------------------------------------------
SprXYDataB		MACRO	[x,y]
	db	{x},{y}-1
	ENDM
;--------------------------------------------------------------------
SprXYDataW		MACRO	[x,y]
	dw	(({x})&BM)+(({y}-1)<<8)
	ENDM
;--------------------------------------------------------------------
SprChrDataB	MACRO	[obj,color,prio,flip,offset]
MYNARG	=	NARG
	CHK_NARG	4,5

	IFEQ	NARG-4
objnam	=	{obj}+obj_offset
	ELSEIF
objnam	=	{obj}+{offset}
	ENDC

	db	objnam&BM,({color}<<1)!((objnam&$100)>>8)!({flip}<<6)!({prio}<<4)
	ENDM
;--------------------------------------------------------------------
SprChrDataW	MACRO	[obj,color,prio,flip,offset]
MYNARG	=	NARG
	CHK_NARG	4,5

	IFEQ	NARG-4
objnam	=	{obj}+obj_offset
	ELSEIF
objnam	=	{obj}+{offset}
	ENDC

	dw	objnam!({color}<<9)!({flip}<<14)!({prio}<<12)
	ENDM
;--------------------------------------------------------------------
km_ldasprchr		macro		[obj,color,prio,flip,offset]
MYNARG	=	NARG
	CHK_NARG	4,5
	km_memchecka16

	IFEQ	NARG-4
objnam	=	{obj}+obj_offset
	ELSEIF
objnam	=	{obj}+{offset}
	ENDC

	lda	#(objnam!({color}<<9)!({flip}<<14)!({prio}<<12))
	endm
;--------------------------------------------------------------------
km_adcsprchr		macro		[obj,color,prio,flip,offset]
MYNARG	=	NARG
	CHK_NARG	4,5
	km_memchecka16

	IFEQ	NARG-4
objnam	=	{obj}+obj_offset
	ELSEIF
objnam	=	{obj}+{offset}
	ENDC
	clc
	adc	#(objnam!({color}<<9)!({flip}<<14)!({prio}<<12))
	endm

;--------------------------------------------------------------------
km_setsprchr		macro		[var,obj,color,prio,flip,offset]
MYNARG	=	NARG
	CHK_NARG	5,6
	km_memchecka16

	IFEQ	NARG-5
objnam	=	{obj}+obj_offset
	ELSEIF
objnam	=	{obj}+{offset}
	ENDC

	lda	#(objnam!({color}<<9)!({flip}<<14)!({prio}<<12))
	sta.\0	{var}
	endm
;--------------------------------------------------------------------

;========================== Sprite Set ==============================
km_SetSprite	macro	[para]
;*Init: data bank 7e *
	km_memchecki16

	IFEQ	NARG

	ifeq	longa
	sta	sprites,y
	iny
	elseif
	sta	sprites,y
	iny
	iny
	endc

	ELSEIF

	ifeq	longa
	lda	{para}
	sta	sprites,y
	iny
	elseif
	lda	{para}
	sta	sprites,y
	iny
	iny
	endc

	ENDC
	endm
;--------------------------------------------------------------------
km_SetSpriteX	macro	[x]
	km_memchecki16

	km_chga8

	IFEQ	NARG-1
	lda	{x}
	ENDC
	sta	sprites,y
	iny

	km_reta16
	endm
;--------------------------------------------------------------------
km_SetSpriteY	macro	[y]
	km_memchecki16
	km_chga8
	IFEQ	NARG-1
	lda	{y}
	ENDC

	dec	a
	sta	sprites,y
	iny

	km_reta16
	endm
;--------------------------------------------------------------------
km_SetSpriteC4X	macro	[x]
	km_memchecki16

	km_chga8

	IFEQ	NARG-1
	lda	{x}
	ENDC
	sec
	sbc	#8
	sta	sprites,y
	iny

	km_reta16
	endm
;--------------------------------------------------------------------
km_SetSpriteC4Y	macro	[y]
	km_memchecki16
	km_chga8

	IFEQ	NARG-1
	lda	{y}
	ENDC
	sec
	sbc	#8+1
	sta	sprites,y
	iny

	km_reta16
	endm
;--------------------------------------------------------------------
km_SetSpriteC4XY	macro	[x,y]
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecki16

	km_chga8
	lda	{x}
	sec
	sbc	#8
	sta	sprites,y
	iny

	lda	{y}
	sec
	sbc	#8+1
	sta	sprites,y
	iny

	km_reta16
	endm
;--------------------------------------------------------------------
km_SetSpriteXY	macro	[x,y]
;sprites charcter data set
	km_memchecki16

	IFEQ	NARG

	ifeq	longa
;mem8,idx16
	a16
	sec
	sbc	#$100
	sta	sprites,y
	iny
	iny
	a8
	elseif
;mem16,idx16
	sec
	sbc	#$100
	sta	sprites,y
	iny
	iny
	endc
	ELSEIF

	IFEQ	NARG-1

	ifeq	LONGA
;mem8,idx16
	a16
	lda	{x}
	sec
	sbc	#$100
	sta	sprites,y
	iny
	iny
	a8
	elseif
;mem16,idx16
	lda	{x}
	sec
	sbc	#$100
	sta	sprites,y
	iny
	iny
	endc

	ELSEIF

	ifeq	LONGA
;mem8,idx16
	lda	{x}
	sta	sprites,y
	iny

	lda	{y}
	dec	a
	sta	sprites,y
	iny

	elseif
;mem16,idx16
	lda	{y}
	dec	a
	and	#$00ff
	xba
	sta	kmwork

	lda	{x}
	and	#$00ff
	ora	kmwork
	sta	sprites,y
	iny
	iny
	endc

	ENDC

	ENDC
	endm
;--------------------------------------------------------------------
km_SetSpriteXY_ImOff	macro	[x,y,xoff,yoff]
MYNARG	=	NARG
	CHK_NARG	4
	km_memchecki16
	km_chga8
;Mem8
	lda.\0	{x}
	clc
	adc	#{xoff}
	sta	sprites,y
	iny
	lda.\0	{y}
	clc
	adc	#{yoff}-1
	sta	sprites,y
	iny
	km_reta16
	endm

	IFEQ	1
;mem16
	lda.\0	{x}
	clc
	adc	#{xoff}+({yoff}<<8-$100)&$ff00	;Y zahyou 1 dot hosei
	sta	sprites,y
	iny
	iny
	ENDC
;--------------------------------------------------------------------
km_SetSpriteImXY	macro	[x,y]
;sprites charcter data set
MYNARG	=	NARG
	CHK_NARG	2

	km_memchecki16

	IFEQ	LONGA

	lda	#{x}
	sta	sprites,y
	iny

	lda	#({y})-1
	sta	sprites,y
	iny

	elseif

	lda	#(((({y})-1)<<8)+{x})
	sta	sprites,y

	iny
	iny

	endc
	endm
;--------------------------------------------------------------------
km_SetSpriteImXY_Off	macro	[x,y]
;sprites charcter data set
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecki16
	km_chga8

	lda	#{x}
	clc
	adc	ksproffx
	sta	sprites,y
	iny
	lda	#{y}-1
	clc
	adc	ksproffy
	sta	sprites,y
	iny

	km_reta16
	endm

	ifeq	1
	lda	#({y}-1)<<8+{x}
	clc
	adc	ksproffx
	sta	sprites,y

	iny
	iny
	endc
;--------------------------------------------------------------------
km_SetSpriteImXY_ImOff	macro	[xy,xyoff]
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecki16

	ifeq	longa
;Mem8 idx16
;---------- obj (x,y) postion ----------
	a16
	lda	#{xy}+{xyoff}-$100
	sta	sprites,y
	iny
	iny
	a8
	elseif
;mem16 idx16
;---------- obj (x,y) postion ----------
	lda	#{xy}+{xyoff}-$100
	sta	sprites,y
	iny
	iny
	endc
	endm
;--------------------------------------------------------------------
km_SetSpriteChrVar	macro	[var,chrbase,color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	km_memchecki16

	CHK_NARG	5,6

	IFEQ	NARG-5
objnam	=	obj_offset+{chrbase}
	ELSEIF
objnam	=	{offset}+{chrbase}
	ENDC

	ifeq	longa

	lda	{var}
	a16
	and	#$ff
	clc
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	a8
	elseif

	lda	{var}
	clc
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	endc
	endm
;--------------------------------------------------------------------
km_SetSpriteChrA	macro	[chrbase,color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	km_memchecki16

	CHK_NARG	4,5
	IFEQ	NARG-4
objnam	=	obj_offset+{chrbase}
	ELSEIF
objnam	=	{offset}+{chrbase}
	ENDC

	IFEQ	LONGA
;Initial :Acc
	a16
	and	#$ff
	clc
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	a8

	elseif
;Init :Acc
	clc
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	ENDC
	endm
;--------------------------------------------------------------------
km_SetSpriteChrVal	macro	[val,color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	km_memchecki16

	CHK_NARG	4,5
	IFEQ	NARG-4
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

	IFEQ	LONGA
	a16
	lda	#({val}+objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	a8
	elseif

	lda	#({val}+objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	endc
	endm
;--------------------------------------------------------------------
km_SetSpriteChrVar_Off	macro	[var,color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	km_memchecki16

	CHK_NARG	4,5
	IFEQ	NARG-4
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

	ifeq	longa

	lda	{var}
	a16
	and	#$ff
	clc
	adc	kw_sproff
	clc
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	a8
	elseif

	lda	{var}
	clc
	adc	kw_sproff
	clc
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	endc
	endm
;--------------------------------------------------------------------
km_SetSpriteChrA_Off	macro	[color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	km_memchecki16

	CHK_NARG	3,4
	IFEQ	NARG-3
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

	IFEQ	LONGA
;Initial :Acc
	a16
	and	#$ff
	clc
	adc	kw_sproff
	clc
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	a8

	elseif
;Init :Acc
	clc
	adc	kw_sproff
	clc
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	ENDC
	endm
;--------------------------------------------------------------------
km_SetSpriteChrVal_Off	macro	[val,color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	km_memchecki16

	CHK_NARG	4,5
	IFEQ	NARG-4
objnam	=	obj_offset+{val}
	ELSEIF
objnam	=	{offset}+{val}
	ENDC


	IFEQ	LONGA
	a16
	lda	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	clc
	adc	kw_sproff
	sta	sprites,y
	iny
	iny
	a8
	elseif

	lda	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	clc
	adc	kw_sproff
	sta	sprites,y
	iny
	iny
	endc
	endm
;--------------------------------------------------------------------
km_SetSpriteChrCol	macro	[base,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	CHK_NARG	3,4

	km_memchecka16i16

	IFEQ	NARG-3
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

;	clc
;	adc	#((objnam)+{base})&BM
;	sta	sprites,y
;	iny
;	xba
;	adc	#(objnam+{base})>>8!({flip}<<6)!({prio}<<4)
;	sta	sprites,y
;	iny

	clc
	adc	#(objnam+{base})!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny
	endm
;--------------------------------------------------------------------
km_SetSpriteCol	macro	[base,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	CHK_NARG	3,4

	km_memchecki16

	IFEQ	NARG-3
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

	IFEQ	LONGA
	pha
	lda	#((objnam)+{base})&BM
	sta	sprites,y
	iny
	pla
	asl	a
	clc
	adc	#(objnam+{base})>>8!({flip}<<6)!({prio}<<4)
	sta	sprites,y
	iny
	ELSEIF

	xba
	asl	a
	clc
	adc	#(objnam+{base})!({flip}<<14)!({prio}<<12)
	sta	sprites,y
	iny
	iny

	ENDC
	endm
;--------------------------------------------------------------------
km_SetSpriteAtt	macro	[char,offset]
;sprites charcter data set
MYNARG	=	NARG
	CHK_NARG	1,2

	km_memchecki16

	IFEQ	NARG-1
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

	IFEQ	LONGA
	pha
	lda	#({char}+objnam)&BM
	sta	sprites,y
	iny
	pla
	clc
	adc	#({char}+objnam)>>8
	sta	sprites,y
	iny

	elseif
	clc
	adc	#({char}+objnam)
	sta	sprites,y
	iny
	iny

	endc
	endm
;--------------------------------------------------------------------
SetSprXYChr	macro	[x,y,character,color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	CHK_NARG	6,7

	km_memchecki16

	IFEQ	NARG-6
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

	IFEQ	LONGA

	lda	{x}
	sta	sprites,y
	iny

	lda	{y}
	dec	a
	sta	sprites,y
	iny

	lda	{character}
	clc
	adc	#(objnam)&BM
	sta	sprites,y
	iny

	lda	{character}+1
	adc	#(objnam>>8)!({color}<<1)!({flip}<<6)!({prio}<<4)
	sta	sprites,y
	iny

	ELSEIF

	lda	{y}
	dec	a
	and	#$00ff
	xba
	ora	{x}
	sta	sprites,y

	iny
	iny

	lda	{character}
	adc	#(objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y

	iny
	iny

	ENDC
	endm
;--------------------------------------------------------------------
SetSprXYChr_Im	macro	[x,y,character,color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	CHK_NARG	6,7
	km_memchecki16

	IFEQ	NARG-6
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

	IFEQ	LONGA
	lda	#{x}
	sta	sprites,y
	iny

	lda	#{y}-1
	sta	sprites,y
	iny

	lda	#({character}+objnam)&BM
	sta	sprites,y
	iny

	lda	#({character}+objnam)>>8!({color}<<1)!({prio}<<4)!({flip}<<6)
	sta	sprites,y
	iny

	elseif

	lda	#(((({y})-1)<<8)+{x})
	sta	sprites,y

	iny
	iny

	lda	#({character}+objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y

	iny
	iny
	endc
	endm
;--------------------------------------------------------------------
SetSprXYOffChr_Im	macro	[x,y,character,color,prio,flip,offset]
;sprites charcter data set
MYNARG	=	NARG
	CHK_NARG	6,7
	km_memchecki16

	IFEQ	NARG-6
objnam	=	obj_offset
	ELSEIF
objnam	=	{offset}
	ENDC

	IFEQ	LONGA

	lda	#{x}
	clc
	adc	ksproffx
	sta	sprites,y
	iny

	lda	#({y})-1
	clc
	adc	ksproffy
	sta	sprites,y
	iny

	lda	#({character}+objnam)&BM
	sta	sprites,y
	iny

	lda	#({character}+objnam)>>8!{color}<<1!{flip}<<6!{prio}<<4
	sta	sprites,y
	iny

	elseif

	lda	#(((({y})-1)<<8)+{x})
	clc
	adc	ksproffx
	sta	sprites,y

	iny
	iny

	lda	#({character}+objnam)!({color}<<9)!({flip}<<14)!({prio}<<12)
	sta	sprites,y

	iny
	iny
	endc
	endm
;---------------------------------------------------------------------------
SetSprDummy	macro
	km_memchecka8i16

	jsr	SetSprDummy_sub

	endm
;---------------------------------------------------------------------------
km_SetSpriteSize1	macro
	jsr	SetSprSize1
	endm
;---------------------------------------------------------------------------
km_SetSpriteSizesb1	macro
	jsr	SetSprSize_sb1
	endm
;---------------------------------------------------------------------------
km_SetSpriteSizesb2	macro
	jsr	SetSprSize_sb2
	endm
;---------------------------------------------------------------------------
km_SetSpriteSizesb3	macro
	jsr	SetSprSize_sb3
	endm
;---------------------------------------------------------------------------
km_SetSpriteSizesb4	macro
	jsr	SetSprSize_sb4
	endm
;---------------------------------------------------------------------------
km_SetSpriteSizedb1	macro
	jsr	SetSprSize_db1
	endm
;---------------------------------------------------------------------------
km_SetSpriteSizedb2	macro
	jsr	SetSprSize_db2
	endm
;---------------------------------------------------------------------------
km_SetSpriteSizedb3	macro
	jsr	SetSprSize_db3
	endm
;---------------------------------------------------------------------------
km_SetSpriteSizedb4	macro
	jsr	SetSprSize_db4
	endm
;---------------------------------------------------------------------------
km_SetSpriteSize	macro
;Init	Yregister... sprites pointer
	jsr	SetSprSize1
	endm
;--------------------------------------------------------------------
km_SetSpriteSizeDouble_l	macro
;Init	Yregister... sprites pointer
	jsl	SetSprSize_double_sub_l
	endm
;--------------------------------------------------------------------
km_SetSpriteSize16Double	macro
;Init	Yregister... sprites pointer
	jsr	mm_SetSprSize_double_sub
	endm
;--------------------------------------------------------------------
BlockTransSPrites	macro	[sourceadr]
;Init	Yreg=Sprites address
	phx
	savemode
	ai16
	BlockTransSprSub	{sourceadr}
	returnmode
	plx
	endm
;--------------------------------------------------------------------
BlockTransSpritesOffset	macro	[sourceadr]
;sprites charcter data set
MYNARG	=	NARG
	km_memcheck
	phx

	ldx	#({sourceadr}+2)&WM
	stx	address

	lda	#{sourceadr}>>16
	sta	address+2

	ai16
	lda.l	{sourceadr}
	sta	kcounter
	jsr	BlockTransSprOffSub
	a8
	plx
	endm
;--------------------------------------------------------------------
BlockTransSpritesBig	macro	[sourceadr]
;Init	Yreg = Sprites pointer
;Exit	Yreg = sprites pointer

	phx
	savemode
	ai16
;--------------------------------------------------------------------------
	lda.l	{sourceadr}		;transfer value
	jsr	BlockSprsize_sub	;[sprites size set]
;--------------------------------------------------------------------------
	BlockTransSprSub  {sourceadr}	;[sprite data set]

	ifeq	1
	ldx	#({sourceadr}&WM)+2	;source addrsss(ROM pointer)
	tya
	clc
	adc	#(sprites)&WM
	tay				;dest address(sprites)

	lda.l	{sourceadr}
	dec	a			;value

	phb
	db	$54
	db	(sprites)>>16		;dest
	db	({sourceadr})>>16	;source
	plb

	tya
	sec
	sbc	#(sprites)&WM
	tay
	endc

	returnmode
	plx
	endm
;--------------------------------------------------------------------
BlockTransSpritesBigDouble	macro	[sourceadr]
;Init	Yreg = Sprites pointer
;Exit	Yreg = sprites pointer

	phx
	savemode

	ai16
	lda.l	{sourceadr}			;tensou ryou
	jsr	BlockSprSize_double_sub		;Sprites Size Set
	BlockTransSprSub  {sourceadr}		;Sprites Data set

	returnmode
	plx
	endm
;--------------------------------------------------------------------------
;*kokokara shita wa tukatte inai *
	IFEQ	1
	ldx	#({sourceadr}&WM)+2	;source addrsss(ROM pointer)
	tya
	clc
	adc	#(sprites)&WM
	tay				;dest address(sprites)

	lda.l	{sourceadr}
	dec	a			;value

	phb
	db	$54
	db	(sprites)>>16		;dest
	db	({sourceadr})>>16	;source
	plb

	tya
	sec
	sbc	#(sprites)&WM
	tay
	ENDC
;--------------------------------------------------------------------
BlockTransSprSub	macro	[sourceadr]

	ldx	#({sourceadr}&WM)+2	;source addrsss(ROM pointer)
	tya
	clc
	adc	#(sprites)&WM
	tay				;dest address(sprites)

	lda.l	{sourceadr}
	dec	a			;value

	phb
	db	$54
	db	(sprites)>>16		;dest
	db	({sourceadr})>>16	;source
	plb

	tya
	sec
	sbc	#(sprites)&WM
	tay
	endm
;--------------------------------------------------------------------
BlockCopySprites	macro	[source]
;*** Init ***
;Xreg :data pointer
;Yreg :spritest pointer
	km_memchecka16i16

	lda.l	{source},x
	kdivu4			;/4
	sta	kmwork		;transfer Value

.loop\@	lda.l	{source}+2,x
	sta	sprites,y	;(X,Y)
	inx
	inx
	iny
	iny
	lda.l	{source}+2,x
	sta	sprites,y	;(Character,Att)
	inx
	inx
	iny
	iny
	dec	kmwork
	bne	.loop\@
	endm
;--------------------------------------------------------------------
BlockCopySprOff	macro	[source,hoseix,hoseiy]
;Init :Xreg (Data Pointer)
;     :Yreg (sprite pointer)
MYNARG	=	NARG
	CHK_NARG	3

	savemode

	ai16
	lda.l	{source},x
	km_divu4
	sta	kmwork		;Tensou Value
.loop\@
	a8
	lda.l	{source}+2,x
	clc
	adc	{hoseix}
	sta	sprites,y	;X zahyou
	inx
	iny

	lda.l	{source}+2,x
	clc
	adc	{hoseiy}
	sta	sprites,y	;Y zahyou
	inx
	iny

	a16
	lda.l	{source}+2,x
	sta	sprites,y	;Character,Att
	inx
	inx
	iny
	iny

	dec	kmwork
	bne	.loop\@

	returnmode
	endm

;--------------------------------------------------------------------
BlockCopySprOffBig	macro	[source,hoseix,hoseiy]
;*** Init ***
;Xreg :Data address
;Yreg :Sprites pointer
MYNARG	=	NARG
	CHK_NARG	3
	savemode

	ai16
	lda.l	{source},x
	jsr	BlockSprsize_sub	;[sprites size set]

	lda.l	{source},x
	km_divu4
	sta	kmwork		;Tensou Value
.loop\@
	a8
	lda.l	{source}+2,x
	clc
	adc	{hoseix}
	sta	sprites,y	;X zahyou
	inx
	iny

	lda.l	{source}+2,x
	clc
	adc	{hoseiy}
	sta	sprites,y	;Y zahyou
	inx
	iny

	a16
	lda.l	{source}+2,x
	sta	sprites,y	;Character,Att
	inx
	inx
	iny
	iny

	dec	kmwork
	bne	.loop\@

	returnmode
	endm
;=====================================================================
;*								*
;*			SOUND Macros				*
;*								*
;=====================================================================
km_setsndmode	macro	[addr]
MYNARG	=	NARG
	CHK_NARG	0,1
	km_chga16

	IFEQ	NARG
	lda	kw_GameMode
	asl	a
	asl	a
	tax
	lda.l	kgamesequence+2,x	;'94/8/19 ni syusei	
	sta	kw_setsndaddr
	ELSEIF
	lda	#(sound_{addr}-SoundTransTbl)&WM
	sta	kw_setsndaddr
	ENDC
	km_reta8
	endm
;-------------------------------------------------------------
km_ldxsoundtblptr	macro
	km_memchecki16		;index mode check
	ldx	kw_setsndaddr
	endm
;-------------------------------------------------------------
;*********************************************************************
;*		Sound Label Macros				*
;*********************************************************************
;---------------------------------------------------------------------
km_port2labelstart	macro
port2tmp	=	0
	endm
;---------------------------------------------------------------------
km_port2label	macro	[label]
sport2_{label}	equ	port2tmp
port2tmp	=	port2tmp+1
	endm
;---------------------------------------------------------------------
km_port2smlabel	macro	{label}
sport2_{label}	equ	port2tmp
	endm
;---------------------------------------------------------------------
km_port3labelstart	macro
port3tmp	=	0
	endm
;---------------------------------------------------------------------
km_port3label	macro	[number]
sport3_{number}	equ	port3tmp
port3tmp	=	port3tmp+1
	endm
;---------------------------------------------------------------------
km_port3SMlabel	macro	{label}
sport3_{number}	equ	port3tmp
	endm
;--------------------------------------------------------------------------
;*********************************************************************
;*			Sound Table Macros			*
;*********************************************************************
sndtbldata	macro
MYNARG	=	NARG
sndval	= 	MYNARG-1

	ifeq	MYNARG
	printf	"** %q%f%q: (%l) Error: No Sound Parameter !!%n"
	error+
	endc

	ifgt	MYNARG-9
	printf	"** %q%f%q: (%l) Error: Too Many Sound Parameter !!%n"
	error+
	endc
sound_\1
;* 0 *
	ifeq	sndval-0
	db	sndval
	db	ksf_\1
	endc

;* 1 *
	ifeq	sndval-1
	db	sndval
	db	ksf_\1
	dl	\2
	endc
;* 2 *
	ifeq	sndval-2
	db	sndval
	db	ksf_\1
	dl	\2
	dl	\3
	endc
;* 3 *
	ifeq	sndval-3
	db	sndval
	db	ksf_\1
	dl	\2
	dl	\3
	dl	\4
	endc
;* 4 *
	ifeq	sndval-4
	db	sndval
	db	ksf_\1
	dl	\2
	dl	\3
	dl	\4
	dl	\5
	endc
;* 5 *
	ifeq	sndval-5
	db	sndval
	db	ksf_\1
	dl	\2
	dl	\3
	dl	\4
	dl	\5
	dl	\6
	endc
;* 6 *
	ifeq	sndval-6
	db	sndval
	db	ksf_\1
	dl	\2
	dl	\3
	dl	\4
	dl	\5
	dl	\6
	dl	\7
	endc
;* 7 *
	ifeq	sndval-7
	db	sndval
	db	ksf_\1
	dl	\2
	dl	\3
	dl	\4
	dl	\5
	dl	\6
	dl	\7
	dl	\8
	endc
;* 8 *
	ifeq	sndval-8
	db	sndval
	db	ksf_\1
	dl	\2
	dl	\3
	dl	\4
	dl	\5
	dl	\6
	dl	\7
	dl	\8
	dl	\9
	endc

	endm
;--------------------------------------------------------------------------
sndspaddr	macro	[addr]
	dw	(soundsp_{addr}-SoundSpecialTransTbl)&WM
	endm
;--------------------------------------------------------------------------
sndsptbldata	macro
MYNARG	=	NARG
sndval	= 	MYNARG-1

	ifeq	MYNARG
	printf	"** %q%f%q: (%l) Error: No Sound Parameter !!%n"
	error+
	endc
	ifgt	MYNARG-4
	printf	"** %q%f%q: (%l) Error: Too Many Sound Parameter !!%n"
	error+
	endc
soundsp_\1
;* 0 *
	ifeq	sndval-0
	db	sndval
	endc

;* 1 *
	ifeq	sndval-1
	db	sndval
	dl	\2
	endc
;* 2 *
	ifeq	sndval-2
	db	sndval
	dl	\2
	dl	\3
	endc
;* 3 *
	ifeq	sndval-3
	db	sndval
	dl	\2
	dl	\3
	dl	\4
	endc
	endm
;*********************************************************************
;*		Sound Data Transfer Macros			*
;*********************************************************************
;---------------------------------------------------------------------
KSoundProgTrans	macro

	km_memcheck
	ldy	#fox2snd&WM
	lda	#fox2snd>>16
	jsl	transfersoundprog_l	;transfer sound data to APU 

	ldx	#$3000
.wait\@	dex
	bne	.wait\@
	endm
;---------------------------------------------------------------------
KSoundTrans	macro	[address,player]
MYNARG	=	NARG
	CHK_NARG	1,2

	km_memchecka8i16

	IFEQ	NARG-1
	km_clrflag	kw_soundflag,ksf_addrchange
	ldy	#{address}&WM
	lda	#{address}>>16
	jsl	Initial_sound_l	;transfer sound data to APU 
	ELSEIF

tmpsnd = {player}-1
	ifeq	tmpsnd

	km_clrflag	kw_soundflag,ksf_addrchange
	ldy	#{address}&WM
	lda	#{address}>>16
	jsl	Initial_sound_l	;transfer sound data to APU 

	elseif

	km_setflag	kw_soundflag,ksf_addrchange
	ldy	#{address}&WM
	lda	#{address}>>16
	jsl	Initial_sound_l	;transfer sound data to APU 
	km_clrflag	kw_soundflag,ksf_addrchange
	endc

	ENDC
	endm
;---------------------------------------------------------------------
KBGMAddr	macro	[addr]
	km_memchecka8i16
	ldy	#{addr}&WM
	sty	kw_soundtransaddr
	lda	#{addr}>>16
	sta	kw_soundtransaddr+2
	endm
;---------------------------------------------------------------------
KBGMInterrupt	macro	[addr]
	kbgmaddr		{addr}
	km_pushgamesyori
	km_setgamesyori		bgmtrans
	endm
;---------------------------------------------------------------------
KSoundBGMTrans	macro
	km_memchecka8i16
	jsl	TransferSoundBGM_l	;transfer sound data to APU 
	endm
;---------------------------------------------------------------------
KSoundBGMTestTrans	macro
	km_memchecka8i16
	a16
	lda.l	conf_bgm
	and	#$ff
	asl	a
	cmp	#configSNDtblLen
	bcc	.skip\@
	lda	#0
.skip\@
	tax
	lda.l	configSNDtbl,x
	sta	kw_setsndaddr
	tax
	a8
	jsl	TransferSoundBGM_l	;transfer sound data to APU 
	endm
;---------------------------------------------------------------------
KSoundPlayerTrans	macro
	km_memchecka8i16
	jsl	TransferSoundPlayer_l	;transfer sound data to APU 
	endm
;---------------------------------------------------------------------
KSoundTransWait	macro
	km_memchecki16

	ldx	#0
.wait1\@	cpx	apu_port0
	bne	.wait1\@
.wait2\@	cpx	apu_port2
	bne	.wait2\@

	ifeq	1
	ldx	#$3000
.wait\@	dex
	bne	.wait\@
	endc
	endm
;---------------------------------------------------------------------
km_soundwait	macro
	lda	#iv_sndwaitirq
	sta	trans_flag		;[irq flag]
	km_waittrans			;[irq wait]
	endm
;---------------------------------------------------------------------
km_soundallstop	macro
	KBGM	fast_FADEOUT
	km_setsndflag	allstop
	endm
;---------------------------------------------------------------------
km_bgmfade		macro	[timer]
	km_memchecka8i16
	ldx	#{timer}
	jsl	KBGMFade_l
	endm
;*********************************************************************
;*			Sound Port 0				*
;*********************************************************************
;---------------------------------------------------------------------
KBGM	macro	[label]
	lda	#kbgm_{label}
	jsl	kbgm_l
	endm
;---------------------------------------------------------------------
KBGM_a	macro
	jsl	kbgm_l
	endm
;---------------------------------------------------------------------
km_pushsndplace	macro
	lda	bgm_place
	sta	bgm_placeback
	endm
;---------------------------------------------------------------------
km_setsndplace	macro	[label]
	km_memchecki16
	km_chga16
	lda	#sport3_place_{label}
	sta	bgm_place
	jsl	setport3_l
	km_reta8
	endm
;---------------------------------------------------------------------
km_pullsndplace	macro
	km_memchecki16
	km_chga16
	lda	bgm_placeback
	jsl	setport3_l
	km_reta8
	endm
;*********************************************************************
;*			Sound Port 1&2				*
;*********************************************************************
km_setsoundport1		macro	[label]
MYNARG	=	NARG

	km_memchecka8

	IFNE	NARG>1
	printf	"** %q%f%q: (%l) Error: Too Many Parameters (km_setsoundport1)!!%n"
	error+
	endc

	ifeq	narg
	sta	sdport1
	endc

	ifeq	narg-1
	lda	#sport1_{label}
	sta	sdport1
	endc
	endm
;-------------------------------------------------------------------------
km_setsndport2		macro	[reg,label]
	km_chga8
MYNARG	=	NARG
	CHK_NARG	1,2
	IFEQ	NARG-1
	lda	#sport2_{label}
	ENDC
	sta.w	alx_snd2,{reg}
	km_reta16
	endm
;-------------------------------------------------------------------------
km_setsoundport2		macro	[label,dist,pos]
MYNARG	=	NARG

	km_memchecka8

	IFNE	NARG>3
	printf	"** %q%f%q: (%l) Error: Too Many Parameters (km_setsoundport2)!!%n"
	error+
	endc

	IFEQ	NARG
	sta	sdport2
	endc


	IFEQ	NARG-1
	lda	#sport2_{label}
	sta	sdport2

	endc

	IFEQ	NARG-2
	lda	#sport2_{label}!sport2_{dist}!sport2_center
	sta	sdport2

	endc

	IFEQ	NARG-3

	lda	#sport2_{label}!sport2_{dist}!sport2_{pos}
	sta	sdport2
	endc

	endm
;-------------------------------------------------------------------------
km_setsoundport2_dist	macro	[dist]
MYNARG	=	NARG

	km_memchecka8

	lda	sdport2
	and	#%11001111
	ora	#sport2_{dist}
	sta	sdport2
	endm
;-------------------------------------------------------------------------
km_setsoundport2_pos		macro	[pos]
MYNARG	=	NARG

	km_memchecka8
	lda	sdport2
	and	#%00111111
	ora	#sport2_{pos}
	sta	sdport2
	endm
;*********************************************************************
;*			Sound Port 3				*
;*********************************************************************
ksound	macro	[name,flag,player]
MYNARG	=	NARG
	km_memchecki16
	km_chga16
;* player *
_sndpl	= 0

	ifeq	narg-3
	ifc	"{player}","2"
_sndpl	=	ksf_plmode<<8
	endc
	endc

	ifeq	narg-1
	lda	#sport3_{name}
	jsl	setport3_l

	elseif

	lda	#sport3_{name}!_sndpl!(ksf_{flag})<<8
	jsl	setport3_l
	endc

	km_reta8
	endm
;---------------------------------------------------------------------
Ksound_a	macro
	km_memchecki16
	km_chga16
	and	#$ff
	jsl	setport3_l
	km_reta8
	endm
;---------------------------------------------------------------------
Ksoundwork	macro	[number,work]
MYNARG	=	NARG
	CHK_NARG	1,2
	km_memchecki16
	km_chga16
	ifeq	narg-1
	lda	#sport3_{number}
	jsl	setport3_l

	elseif
	
	lda.\0	{work}
	and	#$ff
	xba
	clc
	adc	#sport3_{number}
	jsl	setport3_l
	endc
	km_reta8
	endm
;---------------------------------------------------------------------
Kplsound	macro	[obj,label,flag]
MYNARG	=	NARG
tmp_x = 0
tmp_y = 0
tmp_{obj} = 1
	CHK_NARG	2,3
	ifeq	tmp_x+tmp_y
	error	<Illegal strategy parameter! - has to be x or y.>
	endc

	km_memchecki16

	km_chga16
	lda	#sport3_{label}
	cp{obj}	playpt1		;player pointer
	beq	.skip\@

;;	cp{obj}	playhpt1	;player heap poinmter
;;	beq	.skip\@

	ora	#(ksf_plmode)<<8	;player2 flag on
.skip\@
	ifeq	narg-3
	ora	#(ksf_{flag})<<8
	endc

	jsl	setport3_l
	km_reta8
	endm
;*********************************************************************
;*		Check Sound Bug					*
;*********************************************************************
;---------------------------------------------------------------------
km_readport0	macro
	km_memchecka8

	phb

	lda	#0
	pha
	plb		;data bank 0

	lda	apu_port0
	plb
	endm
;---------------------------------------------------------------------
km_readport1	macro
	km_memchecka8

	phb

	lda	#0
	pha
	plb		;data bank 0

	lda	apu_port1
	plb
	endm
;---------------------------------------------------------------------
km_readport2	macro
	km_memchecka8

	phb
	lda	#0
	pha
	plb	;data bank 0

	lda	apu_port2
	plb
	endm
;---------------------------------------------------------------------
km_readport3	macro
	km_memchecka8

	phb

	lda	#0
	pha
	plb	;data bank 0

	lda	apu_port3
	plb
	endm
;---------------------------------------------------------------------
km_waitport3	macro	;port 3 no sound wo zenbu narasumade wait

.wait\@	ldx	sdgpt3	;sdgpt3 .. SOUND DATA wo SET surutameno POINTER
	cpx	sdspt3	;sdspt3	.. SOUND DATA wo buffer ni touroku suru tameno POINTER
	bne	.wait\@

	endm
;---------------------------------------------------------------------
kbugapuport	macro
	ifne	portinfo
	ifne	kportinfo
	km_memchecka8
	pha
	phb

	lda	#0
	pha
	plb		;data bank 0

	lda	apu_port0
	printb	port0
	lda	apu_port0
	printh	port0
	lda	apu_port1
	printb	port1
	lda	apu_port2
	printb	port2
	lda	apu_port3
	printh	port3

	plb
	pla
	endc
	endc
	endm
;---------------------------------------------------------------------
kbugapuport0	macro
	ifne	portinfo
	ifne	kportinfo
	km_memchecka8

	pha
	phb

	lda	#0
	pha
	plb		;data bank 0

	lda	bgm_music
	printb	workport0
	lda	apu_port0
	printb	port0
	plb
	pla
	endc
	endc
	endm
;=====================================================================
;*		Radar Maps Macros				*
;=====================================================================
km_setrdmap	macro	[stage]
	km_memcheck

;	ldx	#(rdmap_{stage}START-radarmaptbl)&WM
;	lda.l	radarmaptbl+1,x
;	sta.l	kenemynumber

;* kondo no merge de naosu 94/9/16 *
;;	lda	#1
;;	sta.l	kenemynumber

	a16
	ldx	#(rdmap_{stage}START)&WM
	lda	#(rdmap_{stage}END-rdmap_{stage}START-1)&BM
	jsr	setrdmap
	a8
	endm
;---------------------------------------------------------------------
km_setrdmapptr	macro	[stage]
	km_memcheck
	a16
	lda	#(rdmap_{stage}START-radarmaptbl)&WM
	sta	KRDMapPtr
	a8
	endm
;---------------------------------------------------------------------
km_ldxrdmapptr	macro
	ldx	KRDMapPtr
	endm
;---------------------------------------------------------------------
km_rdmapstart	macro	[stage]
tmprdmpval = 0
rdmap_{stage}START
{stage}infostart
	db	(((rdmap_{stage}END-rdmap_{stage}START)-({stage}infoend-{stage}infostart))&BM)/RadarMapDataVal
	db	enemytotal_{stage}
{stage}infoend
		endm
;---------------------------------------------------------------------
km_rdmapend		macro	[stage]
	IFGT	tmprdmpval-64
	printf	"** %q%f%q: (%l) Error: Should Building number =<64 %n"
	error+
	ENDC
rdmap_{stage}END
		endm
;---------------------------------------------------------------------
km_rdmap		macro	[x,z,chara,att]
;6 byte
MYNARG	=	NARG
	CHK_NARG	3,4
tmprdmpval = tmprdmpval+1
	dw	{x}
	dw	{z}
	db	sprrdmap_{chara}
	IFEQ	NARG-3
	db	0
	ELSEIF
	db	{att}
	ENDC
	endm
;=====================================================================
;*			Pointer Macro				*
;=====================================================================
km_incptr	macro	[size,var,end]
	IFNE	NARG-3
	printf	"** %q%f%q: (%l) Error: Should be parameter number = 3 %n"
	error+
	ENDC

	km_CHG_MODE	{size}

	lda	{var}
	inc	a
	cmp	{end}
	bne	.skip\@
	lda	#0
.skip\@	sta	{var}

	km_CHG_MODEBACK	{size}
	endm
;---------------------------------------------------------------------
km_incincptr		macro	[size,var,end]
	IFNE	NARG-3

	printf	"** %q%f%q: (%l) Error: Should be parameter number = 3 %n"
	error+

	ENDC

	km_CHG_MODE

	lda	{var}
	inc	a
	inc	a
	cmp	{end}
	bne	.skip\@
	lda	#0
.skip\@	sta	{var}

	km_CHG_MODEBACK
	endm
;---------------------------------------------------------------------
km_decptr		macro	[size,var,init]
	IFNE	NARG-3
	printf	"** %q%f%q: (%l) Error: Should be parameter number = 3 %n"
	error+

	ENDC

	km_CHG_MODE

	lda	{var}
	dec	a
	bne	.skip\@
	lda	{init}
.skip\@	sta	{var}

	km_CHG_MODEBACK
	endm
;---------------------------------------------------------------------
km_decdecptr		macro	[size,var,init]
	IFNE	NARG-3

	printf	"** %q%f%q: (%l) Error: Should be parameter number = 3 %n"
	error+

	ENDC

	km_CHG_MODE

	lda	{var}
	dec	a
	dec	a
	bne	.skip\@
	lda	{init}
.skip\@	sta	{var}

	km_CHG_MODEBACK
	endm
;*********************************************************************
;*		Soft Ware Timer Macros				*
;*********************************************************************
INCTIMER	macro	[mem,start,end]

_ict_w	=	0
_ict_b	=	1

	IFND	_ict_{mem}
	printf	"Error: Only .B and .W allowed%n"
	fail
	ENDC


	ai16

	lda	#{end}&WM
	sec
	sbc	#{start}&WM
	tax

	IFEQ	_ict_{mem}
	dex
	dex
.loop1\@
	lda.l	{start},x
	inc	a
	sta.l	{start},x

	dex
	dex
	bpl	.loop1\@
	a8
	ELSEIF
	a8
	dex
.loop2\@
	lda.l	{start},x
	inc	a
	sta.l	{start},x
	dex
	bpl	.loop2\@

	ENDC

	endm
;---------------------------------------------------------------------
DECTIMER	macro	[mem,start,end]

_ict_w	=	0
_ict_b	=	1

	IFND	_ict_{mem}
	printf	"Error: Only .B and .W allowed%n"
	fail
	ENDC

	ai16

	lda	#{end}&WM
	sec
	sbc	#{start}&WM
	tax

	IFEQ	_ict_{mem}

	dex
	dex
.loop1\@
	lda.l	{start},x
	dec	a
	bpl	.skip1\@
	lda	#0
.skip1\@	sta.l	{start},x
	dex
	dex
	bpl	.loop1\@
	a8

	ELSEIF
	a8
	dex
.loop2\@
	lda.l	{start},x
	dec	a
	bpl	.skip2\@
	lda	#0
.skip2\@
	sta.l	{start},x
	dex
	bpl	.loop2\@

	ENDC
	endm
;---------------------------------------------------------------------
km_dectimer0	macro	[timer]
	lda.\0	{timer}
	dec	a
	bpl	.skip\@
	lda	#0
.skip\@	sta.\0	{timer}
	endm
;---------------------------------------------------------------------
km_inctimer	macro	[timer,cmpval]
	lda.\0	{timer}
	inc	a
	cmp	#{cmpval}
	bne	.skip\@
	lda	#0
.skip\@	sta.\0	{timer}
	endm
;---------------------------------------------------------------------
km_addtimer	macro	[timer,val,cmpval]
	lda.\0	{timer}
	clc
	adc	#{val}
	cmp	#{cmpval}
	bne	.skip\@
	lda	#0
.skip\@	sta.\0	{timer}
	endm
;*********************************************************************
;*								*
;*			Calculation Macros			*
;*								*
;*********************************************************************
km_cpumultu8u8	macro	[reg]
MYNARG	=	NARG
	CHK_NARG	0,1
;Init :Acc(8 bit)*reg(8bit)
;Exit :reg (16 bit)

	km_memchecka8i16

	sta.l	wrmpya
	t{reg}a
	sta.l	wrmpyb
;8 cycle wait
	nop
	nop
	nop
	nop

	a16
	lda.l	rdmpylr
	ta{reg}
	a8
	endm
;----------------------------------------------------------------------
km_cpumultu8uf8	macro	[reg,val]
;Init :Acc(8 bit) * #val(8 bit)
;Exit :reg (16 bit)
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecka8i16

	sta.l	wrmpya
	lda	#{val}
	sta.l	wrmpyb
;8 cycle wait
	nop
	nop
	nop
	nop

	a16
	lda.l	rdmpylr
	ta{reg}
	a8
	endm
;----------------------------------------------------------------------
km_cpumults8us8	macro
	km_memchecka8i16
	phx
	jsl	kcpumults8s8_l
	plx
	endm
;----------------------------------------------------------------------
km_cpumults8us8_X	macro
	km_memchecka8i16
	jsl	kcpumults8s8_l
	endm
;---------------------------------------------------------------------
km_ppumults15s7	macro	[reg]
;Init	;Acc(8  bit) * reg (16 bit)
;Exit	;Acc(H),reg (M,L) (24 bit)
MYNARG	=	NARG
	CHK_NARG	1
	km_memchecka8i16

	sta.l	m7b

	a16
	t{reg}a
	a8

	sta.l	m7a
	xba
	sta.l	m7a

	A16
	lda.l	mpylr	;(l),(m):16bit
	ta{reg}
	A8
	lda.l	mpyhr	;(h) :8bit
	endm
;---------------------------------------------------------------------
km_ppumults15sf7	macro	[reg,val]
;Init	;reg (16 bit) * #val(8  bit)
;Exit	;Acc(H),reg (M,L) (24 bit)
MYNARG	=	NARG
	CHK_NARG	2
	km_memchecka8i16

	a16
	t{reg}a
	a8

	sta.l	m7a
	xba
	sta.l	m7a

	lda	#{val}
	sta.l	m7b

	A16
	lda.l	mpylr	;(l),(m):16bit
	ta{reg}
	A8
	lda.l	mpyhr	;(h) :8bit
	endm
;---------------------------------------------------------------------
km_multa3	macro

	sta	kmwork
	asl	a
	clc
	adc	kmwork

	endm
;--------------------------------------------------------------------
km_multvar3	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1

	lda	{var}
	asl	a
	clc
	adc	{var}
	sta	{var}
	endc

	ifeq	narg-2

	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in long I mode%n"
	error+
	ENDC

		ifeq	longa
			lda	#0
			xba

			lda	{var}
			asl	a
			clc
			adc	{var}
			ta{reg}
		elseif
			lda	{var}
			asl	a
			clc
			adc	{var}
			ta{reg}
		endc
	endc

	endm
;--------------------------------------------------------------------
km_shiftLUA2	macro
	asl	a
	asl	a
	endm

km_multa4	macro
	km_shiftLUA2
	endm
;--------------------------------------------------------------------
km_multvar4	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1

	lda	{var}
	asl	a
	asl	a
	sta	{var}
	endc

	ifeq	narg-2

	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in long I mode%n"
	error+
	ENDC

		ifeq	longa
			lda	#0
			xba

			lda	{var}
			asl	a
			asl	a
			ta{reg}
		elseif
			lda	{var}
			asl	a
			asl	a
			ta{reg}
		endc
	endc

	endm
;--------------------------------------------------------------------
km_multa5	macro

	sta	kmwork
	asl	a
	asl	a
	clc
	adc	kmwork

	endm
;--------------------------------------------------------------------
km_multvar5	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1

	lda	{var}
	asl	a
	asl	a
	clc
	adc	{var}
	sta	{var}
	endc

	ifeq	narg-2

	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in long I mode%n"
	error+
	ENDC

		ifeq	longa
			lda	#0
			xba
			lda	{var}
			asl	a
			asl	a
			clc
			adc	{var}
			ta{reg}
		elseif
			lda	{var}
			asl	a
			asl	a
			clc
			adc	{var}
			ta{reg}
		endc
	endc

	endm
;--------------------------------------------------------------------
km_multa6	macro
	sta	kmwork
	asl	a
	asl	a
	clc
	adc	kmwork
	clc
	adc	kmwork

	endm
;--------------------------------------------------------------------
km_multvar6	macro	[var,reg]
MYNARG	=	NARG
	CHK_NARG	1,2

	ifeq	narg-1

	lda	{var}
	asl	a
	asl	a
	clc
	adc	{var}
	clc
	adc	{var}
	sta	{var}
	endc

	ifeq	narg-2

	IFEQ	LONGI
	printf	"** %q%f%q: (%l) Error: Should be in long I mode%n"
	error+
	ENDC

		ifeq	longa
			lda	#0
			xba
			lda	{var}
			asl	a
			asl	a
			clc
			adc	{var}
			clc
			adc	{var}
			ta{reg}
		elseif
			lda	{var}
			asl	a
			asl	a
			clc
			adc	{var}
			clc
			adc	{var}
			ta{reg}
		endc
	endc

	endm
;--------------------------------------------------------------------
km_shiftLUA3	macro
	asl	a
	asl	a
	asl	a
	endm

km_multa8	macro
	km_shiftLUA3
	endm
;--------------------------------------------------------------------
km_shiftLUA4	macro
	asl	a	;*02
	asl	a	;*04
	asl	a	;*08
	asl	a	;*16
	endm

km_multa16	macro
	km_shiftLUA4
	endm
;--------------------------------------------------------------------
km_shiftLUA5	macro
	asl	a	;*02
	asl	a	;*04
	asl	a	;*08
	asl	a	;*16
	asl	a	;*32
	endm

km_multa32	macro
	km_shiftLUA5
	endm
;--------------------------------------------------------------------
km_shiftRUA2	macro
	lsr	a
	lsr	a
	endm

km_divu4	macro
	km_shiftRUA2
	endm
;--------------------------------------------------------------------
km_shiftRUA3	macro
	lsr	a
	lsr	a
	lsr	a
	endm

km_divu8	macro
	km_shiftRUA3
	endm	
;--------------------------------------------------------------------
km_shiftRUA4	macro
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	endm
km_divu16	macro
	km_shiftRUA4
	endm
;--------------------------------------------------------------------
km_shiftRUA5	macro
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	endm
km_divu32	macro
	km_shiftRUA5
	endm
;--------------------------------------------------------------------
km_shiftRSA2	macro

	ifeq	LONGA
	cmp	#$80
	ror	a
	cmp	#$80
	ror	a
	elseif
	cmp	#$8000
	ror	a
	cmp	#$8000
	ror	a
	endc
	endm

km_divs4	macro
	km_shiftRSA2
	endm
;--------------------------------------------------------------------
km_shiftRSA3	macro

	ifeq	LONGA
	cmp	#$80
	ror	a
	cmp	#$80
	ror	a
	cmp	#$80
	ror	a
	elseif
	cmp	#$8000
	ror	a
	cmp	#$8000
	ror	a
	cmp	#$8000
	ror	a
	endc
	endm

km_divs8	macro
	km_shiftRSA3
	endm
;--------------------------------------------------------------------
km_shiftRSA4	macro
	ifeq	LONGA
	cmp	#$80
	ror	a
	cmp	#$80
	ror	a
	cmp	#$80
	ror	a
	cmp	#$80
	ror	a
	elseif
	cmp	#$8000
	ror	a
	cmp	#$8000
	ror	a
	cmp	#$8000
	ror	a
	cmp	#$8000
	ror	a
	endc
	endm

km_divs16	macro
	km_shiftRSA4
	endm
;--------------------------------------------------------------------
km_cpudivs15u8	macro	[reg]
;init	Acc (16 bit) / Reg (8bit) 
;exit	reg (16 bit)
MYNARG	=	NARG
	CHK_NARG	1
	km_memchecka16i16
_{reg} = 0
_x = 1
_y = 2
	ifeq	_{reg}
	printf	"Error:Should set register (X or Y)\n"
	error+
	elseif
	endc
;**** X register no baai *****

	IFEQ	_{reg}-1
	PHY
	stz	kmwork		;fugou no tame no work
	tay			;fugou kakunin no tame
	bpl	.plas\@
.minus\@
	dec	kmwork		;minus fugou set
	nega
.plas\@
	jsl	kdivu16u8_sub_l
	TXA			;Acc <--- syou wo toriaezu Acc ni hokan

	ldx	kmwork		;FUGOU CHECK
	bpl	.skip\@
	nega
.skip\@
	tax			;X reg <-- syou
	PLY

	ELSEIF

;**** Y register no baai *****
	PHX
	stz	kmwork
	tax		;fugou kakunin no tame
	bpl	.plas\@
.minus\@
	dec	kmwork
	nega
.plas\@
	tyx
	jsl	kdivu16u8_sub_l
	TXA

	ldx	kmwork
	bpl	.skip\@
	nega
.skip\@
	tay

	PLX
	ENDC
	endm
;--------------------------------------------------------------------
km_cpudivs15uf8	macro	[val]
;init	Acc (16 bit) /#val (8bit) 
;exit	Acc (16 bit)
MYNARG	=	NARG
	CHK_NARG	1

	km_memchecka16i16
	PHX
	PHY
	stz	kmwork
	bpl	.plas1\@
.minus\@
	dec	kmwork
	nega
.plas1\@
	ldx	#{val}
	jsl	kdivu16u8_sub_l

	txa
	ldx	kmwork
	bpl	.plas2\@
	nega
.plas2\@
	PLY
	PLX
	endm
;--------------------------------------------------------------------
km_cpudivu16uf8_XY	macro	[val]
;init	:a16i16
;	Acc(16 bit) / #val (8 bit)
;exit	:a16i16
;	syou (x),amari(y)

MYNARG	=	NARG
	CHK_NARG	1

	km_memchecka16i16
	ldx	#{val}
	jsl	kdivu16u8_sub_l

	endm
;--------------------------------------------------------------------
km_cpudivu16uf8_work	macro	[val]
;init	:a16i16
;	Acc(16 bit) / #val (8 bit)
;exit	:a16i16
;	syou(work),amari(work)

MYNARG	=	NARG
	CHK_NARG	1
	km_memchecka16i16
		phx
		phy

		ldx	#{val}
		jsl	kdivu16u8_sub_l
		stx	ksyou
		sty   	kamari

		ply
		plx
	endm
;--------------------------------------------------------------------
km_cpudivu16u8_XY	macro	[divisor,dividend]
MYNARG	=	NARG
	CHK_NARG	1,2

;init 	a16i16
;	(Acc) /#divisor, (dividend) / #divisor
;exit	a16i16
;	Xreg=(syou) , Yreg=amari

	km_memchecka16i16

	IFNE	NARG-1
	lda	{dividend}
	endc

	ldx	{divisor}
	jsl	kdivu16u8_sub_l
	endm
;--------------------------------------------------------------------
km_cpudivu16u8_work	macro	[divisor,dividend]
MYNARG	=	NARG
;init	a16i16
;	(Acc) /divisor, (dividend) / divisor
;exit	a16i16
;	ksyou,kamari

	CHK_NARG	1,2
	km_memchecka16i16

	phx
	phy

	IFNE	NARG-1
	lda	{dividend}
	endc

	ldx	{divisor}
	jsl	kdivu16u8_sub_l
	stx	ksyou
	sty	kamari

	ply
	plx
	endm
;--------------------------------------------------------------------
;*1995/1/11 :Now Not using
;* Using Mario Chip	
;* Init :X zahyou (m_x1 :2 byte)
;*      :Z zahyou (m_y1 :2 byte)
;* Out  :Acc (var) <<< Angle (1 byte)
;--------------------------------------------------------------------
km_obj2field_rotY	macro	[size,obj1,var]
MYNARG	=	NARG
;;;;	poll_mario

	CHG_MODE	{size}

	lda.w	al_worldx,{obj1}
	nega
	sta.l	m_x1

	lda.w	al_worldz,{obj1}
	nega
	sta.l	m_y1

	jsl	karctan16_l

	a8
	xba
;;;	lda.l	m_cnt+1
	clc
	adc.w	al_roty,{obj1}
	nega

	IFNE	MYNARG=3
	sta	{var}
	endc

	CHG_MODEBACK	{size}

;;;	unpoll_mario
	endm
;--------------------------------------------------------------------
;* Using 65816
;* Init :X zahyou (kz_x1:2 byte)
;*      :Z zahyou (kz_y1:2 byte)
;* Out  :Acc (var) <<< Angle (1 byte)
;--------------------------------------------------------------------
kplm_obj2field_rotY	macro	[size,obj1,var]
MYNARG	=	NARG
;;;	poll_mario

	CHG_MODE	{size}
	lda	kpx
	nega
	sta	kz_x1

	lda	kpz
	nega
	sta.l	kz_y1

	jsl	karctan16_l
	a8
	xba
;;;	lda.l	m_cnt+1
	clc
	adc	kroty
	nega

	IFNE	MYNARG=3
	sta	{var}
	endc

	CHG_MODEBACK	{size}
;;;	unpoll_mario
	endm
