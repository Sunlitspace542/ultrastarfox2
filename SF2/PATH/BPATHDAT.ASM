;############################  StarFox II #################################
;#                           ###############                              #
;#  Copyright Argonaut Software Limited, 1993.                            #
;#  All Rights Reserved.                                                  #
;##########################################################################
;#  Filename:     BPATHDAT.ASM                                            #
;##########################################################################
;#  Description:  Boss programs (written in the PATH language)            #
;##########################################################################
;#  Date:         29/8/94                                                 #
;##########################################################################
;#  Author:       Dylan Cuthbert                                          #
;##########################################################################
;#  Modification list:                                                    #
;#    BOSS DODORA                                                         #
;#    BOSS PIERROT                                                        #
;#    BOSS CRUSHER                                                        #
;#    BOSS DRAGON                                                         #
;#    BOSS TANK                                                           #
;#    BOSS RUNNER                                                         #
;#    BOSS ANDORF                                                         #
;#                                                                        #
;##########################################################################
;***** EXTERN *****
	incpub	bpathdat

	IFEQ	PAL

; ---------------- NTSC VALUES ---------------

; --- time delay until everything begins

credits_blanking_time_easy	equ	0
credits_blanking_time_normal	equ	80
credits_blanking_time_hard	equ	0

; --- time delay until 3d begins (must be bigger than blanking_time)

credits_3d_start_delay_easy	equ	40
credits_3d_start_delay_normal equ	90
credits_3d_start_delay_hard	equ	10
	ELSEIF

; ------------ PAL VALUES --------------

credits_blanking_time_easy	equ	0
credits_blanking_time_normal	equ	80
credits_blanking_time_hard	equ	0

credits_3d_start_delay_easy	equ	40
credits_3d_start_delay_normal equ	90
credits_3d_start_delay_hard	equ	10
	ENDC

boss_crusher_deflector_hp	equ	4
boss_crusher_cannon_hp	equ	4
boss_crusher_body_hp		equ	6
boss_crusher_meter_hp	equ	40

boss_crusher_deflector_ap	equ	4
boss_crusher_cannon_ap	equ	2
boss_crusher_body_ap		equ	4

boss_crusher_cplasma_ap	equ	4

boss_dragon_hp		equ	24
boss_dragon_ap		equ	4

boss_crusher_rot_speed	equ	deg5

boss_pierrot_hands_hp	equ	24
boss_pierrot_head_hp		equ	64

boss_pierrot_max_z		equ	800
boss_pierrot_min_z		equ	700

boss_dodora_hp		equ	24
boss_dodora_change_hp	equ	16

boss_dodora_max_z		equ	600
boss_dodora_stop_z		equ	500
boss_dodora_min_z		equ	400

boss_runner_hp		equ	40	;eguchi change 32->120
boss_runner_ap		equ	4
boss_runner_wheel_ap		equ	4

b_tank_launcher_hp		equ	30	;eguchi change 10->30
b_tank_launcher_ap		equ	4
b_tank_ap			equ	4


boss_andorf_mask_hp_norm	equ	16
boss_andorf_mask_hp_hard	equ	10
boss_andorf_cowl_hp_norm	equ	20
boss_andorf_cowl_hp_hard	equ	14
boss_andorf_hand_hp		equ	16
boss_andorf_eye_hp		equ	20
boss_andorf_hand_ap		equ	1
boss_andorf_ball_ap		equ	2
boss_andorf_breath_ap	equ	2
boss_andorf_lasereye_ap	equ	8
boss_andorf_head_ap		equ	4
eye_time			equ	50
boss_andorf_eye_ap		equ	4
boss_andorf_eyecube_hp	equ	25

boss_andorf_core_hp		equ	22
boss_andorf_toge_ap		equ	1

boss_tako_hp			equ	100
boss_tako_ap			equ	4

clippos_boundmax		equ	3092-512

;-------------------------------------------
; Octopus BOSS

	P_BOSSMODELIST	Octopus

;----------- FLAGS -------------
	P_BOSSFLAGLIST
	P_BOSSFLAG	playerundersea
	P_BOSSFLAG	liftlegs
	P_BOSSFLAG	lowerlegs
	P_BOSSFLAG	wibble
	P_BOSSFLAG	hit
	P_BOSSFLAG	abovesea
	P_BOSSFLAG	noclipcheck

tako_child_leg1	equ	1
tako_child_leg2	equ	5
tako_child_leg3	equ	10
tako_child_buildup	equ	30

tako_max_children	equ	20
;-------------------------------
	START_PATH	BOSS_tako


	P_SHADOW	OFF
;	P_RANGECHECK	OFF
	P_RADAROBJ	ra_enemy
	P_TRIGGER	radar_change,8
	P_ENEMYDMGSE	en_cry_3

	P_SET		skidy,hp

	P_IMPORT	pword1,planetswitch
	P_IFSWITCH	skidy,pword1,.remit
	P_IGOTO		.norem
.remit	P_REMOVE
.norem

	P_SET		shape,tako_0
	P_SET		ap,boss_tako_ap

	P_SET		hp,boss_tako_hp
;;;;eguchi write
	P_SET		pbyte1,25
	P_EXPORT	bosshp,pbyte1
	P_EXPORT	bossmaxhp,pbyte1
;;;;eguchi end
;eguchi coment	P_EXPORT	bosshp,hp
;eguchi coment	P_EXPORT	bossmaxhp,hp

	P_CLRBOSSFLAGS

	P_SETBOSSNAME	name_tako


	P_SPAWN		-5,-20,0,deg22,deg90-deg22,0,nullshape,tako_dummypiece,10,10,tako_child_leg1
	P_SPAWN		5,-20,0,deg22,-deg90+deg22,0,nullshape,tako_dummypiece,10,10,tako_child_leg2
	P_SPAWN		0,-20,5,deg22,deg180,0,nullshape,tako_dummypiece,10,10,tako_child_leg3

	P_TRIGGER	.belowsea,BelowSea
	P_TRIGGER	.abovesea,AboveSea
	P_TRIGGER	.hit,WhenHit
	P_TRIGGER	.always,ALWAYS
;;;	P_TRIGGER	.dead,WhenDead

	P_INVISIBLE	ON

	P_SETBOSSFLAG	wibble,ON

	P_WAIT		1
	P_GOSUB		.setclipping

.wait	P_WAIT		1
	P_IFBOSSFLAG	hit,OFF,.wait

	P_SETBOSSFLAG	wibble,hit,OFF
	P_INVINCIBLE	ON

	P_DO		10
	  P_FACEPLAYER	Y
	P_NEXT

	P_SETBOSSFLAG	lowerlegs,ON

	P_SET		vy,-20
	P_WAIT		5
	P_SET		vy,-60

	P_TRIGGER	.awa_spawn,2
.untilsurface
	P_WAIT		1
	P_IFNOTBETWEEN	-1100,worldy,-940,.untilsurface

	P_SET		vy,0
	P_TRIGGER	.awa_spawn,OFF

	P_SETBOSSFLAG	lowerlegs,OFF
	P_SETBOSSFLAG	liftlegs,abovesea,ON
	P_WAIT		10
	P_SETBOSSFLAG	liftlegs,wibble,OFF

	P_IFBOSSFLAG	playerundersea,ON,.madainvin
	P_INVINCIBLE	OFF
.madainvin

	P_SET		oy,worldy
	
	P_TRIGGER	.headwibble,ALWAYS

; --- Main loop with King Tako sitting on the sea

.loop

	P_DO	2

; --- Make sure all the legs are flat

	P_GOSUB		.legsdown

; --- rotate to the left

	P_DO		8
	P_ADD		roty,-5

	P_DISTMORE	2000,.nodo1
	P_CIRCLEPLAYER	2
	P_MOVEINPLAYER	10
.nodo1
	P_NEXT

; --- Raise one leg (arm)

	P_DO		10
	P_BECOMECHILD	tako_child_leg1
	  P_CHASE	childrotx,-deg45
	  P_CHASE	childrotx,-deg45
	P_UNBECOME
	P_DISTMORE	2000,.nodo2
	P_CIRCLEPLAYER	1
	P_MOVEINPLAYER	5
.nodo2
	P_NEXT

; --- Flag the leg to make it fire a plasma

	P_FLAGCHILD	tako_child_leg1
	P_FLAGCHILD	tako_child_leg1+3
	P_WAIT	4
;	P_FLAGCHILD	tako_child_leg1+3
;	P_WAIT	2
;	P_FLAGCHILD	tako_child_leg1+3
;	P_WAIT	2


; --- set the legs flat again

	P_GOSUB		.legsdown

; --- rotate to the right

	P_DO		8
	P_ADD		roty,5
	P_DISTMORE	2000,.nodo3
	P_CIRCLEPLAYER	-1
.nodo3
	P_NEXT

; --- Raise one leg (arm)

	P_DO		10
	P_BECOMECHILD	tako_child_leg2
	  P_CHASE	childrotx,-deg45
	  P_CHASE	childrotx,-deg45
	P_UNBECOME
	P_DISTMORE	2000,.nodo4
	P_CIRCLEPLAYER	-1
.nodo4
	P_NEXT

; --- Flag that leg also to make it fire

	P_FLAGCHILD	tako_child_leg2
	P_FLAGCHILD	tako_child_leg2+3
	P_WAIT	4
;	P_FLAGCHILD	tako_child_leg2+3
;	P_WAIT	2
;	P_FLAGCHILD	tako_child_leg2+3
;	P_WAIT	2

	P_NEXT

; --- set the legs flat again

	P_GOSUB		.legsdown
	P_WAIT		5

	P_DO		10
	  P_ADD		roty,deg11
	  P_ADD		oy,-16
	  P_ADD		worldx,5
	  P_ADD		rotx,1
	P_NEXT

	P_DO		20
	  P_ADD		roty,deg11
	  P_ADD		oy,40
	  P_ADD		rotx,-1
	P_DISTMORE	2000,.nodo5
	  P_MOVEINPLAYER 5
	  P_CIRCLEPLAYER 2
.nodo5
	P_NEXT

	P_ALWAYSGENVECS	ON
	P_DO		2

	P_SETVEL	100
	  P_DO		40
	    P_CHASE	rotx,deg45
	  P_NEXT
	  P_SETVEL	0
	  P_DO	20
	    P_CHASE	rotx,0
	  P_NEXT
	P_NEXT

	P_SETVEL	100
	P_DO		80
	  P_CHASE	rotx,deg45
	P_NEXT
	P_ALWAYSGENVECS	OFF
	P_SETVEL	0

.waituntilabove
	  P_ADD		oy,-20
	  P_ADD		roty,deg11
	  P_CHASE	rotx,0
	  P_WAIT	1
	P_IFNOTBETWEEN	-1100,worldy,-940,.waituntilabove

	P_GOTO		.loop

	P_END

; --- set all legs flat

.legsdown
	P_DO		15
	P_BECOMECHILD	tako_child_leg1
	  P_CHASE	childrotx,0
	P_UNBECOME
	P_BECOMECHILD	tako_child_leg2
	  P_CHASE	childrotx,0
	P_UNBECOME
	P_NEXT

	P_DO		10
	P_FACEPLAYER	Y
	P_NEXT


	P_RETURN

; --- When the tako dies, set off the explosions

.dead
;	P_GDEC		B,KEnemyNumber

;;;;eguchi write
;	P_SET		hp,1
;	P_COLLISIONS	OFF
	P_SCREENFLASH
;	P_FORCE		.tako_exp
;	P_RETURN
.tako_exp
;	P_TRIGGER	.dead,OFF
	P_CLRDEMOSHAPE
	P_TRIGGER	crash_flash,4

	P_WAIT		30
; drop switch
	P_EXPORT	gbyte1,skidy
	P_QSPAWN	on_d,e_sw_base_sw_drop_sea,100,4
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME

	P_GOSUB		boss_exp_screen_flash
	P_SCORE		1000
	P_CIRCLEWINDOW	1,big

	P_SOUNDEFTPOS	en_death_3
	P_SOUNDEFTPOS	bs_bossexplode2

	P_EXPLODE
;;;;eguchi end
	P_RETURN

; --- wobble the head up and down

.headwibble
	P_SET	worldy,oy
	P_INDEX	pbyte1,sintab,pbyte2
	P_ADD	pbyte2,17
	P_DIV2	pbyte1
	P_DIV2	pbyte1
	P_DIV2	pbyte1
	P_ADD	worldy,pbyte1
	P_RETURN

; --- set all children to clip ---

.setclipping
	P_CLIPPING	ON
	P_SET		pbyte1,0
	P_DO		tako_max_children
	  P_BECOMECHILD	pbyte1
	    P_CLIPPING	ON
 	  P_UNBECOME
	  P_INC		pbyte1
	P_INEXT
	P_RETURN

.awa_spawn
	P_QSPAWN	bubble,tako_awa,10,10
	P_RETURN

; --- set the marker for the track arrow

.always
	P_SETMARKER	1
	P_GOSUB		clippos
	P_IFBOSSFLAG	noclipcheck,ON,.con342
	P_IMPORT	tx,bclipflag
	P_IFZERO	tx,.con342
	P_TRIGGER	.turnaround,ALWAYS,deg90/deg11
	P_TRIGGER	.checkon,Timer,50
	P_SETBOSSFLAG	noclipcheck,ON
.con342	P_RETURN
.turnaround
	P_ADD		roty,deg11
	P_RETURN
.checkon
	P_SETBOSSFLAG	noclipcheck,OFF
	P_RETURN


; --- hit routine

.hit
;;;;eguchi write
	P_PUSH		pbyte1
	P_SET		pbyte1,hp
	P_ADD		pbyte1,-49
	P_DIV2		pbyte1
	P_EXPORT	bosshp,pbyte1
	P_SET		pbyte1,51
	P_IFSMALLER	hp,pbyte1,.to_dead
	P_PULL		pbyte1
;;;;eguchi end
;eguchi coment	P_EXPORT	bosshp,hp
	P_SETBOSSFLAG	hit,ON
	P_RETURN
.to_dead
	P_PULL		pbyte1
	P_COLLISIONS	OFF
	P_INVINCIBLE	ON
	P_FORCE		.dead
	P_RETURN

; --- set the flags for when the player goes above the sea

.abovesea
	P_SETBOSSFLAG	playerundersea,OFF
	P_IFBOSSFLAG	abovesea,OFF,.nocols1
	P_INVINCIBLE	OFF
.nocols1
	P_RETURN

; --- set the flags for when the player goes below the sea

.belowsea
	P_SETBOSSFLAG	playerundersea,ON
	
	IFEQ	0

	P_INVISIBLE	OFF
	P_IFBOSSFLAG	abovesea,OFF,.nocols2
	P_INVINCIBLE	OFF
.nocols2


	P_PUSH		pbyte1
	P_SET		pbyte1,0
	P_DO		tako_max_children
	  P_BECOMECHILD	pbyte1
	    P_INVISIBLE	OFF
	    P_COLLISIONS OFF
 	  P_UNBECOME
	  P_INC		pbyte1
	P_INEXT
	P_PULL		pbyte1

	ENDC

	P_RETURN


;--------------------------------------------------------------
clippos
	P_GSET		B,bclipflag,0

	P_GOSUB		.xchk2
	P_GOSUB		.zchk2

	P_PUSH		ox
	P_PUSH		oz
	P_PUSH		slopenum
.andagain
	P_ZERO		slopenum
	P_SET		ox,32767

	P_IFNOTBETWEEN	-1024,worldz,1024,.noxchk1
	P_GOSUB		.xchk1
.noxchk1	P_IFNOTBETWEEN	-1024,worldx,1024,.nozchk1
	P_GOSUB		.zchk1
.nozchk1
	P_IFZERO	slopenum,.ret2
	P_GINC		B,bclipflag
	P_IFSAME	slopenum,1,.1
	P_IFSAME	slopenum,2,.2
	P_IFSAME	slopenum,3,.3
	P_IFSAME	slopenum,4,.4
.ret2
	P_PULL		slopenum
	P_PULL		oz
	P_PULL		ox
	P_RETURN
.1
	P_SET		worldx,-1025
	P_IGOTO		.andagain
.2
	P_SET		worldx,1025
	P_IGOTO		.andagain
.3
	P_SET		worldz,-1025
	P_IGOTO		.andagain
.4
	P_SET		worldz,1025
	P_IGOTO		.andagain

.xchk1
	P_IFBETWEEN	-1024,worldx,0,.xchk1_1
	P_IFBETWEEN	0,worldx,1024,.xchk1_2
	P_RETURN
.xchk1_1
;;	P_SET		worldx,-1024
	P_SET		oz,worldx
	P_ADD		oz,1024
	P_IFLARGER	oz,ox,.ret
	P_SET		slopenum,1
	P_SET		ox,oz
.ret	P_RETURN
.xchk1_2
;;	P_SET		worldx,1024
	P_SET		oz,worldx
	P_NEG		oz
	P_ADD		oz,1024
	P_IFLARGER	oz,ox,.ret
	P_SET		slopenum,2
	P_SET		ox,oz
	P_RETURN

.xchk2
	P_IFBETWEEN	-clippos_boundmax-2048,worldx,-clippos_boundmax,.xchk2_1
	P_IFBETWEEN	clippos_boundmax,worldx,clippos_boundmax+2048,.xchk2_2
	P_RETURN
.xchk2_1
	P_SET		worldx,-clippos_boundmax
	P_GINC		B,bclipflag
	P_RETURN
.xchk2_2
	P_SET		worldx,clippos_boundmax
	P_GINC		B,bclipflag
	P_RETURN

.zchk1
	P_IFBETWEEN	-1024,worldz,0,.zchk1_1
	P_IFBETWEEN	0,worldz,1024,.zchk1_2
	P_RETURN
.zchk1_1
;;	P_SET		worldz,-1024
	P_SET		oz,worldz
	P_ADD		oz,1024
	P_IFLARGER	oz,ox,.ret
	P_SET		slopenum,3
	P_SET		ox,oz
	P_RETURN
.zchk1_2
	P_SET		oz,worldz
	P_NEG		oz
	P_ADD		oz,1024
	P_IFLARGER	oz,ox,.ret
	P_SET		slopenum,4
	P_SET		ox,oz
;;	P_SET		worldz,1024
	P_RETURN

.zchk2
	P_IFBETWEEN	-clippos_boundmax-2048,worldz,-clippos_boundmax,.zchk2_1
	P_IFBETWEEN	clippos_boundmax,worldz,clippos_boundmax+2048,.zchk2_2
	P_RETURN
.zchk2_1
	P_SET		worldz,-clippos_boundmax
	P_GINC		B,bclipflag
	P_RETURN
.zchk2_2
	P_SET		worldz,clippos_boundmax
	P_GINC		B,bclipflag
	P_RETURN

	IFEQ	1

	P_IFBETWEEN	-1024,worldz,1024,.chk1
.nxtchk	P_IFBETWEEN	-1024,worldx,1024,.chk2
.nxtchk2	P_RETURN

.chk1	P_GOSUB		.chkit1
	P_IGOTO		.nxtchk
.chkit1
	P_IFBETWEEN	-clippos_boundmax-2048,worldx,-clippos_boundmax,.clp1
	P_IFBETWEEN	-1024,worldx,0,.clp2
	P_IFBETWEEN	0,worldx,1024,.clp3
	P_IFBETWEEN	clippos_boundmax,worldx,clippos_boundmax+2048,.clp4
	P_RETURN
.clp1	P_SET		worldx,-clippos_boundmax
	P_RETURN
.clp2	P_SET		worldx,-1024
	P_RETURN
.clp3	P_SET		worldx,1024
	P_RETURN
.clp4	P_SET		worldx,clippos_boundmax
	P_RETURN

.chk2	P_GOSUB		.chkit2
	P_IGOTO		.nxtchk2
.chkit2
	P_IFBETWEEN	-4096,worldz,-3092,.clp5
	P_IFBETWEEN	-1024,worldz,0,.clp6
	P_IFBETWEEN	0,worldz,1024,.clp7
	P_IFBETWEEN	3092,worldz,4096,.clp8
	P_RETURN
.clp5	P_SET		worldz,-3092
	P_RETURN
.clp6	P_SET		worldz,-1024
	P_RETURN
.clp7	P_SET		worldz,1024
	P_RETURN
.clp8	P_SET		worldz,3092
	P_RETURN
	ENDC
	
;--------------------------------------------------------------
	START_PATH	tako_awa
	P_COLLISIONS	OFF
	P_SHADOW	OFF
;	P_RANGECHECK	OFF
	P_SPRITE	0,32
	P_ADD		worldy,150<<tako_scale

	P_DO		8
	P_ADD		tx,-3
	P_NEXT
	P_REMOVE

;--------------------------------------------------------------
	START_PATH	tako_dummypiece
	P_SET		shape,nullshape
	P_INVISIBLE	ON
	P_COLLISIONS	OFF
	P_SHADOW	OFF

	P_SPAWN		0,0,0,0,0,0,tako_1,tako_legpiece,10,10,4
	p_START65816
	  ldy	becomelastobj&WM
	  stx	al_immuneptr,y
	p_END65816

; -- set the child's id
	P_EXPORT	gbyte1,sbyte1
	P_BECOME
	  P_IMPORT	sbyte1,gbyte1
	  P_INC		sbyte1
	P_UNBECOME

.lp
	P_IFFLAG	.goforplayer

	P_IFBOSSFLAG	liftlegs,OFF,.nolift
	P_CHASE		childrotx,deg22
.nolift
	P_IFBOSSFLAG	lowerlegs,OFF,.nolower
	P_CHASE		childrotx,deg90-deg22
	P_CHASE		childrotx,deg90-deg22
.nolower
	P_IFBOSSFLAG	wibble,OFF,.nowibble
	P_SET		childrotx,deg22
	P_INDEX		pbyte1,sintab,pbyte2
	P_ADD		pbyte2,25
	P_DIV2		pbyte1
	P_DIV2		pbyte1
	P_DIV2		pbyte1
	P_DIV2		pbyte1
	P_ADD		childrotx,pbyte1
.nowibble
	P_GOTO		.lp

	P_END

.goforplayer
	P_SET	ox,childx
	P_SET	oy,childy
	P_SET	oz,childz

	P_DO	50
	P_CHASE	childz,500
	P_NEXT

	P_DO	50
	P_CHASE	childx,ox
	P_CHASE	childy,oy
	P_CHASE	childz,oz
	P_NEXT
	P_GOTO	.lp

;--------------------------------------------------------------
	START_PATH	tako_legpiece
	P_SHADOW	OFF
;	P_RANGECHECK	OFF
;	P_RADAROBJ	ra_enemy
	P_COLLISIONS	OFF
	P_RELATIVE	OFF

	P_INVISIBLE	ON

	P_SPAWN		0,0,0,0,0,0,tako_1,tako_legpiece2,10,10,4
	p_START65816
	  ldy	becomelastobj&WM
	  stx	al_immuneptr,y
	p_END65816

; -- set the child's id
	P_EXPORT	gbyte1,sbyte1
	P_BECOME
	  P_IMPORT	sbyte1,gbyte1
	  P_INC		sbyte1
	P_UNBECOME

;	P_RTRIGGER	tako_splashcheck,8

.lp
	P_REBOUNDLASER
	P_SWAPVAR	immuneptr,ptr
	P_CHAINPOS	10
	P_ADD		rotx,deg180
	P_SWAPVAR	immuneptr,ptr
	P_GOTO		.lp

	P_END
;--------------------------------------------------------------
	START_PATH	tako_legpiece2
	P_SHADOW	OFF
;	P_RANGECHECK	OFF
;	P_RADAROBJ	ra_enemy
	P_COLLISIONS	OFF
	P_RELATIVE	OFF
	P_INVISIBLE	ON

	P_SPAWN		0,0,40<<tako_scale,0,0,0,tako_2,tako_tail,10,10,5

	p_START65816
	  ldy	becomelastobj&WM
	  stx	al_immuneptr,y
	p_END65816

; -- set the child's id
	P_EXPORT	gbyte1,sbyte1
	P_BECOME
	  P_IMPORT	sbyte1,gbyte1
	  P_INC		sbyte1
	P_UNBECOME

	P_RTRIGGER	tako_splashcheck,8

.lp
	P_REBOUNDLASER
	P_SWAPVAR	immuneptr,ptr
	P_CHAINPOS	20
	P_ADD		rotx,deg180
	P_SWAPVAR	immuneptr,ptr
	P_GOTO		.lp

	P_END

;--------------------------------------------------------------
	START_PATH	tako_tail
	P_SHADOW	OFF
;	P_RANGECHECK	OFF
;	P_RADAROBJ	ra_enemy
	P_RELATIVE	OFF

	P_INVISIBLE	ON
	

	P_RTRIGGER	.dead,WhenDEAD
	P_RTRIGGER	tako_splashcheck,8

.lp
	P_REBOUNDLASER
	P_SWAPVAR	immuneptr,ptr
	P_CHAINPOS	20
	P_ADD		rotx,deg180
	P_SWAPVAR	immuneptr,ptr

	P_IFFLAG	.firerings
	P_GOTO		.lp
.firerings
	P_SPAWN		0,0,0,0,0,0,missile,t_buildup,10,10,tako_child_buildup

	P_GOTO		.lp
	

.dead
	P_SET		hp,1
	P_COLLISIONS	OFF
	P_FORCE		.removeit
	P_RETURN
.removeit
	P_REMOVE


;-------------------------------------
	START_PATH	t_buildup

;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_SPRITE	0,-30
	P_SET		shape,bossball

	P_DO		10
	P_ADD		tx,2
	P_NEXT

	P_WEAPON	eplasma1
	P_FACEPLAYER	IMMEDIATE
	P_FIRE
	P_BECOME
	  P_SETVEL	30
	P_UNBECOME
	P_WAIT		1
	P_REMOVE



;--------------------------------------------------------------
tako_splashcheck
	P_IFNOTBETWEEN	-1020,worldy,-1000,.nosplash

	P_IFBOSSFLAG	playerundersea,ON,.nooto
	P_RANDOMGOTO	.oneoto
	P_SOUNDEFTDISTPOS	en_inmarine
	P_IGOTO		.otheroto
.oneoto	P_SOUNDEFTDISTPOS	en_outmarine

.otheroto
.nooto
	P_QSPAWN	splash,tako_splash,10,10

.nosplash
	P_RETURN

	START_PATH	tako_splash
;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_SPRITE	0,24
	P_SETCOLANIM	0

	P_DO		8
	P_ADDCOLANIM	1,8
	P_NEXT

	P_REMOVE

	

;--------------------------------------------------------------
;--------------------------------------------------------------


;-------------------------------------------
; the credits for the game.

cred_title	equ	1
cred_name1	equ	2

	P_BOSSMODELIST	Credits

;----------- FLAGS -------------
	P_BOSSFLAGLIST
	P_BOSSFLAG	destroytitle


	START_PATH	Credits

	IFEQ	1

	P_COLLISIONS	OFF
	P_SET		rotx,0
	P_SET		roty,0
	P_SET		rotz,0
;	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_ACTIVE	ON
	P_CLRBOSSFLAGS

	P_WAIT		40
	P_BEGINDEMO
	P_RTRIGGER	.always,ALWAYS

	P_RADAROBJ	ra_enemy

.nxtline
	P_INDEX		pbyte1,creditsmsg,mx
	P_INC		mx
	P_IFZERO	pbyte1,.theend
	P_SET		worldx,-1000

	P_IFSAME	pbyte1,cred_name1,.namepart
.titlepart
	P_WAIT		10
	P_SET		worldy,-300
	P_SETBOSSFLAG	destroytitle,ON
	P_WAIT		1
	P_SETBOSSFLAG	destroytitle,OFF
	P_WAIT		10
.con

;-------- this is the loop for the title part of the credits ---------
.nextchar2
	P_INDEX		pbyte1,creditsmsg,mx
	P_INC		mx
	P_IFZERO	pbyte1,.nomoremoji
	P_GOSUB		getfontshape
	P_EXPORT	gword1,pword1

	P_QSPAWN	chr_a,font_flyin4,10,10
	P_BECOME
	  P_IMPORT	shape,gword1
	  P_ACTIVE	ON
	P_UNBECOME

	P_WAIT		2
	P_ADD		worldx,120

	P_GOTO		.nextchar2

;-------- this is the loop for the name part of the credits ---------
.namepart
	P_SET		worldy,0
	P_QSPAWN	a_wing_big,font_hand,10,10
	P_BECOME
	  P_ACTIVE	ON
	P_UNBECOME


.nextchar
	P_INDEX		pbyte1,creditsmsg,mx
	P_INC		mx
	P_IFZERO	pbyte1,.nomoremoji
	P_GOSUB		getfontshape
	P_EXPORT	gword1,pword1

	P_QSPAWN	chr_a,font_flyin3,10,10
	P_BECOME
	  P_IMPORT	shape,gword1
	  P_SET		coltab,whitefont_c&WM
	  P_ACTIVE	ON
	P_UNBECOME

	P_WAIT		2
	P_ADD		worldx,120

	P_GOTO		.nextchar

.always
	P_PUSH	worldx
	P_SET	worldx,0
	P_SETCAMERA
	P_PULL	worldx
	P_RETURN

.nomoremoji
	P_WAIT		50
	P_GOTO		.nxtline
.theend
	P_END

;------------------------------------------------
	START_PATH	font_hand
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
;	P_RELTOPLAYER	ON
	P_ACTIVE	ON
	P_INVISIBLE	ON
	P_RTRIGGER	.anim,ALWAYS
	P_SETANIM	0

	P_WAIT		50
	P_INVISIBLE	OFF
;	P_ADD		worldy,150
	P_SET		rotz,deg90
	P_ADD		worldx,-100

	P_DO		18
	P_ADD		worldz,60
	P_NEXT

	P_DO		90
	P_CHASE		roty,-deg90
	P_CHASE		roty,-deg90
	P_ADD		worldx,40
	P_NEXT

	P_REMOVE

.anim	P_ADDANIM	1,15
	P_RETURN


;------------------------------------------------
	START_PATH	font_flyin4
	P_COLLISIONS	OFF
;	P_RELTOPLAYER	ON
	P_ACTIVE	ON
;	P_RANGECHECK	OFF
	P_SHADOW	OFF
	P_SET		depthoffset,1
.loop
	P_DO		20
	P_ADD		worldz,60
	P_NEXT

.loop2
	P_IFBOSSFLAG	destroytitle,ON,.destroy
	P_GOTO		.loop2
.destroy
	P_SET		tx,rotx
	P_SET		ty,roty
	P_SETRANDOM	rotx
	P_SETRANDOM	roty

	P_SETVEL	40

	P_SET		rotx,tx
	P_SET		roty,ty

	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,-16

	P_DO		30
	  P_ADD		rotz,pbyte1
	P_NEXT

	P_REMOVE


;------------------------------------------------
	START_PATH	font_flyin3
	P_COLLISIONS	OFF
;	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_ACTIVE	ON
	P_SET		depthoffset,1
.loop
	P_DO		20
	P_ADD		worldz,60
;	P_ADD		rotx,deg11
	P_NEXT

	P_WAIT		50

	P_PUSH		rotx
	P_PUSH		roty
	P_SETRANDOM	rotx
	P_SETRANDOM	roty

	P_SETVEL	40

	P_PULL		rotx
	P_PULL		roty

	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,-16

	P_DO		30
	  P_ADD		rotz,pbyte1
	P_NEXT

	P_REMOVE


;------------------------------------------------
c_title	MACRO	[string]
	db	cred_title
	db	"{string}",0
	ENDM

c_name1	MACRO	[string]
	db	cred_name1
	db	"{string}",0
	ENDM

c_end	MACRO
	db	0
	ENDM
;--------------------------------------------------

creditsmsg
	c_name1	<    STARFOX 2>
	c_title	<PRODUCER>
	c_name1	<SHIGERU MIYAMOTO>
	c_title	<DIRECTOR>
	c_name1	<KATSUYA EGUCHI>
	c_title	<ASSISTANT DIRECTOR>
	c_name1	<YOICHI YAMADA>
	c_title	<PROGRAMMED BY>
	c_name1	<DYLAN CUTHBERT>
	c_name1	<TAKUMI KAWAGOE>
	c_name1	<YASUHIRO KAWAGUCHI>
	c_title	<GRAPHIC DESIGN>
	c_name1	<MASANAO ARIMOTO>
	c_title	<3D SHAPE DESIGN>
	c_name1	<TSUYOSHI WATANABE>
	c_title	<SOUND>
	c_name1	<YOJI INAGAKI>
	c_name1	<KOZUE ISHIKAWA>
	c_name1	<YUMIKO KANKI>
	c_title	<3D SYSTEM PROGRAM>
	c_name1	<PETE WARNES>
	c_name1	<CARL GRAHAM>
	c_title	<EXECUTIVE PRODUCER>
	c_name1	<HIROSHI YAMAUCHI>
	c_title	< >
	c_name1	<     THE END>
	c_end

	ENDC

	IFEQ	CESBOOT
;-------------------------------------------
; the Nintendo presents introduction

	P_BOSSMODELIST	IntroText


;--------- FLAGS ----------
	P_BOSSFLAGLIST
	P_BOSSFLAG	burstout

	START_PATH	NintendoPresents

	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_CLRBOSSFLAGS

	P_SET	pbyte1,0
	P_DO	9
	  P_INDEX	ox,i_tabsh,pbyte1
	  P_INDEX	pbyte2,i_tabx,pbyte1
	  P_INC		pbyte1

	  P_EXPORT	gword1,ox

	  P_QSPAWN	nullshape,font_flyin,10,19
	  P_BECOME
	    P_IMPORT	shape,gword1
	  P_UNBECOME
	  P_QSPAWN	nullshape,font_flyin,10,20
	  P_BECOME
	    P_IMPORT	shape,gword1
	  P_UNBECOME

	IFNE	mark_scale-3
	error	<change scale program..>
	ENDC

	  P_SET	oy,pbyte2
	  P_ADD	oy,oy
	  P_ADD	oy,oy
	  P_ADD	oy,oy

	  P_ADD	worldx,oy
	P_NEXT

	P_SET		worldx,-750
	P_QSPAWN	clipshape,font_clip3,10,10
	P_WAIT		92
	P_SETBOSSFLAG	burstout,ON
	P_REMOVE

;.tabsh
;	dw	mark_0
;	dw	mark_N
;	dw	mark_i
;	dw	mark_nn
;	dw	mark_t
;	dw	mark_e
;	dw	mark_nn
;	dw	mark_d
;	dw	mark_o
;.tabx
;	db	-70
;	db	19
;	db	18
;	db	19
;	db	19
;	db	23
;	db	23
;	db	23
;	db	0

	IFEQ		1
.newline
	P_SET		worldx,-400
	P_QSPAWN	clipshape,font_clip2,10,10

	P_SET		pbyte2,0
	P_GOSUB		moji_throwchars

	P_WAIT		10
	P_SET		worldx,-400
	P_ADD		worldy,200
	P_ADD		worldz,200
.nextchar2
	P_INDEX		pbyte1,nintendomsg,pbyte2
	P_INC		pbyte2
	P_IFZERO	pbyte1,.nomoremoji2
	P_GOSUB		getfontshape
	P_EXPORT	gword1,pword1

	P_QSPAWN	chr_a,font_flyin,10,10
	P_BECOME
	  P_IMPORT	shape,gword1
	P_UNBECOME

;	P_WAIT		2
	P_ADD		worldx,120

	P_GOTO		.nextchar2
.nomoremoji2

	P_WAIT		60

	P_SETBOSSFLAG	burstout,ON

	P_WAIT		100

	P_ADD		worldy,-200
	P_ADD		worldz,-200

	P_SETBOSSFLAG	burstout,OFF

	P_REMOVE

	ENDC
	ELSEIF
;-------------------------------------------
; the Nintendo presents introduction

	P_BOSSMODELIST	IntroText


;--------- FLAGS ----------
	P_BOSSFLAGLIST
	P_BOSSFLAG	burstout

	START_PATH	NintendoPresents

	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
	P_RANGECHECK	OFF
	P_CLRBOSSFLAGS
.newline
	P_SET		worldx,-400
	P_QSPAWN	clipshape,font_clip2,10,10

	P_SET		pbyte2,0
	P_GOSUB		moji_throwchars

	P_WAIT		10
	P_SET		worldx,-400
	P_ADD		worldy,200
	P_ADD		worldz,200
.nextchar2
	P_INDEX		pbyte1,nintendomsg,pbyte2
	P_INC		pbyte2
	P_IFZERO	pbyte1,.nomoremoji2
	P_GOSUB		getfontshape
	P_EXPORT	gword1,pword1

	P_QSPAWN	chr_a,font_flyin,10,10
	P_BECOME
	  P_IMPORT	shape,gword1
	P_UNBECOME

;	P_WAIT		2
	P_ADD		worldx,120

	P_GOTO		.nextchar2
.nomoremoji2

	P_WAIT		60

	P_SETBOSSFLAG	burstout,ON

	P_WAIT		100

	P_ADD		worldy,-200
	P_ADD		worldz,-200

	P_SETBOSSFLAG	burstout,OFF

	P_REMOVE
	ENDC
;-------------------------------------------------
; Game over text uses NintendoPresents engine

	START_PATH	corneriafell

	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_CLRBOSSFLAGS

	P_SET		pbyte2,corneriafellmsg-nintendomsg
	p_igoto		Pgameover.enter


	START_PATH	GameOver

	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_CLRBOSSFLAGS

	P_SET		pbyte2,gameovermsg-nintendomsg

.enter	LOCAL

	P_SET		worldx,-400
	P_QSPAWN	clipshape,font_clip2,10,10
	P_DO		2

	P_SET		worldx,-400

	P_GOSUB		moji_throwchars

	P_WAIT		10
	P_SET		worldx,-400
	P_ADD		worldy,200

	P_INEXT

	P_WAIT		60

	P_SETBOSSFLAG	burstout,ON

	P_WAIT		100

	P_ADD		worldy,-200
	P_ADD		worldz,-200

	P_SETBOSSFLAG	burstout,OFF

	P_REMOVE

;;;;;nintendomsg	db	"NINTENDO",0
;;;;;	db	"PRESENTS",0
;;;;;gameovermsg
;;;;;	db	"  GAME",0
;;;;;	db	"  OVER",0
;;;;;;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;;;;;youwinmsg
;;;;;	db	"YOU WIN",0
;;;;;	db	"       ",0
;;;;;youlostmsg
;;;;;	db	"YOU LOST",0
;;;;;	db	"       ",0
;;;;;tobecontinuedmsg
;;;;;	db	"  TO BE",0
;;;;;	db	"CONTINUED",0
;;;;;corneriafellmsg
;;;;;	db	"CORNERIA",0
;;;;;	db	"  FELL",0
;;;;;;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA

;---------------------------------------------------
; throw the characters out one by one

moji_throwchars
.nextchar
	P_INDEX		pbyte1,nintendomsg,pbyte2	    
	P_INC		pbyte2
	P_IFZERO	pbyte1,.nomoremoji
	P_GOSUB		getfontshape
	P_EXPORT	gword1,pword1
	P_QSPAWN	chr_a,font_flyin,10,10
	P_BECOME
	  P_SET		coltab,fieryfont_c&WM
	  P_CLIPPING	BOSS
	  P_IMPORT	shape,gword1
	P_UNBECOME

	P_QSPAWN	chr_a,font_flyin,10,10
	P_BECOME
	  P_SET		pbyte1,1
	  P_CLIPPING	BOSS2
	  P_IMPORT	shape,gword1
	P_UNBECOME

;	P_WAIT		2
	P_ADD		worldx,120

	P_GOTO		.nextchar
.nomoremoji
	P_RETURN

;---------------------------------------------------------
; entry: pbyte1 = ascii code
; exit:  pword1 = shape address
;---------------------------------------------------------

getfontshape
	P_IFBETWEEN	47,pbyte1,58,.numbers
	P_ADD	pbyte1,-65
	P_IFBETWEEN	-66,pbyte1,-1,.noletter

	P_INDEX	pword1,fontshapes,pbyte1
	P_RETURN
.noletter
	P_SET	pword1,nullshape
	P_RETURN
.numbers
	P_ADD	pbyte1,-48
	P_INDEX	pword1,fontnumbers,pbyte1
	P_RETURN

;fontshapes
;	dw	chr_a&WM
;	dw	chr_b&WM
;	dw	chr_c&WM
;	dw	chr_d&WM
;	dw	chr_e&WM
;	dw	chr_f&WM
;	dw	chr_g&WM
;	dw	chr_h&WM
;	dw	chr_i&WM
;	dw	chr_j&WM
;	dw	chr_k&WM
;	dw	chr_l&WM
;	dw	chr_m&WM
;	dw	chr_n&WM
;	dw	chr_o&WM
;	dw	chr_p&WM
;	dw	chr_q&WM
;	dw	chr_r&WM
;	dw	chr_s&WM
;	dw	chr_t&WM
;	dw	chr_u&WM
;	dw	chr_v&WM
;	dw	chr_w&WM
;	dw	chr_x&WM
;	dw	chr_y&WM
;	dw	chr_z&WM
;fontnumbers
;	dw	chr_0&WM
;	dw	chr_1&WM
;	dw	chr_2&WM
;	dw	chr_3&WM
;	dw	chr_4&WM
;	dw	chr_5&WM
;	dw	chr_6&WM
;	dw	chr_7&WM
;	dw	chr_8&WM
;	dw	chr_9&WM

;------------------------------------
	START_PATH	font_clip3
	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_GROUNDOBJ	ON
	P_SET		rotz,deg90+deg22
	P_SET		roty,0
	P_SET		rotx,0
	P_ADD		worldz,1500
	P_ADD		worldx,-100


.wipeout
	P_WAIT		19
	P_DO		2000/150
	P_ADD		worldx,150
	P_NEXT

.noburstyet
	P_IFBOSSFLAG	burstout,ON,.remove
	P_GOTO		.noburstyet
.remove
	P_REMOVE
	

;------------------------------------
	START_PATH	font_clip2
	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_GROUNDOBJ	ON
	P_SET		rotz,deg90+deg22
	P_SET		roty,0
	P_SET		rotx,0
	P_ADD		worldz,1000
	P_ADD		worldx,-100


.wipeout
	P_WAIT		30
;	P_DO		1000/50
; Sorry! Kawagoe chenged (12/26)
	P_DO		1100/50+2
	P_ADD		worldx,50
	P_NEXT

.noburstyet
	P_IFBOSSFLAG	burstout,ON,.remove
	P_GOTO		.noburstyet
.remove
	P_REMOVE

;------------------------------------
	START_PATH	font_clip
	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_SET		worldx,0

	P_SET		rotx,0

	P_DO		deg180/3
	P_ADD		rotz,3
	P_NEXT

	P_REMOVE


;------------------------------------

	START_PATH	font_rotatein
	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_SET		depthoffset,1
	P_SET		rotz,rotx
	P_SET		rotx,0
	P_SET		roty,deg90
	P_CLIPPING	BOSS2

.rotatein
	P_IFSAME	roty,deg180,.con
	P_ADD		roty,-deg11
	P_GOTO		.rotatein
.con
	P_WAIT		5
	P_CLIPPING	OFF
	P_WAIT		20
	P_CLIPPING	BOSS
	P_WAIT		22

;	P_DO		20
;	P_ADD		roty,deg22
;	P_ADD		worldz,-40
;	P_NEXT

	P_REMOVE


;-------------------------------------

	START_PATH	font_flyin

	P_SHADOW	OFF

	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_SET		depthoffset,1
	P_SET		skidy,50
	P_RTRIGGER	.scroll,ALWAYS
	P_IFNOTSAME	ap,19,.noclip
	P_CLIPPING	BOSS
	P_SET		skidy,50
	P_SET		depthoffset,1


	p_ifnotsame	shape,mark_0,.COL
	p_spawn		0,0,0,0,0,0,mark_0r,ninten_r,1,1,1
.COL


	P_SET		coltab,fieryfont_c&WM
	P_INVISIBLE	ON
	P_TRIGGER	.invisoff,Timer,10
.noclip
	P_IFNOTSAME	ap,20,.noclip2
	P_SET		skidy,50
	P_CLIPPING	BOSS2
	P_SET		depthoffset,3
.noclip2

.loop
	P_DO		20
	P_ADD		worldz,skidy
;	P_ADD		worldx,15
	P_ADD		rotx,deg11
	P_NEXT
.untilstraight
	P_IFSAME	rotx,0,.nomore
	P_ADD		rotx,deg11
	P_GOTO		.untilstraight
.invisoff
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_RETURN
.nomore

.notyet
	P_IFBOSSFLAG	burstout,ON,.burstout
	P_GOTO		.notyet
.burstout	P_IFSAME	pbyte1,1,.rem
	P_IFSAME	ap,20,.rem
	P_CLIPPING	OFF

	P_PUSH		rotx
	P_PUSH		roty
	P_SETRANDOM	rotx
	P_SETRANDOM	roty

	P_SETVEL	40

	P_PULL		rotx
	P_PULL		roty

	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,-16
	P_SETRANDOM	pbyte2,31
	P_ADD		pbyte2,-16

	P_DO		40
	  P_ADD		rotx,pbyte1
	  P_ADD		roty,pbyte2
	P_NEXT

.rem
	P_REMOVE

.scroll
	P_ADD	ty,4
	P_RETURN
	


;-------------------------------------------
;-------------------------------------------
; Andorf's final incarnation

	P_BOSSMODELIST	FinalAndorf

	P_BOSSFLAGLIST

fandorf_child_pyr1	equ 	1
fandorf_child_pyr2	equ 	2
fandorf_child_pyr3	equ 	3
fandorf_child_pyr4	equ 	4
fandorf_child_pyr5	equ 	5
fandorf_child_pyr6	equ 	6


	IFEQ	1

	START_PATH	finalfinal_andorf
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_RADAROBJ	ra_enemy
	P_SET		area,-1
	P_SET		ap,1
	P_COLLISIONS	OFF

	P_SET		hp,boss_andorf_core_hp

;	P_RTRIGGER	.weirdness,128
	P_RTRIGGER	.spin,ALWAYS
	P_RTRIGGER	.dead,WhenDead

.lp
	P_WOBBLE
	P_WAIT		1
	P_MOVEINPLAYER	10
	P_DISTMORE	150,.lp

	P_WAIT	20
	P_DO	30
	P_WOBBLE
	P_NEXT

	P_COLLISIONS	ON
	P_DO	10
	P_ADD	worldx,10
	P_ADD	worldz,10
	P_WAIT	1
	P_ADD	worldx,-10
	P_ADD	worldz,-10
	P_NEXT

	P_SPAWN	0,0,16*10<<andorf_scale,0,0,0,a_toge_f,toge,10,10,fandorf_child_pyr1
	P_SPAWN	0,0,16*-10<<andorf_scale,0,0,0,a_toge_b,toge,10,10,fandorf_child_pyr2

	P_SPAWN	16*10<<andorf_scale,0,0<<andorf_scale,0,0,0,a_toge_l,toge,10,10,fandorf_child_pyr3
	P_SPAWN	16*-10<<andorf_scale,0,0<<andorf_scale,0,0,0,a_toge_r,toge,10,10,fandorf_child_pyr4

	P_SPAWN	0,16*10<<andorf_scale,0,0,0,0,a_toge_d,toge,10,10,fandorf_child_pyr5
	P_SPAWN	0,16*-10<<andorf_scale,0,0,0,0,a_toge_u,toge,10,10,fandorf_child_pyr6

	P_DO	20
	P_MOVEINPLAYER	-20
	P_NEXT

.rept

	P_WAIT	20

	P_DO		30
	P_CIRCLEPLAYER	3
	P_NEXT

	P_DO		50
	P_DISTLESS	800,.nomovein
	P_MOVEINPLAYER	10
.nomovein	P_NEXT

	P_WAIT		30
	P_DO		20
	P_CIRCLEPLAYER	-3
	P_NEXT
	
	P_DO		30
	P_MOVEINPLAYER	-45
	P_NEXT

	P_GOTO		.rept
	
	P_END

.dead
	P_SET		hp,1
	P_COLLISIONS	OFF
	P_FORCE		.explode
	P_RETURN
.explode
	P_TRIGGER	.dead,OFF
	P_QSPAWN	nullshape,e_runner_damy,10,10
;	P_QSPAWN	nullshape,credits,10,10
	P_GSET		B,andorfdead,1
	P_EXPLODE

.weirdness
	P_JSL65816	weirdness_l
	P_RETURN

.spin
	P_SETMARKER	1

	P_ADD		roty,2
	P_ADD		rotx,7
;	P_ADD		rotz,3

	P_ANDFRAMEGOTO	127,.chghgt
	P_ANDFRAMEGOTO	64,.ret

	P_CHASE		worldy,pword1
.ret
	P_RETURN
.chghgt
	P_SETRANDOM	pword1,4095
	P_ADD		pword1,-2048
	P_RETURN

;----------------------------------------
	START_PATH	toge

;	P_RANGECHECK	OFF
	P_INVINCIBLE	ON

	P_SET	ox,childx
	P_DIV2	ox
	P_DIV2	ox
	P_DIV2	ox
	P_DIV2	ox

	P_SET	oy,childy
	P_DIV2	oy
	P_DIV2	oy
	P_DIV2	oy
	P_DIV2	oy

	P_SET	oz,childz
	P_DIV2	oz
	P_DIV2	oz
	P_DIV2	oz
	P_DIV2	oz

	P_RTRIGGER	.anim,ALWAYS

	P_SET	ap,boss_andorf_toge_ap
	P_SETANIM	0

	P_WEAPON	HomEmissile

.lpit
	P_DO		10
	P_MOVEIN	10
	P_NEXT

	P_SOUNDEFTPOS	bs_cube_close

	P_DO		20
	P_CHASE		childx,ox
	P_CHASE		childx,ox
	P_CHASE		childy,oy
	P_CHASE		childy,oy
	P_CHASE		childz,oz
	P_CHASE		childz,oz
	P_NEXT

	P_BECOMEMOTHER
	  P_INVISIBLE	ON
	P_UNBECOME

	P_IFNOTSAME	sbyte1,fandorf_child_pyr1,.nospew
	P_BECOMEMOTHER
	  P_RTRIGGER	.spew,ALWAYS,20
	P_UNBECOME
.nospew

	P_IFBETWEEN	fandorf_child_pyr1-1,sbyte1,fandorf_child_pyr3+1,.nofire
;	P_FIRE
.nofire
	P_WAIT		60

	P_IFBETWEEN	fandorf_child_pyr1-1,sbyte1,fandorf_child_pyr3+1,.nofire2
;	P_FIRE
.nofire2

	P_BECOMEMOTHER
	  P_INVISIBLE	OFF
	P_UNBECOME

	P_SOUNDEFTPOS	bs_cube_open

	P_DO		20
	P_MOVEIN	-40
	P_NEXT

	P_DO		20
	P_DO		20
	P_BECOMEMOTHER
	  P_DISTLESS	400,.nomovein
	  P_MOVEINPLAYER	20
.nomovein	P_UNBECOME
	P_NEXT

	P_WAIT		10

	P_GOTO		.lpit

	P_END

.spew
	P_QSPAWN	kusa,andorf_spew,10,10
	P_RETURN


.anim
	P_ADDANIM	1,12
	P_RETURN

	ENDC

;-------------------------------------------
;-------------------------------------------
;-------------------------------------------


;----------- BOSS ANDORF -------------------


	P_BOSSMODELIST	Andorf
	P_BOSSMODE	preturn

;--------- FLAGS ----------
	P_BOSSFLAGLIST
	P_BOSSFLAG	claphands
	P_BOSSFLAG	makeball
	P_BOSSFLAG	openmouth
	P_BOSSFLAG	finalstage
	P_BOSSFLAG	breathefire
	P_BOSSFLAG	lefthanddead
	P_BOSSFLAG	righthanddead
	P_BOSSFLAG	blueface
	P_BOSSFLAG	zoomeye
	P_BOSSFLAG	andorfdeath
	P_BOSSFLAG	stophands
	P_BOSSFLAG	breathefire_snd
	P_BOSSFLAG	maskclosed
	P_BOSSFLAG	runawaaaay
	P_BOSSFLAG	dontcomeclose
	p_BOSSFLAG	goback

andorf_child_head	equ	1
andorf_child_jaw	equ	2
andorf_child_lefthand equ	3
andorf_child_righthand equ	4
andorf_child_maskclip equ	10
andorf_child_ball	equ	21
andorf_child_eye	equ	42
andorf_child_head2	equ	43
andorf_child_clip1	equ	44
andorf_child_clip2	equ	45
andorf_child_jaw2	equ	46
andorf_child_clipdummy equ	47
andorf_child_lasereye1 equ	53
andorf_child_lasereye2 equ	54
andorf_child_closemask1 equ	80
andorf_child_closemask2 equ	81
andorf_child_clipmask1 equ	82
andorf_child_clipmask2 equ	83
andorf_child_spineye1	equ	90
andorf_child_spineye2	equ	91
andorf_child_spineye3	equ	92
andorf_child_spineye4	equ	93
andorf_child_backofhead1	equ	94
andorf_child_backofhead2	equ	95
andorf_child_box		equ	97
andorf_child_eyecube		equ	98

;-----------------------------------------------

	START_PATH	boss_andorf



	
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_RADAROBJ	ra_enemy
	P_HITFLASH	OFF
	P_CLRBOSSFLAGS
	P_ENEMYDMGSE	bs_andorf_damage

	P_IFNOTZERO	pbyte1,.expit
	P_SET		pbyte1,boss_andorf_core_hp
	P_GSET		B,andorf_core_onetime,0
.expit	P_EXPORT	andorf_core_hp,pbyte1

	IFNE	FORCEEASYANDROSS
	P_GSET		B,Kdifficulty,dif_easy
	ENDC
	IFNE	FORCENORMALANDROSS
	P_GSET		B,Kdifficulty,dif_normal
	ENDC
	IFNE	FORCEHARDANDROSS
	P_GSET		B,Kdifficulty,dif_hard
	ENDC

	P_GSET		B,eandorf_mode,pm_ground
	P_SET		area,-1
	P_SET		roty,deg180
	P_SET		ap,0

   	P_SET		hp,boss_andorf_mask_hp_hard
	P_IMPORT	pbyte1,Kdifficulty
	P_IFSAME	pbyte1,dif_hard,.hardmode
	P_SET		hp,boss_andorf_mask_hp_norm
.hardmode
;	P_EXPORT	bosshp,hp
;	P_EXPORT	bossmaxhp,hp
;	P_SETBOSSNAME	<Evil Andorf>

	P_SET		tx,hp
	P_DIV2		tx
	P_SET		ty,hp
	P_DIV2		ty

	P_COLLISIONS	OFF
	P_RTRIGGER	.adjustdist,ALWAYS
	P_RTRIGGER	.setmarker,ALWAYS

	P_SPAWN		0,-300,0,0,0,0,and_hako_big,and_hako,10,10,andorf_child_box

	P_IMPORT	pbyte1,andorf_core_onetime
	P_IFNOTZERO	pbyte1,.nowait
	P_WAIT		40
.nowait
;	P_SET		shape,and_hako
	P_SPAWN		500,0,0,0,-deg90-deg45,0,mask,closemaskleft,10,10,andorf_child_closemask1
	P_SPAWN		-500,0,0,0,deg90+deg45,0,mask,closemaskright,10,10,andorf_child_closemask2

.waitwait
	P_WAIT		1
	P_IFBOSSFLAG	maskclosed,OFF,.waitwait
	P_REMOVE	andorf_child_closemask1
	P_REMOVE	andorf_child_closemask2

	P_COLLISIONS	ON
	P_TRIGGER	.hit,WhenHit
	P_TRIGGER	andorf_iroiro,Always
	P_SETCOLANIM	0

	P_REMOVE	andorf_child_box
	P_SET		shape,mask

.lp
	P_SET		pbyte1,tx
	P_ADD		pbyte1,ty
;	P_EXPORT	bosshp,pbyte1
	P_IFNOTZERO	pbyte1,.notdeadyet
	P_INC		pbyte2
	P_IFSAME	pbyte2,20,.andorfburst
	P_GOTO		.lp
.notdeadyet
; --- do we need to warp? ---

	P_SETRANDOM	pbyte1,127
	P_INPLAYERSCONE	-deg22,deg22,.okwarp
	P_IGOTO		.nowarp
.okwarp
	P_IFZERO	pbyte1,.dosomewarping
.nowarp
	P_ANDFRAMEGOTO	1,.smokecheck
	P_GOTO		.lp

; --- warp mask out of view and into another dimension ---

.dosomewarping
	P_TRIGGER	.adjustdist,OFF
	P_ACCEL		80,5

	P_COLLISIONS	OFF

	P_CLIPPING	boss

	P_SPAWN		0,300,0,0,0,0,clipshape,andorfwarper,10,10,11

	P_SOUNDEFTPOS	bs_disappear

	P_WAIT		40
	P_INVISIBLE	ON
	P_WAIT		10

	P_SETRANDOM	pbyte1,128
	P_ADD		pbyte1,64
	P_ADD		roty,pbyte1
	P_SETVEL	100
	P_DO		10
	  P_ADD		worldx,vx
	  P_ADD		worldz,vz
	P_INEXT
	P_SETVEL	0

	P_NEG		pbyte1
	P_ADD		roty,pbyte1

	P_FACEPLAYER	Y
	P_FACEPLAYER	Y
	P_FACEPLAYER	Y
	P_CLIPPING	boss2
	P_REMOVE	11
	P_WAIT		1
	P_SPAWN		0,300,0,0,0,0,clipshape,andorfwarper,10,10,11
	P_WAIT		1
	P_INVISIBLE	OFF

	P_WAIT		20
	P_REMOVE	11
	P_CLIPPING	OFF
	P_RTRIGGER	.adjustdist,ALWAYS
	P_COLLISIONS	ON
	P_GOTO		.lp


.setmarker
	P_SETMARKER	2
	P_RETURN
; --- adjust distance from player continuously ---
.adjustdist	LOCAL
	
	P_IMPORT	pword1,player1_worldy
	P_ANDFRAMEGOTO	64,.nochg
	P_ADD		pword1,600
.nochg
	P_CHASE		worldy,pword1

	P_WOBBLE
	P_FACEPLAYER	Y

	P_IFBOSSFLAG	goback,OFF,.normstuff
	P_ACCEL		-50,5
	P_IGOTO		.closer2
.normstuff
	P_IFBOSSFLAG	dontcomeclose,ON,.dontdo332
	P_ANDFRAMEGOTO	64,.closer
	P_DISTLESS	1400,.accelaway
	P_IGOTO		.there
.dontdo332
	P_DISTLESS	1000,.accelaway
.there
	P_DISTMORE	1600,.acceltowards
;	P_ANDFRAMEGOTO	64,.closer2
	P_ACCEL		0,10
	P_IGOTO		.closer2
.closer
	P_DISTLESS	1200,.accelaway
	P_ACCEL		40,2
.con554
	P_DISTMORE	2000,.acceltowards
	P_ANDFRAMEGOTO	64,.closer2
	P_ACCEL		0,10
.closer2

	P_INPLAYERSCONE	-deg45+deg11,deg45-deg11,.ok
	P_IFNOTBETWEEN	-3,skidy,3,.ok2
	P_INPLAYERSCONE	-deg180+5,0,.oneway

	P_INC	skidy
	P_IGOTO	.ok2
.oneway
	P_DEC	skidy
	P_IGOTO	.ok2
.ok
	P_IFZERO	skidy,.norot

;	P_DO		1

	P_IFBETWEEN	-127,skidy,0,.inc
	P_DEC		skidy
	P_IGOTO		.dec
.inc
	P_INC		skidy
.dec
;	P_INEXT

.ok2
	P_CIRCLEPLAYER	skidy

.norot

	P_RETURN

.acceltowards
	P_ACCEL		80,5
	P_RETURN
.accelaway
	P_ACCEL		-80,10
	P_RETURN

; --- hit routine ---

.hit
	P_SET		hp,64
	P_IFHITFLAG	.1,1
	P_IFHITFLAG	.2,2
	P_RETURN
	
.1
	P_IFZERO	tx,.txz

	P_GOSUB		.gensmoke1
	P_HITFLASHTRIG
	P_DEC	tx
	P_INVINCIBLE	ON
	P_TRIGGER	.muku2,ALWAYS,5
	P_TRIGGER	.muku2_2,Timer,6
	P_IFZERO	tx,.txz
.ret	P_RETURN
.txz
	P_SET		colframe,6+128
	P_IFZERO	ty,.ret
	P_SET		colframe,4+128
	P_RETURN

.2
	P_IFZERO	ty,.tyz
	P_GOSUB		.gensmoke2
	P_HITFLASHTRIG
	P_DEC	ty
	P_INVINCIBLE	ON
	P_TRIGGER	.muku,ALWAYS,5
	P_TRIGGER	.muku_2,Timer,6
	P_IFZERO	ty,.tyz
	P_RETURN
.tyz
	P_SET		colframe,6+128
	P_IFZERO	tx,.ret
	P_SET		colframe,2+128
	P_RETURN


.muku	P_ADD	roty,deg22
	P_RETURN

.muku2	P_ADD	roty,-deg22
	P_RETURN

.muku_2	P_TRIGGER	.muku2,ALWAYS,3
	P_INVINCIBLE	OFF
	P_RETURN
.muku2_2	P_TRIGGER	.muku,ALWAYS,3
	P_INVINCIBLE	OFF
	P_RETURN

; --- Andorf's face bursts through the mask

.andorfburst
	P_TRIGGER	andorf_iroiro,OFF

	P_IMPORT	pbyte1,Kdifficulty
	P_IFSAME	pbyte1,dif_easy,.diediedie

;	P_IFNOTSAME	pbyte1,dif_normal,.nochk
	P_IMPORT	pbyte1,andorf_core_onetime
	P_IFSAME	pbyte1,1,.diediedie
.nochk

	P_COLLISIONS	OFF

	P_SPAWN		0,0,0,0,0,0,andorf_0,andorf_head,10,10,andorf_child_head
	P_GOSUB		and_f_see_hit
	P_SPAWN		0,0,0,0,0,0,clipshape,andorfburst,10,10,andorf_child_maskclip

	P_WAIT		1
	P_CLIPPING	BOSS

.lp433
	P_IFBOSSFLAG	andorfdeath,OFF,.notdeadyet2
	P_SETBOSSFLAG	andorfdeath,OFF
.diediedie	LOCAL
	P_SET	pbyte1,1
	P_DO	100
	  P_BECOMECHILD	pbyte1
	    P_SET	hp,0
	  P_UNBECOME
	  P_INC	pbyte1
	P_INEXT

;	P_GSET		B,andorfdead,1

	P_SPAWN		-300,0,0,0,0,0,nullshape,e_runner_damy,10,10,254
	P_SPAWN		300,0,0,0,0,0,nullshape,e_runner_damy,10,10,253

	P_IMPORT	pbyte1,Kdifficulty
	P_IFSAME	pbyte1,dif_easy,.domask
	P_IMPORT	pbyte1,andorf_core_onetime
	P_IFZERO	pbyte1,.nomask
.domask
	P_CLIPPING	OFF
	P_SPAWN		50,0,0,0,0,0,mask,crackmaskleft,10,10,andorf_child_closemask1
	P_SPAWN		-50,0,0,0,0,0,mask,crackmaskright,10,10,andorf_child_closemask2
	P_GROUNDOBJ	ON
	P_WAIT		1
	P_SET		shape,and_m
	P_SETANIM	0
	P_WAIT		15
	P_DO		5
	  P_ADDANIM	1,16
	P_NEXT
.nomask
;	P_IMPORT	pbyte1,Kdifficulty
;	P_IFSAME	pbyte1,dif_hard,.nodo223
	P_SET		shape,nullshape
	P_SPAWN		0,-300,0,0,0,0,and_hako_big,andorf_death_throes,10,10,252
.nodo223
	P_FLAGCHILD	andorf_child_eyecube
	P_WAIT		50
	P_UNLINKCHILD	andorf_child_eyecube
	P_UNLINKCHILD	254
	P_UNLINKCHILD	253
	P_UNLINKCHILD	252
	P_EXPLODE
.notdeadyet2	P_GOTO		.lp433

	P_END
;.dothat	P_FORCE		.exp
;	P_TRIGGER	.dothat,OFF
;	P_RETURN
;.exp	P_EXPLODE

; --- check if smoke is required from eyes ---

.smokecheck
;	P_GOSUB		.chk1
;	P_GOSUB		.chk2

	P_ANDFRAMEGOTO	127,.doit
	P_GOTO		.lp
.doit
	P_SPAWN		30<<andorf_scale,-40<<andorf_scale,45<<andorf_scale,0,-deg22,0,smallflame,zigzagger,10,boss_andorf_lasereye_ap,andorf_child_lasereye1
	P_SPAWN		-30<<andorf_scale,-40<<andorf_scale,45<<andorf_scale,0,-deg22,0,smallflame,zigzagger,10,boss_andorf_lasereye_ap,andorf_child_lasereye2

	P_RANDOMGOTO	.otherway

	P_BECOMECHILD	andorf_child_lasereye1
	  P_RTRIGGER	.strafe1,ALWAYS
	  P_SET		childroty,-deg22
	P_UNBECOME
	P_BECOMECHILD	andorf_child_lasereye2
	  P_RTRIGGER	.strafe1,ALWAYS
	  P_SET		childroty,-deg22
	P_UNBECOME

.nodo	P_GOTO		.lp
.otherway
	P_BECOMECHILD	andorf_child_lasereye1
	  P_RTRIGGER	.strafe2,ALWAYS
	  P_SET		childroty,deg22
	P_UNBECOME
	P_BECOMECHILD	andorf_child_lasereye2
	  P_RTRIGGER	.strafe2,ALWAYS
	  P_SET		childroty,deg22
	P_UNBECOME
	P_GOTO		.lp

.strafe1
	P_ADD	childroty,1
	P_RETURN
.strafe2
	P_ADD	childroty,-1
	P_RETURN

.chk1
;	P_IFZERO	tx,.gensmoke1
;	P_RETURN
.chk2
;	P_IFZERO	ty,.gensmoke2
;	P_RETURN

.gensmoke1
	P_SPAWN		8<<andorf_scale,-10<<andorf_scale,15<<andorf_scale,0,0,0,smoke,eye_smoke,10,10
	P_RETURN
.gensmoke2
	P_SPAWN		-8<<andorf_scale,-10<<andorf_scale,15<<andorf_scale,0,0,0,smoke,eye_smoke,10,10
	P_RETURN

; --- iro cycling

andorf_iroiro	LOCAL
	P_START65816
	lda	al_colframe,x
	eor	#1
	sta	al_colframe,x
	P_END65816
	P_RETURN

;----------------------------------------------
	START_PATH	andorf_death_throes

	P_ENEMYDMGSE	bs_andorf_damage
	P_GROUNDOBJ	ON
	P_RADAROBJ	ra_enemy
	P_IMPORT	hp,andorf_core_hp
	P_SET		ap,boss_andorf_toge_ap

	P_ALWAYSGENVECS	ON
	P_RTRIGGER	.setmarker,ALWAYS
	P_RTRIGGER	.hit,WhenHIT
	P_RTRIGGER	.dead,WhenDEAD

	P_IMPORT	pbyte1,andorf_core_onetime
	P_IFNOTZERO	pbyte1,.norevt
	P_GSET		B,andorf_core_onetime,1
	P_TRIGGER	.revert,Timer,200
.norevt

	P_DO		20
	P_ADD		childroty,3
	P_ADD		childrotx,5
	P_NEXT

	P_SETVEL	40

.lp
	P_DO		20
	P_ADD		childroty,6
	P_ADD		childrotx,10
	P_ADD		roty,6
	P_ADD		rotx,10
	P_NEXT

	P_WAIT		1

	P_ALWAYSGENVECS	OFF
	P_ACCEL		70,3
	P_DO		50
	  P_ADD		roty,6
	  P_CHASE	rotx,0
	  P_CHASE	worldy,-200
	P_NEXT
	P_ALWAYSGENVECS	ON
	P_ACCEL		40,1

	P_IGOTO		.lp

.dead	LOCAL
	P_SCORE		3000
	P_GSET		B,andorfdead,1
	P_QSPAWN	nullshape,e_runner_damy,10,10
	P_DO	6
	  P_QSPAWN	and_ita,and_ita,10,10
	P_INEXT
	P_BECOME
	  P_TRIGGER	.towardsplayer,ALWAYS,3
	P_UNBECOME
	P_SOUNDEFFECT	andorf_down
	P_RETURN

.hit
	 P_QSPAWN	and_ita,and_ita,10,10
	P_RETURN

.revert
	P_IFZERO	hp,.ret
	P_COLLISIONS	OFF
	P_FORCE		.comebackmask
.ret	P_RETURN

.comebackmask
	P_EXPORT	andorf_core_hp,hp
	P_RTRIGGER	.hikaru,ALWAYS
	P_TRIGGER	pboss_andorf.adjustdist,ALWAYS
	P_DO		50
	  P_CHASE	rotx,0
	  P_CHASE	roty,0
	P_NEXT
	P_ADD		worldy,300
	P_QSPAWN	nullshape,boss_andorf,10,10
	P_BECOME
	  P_IMPORT	pbyte1,andorf_core_hp
	P_UNBECOME
	P_ADD		worldy,-300
	P_WAIT		1
	P_REMOVE
;	P_END
.hikaru
	P_IFSAME	coltab,WHITE_C&WM,.setid
	P_SET	coltab,WHITE_C&WM
	P_RETURN
.setid	P_SET	coltab,id_0_c&WM
	P_RETURN

.setmarker
	P_SETMARKER	2
	P_RETURN

.towardsplayer
	P_RELTOPLAYER	ON
	P_FACEPLAYER	IMMEDIATE
	P_SETVEL	30
	P_RETURN

	START_PATH	and_ita

	P_COLLISIONS	OFF
	P_SETRANDOM	roty
	P_SETRANDOM	rotx
	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,-16
	P_SETRANDOM	pbyte2,31
	P_ADD		pbyte2,-16
	P_SETVEL	30
	
	P_DO		80
	  P_ADD		rotx,pbyte1
	  P_ADD		roty,pbyte2
	P_NEXT

	P_REMOVE
;	P_EXPLODE
;----------------------------------------------
; the andorf box

	START_PATH	and_hako
	P_COLLISIONS	OFF
	P_GROUNDOBJ	ON
.lp
	P_ADD		childroty,deg11
	P_GOTO		.lp

; --- two masks from either side rotate and close

	START_PATH	closemaskleft
	P_INVINCIBLE	ON
;	P_RANGECHECK	OFF
	P_SPAWN		0,0,0,0,0,-deg90,clipshape,clipmaskright,10,10,andorf_child_clipmask1
	P_CLIPPING	BOSS
	P_INVISIBLE	ON
	P_WAIT		30
	P_INVISIBLE	OFF

.lp	P_ADD		childroty,2
	P_IFSAME	childx,0,.nodec
	P_ADD		childx,-10
.nodec	P_WAIT		1
	P_IFNOTSAME	childroty,0,.lp

	P_SOUNDEFFECT	face_close

	P_CLIPPING	OFF
	P_REMOVE	andorf_child_clipmask1
	P_SETBOSSFLAG	maskclosed,ON
	P_END

	START_PATH	closemaskright
	P_INVINCIBLE	ON
;	P_RANGECHECK	OFF
	P_CLIPPING	BOSS3
	P_SPAWN		0,0,0,0,0,deg90,clipshape2,clipmaskright,10,10,andorf_child_clipmask2
	P_INVISIBLE	ON
	P_WAIT		30
	P_INVISIBLE	OFF

.lp	P_ADD		childroty,-2
	P_IFSAME	childx,0,.noinc
	P_ADD		childx,10
.noinc	P_WAIT		1
	P_IFNOTSAME	childroty,0,.lp

	P_REMOVE	andorf_child_clipmask2
	P_END


; --- two masks from either side crack and break open

	START_PATH	crackmaskleft
	P_SPAWN		0,0,0,0,0,-deg90,clipshape,clipmaskright,10,10,andorf_child_clipmask1
	P_CLIPPING	BOSS
	P_INVISIBLE	ON
	P_WAIT		1
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF

	P_DO		2
	  P_ADD		childx,50
	P_NEXT
	P_SOUNDEFFECT	face_broken1
	P_DO	8
	  P_ADD		childx,20
	  P_WAIT	1
	  P_ADD		childx,-20
	P_NEXT

	P_SOUNDEFFECT	face_broken2

.lp	P_ADD		childrotz,-4
	P_ADD		childx,60
	P_ADD		childy,100
;	P_WAIT		1
	P_GOTO		.lp

	P_CLIPPING	OFF
	P_REMOVE	andorf_child_clipmask1
	P_SETBOSSFLAG	maskclosed,ON
	P_END

	START_PATH	crackmaskright
	P_CLIPPING	BOSS3
	P_INVISIBLE	ON
	P_WAIT		1
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_SPAWN		0,0,0,0,0,deg90,clipshape2,clipmaskright,10,10,andorf_child_clipmask2

	P_DO		2
	  P_ADD		childx,-50
	P_NEXT
	P_DO	8
	  P_ADD		childx,-20
	  P_WAIT	1
	  P_ADD		childx,20
	P_NEXT

.lp	P_ADD		childrotz,4
	P_ADD		childx,-60
	P_ADD		childy,100
;	P_WAIT		1
	P_GOTO		.lp

	P_REMOVE	andorf_child_clipmask2
	P_END

; --- clipping planes for the closing masks

	START_PATH	clipmaskleft
	START_PATH	clipmaskright
	P_COLLISIONS	OFF
	P_END

; --- Special laser fired from mask ---

	START_PATH	zigzagger

	P_SOUND		p2_androf_fire

	P_INVISIBLE	ON

	P_SET		shape,firebr
	P_SET		ap,2
;	P_SPRITE	0
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
;	P_FACEPLAYER	IMMEDIATE
;	P_ADJUSTROT

	P_RTRIGGER	.tracepath,2

	P_WAIT		16

;;	P_RANDOMGOTO	.croty

;;	P_SET		childroty,-deg22
;;	P_DO		20
;;	  P_ADD		childroty,1
;;	P_NEXT
	P_REMOVE


.croty
;;	P_RANDOMGOTO	.crotx
;;	P_SET		childroty,deg22
;;	P_DO		20
;;	  P_ADD		childroty,-1
;;	P_NEXT
;;	P_REMOVE

.crotx
;;	P_SET		childrotx,-deg22
;;	P_DO		20
;;	  P_ADD		childrotx,1
;;	P_NEXT
;;	P_REMOVE

	IFEQ	1
	P_WAIT		1
	P_DO		20
	  P_ADD		childrotx,1
	P_NEXT

	P_WAIT		1
	P_DO		20
	  P_ADD		childroty,-1
	P_NEXT

	P_WAIT		1
	P_DO		20
	  P_ADD		childrotx,-1
	P_NEXT

	ENDC
	P_REMOVE

.tracepath
	P_QSPAWN	plasma1,eyelasertracer,10,boss_andorf_lasereye_ap
	P_RETURN

	IFEQ	1

	START_PATH	zig_ball
	P_SPRITE	0,-24
	P_SET		coltab,tamatama_c&WM
	P_END

	ENDC

	START_PATH	eyelasertracer
;	P_SPAWN		0,0,800,0,0,0,magmaball,zig_ball,10,2,1
;	P_RELTOPLAYER	ON
;	P_INVISIBLE	ON
	P_COLLISIONS	ON
	P_INVINCIBLE	ON
	P_SETVEL	80
;	P_SPRITE	0
;	P_SET		shape,egplasma1
	P_SET		shape,firebr
;	P_RANGECHECK	OFF
	P_RTRIGGER	.spinit,ALWAYS
	
	P_WAIT		12

	P_REMOVE

.spinit
	P_ADD	rotz,deg22
	P_RETURN


	IFEQ		1

	P_SET		pbyte1,deg90
	P_DO		8

	P_SETVEL	15

	P_WAIT		10

	P_SETVEL	0

	P_WITHINRADIUS	80,.setfire
	P_IGOTO		.dontsetfire
.setfire	P_PLRBURN	C
.dontsetfire

	P_WAIT		3

	P_DISTMORE	200,.nodo
	P_FACEPLAYER	IMMEDIATE
	P_IGOTO		.nn
.nodo

	P_ADD		roty,pbyte1
	P_NEG		pbyte1
.nn

	P_NEXT
	P_REMOVE

	ENDC

; --- smoke pours from them eyes ---

	START_PATH	eye_smoke
	P_COLLISIONS	OFF
	P_SPRITE	0,32
	P_SETCOLANIM	0
;	P_RANGECHECK	OFF
	P_RELTOPLAYER	ON

	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,-16
	P_ADD		worldx,pbyte1
	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,-16
	P_ADD		worldy,pbyte1

	P_WAIT		1

	P_DO		8
	P_ADD		tx,2
	P_ADD		worldy,-20
	P_ADDCOLANIM	1,8
	P_NEXT


	P_REMOVE

; --- Warp Andorf with a clipping plane ---

	START_PATH	andorfwarper
	P_GROUNDOBJ	ON
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF

.lp
	P_ADD		childy,-20
	P_ADD		childx,-20
	P_ADD		childrotz,4
	P_GOTO		.lp
	P_END

; --- Strip away the old shape with the clipping plane ---

	START_PATH	andorfburst
	P_GROUNDOBJ	ON
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF

	P_SET		childrotx,-deg90+deg11
	P_SET		childz,400

	P_SOUNDEFTPOS	bs_disappear

	P_DO		16
	P_ADD		childz,-19
	P_NEXT
	P_WAIT		1
	P_ADD		childz,-10
	P_WAIT		1
	P_BECOMEMOTHER
	  P_SET		shape,MASK_S
	  P_CLIPPING	OFF
	P_UNBECOME
	P_END

; --- Andorf's real face (homma kai na) ---

	START_PATH	andorf_head

	P_ENEMYDMGSE	bs_andorf_damage
	P_SETBOSSFLAG	dontcomeclose,ON

	P_SPAWN		0,0,0,0,0,0,andorf_1,andorf_mouth,10,10,andorf_child_jaw

	P_SETCOLANIM	0
	P_TRIGGER	andorf_iroiro,ALWAYS
 
	P_SET		ap,boss_andorf_head_ap
	P_SET		hp,boss_andorf_cowl_hp_hard
	P_IMPORT	pbyte1,Kdifficulty
	P_IFSAME	pbyte1,dif_hard,.hardmode2
	P_SET		hp,boss_andorf_cowl_hp_norm
.hardmode2
;	P_EXPORT	bosshp,hp
;	P_EXPORT	bossmaxhp,hp

	P_HITFLASH	OFF

	P_RTRIGGER	.setclip,ALWAYS
	P_RTRIGGER	.dead,WhenDead
	P_RTRIGGER	.hit,WhenHit

;	P_RANGECHECK	OFF
	P_CLIPPING	BOSS2

	P_INVINCIBLE	ON
	P_WAIT		25

	P_IMPORT	pbyte1,credits_on
	P_IFNOTZERO	pbyte1,.nohands

	P_SPAWN		-800,4000,0,0,0,0,hand_l,andorf_lefthand,10,10,andorf_child_lefthand
	P_BECOME
	  P_INVISIBLE	ON
	P_UNBECOME
	P_SPAWN		800,4000,0,0,0,0,hand_r,andorf_righthand,10,10,andorf_child_righthand
	P_BECOME
	  P_INVISIBLE	ON
	P_UNBECOME
.nohands
;	P_DO		10
;	  P_ADD		childz,-2
;	P_NEXT
	P_INVINCIBLE	OFF

.lp
	P_WAIT		20
	P_SETBOSSFLAG	claphands,ON
	P_FLAGCHILD	2

	P_WAIT		30
	P_GOTO		.lp

.makemoreballs
	P_SPAWN		0,0,200,0,0,0,nullshape,andorf_ball,10,10,andorf_child_ball
	P_BECOME
	  P_IMPORT	childroty,bbyte1
	  P_SET		pbyte1,deg22
	  P_GADD	bbyte1,pbyte1
	P_UNBECOME
	P_RETURN
.setclip
; --- do we need to spawn a ball of magic? ---
	P_IFBOSSFLAG	makeball,OFF,.nomakeball
	P_SETBOSSFLAG	makeball,OFF
	P_GSET		B,bbyte1,-deg22-deg11
	P_TRIGGER	.makemoreballs,4,16

	P_SETBOSSFLAG	goback,ON
	P_TRIGGER	.gobackoff,Timer,40

.nomakeball
	P_CLIPPING	BOSS2
	P_RETURN

.gobackoff
	P_SETBOSSFLAG	goback,OFF
	P_RETURN


; --- Obi WAN KANOBI's hit routine---

.hit
	P_INVINCIBLE	ON
	P_TRIGGER	.blink,ALWAYS,10
	P_TRIGGER	.unblink,Timer,15
;	P_EXPORT	bosshp,hp
	P_CLIPPING	OFF
	P_RETURN

.blink
	P_ADD		childz,-2
	P_RETURN

.unblink	P_TRIGGER	.unblink2,ALWAYS,10
	P_RETURN
.unblink2
	P_ADD		childz,2
	P_IFLASTTRIG	.invoff
	P_RETURN
.invoff
	P_INVINCIBLE	OFF
	P_RETURN

; --- Obi WAN KANOBI's death scene ---

.dead
;	P_EXPORT	bosshp,hp
	P_SET	hp,1
	P_INVINCIBLE	ON
	P_SETBOSSFLAG	finalstage,ON
	P_FORCE		.fullview
	P_TRIGGER	all,off
; 	P_TRIGGER	andorf_iroiro,OFF
;	P_TRIGGER	.makemoreballs,OFF
;	P_TRIGGER	.unblink,OFF
;	P_TRIGGER	.unblink2,OFF
;	P_TRIGGER	.invoff,OFF
;	P_TRIGGER	.hit,OFF
	P_SETCOLANIM	2
	P_RETURN

; --- Obi Wan Kanobi comes out from under his hood ---
.fullview
	P_SETBOSSFLAG	goback,OFF
	P_SOUNDEFFECT	stop_tr3

	P_IMPORT	pbyte1,Kdifficulty
	P_IFNOTSAME	pbyte1,dif_normal,.nodie
	P_SETBOSSFLAG	andorfdeath,ON
	P_END
.nodie

	P_QSPAWN	nullshape,e_runner_damy,10,10

	P_SETBOSSFLAG	stophands,ON
	P_TRIGGER	.hit,OFF
	P_TRIGGER	.dead,OFF

	P_WAIT		20

	P_TRIGGER	.setclip,OFF
	P_BECOMEMOTHER
	  P_SET	shape,nullshape
	  P_CLIPPING	OFF
	P_UNBECOME

	P_CLIPPING	OFF
	P_BECOMECHILD	andorf_child_jaw
	  P_CLIPPING	OFF
	P_UNBECOME

	P_REMOVE	andorf_child_maskclip

	P_SPAWN	0,0,0,0,0,0,andorf_2,andorf_backofhead,10,10,andorf_child_backofhead1
	P_SPAWN	0,0,0,0,0,0,andorf_3,andorf_backofhead,10,10,andorf_child_backofhead2

;	P_RTRIGGER	.gensmoke,4
;	P_RTRIGGER	.eerie_eye,2

	P_SET		pbyte1,50
.waitfordeadhands
	P_DEC		pbyte1
	P_IFNOTZERO	pbyte1,.chkhands

; --- turn around and run away

	P_SOUND		p2_andorf_magic2
	P_SETBOSSFLAG	runawaaaay,ON
	P_BECOMEMOTHER
	  P_TRIGGER	pboss_andorf.adjustdist,OFF
	  P_ALWAYSGENVECS	ON
	  P_ACCEL	90,1
	P_UNBECOME

	P_WAIT		60

	P_DO	4
	P_SETRANDOM	pbyte1,deg5
	P_ADD		pbyte1,-deg5/2
	P_EXPORT	bbyte2,pbyte1
	P_SETRANDOM	pbyte1,deg11
	P_ADD		pbyte1,-deg11/2
	P_EXPORT	bbyte3,pbyte1
	P_DO		8
	  P_BECOMEMOTHER
	    P_IMPORT	tx,bbyte2
	    P_IFNOTBETWEEN	-deg45,rotx,deg45,.stop
	    P_ADD	rotx,tx
.stop
	    P_IMPORT	tx,bbyte3
	    P_ADD	roty,tx
	  P_UNBECOME
	P_NEXT
	P_NEXT

	P_DO		15
	  P_BECOMEMOTHER
	    P_CHASE	rotx,0
	    P_CHASE	rotx,0
	  P_UNBECOME
	P_NEXT

	P_BECOMEMOTHER
	  P_ALWAYSGENVECS	OFF
	P_UNBECOME

	P_SET		pbyte1,100

	P_SETBOSSFLAG	runawaaaay,OFF
	P_BECOMEMOTHER
	  P_ACCEL	0,10
	  P_TRIGGER	pboss_andorf.adjustdist,ALWAYS
	P_UNBECOME
.chkhands
	P_WAIT		1
	P_IFBOSSFLAG	lefthanddead,OFF,.waitfordeadhands
	P_IFBOSSFLAG	righthanddead,OFF,.waitfordeadhands

	P_QSPAWN	nullshape,e_runner_damy,10,10

	P_SETBOSSFLAG	openmouth,ON
	P_WAIT		15
	P_SETBOSSFLAG	openmouth,OFF

; --- now for the cheshire cat type effect with andorf's eye
; --- this uses four clipping planes, two images of the head
; --- and an extra image behind all of them of the remaining eye

	P_SPAWN		0,0,0,0,0,0,and_eye,eerie_eye,10,10,andorf_child_eye
	P_GOSUB		and_f_see
	P_SPAWN		0,0,0,0,0,0,andorf_0,clipeffect_face,10,10,andorf_child_head2
	P_GOSUB		and_f_see
	P_SPAWN		0,0,0,0,0,0,andorf_1,andorf_mouth,10,10,andorf_child_jaw2
	P_GOSUB		and_f_see

	P_SPAWN		100,-300,0,0,0,0,nullshape,eye_clip_dummy,10,10,andorf_child_clipdummy

	P_WAIT		2	; wait for clip planes to initialise

	P_BECOMECHILD	andorf_child_jaw2
	  P_CLIPPING	BOSS3
	  P_SET		coltab,id_1_c&WM
	P_UNBECOME

	P_BECOMECHILD	andorf_child_jaw
	  P_CLIPPING	BOSS2
	P_UNBECOME

	P_CLIPPING	BOSS2

.waitforblue
	P_WAIT		1
	P_IFBOSSFLAG	blueface,OFF,.waitforblue
.loopblue
	P_SETBOSSFLAG	openmouth,breathefire,breathefire_snd,ON
	P_SETRANDOM	ox,255
	P_RANDOMGOTO	.noneg
	P_NEG		ox
.noneg
	P_DO	50
	  P_CHASE	childy,ox
	P_NEXT

	P_IFBOSSFLAG	blueface,ON,.loopblue
	P_DO	50
	  P_CHASE	childy,0
	  P_CHASE	childy,0
	P_NEXT
	P_GOTO		.waitforblue

.invincibleoff
	P_INVINCIBLE	OFF
	P_RETURN


; --- smoke is already pouring out of his eye ---
.gensmoke	P_SPAWN		-8<<andorf_scale,-10<<andorf_Scale,5<<andorf_scale,0,0,0,smoke,eye_smoke,10,10
	P_RETURN


and_f_see_hit
	P_BECOME
	P_INVISIBLE	ON
	P_TRIGGER	can_see_hit,Timer,4
	P_UNBECOME
	P_RETURN
can_see_hit
	P_INVISIBLE	OFF
	P_RETURN

and_f_see
	P_BECOME
	P_INVISIBLE	ON
	P_TRIGGER	can_see,Timer,4
	P_UNBECOME
	P_RETURN
can_see
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_RETURN
; --- the back of andorf's head

	START_PATH	andorf_backofhead
;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_END

;--- dokuro_0 (skeletal face) ---

	START_PATH	dokuro_0

	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLIPPING	BOSS2


	P_END

; --- dummy shape for clipping planes to rotate around
	START_PATH	eye_clip_dummy
	P_COLLISIONS	OFF
	P_INVISIBLE	ON
	P_SPAWN		0,0,0,0,0,0,clipshape,eye_clip_1,10,10,andorf_child_clip1
	P_SPAWN		0,0,0,0,0,0,clipshape2,eye_clip_2,10,10,andorf_child_clip2
.forever
	P_ADD		childrotz,12
	P_IFFLAG	.stop
	P_GOTO		.forever
.stop	P_IFFLAG	.forever
	P_GOTO		.stop

; --- clipping plane 1 for eyeball stage

	START_PATH	eye_clip_1
	P_COLLISIONS	OFF
	P_GROUNDOBJ	ON
;	P_RANGECHECK	OFF

	P_SET		pbyte1,boss_andorf_eyecube_hp
	P_ADD		childy,15
.lp
	P_WAIT		50
	P_SETBOSSFLAG	zoomeye,ON
	P_BECOMEMOTHER
	  P_SPAWN	0,-300,-500,0,0,0,and_hako_big,andorf_eyecube,10,10,andorf_child_eyecube
	P_UNBECOME
	P_BECOMECHILD	andorf_child_head
	  P_COLLISIONS	OFF
	P_UNBECOME
	P_BECOMECHILD	andorf_child_head2
	  P_COLLISIONS	OFF
	P_UNBECOME

	P_DO		25
		P_ADD		childy,10
	P_NEXT

.waitzoom	P_WAIT		1
	P_IFBOSSFLAG	zoomeye,ON,.waitzoom

	P_BECOMECHILD	andorf_child_head2
	  P_COLLISIONS	ON
	  P_INVINCIBLE	ON
	P_UNBECOME
	P_BECOMECHILD	andorf_child_head
	  P_COLLISIONS	ON
	  P_INVINCIBLE	ON
	P_UNBECOME
	P_BECOMECHILD	andorf_child_eyecube
	  P_COLLISIONS	OFF
	P_UNBECOME

	P_DO		25
		P_ADD		childy,-10
	P_NEXT

	P_REMOVE	andorf_child_eyecube

.waitforrot
	P_IFBETWEEN	-6,rotz,6,.con
	P_GOTO		.waitforrot

.con
	P_DO		20
	P_ADD		childy,50
	P_NEXT

	P_FLAGCHILD	andorf_child_clipdummy

	P_BECOMECHILD	andorf_child_head
	  P_INVISIBLE	ON
	P_UNBECOME
	P_BECOMECHILD	andorf_child_head2
	  P_CLIPPING	OFF
	P_UNBECOME
	P_SETBOSSFLAG	blueface,ON

	P_WAIT		20
;	P_SETRANDOM	pbyte1,31
;	P_ADD		pbyte1,10
;	P_WAIT		pbyte1

	P_BECOMECHILD	andorf_child_head
	  P_INVISIBLE	OFF
	P_UNBECOME
	P_BECOMECHILD	andorf_child_head2
	  P_CLIPPING	BOSS3
	P_UNBECOME

	P_SETBOSSFLAG	blueface,OFF

	P_FLAGCHILD	andorf_child_clipdummy

	P_DO		20
	P_ADD		childy,-50
	P_NEXT

	P_GOTO	.lp
	P_END

; 
	START_PATH

; --- clipping plane 2 for eyeball stage

	START_PATH	eye_clip_2
	P_COLLISIONS	OFF
	P_GROUNDOBJ	ON
;	P_RANGECHECK	OFF
	P_ADD		childy,-10
.lp
	P_WAIT		50
	P_DO		25
		P_ADD		childy,-10
	P_NEXT

.waitzoom	P_WAIT		1
	P_IFBOSSFLAG	zoomeye,ON,.waitzoom

	P_DO		25
		P_ADD		childy,10
	P_NEXT

.waitforrot
	P_IFBETWEEN	-6,rotz,6,.con
	P_GOTO		.waitforrot

.con
	P_DO		20
	P_ADD		childy,50
	P_NEXT

.waitnotblue
	P_WAIT		1
	P_IFBOSSFLAG	blueface,ON,.waitnotblue

	P_DO		20
	P_ADD		childy,-50
	P_NEXT

	P_GOTO	.lp
	P_END

; --- andorf's cube thing

	START_PATH	andorf_eyecube

	P_GROUNDOBJ	ON
	P_SET		hp,100
	P_RTRIGGER	.hit,WhenHIT
	P_ENEMYDMGSE	bs_andorf_damage

	P_DO		100
	  P_ADD		childrotx,4
	  P_ADD		childroty,6
	  P_IFFLAG	.dontremoveyet
	P_NEXT
	P_REMOVE
.dontremoveyet
	P_TRIGGER	.hit,OFF
	P_COLLISIONS	OFF
	P_DO		50
	  P_ADD		childrotx,7
	  P_ADD		childroty,12
	P_NEXT
	P_IGOTO		pandorf_death_throes.dead
	
	
.hit
	P_SET	pbyte2,hp
	P_ADD	pbyte2,-100
	P_EXPORT	gbyte1,pbyte2
	P_BECOMECHILD	andorf_child_clip1
	  P_IMPORT	pbyte2,gbyte1
	  P_ADD		pbyte1,pbyte2
	  P_IFBETWEEN	0,pbyte1,127,.ok
	  P_SETBOSSFLAG	andorfdeath,ON
;	  P_GSET	B,andorfdead,1
.ok
	P_UNBECOME
	P_SET	hp,100
	P_RETURN

; --- andorf's eyeball ---

	START_PATH	eerie_eye

	P_COLLISIONS	OFF
	P_GROUNDOBJ	ON
	P_SET		hp,boss_andorf_eye_hp

.wait	P_WAIT		1
	P_IFBOSSFLAG	zoomeye,OFF,.wait

	P_GROUNDOBJ	OFF
	P_RELATIVE	OFF
	P_SETVEL	40

	P_SOUND		p2_androf_eye

	P_TRIGGER	.addvecs,ALWAYS,50

	P_WAIT		10

	P_RELTOPLAYER	ON
	P_SETVEL	0

; --- create the eyes

	P_SET	pbyte1,0
	P_DO	4
	  P_QSPAWN		and_eye,eerie_eye_spin,10,0
	  P_EXPORT	gbyte1,pbyte1
	  P_BECOME
	    P_IMPORT	ap,gbyte1
	  P_UNBECOME
	  P_INC	pbyte1
	P_NEXT

; --- wait for them to initialise

	P_WAIT		1

	P_INVISIBLE	ON

; --- wait to finish
	P_WAIT		eye_time-2

	P_RELTOPLAYER	OFF

; --- import the hp back



	P_SETBOSSFLAG	zoomeye,OFF

	P_SETVEL	0

	P_SET	childx,0
	P_SET	childy,0
	P_SET	childz,0

	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_GROUNDOBJ	ON
	P_RELATIVE	ON

; set the real mother (the head shape)

	P_BECOMECHILD	andorf_child_head
	  P_START65816
	  stx gword1
	  P_END65816
	P_UNBECOME

	P_IMPORT	childrotobj,gword1

	P_SOUND		port2_stop

	P_WAIT		1	

	P_GOTO		.wait

	P_END

; --- add vectors each frame
.addvecs
	P_ADD		worldx,vx
	P_ADD		worldy,vy
	P_ADD		worldz,vz
	P_RETURN

; --- hit routine
.dead
	P_SETBOSSFLAG	andorfdeath,ON
	P_GSET		B,andorfdead,1
.hit
	P_INVISIBLE	ON
	P_RETURN

; --- eerie eyes spin outward

	START_PATH	eerie_eye_spin
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_SET		pbyte1,ap
	P_SET		hp,1
	P_SET		ap,boss_andorf_eye_ap
	P_ADD		pbyte1,pbyte1
	P_TRIGGER	.rem,Timer,eye_time
;	P_TRIGGER	.switchdir,Timer,eye_time/2
	P_TRIGGER	.coldeton,Timer,7
	P_HITFLASH	OFF

	P_FACEPLAYER	IMMEDIATE
	P_INDEX		pbyte2,.chiisai_tab,pbyte1
	P_ADD		roty,pbyte2
	P_INDEX		pbyte2,.chiisai_tab+1,pbyte1
	P_ADD		rotx,pbyte2
	P_SETVEL	90
.lp
	P_WAIT		eye_time
	P_REMOVE

.coldeton
	P_COLLISIONS	ON
	P_RTRIGGER	.hit,WhenHit
	P_RETURN

.hit
	P_IFSAME	pbyte2,1,.norem
	P_FORCE		.rem2
	P_RETURN
.norem	P_HITFLASHTRIG
	P_RETURN

.switchdir
	P_ADD	ap,4
	P_IFBETWEEN	0,ap,8,.noprob
	P_ADD	ap,-8
.noprob	P_RETURN

.rem	P_FORCE		.rem2
	P_RETURN
.rem2	P_REMOVE
	P_END

.chiisai_tab
	db	-deg22,0
	db	deg22,0
	db	0,deg22
	db	0,-deg22
	db	-deg22,-deg22
	db	deg22,-deg22
	db	-deg22,deg22
	db	deg22,deg22

; --- andorf's double face for clipping effect ---

	START_PATH	clipeffect_Face
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLIPPING	BOSS3
	P_SETCOLANIM	7
	P_SET		coltab,id_1_c&WM
	P_END

;--- andorf's right hand ---
	START_PATH	andorf_righthand
	P_INVINCIBLE	ON
	P_WAIT	1
	P_INVISIBLE	OFF
	P_INVINCIBLE	ON

	P_ENEMYDMGSE	bs_andorf_damage
;	P_RANGECHECK	OFF
	P_SETCOLANIM	0

	P_SET		childrotz,-deg22
	P_SET		childrotx,deg90
	P_SETANIM	0
	P_TRIGGER	.anim,ALWAYS
	P_RTRIGGER	.r_dead,WhenDead

.lp
	P_IFBOSSFLAG	finalstage,ON,.finalstage
	P_IFBOSSFLAG	claphands,ON,.claprighthand
	P_GOTO		.lp


; --- when the right hand dies set the flag
.r_dead
	P_SOUND		port2_stop
	P_SETBOSSFLAG	righthanddead,ON
	P_RETURN

; --- Andorf is in his final stage
.finalstage
	P_SET		colframe,0
	P_INVINCIBLE	OFF
	P_SET		hp,boss_andorf_hand_hp
	P_SET		ap,boss_andorf_hand_ap
.finallp
	P_WAIT		50
	P_INVINCIBLE	ON
	P_DO		20
	  P_CHASE		childx,200
	  P_CHASE		childz,1000
	  P_CHASE		childrotx,deg90
	P_NEXT

	P_IFBOSSFLAG	runawaaaay,ON,.nofire
	P_SETBOSSFLAG	openmouth,breathefire,breathefire_snd,ON
.nofire
	P_DO		30
	  P_CHASE		childx,600
	  P_CHASE		childz,100
	  P_CHASE		childz,100
	  P_CHASE		childrotx,0
	  P_CHASE		childroty,0
	  P_CHASE		childrotz,0
	  P_GOSUB		.playerchase
	P_NEXT

	P_INVINCIBLE	OFF

	P_WAIT		20
	P_RANDOMGOTO	.dontfire

	P_DO	10
	P_CHASE		childroty,deg45
	P_CHASE		childroty,deg45
	P_CHASE		childy,-200
	P_CHASE		childx,1000
	P_NEXT

	P_WEAPON	eplasma1
	P_DO		8

	  P_IFBOSSFLAG	runawaaaay,ON,.nofire23
	  P_PLAYERINCONE	deg45,.fire33
	  P_IGOTO	.nofire23
.fire33
	  P_FIRE
	  P_BECOME
	    P_FACEPLAYER IMMEDIATE
	    P_ADD	worldy,-50
	    P_SET	coltab,dokuro_c&WM
	  P_UNBECOME
.nofire23
	P_WAIT		3
	P_NEXT

	P_DO	10
	P_CHASE		childroty,0
	P_CHASE		childroty,0
	P_CHASE		childy,100
	P_CHASE		childx,600
	P_NEXT

.dontfire
	P_GOTO		.finallp


; --- chase the player to the current object's coords
.playerchase	LOCAL
	P_RETURN
	  P_EXPORT		gword1,worldx
	  P_EXPORT		gword2,worldy
	  P_EXPORT		gword3,worldz
	  P_START65816
	    ldy	playpt1
	    s_achase_alvar	W,y,al_worldx,gword1,3
	    s_achase_alvar	W,y,al_worldy,gword2,3
	    s_achase_alvar	W,y,al_worldz,gword3,3
	    toheap y,y
	    s_achase_alvar	W,y,exal_worldx,gword1,3
	    s_achase_alvar	W,y,exal_worldy,gword2,3
	    s_achase_alvar	W,y,exal_worldz,gword3,3
	  P_END65816
	P_RETURN

; --- clap the right hand

.claprighthand
	P_DO		20
	P_CHASE		childroty,deg90
	P_CHASE		childrotx,0
	P_CHASE		childx,60
	P_CHASE		childz,100
	P_CHASE		childy,100
	P_NEXT
	P_IFBOSSFLAG	stophands,ON,.skipfin
	P_TRIGGER	.anim,OFF
	P_GOSUB		.gakki_sound

	P_WAIT		25
	P_IFBOSSFLAG	stophands,ON,.le_fin
;	P_WAIT		25
;	P_IFBOSSFLAG	stophands,ON,.le_fin

	P_SETBOSSFLAG	makeball,ON
	P_DO		10
	  P_ADD		childx,40
	P_NEXT

	P_RTRIGGER	.anim,ALWAYS

	P_IFBOSSFLAG	stophands,ON,.skipfin

	P_WAIT		20

	P_SOUNDEFFECT	bs_magic_stop

	P_SETBOSSFLAG	openmouth,ON

	P_IGOTO		.skipfin
.le_fin	P_RTRIGGER	.anim,ALWAYS
.skipfin
	P_SOUNDEFFECT	bs_magic_stop
	P_TRIGGER	.gakki_sound,OFF

	P_DO		10
	  P_DO	3
	   P_CHASE		childroty,0
	   P_CHASE		childx,700
	   P_CHASE		childy,300
	  P_INEXT
	P_NEXT
	P_WAIT		1

	P_DO		15
	  P_DO	3
	   P_CHASE		childrotx,deg90
	   P_CHASE		childroty,0
	   P_CHASE		childx,700
	   P_CHASE		childy,300
	  P_INEXT
	P_NEXT

.lp3
	P_SETBOSSFLAG	claphands,OFF
	P_GOTO		.lp

.anim
	P_ADDANIM	1,15
	P_RETURN
.gakki_sound
	P_SOUNDEFFECT	bs_androf_magic
	P_TRIGGER	.gakki_sound,Timer,20
	P_RETURN


;--- andorf's left hand ---

	START_PATH	andorf_lefthand
	P_INVINCIBLE	ON
	P_WAIT	1
	P_INVISIBLE	OFF
	P_INVINCIBLE	ON
	P_ENEMYDMGSE	bs_andorf_damage
;	P_RANGECHECK	OFF
	P_SETANIM	0
	P_SETCOLANIM	0

	P_SET		childrotz,deg22
	P_SET		childrotx,deg90
	P_TRIGGER	.anim,ALWAYS
	P_RTRIGGER	.l_dead,WhenDead

.lp
	P_IFBOSSFLAG	finalstage,ON,.finalstage
	P_IFBOSSFLAG	claphands,ON,.claplefthand
	P_GOTO		.lp
; --- Andorf is in his final stage
.finalstage
	P_SET		colframe,0
	P_INVINCIBLE	OFF
	P_SET		hp,boss_andorf_hand_hp
	P_SET		ap,0
.finallp

	P_WAIT		50
	P_INVINCIBLE	ON
	P_DO		20
	  P_CHASE		childx,-200
	  P_CHASE		childz,1000
	  P_CHASE		childrotx,deg90
	P_NEXT

	P_DO		30
	  P_CHASE		childx,-600
	  P_CHASE		childz,100
	  P_CHASE		childz,100
	  P_CHASE		childrotx,0
	  P_CHASE		childroty,0
	  P_CHASE		childrotz,0
	  P_GOSUB		pandorf_righthand.playerchase
	P_NEXT

	P_INVINCIBLE	OFF
	P_WAIT		20
	P_RANDOMGOTO	.dontfire

	P_DO	10
	P_CHASE		childroty,-deg45
	P_CHASE		childroty,-deg45
	P_CHASE		childy,300
	P_CHASE		childx,-1000
	P_NEXT

	P_WEAPON	eplasma1
	P_DO		8

	  P_IFBOSSFLAG	runawaaaay,ON,.nofire23
	  P_PLAYERINCONE	deg45,.fire33
	  P_IGOTO	.nofire23
.fire33
	  P_FIRE
	  P_BECOME
	    P_FACEPLAYER IMMEDIATE
	    P_ADD	worldy,-50
	    P_SET	coltab,dokuro_c&WM
	    P_INVINCIBLE OFF
	    P_SET	hp,2
	    P_TRIGGER	.setsnd,Timer,3
	  P_UNBECOME
.nofire23
	P_WAIT		3
	P_NEXT

	P_DO	10
	P_CHASE		childroty,0
	P_CHASE		childroty,0
	P_CHASE		childy,100
	P_CHASE		childx,-600
	P_NEXT

.dontfire
 
	P_GOTO		.finallp

.setsnd
	P_SOUND		port2_stop
	P_SOUND		p2_ironball
	P_RETURN

; --- when the left hand dies set the flag
.l_dead
	P_SOUND		port2_stop
	P_SETBOSSFLAG	lefthanddead,ON
	P_RETURN


; --- clap the left hand
.claplefthand
	P_DO		20
	  P_CHASE		childroty,-deg90
	  P_CHASE		childrotx,0
	  P_CHASE		childx,-60
	  P_CHASE		childz,100
	  P_CHASE		childy,100
	P_NEXT
	P_IFBOSSFLAG	stophands,ON,.skipfin
	P_TRIGGER	.anim,OFF
	P_SOUNDEFFECT	bs_androf_magic
	P_WAIT		25
	P_IFBOSSFLAG	stophands,ON,.le_fin
;	P_WAIT		25
;	P_IFBOSSFLAG	stophands,ON,.le_fin

	P_SETBOSSFLAG	makeball,ON

	P_DO		10
	  P_ADD		childx,-40
	P_NEXT

	P_RTRIGGER	.anim,ALWAYS

	P_IFBOSSFLAG	stophands,ON,.skipfin

	P_WAIT		20

	P_SOUNDEFFECT	bs_magic_stop

	P_SETBOSSFLAG	openmouth,ON

	P_IGOTO		.skipfin
.le_fin	P_RTRIGGER	.anim,ALWAYS
.skipfin
	P_SOUNDEFFECT	bs_magic_stop
	P_DO		10
	  P_DO	3
	   P_CHASE		childroty,0
	   P_CHASE		childx,-700
	   P_CHASE		childy,300
	  P_INEXT
	P_NEXT
	P_WAIT	1

	P_DO		15
	  P_DO	3
	   P_CHASE		childroty,0
	   P_CHASE		childx,-700
	   P_CHASE		childrotx,deg90
	   P_CHASE		childy,300
	  P_INEXT
	P_NEXT

	P_SETBOSSFLAG	claphands,OFF
	P_GOTO		.lp

.anim
	P_ADDANIM	1,15
	P_RETURN

;--- Magic ball ---

	START_PATH	andorf_ball

	P_SETTYPE	LASER
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_ALWAYSGENVECS	ON
	P_SPRITE	0
	P_SET		shape,bossball&WM
	P_SET		coltab,enemybomb_c&WM
	P_SET		tx,-20

	P_SOUND		p2_EPlasma

	P_DO		10
	  P_ADD		tx,5
	P_NEXT
	P_WAIT		15
	P_DO		5
	  P_ADD		tx,-10
	P_NEXT

	P_WAIT		5

	P_COLLISIONS	ON
	P_INVINCIBLE	ON
	P_UNLINKCHILD
;	P_FACEPLAYER	IMMEDIATE
	P_SETVEL	90

	P_SOUNDEFTPOS	en_ringlaser_s

	P_SET		ap,boss_andorf_ball_ap

	P_DO		10
	  P_CHASE		tx,0
	P_NEXT
	P_WAIT	1

	P_DO		10
	  P_CHASE		tx,0
	  P_FACEPLAYER
	P_NEXT
	P_WAIT	1

	P_DO		30
	  P_CHASE		tx,0
	P_NEXT

	P_DO	5
	  P_CHASE	tx,-50
	P_NEXT

	P_REMOVE

;--- andorf's mouth ---

	START_PATH	andorf_mouth

	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLIPPING	BOSS2
	P_SETANIM	0

.lp
	P_IFBOSSFLAG	openmouth,OFF,.noopen
	P_SETBOSSFLAG	openmouth,OFF
	P_DO		5
	  P_ADDANIM	1,6
;	  P_CHASE		childrotx,deg45
;	  P_CHASE		childrotx,deg45
;	  P_IFNOTSAME		childrotx,deg45,.nofire
	P_NEXT
	P_IFBOSSFLAG		breathefire,OFF,.nofire

	P_DO	4
	  P_SPAWN		0,0,30,0,0,0,smallflame,andorf_breath,10,10,19
	  P_WAIT		1
	P_NEXT
.nofire
;	P_NEXT
	P_SETBOSSFLAG		breathefire,OFF
.noopen
	P_IFSAME	animframe,128,.nodo
;	P_CHASE		childrotx,0
	P_ADDANIM	-1,6
.nodo
	P_GOTO		.lp

	IFEQ	1

	P_IFFLAG	.openmouth
.openmouth
	P_DO		2
	  P_ADD		childrotx,12
	P_NEXT
	P_DO		30
	  P_QSPAWN	kusa,andorf_spew,10,10
	  P_BECOME
	    P_ADD	worldy,40
	  P_UNBECOME
	P_NEXT
	P_DO		2
	  P_ADD		childrotx,-12
	P_NEXT
	P_GOTO		.lp



	P_DO		10
	  P_ADD		childrotx,2
	P_NEXT
	P_WAIT		1
	P_DO		10
	  P_ADD		childrotx,-2
	P_NEXT
	P_GOTO		.lp
	P_END

	ENDC

; --- Andorf's firey breath! ---

	START_PATH	andorf_breath

	P_IFBOSSFLAG	breathefire_snd,OFF,.nosnd
	P_SETBOSSFLAG	breathefire_snd,OFF
	P_IFBOSSFLAG	blueface,ON,.chigau_oto
	P_SOUND		p2_androf_fire
	P_IGOTO		.nosnd
.chigau_oto
	P_SOUND		p2_ERing
.nosnd

	P_SPRITE	0
;	P_RANGECHECK	OFF
	P_SETANIM	0
	P_SETVEL	60
	P_ALWAYSGENVECS	ON
	P_INVINCIBLE	ON
	P_RTRIGGER	.hit,WhenHIT
	P_SET		ap,boss_andorf_breath_ap

	P_IFBOSSFLAG	blueface,OFF,.nochange
	P_SET		coltab,ringlaser_c&WM
	P_ADD		ap,ap
.nochange
	P_IFSAME	coltab,ringlaser_c&WM,.otherspin

	P_SET		childroty,deg90
	P_DO		10
	  P_ADD		childrotx,256/10
	  P_INC		tx
	  P_ADDANIM	1,4
	P_NEXT
	P_IGOTO		.conasnorm

.otherspin
	P_SET		childroty,-deg90
	P_DO		10
	  P_ADD		childrotx,-256/10
	  P_INC		tx
	  P_ADDANIM	1,4
	P_NEXT
.conasnorm
	P_UNLINKCHILD

	P_DO	20
	  P_FACEPLAYER
	  P_FACEPLAYER
	P_NEXT
	P_WAIT	10
.rem	P_REMOVE
.hit	P_FORCE	.rem
	P_RETURN

; --- Andorf's spew ---

	IFEQ	1
	START_PATH	andorf_spew

	P_SET	ap,2
	P_INVINCIBLE	ON
	P_SET	coltab,dokuro_c

	P_SPRITE	0
	P_RELTOPLAYER	ON
;	P_RANGECHECK	OFF

	P_FACEPLAYER	IMMEDIATE
	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,-16
	P_ADD		roty,pbyte1
	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,-16
	P_ADD		rotx,pbyte1
	P_WAIT		10
	P_SETVEL	40

	P_WAIT		60
	P_REMOVE


; -- clipping plane shape --

	START_PATH	wierd

	P_GROUNDOBJ	ON
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF

	P_SET		childrotx,-deg90+deg11

	P_SET		childz,100
	P_RTRIGGER	.reform,ALWAYS
.chkloop
	P_IFFLAG	.reveal
	P_GOTO		.chkloop

.reveal
	P_ADD		childz,-15
	P_GOTO		.chkloop

.reform
	P_IFSAME	childz,200,.nowt
	P_INC		childz
	P_IFSAME	childz,200,.nowt
	P_INC		childz
.nowt
	P_RETURN

	P_END


	ENDC








;------------ END BOSS ANDORF -------------------



;----------- BOSS_RUNNER -------------------
	P_BOSSMODELIST	Runner
;--------- FLAGS ----------
	P_BOSSFLAGLIST
	P_BOSSFLAG	faster

br_child_bigwheel	equ	1
br_child_littlewheel	equ	2
br_child_leftsupport	equ	3
br_child_rightsupport equ	4

	START_PATH	boss_runner

	P_SHADOW	OFF
	P_SOUND		p2_runner_3
	P_SET		hp,boss_runner_hp
	P_SET		shape,runner_3
	P_SET		area,-1
	P_SET		pbyte2,-deg5
;	P_RANGECHECK	OFF
	P_RADAROBJ	ra_enemy
;;;;eguchi write
;	P_TRIGGER	marker_set,Always
;;;;eguchi end

	P_ENEMYDMGSE	en_cry_3

;	P_SPAWN		0,12<<runner_Scale,47<<runner_Scale,0,0,0,runner_1,br_littlewheel,10,10,br_child_littlewheel
	P_SPAWN		52<<runner_Scale,-35<<runner_Scale,-5<<runner_Scale,0,0,0,runner_2,br_supports,10,10,br_child_leftsupport
	P_SPAWN		-52<<runner_Scale,-35<<runner_Scale,-5<<runner_Scale,0,0,0,runner_2,br_supports,10,10,br_child_rightsupport

	P_SET		pbyte1,boss_runner_hp
;;;;eguchi write
;	P_DIV2		pbyte1
;	P_DIV2		pbyte1
;;;;eguchi end
	P_EXPORT	bosshp,pbyte1
	P_EXPORT	bossmaxhp,pbyte1
	P_SETBOSSNAME	name_runner

	P_ACCEL		30,1

	P_RTRIGGER	.dead,WhenDead
	P_RTRIGGER	.run,ALWAYS
;	P_RTRIGGER	.hgtchk,ALWAYS
	P_RTRIGGER	.hit,WhenHit
	P_END

.sethp
	P_PUSH		pbyte1
	P_SET		pbyte1,hp
	P_EXPORT	bosshp,pbyte1
	P_PULL		pbyte1
	P_RETURN
.hit
	P_GOSUB		.sethp
	P_TRIGGER	pbr_bigwheel.fasteroff,Timer,40
	P_SETBOSSFLAG	faster,ON
	P_RETURN
.dead
	P_GOSUB		.sethp
;;;;eguchi write
	P_SCORE		500
	P_QSPAWN	runner_3,e_runner_damy_kong,100,0
;;;;eguchi end
;eguchi9/7	P_GINC		B,ebyte2
;	P_GDEC		B,KEnemyNumber

	P_SOUNDEFTPOS	en_death_3
	P_SOUNDEFTPOS	bs_bossexplode2

;eguchi9/7	P_SET		hp,1
	P_COLLISIONS	OFF
	P_TRIGGER	all,off
;	P_TRIGGER	.dead,OFF
;	P_TRIGGER	.run,OFF
;	P_TRIGGER	.setx1,OFF
;	P_TRIGGER	.setx2,OFF
;	P_TRIGGER	.setz1,OFF
;	P_TRIGGER	.setz2,OFF
;	P_TRIGGER	.beginrottrig,OFF
;eguchi9/7	P_TRIGGER	.doit,Timer,10
;eguchi9/7	P_RTRIGGER	.nomove,ALWAYS
	P_RETURN
;eguchi9/7
;;.nomove	P_SETVEL	0
;;	P_RETURN
;;
;;.doit	P_GOSUB		make_random_item
;;	P_FORCE		.exp
;;	P_RETURN
;;.exp	P_EXPLODE
;kokomade

.hgtchk
;;;;eguchi write
;	P_DIV2		pbyte1
;	P_DIV2		pbyte1
;;;;eguchi end
;eguchi coment	P_EXPORT	bosshp,hp

;	P_JSL65816	getheight_l
;	P_IMPORT	worldy,y1

	P_RETURN

.run
; check for player behind
	P_DISTMORE	700,.nocheck

	P_ACCEL		55,2

	P_PLAYERINCONE	deg45,.turnaround
	P_IGOTO		.checked
.nocheck
	P_IFBOSSFLAG	faster,ON,.speedy_gonzales
	P_DISTLESS	2000,.checked
	P_ACCEL		10,1			;eguchi change 20->0
.speedy_gonzales
	P_ACCEL		55,10
	P_IGOTO		.checked
.checked
	P_ANDFRAMEGOTO	63,.chk			;eguchi change 127->63
	P_IGOTO		.nochk
.chk
	P_DISTMORE	1800,.nochk		;eguchi change 1500->1800

	P_FLAGCHILD	br_child_leftsupport
	P_FLAGCHILD	br_child_rightsupport
	

.nochk

	P_ANDFRAMEGOTO	31,.fire
	P_IGOTO		.nofire
.fire
	P_PUSH		worldy
	P_PUSH		rotx
	P_PUSH	roty
	P_ADD	rotx,-deg11+2
	P_ADD		worldy,-160
	P_ADD		roty,deg180-deg22
	P_WEAPON	relelaser
	P_FIRE
	P_ADD		roty,deg22
	P_FIRE
	P_ADD		roty,deg22
	P_FIRE

	P_ADD		roty,-deg180
	P_PULL	roty
	P_PULL		rotx
	P_PULL		worldy

.nofire

	P_IFSAME	roty,-deg90,.runright
	P_IFSAME	roty,deg90,.runleft
	P_IFSAME	roty,0,.runup
	P_IFSAME	roty,deg180,.rundown
	P_RETURN

.turnaround
	P_FORCE		.turn
	P_RETURN
.turn
	P_TRIGGER	.run,OFF
	P_NEG		pbyte2
.trn
	P_ACCEL		0,10
	P_IFZERO	vel,.nowturn
	P_GOTO		.trn
.nowturn
	P_DO		deg180/deg11
	P_ADD		roty,-deg11
	P_NEXT

	P_ACCEL		30,1
	P_TRIGGER	.run,ALWAYS
	P_END

.runright
	P_IFBETWEEN	5120-512,worldx,5120,.setrotx1
	P_RETURN
.runleft
	P_IFBETWEEN	0,worldx,512,.setrotx2
	P_RETURN
.runup
	P_IFBETWEEN	5120-512,worldz,5120,.setrotz1
	P_RETURN
.rundown
	P_IFBETWEEN	0,worldz,512,.setrotz2
	P_RETURN

.setrotx1	P_FORCE		.beginrot
	P_TRIGGER	.setx1,ALWAYS,30
	P_RETURN
.setrotx2	P_FORCE		.beginrot
	P_TRIGGER	.setx2,ALWAYS,30
	P_RETURN
.setrotz1	P_FORCE		.beginrot
	P_TRIGGER	.setz1,ALWAYS,30
	P_RETURN
.setrotz2	P_FORCE		.beginrot
	P_TRIGGER	.setz2,ALWAYS,30
	P_RETURN

.setx1	P_CHASE		worldx,5120-256
	P_RETURN
.setx2	P_CHASE		worldx,256
	P_RETURN
.setz1	P_CHASE		worldz,5120-256
	P_RETURN
.setz2	P_CHASE		worldz,256
	P_RETURN

.beginrot
	P_TRIGGER	.run,OFF
	P_RTRIGGER	.beginrottrig,ALWAYS
	P_END
.beginrottrig
	P_ACCEL		0,6
	P_ADD		roty,pbyte2
	P_IFSAME	roty,deg90,.endrot
	P_IFSAME	roty,0,.endrot
	P_IFSAME	roty,-deg90,.endrot
	P_IFSAME	roty,deg180,.endrot

	P_RETURN

.endrot	P_FORCE		.forceendrot
	P_RETURN
.forceendrot
	P_ACCEL		30,1
	P_TRIGGER	.beginrottrig,OFF
	P_TRIGGER	.run,ALWAYS
	P_END


;----------- Big wheel on front of runner -----------

	START_PATH	br_bigwheel

	P_INVINCIBLE	ON
	P_SET		area,-1
;	P_RANGECHECK	OFF
.lp
	P_IFFLAG	.throwit
	P_ADD		childrotx,deg11
	P_GOTO		.lp
	P_END

.accel
	P_ADD	worldx,vx
	P_ADD	worldz,vz
	P_RETURN

.fasteroff	LOCAL
	P_SETBOSSFLAG	faster,OFF
	P_RETURN

; --- launch it off ---
.throwit
;	P_BECOMEMOTHER
;	  P_TRIGGER	.accel,ALWAYS,30
;	P_UNBECOME
	P_SOUNDEFTDISTPOS	en_throw_2
	P_UNLINKCHILD

	P_SETBOSSFLAG	faster,ON
	P_TRIGGER	.fasteroff,Timer,30

	P_PUSH		rotx
	P_SET		rotx,0
	P_DISTLESS	400,.slower
	P_DISTLESS	800,.slower2
	P_SETVEL	-50
	P_IGOTO		.vset
.slower2
	P_SETVEL	-35
	P_IGOTO		.vset
.slower
	P_SETVEL	-20
.vset
	P_PULL		rotx
	P_SET		pbyte1,60
.bethrown
	P_DEC		pbyte1
	P_IFZERO	pbyte1,.explode
	P_ADD		rotx,-deg22
	P_ADD		vy,4
	P_HITGROUND	30,.bounce
	P_GOTO		.bethrown
.bounce
	P_SOUNDEFTDISTPOS	en_land_L
	P_NEG		vy
	P_DIV2		vy
	P_GOTO		.bethrown

.explode	P_EXPLODE

;----------- Little wheel on front of runner -----------

	START_PATH	br_littlewheel

	P_COLLISIONS	OFF
	P_SET		area,-1
;	P_RANGECHECK	OFF
.lp
	P_ADD		childrotx,deg11
	P_GOTO		.lp
	P_END


;----------- Side struts -----------

	START_PATH	br_supports
	P_COLLISIONS	OFF
	P_SET		area,-1
;	P_RANGECHECK	OFF
.remake
	P_IFCHILD	br_child_leftsupport,.nospawn
	P_SPAWN		52<<runner_scale,35<<runner_scale,-35<<runner_Scale,0,0,0,runner_0,br_bigwheel,10,boss_runner_wheel_ap,br_child_bigwheel
.nospawn

.chkflg	P_IFFLAG	.raisearms
	P_GOTO		.chkflg

.raisearms
	P_DO		25
	P_ADD		childrotx,deg5
	P_NEXT
	P_FLAGCHILD	br_child_bigwheel
	P_WAITCHASE	childrotx,0
	P_IGOTO		.remake





;----------- B_TANK ------------------------

	START_PATH	B_TANK

	IFEQ	1

;	P_RANGECHECK	OFF
	P_INVINCIBLE	ON
	P_RADAROBJ	ra_enemy
	P_SPAWN		40<<b_tank_scale,-40<<b_tank_scale,-60<<b_tank_scale,0,-deg90,0,b_tank_1,b_tank_launcher,10,10,1
	P_SPAWN		-40<<b_tank_scale,-40<<b_tank_scale,-60<<b_tank_scale,0,deg90,0,b_tank_1,b_tank_launcher,10,10,2
	P_SPAWN		0,-40<<b_tank_scale,20<<b_tank_scale,0,0,0,b_tank_0,b_tank_launcher,10,10,3

	P_SET		ap,b_tank_ap

	P_ALWAYSGENVECS	ON
;;;;eguchi write
	P_TRIGGER	marker_set,Always

	P_SET		pword1,0
	P_EXPORT	bossflags,pword1
	P_SET		pbyte1,0
	P_EXPORT	bossmode,pbyte1

	P_SET		pbyte1,b_tank_launcher_hp*3
	P_DIV2		pbyte1
;	P_EXPORT	bosshp,pbyte1
;	P_EXPORT	bossmaxhp,pbyte1

;	P_SETBOSSNAME	<Mad Tank>
	P_RTRIGGER	.b_tank_meter,ALways
;;;;eguchi end
	P_RTRIGGER	.movetracks,ALWAYS

	P_ACCEL		30,1
	P_WAIT		50
	P_ACCEL		0,1
	P_WAIT		20
	P_DO		deg90/2
	  P_ADD		roty,2
	P_NEXT
	P_ACCEL		50,1
	P_WAIT		50

;;;;eguchi write
.turn_again

	P_RANDOMGOTO	.turn_little
	P_RANDOMGOTO	.turn_little
	P_ACCEL		0,4
	P_WAIT		30

	P_RANDOMGOTO	.turn_neg
	P_DO		30
	  P_ADD		roty,4
	P_NEXT
	P_IGOTO		.turn_neg_end
.turn_neg
	P_DO		30
	  P_ADD		roty,-4
	P_NEXT
.turn_neg_end
	P_ACCEL		50,1
	P_WAIT		50

.turn_little
;;;;eguchi end
	P_RANDOMGOTO	.left

.lp
	P_ACCEL		0,4
	P_WAIT		30
	P_DO		10
	  P_ADD		roty,4
	P_NEXT

	P_ACCEL		50,1
	P_WAIT		50

;;;;eguchi write
	P_IGOTO		.turn_again
;;;;eguchi end
	P_IGOTO		.lp

.left
.lp2
	P_ACCEL		0,4
	P_WAIT		30
	P_DO		10
	  P_ADD		roty,-4
	P_NEXT

	P_ACCEL		50,1
	P_WAIT		50

;;;;eguchi write
	P_IGOTO		.turn_again
;;;;eguchi end
	P_IGOTO		.lp2
	
	P_END
.cd1
	P_CHILDDEAD	2,.cd2
	P_IGOTO		.ndead
.cd2	P_CHILDDEAD	3,.cd3
	P_IGOTO		.ndead
.cd3
	P_FORCE		.dead
	P_IGOTO		.ndead
.dead
	P_TRIGGER	.movetracks,OFF
	P_TRIGGER	pdr_dragon1.explode,4

;;;;eguchi write
	P_ACCEL		0,5
	P_SETVEL	0
	P_TRIGGER	crash_flash,4
;;;;eguchi end
	P_WAIT		50
;;;;eguchi write
	P_GOSUB		boss_exp_screen_flash
;;;;eguchi end
	P_GDEC		B,KEnemyNumber
;;;;eguchi write
	P_SCORE		1000
	P_CIRCLEWINDOW	1,big
;;;;eguchi end
	P_EXPLODE

.movetracks
	P_CHILDDEAD	1,.cd1
.ndead
	P_IFZERO	vel,.nowt
	P_SET		pbyte1,vel
	P_NEG		pbyte1
	P_DIV2		pbyte1
	P_ADD		ty,pbyte1
.nowt	P_RETURN

;;;;eguchi write
.b_tank_meter
	P_PUSH		pbyte1
	P_ZERO		pbyte1
	P_EXPORT	bosshp,pbyte1
	P_SET		pbyte1,1
	P_DO		3
	P_BECOMECHILD	pbyte1
	P_SET		slopenum,hp
	P_DIV2		slopenum
	P_GADD		bosshp,slopenum
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT
	P_PULL		pbyte1
	P_RETURN
;;;;eguchi end

;------------ b_tank's turrets ------------------

	START_PATH	B_TANK_launcher

;	P_RANGECHECK	OFF

	P_TRIGGER	.death,WhenDead
	P_SHADOW	OFF
	P_SET		hp,b_tank_launcher_hp
	P_SET		ap,b_tank_launcher_ap

	P_SET		pbyte2,childroty

.lp
	P_IFNOTSAME	childroty,pbyte2,.nope

	P_BECOMEMOTHER
	  P_EXPORT	gbyte1,vel
	P_UNBECOME

	P_IMPORT	pbyte1,gbyte1
	P_IFZERO	pbyte1,.shootchk
.nope
	P_CHASE		childroty,pbyte2
	P_GOTO		.lp

.shootchk
	P_PUSH		roty
	P_PUSH		rotx
	P_FACEPLAYER	IMMEDIATE
	P_PULL		rotx

	P_SET		pbyte1,roty

	P_PULL		roty


	P_SET		skidy,roty
	P_NEG		skidy
	P_ADD		pbyte1,skidy		; find the difference


	P_IFNOTBETWEEN	-deg90+2,pbyte1,deg90-2,.nope

	P_TRIGGER	.ponponpon,16
	P_TRIGGER	.rotback,ALWAYS
	P_DO		50
	P_FACEPLAYER	Y
	P_ADJUSTROT
	P_NEXT

	P_TRIGGER	.ponponpon,OFF

.waitfor0	P_IFSAME	childrotx,0,.con
	P_GOTO		.waitfor0
.con
	P_TRIGGER	.rotback,OFF

	P_GOTO		.lp

.rotback
	P_CHASE		childrotx,0
	P_RETURN
.ponponpon
	P_DISTMORE	1200,.nowt
	P_PUSH		rotx
	P_PUSH		roty
	P_ADD		worldy,-30
	P_FACEPLAYER	IMMEDIATE
	P_WEAPON	releplasma1
	P_FIRE
	P_ADD		worldy,30
	P_PULL		roty
	P_PULL		rotx

	P_ADD		childrotx,-deg22
.nowt
	P_RETURN

; --- The death routine ---

.death
	P_SET	hp,1
	P_INVINCIBLE	ON
	P_FORCE	.bounceandexplode
	P_RETURN

.bounceandexplode
	P_SHADOW	ON
	P_TRIGGER	.ponponpon,OFF
	P_TRIGGER	pdr_dragon1.explode,4
	P_TRIGGER	.death,OFF
	P_WAIT		16
	P_BECOMEMOTHER
	  P_EXPORT	gword1,worldx
	  P_EXPORT	gword2,worldz
	P_UNBECOME

	P_IMPORT	vx,gword1
	P_NEG		vx
	P_ADD		vx,worldx
	P_IMPORT	vz,gword2
	P_NEG		vz
	P_ADD		vz,worldz

	P_DO	4
	  P_DIV2	vx

	  P_IFCHILD	3,.nodo
	  P_DIV2	vz
.nodo
	P_INEXT

	P_UNLINKCHILD

	P_SET		vy,-32
.fly
	P_ADD		rotx,12
	P_ADD		vy,4
	P_HITGROUND	40,.die
	P_GOTO		.fly

.die
	P_INVINCIBLE	OFF
	P_EXPLODE


	ENDC



	IFEQ	1

;------------------- START BOSS DRAGON ----------------------

DRAGONBOSSSTART

	P_BOSSMODELIST	Dragon
	P_BOSSMODE	dr_stationary
	P_BOSSMODE	dr_tiltright
	P_BOSSMODE	preturn
	

;--------- FLAGS ----------
	P_BOSSFLAGLIST
	P_BOSSFLAG	steppedon


; --- children ---


dr_child_head	equ	1

; **** tilt to the right ****

dr_tiltright

.lp3	P_IFSAME	pbyte2,10,.le_fin3
	P_INC		pbyte2
	P_GOTO		.lp3
.le_fin3
	P_GOSUB		dr_makedrag2

	P_WAIT		120

.lp4	P_IFSAME	pbyte2,4,.le_fin4
	P_DEC		pbyte2
	P_GOTO		.lp4
.le_fin4
	P_GOSUB		dr_makedrag1
	P_WAIT		120


.lp	P_IFSAME	pbyte2,14,.le_fin
	P_INC		pbyte2
	P_GOTO		.lp
.le_fin

	P_GOSUB		dr_makedrag4
	P_WAIT		120

.lp2	P_IFZERO	pbyte2,.le_fin2
	P_DEC		pbyte2
	P_GOTO		.lp2
.le_fin2
	P_GOSUB		dr_makedrag3
	P_WAIT		120


	P_GOTO		dr_tiltright
	P_NEXTBOSSMODE
	P_RETURN

; --- make a dragon that's waiting to bite ---

dr_makedrag1
	P_IMPORT	pbyte1,bosshp
	P_IFZERO	pbyte1,.nomake1
	P_QSPAWN	dragon_0,dr_dragon1,10,10
	P_BECOME
	  P_ADD		worldx,600
	  P_ADD		roty,deg90
	P_UNBECOME
.nomake1
	P_RETURN

dr_makedrag2
	P_IMPORT	pbyte1,bosshp
	P_IFZERO	pbyte1,.nomake2
	P_QSPAWN	dragon_0,dr_dragon1,10,10
	P_BECOME
	  P_ADD		worldx,-600
	  P_ADD		roty,-deg90
	P_UNBECOME
.nomake2
	P_RETURN

dr_makedrag3
	P_IMPORT	pbyte1,bosshp
	P_IFZERO	pbyte1,.nomake3
	P_QSPAWN	dragon_0,dr_dragon1,10,10
	P_BECOME
	  P_ADD		worldx,400
	  P_ADD		roty,deg90
	P_UNBECOME
.nomake3
	P_RETURN

dr_makedrag4
	P_IMPORT	pbyte1,bosshp
	P_IFZERO	pbyte1,.nomake4
	P_QSPAWN	dragon_0,dr_dragon1,10,10
	P_BECOME
	  P_ADD		worldx,-400
	  P_ADD		roty,-deg90
	P_UNBECOME
.nomake4
	P_RETURN


; **** wait a while ****

dr_stationary
	P_SET		slopenum,1
	P_TRIGGER	.stepped,WhenSteppedOn
	P_SETBOSSFLAG	steppedon,OFF
.lp	P_WAIT		1
	P_CHASE		pbyte2,7
	P_IFBOSSFLAG	steppedon,OFF,.lp
	P_TRIGGER	.stepped,OFF
	P_NEXTBOSSMODE
	P_RETURN
.stepped	P_SETBOSSFLAG	steppedon,ON
	P_RETURN
	

	ENDC
;������������������������������������������������������������������������Ŀ
	START_PATH	BOSS_Dragon

	IFEQ	1

;	P_RANGECHECK	OFF
	P_SHADOW	OFF
	P_MOVEPLAYER	ON

	P_SLOPE		ON
	P_COLLISIONS	OFF

	P_SET		pbyte2,8	; stationary position

	P_SET		hp,boss_crusher_body_hp
	P_SET		ap,boss_crusher_body_ap

	P_RADAROBJ	ra_enemy

; player no mae hajimaru

	P_START65816
	ldy	pathplayer&WM
	a16
	lda.w	al_worldx,y
	clc
	adc	#0
	sta	al_worldx,x
	lda.w	al_worldz,y
	clc
	adc	#700
	sta	al_worldz,x
	P_END65816

	P_SET	worldy,10<<hako_0_scale

; clear some vital flags

	P_CLRBOSSFLAGS
	P_SETBOSSMODE	start
	
	P_SET		pbyte1,boss_dragon_hp
	P_EXPORT	bosshp,pbyte1
	P_EXPORT	bossmaxhp,pbyte1

;	P_SETBOSSNAME	<Frumpy Dragon>
 
	P_SET		shape,hako_0

	P_CLIPPING	ON


; make some vital body parts

; .. and set up some player bits and pieces:

	P_TRIGGER	.mainloop,ALWAYS
	P_TRIGGER	.firtreecheck,4
	P_TRIGGER	.deccount,WhenDead

.again
	P_GOSUB	.setbossmode

	P_GOTO	.again

.setbossmode
	P_JUMPBOSSMODE

; --- when dead decrement map count ---

.deccount
	P_GDEC	B,KEnemyNumber
	P_RETURN

; --- main loop, called every frame ---

.mainloop

	P_SET	animframe,pbyte2
	P_ADD	animframe,128
	P_INDEX	rotz,.angletab,pbyte2

	P_RETURN

; --- Check if we need some firtrees ---

.firtreecheck
	P_DISTLESS	1000,.nofirtrees

	ENDC

.firtrees	LOCAL
	P_QSPAWN	flame,dr_firtree,10,10
	P_SOUNDEFTDISTPOS	pillar_of_flames
	P_GOSUB		dp_plrrndset

	IFEQ	1
.nofirtrees
	P_RETURN

; --- table for matching slope animation with real angle ---

.angletab	db	-7*2,-6*2,-5*2,-4*2,-3*2,-2*2,-1*2,0
	db	1*2,2*2,3*2,4*2,5*2,6*2,7*2

;����������������������������������������������������������������
;������������������������������������������������������������������������Ŀ
; Magma ripples

	START_PATH	dr_ripples
	P_SPRITE	0,24
	P_COLLISIONS	OFF
	P_SETCOLANIM	3
	P_SET		worldy,-80
	P_GROUNDOBJ	ON

	P_SETRANDOM	pbyte1,3
	P_ADD		tx,pbyte1
;	P_RANGECHECK	OFF

	P_SETRANDOM	pbyte1,15
	P_ADD		pbyte1,-8
	P_ADD		worldx,pbyte1
	P_SETRANDOM	pbyte1,15
	P_ADD		pbyte1,-8
	P_ADD		worldz,pbyte1

	P_WAIT		1
	P_REMOVE

;����������������������������������������������������������������

	ENDC

;������������������������������������������������������������������������Ŀ
; send trees of flame up towards the player

	START_PATH	dr_firtree
;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_SPRITE	0
	P_SETANIM	0
	P_RTRIGGER	.anim,ALWAYS
	P_ADD		worldy,-60
	P_WAIT		1
	P_IFBETWEEN	-1000,worldy,-500,.nomake
	P_QSPAWN	flame,dr_firtree,10,10
.nomake	P_WAIT		7
	P_REMOVE

.anim
	P_DEC		tx
	P_ADDANIM	1,4
	P_WITHINRADIUS	80,.setfire
	P_IGOTO		.dontsetfire
.setfire	P_PLRBURN	C
.dontsetfire	P_RETURN

;����������������������������������������������������������������

	IFEQ	1

;������������������������������������������������������������������������Ŀ
; this dragon tries to eat the player as he slides off the platform

	START_PATH	dr_dragon1
	P_SPAWN		0,50,-30,-deg90,0,0,dragon_1,dr_dragon1_neck,10,10,1
	P_CLIPPING	ON
	P_SET		rotz,0
	P_SET		hp,100
	P_SET		ap,boss_dragon_ap
	P_TRIGGER	.hit,WhenHit

	P_RADAROBJ	ra_enemy

	P_SET		oy,100
	P_SET		ox,worldx

	P_TRIGGER	.wibble,ALWAYS
.burstforth
	P_IFBETWEEN	-50,oy,0,.ok
	P_ADD		oy,-20
	P_GOTO		.burstforth

.ok
	P_TRIGGER	.fire,32	;eguchi change 16->32
	P_DO	90
	P_FACEPLAYER	Y
	P_INVINCIBLE	ON
	P_DISTMORE	550,.nofurther	;eguchi change 450->550
	P_IFARWING	.nofurther
	P_INVINCIBLE	OFF
	P_IFBETWEEN	-200,oy,-150,.ok2
	P_ADD		oy,-20
.ok2
.nofurther
	P_NEXT
	P_DO		20
	P_ADD		oy,20
	P_NEXT

	P_REMOVE

.hit
	P_GDEC		B,bosshp
	P_IMPORT	pbyte1,bosshp
	P_IFNOTZERO	pbyte1,.nofdie
	P_FORCE		.die
	P_RETURN
.nofdie
	P_IFBETWEEN	85,hp,100,.nosinkyet
	P_FORCE		.sink
.nosinkyet
	P_RETURN
.die
;;;;eguchi write
	P_TRIGGER	.fire,OFF
;;;;eguchi end
	P_TRIGGER	.hit,OFF
	P_TRIGGER	.explode,4

	P_WAIT		20
;;;;eguchi write
	P_GOSUB		boss_exp_screen_flash
;;;;eguchi write end
	
	P_GDEC		B,KEnemyNumber

;;;;eguchi write
	P_SCORE		1000
	P_CIRCLEWINDOW	1,big
;;;;eguchi write end
	P_EXPLODE

.sink
	P_TRIGGER	.hit,OFF

;eguchi coment	P_TRIGGER	.explode,4

	P_DO		20
	P_ADD		oy,20
	P_NEXT

	P_REMOVE

.explode	LOCAL
	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,10,32
	P_BECOME
	  P_SETRANDOM	pbyte1,64
	  P_ADD		pbyte1,-32
	  P_ADD		worldx,pbyte1
	  P_SETRANDOM	pbyte1,64
	  P_ADD		pbyte1,-32
	  P_ADD		worldy,pbyte1
	  P_SETRANDOM	pbyte1,64
	  P_ADD		pbyte1,-32
	  P_ADD		worldz,pbyte1
	P_UNBECOME
	P_RETURN
; --- Wibble the movement ---
.wibble
	P_SET	worldy,oy
	P_INDEX	pbyte1,sintab,pbyte2
	P_ADD	pbyte2,17
	P_DIV2	pbyte1
	P_DIV2	pbyte1
	P_DIV2	pbyte1
	P_ADD	worldy,pbyte1

	P_QSPAWN	msplash,dr_ripples,10,10
	P_RETURN

; --- fire unrelentlessly at the player ---
.fire
	P_IFNOTBETWEEN	-200,worldy,-150,.nofire
	P_WEAPON	eplasma1
	P_PUSH		rotx
	P_PUSH		roty
	P_PUSH		rotz
	P_FACEPLAYER	IMMEDIATE
	P_FIRE
	P_PULL		rotz
	P_PULL		roty
	P_PULL		rotx
.nofire	P_RETURN

; --- Path for neck piece ---
	START_PATH	dr_dragon1_neck
	P_CLIPPING	ON
	P_INVINCIBLE	ON
	P_END


;����������������������������������������������������������������


	ENDC

;------------------- 

;;------------------- START BOSS CRUSHER ----------------------
;
;CRUSHERBOSSSTART
;
;	P_BOSSMODELIST	Crusher
;	P_BOSSMODE	cb_fly
;	P_BOSSMODE	cb_spinfaster,cbm_loop
;	P_BOSSMODE	cb_risehigh
;	P_BOSSMODE	cb_towards
;	P_BOSSMODE	cb_change
;	P_BOSSMODE	cb_swiftly
;	P_BOSSMODE	cb_changeback
;	P_BOSSMODE	cb_towards
;	P_BOSSMODE	cb_gotospin
;	P_BOSSMODE	preturn
;
;--------- FLAGS ----------
	P_BOSSFLAGLIST
	P_BOSSFLAG	compactmode
	P_BOSSFLAG	preparefire
	P_BOSSFLAG	finishfire
	P_BOSSFLAG	bossdead

;;-------------------
;; Child definitions:

cb_child_deflector1	equ	1
cb_child_deflector2	equ	2
cb_child_deflector3	equ	3

cb_child_cannon1	equ	4
cb_child_cannon2	equ	5
cb_child_cannon3	equ	6
cb_child_cannon4	equ	7
cb_child_cannon5	equ	8
cb_child_cannon6	equ	9

cb_child_bottom	equ	10
cb_child_top		equ	11
;
;cb_child_buildup	equ	12
;
;
;;----------------------------------------------------------
;cb_change
;	p_do	32
;	  p_becomechild	cb_child_deflector1
;	    p_add	childrotz,-2
;	  p_unbecome
;	  p_becomechild	cb_child_deflector2
;	    p_add	childrotz,-2
;	  p_unbecome
;	  p_becomechild	cb_child_deflector3
;	    p_add	childrotz,-2
;	  p_unbecome
;	p_next
;	P_NEXTBOSSMODE
;	P_RETURN
;;----------------------------------------------------------
;cb_swiftly
;	P_SETRANDOM	skidy,32
;	P_ADD		skidy,-16
;	P_DO	80
;	  P_PUSH	roty
;	  P_PUSH	rotx
;	  P_FACEPLAYER	IMMEDIATE
;	  P_SET		rotx,0
;	  P_ADD		roty,deg180
;	  P_ADD		roty,skidy
;	  P_SETVEL	120
;	  P_PULL	rotx
;	  P_PULL	roty
;	  P_ADD	roty,4
;	  P_IFBETWEEN	-8192,worldy,-512,.incit
;	  P_IFNOTBETWEEN 512,worldy,8192,.nodec
;	  P_ADD		worldy,-25
;	  P_IGOTO	.nodec
;.incit	  P_ADD		worldy,25
;.nodec
;;	  P_INC		skidy
;	  
;	P_NEXT
;	P_NEXTBOSSMODE
;	P_RETURN
;;----------------------------------------------------------
;cb_changeback
;	p_do	32
;	  p_becomechild	cb_child_deflector1
;	    p_add	childrotz,2
;	  p_unbecome
;	  p_becomechild	cb_child_deflector2
;	    p_add	childrotz,2
;	  p_unbecome
;	  p_becomechild	cb_child_deflector3
;	    p_add	childrotz,2
;	  p_unbecome
;	p_next
;	P_NEXTBOSSMODE
;	P_RETURN
;;----------------------------------------------------------
;
;cb_fly
;	P_RELTOPLAYER	ON
;	P_WAIT		100
;	P_NEXTBOSSMODE
;	P_RETURN
;
;;----------------------------------------------------------
;cb_spinfaster
;;	P_DO		30
;;	P_ADD		roty,2
;;	P_NEXT
;	P_DO		30
;	P_ADD		roty,4
;	P_NEXT
;	P_NEXTBOSSMODE
;	P_RETURN
;
;;----------------------------------------------------------
;cb_gotospin
;	P_SETBOSSMODE	cbm_loop
;	P_RETURN
;;----------------------------------------------------------
;cb_risehigh
;	P_DO		50
;	P_ADD		worldy,-60
;	P_NEXT
;	P_NEXTBOSSMODE
;	P_RETURN
;
;;----------------------------------------------------------
;cb_lower
;	P_DO		50
;	P_ADD		worldy,60
;	P_NEXT
;	P_NEXTBOSSMODE
;	P_RETURN
;;----------------------------------------------------------
;cb_towards
;	P_PUSH		roty
;	P_PUSH		rotx
;	P_PUSH		rotz
;	P_FACEPLAYER	IMMEDIATE
;	P_SET		rotx,0
;	P_SET		rotz,0
;	P_SETVEL	60
;	P_PULL		rotz
;	P_PULL		rotx
;	P_PULL		roty
;
;	P_WAIT		60
;	P_SETVEL	0
;
;	P_NEXTBOSSMODE
;	P_RETURN
;
;
;----------------------------------------------------------

	START_PATH	BOSS_Crusher

	P_CLRBOSSFLAGS

	P_SPAWN		0,0,0,0,43,0,spin_1,C_top,10,10,cb_child_top
	P_SPAWN		0,40<<spin_scale,0,0,0,0,spin_2,C_bottom,10,10,cb_child_bottom


	P_SPAWN		0,20<<spin_scale,60<<spin_scale,0,deg180,0,spin_0,C_deflector,10,10,cb_child_deflector1
	P_SPAWN		52<<spin_scale,20<<spin_scale,-30<<spin_scale,0,deg180-deg120,0,spin_0,C_deflector,10,10,cb_child_deflector2
	P_SPAWN		-52<<spin_scale,20<<spin_scale,-30<<spin_scale,0,deg180+deg120,0,spin_0,C_deflector,10,10,cb_child_deflector3

	P_TRIGGER	marker_set,Always
	P_TRIGGER	.dead_ck,4
	P_TRIGGER	.shield_rot,64
	P_TRIGGER	.base_rot,Always
	P_TRIGGER	.hp_meter,ALways
	P_TRIGGER	.far_come,Always
	P_RADAROBJ	ra_enemy
	P_GSET		b,especialhp1,boss_crusher_meter_hp
	P_SETBOSSNAME	name_Crusher
	P_GSET		b,bossmaxhp,boss_crusher_meter_hp
	P_GSET		b,bosshp,boss_crusher_meter_hp
	P_INVISIBLE	ON

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_crusher
.main_lp
	P_IFSAME	childrotx,-1,.only_tb
	P_GOSUB		.cannon_fire
	P_IMPORT	pbyte1,gbyte1
	P_ADD		pbyte1,50
	P_DO		pbyte1
	P_PUSH		worldx
	P_PUSH		worldz
	P_MOVEINPLAYER	100
	P_PULL		worldz
	P_PULL		worldx
	P_NEXT
.miss
	P_GOSUB		.missile_fire
	P_WAIT		30
.dash
	P_GOSUB		.dash_move
	P_GOTO		.main_lp
.only_tb
	P_RANDOMGOTO	.miss2
	P_RANDOMGOTO	.atack
	P_IGOTO		.dash
.miss2
	P_WAIT		35
	P_GOSUB		.missile_fire
	P_WAIT		35
	P_GOTO		.main_lp
.atack
	P_SET		pbyte2,8
	P_GOSUB		.rot_shield1
.cl
	P_MOVEINPLAYER	50
	P_ADD		roty,-12
	P_DISTLESS	1000,.ce
	P_GOTO		.cl
.ce
	P_DO		32
	P_ADD		roty,-12
	P_NEXT
	P_SET		pbyte2,-8
	P_GOSUB		.rot_shield2
	P_WAIT		30
	P_GOTO		.main_lp
.far_come
	P_DISTLESS	12000,.d_ok
	P_IMPORT	pword1,Player1_worldx
	P_CHASE		worldx,pword1
	P_CHASE		worldx,pword1
	P_IMPORT	pword1,Player1_worldz
	P_CHASE		worldz,pword1
	P_CHASE		worldz,pword1
.d_ok
	P_RETURN
.dash_move
	P_SET		pbyte2,8
	P_GOSUB		.rot_shield1
	P_SET		skidy,2
	P_SET		pword1,2000
	P_RANDOMGOTO	.neg_skid
	P_NEG		skidy
.neg_skid
	P_RANDOMGOTO	.go_far
	P_NEG		pword1
.go_far
	P_PUSH		worldy
	P_IMPORT	worldy,player1_worldy
	P_CHASE		worldy,pword1
	P_CIRCLEPLAYER	skidy
	P_MOVEINPLAYER	-80
	P_ADD		roty,-12
	P_PULL		worldy
	P_DISTMORE	5000,.at_far
	P_GOTO		.go_far
.at_far
	P_DO		64
	P_ADD		roty,-12
	P_CHASE		worldy,pword1
	P_CIRCLEPLAYER	skidy
	P_NEXT
	P_NEG		pbyte2
	P_GOSUB		.rot_shield2
	P_RETURN
.rot_shield1
	P_DO		8
	P_SET		pbyte1,cb_child_deflector1
	P_DO		3
	P_EXPORT	gbyte1,pbyte2
	P_BECOMECHILD	pbyte1
	P_GADD		childrotz,gbyte1
	P_SET		shape,spin_0yoko
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT
	P_NEXT
	P_SOUNDEFTDISTPOS	crusher_shield	;$8e*
	P_RETURN
.rot_shield2
	P_DO		8
	P_SET		pbyte1,cb_child_deflector1
	P_DO		3
	P_EXPORT	gbyte1,pbyte2
	P_BECOMECHILD	pbyte1
	P_GADD		childrotz,gbyte1
	P_SET		shape,spin_0
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT
	P_NEXT
	P_SOUNDEFTDISTPOS	crusher_shield	;$8e*
	P_RETURN
.hp_meter
	P_IMPORT	pbyte1,especialhp1
	P_IFNOTBETWEEN	0,pbyte1,41,.hp_zero
	P_EXPORT	bosshp,pbyte1
	P_RETURN
.hp_zero
	P_GSET		b,bosshp,0
	P_RETURN
.missile_fire
	P_PUSH		worldy
	P_PUSH		roty
	P_ADD		worldy,20<<spin_scale
	P_FACEPLAYER	IMMEDIATE
	P_QSPAWN	dokuro,c_plasma,1,4
	P_ADD		roty,48
	P_DO		4
	P_QSPAWN	dokuro,c_plasma,1,4
	P_ADD		roty,-32
	P_INEXT
	P_PULL		roty
	P_PULL		worldy
	P_ZERO		rotx
	P_RETURN
.cannon_fire
	P_GSET		b,gbyte1,0
	P_SET		pbyte1,cb_child_cannon1
	P_DO		6
	P_BECOMECHILD	pbyte1
	P_IMPORT	pbyte2,gbyte1
	P_ADD		pbyte2,10
	P_EXPORT	gbyte1,pbyte2
	P_SET		pbyte2,1
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT
	P_RETURN
.base_rot
	P_DEC		roty
	P_RETURN
.shield_rot
	P_TRIGGER	.s_rot,Always,10
	P_RETURN
.s_rot
	P_SET		pbyte1,cb_child_bottom
	P_DO		2
	P_BECOMECHILD	pbyte1
	P_ADD		childroty,-6
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT
	P_ADD		roty,6
	P_RETURN
.dead_ck
	P_SET		pbyte1,6
	P_IFSMALLER	slopenum,pbyte1,.life_ok
	P_SET		childrotx,-1
	P_TRIGGER	.dead_ck,OFF
	P_TRIGGER	.dead_ck2,4
	P_SET		pbyte1,cb_child_bottom
	P_DO		2
	P_BECOMECHILD	pbyte1
	P_SET		pbyte2,1
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT
.life_ok
	P_RETURN
.dead_ck2
	P_ZERO		pbyte1
	P_IMPORT	slopenum,especialhp1
	P_IFLARGER	slopenum,pbyte1,.life_ok
	P_GSET		b,especialhp1,0
	P_TRIGGER	.dead_ck2,OFF
	P_FORCE		.dead_on
	P_RETURN
.dead_on
	P_SETBOSSFLAG	bossdead,ON
	P_ADD		worldy,20<<spin_scale
	P_QSPAWN	nullshape,e_runner_damy,10,10
	P_ADD		worldy,-20<<spin_scale
	P_GDEC		B,KEnemyNumber
	P_GSET		b,bossmaxhp,0
	P_WAIT		20
	P_SOUNDEFTPOS	bs_bossexplode2
	P_EXPLODE
;----------
	START_PATH	C_deflector

	P_RADAROBJ	ra_enemy
	P_INVINCIBLE	ON
	P_TRIGGER	reflect_laser,Always
.loop
	P_IFBOSSFLAG	bossdead,ON,.expl
	P_GOTO		.loop
	P_END
.expl
	P_MOVEIN	-80
	P_ADD		childrotx,deg5
	P_GOTO		.expl
;----------
	START_PATH	c_top

	P_SPAWN		0,0,-25<<spin_scale,0,0,0,spin_3,C_topcannon,1,10,cb_child_cannon1
	P_SPAWN		22<<spin_scale,0,12<<spin_scale,0,deg120,0,spin_3,C_topcannon,3,10,cb_child_cannon2
	P_SPAWN		-22<<spin_scale,0,12<<spin_scale,0,-deg120,0,spin_3,C_topcannon,5,10,cb_child_cannon3

	P_INVINCIBLE	ON
	P_IGOTO		pc_bottom.enter
	P_END
;----------
	START_PATH	c_bottom

	P_SET		hp,100
	P_SPAWN		0,0<<spin_scale,-25<<spin_scale,0,0,0,spin_4,C_botcannon,2,10,cb_child_cannon4
	P_SPAWN		22<<spin_scale,0<<spin_scale,12<<spin_scale,0,deg120,0,spin_4,C_botcannon,4,10,cb_child_cannon5
	P_SPAWN		-22<<spin_scale,0<<spin_scale,12<<spin_scale,0,-deg120,0,spin_4,C_botcannon,6,10,cb_child_cannon6

	P_INVINCIBLE	ON
	P_ZERO		pbyte2
.enter	LOCAL
	P_IFSAME	pbyte2,1,.act
	P_GOTO		.enter
.act
	P_INVINCIBLE	OFF
	P_TRIGGER	.hit,WhenHitByPlayer
	P_SET		coltab,id_1_c&WM
.lp
	P_SET		hp,100
	P_GOTO		.lp
.hit
	P_GDEC		b,especialhp1
	P_RETURN
;----------
	START_PATH	c_topcannon
	START_PATH	c_botcannon

	P_SET		slopenum,hp
	P_SET		hp,100
	P_SET		skidy,boss_crusher_cannon_hp
	P_SET		ap,boss_crusher_cannon_ap
	P_WEAPON	EPlasma1
	P_TRIGGER	.cannon_dead,WhenDead
	P_TRIGGER	.cannon_hit,WhenHitByPLayer
.lp
	P_IFSAME	pbyte2,1,.fire_on
	P_GOTO		.lp
.cannon_hit
	P_DEC		skidy
	P_GDEC		b,especialhp1
	P_IFBETWEEN	0,skidy,127,.h_ok
	P_TRIGGER	all,OFF
	P_GOSUB		.cannon_dead
	P_FORCE		.exp
.h_ok
	P_RETURN
.exp
	P_EXPLODE
.fire_on
	P_ZERO		pbyte2
	P_DO		slopenum
	P_WAIT		10
	P_NEXT
	P_GOSUB		sos_fire_must
	P_GOTO		.lp
.cannon_dead
	P_BECOMEMOTHER
	P_INC		slopenum
	P_UNBECOME
	P_RETURN
;---------
	START_PATH	c_plasma

	P_QUADVECS	ON
	P_SOUNDEFFECT	en_missileshoot_s
	P_SOUND		p2_ironball
	P_SET		ap,boss_crusher_cplasma_ap
	P_SET		hp,1
	P_SETVEL	50
	P_ALWAYSGENVECS	ON
	P_HITFLASH	OFF
	P_SPRITE	0,8
	P_RTRIGGER	.hit,WhenHit

	P_WAIT		6
	P_RTRIGGER	.home,ALWAYS
.flp
	P_DISTLESS	1000,.remove
	P_GOTO		.flp
.remove
	P_TRIGGER	.home,OFF
	P_WAIT		20
	P_EXPLODE

.hit	P_FORCE	.remove
	P_RETURN

.home
	P_IFBOSSFLAG	bossdead,OFF,.con
	P_FORCE		.remove
	P_RETURN
.con
	P_DISTLESS	10000,.nfc
	P_FACEPLAYER	y
	P_RETURN
.nfc
	P_FACEPLAYER
	P_RETURN

;
;	P_SET		hp,boss_crusher_body_hp
;	P_SET		ap,boss_crusher_body_ap
;
;	P_SETBOSSNAME	name_Crusher
;	P_SET		pbyte1,boss_crusher_body_hp+boss_crusher_cannon_hp*6
;	P_EXPORT	bossmaxhp,pbyte1
;	P_EXPORT	bosshp,pbyte1
;
;
;	P_ZERO		pbyte2
;
;	P_RADAROBJ	ra_enemy
;
;; player no mae hajimaru
;
;	P_START65816
;	ldy	pathplayer&WM
;	a16
;	lda.w	al_worldx,y
;	clc
;	adc	#0
;	sta	al_worldx,x
;	lda.w	al_worldz,y
;	clc
;	adc	#1200
;	sta	al_worldz,x
;	P_END65816
;
;	P_SET	worldy,400
;
;	P_SOUND	p2_crusher
;
;; clear some vital flags
;
;	P_CLRBOSSFLAGS
;	P_SETBOSSMODE	start
;	
;	P_SET		shape,nullshape
;
;	P_INVISIBLE	ON
;
;; make some vital body parts
;
;	P_SPAWN		0,0,0,0,0,0,spin_1,C_top,10,10,cb_child_top
;	P_SPAWN		0,40<<spin_scale,0,0,0,0,spin_2,C_bottom,10,10,cb_child_bottom
;
;
;	P_SPAWN		0,20<<spin_scale,60<<spin_scale,0,deg180,0,spin_0,C_deflector,10,10,cb_child_deflector1
;	P_SPAWN		52<<spin_scale,20<<spin_scale,-30<<spin_scale,0,deg180-deg120,0,spin_0,C_deflector,10,10,cb_child_deflector2
;	P_SPAWN		-52<<spin_scale,20<<spin_scale,-30<<spin_scale,0,deg180+deg120,0,spin_0,C_deflector,10,10,cb_child_deflector3
;
;	P_RTRIGGER	.mainloop,ALWAYS
;
;.again
;	P_GOSUB	.setbossmode
;	P_GOTO	.again
;
;.setbossmode
;	P_JUMPBOSSMODE
;
;;-------- Main loop ----------
;.mainloop
;	P_SETMARKER	1
;	P_ADD		roty,deg5
;
;	P_IFBOSSFLAG	preparefire,OFF,.nodo
;	P_IFBOSSFLAG	finishfire,ON,.finishfire
;
;	P_BECOMECHILD	cb_child_bottom
;	  P_CHASE	childy,40<<spin_scale
;	  P_CHASE	childy,40<<spin_scale
;	  P_EXPORT	bword1,childy
;	P_UNBECOME
;	P_IMPORT	childy,bword1
;	P_IFNOTSAME	childy,40<<spin_scale,.nodo
;	P_SETBOSSFLAG	finishfire,ON
;
;	P_PUSH		roty
;	P_QSPAWN	missile,c_plasma,10,10
;	P_ADD		roty,deg120
;	P_QSPAWN	missile,c_plasma,10,10
;	P_ADD		roty,deg120
;	P_QSPAWN	missile,c_plasma,10,10
;	P_PULL		roty
;	P_IGOTO		.nodo
;
;.finishfire
;	P_BECOMECHILD	cb_child_bottom
;	  P_CHASE	childy,20<<spin_scale
;	  P_CHASE	childy,20<<spin_scale
;	  P_EXPORT	bword1,childy
;	P_UNBECOME
;	P_IMPORT	childy,bword1
;	P_IFNOTSAME	childy,20<<spin_scale,.nodo
;	P_SETBOSSFLAG	finishfire,preparefire,OFF
;
;.nodo
;
;	P_IFBETWEEN	6,pbyte2,9,.zembushinda
;	P_IFSAME	pbyte2,6,.alldead
;
;	P_RETURN
;
;.zembushinda
;	P_FORCE		.shindeshimatta
;	P_RETURN
;
;.shindeshimatta
;	P_SETBOSSFLAG	bossdead,ON
;	P_SCORE		500
;	P_QSPAWN	nullshape,e_runner_damy,10,10
;	P_TRIGGER	.mainloop,OFF
;	P_DO		25
;	P_ADD		roty,1
;	P_NEXT
;	P_GDEC		B,KEnemyNumber
;
;	P_SOUNDEFTPOS	bs_bossexplode2
;	P_EXPLODE
;.alldead
;	P_IFBOSSFLAG	compactmode,ON,.faster
;
;	P_IFSAME	pbyte1,30,.topbot
;	P_INC		pbyte1
;
;	P_BECOMECHILD	cb_child_deflector1
;	  P_GOSUB	.movout
;	P_UNBECOME
;	P_BECOMECHILD	cb_child_deflector2
;	  P_GOSUB	.movout
;	P_UNBECOME
;	P_BECOMECHILD	cb_child_deflector3
;	  P_GOSUB	.movout
;	P_UNBECOME
;
;	P_RETURN
;
;.topbot
;	P_BECOMECHILD	cb_child_bottom
;	  P_ADD		childy,-8
;	  P_EXPORT	bword1,childy
;	P_UNBECOME
;	P_IMPORT	childy,bword1
;	P_IFSAME	childy,20<<spin_scale,.setflag
;	P_RETURN
;.setflag
;	P_SETBOSSFLAG	compactmode,ON
;	P_RETURN
;.movout
;	P_MOVEIN	-12
;	P_CHASE		childy,10<<spin_scale
;	P_CHASE		childy,10<<spin_scale
;	P_RETURN
;.faster
;	P_ADD		roty,deg5
;	P_RETURN
;
;; --- die ---
;.die
;	P_EXPLODE
;
;
;;--------------- C_DEFLECTOR ----------------
;
;	START_PATH	C_deflector
;	P_RADAROBJ	ra_enemy
;;	P_RANGECHECK	OFF
;	P_SHADOW	OFF
;	P_SET		hp,boss_crusher_deflector_hp
;	P_SET		ap,boss_crusher_deflector_ap
;	P_INVINCIBLE	ON
;
;.loop
;	P_REBOUNDLASER
;	P_IFBOSSFLAG	bossdead,ON,.expl
;	P_GOTO		.loop
;.expl
;	P_MOVEIN	-80
;	P_ADD		childrotx,deg5
;	P_GOTO		.expl
;
;;--------------- C_TOPCANNON ----------------
;
;	START_PATH	C_topcannon
;	P_RADAROBJ	ra_enemy
;	P_RTRIGGER	c_cannonfire,64
;	P_RTRIGGER	c_cannondead,WhenDead
;C_cannon
;;	P_RANGECHECK	OFF
;	P_SHADOW	OFF
;	P_SET		hp,boss_crusher_cannon_hp
;	P_SET		ap,boss_crusher_cannon_ap
;.loop
;	P_GOTO		.loop
;
;
;;--------------- C_BOTCANNON ----------------
;
;	START_PATH	C_botcannon
;	P_RADAROBJ	ra_enemy
;	P_RTRIGGER	c_cannonfire,64
;	P_RTRIGGER	c_cannondead,WhenDead
;	P_IGOTO		C_cannon
;
;;--------------- C_BOTTOM ----------------
;
;	START_PATH	c_bottom
;
;;	P_SET		coltab,id_1_c&WM
;	P_SETCOLANIM	3
;
;	P_SPAWN		0,0<<spin_scale,-25<<spin_scale,0,0,0,spin_4,C_botcannon,10,10,cb_child_cannon4
;	P_SPAWN		22<<spin_scale,0<<spin_scale,12<<spin_scale,0,deg120,0,spin_4,C_botcannon,10,10,cb_child_cannon5
;	P_SPAWN		-22<<spin_scale,0<<spin_scale,12<<spin_scale,0,-deg120,0,spin_4,C_botcannon,10,10,cb_child_cannon6
;	
;;	P_RANGECHECK	OFF
;	P_SHADOW	OFF
;	P_SET		hp,boss_crusher_body_hp
;	P_SET		ap,boss_crusher_body_ap
;
;	P_SET		pbyte2,hp
;	P_RTRIGGER	pc_top.sethp,WhenHit
;
;	P_RTRIGGER	c_cannondead,WhenDead
;	P_RTRIGGER	c_topchk,8
;.remake	P_INVINCIBLE	ON
;
;.loop
;	P_ADD		childroty,-deg5	;-2
;	P_GOTO		.loop
;
;;--------------- C_TOP ----------------
;
;	START_PATH	c_top
;
;	P_SETCOLANIM	3
;;	P_RANGECHECK	OFF
;	P_SHADOW	OFF
;	P_SET		hp,boss_crusher_body_hp
;	P_SET		ap,boss_crusher_body_ap
;	P_SET		pbyte2,hp
;	P_RTRIGGER	.sethp,WhenHit
;	P_INVINCIBLE	ON
;
;	P_SPAWN		0,0,-25<<spin_scale,0,0,0,spin_3,C_topcannon,10,10,cb_child_cannon1
;	P_SPAWN		22<<spin_scale,0,12<<spin_scale,0,deg120,0,spin_3,C_topcannon,10,10,cb_child_cannon2
;	P_SPAWN		-22<<spin_scale,0,12<<spin_scale,0,-deg120,0,spin_3,C_topcannon,10,10,cb_child_cannon3
;
;	P_RTRIGGER	c_cannondead,WhenDead
;	P_RTRIGGER	c_topchk,8
;
;.loop
;	P_ADD		childroty,-deg5	;2
;	P_GOTO		.loop
;
;.sethp	LOCAL
;	P_NEG	pbyte2
;	P_ADD	pbyte2,hp
;	P_GADD	bosshp,pbyte2
;
;	P_SET	pbyte2,hp
;	P_RETURN
;
;
;
; --- The cannon shoots its load ---
;
;C_cannonfire
;	P_RANDOMGOTO	.dontdoit
;	P_RANDOMGOTO	.dontdoit
;	P_ADD		roty,deg180
;	P_SET		pbyte1,rotx
;	P_IFBETWEEN	cb_child_cannon1-1,sbyte1,cb_child_cannon3+1,.chigau_kakudo
;	P_ADD		rotx,deg45+deg22
;	P_IGOTO		.skip
;.chigau_kakudo
;	P_ADD		rotx,-deg45-deg22
;.skip
;	P_SPAWN		0,0,0,0,0,0,missile,c_buildup,10,10,cb_child_buildup
;;	P_QSPAWN	missile,c_plasma,10,10
;	P_SET		rotx,pbyte1
;	P_ADD		roty,deg180
;.dontdoit
;	P_RETURN
;
;; --- The cannon is no more ---
;
;c_cannondead
;	P_SET	pbyte2,-boss_crusher_cannon_hp
;	P_GADD	bosshp,pbyte2
;	P_BECOMEMOTHER
;	  P_INC	pbyte2
;	P_UNBECOME
;	P_RETURN
;
;c_topchk
;	P_IFBOSSFLAG	compactmode,ON,.chgcol
;	P_RETURN
;.chgcol
;	P_ANDFRAMEGOTO	63,.nomissiles
;	P_SETBOSSFLAG	preparefire,ON
;.nomissiles
;	P_ANDFRAMEGOTO	15,.onecol
;	P_SET		coltab,id_0_c&wm
;	P_RETURN
;.onecol	P_SET		coltab,id_1_c&wm
;	P_INVINCIBLE	OFF
;	P_SET		colframe,0
;	P_RETURN
;
;
;;--------------- C_BUILDUP ----------------
;
;	START_PATH	c_buildup
;;	P_RANGECHECK	OFF
;	P_COLLISIONS	OFF
;	P_SPRITE	0
;	P_SET		shape,bossball
;
;	P_DO		20
;	P_ADD		tx,4
;	P_NEXT
;
;	P_QSPAWN	missile,c_plasma,10,10
;	P_WAIT		2
;	P_QSPAWN	missile,c_plasma,10,10
;;	P_WAIT		2
;;	P_QSPAWN	missile,c_plasma,10,10
;	P_REMOVE
;
;
;;-------------------------------------------------
;
;	START_PATH	c_plasma
;;	P_RANGECHECK	OFF
;	P_QUADVECS	ON
;	P_RADAROBJ	ra_enemy
;	P_SOUND		p2_ironball
;	P_SET		ap,boss_crusher_cplasma_ap
;	P_SET		hp,1
;	P_SETVEL	60
;	P_ALWAYSGENVECS	ON
;	P_HITFLASH	OFF
;	P_SPRITE	0,16
;	P_SET		shape,bossball
;	P_SET		coltab,dokuro_c&WM
;;	P_RTRIGGER	.smoketrail,ALWAYS
;	P_RTRIGGER	.hit,WhenHit
;
;	P_WAIT		10
;	P_RTRIGGER	.home,ALWAYS
;	P_WAIT		15
;	P_TRIGGER	.home,OFF
;	P_RTRIGGER	.home,2
;;	P_TRIGGER	.smoketrail,OFF
;	P_WAIT		15
;	P_TRIGGER	.home,OFF
;	P_WAIT		15
;.remove
;	P_REMOVE
;;	P_EXPLODE
;.hit	P_FORCE	.remove
;	P_RETURN
;
;.home
;	P_FACEPLAYER
;	P_IFBOSSFLAG	bossdead,OFF,.con
;	P_FORCE		.remove
;.con	P_RETURN

	IFEQ	1
.smoketrail
	P_SPAWN		0,0,-50,0,0,0,boost,c_plasmaboost,10,10
	P_RETURN

	START_PATH	c_plasmaboost
	P_SPRITE	0
	P_SET		tx,24
	P_SETCOLANIM	0
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF

	P_WAIT	1
	P_DO	6
	P_ADDANIM	1,8
	P_ADD	tx,-3
	P_NEXT
	P_REMOVE
	
	ENDC

;----------------------------------------------------------------
;;;;	printf	"Crusher length = ",*-CRUSHERBOSSSTART,"%n"
;----------------------------------------------------------------














;------------------- START BOSS PIERROT ----------------------

PIERROTBOSSSTART

	IFEQ	1

	P_BOSSMODELIST	Pierrot
	P_BOSSMODE	preturn
	P_BOSSMODE	pi_spitbox,pim_spitagain
	P_BOSSMODE	pi_waitloop
	P_BOSSMODE	pi_deathsequence,pim_deathsequence
	P_BOSSMODE	preturn


;--------- FLAGS ----------
	P_BOSSFLAGLIST
	P_BOSSFLAG	pf_makeball
	P_BOSSFLAG	pf_ballfinished
	P_BOSSFLAG	pf_lefthit
	P_BOSSFLAG	pf_righthit
	P_BOSSFLAG	pf_secondstage
	P_BOSSFLAG	pf_risehead
	P_BOSSFLAG	pf_spitbox
	P_BOSSFLAG	pf_spitting
	P_BOSSFLAG	pf_magichands
	P_BOSSFLAG	pf_gogogo
	P_BOSSFLAG	pf_dying

;-------------------
; Child definitions:

pi_child_lefthand	equ	1
pi_child_righthand	equ	2
pi_child_head	equ	3
pi_child_ball	equ	4



; --- PI_WAITLOOP ---

pi_waitloop
	P_WAIT	20
	P_SETBOSSMODE	pim_spitagain
	P_RETURN

; --- PI_SPITBOX ---

pi_spitbox
	P_SETBOSSFLAG	pf_spitbox,ON

	P_NEXTBOSSMODE
	P_RETURN

	ENDC

;----------------------------------------------------------
	START_PATH	BOSS_Pierrot

	IFEQ	1

;	P_RANGECHECK	OFF

	P_SET		hp,100
	P_SET		ap,10

	P_INVISIBLE	ON

;	P_RELTOPLAYER	ON

	P_SHADOW	OFF

; player no mae hajimaru

	P_START65816
	ldy	pathplayer&WM
	a16
	lda.w	al_worldx,y
	clc
	adc	#0
	sta	al_worldx,x
	lda.w	al_worldz,y
	clc
	adc	#1200
	sta	al_worldz,x
	P_END65816

	P_SET	worldy,-128

; clear some vital flags

	P_SET		pword1,0
	P_EXPORT	bossflags,pword1
	P_SET		pbyte1,0
	P_EXPORT	bossmode,pbyte1

	P_SET		pbyte1,boss_pierrot_hands_hp
	P_EXPORT	bosshp,pbyte1
	P_EXPORT	bossmaxhp,pbyte1

;	P_SETBOSSNAME	<The Hands>


; make some vital body parts

	P_SPAWN		-1000,0,0,0,0,0,hand_r,pi_hand_r,10,10,pi_child_righthand
	P_SPAWN		1000,0,0,0,0,0,hand_l,pi_hand_l,10,10,pi_child_lefthand

; .. and set up some player bits and pieces:

	P_PLRTURN	OFF
	P_PLRFORCETURN	0,1024
	P_FORCETRANSFORM ROBOT
	P_PLRTRANSLOCK

	P_TRIGGER	pi_mainloop,ALWAYS
;	P_TRIGGER	.hitstuff,WhenHit

.again
	P_GOSUB	pi_setbossmode

	P_GOTO	.again

;��������* MAIN LOOP *������������������������������������������������
pi_mainloop
	P_ZDISTLESS	boss_pierrot_max_z,.nochase
	P_START65816
	ldy	pathplayer&WM
	a16
	lda.w	al_worldz,y
	clc
	adc	#boss_pierrot_max_z
	sta	bword1
	P_END65816
	P_IMPORT	pword1,bword1
	P_CHASE		worldz,pword1
.nochase

	P_ZDISTMORE	boss_pierrot_min_z,.nochase2
	P_START65816
	ldy	pathplayer&WM
	a16
	lda.w	al_worldz,y
	clc
	adc	#boss_pierrot_min_z
	sta	bword1
	P_END65816
	P_IMPORT	pword1,bword1
	P_CHASE		worldz,pword1
.nochase2


	P_IFBOSSFLAG	pf_gogogo,OFF,.nocheckyet
	P_IMPORT	pbyte1,bossHP
	P_IFSAME	pbyte1,0,pi_diesequence
.nocheckyet

	P_IFBOSSFLAG	pf_makeball,OFF,.dontmakeball
	P_SETBOSSFLAG	pf_makeball,OFF
	P_CHILDDEAD	pi_child_ball,.makeit
	P_IGOTO		.dontmakeball
.makeit

	P_SPAWN		0,-100,-70,0,0,0,bossball,pi_ball,10,10,pi_child_ball

.dontmakeball

	P_IFBOSSFLAG	pf_risehead,OFF,.dontmakehead
	P_SETBOSSFLAG	pf_risehead,OFF
	P_CHILDDEAD	pi_child_head,.makeit2
	P_IGOTO		.dontmakehead
.makeit2
;	P_SPAWN		0,400,200,0,0,0,pierrot,pi_head,10,10,pi_child_head

	P_SET		pbyte2,110
.dontmakehead
	P_IFSAME	pbyte2,0,.nosmoke

	P_ADD		worldy,50
	P_GOSUB		pi_dosmoke
	P_ADD		worldy,-50
	P_DEC		pbyte2
.nosmoke
	


	P_RETURN

;------------------------------
; Call Pierrot's mode routine:

pi_setbossmode
 	P_JUMPBOSSMODE


; --- Death sequence ---

pi_diesequence
	P_SETBOSSMODE	pim_deathsequence
	P_RETURN

; --- Die die die ---

pi_deathsequence
	P_SETBOSSFLAG	pf_magichands,pf_dying,ON

	P_TRIGGER	pi_mainloop,OFF

	P_SET		pbyte1,deg5

	P_DO		50
	  P_BECOMECHILD	pi_child_head
	    P_CHASE	childrotx,0
	    P_CHASE	childrotx,0
	    P_CHASE	childrotx,0
	  P_UNBECOME
	  P_ADD		rotz,pbyte1
	  P_ADD		worldz,50
	  P_ADD		worldy,-30
	  P_ADD		pbyte1,2
	P_NEXT

;	P_CLEARSEQUENCE
	P_GDEC		B,KEnemyNumber
	P_EXPLODE


;���������������������������������������������������������������Ŀ
;�---------------------- PI_HEAD --------------------------------�

	START_PATH	pi_head

	P_INVINCIBLE	ON
;	P_RANGECHECK	OFF
	P_INVISIBLE	ON

	P_WAIT		10

	P_START65816
	kbgm		fadeout
	P_END65816
	
	P_INVISIBLE	OFF
	P_CLIPPING	ON

	P_SETANIM	0
	P_SET		depthoffset,4

.nxtup	P_WAIT		1
	P_ADD	childy,-6
	P_IFBETWEEN	-30,childy,1000,.nxtup

	P_DO		3
	P_DEC		depthoffset
	P_WAIT		5
	P_NEXT

	P_CLIPPING	OFF

	P_FLAGCHILD	pi_child_lefthand
	P_FLAGCHILD	pi_child_righthand

;	P_SETBOSSNAME	<Pierrot>
	P_SET		pbyte1,boss_pierrot_head_hp
	P_EXPORT	bossHP,pbyte1
	P_EXPORT	bossmaxHP,pbyte1

	P_SOUNDEFFECT	bs_pierrot_voice

	P_START65816
	kbgm		boss
	P_END65816

	P_SETBOSSFLAG	pf_gogogo,ON

	P_DO		10
	P_ADD		childz,-20
	P_NEXT


	P_WAIT	5
	P_BECOMEMOTHER
	  P_NEXTBOSSMODE
	P_UNBECOME

.check
	P_IFBOSSFLAG	pf_spitting,ON,.nospit
	P_IFBOSSFLAG	pf_spitbox,OFF,.nospit
	P_SETBOSSFLAG	pf_spitbox,OFF

	P_QSPAWN	arrowbox,pi_arrowbox,10,10

	P_SETBOSSFLAG	pf_magichands,ON

.nospit
	P_IFFLAG	.spinhead
	P_GOTO		.check

.spinhead

	P_SOUNDEFFECT	bs_pierrot_damage
	P_DO		deg360/deg45
	  P_ADD		childrotx,deg45
	  P_IMPORT	pbyte1,bossHP
	  P_ADD		pbyte1,-boss_pierrot_head_hp/4/(deg360/deg45)
	  P_EXPORT	bossHP,pbyte1
	P_NEXT

	P_GOTO		.check

;���������������������������������������������������������������Ŀ
;�---------------------- PI_ARROWBOXHIT--------------------------�


	START_PATH	PI_ARROWBOXHIT
	P_INVINCIBLE	ON
	P_INVISIBLE	ON
	P_COLLISIONS	ON
	P_SET		ap,4
	P_END

; --- start pierrot animating ---
pi_startanim
;	P_FINDSHAPE	pierrot
	P_BECOMESHAPE
	  P_SET	animframe,0
	P_UNBECOME
	P_RETURN

pi_stopanim
;	P_FINDSHAPE	pierrot
	P_BECOMESHAPE
	  P_SETANIM	0
	P_UNBECOME
	P_RETURN

;���������������������������������������������������������������Ŀ
;�---------------------- PI_ARROWBOX-----------------------------�

	START_PATH	pi_arrowbox

	P_RELTOPLAYER	ON
	P_TRIGGER	.deadcheck,ALWAYS
;	P_RANGECHECK	OFF

	P_SPAWN		0,0,10<<arrowbox_scale,0,0,0,arrowboxHIT,pi_arrowboxhit,10,10,1

	P_ADD		worldy,100
	P_ADD		worldz,-100

	P_SETBOSSFLAG	pf_spitting,ON

	P_TRIGGER	pi_createglitter,ALWAYS

	P_GOSUB		pi_startanim

	P_INVISIBLE	ON
	P_WAIT		20
	P_INVISIBLE	OFF

	P_INVINCIBLE	ON
	P_SLOPE		ON
	P_MOVEPLAYER	ON
	P_SHADOW	OFF
	P_COLLISIONS	OFF

	P_SOUNDEFFECT	bs_pierrot_voice

	P_WAIT		10

	P_TRIGGER	pi_createglitter,OFF

	P_SET		slopenum,1
	P_SET		roty,deg180
	P_TRIGGER	.on,WhenSteppedOn

	P_SETBOSSFLAG	pf_magichands,OFF

	P_GOSUB		pi_stopanim

	P_SOUNDEFFECT	bs_pierrot_breath

	P_SETVEL	30
.lp
	P_DO		1200/30
	P_ZDISTMORE	150,.noslowdown
	P_SETVEL	15
.noslowdown
	P_IFBETWEEN	-1,worldy,100,.reset
	P_ADD		worldy,10
	P_IGOTO		.noreset
.reset	P_SET		worldy,0
.noreset	P_NEXT

; --- sink into the ground ---

	P_TRIGGER	.on,OFF
	P_SLOPE		OFF
	P_CLIPPING	ON
	P_DO	20
	  P_ADD	rotx,2
	  P_ADD	worldy,5
	P_NEXT
	P_SETBOSSFLAG	pf_spitting,OFF
	P_REMOVE

.on	P_FORCE	.spin
	P_RETURN

; --- spin around and begin aiming ---

.spin
	P_RELTOPLAYER	OFF
	P_TRIGGER	.on,OFF
	P_SETVEL	0
	P_GOSUB		pi_startanim

	P_WAIT		5

	P_MOVEPLAYER	OFF
	P_DO	deg180/deg22
	  P_ADD	roty,deg22
	P_NEXT

	P_MOVEPLAYER	ON

	P_TRIGGER	.orirumade,ALWAYS

	P_SET		pbyte2,5
.loop
	P_DO	10
	  P_ADD	roty,2
	P_NEXT
	P_WAIT	1
	P_DO	20
	  P_ADD	roty,-2
	P_NEXT
	P_WAIT	1
	P_DO	10
	  P_ADD	roty,2
	P_NEXT
	P_GOTO	.loop
.orirumade
	P_IFSAME	pbyte2,0,.okcheckit
	P_DEC		pbyte2
	P_IGOTO		.mada
.okcheckit
	P_START65816
	ldy	pathplayer&WM

	s_jmp_NOTalsflag	y,ontheground,.switch
	a16
	txa
	cmp	al_slopeptr,y
	beq	.normal
.switch	a16
	P_SWITCHOUT	.forceit
.normal	P_END65816
.mada	P_RETURN
.forceit	P_FORCE		.fire
	P_RETURN

.fire
	P_TRIGGER	.orirumade,OFF
	P_SETVEL	80

	P_DO	20
	  P_ADD	worldy,-10

	  P_FINDSHAPE	hand_l
	  P_SHAPEINRADIUS	150,.hit

	  P_FINDSHAPE	hand_r
	  P_SHAPEINRADIUS	150,.hit

;	  P_FINDSHAPE	pierrot
	  P_SHAPEINRADIUS	180,.hit
	  P_IGOTO	.nothit
.hit
	  P_FLAGSHAPE
	  P_BREAK	.die
.nothit
	P_NEXT
.die
	P_GOSUB		pi_stopanim
	P_SETBOSSFLAG	pf_spitting,OFF
	P_EXPLODE


; --- Check to see if boss has died ---
.deadcheck
	P_IFBOSSFLAG	pf_dying,OFF,preturn
	P_FORCE		.die
	P_RETURN


;���������������������������������������������������������������Ŀ
;�---------------------- PI_HAND_R ------------------------------�

	START_PATH	pi_hand_r

	P_SET		childroty,-deg90
	P_SET		hp,100

	P_SETANIM	0

	P_TRIGGER	pi_righthandhit,WhenHit
	P_TRIGGER	pi_rightanim,ALWAYS

	P_GOSUB		pi_foreplay1
.again
	P_DO	1
	  P_WAIT		50
	  P_GOSUB		pi_tefire
	P_NEXT

	P_WAIT		10
	P_GOSUB		pi_tefire

	P_GOSUB		pi_makeball

	P_GOTO		.again

;���������������������������������������������������������������Ŀ
;�---------------------- PI_HAND_L ------------------------------�

	START_PATH	pi_hand_l

	P_SET		childroty,deg90
	P_SET		hp,100

	P_SETANIM	0

	P_TRIGGER	pi_lefthandhit,WhenHit
	P_TRIGGER	pi_leftanim,ALWAYS

	P_GOSUB		pi_foreplay1

.again
	P_WAIT		10
	P_GOSUB		pi_tefire

	P_DO		1
	  P_WAIT		50
	  P_GOSUB		pi_tefire
	P_NEXT

	P_GOSUB		pi_makeball

	P_GOTO		.again


;��������������������������������������������������������������
pi_leftanim
	P_GOSUB		pi_hpcheck
	P_IFBOSSFLAG	pf_lefthit,ON,pi_outstretch
	P_IGOTO		pi_animatehand

pi_hpcheck
	P_IMPORT	tx,bosshp
	P_IFNOTSAME	tx,0,.dontforce
	P_SETBOSSFLAG	pf_secondstage,ON
	P_FORCE		pi_nextstage
.dontforce	P_RETURN

pi_rightanim
	P_GOSUB		pi_hpcheck
	P_IFBOSSFLAG	pf_righthit,ON,pi_outstretch
pi_animatehand
	P_ADDANIM	1,15
pi_resetcnt
	P_RETURN

pi_outstretch
	P_SETANIM	15
	P_HITFLASHTRIG
	P_GINC		B,bbyte1
	P_IMPORT	tx,bbyte1
	P_IFNOTBETWEEN	8,tx,100,.ok
	P_IFSAME	shape,hand_r,.rightoff
	P_SETBOSSFLAG	pf_lefthit,OFF
	P_IGOTO		.dd
.rightoff	P_SETBOSSFLAG	pf_righthit,OFF
.dd	P_INVINCIBLE	OFF
	P_IGOTO		pi_resetcnt
.ok
	P_RETURN

pi_lefthandhit
	P_SET		hp,100
	P_SETBOSSFLAG	pf_lefthit,ON
	P_GDEC		B,bosshp
	P_SET		tx,0
	P_EXPORT	bbyte1,tx
	P_INVINCIBLE	ON
	P_RETURN

pi_righthandhit
	P_SET		hp,100
	P_GDEC		B,bosshp
	P_SETBOSSFLAG	pf_righthit,ON
	P_SET		tx,0
	P_EXPORT	bbyte1,tx
	P_INVINCIBLE	ON
	P_RETURN

;��������������������������������������������������������������


;****** walk the hands in from the side and then raise them

pi_foreplay1
;	P_RANGECHECK	OFF
	P_SHADOW	OFF
	P_INVINCIBLE	ON

	P_SETVEL	10
	P_SET		childrotx,deg90

	P_WAIT		970/10
	P_SETVEL	0
	P_DO		15
	P_CHASE		childroty,deg180
	P_CHASE		childrotx,0
	P_NEXT

	P_SET		pbyte1,12
	P_IFCHILD	pi_child_lefthand,.noneg
	P_NEG		pbyte1
.noneg

	P_INVINCIBLE	OFF

	P_DO	4
	  P_DO	3
	    P_ADD	childrotz,pbyte1
	  P_NEXT
	  P_WAIT	1
	  P_NEG		pbyte1
	  P_DO  6
	    P_ADD	childrotz,pbyte1
	  P_NEXT
	  P_WAIT	1
	  P_NEG		pbyte1
	  P_DO	3
	    P_ADD	childrotz,pbyte1
	  P_NEXT
	P_NEXT

	P_RETURN


;*********** Fire plasma's from the fingertips ***********

pi_tefire
	P_INVINCIBLE	ON

	P_DO	6
	  P_ADD	childrotx,8
	P_NEXT

	P_SET	animframe,0
	P_DO	12
	  P_ADD	childroty,2
	  P_WAIT 1
	  P_ADD	childroty,-2
	P_NEXT

	P_PUSH	roty

	P_ADD	roty,-deg45
	P_ADD	rotx,-deg90

	P_ADD	worldy,80

	P_DO	5
	  P_WEAPON	eplasma1
	  P_FIRE
	  P_BECOME
	    P_SET	rotx,0
;	    P_SET	shape,smallenemyball
	    P_SET	tx,8
	    P_FACEPLAYER	Y
	    P_FACEPLAYER	Y
	    P_FACEPLAYER	Y
	    P_FACEPLAYER	Y
	    P_FACEPLAYER	Y
	    P_SETVEL	40
	    P_SOUND	port2_stop
	  P_UNBECOME
	  P_ADD	roty,deg90/5
	P_INEXT

	P_ADD	worldy,-80
	P_ADD	rotx,deg90
	P_PULL	roty

	P_DO	6
	  P_ADD	childrotx,-8
	P_NEXT

	P_INVINCIBLE	OFF
	P_RETURN

;************ Make a ball of magic ************

pi_makeball
	P_SETBOSSFLAG	pf_ballfinished,OFF

; --- Move in together ---

.lp
	P_WAIT	1
	P_FACESHAPE
	P_FACESHAPE
	P_ADJUSTROT
	P_MOVEIN	20
	P_SHAPEDISTMORE	100,.lp

	P_ADD	childrotx,deg11

	P_SETBOSSFLAG	pf_makeball,ON

	P_SET	pbyte1,-4

	P_IFCHILD	pi_child_lefthand,.noneg
	P_NEG	pbyte1
.noneg

	P_INVINCIBLE	ON
; --- Rub the hands up and down ---

	P_DO	10
	  P_DO	3
	    P_ADD childy,pbyte1
	  P_NEXT
	  P_WAIT 1
	  P_NEG pbyte1
	  P_DO	3
	    P_ADD childy,pbyte1
	  P_NEXT
	P_NEXT

; --- Move outwards quickly ---

.moveout
	P_WAIT		1
	P_MOVEIN	-80

	P_CHASE		childrotx,-deg45

	P_SHAPEDISTLESS	400,.moveout

	P_INVINCIBLE	OFF

; --- all finished so now wait for the ball to finish throwing itself ---

.chkflag
	P_IFBOSSFLAG	pf_ballfinished,ON,.exit
	P_GOTO		.chkflag
.exit
	P_WAIT		5

; --- reset the hands' positions facing forwards ---

	P_DO	15
	  P_SHAPEDISTLESS	300,.nomore
	  P_MOVEIN	20
.nomore
	  P_CHASE	childrotx,deg22
	  P_CHASE	childrotx,deg22
	  P_CHASE	childroty,deg180
	P_NEXT

	P_RETURN


;----------------------- PI_BALL -------------------------------
	START_PATH	PI_BALL

;	P_RANGECHECK	OFF
	P_INVINCIBLE	ON
	P_INVISIBLE	ON
	P_SPRITE	0,-15
	P_SET		ap,4


	P_TRIGGER	.nxtstagechk,ALWAYS

	P_WAIT	15
	P_INVISIBLE	OFF

; --- Zoom up the size of the sprite ---

	P_DO	40
	  P_INC	tx
	P_NEXT

	P_WAIT	10

; --- And Zoom it back down quickly ----

	P_DO	5
	  P_ADD	tx,-5
	P_NEXT

	P_SOUND		p2_pierrot_beamball

; --- Change into a plasma ball ---

	P_SET	coltab,enemybomb_c
	P_SPRITE	0

; --- create a glittering trail ---

	P_TRIGGER	pi_createglitter,2

; --- Vibrate with an unseen energy ---

	P_DO	10
	  P_ADD	childy,-10
	  P_WAIT	1
	  P_ADD	childy,10
	P_NEXT

; --- Zoom upwards ---

	P_DO	10
	  P_ADD	childy,-120
	P_NEXT

	P_WAIT	5

; --- Which hand is it going to land in ? ---

	P_RANDOMGOTO	.fromleft

; --- Land in the right hand ---

	P_BECOMECHILD	pi_child_righthand
	  P_EXPORT	bword1,childx
	P_UNBECOME

	P_IMPORT	childx,bword1

	P_DO	10
	  P_ADD childy,120
	P_NEXT

	P_WAIT	5

	P_IGOTO		.beginfromright

; --- Land in the left hand ---

.fromleft
	P_BECOMECHILD	pi_child_lefthand
	  P_EXPORT	bword1,childx
	P_UNBECOME

	P_IMPORT	childx,bword1

	P_DO	10
	  P_ADD childy,120
	P_NEXT


	P_WAIT	5

.backforth

; --- left hand prepares to throw ---

	P_DO	5
	  P_ADD	childx,5
	  P_BECOMECHILD pi_child_lefthand
	    P_ADD childrotx,-2
	  P_UNBECOME
	  P_BECOMECHILD pi_child_righthand
	    P_CHASE childrotx,-deg45
	  P_UNBECOME
	P_NEXT

	P_RANDOMGOTO	.dontthrow1
	P_RANDOMGOTO	.throwfromleft
.dontthrow1

	P_WAIT	5

; --- left hand throws ---

	P_SOUNDEFTPOS	bs_throw

	P_DO	10
	  P_ADD childx,-80
	  P_BECOMECHILD pi_child_lefthand
	    P_CHASE childrotx,deg45
	    P_CHASE childrotx,deg45
	  P_UNBECOME
	P_NEXT
	P_WAIT	1
	P_DO	3
	  P_ADD	childx,-80
	  P_BECOMECHILD pi_child_lefthand
	    P_CHASE childrotx,-deg45
	  P_UNBECOME
	P_NEXT

	P_WAIT	1

.beginfromright

; --- right hand prepares to throw ---

	P_DO	5
	  P_ADD	childx,-5
	  P_BECOMECHILD pi_child_righthand
	    P_ADD childrotx,-2
	  P_UNBECOME
	  P_BECOMECHILD pi_child_lefthand
	    P_CHASE childrotx,-deg45
	  P_UNBECOME
	P_NEXT

	P_RANDOMGOTO	.dontthrow2
	P_RANDOMGOTO	.throwfromright
.dontthrow2

	P_WAIT	5

; --- right hand throws ---

	P_SOUNDEFTPOS	bs_throw
	P_DO	10
	  P_ADD childx,80
	  P_BECOMECHILD pi_child_righthand
	    P_CHASE childrotx,deg45
	    P_CHASE childrotx,deg45
	  P_UNBECOME
	P_NEXT
	P_WAIT	1
	P_DO	3
	  P_ADD	childx,80
	  P_BECOMECHILD pi_child_righthand
	    P_CHASE childrotx,-deg45
	  P_UNBECOME
	P_NEXT

	P_GOTO	.backforth

; --- throw the ball at the player from the left hand ---

.throwfromleft

	P_SOUNDEFTPOS	bs_throw_last

	P_DO	10
	  P_BECOMECHILD pi_child_lefthand
	    P_FACEPLAYER	Y
	    P_FACEPLAYER	Y
	    P_ADJUSTROT
	  P_UNBECOME
	  P_ADD	childx,-6
	P_NEXT
	P_SET	pbyte1,pi_child_lefthand
.throwsame
	P_FACEPLAYER	IMMEDIATE
	P_ADJUSTROT
	P_SETVEL	60

	P_DO	8
	  P_BECOMECHILD pbyte1
	    P_CHASE childrotx,deg90
	    P_CHASE childrotx,deg90
	  P_UNBECOME
	P_NEXT

	P_SETBOSSFLAG	pf_ballfinished,ON

	P_UNLINKCHILD
	P_SETVEL	60

	P_WAIT		30
	P_REMOVE

; --- throw the ball at the player from the right hand ---

.throwfromright
	P_SOUNDEFTPOS	bs_throw_last

	P_DO	10
	  P_BECOMECHILD pi_child_righthand
	    P_FACEPLAYER	Y
	    P_FACEPLAYER	Y
	    P_ADJUSTROT
	  P_UNBECOME
	  P_ADD	childx,6
	P_NEXT

	P_SET	pbyte1,pi_child_righthand
	P_IGOTO	.throwsame



.nxtstagechk
	P_IFBOSSFLAG	pf_secondstage,OFF,.ret
	P_FORCE		.remove
.ret	P_RETURN
.remove
	P_TRIGGER	.nxtstagechk,OFF
	P_COLLISIONS	OFF
	P_DO	20
	P_ADD	tx,-4
	P_NEXT
	P_REMOVE


; --- Create a glittering trail

pi_createglitter
	P_QSPAWN	kirakira,pi_glitter,10,10
	P_BECOME
	  P_SETRANDOM	pbyte2,63
	  P_ADD		worldx,pbyte2
	  P_ADD		worldx,-32
	  P_SETRANDOM	pbyte2,63
	  P_ADD		worldy,pbyte2
	  P_ADD		worldy,-32
	P_UNBECOME
	P_RETURN

;----------------------- PI_GLITTER -------------------------------

	START_PATH	PI_GLITTER
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF

	P_SPRITE	0,40
.again
	P_WAIT	1
	P_ADD	tx,-4
	P_IFNOTSAME	tx,-32,.again
	P_REMOVE


; --- Create some smoke ---

pi_dosmoke
	P_QSPAWN		bossball,pi_smoke,10,10
	P_BECOME
	  P_SETRANDOM	pbyte2,63
	  P_ADD		worldx,pbyte2
	  P_ADD		worldx,-32
	  P_SETRANDOM	pbyte2
	  P_ADD		worldy,pbyte2
	  P_ADD		worldy,-128
	  P_ADD		worldy,50
;	  P_SETRANDOM	pbyte2
;	  P_ADD		worldz,pbyte2
	  P_SET		coltab,wallflash_C&WM
	P_UNBECOME
	P_RETURN


;----------------------- PI_SMOKE -------------------------------

	START_PATH	PI_SMOKE

;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_SPRITE	0

	P_SETRANDOM	tx,15
	P_ADD		tx,tx
	P_ADD		tx,-16

	P_DO		20
	P_ADD		tx,-4
	P_NEXT

	P_REMOVE


;��������������������������������������������������������������
pi_handanim
	P_ADDANIM	1,15
	P_RETURN
;��������������������������������������������������������������
; now to rub the head into existance

pi_nextstage
	P_INVINCIBLE	ON

	P_TRIGGER	pi_leftanim,OFF
	P_TRIGGER	pi_rightanim,OFF
	P_TRIGGER	pi_lefthandhit,OFF
	P_TRIGGER	pi_righthandhit,OFF
	P_TRIGGER	pi_handanim,ALWAYS

	P_DO	20
	P_SHAPEDISTMORE	120,.notfurther
	P_MOVEIN	-20
.notfurther
	P_SHAPEDISTLESS	150,.notcloser
	P_MOVEIN	20
.notcloser
	P_CHASE		childrotx,0
	P_ADD		childroty,deg22
	P_NEXT

	P_SET		pbyte1,deg90

	P_IFCHILD	pi_child_lefthand,.noneg
	P_NEG		pbyte1
.noneg

	P_DO	15
	P_CHASE		childroty,0
	P_CHASE		childroty,0

	P_CHASE		childrotz,pbyte1
	P_CHASE		childrotz,pbyte1
	P_NEXT

	P_SET		ty,0
	P_IFCHILD	pi_child_lefthand,.notr
	P_SET		ty,deg180
.notr
	P_TRIGGER	pi_vibrate,ALWAYS
	P_TRIGGER	pi_createglitter,4
	P_SETBOSSFLAG	pf_risehead,ON

.waitrise	P_IFFLAG	.con
	P_GOTO		.waitrise

.con
	P_WAIT		2
	P_TRIGGER	pi_vibrate,OFF

	P_SET		pbyte1,deg180-deg22
	P_IFCHILD	pi_child_lefthand,.nol
	P_NEG		pbyte1

.nol

	P_DO		20
	  P_SHAPEDISTMORE	400,.nofurther
	  P_MOVEIN	-50
.nofurther
	  P_CHASE	childrotz,deg0
	  P_CHASE	childrotx,-deg22
	  P_CHASE	childroty,pbyte1
	  P_CHASE	childy,0
	P_NEXT

	P_TRIGGER	pi_createglitter,OFF


.waittospit
	P_IFFLAG	.hit
	P_IFBOSSFLAG	pf_magichands,ON,.makespit
	P_GOTO		.waittospit
.makespit
	P_TRIGGER	pi_createglitter,4
	P_DO	30
	  P_CHASE	childrotx,deg90-deg22
	P_NEXT
	P_TRIGGER	pi_createglitter,OFF

.wait
	P_CHASE	childrotx,-deg22
	P_CHASE	childrotx,-deg22
	P_IFBOSSFLAG	pf_magichands,OFF,.waittospit
	P_GOTO		.wait

.hit

	P_SOUNDEFFECT	bs_pierrot_damage

	P_IMPORT	pbyte1,bossHP
	P_ADD		pbyte1,-boss_pierrot_head_hp/16
	P_EXPORT	bossHP,pbyte1

	P_ADD		childz,100
	P_ADD		childrotx,-deg45
	P_TRIGGER	pi_handanim,OFF
	P_SETANIM	15

	P_DO	8
	  P_HITFLASHTRIG
	P_NEXT

	P_TRIGGER	pi_handanim,ALWAYS
	
	P_ADD		childz,-100
	P_ADD		childrotx,deg45

	P_GOTO		.waittospit


; --- Vibrate the hands up and down ---

pi_vibrate
	P_INDEX		tx,sintab,ty
	P_SET		pword1,tx
	P_ADD		pword1,pword1
	P_CHASE		childy,pword1
	P_CHASE		childy,pword1
	P_ADD		ty,32
	P_IFSAME	ty,192,.do2
	P_IFNOTSAME	ty,64,.nodo1
.do2	P_SOUNDEFFECT	bs_hand_move
.nodo1

	ENDC

	P_RETURN





	printf	"Pierrot length = ",*-PIERROTBOSSSTART,"%n"

;------------------- END BOSS PIERROT ----------------------------









;** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **








;------------------- START BOSS KING DODORA ----------------------

DODORABOSSSTART

	P_BOSSMODELIST	KingDodora
;	P_BOSSMODE	kd_flyingin
;	P_BOSSMODE	kd_waitfar

	P_BOSSMODE	kd_landing,kdm_land


	P_BOSSMODE	kd_3d,kdm_3d
;	P_BOSSMODE	kd_3d
	P_BOSSMODE	kd_jump
;	P_BOSSMODE	kd_3dfly
;	P_BOSSMODE	kd_startstrafe2
;	P_BOSSMODE	kd_3dfly
;	P_BOSSMODE	kd_stopstrafe2
	P_BOSSMODE	kd_3dfly
	P_BOSSMODE	kd_startstrafe2
	P_BOSSMODE	kd_3dfly
	P_BOSSMODE	kd_stopstrafe2
	P_BOSSMODE	kd_runaway
	P_BOSSMODE	kd_looptoland
	P_BOSSMODE	preturn

	IFEQ	1

; --- the following is for the 2d version ---

;---- Loop #1
	P_BOSSMODE	kd_blowfireballs,kdm_loop
	P_BOSSMODE	kd_strafe
	P_BOSSMODE	kd_hpcheck
	P_BOSSMODE	kd_strafe
	P_BOSSMODE	kd_waitfirebreath
	P_BOSSMODE	kd_blowfireballs

	P_BOSSMODE	kd_hpcheck

	P_BOSSMODE	kd_eyeplayer
	P_BOSSMODE	kd_waitandfire
	P_BOSSMODE	kd_hpcheck
	P_BOSSMODE	kd_eyeplayer
	P_BOSSMODE	kd_waitandfire

	P_BOSSMODE	kd_waitfirebreath

	P_BOSSMODE	kd_hpcheck

	P_BOSSMODE	kd_goto_loop
;----

;---- Loop #2
	P_BOSSMODE	kd_landing,kdm_landing

	P_BOSSMODE	kd_eyeplayer
	P_BOSSMODE	kd_eyeplayer
	P_BOSSMODE	kd_waitandfire
	P_BOSSMODE	kd_eyeplayer
	P_BOSSMODE	kd_waitandfire
	P_BOSSMODE	kd_waitfirebreath

	P_BOSSMODE	kd_blowfireballs
	P_BOSSMODE	kd_strafe
	P_BOSSMODE	kd_eyeplayer

	P_BOSSMODE	kd_waitfirebreath

	P_BOSSMODE	kd_jump,kdm_jump
	P_BOSSMODE	kd_waitbehindplayer
	P_BOSSMODE	kd_turnaway
	P_BOSSMODE	kd_waitfar

	P_BOSSMODE	kd_startstrafe2
	P_BOSSMODE	kd_turntowards
	P_BOSSMODE	kd_waitbehindplayer
	P_BOSSMODE	kd_stopstrafe2
	P_BOSSMODE	kd_turnaway
	P_BOSSMODE	kd_waitfar

	P_BOSSMODE	kd_goto_landing
;----

;	P_BOSSMODE	preturn
;	P_BOSSMODE	kd_buryhead
;	P_BOSSMODE	kd_waitchikaku

;	P_BOSSMODE	kd_hiteffect,kdm_hiteffect


	ENDC

;--------- FLAGS ----------

	P_BOSSFLAGLIST
	P_BOSSFLAG	walking
	P_BOSSFLAG	sitting
	P_BOSSFLAG	firebreathing
	P_BOSSFLAG	flying
	P_BOSSFLAG	headburying
	P_BOSSFLAG	flapping
	P_BOSSFLAG	swinging
	P_BOSSFLAG	flyingin
	P_BOSSFLAG	gravity
	P_BOSSFLAG	eyeplayer
	P_BOSSFLAG	stopatdist
	P_BOSSFLAG	openmouth
	P_BOSSFLAG	backwards
	P_BOSSFLAG	hit
	P_BOSSFLAG	turning

;-------------------
; Child definitions:

kd_child_leftfoot	equ	1
kd_child_rightfoot	equ	2
kd_child_leftwing	equ	3
kd_child_rightwing	equ	4
kd_child_neck1	equ	5
kd_child_neck2	equ	6
kd_child_neck3	equ	7
kd_child_head	equ	8
kd_child_tail	equ	10
kd_child_firebreath	equ	20

;-------------------
; Various variables:

bd_breathlength	equ	40	; how many frames of 'orrible breath

bd_l		equ	35	; length of neck piece

bd_grav		equ	12	; gravity tsuyosa

bd_breathtiming	equ	10	; time between mouth opening and firebreath

;������������������������������������������
kd_looptoland
	P_SETBOSSMODE	kdm_land
	P_RETURN
;������������������������������������������
;**** Temp strategy for 3d dodora ****

kd_3dfly

	P_ACCEL		30,1
	P_DO	10
	P_FACEPLAYER	Y
	P_NEXT
	P_WAIT	50
	P_NEXTBOSSMODE
	P_RETURN

kd_runaway
	P_ACCEL		50,2
	P_WAIT		50
	P_NEXTBOSSMODE
	P_RETURN
;������������������������������������������
;**** Temp strategy for 3d dodora ****

kd_3d
	
;;;;	P_TRIGGER	.test,ALWAYS,10
;;;;	P_TRIGGER	.test2,ALWAYS,10
;;;;	P_WAIT		30
;;;;	P_IGOTO		kd_3d
;;;;.test
;;;;	P_SCORE		1
;;;;	P_TRIGGER	.test2,ALWAYS,5
;;;;	P_TRIGGER	.test,OFF
;;;;	P_RETURN
;;;;
;;;;.test2
;;;;	P_SCORE		100
;;;;	P_RETURN

	P_DO		2

	P_ACCEL		20,1

	P_DO		5
	P_ADD		roty,-2
	P_NEXT

;	P_FACEPLAYER	Y

;	P_DISTMORE	1000,.nochk
;	P_PLAYERINCONE	deg22,.doit
;	P_IGOTO		.nochk
;.doit
	P_SETBOSSFLAG	eyeplayer,ON
	P_WAIT		10
	P_SETBOSSFLAG	eyeplayer,OFF
	P_WAIT		3
	P_SETBOSSFLAG	firebreathing,ON
	P_WAIT		10
	P_DO		10
	  P_BECOMECHILD	kd_child_head
	    P_DEC	childrotx
	  P_UNBECOME
	P_NEXT
	P_WAIT		1
	P_DO		10
	  P_BECOMECHILD	kd_child_head
	    P_INC	childrotx
	  P_UNBECOME
	P_NEXT
.waitfin	P_WAIT	1
	P_IFBOSSFLAG	firebreathing,ON,.waitfin
	P_WAIT		20
.nochk

	P_NEXT

	P_NEXTBOSSMODE
	P_RETURN

;������������������������������������������
;**** Jump to loop label ****

	IFEQ	1
kd_goto_loop
	P_SETBOSSMODE	kdm_loop
	P_RETURN
	ENDC
;������������������������������������������
;**** Check boss's HP ****

	IFEQ		1
kd_hpcheck
	P_IMPORT	pbyte1,bosshp
	P_IFBETWEEN	0,pbyte1,boss_dodora_change_hp,.jumpit
	P_NEXTBOSSMODE
	P_RETURN
.jumpit
	P_SETBOSSMODE	kdm_jump
	P_RETURN

	ENDC
;������������������������������������������
;**** Start strafing (flyby-strafe)

kd_startstrafe2
	P_SET		pbyte1,127
	P_EXPORT	bbyte1,pbyte1
	P_RTRIGGER	kd_strafe2,ALWAYS
	P_SETBOSSFLAG	eyeplayer,OFF
	P_BECOMECHILD	kd_child_head
	P_SET		pword1,bd_breathtiming
	P_UNBECOME
	P_NEXTBOSSMODE
	P_RETURN
;������������������������������������������
;**** Fly-by Strafing ****

kd_strafe2
	P_SETBOSSFLAG	firebreathing,ON

;	P_IFNOTSAME	roty,deg180,.sotchi

	P_IMPORT	pbyte1,bbyte1
	P_ADD		pbyte1,-4
	P_EXPORT	bbyte1,pbyte1
	P_GDEC		B,bbyte1
	P_GDEC		B,bbyte1
	P_IFBETWEEN	0,pbyte1,127,.sotchi

	P_BECOMECHILD	kd_child_head
	P_SET		childrotx,-deg11
	P_CHASE		childroty,-deg45
	P_UNBECOME
	P_RETURN

.sotchi
	P_BECOMECHILD	kd_child_head
	P_SET		childrotx,-deg11
	P_CHASE		childroty,deg45
	P_UNBECOME
	P_RETURN
;������������������������������������������
;**** Stop strafing (flyby-strafe)

kd_stopstrafe2
	P_SETBOSSFLAG	firebreathing,OFF
	P_TRIGGER	kd_strafe2,OFF
	P_NEXTBOSSMODE
	P_RETURN
;������������������������������������������
;**** loop back to beginning ****

	IFEQ		1
kd_goto_landing
	P_ACCEL		0,2
	P_SETBOSSMODE	kdm_landing
	P_RETURN

;������������������������������������������
;**** turn the boss away from player ****

kd_turnaway
	P_IFSAME	roty,0,.oknextmode
	P_ADD		roty,4
	P_CHASE		rotz,16
	P_GOSUB		.chase
	P_GOTO		kd_turnaway
.oknextmode	P_IFSAME	rotz,0,.oknm2
	P_CHASE		rotz,0
	P_GOSUB		.chase
	P_GOTO		.oknextmode
.oknm2
	P_NEXTBOSSMODE
	P_RETURN

.chase
	P_SET		ox,worldx
	P_SET		oy,worldy
	P_SET		oz,worldz
	P_COPYPLAYERPOS
	P_CHASE		ox,worldx
	P_SET		worldx,ox
	P_SET		worldy,oy
	P_SET		worldz,oz
	P_RETURN
;������������������������������������������
;**** is boss far enough in front? ****

kd_waitfar
	P_IFSAME	roty,0,.nochg
	P_ADD		roty,deg22
	P_RETURN
.nochg
	P_ACCEL		40,2
	P_BEHINDPLAYER	.nocheck
	P_DISTMORE	1300,pnextbossmode
.nocheck	P_RETURN
	

;������������������������������������������
;**** turn the boss towards the player ****

kd_turntowards
	P_ACCEL		15,5
	P_IFSAME	roty,deg180,.oknextmode
	P_ADD		roty,4
	P_CHASE		rotz,-16
	P_GOTO		kd_turntowards
.oknextmode	P_IFSAME	rotz,0,.oknm2
	P_CHASE		rotz,0
	P_GOTO		.oknextmode
.oknm2
	P_NEXTBOSSMODE
	P_RETURN
;������������������������������������������
;**** wait for firebreath to finish ****

kd_waitfirebreath
	P_IFBOSSFLAG	firebreathing,ON,.nodo
	P_NEXTBOSSMODE
	P_WAIT		5
.nodo	P_RETURN
;������������������������������������������
;**** Wait until behind player ****

kd_waitbehindplayer
	P_ACCEL		25,1
	P_BEHINDPLAYER	pnextbossmode
	P_RETURN

	ENDC

;������������������������������������������
;**** Jump at player ****

kd_jump
	P_SETBOSSFLAG	stopatdist,eyeplayer,OFF
	P_SETBOSSFLAG	walking,gravity,ON
	P_GOSUB		kd_flapfaster
	P_ACCEL		0,5
	P_WAIT		10
	P_GOSUB		kd_flapevenfaster
	P_WAIT		10
	P_ACCEL		30,30
	P_WAIT		10

	P_WAIT		10

;	P_DO		10
;	P_DISTMORE	200,.norm
;	P_BREAK		.exit
;.norm
;	P_NEXT
;.exit

	P_ADD	pbyte2,-40
	P_WAIT		1
	P_ADD	pbyte2,-40
	P_WAIT		1
	P_ADD	pbyte2,-40
	P_WAIT		3
	P_SETBOSSFLAG	gravity,walking,OFF
	P_SETBOSSFLAG	flying,ON
	P_GOSUB		kd_flapslower
;	P_ROBOTCAMYOFS	-64
	P_NEXTBOSSMODE
	P_RETURN

;������������������������������������������
;**** Rear up when hit ****

kd_hiteffect
	P_IFBOSSFLAG	firebreathing,ON,.nodo
	P_SETBOSSFLAG	eyeplayer,ON
.nodo
	P_RESTOREBOSSMODE
	P_RETURN

;������������������������������������������
;**** Wait and then fire breathe ****

kd_waitandfire
	P_SETBOSSFLAG	eyeplayer,OFF
	P_SETBOSSFLAG	firebreathing,ON
	P_NEXTBOSSMODE
	P_RETURN
;������������������������������������������
;**** Eye the player ****

kd_eyeplayer
	P_WAIT		1
	P_IFBOSSFLAG	firebreathing,ON,kd_eyeplayer
	P_SETBOSSFLAG	eyeplayer,ON
	P_WAIT		10
	P_NEXTBOSSMODE
	P_RETURN

;������������������������������������������
;**** Strafe player ****

kd_strafe

	P_SETBOSSFLAG	eyeplayer,OFF

	P_BECOMECHILD	kd_child_head
	P_CHASE		childroty,deg45
	P_IFSAME	childroty,deg45,.finishedturning
	P_UNBECOME

	P_RETURN
.finishedturning
	P_UNBECOME
.strafe_em
	P_BECOMECHILD	kd_child_head
	P_IFNOTSAME	pword1,bd_breathtiming,.dontturnyet
	P_ADD		childroty,-2
	P_IFSAME	childroty,-deg45,.finishedstrafing
.dontturnyet	P_UNBECOME
	P_SETBOSSFLAG	firebreathing,ON
	P_GOTO	.strafe_em

.finishedstrafing
	P_UNBECOME
	P_NEXTBOSSMODE
	P_RETURN
;������������������������������������������
;**** Blow fire balls at player ****

	IFEQ	1

kd_blowfireballs
	P_SETBOSSFLAG	eyeplayer,ON
	P_DO	10
	P_RANDOMGOTO	.xit
	P_RANDOMGOTO	.xit

	P_SETBOSSFLAG	openmouth,ON
	P_WAIT		5

	P_BECOMECHILD	kd_child_head
	P_WEAPON	eplasma1
	P_FIRE
	P_UNBECOME
	P_BECOME	; become the weapon we just fired
	  P_SET		shape,plasma1
	  P_SET		coltab,enemybomb_c&WM
	P_UNBECOME
	

	P_SETBOSSFLAG	openmouth,OFF
	P_WAIT		15
.xit
	P_NEXT

	P_NEXTBOSSMODE
	P_RETURN

	ENDC

;������������������������������������������
;**** Boss turn and face walker ****

	IFEQ	1
kd_turnandface
	P_SETVEL	5

	P_RIGHTOFPLAYER	.loop
	P_INC		roty
.loop
	P_CHASE		roty,deg180
	P_CHASE		roty,deg180
	P_WAIT		1
	P_IFNOTSAME	roty,deg180,.loop
	P_SETBOSSFLAG	eyeplayer,ON
	P_NEXTBOSSMODE
	P_RETURN
	ENDC
;������������������������������������������
;**** Boss flying in demo ****

kd_flyingin
	P_CLRBOSSFLAGS
	P_SETBOSSFLAG	flying,flapping,ON
	P_ACCEL		20,10
	P_NEXTBOSSMODE
	P_RETURN

;������������������������������������������
;**** Far enough away? ****

kd_distcheck
	P_ADD		worldz,20
	P_BEHINDPLAYER	.nocheck
	P_DISTMORE	800,pnextbossmode
.nocheck
	P_RETURN

;������������������������������������������
; flap the wings EVEN faster:

kd_flapevenfaster
	P_BECOMECHILD	kd_child_leftwing
	  P_SET		pbyte2,3
	P_UNBECOME
	P_BECOMECHILD	kd_child_rightwing
	  P_SET		pbyte2,3
	P_UNBECOME
	P_RETURN
;������������������������������������������
; flap the wings faster:

kd_flapfaster
	P_BECOMECHILD	kd_child_leftwing
	  P_SET		pbyte2,2
	P_UNBECOME
	P_BECOMECHILD	kd_child_rightwing
	  P_SET		pbyte2,2
	P_UNBECOME
	P_RETURN
;������������������������������������������
; flap the wings slower:

kd_flapslower
	P_BECOMECHILD	kd_child_leftwing
	  P_SET		pbyte2,1
	P_UNBECOME
	P_BECOMECHILD	kd_child_rightwing
	  P_SET		pbyte2,1
	P_UNBECOME
	P_RETURN
;������������������������������������������
;**** Land the dinosaur down safely ****

kd_landing
	P_ACCEL		0,5
	P_CLRBOSSFLAGS
	P_SETBOSSFLAG	flapping,flying,ON

; rotate in the player's direction
;	P_RIGHTOFPLAYER	.ontheright
;	P_INC		roty
;.ontheright

	P_GOSUB		kd_flapfaster

; tilt upwards slightly

	P_DO		5
	  P_CHASE	rotx,-deg22
	  P_CHASE	rotx,-deg22
;	  P_CHASE		roty,deg180
	P_NEXT

	P_GOSUB		kd_flapevenfaster

; get the feet in a walking position

	P_SETBOSSFLAG	walking,ON
	P_DO		20
	  P_CHASE	rotx,-deg45
	  P_CHASE	rotx,-deg45
;	  P_CHASE	roty,deg180
	P_NEXT

; switch gravity on (ie. fall)

	P_SETBOSSFLAG	flying,OFF
	P_SETBOSSFLAG	gravity,ON
	P_DO		10
	  P_CHASE	rotx,0
	  P_CHASE	rotx,0
;	  P_CHASE	roty,deg180
	P_NEXT

	P_GOSUB		kd_flapslower

	P_SET		rotx,0
;.andonceagain
;	P_CHASE		roty,deg180
;	P_WAIT		1
;	P_IFNOTSAME	roty,deg180,.andonceagain

;	P_ROBOTCAMYOFS	-12

	P_SETBOSSFLAG	stopatdist,ON
	P_NEXTBOSSMODE
	P_RETURN

;������������������������������������������
;**** Bury the dinosaur's head ****

kd_buryhead
	P_CLRBOSSFLAGS
	P_SETBOSSFLAG	sitting,headburying,ON
pnextbossmode
	P_NEXTBOSSMODE
	P_RETURN

;������������������������������������������
;**** Wait until the player gets close ****

kd_waitchikaku
	P_DISTMORE	1000,preturn
	P_NEXTBOSSMODE
	P_RETURN
	

;������������������������������������������
;**** Walk the dinosaur ****

kd_walk
	P_SETBOSSFLAG	walking,ON
	P_SETBOSSFLAG	headburying,firebreathing,flying,sitting,OFF
	P_RETURN

;����������������������������������������������������������������Ŀ
;�         -------------- King Dodora, BOSS -------------         �
;������������������������������������������������������������������


	START_PATH	BOSS_Dodora

;	P_RANGECHECK	OFF
	P_RADAROBJ	ra_enemy

	P_SET		skidy,hp

	P_IMPORT	pword1,planetswitch
	P_IFSWITCH	skidy,pword1,.remit
	P_IGOTO		.norem
.remit	P_REMOVE
.norem

	P_SET		hp,100
	P_SET		ap,4

	P_ALWAYSGENVECS	ON

; player no ushiro kara hajimaru

;;	P_START65816
;;	ldy	pathplayer&WM
;;	a16
;;	lda.w	al_worldx,y
;;	clc
;;	adc	#40
;;	sta	al_worldx,x
;;	lda.w	al_worldz,y
;;	clc
;;	adc	#-1000
;;	sta	al_worldz,x
;;	P_END65816

; clear some vital flags

	P_GSET		W,bossflags,0
	P_GSET		B,bossmode,0
	P_EXPORT	bossmode,pbyte1

	P_SET		pbyte1,boss_dodora_hp
	P_EXPORT	bosshp,pbyte1
	P_EXPORT	bossmaxhp,pbyte1

	P_SETBOSSNAME	name_dodora


; make some vital body parts

	P_SPAWN		-25<<dodora_scale,45<<dodora_scale,-15<<dodora_scale,0,0,0,d_ashi_l,D_ashi_l,10,10,kd_child_leftfoot
	P_SPAWN		25<<dodora_scale,45<<dodora_scale,-15<<dodora_scale,0,0,0,d_ashi_r,D_ashi_r,10,10,kd_child_rightfoot

	P_SPAWN		17<<dodora_scale,-25<<dodora_scale,0,0,deg180,0,dodora_l,D_wing_l,10,10,kd_child_leftwing
	P_SPAWN		-17<<dodora_scale,-25<<dodora_scale,0,0,deg180,0,dodora_r,D_wing_r,10,10,kd_child_rightwing

	P_SPAWN		0,0,40<<dodora_scale,deg90,0,0,dodora_1,d_neck,10,10,kd_child_neck1

	P_SPAWN		0,10<<dodora_scale,-40<<dodora_scale,0,0,0,dodora_3,d_tail,10,10,kd_child_tail

	P_SHADOW	ON

;	P_PLRTURN	OFF
;;	P_PLRFORCETURN	0,512
;	P_FORCETRANSFORM ROBOT
;	P_PLRTRANSLOCK

	P_RTRIGGER	.mainloop,ALWAYS
	P_RTRIGGER	.hitstuff,WhenHit
	P_TRIGGER	radar_change,8

.again
	P_GOSUB	.setbossmode

	P_GOTO	.again


;------------------------------
; Call the dodora's mode routine:

.setbossmode
	P_JUMPBOSSMODE

;����������������������������������������������������
; the hit routine

.turnaround
	P_ADD		roty,deg5
	P_RETURN
.turningoff
	P_SETBOSSFLAG	turning,OFF
	P_RETURN

.hitstuff
	P_IFBOSSFLAG	hit,ON,.noturn
	P_IFBOSSFLAG	turning,ON,.noturn
	P_PLAYERINCONE	deg180-deg45,.noturn
	P_SETBOSSFLAG	turning,ON
	P_TRIGGER	.turningoff,Timer,40
	P_TRIGGER	.turnaround,ALWAYS,30
.noturn
	P_SOUNDEFFECT	bs_cry_2
	P_SET		hp,100

	P_GDEC		B,bosshp

	P_IMPORT	pbyte1,bosshp
	P_IFBETWEEN	-100,pbyte1,0,.explode

	P_SETBOSSFLAG	hit,ON
	P_INVINCIBLE	ON
	P_TRIGGER	.coldetbackon,Timer,5
	P_RETURN
.coldetbackon
	P_INVINCIBLE	OFF
	P_RETURN

.explode
	P_FORCE	.explode2
	P_RETURN
.explode2
	P_TRIGGER		.hitstuff,OFF
;	P_CLEARSEQUENCE

	P_WAIT		2

	P_SOUNDEFTPOS	bs_monster_down
	P_SOUNDEFTPOS	bs_bossexplode2


;;;;eguchi write
;;;;eguchi write end

;;	P_GDEC		B,KEnemyNumber
;;;;eguchi write
	P_SCORE		1000
	P_CIRCLEWINDOW	1,big
;;;;eguchi write end
	P_WAIT	10
	P_EXPORT	gbyte1,skidy
	P_QSPAWN	on_d,e_sw_base_sw_drop,100,4
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_EXPLODE

; --- initialise the turnquick trigger ---

.turnquick
	P_ADD	roty,2
	P_RETURN
;����������������������������������������������������
; the main loop (triggered)
.mainloop

	P_SETMARKER	1

	P_GOSUB		clippos

	P_ANDFRAMEGOTO	31,.chkclip
	P_IGOTO		.con342
.chkclip
; --- check to see if 'trying' to walk out of the predefined area ---

	P_IMPORT	tx,bclipflag
	P_IFZERO	tx,.con342
	P_TRIGGER	.turnquick,ALWAYS,30

.con342

	P_PLAYER	1
;	P_PLRFORCEWAY	0,512,7fffH

; ---- Check if collisions should be turned back on ----

	P_IFBOSSFLAG	hit,ON,.noreset
	P_IFZERO	rotx,.noneed
	P_CHASE		rotx,0
	P_CHASE		rotx,0
	P_CHASE		rotx,0
	P_IFNOTSAME	rotx,0,.norearing
.noneed
;	P_INVINCIBLE	OFF
	P_GOSUB		kd_flapslower
	P_IGOTO		.norearing
.noreset
	P_IFNOTSAME	rotx,-deg22,.noclrflag
	P_SETBOSSFLAG	hit,OFF
.noclrflag
	P_GOSUB		kd_flapevenfaster
	P_CHASE		rotx,-deg22
	P_CHASE		rotx,-deg22
	P_CHASE		rotx,-deg22
.norearing

;;; ---- Check for 'stop at distance' check ----
;;
;;	IFEQ	1
;;
;;	P_IFBOSSFLAG	stopatdist,OFF,.nostop
;;
;;	P_DISTMORE	boss_dodora_max_z,.walkagain
;;	P_DISTMORE	boss_dodora_stop_z,.nostop
;;	P_DISTMORE	boss_dodora_min_z,.stopwalk
;;
;;	P_SETBOSSFLAG	walking,backwards,ON
;;	P_ACCEL		-15,5
;;	P_IGOTO		.nostop
;;.stopwalk
;;	P_SETBOSSFLAG	walking,OFF
;;	P_ACCEL		0,2
;;	P_IGOTO		.nostop
;;.walkagain
;;	P_SETBOSSFLAG	walking,ON
;;	P_SETBOSSFLAG	backwards,OFF
;;	P_DISTLESS	1000,.slowspeed
;;	P_ACCEL		50,4
;;	P_IGOTO		.nostop
;;.slowspeed
;;	P_ACCEL		15,5
;;.nostop
;;	ENDC

; ---- Check for gravity:

	P_IFBOSSFLAG	gravity,OFF,.nograv

	P_ADD		pbyte2,bd_grav
	P_ADD		worldy,pbyte2

	P_NEG		pword1
	P_ADD		worldy,pword1

	P_IFNOTBETWEEN	0,worldy,2000,.notbelow
	P_DIV2		pbyte2
	P_DIV2		pbyte2
	P_IFBETWEEN	-4,pbyte2,4,.nosound
	P_SOUNDEFFECT	en_land_l
.nosound
	P_NEG		pbyte2
	P_SET		worldy,0
.notbelow
	P_NEG		pword1
	P_ADD		worldy,pword1
	P_IGOTO		.gravfin
.nograv
	P_CHASE		worldy,pword1
.gravfin

; ---- Check for flying

	P_IFBOSSFLAG	flying,OFF,.notflying

	P_SET		pword1,-300

	P_RETURN
.notflying

	P_RELTOPLAYER	OFF

; ---- Check for sitting

	P_IFBOSSFLAG	sitting,ON,.sitting

	P_SET		pword1,-140
	P_RETURN
.sitting

; ---- If none of the above

	P_SET		pword1,-40
	P_RETURN


;;.alwaysrot
;;	IFEQ	1
;;	P_START65816
;;	km_cmpkeydown	LEFT
;;	bne		.noleft
;;	inc	al_roty,x
;;.noleft
;;	km_cmpkeydown	RIGHT
;;	bne		.noright
;;	dec	al_roty,x
;;.noright
;;	P_END65816
;;	ENDC
;;	P_RETURN


;----------------------- D_FIREBREATH ------------------------------

	START_PATH	d_firebreath
	P_SOUND		p2_fire_breath
;	P_RANGECHECK	OFF
	P_CLIPPING	ON
	P_SHADOW	OFF
	P_COLLISIONS	OFF
	P_RTRIGGER	.fireground,always
	P_SET		pbyte1,bd_breathlength
.nxtfram
	P_IFBOSSFLAG	firebreathing,OFF,.forcerem
	P_ADD		ty,11
	P_DEC		pbyte1
	P_IFSAME	pbyte1,0,.exit
	P_GOTO		.nxtfram
.exit
	P_SETBOSSFLAG	firebreathing,OFF	; turn off the firebreathing flag
.forcerem
	P_SOUND		port2_stop
	P_REMOVE

.fireground
	P_START65816

;---------------------------------------------------------
; Find intersection with ground by firing a dummy particle
; until it hits the ground.
;---------------------------------------------------------

	ldy	dummyobj
	s_copy_pos	y,x
	s_copy_rots	y,x
	s_set_alvar		B,y,al_vel,#50
	phx
	tyx
	s_gen_3Dvecs	x,al_roty,al_rotx,al_vel
	plx
	ldy	dummyobj

	a8

	lda	#20
	sta	pathx1
.again	a8
	dec	pathx1
	beq	.nodo
	s_add_vecs2pos	y
	a16
	lda.w	al_worldy,y
	adc	#16
	bmi	.again

	lda.w	al_worldx,y
	sta	gword1
	lda.w	al_worldz,y
	sta	gword2

.nodo
	P_END65816
;---------------------------------------------------------
; Ok, now spawn the shape and copy the x and z
;---------------------------------------------------------
	P_QSPAWN	flame,d_flames,10,10
	P_BECOME
	  P_IMPORT	worldx,gword1
	  P_IMPORT	worldz,gword2
	  P_SET		worldy,-32
	  P_GOSUB	prandomizeposition
	P_UNBECOME
	P_RETURN


;----------------------- D_FLAMES -------------------------------

; FLAME sprite

	START_PATH	d_flames
;	P_RANGECHECK	OFF
	P_INVINCIBLE	ON
	P_SET		ap,1
	P_SPRITE	0
	P_SETCOLANIM	0

.loopit
	P_ANDFRAMEGOTO	1,.dontsetfire

	P_WITHINRADIUS	80,.setfire
	P_IGOTO		.dontsetfire
.setfire	P_PLRBURN	C
.dontsetfire
	P_ADDCOLANIM	1,4
	P_INC		pbyte1
	P_WAIT		1
	P_IFNOTSAME	pbyte1,3,.loopit

	P_REMOVE

;----------------------- D_TAIL --------------------------------

	START_PATH	d_tail
;	P_RANGECHECK	OFF
	P_INVINCIBLE	ON
	P_END


;----------------------- D_HEAD --------------------------------

	START_PATH	d_head
;	P_RANGECHECK	OFF
	P_SHADOW	ON
	P_INVINCIBLE	ON
	P_SETANIM	0
	P_SETCOLANIM	0

; main loop:

.loop

;;; head buried in sand time?
;;
;;	P_IFBOSSFLAG	headburying,OFF,.notburying
;;	P_CLIPPING	ON
;;	P_GOTO		.loop
;;.notburying	P_CLIPPING	OFF

; fried bananas on toast (with just a touch of sugar)

	P_IFBOSSFLAG	openmouth,ON,.openmouth
	P_IFBOSSFLAG	firebreathing,OFF,.closemouth
	P_ADDCOLANIM	1,8
	P_IFNOTSAME	colframe,128,.noset
	P_SETCOLANIM	5
.noset
	P_IFNOTSAME	pword1,1,.nosoundyet
	P_IFSAME	animframe,128+4,.nosoundyet
	P_SOUNDEFFECT	bs_cry_1
.nosoundyet
.openmouth
	P_IFSAME	pword1,bd_breathtiming,.noinc
	P_INC		pword1
.noinc
	P_IFSAME	animframe,128+4,.con
	P_ADDANIM	-1,8
	P_IGOTO		.con
.closemouth
	P_ADDCOLANIM	1,4
	P_SET		pword1,0
	P_IFSAME	animframe,128,.con
	P_ADDANIM	1,8
.con

;;; if not swinging then don't swing (obvious really!)
;;
;;	P_IFBOSSFLAG	swinging,OFF,.nodo
;;
;;	P_INC		pbyte1
;;	P_IFNOTSAME	pbyte1,20,.noreset
;;	P_SET		pbyte1,0
;;.noreset
;;	P_INDEX		pbyte2,bd_rottable,pbyte1
;;	P_SET		childroty,pbyte2
;;	P_SET		childrotx,deg45+deg11
;;	P_ADD		childrotx,pbyte2
;;.nodo
; eye the player up?

	P_IFBOSSFLAG	eyeplayer,OFF,.noteyeing

	P_FACEPLAYER
	P_ADJUSTROT	; adjust world rotation-> child rotation

	P_IFBETWEEN	-deg45-deg22,childroty,deg45+deg22,.noteyeing
	P_IFBETWEEN	-deg90-deg45,childroty,-deg45-deg22,.1clip
	P_SET		childroty,deg45+deg22
	P_IGOTO		.noteyeing
.1clip	P_SET		childroty,-deg45-deg22

.noteyeing


	P_IFBOSSFLAG	firebreathing,ON,.makefirebreath
	P_GOTO		.loop

; make the firey breath.. cor

.makefirebreath
	P_IFNOTSAME	pword1,bd_breathtiming,.nomake
	P_CHILDDEAD	kd_child_firebreath,.makeit
.nomake

	P_IFBETWEEN	deg45-deg11,childrotx,deg90-deg11,.unbec
	P_IFBETWEEN	deg90-deg11,childrotx,deg90+deg45,.2clip
	P_SET		childrotx,deg45-deg11
	P_IGOTO		.unbec
.2clip	P_SET		childrotx,deg90-deg11
.unbec

	P_GOTO		.loop
.makeit
	P_SPAWN		0,-10<<dodora_scale,35<<dodora_scale,0,0,0,firebr,d_firebreath,10,10,kd_child_firebreath
	P_BECOME
	  P_ADD		childrotx,8
	P_UNBECOME

	P_GOTO		.loop


;----------------------- D_NECK3 -------------------------------

	START_PATH	d_neck3
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_SHADOW	ON
	P_SPAWN		0,-bd_l<<dodora_scale,0,0,0,0,dodora_0,d_head,10,10,kd_child_head
.loop
	P_IFBOSSFLAG	flying,OFF,.notflying

	P_CHASE		childrotx,-deg22
	P_GOTO		.loop

.notflying
;;	P_IFBOSSFLAG	headburying,OFF,.notburying
;;
;;	P_CLIPPING	ON
;;	P_CHASE		childrotx,deg11+deg5
;;
;;	P_GOTO		.loop
;;.notburying
	P_CLIPPING	OFF
	P_CHASE		childrotx,-deg45
	P_GOTO		.loop



;----------------------- D_NECK2 ---------------------------------

	START_PATH	d_neck2
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_SHADOW	ON
	P_SPAWN		0,-bd_l<<dodora_scale,0,-deg45,0,0,dodora_1,d_neck3,10,10,kd_child_neck3
.loop
	P_IFBOSSFLAG	flying,OFF,.notflying

	P_CHASE		childrotx,-deg22
	P_GOTO		.loop

.notflying
;;	P_IFBOSSFLAG	headburying,OFF,.notburying
;;	P_CHASE		childrotx,deg11+deg5
;;
;;	P_GOTO		.loop
;;.notburying
	P_CHASE		childrotx,-deg45
;;	P_IFBOSSFLAG	swinging,OFF,.nodo
;;
;;	P_INC		pbyte1
;;	P_IFNOTSAME	pbyte1,20,.noreset
;;	P_SET		pbyte1,0
;;.noreset
;;	P_INDEX		pbyte2,bd_rottable,pbyte1
;;	P_DIV2		pbyte2
;;	P_SET		childroty,pbyte2
;;.nodo
	P_GOTO		.loop


;----------------------- D_NECK1 -------------------------------------

	START_PATH	d_neck
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_SHADOW	ON
	P_SPAWN		0,-bd_l<<dodora_scale,0,-deg45,0,0,dodora_1,d_neck2,10,10,kd_child_neck2
	P_SET		pbyte1,0

.loop
;;	P_IFBOSSFLAG	headburying,OFF,.notburying
;;	P_CHASE		childrotx,deg90-deg5
;;
;;	P_GOTO		.loop
;;.notburying
	P_CHASE		childrotx,deg90

;;	P_IFBOSSFLAG	swinging,OFF,.nodo
;;	P_INC		pbyte1
;;	P_IFNOTSAME	pbyte1,20,.noreset
;;	P_SET		pbyte1,0
;;.noreset
;;	P_INDEX		pbyte2,bd_rottable,pbyte1
;;	P_SET		childroty,pbyte2
;;.nodo
	P_GOTO		.loop
	
	P_END

bd_rottable	db	0
	db	5
	db	9
	db	12
	db	14
	db	15
	db	14
	db	12
	db	9
	db	5
	db	0
	db	-5
	db	-9
	db	-12
	db	-14
	db	-15
	db	-14
	db	-12
	db	-9
	db	-5


;----------------------- D_WING_L -----------------------------
;----------------------- D_WING_R -----------------------------

	START_PATH	d_wing_r
	START_PATH	d_wing_l
	P_INVINCIBLE	ON
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_SHADOW	ON
	P_SETANIM	0
	P_RTRIGGER	.anim,ALWAYS
	P_SET		pbyte2,1	; flapping speed

.again
	P_IFBOSSFLAG	flapping,ON,.setit
	P_SET		pbyte2,0
	P_IFSAME	animframe,128+12,.nochange
	P_ADDANIM	1,16
.nochange
	P_GOTO		.again
.setit
	P_IFNOTSAME	pbyte2,0,.con
	P_SET		pbyte2,1
.con	P_GOTO		.again

.anim
	P_ADD	animframe,pbyte2
	P_IFNOTBETWEEN	128+15,animframe,128+32,.noclp
	P_ADD	animframe,-16
.noclp
	P_IFNOTSAME	animframe,6+128,.nosnd
	P_SOUNDEFFECT	en_feather_l
.nosnd
	P_RETURN

;----------------------- D_ASHI_L ------------------------------

	START_PATH	d_ashi_l
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_SHADOW	OFF
	P_SETANIM	0

.again
;;	P_IFBOSSFLAG	sitting,ON,.sitting
.walking
	P_IFBOSSFLAG	flying,ON,.flying
	P_CHASE		childy,45<<dodora_scale
	P_CHASE		childz,-15<<dodora_scale
	P_CHASE		childrotx,0
	P_IFBOSSFLAG	walking,ON,.walking2
	P_GOSUB		bd_standing
	P_GOTO		.again
.walking2
	P_GOSUB		bd_animlegs
	P_GOTO		.again
.sitting
	P_GOSUB		bd_sitting
	P_GOTO		.again

.flying
	P_GOSUB		bd_flying
	P_GOTO		.again

;----------------------- D_ASHI_R -------------------------------

	START_PATH	d_ashi_r
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_SHADOW	OFF
	P_SETANIM	8
.again
;;	P_IFBOSSFLAG	sitting,ON,.sitting
.walking
	P_IFBOSSFLAG	flying,ON,.flying
	P_CHASE		childy,45<<dodora_scale
	P_CHASE		childz,-15<<dodora_scale
	P_CHASE		childrotx,0
	P_IFBOSSFLAG	walking,ON,.walking2
	P_GOSUB		bd_standing
	P_GOTO		.again
.walking2
	P_GOSUB		bd_animlegs
	P_GOTO		.again
.sitting
	P_GOSUB		bd_sitting
	P_GOTO		.again

.flying
	P_GOSUB		bd_flying
	P_GOTO		.again

;--------
bd_flying
	P_CHASE		childy,0<<dodora_scale
	P_CHASE		childz,-60<<dodora_scale
	P_CHASE		childrotx,deg90+deg22
	P_IFSAME	animframe,128+12,.nochange
	P_ADDANIM	-1,16
.nochange
	P_RETURN

;--------
bd_standing
	P_IFSAME	animframe,128,.nochange
	P_ADDANIM	-1,16
.nochange
	P_RETURN
	
;--------
bd_sitting	
	P_CHASE		childy,10<<dodora_scale
	P_CHASE		childz,-15<<dodora_scale
	P_CHASE		childrotx,-deg90
	P_IFSAME	animframe,128,.nochange
	P_ADDANIM	-1,16
.nochange
	P_RETURN

bd_animlegs
	P_IFSAME	shape,d_ashi_l,.no	; is this the left foot?
	P_BECOMECHILD	kd_child_leftfoot
	  P_EXPORT	gbyte1,animframe
	P_UNBECOME
	P_IMPORT	pbyte1,gbyte1
	P_NEG		pbyte1
	P_ADD		pbyte1,animframe
	P_IFSAME	pbyte1,8,.no
	P_IFSAME	pbyte1,-8,.no
	P_ADDANIM	-1,16
.no
	P_ADDANIM	1,16
	P_IFNOTSAME	animframe,0+128,.nodo
;	P_SOUNDEFFECT	en_throw	;$9b
.nodo
	P_RETURN



	printf	"Dodora length = ",*-DODORABOSSSTART,"%n"

;------------------- END BOSS KING DODORA ----------------------

;;;;eguchi write
boss_exp_screen_flash
	P_CLRDEMOSHAPE
	P_DO		2
	P_SCREENFLASH
	P_GOSUB		kani_explode
	P_WAIT		2
	P_NEXT
	P_RETURN
crash_botom_dead
	P_QSPAWN	spin_2,e_crash_damy,10,10
	P_RETURN
;------------
	START_PATH	e_runner_damy_kong

	P_TRIGGER	.mk_item,WhenDead
	P_IGOTO		pe_runner_damy.enter
.mk_item
	P_GOSUB		make_random_item
	P_GINC		B,ebyte2
	P_RETURN
;------------
	START_PATH	e_tako_damy

	P_SPAWN		-5,-20,0,deg22,deg90-deg22,0,nullshape,tako_dummypiece,10,10,tako_child_leg1
	P_SPAWN		5,-20,0,deg22,-deg90+deg22,0,nullshape,tako_dummypiece,10,10,tako_child_leg2
	P_SPAWN		0,-20,5,deg22,deg180,0,nullshape,tako_dummypiece,10,10,tako_child_leg3
;------------
	START_PATH	e_runner_damy
.enter	LOCAL
	P_CLRDEMOSHAPE
	P_COLLISIONS	OFF
	P_TRIGGER	crash_flash,4
	P_ACTIVE	ON

	P_WAIT		20
	P_GOSUB		boss_exp_screen_flash
;	P_SCORE		1000
	P_CIRCLEWINDOW	1,big

	P_EXPLODE
;------------
	START_PATH	e_crash_damy

	P_CLRDEMOSHAPE
	P_SET		coltab,id_1_c&WM
	P_COLLISIONS	OFF

	P_TRIGGER	crash_flash,4

	P_CLIPPING	OFF
	P_SET		vx,childx
	P_SET		vz,childz
	P_DO	4
	  P_DIV2	vx
	  P_DIV2	vz
	P_INEXT

	P_SET	vy,-30
	P_SET	pbyte1,deg22
.bounce
	P_NOTHITGROUND	30,.nyet
	
	P_NEG	pbyte1
	P_DIV2	pbyte1

	P_ZERO	vx
	P_ZERO	vz
	
	P_SET	worldy,-30

	P_DIV2	vy
	P_NEG	vy
	P_IFBETWEEN	-5,vy,5,.deaded
.nyet
	P_ADD	rotx,pbyte1
	P_ADD	vy,4
	P_GOTO	.bounce
.deaded

	P_GOSUB		boss_exp_screen_flash
	P_SCORE		1000
	P_GDEC		B,KEnemyNumber
	P_CIRCLEWINDOW	1,big

	P_EXPLODE
crash_flash
	P_HITFLASHTRIG
	P_GOSUB		kani_explode
	P_RETURN
	
;;;;eguchi write end

;***---***---***---***---***---***---***---***---***---***---***---***
; ok, laser particles man...

	start_path	laserpart

;	p_Rangecheck	off
	p_collisions	off
	p_setstrat	.start
	P_END
.start	s_start_strat
	s_particle_data	x,7,5,30
	s_clr_alsflag	x,pathobj
	s_set_alsflag	x,active
	s_set_alsflag	x,notslope
	s_set_alsflag	x,noviewcheck
	s_set_strat	x,.strat
	s_set_alvar	B,x,al_count,#1
.strat	s_start_strat
	lda	al_count,x
	dec	a
	sta	al_count,x
	bpl	.notyet
	cmp	#-10
	beq	.leave
	s_particle_data	x,0,0,0
.notyet

	s_end_strat
.leave
	s_remove_obj	x
	s_end_strat

;---------------------------------------------------------------------
; bursts of flame from the ground around the player

	START_PATH	flameburst
	P_INVISIBLE	ON
.lp	P_WAIT	16
	P_GSET	W,gword1,0
	P_GOSUB	pBOSS_dragon.firtrees
	P_IGOTO	.lp

;---------------------------------------------------------------------
; little fishies, jump out of the ocean waves

	START_PATH	fishburst
	P_INVISIBLE	ON
.lp	P_WAIT	8
	P_GSET	W,gword1,-500
	P_QSPAWN	kozakana,fishies,10,10
	P_LINKTOBECOME
	P_GOSUB		dp_plrrndset
	P_GOTO		.lp
.wt	P_SHAPEDEAD	.lp
	P_GOTO		.wt

;------------------------------------------------------
	START_PATH	fishies
	P_IMPORT	pword1,player1_worldy
	P_IFBETWEEN	-1000,pword1,1000,.nornd
	P_RANDOMGOTO	pfishies2
.nornd
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLIPPING	ON
	P_SETVEL	10
	P_SET		pbyte1,10
.lp	P_WAIT		10
	P_DEC		pbyte1
	P_IFZERO	pbyte1,.rem
	P_INPLAYERSCONE	-deg45-deg22,deg45+deg22,.lp
.rem	P_REMOVE

;------------------------------------------------------
	START_PATH	fishies2
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
;	P_CLIPPING	ON
	P_SET		worldy,-1000
	P_SETVEL	40
	P_ALWAYSGENVECS	ON
	P_QSPAWN	splash,tako_splash,10,10
	P_SET		rotx,-deg45-deg22

	P_SOUNDEFTDISTPOS	en_outmarine

.wt	P_WAIT		1
	P_ADD		rotx,8
	P_IFNOTSAME	rotx,deg45+deg22,.wt
	P_QSPAWN	splash,tako_splash,10,10
	P_SOUNDEFTDISTPOS	en_inmarine
	P_REMOVE

;------------------------------------------------------
; set the object somewhere in front of the player

dp_plrrndset
; --- set position somewhere around the player ---
	P_BECOME
	  P_SETRANDOM	roty
	  P_START65816
	  ldy	pathplayer&WM
	  a16
	  lda.w	al_worldx,y
	  sta	al_worldx,x
	  lda.w	al_worldz,y
	  sta	al_worldz,x
	  lda.w	al_worldy,y
	  sta	al_worldy,x
	  P_END65816
	  P_SETRANDOM	pbyte1
	  P_ADD		worldx,pbyte1
	  P_ADD		worldx,pbyte1
	  P_ADD		worldx,pbyte1
	  P_ADD		worldx,pbyte1
	  P_ADD		worldx,pbyte1
	  P_ADD		worldx,pbyte1
	  P_SETRANDOM	pbyte1
	  P_ADD		worldz,pbyte1
	  P_ADD		worldz,pbyte1
	  P_ADD		worldz,pbyte1
	  P_ADD		worldz,pbyte1
	  P_ADD		worldz,pbyte1
	  P_ADD		worldz,pbyte1
	  P_INPLAYERSCONE	-deg45,deg45,.nocr
	  P_JSL65816	getheight_l
	  P_IMPORT	pword1,y1
	  P_IFSAME	pword1,0,.nocr
.rem
	  P_START65816
	  s_remove_obj	x
	  P_END65816
.nocr
	  P_IMPORT	worldy,gword1
	P_UNBECOME
	P_RETURN





;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
; CREDITS SEQUENCE



cs_zoomtime	equ	60		; frames taken to zoom teki off

;--------------------------------------------------
	START_PATH	creditseq
	P_INVISIBLE	ON

	P_START65816
	lda	#$3a
	sta	rand
	lda	#$a7
	sta	rand+1
	lda	#$55
	sta	rand+2
	lda	#$7f
	sta	rand+3
	P_END65816

;	P_IMPORT	pbyte1,Kdifficulty
;	P_IFSAME	pbyte1,dif_hard,.hard_nagasa
;	P_SET		pbyte1,40
;.hard_nagasa


;	P_GSET		B,Kdifficulty,dif_hard

	P_SET		pbyte1,credits_3d_start_delay_hard
	P_SET		pbyte2,credits_blanking_time_hard

	P_IMPORT	tx,Kdifficulty
	P_IFSAME	tx,dif_hard,.hard_nagasa
	P_SET		pbyte2,credits_blanking_time_normal
	P_SET		pbyte1,credits_3d_Start_delay_normal
	P_IFSAME	tx,dif_normal,.hard_nagasa
	P_SET		pbyte2,credits_blanking_time_easy
	P_SET		pbyte1,credits_3d_start_delay_easy
.hard_nagasa

	P_DO	pbyte1

	P_IFZERO	pbyte2,.wibble
	P_DEC		pbyte2
	P_IGOTO		.noset
.wibble
	P_GSET		B,credits_on,1
.noset

	P_START65816
	stz	fade
	stz	fadedir
	lda	#$80
	sta.l	xinidisp1
	P_END65816
	P_NEXT

;	P_WAIT		140
;	P_BEGINDEMO

;	P_START65816
;	lda	#2
;	sta	fade
;	lda	#$f
;	sta.l	xinidisp1
;	P_END65816

	P_SPAWN	0,0,-100,0,0,0,nullshape,cs_camera,10,10,167
	P_BECOME
	  P_ACTIVE	ON
	P_UNBECOME

	P_WAIT	1
.lp
	P_START65816
	ldy	al_pword1,x
	beq	.nocopy
	s_copy_pos	x,y
.nocopy	P_END65816
	P_GOTO		.lp
;--------------------------------------------------
	START_PATH	cs_camera
	P_INVISIBLE	ON
	P_RTRIGGER	.always,ALWAYS

	P_IMPORT	pbyte1,Kdifficulty
	P_IFSAME	pbyte1,dif_easy,.anotherdemo
	P_IFSAME	pbyte1,dif_normal,.setnorm
	P_SET		ox,0+(cseq_table_hard-cseq_table)/2
	P_IGOTO		.anotherdemo
.setnorm
	P_SET		ox,0+(cseq_table_norm-cseq_table)/2

; --- get objects and add them
.anotherdemo

	P_TRIGGER	.always,OFF

;	P_SET		childx,0
;	P_SET		childy,0
;	P_SET		childz,0
;	P_SET		childroty,deg180
;	P_WAIT		1
;	P_SETCAMERA	IMMEDIATE
	P_RTRIGGER	.always,ALWAYS

;	P_ZERO	ox
.another
	P_INDEX		pword1,cseq_table,ox
	P_IFZERO	pword1,.dontdo1

	P_QSPAWN	nullshape,cs_camera,10,10
	P_EXPORT	gword1,ox
	P_BECOME
	  P_ZERO	rotx
	  P_ZERO	roty
	  P_ZERO	rotz

	  P_IMPORT	ox,gword1

	  P_INDEX	shape,cseq_table,ox
	  P_INC		ox

	  P_INDEX	pword1,cseq_table,ox
	  P_INC		ox
	  P_EXPORT	becomepath,pword1

	  P_INDEX	pword1,cseq_table,ox
	  P_INC		ox
	  P_ADD		worldx,pword1

	  P_INDEX	pword1,cseq_table,ox
	  P_INC		ox
	  P_ADD		worldy,pword1

	  P_INDEX	pword1,cseq_table,ox
	  P_ADD		worldz,pword1

	  P_ACTIVE	ON
	  P_INVISIBLE	ON

	P_UNBECOME

	P_ADD	ox,5
	P_IGOTO	.another

.dontdo1
	P_BECOMEMOTHER
	  P_SWAPVAR	pword1,ptr
	  P_LINKTOBECOME
	  P_SWAPVAR	pword1,ptr
	P_UNBECOME

	P_SWAPVAR	mz,ptr
	P_LINKTOBECOME
	P_SWAPVAR	mz,ptr

	P_INC		ox
	P_INDEX		pword1,cseq_table,ox
	P_IFZERO	pword1,.rem

	P_INC		ox
	P_INDEX		oy,cseq_table,ox
	P_EXPORT	cs_shapename,oy
	P_INC		ox

	P_GSET		B,cseq_flag,0
	P_TRIGGER	cs_fixcam,Timer,2
	P_TRIGGER	cs_screenon,Timer,10

	P_GOSUB		pword1

	P_START65816
;	lda	#$80
;	sta.l	xinidisp1
	lda	#-2
	sta	fadedir
	P_END65816

	P_WAIT		6
	P_GOTO		.anotherdemo

.always
	P_SETCAMERA
	P_SETCAMERA
;	P_SETCAMERA
	P_RETURN
.rem

	P_REMOVE

cs_fixcam
	P_SWAPVAR	mz,ptr
	P_FACESHAPE	IMMEDIATE
	P_ADJUSTROT
	P_SWAPVAR	mz,ptr
	P_SETCAMERA	IMMEDIATE
	P_RETURN

cs_screenon
	P_START65816
;	lda	#$f
;	sta.l	xinidisp1
	lda	#2
	sta	fadedir
	P_END65816
	P_RETURN

;------------------------------------------------------
; --- sweep the camera up and around

	START_PATH	cs_sweep_up2

	P_SET		childz,-5000
	P_IGOTO		pcs_sweep_up.in

	START_PATH	cs_sweep_up

	P_SET		childz,-1000
.in	LOCAL

	P_SET		childx,0
	P_SET		childy,2000

	P_TRIGGER	.up,ALWAYS
	P_TRIGGER	cs_faceshape,ALWAYS
.lp
;	P_WAIT		50

	P_DO		90
	  P_CIRCLE	1
;	  P_MOVEIN	4
	  P_ADD		childz,15
	P_NEXT

	P_WAIT	1
	P_DO	40
	  P_CIRCLE	1
	  P_ADD		childz,25
	P_NEXT

	P_TRIGGER	.up,OFF
	P_GOSUB		cs_finishdemo

	P_RETURN

; 180 frames

.up
	P_IFNOTBETWEEN	-deg90-deg45,rotx,4,.miss
	P_ADD		childy,-10
.miss	P_RETURN

;-----------------------------------------------------
; --- finish off the demo

cs_finishdemo
	P_GSET		B,cseq_flag,1
	P_BECOMEMOTHER
	  P_ZERO	pword1
	P_UNBECOME

	P_WAIT		cs_zoomtime-1
	P_TRIGGER	cs_faceshape,OFF
	P_RETURN


;------------------------------------------------
; --- don't sweep the camera

	START_PATH	cs_nosweep
	P_SET		childx,000
	P_SET		childy,500
	P_SET		childz,-2500

	P_TRIGGER	cs_faceshape,ALWAYS

	P_DO		121
;	P_ADD		worldy,-6	;12
	P_CIRCLE	1
	P_NEXT

	P_START65816

	lda	kdifficulty
	cmp	#dif_hard
	beq	.hard
	lda	#kbgm_end_jan_0
	bra	.set
.hard
	lda	#kbgm_end_jan_1
.set
	kbgm_a

	P_END65816

.lp
	P_GOTO		.lp

;----------------------------------------------------
; --- sweep the camera up and around

	START_PATH	cs_sweep_down

	P_SET		childx,0
	P_SET		childy,-2000
	P_SET		childz,-2000

	P_WAIT		1
	P_SETCAMERA	IMMEDIATE

	P_TRIGGER	.up,ALWAYS
	P_TRIGGER	cs_faceshape,ALWAYS
.lp
	P_DO		100
	  P_ADD		childz,45
	P_NEXT

	P_DO		50
	  P_CIRCLE	-1
	P_NEXT

	P_DO		50
	  P_ADD		childy,10
	  P_ADD		childz,-25
	P_NEXT

	P_GOSUB		cs_finishdemo
	P_TRIGGER	.up,OFF
	P_RETURN

; 200 frames

.up
	P_IFNOTBETWEEN	4,rotx,deg90,.miss
	P_ADD		childy,25
.miss	P_RETURN


;----------------------------------------------------
; --- sweep through the ships

	START_PATH	cs_sweep_through

	P_SET		childx,-500
	P_SET		childy,-1000
	P_SET		childz,-4000

;	P_WAIT		1
;	P_SETCAMERA	IMMEDIATE

	P_TRIGGER	cs_faceshape,ALWAYS

	P_DO		120
	  P_ADD		childz,5000/120
	  P_ADD		childy,10
	P_NEXT

	P_WAIT		1

	P_DO		30
	  P_ADD		childz,6000/75
	  P_ADD		childy,-10
	P_NEXT
	P_WAIT		1

	P_DO		40
	  P_ADD		childy,10
	  P_CIRCLE	-2
	P_NEXT

	P_GOSUB		cs_finishdemo
	P_RETURN

; 190 frames

;----------------------------------------------------
; --- sweep through the ships

	START_PATH	cs_sweep_through_big

	P_SET		childx,-6000
	P_SET		childy,-1500
	P_SET		childz,10000

;	P_WAIT		1
;	P_SETCAMERA	IMMEDIATE

	P_TRIGGER	cs_faceshape,ALWAYS

	P_DO		100
	  P_ADD		childz,-10000/140
	  P_ADD		childy,2
	  P_ADD		childx,10
	P_NEXT

	P_WAIT		1

	P_DO		90
;	  P_CIRCLE	-2
	  P_ADD		childz,-10000/180
	  P_ADD		childy,10
	  P_ADD		childx,25
	P_NEXT

	P_WAIT		1

;	P_RTRIGGER	.movex,ALWAYS
;	P_WAIT		10
	P_GOSUB		cs_finishdemo
;	P_TRIGGER	.movex,OFF
	P_RETURN

;.movex
;	P_ADD		childy,30
;	P_RETURN

; 190 frames

;----------------------------------------------------
; --- sweep through the ships

	START_PATH	cs_sweep_through_close

	P_SET		childx,-200
	P_SET		childy,-300
	P_SET		childz,-1000

	P_WAIT		1
	P_SETCAMERA	IMMEDIATE

	P_TRIGGER	cs_faceshape,ALWAYS

	P_DO		90
	  P_ADD		childz,1000/90
	  P_ADD		childy,5
	P_NEXT

	P_WAIT		1

	P_DO		100
	  P_ADD		childz,7
;	  P_ADD		childy,-7
	  P_CIRCLE	-2
	P_NEXT

	P_GOSUB		cs_finishdemo
	P_RETURN

; 110 frames

;----------------------------------------------------
; --- special camera sweep for andorf

	START_PATH	cs_sweep_andorf

	P_SET	childx,0
	P_SET	childy,0
	P_SET	childz,2000

	P_IMPORT	pbyte1,Kdifficulty
	P_IFSAME	pbyte1,dif_normal,.ok
	P_WAIT		70
	P_IGOTO		.con
.ok	P_WAIT		90
.con

	P_GOSUB		cs_finishdemo
	P_RETURN
;----------------------------------------------------
; --- sweep through the ships from front

	START_PATH	cs_sweep_through_mae

	P_SET		childx,-200
	P_SET		childy,-300
	P_SET		childz,4000

	P_WAIT		1
	P_SETCAMERA	IMMEDIATE

	P_TRIGGER	cs_faceshape,ALWAYS

	P_DO		80
	  P_ADD		childz,-5000/80
	  P_ADD		childy,5
	P_NEXT

	P_DO		50
	  P_ADD		childy,-3
	P_NEXT
	P_WAIT		1

	P_DO		50
	  P_ADD		childy,6
	  P_CIRCLE	1
	P_NEXT

	P_GOSUB		cs_finishdemo
	P_RETURN

; 180 frames

cs_faceshape
	P_SWAPVAR	ptr,mz
	P_FACESHAPE
	P_FACESHAPE
	P_FACESHAPE
	P_FACESHAPE
	P_FACESHAPE
	P_ADJUSTROT
	P_SWAPVAR	ptr,mz
	P_RETURN
;--------------------------------------------------
; the strategy for the 'the end'

	START_PATH	cs_theend
	P_COLLISIONS	OFF
	P_SETANIM	0
	P_NEG		pword1
	P_ADD		worldz,pword1
	P_ADD		worldz,-5000
	P_NEG		pword1
	P_SETVEL	50
	P_WAIT		15
	P_WAIT		pword1
	P_INVISIBLE	OFF
	P_DO		5200/150
	  P_ADD		worldz,150
	P_NEXT
.lp
	P_WAIT	1
	P_DO	3
	  P_ADDANIM	1,4
	P_NEXT
	P_END

;--------------------------------------------------
	START_PATH	cs_baku
	P_SPAWN		-40<<bakugeki_scale,0,0,0,0,0,baku_r,donowt,10,10,1
	P_SPAWN		40<<bakugeki_scale,0,0,0,0,0,baku_l,donowt,10,10,2
	P_IGOTO		pcs_stationary

	START_PATH	donowt
	P_END
;--------------------------------------------------
	START_PATH	cs_batabata
	P_SETANIM	0
	P_TRIGGER	.anim,ALWAYS
	P_IGOTO		pcs_stationary
.anim	P_ADDANIM	1,12
	P_RETURN
;--------------------------------------------------
	START_PATH	cs_demo_senkan
	P_GOSUB		mk_big_senkan
	P_IGOTO		pcs_stationary

;--------------------------------------------------
	START_PATH	cs_baramiss
	P_GOSUB		mk_baramiss_c
	P_IGOTO		pcs_stationary

;--------------------------------------------------
	START_PATH	cs_sos_2
	P_SET		ap,4
	P_GOSUB		make_bit
	P_IGOTO		pcs_stationary

;--------------------------------------------------
	START_PATH	cs_toge
	P_GOSUB		mk_toge
	P_TRIGGER	.spin,ALWAYS
	P_IGOTO		pcs_stationary

.spin
	P_ADD		roty,-4
	P_RETURN

;--------------------------------------------------
	START_PATH	cs_andorf

	P_SPAWN		0,0,0,0,0,0,andorf_0,andorf_head,10,10,andorf_child_head
	P_SPAWN		0,0,0,0,0,0,clipshape,andorfburst,10,10,andorf_child_maskclip
	P_WAIT		1
	P_CLIPPING	BOSS

	P_COLLISIONS	OFF
	P_SETVEL	10
	P_TRIGGER	offcheck_andorf,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF
	P_END

offcheck_andorf
	P_IMPORT	pbyte1,cseq_flag
	P_IFZERO	pbyte1,.noflag
	P_FORCE		.rem
	P_TRIGGER	offcheck_andorf,OFF
.noflag	P_RETURN
.rem
	P_WAIT	cs_zoomtime
	P_REMOVE
;--------------------------------------------------
	START_PATH	cs_monkey

	P_SETANIM	0
	P_COLLISIONS	OFF
	P_SETVEL	30
	P_TRIGGER	offcheck_monkey,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF
	P_END

offcheck_monkey
	P_IMPORT	pbyte1,cseq_flag
	P_IFZERO	pbyte1,.noflag
	P_FORCE		.rem
	P_TRIGGER	offcheck_monkey,OFF
.noflag	P_RETURN
.rem
	P_DO		5
	P_ADDANIM	1,8
	P_NEXT
	P_WAIT	cs_zoomtime-4
	P_REMOVE
;--------------------------------------------------
	START_PATH	cs_gattai
	P_GOSUB		mk_gattai_enban
	P_TRIGGER	.spin,ALWAYS
	P_IGOTO		pcs_stationary
.spin
	P_ADD		roty,4
	P_RETURN
;--------------------------------------------------
	START_PATH	cs_speed_lr
	P_SPAWN		0,0,0,0,0,0,speed_s,cs_nothing,10,10,1
	P_SETANIM	0
	P_IGOTO		pcs_stationary

	START_PATH	cs_nothing
	P_COLLISIONS	OFF
	P_END

;--------------------------------------------------
	START_PATH	cs_ninja
	P_SETANIM	5
	P_IGOTO		pcs_stationary
;--------------------------------------------------
	START_PATH	cs_enkin
	P_SETRANDOM	animframe,7
	P_ADD		animframe,128
	P_TRIGGER	.anim,ALWAYS
	P_TRIGGER	.check,ALWAYS
	P_IGOTO		pcs_stationary
.anim	P_ADDANIM	1,12
	P_RETURN
.check	P_IMPORT	pbyte1,cseq_flag
	P_IFZERO	pbyte1,.noflag
	P_TRIGGER	.check,OFF
	P_TRIGGER	.animoff,Timer,cs_zoomtime
.noflag
	P_RETURN
.animoff	P_TRIGGER	.anim,OFF
	P_RETURN

;--------------------------------------------------
; just fly forwards until told not to

	START_PATH	cs_stationaryslow
	P_SETVEL	10
	P_IGOTO		pcs_stationary.in

	START_PATH	cs_stationary
	P_SETVEL	50
.in	LOCAL
	P_COLLISIONS	OFF
	P_TRIGGER	offcheck,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF
	P_END

	START_PATH	cs_stationary_left
;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_SETVEL	50
	P_TRIGGER	offcheckleft,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF
	P_END

	START_PATH	cs_stationary_right
;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_SETVEL	50
	P_TRIGGER	offcheckright,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF
	P_END


;------------
offcheck
	P_PUSH	pbyte1
	P_IMPORT	pbyte1,cseq_flag
	P_IFZERO	pbyte1,.noflag
	P_FORCE		.rem
	P_TRIGGER	offcheck,OFF
.noflag	P_PULL	pbyte1
	P_RETURN
.rem
	P_SETRANDOM	skidy,7
	P_INC		skidy
	P_ADD		skidy,skidy
	P_ADD		skidy,skidy
	P_WAIT		skidy
	P_TRIGGER	offcheck_zoom,ALWAYS
	P_WAIT	cs_zoomtime-32
	P_NEG		skidy
	P_ADD		skidy,32
	P_WAIT		skidy
	P_REMOVE
offcheck_zoom
	P_ADD	worldz,150
	P_RETURN

;------------
offcheckleft
	P_PUSH	pbyte1
	P_IMPORT	pbyte1,cseq_flag
	P_IFZERO	pbyte1,.noflagl
	P_TRIGGER	offcheckleft,OFF
	P_FORCE		.reml
.noflagl	P_PULL	pbyte1
	P_RETURN
.reml
	P_TRIGGER	offcheck_zoom,ALWAYS
	P_WAIT	10
	P_DO	cs_zoomtime-15
	  P_ADD	rotz,1
	  P_ADD	worldx,-50
	P_NEXT
	P_WAIT	6
	P_REMOVE

;------------
offcheckright
	P_PUSH	pbyte1
	P_IMPORT	pbyte1,cseq_flag
	P_IFZERO	pbyte1,.noflagr
	P_TRIGGER	offcheckright,OFF
	P_FORCE		.remr
.noflagr	P_PULL	pbyte1
	P_RETURN
.remr
	P_TRIGGER	offcheck_zoom,ALWAYS
	P_WAIT	10
	P_DO	cs_zoomtime-15
	  P_ADD	rotz,-1
	  P_ADD	worldx,50
	P_NEXT
	P_WAIT	6
	P_REMOVE


; --- set the star wolf's boss meter
bm_star_wolf
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,STARWOLFNO
	P_IFZERO	pbyte1,bm_wolf
	P_IFSAME	pbyte1,1,bm_leon
	P_IFSAME	pbyte1,2,bm_pigma
bm_algy
	P_SETBOSSNAME	name_algy
	P_IGOTO		bm_in
bm_pigma
	P_SETBOSSNAME	name_pigma
	P_IGOTO		bm_in
bm_leon
	P_SETBOSSNAME	name_leon
	P_IGOTO		bm_in
bm_wolf
	P_SETBOSSNAME	name_wolf
bm_in
	P_ADD		hp,-40
	P_EXPORT	bossmaxhp,hp
	P_EXPORT	bossHP,hp
	P_TRIGGER	.hit,WhenHit
	P_ADD		hp,40
	P_PULL		pbyte1
	P_RETURN

.hit	LOCAL
	P_ADD		hp,-40
	P_EXPORT	bossHP,hp
	P_ADD		hp,40
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,STARWOLFNO
	P_IFZERO	pbyte1,.wolf
	P_IFSAME	pbyte1,1,.set_leon
	P_IFSAME	pbyte1,2,.set_pigma
	P_EXPORT	ehp_algy,hp
	P_IGOTO		.wolf
.set_leon
	P_EXPORT	ehp_leon,hp
	P_IGOTO		.wolf
.set_pigma
	P_EXPORT	ehp_pigma,hp
.wolf
	P_PULL		pbyte1
	P_RETURN
