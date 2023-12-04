;;;;##############################################################
;;;;#                                                            #
;;;;#                    EGUCHI'S DPATHDAT                       #
;;;;#                                                            #
;;;;##############################################################
;;;;#################
;;;;# DEMO CONTROLL #
;;;;#################
;;;;------------------ SAVED ROBO DEMO
;;;
;***** EXTERN *****
    incpub    dpathdat
;***** EXTERN *****
	START_PATH	e_robo_demo

	P_INVISIBLE	ON

.find
	P_FINDSHAPE	demo_target
	P_SHAPEDEAD	.find_again
	P_IGOTO		.start
.find_again
	P_GOTO		.find
.start
	P_GOSUB		make_org_view

	P_IFSAME	slopenum,de_for_door_kotei_pos,.kd
	P_IFSAME	slopenum,de_for_door_kotei_pos_s,.kd_s
	P_IFNOTSAME	slopenum,de_for_neta,.not_ns
.kd
	P_PLAYERDEAD	eg_remove
	P_BEGINDEMO
	P_GOSUB		demo_zoom
;demo_zoom
;	P_COPYVIEWROTS
;	P_COPYVIEWPOS
;	P_IGOTO		.out_view
;	P_SET		pbyte1,8
;	P_IMPORT	pbyte2,PlayerImportFlag
;	P_IFSWITCH	pbyte1,pbyte2,.cock
;	P_IGOTO		.out_view
;.cock
;	P_PUSH		worldy
;	P_COPYPLAYERPOS
;	P_SET		mx,worldx
;	P_SET		mz,worldz
;	P_NEG		mx
;	P_NEG		mz
;	P_COPYVIEWPOS
;	P_ADD		mx,worldx
;	P_ADD		mz,worldz
;	P_NEG		mx
;	P_NEG		mz
;	P_COPYPLAYERPOS
;	P_ADD		worldx,mx
;	P_ADD		worldz,mz
;	P_PULL		worldy
;.out_view
;	P_ADD		worldy,-50
;	P_DO		2
;	P_PUSH		worldy
;	P_MOVEINPLAYER	-100
;	P_PULL		worldy
;	P_FACEPLAYER	IMMEDIATE
;	P_INEXT
;	P_RETURN

	P_DO		10
	P_SETCAMERA
	P_NEXT
	P_WAIT		15
	P_ENDDEMO
	P_IGOTO		.not_ns
.kd_s
	P_PLAYERDEAD	eg_remove
	P_BEGINDEMO
	P_WAIT		8
	P_ENDDEMO
.not_ns
	P_SET		childy,worldy
	P_IFSAME	slopenum,de_for_sw_base_sw_takadai,.mikako_up
	P_COPYVIEWPOS
	P_SET		childy,worldy
	P_IFSAME	slopenum,de_for_map_fuse,.move_ck_500
	P_IFSAME	slopenum,de_for_neta,.move_ck_500
	P_IFSAME	slopenum,de_for_neta_final_door,.move_ck_500
	P_IFSAME	slopenum,de_for_sw_base_sw,.move_ck_300
	P_IFSAME	slopenum,de_for_sw_base_sw_sea,.move_ck_300
	P_IFSAME	slopenum,de_for_sw_base_sw_far,.move_ck_500
	P_IFSAME	slopenum,de_for_sw_base_sli,.sli
	P_IFSAME	slopenum,de_for_base_base,.move_ck_1000
	P_IFSAME	slopenum,de_for_door_kotei_pos,.d_kotei
	P_IFSAME	slopenum,de_for_door_kotei_pos_s,.d_kotei
.move_ck_300
	P_SHAPEDISTLESS	300,.move_out_again
.fast
	P_SHAPEDISTLESS	400,.move_in_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	120
	P_IGOTO		.fast
.move_in_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	50
	P_SHAPEDISTMORE	300,.move_in_again
	P_IGOTO		.move_end

.move_out_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	-50
	P_SHAPEDISTLESS	300,.move_out_again
	P_IGOTO		.move_end
;;;;-----------
.move_ck_500
	P_SHAPEDISTLESS	500,.move_out500_again
.fast500
	P_SHAPEDISTLESS	600,.move_in500_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	120
	P_IGOTO		.fast500
.move_in500_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	10
	P_SHAPEDISTMORE	500,.move_in500_again
	P_IGOTO		.move_end

.move_out500_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	-10
	P_SHAPEDISTLESS	500,.move_out500_again
	P_IGOTO		.move_end
;;;;-----------
.move_ck_1000
	P_SHAPEDISTLESS	1000,.move_out1000_again
.move_in1000_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	50
	P_SHAPEDISTMORE	1000,.move_in1000_again
	P_IGOTO		.move_end

.move_out1000_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	-50
	P_SHAPEDISTLESS	1000,.move_out1000_again
	P_IGOTO		.move_end
;;;;-----------
.mikako_up
	P_ADD		worldx,-1000
	P_ADD		worldz,-200
	P_IGOTO		.move_end
;;;;-----------
.sli
	P_ADD		worldx,-500
	P_ADD		worldz,-100
	P_IGOTO		.move_end
;;;;-----------
.d_kotei
	P_FINDSHAPE	kabe_aku
	P_BECOMESHAPE
	P_EXPORT	gword1,worldx
	P_EXPORT	gword2,worldz
	P_EXPORT	gbyte1,roty
	P_UNBECOME
	P_IMPORT	worldx,gword1
	P_IMPORT	worldz,gword2
	P_IMPORT	pbyte1,gbyte1
	P_SET		pword1,-120
	P_IFZERO	pbyte1,.shitakara
	P_IFSAME	pbyte1,64,.migikara
	P_IFSAME	pbyte1,-64,.hidarikara
	P_ADD		worldz,450
	P_IGOTO		.koko
.hidarikara
	P_ADD		worldx,-450
	P_IGOTO		.koko
.migikara
	P_ADD		worldx,450
	P_IGOTO		.koko
.shitakara
	P_ADD		worldz,-450
.koko
	P_FINDSHAPE	demo_target
	P_IGOTO		.move_end
;;;;-----------
.move_end
	P_GOSUB		.keep_hi

	P_COPYVIEWROTS
	P_SET		pbyte1,roty
	P_FACESHAPE	IMMEDIATE

	P_PLAYERDEAD	eg_remove
	P_BEGINDEMO

	P_SET		childx,worldx
	P_SET		childy,worldy
	P_SET		childz,worldz

	P_SET		worldx,ox
	P_SET		worldy,oy
	P_SET		worldz,oz

	P_GOSUB		.view_again

	P_GOSUB		.set_wait_flag

	P_INC		ty
	P_DO		ty
	P_WAIT		1
	P_NEXT
	P_SET		ty,1
	P_IFLARGER	tx,ty,.ok
	P_SET		tx,ty
.ok
	P_DO		tx
	P_INVISIBLE	ON
	P_NEXT

;;;;---- FOR SWITCH BASE

	P_IFSAME	slopenum,de_for_sw_base_sw,.chika_base
	P_IFSAME	slopenum,de_for_sw_base_sw_sea,.chika_base
	P_IFSAME	slopenum,de_for_sw_base_sw_far,.chika_base
	P_IFSAME	slopenum,de_for_sw_base_sli,.chika_base
	P_IGOTO		.not_chika_base
.chika_base
	P_SET		childy,-200
	P_PUSH		worldx
	P_PUSH		worldy
	P_PUSH		worldz
	P_ZERO		worldx
	P_ZERO		worldy
	P_ZERO		worldz
	P_IFNOTSAME	slopenum,de_for_sw_base_sw_sea,.not_sea
	P_FINDSHAPE	chika_k1
;;;	P_SHAPEDEAD	must_debug
	P_IGOTO		.same_base
.not_sea
	P_FINDSHAPE	chika_k0
;;;	P_SHAPEDEAD	must_debug
.same_base
	P_BECOMESHAPE
	P_EXPORT	gword1,worldx
	P_EXPORT	gword2,worldz
	P_UNBECOME
	P_PULL		worldz
	P_PULL		worldy
	P_PULL		worldx
	P_FINDSHAPE	demo_target
;;;	P_SHAPEDEAD	must_debug
	P_BECOMESHAPE
	P_IMPORT	worldx,gword1
	P_SET		worldy,-200
	P_IMPORT	worldz,gword2
	P_UNBECOME
.bmove_ck_1000
	P_SHAPEDISTLESS	1000,.bmove_out1000_again
.bmove_in1000_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	100		;50
	P_SHAPEDISTMORE	1000,.bmove_in1000_again
	P_IGOTO		.bmove_end

.bmove_out1000_again
	P_GOSUB		.keep_hi
	P_MOVEINSHAPE	-100		;50
	P_SHAPEDISTLESS	1000,.bmove_out1000_again
.bmove_end
	P_GOSUB		.keep_hi

	P_COPYVIEWROTS
	P_SET		pbyte1,roty
	P_FACESHAPE	IMMEDIATE

	P_SET		childx,worldx
	P_SET		childy,worldy
	P_SET		childz,worldz

	P_SET		worldx,ox
	P_SET		worldy,oy
	P_SET		worldz,oz

	P_GOSUB		.view_again

	P_GOSUB		.set_wait_flag2

	P_IMPORT	pword1,PlanetSwitch
	P_SET		pbyte1,5
	P_IFSWITCH	pbyte1,pword1,.long
	P_WAIT		20
	P_GOTO		.not_chika_base
.long
	P_IFNOTSAME	slopenum,de_for_sw_base_sw_sea,.not_sea2
	P_WAIT		40	
	P_IGOTO		.same_base2
.not_sea2
	P_WAIT		70	
.same_base2
;;;;---- FOR SWITCH BASE END END END

.not_chika_base
	P_GOSUB		back_org_view

	P_ENDDEMO

	P_REMOVE
.keep_hi
	P_INC		skidy
	P_SET		worldy,childy

	P_IFZERO	pword1,.not_pw1
	P_SET		worldy,pword1
.not_pw1
	P_RETURN
.view_again
	P_WAIT		1
	P_DO		3			;2
	P_CHASE		worldx,childx
	P_CHASE		worldy,childy
	P_CHASE		worldz,childz
	P_SETCAMERA
	P_INEXT
	P_IFNOTSAME	worldx,childx,.view_again
	P_IFNOTSAME	worldy,childy,.view_again
	P_IFNOTSAME	worldz,childz,.view_again
	P_PUSH		rotx
	P_PUSH		roty
	P_PUSH		rotz
	P_COPYVIEWROTS
	P_SET		weapontype,roty
	P_PULL		rotz
	P_PULL		roty
	P_PULL		rotx
	P_IFNOTSAME	weapontype,pbyte1,.view_again
	P_RETURN

.set_wait_flag
	P_PUSH		pbyte1
	P_PUSH		pbyte2
	P_SET		pbyte2,1
	P_IMPORT	pbyte1,ebyte6
	P_SETSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte6,pbyte1
	P_PULL		pbyte2
	P_PULL		pbyte1
	P_RETURN
.set_wait_flag2
	P_PUSH		pbyte1
	P_PUSH		pbyte2
	P_SET		pbyte2,2
	P_IMPORT	pbyte1,ebyte6
	P_SETSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte6,pbyte1
	P_PULL		pbyte2
	P_PULL		pbyte1
	P_RETURN
;;;must_debug
;;;	P_SCORE		1
;;;	P_GOTO		must_debug
;;;;------------
	START_PATH	e_r_demo_target

	P_WAIT		10

	P_REMOVE
;;;;����������������ͻ
;;;;� SPECIAL OBJECT �
;;;;����������������ͼ
;---------
	START_PATH	e_test_0

	P_SET		hp,100
	P_RADAROBJ	ra_enemy

	P_WAIT		100

	P_GSET		w,RannyuModeSwitch,1
	P_REMOVE

	START_PATH	e_test_1

	P_END
;---------
;---------
;	START_PATH	e_auto_walker_bat
;
;	P_INVISIBLE	ON
;	P_PLAYER	1
;	P_FORCETRANSFORM	robot
;	P_PLAYER	2
;	P_FORCETRANSFORM	robot
;	P_REMOVE
;;;;;-----------
	START_PATH	e_final_map

	P_INVISIBLE	ON
	P_EXPORT	KSoundMapPtr,pbyte1	;sound_ptr init
	P_EXPORT	ebyte1,pbyte1		;switch init
	P_EXPORT	ebyte2,pbyte1		;
	P_EXPORT	ebyte3,pbyte1		;
	P_EXPORT	ebyte4,pbyte1		;
	P_EXPORT	ebyte5,pbyte1		;
	P_EXPORT	ebyte6,pbyte1		;
	P_EXPORT	ebyte7,pbyte1		;
	P_EXPORT	eword1,pword1		;
	P_DO		16			;
	P_INC		pbyte1			;
	P_CLRSWITCH	pbyte1			;
	P_INEXT					;
	P_REMOVE
;;;;------------
	START_PATH	e_andross_msg1

	P_INVISIBLE	ON
;;;;;.again
;;;;;	P_GOSUB		read_emeda
;;;;;	P_DO		16
;;;;;	P_INC		pbyte1
;;;;;	P_IFSWITCH	pbyte1,pword1,.incm
;;;;;	P_IGOTO		.nexts	
;;;;;.incm
;;;;;	P_INC		pbyte2
;;;;;.nexts
;;;;;	P_INEXT
;;;;;	P_INC		slopenum
;;;;;	P_IFNOTSAME	slopenum,4,.again
;;;;;
;;;;;	P_EXPORT	emedal_num,pbyte2

	P_WAIT		10
	P_IMPORT	pbyte1,demotaiman
	P_IFSAME	pbyte1,dt_d_sen,.d_senkan
	P_IMPORT	pbyte1,Kdifficulty
	P_IFSAME	pbyte1,dif_easy,.msg_dragon
	P_IFSAME	pbyte1,dif_hard,.msg_hard

	P_IMPORT	pbyte1,demotaiman
	P_IFSAME	pbyte1,dt_d_sen,.norm_sen_tsuika
	P_MSG		119
	P_REMOVE
.norm_sen_tsuika
	P_MSG		117
	P_REMOVE
.msg_hard
	P_IMPORT	pbyte1,demotaiman
	P_IFSAME	pbyte1,dt_d_sen,.hard_sen_tsuika
	P_MSG		85
	P_REMOVE
.hard_sen_tsuika
	P_MSG		120
	P_REMOVE
.msg_dragon
	P_MSG		112
	P_REMOVE
.d_senkan
	P_SET		pbyte1,opening_andross_msg
	P_DO		3
	P_MSG		pbyte1
	P_INC		pbyte1
	P_WAIT		30
	P_NEXT
	P_REMOVE
;.read_emeda
;	P_IFSAME	slopenum,1,.emeda2
;	P_IFSAME	slopenum,2,.emeda3
;	P_IFSAME	slopenum,3,.emeda4
;	P_IMPORT	pword1,emedal_1
;	P_RETURN
;.emeda2
;	P_IMPORT	pword1,emedal_2
;	P_RETURN
;.emeda3
;	P_IMPORT	pword1,emedal_3
;	P_RETURN
;.emeda4
;	P_IMPORT	pword1,emedal_4
;	P_RETURN

;;;;------------
;;;	START_PATH	e_starfox_msg1
;;;
;;;	P_INVISIBLE	ON
;;;	P_WAIT		8
;;;	P_SET		pbyte1,136
;;;	P_DO		6
;;;	P_MSG		pbyte1
;;;	P_WAIT		40
;;;	P_INC		pbyte1
;;;	P_NEXT
;;;	P_REMOVE
;;;;------------
;;;	START_PATH	e_ck_msg_maker
;;;
;;;	P_INVISIBLE	ON
;;;	P_DO		20
;;;	P_IMPORT	pbyte1,ebyte5
;;;	P_SETSWITCH	pbyte2,pbyte1
;;;	P_EXPORT	ebyte5,pbyte1
;;;	P_NEXT
;;;	P_CLRSWITCH	pbyte2,pbyte1
;;;	P_EXPORT	ebyte5,pbyte1
;;;.rem
;;;	P_REMOVE
;;;;;;;;-----------
;;;	START_PATH	e_msg_maker
;;;
;;;	P_TRIGGER	test_print,Always
;;;
;;;	P_INVISIBLE	ON
;;;	P_IMPORT	tx,Player_friend
;;;	P_IFSAME	tx,-1,.now_msg
;;;	P_ADD		tx,oikakero_msg_num		;boost wo tsukae
;;;	P_MSG		tx
;;;	P_DO		2
;;;	P_WAIT		100
;;;	P_NEXT
;;;	P_IMPORT	pbyte1,ebyte5
;;;	P_CLRSWITCH	pbyte2,pbyte1
;;;	P_EXPORT	ebyte5,pbyte1
;;;.now_msg
;;;	P_REMOVE
;;;;------------
;;;	START_PATH	e_fire_mark
;;;
;;;	P_QSPAWN	laser_0,egu_speed_RelElaser_suka,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_COLLISIONS	OFF
;;;	P_RANGECHECK	OFF
;;;	P_SPRITE	0,8
;;;	P_ADD		tx,ap
;;;	P_CLRTYPE	enemy1
;;;	P_SETCOLANIM	0
;;;	P_WAIT		1
;;;	P_SETCOLANIM	1
;;;	P_WAIT		1
;;;	P_REMOVE
;;;;-----------
;;;	START_PATH	egu_speed_RelElaser_suka
;;;
;;;	P_COLLISIONS	OFF
;;;	P_RANGECHECK	OFF
;;;	P_RELTOPLAYER	ON
;;;	P_ALWAYSGENVECS	ON
;;;	P_SET		childx,worldx
;;;	P_SET		childy,worldy
;;;	P_SET		childz,worldz
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SETRANDOM	pbyte1,3
;;;	P_ADD		pbyte1,-2
;;;	P_ADD		roty,pbyte1
;;;	P_SETRANDOM	pbyte1,3
;;;	P_ADD		pbyte1,-2
;;;	P_ADD		rotx,pbyte1
;;;	P_SETVEL	70
;;;	P_WAIT		1
;;;	P_SET		ox,worldx
;;;	P_SET		oy,worldy
;;;	P_SET		oz,worldz
;;;	P_NEG		childx
;;;	P_NEG		childy
;;;	P_NEG		childz
;;;	P_ADD		ox,childx
;;;	P_ADD		oy,childy
;;;	P_ADD		oz,childz
;;;	P_SETVEL	0
;;;
;;;.loop
;;;	P_DISTLESS	300,.near
;;;	P_INC		pword1
;;;	P_IFSAME	pword1,100,.rem
;;;	P_DO		2
;;;	P_ADD		worldx,ox
;;;	P_ADD		worldy,oy
;;;	P_ADD		worldz,oz
;;;	P_INEXT
;;;	P_GOTO		.loop
;;;.near
;;;	P_SETVEL	127
;;;	P_WAIT		10
;;;.rem
;;;	P_REMOVE
;;;
;;;	START_PATH	egu_speed_RelElaser
;;;
;;;	P_COLLISIONS	OFF
;;;	P_RANGECHECK	OFF
;;;
;;;.lp
;;;	P_WITHINRADIUS	300,.come
;;;.rcome
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_MOVEINPLAYER	70
;;;	P_MOVEINPLAYER	70
;;;	P_INC		pword1
;;;	P_IFSAME	pword1,100,.rem
;;;	P_GOTO		.lp
;;;.come
;;;	P_SETVEL	90
;;;	P_WAIT		10
;;;.rem
;;;	P_REMOVE
;;;;������������ͻ
;;;;� SEA OBJECT �
;;;;������������ͼ
	START_PATH	e_kozakana

	P_RADAROBJ	ra_enemy
	P_SET		hp,100
	P_SHADOW	OFF
	P_COLLISIONS	OFF
	P_GOSUB		sea_init_below
	P_SET		pbyte1,roty
	P_ZERO		roty
	P_SET		ox,-800
	P_SET		oy,-50

	P_DO		pbyte1
	P_INC		pbyte2
	P_EXPORT	gbyte1,pbyte2
	P_SPAWN		0,0,0,0,0,0,kozakana,e_kozakana_c,100,0,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_SETID		pbyte1
	P_SET		pbyte2,6
	P_SETRANDOM	pword1,255		;511
	P_ADD		pword1,-128		;256
	P_SETSWITCH	pbyte2,pword1
	P_ADD		childx,pword1
	P_SETRANDOM	pword1,255		;511
	P_ADD		pword1,-128		;256
	P_SETSWITCH	pbyte2,pword1
	P_ADD		childz,pword1
	P_SETRANDOM	pword1,127
	P_ADD		pword1,-127
	P_SETSWITCH	pbyte2,pword1
	P_ADD		childy,pword1
	P_UNBECOME
	P_INEXT

	P_ALWAYSGENVECS	ON
	P_SET		childx,worldx
	P_NEG		childx
	P_SET		childy,worldy
	P_NEG		childy
	P_SET		childz,worldz
	P_NEG		childz
	P_RTRIGGER	.kozakana_c_move,Always
.loop
	P_SETVEL	40
	P_ACCEL		10,1
	P_WAIT		30

	P_GOSUB		.mk_fish_move
	P_DO		8
	P_CHASE		roty,childroty
	P_CHASE		rotx,childrotx
	P_NEXT
	P_GOTO		.loop
;-----------
.kozakana_c_move
	P_IFLARGER	worldy,ox,.hi_ok
	P_SET		worldy,ox
	P_CHASE		rotx,0
.hi_ok
	P_IFSMALLER	worldy,oy,.hi_ok2
	P_SET		worldy,oy
.hi_ok2
	P_ADD		childx,worldx
	P_EXPORT	gword1,childx
	P_ADD		childy,worldy
	P_EXPORT	gword2,childy
	P_ADD		childz,worldz
	P_EXPORT	gword3,childz

	P_SET		childx,worldx
	P_NEG		childx
	P_SET		childy,worldy
	P_NEG		childy
	P_SET		childz,worldz
	P_NEG		childz

	P_EXPORT	gbyte1,roty
	P_EXPORT	gbyte2,rotx
	P_ZERO		pbyte2
	P_DO		pbyte1
	P_INC		pbyte2
	P_BECOMECHILD	pbyte2
	P_GADD		worldx,gword1
	P_GADD		worldy,gword2
	P_GADD		worldz,gword3
	P_IMPORT	roty,gbyte1
	P_IMPORT	rotx,gbyte2
	P_UNBECOME
	P_INEXT
	P_RETURN
;-----------

.mk_fish_move	LOCAL
	P_PUSH		roty
	P_PUSH		rotx
	P_FACEPLAYER	IMMEDIATE
	P_SET		childrotx,rotx
	P_SET		childroty,roty
	P_PULL		rotx
	P_PULL		roty
	P_SETRANDOM	childrotz,31
	P_ADD		childrotz,-16
	P_ADD		childrotx,childrotz
	P_RETURN

;------------
	START_PATH	e_kozakana_c

	P_RADAROBJ	ra_enemy
	P_SHADOW	OFF
	P_COLLISIONS	OFF
	P_GOSUB		sea_init_below
	P_RELATIVE	OFF

	P_END
;;;;-----------
;;;	START_PATH	e_sea_nocol_above_soff
;;;
;;;	P_SET		hp,100
;;;	P_CLRTYPE	enemy1
;;;	P_COLLISIONS	OFF
;;;	P_SHADOW	OFF
;;;	P_GOSUB		sea_init_above
;;;	P_END
;;;;-----------
	START_PATH	e_sea_buil_above_soff

	P_GOSUB		init_hardslope_soff
	P_GOSUB		sea_init_above
;.above_same	LOCAL
	P_END
;;;;-----------
;;;	START_PATH	e_sea_nocol_below_soff
;;;
;;;	P_SET		hp,100
;;;	P_CLRTYPE	enemy1
;;;	P_SHADOW	OFF
;;;	P_GOSUB		sea_init_below
;;;	P_END
;;;;-----------
	START_PATH	e_sea_buil_below_soff

	P_GOSUB		init_hardslope_soff
	P_GOSUB		sea_init_below
	P_END
;;;;-----------
;;;	START_PATH	e_hyouzan
;;;
;;;	P_GOSUB		sea_init_above
;;;	P_GOSUB		init_hardslope_soff
;;;
;;;	P_END
;;;	
;;;;-----------
	START_PATH	e_sea_outline

	P_SET		hp,100
	P_SHADOW	OFF
	P_COLLISIONS	OFF
	P_CLRTYPE	enemy1
	P_SET		worldy,512
	P_IMPORT	pword1,Player1_worldy
	P_SET		ox,-1000
	P_IFLARGER	pword1,ox,.again
	P_SET		worldy,-488
.again
	P_RTRIGGER	.under,BelowSea
	P_RTRIGGER	.above,AboveSea

	P_END
.under
	P_SET		worldy,512
	P_RETURN
.above
	P_SET		worldy,-488
	P_RETURN
;;;
;;;;���������������ͻ
;;;;� GROUND OBJECT �
;;;;���������������ͼ
	START_PATH	e_totem_pole

	P_GOSUB		init_hardslope_soff
	P_RANGECHECK	OFF
	P_INVISIBLE	ON
.wait_loop
	P_DISTLESS	700,.near
	P_GOTO		.wait_loop
.near
	P_INPLAYERSCONE	-20,20,.act_on
	P_GOTO		.wait_loop
.act_on
	P_SET		worldy,400
	P_CLIPPING	ON
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF

	P_SOUNDEFTDISTPOS	ob_totem_up	;$90

	P_DO		8
	P_ADD		worldy,-50
	P_NEXT
	P_CLIPPING	OFF
	P_ZERO		worldy
	P_PASSSOUND	ON
	P_END
;;;;------------
	START_PATH	e_kinoko

	P_SET		skidy,worldy
	P_ZERO		worldy
	P_GOSUB		init_hardslope
	P_SETANIM	0
	P_EXPORT	gbyte1,roty
	P_INC		roty
	P_DO		roty
	P_ADD		worldy,-20
	P_INEXT
	P_ZERO		roty
	P_EXPORT	gword1,worldy
	P_SET		pword1,-70
	P_IFSMALLER	worldy,pword1,.pass
	P_SET		shape,kinoko_dlow
.pass
	P_SPAWN		0,0,0,0,0,0,kinoko_n,e_buil_shadow_off,100,4,1
	P_BECOME
	P_IMPORT	childy,gword1
	P_NEG		childy
	P_IMPORT	animframe,gbyte1
	P_SET		pbyte1,8
	P_SETSWITCH	pbyte1,animframe
	P_UNBECOME

	P_WAIT		1
	P_IFZERO	skidy,.not_medal

	P_SET		slopenum,1
	P_RTRIGGER	.put_on,WhenSteppedOn
	P_END
.put_on
	P_FORCE		.put_medal
	P_RETURN
.put_medal
	P_TRIGGER	.put_on,OFF
	P_BECOMECHILD	1
	P_CLIPPING	ON
	P_UNBECOME
	P_SOUNDEFFECT	ob_movewall_down	;$91
.d_cont
	P_ADD		worldy,10
	P_IFZERO	worldy,.d_end
	P_GOTO		.d_cont
.d_end
	P_WAIT		5
	P_EXPORT	gbyte1,skidy
	P_GOSUB		set_medal
	P_BECOME
	P_COPYPLAYERPOS
	P_ADD		worldx,300
.ml
	P_INPLAYERSCONE	-5,5,.me
	P_CIRCLEPLAYER	5
	P_IGOTO		.ml
.me
	P_SET		worldy,-100
	P_UNBECOME
	P_REMOVE	1
	P_SCENERY
.not_medal
	P_POSCHILDREN	OFF
	P_SCENERY

;;;;------------
	START_PATH	e_for_m_iwa

	P_GOSUB		init_hardslope_soff
.col_loop
	P_WITHINRADIUS	1500,.change_id
	P_SET		coltab,id_1_c&WM
	P_GOTO		.col_loop
.change_id
	P_IFNOTZERO	pbyte1,.id_is_1
	P_SET		coltab,id_0_c&WM
	P_GOTO		.col_loop
.id_is_1
	P_SET		coltab,id_1_c&WM
	P_GOTO		.col_loop
;;;;------------
;;;	START_PATH	e_hako_lift
;;;
;;;	P_GOSUB		init_hardslope
;;;	P_SETANIM	0
;;;	P_SET		pbyte1,-2
;;;.loop
;;;	P_WAIT		60
;;;
;;;	P_DO		72
;;;	P_ADD		worldy,pbyte1
;;;	P_NEXT
;;;
;;;	P_NEG		pbyte1
;;;	P_IGOTO		.loop
;;;
;;;;------------
	START_PATH	e_hako_6
	P_INC		pbyte1
	START_PATH	e_hako_5
	P_INC		pbyte1
	START_PATH	e_hako_4
	P_INC		pbyte1
	START_PATH	e_hako_3
	P_INC		pbyte1
	START_PATH	e_hako_2
	P_INC		pbyte1
	START_PATH	e_hako_1
	P_INC		pbyte1
	START_PATH	e_hako_0
.hako_same
	P_GOSUB		col_id_ck
	P_IFSAME	shape,t_hako_1,.toson
	P_IFNOTSAME	shape,t_hako_roof,.nos
.son
	P_PASSSOUND	ON
.nos
	P_SET		pbyte2,8
	P_SETSWITCH	pbyte2,pbyte1
	P_SET		animframe,pbyte1
	P_GOSUB		init_hardslope_soff
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,5,.not_sea
	P_CLIPPING	ON
.not_sea
	P_SCENERY
.toson
	P_IFZERO	pbyte1,.son
	P_IFSAME	pbyte1,3,.son
	P_IGOTO		.nos
;;;;------------
	START_PATH	e_kowareru_box

	P_PASSSOUND	ON
	P_GOSUB		init_notinvslope
	P_SET		hp,3
	P_RTRIGGER	.kowareru_hit,WhenHit
	P_TRIGGER	hit_dead,WhenDead
	P_END
.kowareru_hit
	P_DEC		hp
	P_HITFLASHTRIG
	P_RETURN
;;;;------------
	START_PATH	e_kaifuku_panel_sea

	P_SET		pword1,-1000
	P_IFLARGER	worldy,pword1,.in_sea
	P_GOSUB		sea_init_above
	P_IGOTO		.same_live
.in_sea
	P_GOSUB		sea_init_below
.same_live

	START_PATH	e_kaifuku_panel

	P_GOSUB		init_hardslope_soff
	P_RADAROBJ	ra_HPpanel
	P_INC		slopenum
	P_SETCOLANIM	0
	P_RANGECHECK	OFF
	P_ACTIVE	ON
	P_RTRIGGER	.kaifu_ani,Always
.re_st
	P_RTRIGGER	.kaifu_on,WhenSteppedOn
	P_END
.kaifu_on
	P_DISTMORE	70,.kaifu_full
	P_FINDSHAPE	arrow_0
	P_SHAPEDEAD	.no_arrow
	P_SHAPEDISTLESS	500,.invis_arrow
.no_arrow
	P_IFPLAYERFULLHP	.kaifu_full
	P_TRIGGER	.kaifu_on,OFF
	P_FORCE		.now_kaifuku
.kaifu_full
	P_RETURN
.now_kaifuku
	P_QSPAWN	nullshape,e_kai_demo,10,10
	P_SOUNDEFFECT	shieldrecover	;$38
.keep_kaifuku
	P_GINC		b,player1_hpadd
	P_IFPLAYERFULLHP	.kaifu_end
	P_GOTO		.keep_kaifuku
.kaifu_end
	P_WAIT		10
	P_SOUNDEFFECT	leveltrig_stop	;$cc
	P_BECOMESHAPE
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_UNBECOME
	P_GOTO		.re_st

.invis_arrow
	P_BECOMESHAPE
	P_INVISIBLE	ON
	P_UNBECOME
	P_IGOTO		.no_arrow
.kaifu_ani
	P_ADDCOLANIM	1,3
	P_RETURN
;-----------
	START_PATH	e_kai_demo

	P_INVISIBLE	ON
	P_GOSUB		make_org_view
	P_PLAYERDEAD	eg_remove
	P_BEGINDEMO
	P_GOSUB		demo_zoom
.lp
	P_SETCAMERA
	P_IFPLAYERFULLHP	.kaifu_end
	P_GOTO		.lp
.kaifu_end
	P_GOSUB		back_org_view
	P_ENDDEMO
	P_REMOVE
;;;;-----------
	START_PATH	e_miss_dai_live_sea

	P_SET		pword1,-1000
	P_IFLARGER	worldy,pword1,.in_sea
	P_GOSUB		sea_init_above
	P_IGOTO		.same_live
.in_sea
	P_GOSUB		sea_init_below
.same_live
;;;;-----------
	START_PATH	e_miss_dai_live

	P_GOSUB		init_hardslope_soff
	P_RTRIGGER	.miss_dead,WhenFlagged
	P_END
.miss_dead
	P_FORCE		.col_lock
	P_RETURN
.col_lock
	P_STAMPSTART
	P_SETCOLANIM	3
	P_GOSUB		init_hardslope_soff
	P_END
;;;;-----------
;;;	START_PATH	e_miss_dai_sea
;;;	P_SET		pword1,-1000
;;;	P_IFLARGER	worldy,pword1,.in_sea
;;;	P_GOSUB		sea_init_above
;;;	P_IGOTO		.same_live
;;;.in_sea
;;;	P_GOSUB		sea_init_below
;;;.same_live
;;;	START_PATH	e_miss_dai
;;;
;;;	P_SETCOLANIM	3
;;;	P_GOSUB		init_hardslope_soff
;;;	P_END
;;;;-----------
;;;	START_PATH	e_planet_cannon
;;;
;;;	P_SET		roty,hp
;;;	P_SET		rotx,ap
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_ACTIVE	ON
;;;	P_SHADOW	OFF
;;;	P_SET		slopenum,50
;;;	P_SPAWN		0,0,130<<big_l_scale,0,0,0,big_l_f,e_pl_cannon_top,100,4,1
;;;	P_TRIGGER	.life_ck,Always
;;;	P_END
;;;.life_ck
;;;	P_IFLARGER	hp,slopenum,.life_ok
;;;	P_FORCE		.cannon_dead
;;;.life_ok
;;;	P_RETURN
;;;.cannon_dead
;;;	P_TRIGGER	.life_ck,OFF
;;;	P_COLLISIONS	OFF
;;;	P_IMPORT	pbyte1,KEnemyNumber
;;;	P_IFNOTSAME	pbyte1,1,.not_last
;;;	P_SPAWN		0,0,65<<big_l_scale,0,0,0,nullshape,e_cannon_demo_tar,100,0,2
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_GOSUB		demo_move_wait
;;;.not_last
;;;	P_SCREENFLASH
;;;	P_TRIGGER	kani_explode_big,8
;;;	P_FLAGCHILD	1
;;;	P_UNLINKCHILD	1
;;;	P_SET		pbyte1,-2
;;;	P_TRIGGER	cannon_down,Always
;;;	P_WAIT		35
;;;	P_GOSUB		many_exp_group
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCORE		sc_planet_cannon
;;;	P_CIRCLEWINDOW	1,big			;10
;;;	P_EXPLODE
;;;;-----------
;;;	START_PATH	e_pl_cannon_top
;;;
;;;	P_ACTIVE	ON
;;;	P_SHADOW	OFF
;;;	P_TRIGGER	.cannon_top_hit,WhenHit
;;;	P_TRIGGER	.cannon_dead,WhenFlagged
;;;	P_END
;;;.cannon_dead
;;;	P_FORCE		.cannon_dead_on
;;;	P_RETURN
;;;.cannon_dead_on
;;;	P_TRIGGER	.cannon_dead,OFF
;;;	P_COLLISIONS	OFF
;;;	P_SET		pbyte1,2
;;;	P_TRIGGER	cannon_down,Always
;;;	P_TRIGGER	kani_explode_big,8
;;;	P_WAIT		30
;;;	P_GOSUB		many_exp_group
;;;	P_EXPLODE
;;;
;;;.cannon_top_hit
;;;	P_ADD		hp,-100
;;;	P_EXPORT	gbyte1,hp
;;;	P_BECOMEMOTHER
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_ADD		hp,pbyte1
;;;	P_UNBECOME
;;;	P_SET		hp,100
;;;	P_RETURN
;;;;-----------
;;;	START_PATH	e_cannon_demo_tar
;;;
;;;	P_INVISIBLE	ON
;;;	P_GOSUB		make_demo_target
;;;	P_EXPORT	gword1,worldy
;;;	P_BECOME
;;;	P_SET		tx,50
;;;	P_IMPORT	pword1,gword1
;;;	P_SET		slopenum,de_for_hydra
;;;	P_UNBECOME
;;;	P_GOSUB		demo_move_wait
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,32
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_REMOVE
;;;
;;;;-----------
;;;	START_PATH	e_hit_down_dai_big
;;;	P_INC		skidy
;;;	START_PATH	e_hit_down_dai
;;;
;;;	P_SHADOW	OFF
;;;	P_GOSUB		init_notinvslope
;;;	P_TRIGGER	.shizume,WhenHitByPlayer
;;;	P_END
;;;.shizume
;;;	P_FORCE		.on
;;;	P_RETURN
;;;.on
;;;	P_TRIGGER	.shizume,OFF
;;;	P_INVINCIBLE	ON
;;;	P_CLIPPING	ON
;;;	P_SOUND		p2_shizumu	;09
;;;.big
;;;	P_DO		14
;;;	P_ADD		worldy,10
;;;	P_NEXT
;;;	P_DEC		skidy
;;;	P_WAIT		1
;;;	P_IFZERO	skidy,.big
;;;	P_SOUND		port2_stop
;;;	P_SOUNDEFTNEARPOS	en_land_L	;$76
;;;	P_END
;;;;-----------
	START_PATH	e_buil_range_off_hp

	P_SET		roty,hp

	START_PATH	e_buil_range_off

	P_GOSUB		col_id_ck	
	P_SET		skidy,worldy
	P_ZERO		worldy
	P_GOSUB		init_hardslope_soff
	P_RANGECHECK	OFF
	P_IGOTO		pe_buil_shadow_off_g.lp
	START_PATH	e_buil_shadow_off_g

	P_SET		skidy,worldy
	P_ZERO		worldy
	P_GOSUB		init_hardslope_soff
.lp	LOCAL
	P_DISTLESS	512,.off
	P_GROUNDOBJ	ON
	P_IFZERO	skidy,.nashi
	P_IMPORT	pbyte1,ebyte7
	P_CLRSWITCH	skidy,pbyte1
	P_EXPORT	ebyte7,pbyte1
.nashi
	P_GOTO		.lp
.off
	P_DISTMORE	600,.lp
	P_GROUNDOBJ	OFF
	P_IFZERO	skidy,.nashi_2
	P_IMPORT	pbyte1,ebyte7
	P_SETSWITCH	skidy,pbyte1
	P_EXPORT	ebyte7,pbyte1
.nashi_2
	P_GOTO		.off
;------------
	START_PATH	e_buil_shadow_off_c
	P_RTRIGGER	.m_dead,WhenFlagged
	P_IGOTO		pe_buil_shadow_off.enter
.m_dead
	P_FORCE		.exp
	P_RETURN
.exp
	P_EXPLODE

	START_PATH	e_buil_shadow_off

	P_GOSUB		col_id_ck

	P_IFSAME	shape,hako_dai,.son
	P_IFNOTSAME	shape,t_hako_roof,.enter
.son
	P_PASSSOUND	ON
.enter	LOCAL
	P_GOSUB		init_hardslope_soff
	P_END
;;;;-----------
	START_PATH	e_building

	P_IFSAME	shape,michi_1,.passsou
	P_IFSAME	shape,yama_0_0,.passsou
	P_PASSSOUND	ON
.passsou
	P_GOSUB		init_hardslope
	P_SETANIM	0
	P_END
;;;;-----------
;;;	START_PATH	e_inert_nocol_soff
;;;
;;;	P_BECOMEINERT
;;;	P_IGOTO		pe_nocol_s_off.inert_start
;;;;-----------
;;;	START_PATH	e_cyou_center
;;;
;;;	P_INVISIBLE	ON
;;;	P_IGOTO		pe_nocol_s_off.inert_start
;;;;-----------
	START_PATH	e_nocol_range_off

	P_SET		hp,100
	P_COLLISIONS	OFF
	P_RANGECHECK	OFF
	P_SHADOW	OFF

	P_END
;;;;-----------
	START_PATH	e_nocol_s_off_g

	P_GROUNDOBJ	ON

	START_PATH	e_nocol_s_off

	P_GOSUB		col_id_ck

;;;.inert_start	LOCAL
	P_SHADOW	OFF
	P_IFSAME	shape,kabe_to3,.son
	P_IFSAME	shape,kabe_to4,.son
	P_IFSAME	shape,kabe_to5,.son
	P_IGOTO		.noson
.son
	P_PASSSOUND	ON
.noson
;-----------
	START_PATH	e_nocolobj

.st	LOCAL
	P_SET		hp,100
	P_COLLISIONS	OFF
	P_CLRTYPE	enemy1
	P_RANGECHECK	ON

	P_SCENERY
;;;;-----------
	START_PATH	e_ike_0

	P_POOL		-1
	P_GOSUB		init_hardslope_soff
	P_SCENERY
;--------------
	START_PATH	e_invincible_obj

	P_HITFLASH	OFF
	P_TRIGGER	shield_base_hit_msg,WhenHitByPlayer
.lp
	P_SET		hp,100
	P_GOTO		.lp
	P_END

;;;;�����������ͻ
;;;;� MY WEAPON �
;;;;�����������ͼ
;;;	START_PATH	e_eplasma_hou
;;;
;;;	P_WEAPON	Eplasma1
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_FIRE
;;;	P_REMOVE
;;;;;;;�����������������������ͻ
;;;;;;;� SOFTWARE SPRITE SMOKE �
;;;;;;;�����������������������ͼ
;;;;;;dandou_smoke
;;;;;;	P_SOUNDEFTDISTPOS	en_wormappear	;$7f
;;;;;;	P_QSPAWN	smoke,e_sp_smoke,100,60
;;;;;;	P_BECOME
;;;;;;	P_ZERO		worldy
;;;;;;	P_ACTIVE	ON
;;;;;;	P_INC		slopenum
;;;;;;	P_UNBECOME
;;;;;;	P_RETURN
;;;;;;;------------
;;;	START_PATH	e_sp_randomsize_smoke
;;;	P_SETRANDOM	ap,31
;;;
;;;	START_PATH	e_sp_smoke
;;;.start	LOCAL
;;;	P_COLLISIONS	OFF
;;;	P_RANGECHECK	OFF
;;;	P_CLRTYPE	enemy1
;;;	P_SPRITE	0,8
;;;	P_ADD		tx,ap
;;;	P_IGOTO		pe_sp_explosion.same
;;;;;;;------------
;;;;;;	START_PATH	e_sp_smoke_up
;;;;;;
;;;;;;	P_IMPORT	pbyte1,KGameMapPtr
;;;;;;	P_IFNOTSAME	pbyte1,5,.not_sea
;;;;;;	P_IMPORT	pword1,Player1_Worldy
;;;;;;	P_IFNOTBETWEEN	-1000,pword1,0,.not_sea
;;;;;;	P_REMOVE
;;;;;;.not_sea
;;;;;;	P_SPRITE	0,4
;;;;;;	P_ADD		tx,ap
;;;;;;	P_SET		pbyte1,hp
;;;;;;	P_NEG		pbyte1
;;;;;;	P_COLLISIONS	OFF
;;;;;;	P_RANGECHECK	OFF
;;;;;;	P_TRIGGER	.smoke_up,Always
;;;;;;	P_SETCOLANIM	0
;;;;;;	P_WAIT		1
;;;;;;	P_DO		7
;;;;;;	P_ADDCOLANIM	1,8
;;;;;;	P_INC		tx
;;;;;;	P_NEXT
;;;;;;	P_REMOVE
;;;;;;.smoke_up
;;;;;;	P_ADD		worldy,pbyte1
;;;;;;	P_RETURN
;;;;;;;------------ NAGAKU TANABIKU SMOKE and EXPLOSION
;;;	START_PATH	e_noroshi_maker_noex
;;;	P_ACTIVE	ON
;;;	P_INVISIBLE	ON
;;;.loop
;;;	P_QSPAWN	smoke,e_smoke,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_WAIT		15
;;;	P_GOTO		.loop
;;;;-------------------------------------
;;;	START_PATH	e_noroshi_maker
;;;
;;;	P_ACTIVE	ON
;;;	P_INVISIBLE	ON
;;;.loop
;;;	P_QSPAWN	smoke,e_noroshi_smoke,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_WAIT		15
;;;	P_GOTO		.loop
;;;;;;;------------
;;;	START_PATH	e_sos_almost
;;;
;;;	P_ACTIVE	ON
;;;	P_IMPORT	childx,Player1_worldx
;;;	P_IMPORT	childy,Player1_worldy
;;;	P_IMPORT	childz,Player1_worldz
;;;	P_DO		hp
;;;	P_CHASE		worldx,childx
;;;	P_CHASE		worldy,childy
;;;	P_CHASE		worldz,childz
;;;	P_INEXT
;;;;---------
;;;	START_PATH	e_noroshi_smoke
;;;
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,10	;32
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;;------------ NAGAKU TANABIKU SMOKE
;;;	START_PATH	e_smoke
;;;
;;;	P_SPRITE	0,16
;;;	P_RANGECHECK	OFF
;;;	P_COLLISIONS	OFF
;;;	P_TRIGGER	.make_big,Always
;;;
;;;	P_SETCOLANIM	0
;;;
;;;	P_DO		3
;;;	P_DO		4
;;;	P_ADDCOLANIM	1,8
;;;	P_NEXT
;;;	P_DO		4
;;;	P_ADDCOLANIM	-1,8
;;;	P_NEXT
;;;	P_NEXT
;;;
;;;	P_WAIT		1
;;;	P_DO		7
;;;	P_ADDCOLANIM	1,8
;;;	P_NEXT
;;;	P_REMOVE
;;;.make_big
;;;	P_ADD		worldy,-20
;;;	P_ADD		worldx,ap
;;;	P_INC		tx
;;;	P_INC		tx
;;;	P_RETURN
;;;;;;;-----------
;;;;;;make_noroshi_smoke
;;;;;;	P_QSPAWN	smoke,e_smoke,100,5
;;;;;;	P_BECOME
;;;;;;	P_ACTIVE	ON
;;;;;;	P_UNBECOME
;;;;;;	P_RETURN
;;;;;;;-----------
;;;;;;make_noroshi_buble
;;;;;;	P_SET		childrotx,-30
;;;;;;	P_DO		2
;;;;;;	P_EXPORT	gbyte1,childrotx
;;;;;;	P_ADD		childrotx,60
;;;;;;	P_QSPAWN	bubble,e_bubble,10,5
;;;;;;	P_BECOME
;;;;;;	P_IMPORT	pbyte2,gbyte1
;;;;;;	P_ADD		worldy,pbyte2
;;;;;;	P_ACTIVE	ON
;;;;;;	P_UNBECOME
;;;;;;	P_INEXT
;;;;;;	P_RETURN
;;;;;;;-----------
;;;	START_PATH	e_bubble
;;;
;;;	P_SPRITE	0,2
;;;	P_RANGECHECK	OFF
;;;	P_COLLISIONS	OFF
;;;	P_CLIPPING	ON
;;;	P_SET		pbyte1,hp
;;;	P_TRIGGER	.make_big,Always
;;;
;;;	P_DO		25
;;;	P_ADDCOLANIM	1,2
;;;	P_NEXT
;;;	P_REMOVE
;;;.make_big
;;;	P_ADD		worldy,-30
;;;	P_ADD		worldx,pbyte2
;;;	P_ADD		tx,pbyte1
;;;	P_NEG		pbyte1
;;;	P_NEG		pbyte2
;;;	P_INC		tx
;;;	P_RETURN
