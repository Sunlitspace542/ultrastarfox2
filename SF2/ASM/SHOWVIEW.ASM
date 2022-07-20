
;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         SHOWVIEW.ASM                                        ;
; AUTHOR:       Dylan Cuthbert                                      ;
; DESCRIPTION:  Code for generating a view                          ;
; DATE CREATED: 22-2-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;


	incpub	showview


; alien block variables have certain meanings if defined as a view
; al_sword1 = outdist (distance of camera from the point of view)
; al_sword2 = amount of ground dots
; al_sbyte4 = amount of space dust


;------------ MACROS

v_viewcheck	MACRO	[view]

	phx
	ldx	al_shape,y

	a8
	s_jmp_alsflag	y,noviewcheck,.maxrange\@
	romnastyoff
	a16

	lda.l	sh_size,x
	asl	a
	asl	a

	a8
	romnastyon
	a16

	clc
	adc	viewrange	; #viewradius
	cmp	#MAXMAPRANGE		; exceeded math limit?
	bcc	.notover\@
.maxrange\@
	a16
	lda	#MAXMAPRANGE
.notover\@
	sta	tpx
	asl	a
	sta	tpz

	s_jmp_NOTalsflag	y,view{view},.noleeway\@
	lda	tpx
	clc
	adc	#removal_leeway
	sta	tpx
	asl	a
	sta	tpz
.noleeway\@

	ldx	#viewblk{view}
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	clc
	adc	tpx
	cmp	tpz
	bcs	.notok\@

	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	clc
	adc	tpx
	cmp	tpz
	bcs	.notok\@

	a8
	s_set_alsflag	y,view{view}
	bra		.ok\@
.notok\@	a8
	s_clr_alsflag	y,view{view}

.ok\@
	plx
	ENDM


;==================
;---- SHOWVIEW ----
;==================


; generate view #1
showview1_l
	php
	a8
	lda	#0
	sta	v_whichview
	bra	showview_ram_l.in

; generate view #2
showview2_l
	php
	a8
	lda	screenmode
	bit	#sm_twoscreen
	bne	.twoscreen
	plp
	rtl
.twoscreen	lda	#1
	sta	v_whichview
	bra	showview_ram_l.in



; this generates a drawlist (runs in ram)

showview_ram_l
	php
.in	LOCAL
	phb
	a8
	storenasty
	nastyon
	lda	#$7e
	pha
	plb

	ai16
	stz	numshapes
	lda	shadowheight
	sta	v_shadowheight&WM
	lda	viewposy
	sta	v_viewposy&WM

	stz	numshapes	; clear alien count

	ldx	#ramdrawlist&WM
	ldy	allst
.next	a8
	sty	al1pt

; clear view flags
	lda.w	al_flags,y
	and	#~(afinrngpl+affrontpl+afinviewpl+afleftpl)
	ora	#affrontpl
	sta.w	al_flags,y

	s_jmp_alsflag	y,invisible,.nextal
	s_jmp_alsflag	y,removeme,.nextal

; ground obj?
	lda.w	al_type,y
	bit	#atgnd
	a16
	beq	.notgndobj
	lda	#15000
	bra	.gndobj
.notgndobj	lda	#0
.gndobj	sta.w	dl_sortz&WM,x

; copy x,y,z into the drawlist block
	lda.w	al_worldx,y
	sta.w	dl_xx&WM,x
	lda.w	al_worldy,y
	sta.w	dl_yy&WM,x
	lda.w	al_worldz,y
	sta.w	dl_zz&WM,x

	lda.w	al_shape,y
	sta.w	dl_shape&WM,x


; in range of view check
	a8
	lda	v_whichview
	lbeq	.view1

	test_alsflag	y,insidecockpit		; inside the cockpit?
	beq		.notinside2
	test_alsflag	y,player2
	lbne		.nextal

.notinside2

	v_viewcheck	2
	s_jmp_NOTalsflag	y,view2,.nextal
	brl	.inview

.view1
	test_alsflag	y,insidecockpit		; inside the cockpit?
	beq		.notinside1
	test_alsflag	y,player2
	lbeq		.nextal
.notinside1
	v_viewcheck	1
	s_jmp_NOTalsflag	y,view1,.nextal
.inview

	lda.w	al_rotx,y
	sta.w	dl_rotx&WM,x
	lda.w	al_roty,y
	sta.w	dl_roty&WM,x
	lda.w	al_rotz,y
	sta.w	dl_rotz&WM,x

	lda.w	al_flags,y
	and	#afexp
	beq	.noexp
	lda.w	al_count,y
	sta.w	dl_expcnt&WM,x

	bra	.partchk
.noexp
	lda	#0
	sta.w	dl_expcnt&WM,x
.partchk
;-----------------------------------------------
; put unique obj number in dl_shady if partobj.
	lda.w	al_sflags,y
	bit	#asf_partobj
	beq	.exploded

	a16
	tya
	sta.w	dl_shady&WM,x
	a8
	lda.w	al_sbyte1,y	; amount
	sta.w	dl_shadx&WM,x
	lda.w	al_sbyte2,y	; life
	sta.w	dl_shadx&WM+1,x
	lda.w	al_sbyte3,y	; type
	sta.w	dl_shadz&WM,x

;-----------------------------------------------

.exploded

	lda.w	al_sflags,y
	sta.w	dl_sflags&WM,x

; copy the animation and colour animation frames over
	lda.w	al_animframe,y
	bmi	.standardframe
	lda	gameframe
.standardframe
	and	#127
	sta.w	dl_animframe&WM,x

	lda.w	al_colframe,y
	bmi	.standardframe2
	lda	gameframe
.standardframe2
	and	#127
	sta.w	dl_colframe&WM,x

; copy the clipping plane flags in
	lda.w	al_clip,y
	sta.w	dl_clip&WM,x

; copy the depth offset in
	lda.w	al_depthoffset,y
	sta.w	dl_depth&WM,x

; texture map coordinates
	lda.w	al_tx,y
	sta.w	dl_tscrollx&WM,x
	lda.w	al_ty,y
	sta.w	dl_tscrolly&WM,x

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
	sta.w	dl_coltab&WM,x

; increment number of shapes
	inc	numshapes

; increment dl pointer
	txa
	clc
	adc	#dl_sizeof
	tax


.nextal
	a8
; mask out hitflash (only hitflashes for one frame)
; it doesn't care if the alien has been added to the drawlist or not
	lda	v_whichview
	bne	.noclr
	
	lda.w	al_sflags,y
	and	#~asf_hitflash
	sta.w	al_sflags,y
.noclr
	a16
; next alien block (if any)
	lda.w	_next,y
	tay
	lbne	.next
.out
	lda	numshapes
	sta.l	v_numshapes

	a8
	restorenasty
	plb
	plp


	rtl



;---------------------------------------------------------
; this copies the drawlist from ram to mario ram
copydrawlist_l
	php
	phb
	a8
	lda	#0
	pha
	plb

	storenasty
	nastyoff

	lda	#$70
	pha
	plb

	ai16


	ldx	#ramdrawlist&WM
	ldy	#m_drawlist&WM

	lda.l	numshapes
	sta	x1
	lbeq	.nowtdoing
.andagain

offss	=	0


	REPT	dl_sizeof/2
	lda.l	$7e0000+offss,x
	sta.w	offss,y

offss	=	offss+2
	ENDR

	txa
	clc
	adc	#dl_sizeof
	tax

	tya
	clc
	adc	#dl_sizeof
	tay

	dec	x1
	lbne	.andagain
	
.nowtdoing
	a8
	lda	#0
	pha
	plb
	restorenasty
	plb
	plp
	rtl
	


	longi
;---------------------------------------------------------
; GETVIEW1_L
; gets the view for player 1
getview1_l
	ldx	#viewblk1
	stx	viewblock
	jmp	getview_l

;---------------------------------------------------------
; GETVIEW2_L
; gets the view for player 2

getview2_l
	ldx	#viewblk2
	stx	viewblock
	jmp	getview_l

;---------------------------------------------------------
; GETVIEW_L
; gets the view for the current viewblock

getview_l
	php
	a16

	lda.l	v_shadowheight
	sta.l	m_shadowheight
	lda.l	v_viewposy
	sta.l	m_viewposy
	lda.l	v_numshapes
	sta.l	m_numshapes

	ldx	viewblock

	ldy	al_ptr,x
	lda.w	al_hp,y
	and	#255
	sta.l	m_playerHP


	lda	al_worldx,x
	sta	pviewposx

	lda	al_worldy,x
	sta	pviewposy

	lda	al_worldz,x
	sta	pviewposz

	lda	al_sword1,x
	globalscale_a
	sta	outdist

	lda	al_roty,x
	sta	outvy

	lda	al_rotx,x
	sta	outvx

	lda	al_rotz,x
	sta	outvz

	lda	pviewposx
	sta	viewposx

	lda	pviewposy
	sta	viewposy

	lda	pviewposz
	sta	viewposz

	lda	outvx
	sta	viewrotxw

	lda	outvy
	sta	viewrotyw

	lda	outvz
	sta	viewrotzw

	IFEQ	0

	a8i16
;***************************************************************
;* I'M SORRY BUT THESE ARE 2 VERY BIG HACKS, BECAUSE I DON'T WANT
;* TO FUCK WITH PETE'S CODE. (Giles) 


;* JUST X ROTATE VIEW POS.
	a16
	lda	viewrotxw
	nega
	sta matxw
	stz matyw
	stz matzw
	a8
	jsl crotmat16_l

	a16
	copymat16 mat,wmat

	stz	x1
	stz	y1
	lda	outdist
	nega
	sta	z1
	a8
	jsl	wmatrotp16_l

;***************************************************************


;* NOW JUST Y ROTATE VIEW POS.
	a16
	stz matxw
	lda	viewrotyw
	nega
	sta matyw
	stz matzw
	a8
	jsl crotmat16_l

	a16
	copymat16 mat,wmat

	lda	bigx
	sta	x1
	lda	bigy
	sta	y1
	lda	bigz
	sta	z1
	a8
	jsl	wmatrotp16_l
	add bigx,viewposx,viewposx
	add bigy,viewposy,viewposy
	add bigz,viewposz,viewposz

	ENDC

;***************************************************************

.fpos

	IFEQ	1
	ai16
	ldx	#viewblk
	stx	viewpt
	lda	viewposx
	sta	al_worldx,x
	lda	viewposy
	sta	al_worldy,x
	lda	viewposz
	sta	al_worldz,x


	a8

	lda	viewtype
	and	#viewtype_toobj
	beq	.ntpl

	ldy	viewtoobj
	a16
	jsl	Xanglexy_l
	nega
	sta	viewrotXw		
	sta	outvx	
	jsl	Yanglexy_l
	sta	viewrotYw		
	sta	outvy
	lda	outvz
	sta	viewrotZw

	a8
.ntpl
	ENDC


;***************************************************************




getviewrts


	a16
	lda	viewrotxw
	sta	matxw
	lda	viewrotyw
	sta	matyw
	lda	viewrotzw
	sta	matzw

	ai8
	jsl	crotmat16_l

	a16
	copymat16 mat,wmat

	lda	viewposx
	sta.l	m_viewposx

	lda	viewposz
	sta.l	m_viewposz

	lda	viewposy
	sta.l	m_viewposy

;*****************************************************************


	plp
	rtl


