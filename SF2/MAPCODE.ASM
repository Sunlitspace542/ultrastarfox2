;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         MAPCODE.ASM                                         ;
; AUTHOR:       Dylan Cuthbert                                      ;
; DESCRIPTION:  Code to scan map and generate inert lists           ;
; DATE CREATED: 26-2-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;


	INCPUB	mapcode



      
;     ÚÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍµ  MACROS  ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º    ÀÄÄÄÄÄÄÄÄÄÄÙ                               º

i_rangeinit	MACRO
	phx
	a16
	ldx	#viewblk1
	lda	al_worldx,x
	sta	v1x
	lda	al_worldz,x
	sta	v1z

	ldx	#viewblk2
	lda	al_worldx,x
	sta	v2x
	lda	al_worldz,x
	sta	v2z

	plx
	a8
	ENDM

i_rangecheck	MACRO	[view]
	phx
	a16
	txy
	lda.w	i_flags,y
	bit	#if_norangecheck
	bne	.maxrange\@
	lda.w	i_shape,y
	tax
	lda.l	sh_size,x
	asl	a
	asl	a
	clc
	adc	maprange
	cmp	maxmaprangestore
	bcc	.notover\@
.maxrange\@
	lda	maxmaprangestore
.notover\@
	sta	tpz
	asl	a
	sta	tpx

	lda.w	i_flags,y
	bit	#if_exists
	beq	.norm\@

	lda.w	i_alienptr,y
	tax

	lda	tpz
	clc
	adc	#removal_leeway
	sta	tpz
	asl	a
	sta	tpx


	lda	al_worldx,x
	sec
	sbc	v{view}x
	clc
	adc	tpz		; #rangeradius
	cmp	tpx		; #rangeradius*2
	bcs	.notok\@

	lda	al_worldz,x
	sec
	sbc	v{view}z
	clc
	adc	tpz		; #rangeradius
	cmp	tpx		; #rangeradius*2
	bcc	.ok2\@
	bra	.notok\@
;.notok2\@
;	plx
;	phx
.norm\@
	tyx
	lda.w	i_worldx,x
	sec
	sbc	v{view}x
	clc
	adc	tpz		; #rangeradius
	cmp	tpx		; #rangeradius*2
	bcs	.notok\@

	lda.w	i_worldz,x
	sec
	sbc	v{view}z
	clc
	adc	tpz		; #rangeradius
	cmp	tpx		; #rangeradius*2
	bcs	.notok\@
.ok2\@
	a8
	sec
	bra		.ok\@
.notok\@	a8
	clc

.ok\@
	plx
	ENDM


;º                                               º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Initialise the map system ÆÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ             º

mapsysteminit_l
	php
	phb
	a8
	lda	#$7e
	pha
	plb
	ai16

	stz	inertlistptr
	fmtfreelst.w	inertfree,inertlist&WM,number_inert,i_sizeof

	lda     #rangeradius
	sta.l   maprange
	asl     a
	sta.l   maprange2

	lda     #viewradius
	sta.l   viewrange
	asl     a
	sta.l   viewrange2


	jsl	InitBlockmap_l	

	plb
	plp
	rtl

;º                                               º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Scan inert list for new objects to add to alien block list ÆÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     º

scaninerts_l
	php
	phb
	a8i16
	lda	#$7e
	pha
	plb


	pl_jmp_ifbosson	.noareacheck

	km_jmpgameflag	freeze,.nothingdoing

	lda	CurrentArea
	pha
	jsl	CheckAreas_l
	lda	CurrentArea
	sta	x1
	pla
	cmp	x1
	beq	.normalcheck

	lda	#1
	sta	inertrescan
	bra	.checklist

.noareacheck
.normalcheck
	lda	inertrescan
	beq	.normalcheck2
	dec	inertrescan
	bra	.checklist
.normalcheck2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; check to see if either of the players has crossed a 256 boundary
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	ldx	#viewblk1
	lda	oldpx1+1
	cmp	al_worldx+1,x
	bne	.checklist
	lda	oldpz1+1
	cmp	al_worldz+1,x
	bne	.checklist

	test_screenmode	onescreen
	lbne		.nothingdoing

	ldx	#viewblk1
	lda	oldpx2+1
	cmp	al_worldx+1,x
	bne	.checklist
	lda	oldpz2+1
	cmp	al_worldz+1,x
	bne	.checklist
	brl	.nothingdoing

.checklist	a16
	ldx	#viewblk1
	lda	al_worldx,x
	sta	oldpx1
	lda	al_worldz,x
	sta	oldpz1

	ldx	#viewblk2
	lda	al_worldx,x
	sta	oldpx2
	lda	al_worldz,x
	sta	oldpz2

	a8
	i_rangeinit

	ldy	inertlistptr
	lbeq	.nothingdoing

.nxtscan	tyx

; check if in range of view #1
	i_rangecheck	1
	lbcs	.create
; and view #2
	test_screenmode	twoscreen
	lbeq	.deleteit
	i_rangecheck	2
	bcs	.create
.deleteit

; out of both views:
; if exists then remove it
	lda.w	i_flags,x
	bit	#if_exists
	bne	.rubitout
	and	#~if_removedinview
	sta.w	i_flags,x
	brl	.nextinert
.rubitout
	phx
	txy
	ldx.w	i_alienptr,y
	s_remove_obj	x
	plx

; clear the existance flag
	lda.w	i_flags,x
	and	#~(if_exists)
	sta.w	i_flags,x

	brl	.nextinert
	
; in at least one view:
; now to create the object in the REAL world
.create

; if already exists then don't recreate
	lda.w	i_flags,x
	bit	#if_exists
	lbne	.nextinert
	bit	#if_removedinview
	lbne	.nextinert

.makeit

	phx
	a16
	ldx	allst
	l_add	allst,alfreelst,.nocreate
	a8
	txy
	jsl	init_objvars_l
	a16

	ply
	phy

	lda.w	i_worldx,y
	sta	al_worldx,x	
	lda.w	i_worldy,y
	sta	al_worldy,x	
	lda.w	i_worldz,y
	sta	al_worldz,x
	lda.w	i_shape,y
	sta	al_shape,x

	lda.w	i_flags,y
	bit	#if_pathobj
	beq	.normal

	lda.w	i_strat,y
	sta	al_sword2,x

	lda	#path_istrat
	sta	al_stratptr,x
	lda	#path_istrat>>8
	sta	al_stratptr+1,x
	
	bra	.pathobj
.normal
	lda.w	i_strat,y
	sta	al_stratptr,x

	a8
	lda.w	i_strat+2,y
	sta	al_stratptr+2,x
	a16
.pathobj

	tya
	sta.w	al_inertptr,x
	txa
	sta.w	i_alienptr,y

	a8
	lda.w	i_rotx,y
	sta	al_rotx,x	
	lda.w	i_roty,y
	sta	al_roty,x	
	lda.w	i_rotz,y
	sta	al_rotz,x	

	lda.w	i_area,y
	sta	al_area,x

	lda.w	i_flags,y
	ora	#if_exists
	sta.w	i_flags,y

	bit	#if_olsobj
	beq	.noset
	s_set_alsflag	x,olsobj

	lda.w	i_poslist,y
	sta	tempaddrl
	lda.w	i_poslist+1,y
	sta	tempaddrl+1
	lda.w	i_poslist+2,y
	sta	tempaddrl+2

	s_set_resource	L,x,poslist,tempaddrl
.noset
.nocreate
	plx
.nextinert
	ldy.w	_next,x
	lbne	.nxtscan

.nothingdoing

	plb
	plp
	rtl


;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼



;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Purge the alien/inert list of objects in currentarea       ÆÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     º
;º  CurrentArea = tpa                                                     º

PurgeArea_l
	php
	phb
	a8i16
	lda	#$7e
	pha
	plb

; Purge the alien list

	ldx	allst
	beq	.nowtinit
.nxtal
	ldy	_next,x

	lda	al_area,x
	cmp	tpa
	bne	.con

	lda	#0
	sta	al_inertptr,x	; zero its inert connection
	sta	al_inertptr+1,x	; seeing as it will be removed before
				; the alblock is.
	s_remove_obj	x	; remove it (actually removed a frame later)
	
.con	tyx
	bne	.nxtal

.nowtinit
; Now purge the inert objects' list

	ldx	inertlistptr
	lbeq	.nothinginit

.nxti	ldy.w	_next,x

	lda.w	i_area,x
	cmp	tpa
	bne	.coni

	phy
	l_rem.w	inertlistptr,inertfree
	ply

.coni	tyx
	lbne	.nxti

.nothinginit

	stz	olslptr
	stz	olsobjs_num
	stz	olsobj_dead


	plb
	plp
	rtl

;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Have we passed through from one area to another yet?       ÆÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     º
;º                                                                        º
;º Modified to allow two overlapping areas                                º
;º                                                                        º
CheckAreas_l
	php
	phb
	a8i16
	lda	#$7e
	pha
	plb

	a16
	ldx	playpt1
	lda	al_worldx,x
	sta	x1
	lda	al_worldz,x
	sta	z1

	a8
	lda	CurrentArea
	sta	x2
	lda	SecondaryArea
	sta	y2

	lda	#-1
	sta	CurrentArea
	sta	SecondaryArea

	lda	NumAreas
	and	#255
	lbeq	.noareas
	sta	tpa
	stz	tpa+1

	stz	tpx	; which area number are we checking

	ldx	#areas&WM
.nxtarea	a16
	lda.w	mar_flags,x
	bit	#ar_active
	lbeq	.notinthisone

	lda	x1
	sec
	sbc.w	mar_x,x
	cmp.w	mar_width,x
	lbcs	.notinthisone

	lda	z1
	sec
	sbc.w	mar_z,x
	cmp.w	mar_length,x
	bcs	.notinthisone

	a8
	lda	tpx
	cmp	x2			; old CurrentArea
	beq	.setarea		; same as current so no change

	cmp	y2			; old SecondaryArea
	beq	.setarea

	printd	Set,yamada

	a16

	lda.w	mar_mapaddr,x
	sta	mapptr
	a8
	lda.w	mar_mapaddr+2,x
	sta	mapbank

.setarea
	lda	CurrentArea
	inc	a
	beq	.ok_set		; if CurrentArea already set then
	dec	a		; swap out to SecondaryArea
	sta	SecondaryArea
.ok_set

;	lda	#15
;	trb	CurrentArea	; mask out the bottom nybble
	lda	tpx		; preserving the level number
;	ora	CurrentArea	; and or the new area number in
	sta	CurrentArea

	cmp	y2		; compare with secondary area
	beq	.okswap
	cmp	x2		; compare with old current area
	bne	.okdontswap	; if same then swap with secondary area
.okswap	lda	SecondaryArea	; if secondaryarea=-1 then don't swap
	cmp	#-1
	beq	.okdontswap
	cmp	y2
	beq	.okdontswap

	lda	SecondaryArea
	sta	CurrentArea
	lda	tpx
	sta	SecondaryArea

.okdontswap

.notinthisone
	a16
	txa
	clc
	adc	#mar_sizeof
	tax
	inc	tpx
	dec	tpa
	lbne	.nxtarea
.noareas
; now check to see if purge is necessary
	a8
	lda	CurrentArea	; the only time these should be the same
	cmp	SecondaryArea	; is if they are both -1
	lbne	.chkpurge	; don't purge the map if not in any area

	lda	x2
	sta	CurrentArea
	lda	y2
	sta	SecondaryArea	; restore to last frame's map settings

	brl	.nopurge2

.chkpurge
	lda	x2	; old CurrentArea
	cmp	#-1
	beq	.nopurge1
	cmp	CurrentArea
	beq	.nopurge1
	cmp	SecondaryArea
	beq	.nopurge1

	sta	tpa
	printd	purged,yamada
	jsl	PurgeArea_l

.nopurge1

	lda	y2	; old SecondaryArea
	cmp	#-1
	beq	.nopurge2
	cmp	CurrentArea
	beq	.nopurge2
	cmp	SecondaryArea
	beq	.nopurge2

	sta	tpa
	printd	purged,yamada
	jsl	PurgeArea_l

.nopurge2

	plb	
	plp
	rtl
	


;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Set up the bitmap blockmap for the current map             ÆÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     º

InitBlockmap_l

	php
	phb
	a8i16
	lda	#$7e
	pha
	plb

	lda	#-1
	ldx	#0
.setemall
	sta	solidblockmap&WM,x
	inx
	cpx	#(blockmap_numblocks/8)*blockmap_numblocks
	bne	.setemall

	plb
	plp
	rtl

;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Clear an area of the blockmap for a particular area        ÆÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     º

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; On entry A holds the area to change
; bit 7 of A is one to set the area impassable
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ClearBlockmapArea_l
	php
	phb
	a8i16
	sta	x1
	lda	#$7e
	pha
	plb

	a16
	lda	x1
	and	#127	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	tax		³ calculate index into area³
	beq	.le_fin	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lda	#0
	clc
.multiply	adc	#mar_sizeof
	dex
	bne	.multiply
	clc
	tax
.le_fin
	a8
	lda	#255
	rol	x1
	sbc	#255	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	eor	#255	³ Mask (0/255) ³
	sta	y1	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	a16
	lda	areas&WM+mar_x,x
	sta	x1

	lda	areas&WM+mar_z,x
	sta	z1

	lda	areas&WM+mar_width,x
	sta	x2

	lda	areas&WM+mar_length,x
	sta	z2


	jsl	SetBlockMap_l

	plb
	plp
	rtl

;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Set an area of the blockmap to a particular mask           ÆÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     º
;º Entry:                                                                 º
;º       x1,z1 = world coordinates of top left                            º
;º       x2,z2 = width and length in world coordinates                    º
;º       y1 = mask (255 or 0)                                             º

SetBlockMap_l
	php
	phb
	a8i16
	lda	#$7e
	pha
	plb

	a16

	lda	x1
	blockmap_scale_x
	sta	tpa
;				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	blockmap_scale_mask	³ Get the bit mask ³
	sta	y2		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lsr	tpa		ÚÄÄÄÄÄ¿
	lsr	tpa		³ x/8 ³
	lsr	tpa		ÀÄÄÄÄÄÙ

	lda	z1
	blockmap_scale_z
	clc			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	adc	tpa		³ Ok, now TPA holds the offset ³
	sta	tpa		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lda	x2
	clc
	adc	#blockmap_Resolution-1
	blockmap_scale_x
	sta	x2

	lda	z2
	clc
	adc	#blockmap_Resolution-1
	blockmap_scale_x
	sta	z2

.zloop
	lda	tpa
	tax
	lda	x2
	pha


	a8

	lda	y2
	pha

.xloop
; y1 = on/off mask, y2 = positional mask

	lda	solidblockmap&WM,x
	sta	tpx

	lda	y2		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	and	#-1		³ Clear the bit ³
	trb	tpx		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lda	y1		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	and	y2		³ Set the bit to 0 or 1 ³
	tsb	tpx		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lda	tpx
	sta	solidblockmap&WM,x

	clc
	rol	y2		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	bcc	.noinc		³ Have we exhausted this byte? ³
	rol	y2		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	inx
	a16
	txa
	bit	#7		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	bne	.noinc		³ Check to wrap X at edges ³
	sec			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	sbc	#blockmap_numblocks/8
	tax
.noinc	a8

	dec	x2
	bne	.xloop


	pla
	sta	y2

	a16

	pla
	sta	x2
;				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	lda	tpa		³ move down to the next line ³
	clc			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	adc	#blockmap_numblocks/8
	cmp	#(blockmap_numblocks/8)*blockmap_numblocks
	bcc	.noadjust
	sec
	sbc	#(blockmap_numblocks/8)*blockmap_numblocks
.noadjust
	sta	tpa

	dec	z2
	bne	.zloop

	plb
	plp
	rtl


;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Debugging: displays the blockmap on the 3d bitmap screen   ÆÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     º

	SHORTA
	LONGI
showblockmap_l
	IFNE	blockmap_dbg

	php

	ai16
	ldx	#0

temp	=	((blockmap_numblocks/8)*blockmap_numblocks)/2

.copyit
	lda.l	solidblockmap,x
	sta.l	m_drawlist+8+temp,x
	lda.l	solidblockmap+2,x
	sta.l	m_drawlist+10+temp,x
	lda.l	solidblockmap+4,x
	sta.l	m_drawlist+12+temp,x
	lda.l	solidblockmap+6,x
	sta.l	m_drawlist+14+temp,x
	lda.l	solidblockmap+8,x
	sta.l	m_drawlist+0+temp,x
	lda.l	solidblockmap+10,x
	sta.l	m_drawlist+2+temp,x
	lda.l	solidblockmap+12,x
	sta.l	m_drawlist+4+temp,x
	lda.l	solidblockmap+14,x
	sta.l	m_drawlist+6+temp,x

	lda.l	solidblockmap+temp,x
	sta.l	m_drawlist+8,x
	lda.l	solidblockmap+2+temp,x
	sta.l	m_drawlist+10,x
	lda.l	solidblockmap+4+temp,x
	sta.l	m_drawlist+12,x
	lda.l	solidblockmap+6+temp,x
	sta.l	m_drawlist+14,x
	lda.l	solidblockmap+8+temp,x
	sta.l	m_drawlist+0,x
	lda.l	solidblockmap+10+temp,x
	sta.l	m_drawlist+2,x
	lda.l	solidblockmap+12+temp,x
	sta.l	m_drawlist+4,x
	lda.l	solidblockmap+14+temp,x
	sta.l	m_drawlist+6,x

	txa
	clc
	adc	#16
	tax
	cpx	#temp
	lbne	.copyit

	a16
	ldx	playpt1
	lda	al_worldx,x
	clc
	adc	#32768
	blockmap_scale_x
	sta.l	m_x1

	lda	al_worldz,x
	clc
	adc	#32768
	blockmap_scale_x
	sta.l	m_z1

	a8
	call_mario	mdrawblockmap
	plp

	rtl

	ENDC
;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍµ Checks a position on the map for solidity                  ÆÍÍÍÍÍ»
;º     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     º
;º                                                                        º
;º Entry: x1,z1 are worldx and worldz                                     º
;º Exit: x1 is zero or non-zero                                           º
;º                                                                        º
;º Assumes bank 7e                                                        º

CheckBlockMap_l
	php
	ai16
	phx

	lda	x1
	blockmap_scale_x
	sta	tpa
;				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	blockmap_scale_mask	³ Get the bit mask ³
	sta	y2		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lsr	tpa		ÚÄÄÄÄÄ¿
	lsr	tpa		³ x/8 ³
	lsr	tpa		ÀÄÄÄÄÄÙ

	lda	z1
	blockmap_scale_z
	clc			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	adc	tpa		³ Ok, now X holds the offset ³
	tax			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	a8
	lda	solidblockmap&WM,x
	and	y2
	sta	x1

	plx
	plp
	rtl

;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

