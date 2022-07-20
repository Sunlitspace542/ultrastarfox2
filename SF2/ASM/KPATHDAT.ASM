;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         KPATHDAT.ASM                                        ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  Path Data                                           ;
; DATE CREATED: 22-3-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
;***** EXTERN *****
	incpub	kpathdat


;-------
;-------
;------- KARIMASU BY EGUCHI
;-------
;-------
teach_boost_msg_num	equ	26
teach_henkei_msg_num	equ	56
pinchi1_msg_num	equ	16
pinchi2_msg_num	equ	17
corneria_he_ike_msg	equ	38
modore_msg		equ	50
oikakero_msg_num	equ	32
opening_andross_msg	equ	23
base_hit_muda_num	equ	68
shieldbase_hit_muda_num	equ	74
hajimete_maguma_msg	equ	62


st_fall
	P_TRIGGER	fall,Timer,250
	P_RETURN
ochiru_msg
	P_PUSH		pword1
	P_PUSH		pbyte1
	P_PUSH		weapontype
	P_IMPORT	pword1,KW_MisMapFlag
	P_SET		pbyte1,ef_missilefell
	P_SETSWITCH	pbyte1,pword1
	P_EXPORT	KW_MisMapFlag,pword1
	P_IMPORT	weapontype,Player_friend
	P_IFSAME	weapontype,-1,.no_friend
	P_SET		pword1,146
	P_ADD		pword1,weapontype
	P_MSG		pword1
.no_friend
	P_PULL		weapontype
	P_PULL		pbyte1
	P_PULL		pword1
	P_RETURN
;-----------
inseki_ck
	P_IMPORT	pbyte1,KX_NEARPLANETNUM
	P_IFNOTSAME	pbyte1,7,.cut_in_ck
	P_IMPORT	pbyte1,KEnemyNumber
	P_SET		pbyte2,2
	P_IFLARGER	pbyte1,pbyte2,.in_oosugi
	P_QSPAWN	nullshape,mk_big_inseki,10,10
.cut_in_ck
	P_TRIGGER	inseki_ck,OFF
.in_oosugi
	P_RETURN
expo_world
	P_EXPORT	gword1,worldx
	P_EXPORT	gword2,worldy
	P_EXPORT	gword3,worldz
	P_RETURN
impo_world
	P_IMPORT	worldx,gword1
	P_IMPORT	worldy,gword2
	P_IMPORT	worldz,gword3
	P_RETURN
impo_xz_world
	P_IMPORT	worldx,gword1
	P_IMPORT	worldz,gword2
	P_RETURN
enemy_hp_meter_hydra
	P_PUSH		hp
	P_ADD		hp,-40
	P_DIV2		hp
	P_EXPORT	bossmaxhp,hp
	P_EXPORT	bossHP,hp
	P_PULL		hp
	P_RTRIGGER	meterhit_hydra,WhenHit
	P_RETURN
meterhit_hydra
	P_PUSH		hp
	P_ADD		hp,-40
	P_IFNOTSAME	hp,1,.sonomama
	P_INC		hp
.sonomama
	P_DIV2		hp
	P_EXPORT	bossHP,hp
	P_PULL		hp
	P_RETURN
enemy_hp_meter
	P_ADD		hp,-50
	P_EXPORT	bossmaxhp,hp
	P_EXPORT	bossHP,hp
	P_ADD		hp,50
	P_RTRIGGER	.meterhit,WhenHit
	P_RETURN
.meterhit
	P_ADD		hp,-50
	P_EXPORT	bossHP,hp
	P_ADD		hp,50
	P_RETURN

missile_count
	P_GINC		w,ecountmissile
	P_GOSUB		dec_EEnemyNumber_skidy
	P_GDEC		b,KEnemyNumber
	P_RETURN

fighter_count_gset
	P_GSET		b,eaction1,255
fighter_count
	P_SCREENFLASH
	P_GOSUB		dec_EEnemyNumber_skidy
fighter_count_baku
	P_CLRDEMOSHAPE
fighter_count_wolf
	P_GINC		w,ecountfighter
	P_GDEC		b,KEnemyNumber
	P_RETURN

;----------
count_medal
	P_IMPORT	pbyte1,KDifficulty
	P_IFSAME	pbyte1,dif_easy,.c_easy
	P_IFSAME	pbyte1,dif_normal,.c_normal
	P_GINC		b,emedalhard
	P_RETURN
.c_normal
	P_GINC		b,emedalnormal
	P_RETURN
.c_easy
	P_GINC		b,emedaleasy
	P_RETURN
;------------
crose_door_wait
	P_INVINCIBLE	ON
	P_SET		coltab,black_c&wm
.wlp
	P_IMPORT	pbyte2,ebyte2
	P_IFSAME	pbyte2,255,.act
	P_GOTO		.wlp
.act
	P_SET		coltab,id_0_c&wm
	P_INVINCIBLE	OFF
	P_RETURN
;------------
pause_ck
	P_PUSH		pbyte1
	P_PUSH		pword1
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFNOTSAME	pbyte1,1,.not_last
	P_IMPORT	pword1,KW_GAMEFLAG
	P_SET		pbyte1,ef_pausedisable
	P_SETSWITCH	pbyte1,pword1
	P_EXPORT	KW_GAMEFLAG,pword1
;;;;	P_TRIGGER	pause_ck,OFF
.not_last
	P_PULL		pword1
	P_PULL		pbyte1
	P_RETURN
;------------
mk_big_senkan
	P_GSET		b,gbyte1,0
	P_DO		5
	p_spawn	0,0,0,0,0,0,nullshape,gd_d_sen_parts,1,1,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childz,d_sen_c_zz,pbyte1
	P_INDEX		shape,d_sen_c_ss,pbyte1
	P_INC		pbyte1
	P_SETID		pbyte1
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
	P_BECOME
	P_SET		childy,-55<<d_sens_scale
	P_UNBECOME
	P_RETURN

make_bit
	P_ADD		skidy,7
	P_EXPORT	gbyte1,skidy
	P_ADD		skidy,-7
	P_IFSAME	ap,1,.make1
	P_IFSAME	ap,2,.make2
	P_IFSAME	ap,3,.make3
	P_SPAWN		500<<2,0,0,0,0,0,kieru_0,e_bit_kieru,100,0,2
	P_GOSUB		.beco
.make3
	P_SPAWN		-500<<2,0,0,0,0,0,kieru_0,e_bit_kieru,100,0,3
	P_GOSUB		.beco
.make2
	P_SPAWN		0,0,500<<2,0,0,0,kieru_0,e_bit_kieru,100,128,4
	P_GOSUB		.beco
.make1
	P_SPAWN		0,0,-500<<2,0,0,0,kieru_0,e_bit_kieru,100,128,5
	P_GOSUB		.beco
	P_RETURN
.beco
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_GINC		b,gbyte1
	P_RETURN
col_id_ck
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,playerctlmode
	P_IFNOTSAME	pbyte1,map_room,.chigau
	P_IMPORT	pbyte1,KGameMapPtr	;file shitei
	P_IFSAME	pbyte1,2,.magu
	P_IFSAME	pbyte1,5,.umi
	P_IGOTO		.chigau
.umi
	P_SET		coltab,id_3_c
	P_IGOTO		.chigau
.magu
	P_SET		coltab,id_2_c
.chigau
	P_PULL		pbyte1
	P_RETURN
;
;;;;-----------
;;;	START_PATH	e_medal_num
;;;
;;;	P_COLLISIONS	OFF
;;;	P_IMPORT	pbyte1,emedal_num
;;;	P_SET		pbyte1,10
;;;	P_IFNOTBETWEEN	-1,pbyte1,10,.futaketa
;;;
;;;	P_PRINT		pbyte1,d,eguchi
;;;	P_END
;;;.futaketa
;;;	P_SET		pbyte2,d,eguchi
;;;	P_PRINT		pbyte2,d,eguchi
;;;	P_END
;;;;------------
	START_PATH	e_hom_c

	P_COLLISIONS	OFF
.lp
	P_SETCOLANIM	2
	P_WAIT		1
	P_SETCOLANIM	3
	P_GOTO		.lp
	P_END
;-----------
	START_PATH	e_explain_core2

	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_SPAWN		0,0,0,0,0,0,kaku5_0,e_explain_shape,10,10,2
	P_SPAWN		0,-20<<kaku_scale,0,0,0,0,kaku_0_c,e_explain_shape,10,10,3
	P_END
;;;;------------
	START_PATH	e_toge_dama

	P_INVINCIBLE	ON
	P_SLOPE		ON
	P_RANGECHECK	ON
	P_END
;;;;ษอออออออออออออออออออออออป
;;;;บ SOFTWARE SPRITE SMOKE บ
;;;;ศอออออออออออออออออออออออผ
;;;dandou_smoke
;;;	P_SOUNDEFTDISTPOS	en_wormappear	;$7f
;;;	P_QSPAWN	smoke,e_sp_smoke,100,60
;;;	P_BECOME
;;;	P_ZERO		worldy
;;;	P_ACTIVE	ON
;;;	P_INC		slopenum
;;;	P_UNBECOME
;;;	P_RETURN
;;;;------------
	START_PATH	mk_big_inseki

	P_GSET		b,emeteohit,0
	P_INVISIBLE	ON
	P_COPYPLAYERPOS
	P_ADD		worldx,20000
	P_RTRIGGER	.d_pw1,Always
.lp
	P_IMPORT	worldy,PLayer1_worldy
	P_DISTMORE	20000,.far
	P_MOVEINPLAYER	-100
.far
	P_INPLAYERSCONE -10,10,.in
	P_CIRCLEPLAYER	10
	P_GOTO		.lp
.in
	P_IFNOTZERO	pword1,.aru
	P_QSPAWN	bigmeteo,e_big_meteo,100,4
	P_SETRANDOM	pword1,63
	P_ADD		pword1,45
.aru
	P_GOTO		.lp
.d_pw1
	P_IFZERO	pword1,.z
	P_DEC		pword1
.z
	P_RETURN
;------
	START_PATH	e_big_meteo

	P_COLLISIONS	OFF
	P_SPRITE	0,2
	P_RTRIGGER	.speed,Always

	P_DO		70
	P_WAIT		1
	P_INC		tx
	P_NEXT
;	P_WAIT		30
	P_REMOVE
.speed
	P_IMPORT	vx,Player1_vx
	P_NEG		vx
	P_IMPORT	vz,Player1_vz
	P_NEG		vz
	P_DO		4
	P_ADD		vx,vx
	P_ADD		vz,vz
	P_INEXT
	P_DISTLESS	1500,.rem
	P_RETURN
.rem
	P_IMPORT	pbyte1,emeteohit
	P_IFSAME	pbyte1,1,.pass
	P_COLLISIONS	ON
.pass
	P_FORCE		eg_remove
	P_RETURN
;.eg_remove
;	P_REMOVE
;;;;------------
	START_PATH	e_sp_randomsize_smoke
	P_SETRANDOM	ap,31

	START_PATH	e_sp_smoke
.start	LOCAL
	P_COLLISIONS	OFF
;;	P_RANGECHECK	OFF
	P_CLRTYPE	enemy1
	P_SPRITE	0,8
	P_ADD		tx,ap
	P_IGOTO		pe_sp_explosion.same
;;;;------------
;;;	START_PATH	e_sp_smoke_up
;;;
;;;	P_IMPORT	pbyte1,KGameMapPtr
;;;	P_IFNOTSAME	pbyte1,5,.not_sea
;;;	P_IMPORT	pword1,Player1_Worldy
;;;	P_IFNOTBETWEEN	-1000,pword1,0,.not_sea
;;;	P_REMOVE
;;;.not_sea
;;;	P_SPRITE	0,4
;;;	P_ADD		tx,ap
;;;	P_SET		pbyte1,hp
;;;	P_NEG		pbyte1
;;;	P_COLLISIONS	OFF
;;;	P_RANGECHECK	OFF
;;;	P_TRIGGER	.smoke_up,Always
;;;	P_SETCOLANIM	0
;;;	P_WAIT		1
;;;	P_DO		7
;;;	P_ADDCOLANIM	1,8
;;;	P_INC		tx
;;;	P_NEXT
;;;	P_REMOVE
;;;.smoke_up
;;;	P_ADD		worldy,pbyte1
;;;	P_RETURN
;;;;------------ NAGAKU TANABIKU SMOKE and EXPLOSION
	START_PATH	e_noroshi_maker_noex
	P_ACTIVE	ON
	P_INVISIBLE	ON
.loop
	P_QSPAWN	smoke,e_smoke,100,0
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_WAIT		15
	P_GOTO		.loop
;-------------------------------------
	START_PATH	e_noroshi_maker

	P_ACTIVE	ON
	P_INVISIBLE	ON
.loop
	P_QSPAWN	smoke,e_noroshi_smoke,100,0
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_WAIT		15
	P_GOTO		.loop
;;;;------------
	START_PATH	e_noroshi_smoke_nos

	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,1,10	;32
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_IGOTO		pe_noroshi_smoke.enter
;;;;------------
	START_PATH	e_sos_almost

	P_ACTIVE	ON
	P_IMPORT	childx,Player1_worldx
	P_IMPORT	childy,Player1_worldy
	P_IMPORT	childz,Player1_worldz
	P_DO		hp
	P_CHASE		worldx,childx
	P_CHASE		worldy,childy
	P_CHASE		worldz,childz
	P_INEXT
;---------
	START_PATH	e_noroshi_smoke

	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,10	;32
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
.enter	LOCAL
;------------ NAGAKU TANABIKU SMOKE
	START_PATH	e_smoke

	P_SPRITE	0,16
;	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_RTRIGGER	.make_big,Always

	P_SETCOLANIM	0

	P_DO		3
	P_DO		4
	P_ADDCOLANIM	1,8
	P_NEXT
	P_DO		4
	P_ADDCOLANIM	-1,8
	P_NEXT
	P_NEXT

	P_WAIT		1
	P_DO		7
	P_ADDCOLANIM	1,8
	P_NEXT
	P_REMOVE
.make_big
	P_ADD		worldy,-20
	P_ADD		worldx,ap
	P_INC		tx
	P_INC		tx
	P_RETURN
;;;;-----------
;;;make_noroshi_smoke
;;;	P_QSPAWN	smoke,e_smoke,100,5
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_RETURN
;;;;-----------
;;;make_noroshi_buble
;;;	P_SET		childrotx,-30
;;;	P_DO		2
;;;	P_EXPORT	gbyte1,childrotx
;;;	P_ADD		childrotx,60
;;;	P_QSPAWN	bubble,e_bubble,10,5
;;;	P_BECOME
;;;	P_IMPORT	pbyte2,gbyte1
;;;	P_ADD		worldy,pbyte2
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_RETURN
;;;;-----------
	START_PATH	e_bubble

	P_SPRITE	0,2
	P_COLLISIONS	OFF
	P_CLIPPING	ON
	P_SET		pbyte1,hp
	P_TRIGGER	.make_big,Always

	P_DO		25
	P_ADDCOLANIM	1,2
	P_NEXT
	P_REMOVE
.make_big
	P_ADD		worldy,-30
	P_ADD		worldx,pbyte2
	P_ADD		tx,pbyte1
	P_NEG		pbyte1
	P_NEG		pbyte2
	P_INC		tx
	P_RETURN
;;;;ษอออออออออออออออออออออออออป
;;;;บ SOFTWARE SPRITE SPARK   บ
;;;;ศอออออออออออออออออออออออออผ
;;;;-----------
	START_PATH	e_sp_spark_core

	P_SOUNDEFTDISTPOS	ob_damege_spark	;$96
	P_INC		slopenum
	P_IGOTO		pe_sp_spark.sou_enter

	START_PATH	e_sp_spark

	P_SOUNDEFTNEARPOS	en_plasma	;$83
.sou_enter	LOCAL
	P_SPRITE	0,8
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLRTYPE	enemy1
	P_ADD		tx,ap
	P_SETCOLANIM	0
	P_WAIT		1
	P_DO		hp
	P_ADDCOLANIM	1,2
	P_INC		pbyte1
	P_IFNOTSAME	pbyte1,4,.nos
	P_IFNOTZERO	slopenum,.c_sou
	P_SOUNDEFTNEARPOS	en_plasma	;$83
	P_IGOTO		.nos
.c_sou
	P_SOUNDEFTDISTPOS	ob_damege_spark	;$96
.nos
	P_NEXT
	P_REMOVE
;;;
;;;;ษอออออออออออออออออออออออออป
;;;;บ SOFTWARE SPRITE SPLASH  บ
;;;;ศอออออออออออออออออออออออออผ
	START_PATH	e_sp_stay_splash

	P_SPRITE	0,1
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLRTYPE	enemy1
	P_ADD		tx,hp
	P_TRIGGER	.rand_anim,32
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,5,.re_set
	P_GOSUB		sea_init_above
.re_set
	P_SET		colframe,ap
	P_END
.rand_anim
	P_RANDOMGOTO	.pass
	P_FORCE		.anim_on
.pass
	P_RETURN
.anim_on
	P_DEC		colframe
	P_WAIT		1
	P_INC		colframe
	P_RANDOMGOTO	.re_set
	P_GOTO		.anim_on
;;;
;;;	P_END
;;;;-----------
;;;	START_PATH	e_sp_splash_cont
;;;
;;;	P_INC		skidy
;;;
;----------
	START_PATH	e_sp_splash_in

	P_SOUNDEFTDISTPOS	en_inmarine	;$88
	P_IGOTO		pe_sp_splash.enter	
;----------
	START_PATH	e_sp_splash_out

	P_SOUNDEFTDISTPOS	en_outmarine	;$89

;----------
	START_PATH	e_sp_splash
.enter	LOCAL
	P_SPRITE	0,8
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLRTYPE	enemy1
	P_ADD		tx,ap
	P_SETCOLANIM	0
	P_WAIT		1
	P_DO		hp
	P_ADDCOLANIM	1,8
	P_NEXT
	P_REMOVE
;;;;ษออออออออออออออออออออออออออออป
;;;;บ SOFTWARE SPRITE KIRAKIRA   บ
;;;;ศออออออออออออออออออออออออออออผ
	START_PATH	e_kira_maker
	P_INVISIBLE	ON
	P_CLRTYPE	enemy1
	P_DO		ap
	P_EXPORT	gbyte1,hp
	P_QSPAWN	kirakira,e_sp_kirakira,100,0
	P_BECOME
	P_ACTIVE	ON
	P_IMPORT	ap,gbyte1
	P_UNBECOME
	P_WAIT		2
	P_NEXT
	P_REMOVE
;-----------
	START_PATH	e_sp_kirakira

	P_SPRITE	0,8
	P_ADD		tx,ap
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLRTYPE	enemy1
	P_TRIGGER	.fall,Always

	P_SETRANDOM	pbyte1,63
	P_ADD		pbyte1,-32
	P_ADD		worldx,pbyte1

	P_SETRANDOM	pbyte1,63
	P_ADD		pbyte1,-32
	P_ADD		worldy,pbyte1

	P_SETRANDOM	pbyte1,63
	P_ADD		pbyte1,-32
	P_ADD		worldz,pbyte1

	P_WAIT		13

	P_REMOVE
.fall
	P_INC		pbyte2
	P_ADD		worldy,pbyte2
	P_DEC		tx
	P_RETURN
;;;;ษออออออออออออออออออออออออออออป
;;;;บ SOFTWARE SPRITE EXPLOSIONS บ
;;;;ศออออออออออออออออออออออออออออผ
	START_PATH	e_sp_explosion_stay_apsize

	P_INC		pbyte2
	P_IGOTO		pe_sp_explosion.start
;;;;-----------
	START_PATH	e_sp_bigrandom_explosion

	P_SETRANDOM	pbyte1,31
	P_ADD		ap,pbyte1
	P_IGOTO		pe_sp_explosion.start
;------------
	START_PATH	e_sp_randomsize_explosion

	P_SETRANDOM	ap,15

	START_PATH	e_sp_explosion

.start	LOCAL
	P_IFROBOT	.not_vec
	P_IFUFO		.not_vec
	P_TRIGGER	player_vec_neg,ALways
.not_vec
	P_COLLISIONS	OFF
;	P_RANGECHECK	OFF
	P_CLRTYPE	enemy1
	P_SPRITE	0,8
	P_ADD		tx,ap
	P_SET		pbyte1,17

	P_IFSAME	hp,1,.same

	P_IFLARGER	tx,pbyte1,.big_sound
	P_SOUNDEFTDIST	en_explode_demo	;$8b
;	P_SOUNDEFFECT	en_explode_demo	;$8b
	P_IGOTO		.same
.big_sound
	P_SOUNDEFTDIST	en_explode_s	;$70
;	P_SOUNDEFFECT	en_explode_s	;$70

.same	LOCAL
	P_IFSAME	pbyte2,1,.stay
	P_INC		slopenum

	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64

	P_DO		slopenum
	P_ADD		worldx,pbyte1
	P_INEXT

	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64
	P_DO		slopenum
	P_ADD		worldy,pbyte1
	P_INEXT

	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64

	P_DO		slopenum
	P_ADD		worldz,pbyte1
	P_INEXT
.stay
	START_PATH	e_smoke_simple

	P_COLLISIONS	OFF

	P_SETCOLANIM	0
	P_WAIT		1
	P_DO		7
	P_ADDCOLANIM	1,8
	P_NEXT

	P_REMOVE
player_vec_neg
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,Player1_vx
	P_ADD		pbyte1,pbyte1
	P_NEG		pbyte1
	P_ADD		worldx,pbyte1
	P_IMPORT	pbyte1,Player1_vz
	P_ADD		pbyte1,pbyte1
	P_NEG		pbyte1
	P_ADD		worldz,pbyte1
	P_PULL		pbyte1
	P_RETURN
;;;;ษอออออออออออออออออออออออป
;;;;บ SOFTWARE SPRITE BOOST บ
;;;;ศอออออออออออออออออออออออผ
	START_PATH	e_friend_boost

	P_SPRITE	0,2
	P_IGOTO		pe_sp_boost.enter
;---------
	START_PATH	e_sp_boost_hp
	P_INC		skidy
	START_PATH	e_sp_boost

	P_ACTIVE	ON
	P_SPRITE	0,8
	P_ADD		tx,ap
.enter	LOCAL
	P_ACTIVE	ON
	P_COLLISIONS	OFF
	P_RANGECHECK	OFF
	P_CLRTYPE	enemy1

.again_on
	P_TRIGGER	.inv_on,WhenFlagged

	P_SETCOLANIM	0
	P_DO		3
	P_ADDCOLANIM	1,4
	P_NEXT
	P_WAIT		1
	P_IFNOTZERO	skidy,.hp_loop
.loop
	P_SETCOLANIM	0
	P_WAIT		1
	P_SETCOLANIM	1
	P_GOTO		.loop
.inv_on
	P_INVISIBLE	ON
	P_FORCE		.wait_inv_off
	P_RETURN
.wait_inv_off
	P_TRIGGER	.inv_on,OFF
	P_CLEARSTACK
	P_TRIGGER	.inv_off,WhenFlagged
	P_END
.inv_off
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_FORCE		.to_again_on
	P_RETURN
.to_again_on
	P_TRIGGER	.inv_off,OFF
	P_IGOTO		.again_on
.hp_loop
	P_DO		hp
	P_SETCOLANIM	0
	P_WAIT		1
	P_SETCOLANIM	1
	P_NEXT
	P_REMOVE
;;;;ษอออออป
;;;;บ SUB บ
;;;;ศอออออผ
roll_msg_tri
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,ebyte1
	P_IFNOTZERO	pbyte1,.nn_easy
	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.nn_easy
	P_ADD		pbyte1,198
	P_MSG		pbyte1
	P_GSET		b,ebyte1,60
.nn_easy
	P_PULL		pbyte1
	P_RETURN
;------------
mk_gattai_enban
	P_GSET		b,gbyte1,0
	P_DO		6
	P_SPAWN		0,0,0,0,0,0,enban_0,e_enban_c,4,4,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childx,enban_cx_tab,pbyte1
	P_INDEX		childz,enban_cz_tab,pbyte1
	P_INDEX		childroty,enban_ry_tab,pbyte1
	P_INC		pbyte1
	P_SETID		pbyte1
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
	P_RETURN
;------------
mk_toge
	P_SPAWN		40<<tate_m_scale,-90<<tate_m_scale,0,0,-64,0,tate_m_1,e_tate_m_c,10,1,1
	P_SPAWN		-40<<tate_m_scale,-90<<tate_m_scale,0,0,64,0,tate_m_1,e_tate_m_c,10,2,2
	P_SPAWN		0,90<<tate_m_scale,40<<tate_m_scale,0,0,128,tate_m_1,e_tate_m_c,10,3,3
	P_SPAWN		0,90<<tate_m_scale,-40<<tate_m_scale,0,128,128,tate_m_1,e_tate_m_c,10,4,4
	P_RETURN
;------------
kirai_maku
	P_QSPAWN	dokuro,e_kirai,10,10
	P_RETURN
;------------
make_demo_target
	P_QSPAWN	demo_target,e_r_demo_target,100,0
;;;make_demo_worm
	P_BECOME
	P_INVISIBLE	ON
	P_INVINCIBLE	ON
	P_UNBECOME
;;;make_demo_kani
	P_QSPAWN	nullshape,e_robo_demo,100,0
	P_ACTIVE	ON
	P_RETURN
;------------
teach_henkei
	P_IFNOTZERO	skidy,.ret
	P_IFNOTZERO	childrotx,.ret
	P_IMPORT	slopenum,ebyte1
	P_IFNOTZERO	slopenum,.retr
	P_SET		slopenum,60
	P_EXPORT	ebyte1,slopenum
	P_SET		slopenum,teach_henkei_msg_num		;henkeishiro msg56
	P_ADD		slopenum,ty
	P_MSG		slopenum
	P_SET		childrotx,3
.ret
	P_DEC		childrotx
.retr
	P_RETURN
;------------
shock_midc
	P_SOUNDEFTDIRECT	ob_core_thud,midC	;$b8
	P_SHOCKCAM	1,128
	P_RETURN
shock_efe
	P_SOUNDEFFECT	ob_core_thud	;$b8
	P_SHOCKCAM	1,128
	P_RETURN
;--------------------
set_medal
	P_QSPAWN	medal,e_omake_medal,99,10
	P_BECOME
	P_IMPORT	roty,gbyte1
	P_UNBECOME
	P_RETURN
;;;;---------------- INIT SLOPE
make_boost
	P_DO		pbyte2
	P_EXPORT	gbyte1,pbyte1
	P_EXPORT	gword1,pword1
	P_SPAWN		0,0,0,0,0,0,boost,e_sp_boost,100,0,9
	P_BECOME
	P_IMPORT	pbyte1,gbyte2
	P_SETID		pbyte1
	P_INC		pbyte1
	P_EXPORT	gbyte2,pbyte1
	P_DEC		pbyte1
	P_IMPORT	ap,gbyte1
	P_IMPORT	childz,gword1
	P_UNBECOME
	P_INEXT
	P_RETURN
make_boostbig
	P_DO		pbyte2
	P_EXPORT	gbyte1,pbyte1
	P_EXPORT	gword1,pword1
	P_SPAWN		0,0,0,0,0,0,boost_big,e_sp_boost,100,0,9
	P_BECOME
	P_IMPORT	pbyte1,gbyte2
	P_SETID		pbyte1
	P_INC		pbyte1
	P_EXPORT	gbyte2,pbyte1
	P_DEC		pbyte1
	P_IMPORT	ap,gbyte1
	P_IMPORT	childz,gword1
	P_UNBECOME
	P_INEXT
	P_RETURN
;;;;-----------
mk_many_spark_core
	P_QSPAWN	wallflash,e_sp_spark_core,10,8
	P_IGOTO		mk_many_spark.same
mk_many_spark
	P_QSPAWN	wallflash,e_sp_spark,10,8
.same	LOCAL
	P_BECOME
	P_ACTIVE	ON
	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64
	P_ADD		worldx,pbyte1
	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64
	P_ADD		worldy,pbyte1
	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64
	P_ADD		worldz,pbyte1
	P_SETRANDOM	hp,7
	P_INC		hp
	P_UNBECOME
	P_RETURN
;------------
init_hardslope_soff
	P_SHADOW	OFF
init_hardslope
	P_INVINCIBLE	ON
init_notinvslope
	P_SET		hp,100
	P_SET		ap,4
	P_SLOPE		ON
	P_COLLISIONS	OFF
	P_RANGECHECK	ON		;;;;;;;;;
	P_CLRTYPE	enemy1
	P_RETURN
;------------
sos_explode
	P_SCREENFLASH
	P_DO		4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,32
	P_BECOME
	P_ACTIVE	ON
	P_ADD		slopenum,4
	P_UNBECOME
	P_ADD		rotx,2
	P_ADD		rotz,-2
	P_ADD		worldy,10
	P_NEXT
	P_CIRCLEWINDOW	1,big			;10
	P_GOSUB		make_random_item
	P_EXPLODE
;;;---------
many_exp_group
	P_DO		4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,90
	P_BECOME
	P_ADD		slopenum,3
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT
	P_RETURN
;;;;------------
sos_group_explode
	P_DO		4
	P_QSPAWN	explosion6,e_sp_bigrandom_explosion,100,50
	P_BECOME
	P_ADD		slopenum,6
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT
	P_RETURN
;;;;------------
group_explode
	P_DO		4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,32
	P_BECOME
	P_ADD		slopenum,2
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT
	P_RETURN
;;;;------------
s_group_explode
	P_DO		2		;4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,8
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT
	P_RETURN
;-----------
senkan_explode
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,100
	P_BECOME
	P_ACTIVE	ON
	P_ADD		slopenum,6
	P_UNBECOME
	P_RETURN
;-----------
kani_explode_big
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,64
	P_BECOME
	P_ACTIVE	ON
	P_ADD		slopenum,3
	P_UNBECOME
	P_RETURN
;-----------
kani_explode
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,31
	P_BECOME
	P_ACTIVE	ON
	P_INC		slopenum
	P_UNBECOME
	P_RETURN
;-----------
core_explode
	P_RANDOMGOTO	.pass
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,31
	P_BECOME
	P_ACTIVE	ON
	P_INC		slopenum
	P_UNBECOME
.pass
	P_QSPAWN	explosion5,e_sp_randomsize_explosion,100,5
	P_BECOME
	P_ACTIVE	ON
	P_INC		slopenum
	P_UNBECOME
	P_RETURN
;-----------
mk_many_damy_exp
	P_QSPAWN	explosion5,e_sp_randomsize_explosion,100,0
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_RETURN
;-----------
hasami_smoke
	P_SOUNDEFTDISTPOS	en_wormappear	;$7f
hasami_smoke_nosou
	P_QSPAWN	smoke,e_sp_randomsize_smoke,100,0
	P_BECOME
	P_ZERO		worldy
	P_ACTIVE	ON
	P_UNBECOME
	P_RETURN
;;;;------------ NAGAKU TANABIKU SMOKE MAKER
exp_smoke
	P_QSPAWN	smoke,e_smoke,100,-15
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_RETURN

;-----------
wait_start_trigger
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,etrigger
	P_IFNOTZERO	pbyte1,.trig_on
	P_PULL		pbyte1
	P_GOTO		wait_start_trigger
.trig_on
	P_PULL		pbyte1
	P_RETURN
;-----------
sos_fire_must2
	P_PUSH		rotx
	P_PUSH		roty
	P_PUSH		rotz
	P_PUSH		pbyte2
	P_FACEPLAYER	IMMEDIATE
	P_SET		pbyte1,rotx
	P_DIV2		pbyte1
	P_SET		pbyte2,pbyte1
	P_DIV2		pbyte2
	P_ADD		pbyte1,pbyte2
	P_NEG		pbyte1
	P_ADD		rotx,pbyte1
	P_FIRE
	P_BECOME
	P_SET		skidy,1
	P_UNBECOME
	P_PULL		pbyte2
	P_PULL		rotz
	P_PULL		roty
	P_PULL		rotx
	P_RETURN
;-----------
room_enemy_sw_dead
	P_IMPORT	pbyte1,ebyte8
	P_SETSWITCH	skidy,pbyte1
	P_EXPORT	ebyte8,pbyte1
	P_RETURN
;----
radar_change
	P_IFSAME	radarobj,ra_enemy,.rad_hon
	P_RADAROBJ	ra_enemy
	P_RETURN
.rad_hon
	P_RADAROBJ	ra_honmei
	P_RETURN
;------------
shield_base_hit_msg
	P_SOUNDEFTDISTPOS	barrier_hit	;$23
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,ebyte1
	P_IFNOTZERO	pbyte1,.pass_msg
	P_SET		pbyte1,60
	P_EXPORT	ebyte1,pbyte1
	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.pass_msg
	P_ADD		pbyte1,shieldbase_hit_muda_num
	P_MSG		pbyte1
.pass_msg
	P_PULL		pbyte1
	P_RETURN
base_hit_msg
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,ebyte1
	P_IFNOTZERO	pbyte1,.pass_msg
	P_SET		pbyte1,60
	P_EXPORT	ebyte1,pbyte1
	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.pass_msg
	P_ADD		pbyte1,base_hit_muda_num
	P_MSG		pbyte1
.pass_msg
	P_PULL		pbyte1
	P_RETURN
;------------
inc_final_door_lock
	P_GINC		b,ebyte2
	P_SCORE		100
	P_RETURN
;------------
mini_missile_fire
	P_WEAPON	HomEMissile
	P_FIRE
	P_BECOME
	P_SET		skidy,1
	P_UNBECOME
	P_RETURN
missile_fire
	P_WEAPON	HomEMissile
	P_FIRE
	P_RETURN
;-----------
CurrentSw_Skidy_ck
	P_IMPORT	pword1,CurrentSwitch
	P_INC		skidy
	P_IFSWITCH	skidy,pword1,.sw_inv
	P_ZERO		pword1
	P_RETURN
.sw_inv
	P_SET		pword1,100
	P_RETURN
;;;;------------
dec_EEnemyNumber_skidy
	P_PUSH		pword1
	P_PUSH		pbyte1
	P_IMPORT	pword1,CurrentSwitch
	P_IMPORT	pbyte1,CurrentEEnemyNumber
	P_SETSWITCH	skidy,pword1
	P_EXPORT	CurrentSwitch,pword1
	P_IFBETWEEN	0,skidy,8,.lower
	P_ADD		pbyte1,-16
	P_IGOTO		.set_eenemy
.lower
	P_ADD		pbyte1,-1
.set_eenemy
	P_EXPORT	CurrentEEnemyNumber,pbyte1
	P_PULL		pbyte1
	P_PULL		pword1
	P_RETURN
;;;;------------
roty_pb2_pb1
	P_SET		pbyte1,roty
	P_SET		pbyte2,5
	P_DO		4
	P_CLRSWITCH	pbyte2,pbyte1
	P_INC		pbyte2
	P_INEXT
	P_SET		pbyte2,roty
	P_DO		4
	P_SHIFTR	pbyte2
	P_INEXT
	P_RETURN
;------------
make_sw_num_hofhp
	P_PUSH		pbyte1
	P_SET		pbyte1,5
	P_SET		skidy,hp
	P_DO		4
	P_CLRSWITCH	pbyte1,hp
	P_INC		pbyte1
	P_SHIFTR	skidy
	P_INEXT
	P_PULL		pbyte1
	P_RETURN
;;;;------------
make_sw_num_hofap
	P_PUSH		pbyte1
	P_SET		pbyte1,5
	P_SET		skidy,ap
	P_DO		4
	P_CLRSWITCH	pbyte1,ap
	P_INC		pbyte1
	P_SHIFTR	skidy
	P_INEXT
	P_INC		skidy
	P_PULL		pbyte1
	P_RETURN
;;;;------------
decide_angle_slonum_s_s
	P_SETRANDOM	slopenum,3
	P_ADD		slopenum,4
	P_IGOTO		deciang_sn_a_neg
decide_angle_slonum_s
	P_SETRANDOM	slopenum,7
	P_IGOTO		deciang_sn_a
decide_angle_slonum
	P_SETRANDOM	slopenum,15
	P_ADD		slopenum,8
deciang_sn_a
	P_ADD		slopenum,8
deciang_sn_a_neg
	P_RANDOMGOTO	.neg_turn
	P_NEG		slopenum
.neg_turn
	P_RETURN
;;;;------------
slonum_rz_waitchase
	P_CHASE		rotz,slopenum
	P_IFSAME	rotz,slopenum,.chase_end
	P_GOTO		slonum_rz_waitchase
.chase_end
	P_RETURN
;;;;------------
use_boost_ck
	P_DISTLESS	13000,.pass
	P_DISTMORE	19000,.pass
	P_QSPAWN	nullshape,e_use_boost_msg,100,0
.pass
	P_RETURN
;-------
	START_PATH	e_use_boost_msg

	P_INVISIBLE	ON
	P_IMPORT	pbyte1,ebyte5
	P_SET		pbyte2,3
	P_IFSWITCH	pbyte2,pbyte1,.rem
	P_IMPORT	tx,Player_friend
	P_IFSAME	tx,-1,.rem
	P_SET		pword1,tx
	P_IMPORT	pbyte1,player_controltypeABXY
	P_IFZERO	pbyte1,.norm_ABXY
	P_ADD		pword1,96
.norm_ABXY
	P_ADD		pword1,oikakero_msg_num		;boost wo tsukae
	P_MSG		pword1
	P_DO		3
	P_IMPORT	pbyte1,ebyte5
	P_SETSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte5,pbyte1
	P_NEXT
	P_IMPORT	pbyte1,ebyte5
	P_CLRSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte5,pbyte1
.rem
	P_REMOVE

;;;;------------
near_check
	P_DISTMORE	10000,.pass
	P_QSPAWN	nullshape,e_boost_msg_dame,100,0
.pass
	P_RETURN
;-------
	START_PATH	e_boost_msg_dame

	P_INVISIBLE	ON
	P_IMPORT	pbyte1,ebyte5
	P_SET		pbyte2,3
	P_IFSWITCH	pbyte2,pbyte1,.rem
	P_DO		70
	P_IMPORT	pbyte1,ebyte5
	P_SETSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte5,pbyte1
	P_NEXT
	P_IMPORT	pbyte1,ebyte5
	P_CLRSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte5,pbyte1
.rem
	P_REMOVE
;;;;------------
;;;ck_msg_maker
;;;	P_DISTMORE	10000,.now_msg2
;;;	P_PUSH		pbyte1
;;;	P_PUSH		pbyte2
;;;	P_IMPORT	pbyte1,ebyte5
;;;	P_SET		pbyte2,3
;;;	P_IFSWITCH	pbyte2,pbyte1,.now_msg
;;;	P_SETSWITCH	pbyte2,pbyte1
;;;	P_EXPORT	ebyte5,pbyte1
;;;	P_QSPAWN	nullshape,e_ck_msg_maker,100,0
;;;.now_msg
;;;	P_PULL		pbyte2
;;;	P_PULL		pbyte1
;;;.now_msg2
;;;	P_RETURN
;;;make_msg_maker
;;;	P_PUSH		pbyte1
;;;	P_PUSH		pbyte2
;;;	P_IMPORT	pbyte1,ebyte5
;;;	P_SET		pbyte2,3
;;;	P_IFSWITCH	pbyte2,pbyte1,.now_msg
;;;	P_SETSWITCH	pbyte2,pbyte1
;;;	P_EXPORT	ebyte5,pbyte1
;;;	P_QSPAWN	nullshape,e_msg_maker,100,0
;;;.now_msg
;;;	P_PULL		pbyte2
;;;	P_PULL		pbyte1
;;;	P_RETURN
;;;;------------
far_rem_ck
	P_DISTLESS	23000,.ok
	P_FORCE		.rem
.ok
	P_RETURN
.rem
	P_REMOVE
;;;;------------
sos_dead
	P_FORCE		.dead
	P_RETURN
.dead
	P_TRIGGER	sos_dead,OFF
	P_RELTOPLAYER	OFF
	P_SCORE		sc_sos_weak
	P_GOSUB		fighter_count_gset
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
;	P_CLRDEMOSHAPE
;	P_SCREENFLASH
;	P_SET		pbyte1,255
;	P_EXPORT	eaction1,pbyte1
	P_IFSAME	shape,virus,.small
	P_GOSUB		sos_group_explode
.ret_small
	P_RANDOMGOTO	.pass
	P_RANDOMGOTO	.pass
	P_GOSUB		make_hp_item
.pass
	P_EXPLODE
.small
	P_GOSUB		s_group_explode
	P_IGOTO		.ret_small
;;;;------------
fly_wave
	P_INDEX		pbyte1,costab,pbyte2
	P_IFZERO	tx,.zt
	P_IFBETWEEN	-127,tx,0,.minus
	P_DO		tx			;3
	P_DIV2		pbyte1
	P_INEXT
.zt
	P_ADD		worldy,pbyte1
.ztt
	P_DO		ty			;4
	P_INC		pbyte2
	P_INEXT
	P_RETURN
.minus
	P_NEG		tx
	P_DO		tx
	P_ADD		worldy,pbyte1
	P_ADD		worldy,pbyte1
	P_INEXT
	P_NEG		tx
	P_IGOTO		.ztt
;;;;------------
fly_wave_c
	P_INDEX		pbyte1,costab,pbyte2
	P_DO		tx			;3
	P_DIV2		pbyte1
	P_INEXT
	P_DO		ty			;4
	P_INC		pbyte2
	P_INEXT
	P_ADD		childy,pbyte1
	P_RETURN
;;;;------------
;;;down_30
;;;	P_ADD		worldy,30
;;;	P_RETURN
down_10
	P_ADD		worldy,10
	P_RETURN
;;;cannon_down
;;;	P_ADD		worldy,25
;;;	P_ADD		rotx,pbyte1
;;;	P_RETURN
;;;;------------
ran_neg_pb1
	P_RANDOMGOTO	.neg_pb12
	P_NEG		pbyte1
.neg_pb12
	P_RETURN
;;;;------------
set_hp100_ap4_enemy
	P_TRIGGER	marker_set,Always
	P_RADAROBJ	ra_enemy
	P_ALWAYSGENVECS	ON
set_hp100_ap4
	P_SET		hp,100
	P_SET		ap,4
	P_RETURN
wakidashi_init
	P_SET		hp,100
	P_SET		ap,4
	P_ALWAYSGENVECS	ON
;;;;;;;;	P_RANGECHECK	OFF
	P_RANGECHECK	ON
	P_RADAROBJ	ra_enemy
	P_RETURN

wakidashi_dead
	P_SCORE		sc_wakidashi
wakidashi_dead_no_sc
	P_INVISIBLE	ON
	P_EXPORT	gword1,shape
	P_QSPAWN	nullshape,e_wakidashi_damy_exp,10,10
	P_BECOME
	P_IMPORT	shape,gword1
	P_UNBECOME
	P_ADD		worldx,20000
	P_FORCE		.rem
	P_RETURN
.rem
	P_TRIGGER	wakidashi_dead,OFF
	P_TRIGGER	wakidashi_dead_no_sc,OFF
	P_REMOVE

hit_dead_init
	P_RADAROBJ	ra_enemy
hit_dead_init_noradar
	P_SET		hp,1
	P_SET		ap,4
	P_ALWAYSGENVECS	ON
;;;;;;;;	P_RANGECHECK	OFF
	P_RETURN
ring_hit_dead
	P_GOSUB		fire_cansel
hit_dead
	P_GOSUB		make_hp_item_random
hit_dead_score
	P_SCORE		sc_hit_dead
	P_RETURN
;---
from_carier_dead
	P_FORCE		.exp
	P_RETURN
.exp
	P_TRIGGER	from_carier_dead,OFF
	P_GOSUB		make_hp_item_random
	P_SCORE		sc_hit_dead
	P_GDEC		b,ebyte6
	P_GOSUB		sos_group_explode
	P_EXPLODE
;---
	START_PATH	e_wakidashi_damy_exp

	P_COLLISIONS	OFF
	P_SCREENFLASH
	P_GOSUB		s_group_explode
	P_EXPLODE
;;;;------------
;;;final_enemy_demo
;;;	P_CLRDEMOSHAPE
;;;	P_GDEC		b,KEnemyNumber
;;;	P_GOSUB		s_group_explode
;;;	P_SCREENFLASH
;;;	P_EXPLODE
;;;;------------
;;;final_enemy_demo_space
;;;	P_SPACESHIP	OFF
;;;	P_RELTOPLAYER	OFF
;;;	P_COLLISIONS	OFF
;;;	P_ACCEL		0,10
;;;	P_SETVEL	0
;;;	P_PUSH		pbyte1
;;;	P_IMPORT	pbyte1,KEnemyNumber
;;;	P_IFNOTSAME	pbyte1,1,.not_demo
;;;	P_PULL		pbyte1
;;;	P_PUSH		rotz
;;;	P_ZERO		rotz
;;;	P_GOSUB		make_toge_test
;;;	P_PULL		rotz
;;;	P_EXPORT	gword1,worldy
;;;	P_BECOME
;;;	P_SET		tx,15
;;;	P_SET		slopenum,de_for_kaiten
;;;	P_IMPORT	pword1,gword1
;;;	P_UNBECOME
;;;	P_RETURN
;;;.not_demo
;;;	P_PULL		pbyte1
;;;	P_SCREENFLASH
;;;	P_RETURN
;;;;------------
;;;hajimete_msg_check
;;;	P_IMPORT	pword1,eword3
;;;	P_IFSWITCH	pbyte1,pword1,.not_hajimete
;;;	P_SETSWITCH	pbyte1,pword1
;;;	P_EXPORT	eword3,pword1
;;;	P_EXPORT	eword2,ox
;;;.not_hajimete
;;;	P_RETURN
;;;;------------
;;;senkan_wave
;;;	P_IFNOTZERO	mz,.slow_pass
;;;	P_IFBETWEEN	-5,rotz,4,.not_wait
;;;	P_INC		mz
;;;.not_wait
;;;	P_DEC		my
;;;	P_IFZERO	my,.turn
;;;	P_ADD		rotz,mx
;;;	P_RETURN
;;;.turn
;;;	P_SET		my,21
;;;	P_NEG		mx
;;;	P_SET		mz,8
;;;	P_RETURN
;;;.slow_pass
;;;	P_DEC		mz
;;;	P_RETURN
;;;;------------
;;;shift_hap
;;;	P_SET		pbyte1,hp
;;;	P_SET		pbyte2,ap
;;;	P_DO		4
;;;	P_SHIFTR	pbyte1
;;;	P_SHIFTR	pbyte2
;;;	P_INEXT
;;;	P_RETURN
;;;;------------
;;;clsw_hap
;;;	P_SET		pbyte2,5
;;;	P_DO		4
;;;	P_CLRSWITCH	pbyte2,hp
;;;	P_CLRSWITCH	pbyte2,ap
;;;	P_INC		pbyte2
;;;	P_INEXT
;;;	P_RETURN
;;;;------------
;;;
;;;make_init_rot
;;;	P_GOSUB		shift_hap
;;;	P_INDEX		rotx,init_angle_tab,pbyte1
;;;	P_INDEX		rotz,init_angle_tab,pbyte2
;;;
;;;	P_GOSUB		clsw_hap
;;;	P_INDEX		roty,init_angle_tab,hp
;;;
;;;	P_RETURN
;;;
;;;;------------
;;;suihei_hikou
;;;	P_IFZERO	oz,.hp_loop
;;;	P_DO		oz
;;;	P_WAIT		1
;;;	P_INEXT
;;;.hp_loop
;;;	P_WAIT		1	;4
;;;	P_IFZERO	rotx,.ck_z
;;;	P_IFBETWEEN	-128,rotx,0,.incx
;;;	P_DEC		rotx
;;;	P_IGOTO		.ck_z
;;;.incx
;;;	P_INC		rotx
;;;.ck_z
;;;	P_IFZERO	rotz,.end_z
;;;	P_IFBETWEEN	-128,rotz,0,.incz
;;;	P_DEC		rotz
;;;	P_IGOTO		.end_z
;;;.incz
;;;	P_INC		rotz
;;;.end_z
;;;	P_IFNOTZERO	rotx,.hp_loop
;;;	P_IFNOTZERO	rotz,.hp_loop
;;;	P_IGOTO		.hp_start
;;;.hp_start
;;;	P_RETURN
;;;;------------
hp100_reflect_laser
	P_SET		hp,100
reflect_laser
	P_REBOUNDLASER
	P_RETURN
;;;;------------
;;;rem_arrow
;;;	P_FINDSHAPE	arrow_0
;;;	P_SHAPEDEAD	.ret
;;;	P_SHAPEDISTLESS	500,.aru_ar
;;;.ret
;;;	P_RETURN
;;;.aru_ar
;;;	P_FLAGSHAPE
;;;	P_RETURN
;;;;------------
;;;enemy_num_rem
;;;	P_IMPORT	childrotz,KEnemyNumber
;;;	P_IFNOTZERO	childrotz,.cont_ok
;;;	P_FORCE		.rem_on
;;;.cont_ok
;;;	P_RETURN
;;;.rem_on
;;;	P_REMOVE
;;;
;;;;------------
;;;immed_fire
;;;	P_PUSH		roty
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_FIRE
;;;	P_PULL		roty
;;;	P_RETURN
;;;;------------
set_child_xyz
	P_SET		childy,worldy
set_child_xz
	P_SET		childx,worldx
	P_SET		childz,worldz
	P_RETURN
;;;;------------
put_marker
	P_EXPORT	gword1,childx
	P_EXPORT	gword2,childz
;;;put_only_marker
	P_QSPAWN	marker,e_marker,100,0
	P_FINDSHAPE	marker
	P_RETURN
;;;;------------
sea_init_above
	P_PUSH		ox
	P_IMPORT	pword1,Player1_worldy
	P_SET		ox,-1000
	P_IFSMALLER	pword1,ox,.above_same
	P_INVISIBLE	ON
.above_same
	P_TRIGGER	i_sky_pl_in_sea,BelowSea
	P_TRIGGER	i_sky_pl_out_sea_nocol,AboveSea
	P_PULL		ox
	P_RETURN
;;;;------------
sea_init_below
	P_PUSH		ox
	P_IMPORT	pword1,Player1_worldy
	P_SET		ox,-1000
	P_IFLARGER	pword1,ox,.below_same
	P_INVISIBLE	ON
.below_same
	P_TRIGGER	i_sea_pl_in_sea_nocol,BelowSea
	P_TRIGGER	i_sea_pl_out_sea,AboveSea
	P_PULL		ox
	P_RETURN
;;;;------------
sea_init_below_canhit
	P_IMPORT	pword1,Player1_worldy
	P_SET		ox,-1000
	P_IFLARGER	pword1,ox,.below_same
	P_INVISIBLE	ON
.below_same
	P_TRIGGER	i_sea_pl_in_sea,BelowSea
	P_TRIGGER	i_sea_pl_out_sea,AboveSea
	P_RETURN
;;;;------------
sea_init_above_canhit
	P_IMPORT	pword1,Player1_worldy
	P_SET		ox,-1000
	P_IFSMALLER	pword1,ox,.above_same
	P_INVISIBLE	ON
.above_same
	P_TRIGGER	i_sky_pl_in_sea,BelowSea
	P_TRIGGER	i_sky_pl_out_sea,AboveSea
	P_RETURN
;;;;------------
sea_map_ck
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,5,.not_sea
	P_CLIPPING	ON
.not_sea
	P_PULL		pbyte1
	P_RETURN
;;;;-------------
i_sky_pl_in_sea
	P_INVISIBLE	ON
	P_RETURN
i_sky_pl_out_sea_nocol
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_RETURN
i_sky_pl_out_sea
	P_INVISIBLE	OFF
	P_RETURN
i_sea_pl_in_sea_nocol
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_RETURN
i_sea_pl_in_sea
	P_INVISIBLE	OFF
	P_RETURN
i_sea_pl_out_sea
	P_INVISIBLE	ON
	P_RETURN
;;;;------------ RETURN ORIGINAL VIEW POS
back_org_view
	P_NEG		childrotx
	P_NEG		childroty
	P_NEG		childrotz
.back_camera
	P_WAIT		1
	P_DO		3			;2
	P_CHASE		worldx,ox
	P_CHASE		worldy,oy
	P_CHASE		worldz,oz
	P_CHASE		rotx,childrotx
	P_CHASE		roty,childroty
	P_CHASE		rotz,childrotz
	P_INEXT
	P_SETCAMERA	IMMEDIATE
	P_IFNOTSAME	worldx,ox,.back_camera
	P_IFNOTSAME	worldy,oy,.back_camera
	P_IFNOTSAME	worldz,oz,.back_camera
	P_IFNOTSAME	rotx,childrotx,.back_camera
	P_IFNOTSAME	roty,childroty,.back_camera
	P_IFNOTSAME	rotz,childrotz,.back_camera
	P_RETURN
;;;;------------ ORIGINAL VIEW POS
make_org_view
	P_PUSH		worldx
	P_PUSH		worldy
	P_PUSH		worldz
	P_PUSH		rotx
	P_PUSH		roty
	P_PUSH		rotz

	P_COPYVIEWROTS
	P_SET		childrotx,rotx
	P_SET		childroty,roty
	P_SET		childrotz,rotz
	P_COPYVIEWPOS
	P_SET		ox,worldx
	P_SET		oy,worldy
	P_SET		oz,worldz

	P_PULL		rotz
	P_PULL		roty
	P_PULL		rotx
	P_PULL		worldz
	P_PULL		worldy
	P_PULL		worldx
	P_RETURN
;;;;------------ DEMO CAMERA STANDBY WAIT
demo_zoom
	P_COPYVIEWROTS
	P_COPYVIEWPOS
	P_SET		pbyte1,7
	P_IMPORT	pbyte2,PlayerImportFlag
	P_IFSWITCH	pbyte1,pbyte2,.cock
	P_IGOTO		.out_view
.cock
	P_PUSH		worldy
	P_COPYPLAYERPOS
	P_SET		mx,worldx
	P_SET		mz,worldz
	P_NEG		mx
	P_NEG		mz
	P_COPYVIEWPOS
	P_ADD		mx,worldx
	P_ADD		mz,worldz
	P_NEG		mx
	P_NEG		mz
	P_COPYPLAYERPOS
	P_ADD		worldx,mx
	P_ADD		worldz,mz
	P_PULL		worldy
.out_view
	P_DO		3
	P_PUSH		worldy
	P_MOVEINPLAYER	-100
	P_PULL		worldy
	P_FACEPLAYER	IMMEDIATE
	P_INEXT
	P_RETURN
;-------------
demo_move_wait
	P_PUSH		pbyte2
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,ebyte6
	P_SET		pbyte2,1
	P_CLRSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte6,pbyte1
	P_PULL		pbyte1
	P_PULL		pbyte2
.demo_wait_loop
	P_PUSH		pbyte2
	P_PUSH		pbyte1
	P_SET		pbyte2,1
	P_IMPORT	pbyte1,ebyte6
	P_IFSWITCH	pbyte2,pbyte1,.end_d_move
	P_PULL		pbyte1
	P_PULL		pbyte2
	P_GOTO		.demo_wait_loop
.end_d_move
	P_PULL		pbyte1
	P_PULL		pbyte2
	P_RETURN
;------------
demo_move_wait2
	P_PUSH		pbyte2
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,ebyte6
	P_SET		pbyte2,2
	P_CLRSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte6,pbyte1
	P_PULL		pbyte1
	P_PULL		pbyte2
.demo_wait_loop
	P_PUSH		pbyte2
	P_PUSH		pbyte1
	P_SET		pbyte2,2
	P_IMPORT	pbyte1,ebyte6
	P_IFSWITCH	pbyte2,pbyte1,.end_d_move
	P_PULL		pbyte1
	P_PULL		pbyte2
	P_GOTO		.demo_wait_loop
.end_d_move
	P_PULL		pbyte1
	P_PULL		pbyte2
	P_RETURN
;;;;----------- PUT ONEMORE
;;;sos_more_go_far
;;;.to_far
;;;	P_SET		worldy,pword1
;;;	P_MOVEINPLAYER	-120
;;;	P_DISTMORE	4000,.far
;;;	P_IGOTO		.to_far
;;;.far
;;;	P_RANDOMGOTO	.neg
;;;	P_CIRCLEPLAYER	32
;;;	P_IGOTO		.unb
;;;.neg
;;;	P_CIRCLEPLAYER	-32
;;;.unb
;;;	P_RETURN
;;;;----------- PUT ONEMORE
;;;one_more_go_far
;;;	P_NEG		worldx
;;;	P_GADD		worldx,Player1_worldx
;;;	P_IFNOTZERO	worldx,.ok_x
;;;	P_INC		childx
;;;	P_IGOTO		.ok_xz
;;;.ok_x
;;;	P_NEG		worldz
;;;	P_GADD		worldz,Player1_worldz
;;;	P_IFNOTZERO	worldz,.ok_xz
;;;	P_INC		childz
;;;.ok_xz
;;;	P_SET		worldx,childx
;;;	P_SET		worldz,childz
;;;.to_far
;;;	P_IMPORT	worldy,Player1_worldy
;;;	P_DISTMORE	2800,.far
;;;	P_MOVEINPLAYER	-120
;;;	P_IGOTO		.to_far
;;;.far
;;;	P_SET		worldy,pword1
;;;	P_RANDOMGOTO	.neg
;;;	P_CIRCLEPLAYER	32
;;;	P_IGOTO		.unb
;;;.neg
;;;	P_CIRCLEPLAYER	-32
;;;.unb
;;;	P_RETURN
;;;;----------- SASORI KUMO MOVE IN
;;;move_in_mark
;;;	P_FACESHAPE
;;;	P_MOVEINSHAPE	30
;;;	P_ZERO		rotx
;;;	P_SET		worldy,pbyte1
;;;
;;;	P_SHAPEDISTLESS	50,.near
;;;	P_GOTO		move_in_mark
;;;.near
;;;	P_FLAGSHAPE
;;;
;;;	P_RETURN
;;;;----------- SASORI KUMO RETURN MARK SET
;;;;----------- FRIEND SHAPE SET
set_friend_shape

	P_IMPORT	pbyte1,Player_friend
	P_SET		tx,pbyte1
	P_INDEX		coltab,friend_col,pbyte1
	P_DIV2		pbyte1
	P_INDEX		shape,friend_shape,pbyte1
	P_RETURN
;;;friend_shape
;;;	dw	a_wing	;fox,falco
;;;	dw	c_wing	;peppy,slippy
;;;	dw	b_wing	;gal1,gal2
;;;friend_w1
;;;	dw	a_wing_1	;fox
;;;	dw	c_wing_1	;peppy
;;;	dw	b_wing_1	;gal1
;;;friend_w2
;;;	dw	a_wing_0	;fox
;;;	dw	c_wing_0	;peppy
;;;	dw	b_wing_0	;gal1
;;;friend_col
;;;	dw	id_0_c
;;;	dw	id_1_c
;;;	dw	id_0_c
;;;	dw	id_1_c
;;;	dw	id_0_c
;;;	dw	id_1_c
;;;;----------- ONLY ROTY
;;;only_roty
;;;	P_ADD		roty,slopenum
;;;	P_RETURN
;;;;----------- DOOR OPEN CROSE
open_door_base
	P_SOUNDEFFECT	ob_base_door	;$9c
	P_IGOTO		open_door.ent
open_door
	P_SOUNDEFTPOS	ob_opendoor_s	;$ab
	P_IFNOTSAME	shape,kaku_to,.ent
	P_TRIGGER	.sec_op_sou,Timer,6
.ent	LOCAL
	P_SLOPE		OFF
	P_DO		11
	P_ADDANIM	1,12
	P_NEXT
	P_RETURN
.sec_op_sou
	P_SOUNDEFTPOS	ob_opendoor_s	;$ab
	P_RETURN
crose_door
	P_SOUNDEFTDIST	ob_closedoor_s	;$ab
	P_IFNOTSAME	shape,kaku_to,.ent
	P_TRIGGER	.sec_cr_sou,Timer,6
.ent
	P_SLOPE		ON
	P_DO		11
	P_ADDANIM	-1,12
	P_NEXT
	P_RETURN
.sec_cr_sou
	P_SOUNDEFTDIST	ob_closedoor_s	;$ab
	P_RETURN
;;;
;;;;----------- INIT SOS ZACO
init_sos_zaco
	P_SET		hp,100
	P_SET		ap,4
	P_SHADOW	OFF
;;;;;;;;	P_RANGECHECK	OFF
	P_ALWAYSGENVECS	ON
	P_RADAROBJ	ra_enemy
	P_WEAPON	RelElaser
	P_RETURN
;;;;----------- SOS ZACO no RELTOPLAYER CONTROLL
;;;sos_rel_ck
;;;	P_INPLAYERSCONE	151,231,.rel_off
;;;	P_INPLAYERSCONE	24,104,.rel_off
;;;	P_RELTOPLAYER	ON
;;;	P_RETURN
;;;.rel_off
;;;	P_RELTOPLAYER	OFF
;;;	P_RETURN
;;;
;;;;----------- INIT NOT TARGET HOUDAI
;;;not_target_hou
;;;	P_SET		hp,2
;;;	P_SET		ap,4
;;;	P_RANGECHECK	OFF
;;;	P_RADAROBJ	ra_honmei
;;;	P_WEAPON	EPlasma1
;;;	P_TRIGGER	yoi_hou_dead,WhenDead
;;;	P_RETURN
;;;yoi_hou_dead
;;;	P_SCORE		sc_yoi_hou
;;;	P_RETURN
	START_PATH	e_clip_obj_ground

	P_GROUNDOBJ	ON
;----------
	START_PATH	e_clip_obj

	P_COLLISIONS	OFF
	P_CLIPPING	BOSS
	P_SHADOW	OFF
	P_END

;;;;----------- SOS FIRE SUB
	START_PATH	e_sos_fire_hou_ring
	P_INVISIBLE	ON
	P_WEAPON	ERing
	P_GOSUB		sos_fire_must
	P_REMOVE
ring_fire_must_stay
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFZERO	pbyte1,.pass
	P_QSPAWN	ring_mark,e_ring_mark,10,10
.pass
	P_PULL		pbyte1
	P_RETURN
ring_fire_must_child
	P_SPAWN		0,0,0,0,0,0,ring_mark,e_ring_mark_child,10,10,11
	P_RETURN
sos_fire_must
	P_PUSH		rotx
	P_PUSH		roty
	P_PUSH		rotz
	P_FACEPLAYER	IMMEDIATE
	P_FIRE
	P_PULL		rotz
	P_PULL		roty
	P_PULL		rotx
	P_RETURN
;---------
	START_PATH	e_ring_mark_child

	P_SPRITE	0,8
	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_WEAPON	ERing
	P_SOUNDEFTDISTPOS	en_ERing_charge	;$7b
	P_DO		10
	P_ADD		tx,2
	P_NEXT
	P_FACEPLAYER	IMMEDIATE
	P_ADJUSTROT
	P_FIRE
	P_REMOVE
;-----------
	START_PATH	e_ring_mark

	P_SET		mx,worldx
	P_SET		my,worldy
	P_SET		mz,worldz

	P_TRIGGER	.rem_ck,Always
	P_SPRITE	0,8
;	P_SETCOLANIM	0
	P_RANGECHECK	OFF
	P_COLLISIONS	OFF
	P_WEAPON	ERing
	P_FACEPLAYER	IMMEDIATE
	P_ADJUSTROT
	P_SOUNDEFTDISTPOS	en_ERing_charge	;$7b
	P_DO		10
	P_ADD		tx,2
	P_SET		worldx,mx
	P_SET		worldy,my
	P_SET		worldz,mz
	P_MOVEINPLAYER	30
	P_NEXT
	P_FIRE
.rem
	P_REMOVE
.rem_ck
	P_IFZERO	pbyte1,.ok
	P_FORCE		.rem
.ok
	P_RETURN
;------------
fire_cansel
	P_FINDSHAPE	ring_mark
	P_BECOMESHAPE
	P_INC		pbyte1
	P_UNBECOME
	P_RETURN
;;;;----------
;;;sos_fire_sub
;;;	P_DEC		pbyte1
;;;	P_IFNOTZERO	pbyte1,.pass_at
;;;	P_PUSH		rotx
;;;	P_PUSH		roty
;;;	P_PUSH		rotz
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_FIRE
;;;	P_PULL		rotz
;;;	P_PULL		roty
;;;	P_PULL		rotx
;;;	P_SET		pbyte1,16
;;;.pass_at
;;;	P_RETURN
;;;;------------
;;;egu_fire_sub
;;;	P_DEC		pbyte1
;;;	P_IFNOTZERO	pbyte1,.pass_at
;;;	P_PUSH		rotx
;;;	P_PUSH		roty
;;;	P_PUSH		rotz
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SPAWN		0,0,150,0,0,0,laser_0,egu_speed_RelElaser,100,2
;;;	P_PULL		rotz
;;;	P_PULL		roty
;;;	P_PULL		rotx
;;;	P_SET		pbyte1,16
;;;.pass_at
;;;	P_RETURN
;;;;-----------MAKE RANDOM ITEM
make_hp_item_random
	P_RANDOMGOTO	make_hp_item
	P_RETURN
make_random_item
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFNOTZERO	pbyte1,.make
	P_RETURN
.make
	P_SETRANDOM	pbyte1,15
	P_IFZERO	pbyte1,make_twinblaster
	P_SETRANDOM	pbyte1,7
	P_IFSAME	pbyte1,7,make_flamethrower
	P_IFSAME	pbyte1,6,make_shieldplayer
	P_IFSAME	pbyte1,5,make_smartplasma
	P_IMPORT	pbyte1,KDifficulty
	P_IFNOTSAME	pbyte1,dif_easy,make_hp_item
	P_SETRANDOM	pbyte1,3
	P_IFSAME	pbyte1,3,make_flamethrower
	P_IFSAME	pbyte1,2,make_shieldplayer
	P_IFSAME	pbyte1,1,make_smartplasma
	P_IFZERO	pbyte1,make_twinblaster

;;;	P_IFSAME	pbyte1,4,make_dummyplayer
;;;	P_IFSAME	pbyte1,2,make_twinblaster
make_hp_item
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFNOTZERO	pbyte1,.make
	P_RETURN
.make
	P_QSPAWN	item_ita,e_item_hp,10,0
	P_IGOTO		item_make_end
;;;make_1up
;;;	P_QSPAWN	item_ita,e_item_1up,10,0
;;;	P_IGOTO		item_make_end
make_flamethrower
	P_QSPAWN	item_ita,e_item_flamethrower,10,0
	P_IGOTO		item_make_end
make_shieldplayer
	P_QSPAWN	item_ita,e_item_shieldplayer,10,0
	P_IGOTO		item_make_end
make_smartplasma
	P_QSPAWN	item_ita,e_item_smartplasma,10,0
	P_IGOTO		item_make_end
;make_dummyplayer
;	P_QSPAWN	item_ita,e_item_dummyplayer,10,0
;	P_IGOTO		item_make_end
make_twinblaster
	P_QSPAWN	item_ita,e_item_twinblaster,10,0
item_make_end
	P_BECOME
	P_ACTIVE	ON
	P_ZERO		roty
	P_UNBECOME
	P_RETURN
;;;;----------------- MARKER SET SUB
marker_set
	P_SETMARKER	1
	P_RETURN
marker_set2
	P_SETMARKER	2
	P_RETURN
;;;;----------------- ADDANIM 1,16
;;;anim_add_16
;;;	P_ADDANIM	1,16
;;;	P_RETURN
;;;;----------------- ADDANIM 1,12
anim_add_12
	P_ADDANIM	1,12
	P_RETURN
;;;;----------------- ADDANIM 1,11
anim_add_11
	P_ADDANIM	1,11
	P_RETURN
;;;;----------------- ADDANIM 1,8
;;;anim_add_8
;;;	P_ADDANIM	1,8
;;;	P_RETURN
;;;;----------------- ADDANIM	SOUND	FOR SASORI
sasori_sound
	P_SOUNDEFTNEARPOS	en_spiderwork_L	;$80
	P_RETURN
;;;;----------------- ADDANIM	1,12&SOUND	FOR SUISUI
;;;anim_add_12_sui
;;;	P_ADDANIM	1,12
;;;	P_IFSAME	animframe,-122,.sound_on
;;;	P_IFSAME	animframe,-128,.sound_on
;;;	P_RETURN
;;;.sound_on
;;;	P_IMPORT		ox,Player1_worldy
;;;	P_IFSMALLER		ox,pword1,.nos
;;;	P_SOUNDEFTDISTPOS	en_suisui	;$6b
;;;.nos
;;;	P_RETURN
;;;;----------------- ADDANIM	1,12&SOUND	FOR TEKUTEKU
anim_add_12_teku
	P_ADDANIM	1,12
	P_IFSAME	animframe,-122,.sound_on
	P_IFSAME	animframe,-128,.sound_on
	P_RETURN
.sound_on
	P_IFSAME	shape,tekuteku,.big
	P_SOUNDEFTDISTPOS	en_tekuteku_s	;$69
	P_RETURN
.big
	P_SOUNDEFTDISTPOS	en_tekuteku	;$69
	P_RETURN
;;;;----------------- ADDANIM	1,16&SOUND	FOR KUMO
kumo_anim
	P_ADDANIM	1,16

	P_IFSAME	animframe,128,.sound_on
	P_IFSAME	animframe,136,.sound_on
	P_RETURN
.sound_on
	P_SOUNDEFTNEARPOS	en_spiderwork_L	;$91
	P_RETURN
;;;;---------------- CLIPPED OBJ'S SHADOW CHECK
shadow_ck
	P_SHADOW	OFF
	P_IFBETWEEN	0,worldy,15000,.sh_off
	P_SHADOW	ON
.sh_off
	P_RETURN
;;;;------------ RECOVER ITSELF
self_invincible
	P_SET		hp,100
	P_RETURN

;--------------
eg_remove
	P_REMOVE
;--------------
;************************************************************
;*********************** DYLAN'S   **************************
;***********************           **************************
;*********************** PATH DATA **************************
;************************************************************
;randomplayer
;	P_RANDOMGOTO	.setp2
;	P_PLAYER	1
;	P_RETURN
;.setp2	P_PLAYER	2
;	P_RETURN


;	ifeq	1
;
;
;;--------------- Ground turret, aim and fire at a player -----
;
;	START_PATH	houdai1
;
;	P_SPAWN		0,0,0,0,0,0,hou_0_1,houdai_head,10,10,1
;	P_SET		hp,12
;	P_SET		ap,2
;	P_END
;
;	START_PATH	houdai_head
;	P_SET		hp,12
;	P_SET		ap,2
;
;	P_WEAPON	laser2
;
;.loop
;	P_IFNOTSAME	pbyte1,0,.dontcheck
;	P_PLAYER	1
;	P_GOSUB		.checkfire
;	P_PLAYER	2
;	P_GOSUB		.checkfire
;	P_IGOTO		.dontadd
;.dontcheck
;	P_ADD		pbyte1,-1
;.dontadd
;	P_ADD	childroty,deg5
;
;	P_GOTO		.loop
;.checkfire
;	P_DISTMORE	2000,.dontfire
;	P_PLAYERINCONE	deg5,.fire
;.dontfire
;	P_RETURN
;.fire
;	P_ADD		worldy,-50
;	P_FIRE
;	P_ADD		worldy,50
;	P_SET		pbyte1,10
;	P_RETURN
;
;
;randomplayer
;	P_RANDOMGOTO	.setp2
;	P_PLAYER	1
;	P_RETURN
;.setp2	P_PLAYER	2
;	P_RETURN
;
;
;
;;--------------- Fake player.. attacks either of the players -----
;
;	START_PATH	fakeplayer
;
;	P_SET		hp,20
;	P_SET		ap,1
;	P_GOSUB		randomplayer
;	P_WEAPON	laser2
;
;.loopuntilnear
;	P_WAIT		1
;	P_DISTMORE	1000,.loopuntilnear
;
;	P_SETVEL	0
;	P_LOCKPLAYER	ON
;
;	P_DO		8
;	  P_DO		20
;	    P_CHASE		childy,0
;	    P_FACEPLAYER
;
;rotaccel	=	$20
;rotaccel_limit =	$100
;
;	    P_LEFTOFPLAYER	.dontdo
;	    P_ADD		pword1,-rotaccel
;.dontdo
;	    P_RIGHTOFPLAYER	.dontdo2
;	    P_ADD		pword1,rotaccel
;.dontdo2
;
;	    P_IFBETWEEN		-rotaccel_limit,pword1,rotaccel_limit,.noclamp
;
;	    P_IFBETWEEN		0,pword1,$1000,.posclamp
;.negclamp
;	    P_SET		pword1,-rotaccel_limit
;	    P_IGOTO		.noclamp
;.posclamp
;	    P_SET		pword1,rotaccel_limit
;.noclamp
;	    P_CIRCLE		pword1
;
;	    P_DISTMORE		800,.nomore
;	    P_MOVEIN		-30
;.nomore
;
;	  P_NEXT
;	  P_FIRE
;	P_INEXT
;
;	P_LOCKPLAYER	OFF
;	P_SETVEL	30
;
;	P_DO		100
;	P_ADD		rotz,deg22
;	P_NEXT
;
;	P_WAITCHASE	rotz,deg0
;	P_GOTO		.loopuntilnear
;
;	P_ALWAYSGENVECS	ON
;	P_WEAPON	laser1
;	P_TRIGGER	.hit,WHENHIT
;
;.loop
;	P_ACCEL		20,10
;
;	P_DO		10
;	P_FACEPLAYER
;	P_NEXT
;
;	P_ACCEL		70,20
;	P_ADD		roty,-5
;
;	P_DO		30
;	P_NEXT
;
;	P_DO		20
;	P_ADD		roty,1
;	P_NEXT
;
;	P_GOTO		.loop
;
;	IFEQ	1	;this
;
;	P_SET		hp,20
;	P_SET		ap,2
;	P_PLAYER	1
;	P_ALWAYSGENVECS	ON
;	P_WEAPON	laser1
;	P_TRIGGER	.hit,WHENHIT
;
;.loop
;	P_TRIGGER	.home,ALWAYS
;	P_ACCEL		20,2
;	P_DO		50
;	P_NEXT
;
;	P_FIRE
;
;	P_TRIGGER	.home,OFF
;
;	P_ACCEL		60,10
;	P_DO		30
;	P_NEXT
;
;
;	P_FIRE
;
;	P_GOTO		.loop
;
;	ENDC
;
;.hit
;	P_ACCEL		5,10	; if hit, slow almost to a stop
;	P_RETURN
;.home
;	P_FACEPLAYER
;	P_RETURN
;
;
;;-------------------------------------------------------------------
;; KAME_0 land octopus boss.
;
;	START_PATH	kame0
;
;	P_SPAWN		(0<<kame0_scale),(0<<kame0_scale),(-40<<kame0_scale),0,0,0,kame_0_3,kame0leg,10,10,1
;	  P_BECOME
;	  P_SET		pbyte1,-deg90-deg45
;	  P_SET		pbyte2,2	; how many pieces
;	  P_UNBECOME
;	P_SPAWN		(30<<kame0_scale),(0<<kame0_scale),(20<<kame0_scale),0,deg120,0,kame_0_3,kame0leg,10,10,2
;	  P_BECOME
;	  P_SET		pbyte1,-deg90-deg45
;	  P_SET		pbyte2,2	; how many pieces
;	  P_UNBECOME
;	P_SPAWN		(-30<<kame0_scale),(0<<kame0_scale),(20<<kame0_scale),0,-deg120,0,kame_0_3,kame0leg,10,10,3
;	  P_BECOME
;	  P_SET		pbyte1,-deg90-deg45
;	  P_SET		pbyte2,2	; how many pieces
;	  P_UNBECOME
;	P_INVINCIBLE	ON
;	P_SET		ap,4
;
;;	P_TRIGGER	setview_sub,ALWAYS
;
;	P_SETANIM	0
;
;.loop
;
;	P_CHASE		worldy,-200
;	P_ADD		roty,-2
;	P_GOTO		.loop
;
;	P_END
;
;
;;--------------------------------------------------------------
;	START_PATH	kame0leg
;	P_INVINCIBLE	ON
;
;	P_SETANIM	0
;	P_TRIGGER	.leggrow,4
;
;.loop
;	P_CHASE		childrotx,pbyte1
;
;	P_SETRANDOM	sbyte2,255
;	P_IFSAME	sbyte2,0,.raiseleg
;	P_GOTO		.loop
;.raiseleg
;	P_ADD		childrotx,2
;	P_IFBETWEEN	-deg45,childrotx,0,.loop
;	P_GOTO		.raiseleg
;
;
;.leggrow	P_IFSAME	animframe,128+8,.dontgrow
;	P_ADDANIM	1,10
;	P_IFNOTSAME	animframe,128+8,.dontgrow
;	P_DEC		pbyte2
;	P_IFSAME	pbyte2,0,.dontgrow
;	P_IFSAME	pbyte2,1,.growhead
;	P_SPAWN		0,-70,0,0,0,0,kame_0_3,kame0leg,10,10,1
;	P_GOSUB		.setcreator
;.dontgrow	P_RETURN
;.growhead
;	P_SPAWN		0,-80,0,0,0,0,kame_0_4,kame0foot,10,10,1
;	P_GOSUB		.setcreator
;	P_RETURN
;
;.setcreator
;	P_START65816
;	stx	gword1
;	P_END65816
;	P_EXPORT	gbyte1,pbyte2
;	P_BECOME
;	  P_IMPORT	childrotobj,gword1
;	  P_SET		pbyte1,-deg5
;	  P_IMPORT	pbyte2,gbyte1
;	P_UNBECOME
;	P_RETURN
;
;;--------------------------------------------------------------
;
;	START_PATH	kame0foot
;
;	P_INVINCIBLE	ON
;	P_SETANIM	0
;	P_ADD		childrotx,deg90
;
;.animit1
;	P_ADDANIM	1,20
;	P_IFSAME	animframe,128+5,.nxtbitchk
;	P_GOTO		.animit1
;.nxtbitchk
;	P_SETRANDOM	pbyte1,15
;	P_IFNOTSAME	pbyte1,0,.nxtbit
;	P_WAIT		1
;.openfully
;	P_ADDANIM	1,20
;	P_IFSAME	animframe,128+16,.nxtbit
;	P_GOTO		.openfully
;.nxtbit
;	P_ADDANIM	-1,20
;	P_IFSAME	animframe,128+0,.animit1
;	P_GOTO		.nxtbit
;	P_END
;	
;
;;-------------------------------------------------------------------
;; tables:
;backforth_tab
;	db	0,0,1,1,1,2,2,3,4,6,9,6,4,3,2,2,1,1,1,0
;	db	0,0,-1,-1,-1,-2,-2,-4,-5,-7,-10,-7,-5,-4,-2,-2,-1,-1,-1,0
;
;
;
;	endc


;---------------------------------------------------------------
;95,8,17_egu_coment
;setview_sub
;	P_START65816
;	ldy	#viewblk1
;	s_copy_pos	y,x
;	s_set_alvar	W,y,al_rotx,#0
;	s_set_alvar	W,y,al_roty,#0
;	s_set_alvar	W,y,al_rotz,#0
;	s_set_alvar	W,y,al_sword1,#700
;	s_set_alvar	W,y,al_sword2,#0
;	s_set_alvar	B,y,al_sbyte4,#0
;	P_END65816
;	P_RETURN
;95,8,17_egu_coment_end


;---------------------------------------------------------------------------
; boost on and off subroutines
;---------------------------------------------------------------------------
;95,8,17_egu_coment
;pbooston
;
;;	P_JSL65816	makeengine_srou_l
;;	P_TRIGGER	pboostcode,ALWAYS
;	P_RETURN
;
;pboostcode
;;	P_JSL65816	updateengine_srou_l
;	P_RETURN
;pboostoff
;	P_RETURN
;95,8,17_egu_coment_end


;---------------------------------------------------------------------------
; pollen subroutines
;95,8,17_egu_coment
;ppollen
;;	P_JSL65816	makepollen_srou_l
;	P_RETURN
;95,8,17_egu_coment_end

;---------------------------------------------------------------------------
pslopeon
	P_START65816
	s_clr_alsflag	x,notslope
	P_END65816
	P_RETURN

;---------------------------------------------------------------------------
pslopeoff
	P_START65816
	s_set_alsflag	x,notslope
	P_END65816
	P_RETURN

;---------------------------------------------------------------------------
prandomizeposition
	P_SETRANDOM	pbyte2,31
	P_ADD		worldx,pbyte2
	P_ADD		worldx,-16
	P_SETRANDOM	pbyte2,31
	P_ADD		worldz,pbyte2
	P_ADD		worldz,-16
	P_RETURN
;---------------------------------------------------------------------------
preturn	P_RETURN
;-------
;-------
;------- KARIMASHITA
;-------
;-------

;
;
;
;;************************************************************
;;*********************** Kawaguchi's ************************
;;***********************           **************************
;;*********************** PATH DATA **************************
;;************************************************************
;;********************** Path Data Library *******************
;;Temporary Path Data
;;Friend Base Path Data
;;Enemy Zaco Path Data
;;Enemy Boss Path Data
;;Item Path Data
;;Ring Path Data
;;Building Path Data
;
;;*********************************************************************
;;*								*
;;*		TEMPORARY PATH LIBRARY				*
;;*								*
;;*********************************************************************
;;---------------------------------------------------------------------
;	start_path	kroty
;	p_set	hp,10
;	p_set	ap,0
;	P_shadow	off		;shadow off
;	p_trigger	.rot,always
;	p_end
;.rot
;	p_add	roty,4
;	p_return
;
;
;
;
;
;
;	IFEQ	1
;;--------------------------------------------------------------------
;	start_path	ktest
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;;;;	p_pollen	on
;	p_end
;;---------------------------------------------------------------------
;	start_path	ktestlvsnd
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;	P_SOUND		p2_zako_2	;p2_ering
;.LOOP
;	P_GOTO		.LOOP
;;---------------------------------------------------------------------
;	start_path	ktestlvsnd2
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;	P_SOUND		p2_enemy_fly1
;.LOOP
;	P_GOTO		.LOOP
;;---------------------------------------------------------------------
;	start_path	ktestlvsnd3
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;	P_SOUND		p2_enemy_fly3
;.LOOP
;	P_GOTO		.LOOP
;;---------------------------------------------------------------------
;	start_path	ktestlvsnd4
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;;;;	P_SOUND		p2_laputa
;.LOOP
;	P_GOTO		.LOOP
;;---------------------------------------------------------------------
;	start_path	ktestsndpos
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;.LOOP
;	P_SOUNDEFTPOS	en_jump1_L
;
;	P_WAIT		30
;	P_GOTO		.LOOP
;	p_end
;;---------------------------------------------------------------------
;	start_path	ktestsnddist
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;.LOOP
;	P_SOUNDEFTDIST	en_explode_s	;en_missileshoot_s
;	P_WAIT		20
;	P_GOTO		.LOOP
;	p_end
;;---------------------------------------------------------------------
;	start_path	ktestsnddistpos
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;.LOOP
;	P_SOUNDEFTDISTPOS	en_laser_sL	;en_missileshoot_s
;	P_WAIT		20
;	P_GOTO		.LOOP
;	p_end
;;---------------------------------------------------------------------
;	start_path	ktestsndnearpos
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;.LOOP
;	P_SOUNDEFTPOS	en_laser_sL	;P_SOUNDEFTNEAR	en_laser_sL	;POS	en_laser_sL
;	P_WAIT		20
;	P_GOTO		.LOOP
;	p_end
;;---------------------------------------------------------------------
;	start_path	ktestsndvis
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;.LOOP
;	P_SOUNDEFTVIS	en_laser_sL
;	P_WAIT		20
;	P_GOTO		.LOOP
;	p_end
;;---------------------------------------------------------------------
;	start_path	ktestsnddirect
;	p_set		hp,100		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_RADAROBJ	ra_enemy
;.LOOP
;	P_SOUNDEFTDIRECT	en_laser_sL,nearL
;	P_WAIT		20
;	P_GOTO		.LOOP
;	p_end
;
;;---------------------------------------------------------------------
;	start_path	khp
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_end
;;---------------------------------------------------------------------
;	start_path	kcolloff
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_collisions	off		;collisions off
;	p_end
;;---------------------------------------------------------------------
;	start_path	kmuteki
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_invincible	on		;muteki (on/off)
;	p_end
;;---------------------------------------------------------------------
;	start_path	k3Dmove
;
;	p_setvel	7		;enemy velocity
;	p_alwaysgenvecs	on		;vel to 3D vector
;	p_end
;;---------------------------------------------------------------------
;	start_path	kshadowon
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_shadow	on		;shadow on
;	p_end
;;---------------------------------------------------------------------
;	start_path	kshadowoff
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	P_shadow	off		;shadow off
;	p_end
;;---------------------------------------------------------------------
;	start_path	krotx
;	p_set	hp,10
;	p_set	ap,0
;	p_trigger	.rot,always
;	p_end
;.rot
;	p_add	rotx,4
;	p_return
;;---------------------------------------------------------------------
;	start_path	krotz
;	p_set	hp,10
;	p_set	ap,0
;	p_trigger	.rot,always
;	p_end
;.rot
;	p_add	rotz,32	;4
;	p_return
;;---------------------------------------------------------------------
;	start_path	krotxy
;	p_set	hp,10
;	p_set	ap,0
;	p_trigger	.rot,always
;	p_end
;.rot
;	p_add	rotx,4
;	p_add	roty,4
;	p_return
;
;;---------------------------------------------------------------------
;	start_path	krotxyz
;	p_set	hp,10
;	p_set	ap,0
;	p_trigger	.rot,always
;	p_end
;.rot
;	p_add	rotx,4
;	p_add	roty,4
;	p_add	rotz,4
;	p_return
;
;;---------------------------------------------------------------------
;	start_path	kalways
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_trigger	.always,Always	;jmp every flaME
;	p_end
;.Always
;	p_end
;;---------------------------------------------------------------------
;	start_path	kthrough
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;
;	p_trigger	.through,whenthrough
;	p_end
;
;.through	p_withinradius	30,.playerthrough	;radius check
;	p_return
;
;.playerthrough
;	p_return
;;---------------------------------------------------------------------
;	start_path	kwhenhit
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_trigger	.hit,whenhit
;	p_end
;.hit
;	p_return
;;---------------------------------------------------------------------
;	start_path	ksprite
;	p_collisions	off
;	p_set		hp,50		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_sprite	0,0		;[color,size]
;	p_end
;;---------------------------------------------------------------------
;	start_path	kindexjmp
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;
;	p_set	pbyte1,0		;[0,1,2,...]
;	p_index	pword1,.jumptable,pbyte1
;	p_gosub	pword1
;	p_end
;
;.jumptable
;	dw	.Adr_one&WM
;	dw	.Adr_two&WM
;	dw	.Adr_three&WM
;
;.Adr_one
;	p_return
;.Adr_two
;	p_return
;.Adr_three
;	p_return
;;---------------------------------------------------------------------
;	start_path	kbecome
;	p_set		hp,10		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;
;	p_export	gword1,pword1	;gword1 ,<-- pword1(mother)
;
;	p_spawn		0,-100,128,0,0,0,nullshape,kbecome_sub,10,10
;	p_become
;	p_import	pword1,gword1	;pword1(child)<--- gword1
;	p_unbecome
;	p_end
;
;	start_path	kbecome_sub
;	p_end
;;--------------------------------------------------------------------
;	start_path	kexplain
;	p_set	hp,10
;	p_set	ap,0
;	P_shadow	off		;shadow off
;
;;	p_import	shape,kx_expshape
;;	p_import	pword1,kx_exppath
;	p_gosub		pword1
;	p_end
;;----------------------------------------
;	start_path	kexp1
;	P_TRIGGER	.add_tx,Always
;	P_IGOTO		.pass
;.add_tx
;	P_ADD		tx,5
;	P_RETURN
;.pass
;	start_path	kexp7
;	start_path	kexp8
;	start_path	kexp9
;	start_path	kexp10
;	p_set	worldz,600
;	p_igoto		expset
;
;	start_path	kexp2
;	p_set	worldy,50
;	p_set	worldz,300
;	p_igoto		expset
;
;	start_path	kexp3
;	p_set	worldy,100
;	p_set	worldz,500
;	p_setanim	0
;	p_igoto		expset
;
;	start_path	kexp4
;	p_set	worldy,70
;	p_set	worldz,800
;	p_igoto		expset
;
;	start_path	kexp5
;	p_set	worldz,100
;	p_sprite	0,0		;[color,size]
;	p_igoto		expset
;
;	start_path	kexp6
;	p_set	worldz,500
;;	p_spawn	0,0,0,0,0,16,kurage_1_1,e_nocol_s_off,100,0,1
;	p_igoto		expset
;
;expset
;.loop
;	p_add	roty,4
;	P_GOTO	.loop
;
;;*************************************************************************
;;*************************************************************************
;;*************************************************************************
;;========================================================================
;	ifeq	1
;	start_path	sprite_0
;	p_sprite	0
;	p_IGOTO		set
;	start_path	sprite_1
;	p_sprite	0,32
;	p_igoto		set
;	start_path	sprite_2
;	p_sprite	0,64
;set
;	p_shadow	off
;	p_collisions	off
;	p_spawn		000,10,000,0,0,0,s_8,shadow_0,10,10
;	p_end
;
;;-------------- Child Path Data ------------------------------------
;	start_path	shadow_0
;	p_collisions	off
;	p_end
;	endc
;;========================================================================
;	ifeq	0
;	start_path	sprite_0
;	p_sprite	0
;	p_collisions	off
;	p_spawn		000,10,000,0,0,0,s_8,shadow_0,10,10
;	p_end
;
;	start_path	sprite_1
;	p_collisions	off
;	p_sprite	0,32
;	p_spawn		000,15,000,0,0,0,s_8,shadow_0,10,10
;	p_end
;
;	start_path	sprite_2
;	p_collisions	off
;	p_sprite	0,64
;	p_spawn		000,20,000,0,0,0,s_8,shadow_0,10,10
;	p_end
;
;;-------------- Child Path Data ---------------
;	start_path	shadow_0
;	p_shadow	off
;	p_collisions	off
;	p_end
;
;
;	endc
;;*********************************************************************
;;*								*
;;*			Friend Base Path Data 			*
;;*								*
;;*********************************************************************
;	start_path	kbase0
;
;	p_set		hp,100
;	p_set		ap,0
;
;;	p_spawn		000,040*2,000,0,0,0,daruma_0,daruhako0,50,0,1
;;	p_spawn		000,060*2,000,0,0,0,daruma_1,daruhako1,50,0,2
;;	p_spawn		000,080*2,000,0,0,0,daruma_0,daruhako0,50,0,3
;;	p_spawn		000,095*2,000,0,0,0,daruma_0,daruhako0,50,0,4
;;	p_spawn		000,115*2,000,0,0,0,daruma_1,daruhako0,50,0,5
;;
;	p_collisions	off
;	p_end
;
;;-------------- Child Path Data ---------------
;	start_path	daruhako0
;	start_path	daruhako1
;
;	p_collisions	off
;	p_end
;
;;*********************************************************************
;;*								*
;;*			Enemy Zaco Path Data			*
;;*								*
;;*********************************************************************
;;---------------------------------------------------------------------
;;*			Zaco 5 Path Data			*
;;---------------------------------------------------------------------
;	start_path	kpzaco_5
;	p_set		hp,50		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_setvel	30		;enemy velocity
;	p_alwaysgenvecs	on		;vel to 3D vector
;
;;;	P_WEAPON	laser2		;weapon kind
;
;;;;;;	P_GOSUB		randomplayer	;player select
;	p_player	1
;.loop
;	p_faceplayer			;turn player
;	P_DISTLESS	2000,.dontswap
;	P_SWAPPLAYER
;.dontswap
;	P_DO	15
;	P_FACEPLAYER
;	P_SET	rotx,0
;	P_NEXT
;
;	P_ADD		worldy,-50
;	P_FIRE		ATPLAYER,CANHIT
;	P_ADD		worldy,50
;	P_GOTO	.loop
;
;;---------------------------------------------------------------------
;;*			Robot Path Data				*
;;---------------------------------------------------------------------
;	start_path	krobo_0
;
;	p_set		hp,50		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_setvel	7		;enemy velocity
;	p_alwaysgenvecs	on		;vel to 3D vector
;;;;	P_WEAPON	laser2		;weapon kind
;	P_shadow	on
;;;;;;	P_GOSUB		randomplayer	;player select
;	p_player	1
;	p_trigger	.fire,32	;enemy fire
;
;.loop
;	P_DISTLESS	500,.DoNothing	;if player distance <500
;
;	P_DISTLESS	2000,.dontswap	;if player distance <2000
;	P_SWAPPLAYER
;
;.dontswap
;
;;**** Player Search ****
;	P_DO	15
;	P_FACEPLAYER
;	P_SET	rotx,0
;	P_NEXT
;
;.DoNothing
;	P_GOTO	.loop
;
;;**** Laser Fire *****
;.fire
;	P_ADD		worldy,-50
;	P_FIRE		ATPLAYER,CANHIT
;	P_ADD		worldy,50
;	p_return
;;---------------------------------------------------------------------
;;*			Gun Shot				*
;;---------------------------------------------------------------------
;	start_path	kgunshot_0
;
;	p_set		hp,50		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_zero		pbyte1		;path pointer
;	p_setvel	7		;enemy velocity
;	p_alwaysgenvecs	on		;vel to 3D vector
;;;	P_WEAPON	laser2		;weapon kind
;	P_shadow	on		;shadow on/off
;;;	P_GOSUB		randomplayer	;player select
;
;.MainLoop
;	P_DISTLESS	300,.LaserShot	;if player distance <300
;	P_DISTLESS	2000,.dontswap	;if player distance <2000
;
;;;;;;	P_SWAPPLAYER
;
;;**** Player Search ****
;.dontswap
;;;;	p_set	shape,gun_walk
;	p_setvel	7		;enemy velocity
;	P_DO	15
;	P_FACEPLAYER
;	P_SET	rotx,0
;	P_NEXT
;
;	P_WAIT	20
;
;;;;	p_set	shape,gun_walk
;	p_setvel	0		;enemy velocity
;	P_WAIT	5
;
;	P_GOTO	.MainLoop
;
;;***** Player Look ********
;.PLayerLook
;	p_setvel	2		;enemy velocity
;
;;;;	p_set	shape,gun_look
;
;	P_DO	15
;	P_FACEPLAYER
;	P_SET	rotx,0
;	P_NEXT
;	p_goto	.MainLoop
;
;;**** Laser Shot *****
;.LaserShot
;.Loop_LaserShot
;
;;;;	p_set	shape,gun_pose
;	p_setanim	0
;
;	p_do		17
;	p_addanim	1,18
;	p_next
;
;	p_wait	8
;
;;;;	p_set	shape,gun_shot
;	p_setanim	0
;
;	p_do		8
;	p_addanim	1,8
;	p_next
;	p_gosub	.fire
;
;	p_do		8
;	p_addanim	1,8
;	p_next
;	p_gosub	.fire
;
;	p_wait	20
;
;	p_goto	.MainLoop
;
;
;	ifeq	1
;	p_index	pword1,.shottable,pbyte1
;	p_gosub	pword1
;
;	p_do		16
;	p_addanim	1,16
;	p_next
;	P_GOTO	.Loop_LaserShot
;
;.gun_look
;	p_setvel	3		;enemy velocity
;	p_set	pbyte1,1
;;	p_set	shape,gun_look
;	p_setanim	0
;	P_return
;.gun_pose
;	p_set	pbyte1,2
;;	p_set	shape,gun_pose
;	p_setanim	0
;	p_return
;.gun_shot
;;;	p_set	shape,gun_shot
;	p_setanim	0
;	p_return
;	endc
;
;;**** Laser Fire *****
;.fire
;	P_ADD		worldy,20
;	P_FIRE		ATPLAYER,CANHIT
;	P_ADD		worldy,-20
;	p_return
;
;	ifeq	1
;.shottable
;	dw	.gun_look&WM
;	dw	.gun_pose&WM
;	dw	.gun_shot&WM
;	endc
;;---------------------------------------------------------------------
;;*			Batta Path Data				*
;;---------------------------------------------------------------------
;	start_path	kbatta_0
;
;	p_set		hp,50		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;	p_setvel	7		;enemy velocity
;	p_alwaysgenvecs	on		;vel to 3D vector
;;;	P_WEAPON	laser2		;weapon kind
;	P_shadow	on
;	P_set		pbyte1,-32
;
;;;;;;	P_GOSUB		randomplayer	;player select
;	p_player	1
;	p_trigger	.fire,32	;enemy fire
;
;.loop
;	P_DISTLESS	500,.Mov	;if player distance <500
;
;	P_DISTLESS	2000,.dontswap	;if player distance <2000
;	P_SWAPPLAYER
;.dontswap
;
;;**** Player Search ****
;	P_DO	15
;	P_FACEPLAYER
;	P_SET	rotx,0
;	P_NEXT
;.mov
;	P_ADD	worldy,pbyte1
;	p_add	pbyte1,4
;	P_ifnotsame	pbyte1,36,.DoNothing
;	P_set	pbyte1,-32
;.DoNothing
;	P_GOTO	.loop
;
;;**** Laser Fire *****
;.fire
;	P_ADD		worldy,-50
;	P_FIRE		ATPLAYER,CANHIT
;	P_ADD		worldy,50
;	p_return
;
;;---------------------------------------------------------------------
;;*
;;---------------------------------------------------------------------
;
;
;;*********************************************************************
;;*								*
;;*			Enemy Boss Path Data			*
;;*								*
;;*********************************************************************
;;========================= Duncing Insector ==========================
;	start_path	dancing
;	p_set		hp,100
;	p_set		ap,0
;	ifeq	1
;	p_spawn		000,00,-48,0,72*0,0,boss_h_1,reg1,50,0,1
;	p_spawn		028,30,040,0,72*1,0,boss_h_1,reg2,50,0,2
;	p_spawn		-48,30,-16,0,72*2,0,boss_h_1,reg3,50,0,3
;	p_spawn		048,30,-16,0,72*3,0,boss_h_1,reg4,50,0,4
;	p_spawn		000,30,-48,0,72*4,0,boss_h_1,reg5,50,0,5
;	
;	p_spawn		0,5,0,0,0,0,boss_h_2,head1,50,0,6
;	endc
;	p_end
;
;;--------------------------------------------------------------------
;	start_path	reg1
;	p_inc		pbyte1
;	start_path	reg2
;	p_inc		pbyte1
;	start_path	reg3
;	p_inc		pbyte1
;	start_path	reg4
;	p_inc		pbyte1
;	start_path	reg5
;
;	p_collisions	off
;	p_trigger	.walk,Always
;	p_end
;
;
;.walk
;	p_index		animframe,.regtable,pbyte1
;	p_inc		pbyte1
;	p_ifnotsame	pbyte1,10,.notsame
;
;	p_zero		pbyte1
;.notsame
;	p_return
;
;.regtable
;	db	1+128,2+128,3+128,4+128,5+128
;	db	6+128,5+128,4+128,3+128,2+128
;
;;--------------------------------------------------------------------
;	start_path	head1
;
;	p_collisions	off
;	p_end
;
;;*********************************************************************
;;*								*
;;*			Recover HP Path Data 			*
;;*								*
;;*********************************************************************
;	start_path	KBOXrecover
;	start_path	test_whensteppedon
;	p_set		hp,50		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;
;	p_start65816
;	s_clr_alsflag	x,notslope	;Slope
;	p_end65816
;
;;dono saka ni nokkateiruka wo check (saka niwa sorezore number ga aru)
;
;	p_set	slopenum,1		;slope Noumber set
;.Check_stepon
;	P_trigger	.JmpStepOn,whensteppedon
;	p_end
;
;.JmpStepOn
;	p_force		.StepOn
;	p_return
;;-------------------------------------
;;*	If Step On		*
;;-------------------------------------
;.StepOn
;	p_trigger	.StepOn,off
;
;	p_ifplayer	2,.player2
;.player1
;	p_import	pbyte1,player1_hpadd
;	p_add		pbyte1,1
;	p_export	player1_hpadd,pbyte1	;plaer 1 HP recover
;	p_igoto		.wait
;.player2
;	p_import	pbyte1,player2_hpadd
;	p_add		pbyte1,1
;	p_export	player2_hpadd,pbyte1	;plaer 2 HP recover
;
;.wait	p_loop		10,.wait
;	p_goto		.Check_stepon	
;;*********************************************************************
;;*								*
;;*			Building Path Data 			*
;;*								*
;;*********************************************************************
;	start_path	kbuild
;
;	p_set		hp,10
;	p_set		ap,0
;	p_collisions	off
;	p_end
;;---------------------------------------------------------------------
;	start_path	kisu_0
;
;	p_set		hp,10
;	p_set		ap,2
;	p_collisions	off
;;	p_spawn	-40*2,0,040*2,0,0,0,isu_0,kisu_sub0,10,10,1
;;	p_spawn	040*2,0,040*2,0,0,0,isu_1,kisu_sub0,10,10,2
;;	p_spawn	-40*2,0,-40*2,0,0,0,isu_2,kisu_sub0,10,10,3
;;	p_spawn	040*2,0,-40*2,0,0,0,isu_3,kisu_sub0,10,10,4
;;
;	p_end
;	p_end
;
;
;	start_path	kisu_sub0
;	p_set		hp,10
;	p_set		ap,0
;	p_collisions	off
;	p_end
;
;
;
;;*********************************************************************
;;*								*
;;*			Ring Path Data	 			*
;;*								*
;;*********************************************************************
;	start_path	ktest1
;	start_path	ktest2
;	start_path	ktest3
;	start_path	ktest4
;	start_path	ktest5
;	start_path	ktest6
;
;	p_set		hp,10
;	p_set		ap,2
;
;	p_collisions	off
;
;;	p_debris	training
;
;	p_trigger	.Through_check,Always
;	p_end
;;---------------------------------------------------------------
;.Through_check
;	p_player	1
;	P_WITHINRADIUS	80,.SkipPl1
;	p_player	2
;	P_WITHINRADIUS	80,.SkipPl2
;	p_return
;
;.SkipPl1
;	p_force		.Through_player1
;	p_return
;
;.SkipPl2
;	p_force		.Through_player2
;	p_return
;;------------------ Through Ring -------------------
;.Through_player1
;	p_trigger	.Through_check,off
;
;;*** HP ADD ***
;	p_import	pbyte1,player1_hpadd
;	p_add		pbyte1,1
;	p_export	player1_hpadd,pbyte1
;
;	p_score		100
;;	P_SOUNDEFT	CatchMedal	;$10
;	p_set	coltab,id_0_c
;
;;	p_particles
;;	p_gosub		.rot
;;	p_trigger	.Through_check,Always
;	p_end
;
;.Through_player2
;	p_trigger	.Through_check,off
;
;;*** HP ADD ***
;	p_import	pbyte1,player2_hpadd
;	p_add		pbyte1,1
;	p_export	player2_hpadd,pbyte1
;
;	p_score		100
;;	P_SOUNDEFECT	CatchMedal	;$10
;	p_set	coltab,id_1_c
;
;;	p_particles
;
;;	p_gosub		.rot
;
;;	p_trigger	.Through_check,Always
;	p_end
;
;
;.rot	
;	p_do		16
;	p_add		roty,32
;	p_next
;
;	p_return
;;*************************************************************
;;*			KRING				*
;;*************************************************************
;	start_path	kring
;	p_set		hp,10
;	p_set		ap,10
;	p_collisions	off	;collision OFF
;
;	p_trigger	.Through_check,whenthrough
;	p_end
;;-----------------------------------------------------
;;*		Ring Through Check		*
;;-----------------------------------------------------
;.Through_check
;	p_player	1
;	P_WITHINRADIUS	80,.SkipPl1
;	p_player	2
;	P_WITHINRADIUS	80,.SkipPl2
;	p_return
;
;.SkipPl1
;	p_force		.Through_player1
;	p_return
;
;.SkipPl2
;	p_force		.Through_player2
;	p_return
;;-----------------------------------------------------
;;*		Player1		[Ring Through]	*
;;-----------------------------------------------------
;.Through_player1
;	p_trigger	.Through_check,off
;
;;---- HP Restore ----
;	p_import	pbyte1,player1_hpadd
;	p_add		pbyte1,1
;	p_export	player1_hpadd,pbyte1
;
;;---- score ---
;;	p_import	pword1,kplayer1score
;;	p_add		pword1,100
;;	p_export	kplayer1score,pword1
;
;	p_score		100
;;--- sound set ---
;;	P_SOUNDEFFECT	CatchMedal	;$1b
;
;;--- color ID change ---
;	p_set	coltab,id_0_c
;
;	p_gosub		.rot
;	p_trigger	.Through_check,Always
;	p_end
;
;;-----------------------------------------------------
;;*		Player2		[Ring Through]	*
;;-----------------------------------------------------
;.Through_player2
;	p_trigger	.Through_check,off
;
;;---- HP Restore -----
;	p_import	pbyte1,player2_hpadd
;	p_add		pbyte1,1
;	p_export	player2_hpadd,pbyte1
;;---- score ---
;;	p_import	pword1,kplayer2score
;;	p_add		pword1,100
;;	p_export	kplayer2score,pword1
;
;	p_score		100
;;--- sound set ---
;;	P_SOUNDEFFECT	CatchMedal	;$1b
;
;;--- color ID change ---
;	p_set	coltab,id_1_c
;
;	p_gosub		.rot
;
;	p_trigger	.Through_check,whenthrough
;	p_end
;;-----------------------------------------------------
;;*	Ring Rotation sub routine		*
;;-----------------------------------------------------
;.rot	
;	p_do		16
;	p_add		roty,32
;	p_next
;
;	p_return
;
;;*************************************************************
;;*			KRING2				*
;;*************************************************************
;	start_path	kring2
;	p_set	hp,50
;	p_set	ap,0
;	p_invincible	on
;;;;	p_spawn		0,0,0,0,0,0,training,kring_sub,4,2,link	
;
;	p_trigger	.Through_check,whenthrough
;	p_end
;
;;--------------------------------------------------------------------
;.Through_Check
;
;	p_player	1
;	p_withinradius	30,.P1Hitjump
;
;	p_player	2
;	p_withinradius	30,.P2Hitjump
;	p_return
;.P1Hitjump
;	p_force		.P1Hit
;	p_return
;.P2Hitjump
;	p_force		.P2Hit
;	p_return
;
;
;.P1Hit
;	p_trigger	.Through_check,off
;
;	p_import	pbyte2,kbyte1
;	p_inc		pbyte2
;	p_export	kbyte1,pbyte2
;	
;
;	p_shapedead	.dontdo1
;	p_becomeshape
;	p_set	coltab,id_0_c
;	p_set	pbyte1,1
;	p_unbecome
;.dontdo1
;	p_wait		30
;
;	p_trigger	.Through_check,whenthrough
;	p_end
;.P2Hit
;	p_trigger	.through_check,off
;
;	p_import	pbyte2,kbyte2
;	p_inc		pbyte2
;	p_export	kbyte2,pbyte2
;
;	p_shapedead	.dontdo2
;	p_becomeshape
;	p_set	coltab,id_1_c
;	p_set	pbyte1,1
;	p_unbecome
;.dontdo2
;	p_wait		30
;
;	p_trigger	.Through_check,whenthrough
;	p_end
;
;
;;-------------------------------------------------------------------
;;kitem
; 	start_path	kring_sub
;	p_invincible	on	
;	p_collisions	off   
;
;.loop
;	p_ifsame	pbyte1,1,.rot
;	p_goto		.loop
;
;
;.rot
;		p_do	10	
;		p_add	roty,16
;		p_next
;
;		P_zero	pbyte1
;
;		p_goto		.loop
;
;;============================= KRING 3 ===============================
;	start_path	kring3
;
;	start_path	kring4
;
;	start_path	kring5
;
;	p_set		hp,10
;	p_set		ap,2
;
;	p_collisions	off
;
;	p_trigger	.through_check,whenthrough
;.mov
;	p_do		25
;	p_add		worldy,-16
;	p_next
;
;	p_wait		10
;
;	p_do		25
;	p_add		worldy,16
;	p_next
;
;	P_goto		.mov
;;---------------------------------------------------------------
;.Through_check
;	p_player	1
;	P_WITHINRADIUS	50,.SkipPl1
;	p_player	2
;	P_WITHINRADIUS	50,.SkipPl2
;	p_return
;
;
;.SkipPl1
;	p_force		.Through_player1
;	p_return
;
;.SkipPl2
;	p_force		.Through_player2
;	p_return
;;------------------ Through Ring -------------------
;.Through_player1
;	p_trigger	.Through_check,off
;
;;---- HP Restore --------------------------------------------------------
;	p_start65816
;
;	phb
;	db7e
;	s_set_objtobeplayer1	x	;player1 pointer
;
;	lda	al_hp,x
;	clc
;	adc	#04
;	cmp	#41
;	bpl	.P1Hp_over
;	sta	al_hp,x
;	
;;	km_plheapptr	1,x
;;	setflag		KHITFLASH,#$80,x	;Flag:Copy CGX data to Maio RAM
;.P1Hp_over
;	plb
;	p_end65816
;;------------------------------------------------------------------------
;
;	p_import	pbyte2,kbyte1
;	p_inc		pbyte2
;	p_export	kbyte1,pbyte2
;
;	p_score		100
;;	P_SOUNDEFFECT	CatchMedal	;$10
;	p_set	coltab,id_0_c
;
;	p_gosub		.rot
;	p_trigger	.Through_check,whenthrough
;	p_end
;
;.Through_player2
;	p_trigger	.Through_check,off
;;---- HP Restore --------------------------------------------------------
;	p_start65816
;
;	phb
;	db7e
;	s_set_objtobeplayer2	x	;player2 pointer
;
;	lda	al_hp,x
;	clc
;	adc	#04
;	cmp	#41
;	bpl	.P2Hp_over
;	sta	al_hp,x
;	
;;	km_plheapptr	2,x
;;	setflag		KHITFLASH,#$80,x	;Flag:Copy CGX data to Maio RAM
;.P2Hp_over
;	plb
;	p_end65816
;;------------------------------------------------------------------------
;	p_import	pbyte2,kbyte2
;	p_inc		pbyte2
;	p_export	kbyte2,pbyte2
;
;	p_score		100
;;	P_SOUNDEFFECT	CatchMedal	;$10
;	p_set	coltab,id_1_c
;	p_gosub		.rot
;
;	p_trigger	.Through_check,whenthrough
;	p_end
;
;
;.rot	
;	p_do		16
;	p_add		roty,32
;	p_next
;
;	p_return
;;*********************************************************************
;;*			ITEM PATH Data				*
;;*								*
;;*********************************************************************
;
;	start_path	kg_coin_0
;;Initial
;	p_set		hp,80		;enemy Hit Point
;	p_set		ap,0		;enemy Attack Point
;;	p_collisions	off
;	P_shadow	off	;shadow
;
;	p_trigger	.hit,whenhit
;	p_spawn		000,0,000,0,0,0,s_4,shadow_1,10,10
;
;	P_END
;	P_END
;
;.hit	p_force		.forcejmp_hit
;	p_return
;
;.forcejmp_hit
;	p_do	32
;	p_add	roty,16
;	p_next
;	p_end
;;-------------- Child Path Data ---------------
;	start_path	shadow_1
;;;;;	p_shadow	on
;	p_collisions	off
;	p_end
;
;	ENDC
