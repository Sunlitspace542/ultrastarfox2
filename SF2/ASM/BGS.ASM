;***************************************************************************
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                           Argonaut Software.                            *	   
;*_________________________________________________________________________*
;*                                                                         *
;*   File: BGS.ASM                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: Definitions for level backgrounds.                              *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 5/5/92                                                          *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:                                                                 *
;*	 Krister Wombell, Dylan Cuthbert ,Yasuhiro Kawaguchi          *
;*                                                                         *
;***************************************************************************

	INCPUB	bgs

;*****************************************************************************
;*									*
;*			Screen Set					*
;*									*
;*****************************************************************************
;=====================================================================
;*			Title Screen				*
;=====================================================================
	shorta
	longi
bg_title_1
;* game (3d) palette *
	km_gamepal	night
;* bg mode *
	jsr	mode1h16
;* cgx & scr & colour *
	bg2chr	b16		;bg2 character data
	bg2scr	b16		;bg2 screen data

	km_setscreenflag	noset_col	;dma crash boushi!!
	km_decrunchpal		;colour data decompress to MARIO RAM
	set_bg			;(irq start) bg data trans

	km_palette	b16,16,0	;BG Base Colour
	set_palette			;col data transfer
	brl	depthmode_space_night

;=====================================================================
;*			Demo Screen				*
;=====================================================================
bg_titledemo_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16

	bg2chr	a8
	bg2scr	a8

	km_decrunchpal
	km_palette	col_2
	set_bg

	km_bitcheckmistotalflag	gameend
	beq	.easy

	lda.l	kdifficulty
	beq	.easy
	dec	a
	beq	.normal
.hard
	km_palette	a19,3,4
	jmp	depthmode_space
.normal
	km_palette	a20,3,4
	jmp	depthmode_space
.easy
	km_palette	a8,3,4
	jmp	depthmode_space

;---------------------------------------------------------------------------
bg_startenemydemo_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16

	bg2chr	a8
	bg2scr	a8

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a8,3,4
	jmp	depthmode_space

;---------------------------------------------------------------------------
bg_startarwingdemo_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16

	bg2chr	a8
	bg2scr	a18

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a8,3,4
	jmp	depthmode_space

;---------------------------------------------------------------------------
bg_entermshipdemo_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16

	bg2chr	a8
	bg2scr	a8

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a8,3,4
	jmp	depthmode_space
;---------------------------------------------------------------------------
;* Game Over BG (for Planet)*
bg_attackcorneriademo_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16

	bg2chr	a8
	bg2scr	a18

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a8,3,4
	jmp	depthmode_space

;---------------------------------------------------------------------------
;* Game Over BG (for Ground)*
bg_explodecorneriademo_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2h16

	bg2chr	a13
	bg2scr	a13

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a13,3,4
	jmp	depthmode_space

;---------------------------------------------------------------------------
;* Enter Meteor Base BG *
	shorta
	longi
bg_entermeteordemo_1
	IFEQ	1
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16

	bg2chr	a11
	bg2scr	a16

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a12,3,4
	jmp	depthmode_space
	ENDC
;---------------------------------------------------------------------------
bg_sun_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	sun
;* bg mode *
	jsr	mode2v16

	bg2chr	a11
	bg2scr	a10

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a11,3,4
	jmp	depthmode_space


;---------------------------------------------------------------------------
bg_corneria_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2h16

	bg2chr	a5
	bg2scr	a5

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a5,3,4
	jmp	depthmode_space

;=====================================================================
;*		MISSION BG Screen				*
;=====================================================================
bg_missionexplain_1
	shorta
	longi

;* tm *
	lda	#1+2+4+16
	sta	kw_tmptm
;* BG3 size ( mode1h8 no maeni oku !!!)
	km_setbg3size				;4chr mode
	km_setval	bg3screensize,3		;4 screen
;* game 3d  palette *
	km_gamepal	MARINE
;* bg mode *
	jsr	mode1h8

;* cgx & scr & colour *
	bg2chr	b14,2*k,0
	bg2scr	b14,0,2*k

	km_setscreenflag	noset_col	;dma crash boushi!!
	km_decrunchpal
	set_bg

	km_palette	b0,16,0
	set_palette			;col data transfer

	bg3chr	b15,4*k,0
	bg3scr	b15,0,4*k
	set_bg3

	set_zdepthtable	explain
	brl	depthmode_planet_night

;-------------------------------------------------------------------------
bg_missiongameover_1
	shorta
	longi
;* tm *
	lda	#1+2+16
	sta	kw_tmptm

;* BG3 size ( mode1h8 no maeni oku !!!)
;	km_setbg3size				;4chr mode
;	km_setval	bg3screensize,3		;4 screen

;* game 3d  palette *
	km_gamepal	NIGHT
;* bg mode *
	jsr	mode1h16

	km_clrflag16	screenmode,sm_nosprites

;* cgx & scr & colour *
	bg2chr	a15	;,4*k,0
	bg2scr	a15	;,0,2*k
	km_decrunchpal
	km_palette	a15,3,4
	set_bg

;	bg3chr	b15,4*k,0
;	bg3scr	b15,0,4*k
;	set_bg3

	km_palette	b15,8,8	;file,length,start
	set_palette		;planet col data transfer

	set_zdepthtable	explain
	jmp	depthmode_planet_night
;-------------------------------------------------------------------------
bg_missioncontinue_1
	shorta
	longi
;* tm *
	lda	#16+1
	sta	kw_tmptm
;* BG3 size ( mode1h8 no maeni oku !!!)
	km_setbg3size				;4chr mode
	km_setval	bg3screensize,3		;4 screen

;* game 3d  palette *
	km_gamepal	NIGHT
;* bg mode *
	jsr	mode1h8

;* cgx & scr & colour *
	bg2chr	b14,2*k,0
	bg2scr	b14,0,2*k
	km_decrunchpal
	km_palette	yaji_0,4,8	;file,length,start
	set_bg

	km_palette	b0,7,0
	set_palette		;planet col data transfer

	set_zdepthtable	explain
	jmp	depthmode_planet_night
;---------------------------------------------------------------------------
bg_missionstage1_1
	shorta
	longi

;* game 3d  palette *
	km_gamepal	mist

;* bg mode *
	jsr	mode2h16

	lda	currentlevel
	cmp	#itemplanetskill
	km_beq	.itemplanet

.Normal
;* cgx & scr & colour *
	bg2chr	a0
	bg2scr	a0

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a0,3,4
	set_palette		;col data transfer
	km_palette	w0,8,8	;file,length,start
	set_palette		;col data transfer

	set_zdepthtable	mist	;depth mode (coltabs.asm)
;	info	hon,von,zon,nodots
	hofmode	nograd
	bg2Yscroll	0 	;232
	planet	mist		;(night,mist,desert,marine)

.Itemplanet
;* cgx & scr & colour *
	bg2chr	a3
	bg2scr	a12

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a12,3,4
	brl	depthmode_planet

;---------------------------------------------------------------------------
bg_missionstage2_1
	shorta
	longi

;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2h16
;* cgx & scr & colour *
	bg2chr	a1
	bg2scr	a1

	km_decrunchpal
	km_blocktrans	(c0_pac),kx_palette2,256
	km_palette	col_2
	set_bg
	km_palette	a1,3,4
	jmp	depthmode_planet

;---------------------------------------------------------------------------
bg_missionstage3_1
	shorta
	longi

;* game 3d  palette *
	km_gamepal	magma
;* bg mode *
	jsr	mode2h16

;* cgx & scr & colour *
	bg2chr	a2
	bg2scr	a2
	km_decrunchpal
 	km_palette	col_2
	set_bg
	km_palette	a2,3,4

	shadowheight	-16
	jmp	depthmode_planet
;---------------------------------------------------------------------------
bg_missionstage4_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	mist
;* bg mode *
	jsr	mode2h16

;* cgx & scr & colour *
	bg2chr	a3
	bg2scr	a3
	km_decrunchpal
	km_blocktrans	(c1_pac+8*16*2),kx_palette2,256
 	km_palette	col_2
	set_bg
	km_palette	a3,3,4
	set_palette		;col data transfer

;=============================================
;*	Yajima's Screen Buffer Tenkai	*
;=============================================
	ifeq	1
;* heap memory get *
	phb
	db7e
	a16
	lda	#2048
	jsl	alloc_l
	sta	heaven_bgpointer

	lda	#2048
	jsl	alloc_l
	sta	hell_bgpointer
	a8
	plb
;* copy screen data from mario RAM to heap RAM *
	decram	a3_pcr,0
	ldy	heaven_bgpointer
	km_blocktransY	($700000+dec_base),xheap,2048
	decram	a4_pcr,0
	ldy	hell_bgpointer
	km_blocktransY	($700000+dec_base),xheap,2048
	endc
	jmp	depthmode_planet_w0obj
;---------------------------------------------------------------------------
bg_missionstage5_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2h16

	bg2chr	a4
	bg2scr	a4

	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a4,3,4
	jmp	depthmode_planet

;---------------------------------------------------------------------------
bg_missionstage6_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	mist
;* bg mode *
	jsr	mode2v16

;* cgx & scr & colour *
	bg2chr	a6
	bg2scr	a6
	km_decrunchpal
	km_palette	col_2
	set_bg
;;;	km_blocktrans	(c1_pac+8*16*2),kx_palette2,256
	km_palette	a6,3,4
	set_palette

	km_palette	w0,8,8	;file,length,start
	set_palette		;col data transfer

	set_zdepthtable	ground	;depth mode (coltabs.asm)
;	info	hon,von,zon,nodots
	hofmode	nograd
	bg2Yscroll	0 	;232
	planet	marine	;(night,mist,desert,marine)
;---------------------------------------------------------------------------
bg_room_1
	shorta
	longi

	km_clrscreenflag	bgcolpal
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
	km_clrscreenflag	tutumode

;	km_cmpcheckgamestage	stg6
;	beq	.fortuna

	bg2scr	a11
	bg2chr	a11

;	bra	.common
;.fortuna
;	bg2scr	a28
;	bg2chr	a6
.common
	km_decrunchpal
	km_palette	col_2
	set_bg

	a16
	km_ldaslx	KGameMapPtr
	lda.l	RoomColourtbl,x
	sta	vram3addr
	a8
	lda	#a16_pac>>16
	sta	vram3addr+2
	ldx	#3*32
	stx	vram3len
	ldx	#4*16
	stx	palettestart
	jmp	depthmode_planet

RoomColourtbl
	dw	a23_pac&WM	;stage 1
	dw	a24_pac&WM	;stage 2
	dw	a25_pac&WM	;stage 3
	dw	a26_pac&WM	;stage 4
	dw	a27_pac&WM	;stage 5
	dw	a28_pac&WM	;stage 6
	dw	a16_pac&WM	;???
	dw	a16_pac&WM	;???
	dw	a16_pac&WM	;senkan
;---------------------------------------------------------------------------
	shorta
	longi
bg_tutu_1
	IFEQ	1	;not using
	km_clrscreenflag	bgcolpal
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
	km_setscreenflag	tutumode
	bg2scr	a12
	bg2chr	a11
	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a11,3,4
	jmp	depthmode_planet
	ENDC
;---------------------------------------------------------------------------
bg_missionsos1_1
bg_missionsos2_1
bg_missionsos3_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
;* cgx & scr & colour *
	lda.l	kx_NearPlanetNum
	cmp	#8
	beq	.NearPlanet
	cmp	#7
	bmi	.NearPlanet
	beq	.Asteroid
	bra	.SPACE

.NearPlanet
	bg2chr	a8
	bg2scr	a18
	bra	.skip
.Asteroid
	bg2chr	a4
	bg2scr	a9
	bra	.skip
.SPACE
	bg2chr	a8
	bg2scr	a8
	bra	.skip
.skip
	km_decrunchpal
	km_palette	col_2
	set_bg

	a16
	km_ldaslx.l	kx_NearPlanetNum
	lda.l	SOScolourTable,x
	sta	vram3addr
	a8
	lda	#a18_pac>>16
	sta	vram3addr+2
	ldx	#3*32
	stx	vram3len
	ldx	#4*16
	stx	palettestart
	jmp	depthmode_space

SOScolourTable
	dw	a8_pac&WM	;corneria	;0
	dw	a18_pac&WM	;stage 1	;1
	dw	a19_pac&WM	;stage 2	;2
	dw	a20_pac&WM	;stage 3	;3
	dw	a21_pac&WM	;stage 4	;4
	dw	a18_pac&WM	;stage 5	;5
	dw	a8_pac&WM	;stage 6	;6
	dw	a4_pac&WM	;asteroid	;7
	dw	a8_pac&WM	;corneria	;8
	dw	a8_pac&WM	;normal		;9
	dw	a18_pac&WM	;space1		;10
	dw	a19_pac&WM	;space2		;11
	dw	a20_pac&WM	;space3		;12
	dw	a21_pac&WM	;space4		;13
	dw	a8_pac&WM	;normal
	dw	a8_pac&WM	;normal
	dw	a8_pac&WM	;normal
;---------------------------------------------------------------------------
bg_missionextra1_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
;* cgx & scr & colour *
	bg2chr	a7
	bg2scr	a7

	km_decrunchpal
	km_blocktrans	(c1_pac),kx_palette2,256

	km_palette	col_2
	set_bg
	km_palette	a7,3,4

	km_setscreenflag	bgcolpal
	jmp	depthmode_space

;---------------------------------------------------------------------------
bg_missionextra2_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
;* cgx & scr & colour *

	bg2chr	a11	;a11
 	bg2scr	a11	;a12
	km_decrunchpal

;;;;	km_blocktrans	(c1_pac),kx_palette2,256

	km_palette	col_2
	set_bg

	km_palette	a11,3,4	;a12,3,4
	jmp	depthmode_planet

;---------------------------------------------------------------------------
bg_missionextra3_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
;* cgx & scr & colour *
	bg2chr	a11	;a10
	bg2scr	a11	;a10
	km_decrunchpal
	km_palette	col_2
	set_bg
;;;;	km_blocktrans	(c1_pac),kx_palette2,256
	km_palette	a11,3,4	;a10,3,4
	jmp	depthmode_planet

;---------------------------------------------------------------------------
bg_missionextra4_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
;* cgx & scr & colour *
	bg2chr	a11
	bg2scr	a11
	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a11,3,4
	jmp	depthmode_planet

;=====================================================================
;*		For Training BG Screen				*
;=====================================================================
bg_typeselect_1
	shorta
	longi
	IFEQ	1
;* bg mode *
	jsr	mode1h8
;* cgx & scr & colour *
	bg2chr	b2
	bg2scr	b2
	km_decrunchpal		;colour data decompress to MARIO RAM
	km_palette	b2	;BG Base Colour
	set_bg
	jmp	depthmode_planet_w0obj
	ENDC

bg_training_1
	shorta
	longi
	IFEQ	1
;* bg mode *
	jsr	mode2h16

;* cgx & scr & colour *
;	bg2chr	a14
;	bg2scr	a14
	km_decrunchpal
	km_palette	col_2
	set_bg
	km_palette	a14,3,4
	jmp	depthmode_planet
	ENDC
;=====================================================================
;*			Battle BG Screen			*
;=====================================================================
	shorta
	longi
bg_battlestage1_1
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2h16

;* cgx & scr & colour *
	bg2chr	a0
	bg2scr	a0
	km_decrunchpal
	km_palette	col_1
	set_bg
	km_palette	a0,3,4
	jmp	depthmode_planet
;----------------------------------------------------------------------
bg_battlestage2_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
;* cgx & scr & colour *
	bg2chr	a11
	bg2scr	a11
	km_decrunchpal
	km_palette	col_1
	set_bg
	km_blocktrans	(c1_pac),kx_palette2,256
	km_palette	a11,3,4	;a10,3,4
	jmp	depthmode_space
;----------------------------------------------------------------------
bg_battlestage3_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
;* bg mode *
	jsr	mode2v16
;* cgx & scr & colour *
	bg2chr	a11	;a10
	bg2scr	a11	;a10
	km_decrunchpal
	km_palette	col_1
	set_bg
	km_blocktrans	(c1_pac),kx_palette2,256
	km_palette	a11,3,4	;a10,3,4
	jmp	depthmode_planet

;----------------------------------------------------------------------
	IFEQ	1
bg_battlestage4_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
	jsr	mode2v16
	bg2chr	a8
	bg2scr	a8
	km_decrunchpal
	km_palette	col_1
	set_bg
	km_palette	a8,3,4
	jmp	depthmode_space
	ENDC
;----------------------------------------------------------------------
	IFEQ	1
bg_battlestage5_1
	shorta
	longi
;* game 3d  palette *
	km_gamepal	night
	jsr	mode2v16
	bg2chr	a13
	bg2scr	a13
	km_decrunchpal
	km_palette	col_1
	set_bg
	km_palette	a13,3,4
	set_palette

	set_zdepthtable	ground
	hofmode	nograd
	bg2Yscroll	0 ;232
	planet	marine	;(night,mist,desert,marine)
	ENDC
;=====================================================================
;*			3D megane BG screen			*
;=====================================================================
bg_3dglasses_1
	i16
;	jsr	mode1h8
;	palette	test3d,8,0
	jmp	depthmode_planet

;*********************************************************************
;*								*
;*			SET DEPTH MODE				*
;*								*
;*********************************************************************
;---------------------------------------------------------------------
;*			Planet Common Depth Mode		*
;---------------------------------------------------------------------
depthmode_planet
	shorta
	longi
	set_palette		;col data transfer
depthmode_planet_w0obj
	shorta
	longi
	km_palette	w0,8,8	;file,length,start
	set_palette		;col data transfer
	set_zdepthtable	ground	;depth mode (coltabs.asm)
depthmode_planet_night
;	info	hon,von,zon,nodots
	hofmode	nograd
	bg2Yscroll	0 	;232

	km_cmpcheckgamestage	STG3
	beq	depthmode_red
	planet	night		;(night,mist,desert,marine,red)
depthmode_red
	planet	red		;(night,mist,desert,marine,red)
;---------------------------------------------------------------------
;*			Planet Common Depth Mode		*
;---------------------------------------------------------------------
depthmode_space
	shorta
	longi
	set_palette		;col data transfer

depthmode_space_w0obj
	shorta
	longi
	km_palette	w0,8,8	;file,length,start
	set_palette		;col data transfer
depthmode_space_night
	shorta
	longi
	set_zdepthtable	space
;	info	hon,von,zon,nodots
	hofmode	nograd
	bg2Yscroll	0 	;232
	space	night		;(night,mist,desert,marine)


;*********************************************************************
;*								*
;*			SET BG MODE				*
;*								*
;*********************************************************************
mode1h8
	shorta
	longi
	init_bg	mode1,HORZ,8	;bg mode
	rts
mode1h16
	shorta
	longi
	init_bg	mode1,HORZ,16	;bg mode
	rts
mode2h16
	shorta
	longi
	init_bg	mode2,HORZ,16	;bg mode
	rts
mode2v16
	shorta
	longi
	init_bg	mode2,VERT,16	;bg mode
	rts
;----------------------------------------------------------
;----------------------------------------------------------
;----------------------------------------------------------
initmode1
	a8i16
	waittrans
	lda	#iv_irqsetmode1
	sta	trans_flag
	waittrans
	rts
	
initmode2	a8i16
	waittrans
	lda	#iv_irqsetmode2
	sta	trans_flag
	waittrans
	rts

dec_chr_l	php
	a16
	lda	#dec_base
	sta.l	m_decaddr
	a8
	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l
	plp
	rtl

dec_bg_l	php
	a16
	lda	#scr_offset
	sta.l	m_decoffset
	lda	#dec_base+bg2_cgx_len
	sta.l	m_decaddr
	a8
	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l
	plp
	rtl

dec_bg3_l	php
	a16
	lda	#0
	sta.l	m_decoffset
	lda	#dec_base+6144
	sta.l	m_decaddr
	a8
	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l
	plp
	rtl

dec_l	php
	a16
	lda	#dec_base
	sta.l	m_decaddr
	a8
	lda	#mdecrunch>>16
	ldx	#mdecrunch&WM
	jsl	runmario_l
	plp
	rtl
;--------------------------------------------------------------------------
bgbase	=	(*&~WM)+1

bg2chr	SHORTA
	LONGI

	a16
	pla
	tax
	clc
	adc	#7
	pha


	lda	#0
	sta.l	m_decoffset

	lda.l	bgbase+2,x
	and	#255
	sta.l	m_enddatabnk

	lda.l	bgbase,x
	sta.l	m_enddata

	lda.l	bgbase+3,x
	bne	.nodefault
	lda	vram_bg2_cgx
.nodefault
	sta	vram1addr
	lda.l	bgbase+5,x
	sta	vram1len

	a8
	jsl	dec_chr_l

	rts
;--------------------------------------------------------------------------
bg2scr	SHORTA
	LONGI

	a16
	pla
	tax
	clc
	adc	#7
	pha

	lda.l	bgbase,x
	sta.l	m_enddata
	lda.l	bgbase+2,x
	and	#255
	sta.l	m_enddatabnk
	lda.l	bgbase+3,x
	bne	.nodefault
	lda	vram_bg2_scr
.nodefault
	sta	vram2addr
	lda.l	bgbase+5,x
	sta	vram2len
	a8

	jsl	dec_bg_l

	rts
;--------------------------------------------------------------------------

;--------------------------------------------------------------------------
;* kawaguchi *
	IFEQ	1
bg2chrtbl	SHORTA
	LONGI
	a16
	lda	#0
	sta.l	m_decoffset

	lda	kz_tempaddrl+2
	and	#$ff
	sta.l	m_enddatabnk
	lda	kz_tempaddrl
	sta.l	m_enddata

	lda	kz_tpx
	bne	.nodefault
	lda	vram_bg2_cgx
.nodefault
	sta	vram1addr
	lda	kz_tpy
	sta	vram1len
	a8
	jsl	dec_chr_l
	rts
	ENDC
;=====================================================================
;*		Colour Data no kaitou				*
;=====================================================================
kdecrunchpal_l
	decrunch_palettes
	rtl
;----------------------------------------------------------
;----------------------------------------------------------
dopalette	SHORTA
	LONGI
	a16
	pla
	tax
	clc
	adc	#7
	pha

	lda.l	bgbase,x
	sta	vram3addr
	lda.l	bgbase+5,x
	sta	palettestart
	a8
	lda.l	bgbase+2,x
	sta	vram3addr+2
	a16
	lda.l	bgbase+3,x
	sta	vram3len

	decrunch_palettes
	a8
	waittrans


	IFEQ	1
;* Colour Palette Buffer ni Copy *
	a16
	lda	vram3len
	lsr	a
	sta	kcounter

	lda	palettestart
	asl	a
	tax
	ldy	vram3addr

	phb
	a8
	lda	vram3addr+2
	pha
	plb	; switch bank (70)
	a16
.loop
	lda.w	0,y
	sta.l	kx_palette,x
	inx
	inx
	iny
	iny
	dec	kcounter
	bne	.loop
	a8
	plb
	ENDC

;----------------------------------------------------------------------
	IFEQ	1
	lda	vram3addr
	clc
	adc	#7*32-1
	tay

	phy

	decrunch_palettes

	a8
	waittrans

	phb
	lda	vram3addr+2
	pha
	plb	; switch bank

	ldx	#7*32-1
.notfinished
	lda.w	0,y
	sta.l	pal0palette,x
	dey
	dex
	bpl	.notfinished
	
	plb
	ply

	ENDC

	rts

;-------------------------------------------------------------
;*		BG Set Sequence Table List		*
;-------------------------------------------------------------
bglists	dw	0
	db	0

	defbg	title
	defbg	typeselect
	defbg	training
	defbg	missionexplain
	defbg	missiongameover
	defbg	missioncontinue

	defbg	missionstage1
	defbg	missionstage2
	defbg	missionstage3
	defbg	missionstage4
	defbg	missionstage5
	defbg	missionstage6
	defbg	room
	defbg	tutu
	defbg	sun
	defbg	corneria

	defbg	missionextra1
	defbg	missionextra2
	defbg	missionextra3
	defbg	missionextra4
	defbg	missionsos1
	defbg	missionsos2
	defbg	missionsos3

	defbg	titledemo
	defbg	startenemydemo
	defbg	entermshipdemo
	defbg	startarwingdemo
	defbg	entermeteordemo
	defbg	attackcorneriademo
	defbg	explodecorneriademo

	defbg	battlestage1
	defbg	battlestage2
	defbg	battlestage3
;	defbg	battlestage4
;	defbg	battlestage5
	defbg	3dglasses

;;	defbg	level1
;;	defbg	level2
;;;;	defbg	mapscr

	dw	0,0	; terminate list

