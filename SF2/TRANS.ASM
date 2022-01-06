;ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ                                                                         บ
;บ                               StarFox                                   บ
;บ                              ---------                                  บ
;บ                                                                         บ
;บ                           SuperNES version.                             บ
;บ                                                                         บ
;บ                           Argonaut Software.                            บ
;บ                                                                         บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                         บ
;บ  File : trans.asm                                                       บ
;บ                                                                         บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                         บ
;บ  Descr : Transfer loop, etc.                                            บ
;บ                                                                         บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                         บ
;บ  Date created : 15/2/1992                                               บ
;บ                                                                         บ
;ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
;บ                                                                         บ
;บ  Author: Krister Wombell                                                บ
;บ                                                                         บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

	INCPUB	trans

de_jsl	macro	[addr]
;;;	kbug1
	jsl	{addr}
;;;	kbug1
	endm
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------

transfer_l
	a8i16

	lda	framec
	sta	framer
	stz	framec
.notfinished
	lda	trans_flag
	bne	.notfinished

	test_screenmode	twoscreen
	lbne		.normaltrans

;ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
; this is the main game transfer routine for one screen mode
; it runs the drawing of the 3d in parallel with the transfer
; of the double buffer and in parallel with the path strategies
; (and anything else that does a romnastyoff and runs in ram)
;ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
;* MISSION Version *
	lda	#iv_gameirq1_1
	sta	trans_flag	; begin the transfer

	jsl	copydrawlist_l

	jsl	generate_collist_l

	lda	trans_flag
;	printh	check1,dylan

	jsl	begin_3d_display_l

	lda	trans_flag
;	printh	check2,dylan

	jsl	setwindowtabs_l		;kawaguchi
	jsl	find_window_pri_l	;kawaguchi

	jsl	sethvscroll_l		;kawaguchi

;* kawaguchi *
;;;	lda	trans_flag
;;;	printh	<hvscroll irq>,kawaguchi

	jsl	set_horizon_l

	jsl	setvofst_l	; (2/10)kawagoe
	jsl	cc_alart_l

	jsl	bg2horzvertscroll_l

	jsl	set_enemy_cursor_P1_l	; Kawagoe
	jsl	set_player_cursor_P1_l	; Kawagoe

	jsl	parallel_mismap_l	;kawaguchi
;;;;	jsl	draw_Wave_p1_l		;Kawaguchi
;;;;	jsl	do_spritesp1radar_l	;Kawaguchi
	jsl	do_sprites_l		;kawaguchi

	ramnastyoff
	ldx	mapptr
	jsl	newobjs_l
	ramnastyon

	jsl	scaninerts_l


	lda	trans_flag
;	printh	gamecode,dylan

; ฤฤฤฤฤฤฤฤฤฤ debug
;	jsl	finishit_l

	jsl	dostrats1_l
	jsl	dostrats2_l

	lda	trans_flag
;	printh	<Strat finish>,dylan

	jsl	showview1_l

	jsl	finish_3d_display_l

	IFEQ	1	; Turbo sprites test

	ldx	playpt1
	a16
	lda	al_worldx,x
	printd	px
	lda	al_worldz,x
	printd	pz

	a8
	phb
	a8
	lda	#$70
	pha
	plb


	ldx	#m_ts_buffer&WM

	lda	#40
.lp
	pha

	lda	#115
	sta.w	ts_sprite,x
	lda	#32
	sta.w	ts_size,x
	lda	#0
	sta.w	ts_anim,x
	lda	#8
	sta.w	ts_animlimit,x

	a16
	lda	x1
	sta.w	ts_x,x
	clc
	adc	#50
	sta	x1
	lda	z1
	sta.w	ts_z,x
	clc
	adc	#50
	sta	z1
	lda	#0
	sta.w	ts_y,x

	txa
	clc
	adc	#ts_sizeof
	tax
	a8

	pla
	dec	a
	bne	.lp

;	call_mario	mTurboSprites
	plb


	ENDC


;'94/9/26 :comment ni shimashita !!
;	km_cmpcheckgamemode	missionexplain
;	bne	.skipexp
;	jsl	missobj_l		;yajima
;	jsl	kexp_makingplanet_l	;kawaguchi
;.skipexp
	lda	trans_flag
;	printh	<3d finish>,dylan


	lda	bgflags
	beq	.normtt
	jsr	transswap
.normtt

	jmp	.finishtrans

;ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
; this is the old trans loop

.normaltrans
	test_screenmode	3dglasses
	beq	.twoscreen
	lda	#iv_gameirq1_1
	bra	.onescreen

.twoscreen	lda	#iv_gameirq1
.onescreen	sta	trans_flag		;start screen transferring

; IRQ #1 & #2 are occurring
; meanwhile:

	jsl	generate_collist_l
	

	jsl	begin_3d_display2_l

; insert anything here that needs to have the world matrix and view set up
; for screen #2

	jsl	set_player_cursor_P2_l	; Kawagoe


;;;;	jsl	draw_Wave_p2_l		;kawaguchi

	jsl	setwindowtabs_l		;kawaguchi
	jsl	find_window_pri_l	;kawaguchi

	jsl	do_sprites_l		;kawaguchi

;	jsl	setvofst_l	; SAISYO NO BASYO

	jsl	sethvscroll_l		;kawaguchi

	test_screenmode	3dglasses
	bne	.stratsnothere2

	bit	#sm_twoscreen
	bne	.stratsnothere2

;--	jsl	dostrats1_l
;--	jsl	dostrats2_l

.stratsnothere2

	jsl	dostrats1_l

	jsl	set_enemy_cursor_P2_l	; Kawagoe

	jsl	set_horizon_l

	jsl	setvofst_l	; (2/10)kawagoe

	jsl	finish_3d_display2_l
	jsl	copydrawlist_l

	
.endirq2
	test_screenmode	onescreen
	beq	.tswait
.oswait
; wait until the first 3 irq's have completed in onescreen mode

	lda	trans_flag
	beq	.no2ndtrans
	cmp	#iv_gameirq4_1
	bne	.oswait
	bra	.no2ndtrans


; wait to initiate transfer of player 2's bg in twoscreen mode
.tswait
	lda	trans_flag
	bne	.tswait

	lda	#iv_gameirq3
	sta	trans_flag

.no2ndtrans
; IRQ #3 & #4 are occuring
; meanwhile:
	jsl	bg2horzvertscroll_l
;;--	call_mario	mclrbitmap1

	jsl	begin_3d_display1_l

; insert anything here that needs to have the world matrix and view set up
; for screen #1

	jsl	set_player_cursor_P1_l	; Kawagoe

;;;;	jsl	draw_Wave_p1_l		;Kawaguchi
;;;;	jsl	do_spritesp1radar_l	;Kawaguchi

	lda	screenmode
	bit	#sm_onescreen
	bne	.stratsnothere

;--	jsl	dostrats1_l
	jsl	dostrats2_l

	jsl	 set_enemy_cursor_P1_l	; Kawagoe

.stratsnothere
	jsl	finish_3d_display1_l

	lda	screenmode
	bit	#sm_3dglasses
	bne	.dontdoview2

	a8
	ldx	mapptr
	jsl	newobjs_l
	jsl	showview2_l
	jsl	copydrawlist_l
.dontdoview2

	jsl	scaninerts_l

.endirq4	lda	trans_flag
	bne	.endirq4

	lda	bgflags
	beq	.normalspl
	jsr	transswap
.normalspl
	lda	screenmode
	bit	#sm_3dglasses
	bne	.clritnow
	bit	#sm_twoscreen
	beq	.nottwoscreen
.clritnow
;;--	call_mario	mclrbitmap2
.nottwoscreen


.finishtrans
;------------------------------------------------------------
;* sound port2 value set *
;'94/9/4 :by kawaguchi
	a8
	km_bitcheckgameflag	battle
	bne	.noset_port2
	km_setvar	sdport2,sdport2tmp
	km_setvar	sdchkno2,sdchkno2tmp
	km_stxvar	sdchkptr2,sdchkptr2tmp
	km_stxvar	sdchklen2,sddist2

;* enemy ga touroku sarete iruka check *
	a16
	lda	sddist2
	inc	a
	bne	.enemy_exist
	km_setval	sdport2,0
	km_setval	sdchkno2,0
	km_stxval	sdchkptr2,0
.enemy_exist
.noset_port2
	a8
;------------------------------------------------------------
	jsl	set_kscreen_l		;kawaguchi
	jsl	set_cockpit_l
	jsl	DisplayMessages_l	;player no kao&mes hyouji
	jsl	main_gameclear_l	;YAJIMA
	jsl	showtechdata_l		; credits test

	lda	trans_flag
;	printh	<ALL finish>,dylan

	a8
	lda	framec
	sta	framerate
	lda	framecount
	clc
	adc	framer
	sta	framecount
	inc	frames
	lda	framecount
	IFEQ	PAL
	cmp	#60		; per second
	ELSEIF
	cmp	#50		; per second
	ENDC
	bcc	.noreset
	lda	frames
	sta	framesb
	stz	frames
	lda	framecount
	sec
	IFEQ	PAL
	sbc	#60
	ELSEIF
	sbc	#50
	ENDC
	sta	framecount
.noreset
	lda	framesb
	printd	< FPS >

	IFEQ	1	; frame rate test

	phb
	a8
	lda	#$7e
	pha
	plb
	km_testkeydown	X
	beq	.nox
	lda	#1
	sta	temptempflag
	bra	.oktemp

.nox	lda	#0
	sta	temptempflag
.oktemp
	plb

	ENDC

	IFEQ	1	; Alien count display

	ai16
	stz	x1
	lda	allst
	beq	.empty
.count
	tax
	inc	x1
	lda	_next,x
	bne	.count

.empty
	a8i16
	lda	x1
	printd	<Num Aliens>

	ENDC

	IFNE	pathcount	; path command count check

	a16
	lda.l	pathcommandcount
	printd	<Path commands>
	lda	#0
	sta.l	pathcommandcount
	a8

	ENDC

	IFNE	blockmap_dbg

	jsl	showblockmap_l		; debugging

	ENDC

;;	a8
;;	lda.l	CurrentArea
;;	printh	CArea,YAMADA
;;	lda.l	SecondaryArea
;;	printh	SArea,YAMADA

	IFEQ	1

	a8i16
	phb
	lda	#$7e
	pha
	plb

	a16
	ldx	playpt1
	lda	al_worldx,x
	blockmap_scale_x
	sta	x1
	blockmap_scale_mask
	sta	y1
	lsr	x1
	lsr	x1
	lsr	x1
	lda	al_worldz,x
	blockmap_scale_z
	clc
	adc	x1
	tax
	lda	solidblockmap&WM,x
	and	y1
	printb	Mask
	
	a8
	plb

	ENDC

	IFEQ	1
	phb
	a8
	lda	#$7e
	pha
	plb

	km_testkeydown	X
	beq	.notpressed
	a16
	lda	#16
	jsl	alloc_l
.notpressed
	jsl	avail_l
	a16
	printd	<Ram Available>
	a8
	plb

	ENDC

	IFEQ	1
	ai16
	lda	#(test_slo-xroutines+xrstart)&WM
	sta.l	m_pntptr
	lda	#15
	sta.l	m_bigx
	lda	#-5
	sta.l	m_bigz
	a8
	call_mario	MClosestLine
	a16
	lda.l	m_pntptr
	printd	Distance
	lda.l	m_bigx
	printd	newx
	lda.l	m_bigz
	printd	newz

	ENDC

	IFNE	polllaginfo	; print xroutines debug info
	a16
	lda.l	xroutines
	printh	<Poll lag lo>,dylan
	lda.l	xroutines+2
	printh	<Poll lag hi>,dylan

	lda	#0
	sta.l	xroutines
	sta.l	xroutines+2
	a8

	ENDC

;*** Debug Mode Display ***
	km_acmpkeydown	TLR
	bne	.notmodechange
	km_testjoypad	X
	beq	.notmodechange
	km_eorgameflag	debug	;debug mode FLAG no kirikae
.notmodechange
;debug mode ka inakawa <displaydebugging_l> routine no nakade set shitearu.
	jsl	displaydebugging_l

	ifeq	1
	lda	checkirq1
	printd	< IRQ1 >
	lda	checkirq2
	printd	< IRQ2 >
	lda	checkirq3
	printd	< IRQ3 >
	lda	checkirq4
	printd	< IRQ4 >
	lda	checkirq
	printd	< Mario Wait IRQ >
	endc
	rtl

;========================================================
;========================================================
;========================================================
;========================================================
;========================================================
;======================= OBSOLETE =======================
;========================================================
;========================================================
;========================================================
;========================================================


	IFEQ	1


	jsl	getview_l

;	jsl	dosounds_l
;	jsl	palgoto_l
	jsl	showview_ram_l
	jsl	copydrawlist_l
;	jsl	do_sprites_l
;	jsr	calcmeters


	a8
.twait	lda	transbmp1
	beq	.twait

	lda	bgflags
	beq	.normal
	jsr	transswap
.normal
	jsl	clronehalf_l

.twait2	lda	transbmp1
	cmp	#2
	bne	.twait2
	stz	transbmp1

	ai16
	lda	dotsflag
	sta.l	m_dotsorstars
	beq	.skip
	jsl	mshowgrid_l
.skip	jsl	do_3d_display_l

	jsr	do_window_wipe

	a8
	lda	doingwipe
	beq	.nd3
	inc	noirqbit3
.nd3
	a8
	lda	framec
	sta	framerate
	lda	framecount
	clc
	adc	framer
	sta	framecount
	inc	frames
	lda	framecount
	cmp	#60		; per second
	bcc	.noreset
	lda	frames
	sta	framesb
	stz	frames
	lda	framecount
	sec
	sbc	#60
	sta	framecount
.noreset	
	printd	1,1





	ifne	mario_stats3d

	lda.l	m_numshapes		; shapes in drawlist
	printd	25,2

	lda.l	m_shapes_notdrawn+1	; shapes rejected by new quick tests
	printd	21,3
	lda.l	m_shapes_notdrawn	; shapes rejected after rot\proj pnts
	printd	25,3

	lda.l	m_polys_drawn
	printd	25,4

	lda.l	m_lines_drawn
	printd	25,5

	lda.l	m_points_done+1		; I've seen >600 pnts being rotated!
	printd	21,6
	lda.l	m_points_done
	printd	25,6

	lda.l	m_visis_done+1
	printd	21,7
	lda.l	m_visis_done
	printd	25,7

	lda.l	m_polys_clip2d
	printd	25,8
		
	lda.l	m_polys_clip3d
	printd	25,9

	endc




;
;	lda	gameflags2
;	and	#gf2_ingame
;	printd	25,2
;
;	lda	pshipflags2
;	and	#psf2_playerHP0
;	printd	25,3
;
;	lda	thatfunnyolevalue2
;	printd	25,4
;
;	lda	thatfunnyolevalue
;	printd	22,4

;	a8
;	lda	specials_dead
;	printb	1,1
;	lda	specialobjtotal
;	printb	1,2

;	a8i16
;	sprint	0,5
;	ldx	#0
;.lpdfd	lda	sdport3,x
;	phx
;	jsl	printb_l
;	plx
;	inx
;	cpx	#16
;	bne	.lpdfd

;	a8
;	lda	port1bolox
;	lda	pshipflags3
;	and	#psf3_enginesnd
;	printb	0,1
;	lda	port1bolox
;	printb	0,2
;	lda	playersndflag
;	printb	0,3
;	lda	apu_port1
;	printb	0,4

;	lda	circleanim
;	printb
	rtl

	ENDC

	shorta
	longi
transswap_l	jsr	transswap
	rtl
transswap
	php
	waittrans

	a8			;DO BG CHANGES ETC.
	lda	bgflags
	bit	#bgf_restart
	beq	.nores
	jsl	restart_l
.nores
	ai16
	lda	bgflags
	bit	#bgf_bg
	beq	.noreq

	lda	showmap
	cmp	#bitmap1_dbl
	bne	.notyet

	jsl	dobgreq_l

;* bug (kawaguchi) *
	IFEQ	1
	a8
	lda	#0
	sta.l	$2121
	sta.l	$2122
	sta.l	$2122
	a16
	ENDC
.noreq
	ai16
	lda	bgflags
	bit	#bgf_info
	beq	.noreqinfo
	jsl	setbginforeq_l
.noreqinfo
	a8
	lda	bgflags
	and	#~(bgf_info+bgf_bg+bgf_restart)
	sta	bgflags

	stz	trans_flag
.notyet
	plp
	rts



;-----------------------------------------------------------------------
	shorta
	longi
; make copy of screen #1's view while strategies are done
copyview3d
	IFEQ	1

	php

	lda	screenmode
	bit	#sm_3dglasses
	beq	.nocopy

	a16
	ldy	#viewblk1

	lda.w	al_sword1,y
	sta	tempview
	lda.w	al_sword2,y
	sta	tempview+2

	lda.w	al_worldx,y
	sta	tempview+4

	lda.w	al_worldy,y
	sta	tempview+6

	lda.w	al_worldz,y
	sta	tempview+8

	lda.w	al_rotx,y
	sta	tempview+10
	lda.w	al_roty,y
	sta	tempview+12
	lda.w	al_rotz,y
	sta	tempview+14


	a8
	lda.w	al_sbyte4,y
	sta	tempview+16
	
.nocopy
	plp

	ENDC


	rts


; copy the copy of screen 1's view intro screen 2's view after the strats
; have finished
; this is only done for the red/green 3d glasses
	shorta
	longi
copy3dview

	IFEQ	1

	php

	lda	screenmode
	bit	#sm_3dglasses
	lbeq	.nocopy

	a16
	ldx	#viewblk2

	lda	tempview
	sta	al_sword1,x
	lda	tempview+2
	sta	al_sword2,x

	lda	tempview+4
	sta	al_worldx,x

	lda	tempview+6
	sta	al_worldy,x

	lda	tempview+8
	sta	al_worldz,x

	lda	tempview+10
	sta	al_rotx,x
	lda	tempview+12
	sta	al_roty,x
	lda	tempview+14
	sta	al_rotz,x


	a8
	lda	tempview+16
	sta	al_sbyte4,x

; right eye manipulation
	a16
	lda	al_worldx,x
	clc
	adc	tempview+22
	clc
	adc	tempview+22
	sta	al_worldx,x

	lda	al_roty,x
	sec
	sbc	tempview+20
	sec
	sbc	tempview+20
	sta	al_roty,x

; left eye manipulation
	ldx	#viewblk1
	a16
	lda	al_worldx,x
	sec
	sbc	tempview+22
	sta	al_worldx,x

	lda	al_roty,x
	clc
	adc	tempview+20
	sta	al_roty,x

	testjoypad2	TLEFT
	beq		.nodec

	inc	tempview+22
.nodec
	testjoypad2	TRIGHT
	beq		.noinc

	dec	tempview+22

.noinc

	testjoypad2	LEFT
	beq		.nodec2

	lda	tempview+20
	clc
	adc	#128
	sta	tempview+20
.nodec2
	testjoypad2	RIGHT
	beq		.noinc2

	lda	tempview+20
	sec
	sbc	#128
	sta	tempview+20

.noinc2


.nocopy
	plp

	ENDC

	rts



;-----------------------------------------------------------------------
calcbg2voffsets_l
	jsr	calcbg2voffsets
	rtl
calcbg2voffsets
	IFEQ	1
	ai16
	stz	dobg2
	lda	dovofs
	and	#$ff
	bne	.do
	rts
.do	longa
 
	lda	dozrot
	and	#$ff
	bne	.dorotz
	lda	#0
	bra	.gotzrot
.dorotz
	lda	plrotz		;max is $d00
	bmi	.neg
.gotzrot
	swa
	and	#7
	asl	a
	tax
	lda.l	bg2ptrs,x
	cmp	lastrot
	bne	.set
	rts
.set	sta	lastrot
	tax
	ldy	#0
.lp	lda	0,x
	clc
	adc	bg2scroll
	sta.w	bg2voffsbak,y
	iny
	iny
	inx
	inx
	cpy	#64
	bne	.lp
	lda	#1
	sta	dobg2
	rts

	longa
	longi
.neg
	nega
	swa
	and	#7
	asl	a
	tax
	lda.l	bg2ptrs,x
	cmp	lastrot
	bne	.set2
	rts
.set2	sta	lastrot
	clc
	adc	#62
	tax
	ldy	#0
.lp2	lda	0,x
	clc
	adc	bg2scroll
	sta.w	bg2voffsbak,y
	dex
	dex
	iny
	iny
	cpy	#64
	bne	.lp2
	lda	#1
	sta	dobg2
	ENDC
	rts


	shorta
	longi
dmabg2voffsets_l
	php
	a8i16
	jsr	dmabg2voffsets
	plp
	rtl
dmabg2voffsets
	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	ldx	#bg2voffsbak
	stx	ch0addra1tl
	stz	ch0atbank
	ldx	#(bg2offsets+32)&WM
	stx	vmaddl
	ldx	#64
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen
	rts


;------------------------------------------------------------------------------
clronehalf_l
; clears one half of the 3d screen
	php
	a8i16
	lda	#mclrbitmaps2>>16
	ldx	#mclrbitmaps2&WM
	jsl	runmario_l
	plp
	rtl


;------------------------------------------------------------------------------
clrotherhalf_l
; clears one half of the 3d screen
	php
	a8i16
	lda	#mclrbitmaps3>>16
	ldx	#mclrbitmaps3&WM
	jsl	runmario_l
	plp
	rtl


;------------------------------------------------------------------------------
	IFEQ	1
do_hpositions_l
	jsr	do_hpositions
	rtl
do_hpositions
	ai16
	lda	dohofs
	and	#$ff
	bne	.ok
	rts
.ok	ldx	hposjmp
	jmp	(.jmp,x)
.jmp	dw	rotplanet&WM
	dw	tunnelgrad&WM
	dw	tunnelgrad&WM
	dw	waterhofs&WM
	dw	tunnelgrad&WM
	dw	nograd&WM
	dw	bhole&WM
	dw	bholescaledown&WM

	longa
bhole	lda	viewposx
	sta.l	m_viewposx
	a8
	lda	#mbhole>>16
	ldx	#mbhole&WM
	jsl	runmario_l
	rts

	longa
bholescaledown
;	lda.l	bholescaleval
;	cmp	#512
;	beq	.sk
;	inc	a
;	sta.l	bholescaleval
;.sk	sta.l	m_y1
;	lda	viewposx
;	sta.l	m_viewposx
;	a8
;	lda	#mbholescaledown>>16
;	ldx	#mbholescaledown&WM
;	jsl	runmario_l
;	rts

	longa
nograd	lda	viewposx
	sta.l	m_viewposx
	a8
	lda	#mnograd>>16
	ldx	#mnograd&WM
	jsl	runmario_l
	rts

	longa
waterhofs	lda	viewposx
	sta.l	m_viewposx
	a8
	lda	#mwibbletunnel>>16
	ldx	#mwibbletunnel&WM
	jsl	runmario_l
	rts

	longa
rotplanet	lda	plrotz
	sta.l	m_viewposx
	ldx	playpt
	lda	al_worldx,x
	sta.l	m_y1
	a8
	lda	#mrotplanet>>16
	ldx	#mrotplanet&WM
	jsl	runmario_l
	rts

	longa
tunnelgrad	lda	viewposx
	sta.l	m_viewposx
	a8
	lda	#mtunnelgrad>>16
	ldx	#mtunnelgrad&WM
	jsl	runmario_l
	rts



;------------------------------------------------------------------------------
dmahpos_l	jsr	dmahpos
	rtl
dmahpos	ai8
.vw	lda	slhvr		;wait for screen off
	ldx	ophctr
	lda	ophctr
	and	#1
	bne	.vw
	cpx	#90
	bcc	.vw
	cpx	#100
	bcs	.vw

	i16
	disable
	ldx	hdmabg2hofs2
	stx	wmaddl
	stz	wmaddh
	lda	#wmdata&$ff
	sta	ch0addrb
	ldx	#(bg_scrollbuffer)&WM
	stx	ch0addra1tl
	lda	#(bg_scrollbuffer)>>16
	sta	ch0atbank
	ldx	#224*3
	stx	ch0dataddrl
	stz	ch0params
	lda	#1
	sta	mdmaen
	enable
	rts

	ENDC

;------------------------------------------------------------------------------
calcmeters	a8i16
	ldx	pcboxobj_b
	lda	al_HP,x
	bpl	.ok
	lda	#0
.ok	sta.l	m_damage

	IFEQ	1
boost	lda.l	m_boostcnt
	beq	.end
	lda.l	m_boostanim
	dec	a
	dec	a
	bpl	.ok
	lda	#0
	sta.l	m_boostcnt
.ok	sta.l	m_boostanim
	bra	.draw
.end	lda.l	m_boostanim
	cmp	#40
	beq	.draw
	lda.l	m_boostanim
	inc	a
	sta.l	m_boostanim
	and	#15
	beq	.draw
.draw
	rts


	ENDC
;------------------------------------------------------------------------------
;'94/10/17 :kawaguchi ga krister no routine wo comment shimashita !!!!

	Ifeq	1
init_wipe	macro
\1_circle	equ	*-circletab
	db	ct_init_wipe
	dw	\1&0ffffh
	endm

do_wipe	macro
	db	ct_wipe_do
	endm

circlegoto	macro
	db	ct_circle_goto
	dw	\1-circletab
	endm

wipeend	macro
	db	ct_wipe_end
	endm

ct_circle_init		equ	0
ct_circle_rad		equ	2
ct_circle_blue		equ	4
ct_circle_green	equ	6
ct_circle_red		equ	8
ct_circle_endifblue	equ	10
ct_circle_endifgreen	equ	12
ct_circle_endifred	equ	14
ct_circle_endifradius	equ	16
ct_circle_end		equ	18
ct_circle_loop		equ	20
ct_set_blue		equ	22
ct_set_green		equ	24
ct_set_red		equ	26
ct_circle_exit		equ	28
ct_set_rad		equ	30
ct_set_affect		equ	32
ct_init_wipe		equ	34
ct_wipe_do		equ	36
ct_circle_goto		equ	38
ct_wipe_end		equ	40

do_circle_explosion_l
	jsr	do_circle_explosion
	rtl


do_circle_explosion
	a8
	stz	doawipe
	ai16
	ldx	circleanim
	bne	circle_com
	a8
	dealloc_window	circle,1
	stz	doingwipe
	rts
circle_com	a16
	lda.l	circletab,x
	and	#$ff
	txy
	tax
	jmp	(circlejmp,x)
circlejmp	dw	circle_init&WM
	dw	circle_rad&WM
	dw	circle_blue&WM
	dw	circle_green&WM
	dw	circle_red&WM
	dw	circle_endifblue&WM
	dw	circle_endifgreen&WM
	dw	circle_endifred&WM
	dw	circle_endifradius&WM
	dw	circle_end&WM
	dw	circle_loop&WM
	dw	set_blue&WM
	dw	set_green&WM
	dw	set_red&WM
	dw	circle_exit&WM
	dw	set_rad&WM
	dw	set_affect&WM
	dw	wipe_init&WM
	dw	wipe_do&WM
	dw	circle_goto&WM
	dw	wipeend_do&WM

	longa
	longi
circle_goto	tyx
	lda.l	circletab+1,x
	sta	circleanim
	tax
	jmp	circle_com

	longa
	longi
circle_init	tyx
	stz	circlerad
	stz	circledestrad
	a8
	stz	circleblue
	stz	circlesrcblue
	stz	circlered
	stz	circlesrcred
	stz	circlegreen
	stz	circlesrcgreen
	lda	#1+2+4+32
	sta	circleaff
	inx
	stx	circleanim
	jmp	circle_com

	longa
	longi
circle_rad	tyx
	lda.l	circletab+1,x
	sta	circledestrad
	lda.l	circletab+3,x
	sta	circlespeed
	lda.l	circletab+5,x
	sta	circlespeedadd
	inx
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	circle_com

	longa
	longi
circle_blue	tyx
	a8
	lda.l	circletab+1,x
	sta	circleblue
	lda.l	circletab+2,x
	sta	circleblueframe
	sta	circleblueframesrc
	lda.l	circletab+3,x
	sta	circlebluespeed
	inx
	inx
	inx
	inx
	jmp	circle_com
	longa
	longi
circle_green
	tyx
	a8
	lda.l	circletab+1,x
	sta	circlegreen
	lda.l	circletab+2,x
	sta	circlegreenframe
	sta	circlegreenframesrc
	lda.l	circletab+3,x
	sta	circlegreenspeed
	inx
	inx
	inx
	inx
	jmp	circle_com
	longa
	longi
circle_red	tyx
	a8
	lda.l	circletab+1,x
	sta	circlered
	lda.l	circletab+2,x
	sta	circleredframe
	sta	circleredframesrc
	lda.l	circletab+3,x
	sta	circleredspeed
	inx
	inx
	inx
	inx
	jmp	circle_com
	longa
	longi
circle_endifblue
	tyx
	a8
	lda.l	circletab+1,x
	cmp	circlesrcblue
	lbne	circlecomend
	inx
	inx
	stx	circleanim
	jmp	circle_com
	longa
	longi
circle_endifgreen
	tyx
	a8
	lda.l	circletab+1,x
	cmp	circlesrcgreen
	lbne	circlecomend
	inx
	inx
	stx	circleanim
	jmp	circle_com
	longa
	longi
circle_endifred
	tyx
	a8
	lda.l	circletab+1,x
	cmp	circlesrcred
	lbne	circlecomend
	inx
	inx
	stx	circleanim
	jmp	circle_com
	longa
	longi
circle_endifradius
	tyx
	lda.l	circletab+1,x
	cmp	circlerad
	lbne	circlecomend
	inx
	inx
	inx
	stx	circleanim
	jmp	circle_com

	longa
	longi
circle_end	stz	circleobj
	stz	circleanim
	stz	circlerad
	jmp	circlecomend
	longa
	longi
circle_loop	tyx
	inx
	stx	circleanim
	jmp	circlecomend

	longa
	longi
set_blue	tyx
	a8
	lda.l	circletab+1,x
	sta	circlesrcblue
	inx
	inx
	jmp	circle_com
	longa
	longi
set_green	tyx
	a8
	lda.l	circletab+1,x
	sta	circlesrcgreen
	inx
	inx
	jmp	circle_com
	longa
	longi
set_red	tyx
	a8
	lda.l	circletab+1,x
	sta	circlesrcred
	inx
	inx
	jmp	circle_com

	longa
	longi
circle_exit	tyx
	inx
	stx	circleanim
	jmp	circlecomend

	longa
	longi
set_rad	tyx
	lda.l	circletab+1,x
	sta	circlerad
	inx
	inx
	inx
	jmp	circle_com

	longa
	longi
set_affect	tyx
	a8
	lda.l	circletab+1,x
	sta	circleaff
	inx
	inx
	jmp	circle_com

circlecomend
	a16
	lda	circlerad
	cmp	circledestrad
	beq	.donerad
	bcc	.addrad
	sec
	sbc	circlespeed
	cmp	circledestrad
	bcs	.donerad
	lda	circledestrad
	bra	.donerad
.addrad	clc
	adc	circlespeed
	cmp	circledestrad
	bcc	.donerad
	lda	circledestrad
.donerad	cmp	#0
	bne	.radok5
	lda	#1
.radok5	sta	circlerad
	sta.l	m_rotx

	lda	circlespeed
	beq	.radok
	clc
	adc	circlespeedadd
	sta	circlespeed
.radok

	a8
	lda	circleblueframe
	dec	a
	sta	circleblueframe
	bne	.blueskip
	lda	circleblueframesrc
	sta	circleblueframe
	lda	circlesrcblue
	cmp	circleblue
	beq	.blueok
	bcc	.blueadd
	sec
	sbc	circlebluespeed
	bpl	.bluepos
	lda	#0
.bluepos	cmp	circleblue
	bcs	.blueok
	lda	circlesrcblue
	bra	.blueok
.blueadd	clc
	adc	circlebluespeed
	cmp	circleblue
	bcc	.blueok
	lda	circlesrcblue
.blueok	sta	circlesrcblue
.blueskip
	lda	circlegreenframe
	dec	a
	sta	circlegreenframe
	bne	.greenskip
	lda	circlegreenframesrc
	sta	circlegreenframe
	lda	circlesrcgreen
	cmp	circlegreen
	beq	.greenok
	bcc	.greenadd
	sec
	sbc	circlegreenspeed
	bpl	.greenpos
	lda	#0
.greenpos	cmp	circlegreen
	bcs	.greenok
	lda	circlesrcgreen
	bra	.greenok
.greenadd	clc
	adc	circlegreenspeed
	cmp	circlegreen
	bcc	.greenok
	lda	circlesrcgreen
.greenok	sta	circlesrcgreen
.greenskip
	lda	circleredframe
	dec	a
	sta	circleredframe
	bne	.redskip
	lda	circleredframesrc
	sta	circleredframe
	lda	circlesrcred
	cmp	circlered
	beq	.redok
	bcc	.redadd
	sec
	sbc	circleredspeed
	bpl	.redpos
	lda	#0
.redpos	cmp	circlered
	bcs	.redok
	lda	circlesrcred
	bra	.redok
.redadd	clc
	adc	circleredspeed
	cmp	circlered
	bcc	.redok
	lda	circlesrcred
.redok	sta	circlesrcred
.redskip



	a16
	ldx	circleobj		; get the centre of the screen
	beq	.default
	lda	#0		; LEAVE THIS FOR MERGE (giles)
	jsl	rotproj_l
	lda	xs
	clc
	adc	#((32-gameNum_col)/2)*8	; centre of real screen
	sta	xs		; store it back for later use
	sta.l	m_bigx
	lda	ys
	clc
	adc	#gameStRow*8	; centre of real screen
	sta.l	m_bigy
	bra	.continue
.default	lda	#128
	sta.l	m_bigx
	sta	xs
	lda	#112
	sta.l	m_bigy
.continue

	a8
	alloc_window circle,1		;allocate a window
	stz	wm_coldata,x
	lda	circlesrcblue
	sta	wm_coldata_b,x
	lda	circlesrcgreen
	sta	wm_coldata_g,x
	lda	circlesrcred
	sta	wm_coldata_r,x
	lda	#%00010000
	sta	wm_cgswsel,x
	lda	circleaff
	sta	wm_cgadsub,x
	stz	wm_ts,x

	lda	#mcalc_circle>>16
	ldx	#mcalc_circle&WM
	jsl	runmario_l


copywh0wh1	a8
	phb
	lda	#$7e
	pha
	plb

	ldx	#191*2
	ldy	#191*3+3
	lda	whichcircle
	beq	.lp2
.lp	lda.l	m_circlebuf,x
;	sta.w	(xhdma_wh0wh1_1+2)&WM,y
	lda.l	m_circlebuf2,x
;	sta.w	(xhdma_wh0wh1_1+1)&WM,y
	dey
	dey
	dey
	dex
	dex
	bpl	.lp
	plb
	rts
.lp2	lda.l	m_circlebuf,x
;	sta.w	xhdma_wh0wh1_2+2,y
	lda.l	m_circlebuf2,x
;	sta.w	xhdma_wh0wh1_2+1,y
	dey
	dey
	dey
	dex
	dex
	bpl	.lp2
	plb
	rts




circletab
	db	0
	initcircle	fillscreen		;FILLSCREEN
	radiusto	200,4
	blueto		31,3
	greento		31,3
	redto		31,3
	setblue		14
	setgreen	14
	setred		14
	circleloop
	circleendif	radius,200
	blueto		0,1,2
	greento		0,1,2
	radiusto	500,4
	circleloop
	circleendif	blue,0
	redto		0,1,2
	circleloop
	circleendif	red,0
	circleend

	initcircle	smartbomb		;SMART BOMB
	setrad		297
	setblue		28
	setgreen	28
	setred		28
	circleexit
	setrad		0

	radiusto	9,9
	blueto		31,7
	greento		31,15
	redto		31,3
	setblue		28
	setgreen	28
	setred		28
	circleexit
	radiusto	135,9
	redto		0,1,2
	circleloop
	circleendif	radius,135
	radiusto	297,9
	blueto		0,1
	greento		0,1
	circleloop
	circleendif	green,0
	circleend

	initcircle	whitefillscreen		;WHITE FILL SCREEN
	radiusto	197,18,-1
	blueto		31,1
	greento		31,1
	redto		31,1
	setblue		14
	setgreen	14
	setred		14
	circleloop
	circleendif	radius,171
	blueto		0,1
	greento		0,1
	circleloop
	circleendif	blue,0
	radiusto	10,4
	redto		0,1
	circleloop
	circleendif	radius,0
	circleend

	initcircle	redfillscreen		;RED FILL SCREEN
	radiusto	197,18,-1
	redto		31,1
	setred		14
	circleloop
	circleendif	radius,300
	circleend

	initcircle	laststage		;FILLSCREEN
	circle_aff	2+32
	radiusto	200,4
	blueto	31,3
	greento	31,3
	redto	31,3
	setblue	14
	setgreen	14
	setred	14
	circleloop
	circleendif	radius,200
	blueto	0,1,2
	greento	0,1,2
	circleloop
	circleendif	blue,0
	redto	0,1,2
	circleloop
	circleendif	red,0
	circleend

	init_wipe	mroundwipefill
	do_wipe
.lp	init_wipe	mwipefill
	do_wipe
	circlegoto	.lp
	wipeend

	init_wipe	mscramwipe
	do_wipe
	wipeend

	init_wipe	mroundwipeclear
	do_wipe
	wipeend

	init_wipe	mstarwipe
	do_wipe
	wipeend



wipe_init	tyx
	a16
	lda.l	circletab+1,x
	sta	wintabptr
	inx
	inx
	inx
	stx	circleanim
wipe_do	a8
	inc	doawipe
	rts

	longa
	longi
wipeend_do	stz	circleanim
	a8
;	dealloc_window wipe,1
	rts



do_window_wipe_l
	jsr	do_window_wipe
	rtl
do_window_wipe
	a8
	lda	doawipe
	bne	.do
	rts
.do
	a16
	lda	wintabptr
	sta.l	m_wintabptr
	call_mario mbumwipe
	lda.l	m_wintabptr
	sta	wintabptr

	a8
	lda	#1
	sta	doingwipe


;	alloc_window wipe,1		;allocate a window
	lda.l	m_winwbglog
	sta	wm_wbglog,x

	a16
	lda	wintabptr
	cmp	#1
	bne	.ok
	inc	circleanim
.ok
	a8
	jmp	copywh0wh1



calcbgscroll_l
	phy
	php
	i8
	

	a16
	lda		outvx
	asra
	asra
	asra
	asra
	asra
	asra
	sta	tpa
	asra
	clc
	adc	tpa
	nega

	ldy	nomaxbg2Yscroll
	bne	.nmin

	cmp	#232
	bmi	.nmax
	lda	#232
.nmax

	cmp	#-56
	bpl	.nmin
	lda	#-56
.nmin

	clc
	adc		bg2Yscroll
	and		#511
	sta		bg2scroll
	stz		lastrot

	lda		outvy
	sec
	sbc		player_turnrot
	asra	
	asra	
	asra	
	asra	
	asra
	clc
	adc		bg2Xscroll
	sta.l		m_scrollxoff
	a8

	plp
	ply
	rtl
	ENDC

;'94/10/17 :kawaguchi ga krister no routine wo comment shimashita !!

