	shorta
	longi

; this routine finds an existing hitlist block for the alien block in x
; with the alien block in y
; if it cannot find an existing one it creates a new one.. if possible
; it returns a pointer to the block in x1 (x and y are preserved)
gethitlistptr
	stx	x2
	sty	y2
	a16
	tya
	ldy.w	al_hitlist,x
	beq	.createnewone
	tyx
.search
	cmp.w	hl_alptr,x
	beq	.foundone
	ldy.w	_next,x
	tyx
	bne	.search

.createnewone
	ldx	x2
	lda	al_hitlist,x
	sta	y1	; store hitlist ptr

	tax
	l_add.w	y1,hitlistfree,.nocando

	ldy	x2	; restore hitlist ptr
	lda	y1
	sta.w	al_hitlist,y

; now to initialise the new hitlist area
	stz.w	hl_alptr,x
	stz.w	hl_hlptr,x
	a8
	lda	#hf_firstframe
	sta.w	hl_flags,x
	stz.w	hl_hitflags,x
	stz.w	hl_count,x
.foundone
	a8
	lda.w	hl_flags,x
	ora	#hf_stillcolliding
	sta.w	hl_flags,x	; set flags to show that it is still active

	inc.w	hl_count,x	; frame count

	stx	x1
	ldx	x2
	ldy	y2
	rts
.nocando	blink

;�������������������������������������������������������������
; Call the resource end_hit
; x is current alien
; y is current alien's current hitlist entry
	LONGI
	LONGA
call_end_hit
	php
	phy

	sty	hit_hlptr

	lda.w	hl_alptr,y	; get offending alien's pointer
	tay
	a8

	phy
	s_get_resource	L,x,tjmp,end_hit,.noend
	ply
	phy

	storenasty

	lda	#.noend2>>16
	pha
	pea	(.noend2-1)&WM

	romnastyoff
	jmp.l	[tjmp]
.noend2
	restorenasty
.noend
	ply

	ply
	plp
	rts

;����������������������������������������������������������
	LONGI
	LONGA
removehl_l
; remove the hitlist entry that is linked to this one first
	phx
	phy

	jsr	call_end_hit

	ldx.w	hl_alptr,y
	lda.w	hl_hlptr,y
	tay

	jsr	call_end_hit

	lda	al_hitlist,x
	sta	y1
	phx
	tyx
	l_rem.w	y1,hitlistfree
	plx
	lda	y1
	sta	al_hitlist,x

	ply
	plx

; now actually delete this hitlist entry
	lda	al_hitlist,x
	sta	y1
	phx
	tyx
	l_rem.w	y1,hitlistfree
	plx
	lda	y1
	sta	al_hitlist,x
	rtl


	shorta
	longi


; this macro does a collision detection check
; xcol,ycol,zcol = sh_maxx-z of shape #1
; xp,ys,zp = x,y,z of shape #1
; tpx,tpy,tpz = x,y,z of shape #2
; x points to shape header or collision box structure
coldet	MACRO	; notcollidedroutine,collidedroutine,offset value for x y and z

;offsetforx	=	\3	;sh_xmax
;offsetfory	=	\4	;sh_ymax
;offsetforz	=	\5	;sh_zmax


	lda.\0	\5,x
	clc
	adc	zcol
	sta	rangexz
	lda	tpz	; alien's z
	sec
	sbc	zp
	bpl	.chkcoll5\@
	eor	#WM
	inc	a
.chkcoll5\@
	sec
	sbc	rangexz
	bmi	.chkcoll6\@
	jmp	\1
.chkcoll6\@
	lda.\0	\3,x
	clc
	adc	xcol
	sta	rangexz
	lda	tpx		; alien's x
	sec
	sbc	xp
	bpl	.chkcoll2\@
	eor	#WM
	inc	a
.chkcoll2\@
	sec
	sbc	rangexz
	bmi	.chkcoll3\@
	jmp	\1
.chkcoll3\@

	lda.\0	\4,x
	clc
	adc	ycol
	sta	rangexz
	lda	tpy	; alien's y + height
	sec
	sbc	ys
	bpl	.chkcoll51\@
	eor	#WM
	inc	a
.chkcoll51\@
	sec
	sbc	rangexz
	bmi	\2
	jmp	\1
	ENDM



scale_a	MACRO
	sta	x1
	lda	scale
	and	#cbf_scale
	beq	.noscale\@
	sty	scalecnt
	tay
;	sta	scalecnt
	lda	x1
.keepscaling\@
	asl	a
	dey
;	dec	scalecnt
	bne	.keepscaling\@
	ldy	scalecnt
	bra	.scaled\@
.noscale\@
	lda	x1
.scaled\@

;	sta	x1
;	lda	scale
;	and	#cbf_scale
;	beq	.ns\@
;
;	stx	scalecnt
;	asl	a
;	tax
;	lda	x1
;	jmp	(.tab\@,x)
;.tab\@	dw	.s0\@
;	dw	.s1\@
;	dw	.s2\@
;	dw	.s3\@
;	dw	.s4\@
;	dw	.s5\@
;	dw	.s6\@
;	dw	.s7\@
;.s0\@	ldx	scalecnt
;	bra	.sd\@
;.s1	asl	a
;	ldx	scalecnt
;	bra	.sd\@
;.s2	asl	a
;	asl	a
;	ldx	scalecnt
;	bra	.sd\@
;.s3	asl	a
;	asl	a
;	asl	a
;	ldx	scalecnt
;	bra	.sd\@
;.s4	asl	a
;	asl	a
;	asl	a
;	asl	a
;	ldx	scalecnt
;	bra	.sd\@
;
;.s5	asl	a
;	asl	a
;	asl	a
;	asl	a
;	asl	a
;	ldx	scalecnt
;	bra	.sd\@
;.s6	asl	a
;	asl	a
;	asl	a
;	asl	a
;	asl	a
;	asl	a
;	ldx	scalecnt
;	bra	.sd\@
;.s7	asl	a
;	asl	a
;	asl	a
;	asl	a
;	asl	a
;	asl	a
;	asl	a
;	ldx	scalecnt
;	bra	.sd\@
;
;.ns\@	lda	x1
;.sd\@
	ENDM



; tmpx,xp,ys,zp,x1,y1,z1,collradius

chkcoll_l
	jsr	chkcoll
	rtl


init_strats_ram_l
	phb
	php

	a8i16
	lda	#$7e
	pha
	plb		; set data bank register

	ldx	allst
.ccf	s_jmp_NOTalsflag x,removeme,.dontremove
	a16
	lda	_next,x
	pha
	a8
	s_remove_obj	x,really
	ply
	tyx
	jmp	.okgo	
.dontremove
; set the real invincibility flag here...
; if it is set in the strategies problems arise.

	s_jmp_alsflag	x,nohitaffect,.setit
	s_clr_alsflag	x,nohitaffect_really
	bra		.okclr
.setit	s_set_alsflag	x,nohitaffect_really
.okclr

	s_jmp_alsflag	x,collide,.ncci
	s_clr_alsflag	x,Lcollide
; obsolete	s_set_alvar	B,x,al_collcount,#1
	bra		.nclc
.ncci	s_set_alsflag	x,Lcollide
.nclc	s_clr_alsflag	x,collide

; obsolete	s_set_alvar	W,x,al_collobjptr,#0

; now to scan the hitlist for irrelevants (banana bouqet)

	ldy	al_hitlist,x
	beq	.nc	; nothing in there
	a16
.nxthl
	lda.w	_next,y
	pha

	lda.w	hl_flags,y
	bit	#hf_stillcolliding
	bne	.clrit
; it is no longer colliding so remove it
	jsl	removehl_l
	bra	.nxt1
.clrit
; clear the stillcolliding flag
	a8
	and	#~hf_stillcolliding
	sta.w	hl_flags,y
	a16
.nxt1
	ply
	bne	.nxthl

	a8

.nc	txy
	ldx	_next,y
.okgo
	bne	.ccf



;----------------------------------------------------
	lda	collistcnt
	beq	.mmiss

	ldx	#0
.dc
	phx
	jsr	chkcoll
	plx

	a16
	txa
	clc
	adc	#cl_sizeof
	tax
	a8

	dec	collistcnt
	bne	.dc
.mmiss

	plp
	plb
	rtl


	shorta
	longi


chkcoll
	stx	tmpy

	ldy	cl_alien&WM,x
	tyx
	stx	tmpx

;	test_alsflag	x,collide
;	lbne	.finish

	ldy	al_shape,x
	sty	currshape
	ldy	tmpy

	stz	flagset
	stz	scale+1

	a16

.usexyz	lda.w	cl_colbox&WM,y
	lbeq	.normcol	; normal collision detection?

	km_db7f			; databank 7f

.andagain	tay			; y is now box list pointer
	a8
	stz	temphitflag
	lda.w	cb_frame,y
	beq	.noanim		; check for animated box
	dec	a
	sta	x1
	lda.l	alx_animframe,x
	bpl	.normanim
	and	x1
	beq	.firstframe
	bra	.intoanim
.normanim	lda	x1
	and	gameframe
	beq	.firstframe
.intoanim	a16
	and	#127
	sta	x1
	tya			; y->a
	ldy	x1		; a->y
	clc
.add
	adc	#cb_sizeof		; crappy and slow..
	dey
	bne	.add
	tay
	a8
	
.firstframe
.noanim
	lda.w	cb_rotz,y
	sta	scale
	bit	#cbf_rotz!cbf_roty!cbf_rotx!cbf_rotxyz
	lbeq	.normrot
	bit	#cbf_rotz
	lbne	.rotz
	bit	#cbf_roty
	lbne	.roty
	bit	#cbf_rotx
	lbne	.rotx
.rotxyz
; full rotation... zxy
; first, z rotation...
	lda.w	cb_xoff,y
	sta	x1
	sta	x2

	lda.w	cb_yoff,y
	sta	y1
	sta	y2

	lda.l	al_rotz,x
	beq	.missrotz2
	jsl	rotate_8yx_ram_l
.missrotz2
; next, x rotation...
	lda	y2
	sta	y1	; get y from previous rotate

	lda.w	cb_zoff,y
	sta	z1
	sta	z2

	lda.l	al_rotx,x
	beq	.missrotx2
	jsl	rotate_8yz_ram_l
.missrotx2
; next y rotation...
	lda	x2
	sta	x1	; values from previous rotates

	lda	z2
	sta	z1

	lda.l	al_roty,x
	beq	.missroty2
	jsl	rotate_8xz_ram_l
.missroty2
; now to scale and add to offsets...
	a16
	lda	x2
	sexa
	SCALE_A
	clc
	adc.l	al_worldx,x
	sta	xp		; x scaled and stored

	lda	z2
	sexa
	SCALE_A
	clc
	adc.l	al_worldz,x
	sta	zp		; z scaled and stored

	lda	y2
	sexa
	SCALE_A
	clc
	adc.l	al_worldy,x
	sta	ys
; finished (phew!)
	jmp	.normnon


; SINGLE AXIS ROTATION ---------------------------------------------------

.rotx	lda.w	cb_yoff,y		; y offset
	sta	y1
	sta	y2
	lda.w	cb_zoff,y		; z offset
	sta	z1
	sta	z2

	lda.l	al_rotx,x
	beq	.missrotx
	jsl	rotate_8yz_ram_l	; rotate it
.missrotx	a16
	lda	y2		; get result y
	sexa
	SCALE_A			; scale it
	clc
	adc.l	al_worldy,x
	sta	ys		; store the y position
	lda	z2
	sexa
	SCALE_A			; scale it
	clc
	adc.l	al_worldz,x
	sta	zp		; store the z position
	lda.w	cb_xoff,y		; add the collision box offsets
	clc
	adc.l	al_worldx,x
	sta	xp
	jmp	.normnon

	shorta

.roty	lda.w	cb_xoff,y		; x offset
	sta	x1
	sta	x2
	lda.w	cb_zoff,y		; y offset
	sta	z1
	sta	z2

	lda.l	al_roty,x
	beq	.missroty
	jsl	rotate_8xz_ram_l	; rotate it
.missroty	a16
	lda	x2		; get result x
	sexa
	SCALE_A
	clc
	adc.l	al_worldx,x
	sta	xp		; store the x position
	lda	z2
	sexa
	SCALE_A
	clc
	adc.l	al_worldz,x
	sta	zp		; store the z position
	lda.w	cb_yoff,y
	clc
	adc.l	al_worldy,x
	sta	ys
	jmp	.normnon

	shorta
.rotz	lda.w	cb_xoff,y		; x offset
	sta	x1
	sta	x2
	lda.w	cb_yoff,y		; y offset
	sta	y1
	sta	y2

	lda.l	al_rotz,x
	beq	.missrotz
	jsl	rotate_8yx_ram_l	; rotate it
.missrotz	a16
	lda	x2		; get result x
	sexa
	SCALE_A
	clc
	adc.l	al_worldx,x
	sta	xp		; store the x position
	lda	y2
	sexa
	SCALE_A
	clc
	adc.l	al_worldy,x
	sta	ys		; store the y position
	lda.w	cb_zoff,y
	clc
	adc.l	al_worldz,x
	sta	zp
	bra	.normnon


.normrot
	a16
	lda.w	cb_xoff,y		; add the collision box offsets
	clc
	adc.l	al_worldx,x
	sta	xp
	lda.w	cb_yoff,y
	clc
	adc.l	al_worldy,x
	sta	ys
	lda.w	cb_zoff,y
	clc
	adc.l	al_worldz,x
	sta	zp
.normnon

	lda.w	cb_xmax,y
	sta	xcol
	lda.w	cb_ymax,y
	sta	ycol
	lda.w	cb_zmax,y
	sta	zcol
	phx
	phy
	a8
	lda.w	cb_flagset,y
	sta	flagset
	km_db7e
	a16
	jsr	.forcein
	a16
	km_db7f
	ply
	plx
;	lda	temphitflag
;	bne	.finish
	a16
	lda.w	cb_next,y
	lbne	.andagain

.finish	a8
	km_db7e
	rts

	longa	
.normcol
	lda.w	cl_xmax&WM,y
	sta	xcol
	lda.w	cl_ymax&WM,y
	sta	ycol
	lda.w	cl_zmax&WM,y
	sta	zcol
.userad	lda	al_worldx,x
	sta	xp
	lda	al_worldz,x
	sta	zp
	lda	al_worldy,x
	sta	ys
.forcein
	lda	collistcnt
	sta	collistcnt2
	ldy	tmpy
	sty	tmpcl
	jmp	chkcollnxt

chkcoll0
	a8
	sty	tmpcl
	ldx	cl_alien&WM,y

	stz	temphitflag2		; clear the hit flags

	a16

	ldy	tmpx	; x = alien1, y = alien2

;	test_alsflag	y,collide
;	lbne	chkcollnxt

	lda.w	al_collflags,y
	and	al_collflags,x
	and	#acf_colltype1!acf_colltype2!acf_colltype3!acf_colltype4!acf_colltype5
	lbne	chkcollnxt

	tya
	cmp	al_immuneptr,x
	lbeq	chkcollnxt
	txa
	tyx
	cmp	al_immuneptr,x
	lbeq	chkcollnxt

	txy
	tax

	lda	al_worldx,x
	sta	tpx
	lda	al_worldy,x
	sta	tpy
	lda	al_worldz,x
	sta	tpz		; store x,y, and z from the alien

	test_alsflag	x,sameshapecollide
	beq		.chkitnow
	test_alsflag	y,sameshapecollide
	beq		.chkitnow
.nochkitnow
	lda		al_shape,x
	txy
	bra		.nochk
.chkitnow
	lda	al_shape,x
	txy

	cmp	currshape		; same shape?
	lbeq	chkcollnxt
.nochk
	ldx	tmpcl
	lda.w	cl_colbox&WM,x	; collision box list
	lbeq	normalcol		; nope, normal collisions
; now for the collision box stuff
	pha
	lda	tpx
	sta	objx
	lda	tpy
	sta	objy
	lda	tpz
	sta	objz		; copy alien #2's x,y centre
	COLDET.w	.chkcollnxt,.nxtbox,cl_xmax&WM,cl_ymax&WM,cl_zmax&WM
.chkcollnxt	pla
	jmp	chkcollnxt
.nxtbox	pla
	tax

nxtbox
	a8

	lda.l	cbx_frame,x
	beq	.noanim		; check for animated box
	dec	a
	sta	x1
	phx
	tyx
	lda.l	alx_animframe,x
	bpl	.normanim
	plx
	and	x1
	beq	.firstframe
	bra	.intoanim
.normanim	plx
	lda	x1
	and	gameframe
	beq	.firstframe
.intoanim	a16
	and	#127
	sta	x1
	txa			; x->a
	ldx	x1		; a->x
	clc
.add	adc	#cb_sizeof		; crappy and slow..
	dex
	bne	.add
	tax
	a8
	
.firstframe
.noanim
	lda.l	cbx_rotz,x
	sta	scale
	and	#cbf_rotz!cbf_rotx!cbf_roty!cbf_rotxyz
	lbeq	.normrot		; rotated box?
	bit	#cbf_rotz
	lbne	.rotz
	bit	#cbf_roty
	lbne	.roty
	bit	#cbf_rotx
	lbne	.rotx

.rotxyz
; full rotation... zxy
; first, z rotation...
	lda.l	cbx_xoff,x
	sta	x1
	sta	x2

	lda.l	cbx_yoff,x
	sta	y1
	sta	y2

	lda.w	al_rotz,y
	beq	.missrotz2
	jsl	rotate_8yx_ram_l
.missrotz2
; next, x rotation
	lda	y2
	sta	y1	; get previous rotated value

	lda.l	cbx_zoff,x
	sta	z1
	sta	z2

	lda.w	al_rotx,y
	beq	.missrotx2
	jsl	rotate_8yz_ram_l
.missrotx2
; next, y rotation...
	lda	x2
	sta	x1

	lda	z2
	sta	z1	; values from previous rotate

	lda.w	al_roty,y
	beq	.missroty2
	jsl	rotate_8xz_ram_l
.missroty2
; now to scale and add to offsets
	a16
	lda	y2
	sexa
	SCALE_A
	clc
	adc	objy
	sta	tpy	; y scaled and stored

	lda	z2
	sexa
	SCALE_A
	clc
	adc	objz
	sta	tpz	; z scaled and stored

	lda	x2
	sexa
	SCALE_A
	clc
	adc	objx
	sta	tpx	; x scaled and stored

	brl	.normnon



	shorta
.rotx
	lda.l	cbx_yoff,x
	sta	y1
	sta	y2
	lda.l	cbx_zoff,x
	sta	z1
	sta	z2

	lda.w	al_rotx,y
	beq	.missrotx
	jsl	rotate_8yz_ram_l
.missrotx	a16
	lda	y2
	sexa
	SCALE_A
	clc
	adc	objy
	sta	tpy
	lda	z2
	sexa
	SCALE_A
	clc
	adc	objz
	sta	tpz
	lda	objx
	clc
	adc.l	cbx_xoff,x
	sta	tpx
	jmp	.normnon

	shorta
.roty
	lda.l	cbx_xoff,x
	sta	x1
	sta	x2
	lda.l	cbx_zoff,x
	sta	z1
	sta	z2

	lda.w	al_roty,y
	beq	.missroty
	jsl	rotate_8xz_ram_l
.missroty	a16
	lda	x2
	sexa
	SCALE_A
	clc
	adc	objx
	sta	tpx
	lda	z2
	sexa
	SCALE_A
	clc
	adc	objz
	sta	tpz
	lda	objy
	clc
	adc.l	cbx_yoff,x
	sta	tpy
	brl	.normnon

	shorta
.rotz
	lda.l	cbx_xoff,x
	sta	x1
	sta	x2
	lda.l	cbx_yoff,x
	sta	y1
	sta	y2

	lda.w	al_rotz,y
	beq	.missrotz
	jsl	rotate_8yx_ram_l
.missrotz	a16
	lda	x2
	sexa
	SCALE_A
	clc
	adc	objx
	sta	tpx
	lda	y2
	sexa
	SCALE_A
	clc
	adc	objy
	sta	tpy
	lda	objz
	clc
	adc.l	cbx_zoff,x
	sta	tpz
	bra	.normnon

.normrot	a16
	lda	objx
	clc
	adc.l	cbx_xoff,x
	sta	tpx
	lda	objy
	clc
	adc.l	cbx_yoff,x
	sta	tpy
	lda	objz
	clc
	adc.l	cbx_zoff,x
	sta	tpz
.normnon

	COLDET.l	chknxtbox,boxhit,cbx_xmax,cbx_ymax,cbx_zmax

boxhit	a8

	lda.l	cbx_flagset,x
	ora	temphitflag2
	sta	temphitflag2	; set flags for object checking against

	a16

chknxtbox	lda.l	cbx_next,x
	tax
	lbne	nxtbox

	a8
	lda	temphitflag2
	beq	.nohit
	phx

	ldx	tmpx		; x<->y
	jsr	gethitlistptr	; get pointer to hit list structure for x
	ldx	x1
	stx	z1		; temporarily preserve result
	tyx
	ldy	tmpx		; y<->x
	jsr	gethitlistptr	; get pointer to hit list structure for y

	s_set_alsflag	x,collide
	s_set_alsflag	y,collide

; obsolete	s_set_alvartobeobj	x,al_collobjptr,y
; obsolete	s_set_alvartobeobj	y,al_collobjptr,x

	a16
	phx
	txa
	ldx	z1
	sta.w	hl_alptr,x

	ldy	x1		; pointers to hitlist structure
	lda	tmpx
	sta.w	hl_alptr,y

	txa
	sta.w	hl_hlptr,y
	tya
	sta.w	hl_hlptr,x

	a8

	lda	temphitflag2
	sta.w	hl_hitflags,y	; set the hitflag mask y
	lda	flagset
	sta.w	hl_hitflags,x	; set the hitflag mask x

	ply
	lda.w	al_hitflags,y
	ora	temphitflag2
	sta.w	al_hitflags,y
	ldx	tmpx
	lda	al_hitflags,x
	ora	flagset
	sta	al_hitflags,x
	plx
	jmp	chkcollnxt	;endccoll
.nohit
	jmp	chkcollnxt

	longa
normalcol
	COLDET.w	chkcollnxt,chkcoll61,cl_xmax&WM,cl_ymax&WM,cl_zmax&WM

chkcoll61
	phx

	a8
	ldx	tmpx		; x<->y
	jsr	gethitlistptr	; get pointer to hit list structure for x
	ldx	x1
	stx	z1		; temporarily preserve result
	tyx
	ldy	tmpx		; y<->x
	jsr	gethitlistptr	; get pointer to hit list structure for y


	s_set_alsflag	x,collide
	s_set_alsflag	y,collide

; obsolete	s_set_alvartobeobj	x,al_collobjptr,y
; obsolete	s_set_alvartobeobj	y,al_collobjptr,x



	a16
	txa
	ldx	z1
	sta.w	hl_alptr,x

	ldy	x1		; pointers to hitlist structure
	lda	tmpx
	sta.w	hl_alptr,y

	txa
	sta.w	hl_hlptr,y
	tya
	sta.w	hl_hlptr,x

	a8

	lda	flagset
	sta.w	hl_hitflags,x	; set the hitflag mask x

	ldx	tmpx
	lda	al_hitflags,x
	ora	flagset
	sta	al_hitflags,x


	plx


;;;	jmp	endccoll
chkcollnxt
	a16
	lda	tmpcl
	clc
	adc	#cl_sizeof&WM
	tay

	dec	collistcnt2
	beq	chkcoll1
	jmp	chkcoll0
chkcoll1
endccoll
	a8
	rts







;**********************************************************************************
	incfile	ASM\colboxes.asm

