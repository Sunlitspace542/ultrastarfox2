;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         CONFIG.ASM 	                                       ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  Config Routine   	                               ;
; DATE CREATED: 18-4-94                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
	INCPUB	config
;--------------------------------------------------------------------
configmode_l
	jsr	configmode
	rtl
;*********************************************************************
;*								*
;*			CONFIG					*
;*								*
;*********************************************************************
CONFIGMODE
	IFNE	enableconfig
	php
	a8i16
	phb
	pha
	phx
	phy

;;;	km_clrKAWARAM		;[WORK RAM CLEAR]
	jsr	init_configmode
;* SCREEN ON *
	km_screenon
;* IRQ ENABLE *
	km_IRQenable	titleirq
;-------------------------------------------------------------------
;********** Main Loop **********
.loop
	jsr	configkeycheck	;[key check]
	jsr	configsprites	;[sprites]

	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]

	km_bitcheckflag.l	conf_flag,conf_exit
	beq	.loop
;-------------------------------------------------------------------
;* Return to Title *
.end
	KBGM			fadeout	;port0
	km_setsoundport1	stop	;port1
	km_setsoundport2	stop	;port2
;-------------------------------------------------------------------
	km_screenoff
	km_setgamemode		title
;-------------------------------------------------------------------
	ply
	plx
	pla
	plb
	plp
	ENDC
	rts



	IFNE	enableconfig
;=====================================================================
;*								*
;*		Initial config mode				*
;*								*
;=====================================================================
Init_configmode
	shorta
	longi
;* SCREEN OFF *
	km_screenoff
	km_setval	kw_tm,%00010000

;* CGX DATA wo VRAM ni tensou *
	km_dmacgx4VRAM	0,kawaguti_cgx,cn_obj_cgx,$30
	decrunch_palettes
	dmacgram	0,$80,yaji_0_pac,$40*2

;* SPRITES DATA wo SET *
	jsr	configsprites
	oamsuballon

;* PARAMETERS no syokika *
	stz	key_tateptr1
	km_setval	key_tatemaxptr1,7
	rts

;=====================================================================
;*		KEY CHECK to SOUND SET				*
;* data bank 7e							*
;=====================================================================
configkeycheck
	shorta
	longi
	phb
	db7e
	km_hib0
	lda	key_tateptr1	;keyptr
	asl	a
	tax
;* SOUND DATA SET *
	km_testjoypad	kettei
	beq	.checkBbutton
	jmp	(.ketteitbl,x)
.ketteitbl
	dw	.stereo_monoral&WM
	dw	.ring_bgm&WM
	dw	.port0&WM
	dw	.port1&WM
	dw	.port2&WM
	dw	.port3&WM
	dw	.stereo_monoral&WM
.checkBbutton
	km_testjoypad	Cancel
	km_beq	.checktrigger
	jmp	(.canceltbl,x)
.canceltbl
	dw	.exit&WM
	dw	.stop_bgm&WM
	dw	.stop_port0&WM
	dw	.stop_port1&WM
	dw	.stop_port2&WM
	dw	.stop_port3&WM
	dw	.exit&WM

;=====================================================================
;*			Kettei					*
;=====================================================================
.stereo_monoral
	km_setflag	conf_flag,conf_exit
	brl	.exit
;--------------------------------------
.ring_bgm
	disable
	KSoundBGMTestTrans
	lda	timeupr
	enable
	lda	conf_port0
	KBGM_a
	brl	.exit
;--------------------------------------
.port0
	lda	conf_port0
	KBGM_a
	brl	.exit
;--------------------------------------
.port1
	lda	conf_port1
	km_setsoundport1
	brl	.exit
;--------------------------------------
.port2
	lda	conf_port2
	km_setsoundport2
	brl	.exit
;--------------------------------------
.port3
	lda	conf_se
	cmp	#2		;pause on sound
	beq	.skip_se
	ksound_a
.skip_se
	brl	.exit
;=====================================================================
;*			Cancel					*
;=====================================================================
.stop_bgm
	kBGM	stop
	brl 	.exit
.stop_port0
	kBGM	stop
	brl 	.exit
.stop_port1
	km_setsoundport1	stop
	brl 	.exit
.stop_port2
	km_setsoundport2	stop
	brl 	.exit
.stop_port3
	ksound	stop
	brl 	.exit
;=====================================================================
;*			Select					*
;=====================================================================
.checktrigger
	km_autotrigread		;[KEY STATES READ]
	km_TESTautotrig	UP
	bne		.up
	km_TESTautotrig	DOWN
	bne		.down
	bra		.CheckLR
;---------------------------------------------------------------------
.up
	lda	key_tateptr1	;keyptr
	dec	a
	bpl	.skip_up
	lda	key_tatemaxptr1	;keymaxptr
	dec	a
.skip_up
	sta	key_tateptr1	;keyptr
	brl	.sound
;---------------------------------------------------------------------
.down
	lda	key_tateptr1	;keyptr
	inc	a
	cmp	key_tatemaxptr1	;keymaxptr
	bne	.skip_down
	lda	#0
.skip_down
	sta	key_tateptr1	;keyptr
	brl	.sound
;---------------------------------------------------------------------
.CheckLR
	km_TESTautotrig	LR
	km_beq	.exit

	jmp	(.sndporttbl,x)
.sndporttbl
	dw	.soundmode&WM
	dw	.bgm&WM
	dw	.sport0&WM
	dw	.sport1&WM
	dw	.sport2&WM
	dw	.sport3&WM
	dw	.exit&WM
;---------------------------------------------------------------------
.soundmode
	km_TESTautotrig	Right
	bne	.RIGHT1
	lda	monoral		;conf_sound
	dec	a
	and	#1
	sta	monoral		;conf_sound
	jsl	Stereo_l
	brl	.sound
.RIGHT1
	lda	monoral		;conf_sound
	inc	a
	and	#1
	sta	monoral

	jsl	Stereo_l
	brl	.sound
;---------------------------------------------------------------------
.BGM
	lda	conf_bgm
	jsr	SelectConfigSound
	IFNE	configimprovements
	bmi	.bgmminus
	cmp	#configSNDtbllen/2
	bne	.get_bgm
	lda	#0
	bra	.get_bgm
.bgmminus
	lda	#configSNDtbllen/2-1
.get_bgm
	ENDC
	sta	conf_bgm
	bra	.sound
;---------------------------------------------------------------------
.Sport0
	lda	conf_port0
	jsr	SelectConfigSound
	bmi	.minus
	cmp	#9
	bne	.get_port0
	lda	#0
	bra	.get_port0
.minus
	lda	#8
.get_port0
	sta	conf_port0
	bra	.sound
;---------------------------------------------------------------------
.Sport1
	lda	conf_port1
	jsr	SelectConfigSound
	sta	conf_port1
	bra	.sound
;---------------------------------------------------------------------
.Sport2
	lda	conf_port2
	jsr	SelectConfigSound
	sta	conf_port2
	bra	.sound
;---------------------------------------------------------------------
.Sport3
	lda	conf_se
	jsr	SelectConfigSound
	sta	conf_se
;---------------------------------------------------------------------
.sound
	IFNE	configcursorsound
	ksound	cursor
	ENDC
;---------------------------------------------------------------------
.exit
	plb
	rts
;---------------------------------------------------------------------
;*		Select Config Sound	(port 0,1,2,3)		*
;*INPUT,OUTPUT :Acc							*
;---------------------------------------------------------------------
SelectConfigSound
	shorta
	longi

	pha
	km_testkeydown	X
	beq	.step1

	km_TESTautotrig	Right
	bne	.stepR10
.stepL10
	pla
	sec
	sbc	#$10
	bra	.exit
.stepR10
	pla
	clc
	adc	#$10
	bra	.exit
.step1
	km_TESTautotrig	Right
	bne	.stepR1
.stepL1
	pla
	dec	a
	bra	.exit
.stepR1
	pla
	inc	a
	bra	.exit
;------------------------------------------------------------------------
.exit

	RTS
;-------------------------------------------------------------------------

;=====================================================================
;*								*
;=====================================================================
configsprites
	shorta
	longi
	phb
	db7e
	oamclear_SG

	ldy	#0
;---------------------------------------------------------------------------
;* CONFIG KOTEI MOJI *
	BlockTransSPrites	ConfigSprData
;---------------------------------------------------------------------------
;* YAJIRUSHI *
	lda	#$10
	sta	sprites,y	;[X zahyo]
	iny

	lda	key_tateptr1	;keyptr
	km_multa8
	clc
	adc	#$40		;[y zahyo]
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri3,noflip	;[character]
;---------------------------------------------------------------------------
;* STEREO , MONORAL *
	lda	monoral
	bne	.monoral
.stereo
	BlockTransSprites	StereoSprData
	bra	.next1
.monoral
	BlockTransSprites	MonoralSprData
;---------------------------------------------------------------------------
.next1
;* BGM *
	lda	conf_bgm
	km_printByte	11,9
;* SPORT0 *
	lda	conf_port0
	km_printByte	11,10
;* SPORT1 *
	lda	conf_port1
	km_printByte	11,11
;* SPORT2 *
	lda	conf_port2
	km_printByte	11,12
;* SE *
	lda	conf_se
	km_printByte	11,13

;* port0 *
	km_readport0
	km_printBinary	11,16
;* port1 *
	km_readport1
	km_printBinary	11,17
;* port2 *
	km_readport2
	km_printBinary	11,18
;* port3 *
	km_readport3
	km_printByte	11,19
;---------------------------------------------------------------------------
.end
	plb
	rts

;*********************************************************************
;*								*
;*			CONFIG MODE				*
;*								*
;*********************************************************************
configx	equ	$00
configy	equ	$00
confchroff	equ	$00

ConfigSprData
	km_datacnt	W,ConfigSprData
	SpriteDataB	configx+10*8,configy+06*8,confchroff+$0c,colpal0,pri3,noflip	;c
	SpriteDataB	configx+11*8,configy+06*8,confchroff+$18,colpal0,pri3,noflip	;o
	SpriteDataB	configx+12*8,configy+06*8,confchroff+$17,colpal0,pri3,noflip	;n
	SpriteDataB	configx+13*8,configy+06*8,confchroff+$0f,colpal0,pri3,noflip	;f
	SpriteDataB	configx+14*8,configy+06*8,confchroff+$12,colpal0,pri3,noflip	;i
	SpriteDataB	configx+15*8,configy+06*8,confchroff+$10,colpal0,pri3,noflip	;g

	SpriteDataB	configx+17*8,configy+06*8,confchroff+$16,colpal0,pri3,noflip	;m
	SpriteDataB	configx+18*8,configy+06*8,confchroff+$18,colpal0,pri3,noflip	;o
	SpriteDataB	configx+19*8,configy+06*8,confchroff+$0d,colpal0,pri3,noflip	;d
	SpriteDataB	configx+20*8,configy+06*8,confchroff+$0e,colpal0,pri3,noflip	;e

	SpriteDataB	configx+04*8,configy+08*8,confchroff+$1c,colpal0,pri3,noflip	;s
	SpriteDataB	configx+05*8,configy+08*8,confchroff+$18,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+08*8,confchroff+$1e,colpal0,pri3,noflip	;u
	SpriteDataB	configx+07*8,configy+08*8,confchroff+$17,colpal0,pri3,noflip	;n
	SpriteDataB	configx+08*8,configy+08*8,confchroff+$0d,colpal0,pri3,noflip	;d

	SpriteDataB	configx+04*8,configy+09*8,conf_s,colpal0,pri3,noflip	;s
	SpriteDataB	configx+05*8,configy+09*8,conf_c,colpal0,pri3,noflip	;c
	SpriteDataB	configx+06*8,configy+09*8,conf_e,colpal0,pri3,noflip	;e
	SpriteDataB	configx+07*8,configy+09*8,conf_n,colpal0,pri3,noflip	;n
	SpriteDataB	configx+08*8,configy+09*8,conf_e,colpal0,pri3,noflip	;e

	SpriteDataB	configx+04*8,configy+010*8,conf_p,colpal0,pri3,noflip	;p
	SpriteDataB	configx+05*8,configy+010*8,conf_o,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+010*8,conf_r,colpal0,pri3,noflip	;r
	SpriteDataB	configx+07*8,configy+010*8,conf_t,colpal0,pri3,noflip	;t
	SpriteDataB	configx+08*8,configy+010*8,conf_0,colpal0,pri3,noflip	;0

	SpriteDataB	configx+04*8,configy+011*8,conf_p,colpal0,pri3,noflip	;p
	SpriteDataB	configx+05*8,configy+011*8,conf_o,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+011*8,conf_r,colpal0,pri3,noflip	;r
	SpriteDataB	configx+07*8,configy+011*8,conf_t,colpal0,pri3,noflip	;t
	SpriteDataB	configx+08*8,configy+011*8,conf_1,colpal0,pri3,noflip	;1

	SpriteDataB	configx+04*8,configy+012*8,conf_p,colpal0,pri3,noflip	;p
	SpriteDataB	configx+05*8,configy+012*8,conf_o,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+012*8,conf_r,colpal0,pri3,noflip	;r
	SpriteDataB	configx+07*8,configy+012*8,conf_t,colpal0,pri3,noflip	;t
	SpriteDataB	configx+08*8,configy+012*8,conf_2,colpal0,pri3,noflip	;2
	
	SpriteDataB	configx+04*8,configy+013*8,conf_p,colpal0,pri3,noflip	;p
	SpriteDataB	configx+05*8,configy+013*8,conf_o,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+013*8,conf_r,colpal0,pri3,noflip	;r
	SpriteDataB	configx+07*8,configy+013*8,conf_t,colpal0,pri3,noflip	;t
	SpriteDataB	configx+08*8,configy+013*8,conf_3,colpal0,pri3,noflip	;3

	SpriteDataB	configx+04*8,configy+014*8,conf_e,colpal0,pri3,noflip	;e
	SpriteDataB	configx+05*8,configy+014*8,conf_x,colpal0,pri3,noflip	;x
	SpriteDataB	configx+06*8,configy+014*8,conf_i,colpal0,pri3,noflip	;i
	SpriteDataB	configx+07*8,configy+014*8,conf_t,colpal0,pri3,noflip	;t

	SpriteDataB	configx+04*8,configy+016*8,conf_p,colpal0,pri3,noflip	;p
	SpriteDataB	configx+05*8,configy+016*8,conf_o,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+016*8,conf_r,colpal0,pri3,noflip	;r
	SpriteDataB	configx+07*8,configy+016*8,conf_t,colpal0,pri3,noflip	;t
	SpriteDataB	configx+08*8,configy+016*8,conf_0,colpal0,pri3,noflip	;0

	SpriteDataB	configx+04*8,configy+017*8,conf_p,colpal0,pri3,noflip	;p
	SpriteDataB	configx+05*8,configy+017*8,conf_o,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+017*8,conf_r,colpal0,pri3,noflip	;r
	SpriteDataB	configx+07*8,configy+017*8,conf_t,colpal0,pri3,noflip	;t
	SpriteDataB	configx+08*8,configy+017*8,conf_1,colpal0,pri3,noflip	;1

	SpriteDataB	configx+04*8,configy+018*8,conf_p,colpal0,pri3,noflip	;p
	SpriteDataB	configx+05*8,configy+018*8,conf_o,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+018*8,conf_r,colpal0,pri3,noflip	;r
	SpriteDataB	configx+07*8,configy+018*8,conf_t,colpal0,pri3,noflip	;t
	SpriteDataB	configx+08*8,configy+018*8,conf_2,colpal0,pri3,noflip	;2

	SpriteDataB	configx+04*8,configy+019*8,conf_p,colpal0,pri3,noflip	;p
	SpriteDataB	configx+05*8,configy+019*8,conf_o,colpal0,pri3,noflip	;o
	SpriteDataB	configx+06*8,configy+019*8,conf_r,colpal0,pri3,noflip	;r
	SpriteDataB	configx+07*8,configy+019*8,conf_t,colpal0,pri3,noflip	;t
	SpriteDataB	configx+08*8,configy+019*8,conf_3,colpal0,pri3,noflip	;3
ConfigSprDataEnd

StereoSprData
	km_datacnt	W,StereoSprData
	SpriteDataB	configx+11*8,configy+08*8,confchroff+$1c,colpal0,pri3,noflip	;s
	SpriteDataB	configx+12*8,configy+08*8,confchroff+$1d,colpal0,pri3,noflip	;t
	SpriteDataB	configx+13*8,configy+08*8,confchroff+$0e,colpal0,pri3,noflip	;e
	SpriteDataB	configx+14*8,configy+08*8,confchroff+$1b,colpal0,pri3,noflip	;r
	SpriteDataB	configx+15*8,configy+08*8,confchroff+$0e,colpal0,pri3,noflip	;e
	SpriteDataB	configx+16*8,configy+08*8,confchroff+$18,colpal0,pri3,noflip	;o
StereoSprDataEnd

MonoralSprData
	km_datacnt	W,MonoralSprData
	SpriteDataB	configx+11*8,configy+08*8,confchroff+$16,colpal0,pri3,noflip	;m
	SpriteDataB	configx+12*8,configy+08*8,confchroff+$18,colpal0,pri3,noflip	;o
	SpriteDataB	configx+13*8,configy+08*8,confchroff+$17,colpal0,pri3,noflip	;n
	SpriteDataB	configx+14*8,configy+08*8,confchroff+$18,colpal0,pri3,noflip	;o
	SpriteDataB	configx+15*8,configy+08*8,confchroff+$1b,colpal0,pri3,noflip	;r
	SpriteDataB	configx+16*8,configy+08*8,confchroff+$0a,colpal0,pri3,noflip	;a
	SpriteDataB	configx+17*8,configy+08*8,confchroff+$15,colpal0,pri3,noflip	;l
MonoralSprDataEnd

	
	ENDC
