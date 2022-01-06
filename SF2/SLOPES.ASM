;                            �������������Ŀ
;���������������������������͵  StarFox II ������������������������������ͻ
;�                           ���������������                              �
;�  Copyright Argonaut Software Limited, 1993.                            �
;�  All Rights Reserved.                                                  �
;������������������������������������������������������������������������Ķ
;�  Filename:     SLOPES.ASM                                              �
;������������������������������������������������������������������������Ķ
;�  Description:  Code for finding height of nearest polygon,             �
;�                and various other slope dynamics related programs.      �
;������������������������������������������������������������������������Ķ
;�  Date:         5/3/93.                                                 �
;������������������������������������������������������������������������Ķ
;�  Author:       Dylan Cuthbert                                          �
;������������������������������������������������������������������������Ķ
;�  Modification list:                                                    �
;�                                                                        �
;������������������������������������������������������������������������ͼ

	incpub	slopes




;    ������������ͻ
;���Ķ WithinPoly ������������������������������Ŀ
;�   ������������ͼ                              �
;� Entry: y = Slopepolygon definition            �
;�       x1 = player's x                         �
;�       z1 = player's z                         �
;�       x2 = slope's x (centre of slope)        �
;�       z2 = slope's z                          �
;�    scale = scale shift value                  �
;�      DBR = $7f                                �
;� Exit:  a = non-zero if outside polygon        �
;�    scale = 0                                  �
;�������������������������������������������������

lx1	equ	ux
lz1	equ	uy

lx2	equ	vx
lz2	equ	vy

	LONGI
;��������������������������������������������������������������������������
WithinPoly_l
	php
	phy
	phx
	tyx
	a16


;��������������������������������������������������������������������������
; now call the mario chip to do the actual calculation
;��������������������������������������������������������������������������

	lda	x1
	sta.l	m_bigx
	lda	z1
	sta.l	m_bigz
	txa
	sta.l	m_pntptr

	lda	scale
	sta.l	m_scale

	a8
	call_mario	MWithinPoly


	a16
	lda.l	m_pntptr ; load result
	plx
	ply
	plp
	rtl


SlopePollMario
	pha
	php
	a8
	lda.l	slopepoll
	bne	.alreadypolled
	lda	#1
	sta.l	slopepoll
	jsl	pollmario_l	; Tell the mario chip to stop
.alreadypolled
	plp
	pla
	rts

SlopeUnpollMario
	pha
	php
	a8
	lda.l	slopepoll
	beq	.notpolled
	jsl	unpollmario_l	; Tell the mario chip to get going again
	lda	#0
	sta.l	slopepoll
.notpolled
	plp
	pla
	rts
	

;    �����������ͻ
;���Ķ GetHeight ������������������������������Ŀ
;�   �����������ͼ                              �
;� Entry: x = alien                             �
;� Exit:  y1 = y position of nearest polygon    �
;������������������������������������������������


getheight_l
	php
	phb
	phy
	a8i16
	lda	#0
	pha
	plb

	lda	#0
	sta.l	slopepoll

	phx

	a16
	jsl	slope_init_l

	ldx	allst
	lbeq	.nowtabout

.nxtal
	jsl	slope_check_l

	a16
	txa
	lbeq	.nowtabout

;��������������������������������������������������������������������������
; have found the nearest object (in x), shape ptr in y
; at this point:
; x   = slope object
; y   = slope shape
; x1  = player's x
; z1  = player's z
; x2  = slope shape's xmax
; z2  = slope shape's zmax
; tpa = player's shape
; tpx = player's object
;��������������������������������������������������������������������������

.gotone
	stx	currentslope
	lda	al_worldx,x
	sta	x2
	lda	al_worldy,x
	sta	y2
	lda	al_worldz,x
	sta	z2
	a8
	lda	al_roty,x
	sta	roty		; store the rotation of the slope
	lda	al_rotx,x
	sta	rotx		; store the rotation of the slope
	lda	al_rotz,x
	sta	rotz		; store the rotation of the slope

	jsr	SlopePollMario

	lda.l	alx_animframe,x
	bpl	.gameframe
	and	#127
	bra	.storit
.gameframe
	lda	gameframe
	and	#255
.storit
	sta	tpz
	stz	tpz+1
	a16

	lda	#0
	sta.l	currentslopepoly

	sty	tpa
	ldx.w	sh_slopebox,y
	cpx	tpa
	bne	.normslope

;��������������������������������������������������������������������������
; if not a slope, then it is a box
;��������������������������������������������������������������������������

	stz	tpa
	lda.w	sh_ymax,y
	nega
	clc
	adc	y2
	sta	y1
; set normal for box objects (straight up - flat)
	lda	#$8000
	sta.l	m_sprb
	lda	#0
	sta.l	m_spra
	sta.l	m_sprc
	lda	#0
	sta.l	currentslopetype

; now set up boundary limits for box
	lda.w	sh_xmax,y	; width of box
	sec			; +1 (move it *just* out of the bounding box)
	adc	x2		; add x of box
	sec
	sbc	x1		; subtract player's position
	sta	currentslopex2	; set right boundary
	clc			; -1
	sbc.w	sh_xmax,y	; set left boundary
	sec
	sbc.w	sh_xmax,y	; set left boundary
	sta	currentslopex1

	lda.w	sh_zmax,y
	sec			; +1
	adc	z2
	sec
	sbc	z1
	sta	currentslopez2
	clc			; -1
	sbc.w	sh_zmax,y
	sec
	sbc.w	sh_zmax,y
	sta	currentslopez1

	brl	.slopeexit
	
;��������������������������������������������������������������������������
; It is a normal slope
;
; at this point:
; x   = slope data
; y   = slope shape
; x1  = player's x
; z1  = player's z
; x2  = slope's x
; y2  = slope's y
; z2  = slope's z
; currentslope = slope object
; tpa = slope's shape
; tpx = player's object
; tpz = animation frame
;
;��������������������������������������������������������������������������
; Modification 13/5/94: player's x and z are made relative by rotating
; them into the slope (by the slope's rotation), then on exit the
; normal's and positions are rotated back (again by the slope's rotation)
;��������������������������������������������������������������������������
.normslope
	a8
	lda	#slopedata>>16
	pha
	plb
	a16

;��������������������������������������������������������������������������������
; Now to go about making the player's x and z relative (positional and rotational)
;��������������������������������������������������������������������������������

	lda	x1
	sec
	sbc	x2
	sta	x1
	lda	z1
	sec
	sbc	z2	; relative positonal
	sta	z1

;��������������������������������������������������������������������������
; rotate the player's point into the slope's area
;��������������������������������������������������������������������������

	phx

	lda	x1
	sta.l	m_x1
	lda	z1
	sta.l	m_z1

	lda	roty
	and	#255
	beq	.norot
	nega
	sta.l	m_roty

	call_mario	MRotatePoint

	lda.l	m_x1
	sta	x1
	lda.l	m_z1
	sta	z1

.norot
	IFEQ	1

	lda	rotx
	and	#255
	beq	.norotx
	nega
	sta.l	m_roty

	lda	#0
	sta.l	m_x1	; x rotation ie. y and z rotate around angle x
			; we don't need y so set it to zero

	call_mario	MRotatePoint

	lda.l	m_z1
	sta	z1
.norotx
	ENDC
	plx
;��������������������������������������������������������������������������
; number of slopes
;��������������������������������������������������������������������������
	lda.w	0,x
	and	#255
	sta	tpa
	inx

.onemore
	txa
	clc
	adc	#sl_sizeof
	sta	tpy

	lda.w	sl_frames,x
	and	#255
	beq	.noanim

	sta	y1
	ldy	#0
	txa

;��������������������������������������������������������������������������
; index into the animation
;��������������������������������������������������������������������������

.addup
	cpy	tpz
	bne	.nost
	tax
.nost
	clc
	adc	#sl_sizeof
	iny
	cpy	y1
	bne	.addup
	sta	tpy
	
;��������������������������������������������������������������������������
; and continue as normal
;��������������������������������������������������������������������������
.noanim
	lda.w	sl_width,x
	lsr	a
	clc
	adc.w	sl_x,x
	sec
	sbc	x1	; sbc worldx of colliding alien
	cmp.w	sl_width,x
	bcs	.nowt

	lda.w	sl_length,x
	lsr	a
	clc
	adc.w	sl_z,x
	sec
	sbc	z1	; sbc worldx of colliding alien
	cmp.w	sl_length,x
	bcc	.foundslope

.nowt
	ldx	tpy
	dec	tpa
	lbne	.onemore
	brl	.notclose	;.nowtabout

;��������������������������������������������������������������������������
; we have found the slope box, now comes the difficult part
; x = slope box
; x1,z1 = colliding object's x and z
; x2,z2 = slope's object's x and z
;��������������������������������������������������������������������������

.foundslope
; Check for within polygon collision detection
; ie. is this slope square or not?

	ldy.w	sl_poly,x	; pointer to polygon definition
	beq	.notpoly

	tya
	sta.l	currentslopepoly

	lda.w	sl_scale,x
	and	#255
	sta	scale		; copy the scale in

	jsl	WithinPoly_l	; returns ZERO if not inside polygon

	cmp	#0
	bne	.nowt		; the object isn't on this slope
				; otherwise carry on as normal
.notpoly

;��������������������������������������������������������������������������
; copy the x1,z1;x2,z2 parameters

	lda.w	sl_width,x
	lsr	a
	sec
	adc.w	sl_x,x	; add offset of slope
	sec
	sbc	x1	; subtract player's position (player becomes 0,0)
	sta.l	currentslopex2	; set right boundary
	clc		; -1
	sbc.w	sl_width,x
	sta.l	currentslopex1	; set left boundary

; do the same again for z

	lda.w	sl_length,x
	lsr	a
	sec
	adc.w	sl_z,x
	sec
	sbc	z1
	sta.l	currentslopez2
	clc
	sbc.w	sl_length,x
	sta.l	currentslopez1


; calculate the height of the current object's position on the slope

	lda.w	sl_nx,x
	and	#255
	xba
	sta.l	m_spra	; x normal
	lda.w	sl_ny,x
	and	#255
	xba
	sta.l	m_sprb	; y normal
	lda.w	sl_nz,x
	and	#255
	xba
	sta.l	m_sprc	; z normal of slope

	lda	x1	; player's x
	sta.l	m_bigx

	lda	z1
	sta.l	m_bigz

	lda.w	sl_dist,x
	sta.l	m_bigy

;;	lda.w	sl_rotx,x
;;	and	#255
;;	sta.l	m_rotx

;;	lda.w	sl_rotz,x
;;	and	#255
;;	sta.l	m_rotz

	lda.w	sl_type,x
	and	#255
	sta.l	currentslopetype

	call_mario	mslopeheight

	lda.l	m_bigy
	clc
	adc	y2
	sta	y1

;��������������������������������������������������������������������������
; is it the highest slope found yet?
;��������������������������������������������������������������������������
.slopeexit
	a8
	lda	#0
	pha
	plb		; DBR = 0
	a16

	ldx	tpx
	ldy	currentslope	; get shape pointer for slope
	lda.w	al_shape,y
	tay
	lda	y1
	sec
	adc.w	sh_ymax,y
	inc	a
	cmp	al_worldy,x
	lbmi	.notclose

	lda	y1
	cmp	closestslopeheight
	lbpl	.notclose


	lda	tpa
	sta	closestslopenum
	lda	y1
	sta	closestslopeheight
	lda	currentslope
	sta	closestslope
	lda.l	m_spra
	sta	tmp_spra
	lda.l	m_sprb
	sta	tmp_sprb
	lda.l	m_sprc
	sta	tmp_sprc
	lda.l	m_sprd
	sta	tmp_sprd
	lda.l	m_rotx
	sta	tmp_rotx
	lda.l	m_rotz
	sta	tmp_rotz
	lda	currentslopetype
	sta	closestslopetype
; copy the box's boundaries over
	lda	currentslopex1
	sta	closestslopex1
	lda	currentslopex2
	sta	closestslopex2
	lda	currentslopez1
	sta	closestslopez1
	lda	currentslopez2
	sta	closestslopez2

	lda	currentslopepoly
	sta	closestslopepoly

	lda	scale
	sta	closestslopescale
	
.notclose
	a8
	lda	#0
	pha
	plb
	a16
	ldy	currentslope
	ldx	_next,y

	beq	.exit

	ldy	tpx
	lda.w	al_shape,y
	sta	tpa
	lda.w	al_worldx,y
	sta	x1
	lda.w	al_worldz,y
	sta	z1
	brl	.nxtal
.nowtabout
.exit
	plx
	a8
	lda	#0
	pha
	plb

;	a16
;	lda	tmp_spra
;	sta.l	m_spra
;	lda	tmp_sprb
;	sta.l	m_sprb
;	lda	tmp_sprc
;	sta.l	m_sprc
;	lda	tmp_sprd
;	sta.l	m_sprd
;	lda	tmp_rotx
;	sta.l	m_rotx
;	lda	tmp_rotz
;	sta.l	m_rotz

	a16
	lda	closestslopeheight
	cmp	#MAGIC_Y
	bne	.notground
	lda	#0
.notground
	sta	y1
	lda	closestslope
	sta.l	alx_slopeptr,x
	beq	.nonormrot

	jsr	SlopePollMario

;����������������������������������������������������������������������������
; If on a slope rotate the slope's normals according to its rotation
;����������������������������������������������������������������������������
	tay
	lda.w	al_roty,y
	beq	.nonormrot
	sta.l	m_roty

; y rotation

	lda	tmp_spra
	asra
	asra
	sta.l	m_x1
	lda	tmp_sprc
	asra
	asra
	sta.l	m_z1

	phx
	call_mario	MRotatePoint
	plx

	lda.l	m_x1
	asl	a
	asl	a
	sta.l	m_spra
	sta	tmp_spra
	lda.l	m_z1
	asl	a
	asl	a
	sta.l	m_sprc
	sta	tmp_sprc
.nonormrot
	IFEQ	1
; now check for x rotation
	lda.w	al_rotx,y
	beq	.noxrot
	sta.l	m_roty
; y rotation

	lda	#0
	sta.l	m_x1
	lda	tmp_sprc
	asra
	asra
	sta.l	m_z1

	phx
	call_mario	MRotatePoint
	plx

	lda.l	m_z1
	asl	a
	asl	a
	sta.l	m_sprc
.noxrot
	ENDC

	a8
	lda	closestslopenum
	sta.l	alx_slopenum,x

	lda.l	closestslopetype
	sta.l	alx_slopetype,x

	jsr	SlopeUnpollMario

	ply
	plb
	plp
	rtl





;   �����������������ͻ
;��Ķ GeneralDynamics ����������������������������������������Ŀ
;�  �����������������ͼ                                        �
;�this routine is a general routine to call in order to move   �
;�an object around correctly in slopeworld.                    �
;���������������������������������������������������������������
;	in	:A = gravity(normal:0)

generaldynamics_l
	php
	phb
	a8

; set gravity
;	lda	#0
	sta	gd_off

	poll_mario

	lda	#$7e
	pha
	plb

	a16

	stz	dynamflag

;��������������������������������������������������������������������������
; store old x,y,z
;��������������������������������������������������������������������������
	lda	al_worldz,x
	sta	oldworldz
	lda	al_worldy,x
	sta	oldworldy
	lda	al_worldx,x
	sta	oldworldx

;��������������������������������������������������������������������������
; store the old slope
;��������������������������������������������������������������������������
	lda	al_slopeptr,x
	sta	lastslope

	lda	al_slopenum,x
	and	#255
	sta	lastslopenum

;��������������������������������������������������������������������������
; add vectors to position
;��������������������������������������������������������������������������
damping	=	3	; ex:10	(Kawagoe changed)

	lda	al_vx,x
	clc
	adc	#damping
	cmp	#damping*2
	bcs	.noz1
	lda	#damping
.noz1	sec
	sbc	#damping
	clc
	adc	al_worldx,x
	sta	al_worldx,x

	lda	al_vy,x
	clc
	adc	#damping
	cmp	#damping*2
	bcs	.noz2
	lda	#damping
.noz2	sec
	sbc	#damping
	clc
	adc	al_worldy,x
	sta	al_worldy,x

	lda	al_vz,x
	clc
	adc	#damping
	cmp	#damping*2
	bcs	.noz3
	lda	#damping
.noz3	sec
	sbc	#damping
	clc
	adc	al_worldz,x
	sta	al_worldz,x

;��������������������������������������������������������������������������
; add object movement vectors
;��������������������������������������������������������������������������

	lda	al_worldx,x
	clc
	adc	al_ox,x
	sta	al_worldx,x

	lda	al_worldy,x
	clc
	adc	al_oy,x
	sta	al_worldy,x

	lda	al_worldz,x
	clc
	adc	al_oz,x
	sta	al_worldz,x

;��������������������������������������������������������������������������
; add some g
;��������������������������������������������������������������������������

	lda	gd_off	;=! 0 no toki gravity wa off.
			;gd_off ha generaldynamics_l wo
			;call suru tokini set suru.
	and	#0ffH
	bne	.nogthisframe

	lda	al_vy,x
	clc
	adc	gd_gravity	;#4(normal no atai)
	sta	al_vy,x
.nogthisframe

;��������������������������������������������������������������������������
; scale up vectors
;��������������������������������������������������������������������������
	lda	al_vx,x
	asl	a
	asl	a
          	asl	a
	sta	al_vx,x

	lda	al_vy,x
	asl	a
	asl	a
	asl	a
	sta	al_vy,x

	lda	al_vz,x
	asl	a
	asl	a
	asl	a
	sta	al_vz,x

	lda	al_mx,x
	asl	a
	asl	a
	asl	a
	sta	al_mx,x

	lda	al_my,x
	asl	a
	asl	a
	asl	a
	sta	al_my,x

	lda	al_mz,x
	asl	a
	asl	a
	asl	a
	sta	al_mz,x


;��������������������������������������������������������������������������
; get the height of the current slope
;��������������������������������������������������������������������������

.tryonceagain
	jsl	getheight_l

; --- Copy some variables into mario ram ---
	a16
	lda	tmp_spra
	sta.l	m_spra
	lda	tmp_sprb
	sta.l	m_sprb
	lda	tmp_sprc
	sta.l	m_sprc
	lda	tmp_sprd
	sta.l	m_sprd
	lda	tmp_rotx
	sta.l	m_rotx
	lda	tmp_rotz
	sta.l	m_rotz

;��������������������������������������������������������������������������
; check if on same slope
;��������������������������������������������������������������������������

	lda	al_slopeptr,x
	cmp	lastslope
	bne	.doit
	

	lda	al_slopenum,x
	and	#255
	cmp	lastslopenum
	bne	.doit

	ldy	al_slopeptr,x
	beq	.doit

;��������������������������������������������������������������������������
; if on the same slope, move the object with the slope
;��������������������������������������������������������������������������

	lda.w	al_vy,y
	clc
	adc	al_worldy,x
	sta	y2
	clc
	adc	#damping
	sec
	sbc	y1
	lbmi	.aboveslope

	lda	y2
	sta	al_worldy,x

;;	lda.w	al_vx,y
;;	clc
;;	adc	al_worldx,x
;;	sta	al_worldx,x

;;	lda.w	al_vz,y
;;	clc
;;	adc	al_worldz,x
;;	sta	al_worldz,x


	jmp	.sameslope
.doit

	lda	al_worldy,x
	clc
	adc	#damping
	sec
	sbc	y1
	lbmi	.aboveslope

;��������������������������������������������������������������������������
; check if we can just step on to this slope
;��������������������������������������������������������������������������

stepup	=	30

	lda	al_worldy,x
	sec
	sbc	y1
	lbmi	.sameslope
	cmp	#stepup
	lbcc	.sameslope

;��������������������������������������������������������������������������
; we've hit a wall, now what?
;��������������������������������������������������������������������������

	lda	dynamflag
	bit	#2
	lbne	.nothrow

	ora	#4	; set 'collision' flag
	sta	dynamflag

	lda	dynamflag
	bit	#1
	beq	.slideit

; if the worst things come to the worst restore last known position
	lda	oldworldx
	sta	al_worldx,x
	lda	oldworldz
	sta	al_worldz,x

	lda	dynamflag
	ora	#2
	sta	dynamflag

	bra	.continueit

;��������������������������������������������������������������������������
; adjust position to edge of object
;��������������������������������������������������������������������������
.slideit
	jsr	clamptoside
	
	lda	al_worldx,x
	clc
	adc	x1
	sta	al_worldx,x

	lda	al_worldz,x
	clc
	adc	z1
	sta	al_worldz,x

.continueit
;��������������������������������������������������������������������������
; transfer energy into the object hit
;��������������������������������������������������������������������������

	ldy	al_slopeptr,x
	beq	.onground2

;;	lda.w	al_vy,y
;;	clc
;;	adc	al_worldy,x
;;	sta	al_worldy,x

;;	lda.w	al_vx,y
;;	clc
;;	adc	al_worldx,x
;;	sta	al_worldx,x

;;	lda.w	al_vz,y
;;	clc
;;	adc	al_worldz,x
;;	sta	al_worldz,x

	IFEQ	1
	lda	al_vx,x
	asra
	asra
	sta	x1
	lda	al_ox,x
	asra
	asra
	clc
	adc	x1
	clc
	adc.w	al_vx,y
	sta.w	al_vx,y
	
	lda	al_vz,x
	asra
	asra
	sta	x1
	lda	al_oz,x
	asra
	asra
	clc
	adc	x1
	clc
	adc.w	al_vz,y
	sta.w	al_vz,y

	ENDC

.onground2
	lda	dynamflag
	ora	#1
	sta	dynamflag


	brl	.tryonceagain

.sameslope

;��������������������������������������������������������������������������
; throw the object up
;��������������������������������������������������������������������������

	s_jmp_NOTalsflag	x,ontheground,.nothrow

	lda	al_worldy,x
	sec
	sbc	y1
	asl	a
	sta	x1
	asl	a
	clc
	adc	x1
	sta.l	m_spr0

.nothrow

;��������������������������������������������������������������������������
; tell the strategy it's on the ground
;��������������������������������������������������������������������������
	a8
	s_set_alsflag	x,ontheground
	a16
;��������������������������������������������������������������������������
; rotate the object's movement vectors to the rotation of the slope
;��������������������������������������������������������������������������

	lda	y1
	pha

	phx
	lda.l		m_rotx
	and		#255
	xba
	eor		#-1
	inc		a
	sta		matxw
	lda.l		m_rotz
	and		#255
	xba
	eor		#-1
	inc		a
	sta		matzw
	stz		matyw
	a8
	jsl		crotmat16_l
	ai16
	copymat16	mat,wmat

	plx
	phx
	
	lda	al_mx,x
	sta	x1

	lda	al_mz,x
	sta	z1

	stz	y1

	a8
	jsl	wmatrotp16_l
	ai16

	plx
	lda	bigx
	adiv2
	adiv2
	adiv2
	sta	al_ox,x

	lda	bigy
	adiv2
	adiv2
	adiv2
	clc
	adc	al_my,x
	sta	al_oy,x

	lda	bigz
	adiv2
	adiv2
	adiv2
	sta	al_oz,x
.dontdo
	pla
	sta	y1

.goahead
;��������������������������������������������������������������������������
; spra, sprb, & sprc are set up from the previous call to getheight
; (spra,sprb & sprc is the normal vector for the current slope)
;��������������������������������������������������������������������������

;��������������������������������������������������������������������������
; copy the object's movement vector
;��������������������������������������������������������������������������
	lda	al_vx,x
	sta.l	m_bigx
	lda	al_vy,x
	sta.l	m_bigy
	lda	al_vz,x
	sta.l	m_bigz

	lda	#$4000
	sta.l	m_sprd	; bounciness

	phx
	call_mario	mslopebounce
	plx

;��������������������������������������������������������������������������
; copy the vectors back
;��������������������������������������������������������������������������
	lda.l	m_bigx
	sta	al_vx,x
	lda.l	m_bigy
	sta	al_vy,x
	lda.l	m_bigz
	sta	al_vz,x

;��������������������������������������������������������������������������
; clamp the object to the slope if need be
;��������������������������������������������������������������������������
	lda	y1
	sta	al_worldy,x
	

;��������������������������������������������������������������������������
; slope friction
;��������������������������������������������������������������������������
	lda	al_vx,x
	sta.l	m_bigx
	lda	al_vz,x
	sta.l	m_bigz
	phx
	call_mario	mscalexz_s
	plx
	lda.l	m_bigx
	sta	al_vx,x
	lda.l	m_bigz
	sta	al_vz,x

	bra	.continue

;��������������������������������������������������������������������������
;��������������������������������������������������������������������������


.aboveslope
;��������������������������������������������������������������������������
; tell the strategy it's not on the ground
;��������������������������������������������������������������������������
	a8
	s_clr_alsflag	x,ontheground
	a16

;��������������������������������������������������������������������������
; Still allow thrust to be applied when in the air
;��������������������������������������������������������������������������
	lda	al_mx,x
	adiv2
	adiv2
	adiv2
	sta	al_ox,x
	lda	al_my,x
	sta	al_oy,x
	lda	al_mz,x
	adiv2
	adiv2
	adiv2
	sta	al_oz,x

;��������������������������������������������������������������������������
; air friction
;��������������������������������������������������������������������������
	lda	al_vx,x
	sta.l	m_bigx
	lda	al_vz,x
	sta.l	m_bigz
	phx
	call_mario	mscalexz_a
	plx
	lda.l	m_bigx
	sta	al_vx,x
	lda.l	m_bigz
	sta	al_vz,x

.continue
	stz	al_mx,x
	stz	al_mz,x
	stz	al_my,x

;��������������������������������������������������������������������������
; scale down vectors
;��������������������������������������������������������������������������
	lda	al_vx,x
	adiv2
	adiv2
	adiv2
	sta	al_vx,x

	lda	al_vy,x
	adiv2
	adiv2
	adiv2
	sta	al_vy,x

	lda	al_vz,x
	adiv2
	adiv2
	adiv2
	sta	al_vz,x

;��������������������������������������������������������������������������
; calculate distance moved
;��������������������������������������������������������������������������
	lda	oldworldx
	eor	#-1
	clc
	adc	al_worldx,x
	sta.l	m_bigx

	lda	oldworldy
	eor	#-1
	clc
	adc	al_worldy,x
	sta.l	m_bigy

	lda	oldworldz
	eor	#-1
	clc
	adc	al_worldz,x
	sta.l	m_bigz

	phx
	call_mario	mveclen
	plx

;��������������������������������������������������������������������������
; set rotation
;��������������������������������������������������������������������������

;	a8
;	lda.l	m_rotx+1
;	sta	x1
;	s_achase_alvar	B,x,al_rotx,x1,1
	
;	lda.l	m_rotz+1
;	sta	x1
;	s_achase_alvar	B,x,al_rotz,x1,1

	a8
	unpoll_mario

	plb
	plp
	rtl



;   ������ͻ
;��Ķ SUCK ���������������������������������������������������Ŀ
;�  ������ͼ                                                   �
;�this routine sucks objects towards the current object (in x) �
;���������������������������������������������������������������

suckrange	=	500

suck_l
	php
	phb
	a8
	lda	#$7e
	pha
	plb

	phx


	a16
	lda	al_worldx,x
	sta	x1
	lda	al_worldy,x
	sta	y1
	lda	al_worldz,x
	sta	z1

	stx	tpx

	ldx	allst
	lbeq	.nowtabout
.nxtal
	cpx	tpx
	lbeq	.notthisone

;	s_jmp_NOTalsflag	x,pickupable,.notthisone

;��������������������������������������������������������������������������
; calculate the distance between sucker and suckee
;��������������������������������������������������������������������������
	lda	x1
	sec
	sbc	al_worldx,x
	sta.l	m_bigx

	lda	y1
	sec
	sbc	al_worldy,x
	sta.l	m_bigy

	lda	z1
	sec
	sbc	al_worldz,x
	sta.l	m_bigz

	phx
	call_mario	mveclen
	plx

	lda.l	m_z1
	cmp	#suckrange
	bcs	.notthisone


	lda	#10
	sta.l	m_x1
	
	phx
	call_mario	mdividevecs	
	plx
	
	lda.l	m_bigx
	clc
	adc	al_vx,x
	sta	al_vx,x

	lda.l	m_bigy
	clc
	adc	al_vy,x
	sta	al_vy,x

	lda.l	m_bigz
	clc
	adc	al_vz,x
	sta	al_vz,x

.notthisone
	lda	_next,x
	tax
	lbne	.nxtal
	
	

.nowtabout
	plx
	plb
	plp
	rtl


;   �����������ͻ
;��Ķ Whichside ����������������������������������������������Ŀ
;�  �����������ͼ                                              �
;�Calculates which side of an object another object is,        �
;�by calculating a normal and then calculating a plane         �
;�equation.                                                    �
;�Entry: x,y = object 1, object 2                              �
;�Exit:  a = high byte of distance                             �
;���������������������������������������������������������������


whichside_l
	a8
	stz	x1
	stz	y1
	lda	#127
	sta	z1
whichside2_l
	php
	a8i16
	phb
	lda	#$7e
	pha
	plb

	phy
	phx

;��������������������������������������������������������������������������
; calculate the normal
;��������������������������������������������������������������������������

	sty	tmpy

	ldy	dummyobj
	s_set_alvar	W,y,al_worldx,#0
	s_set_alvar	W,y,al_worldy,#0
	s_set_alvar	W,y,al_worldz,#0
	s_add_roffs2pos	B,y,y,x,x1,y1,z1,1,1,1
	
	poll_mario

	s_copy_alvar2var.l	W,y,m_x1,al_worldx,<xba%n	and	#$ff00>
	s_copy_alvar2var.l	W,y,m_y1,al_worldy,<xba%n	and	#$ff00>
	s_copy_alvar2var.l	W,y,m_z1,al_worldz,<xba%n	and	#$ff00>

;��������������������������������������������������������������������������
; calculate the shape's offset
;��������������������������������������������������������������������������

	ldy	tmpy
	a16
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	sta.l	m_bigx
	
	lda.w	al_worldy,y
	sec
	sbc	al_worldy,x
	sta.l	m_bigy

	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	sta.l	m_bigz

	a8

;��������������������������������������������������������������������������
; Now calculate bigx*x1+bigy*y1+bigz*z1 using the Super FX
;��������������������������������������������������������������������������

	call_mario	mwhichside

	a16
	lda.l	m_spra
	xba
	a8
	sta	x1
	unpoll_mario
	lda	x1
	plx
	ply
	plb
	plp
	rtl




;   ����������������������������������ͻ
;��Ķ Position and Distance from Plane �����������������������Ŀ
;�  ����������������������������������ͼ                       �
;� This calculates the normal for object #1's orientation      �
;� and then calculates the distance from the plane of #2, then �
;� revectors that back to find the point on the plane itself   �
;� eg.                                                         �
;�     Ax+By+Cz = -D (ABC = nx,ny,nz; xyz = object #2)         �
;�     x' = DA+x                                               �
;�     y' = DB+y                                               �
;�     z' = DC+z  xyz' = point of intersection with #1's plane �
;�                                                             �
;� Entry:                                                      �
;�     x = object to generate plane from (normally the player) �
;�     y = object to calculate D and xyz' for                  �
;� Exit:                                                       �
;�     bigx = point of intersection x                          �
;�     bigy = point of intersection y                          �
;�     bigz = point of intersection z (it is relative from #1) �
;�     spra = Distance of #1's plane from #2                   �
;�                                                             �
;���������������������������������������������������������������

pdpcalc_l
	php
	a8i16
	phb
	lda	#$7e
	pha
	plb


	stz	x1
	lda	#127
	sta	y1
	stz	z1
	jsl	whichside2_l	; this calculates ABCD and xyz

	call_mario	mrevec	; calculate it into bigx,bigy,bigz


	plb
	plp
	rtl



;   �����������������ͻ
;��Ķ Clamptoside     ����������������������������������������Ŀ
;�  �����������������ͼ                                        �
;�this routine clamps the object in x to the side of the last  �
;�slope it was standing on.                                    �
;�It returns the vector which should be added to x,z           �
;���������������������������������������������������������������
;    in:  closestslopex1/x2/y1/y2 = boundary box of slope
;         (these are normally set up by GETHEIGHT_L)
;    out :X1,Z1 = vector
; trashes x1

_ctscheck	MACRO	[which,num]

	lda	closestslope{which}{num}
	bpl	.ok\@
	nega
.ok\@	cmp	tpa
	bcs	.no\@
	sta	tpa
	lda	closestslope{which}{num}
	sta	{which}1
	IFC	"{which}","x"
	stz	z1
	ELSEIF
	stz	x1
	ENDC
.no\@
	ENDM


clamptoside_l
	jsr	clamptoside

	rtl

clamptoside
	php
	phy
	a16
	lda	closestslopepoly
	lbeq	.ok
; slope polygon

	sta	x1

	a8
	POLL_MARIO
	a16

	lda	closestslopescale
	sta.l	m_scale


	lda	x1
	sta.l	m_pntptr

	ldy	closestslope

	lda.w	al_worldx,x
	sec
	sbc.w	al_worldx,y
	sta.l	m_x1

	lda.w	al_worldz,x
	sec
	sbc.w	al_worldz,y
	sta.l	m_z1		; get player's coordinates relative

	phx

	lda.w	al_roty,y
	and	#255
	pha
	beq	.noroty
	nega
	sta.l	m_roty

	call_mario	MRotatePoint

.noroty
	lda.l	m_x1
	sta.l	m_bigx
	lda.l	m_z1
	sta.l	m_bigz

	call_mario	MClosestLine

	lda.l	m_bigx
	nega
	sta.l	m_x1
	lda.l	m_bigz
	nega
	sta.l	m_z1

	pla
	beq	.noroty2
	sta.l	m_roty

	call_mario	MRotatePoint

.noroty2
	lda.l	m_x1
	sta	x1
	lda.l	m_z1
	sta	z1

	plx

	a8
	UNPOLL_MARIO

	ply
	plp
	rts
.ok
	LONGA
; normal 'box' polygon

	lda	#$ffff
	sta	tpa
	stz	x1
	stz	z1

	_ctscheck	x,1
	_ctscheck	z,1
	_ctscheck	x,2
	_ctscheck	z,2

	ply
	plp
	rts

weirdness_l
	php
	a8i16
	POLL_MARIO
	phb

	lda	#$70
	pha
	plb

	a16
	lda	#-500
	sta	x1
	stz	y1
	a8

	ldx	#0
	ldy	#0
.loop
	a8

	lda.l	testtable,x
	cmp	#32
	beq	.nopiece

	lda	#df_sprites
	sta	m_dustpnts1,y
	lda	#124
	sta	m_dustpnts1+1,y

	a16
	lda.l	player1_worldx
	clc
	adc	x1
	sta	m_dustpnts1+2,y
	lda	y1
	sta	m_dustpnts1+4,y
	lda.l	player1_worldz
	clc
	adc	#2000
	sta	m_dustpnts1+6,y

	tya
	clc
	adc	#mdustsizeof
	tay

.nopiece	a16

	lda	x1
	clc
	adc	#32
	sta	x1

	inx
	txa
	and	#63
	bne	.loop

	lda	x1
	sec
	sbc	#64*32
	sta	x1
	
	lda	y1
	clc
	adc	#32
	sta	y1

	txa
	cmp	#endtesttable-testtable
	bne	.loop
	

	a8
	plb
	UNPOLL_MARIO
	plp
	rtl


testtable
;	db	"00  0   0 0     00  0  0     00 0  0 000 0  0 000  000 000  000 "
;	db	"0 0  0 0  0    0  0 00 0    0   0  0  0  0  0 0  0 0   0  0  0  "
;	db	"0  0  0   0    0000 0 00    0   0  0  0  0000 000  00  000   0  "
;	db	"0 0   0   0    0  0 0  0    0   0  0  0  0  0 0  0 0   0 0   0  "
;	db	"00    0   0000 0  0 0  0     00  00   0  0  0 000  000 0  0  0  "
endtesttable


