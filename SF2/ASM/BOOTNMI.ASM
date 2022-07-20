	incpub	bootnmi

	shorta
	shorti
startboot	disable		;IRQ disable
	clc
;kono kirikae (6502 ---> 65816) wo surumade 65816 command wo tukauna !!
	xce		;65816 mode
;----------------------------------------------------------------
	stz	nmitimen	;NMI disable
	stz	mdmaen		;DMA OFF
	stz	hdmaen		;HDMA OFF
	lda	#$80
	sta	inidisp		;screen off
	stz	setini		;set ppu mode
;----------------------------------------------------------------
	ai16
	lda	#0
	tcd		;direct reg set
	a8
	db0
	ldx	#$2ff
	txs		;stack pointer set
;----------------------------------------------------------------
;*** SFX reg initial & D-RAM ,M-RAM clear ***
	shorta
	i8
	jsl	startsfx_l	;reset SFX register
	jsr	initialise_ram	;clear SFX & Mario RAM
;--------------------------------------------------------------------
;**** Ver Check *****
	jsr	VersionCheck

;**** ima conect shiteiru controller ha nanika check *****
	jsr	Check_ConectCont
;--------------------------------------------------------------------
;[Back Up Ram Clear] :Yajima's
	jsl	Check_backupRAM_l   	;; backup ram initialize

	a16
	lda	#0
	sta.l	backup_writeflag
	a8
;--------------------------------------------------------------------
;*** Sound Initialize ***
;*sound program tensou *
	a8i16
	ksoundprogtrans
	ksoundtrans	ffset1
	ksoundtrans	ffset2
;---------------------------------------------------------------------
	ai8
;;;;	fast			;21M mode
;---------------------------------------------------------------------
gamecotinue
	jsl	Read_backupRAM_coindata_l
	jsl	Read_backupRAM_soundmode_l

	ai8
	jsl	initialise_l
	jsl	intro_l		;Game Main
restart
	a8
	db0
	ai16
	clc
	xce
	lda	#0
	tcd
	ldx	#$2ff
	txs			; reset the stack
	ai8
	disable
	jsl	startsfx_l
	jsr	initialise_ram
	bra	gamecotinue

;*********************************************************************
;*								*
;*		Initialise SFX RAM				*
;*								*
;*********************************************************************

; clear all ram
initialise_ram
	php

	a8
	lda	#$7e
	pha
	plb

	ai16
	ldx	#$2000	;clr ext. RAM
.7epage	stz.w	0,x
	stz.w	2,x
	stz.w	4,x
	stz.w	6,x
	txa
	clc
	adc	#8
	tax
	bne	.7epage

	a8
	lda	#$7f
	pha
	plb
	a16

.7fpage	stz.w	0,x
	stz.w	2,x
	stz.w	4,x
	stz.w	6,x
	txa
	clc
	adc	#8
	tax
	bne	.7fpage

	a8
	lda	#$70
	pha
	plb

	ai16
	ldx	#m_backupram_start&WM
.loop1	dex
	dex
	stz.w	0,x
	bne	.loop1

	ldx	#m_backupram_end&WM
.loop2	stz.w	0,x
	inx
	inx
	bne	.loop2

	IFNE	clr_bakupram
	ldx	#(m_backupram_end-m_backupram_start)&WM
.loop3	dex
	stz.w	m_backupram_start&WM,x
	bne	.loop3
	ENDC

	jsl	check_backupram_l

	a8
	lda	#0
	pha
	plb
	a16

	ldx	#$2000-$300-8	;clr Work RAM
.sssp	stz	$300,x
	stz	$302,x
	stz	$304,x
	stz	$306,x
	txa
	sec
	sbc	#8
	tax
	bpl	.sssp

	ldx	#$fe
.zpage	stz	0,x
	dex
	dex
	bpl	.zpage

	jsl	copy_to_0101_l

	a8
	lda	stat78r		; ntsc/pal
	and	#1<<4
	sta	ntscpal


	plp
	rts


;*********************************************************************
;*								*
;*		Initialise SFX Register				*
;*								*
;*********************************************************************
	shorta
	shorti
;------ reset SFX regs ------------------------------
startsfx_l
	disable
	waitdma	1
	waitdma	0
	lda	#$8f
	sta	$2100
	lda	#0
	sta	$2101
	sta	$2102
	sta	$2103

	sta	$2105
	sta	$2106
	sta	$2107
	sta	$2108
	sta	$2109
	sta	$210a
	sta	$210b
	sta	$210c

	sta	$210d
	sta	$210d
	sta	$210e
	sta	$210e
	sta	$210f
	sta	$210f
	sta	$2110
	sta	$2110
	sta	$2111
	sta	$2112
	sta	$2112
	sta	$2113
	sta	$2113
	sta	$2114
	sta	$2114

	ldx	#$80
	stx	$2115
	
	sta	$2116
	sta	$2117

	sta	$211a

	ldx	#1
	sta	$211b
	stx	$211b
	sta	$211c
	sta	$211c
	sta	$211d
	sta	$211d
	sta	$211e
	stx	$211e
	sta	$211f
	sta	$211f
	sta	$2120
	sta	$2120

	sta	$2121

	sta	$2122
	sta	$2123
	sta	$2124
	sta	$2125
	sta	$2126
	sta	$2127
	sta	$2128
	sta	$2129
	sta	$212a
	sta	$212b
	sta	$212c
	sta	$212d
	sta	$212e

	ldy	#$30
	sty	$2130

	sta	$2131
	ldx	#$e0
	stx	$2132
	sta	$2133

	sta	$4200
	ldx	#$ff
	stx	$4201
	sta	$4202
	sta	$4203
	sta	$4204
	sta	$4205
	sta	$4206
	sta	$4207
	sta	$4208
	sta	$4209
	sta	$420a
	sta	$420b
	sta	$420c
	sta	$420d

;* Read Register *
	lda	stat78r	;$213f
	rtl

	shorta
	longi
fnmi_l
	rtl
;*********************************************************************
;*								*
;*		Super Famicom Version Check	[NTSC/PAL]	*
;*								*
;*********************************************************************
VersionCheck
	php
	phb
	ai8
	db0
	stz	kz_x1

	ifne	pal
	inc	kz_x1
	ENDC

	lda	stat78r
	bit	#d4	;%00010000
	bne	.Pal
.NTSC
	lda	kz_x1
	beq	.END	;NTSC
	brl	Display_IllegalMessage
.PAL
	lda	kz_x1
	bne	.END
	brl	Display_IllegalMessage
.END
	plb
	plp
	rts	

;*********************************************************************
;*								*
;*		Connect Controller Type Check			*
;*								*
;*********************************************************************
Check_ConectCont
	php
	phb
	ai8
	db0
;----------------------------------------------------
	km_setval	nmitimen,0	;auto read disable
	km_setval	$4016,0

	jsr	check_joycontenable
;----------------------------------------------------
;* Get Check Params *
	stz	kz_x1
	stz	kz_y1

	km_setval	$4016,1
	km_setval	$4016,0

	ldx	#16
.loop1
	lda	$4016
	lsr	a
	rol	kz_x1		;controller 1 params

	lda	$4017
	lsr	a
	rol	kz_y1		;controller 2 params
	dex
	bne	.loop1

;* controller conect check ( 17 bit me ) *
	lda	$4016
	sta	kz_x2
	lda	$4017
	sta	kz_y2

;----------------------------------------------------
;* cont 1 ni controller conect ? *
	lda	kz_x1
	and	#%00001111
	bne	.NOK

;	lda	kz_x2
;	and	#%1
;	beq	.Not_conect_cont1

;* cont 1 ni multi 5 ga conect ? *
	jsr	Check_Multi5_cont1
	bcs	.NOK
.Not_conect_cont1
;----------------------------------------------------
;* cont 2 ni controller conect ? *

	lda	kz_y1
	and	#%00001111
	bne	.NOK

;	lda	kz_y2
;	and	#%1
;	beq	.Not_conect_cont2

;* cont 2 ni multi 5 ga conect ? *
	jsr	Check_Multi5_cont2
	bcs	.NOK
.Not_conect_cont2
;----------------------------------------------------
.End
	km_setval	$4016,0

	plb
	plp
	rts
;----------------------------------------------------
.NOK
	jmp	Display_NOKmessage
;=====================================================================
;*								*
;*		Multi Player 5 Conect Check	(Controller1)	*
;*								*
;=====================================================================
	shorta
	shorti
Check_Multi5_cont1
;-------------------------------------
;* muliti 5 Conect Check (cont1)	*
;-------------------------------------
.Check1
	lda	$4016
	ora	#%1
	sta	$4016
;--------------------------------------
.Check2
	ldx	#8
.loop1
	lda	$4016
	and	#%00000010
	beq	.NoMulti5
	dex
	bne	.loop1
;--------------------------------------
.Check3
	lda	$4016
	and	#%11111110
	sta	$4016
;--------------------------------------
.Check4
	ldx	#8
.loop2
	lda	$4016
	and	#%00000010
	beq	.Multi5
	dex
	bne	.loop2
;--------------------------------------
.NoMulti5
	clc
	rts
;--------------------------------------
.Multi5
	sec
	rts


;=====================================================================
;*								*
;*		Multi Player 5 Conect Check	(Controller2)	*
;*								*
;=====================================================================
	shorta
	shorti
Check_Multi5_cont2
;-------------------------------------
;* muliti 5 Conect Check (cont2)	*
;-------------------------------------
.Check1
	lda	$4016
	ora	#%1
	sta	$4016
;--------------------------------------
.Check2
	ldx	#8
.loop1
	lda	$4017
	and	#%00000010
	beq	.NoMulti5
	dex
	bne	.loop1
;--------------------------------------
.Check3
	lda	$4016
	and	#%11111110
	sta	$4016
;--------------------------------------
.Check4
	ldx	#8
.loop2
	lda	$4017
	and	#%00000010
	beq	.Multi5
	dex
	bne	.loop2
;--------------------------------------
.NoMulti5
	clc
	rts
;--------------------------------------
.Multi5
	sec
	rts

;---------------------------------------------------------------------
;*		Joy Contoroller Read Enable Check		*
;---------------------------------------------------------------------
	shorta
	shorti
check_joycontenable
.vblank_wait1
	lda	rdnmir		;($4210)
	bit	#%10000000
	beq	.vblank_wait1
	lda	rdnmir

.580cycle_wait	;chyotto oomeni 600 cycle wait
	ldx	#150
.loop
	dex			;2 cycle
	bne	.loop		;2 cycle

.joy_disable
	lda	hvbjoyr
	bit	#1
	bne	.joy_disable
	rts

;---------------------------------------------------------------------
;*		Illegal Super Famicom Type Message		*
;---------------------------------------------------------------------
nok_bg1_cgx	equ	0
nok_bg1_scr	equ	(32*k)/2
Display_IllegalMessage
	a8i16
	db0
	decvramnotrans	0,nok_bg1_scr,b13_pcr,$800
	bra	IllegalMessageCommon
;---------------------------------------------------------------------
;*		Mistake Controller Type Message			*
;---------------------------------------------------------------------
Display_NOKmessage
	a8i16
	db0
	decvramnotrans	0,nok_bg1_scr,b12_pcr,$800

;---------------------------------------------------------------------
;*		Display Common					*
;---------------------------------------------------------------------
	shorta
	longi
IllegalMessageCommon
	decvramnotrans	0,nok_bg1_cgx,b12_ccr,($100*32)
	decrunch_palettes
	dmacgram	0,0,b0_pac,$200
	km_setval	bgmode,0
	km_setval	bg1sc,(nok_bg1_scr>>8)&$fc
	km_setval	bg12nba,(nok_bg1_cgx>>12)
	km_setval	tm,%00000001
	km_setval	INIDISP,$f
.loop
	bra	.loop

;---------------------------------------------------------------------
;		Not Using Area
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
	IFEQ	1	;'95/6/21 :comment :check :dylan
gamecotinue
	ai8
	jsl	initialise_l
	jsl	intro_l		;Game Main
restart
;	a8
;	lda	#0
;	sta.l	contexit
;	lda	#0
;	sta	defaulttrain
;;;;	bra	firsttimeuse
	ENDC
;---------------------------------------------------------------------
	IFEQ	1	;'95/6/21 :comment :check :dylan
	lda.l	whichroute
	pha			; preserve level number
	lda	defaulttrain
	pha
	lda.l	contexit
	pha
	lda	c_type
	pha
	jsr	initialise_ram
	pla
	sta	c_type
	pla
	sta.l	contexit
	pla
	sta	defaulttrain
	pla
	sta.l	whichroute
	lda	#1
	sta	firstdnld
;-----------------------------------------------------
firsttimeuse
	a8
	lda	#0
	pha
	plb			;Data Bank 0
	ai8
	jsl	startsfx_l	;reset SFX register
	jsr	initialise_ram	;clear SFX&Mario RAM
	i16
	ldx	#$2ff
 	txs			; reset the stack
;-----------------------------------------------------
;'95/4/7 :comment
	a8i16
   	phb
	db7e
	jsl	hvofsRAMClear1_l
	jsl	hvofsRAMClear2_l
	plb
;kawaguchi params
;	km_clrgameflag		all
;	km_clrmismapflag	all
;	km_clrmissionflag	all
;	km_clrbattleflag	all
;	km_clrgameoverflag	all
;	km_clrscreenflag	all
;	km_clrscrollflag	all
;	km_clrwindowflag	all
;	km_clrsndflag		all
	km_setgamemode	title
	jmp	gamecotinue
	ENDC

;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------






