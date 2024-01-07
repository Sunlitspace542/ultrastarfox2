
; strategy routines that must run in ram

	incpub	ramsrou



;��������������������������������������������������������������
; The following code is ripped out of GetHeight_l in
; slopes.asm in order for it to run in parallel with the FX chip
;��������������������������������������������������������������


	LONGA
	LONGI
slope_init_l

	a8
	nastyon
	a16
;��������������������������������������������������������������������������
; set defaults: ie. ground
;��������������������������������������������������������������������������

	pl_test_planetmode	space
	beq			.space
	lda	#MAGIC_Y
	bra	.setit
.space	lda	#16384
.setit	sta	closestslopeheight

	stz	closestslope
	stz	closestslopenum
	stz	currentslope
	lda	#0
	sta	currentslopetype
	sta	closestslopetype
	sta	currentslopex1
	sta	currentslopez1
	sta	closestslopex1
	sta	closestslopez1
	sta	currentslopex2
	sta	currentslopez2
	sta	closestslopex2
	sta	closestslopez2
	sta	closestslopepoly
	sta	currentslopepoly
	stz	y1
;��������������������������������������������������������������������������
; set normal for ground
;��������������������������������������������������������������������������
	lda	#$8000
	sta	tmp_sprb
	lda	#0
	sta	tmp_spra
	sta	tmp_sprc
;��������������������������������������������������������������������������
; set angle for ground (0)
;��������������������������������������������������������������������������
	sta	tmp_rotx
	sta	tmp_rotz

	lda	al_worldx,x
	sta	x1
	lda	al_worldz,x
	sta	z1
	lda	al_shape,x
	sta	tpa
	stx	tpx

	a8
	nastyoff
	a16
	
	rtl


	LONGA
	LONGI
slope_check_l
;��������������������������������������������������������������������������
; find the nearest alien. (this should be modified to search through the
; hitlist but currently it is kept to allow the shadow to be correctly
; mapped to the nearest surface)
;��������������������������������������������������������������������������
	a8
	nastyon
	a16

.nxtal
;��������������������������������������������������������������������������
; don't check itself
;��������������������������������������������������������������������������
	cpx	tpx
	beq	.notthisone

	test_alcollflags	x,acf_firstframe
	bne	.notthisone

	test_alsflag		x,notslope
	bne	.notthisone

	ldy	al_shape,x

;��������������������������������������������������������������������������
; shapex+xradius-objx>xradius*2?
;��������������������������������������������������������������������������
	a8
	romnastyoff
	a16

	lda.w	sh_xmax,y
	sta	x2

	a8
	romnastyon
	a16

	lda	x2
	clc
	adc	al_worldx,x
	asl	x2
	sec
	sbc	x1
	cmp	x2
	bcs	.notthisone

;��������������������������������������������������������������������������
; shapez+zradius-objz>zradius*2?
;��������������������������������������������������������������������������
	a8
	romnastyoff
	a16

	lda.w	sh_zmax,y
	sta	x2

	a8
	romnastyon
	a16

	lda	x2
	clc
	adc	al_worldz,x
	asl	x2
	sec
	sbc	z1
	cmp	x2
	bcc	.gotone

.notthisone
	lda	_next,x
	tax
	bne	.nxtal

.gotone
	a8
	nastyoff
	a16
	rtl





;�������������������������������������������������
; 31 bit Unsigned divide
; 31 bit divided by 15 bit giving 15 bit result
;
; In:	dividend unsigned 31 bit
;	divisor  unsigned 15 bit
; Out:	quotient unsigned 15 bit
; Uses: A,X
; Cycles:	47 + 16*21 = 383 max


dividend = divdnd
divisor  = divsor

divmac	macro
	rol	dividend	; 7
	rol	a		; 2
	tax			; 2
	clc			; 2
	adc	divisor		; 4
	bcs	\@		; 2/3
	txa			; 2	= 21/20
\@
	endm


divu3115_l
	php
	a8
	storenasty
	nastyon
	jsr	divu3115
	restorenasty
	plp
	rtl

divu3115
	phx
	php
	ai16

	lda	#0
	sec
	sbc	divisor
	sta	divisor

	lda	dividend+2

	asl	dividend	; 7
	rol	a		; 2
	tax			; 2
	clc			; 2
	adc	divisor		; 4
	bcs	div1		; 2/3
	txa			; 2	= 21/20
div1

	rept	15
	divmac
	endr

	lda	dividend
	rol	a
	sta	quotient
	stz	quotient+2	

	plp
	plx
	rts	



;-----------------------------------------------
; 16 bit arctan (x1/y1)
;
; A = arctan(x1/y1)
;
; 0 to 359 degrees is $0000 to $ffff
; x1 and y1 are signed words
;
;    Calls	mdivu3115
;
; in:	x1,y1
;out:	A = angle
;uses: xx2,yy2
;table: arctantab



xx2	equ	dividend+2
yy2	equ	divisor

arctan16_l
	php
	a8
	storenasty
	nastyon
	jsr	arctan16a
	a16
	sta	textpt
	a8
	restorenasty
	a16
	lda	textpt
	plp
	rtl

arctan16a
	phx
	phy
	php
	ai16

	lda	y1	; if (y1=0)
	bne	.21

	lda	#deg90<<8 ; then angle=deg90
	bra	.4
.21
	bpl	.2	; y2=abs(y1)
	eor	#-1
	inc	a
.2
	sta	yy2

	lda	x1
	bpl	.1	; x2=abs(x1)
	eor	#-1
	inc	a
.1
;	sta	xx2

	ldy	#0	; y=0
	cmp	yy2
	bne	.7	; if (y2=x2)

	lda	#deg45<<8 ; then angle=deg45
	bra	.4
.7
	bmi	.3	; if (x2>y2) then

	dey		; y=-1
	ldx	yy2	; swap x2,y2
	sta	yy2
	txa
.3
	stz	dividend
	lsr	a
	ror	dividend
	lsr	a
	ror	dividend
	sta	dividend+2

	jsr	divu3115	; quotient = (x2<<14)/y2

	lda	quotient
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	and	#$fffe
	tax

	a8
	romnastyoff
	a16

	lda.l	arctantab,x
	sta	yy2	; y2=angle

	a8
	romnastyon
	a16

	cpy	#0	; if (y<0) 
	bpl	.41

	lda	#deg90<<8 ; then y2=deg90-y2
	sec
	sbc	yy2
.4
	sta	yy2
.41
	lda	x1
	eor	y1
	bpl	.5	; if (x1^y1 < 0)

	lda	#0	; then y2=-y2
	sec
	sbc	yy2
	sta	yy2
.5
	lda	y1
	bpl	.6	; if (y1<0)

	lda	yy2	; y2+=deg180
	clc
	adc	#deg180<<8
	sta	yy2
.6
	lda	yy2
	plp
	ply
	plx
	rts


arctan16m_l
	php
	jsr	arctan16	
	plp
	rtl



;-----------------------------------------------
; 16 bit arctan (x1/y1)
; a = arctan(x1/y1)
;
; 0 to 359 degrees is $0000 to $ffff
; x1 and y1 are signed
;
; tmpx,x1,x2,x3,y1,y2,px,pz,pr

arctan16
sarctan
	phx
	php

	a8
	poll_mario

	a16
	lda	x1
	sta.l	m_x1
	lda	y1
	sta.l	m_y1

	a8i16
	lda	#mcallarctan16>>16
	ldx	#mcallarctan16&$ffff
	jsl	runmario_l
	
	a16
	lda.l	m_cnt
	sta	textpt

	a8
	unpoll_mario

	a16
	lda	textpt

	plp
	plx
	rts



;*****************************************************************************
;* find_object
;*
;*
;* entry:		ai16
;* 	A    : shape number.
;*	fobj   : first object.
;*
;* exit:		ai16
;*	X : not changed.
;*	Y : ptr. to object. (0=not found)
;*	fobj   : ptr to object.
;*


	LONGA
	LONGI
find_object_l
findtarget_l
	stx	tpx
	ldx	fobj
	beq	bad_fobj

	cmp	#0
	beq	get_anyobj


	txy
.loop	cmp	al_shape,x
	beq	.gotone
.next	ldy	_next,x
	tyx
	bne	.loop
.gotone	cpx	tpx
	beq	.next
	ldy	_next,x
	sty	fobj
	txy
	ldx	tpx
	rtl	

bad_fobj	ldy	#0
	sty	fobj
	ldx	tpx
	rtl


get_anyobj
	ldy	_next,x
	beq	bad_fobj
	tyx
	cpx	tpx
	beq	get_anyobj

	lda_sflags	x,realobj
	and	#asf_realobj
	beq	get_anyobj

	stx	fobj
	ldx	tpx
	rtl


;*****************************************************************************
;* find_Mobject
;*
;*
;* entry:		ai16
;* 	A    : shape number.
;*	X1   : SFLAGS mask
;*	fobj   : first object.
;*
;* exit:		ai16
;*	X : not changed.
;*	Y : ptr. to object. (0=not found)
;*	fobj   : ptr to object.
;*


	LONGA
	LONGI
find_Mobject_l
	cmp	#0
	beq	get_anyMobj

	stx	tpx
	ldx	fobj
	lbeq	bad_fobj
	txy
.loop	cmp	al_shape,x
	beq	.gotone
.next	ldy	_next,x
	tyx
	bne	.loop

.gotone	
	cpx	tpx
	beq	.next
	sta	tpa
	a8
	lda	al_sflags,x
	and	x1
	a16
	bne	.got_mobj
	lda	tpa
	bra	.next
.got_mobj	
	ldy	_next,x
	sty	fobj

	txy
	ldx	tpx
	rtl	


get_anyMobj		   	
	stx	tpx
	ldx	fobj
	lbeq	bad_fobj
	txy
	a8
.loop	
	cpx	tpx
	beq	.next
	lda	al_sflags,x
	and	x1
	bne	.got_mobj

.next	ldy	_next,x
	tyx
	bne	.loop
	
.got_mobj	
	ldy	_next,x
	sty	fobj
	txy
	ldx	tpx
	a16
	rtl


;*****************************************************************************
;* find_nearobject
;*
;*
;* entry:		ai16
;* 	A 	: shape number.
;*	TPZ	: min radius. less than 8000
;*	TPX	: max radius. less than 8000
;*	fobj      : first object.
;*
;* exit:		ai16
;*	X	: not changed.
;*	Y 	: ptr. to object. (0=not found)
;*	fobj   : ptr to object.
;*

	LONGA
	LONGI
find_nearobject_l
findntarget_l

	stx	x2		; store current object.
	ldx	fobj		; first object list.
	lbeq	badfend

	cmp	#0
	beq	find_anynearobject_l

	sta	y2
	stz	tpy		; nearest object

.loop	
	cpx    	x2
	beq	.not_near

	lda	al_shape,x
	cmp	y2
	bne	.not_near

	ldy	x2
	jsl	xzdiffs_l
	a16

	lda	rangexz
	cmp	tpx
	bpl	.not_near
	cmp	tpz
	bmi	.not_near
	sta	tpx
	stx	tpy
.not_near

	ldy	_next,x
	tyx
	bne	.loop
	ldy	_next,x
	sty	fobj
	ldy	tpy
     	ldx	x2
	rtl
	
badfend	ldy	#0
	ldx	x2		
	rtl


;*****************************************************************************
;* find_anynearobject
;*
;*
;* entry:		ai16
;*	TPX	: max radius. less than 8000
;*	fobj      : first object.
;*
;* exit:		ai16
;*	X	: not changed.
;*	Y 	: ptr. to object. (0=not found)
;*	fobj   : ptr to object.
;*

	LONGA
	LONGI
find_anynearobject_l
	stz	tpy		; nearest object

.loop	
	cpx	x2
	beq	.not_near

	lda_sflags	x,realobj
	and	#asf_realobj
	beq	.not_near

	ldy	x2
	jsl	xzdiffs_l
	a16

	lda	rangexz
	cmp	tpx
	bpl	.not_near
	cmp	tpz
	bmi	.not_near
	sta	tpx
	stx	tpy
.not_near

	ldy	_next,x
	tyx
	lbne	.loop
	sty	fobj

	ldy	tpy
     	ldx	x2
	rtl




;*****************************************************************************
;* find_radiusobject
;*
;*
;* entry:		ai16
;* 	A 	: shape number.
;*	TPZ	: min radius. less than 8000
;*	TPX	: max radius. less than 8000
;*	fobj      : first object.
;*
;* exit:		ai16
;*	X	: not changed.
;*	Y 	: ptr. to object. (0=not found)
;*	fobj   : ptr to object.
;*

	LONGA
	LONGI
find_radiusobject_l

	stx	x2		; store current object.
	ldx	fobj		; first object list.
	lbeq	badfend

	cmp	#0
	beq	find_anyradiusobject_l

	sta	y2
	stz	tpy		; nearest object

.loop	
	cpx    	x2
	beq	.not_near

	lda	al_shape,x
	cmp	y2
	bne	.not_near

	ldy	x2
	jsl	xzdiffs_l
	a16

	lda	rangexz
	cmp	tpx
	bpl	.not_near
	cmp	tpz
	bpl	.found
.not_near

	ldy	_next,x
	tyx
	bne	.loop

.found	ldy	_next,x
	sty	fobj
	txy
     	ldx	x2
	rtl
	
;*****************************************************************************
;* find_anyradiusobject
;*
;*
;* entry:		ai16
;*	TPX	: max radius. less than 8000
;*	fobj      : first object.
;*
;* exit:		ai16
;*	X	: not changed.
;*	Y 	: ptr. to object. (0=not found)
;*	fobj   : ptr to object.
;*

	LONGA
	LONGI
find_anyradiusobject_l

.loop	
	cpx	x2
	beq	.not_near

	lda_sflags	x,realobj
	and	#asf_realobj
	beq	.not_near

	ldy	x2
	jsl	xzdiffs_l
	a16

	lda	rangexz
	cmp	tpx
	bpl	.not_near
	cmp	tpz
	bpl	.found
.not_near

	ldy	_next,x
	tyx
	lbne	.loop

.found	ldy	_next,x
	sty	fobj
	txy
     	ldx	x2
	rtl


;*****************************************************************************
;* find_shape_l
;*
;* entry:	ai16
;*	A : shape.
;*
;* exit:		ai16
;*	X : ptr to obj
;*	uses Y
;*	
;*
	longa
	longi
find_shape_l
	php
	ldy	allst
.findloop
	tyx
	cmp	al_shape,x
	beq	.foundobj
	ldy	_next,x
	bne	.findloop
	ldx	#0
.foundobj	
	plp
	rtl

;*****************************************************************************
;* find_enemynearobject( T.Kawagoe )
;*
;*
;* entry:		ai16
;*	TPX	: max radius. less than 8000
;*	TPX	: min radius.
;*	fobj      : first object.
;*	Z2	: if -range(rotx)�< "X1"  <range� then chase.
;*	Z1	: if -range(roty)�< "Z1"  <range� then chase.
;*
;* exit:		ai16
;*	X	: not changed.
;*	Y 	: ptr. to object. (0=not found)
;*	fobj   : ptr to object.
;*

	LONGA
	LONGI

find_enemynearobject_l

	stz	tpy		; nearest object
	stx	x2		; store current object.

	ldx	allst

.loop	cpx	x2
	rlbeq	.not_near

	lda_sflags	x,realobj
	and	#asf_realobj
	rlbeq	.not_near

	ldy	x2
	jsl	xzdiffs_l
	a16

	lda	rangexz
	cmp	tpx
	rlbpl	.not_near
	cmp	tpz
	rlbmi	.not_near

;**************************************
; check enemy or not.

; roty
	a16
	lda	al_worldx,x
	sec
	sbc.w	al_worldx,y
	sta	x1
	lda	al_worldz,x
	sec
	sbc.w	al_worldz,y
	sta	y1
	a8

	jsl	arctan16_l

	a8
	xba
	sta	x1


	lda	z1	; get the range
	clc
	adc.w	al_roty,y	; add y rotation
	clc
	adc	x1	; sub angle returned by arctan
	asra
	cmp	z1	; double the range and compare (+- range)

	rlbcs	.notenemy

; rotx
	phx
	phy
	jsl	xzdiffs_l
	a16
	lda	rangexz
	sta	y1
	lda.w	al_worldy,y
	sec
	sbc	al_worldy,x
	sta	x1
	jsl	arctan16_l
	ai16	
	ply
	plx


	a8
	xba
	sta	x1

	lda	z2	; get the range
	clc
	adc.w	al_rotx,y	; add y rotation
	clc
	adc	x1	; sub angle returned by arctan
	asra
	cmp	z2	; double the range and compare (+- range)

	rlbcs	.notenemy


; current obj TO nearest obj ga ryou-hou ENEMY2 dattara search sinai.

	s_jmpnot_colltype	y,ENEMY2,.notenemy2
	s_jmp_colltype		x,ENEMY2,.notenemy
.notenemy2


	s_jmp_alcollflag	x,WEAPON,.notenemy
	s_jmpnot_colltype	x,ENEMY1,.notenemy
	s_jmp_colltype		x,FRIEND,.notenemy
	s_jmp_colltype		x,LASER,.notenemy
	s_jmp_alsflag		x,colldisable,.notenemy
	s_jmp_alsflag		x,nohitaffect,.notenemy

;	cpy		playpt1
;	beq		.notenemy
;	cpy		playpt2
;	beq		.notenemy
;	cpy		dummyobj
;	beq		.notenemy


	a16
	lda	rangexz
	sta	tpx
	stx	tpy
.notenemy	a16
;**************************************

.not_near

	ldy	_next,x
	tyx
	rlbne	.loop
	sty	fobj


	ldy	tpy
     	ldx	x2
	rtl



;*****************************************************************************
;* anglexy_off
;*
;*
;* entry:		a8i16
;* 	x2 : X offset
;*	z2 : Z offset
;*	X  : obj 1
;*	Y  : obj 2
;*
;* exit:		a8i16
;*	A  : 8 bit angle
;* 	x2 : X offset
;*	z2 : Z offset
;*	X  : obj 1
;*	Y  : obj 2
;*
;*
;*

anglexy_off_l
	phx
	phy
	
	jsl	xzdiffs_l

	a16
	lda	x1
	clc
	adc	x2
	sta	x1

	lda	y1
	clc
	adc	z2
	sta	y1


	jsl	arctan16_l
	a16
	xba
	and	#$ff
	a8i16
	ply
	plx
	rtl

;*****************************************************************************
;* anglexy_abs
;*
;*
;* entry:		a8i16
;* 	x2 : X position
;*	z2 : Z position
;*	X  : obj 1
;*
;* exit:		a8i16
;*	A  : 8 bit angle
;* 	x2 : X pos
;*	z2 : Z pos
;*	X  : obj 1
;*
;*
;*

	LONGI
anglexy_abs_l
	phx
	phy
	
	jsl	xzdiffs_abs_l

	jsl	arctan16_l
	a16
	xba
	and	#$ff
	a8i16
	ply
	plx
	rtl


;*****************************************************************************
;* add_objvecs	- add vecs of obj1 to obj2
;*
;*
;* entry:		a8i16
;*	X  		: obj 2
;*	Y		: obj 1
;*
;* exit:		a8i16
;*	X  		: obj 2
;*	Y		: obj 1
;*
;*

	LONGI
add_objvecs_l
	a16
	stx	tpx
	tyx
	ldy	tpx

	lda	al_vx,x
	sta	x1	
	lda	al_vy,x
	sta	y1	
	lda	al_vz,x
	sta	z1    
	
	stx	tpx
	tyx
	ldy	tpx

	lda	al_vx,x
	clc
	adc	x1	
	sta	al_vx,x
	lda	al_vy,x
	clc
	adc	y1	
	sta	al_vy,x
	lda	al_vz,x
	clc
	adc	z1	
	sta	al_vz,x

	a8
	rtl




	
	



sr_addplayerZx
	s_add_alvar		W,x,al_worldz,pviewvelz
	rtl
sr_addplayerZy
	s_add_alvar		W,y,al_worldz,pviewvelz
	rtl


;*****************************************************************************
;* anglexy
;*
;* entry: a8i16
;*	 
;*	 x : obj1 
;*	 y : obj2 
;*	 
;*	 
;*
;* exit:  a8i16
;*	 
;*	 x : obj1 
;*	 y : obj2 
;*	 A : y angle.
;*	 
;*		
;*

	shorta
	longi
anglexy_l  
Yanglexy_l
	phx
	phy
	a16	
	
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	sta	x1

	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	sta	y1

	jsl	arctan16_l
	ai16
	ply
	plx
	rtl

;*****************************************************************************
;* Xanglexy
;*
;* entry: a8i16
;*	 
;*	 x : obj1 
;*	 y : obj2 
;*	 
;*	 
;*
;* exit:  ai16
;*	 
;*	 x : obj1 
;*	 y : obj2 
;*	 A : x angle.
;*	 
;*		
;*

	shorta
	longi
Xanglexy_l  
	phx
	phy
	
	jsl	xzdiffs_l
	a16
	lda	rangexz
	sta	y1
	lda.w	al_worldy,y
	sec
	sbc	al_worldy,x
	sta	x1
	jsl	arctan16_l
	ai16	
	ply
	plx
	rtl
	

;*****************************************************************************
;* Xangleabs
;*
;* entry: a8i16
;*	 
;*	 x : obj1 
;*	 x2 : position
;*	 y2 : 
;*	 z2 : 
;*	 
;*	 
;*
;* exit:  a8i16
;*	 
;*	 x : obj1 
;*	 A : x angle.
;*	 
;*		
;*

	shorta
	longi
Xanglexabs_l  
	phx
	phy
	
	jsl	xzdiffs_abs_l
	a16
	lda	rangexz
	sta	y1
	lda.w	y2
	sec
	sbc	al_worldy,x
	sta	x1
	jsl	arctan16_l
	a16	
	sta	tpx
	xba
	and	#$ff
	a8i16
	ply
	plx
	rtl



;*****************************************************************************
;* Yangleabs
;*
;* entry: a8i16
;*	 
;*	 x : obj1 
;*	 x2 : position
;*	 z2 : 
;*	 
;*	 
;*
;* exit:  a8i16
;*	 
;*	 x : obj1 
;*	 A : y angle.
;*	 
;*		
;*

	shorta
	longi
Yanglexabs_l  
	phx
	phy
	
	a16
	
	lda.w	x2
	sec
	sbc	al_worldx,x
	sta	x1

	lda.w	z2
	sec
	sbc	al_worldz,x
	sta	y1

	jsl	arctan16_l
	a16	
	sta	tpx
	xba
	and	#$ff
	a8i16
	ply
	plx
	rtl




;-------------------------------------------------------------------------------

find_alptr_l
	php
	ai16
	txa
	ldy	allst
.carryon
	tyx
	cmp	al_ptr,x
	beq	.found
	ldy	_next,x
	bne	.carryon
	ldx	dummyobj
.found
	txy
	tax
	plp
	rtl

	shorta


;-------------------------------------------------------------------------------


;--------------------------------------------------------------------

child_rotpos_l
	phy

	s_set_objtobemother	y,x

	a16
	lda	al_childrotobj,x
	beq	.ok
	stx	x1
	cmp	x1
	lbeq	.norot
	tay
.ok	a8


	s_copy_alvar2var	W,x,x1,al_childx
	s_copy_alvar2var	W,x,y1,al_childy
	s_copy_alvar2var	W,x,z1,al_childz
	s_copy_pos		x,y

	lda	al_childrotx,x
	clc
	adc.w	al_rotx,y
	sta	al_rotx,x

	lda	al_childroty,x
	clc
	adc.w	al_roty,y
	sta	al_roty,x

	lda	al_childrotz,x
	clc
	adc.w	al_rotz,y
	sta	al_rotz,x

	IFEQ	0

; set the angles up for the rotation
	s_copy_alvar2var	B,y,matxw+1,al_rotx
	s_copy_alvar2var	B,y,matyw+1,al_roty
	s_copy_alvar2var	B,y,matzw+1,al_rotz

	stz	matxw
	stz	matyw
	stz	matzw

	s_rotate_16bit

	s_add_alvar	W,x,al_worldx,bigx
	s_add_alvar	W,x,al_worldy,bigy
	s_add_alvar	W,x,al_worldz,bigz

	ENDC

;	s_add_roffs2pos		B,x,y,y,x1,y1,z1,1,1,1,childscale,childscale,childscale

.norot
	a8
	ply
	rtl

;--------------------------------------------------------------------

	SHORTA
rotpos_allchildren_l
	phy
	phx

	POLL_MARIO
.again
	ldy	al_sword1,x
	beq	.finished
	tyx
	
	jsl	child_rotpos_l
	bra	.again
.finished
	UNPOLL_MARIO
	plx
	ply
	rtl



;------------------------------------------------------------------
; input: x=alien ptr
; input: a=resource type
; exit:  y=address of resource
	longi
	shorta
scanresources_l
	a8
	sta	restemp+1
	ldy	al_resources,x
	beq	.exit
	lda.w	heap,y
	sta	restemp
.chkloop
	iny
	lda.w	heap,y
	cmp	restemp+1
	beq	.exit
	iny
	iny
	iny
	dec	restemp
	bne	.chkloop
	ldy	#0
.exit
	rtl
;------------------------------------------------------------------
; input: x=alien ptr
; input: a=resource type
; exit:  y=address of new resource
setresource_l
	a8
	sta	restemp+1
	ldy	al_resources,x
	beq	.createnew
	lda.w	heap,y
	sta	restemp
;���������������������������������������������������������������������
; Search for existing resource with same type
;���������������������������������������������������������������������
.chkloop
	iny
	lda.w	heap,y
	cmp	restemp+1
	beq	.exit
	iny
	iny
	iny
	dec	restemp
	bne	.chkloop
;���������������������������������������������������������������������
; if none found then add a new one
;���������������������������������������������������������������������
	ldy	al_resources,x
	lda.w	heap,y
	inc	a
	a16
	and	#255
	asl	a
	asl	a
	inc	a
	s_realloc	x,y,a
	bra	.calcaddr
;���������������������������������������������������������������������
; if none found then create a new one
;���������������������������������������������������������������������
.createnew	SHORTA
	s_alloc	x,Y,#5
	lda	#0
	sta.w	heap,y
;���������������������������������������������������������������������
; a resource has now been added so store the pointer,
; increment the count and return
;���������������������������������������������������������������������
.calcaddr	a16
	tya
	sta	al_resources,x
	a8
	lda.w	heap,y
	inc	a
	sta.w	heap,y
	dec	a
	a16
	and	#255
	asl	a
	asl	a
	clc
	adc	al_resources,x
	inc	a
	tay
	a8
	lda	restemp+1
	sta.w	heap,y	; store the resource type

.exit	rtl
	
;------------------------------------------------------------------


;**********************************************************************************
	shorta
	longi
sr_speedto
          	sta	tpx

	lda	al_vel,x
	sec
	sbc	tpa
	beq	.nsc

	bpl	.nneg
	nega
.nneg
	cmp	tpx
	bpl	.sc
	
	lda	tpa
	bra	.fs

.sc	lda	al_vel,x
	cmp	tpa
	Fchase_A	tpa,tpx

.fs	sta 	al_vel,x
	clc
	rtl
.nsc
	sec
	rtl


;*****************************************************************************
;* xzdiffs_off
;*
;*
;* entry:		a8i16
;*	X  		: obj 1
;*	Y  		: obj 2
;* x2,z2		: x,z offsets
;*
;*
;* exit:		a8i16
;*	X  	: obj 1
;*	Y  	: obj 2
;*	rangexz : distance. 
;*
;*


	LONGI
xzdiffs_off_l
	a16
	lda.w	al_worldx,y
	clc
	adc	x2
	sec
	sbc	al_worldx,x
	sta	x1
	bpl	.px
	lda	#0
	sec
	sbc	x1
.px	sta	rangexz

	lda.w	al_worldz,y
	clc
	adc	z2
	sec
	sbc	al_worldz,x
	sta	y1
	bmi	.ny
	clc
	adc	rangexz
	bra	.x
.ny	sec
	lda	rangexz
	sbc	y1
.x	sta	rangexz
	a8
	rtl


;*****************************************************************************
;* xzdiffs_abs
;*
;*
;* entry:		a8i16
;*	X  		: obj 1
;* 	x2,z2		: x,z position
;*
;*
;* exit:		a8i16
;*	X  	: obj 1
;*	rangexz : distance. 
;*
;*


	LONGI
xzdiffs_abs_l
	a16
	lda	x2
	sec
	sbc	al_worldx,x
	sta	x1
	bpl	.px
	lda	#0
	sec
	sbc	x1
.px	sta	rangexz

	lda	z2
	sec
	sbc	al_worldz,x
	sta	y1
	bmi	.ny
	clc
	adc	rangexz
	bra	.x
.ny	sec
	lda	rangexz
	sbc	y1
.x	sta	rangexz
	a8
	rtl

;*****************************************************************************
;* xydiffs_abs
;*
;*
;* entry:		a8i16
;*	X  		: obj 1
;* 	x2,y2		: x,y position
;*
;*
;* exit:		a8i16
;*	X  	: obj 1
;*	rangexz : distance. 
;*
;*


	LONGI
xydiffs_abs_l
	a16
	lda	x2
	sec
	sbc	al_worldx,x
	sta	x1
	bpl	.px
	lda	#0
	sec
	sbc	x1
.px	sta	rangexz

	lda	y2
	sec
	sbc	al_worldy,x
	sta	y1
	bmi	.ny
	clc
	adc	rangexz
	bra	.x
.ny	sec
	lda	rangexz
	sbc	y1
.x	sta	rangexz
	a8
	rtl




;*****************************************************************************


	shorta
	longi
xzdiffs_l

	a16
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	bpl	.nnegx
	nega
.nnegx	sta	x1

	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	bpl	.nnegz
	nega
.nnegz	sta	y1
	

xzdiffs_diffabs_l
	a16
	lda	x1
	asra
	sta	x1
	lda	y1
	asra
	sta	y1


	lda	y1
	clc
	adc	x1
	asl	a
	sta	rangexz

	lda	y1
	cmp	x1
	bmi	.xmax
	lda	y1
	bra	.done
.xmax	lda	x1
.done
	clc
	adc	rangexz
	

	sta	x1
;	asl	a
;	asl	a
	sta	y1
	lda	x1
	asra
	clc
	adc	y1
;	asra
	asra
	asra
;	asra
	sta	rangexz

	a8	
	rtl



;*****************************************************************************


	shorta
	longi
xydiffs_l
	a16
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	sta	x1
	bpl	.px
	lda	#0
	sec
	sbc	x1
.px	sta	rangexy

	lda.w	al_worldy,y
	sec
	sbc	al_worldy,x
	sta	y1
	bmi	.ny
	clc
	adc	rangexy
	bra	.x
.ny	sec
	lda	rangexy
	sbc	y1
.x	sta	rangexy
	a8
	rtl


;**********************************************************************************

	longa
sr16_achase_alvar1
	Achase_var2A		tpx,1,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr16_achase_alvar2
	Achase_var2A		tpx,2,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr16_achase_alvar3      
  	Achase_var2A		tpx,3,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr16_achase_alvar4      
	Achase_var2A		tpx,4,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr16_achase_alvar5      
	Achase_var2A		tpx,5,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr16_achase_alvar6      
	Achase_var2A		tpx,6,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr16_achase_alvar7      
	Achase_var2A		tpx,7,sr_achase_alvar_fin
	brl			sr_achase_alvar_end

	shorta
sr8_achase_alvar1
	Achase_var2A		tpx,1,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr8_achase_alvar2
	Achase_var2A		tpx,2,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr8_achase_alvar3      
  	Achase_var2A		tpx,3,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr8_achase_alvar4      
	Achase_var2A		tpx,4,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr8_achase_alvar5      
	Achase_var2A		tpx,5,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr8_achase_alvar6      
	Achase_var2A		tpx,6,sr_achase_alvar_fin
	brl			sr_achase_alvar_end
sr8_achase_alvar7
	Achase_var2A		tpx,7,sr_achase_alvar_fin
	brl			sr_achase_alvar_end



sr_achase_alvar_end
	lda	tpx
	clc
	rtl

sr_achase_alvar_fin
	lda	tpx
	sec
	rtl

;*****************************************************************************
;* makeobj_l
;*
	SHORTA
	LONGI

makeobj_l
	l_add	allst,alfreelst,.badobj
	phx
	ldx	alfreelst
	bne	.contin_ok
	jsr	purge_unneeded
.contin_ok
	plx
	sec
	rtl
.badobj
	nastyoff
	blink	4
	clc
	rtl
	
	SHORTA
purge_unneeded	
; if an object couldn't be made, scan through for delete-able objects
; and retry
	phx
	phy

	ldx	allst
.lp
	ldy	_next,x
	beq	.nomore
	phy

	s_jmp_alsflag	x,partobj,.simrem
	a16
	lda	al_shape,x
	cmp	#explosion
	beq	.simrem
	cmp	#explosion2
	beq	.simrem
	cmp	#explosion3
	beq	.simrem
	cmp	#explosion4
	beq	.simrem
	cmp	#explosion5
	beq	.simrem
	bra		.norem
.simrem
	a8
	s_remove_obj	x
	
.norem	a8
	plx
	bra	.lp
.nomore
	ply
	plx
	rts


;*****************************************************************************
;* init_objvars
;*
;*
;* entry:	a8i16
;*
;*      Y : ptr. to object
;*
;* exit:	a8i16
;*
;*

	SHORTA
	LONGI
init_objvars_l
	exg_XY 
	phb

	lda	#$7e
	pha
	plb

;-------------------------------------------------
; clear alien block	
	lda	#0
	phy
	phx

	ldy	#al_size-4
.clral	sta	al_start,x
	inx	
	dey	
	bne	.clral

	plx
	phx

	ldy	#al_size
.clral2	sta	alx_start&WM,x
	inx	
	dey	
	bne	.clral2

	plx
	ply
;-------------------------------------------------
; set default flags

	s_set_alflag		x,inviewpl
	s_setremove_behind	x
	s_set_alcollflag	x,firstframe
	s_set_alsflag		x,realobj

	km_jmpnotgameflag	freeze,.notactv
	s_set_alsflag		x,active
.notactv

	lda	CurrentArea
	sta	al_area,x

	
	plb
	exg_XY 
	rtl

;**********************************************************************************
	SHORTA
	LONGI
sr_make_obj	

	stx	tpx
	ldx	allst
	jsl	makeobj_l
	bcs	.gobj
.badobj
	ldy	#0
	ldx	tpx
	clc
	rtl
.gobj
	txy
	ldx	tpx

	a8
	jsl	init_objvars_l

	a16
	lda	tpa
	sta.w	al_shape,y

	a8
	sec
	rtl

;**********************************************************************************
	shorta
	longi
sr_make_child			; entry child number in A.
	sta	tpa

	s_set_alvar		B,y,al_sbyte1,tpa
	s_set_alvartobeobj	y,al_ptr,x
	s_set_alvar		W,y,al_sword1,#0
	
	a16
	sty	tpx
	txa

.lp	tay
	s_lda.w	al_sword1,y
	bne	.lp
	lda	tpx
	s_sta.w	al_sword1,y
	ldy	tpx
	a8


	s_set_alsflag	x,motherobj
	s_set_alsflag	y,childobj
	s_set_alsflag	y,removewithmother	; default

	rtl


;**********************************************************************************

	SHORTA
	LONGI
setobjtobechildyx_srou

	sta	tempchildnum	

	phx

.nc	ldy	al_sword1,x
	beq	.fc
.gc
	s_lda.w	al_sbyte1,y
	cmp	tempchildnum
	beq	.fc
	tyx
	bra	.nc
.fc
	plx

	rtl


setobjtobechildxy_srou
	sta	tempchildnum

	phy

.nc	ldx	al_sword1,y
	beq	.fc
.gc
	s_lda.w	al_sbyte1,x
	cmp	tempchildnum
	beq	.fc
	txy
	bra	.nc
.fc
	ply
	rtl



;**********************************************************************************
;* sort out child and mother objects if object in X is killed.
murderfamily_l
	phy
	phx
	a8

	s_jmpnot_alsflag	x,motherobj,.nmother
	s_clr_alsflag		x,motherobj

	ldy	al_sword1,x
	tyx
	lbeq	.nmother
.dispatchkids
	ldy	al_sword1,x
	phy
	s_clr_alsflag		x,childobj
	s_set_alvar		W,x,al_ptr,#0
	s_jmp_NOTalsflag	x,removewithmother,.norem
;;	s_jmp_NOTalsflag	x,inertwhenmotherdead,.killit
	brl			.killit
; we need to make this alien an inert object..
	phx
	a16
	ldx	inertlistptr
	l_add.w	inertlistptr,inertfree,.norem2
	txy
	plx

	lda	al_worldx,x
	sta.w	i_worldx,y
	lda	al_worldy,x
	sta.w	i_worldy,y
	lda	al_worldz,x
	sta.w	i_worldz,y
	lda	al_shape,x
	sta.w	i_shape,y
; exchange each other's pointers
	txa
	sta.w	i_alienptr,y
	tya
	sta	al_inertptr,x

	s_jmp_alsflag	x,pathobj,.setpath

	lda	al_stratptr,x
	sta.w	i_strat,y
	a8
	lda	al_stratptr+2,x
	sta.w	i_strat+2,y
	lda	#if_exists
	sta.w	i_flags,y
	bra	.normobj

.setpath	LONGA
	lda	al_sword2,x
	sta.w	i_strat,y
	a8
	lda	#if_pathobj!if_exists
	sta.w	i_flags,y
.normobj
	lda	al_rotx,x
	sta.w	i_rotx,y
	lda	al_roty,x
	sta.w	i_roty,y
	lda	al_rotz,x
	sta.w	i_rotz,y
	

	bra	.norem
.norem2
	a8
	plx
	bra	.norem
.killit
	s_kill_obj		x
.norem	ply
	tyx
	lbne	.dispatchkids
	

.nmother
	plx
	ply
	rtl

;**********************************************************************************

	SHORTA
	LONGI
jmptostratx_jml
	lda	al_stratptr+2,x
	pha
	a16
	bne	.nochk1
	lda	al_stratptr,x
	beq	.failed
	dec	a
	pha
	a8
	rtl
.nochk1	LONGA
	lda	al_stratptr,x
	dec	a
	pha
	a8
	rtl

.failed	a8
	pla
	rtl	; s_end_strat



;**********************************************************************************
	SHORTA
	LONGI
sr_copyposyx
	a16
	lda	al_worldx,x
	sta.w	al_worldx,y
	lda	al_worldy,x
	sta.w	al_worldy,y
	lda	al_worldz,x
	sta.w	al_worldz,y
	a8
	rtl
sr_copyposxy
	a16
	lda.w	al_worldx,y
	sta	al_worldx,x
	lda.w	al_worldy,y
	sta	al_worldy,x
	lda.w	al_worldz,y
	sta	al_worldz,x
	a8
	rtl

sr_copyrotsyx
	s_lda.w	al_rotx,x
	s_sta.w	al_rotx,y
	s_lda.w	al_roty,x
	s_sta.w	al_roty,y
	s_lda.w	al_rotz,x
	s_sta.w	al_rotz,y
	rtl
sr_copyrotsxy
	s_lda.w	al_rotx,y
	s_sta.w	al_rotx,x
	s_lda.w	al_roty,y
	s_sta.w	al_roty,x
	s_lda.w	al_rotz,y
	s_sta.w	al_rotz,x
	rtl

;*****************************************************************************


;----------------------------
	shorta
	longi
addvecs4_l
	a16
	asl	x1
	asl	y1
	asl	z1
	asl	x1
	asl	y1
	asl	z1
	bra	addvecs0_l
addvecs2_l
	a16
	asl	x1
	asl	y1
	asl	z1

addvecs_l
	a16
addvecs0_l
	lda	al_worldx,x
	clc
	adc	x1
	sta	al_worldx,x

	lda	al_worldy,x
	clc
	adc	y1
	sta	al_worldy,x

	lda	al_worldz,x
	clc
	adc	z1
	sta	al_worldz,x
	a8
	rtl

;*****************************************************************************
addalvecs_l
	a16
	lda	al_worldx,x
	clc
	adc	al_vx,x
	sta	al_worldx,x

	lda	al_worldy,x
	clc
	adc	al_vy,x
	sta	al_worldy,x

	lda	al_worldz,x
	clc
	adc	al_vz,x
	sta	al_worldz,x
	a8
	rtl

;*****************************************************************************


;Calc X Z velocity vectors ------------------------
	shorta
	longi
alvelvecs_l
	lda	al_vel,x
velvecs_l
	sta	tmpz
	phb
	stx	tmpx
	sty	tmpy
	stz	y1
	stz	y1+1
	lda	al_roty,x
	tax

	i8

	lda.l	ramsintab,x
	sta	siny
	lda.l	ramcostab,x
	sta	cosy
	mulslogmacram	tmpz,siny
	ldx	#0

	sta	x1

	cmp	#0
	bpl	velvec1
	dex
velvec1
	stx	x1+1
	mulslogmacram	tmpz,cosy
	ldx	#0
	sta	z1
	cmp	#0
	bpl	velvec2
	dex
velvec2
	stx	z1+1
	i16
	ldx	tmpx
	ldy	tmpy
	rtl



;**********************************************************************************
sr_gen_3dvecs
	jsl	n3Dvecs_l		; generate x,y,z vels from x,y rot and speed.

	a16
	lda	x1
	sta	al_vx,x

	lda	y1
	sta	al_vy,x

	lda	z1
	sta	al_vz,x
	a8
	rtl

sr_gen_3dvecs1
	jsl	n3Dvecs_l		; generate x,y,z vels from x,y rot and speed.

	a16
	lda	x1
	asl	a
	sta	al_vx,x

	lda	y1
	asl	a
	sta	al_vy,x

	lda	z1
	asl	a
	sta	al_vz,x
	a8
	rtl


sr_gen_3dvecs2
	jsl	n3Dvecs_l		; generate x,y,z vels from x,y rot and speed.

	a16
	lda	x1
	asl	a
	asl	a
	sta	al_vx,x

	lda	y1
	asl	a
	asl	a
	sta	al_vy,x

	lda	z1
	asl	a
	asl	a
	sta	al_vz,x
	a8
	rtl

sr_gen_3dvecs3
	jsl	n3Dvecs_l		; generate x,y,z vels from x,y rot and speed.

	a16
	lda	x1
	asl	a
	asl	a
	asl	a
	sta	al_vx,x

	lda	y1
	asl	a
	asl	a
	asl	a
	sta	al_vy,x

	lda	z1
	asl	a
	asl	a
	asl	a
	sta	al_vz,x
	a8
	rtl




;*****************************************************************************

	shorta
	longi	

		
nalvelvecs_l
	lda	al_vel,x
	sta	tmpz
nvelvecs_l
	lda	al_roty,x

nvecs_l
	stx	tmpx
	sty	tmpy
	stz	y1
	stz	y1+1

	nega
	tax

	i8

	inx
	iny
	lda.l	ramsintab,x
	sta	siny
	lda.l	ramcostab,x
	sta	cosy
	mulslogmacram	tmpz,siny
	ldx	#0
	sta	x1
	cmp	#0
	bpl	nvelvec1
	dex
nvelvec1
	stx	x1+1
	mulslogmacram	tmpz,cosy
	ldx	#0
	sta	z1
	cmp	#0
	bpl	nvelvec2
	dex
nvelvec2
	stx	z1+1
	i16
	ldx	tmpx
	ldy	tmpy
	rtl




;*****************************************************************************



;Calc X Y Z velocity vectors ------------------------
	shorta
	longi
alvel3vecs_l
	lda	al_vel,x
vel3vecs_l
	sta	tmpz
	stz	x1+1
	stz	y1+1
	stz	z1+1
	stx	tmpx
	sty	tmpy
	lda	al_roty,x
	tay
	lda	al_rotx,x
	nega
	tax

	i8

	phx
	tyx
	lda.l	ramsintab,x
	sta	siny
	lda.l	ramcostab,x
	sta	cosy
	plx
	lda.l	ramsintab,x
	sta	sinx
	lda.l	ramcostab,x
	sta	cosx
	mulslogmacram	tmpz,siny
	sta	x1
	mulslogmacram	x1,cosx
	sta	x1
	cmp	#0
	bpl	.x1pos
	dec	x1+1
.x1pos

	mulslogmacram	tmpz,cosy
	sta	z1
	mulslogmacram	z1,cosx
	sta	z1
	cmp	#0
	bpl	.z1pos
	dec	z1+1
.z1pos
	mulslogmacram	tmpz,sinx
	sta	y1
	cmp	#0
	bpl	.y1pos
	dec	y1+1
.y1pos
	i16
	ldx	tmpx
	ldy	tmpy
	rtl

;*****************************************************************************

	shorta
	longi
nalvel3vecs_l
	lda	al_vel,x
nvel3vecs_l
	sta	tmpz
	lda	al_roty,x
	sta	troty
	lda	al_rotx,x
	sta	trotx
n3dvecs_l
 
	stz	x1+1
	stz	y1+1
	stz	z1+1
	stx	tmpx
	sty	tmpy
	
	lda	troty
	nega
	tay

	lda	trotx
	tax

	i8

	phx
	tyx
	lda.l	ramsintab,x
	sta	siny
	lda.l	ramcostab,x
	sta	cosy
	plx
	lda.l	ramsintab,x
	sta	sinx
	lda.l	ramcostab,x
	sta	cosx
	mulslogmacram	tmpz,siny
	sta	x1
	mulslogmacram	x1,cosx
	sta	x1
	cmp	#0
	bpl	.x1pos
	dec	x1+1
.x1pos

	mulslogmacram	tmpz,cosy
	sta	z1
	mulslogmacram	z1,cosx
	sta	z1
	cmp	#0
	bpl	.z1pos
	dec	z1+1
.z1pos
	mulslogmacram	tmpz,sinx
	sta	y1
	cmp	#0
	bpl	.y1pos
	dec	y1+1
.y1pos
	a16
	lda	x1
	sta	x1
	lda	y1
	sta	y1
	lda	z1
	sta	z1

	a8i16
	ldx	tmpx
	ldy	tmpy
	rtl

;--------------------------------------------------------------------
; mode change code:

	shorta
modechangeadd_l
	sta	x1
	lda	al_stratstate,x
	clc
	adc	x1
	sta	al_stratstate,x
	rtl

modechangeset_l
	sta	al_stratstate,x
	rtl

jumptostate_l
	sty	tmpstate
	lda	al_stratstate,x
	a16
	and	#255
	asl	a
	asl	a
	tay
	a8
	lda.l	[tempaddrl],y
	pha
	iny
	a16
	lda.l	[tempaddrl],y
	pha
	a8
	ldy	tmpstate
	rtl

;�������������������������������������������������������
; generate list for collision detection to run through

generate_collist_l
	php
	a8
	storenasty
	nastyon
	ai16

	stz	collistcnt

	km_bitcheckmissionflag	enemyrunaway
	bne	.ret

	ldx	allst
	beq	.ret

	ldy	#0
.nextone
	phx

	test_alcollflags	x,acf_firstframe
	bne	.isff

	test_alsflag	x,colldisable
	bne	.isff
	test_alsflag	x,removeme
	bne	.isff

	lda	al_hp,x
	and	#255
	beq	.isff
	lda	al_flags,x
	bit	#afexp
	bne	.isff

	phx

	lda	al_shape,x
	tyx
	tay

	pla
	sta.l	cl_alien,x

	a8
	romnastyoff
	a16

	lda.w	sh_radius,y
	sta.l	cl_colbox,x

	lda.w	sh_xmax,y
	sta.l	cl_xmax,x

	lda.w	sh_ymax,y
	sta.l	cl_ymax,x

	lda.w	sh_zmax,y
	sta.l	cl_zmax,x

	a8
	romnastyon
	a16

	inc	collistcnt

	txa
	clc
	adc	#cl_sizeof
	tay
.isff
	plx
	lda	_next,x
	tax
	bne	.nextone

.ret
	a8
	restorenasty
	plp
	rtl


;----------------------------------------------------------------


;**********************************************************************************
	shorta
	longi
sr_remove_objx

;	s_jmpNOT_onfire		x,.nfr
;	s_remove_fire	x
;.nfr
;	s_doremove_obj		x
	jsl			removedeadal_l
.ero
	rtl

sr_remove_objy
	exg_xy
	jsl		sr_remove_objx
	exg_xy
	rtl



	shorta
	longi
;demove dead alien from alien list
Removedeadal_l
	jsr	removedeadal
	rtl
Removedeadal 
	phx
	phy
	php

	storenasty
	nastyon
	
	jsl	delinkinert_l

	jsl	removecollisions_l

	jsl	divorcefamily_l

	a16
	jsl	removeptrs_l
	l_rem	allst,alfreelst	;unlink al_block

	a8
	restorenasty
	plp
	ply
	plx
	rts



;**********************************************************************************
	LONGI
	SHORTA
; deletes the hitlist of the object x
removecollisions_l
	phb
	a8i16
	lda	#$7e
	pha
	plb

	a16
	ldy	al_hitlist,x
	beq	.none
.nxt1
	lda.w	_next,y
	pha

	jsl	removehl_l	; removes y from x

	ply
	bne	.nxt1		; delete until end of list

.none
	lda	al_hitlist,x
	beq	.ok112
	blink
.ok112

	plb
	rtl

;**********************************************************************************
	LONGI
	SHORTA
; if the object is an inert object, this removes the inert structure
; x = object
removeinert_l
	phb
	a8i16
	lda	#$7e
	pha
	plb
	phy

	ldy	al_inertptr,x
	beq	.exit

	stz	al_inertptr,x
	stz	al_inertptr+1,x

	phx
	phy
	tyx
	l_rem.w	inertlistptr,inertfree

	ply
	plx
.exit
	ply
	plb
	rtl
;**********************************************************************************


;**********************************************************************************
	LONGI
	SHORTA
; if the object is an inert object, this clears the pointers
; x = object
delinkinert_l
	phb
	a8i16
	lda	#$7e
	pha
	plb
	phy

	ldy	al_inertptr,x
	beq	.exit

	stz	al_inertptr,x
	stz	al_inertptr+1,x

	lda.w	i_flags,y
	and	#~if_exists
	ora	#if_removedinview
	sta.w	i_flags,y

	lda	#0
	sta.w	i_alienptr,y
	sta.w	i_alienptr+1,y
.exit
	ply
	plb
	rtl
;**********************************************************************************

;**********************************************************************************
;* sort out child and mother objects if object in X removed.
divorcefamily_l
	phy
	phx
	a8
	s_jmpnot_alsflag	x,childobj,.nchild
	s_set_objtobemother	y,x
	s_remove_child		x,y
.nchild

	s_jmpnot_alsflag	x,motherobj,.nmother
;	s_clr_alsflag		y,motherobj	; major bug here Giles
	s_clr_alsflag		x,motherobj	; well ok, it's minor

	ldy	al_sword1,x
	tyx
	beq	.nmother
.dispatchkids
	ldy	al_sword1,x
	s_clr_alsflag		x,childobj
	s_set_alvar		W,x,al_ptr,#0
	s_jmp_NOTalsflag	x,removewithmother,.norem
	s_remove_obj		x
.norem	tyx
	bne	.dispatchkids
	

.nmother
	plx
	ply
	rtl


;--------------------------------------------------------------------
;--------------------------------------------------------------------


removeptrs_l
;******* Remove immunity ptr
	phx
	txa
	ldx	allst

.rem	cmp	al_immuneptr,x
	bne	.rem2
	stz	al_immuneptr,x
.rem2
	cmp	al_ptr,x
	bne	.rem3
	stz	al_ptr,x
.rem3
;	cmp	al_fireobjptr,x
;	bne	.rem4
;	stz	al_fireobjptr,x
;.rem4
;	cmp	al_collobjptr,x
;	bne	.remok
;	stz	al_collobjptr,x

.remok	ldy	_next,x
	tyx
	bne	.rem
	plx

	jsl	sallfree_l	; free any memory allocated
	rtl






;����������������������������������������������������������������������-
; run through each alien block and call its strategy
; part 1 ( it is split into two parts to optimise two player mode)

dostrats1_l
	phb
	a8i16


;*******
	lda	p1_status
	bit	#p1_status_bom
	beq	.noBOM
	jsl	decHP_srou_l
.noBOM
;*******


	storenasty
	nastyon

 	incw	gameframe

	lda	#$7e
	pha
	plb

	ldx	allst			;do all strategies

.stratlp
	lda.l	m_sfr
	and	#$20
	beq	.cont		; has mario chip finished?
	s_jmp_alsflag	x,simpleobj,.nxtal
	stz	aldead
	jsl	do_strat_l
	lda	aldead
	bne	.killal
.nxtal
	ldy	_next,x
.killed	tyx
	bne	.stratlp
	bra	.cont
.killal	ldy	_next,x
 	jsl	removedeadal_l
	bra	.killed
.cont	stx	dostrats_alptr

	restorenasty
	plb
	rtl

;������������������������������������������������������������������
; part 2 ( it is split into two parts to optimise two player mode)

dostrats2_l
	phb
	a8i16
	storenasty
	nastyon

	lda	#$7e
	pha
	plb
	ldx	dostrats_alptr		;do all strategies
	beq	.cont

.stratlp
	s_jmp_alsflag	x,simpleobj,.nxtal
	stz	aldead
	jsl	do_strat_l
	lda	aldead
	bne	.killal
.nxtal
	ldy	_next,x
.killed	tyx
	bne	.stratlp
	bra	.cont
.killal	ldy	_next,x
 	jsl	removedeadal_l
	bra	.killed
.cont	stx	dostrats_alptr

	restorenasty
	plb
	rtl



;*****************************************************************************
;* do_strat_l
;*
;*
;* entry:
;*	 X : ptr. to object.
;*
;*

Do_strat_l
	php
	a8
	storenasty
	nastyon

	ai16
	cpx	dummyobj
	lbeq	.estrat

	a8
	

	stx	al1pt

; is the hitpoint 0?
	lda	al_HP,x
	bne	.notdead

	s_jmp_alcollflag	x,firstframe,.notdead
	s_jmp_alsflag	x,active,.dontfreeze2
	km_jmpgameflag	freeze,.notdead
.dontfreeze2
	lda	#pre_explode_istrat>>16
;;	lda.l	alx_expstratptr+2,x 
	sta	tjmp+2
	a16
	lda	#pre_explode_istrat&WM
;;	lda.l	alx_expstratptr,x 
	sta	tjmp
	brl	.dostr
	a8
.notdead
	s_clr_alcollflag	x,firstframe

; something hit it?
	test_alsflag	x,collide
	beq	.nothit

;;;	lda.l	alx_collstratptr+2,x 
	lda	#hit_istrat>>16
	sta	tjmp+2
	a16
	lda	#hit_istrat&WM
;;	lda.l	alx_collstratptr,x  
	sta	tjmp
	brl	.dostr
	a8

	s_clr_alsflag	x,collide
.nothit
	lda	al_stratptr+2,x 
	sta	tjmp+2
	a16
	lda	al_stratptr,x
	beq	.strad
	sta	tjmp

	a8

	s_jmp_alsflag	x,active,.dontfreeze
	km_jmpgameflag	freeze,.estrat
.dontfreeze
		
.dostr
	a8	

	lda	#(.estrat>>16)&255
	pha

	pea	(.estrat-1)&WM

	romnastyoff
	jmp.l	[tjmp]

.estrat
;*************************************************************************
;*************************************************************************
;**** kawaguchi port2 (loop) check area start ****
	romnastyon
	phx
	phy
	php

	a8i16
	km_bitchecksndflag	allstop
	bne	.nosound
	lda	alx_snd2,x
	beq	.nosound
;* set port 2 *
	ldy	#viewblk1
	jsr	kgetport2
.nosound
	plp
	ply
	plx
;**** kawaguchi port2 check area end ****
;*************************************************************************
;*************************************************************************

;---------------------------------------------------------

.strad	a8
	restorenasty
	plp
	rtl


.bad_strat
	badstrat


;*************************************************************************
;*************************************************************************
;**** kawaguchi sub program start ****
;=============================================================
;*		Sound Port 2 Data Get			*
;* Acc   :Sound Number					*
;* Xreg  :alien  pointer					*
;* Yreg  :player VIEW pointer				*
;* kwork :sound number					*
;* kz_x1 :relative x						*
;* kz_z1 :relative z						*
;=============================================================
kgetport2
	phx
	php

	shorta
	longi
	sta	kwork
;* distance check *
	jsr	.getdistance_easy
	a16
	lda	pathz1		;current distance
	cmp	sddist2		;before distance
	bcs	.end		;mae no length yori tookattara goto end!! 
	sta	sddist2		;NEW distance
	a8
	km_setvar	sdchkno2tmp,kwork	;Set Sound No
	stx	sdchkptr2tmp			;Set Alien pointer

;* sound distance flag set *
	a16
	ldx	#0
	lda	sddist2		;NEW distance
	cmp	#200*2
	bmi	..set_distflag
	inx
	cmp	#500*2
	bmi	..set_distflag
	inx
	cmp	#1000*2
	bmi	..set_distflag
	inx
..set_distflag
	a8
	lda.l	..snd2disttbl,x
	ora	kwork
	sta	kwork

;* angle *
;Init :kz_x1,kz_y1 :(x,z)zahyou

	a16
	jsl	arctan16_l

	a8
	xba
	sec
	sbc.w	al_roty+1,y	;player camera angle
	ldx	#0
;* Memo :angle wo kaeruni wa ushirono $10 no bubun wo kaeru *
	cmp	#$00+$10	;22 do
	bcc	..snd2center
	cmp	#$00-$10
	bcs	..snd2center
	cmp	#$80-$10
	bcc	..snd2right
	cmp	#$80+$10
	bcc	..snd2center
	bra	..snd2left
..snd2right
	inx
..snd2center
	inx
..snd2left
	lda.l	..snd2angtbl,x
	ora	kwork
	sta	sdport2tmp
.end
	plp
	plx
	rts

;=====================================================================
;*		Sound Port2 Distance Table			*
;=====================================================================
..snd2disttbl
	db	sport2_sonear
	db	sport2_near
	db	sport2_far
	db	sport2_sofar
;=====================================================================
;*		Sound Port2 Angle Table				*
;=====================================================================
..snd2angtbl
	db	sport2_left
	db	sport2_center
	db	sport2_right

;=====================================================================
;*		Calculate Distance (Easy Version)		*
;* Xreg :alien pointer						*
;* Yreg :player VIEW pointer						*
;* Out  :Acc,pathz1 :from enemy to player distance			*
;*      :kz_x1  :from enemy to player zahyou X			*
;*      :kz_z1  :from enemy to player zahyou Z			*
;*      :kz_tpx  :from enemy to player distance � X �		*
;*      :kz_tpy  :from enemy to player distance � Z �		*
;=====================================================================
.getdistance_easy
	php
	a16
	longi
;-----------------------------------------------------------------------
;* zahyou *
;* For Angle Data *
	lda.w	al_worldx,x
	sec
	sbc.w	al_worldx,y
	sta	kz_x1
	bpl	.next1
	km_nega
.next1
	sta	kz_x2

	lda.w	al_worldz,x
	sec
	sbc.w	al_worldz,y
	sta	kz_y1
	bpl	.next2
	km_nega
.next2
	sta	kz_y2
;-----------------------------------------------------------------------
	clc
	adc	kz_x2
	ror	a
	sta	pathz1



	IFEQ	1
;;;	asr	a
	sta	kz_x1		;Alien X
	lda.w	al_worldz,x
;;;	asr	a
	sta	kz_z1		;Alien Z

	lda.w	al_worldx,y
;;;	asr	a
	sta	kz_x2		;Player X
	lda.w	al_worldz,y
;;;	asr	a
	sta	kz_z2		;Player Z
;---------------------------
;* relative x zahyou *
	km_substavarvar	kz_x1,kz_x2,kz_x1
	bpl	..plasx
	km_nega
..plasx
	sta	kz_tpx
;---------------------------
;* relative z zahyou *
	km_substavarvar	kz_z1,kz_z2,kz_z1
	bpl	..plasz
	km_nega
..plasz
	sta	kz_tpy
;---------------------------
	km_addstavarvar	pathz1,kz_tpx,kz_tpy
	ENDC

	plp
	rts

;=====================================================================
;*		Calculate Angle (Easy Version)			*
;* Xreg :alien pointer						*
;* Yreg :player pointer						*
;* Init :kz_x1,kz_z1 :from enemy to player zahyou (X,Y)		*
;* Out  :pathz1 :from enemy to player angle				*
;=====================================================================
.getangle_easy
	php
	a16
;* init *
	stz	pathz1
	km_negstavar	kz_x2,kz_x1
;* check *
	lda	kz_z1
	cmp	kz_x1
	bmi	..minus1
..plas1
	cmp	kz_x2
	bpl	..center_easy
	bra	..left_easy
..minus1
	cmp	kz_x2
	bmi	..center_easy
..right_easy
	inc	pathz1
..center_easy
	inc	pathz1
..left_easy
	plp
	rts

;*************************************************************************
;*************************************************************************
;**** kawaguchi sub program end ****


;*****************************************************************************
;* rotate_16xz
;*
;*
;* entry:	a8
;*	A  : Y angle 
;*	x1 : x vector 16bit
;*	z1 : z vector 16bit
;*
;*
;* exit:	a8	
;*
;*	x2 : rotated x vector 16bit
;*	z2 : rotated z vector 16bit
;*
;*
	SHORTA
	LONGI

rotate_16xz_l
	stx	tpx
	sty	tpy
	php
	phb

	i8

	tax
	lda	#0
	pha
	plb
	lda sintab,x
	sta sinvy
	lda costab,x
	sta cosvy

	mulslog168 x1,sinvy
	lda m4
	sta z2
	lda m5
	sta z2+1
	mulslog168 z1,cosvy
	lda m4
	clc
	adc z2
	sta z2
	lda m5
	adc z2+1
	sta z2+1

	mulslog168 z1,sinvy
	lda m4
	sta x2
	lda m5
	sta x2+1
	mulslog168 x1,cosvy
	lda m4
	sec
	sbc x2
	sta x2
	lda m5
	sbc x2+1
	sta x2+1

	plb
	plp
	ldy	tpy
	ldx	tpx
	rtl



;*****************************************************************************
;* rotate_16yz
;*
;*
;* entry:	a8
;*	A  : X angle 
;*	y1 : y vector 16bit
;*	z1 : z vector 16bit
;*
;*
;* exit:	a8	
;*
;*	y2 : rotated y vector 16bit
;*	z2 : rotated z vector 16bit
;*
;*
	SHORTA
	LONGI

rotate_16yz_l
	stx	tpx
	sty	tpy
	php
	phb

	i8

	nega
	tax
	lda	#0
	pha
	plb
	lda sintab,x
	sta sinvy
	lda costab,x
	sta cosvy

	mulslog168 y1,sinvy
	lda m4
	sta z2
	lda m5
	sta z2+1
	mulslog168 z1,cosvy
	lda m4
	clc
	adc z2
	sta z2
	lda m5
	adc z2+1
	sta z2+1

	mulslog168 z1,sinvy
	lda m4
	sta y2
	lda m5
	sta y2+1
	mulslog168 y1,cosvy
	lda m4
	sec
	sbc y2
	sta y2
	lda m5
	sbc y2+1
	sta y2+1

	plb
	plp
	ldy	tpy
	ldx	tpx
	rtl



;*****************************************************************************
;* rotate_8xz
;*
;*
;* entry:		a8i16
;*	A  : Y angle
;*	x1 : x vector 8bit
;*	z1 : z vector 8bit
;*
;*
;* exit:		a8i16
;*
;*	x2 : rotated x vector 16bit
;*	z2 : rotated z vector 16bit
;*
;*
	
	SHORTA
	LONGI
rotate_8xz_ram_l
rotate_8xz_l
	phy
	phx
	php

	i8

	nega
	tax
	storenasty
	nastyon		; switch the mario chip on

	lda.l	ramcostab,x
	sta	cy
	lda.l	ramsintab,x
	sta	sy

	mulslogmacram x1,cy
	stx	x2
	mulslogmacram z1,sy
	txa
	clc
	adc	x2
	sta	x2
	sexam	x2+1

	mulslogmacram x1,sy
	txa
	nega
	sta	z2
	mulslogmacram z1,cy
	txa
	clc
	adc	z2
	sta	z2
	sexam	z2+1

	restorenasty

	plp
	plx
	ply


	rtl

;*****************************************************************************
;* rotate_8yz
;*
;*
;* entry:		a8i16
;*	A  : X angle
;*	y1 : y vector 8bit
;*	z1 : z vector 8bit
;*
;*
;* exit:		a8i16
;*
;*	y2 : rotated y vector 16bit
;*	z2 : rotated z vector 16bit
;*
;*
	
	SHORTA
	LONGI
rotate_8yz_ram_l
rotate_8yz_l
	phx
	phy
	php

	i8

	tax
	storenasty
	nastyon		; switch the mario chip on

	lda.l	ramcostab,x
	sta	cy
	lda.l	ramsintab,x
	sta	sy

	mulslogmacram y1,cy
	stx	y2
	mulslogmacram z1,sy
	txa
	clc
	adc	y2
	sta	y2
	sexam	y2+1

	mulslogmacram y1,sy
	txa
	nega
	sta	z2
	mulslogmacram z1,cy
	txa
	clc
	adc	z2
	sta	z2
	sexam	z2+1

	restorenasty
	plp
	ply
	plx


	rtl


;*****************************************************************************
;* rotate_8yx
;*
;*
;* entry:		a8i16
;*	A  : Y angle
;*	x1 : x vector 8bit
;*	z1 : z vector 8bit
;*
;*
;* exit:		a8i16
;*
;*	x2 : rotated x vector 16bit
;*	z2 : rotated z vector 16bit
;*
;*
	
	SHORTA
	LONGI
rotate_8yx_ram_l
rotate_8yx_l
	phy
	phx
	php

	i8

	tax
	storenasty
	nastyon
	lda.l	ramcostab,x
	sta	cy
	lda.l	ramsintab,x
	sta	sy

	mulslogmacram x1,cy
	stx	x2
	mulslogmacram y1,sy
	txa
	clc
	adc	x2
	sta	x2
	sexam	x2+1

	mulslogmacram x1,sy
	txa
	nega
	sta	y2
	mulslogmacram y1,cy
	txa
	clc
	adc	y2
	sta	y2
	sexam	y2+1

	restorenasty

	plp
	plx
	ply


	rtl



ramsintab
	DB	0
	DB	3
	DB	6
	DB	9
	DB	12
	DB	15
	DB	18
	DB	21
	DB	24
	DB	27
	DB	30
	DB	33
	DB	36
	DB	39
	DB	42
	DB	45
	DB	48
	DB	51
	DB	54
	DB	57
	DB	59
	DB	62
	DB	65
	DB	67
	DB	70
	DB	73
	DB	75
	DB	78
	DB	80
	DB	82
	DB	85
	DB	87
	DB	89
	DB	91
	DB	94
	DB	96
	DB	98
	DB	100
	DB	102
	DB	103
	DB	105
	DB	107
	DB	108
	DB	110
	DB	112
	DB	113
	DB	114
	DB	116
	DB	117
	DB	118
	DB	119
	DB	120
	DB	121
	DB	122
	DB	123
	DB	123
	DB	124
	DB	125
	DB	125
	DB	126
	DB	126
	DB	126
	DB	126
	DB	126

ramcostab
	DB	127
	DB	126
	DB	126
	DB	126
	DB	126
	DB	126
	DB	125
	DB	125
	DB	124
	DB	123
	DB	123
	DB	122
	DB	121
	DB	120
	DB	119
	DB	118
	DB	117
	DB	116
	DB	114
	DB	113
	DB	112
	DB	110
	DB	108
	DB	107
	DB	105
	DB	103
	DB	102
	DB	100
	DB	98
	DB	96
	DB	94
	DB	91
	DB	89
	DB	87
	DB	85
	DB	82
	DB	80
	DB	78
	DB	75
	DB	73
	DB	70
	DB	67
	DB	65
	DB	62
	DB	59
	DB	57
	DB	54
	DB	51
	DB	48
	DB	45
	DB	42
	DB	39
	DB	36
	DB	33
	DB	30
	DB	27
	DB	24
	DB	21
	DB	18
	DB	15
	DB	12
	DB	9
	DB	6
	DB	3
	DB	0
	DB	-3
	DB	-6
	DB	-9
	DB	-12
	DB	-15
	DB	-18
	DB	-21
	DB	-24
	DB	-27
	DB	-30
	DB	-33
	DB	-36
	DB	-39
	DB	-42
	DB	-45
	DB	-48
	DB	-51
	DB	-54
	DB	-57
	DB	-59
	DB	-62
	DB	-65
	DB	-67
	DB	-70
	DB	-73
	DB	-75
	DB	-78
	DB	-80
	DB	-82
	DB	-85
	DB	-87
	DB	-89
	DB	-91
	DB	-94
	DB	-96
	DB	-98
	DB	-100
	DB	-102
	DB	-103
	DB	-105
	DB	-107
	DB	-108
	DB	-110
	DB	-112
	DB	-113
	DB	-114
	DB	-116
	DB	-117
	DB	-118
	DB	-119
	DB	-120
	DB	-121
	DB	-122
	DB	-123
	DB	-123
	DB	-124
	DB	-125
	DB	-125
	DB	-126
	DB	-126
	DB	-126
	DB	-126
	DB	-126
	DB	-127
	DB	-126
	DB	-126
	DB	-126
	DB	-126
	DB	-126
	DB	-125
	DB	-125
	DB	-124
	DB	-123
	DB	-123
	DB	-122
	DB	-121
	DB	-120
	DB	-119
	DB	-118
	DB	-117
	DB	-116
	DB	-114
	DB	-113
	DB	-112
	DB	-110
	DB	-108
	DB	-107
	DB	-105
	DB	-103
	DB	-102
	DB	-100
	DB	-98
	DB	-96
	DB	-94
	DB	-91
	DB	-89
	DB	-87
	DB	-85
	DB	-82
	DB	-80
	DB	-78
	DB	-75
	DB	-73
	DB	-70
	DB	-67
	DB	-65
	DB	-62
	DB	-59
	DB	-57
	DB	-54
	DB	-51
	DB	-48
	DB	-45
	DB	-42
	DB	-39
	DB	-36
	DB	-33
	DB	-30
	DB	-27
	DB	-24
	DB	-21
	DB	-18
	DB	-15
	DB	-12
	DB	-9
	DB	-6
	DB	-3
	DB	0
	DB	3
	DB	6
	DB	9
	DB	12
	DB	15
	DB	18
	DB	21
	DB	24
	DB	27
	DB	30
	DB	33
	DB	36
	DB	39
	DB	42
	DB	45
	DB	48
	DB	51
	DB	54
	DB	57
	DB	59
	DB	62
	DB	65
	DB	67
	DB	70
	DB	73
	DB	75
	DB	78
	DB	80
	DB	82
	DB	85
	DB	87
	DB	89
	DB	91
	DB	94
	DB	96
	DB	98
	DB	100
	DB	102
	DB	103
	DB	105
	DB	107
	DB	108
	DB	110
	DB	112
	DB	113
	DB	114
	DB	116
	DB	117
	DB	118
	DB	119
	DB	120
	DB	121
	DB	122
	DB	123
	DB	123
	DB	124
	DB	125
	DB	125
	DB	126
	DB	126
	DB	126
	DB	126
	DB	126

