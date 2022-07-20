rx	equr	1
ry	equr	2
rpxx	equr	1
rpxy	equr	2
rpxz	equr	3
rmlo	equr	4
rmhi	equr	5
rz	equr	6
rx1	equr	7
ry1	equr	8
rz1	equr	9
rgridx	equr	10
rgridz	equr	11

mshowgrid2
	iwt	r11,#mshowdust2ret&WM

mshowgrid
	sms	[m_dotsorstars],r11

	sub	r0
	ramb
	cmode

	ibt	r0,#ztab>>16
	romb

	lms	rx1,[m_x1]
	lms	ry1,[m_y1]
	lms	rz1,[m_z1]

	lms	rpxx,[m_pxx]
	lms	rpxy,[m_pxy]
	lms	rpxz,[m_pxz]

	lms	rgridz,[m_gridz]

	miwt	r0,mgridsize
	sms	[m_gridzsize],r0

	mcache
mcachecheck

mgridzloop
	lms	rgridx,[m_gridx]

	with	rz1
	sub	rpxz
	
	miwt	r12,mgridsize
	move	r13,pc

mgridxloop
;	mtest	rz1
	with	rz1
	add	rpxz
	bpl	mgrdrawdot
;	nop

mgrdrawdotrts
	with	rx1
	add	rpxx
	with	ry1
	add	rpxy
;	with	rz1
;	add	rpxz
	loop
	inc	rgridx

	inc	rgridz

	lms	r0,[m_pzx]
	lms	rx1,[m_x1]
	with	rx1
	add	r0
	sms	[m_x1],rx1

	lms	r0,[m_pzy]
	lms	ry1,[m_y1]
	with	ry1
	add	r0
	sms	[m_y1],ry1

	lms	r0,[m_pzz]
	lms	rz1,[m_z1]
	with	rz1
	add	r0
	sms	[m_z1],rz1

	lms	r0,[m_gridzsize]
	dec	r0
	bne	mgridzloop
	sbk

	ibt	rx,#0
	ibt	ry,#0
	mrpix
	nop

	lms	r11,[m_dotsorstars]
	jmp	r11
	nop



mgrdrawdot
	move	rz,rz1
	miwt	r0,maxztab
	sub	rz
	bpl	mgrdrawdot1
	nop
	miwt	rz,maxztab-1
mgrdrawdot1

	miwt	r0,256
	sub	rz
	bpl	mgrdrawdotrts
	nop



	move	r0,r10
	iwt	r10,#m_stack&WM
	mpush	r0
	mpush	r1
	mpush	r2
	mpush	r3
	mpush	r4
	mpush	r5
	mpush	r6
	mpush	r7
	mpush	r8
	mpush	r9
	mpush	r10
	mpush	r11
	mpush	r12
	mpush	r13


	sub	r0
	sms	[m_shift],r0
	sms	[m_spr0],r0
	ibt	r0,#32
	sms	[m_sprsize],r0
	ibt	r0,#16
	sms	[m_spra],r0

	sms	[m_bigx],rx1
	sms	[m_bigy],ry1
	sms	[m_bigz],rz

	iwt	r0,#meteo_c&WM
	sms	[m_colourptr],r0

	mcall	mssprite
	nop

	


	mpop	r13
	mpop	r12
	mpop	r11
	mpop	r10
	mpop	r9
	mpop	r8
	mpop 	r7
	mpop	r6
	mpop	r5
	mpop	r4
	mpop	r3
	mpop	r2
	mpop	r1
	mpop	r0
	move	r10,r0



	IFEQ	1

	with	rz
	bic	#1

	miwt	r0,ztab
	to	r14
	add	rz
	mgetw	rz		; 32767/z

	from	rx1
	fmult
;	rol			; DYLAN - 1/8/94
	lms	rmhi,[m_vanishx]
;	ibt	rmhi,#mvanishx		; vanishx
	add	rmhi

	lms	rmlo,[m_xright]
	inc	rmlo
;	miwt	rmlo,mrightclp+1	; x clip check
	cmp	rmlo
	bcs	mgrdrawdotrts
	nop

	from	ry1
	to	rmhi
	fmult
	with	rmhi
;	rol			; DYLAN - 1/8/94
	lms	rz,[m_vanishy]
;	ibt	rz,#mvanishy		; vanishy
	with	rmhi
	add	rz

	lms	rmlo,[m_ybot]
;	miwt	rmlo,mbotclp	; y clip check
	from	rmhi
	cmp	rmlo
	bcs	mgrdrawdot4
	nop

	move	rz,rx		; save rpxx
	move	rx,r0		; x

	from	rgridx		; calc. grid colour
	xor	rgridz
	and	#4
	add	#11

	ibt	r0,#9
	colour

	move	r0,ry		; save rpxy
	move	ry,rmhi		; y
	plot

	miwt	rmhi,mgrid2z	; draw 2 dots if z<grid2z
	from	rz1
	to	rmhi
	sub	rmhi
	bcs	mgrdrawdot3
;	nop
	inc	ry
	dec	rx
	plot
mgrdrawdot3

	move	rx,rz		; restore rpxx
	move	ry,r0		; restore rpxy

mgrdrawdot4
	ENDC

	mlbra	mgrdrawdotrts



;************************************************


;minitdust
;mshowdust

	ifeq	0

mrand	macro

	from	rrand
	swap
	ror
	add	rrand
	to	rrand
	adc	rrand
	inc	rrand
	endm


rdustptr	equr	9
rrand	equr	8
rx1	equr	1
ry1	equr	2
rz1	equr	3
rt	equr	7

minitdust
;8/6/93 - two lists of dust points to be initialised now
	miwt	rrand,$19f8
	sms	[m_rand],rrand

	iwt	rdustptr,#m_dustpnts1&WM

	mcall	.init
	nop

	iwt	rdustptr,#m_dustpnts2&WM

	mcall	.init
	nop

	stop
	nop
.init
	miwt	rt,$80

	miwt	r12,mmaxdust
	move	r13,pc

	inc	rdustptr
	inc	rdustptr	; SKIP sprite type and flags

	mrand
	from	rrand
	mstwi	rdustptr	;x

	mrand
	from	rrand
;	or	rt
	mstwi	rdustptr	;y

	mrand
	from	rrand
	mstwi	rdustptr	;z

	ibt	r0,#mdustsizeof-8
	to	rdustptr	; SKIP projected x,y,z

	loop
	add	rdustptr

	jmp	r11
	nop



rdustptr	equr	9
routptr	equr	8
rrand	equr	7
rx	equr	1
ry	equr	2
rz	equr	3

dustrangez	=	5*1024/2
dustrangexy	=	4*1024/2


mshowdust2
	iwt	r11,#mshowdust2ret&WM
	iwt	r15,#mshowdust&WM
	nop
mshowdust2ret
	stop
	nop

mshowdust
	sms	[m_dotsorstars],r11

	ibt	r0,#ztab>>16
	romb

	lm	r0,[m_dustframe]
	lms	rrand,[m_rand]
	add	rrand
	sms	[m_rand],r0
	
	lm	rdustptr,[m_dustptr]	;8/6/93 dust points list is variable
;	miwt	rdustptr,m_dustpnts	;8/6/93 commented out
	miwt	routptr,m_rotpnts
;	ibt	r0,#mmaxdust		; 14/7/93
;	sms	[m_cnt],r0		; this is now set by the caller
	lms	r0,[m_cnt]		; check for zero
	lob
	sms	[m_spra],r0		; temporarily store it
	bne	.nz
	nop
	lms	pc,[m_dotsorstars]
	nop
.nz

;----- HACK 3/8/94 DYLAN -----
; set the colour frame ptr back by the amount of dots in the buffer
; then each sprite in the starfield can have a different animation frame

	lm	r0,[m_dustframe]
	inc	r0
	sbk
	sms	[m_colframe],r0
;----- END HACK -----

	mcache

mrotdustloop

;----- HACK 3/8/94 DYLAN -----
	lm	r0,[m_colframe]
	move	rx,r0
	inc	r0
	sbk

	ldb	[rdustptr]
;;	lms	r0,[m_dustflags]
	ibt	ry,#df_coloured!df_sprites
	and	ry
	cmp	ry
	bne	.nocolcheck
	nop

; now check if the animation and'ed with 3 has turned over to 0

	ibt	rz,#3
	from	rx
	and	rz
	cmp	rz
	mlbeq	.ovall
.nocolcheck
	
;----- END HACK -----

.reloop
	miwt	r4,dustrangexy
	miwt	r5,-dustrangexy

	ldb	[rdustptr]
 	sms	[m_realdustflags],r0	; store the flags

	inc	rdustptr
	inc	rdustptr	; SKIP sprite/colour and flags

;----- HACK TO ALLOW STARDUST TO ALWAYS FLY TOWARDS THE PLAYER - DYLAN 15/11/94 -----


	lms	rx,[m_realdustflags]
	ibt	r0,#df_moving
	and	rx
	beq	.notmoving_x
	nop
	lm	rx,[m_p1_vx]
	mldwi	rdustptr
	add	rx
	bra	.moving_x
	sbk
.notmoving_x

	mldwi	rdustptr
.moving_x
;	swap
	lms	rx,[m_viewposx]
	to	rx
	sub	rx

	from	rx
	sub	r4
	bcc	.1
	nop
	from	rx
	sub	r5
	bcs	.1
	nop
	mlbra	.ov1
.1
;----- HACK BY DYLAN TO ALLOW RAINING STARDUST AND RISING BUBBLES 3/8/94 ----

	lms	ry,[m_realdustflags]
	ibt	r0,#df_bubbles
	and	ry
	beq	.nobubbles
	nop
	mldwi	rdustptr
	ibt	ry,#70
	sub	ry
	bra	.raining
	sbk
.nobubbles
	ibt	r0,#df_raining
	and	ry
	beq	.notraining
	nop
	mldwi	rdustptr
	moves	r0,r0
	mlbpl	.ov2
	ibt	ry,#50
	add	ry
	bra	.raining
	sbk

.notraining
	ibt	r0,#df_moving
	and	ry
	beq	.notmoving_y
	nop
	lm	ry,[m_p1_vy]
	mldwi	rdustptr
	add	ry
	bra	.raining
	sbk

.notmoving_y

;---- END HACK -----
	mldwi	rdustptr
.raining
;	swap
	lms	ry,[m_viewposy]
	to	ry
	sub	ry

	from	ry
	sub	r4
	bcc	.2
	nop
	from	ry
	sub	r5
	bcs	.2
	nop

;----- HACK TO PREVENT Y-RANGE CHECKING WHEN DISPLAYING ASTEROIDS -----
	lms	rz,[m_realdustflags]
	ibt	r0,#df_belt!df_ground
	and	rz
	bne	.2
	nop
;----- END HACK -----


	mlbra	.ov2
.2
;----- HACK TO ALLOW STARDUST TO BE 'FLYING' ALONG Z PLANE - DYLAN 3/8/94 -----

	lms	rz,[m_realdustflags]
	ibt	r0,#df_moving
	and	rz
	beq	.notmoving
	nop
	lm	rz,[m_p1_vz]
	mldwi	rdustptr
	add	rz
	bra	.moving
	sbk


;----- END HACK -----
.notmoving
	mldwi	rdustptr
.moving
;	swap
	lms	rz,[m_viewposz]
	to	rz
	sub	rz

	miwt	r4,dustrangez
	miwt	r5,-dustrangez

	from	rz
	sub	r4
	bcc	.3
	nop
	from	rz
	sub	r5
	bcs	.3
	nop
	mlbra	.ov3
.3
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33

	mtest	r0
	mlbmi	.ov3

	mstwi	rdustptr			; z

	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	mstwi	rdustptr   			; x
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	mstwi	rdustptr			; y


	lms	r0,[m_cnt]
	dec	r0
	sbk
	mlbne	mrotdustloop

	mlbra	.ov

.ov1
	inc	rdustptr
	inc	rdustptr
.ov2
	inc	rdustptr
	inc	rdustptr
.ov3
	with	rdustptr
	sub	#8	; x,y,z +sprites,flags
.ovall

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Each star dust particle has its own set of eight flags
; describing what type it is. (check defflaglist df in dalcs.inc)
; If ground + (rain or belt or bubbles) is set it means
; that ground dust go in even entries and the other particles
; go in the odd entries... also the first 4 entries of
; the m_dustsprite table are ground dust sprites and
; entries 5-8 are for the other dust types
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	lm	r0,[m_dustflags]
	move	rz,r0

	ibt	ry,#0

;	iwt	r0,#df_mixed
;	and	rz
;	beq	.notmixed

;	lms	r0,[m_cnt]
;	and	#1
;	beq	.notmixed
;	nop

;	ibt	r0,#~(df_sprites)
;	to	rz
;	and	rz	; clear the raining/bubbly type flags leaving just ground
;.notmixed
	ibt	r0,#df_ground
	and	rz
	beq	.not_rainplusground
	nop
	ibt	r0,#df_raining!df_belt!df_bubbles
	and	rz
	beq	.not_rainplusground
	nop

	lms	r0,[m_cnt]
	and	#3
	beq	.not_rain
	nop

	ibt	ry,#4	; offset the table by 4 is m_cnt is even
	bra	.not_rainplusground
	nop
.not_rain
	ibt	r0,#~(df_raining!df_belt!df_bubbles)
	to	rz
	and	rz	; clear the raining/bubbly type flags leaving just ground

.not_rainplusground

	from	rz
	stb	[rdustptr]		; store the flags (lo byte only)
	sms	[m_realdustflags],rz
	inc	rdustptr

	mrand
	with	rrand
	and	#3
	lm	r0,[m_dustsprite]	; add in the base address of the table
	add	rrand
	to	r14
	add	ry
	getb

	stb	[rdustptr]	; store the sprite number

	inc	rdustptr
	
	
	lms	rrand,[m_rand]
	mrand
	from	rrand
	asr
	asr
	asr
	asr
;	asr
	to	rx		; x = -2k to 2k
	asr

	mrand
	from	rrand
	asr
	asr
	asr
	asr
	asr
	to	ry		; y = -2k to 2k
	asr

	mrand
	from	rrand
	lsr
	lsr
	lsr
	lsr
	lsr
	miwt	rz,512
	to	rz		; z = 1k to 5k
	add	rz
	sms	[m_rand],rrand

;	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	mdotprod16mq	m_wmat11,m_wmat12,m_wmat13
	lms	r4,[m_viewposx]
	add	r4
;	hib
	mstwi	rdustptr	; x


;	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	mdotprod16mq	m_wmat21,m_wmat22,m_wmat23
	lms	r4,[m_viewposy]
	add	r4
;	hib

	mstwi	rdustptr	; y   

;	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33
	mdotprod16mq	m_wmat31,m_wmat32,m_wmat33
	lms	r4,[m_viewposz]
	add	r4
;	hib
	mstwi	rdustptr	; z   


;----- HACK BY DYLAN TO CLAMP DOTS TO GROUND OR ASTEROID BELT 3/8/94 ----

	lms	r4,[m_realdustflags]
	ibt	r0,#df_ground!df_belt!df_raining
	and	r4
	beq	.norm
	nop
	dec	rdustptr
	dec	rdustptr
	dec	rdustptr
	dec	rdustptr

	ibt	r0,#df_raining
	and	r4
	beq	.notraining2
	nop

; if raining then add 'n' to viewpos (ceiling of rain)

	mrand
	from	rrand
	lob
	iwt	r4,#-512
	add	r4
	lms	r4,[m_viewposy]
	add	r4
	bra	.store_it
	nop
	
.notraining2
	ibt	r0,#df_belt
	and	r4
	beq	.zero_it
	nop

	iwt	r4,#255
	ldw	[rdustptr]
	and	r4
	bra	.store_it
	nop
	
.zero_it
	lm	r0,[m_shadowheight]
.store_it
	mstwi	rdustptr	; ZERO the y component
	inc	rdustptr
	inc	rdustptr

.norm
;----- END HACK ----

	
	ifeq	1
	with	routptr
	add	#4
	ibt	r0,#-1
	mstwi	routptr
	mlbra	.ovr
	endc

	with	rdustptr
	sub	#8		; x,y,z and sprite,flags
	mlbra	.reloop
.ov

;************************************************


mdust2z	=	1024

rrotptr	equr	7

mprojdust
;	ibt	r0,#15
;	colour

	sub	r0
	cmode

mprojdustloop2

	miwt	rsp,m_stack
	lm	rrotptr,[m_dustptr]	;8/6/93 dust points list is variable
;	miwt	rrotptr,m_rotpnts	;rotated points are stored in dust list now
;	ibt	r0,#8

	lms	r0,[m_spra]	; retrieve count from temporary store
	sms	[m_cnt],r0

;----- HACK 3/8/94 DYLAN -----
	lm	r0,[m_dustframe]
	sms	[m_colframe],r0
;----- END HACK -----

	mcache

mprojdustloop

;----- HACK 3/8/94 DYLAN -----
	lms	r0,[m_colframe]
	inc	r0
	sbk
;----- END HACK -----

	ldb	[rrotptr]
	sms	[m_realdustflags],r0	; store the flags
	inc	rrotptr
	ldb	[rrotptr]	; get the sprite id out
	sms	[m_x1],r0	; store it temporarily	

	with	rrotptr
	add	#7	; skip unrotated x,y,z and sprite/flags


	to	rz
	mldwi	rrotptr	; z
	to	rx
	mldwi	rrotptr	; x
	to	ry
	mldwi	rrotptr	; y

	mtest	rz
	mlbmi	mprojdustoff
	nop

	ifeq	1
	mcall	mprojectpnt
	nop

	ibt	rz,#$1f
	and	rz
	mtest	r0
	bne	.1
	nop
	plot	
.1
	endc

	ifeq	0

mdrawdust
	move	r6,rz
	miwt	r0,maxztab
	sub	r6
	bpl	.1
	nop
	miwt	r6,maxztab-1
.1

	IFEQ	0

	miwt	r0,128
	sub	r6
	bmi	.4
	nop
	beq	.4
	nop

	ifeq	1
	from	rx
	add	rx
;	bcs	.4
	nop
	move	rx,r0
	from	ry
	add	ry
;	bcs	.4
	nop
	move	ry,r0
	with	r6
	add	r6
;	mlbra	.1
	endc

	mlbra	mprojdustoff

	ENDC

.4

;----- MAJOR HACK BY DYLAN TO ALLOW SOFTWARE SPRITES INSTEAD OF DOTS 3/8/94 -----

	lms	rmhi,[m_realdustflags]
	ibt	r0,#df_sprites
	and	rmhi
	mlbeq	.dustasdots
	iwt	r0,#df_mixed
	and	rmhi
	beq	.notmixed
	nop

	lms	r0,[m_cnt]
	and	#3
	mlbne	.dustasdots
.notmixed

	lms	r0,[m_colframe]
	inc	r0
	sbk

	move	r0,r10
	iwt	r10,#m_stack&WM
	mpush	r0
	mpush	r1
	mpush	r2
	mpush	r3
	mpush	r4
	mpush	r5
	mpush	r6
	mpush	r7
	mpush	r8
	mpush	r9
	mpush	r10
	mpush	r11
	mpush	r12
	mpush	r13

	lms	r0,[m_colframe]
	inc	r0
	sbk

	


	sub	r0
	sms	[m_shift],r0
	sms	[m_sprxscale],r0
	lm	r0,[m_x1]
	sms	[m_spr0],r0
	ibt	r0,#32
	sms	[m_sprsize],r0
	lm	r0,[m_dustsize]
	sms	[m_spra],r0

	sms	[m_bigx],rx
	sms	[m_bigy],ry
	sms	[m_bigz],rz

	iwt	r0,#id_0_c&WM
	sms	[m_colourptr],r0

	mcall	mssprite
	nop

	


	mpop	r13
	mpop	r12
	mpop	r11
	mpop	r10
	mpop	r9
	mpop	r8
	mpop 	r7
	mpop	r6
	mpop	r5
	mpop	r4
	mpop	r3
	mpop	r2
	mpop	r1
	mpop	r0
	move	r10,r0

	mlbra	mprojdustoff

.dustasdots

;----- END HACK -----

	ibt	r0,#ztab>>16
	romb

	sub	r0
	cmode
.agn
	iwt	r0,#256
	sub	r6
	bmi	.noshift

	with	rx
	add	rx
	with	ry
	add	ry
	with	r6
	add	r6
	bra	.agn
	nop
.noshift

	with	r6
	bic	#1

	miwt	r0,ztab
	to	r14
	add	r6
	mgetw	r6		; 32767/z

	from	rx
	fmult
;	rol
	lms	rmhi,[m_vanishx]		; vanishx
	to	rx
	add	rmhi

	lms	rmlo,[m_xright]
	inc	rmlo
;	miwt	rmlo,mrightclp+1	; x clip check
	from	rx
	sub	rmlo
	bcs	.3
	add	rmlo

	from	ry
	fmult
;	rol
	lms	rmhi,[m_vanishy]		; vanishy
	to	ry
	add	rmhi

	lms	rmhi,[m_ybot]
;	miwt	rmhi,mbotclp	; y clip check
	from	ry
	sub	rmhi
	bcs	.3
	add	rmhi

	ifne	0	; gray scale stars
	from	rz		; 0 to 4k
	hib			; 0 to 15
	dec	r0
	dec	r0		;-2 to 13
	bpl	.22
	nop
	sub	r0
.22
	lsr			; 0 to 6
;	lsr			; 0 to 3
;	lsr			; 0 to 1
	ibt	rmhi,#5
	sub	rmhi
	bcc	.2
	add	rmhi
	ibt	r0,#4
.2
	mneg	r0
	add	#14
	endc

	ifne	1	; gray scale stars
	from	rz		; 0 to 4k
	hib			; 0 to 15
	ibt	rmhi,#16
	cmp	rmhi
	bmi	.21
	nop
	sub	r0
.21

;----- HACK DYLAN 3/8/94 Are the star dots coloured? -----

	lms	rmhi,[m_realdustflags]
	ibt	r8,#df_coloured
	with	rmhi
	and	r8
	bne	.nplan
	nop

;----- END HACK -----

	IFEQ	1

	bra	.snow	; hack to force white stars for the time-being
	nop
	lm	rmhi,[m_planetstars]
	with	rmhi
	lob
	dec	rmhi
	bmi	.nplan
	nop
	bne	.pollen
	nop

	ENDC

.snow	miwt	rmhi,snow_cols
	to	r14
	add	rmhi
	bra	.colcont2
	nop
.pollen
	ibt	r0,#3
	bra	.colcont3
	nop


.nplan
	miwt	rmhi,star_cols
.colcont
	to	r14
	add	rmhi

	lms	r0,[m_cnt]
	and	#3
	add	r0		
	add	r0		
	add	r0		
	add	r0		
	with	r14
	add	r0
.colcont2

	getb
.colcont3
	endc

	ifne	0	; random colour stars
	lms	r0,[m_cnt]
	and	#7
	inc	r0
	endc

	ifne	0	; red/yellow, blue and grey depth cued stars

	from	rz		; 0 to 4k
	hib			; 0 to 15
	dec	r0
	dec	r0		;-3 to 12
	bpl	.22		; 0 to 12
	nop
	sub	r0
.22
	lsr			; 0 to 6
	to	rmhi
	lsr			; 0 to 3

	lms	r0,[m_cnt]
	and	#3

;	ibt	r0,#2

	sub	#2
	bne	.221
	nop
	inc	r0	
	inc	rmhi
	inc	rmhi
.221
	add	#3		; 0,1,3
	add	r0		
	add	r0		; 4,8,16		
	sub	rmhi	

	endc

	colour
	plot

	ifne	0
	add	r0
.222
	dec	r0
	bne	.222	
	plot

	mlbra	mprojdustoff
	endc

	miwt	rmhi,mdust2z	; draw 2 dots if z<dust2z
	from	rz
	sub	rmhi
	bcs	.3
;	nop
	inc	ry
	dec	rx
	plot
.3
	endc

mprojdustoff
	lms	r0,[m_cnt]
	dec	r0
	sbk
	mlbne	mprojdustloop

;;;;	lm	r0,[m_mariopoll]
;;;;	moves	r0,r0
;;;;	beq	.nogo
;;;;	nop
;;;;	move	r0,r10
;;;;	iwt	r10,#(m_stack&WM)+mmaxstack/2
;;;;	mpush	r0
;;;;	mpush	rrotptr
;;;;	mcall	manswerpoll
;;;;	nop
;;;;	mpop	rrotptr
;;;;	mpop	r0
;;;;	move	r10,r0
;;;;.nogo

	lms	pc,[m_dotsorstars]
	nop

	endc


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; change dust in a particular area to another sprite
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; m_bigx, bigz is top left of area
; m_x1,m_z1 is width and height of area.
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; UNDER CONSTRUCTION - ie. not bloody finished yet due to hard disk crash
mchangedust
;	sub	r0
;	romb
;	ramb

;	lms	r1,[m_bigx]
;	lms	r2,[m_bigz]
;	lms	r3,[m_x1]
;	lms	r4,[m_z1]

	




;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Draw the turbo sprites
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; this draws sprites whose data is taken from the array
; ts_buffer
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�


mTurboSprites
	IFEQ	1
	sub	r0
	romb
	ramb

	iwt	r10,#m_stack&WM

	iwt	r11,#m_ts_buffer&WM
	iwt	r12,#number_turbosprites
	move	r13,r15
.loopit

	mpush	r11

	mldbi	r11
	sms	[m_spr0],r0	; sprite #id

	moves	r0,r0
	mlbeq	.nodr

	mldbi	r11
	sms	[m_spra],r0	; sprite size

	mldbi	r11
	sms	[m_colframe],r0	; animation frame
	to	r5
	lob

	ldb	[r11]
	lob		; the animation limit

	dec	r11

	inc	r5
	cmp	r5
	bne	.aok
	nop
	dec	r11
	dec	r11
	dec	r11	; go back to ts_sprite
	sub	r0
	stb	[r11]	; clear it
	mlbra	.nodr
.aok	
	stb	[r11]	; store new animation frame	

	inc	r11
	inc	r11

; world rotate the coordinates

	mldwi	r11
	lms	rx,[m_viewposx]
	to	rx
	sub	rx

	mldwi	r11
	lms	ry,[m_viewposy]
	to	ry
	sub	ry

	mldwi	r11
	lms	rz,[m_viewposz]
	to	rz
	sub	rz

	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33

	mtest	r0
	mlbmi	.nodr

	sms	[m_bigz],rz

	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	sms	[m_bigx],rx
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	sms	[m_bigy],ry


	mpush	r12
	mpush	r13

	sub	r0
	sms	[m_shift],r0
	sms	[m_sprxscale],r0

	ibt	r0,#32
	sms	[m_sprsize],r0

	ibt	r0,#32
	sms	[m_spra],r0

	ibt	r0,#115
	sms	[m_spr0],r0

	iwt	r0,#id_0_c
	sms	[m_colourptr],r0

	mcall	mssprite
	nop

	mpop	r13
	mpop	r12
.nodr

	mpop	r11
	ibt	r0,#ts_sizeof
	to	r11
	add	r11

	loop
	nop

	ENDC

	stop
	nop


