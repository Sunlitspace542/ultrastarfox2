safeinidisptop	equ	1

	incpub	main


initialise_l

	php
	a8

	lda	#40
	sta	fox		; hack to allow check for fox's hp
	sta	frog
	sta	bunny
	sta	cock
	sta	pepper
	sta	andorf
;========================== kawaguchi params ==============================
	shorta
	i16
	phb
	db7e
;* game (1p) continue *
	ifeq	kexplain
	km_setmistotalflag	explain1
	elseif
	km_clrmistotalflag	explain1
	endc
;* Mission Map Saisyo no BGM Sound *
	km_setval	kw_mmBGM,kbgm_stg1
;* player HP *
	jsl	playerstatus_init_l
	
;* hdma table ( for window) (!! NOT !! HV-SCROLL)*
	km_stxval	hdmawindowon,$FF00
	km_stxval	hdmawindowon+2,$FF00
	km_stxval	hdmawindowoff,$0001
	km_stxval	hdmawindowoff+2,$0001
	plb
;=====================================================================
	jsl	playerstart_init_l
	jsl	initplanets_l

	ai16
	stz	specialobjtotal

;	lda	#allcolscru&WM		;uncrunch colours and copy up
;	sta.l	m_enddata
;	lda	#$1000
;	sta.l	m_decaddr
;	lda	#0
;	sta.l	m_decoffset
;	a8
;	lda	#allcolscru>>16
;	sta.l	m_enddatabnk
;	lda	#mdecrunch>>16
;	ldx	#mdecrunch&WM
;	jsl	runmario_l

;	a16
;	ldx	#0
;.lp	lda.l	$701000,x
;	sta.l	gamepalettes,x
;	inx
;	inx
;	cpx	#__totpallen
;	bne	.lp

	a8
	km_setgameflag	debug

	fast

	plp
	rtl

initgame_l
	php
	phb
;-- db 0 ---
	a8
	lda	#0
	pha
	plb

	disable

	a8
	stz	hdmaen
	lda	#$80
	setinidisp1
	sta	inidisp
	stz	fadedir
	stz	fade
	lda	#0
	sta.l	cockpit_transferred

;* kono wait wa 1 fram matte h-dma ga subete owaruno wo matu !! *
	waitdma	110
	waitdma	100	; turn off screen and wait for sync

	lda	#mmaxdust
	sta	stardustkazu

;* irq flag clear *
;;;;	stz	trans_flag
	stz	trans_flag2

	ai16
	lda	#MAXMAPRANGE
	sta.l	maxmaprangestore

	lda	#-10000
	sta	stardustheight

	lda	#1
	sta.l	m_particlesON

	stz	olslptr
	stz	olsobjs_num
	stz	olsobj_dead
	stz	levelfinished
	stz	circleanim
	stz	mapcnt
	stz	lastplayz
	stz	lastzchange
	stz	viewposz	; reset map position
	lda	#1
	sta.l	m_meters
	stz	levelfinished
;------------------------------------------------------------------
;(KAWAGUCHI Parameters)
	a8i16
	PHB
	db7e
	km_bitcheckgameflag	battle
	bne	.battle
;=============================
.MISSION
	shorta
	longi
;* syori *
	km_setgamesyori	main
;* Flag *
	a16
	km_setgameflag		keydisable	;[GAME FLAG]
	km_clrgameflag		areaout		;[GAME FLAG]
	km_clrmissionflag	parallel	;[MISSION FLAG]

;* radar scale *
	km_setval	kx_radarscale,scale_ground	;1dot = 128 (gamelist.inc)
;* Game Timer *
	km_setval	kx_GameTmAdd,0
	km_setval	kx_GameTmSub,missgftm	;1 hour time = 10 second
	km_setval	kx_EnStratTm,enstrattm	;enemy stratage timer
	km_setval	kw_Gametimer,0		;Game ni kakatta time
	a8
;* sprite display wait (for mission) *
	km_setval	sprdispwait,3
	brl	.COMMON
;=============================
.BATTLE
	shorta
	longi
;* Game Timer *
	km_stxval	kw_GameTimer,2*60+2

;**** player states ****
;* player HP *
	jsl	playerstatus_init_l

;* player1 *
;---- ring out -----
	km_plheapptr	1,x
	km_setval	KRingOutSecTm,second,x		; 1 sec time (15)
	s_set_alvar	B,x,KRingOutTimer,#ROIntTm  	; Set Init Time(10)
;* player 2 *
;---- ring out -----
	km_plheapptr	2,x
	km_setval	KRingOutSecTm,second,x		; 1 sec time (15)
	s_set_alvar	B,x,KRingOutTimer,#ROIntTm  	; Set Init Time(10)
;=============================
.COMMON
	km_setval.l	coltimer_2,3
	km_setval.l	coltimermax_2,3
	PLB
;------------------------------------------------------------------
;(Yajima's Parameter)
	jsl	clear_YJgameparam_l
;------------------------------------------------------------------
;(Kawagoe's Parameters)
	stz	demoflag
	a16
	stz	player1_horizon_offset
	stz	player2_horizon_offset
	stz	player1hscroll_offset
	stz	player2hscroll_offset
	a8
;------------------------------------------------------------------
;* (Dylan Parameters) *
	a16
	km_setval.l	bossmaxhp,0
	a8
	lda	#0
	sta.l	m_meters
	stz	gameframe
;---------------------------------------------------
	jsl	setscreentype_l
;---------------------------------------------------
	a8
	lda	#1
	sta	sheildon
	stz	showtype
	stz	msg_count1
	stz	msg_count2
	stz	restartcol
	stz	onecredspr
	stz	doneacircle
	stz	windowmode1
	stz	windowmode2
	stz	nosetport3
	stz	pausesnd
	stz	sdpck3
	stz	prttraining

	lda	#-1
	sta	CurrentArea
	sta	SecondaryArea
	stz	NumAreas
	lda	#0
	sta.l	MessageCount

	jsl	kill_list_l	; format alien list
	jsl	initmem_l

	jsl	mapsysteminit_l
	a8
	lda	mapbank
	pha			;>>>> PUSH Map Bank

	lda.l	mapbase+2	; set up player's objects
	sta	mapbank
	ai16
	lda	mapptr
	pha			;>>>> PUSH Map Address
	lda.l	mapbase
	tax

	stz	playpt1
	stz	playpt2

	lda	screenmode
	bit	#sm_noplayer
	bne	.noplayerobjs

	jsl	newobjs_l		;add player

.noplayerobjs
	a8i16
	jsl	initgame_strats_l	;initialise game
	i16
	plx			;<<<< PULL Map Address
	pla			;<<<< PULL Map Bank
	sta	mapbank
	a16
	stz	levelfinished
	stx	mapptr

	jsl	newobjs_l		; set new map going

	jsl	initgame3d_l
	jsl	find_window_pri_l

	plb
	plp
	rtl

;-------------------------------------------------------------------------

initgame3d_l
	php
	ai8
;	jsr	gameclipwindow
	a16
	lda	#$1234
	sta.l	m_particlerand	
	lda	#1
	sta.l	m_clrbitmaps
	jsl	screensetup_l
	a8
	lda	#deg180
	sta	roty
	lda	#-1
	sta	mariocode
	stz	trans_flag
	jml	init3d1



	IFEQ	1

halfbg23	php
	a8i16
	phx

	alloc_window	halffade,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%11100110
	sta	wm_cgadsub,x
	lda	#%11100000
	ora	wm_val,x
	sta	wm_coldata,x
	lda	wm_val,x
	cmp	#15
	beq	.nc
	inc	a
	sta	wm_val,x
.nc	plx
	plp
	rts

fadehalf2norm	php
	a8i16
	phx
	alloc_window	halffade,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%11100110
	sta	wm_cgadsub,x

	lda	#%11100000
	ora	wm_val,x
	sta	wm_coldata,x

	lda	wm_val,x
	beq	.done
	dec	a
	sta	wm_val,x
	plx
	plp
	rts
.done	
	dealloc_window	halffade,1
	plx
	plp
	rts

setbg23toblack
	php
	a8i16
	phx
	alloc_window	halffade,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%11100110
	sta	wm_cgadsub,x

	lda	#%11111111
	sta	wm_coldata,x

	lda	#31
	sta	wm_val,x
	plx
	plp
	rts

	ENDC

*****************************************************************************
*****************************************************************************
*****************************************************************************
*****************************************************************************



	IFEQ	1

	shorta
	shorti
gameclipwindow_l
	jsr gameclipwindow
	rtl

gameclipwindow
	a16
	test_screenmode	training
	lbne	.training
	test_screenmode	3dglasses
	lbne	.3dglasses
	test_screenmode	onescreen
	lbeq	.twoscreen
	test_screenmode	cockpit
	lbeq	.nocock		; you said it
	
	movi	0,clx1
	movi	bitmapwidth_1c*8-1,clx2
	movi	0,cly1
	movi	bitmapvheight_1c*8-1,cly2
	movi	bitmapwidth_1c*4,vanishx
	movi	bitmapvheight_1c*4,vanishy

	lda	#bitmapvheight_1c*8
	sta	screenvheight
	lda	#bitmapheight_1c*8
	sta	screenheight
	lda	#bitmapwidth_1c*8
	sta	screenwidth
	lda	#player1_wx_1c
	sta	screen3dxpos_1
	lda	#player1_wy_1c
	sta	screen3dypos_1

	lda	#pal3d<<10
	sta	screen3dpalette_1
	lda	#(0<<10)!(1<<13)	; set priority and palette 7 for blanking char
	sta	blankpalette

	brl	.setem
.3dglasses
	movi	0,clx1
	movi	bitmapwidth_3d*8-1,clx2
	movi	0,cly1
	movi	bitmapvheight_3d*8-1,cly2
	movi	bitmapwidth_3d*4,vanishx
	movi	bitmapvheight_3d*4,vanishy

	lda	#bitmapvheight_3d*8
	sta	screenvheight
	lda	#bitmapheight_3d*8
	sta	screenheight
	lda	#bitmapwidth_3d*8
	sta	screenwidth
	lda	#player1_wx_3d
	sta	screen3dxpos_1
	lda	#player1_wy_3d
	sta	screen3dypos_1

	lda	#1<<10
	sta	screen3dpalette_1
	lda	#3<<10
	sta	screen3dpalette_2
	lda	#(7<<10)!(1<<13)	; set priority and palette 7 for blanking char
	sta	blankpalette
	brl	.setem

.training
	movi	0,clx1
	movi	bitmapwidth_tr*8-1,clx2
	movi	0,cly1
	movi	bitmapvheight_tr*8-1,cly2
	movi	bitmapwidth_tr*4,vanishx
	movi	bitmapvheight_tr*4,vanishy

	lda	#bitmapvheight_tr*8
	sta	screenvheight
	lda	#bitmapheight_tr*8
	sta	screenheight
	lda	#bitmapwidth_tr*8
	sta	screenwidth
	lda	#player1_wx_tr
	sta	screen3dxpos_1
	lda	#player1_wy_tr
	sta	screen3dypos_1

	lda	#pal3d<<10
	sta	screen3dpalette_1
	lda	#(0<<10)!(1<<13)	; set priority and palette 7 for blanking char
	sta	blankpalette

	brl	.setem

.nocock
	movi 0,clx1
	movi bitmapwidth_1*8-1,clx2
	movi 0,cly1
	movi bitmapvheight_1*8-1,cly2
	movi bitmapwidth_1*4,vanishx
	movi bitmapvheight_1*4,vanishy

	lda	#bitmapvheight_1*8
	sta	screenvheight
	lda	#bitmapheight_1*8
	sta	screenheight
	lda	#bitmapwidth_1*8
	sta	screenwidth
	lda	#player1_wx_1
	sta	screen3dxpos_1
	lda	#player1_wy_1
	sta	screen3dypos_1

	lda	#pal3d<<10
	sta	screen3dpalette_1
	lda	#(0<<10)!(1<<13)	; set priority and palette 7 for blanking char
	sta	blankpalette

	bra	.setem
.twoscreen
	movi 0,clx1
	movi bitmapwidth*8-1,clx2
	movi 0,cly1
	movi bitmapvheight*8-1,cly2
	movi bitmapwidth*4,vanishx
	movi bitmapvheight*4,vanishy

	lda	#bitmapvheight*8
	sta	screenvheight
	lda	#bitmapheight*8
	sta	screenheight
	lda	#bitmapwidth*8
	sta	screenwidth
	lda	#player1_wx
	sta	screen3dxpos_1
	lda	#player1_wy
	sta	screen3dypos_1
	lda	#player2_wx
	sta	screen3dxpos_2
	lda	#player2_wy
	sta	screen3dypos_2

	lda	#pal3d<<10
	sta	screen3dpalette_1
	lda	#pal3d<<10
	sta	screen3dpalette_2
	lda	#(7<<10)!(1<<13)	; set priority and palette 7 for blanking char
	sta	blankpalette

.setem
	a16
	lda	screenheight
	sta.l	m_screenheight
	lda	screenvheight
	sta.l	m_screenvheight
	lda	screenwidth
	sta.l	m_screenwidth
	lda	screen3dxpos_1
	sta.l	m_screen3dxpos_1
	lda	screen3dxpos_2
	sta.l	m_screen3dxpos_2
	lda	screen3dypos_1
	sta.l	m_screen3dypos_1
	lda	screen3dypos_2
	sta.l	m_screen3dypos_2

	lda	screen3dpalette_1
	sta.l	m_screen3dpalette_1
	lda	screen3dpalette_2
	sta.l	m_screen3dpalette_2
	lda	blankpalette
	sta.l	m_blankpalette

	lda	screenmode
	sta.l	m_screenmode
	a8
	rts

	ENDC


clearhvofs_l
	php
	a8
	stz	bg1hofs
	stz	bg1hofs
	stz	bg1vofs
	stz	bg1vofs

	stz	bg2hofs
	stz	bg2hofs
	stz	bg2vofs
	stz	bg2vofs

	stz	bg3hofs
	stz	bg3hofs
	stz	bg3vofs
	stz	bg3vofs

	stz	bg4hofs
	stz	bg4hofs
	stz	bg4vofs
	stz	bg4vofs
	plp
	rtl



setpal_l	php
	ai16
	and #$ff
	xba
	lsr a
	lsr a
	lsr a
	tax

	a8
	lda	#16*pal3d
	sta	cgadd
	ldy	#0
.loop	lda.l	paladdr,x
	sta	cgdata
	lda.l	paladdr+1,x
	sta	cgdata
	inx
	inx
	iny
	iny
	cpy	#32
	bne	.loop
	plp
	rtl
;-------------------------------------------------------------------------
setgamepal_l	php
	phb
	ai16
;Acc :Game Palette Pointer

	and #$ff
	xba
	lsr a
	lsr a
	lsr a		;* 32 (1 palette no length)
	tax

;;;	disable
	a8
	lda	#$7e
	pha
	plb		; so we can access ram without .L

	ldy	#0
	a16
.loop	lda.l	paladdr,x
;;	sta.w	gamepalbuff&WM,y
;;	sta.w	pal0palette+7*32,y
	sta.w	kx_palette&WM+7*32,y
	inx
	inx
	iny
	iny
	cpy	#32
	bne	.loop
;;;;	enable
	plb
	plp
	rtl




kill_list_l	php
	ai16
	stz	allst	;clear Alien list
	FmtFreeLst	alfreelst,alblks,number_al,al_size
	plp
	rtl



showview_l
	php
	jsr	marioshowview
	a8i16
	call_mario	mallrotzsort
	plp
	rtl

alienflags_l
	php
	phb
	a8
	lda	#$7e
	pha
	plb

	i16
	ldx	#m_drawlist&WM
	ldy	allst
.next

	a8
	test_alsflag		y,invisible
	bne			.nextal
;	s_jmp_alsflag		y,invisible,.nextal

	a16
	lda.l	dl_x,x
	bpl	.right
.left	lda.w	al_flags,y
	ora	#afinviewpl+afleftpl
	sta.w	al_flags,y
	bra	.cont
.right	lda.w	al_flags,y
	ora	#afinviewpl
	sta.w	al_flags,y
.cont
	a16
	txa
	clc
	adc	#dl_sizeof
	tax

.nextal	a16
	lda.w	_next,y
.killed
	tay
	bne	.next

	plb
	plp
	rtl

	IFEQ	0

marioshowview
	php
	phb
	a8
	lda	#$7e
	pha
	plb

	ai16
	stz	numshapes
	lda	shadowheight
	sta.l	m_shadowheight
	lda	viewposy
	sta.l	m_viewposy

	ldx	#m_Drawlist&WM
	ldy	allst
.next	a8
	sty	al1pt

; clear view flags
	lda.w	al_flags,y
	and	#~(afinrngpl+affrontpl+afinviewpl+afleftpl)
	ora	#affrontpl
	sta.w	al_flags,y

	s_jmp_alsflag	y,invisible,.nextal

; ground obj?
	lda.w	al_type,y
	bit	#atgnd
	a16
	beq	.notgndobj
	lda	#15000
	bra	.gndobj
.notgndobj	lda	#0
.gndobj	sta.l	dl_sortz,x

; copy x,y,z into the drawlist block
	lda.w	al_worldx,y
	sec
	sbc	viewposx
	sta.l	dl_x,x
	lda.w	al_worldy,y
	sec
	sbc	viewposy
	sta.l	dl_y,x
	lda.w	al_worldz,y
	sec
	sbc	viewposz
	sta.l	dl_z,x

;	s_jmp_NOTalsflag	y,invisible,.notinvis
;	lda	#nullshape
;	bra	.invis
.notinvis
	lda.w	al_shape,y
.invis
	sta.l	dl_shape,x

	a8
	lda.w	al_rotx,y
	sta.l	dl_rotx,x
	lda.w	al_roty,y
	sta.l	dl_roty,x
	lda.w	al_rotz,y
	sta.l	dl_rotz,x


	a8
	lda.w	al_flags,y
	and	#afexp
	beq	.noexp
	lda.w	al_count,y
	sta.l	dl_expcnt,x

;-----------------------------------------------
; put unique obj number in dl_shady if partobj.
	lda.w	al_sflags,y
	bit	#asf_partobj
	beq	.exploded

	a16
	tya
	sta.l	dl_shady,x
	a8
	lda.w	al_sbyte1,y	; amount
	sta.l	dl_shadx,x
	lda.w	al_sbyte2,y	; life
	sta.l	dl_shadx+1,x
	lda.w	al_sbyte3,y	; type
	sta.l	dl_shadz,x

;-----------------------------------------------

	bra	.exploded
.noexp
	lda	#0
	sta.l	dl_expcnt,x

.exploded

	lda.w	al_sflags,y
	sta.l	dl_sflags,x

; mask out hitflash (only hitflashes for one frame)
	and	#~asf_hitflash
	sta.w	al_sflags,y

; copy the animation and colour animation frames over
	lda.w	al_animframe,y
	bmi	.standardframe
	lda	gameframe
.standardframe
	and	#127
	sta.l	dl_animframe,x

	lda.w	al_colframe,y
	bmi	.standardframe2
	lda	gameframe
.standardframe2
	and	#127
	sta.l	dl_colframe,x

; copy the depth offset in
	lda.w	al_depthoffset,y
	sta.l	dl_depth,x

; texture map coordinates
	lda.w	al_tx,y
	sta.l	dl_tscrollx,x
	lda.w	al_ty,y
	sta.l	dl_tscrolly,x

; check for debug mode (y = alientemp)
	a16
	cpy	alientemp
	bne	.normcoltab

	lda	gameframe
	and	#7
	cmp	#4
	bcc	.onecol
	lda	#white_C&WM
	bra	.connn
.onecol
	lda	#black_C&WM
	bra	.connn

.normcoltab
	lda.w	al_coltab,y
.connn
	sta.l	dl_coltab,x

; increment number of shapes
	inc	numshapes

; increment dl pointer
	txa
	clc
	adc	#dl_sizeof
	tax


.nextal	a16
; next alien block (if any)
	lda.w	_next,y
	tay
	lbne	.next
.out
	lda	numshapes
	sta.l	m_numshapes

	plb
	plp


	rts

	ELSEIF


showview	

	a16
	lda	viewposy
	sta.l	m_viewposy

	ai8
	lda	showtype
	lbne	showview2

	jsr	 initdeferredlist

	i16
	ldx	allst
.next	a8
	stx	al1pt

	s_jmp_alsflag	x,invisible,.nextal

	lda	al_flags,x
	and	#~(afinrngpl+affrontpl+afinviewpl+afleftpl)
	sta	al_flags,x

	ldy	al_shape,x
	a16
	lda	al_worldx,x
	sec
	sbc	viewposx
	sta.l	m_x1
	lda	al_worldy,x
	sec
	sbc	viewposy
	pha
	lda	shadowheight
	sbc	viewposy
	sta.l	m_y1
	lda	al_worldz,x
	sec
	sbc	viewposz
	sta.l	m_z1

	lda	al_sflags,x
	and	#asf_shadow
	beq	.noshadow

	a8
	lda	#mwmatrotp16>>16
	ldx	#mwmatrotp16&$ffff
	jsl	runmario_l
	a16
	lda.l	m_bigx
	sta	shadx
	lda.l	m_bigz
	sta	shadz
.noshadow
	lda.l	m_bigy
	sta	shady
	pla
	sta.l	m_y1

	a8
	lda	#mwmatrotp16>>16
	ldx	#mwmatrotp16&$ffff
	jsl	runmario_l

	ldx	al1pt

	lda	al_sflags,x
	and	#asf_shadowshape
	a16
	beq	.notshadowshape
	lda.l	m_bigx
	sta	shadx
	lda.l	m_bigy
	sta	shady
	lda.l	m_bigz
	sta	shadz
.notshadowshape

	lda.l	m_bigx
	bpl	.right
.left	sta	bigx
	lda	al_flags,x
	ora	#afinviewpl+affrontpl+afleftpl
	sta	al_flags,x
	bra	.cont
.right	sta	bigx
	lda	al_flags,x
	ora	#afinviewpl+affrontpl
	sta	al_flags,x
.cont

	lda.l	m_bigz
	ldy	al_shape,x
	clc
	adc.w	sh_zmax,y
	bmi	.chkkillal
	sec
	sbc.w	sh_zmax,y
	sta	bigz

	lda.l	m_bigy
	sta	bigy

	jsr	deferredinsert
	ldx	al1pt
.nextal	ldy	_next,x
.killed	tyx
	lbne	.next
	rts


	longi
.chkkillal	
	a8
	s_jmp_varAND		B,gameflags,#gf_nozremove,.nextal
	test_alcollflags	x,acf_firstframe
	bne	.nextal
	lda	al_type,x
	and	#atzremove
	beq	.nextal
	ldy	_next,x
	jsl	removedeadal_l
	bra	.killed


showview2
	IFEQ	1
	jsr	 initdeferredlist

	i16
	ldx	allst
.next
	a8
	stx	al1pt

	lda	al_flags,x
	and	#~(afinrngpl+affrontpl+afinviewpl+afleftpl)
	sta	al_flags,x

	ldy	al_shape,x

	a16
	lda	al_worldx,x
	sec
	sbc	viewposx
	sta.l	m_x1
	lda	al_worldy,x
	sec
	sbc	viewposy
	sta.l	m_y1
	lda	al_worldz,x
	sec
	sbc	viewposz
	sta.l	m_z1

	lda	#0
	sec
	sbc	viewposy
	sta	shady

	a8
	lda	#mwmatrotp16>>16
	ldx	#mwmatrotp16&$ffff
	jsl	runmario_l
	ldx	al1pt

	a16
	lda.l	m_bigz
	bpl	.zp
	nega
.zp	sta	tpx
	lda.l	m_bigx
	bpl	.xp
	nega
.xp	adc	tpx
	cmp	#maxztab+1000
	bcs	.killal

	lda.l	m_bigz
	sta	bigz

	lda.l	m_bigx
	bpl	.right
.left	sta	bigx
	lda	al_flags,x
	ora	#afinviewpl+affrontpl+afleftpl
	sta	al_flags,x
	bra	.cont
.right	sta	bigx
	lda	al_flags,x
	ora	#afinviewpl+affrontpl
	sta	al_flags,x
.cont
	lda.l	m_bigy
	sta	bigy

	jsr	deferredinsert
	ldx	al1pt
.nextal	ldy	_next,x
.killed	tyx
	lbne	.next
	rts

	longi
.killal	a8
	ldy	_next,x
	jsl	removedeadal_l
	bra	.killed


	ENDC


	ENDC

	IFEQ	1
initdeferredlist
	php
	ai16
	ldx	#zbblks
	stx	spare
	stz	zb_behind,x
	stz	zb_infront,x
	stz	head
	plp
	rts



***************************************************************
*
*   Binary tree Z sort
*
*   By Krister Wombell and Jon Wolff.
*
zb_behind	equ	0
zb_infront	equ	2

deferredinsert
	ai16
;	lda	bigx
;	bpl	.posx
;	eor	#-1
;.posx	lsr	a
;	adc	bigz
;	sta	sortz
;	lda	bigy
;	bpl	.posy
;	eor	#-1
;.posy	lsr	a
;	adc	sortz
	
	lda	bigz
	sta	sortz

	ldy	al_shape,x
	clc
	adc.w	sh_sortz,y 
	bpl	.nbehind
	lda	#0
.nbehind
	sta	sortz

	lda	al_type,x
	and	#atgnd
	beq	.notgndobj
	clc
	lda	sortz
	adc	#20000
	sta	sortz
.notgndobj
	lda	sortz
	ldx	#head 		;link 'a' into binary tree
.loop	ldy	0,x
	beq	.dolink
	tyx
	cmp	zb_sz,x
	bcs	.loop
	inx
	inx
	bra	.loop
.dolink
	ldy	spare
	sty	0,x
	tyx
	stz	zb_behind,x
	stz	zb_infront,x
.copydata
	lda	al1pt		;store ptr to al block
	sta	zb_ptr,x		;store rotated x
	lda	bigx
	sta	zb_x,x
	lda	bigy		;rotated y
	sta	zb_y,x
	lda	bigz		;rotated z
	sta	zb_z,x
	lda	shady
	sta	zb_shady,x	; store the shadow's rotated y
	lda	shadx
	sta	zb_shadx,x
	lda	shadz
	sta	zb_shadz,x

	lda	sortz		;and distance
	sta	zb_sz,x
	txa
	clc
	adc	#zb_size
	sta	spare
	rts


	ENDC
	shorta
	longi
build_drawlist_l
	jsr	build_drawlist
	rtl
build_drawlist
	rts
	IFEQ	1
	ai16
	ldx	#m_drawlist&WM
	stx	dlptr

	stz	numshapes
	stz	ktpx

	ldx	head		;get first behind
	lbeq	drawlistexit
walktree
	ldy	zb_behind,x
	beq	.nonebehind
	phx
	tyx
	inc	ktpx
	jmp	walktree		;do 'behind objects'
.ret	local
	plx
.nonebehind
	ldy	zb_ptr,x

	phx
	ldx	dlptr
	a8
	lda.w	al_rotx,y
	sta.l	dl_rotx,x
	lda.w	al_roty,y
	sta.l	dl_roty,x
	lda.w	al_rotz,y
	sta.l	dl_rotz,x
	a16
	lda.w	al_shape,y
	sta.l	dl_shape,x
	plx

	phy
	txy
	ldx	dlptr
	lda.w	zb_shady,y
	sta.l	dl_shady,x
	lda.w	zb_shadx,y
	sta.l	dl_shadx,x
	lda.w	zb_shadz,y
	sta.l	dl_shadz,x
	lda.w	zb_y,y
	sta.l	dl_y,x
	lda.w	zb_x,y
	sta.l	dl_x,x
	lda.w	zb_z,y		;y=zb block
	sta.l	dl_z,x
	plx			;x=al block

	phy
	a8
	stz	expcnt
	lda	al_flags,x
	and	#afexp
	beq	.noexp
	lda	al_count,x
	sta	expcnt

;-----------------------------------------------
; put unique obj number in dl_shady if partobj.
	lda	al_sflags,x
	bit	#asf_partobj,.noexp

	a16
	txy
	txa
	ldx	dlptr
	sta.l	dl_shady,x
	a8
	lda.w	al_sbyte1,y	; amount
	sta.l	dl_shadx,x
	lda.w	al_sbyte2,y	; life
	sta.l	dl_shadx+1,x
	lda.w	al_sbyte3,y	; type
	sta.l	dl_shadz,x
	tyx

;-----------------------------------------------


.noexp
	lda	al_sflags,x
	sta	sflags
	bit	#asf_hitflash
	beq	.nothfc
	and	#~asf_hitflash
	sta	al_sflags,x
.nothfc
	lda.l	alx_animframe,x
	bit	#128
	bne	.standardframe
	lda	gameframe
.standardframe
	sta	animframe
	lda.l	alx_colframe,x
	bit	#128
	bne	.standardframe2
	lda	gameframe
.standardframe2
	sta	colframe

	lda.l	alx_depthoffset,x	; get high byte.
	sta	tpa

	lda.l	alx_tx,x
	sta	texxy
	lda.l	alx_ty,x
	sta	texxy+1

	a16
	cpx	alientemp
	bne	.normcoltab
	lda	gameframe
	and	#7
	cmp	#4
	bcc	.onecol
	lda	#white_C&WM
	bra	.connn
.onecol
	lda	#black_C&WM
	bra	.connn
.normcoltab
	lda.l	alx_coltab,x
.connn
	sta	tpx
	a8

	ldx	dlptr
	lda	texxy
	sta.l	dl_tscrollx,x
	lda	texxy+1
	sta.l	dl_tscrolly,x
	lda	expcnt
	sta.l	dl_expcnt,x
	lda	sflags
	sta.l	dl_sflags,x
	lda	animframe
	and	#127
	sta.l	dl_animframe,x
	lda	colframe
	and	#127
	sta.l	dl_colframe,x
	lda	tpa
	sta.l	dl_depth,x
	a16
	lda	tpx
	sta.l	dl_coltab,x

	lda	dlptr
	clc
	adc	#dl_sizeof
	sta	dlptr

	inc	numshapes

	plx
	ldy	zb_infront,x
	beq	drawlistexit
	tyx
	jmp	walktree

drawlistexit
	dec	ktpx
	bpl	walktree.ret
	rts


	ENDC




makeBG2black_l
	phx
	a8
	lda	#0
	ldx	#(7*32)-1
.clr	sta.w	pal0palette,x
	dex	
	bpl	.clr
	plx
    	rtl


;---------------------------------------------------------------------------


setinidisp1_l
	php
	a8
	sta.l	xinidisp1
	sta.l	xinidisp2
	sta.l	xinidisp1a
	plp
	rtl

;---------------------------------------------------------------------------

setnoclash_l
	php
	a8
	lda	#99
	sta.l	xinidisp1-1
	lda	#49
	sta.l	xinidisp2-1
	lda	#58
	sta.l	xinidisp1a-1
	plp
	rtl
;---------------------------------------------------------------------------
screenoff_l
	php
	a8i16
	stz	hdmaen
	stz	trans_flag
	waitdma	150
	waitdma	140	; wait for it all to take effect
	lda	#$80
	sta	inidisp
	setinidisp1
	plp
	rtl


;---------------------------------------------------------------------------


batabata_name	db	" MOTH GLIDER ",0
dandou_name		db	" PLANET MISSILE ",0
sos_0_name		db	" NIGHT FANG ",0
taigun_name		db	" HAL BIRD ",0
sos_1_name		db	" SKULL TOAD ",0
jyouge_name		db	" GOLD STAR ",0
demo_senkan_name	db	" CANNON BETRAYER ",0
dragon_name		db	" MIRAGE DRAGON ",0
wolf_name		db	" THE WOLF TEAM ",0
andorf_name		db	" ANDORF",0
andross_name		db	" ANDROSS",0

enkin_name		db	" SKY KICKER ",0
baramiss_name	db	" SPREAD MISSILE ",0
virus_name		db	" BRAIN SPOILER ",0
speed_name		db	" SPIRAL KITE ",0
baku_name		db	" CANNON BOMBER ",0
ninja_name		db	" TEKTRON ",0
stepup_0_name	db	" HUNTER FANTRON ",0

gattai_name		db	" TURTLE MISSILE ",0
toge_name		db	" STATION MISSILE ",0
kuru0_name		db	" THE SPINNERS ",0
sos_2_name		db	" METAL BOOMERANG ",0
crusher_name		db	" SPACE BLADE ",0
suisei_name		db	" ASTROPOLIS ",0
jyouge_1_name	db	" PRISON BOW ",0

name_algy	db	"ALGY",0
name_pigma	db	"PIGMA",0
name_leon	db	"LEON",0
name_wolf	db	"WOLF",0
name_kani	db	"QUEEN DRAGOON",0
name_kama	db	"KAMANTIS",0
name_fantron	db	"H.FANTRON",0
name_tectron	db	"TEKTRON",0
name_mirage	db	"MIRAGE DRAGON",0
name_knight	db	"KNIGHT NACK",0
name_kick	db	"KICK GUNNER",0
name_yoyo	db	"HEAVY CHARIOT",0

name_tako	db	"QUEEN DIORAY",0
name_runner	db	"TAL KONG",0
name_crusher	db	"SPACE BLADE",0
name_dodora	db	"KING DODORA",0

