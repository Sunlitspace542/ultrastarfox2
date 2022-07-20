;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                                                                    ³
;³                 STARFOX II - REVENGE OF PEPPY -                    ³
;³                                                                    ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³                                                                    ³
;³ FILE:          VIEWS.ASM                                           ³
;³ AUTHOR:       Takumi Kawagoe                                       ³
;³ DESCRIPTION:  The Camera's strategy                                ³
;³ DATE CREATED: 16-2-93                                              ³
;³                                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	INCPUB	views

no_VIEW	equ	0	; dummy

;work0	equ	twork+0
;work1	equ	twork+2
;work2	equ	twork+4
;work3	equ	twork+6
;work4	equ	twork+8
;work5	equ	twork+10
;work6	equ	twork+12
;work7	equ	twork+14
;work8	equ	twork+16
;work9	equ	twork+18
;work10	equ	twork+20
;work11	equ	twork+22
;work12	equ	twork+24
;work13	equ	twork+26
;work14	equ	twork+28
;work15	equ	twork+30


;X1c	equ	twork+26	;16bit
;Y1c	equ	twork+28	;16bit
;Z1c	equ	twork+30	;16bit

	SHORTA
	LONGI

MAIN_VIEWBRANCH_L	; in	: idX = player's pointer
		;	: exal_viewptr = pointer

	PUSHYP

	a8i16

	km_jmpgameflag	freeze,.freeze

	lda	demomode
	bne	.demo

.start	ai16

	toheap	y,x

	lda	exal_viewstratptr+0,y
	beq	.return

	lda	#.return&0ffffH
	dec	a
	pha
	a8
	lda	exal_viewstratptr+2,y
	pha
	a16
	lda	exal_viewstratptr+0,y
	dec	a
	pha
	a8
	rtl


.freeze

	jsr	copy_viewrot_freeze

.return

	PULLYP
	rtl



.demo	jsr	copy_viewrot_freeze
	jsl	demoview_srou_l

	PULLYP
	rtl


;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
; Calculates the player's view position                             ;  
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

	SHORTA
	LONGI

ONFIELD_ARWING_VIEW

	php
	a8i16

	toheap	y,x

	pl_jmpnot_ifcaminthesea	x,.on

.off	c_vofsoff		x
	bra	.exitvofs
.on	c_vofson		x
.exitvofs
	jsr	ARWING_CAMERA
	jsl	camrotX_shock_l
	jsr	copy_viewrot
	jsr	copy_viewpos
	jsl	VIEW_CHANGE_l
	jsl	set_hscroll_offset_l
	jsl	demoview_srou_l

	plp
	rts


COSMO_ARWING_VIEW

	php
	a8i16

	c_vofson	x

.nokamitsuki

	jsr	ARWING_CAMERA
	jsl	camrotX_shock_l
	jsr	copy_viewrot
	jsr	copy_viewpos
	jsl	VIEW_CHANGE_l

	jsl	set_hscroll_offset_l
	jsl	set_vscroll_offset_l

.exit
	jsl	demoview_srou_l

	plp
	rts
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;DEMO                                                         ³
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;DEMO_AWDEAD_0_0_VIEW
;
;	php
;	a8i16
;
;	c_vofson	x
;
;	jsl	Arwing0_horizon_l
;	jsr	DEMO_AWDEAD_0_0_camera
;	jsr	copy_viewrot
;	jsr	copy_viewpos
;	jsl	VIEW_CHANGE_l
;
;	plp
;	rts
;


;DEMO_BATTLESTART_0_0_VIEW
;
;	php
;	a8i16
;
;	c_vofson	x
;
;	jsl	Arwing0_horizon_l
;	jsr	DEMO_BATTLESTART_0_0_camera
;	jsr	copy_viewrot
;	jsr	copy_viewpos
;;	jsl	VIEW_CHANGE_l
;
;	plp
;	rts



;TEST_DUEL_VIEW
;
;	php
;	a8i16
;
;	c_vofson	x
;
;	jsl	Arwing0_horizon_l
;	jsr	DEMO_BOSS_camera
;	jsr	copy_viewrot
;	jsr	copy_viewpos
;;	jsl	Arwing0_horizon_l
;
;;	s_jmpNOT_varAND		B,BOSSstatus,#BOSSstatus_demoend,.exit
;;	c_set_viewstrat		x,SPIN_ARWING
;
;.exit
;	plp
;	rts


;LOOK_P1
;
;	c_vofson	x
;
;	pl_ldy_viewblk	x
;
;	phx
;
;	s_set_objtobeplayer1	x
;	s_set_alvar		W,y,al_rotx,#-20
;	s_set_alvar		W,y,al_roty,#0
;	s_set_alvar		W,y,al_rotz,#0
;	s_add_roffs2pos		B,y,x,y,#-3,#-12,#-25,1,1,0,2,2,2
;	jmp			.exit
;
;.exit	plx
;
;	s_set_alvar		W,y,al_sword1,#0
;
;	jsl	Arwing0_horizon_l
;	plp
;	rts





	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C3Dview
	phx
	pl_ldy_viewblk		x
	s_jmpNOT_alsflag		x,player2,.p1
.p2	s_set_alvar	W,y,al_rotx,#0
	s_set_alvar	W,y,al_roty,#80H
	s_set_alvar	W,y,al_rotz,#0
	PHX
	s_set_objtobeplayer1	x
	c_add_roffs2pos16	W,y,x,y,#-3,#-30,#-150,1,1,0	;,2,2,2
	PLX
	bra			.pp
.p1	PHX
	ldx			#viewblk2
	s_copy_pos		y,x
	s_set_alvar	W,y,al_rotx,#0
	s_set_alvar	W,y,al_roty,#-80H
	s_set_alvar	W,y,al_rotz,#0
	s_add_alvar		W,y,al_worldx,#3
;	s_set_objtobeplayer2	x
;	c_add_roffs2pos16	W,y,x,y,#3,#-30,#-150,1,1,0	;,2,2,2
	PLX
.pp	pl_ldy_viewblk	x
;	PHY
;**************************************************
;
;	s_set_objtobeplayer1	x
;	ldy		dummyobj
;	s_copy_pos	y,x
;
;	PLY
;
;	s_exg_objs
;
;	s_obj2obj_3dangle	x,y,al_roty,al_rotx,0
;
;	a16
;	lda		al_roty,x
;	xba
;	and		#0ff00H
;	nega
;	sta		al_roty,x
;	a8
;
;**************************************************
;	s_pull_obj	x
	plx
	plp
	rts
	s_set_var	B,work0,#0
	s_jmpNOT_alsflag	x,player2,.ppp
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	testjoypad	X,pcont
	beq		.noX
	s_Fchase_var	B,LOOKdis,#127,1
.noX	testjoypad	B,pcont
	beq		.noB
	s_Fchase_var	B,LOOKdis,#0,1
.noB	lda		LOOKdis
;	printb	1,2
	testjoypad	tleft,pcont
	beq		.noL
	s_Fchase_var	B,EYEdis,#100,1
.noL	testjoypad	tright,pcont
	beq		.noR
	s_Fchase_var	B,EYEdis,#0,1
.noR	s_set_var	B,EYEdis,#0
	lda		EYEdis
;	printb	1,3
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	s_set_var	B,work0,#80H
.ppp	pl_ldy_viewblk	x
	s_push_obj	x
	s_set_objtobeplayer2	x
	s_copy_pos	y,x
;;**************************************************
	s_push_obj	x
	s_push_obj	y
	ldy		dummyobj
	s_copy_pos	y,x
	s_copy_rots	y,x
;	s_add_roffs2pos	B,y,x,x,#0,#0,LOOKdis,1,1,0,1,1,1
	s_add_roffs2pos	B,y,x,x,#0,#0,#100,1,1,0,1,1,1
	s_pull_obj	y
	s_pull_obj	x
;**************************************************
;**************************************************
	s_set_alvar	B,y,al_rotx,#0
	s_set_alvar	B,y,al_roty,#0
	s_set_alvar	W,y,al_rotz,#0
	s_copy_alvar2alvar	B,y,al_rotx+1,x,al_rotx
	s_copy_alvar2alvar	B,y,al_roty+1,x,al_roty
	s_neg_alvar		W,y,al_rotx
	s_neg_alvar		W,y,al_roty
	s_jmp_varZERO	B,work0,.lll2
.lll1
;	s_copy_var2var	B,work1,EYEdis
;	s_neg_var	B,work1
	a16
	lda		EYEdis
	and	#0ffH
	nega
	sta	work1
	A8
;	c_add_roffs2pos16	W,y,x,x,work1,#-30,#-150,1,1,0	;,2,2,2
	c_add_roffs2pos16	W,y,x,x,#-3,#-30,#-150,1,1,0	;,2,2,2
	jmp	.kkk
.lll2
;	s_copy_var2var	B,work1,EYEdis
	a16
	lda		EYEdis
	and	#0ffH
	sta	work1
	A8
;	c_add_roffs2pos16	W,y,x,x,work1,#-30,#-150,1,1,0	;,2,2,2
	c_add_roffs2pos16	W,y,x,x,#3,#-30,#-150,1,1,0	;,2,2,2
.kkk
;**************************************************
	s_push_obj	x
	s_push_obj	y
	tyx
	ldy		dummyobj
	s_obj2obj_3dangle	x,y,al_roty,al_rotx,0
	a16
	lda		al_roty,x
	xba
	and		#0ff00H
	nega
	sta		al_roty,x
	a8
	s_pull_obj	y
	s_pull_obj	x
;**************************************************
	s_pull_obj	x
	plp
	rts
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;-------------------------------------------------------------------
;-------------------------------------------------------------------
	SHORTA
	LONGI

ONFIELD_ROBO_VIEW

	php

	a8i16

	pl_jmpnot_ifinthesea	x,.on

.off	c_vofsoff	x
	bra	.exitvofs
.on	c_vofson	x
.exitvofs

	jsl	VIEW_CHANGE_l

	jsr	ROBOT_CAMERA
	jsl	camrotX_shock_l
;----------------------------------------------------------------

bcs_counter	equ	work9
bcs_x	equ	work8
bcs_z	equ	work7

	PHX	;--->>>

	toheap	y,x

	pl_jmp_ifblockoff	x,.inn,y

	pl_ldx_viewblk	x

	s_jmp_ifsolid	x,.inn

.out	lda	exal_VIEWflag,y
	ora	#exal_VIEWflag_blockout
	bra	.sta

.inn	lda	exal_VIEWflag,y
	and	#~exal_VIEWflag_blockout
.sta	sta	exal_VIEWflag,y

	PLX	;<<<---

;----------------------------------------------------------------

	jsr	copy_viewrot
	jsr	copy_viewpos
	jsl	demoview_srou_l

	plp
	rts

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
; TEST VIEW
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	SHORTA
	LONGI
testview_l	phx
	phy
	php
	a8
	lda.l	seavscroll_buf+0
;	printh	data1_0,kawagoe
	a16
	lda.l	seavscroll_buf+1
;	printh	data1_1,kawagoe
	a8
	lda.l	seavscroll_buf+3
;	printh	data2_0,kawagoe
	a16
	lda.l	seavscroll_buf+4
;	printh	data2_1,kawagoe
	a8
	lda.l	seavscroll_buf+6
;	printh	data3_0,kawagoe
	a16
	lda.l	seavscroll_buf+7
;	printh	data3_1,kawagoe
	a8
	lda.l	seavscroll_buf+9
;	printh	data4_0,kawagoe
	a16
	lda.l	seavscroll_buf+10
;	printh	data4_1,kawagoe
	a8
	a8
	lda.l	seavscroll_buf+12
;	printh	data5_0,kawagoe
	a8
	lda.l	seavscroll_buf+15
;	printh	data6_0,kawagoe
	a8
	lda.l	seavscroll_buf+18
;	printh	enddata_0,kawagoe
	c_vofsoff	x
	pl_ldy_viewblk	x
.up	testjoypad	up,pcont
	beq		.dw
	s_sub_alvar	B,y,al_rotx+1,#3
.dw	testjoypad	down,pcont
	beq		.left
	s_add_alvar	B,y,al_rotx+1,#3
.left	testjoypad	left,pcont
	beq		.right
	s_sub_alvar	B,y,al_roty+1,#3
.right	testjoypad	right,pcont
	beq		.noudlr
	s_add_alvar	B,y,al_roty+1,#3
.noudlr	s_set_alvar	B,y,al_vel,#0
.x	testjoypad	x,pcont
	beq		.b
	s_add_alvar	W,y,al_worldy,#-20
	bra		.setvec
.b	testjoypad	b,pcont
	beq		.y
	s_add_alvar	W,y,al_worldy,#20
	bra		.setvec
.y	testjoypad	y,pcont
	beq		.a
	s_set_alvar	B,y,al_vel,#20
	bra		.setvec
.a	testjoypad	a,pcont
	beq		.setvec
	s_set_alvar	B,y,al_vel,#-20
.setvec	phx
	tyx
	s_copy_alvar2alvar	B,x,al_rotx,x,al_rotx+1
	s_copy_alvar2alvar	B,x,al_roty,x,al_roty+1
	s_copy_alvar2alvar	B,x,al_rotz,x,al_rotz+1
	s_neg_alvar	B,y,al_rotx
	s_neg_alvar	B,y,al_roty
	s_neg_alvar	B,y,al_rotz
	s_gen_3Dvecs	x,al_roty,al_rotx,al_vel
	s_add_vecs2pos	x
	s_set_alvar	B,y,al_rotx,#0
	s_set_alvar	B,y,al_rotx,#0
	s_set_alvar	B,y,al_rotx,#0
	plx
	plp
	ply
	plx
	rtl
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
; Calculates the player's view position                             ;  
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
	SHORTA
	LONGI

ROBOT_CAMERA

	s_start_strat

	PUSHXYP

	a8i16

	toheap	y,x

;-------------------------------------------------------------------------
; -- copy rot x,y,z into view --

	s_push_obj		y
; - rotx -

; - roty -
	s_copy_alvar2var	W,y,work0,exal_roty
	s_neg_var		W,work0
	s_set_alvar		W,y,exal_camroty,work0
	s_sub_alvars		W,y,exal_camroty,y,exal_camrotyofs
	s_Fchase_alvar		W,y,exal_camrotyofs,#0,100H

; noturn mode no offset(arwing de tsukau)

	s_achase_alvar		W,y,exal_camrotyofsNT,#0,3

; - rotz -
	s_achase_alvar		W,y,exal_camrotz,#0,1
	s_pull_obj		y

;-------------------------------------------------------------------------
; -- copy world x,y,z into view --

	a16
	lda	exal_worldx,y
	sta	X1c
	lda	exal_worldy,y
	sta	Y1c
	lda	exal_worldz,y
	sta	Z1c
	lda	#0
	sta	work1
	a8

	jsr	set_camera_worldz_offset
	jsr	set_camera_worldx_offset

	a16
	lda	X1c
	sta	exal_camworldx,y
	lda	Z1c
	sta	exal_camworldz,y
	a8


	jsr	set_camera_worldy_offset5

.exit

	PULLXYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

RB_CAMROTX_l		; set camera rotation x

	s_start_strat

	PUSHYP

	a8i16

	toheap		y,x

;-----------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ trans falling & rising ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	s_set_var	W,work0,#0

	pl_jmp_iftransrising	x,.transrise_w,y
	pl_jmp_iftransfalling_w	x,.transfall_w,y
	pl_jmp_iftransfalling_g	x,.fallrx,y
	pl_jmp_iftransfalling	x,.fallrx,y
	pl_jmpnot_iftransrising	x,.crxground,y

.riserx	a16

	lda	#-transfall_y
	clc
	adc	SEADEPTH
	sec
	sbc	al_worldy,x
	php
	sta	tpy

	plp
	a8
	rlbmi	.look
	a16
	lda	tpy
	sta	work0
	a8
	jmp	.look


.fallrx	a16
	lda	#transfall_y
	clc
	adc	SEADEPTH
	sec
	sbc	al_worldy,x
	clc
	adc	exal_camlookyofs,y

	php
	sta	tpy
	plp
	a8
	rlbpl	.look
	a16
	lda	tpy
	sta	work0
	a8
	jmp	.look



.transfall_w
.transrise_w

	s_set_alvar	W,y,exal_camrotxofs,#0
	s_set_alvar	W,y,exal_camrotx,#0

	jmp		.crxexit

;-----------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ set "look y offset" ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.crxground
	s_set_var	W,work1,#3	; Yofs chase rate

	a16
	lda	#RBcameralookYofs_no
	sta	work0
	a8

;-----------------------------------------------------------------------------
; BOSS mode tokade,path kara Y offset wo set sitatoki....
	s_varadd_alvar	W,y,work0,exal_camlookyofs_ext
;-----------------------------------------------------------------------------

.Fc	sm_Fchase_alvar	W,y,exal_camlookYofs,work0,work1	;5
	bra			.setYofs
.nopushX	s_and_alvar		B,y,exal_VIEWflag,#~(exal_VIEWflag_RBpushX!exal_VIEWflag_RBtrigX)
.setYofs	s_copy_alvar2var	W,y,work0,exal_camlookYofs
	s_varsub_alvar		W,y,work0,exal_camYofs_normal
	s_set_var		W,work1,#100

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ calc angle  camera --> point ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.look

;****TEST
	sp_jmp_playertype	x,ARWING,.notmarine,y
	pl_jmpnot_ifinthesea	x,.notmarine

	a16
	lda	exal_camworldy,y
	sec
	sbc	exal_bodyworldy,y
	bmi	.notaddmarine
	clc
	adc	work0
	sta	work0

.notaddmarine
	a8
.notmarine
;****cockpit?
	sp_jmpNOT_ifcockpit	x,.nocock

	a16
	lda	work0
	clc
	adc	#-15	;#RB0camYofs_cockpit
	sta	work0
	a8
	bra	.calc
;*****room?
.nocock
;*****

.calc	c_calc_lookangle	W,x,work0,work1,#0,work0,#100

.max	lda		work0+1
	bmi		.min
	cmp		#onfield_RBCAMmaxrotX
	bmi		.crx
	lda		#onfield_RBCAMmaxrotX
	bra		.rcrx
.min	cmp		#-onfield_RBCAMmaxrotX
	bpl		.crx
	lda		#-onfield_RBCAMmaxrotX
.rcrx	sta		work0+1

.crx

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	pl_test_planetmode	marine
	bne			.ground
	pl_jmpnot_ifonthe	x,water,.ground
;-----------------------------------------------------------------------------
.marine
	a8
	pl_jmpnot_iftransfalling	x,.inmarine
	s_jmp_varPL	W,work0,.walkshake
.inmarine	s_achase_alvar	W,y,exal_camrotx,work0,1
	bra		.walkshake

;-----------------------------------------------------------------------------
.ground
	pl_jmp_iffloating	x,.skip6,y
	pl_jmpNOT_ifjmp		x,.skip6

	a16
	lda.w	exal_camworldy,y
	sec
	sbc	al_worldy,x
	bra	.walkshake

.skip6	a8
	s_achase_alvar	W,y,exal_camrotx,work0,1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- walk --
.walkshake	a8


	pl_jmp_ASHIinpool	x,.jjjj

	pl_jmpNOT_ifjmp		x,.do2

.jjjj	s_set_var	W,work0,#0


	bra		.addws

.do2	phx

	lda		#0
	xba

	lda		al_animframe,x
	and		#127
	tax

	lda.l	.data,x

	plx
	sta	work0
	lda	#0
	sta	work0+1


	s_copy_alvar2var	W,y,work1,exal_camRotXofs

	s_achase_var		W,work0,work1,3

.addws

	s_set_alvar	W,y,exal_camRotXofs,work0
	s_add_alvars	W,y,exal_camrotx,y,exal_camRotXofs

.crxexit

;**************************************************************************************
;	toheap	y,x
;
;	pl_jmp_ifinthesea		x,.LINETEST
;
;	pl_jmpnot_iftransfalling	x,.NOLINE
;	pl_jmpnot_ifonthe		x,water,.NOLINE
;
;.LINETEST
;	s_set_alvar	W,y,exal_camrotx,#0
;.NOLINE
;**************************************************************************************


	PULLYP


	rtl

.data
	DB	80H
	DB	80H
	DB	0
	DB	0

	DB	0
	DB	0
	DB	80H
	DB	80H

	DB	80H
	DB	80H
	DB	0
	DB	0

	DB	0
	DB	0
	DB	80H
	DB	80H




;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;            ---- COSMO MODE ----                                   ;
; Calculates the Arwing's camera position                           ;  
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

ARWING_CAMERA

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- copy x,y,z into view --

	a16
	lda	al_worldx,x
	sta	X1c
	lda	al_worldy,x
	sta	Y1c
	lda	al_worldz,x
	sta	Z1c
	a8

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- set camera view offset Y1c --

; ARWING & ARMER

	jsr	set_camera_worldy_offset4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- set camera view offset Y1c --

	jsr	set_camera_worldz_offset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- set camera view offset Y1c --

	jsr	set_camera_worldx_offset
.endxofs
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;--------------------------------------------------------------------------------
.nolimitY

;	s_copy_alvar2var	W,y,work4,exal_worldyoffset ; (=shake)
;	s_add_var		W,Y1c,work4
;	s_set_alvar		W,y,exal_camworldx,X1c
;	s_set_alvar		W,y,exal_camworldy,Y1c
;	s_set_alvar		W,y,exal_camworldz,Z1c


	a16

	lda	Y1c
	clc
	adc	exal_worldyoffset,y
	sta	Y1c
	sta	exal_camworldy,y

	lda	X1c
	sta	exal_camworldx,y
	lda	Z1c
	sta	exal_camworldz,y
	a8

;--------------------------------------------------------------------------------

	jsr	cam_boost_zofs_srou

;--------------------------------------------------------------------------------
.camrot

;-- camera rotx ---

	sp_jmp_playertype	x,ufo,.armercamrotx,y

.arwingcamrotx

.cosmo	jsr	CS_CAMROTX
	bra	.nocamrotx

.armercamrotx

	jsl	RB_CAMROTX_l

.nocamrotx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-- camera roty ---

	pl_jmp_ifturn	x,.crotynormal

;-----------------------------------------------------------------------------
;[1 tunnel mode]

	s_set_var	W,work0,#0

	sp_jmpnot_ifcockpit	x,.notcock,y
	s_jmp_ABSalvarless	W,y,exal_rotyoffset,#16*256,.notrot

	a16
	lda	exal_rotyoffset,y
	asra
	asra
	jmp	.setyofs2



.notcock	SHORTA
	pl_jmp_ifturn	x,.SF2,y

.SF1	a16
	lda	#camerax_offset_SF1-10
	bra	.setofs

.SF2	a16
	lda	#camerax_offset_SF2-10

.setofs	sta	x1
	nega
	sta	x2

	lda	exal_camXofs,y
	bmi	.tlmi
.tlpl	cmp	x1	;#cameraX_offset
	bcc	.notrot
	a8
	testjoypad	left,pcont
	beq		.notrot
	bra	.setyofs

.tlmi	LONGA
	cmp	x2	;#-cameraX_offset
	bcs	.notrot
	a8
	testjoypad	right,pcont
	beq		.notrot

.setyofs	a16
	lda	exal_rotyoffset,y
	asra
	asra
	sta	tpy
	asra
	clc
	adc	tpy
.setyofs2	nega
	sta	work0

.notrot
	a8


	s_Fchase_alvar		W,y,exal_camrotyofsNT,work0,100H


	bra	.cryn

;-----------------------------------------------------------------------------
;[2 normal mode]
.crotynormal

	s_achase_alvar	W,y,exal_camrotyofsNT,#0,3

.cryn	a16
	lda	exal_roty,y
	nega
	sta	work0
	a8

	s_set_alvar		W,y,exal_camroty,work0

	a16
	lda			work0
	sec
	sbc			exal_camroty,y
	sta			exal_camrotyofs,y
	a8

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-- camera rotz ---

; transform no toki rotz ha 0 ni suru.

	pl_jmpnot_iftransform	x,.normalrotz
.camrotzoff	a16
	lda			exal_camrotz,y
	adiv2
	sta			exal_camrotz,y
	a8

	jmp			.nocamrotz


.normalrotz
;	sp_jmp_playertype	x,ufo,.armercamrotz

.arwingcamrotz

	s_copy_alvar2var	B,y,work0+1,exal_inccamrotz
	s_set_var		B,work0+0,#0
	s_Fchase_alvar		W,y,exal_camrotz,work0,100H
	bra			.nocamrotz

.armercamrotz

;	s_copy_alvar2var	B,x,work0+1,exal_inccamrotz
;	s_set_var		B,work0+0,#0
;	s_set_var		B,work0+1,#0
;	s_Fchase_alvar		W,x,exal_inccamrotz,work0,100H
;	s_achase_alvar		W,x,exal_camrotz,#0,3

.nocamrotz
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- clamp pros.(tunnel mode) TESTING.... --

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	s_jmp_varNE	B,playerctlmode,#map_room,.noclamp
	jsr		copyviewpos2dummy
	s_push_obj	x
	ldx		dummyobj
	jsl		getheight_l
	s_jmp_alvarless	W,y,exal_camworldy,y1,.nc0
	s_jmp_alvarNE	B,x,al_slopetype,#st_wall,.nc0
	jsl		clamptoside_l
	bra		.addclamp
.nc0	a16
	lda	#0
	sta	x1
	sta	z1
	a8
.addclamp	s_pull_obj	x
	s_achase_alvar	W,y,exal_clampcamx,x1,3
	s_achase_alvar	W,y,exal_clampcamz,z1,3
	a16
	lda	exal_camworldx,y
	clc
	adc	exal_clampcamx,y
	sta	exal_camworldx,y
	lda	exal_camworldz,y
	clc
	adc	exal_clampcamz,y
	sta	exal_camworldz,y
	a8
.noclamp
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.exit	PULLYP
	rts


;------------------------------------------------------------------------------
; 	calcurate camera rotationXYZ

	SHORTA
	LONGI	

;	work0:work RAM

CS_CAMROTX

; --- set rotation X ---

	phx
	phy
	php

	a8i16

	toheap	y,x

	sp_jmp_ifcockpit	x,.cockpit,y

;--------------------------------------------------------------
; --[normal mode]--

	s_set_var	W,work0,#0
	s_set_alvar	W,y,exal_acclcamrotX,#0


; check alt limit



.top	pl_jmpNOT_ifaltLMT	x,top,.btm
	lda	exal_camupdw,y
	bit	#exal_camupdw_up
	beq	.tbout
	lda	exal_maxCrotX,y
	asra
	sta	work0+1
	bra	.dwac



.btm	s_jmp_alvarAND	B,y,exal_camupdw,#exal_camupdw_dwG,.tbout

	pl_jmpNOT_ifaltLMT	x,bottom,.tbout
	lda	exal_camupdw,y
	bit	#exal_camupdw_dw
	beq	.tbout
	lda	exal_minCrotX,y
	asra
	sta	work0+1
	bra	.upac
.tbout


.up

	lda	exal_camupdw,y
	and	#exal_camupdw_dwL!exal_camupdw_dw
	cmp	#exal_camupdw_dwL!exal_camupdw_dw
	bne	.dw


	s_copy_alvar2var	B,y,work0+1,exal_minCrotX


.upac
	s_set_alvar		W,y,exal_acclcamrotX,#-1c0H
	jmp			.ac

.dw

	lda	exal_camupdw,y
	and	#exal_camupdw_upH!exal_camupdw_up
	cmp	#exal_camupdw_upH!exal_camupdw_up
	bne	.cknk

	s_copy_alvar2var	B,y,work0+1,exal_maxCrotX


.dwac
	s_set_alvar		W,y,exal_acclcamrotX,#1c0H
	jmp			.ac


.cknk
	lda	exal_camupdw,y
	bit	#exal_camupdw_up
	bne	.nkup
	bit	#exal_camupdw_dw
	rlbeq	.nk

.nkdw	s_set_alvar		W,y,exal_acclcamrotX,#-80H
	bra			.nkf
.nkup	s_set_alvar		W,y,exal_acclcamrotX,#80H

.nkf

	s_achase_alvar		W,y,exal_camrotX,#0,3

	jmp			.exit_ccr

;--------------------------------------------------------------
; --[cockpit mode]--

.cockpit	s_set_var		W,work0,#0
	testjoypad		up,pcont
	bne			.cup
	testjoypad		down,pcont
	bne			.cdw
	s_set_var		W,x1,#0
	jmp			.nk

.cup	s_set_var		W,x1,#-200H
	s_set_var		W,work0,#0
	s_copy_alvar2var	B,y,work0+1,exal_minCrotX
	pl_jmp_ifaltLMT		x,bottom,.cudH
	bra			.cudF

.cdw	s_set_var		W,x1,#200H
	s_set_var		W,work0,#0
	s_copy_alvar2var	B,y,work0+1,exal_maxCrotX
	pl_jmpNOT_ifaltLMT	x,top,.cudF

.cudH	a16	;if LMT max=50%
	lda			work0
	asra
	sta			work0
	a8
.cudF	s_Fchase_alvar		W,y,exal_acclcamrotX,x1,80H
	bra			.ac

;--------------------------------------------------------------

.nk	s_Fchase_alvar		W,y,exal_acclcamrotX,#0,80H
	bra			.exit_ccr

.ac
	a16

	lda	exal_camrotx,y
	clc
	adc	exal_acclcamrotx,y
	sta	x1

	bmi	.brmi

.brpl	cmp	work0
	bcc	.setadd
	bra			.brac

.brmi	cmp	work0
	bcs	.setadd


.brac	a8
	s_achase_alvar		W,y,exal_camrotx,work0,3
	bra			.skip0

.setadd	a8
	s_set_alvar		W,y,exal_camrotx,x1



	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.ac	s_copy_alvar2var	W,y,x1,exal_camrotx
	s_varadd_alvar		W,y,x1,exal_acclcamrotx
.brpl	s_jmp_varLESS		W,x1,#0,.brmi
	s_jmp_varLESS		W,x1,work0,.setadd
	bra			.brac
.brmi	s_jmp_varMORE		W,x1,#0,.skip0
	s_jmp_varMORE		W,x1,work0,.setadd
.brac	s_achase_alvar		W,y,exal_camrotx,work0,3
	bra			.skip0
.setadd	s_set_alvar		W,y,exal_camrotx,x1
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC



.skip0

.exit_ccr

.exit


	plp
	ply
	plx
	rts

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
; Set camera world x offset                                         ;  
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

set_camera_worldx_offset

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x

;---------------------------------------------------------------------------
; cockpit mode chenging?

	sp_jmp_ifcockpitchg	x,.xofsoff,y

;---------------------------------------------------------------------------
; cockpit mode?

	sp_jmp_ifcockpit	x,.xofsoff,y

;---------------------------------------------------------------------------
; control off?

	pl_jmp_ifcontroloff	x,.xofsoff,y

;---------------------------------------------------------------------------

	sp_jmp_playertype	x,ARWING,.ARWING

;---------------------------------------------------------------------------
.ROBOT

	a16
	lda	#0
	sta	exal_camXofs,y
	sta	exal_acclcamXofs,y
	sta	exal_camxofsbuf,y
	a8

	jmp		.addofs

;---------------------------------------------------------------------------
.ARWING

;---------------------------------------------------------------------
;set camera offset x(MAX,MIN)

	pl_jmpnot_ifturn	x,.calcofs,y

;---------------------------------------------------------------------
;view out of blockmap?

	s_jmpnot_alvarAND	B,y,exal_blockmapstatus,#exal_blockmapstatus_viewout!exal_blockmapstatus_playerout,.noVblockout

	a16
	lda	exal_camxofsbuf,y
	adiv2
	adiv2
	sta	exal_camxofsbuf,y
	a8
	jmp		.acxofs

.noVblockout

;---------------------------------------------------------------------
; trigger de X offset wo modosu.

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	lda	exal_sidevelcounter,y
	and	#exal_sidevelcounter_mask
	cmp	#8
	bcs	.noxofs0trig
	a16
	lda	pcont
	bit	#pad_left!pad_right
	a8
	bne	.noxofs0trig
	lda	exal_sidevelcounter,y
	bit	#exal_sidevelcounter_right
	bne	.xofs0_r
.xofs0_l	lda	exal_camxofsbuf+1,y
	bpl	.noxofs0trig
	bra	.xofs0
.xofs0_r	lda	exal_camxofsbuf+1,y
	bpl	.xofs0
.noxofs0trig
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;---------------------------------------------------------------------

.ck_tLR
	pl_jmp_notLRKEYdown	pcont,.no_tLR

.xofs0	s_Fchase_alvar		W,y,exal_camxofsbuf,#0,10

	jmp		.acxofs

.no_tLR

;---------------------------------------------------------------------
.calcofs

; blockmap 

;	lda	exal_blockmapstatus,y
;	bit	#exal_blockmapstatus_Lout!exal_blockmapstatus_Rout
;	beq	.noblock
;
;
;.blockLR	a16
;	bit	#exal_blockmapstatus_Lout
;	bne	.blockR
;.blockL	lda	#-20
;	bra	.block
;.blockR	lda	#20
;.block	sta	tpx
;	a8
;	bra	.cktype

.noblock	s_copy_alvar2var	W,y,tpx,exal_sidevel

	a16
	lda	exal_shockvel,y
	sexa
	clc
	adc	tpx
	sta	tpx
	a8

.cktype	sp_jmp_playertype	x,ROBOT,.ccRB,y

.ccAW_SF1	a16
	lda	#camerax_offset_SF1
	sta	x1
	lda	#-camerax_offset_SF1
	bra	.cc

.ccRB	a16
	lda	#camerax_offsetRB
	sta	x1
	lda	#-camerax_offsetRB
.cc	sta	x2

	lda		tpx
	clc
	adc		exal_camxofsbuf,y
	bmi		.mi
.pl	cmp		x1	; max value
 	bcc		.setxofs
	lda		x1	;
	bra		.setxofs
.mi	cmp		x2	; min value
	bcs		.setxofs
	lda		x2	;
.setxofs	sta		exal_camxofsbuf,y
	a8

.acxofs	s_achase_alvar2alvar	W,y,exal_camxofs,y,exal_camxofsbuf,2
	bra		.addofs


;---------------------------------------------------------------------
; worldx offset off

.xofsoff
	s_set_alvar	W,y,exal_camXofs,#0
	s_set_alvar	W,y,exal_acclcamXofs,#0
	s_set_alvar	W,y,exal_camxofsbuf,#0
	bra		.exit

;---------------------------------------------------------------------

.addofs	s_copy_alvar2var	W,y,work0,exal_camXofs

.inside	lda.w		exal_camroty+1,y
	nega
	sta		work3+0

	pl_roty_xvec16div2	work1,work2,work0,work3+0

	s_add_var	W,X1c,work1
	s_add_var	W,Z1c,work2

;-------------------------------------------------------------------

.exit	PULLYP
	rts

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
; set Arwing's Z offset(exal_camZofs_N			       ;
; (see sub routine CAM_BOOST_ZOFS)				       ;
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;	In	:exal_camZofs(word) offset value
;		:X1c,Y1c,Z1c worldx,y,z
;		:exal_VIEWflag_blockout = 1 no toki z offset wa chi-sakusuru....
;	Out	:X1c(=+offset),Y1c(=+offset),Z1c(=+offset)

set_camera_worldz_offset

blockcamzofs	equ	100

	PUSHYP

	a8i16

	toheap	y,x

; --- calc value of offset Z ---
;----------------------------------------------------------------------------------------------------------

	c_jmp_viewstratEQ	x,ONFIELD_ROBO,.ROBO,y

	jmp			.ARWING

;----------------------------------------------------------------------------------------------------------
.ROBO

;transrising?

	pl_jmpnot_iftransrising	x,.notransrise,y
	s_achase_alvar		W,y,exal_camZofs_N,#-400,2
	jmp			.add

.notransrise
;----------------------------------------------------------------------------------------------------------
; block map

	pl_jmp_ifblockoff	x,.noblock,y

	sp_jmp_ifcockpit	x,.noblock

	s_jmpnot_alvarAND	B,y,exal_blockmapstatus,#exal_blockmapstatus_viewout,.noblock
	s_achase_alvar		W,y,exal_camZofs,#blockcamzofs,2
	bra			.add

.noblock
;----------------------------------------------------------------------------------------------------------

	s_set_var	W,z1,#0
;************
	pl_jmpnot_ifinthesea	x,.notmarine
	s_set_var		W,z1,#marinezofs
	bra			.chase
.notmarine
;************

	sp_jmp_ifcockpit	x,.chase,y

	s_jmp_alvarzero		W,x,al_slopeptr,.chase
	pl_jmp_iftransform	x,.chase
	s_set_var		W,z1,#slopezofs

.chase	s_achase_alvar		W,y,exal_camZofs,z1,5

.add	a16
	lda	exal_camZofs_N,y
	clc
	adc	exal_camZofs,y
	sta	z1
	a8

	bra			.calc

;-----------------------------------------------------
; --- calc value of offset Z ---

.ARWING

	s_copy_alvar2var	W,y,z1,exal_camZofs_N

;-----------------------------------------------------

;	s_achase_alvar	W,y,exal_camZofs_tame,#0,3

;-----------------------------------------------------

.calc

; add offset value

	lda			#0
	sta			work0+0

	s_copy_alvar2var	B,y,work0+1,exal_camroty+1

	jsl			calc_WLDoffset_l

	s_add_var		W,X1c,x2
	s_add_var		W,Z1c,z2
	s_add_var		W,Y1c,y2


;-------------------------------------------------------------------
	PULLYP

	rts

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
; set world z offset value : exal_camZofs_N
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

cam_boost_zofs_srou

cb_zofs	equ	work9
cb_zrot	equ	work8
cb_zvx	equ	work7
cb_zvz	equ	work6
cb_zofs_tame	equ	work5


	PUSHYP

	a8i16

	ldy	#0
	sty	cb_zofs

	toheap	y,x

;-------------------------------------------------------------------
.arwing
; -- cockpit mode offset --

	sp_jmpnot_ifcockpit	x,.nocock,y

	s_achase_alvar		W,y,exal_camZofs,cb_zofs,3

	jmp	.calc

.nocock
;-------------------------------------------------------------------
; -- boost offset --
.boost_ofs

	a16
	lda	#70
	sta	cb_zofs_tame
	a8

	pl_jmp_ifboost		x,.F
	pl_jmp_ifbrake		x,.B
	bra			.addTAME

.B	a16

	lda	#20
	sta	cb_zofs_tame

	lda	exal_camZofs_B,y
	bra	.set

.F	a16
	lda	exal_camZofs_F,y
.set
	clc
	adc	exal_camZofs_tame,y
	sta	cb_zofs

	a8

;-------------------------------------------------------------------

.addTame

	lda	exal_camZofs_tame_accl,y
	beq	.tame0

	dec	a
	sta	exal_camZofs_tame_accl,y

	s_achase_alvar	W,y,exal_camZofs_tame,cb_zofs_tame,1

	bra	.settame
.tame0

	s_achase_alvar	W,y,exal_camZofs_tame,#0,4

.settame

;-------------------------------------------------------------------
.set_camofs
	a8

	s_achase_alvar		W,y,exal_camZofs,cb_zofs,3

	a16
	lda	exal_camZofs,y
	asl	a
	clc
	adc	exal_camZofs_tame,y
	sta	cb_zofs
	a8

;-------------------------------------------------------------------
.calc

; copy pos --> dummy

	jsr	copyviewpos2dummy

	s_push_obj	y
	ldy	dummyobj
	c_add_Roffs2pos16	W,y,y,x,#0,#0,cb_zofs,1,1,0
	s_pull_obj	y

	jsr	copydummypos2view

;-------------------------------------------------------------------
.exit	PULLYP

	rts



;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
; Calculates the camera world XYZ offset			       ;
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
calc_WLDoffset_l	; in	: work0   angleX(8 bits)
		;	: work0+1 angleY(8 bits)

		;	: z1(worldZ offset value)
		; out	: x2,y2,z2

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x

	s_neg_var	B,work0+1


	a16
	lda	#0
	sta	x1
	sta	x2

	lda	exal_camYofs,y
	asl	a
	sta	y1
	sta	y2
	lda	z1
	sta	z2

	a8

	lda	exal_camrotx+1,y
	nega

	jsl	rotate_16yz_l
	a16
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1

	a8
	lda	work0+1
	jsl	rotate_16xz_l

	a16
	lda	x2
	asra
	sta	x2
	lda	z2
	asra
	sta	z2
	lda	y2
	asra
	sta	y2
	a8


	PULLYP

	rtl



;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ;
;-------------------------------------------------------------------;
;                                                                   ;
; Calculates camera worldy offset(part4)              	       ;
;                                                                   ;
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ;

exal_camupdw_up	equ	%00000001
exal_camupdw_upH	equ	%00000010
exal_camupdw_upOLD	equ	%00000100	; last

exal_camupdw_dw	equ	%00001000
exal_camupdw_dwL	equ	%00010000
exal_camupdw_dwOLD	equ	%00100000	; last

exal_camupdw_dwG	equ	%10000000	; ground no chi kai!

exal_camupdw_dwALL	equ	exal_camupdw_dw!exal_camupdw_dwL!exal_camupdw_dwOLD
exal_camupdw_upALL	equ	exal_camupdw_up!exal_camupdw_upH!exal_camupdw_upOLD



ufo_camyofs		equ	work9
ufo_midCmoveY	equ	work8



set_camera_worldy_offset4	;(scwo)

	PUSHXYP

	a8i16

	toheap	y,x

	sp_jmp_playertype	x,UFO,.exit,y

;---------------------------------------------------------------------------
; control off?

	pl_jmp_ifcontrolon	x,.ctlon,y
	s_achase_alvar	W,y,exal_camYofs,#0,3
	jmp			.done

.ctlon
;---------------------------------------------------------------------------

	s_jmp_varZERO		B,Kenemynumber,.transform

;---------------------------------------------------------------------------

	s_jmp_alvarAND		B,y,exal_VIEWflag,#exal_VIEWflag_cpchg,.transform
	sp_jmp_ifcockpit	x,.cockpit,y
	jmp	.do

;------------------------------------------------------------------------
.transform

.cockpit	; cockpit mode

;------------
	a16
	lda	#0
	sta	exal_camYcenterOFS,Y
	lda	#-20
	sta	exal_camYofs,y
	lda	al_worldy,x
	sta	exal_camworldy,y
	sta	exal_camYcenter,Y
	a8

	lda	exal_camupdw,y
	and	#~(exal_camupdw_upALL!exal_camupdw_dwALL)
	sta	exal_camupdw,y
	lda	al_rotx,x
	bpl	.cdw

.cup	lda	exal_camupdw,y
	ora	#exal_camupdw_up!exal_camupdw_upOLD
	sta	exal_camupdw,y
	jmp	.done

.cdw	lda	exal_camupdw,y
	ora	#exal_camupdw_dw!exal_camupdw_dwOLD
	sta	exal_camupdw,y
	jmp	.done



;------------



;	s_set_alvar		W,y,exal_camYcenterOFS,#0
;	s_jmp_alvarPL		W,y,exal_camZofs_N,.rear
;.front	; changing
;	a16
;	lda			exal_camYofs,y
;	adiv2
;	sta			exal_camYofs,y
;	a8
;	jmp			.done
;.rear	a8
;	s_set_alvar		W,y,exal_camYofs,#-20	;-40
;	jmp			.done



;------------------------------------------------------------------------
.do
	sp_jmp_playertype	x,ROBOT,.INTHESEA_RB,y
	jmp			.COSMO_AW

;----------------------------------------------------
; worldy offset for ONFIELD ARWING
.INTHESEA_RB


	pl_jmpnot_ifinthesea	x,.exit

	a16

	lda	Y1c
	sta	y1

	a8

	lda	#7eh
	sta	y2

	pl_mult_168	y1,y1,y2

	a16

	lda	y1
	asra
	asra
	asra
	asra
	asra
	clc
	nega
	adc	y1
	sta	Y1c

	jmp	.done

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;----------------------------------------------------
; worldy offset for INSPACE ARMER
.INSPACE_AM
	SHORTA
	LONGI
;----------------------------------------------------
; TUTU mode
	pl_jmpnot_iftutumode	x,.isam_0,y
	a16
	lda	exal_TUTUheightcurrent,y
	lsr	a
	clc
	adc	exal_TUTUlevelcurrent,y
	sta	y1		; center pos
	sec
	sbc	Y1c
	pha
	lda	exal_TUTUheight,y
	asl	a	;4
	asl	a	;8
	bmi	.isam_8192
	asl	a	;8
	bmi	.isam_4096
	asl	a	;8
	bmi	.isam_2048
.isam_1024	pla
	asl	a	;800h
	pha
.isam_2048	pla		;800h
	asl	a	;1000h
	pha
.isam_4096	pla		;1000h
	asl	a	;2000h
	pha
.isam_8192	pla		;2000h
	asl	a	;4000h
	xba
	sexa
	clc
	sta	y1
	asra
	clc
	adc	y1
	sta	y1
	a8
	s_achase_alvar	W,y,exal_camYofs,y1,3
	jmp	.done
;----------------------------------------------------
.isam_0	a16
	lda	Y1c
	sec
	sbc	exal_midCmoveY,y
	sta	y1
	a8
	lda	#7bh
	sta	y2
.isam_1	pl_mult_168	y1,y1,y2
	a16
	lda	y1
	clc
	adc	exal_midCmoveY,y
	sta	Y1c
	lda	#0
	sta	exal_camYofs,y
	jmp	.done
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;----------------------------------------------------
; worldy offset for COSMO ARWING

.COSMO_AW	a8

	c_jmpnot_ifdemoview	x,.caw_start,y

	a16
	
	lda	#0
	sta	exal_camYcenterOFS,Y
	sta	exal_camYofs,y
	lda	al_worldy,x
	sta	exal_camworldy,y
	sta	exal_camYcenter,Y

	a8

	jmp	.exit

;----------------------------------------------------
.caw_start

;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK

;kore o kaeru

	lda	exal_camYofsMAX,y

	a16
	lda	#30	;100
	sta	work5
	lda	#-30	;-100
	sta	work6
	a8

;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;KOKOKOKKOKKOKOKOK
;-------------------------------------------------------
; flag
	a8

	testjoypad		up,pcont
	bne			.dwf0
	testjoypad		down,pcont
	beq			.nkf0

.upf0
	lda	al_rotx,x
	bmi	.upf2

	a16
	lda	exal_camYcenterOFS,Y
	clc
	adc	#-30
	a8
	bpl	.nkf0

.upf2	lda	exal_camupdw,y
	bit	#exal_camupdw_up
	bne	.upf1
	and	#(exal_camupdw_upH!exal_camupdw_dwALL)^-1
.upf1	ora	#exal_camupdw_up!exal_camupdw_upOLD
	bra	.flagE

.dwf0


	lda	al_rotx,x
	bpl	.dwf2


	a16
	lda	exal_camYcenterOFS,Y
	clc
	adc	#30
	a8
	bmi	.nkf0


.dwf2	lda	exal_camupdw,y
	bit	#exal_camupdw_dw
	bne	.dwf1
	and	#(exal_camupdw_dwL!exal_camupdw_upALL)^-1
.dwf1	ora	#exal_camupdw_dw!exal_camupdw_dwOLD
	bra	.flagE


.nkf0	lda	exal_camupdw,y
	and	#(exal_camupdw_up!exal_camupdw_upH!exal_camupdw_dw!exal_camupdw_dwL)^-1
.flagE	sta	exal_camupdw,y

;----------------------------------------------------

.ProsG	; after camYofs reach MAX rate

	c_jmp_viewstratEQ	x,COSMO_ARWING,.no_ng,y

	lda	exal_camupdw,y
	bit	#exal_camupdw_up
	bne	.no_ng

	a16
	lda	Y1c
	clc
	adc	exal_minPmoveY,y
	clc
	adc	#100
	a8
	bmi	.clr_ng

	s_and_alvar	B,y,exal_camupdw,#~(exal_camupdw_upH!exal_camupdw_dwL)
	s_Fchase_alvar	W,y,exal_camYcenterOFS,#0,5

	a16
	lda	Y1c
	sec
	sbc	exal_camYcenterOFS,Y
	sta	exal_camYcenter,Y
	lda	exal_camYcenterOFS,Y
	sta	work0

	a8
	s_or_alvar	B,y,exal_camupdw,#exal_camupdw_dwG
	jmp	.inn
.clr_ng
	s_and_alvar	B,y,exal_camupdw,#~exal_camupdw_dwG
.no_ng
;----------------------------------------------------
; marine no tame

	lda	exal_camupdw,y
	bit	#exal_camupdw_upH!exal_camupdw_dwL
	rlbeq	.Pros1

;----- ----- ----- ----- ----- ----- -----
.Pros0	; after camYofs reach MAX rate

	a16
	lda	Y1c
	sec
	sbc	exal_camYcenterOFS,Y
	sta	exal_camYcenter,Y

	lda	exal_camYcenterOFS,Y
	sta	work0
	jmp	.inn

;----- ----- ----- ----- ----- ----- -----

.Pros1	; before camYofs reach MAX rate

	a16
	lda	Y1c
	sec
	sbc	exal_camYcenter,Y
	sta	exal_camYcenterOFS,Y
	sta	work0

.doit
	lda	exal_camupdw,y
	bit	#exal_camupdw_dw!exal_camupdw_dwOLD
	bne	.pl0
	bit	#exal_camupdw_up!exal_camupdw_upOLD
	bne	.mi0



.nokey



.mi0
	lda	work0
	rlbpl	.inn
	cmp	work6	;ofsYmaxNEG
	rlbcs	.inn

	pha
	lda	Y1c
	clc
	adc	work5	;ofsYmax
	sta	work3
	a8
	s_achase_alvar		W,y,exal_camYcenter,work3,1
	s_jmpNOT_alvarAND	B,y,exal_camupdw,#exal_camupdw_up,.inn_n2
	s_or_alvar		B,y,exal_camupdw,#exal_camupdw_upH
	a16
	pla
	jmp	.inn_n

.pl0
	lda	work0
	bmi	.inn
	cmp	work5	;ofsYmax
	bcc	.inn

	pha
	lda	Y1c
	clc
	adc	work6	;ofsYmaxNEG
	sta	work3
	a8
	s_achase_alvar		W,y,exal_camYcenter,work3,1
	s_jmpNOT_alvarAND	B,y,exal_camupdw,#exal_camupdw_dw,.inn_n2
	s_or_alvar		B,y,exal_camupdw,#exal_camupdw_dwL
	a16
	pla
	jmp	.inn_n

.inn_n2	a16
	pla
.inn_n
	sta	work0

.inn
	a8


;	sm_jmp_if1screen	.onescreen
;.twoscreen	a16
;	lda	work0
;	asra
;	sta	tpx
;	asra
;	asra
;	nega
;	clc
;	adc	tpx
;	nega
;	sta	exal_camYofs,y
;	bra	.done


.onescreen
	a16
	lda	work0	; calc 38%
	asra
	sta	tpx
	asra
	asra
	asra
	nega
	clc
	adc	tpx
	nega
	sta	exal_camYofs,y


.done

;	a16
;	lda	y1c
;	clc
;	adc	#-25
;	sta	y1c
;	a8



.exit

	PULLXYP

	rts


testofs	equ	150	;*2








;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ;
;-------------------------------------------------------------------;
;                                                                   ;
; Calculates camera worldy offset(part5)              	       ;
;                                                                   ;
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ;

set_camera_worldy_offset5

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x

;--------------------------------------------------------------------------------------
; SET WORLDY

; Y offset (normal mode)

.p_height
;--------------------------------------------------------------------------------------
; cockpit mode


	pl_jmp_iftransrising	x,.transWY,y
	pl_jmp_iftransfalling	x,.transWY,y
	pl_jmp_iftransrising_w	x,.transWY,y
	pl_jmp_iftransfalling_w	x,.transWY,y
	sp_jmpNOT_ifcockpit	x,.transWY

.cocky

	a16
	lda	exal_bodyworldy,y
	clc
	adc	#RB0camYofs_cockpit
	sta	work0
	a8
;------------
; pool?

	pl_test_planetmode	marine
	beq			.nopool

	a16
	lda	exal_pooldepth,y
	cmp	work0
	bpl	.nopool2
	clc
	adc	#RB0camYofs_cockpit
	sta	work0
.nopool2	a8

.nopool

;------------
	s_jmpnot_alsflag	x,ontheground,.set2
	pl_clr_transfalling	x,y

	jmp			.set2

;--------------------------------------------------------------------------------------

.transWY

;--------------------------------------------------------------------------------------
; not cockpit mode

.normWY	s_set_var		W,work0,#0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; trans falling(ground)

	pl_jmpnot_iftransfalling_g	x,.nottransfall_g

	s_achase_alvar2alvar	W,y,exal_camworldy,y,exal_bodyworldy,1

	s_jmp_alsflag	x,ontheground,.clrtransfall_g

	bra		.nottransfall_g

.clrtransfall_g

	pl_clr_transfalling	x,y

.nottransfall_g
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; trans falling(marine)

	pl_jmp_iftransfalling_w		x,.transfall_w
	pl_jmpnot_iftransfalling	x,.nottransfall

	pl_jmp_ifinthesea	x,.fallsea

;*** on island?

.fallisland
	a16
	lda	exal_getheight_WY,y
	sec
	sbc	seadepth
	a8
	rlbpl	.exit
	jmp	.ground

;***
.fallsea	a16
	lda	#transfall_y
	clc
	adc	SEADEPTH
	sta	y1
	a8

	s_Fchase_alvar	W,y,exal_camworldy,y1,20,.transfall_w_on

	jmp		.exit

.transfall_w_on

	pl_set_transfalling_w	x,y

.transfall_w

	a16
	lda	#-transfall_y
	clc
	adc	SEADEPTH
	sta	y1
	a8

	s_Fchase_alvar	W,y,exal_camworldy,y1,4,.transfall_w_off
	jmp		.exit

.transfall_w_off

	pl_clr_transfalling	x,y

.nottransfall
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; trans rising

;	a16
;	lda	exal_camworldy,y
;	printh	exal_camworldy,kawagoe
;	a8

	pl_jmp_iftransrising_w	x,.transrise_w,y
	pl_jmpnot_iftransrising	x,.nottransrise,y


;-------------------------------------------------------------------------------
; transforming

	pl_jmpnot_iftransform	x,.notransform,y

	s_achase_alvar2alvar	W,y,exal_camworldy,y,exal_bodyworldy,2

	jmp			.exit

.notransform
;-------------------------------------------------------------------------------



	a16

	lda	al_worldy,x
	sta	exal_camworldy,y

	lda	#-transfall_y
	clc
	adc	SEADEPTH
	cmp	exal_camworldy,y
	rlbmi	.transrise_c
	sta	exal_camworldy,y

.transrise_c
	a8

	pl_jmp_ifinthesea	x,.exit

	a16
	lda	#-transfall_y
	clc
	adc	SEADEPTH
	sta	y1
	cmp	exal_camworldy,y
	a8

	rlbmi	.exit

.transrise_w_on

	s_set_alvar		W,y,exal_camworldy,y1
	pl_set_transrising_w	x,y

.transrise_w

	s_copy_alvar2alvar	W,y,exal_camYcenter,x,al_worldy

	a16
	lda	#transfall_y
	clc
	adc	SEADEPTH
	sta	y1
	a8

	s_Fchase_alvar	W,y,exal_camworldy,y1,4,.transrise_w_off

	jmp		.exit

.transrise_w_off

	pl_clr_transrising	x,y

	jmp		.exit

.nottransrise

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;--------------------------------------------------------------------------------------
; normal mode

	sp_jmpnot_playertype	x,ARWING,.notAW
	s_achase_alvar2alvar	W,y,exal_camworldy,x,al_worldy,3
	jmp	.exit
.notAW
;--------------------------------------------------------------------------------------

	pl_jmp_ifinthesea	x,.marine

	pl_jmp_UEpool		x,.pool

	pl_test_planetmode	marine
	rlbne			.ground

	rb_jmp_ifonshape	x,.ground

;--------------------------------------------------------------------------------------

.marine
	s_copy_alvar2var	W,y,Y1c,exal_bodyworldy
	jsr			set_camera_worldy_offset4
	s_achase_alvar		W,y,exal_camworldy,y1c,2
	jmp		.exit

;--------------------------------------------------------------------------------------

.ground

	s_copy_alvar2var	W,y,work0,exal_getheight_WY
	s_varadd_alvar		W,y,work0,exal_pooldepth

	s_jmp_alvarZERO		W,x,al_slopeptr,.stest
	s_add_var		W,work0,#slopeyofs

; room?
	lda	playerctlmode
	cmp	#map_room
	bne	.roomin

	a16
	lda	#-250
	cmp	work0
	bmi	.roomin
	sta	work0
.roomin	a8


.stest	jmp	.set

;--------------------------------------------------------------------------------------

.pool
	s_copy_alvar2var	W,y,work0,exal_pooldepth
	s_sub_var		W,work0,#RBcameraYofs>>1

	s_jmp_alvarZERO		W,x,al_slopeptr,.stest2
	s_add_var		W,work0,#slopeyofs

.stest2
	bra	.set2

;--------------------------------------------------------------------------------------
.set
;	sm_jmp_if2screen	.set_2

	s_sub_var		W,work0,#RBcameraYofs+20

;	bra			.set2
;.set_2	s_sub_var		W,work0,#RBcameraYofs_2	; battle mode

.set2

;********************************************************************

	s_copy_var2var		W,x1,work0		;chase value
	s_copy_alvar2var	W,y,x2,exal_camworldy	;current value
	s_copy_var2var		W,x3,#50		;limitter

	jsl			ACHASElimit_srou_l

	s_copy_var2var		W,work0,x2

;********************************************************************

	sp_jmp_ifcockpit	x,.cockchase,y

	s_achase_alvar		W,y,exal_camworldy,work0,3
	bra			.exit

.cockchase	s_set_alvar		W,y,exal_camworldy,work0

;--------------------------------------------------------------------------------------

.exit
	PULLYP
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Set Arwing's hscroll offset
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; set :exal_sidevel ( camera X offset inc value )

set_hscroll_offset_l

	IFEQ	1
	PUSHYP
	a8i16
	toheap	y,x
	c_jmp_ifdemoview	x,.exit,y
	pl_jmp_ifturn		x,.exit,y
	a16
	lda	exal_sidevel,y
	asra
	asra
	asra
	sta	tpx
	a8
	s_jmp_alsflag	x,player2,.p2
.p1	a16
	lda	player1hscroll_offset
	clc
	sbc	tpx
	sta	player1hscroll_offset
	bra	.exit
.p2	a16
	lda	player2hscroll_offset
	clc
	sbc	tpx
	sta	player2hscroll_offset
.exit	PULLYP
	ENDC

	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Set Arwing(Armer)'s vscroll offset(SPACE MODE)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
set_vscroll_offset_l

	PUSHYP

	s_start_strat

	a8i16

	km_jmpgameflag		freeze,.pp

	sp_jmp_ifvscrolloff	x,.pp

	pl_ldy_viewblk	x

	a16

	lda	BATTLEAREA_maxY
	clc
	adc	BATTLEAREA_minY
	adiv2
	nega
	clc
	adc.w	al_worldy,y

	asra
	asra
	asra
	asra

	sta	work0
	bit	#8000H
	bne	.mi

.pl	cmp	#160	;vscrollofsmax	; limitter
	bcc	.done
	lda	#160	;vscrollofsmax
	bra	.set

.mi	nega
	cmp	#160	;vscrollofsmax	; limitter
	bcc	.done
	lda	#160	;vscrollofsmax
	nega
.set	sta	work0

.done	a8

	s_set_var	W,player1vscroll_offset,work0


;	s_jmp_alsflag	x,player2,.pp2
;.pp1	s_set_var	W,player1vscroll_offset,work0
;	bra	.pp
;.pp2	s_set_var	W,player2vscroll_offset,work0
;	bra	.pp
;.pp	a16
;	lda	player1vscroll_offset
;	lda	gameframe
;	printh	player1vscroll_offset,kawagoe
;	a8

.pp


	PULLYP

	rtl


;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
; Calculates the horizon position                                   ;  
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;set horizon data

set_horizon_l

	PUSHXYPB

	a8i16

	BANK7E

;player1

	ldx	playpt1

	a16

;********************************************************************
; for switch demo
;
;	km_jmpnotgameflag	freeze,.notdemo
;
;	toheap	y,x
;
;	lda	exal_VIEWflag2,y
;	and	#~exal_VIEWflag2_inthesea
;	sta	exal_VIEWflag2,y
;
;	lda	exal_status,y
;	and	#~exal_status_transrising_w
;	sta	exal_status,y
;	lda	exal_VIEWflag2,y
;	and	#~exal_VIEWflag2_inthesea
;	sta	exal_VIEWflag2,y
;
;	ldy	#viewblk1
;	lda.w	al_worldy,y
;	toheap	y,x
;
;	sec
;	sbc	SEADEPTH
;
;	bpl	.pl
;	nega
;	bra	.cmp
;.pl
;	PHA
;	lda	exal_VIEWflag2,y
;	ora	#exal_VIEWflag2_inthesea
;	sta	exal_VIEWflag2,y
;
;	lda	exal_VIEWflag3,y
;	ora	#exal_VIEWflag3_insea_F
;	sta	exal_VIEWflag3,y
;
;	PLA
;
;.cmp	cmp	#20h
;	bpl	.ue
;
;	lda	exal_status,y
;	ora	#exal_status_transrising_w
;	sta	exal_status,y
;.ue
;
;	bra	.freezeout
;
;--------------------------------------------------------------------
;.notdemo
;
; freeze trigger off
;
;	lda	exal_VIEWflag3,y
;	and	#~(exal_VIEWflag3_insea_F!exal_VIEWflag3_outsea_F)
;	sta	exal_VIEWflag3,y
;
;.freezeout
;********************************************************************

; -- rotz buffser --

	toheap	y,x

	lda	player1_horizonbak
	jsr	.addseaofs
	lda	y1
	clc
	adc	player1vscroll_offset
	clc
	adc	player1_horizon_offset
	sta	player1_horizon

	jsr	.calcV
	sta	player1_horizonbak

	lda	y2
	sta	player1_horizon_wofs

	a8

.exit
	PULLXYPB
	rtl



.calcV	a8i16

	PHY

	pl_ldy_viewblk	x
	a16
	lda.w	al_rotx,y

	clc

	PLY

	PHA

	a8

	lda	demomode
	beq	.cksp

	lda	demoNo
	cmp	#demo_starwolf
	bne	.normal
	bra	.space


.cksp	pl_test_planetmode	space
	rlbeq			.space

.normal	a16
	PLA
	adiv2
	bra	.normal2
.space	a16
	lda	BATTLEAREA_maxY
	cmp	#-3500
	bne	.normal
	PLA
.normal2	adiv2
	adiv2
	adiv2
	adiv2
	adiv2

;*************************************
; adjusting....

	sta	tpx

.adjust	adiv2
	adiv2
	adiv2
	sta	tpy
	adiv2
	clc
	adc	tpy

	nega
	clc
	adc	tpx

;*************************************

	sta	Y1c
	nega
	sta	y1

.return	a16
	lda	y1

	rts




.addseaofs	LONGA
	LONGI
	sta	y1

	lda	#0
	sta	y2

	a8

	pl_test_planetmode	marine
	rlbne			.aso1

;------------
	phy


	km_jmpgameflag	freeze,.ckinthesea	; demo tyu- ha inthesea dake check suru.
	pl_jmp_iftransfalling	x,.noaddofs0,y
.ckinthesea	pl_jmpnot_ifcaminthesea	x,.noaddofs1,y


;;;.addofs
	a16

	lda	y1
	clc
	adc	#200h
	sta	y1
	a8
	jmp	.noaddofs2

.noaddofs0
.noaddofs1
.noaddofs2
	ply

;------------
; trans fall offset

	pl_jmp_iftransrising_w		x,.aso_on,y
	pl_jmpnot_iftransfalling_w	x,.aso1,y

.aso_on	s_copy_alvar2var	W,y,tpy,exal_camworldy

	phy
	pl_ldy_viewblk	x

	a16

	lda.w	al_worldy,y
	sta	tpy

	lda	tpy
	sec
	sbc	#transfall_y

	sec
	sbc	SEADEPTH

	bit	#0ffe0h
	beq	.aso2
	lda	#01fh
.aso2	asl	a
	asl	a
	asl	a
	ply
	sta	y2

	rts

.aso1	a16
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------
;		copy VIEW ANGLE
;----------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
copy_viewrot

;	idX	: camera pointer

	PUSHXYP
	a8i16
	stx			work0

	toheap	y,x

	pl_ldx_viewblk		x

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- rotx --

	s_copy_alvar2alvar	W,x,al_rotx,y,exal_camrotx

	a16
	lda	exal_camrotxtilt,y
	asl	a
	clc
	adc	al_rotx,x
	sta	al_rotx,x
	a8

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- roty --

	s_copy_alvar2alvar	W,x,al_roty,y,exal_camroty
	s_add_alvars		W,x,al_roty,y,exal_camrotyofsNT

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- rotz --
	s_push_obj		x

	ldx	work0

;	s_jmp_alsflag		x,player2,.p2rotz

.p1rotz	s_pull_obj		x
	a16
	lda	exal_camrotz,y
	sta	al_rotz,x
	sta	p1_camrotzbuf
	a8
	bra			.pprotz

;.p2rotz	s_pull_obj		x
;	a16
;	lda	exal_camrotz,y
;	sta	al_rotz,x
;	sta	p2_camrotzbuf
;	a8

.pprotz
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.exit	PULLXYP

	rts




copy_viewrot_freeze	; freeze(koneta-clear demo no toki callsuru.)

	PUSHYP
	a8i16

	pl_ldy_viewblk		x

;	s_jmp_alsflag		x,player2,.p2

.p1	a16
	lda.w	al_rotz,y
	sta	p1_camrotzbuf
;	bra	.exit
;
;.p2	a16
;	lda.w	al_rotz,y
;	sta	p2_camrotzbuf

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.exit	PULLYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------
;		copy VIEW POS
;----------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
copy_viewpos

	PUSHXYP

	s_start_strat

	a8i16

	pl_ldy_viewblk	x

	s_set_alvar	W,y,al_sword1,#0

	toheap		x,x

	a16
	lda	exal_camworldx,x
	sta.w	al_worldx,y
	lda	exal_camworldy,x
	sta.w	al_worldy,y
	lda	exal_camworldz,x
	sta.w	al_worldz,y

	PULLXYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------
;		CAMERA LOOKS OBJECTS
;----------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;	In	:	idX   = pointer of object
;		:	idY   = camera pointer
;		:	x1 = X offset(8bit)
;		:	y1 = Y offset(8bit)
;		:	z1 = Z offset(8bit)

;	Out	:	x2 = rotx(16bit)
;		:	y2 = roty(16bit)

	SHORTA
	LONGI

cam_looksobj_l

	PUSHYP

	a8i16

	sp_jmp_playertype	x,ROBOT,.rb

.aw
	ldy		dummyobj
	s_copy_pos	y,x
	s_copy_rots	y,x
	s_set_var	W,z1,#0
	bra		.roffs

.rb
	s_push_obj	x

	toheap		y,x

	ldx		dummyobj

	a16
	lda	exal_worldx,y
	sta	al_worldx,x
	lda	exal_bodyworldy,y
	sta	al_worldy,x
	lda	exal_worldz,y
	sta	al_worldz,x
	a8

	lda	exal_roty+1,y
	sta	y2

	txy
	s_pull_obj		x

	s_set_alvar		B,y,al_roty,y2

.roffs


	s_add_roffs2pos		B,y,y,y,x1,y1,z1,0,1,0


	s_push_obj		x
	pl_ldx_viewblk		x

	ldy	dummyobj

;-----------------------------------------------------------------------------
	stz	smvar_byte1
;-----------------------------------------------------------------------------
	s_jsl	Xanglexy_l
	a16
	nega
	sta	x2
	a8
;-----------------------------------------------------------------------------
	s_jsl	Yanglexy_l
	a16
	sta	y2
	a8
;-----------------------------------------------------------------------------
	s_pull_obj		x

	PULLYP

	rtl






	IFEQ	1
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	SHORTA
	LONGI
cam_looksobj_l
	PUSHXYP
	a8i16
	sp_jmp_playertype	x,ROBOT,.rb
.aw	ldy		dummyobj
	s_copy_pos	y,x
	s_copy_rots	y,x
	s_set_var	W,z1,#0
	bra		.roffs
.rb	s_push_obj	x
	toheap		y,x
	ldx		dummyobj
	a16
	lda	exal_worldx,y
	sta	al_worldx,x
	lda	exal_worldy,y
	sta	al_worldy,x
	lda	exal_worldz,y
	sta	al_worldz,x
	lda	exal_bodyofsy,y
	sexa
	nega
	clc
	adc	y1
	sta	y1
	a8
	lda	exal_roty+1,y
	sta	y2
	txy
	s_pull_obj		x
	s_set_alvar	B,y,al_roty,y2
.roffs	a16
	lda	y1
	pha
	a8
	c_add_roffs2pos16	W,y,y,y,x1,#0,z1,0,1,0
	a16
	pla
	sta	y1
	a8
	s_add_alvar	W,y,al_worldy,y1
	s_push_obj		x
	pl_ldx_viewblk		x
	ldy			dummyobj
	lda	al_rotx,x
	pha
	lda	al_roty,x
	pha
	s_obj2obj_3dangle	x,y,al_roty,al_rotx,0
	s_copy_alvar2var	B,x,x1,al_rotx
	s_copy_alvar2var	B,x,y1,al_roty
	pla
	sta	al_roty,x
	pla
	sta	al_rotx,x
	s_neg_var		W,x1
	s_neg_var		W,y1
	s_pull_obj		x
	PULLXYP
	rtl
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------
;		INBETWEEN ROUTINE
;----------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

set_inbet_path_l	; call from path idY : #viewblk1 or #viewblk2


	PUSHXYP

	tyx
	bra	set_inbet_l.enter

set_inbet_l

;	sflag1	:world  x,y,z inbetween on
;	sflag2	:rot    x,y,z inbetween on
;	sflag3	:inbetween off trigger
;	sflag4	:world  x,y,z inbetween not finish flag
;	sflag5	:rot    x,y,z inbetween not finish flag
;	sflag6	:fast mode flag

	PUSHXYP

	pl_ldx_viewblk	x

; ----

.enter	LOCAL

; ----
	km_jmpnotgameflag	freeze,.notfreeze
	a16
	lda		#0
	sta		al_childx,x
	sta		al_childy,x
	sta		al_childz,x
	a8
.notfreeze
; ----
	s_jmp_alsflag	x,sflag1,.offtrig	; pos inbet
	s_jmp_alsflag	x,sflag2,.offtrig	; rot inbet
	jmp	.noinit

.offtrig
	s_jmpnot_alsflag	x,sflag3,.start
	s_clr_alsflag		x,sflag3

	s_clr_alsflag	x,sflag1	; pos inbet
	s_clr_alsflag	x,sflag2	; rot inbet

	jmp			.noinit

.start	LOCAL

; ----
.pos

	s_jmpnot_alsflag	x,sflag1,.rot
	s_clr_alsflag		x,sflag1
	s_set_alsflag		x,sflag4

	a16
	lda		al_ox,x
	sec
	sbc		al_worldx,x
	sta		al_childx,x

	lda		al_oy,x
	sec
	sbc		al_worldy,x
	sta		al_childy,x

	lda		al_oz,x
	sec
	sbc		al_worldz,x
	sta		al_childz,x
	a8

;---
.rot
	s_jmpnot_alsflag	x,sflag2,.noinit
	s_clr_alsflag		x,sflag2
	s_set_alsflag		x,sflag5

	lda		al_mx+1,x
	sec
	sbc		al_rotx+1,x
	sta		al_childrotx,x

	lda		al_my+1,x
	sec
	sbc		al_roty+1,x
	sta		al_childroty,x

	lda		al_mz+1,x
	sec
	sbc		al_rotz+1,x
	sta		al_childrotz,x


	lda		al_roty+1,x
	sta		al_count,x	;exal_caminbetroty,y

	a8
;---
.noinit
	jsr	.decinbetpos
	jsr	.decinbetrot
	jsr	.addinbetrot
	jsr	.addinbetpos
	jsr	.copyoldposrot


.exit	LOCAL

	PULLXYP


	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI
.addinbetpos

	s_jmpnot_alsflag	x,sflag4,.notrotation2

	phy

	ldy			dummyobj
	s_copy_alvar2alvar	B,y,al_rotx,x,al_rotx+1
	s_copy_alvar2alvar	B,y,al_rotz,x,al_rotz+1

	a16
	lda		al_childx,x
	sta		x1
	lda		al_childy,x
	sta		y1
	lda		al_childz,x
	sta		z1
	a8

	lda		al_count,x
	sec
	sbc		al_roty+1,x
	sta.w		al_roty,y

.rotation
	c_add_Roffs2pos16	W,x,x,y,x1,y1,z1,0,1,0

.notrotation
	ply

.notrotation2
	rts



.initinbetpos

	a16

	lda	al_ox,x
	sec
	sbc.w	al_worldx,x
	sta.w	al_childx,x

	lda	al_oy,x
	sec
	sbc.w	al_worldy,x
	sta.w	al_childy,x

	lda	al_oz,x
	sec
	sbc.w	al_worldz,x
	sta.w	al_childz,x

	a8

	rts

.addinbetrot

	s_jmpnot_alsflag	x,sflag5,.noaddinbetrot

	lda	al_rotx+1,x
	clc
	adc	al_childrotx,x
	sta	al_rotx+1,x

	lda	al_roty+1,x
	clc
	adc	al_childroty,x
	sta	al_roty+1,x

	lda	al_rotz+1,x
	clc
	adc	al_childrotz,x
	sta	al_rotz+1,x

.noaddinbetrot

	rts

.copyoldposrot

	a16

	lda	al_worldx,x
	sta	al_ox,x
	lda	al_worldy,x
	sta	al_oy,x
	lda	al_worldz,x
	sta	al_oz,x

	lda	al_rotx,x
	sta	al_mx,x
	lda	al_roty,x
	sta	al_my,x
	lda	al_rotz,x
	sta	al_mz,x

	a8

	rts


.decinbetpos
	s_jmp_alsflag	x,sflag6,.decinbetpos_fast

	s_achase_alvar	W,x,al_childx,#0,4
	s_achase_alvar	W,x,al_childy,#0,4
	s_achase_alvar	W,x,al_childz,#0,4

.dip1	a16
	lda	al_childx,x
	ora	al_childy,x
	ora	al_childz,x
	a8
	bne	.dip0
	s_clr_alsflag	x,sflag4
.dip0	rts


.decinbetpos_fast
	a8
	s_achase_alvar	W,x,al_childx,#0,1
	s_achase_alvar	W,x,al_childy,#0,1
	s_achase_alvar	W,x,al_childz,#0,1
	bra		.dip1

.decinbetrot
	s_fchase_alvar	B,x,al_childrotx,#0,1
	s_fchase_alvar	B,x,al_childroty,#0,1
	s_fchase_alvar	B,x,al_childrotz,#0,1

	lda	al_childrotx,x
	ora	al_childroty,x
	ora	al_childrotz,x
	bne	.dir0
	s_clr_alsflag	x,sflag5
.dir0	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------;
; Set player's shock!		                               ;
;-------------------------------------------------------------------;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

camrotX_shock_l

	PUSHYP

	a8i16

	toheap	y,x

	s_neg_alvar	W,y,exal_camrotxtilt
	s_fchase_alvar	W,y,exal_camrotxtilt,#0,10H

	PULLYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;		VIEW CHANGE ROUTINE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
NUMofAWview	equ	2

;viewtab_one	equ	work9
;viewtab_two	equ	work8

	SHORTA
	LONGI

VIEW_CHANGE_l

	PUSHYP

	a8i16

	toheap	y,x

;--------------------------------------------------------------------------------
; pool view flag

	sp_jmpNOT_playertype	x,ROBOT,.notpool,y

	pl_jmpnot_ifinthesea	x,.notpool
	s_jmp_alsflag		x,ontheground,.notpool
	pl_jmpnot_KAOinpool	x,.notpool

.notpool

;--------------------------------------------------------------------------------
; view change wo shita atono inbetween on?

	s_jmpnot_alvarAND	B,y,exal_VIEWflag,#exal_VIEWflag_cpinbet,.noinbet
	s_and_alvar		B,y,exal_VIEWflag,#~exal_VIEWflag_cpinbet
	c_view_inbetween	x,on

.noinbet
;--------------------------------------------------------------------------------

	s_jmp_alvarPL		W,y,exal_camZofs_N,.clrPLAYER
	s_jmp_alvarLESS		W,y,exal_camZofs_N,#-40,.setplayer

.clrPLAYER	s_set_alsflag	x,insidecockpit
	bra	.do

.setPLAYER	s_clr_alsflag	x,insidecockpit

.do

;--------------------------------------------------------------------------------
; read import flag (from Yajima)

	sp_ifviewchangeOFF	.off

	lda	playerimportflag
	bit	#pif_cockpit_trig
	beq	.readkey
	and	#~pif_cockpit_trig
	sta	playerimportflag

;	lda	PMODE
;	bne	.RB

.AW

;	sp_jmp_playerctl	x,CS_ARWING,off,y

	lda	playerimportflag
	bit	#pif_cockpit_on
	bne	.on

;;	bra	.off
;;
;;.RB
;;RB off	lda	playerimportflag
;;RB off	bit	#pif_cockpit_onRB
;;RB off	bne	.on

.off	sp_jmpnot_ifcockpit	x,.readkey,y
	bra	.VCON

.on	sp_jmpnot_ifcockpit	x,.VCON,y

;------------
; read key

.readkey

	IFEQ	1
	testjoypad	tleft,pcont
	beq		.cka00
	testjoypad	tright,pcont
	beq		.cka00
	testjoypad	select,ptrig
	beq		.cka00
	kplsound	x,viewchange
	c_cockpitmode_change
	ENDC

	bra		.cka00


.VCON	s_or_alvar	B,y,exal_VIEWflag,#exal_VIEWflag_change

.cka00	s_jmp_alvarAND	B,y,exal_VIEWflag,#exal_VIEWflag_cpchg,.cka0

	s_jmpNOT_alvarAND	B,y,exal_VIEWflag,#exal_VIEWflag_change,.cka0
	s_and_alvar		B,y,exal_VIEWflag,#~exal_VIEWflag_change

	s_jmp_alvarZERO		B,x,al_hp,.noSE

.noSE

	c_view_inbetween	x,on
	pl_eor_alvar	B,y,exal_VIEWflag,#exal_VIEWflag_cockpit
	s_or_alvar	B,y,exal_VIEWflag,#exal_VIEWflag_cpchg

;************
; set Kawaguchi flag

	stz	pause_viewselect
	lda	exal_VIEWflag,y
	bit	#exal_VIEWflag_cockpit
	beq	.skf
	inc	pause_viewselect
.skf
;************
.cka0

;-----------------------------------------------------

.normal
	pl_jmp_iftransform	x,.cka3

	s_jmpNOT_alvarAND	B,y,exal_VIEWflag,#exal_VIEWflag_cockpit,.cka3
	s_copy_alvar2var	W,y,work0,exal_camZofs_cock

	bra			.cka4

.cka3	s_copy_alvar2var	W,y,work0,exal_camZofs_objective
.cka4
;------------------------------------------------------------------------

.chaseAWv
	s_Fchase_alvar	W,y,exal_camZofs_N,work0,30
	bra		.setofs2
.setofs2
	s_varsub_alvar		W,y,work0,exal_camZofs_N
	pl_abs_var		W,work0
	s_jmp_varMORE		W,work0,#50,.exitAWv

	s_jmpNOT_alvarAND	B,y,exal_VIEWflag,#exal_VIEWflag_cpchg,.exitAWv
	s_and_alvar		B,y,exal_VIEWflag,#~exal_VIEWflag_cpchg
	s_or_alvar		B,y,exal_VIEWflag,#exal_VIEWflag_cpinbet

.exitAWv

	PULLYP
	rtl



;--------------------------------------------------------------------------------
VIEW_CHANGE_INIT_l

	PUSHXYP

	a8i16

	toheap	y,x

	sp_jmp_playertype	x,UFO,.ARMER,y
	sp_jmp_playertype	x,ARWING,.ARWING,y


.ROBOT
;	sm_jmp_if2screen	.tscRB

.oscRB	ldx	#RBV_NORMAL_1&WM
	bra	.set
;.tscRB	ldx	#RBV_NORMAL&WM
;	bra	.set


.ARMER
;	sm_jmp_if2screen	.AMtsc

.AMosc	ldx	#AMV_NORMAL_1&WM
	bra	.set
;.AMtsc	ldx	#AMV_NORMAL&WM
;	bra	.set


.ARWING
;	sm_jmp_if2screen	.tsc

.osc	ldx	#ARV_NORMAL_1&WM
	bra	.set
;.tsc	ldx	#ARV_NORMAL&WM

.set	a16
	lda.l	VIEW_TABLE&0ff0000H+0,x
	sta	exal_camZofs_N,y
	sta	exal_camZofs_objective,y
	lda.l	VIEW_TABLE&0ff0000H+2,x
	sta	exal_camZofs_F,y
	lda.l	VIEW_TABLE&0ff0000H+4,x
	sta	exal_camZofs_B,y
	lda.l	VIEW_TABLE&0ff0000H+6,x
	sta	exal_camZofs_cock,y
	lda.l	VIEW_TABLE&0ff0000H+8,x
	sta	exal_camRotXofs_Normal,y
	lda.l	VIEW_TABLE&0ff0000H+10,x
	sta	exal_camRotXofs_JMP,y
	lda.l	VIEW_TABLE&0ff0000H+12,x
	sta	exal_camYofs_Normal,y

.exit	PULLXYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	limitter of seadepth
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
sealimit_view_srou_l
;--------------------------------------------------------------------------------
; limitter of sea(final)
; umi ni sita ni camera ga ikanai you ni suru.

	s_start_strat

	PHY

	toheap	y,x

	c_jmp_viewstratNE	x,ONFIELD_ARWING,.los_end,y

	phy
	pl_ldy_viewblk	x

	a16

	lda	#-10
	clc
	adc	seadepth
	cmp.w	al_worldy,y
	bpl	.los
	sta.w	al_worldy,y

.los	ply

	a8

.los_end
	PLY

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	copy view pos <---> dummy obj pos
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
copyviewpos2dummy

;	in	:idx player's pointer

	s_start_strat

	PUSHXYP

	a8i16

	toheap	y,x

	ldx	dummyobj
	a16
	lda	exal_camworldx,y
	sta	al_worldx,x
	lda	exal_camworldy,y
	sta	al_worldy,x
	lda	exal_camworldz,y
	sta	al_worldz,x

	PULLXYP

	rts

;---------------------------------------------------------------
copydummypos2view

	s_start_strat

	PUSHXYP

	a8i16

	toheap	y,x

	ldx	dummyobj
	a16
	lda	al_worldx,x
	sta	exal_camworldx,y
	lda	al_worldy,x
	sta	exal_camworldy,y
	lda	al_worldz,x
	sta	exal_camworldz,y

	PULLXYP

	rts

;---------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³   -----------------------    ³
;³   VIEW CHANGE DATA(ROBOT)    ³
;³   -----------------------    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RB_VIEW_COCK	DW	0
	DW	-150


VIEW_TABLE	;(4 Table)

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³   -----------------------    ³
;³   VIEW CHANGE DATA(ARWING)   ³
;³   -----------------------    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RBV_NORMAL_1	; one screen mode

	DW	-RB0camZofs_N_1
	DW	-RB0camZofs_F_1
	DW	-RB0camZofs_B_1
	DW	20
	DW	0
	DW	0
	DW	0

;RBV_NORMAL	; two screen mode
;
;	DW	-RB0camZofs_N
;	DW	-RB0camZofs_F
;	DW	-RB0camZofs_B
;	DW	20
;	DW	0
;	DW	0
;	DW	0

ARV_NORMAL_1	; one screen mode

	DW	-cameraZ_offset_normal_1
	DW	-cameraZ_offset_boost_1
	DW	-cameraZ_offset_brake_1
	DW	0
	DW	0
	DW	0
	DW	0

;ARV_NORMAL	; two screen mode
;
;	DW	-cameraZ_offset_normal
;	DW	-cameraZ_offset_boost
;	DW	-cameraZ_offset_brake
;	DW	20
;	DW	0
;	DW	0
;	DW	0

AMV_NORMAL_1	; one screen mode

	DW	-AMcameraZ_offset_normal_1
	DW	0
	DW	0
	DW	0
	DW	0
	DW	0
	DW	0

;AMV_NORMAL	; two screen mode
;
;	DW	-AMcameraZ_offset_normal
;	DW	0
;	DW	0
;	DW	0
;	DW	0
;	DW	0
;	DW	0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³   -----------------------    ³
;³  VIEW CHANGE DATA(ALL CLEAR) ³
;³   -----------------------    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


VIEW_ZERO	;clera data

	DW	0
	DW	0
	DW	0
	DW	0
	DW	0
	DW	0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	DEMO CAMERA
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	al_pword1	:time counter
;	al_pbyte1	;temp
;	al_pbyte2	;temp

;local macro


end_demoview	macro

	rtl

	endm

demoview_srou_l

	s_start_strat

	PUSHXYP

	a8i16

	ldy	#viewblk1
; inc timer
	a16
	lda.w	al_pword1,y
	inc	a
	sta.w	al_pword1,y
	a8

;------------

	toheap	y,x

	a16
	lda	exal_demoviewstratptr+0,y
	beq	.exit
	a8

	lda	#(.exit&0ff0000H)>>16
	pha
	a16
	lda	#.exit&0ffffH
	dec	a
	pha

	a8
	lda	exal_demoviewstratptr+2,y
	pha
	a16
	lda	exal_demoviewstratptr+0,y
	dec	a
	pha
	a8
	rtl

.exit	LOCAL

	PULLXYP
	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	DEMO CAMERA
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DVSTRAT_trapper
	s_start_strat
	pl_ldy_viewblk	x
	a16
	lda.w	al_ox,y
	sta.w	al_worldx,y
	lda.w	al_oy,y
	sta.w	al_worldy,y
	lda.w	al_oz,y
	sta.w	al_worldz,y
	a8
	sp_jmp_playertype	x,ARWING,.aw
.rb	s_set_alvar	B,y,al_roty,coreroty
	s_set_alvar	W,y,al_worldy,#-200
	s_set_alvar	W,y,al_worldx,corex
	s_set_alvar	W,y,al_worldz,corez
	s_add_roffs2pos	B,y,y,y,#0,#0,#127,0,1,0,3,0,3
	bra		.watch
.aw	s_achase_alvar2alvar	W,y,al_worldx,x,al_worldx,4
	s_achase_alvar2alvar	W,y,al_worldz,x,al_worldz,4
	a16
	lda.w	al_worldy,y
	clc
	adc	#-5
	sta.w	al_worldy,y
	a8
.watch	jsr	dv_watchobj
	end_demoview
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC
;-----------------------------------------------------------------------------
;DVSTRAT_gotoendseq0
;
;	s_start_strat
;
;	jsr	dv_turninit
;
;
;	pl_ldy_viewblk	x
;	s_set_alvar	B,y,al_pbyte1,#80h
;
;
;	c_set_demoviewstrat	x,gotoendseq0_1
;
;DVSTRAT_gotoendseq0_1
;
;.turn	jsr	dv_turnaroundobj_003
;.watch	LOCAL
;	jsr	dv_watchobj
;	jsr	dv_copyplrxzvecs
;
;	toheap	y,x
;
;	pl_jmp_ifblockoff	x,.exit,y
;
;.exit	end_demoview
;
;-----------------------------------------------------------------------------
DVSTRAT_chika

	s_start_strat


	ldy	dummyobj
	a16
	lda	corex
	sta.w	al_worldx,y
	lda	#-50
	sta.w	al_worldy,y
	lda	corez
	sta.w	al_worldz,y
	lda	coreroty
	sta.w	al_roty,y
	a8

	s_add_roffs2pos	B,y,y,y,#0,#0,#60,0,1,0

	sty	demoshapeptr

	jsr	dv_watchobj
	jsr	dv_corepos

	ldy	#viewblk1

	a16
	lda.w	al_rotx,y
	asra
	sta.w	al_rotx,y
	a8

	end_demoview

;-----------------------------------------------------------------------------
DVSTRAT_clrawof

	s_start_strat

	jsr	dv_turninit

	c_set_demoviewstrat	x,clrawof_1

DVSTRAT_clrawof_1

	jsr	dv_copyplrxzvecs

.turn	jsr	dv_turnaroundobj_demoshape	;005
.watch	LOCAL
	jsr	dv_watchobj

	toheap	y,x

	pl_jmp_ifblockoff	x,.exit,y

.exit	end_demoview

;-----------------------------------------------------------------------------
DVSTRAT_goto_endseq0

	s_start_strat

	jsr	dv_turninit

	c_set_demoviewstrat	x,goto_endseq0_1

DVSTRAT_goto_endseq0_1

	jsr	dv_turnaroundobj_005
	jsr	dv_watchobj
	jsr	dv_copyplrxzvecs

.exit	end_demoview

;-----------------------------------------------------------------------------
DVSTRAT_playerdead

	s_start_strat

	jsr	dv_turninit

	c_set_demoviewstrat	x,playerdead_1

DVSTRAT_playerdead_1

.turn	jsr	dv_turnaroundobj_003
.watch	LOCAL
	jsr	dv_watchobj
	jsr	dv_copyplrxzvecs

	toheap	y,x

	pl_jmp_ifblockoff	x,.exit,y

.exit

	end_demoview

;-----------------------------------------------------------------------------

DVSTRAT_enemyhasgone

	s_start_strat

	PHY
	toheap	y,x
	s_set_alvar	W,y,exal_camZofs_gone,#-80
	PLY

	jsr	dv_turninit

	c_set_demoviewstrat	x,enemyhasgone_1


DVSTRAT_enemyhasgone_1

	jsr	dv_turnaroundobj_004
	jsr	dv_watchobj
	jsr	dv_copyplrxzvecs

	end_demoview

;-----------------------------------------------------------------------------
;	stratroutine for DEMO
;-----------------------------------------------------------------------------

dv_watchobj

;	demoshapeptr	; obj pointer

	PUSHYP

	s_push_obj		x

	pl_ldx_viewblk		x

;-----------------------------------------------------------------------------
; copy old rot

	a16
	lda	al_mx,x
	sta	al_rotx,x
	lda	al_my,x
	sta	al_roty,x
	lda	al_mz,x
	sta	al_rotz,x
	a8

;-----------------------------------------------------------------------------
	ldy	demoshapeptr
;-----------------------------------------------------------------------------
	stz	smvar_byte1
;-----------------------------------------------------------------------------
	s_jsl	Xanglexy_l
	a16
	nega
	sta	x2
	a8
;-----------------------------------------------------------------------------
	s_jsl	Yanglexy_l
	a16
	sta	y2
	a8
;-----------------------------------------------------------------------------
	a16
	lda	x2
	asra
	sta	x2	;al_rotx,x
	a8

	s_achase_alvar	W,x,al_rotx,x2,1
	s_achase_alvar	W,x,al_roty,y2,1

	a16
	lda	#0
	sta	al_rotz,x
	a8

;-----------------------------------------------------------------------------
	s_pull_obj		x

	PULLYP

	rts








dv_turnaroundobj_005	; in al_pbyte1

	s_start_strat


	toheap	y,x
	a16
	lda	exal_worldyoffset,y
	sta	y1
	a8

	pl_ldy_viewblk	x

;;	lda	al_roty,x
;;	sta.w	al_pbyte1,y

	s_set_var	W,x1,#0
	s_set_var	W,y1,#-50
	s_set_var	W,z1,#-200

	lda	al_roty,x
	sta	tpy

	jmp		dv_turnaroundobj


dv_turnaroundobj_004	; in al_pbyte1

	s_start_strat

	PHY
	toheap	y,x
	a16
	lda	exal_camZofs_gone,y
	clc
	adc	#-5
	sta	z1
	sta	exal_camZofs_gone,y
	a8
	PLY

	bra	dv_turnaroundobj_003.enter


dv_turnaroundobj_003	; in al_pbyte1

	s_start_strat

	s_set_var	W,z1,#-200

.enter	LOCAL

	s_set_var	W,x1,#0
	s_set_var	W,y1,#-50

	sp_jmp_playertype	x,ARWING,.aw
	s_set_var	W,z1,#-80<<1
	s_set_var	W,y1,#-40
.aw
	jmp	dv_turnaroundobj



dv_turnaroundobj	; in al_pbyte1

	; in al_pbyte1
		; x1	offsetx
		; y1	offsety
		; z1	offsetz
	s_start_strat
	phy
	phx
	ldy	dummyobj

	lda	al_roty,x
	sta	tpy

	pl_ldx_viewblk	x

	lda	playerctlmode
	cmp	#map_room
	beq	.noturn

	lda	al_pbyte1,x
	sec
	sbc	#1
	sta	al_pbyte1,x

.noturn	lda	al_pbyte1,x
;	clc
;	adc	tpy
	sta.w	al_roty,y
	lda	#0
	sta.w	al_rotx,y

	plx

	c_add_roffs2pos16	W,y,x,y,x1,y1,z1,0,1,0

	phx

	pl_ldx_viewblk	x

	s_copy_pos	x,y

;	s_achase_alvar2alvar	W,x,al_worldx,y,al_worldx,1
;	s_achase_alvar2alvar	W,x,al_worldy,y,al_worldy,1
;	s_achase_alvar2alvar	W,x,al_worldz,y,al_worldz,1


	s_set_alvar	W,x,al_rotx,#-10*256
	bra		.space

.nox	s_set_alvar	W,x,al_rotx,#0

.space	pl_test_planetmode	space
	beq	.nolmt
	s_jmp_higher	x,#-10H,.nolmt
	s_set_alvar	W,x,al_worldy,#-10H

.nolmt	plx
	ply
	rts

;---------------------------------------------------------------------------------------
dv_turninit	; turn mode no initial

	s_start_strat

	PHY

	stx	demoshapeptr

	toheap	y,x

;	lda.w	exal_roty+1,y
;	sta	y1

	pl_ldy_viewblk	x

;	lda	y1

	lda.w	al_roty+1,y
	nega
	sta.w	al_pbyte1,y

	a16
	lda	#0
	sta.w	al_pword1,y
	a8

	PLY

	rts

;---------------------------------------------------------------------------------------
dv_copyplrxzvecs

	PUSHXYP

	toheap	y,x

	pl_ldx_viewblk	x

	a16
	lda	exal_vx,y
	sta	al_vx,x
	lda	exal_vy,y
	sta	al_vy,x
	lda	exal_vz,y
	sta	al_vz,x
	a8

	PULLXYP

	rts


;---------------------------------------------------------------------------------------
dv_turnaroundobj_demoshape	; in al_pbyte1

	; in al_pbyte1
		; x1	offsetx
		; y1	offsety
		; z1	offsetz

	s_start_strat

	phy
	phx
	ldy	dummyobj

	a16
	lda	clrdemoshape_x
	sta.w	al_worldx,y
	lda	clrdemoshape_y
	sta.w	al_worldy,y
	lda	clrdemoshape_z
	sta.w	al_worldz,y
	a8

	s_jsl	anglexy_l
	a8
	xba
	nega

	sta.w	al_roty,y	; roty
	sta	tpy


	ldx	#viewblk1



; check timer
	lda	al_pword1,x
	cmp	#15
	bmi	.noface

.facenorm	lda	#1	;no
.face	sta	y1

	sm_Fchase_alvar	B,x,al_pbyte1,tpy,y1

.noface

	lda	al_pbyte1,x
	sta.w	al_roty,y


	lda	#0
	sta.w	al_rotx,y
	lda	#0
	sta.w	al_rotz,y

	a16

	lda	player1_worldx
	sta.w	al_worldx,y
	lda	player1_worldy
	sta.w	al_worldy,y
	lda	player1_worldz
	sta.w	al_worldz,y

	PHX

	ldx	#0

	lda	kw_gametimer
	bit	#0fffeh
	beq	.gettab

	ldx	#4

.gettab	lda.l	.postab+0,x
	sta	y1
	lda.l	.postab+2,x
	sta	z1
	PLX

	a8

	c_add_roffs2pos16	W,x,y,y,#0,y1,z1,0,1,0

	plx
	ply
	rts


.postab
	dw	20	;y
	dw	-120	;z

	dw	-50	;y
	dw	-150	;z

;---------------------------------------------------------------------------------------
dv_corepos

	s_start_strat

	PUSHXYP

	ldx	dummyobj

	a16
	lda	corex
	sta	al_worldx,x
	lda	corez
	sta	al_worldz,x
	lda	#0
	sta	al_worldy,x
	a8
	lda	coreroty
	sta	al_roty,x
	lda	#0
	sta	al_rotx,x
	sta	al_rotz,x

	ldy	#viewblk1

	s_add_roffs2pos	B,y,x,x,#0,#-60,#60,0,1,0,4,2,4

	a16
	lda.w	al_worldx,y
	sta	x1
	lda.w	al_worldy,y
	sta	y1
	lda.w	al_worldz,y
	sta	z1

	lda.w	al_ox,y
	sta.w	al_worldx,y
	lda.w	al_oy,y
	sta.w	al_worldy,y
	lda.w	al_oz,y
	sta.w	al_worldz,y

	a8

	s_achase_alvar	W,y,al_worldx,x1,4
	s_achase_alvar	W,y,al_worldy,y1,4
	s_achase_alvar	W,y,al_worldz,z1,4

	PULLXYP

	rts


;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

	end
