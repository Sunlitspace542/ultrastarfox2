
	incpub	game

	IFEQ	1
getview_l
	a16


	ldx	#viewblk1

	lda	al_worldx,x
	sta	pviewposx

	lda	al_worldy,x
	sta	pviewposy

	lda	al_worldz,x
	sta	pviewposz

	lda	al_sword1,x
	sta	outdist

	lda	al_roty,x
	and	#255
	xba
	sta	outvy

	lda	al_rotx,x
	and	#255
	xba
	sta	outvx

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


;***************************************************************

.fpos

	ai16
	ldx #viewblk
	stx viewpt
	lda viewposx
	sta al_worldx,x
	lda viewposy
	sta al_worldy,x
	lda viewposz
	sta al_worldz,x


	a8

	lda	viewtype
	and	#viewtype_toobj
	rlbeq	.ntpl

	ldy	viewtoobj
	a16
	jsl		Xanglexy_l
	nega
	sta		viewrotXw		
	sta		outvx	
	jsl		Yanglexy_l
	sta		viewrotYw		
	sta		outvy
	lda		outvz
	sta		viewrotZw

	a8
.ntpl
	
	



;***************************************************************

	a16
	lda	viewrotxw
	nega
	sta matxw
	lda	viewrotyw
	nega
	sta matyw
	lda	viewrotzw
	nega
	sta matzw
	a8
	jsl crotmat16_l

	a16
	copymat16 mat,wmat


;***************************************************************




getviewrts


	a16
	lda viewrotxw
	sta matxw
	lda viewrotyw
	sta matyw
	lda viewrotzw
	sta matzw

	ai8
	jsl crotmat16_l

	a16
	copymat16 mat,wmat
	a8




;*****************************************************************
; cross hair calculation.


	php
	ai16
	ldx	playpt

	stz	y1
	lda	#crosshairdist
	sta	z1
	a8
	lda	al_rotx,x
	jsl	rotate_16yz_l

	a16
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1

	a8
	lda	al_roty,x
	jsl	rotate_16xz_l

	a16
	lda	x2
	clc
	adc	al_worldx,x
	sec
	sbc	viewposx
	sta.l	m_x1

	lda	y2
	clc
	adc	al_worldy,x
	sec
	sbc	viewposy
	sta.l	m_y1

	lda	z2
	clc
	adc	al_worldz,x
	sec
	sbc	viewposz
	sta.l	m_z1


	a8
	s_jmp_varNE	B,splayerflymode,#spfm_inside,.nin
	a16
	lda.l	m_y1
	clc
	adc	#inviewLaserYoff
	sta.l	m_y1	
	a8
.nin



	lda	#mwmatrotp16>>16
	ldx	#mwmatrotp16&$ffff
	jsl	runmario_l
	a16
	lda.l	m_bigx
	sta	x1
	lda.l	m_bigy
	sta.l	y1
	lda.l	m_bigz
	sta	z1

	ai8
	jsl	projectlog_l
	plp


	a16
	lda	xs
	sec
	sbc	#mvanishx
	sta	arsebandX

	lda	ys
	sec
	sbc	#mvanishy
	sta	arsebandY

	a8
	
;*****************************************************************


	rtl


	ENDC



	IFEQ	1

irotcentre
	ldx viewrotx
	lda sintab,x
	sta sinvx
	lda costab,x
	sta cosvx

	ldx viewroty
	lda sintab,x
	sta sinvy
	lda costab,x
	sta cosvy

	ldx viewrotz
	lda sintab,x
	sta sinvz
	lda costab,x
	sta cosvz


; z

;	lda viewrotz
;	lbeq irotcen3

	mulslog168 x1,cosvz
	lda m4
	sta bigx
	lda m5
	sta bigx+1
	mulslog168 y1,sinvz
	lda m4
	clc
	adc bigx
	sta bigx
	lda m5
	adc bigx+1
	sta bigx+1

	mulslog168 x1,sinvz
	lda m4
	sta bigy
	lda m5
	sta bigy+1
	mulslog168 y1,cosvz
	lda m4
	sec
	sbc bigy
	sta bigy
	lda m5
	sbc bigy+1
	sta bigy+1

	mov bigx,x1
	mov bigy,y1


irotcen3


; x

;	lda viewrotx
;	lbeq irotcen2

	mulslog168 z1,sinvx
	lda m4
	sta bigy
	lda m5
	sta bigy+1
	mulslog168 y1,cosvx
	lda m4
	clc
	adc bigy
	sta bigy
	lda m5
	adc bigy+1
	sta bigy+1

	mulslog168 y1,sinvx
	lda m4
	sta bigz
	lda m5
	sta bigz+1
	mulslog168 z1,cosvx
	lda m4
	sec
	sbc bigz
	sta bigz
	lda m5
	sbc bigz+1
	sta bigz+1


	mov bigz,z1
	mov bigy,y1

irotcen2

; y

	mulslog168 x1,sinvy
	lda m4
	sta bigz
	lda m5
	sta bigz+1
	mulslog168 z1,cosvy
	lda m4
	clc
	adc bigz
	sta bigz
	lda m5
	adc bigz+1
	sta bigz+1

	mulslog168 z1,sinvy
	lda m4
	sta bigx
	lda m5
	sta bigx+1
	mulslog168 x1,cosvy
	lda m4
	sec
	sbc bigx
	sta bigx
	lda m5
	sbc bigx+1
	sta bigx+1

;	mov y1,bigy
;	mov bigx,x1
;	mov bigz,z1

	rts



	ENDC

;
; 6502 MATHS LIBRARY
;
; by P. R. Warnes, Copyright 1990
;


	IFEQ	1
muls8log_l
	jsr	muls8log
	rtl
muls8log 
	ldx m1
	beq muls8log1
	ldy m2
	beq muls8log2
	lda logtab8s,x
	clc
	adc logtab8s,y
	tay
	txa
	ldx alogtab8s,y
	eor m2
	bpl muls8log1
	ldx nalogtab8s,y
muls8log1 
	stx m3
	rts
muls8log2
	ldx #0
	stx m3
	rts


muls816log0y 
	ldx #0
muls816log0 
	stx m3
	stx m4
	rts
	
muls816log_l
	jsr	muls816log
	rtl
muls816log 
	ldx m1
	beq muls816log0
	ldy m2
	beq muls816log0y
	lda logtab8s,x
	clc
	adc logtab8s,y
	tay
	txa
	ldx alogtab8s,y
	eor m2
	bpl muls816log1
	ldx nalogtab8s,y
muls816log1 
	stx m3
	ldx alogtab8sl,y
	cmp #0
	bpl muls816log2
	ldx nalogtab8sl,y
muls816log2 
	stx m4
	rts


	ENDC
muls816log16_l
	jsr	muls816log16
	rtl
muls816log16
	stz	m6
	stz	m7
	mla16mac	m1,m3,m4,m6
	rts


