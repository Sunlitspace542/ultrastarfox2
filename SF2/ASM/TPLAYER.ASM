;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º FILE:                TPLAYER.ASM                          º
;º AUTHOR:              Takumi Kawagoe   Nintendo.co.ltd  EDAº
;º DESCRIPTION:         PLAYER CONTROL ROUTINE               º
;º DATE CREATED:        ?-3-93                               º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

	INCPUB	tplayer

AMCTL	EQU	1	; 0:left right turn    1: tleft tright turn)

	SHORTA
	LONGI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
bit0	equ	1
bit1	equ	2
bit2	equ	4
bit3	equ	8
bit4	equ	16
bit5	equ	32
bit6	equ	64
bit7	equ	128

;LRtrig_lastLR	equ	1<<7	;1 tright 0: tleft
;LRtrig_lastL		equ	1<<6	;last key
;LRtrig_lastR		equ	1<<5	;last key
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; --- Transform anim pattern ---
a_wing_0_maxframe	equ	7
a_wing_1_maxframe	equ	6+1
b_wing_0_maxframe	equ	7
b_wing_1_maxframe	equ	6+1
c_wing_0_maxframe	equ	7
c_wing_1_maxframe	equ	6+1
ar_ufo_0_maxframe	equ	7
ar_ufo_1_maxframe	equ	6+1
b_ufo_0_maxframe	equ	7
b_ufo_1_maxframe	equ	6+1
c_ufo_0_maxframe	equ	7
c_ufo_1_maxframe	equ	6+1
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

tarwing_exalvar_init

	PUSHYP

	a8i16

	toheap	y,x

	jsr	clear_exalvars

;-----------------------------------------------------------------------------
.enter	LOCAL

	s_set_alvar	B,y,exal_boost,#0
	s_set_alvar	B,y,exal_brake,#0

	s_set_alvar	W,y,exal_enemyaltmeter_objptr,#0

	s_copy_alvar2alvar	B,y,exal_rotx+1,x,al_rotx
	s_copy_alvar2alvar	B,y,exal_roty+1,x,al_roty
	s_copy_alvar2alvar	B,y,exal_rotz,x,al_rotz

;-----------------------------------------------------------------------------
; battle mode no toki weapon level wa 0 ni suru....

;	sm_jmp_if1screen	.notbattle
;	lda		#exal_weap_level_0
;	sta		exal_weap_level,y
;.notbattle

;-----------------------------------------------------------------------------

	PULLYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Initial Weapon Status
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

weap_init

	PUSHYP

	toheap	y,x

	a8i16

	s_set_alvar	B,y,exal_weap_level,p1_weap_level
	s_set_alvar	B,y,exal_spweap_type,p1_spweap_type
	s_set_alvar	B,y,exal_spweap_LMT,p1_spweap_LMT

;************

;	s_jmp_alsflag	x,player2,.p2
;
;
;.p1	s_set_alvar	B,y,exal_weap_level,p1_weap_level
;	s_set_alvar	B,y,exal_spweap_type,p1_spweap_type
;	s_set_alvar	B,y,exal_spweap_LMT,p1_spweap_LMT
;
;	bra		.exit
;
;.p2	s_set_alvar	B,y,exal_weap_level,p2_weap_level
;	s_set_alvar	B,y,exal_spweap_type,p2_spweap_type
;	s_set_alvar	B,y,exal_spweap_LMT,p2_spweap_LMT

.exit	PULLYP

	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Structure clear
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; structure clear

clear_exalvars

	PUSHXYP

	a8i16

	toheap	y,x

	ldx	#0
	lda	#0
.loop	sta	exal_start,y
	iny
	inx
	cpx	#playerheap_sizeof
	bne	.loop

	PULLXYP

	rts

; structure clear

clear_exalvars_2

	PUSHXYP

	a8i16

	toheap	y,x

	lda	#0
	ldx	#0

.loop	sta	exal_start,y
	iny
	inx
	cpx	#playerheap_clear_sizeof
	bne	.loop

	PULLXYP

	rts
;-----------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Restart init
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

restart_exalvar_init

	PUSHYP
	a8i16
	toheap	y,x

	a16
	lda	#0
	sta	exal_camXofs,y
	sta	exal_camXofsbuf,y
	sta	exal_sidevel,y

	a8
	lda	#0
	sta	exal_dmgeffect,y
	sta	exal_weap_level,y
	sta	exal_boostheatup,y

;transform on!

	s_and_alvar	B,y,exal_CTLtype,#(exal_CTLtype_notrans!exal_CTLtype_notransreally)^-1

;shield off

	jmp	tarwing_exalvar_init.enter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; ARWING init exalvar
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;	SHORTA
;	LONGI
;
;Arwing0_exalvar_init
;
;	php
;	a8i16
;	jsr		GENERAL_exalvar_init
;	plp
;
;	rts
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; ARMER init exalvar
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

Armer0_exalvar_init

	PUSHYP

	a8i16

	toheap	y,x

	a16
	lda	#0
	sta	exal_rotyoffset,y		; shake
	a8
	jsr	GENERAL_exalvar_init

	s_or_alvar	B,y,exal_CTLtype,#exal_CTLtype_automatic

	PULLYP

	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; ROBOT init exalvar
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

Robo0_exalvar_init

	PUSHYP

	a8i16

	s_set_alvar	B,x,al_pbyte1,#0	; for roboFBLRflag

	toheap		y,x

; init position

	s_copy_alvar2alvar	W,y,exal_bodyworldy,x,al_worldy

	a16
	lda	#0
	sta	exal_jmpvel,y
	sta	exal_rotyoffset,y	; shake
	a8

	sta	exal_rotzoffset,y
	sta	exal_rotzofscounter,y	; counter of Arwing's shaking
	sta	exal_worldyofscounter,y	; counter of Arwing's shaking data
	sta	exal_acclroty,y		; shake
	sta	exal_robostatus,y
	sta	exal_robostatus2,y
	sta	exal_robostatustrig,y
	sta	exal_jmpstatus,y
	sta	exal_jmpstatus2,y
	sta	exal_jmpcounter,y
	sta	eal_pbyte1,y		; jmp flag
	sta	exal_gravcounter,y

	s_and_alvar	B,y,exal_control,#exal_control_RBmask

	s_set_alvar	W,y,exal_acclroty,#0
	s_set_alvar	W,y,exal_gravity,#400H


	s_set_alvar	W,y,exal_camlookYofs,#RBcameralookYofs_no


;	sm_jmp_if2screen	.two
;.one	s_set_alvar	W,y,exal_camlookYofs,#RBcameralookYofs_no
;	bra		.vv
;.two	s_set_alvar	W,y,exal_camlookYofs,#RBcameralookYofs_no_2
;.vv

	s_add_alvars	W,y,exal_camlookYofs,y,exal_camlookYofs_ext

	jsr		GENERAL_exalvar_init

	PULLYP

	rts


	SHORTA
	LONGI

GENERAL_exalvar_init

	PUSHYP

	a8i16

	toheap	y,x

; copy real pos

	a16
	lda	al_worldx,x
	sta	exal_worldx,y
	lda	al_worldy,x
	sta	exal_worldy,y
	lda	al_worldz,x
	sta	exal_worldz,y
	a8

	s_set_alvar	B,y,exal_weaponstatus,#0
	s_set_alvar	B,y,exal_SPweaponstatus,#0
	s_set_alvar	B,y,exal_rollingstatus,#0

	lda	#0
	sta	exal_RBrollingoffset,y
	sta	exal_shockvel,y
	sta	exal_laser_LMT,y
	sta	exal_animflag,y
	sta	exal_animdush,y
	sta	exal_jetrot,y
	sta	exal_jetrotx,y
	sta	exal_jetroty,y
	sta	exal_jetrotoffset,y
	sta	exal_motionNo,y
	sta	exal_motiondir,y
	sta	exal_camupdw,y
	sta	exal_vel,y
	sta	exal_hit_framecount,y
	sta	exal_bodyofsy,y
	sta	exal_bodyfloatofsy,y
	sta	exal_bodyofsymotion,y
	sta	exal_jetstatus,y
	sta	exal_jetstatus2,y
	sta	exal_poolofsy,y
	sta	exal_sidevelcounter,y

	a16
	lda	#0
	sta	exal_vyold,y
	sta	exal_vx,y
	sta	exal_vy,y
	sta	exal_vz,y
	sta	exal_jetLobjptr,y
	sta	exal_jetRobjptr,y
	sta	exal_pooldepth,y
	sta	exal_slopenumB,y
	sta	exal_slopenumL,y
	sta	exal_slopenumR,y
	sta	exal_worldxoffset,y
	sta	exal_worldyoffset,y
	sta	exal_worldzoffset,y
	sta	exal_camZofs_tame,y

	PULLYP
	rts

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³  parameter table  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

speed_tab
	pilottab	B,speed_aw

speedspace_tab
	pilottab	B,speedspace_aw

;speed_battle_tab
;	pilottab	B,speed_battle_aw
;
;speedspace_battle_tab
;	pilottab	B,speedspace_battle_aw

speedmax_tab
	pilottab	B,boostspeed_aw

speedmax_room_tab

	pilottab	B,boostspeed_room_aw

speedmin_tab
	pilottab	B,brakespeed_aw

speedlr_tab
	pilottab	B,brakeTspeed_aw

speedspacemax_tab
	pilottab	B,boostspeedspace_aw


;*******************************************************************
;*******************************************************************
;
;	TRANSFORM PROG
;
;*******************************************************************
;*******************************************************************
;-------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ARMER --> ARWING³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRanmAM2AW_A_WING

	traniminc	a_wing_0,a_wing_1,a_wing,0,cs_Arwing_init	;fl_AM2AW

TRanmAM2AW_B_WING

	traniminc	b_wing_0,b_wing_1,b_wing,0,cs_Arwing_init	;fl_AM2AW

TRanmAM2AW_C_WING

	traniminc	c_wing_0,c_wing_1,c_wing,0,cs_Arwing_init	;fl_AM2AW

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ARWING --> ARMER³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRanmAW2AM_A_WING

	tranimdec	a_wing_1,a_wing_0,a_robo,1,is_Armer_init	;fl_AW2AM

TRanmAW2AM_B_WING

	tranimdec	b_wing_1,b_wing_0,b_robo,1,is_Armer_init	;fl_AW2AM

TRanmAW2AM_C_WING

	tranimdec	c_wing_1,c_wing_0,c_robo,1,is_Armer_init	;fl_AW2AM

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ARWING --> ROBOT³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRanmAW2RB_A_WING

	tranimdec	a_wing_1,a_wing_0,A_WING_0,1,of_robo_init	;fl_AW2RB

TRanmAW2RB_B_WING		;B-WING --> B-ROBO

	tranimdec	b_wing_1,b_wing_0,B_WING_0,1,of_robo_init	;fl_AW2RB

TRanmAW2RB_C_WING		;C-WING --> C-ROBO

	tranimdec	c_wing_1,c_wing_0,C_WING_0,1,of_robo_init	;fl_AW2RB


;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ROBOT --> ARWING³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


TRanmRB2AW_A_WING

	traniminc	a_wing_0,a_wing_1,a_wing,0,of_arwing_init	;fl_RB2AW

TRanmRB2AW_B_WING

	traniminc	b_wing_0,b_wing_1,b_wing,0,of_arwing_init	;fl_RB2AW


TRanmRB2AW_C_WING

	traniminc	c_wing_0,c_wing_1,c_wing,0,of_arwing_init	;fl_RB2AW




	SHORTA
	LONGI

;---------------------------------------------------------------------

PLR_TRANIMTBL

	;anim0 shape		,2 0
	;amim0 maxframe		,1 2
	;anim0 final value	,1 3
	;anim0 inc   value	,1 4
	;anim0 init  value	,1 5

	;anim1 shape		,2 6
	;amim1 maxframe		,1 8
	;anim1 final value	,1 9
	;anim1 inc   value	,1 10
	;anim1 init  value	,1 11

	;next mode		,2 12
	;next shape		,2 14
	;next anim init value	,1 16

; ARWING --> ROBOT(WALKER)

TRanmAW2RB_TAB

	DW	TRanmAW2RB_A_WING&WM	; FOX
	DW	TRanmAW2RB_A_WING&WM	; FALCO
	DW	TRanmAW2RB_C_WING&WM	; PEPPY
	DW	TRanmAW2RB_C_WING&WM	; SLIPPY
	DW	TRanmAW2RB_B_WING&WM	; GAL1
	DW	TRanmAW2RB_B_WING&WM	; GAL2


; ROBOT(WALKER) --> ARWING

TRanmRB2AW_TAB

	DW	TRanmRB2AW_A_WING&WM	; FOX
	DW	TRanmRB2AW_A_WING&WM	; FALCO
	DW	TRanmRB2AW_C_WING&WM	; PEPPY
	DW	TRanmRB2AW_C_WING&WM	; SLIPPY
	DW	TRanmRB2AW_B_WING&WM	; GAL1
	DW	TRanmRB2AW_B_WING&WM	; GAL2


; ARWING --> ARMER(UFO)

TRanmAW2AM_TAB

	DW	TRanmAW2AM_A_WING&WM	; FOX
	DW	TRanmAW2AM_A_WING&WM	; FALCO
	DW	TRanmAW2AM_C_WING&WM	; PEPPY
	DW	TRanmAW2AM_C_WING&WM	; SLIPPY
	DW	TRanmAW2AM_B_WING&WM	; GAL1
	DW	TRanmAW2AM_B_WING&WM	; GAL2


; ARMER(UFO) --> ARWING

TRanmAM2AW_TAB

	DW	TRanmAM2AW_A_WING&WM	; FOX
	DW	TRanmAM2AW_A_WING&WM	; FALCO
	DW	TRanmAM2AW_C_WING&WM	; PEPPY
	DW	TRanmAM2AW_C_WING&WM	; SLIPPY
	DW	TRanmAM2AW_B_WING&WM	; GAL1
	DW	TRanmAM2AW_B_WING&WM	; GAL2



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
; ARWING to WALKER!	ar_wa_0(11) & ar_wa_1(12)
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

TRANS_AW2RB_CTL_l

;Trans_Arwing2Robo		; ARWING --> ROBOT

	PUSHYP

	a8i16

	pl_Sboost	x,off

	jsr		trans_aw2rb_lrlr_srou
	jsr		T_AW_RB_mainpros

	pl_jmp_timerLESS	x,#waittransform,.exit

; animate into a walker #1

	toheap		y,x

	t_tranim_do	x,TRanmAW2RB_TAB,y

.exit
	PULLYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

TRANS_RB2AW_CTL_l		; ROBOT  --> ARWING

	PUSHYP

	a8i16

	pl_Sboost	x,off

	jsr	trans_rb2aw_lrlr_srou

	jsr	T_AW_RB_mainpros

	jsr	set_worldxyz2exal_srou

	pl_jmp_timerLESS	x,#waittransform,.exit

; animate into a walker #1

	toheap		y,x

	t_tranim_do	x,TRanmRB2AW_TAB,y

; del obj
	s_push_obj	x

.R	ldx		exal_jetRobjptr,y
	beq		.L
	s_set_alvar	W,x,al_shape,#nullshape
.L	ldx		exal_jetLobjptr,y
	beq		.B
	s_set_alvar	W,x,al_shape,#nullshape
.B

.E	s_pull_obj	x

.exit	PULLYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

TRANS_AW2AM_CTL_l		; ARWING --> ARMER

	s_start_strat

	PUSHYP

	a8i16

	toheap		y,x

	pl_Sboost	x,off

	t_tranim_do	x,TRanmAW2AM_TAB,y

	s_achase_alvar	B,x,al_vel,#0,3

	jsr	T_AW_AM_mainpros

.exit	PULLYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


	SHORTA
	LONGI

TRANS_AM2AW_CTL_l		; ARMER --> ARWING

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x

	pl_Sboost	x,off

	t_tranim_do	x,TRanmAM2AW_TAB,y

	s_achase_alvar	B,x,al_vel,#30,3

	jsr		T_AW_AM_mainpros

	pl_jet		x,off,y

.exit	PULLYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	SHORTA
	LONGI
;-------------------------------------------------------------------
T_AW_RB_mainpros

	jsr	TRANSworldy_srou	; set worldy
	jsr	SET_AW_ALVARS	;(on FIELD)
	bra	TRANSgpros

;-------------------------------------------------------------------
T_AW_AM_mainpros

	s_achase_alvar	W,y,exal_rotztilt,#0,2
	s_achase_alvar	B,y,exal_rotztend,#0,2
	s_achase_alvar	B,y,exal_rotzoffset,#0,2
	s_achase_alvar	B,y,exal_rotzhit,#0,2
	s_achase_alvar	B,y,exal_rotz,#0,2

	jsr	SET_AW_ALVARS	;(in space)

;-------------------------------------------------------------------
TRANSgpros

	jsr	TRANS_ALVARS

	jsr	ARWINGaddvecs_srou

	s_achase_alvar	B,x,al_vel,#0,3

	pl_Sboost	x,off
	ldy	al_sword2,x
	s_achase_alvar		W,y,exal_camrotx,#0,3
	jsl	blockmap_srou_l
	rts


INTERDEMO_ALVARS

	PUSHYP

	a8i16

	ramnastyoff

	lda	#0
	sta.l	m_dustflags

	ramnastyon


; -- rotation parameters >>#0 --

	s_set_var	W,inc_rotx,#0
	s_set_var	W,inc_roty,#0
	s_set_var	W,inc_rotz,#0

	toheap	y,x

	jsr	clear_exalvars_2

	jsr	weap_init

	a16
	lda	#0
	sta	al_mx,x
	sta	al_my,x
	sta	al_mz,x
	sta	al_ox,x
	sta	al_oy,x
	sta	al_oz,x
	a8


	pl_clr_intheseaflag	x

; planet mode(default)

	pl_planetmode	ground

	PULLYP
	rts



;-------------------------------------------------------------------

	SHORTA
	LONGI

TRANS_ALVARS
	PUSHYP

	a8i16


	stz	p1_firerotx


; -- rotation parameters >>#0 --

	s_set_var	W,inc_rotx,#0
	s_set_var	W,inc_roty,#0
	s_set_var	W,inc_rotz,#0

	toheap	y,x

	pl_ROLLINGshield	x,off,y

; byte alvars

	lda	#0
	sta	exal_boostheatup,y
	sta	exal_RBrollingoffset,y
	sta	exal_rollingoffset,y
	sta	exal_rollingstatus,y
	sta	exal_dushcounter,y

	ta_alvar2zero	y,exal_rotxoffset,62
	ta_alvar2zero	y,exal_inccamrotz,62
	ta_alvar2zero	y,exal_rotz,62

	a16

; word alvars

	ta_alvar2zero	y,exal_rotyoffset,62
	ta_alvar2zero	y,exal_camrotz,62
	ta_alvar2zero	y,exal_acclroty,62
	ta_alvar2zero	y,exal_camRotXofs,62	; Camera rotation offset
	ta_alvar2zero	y,exal_camRotYofs,62	; Camera rotation offset

	a8

	pl_ldy_viewblk		x
	s_achase_alvar		W,y,al_rotx,#0,3

;off boost
	s_achase_alvar		B,x,al_rotz,#0,2

	pl_Sboost		x,off

	PULLYP
	rts


;-------------------------------------------------------------
.perc62B
	a8
	asra
	sta	tpx
	asra
	asra
	clc
	adc	tpx
	rts

.perc62W
	a16
	asra
	sta	tpx
	asra
	asra
	clc
	adc	tpx
	rts

;---------------------------------------------------------------------


	SHORTA
	LONGI

initPLR_TRANSANIM_l
;	in	x1 : data table address

	php
	a8i16

	s_push_obj	x
;---------------------------------------------------------------------

	phy

	toheap	y,x

	a16
	lda	exal_pilotNo,y
	and	#exal_pilotNo_plmask
	asl	a
	tay

	lda	[x1],y

	tax

	a8
	ply

;---------------------------------------------------------------------

	a16
	lda.l		PLR_TRANIMTBL&0ff0000H+0,x	; anim0 shape
	sta		work0
	a8
	lda.l		PLR_TRANIMTBL&0ff0000H+5,x	; anim0 init value
	sta		work1

	s_pull_obj	x

	s_set_alvar	W,x,al_shape,work0
	s_init_anim	x,work1

	plp
	rtl


	SHORTA
	LONGI



PLR_TRANSANIM_l
		; In	: idy(data pointer)
		;	: nextmode
		;	: anim0_maxframe
		;	: anim0_minframe
		;	: anim1_maxframe
		;	: anim1_minframe
	phx
	phy
	php
	a8i16

	toheap	y,x

	km_jmpnotflag	exal_transflag,exal_transflag_transanm1_flag,.RoboAnm2,y

;***********************************************
;	lda	gameframe	;winctimer
;	bit	#15
;	rlbne	.exit
;***********************************************

	s_push_obj	x
	ldx	name
	lda.l		PLR_TRANIMTBL&0ff0000H+2,x	; anim0 MAX   frame
	sta		work0
	lda.l		PLR_TRANIMTBL&0ff0000H+4,x	; anim0 inc   value
	sta		work1
	lda.l		PLR_TRANIMTBL&0ff0000H+3,x	; anim0 final value
	sta		work2
	s_pull_obj	x

	s_add_anim	x,work1,work0
	s_cmp_anim	x,work2
	rlbne	.exit

.setother
	phx
	ldx	name
	lda.l		PLR_TRANIMTBL&0ff0000H+6,x	; anim1 shape
	sta		work0
	lda.l		PLR_TRANIMTBL&0ff0000H+7,x	; anim1 shape
	sta		work0+1
	lda.l		PLR_TRANIMTBL&0ff0000H+11,x	; anim1 init value
	sta		work1
	plx

	km_clrflag	exal_transflag,exal_transflag_transanm1_flag,y
	s_set_alvar	W,x,al_shape,work0
	s_init_anim	x,work1
	jmp		.exit

; animate into a walker #2

.RoboAnm2
;***********************************************
;	lda	gameframe	;winctimer
;	bit	#15
;	rlbne	.exit
;***********************************************

	phx
	ldx	name
	lda.l		PLR_TRANIMTBL&0ff0000H+8,x	; anim1 max frame
	sta		work0
	lda.l		PLR_TRANIMTBL&0ff0000H+10,x	; anim1 inc value
	sta		work0+1
	lda.l		PLR_TRANIMTBL&0ff0000H+9,x	; anim1 final value
	sta		work1
	plx

	s_add_anim	x,work0+1,work0
	s_cmp_anim	x,work1
	rlbne	.exit


.settowalker
	a16
	phx
	ldx		name

	lda.l		PLR_TRANIMTBL&0ff0000H+14,x	; next shape
	sta		work1
	a8
	lda.l		PLR_TRANIMTBL&0ff0000H+16,x	; next init value
	sta		work2

	lda.l		PLR_TRANIMTBL&0ff0000H+17,x	; sound
	sta		work3
	plx


; [next mode]

	jsr			getctldat_srou	; get next mode
	s_copy_var2var		W,work0,y1
	lda			exal_shapeNoNEXT,y
	and			#exal_shapeNo_ctmask^-1
	sta			exal_shapeNoNEXT,y

	s_copy_var2var		W,work0,y1

;testhiteruu	yooooooo-----nnn


	s_jmpNOT_alvarAND	B,y,exal_transflag,#exal_transflag_transanm2_flag,.exitse

	s_jmpNOT_alvarAND	B,y,exal_transflag,#exal_transflag_armode_flag,.RBse


.AWse	pl_SE_transEND	x,ARWING	;AW --> RB

	bra		.exitse

.RBse	pl_SE_transEND	x,ROBOT		;RB --> AW


.exitse	s_init_anim	x,work2
	s_set_alvar	W,x,al_shape,work1
	km_clrflag	exal_transflag,exal_transflag_transanm2_flag,y
	s_mode_change	x,work0


.exit

	plp
	ply
	plx
	rtl

;*******************************************************************
;*******************************************************************
;
;	PLAYER CONTROL
;
;*******************************************************************
;*******************************************************************
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
; Arwing's control(SPACE)
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
tutumax	equ	100
iac_vx	equ	work9
iac_vy	equ	work8
iac_vz	equ	work7


	SHORTA
	LONGI

INSPACE_ARMER_CTL_l

	a8i16

	toheap	y,x

;------------------------------------------------

	pl_Sboost	x,off

	a8
;------------------------------------------------
	pl_set_exalKEY


; lrlr
	s_set_alvar	B,y,exal_inccamrotz,#0

	ldy	#0
	sty	inc_rotx
	sty	inc_roty
	sty	inc_rotz

	jsr	trans_rb2aw_lrlr_srou
	jsr	CS_AW_UPDOWN
	jsr	SET_AW_ALVARS	;(in SPACE)

	s_set_alvar	B,x,al_vel,#0


	s_set_var	B,x1,#0
	s_set_var	B,y1,#0
	s_set_var	B,z1,#0


	testjoypad	down,pcont
	beq		.down_end
	s_set_var	B,y1,#-30
.down_end

	testjoypad	up,pcont
	beq		.up_end
	s_set_var	B,y1,#30
.up_end


	testjoypad	left,pcont
	beq		.left_end
	s_set_var	B,x1,#-30
.left_end
	testjoypad	right,pcont
	beq		.right_end
	s_set_var	B,x1,#30
.right_end


.vel	testjoypad	Y,pcont
	bne		.30
	testjoypad	A,pcont
	beq		.novel
	s_set_var	B,z1,#-30
	bra		.novel
.30	s_set_var	B,z1,#30

.novel
	s_add_roffs2pos	B,x,x,x,x1,y1,z1,0,1,0


;---------------------------------------------------------------------------------------

	pl_trans	x,CS_ARWING,transRobo2Arwing

	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;Arwing no kyo-tsu- no process
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AW_pros_srou

	php
	a8i16

	jsr	set_rollingstatus
	jsr	playerfloating_srou		; (player's furafura)
	jsr	ARWINGboost_srou
	jsl	ARWINGhit_surface_l

	jsr	set_Arwing_vel
	jsr	SET_AW_ALVARS
	jsr	ARWINGaddvecs_srou

;------------
;crash with enemy

	phy

	toheap	y,x

	lda	exal_shockvel,y
	rlbeq	.noshock

	s_set_alvar	B,x,al_pbyte1,#deg90
	s_add_alvars	B,x,al_pbyte1,x,al_roty

	lda	exal_shockvel,y
	sta	al_pbyte2,x

	s_gen_vecs	x,al_pbyte1,al_pbyte2
	s_add_vecs2pos	x
	s_Fchase_alvar	B,y,exal_shockvel,#0,20

.noshock	ply

;------------

	jsl	ARWINGhit_slope_l

	sm_jmp_if2screen	.exit

	jsl	noturnxlmt_srou_l

	jsl	blockmap_srou_l
	jsl	ARWINGhit_wall_l

.exit	plp
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
; Arwing's control(SPACE part2)
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

COSMO_ARWING_CTL_l

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x
.start
;------------------------------------------------
	pl_set_exalkey
;------------------------------------------------

;clear work RAM

	s_set_alvar	B,y,exal_inccamrotz,#0

	ldy	#0
	sty	inc_rotx
	sty	inc_roty
	sty	inc_rotz

	jsr	OF_AW_lrLR
	jsr	CS_AW_UPDOWN
	jsr	CS_AW_checkALT
	jsr	AW_pros_srou


;	IFNE	debuginfo
;	pl_trans	x,ARMER,transArwing2Robo
;	ENDC

	testjoypad	select,ptrig
	beq		.nobeep

	ksound	trans_unable

.nobeep
	PULLYP

	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
; Arwing's control(ON FIELD)
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

ONFIELD_ARWING_CTL_l

	PUSHYP

	a8i16

	toheap	y,x

.start
;------------------------------------------------

	jsl	checkYclip_srou_l

;------------------------------------------------

	pl_jmpnot_iftransrising	x,.nobubble,y

	jsl	makebubble_srou_l
.nobubble
;------------------------------------------------
OAC_entry
	pl_set_exalkey

;------------------------------------------------
;clear work RAM
	s_set_alvar	B,y,exal_inccamrotz,#0

	s_set_var	W,inc_rotx,#0
	s_set_var	W,inc_roty,#0
	s_set_var	W,inc_rotz,#0

	jsr	OF_AW_lrLR
	jsr	OF_AW_UPDOWN
	jsr	OF_AW_checkALT

	jsr	AW_pros_srou

	pl_trans	x,ROBOT,transArwing2Robo

	PULLYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
; check UP DOWN key routine
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


	SHORTA
	LONGI

CS_AW_UPDOWN	;(in space type B)

	PUSHYP

	a8i16

	toheap	y,x

	s_set_var	W,inc_rotx,#0

	pl_jmp_ifcontroloff	x,.exit,y

	s_or_alvar	B,y,exal_updown,#80H

	s_set_alvar	B,y,exal_inccamrotx,#0

.up	testjoypad		up,pcont
	s_beq			.exit_up
	s_copy_alvar2var	B,y,inc_rotx+1,exal_maxProtx
	bra	.exit

.exit_up

.down	testjoypad		down,pcont
	s_beq			.exit_dw
	s_copy_alvar2var	B,y,inc_rotx+1,exal_minProtx
	bra			.exit

.exit_dw

.no_keys

	s_copy_alvar2var	W,y,inc_rotx,exal_rotx
	;s_set_var		W,inc_rotx,#0

.exit	PULLYP
	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

OF_AW_UPDOWN	PUSHYP

	a8i16

	toheap		y,x

	s_set_alvar	B,y,exal_inccamrotx,#0
	s_set_var	W,inc_rotx,#0
	testjoypad	up,ptrig

	bne		.set_updownflag
	testjoypad	down,ptrig
	beq		.up_noclr

.set_updownflag

	s_or_alvar	B,y,exal_updown,#80H

.up_noclr

;----------------------------------------------------
.up	testjoypad		up,pcont
	s_beq			.exit_up

;------------------------------------
; wait camera's moving (uwcm)
;------------------------------------

	s_and_alvar		B,y,exal_updown,#80H^-1
	s_copy_alvar2var	B,y,inc_rotx+1,exal_maxProtx
	jmp	._add
.exit_up
;----------------------------------------------------

.down	TM_TESTEXBUTTON		x,down,y
	rlbeq	.no_keys

;------------------------------------
; wait camera's moving (dwcm)

.dwcm_skip2

;------------------------------------

	s_and_alvar	B,y,exal_updown,#80H^-1

.dwcm_skip3	s_and_alvar		B,y,exal_updown,#80H^-1
	s_copy_alvar2var	B,y,inc_rotx+1,exal_minProtx
	bra	._add
.exit_down

;----------------------------------------------------

.no_keys	s_and_alvar		B,y,exal_updown,#80H^-1
	s_set_alvar		B,y,exal_inccamrotx,#camrotxmid
	s_set_var		W,inc_rotx,#0

;----------------------------------------------------

._add

;----------------------------------------------------
; transrising?

	pl_jmpnot_iftransrising	x,.exit,y

	a16

	lda	#-50
	clc
	adc	SEADEPTH	;DDM
	sta	tpy

	a8

	s_jmp_higher	x,tpy,.exit
	s_set_var	W,inc_rotx,#0c000h

;----------------------------------------------------

.exit	PULLYP
	rts



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
; check left,right,L & R routine
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

;	Out:
;		exal_rotyoffset	W	player roty offset
;		exal_rotztend	B	rotz (push left right)
;		exal_rotztilt	W	rotz (push LR)
;		exal_control	B	last LR key flag
;		inc_camrotz	W	obj value
;		inc_roty	W	obj value

OF_AW_lrLR
	PUSHYP

	a8i16

; flag clear
	toheap	y,x

	pl_set_rotyoffset	x

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; sidevel counter
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	a16
	lda	#pad_left!pad_right
	bit	ptrig
	a8
	beq	.notrigsvc

	a16
	lda	ptrig	; pad_right=bit8 pad_left=bit9
	and	#pad_left!pad_right
	lsr	a
	lsr	a
	a8

	bra	.setsvc
.notrigsvc
;-------------------------------------------------------
	a16
	and	pcont
	a8
	beq	.endsvc

	lda	exal_sidevelcounter,y
	clc
	adc	#1
	bit	#20h
	beq	.setsvc

	lda	#01fh
.setsvc	sta	exal_sidevelcounter,y

.endsvc
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
.left	pl_jmp_NOTkeydown	left,pcont,.right

	s_inc_alvar	B,y,exal_sidevelcounter

	s_set_alvar	B,y,exal_inccamrotz,#-camrotzmax
	pl_jmp_keydown	tleft,pcont,.skip_left3
	pl_jmp_keydown	tright,pcont,.skip_left3
	s_bra		.skip_left2

;----------------------------------------------------
.skip_left3

; --- Brake turn ---

	ldy	al_sword2,x
	s_jmpNOT_alvarAND	B,y,exal_control,#exal_control_brake,.brake_off
.btonL
	pl_get_pilottab	W,x,inc_roty,rotyacclBRAKE_tab
;	s_set_var	W,inc_roty,#rotyacclBRAKE
	s_or_alvar	B,y,exal_control,#exal_control_brakeTurn
	jmp	.LR

; --- normal turn ---

.brake_off
	pl_get_pilottab	W,x,inc_roty,rotyacclLR_tab
	jmp	.LR
;----------------------------------------------------
.skip_left2
	pl_get_pilottab	W,x,inc_roty,rotyaccl_tab
	jmp	.add_shift
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
.right
	pl_jmp_NOTkeydown	right,pcont,.noleftright

	s_set_alvar	B,y,exal_inccamrotz,#camrotzmax
	pl_jmp_keydown	tleft,pcont,.skip_right3
	pl_jmp_keydown	tright,pcont,.skip_right3
	s_bra		.skip_right2

;----------------------------------------------------
.skip_right3

; --- Brake turn ---
	ldy	al_sword2,x
	s_jmpNOT_alvarAND	B,y,exal_control,#exal_control_brake,.brake_off2
.btonR
	pl_get_pilottab	W,x,inc_roty,rotyacclBRAKE_tab
	s_neg_var	W,inc_roty
	s_or_alvar	B,y,exal_control,#exal_control_brakeTurn
	jmp	.LR

; --- normal turn ---

.brake_off2
	pl_get_pilottab	W,x,inc_roty,rotyacclLR_tab
	s_neg_var	W,inc_roty
	jmp	.LR

.skip_right2
	pl_get_pilottab	W,x,inc_roty,rotyaccl_tab
	s_neg_var	W,inc_roty

;----------------------------------------------------

.add_shift
	jmp	.LR

;----------------------------------------------------
.noleftright

	s_set_alvar	B,y,exal_inccamrotz,#0	;camrotzmax

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

.LR	toheap	y,x

;--------------------------------------------------------------------------
; --- set exal_rotztend (rotZ offset when push left or right) ---

.rotzleftright

	pl_jmp_iftransform	x,.rotztend00
	pl_jmp_LRkeydown	pcont,.rotztend00

	a16
	lda	pcont
	bit	#pad_left!pad_right
	beq	.rotztend00
	bit	#pad_left
	bne	.rotztendleft

.rotztendright
	a8
	lda	#-30
	bra	.rotztend0
.rotztendleft
	a8
	lda	#30
	bra	.rotztend0
.rotztend00	a8
	lda	#0
.rotztend0	sta	z1

	s_achase_alvar	B,y,exal_rotztend,z1,3

.notend
;--------------------------------------------------------------------------
; --- set exal_rotztilt (rotZ offset when push tLeft or tRight) ---

	pl_jmp_iftransform	x,.noLRkeysS
	pl_jmp_LASTLRkey	x,.nhtl,.nhtr,.noLRkeys,y

.nhtl	a16
	lda			#deg45/3
	bra			.addtilt
.nhtr	a16
	lda			#-deg45/3
.addtilt	clc
	adc			exal_rotztilt,y
	sta			exal_rotztilt,y
	a8
	bra			.nhptc

.noLRkeysS	s_Achase_alvar		W,y,exal_rotztilt,#0,1
.noLRkeys	s_Achase_alvar		W,y,exal_rotztilt,#0,3
.nhptc	s_limit_alvar		W,y,exal_rotztilt,-deg90,deg90


;-------------------------------------------------------------------
; transform siteru toki wa camera no rotz wo 0 ni suru.

	pl_jmpnot_iftransform	x,.notrans

	s_set_alvar		B,y,exal_inccamrotz,#0

.notrans
;-------------------------------------------------------------------
; no turn mode no toki

	pl_jmp_ifturn		x,.nofturn

	jsr	.forceroty

;	a16
;	lda	exal_forceroty,y
;	and	#0ffH
;	xba
;	sta	y1
;	lda	exal_roty,y
;	sta	y2
;	a8
;
;	s_achase_alvar		W,y,exal_roty,y1,3
;
.nofturn

;-------------------------------------------------------------------
; set side vel

	a16
	lda	pcont
	bit	#pad_left!pad_right
	a8
	bne	.norm

	s_achase_alvar	W,y,exal_sidevel,#0,1

	bra		.exitsidevel

.norm	sp_jmpnot_playertype	x,ARWING,.exitsidevel

	lda	exal_rotyoffset+1,y
	asl	a
	asl	a
	sta	x1

	pl_get_pilottab	B,x,work0,awxofsvel_tab

	a16
	lda	work0	;side vel
	sexa
	sta	x2

	a8
	jsl	calc_sin16_l

	s_set_alvar	W,y,exal_sidevel,y1+1

.exitsidevel
;-------------------------------------------------------------------

	PULLYP

	rts





.forceroty	LOCAL

	s_start_strat

	a16
	lda	exal_forceroty,y
	and	#0ffH
	xba
	sta	y1
	lda	exal_roty,y
	sta	y2
	a8

	lda	exal_forceroty,y
	sec
	sbc	exal_roty+1,y
	asl	a
	sta	z1

	s_achase_alvar	B,y,exal_rotzhit,z1,2

	s_achase_alvar	W,y,exal_roty,y1,1
	s_achase_alvar	W,y,exal_rotyoffset,#0,1


.exitfy
	rts
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; data table

rotyacclUFO_tab
	pilottab	W,rotyacclUFO_

rotyaccl_tab
	pilottab	W,rotyaccl_

rotyacclLR_tab
	pilottab	W,rotyacclLR_

rotyacclBRAKE_tab
	pilottab	W,rotyacclBRAKE_

awxofsvel_tab
	pilottab	B,OF_AW_XOFSVEL_

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; set rolling status flag
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

set_rollingstatus

	PUSHYP

	a8i16

	toheap	y,x

; --- set rolling shield flag ---

	lda	exal_rollingoffset,y
	beq	.shieldoff

.shieldon	pl_ROLLINGshield	x,on,y
	bra			.send
.shieldoff	pl_ROLLINGshield	x,off,y

.send


; --- check rolling flag ---

	s_jmp_alvarNE		B,y,exal_rollingoffset,#0,.rolling

	s_and_alvar		B,y,exal_control,#exal_control_rolling^-1

; --- check trigger ---

	s_jmpNOT_varAND	B,ptrig,#pad_tleft!pad_tright,.inc
	s_copy_var2var	B,tpx,ptrig
	s_and_var	B,tpx,#pad_tleft!pad_tright

	lda	pcont
	and	#pad_tleft!pad_tright
	cmp	#pad_tleft!pad_tright
	rlbeq	.inc

	lda	exal_rollingstatus,y
	and	#pad_tleft!pad_tright
	cmp	tpx
	rlbne	.reset

; -- check counter ---

.set0
	lda	exal_rollingstatus,y
	and	#0fH
	cmp	#rollinginterval&0fH
	rlbcs	.reset

; --- set rolling offset ---

	pl_jmp_LASTLdown	x,.L,y

.R	s_set_alvar	B,y,exal_rollingoffset,#-20H
	bra	.set1
.L	s_set_alvar	B,y,exal_rollingoffset,#20H


; --- set rolling flag ---
.set1	a8

	s_or_alvar	B,y,exal_control,#exal_control_rolling

; --- trans lock timer off ---
;
;	lda	#0
;	sta	exal_translocktimer,y
;
; --- set rolling time ---

	lda	exal_rollingstatus,y
	and	#0f0H
	sta	exal_rollingstatus,y
	bra	.inc

;--------------------------------------------------

.reset
	lda	ptrig			; set last trigger
	and	#pad_tleft!pad_tright
	sta	tpx

	lda	exal_rollingstatus,y
	and	#(pad_tleft!pad_tright)^-1
	ora	tpx
	and	#0f0H			; clear low 4bit(counter)
	sta	exal_rollingstatus,y

	s_and_alvar	B,y,exal_control,#exal_control_rolling^-1

	bra	.exit

;--------------------------------------------------

.inc	lda	exal_rollingstatus,y	; inc low 4bit(counter)
	and	#0fH
	cmp	#15	;rollinginterval
	beq	.exit
	lda	exal_rollingstatus,y
	inc	a
.skip0	sta	exal_rollingstatus,y

.exit	PULLYP
	rts

;--------------------------------------------------

.rolling	a8
	s_jmp_alvarpl		B,y,exal_rollingoffset,.pl
	s_add_alvar		B,y,exal_rollingoffset,#2
	bra			.roll_f
.pl       	s_sub_alvar		B,y,exal_rollingoffset,#2

.roll_f	lda	exal_rollingstatus,y
	and	#0f0H
	ora	#00fH
	sta	exal_rollingstatus,y

.cont	PULLYP
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; set roty offset routine
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	SHORTA
	LONGI

;set Arwing's roty offset value(exal_rotyoffset)

set_rotyoffset_l

;	In	:y1(16bit) offset value(0-7fffH)
;	Out	:exal_rotyoffset(16bit)

	PUSHYP

	toheap	y,x

	s_set_var	B,y1+0,#0

	sp_jmp_playertype	x,UFO,.am0

	pl_jmpnot_ifturn	x,.aw1,y


	s_set_var	W,y2,#280h


.aw0	pl_get_pilottab	B,x,y1+1,.awtab
	bra		.turn
.aw1	pl_get_pilottab	B,x,y1+1,.awtab2
	bra		.turn

.am0
	s_set_var	B,y1+1,#OF_AM_ROTYOFS

.turn	s_jmp_varZERO		W,y1,.set

.left	pl_jmp_NOTkeydown	left,pcont,.right
	bra			.set
.right	pl_jmp_NOTkeydown	right,pcont,.nokey
	s_neg_var		W,y1
	bra			.set
.nokey

	s_set_var		W,y1,#0
	s_set_var		W,y2,#0


	s_set_alvar	W,y,exal_rotyoffsetaccel,#0


	jmp	.exit


.set	pl_jmp_ifturn		x,.a0,y
.a1	;s_fchase_alvar		W,y,exal_rotyoffset,y1,OF_AW_ROTYOFSinc
	;bra			.exit
.a0

;	s_achase_alvar		W,y,exal_rotyoffset,y1,3
;	s_achase_alvar		W,y,exal_rotyoffset,y1,4

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;
;	sp_jmp_ifcockpit	x,.noturbo,y
;
;	A16
;	LDA	EXAL_ROTYOFFSET,Y
;	BMI	.MIII
;
;.PLLL	LDA	Y1
;	BPL	.KKKK
;	;;;LDA	#0
;	;;;STA	EXAL_ROTYOFFSET,Y
;	BRA	.KKKK
;
;.MIII	LDA	Y1
;	BEQ	.KKKK
;	BMI	.KKKK
;	;;;LDA	#-1
;	;;;STA	EXAL_ROTYOFFSET,Y
;.KKKK
;	A8
;
;.noturbo
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

	s_achase_alvar		W,y,exal_rotyoffsetaccel,y2,2
	s_copy_alvar2var	W,y,y2,exal_rotyoffsetaccel

	sm_Fchase_alvar		W,y,exal_rotyoffset,y1,y2	;200h
;	s_Fchase_alvar		W,y,exal_rotyoffset,y1,200h



;miyamoto	s_achase_alvar		W,y,exal_rotyoffset,y1,4
;	s_achase_alvar		W,y,exal_rotyoffset,y1,2

.exit	PULLYP
	rtl


.awtab	pilottab	B,OF_AW_ROTYOFS_
.awtab2	pilottab	B,OF_AW_ROTYOFSnoturn_





;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
; check altitude routines
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; check limit of altitude for ON FIELD ARWING
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;	out	:	exal_vxvyvz
;		:	exal_xyzLMT

	SHORTA
	LONGI

OF_AW_checkALT

	PUSHYP
	a8i16

	toheap	y,x

	s_set_alvar	B,y,exal_vxvyvz,#exal_vxvyvz_ALL
	lda	#-30
	jsr	ARWING_altcheck_HIGH
	lda	#0
	jsr	ARWING_altcheck_LOW

.exit	PULLYP
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; check limit of altitude for COSMO ARWING
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	out	:	exal_vxvyvz
;		:	exal_xyzLMT

	SHORTA
	LONGI

CS_AW_checkALT

	PUSHYP
	a8i16

	toheap	y,x

	s_set_alvar	B,y,exal_vxvyvz,#exal_vxvyvz_ALL

	lda		#-10
	jsr		ARWING_altcheck_HIGHEX
	lda		#10
	jsr		ARWING_altcheck_LOWEX

	a16
	lda	pcont
	bit	#pad_up!pad_down
	a8
	bne	.exit

	s_achase_alvar	B,y,exal_rotxoffset,#0,2

.exit	PULLYP
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; --[ check HIGH limit]--
;-------------------------------------------------------------------
;	in	: 	idx player's pointer
;		:	idy player's heap pointer
;		:	inc_rotx(16bit)
;		:	exal_minPmoveY
;		:	A rotx offset max(8bit)
;		:	idY heap pointer
;	out	:	inc_rotx(16bit)
;		:	exal_rotxoffset(8bit)
;	set flag:	exal_xyzLMT_bottom
;		:	exal_inccamrotx
;	using	:	work0

osikomi	equ	32

ARWING_altcheck_HIGH

	PHP

	s_start_strat

	sta	work1	; rotx offset max

	s_and_alvar	B,y,exal_xyzLMT,#exal_xyzLMT_top^-1

;----------------------------------

.ckalt_high0
	a16
	lda	exal_maxPmoveY,y
	sec
	sbc	#osikomi
	clc
	adc	al_worldy,x
	sta	y1
	rlbpl	.ckalt_high1

.pullup0
	lda	inc_rotx
	bne	.ckalt_high1
	lda	#rotxpullup*100H
	sta	inc_rotx

;------------
.ckalt_high1
	lda	inc_rotx

	bpl	.exit_high
	beq	.exit_high

	lda	exal_maxPmoveY,y
	sta	atl_disty	;y1
	sec
	sbc	#64
	clc
	adc	al_worldy,x

	bpl	.exit_high
	nega
	sta	atl_disty	;y1

;-------------------------------------------------------------------
.caltplus	a8

	s_or_alvar	B,y,exal_xyzLMT,#exal_xyzLMT_top

	s_copy_var2var	W,work0,inc_rotx

	jsr		calc_pulluprotx_srou

	lda		gameframe
	and		#1
	beq		.exit

	s_Fchase_alvar	B,y,exal_rotxoffset,work1,1
	bra		.exit

.exit_high	a8
	s_jmp_alvarPL	B,y,exal_rotxoffset,.exit
	s_Fchase_alvar	B,y,exal_rotxoffset,#0,2
;-------------------------------------------------------------------
.exit	PLP
	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; --[ check LOW limit]--
;-------------------------------------------------------------------

ARWING_altcheck_LOW

atl_rxmax	equ	work9
atl_disty	equ	work8


	s_start_strat

	PHP

	sta			work1	; rotx offset max

	s_and_alvar	B,y,exal_xyzLMT,#exal_xyzLMT_bottom^-1


;----------------------------------

.ckalt_low0

	ai16

	lda			exal_minPmoveY,y
	clc
	adc			#osikomi
	clc
	adc			al_worldy,x
	bmi			.ckalt_low1
;	sta			atl_disty	;y1

.pullup0
;	a8
;
;	lda	exal_rotztend,y
;	asra
;	sta	tpz
;	asra
;	clc
;	adc	tpz
;	sta	exal_rotztend,y
;
;	a16

	lda			inc_rotx
	bne			.ckalt_low1
	lda			#-rotxpullup*100H
	sta			inc_rotx

;.ckalt_low0	a8
;	s_copy_alvar2var	W,y,y1,exal_minPmoveY
;	s_add_var		W,y1,#osikomi
;	s_varadd_alvar		W,x,y1,al_worldy
;	s_bmi			.ckalt_low1
;.pullup0	s_jmp_varNOTzero	W,inc_rotx,.ckalt_low1
;	s_set_var		W,inc_rotx,#-rotxpullup*100H

;----------------------------------

.ckalt_low1	a16
	lda			inc_rotx
	bmi			.exit_low
	beq			.exit_low

	lda			exal_minPmoveY,y
	clc
	adc			#110	;64	;*2
	clc
	adc			al_worldy,x
	bmi			.exit_low

	LSR		a

	sta			atl_disty

;----------------------------------
.caltplus	a8

	s_or_alvar	B,y,exal_xyzLMT,#exal_xyzLMT_bottom

	jsr		calc_pulluprotx_srou
	jsr		calc_pulluprotztend_srou


;	sp_jmp_playerctl	x,OF_ARWING,.exit,y
;
;	lda	gameframe
;	and	#1
;	beq	.exit
;
;	s_Fchase_alvar	B,y,exal_rotxoffset,atl_rxmax,1
	bra		.exit

.exit_low	a8
	s_jmp_alvarMI	B,y,exal_rotxoffset,.exit
	s_Fchase_alvar	B,y,exal_rotxoffset,#0,2
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.exit	PLP
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	PULL UP no tokino rotx,rotztend wo set suru...
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	in	idy : heap pointer
;		atl_disty	=al_worldx+minPmoveY+64

;	in,out	inc_rotx	(pulluprotx no toki)
;	in,out	exal_rotztend	(pulluprotztend no toki)


calc_pulluprotztend_srou


	s_start_strat

	s_copy_var2var	W,y1,atl_disty

	a16
	lda	exal_rotztend,y
	sexa
	sta	x2
	a8

	jsr	calc_pulluprotx_srou.calc

	lda	y1+1
	asl	a
	sta	exal_rotztend,y

.exit	rts




calc_pulluprotx_srou

	s_start_strat

	s_copy_var2var	W,y1,atl_disty
	s_copy_var2var	W,x2,inc_rotx

	jsr	.calc

	a16
	lda	y1+1
	sta	inc_rotx
	a8

	lda	#pullup_camrotx
	sta	exal_inccamrotx,y

.exit
	rts



.calc	LOCAL


;	in	y1 Y limit kara no kyori
;		x2 var
;	out	y1+1(16bit)


	s_jmpNOT_varAND	W,y1,#0ff80H,.skip0
	s_set_var	W,y1,#7fH		; max 7fH
.skip0
	s_push_obj	x
	ldx		y1
	a16
	lda.l		costab,x
	sexa
	sta		x1
	a8
	s_pull_obj	x

	jsl	Pcalc_muls161632_l

	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; --[ check HIGH limit]--
;-------------------------------------------------------------------

ARWING_altcheck_HIGHEX

;	idy:heap pointer

	s_start_strat

	PHP

	sta		work1

	s_and_alvar	B,y,exal_xyzLMT,#exal_xyzLMT_top^-1

	a16

;----------------------------------

.ckalt_high0

	lda		exal_maxPmoveY,y
	clc
	adc		al_worldy,x
	rlbpl		.exit

.ckalt_high1

	lda		inc_rotx
	rlbpl		.exit

	a8
	s_and_alvar	B,y,exal_vxvyvz,#exal_vxvyvz_vy^-1

	a16
	lda		inc_rotx
	asra
	sta		inc_rotx

	a8
	s_or_alvar	B,y,exal_xyzLMT,#exal_xyzLMT_top

	bra		ARWING_altcheck_LOWEX.chaserxofs


.exit	PLP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; --[ check LOW limit]--
;-------------------------------------------------------------------

ARWING_altcheck_LOWEX

	s_start_strat

	PHP

	sta			work1	; rotx offset max

	s_and_alvar		B,y,exal_xyzLMT,#exal_xyzLMT_bottom^-1

;----------------------------------
	a16
.ckalt_low0
	lda			exal_minPmoveY,y
	clc
	adc			al_worldy,x
	bmi			.exit

.ckalt_low1
	lda			inc_rotx
	bmi			.exit

	a8
	s_and_alvar		B,y,exal_vxvyvz,#exal_vxvyvz_vy^-1

	a16
	lda			inc_rotx
	asra
	sta			inc_rotx
	a8
	s_or_alvar		B,y,exal_xyzLMT,#exal_xyzLMT_bottom


.chaserxofs	LOCAL

	lda		gameframe
	and		#1
	beq		.exit
	s_Fchase_alvar	B,y,exal_rotxoffset,work1,1
	bra		.exit


.exit
	PLP

	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                            ³
;³    SET ARWING'S ALVARS     ³
;³                            ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

;------------------------------------------------------------------------
;-- rotX --
;	In:
;		inc_rotx		; W
;		exal_rotxoffset		; B for loop the loop
;	Out:
;		exal_rotx		; W rotx buffer
;		al_rotx			; B player rotx
;-- rotY --
;	In:
;		inc_roty		; W
;		exal_rotyoffset		; W push left right
;	Out:
;		exal_acclroty		; W
;		exal_roty		; W
;		al_rotx			; B
;-- rotz --
;	In:
;		exal_rotzoffset		; B shaking
;		exal_rollingoffset	; B rolling value(0-20H)
;		exal_rotztilt		; W push LR
;		exal_rotztend		; B push left right
;		exal_rotzhit		; when hit
;		inc_rotz		; no pros
;	Out:	exal_rotz		; B rotz buffer
;		al_rotz			; B player rotz
;
;------------------------------------------------------------------------
SET_AW_ALVARS

	PUSHXYP

	a8i16

	toheap	y,x


	s_achase_alvar	B,y,exal_rotyoffsetSHOCK,#0,2

.other

;--- rotx ---

; enter tutu mode?


	sp_jmp_playerctl	x,OF_ARWING,.ofix

.csix	s_achase_alvar		W,y,exal_rotx,inc_rotx,3
	bra			.ix
.ofix	s_achase_alvar		W,y,exal_rotx,inc_rotx,2

.ix
	pl_jmp_ifcontroloff	x,.normrotx,y
	sp_jmpNOT_ifcockpit	x,.normrotx,y

	s_copy_alvar2alvar	B,x,al_rotx,y,exal_camrotx+1
	s_neg_alvar		B,x,al_rotx

	lda			al_rotx,x
	asra
	asra
	clc
	adc			al_rotx,x
	sta			al_rotx,x

	bra	.exitrotx

.normrotx

	s_copy_alvar2alvar	B,x,al_rotx,y,exal_rotx+1
	s_add_alvars		B,x,al_rotx,y,exal_rotxoffset

.exitrotx
;--- roty ---

	pl_jmp_ifturn		x,.turnon,y
	s_copy_alvar2alvar	B,x,al_roty,y,exal_roty+1
	s_add_alvars		B,x,al_roty,y,exal_rotyoffset+1
	s_add_alvars		B,x,al_roty,y,exal_rotyoffsetSHOCK
	jmp			.exitroty

.turnon	s_copy_var2alvar	W,y,exal_acclroty,inc_roty
	s_add_alvar		W,y,exal_roty,inc_roty

.normroty

	s_copy_alvar2alvar	B,x,al_roty,y,exal_roty+1
	s_add_alvars		B,x,al_roty,y,exal_rotyoffset+1
	s_add_alvars		B,x,al_roty,y,exal_rotyoffsetSHOCK
	s_add_alvars		B,x,al_roty,y,exal_RBrollingoffset

.exitroty

; --- rotz ---

	pl_jmp_iftransform	x,.trrotz
	sp_jmp_playertype	x,ARWING,.dorotz

.trrotz	lda	al_rotz,x
	adiv2
	sta	al_rotz,x
	bra	.rotzend


.dorotz
	s_jmp_alvarNE		B,y,exal_rollingoffset,#0,.addroll

;	a16
	lda			exal_rotz,y
;	sexa

	adiv2
	sta	tpx
	adiv2
	clc
	adc	tpx

;	a8

	sta			exal_rotz,y
.addroll
	s_add_alvars		B,y,exal_rotz,y,exal_rollingoffset


	lda			exal_rotz,y
	clc
	adc			exal_rotzoffset,y
	clc
	adc			exal_rotztilt,y
	clc
	adc			exal_rotztend,y
	clc
	adc			exal_rotzhit,y
	sta			al_rotz,x

.rotzend

	PULLXYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
;	CLEAR DEMO(ARWING)
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;	SHORTA
;	LONGI
;
;DEMO_BATTLESTART_0_0_CTL_l
;
;	PUSHXYP
;
;	a8i16
;
;
;	ldy	#viewblk1
;
;	toheap	y,x
;
;WARNING	al_roty,exal_roty ha chart.asm de set shiteiru.
;
;	s_set_speed	x,#40
;	s_gen_3dvecs	x,al_roty,al_rotx,al_vel
;	s_add_vecs2pos	x
;
;	s_varadd_alvar	W,x,calcbuf,al_vy
;
;	PULLXYP
;	rtl
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
;	CLEAR DEMO(ARWING)
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	using	:	al_pbyte1 = state
;		:	al_pword1 = demo time counter
;
;awc_speed	equ	35
;
;
;	SHORTA
;	LONGI
;
;DEMO_AWCLEAR_0_0_CTL_l
;
;da00wait0	equ	100
;da00wait1	equ	10
;da00wait2	equ	120
;
;	PUSHYP
;
;	a8i16
;
;	toheap	y,x
;
;	s_set_alvar	B,x,al_vel,#30
;	s_set_alvar	B,y,exal_vel,#0
;
;	s_set_alvar	W,y,exal_rotyoffset,#0
;	s_achase_alvar	B,y,exal_rotx+1,#0,4
;	s_achase_alvar	B,y,exal_rotz+1,#0,3
;	s_jmp_higher	x,#-100,.norise
;	s_add_alvar	W,x,al_worldy,#-5
;
;.norise	jmp	DEMO_AWCLEAR_0_1_CTL_l.enter
;
;
;DEMO_AWCLEAR_0_1_CTL_l
;
;
;	PUSHYP
;
;	a8i16
;
;	toheap	y,x
;
;	pl_block	x,off,y
;	s_achase_alvar	B,y,exal_vel,#30,2
;	s_achase_alvar	B,y,exal_rotx+1,#-40H,2
;	s_achase_alvar	B,x,exal_rotz,#-30,2
;	s_achase_alvar	B,y,exal_rotyoffset+1,#-30,3
;	pl_Sboost	x,on
;
;.enter	LOCAL
;
;	jsr	playerfloating_srou	; (player's furafura)
;	jsr	SET_AW_ALVARS
;	jsr	ARWINGaddvecs_srou
;
;
;
;	PULLYP
;
;	rtl
;
;
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;  Add Arwing vector
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	SHORTA
	LONGI

ARWINGaddvecs_srou

	PUSHYP

aav_vx	equ	work9
aav_vy	equ	work8
aav_vz	equ	work7
aav_wx	equ	work6
aav_wy	equ	work5
aav_wz	equ	work4


	s_start_strat

	a8i16

	toheap			y,x


;************************
; room mode no slope
;
;	a16
;	lda	#0
;	sta	exal_slopeptrROOM,y
;	a8
;	sta	exal_slopetypeROOM,y
;
;************************

	pl_jmpnot_iftransrising		x,.start,y
	pl_jmp_ifinthesea	x,.inthesea
	s_set_alvar	B,x,al_vel,#20
.inthesea	s_and_alvar	B,y,exal_vxvyvz,#~(exal_vxvyvz_vx!exal_vxvyvz_vz)
	s_set_alvar	B,y,exal_vel,#0
	a16
	lda	#300
	clc
	adc	SEADEPTH	;DDM
	sta	tpy
	cmp	al_worldy,x
	a8
	bpl	.start
	s_set_alvar	B,y,exal_vel,#100

;************************

.start	km_jmpgameflag		freeze,.exit

	s_copy_alvar2var	B,y,x1,exal_vel

.enter	jsr			.addpros
	a16
	lda	al_vx,x
	sta	exal_vx,y

	lda	exal_vel-1,y	; BRAKE dattara VY ha tasanai.
	bpl	.addy0
	lda	#0
	bra	.addy1
.addy0	lda	al_vy,x
.addy1	sta	exal_vy,y

	lda	al_vz,x
	sta	exal_vz,y
	a8

	s_copy_alvar2var	B,x,x1,al_vel
	jsr			.addpros

	a16
	lda	al_vx,x
	clc
	adc	exal_vx,y
	sta	exal_vx,y
	lda	al_vy,x
	clc
	adc	exal_vy,y
	sta	exal_vy,y
	lda	al_vz,x
	clc
	adc	exal_vz,y
	sta	exal_vz,y


; Room mode?

	lda	playerctlmode
	and	#0ffh
	cmp	#map_room
	rlbeq	addroomvecs

	lda	exal_vx,y
	clc
	adc	al_worldx,x
	sta	al_worldx,x
	lda	exal_vy,y
	clc
	adc	al_worldy,x
	sta	al_worldy,x
	lda	exal_vz,y
	clc
	adc	al_worldz,x
	sta	al_worldz,x

	a8

;-----------------------------------------------------------------------------
; clear al_m*,al_o*

	a16
	lda	#0
	sta	al_mx,x
	sta	al_my,x
	sta	al_mz,x
	sta	al_ox,x
	sta	al_oy,x
	sta	al_oz,x
	a8

;-----------------------------------------------------------------------------
; ARWING'S side vel
	
;	lda	exal_sidevel,y
;	nega
;	sta	x1
;
;	s_add_roffs2pos	B,x,x,x,x1,#0,#0,0,1,0

.exit	PULLYP

	rts


.addpros	s_start_strat

	ldy	dummyobj

	s_set_alvar		B,y,al_vel,x1
	s_copy_rots		y,x

	s_push_obj		y
	ldy	al_sword2,x
	s_copy_alvar2var	B,y,x1,exal_rotx+1
	s_pull_obj		y
	s_set_alvar		B,y,al_rotx,x1

	s_exg_objs
	s_gen_3Dvecs		x,al_roty,al_rotx,al_vel
	s_exg_objs

	s_copy_vecs		x,y


	toheap		y,x

	s_jmp_alvarAND	B,y,exal_vxvyvz,#exal_vxvyvz_vx,.vxon
	s_set_alvar	W,x,al_vx,#0
.vxon
	s_jmp_alvarAND	B,y,exal_vxvyvz,#exal_vxvyvz_vy,.vyon
	s_set_alvar	W,x,al_vy,#0
.vyon
	s_jmp_alvarAND	B,y,exal_vxvyvz,#exal_vxvyvz_vz,.vzon
	s_set_alvar	W,x,al_vz,#0
.vzon


	rts










;-------------------------------------------------------------------
addroomvecs

	a16

; backup vector

	lda	al_vx,x
	sta	aav_vx
	lda	al_vy,x
	sta	aav_vy
	lda	al_vz,x
	sta	aav_vz

; add vy
	lda	exal_vy,y
	clc
	adc	al_worldy,x
	sta	al_worldy,x

; set mx,my,mz

	lda	exal_vx,y
	sta	al_mx,x
	clc
	adc	al_worldx,x
	sta	aav_wx

	lda	exal_vz,y
	sta	al_mz,x
	clc
	adc	al_worldz,x
	sta	aav_wz


	lda	exal_vx_gen,y
	sta	al_vx,x
	lda	exal_vz_gen,y
	sta	al_vz,x
	lda	#0
	sta	al_vy,x


	lda	#0
	sta	gd_gravity

;----------------------------------------------------------------------
; call generaldynamics_l

	a16

	lda	slopeptrold
	sta	al_slopeptr,x
	a8
	lda	slopenumold
	sta	al_slopenum,x

	PHY
	lda	#1
	jsl	generaldynamics_l
	PLY

	a16
	lda	al_slopeptr,x
	sta	slopeptrold
	a8
	lda	al_slopenum,x
	sta	slopenumold
	a16

;----------------------------------------------------------------------

	lda	al_vx,x
	sta	exal_vx_gen,y
	lda	al_vz,x
	sta	exal_vz_gen,y

; PULL vector

	lda	aav_vx
	sta	al_vx,x
	lda	aav_vy
	sta	al_vy,x
	lda	aav_vz
	sta	al_vz,x

;-------------------------------------------------------------------------

	a8

	lda	dynamflag
	bit	#4
	beq	.noeffect

	lda	exal_blockmapstatus,y
	ora	#exal_blockmapstatus_SE
	sta	exal_blockmapstatus,y

.noeffect
;-------------------------------------------------------------------------

	PULLYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;  Boost Process
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

ARWINGboost_srou

	php

	a8i16

	toheap	y,x


	lda	kenemynumber
	beq	.nokey

;----------------------------------
;check keys

	testjoypad	brake,ptrig
	bne		.tB
	testjoypad	boost,ptrig
	beq		.cnt

	lda	#0
	bra	.sta

.tB	lda	#1
.sta	sta	exal_control3,y

.cnt	lda	exal_control3,y
	bne	.B





.X	testjoypad		boost,pcont	;x,pcont
	beq			.B
	pl_Sboost		x,on
	bra			.gotoinc


.B	testjoypad		brake,pcont	;B,pcont
	beq			.clr
	pl_Sbrake		x,on
	bra			.gotoinc


.clr	lda	#0
	sta	exal_control3,y


.nokey	pl_Sboost		x,off

.gotoinc
;	pl_boostinc

.exit	plp
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;   set Arwing's al_vel
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
set_arwing_vel

	PUSHYP

	s_start_strat

	a8i16

awspeed		equ	work9+1
awspeedspace		equ	work9+0
;awspeed_battle	equ	work8+1
;awspeedspace_battle	equ	work8+0
awspeedmax		equ	work7+1
awspeedmin		equ	work7+0
awspeedlr		equ	work6+1
awboostspeed		equ	work6+0
awboostspeedspace	equ	work5+1
awspeedspacemax	equ	work5+0
awspeed_room_max	equ	work4+1


	toheap	y,x

;-------------------------------------------------------------------
; demo no toki vel=38

	lda	demomode
	beq	.notdemo
	lda	#38
	sta	awspeed
	lda	#0
	sta	awboostspeed
	jmp	.achasevel
.notdemo
;-------------------------------------------------------------------
	pl_jmpnot_iftransform	x,.nottrans,y

	lda	#0
	sta	awspeed
	lda	#0
	sta	awboostspeed
	jmp	.achasevel
.nottrans
;-------------------------------------------------------------------

;	pl_jmp_ifenter		x,.nopros,0,y

	pl_get_pilotTAB_ST	B,x,awspeed,speed_tab
	pgpt_C			B,x,awspeedspace,speedspace_tab
;	pgpt_C			B,x,awspeed_battle,speed_battle_tab
;	pgpt_C			B,x,awspeedspace_battle,speedspace_battle_tab
	pgpt_C			B,x,awspeedmax,speedmax_tab
	pgpt_C			B,x,awspeedmin,speedmin_tab
	pgpt_C			B,x,awspeedspacemax,speedspacemax_tab

	pgpt_C			B,x,awspeed_room_max,speedmax_room_tab

	pgpt_END		B,x,awspeedlr,speedlr_tab

.start
;-------------------------------------------------------------------
; battle mode ?
;
;	sm_jmp_if1screen	.notbattle
;	s_set_var	B,awspeed,awspeed_battle
;	s_set_var	B,awspeedspace,awspeedspace_battle
;
;.notbattle
;-------------------------------------------------------------------
; over heat no gensoku.
;
;	pl_jmpnot_ifoverheat	x,.noovh,y
;	a16
;	lsr	awspeed
;	lsr	awspeedspace
;	a8
;.noovh
;-------------------------------------------------------------------
.vel_X
	pl_jmpNOT_ifboost	x,.vel_B,y

	s_set_var	B,awboostspeedspace,awspeedspacemax

	lda	playerctlmode
	cmp	#map_room
	beq	.vxroom
.vxnorm	s_set_var	B,awboostspeed,awspeedmax
	jmp		.exit_vel
.vxroom	s_set_var	B,awboostspeed,awspeed_room_max
	jmp		.exit_vel

.vel_B
	pl_jmpNOT_ifbrake	x,.vel_no,y
	lda		awspeedmin
	sta		awboostspeed
	sta		awboostspeedspace
	jmp		.exit_vel
.vel_no
;-------------------------------------------------------------------

	pl_jmpnot_ifturn	x,.exit_vel

;-------------------------------------------------------------------

	testjoypad	left,pcont
	bne		.lr
	testjoypad	right,pcont
	bne		.lr

.no_lr
	lda	#0
	sta	awboostspeed
	sta	awboostspeedspace
	bra	.exit_vel
.lr

;-------------------------------------------------------------------
;LEFT or RIGHT wo oshiteiruto sokudo wo otosu you ni shiteiru....
	s_jmp_ANDframe	#1,.exit
	s_Fchase_alvar	B,x,al_vel,awspeedlr,1
	s_set_var	B,awboostspeed,#0
	bra		.exit
;-------------------------------------------------------------------

.exit_vel

	sp_jmp_playerctl	x,OF_ARWING,.ofaw,y

	s_set_var	B,awspeed,awspeedspace
	s_set_var	B,awboostspeed,awboostspeedspace

.achasevel

.ofaw	s_achase_alvar	B,x,al_vel,awspeed,3

.exit

	a16
	lda	exal_vel,y
	sexa
	sta	z1
	lda	awboostspeed
	sexa
	sta	z2
	a8

	s_achase_var	W,z1,z2,3
	s_set_alvar	B,y,exal_vel,z1


;	s_achase_alvar	B,y,exal_vel,awboostspeed,3

;-------------------------------------------------------------------

.nopros
	PULLYP

	rts



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	tranform no toki no rotation Y wo set suru.
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

trans_aw2rb_lrlr_srou
	s_start_strat

	PUSHXYP

	pl_set_exalkey

	s_set_var	W,inc_roty,#0

	jsr		OF_AW_lrlr

	PULLXYP

	rts

trans_rb2aw_lrlr_srou

	s_start_strat

	PUSHXYP

	pl_set_exalkey

	s_set_var	W,inc_roty,#0

	testjoypad	tright,pcont
	bne		.tright
	testjoypad	tleft,pcont
	beq		.exit

.tleft	jsr		.get
	bra		.exit

.tright	jsr		.get
	s_neg_var	W,inc_roty

.exit

	PULLXYP

	rts

.get	pl_get_pilottab		B,x,inc_roty+1,roboLRrotyinc_tab
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Go to height
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
gotoheight_srou_l

;	in	:y1    = height(16bit)
;		:z1    = dummy z(16bit)
;		:idx   = obj pointer
;	out	:x1    = angle (16bit)

	PUSHXYP

	a8i16

	a16
	lda	y1
	sec
	sbc.w	al_worldy,x
	sta	x1

	lda	#400		;dummy data
	sta	y1

	jsl	call_arctan16_l

	a8

	PULLXYP
	rtl

gotoxpos_srou_l

;	in	:x1    = x pos
;		:z1    = dummy z(16bit)
;		:idx   = obj pointer
;	out	:x1    = angle (16bit)

	PUSHXYP

	a16
	lda	al_worldx,x
	sec
	sbc	x1
	sta	x1

	lda	z1
	sta	y1

	jsl	call_arctan16_l

	a8

	PULLXYP
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	TRANS FORM no toki no worldy wo set suru!
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
TRANSworldy_srou

transaltmin	equ	-80

	s_start_strat

;henkei tyu no worldy wo tyousei suru

	pl_test_planetmode	space
	beq	.noadjust
	pl_test_planetmode	marine
	bne	.normal
;------------------------------------------------------------------------------
.marine	pl_jmp_ifinthesea	x,.normal
	a16
	lda	SEADEPTH
	clc
	adc	#transaltmin
	bra	.normal2
;------------------------------------------------------------------------------
.normal	a16
	lda	#transaltmin	; min worldy
.normal2	cmp	al_worldy,x
	bpl	.noadjust
;------------------------------------------------------------------------------
.doadjust	a16
	lda	#-8
	clc
	adc	al_worldy,x
	sta	al_worldy,x
;------------------------------------------------------------------------------
.noadjust
.exit	a8
	rts
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Set player's key buffer (exal_keybutton)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	LONGA
	LONGI

set_exalkey_l

	phy
	php
	ai16

	toheap	y,x

	lda	exal_oldkeybutton,y
	eor	pcont			; get trigger
	ora	exal_keybutton,y
	and	pcont
	sta	exal_keybutton,y

.exit	lda	pcont
	sta	exal_oldkeybutton,y

	plp
	ply
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;player's floating effect
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

playerfloating_srou

	PUSHXYP

	SHORTA
	LONGI

	a8i16


	km_jmpgameflag	freeze,.exit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;Z rotation

	lda	#0
	xba

	toheap	y,x

	sp_jmp_playertype	x,UFO,.norotz,y


	lda	exal_rotzofscounter,y
	inc	a
	cmp	#rzod_end-rotzofsdat
	bcc	.setcounter
	lda	#0
.setcounter	sta	exal_rotzofscounter,y
	phx
	tax
	lda.l	rotzofsdat,x
	plx
	sta.w	exal_rotzoffset,y

.norotz
;----------------------------------------------------
	lda	exal_worldyofscounter,y
	inc	a
	cmp	#wyod_end-worldyofsdat
	bcc	.setcounter2
	lda	#0
.setcounter2	sta	exal_worldyofscounter,y
	phx
	tax
	a16
	lda.l	worldyofsdat,x

	sexa

	clc
	adc	exal_worldyoffset,y
	sta	exal_worldyoffset,y

	a8

	plx

.exit	PULLXYP

	rts
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
rotzofsdat

	db	0

	db	1
	db	2,2
	db	3,3
	db	4,4,4,4
	db	3,3
	db	2,2
	db	1

	db	0

	db	-1
	db	-2,-2
	db	-3,-3
	db	-4,-4,-4,-4
	db	-3,-3
	db	-2,-2
	db	-1

rzod_end

worldyofsdat
	db	1
	db	0
	db	1
	db	0
	db	0
	db	1
	db	0
	db	0

	db	0
	db	0
	db	-1
	db	0
	db	0
	db	-1
	db	0
	db	-1
	db	-1
	db	0
	db	-1
	db	0
	db	0
	db	-1
	db	0
	db	0


	db	0
	db	0
	db	1
	db	0
	db	0
	db	1
	db	0
	db	1
wyod_end



;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;-------------------------------------------------------------------;
;                                                                   ;
;    player hit slope		                               ;
;                                                                   ; 
;-------------------------------------------------------------------;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
AWexptime	equ	50
AWflashtime0	equ	AWexptime-10
AWflashtime1	equ	AWexptime-4
expdemoend	equ	60+15

;
	SHORTA
	LONGI

playerexplode_istrat

;al_pword1	demo time counter

	s_start_strat

	a8i16

;;;	jsl		timechart_l

	pl_Sboost	x,off

;---------------------------------------------------------------------------------------------------------------
; make explosion obj
	s_make_childobjrotpos	#nullshape,0,#0,#0,#0,#0,#0,#0,path_istrat
	cpy		#0
	beq		.exp0
	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
	s_set_path	y,p_explode_s_rnd31
	s_set_aldata	y,#1,#1
	s_set_lifecnt	y,#awexptime
.exp0
;---------------------------------------------------------------------------------------------------------------

	toheap	y,x


;---------------------------------------------------------------------------------------------------------------
; special bomb no window wo clear suru tame.

	sm_circle_decRGB	x,#1,#1,#1

;---------------------------------------------------------------------------------------------------------------
;	s_jmp_alsflag	x,player2,.p2ram

.p1ram	s_or_var	B,p1_status,#p1_status_HP0
	s_set_var	B,sdport1,#0

;	bra		.ppram
;.p2ram	s_or_var	B,p2_status,#p2_status_HP0
;	s_set_var	B,sdport2,#0
;.ppram

;---------------------------------------------------------------------------------------------------------------

;	jsl		tp_alarmoff_srou_l

;---------------------------------------------------------------------------------------------------------------

	ct_set_chartptr	x,playerdead

;---------------------------------------------------------------------------------------------------------------

	sp_jmpnot_playertype	x,ARWING,.RBs0
.AWs0	kplsound	x,myshield0
	bra		.endSE
.RBs0	kplsound	x,Roboshield0
.endSE
;---------------------------------------------------------------------------------------------------------------
;calc vecs
	s_set_alvar	B,x,al_vel,#30
	s_set_alvar	B,x,al_sbyte1,#0
	s_gen_3Dvecs	x,al_roty,al_sbyte1,al_vel

;---------------------------------------------------------------------------------------------------------------

	pl_coll_damage	x
	pl_set_timer	x,#0

	s_set_alvar	W,x,al_pword1,#0

;*************************************************************
;WARNING! battle no toki no bakuhatsu wo hayameru tame no syori.

	sm_jmp_if1screen	.notfast

	s_set_alvar	W,x,al_pword1,#30

.notfast
;*************************************************************


	phy
	s_set_resource	L,x,WhenDead,#.strat
	ply
	pl_jet		x,off,y

	c_view_inbetween	x,on

;	c_set_demoviewstrat	x,playerdead,y
;	c_do_viewstrat
;	jsl		set_inbet_l

	s_rotpos_allchildren	x

	s_set_alvar	W,x,al_depthoffset,#depth_2

;---------------------------------------------------------------------------------------------------------------

	s_set_alvar	B,y,exal_HP,#0

;---------------------------------------------------------------------------------------------------------------

	s_end_strat

;---------------------------------------------------------------------------------------------------------------
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

.strat	a8i16

	toheap	y,x

;---------------------------------------------------------------------------------------------------------------

	s_set_alvar	B,y,exal_HP,#0

;---------------------------------------------------------------------------------------------------------------
	pl_inc_timer	x

	jsl		timechart_l

	s_clr_alsflag	x,insidecockpit

;-----------------------------------------------------------------------------
; room no kabe atari

	pl_jmp_ifblockoff	x,.nosolid,y

	s_jmp_ifnotsolid	x,.nosolid

	pl_jmp_timerMORE	x,#awexptime,.nosolid
	pl_set_timer		x,#awexptime
.nosolid
;-----------------------------------------------------------------------------
; Explode circle

	pl_jmp_timerEQ		x,#37,.smallcircle_on
	pl_jmp_timerEQ		x,#awexptime,.bigcircle_on
	pl_jmp_timerEQ		x,#38,.circlepos
	pl_jmp_timerLESS	x,#awexptime,.nocircle

	jsl	cc_addbuffer_white_l

	jmp			.circlepos

;************ Small explode circle on. Set parameters
.smallcircle_on

	sm_circle_on		x,#3,#0,#1
	sm_circle_RGB		x,#31,#31,#31
	sm_circle_decRGB	x,#4,#8,#8
	sm_circle_pri		x,on,y
	bra			.circlepos

;************ Explode circle on. Set parameters

.bigcircle_on

	sm_circle_pri		x,off,y
	sm_circle_on		x,#3,#2,#0
	sm_circle_RGB		x,#31,#31,#31

;	sm_jmp_if1screen	.edo0
;	sm_circle_decRGB	x,#1,#2,#2
;	bra			.edo1

.edo0	sm_circle_decRGB	x,#0,#2,#2
.edo1	sm_circle_pri		x,on,y

;************

.circlepos	sm_circle_objpos	x

.nocircle

;-------------------------------------------------------------------------
; remove child

; heal
	s_jmp_childdead		#childno_heal,.noheal
	s_push_obj	y
	s_set_objtobechild	y,x,#childno_heal
	s_remove_obj		y
	s_pull_obj	y
.noheal

;-------------------------------------------------------------------------
; general dynamics

	sp_jmpnot_playertype	x,ROBOT,.nogd

	a16
	lda	#0
	sta	al_mx,x
	sta	al_mz,x
	sta	al_vx,x
	sta	al_vz,x
	a8

	jsl	RB_generaldynamics_l

.nogd

;-------------------------------------------------------------------------

	s_achase_alvar		B,x,al_rotx,#0,3

;-----------------------------------------------------------------------------

	jsl		set_hudrot_srou_l

;	pl_SE_engine	x
	pl_SE_trans	x

	c_do_viewstrat

	jsl		set_inbet_l

	pl_damage_meter

;-----------------------------------------------------------------------------

	pl_jmp_timerMORE	x,#awexptime,.addvec

;-----------------------------------------------------------------------------
;EFFECTS
	pl_jmp_timerLESS	x,#awflashtime0,.explode0
	pl_jmp_timerLESS	x,#awflashtime1,.skip

.flash	s_jmp_NOTANDframe	#1,.skip
	s_set_alsflag		x,hitflash
	bra			.skip

;SMALL EXPLOTION

.explode0
;	s_jmp_NOTANDframe	#3,.skip
;	s_make_obj	#nullshape,.skip
;	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
;	s_set_path	y,p_explode_s_rnd31
;	s_set_aldata	y,#1,#1
.skip




;-----------------------------------------------------------------------------
; set particle

	s_push_obj	y
	pl_jmp_timerNE	x,#awexptime,.nopart
	s_make_obj	#nullshape,.nopart
	cpy		#0
	beq		.nopart
	s_set_alptrs	y,player_particle_istrat,hit_istrat,explode_istrat
	s_set_aldata	y,#1,#1
	s_set_alsflag	y,colldisable
	s_copy_pos	y,x
	s_particle_data	y,6,60,127
.nopart	s_pull_obj	y

.addvec	sp_jmp_playertype	x,ROBOT,.RB
	sp_jmp_playertype	x,UFO,.RB

	s_add_alvar	B,x,al_rotz,#5
	s_add_vecs2pos	x

;-----------------------------------------------------------------------------
.RB

	pl_jmp_timerNE		x,#awexptime,.exit

	a16
	lda	#0
	sta	al_vx,x
	sta	al_vy,x
	sta	al_vz,x
	a8

;************
	s_push_obj	y

	s_make_obj	#explosion5,.pexp0
	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
	s_set_path	y,p_explode_l
	s_set_aldata	y,#10,#10
	s_copy_pos	y,x
.pexp0
	s_pull_obj	y

;************

	kplsound	x,shipdown	; sound
	jsr		.remove_arm

.setnull	s_set_alvar	W,x,al_shape,#nullshape


;************

.exit

;-----------------------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³end sequence?³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	;pl_jmp_timerLESS	x,#expdemoend,.notfinish
	;sm_jmp_if2screen	.resetplayer
	;s_jmpnot_alsflag	x,player2,.p1rest
.p2rest	;lda		kw_playerrest2
	;bne		.resetplayer2
	;bra		.endseq
.p1rest	;lda		kw_playerrest1
	;bne		.resetplayer2
.endseq	;km_setmissionsyori	gameover
	;bra		.notfinish
.resetplayer2
	;km_setmissionsyori	playerdown
.resetplayer	;pl_ifrestart	.restart




.notfinish
.restart



	pl_jmp_timerMORE	x,#awexptime-1,.nochild
	s_rotpos_allchildren	x
.nochild


	s_end_strat

;-------------------------------------------------------------------------------------------------------------------


;	s_set_alvar	W,y,kscore+0,#0
;	s_set_alvar	B,y,kscore+2,#0
;
;
;	ct_set_chartptr	x,off
;
;	s_jmp_alsflag	x,player2,.p2
;
;.p1	s_set_strat	x,playeragain_istrat
;	s_set_alvar	B,x,al_HP,#40	;p1_hp
;	bra		.finish
;.p2	s_set_strat	x,player2again_istrat
;	s_set_alvar	B,x,al_HP,#40	;p2_hp
;
;
;.finish
;
;	s_end_strat


.remove_arm

; remove arm(ARMER)

;ÚÄÄÄÄÄÄÄÄÄ¿
;³Set rot Y³
;ÀÄÄÄÄÄÄÄÄÄÙ

	pl_ldy_viewblk		x
	lda.w			al_roty+1,y
	clc
	adc			#20
	nega
	sta			work0

	toheap		y,x
;ÚÄÄÄÄ¿
;³legL³
;ÀÄÄÄÄÙ

.reL	s_jmp_alvarZERO		W,y,exal_jetLobjptr,.noreL
	phx
	s_set_objtobealvar	x,y,exal_jetLobjptr
	s_set_strat		x,brokenleg_istrat
	s_set_alvar		B,x,al_roty,work0
	s_add_alvar		B,x,al_roty,#128
	s_set_alvar		B,x,al_rotx,#-40
	s_set_alvar		B,x,al_vel,#12
	plx
.noreL
;ÚÄÄÄÄ¿
;³legR³
;ÀÄÄÄÄÙ

.reR	s_jmp_alvarZERO		W,y,exal_jetRobjptr,.noreR
	phx
	s_set_objtobealvar	x,y,exal_jetRobjptr
	s_set_strat		x,brokenleg_istrat
	s_set_alvar		B,x,al_roty,work0
	s_set_alvar		B,x,al_rotx,#-60
	s_set_alvar		B,x,al_vel,#10
	plx
.noreR
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
copy_final_Splayer_shield_l

	PUSHXYP

	stx	x2

	lda	#48h

	bra	copy_Splayer_shield_l.enter


copy_kaitei_Splayer_shield_l

	PUSHXYP

	stx	x2

	lda	#20h-5

	bra	copy_Splayer_shield_l.enter


copy_Splayer_shield_l

	PUSHXYP

	ldy	playpt1
	sty	x2

	lda	#11h

.enter	LOCAL

	sta	x1	; count

	ldy	playpt1
	toheap	y,y
	lda	exal_shield,y
	and	#exal_shield_mask
	beq	.badobj

	s_make_obj	#barrier,.badobj

	jsl	effectpath_init_srou_l

	s_set_strat	y,.strat

	s_set_alvar	B,y,al_count,#0

	s_set_alsflag	y,colldisable
	s_set_alsflag	y,notslope

	s_set_alvar	B,y,al_pbyte1,x1
	s_set_alvar	W,y,al_ptr,x2	; pointer


	lda	#1	; shield opened flag
	sta	shieldinit

.badobj	PULLXYP

	rtl




.strat	s_start_strat

	s_set_alsflag	x,noviewcheck

	s_set_alsflag	x,colldisable
	s_set_alsflag	x,notslope

	s_add_alvar	B,x,al_rotx,#8
	s_add_alvar	B,x,al_rotz,#6

	ldy	al_ptr,x

	s_copy_pos	x,y
	s_init_anim	x,#9

	lda	al_count,x
	inc	a
	sta	al_count,x
	cmp	al_pbyte1,x	;#11h
	bmi	.alive

.remove	s_remove_obj	x


.alive
	s_end_strat


;----------------------------------------------------------------------------------
copy_player_shield_l

	PUSHXYP

	ldy	playpt1
	toheap	y,y
	lda	exal_shield,y
	and	#exal_shield_mask
	beq	.badobj


	s_make_childobjrotpos	#barrier,#childno_boost,#0,#0,#0,#0,#0,#0,.strat
	cpy		#0
	beq		.badobj

	jsl	effectpath_init_srou_l

	s_set_strat	y,.strat

	lda	#1	; shield opened flag
	sta	shieldinit

	s_set_alsflag	y,colldisable

.badobj	PULLXYP

	rtl




.strat	s_start_strat


	s_set_alsflag	x,noviewcheck

	s_set_alsflag	x,colldisable

	s_add_alvar	B,x,al_childrotx,#8
	s_add_alvar	B,x,al_childrotz,#6

	s_set_objtobemother	y,x

	s_jmp_alsflag		y,invisible,.remove

	a16
	lda.w	al_shape,y
	cmp	#nullshape
	a8
	beq	.remove

	s_init_anim	x,#9
	lda		demomode
	bne		.alive

.remove	s_remove_obj	x

.alive
	s_end_strat

;---------------------------------------------------------------------------

title_bwing_path_l

	s_start_strat

	s_achase_alvar	B,x,al_rotz,#0,3

	a16
	lda	al_worldx,x
	clc
	adc	al_childx,x
	sta	al_worldx,x

	lda	al_worldy,x
	clc
	adc	al_childy,x
	sta	al_worldy,x

	lda	al_worldz,x
	clc
	adc	al_childz,x
	sta	al_worldz,x

	a8

	s_achase_alvar	W,x,al_childx,#0,3
	s_achase_alvar	W,x,al_childy,#0,3
	s_achase_alvar	W,x,al_childz,#0,3


	rtl


;---------------------------------------------------------------------------

STARWOLFdirector_demo_path_l

	s_start_strat

	a16
	lda	#8000h
	clc
	adc	al_worldx,x
	sta	al_worldx,x

	lda	#8000h
	clc
	adc	al_worldy,x
	sta	al_worldy,x

	lda	#8000h
	clc
	adc	al_worldz,x
	sta	al_worldz,x

	a8

	s_set_alvar	B,x,al_rotx,#26
	s_set_alvar	B,x,al_roty,#deg90
	s_set_alvar	B,x,al_rotz,#0


	rtl

;---------------------------------------------------------------------------
pc_cam_path_l

	s_start_strat

	a16
	lda	#0
	sta	al_worldx,x
	sta	al_worldy,x
	sta	al_worldz,x

	sta	al_vx,x
	sta	al_vy,x
	lda	#10
	sta	al_vz,x
	a8

	s_set_alvar	B,x,al_rotx,#10h
	s_set_alvar	B,x,al_roty,#deg180-30


;	p_zero	vx
;	p_zero	vy
;	p_set	vz,10
;	p_zero	worldx
;	p_zero	worldy
;	p_zero	worldz
;	p_set	rotx,10h
;	p_set	roty,deg180-30


	rtl

;---------------------------------------------------------------------------
heal_path00_l

	s_start_strat

	s_achase_alvar	W,x,al_childz,#200,3
	s_achase_alvar	W,x,al_childz,#200,3
	s_achase_alvar	W,x,al_childy,#0,3
	s_achase_alvar	W,x,al_childy,#0,3

	rtl

heal_path01_l

	s_start_strat

	s_achase_alvar2alvar	W,x,al_childx,x,al_pword1,3
	s_achase_alvar		W,x,al_childz,#0,3
	s_achase_alvar		W,x,al_childz,#0,3
	s_achase_alvar		W,x,al_childy,#0,3

	rtl

heal_path02_l

	s_start_strat

	s_add_alvar	B,x,al_childrotx,#-8
	s_add_alvar	W,x,al_childy,#10
	s_add_alvar	W,x,al_childz,#-10
	s_add_alvars	B,x,al_childrotz,x,al_pbyte1
	s_add_alvars	B,x,al_childroty,x,al_pbyte1

	rtl
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	end of file
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	strats_end

	end

