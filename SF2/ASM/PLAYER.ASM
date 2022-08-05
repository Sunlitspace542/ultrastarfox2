;��������������������������������������������������������������������Ŀ
;�                                                                    �
;�                 STARFOX II - REVENGE OF PEPPY -                    �
;�                                                                    �
;��������������������������������������������������������������������Ĵ
;�                                                                    �
;� FILE:         PLAYER.ASM                                           �
;� AUTHOR:       Dylan Cuthbert & Takumi Kawagoe                      �
;� DESCRIPTION:  The Player's strategy                                �
;� DATE CREATED: 16-2-93                                              �
;�                                                                    �
;����������������������������������������������������������������������

; usually using	:al_pbyte2  	transform flags (See talcs.inc)
;		:al_pbyte1	demo(roty buffer)
;		:al_sword1  	distance of view = 0
;		:al_sword2  	HEAP memory
;		:al_pword1	MACRO de tukatteiru!(See TMACROS.INC) time counter(DEMO)
;		:al_stratstate	player's mode
;		:al_ptr		view strat pointer(=viewblk1 or 2)
;		:al_sbyte2	(Robot no roty offset)
;		:sflag6		ashioto flag (ROBOT)
;		:sflag5		shadow (ROBOT)
;		:sflag4		(for special weapon limitter!)
;		:sflag3		in the sea flag
;		:sflag2		for dragon

	INCPUB	player


;spweap_init	equ	spweap_heal
spweap_init	equ	spweap_bomb
;spweap_init	equ	spweap_shield


;�������������������������������������������������������������������
;����������������������������������Ŀ
;�LOCAL MACRO to make parts of ROBOT�
;������������������������������������

makeRBleg	macro	[name,label]
	pla
	pha
	bit		#exal_jetstatus_{name}alive
	bne		{label}
	jsr		Onfield_robo2.generate{name}
	bcc		{label}
	pla
	ora		#exal_jetstatus_{name}alive
	pha
	endm

;---------------------------------------------------------------------------------------
;����������������ͻ
;�Player no inital�
;����������������ͼ
	strats_start

	SHORTA
	LONGI

player_init

;���������������������Ŀ
;�HEAPmemory no initial�
;�����������������������

	s_freeall	x	; release all memory
	s_alloc		x,y,#playerheap_sizeof
	sty		al_sword2,x


.interdemo	LOCAL

	toheap		y,x

;�����������������������Ŀ
;�Heap exalvar no initial�
;�������������������������

	jsr		tarwing_exalvar_init

;�����������������Ŀ
;�set player's area�
;�������������������

	pl_set_area	x,-1

;��������������������Ŀ
;�clear transform flag�
;����������������������

	pl_clr_transflag	x

;--------------------------------------------------------------------------------------

	IFEQ	NOBATTLE
	s_jmp_alsflag	x,player2,.setplaypt2
	ENDC

;��������������������������Ŀ
;�Player 1 no RAM no initial�
;����������������������������

.setplaypt1	stx		playpt1
	sty		playhpt1

	s_set_alvar	B,y,exal_PILOTNo,p1_PILOTNo
	s_set_alvar	B,x,al_HP,#1
	s_set_alvar	B,y,exal_HP,p1_HP

	lda	p1_HP
	sta	KHP,y

	a16

	lda	kx_basicscore	;kw_totalscore1
	sta	kscore,y
	lda	kx_basicscore+1	;kw_totalscore1+1
	sta	kscore+1,y

	a8

	jmp	.con

;��������������������������Ŀ
;�Player 2 no RAM no initial�
;����������������������������

	IFEQ	NOBATTLE
;------------>>>>>>>>>>>>>>>>
;------------>>>>>>>>>>>>>>>>
;------------>>>>>>>>>>>>>>>>
.setplaypt2	stx		playpt2
	sty		playhpt2
	s_set_alvar	B,y,exal_PILOTNo,p2_PILOTNo
	s_set_alvar	B,x,al_HP,#1
	s_set_alvar	B,y,exal_HP,p2_HP
	s_set_alvar	B,y,KHP,p2_HP
	a16
	lda	kw_totalscore2
	sta	kscore,y
	lda	kw_totalscore2+1
	sta	kscore+1,y
	a8
;------------<<<<<<<<<<<<<<<<
;------------<<<<<<<<<<<<<<<<
;------------<<<<<<<<<<<<<<<<
	ENDC

;�����������������������Ŀ
;�alsflag nado no initial�
;�������������������������
.con
	stx	internalplaypt
	stx	viewpt
	stx	viewtoobj

	s_init_anim	x,#0
	s_set_alvar	B,x,al_ap,#playerAP

	s_setnoremove_behind	x
	s_set_alsflag	x,sameshapecollide
	s_set_alsflag	x,shadow
	s_set_alsflag	x,notslope
	s_set_alsflag	x,noviewcheck

;�����������������������Ŀ
;�DAMAGE METER no initial�
;�������������������������

	rts

robotyofstab
	shapetab	B,robotyofstab_

;��������������������������������������������������������������������������������
;	PLAYER 1&2 MAIN STRAT
;��������������������������������������������������������������������������������

EXplayer2_istrat

	s_start_strat

	a8i16

	s_set_alsflag	x,player2

	bra	EXplayer_istrat.enter

	IFEQ	NOBATTLE
;------------>>>>>>>>>>>>>>>>
;------------>>>>>>>>>>>>>>>>
;------------>>>>>>>>>>>>>>>>
	s_start_strat
	a8i16
	s_set_alsflag	x,player2
	s_set_alvar	B,x,al_tx,#2
	jsr		EXplayer_istrat.init
	jsl		initEalt_srou_l
	s_set_strat	x,player_istrat
	s_end_strat
;------------<<<<<<<<<<<<<<<<
;------------<<<<<<<<<<<<<<<<
;------------<<<<<<<<<<<<<<<<
	ENDC

EXplayer_istrat

	s_start_strat

	a8i16

	s_clr_alsflag	x,player2

.enter	LOCAL

	s_set_alsflag	x,active

	s_set_var	B,playerctlmode,#0	; clear player control mode

	s_set_alvar	B,x,al_tx,#1

	jsr		EXplayer_istrat.init

	jsl		player_RAMinit_l	; (game)

	jsl		initEalt_srou_l

	s_set_strat	x,player_istrat

	s_end_strat


.init	LOCAL

	s_set_alsflag	x,colldisable
	s_set_aldata	x,#255,#1
	s_set_alptrs	x,player_istrat,hit_istrat,explode_istrat
	phy
	s_set_resource	L,x,WhenDead,#playerexplode_istrat
	ply
	jsr		player_init

	rts

;���������������������������������������������������������������������������������
CLEARDEMOplayer_istrat

	s_start_strat

	a8i16

	s_set_var	B,sdport1,#%100	; sound stop

	lda	demoflag
	and	#~(demoflag_nextmap!demoflag_nextmap_off)
	sta	demoflag

	s_set_alsflag	x,colldisable

	jsr	INTERDEMO_ALVARS

	jmp	player_istrat.demo

;���������������������������������������������������������������������������������
; GOTO DEMO player
;���������������������������������������������������������������������������������


GOTODEMOplayer_istrat

	s_start_strat

	a8i16

	s_set_alvar	W,x,al_shape,#nullshape

	jsr	INTERDEMO_ALVARS

	toheap	y,x

; don't clear chart!

	s_set_alvar	W,y,exal_charttimer,#0

;           �������������������������������Ŀ
;           �ct_set_chartptr	x,nextmap_chika�
;           �ct_set_chartptr	x,nextmap_d_sen�
;           ���������������������������������

	s_set_alvar	W,x,al_shape,#nullshape
	s_set_var	B,sdport1,#%100	; sound stop
	s_set_var	B,sdport2,#0	; sound stop

	lda	#0
	sta	demoflag
	s_set_strat	x,.wait_nextmap_start

.wait_nextmap_start

	s_set_alsflag	x,colldisable

	s_playercontroller

	jsl	timechart_l

;	IFNE	debuginfo
;	jsr	testxyz
;	ENDC

.exit	s_end_strat



;���������������������������������������������������������������������������������
;INTERDEMOSTARTplayer_istrat
;���������������������������������������������������������������������������������
INTERDEMOplayer_istrat

	s_start_strat

	a8i16

	PUSHXYP
	jsl	remove_map_l
	lda	#0
	sta	Numareas
	lda	#-1
	sta	CurrentArea
	sta	SecondaryArea
	jsl	InitBlockmap_l
	PULLXYP

	jsr	INTERDEMO_ALVARS

	ct_set_chartptr	x,off

	s_set_alvar	W,x,al_shape,#nullshape

	s_set_var	B,sdport1,#%100	; sound stop
	s_set_var	B,sdport2,#0	; sound stop

	lda	demoflag
	and	#~(demoflag_nextmap!demoflag_nextmap_off)
	sta	demoflag

	s_set_alsflag	x,colldisable


; view strat off

	c_set_viewstrat	x,off

;���������������������������������������������������������������������������������

player_istrat

	s_start_strat


;---------------------------------------------------------------------------------

; *********

	a16
	lda	#0
	sta	testx
	sta	testy
	sta	testz
	a8

; *********

	lda	demomode
	bne	.demostart

	c_view_inbetween	x,offtrig

	jmp	.start

;---------------------------------------------------------------------------------
; make domo director


.demostart

	; wait until set demoNo

	lda	demoNo
	cmp	#demo_wait
	bne	.demostart_0

	s_end_strat

.demostart_0

;*****************************************************************************
; inter demo off?
;
;	lda	demoNo
;	cmp	#demo_off
;	bne	.notnone
;
;	lda	#0
;	sta	demoNo
;	lda	#0
;	sta	demomode
;
;	toheap		y,x
;
;	c_view_inbetween	x,offtrig
;
;	jmp	.start
;
;.notnone
;*****************************************************************************

	jsl	makedirector_srou_l

	s_set_strat	x,.waitdemoend

	toheap		y,x

	KM_PUSHSNDPLACE

.waitdemoend

	ldy	#viewblk1

;	lda.w	al_rotx+1,y
;	printh	VIEWROTX,kawagoe
;	lda.w	al_roty+1,y
;	printh	VIEWROTY,kawagoe



	toheap		y,x

	jsl	set_vscroll_offset_l

	km_clrgameflag		keydisable	;[for kawaguchi]

	lda	demomode
	rlbeq	.demoend

.demo	LOCAL

	toheap	y,x

	s_playercontroller

	jsl	timechart_l

	jsl	cc_alart_l

;	IFNE	debuginfo
;	jsr	testxyz
;	ENDC
.exit

	s_end_strat






.demoend	toheap	y,x

	pl_control	x,on,y


;************ STAR WOLF demo no toki inbet wo OFF nisuru....

	lda	demoNo
	cmp	#demo_starwolf
	bne	.noofftrig
	c_view_inbetween	x,offtrig
.noofftrig
;************


; initial view parameter

	a16
	lda	al_worldy,x
	sta	exal_camYcenter,Y
	a8

	jsl	set_inbet_l

	KM_PULLSNDPLACE

;���������������������������������������������������������������������������������

.start	a8i16

;------------------------------------------------------------------------------
; displayon

	sp_display	on

	lda	#80h
	sta	p1_targetX
	sta	p1_targetY

;------------------------------------------------------------------------------
; weapon initial

	jsr	weap_init

;------------------------------------------------------------------------------

	toheap	y,x

	km_clrgameflag		keydisable	;[for kawaguchi]
	km_setmissionflag	parallel	;[for kawaguchi]

;------------------------------------------------------------------------------
; view change flag
;
;	sp_cockpit_init
;
;------------------------------------------------------------------------------

	pl_control	x,on,y

	s_clr_alsflag	x,invisible

	s_set_alsflag	x,active

	phy
	s_set_resource	L,x,WhenDead,#playerexplode_istrat
	ply

	s_clr_alsflag	x,colldisable

	s_clr_alsflag	x,realobj

	s_set_strat	x,PLAYERMAIN.strat

	phy
	s_set_resource	L,x,start_hit,#hitplayer_start
	s_set_resource	L,x,while_hit,#hitplayer_while
	s_set_resource	L,x,end_hit,#hitplayer_end
	ply

	c_set_demoviewstrat	x,off,y

;---------------------------------------------------------------------------------

	PHX

	ai16
	lda	playerctlmode
	cmp	#9+1	; max mode
	bcc	.skip
	lda	#0
.skip	asl	a
	tax
	lda.l	player_ctl_mode,x
	tax

; aw or rb?

	lda	playerinitmode
	bit	#playerinitmode_ROBOT!playerinitmode_UFO
	bne	.rb

.aw	lda.l	player_ctl_mode&0ff0000H+0,x
	bra	.mode

.rb	lda.l	player_ctl_mode&0ff0000H+2,x

.mode	sta	exal_controlmode,y
	sta	x1

	lda.l	player_ctl_mode&0ff0000H+4,x
	sta	vscrollofsmax
	lda.l	player_ctl_mode&0ff0000H+6,x
	sta	vscrollofsrate

	a8

	PLX

	jsl	modechangesrou_l

	jmp	PLAYERMAIN.strat


;---------------------------------------------------------------------------------

; -- ARWING INIT -- on field

Onfield_Arwing_init

	s_start_strat

	s_clr_alsflag	x,ontheground

	toheap		y,x

	pl_clr_transfalling	x,y

	pl_planetmode		ground
	pl_jmpnot_ifexistSEA	.nosea
	lda	seatype
	cmp	#st_magma
	beq	.nosea
	pl_planetmode		marine
.nosea

.pmodeend


;.entry	LOCAL

	toheap		y,x

; umi kara tobidasutoki ha control ha OFF ni suru.

.onthesea

	pl_SHAPEandCTLNo	x,OF_ARWING

	sp_cockpit_init
	sp_viewchange	off	; view change off (kyakkan only)

	jsr	GENERAL_exalvar_init
	pl_mode_change		x,of_Arwing
	s_clr_alsflag		x,ontheground

	s_set_alsflag		x,shadow

Onfield_Arwing

	s_start_strat

	a8i16

	toheap	y,x

.onthesea	c_jmp_viewstratEQ	x,ONFIELD_ARWING,.nosetofawv,y

	c_jmp_ifdemoview	x,.nosetofawv,y
	pl_jmp_iftransrising	x,.nosetofawv,y

	c_view_inbetween	x,on
	c_set_viewstrat		x,ONFIELD_ARWING

.nosetofawv	pl_clr_transflag	x

	s_set_alsflag		x,sflag8	; set permanently inside
	pl_playercontroller	x		; read controller
	pl_set_LASTLRkey

	c_jmp_viewstratEQ	x,ONFIELD_ARWING,.norcx,y
	jsl			RB_CAMROTX_l
.norcx	PL_DO_CTLandVIEW	x,ONFIELD_ARWING


; seadepth no limitter

	jsl	sealimit_view_srou_l

;--------------------------------------------------------------------------------

	pl_check_inthesea	x
	pl_set_PILOTshape	x,x,shape_ARWING

.ofaw_entry	LOCAL

	toheap			y,x
	s_or_alvar		B,y,exal_transflag,#exal_transflag_armode_flag

.ofaw_entry_AM	LOCAL


	pl_damage_meter
	pl_coll_damage	x
	pl_SE_engine	x
	pl_SE_trans	x

	jsl	set_hudrot_srou_l
	jsl	tp_checkshoot_l
	jsl	fire_powerd_srou_l

	pl_end_strat

;-----------------------------------------------------------------------
; -- ARWING STRAT -- in SPACE2

Cosmo_Arwing_init

	s_start_strat


	toheap		y,x

	pl_SHAPEandCTLNo	x,CS_ARWING

	sp_cockpit_init
	sp_viewchange	on	; view change off (kyakkan only)

	jsr	GENERAL_exalvar_init

	pl_planetmode		space

	pl_mode_change		x,cs_Arwing
	c_view_inbetween	x,on

	jsr			cosmo_arwing.setcosmoview

	s_set_alsflag		x,shadow
	s_clr_alsflag		x,ontheground


Cosmo_Arwing

	s_start_strat

	pl_clr_transflag	x

	s_set_alsflag		x,sflag8	; set permanently inside
	pl_playercontroller	x		; read controller
	pl_set_LASTLRkey
	PL_DO_CTLandVIEW	x,COSMO_ARWING

	pl_set_PILOTshape	x,x,shape_ARWING

	jmp			Onfield_Arwing.ofaw_entry



.setcosmoview	LOCAL
	s_start_strat

	pl_jmpnot_ifturn	x,.SF1view,y
.SF2view	c_set_viewstrat		x,COSMO_ARWING
	bra			.exitcosmoview
.SF1view	c_set_viewstrat		x,ONFIELD_ARWING
.exitcosmoview
	rts


;-----------------------------------------------------------------------
; -- ARMER INIT -- in SPACE
Inspace_Armer_init

	s_start_strat

;	toheap		y,x
;
;	pl_SHAPEandCTLNo	x,ARMER
;
;	sp_cockpit_init
;	sp_viewchange	off	; view change off (kyakkan only)
;
;	jsr			Armer0_exalvar_init
;
;	pl_planetmode		space
;
;	pl_mode_change		x,is_Armer
;
;	s_set_alsflag		x,shadow
;	s_clr_alsflag		x,ontheground
;
;	c_set_viewstrat		x,COSMO_ARWING
;	c_view_inbetween	x,on
;
; -- ARMER STRAT -- in SPACE

Inspace_Armer

	s_start_strat

	pl_clr_transflag	x

	s_set_alsflag		x,sflag8	; set permanently inside

;---------------------------------------------------------------------------

	a16
	lda	#0
	sta	gd_gravity
	a8
	lda	#1
	jsl	generaldynamics_l
	jsr	set_worldxyz2exal_srou	; copy pos -> exal pos

;---------------------------------------------------------------------------

	pl_playercontroller	x		; read controller

	toheap			y,x

	s_and_alvar		B,y,exal_transflag,#exal_transflag_armode_flag^-1
	pl_set_LASTLRkey

	PL_DO_CTLandVIEW	x,INSPACE_ARMER

	s_set_alvar	W,x,al_shape,#c_wing

	jmp		Onfield_Arwing.ofaw_entry_AM


;�����������������������������������������������������������������������
; -- ROBOT INIT --

Onfield_robo_init

;using	:sflag6	ashioto flag
;	:sflag5 shadow flag(1:shadow on 0:off)
;	:sbyte1 as state (see ROBOANIM_srou.animdriver)
;	:sbyte2 as motion counter (ROBOT no sokudo wo kaetarisuru tame)
;	:sbyte3 leg roty offset (up or down + left or right)

	s_start_strat

	toheap	y,x

	jsr		Robo0_exalvar_init

	pl_planetmode		ground
	pl_jmpnot_ifexistSEA	.nosea
	lda	seatype
	cmp	#st_magma
	beq	.nosea
	pl_planetmode		marine
.nosea

;���������������������������Ŀ
;�Robot no Yoffset no initial�
;�����������������������������

	pl_get_shapeTAB	B,x,y1,robotyofstab

	toheap		y,x

	s_set_alvar	B,y,exal_bodyofsy,y1

	a16

	lda	y1
	sexa
	clc
	adc	exal_worldy,y
	sta	exal_worldy,y
	sta	al_worldy,x

	a8

	pl_SHAPEandCTLNo	x,ROBOT

	sp_cockpit_init
	sp_viewchange	off	; view change off (kyakkan only)

	pl_mode_change		x,of_robo


	jsr			ROBOT_init_srou

.exitjmp

;���������������������Ŀ
;�clear rotz parameters�
;�����������������������

	toheap	y,x

;������������Ŀ
;�clear vector�
;��������������

	a16
	lda	#0
	sta	al_vy,x

	sta	work_mx
	sta	work_mz

	a8

	s_clr_alsflag	x,ontheground

;-----------------------------------------------------------------------
; -- ROBOT STRAT --

Onfield_robo

	s_start_strat

	pl_clr_transflag	x

	s_set_alsflag		x,sflag8	; set permanently inside

.setview	toheap	y,x

	c_jmp_viewstratEQ	x,ONFIELD_ROBO,.noset,y
	c_view_inbetween	x,on
	c_set_viewstrat		x,ONFIELD_ROBO

.noset

	lda		exal_jetstatus,y
	and		#exal_jetstatus_ALL
	cmp		#exal_jetstatus_ALL
	beq		.make_OK

.domake	lda		exal_jetstatus,y
	pha


.makeLleg0	makeRBleg	legL0,.makeRleg0
.makeRleg0	makeRBleg	legR0,.makeLlegEND
.makeLlegEND


	ldy		al_sword2,x
	pla
	sta		exal_jetstatus,y

.make_OK

;CNTOFF	pl_control		x,on,y

;----------------------------------------------------------------------------

	toheap		y,x

	lda		exal_jetstatus,y
	and		#exal_jetstatus_ALL

	cmp		#exal_jetstatus_ALL
	rlbne		.nochangemode

	pl_set_PILOTshape	x,x,shape_ROBOT_HEAD

	pl_mode_change		x,of_robo2

.nochangemode
;----------------------------------------------------------------------------

onfield_robo2

	toheap	y,x

;----------------------------------------------------------------------------

	pl_playercontroller	x		; read controller

;----------------------------------------------------------------------------

;��������������������Ŀ
;� GENERAL DYNAMICS   �
;����������������������

	jsl	RB_generaldynamics_l

;----------------------------------------------------------------------------

	jsl	makeshadow_srou_l

;---------------------------------------------------------------------------------------------------
; shape ni notte itara shadow ha off ni suru..

	pl_jmpnot_ifinthesea	x,.scam
	pl_jmpnot_ifcaminthesea	x,.shadowoff,y
.scam
	pl_jmp_ZENBUinpool	x,.shadowon
	rb_jmp_ifonshape	x,.shadowoff

.shadowon	s_set_alsflag		x,shadow
	bra			.shadow
.shadowoff	s_clr_alsflag		x,shadow
.shadow

;----------------------------------------------------------------------------

	pl_check_inthesea	x

	s_and_alvar		B,y,exal_transflag,#exal_transflag_armode_flag^-1

	pl_set_LASTLRkey

	jsl			RB_CAMROTX_l

	PL_DO_CTLandVIEW	x,ONFIELD_ROBO

;----------------------------------------------------------------------------
;camera angle

	jsl	tp_checkshoot_l
	jsl	fire_powerd_srou_l

	jsl	set_hudrot_srou_l

	pl_damage_meter

	pl_coll_damage	x

	pl_SE_engine	x

	pl_SE_trans	x

	pl_end_strat

;-----------------------------------------------------------------------------------
; --- make legs ROBOT ---

.generatelegL0	LOCAL

	jsr	.generate_do
	rlbcc	.generatebodyNG

	s_set_strat		y,RBlegL_Istrat

	s_push_obj		y
	toheap	y,x
	s_set_alvar		W,y,exal_jetLobjptr,tpy
	s_pull_obj		y

	s_neg_alvar		W,y,al_childx

	jmp			.generateleg

.generatelegR0	LOCAL

	jsr	.generate_do
	bcc	.generatebodyNG

	s_set_strat		y,RBlegR_Istrat

	s_push_obj		y
	toheap	y,x
	s_set_alvar		W,y,exal_jetRobjptr,tpy
	s_pull_obj		y

	jmp			.generateleg

.generateleg

	s_set_colltype		y,FRIEND

	s_set_collstrat		y,hit_istrat
	s_set_expstrat		y,explode_istrat

	s_set_aldata		y,#ROBOTleg_HP,#ROBOTleg_AP


	IFEQ	NOBATTLE
;------------>>>>>>>>>>>>>>>>
;------------>>>>>>>>>>>>>>>>
;------------>>>>>>>>>>>>>>>>
	s_jmp_alsflag	x,player2,.gbend
	s_set_alsflag	y,player2
	s_set_alsflag	y,sflag10
	s_set_alsflag	y,nohitaffect
.gbend
;------------<<<<<<<<<<<<<<<<
;------------<<<<<<<<<<<<<<<<
;------------<<<<<<<<<<<<<<<<
	ENDC

	sec
	rts

.generatebodyNG

	clc
	rts

;-----------------------------------------------------------------------------------

.generate_do

	pl_get_shapeTAB_ST	W,x,x1,RBleg_xofstab
	pgst_END		W,x,y1,RBleg_yofstab

	s_make_childobjrotpos	#nullshape,childno_legLR,x1,y1,#0,#0,#0,#0,path_istrat
	cpy	#0
	beq	.failed
	sty	tpy
	sec
	rts

.failed	clc
	rts

;�����������������������������������������������������������������������
;-----------------------------------------------------------------------
ROBOT_init_srou

	s_start_strat

	PHY

	ldy		al_sword2,x
	s_set_alvar	W,y,exal_animptr,#abt_RBstopping&WM
	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBstopping&WM

	lda	#0
	sta	exal_motionNo,y
	rb_set_motioncounter	x,#0

	s_clr_alsflag		x,sflag6	;ashioto flag
	s_clr_alsflag		x,sflag5	;shadow flag

	lda		#0
	sta		al_sbyte1,x
	sta		al_sbyte2,x
	sta		al_sbyte3,x	; leg roty offset

	s_set_var	B,p1_legflag,#0



	IFEQ	NOBATTLE
;------------>>>>>>>>>>>>>>>>
;------------>>>>>>>>>>>>>>>>
;------------>>>>>>>>>>>>>>>>
	s_jmp_alsflag	x,player2,.okip2
	s_set_var	B,p1_legflag,#0
	bra		.okipp
.okip2	s_set_var	B,p2_legflag,#0
.okipp
.exitjmp
;------------<<<<<<<<<<<<<<<<
;------------<<<<<<<<<<<<<<<<
;------------<<<<<<<<<<<<<<<<
	ENDC



	PLY

	rts

;    ����������������������������������������������������������ͻ
;    �                                                          �
;    �           STRATS FOR PLAYER'S TRANSFORMATIONS            �
;    �                                                          �
;    ����������������������������������������������������������ͼ

; -- ARWING>>ROBO INIT --

Aw2Rb_init
	s_start_strat

	toheap		y,x
	jsr			TRANSFORM_srous.init

	t_tranim_init		x,TRanmAW2RB_TAB
	pl_mode_change		x,Tr_aw2rb

	pl_get_pilotTAB		B,x,x1,speed_tab

	s_set_alvar	B,y,exal_vel,#0

	s_jmp_alvarLESS		B,x,al_vel,x1,.nodown
	s_set_speed		x,x1

.nodown	s_clr_alsflag		x,ontheground

;CNTOFF	pl_control		x,on,y

;-----------------------------------------------------------------------
;�������������������������������������������������Ŀ
;� umi no ue de robot ni henkei sitaka CHECK suru. �
;���������������������������������������������������

	toheap	y,x

	pl_clr_transfalling	x,y
	pl_clr_transrising	x,y

	pl_test_planetmode	marine
	bne			.tf_g

.tf_m	pl_jmp_ifinthesea	x,Aw2Rb
	pl_set_transfalling	x,y
	bra			Aw2Rb
.tf_g	pl_set_transfalling_g	x,y

;-----------------------------------------------------------------------
; -- ARWING>>ROBO STRAT --

Aw2Rb
	s_start_strat

	toheap	y,x

	pl_set_transflag	x

	s_set_alsflag		x,sflag8	; set permanently inside
	pl_playercontroller	x		; read controller
	PL_DO_CTLandVIEW	x,Trans_AW2RB

	jsl	sealimit_view_srou_l

	jmp	TRANSFORM_pros

;�����������������������������������������������������������������������
; -- ROBO>>ARWING INIT --
Rb2Aw_init
	s_start_strat

	jsr	RBlegbodynullshape
	jsr	TRANSFORM_srous.init
	jsr	GENERAL_exalvar_init

	t_tranim_init		x,TRanmRB2AW_TAB

	pl_mode_change		x,Tr_Rb2aw

	s_clr_alsflag		x,ontheground

;CNTOFF	pl_control		x,on

;-----------------------------------------------------------------------
;���������������������������������������������������Ŀ
;� umi no naka de arwing ni henkei sitaka CHECK suru.�
;�����������������������������������������������������

	toheap			y,x

	pl_clr_transrising	x,y

;	henkei go ni clear suru!-----------|
;	pl_clr_transfalling	x,y   <----|

	s_jmp_varZERO		W,SEADEPTH,Rb2Aw

	pl_jmpnot_ifinthesea	x,Rb2Aw

	pl_set_transrising	x,y

;-----------------------------------------------------------------------

; -- ROBO>>ARWING STRAT --
Rb2Aw	; Kawagoe's Arwing
	s_start_strat
	pl_set_transflag	x
	s_set_alsflag		x,sflag8	; set permanently inside

	pl_set_transflag	x

	pl_playercontroller	x
	PL_DO_CTLandVIEW	x,Trans_RB2AW
	pl_check_inthesea	x

	jmp	Am2Aw.enter

;�����������������������������������������������������������������������
; -- ARWING>>ARMER INIT --

Aw2Am_init
	s_start_strat

	jsr			TRANSFORM_srous.init
	jsr			Armer0_exalvar_init

	t_tranim_init		x,TRanmAW2AM_TAB
	pl_mode_change		x,Tr_Aw2Am

	s_clr_alsflag		x,ontheground

;CNTOFF	pl_control		x,on

;-----------------------------------------------------------------------
; -- ARWING>>ROBO STRAT --
Aw2Am
	s_start_strat

	pl_set_transflag	x

	s_set_alsflag		x,sflag8	; set permanently inside

	PL_DO_CTLandVIEW	x,Trans_AW2AM

	jmp	TRANSFORM_pros

;�����������������������������������������������������������������������
; -- ROBO>>ARWING INIT --
Am2Aw_init
	s_start_strat
	jsr			RBlegbodynullshape

	jsr	TRANSFORM_srous.init
	jsr	GENERAL_exalvar_init

	t_tranim_init		x,TRanmAM2AW_TAB

	pl_mode_change		x,Tr_Am2aw

	s_clr_alsflag		x,ontheground

;CNTOFF	pl_control		x,on

;-----------------------------------------------------------------------
; -- ROBO>>ARWING STRAT --
Am2Aw	; Kawagoe's Arwing

	s_start_strat

	pl_set_transflag	x

	s_set_alsflag		x,sflag8	; set permanently inside

	PL_DO_CTLandVIEW	x,TRANS_AM2AW

.enter	LOCAL

	toheap	y,x

	s_copy_alvar2alvar	W,y,exal_camYcenter,y,exal_worldy
	s_set_alvar		W,y,exal_camYofs,#0


	jmp	TRANSFORM_pros

;������������������������������������������������������������������������������
TRANSFORM_srous

.init	LOCAL

	s_start_strat

	s_or_alvar		B,y,exal_transflag,#exal_transflag_transform_flag

	sp_weap_power		x,off,y

	s_set_alsflag		x,shadow

	pl_set_timer		x,#0

	rts
;������������������������������������������������������������������������������
TRANSFORM_pros

	s_start_strat

	s_achase_alvar		B,x,al_vel,#0,2

	pl_check_inthesea	x
	pl_damage_meter	;armer_HP,DMETERNUM
	pl_coll_damage		x
	pl_SE_engine		x
	pl_SE_trans		x
	jsl	set_hudrot_srou_l
	jsr	set_worldxyz2exal_srou
	jsl	fire_powerd_srou_l

	pl_end_strat

;������������������������������������������������������������������������������
;������������������������������������Ŀ
;�ROBOT no shape wo nullshape ni suru.�
;��������������������������������������

RBlegbodynullshape

	s_start_strat

	PUSHXYP
	a8i16

	ldy	al_sword2,x

	a16
	lda	#nullshape

.R	ldx	exal_jetRobjptr,y
	beq	.L
	sta	al_shape,x

.L	ldx	exal_jetLobjptr,y
	beq	.B
	sta	al_shape,x

.B

.exit	PULLXYP
	rts


;������������������������������������������������������������������������������
;    ����������������������������������������������������������ͻ
;    �                                                          �
;    �           STRATS FOR PLAYER'S DEMONSTRASION              �
;    �                                                          �
;    ����������������������������������������������������������ͼ



;�����������������������������������������������������������������������

;DEMO_srou
;.istrat	LOCAL
;
;	s_start_strat
;
;	PHY
;
;;CNTOFF	pl_control		x,off
;	s_set_alsflag		x,nohitaffect
;	s_set_alsflag		x,sflag8		; set permanently inside
;
;	s_set_alvar		B,x,al_pbyte1,#0	; demo state
;	pl_set_timer		x,#0		;macro	[obj,value]
;;	s_set_alvar		B,x,al_pword1,#0	; demo time counter
;
;	c_cockpitmode		x,off
;	pl_Sboost		x,off
;
;	pl_set_area		x,-1
;
;	pl_ldy_viewblk		x
;	s_set_state		y,#0		 ;state
;
;	PLY
;
;	rts
;�����������������������������������������������������������������������

;����������������������������������������������������������������������������������
;	Calcurate Robot's vector
;����������������������������������������������������������������������������������

	LONGI
	SHORTA

RB_gen3dvecs_l

;	in tpy : roty

	PUSHXYP

	s_start_strat

	a8i16

;�����������Ŀ
;�Calc vector�
;�������������

	ldy		dummyobj
	s_set_alvar	W,y,al_worldx,#0
	s_set_alvar	W,y,al_worldz,#0
	s_set_alvar	B,y,al_roty,tpy

	s_add_roffs2pos	B,y,y,y,x1,y1,z1,0,1,0

;���������������Ŀ
;�add al_mx,al_mz�
;�����������������

	s_add_alvars	W,x,al_mx,y,al_worldx
	s_add_alvars	W,x,al_mz,y,al_worldz

	s_add_alvar	W,x,al_mx,work_mx
	s_add_alvar	W,x,al_mz,work_mz

.exit
	PULLXYP

	rtl

;����������������������������������������������������������������������������������
;	Sound routine (use macro!)
;����������������������������������������������������������������������������������
pl_SE_Robowalk_l

	s_start_strat

;	in	idx	:player pointer

	PUSHXYP

	toheap	y,x

	pl_jmp_ifinthesea	x,.inthesea

	pl_jmp_ASHIinpool	x,.inthepool

	bra	.ontheground

;����������������Ŀ
;�walk in the pool�
;������������������
.inthepool
	pl_jmp_ifonthe	x,magma,.magma,y

	lda	exal_animflag,y
	bit	#exal_animflag_SEwalkpool
	bne	.noSEwp

	ora	#exal_animflag_SEwalkpool
	sta	exal_animflag,y

.magma	pl_jmpnot_ifdush	x,.sd,y

	ksound		waterwalk,far

	bra	.exit


.sd	ksound		waterwalk

	bra	.exit


.noSEwp
	and	#~exal_animflag_SEwalkpool
	sta	exal_animflag,y
	bra	.exit

;���������������Ŀ
;�walk in the sea�
;�����������������
.inthesea

	s_jmpNOT_alsflag	x,ontheground,.exit

	pl_jmp_ifdush		x,.wsf,y

	ksound		Robowalkinsea1,far

	bra	.exit


.wsf	ksound		Robowalkinsea1

	bra	.exit

;������������������Ŀ
;�walk on the ground�
;��������������������
.ontheground

	s_jmpNOT_alsflag	x,ontheground,.exit

	pl_jmp_ifdush		x,.wd,y

	ksound		Robowalk1,far
	bra			.exit

.wd	ksound		Robowalk1

.exit
	PULLXYP

	rtl
;����������������������������������������������������������������������������������
;	Sound routine (use macro!)
;����������������������������������������������������������������������������������
pl_SE_Roboswim_l

	s_start_strat

;	in	idx	:player pointer

	PHP

	kplsound		x,Roboswim

	PLP

	rtl

;����������������������������������������������������������������������������������
;	Sound routine (use macro!)
;����������������������������������������������������������������������������������
pl_SE_transEND_l

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x

	lda	exal_transENDse,y
	bit	#exal_transENDse_mask
	rlbeq	.exit
	dec	a
	sta	exal_transENDse,y
.SE
	bit	#exal_transENDse_RB
	bne	.RBse

.AWse	and	#exal_transENDse_mask
	cmp	#exal_transENDse_mask-2
	bne	.exit

	lda	exal_transENDse,y
	and	#exal_transENDse_notEND^-1
	sta	exal_transENDse,y

	kplsound	x,transArwing2Roboend

	bra		.exit

.RBse	and		#exal_transENDse_mask
	cmp		#exal_transENDse_mask-2
	bne		.cksea
	kplsound	x,transRobo2Arwingend

	lda	exal_transENDse,y
	and	#exal_transENDse_notEND^-1
	sta	exal_transENDse,y

.cksea	pl_jmpnot_ifinthesea	x,.exit

	lda		exal_transENDse,y
	and		#exal_transENDse_mask
	cmp		#exal_transENDse_mask-8
	bne		.exit
	kplsound	x,ob_up_to_the_sky

.exit	PULLYP

	rtl


;����������������������������������������������������������������������������������
;	Set last L R key flag
;����������������������������������������������������������������������������������

setlastLRflag_srou_l

	strats_start

;exal_control exal_control_lastLR
;

	PHY

	toheap	y,x


.skip1	testjoypad	tright,ptrig
	beq	.skip
	lda	exal_lastLR,y
	ora	#exal_lastLR_lastLR
	bra	.exit0
.skip
	testjoypad	tleft,ptrig
	beq	.exit1
	lda	exal_lastLR,y
	and	#exal_lastLR_lastLR^-1
.exit0	sta	exal_lastLR,y
.exit1


; ----------------------------------------------------------------------------------
; -- set LRtrig --



.LR	lda	exal_lastLR,y
	and	#(exal_lastLR_L!exal_lastLR_R)^-1
	sta	exal_lastLR,y


	lda	pcont
	and	#%00110000
	beq	.nokey
	cmp	#%00110000
	beq	.check
	bit	#%00100000	;l
	bne	.left
	bra	.right


.check	lda	exal_lastLR,y
	bit	#exal_lastLR_lastLR
	bne	.lastright

.lastleft	testjoypad	tleft,pcont
	beq	.nokey
.left	lda	exal_lastLR,y
	ora	#exal_lastLR_L
	bra	.setLR

.lastright	testjoypad	tright,pcont
	beq	.nokey
.right	lda	exal_lastLR,y
	ora	#exal_lastLR_R
.setLR	sta	exal_lastLR,y

.nokey
	PLY

	rtl

	strats_end


;����������������������������������������������������������������������������������
;
;����������������������������������������������������������������������������������
;	idX	:player's pointer
;	out	:idX pilotNo * 2

get_pilotNotoidx_B_l

	php

	ai16

	phy

	toheap	y,x

	lda	exal_pilotNo,y
	and	#exal_pilotNo_plmask
	cmp	#max_ep_PLAYER+1
	bcc	.skip0

	lda	#0

.skip0	ply

	tax

	plp

	rtl



get_pilotNotoidx_W_l	;This one! Check.

	php

	ai16

	jsl	get_pilotNotoidx_B_l

	txa
	asl	a
	tax

	plp

	rtl


get_shapeNotoidx_W_l

	php

	ai16

	jsl	get_pilotNotoidx_B_l

	txa
	and	#1^-1

	tax

	plp

	rtl


get_shapeNotoidx_B_l

	php

	ai16

	jsl	get_pilotNotoidx_B_l

	txa
	lsr	a

	tax

	plp

	rtl


;����������������������������������������������������������������������������������
;	SPECIAL WEAPON no kazu no SET
;����������������������������������������������������������������������������������
;	use macro "incspweapnum" See tmacro.inc

addspweapnum_srou_l

;	in	x1: add value

	s_start_strat

	PUSHXYP

	a8i16

	toheap	y,x

	lda	exal_spweap_LMT,y
	and	#pX_spweap_LMT_LMT	;mask
	cmp	#pX_spweap_LMT_num
	bcs	.full

	clc
	adc	x1
	cmp	#pX_spweap_LMT_num
	bcc	.set
	lda	#pX_spweap_LMT_num
.set	and	#pX_spweap_LMT_LMT	;mask
	sta	x2

	lda	exal_spweap_LMT,y
	and	#pX_spweap_LMT_LMT^-1	;mask
	ora	x2
	sta	exal_spweap_LMT,y


.ok	PULLXYP
	clc
	rtl

.full	PULLXYP
	sec
	rtl




;-----------------------------------------------------------------------------
incspweappnt_srou_l

;	out	x1:number of current counter

	PUSHXYP

	a8i16

	ldy	al_sword2,x
	lda	exal_spweap_LMT,y
	jsr	PXISW_SROU.setx1
	jsr	PXISW_SROU.add
	sta	exal_spweap_LMT,y

	PULLXYP

	rtl


PXISW_SROU
.setx1	LOCAL

	SHORTA
	LONGI

	pha
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	and	#pX_spweap_LMT_PNT>>4	;mask
	sta	x1
	pla
	rts

.add	LOCAL
	pha
	and	#%00001111
	sta	x2
	pla
	and	#%11110000
	clc
	adc	#%10000
	cmp	#(pX_spweap_LMT_PNTmax+1)<<4
	bcc	.sta
	lda	#0
.sta	ora	x2
	rts

;-----------------------------------------------------------------------------
; SPWEAP pointer wo GET suru. use macro!

getspweappnt_srou_l

;	out	x1:pointer

	PUSHXYP

	a8i16

	toheap	y,x

	lda	exal_spweap_LMT,y
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	and	#%1111	;pX_spweap_LMT_PNT>>4	;mask
	sta	x1

	PULLXYP

	rtl

;����������������������������������������������������������������������������������
;syo-totsu sita tokino CAMERA no sindou,muteki FLAG wo SET suru.
;SOUND mo SET suru.
;����������������������������������������������������������������������������������

colldamage_srou_l

	phy

	toheap	y,x

	pl_nohittimer_dec	x
	s_achase_alvar	B,y,exal_rotzhit,#0,3

	ply

	rtl


;����������������������������������������������������������������������������������
;player no nohit counter wo decriment suru.....
;����������������������������������������������������������������������������������


decnohit_srou_l

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x

;---------------------------------------------------------------------
; nohit flag
	lda		exal_nohit,y
	and		#exal_nohit_mask
	beq		.skip

	s_jmpNOT_varAND	B,gameframe,#3,.noflash

	s_set_alsflag	x,hitflash

.noflash
	lda		exal_nohit,y
	pha
	and		#exal_nohit_mask^-1
	sta		exal_nohit,y
	pla
	dec		a
	ora		exal_nohit,y
	sta		exal_nohit,y
	beq		.skip

.skip3	s_set_alsflag	x,nohitaffect
	s_set_alsflag	x,colldisable
	bra		.skip1
.skip
	s_clr_alsflag	x,nohitaffect
	s_clr_alsflag	x,colldisable
.skip1

;---------------------------------------------------------------------
; trans rising no toki, nohitaffect wo set suru....

	km_jmpgameflag	freeze,.setals

	lda	exal_nohitRISE,y
	and	#exal_nohitRISE_mask
	beq	.ckrise

	dec	a
	sta	tpx
	lda	exal_nohitRISE,y
	and	#exal_nohitRISE_mask^-1
	ora	tpx
	sta	exal_nohitRISE,y

	bra	.setals

.ckrise	pl_jmpnot_iftransrising	x,.norise,y

	s_set_alvar	B,y,exal_nohitRISE,#exal_nohitRISE_mask

.setals	s_set_alsflag	x,nohitaffect

.norise
;---------------------------------------------------------------------

	PULLYP

	rtl



;����������������������������������������������������������������������������������
;	Sound routine(use macro!)
;����������������������������������������������������������������������������������

; FLAG LIST

RB_engine_MASK	equ	%01101100
RB_engine_echo	equ	%01000000
RB_engine_start	equ	%00100100
RB_engine_LV1	equ	%00101000
RB_engine_LV2	equ	%00101100
RB_engine_stop	equ	%10000000

AW_engine_MASK	equ	%01101100
AW_engine_start	equ	%00000100
AW_engine_speedup	equ	%00001000

AW_engine_speeddown	equ	%00001100
AW_engine_stop	equ	%10000000

AW_engine_horiMASK	equ	%00010011
AW_engine_horiLV0	equ	%00000000
AW_engine_horiLV1	equ	%00000001
AW_engine_horiLV2	equ	%00000010
AW_engine_horiLV3	equ	%00000011

AM_engine_MASK	equ	%00111100
AM_engine_start	equ	%00000000	;%00100100
AM_engine_stop	equ	%00000000
AM_engine_barner	equ	%00101100
AM_engine_armroll	equ	%00110100


	SHORTA
	LONGI

ps_engine_start_l

;	using	:work0
;		:work1

	phx
	phy
	php

	a8i16

	toheap	y,x

	a16
	lda	exal_chartptr,y
	cmp	#chart_goto_final&WM
	a8
	rlbeq	.exitengine

	lda	Kenemynumber
	beq	.exitengine

; --- start ---
.startpros




.p1engine	s_set_var	B,work0,sdport1
	jsr		.mainpros
	s_set_var	B,sdport1,work0


.exitengine	plp
	ply
	plx
	rtl




.mainpros

;	In	:work0(=sdport1 or sdport2)
;	Out	:work0

;�������������������Ŀ
;�kisyu ni yoru bunki�
;���������������������

	sp_jmp_playertype	x,UFO,.AM
	sp_jmp_playertype	x,ROBOT,.RB

.AW
	pl_jmp_iftransrising	x,.AWstop

	pl_jmpnot_iftransform	x,.AWdo

.AWstop	s_and_var	B,work0,#AW_engine_stop

	jmp		.AWexit

.AWdo

;-- engine level --


	toheap	y,x

	s_and_var	B,work0,#AW_engine_MASK^-1

.AWlv	;speed

	pl_jmp_ifboost	x,.AWlvUP
	pl_jmp_ifbrake	x,.AWlvDW,y

.AWlv1	s_or_var	B,work0,#AW_engine_start
	bra	.exitAWlv
.AWlvUP	s_or_var	B,work0,#AW_engine_speedup
	bra	.exitAWlv
.AWlvDW	s_or_var	B,work0,#AW_engine_speeddown

.exitAWlv

;--------------------------------------------------------------------------------
.AWhoriLV

	s_AND_var		B,work0,#AW_engine_horiMASK^-1

;-- sui-hei kasoku & jyo-syo ka-kou --

	s_copy_alvar2var	W,x,y1,al_vy

	pl_abs_var		W,y1

	s_set_var		B,x1+1,#0
	pl_get_pilotTAB		B,x,x1+0,speed_tab
	lsr	x1
	lsr	x1
	lsr	x1
	s_jmp_varLESS		W,y1,x1,.nnn

	s_or_var		B,work0,#%00010000

.nnn

;HORI-- -- -- -- --

.AWHORI
	s_copy_alvar2var	W,y,work1,exal_acclroty
	s_jmp_varPL		W,work1,.AWhorilvPL
	s_neg_var		W,work1

.AWhorilvPL
	pl_jmp_ifrollstart	x,.AWh3

	s_jmp_varMORE	W,work1,#rotyacclBRAKE,.AWh3
	s_jmp_varMORE	W,work1,#rotyacclLR,.AWh2
	s_jmp_varMORE	W,work1,#rotyaccl,.AWh1
	bra		.AWexit

.AWh1	s_or_var	B,work0,#AW_engine_horiLV1
	bra		.AWexit
.AWh2	s_or_var	B,work0,#AW_engine_horiLV2
	bra		.AWexit
.AWh3	s_or_var	B,work0,#AW_engine_horiLV3
	bra		.AWexit




.AWexit
	pl_jmpnot_iftransrising	x,.exitmainpros,y

	s_or_var	B,work0,#RB_engine_echo
	jmp		.exitmainpros

;--------------------------------------------------------------------------------

.RB	toheap		y,x

	s_and_var		B,work0,#RB_engine_stop

	pl_jmpnot_ifinthesea	x,.exitmainpros
	s_or_var		B,work0,#RB_engine_echo
	bra			.exitmainpros


.AM
	pl_jmpNOT_iftransform	x,.AMdo
.AMstop	s_and_var	B,work0,#AM_engine_stop
	jmp		.exitmainpros

.AMdo	s_and_var	B,work0,#AM_engine_MASK^-1
	pl_jet		x,check
	bne		.AMb
.AMn	s_set_var	B,work0,#AM_engine_start
	bra		.AMr
.AMb	s_set_var	B,work0,#AM_engine_barner

.AMr	pl_jmpNOT_ifarmrollsound	x,.AMnoroll,y
	s_or_var	B,work0,#AM_engine_armroll

.AMnoroll

.exitmainpros

.exit

	rts

;����������������������������������������������������������������������������������
;	READ PLAYER CONTROLLER
;����������������������������������������������������������������������������������
;	set	ptrig&pcont

playercontroller_srou_l

	s_start_strat

	PUSHYP

	a8i16

	ldy			#0
	sty			pcont
	sty			ptrig

	toheap	y,x

	km_jmpgameflag	freeze,.skip0

	pl_jmp_iftransrising	x,.skip0,y

	s_playercontroller


;AUTOFIRE
;	a16
;	lda	gameframe
;	and	#3
;	bne	.lll
;	lda	pcont
;	ora	#pad_Y
;	sta	pcont
;	lda	ptrig
;	ora	#pad_Y
;	sta	ptrig
;.lll	a8



	sp_jmpnot_playertype	x,ARWING,.cntEND,y

	lda	#player_controltype_1B
	and	player_controltype
	beq	.cntEND

.cntB	a16
	lda	pcont
	jsr	.swap
	sta	pcont
	lda	ptrig
	jsr	.swap
	sta	ptrig
	a8
.cntEND

;-----------------------------------------------------------------------------
;ABXY type

	lda	player_controltypeABXY
	beq	.defABXY

	a16
	lda	pcont
	jsr	.swapABXY
	sta	pcont
	lda	ptrig
	jsr	.swapABXY
	sta	ptrig
	a8

.defABXY
;-----------------------------------------------------------------------------

	a16
	lda	pcont
	sta	p_pcont
	lda	ptrig
	sta	p_ptrig
	a8

 	s_jmp_alvarAND	B,y,exal_control,#exal_control_on,.keyon

.keyoff	a16

	lda	pcont
	and	#pad_start
	sta	pcont
	lda	ptrig
	and	#pad_start
	sta	ptrig

.keyon	a16

	lda	exal_key_trig,y
	ora	ptrig
	sta	ptrig

	lda	exal_key_cont,y
	ora	pcont
	sta	pcont

	lda	#0
	sta	exal_key_cont,y
	sta	exal_key_trig,y
	a8

.skip0	PULLYP


	rtl


.swap	LONGA
	LONGI

	pha
	and	#~(pad_up!pad_down)
	sta	x1
	pla
	pha
	and	#pad_down
	asl	a
	sta	x2
	pla
	and	#pad_up
	lsr	a
	ora	x2
	ora	x1
	rts


.swapABXY	LONGA
	LONGI

	sta	x1	; import
	stz	x2	; export

.A	and	#pad_A
	lsr	a
	sta	x2

.B	lda	x1
	and	#pad_B
	xba
	ora	x2
	sta	x2

.X	lda	x1
	and	#pad_X
	xba
	ora	x2
	sta	x2

.Y	lda	x1
	and	#pad_Y
	asl	a
	ora	x2
	sta	x2

	lda	x1
	and	#~(pad_A!pad_B!pad_X!pad_Y)
	ora	x2

	rts


;����������������������������������������������������������������������������������
;	CHANGE PLAYER'S MODE
;����������������������������������������������������������������������������������
modechangesrou_l
	s_start_strat
	s_mode_change		x,x1
	rtl
;����������������������������������������������������������������������������������
;	RAM initial
;����������������������������������������������������������������������������������
	SHORTA
	LONGI

player_RAMinit_l	; (game)

	phx
	phy
	php
	a8i16

; key data clear

	s_playercontroller

	a16
	lda	#0
	sta	pcont
	sta	ptrig
	a8

	s_set_var	B,playerctlmode,#0	; clear player control mode

	stz	PMODE

;------------------------------------------------------------------------------
; for wolf BGM

	stz	wolfsoundoff

;------------------------------------------------------------------------------
; for shield

	stz	shieldinit

;------------------------------------------------------------------------------

	lda	P1_maxHP
	cmp	p1_HP
	bpl	.noHP
	sta	P1_HP
.noHP

;------------------------------------------------------------------------------

	stz	p1_firerotx

;------------------------------------------------------------------------------
; attack start demo no distance

	ldy	#800
	sty	p1_dist2cam

	ldy	#-10
	sty	p1_vz2enemy

;------------------------------------------------------------------------------
;export suru flag

	stz	playerexportflag

;------------------------------------------------------------------------------
; starwolf

	stz	starwolf_demo

;------------------------------------------------------------------------------
; planet mode

	stz	planet_mode

;------------------------------------------------------------------------------
; boostmeter,cursor on off flag
; 1 : on
	stz	displayflag

;------------------------------------------------------------------------------
; Enemy work ram

	stz	Etrigger

;------------------------------------------------------------------------------
;	lda	#0	;player_controltype_1B!player_controltype_2B
;	sta	player_controltype


; player remain

	stz	demomsg	; message

	stz	demomode

	lda	#demo_off
	sta	demoNo
	sta	demoNoNext
	sta	demoNoClear

;------------------------------------------------------------------------------
; inter demo
	stz	demoflag	; MAPMACS.INC demo initial siteru!

	stz	intermapbank
	ldy	#0
	sty	intermapptr
;------------------------------------------------------------------------------

	stz	BOSSstatus
	stz	andorfDEAD

	stz	p1_markstatus

	stz	voffsetflag
	stz	player1_hpadd
	stz	player1_hpadd
	stz	p1_status
	stz	p2_status
	stz	sdport1
	stz	sdport2

;------------------------------------------------------------------------------
; view change flag etc....

;	lda	playerimportflag
;	ora	#pif_cockpit_trig
;	sta	playerimportflag

;------------------------------------------------------------------------------

	lda	#100
	sta	p1_targetx
	sta	p1_targetx

	a16

	stz	demoshapeptr
	stz	clrdemoshape_x
	stz	clrdemoshape_y
	stz	clrdemoshape_z

	stz	attackx
	stz	attacky
	stz	attackz

	stz	BOSSptr

	stz	calcbuf

	stz	player1_worldx
	stz	player1_worldy
	stz	player1_worldz

	stz	player1_vx
	stz	player1_vy
	stz	player1_vz


	stz	player1hscroll_offset
	stz	player1vscroll_offset
	stz	player1_horizon
	stz	player1_horizon_Wofs
	stz	player1_horizonbak
	stz	p1_camrotzbuf

	stz	SEADEPTH	; depth of sea


;byte	sta	p2_targety
;	sta	p2_targety
;word	stz	p2_camrotzbuf
;	stz	player2_horizonbak
;	stz	player2_horizon_Wofs
;	stz	player2_horizon
;	stz	player2vscroll_offset
;	stz	player2hscroll_offset
;	stz	player2_worldx
;	stz	player2_worldy
;	stz	player2_worldz
;	stz	player2_vx
;	stz	player2_vy
;	stz	player2_vz

	a16
	stz	slopeptrold
	a8
	stz	slopenumold

	plp
	ply
	plx
	rtl



;����������������������������������������������������������������������������������
;	BATTLE ga owattaka check suru.
;����������������������������������������������������������������������������������
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
battle_end_l
	s_start_strat

	sm_jmp_if2screen	.exit
;	test_screenmode	onescreen
;	beq	.exit
;----------------------------------------------------------------------------------
	s_jmp_alsflag	x,player2,.p2
;----------------------------------------------------------------------------------
.p1	pl_jmp_ifplayer2dead	.win
	bra			.exit
.p2	pl_jmp_ifplayer1dead	.win
	bra			.exit
;----------------------------------------------------------------------------------
.win	pl_control	x,off
	pl_mode_change	x,DM_AWC_0_0_init
;----------------------------------------------------------------------------------
.exit
	rtl
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;����������������������������������������������������������������������������������
;	TABLE of ARWING
;����������������������������������������������������������������������������������
shape_ARWING	; in space Armer

	DW	A_WING	; fox
	DW	C_WING	;
	DW	B_WING	;

shape_ROBOT_NULL	; walker

;	DW	nullROBOTA
;	DW	nullROBOTB
;	DW	nullROBOTB

shape_ROBOT_HEAD	; walker

	DW	A_ROBO	; fox
	DW	C_ROBO
	DW	B_ROBO

shape_ARMER_BODY	; in space Armer

	DW	a_robo
	DW	c_robo
	DW	b_robo

;����������������������������������������������������������������������������������
;	player no parts(ude toka ashi toka...)no initial
;����������������������������������������������������������������������������������
plobjinit_srou_l

	PHP
	s_start_strat
	a8i16
	s_start_strat

	s_set_alsflag		y,notslope
	s_set_alsflag		y,colldisable
	s_set_aldata		y,#1,#1
	s_set_alvartobeobj	y,al_ptr,x
	s_copy_pos		y,x
	s_copy_rots		y,x
	s_clr_alsflag		y,shadow

	PLP
	rtl

;����������������������������������������������������������������������������������
; worldx,y,z buffer <---> worldx,y,z
;����������������������������������������������������������������������������������
set_exal2worldxyz_srou

	PUSHYP

	s_start_strat

	ai16

	toheap	y,x

	lda	exal_worldx,y
	sta	al_worldx,x
	lda	exal_worldy,y
	sta	al_worldy,x
	lda	exal_worldz,y
	sta	al_worldz,x

	PULLYP

	rts

set_worldxyz2exal_srou

	PUSHYP

	s_start_strat

	ai16

	toheap	y,x

	lda	al_worldx,x
	sta	exal_worldx,y

	lda	al_worldy,x
	sta	exal_worldy,y

	lda	al_worldz,x
	sta	exal_worldz,y

	PULLYP

	rts

;����������������������������������������������������������������������������������
;	hit strats
;	hit_hlptr	hit list pointer(16bit)
;	hit_ap		hitter's AP	(16bit)
;	hit_framecount	hit counter	(8bit)
;����������������������������������������������������������������������������������

;���������������������ͻ
;�  HIT STRAT : FIRST  �
;���������������������ͼ

hitplayer_start

hitplayer_while

hitplayer_end

	s_start_strat

	PUSHXYP
	a8i16

;------------------------------------------------------------------------------------

	toheap	y,x

	lda	exal_nohit,y
	rlbne	.setAP1
	
	pl_jmp_ifcontroloff	x,.setAP1,y

;------------------------------------------------------------------------------------
; SP arwing ha damage hanbun

;	pl_lda_PILOTNoFSG	x
;	cmp	#ep_SP
;	bne	.noSP

	lda	hit_ap

	IFNE	DamageHalf
	asr	a
	ENDC

	sta	hit_ap
.noSP
;------------------------------------------------------------------------------------

	pl_jmp_iftransform	x,.setAP1

;DEBUG*********************
	ldy	hit_hlptr
	a16
	lda.w	hl_alptr,y
	tay
	a8
;**************************

; rolling dattara weapon dake hanekaesu.

	lda	Kenemynumber
	rlbeq	.setAP1

	lda	demomode
	rlbne	.setAP1


;.nockKNUM

;************
;	IFEQ	PLAYERHIT
;
;	s_jmp_colltype	y,LASER,.weapon
;	s_jmp_colltype	y,ENEMYWEAP,.weapon
;	s_set_var	B,hit_ap,#0
;	jsl		shock_wave_srou_l
;	bra		.sound
;.weapon
;	ENDC
;************

	pl_jmp_ifitemshield		x,.shieldon

	pl_jmpnot_ifrollingshield	x,.noshield

	s_jmpnot_colltype	y,LASER,.noshield
	bra			.setAP0

.shieldon
	s_push_obj	y
	toheap		y,x
	s_set_alvar	B,y,exal_scrflash,#1

	lda	exal_scrflash_flag,y
	ora	#exal_scrflash_flag_shield
	sta	exal_scrflash_flag,y

	s_pull_obj	y

.setAP0

	jsl	reflectSE_srou_l

;;;	kplsound	x,shieldreflect


; make rebound obj

	jsl	rebound_srou_l

.setAP1	s_set_var	B,hit_ap,#0

	s_clr_alsflag	x,hitflash

	jmp		.exitsound

.noshield

;-----------------------------------------------------------------------------

	s_jmpnot_alsflag	y,fireobj,.burnoff

; make burn
	PHY

	toheap	y,x

.LW	lda	al_hitflags,x
	bit	#HF2
	beq	.RW
	pl_burn	x,on,L,y


.RW	lda	al_hitflags,x
	bit	#HF3
	beq	.B
	pl_burn	x,on,R,y


.B
	lda	al_hitflags,x
	bit	#HF1
	beq	.burnend
	pl_burn	x,on,C,y

.burnend
	PLY

.burnoff

	lda	al_hitflags,x
	and	#~(HF1!HF2!HF3)
	sta	al_hitflags,x

;-----------------------------------------------------------------------------

	jsl	shock_wave_srou_l

;�����������������������������������������������������������������������������
;	hitter's =! then goto hit pros
;�����������������������������������������������������������������������������
;	s_jmp_varnotZERO	B,hit_ap,.hit
;.nohit	s_clr_alsflag	x,hitflash
;	bra		.object
;�����������������������������������������������������������������������������
;	effect of hitting
;�����������������������������������������������������������������������������
.hit	jsl		hit_effect_l
.sound	s_jmp_varless	B,hit_ap,#4,.ss
.sl	kplsound	x,damage_l
	bra		.exitsound
.ss	kplsound	x,damage_s
.exitsound
;�����������������������������������������������������������������������������
.object	;;;jsr	pushobjct_srou
;�����������������������������������������������������������������������������

	toheap	y,x

	lda	exal_HP,y
	beq	.death

	sec
	sbc	hit_ap
	sta	exal_HP,y
	bpl	.AP0

	lda	#0
	sta	exal_HP,y

.AP0	lda	#0
	sta	hit_ap

.death	; hit_ap wa sonomama.

.exit	PULLXYP

	s_end_strat




;���������������������ͻ
;�  HIT STRAT : WHILE  �
;���������������������ͼ
;�������������������ͻ
;�  HIT STRAT : END  �
;�������������������ͼ

;hitplayer_while
;hitplayer_end

;	s_start_strat
;
;	PHP
;
;	a8i16
;
;	s_clr_alsflag	x,hitflash
;
;	lda	#0
;	sta	hit_ap
;
;	PLP
;
;	s_end_strat

;************

shock_wave_srou_l

	s_start_strat

	PHP

	a8i16

	lda	playerctlmode
	cmp	#map_room
	beq	.noshock

	sp_jmp_playertype	x,ROBOT,.noshock

	s_jmp_colltype	y,LASER,.noshock

	s_push_obj	y

	s_obj2obj_angle	x,y,al_pbyte1,0

	lda	al_roty,x
	cmp	al_pbyte1,x
	bmi	.mis
.pls	lda	#deg90
	bra	.sr
.mis	lda	#-deg90
.sr	ldy	dummyobj


	toheap	y,x


	sta	exal_rotyoffsetSHOCK,y
	adiv2
	sta	exal_shockvel,y

	s_pull_obj	y

.noshock

;	jsl	hit_effect_l
;	jsl	crash_effect_l

;************

	PLP

	rtl


;�����������������������������������������������������������������������������
;	if hitter's colltype = OBJECT then copy vector
;
;	in	idX		: player's pointer
;		hit_hlptr	: hitlist pointer
;
;�����������������������������������������������������������������������������

fireobjct_srou

	s_start_strat

	PHY

;-------------------------------------------------------------------------------------------------

	ldy	al_hitlist,x
	rlbeq	.exit

;-------------------------------------------------------------------------------------------------
; X hitter's pointer


.next	a16
	lda.w	hl_alptr,y
	tay
	a8

	s_jmpnot_alsflag	y,fireobj,.cont

.cont	a16
	lda.w	_next,y
	tay
	a8

	rlbne	.next

;-------------------------------------------------------------------------------------------------
.exit
	PLY

	rts


;����������������������������������������������������������������������������������
;	Transform suru ka sinaika....
;����������������������������������������������������������������������������������
;	in	x1:next mode
;		idX:player pointer

settransform_srou_l

st_nexttype		equ	x1
st_nextctlmode	equ	y1
st_nexttransmode	equ	z1

	PUSHYP

	a8i16

	toheap	y,x

;-------------------------------------

	lda	exal_transENDse,y
	bit	#exal_transENDse_notEND
	rlbne	.noselect

.fall	pl_jmpnot_ifinthesea		x,.rise
	pl_jmpnot_ifcamintheseareally	x,.noselect,y


.rise	pl_jmp_ifinthesea		x,.start
	pl_jmp_ifcamintheseareally	x,.noselect,y

.start

;	testjoypad	tleft,pcont
;	beq		.cks
;	testjoypad	tright,pcont
;	bne		.noselect

.cks	testjoypad	select,ptrig
	beq		.noselect

	lda	exal_CTLtype,y
	and	#exal_CTLtype_notrans!exal_CTLtype_notransreally
	bne	.boo

;{ = sp_trans_d0

	lda	exal_shapeNoNEXT,y
	and	#exal_shapeNo_ctmask^-1
	ora	x1	;#ct_{type}
	sta	exal_shapeNoNEXT,y
;}

	bra	.noselect

.boo

.noselect

;-------------------------------------
; transform suru?


;[same control type?]

	a16

	lda	exal_shapeNoNEXT,y
	and	#exal_shapeNo_ctmask

	and	#exal_shapeNo_ctmask
	rlbeq	.notrans

	PHA

;clear
	lda	exal_shapeNo,y
	and	#exal_shapeNo_ctmask
	sta	tpx
	PLA
	cmp	tpx
	beq	.notrans

; read table data

	jsr	getctldat_srou

;[same type?]


	lda	exal_shapeNo,y
	and	#exal_shapeNo_stmask
	cmp	st_nexttype
	beq	.ctlmode


;[do transform]

.transmode

;[transform kinshi flag]

	lda	exal_CTLtype,y
	bit	#exal_CTLtype_notransreally
	bne	.notrans
	bit	#exal_CTLtype_notrans
	beq	.nolock
	and	#exal_CTLtype_notrans^-1
	ora	#exal_CTLtype_notransreally
	sta	exal_CTLtype,y
.nolock

	jsr	gettransdat_srou
	lda	st_nexttransmode
	beq	.notrans

	bra	.set


;[change control]

.ctlmode

	lda	exal_shapeNoNEXT,y
	and	#exal_shapeNo_ctmask^-1
	sta	exal_shapeNoNEXT,y

	lda	st_nextctlmode
	sta	x1

	a8
	s_mode_change	x,x1
	PULLYP
	clc
	rtl

.set	LONGA
	sta	x1
	a8
	s_mode_change	x,x1
	PULLYP
	sec
	rtl

.notrans	a8
	PULLYP
	clc
	rtl

;-----------------------------------------------------------------------------

getctldat_srou

;	in	:exal_shapeNoNEXT bit 0-3
;	out	:st_nexttype(next type)
;		:st_nextctlmode(next control mode)

	PUSHXYP

	ai16
	ldy	al_sword2,x
	lda	exal_shapeNoNEXT,y

	and	#exal_shapeNo_ctmask

;	printh	NEXTNo,kawagoe

	asl	a
	asl	a


	tax

	lda.l	ctltable,x
	sta	st_nexttype

	lda.l	ctltable+2,x
	sta	st_nextctlmode

	PULLXYP

	rts


gettransdat_srou

;	in	:exal_shapeNoNEXT bit 0-3
;	out	:z1(next trans mode)

	PUSHXYP

	a8i16

	toheap	y,x

	sp_jmp_playertype	x,ROBOT,.rb,y
	sp_jmp_playertype	x,UFO,.am,y

	lda	exal_shapeNoNEXT,y
	and	#exal_shapeNo_ctmask
	cmp	#ct_robot
	beq	.aw2rb

.aw2am	ldy	#pl_arwing2armer	; trans
	bra	.set
.aw2rb	ldy	#pl_arwing2robo		; trans
	bra	.set

.am	ldy	#pl_armer2arwing	; trans
	bra	.set
.rb	ldy	#pl_robo2arwing		; trans

.set	sty	st_nexttransmode

	PULLXYP

	rts


;--------------------------------------------------------------------------------
; player mode table

ctltable

;dummy
	dw	0
	dw	0	;dummy

;ct_OF_ARWING

	dw	st_OF_ARWING<<4
	dw	of_arwing_init	; control

;ct_CS_ARWING

	dw	st_CS_ARWING<<4
	dw	cs_arwing_init	; control

;ct_ARMER
	dw	st_ARMER<<4
	dw	is_armer_init	; control

;ct_ROBOT
	dw	st_ROBOT<<4
	dw	of_robo_init	; control



;transtable

;dummy
	dw	0
;
;ct_OF_ARWING

;	dw	pl_arwing2robo	; trans

;ct_CS_ARWING

;	dw	pl_arwing2armer	; trans

;ct_ARMER

;	dw	pl_armer2arwing	; trans

;ct_ROBOT

;	dw	pl_robo2arwing	; trans



;����������������������������������������������������������������������������������
;	PL_DO_CTLandVIEW de tsukau.
;����������������������������������������������������������������������������������
do_viewstrat_srou

	s_start_strat

;	jsl	blockmap_srou_l

	c_do_viewstrat

	jsl	set_inbet_l

	rts

;����������������������������������������������������������������������������������
;	MAP ROUTINE
;����������������������������������������������������������������������������������

map_arwing_init_l

;Call from map files. use map macro "map_arwing_init"

;in	y1(1word):player move area high
;	y2(1word):player move area low
;	x1(1byte):player max rotx
;	x2(1byte):player min rotx

	PUSHXYPB

	a8i16

	lda	#7eH
	pha
	plb

	ldx	playpt1
	jsr	.set


	IFEQ	NOBATTLE
;------------>>>>>>>>>>>>>>>>
	sm_jmp_if1screen	.exit
;	test_screenmode	onescreen
;	bne	.exit
	ldx	playpt2
	jsr	.set
;------------<<<<<<<<<<<<<<<<
	ENDC


.exit	jmp	maprou_end


.set	toheap	y,x
	a16
	lda		y1	;#-({high})
	sta		exal_maxPmoveY,y
	lda		y2	;#-({low})
	sta		exal_minPmoveY,y
	a8
	lda		x1	;#{rotxmax}
	sta		exal_maxProtX,y
	lda		x2	;#{rotxmin}
	sta		exal_minProtX,y


	rts

;-------------------------------------------------------------------------------------

; misiion mode no toki no camera no parameter no initial
; Call from map files. use map macro "map_camerainit_1screen"

;in	y1(1word):camera move center
;	y2(1byte):camera-player no y offset no max
;	y3(1byte):camera-player no y offset no hayasa
;	x1(1byte):camera max rotx
;	x2(1byte):camera min rotx

map_camerainit_1screen_l
map_camerainit_2screen_l

	PUSHXYPB
	a8i16
	ldx		playpt1

;	bra		map_camerainit_2screen_l.enter
;	PUSHXYPB
;	a8i16
;	ldx	playpt2
;
;.enter	LOCAL

	beq	.exit

	toheap		y,x

	lda	#7eH
	pha
	plb

	a16
	lda	y1
	sta	exal_midCmoveY,y

	a8
	lda	y2
	sta	exal_camYofsMAX,y
	lda	x1
	sta	exal_maxCrotX,y
	lda	x2
	sta	exal_minCrotX,y
	lda	y3
	sta	exal_camYofsrate,y

.exit
	jmp	maprou_end


;-------------------------------------------------------------------------------------
; player position no initial

;in	p1_worldx_init(1word):worldx
;	p1_worldy_init(1word):worldy
;	p1_worldz_init(1word):worldz
;	p1_roty_init  (1byte):roty


map_setplayerpos_1_l
map_setplayerpos_2_l

	PUSHXYPB
	a8i16
	ldx	playpt1

	lda	#7eH
	pha
	plb
	a16

	lda	p1_worldx_init
	sta	al_worldx,x
	lda	p1_worldy_init
	sta	al_worldy,x
	lda	p1_worldz_init
	sta	al_worldz,x

	a8
	toheap	y,x
	lda	p1_roty_init
	sta	exal_roty+1,y
	sta	al_roty,x

	nega

	sta	exal_camroty+1,y
	ldy	#viewblk1
	sta.w	al_roty+1,y

	jmp	maprou_end


;-------------------------------------------------------------------------------------
; player v scroll(offset) wo off ni suru.

; Call from map files. use map macro "map_vscrolloff"

map_vscroll_off_l

	PUSHXYPB

	a8i16

	BANK7E

	ldx	playpt1
	jsr	.set

	a16
	lda	screenvheight
	cmp	#24*8
	a8
	beq	.exit

	ldx	playpt2
	jsr	.set
	bra	.exit


.exit
	jmp	maprou_end


.set	toheap	y,x
	lda	exal_VIEWflag3,y
	ora	#exal_VIEWflag3_vscrloff
	sta	exal_VIEWflag3,y
	rts


;-------------------------------------------------------------------------------------
; player no TUTU mode wo on ni suru.

; Call from map files. use map macro "map_playerTUTUmode"

; in	:tpx direction flag (see talcs.inc)

map_playerTUTUmode_l

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	PUSHXYPB
	a8i16
	BANK7E
;in	: x1 data address
;	: tpx direction flag (see talcs.inc)
	SHORTA
	LONGI
	ldy	playpt1
	toheap	y,y
	lda	tpx	;#exal_TUTUdir_{dir}
	sta	exal_TUTUdir,y
	lda	exal_control2,y
	ora	#exal_control2_TUTU
	sta	exal_control2,y
	lda	tpx	;#exal_TUTUdir_{dir}
	sta	exal_TUTUdir,y
	a16
	lda	x1+0
	sta	exal_TUTUptr+0,y
	lda	x1+1
	sta	exal_TUTUptr+1,y
	lda	[x1]
	sta	exal_TUTUheight,y
	sta	exal_TUTUheightcurrent,y
	dec	a
	eor	#-1
	and	al_worldy,x
	sta	exal_TUTUlevel,y
	sta	exal_TUTUlevelcurrent,y
	a8
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

	jmp	maprou_end

;-------------------------------------------------------------------------------------
; player no block map no check wo off ni suru.

; Call from map files. use map macro "map_playerblockmap_off"

map_playerblockmap_off_1_l
map_playerblockmap_off_2_l

	PUSHXYPB

	a8i16

	ldx	playpt1

	BANK7E

	toheap	y,x
	lda	exal_blockflag,y
	ora	#exal_blockflag_off
	sta	exal_blockflag,y

	jmp	maprou_end


map_playerblockmap_on_1_l
map_playerblockmap_on_2_l

	PUSHXYPB

	a8i16

	ldx	playpt1

	BANK7E

	toheap	y,x
	lda	exal_blockflag,y
	and	#~exal_blockflag_off
	sta	exal_blockflag,y

	jmp	maprou_end


;---------------------------------------------------------------------------------
; player position no initial (space mode)

;in	p1_worldx_init(1word):worldx (normal:0)
;	p1_worldy_init(1word):worldy (normal:0)
;	p1_worldz_init(1word):worldz
;	p1_roty_init  (1byte):roty

;	e_worldx_init(1word):enemy's worldx
;	e_worldz_init(1word):enemy's worldz



map_setplayerpos_battleship_l

msb_dist2enemy	equ	work9

	PUSHXYPB
	a8i16

	ldy	#18000
	sty	msb_dist2enemy

	bra	map_setplayerpos_relative_l.enter

map_setplayerpos_relative_l

	PUSHXYPB
	a8i16

	ldy	#0
	sty	msb_dist2enemy

.enter	LOCAL

	ldx	playpt1
	rlbeq	.exit

	lda	#7eH
	pha
	plb

; set attackrnd	; attack-rotx wo random ni set suru.

	lda	attackrnd
	clc
	adc	#1
	and	#7
	sta	attackrnd

	a16

	lda	p1_worldx_init
	sta	al_worldx,x
	lda	#0
	sta	al_worldy,x
	lda	p1_worldz_init
	sta	al_worldz,x

	ldy	dummyobj
	lda	e_worldx_init
	sta.w	al_worldx,y
	lda	#0
	sta.w	al_worldy,y
	lda	e_worldz_init
	sta.w	al_worldz,y

	a8

	s_obj2obj_angle		x,y,al_roty,0

;***********
;test	s_add_rnd2alvar		x,al_roty,#255
;	s_copy_alvar2var	B,x,p1_roty_init,al_roty
;***********
;*** battle ship ***

	a16
	lda	msb_dist2enemy
	beq	.notbattleship
	nega
	sta	z1
	a8
	c_add_Roffs2pos16	W,x,x,x,#0,#0,z1,0,1,0
.notbattleship
	a8

;*******************

	toheap	y,x

; SPACE BATTLE no opening demono wo set suru.

	lda	p1_roty_init
	sec
	sbc	al_roty,x
	clc
	adc	#deg90
	bmi	.back

.mae	lda	#demo_attack
	bra	.stademo
.back
;;;;;;;	lda	#demo_attackback
	lda	#demo_attack

.stademo	sta	exal_demoNo_attack,y

; PLAYER no initial.

	lda	p1_roty_init
	sta	exal_roty+1,y
	sta	al_roty,x

	nega

	sta	exal_camroty+1,y
	ldy	#viewblk1
	sta.w	al_roty+1,y
.exit
	jmp	maprou_end



;---------------------------------------------------------------------------------

maprou_end	PULLXYPB

	rtl


;  ����������������������������������������������������������ͻ
;  �                                                          �
;  �                  STRATS FOR PLAYER                       �
;  �                                                          �
;  ����������������������������������������������������������ͼ

;  -- PLAYER MODE TABLE --



PLAYERMAIN

.strat	LOCAL

	s_start_strat

	toheap	y,x

	a8

;-------------------------------------------------------------------------------------------
; set HP parameters

	pl_get_pilotTAB		B,x,P1_maxMETER,maxMETER_tab
	pl_get_pilotTAB		B,x,P1_maxHP,maxHP_tab
	lda	p1_maxHP
	cmp	exal_HP,y
	bpl	.endHP
	sta	exal_HP,y
.endHP

;-------------------------------------------------------------------------------------------

;	jsl	setcoreENTERroty_srou_l	; call from player strat


;	lda	exal_BGM,y
;	printh	exal_BGM,kawagoe
;	lda	ebyte1
;	printh	ebyte1,kawagoe


	jsl	pass_sound_srou_l

;	jsl	rotate_Proty_l
;	a16
;	lda	x2
;	printh	PPPWX,kawagoe
;	lda	z2
;	printh	PPPWZ,kawagoe
;	a8
;
;	a16
;	lda	exal_vz,y
;	printh	EXAL_VZ,kawagoe
;	a8


	a8i16

;	lda	exal_control,y
;	printb	exal_control,h,kawagoe

;	lda	exal_blockflag,y
;	printb	BLOCK,kawagoe

;	a16
;	lda	al_worldy,x
;	printh	y,kawagoe
;	a8

;	lda	al_worldz,x
;	printh	z,kawagoe
;	a8

;	a16
;	lda	#exal_start
;	printh	exal_start,kawagoe
;	a8

;	lda	al_ap,x
;	printh	al_ap,kawagoe


;	a16
;	lda	screenvheight
;	printh	screenvh,kawagoe
;	a8


;	lda	al_vel,x
;	printh	AL_VELGGGGG,kawagoe
;	s_set_alvar	B,x,al_vel,#30



;	lda	exal_vel,y
;	printh	exal_vel,kawagoe
;	lda	al_vel,x
;	printh	al_vel,kawagoe

;	lda	exal_HP,y
;	printh	exaL_HP,kawagoe

                                    ;	lda	Kringouttimer,y
;	printh	kring,kawagoe

;	a16
;	lda	al_ptr,x
;	printh	POINTER,kawagoe
;	a8

;------------------------------------------------------------------------------

	s_clr_alsflag		x,insidecockpit

;------------------------------------------------------------------------------
	a16
	stz	player1_vx
	stz	player1_vy
	stz	player1_vz
	a8
;------------------------------------------------------------------------------
; damage meter SE

	lda	exal_HPmeterSE,y
	cmp	#10
	beq	.nodmgse
	inc	a
	sta	exal_HPmeterSE,y
	cmp	#10
	bne	.nodmgse

	lda	exal_HP,y
	cmp	#3*4+1
	bpl	.nodmgse
	cmp	#1*4+1
	bmi	.s1

.s2	kplsound	x,salarm_s	; sound
	bra		.nodmgse
.s1	kplsound	x,salarm_h	; sound


.nodmgse

;------------------------------------------------------------------------------
	km_jmpnotgameflag	freeze,.notfreeze
	s_set_alvar		B,y,exal_laser_LMT,#0
.notfreeze
;------------------------------------------------------------------------------

;	jsl	cc_copy2buffer_l

;	s_count_childs	x,x1
;	lda	x1
;	printh	CHILD_NUMBER,kawagoe

	toheap	y,x

;	lda	planet_mode
;	printh	planet_mode,kawagoe


;	lda	exal_control2,y
;	printh	CONTROL2,kawagoe

;	lda	exal_tutudir,y
;	printh	DIRDIR,kawagoe

;	a16
;	lda	al_worldy,x
;	printh	WORLDY,kawagoe
;	a8


;	jsl	Check_KGWindow_l

;	jsr	kawaguchi_hit


.up

;HHHH	km_jmpgameflag	freeze,freeze_end_strat


;	testjoypad	Y,ptrig
;	rlbeq		.noburn

;	pl_burn		x,on,ALL

.noburn
	toheap	y,x

;	lda	exal_laser_LMT,y
;	printh	LMT,kawagoe


;	lda	exal_spweap_LMT,y
;	and	#0fH
;	printh	spweapnum,kawagoe



;;;	s_set_colltype	x,FRIEND

	a8

;-----------------------------------------------------------------------------
; call time chart routine

	jsl	timechart_l

;-----------------------------------------------------------------------------

	toheap	y,x

	a8

;	lda	#tarwing_sizeof
;	printh	<HEAP SIZE>,kawagoe

;������������Ŀ
;�set pilot No�
;��������������

.p1PN	s_copy_alvar2var	B,y,p1_HP,exal_HP
	s_copy_alvar2var	B,y,p1_spweap_type,exal_spweap_TYPE
	s_copy_alvar2var	B,y,p1_spweap_LMT,exal_spweap_LMT
	s_copy_alvar2var	B,y,p1_weap_level,exal_weap_level

;�������������������������������Ŀ
;�tell player's position to enemy�
;���������������������������������

; set player1(2)_worldx,y,z
; set player1(2)_vx,y,z

	jsl	cp_playervecspos_l

;inc general timer

	pl_inc_timer	x

;	lda	demomode
;	rlbeq	.active
;
;	pl_end_strat

;---------------------------------------------------------------------------------------------------------------

.active	s_mode_table

; main control mode ......

	s_mode_entry	Onfield_robo_init,of_robo_init
	s_mode_entry	Onfield_robo,of_robo
	s_mode_entry	Onfield_robo2,of_robo2

	s_mode_entry	Inspace_Armer_init,is_Armer_init
	s_mode_entry	Inspace_Armer,is_Armer

	s_mode_entry	Onfield_Arwing_init,of_Arwing_init
	s_mode_entry	Onfield_Arwing,of_Arwing

	s_mode_entry	Cosmo_Arwing_init,cs_Arwing_init
	s_mode_entry	Cosmo_Arwing,cs_Arwing

; transform mode .......

	s_mode_entry	Aw2Rb_init,pl_Arwing2Robo
	s_mode_entry	Aw2Rb,Tr_Aw2Rb

	s_mode_entry	Rb2Aw_init,pl_Robo2Arwing
	s_mode_entry	Rb2Aw,Tr_Rb2Aw

	s_mode_entry	Aw2Am_init,pl_Arwing2Armer
	s_mode_entry	Aw2Am,Tr_Aw2Am

	s_mode_entry	Am2Aw_init,pl_Armer2Arwing
	s_mode_entry	Am2Aw,Tr_Am2Aw

; demonstration mode ....

;	( clear demo )

;	s_mode_entry	DEMO_AWCLEAR_0_0_init,DM_AWC_0_0_init
;	s_mode_entry	DEMO_AWCLEAR_0_0,DM_AWC_0_0
;	s_mode_entry	DEMO_AWCLEAR_0_1,DM_AWC_0_1

;	( game start demo )

;	s_mode_entry	DEMO_BATTLESTART_0_0_init,DM_BS_0_0_init
;	s_mode_entry	DEMO_BATTLESTART_0_1_init,DM_BS_0_1_init
;	s_mode_entry	DEMO_BATTLESTART_0_0,DM_BS_0_0
;	s_mode_entry	DEMO_BATTLESTART_0_0,DM_BS_0_0

	s_mode_table_end

;����������������������������������������������������������������������������������
;freeze!
;����������������������������������������������������������������������������������

;freeze_end_strat	LOCAL
;
;	s_start_strat
;
;	sp_jmpnot_playertype	x,ROBOT,player_end_strat.addchild
;
;	toheap	y,x
;
;	jsl	RB_setbodypos_srou_l
;
;	s_set_alvar		B,y,exal_laser_LMT,#0
;
;	s_copy_alvar2alvar	W,x,al_worldy,y,exal_bodyworldy
;
;	jmp	player_end_strat.addchild

;����������������������������������������������������������������������������������
;	initial data table
;����������������������������������������������������������������������������������
player_ctl_mode

	dw	.gnd&WM		;0
	dw	.mrn&WM		;1
	dw	.dst&WM		;2
	dw	.cms&WM		;3
	dw	.cms2&WM	;4
	dw	.gnd2&WM	;5
	dw	.tnl&WM		;6
	dw	.sun&WM		;7
	dw	.gnd&WM		;8
	dw	.room&WM	;9

.gnd	BGinitdat	of_Arwing_init,of_robo_init,ground
.mrn	BGinitdat	of_Arwing_init,of_robo_init,marine
.dst	BGinitdat	of_Arwing_init,of_robo_init,desert
.cms	BGinitdat	cs_Arwing_init,is_armer_init,cosmos
.cms2	BGinitdat	cs_Arwing_init,is_armer_init,cosmos
.gnd2	BGinitdat	cs_Arwing_init,is_armer_init,ground2
.tnl	BGinitdat	of_Arwing_init,of_robo_init,tunnel
.sun	BGinitdat	cs_Arwing_init,is_armer_init,sun
.room	BGinitdat	of_Arwing_init,of_robo_init,tunnel


;.gnd	BGinitdat	of_Arwing0_init,DM_BS_0_0_init,ground
;.mrn	BGinitdat	of_Arwing0_init,DM_BS_0_0_init,marine
;.dst	BGinitdat	of_Arwing0_init,DM_BS_0_0_init,desert
;.cms	BGinitdat	cs_Arwing0_init,DM_BS_0_1_init,cosmos
;.cms2	BGinitdat	cs_Arwing0_init,DM_BS_0_1_init,cosmos
;.gnd2	BGinitdat	cs_Arwing0_init,DM_BS_0_0_init,ground2
;.tnl	BGinitdat	of_Arwing0_init,0,tunnel
;.sun	BGinitdat	cs_Arwing0_init,DM_BS_0_0_init,sun
;.room	BGinitdat	of_Arwing0_init,0,tunnel



;����������������������������������������������������������������������������������
;	player no saigo no syori
;����������������������������������������������������������������������������������
player_end_strat

	s_start_strat

	a8i16

	toheap	y,x

;----------------------------------------------------------------------------------
; decriment reflect SE counter


	lda	exal_reflectSE,y
	beq	.norSE
	dec	a
	and	#7
	sta	exal_reflectSE,y	
.norSE

;----------------------------------------------------------------------------------
; debug command

	IFNE	debuginfo

;	testjoypad	tright,pcont
;	beq		.noup
;	testjoypad	tleft,pcont
;	beq		.noup
;	testjoypad	Y,ptrig
;	beq		.noup
;	wm_weaplevelup	x

;.noup	testjoypad	A,pcont
;	beq		.nodead
;	testjoypad	Y,ptrig
;	beq		.nodead
;	testjoypad	tleft,pcont
;	beq		.nodead
;	testjoypad	tright,pcont
;	beq		.nodead
;	s_set_alvar	B,x,al_HP,#0
;.nodead
	ENDC

;----------------------------------------------------------------------------------
; When battle mode then set marker
;	s_jmpnot_alsflag	x,player2,.markP2
;
;.markP1	ldy	playpt1
;	toheap	y,y
;	s_jmp_alvarnotZERO	W,y,exal_enemyaltmeter_objptr,.nomark
;	jsl	addEaltlist_p1_l
;	bra	.nomark
;
;.markP2	ldy	playpt2
;	toheap	y,y
;	s_jmp_alvarnotZERO	W,y,exal_enemyaltmeter_objptr,.nomark
;	jsl	addEaltlist_p2_l
;.nomark
;
;----------------------------------------------------------------------------------
	toheap		y,x
;----------------------------------------------------------------------------------
; HEAL ITEM

	lda		exal_roty+1,y
	sta		y1
	s_set_objtobechild	y,x,#childno_heal
	cpy		#0
	beq		.noHEAL
	s_copy_pos	y,x
	lda		#0
	sta.w		al_rotx,y
	sta.w		al_rotz,y
	s_set_alvar	B,y,al_roty,y1
.noHEAL
;----------------------------------------------------------------------------------
; decno translock timer
;
;	toheap	y,x
;
;	lda	exal_translocktimer,y
;	beq	.nolock
;	dec	a
;	sta	exal_translocktimer,y
;
;	jsl	makedamagespark_srou_l
;
;.nolock
;
;----------------------------------------------------------------------------------

	toheap	y,x

;----------------------------------------------------------------------------------
; alart mode ?

	lda	playerctlmode
	cmp	#map_room
	bne	.add1	;.noalart


;------------ final stage?

	a16
	lda	KGameMapPtr
	cmp	#stg_ext2
	a8
	bne	.notfinal

	lda	ebyte2
	cmp	#255
	beq	.add
	bra	.noalart
.notfinal

;------------

	lda	ebyte2
	cmp	#254
	beq	.add
	cmp	#255
	bne	.add1	;noalart

	bra	.add1

.add
	lda	exal_paletteflag,y
	bit	#exal_paletteflag_trig
	bne	.add0
	ora	#exal_paletteflag_trig!exal_paletteflag_alart!exal_paletteflag_normal
.add0	sta	exal_paletteflag,y

.add1
;;;;	jsl	cc_alart_l

.noalart

;---------------------------------------------------------------------------------
; copy old pos

	ai16
	lda	al_worldx,x
	sta	exal_worldxold,y
	lda	al_worldy,x
	sta	exal_worldyold,y
	lda	al_worldz,x
	sta	exal_worldzold,y
	a8

;����������������������������������������������������������������������������������
;	Rannyu-mode no BGM
;����������������������������������������������������������������������������������

	lda	Kenemynumber
	beq	.notwolfdead

	km_bitcheckmismapflag2	rannyutrig
	beq	.notwolfdead

	lda	wolfsoundoff
	beq	.notwolfdead

;	lda	RannyuModeSwitch
;	cmp	#-1
;	bne	.notwolfdead

	lda	exal_BGM,y
	bit	#exal_BGM_wolfdead
	bne	.notwolfdead
	ora	#exal_BGM_wolfdead
	sta	exal_BGM,y

	KBGM	stg1

.notwolfdead

;����������������������������������������������������������������������������������
;	SE wallreflect
;����������������������������������������������������������������������������������

	lda	exal_blockmapstatus,y

	bit	#exal_blockmapstatus_SE
	beq	.wSEoff

	and	#~exal_blockmapstatus_SE
	sta	exal_blockmapstatus,y

	bit	#exal_blockmapstatus_SEold
	bne	.nowSE
	ora	#exal_blockmapstatus_SEold
	sta	exal_blockmapstatus,y

	sp_jmp_playertype	x,ROBOT,.nowSE

	kplsound	x,wallreflect

	c_addcol_cam	x,shield,plscrflashfrm_s,on,y
	c_shock_cam	x,#scrshock,y


; camera shock!

	pl_jmp_ifbrake	x,.tamebrake,y
	s_set_alvar	W,y,exal_camZofs_tame,#70
	bra	.nowSE

.tamebrake	s_set_alvar	W,y,exal_camZofs_tame,#10
	bra	.nowSE




.wSEoff	and	#~(exal_blockmapstatus_SE!exal_blockmapstatus_SEold)
.wSEset	sta	exal_blockmapstatus,y

.nowSE
;����������������������������������������������������������������������������������
;	Set coltab
;����������������������������������������������������������������������������������

	pl_p2_coltab		x,id_1_c

;����������������������������������������������������������������������������������
;	set burning
;����������������������������������������������������������������������������������

	jsl	makeburnning_l

;������������������������������������������������������������������������������
;	set player shild(sps)
;������������������������������������������������������������������������������

	lda	demomode
	bne	.sps_ck

	lda	Kenemynumber
	beq	.sps_RBexit

	jsl	makeshield_srou_l

	pl_jmpnot_ifshield	x,.sps_RBexit

.sps_RBexit	lda	exal_shield,y
	bit	#exal_shield_mask
	beq	.sps_ck

	lda	gameframe
	and	#7
	bne	.sps_ck

	lda	exal_shield,y
	dec	a
	sta	exal_shield,y
.sps_ck

;����������������������������������������������������������������������������������
;	Set depth offset
;����������������������������������������������������������������������������������
; set depth

	phx
	a16
	lda	exal_depthno,y
	and	#3
	asl	a
	tax
	lda.l	.depthtab,x
	plx
	sta	al_depthoffset,x
	a8

;����������������������������������������������������������������������������������
;	player HP add (pha)
;����������������������������������������������������������������������������������

.pha_p1	lda	player1_hpadd
	stz	player1_hpadd

.pha_add	sta	work0
	beq	.pha_exit
	clc
	adc	exal_hp,y
	cmp	P1_maxHP	;#player_HP
	bcc	.pha_set
	lda	P1_maxHP	;#player_HP
.pha_set	sta	exal_hp,y

	jsl	makehealeffect_srou_l

.pha_exit

;����������������������������������������������������������������������������������
;	move child pos(ashi toka..)
;����������������������������������������������������������������������������������

	pl_jmp_iftransform	x,.AW
	sp_jmp_playertype	x,ROBOT,.RB

.addchild	LOCAL

.AW	s_rotpos_allchildren	x
	bra			.childend

.RB	toheap	y,x
	a16
	lda	al_worldy,x
	sta	work0
	a8
	lda	al_roty,x
	sta	work1+1

	s_copy_alvar2alvar	W,x,al_worldy,y,exal_bodyworldy

	s_add_alvars		B,x,al_roty,y,exal_jetroty

	s_rotpos_allchildren	x

	a16
	lda	work0
	sta	al_worldy,x
	a8
	lda	work1+1
	sta	al_roty,x

.childend

;����������������������������������������������������������������������������������
;	Change pilot (debug mode)
;����������������������������������������������������������������������������������

	toheap	y,x

;**************************************************************************************
; debug mode
;	IFNE	debuginfo
;
;	jsr	testxyz
;
;	testjoypad	up,pcont
;	rlbeq	.nnn
;	testjoypad	select,pcont
;	rlbeq	.nnn
;
;.tleft	testjoypad	tleft,pcont
;	beq		.tright
;
;	wm_setspweaptype	x,bomb
;
;	lda		#ep_FOX
;	bra		.setpilotno
;
;.tright	testjoypad	tright,pcont
;	beq		.A
;
;	wm_setspweaptype	x,bomb
;
;	lda		#ep_FALCO
;	bra		.setpilotno
;
;.A	testjoypad	A,pcont
;	beq		.B
;
;	wm_setspweaptype	x,heal
;
;	lda		#ep_PEPPY
;	bra		.setpilotno
;
;.B	testjoypad	B,pcont
;	beq		.Y
;
;	wm_setspweaptype	x,heal
;
;	lda		#ep_SLIPPY
;	bra		.setpilotno
;
;.Y	testjoypad	Y,pcont
;	beq		.X
;
;	wm_setspweaptype	x,shield
;
;	lda		#ep_GAL1
;	bra		.setpilotno
;
;.X	testjoypad	X,pcont
;	beq		.nnn
;
;	wm_setspweaptype	x,shield
;
;	lda		#ep_GAL2
;	bra		.setpilotno
;
;
;.setpilotno	sta	p1_PILOTNo
;	sta	exal_pilotNo,y
;
;	pl_get_pilotTAB		B,x,P1_maxMETER,maxMETER_tab
;	pl_get_pilotTAB		B,x,P1_maxHP,maxHP_tab
;
;	lda	p1_maxHP
;	cmp	exal_HP,y
;	bpl	.nnn
;	sta	exal_HP,y
;.nnn
;
;	ENDC
;
;**************************************************************************************

;����������������������������������������������������������������������������������
;	CORE BGM
;����������������������������������������������������������������������������������

	lda	playerctlmode
	cmp	#map_room
	bne	.notcoreBGM

	a16
	lda	KGameMapPtr
	cmp	#stg_ext2
	a8
	beq	.ext2

	lda	ebyte2
	cmp	#254
	beq	.254

.ext2	lda	ebyte2
	cmp	#255
	bne	.notcoreBGM


.255	lda	exal_BGM,y
	bit	#exal_BGM_core1
	bne	.notcoreBGM
	ora	#exal_BGM_core1
	sta	exal_BGM,y

	KBGM	boss

	bra	.notcoreBGM


.254	lda	exal_BGM,y
	bit	#exal_BGM_core0
	bne	.notcoreBGM
	ora	#exal_BGM_core0
	sta	exal_BGM,y

	KBGM	boss_prologue

.notcoreBGM

;����������������������������������������������������������������������������������
;	ENEMY HAS GONE?(ehg)
;����������������������������������������������������������������������������������

	lda	Kenemynumber
	beq	.ehg_exit

	a16
	km_bitcheckmissionflag	enemyrunaway
	a8
	beq		.ehg_exit

	s_jmp_alvarnotZERO	W,y,exal_chartptr,.ehg_exit

	ct_set_chartptr		x,enemyhasgone_

	pl_control	x,off,y

	jmp	.exit

.ehg_exit

;����������������������������������������������������������������������������������
; STAR WOLF DEMO
;����������������������������������������������������������������������������������

	lda	Kenemynumber
	beq	.noSW


	lda	starwolf_demo
	bit	#starwolf_demo_on
	beq	.noSW
	bit	#starwolf_demo_director
	bne	.noSW

	s_make_obj	#nullshape,.noSW
	s_set_strat	y,path_istrat
	s_set_aldata	y,#1,#1
	s_set_alsflag	y,colldisable
	s_set_path	y,starwolfdirector

	lda	starwolf_demo
	ora	#starwolf_demo_director
	sta	starwolf_demo

.noSW

;����������������������������������������������������������������������������������
;	GAME FINISH?
;����������������������������������������������������������������������������������

; If Andorf dead,then Kenemynumber = 0

	lda	andorfDEAD
	cmp	#1
	bne	.andorfnotdead
	stz	Kenemynumber

.andorfnotdead


;******************************************************
; debug mode

	IFNE	debuginfo

;	testjoypad	B,pcont
;	beq		.noboss
;	testjoypad	X,pcont
;	beq		.noboss
;	testjoypad	Y,pcont
;	beq		.noboss
;	testjoypad	tright,pcont
;	beq		.noboss
;
;	lda	#0
;	sta	KEnemyNumber
;	sta	currentEenemyNumber
;
;
;.noboss
	ENDC

;******************************************************

	lda	KEnemyNumber
	rlbne	.notsetseq

;***	sm_jmp_ifbattle		.notsetseq

bosswait00	equ	30

;***	s_jmp_alsflag	x,player2,.p2

;------------------------------------------------------
.p1	test_playerdead	1
	rlbne		.notsetseq

;***	bra		.pp
;***;------------------------------------------------------
;***.p2	test_playerdead	2
;***	rlbne		.notsetseq
;***;------------------------------------------------------
;***.pp
;-------------------------------------------------------

; demo?
	lda	demomode
	bne	.notsetseq

; player is dead?

	lda	al_HP,x
	beq	.notsetseq

; freezing?

	km_jmpgameflag		freeze,.notsetseq

	pl_jmp_iftransform	x,.notsetseq

	sp_trans_lock		x,y

	s_jmp_alvarnotZERO	W,y,exal_chartptr,.notsetseq

	jsl			setclearseq_l

.notsetseq

;������������������������������������������������������������������������������
;	START INTER DEMO?
;������������������������������������������������������������������������������
;******************************************************
; debug mode

;	IFNE	debuginfo
;
;	testjoypad	B,pcont
;	beq		.nonext
;	testjoypad	X,pcont
;	beq		.nonext
;	testjoypad	Y,pcont
;	beq		.nonext
;	testjoypad	up,ptrig
;	beq		.nonext
;
;	lda	demoflag
;	ora	#demoflag_nextmap
;	sta	demoflag
;.nonext
;	ENDC

;******************************************************

;-----------------------------------------------------------------------------
;�����������������Ŀ
;�inc current level�
;�������������������

	lda		demoflag
	bit		#demoflag_nextmap_inclevel
	beq		.noinclevel
	and		#~demoflag_nextmap_inclevel
	sta		demoflag

	s_inc_var	B,currentlevel

.noinclevel

;-----------------------------------------------------------------------------


	toheap	y,x

	pl_jmp_iftransform	x,.notnext,y
	pl_jmp_iftransrising	x,.notnext,y

	lda	KEnemyNumber
	rlbeq	.notnext

	lda	demoflag
	bit	#demoflag_nextmap_off
	bne	.director
	bit	#demoflag_nextmap
	rlbeq	.notnext
	ora	#demoflag_nextmap_off
	sta	demoflag

;�����������Ŀ
;�final boss?�
;�������������

.director	bit	#demoflag_nextmap_gotodirector
	rlbne	.trap

;************

;������������������ͻ
;�make GOTO director�
;������������������ͼ

	PHY

	s_make_obj	#nullshape,.nodirec

	lda	playerctlmode
	cmp	#map_room
	beq	.final

	pl_test_planetmode	marine
	beq			.kaitei
	pl_test_planetmode	space
	bne			.chika
.d_sen	s_set_path	y,gotod_sendirector
	ct_set_chartptr	x,goto_d_sen
	bra		.made
.kaitei	s_set_path	y,gotokaiteidirector
	bra		.made
.chika	s_set_path	y,gotochikadirector
	bra		.made
.final	s_set_path	y,gotofinaldirector
	ct_set_chartptr	x,goto_final

.made	s_copy_pos	y,x
	s_set_strat	y,path_istrat
	s_set_aldata	y,#1,#1
	s_set_alsflag	y,colldisable
	s_or_var	B,demoflag,#demoflag_nextmap_gotodirector
.nodirec	PLY
;************

	jsl	setcoreENTERroty_srou_l	; call from player strat
	jmp	.notnext

.trap	bit	#demoflag_nextmap_trapped
	rlbeq	.notnext


;************
;������������ͻ
;�change strat�
;������������ͼ
	bit	#demoflag_nextmap_trapped_on
	rlbne	.notnext
	ora	#demoflag_nextmap_trapped_on
	sta	demoflag

	lda	playerctlmode
	cmp	#map_room
	rlbeq	.c_final

;************
;���������������������Ŀ
;�set PlanetSwitch flag�
;�����������������������

	lda	playerctlmode
	cmp	#map_room
	beq	.noswitch
	cmp	#map_space
	beq	.noswitch

	lda	PlanetSwitch
	ora	#%100000
	sta	PlanetSwitch

.noswitch
;************
	pl_test_planetmode	marine
	rlbeq			.c_kaitei
	pl_test_planetmode	space
	rlbne			.c_chika
.c_d_sen	ct_set_chartptr	x,nextmap_d_sen,y
	s_set_strat	x,GOTODEMOplayer_istrat
	bra		.notnext
.c_kaitei	ct_set_chartptr	x,nextmap_kaitei,y
	bra		.notnext
.c_final	ct_set_chartptr	x,nextmap_final,y
	s_set_strat	x,GOTODEMOplayer_istrat
	bra		.notnext
.c_chika	ct_set_chartptr	x,nextmap_chika,y
;************

.notnext
;-----------------------------------------------------------------------------

.exit

;-----------------------------------------------------------------------------
;�������������������������������Ŀ
;�Special Bomb window no position�
;���������������������������������

	toheap	y,x

;	a16
;	lda	#chart_specialbomb&WM
;	cmp	exal_chartptr+0,y
;	a8
;	rlbne	.nobom
;
;	s_push_obj	x
;	s_push_obj	y
;
;	sp_jmpnot_ifcockpit	x,.nocock,y
;
;	a16
;	lda	dummyobj
;	sta	exal_circle_obj,y
;	tay
;	a8
;
;	s_add_roffs2pos	B,y,x,x,#0,#-40,#120,1,1,1
;	tyx
;
;.nocock	jsl	circle_objpos_srou_l
;
;	s_pull_obj	y
;	s_pull_obj	x
;
;	a16
;	txa
;	sta	exal_circle_obj,y
;	a8
;
;.nobom

;-----------------------------------------------------------------------------

	jsl	set_target_l

;-----------------------------------------------------------------------------

	s_end_strat



.depthtab	dw	depth_1
	dw	depth_2
	dw	depth_3
	dw	depth_4

;����������������������������������������������������������������������������������
;	Swap player's status
;����������������������������������������������������������������������������������
playerstatus_swap_l

	PUSHXYPB

	a8i16

	BANK7E

	lda	P1_PILOTNo
	sta	player_friend

	sp_swapvar	B,_PILOTNo
	sp_swapvar	B,_maxHP
	sp_swapvar	B,_maxMETER
	sp_swapvar	B,_HP
	sp_swapvar	B,_spweap_type
	sp_swapvar	B,_spweap_lmt
	sp_swapvar	B,_weap_level

; SWAP tame homing flag

	lda	p_tamehom
	PHA
	and	#p_tamehom_p1
	lsr	a
	sta	tpx
	PLA
	and	#p_tamehom_p2
	asl	a
	ora	tpx
	sta	p_tamehom

	PULLXYPB

	rtl

;����������������������������������������������������������������������������������
;	player's status init
;����������������������������������������������������������������������������������
playerstatus_init_l

	PUSHXYPB

;	BANK7E

	a8i16

;;;;;;	s_set_var	B,initial_twin_player,#%00101001

	s_set_var2rnd	attackrnd,#255

	stz	p_tamehom	; tame homing flag

	stz	p1_status

	stz	plrmsg

;-----------------------------------------------------------------------------------
; view change no flag(Back up RAM)

;	stz	playerimportflag

	jsl	Read_backupRAM_playertype_l

;-----------------------------------------------------------------------------------
; set player 1

	a16
	lda	p1_PILOTNo
	and	#7
	tax
	a8

	lda.l	maxHP_tab,x
	sta	P1_maxHP
	sta	P1_HP
	lda.l	maxMETER_tab,x
	sta	P1_maxMETER

	lda.l	.SPWEAP,x
;;;;;	lda	#spweap_heal
	sta	p1_spweap_type

	lda.l	.SPWEAPnum,x
	sta.l	p1_spweap_lmt

;	lda.l	.WEAPlevel,x
;	sta	p1_weap_level

; set player 2

	a16
	lda	p2_PILOTNo
	and	#7
	tax
	a8

	lda.l	maxHP_tab,x
	sta	P2_maxHP
	sta	P2_HP
	lda.l	maxMETER_tab,x
	sta	P2_maxMETER

	lda.l	.SPWEAP,x
	sta	p2_spweap_type

	lda.l	.SPWEAPnum,x
	sta.l	p2_spweap_lmt

;	lda.l	.WEAPlevel,x
;	sta	p2_weap_level

	a8


; set weapon level

	lda	p1_PilotNo
	jsr	.WL
	sta	p1_weap_level

	lda	p2_PilotNo
	jsr	.WL
	sta	p2_weap_level

;-----------------------------------------------------------------------------------
	PULLXYPB

	rtl



	SHORTA
	LONGI
.WL
	PHX
	a16
	and	#7
	tax
	lda.l	.WEAPlevel,x
	a8
	PLX
	sta	tpx


	lda	initial_twin_player
	and	tpx
	bne	.twin

	lda	#exal_weap_level_1	; normal
	rts

.twin	lda	#exal_weap_level_2	; twin
	rts




.WEAPlevel
	db	1<<0
	db	1<<1
	db	1<<2
	db	1<<3
	db	1<<4
	db	1<<5
	db	1<<0
	db	1<<0

.SPWEAP
	pilottab	B,SPWEAP_

.SPWEAPnum
	pilottab	B,SPWEAPnum_



maxHP_tab	pilottab	B,maxHP_

maxMETER_tab	pilottab	B,maxMETER_





testxyz

;	IFNE	debuginfo
;
;	a16
;
;	lda	#0
;	sta	testx
;	sta	testy
;	sta	testz
;	a8
;
;.l	testjoypad	left,pcont
;	beq		.r
;	s_set_var	W,testx,#-32
;
;.r	testjoypad	right,pcont
;	beq		.u
;	s_set_var	W,testx,#32
;
;.u	testjoypad	up,pcont
;	beq		.d
;	s_set_var	W,testz,#32
;
;.d	testjoypad	down,pcont
;	beq		.x
;	s_set_var	W,testz,#-32
;
;.x	testjoypad	x,pcont
;	beq		.b
;	s_set_var	W,testy,#-32
;
;.b	testjoypad	a,pcont
;	beq		.nnn
;	s_set_var	W,testy,#32
;.nnn
;

;	ENDC

	rts

;��������������������������������������Ŀ
;�                                      �
;�Boost of Arwing.                      �
;�use macro "pl_Sboost"(see tmacros.inc)�
;�                                      �
;����������������������������������������

b_offtimer	equ	15


tp_booston_srou_l

	PUSHYP

	a8i16

	s_start_strat

	toheap	y,x

	s_set_alvar	B,y,exal_boostbuf,#0

	jsl	makeboost_srou_l

	lda	exal_control,y
	bit	#exal_control_boost
	bne	.skip1

	kplsound	x,boost	; sound


.skip1
	lda	exal_control,y
	and	#(exal_control_brake)^-1
	ora	#exal_control_boost
	sta	exal_control,y
.skip2
	lda	exal_boost,y
	ora	#exal_boost_boost!exal_boost_pm
	sta	exal_boost,y
.skip0

; set display timer

.settimer	LOCAL

	lda	exal_brake,y
	and	#~exal_brake_timer
	ora	#b_offtimer
	sta	exal_brake,y

	PULLYP

	rtl

;��������������������������������������Ŀ
;�                                      �
;�Brake of Arwing.                      �
;�use macro "pl_Sbrake"(see tmacros.inc)�
;�                                      �
;����������������������������������������
;

;use macro pl_Sbrake	macro	on/off

tp_brakeon_srou_l

	PUSHYP

	a8i16

	s_start_strat


; set display timer
;
;	lda	exal_brake,y
;	and	#~exal_brake_timer
;	ora	#b_offtimer
;	sta	exal_brake,y



	jsl	makebrakeL_srou_l
	rlbcc		.noL

.noL

	jsl	makebrakeR_srou_l
	rlbcc		.noR

.noR

	toheap	y,x

	s_jmp_alvarAND	B,y,exal_control,#exal_control_brake,.skip1

	s_set_alvar	B,y,exal_boostbuf,#0

	kplsound	x,brake	; sound

.skip1
	lda	exal_control,y
	and	#(exal_control_boost)^-1
	bit	#exal_control_brake
	bne	.skip3
	ora	#exal_control_brake
	sta	exal_control,y

.skip3
	lda	exal_boost,y
	ora	#exal_boost_boost!exal_boost_pm
	sta	exal_boost,y
.skip0
	jmp	tp_booston_srou_l.settimer


tp_boostoff_srou_l


	PUSHYP

	a8i16

	toheap	y,x

	lda	exal_boost,y
	and	#exal_boost_pm^-1
	sta	exal_boost,y

.enter	LOCAL

	lda	exal_control,y
	and	#(exal_control_boost!exal_control_brake)^-1
	sta	exal_control,y

.skip
	lda	exal_brake,y
	and	#(exal_brake_Lalive!exal_brake_Ralive)^-1
	sta	exal_brake,y

;BO****
;	s_and_alvar	B,y,exal_control,#~exal_control_overheat
;******



; set display timer

.dectimer

	lda	exal_boost,y
	and	#%111111
	bne	.exit


	lda	exal_brake,y
	bit	#exal_brake_timer
	beq	.exit

	lda	gameframe
	and	#1
	bne	.exit

	lda	exal_brake,y
	dec	a
	sta	exal_brake,y

.exit	PULLYP

	rtl


tp_brakeoff_srou_l

	PUSHYP

	a8i16

	toheap	y,x

	lda	exal_boost,y
	and	#exal_boost_boost^-1
	sta	exal_boost,y

	bra	tp_boostoff_srou_l.enter

;����������������������������������������������������������������������������������
; Rotate player zahyou
;����������������������������������������������������������������������������������

rotate_Proty_l	; player zahyou ni henkan suru.

; in
; idx : player or view pointer
; tpx : objct's worldx
; tpz : objct's worldz

; out
; x2 : worldx
; z2 : worldz

	PUSHXYP

	a8i16

;------------

	pl_ldx_viewblk	x

	a16

	lda	tpx
	sec
	sbc	al_worldx,x
	sta	x1
	sta	x2

	lda	tpz
	sec
	sbc	al_worldz,x
	sta	z1
	sta	z2

	a8

	lda	al_roty+1,x	; view roty
	jsl	rotate_16xz_l

	PULLXYP

	rtl

;����������������������������������������������������������������������������������
;
;����������������������������������������������������������������������������������

attackSE_srou_l

as_shptr	equ	work9	; shape table pointer
as_dst	equ	work8	; distance buffer
as_alptr	equ	work7	;
as_port2	equ	work6	;
as_x	equ	work5	;
as_y	equ	work4	;
as_z	equ	work3	;


;	out	al_pbyte1 : SE port2 No.

	s_start_strat

	PUSHXYP

	ai16

	S_PUSH_OBJ	X

	lda	#07fffh
	sta	as_dst		; distance
	stz	as_alptr	; alien pointer
	stz	as_port2	; SE type

	stz	x1	; shape tab pointer

	ldy	dummyobj
	lda	#0
	sta.w	al_worldx,y
	sta.w	al_worldy,y
	sta.w	al_worldz,y


	ldy	allst


.findloop	a8

	tyx

	ldy	dummyobj
	jsl	xzdiffs_l

	a16

	lda	rangexz
	bmi	.out
	cmp	as_dst
	bcs	.out

;>>>>>-------
; check shape

	lda	al_shape,x
	sta	tpx

	PHX
	ldx	#0
.shloop
	lda.l	ase_tab+0,x
	beq	.ng

	cmp	tpx
	beq	.ok
	inx
	inx
	inx
	bra	.shloop

.ok

	lda.l	ase_tab+2,x
	and	#0ffh
	sta	as_port2

	PLX
	lda	rangexz
	sta	as_dst
	stx	as_alptr

	lda	al_worldx,x
	sta	as_x
	lda	al_worldy,x
	sta	as_y
	lda	al_worldz,x
	sta	as_z

	bra	.out

.ng	PLX

;<<<<<-------

.out	ldy	_next,x
	rlbne	.findloop

;------------

	S_PULL_OBJ	X

;------------
; set sound shape

	lda	as_alptr
	beq	.noSE

	a8
	lda	as_port2
	beq	.noSE
	sta.w	alx_snd2,x
	a16

	lda	as_x
	sta	al_worldx,x
	lda	as_y
	sta	al_worldy,x
	lda	as_z
	sta	al_worldz,x

.noSE	a16

;------------

	PULLXYP

;------------

	rtl

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

;����������������������������������������������������������������������������������
;	PASS Sound
;����������������������������������������������������������������������������������
ps_distlmt	equ	500
ps_distlmty	equ	300

ps_distlmt_z		equ	150
ps_distlmt_x		equ	130
ps_distlmt_in_x	equ	50

ps_obj1x	equ	work9
ps_obj1z	equ	work8
ps_obj2x	equ	work7
ps_obj2z	equ	work6

ps_plrptr	equ	work5
ps_obj1dist	equ	work4
ps_obj2dist	equ	work3
ps_obj1ptr	equ	work2
ps_obj2ptr	equ	work1


pass_sound_srou_l

.start
	PUSHYP

	a8i16

	km_jmpgameflag	freeze,.exit

	toheap	y,x

;-----------------------------------------------------------------------------
	sp_jmpnot_playertype	x,ARWING,.exit,y
	pl_jmp_ifbrake		x,.exit,y
;-----------------------------------------------------------------------------
	pl_lda_PILOTNoFSG	x,y
	cmp	#ep_SP
	bne	.notSP
	pl_jmpnot_ifboost	x,.exit,y
.notSP
;-----------------------------------------------------------------------------

	PHX

	a16

	ldy	#7fffh
	sty	ps_obj1dist	; obj2 dist
	sty	ps_obj2dist	; obj2 dist
	ldy	#0
	sty	ps_obj1ptr	; obj1 pointer
	sty	ps_obj2ptr	; obj2 pointer

	ldy	allst
	stx	ps_plrptr	; store current object.

.findloop	tyx

	a8
	s_jmpnot_alsflag	x,passsound,.next
	a16

	ldy	ps_plrptr

	lda.w	al_worldy,y
	sec
	sbc	al_worldy,x
	bpl	.ypl
	nega
.ypl	cmp	#ps_distlmty
	rlbcs	.rangeout


	jsl	xzdiffs_l


	a16
	lda	rangexz
	cmp	#ps_distlmt
	rlbcs	.rangeout





;************
; player no zahyou ni henkan site kyori wo check.

	lda	al_worldx,x
	sta	tpx
	lda	al_worldz,x
	sta	tpz

	jsl	rotate_Proty_l

	lda	z2
	bmi	.rangeout
	cmp	#ps_distlmt_z
	bpl	.rangeout

	a8
	s_jmp_alsflag	x,whooshobject,.next
	a16
	lda	z2
	clc
	adc	x2

;************
; Chikai obj wo 2-ko mitsukeru.

	cmp	ps_obj2dist
	bcs	.rangeout
	cmp	ps_obj1dist
	bcs	.setobj2

.setobj1	PHA

	lda	ps_obj1ptr
	sta	ps_obj2ptr
	lda	ps_obj1dist
	sta	ps_obj2dist
	lda	ps_obj1x
	sta	ps_obj2x
	lda	ps_obj1z
	sta	ps_obj2z

	PLA

	stx	ps_obj1ptr
	sta	ps_obj1dist
	lda	x2
	sta	ps_obj1x
	lda	z2
	sta	ps_obj1z
	bra	.next

.setobj2

	stx	ps_obj2ptr
	sta	ps_obj2dist
	lda	x2
	sta	ps_obj2x
	lda	z2
	sta	ps_obj2z

	bra	.next


.rangeout	a8

	s_clr_alsflag	x,whooshobject

.next	a16

	ldy	_next,x
	rlbne	.findloop
	ldx	#0

.cantfind
;-----------------------------------------------------------------------------
	PLX
;-----------------------------------------------------------------------------

;*********** found?

	stz	x1	; sound flag

.SEobj1	ldy	ps_obj1ptr
	rlbeq	.noSE

	lda	ps_obj1x
	bpl	.SE1pl
	nega
.SE1pl	cmp	#ps_distlmt_in_x
	bcc	.SEc1

	cmp	#ps_distlmt_x
	bcs	.SEobj2

	lda	ps_obj1x
	bmi	.SEl1

.SEr1	lda	#%0001
	bra	.SE1
.SEl1	lda	#%0100
	bra	.SE1
.SEc1	lda	#%0010
.SE1	sta	x1

;*********** size check

	jsr	.sizeck

;***********

	a8
	s_set_alsflag	y,whooshobject
	a16

.SEobj2	ldy	ps_obj2ptr
	beq	.noSE

	lda	ps_obj2x
	bpl	.SE2pl
	nega
.SE2pl	cmp	#ps_distlmt_in_x
	bcc	.SEc2

	cmp	#ps_distlmt_x
	bcs	.noSE

	lda	ps_obj1x
	bmi	.SEl2

.SEr2	lda	#%0001
	bra	.SE2
.SEl2	lda	#%0100
	bra	.SE2
.SEc2	lda	#%0010
.SE2	ora	x1
	sta	x1

;*********** size check

	jsr	.sizeck

;***********

	a8
	s_set_alsflag	y,whooshobject

.noSE	a8

	lda	x1
	beq	.exit
	bit	#%10
	bne	.c
	bit	#%100
	bne	.l

.r	kplsound	x,ob_throughObst_L,nearR
	bra		.exit
.l	kplsound	x,ob_throughObst_L,nearL
	bra		.exit
.c	kplsound	x,ob_throughObst_L,nearC

.exit

;***********

;-----------------------------------------------------------------------------

	PULLYP
	rtl

;-----------------------------------------------------------------------------

.sizeck	LONGA
	LONGI

;*********** size check
	PHX
	PHY

	tyx
	ldy	al_shape,x
	tyx

	lda.l	sh_size,x
	bit	#0ff00h
	beq	.notc
	lda	#%0010
	sta	x1

.notc	PLY
	PLX
;***********

	rts

;-----------------------------------------------------------------------------

;����������������������������������������������������������������������������������
; demo message
;����������������������������������������������������������������������������������
msg_clear_srou_l

; x1	: pepper msg No
; x2	: pertner msg No
; tpx	: flag

	PHP

	a8i16

	lda	Player_friend
	bmi	.pepper

	lda	plrmsg
	eor	tpx	; flag
	sta	plrmsg
	bit	tpx	; flag
	beq	.pepper

.partner	PHY
	a16
	lda	Player_friend
	and	#07h
	tay
	a8
	lda	x1
.loop	dey
	bmi	.Psta
	inc	a
	bra	.loop

.Psta	PLY
	bra	.sta

.pepper	lda	x2	; pepper
.sta
	phx
	jsl	FriendMessage_l
	plx

	PLP

	rtl
;��������������������������������������������������������������������������������������������������
;	Relative to player
;��������������������������������������������������������������������������������������������������
weap_relative2player1_srou_l

	phy
	php

	s_set_objtobevar	y,playpt1
	bra	weap_relative2player_srou_l.enter

weap_relative2player_srou_l

	phy
	php

	s_set_objtobealvar	y,x,al_ptr

.enter	LOCAL

	sp_jmpnot_playertype	y,ARWING,.RB

.AW	a16
	lda.w	al_vx,y
	clc
	adc	al_vx,x
	sta	al_vx,x
	lda.w	al_vz,y
	clc
	adc	al_vz,x
	sta	al_vz,x
	bra	.exit

.RB	a16
	lda.w	al_mx,y
	clc
	adc	al_vx,x
	sta	al_vx,x
	lda.w	al_mz,y
	clc
	adc	al_vz,x
	sta	al_vz,x

.exit	a8
	plp
	ply

	rtl


;�����������������������������������������������������������������������������
;	Set Demo sequence Director
;�����������������������������������������������������������������������������

makedirector_srou_l

	s_start_strat

	a8i16

	PUSHYP


	lda	demoNo
	cmp	#demo_off
	rlbeq	.demo
	cmp	#demo_wait
	rlbeq	.demo

	cmp	#demo_attack
	bne	.cnt

	toheap	y,x

	lda	exal_demoNo_attack,y
	sta	demoNo

.cnt
	s_make_obj	#nullshape,.demo
	s_set_strat	y,path_istrat

	a16
	lda	#0
	sta.w	al_worldx,y
	sta.w	al_worldy,y
	sta.w	al_worldz,y
	a8
	sta.w	al_rotx,y
	sta.w	al_roty,y
	sta.w	al_rotz,y



	PHY
	PHX

	toheap	y,x

	a16
	lda	demoNo
	and	#0ffh
	cmp	#demodirector_tab_max
	bmi	.ddok
	lda	#0
.ddok	asl	a
	asl	a
	asl	a
	tax

; set chart ptr    **

	lda.l	demodirector_tab+2,x
	sta	exal_chartptr+0,y
	lda.l	demodirector_tab+3,x
	sta	exal_chartptr+1,y
	lda.l	demodirector_tab+5,x
	sta	exal_charttimer_skip,y
	lda	#0
	sta	exal_charttimer,y
	sta	charttimer

; set path pointer **

	lda.l	demodirector_tab+0,x

	PLX
	PLY

	sta.w	al_sword2,y

	a8

	s_set_aldata	y,#1,#1
	s_set_alsflag	y,colldisable


.demo	PULLYP

	rtl



;����������������������������������������������������������������������������
;Special weapon no kazu wo sei gen suru.over sitetara jibaku saseru.
;����������������������������������������������������������������������������

chk_spweappnt_srou_l	;if spweappnt = al_pbyte1(counter) then set Carry

	s_start_strat

	phy

	s_set_objtobealvar	y,x,al_ptr

	wm_getspweappnt	y,twork0	;check sp weap counter

	s_jmp_alvarEQ	B,x,al_pbyte1,twork0,.remove

.setMARK	s_set_alsflag	x,sflag6

	ply
	clc
	rtl

.remove	s_set_alvar	B,x,al_HP,#0	; jibaku!

	ply
	sec
	rtl

;����������������������������������������������������������������������������
; enemy mark wo set
;����������������������������������������������������������������������������
setenemymark_srou_l

;	al_ptr : player's pointer(dummy weapon no toki)

	s_start_strat

	test_screenmode	onescreen
	bne		.nodisp

	s_jmp_alvarEQ	W,x,al_ptr,playpt1,.setp2
	s_jmp_alvarNE	W,x,al_ptr,playpt2,.nodisp

.setp1	setenemymark	x,1
	bra		.nodisp
.setp2	setenemymark	x,2

.nodisp

	rtl

;����������������������������������������������������������������������������
; LIMITTER for PLAYER'S LASER

	SHORTA
	LONGI

chk_laser_lmt_l

;	in	:x player's pointer
;		:y weapon's pointer
;	out	:c=1 then OK!

	PHP

	s_push_obj	y
	ldy		al_sword2,x
	lda		exal_laser_LMT,y

	s_pull_obj	y
	cmp		#laserLMT
	bpl		.fail

.ok	PLP
	sec
	rtl


.fail	PLP
	clc
	rtl

;����������������������������������������������������������������������������
; LIMITTER for PLAYER'S LASER

	SHORTA
	LONGI

dec_laser_lmt_l

	PUSHXYP

	a8i16

	ldy		al_ptr,x	; player pointer

	tyx
	ldy		al_sword2,x

	s_beqdec_alvar	B,y,exal_laser_LMT,.exit,#0

.exit	PULLXYP

	rtl


;����������������������������������������������������������������������������������
;	damage flickker
;����������������������������������������������������������������������������������
playercoltab_srou_l

	s_start_strat

	PUSHYP

	a8i16

	toheap	y,x

	lda	exal_pilotNo,y
	and	#1
	bne	.p2

.p1	s_set_coltab		x,#id_0_c&WM
	bra			.set
.p2	s_set_coltab		x,#id_1_c&WM


.set
	lda	exal_HP,y
	cmp	#3*4+1
	bcs	.clr

	jsl	makedamagespark_srou_l

; lock depth

	s_set_alvar	B,y,exal_depthno,#80h

	lda	gameframe
	bit	#%100
	bne	.exit

	bit	#%1
	bne	.exit

	s_set_alvar	B,y,exal_depthno,#83h

	bra	.exit


.clr	lda	exal_depthno,y
	bit	#80h
	beq	.exit

	lda	#0
	sta	exal_depthno,y


.exit	PULLYP

	rtl


;����������������������������������������������������������������������������������
;	hit effect
;����������������������������������������������������������������������������������

hit_effect_small_l

	s_start_strat

	PUSHYP

	toheap	y,x

	s_jmp_alvarNE	B,y,exal_nohit,#0,hit_effect_l.nohit

	lda		#plnohitfrm_s
	and		#exal_nohit_mask
	sta		exal_nohit,y

	c_addcol_cam	x,dmg,plscrflashfrm_s,on,y

	c_shock_cam	x,#scrshock_s,y

	bra		hit_effect_l.enter

hit_effect_l

	s_start_strat

	PUSHYP

	toheap	y,x

	lda		#plnohitfrm
	and		#exal_nohit_mask
	sta		exal_nohit,y

	c_addcol_cam	x,dmg,plscrflashfrm,on,y

	c_shock_cam	x,#scrshock,y

.enter	LOCAL

	sp_weap_power	x,off,y

	s_set_alvar	B,y,exal_rotzhit,#30
	s_jmp_ANDframe	#1,.nohit
	s_neg_alvar	B,y,exal_rotzhit

.nohit	LOCAL
	PULLYP
	rtl


;����������������������������������������������������������������������������������
; SHIELD REFLECT SE
;����������������������������������������������������������������������������������

reflectSE_srou_l

	PUSHYP

	s_start_strat

	toheap		y,x

	lda	exal_reflectSE,y
	bne	.noSE

	kplsound	x,shieldreflect

	s_set_alvar2rnd	y,exal_reflectSE,#7

.noSE

	PULLYP

	rtl

;����������������������������������������������������������������������������������


wingman_AW_shape

	dw	a_wing
	dw	a_wing
	dw	c_wing
	dw	c_wing
	dw	b_wing
	dw	b_wing

wingman_RB_shape

	dw	a_wing_0
	dw	a_wing_0
	dw	c_wing_0
	dw	c_wing_0
	dw	b_wing_0
	dw	b_wing_0

;����������������������������������������������������������������������������������
;	end of file
;����������������������������������������������������������������������������������



	strats_end

	end


