;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                   STARFOX II - THE SEQUEL                          ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³ FILE:         WEAPONS.ASM                                          ³
;³ AUTHOR:       Dylan Cuthbert & Takumi Kawagoe(EDA)                 ³
;³ DESCRIPTION:  Code for various weapons                             ³
;³ DATE CREATED: 24-2-93                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	INCPUB	weapons

karauchiang	equ	40h

; -- work ram --

;work0	=	twork+0
;work1	=	twork+2
;work2	=	twork+4
;work3	=	twork+6
;work4	=	twork+8
;work5	=	twork+10
;work6	=	twork+12
;work7	=	twork+14
;work8	=	twork+16
;work9	=	twork+18
;work10	=	twork+20
;work11	=	twork+22
;work12	=	twork+24
;work13	=	twork+26
;work14	=	twork+28
;work15	=	twork+30

	strats_start

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                                         º
;º           ENEMY'S WEAPON                º
;º                                         º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

;this is called when s_fire is used

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Relative weapon
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

fireRelElaser_hsp_l

	s_start_strat
	jsr	genweap_srou
	rlbcc	weap_badobj
	s_set_path	y,RelElaser_hsp
	jsr		Eweap_init	;weapon_srous.Einit_laser
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

fireRelElaser_l

	s_start_strat
	jsr	genweap_srou
	rlbcc	weap_badobj
	s_set_path	y,RelElaser
	jsr	Eweap_init	;	weapon_srous.Einit_laser
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

fireElaser_l

	s_start_strat
	jsr	genweap_srou
	rlbcc	weap_badobj
	s_set_path	y,Elaser
	wm_set_speed	y,Elaser
	jsr	Eweap_init	;	weapon_srous.Einit_laser
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENEMY'S RING LASER
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

fireEring_l
	s_start_strat
	jsr	genweap_srou
	rlbcc	weap_badobj
	s_set_path	y,RelEring
	wm_set_speed	y,Ering
	jsr		Eweap_init
	rtl


fireRelEring_l

	s_start_strat
	jsr	genweap_srou
	rlbcc	weap_badobj
	s_set_path	y,RelEring
.enter	LOCAL
	jsr		Eweap_init
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENEMY'S PLASMA
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

fireEplasma1_l

	jsr	genweap_srou
	rlbcc	weap_badobj
	s_set_path	y,Eplasma1
;TEST	wm_set_speed	y,Eplasma1
.enter	LOCAL
	jsr		Eweap_init

.badobj	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

fireRelEplasma1_l

	s_start_strat
	jsr	genweap_srou
	rlbcc	weap_badobj
	s_set_path	y,RelEplasma1
.enter	LOCAL
	jsr	Eweap_init
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Homing weapoon
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

fireHomEmissile_l

	s_start_strat
	jsr	genweap_srou
	rlbcc	weap_badobj
	s_set_path	y,HomEmissile
	s_clr_alsflag	y,dontexplode

.enter	LOCAL
;	jsr		weapon_srous.Einit_missile
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Normal weapon(Friend)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;fireFlaser_l
;
;	s_start_strat
;	jsr		genweap_srou
;	rlbcc		weap_badobj
;	s_set_path	y,Flaser
;	s_set_alsflag	y,dontexplode
;	s_set_alvar	W,y,al_immuneptr,playpt1
;
;	s_init_anim	y,#3
;
;	rtl
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÚÄÄÄÄÄÄÄÄÄ¿
;³ rebound ³ player & enemy
;ÀÄÄÄÄÄÄÄÄÄÙ

firerebound_l	; relative to player
		; sflag1 : using for limitter

	s_start_strat

	jsr	genweap_srou
	rlbcc	weap_badobj

	cpx	playpt1
	beq	.player
	cpx	playpt2
	beq	.player

;------------------------------------------------------------------------------
.enemy
	jsr	Eweap_init	;	weapon_srous.Einit_laser
	s_set_path	y,Erebound
	s_set_alvar	B,y,al_hp,#REBOUNDHP
	s_set_alvar	B,y,al_ap,#REBOUNDAP

	jmp		.exit

;------------------------------------------------------------------------------
.player
;------------------------------------------------------------------------------

.mission
	s_set_path	y,Prebound

	s_set_alvar	B,y,al_hp,#REBOUNDHP
	s_set_alvar	B,y,al_AP,#REBOUNDAP


;------------------------------------------------------------------------------
.exit	rtl



.badobj	ldy	dummyobj
	rtl

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                                                       º
;º	PLAYER'S WEAPON (PLAYER only)               º
;º                                                       º
;º            set colltype	= FRIEND,LASER              º
;º                                                       º
;º	set al_ptr	= player's pointer          º
;º                                                       º
;º	set sflag10 if shoot by player2             º
;º                                                       º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ player's weapon "POWERD LASER" ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fireAWpowerdlaser_l
fireAWpowerdlaser_twin_l
fireAWpowerdlaser_twintwin_l

; al_shape wa path de AP wo set surunoni tsukau...

	a8i16

	jsr		genPweap_srou
	rlbcc		weap_badobj
	s_set_alvar	W,y,al_shape,#tame	;kawaguchibeem

.init	LOCAL

	s_set_path		y,Ppowerdlaser
	s_copy_alvar2alvar	B,y,al_rotz,x,al_rotz
	lda	p1_firerotx
	sta.w	al_rotx,y

;************
	jsr	Pweapshape_srou
;************

	s_set_alvar	B,y,al_HP,#PpowerdlaserHP
	s_set_alvar	B,y,al_AP,#PpowerdlaserAP


.badobj	LOCAL

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ player's weapon "twintwin LASER" ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fireAWlaser_twintwin_l

	a8i16

	jsl		chk_laser_lmt_l
	rlbcc		weap_badobj
	jsr		genPweap_srou
	rlbcc		weap_badobj
	s_set_alvar	W,y,al_shape,#beam_2

	bra		fireAWlaser_twin_l.enter

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ player's weapon "twin LASER" ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fireAWlaser_twin_l

	a8i16

	jsl		chk_laser_lmt_l
	rlbcc		weap_badobj
;------------------------------------------------------------------------------------------
; make gunblaze

;	jsl	makegunblaze_srou_l

;------------------------------------------------------------------------------------------
	jsr		genPweap_srou
	rlbcc		weap_badobj
	s_set_alvar	W,y,al_shape,#beam_1

.enter	LOCAL

	s_push_obj	y
	toheap		y,x
	lda		exal_rollingoffset,y
	s_pull_obj	y
	sta.w		al_childrotz,y
	jmp		fireAWlaser_l.init

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ player's weapon "normal LASER" ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fireAWlaser_l

; al_shape wa path de AP wo set surunoni tsukau...

	a8i16

	jsl		chk_laser_lmt_l
	rlbcc		weap_badobj


;	toheap	y,x
;
;	lda	exal_target_x,y
;	printh	TARGETX,kawagoe
;	sta.w	al_worldx,y
;	lda	exal_target_y,y
;	printh	TARGETY,kawagoe
;	sta.w	al_worldy,y
;	lda	exal_target_z,y
;	printh	TARGETZ,kawagoe
;	sta.w	al_worldz,y




;------------------------------------------------------------------------------------------
; make gunblaze

;	jsl	makegunblaze_srou_l

;------------------------------------------------------------------------------------------

	jsr		genPweap_srou
	rlbcc		weap_badobj

	s_set_alvar	W,y,al_shape,#beam_0

	s_set_alvar	B,y,al_childrotz,#0

.init	LOCAL

	s_set_path	y,Plaser

;	s_make_child	#childno_Plaser

;	s_push_obj	y
;	toheap	y,x
;	lda	exal_acclroty+1,y
;	s_pull_obj	y

;*********** player's accel roty
;	sta.w	al_pbyte1,y
;***********

	s_copy_alvar2alvar	B,y,al_rotz,x,al_rotz

	s_init_anim	y,#3


;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
	IFEQ	1

	phx
	phy
	tyx
	wm_find_enemynearobj	y,x,#0,#2000,#25,#25,.cant
	phx
	ldx	dummyobj
	a16
	lda.w	al_vx,y
	asl	a
	asl	a
	asl	a
	clc
	adc.w	al_worldx,y
	sta	al_worldx,x
	lda.w	al_vy,y
	asl	a
	asl	a
	asl	a
	clc
	adc.w	al_worldy,y
	sta	al_worldy,x
	lda.w	al_vz,y
	asl	a
	asl	a
	asl	a
	clc
	adc.w	al_worldz,y
	sta	al_worldz,x
	a8
	plx
	s_obj2obj_3Dangle	x,y,al_roty,al_rotx,0
.cant	ply
	plx

	ENDC
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;	IFEQ	1

	s_push_obj	y
	s_push_obj	x


	s_push_obj	y	; push idY


	toheap	y,x

	tyx

	a16
	ldy	dummyobj
	lda	exal_target_x,x
	;;;printh	TARGETX,kawagoe
	sta.w	al_worldx,y
	lda	exal_target_y,x
	;;;printh	TARGETY,kawagoe
	sta.w	al_worldy,y
	lda	exal_target_z,x
	;;;printh	TARGETZ,kawagoe
	sta.w	al_worldz,y
	a8

	s_pull_obj	x	; pull weapon's pointer as idX

	s_obj2obj_angle	x,y,al_roty,0

	s_pull_obj	x
	s_pull_obj	y



;	s_copy_alvar2alvar	B,y,al_rotx,x,al_rotx




;	ENDC




;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

;************
	jsr	Pweapshape_srou
;************


.badobj	LOCAL

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ player's weapon "PLASMA"(limitter tuki) ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

firePplasma_l

	toheap	y,x
	lda	exal_weap_level,y
	and	#3
	rlbeq	weap_badobj

	jsl		chk_laser_lmt_l
	rlbcc		weap_badobj
	jsr		genPweap_srou
	rlbcc		weap_badobj

;---------------------------------------------------------------------------------------------
; set SHAPE & AP,HP

	PHY
	toheap	y,x
	lda	exal_weap_level,y
	PLY
	and	#3
	dec	a
	beq	.lv0
	pha
	s_set_alvar	W,y,al_shape,#beam_2
	pla
	dec	a
	beq	.lv1

.lv2	lda	#Pplasma1twintwinAP
	bra	.AP
.lv1	lda	#Pplasma1twinAP
	bra	.AP
.lv0
	s_set_alvar	W,y,al_shape,#plasma1
	s_sprite_obj	y,#0
	lda	#Pplasma1AP
.AP	sta.w	al_AP,y

;---------------------------------------------------------------------------------------------
; set PATH

.mission	s_set_path		y,pplasma0

;---------------------------------------------------------------------------------------------
; find enemy
;
;	s_push_obj	x
;	s_push_obj	y
;
;	wm_find_enemynearobj	y,x,#0,#7000,#10,#50,.cantfind
;
;	sty	x1	; chase onj
;
;.found
;
;	ldx	dummyobj
;
;	a16
;	lda.w	al_vx,y
;	asl	a
;	asl	a
;	clc
;	adc.w	al_worldx,y
;	sta	al_worldx,x
;	lda.w	al_vy,y
;	asl	a
;	asl	a
;	clc
;	adc.w	al_worldy,y
;	sta	al_worldy,x
;	lda.w	al_vz,y
;	asl	a
;	asl	a
;	clc
;	adc.w	al_worldz,y
;	sta	al_worldz,x
;	a8
;
;	s_copy_pos	x,y
;
;	s_weapon_rots2obj	x
;
;
;.cantfind	s_pull_obj	y
;	s_pull_obj	x
;
;---------------------------------------------------------------------------------------------
;	s_push_obj	x
;
;
;	ldx	svar_weapobj
;	beq	.nofind
;
;	s_exg_objs
;	s_obj2obj_3dangle	x,y,al_pbyte1,al_rotx,0
;	lda	al_rotx,x
;	asra
;	sta	tpx
;	asra
;	asra
;	clc
;	adc	tpx
;	sta	al_rotx,x
;	s_exg_objs
;
;
;.nofind	s_pull_obj	x
;
;	lda.w	al_rotx,y
;	bmi	.lmtmix
;.lmtplx	cmp	#25
;	bcc	.nolmtx
;	lda	#25
;	bra	.stax
;.lmtmix	cmp	#-25
;	bcs	.nolmtx
;	lda	#-25
;.stax	sta.w	al_rotx,y
;.nolmtx


	lda	p1_firerotx
	sta.w	al_rotx,y


;set weapon counter

.count


;************
	jsr	Pweapshape_srou
;************

.exit
	rtl

;.badobj	ldy	dummyobj
;	rtl



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;plasmaexplode_istrat
;
;	s_start_strat
;	jsl	dec_laser_lmt_l	; Dec Player fire limitter
;	jml	explode_istrat
;
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ player's weapon "SPREADPLASMA"(limitter tuki) ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
firespreadplasma_l
	jsr		genPweap_srou
	rlbcc		weap_badobj
	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
	s_set_path	y,spreadplasma
	s_set_aldata	y,#spreadHP,#spreadAP
	a16
	txa
	sta.w	al_pword1,y
	a8
;	sm_jmp_if1screen	.battle
;
;	s_jmpnot_alsflag	x,player2,.chaseplayer2
;
;.chaseplayer1
;	a16
;	lda	playpt1
;	bra	.setptr
;
;.chaseplayer2
;	a16
;	lda	playpt2
;	bra	.setptr
;
;.battle	a16
;	lda	#0
;.setptr	sta.w	al_ptr,y
;	a8
.se	pl_SE		x,arwingbmball1,arwingbmball2
	rtl
.badobj	ldy	dummyobj
	rtl
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ player's special weapon "DUMMY"(limitter tuki) ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
; fire dummy - this is called when s_fire is used
;	al_ptr		obj pointer of player
;	sflag6		set mark?
;	sflag5		smoke flag smoke wo set sitaato clr suru.
;	al_sbyte1	using in gen_weapon_l
;	al_sbyte2	using in gen_weapon_l
;	al_sbyte3	using in gen_weapon_l
;	al_pbyte1	special weapon counter
;	al_pbyte2	rotz counter
;	al_sword1	get height(RB)
awdummyANIMMAX	equ	8
fireawdummy_l
.make	jsr		genPweap_srou
	rlbcc		weap_badobj
	s_clr_alsflag	y,dontexplode
	s_copy_alvar2alvar	B,y,al_vel,x,al_vel
	sp_jmp_playertype	x,UFO,.AM
	sp_jmp_playertype	x,ROBOT,.RB
.AW	pl_set_PILOTshape	x,y,.AWshapetab
	s_set_path	y,arwingdummy
	jmp			.exitshape
.RB	pl_set_PILOTshape	x,y,.RBshapetab
	s_set_path	y,robotdummy
	s_add_roffs2pos	B,y,x,y,#0,#-15,#20,0,1,0
	bra			.exitshape
.AM	pl_set_PILOTshape	x,y,.AMshapetab
	s_set_path		y,arwingdummy
.exitshape	s_jmp_NOTalsflag	x,player2,.p1
.p2	s_set_coltab		y,#id_1_c&WM
.p1	wm_incspweappnt		y,x,al_pbyte1
	s_set_aldata		y,#dummyHP,#dummyAP
	rtl
.badobj	ldy	dummyobj
	rtl
.awdummyvec	rts
.AWshapetab	dw	aw_dummy
	dw	cw_dummy
	dw	bw_dummy
.AMshapetab	dw	au_dummy
	dw	cu_dummy
	dw	bu_dummy
.RBshapetab	dw	ar_dummy
	dw	cr_dummy
	dw	br_dummy
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ player's special weapon "MISSILE1"(limitter tuki) ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
; fire missile - this is called when s_fire is used
;	al_ptr		obj pointer of player
;	al_pbyte1	(=rotx)
;	al_pbyte2	(=roty)
firemissile1_l
;	pword1	: world Y limitter
;		: 8000h : off
missilrxchaserate	EQU	5
missilrychaserate	EQU	5
	s_jmp_childalive	#childno_missile,.badobj
	jsr		genPweap_srou
	rlbcc		weap_badobj
	s_clr_alsflag	y,dontexplode
	s_set_path	y,Pmissile
;	s_set_alvar	B,y,al_vel,#5
;	s_copy_rots	y,x
;	s_exg_objs
;	s_gen_3Dvecs	x,al_roty,al_rotx,al_vel
;	s_exg_objs
	phy
	toheap	y,x
	pl_test_planetmode	space
	beq			.space
	a16
	lda	exal_vx,y
	sta	tpx
	lda	exal_vz,y
	sta	tpz
	lda	exal_pooldepth,y
	ply
	bra	.sety
.space	lda	#8000h
.sety	sta.w	al_pword1,y
	lda	tpx
	sta.w	al_childx,y
	lda	tpz
	sta.w	al_childz,y
	a8
;	s_copy_alvar2alvar	B,y,al_vel,x,al_vel
;	s_sub_alvar		B,y,al_vel,#2
;	s_set_alvartobeobj	y,al_ptr,x	; player obj
;	s_clr_alsflag		y,realobj
;	s_set_alptrs	y,.mainstrat,hit_istrat,.explode
;	s_clr_alsflag	y,realobj
;	s_set_aldata	y,#PmissileHP,#PmissileAP
;	s_set_lifecnt	y,#PmissileLIF
.exit	rtl
.badobj	ldy	#0	;dummyobj
	rtl
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC





;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-----------------------------------------------------------------------------
;	ironna routine
;-----------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;player no enemy marker wo current obj wo mark suru you ni kaeru.
;
;setEmark_srou	;al_ptr = player's pointer
;
;	s_start_strat
;
;	phy
;	phx
;
;	s_set_objtobealvar	y,x,al_ptr
;	cpy	playpt2
;	beq	.p2
;	cpy	playpt1
;	bne	.exit
;
;.p1	setenemymark		x,1
;	bra			.exit
;.p2	setenemymark		x,2
;
;.exit
;	ply
;	rts
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;makesmoke2_l
;	in	:A = smoke size
;
;
;	phx
;	phy
;	php
;
;	a8i16
;	s_make_obj	#smoke,.badobj
;	jsl		TSTRATsrous_l.initsprite
;	s_set_strat	y,.strat
;	s_copy_pos	y,x
;
;.badobj	plp
;	ply
;	plx
;
;	rtl
;
;
;
;.strat	s_start_strat
;	s_add_colanim	x,#2,#8,.remove
;.end	s_end_strat
;
;.remove	s_remove_obj	x
;	s_end_strat
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³Strats for explosion³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;generateexplodeRND127_l
;
;	shorta
;	longi
;
;	PUSHXYP
;
;	a8i16
;	jsl		generateexplode_plr_l
;	rlbcc		.exit
;	s_add_rnd2pos	y,127,127,127,0,0,1
;
;.exit	PULLXYP
;	rtl
;generateexplodeRND61_l
;
;	shorta
;	longi
;
;	PUSHXYP
;
;	a8i16
;	jsl		generateexplode_l
;	rlbcc		.exit
;	s_add_rnd2pos	y,61,61,61,0,0,1
;
;.exit	PULLXYP
;	rtl
;generateexplodeRND31_l
;
;
;	shorta
;	longi
;
;	PUSHXYP
;
;	a8i16
;	jsl		generateexplode_plr_l
;	rlbcc		.exit
;	s_add_rnd2pos	y,31,31,31,0,0,1
;
;.exit
;	PULLXYP
;	rtl

;generateexplode_plr_l
;
;	phx
;	php
;
;	a8i16
;	s_make_obj	#explosion,generateexplode2_l.badobj
;	jsr		explode_init_srou
;	s_set_lifecnt	y,#4
;	s_sprite_obj	y,#0,#-1
;	kplsound	x,pl_explode_s
;
;	jmp		generateexplode2_l.enter2

;generateexplode_l
;
;	phx
;	php
;
;	a8i16
;	s_make_obj	#explosion,generateexplode2_l.badobj
;	jsr		explode_init_srou
;	s_set_lifecnt	y,#4
;	s_sprite_obj	y,#0,#-1
;	jmp		generateexplode2_l.enter
;
;generateexplode2_l
;
;	phx
;	php
;
;	a8i16
;	s_make_obj	#explosion5,.badobj
;	jsr		explode_init_srou
;	s_set_lifecnt	y,#8
;	s_sprite_obj	y,#0,#0
;
;
;.enter	LOCAL
;	s_exg_objs
;	jsl		explode_sound_plr1_l
;	s_exg_objs
;
;.enter2	LOCAL
;	s_set_expstrat	y,.strat
;	s_clr_alsflag	y,realobj
;	plp
;	sec
;;	ply
;	plx
;	rtl
;
;
;.badobj	LOCAL
;
;
;.exit	plp
;	clc
;;	ply
;	plx
;	rtl
;
;
;.strat	s_start_strat
;	s_add_vecs2pos		x
;	s_decbne_lifecnt	x,.end
;	bra	.remove
;.end
;	s_add_colanim		x,#1,#8
;	s_end_strat
;
;.remove	jml	explode_istrat
;
;-----------------------------------------------------------------------------


Eweap_init

weapon_srous
	s_start_strat
;.genY3dvecs	LOCAL
;	s_exg_objs
;	jsr	.gen3dvecs
;	s_exg_objs
;	rts
;.gen3dvecs	LOCAL
;	s_gen_3dvecs	x,al_roty,al_rotx,al_vel
;	rts
;
;.Einit_spriteweap	LOCAL
;	s_sprite_obj	y,#0,#Eweap_size
;.Einit_laser		LOCAL	; enemy weapon init
;	s_set_colltype	y,LASER
;	s_clr_alsflag	y,shadow
;ÍÍÍÍÍÍÍÍÍÍÍÍ
; karauchi check

	s_push_obj	x
	ldx	playpt1
	lda	al_roty,x
	s_pull_obj	x

	clc
	adc	#deg180

	sec
	sbc.w	al_roty,y
	clc
	adc	#karauchiang
	cmp	#karauchiang*2
	bcc	.notkara1

	s_set_var2rnd	tpx,#3

	lda		tpx
	beq		.notkara
	s_set_alsflag	y,colldisable
	inc	testx
.notkara
	inc	testy
.notkara1

	s_set_colltype	y,ENEMYWEAP
	s_set_colltype	y,ENEMY1

	rts





;.Pinit_laser		LOCAL	; player's werpon init
	;s_set_colltype		y,LASER
	;s_set_alsflag		y,dontexplode
;	bra	.Pim_enter
;.Pinit_missile	LOCAL
;	s_set_alsflag		y,shadow
;.Pim_enter
;	s_set_colltype		y,FRIEND
;	pl_set_area		y,-1
;	s_set_alsflag		y,notslope
;	pl_copy_alsflag		y,x,player2
;	s_set_alsflag		y,noviewcheck
;
;	s_copy_alvar2alvar	B,y,al_vel,x,al_vel
;	s_sub_alvar		B,y,al_vel,#2
;	s_set_alvartobeobj	y,al_ptr,x	; player obj
;	s_clr_alsflag		y,realobj
;
; tell weapon which player(0: player1   1: palyer2)
;
;	s_jmpnot_alsflag	x,player2,.pp
;.p2	s_set_alsflag		y,sflag10
;.pp
;	rts
;

;-----------------------------------------------------------------------------
;explode_init_srou
;
;	s_start_strat
;	s_set_alsflag	y,notslope
;	s_set_alsflag	y,colldisable
;	s_set_alsflag	y,dontexplode
;	s_clr_alsflag	y,realobj
;	s_set_alvartobeobj	y,al_ptr,x
;	s_init_colanim	y,#0
;	s_set_aldata	y,#0,#0
;	s_copy_pos	y,x
;	s_copy_rots	y,x
;	s_copy_vecs	y,x
;	rts
;
;-----------------------------------------------------------------------------

;if hit anything C=on else C=off

hitsomething_srou_l

	s_start_strat

	phx
	phy

	s_jmp_alsflag		x,collide,.hitc
	s_jmp_alsflag		x,Lcollide,.hitc

.slope

	pl_test_planetmode	space
	beq			.nohitg


	a16
	lda	al_worldy,x
	clc
	adc	#20
	a8
	rlbpl	.hitg



.nohitg

;------------ check slope


	lda	al_slopenum,x
	pha

	jsl	getheight_l

	pla
	sta	al_slopenum,x

	ldy	al_slopeptr,x
	beq	.nothit

	s_jmp_alvarLESS	W,x,al_worldy,y1,.nothit

.cntck
;------------
	s_jmpnot_colltype	x,FRIEND,.ckpathobj
	s_jmpnot_colltype	x,LASER,.ckpathobj

	s_jmp_alsflag		x,sflag10,.hitbyp2
.hitbyp1	s_set_alsflag		y,hitbyplayer1
	bra			.ckpathobj
.hitbyp2	s_set_alsflag		y,hitbyplayer2

.ckpathobj	s_jmpnot_alsflag	y,pathobj,.hitc
	s_set_alsflag		y,sflag7
	bra			.hits


.nothit	ply
	plx
	clc
	rtl


.hits	; hit slope

	ldy	al_slopeptr,x
	sty	y1
	bra	.hitexit

.hitc	; hit object
	ldy	al_hitlist,x
	a16
	lda.w	hl_alptr,y
	sta	y1
	a8
	phy
	ldy	y1
	stz	hit_noaffect_chk
	test_alsflag	y,nohitaffect
	beq	.no1
	lda	#1
	sta	hit_noaffect_chk
.no1	ply
	bra	.hitexit

.hitg	s_set_var	W,y1,#0


.hitexit	ply
	plx
	sec
	rtl


;-----------------------------------------------------------------------------
;weap_remove
;	s_start_strat
;;;;;;;;	s_set_alsflag	x,colldisable
;	s_remove_obj	x
;	s_end_strat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-----------------------------------------------------------------------------
;	SOUND ROUTINE
;-----------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

hitsomething_snd_srou_l


;out	C=1 hit!
;	A = 1: damaged   0:rebounded
;	x1(byte1): sound type
;		0:normal
;		1:seibutsu(small)
;		2:seibutsu(large)
;		3:dragon


	s_start_strat

	jsl	hitsomething_srou_l
	bcs	.hit

	stz	x1

	clc
	rtl



.hit	PUSHXYP

	stz	x1+1
	stz	x1

	s_jmp_varZERO	W,y1,.ground

	ldy		y1

; already dead?

	cpy	playpt1
	rlbeq	.hitexit
	cpy	playpt2
	rlbeq	.hitexit

	s_jmp_alvarZERO	B,y,al_HP,.hitexit

	s_jmp_alsflag	y,nohitaffect,.rebound

; resource "enemySEtype" = SE type

	PHY
	s_get_resource	B,y,A,enemySEtype,.damage
	sta	x1
.damage	PLY

	lda	#1
	bra	.hitexit

.rebound	PHY
	s_get_resource	B,y,A,enemyRBDSEtype,.rbd
	sta	x1

.rbd	PLY
	lda	#2
	bra	.hitexit

.ground	lda	#0

.hitexit	PULLXYP

	sec
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	set speed & generate vector
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
weap_set_speed

	s_start_strat

; idY : weapon pointer
; tpx	: speed (player = arwing)
; tpy	: speed (player = robot)


	s_push_obj	y

	ldy	playpt1
	sp_jmpnot_playertype	y,ARWING,.rb

.aw	lda	tpx	;#{name}VELaw
	bra	.pp
.rb	lda	tpy	;#{name}VELrb
.pp	s_pull_obj	y

	sta.w	al_vel,y

	s_exg_objs
	s_gen_3dvecs	x,al_roty,al_rotx,al_vel
	s_exg_objs

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	generate weapon
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

genweap_srou
	s_start_strat

	a16
	lda	allst
	pha
	a8
	stx	allst

	s_make_obj	#nullshape,.badobj

	a16
	pla
	sta	allst
	a8

	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
	s_set_aldata	y,#1,#1
	jsl		gen_weapon_l
	s_set_alsflag	y,realobj	; test
	s_set_alsflag	y,notslope
	s_set_alsflag	y,dontexplode

	s_set_alcollflag	y,WEAPON
	s_init_anim		y,#0
	s_set_alsflag		y,noviewcheck
	s_set_alptrs		y,path_istrat,hit_istrat,explode_istrat

	sec
	rts

.badobj
	a16
	pla
	sta	allst
	a8

	clc
	rts





	IFEQ	1
genweap_srou	s_start_strat
	s_make_obj	#nullshape,.badobj
	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
	s_set_aldata	y,#1,#1
	jsl		gen_weapon_l
	s_set_alsflag	y,realobj	; test
	s_set_alsflag	y,notslope
	s_set_alsflag	y,dontexplode
	s_set_alcollflag	y,WEAPON
	s_init_anim		y,#0
	s_set_alsflag		y,noviewcheck
	s_set_alptrs		y,path_istrat,hit_istrat,explode_istrat
	sec
	rts
.badobj	clc
	rts
	ENDC




genPweap_srou

	s_start_strat

	jsr		genweap_srou

	bcc		.badobj

;	s_make_obj	#nullshape,.badobj
;	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
;	s_set_aldata	y,#1,#1
;	jsl		gen_weapon_l
;	s_clr_alsflag	y,realobj
;	s_set_alsflag	y,notslope
;	s_set_alsflag	y,dontexplode
;
;	s_set_alcollflag	y,WEAPON
;	s_init_anim		y,#0
;	s_set_alsflag		y,noviewcheck
;	s_set_alptrs		y,path_istrat,hit_istrat,explode_istrat


	pl_set_area	y,-1
	s_set_colltype		y,FRIEND
	s_set_alvartobeobj	y,al_ptr,x	; player pointer

	s_jmpnot_alsflag	x,player2,.pp
.p2	s_set_alsflag		y,sflag10
.pp

	sec
	rts

.badobj	clc
	rts



weap_badobj	rtl




; set weapon's shape to "resource"

Pweapshape_srou

;	idy : weapon's pointer

	s_start_strat

	PUSHXYP

	a16
	lda.w	al_shape,y
	sta	x1
	a8

	s_set_resource	W,y,Pweapshape,x1

	PULLXYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	END of FILE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	END
