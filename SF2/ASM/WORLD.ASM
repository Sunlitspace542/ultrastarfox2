;***************************************************************************
;*                                                                         *
;*                              StarGlider                                 *
;*                              -----------                                *
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                                                                         *
;*                           Argonaut Software.      		   *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*   File: WORLD                                                         *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: WORLD                                                         *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 12/2/92                                                         *
;*                                                                         *
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:						   *
;*                                                                         *
;*	Krister Wombell, Giles and Dylan                              *
;*                                                                         *
;***************************************************************************

	incpub	world




ifobjinvalid	macro
	phx
	ldx	lastmapobj
	bne	.\@
	plx
	jmp	\1
.\@
	plx
	endm

	shorta
	longi

newobjs_l
	php
	a8
	phb
	jsr	newobjex
	plb
	plp
	rtl
newobjex
	a8
	lda	mapbank
	pha
	plb
	a16
	lda	mapbase&WM,x
	and	#$ff
	txy
	tax
	jmp	(mapjmp,x)
mapjmp	dw	mapobjdo&WM	;0
	dw	mapenddo&WM
	dw	maploopdo&WM	;4
	dw	mapdebdo&WM
	dw	mapnopdo&WM	;8
	dw	mapmother&WM
	dw	mapremove&WM	;12
	dw	setstagedo&WM
	dw	setbgdo&WM	;16
	dw	mapwait&WM
	dw	setbgmdo&WM
	dw	setnodotsdo&WM
	dw	setgnddotsdo&WM	;24
	dw	setspacedustdo&WM
	dw	setothmusdo&WM	;28
	dw	setvofson&WM
	dw	setvofsoff&WM	;32
	dw	sethofson&WM
	dw	sethofsoff&WM	;36
	dw	mapobjzrotdo&WM
	dw	mapjsrdo&WM	;40
	dw	maprtsdo&WM
	dw	mapifdo&WM	;44
	dw	mapgotodo&WM
	dw	setxrotdo&WM	;48
	dw	setyrotdo&WM
	dw	setzrotdo&WM	;52
	dw	setalvarbdo&WM
	dw	setalvarwdo&WM	;56
	dw	setalvarldo&WM
	dw	setalxvarbdo&WM	;60
	dw	setalxvarwdo&WM
	dw	setalxvarldo&WM	;64
	dw	setfadeupdo&WM
	dw	setfadedowndo&WM ;68
	dw	setalvarptrbdo&WM
	dw	setalvarptrwdo&WM ;72
	dw	setvarobjdo&WM
	dw	mapwaitfadedo&WM ;76
	dw	setfadequpdo&WM
	dw	setfadeqdowndo&WM ;80
	dw	setscreenoffdo&WM
	dw	setscreenondo&WM ;84
	dw	setzrotoffdo&WM
	dw	setzrotondo&WM	;88
	dw	mapspecial&WM
	dw	setvarbdo&WM	;92
	dw	setvarwdo&WM
	dw	setvarldo&WM	;96
	dw	setbgslowdo&WM
	dw	waitsetbg&WM	;100
	dw	setbginfo&WM
	dw	addalvarptrbdo&WM ;104
	dw	addalvarptrwdo&WM
	dw	fadetoseado&WM	;108
	dw	fadetogrounddo&WM
	dw	mapqobjdo&WM	;112
	dw	mapobj8do&WM
	dw	mapdobjdo&WM	;116
	dw	mapqobjdo&WM
	dw	map65816&WM	;120
	dw	mapcodejsl&WM
	dw	mapjmpvarlessdo&WM	;124
	dw	mapjmpvarmoredo&WM	;126
	dw	mapjmpvareqdo&WM	;128
	dw	mapsendmessage&WM	;130
	dw	mapCspecial&WM		;132
	dw	mapnormobj&WM		;134
	dw	notneededyet&WM		;136
	dw	mapwait2do&WM		;138
	dw	mapsetpathdo&WM		;140
	dw	mapinertobjdo&WM	;142
	dw	mapinertpathdo&WM	;144
	dw	mapsetscale&WM		;146
	dw	mapsetarea&WM		;148
	dw	mapifswitch&WM		;150
	dw	mapifnotswitch&WM	;152
	dw	mapsetdust&WM		;154
	dw	mapareaout&WM		;156
	dw	mapgotoiflevelcode&WM	;158
	dw	mapinerttargetdo&WM	;160
	dw	mapgotoifplanetcode&WM	;162
	dw	mapgotoifsatellite&WM	;164

	REPT	(ols_id-(*-mapjmp))/2
	dw	0	; Pad out table with zero's up to the ols stuff
	ENDR

	dw	olsobject&wm		; 200
	dw	olswait&wm		; 202
	dw	olsgoto&wm		; 204
	dw	olspositions&wm		; 206
	dw	olslink&wm		; 208
	dw	olspathobj&wm		; 210
	dw	olslinkend&wm		; 212
	dw	olsinertpath&wm		; 214


;-------------------------------------------------------------------
	longa
	longi
mapgotoiflevelcode
	a8
	lda.w	mgil_level,y
	cmp	currentlevel
	bne	.nojump

	a16
	lda.w	mgil_addr,y
	tax
	jmp	newobjex

.nojump
	a16
	tya
	clc
	adc	#mgil_sizeof
	tax
	jmp	newobjex

;-------------------------------------------------------------------
	longa
	longi
mapsetdust
	lda.w	msd_dustflags,y
	sta.l	m_dustflags

	a16
	tya
	clc
	adc	#msd_sizeof
	tax

	jmp	newobjex

;-------------------------------------------------------------------
	longa
	longi
; add a user defined area
mapsetarea

; get the area number
	lda.w	ma_num,y
	and	#127

	tax		; calculate index into area
	beq	.le_fin
	lda	#0
	clc
.multiply	adc	#mar_sizeof
	dex
	bne	.multiply
	clc
	tax
.le_fin
	lda.w	ma_x,y
	and	#255
	xba
	sta.l	areas+mar_x,x

	lda.w	ma_z,y
	and	#255
	xba
	sta.l	areas+mar_z,x

	lda.w	ma_width,y
	and	#255
	xba
	sta.l	areas+mar_width,x

	lda.w	ma_length,y
	and	#255
	xba
	sta.l	areas+mar_length,x

	lda.w	ma_addr,y
	sta.l	areas+mar_mapaddr,x
	lda.w	ma_addr+1,y
	sta.l	areas+mar_mapaddr+1,x

	a8
	lda.w	ma_num,y
	and	#128
	beq	.setactive
	lda	#0
	beq	.setit
.setactive
	lda	#ar_active
.setit	sta.l	areas+mar_flags,x

	inc	NumAreas
	a16
	tya
	clc
	adc	#ma_sizeof
	tax

	jmp	newobjex

;-------------------------------------------------------------------
	shorta
	longi
; check for linked ols objects.
; ie. when one object blows up another particular object gets created.

checkolslinks_l
	php
	phy
	a16
	ldy	olslptr
	beq	.nolinks
	txa
	bra	.search

.nxtone
	txa
	cmp.w	olslinks,y
	beq	.gotone
	lda	al_inertptr,x	; check for ols ptr
	cmp.w	olslinks,y
	beq	.gotone
.search
	dey
	dey
	dey
	dey
	dey

	bpl	.nxtone
.nolinks
	ply
	plp
	rtl
.gotone
; now to create ols object
	phx
	phb
	a8
	lda	mapbank
	pha
	lda.w	olslinks+4,y
	sta	mapbank
	

	ldx.w	olslinks+2,y	; get old map ptr.
	phy
	jsl	newobjs_l
	ply

	jsr	removeolslink

	a8
	pla
	sta	mapbank
	plb

	plx
	ply
	plp
	rtl

;-------------------------------------------------------------------
; remove the link in y from olslinks list
	longa
	longi
removeolslink
	php
	a16
	phx
	sty	x1
	lda	olslptr
	sec
	sbc	x1
	beq	.norem
	sec
	sbc	#5
	beq	.norembutincptr

	tax
	a8

.madamada
	lda.w	olslinks+5,y
	sta.w	olslinks,y
	iny
	dex
	bne	.madamada

	a16
.norembutincptr
	lda	olslptr
	sec
	sbc	#5
	sta	olslptr		; adjust ptr to last object
.norem
	plx
	plp
	rts

;-------------------------------------------------------------------
	longa
	longi
olslink
	tyx
	ldy	olslptr

	lda	lastmapobj
	beq	.nolastobj
	sta.w	olslinks,y

	txa
	clc
	adc	#ol_sizeof
	sta.w	olslinks+2,y

	a8
	lda	mapbank
	sta.w	olslinks+4,y
	a16

	iny
	iny
	iny
	iny
	iny
	sty	olslptr

.nolastobj
	lda.w	ol_bypass,x
	tax
	jmp	newobjex


;-------------------------------------------------------------------
	longa
	longi

olslinkend	rts
	
	
;-------------------------------------------------------------------
	longa
	longi
olspositions
	tyx
	txa
	inc	a
	inc	a
	sta	olspositions_addr

	a8
	lda	mapbank
	sta	olspositions_addr+2

	lda	op_numpos,x
	sta	olspositions_num
	a16

	and	#255
	asl	a
	sta	x1
	asl	a
	clc
	adc	x1
	sta	x1
	txa
	clc
	adc	x1
	clc
	adc	#op_sizeof
	tax		; increment x past the list of coordinates

	jmp	newobjex
	
;-------------------------------------------------------------------
; sets alien in x to a random position taken from the olspositions table
	longa
	longi	
setrandompos
	php
	phy
	phb
	a16
	lda	olspositions_num
	dec	a
	and	#255
	sta	x1

	a8
	lda	olspositions_addr+2
	pha
	plb	; change to map bank to read table
	sta	tempaddrl+2

	jsl	random_l
	a16
	and	x1	; mask out
	asl	a
	sta	x1
	asl	a	; *6
	clc
	adc	x1
	sta	x1

	txy
	lda	olspositions_addr
	clc
	adc	x1
	tax	; calculate offset into x,z table
	sta	tempaddrl


	lda.l	mapbase,x
	sta	x1
	lda.l	mapbase+2,x
	sta	y1
	lda.l	mapbase+4,x
	sta	z1


	plb
	tyx
	ply
	plp
	rts

;-------------------------------------------------------------------
; this searches the aliens and then the inert objects
; for any ols objects with the same position
; position as is in tempaddrl

findolssamepos
	php
	phb
	phx
	phy
	a8
	lda	#$7e
	pha
	plb
	a16

	ldx	allst
	beq	.none1

.lp
	s_jmp_notalsflag	x,olsobj,.nomatch
	s_get_resource	L,x,textpt,poslist,.nomatch

	lda	textpt
	cmp	tempaddrl
	bne	.nomatch
	lda	textpt+1
	cmp	tempaddrl+1
	beq	.match
.nomatch

	lda	_next,x
	tax
	bne	.lp

.none1

	ldx	inertlistptr
	beq	.none2
.lp2
	lda.w	i_poslist,x
	cmp	tempaddrl
	bne	.nomatch2
	lda.w	i_poslist+1,x
	cmp	tempaddrl+1
	beq	.match

.nomatch2
	lda.w	_next,x
	tax
	bne	.lp2
.none2


	lda	#0
	bra	.exit

.match	lda	#1
.exit
	ply
	plx
	plb
	plp
	rts

;-------------------------------------------------------------------
	LONGA
	LONGI
setols
; set position randomly
	php
	phx
.lp
	jsr	setrandompos

	jsr	findolssamepos
	cmp	#1
	beq	.lp

	lda	x1
	sta.w	al_worldx,y

	lda	y1
	sta.w	al_worldy,y

	lda	z1
	sta.w	al_worldz,y

	s_set_alsflag	y,olsobj

	sty	lastmapobj

	a8
	phb
	lda	#$7e
	pha
	plb
	s_set_resource	L,y,poslist,tempaddrl
	inc	olsobjs_num

.notfound

	plb
	plx
	plp
	rts

;-------------------------------------------------------------------
	LONGA
	LONGI
setinertols
; set position randomly
	php

	a16
.lp
	jsr	setrandompos

	jsr	findolssamepos
	cmp	#1
;	beq	.lp

	lda	x1
	sta.w	i_worldx,y

	lda	y1
	sta.w	i_worldy,y

	lda	z1
	sta.w	i_worldz,y

	sty	lastmapobj

	a8
	inc	olsobjs_num

	lda	tempaddrl+2
	sta.w	i_poslist+2,y	; store the position
	a16
	lda	tempaddrl
	sta.w	i_poslist,y
	plp
	rts

;-------------------------------------------------------------------
	longa
	longi
olspathobj
	tyx

; add the object
	phx
	ldx	allst
	l_add	allst,alfreelst,.noadd
	txy
	plx

; initialise its variables
	a8
	jsl	init_objvars_l
	a16

; copy data from map
	lda	opo_shape,x
	sta.w	al_shape,y
	lda	opo_path,x
	sta.w	al_sword2,y

	lda	#path_istrat&WM
	sta.w	al_stratptr,y
	lda	#path_istrat>>8
	sta.w	al_stratptr+1,y

	jsr	setols

	bra	.wobber

.noadd
	stz	lastmapobj
	plx
.wobber
	txa
	clc
	adc	#opo_sizeof
	tax

	jmp	newobjex



;-------------------------------------------------------------------
	longa
	longi
olsinertpath
	phb
	phy

	lda.w	opo_shape,y
	sta	x2
	lda.w	opo_path,y
	sta	y2

	a8
	lda	#$7e
	pha
	plb
	a16

; add the object
	ldx	inertlistptr
	l_add.w	inertlistptr,inertfree,.noadd

; copy data from map
	lda	x2
	sta.w	i_shape,x
	lda	y2
	sta.w	i_strat,x

	stz.w	i_alienptr,x
	a8
	lda	#if_pathobj!if_olsobj
	sta.w	i_flags,x
	stz.w	i_rotx,x
	stz.w	i_roty,x
	stz.w	i_rotz,x

	txy
	jsr	setinertols

	plx
	plb

	bra	.wobber

.noadd	a16
	stz	lastmapobj
	plx
	plb
.wobber	a16
	txa
	clc
	adc	#opo_sizeof
	tax

	jmp	newobjex

;-------------------------------------------------------------------
	longa
	longi
olsobject
	tyx
	jsr	olsobject_rou
	txa
	clc
	adc	#oo_sizeof
	tax
	jmp	newobjex
olsobject_rou

; add the object
	phx
	ldx	allst
	l_add	allst,alfreelst,.noadd
	txy
	plx

; initialise its variables
	a8
	jsl	init_objvars_l
	a16

; copy data from map
	lda	oo_shape,x
	sta.w	al_shape,y
	lda	oo_strategy,x
	sta.w	al_stratptr,y
	lda	oo_strategy+1,x
	sta.w	al_stratptr+1,y

	jsr	setols

	bra	.wobber

.noadd
	stz	lastmapobj
	plx
.wobber
	rts
;-------------------------------------------------------------------
	longa
	longi
olswait
	tyx

	lda	ow_condition,x
	and	#255
	cmp	#_olsw_alldead
	beq	.chkalldead
	cmp	#_olsw_onedead
	beq	.chkonedead
.wait
	stx	mapptr
	rts
.chkalldead
	lda	olsobjs_num
	beq	.con
	stx	mapptr
	rts
.chkonedead
	lda	olsobj_dead
	beq	.wait
	stz	olsobj_dead
.con
	txa
	clc
	adc	#ow_sizeof
	tax
	jmp	newobjex

;-------------------------------------------------------------------
	longa
	longi
olsgoto
	tyx
	lda	og_condition,x
	and	#255
	beq	.gotoit
	cmp	#_olsg_ifnotsos1
	beq	.notsos1
	cmp	#_olsg_ifnotsos2
	beq	.notsos2
	cmp	#_olsg_ifnotsos3
	beq	.notsos3
	bra	.con
.notsos1
.notsos2
.notsos3
.con
	txa
	clc
	adc	#og_sizeof
	tax
	jmp	newobjex
.gotoit	lda	og_addr,x
	tax
	jmp	newobjex
;-------------------------------------------------------------------

;-------------------------------------------------------------------
	longa
	longi

mapsetscale
	lda.w	ms_scale,y
;	jsl	set_scale_l
	tya
	clc
	adc	#ms_sizeof
	tax
	jmp	newobjex

;-------------------------------------------------------------------
	longa
	longi
mapinerttargetdo
	phb
	phy

	lda	#if_pathobj!if_target
	sta.l	tempinertflags

	jmp	mapinertpathdo_in
;-------------------------------------------------------------------
	longa
	longi

mapinertpathdo
	phb
	phy
	lda	#if_pathobj
	sta.l	tempinertflags

mapinertpathdo_in
; copy data into temporary storage
	lda.w	mip_x,y
	sta	x1
	lda.w	mip_y,y
	sta	y1
	lda.w	mip_z,y
	sta	z1

	lda.w	mip_shape,y
	sta	x2

	lda.w	mip_path,y
	sta	y2

	a8

	lda.w	mip_roty,y
	sta	z2+1

	lda	#$7e
	pha
	plb

	a16

	ldx	inertlistptr
	l_add.w	inertlistptr,inertfree,.nocando

	lda	x1
	sta.w	i_worldx,x
	lda	y1
	sta.w	i_worldy,x
	lda	z1
	sta.w	i_worldz,x
	lda	x2
	sta.w	i_shape,x
	lda	y2
	sta.w	i_strat,x

	a8
	lda	z2+1
	sta.w	i_roty,x

	lda	CurrentArea
	sta.w	i_area,x

	lda.l	tempinertflags	; #if_pathobj
	sta.w	i_flags,x
	stz.w	i_rotx,x
	stz.w	i_rotz,x
	a16
.nocando
	plx
	plb
	txa
	clc
	adc	#mip_sizeof
	tax
	jmp	newobjex

;-------------------------------------------------------------------
	longa
	longi

mapinertobjdo
	phb
	phy
; copy data into temporary storage
	lda.w	mio_x,y
	sta	x1
	lda.w	mio_y,y
	sta	y1
	lda.w	mio_z,y
	sta	z1

	lda.w	mio_shape,y
	sta	x2

	lda.w	mio_strat,y
	sta	y2

	a8
	lda.w	mio_strat+2,y
	sta	z2

	lda.w	mio_roty,y
	sta	z2+1

	lda	#$7e
	pha
	plb

	a16

	ldx	inertlistptr
	l_add.w	inertlistptr,inertfree,.nocando

	lda	x1
	globalscale_a
	sta.w	i_worldx,x
	lda	y1
	globalscale_a
	sta.w	i_worldy,x
	lda	z1
	globalscale_a
	sta.w	i_worldz,x
	lda	x2
	sta.w	i_shape,x
	lda	y2
	sta.w	i_strat,x

	a8
	lda	z2
	sta.w	i_strat+2,x
	lda	z2+1
	sta.w	i_roty,x

	lda	CurrentArea
	sta.w	i_area,x

	stz.w	i_flags,x
	stz.w	i_rotx,x
	stz.w	i_rotz,x
	a16
.nocando
	plx
	plb
	txa
	clc
	adc	#mio_sizeof
	tax
	jmp	newobjex

	longa
	longi
mapsetpathdo	tyx
	ifobjinvalid	.dekinai
	ldy	lastmapobj
	lda	mapbase&WM+1,x
	sta.w	al_sword2,y
.dekinai	inx
	inx
	inx
	jmp	newobjex


	longa
	longi
mapwait2do	tyx
	lda	mapbase&WM+1,x
	and	#255
	asl	a
	asl	a
	asl	a
	asl	a
	sta	mapcnt
	inx
	inx
	stx	mapptr

	rts



notneededyet
	longa
	longi
setbgmdo	tyx
	a8
	lda		pshipflags2
	and		#psf2_playerHP0
	bne		.nobgm

	lda	mapbase&WM+1,x
	sta	bgm_music
	stz	bgmcnt
.nobgm
	inx
	inx
	jmp	newobjex

	longa
	longi
mapsendmessage
	tyx
	phx
	lda	mapbase&WM+1,x
;	jsl	send_message_l
	plx
	inx
	inx
	jmp	newobjex


	longa
	longi
map65816	tyx
	txa
	clc
	adc	#mapbase&WM
	tax
	a8
	lda	#0
	pha
	plb	; dbr=0
	lda	#newobjex>>16
	pha
	ldy	#(newobjex-1)&WM
	phy
	lda	mapbank
	pha
	phx
	ldx	lastmapobj
	rtl

	longa
	longi
mapcodejsl	tyx
	phx
	a8
	lda	#.ret>>16
	pha
	ldy	#(.ret-1)&WM
	phy
	lda	mapbase&WM+3,x
	pha
	ldy	mapbase&WM+1,x
	phy
	ldx	lastmapobj
	lda	#0
	pha
	plb	; dbr=0
	rtl

.ret	ai16
	plx
	inx
	inx
	inx
	inx
	jmp	newobjex



	
;--------------------------------------------------------
	longa
	longi
mapjmpvarlessdo
	tyx
	lda	mapbase&WM+1,x
	sta	tempaddrl
	lda	mapbase&WM+2,x
	sta	tempaddrl+1
	a8
	lda.l	[tempaddrl]
	cmp	mapbase&WM+4,x
	bpl	.njmp
	a16
	lda	mapbase&WM+5,x
	tax
	jmp	newobjex
.njmp
	inx
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex
	
;--------------------------------------------------------
	longa
	longi
mapifswitch
	tyx
	lda.l	switchflags
	bit	mapbase&WM+1,x
	beq	.njmp
	lda	mapbase&WM+3,x
	tax
	jmp	newobjex
.njmp
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex
;--------------------------------------------------------
	longa
	longi
mapifnotswitch
	tyx
	lda.l	switchflags
	bit	mapbase&WM+1,x
	bne	.njmp
	lda	mapbase&WM+3,x
	tax
	jmp	newobjex
.njmp
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex
;--------------------------------------------------------
	longa
	longi
mapjmpvarmoredo
	tyx
	lda	mapbase&WM+1,x
	sta	tempaddrl
	lda	mapbase&WM+2,x
	sta	tempaddrl+1
	a8
	lda.l	[tempaddrl]
	cmp	mapbase&WM+4,x
	beq	.njmp
	bmi	.njmp
	a16
	lda	mapbase&WM+5,x
	tax
	jmp	newobjex
.njmp
	inx
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex
	
;--------------------------------------------------------
	longa
	longi
mapjmpvareqdo
	tyx
	lda	mapbase&WM+1,x
	sta	tempaddrl
	lda	mapbase&WM+2,x
	sta	tempaddrl+1
	a8
	lda.l	[tempaddrl]
	cmp	mapbase&WM+4,x
	bne	.njmp
	a16
	lda	mapbase&WM+5,x
	tax
	jmp	newobjex
.njmp
	inx
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex
	



	longa
	longi
fadetoseado
	IFEQ	1
	tyx
	inx
	ldy	#seapal-seapal+30
	sty	palfade
	sty	lastpalfade
	ldy	#2
	sty	palcnt
	lda	#30
	sta	palnum
	jmp	newobjex
	ENDC
	
	longa
	longi
fadetogrounddo
	IFEQ	1
	tyx
	inx
	ldy	#groundpal-seapal+30
	sty	palfade
	sty	lastpalfade
	ldy	#2
	sty	palcnt
	lda	#30
	sta	palnum
	jmp	newobjex
	ENDC

setrestartfade_l
	php
	ai16
	lda	restartpalfade
	beq	.nodo
	sta	palfade
	ldy	#2
	sty	palcnt
	lda	#30
	sta	palnum
.nodo
	plp
	rtl

	longa
	longi
addalvarptrbdo	tyx
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	clc
	adc	lastmapobj
	tay
	lda	mapbase&WM+3,x
	sta	tempaddrl
	lda	mapbase&WM+4,x
	sta	tempaddrl+1
	a8
	lda	[tempaddrl]
	clc
	adc.w	0,y
	sta.w	0,y
.dekinai
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
addalvarptrwdo	tyx
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	clc
	adc	lastmapobj
	tay
	lda	mapbase&WM+3,x
	sta	tempaddrl
	lda	mapbase&WM+4,x
	sta	tempaddrl+1
	a16
	lda	[tempaddrl]
	clc
	adc.w	0,y
	sta.w	0,y
.dekinai
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex


	longa
	longi
setbginfo	tyx
	phx

	jsl	setbginfo_l

	plx
	inx
	jmp	newobjex

setbginfo_l
	lda	bgflags
	ora	#bgf_info
	sta	bgflags
	rtl


setbginforeq_l
	php
	ai16
	a8

	lda	levelinfo
	bit	#if_ground!if_space
	beq	.nodots
	bit	#if_ground
	beq	.space
	lda	#1
	sta	dotsflag
	bra	.con_2
.space	lda	#-1
	sta	dotsflag
	sta	dotsflag+1
	bra	.con
.nodots	stz	dotsflag	; set the dots up
.con_2	stz	dotsflag+1
.con

;-----------------------------------------
	lda	levelinfo
	bit	#if_vofson
	beq	.novofs
	jsr	vofsonplease
	bra	.con2
.novofs	jsr	vofsoffplease
.con2
	lda	levelinfo
	bit	#if_hofson
	beq	.nohofs
	lda	#1
	sta	dohofs
	bra	.con3
.nohofs	stz	dohofs
.con3	

;-----------------------------------------
	lda	#0
	sta.l	m_planetstars
	sta.l	m_planetstars+1

	lda	levelinfo
	bit	#if_snow
	beq	.nsnow
	lda	#1
	sta.l	m_planetstars
	sta.l	m_planetstars+1
	bra	.pst

.nsnow
	bit	#if_pollen
	beq	.noplanetstars
	lda	#2
	sta.l	m_planetstars
	sta.l	m_planetstars+1


.pst
	lda	#-1
	sta	dotsflag
	sta	dotsflag+1

.noplanetstars

;-----------------------------------------

	lda	levelinfo
	bit	#if_zroton
	beq	.nozrot
	lda	#1
	sta	dozrot
	bra	.con4
.nozrot	stz	dozrot
.con4	plp
	rtl


	longa
	longi
setvarldo	tyx
	lda	mapbase&WM+1,x
	sta	tempaddrl
	lda	mapbase&WM+2,x
	sta	tempaddrl+1

	lda	mapbase&WM+4,x
	sta.l	[tempaddrl]
	inc	tempaddrl
	inc	tempaddrl
	a8
	lda	mapbase&WM+6,x
	sta.l	[tempaddrl]
	inx

	inx
	inx
	inx

	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
setvarwdo	tyx
	lda	mapbase&WM+3,x
	sta	tempaddrl
	lda	mapbase&WM+4,x
	sta	tempaddrl+1
	lda	mapbase&WM+1,x
	sta	[tempaddrl]
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex


	longa
	longi
setvarbdo	tyx
	lda	mapbase&WM+2,x
	sta	tempaddrl
	lda	mapbase&WM+3,x
	sta	tempaddrl+1
	a8
	lda	mapbase&WM+1,x
	sta.l	[tempaddrl]
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex




	longa
	longi
mapspecial	tyx
	ifobjinvalid	.dekinai
	ldy	lastmapobj
	a8
	lda	#asf_special
	sta.w	al_sflags,y
	inc	specialobjtotal
.dekinai
	inx
	jmp	newobjex


	longa
	longi
mapCspecial	tyx
	ifobjinvalid	.dekinai
	ldy	lastmapobj
	a8
	lda	#asf_Cspecial
	sta_sflags	y,Cspecial
	inc	specialobjtotal
.dekinai
	inx
	jmp	newobjex

	longa
	longi
setzrotoffdo
	tyx
	a8
	stz	dozrot
	inx
	jmp	newobjex

	longa
	longi
setzrotondo
	tyx
	a8
	lda	#1
	sta	dozrot
	inx
	jmp	newobjex

	longa
	longi
setscreenoffdo
	tyx
	a8
	stz	fadedir
	stz	fade
	lda	#$80
	setinidisp1
	sta	inidisp
	inx
	jmp	newobjex

	longa
	longi
setscreenondo
	tyx
	a8
	stz	fadedir
	lda	#$f
	sta	fade
	setinidisp1
	sta	inidisp
	inx
	jmp	newobjex

	longa
	longi
mapwaitfadedo
	tyx
	a8
	lda	fade
	bne	.wait
	lda.l	xinidisp1
	cmp	#$80
	bne	.wait
	inx
	jmp	newobjex
.wait	lda	#1
	sta	mapcnt
	stz	mapcnt+1
	stx	mapptr
	rts

	longa
	longi
setvarobjdo	tyx
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	sta	tempaddrl
	lda	mapbase&WM+2,x
	sta	tempaddrl+1
	lda	lastmapobj
	sta.l	[tempaddrl]
.dekinai
	inx
	inx
	inx
	inx
	jmp	newobjex


	longa
	longi
setalvarptrbdo	tyx
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	clc
	adc	lastmapobj
	tay
	lda	mapbase&WM+3,x
	sta	tempaddrl
	lda	mapbase&WM+4,x
	sta	tempaddrl+1
	a8
	lda	[tempaddrl]
	sta.w	0,y
.dekinai
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
setalvarptrwdo	
	tyx
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	clc
	adc	lastmapobj
	tay
	lda	mapbase&WM+3,x
	sta	tempaddrl
	lda	mapbase&WM+4,x
	sta	tempaddrl+1
	a16
	lda	[tempaddrl]
	sta.w	0,y
.dekinai
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
setfadeupdo	tyx
	a8
	lda	#1
	sta	fadedir
	inx
	jmp	newobjex
	longa
	longi
setfadedowndo
	tyx
	a8
	lda	#-1
	sta	fadedir
	inx
	jmp	newobjex

	longa
	longi
setfadequpdo
	tyx
	a8
	lda	#2
	sta	fadedir
	inx
	jmp	newobjex
	longa
	longi
setfadeqdowndo
	tyx
	a8
	lda	#-2
	sta	fadedir
	inx
	jmp	newobjex

	longa
	longi
setalvarbdo	tyx
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	clc
	adc	lastmapobj
	tay
	a8
	lda	mapbase&WM+3,x
	sta.w	0,y
.dekinai
	inx
	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
setalvarwdo	tyx
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	clc
	adc	lastmapobj
	tay
	lda	mapbase&WM+3,x
	sta.w	0,y
.dekinai	inx
	inx
	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
setalvarldo	tyx
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	clc
	adc	lastmapobj
	tay
	lda	mapbase&WM+3,x
	sta.w	0,y
	a8
	lda	mapbase&WM+5,x
	sta.w	2,y
.dekinai
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex


	longa
	longi
setalxvarbdo
	tyx
	ifobjinvalid	.dekinai
	lda	lastmapobj
	clc
	adc	mapbase&WM+1,x
	txy
	tax
	a8
	lda.w	mapbase&WM+3,y
	sta.l	xalblks,x
	tyx
.dekinai
	inx
	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
setalxvarwdo
	tyx
	ifobjinvalid	.dekinai
	lda	lastmapobj
	clc
	adc	mapbase&WM+1,x
	txy
	tax
	lda.w	mapbase&WM+3,y
	sta.l	xalblks,x
	tyx
.dekinai
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
setalxvarldo
	tyx
	ifobjinvalid	.dekinai
	lda	lastmapobj
	clc
	adc	mapbase&WM+1,x
	txy
	tax
	lda.w	mapbase&WM+3,y
	sta.l	xalblks,x
	a8
	lda.w	mapbase&WM+5,y
	sta.l	xalblks+2,x
	tyx
.dekinai
	inx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex


	longa
	longi
mapwaitdo	tyx
	lda	mapbase&WM+1,x
	sta	mapcnt
	inx
	inx
	inx
	stx	mapptr

	rts

	longa
	longi
setxrotdo	tyx
	a8
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	ldy	lastmapobj
	sta.w	al_rotx,y
.dekinai
	inx
	inx
	jmp	newobjex

	longa
	longi
setyrotdo	tyx
	ifobjinvalid	.dekinai
	a8
	lda	mapbase&WM+1,x
	ldy	lastmapobj
	sta.w	al_roty,y
.dekinai
	inx
	inx
	jmp	newobjex

	longa
	longi
setzrotdo	tyx
	a8
	ifobjinvalid	.dekinai
	lda	mapbase&WM+1,x
	ldy	lastmapobj
	sta.w	al_rotz,y
.dekinai
	inx
	inx
	jmp	newobjex

	longa
	longi
mapgotodo
	tyx
	a8
	lda	mapbase&WM+3,x
	sta	mapbank
	a16
	lda	mapbase&WM+1,x
	tax
	jmp	newobjex

	longa
	longi
mapifdo
	tyx
	phx
	a8
	lda	#.ret>>16
	pha
	a16
	lda	#(.ret-1)&WM
	pha

	a8
	lda	mapbase&WM+3,x
	pha
	a16
	lda	mapbase&WM+1,x
	dec	a
	pha

	a8
	lda	#0
	pha
	plb	; dbr=0

	rtl


.ret	bcs	.nodo

	a8
	lda	mapbank
	pha
	plb

	ai16
	plx
	inx
	inx
	inx
	inx
	inx
	inx
	stx	mapptr
	lda	#1
	sta	mapcnt

	rts

.nodo	
	a8
	lda	mapbank
	pha
	plb

	ai16
	plx
	lda	mapbase&WM+4,x
	tax
	jmp	newobjex

	longa
	longi
mapjsrdo
	tyx
	ldy	mapjsrptr
	txa
	sta.w	mapjsrstk,y
	a8
	lda	mapbank
	sta.w	mapjsrstk+2,y
	a16
	iny
	iny
	iny
	sty	mapjsrptr
	a8
	lda	mapbase&WM+3,x
	sta	mapbank
	a16
	lda	mapbase&WM+1,x
	tax
	inc	nummapjsr
	jmp	newobjex

	longa
	longi
maprtsdo
	tyx
	ldy	mapjsrptr
	dey
	a8
	lda.w	mapjsrstk,y
	sta	mapbank
	a16
	dey
	dey
	ldx	mapjsrstk,y
	sty	mapjsrptr
	inx
	inx
	inx
	inx
	dec	nummapjsr
	jmp	newobjex


	longa
	longi
setvofson	tyx
	jsr	vofsonplease
	inx
	jmp	newobjex
vofsonplease_l
	jsr	vofsonplease
	rtl
vofsonplease
	php
	a8
	lda	bg2scroll
	sta	bg2vofs
	lda	bg2scroll+1
	sta	bg2vofs
	lda	#1
	sta	dovofs
	plp
	rts

	longa
setvofsoff	tyx
	jsr	vofsoffplease
	inx
	jmp	newobjex
vofsoffplease_l
	jsr	vofsoffplease
	rtl

vofsoffplease
	php
	a8
	stz	dovofs
	lda	bg2scroll
	sta	bg2vofs
	lda	bg2scroll+1
	sta	bg2vofs
	plp
	rts


	longa
sethofson	tyx
	a8
	lda	#1
	sta	dohofs
	inx
	jmp	newobjex
	longa
sethofsoff	tyx
	a8
	stz	dohofs
	inx
	jmp	newobjex

	longa
	longi
setothmusdo	tyx
	a8
	lda	mapbase&WM+1,x
	sta	othmusic
	inx
	inx
	jmp	newobjex

	longa
	longi
setnodotsdo	tyx
	stz	dotsflag
	inx
	jmp	newobjex
setgnddotsdo
	tyx
	lda	#1
	sta	dotsflag
	inx
	jmp	newobjex
setspacedustdo
	tyx
	lda	#-1
	sta	dotsflag
	inx
	jmp	newobjex

	longa
	longi
waitsetbg	tyx
	phx
	lda	bg_dmalist
	tax
	lda.l	bglists,x
	sta	x1
	lda.l	bglists+1,x
	ora	x1
	beq	.con
	plx
	stx	mapptr
	rts
.con	plx
	inx
	jmp	newobjex

	longa
	longi
setbgslowdo
	tyx
	lda	mapbase&WM+1,x
	and	#255
	sta	bgtransspeed
	lda	mapbase&WM+2,x
	sta	bg_dmalist
	sta	currentbg
	inx
	inx
	inx
	inx
	jmp	newobjex
	
	longa
	longi
setbgdo	tyx
	phx

	a16
	lda	mapbase&WM+1,x
	jsl	setbg_l

	plx
	inx
	inx
	inx
	jmp	newobjex

	longa
	longi
setbg_l
	sta	currentbg
	lda	bgflags
	ora	#bgf_bg
	sta	bgflags
	rtl

dobgreq_l
	a8
	lda	#1+2+16
	sta	kw_tmptm	;through main get

	ai16
	ldx	currentbg
.loop
	lda.l	bglists,x
	sta	x1
	lda.l	bglists+1,x
	sta	x2
	ora	x1
	beq	.out
	phx
	a8
	lda	#.ret>>16
	pha
	a16
	lda	#(.ret-1)&WM
	pha

	a8
	lda	x1
	pha
	ldx	x2
	dex
	phx
	rtl
.ret
	a16
	plx
	inx
	inx
	inx
	bra	.loop
.out
	rtl



	longa
	longi
setstagedo
	tyx
	lda	#50
	sta	stagecnt
	inx
	jmp	newobjex

	longa
	longi
mapqobjdo
	IFEQ	1


;;	tyx
;;	lda	map_count,x
;;	and	#255
;;	asl	a
;;	asl	a
;;	asl	a
;;	asl	a
;;	sta	mapcnt
;;	phx
;;	ldx	allst
;;	l_add	allst,alfreelst,.nofreeblks
;;	txy
;;	plx
;;	a8
;;	jsl	init_objvars_l
;;	a16
;;
;;	lda	mq_x,x
;;	sexa
;;	asl	a
;;	asl	a
;;	sta.w	al_worldx,y
;;	lda	mq_y,x
;;	sexa
;;	asl	a
;;	asl	a
;;	sta.w	al_worldy,y
;;	lda	mq_z,x
;;	and	#255
;;	asl	a
;;	asl	a
;;	asl	a
;;	asl	a
;;	sta.w	al_worldz,y
;;
;;	lda	map_ctrl,x
;;	and	#255
;;	cmp	#ctrlmapqobj2
;;	bne	.norm
;;
;;	lda	mq_shape,x
;;	phx
;;	and	#255
;;	asl	a
;;	asl	a
;;	tax
;;	lda.l	istrats,x
;;	sta.w	al_stratptr,y
;;	a8
;;	lda.l	istrats+2,x
;;	sta.w	al_stratptr+2,y
;;	lda.l	istrats+3,x
;;	a16
;;	and	#255
;;	asl	a
;;	tax
;;	lda.l	shapes,x
;;	sta.w	al_shape,y
;;	plx
;;	bra	.aha
;;.norm
;;	lda	mq_shape,x
;;	phx
;;	and	#255
;;	asl	a
;;	tax
;;	lda.l	shapes,x
;;	sta.w	al_shape,y
;;	plx
;;
;;	lda	mq_strat,x
;;	phx
;;	and	#255
;;	asl	a
;;	asl	a
;;	tax
;;	lda.l	istrats,x
;;	sta.w	al_stratptr,y
;;	a8
;;	lda.l	istrats+2,x
;;	sta.w	al_stratptr+2,y
;;	plx
;;
;;.aha
;;	a16
;;	sty	lastmapobj
;;
;;	jsr	.incx
;;
;;	lda	mapcnt
;;	bne	.listfull
;;	jmp	newobjex
;;.listfull	stx	mapptr
;;	rts
;;.nofreeblks	a16
;;	ldx	#0
;;	stx	lastmapobj
;;	plx
;;	jsr	.incx
;;	lda	mapcnt
;;	bne	.listfull
;;	jmp	newobjex
;;
;;.incx	lda	map_ctrl,x
;;	and	#255
;;	cmp	#ctrlmapqobj2
;;	beq	.oneway
;;	txa
;;	clc
;;	adc	#mq_sizeof
;;	tax
;;	rts
;;.oneway	txa
;;	clc
;;	adc	#mq_sizeof-1
;;	tax
;;	rts
;;
	ENDC

	longa
	longi
mapobj8do
	tyx
	lda	map_count,x
	and	#255
	asl	a
	asl	a
	sta	mapcnt
	phx
	ldx	allst
	l_add	allst,alfreelst,.nofreeblks
	txy
	plx
	a8
	jsl	init_objvars_l
	a16

	lda	m8_x,x
	sexa
	asl	a
	asl	a
	sta.w	al_worldx,y
	lda	m8_y,x
	sexa
	asl	a
	asl	a
	sta.w	al_worldy,y
	lda	m8_z,x
	sexa
	asl	a
	asl	a
	asl	a
	asl	a
	sta.w	al_worldz,y

	lda	m8_shape,x
	sta.w	al_shape,y
	lda	m8_strat,x
	sta.w	al_stratptr,y
	a8
	lda	m8_strat+2,x
	sta.w	al_stratptr+2,y
	a16
	sty	lastmapobj

	txa
	clc
	adc	#m8_sizeof
	tax

	lda	mapcnt
	bne	.listfull
	jmp	newobjex
.listfull	stx	mapptr
	rts
.nofreeblks	a16
	stz	lastmapobj
	pla
	clc
	adc	#m8_sizeof
	tax

	lda	mapcnt
	bne	.listfull
	jmp	newobjex



	longa
	longi
mapobjdo
	IFEQ	1
;;	tyx
;;	lda	map_count,x
;;	sta	mapcnt
;;	phx
;;	ldx	allst
;;	l_add	allst,alfreelst,.nofreeblks
;;	txy
;;	plx
;;	a8
;;	jsl	init_objvars_l
;;	a16
;;
;;	lda	mobj_x,x
;;	sta.w	al_worldx,y
;;	lda	mobj_y,x
;;	sta.w	al_worldy,y
;;	lda	mobj_z,x
;;	sta.w	al_worldz,y
;;
;;	lda	mobj_shape,x
;;	phx
;;	and	#255
;;	asl	a
;;	tax
;;	lda.l	shapes,x
;;	sta.w	al_shape,y
;;	plx
;;
;;	lda	mobj_strat,x
;;	phx
;;	and	#255
;;	
;;
;;	asl	a
;;	asl	a
;;	tax
;;	lda.l	istrats,x
;;	sta.w	al_stratptr,y
;;	a8
;;	lda.l	istrats+2,x
;;	sta.w	al_stratptr+2,y
;;	plx
;;
;;	sty	lastmapobj
;;
;;	a16
;;	txa
;;	clc
;;	adc	#mobj_sizeof
;;	tax
;;
;;	lda	mapcnt
;;	bne	.listfull
;;	jmp	newobjex
;;.listfull	stx	mapptr
;;	rts
;;.nofreeblks	a16
;;	stz	lastmapobj
;;	pla
;;	clc
;;	adc	#mobj_sizeof
;;	tax
;;
;;	lda	mapcnt
;;	bne	.listfull
;;	jmp	newobjex

	ENDC

	longa
	longi
mapdobjdo

	IFEQ	1
;;
;;	tyx
;;	lda	map_count,x
;;	sta	mapcnt
;;	phx
;;	ldx	allst
;;	l_add	allst,alfreelst,.nofreeblks
;;	txy
;;	plx
;;	a8
;;	jsl	init_objvars_l
;;	a16
;;
;;	lda	md_x,x
;;	sta.w	al_worldx,y
;;	lda	md_y,x
;;	sta.w	al_worldy,y
;;	lda	md_z,x
;;	sta.w	al_worldz,y
;;
;;	lda	md_strat,x
;;	phx
;;	and	#255
;;	asl	a
;;	asl	a
;;	tax
;;	lda.l	istrats,x
;;	sta.w	al_stratptr,y
;;	a8
;;	lda.l	istrats+2,x
;;	sta.w	al_stratptr+2,y
;;	lda.l	istrats+3,x
;;	a16
;;	and	#255
;;	asl	a
;;	tax
;;	lda.l	shapes,x
;;	sta.w	al_shape,y
;;	plx
;;
;;	sty	lastmapobj
;;
;;	a16
;;	txa
;;	clc
;;	adc	#md_sizeof
;;	tax
;;
;;	lda	mapcnt
;;	bne	.listfull
;;	jmp	newobjex
;;.listfull	stx	mapptr
;;	rts
;;.nofreeblks	a16
;;	stz	lastmapobj
;;	pla
;;	clc
;;	adc	#md_sizeof
;;	tax
;;
;;	lda	mapcnt
;;	bne	.listfull
;;	jmp	newobjex

	ENDC

	longa
	longi
mapobjzrotdo
	IFEQ	1
;;
;;	tyx
;;	lda	map_count,x
;;	sta	mapcnt
;;	phx
;;	ldx	allst
;;	l_add	allst,alfreelst,.nofreeblks
;;	txy
;;	plx
;;	a8
;;	jsl	init_objvars_l
;;	a16
;;
;;	lda	mz_x,x
;;	sta.w	al_worldx,y
;;	lda	mz_y,x
;;	sta.w	al_worldy,y
;;	lda	mz_z,x
;;	sta.w	al_worldz,y
;;
;;	lda	mz_shape,x
;;	phx
;;	and	#255
;;	asl	a
;;	tax
;;	lda.l	shapes,x
;;	sta.w	al_shape,y
;;	plx
;;
;;	lda	mz_strat,x
;;	phx
;;	and	#255
;;	asl	a
;;	asl	a
;;	tax
;;	lda.l	istrats,x
;;	sta.w	al_stratptr,y
;;	a8
;;	lda.l	istrats+2,x
;;	sta.w	al_stratptr+2,y
;;	plx
;;
;;	lda	mz_rotz,x
;;	sta.w	al_rotz,y
;;
;;	sty	lastmapobj
;;	
;;	a16
;;	txa
;;	clc
;;	adc	#mz_sizeof
;;	tax
;;
;;	lda	mapcnt
;;	bne	.listfull
;;	jmp	newobjex
;;.listfull	stx	mapptr
;;	rts
;;.nofreeblks	a16
;;	stz	lastmapobj
;;	pla
;;	clc
;;	adc	#mz_sizeof
;;	tax
;;
;;	lda	mapcnt
;;	bne	.listfull
;;	jmp	newobjex

	ENDC


	longa
	longi
mapenddo	tyx
	stx	mapptr
	rts  			;**** end of level



	longa
	longi
maploopdo
	tya
	ldx	#0
.findloop	cmp	mapaddrs,x
	beq	.thisloop
	inx
	inx
	cpx	#8
	bne	.findloop
.newloop
	ldx	nummaploops
	sta	mapaddrs,x
	lda.w	mapbase&WM+3,y
	sta	maploops,x

	inc	nummaploops
	inc	nummaploops

	lda.w	mapbase&WM+1,y
	tax
	jmp	newobjex

.thisloop
	lda	maploops,x
	dec	a
	beq	.end
	sta	maploops,x
	tyx
	lda	mapbase&WM+1,x
	tax
	jmp	newobjex

.end
	stz	mapaddrs,x
	stz	maploops,x
	dec	nummaploops
	dec	nummaploops
	tyx
	inx
	inx
	inx
	inx
	inx
	jmp	newobjex


	longa
	longi
mapdebdo	blink

	longa
	longi
mapnopdo	inx
	jmp	newobjex


;--------------------------------------------------------------
; mapnormobj:
;--------------------------------------------------------------

	longa
	longi
mapnormobj

	tyx
	lda	map_count,x
	sta	mapcnt
	phx
	ldx	allst
	l_add	allst,alfreelst,.nofreeblks
	txy
	sty	lastmapobj
	plx
	a8
	jsl	init_objvars_l
	a16

	lda	mm_x,x
	sta.w	al_worldx,y
	lda	mm_y,x
	sta.w	al_worldy,y
	lda	mm_z,x
	sta.w	al_worldz,y

	lda	mm_shape,x
	sta.w	al_shape,y

	lda	mm_strat,x
	sta.w	al_stratptr,y
	lda	mm_strat+1,x
	sta.w	al_stratptr+1,y

	a16
	txa
	clc
	adc	#mm_sizeof-2
	tax
.chkit
	lda	mapcnt
	bne	.listfull
	jmp	newobjex
.listfull	stx	mapptr
	rts
.nofreeblks	a16
	stz	lastmapobj
	pla
	clc
	adc	#mm_sizeof-2
	tax
	bra	.chkit





;--------------------------------------------------------------
; mapmother:
; this generates a mother ship type of alien which generates
; other aliens according to the list specified
; the strategy specified must use the macro s_bemother
;--------------------------------------------------------------

	longa
	longi
mapmother

	tyx
	lda	map_count,x
	sta	mapcnt
	phx
	ldx	allst
	l_add	allst,alfreelst,.nofreeblks
	txy
	sty	lastmapobj
	plx
	a8
	jsl	init_objvars_l
	a16

	lda	mm_x,x
	sta.w	al_worldx,y
	lda	mm_y,x
	sta.w	al_worldy,y
	lda	mm_z,x
	sta.w	al_worldz,y

	lda	mm_shape,x
	sta.w	al_shape,y

	lda	mm_strat,x
	sta.w	al_stratptr,y
	lda	mm_strat+1,x
	sta.w	al_stratptr+1,y

	lda	mm_map,x
	sta.w	al_ptr,y		; store the pointer to the map

	lda	#atzremove
	sta.w	al_type,y

	a16
	txa
	clc
	adc	#mm_sizeof
	tax
.chkit
	lda	mapcnt
	bne	.listfull
	jmp	newobjex
.listfull	stx	mapptr
	rts
.nofreeblks	a16
	stz	lastmapobj
	pla
	clc
	adc	#mm_sizeof
	tax
	bra	.chkit





;----------------------------------------------------------------------
; mapremove:
; this removes the object with the specified shape from the alien list
;----------------------------------------------------------------------

	longa
	longi
mapremove
	ldx	allst
	beq	.out

.keepsearching
	lda	_next,x
	tax
	beq	.out
	lda	mr_shape,y
	cmp	al_shape,x
	bne	.keepsearching
	phy
	jsl	removedeadal_l
	ply

.out
	tya
	clc
	adc	#mr_sizeof
	tax
	jmp	newobjex


;----------------------------------------------------------------------
; mapwait
; this is like adding a null object
;----------------------------------------------------------------------

	longa
	longi

mapwait
	tyx
	inx
	inx
	inx
	lda	mapbase&WM+1-3,x
	beq	.zero
	sta	mapcnt
	stx	mapptr
	rts
.zero	jmp	newobjex

;****************************************************************************
;Kawaguchi Program Start
;****************************************************************************
;---------------------------------------------------------------------
;*		Mission Area Out Off/ON				* 
;---------------------------------------------------------------------
	longa
	longi
mapareaout
	tyx
	km_setgameflag	areaout
	inx
	jmp	newobjex

;---------------------------------------------------------------------
;*		Map Goto If Planet				*
;---------------------------------------------------------------------
	longa
	longi
mapgotoifplanetcode
	km_bitcheckflag16	currentlevel,1
	beq	kg_nojump
	bra	kg_jump

;---------------------------------------------------------------------
;*		Map Goto If Satellite				*
;---------------------------------------------------------------------
	longa
	longi
mapgotoifsatellite
	km_bitcheckflag16.l	kx_satelliteflag,safl_virustorituki
	beq	kg_nojump
	bra	kg_jump

kg_jump
	lda.w	map_count,y
	tax
	jmp	newobjex
kg_nojump
	tya
	clc
	adc	#map_sizeof
	tax
	jmp	newobjex

;****************************************************************************
;Kawaguchi Program End
;****************************************************************************

;	incfile	ASM\mother.asm



