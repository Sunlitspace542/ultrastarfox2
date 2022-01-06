;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                                                                    ³
;³                 STARFOX II - REVENGE OF PEPPY -                    ³
;³                                                                    ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³                                                                    ³
;³ FILE:         GSTRATS.ASM                                          ³
;³ AUTHOR:       Takumi Kawagoe                                       ³
;³ DESCRIPTION:  Strategy for enemy                                   ³
;³ DATE CREATED: 25-11-93                                             ³
;³                                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	INCPUB	tstrats

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;------------------------------------------------------------------
;	In	:	x:obj(weapon,enemy etc...) pointer
;

	SHORTA
	LONGI


explode_sound_plr1_l
	phy
	php
	ldy			#viewblk1
	bra			exps_enter

explode_sound_plr2_l
	phy
	php
	ldy			#viewblk2

exps_enter	s_jmp_distmore		x,y,#snddist_far,.far
	s_jmp_distmore		x,y,#snddist_near,.near
.sonear
	ksound		en_explode_s
	bra			.exitsnd
.near
	ksound		en_explode_s,midC
	bra			.exitsnd
.far
	ksound		en_explode_s,far

.exitsnd

	plp
 	ply
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ROUTINES
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
TSTRATsrous_l

.initsprite	LOCAL

	s_set_alsflag		y,notslope
	s_set_alsflag		y,colldisable
	s_init_colanim		y,#0
	s_set_aldata		y,#1,#1	;hardHP,#hardAP
	s_set_alvartobeobj	y,al_ptr,x
	s_sprite_obj		y,#0,#0
	s_copy_pos		y,x
	s_copy_rots		y,x
	s_clr_alsflag		y,shadow
	s_clr_alsflag		y,realobj
	rtl

TSTRAT_000_l

	s_start_strat

	lda	al_rotx,x
	bmi	.mi

	cmp	#30
	bmi	.exit
	dec	a
	bra	.sta

.mi	cmp	#-30
	bpl	.exit
	inc	a
.sta

	sta	al_rotx,x

.exit	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	particle obj
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

player_particle_istrat

	s_start_strat

	s_set_alsflag	x,nohitaffect
	s_set_alvar	B,x,al_count,#0
	s_set_strat	x,.strat0



.strat0
	s_jmp_alvarless	B,x,al_count,#100,.exit
	s_set_strat	x,.strat1
	s_set_alvar	B,x,al_sbyte3,#0
	bra		.exit


.strat1
.exit	s_inc_alvar	B,x,al_count

	ldy		playpt1
	s_copy_pos	x,y
	s_jmp_alvarless	B,x,al_count,#127,.alive
	s_remove_obj	x
.alive	s_end_strat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	for demo
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

setpilotshape_srou_l

;	in	: A player number (0-5)

	PUSHXYP

	ai16

	txy
	and	#15
	cmp	#6
	bcc	.ok
	lda	#5
.ok
	asl	a
	asl	a
	tax
	lda.l	.tab+0,x
	sta.w	al_shape,y
	lda.l	.tab+2,x
	sta.w	al_coltab,y

	PULLXYP

	rtl

.tab	dw	a_wing,id_0_c
	dw	a_wing,id_1_c
	dw	c_wing,id_0_c
	dw	c_wing,id_1_c
	dw	b_wing,id_0_c
	dw	b_wing,id_1_c


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

rotateplrpos2childpos_l

; Call from player's dummy shape(child)

	s_start_strat

	PUSHXYP

	a8i16

	s_push_obj	x

	ldy	al_childrotobj,x
	tyx

	ldy	playpt1

	lda.w	al_roty,y
	sec
	sbc	al_roty,x
	sta	work0

	a16
	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	sta	x1
	sta	x2

	;lda.w	al_worldy,y
	;sec
	;sbc	al_worldy,x
	lda	#0
	sta	y1
	sta	y2

	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	sta	z1
	sta	z2

	a8
	lda	al_roty,x
	nega
	jsl	rotate_16xz_l

	s_pull_obj	x

	a16
	lda	x2
	sta	al_childx,x
;	lda	y2
;	sta	al_childy,x
	lda	z2
	sta	al_childz,x
	a8
	lda	work0
	sta	al_childroty,x

	PULLXYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; D_SEN DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
setcoreENTERroty_srou_l	; call from player strat


	s_start_strat

	PUSHYP

	ldy	dummyobj
	a16
	lda	corex
	sta.w	al_worldx,y
	lda	corez
	sta.w	al_worldz,y
	a8

	s_set_alvar	B,y,al_roty,Kinitroty
	s_add_roffs2pos	B,y,y,y,#0,#0,#120,0,1,0,5,5,5

	s_exg_objs
	s_obj2obj_angle	x,y,al_roty,0
	s_exg_objs

	lda.w	al_roty,y
	sec
	sbc	Kinitroty
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	coreENTERroty


	PULLYP

	rtl




	IFEQ	1

; corex	= d_sen no worldx
; corez	= d_sen no worldz

	s_start_strat

	PUSHYP

	ai16

	lda	al_worldx,x
	sec
	sbc	corex
	sta	x1
	sta	x2

	lda	al_worldz,x
	sec
	sbc	corez
	sta	z1
	sta	z2

;------------
	a8

	lda	Kinitroty
	nega

	jsl	rotate_16xz_l

	a16

	lda	z2
	printh	COREZ2,kawagoe
	lda	x2
	printh	COREX2,kawagoe



	stz	tpx

	lda	z2
	bpl	.plz
.miz	cmp	#-120<<d_sen_scale
	bmi	.z0
	bra	.z1
.plz	cmp	#150<<d_sen_scale
	bmi	.z2
.z3	inc	tpx
.z2	inc	tpx
.z1	inc	tpx
.z0	asl	tpx
	asl	tpx

	lda	x2
	bpl	.plx
.mix	cmp	#-40<<d_sen_scale
	bmi	.x0
	bra	.x1

.plx	cmp	#40<<d_sen_scale
	bmi	.x2
.x3	inc	tpx
.x2	inc	tpx
.x1	inc	tpx
.x0
	PHX
	ldx	tpx
	lda.l	.tab,x

	PLX

	a8

	sta	coreENTERroty

.tab	db	7	;*20h	;0
	db	0	;*20h	;1
	db	0	;*20h	;2
	db	1	;*20h	;3
	db	6	;*20h	;4
	db	6	;*20h	;5
	db	2	;*20h	;6
	db	2	;*20h	;7

	db	6	;*20h	;8
	db	6	;*20h	;9
	db	2	;*20h	;10
	db	2	;*20h	;11

	db	5	;*20h	;12
	db	4	;*20h	;13
	db	4	;*20h	;14
	db	3	;*20h	;15

	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; D_SEN DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
setd_senpos_srou_l	; call from path program
	rtl
	s_start_strat
	PUSHYP
	a8i16
	ldy	dummyobj
	a16
	lda	corex
	sta.w	al_worldx,y
	lda	corez
	sta.w	al_worldz,y
	a8
	s_jsl	anglexy_l
	a8
	xba
	nega
	sta	tpy
	lda	#0ffh
	sec
	sbc	coreENTERroty	;tpy
	printh	RREWRRWR,kawagoe
;	nega
;	sta	tpy
;
;	sec
;	sbc	al_roty,x
	sta	al_childroty,x
	PULLYP
	rtl
; corex	= d_sen no worldx
; corez	= d_sen no worldz
	s_start_strat
	PUSHYP
	a8i16
; set camera pos
	txy
	PHX
	lda	coreENTERroty
;	clc
;	adc	#-10h
;	lsr	a
;	lsr	a
	a16
	and	#%111000
	printh	TABX,kawagoe
	tax
	lda.l	.tab+0,x
	sta.w	al_childx,y
	clc
	adc	corex
	sta.w	al_worldx,y
	lda.l	.tab+2,x
	sta.w	al_childy,y
	sta.w	al_worldy,y
	lda.l	.tab+4,x
	sta.w	al_childz,y
	clc
	adc	corez
	sta.w	al_worldz,y
	lda.l	.tab+6,x
	sexa
	sta.w	al_vx,y
	lda.l	.tab+7,x
	sexa
	sta.w	al_vz,y
	txa
	PLX
	a8
	sta	al_pbyte1,x
	PULLYP
	rtl
.tab
;0
	dw	0febbh,0fe70h,109ah
	db	0
	db	0
;1
	dw	0febbh,0fe70h,109ah
	db	0
	db	0
;2
	dw	0febbh,0fe70h,109ah
	db	0
	db	0
;3
	dw	0febbh,0fe70h,109ah
	db	12
	db	0
;4
	dw	0febbh,0fe70h,109ah
	db	0
	db	0
;5
	dw	0febbh,0fe70h,109ah
	db	-12
	db	0
;6
	dw	0febbh,0fe70h,109ah
	db	0
	db	0
;7
	dw	0febbh,0fe70h,109ah
	db	0
	db	0
; pos y = 0fc18h (normal)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	END OF FILE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	end
