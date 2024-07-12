;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         TITLE.ASM                                           ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  Title Screen                                        ;
; DATE CREATED: 10-3-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
	INCPUB	title
;=====================================================================
;*								*
;*			Special Macros				*
;*								*
;=====================================================================
;---------------------------------------------------------------------
;*		Battle Player Select KEY States			*
;---------------------------------------------------------------------
km_btplkeystates	macro	[cont]
_bpscont	=	{cont}-1
	phb
	db7e

	IFEQ	_bpscont

	km_autotrigread			;autotrig0 <----  jyuuji KEY
	km_setkeystates		0	;keystates <----  ALL KEY (cont1)
	lda	bps_keyptr2
	sta	keyptrbk		;player2 no back key states

	lda	bps_keyptr1
	ELSEIF

	km_autotrigread2		;autotrig1 <----  jyuuji KEY
	km_setkeystates		1	;keystates <----  ALL KEY (cont2)

	lda	bps_keyptr1
	sta	keyptrbk		;player1 no back key states

	lda	bps_keyptr2
	ENDC

	cmp	#$ff
	beq	.noplayer\@

	lda	bps_keyptr{cont}
	sta	keyptr			;Get select cursor pointer
	lda	bps_Okflag{cont}
	sta	bps_OKflag		;Get player select OK Flag

	jsr	keybtplsel		;[key check]

	lda	keyptr
	sta	bps_keyptr{cont}	;Put player select pointer

	lda	bps_Okflag
	sta	bps_OKflag{cont}	;Put player select OK flag

.noplayer\@
	plb
	endm

;*********************************************************************
;*								*
;*		Select Mission Player				*
;*								*
;*********************************************************************
; [bfs_OKflag]
;fbfs_OKptrmax	equ	%00000111	;field select pointer check val
;fbfs_OKInitptr	equ	%00000000	;spr init
;fbfs_OKanmptr	equ	%00000001	;spr Ok anime display
;fbfs_OKflashptr	equ	%00000010	;spr OK flash
;fbfs_OKcancelptr	equ	%00000011	;spr OK disp cancell
;fbfs_ok		equ	%00001000	;field select OK? flag
;fbfs_selEND		equ	%00010000	;field select ALL OK flag
;fbfs_cancel		equ	%00100000	;field select Cancel flag
;fbfs_buttondisable	equ	%01000000	;button read disable flag
;fbfs_keydisable	equ	%10000000	;key read disable flag
;----------------------------------------------------------------------
SelectMissionPlayer_l

	php
	a8i16
;* WORK RAM Clear *
;;;	km_clrKAWARAM				;[WORK RAM CLEAR]

;* Flag Set *
	km_setspritemode	selectmissionplayer

	a16
	km_clrscreenflag	sprwbuf		;[SCREEN FLAG]
	km_setscrollflag	hdmascroll	;[SCREEN FLAG]
	km_setwindowflag	normalwipe	;[SCREEN FLAG]
	a8

;* SOUND SET *
	km_setsndmode
	km_ldxsoundtblptr
	KSoundBGMTrans

;* SCREEN SET *
	jsr	Init_MPScreen
	jsl	init_sprites_l

;* Yajima's Initial *
	jsl	Init_pselect_l	;(For Yajima's)

;* wipe init & open *
	km_initwipeopen	mispl

;* Set window structs *
	jsl	init_nopolywindows_l

;* IRQ enable *
	km_screenon
	km_IRQenable	titleirq,226	;[IRQ enable]
;==========================================================================
.loop_mapsel
;	km_SyoriOverCheckStart

;* wipe *
	jsl	setblack_l		; [black fade]
	jsl	wipe_l
	jsl	find_window_pri_l	; [window pri]
;* Sprites *
	jsl	do_sprites_l		;[sprites]

;	km_SyoriOverCheckEnd

	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

;******* Debug mode *******
;* force soft ware reset *
	km_Debug_reset

	lda	mpw_misplayerflag
	km_bne	.pushstart
.ok_cancell 
	km_setval.l	bps_OKflag1,0
	brl	.loop_mapsel
;==========================================================================
.pushstart
	shorta
	phb
	db7e
	km_hib0
	lda	playerselectNo
	sta	p1_pilotNo
	sta	kx_p1_pilotNo
	lsr	a
	asl	a
	sta	kx_p1_TypePtr

	lda	player_friend
	sta	p2_pilotNo
	sta.l	kx_p2_pilotNo
	lsr	a
	asl	a
	sta	kx_p2_TypePtr

;* player states  *
	jsl	playerstatus_init_l	;(Call Kawagoe Routine)

	plb
;* kettei *
	KBGM	FADEOUT
	km_setsndflag	allstop

	IFNE	kbattle
	km_bitchecktotalflag	battle
	bne	.battle
	ENDC

;* set game mode *
.mission
;	km_settmpgamemode	demo
	km_setdemonumber	startarwingdemo
	bra	.wipeclosestart

	IFNE	kbattle
.battle
	km_settmpgamemode	initbattle
	ENDC

;* wipe close *
.wipeclosestart
	km_initwipeclose	mispl
	km_wipewait_l
;-----------------------------------------------------
;* SET GAME MODE *
	km_setnextgamemode
;* flag clear or set *
	km_clrscreenflag	all
	km_clrwindowflag	all	;[window flag]
	km_clrscrollflag	all	;[scroll flag]
	km_clrgameflag		kawairq
	km_clrsndflag		allstop ;[sound flag]
;* set var *
	km_setval.l	coltimer_2,1
;-----------------------------------------------------
;* Player Sound *
	KSoundPlayerTrans
;-----------------------------------------------------

.End
	plp
	rtl

;**** PLAYER TYPE TABLE  ****
playertbl
	db	ep_fox		;0
	db	ep_falco	;1
	db	ep_peppy	;2
	db	ep_slippy	;3
	db	ep_gal1		;4
	db	ep_gal2		;5

;*********************************************************************
;*								*
;*		Initial Mission Player Screen			*
;*********************************************************************
Init_MPScreen
	shorta
	longi
	phb
	db0
	screen_off
	disable			;IRQ disable

	jsr	Initial_MpPPUreg

	jsr	Set_MPBG1CGX
	jsr	Set_MPBG1SCR

	jsr	Set_MPBG2CGX
	jsr	Set_MPBG2SCR

	jsr	Set_MPBG3CGX
	jsr	Set_MPBG3SCR

	jsr	Set_MPCOL

	jsr	Set_MPOBJCGX

	plb
	rts
;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
Initial_MpPPUreg
	shorta

	lda	#%00001001
	sta	bgmode		;BG mode 1 ,8*8 dot ,BG3 prio off

	lda	#(mp_bg1_scr>>8)&$fc	;BG1 SCR ,screen 1
	sta	bg1sc				   
	lda	#(mp_bg2_scr>>8)&$fc
	sta	bg2sc			;BG2 SCR ,screen 1
	lda	#(mp_bg3_scr>>8)&$fc
	sta	bg3sc			;BG3 SCR ,screen 1

	lda	#(mp_bg1_cgx>>12)!((mp_bg2_cgx>>8)&$f0)
	sta	bg12nba			;BG1,BG2

	lda	#(mp_bg3_cgx>>12)
	sta	bg34nba			;BG3

	lda	#(mp_obj_cgx>>13)
	sta	objsel			;OBJ

	lda	#%00010011
	sta	tm			;BG1,BG2,OBJ display
	sta	kw_tm
	sta	kw_tmbackup
	lda	#%00000000
	sta	ts
	lda	#%00000000
	sta	cgswsel
	lda	#%00000000
	sta	cgadsub

;* H-V SCROOLL *
	jsl	init_mmhvscroll_l

	lda	#%01000010
	sta	ch2params	(indirect mode)
	ldx	#xhdma_bg2vscroll_bat&WM
	lda	#bg2vofs&BM
	sta	ch2addrb
	stx	ch2addra1tl
	lda	#xhdma_bg2vscroll_bat>>16
	sta	ch2atbank
	sta	ch2databank

	lda	#%01000010
	sta	ch3params	;(indirect mode)
	lda	#bg2hofs&BM
	sta	ch3addrb
	ldx	#xhdma_bg2hscroll_bat&WM
	stx	ch3addra1tl
	lda	#xhdma_bg2hscroll_bat>>16
	sta	ch3atbank
	sta	ch3databank

	lda	#%00001100
	sta	hdmaen_gc
	rts
;=====================================================================
;*			Initial BG1 Character Data		*
;=====================================================================
Set_MPBG1CGX
	decvramnotrans	0,mp_bg1_cgx,b1_ccr,(256*32)
	rts
;=====================================================================
;*			Initial BG1 Screen Data			*
;=====================================================================
Set_MPBG1SCR
	decvramnotrans	0,mp_bg1_scr,b1_pcr,$800
	rts
;=====================================================================
;*			Initial BG2 Character Data		*
;=====================================================================
Set_MPBG2CGX
	rts
;=====================================================================
;*			Initial BG2 Screen Data			*
;=====================================================================
Set_MPBG2SCR
	decvramnotrans	0,mp_bg2_scr,b3_pcr,$800
	rts
;=====================================================================
;*			Initial BG3 Character Data		*
;=====================================================================
Set_MPBG3CGX
	decvramnotrans	0,mp_bg3_cgx,b9_ccr,(256*32)
	rts
;=====================================================================
;*			Initial BG3 Screen Data			*
;=====================================================================
Set_MPBG3SCR
	rts
;=====================================================================
;*			Initial OBJ Character Data		*
;=====================================================================
Set_MPOBJCGX
	decvramnotrans	0,mp_obj_cgx,e4_ccr,($180*32)
	rts

;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_MPCOL
	decrunch_palettes
	dmacgram	0,0,b1_pac,$200
	km_dmaromram	0,b1_pac,kx_palette,$200
	km_dmaromram	0,b3_pac,kx_palette2,(32*6)
	rts



;*********************************************************************
;*								*
;*		Initial Battle Player Select 			*
;*********************************************************************
	IFEQ	1
Init_PlayerSelect
	shorta
	longi
	phb
	db0
	screen_off
	disable			;IRQ disable

	jsr	Initial_PlayerSel_PPUreg

	jsr	Set_PBG1CGX
	jsr	Set_PBG1SCR

	jsr	Set_PBG2CGX
	jsr	Set_PBG2SCR

;	jsr	Set_PBG3CGX
;	jsr	Set_PBG3SCR

	jsr	Set_POBJCGX

	jsr	Set_PCOL

	plb
	rts
;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
Initial_PlayerSel_PPUreg
	shorta

	lda	#%00101001
	sta	bgmode		;BG mode 1 ,8*8 dot ,BG3 prio off

	lda	#(bp_bg1_scr>>8)&$fc	;BG1 SCR ,screen 1
	sta	bg1sc				   
	lda	#(bp_bg2_scr>>8)&$fc
	sta	bg2sc			;BG2 SCR ,screen 1
	lda	#(bp_bg3_scr>>8)&$fc
	sta	bg3sc			;BG3 SCR ,screen 1
	lda	#(bp_bg1_cgx>>12)!((bp_bg2_cgx>>8)&$f0)
	sta	bg12nba			;BG1,BG2
	lda	#(bp_bg3_cgx>>12)
	sta	bg34nba			;BG3

	lda	#(bp_obj_cgx>>13)
	sta	objsel			;OBJ

	lda	#%00010011
	sta	tm			;BG1,BG2,OBJ display
	sta	kw_tm
	sta	kw_tmbackup

	lda	#0
	sta	ts
	sta	cgswsel
	sta	cgadsub

;* H-V SCROOLL *
	ldx	#xhdma_bg2hscroll_bat&WM
	stx	ch3addra1tl
	lda	#xhdma_bg2hscroll_bat>>16
	sta	ch3atbank

	lda	#%00001100
	sta	hdmaen_gc

	rts

;=====================================================================
;*			Initial BG1 Character Data		*
;=====================================================================
Set_PBG1CGX
	decvramnotrans	0,bp_bg1_cgx,b1_ccr,(256*32)
	rts
;=====================================================================
;*			Initial BG1 Screen Data			*
;=====================================================================
Set_PBG1SCR
	decvramnotrans	0,bp_bg1_scr,b1_pcr,$800
	rts
;=====================================================================
;*			Initial BG2 Character Data		*
;=====================================================================
Set_PBG2CGX
	decvramnotrans	0,bp_bg2_cgx,a0_ccr,(256*32)
	rts
;=====================================================================
;*			Initial BG2 Screen Data			*
;=====================================================================
Set_PBG2SCR
	decvramnotrans	0,bp_bg2_scr,b6_pcr,$800
	rts
;=====================================================================
;*			Initial BG3 Character Data		*
;=====================================================================
Set_PBG3CGX
	rts
;=====================================================================
;*			Initial BG3 Screen Data			*
;=====================================================================
Set_PBG3SCR
	rts
;=====================================================================
;*			Initial OBJ Character Data		*
;=====================================================================
Set_POBJCGX
;	decvramnotrans	0,bp_obj_cgx,e1_ccr,($1c0*32)
	rts

;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_PCOL
	decrunch_palettes
	dmacgram	0,0,b1_pac,$200
	dmacgram	0,$40,a0_pac,$2*4*16
	rts
	ENDC




;*****************************************************************************
;*									*
;*									*
;*			NOT USING AREA START				* 
;*									*
;*									*
;*****************************************************************************

;***************************************************************************
;***************************************************************************
			IFEQ	1
;***************************************************************************
;***************************************************************************


;*********************************************************************
;*								*
;*	(Test Version) Select Mission Level 			*
;*								*
;*********************************************************************
	IFEQ	1
SelectTestMissionLevel_l
	php
	a8i16
;* Initialize *
	jsr	Init_TestScreen

	km_setval	key_tateptr1,0
	km_setval.l	Kdifficulty,0
	km_setval	key_tatemaxptr1,3
;* IRQ Enable *
	km_IRQenable	titleirq	;[IRQ enable]

;* screen ON *
	km_fadeup

.loop_mapsel
	jsl	Check_autotrigUD_l
	jsr	do_spritesMLS

	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

;* Cancell *
	km_testjoypad	cancel	;[cancel]
	beq	.nopushB

	lda	#sport3_Kettei		;Kettei !!
	ksound_a
	km_setgamemode	title	;NEXT GAME MODE
	jmp	.end
.nopushB

;* Kettei *
	km_testjoypad	OK
	beq	.loop_mapsel
	km_setvar	Kdifficulty,key_tateptr1

	lda	#sport3_Kettei		;Kettei !!
	ksound_a
	km_setgamemode	testmissionmap	;NEXT GAME MODE
;-----------------------------------------------------
.End
	km_qfadedown
	km_screenoff
;-----------------------------------------------------
	plp
	rtl
;=====================================================================
;*		Mission Level Select sprites	[SPRITES]	*
;=====================================================================
do_spritesMLS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	MLevelSelSprData

;Map select mark set
	lda	#$50
	sta	sprites,y
	iny

	lda	key_tateptr1
	km_multa8
	clc
	adc	#$70
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri0,noflip

	plb
	rts
	ENDC
;*********************************************************************
;*								*
;*	(Test Version) Select Battle MAP 			*
;*								*
;*********************************************************************
SelectTestBattleMap_l
	IFEQ	1
	php
	a8i16
	jsr	Init_TestScreen

	lda	#0
	sta	key_tateptr1
	sta.l	KGameMapPtr

	lda	#(battlemaptblEND-battlemaptbl)&BM
	sta	key_tatemaxptr1	;key down max pointer

;* screen ON *
	km_IRQenable	titleirq	;[IRQ enable]
	km_screenon

.loop_mapsel
;;;	jsr	select_mapmode
	jsl	Check_autotrigUD_l
	jsr	do_spritesBMS

	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

	km_testjoypad	Cancel	;[cancell]
	beq	.nopushB

	lda	#(battlemaptblEND-battlemaptbl)&BM
	sta.l	KGameMapPtr
	jmp	.end
.nopushB
	km_testjoypad	OK
	beq	.loop_mapsel

	lda	key_tateptr1
	sta.l	KGameMapPtr

	lda	#sport3_Kettei
	ksound_a

	km_soundwait
;-----------------------------------------------------
;* Game Pointer *
	km_setgamemode	selectmissionplayer
;-----------------------------------------------------
.End
;* key states clear *
	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]

	km_screenoff
;-----------------------------------------------------
	plp
	ENDC
	rtl

	IFEQ	1
battlemaptbl		;cf (kalcs.inc)
	db	stg_bat1
	db	stg_bat2
	db	stg_bat3
	db	stg_bat4
	db	stg_bat5
battlemaptblEND
	db	kmode_title		;Go back Title

;=====================================================================
;*		Battle Map Select sprites	[SPRITES]	*
;=====================================================================
do_spritesBMS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	TitSPrData
	BlockTransSPrites	BMapSelSprData
;Map select mark set

	lda	#$50
	sta	sprites,y
	iny

	lda	key_tateptr1
	km_multa8
	clc
	adc	#$50
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri0,noflip
	plb
	rts
	ENDC


;*********************************************************************
;*								*
;*		Initial Field Select 				*
;*********************************************************************
	ifeq	1
Init_FieldSelect
	shorta
	longi
	phb
	db0
	screen_off
	jsr	Initial_FieldSel_PPUreg
;--------------------------------------------------------------------
	jsr	Set_FBG1CGX
	jsr	Set_FBG1SCR

	jsr	Set_FBG2CGX
	jsr	Set_FBG2SCR

	jsr	Set_FBG3CGX
	jsr	Set_FBG3SCR

	jsr	Set_FCOL

	plb
	rts
;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
Initial_FieldSel_PPUreg
	shorta
	lda	#%00000001
	sta	bgmode		;BG mode 1 ,8*8 dot

	lda	#(bf_bg1_scr>>8)&$fc	;BG1 SCR screen 1
	sta	bg1sc				   

	lda	#(bf_bg2_scr>>8)&$fc
	sta	bg2sc			;BG2 SCR screen 1
	sta	kw_bg2sc

	lda	#(bf_bg3_scr>>8)&$fc
	sta	bg3sc			;BG3 SCR ,screen 1

	lda	#(bf_bg1_cgx>>12)!((bf_bg2_cgx>>8)&$f0)
	sta	bg12nba			;BG1 (0000) ,BG2 (0000)

	lda	#(bf_bg3_cgx>>12)
	sta	bg34nba			;BG3

	lda	#(bf_obj_cgx>>13)
	sta	objsel			;OBJ

	lda	#%00010101
	sta	tm			;BG1,OBJ display
	sta	kw_tm
	sta	kw_tmbackup

	ifeq	1
	lda	#%00000010
	sta	ts			;BG2 display
	lda	#%00000010
	sta	cgswsel
	lda	#%10000001
	sta	cgadsub
	endc

	lda	#0
	sta	hdmaen_gc
	rts
;=====================================================================
;*			Initial BG1 Character Data		*
;=====================================================================
Set_FBG1CGX
	decvramnotrans	0,bf_bg1_cgx,b0_ccr,($1e0*32)
	rts
;=====================================================================
;*			Initial BG1 Screen Data			*
;=====================================================================
Set_FBG1SCR
	decvramnotrans	0,bf_bg1_scr,b0_pcr,$800
	rts
;=====================================================================
;*			Initial BG2 Character Data		*
;=====================================================================
Set_FBG2CGX
	rts
;=====================================================================
;*			Initial BG2 Screen Data			*
;=====================================================================
Set_FBG2SCR
	decvramnotrans	0,bf_bg2_scr,b4_pcr,$800*4

	rts
;=====================================================================
;*			Initial BG3 Character Data		*
;=====================================================================
Set_FBG3CGX
	decvramnotrans	0,bf_bg3_cgx,b9_ccr,($100*32)
	rts
;=====================================================================
;*			Initial BG3 Screen Data			*
;=====================================================================
Set_FBG3SCR
	decvramnotrans	0,bf_bg3_scr,b15_pcr,$800
	rts
;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_FCOL
	decrunch_palettes
	dmacgram	0,0,b0_pac,$200
	rts

;=====================================================================
;*			Initial OBJ Character Data		*
;=====================================================================
Set_FOBJCGX
	rts

;=====================================================================
;*			Initial OAM Data			*
;* Data Bank:0							*
;=====================================================================
Set_FOAM
	rts
	endc
;*********************************************************************
;*								*
;*		Battle Field Select				*
;*								*
;*********************************************************************
Selectbattlefield_l
	ifeq	1
	php
	a8i16
	phb
	db7e
;* WORK RAM CLEAR *
;;;	km_clrKAWARAM			;[WORK RAM CLEAR]

;* flag *
	km_setspritemode	selectbattlefield	;[SPRITE MODE]
	km_setscreenflag	normalwipe		;[SCREEN FLAG]
	km_setscreenflag	screenadd		;[screen flag]
;* Initial parameter *
	lda	#fbfs_keymaxptr
	sta	key_tatemaxptr1		;key down max pointer

	stz	kx_bg3hofstm		;bg3 scroll speed
	stz	kw_bg3hofs		;bg3 scroll

	km_lldx	key_tateptr1
	lda.l	bfscursorYpostbl,X
	sta.l	rarwinghosY
;* arwing1 *
	stz	rarwingmvtm1	;arwing move timer
	lda	#3
	sta	rarwingptr1	;arwing turn pointer
;* arwing2 *
	stz	rarwingmvtm2	;arwing move timer
	lda	#1
	sta	rarwingptr2	;arwing  turn pointer

;* SOUND SET *
	km_setsndmode
	km_ldxsoundtblptr
	KSoundBGMTrans

;* CGX,SCR,COL *
	jsr	Init_fieldselect	;[CGX,SCR,COL]
	jsl	init_sprites_l		;[sprites]

* wipe init & open *
	km_initwipeopen	batfl

;* Set window structs *
	jsr	init_windows

;* IRQ ENABLE *
	km_IRQenable	titleirq,226	;[IRQ enable]
;-------------------------------------------------------------------------
.LOOP
;;;	km_SyoriOverCheckStart
;* wipe *
	jsl	setblack_l		; [black fade]
	jsl	wipe_l
	jsl	find_window_pri_l	; [window pri]

;* key check *
	jsr	keybattlesel	;[key check]

;* sprites *
	jsl	do_sprites_l	;[sprites]

;* scroll *
	lda	kx_bg3hofstm
	beq	.scrollchange
	dec	a
	sta	kx_bg3hofstm
	bra	.scrollend
.scrollchange
	lda	#4
	sta	kx_bg3hofstm	;scroll speed
	inc	kw_bg3hofs	;[BG3 scroll]
.scrollend

;;;	km_SyoriOverCheckEnd

;*** IRQ WAIT ***
	lda	#iv_titleirq
	sta	trans_flag	;[irq pointer]
	km_waittrans		;[irq wait]

;*** OK & CANCELL CHECK ***
;[battle field select end check]
	km_bitcheckflag	bfs_OKflag,fbfs_selEND
	bne	.OK
;[cancell check]
	km_bitcheckflag	bfs_OKflag,fbfs_cancel
	km_beq		.LOOP

	km_bitcheckflag	bfs_OKflag,fbfs_ok
	bne		.OK_cancell
;-------------------------------------------------------------------------
.Cancell
	km_settmpgamemode	title
;cancell sound wa "keybattlesel" de SET shite aru.
	bra	.wipeclosestart
;-------------------------------------------------------------------------
.OK_Cancell
	stz	bfs_OKflag	;ALL FLAG CLEAR
	brl	.LOOP
;-------------------------------------------------------------------------
.OK
;OK  sound wa "keybattlesel" de SET shite aru.
	km_settmpgamemode	selectbattleplayer
;-------------------------------------------------------------------------
;* wipe close *
.wipeclosestart
	km_initwipeclose	batfl
	km_wipefadewait
;* SET GAME MODE *
	km_setnextgamemode

;-----------------------------------------------------
.END
	plb
	plp
	ENDC
	rtl

;=====================================================================
;*		Battle Field Select		[Key Check]	*
;* data bank 7e							*
;=====================================================================
	IFEQ	1
keybattlesel
	shorta
	longi
	phb
	db7e
;KETTEI
	km_testjoypad	OK
	beq	.NopushA	;moshi start,A wo oshite inakattara

	km_bitcheckflag	bfs_OKflag,fbfs_buttondisable
	bne	.NopushA	;Moshi animation tyuu dattara

	lda	bfs_OKflag
	clc
	adc	#fbfs_ok	;1..OK flag /2..select END flag
	ora	#fbfs_buttondisable!fbfs_keydisable
	sta	bfs_OKflag

	lda		#sport3_Kettei
	ksound_a
	brl	.end
.NopushA
;---------------------------------------------------------------------
;CANCEL
	km_testjoypad	Cancel
	beq	.NopushB	;moshi cancell button wo oshite inakattara

	km_bitcheckflag	bfs_OKflag,fbfs_buttondisable
	bne	.NopushB	;moshi animation tyuu dattara

	km_bitcheckflag	bfs_OKflag,fbfs_ok
	bne	.Ok_cancel	;moshi OK flag ga tatte itara

.Normal_Cancel
	km_setflag	bfs_OKflag,fbfs_cancel
	ksound	cancel
	bra	.end
.OK_cancel
	lda	bfs_OKflag
	and	#fbfs_OKptrmax
	inc	a
	ora	#fbfs_ok!fbfs_buttondisable!fbfs_keydisable
	sta	bfs_OKflag

	lda		#sport3_Kettei
	ksound_a
	bra	.end
.NopushB
;----------------------------------------------
;SELECT
	km_bitcheckflag	bfs_OKflag,fbfs_keydisable
	km_bne	.Nopushkey

	jsl	Check_autotrigUD_l

	km_bitcheckflag	autotrig,triggerflag
	beq	.Nopushkey	;moshi trigger flag ga tatte inakattara
	km_bitcheckflag	autotrig,padl_UD
	beq	.Nopushkey	;moshi ue shita no key wo oshite inakattara

;moshi key (up down) wo oshite itara arwing no postion idou
	km_lldx	key_tateptr1
	lda.l	btfieldselwintable,x
	sta	kw_bg2sc

	lda.l	bfscursorYpostbl,X
	sta.l	rarwinghosY
;* arwing1 *
	stz	rarwingmvtm1	;arwing move timer
	lda	#3
	sta	rarwingptr1	;arwing turn pointer

;* arwing2 *
	stz	rarwingmvtm2	;arwing move timer
	lda	#1
	sta	rarwingptr2	;arwing  turn pointer
.Nopushkey
;--------------------------------------------------------------------
.end
	plb
	rts
btfieldselwintable
	DB	((bf_bg2_scr+$000)>>8)&$fc
	DB	((bf_bg2_scr+$400)>>8)&$fc
	DB	((bf_bg2_scr+$800)>>8)&$fc
	DB	((bf_bg2_scr+$C00)>>8)&$fc

	ENDC

;*********************************************************************
;*								*
;*		Battle Player Select Routine			*
;* data bank 7e							*
;*********************************************************************
Selectbattleplayer_l
	ifeq	1
	php
	phb
	db7e
;** WORK RAM CLEAR **
;;;	km_clrKAWARAM
;* flag *
	km_setspritemode	selectbattleplayer
	km_clrscreenflag	screenadd
;---------------------------------------------------------------------
;* (H,V) SCROLL Initial Postion *
	ai16
	lda	#0
	sta	kx_hscrollp1
	lda	#256
	sta	kx_hscrollp2
	lda	#-24
	sta	kx_vscrollp1
	lda	#-152
	sta	kx_vscrollp2
	a8
;* Parameter Set *
	lda	#fbps_keymaxptr
	sta	keymaxptr		;key down max pointer
	lda	#1
	sta	bps_keyptr2

	lda	#bps_aroffx
	sta	bps_arwing1offx
	lda	#bps_aroffy
	sta	bps_arwing1offy

	lda	#bps_aroffx
	sta	bps_arwing2offx
	lda	#bps_aroffy+80h
	sta	bps_arwing2offy

;* SOUND SET *
;	km_setsndmode
;	km_ldxsoundtblptr
;	KSoundBGMTrans

;* Initial Screen *
	jsr	Init_playerselect	;[screen initial]
	jsl	init_sprites_l
* wipe init & open *
	km_initwipeopen	batfl

;* Set window structs *
	jsr	init_windows

;* IRQ ENABLE *
	km_IRQenable	titleirq,226	;[IRQ enable]
;---------------------------------------------------------------------
.LOOP
;* wipe *
	jsl	setblack_l		; [black fade]
	jsl	wipe_l
	jsl	find_window_pri_l	; [window pri]

;* KEY CHECK *
	km_btplkeystates	1	;[key check]
	km_btplkeystates	2	;[key check]

;* SPRITES *
	jsl	do_sprites_l		;[sprites]

;* SCROLL VALUE *				;[scroll]
	a16
	lda	kx_hscrollp1
	dec	a
	and	#$3ff
	sta	kx_hscrollp1

	lda	kx_hscrollp2
	dec	a
	and	#$3ff
	sta	kx_hscrollp2
	a8

;* IRQ WAIT *
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans			;[irq wait]
;-----------------------------------------------------
;* KEY CHECK *
	km_testjoypad	Cancel
	bne	.Cancell

	km_bitcheckflag	bps_OKflag1,fbfs_ok
	beq		.jmp_loop
	km_bitcheckflag	bps_OKflag2,fbfs_ok
	bne		.startpush
.jmp_loop
	BRL	.LOOP
;-----------------------------------------------------
.Cancell
	km_settmpgamemode	selectbattlefield
	ksound	cancel
	bra	.wipeclosestart
;-----------------------------------------------------
.startpush
	km_lldx	bps_keyptr1
	lda.l	playertbl,x
	sta	p1_pilotNo
	lda.l	playertbl2,x
	km_sta_playertype	1

	km_lldx	bps_keyptr2
	lda.l	playertbl,x
	sta	p2_pilotNo

	lda.l	playertbl2,x
	km_sta_playertype	2

	km_settmpgamemode	testbattlefield

	ksound	kettei
	km_soundwait
;* BGM stop
	KBGM	FadeOut
;-------------------------------------------------------------------------
;* wipe close *
.wipeclosestart
	km_initwipeclose	batfl
	km_wipefadewait
;-------------------------------------------------------------------------
;* SET GAME MODE *
	km_clrscreenflag	all
	km_clrwindowflag	all	;[window flag]
	km_clrscrollflag	all	;[scroll flag]
	km_setnextgamemode
;--------------------------------------------------------------------------
.end
	plb
	plp
	ENDC
	rtl

;=====================================================================
;*		Battle Player Select		[Key Check]	*
;* data bank 7e							*
;=====================================================================
	IFEQ	1
keybtplsel
	shorta
	longi

	km_bitcheckmisplflag	config
	km_bne	.end

;KETTEI
;	km_checkjoypad	OK
;	beq	.NopushA	;moshi start,A wo oshite inakattara


	km_bitcheck	mpw_keyflag,mpkf_pushAB
	beq	.NopushA	;moshi start,A wo oshite inakattara

	km_bitcheckflag	bps_OKflag,fbfs_buttondisable
	bne	.NopushA	;Moshi animation tyuu dattara

	km_clrflag	mpw_keyflag,mpkf_pushAB
	lda	bps_OKflag
	clc
	adc	#fbfs_ok	;1..OK flag /2..select END flag
	ora	#fbfs_buttondisable!fbfs_keydisable
	sta	bps_OKflag

	lda		#sport3_kettei
	ksound_a
	bra	.end
.NopushA
;---------------------------------------------------------------------
;CANCELL
;	km_checkjoypad	Cancel
;	beq	.NopushB	;moshi cancell button wo oshite inakattara

	km_bitcheck	mpw_keyflag,mpkf_pushXY
	beq	.NopushB	;moshi start,A wo oshite inakattara

	km_bitcheckflag	bps_OKflag,fbfs_buttondisable
	bne	.NopushB	;moshi animation tyuu dattara

	km_clrflag	mpw_keyflag,mpkf_pushXY

	km_bitcheckflag	bps_OKflag,fbfs_ok
	bne	.Ok_cancell	;moshi OK flag ga tatte itara

.Normal_Cancell
	lda	#fbfs_cancel
	sta	bps_OKflag

	ksound	cancel
	bra	.end
.OK_cancell
	lda	bps_OKflag
	and	#fbfs_OKptrmax
	inc	a
	ora	#fbfs_ok!fbfs_buttondisable!fbfs_keydisable
	sta	bps_OKflag

	lda		#sport3_Kettei
	ksound_a
	bra	.end
.NopushB
;----------------------------------------------
;SELECT
	km_bitcheckflag	bps_OKflag,fbfs_keydisable
	bne	.Nopushkey


	jsr	CheckBPSKey
.nopushkey
.end
	rts

;=====================================================================
;*		Check AUTO TRIGGER  (LEFT,RIGHT)   [KEY CHECK]	*
;* Init :keymaxptr 							*
;=====================================================================
CheckBPSKey
	shorta
	longi
;---------------------------------------------------------------------
	km_CHECKjoypad	LEFT
	bne		.left
	km_CHECKjoypad	RIGHT
	bne		.right
	bra		.exit
;---------------------------------------------------------------------
.left	lda	keyptr
	dec	a
	bpl	.skip_left
	lda	keymaxptr
	dec	a
.skip_left
	cmp	keyptrbk
	bne	.skip_left2
	dec	a
	bpl	.skip_left2
	lda	keymaxptr
	dec	a
.skip_left2
	sta	keyptr
	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.right	lda	keyptr
	inc	a
	cmp	keymaxptr
	bne	.skip_right
	lda	#0
.skip_right
	cmp	keyptrbk
	bne	.skipr
	inc	a
.skipr
	cmp	keymaxptr
	bne	.skip_right2
	lda	#0
.skip_right2
	sta	keyptr

	km_setflag	keyflag,key_push
;---------------------------------------------------------------------
.sound	ksound	cursor
;---------------------------------------------------------------------
.exit	rts
	ENDC


;***************************************************************************	
;***************************************************************************	
;			Not Using Area
	IFEQ	1
;***************************************************************************	

;*********************************************************************
;*								*
;*	(Test Version) Game Mode Select				*
;*								*
;*********************************************************************
;=====================================================================
;*		CHECK TEST GAME MODE				*
;=====================================================================
testgamemode_l
	php
	a8i16
	lda	#0
	sta	key_tateptr1
	lda	#2
	sta	key_tatemaxptr1	;key down max pointer

	jsr	Init_TestScreen
;* screen ON *
	km_IRQenable	titleirq	;[IRQ enable]
	km_screenon
.loop_mapsel
	jsl	Check_autotrigUD_l	;[key check]
	jsr	do_spritesTGS		;[sprites]

	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

	km_testjoypad	b	;[cancell]
	beq	.nopushB

	km_setgamemode	title
	jmp	.end
.nopushB

	km_testjoypad	OK
	bne	.pushstart
	bra	.loop_mapsel

.pushstart
	lda	#sport3_Kettei
	ksound_a

	lda	key_tateptr1
	bne	.battle
.mission
	lda	#st_normalscr
	sta	screentype
	km_setspritemode	mission
	km_clrgameflag		battle	;MISSION MODE
	bra	.next
.battle

	lda	#st_twoplayerscr
	sta	screentype
	km_setgameflag		battle
	km_setspritemode	battle
.next
	km_setgamemode	testlocation
;--------------------------------------------------------------------
.end	
	km_screenoff	;SCREEN,IRQ,HDMA OFF
	plp
	rtl

;=====================================================================
;*			CHECK TEST LOCATION			*
;=====================================================================
testLOCATION_l
	php
	a8i16
	lda	#0
	sta	key_tateptr1
	lda	#4
	sta	key_tatemaxptr1	;key down max pointer

	jsr	Init_TestScreen
;* screen ON *
	km_IRQenable	titleirq	;[IRQ enable]
	km_screenon
.loop_mapsel
	jsl	Check_autotrigUD_l	;[key check]
	jsr	do_spritesTLS		;[sprites]

	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

	testjoypad	b	;[cancell]
	beq	.nopushB

	km_setgamemode	testgamemode

	jmp	.end
.nopushB

	km_testjoypad	OK
	bne	.pushstart
	bra	.loop_mapsel

.pushstart
	lda	#sport3_Kettei
	ksound_a

	km_lldx	key_tateptr1
	lda.l	testLOCATtbl,x
	sta.l	KGameMap
	km_setgamemode	testplayer
;--------------------------------------------------------------------
.end	
	km_screenoff	;SCREEN,IRQ,HDMA OFF
	plp
	rtl

testLOCATtbl
	db	map_ground
	db	map_space
	db	map_marine
	db	map_desert

;=====================================================================
;*			Select Player				*
;=====================================================================
SelectTestPlayer_l
	php
	a8i16
	lda	#0
	sta	key_tateptr1
	sta.l	KGameMapPtr
	lda	#6
	sta	key_tatemaxptr1	;key down max pointer

	jsr	Init_TestScreen
;* screen ON *
	km_IRQenable	titleirq	;[IRQ enable]
	km_screenon
.loop_mapsel
	jsl	Check_autotrigUD_l	;[key check]
	jsr	do_spritesTPS		;[sprites]

	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

	testjoypad	b	;[cancell]
	beq	.nopushB

	km_setgamemode	testlocation

	jmp	.end
.nopushB
	testjoypad	A
	bne	.pushstart
	testjoypad	start
	bne	.pushstart
	bra	.loop_mapsel

.pushstart
	km_lldx	key_tateptr1
	lda.l	playertbl,x
	sta	p1_pilotNo		;Player POINTER
	lda.l	playertbl2,x
	sta.l	karpltype1

	km_setgamemode	testuser

	lda		#sport3_Kettei
	ksound_a			;[sound]
;-----------------------------------------------------
;Init Game parameter
	a8
	lda	#1
	sta.l	coltimer_0

;-----------------------------------------------------
.End
	km_screenoff	;SCREEN,IRQ,HDMA OFF
;-----------------------------------------------------
	plp
	rtl

;=====================================================================
;*			CHECK USER NAME				*
;=====================================================================
SelectTestMap_l
	php
	a8i16
	lda	#0
	sta	key_tateptr1
	sta.l	KGameMapPtr
	lda	#(testmaptblEND-testmaptbl)&BM
	sta	key_tatemaxptr1	;key down max pointer

	jsr	Init_TestScreen
;* screen ON *
	km_IRQenable	titleirq	;[IRQ enable]
	km_screenon
.loop_mapsel
;;;	jsr	select_mapmode	 	;[key check]
	jsl	Check_autotrigUD_l	;[key check]
	jsr	do_spritesTMS		;[sprites]

	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

	testjoypad	b	;[cancell]
	beq	.nopushB
	lda	#(testmaptblEND-testmaptbl)&BM
	sta.l	KGameMapPtr		;USER MAP POINTER
	jmp	.end
.nopushB
	testjoypad	A
	bne	.pushstart
	testjoypad	start
	bne	.pushstart
	bra	.loop_mapsel

.pushstart
	lda	key_tateptr1
	sta.l	KGameMapPtr		;USER MAP POINTER

	lda		#sport3_Kettei
	ksound_a			;[sound]
;-----------------------------------------------------
;Init Game parameter
	a16
	lda	#90
	clc
	adc	#1
	sta	kw_GameTimer
	a8
	lda	#1
	sta.l	coltimer_0
;-----------------------------------------------------
.End
	km_screenoff	;SCREEN,IRQ,HDMA OFF

	stz	trans_flag
;-----------------------------------------------------
	plp
	rtl

;=====================================================================
;*		Select Map Mode			[KEYCHECK]	*
;=====================================================================
Select_mapmode
	ifeq	1
	shorta
	longi

	testjoypad	up
	bne		.up
	testjoypad	down
	bne		.down
	testjoypad	select
	bne		.down
	bra		.exit
;---------------------------------------------------------------------
.up
	lda	keyptr
	dec	a
	bpl	.skip_up	
	lda	#7
.skip_up
	sta	keyptr
	bra	.sound
;---------------------------------------------------------------------
.down
	lda	keyptr
	inc	a
	cmp	#8
	bne	.skip_down
	lda	#0
.skip_down
	sta	keyptr
;---------------------------------------------------------------------
.sound
	ksound	cursor
;---------------------------------------------------------------------
.exit
	endc
	rts

;=====================================================================
;*		Test Map Select sprites	[SPRITES]		*
;=====================================================================
do_spritesTGS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	TitSPrData
	BlockTransSPrites	TGameSelSprData
;Map select mark set

	lda	#$50
	sta	sprites,y
	iny

	lda	key_tateptr1
	km_multa8
	clc
	adc	#$50
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri0,noflip

	plb
	rts

;=====================================================================
;*		Test Location Select sprites	[SPRITES]	*
;=====================================================================
do_spritesTLS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	TitSPrData
	BlockTransSPrites	TLocatSelSprData
;Map select mark set

	lda	#$50
	sta	sprites,y
	iny

	lda	key_tateptr1
	km_multa8
	clc
	adc	#$50
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri0,noflip

	plb
	rts


;=====================================================================
;*		Test Map Select sprites	[SPRITES]		*
;=====================================================================
do_spritesTMS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	TitSPrData
	BlockTransSPrites	TMapSelSprData
;Map select mark set

	lda	#$50
	sta	sprites,y
	iny

	lda	key_tateptr1
	km_multa8
	clc
	adc	#$50
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri0,noflip

	plb
	rts
;=====================================================================
;*			Test Player Select			*
;=====================================================================
do_spritesTPS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	TitSPrData
	BlockTransSPrites	TPlayerSelSprData
;Map select mark set

	lda	#$50
	sta	sprites,y
	iny

	lda	key_tateptr1
	km_multa8
	clc
	adc	#$50
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri0,noflip

	plb
	rts
;=====================================================================
;*			Test Training 
;=====================================================================
do_spritesTT
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	TitSPrData
	BlockTransSPrites	TrainSelSprData
;Map select mark set

	lda	#$50
	sta	sprites,y
	iny

	lda	key_tateptr1
	km_multa8
	clc
	adc	#$50
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri0,noflip

	plb
	rts

;*********************************************************************
;*								*
;*	(Test Version) Training Mode				*
;*								*
;*********************************************************************
;---------------------------------------------------------------------
;*			CHECK TEST Traing			*
;---------------------------------------------------------------------
selecttraining_l
	php
	a8i16
	lda	#0
	sta	key_tateptr1
	lda	#2
	sta	key_tatemaxptr1	;key down max pointer

	jsr	Init_TestScreen
;* screen ON *
	km_IRQenable	titleirq	;[IRQ enable]
	km_screenon

	ENABLE			;IRQ enable

.loop_mapsel
	jsl	Check_autotrigUD_l	;[key check]
	jsr	do_spritesTT		;[sprites]

	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

	testjoypad	b	;[cancell]
	beq	.nopushB

	km_setgamemode	title
	jmp	.end
.nopushB

	km_testjoypad	OK
	bne	.pushstart
	bra	.loop_mapsel

.pushstart
	lda	#sport3_Kettei
	ksound_a

	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

	lda	key_tateptr1
	bne	.training
.typeselect
	km_setgamemode	typeselect
	bra	.end
.training
	km_setgamemode	training
;--------------------------------------------------------------------
.end	
	km_screenoff	;SCREEN,IRQ,HDMA OFF
	plp
	rtl




;*********************************************************************
;*								*
;*			TiTle Routine				*
;*								*
;*********************************************************************
	IFEQ	1
title_l
	php
	a8i16
;********************	Initial			*****************
;* cgx,scr,col,oam ,irq enable *
;;;	km_clrKAWARAM			;[WORK RAM CLEAR]
	jsr	Init_TestScreen

;* screen ON *
	km_IRQenable	titleirq	;[IRQ enable]
	km_screenon

;* parameter init set *
	km_setval	key_tatemaxptr1,(kgamemodetblEND-kgamemodetbl)

;*******************		GAME Select Mode	*****************
Select_gamemode
	jsl	Check_autotrigUD_l	;[key check] 
	jsr	do_spritesGS	 	;[sprites]

	lda	#iv_titleirq
	sta	trans_flag		;[irq flag]
	km_waittrans			;[irq wait]

	km_testjoypad	OK		;[key check]
	bne	.pushstart
	bra	select_gamemode
;-----------------------------------------------------------------------
.pushstart
	lda		#sport3_kettei
	ksound_a			;kettei [sound]
;					;start button wo push shitara
	lda	#iv_titleirq
	sta	trans_flag		;[irq flag]
	km_waittrans			;[irq wait]
;-------------------------------------------------------------------------
	km_lldx	key_tateptr1
	lda.l	kgamemodetbl,x
	cmp	#kmode_stereomonoral
	beq	Select_gamemode ;If stereo/monoral no postion de 
	km_stagamemode		;mission/battle/another mode
;-------------------------------------------------------------------------
;* sound off *
	KBGM	FadeOut

.wait
	lda	bgmcnt
	cmp	#2
	bne	.wait

;* screen off & irq off *
	km_screenoff
	plp
	rtl
;-------------------------------------------------------------------------
kgamemodetbl
	db	kmode_selectmissionplayer
	db	kmode_selectbattlefield
	db	kmode_testgamemode
	db	kmode_training
	db	kmode_config
kgamemodetblEND

;	db	kmode_3dglasses
;	db	kmode_training
;	db	kmode_typeselect

;=====================================================================
;*		Select Game Mode		[KEY CHECK]	*
;=====================================================================
check_soundmode
	shorta
	longi
	IFEQ	1
	testjoypad	LR
	beq		.exit
;---------------------------------------------------------------------
.LeftRight
;stereo/monoral kirikae
	lda	keyptr
	cmp	#5
	bne	.exit

	lda	monoral
	inc	a
	and	#1
	sta	monoral
	jsl	Stereo_l
;---------------------------------------------------------------------
.sound
	ksound	cursor
;---------------------------------------------------------------------
.exit
	endc
	rts
;=====================================================================
;*		Set game select sprites		[SPRITES]	*
;* DAta
;=====================================================================
do_spritesGS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0
;game select init screen display
	BlockTransSPrites	TitSPrData
	BlockTransSPrites	GameSelSprData

;stereo / monoral
	lda	monoral
	bne	.monoral
.stereo
;	BlockTransSPrites	StereoSprData
	bra	.skip
.monoral
;	BlockTransSPrites	MonoralSprData
.skip
;game select mark set
	lda	#$50
	sta	sprites,y	;[X zahyo]
	iny

	lda	key_tateptr1	;keyptr
	km_multa8
	clc
	adc	#$60		;[y zahyo]
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri3,noflip	;[character]

	plb
	rts
	ENDC
;***************************************************************************
;***************************************************************************
	ENDC
;***************************************************************************
;***************************************************************************
;=============================================================================

;=============================================================================
;*				BATTLE					*
;=============================================================================
	IFEQ	1
bmx	=	$60
bmy	=	$40
ty = 2

BMapSelSprData
	km_datacnt	W,BMapSelSprData
	SpriteDataB	bmx+0*8,bmy+ty*8,titchr+conf_b,colpal0,pri3,noflip
	SpriteDataB	bmx+1*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+2*8,bmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	bmx+3*8,bmy+ty*8,titchr+conf_bar,colpal0,pri3,noflip

	SpriteDataB	bmx+4*8,bmy+ty*8,titchr+conf_g,colpal0,pri3,noflip
	SpriteDataB	bmx+5*8,bmy+ty*8,titchr+conf_r,colpal0,pri3,noflip
	SpriteDataB	bmx+6*8,bmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	bmx+7*8,bmy+ty*8,titchr+conf_u,colpal0,pri3,noflip
	SpriteDataB	bmx+8*8,bmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	bmx+9*8,bmy+ty*8,titchr+conf_d,colpal0,pri3,noflip
	SpriteDataB	bmx+10*8,bmy+ty*8,titchr+conf_1,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	bmx+0*8,bmy+ty*8,titchr+conf_b,colpal0,pri3,noflip
	SpriteDataB	bmx+1*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+2*8,bmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	bmx+3*8,bmy+ty*8,titchr+conf_bar,colpal0,pri3,noflip

	SpriteDataB	bmx+4*8,bmy+ty*8,titchr+conf_g,colpal0,pri3,noflip
	SpriteDataB	bmx+5*8,bmy+ty*8,titchr+conf_r,colpal0,pri3,noflip
	SpriteDataB	bmx+6*8,bmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	bmx+7*8,bmy+ty*8,titchr+conf_u,colpal0,pri3,noflip
	SpriteDataB	bmx+8*8,bmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	bmx+9*8,bmy+ty*8,titchr+conf_d,colpal0,pri3,noflip
	SpriteDataB	bmx+10*8,bmy+ty*8,titchr+conf_2,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	bmx+0*8,bmy+ty*8,titchr+conf_b,colpal0,pri3,noflip
	SpriteDataB	bmx+1*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+2*8,bmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	bmx+3*8,bmy+ty*8,titchr+conf_bar,colpal0,pri3,noflip

	SpriteDataB	bmx+4*8,bmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	bmx+5*8,bmy+ty*8,titchr+conf_p,colpal0,pri3,noflip
	SpriteDataB	bmx+6*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+7*8,bmy+ty*8,titchr+conf_c,colpal0,pri3,noflip
	SpriteDataB	bmx+8*8,bmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	bmx+9*8,bmy+ty*8,titchr+conf_1,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	bmx+0*8,bmy+ty*8,titchr+conf_b,colpal0,pri3,noflip
	SpriteDataB	bmx+1*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+2*8,bmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	bmx+3*8,bmy+ty*8,titchr+conf_bar,colpal0,pri3,noflip

	SpriteDataB	bmx+4*8,bmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	bmx+5*8,bmy+ty*8,titchr+conf_p,colpal0,pri3,noflip
	SpriteDataB	bmx+6*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+7*8,bmy+ty*8,titchr+conf_c,colpal0,pri3,noflip
	SpriteDataB	bmx+8*8,bmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	bmx+9*8,bmy+ty*8,titchr+conf_2,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	bmx+0*8,bmy+ty*8,titchr+conf_b,colpal0,pri3,noflip
	SpriteDataB	bmx+1*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+2*8,bmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	bmx+3*8,bmy+ty*8,titchr+conf_bar,colpal0,pri3,noflip

	SpriteDataB	bmx+4*8,bmy+ty*8,titchr+conf_m,colpal0,pri3,noflip
	SpriteDataB	bmx+5*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+6*8,bmy+ty*8,titchr+conf_r,colpal0,pri3,noflip
	SpriteDataB	bmx+7*8,bmy+ty*8,titchr+conf_i,colpal0,pri3,noflip
	SpriteDataB	bmx+8*8,bmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	bmx+9*8,bmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
BMapSelSprDataEnd
	ENDC
;----------------------------------------------------------------------------------------------
	IFEQ	1
gmselx	equ	$60
gmsely	equ	$40
ty = 6
GameSelSprData
	km_datacnt	W,GameSelSprData
	SpriteDataB	gmselx+0*8,gmsely+ty*8,titchr+conf_m,colpal0,pri3,noflip ;m
	SpriteDataB	gmselx+1*8,gmsely+ty*8,titchr+conf_i,colpal0,pri3,noflip ;i
	SpriteDataB	gmselx+2*8,gmsely+ty*8,titchr+conf_s,colpal0,pri3,noflip ;s
	SpriteDataB	gmselx+3*8,gmsely+ty*8,titchr+conf_s,colpal0,pri3,noflip ;s
	SpriteDataB	gmselx+4*8,gmsely+ty*8,titchr+conf_i,colpal0,pri3,noflip ;i
	SpriteDataB	gmselx+5*8,gmsely+ty*8,titchr+conf_o,colpal0,pri3,noflip ;o
	SpriteDataB	gmselx+6*8,gmsely+ty*8,titchr+conf_n,colpal0,pri3,noflip ;n
ty = ty+1
	SpriteDataB	gmselx+0*8,gmsely+ty*8,titchr+conf_b,colpal0,pri3,noflip ;b
	SpriteDataB	gmselx+1*8,gmsely+ty*8,titchr+conf_a,colpal0,pri3,noflip ;a
	SpriteDataB	gmselx+2*8,gmsely+ty*8,titchr+conf_t,colpal0,pri3,noflip ;t
	SpriteDataB	gmselx+3*8,gmsely+ty*8,titchr+conf_t,colpal0,pri3,noflip ;t
	SpriteDataB	gmselx+4*8,gmsely+ty*8,titchr+conf_l,colpal0,pri3,noflip ;l
	SpriteDataB	gmselx+5*8,gmsely+ty*8,titchr+conf_e,colpal0,pri3,noflip ;e
ty = ty+1
	SpriteDataB	gmselx+0*8,gmsely+ty*8,titchr+conf_t,colpal0,pri3,noflip ;t
	SpriteDataB	gmselx+1*8,gmsely+ty*8,titchr+conf_e,colpal0,pri3,noflip ;e
	SpriteDataB	gmselx+2*8,gmsely+ty*8,titchr+conf_s,colpal0,pri3,noflip ;s
	SpriteDataB	gmselx+3*8,gmsely+ty*8,titchr+conf_t,colpal0,pri3,noflip ;t
ty = ty+1
	SpriteDataB	gmselx+0*8,gmsely+ty*8,titchr+conf_t,colpal0,pri3,noflip ;t
	SpriteDataB	gmselx+1*8,gmsely+ty*8,titchr+conf_r,colpal0,pri3,noflip ;r
	SpriteDataB	gmselx+2*8,gmsely+ty*8,titchr+conf_a,colpal0,pri3,noflip ;a	
	SpriteDataB	gmselx+3*8,gmsely+ty*8,titchr+conf_i,colpal0,pri3,noflip ;i
	SpriteDataB	gmselx+4*8,gmsely+ty*8,titchr+conf_n,colpal0,pri3,noflip ;n
	SpriteDataB	gmselx+5*8,gmsely+ty*8,titchr+conf_i,colpal0,pri3,noflip ;i
	SpriteDataB	gmselx+6*8,gmsely+ty*8,titchr+conf_n,colpal0,pri3,noflip ;n
	SpriteDataB	gmselx+7*8,gmsely+ty*8,titchr+conf_g,colpal0,pri3,noflip ;g
ty = ty+1

	SpriteDataB	gmselx+0*8,gmsely+ty*8,titchr+conf_c,colpal0,pri3,noflip ;c
	SpriteDataB	gmselx+1*8,gmsely+ty*8,titchr+conf_o,colpal0,pri3,noflip ;o
	SpriteDataB	gmselx+2*8,gmsely+ty*8,titchr+conf_n,colpal0,pri3,noflip ;n
	SpriteDataB	gmselx+3*8,gmsely+ty*8,titchr+conf_f,colpal0,pri3,noflip ;f
	SpriteDataB	gmselx+4*8,gmsely+ty*8,titchr+conf_i,colpal0,pri3,noflip ;i
	SpriteDataB	gmselx+5*8,gmsely+ty*8,titchr+conf_g,colpal0,pri3,noflip ;g
GameSelSprDataEND
	ENDC
;----------------------------------------------------------------------------------------------
	IFEQ	1
mmx	=	$60
mmy	=	$40
ty = 6
MLevelSelSprData
	km_datacnt	W,MLevelSelSprData
;Easy
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_y,colpal0,pri3,noflip

;Normal
	SpriteDataB	mmx+00*8,mmy+(ty+1)*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+(ty+1)*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+(ty+1)*8,titchr+conf_r,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+(ty+1)*8,titchr+conf_m,colpal0,pri3,noflip
	SpriteDataB	mmx+04*8,mmy+(ty+1)*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+05*8,mmy+(ty+1)*8,titchr+conf_l,colpal0,pri3,noflip

;Hard
	SpriteDataB	mmx+00*8,mmy+(ty+2)*8,titchr+conf_h,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+(ty+2)*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+(ty+2)*8,titchr+conf_r,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+(ty+2)*8,titchr+conf_d,colpal0,pri3,noflip
MLevelSelSprDataEnd
	ENDC
;----------------------------------------------------------------------------------------------
	IFEQ	1
bmx	=	$60
bmy	=	$60
ty = 2
BatMapSelSprData
	km_datacnt	W,BatMapSelSprData
	SpriteDataB	bmx+0*8,bmy+ty*8,titchr+conf_g,colpal0,pri3,noflip
	SpriteDataB	bmx+1*8,bmy+ty*8,titchr+conf_r,colpal0,pri3,noflip
	SpriteDataB	bmx+2*8,bmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	bmx+3*8,bmy+ty*8,titchr+conf_u,colpal0,pri3,noflip
	SpriteDataB	bmx+4*8,bmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	bmx+5*8,bmy+ty*8,titchr+conf_d,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	bmx+0*8,bmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	bmx+1*8,bmy+ty*8,titchr+conf_p,colpal0,pri3,noflip
	SpriteDataB	bmx+2*8,bmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	bmx+3*8,bmy+ty*8,titchr+conf_c,colpal0,pri3,noflip
	SpriteDataB	bmx+4*8,bmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	bmx+0*8,bmy+ty*8,titchr+conf_i,colpal0,pri3,noflip
	SpriteDataB	bmx+1*8,bmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	bmx+2*8,bmy+ty*8,titchr+conf_d,colpal0,pri3,noflip
	SpriteDataB	bmx+3*8,bmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	bmx+4*8,bmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	bmx+5*8,bmy+ty*8,titchr+conf_r,colpal0,pri3,noflip
BatMapSelSprDataEnd
	ENDC


;***************************************************************************
;***************************************************************************
;***************************************************************************
	ENDC
;***************************************************************************
;***************************************************************************
;***************************************************************************
