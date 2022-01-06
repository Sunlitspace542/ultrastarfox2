;;;
;;;	 incpub	pathdata
;;;;
;;;;ebyte1 msg wo aratani hyoujishitemo yoika 0=OK/num=DAME
;;;;ebyte2 final door no lock kaijyono owatta kaisuu
;;;;ebyte2 space no wolf no tamedama 0=ataru/1=ataranai
;;;;ebyte3 tojikome door no lock kaijyono owatta kaisuu
;;;;ebyte4 semi final door no lock kaijyono owatta kaisuu
;;;;ebyte5 roomde de 1way_door no jyoutai 0=open/1=crose
;;;;ebyte5 bit3		space de msg_maker no jyoutai 0=inai/1=iru
;;;;ebyte6 bit1		demo ga owattaka doukano flag 0=demo/1=finished
;;;;ebyte6 bit2,3,4	yousai no antenna no jyoutai 0=mada/1=finished
;;;;ebyte6 bit5		modore no friend hikoucyuu flag 0=nashi/1=hikoucyuu
;;;;ebyte6 bit6,7,8	c_cup_switch no jyoutai 0=mada/1=finished
;;;;ebyte6 all_bit   space de carier kara deru teki no kazu
;;;;ebyte7 tsuuro no jyoutai 0=groundobj ON/1=groundobj OFF
;;;;ebyte8 base nai no teki detemo iika 0=ok/1=dame
;;;;eword1 item no switch (stage gotoni init sareru) 0=mada/1=totta
;;;;eword2 dono hajimete msg wo hyoujisuruka 0=hyouji shinai/num=message number
;;;;eword3 hajimete msg no flag 1		2		3		4	      
;;;;			saisyu line	teach base	teach robo	teach magma
;;;;			5		6		7		8
;;;;			teach boost	teach airLR	teach robLR	teach fuse
;;;;			9		16
;;;;			pepper teach	teach henkei 
;;;
;;;;omake medal no number
;;;;
;;;;$40 mukade koroshitara
;;;;$41 sagyou box taoshitara
;;;;$42 hae box taoshitara
;;;;$43 kao man wo uttara
;;;;$44 kabemukade stg1_3
;;;;$45 kabemukade stg4_5
;;;;$46 kabemukade ext2_2
;;;;$47 kabemukade stg1_5
;;;;
;;;;;;;;;;;;;;;;;;;;;
;;;;;slope ni nottatokino takasa ga wakaru (pword1)
;;;;
;;;;	P_JSL65816	getheight_l
;;;;	P_IMPORT	pword1,y1	
;;;;
;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;showtrigs
;;;	P_START65816
;;;	ldy	al_stratmem,x
;;;	lda.w	heap,y
;;;	printd	Triggers,eguchi
;;;
;;;	sta	pathx1
;;;	iny
;;;.lp
;;;	a16
;;;	lda.w	heap,y
;;;	printh	T,eguchi
;;;	a8
;;;	iny
;;;	iny
;;;	iny
;;;	iny
;;;	dec	pathx1
;;;	bne	.lp
;;;
;;;	P_END65816
;;;	P_RETURN
;;;;ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;;;;บ                                                            บ
;;;;บ                    EGUCHI'S PATHDATA                       บ
;;;;บ                                                            บ
;;;;ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

junko_speed		equ	10
run_speed		equ	20
sankai_speed		equ	60

action_dist		equ	10000

;;;;ษออออออออออป
;;;;บ DARK FOX บ
;;;;ศออออออออออผ
;;	START_PATH	e_wolf_demo
;;
;;	P_RADAROBJ	ra_sonota
;;	P_INVISIBLE	ON
;;	P_WAIT		80	;test
;;
;;	P_COPYPLAYERPOS
;;	P_ADD		worldz,12000
;;
;;	P_QSPAWN	wolf,e_wolf_demo_shape,10,10
;;	P_BECOME
;;	P_ACTIVE	ON
;;	P_ADD		worldz,10000
;;	P_ADD		worldy,-6000
;;	P_UNBECOME
;;	P_LINKTOBECOME
;;	P_FACESHAPE	IMMEDIATE
;;	P_SETCAMERA	IMMEDIATE
;;	P_ADD		roty,16
;;	P_ADD		rotx,16
;;	P_DO		2
;;	P_SETCAMERA	IMMEDIATE
;;	P_NEXT
;;	P_FLAGSHAPE
;;.more
;;	P_BEGINDEMO
;;
;;	P_GOSUB		.get_speed
;;
;;	P_DO		3
;;	P_DIV2		vx
;;	P_DIV2		vy
;;	P_DIV2		vz
;;	P_INEXT
;;	P_DO		20
;;	P_SETCAMERA
;;	P_NEXT
;;
;;	P_GOSUB		.get_speed
;;
;;	P_DO		100
;;	P_SETCAMERA
;;	P_NEXT
;;
;;	P_ENDDEMO
;;
;;	P_REMOVE
;;	P_END
;;.get_speed
;;	P_BECOMESHAPE
;;	P_EXPORT	gword1,vx
;;	P_EXPORT	gword2,vy
;;	P_EXPORT	gword3,vz
;;	P_UNBECOME
;;	P_IMPORT	vx,gword1
;;	P_IMPORT	vy,gword2
;;	P_IMPORT	vz,gword3
;;	P_RETURN
;;;------------
;;	START_PATH	e_wolf_demo_shape
;;
;;	P_ADD		roty,120
;;	P_ADD		rotx,24
;;	P_COLLISIONS	OFF
;;	P_QUADVECS	ON
;;.wait
;;	P_IFFLAG	.go
;;	P_GOTO		.wait
;;.go
;;	P_SETVEL	100
;;	P_END
;------------
	START_PATH	e_tamedama

	P_SETANIM	0
	p_settype	LASER
	P_SET		coltab,id_1_c&wm
	P_RTRIGGER	.hit_rem,WhenHit
	P_RTRIGGER	.dead_coli,Always

	P_IMPORT	pbyte1,KDifficulty
	P_IFSAME	pbyte1,dif_hard,.go
	P_IFSAME	pbyte1,dif_normal,.normal_ap
	P_SET		ap,4
	P_IGOTO		.go
.normal_ap
	P_SET		ap,6
.go
	P_SOUNDEFTDISTPOS	en_wolf_s_shot	;$b9
	P_SOUND		p2_wolf_laser	;0F	;sdst5

	P_DO		64
	P_DISTMORE	8000,.far
	P_SETVEL	0

		P_DO		3
		P_MOVEINPLAYER	100
		P_INEXT

	P_GOSUB		.rot
	P_IGOTO		.ne
.far
	P_QUADVECS	ON
	P_SETVEL	100
	P_FACEPLAYER	y
.ne
	P_NEXT
.rem
	P_REMOVE
.rot
	P_ADD		rotx,32
	P_ADD		roty,32
	P_RETURN
.dead_coli
	P_IMPORT	pbyte1,ebyte2
	P_IFZERO	pbyte1,.ok
	P_FORCE		.rem
.ok
	P_RETURN
.hit_rem
	P_FORCE		.rem
	P_RETURN
;-----------
	START_PATH	e_wolf_tame

	p_collisions	off
	p_sprite	0,16
.lp
	P_DO		15
	P_ADD		tx,2
	P_NEXT
	P_WAIT		1
	P_SET		shape,tamatamal
	P_END
;------------
	START_PATH	e_find_tame


	P_INVISIBLE	ON
	P_TRIGGER	.find_tame,2
.lp
	P_IMPORT	pbyte1,ebyte2
	P_IFNOTZERO	pbyte1,eg_remove
	P_FINDSHAPE	wolf_1_eg
	P_SHAPEDEAD	.f_wolf_eg
	P_IGOTO		.cop
.f_wolf_eg
	P_FINDSHAPE	wolf_eg
	P_SHAPEDEAD	eg_remove
.cop
	P_BECOMESHAPE
	P_GOSUB		expo_world
	P_UNBECOME
	P_GOSUB		impo_world
	P_GOTO		.lp	
;.rem
;	P_REMOVE
.find_tame
	P_FINDSHAPE	tame
	P_SHAPEDEAD	.f_tamel
	P_IGOTO		.teach
.f_tamel
	P_FINDSHAPE	tamel
	P_SHAPEDEAD	.ret
.teach
	P_SHAPEDISTMORE	4000,.ret
	P_GSET		b,eftame,1
;	P_GSET		b,eaction2,1
	P_TRIGGER	.find_tame,OFF
	P_TRIGGER	.find_start_again,Timer,25
	P_FORCE		.lp
.ret
	P_RETURN
.find_start_again
	P_TRIGGER	.find_tame,2
	P_RETURN
;-------------
;pbyte1=free
;pbyte2=rotation no index
;slopenum=half of hp
;pword1=free
;childrotx
;childroty
;childrotz=movement
;childx=move counter
;tx=ref_rot_angle
;ty=ref_rot_counter
;childy=kaitenflag
;childz=collision 0=on/1=off
	START_PATH	e_star_wolf

	P_GSET		b,eftame,0
	P_INVISIBLE	ON
	P_RADAROBJ	ra_enemy

	P_GOSUB		wait_start_trigger
	P_GSET		b,ebyte1,70

	P_GOSUB		set_hp100_ap4_enemy
	P_ENEMYDMGSE	en_dmg_2	;$65*
	P_COPYPLAYERPOS
	P_ADD		worldz,3000
	P_ADD		worldx,10000
	P_SET		worldy,-4000
	P_FACEPLAYER	IMMEDIATE
	P_ADD		worldz,5000
	P_INVISIBLE	OFF

	P_SOUND		p2_wolf_arwing	;01
	P_ENEMYRBDSE	reboundlaser2

	P_COLLISIONS	OFF
	P_RTRIGGER	.keep_dist,Always
	P_TRIGGER	.first_msg,Timer,30

	P_QSPAWN	nullshape,e_find_tame,10,10

	P_IMPORT	pbyte1,KDifficulty
	P_IFSAME	shape,wolf_1_eg,.set_hp		;yowaihounara
	P_INC		pbyte1
.set_hp
	P_INDEX		hp,e_wolf_hp,pbyte1
	P_SET		slopenum,hp
	P_ADD		slopenum,-40
	P_DIV2		slopenum
	P_ADD		slopenum,40
	P_INC		slopenum

	P_GOSUB		bm_star_wolf

	P_IMPORT	pbyte1,STARWOLFNO
	P_IFZERO	pbyte1,.this_hp
	P_IFSAME	pbyte1,1,.ck_leon
	P_IFSAME	pbyte1,2,.ck_pigma
	P_IMPORT	pbyte1,ehp_algy
	P_IGOTO		.ck_hp
.ck_leon
	P_IMPORT	pbyte1,ehp_leon
	P_IGOTO		.ck_hp
.ck_pigma
	P_IMPORT	pbyte1,ehp_pigma
.ck_hp
	P_IFZERO	pbyte1,.this_hp
.init_hp
	P_ADD		pbyte1,10
	P_IFLARGER	hp,pbyte1,.kok
	P_SET		pbyte1,hp
.kok
	P_SET		hp,pbyte1
	P_GOSUB		bm_in.hit
.this_hp
	P_RTRIGGER	.keep_hi,Always
	P_TRIGGER	.gurari,WhenHit
	P_TRIGGER	.find_pl_tame,Always

	P_ZERO		worldy

	P_SET		childrotx,40
	P_SET		childroty,2
	P_SET		childrotz,40
	P_QUADVECS	ON
.main_action
	P_ACCEL		100,1
	P_ZERO		childx

	P_RTRIGGER	.change_turn,128
	P_RTRIGGER	.change_updw,64
.turn_lp
	P_INC		childx
	P_IFSAME	childx,60,.atack
	P_IFNOTZERO	childy,.now_rot
	P_CHASE		rotz,childrotz
.now_rot
	P_CHASE		rotx,childrotx
	P_ADD		roty,childroty
	P_GOTO		.turn_lp
;------------
.keep_dist
	P_DISTLESS	15000,.dist_ok
	P_COLLISIONS	OFF
	P_DO		5
	P_FACEPLAYER	y
	P_INEXT
	P_RETURN
.dist_ok
	P_IFNOTZERO	childz,.ret_col
	P_COLLISIONS	ON
.ret_col
	P_RETURN
;------------
.keep_hi
	P_SET		pword1,-4000
	P_IFSMALLER	worldy,pword1,.p4000
	P_SET		pword1,4000
	P_IFLARGER	worldy,pword1,.p4000
	P_CHILDDEAD	10,.b_nai
	P_REMOVE	10
	P_REMOVE	11
.b_nai
	P_CHILDDEAD	9,.mk_boost
	P_RETURN
.p4000
	P_SET		worldy,pword1
	P_CHILDDEAD	9,.boo_nai
	P_REMOVE	9
.boo_nai
	P_CHILDDEAD	10,.breki
	P_RETURN
.breki
	P_SPAWN		-30<<wolf_eg_scale,5<<wolf_eg_scale,20<<wolf_eg_scale,0,0,0,boost,e_sp_boost,100,70,10
	P_SPAWN		030<<wolf_eg_scale,5<<wolf_eg_scale,20<<wolf_eg_scale,0,0,0,boost,e_sp_boost,100,70,11
	P_RETURN
;-------------
.mk_boost	LOCAL
	P_SOUNDEFTDISTPOS	partner_boost	;$46
	P_SPAWN		0,-5<<wolf_eg_scale,-60<<wolf_eg_scale,0,0,0,boost,e_sp_boost,100,100,9
	P_RETURN
;-------------
.change_turn
	P_NEG		childrotz
	P_NEG		childroty
	P_RETURN
.change_updw
	P_NEG		childrotx
	P_RETURN
;;-----------
.tame_atack
	P_IFSAME	pbyte1,dif_hard,.hard_t
	P_IFSAME	pbyte1,dif_normal,.normal_ret
	P_RANDOMGOTO	.futsuu_atack
.normal_ret
	P_RANDOMGOTO	.futsuu_atack
.hard_t
	P_SPAWN		0,15<<wolf_eg_scale,15<<wolf_eg_scale,0,0,0,tametamel,e_wolf_tame,10,10,1
.tame_lp
	P_INC		childx
	P_IFSAME	childx,80,.tame_fire
	P_IFNOTZERO	childy,.now_rot2
	P_CHASE		rotz,childrotz
.now_rot2
	P_CHASE		rotx,childrotx
	P_ADD		roty,childroty
	P_GOTO		.tame_lp
.tame_fire
	P_TRIGGER	.change_turn,OFF
	P_TRIGGER	.change_updw,OFF
;;;9/11	P_ACCEL		30,5
.tame_fire_wlp
	P_CHILDDEAD	1,.naitame
	P_PLAYERINCONE	4,.fire_tama

	P_DISTMORE	10000,.too_far_t
	P_FACEPLAYER
	P_IGOTO		.fe
.too_far_t
	P_FACEPLAYER	y
.fe
	P_GOTO		.tame_fire_wlp
.fire_tama
	P_IMPORT	pbyte1,KDifficulty
	P_IFSAME	pbyte1,dif_hard,.n_easy
	P_TRIGGER	roll_msg_tri,Timer,30
.n_easy
	P_REMOVE	1
	P_QSPAWN	etame,e_tamedama,10,8
;.mou_nai
	P_GOTO		.main_action
;;-----------
.atack
	P_IMPORT	pbyte1,KDifficulty
	P_RANDOMGOTO	.tame_atack
	P_IFNOTSAME	pbyte1,dif_hard,.futsuu_atack
	P_RANDOMGOTO	.hard_t
.futsuu_atack
	P_ACCEL		70,5
	P_WAITCHASE	rotz,0
.naitame
	P_WEAPON	ELaser
	P_RTRIGGER	.laser_fire,8
	P_TRIGGER	.change_turn,OFF
	P_TRIGGER	.change_updw,OFF
	P_RTRIGGER	.atack_ref_rot,64
.face_lp
	P_DISTMORE	10000,.too_far
	P_DISTLESS	3800,.at_act
	P_FACEPLAYER
	P_GOTO		.face_lp
.too_far
	P_FACEPLAYER	y
	P_CHASE		rotx,0
	P_GOTO		.face_lp
.at_act
	P_ACCEL		100,5
	P_SETVEL	100
	P_TRIGGER	.atack_ref_rot,OFF
	P_TRIGGER	.laser_fire,OFF
;.from_tama
	P_GOTO		.main_action
;;-----------
.atack_ref_rot
	P_IFNOTZERO	childy,.kaiten_cyu
	P_SET		childy,2
	P_GOSUB		.ref_trigger
.kaiten_cyu
	P_RETURN
.rotz_flat_5
	P_CHASE		rotz,0
	P_RETURN
;;-----------
.ref_rot
	P_IFNOTZERO	childy,.at_kaiten_cyu
	P_SET		childy,1
.ref_trigger
	P_SET		tx,16
	P_ZERO		ty
	P_TRIGGER	.l_ref_rot,Always,18
	P_TRIGGER	.l_ref_off,timer,19
.at_kaiten_cyu
	P_RETURN
.l_ref_off
	P_INVINCIBLE	OFF
	P_ZERO		childy
	P_TRIGGER	.rotz_flat_5,Always,5
;;;;;;	P_TRIGGER	.find_pl_tame,Always
	P_RETURN
.l_ref_rot
	P_INVINCIBLE	ON
	P_REBOUNDLASER
	P_ADD		rotz,tx
	P_INC		ty
	P_IFBETWEEN	-1,ty,14,.pass_sm
	P_ADD		tx,-4
.pass_sm
	P_RETURN
;-----------
.laser_fire
	P_DISTMORE	8000,.pass_f
	P_GOSUB		sos_fire_must
.pass_f
	P_RETURN

;;-------------
.find_pl_tame
	P_IMPORT	pbyte1,eftame
;	P_IMPORT	pbyte1,eaction2
	P_IFZERO	pbyte1,.no_pl_tame
	P_GSET		b,eftame,0
;	P_GSET		b,eaction2,0
	P_IMPORT	pbyte1,KDifficulty
	P_IFSAME	pbyte1,dif_easy,.easy_wolf
	P_IFSAME	pbyte1,dif_normal,.normal_wolf
	P_IFSAME	shape,wolf_eg,.ref_pl_tame
.seventy_five
	P_RANDOMGOTO	.ref_pl_tame
	P_RANDOMGOTO	.no_pl_tame
.ref_pl_tame
;;;;;;	P_TRIGGER	.find_pl_tame,OFF
	P_GOSUB		.ref_rot
.no_pl_tame
	P_RETURN

.easy_wolf
	P_IFNOTSAME	shape,wolf_eg,.no_pl_tame	;zaco = 0%
.twenty_five
	P_RANDOMGOTO	.no_pl_tame
.fifty_fifty
	P_RANDOMGOTO	.no_pl_tame
	P_IGOTO		.ref_pl_tame			;wolf = 25%
.normal_wolf
	P_IFSAME	shape,wolf_eg,.seventy_five
	P_IGOTO		.fifty_fifty
;;-----------
.gurari
	P_REMOVE	1
	P_SET		childz,1
	P_COLLISIONS	OFF
	P_IFLARGER	hp,slopenum,.pass_hit_msg
	P_IMPORT	slopenum,STARWOLFNO		;RannyuPilot
	P_GSET		b,ebyte1,60
	P_ADD		slopenum,178
	P_MSG		slopenum
	P_ZERO		slopenum
.pass_hit_msg
	P_SET		pbyte1,40
	P_IFLARGER	hp,pbyte1,.not_dead

	P_TRIGGER	all,OFF
	P_GSET		b,ebyte2,1
	P_REMOVE	1
	P_REMOVE	9
	P_REMOVE	10
	P_REMOVE	11
	P_FORCE		.dead
	P_RETURN
.not_dead
	P_TRIGGER	.guragura,Always,10
	P_TRIGGER	.collision_on,Timer,12
	P_ZERO		pbyte2
	P_ADD		worldy,600
	P_ADD		rotz,-10
	P_RETURN
.collision_on
	P_ZERO		childz
	P_COLLISIONS	ON
	P_RETURN
.guragura
	P_AUTOINDEX	b,rotz,gura_ang,pbyte2,10
	P_ADD		worldy,-60
	P_RETURN
;;-----------
.dead
	P_INVINCIBLE	ON

	P_IMPORT	pbyte1,KEnemyNumber
	P_EXPORT	emeteohit,pbyte1
	P_SET		hp,100

	P_QSPAWN	nullshape,e_exp_self,10,10
	P_EXPORT	gword1,shape
	P_BECOME
	P_IMPORT	shape,gword1
	P_UNBECOME

	P_SCREENFLASH
	P_CIRCLEWINDOW	5

	P_GSET		w,RannyuModeSwitch,-1
	P_TRIGGER	pause_ck,Always
	P_CLRDEMOSHAPE
	P_RTRIGGER	.noroshi,16
	P_ACCEL		40,5
	P_WAITCHASE	rotz,0
	P_ZERO		pbyte2
	P_TRIGGER	.wolf_run_go,Timer,55
	P_RTRIGGER	.gura_ang,Always
	P_IMPORT	pbyte1,STARWOLFNO	;RannyuPilot
	P_ADD		pbyte1,164		;wolf no dead message
	P_MSG		pbyte1
	P_GSET		b,ebyte1,60
.clp
	P_DISTMORE	8000,.far_dead
	P_DISTLESS	5000,.br
;;;	P_FACEPLAYEROFS	20,50,127
	P_FACEPLAYER
	P_GOTO		.clp
;;-----------
.noroshi
	P_QSPAWN	smoke,e_noroshi_smoke_nos,100,0
	P_BECOME
	P_ACTIVE	ON
	P_ADD		tx,32
	P_UNBECOME
	P_RETURN
.gura_ang
	P_IMPORT	pword1,Player1_worldy
	P_CHASE		worldy,pword1
	P_AUTOINDEX	b,rotz,gura_ang2,pbyte2,10
	P_RETURN
;;-----------
.far_dead
	P_FACEPLAYER	y
	P_CHASE		rotx,0
	P_GOTO		.clp
.br
	P_INPLAYERSCONE	-64,64,.exp
	P_GOTO		.clp
.exp
	P_ACCEL		10,1
	P_CIRCLEWINDOW	5
	P_DO		10
	P_ADD		roty,-2
	P_NEXT
.lp_end
	P_GOTO		.lp_end
.wolf_run_go
	P_IFNOTSAME	shape,wolf_eg,.not_wolf
	P_FORCE		.wolf_go
	P_RETURN
.not_wolf
	P_FORCE		.wolf_1_wxp
	P_RETURN
.wolf_1_wxp
	P_SCREENFLASH
	P_CIRCLEWINDOW	1,big

	P_DO		4
	P_QSPAWN	explosion6,e_sp_bigrandom_explosion,100,50
	P_BECOME
	P_ACTIVE	ON
	P_ADD		slopenum,6
	P_UNBECOME
	P_NEXT

	P_GSET		w,RannyuModeSwitch,-2
	P_GSET		b,WOLFSOUNDOFF,1
	P_TRIGGER	pause_ck,OFF
	P_GOSUB		fighter_count_wolf
	P_SCORE		sc_wolf_zaco
	P_GSET		b,bossmaxhp,0
	P_EXPLODE
.wolf_go
	P_RELTOPLAYER	ON
	P_ACCEL		0,1
	P_GSET		b,ebyte1,60
	P_MSG		168
	P_DO		32
	P_CHASE		rotz,16
	P_ADD		roty,4
	P_CHASE		rotx,0
	P_NEXT
	P_GOSUB		pe_star_wolf.mk_boost
	P_RELTOPLAYER	OFF
	P_ACCEL		100,20
	P_DO		10
	P_CHASE		rotz,0
	P_NEXT
	P_GSET		w,RannyuModeSwitch,-2
	P_GSET		b,WOLFSOUNDOFF,1
	P_TRIGGER	pause_ck,OFF
	P_GOSUB		fighter_count_wolf
	P_SCORE		sc_wolf
	P_WAIT		20
	P_GSET		b,bossmaxhp,0
	P_REMOVE
;;-------------
.first_msg
	P_IMPORT	pbyte1,STARWOLFNO		;RannyuPilot
	P_ADD		pbyte1,172
	P_MSG		pbyte1
	P_GSET		b,ebyte1,60
	P_GOSUB		.mk_boost
	P_COLLISIONS	ON
	P_RETURN
;;;;ษอออออออออออออออออป
;;;;บ FRIEND & PEPPER บ
;;;;ศอออออออออออออออออผ
;;;;------------
henkei_wait	equ	16
;;;
	START_PATH	e_auto_walker

	P_SET		hp,100
	P_INVISIBLE	ON
	P_IMPORT	pbyte1,KDifficulty
	P_IFNOTSAME	pbyte1,dif_easy,.rem
	P_WAIT		henkei_wait		;20
	P_FORCETRANSFORM	robot

	P_IMPORT	pword1,eword3
	P_SET		pbyte1,9
	P_IFSWITCH	pbyte1,pword1,.rem
	P_SETSWITCH	pbyte1,pword1
	P_EXPORT	eword3,pword1
	P_WAIT		30
	P_SET		pword1,204
	P_DO		5
	P_GSET		b,ebyte1,80
	P_IFNOTSAME	pword1,207,.notcon
	P_IMPORT	pbyte1,player_controltypeABXY
	P_IFZERO	pbyte1,.notcon
	P_MSG		213
	P_IGOTO		.af_sp
.notcon
	P_MSG		pword1
.af_sp
	P_INC		pword1
	P_WAIT		65
	P_NEXT
.rem
	P_REMOVE
;;;;------------
;;;	START_PATH	e_space_friend
;;;
;;;	p_settype	laser
;;;	p_settype	friend
;;;	p_clrtype	enemy1
;;;
;;;	P_IMPORT	pbyte1,Player_friend
;;;	P_IFSAME	pbyte1,-1,eg_remove
;;;	P_INVISIBLE	ON
;;;	P_ACTIVE	ON
;;;
;;;	P_GOSUB		wait_start_trigger
;;;
;;;	P_DO		15
;;;	P_IMPORT	worldx,Player1_worldx
;;;	P_IMPORT	worldy,Player1_worldy
;;;	P_IMPORT	worldz,Player1_worldz
;;;	P_NEXT
;;;
;;;	P_SET		pbyte1,5
;;;	P_GOSUB		ran_neg_pb1
;;;	P_ADD		worldx,100
;;;	P_RANDOMGOTO	.plu
;;;	P_ADD		worldy,-50
;;;	P_IGOTO		.work_pos
;;;.plu
;;;	P_ADD		worldy,50
;;;.work_pos
;;;	P_INPLAYERSCONE	-100,100,.to_work
;;;	P_IGOTO		.work
;;;.to_work
;;;	P_CIRCLEPLAYER	pbyte1		;5
;;;	P_IGOTO		.work_pos
;;;.work
;;;	P_GOSUB		set_friend_shape
;;;
;;;	P_INVISIBLE	OFF
;;;	P_COLLISIONS	OFF
;;;	P_ALWAYSGENVECS	ON
;;;	P_RADAROBJ	ra_player
;;;
;;;;	P_SOUND		p2_demo_arwing	;01
;;;	P_ZERO		pbyte2
;;;	P_TRIGGER	.friend_fire,Always	;ap
;;;	P_TRIGGER	.num_ck,Always		;hp
;;;
;;;	P_QUADVECS	ON
;;;	P_COPYPLAYERROTS
;;;	P_SETVEL	12
;;;	P_IGOTO		.enter_start
;;;;------------
;;;.re_start
;;;	P_TRIGGER	.chase_option_ck,Always
;;;.main_loop
;;;	P_SETVEL	10
;;;	P_SPACESHIP	ON
;;;	P_SET		rotz,8
;;;	P_GOSUB		.find_miss
;;;	P_IFZERO	skidy,.flp
;;;.olp
;;;	P_SHAPEDEAD	.flp
;;;	P_OBJINCONE	5,.tclp
;;;	P_GOTO		.olp
;;;.flp
;;;	P_PLAYERINCONE	5,.tclp
;;;	P_GOTO		.flp
;;;.tclp
;;;	P_ZERO		rotz
;;;	P_SPACESHIP	OFF
;;;.clp
;;;	P_IFZERO	skidy,.plne
;;;	P_SHAPEDEAD	.tlp
;;;	P_SET		vel,slopenum
;;;	P_SHAPEDISTLESS	7000,.fac
;;;	P_SHAPEDISTMORE	12000,.plne
;;;	P_MOVEINSHAPE	80
;;;.fac
;;;	P_FACESHAPE
;;;	P_SHAPEDISTLESS	500,.tlp
;;;	P_GOTO		.clp
;;;.plne
;;;	P_DISTLESS	500,.tlp
;;;	P_FACEPLAYER			;OFS	0,0,30
;;;	P_GOTO		.clp
;;;.tlp
;;;	P_GOTO		.main_loop
;;;;------------
;;;.find_miss
;;;	P_IMPORT	skidy,KGameMapPtr
;;;	P_IFNOTSAME	skidy,7,.find_enemy
;;;	P_SET		skidy,1
;;;	P_SET		slopenum,20
;;;	P_FINDSHAPE	dandou
;;;	P_SHAPEDEAD	.bara
;;;	P_RETURN
;;;.bara
;;;	P_INC		skidy
;;;	P_FINDSHAPE	miss2_0
;;;	P_SHAPEDEAD	.enb
;;;	P_RETURN
;;;.enb
;;;	P_INC		skidy
;;;	P_FINDSHAPE	enban_1
;;;	P_SHAPEDEAD	.tate
;;;	P_RETURN
;;;.tate
;;;	P_INC		skidy
;;;	P_FINDSHAPE	tate_m_0
;;;	P_SHAPEDEAD	.nashi
;;;	P_RETURN
;;;.nashi
;;;	P_SET		slopenum,10
;;;	P_ZERO		skidy
;;;	P_RETURN
;;;
;;;.find_enemy
;;;	P_SET		slopenum,10
;;;	P_SET		skidy,1
;;;	P_FINDSHAPE	taigun
;;;	P_SHAPEDEAD	.sos_0
;;;	P_RETURN
;;;.sos_0
;;;	P_INC		skidy
;;;	P_FINDSHAPE	sos_0
;;;	P_SHAPEDEAD	.speed_s
;;;	P_RETURN
;;;.speed_s
;;;	P_INC		skidy
;;;	P_FINDSHAPE	speed_s
;;;	P_SHAPEDEAD	.sos_1
;;;	P_RETURN
;;;.sos_1
;;;	P_INC		skidy
;;;	P_FINDSHAPE	sos_1
;;;	P_SHAPEDEAD	.enkin
;;;	P_RETURN
;;;.enkin
;;;	P_INC		skidy
;;;	P_FINDSHAPE	enkin
;;;	P_SHAPEDEAD	.jyouge
;;;	P_RETURN
;;;.jyouge
;;;	P_INC		skidy
;;;	P_FINDSHAPE	jyouge
;;;	P_SHAPEDEAD	.sos_2
;;;	P_RETURN
;;;.sos_2
;;;	P_INC		skidy
;;;	P_FINDSHAPE	sos_2
;;;	P_SHAPEDEAD	.jyouge_1
;;;	P_RETURN
;;;.jyouge_1
;;;	P_INC		skidy
;;;	P_FINDSHAPE	jyouge_1
;;;	P_SHAPEDEAD	.ninja
;;;	P_RETURN
;;;.ninja
;;;	P_INC		skidy
;;;	P_FINDSHAPE	ninja
;;;	P_SHAPEDEAD	.hydra
;;;	P_RETURN
;;;.hydra
;;;	P_INC		skidy
;;;	P_FINDSHAPE	stepup_0
;;;	P_SHAPEDEAD	.nashi
;;;	P_RETURN
;;;;------------
;;;.chase_option_ck
;;;	P_IFUFO		.pl_ufo
;;;	P_WITHINRADIUS	600,.option_go_on
;;;.pl_ufo
;;;	P_DISTMORE	10000,.chase_go_on
;;;	P_RETURN
;;;.option_go_on
;;;	P_FORCE		.option_on
;;;	P_RETURN
;;;.chase_go_on
;;;	P_FORCE		.chase_player
;;;	P_RETURN
;;;;-----------
;;;.chase_player
;;;	P_TRIGGER	.chase_option_ck,OFF
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SETVEL	60
;;;.cont_chase
;;;	P_ZERO		rotx
;;;	P_ZERO		worldy
;;;	P_FACEPLAYER	y
;;;	P_DISTLESS	500,.go_restart
;;;	P_GOTO		.cont_chase
;;;.go_restart
;;;	P_WAIT		20
;;;	P_GOTO		.re_start
;;;;-----------
;;;.option_on
;;;	P_TRIGGER	.chase_option_ck,OFF
;;;	P_SETVEL	0
;;;
;;;	P_QSPAWN	marker,e_friend_marker,100,0
;;;	P_FINDSHAPE	marker
;;;
;;;	P_BECOME
;;;	P_IMPORT	pbyte1,Player_friend
;;;	P_DIV2		pbyte1
;;;	P_IFZERO	pbyte1,.ar1
;;;	P_IFSAME	pbyte1,1,.ar2
;;;
;;;	P_FINDSHAPE	b_wing
;;;	P_IGOTO		.shape_found
;;;.ar2
;;;	P_FINDSHAPE	c_wing
;;;	P_IGOTO		.shape_found
;;;.ar1
;;;	P_FINDSHAPE	a_wing
;;;.shape_found
;;;	P_COPYPLAYERPOS
;;;	P_UNBECOME
;;;.come
;;;	P_PUSH		rotx
;;;	P_PUSH		roty
;;;	P_PUSH		rotz
;;;	P_COPYPLAYERROTS
;;;	P_SET		childrotx,rotx
;;;	P_SET		childroty,roty
;;;	P_SET		childrotz,rotz
;;;	P_PULL		rotz
;;;	P_PULL		roty
;;;	P_PULL		rotx
;;;	P_CHASE		rotx,childrotx
;;;	P_CHASE		roty,childroty
;;;	P_CHASE		rotz,childrotz
;;;	P_MOVEINSHAPE	30
;;;	P_SHAPEINRADIUS	30,.come_end
;;;	P_GOTO		.come
;;;.come_end
;;;	P_SET		ox,worldx
;;;	P_SET		oy,worldy
;;;	P_SET		oz,worldz
;;;	P_SET		mx,worldx
;;;	P_SET		my,worldy
;;;	P_SET		mz,worldz
;;;	P_SET		tx,rotx
;;;	P_SET		ty,roty
;;;	P_SET		slopenum,rotz
;;;	P_SET		pbyte2,rotx
;;;	P_SET		skidy,roty
;;;	P_SET		weapontype,rotz
;;;
;;;	P_IMPORT	pword1,Player1_worldx
;;;	P_NEG		pword1
;;;	P_ADD		pword1,worldx
;;;	P_EXPORT	efriendofsx,pword1
;;;	P_IMPORT	pword1,Player1_worldy
;;;	P_NEG		pword1
;;;	P_ADD		pword1,worldy
;;;	P_EXPORT	efriendofsy,pword1
;;;	P_IMPORT	pword1,Player1_worldz
;;;	P_NEG		pword1
;;;	P_ADD		pword1,worldz
;;;	P_EXPORT	efriendofsz,pword1
;;;
;;;	P_FLAGSHAPE
;;;	P_ZERO		pbyte1
;;;	P_SET		pword1,1
;;;	P_REMOVE	9
;;;	P_TRIGGER	.boost_ck,Always
;;;
;;;	P_DO		150
;;;	P_GOSUB		.dilay_player
;;;	P_IFUFO		.pl_ufo_br
;;;	P_NEXT
;;;.op_en
;;;	P_TRIGGER	.boost_ck,OFF
;;;	P_REMOVE	9
;;;	P_SETVEL	22
;;;.enter_start
;;;	P_GOSUB		.must_boost
;;;
;;;	P_ZERO		pword1
;;;
;;;	P_WAITCHASE	rotz,0
;;;	P_WAITCHASE	rotx,0
;;;.farlp
;;;	P_DISTMORE	1500,.to_re_start
;;;	P_GOTO		.farlp
;;;.to_re_start
;;;	P_REMOVE	9
;;;	P_GOTO		.re_start
;;;.boost_ck
;;;	P_IFPLAYERBOOST	.now_boost
;;;	P_SET		pword1,1
;;;	P_REMOVE	9
;;;	P_RETURN
;;;.now_boost
;;;	P_IFSAME	pword1,11,.ret
;;;.must_boost
;;;	P_SET		pword1,11
;;;	P_TRIGGER	.boost_on,Timer,5
;;;.ret
;;;	P_RETURN
;;;.boost_on
;;;	P_SOUNDEFTDISTPOS	partner_boost	;$46
;;;	P_SPAWN		0,0,-20,0,0,0,boost,e_friend_boost,100,0,9
;;;	P_RETURN
;;;;------------
;;;.pl_ufo_br
;;;	P_BREAK		.op_en
;;;;------------
;;;.dilay_player
;;;	P_COPYPLAYERPOS
;;;	P_COPYPLAYERROTS
;;;
;;;	P_GADD		worldx,efriendofsx
;;;	P_GADD		worldy,efriendofsy
;;;	P_GADD		worldz,efriendofsz
;;;
;;;	P_IFZERO	pbyte1,.memo0
;;;	P_IFSAME	pbyte1,1,.memo1
;;;;.memo2
;;;	P_SET		ox,worldx
;;;	P_SET		oy,worldy
;;;	P_SET		oz,worldz
;;;	P_SET		pbyte2,rotx
;;;	P_SET		skidy,roty
;;;	P_SET		weapontype,rotz
;;;	P_SET		worldx,childx
;;;	P_SET		worldy,childy
;;;	P_SET		worldz,childz
;;;	P_SET		rotx,childrotx
;;;	P_SET		roty,childroty
;;;	P_SET		rotz,childrotz
;;;	P_ZERO		pbyte1
;;;	P_RETURN
;;;.memo1
;;;	P_SET		mx,worldx
;;;	P_SET		my,worldy
;;;	P_SET		mz,worldz
;;;	P_SET		tx,rotx
;;;	P_SET		ty,roty
;;;	P_SET		slopenum,rotz
;;;	P_SET		worldx,ox
;;;	P_SET		worldy,oy
;;;	P_SET		worldz,oz
;;;	P_SET		rotx,pbyte2
;;;	P_SET		roty,skidy
;;;	P_SET		rotz,weapontype
;;;	P_INC		pbyte1
;;;	P_RETURN
;;;.memo0
;;;	P_SET		childx,worldx
;;;	P_SET		childy,worldy
;;;	P_SET		childz,worldz
;;;	P_SET		childrotx,rotx
;;;	P_SET		childroty,roty
;;;	P_SET		childrotz,rotz
;;;	P_SET		worldx,mx
;;;	P_SET		worldy,my
;;;	P_SET		worldz,mz
;;;	P_SET		rotx,tx
;;;	P_SET		roty,ty
;;;	P_SET		rotz,slopenum
;;;	P_INC		pbyte1
;;;	P_RETURN
;;;;----------
;;;.friend_fire
;;;	P_INC		ap
;;;	P_IFSAME	ap,32,.fir
;;;	P_IFNOTSAME	ap,34,.no_fir
;;;	P_ZERO		ap
;;;.fir
;;;	P_IFNOTZERO	pword1,.plbeam
;;;	P_QSPAWN	beam_0s,e_f_beam,100,1
;;;	P_IGOTO		.no_fir
;;;.plbeam
;;;	P_QSPAWN	beam_0,plaser,100,1
;;;	P_BECOME
;;;	P_INC		skidy
;;;	P_UNBECOME
;;;	P_BECOME
;;;	P_COLLISIONS	OFF
;;;	P_UNBECOME
;;;.no_fir
;;;	P_RETURN
;;;;----------
;;;.num_ck
;;;	P_IMPORT	hp,KEnemyNumber
;;;	P_IFNOTZERO	hp,.cont
;;;	P_FORCE		.demo
;;;.cont
;;;	P_SET		hp,100
;;;	P_RETURN
;;;.demo
;;;	P_TRIGGER	.num_ck,OFF
;;;	P_TRIGGER	.friend_fire,OFF
;;;.demo_fly
;;;	P_COPYPLAYERROTS
;;;	P_MOVEINPLAYER	60
;;;	P_WITHINRADIUS	100,.end
;;;	P_GOTO		.demo_fly
;;;.end
;;;	P_END
;;;;---------------
;;;	START_PATH	e_f_beam
;;;
;;;	p_settype	laser
;;;;	p_settype	friend
;;;	p_clrtype	enemy1
;;;	P_QUADVECS	ON
;;;	P_COLLISIONS	OFF
;;;	P_TRIGGER	.hit,WhenHit
;;;	P_SETANIM	0
;;;	P_SOUNDEFTDISTPOS	partner_laser	;$5c
;;;	P_SETVEL	60
;;;
;;;	P_WAIT		15
;;;.rem
;;;	P_REMOVE
;;;.hit
;;;	P_FORCE		.rem
;;;	P_TRIGGER	.hit,OFF
;;;	P_RETURN
;---------------
	START_PATH	e_checker_planet
	P_IGOTO		pe_checker_space.enter
;-----------
	START_PATH	e_checker_space

	P_TRIGGER	.ck_start,Timer,120
	P_RTRIGGER	.rannyu_ck,Always
	P_RTRIGGER	.checker_pos,Always
.enter	LOCAL
	P_CLRTYPE	enemy1
	P_INVISIBLE	ON
	P_ACTIVE	ON
.lp
	P_IMPORT	slopenum,ebyte1
	P_IFZERO	slopenum,.ok_msg
	P_GDEC		b,ebyte1
.ok_msg
	P_GOTO		.lp
.ck_start
	P_TRIGGER	inseki_ck,Always
	P_RETURN
.rannyu_ck
	P_IMPORT	pword1,RannyuModeSwitch
	P_IFSAME	pword1,1,.ari
.nashi
	P_RETURN
.ari
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFZERO	pbyte1,.oosugi
	P_SET		pbyte2,2
	P_IFLARGER	pbyte1,pbyte2,.oosugi
	P_GSET		w,RannyuModeSwitch,0
	P_GINC		b,KEnemyNumber
	P_RADAROBJ	ra_enemy
	P_TRIGGER	.e_radar_off,Timer,100
	P_FORCE		.wolf
.oosugi
	P_RETURN
.wolf
	P_TRIGGER	.rannyu_ck,OFF
	P_IFNOTSAME	pbyte1,2,.sugu
	P_WAIT		10
.sugu
	P_QSPAWN	nullshape,STARWOLFdirector,10,10
	P_TRIGGER	.mk_wolf,Timer,60
	P_IGOTO		.lp
.mk_wolf
	P_QSPAWN	nullshape,e_star_wolf,100,10
	P_IMPORT	pbyte1,STARWOLFNO	;RannyuPilot
	P_IFZERO	pbyte1,.wolfshape
	P_BECOME
	P_SET		shape,wolf_1_eg
	P_UNBECOME
	P_RETURN
.e_radar_off
	P_RADAROBJ	ra_off
	P_RETURN
.wolfshape
	P_BECOME
	P_SET		shape,wolf_eg
	P_UNBECOME
	P_RETURN
.checker_pos
	P_COPYPLAYERPOS
	P_ADD		worldy,1500
	P_RETURN
;-----------
	START_PATH	e_game_maker_space

	P_INVISIBLE	ON	
	P_CLRTYPE	enemy1

	P_TRIGGER	pe_game_maker_planet.map_msg,Always
	P_RTRIGGER	.pos_keep,8

	P_IMPORT	ty,Player_friend
	P_IFSAME	ty,-1,.pertner_nashi	;partner ga inai

	P_IMPORT	oy,eword2
	P_IFZERO	oy,.not_any_hajimete
	P_ADD		oy,ty
	P_MSG		oy
;;;	P_SET		skidy,60
	P_ZERO		oy
	P_EXPORT	eword2,oy
.not_any_hajimete
	P_WAIT		15
	P_IMPORT	oy,eword3

	P_IMPORT	tx,KDifficulty
	P_IFSAME	tx,dif_hard,.pertner_nashi

	P_IMPORT	weapontype,playerctlmode
	P_IFSAME	weapontype,map_room,.in_room_trg
	P_SET		tx,5				;hajimete boost flag
	P_IFSWITCH	tx,oy,.pertner_nashi		;boost shitakoto aru
	P_WAIT		60
	P_RTRIGGER	.teach_boost,128
	P_RTRIGGER	.boost_ck,Always
.pertner_nashi
	P_END
;-----------
.pos_keep
	P_COPYPLAYERPOS
	P_ADD		worldy,1000
	P_RETURN
;-----------
.in_room_trg
	P_SET		tx,16
	P_IFSWITCH	tx,oy,.pertner_nashi
	P_WAIT		20
	P_IMPORT	weapontype,KGameMapPtr
	P_IFNOTSAME	weapontype,8,.ok
	P_SET		weapontype,1
.ok
	P_TRIGGER	teach_henkei,128
	P_RTRIGGER	.henkei_ck,Always
	P_END

.henkei_ck
	P_IFSAME	weapontype,-1,.cut
	P_IMPORT	oy,eword3
	P_IFNOTSAME	weapontype,1,.now_robo
	P_IFARWING	.arwing
.natta
	P_SET		tx,16
	P_IMPORT	oy,eword3
	P_SETSWITCH	tx,oy
	P_EXPORT	eword3,oy
.cut
	P_FORCE		.henkeishita
.arwing
	P_RETURN
.now_robo
	P_IFROBOT	.arwing
	P_IGOTO		.natta

.henkeishita
	P_TRIGGER	teach_henkei,OFF
	P_TRIGGER	.henkei_ck,OFF
	P_END

.teach_boost
	P_IFNOTZERO	pword1,.ret
	P_IFNOTZERO	skidy,.ret
	P_IFNOTZERO	childrotx,.ret
	P_IMPORT	ap,ebyte1
	P_IFNOTZERO	ap,.rret
	P_IMPORT	ap,KEnemyNumber
	P_IFZERO	ap,.rret
	P_SET		pword1,teach_boost_msg_num	;use boost msg num
	P_IMPORT	ap,player_controltypeABXY
	P_IFZERO	ap,.norm_ABXY
	P_ADD		pword1,96
.norm_ABXY
	P_ADD		pword1,ty
	P_IFROBOT	.pass_msg
	P_IFUFO		.pass_msg
	P_MSG		pword1
.pass_msg
	P_ZERO		pword1
	P_SET		childrotx,3
.ret
	P_DEC		childrotx
.rret
	P_RETURN

.boost_ck
	P_IFPLAYERBOOST	.now_boost
	P_ZERO		pword1
	P_RETURN
.now_boost
	P_INC		pword1
	P_IFSAME	pword1,40,.ok_boost
	P_RETURN
.ok_boost
	P_SET		tx,5
	P_IMPORT	oy,eword3
	P_SETSWITCH	tx,oy
	P_EXPORT	eword3,oy
	P_FORCE		.boostshita
	P_RETURN

.boostshita
	P_TRIGGER	.teach_boost,OFF
	P_TRIGGER	.boost_ck,OFF
	P_END

;;;;------------
henkei_ck_wait	equ	30
	START_PATH	e_game_maker_planet

;;;	P_TRIGGER	enemy_num_rem,Always	;KEnemyNumber ga 0 ninattara removesuru

	P_INVISIBLE	ON	
	P_IMPORT	tx,KGameMapPtr
	P_IMPORT	ty,Player_friend
	P_CLRTYPE	enemy1
	P_SET		pbyte2,5		;ebyte6 no bit5 shitei
	P_SET		ox,worldx
	P_SET		childx,worldx
	P_NEG		childx
	P_SET		oz,worldz
	P_SET		childz,worldz
	P_NEG		childz

	P_RTRIGGER	.map_msg,Always		;map no jyoukyou wo message suru

	P_WAIT		henkei_wait+henkei_ck_wait

	P_IFNOTSAME	ty,-1,.pertner_ari	;partner ga inai
	P_END
.pertner_ari
	P_IMPORT	oy,eword2
	P_IFZERO	oy,.not_any_hajimete
	P_ADD		oy,ty
	P_MSG		oy
;;;	P_SET		skidy,60
	P_ZERO		oy
	P_EXPORT	eword2,oy
.not_any_hajimete
	P_IMPORT	oy,eword3

	P_IMPORT	tx,KDifficulty
	P_IFSAME	tx,dif_hard,.start

	P_SET		tx,16				;hajimete henkei flag
	P_IFSWITCH	tx,oy,.start
	P_TRIGGER	teach_henkei,128
	P_RTRIGGER	.henkei_ck,Always
.start
	P_RTRIGGER	.pl_pos_ck,16
	P_END

.henkei_ck
	P_IFSAME	weapontype,-1,.cut
	P_IMPORT	oy,eword3
	P_IFROBOT	.arwing
	P_SET		tx,16
	P_IMPORT	oy,eword3
	P_SETSWITCH	tx,oy
	P_EXPORT	eword3,oy
.cut
	P_FORCE		.henkeishita
.arwing
	P_RETURN

.henkeishita
	P_TRIGGER	teach_henkei,OFF
	P_TRIGGER	.henkei_ck,OFF
	P_END
;;;;------------
.map_msg	LOCAL
	P_IFNOTZERO	skidy,.no_act
	P_IMPORT	slopenum,KEnemyNumber
	P_IFZERO	slopenum,.no_act1
	P_IMPORT	slopenum,Pepper_message
	P_IFZERO	slopenum,.no_act1

	P_MSG		slopenum

	P_IFSAME	ty,-1,.not_line			;partner ga inai
	P_IMPORT	skidy,KX_NEARPLANETNUM
	P_IFSAME	skidy,8,.not_line		;already_near_planet

	P_IFSAME	slopenum,pinchi1_msg_num,.map_line_fin
	P_IFSAME	slopenum,pinchi2_msg_num,.map_line_fin
.not_line
	P_SET		skidy,60			;wait time
	P_EXPORT	ebyte1,skidy
.no_act
	P_DEC		skidy
	P_IFNOTZERO	skidy,.no_act1
	P_EXPORT	Pepper_message,skidy
.no_act1
	P_RETURN

.map_line_fin
	P_EXPORT	gbyte1,slopenum
	P_QSPAWN	nullshape,e_line_msg,100,0
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_UNBECOME
	P_SET		skidy,120
	P_IGOTO		.no_act
;;;;------------
.pl_pos_ck
	P_COPYPLAYERPOS
	P_IFLARGER	worldx,ox,.out
	P_IFSMALLER	worldx,childx,.out
	P_IFLARGER	worldz,oz,.out
	P_IFSMALLER	worldz,childz,.out
	P_ZERO		pword1
	P_RETURN
.out
	P_INC		pword1
	P_IFNOTSAME	pword1,10,.mada
	P_FORCE		.game_make
.mada
	P_RETURN
.game_make
	P_TRIGGER	.pl_pos_ck,OFF
	P_ZERO		pword1
	P_IMPORT	pbyte1,ebyte6
	P_SETSWITCH	pbyte2,pbyte1
	P_EXPORT	ebyte6,pbyte1
;	P_QSPAWN	zaco_0,e_friend_modore,100,5
	P_QSPAWN	zaco_2,e_friend_modore,100,5
	P_EXPORT	gword1,ox
	P_EXPORT	gword2,oz
	P_BECOME
	P_IMPORT	ox,gword1
	P_IMPORT	oz,gword2
	P_UNBECOME
.wait_loop
	P_COPYPLAYERPOS
	P_IMPORT	pbyte1,ebyte6
	P_IFSWITCH	pbyte2,pbyte1,.more_w
	P_IGOTO		.start
.more_w
	P_GOTO		.wait_loop
;;;;-----------
	START_PATH	e_line_msg

;;;	P_TRIGGER	enemy_num_rem,Always
	P_IMPORT	slopenum,KX_NEARPLANETNUM
	P_IFSAME	slopenum,8,.rem

	P_INVISIBLE	ON
	P_IMPORT	pbyte2,Player_friend
	P_WAIT		60

	P_IFSAME	pbyte1,pinchi1_msg_num,.notfinal
	P_SET		tx,6
.notfinal
	P_ADD		tx,corneria_he_ike_msg
	P_ADD		tx,pbyte2
	P_MSG		tx
.rem
	P_REMOVE

;;;;-----------
	START_PATH	e_friend_modore

	P_COLLISIONS	OFF
	P_ALWAYSGENVECS	ON
	P_CLRTYPE	enemy1
	P_ZERO		worldx
	P_ZERO		worldz
	P_RADAROBJ	ra_player
	P_SOUND		p2_demo_arwing
	P_GOSUB		set_friend_shape

	P_IMPORT	pbyte2,KGameMapPtr
	P_IFNOTSAME	pbyte2,5,.not_sea0
	P_RTRIGGER	.keep_sea_hi,Always
	P_GOSUB		sea_init_above
.sea_come_here
	P_GOSUB		.come_sub
	P_IMPORT	worldy,Player1_worldy
	P_DISTLESS	3000,.sea_mid
	P_SET		worldy,-1200
	P_GOTO		.sea_come_here
.sea_mid
	P_FACEPLAYER	y
	P_IMPORT	worldy,Player1_worldy
	P_MOVEINPLAYER	100
	P_DISTLESS	500,.sea_near
	P_SET		worldy,-1200
	P_GOTO		.sea_mid
.sea_near
	P_SET		worldy,-1200
	P_RELTOPLAYER	ON
	P_SETVEL	50
	P_WAIT		3
	P_IGOTO		.in_air
;-----------
.come_sub
	P_IMPORT	childx,Player1_worldx
	P_IMPORT	childz,Player1_worldz
	P_CHASE		worldx,childx
	P_CHASE		worldz,childz
	P_RETURN
;;;;-----------
.not_sea0
	P_RTRIGGER	.keep_hi,Always
.come_here
	P_GOSUB		.come_sub
	P_DISTLESS	3000,.mid
	P_GOTO		.come_here
;------------
.keep_hi
	P_SET		worldy,-200
	P_RETURN
.keep_sea_hi
	P_SET		worldy,-1200
	P_RETURN
;------------
.mid
	P_FACEPLAYER	y
	P_MOVEINPLAYER	100
	P_DISTLESS	500,.near
	P_GOTO		.mid
.near
	P_RELTOPLAYER	ON
	P_SETVEL	50
	P_WAIT		3
	P_IFARWING	.in_air
;;-------- WHEN ROBOT
	P_SOUND		port2_stop
	P_WAIT		4
	P_ACCEL		0,5
	P_TRIGGER	.keep_hi,OFF
	P_SOUNDEFFECT	transArwing2Robo	;$1c
	P_INDEX		shape,friend_w1,pbyte1
	P_SETANIM	5
	P_WAIT		1
	P_DO		4
	P_ADDANIM	-1,6
	P_NEXT
	P_WAIT		1
	P_INDEX		shape,friend_w2,pbyte1
	P_SETANIM	6
	P_WAIT		1
	P_DO		5
	P_ADDANIM	-1,7
	P_NEXT
	P_SOUNDEFFECT	transArwing2RoboEnd	;$1e
	P_SET		pbyte2,10
.down_again
	P_ADD		worldy,pbyte2
	P_HITGROUND	35,.on_g
	P_ADD		pbyte2,5
	P_GOTO		.down_again
.on_g
	P_SET		worldy,-35
	P_SHOCKCAM	1,64
	P_SOUNDEFFECT	Roboland_s	;$2d

	P_RELTOPLAYER	OFF

	P_SET		pbyte2,25

	P_DO		2
	P_EXPORT	gbyte1,pbyte2
	P_QSPAWN	smoke,e_smoke_simple,100,0
	P_BECOME
	P_SPRITE	0,4
	P_IMPORT	pbyte1,gbyte1
	P_ADD		worldx,pbyte1
	P_ZERO		worldy
	P_UNBECOME
	P_NEG		pbyte2
	P_INEXT

	P_IMPORT	pbyte2,ebyte1
	P_IFNOTZERO	pbyte2,.skip_msg
	P_GSET		b,ebyte1,60
	P_SET		pbyte2,tx
	P_ADD		pbyte2,modore_msg

	P_GOSUB		.modore_msg_ck
.skip_msg
	
	P_WAIT		30

	P_SET		pbyte2,-5
	P_RTRIGGER	.up,Always

	P_SOUNDEFFECT	transRobo2Arwing	;$1d
	P_DO		5
	P_ADDANIM	1,7
	P_NEXT
	P_WAIT		1
	P_TRIGGER	.up,OFF

	P_ACCEL		40,2

	P_INDEX		shape,friend_w1,pbyte1
	P_SETANIM	1
	P_WAIT		1

	P_DO		4
	P_ADDANIM	1,6
	P_NEXT
	P_WAIT		1
	P_INDEX		shape,friend_shape,pbyte1
	P_SOUNDEFFECT	transRobo2ArwingEnd	;$1f
	P_SOUND		p2_demo_arwing
	P_RELTOPLAYER	ON
	P_IGOTO		.from_robo
;------------
.up
	P_ADD		worldy,pbyte2
	P_ADD		pbyte2,-5
	P_RETURN
;------------
.in_air
	P_IMPORT	pbyte2,ebyte1
	P_IFNOTZERO	pbyte2,.skip_msg2
	P_GSET		b,ebyte1,60
	P_SET		pbyte2,tx
	P_ADD		pbyte2,modore_msg

	P_GOSUB		.modore_msg_ck
.skip_msg2
	P_ACCEL		10,5
	P_WAIT		40
.from_robo
	P_ACCEL		20,1
	P_SPACESHIP	ON
	P_ZERO		rotx
	P_DO		8
	P_ADD		rotz,2
	P_NEXT
	P_WAIT		24
	P_DO		8
	P_ADD		rotz,-2
	P_NEXT
	P_SPACESHIP	OFF
	P_RELTOPLAYER	OFF
	P_SETVEL	0
	P_SET		childx,ox
	P_NEG		childx
	P_SET		childz,oz
	P_NEG		childz

	P_ZERO		pbyte1
.back
	P_QSPAWN	marker,e_marker_target,100,0
	P_FINDSHAPE	marker
	P_BECOME
	P_CHASE		worldx,0
	P_CHASE		worldz,0
	P_UNBECOME
	P_BEHINDPLAYER	.fast
.slow
	P_IFNOTZERO	pbyte1,.fast1
	P_MOVEINSHAPE	40
	P_IGOTO		.same
.fast
	P_IFNOTZERO	pbyte1,.fast1
	P_SPAWN		0,0,-30,0,0,0,boost,e_sp_boost_hp,4,0,1
	P_SOUNDEFTDISTPOS	partner_boost	;$46
	P_SET		pbyte1,15
.fast1
	P_DEC		pbyte1
	P_MOVEINSHAPE	45
.same
	P_FACESHAPE
	P_ZERO		rotx
	P_IFLARGER	worldx,ox,.more
	P_IFLARGER	worldz,oz,.more
	P_IFSMALLER	worldx,childx,.more
	P_IFSMALLER	worldz,childz,.more
	P_IGOTO		.bye
.more
	P_GOTO		.back

;-----------
.modore_msg_ck
	P_PUSH		worldx
	P_PUSH		worldz
	P_IMPORT	worldx,Player1_worldx
	P_IMPORT	worldz,Player1_worldz
	P_IFNOTBETWEEN	-7000,worldx,7000,.plmodore_msg2
	P_IFNOTBETWEEN	-7000,worldz,7000,.plmodore_msg2
	P_IGOTO		.plskip_msg2
.plmodore_msg2
	P_MSG		pbyte2
.plskip_msg2
	P_PULL		worldz
	P_PULL		worldx
	P_RETURN
;-----------
.bye
	P_REMOVE	1
	P_SPAWN		0,0,-30,0,0,0,boost,e_sp_boost,4,0,1
	P_SETVEL	50
	P_FLAGSHAPE
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,5,.not_sea22
	P_TRIGGER	.keep_sea_hi,OFF
	P_IGOTO		.same_sea2
.not_sea22
	P_TRIGGER	.keep_hi,OFF
.same_sea2
	P_WAITCHASE	rotx,-16
	P_WAIT		50
	P_IMPORT	pbyte1,ebyte6
	P_CLRSWITCH	ap,pbyte1
	P_EXPORT	ebyte6,pbyte1
	P_REMOVE

;;;;------------
	START_PATH	e_marker_target

	P_INVISIBLE	ON
	P_REMOVE
;;;;ษออออออป
;;;;บ DOOR บ
;;;;ศออออออผ
	START_PATH	e_door_hou_door_final

	P_INC		pbyte2

	START_PATH	e_door_hou_door

	P_PASSSOUND	ON
	P_SET		skidy,worldy
	P_ZERO		worldy
	P_ADD		roty,128
	P_IFSWITCH	skidy,.already_dead
	P_GOSUB		init_hardslope_soff
	P_SETANIM	11
	P_SPAWN		0,-15<<kabe_aku_scale,-10<<kabe_aku_scale,0,128,0,to_hou,e_door_hou,30,4,1
.lp
	P_CHILDDEAD	1,.open
	P_GOTO		.lp
.open
	P_GOSUB		fire_cansel
	P_SETSWITCH	skidy
	P_SETANIM	0
	P_WAIT		15
;;;
	P_ADD		worldy,-120
	P_GOSUB		make_demo_target
	P_ADD		worldy,120
	P_BECOME
	P_SET		slopenum,de_for_door_kotei_pos_s
	P_SET		pword1,-120
	P_SET		tx,17
	P_UNBECOME
	P_ACTIVE	ON
	P_GOSUB		demo_move_wait
;;;
	P_IFNOTZERO	pbyte2,.final
;;;	P_SOUNDEFFECT	door_open_chime	;$41
	P_GOSUB		open_door
.already_dead
	P_STAMPSTART
	P_SETANIM	11
	P_GOSUB		init_hardslope_soff
	P_SLOPE		OFF
	P_SET		shape,kabe_akufinal
	P_END
.final
	P_GOSUB		open_door
	P_SET		pbyte2,254
	P_EXPORT	ebyte2,pbyte2
	P_IGOTO		.already_dead
;----------
	START_PATH	e_door_hou

;	P_CLRTYPE	enemy1
	P_GOSUB		hit_dead_init
	P_RTRIGGER	.hit_dead,WhenDead
	P_RADAROBJ	ra_enemy
	P_SET		hp,40
.lp
	P_RTRIGGER	.atack,64
	P_TRIGGER	reflect_laser,Always
	P_INVINCIBLE	ON
	P_SETANIM	0
	P_END
.hit_dead
	P_SCORE		sc_hit_dead
	P_SET		shape,to_hou_s
	P_RETURN
.atack
	P_DISTMORE	2000,.pass_at
	P_FORCE		.on
.pass_at
	P_RETURN
.on
	P_TRIGGER	.atack,OFF
	P_TRIGGER	reflect_laser,OFF
	P_RTRIGGER	.able_ck,Always
	P_INVINCIBLE	OFF
	P_SOUNDEFTPOS	ob_opendoor_s	;$ab
	P_SLOPE		OFF
	P_DO		11
	P_ADDANIM	1,12
	P_NEXT

	P_WAIT		1
	P_SETANIM	9
	P_WAIT		1
	P_SETANIM	11

	P_RTRIGGER	.sos_fire,16
	P_WAIT		45
	P_TRIGGER	.sos_fire,OFF

	P_SOUNDEFTDIST	ob_closedoor_s	;$ab
	P_DO		11
	P_ADDANIM	-1,12
	P_NEXT

	P_WAIT		1
	P_SETANIM	2
	P_WAIT		1
	P_SETANIM	0

	P_TRIGGER	.able_ck,OFF
	P_GOTO		.lp
.able_ck
	P_PLAYERINCONE	24,.able
	P_INVINCIBLE	ON
	P_REBOUNDLASER
	P_RETURN
.able
	P_INVINCIBLE	OFF
	P_RETURN

.sos_fire
;	P_ADD		worldy,-15<<to_hou_scale
	P_GOSUB		ring_fire_must_stay
;	P_ADD		worldy,15<<to_hou_scale
	P_RETURN
;;;.on
;;;	P_TRIGGER	.atack,OFF
;;;	P_TRIGGER	reflect_laser,OFF
;;;	P_INVINCIBLE	OFF
;;;	P_SETRANDOM	pbyte1,15
;;;	P_INC		pbyte1
;;;	P_DO		pbyte1
;;;	P_NEXT
;;;.onn
;;;	P_ZERO		pbyte1
;;;	P_IFSAME	animframe,-113,.fi
;;;	P_INC		pbyte1
;;;	P_IFSAME	animframe,-123,.fi
;;;	P_INC		pbyte1
;;;	P_IFSAME	animframe,-121,.fi
;;;	P_INC		pbyte1
;;;	P_IFSAME	animframe,-116,.fi
;;;	P_GOTO		.onn
;;;.fi
;;;	P_EXPORT	gbyte1,pbyte1
;;;	P_SPAWN		0,0,0,0,0,0,toge_0,e_to_hou_fire,100,0,2
;;;	P_BECOME
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_INDEX		childx,to_hou_x,pbyte1
;;;	P_INDEX		childy,to_hou_y,pbyte1
;;;	P_INDEX		childz,to_hou_z,pbyte1
;;;	P_UNBECOME
;;;	P_GOTO		.lp
;;;.anim
;;;	P_ADDANIM	1,16
;;;	P_RETURN
;;;to_hou_x
;;;	dw	0,17<<to_hou_scale,0,-18<<to_hou_scale
;;;to_hou_y
;;;	dw	-5<<to_hou_scale,-7<<to_hou_scale,3<<to_hou_scale,3<<to_hou_scale
;;;to_hou_z
;;;	dw	14<<to_hou_scale,18<<to_hou_scale,16<<to_hou_scale,17<<to_hou_scale
;-----------
	START_PATH	e_final_door_hp
	P_SET		roty,hp
	START_PATH	e_final_door

	P_PASSSOUND	ON
	P_GOSUB		init_hardslope_soff
	P_SETANIM	0
	P_SET		skidy,worldy
	P_DEC		skidy
	P_ZERO		worldy
.wlp
	P_IMPORT	pbyte1,ebyte2
	P_IFLARGER	pbyte1,skidy,.open
	P_IFSAME	pbyte1,254,.already_end
	P_GOTO		.wlp
.open
	P_WAIT		15
	P_ADD		worldy,-120
	P_GOSUB		make_demo_target
	P_ADD		worldy,120
	P_BECOME
	P_SET		slopenum,de_for_door_kotei_pos_s
	P_SET		pword1,-120
	P_SET		tx,17
	P_UNBECOME
	P_ACTIVE	ON
	P_GOSUB		demo_move_wait
	P_GOSUB		open_door
	P_SET		pbyte1,254
	P_EXPORT	ebyte2,pbyte1
	P_TRIGGER	.rem_meter,Timer,10
.already_end
	P_SETANIM	11
	P_SLOPE		OFF
	P_SET		shape,kabe_akufinal
	P_END
.rem_meter
	P_GSET		b,bossmaxhp,0
	P_RETURN
;------------
	START_PATH	e_semifinal_door

	P_PASSSOUND	ON
	P_GOSUB		init_hardslope_soff
	P_SETANIM	0
	P_RANGECHECK	OFF
	P_SET		coltab,black_c&wm
	P_SET		skidy,worldy
	P_DEC		skidy
	P_ZERO		worldy
.wlp
	P_IMPORT	pbyte1,ebyte4
	P_IFLARGER	pbyte1,skidy,.open
	P_GOTO		.wlp
.open
	P_SET		coltab,id_0_c&wm
	P_GOSUB		open_door
	P_ZERO		pbyte1
	P_EXPORT	ebyte4,pbyte1
	P_STAMPSTART
	P_GOSUB		init_hardslope_soff
	P_SLOPE		OFF
	P_SETANIM	11
	P_END
;------------
	START_PATH	e_tojikome_door

	P_PASSSOUND	ON
	P_GOSUB		init_hardslope_soff
	P_SLOPE		OFF
	P_SET		skidy,worldy
	P_DEC		skidy
	P_ZERO		worldy
	P_SETANIM	11
	P_GOSUB		roty_pb2_pb1
	P_INC		pbyte1
	P_INDEX		roty,init_angle_tab,pbyte2
	P_IMPORT	pbyte2,ebyte8
	P_IFSWITCH	pbyte1,pbyte2,.ended
	P_RTRIGGER	.tojikome,WhenThrough
.ended
	P_END
.tojikome
	P_FORCE		.close
	P_RETURN
.close
	P_TRIGGER	.tojikome,OFF
.mada
	P_WAIT		1
	P_PLAYERINCONE	64,.mada
	P_DISTLESS	200,.mada
	P_SET		pbyte1,-1
	P_EXPORT	ebyte3,pbyte1
	P_GOSUB		init_hardslope_soff
	P_GOSUB		crose_door
	P_GINC		b,ebyte3
	P_SET		pword1,shape
	P_SET		shape,ak1_1
.wlp
	P_IMPORT	pbyte1,ebyte3
	P_IFLARGER	pbyte1,skidy,.open
	P_GOTO		.wlp
.open
	P_SET		shape,pword1
	P_WAIT		15
	P_SOUNDEFFECT	door_open_chime	;$41
	P_GOSUB		open_door
	P_END
	
	
;-----------
	START_PATH	e_hit_dont_stop_door
	P_SET		childrotx,1
	START_PATH	e_hit_stop_door

	P_PASSSOUND	ON
	P_SET		pbyte1,roty
	P_GOSUB		init_hardslope_soff
	P_RANGECHECK	OFF
.lp
	P_IFNOTZERO	childrotx,.dont_stop
	P_RTRIGGER	.stop,WhenHitByPlayer
	P_INVINCIBLE	OFF
.dont_stop
	P_SOUND		p2_yoi_hou	;08
.lp2
	P_ADD		roty,pbyte1
	P_GOTO		.lp2
.stop
	P_HITFLASHTRIG
	P_FORCE		.stop_wait
	P_RETURN
.stop_wait
	P_SET		coltab,id_2_c&wm
	P_SETCOLANIM	1
	P_IFZERO	roty,.w
	P_IFSAME	roty,64,.w
	P_IFSAME	roty,128,.w
	P_IFSAME	roty,-64,.w
	P_ADD		roty,pbyte1
	P_GOTO		.stop_wait
.w
	P_TRIGGER	.stop,OFF
	P_SOUND		port2_stop
	P_SOUNDEFTDISTPOS	en_land_L	;$76
	P_INVINCIBLE	ON
	P_WAIT		65
	P_DO		5
	P_SET		coltab,id_2_c&wm
	P_WAIT		1
	P_SET		coltab,id_0_c&wm
	P_NEXT
	P_SET		colframe,0
	P_GOTO		.lp

;-----------
	START_PATH	e_final_1way_andorf

	P_SET		weapontype,2
	P_IGOTO		pe_1way_door.enter

	START_PATH	e_final_1way_door

	P_SET		weapontype,1
	P_IGOTO		pe_1way_door.enter

	START_PATH	e_1way_door

	P_SET		weapontype,0
.enter	LOCAL
	P_PASSSOUND	ON
	P_SET		skidy,worldy
	P_ZERO		worldy
	P_SETANIM	0
	P_RTRIGGER	.ground_ck,Always
	P_GOSUB		init_hardslope_soff
.wlp
	P_DISTLESS	4000,.ck
	P_GOTO		.wlp
.ck
	P_PLAYERINCONE	64,.this_color
	P_TRIGGER	.ground_ck,OFF
	P_SET		shape,ak1_1
	P_END
.this_color
.come_wait
	P_DISTLESS	600,.near
	P_GOTO		.come_wait
.near
	P_PLAYERINCONE	64,.open
	P_GOTO		.come_wait
.open
	P_RTRIGGER	.through_ck,WhenThrough
	P_IFZERO	weapontype,.e
	P_SET		pbyte1,254
	P_EXPORT	ebyte2,pbyte1
.e
	P_GOSUB		open_door
	P_END
.ground_ck
	P_IMPORT	pbyte1,ebyte7
	P_IFSWITCH	skidy,pbyte1,.gr_off
	P_GROUNDOBJ	ON
	P_IFNOTSAME	skidy,1,.not_kaku_to
	P_SET		shape,kaku_to_d
	P_RETURN
.not_kaku_to
	P_SET		shape,kabe_ak1_d
	P_RETURN
.gr_off
	P_GROUNDOBJ	OFF
	P_IFNOTSAME	skidy,1,.not_kaku_to2
	P_SET		shape,kaku_to
	P_RETURN
.not_kaku_to2
	P_SET		shape,kabe_ak1
	P_RETURN
.through_ck
	P_DISTMORE	300,.chigau
	P_FORCE		.crose
.chigau
	P_RETURN
.crose
	P_TRIGGER	.through_ck,OFF

.mada
	P_WAIT		1
	P_IFSAME	animframe,-117,.mok
	P_ADDANIM	1,12
.mok
	P_DISTMORE	500,.mada
	P_PLAYERINCONE	64,.mada
	P_DISTLESS	200,.mada

	P_IFZERO	weapontype,.not_core_room_tr
	P_FINDSHAPE	stg_checker
	P_BECOMESHAPE
	P_SET		weapontype,-1
	P_UNBECOME
	P_FORCETRANSFORM	robot
.not_core_room_tr
	P_SLOPE		ON
.op
	P_IFSAME	animframe,-117,.ok
	P_ADDANIM	1,12
	P_GOTO		.op
.ok
	P_GOSUB		crose_door
	P_IFZERO	weapontype,.not_core_room
	P_SET		pbyte1,255
	P_EXPORT	ebyte2,pbyte1
	P_TRIGGER	.ground_ck,OFF
	P_SET		shape,kaku_to1

	P_IFNOTSAME	weapontype,2,.ed
	P_WAIT		10
	P_IMPORT	pbyte1,KDifficulty
	P_ADD		pbyte1,137
	P_MSG		pbyte1
.ed
	P_END
.not_core_room
	P_TRIGGER	.ground_ck,OFF
	P_SET		shape,ak1_1
	P_SET		coltab,id_0_c&wm
	P_GSET		b,ebyte5,1
	P_END
;;;;-----------
	START_PATH	e_hit_open_door_0

	P_PASSSOUND	ON
	P_GOSUB		init_hardslope_soff
	P_RTRIGGER	.open,WhenHitByPlayer
	P_END
.open
	P_FORCE		.open_start
	P_RETURN
.open_start
	P_SOUNDEFTDISTPOS	ob_push_door	;$a8
	P_TRIGGER	.open,OFF
	P_PUSH		roty
	P_SET		pbyte1,roty
	P_NEG		pbyte1  
	P_DO		10
	P_FACEPLAYER	y
	P_INEXT
	P_ADD		roty,pbyte1
	P_SET		pbyte2,-10
	P_IFBETWEEN	-65,roty,64,.end_ck
	P_NEG		pbyte2
.end_ck
	P_PULL		roty

	P_DO		6
	P_ADD		roty,pbyte2
	P_NEXT

	P_DO		3
	P_DIV2		pbyte2
	P_INEXT
;	P_DIV2		pbyte2
;	P_DIV2		pbyte2
;	P_DIV2		pbyte2
	P_DO		4
	P_ADD		roty,pbyte2
	P_NEXT

	P_SOUNDEFTDISTPOS	en_land_L	;$76
	P_END
;;;;------------
	START_PATH	e_hit_open_door_1

	P_PASSSOUND	ON
	P_GOSUB		init_hardslope_soff
	P_SET		pbyte1,9
	P_SETANIM	0
.again
	P_RTRIGGER	.open,WhenHitByPlayer
	P_END
.open
	P_HITFLASHTRIG
	P_FORCE		.open_start
	P_RETURN
.open_start
	P_TRIGGER	.open,OFF

	P_HITFLASHTRIG
	P_ADDANIM	1,10
	P_SOUNDEFTDIST	ob_t_to_1_open	;$a0*
	P_DEC		pbyte1
	P_WAIT		1
	P_IFNOTSAME	pbyte1,5,.again

	P_SOUNDEFTDIST	ob_opendoor_s	;$92
	P_DO		pbyte1
	P_ADDANIM	1,10
	P_NEXT
	
	P_END
;;;;------------
	START_PATH	e_hit_open_door_2

	P_PASSSOUND	ON
	P_GOSUB		init_hardslope_soff
.door_2_start
	P_RTRIGGER	.open_d2,WhenHitByPlayer
	P_END

.open_d2
	P_FORCE		.open_d2_start
	P_RETURN

.open_d2_start
	P_SOUNDEFTDISTPOS	ob_push_door	;$a8
	P_TRIGGER	.open_d2,OFF
	P_PUSH		roty
	P_SET		pbyte1,roty
	P_NEG		pbyte1
	P_DO		10
	P_FACEPLAYER	y
	P_INEXT
	P_ADD		roty,pbyte1
	P_SET		pbyte2,-10
	P_IFBETWEEN	-65,roty,64,.end_ck_d2
	P_NEG		pbyte2
.end_ck_d2
	P_PULL		roty

	P_DO		12
	P_ADD		roty,pbyte2
	P_NEXT

	P_DIV2		pbyte2
	P_DIV2		pbyte2
	P_DO		4
	P_ADD		roty,pbyte2
	P_NEXT

	P_SOUNDEFTDISTPOS	en_land_L	;$76

	P_GOTO		.door_2_start
;-----------
	START_PATH	e_switch_cup_hard

	P_SPAWN		0,-22<<cup_scale,-45<<cup_scale,0,0,0,toge_big,e_toge_dama,100,4,2

	START_PATH	e_switch_cup

	P_GOSUB		init_hardslope_soff
	P_EXPORT	gbyte1,roty
	P_SPAWN		0,14<<cup_scale,70<<cup_scale,0,0,0,cup_1,e_cup_lift,100,4,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_UNBECOME
	P_SOUND		p2_cup_0	;08
.lp
	P_ADD		roty,2
	P_GOTO		.lp
;;;;------------
	START_PATH	e_cup_lift

	P_GOSUB		init_hardslope
	P_SPAWN		0,-2<<cup_scale-14<<cup_scale,20,0,0,0,on_d,e_fumu_switch_door_map_aku,100,4,2
	P_EXPORT	gbyte1,pbyte1
	P_BECOME
	P_IMPORT	roty,gbyte1
	P_SETANIM	0
	P_UNBECOME
.again
	P_WAIT		10
	P_SET		pbyte2,1
.lp
	P_DO		9
	P_INDEX		tx,cup_y_pos,pbyte2
	P_ADDANIM	1,10
	P_SET		childy,tx
	P_INC		pbyte2
	P_NEXT

	P_WAIT		10
	P_SET		pbyte2,8
.dlp
	P_DO		9
	P_INDEX		tx,cup_y_pos,pbyte2
	P_ADDANIM	-1,10
	P_SET		childy,tx
	P_DEC		pbyte2
	P_NEXT

	P_GOTO		.again
;;;;------------
	START_PATH	e_neta_switch_hikkomi
	P_INC		skidy
	START_PATH	e_neta_switch_bou
	P_INC		skidy
	START_PATH	e_fumu_switch_door_map_aku
.enter	LOCAL
	P_SET		pbyte2,roty
	P_ZERO		roty
	P_GOSUB		init_hardslope_soff
	P_MOVEPLAYER	ON
	P_ACTIVE	ON
	P_SETANIM	0
	P_SETCOLANIM	0
	P_INC		slopenum
	P_IFSWITCH	pbyte2,.already_off
	P_RTRIGGER	.fumu_stepped,WhenSteppedOn
	P_END
.fumu_stepped
	P_DISTMORE	150,.fumu_not_cen
	P_FORCE		.fumu_steped_anim
.fumu_not_cen
	P_RETURN
.fumu_steped_anim
	P_TRIGGER	.fumu_stepped,OFF
	P_IFSAME	skidy,1,.for_neta_bou
	P_IFSAME	skidy,2,.for_neta_kakure

	P_FINDSHAPE	kabe_aku
	P_BECOMESHAPE
	P_ADD		worldy,-120
	P_GOSUB		expo_world
	P_ADD		worldy,120
	P_UNBECOME
	P_SET		pbyte1,17
	P_EXPORT	gbyte1,pbyte1
	P_SET		pbyte1,de_for_door_kotei_pos
	P_EXPORT	gbyte2,pbyte1
	P_IGOTO		.demo
.for_neta_kakure
	P_FINDSHAPE	kakureto
	P_BECOMESHAPE
	P_ADD		worldy,-150
	P_GOSUB		expo_world
	P_ADD		worldy,150
	P_UNBECOME
	P_SET		pbyte1,17
	P_EXPORT	gbyte1,pbyte1
	P_SET		pbyte1,de_for_neta
	P_EXPORT	gbyte2,pbyte1
	P_IGOTO		.demo
.for_neta_bou
	P_FINDSHAPE	da_ha_ta
	P_SHAPEDEAD	.find_yo
.get_pos_bou
	P_BECOMESHAPE
	P_GOSUB		expo_world
	P_UNBECOME
	P_SET		pbyte1,17
	P_EXPORT	gbyte1,pbyte1
	P_SET		pbyte1,de_for_neta
	P_EXPORT	gbyte2,pbyte1
	P_IGOTO		.demo
.find_yo
	P_FINDSHAPE	da_ha_yo
	P_IGOTO		.get_pos_bou
.demo
	P_QSPAWN	demo_target,e_r_demo_target,100,0
	P_BECOME
	P_GOSUB		impo_world
	P_INVISIBLE	ON
	P_UNBECOME

	P_QSPAWN	nullshape,e_robo_demo,100,0
	P_BECOME
	P_IMPORT	pword1,gword2
	P_ADD		pword1,-50
	P_IMPORT	tx,gbyte1
	P_IMPORT	slopenum,gbyte2
	P_UNBECOME
	P_ACTIVE	ON
	P_WAIT		12
	P_SLOPE		OFF

	P_SOUNDEFFECT	ob_switchon	;$34
	P_DO		7
	P_ADDANIM	1,8
	P_NEXT
.already_off
	P_SET		shape,OFF_d
	P_SETANIM	7
	P_SETCOLANIM	1
	P_GOSUB		init_hardslope_soff

	P_GOSUB		demo_move_wait

	P_SETSWITCH	pbyte2

	P_IFNOTZERO	skidy,.for_neta2
	P_FLAGSHAPE
.for_neta2
	P_END
;;;;------------
	START_PATH	e_switch_op_door

	P_PASSSOUND	ON
	P_ACTIVE	ON
	P_SET		coltab,id_3_c&WM
	P_GOSUB		init_hardslope_soff
	P_SET		pbyte2,worldy
	P_ZERO		worldy
	P_IFSWITCH	pbyte2,.already_open
	P_SETANIM	0
	P_RTRIGGER	.op_sw_on,WhenFlagged
	P_END
.op_sw_on
	P_SETSWITCH	pbyte2
	P_FORCE		.open_on
	P_RETURN
.open_on
	P_TRIGGER	.op_sw_on,OFF
	P_GOSUB		open_door
.already_open
	P_SETANIM	11
	P_SLOPE		OFF
	P_COLLISIONS	OFF
	P_SET		shape,kabe_akufinal
	P_END
;;;;------------
	START_PATH	e_free_door

	P_PASSSOUND	ON
	P_SETANIM	0
	P_GOSUB		init_hardslope_soff
.again	LOCAL
	P_DISTLESS	300,.op_ck
	P_IFNOTSAME	animframe,-117,.alre_cr
	P_GOSUB		crose_door
.alre_cr
	P_GOTO		.again
.op_ck
	P_IFNOTSAME	animframe,-128,.alre_op
	P_GOSUB		open_door
.alre_op
	P_GOTO		.again
;;;
;;;;ษออออออออออออออป
;;;;บ NORMAL ENEMY บ
;;;;ศออออออออออออออผ
;;;	START_PATH	e_uchiage_mother
;;;
;;;	P_INVISIBLE	ON
;;;	P_RELTOPLAYER	ON
;;;
;;;	P_WAIT		70
;;;	P_TRIGGER	.make_uchiage,16
;;;.loop
;;;	P_IMPORT	pbyte1,KenemyNumber
;;;	P_IFZERO	pbyte1,.end
;;;	P_INPLAYERSCONE	-11,11,.keep_pos
;;;	P_CIRCLEPLAYER	10
;;;.keep_pos
;;;	P_DISTLESS	1800,.too_near
;;;	P_DISTLESS	2300,.keep
;;;	P_IMPORT	worldy,Player1_worldy
;;;	P_MOVEINPLAYER	127
;;;	P_GOTO		.loop
;;;.too_near
;;;	P_IMPORT	worldy,Player1_worldy
;;;	P_MOVEINPLAYER	-127
;;;.keep
;;;	P_GOTO		.loop
;;;.end
;;;	P_REMOVE
;;;
;;;.make_uchiage
;;;	P_INPLAYERSCONE	70,186,.pass
;;;	P_SETRANDOM	pbyte1,31
;;;	P_ADD		pbyte1,-16
;;;	P_CIRCLEPLAYER	pbyte1
;;;	P_QSPAWN	tomato_0,e_uchiage_missile,2,4
;;;	P_NEG		pbyte1
;;;	P_CIRCLEPLAYER	pbyte1
;;;.pass
;;;	P_RETURN
;;;;-----------
;;;	START_PATH	e_uchiage_missile
;;;
;;;	P_RELTOPLAYER	ON
;;;	P_RADAROBJ	ra_honmei
;;;	P_SET		slopenum,8
;;;	P_SET		ox,128
;;;	P_TRIGGER	only_roty,Always
;;;	P_TRIGGER	.life,Always
;;;	P_TRIGGER	.uchiage_dead,WhenDead
;;;	P_IMPORT	worldy,Player1_worldy
;;;	P_ADD		worldy,1000
;;;.loop
;;;	P_IMPORT	pword1,Player1_worldy
;;;	P_IFSMALLER	worldy,pword1,.to_player
;;;	P_ADD		worldy,-50
;;;	P_GOTO		.loop
;;;.to_player
;;;	P_DISTLESS	800,.near
;;;	P_MOVEINPLAYER	50
;;;	P_GOTO		.to_player
;;;.near
;;;	P_PUSH		roty
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SETVEL	40
;;;	P_PULL		roty
;;;	P_ZERO		rotx
;;;	P_WAIT		50
;;;.dead
;;;	P_TRIGGER	.uchiage_dead,OFF
;;;	P_EXPLODE
;;;.life
;;;	P_DEC		ox
;;;	P_IFNOTZERO	ox,.life_ok
;;;	P_FORCE		.dead
;;;.life_ok
;;;	P_RETURN
;;;.uchiage_dead
;;;	P_SCORE		sc_tomato
;;;	P_RETURN
;;;;------------
	START_PATH	e_yoyo_tank

	P_GOSUB		wakidashi_init
	P_RANGECHECK	OFF
	P_INVISIBLE	ON
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove
.wlp
	P_IMPORT	pbyte1,ebyte5
	P_IFSAME	pbyte1,1,.wst
	P_GOTO		.wlp
.wst
	P_ADD		roty,128
	P_INVISIBLE	OFF
	P_SOUND		p2_yoyo_c	;0E
	P_ENEMYDMGSE	en_cry_2
	P_SPAWN		34<<yoyo_scale,-14<<yoyo_scale,0,0,0,0,yoyo_l,e_yoyo_c,10,4,1
	P_SPAWN		-34<<yoyo_scale,-14<<yoyo_scale,0,0,0,0,yoyo_r,e_yoyo_c,10,4,2
	P_SETBOSSNAME	name_yoyo
	P_GOSUB		enemy_hp_meter_hydra
	P_GOSUB		.colli_on
	P_RTRIGGER	.out_ck,Always
.lp
	P_SETVEL	40
	P_GOSUB		.muteki
	P_WAIT		60
	P_SETVEL	0
	P_GOSUB		.futsuu
	P_ZERO		pbyte2

	P_GOSUB		.at_wait

	P_DO		3
	P_GOSUB		.fire_tama
	P_DO		5
	P_SETVEL	0
	P_FACEPLAYER	y
	P_NEXT
	P_NEXT

	P_GOSUB		.at_wait

	P_GOTO		.lp
.at_wait
	P_DO		15
	P_SETVEL	0
	P_FACEPLAYER	y
	P_NEXT
	P_RETURN
.colli_on
	P_RTRIGGER	.hit_ck,WhenHit
	P_COLLISIONS	ON
	P_RETURN
.hit_ck
	P_TRIGGER	.hit_ck,OFF
	P_COLLISIONS	OFF
	P_SET		pbyte1,40
	P_IFLARGER	hp,pbyte1,.ok
	P_TRIGGER	.out_ck_on,OFF
	P_TRIGGER	.colli_on,OFF
	P_TRIGGER	.out_ck,OFF
	P_TRIGGER	.kieru,OFF
	P_TRIGGER	.ataru,OFF
	P_FORCE		.dead
	P_RETURN
.ok
	P_TRIGGER	.colli_on,Timer,4
	P_RETURN
.dead
	P_SCREENFLASH
	P_SCORE		sc_shield_robo

	P_TRIGGER	mk_many_damy_exp,4
	P_DO		15
	P_RANDOMGOTO	.no_fl1
	P_HITFLASHTRIG
.no_fl1
	P_NEXT

	P_SOUNDEFTPOS	en_death_2	;$79
	P_SOUNDEFTPOS	bs_BossExplode2	;$c0
	P_CIRCLEWINDOW	1,big
	P_DO		4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,8
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT
	P_GINC		b,ebyte2
	P_GOSUB		make_random_item
	P_EXPLODE
.fire_tama
	P_SOUNDEFTDISTPOS	en_tank_shoot	;$74
	p_SPAWN		0,-5<<yoyo_scale,15<<yoyo_scale,0,0,0,boost,gunblaze,1,1,9
	P_SPAWN		0,-4<<yoyo_scale,4<<yoyo_scale,0,0,0,toge_0,e_tank_tama,100,4
	P_RETURN
.out_ck
	P_IFNOTBETWEEN	512,worldx,2048,.out
	P_IFNOTBETWEEN	7680,worldz,10752,.out
	P_RETURN
.out
	P_TRIGGER	.out_ck,OFF
	P_SETVEL	0
	P_QSPAWN	marker,e_marker_target,10,10
	P_BECOME
	P_FINDSHAPE	yoyo_c
	P_SET		worldx,1536
	P_SET		worldz,9216
	P_FACESHAPE	IMMEDIATE
	P_EXPORT	gbyte1,roty
	P_UNBECOME
	P_IMPORT	childroty,gbyte1
	P_ADD		childroty,128
	P_TRIGGER	.turn,Always,32
	P_TRIGGER	.out_ck_on,TIMER,40
	P_RETURN
.out_ck_on
	P_TRIGGER	.out_ck,Always
	P_SETVEL	40
	P_RETURN
.turn
	P_CHASE		roty,childroty
	P_RETURN
.muteki
	P_SOUNDEFTDISTPOS	en_yoyo_c_close	;$89*
	P_TRIGGER	.chijimu,Always,5
	P_TRIGGER	.kieru,Timer,5
	P_RETURN
.futsuu
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_SOUNDEFTDISTPOS	en_yoyo_c_open	;$89*
	P_TRIGGER	.deru,Always,5
	P_TRIGGER	.ataru,Timer,5
	P_RETURN
.ataru
	P_SET		shape,yoyo_c
	P_COLLISIONS	ON
	P_RETURN
.kieru
	P_INVISIBLE	ON
	P_RETURN
.deru
	P_BECOMECHILD	1
	P_ADD		childx,4<<yoyo_scale
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childx,-4<<yoyo_scale
	P_UNBECOME
	P_RETURN
.chijimu
	P_COLLISIONS	OFF
	P_SET		shape,yoyo_c2
	P_BECOMECHILD	1
	P_ADD		childx,-4<<yoyo_scale
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childx,4<<yoyo_scale
	P_UNBECOME
	P_RETURN
;------------
	START_PATH	e_yoyo_c
	P_INVINCIBLE	ON
	P_TRIGGER	reflect_laser,Always
	P_RTRIGGER	.cata_anim,Always
	P_SET		pbyte1,-4
	P_END
.cata_anim
	P_ADD		ty,pbyte1
	P_RETURN
;;;;------------
	START_PATH	e_root_tank_final2

	P_SET		weapontype,1
	P_IGOTO		pe_root_tank_final.enter
;-----------
	START_PATH	e_root_tank_tojikomefinal
	P_SET		weapontype,2
	P_IGOTO		pe_root_tank_final.enter
;-----------
	START_PATH	e_root_tank_final

	P_SET		weapontype,0
.enter	LOCAL
;-----
	P_SET		skidy,hp
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove
	P_IMPORT	pbyte1,ebyte8
	P_IFSWITCH	skidy,pbyte1,eg_remove
;	P_IGOTO		.sw_ok
;.swrem
;	P_REMOVE
.sw_ok
;-----
	P_SET		slopenum,worldy
	P_INDEX		childroty,root_t_tab1,slopenum
	P_INDEX		ox,root_t_tab2,slopenum
	P_INDEX		oz,root_t_tab2,slopenum
	P_INDEX		childx,root_t_tab3,slopenum
	P_INDEX		childz,root_t_tab3,slopenum
	P_SET		worldy,-25<<r_tank_scale
	P_GOSUB		wakidashi_init

	P_IFNOTSAME	weapontype,2,.nt
	P_INVISIBLE	ON
.wnt
	P_IMPORT	pbyte1,ebyte3
	P_IFSAME	pbyte1,-1,.nt
	P_GOTO		.wnt
.nt
	P_INVISIBLE	OFF
	P_SOUND		p2_r_tank_0	;09
	P_SET		slopenum,hp
	P_ADD		slopenum,-5
	P_SPAWN		0,(-57+25)<<r_tank_scale,0,0,0,0,r_tank_1,e_root_tank_c,100,4,1
	P_RTRIGGER	.cyata,Always
;	P_SET		ox,-10
;	P_SET		oz,-10
;	P_SET		childroty,64
	P_SET		pbyte2,1
	P_RTRIGGER	.hit,WhenHit
.lp
	P_GOSUB		.make_r_y
	P_GOSUB		.move_x
	P_GOSUB		.make_r_y
	P_GOSUB		.move_z
	P_IGOTO		.lp
.hit
	P_SET		pbyte1,70
	P_IFLARGER	hp,pbyte1,.up
	P_FORCE		.dead
.up
	P_IFLARGER	hp,slopenum,.ok
	P_ADD		slopenum,-5
	P_SET		mx,ox
	P_DIV2		mx
	P_ADD		ox,mx
	P_SET		mz,oz
	P_DIV2		mz
	P_ADD		oz,mz
	P_INC		pbyte2
.ok
	P_RETURN
.dead
	P_TRIGGER	.hit,OFF
	P_COLLISIONS	OFF
	P_IFZERO	childrotx,.soko
	P_IFSAME	childrotx,1,.mvx
	P_DO		5
	P_DIV2		oz
	P_ADD		worldz,oz
	P_NEXT
	P_GOTO		.exp
.mvx
	P_DO		5
	P_DIV2		ox
	P_ADD		worldx,ox
	P_NEXT
	P_IGOTO		.exp
.soko
	P_WAIT		5
.exp
	P_FLAGCHILD	1
	P_UNLINKCHILD	1
	P_GOSUB		s_group_explode
	P_SOUNDEFTPOS	bs_BossExplode2	;$c0
	P_CIRCLEWINDOW	1,big
	P_SCORE		sc_kabe_mukade
	P_GINC		b,ebyte2
	P_GOSUB		make_random_item
	P_GOSUB		room_enemy_sw_dead
	P_IFNOTSAME	weapontype,2,.tf
	P_GINC		b,ebyte3
.tf
	P_EXPLODE
	
.make_r_y
	P_ZERO		childrotx
	P_DO		pbyte2
	P_CHASE		roty,childroty
	P_BECOMECHILD	1
	P_FACEPLAYER	y
	P_ADJUSTROT
	P_UNBECOME
	P_INEXT
	P_IFSAME	roty,childroty,.made
	P_GOTO		.make_r_y
.made
	P_ADD		childroty,64
	P_RETURN
.move_x
	P_SET		childrotx,1
	P_ADD		worldx,ox
	P_ADD		childx,ox
	P_IFSAME	weapontype,1,.final2x
	P_IFNOTBETWEEN	-1024,childx,0,.endx
	P_GOTO		.move_x
.final2x
	P_IFNOTBETWEEN	-2048,childx,0,.endx
	P_GOTO		.move_x
.endx
	P_NEG		ox
	P_RETURN
.move_z
	P_SET		childrotx,2
	P_ADD		worldz,oz
	P_ADD		childz,oz
	P_IFSAME	weapontype,1,.final2z
	P_IFNOTBETWEEN	-1024,childz,0,.endz
	P_GOTO		.move_z
.final2z
	P_IFNOTBETWEEN	-3072,childz,0,.endz
	P_GOTO		.move_z
.endz
	P_NEG		oz
	P_RETURN
.cyata
	P_ADD		ty,-3
	P_RETURN
;--------
	START_PATH	e_root_tank_c

	P_COLLISIONS	OFF
	P_ACTIVE	ON
	P_RTRIGGER	.face,Always
	P_RTRIGGER	.dead,WhenFlagged
	P_END
.dead
	P_FORCE		.dead_on
	P_RETURN
.dead_on
	P_TRIGGER	.face,OFF
	P_TRIGGER	.dead,OFF
	P_ZERO		pbyte1
	P_DO		18
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_ADD		roty,32
	P_ADD		rotx,32
	P_NEXT
	P_EXPLODE
.face
	P_IFZERO	slopenum,.zs
	P_DEC		slopenum
.zs
	P_SET		pbyte1,roty
	P_FACEPLAYER	y
;	P_FACEPLAYER	y
	P_IFLARGER	roty,pbyte1,.ad
	P_ADD		pbyte1,-4
.ad
	P_ADD		pbyte1,2
	P_SET		roty,pbyte1
	P_ADJUSTROT
	P_PLAYERINCONE	5,.fire
	P_RETURN
.fire
	P_IFNOTZERO	slopenum,.cant
	P_SOUNDEFTDISTPOS	en_tank_shoot	;$74
	p_SPAWN		0,-5<<r_tank_scale,15<<r_tank_scale,0,0,0,boost,gunblaze,1,1,9
	P_QSPAWN	toge_0,e_tank_tama,100,4
	P_SET		slopenum,30
.cant
	P_RETURN
;------------
	START_PATH	e_tank_tama

	P_RTRIGGER	.ck_ground,Always
	P_INVISIBLE	ON
	P_WAIT		1
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_TRIGGER	.colli_on,Timer,5

	P_IMPORT	childx,Player1_worldx
	P_NEG		childx
	P_ADD		childx,worldx
	P_DO		4
	P_DIV2		childx
	P_INEXT
	P_SET		pword1,childx
	P_DO		3
	P_DIV2		childx
	P_INEXT
	P_NEG		childx
	P_ADD		childx,pword1
	P_NEG		childx
	P_IMPORT	childz,Player1_worldz
	P_NEG		childz
	P_ADD		childz,worldz
	P_DO		4
	P_DIV2		childz
	P_INEXT
	P_SET		pword1,childz
	P_DO		3
	P_DIV2		childz
	P_INEXT
	P_NEG		childz
	P_ADD		childz,pword1
	P_NEG		childz

	P_AUTOINDEX	b,worldy,dandou_tab,pbyte1,14
	P_WAIT		1

	P_CLRTYPE	enemy1
	P_DO		13
	P_AUTOINDEX	b,worldy,dandou_tab,pbyte1,14
	P_NEXT
	P_WAIT		1
.lp
	P_SET		pbyte1,50
	P_ADD		worldy,pbyte1
	P_GOTO		.lp
.colli_on
	P_COLLISIONS	ON
	P_RETURN
.ck_ground
	P_ADD		roty,16
	P_HITSLOPE	.expp
	P_ADD		worldx,childx
	P_ADD		worldz,childz
	P_HITGROUND	0,.exp
	P_RETURN
.exp
	P_FORCE		.exp_on
	P_RETURN
.expp
	P_FORCE		.exp_onn
	P_RETURN
.exp_on
	P_ZERO		worldy
.exp_onn
	P_EXPLODE
;;;;------------
	START_PATH	e_kabe_mukade_tojikome
	P_INC		childrotx
	P_SET		childrotz,ap
	START_PATH	e_kabe_mukade_final
	P_INC		childrotx
	START_PATH	e_kabe_mukade

;-----
	P_SET		skidy,hp
	P_IMPORT	pbyte1,ebyte8
	P_IFSWITCH	skidy,pbyte1,eg_remove
;	P_IGOTO		.sw_ok
;.swrem
;	P_REMOVE
.sw_ok
;-----
	P_SET		hp,100
	P_SET		ap,4

	P_IFNOTSAME	childrotx,2,.nt
	P_INVISIBLE	ON
.wnt
	P_IMPORT	pbyte1,ebyte3
	P_IFSAME	pbyte1,-1,.nt
	P_GOTO		.wnt
.nt
	P_SETANIM	0
	P_INVISIBLE	ON
	P_SET		childx,worldx
	P_SET		childz,worldz
.lp
	P_SETRANDOM	pbyte1,7
	P_SET		worldx,childx
	P_SET		worldz,childz
	P_INDEX		pword1,mukaderoom_x,pbyte1
	P_ADD		worldx,pword1
	P_INDEX		pword1,mukaderoom_z,pbyte1
	P_ADD		worldz,pword1
	P_INDEX		roty,mukaderoom_rot,pbyte1

	P_RTRIGGER	.must_chijimu,WhenHit

	P_GOSUB		.nobiru
	P_WAIT		10
	P_DO		5
	P_GOSUB		.kabe_muka_at
	P_WAIT		30
	P_NEXT

.must_chijimu_on
	P_TRIGGER	.must_chijimu,OFF
	P_GOSUB		.chijimu

	P_WAIT		10
	P_GOTO		.lp

.kabe_muka_at	LOCAL
	P_SPAWN		0,0,60<<room_hou_scale,0,0,0,ring_mark,e_ring_mark_child,10,10,11
	P_RETURN

.nobiru	LOCAL
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_WAIT		1
	P_RADAROBJ	ra_enemy
	P_SOUNDEFTDISTPOS	ob_room_hou_out	;$a2*
	P_DO		15
	P_ADDANIM	1,16
	P_NEXT
	P_COLLISIONS	ON
	P_RETURN
.chijimu	LOCAL
	P_COLLISIONS	OFF
	P_SOUNDEFTDISTPOS	ob_room_hou_in	;$a2
	P_DO		15
	P_ADDANIM	-1,16
	P_NEXT
	P_WAIT		1
	P_INVISIBLE	ON
	P_RADAROBJ	ra_off
	P_RETURN

.must_chijimu
	P_REMOVE	11
	P_SET		pbyte1,80
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.dead
	P_RETURN
.ok
	P_FORCE		.on
	P_RETURN
.on
	P_CLEARSTACK
	P_IGOTO		.must_chijimu_on
	
.dead
	P_TRIGGER	.must_chijimu,OFF
	P_COLLISIONS	OFF
	P_SCORE		sc_kabe_mukade
	P_GOSUB		room_enemy_sw_dead
	P_SCREENFLASH
	P_GOSUB		s_group_explode
	P_IFZERO	childrotx,.nashi
	P_IFSAME	childrotx,1,.final
	P_GINC		b,ebyte3
	P_SCORE		sc_sos_strong
	P_GOSUB		make_hp_item_random

	P_INDEX		pbyte1,toji_muka_medal,childrotz
	P_EXPORT	gbyte1,pbyte1
	P_EXPORT	gword1,childx
	P_EXPORT	gword2,childz
	P_GOSUB		set_medal
	P_BECOME
	P_GOSUB		impo_xz_world
;	P_IMPORT	worldx,gword1
;	P_IMPORT	worldz,gword2
	P_SET		worldy,-80
	P_UNBECOME
	P_EXPLODE
.final
	P_SCORE		sc_shield_robo
	P_GINC		b,ebyte2
	P_GOSUB		make_hp_item
	P_EXPLODE
.nashi
	P_GOSUB		make_hp_item_random
	P_SCORE		sc_sos_strong
	P_EXPLODE
;.mukaderoom_x
;	dw	-256,256,1056,1056,-1056,-1056,-256,256
;.mukaderoom_z
;	dw	1056,1056,256,-256,256,-256,-1056,-1056
;.mukaderoom_rot
;	db	128,128,64,64,-64,-64,0,0
;;;;------------
	START_PATH	e_uso_enemy2

;	P_TRIGGER	marker_set,Always

	START_PATH	e_uso_enemy

	P_GOSUB		hit_dead_init
	P_TRIGGER	hit_dead,whenDead
	P_SETANIM	0
	P_END

;;;;------------
	START_PATH	e_kabe_hou

	P_GOSUB		hit_dead_init
	P_TRIGGER	ring_hit_dead,WhenDead
	P_SETRANDOM	pbyte2,31
	P_ADD		pbyte2,16
.lp
	P_INC		pbyte2
	P_IFNOTSAME	pbyte2,64,.f_wait
	P_ZERO		pbyte2
	P_GOSUB		ring_fire_must_stay
.f_wait
	P_GOTO		.lp
;;;;------------

	START_PATH	e_laser_hou_c
	P_SET		skidy,hp
	P_TRIGGER	hou_c_dead,WhenDead
	P_IGOTO		pe_laser_hou.enter

	START_PATH	e_laser_hou_final
	P_TRIGGER	inc_final_door_lock,WhenDead
	
	START_PATH	e_laser_hou
.enter	LOCAL
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove

	P_TRIGGER	hit_dead,WhenDead
	P_TRIGGER	shot_ck,Always
	P_GOSUB		hit_dead_init
	P_WEAPON	ELaser
	P_FACEPLAYER	IMMEDIATE
	P_ZERO		rotx
	P_WAIT		3
	P_SET		pbyte1,8
	P_GOSUB		ran_neg_pb1
.face_loop
	P_PLAYERINCONE	5,.atack
.face_loop2
	P_ADD		roty,pbyte1
	P_ADJUSTROT
	P_GOTO		.face_loop
.atack
	P_IFNOTZERO	pbyte2,.cant
	P_DO		2
	P_ADD		worldy,-40
	P_GOSUB		sos_fire_must
	P_ADD		worldy,40
	P_WAIT		4
	P_NEXT
	P_SET		pbyte2,32
.cant
	P_GOTO		.face_loop2

shot_ck
	P_IFZERO	pbyte2,.shot_ok
	P_DEC		pbyte2
.shot_ok
	P_RETURN
;-----------
hou_c_dead
	P_BECOMEMOTHER
	P_INC		pbyte2
	P_UNBECOME
	P_IMPORT	pbyte1,ebyte6
	P_SETSWITCH	skidy,pbyte1
	P_EXPORT	ebyte6,pbyte1
	P_FLAGMOTHER
	P_RETURN
;-----------
;;;	START_PATH	e_ring_hou_c
;;;	P_SET		skidy,hp
;;;	P_TRIGGER	hou_c_dead,WhenDead
;;;	P_IGOTO		pe_ring_hou.enter

	START_PATH	e_ring_hou_final
	P_TRIGGER	inc_final_door_lock,WhenDead

	START_PATH	e_ring_hou
.enter	LOCAL
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove

	P_TRIGGER	hit_dead,WhenDead
	P_TRIGGER	shot_ck,Always
	P_GOSUB		hit_dead_init
	P_WEAPON	ERing
	P_FACEPLAYER	IMMEDIATE
	P_ZERO		rotx
	P_WAIT		3
	P_SET		pbyte1,4
	P_GOSUB		ran_neg_pb1
.face_loop
	P_SOUND		p2_yoi_hou	;08
.face_loop2
	P_ADD		roty,pbyte1
	P_ADJUSTROT
	P_PLAYERINCONE	5,.atack
	P_GOTO		.face_loop2
.atack
	P_SOUND		port2_stop
	P_IFNOTZERO	pbyte2,.cant
	P_SPAWN		0,-50,200,0,0,0,ring_mark,e_ring_mark_child,10,10,11
;	P_DO		10
;	P_FACEPLAYER	y
;	P_NEXT
	P_WAIT		10
;	P_ADD		worldy,-40
;	P_GOSUB		sos_fire_must
;	P_ADD		worldy,40
	P_WAIT		10
	P_SET		pbyte2,32
.cant
	P_GOTO		.face_loop

;;;	START_PATH	e_yoi_hou
;;;
;;;	P_GOSUB		not_target_hou
;;;
;;;.face_loop
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	5,.atack
;;;	P_IFZERO	pbyte1,.ok
;;;	P_DEC		pbyte1
;;;.ok
;;;	P_GOTO		.face_loop
;;;.atack
;;;	P_IFNOTZERO	pbyte1,.cant
;;;	P_ADD		worldy,-100
;;;	P_GOSUB		immed_fire
;;;	P_ADD		worldy,100
;;;	P_ZERO		rotx
;;;	P_SET		pbyte1,64
;;;.cant
;;;	P_DEC		pbyte1
;;;	P_GOTO		.face_loop
;;;;------------
	START_PATH	e_hae_fly_box

	P_SPAWN		0,110,-50,0,0,0,box_0small,e_cube,2,3,1
	P_SOUND		p2_hae_0
	P_IGOTO		pe_sagyou_walk_box.hae_start
;;;;------------
	START_PATH	e_wakidashi_hae

	P_GOSUB		wakidashi_init
	P_TRIGGER	wakidashi_dead,WhenHit
	P_TRIGGER	fly_wave,Always
	P_SET		tx,4
	P_SET		ty,4
	P_RTRIGGER	.hae_anim,Always
	P_WEAPON	ELaser
	P_SOUND		p2_hae_0
	P_QUADVECS	ON
.atack_start
	P_RTRIGGER	.hae_atack,128		
.loop
	P_SETRANDOM	slopenum

	P_RANDOMGOTO	.face1
	P_DO		8
	P_FACEPLAYER	y
	P_NEXT
	P_IGOTO		.face2
.face1
	P_DO		8
	P_CHASE		roty,slopenum
	P_NEXT
.face2
	P_ACCEL		15,2
	P_SETRANDOM	slopenum,31
.move2
	P_DEC		slopenum
	P_IFSAME	slopenum,-1,.stop
	P_GOTO		.move2
.stop
	P_ACCEL		0,2
	P_GOTO		.loop
.hae_atack
	P_RANDOMGOTO	.pass_at
	P_FORCE		.atack_on
.pass_at
	P_RETURN
.atack_on
	P_TRIGGER	.hae_atack,OFF
	P_ACCEL		0,2
	P_SET		childrotx,rotx
	P_SET		childroty,roty
	
	P_DO		3
	P_DO		16
	P_FACEPLAYER	y
	P_NEXT

	P_GOSUB		sos_fire_must
	P_NEXT

	P_GOTO		.atack_start

.hae_anim
	P_HITSLOPE	wakidashi_dead_no_sc
	P_ADDANIM	1,6
	P_RETURN

;;;	START_PATH	e_hae_0_target
;;;
;;;	P_SET		skidy,roty
;;;.tar_start	LOCAL
;;;	P_GOSUB		set_child_xyz
;;;	P_RANGECHECK	OFF
;;;	P_SOUND		p2_hae_0
;;;	P_RADAROBJ	ra_enemy
;;;	P_TRIGGER	marker_set,Always
;;;	P_GOSUB		set_hp100_ap4
;;;	P_WEAPON	ELaser
;;;	P_ALWAYSGENVECS	ON
;;;	P_TRIGGER	.hae_dead,WhenHit		;Dead
;;;.atack_start
;;;	P_TRIGGER	.hae_atack,128
;;;.restart
;;;	P_TRIGGER	.hae_area,4
;;;.loop
;;;	P_SETRANDOM	pbyte1
;;;	P_SETRANDOM	pbyte2,32
;;;
;;;	P_DO		8
;;;	P_CHASE		roty,pbyte1
;;;	P_NEXT
;;;
;;;	P_SETVEL	40
;;;.move2
;;;	P_DEC		pbyte2
;;;	P_IFSAME	pbyte2,-1,.stop
;;;	P_GOTO		.move2
;;;.stop
;;;	P_SETVEL	0
;;;	P_GOTO		.loop
;;;	P_END
;;;.hae_atack
;;;	P_FORCE		.atack_on
;;;	P_RETURN
;;;.atack_on
;;;	P_TRIGGER	.hae_area,OFF
;;;	P_TRIGGER	.hae_atack,OFF
;;;	P_SETVEL	0
;;;	P_SET		childrotx,rotx
;;;	P_SET		childroty,roty
;;;	
;;;	P_DO		3
;;;	P_DO		16
;;;	P_FACEPLAYER
;;;	P_NEXT
;;;
;;;	P_FIRE
;;;	P_NEXT
;;;.face
;;;	P_WAIT		1
;;;	P_CHASE		rotx,childrotx
;;;	P_CHASE		roty,childroty
;;;	P_IFNOTSAME	rotx,childrotx,.face
;;;	P_IFNOTSAME	roty,childroty,.face
;;;	P_GOTO		.atack_start
;;;.hae_area
;;;	P_IFZERO	slopenum,.make_mark
;;;	P_FLAGSHAPE
;;;	P_ZERO		slopenum
;;;.make_mark
;;;	P_INC		slopenum
;;;	P_GOSUB		put_marker
;;;	P_BECOME
;;;	P_FINDSHAPE	hae_0
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldz,gword2
;;;	P_UNBECOME
;;;	P_SHAPEDISTLESS	1000,.near
;;;	P_FORCE		.come
;;;	P_RETURN
;;;.near
;;;	P_FLAGSHAPE
;;;	P_DEC		slopenum
;;;	P_RETURN
;;;.come
;;;	P_TRIGGER	.hae_area,OFF
;;;.come1
;;;	P_FACESHAPE
;;;	P_MOVEINSHAPE	30
;;;	P_SHAPEDISTLESS	50,.go_rest
;;;	P_GOTO		.come1
;;;.go_rest
;;;	P_GOTO		.restart
;;;.hae_dead
;;;	P_SCORE		sc_hae
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.hae_area,OFF
;;;	P_TRIGGER	.hae_atack,OFF
;;;	P_TRIGGER	.hae_dead,OFF
;;;	P_IGOTO		final_enemy_demo
;;;;------------
	START_PATH	e_wakidashi_ka

	P_GOSUB		wakidashi_init
	P_TRIGGER	wakidashi_dead,WhenHit
	P_RTRIGGER	.sl_ck,Always
	P_TRIGGER	fly_wave,Always
	P_SET		tx,3
	P_SET		ty,3
	P_WEAPON	ELaser
	P_SOUND		p2_hae_0
	P_QUADVECS	ON
.start
	P_SETVEL	15
.come
	P_FACEPLAYER	y
	P_WITHINRADIUS	1500,.stop
	P_GOTO		.come
.stop
	P_ACCEL		0,2
	P_DO		3
	P_GOSUB		sos_fire_must
	P_DO		5
	P_FACEPLAYER	y
	P_NEXT
	P_NEXT
.run
	P_SETRANDOM	childroty
.turn
	P_CHASE		roty,childroty
	P_IFSAME	roty,childroty,.go
	P_GOTO		.turn
.go
	P_ACCEL		15,2
	P_RANDOMGOTO	.run
.go2
	P_DISTMORE	2000,.come
	P_GOTO		.go2
	
.sl_ck
	P_HITSLOPE	wakidashi_dead_no_sc
	P_RETURN

;;;	START_PATH	e_ka_0_target
;;;
;;;	P_SET		skidy,roty
;;;	P_GOSUB		set_child_xyz
;;;	P_RADAROBJ	ra_enemy
;;;	P_TRIGGER	marker_set,ALways
;;;	P_GOSUB		set_hp100_ap4
;;;	P_RANGECHECK	OFF
;;;	P_ALWAYSGENVECS	ON
;;;	P_WEAPON	RelElaser
;;;	P_TRIGGER	.ka_dead,WhenHit		;Dead
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_ZERO		rotx
;;;.start
;;;	P_RELTOPLAYER	ON
;;;	P_SETVEL	30
;;;	P_TRIGGER	.home_life_ck,Always
;;;.come
;;;	P_FACEPLAYER	y
;;;	P_WITHINRADIUS	1000,.stop
;;;	P_GOTO		.come
;;;.stop
;;;	P_ACCEL		0,2
;;;	P_DO		3
;;;	P_GOSUB		immed_fire
;;;	P_ZERO		rotx
;;;	P_DO		40
;;;	P_FACEPLAYER	y
;;;	P_NEXT
;;;	P_NEXT
;;;
;;;	P_SETRANDOM	childroty
;;;.turn
;;;	P_CHASE		roty,childroty
;;;	P_IFSAME	roty,childroty,.go
;;;	P_GOTO		.turn
;;;.go
;;;	P_ACCEL		30,2
;;;.go2
;;;	P_DISTMORE	1500,.come
;;;	P_GOTO		.go2
;;;	
;;;	P_END
;;;.home_life_ck
;;;	P_INC		pword1
;;;	P_IFNOTSAME	pword1,200,.cont
;;;	P_FORCE		.back_home
;;;.cont
;;;	P_RETURN
;;;.back_home
;;;	P_TRIGGER	.home_life_ck,OFF
;;;	P_CLEARSTACK
;;;	P_ZERO		pword1
;;;	P_INC		pbyte1
;;;	P_GOSUB		put_marker
;;;	P_BECOME
;;;	P_FINDSHAPE	ka_0
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldz,gword2
;;;	P_UNBECOME
;;;
;;;	P_SETVEL	0
;;;	P_RELTOPLAYER	OFF
;;;	P_ACCEL		60,3
;;;.go_home
;;;	P_FACESHAPE
;;;	P_ZERO		rotx
;;;	P_SHAPEDISTLESS	500,.start_to
;;;	P_GOTO		.go_home
;;;.start_to
;;;	P_FLAGSHAPE
;;;	P_ZERO		pbyte1
;;;	P_GOTO		.start
;;;.ka_dead
;;;	P_IFZERO	pbyte1,.no
;;;	P_FLAGSHAPE
;;;.no
;;;	P_SCORE		sc_ka
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.home_life_ck,OFF
;;;	P_TRIGGER	.ka_dead,OFF
;;;	P_IGOTO		final_enemy_demo
;;;;------------
	START_PATH	e_sw_arrow

	P_SHADOW	OFF
	P_SET		hp,100
	P_COLLISIONS	OFF
	P_TRIGGER	pe_marker.rem,WhenFlagged
	P_RTRIGGER	.ve,Always
	P_RTRIGGER	.vis,64
	P_END
.ve
	P_FACEVIEW	IMMEDIATE
	P_RETURN
.vis
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_RETURN
;;;;------------
	START_PATH	e_friend_marker

	P_INVISIBLE	ON
	P_RTRIGGER	.rem,WhenFlagged

	P_SETRANDOM	pbyte1,3
	P_SETRANDOM	pbyte2,3
.lp
	P_COPYPLAYERPOS
	P_IFSAME	pbyte2,2,.d
	P_IFSAME	pbyte2,3,.u
	P_IGOTO		.fl
.u
	P_ADD		worldy,50
	P_IGOTO		.fl
.d
	P_ADD		worldy,-50
.fl
	P_IFSAME	pbyte1,1,.xp100
	P_IFSAME	pbyte1,2,.xm100
	P_IFSAME	pbyte1,3,.zp100
	P_ADD		worldz,-100
	P_GOTO		.lp
.zp100
	P_ADD		worldz,100
	P_GOTO		.lp
.xm100
	P_ADD		worldx,-100
	P_GOTO		.lp
.xp100
	P_ADD		worldx,100
	P_GOTO		.lp

.rem	LOCAL

	P_FORCE		.kill
	P_RETURN
.kill
	P_STAMPSTART
	P_REMOVE
;;;;------------
	START_PATH	e_marker

	P_INVISIBLE	ON
	P_RTRIGGER	.rem,WhenFlagged
	P_RTRIGGER	.rem,WhenShapeDead

	P_END

.rem	LOCAL

	P_FORCE		.kill
	P_RETURN
.kill
	P_STAMPSTART
	P_REMOVE
;;;;------------
	START_PATH	e_room_toge

	P_SET		tx,roty
	P_ZERO		roty
	P_INVINCIBLE	ON
	P_RADAROBJ	ra_enemy
	P_GOSUB		set_hp100_ap4
	P_SET		coltab,id_1_c&wm

	P_SET		childx,worldx
	P_ADD		childx,150
	P_SET		ox,worldx
	P_ADD		ox,-150
	P_SET		childz,worldz
	P_ADD		childz,150
	P_SET		oz,worldz
	P_ADD		oz,-150
.lp
	P_IFSAME	tx,1,.ck_z
	P_IMPORT	pword1,Player1_worldx
	P_IFSMALLER	pword1,ox,.ck_z
	P_IFLARGER	pword1,childx,.ck_z
	P_SET		pbyte1,80		;z_offset
	P_ZERO		pbyte2			;x_offset
	P_IGOTO		.move
.ck_z
	P_IFSAME	tx,2,.next_fl
	P_IMPORT	pword1,Player1_worldz
	P_IFSMALLER	pword1,oz,.next_fl
	P_IFLARGER	pword1,childx,.next_fl
	P_SET		pbyte2,80		;x_offset
	P_ZERO		pbyte1			;z_offset
.move
	P_IMPORT	pword1,Player1_worldx
	P_NEG		pword1
	P_ADD		pword1,worldx
	P_IFSMALLER	pword1,childy,.on_left		;childy = 0
	P_NEG		pbyte2
.on_left
	P_IMPORT	pword1,Player1_worldz
	P_NEG		pword1
	P_ADD		pword1,worldz
	P_IFSMALLER	pword1,childy,.in_front		;childy = 0
	P_NEG		pbyte1
.in_front
	P_SOUNDEFTPOS	ob_toge_slide	;$77*
	P_DO		10
	P_ADD		worldx,pbyte2
	P_ADD		worldz,pbyte1
	P_NEXT
	P_NEG		pbyte1
	P_NEG		pbyte2
	P_DO		2
	P_DIV2		pbyte1
	P_DIV2		pbyte2
	P_INEXT
;	P_DIV2		pbyte1
;	P_DIV2		pbyte2
;	P_DIV2		pbyte1
;	P_DIV2		pbyte2
	P_WAIT		30

	P_DO		40
	P_ADD		worldx,pbyte2
	P_ADD		worldz,pbyte1
	P_NEXT
	P_WAIT		30
.next_fl
	P_GOTO		.lp
;;;;------------
	START_PATH	e_kao_man
	
	P_GOSUB		set_child_xyz
	P_CLIPPING	ON
.kao_start
	P_CLEARSTACK
	P_SETCOLANIM	3
	P_RADAROBJ	ra_off
	P_GOSUB		init_notinvslope
	P_SHADOW	OFF
	P_INVINCIBLE	OFF
	P_RTRIGGER	.kao_work_trig,WhenHitByPlayer
	P_END

.kao_work_trig
	P_HITFLASHTRIG
	P_IFNOTSAME	worldy,40,.not_medal
	P_SET		childy,39
	P_GSET		b,gbyte1,43h
	P_GOSUB		set_medal
	P_BECOME
	P_ADD		worldy,-100
	P_UNBECOME
.not_medal
	P_FORCE		.kao_work
	P_RETURN
.kao_work
	P_TRIGGER	.kao_work_trig,OFF
	P_ZERO		colframe
	P_RADAROBJ	ra_enemy
	P_SHADOW	ON
	P_INVINCIBLE	ON
	P_SET		hp,100

	P_GOSUB		.to_on_g

	P_DO		2
	   P_DO		20
	      P_FACEPLAYER	y
	   P_NEXT

	   P_ZERO		pbyte1

	   P_SOUNDEFTDISTPOS	en_jump1_L	;$58

	   P_DO			19
	   P_AUTOINDEX		b,worldy,jumptab,pbyte1,20
	   P_IMPORT		ox,Player1_worldx
	   P_IMPORT		oz,Player1_worldz
	   P_CHASE		worldx,ox
	   P_CHASE		worldz,oz
	   P_NEXT

	   P_COLLISIONS		ON
	   P_WAIT		1

	   P_SET		worldy,childy

	   P_GOSUB		.kao_shock
	   P_WAIT		15

	   P_COLLISIONS		OFF
	   P_GOSUB		.to_on_g

	P_NEXT

	P_WAIT		15

	P_ZERO		pbyte1
	P_RTRIGGER	.kao_roty,Always
	P_SOUNDEFTDISTPOS	en_jump1_L	;$58
.kao_go_home
	P_CHASE		worldx,childx
	P_CHASE		worldz,childz
	P_AUTOINDEX	B,worldy,jumptab,pbyte1,20
	P_IFNOTZERO	pbyte1,.kao_go_home_again
	P_GOSUB		.kao_shock
	P_WAIT		10
	P_SOUNDEFTDISTPOS	en_jump1_L	;$58
.kao_go_home_again
	P_IFNOTSAME	childx,worldx,.kao_goto_home
	P_IFSAME	childz,worldz,.kao_posok
.kao_goto_home
	P_GOTO		.kao_go_home
.kao_posok
	P_AUTOINDEX	B,worldy,jumptab,pbyte1,20
	P_IFZERO	pbyte1,.kao_in_home
	P_GOTO		.kao_posok
.kao_in_home
	P_SOUNDEFTDISTPOS	en_jump1_L	;$58
	P_GOSUB		.kao_shock
	P_SET		worldy,childy

	P_TRIGGER	.kao_roty,OFF
	P_IGOTO		.kao_start
.kao_roty
	P_ADD		roty,16
	P_RETURN
.to_on_g
	P_RTRIGGER	.kao_up_sound,2
	P_DO		8
	P_ADD		worldy,-7
	P_WAIT		1
	P_ADD		worldy,4
	P_NEXT
.to_on_g2
	P_ADD		worldy,-8
	P_IFBETWEEN	-127,worldy,0,.on_g
	P_GOTO		.to_on_g2
.on_g
	P_ZERO		worldy
	P_TRIGGER	.kao_up_sound,OFF
	P_RETURN
.kao_up_sound
	P_SOUNDEFTNEARPOS	ob_moai_move	;$a3
	P_RETURN
.kao_shock
	P_IFARWING	.kao_no_shock
	P_SHOCKCAM	1,128
.kao_no_shock
	P_SOUNDEFTNEARPOS	en_land_L	;$76
	P_RETURN
;;;;------------
	START_PATH	e_round_dosun

	P_INC		skidy
	P_ALWAYSGENVECS	ON
	P_IFSAME	roty,128,.neg
	P_ADD		worldx,1000
	P_IGOTO		.same
.neg
	P_ADD		worldx,-1000
.same
;------------
	START_PATH	e_dosun

	P_GOSUB		init_hardslope
	P_SET		childy,worldy
	P_RADAROBJ	ra_enemy

.again_r
	P_RTRIGGER	.hit_down,WhenHitByPlayer
	P_IFZERO	skidy,.again
	P_RTRIGGER	.round_kao,Always
;	P_RTRIGGER	.round_atack,4
	P_SOUND		p2_kaoman
	P_SETVEL	30
.again
	P_WITHINRADIUS	500,.on
	P_GOTO		.again
.on
	P_IMPORT	childx,Player1_worldx
	P_IMPORT	childz,Player1_worldz
	P_NEG		childx
	P_ADD		childx,worldx
	P_IFNOTBETWEEN	-120,childx,120,.not_under
	P_NEG		childz
	P_ADD		childz,worldz
	P_IFNOTBETWEEN	-120,childz,120,.not_under
.hit_down_on
	P_TRIGGER	.hit_down,OFF
	P_TRIGGER	.round_kao,OFF
	P_SOUND		port2_stop
	P_SETVEL	0
	P_SOUNDEFTNEARPOS	en_kaoman_down	;$64
.down
	P_NOTHITGROUND	50,.no_col
	P_COLLISIONS	ON
.no_col
	P_HITGROUND	0,.on_g
	P_ADD		worldy,50
	P_GOTO		.down
.on_g
	P_COLLISIONS	OFF
	P_SHOCKCAM	1,128
	P_SOUNDEFTNEARPOS	en_land_L	;$76
	P_ZERO		worldy
	P_WAIT		20
.down_cont
	P_IFSAME	worldy,childy,.not_under_to
	P_CHASE		worldy,childy
	P_GOTO		.down_cont
.not_under_to
	P_WAIT		10
	P_GOTO		.again_r
.not_under
	P_GOTO		.again

.round_kao
	P_ADD		roty,1
	P_RETURN

.hit_down
	P_FORCE		.hit_down_on
	P_RETURN




;.round_atack
;	P_PLAYERINCONE	10,.atack
;	P_RETURN
;.atack
;	P_SPAWN		0,-50,100,0,0,0,nullshape,e_dosun_fire,100,0,1
;	P_RETURN
;-----------
;	START_PATH	e_dosun_fire
;
;	P_INVISIBLE	ON
;	P_WEAPON	ELaser		;ERing
;	P_GOSUB		sos_fire_must
;	P_REMOVE
;;;;------------
	START_PATH	e_wakidashi_kumo

	P_GOSUB		wakidashi_init
	P_TRIGGER	wakidashi_dead,WhenHit
	P_TRIGGER	kumo_anim,Always
	P_WEAPON	Ering

	P_SET		childroty,roty
.walk_st
	P_RTRIGGER	.atack,64
	P_SETVEL	20
.walk
	P_INC		pbyte1
	P_IFSAME	pbyte1,127,.u_turn
	P_GOTO		.walk
.u_turn
	P_TRIGGER	.atack,OFF
	P_SETVEL	0
	P_GOSUB		.kumo_fire
	P_ADD		childroty,127
	P_ZERO		pbyte1
.u_turn_cont
	P_CHASE		roty,childroty
	P_IFSAME	roty,childroty,.walk_st
	P_GOTO		.u_turn_cont
.atack
	P_FORCE		.atack_on
	P_RETURN
.atack_on
	P_TRIGGER	.atack,OFF
	P_SETVEL	0
	P_GOSUB		.kumo_fire
	P_GOTO		.walk_st
.kumo_fire
	P_SET		childrotx,roty
.rot_more
	P_FACEPLAYER	y
	P_PLAYERINCONE	5,.on
	P_GOTO		.rot_more
.on
;	P_ADD		worldy,-50
;	P_GOSUB		sos_fire_must
;	P_ADD		worldy,50
	P_SPAWN		0,-50,50,0,0,0,ring_mark,e_ring_mark_child,10,10,11
	P_DO		10
	P_FACEPLAYER	y
	P_NEXT
.ret_more
	P_CHASE		roty,childrotx
	P_IFSAME	roty,childrotx,.cant_2
	P_GOTO		.ret_more
.cant_2
	P_RETURN




;;;	START_PATH	e_kumo_target
;;;
;;;	P_INC		skidy
;;;	P_RADAROBJ	ra_enemy
;;;	P_GOSUB		set_hp100_ap4
;;;	P_SET		pword1,worldy
;;;	P_SET		childrotz,roty
;;;	P_SET		worldy,-50
;;;	P_TRIGGER	kumo_anim,Always
;;;	P_TRIGGER	.kumo_dead,WhenHit		;Dead
;;;	P_WEAPON	Eplasma1
;;;	P_RANGECHECK	OFF
;;;
;;;	P_SET		childroty,roty
;;;.walk_st
;;;	P_TRIGGER	.atack,64
;;;	P_SETVEL	20
;;;.walk
;;;	P_INC		pbyte1
;;;	P_IFSAME	pbyte1,127,.u_turn
;;;	P_GOTO		.walk
;;;.u_turn
;;;	P_TRIGGER	.atack,OFF
;;;	P_SETVEL	0
;;;	P_GOSUB		.kumo_fire
;;;	P_ADD		childroty,127
;;;	P_ZERO		pbyte1
;;;.u_turn_cont
;;;	P_CHASE		roty,childroty
;;;	P_IFSAME	roty,childroty,.walk_st
;;;	P_GOTO		.u_turn_cont
;;;.atack
;;;	P_BEHINDKPLAYER	.cant
;;;	P_FORCE		.atack_on
;;;.cant
;;;	P_RETURN
;;;.atack_on
;;;	P_TRIGGER	.atack,OFF
;;;	P_SETVEL	0
;;;	P_GOSUB		.kumo_fire
;;;	P_GOTO		.walk_st
;;;.kumo_fire
;;;	P_SET		childrotx,roty
;;;	P_BEHINDKPLAYER	.cant_2
;;;.rot_more
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	5,.on
;;;	P_GOTO		.rot_more
;;;.on
;;;	P_ADD		worldy,-50
;;;	P_GOSUB		immed_fire
;;;	P_ADD		worldy,50
;;;	P_ZERO		rotx
;;;.ret_more
;;;	P_CHASE		roty,childrotx
;;;	P_IFSAME	roty,childrotx,.cant_2
;;;	P_GOTO		.ret_more
;;;.cant_2
;;;	P_RETURN
;;;
;;;.kumo_dead
;;;	P_SCORE		sc_kumo
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.atack,OFF
;;;	P_TRIGGER	.kumo_dead,OFF
;;;	P_IGOTO		final_enemy_demo
;;;;-----------
	START_PATH	e_wakidashi_helico

	P_GOSUB		wakidashi_init
	P_TRIGGER	wakidashi_dead,WhenHit
	P_TRIGGER	fly_wave,Always
	P_RTRIGGER	.sl_ck,Always
	P_SET		tx,4
	P_SET		ty,4
	P_WEAPON	Elaser
	P_SOUND		p2_zako_2
	P_QUADVECS	ON

.atack_again
	P_FACEPLAYER	IMMEDIATE
	P_ZERO		rotx
	P_SETVEL	25
.again
	P_FACEPLAYER	y
	P_DISTLESS	1000,.atack
	P_GOTO		.again
.atack
	P_SETVEL	0

	P_DO		3
	P_GOSUB		sos_fire_must
	P_WAIT		16
	P_NEXT

	P_SETVEL	25
	P_SET		slopenum,127
.atack_wait
	P_DEC		slopenum
	P_IFZERO	slopenum,.atack_againa
	P_DISTMORE	2500,.atack_againa
	P_GOTO		.atack_wait
.atack_againa
	P_SETVEL	0
	P_WAIT		40
	P_GOTO		.atack_again
	
.sl_ck
	P_HITSLOPE	wakidashi_dead_no_sc
	P_RETURN
;------------
;;;	START_PATH	e_helico_target
;;;
;;;	P_SET		skidy,roty
;;;	P_RADAROBJ	ra_enemy
;;;	P_SOUND		p2_zako_2
;;;	P_GOSUB		set_hp100_ap4
;;;	P_WEAPON	Elaser
;;;	P_RANGECHECK	OFF
;;;	P_GOSUB		set_child_xyz
;;;	P_TRIGGER	.set_wy,Always
;;;	P_TRIGGER	.heli_dead,WhenHit		;Dead
;;;.atack_again
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SETVEL	30
;;;	P_RELTOPLAYER	ON
;;;.again
;;;	P_FACEPLAYER	y
;;;	P_DISTLESS	600,.atack
;;;	P_GOTO		.again
;;;.atack
;;;	P_SETVEL	0
;;;	P_IMPORT	ox,Player1_worldx
;;;	P_NEG		ox
;;;	P_ADD		ox,worldx
;;;	P_IMPORT	oz,Player1_worldz
;;;	P_NEG		oz
;;;	P_ADD		oz,worldz
;;;
;;;	P_DO		4
;;;	P_DO		32
;;;	P_COPYPLAYERPOS
;;;	P_ADD		worldx,ox
;;;	P_ADD		worldz,oz
;;;	P_SET		worldy,childy
;;;	P_FACEPLAYER
;;;	P_NEXT
;;;	P_FIRE
;;;	P_NEXT
;;;
;;;	P_RELTOPLAYER	OFF
;;;	P_SET		pbyte1,127
;;;.atack_wait
;;;	P_DEC		pbyte1
;;;	P_IFZERO	pbyte1,.atack_again
;;;	P_DISTMORE	1800,.atack_again
;;;	P_GOTO		.atack_wait
;;;.set_wy
;;;	P_SET		worldy,childy
;;;	P_RETURN
;;;.heli_dead
;;;	P_SCORE		sc_heli
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.heli_dead,OFF
;;;	P_IGOTO		final_enemy_demo
;;;;------------
	START_PATH	e_guru2_bar

	P_RANGECHECK	ON
	P_SET		pbyte2,4
	P_IFZERO	roty,.pass
	P_NEG		pbyte2
.pass
	P_SET		hp,20
	P_SET		childrotx,hp
	P_SET		ap,4
	P_SHADOW	OFF
	P_SOUND		p2_guru2bar
	P_RTRIGGER	.guru2_rot,Always
.restart
	P_RTRIGGER	.guru2_hit,WhenHitByPlayer
	P_END
.guru2_hit
	P_IFHITFLAG	.guru2_nojump,1
	P_FORCE		.guru2_j_on
	P_SET		childrotx,hp
.guru2_nojump
	P_SET		hp,childrotx
	P_RETURN
.guru2_j_on
	P_TRIGGER	.guru2_hit,OFF
	P_COLLISIONS	OFF
	P_ZERO		pbyte1
	P_SET		tx,20
	P_DO		2
	P_DO		tx
	P_AUTOINDEX	B,worldy,jumptab,pbyte1,20
	P_NEXT
	P_SOUNDEFTPOS	ob_bunsoft_L	;$ba
	P_SET		tx,10
	P_SET		pbyte1,5
	P_NEXT

	P_COLLISIONS	ON
	P_GOTO		.restart
.guru2_rot
	P_ADD		roty,pbyte2
	P_RETURN

;;;;------------
	START_PATH	e_hana_hou

	P_GOSUB		wakidashi_init
	P_TRIGGER	wakidashi_dead,WhenHit
	P_WEAPON	ERing
	P_SETANIM	0
	P_GOTO		.fire_loop2
.fire_loop
	P_SETANIM	0
.fire_loop2
	P_FACEPLAYER	y
	P_PLAYERINCONE	5,.fire_on
	P_GOTO		.fire_loop2
.fire_on
	P_DO		7
	P_ADDANIM	1,8
	P_NEXT
	P_WAIT		2
	P_ADD		worldy,-80
	P_GOSUB		sos_fire_must
	P_ADD		worldy,80
	P_WAIT		2
	P_DO		7
	P_ADDANIM	-1,8
	P_NEXT
	P_WAIT		5
.fire_pass
	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,31
	P_DO		pbyte1
	P_NEXT
	P_GOTO		.fire_loop

;;;	P_SET		hp,2
;;;	P_SET		ap,4
;;;	P_RADAROBJ	ra_honmei
;;;	P_WEAPON	Eplasma1
;;;	P_TRIGGER	.flower_dead,WhenDead
;;;.fire_loop
;;;	P_SETANIM	0
;;;	P_TRIGGER	.flower_act,64
;;;	P_END
;;;.flower_act
;;;	P_FORCE		.fire_loop_st
;;;	P_RETURN
;;;.fire_loop_st
;;;	P_TRIGGER	.flower_act,OFF
;;;.fire_loop2
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	5,.fire_on
;;;	P_GOTO		.fire_loop2
;;;.fire_on
;;;	P_BEHINDKPLAYER	.fire_pass
;;;	P_DO		7
;;;	P_ADDANIM	1,8
;;;	P_NEXT
;;;	P_WAIT		2
;;;	P_ADD		worldy,-80
;;;	P_GOSUB		immed_fire
;;;	P_ZERO		rotx
;;;	P_ADD		worldy,80
;;;	P_WAIT		2
;;;	P_DO		7
;;;	P_ADDANIM	-1,8
;;;	P_NEXT
;;;	P_WAIT		5
;;;.fire_pass
;;;	P_GOTO		.fire_loop
;;;
;;;.flower_dead
;;;	P_SCORE		sc_hana_hou
;;;	P_RETURN
;;;;------------
	START_PATH	e_wakidashi_cyou

	P_GOSUB		wakidashi_init
	P_TRIGGER	anim_add_12,Always
	P_TRIGGER	wakidashi_dead,WhenHit
	P_RTRIGGER	.cyou_fire,16
	P_WEAPON	Elaser
	P_SOUND		p2_zako_0

	P_RTRIGGER	.keep_hi,ALways

	P_QUADVECS	ON
	P_SETVEL	15
.lp
	P_FACEPLAYER
	P_DISTLESS	1000,.cyokushin
	P_GOTO		.lp
.cyokushin
	P_WAITCHASE	rotx,0
.mada
	P_WAIT		10
	P_PLAYERINCONE	32,.mada

	P_WAIT		20
	P_SPACESHIP	ON
	P_GOSUB		decide_angle_slonum
	P_GOSUB		slonum_rz_waitchase
.more
	P_PLAYERINCONE	5,.lock
	P_GOTO		.more
.lock
	P_SPACESHIP	OFF
	P_WAITCHASE	rotz,0
	P_GOTO		.lp
.keep_hi
	P_HITSLOPE	wakidashi_dead_no_sc
	P_SET		pword1,-150
	P_IFSMALLER	worldy,pword1,.hi_ok
	P_SET		worldy,-150
.hi_ok
	P_RETURN
.cyou_fire
	P_PLAYERINCONE	10,.attack
	P_RETURN
.attack
	P_GOSUB		sos_fire_must
	P_RETURN
	
;;;	START_PATH	e_cyoucyou_target
;;;
;;;	P_SET		skidy,roty
;;;	P_TRIGGER	marker_set,Always
;;;	P_GOSUB		set_hp100_ap4
;;;	P_ALWAYSGENVECS	ON
;;;	P_RANGECHECK	OFF
;;;	P_WEAPON	RelElaser
;;;	P_SET		childy,-200
;;;	P_TRIGGER	anim_add_12,Always
;;;	P_TRIGGER	.hi_ck,Always
;;;	P_TRIGGER	.zaco_dead,WhenHit		;Dead
;;;
;;;	P_INVISIBLE	ON
;;;.wait_loop
;;;	P_FINDSHAPE	center_p		;eisei_1
;;;	P_SHAPEDEAD	.wait_cyou
;;;	P_IGOTO		.start
;;;.wait_cyou
;;;	P_GOTO		.wait_loop
;;;.start
;;;	P_INVISIBLE	OFF
;;;	P_RADAROBJ	ra_enemy
;;;	P_SOUND		p2_zako_0
;;;	P_SETVEL	50
;;;.come
;;;	P_TRIGGER	.atack_ck,Always
;;;.come_on
;;;	P_FACESHAPE
;;;	P_SHAPEDISTLESS	1000,.again
;;;	P_GOTO		.come_on
;;;.again
;;;	P_DO		15
;;;	P_FACESHAPE
;;;	P_NEXT
;;;
;;;	P_SETRANDOM	pbyte2,3
;;;	P_IFZERO	pbyte2,.again
;;;.step_2
;;;	P_WAIT		30
;;;
;;;	P_DO		64
;;;	P_ADD		rotx,-4
;;;	P_NEXT
;;;
;;;	P_ZERO		pbyte1
;;;	P_GOTO		.again
;;;.hi_ck
;;;	P_IFSMALLER	worldy,childy,.hi_ok
;;;	P_SET		worldy,childy
;;;.hi_ok
;;;	P_RETURN
;;;.atack_ck
;;;	P_IFNOTZERO	pbyte1,.cant_atack
;;;	P_FORCE		.atack_on
;;;.cant_atack
;;;	P_RETURN
;;;.atack_on
;;;	P_TRIGGER	.atack_ck,OFF
;;;.act_1
;;;	P_FACEPLAYER
;;;	P_WITHINRADIUS	1000,.act_2
;;;	P_SHAPEDISTLESS	2500,.cont
;;;	P_IGOTO		.act_2
;;;.cont
;;;	P_INC		pword1
;;;	P_IFSAME	pword1,100,.act_2
;;;	P_GOTO		.act_1
;;;.act_2
;;;	P_ZERO		pword1
;;;	P_ACCEL		0,4
;;;	P_DO		20
;;;	P_FACEPLAYER
;;;	P_NEXT
;;;	P_BEHINDKPLAYER	.act_3
;;;	P_FIRE
;;;.act_3
;;;	P_INC		pbyte1
;;;	P_ACCEL		50,4
;;;	P_GOTO		.come
;;;
;;;.zaco_dead
;;;	P_SCORE		sc_cyou_zaco
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.atack_ck,OFF
;;;	P_TRIGGER	.zaco_dead,OFF
;;;	P_IGOTO		final_enemy_demo
;;;;------------
	START_PATH	e_wakidashi_iwashi

	P_SOUND		p2_iwashi_0l
	P_SHADOW	OFF
	P_GOSUB		wakidashi_init
	P_WEAPON	ELaser
	P_SET		ox,-800
	P_SET		oy,-70
	P_GOSUB		sea_init_below_canhit

	P_TRIGGER	fly_wave,Always
	P_SET		tx,4
	P_SET		ty,4
	P_TRIGGER	wakidashi_dead,WhenHit		;Dead
	P_RTRIGGER	.iwashi_hi_ck,Always
.re_st
	P_RTRIGGER	.iwashi_atack,64
	P_RTRIGGER	.iwashi_circle,Always
	P_RTRIGGER	.iwashi_slow,2
	P_SET		childrotx,64
	P_SET		slopenum,-5
	P_SET		childroty,1
	P_RANDOMGOTO	.neg
	P_NEG		childrotx
	P_NEG		slopenum
	P_NEG		childroty
.neg
	P_SET		childrotz,slopenum
	P_RTRIGGER	.quick,32
	P_END
.quick
	P_RANDOMGOTO	.nq
	P_SET		slopenum,childrotz
.nq
	P_RETURN
.iwashi_atack
	P_RANDOMGOTO	.cant_fire
	P_IMPORT	pword1,Player1_worldy
	P_IFNOTBETWEEN	-800,pword1,0,.cant_fire
	P_FORCE		.atack
.cant_fire
	P_RETURN
.atack
	P_TRIGGER	.iwashi_atack,OFF
	P_TRIGGER	.iwashi_circle,OFF
	P_TRIGGER	.iwashi_slow,OFF
	P_SETVEL	40
	P_ACCEL		0,2
.face
	P_FACEPLAYER
	P_IFZERO	vel,.fire
	P_GOTO		.face
.fire
	P_DO		3
	P_GOSUB		sos_fire_must
	P_DO		5
	P_FACEPLAYER
	P_NEXT
	P_NEXT
	P_GOTO		.re_st
.iwashi_circle
	P_CIRCLEPLAYER	slopenum
	P_FACEPLAYER	IMMEDIATE
	P_ZERO		rotx
	P_ADD		roty,childrotx
	P_RETURN

.iwashi_slow
	P_IFBETWEEN	-2,slopenum,1,.pass
	P_ADD		slopenum,childroty
.pass
	P_RETURN

.iwashi_hi_ck
	P_HITSLOPE	wakidashi_dead_no_sc
	P_IFSMALLER	worldy,ox,.too_hi
	P_IFSMALLER	worldy,oy,.hi_ok
	P_SET		worldy,oy
	P_RETURN
.too_hi
	P_SET		worldy,ox
.hi_ok
	P_RETURN

;;;	START_PATH	e_iwashi_target
;;;
;;;	P_GOSUB		set_child_xyz
;;;
;;;	P_SOUND		p2_iwashi_0l
;;;	P_SHADOW	OFF
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_SET		ox,-800
;;;	P_SET		oy,-70
;;;	P_SET		skidy,roty
;;;	P_GOSUB		sea_init_below_canhit
;;;
;;;	P_TRIGGER	.iwashi_dead,WhenHit		;Dead
;;;	P_TRIGGER	.iwashi_hi_ck,Always
;;;
;;;.again
;;;	P_SETVEL	40
;;;	P_ACCEL		10,1
;;;	P_WAIT		35
;;;	P_GOSUB		.fish_home_ck
;;;	P_RANDOMGOTO	.no_atack
;;;	P_INPLAYERSCONE	-15,15,.atack
;;;.no_atack
;;;	P_GOSUB		pe_kozakana.mk_fish_move
;;;	P_DO		6
;;;	P_CHASE		roty,childroty
;;;	P_CHASE		rotx,childrotx
;;;	P_NEXT
;;;	P_GOTO		.again
;;;.atack
;;;	P_DO		16
;;;	P_FACEPLAYER
;;;	P_NEXT
;;;	P_SETVEL	40
;;;	P_WAIT		20
;;;	P_GOTO		.again
;;;	P_END
;;;.fish_home_ck
;;;	P_GOSUB		put_marker
;;;	P_EXPORT	gword3,childy
;;;	P_BECOME
;;;	P_FINDSHAPE	iwashi_0m
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldy,gword3
;;;	P_IMPORT	worldz,gword2
;;;	P_UNBECOME
;;;	P_SHAPEDISTLESS	1500,.fish_home_near
;;;
;;;	P_ACCEL		40,2
;;;.back_loop
;;;	P_FACESHAPE
;;;	P_SHAPEDISTLESS	100,.fish_home_near
;;;	P_GOTO		.back_loop
;;;.fish_home_near
;;;	P_FLAGSHAPE
;;;	P_RETURN
;;;.iwashi_hi_ck
;;;	P_IFSMALLER	worldy,ox,.too_hi
;;;	P_IFSMALLER	worldy,oy,.hi_ok
;;;	P_SET		worldy,oy
;;;	P_RETURN
;;;.too_hi
;;;	P_SET		worldy,ox
;;;.hi_ok
;;;	P_RETURN
;;;
;;;.iwashi_dead
;;;	P_SCORE		sc_iwashi_target
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.iwashi_dead,OFF
;;;	P_IGOTO		final_enemy_demo
;;;;ษออออออออออออออออออออออป
;;;;บ STEP_UP TARGET ENEMY บ
;;;;ศออออออออออออออออออออออผ
arm_length	=	2
	START_PATH	e_step_hydra

	P_SET		skidy,hp
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_ENEMYDMGSE	en_cry_3
	P_RTRIGGER	.live_ck,WhenHit
	P_SET		childrotz,3
	P_SET		childrotx,16
	P_GOSUB		set_hp100_ap4_enemy
	P_SET		hp,127
	P_SETBOSSNAME	name_fantron
	P_GOSUB		enemy_hp_meter_hydra

	P_GOSUB		.mk_damy_arm

	P_QUADVECS	ON
	P_SETVEL	junko_speed

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_stepup_0	;0E

;	P_SET		pbyte1,hp
.wlp
;	P_DISTLESS	5000,.run_1
;	P_IFNOTSAME	pbyte1,hp,.run_1
;	P_SET		pbyte1,hp
;	P_GOTO		.wlp
.run_1
	P_IGOTO		.bat_wait2
;	P_IMPORT	pbyte1,KEnemyNumber
;	P_IFBETWEEN	0,pbyte1,2,.bat_wait2
;;;	P_FLAGCHILD	11
;;;	P_FLAGCHILD	12
;;;	P_WAIT		5
;;;
;;;	P_SETVEL	60
;;;	P_BECOMECHILD	11
;;;	P_SET		tx,120
;;;	P_UNBECOME
;;;	P_BECOMECHILD	12
;;;	P_SET		tx,120
;;;	P_UNBECOME
;;;	P_FLAGCHILD	11
;;;	P_FLAGCHILD	12
;;;.runrun
;;;	P_DISTMORE	23000,eg_remove
;;;	P_GOTO		.runrun

;	P_ZERO		pbyte1
;.fw
;;	P_INC		pbyte1
;;	P_PRINT		pbyte1,d,eguchi
;;	P_IFSAME	pbyte1,150,.far_ok
;	P_DISTMORE	15000,.far_ok
;	P_GOTO		.fw
;.far_ok
;	P_SETVEL	12
;	P_BECOMECHILD	11
;	P_SET		tx,40
;	P_UNBECOME
;	P_BECOMECHILD	12
;	P_SET		tx,40
;	P_UNBECOME
;	P_GOTO		.wlp

.mk_damy_arm	LOCAL
	P_SPAWN		280,0,0,0,0,0,stepup_1,e_damy_arm,100,2,9
	P_SPAWN		-280,0,0,0,0,0,stepup_1,e_damy_arm,100,2,10
	P_SPAWN		280,0,-450,0,0,0,boost,e_sp_boost,10,40,11
	P_SPAWN		-280,0,-450,0,0,0,boost,e_sp_boost,10,40,12
	P_RETURN
.colli_on
	P_COLLISIONS	ON
	P_RETURN
.live_ck
	P_TRIGGER	.colli_on,Timer,4
	P_COLLISIONS	OFF
	P_SET		slopenum,40
	P_IFLARGER	hp,slopenum,.live_ok
	P_TRIGGER	.recov_hp,OFF
	P_FORCE		.hyd_down
.live_ok
	P_RETURN
.hyd_down
	P_TRIGGER	.live_ck,OFF
	P_TRIGGER	.chase_face,OFF
	P_TRIGGER	.chase_hi,OFF
	P_TRIGGER	.atack_rot,OFF
	P_REMOVE	11
	P_REMOVE	12

	P_RTRIGGER	.d_cont,ALways
	P_SOUNDEFTPOS	en_death_3	;$7c
	P_CLRDEMOSHAPE
	P_SCORE		sc_stepup_hydra
	P_GOSUB		dec_EEnemyNumber_skidy
	P_GDEC		b,KEnemyNumber
	P_SCREENFLASH

	P_TRIGGER	kani_explode_big,4
	P_DO		10
	P_ADD		rotx,2
	P_ADD		rotz,-2
	P_NEXT
	P_WAIT		10
	P_GOSUB		group_explode
	P_SCREENFLASH
	P_GOSUB		many_exp_group
	P_CIRCLEWINDOW	1,big			;50
	P_GSET		b,bossmaxhp,0
	P_EXPLODE
.d_cont
	P_ADD		worldy,20
	P_RETURN
.battle_start
;	P_RTRIGGER	.come_dist,ALways
	P_RELTOPLAYER	ON
	P_SOUND		port2_stop	;00
	P_ACCEL		0,3
;;;;	P_RELTOPLAYER	ON
;;;;	P_GOSUB		.make_chase_pos
;;;;	P_TRIGGER	.chase_face,Always
	P_WAITCHASE	rotz,0
	P_FLAGCHILD	11
	P_FLAGCHILD	12

	P_FLAGCHILD	9
	P_FLAGCHILD	10
	P_DO		16
	P_CHASE		rotx,0
	P_CHASE		rotz,0
	P_NEXT
	P_ZERO		rotx
	P_ZERO		rotz
;-----------
	P_SPAWN		280,0,0,0,0,0,stepup_2,e_hyd_arm,100,1,1
	P_SPAWN		-280,0,0,0,0,0,stepup_2,e_hyd_arm,100,2,2

	P_WAIT		3

	P_BECOMECHILD	9
	P_INVISIBLE	ON
	P_UNBECOME
	P_BECOMECHILD	10
	P_INVISIBLE	ON
	P_UNBECOME

	P_SET		pbyte1,1
	P_GOSUB		.com_hand

	P_DO		8
	P_BECOMECHILD	1
	P_ADD		childroty,8
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childroty,-8
	P_UNBECOME
	P_NEXT

	P_WAIT		8


;-----ARM NOBIRU

	P_SET		tx,arm_length
.nobi
	P_ZERO		pbyte1
	P_DO		6
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ADDANIM	1,8
	P_UNBECOME
	P_INEXT

	P_DO		3
	 P_ZERO		pbyte1
	 P_DO		8
	  P_INC		pbyte1
	  P_BECOMECHILD	pbyte1
	   P_ADD		pbyte2,-3
	  P_UNBECOME
	 P_INEXT
	P_NEXT

	P_WAIT		1

	P_ZERO		pbyte1
	P_DO		8
	 P_INC		pbyte1
	 P_BECOMECHILD	pbyte1
	  P_ADD		pbyte2,-1
	 P_UNBECOME
	P_INEXT

	P_WAIT		1
	P_DEC		tx
	P_IFNOTZERO	tx,.nobi
;------------
;;;;	P_TRIGGER	.come_dist,ALways
;;;;	P_TRIGGER	.chase_face,OFF
.wave_again
	P_GOSUB		.make_chase_pos
	P_SET		pbyte1,2
	P_GOSUB		.com_hand

	P_RTRIGGER	.chase_face,Always

	P_DO		8
	P_DISTLESS	2000,.pass_c
	P_MOVEINPLAYER	100
.pass_c
	P_NEXT

	P_SETRANDOM	pbyte1,3

	P_IFSAME	pbyte1,1,.pachin
	P_IFSAME	pbyte1,2,.genko
	P_IFSAME	pbyte1,3,.spin
;---------
	P_GOSUB		.arm_front
	P_TRIGGER	.chase_rotx_arm,Always
	P_WAIT		4
	P_SET		pbyte1,2
	P_GOSUB		.com_hand
	P_WAIT		15
	P_TRIGGER	.chase_face,OFF
	P_TRIGGER	.chase_rotx_arm,OFF
	P_WAIT		10
	P_GOSUB		.pachin_long
	P_WAIT		5
	P_GOSUB		.motono_nagasa
	P_GOSUB		.arm_back
	P_BECOMECHILD	1
	P_ZERO		childrotx
	P_UNBECOME
	P_BECOMECHILD	2
	P_ZERO		childrotx
	P_UNBECOME
	P_IGOTO		.atack_end2
;---------
.chase_face
	P_CHASE		rotz,0
	P_FACEPLAYER
	P_FACEPLAYER
	P_CHASE		worldy,childy
;	P_CHASE		worldx,childx		;test
;	P_CHASE		worldz,childz		;test
	P_RETURN
;---------
.spin
	P_GOSUB		.pachin_long
	P_TRIGGER	.chase_face,OFF
	P_RTRIGGER	.chase_hi,Always
	P_SET		pbyte1,4
	P_GOSUB		ran_neg_pb1
	P_DO		10
	P_ADD		roty,pbyte1
	P_NEXT
	P_WAIT		6
	P_RTRIGGER	.atack_rot,Always
	P_NEG		pbyte1
	P_SET		ty,pbyte1
	P_DIV2		ty	
	P_DIV2		ty
	P_SET		pbyte1,ty
	P_DO		20
	P_ADD		pbyte1,ty
	P_NEXT
	P_WAIT		30
	P_NEG		ty
	P_DO		20
	P_ADD		pbyte1,ty
	P_NEXT

	P_TRIGGER	.atack_rot,OFF
	P_GOSUB		.motono_nagasa
	P_TRIGGER	.chase_hi,OFF
	P_GOTO		.atack_end
;---------
.atack_rot
	P_PUSH		pbyte1
	P_DIV2		pbyte1
	P_DIV2		pbyte1
	P_CIRCLEPLAYER	pbyte1
	P_PULL		pbyte1
	P_CHASE		rotx,0
	P_ADD		roty,pbyte1
	P_PLAYERINCONE	53,.nos
	P_PLAYERINCONE	75,.sou
	P_RETURN
.sou
	P_SOUNDEFTDISTPOS	en_throw_2	;$84*
.nos
	P_RETURN
;---------
.chase_hi
	P_IMPORT	childy,Player1_worldy
	P_CHASE		worldy,childy
	P_RETURN
;---------
.genko
	P_TRIGGER	.chase_face,OFF
	P_GOSUB		.chase_rotx_arm
	P_GOSUB		.pachin_long
	P_SET		pbyte1,5
	P_GOSUB		ran_neg_pb1
	P_DO		16
	P_GOSUB		.u1u2
	P_ADD		roty,pbyte1		;-5	;5
	P_ADD		rotx,-2
	P_NEXT

	P_BECOMECHILD	1
	P_ADD		childroty,64
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childroty,-64
	P_UNBECOME
	P_NEG		pbyte1
;;;
	P_DO		8
	P_DO		2
	P_GOSUB		.d1d2
	P_ADD		roty,pbyte1		;5	;-5
	P_ADD		rotx,2
	P_INEXT
	P_NEXT

	P_SOUNDEFTDISTPOS	en_throw_2	;$84*
	P_WAIT		1

	P_DO		8
	P_DO		2
	P_GOSUB		.d1d2
	P_ADD		roty,pbyte1		;5	;-5
	P_ADD		rotx,2
	P_INEXT
	P_NEXT
;;;
	P_BECOMECHILD	1
	P_ADD		childroty,-64
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childroty,64
	P_UNBECOME

	P_DO		16
	P_GOSUB		.u1u2
	P_BECOMECHILD	1
	P_CHASE		childrotx,0
	P_UNBECOME
	P_BECOMECHILD	2
	P_CHASE		childrotx,0
	P_UNBECOME
	P_ADD		roty,pbyte1		;-5	;5
	P_ADD		rotx,-2
	P_NEXT
	P_GOSUB		.motono_nagasa

	P_BECOMECHILD	1
	P_ZERO		childrotx
	P_UNBECOME
	P_BECOMECHILD	2
	P_ZERO		childrotx
	P_UNBECOME

	P_GOTO		.atack_end2
;-----------
.pachin
	P_GOSUB		.pachin_long
	P_TRIGGER	.chase_face,OFF
	P_TRIGGER	.chase_rotx_arm,Always
	P_WAIT		10
.pachi_on
	P_SOUNDEFTDISTPOS	en_throw_2	;$84*

	P_GOSUB		.arm_front
	P_SOUNDEFTPOS		en_land_L	;$76
	P_WAIT		5
	P_SOUNDEFTDISTPOS	en_throw_2	;$84*

	P_TRIGGER	.chase_rotx_arm,OFF

	P_GOSUB		.arm_back

	P_BECOMECHILD	1
	P_ZERO		childrotx
	P_UNBECOME
	P_BECOMECHILD	2
	P_ZERO		childrotx
	P_UNBECOME

	P_GOSUB		.motono_nagasa
;------------
.atack_end
	P_TRIGGER	.chase_face,OFF
.atack_end2
	P_RANDOMGOTO	.wave_again

	P_RELTOPLAYER	OFF

	P_DO		8
	P_BECOMECHILD	1
	P_ADD		childroty,-8
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childroty,8
	P_UNBECOME
	P_NEXT

;-------ARM CHIJIMU

	P_SET		tx,arm_length
.chijimi
	P_DO		3
	P_ZERO		pbyte1
	P_DO		8
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ADD		pbyte2,3
	P_UNBECOME
	P_INEXT
	P_NEXT

	P_ZERO		pbyte1
	P_DO		8
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ADD		pbyte2,1
	P_UNBECOME
	P_INEXT

	P_SOUNDEFTDISTPOS	en_arm_set	;$0d*

	P_ZERO		pbyte1

	P_DO		6
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ADDANIM	-1,8
	P_UNBECOME
	P_INEXT

	P_WAIT		1
	P_DEC		tx
	P_IFNOTZERO	tx,.chijimi
;------------
	P_REMOVE	1
	P_REMOVE	2
	P_REMOVE	3
	P_REMOVE	4
	P_REMOVE	5
	P_REMOVE	6
	P_REMOVE	7
	P_REMOVE	8
;-----------
	P_BECOMECHILD	9
	P_INVISIBLE	OFF
	P_UNBECOME
	P_BECOMECHILD	10
	P_INVISIBLE	OFF
	P_UNBECOME

	P_FLAGCHILD	9
	P_FLAGCHILD	10

	P_WAIT		10

	P_FLAGCHILD	11
	P_FLAGCHILD	12

	P_IMPORT	slopenum,KDifficulty
	P_IFNOTSAME	slopenum,dif_hard,.no_h
	P_RTRIGGER	.recov_hp,8
.no_h
	P_SOUND		p2_stepup_0	;0E
	P_ACCEL		40,5
;---
	P_NEG		childrotx
	P_SETRANDOM	pbyte2,31
	P_ADD		pbyte2,32
	P_SET		pbyte1,2
	P_GOSUB		ran_neg_pb1
	P_DO		pbyte2
	P_ADD		roty,pbyte1
	P_CHASE		rotx,childrotx
	P_NEXT

	P_WAITCHASE	rotx,0
;---
	P_ACCEL		12,1
.mada
	P_IFSAME	vel,12,.ok
	P_GOTO		.mada
.ok
	P_ZERO		pword1

.bat_wait2
	P_SET		pbyte1,32
	P_GOSUB		ran_neg_pb1
	P_SPACESHIP	ON
	P_DO		15
	P_CHASE		rotz,pbyte1
	P_NEXT
.turn_lock
	P_DISTLESS	13000,.f_cone
	P_SPACESHIP	OFF
	P_FACEPLAYER	y
	P_SETVEL	60
	P_GOTO		.turn_lock
.f_cone
	P_SETVEL	junko_speed
	P_SPACESHIP	ON
	P_PLAYERINCONE	5,.lock_on
	P_GOTO		.turn_lock
.lock_on
	P_ACCEL		60,10
	P_SPACESHIP	OFF
.come_p
	P_CHASE		rotz,0
	P_DISTLESS	10000,.pn
	P_FACEPLAYER	y
	P_IGOTO		.pc
.pn
	P_FACEPLAYER
.pc
	P_DISTLESS	3500,.tbattle_start
	P_GOTO		.come_p
.tbattle_start
	P_TRIGGER	.recov_hp,OFF
	P_IGOTO		.battle_start
.recov_hp
	P_SCORE		1
	P_IFSAME	hp,127,.h_pass
	P_INC		hp
	P_GOSUB		meterhit_hydra
.h_pass
	P_RETURN

;;;;------HYDRA SUB
;-------------
.chase_rotx_arm
	P_PUSH		rotx
	P_PUSH		pbyte1
	P_NEG		rotx
	P_SET		pbyte1,rotx
	P_DIV2		pbyte1
	P_ADD		rotx,pbyte1
	P_EXPORT	etemp,rotx
	P_PULL		pbyte1
	P_PULL		rotx
	P_BECOMECHILD	1
	P_IMPORT	childrotx,etemp
	P_UNBECOME
	P_BECOMECHILD	2
	P_IMPORT	childrotx,etemp
	P_UNBECOME
	P_RETURN
;-------------
;---------
;.come_dist
;	P_DISTMORE	7000,.come_fast
;	P_DISTMORE	2000,.come
;	P_DISTLESS	1500,.to_far
;	P_RETURN
;.to_far
;	P_PUSH		worldy
;	P_IMPORT	worldy,PLayer1_worldy
;	P_MOVEINPLAYER	-100
;	P_PULL		worldy
;	P_RETURN
;.come_fast
;	P_MOVEINPLAYER	100
;	P_MOVEINPLAYER	100
;.come
;	P_MOVEINPLAYER	100
;	P_RETURN
;;;;----
.u1u2
	P_BECOMECHILD	1
	P_ADD		childrotx,4
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childrotx,4
	P_UNBECOME
	P_RETURN
.d1d2
	P_BECOMECHILD	1
	P_ADD		childrotx,-4
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childrotx,-4
	P_UNBECOME
	P_RETURN
;;;;----
.com_hand
	P_EXPORT	gbyte1,pbyte1
	P_BECOMECHILD	7
	P_IMPORT	tx,gbyte1
	P_UNBECOME
	P_BECOMECHILD	8
	P_IMPORT	tx,gbyte1
	P_UNBECOME
	P_FLAGCHILD	7
	P_FLAGCHILD	8
	P_RETURN
;;;;----
;;;;----
.motono_nagasa
	P_IFZERO	tx,.motono_end
	P_DO		tx
	P_ZERO		pbyte1
	P_DO		6
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ADD		pbyte2,10
	P_ADDANIM	-1,8
	P_UNBECOME
	P_INEXT
	P_BECOMECHILD	7
	P_ADD		pbyte2,10
	P_UNBECOME
	P_BECOMECHILD	8
	P_ADD		pbyte2,10
	P_UNBECOME
	P_NEXT
.motono_end
	P_RETURN
;;;;---
.pachin_long
	P_ZERO		tx
;	P_DISTLESS	1000,.this_long
	P_WITHINRADIUS	1000,.this_long
	P_INC		tx
;	P_DISTLESS	1200,.this_long
	P_WITHINRADIUS	1200,.this_long
	P_INC		tx
;	P_DISTLESS	1400,.this_long
	P_WITHINRADIUS	1400,.this_long
	P_INC		tx
;	P_DISTLESS	1600,.this_long
	P_WITHINRADIUS	1600,.this_long
	P_INC		tx
;	P_DISTLESS	1800,.this_long
	P_WITHINRADIUS	1800,.this_long
	P_INC		tx
.this_long
;	P_IFZERO	tx,.pachi_on
	P_IFZERO	tx,.to_pachi_on
	P_SOUNDEFTDISTPOS	ob_arm_punch	;$77*
	P_DO		tx
	P_ZERO		pbyte1
	P_DO		6
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ADD		pbyte2,-10
	P_ADDANIM	1,8
	P_UNBECOME
	P_INEXT
	P_BECOMECHILD	7
	P_ADD		pbyte2,-10
	P_UNBECOME
	P_BECOMECHILD	8
	P_ADD		pbyte2,-10
	P_UNBECOME
	P_NEXT
.to_pachi_on
	P_RETURN
;;;;---
;;;;---
.arm_front
	P_DO		5
	P_DO		2
	P_GOSUB		.f1f2
	P_INEXT
	P_NEXT
	P_GOSUB		.b1b2
	P_RETURN
.arm_back
	P_DO		9
	P_GOSUB		.b1b2
	P_NEXT
	P_RETURN
;;;;---
.b1b2
	P_BECOMECHILD	1
	P_ADD		childroty,-8
	P_CHASE		childrotx,0
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childroty,8
	P_CHASE		childrotx,0
	P_UNBECOME
	P_RETURN
.f1f2
	P_BECOMECHILD	1
	P_ADD		childroty,8
	P_UNBECOME
	P_BECOMECHILD	2
	P_ADD		childroty,-8
	P_UNBECOME
	P_RETURN
;;;;---
.make_chase_pos
	P_PUSH		pbyte1
	P_PUSH		worldz
	P_PUSH		worldy
	P_PUSH		worldx
	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64
	P_CIRCLEPLAYER	pbyte1
	P_SET		childx,worldx
	P_SET		childz,worldz
	P_IMPORT	worldy,Player1_worldy
	P_SETRANDOM	childy,1023
	P_ADD		childy,-512
	P_ADD		childy,worldy
	P_PULL		worldx
	P_PULL		worldy
	P_PULL		worldz
	P_PULL		pbyte1
	P_RETURN
;;;;------------
	START_PATH	e_hyd_arm

	P_ACTIVE	ON
	P_INVINCIBLE	ON
	P_SETANIM	0
	P_SETID		ap
	P_SET		pbyte1,ap
	P_SET		pbyte2,-10
	P_IFSAME	ap,7,.hand
	P_IFSAME	ap,8,.hand
	P_ADD		ap,2
	P_EXPORT	gbyte1,ap
;*************************************************************************
	
	P_SPAWN		0,0,0,0,0,0,stepup_2,e_hyd_arm,100,1,1

	p_start65816
	s_set_objtobevar	y,becomelastobj&WM
	stx			al_immuneptr,y
	p_end65816
;-------------
	P_BECOME
	P_IMPORT	ap,gbyte1
	P_UNBECOME	
;*************************************************************************
	P_SET		coltab,id_1_c&WM
	P_IFSAME	pbyte1,1,.nemoto
	P_IFSAME	pbyte1,2,.nemoto
.same
	P_INVISIBLE	ON
	P_RELATIVE	OFF
	P_RTRIGGER	.arm_wave,Always
	P_WAIT		3
	P_INVISIBLE	OFF
	P_END
.arm_wave
	P_SWAPVAR	immuneptr,ptr
	P_CHAINPOS	pbyte2
	P_SWAPVAR	immuneptr,ptr
	P_RETURN
.nemoto
	P_END
.hand
	P_SET		ap,4
	P_INVINCIBLE	ON
	P_SETANIM	7
	P_SET		shape,stepup_1
	P_RTRIGGER	.hand_com,WhenFlagged
	P_IGOTO		.same
.hand_com
	P_FORCE		.hand_on
	P_RETURN
.hand_on
	P_IFSAME	tx,1,.h_gu_gu
	P_IFSAME	tx,2,.h_q_gu_gu
	P_END
.h_q_gu_gu
	P_DO		3
	P_ADDANIM	-2,8
	P_NEXT
	P_WAIT		1
	P_DO		3
	P_ADDANIM	2,8
	P_NEXT
	P_SOUNDEFTDISTPOS	en_hasami	;$7c
	P_END
.h_gu_gu
	P_DO		7
	P_ADDANIM	-1,8
	P_NEXT
	P_WAIT		1
	P_DO		7
	P_ADDANIM	1,8
	P_NEXT
	P_SOUNDEFTDISTPOS	en_hasami	;$7c
	P_END
;;;;------------
	START_PATH	e_damy_arm

	P_ACTIVE	ON
	P_INVINCIBLE	ON
.pa
	P_SETANIM	0
	P_RTRIGGER	.hand_anm,WhenFlagged
	P_END
.hand_anm
	P_FORCE		.hand_anm_on
	P_RETURN
.hand_anm_on
	P_TRIGGER	.hand_anm,OFF
	P_DO		7
	P_ADDANIM	1,8
	P_NEXT
	P_WAIT		1
	P_DO		7
	P_ADDANIM	-1,8
	P_NEXT
	P_DO		7
	P_ADDANIM	1,8
	P_NEXT
	P_RTRIGGER	.hand_anm2,WhenFlagged
	P_END
.hand_anm2
	P_FORCE		.hand_anm_on2
	P_RETURN
.hand_anm_on2
	P_TRIGGER	.hand_anm2,OFF

	P_DO		8
	P_ADDANIM	-1,8
	P_NEXT
	P_IGOTO		.pa
;;;;ษออออออออออออออออออป
;;;;บ SOS TARGET ENEMY บ
;;;;ศออออออออออออออออออผ
	START_PATH	e_tate_missile

	P_SET		skidy,ap
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_GOSUB		set_hp100_ap4
	P_RADAROBJ	ra_enemy
	P_CLRTYPE	enemy1
	P_SLOPE		ON
	P_COLLISIONS	OFF
	P_INVINCIBLE	ON
	P_TRIGGER	reflect_laser,Always
	P_ALWAYSGENVECS	OFF
	P_GOSUB		mk_toge
;;;;;	P_RTRIGGER	.c_dead,WhenFlagged
	P_RTRIGGER	.r_y,Always
	P_RTRIGGER	.sound,8
	P_QUADVECS	ON
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_SETVEL	junko_speed

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_tate_m_0	;08

	P_IMPORT	pbyte2,KX_NEARPLANETNUM
	P_IFNOTSAME	pbyte2,8,.not_corneria
	P_TRIGGER	st_fall,Timer,250
.not_corneria

	P_RTRIGGER	.too_near,64
	P_RTRIGGER	.put_marker,ALways

	P_SET		pbyte2,64
	P_SET		tx,1
	P_SET		ty,1

	P_ZERO		pword1
	P_IFLARGER	worldy,pword1,.up

	P_SET		pword1,50
	P_IGOTO		.zero_level
.up
	P_SET		pword1,-50
.zero_level
	P_ADD		worldy,pword1
	P_IFBETWEEN	-100,worldy,100,.st
	P_GOTO		.zero_level
.st
	P_SET		tx,2
	P_SET		ty,2
	P_TRIGGER	fly_wave,Always
	P_SET		childrotx,slopenum
.wlp
	P_IFNOTSAME	childrotx,slopenum,.act
	P_GOTO		.wlp
.act
	P_ALWAYSGENVECS	ON
	P_SETVEL	60
.ag
	P_DO		10
	P_ADD		roty,-8
	P_NEXT
	P_RANDOMGOTO	.ag
	P_ALWAYSGENVECS	OFF
	P_SETVEL	junko_speed
	P_SET		childrotx,slopenum
	P_GOTO		.wlp
.r_y
	P_ADD		roty,16
	P_RETURN
;.c_dead
;	P_IFNOTSAME	slopenum,4,.mada
;	P_FORCE		.all_dead
;.mada
;	P_RETURN
.sound
	P_DISTMORE	18000,.no_sou
	P_SOUNDEFTDISTPOS	ob_bun		;$98
.no_sou
	P_RETURN
.all_dead
	P_TRIGGER	fly_wave,OFF
	P_TRIGGER	.put_marker,OFF
	P_TRIGGER	marker_set,Always
	P_SETTYPE	enemy1
	P_ALWAYSGENVECS	ON
	P_COLLISIONS	ON
	P_INVINCIBLE	OFF
	P_SETVEL	junko_speed
	P_SET		hp,100
	P_WAIT		1
	P_ALWAYSGENVECS	OFF
.de_lp
	P_SET		slopenum,95
	P_IFSMALLER	hp,slopenum,.moth_kill
	P_GOTO		.de_lp
.moth_kill
	P_COLLISIONS	OFF
	P_CLRDEMOSHAPE
	P_GOSUB		missile_count
	P_SCORE		sc_enban_m
	P_TRIGGER	senkan_explode,4
	P_SPAWN		0,-70<<tate_m_scale,0,0,0,0,nullshape,e_tate_m_e,100,0,1
	P_SPAWN		0,60<<tate_m_scale,0,0,0,0,nullshape,e_tate_m_e,100,0,2
	P_SCREENFLASH
	P_DO		25
	P_ADD		worldy,10
	P_RANDOMGOTO	.rand_fl
	P_HITFLASHTRIG
.rand_fl
	P_NEXT

	P_TRIGGER	senkan_explode,OFF
	P_SET		shape,tate_m_0big
	P_CIRCLEWINDOW	1,big			;10
	P_EXPLODE

.put_marker
	P_SET		pbyte1,1
	P_CHILDDEAD	1,.c2
	P_IGOTO		.put
.c2
	P_INC		pbyte1
	P_CHILDDEAD	2,.c3
	P_IGOTO		.put
.c3
	P_INC		pbyte1
	P_CHILDDEAD	3,.c4
	P_IGOTO		.put
.c4
	P_INC		pbyte1
	P_CHILDDEAD	4,.all
.put
	P_BECOMECHILD	pbyte1
	P_SETMARKER	1
	P_UNBECOME
	P_RETURN
.all
	P_FORCE		.all_dead
	P_RETURN
.too_near
	P_DISTMORE	3000,.pass_in
	P_TRIGGER	.to_f,Always,30
.pass_in
	P_RETURN
.to_f
	P_PUSH		worldy
	P_IMPORT	worldy,Player1_worldy
	P_MOVEINPLAYER	-60
	P_PULL		worldy
	P_RETURN
fall
	P_GOSUB		ochiru_msg
	P_TRIGGER	.fall_down,Always,80
	P_TRIGGER	.fall_end,Timer,80
	P_RETURN
.fall_down
	P_ADD		worldy,200
	P_RETURN
.fall_end
	P_TRIGGER	all,OFF
	P_CIRCLEWINDOW	1,big
	P_SOUNDEFTDISTPOS	mis_explode	;$2b*
	P_FORCE		eg_remove
	P_RETURN
;mk_toge	LOCAL
;	P_SPAWN		40<<tate_m_scale,-90<<tate_m_scale,0,0,-64,0,tate_m_1,e_tate_m_c,10,1,1
;	P_SPAWN		-40<<tate_m_scale,-90<<tate_m_scale,0,0,64,0,tate_m_1,e_tate_m_c,10,2,2
;	P_SPAWN		0,90<<tate_m_scale,40<<tate_m_scale,0,0,128,tate_m_1,e_tate_m_c,10,3,3
;	P_SPAWN		0,90<<tate_m_scale,-40<<tate_m_scale,0,128,128,tate_m_1,e_tate_m_c,10,4,4
;	P_RETURN
;------------
	START_PATH	e_tate_m_e

	P_INVISIBLE	ON
	P_TRIGGER	senkan_explode,4
	P_END
;------------
	START_PATH	e_tate_m_c

	P_SET		skidy,ap
	P_SET		ap,4
	P_SHADOW	OFF
	P_RADAROBJ	ra_enemy
	P_RTRIGGER	.dead,WhenDead
	P_IMPORT	pbyte1,CREDITS_ON
	P_IFNOTZERO	pbyte1,.not_cr
	P_RTRIGGER	.fl_ck,Always
.not_cr
	P_END
.fl_ck
	P_IMPORT	pword1,Player1_worldy
	P_NEG		pword1
	P_ADD		pword1,worldy
	P_IFBETWEEN	-1000,pword1,1000,.in
	P_CLRTYPE	enemy1
	P_RETURN
.in
	P_SETTYPE	enemy1
	P_RETURN
.dead
	P_SCORE		sc_tate_m_c
;	P_BECOMEMOTHER
;	P_INC		slopenum
;	P_UNBECOME
;	P_FLAGMOTHER
	P_RETURN
;------------
	START_PATH	e_gattai_enban

	P_SET		skidy,ap
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_GOSUB		set_hp100_ap4_enemy
	P_QUADVECS	ON

	P_GOSUB		mk_gattai_enban

	P_RTRIGGER	.enban_m_ck,4			;WhenFlagged
	P_TRIGGER	self_invincible,WhenHit
	P_INVINCIBLE	ON
	P_SET		tx,4
	P_SET		ty,4
	P_TRIGGER	fly_wave,Always
	P_RTRIGGER	.only_roty,ALways
	P_ALWAYSGENVECS	OFF
	P_SETVEL	junko_speed

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_enban_1	;05

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128
	P_TRIGGER	fly_wave,OFF
	P_ZERO		pbyte2
	P_SET		tx,0
	P_SET		ty,1
	P_ZERO		pword1
	P_IFLARGER	worldy,pword1,.up

	P_SET		pword1,50
	P_IGOTO		.zero_level
.up
	P_SET		pword1,-50
.zero_level
	P_ADD		worldy,pword1
	P_IFBETWEEN	-100,worldy,100,.st
	P_GOTO		.zero_level
.st
	P_TRIGGER	fly_wave,Always
	P_ZERO		pbyte2
	P_SET		tx,0
	P_SET		ty,1
	P_IMPORT	weapontype,KX_NEARPLANETNUM
	P_IFSAME	weapontype,8,pe_sos_dandou.near_by_planet
	P_RTRIGGER	.too_near,64
.start
	P_SET		childrotx,slopenum
.come_wait
	P_IFNOTSAME	childrotx,slopenum,.act
	P_GOTO		.come_wait
.act
	P_SET		childrotx,slopenum
	P_ALWAYSGENVECS	ON
	P_SETVEL	60
.near
	P_WAIT		30
	P_RANDOMGOTO	.near
	P_TRIGGER	.only_roty,OFF
	P_SETRANDOM	childroty
	P_SETVEL	junko_speed
.ry_lp
	P_CHASE		roty,childroty
	P_IFSAME	roty,childroty,.to_come_wait
	P_GOTO		.ry_lp
.to_come_wait
	P_ALWAYSGENVECS	OFF
	P_RTRIGGER	.only_roty,ALways
	P_IGOTO		.come_wait

.enban_m_ck
	P_SET		childrotz,6
	P_IFSMALLER	slopenum,childrotz,.c_is_ok
;;;;	P_IFNOTSAME	slopenum,6,.c_is_ok
	P_FORCE		.all_c_dead
.c_is_ok
	P_RETURN
.all_c_dead
	P_TRIGGER	self_invincible,OFF
	P_TRIGGER	.enban_m_ck,OFF

	P_RTRIGGER	.moth_hit,WhenHit
	P_COLLISIONS	ON
	P_INVINCIBLE	OFF
	P_SET		hp,100
	P_END
.moth_hit
	P_SET		slopenum,95
	P_IFLARGER	hp,slopenum,.moth_ok
	P_FORCE		.last_dead
.moth_ok
	P_RETURN
.last_dead
	P_TRIGGER	.moth_hit,OFF
	P_COLLISIONS	OFF
	P_TRIGGER	kani_explode,4

	P_CLRDEMOSHAPE
	P_GOSUB		missile_count
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
	P_SCORE		sc_enban_m

	P_DO		15
	P_ADD		worldy,10
	P_RANDOMGOTO	.rand_fl
	P_HITFLASHTRIG
.rand_fl
	P_NEXT

	P_CIRCLEWINDOW	1,big			;10
	P_GOSUB		sos_group_explode
	P_EXPLODE
.only_roty
	P_ADD		roty,-4
	P_RETURN
.too_near
	P_DISTMORE	3000,.pass_in
	P_TRIGGER	.to_f,Always,30
.pass_in
	P_RETURN
.to_f
	P_PUSH		worldy
	P_IMPORT	worldy,Player1_worldy
	P_MOVEINPLAYER	-60
	P_PULL		worldy
	P_RETURN

;;;;------------
	START_PATH	e_enban_c
	P_RTRIGGER	.enban_c_dead,WhenDead
	P_END
.enban_c_dead
	P_SCORE		sc_enban_c
	P_BECOMEMOTHER
	P_INC		slopenum
	P_UNBECOME
	P_QSPAWN	enban_0,e_enban_ex,10,10
	P_RETURN
;----------
	START_PATH	e_enban_ex

	P_GOSUB		sos_group_explode
	P_EXPLODE
;;;;---------------------------------------------------------
;;;hentai_speed equ 40
;;;	START_PATH	e_sos_1hentaicyou_1
;;;	P_INC		mx
;;;	START_PATH	e_sos_hentaicyou_1
;;;
;;;	P_GOSUB		make_sw_num_hofhp	;skidy ni switchnumber ireru
;;;
;;;	P_SOUND		p2_sos_0
;;;	P_RANGECHECK	OFF
;;;	P_ALWAYSGENVECS	ON
;;;	P_COLLISIONS	OFF
;;;	P_SET		coltab,id_1_c&WM
;;;	P_RADAROBJ	ra_enemy
;;;
;;;	P_TRIGGER	pe_sos_weak_1.sos_weak_hit,WhenHit
;;;	P_TRIGGER	pe_sos_hentaiki.hentai_dead_ebyte,WhenDead
;;;	P_TRIGGER	marker_set,Always
;;;
;;;	P_SET		slopenum,ap
;;;
;;;	P_GOSUB		make_init_rot
;;;	P_SET		pbyte2,5			;boost no child num
;;;	P_EXPORT	gbyte2,pbyte2
;;;	P_INC		ap				;hentaiki no sousuu
;;;	P_SET		pbyte2,ap			;
;;;
;;;	P_SET		pbyte1,30			;boost no size
;;;	P_SET		pword1,-150			;boost no childz
;;;	P_GOSUB		make_boost
;;;
;;;	P_ZERO		pbyte2				;boost no childx,y setting
;;;	P_SET		pbyte1,5
;;;	P_DO		4
;;;	P_EXPORT	gbyte1,pbyte2
;;;	P_INC		pbyte2
;;;	P_INC		pbyte1
;;;	P_BECOMECHILD	pbyte1
;;;	P_IMPORT	pbyte2,gbyte1
;;;	P_INDEX		pword1,hentai_posx,pbyte2
;;;	P_ADD		childx,pword1
;;;	P_INDEX		pword1,hentai_posy,pbyte2
;;;	P_ADD		childy,pword1
;;;	P_INDEX		pword1,hentai_posz,pbyte2
;;;	P_ADD		childz,pword1
;;;	P_UNBECOME
;;;	P_INEXT
;;;
;;;	P_DEC		ap
;;;	P_ZERO		pbyte1
;;;	P_EXPORT	gbyte2,skidy
;;;	P_DO		ap				;hentaiki wo tsukuru
;;;	P_INC		pbyte1
;;;	P_EXPORT	gbyte1,pbyte1
;;;	P_EXPORT	gword1,shape
;;;	P_GINC		b,gbyte2
;;;	P_SPAWN		0,0,0,0,0,0,sos_0,e_sos_hentaiki,100,0,1
;;;	P_BECOME
;;;	P_IMPORT	shape,gword1
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_SETID		pbyte1
;;;	P_IMPORT	skidy,gbyte2
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_GOSUB		CurrentSw_Skidy_ck
;;;	P_IFZERO	pword1,.csok
;;;	P_INVISIBLE	ON
;;;	P_RADAROBJ	ra_off
;;;	P_REMOVE	5
;;;.csok
;;;	P_DO		4
;;;	P_SHIFTR	slopenum
;;;	P_INEXT
;;;	P_ADD		slopenum,-2		;nigeru houkou
;;;	P_SET		pbyte2,ap		;hentai_id
;;;	P_INC		pbyte2			;hentaiki no sousuu
;;;	P_GOSUB		set_hp100_ap4
;;;	P_SETVEL	hentai_speed
;;;	P_ZERO		rotz
;;;	P_GOSUB		suihei_hikou
;;;	P_IFNOTZERO	mx,.wait_come
;;;.wait_come_0
;;;	P_IMPORT	pbyte1,ebyte2
;;;	P_IFNOTZERO	pbyte1,.act_0
;;;	P_DISTLESS	5000,.act_0
;;;	P_GOTO		.wait_come_0
;;;.act_0
;;;	P_EXPORT	ebyte2,slopenum
;;;
;;;	P_ACCEL		50,5
;;;
;;;	P_DO		8
;;;	P_ADD		rotz,slopenum
;;;	P_NEXT
;;;.turn_cont
;;;	P_DO		32
;;;	P_ADD		worldy,30
;;;	P_ADD		roty,slopenum
;;;	P_NEXT
;;;
;;;	P_ZERO		slopenum
;;;	P_EXPORT	ebyte2,slopenum
;;;	P_WAIT		40
;;;.wait_come
;;;	P_IMPORT	pbyte1,ebyte2
;;;	P_IFNOTZERO	pbyte1,.pass_act
;;;	P_DISTLESS	4000,.act
;;;	P_GOTO		.wait_come
;;;.pass_act
;;;	P_DISTLESS	2500,.act
;;;	P_GOTO		.wait_come
;;;.act
;;;	P_EXPORT	ebyte2,pbyte2
;;;	P_REMOVE	6
;;;	P_FLAGCHILD	1
;;;	P_UNLINKCHILD	1
;;;	P_WAIT		5
;;;	P_REMOVE	7
;;;	P_FLAGCHILD	2
;;;	P_UNLINKCHILD	2
;;;	P_WAIT		5
;;;
;;;	P_REMOVE	8
;;;	P_FLAGCHILD	3
;;;	P_UNLINKCHILD	3
;;;	P_WAIT		5
;;;	P_REMOVE	9
;;;	P_FLAGCHILD	4
;;;	P_UNLINKCHILD	4
;;;	P_WAIT		5
;;;.no_more_hentai
;;;	P_IFZERO	pword1,.ikiteru
;;;	P_REMOVE
;;;.ikiteru
;;;	P_COLLISIONS	ON
;;;	P_ACCEL		60,2
;;;	P_WAITCHASE	rotz,0
;;;.to_wait
;;;	P_WAIT		1
;;;	P_DISTLESS	7000,.to_wait
;;;	P_RELTOPLAYER	ON
;;;	P_SPACESHIP	ON
;;;	P_ACCEL		30,10
;;;	P_WAITCHASE	rotz,16
;;;.nige_wait
;;;	P_IMPORT	pbyte2,KEnemyNumber
;;;	P_IFSAME	pbyte2,1,.nigero
;;;
;;;	P_DISTLESS	3000,.nigero
;;;	P_DISTLESS	7000,.too_near
;;;	P_GOTO		.nige_wait
;;;.too_near
;;;	P_MOVEINPLAYER	-10
;;;	P_GOTO		.nige_wait
;;;.nigero
;;;	P_WAIT		1
;;;	P_PLAYERINCONE	80,.nigero
;;;	P_SPACESHIP	OFF
;;;	P_WAITCHASE	rotz,0
;;;	P_RELTOPLAYER	OFF
;;;	P_FLAGCHILD	5
;;;	P_WAIT		3
;;;	P_BECOMECHILD	5
;;;	P_ADD		tx,40
;;;	P_UNBECOME
;;;	
;;;	P_FLAGCHILD	5
;;;	P_SETVEL	127
;;;	P_WAIT		5
;;;
;;;	P_BECOMECHILD	5
;;;	P_ADD		tx,-20
;;;	P_UNBECOME
;;;	P_SET		pbyte2,4
;;;
;;;	P_ACCEL		50,2
;;;.lpp
;;;	P_WAIT		1
;;;	P_IFNOTSAME	vel,50,.lpp
;;;
;;;.m_wait
;;;	P_DISTLESS	3000,.m_act
;;;	P_GOTO		.m_wait
;;;.m_act
;;;	P_TRIGGER	marker_set,OFF
;;;	P_IGOTO		pe_sos_hentaiki.turn_on
;;;
;;;;-----------
;;;	START_PATH	e_sos_hentaiki
;;;
;;;	P_IMPORT	pword1,CurrentSwitch
;;;	P_INC		skidy
;;;	P_IFSWITCH	skidy,pword1,.rem
;;;	P_IGOTO		.ikiteru
;;;.rem
;;;	P_ADD		pbyte1,5
;;;	P_BECOMECHILD	pbyte1
;;;	P_INVISIBLE	ON
;;;	P_UNBECOME
;;;	P_REMOVE
;;;.ikiteru
;;;	P_SOUND		p2_sos_0
;;;	P_RANGECHECK	OFF
;;;	P_RELTOPLAYER	ON
;;;	P_COLLISIONS	OFF
;;;	P_RADAROBJ	ra_enemy
;;;
;;;	P_SET		tx,pbyte1
;;;	P_DEC		pbyte1
;;;	P_INDEX		childx,hentai_posx,pbyte1
;;;	P_INDEX		childy,hentai_posy,pbyte1
;;;	P_INDEX		childz,hentai_posz,pbyte1
;;;	P_SET		pbyte1,tx
;;;	P_TRIGGER	.hen_act,WhenFlagged
;;;	P_TRIGGER	pe_sos_weak_1.sos_weak_hit,WhenHit
;;;	P_TRIGGER	.hentai_dead_ebyte,WhenDead
;;;	P_END
;;;.hen_act
;;;	P_FORCE		.hen_act_on
;;;	P_RETURN
;;;.hen_act_on
;;;	P_TRIGGER	.hen_act,OFF
;;;	P_ALWAYSGENVECS	ON
;;;	P_SETVEL	hentai_speed
;;;	P_SET		pbyte2,4
;;;	P_IFSAME	pbyte1,2,.turn_on
;;;	P_IFSAME	pbyte1,4,.turn_on
;;;	P_NEG		pbyte2
;;;.turn_on	LOCAL
;;;	P_DO		8
;;;	P_ADD		rotz,pbyte2
;;;	P_NEXT
;;;	P_ACCEL		90,5
;;;	P_ZERO		pword1
;;;.turn_cont
;;;	P_PLAYERINCONE	5,.begin_weak_1
;;;	P_INC		pword1
;;;	P_IFSAME	pword1,100,.begin_weak_1
;;;	P_ADD		worldy,20
;;;	P_ADD		roty,pbyte2
;;;	P_GOTO		.turn_cont
;;;.begin_weak_1
;;;	P_GOSUB		init_sos_zaco
;;;	P_COLLISIONS	ON
;;;	P_SET		slopenum,1
;;;	P_TRIGGER	marker_set,Always
;;;	P_SET		childrotx,98
;;;	P_SET		childroty,10
;;;	P_GOSUB		sos_0_boost
;;;	P_IGOTO		pe_sos_weak_1.come_loop_to
;;;.hentai_dead_ebyte	LOCAL
;;;	P_GDEC		b,ebyte2
;;;	P_RETURN
;;;;------------
;;;	START_PATH	e_sos_speed_hentai_kr
;;;
;;;	P_IFZERO	ap,pe_sos_speed_hentai.koki
;;;	P_EXPORT	gbyte1,slopenum
;;;	P_EXPORT	gbyte2,ty
;;;	P_EXPORT	gword1,mz
;;;	P_SPAWN		127,127,-127,0,0,0,speed_s,e_sos_speed_hentai_kr,0,0
;;;	P_BECOME
;;;	P_IMPORT	skidy,etemp
;;;	P_GINC		b,etemp
;;;	P_IMPORT	slopenum,gbyte1
;;;	P_IMPORT	ty,gbyte2
;;;	P_IMPORT	mz,gword1
;;;	P_SET		tx,-1
;;;	P_SET		my,5
;;;	P_UNBECOME
;;;	P_IGOTO		pe_sos_speed_hentai.koki
;;;;-----------
;;;	START_PATH	e_sos_speed_hentai_kl
;;;
;;;	P_IFZERO	ap,pe_sos_speed_hentai.koki
;;;	P_EXPORT	gbyte1,slopenum
;;;	P_EXPORT	gbyte2,ty
;;;	P_EXPORT	gword1,mz
;;;	P_SPAWN		-127,127,-127,0,0,0,speed_s,e_sos_speed_hentai_kl,0,0
;;;	P_BECOME
;;;	P_IMPORT	skidy,etemp
;;;	P_GINC		b,etemp
;;;	P_IMPORT	slopenum,gbyte1
;;;	P_IMPORT	ty,gbyte2
;;;	P_IMPORT	mz,gword1
;;;	P_SET		tx,1
;;;	P_SET		my,4
;;;	P_UNBECOME
;;;	P_IGOTO		pe_sos_speed_hentai.koki
;;;;-----------
;;;	START_PATH	e_sos_speed_1hentai
;;;	P_INC		mz
;;;	START_PATH	e_sos_speed_hentai
;;;
;;;	P_GOSUB		make_sw_num_hofhp	;skidy ni switchnumber ireru
;;;	P_EXPORT	etemp,skidy
;;;	P_GINC		b,etemp
;;;
;;;	P_GOSUB		shift_hap
;;;	P_INDEX		rotx,init_angle_tab,pbyte1
;;;	P_SET		slopenum,pbyte2
;;;	P_ADD		slopenum,-2			;hentai no turn no houkou
;;;	P_GOSUB		clsw_hap
;;;	P_INDEX		roty,init_angle_tab,hp
;;;
;;;	P_GINC		b,ebyte3
;;;	P_IMPORT	ty,ebyte3
;;;	P_ADD		ap,-2
;;;	P_EXPORT	gbyte1,ap			;sarani koki aruka 0=nashi
;;;	P_EXPORT	gbyte2,slopenum
;;;	P_EXPORT	gbyte3,ty
;;;	P_EXPORT	gword1,mz
;;;	P_SPAWN		127,127,-127,0,0,0,speed_s,e_sos_speed_hentai_kr,0,0
;;;	P_BECOME
;;;	P_IMPORT	skidy,etemp
;;;	P_GINC		b,etemp
;;;	P_IMPORT	ap,gbyte1
;;;	P_IMPORT	slopenum,gbyte2
;;;	P_IMPORT	ty,gbyte3
;;;	P_IMPORT	mz,gword1
;;;	P_SET		tx,-1
;;;	P_SET		my,3
;;;	P_UNBECOME
;;;	P_SPAWN		-127,127,-127,0,0,0,speed_s,e_sos_speed_hentai_kl,0,0
;;;	P_BECOME
;;;	P_IMPORT	skidy,etemp
;;;	P_GINC		b,etemp
;;;	P_IMPORT	ap,gbyte1
;;;	P_IMPORT	slopenum,gbyte2
;;;	P_IMPORT	ty,gbyte3
;;;	P_IMPORT	mz,gword1
;;;	P_SET		tx,1
;;;	P_SET		my,2
;;;	P_UNBECOME
;;;	P_SET		tx,1
;;;	P_SET		my,1
;;;.koki	LOCAL
;;;	P_INC		mx
;;;	P_IGOTO		pe_sos_speed.hentai_start
;;;;-----------
;;;	START_PATH	e_sos_speed
;;;
;;;	P_SET		roty,hp
;;;	P_SET		skidy,ap
;;;.hentai_start	LOCAL
;;;	P_GOSUB		CurrentSw_Skidy_ck
;;;	P_IFZERO	pword1,.csok
;;;	P_REMOVE
;;;.csok
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_SOUND		p2_speed_s
;;;	P_RELATIVE	OFF
;;;
;;;	P_SPAWN		0,0,0,0,0,0,speed_lr,e_speed_lr,100,0,1
;;;
;;;	P_WEAPON	RelElaser
;;;	P_RANGECHECK	OFF
;;;
;;;	P_SET		childroty,roty
;;;	P_SET		childy,worldy
;;;	P_TRIGGER	.speed_dead,WhenHit
;;;	P_TRIGGER	.run_vis,16
;;;	P_SETVEL	40
;;;
;;;	P_IFSAME	mz,1,.hentai_wait3
;;;	P_IFZERO	mx,.come_wait
;;;.hentai_wait1
;;;	P_DISTLESS	3000,.hentai_wait2
;;;	P_GOTO		.hentai_wait1
;;;.hentai_wait2
;;;	P_TRIGGER	.run_vis,OFF
;;;	P_EXPORT	ebyte2,ty
;;;	P_DO		16
;;;	P_ADD		rotz,slopenum
;;;	P_NEXT
;;;	P_ACCEL		127,5
;;;	P_SPACESHIP	ON
;;;	P_DO		16
;;;	P_ADD		worldy,15
;;;	P_NEXT
;;;
;;;	P_SPACESHIP	OFF
;;;	
;;;	P_ZERO		pbyte1
;;;	P_EXPORT	ebyte2,pbyte1
;;;	P_GOSUB		suihei_hikou
;;;	P_WAIT		50
;;;	P_ACCEL		40,2
;;;.hentai_wait3
;;;	P_DISTLESS	3000,.hentai_to_start
;;;	P_GOTO		.hentai_wait3
;;;.hentai_to_start
;;;	P_TRIGGER	.run_vis,OFF
;;;	P_EXPORT	ebyte2,ty
;;;	P_DO		my
;;;	P_WAIT		10
;;;	P_NEXT
;;;	P_DO		16
;;;	P_ADD		rotz,tx
;;;	P_ADD		rotz,tx
;;;	P_NEXT
;;;	P_ACCEL		120,10			;60,5
;;;
;;;	P_DO		80
;;;	P_ADD		roty,tx
;;;	P_ADD		roty,tx
;;;	P_NEXT
;;;
;;;	P_WAITCHASE	rotz,0
;;;	P_RELTOPLAYER	ON
;;;	P_TRIGGER	.speed_dist,Always
;;;	P_SETVEL	0
;;;	P_IGOTO		.hentai_atack_on
;;;.come_wait
;;;	P_DISTLESS	2500,.start
;;;	P_GOTO		.come_wait
;;;.start
;;;.start2
;;;	P_RELTOPLAYER	ON			;;;
;;;	P_TRIGGER	.speed_dist,Always
;;;	P_FLAGCHILD	10			;OFF
;;;	P_WAIT		1
;;;.start_face
;;;	P_ADD		roty,-8
;;;	P_PLAYERINCONE	10,.re_start
;;;	P_GOTO		.start_face
;;;.re_start
;;;	P_SETVEL	0
;;;	P_FLAGCHILD	10			;ON
;;;
;;;	P_WAIT		3
;;;.hentai_atack_on
;;;	P_DO		3
;;;		P_SETRANDOM	ox,255
;;;		P_ADD		ox,-128
;;;		P_SETRANDOM	oz,255
;;;		P_ADD		oz,-128
;;;		P_SET		oy,120
;;;		P_GOSUB		.boost_flag	;OFF
;;;		P_SET		pbyte2,64
;;;		P_ABOVEPLAYER	.move_down
;;;		P_NEG		oy
;;;		P_NEG		pbyte2
;;;.move_down
;;;		P_GOSUB		.make_wing_rot
;;;		P_WAIT		8
;;;		P_GOSUB		.boost_flag	;ON
;;;		P_TRIGGER	.speed_move,Always
;;;		P_WAIT		8
;;;		P_TRIGGER	sos_fire_must,16
;;;.speed_down_cont
;;;		P_WAIT		1
;;;		P_DO		2
;;;		P_CHASE		ox,0
;;;		P_CHASE		oy,0
;;;		P_CHASE		oz,0
;;;		P_INEXT
;;;		P_FACEPLAYER
;;;		P_IFNOTZERO	oy,.speed_down_cont
;;;		P_TRIGGER	.speed_move,OFF
;;;		P_TRIGGER	sos_fire_must,OFF
;;;
;;;		P_SETRANDOM	pbyte1,7
;;;		P_ADD		pbyte1,-4
;;;		P_DO		10
;;;		P_ADD		roty,pbyte1
;;;		P_NEXT
;;;	P_NEXT
;;;
;;;	P_GOSUB		.boost_flag
;;;
;;;	P_ZERO		pbyte2
;;;	P_GOSUB		.make_wing_rot
;;;	P_WAIT		8
;;;	P_SET		childrotz,32
;;;	P_IFSMALLER	worldy,childy,.ok_x_rot
;;;	P_NEG		childrotz
;;;.ok_x_rot
;;;	P_SET		childrotx,childroty
;;;	P_NEG		childrotx
;;;	P_ADD		childrotx,roty
;;;	P_IFSMALLER	childrotx,ty,.rev_rot
;;;	P_FLAGCHILD	9		;ON
;;;	P_IGOTO		.run_root
;;;.rev_rot
;;;	P_FLAGCHILD	10		;ON
;;;.run_root
;;;	P_CHASE		roty,childroty
;;;	P_CHASE		roty,childroty
;;;	P_CHASE		rotx,childrotz
;;;	P_IFSAME	childroty,roty,.go_run
;;;	P_GOTO		.run_root
;;;
;;;.go_run
;;;	P_TRIGGER	.speed_dist,OFF
;;;	P_SETVEL	127
;;;	P_IFSMALLER	childrotx,ty,.rev_rot2
;;;	
;;;	P_FLAGCHILD	10
;;;	P_IGOTO		.run_st	
;;;.rev_rot2
;;;	P_FLAGCHILD	9
;;;.run_st
;;;	P_DO		40
;;;	P_IFSAME	childrotz,32,.down_ck
;;;	P_IFLARGER	worldy,childy,.hi_cont
;;;	P_IGOTO		.zero_x
;;;.down_ck
;;;	P_IFSMALLER	worldy,childy,.hi_cont
;;;.zero_x
;;;	P_CHASE		rotx,0
;;;	P_CHASE		rotx,0
;;;.hi_cont
;;;	P_NEXT
;;;
;;;	P_ACCEL		55,2
;;;	P_WAITCHASE	rotx,0
;;;.flp
;;;	P_DISTMORE	3000,.nom
;;;	P_GOTO		.flp
;;;.nom
;;;
;;;	P_RELTOPLAYER	OFF			;;;
;;;.run_lp
;;;	P_DISTLESS	2500,.start
;;;	P_GOTO		.run_lp
;;;;------------
;;;.speed_dead
;;;	P_FORCE		.speed_exp
;;;	P_RETURN
;;;.speed_exp
;;;	P_TRIGGER	.speed_move,OFF
;;;	P_TRIGGER	.speed_dist,OFF
;;;	P_TRIGGER	.speed_dead,OFF
;;;	P_RELTOPLAYER	OFF
;;;	P_COLLISIONS	OFF
;;;	P_REMOVE	9
;;;	P_REMOVE	10
;;;	P_CLRDEMOSHAPE
;;;	P_GOSUB		dec_EEnemyNumber_skidy
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCORE		sc_sos_speed
;;;	P_SCREENFLASH
;;;	P_GOSUB		group_explode
;;;	P_BECOMECHILD	1
;;;	P_INC		pbyte1
;;;	P_UNBECOME
;;;	P_FLAGCHILD	1
;;;	P_UNLINKCHILD	1
;;;	P_EXPLODE
;;;.run_vis
;;;	P_CHASE		rotx,0
;;;	P_RETURN
;;;
;;;.speed_dist
;;;	P_DISTLESS	2000,.dist_ok
;;;	P_MOVEINPLAYER	30
;;;.dist_ok
;;;	P_RETURN
;;;.speed_move
;;;	P_ADD		worldx,ox
;;;	P_ADD		worldy,oy
;;;	P_ADD		worldz,oz
;;;	P_RETURN
;;;
;;;.make_wing_rot
;;;	P_EXPORT	gbyte1,pbyte2
;;;	P_BECOMECHILD	1
;;;	P_EXPORT	gbyte2,childrotx
;;;	P_UNBECOME
;;;	P_IMPORT	childrotx,gbyte2
;;;	P_NEG		childrotx
;;;	P_ADD		childrotx,pbyte2
;;;	P_SET		pbyte1,16
;;;	P_IFLARGER	childrotx,ty,.plus
;;;	P_NEG		pbyte1
;;;.plus
;;;	P_EXPORT	gbyte2,pbyte1
;;;	P_BECOMECHILD	1
;;;	P_IMPORT	pbyte2,gbyte1
;;;	P_IMPORT	slopenum,gbyte2
;;;	P_UNBECOME
;;;	P_FLAGCHILD	1
;;;	P_RETURN
;;;
;;;.boost_flag
;;;	P_FLAGCHILD	9
;;;	P_FLAGCHILD	10
;;;	P_RETURN
;;;;------------
;;;	START_PATH	e_speed_lr
;;;
;;;	P_ACTIVE	ON
;;;	P_SETANIM	0
;;;	P_SHADOW	OFF
;;;	P_SET		pbyte2,9
;;;	P_SET		slopenum,pbyte2
;;;	P_EXPORT	gbyte2,pbyte2
;;;
;;;	P_SET		pbyte2,2
;;;	P_SET		pbyte1,30
;;;	P_SET		pword1,-22<<speed_scale
;;;	P_GOSUB		make_boost
;;;
;;;	P_BECOMECHILD	9
;;;	P_SET		childx,-36<<speed_scale
;;;	P_UNBECOME
;;;	P_BECOMECHILD	10
;;;	P_SET		childx,36<<speed_scale
;;;	P_UNBECOME
;;;
;;;	P_COLLISIONS	OFF
;;;	P_RANGECHECK	OFF
;;;	P_ZERO		pbyte1
;;;.re_start
;;;	P_TRIGGER	.mother_flag,WhenFlagged
;;;	P_END
;;;.mother_flag
;;;	P_IFZERO	pbyte1,.rot_flag
;;;	P_FORCE		.exp
;;;	P_RETURN
;;;.rot_flag
;;;	P_FORCE		.wing_rot
;;;	P_RETURN
;;;.wing_rot
;;;	P_TRIGGER	.mother_flag,OFF
;;;.wing_rot_lp
;;;	P_IFSAME	pbyte2,childrotx,.re_start
;;;	P_ADD		childrotx,slopenum
;;;	P_GOTO		.wing_rot_lp
;;;.exp
;;;	P_SETANIM	1
;;;	P_ADD		childx,30<<speed_scale
;;;	P_QSPAWN	speed_lr,e_speed_r,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_SETANIM	2
;;;	P_UNBECOME
;;;	P_ADD		childx,-60<<speed_scale
;;;	P_RELTOPLAYER	ON
;;;
;;;	START_PATH	e_speed_r
;;;
;;;	P_COLLISIONS	OFF
;;;	P_SETRANDOM	pbyte1,255
;;;	P_DIV2		pbyte1
;;;	P_SETRANDOM	pbyte2,255
;;;	P_DIV2		pbyte2
;;;	P_SETRANDOM	slopenum,255
;;;	P_DIV2		slopenum
;;;	P_SETRANDOM	childrotx,15
;;;	P_ADD		childrotx,16
;;;	P_SETRANDOM	childroty,15
;;;	P_ADD		childroty,-48
;;;	P_DO		10
;;;	P_ADD		worldx,pbyte1
;;;	P_ADD		worldy,pbyte2
;;;	P_ADD		worldz,slopenum
;;;	P_ADD		roty,childrotx
;;;	P_ADD		rotx,childroty
;;;	P_NEXT
;;;	P_EXPLODE
;;;
;;;;-----------
	START_PATH	e_sos_enkin_mustwork

	P_INC		mx

	START_PATH	e_sos_enkin

	P_GOSUB		make_sw_num_hofap
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_TRIGGER	anim_add_12,Always
	P_RTRIGGER	.enkin_hit,WhenHit

	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_GOSUB		set_hp100_ap4_enemy
	P_WEAPON	HomEMissile
	P_SET		pbyte1,30<<1
	P_SET		pword1,-80
	P_SET		pbyte2,9
	P_EXPORT	gbyte2,pbyte2
	P_SET		pbyte2,1
	P_GOSUB		make_boost
	P_QUADVECS	ON
	P_SETVEL	junko_speed		;12

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_enkin

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128

.wlp
	P_WITHINRADIUS	action_dist,.act
	P_DISTMORE	14000,.twlp
	P_IMPORT	slopenum,eaction1
	P_IFSAME	slopenum,255,.act
	P_IFNOTZERO	slopenum,.run
.twlp
	P_GOTO		.wlp
;----------
.enkin_hit
	P_FORCE		.life_out
	P_RETURN
.life_out
	P_TRIGGER	.enkin_hit,OFF
	P_RELTOPLAYER	OFF
	P_GOSUB		fighter_count_gset
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
;	P_CLRDEMOSHAPE
;	P_SCREENFLASH
;	P_SET		slopenum,255
;	P_EXPORT	eaction1,slopenum
	P_SCORE		sc_enkin
	P_REMOVE	9
	P_COLLISIONS	OFF
	P_GOSUB		sos_group_explode
	P_EXPLODE
;----------
.run
	P_IFNOTZERO	mx,.act
	P_ACCEL		run_speed,2		;40,2
	P_BECOMECHILD	9
	P_SET		tx,100
	P_UNBECOME
	P_ZERO		slopenum
.run_cont
	P_DISTLESS	5000,.act
	P_INC		slopenum
	P_IFSAME	slopenum,45,.run_end
	P_GOTO		.run_cont
.run_end
	P_ACCEL		junko_speed,2		;12,2
	P_BECOMECHILD	9
	P_SET		tx,30
	P_UNBECOME
	P_ZERO		slopenum
	P_EXPORT	eaction1,slopenum
	P_GOTO		.wlp
.act
	P_RELTOPLAYER	ON
;	P_EXPORT	eaction1,skidy
;	P_ACCEL		60,2			;30,2
	P_ACCEL		sankai_speed,20			;30,2
	P_BECOMECHILD	9
	P_SET		tx,90
	P_UNBECOME
	P_RANDOMGOTO	.st_up
	P_WAITCHASE	rotx,16
	P_IGOTO		.rroot
.st_up
	P_WAITCHASE	rotx,-16
.rroot
	P_SETRANDOM	childroty
.root
	P_WAIT		1
	P_CHASE		roty,childroty
	P_IFNOTSAME	roty,childroty,.root

	P_WAITCHASE	rotx,0
	P_WAIT		10
	P_ZERO		slopenum
	P_EXPORT	eaction1,slopenum
.turn_again
	P_SET		pbyte1,1	;turn y 
	P_SET		pbyte2,2

	P_RIGHTOFPLAYER	.atright
	P_NEG		pbyte1
.atright
	P_ABOVEPLAYER	.atabove
	P_NEG		pbyte2
.atabove
	P_SPACESHIP	ON
	P_PLAYERINCONE	10,.face_p
	P_IFNOTBETWEEN	-16,rotz,16,.pass_rz
	P_ADD		rotz,pbyte1
.pass_rz
	P_IFNOTBETWEEN	-64,rotx,64,.pass_rx
	P_ADD		rotx,pbyte2
.pass_rx
	P_GOTO		.atabove
.face_p
;	P_ACCEL		60,2			;30,2
	P_INC		pbyte1
	P_IFSAME	pbyte1,10,.kyousei_stop
	P_ZERO		rotz
	P_IMPORT	childy,Player1_Worldy
	P_SET		childx,worldy
	P_NEG		childx
	P_ADD		childx,childy
	P_IFNOTBETWEEN	-200,childx,200,.pass_rx
.kyousei_stop
	P_SET		childrotx,rotx
	P_NEG		childrotx
	P_SPACESHIP	OFF
.come0
	P_CHASE		rotz,0
	P_CHASE		rotx,0
	P_FACEPLAYER	y
	P_DISTLESS	5000,.come1
	P_GOTO		.come0
.come1
;	P_ACCEL		40,2
	P_TRIGGER	missile_fire_l_ran,64
	P_SETRANDOM	slopenum,3
.come2
	P_CHASE		rotz,0
	P_IFSAME	slopenum,2,.tolef
	P_IFSAME	slopenum,3,.torig
	P_FACEPLAYEROFS	0,0,127
.ck_hi
	P_IMPORT	childy,Player1_Worldy
	P_SET		childx,worldy
	P_NEG		childx
	P_ADD		childx,childy
	P_IFBETWEEN	-500,childx,500,.same_hi
	P_GOTO		.come2
.tolef
	P_FACEPLAYEROFS	-127,0,0
	P_IGOTO		.ck_hi
.torig
	P_FACEPLAYEROFS	127,0,0
	P_IGOTO		.ck_hi
.same_hi
	P_ACCEL		60,1
.same_hil
	P_WAIT		25		;50
.fi
	P_TRIGGER	missile_fire_l_ran,OFF
	P_ZERO		pbyte2
	P_INPLAYERSCONE	0,128,.at_r
	P_SET		pbyte1,4
	P_IGOTO		.same_hi_lp
.at_r
	P_SET		pbyte1,-4
.same_hi_lp
	P_ADD		roty,pbyte1
	P_CHASE		rotx,0
	P_INC		pbyte2
	P_IFSAME	pbyte2,10,.near
	P_GOTO		.same_hi_lp
.near
	P_WAITCHASE	rotz,0
.nnear
	P_DISTMORE	8000,.turn_again	;.to_aga
	P_GOTO		.nnear
;;;;------------
;;;	START_PATH	e_sos_boomeran
;;;
;;;	P_INVISIBLE	ON
;;;	P_WAIT		100
;;;	P_WAIT		100
;;;.again
;;;	P_COPYVIEWROTS
;;;	P_COPYVIEWPOS
;;;
;;;	P_NEG		rotx
;;;	P_NEG		roty
;;;	P_NEG		rotz
;;;	P_FINDSHAPE	b_wing
;;;
;;;	P_BEGINDEMO
;;;	P_SETCAMERA	IMMEDIATE
;;;	P_DO		50
;;;	P_SCORE		1
;;;	P_FACESHAPE
;;;	P_MOVEINSHAPE	10
;;;	P_SET		worldy,-120
;;;	P_SETCAMERA
;;;	P_NEXT
;;;
;;;	P_WAIT		30
;;;	P_ENDDEMO
;;;
;;;	P_DO		100
;;;	P_SCORE		1
;;;	P_NEXT
;;;	P_GOTO		.again
;;;
;;;	P_END
;;;;------------
;;;;------------
;;;;------------
;;;;------------
	START_PATH	e_sos_kamereon_2

.enter	LOCAL
	P_GOSUB		init_sos_zaco

	P_WEAPON	Eplasma1
	P_SET		pbyte2,60		;min_hp
	P_SET		slopenum,80		;1st_step
	P_RTRIGGER	.kamereon_2_deadck,WhenHit
	P_SET		ox,2			;1
	P_SET		oy,20			;28
	P_SET		oz,0
	P_IMPORT	pbyte1,KDifficulty
	P_IFNOTSAME	pbyte1,dif_easy,.not_easy
	P_INC		ox		;ox=3
	P_ADD		oy,5		;oy=25
.not_easy
	P_SET		pbyte1,8
	P_IGOTO		pe_sos_kamereon_1.kamereon_start

.kamereon_2_deadck
	P_IFLARGER	hp,slopenum,.live_ok_1
	P_SPAWN		0,0,0,0,0,0,nullshape,e_noroshi_maker,100,0,1
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_ZERO		slopenum
.live_ok_1
	P_IFLARGER	hp,pbyte2,.live_ok_2
	P_FORCE		.kamereon_dead
.live_ok_2
	P_RETURN

.kamereon_dead
	P_TRIGGER	.kamereon_2_deadck,OFF

	P_GOSUB		fighter_count
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
;	P_CLRDEMOSHAPE
;	P_SCREENFLASH
	P_SCORE		sc_sos_strong

	P_REMOVE	1
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_RELTOPLAYER	OFF
	P_ALWAYSGENVECS	ON
	P_SETVEL	0

	P_TRIGGER	kani_explode,4
	P_TRIGGER	exp_smoke,8

	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,119
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME

	P_DO		50
	P_PUSH		rotx
	P_PUSH		roty
	P_FACEVIEW	IMMEDIATE
	P_SET		childroty,roty
	P_PULL		roty
	P_PULL		rotx
	P_CHASE		roty,childroty
	P_DEC		rotx
	P_ADD		worldy,10
	P_RANDOMGOTO	.fl_pass
	P_RANDOMGOTO	.fl_pass
	P_HITFLASHTRIG
.fl_pass
	P_NEXT

	P_DO		4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,32
	P_BECOME
	P_ADD		slopenum,4
	P_ACTIVE	ON
	P_UNBECOME
	P_PUSH		roty
	P_PUSH		rotx
	P_FACEVIEW	IMMEDIATE
	P_SET		childroty,roty
	P_PULL		rotx
	P_PULL		roty
	P_CHASE		roty,childroty
	P_ADD		worldy,10
	P_DEC		rotx
	P_NEXT

	P_CIRCLEWINDOW	1,big
	P_GOSUB		make_random_item
	P_EXPLODE
;;;;------------
	START_PATH	e_kamereon_core

	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_GOSUB		make_sw_num_hofhp	;skidy ni switchnumber ireru
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_INVISIBLE	ON
.csok
	P_COLLISIONS	OFF
	P_IFNOTZERO	pword1,.no_core
	P_TRIGGER	marker_set,Always
	P_RADAROBJ	ra_enemy
.no_core
	P_ADD		skidy,7
	P_EXPORT	gbyte1,skidy
	P_ADD		skidy,-7
	P_SPAWN		120<<kururin0_scale,0,0,0,0,64,kuru0_u,e_kamereon_0,100,4,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_SPAWN		-120<<kururin0_scale,0,0,0,0,64,kuru0_u,e_kamereon_0,100,4,2
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_INC		skidy
	P_UNBECOME
	P_IFSAME	hp,2,.cis2
	P_SPAWN		0,120<<kururin0_scale,0,0,0,0,kuru0_u,e_kamereon_0,100,4,3
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_ADD		skidy,2
	P_UNBECOME
	P_SPAWN		0,-120<<kururin0_scale,0,0,0,0,kuru0_u,e_kamereon_0,100,4,4
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_ADD		skidy,3
	P_UNBECOME
.cis2
	P_SET		hp,120
	P_IFZERO	pword1,.aru_core
	P_GOSUB		c_flag_1234
;	P_FLAGCHILD	1
;	P_FLAGCHILD	2
;	P_FLAGCHILD	3
;	P_FLAGCHILD	4
	P_WAIT		20
	P_GOSUB		c_unlink_1234
;	P_UNLINKCHILD	1
;	P_UNLINKCHILD	2
;	P_UNLINKCHILD	3
;	P_UNLINKCHILD	4
	P_REMOVE
.aru_core
	P_TRIGGER	far_rem_ck,16
	P_RTRIGGER	.core_rot,Always

	P_SET		pbyte2,5
	P_EXPORT	gbyte2,pbyte2
	P_SET		pword1,-150
	P_SET		pbyte1,60
	P_SET		pbyte2,1
	P_GOSUB		make_boost

	P_QUADVECS	ON
	P_SETVEL	junko_speed		;12

	P_GOSUB		wait_start_trigger
	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128
.wait_lp
	P_DISTLESS	action_dist,.run1
	P_GOTO		.wait_lp
;----------
.core_rot
	P_ADD		rotz,4
	P_RETURN
;----------
.run1
	P_ZERO		pbyte1
	P_EXPORT	eaction1,pbyte1
	P_SET		pbyte1,3
	P_DO		2
	P_BECOMECHILD	pbyte1
	P_IMPORT	pbyte1,eaction1
	P_SETSWITCH	skidy,pbyte1
	P_EXPORT	eaction1,pbyte1
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT

	P_GOSUB		c_flag_34
;	P_FLAGCHILD	3
;	P_FLAGCHILD	4
	P_FLAGCHILD	5
	P_WAIT		20
	P_GOSUB		c_unlink_34
;	P_UNLINKCHILD	3
;	P_UNLINKCHILD	4

	P_BECOMECHILD	5
	P_SET		tx,110
	P_UNBECOME
	P_FLAGCHILD	5
	P_WAIT		1
	P_ACCEL		40,5
	P_ZERO		pbyte2
.run1_lp
	P_IMPORT	pbyte1,eaction1
	P_IFZERO	pbyte1,.to_run2
	P_INC		pbyte2
	P_IFSAME	pbyte2,100,.to_run2		;.move_f
	P_GOTO		.run1_lp
.to_run2
	P_ACCEL		junko_speed+1,2		;12,2
	P_BECOMECHILD	5
	P_SET		tx,60
	P_UNBECOME
.to_run2_lp
	P_DISTLESS	8000,.run2
	P_GOTO		.to_run2_lp
.run2
	P_SET		pbyte1,1
	P_DO		2
	P_BECOMECHILD	pbyte1
	P_IMPORT	pbyte1,eaction1
	P_SETSWITCH	skidy,pbyte1
	P_EXPORT	eaction1,pbyte1
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT
	P_FLAGCHILD	1
	P_FLAGCHILD	2
	P_FLAGCHILD	5
	P_WAIT		20
	P_UNLINKCHILD	1
	P_UNLINKCHILD	2
	P_BECOMECHILD	5
	P_SET		tx,110
	P_UNBECOME
	P_FLAGCHILD	5
	P_ACCEL		40,5
	P_ZERO		pbyte2
.run2_lp
	P_IMPORT	pbyte1,eaction1
	P_IFZERO	pbyte1,.slow1
	P_INC		pbyte2
	P_IFSAME	pbyte2,100,.slow1		;.move_ff
	P_GOTO		.run2_lp
.slow1
	P_TRIGGER	.core_rot,OFF
	P_BECOMECHILD	5
	P_SET		tx,60
	P_UNBECOME
	P_ACCEL		junko_speed+1,2		;12,2
	P_WAITCHASE	rotz,0
.fi_wait
	P_DISTLESS	8000,.fight
	P_GOTO		.fi_wait	
.fight
	P_SETVEL	0
	P_REMOVE	5
	P_DO		16		;32
	P_FACEPLAYER
	P_CHASE		rotz,0
	P_NEXT

	P_SET		shape,kururin1
	P_SET		pbyte1,8
	P_GOSUB		pe_sos_kamereon_1.kurun
	P_SETRANDOM	pbyte2,15
	P_INC		pbyte2
	P_DO		pbyte2
	P_CIRCLEPLAYER	16
	P_NEXT
	P_SET		hp,100
	P_IGOTO		pe_sos_kamereon_2.enter
;;;;------------
	START_PATH	e_kamereon_0

	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_COLLISIONS	OFF
	P_RTRIGGER	.kamereon_1_deadck,WhenHit
	P_RTRIGGER	.act_trg,WhenFlagged
	P_END
.act_trg
	P_FORCE		.act
	P_RETURN
.act
	P_TRIGGER	.act_trg,OFF
	P_COLLISIONS	ON
	P_GOSUB		init_sos_zaco
	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128

	P_DO		32
	P_MOVEIN	-30
	P_FACEPLAYER
	P_CHASE		rotz,0
	P_ADJUSTROT
	P_NEXT

	P_SET		shape,kururin0
	P_SET		pbyte2,1
	P_TRIGGER	.kamereon_1_deadck,OFF
	P_IGOTO		pe_sos_kamereon_1.kame_0_start

.kamereon_1_deadck
	P_FORCE		.dead
	P_RETURN
.dead
	P_TRIGGER	.kamereon_1_deadck,OFF
	P_TRIGGER	kame_face_exp,Always
	P_IMPORT	pbyte2,eaction1
	P_CLRSWITCH	skidy,pbyte2
	P_EXPORT	eaction1,pbyte2
	P_SET		pbyte2,3
	P_IGOTO		kamereon_weak_exp
;;;;------------
	START_PATH	e_sos_kamereon_1
.kame_0_start	LOCAL
	P_RTRIGGER	.kamereon_1_deadck,WhenHit
	P_GOSUB		init_sos_zaco
	P_INC		slopenum		;only_noroshi_flag
	P_SET		ox,2
	P_SET		oy,32
	P_SET		oz,2
	P_SET		pbyte1,16
.kamereon_start	LOCAL
	P_TRIGGER	marker_set,ALways
	P_IFSAME	pbyte2,1,.core_st
	P_INVISIBLE	ON
.come_wait
	P_DISTLESS	8000,.to_re_start
	P_GOTO		.come_wait
.to_re_start
	P_SETVEL	0
.re_start
	P_SETRANDOM	ap,15
	P_INC		ap
;	P_IGOTO		.rev
	P_RANDOMGOTO	.rev
	P_DO		ap
	P_CIRCLEPLAYER	16
	P_NEXT
	P_IGOTO		.erev
.rev
	P_DO		ap
	P_CIRCLEPLAYER	-16
	P_NEXT
.erev
	P_SET		ap,4
;	P_IMPORT	worldy,Player1_worldy
	P_PUSH		pword1
	P_SETRANDOM	pword1,8191
	P_ADD		pword1,-4095
	P_SET		worldy,pword1
	P_SET		childy,worldy
	P_PULL		pword1
.re_lp
	P_SET		worldy,childy
	P_DISTLESS	3000,.go_far
	P_DISTLESS	8500,.near
	P_MOVEINPLAYER	100
	P_GOTO		.re_lp
.go_far
	P_MOVEINPLAYER	-100
	P_GOTO		.re_lp
.near
	P_IFNOTZERO	slopenum,.no_noroshi
	P_CHILDDEAD	1,.make
	P_IGOTO		.no_noroshi
.make
	P_SPAWN		0,0,0,0,0,0,nullshape,e_noroshi_maker,100,0,1
.no_noroshi
	P_FACEPLAYER	IMMEDIATE
	P_ADD		roty,128
	P_NEG		rotx
	P_INVISIBLE	OFF
	P_RADAROBJ	ra_enemy
	P_SOUNDEFTDISTPOS	en_kururin	;$7b
.face_again
	P_FACEPLAYER
	P_IFNOTZERO	oz,.slow_1
	P_FACEPLAYER
.slow_1
	P_PLAYERINCONE	5,.face_ok
	P_GOTO		.face_again
.face_ok
	P_DO		ox		;2
	P_DO		oy		;32
	P_ADD		rotz,oz		;2
	P_FACEPLAYER
	P_NEXT
	P_GOSUB		sos_fire_must
	P_NEXT
.core_st	LOCAL
	P_GOSUB		.kurun
	P_GOTO		.re_start

.kurun	LOCAL
	P_SOUNDEFTDISTPOS	en_kururin	;$7b
	P_DO		pbyte1			;16
	P_PUSH		rotx
	P_PUSH		roty
	P_FACEPLAYER	IMMEDIATE
	P_SET		childrotx,rotx
	P_SET		childroty,roty
	P_NEG		childrotx
	P_ADD		childroty,128
	P_PULL		roty
	P_PULL		rotx
	P_CHASE		roty,childroty
	P_CHASE		rotx,childrotx
	P_IFNOTZERO	oz,.slow_2
	P_CHASE		roty,childroty
	P_CHASE		rotx,childrotx
.slow_2
	P_NEXT
	P_REMOVE	1
	P_INVISIBLE	ON
	P_WAIT		30
.aga
	P_RANDOMGOTO	.to_st
	P_CIRCLEPLAYER	8
	P_DO		2
	P_MOVEINPLAYER	-100
	P_MOVEINPLAYER	-100
	P_INEXT
	P_GOTO		.aga
.to_st
	P_RETURN
;;;	
;;;	P_END
;;;
.kamereon_1_deadck
	P_FORCE		.dead
	P_RETURN
.dead
	P_TRIGGER	.kamereon_1_deadck,OFF
	P_TRIGGER	kame_face_exp,Always
	P_IMPORT	pbyte2,eaction1
	P_CLRSWITCH	skidy,pbyte2
	P_EXPORT	eaction1,pbyte2
	P_SET		pbyte2,3
	P_GOTO		sos_weak_exp

kame_face_exp
	P_PUSH		roty
	P_PUSH		rotx
	P_FACEVIEW	IMMEDIATE
	P_SET		childroty,roty
	P_PULL		rotx
	P_PULL		roty
	P_CHASE		roty,childroty
	P_RETURN
;;;;------------
;;;;------------
;;;;------------
;;;;------------
;;;shield_kan_hp1	=	90
;;;shield_kan_hp2	=	70
;;;
;;;	START_PATH	e_shield_senkan
;;;
;;;	P_SET		skidy,hp
;;;	P_GOSUB		CurrentSw_Skidy_ck
;;;	P_IFZERO	pword1,.csok
;;;	P_REMOVE
;;;.csok
;;;	P_SOUND		p2_teki_2
;;;	P_SET		roty,ap
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_SET		slopenum,shield_kan_hp1
;;;	P_SET		childrotz,shield_kan_hp2
;;;	P_RANGECHECK	OFF
;;;	P_WEAPON	Elaser
;;;	P_SET		tx,40
;;;
;;;	P_GOSUB		.make_kan_shield
;;;
;;;	P_SPAWN		0,0,-60<<teki_2_scale,0,0,0,boost,e_sp_boost,100,110,4
;;;	P_SETVEL	40
;;;
;;;	P_TRIGGER	.shild_kan_hit,WhenHit
;;;
;;;	P_GOSUB		suihei_hikou
;;;	P_ZERO		tx
;;;.wait_come
;;;	P_DISTLESS	2500,.act
;;;	P_GOTO		.wait_come
;;;.act
;;;	P_REMOVE	4
;;;	P_ACCEL		10,1
;;;	P_TRIGGER	.shild_kan_dist,8
;;;	P_TRIGGER	.shild_kan_atack,16
;;;	P_TRIGGER	.shield_col_ck,Always
;;;
;;;.ck_pl_view
;;;	P_INPLAYERSCONE	-25,25,.turn
;;;	P_GOTO		.ck_pl_view
;;;.turn
;;;	P_PLAYERINCONE	48,.turn_init
;;;	P_PLAYERINCONE	80,.end_turn
;;;.turn_init
;;;	P_SET		childroty,roty
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SET		childrotx,roty
;;;	P_SET		roty,childroty
;;;	P_ZERO		rotx
;;;	P_NEG		childroty
;;;	P_ADD		childroty,childrotx
;;;	P_SET		pbyte1,-1
;;;	P_IFBETWEEN	0,childroty,64,.inc_ry
;;;	P_IFBETWEEN	-128,childroty,-64,.inc_ry
;;;	P_NEG		pbyte1
;;;.inc_ry
;;;	P_PLAYERINCONE	48,.turn_cont
;;;	P_PLAYERINCONE	80,.end_turn
;;;.turn_cont
;;;	P_ADD		roty,pbyte1
;;;	P_GOTO		.inc_ry
;;;.end_turn
;;;	P_WAIT		20
;;;	P_GOTO		.ck_pl_view
;;;	P_END
;;;
;;;.shield_col_ck
;;;	P_PUSH		roty
;;;	P_PUSH		rotx
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_EXPORT	gbyte1,rotx
;;;	P_PULL		rotx
;;;	P_PULL		roty
;;;	P_ZERO		pbyte2
;;;	P_DO		2
;;;	P_INC		pbyte2
;;;	P_BECOMECHILD	pbyte2
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_RETURN
;;;
;;;.shild_kan_dist
;;;	P_WITHINRADIUS	5000,.dist_ok
;;;	P_PUSH		worldy
;;;	P_IMPORT	worldy,Player1_worldy
;;;	P_MOVEINPLAYER	50
;;;	P_PULL		worldy
;;;.dist_ok
;;;	P_RETURN
;;;
;;;.shild_kan_hit
;;;	P_IFBETWEEN	50,hp,127,.mada
;;;	P_FORCE		.dead_on
;;;	P_RETURN
;;;.mada
;;;	P_IFLARGER	hp,slopenum,.life_ok
;;;	P_QSPAWN	smoke,e_sos_almost,2,0
;;;	P_ADD		slopenum,-8
;;;	P_IFLARGER	hp,childrotz,.life_ok
;;;	P_SPAWN		20<<teki_2_scale,-10<<teki_2_scale,0,0,0,0,nullshape,e_noroshi_maker,100,0,3
;;;	P_ZERO		childrotz
;;;.life_ok
;;;	P_RETURN
;;;.dead_on
;;;	P_TRIGGER	marker_set,OFF
;;;	P_TRIGGER	.shild_kan_hit,OFF
;;;	P_TRIGGER	.shild_kan_dist,OFF
;;;	P_TRIGGER	.shield_col_ck,OFF
;;;	P_TRIGGER	.shild_kan_atack,OFF
;;;	P_CLRDEMOSHAPE
;;;	P_GOSUB		dec_EEnemyNumber_skidy
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCREENFLASH
;;;	P_SPAWN		0,0,-60<<teki_2_scale,0,0,0,boost,e_sp_boost,100,110,4
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_ACCEL		80,5
;;;	P_SPAWN		0,0<<teki_2_scale,0,0,0,0,nullshape,e_tekikan_exp_big,100,0,5
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_FLAGCHILD	1
;;;	P_FLAGCHILD	2
;;;	P_COLLISIONS	OFF
;;;
;;;	P_DO		15
;;;	P_RANDOMGOTO	.no_flash
;;;	P_HITFLASHTRIG
;;;.no_flash
;;;	P_NEXT
;;;
;;;	P_TRIGGER	.down,Always
;;;	P_WAIT		10
;;;	P_GOSUB		many_exp_group
;;;	P_CIRCLEWINDOW	1,big			;10
;;;	P_EXPLODE
;;;.down
;;;	P_IFSAME	rotx,64,.only_d
;;;	P_INC		rotx
;;;	P_INC		rotz
;;;.only_d
;;;	P_ADD		worldy,30
;;;	P_RETURN
;;;.shild_kan_atack
;;;	P_DISTLESS	2500,.at
;;;	P_RETURN
;;;.at
;;;	P_PUSH		rotx
;;;	P_PUSH		roty
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_IFBETWEEN	-21,rotx,21,.no_at
;;;	P_SETRANDOM	ox,15
;;;	P_ADD		ox,-7
;;;	P_ADD		rotx,ox
;;;	P_SETRANDOM	ox,15
;;;	P_ADD		ox,-7
;;;	P_ADD		roty,ox
;;;	P_FIRE
;;;.no_at
;;;	P_PULL		roty
;;;	P_PULL		rotx
;;;	P_RETURN
;;;
;;;.make_kan_shield	LOCAL
;;;	P_SPAWN		70<<teki_2_scale,0,0,0,0,0,teki_2_l,e_kan_shield,100,2,1
;;;	P_SPAWN		-70<<teki_2_scale,0,0,0,0,0,teki_2_r,e_kan_shield,100,2,2
;;;	P_RETURN
;;;;------------
;;;	START_PATH	e_kan_shield
;;;
;;;	P_ACTIVE	ON
;;;	P_SHADOW	OFF
;;;	P_INVINCIBLE	ON
;;;	P_IFZERO	ap,.demo
;;;.demo
;;;	P_HITFLASH	OFF
;;;	P_RANGECHECK	OFF
;;;	P_SET		ox,worldy
;;;	P_ADD		ox,40<<teki_2_scale
;;;	P_SET		oy,worldy
;;;	P_ADD		oy,-40<<teki_2_scale
;;;	P_TRIGGER	reflect_laser,Always
;;;	P_TRIGGER	.colli_onoff,Always
;;;	P_TRIGGER	.shield_exp,WhenFlagged
;;;	P_END
;;;.shield_exp
;;;	P_FORCE		.exp_on
;;;	P_RETURN
;;;.exp_on
;;;	P_TRIGGER	.shield_exp,OFF
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,100
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_SET		pbyte1,-15
;;;	P_SET		pbyte2,1
;;;	P_IFSMALLER	childx,childy,.no_neg
;;;	P_NEG		pbyte1
;;;	P_NEG		pbyte2
;;;.no_neg
;;;	P_TRIGGER	.down,Always
;;;	P_WAIT		30
;;;	P_GOSUB		many_exp_group
;;;	P_EXPLODE
;;;.down
;;;	P_ADD		childrotz,pbyte2
;;;	P_ADD		childy,30
;;;	P_ADD		childx,pbyte1
;;;	P_RETURN
;;;	
;;;.colli_onoff
;;;	P_IFBETWEEN	-23,pbyte1,23,.c_on
;;;	P_COLLISIONS	OFF
;;;	P_RETURN
;;;.c_on
;;;	P_COLLISIONS	ON
;;;	P_RETURN
;;;
;;;;------------
;;;kuubo_sp	equ	40			;35
;;;	START_PATH	e_sos_kuubo
;;;
;;;	P_SET		skidy,hp
;;;	P_GOSUB		CurrentSw_Skidy_ck
;;;	P_IFZERO	pword1,.csok
;;;	P_REMOVE
;;;.csok
;;;	P_SET		hp,100
;;;	P_SOUND		p2_tekikan
;;;
;;;	P_TRIGGER	.kan_col_ck,8
;;;	P_SET		oz,hp
;;;	P_SET		roty,ap
;;;	P_SETVEL	kuubo_sp		;55
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_TRIGGER	.kuubo_sp_controll,16
;;;	P_TRIGGER	.hit_ck,WhenHit
;;;	P_RANGECHECK	OFF
;;;	P_SET		slopenum,75
;;;	P_SETRANDOM	weapontype
;;;
;;;	P_GOSUB		suihei_hikou
;;;	P_INC		mx
;;;	P_SET		my,11
;;;	P_TRIGGER	senkan_wave,Always
;;;
;;;	P_INC		childrotz
;;;	P_END
;;;.hit_ck
;;;	P_IFLARGER	hp,slopenum,.one_ok
;;;	P_FORCE		.step_2
;;;.one_ok
;;;	P_RETURN
;;;.step_2
;;;	P_TRIGGER	.hit_ck,OFF
;;;	P_TRIGGER	.hit_ck2,WhenHit
;;;	P_SET		hp,100
;;;	P_SET		tx,95
;;;	P_SET		pbyte1,90
;;;	P_END
;;;.hit_ck2
;;;	P_IFLARGER	hp,tx,.no_almost
;;;	P_QSPAWN	smoke,e_sos_almost,2,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_ADD		tx,-5
;;;.no_almost
;;;	P_IFLARGER	hp,pbyte1,.no_noroshi
;;;	P_ADD		pbyte1,-10
;;;	P_EXPORT	gbyte1,pbyte2
;;;	P_INC		pbyte2
;;;	P_SPAWN		0,0,0,0,0,0,nullshape,e_noroshi_maker,100,0,1
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_INDEX		childx,tekikan_noroshix,pbyte1
;;;	P_INDEX		childy,tekikan_noroshiy,pbyte1
;;;	P_INDEX		childz,tekikan_noroshiz,pbyte1
;;;	P_UNBECOME
;;;.no_noroshi
;;;	P_IFLARGER	hp,slopenum,.two_ok
;;;	P_FORCE		.step_3
;;;.two_ok
;;;	P_RETURN
;;;.step_3
;;;	P_TRIGGER	.hit_ck2,OFF
;;;	P_TRIGGER	.kansaiki,OFF
;;;	P_TRIGGER	marker_set,OFF
;;;	P_TRIGGER	.kuubo_sp_controll,OFF
;;;	P_TRIGGER	senkan_wave,OFF
;;;
;;;	P_GOSUB		dec_EEnemyNumber_skidy
;;;	P_GDEC		b,KEnemyNumber
;;;
;;;	P_CLRDEMOSHAPE
;;;
;;;	P_REMOVE	9
;;;	P_REMOVE	10
;;;	P_COLLISIONS	OFF
;;;
;;;	P_SCREENFLASH
;;;	P_TRIGGER	kani_explode,8			;2
;;;	P_SPAWN		0,0,-600,0,0,0,nullshape,e_tekikan_exp,100,0,1
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_DO		40
;;;	P_IFSAME	rotx,64,.only_d
;;;	P_INC		rotx
;;;	P_INC		rotz
;;;.only_d
;;;	P_ADD		worldy,30
;;;	P_NEXT
;;;
;;;	P_DO		5
;;;	P_ADD		worldy,30
;;;	P_NEXT
;;;
;;;	P_GOSUB		many_exp_group
;;;	P_CIRCLEWINDOW	1,big
;;;
;;;	P_SCORE		sc_kuubo
;;;
;;;	P_EXPLODE
;;;
;;;.kuubo_sp_controll
;;;	P_DISTLESS	7500,.kan_go
;;;	P_GOSUB		make_msg_maker
;;;	P_RETURN
;;;.kan_go
;;;	P_GOSUB		ck_msg_maker
;;;	P_PUSH		pbyte1
;;;	P_DISTMORE	3000,.not_fire2
;;;	P_IMPORT	pbyte1,ebyte3
;;;	P_IFZERO	pbyte1,.my_fire
;;;	P_IFNOTSAME	pbyte1,weapontype,.not_fire
;;;.my_fire
;;;	P_EXPORT	ebyte3,weapontype
;;;	P_RANDOMGOTO	.left_f
;;;	P_IFSAME	shape,teki_3,.teki_3_r
;;;	P_SPAWN		40<<tekikan_scale,-10<<tekikan_scale,0,0,0,0,boost,e_fire_mark,100,40,9
;;;	P_IGOTO		.not_fire
;;;.teki_3_r
;;;	P_SPAWN		50<<teki_3_scale,-10<<teki_3_scale,20<<teki_3_scale,0,0,0,boost,e_fire_mark,100,40,9
;;;	P_IGOTO		.not_fire
;;;.left_f
;;;	P_IFSAME	shape,teki_3,.teki_3_l
;;;	P_SPAWN		-40<<tekikan_scale,-10<<tekikan_scale,0,0,0,0,boost,e_fire_mark,100,40,10
;;;	P_IGOTO		.not_fire
;;;.teki_3_l
;;;	P_SPAWN		-50<<teki_3_scale,-10<<teki_3_scale,20<<teki_3_scale,0,0,0,boost,e_fire_mark,100,40,10
;;;	P_IGOTO		.not_fire
;;;.not_fire2
;;;	P_ZERO		pbyte1
;;;	P_EXPORT	ebyte3,pbyte1
;;;.not_fire
;;;	P_PULL		pbyte1
;;;	P_RETURN
;;;
;;;.kansaiki
;;;	P_DISTMORE	3000,.dont_make
;;;	P_CHILDDEAD	1,.make
;;;	P_RETURN
;;;.make
;;;	P_NEG		childrotz
;;;	P_SPAWN		-50<<tekikan_scale,0,10<<tekikan_scale,0,-7,0,zaco_0,e_kansaiki,2,-4,1
;;;	P_IFSAME	childrotz,1,.right
;;;	P_RETURN
;;;.right
;;;	P_BECOME
;;;	P_NEG		childx
;;;	P_UNBECOME
;;;.dont_make
;;;	P_RETURN
;;;.kan_col_ck
;;;	P_DISTLESS	4000,.set_id_0
;;;	P_SET		coltab,id_3_c&WM
;;;	P_RETURN
;;;.set_id_0
;;;	P_SET		coltab,id_0_c&WM
;;;	P_RETURN
;;;
;;;tekikan_noroshix
;;;	dw	200,-200
;;;tekikan_noroshiy
;;;	dw	-150,-150
;;;tekikan_noroshiz
;;;	dw	600,-600
;;;;------------
;;;	START_PATH	e_kansaiki_2
;;;
;;;	P_INC		skidy
;;;
;;;	START_PATH	e_kansaiki
;;;
;;;	P_RADAROBJ	ra_honmei
;;;	P_RELATIVE	OFF
;;;	P_TRIGGER	.kansaiki_dead,WhenDead
;;;	P_TRIGGER	.kansaiki_ck,8
;;;	P_ALWAYSGENVECS	ON
;;;	P_RANGECHECK	OFF
;;;	P_SET		pbyte1,ap
;;;	P_SET		ap,4
;;;
;;;	P_IFNOTZERO	skidy,.kan_2
;;;
;;;	P_SETVEL	90
;;;	P_WAIT		20
;;;	P_RELTOPLAYER	ON
;;;	P_SETVEL	60
;;;
;;;	P_DO		20
;;;	P_ADD		roty,pbyte1
;;;	P_NEXT
;;;.turn_1
;;;	P_WAIT		1
;;;	P_INPLAYERSCONE	-8,8,.turn_1
;;;
;;;	P_DO		16
;;;	P_ADD		roty,pbyte1
;;;	P_NEXT
;;;
;;;	P_WAIT		15
;;;
;;;.kan_2
;;;	P_SETVEL	90
;;;	P_WAIT		15		;40
;;;	P_RELTOPLAYER	ON
;;;	P_SETVEL	60
;;;	P_DO		120
;;;	P_FACEPLAYER
;;;	P_NEXT
;;;	P_REMOVE
;;;.kansaiki_ck
;;;	P_IMPORT	pbyte2,KEnemyNumber
;;;	P_IFNOTZERO	pbyte2,.ok
;;;	P_FORCE		.dead_own
;;;.ok
;;;	P_RETURN
;;;.dead_own
;;;	P_EXPLODE
;;;.kansaiki_dead
;;;	P_SCORE		sc_kansaiki
;;;	P_RANDOMGOTO	.pass
;;;	P_RANDOMGOTO	.pass
;;;	P_GOSUB		make_hp_item
;;;.pass
;;;	P_RETURN
;;;;------------
;;;	START_PATH	e_tekikan_exp_big
;;;
;;;	P_INVISIBLE	ON
;;;	P_TRIGGER	senkan_explode,8		;2
;;;	P_END
;;;;------------
;;;	START_PATH	e_tekikan_exp
;;;
;;;	P_INVISIBLE	ON
;;;	P_TRIGGER	kani_explode_big,8		;2
;;;	P_END
;;;;------------
	START_PATH	e_sos_baramiss_2

	P_SET		slopenum,1

	START_PATH	e_sos_baramiss

	P_SET		skidy,hp
	P_EXPORT	etemp,skidy
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_GOSUB		set_hp100_ap4_enemy

	P_GOSUB		mk_baramiss_c

	P_SET		pbyte1,2
	P_SPAWN		65<<miss2_scale,0,-100<<miss2_scale,0,0,0,boost,e_sp_boost,100,20,5
	P_SPAWN		-65<<miss2_scale,0,-100<<miss2_scale,0,0,0,boost,e_sp_boost,100,20,6
	P_IFNOTZERO	slopenum,.mis2
	P_ADD		pbyte1,2
	P_SPAWN		0,65<<miss2_scale,-100<<miss2_scale,0,0,0,boost,e_sp_boost,100,20,7
	P_SPAWN		0,-65<<miss2_scale,-100<<miss2_scale,0,0,0,boost,e_sp_boost,100,20,8
.mis2
	P_WAIT		2
	P_IFNOTZERO	pbyte1,.aru
	P_REMOVE
.aru
	P_ADD		rotz,64
	P_RTRIGGER	.bara_m_dead,WhenHit
	P_TRIGGER	pe_sos_dandou.only_rotz,Always
	P_SETVEL	dandou_speed
	P_WAIT		5
	P_RTRIGGER	.bara_c_dead,Always

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_dandou

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128
	P_RTRIGGER	.shap_ck,Always

	P_IGOTO		pe_sos_dandou.dandou_fly
.shap_ck
	P_WITHINRADIUS	5000,.near_shap
	P_SET		shape,miss2_1far
	P_RETURN
.near_shap
	P_SET		shape,miss2_1
	P_RETURN
;---------
.bara_m_dead
	P_FORCE		.life_out
	P_RETURN
.life_out
	P_TRIGGER	.bara_m_dead,OFF
	P_TRIGGER	near_check,OFF
	P_TRIGGER	use_boost_ck,OFF
	P_COLLISIONS	OFF
	P_SETVEL	0
	P_SCORE		sc_bara_miss_main

	P_ZERO		pbyte1
	P_DO		4
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_SET		hp,49
	P_UNBECOME
	P_INEXT
	P_GOSUB		c_unlink_1234
;	P_UNLINKCHILD	1
;	P_UNLINKCHILD	2
;	P_UNLINKCHILD	3
;	P_UNLINKCHILD	4
	P_CIRCLEWINDOW	1,big			;10
	P_EXPLODE


.bara_c_dead
	P_INC		childrotx
	P_IFNOTSAME	childrotx,5,.this
	P_SET		childrotx,1
.this
	P_BECOMECHILD	childrotx
	P_EXPORT	gbyte1,hp
	P_IFSAME	hp,120,.c_live
	P_SET		hp,89
	P_COLLISIONS	OFF
.c_live
	P_UNBECOME
	P_IMPORT	pbyte2,gbyte1
	P_IFSAME	pbyte2,120,.c_ok
	P_FORCE		.barabara
.c_ok
	P_RETURN
.barabara
	P_TRIGGER	.bara_m_dead,OFF
	P_TRIGGER	.bara_c_dead,OFF
	P_COLLISIONS	OFF

	P_REMOVE	5
	P_REMOVE	6
	P_REMOVE	7
	P_REMOVE	8

	P_WAIT		8

	P_TRIGGER	near_check,OFF
	P_TRIGGER	use_boost_ck,OFF
	P_SETVEL	0
	P_RELTOPLAYER	ON

	P_COLLISIONS	OFF

	P_GOSUB		c_flag_1234
;	P_FLAGCHILD	1
;	P_FLAGCHILD	2
;	P_FLAGCHILD	3
;	P_FLAGCHILD	4

.wait_call
	P_IFFLAG	.call_m
	P_GOTO		.wait_call
.call_m
	P_GOSUB		c_unlink_1234
;	P_UNLINKCHILD	1
;	P_UNLINKCHILD	2
;	P_UNLINKCHILD	3
;	P_UNLINKCHILD	4

	P_WAIT		5
	P_EXPLODE

mk_baramiss_c	LOCAL
	P_SPAWN		65<<miss2_scale,0,0,40,0,0,miss2_0,e_bara_miss,120,1,1
	P_GOSUB		.beco
	P_SPAWN		-65<<miss2_scale,0,0,-40,0,0,miss2_0,e_bara_miss,120,2,2
	P_GOSUB		.beco
	P_IFNOTZERO	slopenum,.mis2_0
	P_SPAWN		0,65<<miss2_scale,0,0,40,0,miss2_0,e_bara_miss,120,3,3
	P_GOSUB		.beco
	P_SPAWN		0,-65<<miss2_scale,0,0,-40,0,miss2_0,e_bara_miss,120,4,4
	P_GOSUB		.beco
.mis2_0
	P_RETURN
.beco
	P_BECOME
	P_IMPORT	skidy,etemp
	P_GINC		b,etemp
	P_UNBECOME
	P_RETURN
;;;;------------
	START_PATH	e_bara_miss

	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_ADD		ap,4
	P_BECOMECHILD	ap
	P_INVISIBLE	ON
	P_UNBECOME
	P_BECOMEMOTHER
	P_DEC		pbyte1
	P_UNBECOME
	P_REMOVE
.csok
	P_SET		slopenum,ap
	P_SET		ap,2
	P_CLRDEMOSHAPE
	P_ACTIVE	ON
	P_SET		tx,childrotx
	P_ZERO		childrotx
	P_SET		ty,childroty
	P_ZERO		childroty
	P_SET		pbyte1,90
	P_RADAROBJ	ra_enemy
	P_ALWAYSGENVECS	ON
	P_SHADOW	OFF
	P_RTRIGGER	.bara_on,WhenFlagged
	P_RTRIGGER	.bara_dead,WhenDead
	P_TRIGGER	far_rem_ck,16

.c_loop
	P_IFSMALLER	hp,pbyte1,.jibaku
	P_GOTO		.c_loop
.jibaku
	P_GOSUB		missile_count
	P_SCORE		sc_bara_miss
	P_SET		shape,miss2_exp
	P_TRIGGER	.bara_dead,OFF
	P_EXPLODE
.bara_dead
	P_GOSUB		missile_count
	P_SCORE		sc_bara_miss
	P_SET		shape,miss2_exp
	P_CIRCLEWINDOW	1,big			;10
	P_RETURN
.bara_on
	P_FORCE		.barabara
	P_RETURN
.barabara
	P_TRIGGER	.bara_dead,OFF
	P_TRIGGER	.bara_on,OFF
	P_SOUNDEFTDISTPOS	en_missile_bunri	;$8e
	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
	P_SET		pbyte1,roty
	P_DEC		slopenum
	P_INDEX		slopenum,bara_ang_tab,slopenum
	P_SET		pbyte2,2
	P_RANDOMGOTO	.neg2
	P_NEG		pbyte2
.neg2
	P_DO		10
	P_ADD		childx,tx
	P_ADD		childy,ty
	P_ADD		childroty,slopenum
	P_ADD		childrotx,pbyte2
	P_NEXT

	P_DO		10
	P_ADD		childx,tx
	P_ADD		childy,ty
	P_ADD		childroty,slopenum
	P_ADD		childrotx,pbyte2
	P_CHASE		tx,0
	P_CHASE		ty,0
	P_CHASE		slopenum,0
	P_CHASE		pbyte2,0
	P_NEXT

	P_FLAGMOTHER

	P_WAIT		3

	P_SPAWN		0,0,-100<<miss2_scale,0,0,0,boost,e_sp_boost,100,10,1
	P_ACCEL		20,1
.run_loop
	P_WAIT		1
	P_CHASE		rotx,0
	P_IFNOTZERO	rotx,.run_loop
	P_IFNOTSAME	vel,20,.run_loop

	P_RTRIGGER	.barabara_live,WhenHit
	P_SET		slopenum,110			;95
	P_COLLISIONS	ON
	P_RELTOPLAYER	OFF
	P_SETVEL	70
	P_BECOMECHILD	1
	P_ADD		tx,60
	P_UNBECOME
	P_WAIT		5
	P_ACCEL		dandou_speed,1
	P_BECOMECHILD	1
	P_ADD		tx,-40
	P_UNBECOME

	P_SOUND		p2_dandou
	P_TRIGGER	marker_set,Always
	P_TRIGGER	pe_sos_dandou.only_rotz,Always
	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128

	P_IGOTO		pe_sos_dandou.dandou_fly

.barabara_live
	P_IFLARGER	hp,slopenum,.bara_live_ok
	P_FORCE		.bara_must_exp
.bara_live_ok
	P_RETURN
.bara_must_exp
	P_TRIGGER	.barabara_live,OFF
	P_TRIGGER	near_check,OFF
	P_TRIGGER	use_boost_ck,OFF
	P_REMOVE	1
	P_TRIGGER	down_10,Always
	P_SCREENFLASH
	P_GOSUB		s_group_explode

	P_WAIT		5

	P_GOSUB		.bara_dead
	P_EXPLODE
;bara_ang_tab
;	db	-1,1,3,-3
;;;;------------
dandou_speed	equ	48
	START_PATH	e_sos_dandou

	P_SET		skidy,hp
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_GOSUB		set_hp100_ap4_enemy

	P_SPAWN		0,0,-400,0,0,0,boost,e_sp_boost,100,70,1

	P_SETVEL	dandou_speed		;50

	P_SET		pbyte2,80	;60		;min_hp
	P_SET		slopenum,95	;80		;1st_step
	P_RTRIGGER	.sos_live_ck,WhenHit
	P_RTRIGGER	.only_rotz,Always
	P_TRIGGER	far_rem_ck,16

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_dandou

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128
;----------
.dandou_fly	LOCAL
	P_IMPORT	weapontype,KX_NEARPLANETNUM
	P_IFSAME	weapontype,8,.near_by_planet
	P_SET		my,1
	P_RANDOMGOTO	.lp
	P_NEG		my
.lp
	P_WAIT		50
	P_RANDOMGOTO	.lp
	P_ZERO		pword1
	P_SET		mz,1
	P_RANDOMGOTO	.lr
	P_IFSMALLER	worldy,pword1,.go_up
	P_NEG		mz
.go_up
	P_DO		40
	P_ADD		rotx,mz
	P_NEXT
	P_NEG		mz
	P_WAIT		30
	P_DO		40
	P_ADD		rotx,mz
	P_NEXT
	P_GOTO		.lp
.lr
	P_DO		40
	P_ADD		roty,my
	P_NEXT
	P_NEG		my
	P_WAIT		30
	P_DO		40
	P_ADD		roty,my
	P_NEXT
	P_GOTO		.lp
;-----------
.only_rotz	LOCAL
	P_ADD		rotz,2
	P_RETURN
;-----------
.near_by_planet	LOCAL
	P_SET		weapontype,skidy
	P_DIV2		weapontype
	P_ADD		weapontype,6
	P_DO		weapontype
	P_WAIT		50
	P_NEXT
.view_ck
	P_INPLAYERSCONE	-25,25,.ochiru
	P_GOTO		.view_ck
.ochiru
	P_GOSUB		ochiru_msg
	
;;	P_IMPORT	weapontype,Player_friend
;;	P_IFSAME	weapontype,-1,.no_friend
;;	P_SET		pword1,146
;;	P_ADD		pword1,weapontype
;;	P_MSG		pword1
;;.no_friend
;;	P_IMPORT	pword1,KW_MisMapFlag
;;	P_SET		pbyte1,ef_missilefell
;;	P_SETSWITCH	pbyte1,pword1
;;	P_EXPORT	KW_MisMapFlag,pword1
	P_ACCEL		100,5
	P_RELTOPLAYER	ON
	P_WAITCHASE	rotx,64
.w_dam
	P_SET		pword1,8000
	P_IFLARGER	worldy,pword1,.pl_damage
	P_GOTO		.w_dam
.pl_damage
	P_INVISIBLE	ON
	P_ACCEL		0,50
	P_WAIT		15
	P_SCREENFLASH
	P_WAIT		2
	P_CIRCLEWINDOW	1,big
	P_SOUNDEFTDISTPOS	mis_explode	;$2b*
;	P_IMPORT	pword1,KW_MisMapFlag
;	P_SET		pbyte1,ef_missilefell
;	P_SETSWITCH	pbyte1,pword1
;	P_EXPORT	KW_MisMapFlag,pword1
	P_REMOVE
;-----------
.sos_live_ck
	P_SOUNDEFFECT	RobolandInSea_l	;$19
	P_IFLARGER	hp,slopenum,.live_ok
	P_ADD		slopenum,-5
	P_ADD		vel,-3
	P_BECOMECHILD	1
	P_ADD		tx,-15
	P_UNBECOME
	P_QSPAWN	smoke,e_sos_almost,2,0
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_IFLARGER	hp,pbyte2,.live_ok
	P_FORCE		.next_step
.live_ok
	P_RETURN
.next_step
	P_TRIGGER	.sos_live_ck,OFF
	P_TRIGGER	near_check,OFF
	P_TRIGGER	use_boost_ck,OFF

	P_REMOVE	1

	P_COLLISIONS	OFF
	P_INVINCIBLE	ON
	P_RELTOPLAYER	ON
	P_ALWAYSGENVECS	ON
	P_SETVEL	0

	P_SCREENFLASH

	P_CLRDEMOSHAPE
	P_GOSUB		missile_count
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
	P_SCORE		sc_sos_strong

	P_TRIGGER	kani_explode,4
	P_TRIGGER	exp_smoke,8

	P_ACCEL		0,2

	P_DO		10
	P_ADD		worldy,10
	P_NEXT

	P_IGOTO		sos_explode

;;;;------------
;;;	START_PATH	e_sos_weak_2
;;;
;;;	P_SET		skidy,hp
;;;	P_GOSUB		CurrentSw_Skidy_ck
;;;	P_IFZERO	pword1,.csok
;;;	P_REMOVE
;;;.csok
;;;	P_SET		pword1,worldy
;;;	P_SET		childy,worldy
;;;	P_FINDSHAPE	marker
;;;	P_SHAPEDEAD	.make_core
;;;	P_BECOMESHAPE
;;;	P_EXPORT	gword1,worldy
;;;	P_UNBECOME
;;;	P_IMPORT	worldy,gword1
;;;.core_come
;;;	P_SHAPEDISTLESS	1000,.to_far
;;;.to_near
;;;	P_SHAPEDISTLESS	1000,.back_core
;;;	P_MOVEINSHAPE	50
;;;	P_IGOTO		.to_near
;;;.to_far
;;;	P_MOVEINSHAPE	-50
;;;	P_SHAPEDISTLESS	1000,.to_far
;;;.back_core
;;;	P_TRIGGER	.round_core,Always
;;;	P_GOSUB		init_sos_zaco
;;;	P_INC		pbyte1
;;;	P_TRIGGER	marker_set,Always
;;;	P_TRIGGER	.weak2_roty,Always
;;;	P_TRIGGER	.weak2_dead_ck,WhenHit
;;;
;;;.come_wait
;;;	P_DISTLESS	3500,.to_atack_loop_pp
;;;	P_GOTO		.come_wait
;;;.to_atack_loop_pp
;;;	P_TRIGGER	.round_core,OFF
;;;.to_atack_loop_p
;;;	P_GOSUB		.neg_shape
;;;	P_CHASE		worldy,childy
;;;	P_IFSAME	worldy,childy,.a
;;;	P_GOTO		.to_atack_loop_p
;;;.a
;;;	P_SET		shape,kieru_0
;;;	P_COLLISIONS	ON
;;;.atack_loop
;;;	P_SETRANDOM	childx,511
;;;	P_ADD		childx,1500		;800
;;;	P_RANDOMGOTO	.neg1
;;;	P_NEG		childx
;;;.neg1
;;;	P_SETRANDOM	childz,511
;;;	P_ADD		childz,1500		;800
;;;	P_RANDOMGOTO	.neg2
;;;	P_NEG		childz
;;;.neg2
;;;	P_SETRANDOM	childy,511
;;;	P_ADD		childy,-255
;;;.neg3
;;;	P_RELTOPLAYER	ON
;;;	P_SOUNDEFTDISTPOS	en_kieru	;$8f
;;;	P_DO		5		;10
;;;	P_SET		shape,kieru_0
;;;	P_WAIT		1
;;;	P_SET		shape,kieru_1
;;;	P_NEXT
;;;	P_RELTOPLAYER	OFF
;;;	P_COLLISIONS	OFF
;;;
;;;	P_DO		30
;;;	P_SET		worldy,pword1
;;;	P_SET		ox,childx
;;;	P_SET		oy,childy
;;;	P_SET		oz,childz
;;;	P_PUSH		worldx
;;;	P_PUSH		worldz
;;;	P_PUSH		worldy
;;;	P_COPYPLAYERPOS
;;;	P_ADD		ox,worldx
;;;	P_ADD		oz,worldz
;;;	P_PULL		worldy
;;;	P_PULL		worldz
;;;	P_PULL		worldx
;;;	P_CHASE		worldx,ox
;;;	P_ADD		oy,worldy
;;;	P_CHASE		worldy,oy
;;;	P_CHASE		worldz,oz
;;;	P_FACEPLAYER	y
;;;	P_NEXT
;;;
;;;	P_RELTOPLAYER	ON
;;;	P_DO		5		;10
;;;	P_SET		shape,kieru_1
;;;	P_WAIT		1
;;;	P_SET		shape,kieru_0
;;;	P_NEXT
;;;	P_COLLISIONS	ON
;;;	P_RELTOPLAYER	OFF
;;;
;;;	P_GOSUB		sos_fire_must
;;;
;;;	P_WAIT		20
;;;	P_GOTO		.atack_loop
;;;.weak2_roty
;;;	P_ADD		roty,-20
;;;	P_DISTLESS	6000,.ok_dist
;;;	P_MOVEINPLAYER	50
;;;.ok_dist
;;;	P_RETURN
;;;
;;;.weak2_dead_ck
;;;	P_FORCE		.dead
;;;	P_RETURN
;;;.dead
;;;	P_TRIGGER	.round_core,OFF
;;;	P_TRIGGER	.weak2_roty,OFF
;;;	P_TRIGGER	.weak2_dead_ck,OFF
;;;	P_SET		pbyte2,2
;;;	P_GOTO		sos_weak_exp
;;;
;;;.round_core
;;;	P_CIRCLESHAPE	10
;;;	P_PUSH		pbyte1
;;;	P_INDEX		pbyte1,sintab,slopenum
;;;	P_ADD		worldy,pbyte1
;;;	P_ADD		slopenum,8
;;;	P_PULL		pbyte1
;;;	P_PUSH		worldy
;;;	P_BECOMESHAPE
;;;	P_EXPORT	gword1,worldy
;;;	P_UNBECOME
;;;	P_IMPORT	worldy,gword1
;;;	P_SHAPEDISTLESS	1000,.go_far
;;;	P_MOVEINSHAPE	10
;;;	P_PULL		worldy
;;;	P_RETURN
;;;.go_far
;;;	P_MOVEINSHAPE	-10
;;;	P_PULL		worldy
;;;	P_RETURN
;;;.make_core
;;;	P_EXPORT	gbyte1,ap
;;;	P_ADD		worldx,1000
;;;	P_QSPAWN	marker,e_weak_2_core,100,0
;;;	P_FINDSHAPE	marker
;;;	P_ADD		worldx,-1000
;;;	P_BECOME
;;;	P_IMPORT	roty,gbyte1
;;;	P_UNBECOME
;;;	P_IGOTO		.back_core
;;;.neg_shape
;;;	P_IFSAME	shape,kieru_0,.to_1
;;;	P_SET		shape,kieru_0
;;;	P_RETURN
;;;.to_1
;;;	P_SET		shape,kieru_1
;;;	P_RETURN
;;;;-----------
;;;	START_PATH	e_weak_2_core
;;;
;;;	P_ALWAYSGENVECS	ON
;;;	P_INVISIBLE	ON
;;;	P_SETVEL	40
;;;	P_END
;;;;-----------
;;;	START_PATH	e_sos_weak_1
;;;
;;;	P_SET		skidy,hp
;;;	P_GOSUB		CurrentSw_Skidy_ck
;;;	P_IFZERO	pword1,.csok
;;;	P_REMOVE
;;;.csok
;;;	P_SOUND		p2_sos_0
;;;	P_SET		roty,ap
;;;	P_GOSUB		init_sos_zaco
;;;	P_TRIGGER	.sos_weak_hit,WhenHit
;;;	
;;;	P_TRIGGER	marker_set,Always
;;;
;;;	P_GOSUB		sos_0_boost
;;;	P_SET		pbyte1,1
;;;	P_SETVEL	40		;50
;;;
;;;.run
;;;	P_DISTLESS	3500,.start
;;;	P_IMPORT	pbyte2,ebyte2
;;;	P_IFSAME	pbyte2,pbyte1,.start
;;;	P_GOTO		.run
;;;
;;;.start
;;;	P_EXPORT	ebyte2,pbyte1
;;;	P_INVISIBLE	OFF
;;;	P_FLAGCHILD	1
;;;	P_WAIT		1
;;;	P_BECOMECHILD	1
;;;	P_ADD		tx,40
;;;	P_UNBECOME
;;;	P_FLAGCHILD	1
;;;	P_SETVEL	90
;;;	P_SPACESHIP	ON
;;;	P_GOSUB		.rand_crzq
;;;	P_SET		childroty,20
;;;.first_lp
;;;	P_IMPORT	pword1,Player1_Worldy
;;;	P_IFSMALLER	worldy,pword1,.down_face
;;;	P_CHASE		rotx,-32
;;;	P_IGOTO		.same_face
;;;.down_face
;;;	P_CHASE		rotx,32
;;;.same_face
;;;	P_CHASE		rotz,childrotz
;;;	P_PLAYERINCONE	5,.come_loop_to
;;;	P_GOTO		.first_lp
;;;.come_loop_to	LOCAL
;;;	P_RELTOPLAYER	OFF
;;;	P_SPACESHIP	OFF
;;;
;;;	P_WEAPON	RelElaser_hsp
;;;	P_GOSUB		egu_fire_sub
;;;
;;;	P_DISTMORE	4000,.pass_face
;;;	P_DISTLESS	3000,.pass_face
;;;	P_PUSH		roty
;;;	P_FACEPLAYER
;;;	P_PULL		roty
;;;.pass_face
;;;	P_CHASE		rotz,0
;;;	P_IFNOTZERO	childroty,.come_loop_to1
;;;	P_IFZERO	rotz,.again
;;;	P_GOTO		.come_loop_to
;;;.come_loop_to1
;;;	P_DEC		childroty
;;;	P_GOTO		.come_loop_to
;;;
;;;.come_loop_again
;;;	P_TRIGGER	.spiral,Always
;;;.come_loop
;;;	P_DISTMORE	4000,.too_far
;;;	P_FACEPLAYER
;;;	P_DISTLESS	2000,.near
;;;	P_INC		pbyte2
;;;	P_IFSAME	pbyte2,40,.not_fire
;;;	P_GOTO		.come_loop
;;;.too_far
;;;	P_MOVEINPLAYER	50
;;;	P_GOTO		.come_loop
;;;.near
;;;	P_GOSUB		sos_fire_sub
;;;.not_fire
;;;	P_TRIGGER	.spiral,OFF
;;;.sp_again
;;;	P_IFZERO	rotz,.end_spiral
;;;	P_ADD		rotz,childrotz
;;;	P_GOTO		.sp_again
;;;.end_spiral
;;;	P_ZERO		pbyte2
;;;	P_SET		childrotz,8
;;;	P_RANDOMGOTO	.rev
;;;	P_NEG		childrotz
;;;.rev
;;;	P_SETRANDOM	childroty,31
;;;	P_ADD		childroty,-16
;;;
;;;	P_SPACESHIP	ON
;;;	P_DO		8
;;;	P_ADD		rotz,childrotz
;;;	P_CHASE		rotx,childroty
;;;	P_NEXT
;;;	P_NEG		childrotz
;;;	P_DO		8
;;;	P_ADD		rotz,childrotz
;;;	P_CHASE		rotx,childroty
;;;	P_NEXT
;;;.again
;;;	P_RELTOPLAYER	ON
;;;	P_SPACESHIP	ON
;;;	P_WAIT		1
;;;	P_CHASE		rotx,0
;;;	P_DISTLESS	3000,.again
;;;	P_GOSUB		.rand_crz
;;;
;;;	P_INPLAYERSCONE	-25,25,.face_con
;;;	P_SET		childrotz,-8
;;;	P_INPLAYERSCONE	-128,-25,.face_con
;;;	P_NEG		childrotz
;;;.face_con
;;;	P_CHASE		rotz,childrotz
;;;	P_CHASE		rotx,0
;;;	P_PLAYERINCONE	5,.face_on
;;;	P_GOTO		.face_con
;;;.face_on
;;;	P_SPACESHIP	OFF
;;;	P_SET		pbyte1,1
;;;	P_IFBETWEEN	-1,rotz,127,.wc16
;;;	P_SET		childrotz,-16
;;;	P_WAITCHASE	rotz,-16
;;;	P_GOTO		.come_loop_again
;;;.wc16
;;;	P_SET		childrotz,16
;;;	P_WAITCHASE	rotz,16
;;;	P_GOTO		.come_loop_again
;;;.spiral
;;;	P_ADD		rotz,childrotz
;;;	P_RETURN
;;;;------------
;;;.rand_crzq
;;;	P_SET		childrotz,32
;;;	P_IGOTO		.sz
;;;.rand_crz
;;;	P_SET		childrotz,15
;;;.sz
;;;	P_RANDOMGOTO	.not_neg_z
;;;	P_NEG		childrotz
;;;.not_neg_z
;;;	P_RETURN
;;;
;;;.sos_weak_hit	LOCAL
;;;	P_FORCE		.dead
;;;	P_RETURN
;;;.dead
;;;	P_TRIGGER	.sos_weak_hit,OFF
;;;	P_SET		pbyte2,1
sos_weak_exp
	P_REMOVE	1

kamereon_weak_exp
	P_COLLISIONS	OFF
	P_RELTOPLAYER	OFF
	P_SCORE		sc_sos_weak
	P_GOSUB		fighter_count
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
;	P_CLRDEMOSHAPE
;	P_SCREENFLASH
	P_GOSUB		group_explode

	P_RANDOMGOTO	.pass
	P_RANDOMGOTO	.pass
	P_GOSUB		make_hp_item
.pass
	P_EXPLODE
;;;
;;;;------------
;;;	START_PATH	e_sos_strong_2
;;;
;;;	P_SET		skidy,hp
;;;	P_GOSUB		CurrentSw_Skidy_ck
;;;	P_IFZERO	pword1,.csok
;;;	P_REMOVE
;;;.csok
;;;	P_IMPORT	roty,Kinitroty
;;;	P_ALWAYSGENVECS	ON
;;;	P_SETVEL	55
;;;	P_SOUND		p2_sos_2
;;;	P_SET		pbyte2,1
;;;	P_EXPORT	gbyte2,pbyte2
;;;	P_SET		pword1,-130
;;;	P_SET		pbyte1,70
;;;	P_GOSUB		make_boost
;;;	P_ZERO		pword1
;;;	P_GOSUB		init_sos_zaco
;;;	P_TRIGGER	marker_set,ALways
;;;
;;;	P_WEAPON	RelEplasma1
;;;	P_SET		pbyte2,60		;min_hp
;;;	P_SET		slopenum,80		;1st_step
;;;	P_TRIGGER	.sos_live_ck,WhenHit
;;;	P_INC		pbyte1
;;;
;;;.wait_loop
;;;	P_DISTLESS	2000,.go_b
;;;	P_GOTO		.wait_loop
;;;
;;;.go_b
;;;	P_FLAGCHILD	1
;;;	P_WAIT		5
;;;	P_BECOMECHILD	1
;;;	P_ADD		tx,30
;;;	P_UNBECOME
;;;	P_FLAGCHILD	1
;;;	P_WAIT		5
;;;	P_BECOMECHILD	1
;;;	P_ADD		tx,-30
;;;	P_UNBECOME
;;;	P_FLAGCHILD	1
;;;	P_WAIT		1
;;;.go
;;;	P_FLAGCHILD	1
;;;	P_TRIGGER	.sos_dist_keep,Always
;;;	P_RELTOPLAYER	ON
;;;	P_SPACESHIP	ON
;;;
;;;	P_INPLAYERSCONE	0,127,.pos_st_l
;;;	P_SET		childrotz,4
;;;	P_SET		mz,-4
;;;	P_SET		childrotx,-64
;;;	P_SET		tx,16
;;;	P_SET		ty,2
;;;	P_IGOTO		.same_lr
;;;.pos_st_l
;;;	P_SET		childrotz,4
;;;	P_SET		mz,4
;;;	P_SET		childrotx,64
;;;	P_SET		tx,-16
;;;	P_SET		ty,-2
;;;.same_lr
;;;	P_GOSUB		.z_turn
;;;	P_WAIT		1
;;;	P_SPACESHIP	OFF
;;;	P_ACCEL		40,5
;;;	P_WAIT		10
;;;	P_SETVEL	0
;;;	P_TRIGGER	.st2_damy_spawn,8
;;;.round_r
;;;	P_INPLAYERSCONE	96,160,.atack_on
;;;	P_INC		pword1
;;;	P_IFSAME	pword1,50,.atack_on
;;;	P_CHASE		rotz,tx
;;;	P_GOSUB		.new_roty
;;;	P_CIRCLEPLAYER	ty
;;;	P_GOTO		.round_r
;;;.atack_on
;;;	P_TRIGGER	.st2_damy_spawn,OFF
;;;	P_TRIGGER	.sos_dist_keep,OFF
;;;	P_FLAGCHILD	1
;;;	P_RELTOPLAYER	ON
;;;
;;;	P_SET		pbyte1,32
;;;.at_again
;;;	P_DO		60
;;;	P_FACEPLAYER
;;;	P_CHASE		rotz,0
;;;	P_GOSUB		sos_fire_sub
;;;	P_NEXT
;;;.pass_player
;;;	P_ACCEL		80,2
;;;.to_start
;;;	P_ZERO		pword1
;;;	P_SETVEL	40
;;;	P_WAITCHASE	rotx,0
;;;	P_SPACESHIP	ON
;;;	P_SET		childrotz,9
;;;	P_SET		mz,4
;;;	P_GOSUB		.z_turn
;;;	P_SPACESHIP	OFF
;;;	P_GOTO		.go
;;;
;;;.new_roty
;;;	P_PUSH		roty
;;;	P_PUSH		rotx
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SET		childroty,roty
;;;	P_PULL		rotx
;;;	P_PULL		roty
;;;	P_ADD		childroty,childrotx
;;;	P_CHASE		roty,childroty
;;;	P_CHASE		roty,childroty
;;;	P_RETURN
;;;
;;;.sos_dist_keep
;;;	P_DISTLESS	1400,.too_near	;1000
;;;	P_DISTLESS	1800,.keep	;2000
;;;	P_MOVEINPLAYER	30
;;;.keep
;;;	P_RETURN
;;;.too_near
;;;	P_MOVEINPLAYER	-30
;;;	P_RETURN
;;;
;;;.sos_live_ck
;;;	P_IFLARGER	hp,slopenum,.live_ok
;;;	P_ADD		slopenum,-5
;;;	P_QSPAWN	smoke,e_sos_almost,3,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_IFLARGER	hp,pbyte2,.live_ok
;;;	P_FORCE		.next_step
;;;.live_ok
;;;	P_RETURN
;;;.next_step
;;;	P_REMOVE	1
;;;	P_TRIGGER	.sos_live_ck,OFF
;;;	P_TRIGGER	.sos_dist_keep,OFF
;;;	P_IGOTO		next_step_same
;;;.z_turn
;;;	P_DO		childrotz
;;;	P_ADD		rotz,mz
;;;	P_NEXT
;;;	P_WAIT		8
;;;	P_NEG		mz
;;;	P_DO		childrotz
;;;	P_ADD		rotz,mz
;;;	P_NEXT
;;;	P_RETURN
;;;.st2_damy_spawn
;;;	P_PUSH		pbyte1
;;;	P_IMPORT	pbyte1,KDifficulty
;;;	P_IFSAME	pbyte1,dif_easy,.not_spawn
;;;	P_QSPAWN	sos_2,e_strong2_c,100,4
;;;.not_spawn
;;;	P_PULL		pbyte1
;;;	P_RETURN
;;;;------------
;;;	START_PATH	e_strong2_c
;;;
;;;	P_HITFLASH	OFF
;;;	P_WEAPON	RelEplasma1
;;;	P_SET		coltab,id_1_c&WM
;;;	P_TRIGGER	.rem,WhenHit
;;;	P_DO		25
;;;	P_FACEPLAYER
;;;	P_NEXT
;;;	P_FIRE
;;;	P_WAIT		10
;;;.rem_on
;;;	P_REMOVE
;;;.rem
;;;	P_FORCE		.rem_on
;;;	P_RETURN
;;;;------------
;;;	START_PATH	e_sos_strong_1
;;;
;;;	P_SET		skidy,hp
;;;	P_GOSUB		CurrentSw_Skidy_ck
;;;	P_IFZERO	pword1,.csok
;;;	P_REMOVE
;;;.csok
;;;	P_SOUND		p2_sos_1
;;;	P_SET		roty,ap
;;;	P_GOSUB		init_sos_zaco
;;;
;;;	P_TRIGGER	marker_set,Always
;;;	P_WEAPON	RelEplasma1
;;;	P_SET		pbyte2,60		;min_hp
;;;	P_SET		slopenum,80		;1st_step
;;;	P_TRIGGER	.sos_live_ck,WhenHit
;;;	P_SETVEL	48	;50
;;;.wait_loop
;;;	P_DISTLESS	5000,.go1
;;;	P_GOTO		.wait_loop
;;;.go1
;;;	P_TRIGGER	sos_rel_ck,Always
;;;	P_ZERO		pword1
;;;	P_SPACESHIP	ON
;;;	P_WAITCHASE	rotz,-16
;;;.tu
;;;	P_PLAYERINCONE	5,.go2
;;;	P_GOTO		.tu
;;;.go2
;;;	P_SPACESHIP	OFF
;;;	P_WAITCHASE	rotz,0
;;;.come_loop
;;;	P_GOSUB		sos_fire_sub		;using pbyte1
;;;
;;;	P_DISTLESS	1500,.near
;;;	P_DISTMORE	4000,.a
;;;	P_SETVEL	40
;;;	P_FACEPLAYER
;;;	P_GOTO		.come_loop
;;;.a
;;;	P_SETVEL	0
;;;	P_MOVEINPLAYER	50
;;;	P_GOTO		.come_loop
;;;.near
;;;	P_IMPORT	pword1,Player1_worldy
;;;	P_NEG		pword1
;;;	P_ADD		pword1,worldy
;;;	P_IFNOTBETWEEN	-500,pword1,500,.through
;;;	P_SET		pword1,2
;;;	P_SET		mx,2
;;;	P_RANDOMGOTO	.d
;;;	P_NEG		pword1
;;;.d
;;;	P_RANDOMGOTO	.r
;;;	P_NEG		mx
;;;.r
;;;	P_DO		32
;;;	P_ADD		rotx,pword1
;;;	P_ADD		roty,mx
;;;	P_NEXT
;;;	P_NEG		pword1
;;;	P_DO		32
;;;	P_ADD		rotx,pword1
;;;	P_ADD		roty,mx
;;;	P_NEXT
;;;
;;;	P_ZERO		pword1
;;;	P_IGOTO		.wait_far
;;;.through
;;;	P_ZERO		pword1
;;;	P_WAITCHASE	rotx,0
;;;.wait_far
;;;	P_BELOWPLAYER	.do
;;;	P_WAITCHASE	rotx,32
;;;.rdo
;;;	P_DISTMORE	3000,.out
;;;	P_INC		pword1
;;;	P_IFSAME	pword1,60,.out
;;;	P_GOTO		.rdo
;;;.do
;;;	P_WAITCHASE	rotx,-32
;;;	P_IGOTO		.rdo
;;;.out
;;;	P_WAITCHASE	rotx,0
;;;	P_WAITCHASE	rotz,30
;;;	P_SPACESHIP	ON
;;;.face_lp
;;;	P_PLAYERINCONE	5,.f_on
;;;	P_GOTO		.face_lp
;;;.f_on
;;;	P_SPACESHIP	OFF
;;;	P_WAITCHASE	rotz,0
;;;	P_SET		pbyte1,1
;;;	P_GOTO		.come_loop
;;;.sos_live_ck
;;;	P_IFLARGER	hp,slopenum,.live_ok
;;;	P_ADD		slopenum,-5
;;;	P_QSPAWN	smoke,e_sos_almost,3,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_IFLARGER	hp,pbyte2,.live_ok
;;;	P_FORCE		.next_step
;;;.live_ok
;;;	P_RETURN
;;;.next_step
;;;	P_TRIGGER	.sos_live_ck,OFF
;;;	P_TRIGGER	sos_rel_ck,OFF
;;;next_step_same
;;;	P_COLLISIONS	OFF
;;;	P_INVINCIBLE	ON
;;;	P_RELTOPLAYER	ON
;;;	P_ALWAYSGENVECS	ON
;;;	P_SETVEL	0
;;;
;;;	P_TRIGGER	kani_explode,4
;;;	P_TRIGGER	exp_smoke,8
;;;
;;;	P_PUSH		rotx
;;;	P_PUSH		roty
;;;	P_PUSH		rotz
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SET		childroty,roty
;;;	P_PULL		rotz
;;;	P_PULL		roty
;;;	P_PULL		rotx
;;;	P_ADD		childroty,128
;;;.rot_again
;;;	P_SETVEL	20
;;;	P_IFSAME	roty,childroty,.wait_again
;;;	P_CHASE		roty,childroty
;;;	P_CHASE		rotz,0
;;;	P_GOTO		.rot_again
;;;
;;;.wait_again
;;;	P_DO		10
;;;	P_ADD		rotx,2
;;;	P_ADD		rotz,-2
;;;	P_ADD		worldy,10
;;;	P_NEXT
;;;	P_CLRDEMOSHAPE
;;;	P_GOSUB		dec_EEnemyNumber_skidy
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCORE		sc_sos_strong
;;;	P_IGOTO		sos_explode
;;;;ษออออออออออออออป
;;;;บ TARGET ENEMY บ
;;;;ศออออออออออออออผ
;;;	START_PATH	e_gengoro_target
;;;
;;;	P_GOSUB		set_child_xyz
;;;
;;;	P_SET		skidy,roty
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_CLIPPING	ON
;;;	P_SHADOW	OFF
;;;	P_WEAPON	ELaser
;;;	P_TRIGGER	.gengoro_dead,WhenHit		;Dead
;;;	P_TRIGGER	anim_add_12_sui,Always
;;;	P_SET		pword1,-1000
;;;
;;;.gengoro_start
;;;	P_SETVEL	20
;;;	P_ACCEL		0,2
;;;	P_FACEPLAYER	y
;;;	P_SET		rotx,32
;;;	P_PLAYERINCONE	10,.gengoro_on
;;;	P_GOTO		.gengoro_start
;;;.gengoro_on
;;;	P_TRIGGER	.water_up,Always
;;;.re_start
;;;	P_SETVEL	50
;;;	P_ACCEL		0,2
;;;.down_loop
;;;	P_HITGROUND	150,.atack_under
;;;	P_IFZERO	vel,.flow
;;;	P_GOTO		.down_loop
;;;.flow
;;;	P_WAIT		15
;;;	P_GOTO		.re_start
;;;
;;;.atack_under
;;;	P_DO		30
;;;	P_FACEPLAYER
;;;	P_NEXT
;;;
;;;	P_SETVEL	30
;;;.come_more
;;;	P_GOSUB		.is_gengoro_far
;;;	P_INC		pbyte1
;;;	P_IFSAME	pbyte1,127,.atack_un_on
;;;	P_DISTLESS	600,.atack_un_on
;;;	P_FACEPLAYER
;;;	P_GOTO		.come_more
;;;.atack_un_on
;;;	P_ZERO		pbyte1
;;;	P_SETVEL	0
;;;	P_DO		3
;;;	P_GOSUB		.under_sea_atack
;;;	P_DO		20
;;;	P_FACEPLAYER
;;;	P_NEXT
;;;	P_INEXT
;;;
;;;	P_GOSUB		.is_gengoro_far
;;;
;;;.out_water
;;;	P_FACEPLAYER	y
;;;	P_CHASE		rotx,-32
;;;	P_IFSAME	rotx,-32,.out_go
;;;	P_GOTO		.out_water
;;;.out_go
;;;	P_IMPORT	oy,Player1_Worldy
;;;	P_IFLARGER	oy,pword1,.deru_ck
;;;	P_PUSH		worldy
;;;	P_SET		worldy,oy
;;;	P_DISTLESS	1500,.to_out_water
;;;	P_PULL		worldy
;;;	P_SET		worldy,-800
;;;	P_IGOTO		.out_ok
;;;.to_out_water
;;;	P_RELTOPLAYER	ON
;;;	P_MOVEINPLAYER	-50
;;;	P_PULL		worldy
;;;	P_GOTO		.out_water
;;;.out_ok
;;;	P_INPLAYERSCONE	-25,25,.deru_ck
;;;	P_GOTO		.out_water
;;;.deru_ck
;;;	P_RELTOPLAYER	OFF
;;;	P_TRIGGER	.water_up,OFF
;;;	P_ACCEL		20,2			;40,2
;;;.out_loop
;;;	P_IFSMALLER	worldy,pword1,.now_out
;;;	P_GOTO		.out_loop
;;;.now_out
;;;	P_SOUNDEFTDISTPOS	en_outmarine	;$89
;;;	P_GOSUB		.gengoro_in_out
;;;	P_DO		40		;20
;;;	P_CHASE		rotx,0
;;;	P_NEXT
;;;.in_loop
;;;	P_CHASE		rotx,32
;;;	P_IFLARGER	worldy,pword1,.now_in
;;;	P_GOTO		.in_loop
;;;.now_in
;;;	P_SOUNDEFTDISTPOS	en_inmarine	;$88
;;;	P_GOSUB		.gengoro_in_out
;;;	P_DO		20
;;;	P_CHASE		rotx,32
;;;	P_NEXT
;;;	P_GOTO		.gengoro_start
;;;;----------
;;;.is_gengoro_far
;;;	P_GOSUB		put_marker
;;;	P_EXPORT	gword3,childy
;;;	P_BECOME
;;;	P_FINDSHAPE	suisui
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldy,gword3
;;;	P_IMPORT	worldz,gword2
;;;	P_UNBECOME
;;;	P_SHAPEDISTLESS	1500,.near
;;;	P_ACCEL		40,2
;;;.return_loop
;;;	P_SHAPEDISTLESS	300,.back_near
;;;	P_FACESHAPE
;;;	P_GOTO		.return_loop
;;;.back_near
;;;	P_FLAGSHAPE
;;;	P_RETURN
;;;.near
;;;	P_FLAGSHAPE
;;;	P_RETURN
;;;.gengoro_in_out
;;;	P_IMPORT	oy,Player1_Worldy
;;;	P_IFLARGER	oy,pword1,.pass_splash1
;;;	P_QSPAWN	splash,e_sp_splash,8,50
;;;	P_BECOME
;;;	P_SET		worldy,-1000
;;;	P_UNBECOME
;;;.pass_splash1
;;;	P_RETURN
;;;
;;;.under_sea_atack
;;;	P_IMPORT	oy,Player1_Worldy
;;;	P_IFNOTBETWEEN	-1000,oy,0,.pass_un_at
;;;	P_PUSH		rotx
;;;	P_GOSUB		immed_fire
;;;	P_PULL		rotx
;;;.pass_un_at
;;;	P_RETURN
;;;.water_up
;;;	P_IMPORT	oy,Player1_Worldy
;;;	P_IFLARGER	oy,pword1,.p_under_sea
;;;	P_IFBETWEEN	-300,worldy,0,.sea_not_top
;;;	P_SET		worldy,-300
;;;	P_RETURN
;;;.p_under_sea
;;;	P_IFBETWEEN	-800,worldy,0,.sea_not_top
;;;	P_SET		worldy,-800
;;;.sea_not_top
;;;	P_ADD		worldy,-5
;;;	P_RETURN
;;;
;;;.gengoro_dead
;;;	P_SCORE		sc_gengoro
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.gengoro_dead,OFF
;;;	P_IGOTO		final_enemy_demo
;;;;-----------
	START_PATH	e_wakidashi_amenbo

	P_GOSUB		wakidashi_init
	P_TRIGGER	wakidashi_dead,WhenHit
	P_GOSUB		sea_init_above_canhit
	P_RTRIGGER	.sl_ck,Always
	P_WEAPON	ELaser
	P_SET		pword1,-1000

	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		110,40,100,0,0,0,splash,e_sp_stay_splash,8,135,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childx,ame_sp_x,pbyte1
	P_INDEX		childz,ame_sp_z,pbyte1
	P_INC		pbyte1
	P_SETID		pbyte1
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
;	P_SPAWN		110,40,100,0,0,0,splash,e_sp_stay_splash,8,135,1
;	P_SPAWN		120,40,-110,0,0,0,splash,e_sp_stay_splash,8,135,2
;	P_SPAWN		-110,40,100,0,0,0,splash,e_sp_stay_splash,8,135,3
;	P_SPAWN		-120,40,-110,0,0,0,splash,e_sp_stay_splash,8,135,4
.re_start_ck
	P_RTRIGGER	.amenbo_atack,64
.re_start
	P_SETRANDOM	pbyte1
.muki_loop
	P_CHASE		roty,pbyte1
	P_IFSAME	roty,pbyte1,.go
	P_GOTO		.muki_loop
.go
	P_ABOVEPLAYER	.nos
	P_SOUNDEFTDISTPOS	en_amenbo_walk	;$6a
.nos
	P_SETVEL	50
	P_ACCEL		0,1
	P_WAIT		50
	P_GOTO		.re_start

.amenbo_atack
	P_BELOWPLAYER	.can_atack
	P_RETURN
.can_atack
	P_RANDOMGOTO	.cant_atack
	P_FORCE		.atack_on
.cant_atack
	P_RETURN
.atack_on
	P_TRIGGER	.amenbo_atack,OFF

	P_DO		3
.face_p
	P_FACEPLAYER	y
	P_PLAYERINCONE	5,.fire_on
	P_GOTO		.face_p
.fire_on
	P_ADD		worldy,-50
	P_GOSUB		sos_fire_must
	P_ADD		worldy,50
	P_WAIT		5
	P_NEXT
	P_GOTO		.re_start_ck
.sl_ck
	P_HITSLOPE	wakidashi_dead_no_sc
	P_RETURN

;;;	START_PATH	e_amenbo_target
;;;
;;;	P_GOSUB		set_child_xyz
;;;;-----------
;;;	P_SET		skidy,roty
;;;	
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_WEAPON	ELaser
;;;	P_GOSUB		sea_init_above_canhit
;;;	P_RANGECHECK	OFF
;;;	P_SET		pword1,-1000
;;;
;;;	P_SPAWN		110,40,100,0,0,0,splash,e_sp_stay_splash,8,135,1
;;;	P_SPAWN		120,40,-110,0,0,0,splash,e_sp_stay_splash,8,135,2
;;;	P_SPAWN		-110,40,100,0,0,0,splash,e_sp_stay_splash,8,135,3
;;;	P_SPAWN		-120,40,-110,0,0,0,splash,e_sp_stay_splash,8,135,4
;;;
;;;	P_TRIGGER	.amenbo_dead,WhenHit		;Dead
;;;.re_start_ck
;;;	P_TRIGGER	.amenbo_atack,64
;;;.re_start
;;;	P_SETRANDOM	pbyte1
;;;.muki_loop
;;;	P_CHASE		roty,pbyte1
;;;	P_IFSAME	roty,pbyte1,.go
;;;	P_GOTO		.muki_loop
;;;.go
;;;	P_ABOVEPLAYER	.nos
;;;	P_SOUNDEFTDISTPOS	en_amenbo_walk	;$6a
;;;.nos
;;;	P_SETVEL	50
;;;	P_ACCEL		0,1
;;;	P_WAIT		50
;;;	P_GOTO		.re_start
;;;
;;;	P_END
;;;
;;;.amenbo_area_ck
;;;	P_GOSUB		put_marker
;;;	P_INC		tx
;;;	P_BECOME
;;;	P_FINDSHAPE	amenbo
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldz,gword2
;;;	P_UNBECOME
;;;	P_SHAPEDISTLESS	1500,.area_ok
;;;	P_FORCE		.back_home
;;;	P_RETURN
;;;.area_ok
;;;	P_FLAGSHAPE
;;;	P_DEC		tx
;;;	P_RETURN
;;;.back_home
;;;	P_TRIGGER	.amenbo_atack,OFF
;;;
;;;	P_ACCEL		0,2
;;;	P_WAIT		25
;;;.move_again
;;;	P_SETVEL	50
;;;	P_ACCEL		0,2
;;;	P_DO		25
;;;	P_FACESHAPE
;;;	P_NEXT
;;;	P_SHAPEDISTLESS	200,.come_near
;;;	P_GOTO		.move_again
;;;.come_near
;;;	P_FLAGSHAPE
;;;	P_DEC		tx
;;;	P_GOTO		.re_start_ck
;;;
;;;.amenbo_atack
;;;	P_BELOWPLAYER	.can_atack
;;;	P_IGOTO		.amenbo_area_ck
;;;.can_atack
;;;	P_IFNOTZERO	pbyte2,.cant_at
;;;	P_FORCE		.atack_on
;;;	P_SET		pbyte2,5		;wait_4_timer
;;;	P_RETURN
;;;.cant_at
;;;	P_DEC		pbyte2
;;;	P_IGOTO		.amenbo_area_ck
;;;.atack_on
;;;	P_TRIGGER	.amenbo_atack,OFF
;;;
;;;	P_DO		3
;;;.face_p
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	5,.fire_on
;;;	P_GOTO		.face_p
;;;.fire_on
;;;	P_ADD		worldy,-50
;;;	P_GOSUB		immed_fire
;;;	P_ADD		worldy,50
;;;	P_ZERO		rotx
;;;	P_WAIT		30
;;;	P_NEXT
;;;	P_GOTO		.re_start_ck
;;;	
;;;.amenbo_dead	
;;;	P_REMOVE	1
;;;	P_REMOVE	2
;;;	P_REMOVE	3
;;;	P_REMOVE	4
;;;	P_SCORE		sc_amenbo
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.amenbo_atack,OFF
;;;	P_TRIGGER	.amenbo_dead,OFF
;;;	P_IGOTO		final_enemy_demo
;;;;------------
;;;	START_PATH	e_kurage_sea_1
;;;
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_SET		rotx,128
;;;	P_SET		slopenum,50		;minimam hp
;;;	P_SET		mx,2
;;;	P_INVISIBLE	ON
;;;	P_TRIGGER	i_sea_pl_in_sea,BelowSea
;;;	P_TRIGGER	i_sea_pl_out_sea,AboveSea
;;;
;;;	P_TRIGGER	.kurage_sea_hit,WhenHit
;;;
;;;	P_SETANIM	7
;;;	P_END
;;;
;;;.kurage_sea_hit
;;;	P_SET		hp,120
;;;	P_FORCE		.kurage_get_up
;;;	P_RETURN
;;;.kurage_get_up
;;;	P_SOUNDEFTDISTPOS	en_kurage_getup	;$7d*
;;;	P_TRIGGER	.kurage_sea_hit,OFF
;;;.get_up
;;;	P_IFSAME	animframe,-128,.pass_anim
;;;	P_ADDANIM	1,11
;;;	P_IGOTO		.pass_up
;;;.pass_anim	
;;;	P_ADD		worldy,-15
;;;	P_IFNOTZERO	ty,.pass_up
;;;	P_SPAWN		0,-150,0,0,0,0,kurage_1,e_kurage_1_c,100,1,1
;;;	P_BECOME
;;;	P_SET		pbyte1,1
;;;	P_INVISIBLE	ON
;;;	P_UNBECOME
;;;	P_INC		ty
;;;.pass_up
;;;	P_CHILDDEAD	3,.pass_child
;;;	P_ZERO		tx
;;;	P_DO		3
;;;	P_INC		tx
;;;	P_BECOMECHILD	tx
;;;	P_IFNOTSAME	pbyte1,2,.not_botom
;;;	P_CHASE		childy,0
;;;	P_IGOTO		.c_vis
;;;.not_botom
;;;	P_CHASE		childy,480
;;;	P_IFBETWEEN	-200,childy,150,.pass_invis
;;;.c_vis
;;;	P_INVISIBLE	OFF
;;;.pass_invis
;;;	P_CHASE		childrotz,16
;;;	P_UNBECOME
;;;	P_INEXT
;;;.pass_child
;;;	P_CHASE		rotx,0
;;;	P_IFZERO	rotx,.stand
;;;	P_GOTO		.get_up
;;;
;;;.stand
;;;	P_TRIGGER	.kurage_1_hit2,WhenHit
;;;.action
;;;	P_SETANIM	7
;;;	P_DO		60
;;;	 P_ZERO		tx
;;;
;;;	P_PUSH		rotx
;;;	P_PUSH		roty
;;;	P_PUSH		pbyte1
;;;	P_SET		pbyte1,roty
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_NEG		pbyte1
;;;	P_ADD		roty,pbyte1
;;;	P_EXPORT	gbyte1,roty
;;;	P_PULL		pbyte1
;;;	P_PULL		roty
;;;	P_PULL		rotx
;;;	 P_DO		3
;;;	  P_INC		tx
;;;	  P_BECOMECHILD	tx
;;;	  P_CHASE		childroty,-16
;;;	  P_IFNOTSAME	pbyte1,2,.not_bot
;;;	  P_CHASE		childrotz,56
;;;	  P_IMPORT		pbyte2,gbyte1
;;;	  P_IGOTO		.same_c
;;;.not_bot
;;;	  P_CHASE		childrotz,0
;;;.same_c
;;;	  P_UNBECOME
;;;	 P_INEXT
;;;	 P_ADD		roty,16
;;;	 P_ADD		worldy,10
;;;
;;;	P_NEXT
;;;
;;;	P_DO		5
;;;	 P_DO		11
;;;	  P_ADDANIM	1,11
;;;	  P_ADD		worldy,-20
;;;	  P_BECOMECHILD	1
;;;	  P_DEC		childrotz
;;;	  P_UNBECOME
;;;	 P_NEXT
;;;	 P_DO		5
;;;	  P_ZERO		tx
;;;	  P_BECOMECHILD	2
;;;	  P_CHASE		childrotz,16
;;;	  P_CHASE		childroty,0
;;;	  P_UNBECOME
;;;	  P_BECOMECHILD	3
;;;	  P_CHASE		childrotz,16
;;;	  P_CHASE		childroty,0
;;;	  P_UNBECOME
;;;	  P_ADD		worldy,20
;;;	 P_NEXT
;;;	P_NEXT
;;;	
;;;	P_GOTO		.action
;;;	P_END
;;;
;;;.kurage_1_hit2
;;;	P_IFLARGER	hp,slopenum,.live_ok
;;;	P_DEC		mx
;;;	P_SET		hp,120
;;;	P_IFNOTBETWEEN	-127,mx,0,.live_ok
;;;	P_FORCE		.kurage_1_dead
;;;.live_ok
;;;	P_RETURN
;;;
;;;.kurage_1_dead
;;;	P_TRIGGER	.kurage_1_hit2,OFF
;;;.kurage_dead_same	LOCAL
;;;	P_COLLISIONS	OFF
;;;	P_SCREENFLASH
;;;	P_CLRDEMOSHAPE
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCORE		sc_kurage
;;;
;;;
;;;	P_TRIGGER	kani_explode,4
;;;	P_TRIGGER	.kurage_dead_anim,Always
;;;;;;	IFEQ		e_boss_demo_cut
;;;;;;
;;;;;;	P_ADD		worldy,-150
;;;;;;	P_EXPORT	gword1,worldy
;;;;;;	P_GOSUB		make_demo_target
;;;;;;	P_ADD		worldy,150
;;;;;;	P_BECOME
;;;;;;	P_IMPORT	pword1,gword1
;;;;;;	P_SET		slopenum,de_for_kurage
;;;;;;	P_SET		tx,25
;;;;;;	P_UNBECOME
;;;;;;
;;;;;;	P_GOSUB		demo_move_wait
;;;;;;
;;;;;;	ENDC
;;;
;;;	P_DO		20
;;;	P_RANDOMGOTO	.no_fl
;;;	P_HITFLASHTRIG
;;;.no_fl
;;;	P_NEXT
;;;
;;;	P_GOSUB		many_exp_group		;pe_sos_kuubo.many_exp
;;;
;;;	P_CIRCLEWINDOW	1,big
;;;	P_EXPLODE
;;;
;;;.kurage_dead_anim
;;;	P_ADDANIM	2,11
;;;	P_RETURN
;;;;;;;------------
;;;	START_PATH	e_kurage_1_c
;;;
;;;	P_ACTIVE	ON
;;;	P_IFSAME	hp,1,.for_explain
;;;	P_SETID		pbyte1
;;;	P_IFSAME	pbyte1,3,.i_am_needle
;;;	P_INC		pbyte1
;;;	P_EXPORT	gbyte1,pbyte1
;;;	P_SPAWN		0,0,0,0,0,0,kurage_1,e_kurage_1_c,100,1,1
;;;	P_BECOME
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_INVISIBLE	ON
;;;	P_UNBECOME
;;;.same
;;;	P_TRIGGER	i_sea_pl_in_sea,BelowSea
;;;	P_TRIGGER	i_sea_pl_out_sea,AboveSea
;;;
;;;.lop
;;;	P_IFLARGER	childrotz,tx,.bun
;;;	P_GOTO		.lop
;;;.bun
;;;	P_IFNOTBETWEEN	-95,pbyte2,-80,.nos
;;;	P_SOUNDEFTDISTPOS	en_tail_swing	;$84*
;;;	P_ZERO		pbyte2
;;;.nos
;;;	P_GOTO		.lop
;;;	P_END
;;;.for_explain
;;;	P_SHADOW	OFF
;;;	P_END
;;;.i_am_needle
;;;	P_SET		shape,kurage_2
;;;	P_SET		ap,4
;;;	P_SET		tx,30
;;;	P_IGOTO		.same
;;;;------------
;;;	START_PATH	e_kurage_sky_1
;;;
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_SET		hp,120
;;;	P_SET		slopenum,50
;;;	P_TRIGGER	.kurage_life,WhenHit
;;;	P_TRIGGER	i_sky_pl_in_sea,BelowSea
;;;	P_TRIGGER	i_sky_pl_out_sea,AboveSea
;;;	P_SET		childy,worldx
;;;	P_SET		oy,worldz
;;;	P_SET		childx,worldx
;;;	P_ADD		childx,2048
;;;	P_SET		ox,worldx
;;;	P_ADD		ox,-2048
;;;	P_SET		childz,worldz
;;;	P_ADD		childz,2048
;;;	P_SET		oz,worldz
;;;	P_ADD		oz,-2048
;;;.re_start
;;;	P_DISTLESS	1000,.go
;;;	P_GOTO		.re_start
;;;.go
;;;	P_RELTOPLAYER	ON
;;;	P_TRIGGER	.kurage_range_ck,8
;;;
;;;.kurage_ready
;;;	P_IFNOTZERO	ty,.mouaru
;;;	P_SPAWN		0,-240,0,0,0,0,kurage_1,e_kurage_c,100,4,1
;;;	P_BECOME
;;;	P_SET		pbyte1,1
;;;	P_UNBECOME
;;;	P_INC		ty
;;;.wait_c_loop
;;;	P_WAIT		1
;;;	P_CHILDDEAD	4,.wait_c_loop
;;;
;;;	P_DO		10
;;;	P_BECOMECHILD	1
;;;	P_ADD		childy,24
;;;	P_UNBECOME
;;;	P_NEXT
;;;.mouaru
;;;	P_DO		24
;;;	P_FACEPLAYER
;;;	P_BECOMECHILD	1
;;;	P_CHASE		childrotx,-70
;;;	P_UNBECOME
;;;	P_NEXT
;;;
;;;	P_SET		tx,2
;;;	P_DO		3
;;;	P_BECOMECHILD	tx
;;;	P_INVISIBLE	OFF
;;;	P_UNBECOME
;;;	P_INC		tx
;;;	P_INEXT
;;;
;;;.again
;;;	P_INPLAYERSCONE	-40,40,.atack
;;;	P_GOSUB		.kurage_sky_reset
;;;	P_GOTO		.mouaru
;;;.atack
;;;	P_DO		10
;;;	P_SET		tx,2
;;;	P_DO		3
;;;	P_BECOMECHILD	tx
;;;	P_ADD		childy,48
;;;	P_UNBECOME
;;;	P_INC		tx
;;;	P_INEXT
;;;	P_NEXT
;;;	P_WAIT		1
;;;	P_DO		10
;;;	P_SET		tx,2
;;;	P_DO		3
;;;	P_BECOMECHILD	tx
;;;	P_ADD		childy,-48
;;;	P_UNBECOME
;;;	P_INC		tx
;;;	P_INEXT
;;;	P_NEXT
;;;
;;;	P_DO		15
;;;	P_FACEPLAYER
;;;	P_BECOMECHILD	1
;;;	P_CHASE		childrotx,-64
;;;	P_UNBECOME
;;;	P_NEXT
;;;	P_GOTO		.again
;;;
;;;.kurage_range_ck
;;;	P_IFLARGER	worldx,childx,.out
;;;	P_IFSMALLER	worldx,ox,.out
;;;	P_IFLARGER	worldz,childz,.out
;;;	P_IFSMALLER	worldz,oz,.out
;;;	P_RETURN
;;;.out
;;;	P_FORCE		.back_center
;;;	P_RETURN
;;;.back_center
;;;	P_TRIGGER	.kurage_range_ck,OFF
;;;	
;;;	P_TRIGGER	.back_rot,Always
;;;
;;;	P_GOSUB		.kurage_sky_reset
;;;	P_RELTOPLAYER	OFF
;;;	P_EXPORT	gword1,childy
;;;	P_EXPORT	gword2,oy
;;;	P_GOSUB		put_only_marker
;;;	P_BECOME
;;;	P_FINDSHAPE	kurage_0
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldz,gword2
;;;	P_UNBECOME
;;;.come_cont
;;;	P_MOVEINSHAPE	30
;;;	P_SHAPEDISTLESS	300,.come_end
;;;	P_GOTO		.come_cont
;;;.come_end
;;;	P_TRIGGER	.back_rot,OFF
;;;	P_FLAGSHAPE
;;;	P_GOTO		.re_start
;;;
;;;.kurage_sky_reset
;;;	P_DO		40
;;;	P_ZERO		pbyte1
;;;	P_DO		4
;;;	  P_INC		pbyte1
;;;	  P_BECOMECHILD	pbyte1
;;;	    P_CHASE		childx,0
;;;	    P_CHASE		childy,0
;;;	    P_CHASE		childz,0
;;;	    P_CHASE		childrotx,0
;;;	    P_CHASE		childroty,0
;;;	    P_CHASE		childrotz,0
;;;	  P_UNBECOME
;;;	P_INEXT
;;;	P_NEXT
;;;	P_RETURN
;;;
;;;.back_rot
;;;	P_ADD		roty,16
;;;	P_RETURN
;;;
;;;.kurage_life
;;;	P_IFLARGER	hp,slopenum,.life_ok
;;;	P_FORCE		.kurage_dead
;;;.life_ok
;;;	P_RETURN
;;;.kurage_dead
;;;	P_TRIGGER	.kurage_range_ck,OFF
;;;	P_TRIGGER	.kurage_life,OFF
;;;	P_TRIGGER	.back_rot,OFF
;;;	P_RELTOPLAYER	OFF
;;;	P_IGOTO		pe_kurage_sea_1.kurage_dead_same
;;;;------------
;;;	START_PATH	e_kurage_c
;;;
;;;	P_ACTIVE	ON
;;;	P_SETID		pbyte1
;;;	P_INVISIBLE	ON
;;;	P_TRIGGER	i_sky_pl_in_sea,BelowSea
;;;	P_TRIGGER	i_sky_pl_out_sea,AboveSea
;;;	P_SHADOW	OFF
;;;	P_TRIGGER	self_invincible,Always
;;;	P_IFSAME	pbyte1,4,.i_am_needle
;;;	P_INC		pbyte1
;;;	P_EXPORT	gbyte1,pbyte1
;;;	P_SPAWN		0,0,0,0,0,0,kurage_1,e_kurage_c,100,1,1
;;;	P_BECOME
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_UNBECOME
;;;	P_END
;;;.i_am_needle
;;;	P_SET		shape,kurage_2
;;;	P_SET		ap,4
;;;	P_INVISIBLE	OFF
;;;	P_END
;;;;------------
	START_PATH	e_down_switch

	P_COLLISIONS	OFF
	P_SETANIM	0
	P_SETCOLANIM	0
.llp
	P_IFFLAG	.drop
	P_GOTO		.llp
.drop
	P_ZERO		pbyte1
	P_ZERO		pbyte2
	P_RTRIGGER	.rott,Always
;;;	P_TRIGGER	marker_set,Always
	P_DO		20
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_NEXT

	P_WAIT		1
	P_SET		pbyte1,60
.lp
	P_ADD		worldy,pbyte1
	P_ADD		pbyte1,10
	P_HITGROUND	0,.on_g
	P_GOTO		.lp
.on_g
	P_SOUNDEFTDISTPOS	ob_bunhard_L	;$99
	P_TRIGGER	.rott,OFF
	P_ZERO		worldy
	P_WAIT		1
	P_RTRIGGER	.rottt,Always
	P_SET		pbyte1,5
	P_DO		10
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_NEXT
	P_SOUNDEFTDISTPOS	ob_bunhard_L	;$99
	P_WAIT		1
	P_SET		pbyte1,6
	P_DO		8
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_NEXT

	P_SOUNDEFTDISTPOS	ob_bunhard_end	;$a0

	P_ZERO		rotx
	P_ZERO		roty
	P_ZERO		rotz
	P_ZERO		worldy
	P_TRIGGER	.rottt,OFF
	P_ZERO		pbyte1
	P_SET		roty,skidy
	P_ZERO		skidy
	P_IGOTO		pe_fumu_switch_door_map_aku.enter
.rott
	P_ADD		rotx,16
	P_ADD		roty,16
	P_RETURN
.rottt
	P_CHASE		rotx,0
	P_CHASE		roty,0
	P_RETURN

;-----------
	START_PATH	e_sagyou_walk_switch_aku

	P_GOSUB		roty_pb2_pb1
	P_SET		skidy,pbyte1
	P_INDEX		roty,init_angle_tab,pbyte2
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,0,150,0,0,0,on_d,e_down_switch,100,4,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_IGOTO		pe_sagyou_walk_box.hae_start
;-----------
	START_PATH	e_sagyou_walk_box

	P_SPAWN		0,0,150,0,0,0,box_0small,e_cube,2,2,1
.hae_start	LOCAL
	P_GOSUB		wakidashi_init
	P_SET		pbyte1,99
	P_RTRIGGER	.stop_ck,Always
	P_RTRIGGER	.i_stop_ck,Always
.re_go
	P_SETVEL	20
	P_WAIT		90
	P_SETVEL	0
	P_DO		32
	P_ADD		roty,4
	P_NEXT
	P_GOTO		.re_go
.i_stop_ck
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.i_dead
.ok
	P_RETURN
.stop_ck
	P_CHILDDEAD	1,.box_break
	P_RETURN
.box_break
	P_FORCE		.urouro
	P_RETURN
.i_dead
	P_TRIGGER	.i_stop_ck,OFF
	P_TRIGGER	.stop_ck,OFF
	P_FLAGCHILD	1
	P_UNLINKCHILD	1
	P_SCORE		sc_hit_dead
	P_EXPLODE
.urouro
	P_TRIGGER	.stop_ck,OFF
.uro_rot
	P_ADD		roty,4
	P_GOTO		.uro_rot
;------------
	START_PATH	e_cube

	P_ACTIVE	ON
	P_RTRIGGER	.jump_on,WhenFlagged
	P_END
.jump_on
	P_FORCE		.jump
	P_RETURN
.jump
	P_TRIGGER	.jump_on,OFF
	P_DO		20
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_ADD		worldz,5
	P_ADD		roty,8
	P_NEXT
	P_IMPORT	pword1,emedal_4
	P_IFSWITCH	ap,pword1,.twitem
	P_IFSAME	ap,3,.hae42ck
.sagyou41ck
	P_GSET		b,gbyte1,41h
	P_IGOTO		.medal
.hae42ck
	P_GSET		b,gbyte1,42h
.medal
	P_GOSUB		set_medal
	P_EXPLODE
.twitem
	P_GOSUB		make_twinblaster
	P_EXPLODE
;;;;------------
;;;	START_PATH	e_sagyou_hashira
;;;
;;;	P_SOUND		p2_sagyou_0
;;;	P_GOSUB		wakidashi_init
;;;	P_SET		pbyte1,hp
;;;	P_SET		pbyte2,99
;;;	P_HITFLASH	OFF
;;;	P_TRIGGER	.sag_hit,WhenHit
;;;	P_SETVEL	30
;;;.loop
;;;	P_WAIT		34
;;;	P_DO		32
;;;	P_ADD		roty,4
;;;	P_NEXT
;;;	P_GOTO		.loop
;;;	P_END
;;;.sag_hit
;;;	P_IFHITFLAG	.body,2
;;;	P_SET		hp,pbyte1
;;;	P_SOUNDEFTDIST	ob_reboundlaser_s	;$a8
;;;	P_RETURN
;;;.body
;;;	P_SET		pbyte1,hp
;;;	P_HITFLASHTRIG
;;;	P_IFLARGER	hp,pbyte2,.ok
;;;	P_FORCE		.sag_dead
;;;.ok
;;;	P_RETURN
;;;.sag_dead
;;;	P_TRIGGER	.sag_hit,OFF
;;;
;;;	P_SPAWN		45,-9,0,0,0,0,sagyou_1,e_down_pill,100,4
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_SPAWN		-45,-9,0,0,0,0,sagyou_1,e_down_pill,100,4
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_SCORE		sc_wakidashi
;;;	P_INVISIBLE	ON
;;;	P_QSPAWN	sagyou_0_s,e_wakidashi_damy_exp,10,10
;;;	P_ADD		worldx,20000
;;;	P_REMOVE
;;;;------------
;;;	START_PATH	e_down_pill
;;;
;;;	P_INVINCIBLE	ON
;;;	P_SET		pbyte1,7
;;;	P_DO		13
;;;	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
;;;	P_NEXT
;;;.down_loop
;;;	P_ADD		worldy,50
;;;	P_HITGROUND	0,.again
;;;	P_GOTO		.down_loop
;;;.again
;;;	P_SOUNDEFTNEARPOS	en_land_L	;$76
;;;	P_SET		worldy,-20
;;;	P_SET		pbyte1,4
;;;	P_DO		12
;;;	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
;;;	P_NEXT
;;;	P_WAIT		1
;;;	P_SET		shape,sagyou_1exp
;;;	P_EXPLODE
;;;;------------
	START_PATH	e_new_sagyou_r

	P_GOSUB		hit_dead_init
	P_TRIGGER	hit_dead,WhenDead
	P_RTRIGGER	.sagyou_spark,8
	P_END
	
.sagyou_spark
	P_SETRANDOM	pbyte1,7
	P_INC		pbyte1
	P_EXPORT	gbyte1,pbyte1
	P_SPAWN		0,0,45,0,0,0,wallflash,e_sp_spark,4,12
	P_BECOME
	P_IMPORT	hp,gbyte1
	P_ACTIVE	ON
	P_UNBECOME
	P_RETURN





;;;	START_PATH	e_sagyou_target
;;;
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_SET		slopenum,98		;sagyou hp min
;;;	P_RANGECHECK	OFF
;;;	P_TRIGGER	.hit_ck,WhenHit
;;;	P_TRIGGER	.sagyou_spark,8
;;;	P_END
;;;.hit_ck
;;;	P_IFLARGER	hp,slopenum,.live
;;;	P_FORCE		.dead
;;;.live
;;;	P_RETURN
;;;.dead
;;;	P_TRIGGER	.hit_ck,OFF
;;;	P_TRIGGER	.sagyou_spark,OFF
;;;
;;;	P_SCORE		sc_sagyou_target
;;;	P_IGOTO		final_enemy_demo
;;;
;;;.sagyou_spark
;;;	P_SETRANDOM	pbyte1,7
;;;	P_INC		pbyte1
;;;	P_EXPORT	gbyte1,pbyte1
;;;	P_SPAWN		0,0,45,0,0,0,wallflash,e_sp_spark,4,12
;;;	P_BECOME
;;;	P_IMPORT	hp,gbyte1
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_RETURN
;;;;------------
	START_PATH	e_yuka_hou_kotei_final

	P_INC		childrotx

	START_PATH	e_yuka_hou_kotei_tojikome

	P_INC		childrotx

	START_PATH	e_yuka_hou_kotei

	P_ADD		childrotx,3
	P_IGOTO		pe_yuka_hou.enter

	START_PATH	e_yuka_hou_tojikome

	P_SET		skidy,hp
	P_SET		childrotx,2
	P_IGOTO		pe_yuka_hou.andorf
;;	P_INC		childrotx

	START_PATH	e_yuka_hou_final

	P_INC		childrotx

	START_PATH	e_yuka_hou
;-----
	P_SET		skidy,hp
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove
.andorf	LOCAL
	P_IMPORT	pbyte1,ebyte8
	P_IFSWITCH	skidy,pbyte1,eg_remove
;	P_IGOTO		.sw_ok
;.swrem
;	P_REMOVE
.sw_ok
;-----
.enter	LOCAL
	P_GOSUB		wakidashi_init
	P_ENEMYDMGSE	en_cry_2
	P_IFSAME	childrotx,2,.ntck
	P_IFSAME	childrotx,4,.ntck

	P_IGOTO		.nt
.ntck
	P_INVISIBLE	ON
.wnt
	P_IMPORT	pbyte1,ebyte3
	P_IFSAME	pbyte1,-1,.nt
	P_GOTO		.wnt

.nt
	P_INVISIBLE	OFF
	P_CLRTYPE	enemy1
	P_SET		childx,worldx
	P_SET		childz,worldz
	P_SETANIM	0
	P_SET		worldy,70<<yuka_hou_scale

	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,8,.chigau
	P_IMPORT	pbyte1,CurrentLevel
	P_IFNOTSAME	pbyte1,15,.chigau
	P_INVISIBLE	ON
.cr_wait
	P_IMPORT	pbyte1,ebyte5
	P_IFNOTZERO	pbyte1,.chigau
	P_GOTO		.cr_wait
.chigau


	P_RTRIGGER	.hit,WhenHit
	P_INVISIBLE	ON
.lp
	P_IFSAME	childrotx,3,.kotei_pos
	P_IFSAME	childrotx,4,.kotei_pos
	P_IFSAME	childrotx,5,.kotei_pos
	P_SETRANDOM	pbyte1,7
	P_SET		ox,childx
	P_SET		oz,childz
	P_INDEX		pword1,yuka_hou_x,pbyte1
	P_ADD		ox,pword1
	P_INDEX		pword1,yuka_hou_z,pbyte1
	P_ADD		oz,pword1
.more
	P_CHASE		worldx,ox
	P_CHASE		worldz,oz
	P_WAIT		1
	P_IFNOTSAME	worldx,ox,.more
	P_IFNOTSAME	worldz,oz,.more
	P_IGOTO		.act_kotei
.kotei_pos
	P_WAIT		30
	P_RANDOMGOTO	.kotei_pos
.act_kotei
	P_INVISIBLE	OFF
	P_CLIPPING	ON

	P_SOUNDEFTDISTPOS	ob_yuka_hou_out	;$a5

	P_DO		7
	P_ADD		worldy,-10<<yuka_hou_scale
	P_NEXT
	P_RTRIGGER	.face,Always
	P_DO		9
	P_ADDANIM	1,10
	P_NEXT

	P_WAIT		20
	P_DO		3
;	P_SPAWN		0,-50<<yuka_hou_scale,50<<yuka_hou_scale,0,0,0,nullshape,e_tousenbo_fire,100,0,1
	P_ADD		worldy,-60<<yuka_hou_scale
	P_GOSUB		ring_fire_must_stay
	P_ADD		worldy,60<<yuka_hou_scale
	P_WAIT		20
	P_NEXT

	P_TRIGGER	.face,OFF

	P_DO		6
	P_ADDANIM	-1,10
	P_NEXT
	P_WAIT		1
	P_SOUNDEFTDISTPOS	ob_yuka_hou_in	;$a6

	P_DO		3
	P_ADDANIM	-1,10
	P_NEXT

	P_DO		7
	P_ADD		worldy,10<<yuka_hou_scale
	P_NEXT
	P_CLIPPING	OFF
	P_INVISIBLE	ON
	P_WAIT		30
	P_IGOTO		.lp
.face
	P_FACEPLAYER	y
	P_RETURN
.hit
	P_SET		pbyte2,50
	P_IFLARGER	hp,pbyte2,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_SET		shape,yuka_hou_exp
	P_GOSUB		fire_cansel
	P_TRIGGER	.hit,OFF
	P_COLLISIONS	OFF
	P_DO		4
	P_ADD		worldy,-30<<yuka_hou_scale
	P_QSPAWN	explosion5,e_sp_randomsize_explosion,100,32
	P_ADD		worldy,30<<yuka_hou_scale
	P_BECOME
	P_ADD		slopenum,2
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT
	P_IFSAME	childrotx,3,.no_sky
	P_IFSAME	childrotx,4,.no_sky
	P_IFSAME	childrotx,5,.no_sky
	P_GOSUB		room_enemy_sw_dead
.no_sky
	P_IFZERO	childrotx,.nashi
	P_IFSAME	childrotx,1,.final
	P_IFSAME	childrotx,3,.nashi
	P_IFSAME	childrotx,5,.final

	P_GOSUB		.r_hp
	P_GINC		b,ebyte3
	P_SCORE		sc_sos_strong
	P_EXPLODE
.r_hp
	P_PUSH		worldy
	P_SET		worldy,-100
	P_GOSUB		make_hp_item_random
	P_PULL		worldy
	P_RETURN
.final
	P_PUSH		worldy
	P_SET		worldy,-100
	P_GOSUB		make_hp_item
	P_PULL		worldy
	P_SCORE		sc_shield_robo
	P_GINC		b,ebyte2
	P_EXPLODE
.nashi
	P_GOSUB		.r_hp
	P_SCORE		sc_sos_strong
	P_EXPLODE
;.yuka_hou_x
;	dw	-768,768,0,-512,512,0,-768,768
;.yuka_hou_z
;	dw	768,768,512,0,0,-512,-768,-768
;;;;------------
	START_PATH	e_hako_hou

	P_PASSSOUND	ON
	P_GOSUB		wakidashi_init
	P_WEAPON	ERing
;	P_CLRTYPE	enemy1
	P_SETANIM	0
	P_SLOPE		ON
	P_COLLISIONS	OFF
	P_HITFLASH	OFF
	P_ADD		worldy,-40<<ha_hou_scale
.lp
	P_INC		pbyte1
	P_IFSAME	pbyte1,40,.atack
	P_GOTO		.lp
.atack
	P_SOUNDEFTDISTPOS	ob_ha_hou_door	;$9f
	P_DO		11
	P_ADDANIM	1,12
	P_NEXT
	P_SLOPE		OFF
	P_COLLISIONS	ON
	P_RTRIGGER	.hit,WhenHit

	P_DO		3
;	P_ADD		worldy,-40<<ha_hou_scale
	P_GOSUB		ring_fire_must_stay
;	P_ADD		worldy,40<<ha_hou_scale
	P_WAIT		22
	P_NEXT
	
	P_TRIGGER	.hit,OFF
	P_SLOPE		ON
	P_COLLISIONS	OFF
	P_DO		8
	P_ADDANIM	-1,12
	P_NEXT
	P_SOUNDEFTDISTPOS	ob_ha_hou_door	;$9f
	P_WAIT		1
	P_DO		3
	P_ADDANIM	-1,12
	P_NEXT
	P_ZERO		pbyte1
	P_GOTO		.lp
.hit
	P_FORCE		.dead
	P_RETURN
.dead
	P_TRIGGER	.hit,OFF
	P_SCORE		sc_hit_dead
	P_RADAROBJ	ra_off
	P_CLEARSTACK

	P_GOSUB		fire_cansel
	P_SET		shape,ha_hou_1
	P_ZERO		worldy
	P_SLOPE		ON
	P_COLLISIONS	OFF
	P_SPAWN		0,-50<<ha_hou_scale,0,0,0,0,ha_hou_1,e_buil_shadow_off,100,4,1
	P_BECOME
	P_PASSSOUND	ON
	P_UNBECOME
	P_INVINCIBLE	ON
	P_ADD		worldy,-40<<ha_hou_scale
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,32
	P_ADD		worldy,40<<ha_hou_scale
	P_END
;;;;------------
	START_PATH	e_tenjyou_yamori

;-----
	P_SET		skidy,hp
	P_IMPORT	pbyte1,ebyte8
	P_IFSWITCH	skidy,pbyte1,eg_remove
;	P_IGOTO		.sw_ok
;.swrem
;	P_REMOVE
.sw_ok
;-----
	P_ENEMYDMGSE	en_cry_2
	P_GOSUB		wakidashi_init
	P_RANGECHECK	OFF
	P_INVISIBLE	ON
.wlp
	P_IMPORT	pbyte1,ebyte5
	P_IFSAME	pbyte1,1,.wst
	P_GOTO		.wlp
.wst
	P_INVISIBLE	OFF
	P_SET		worldy,-320+60<<yamori_scale
	P_RTRIGGER	.yamo_hit,WhenHit
	P_GOSUB		pe_yamori.mk_ashi
	P_SET		rotz,128
	P_SET		childx,worldx
	P_ADD		childx,1024-100<<yamori_scale
	P_SET		ox,worldx
	P_ADD		ox,-1024+100<<yamori_scale
	P_SET		childz,worldz
	P_ADD		childz,1024-100<<yamori_scale
	P_SET		oz,worldz
	P_ADD		oz,-1024+100<<yamori_scale
	P_RTRIGGER	.kakomi_ck,Always
	P_RTRIGGER	.houkou_change,128
	P_TRIGGER	yamori_sound,Always
	P_SETVEL	20
	P_SET		pbyte2,1
.lp
	P_ADD		roty,pbyte2
	P_GOTO		.lp
.houkou_change
	P_SPAWN		0,0,50,0,0,0,nullshape,e_atacker,10,10,9
	P_RANDOMGOTO	.noneg
	P_NEG		pbyte2
.noneg
	P_RETURN
.kakomi_ck
	P_IFSMALLER	worldx,childx,.ok1
	P_SET		worldx,childx
.ok1
	P_IFLARGER	worldx,ox,.ok2
	P_SET		worldx,ox
.ok2
	P_IFSMALLER	worldz,childz,.ok3
	P_SET		worldz,childz
.ok3
	P_IFLARGER	worldz,oz,.ok4
	P_SET		worldz,oz
.ok4
	P_RETURN
	P_RETURN
.yamo_hit
	P_SET		pbyte1,80
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.yamo_hit,OFF
	P_IGOTO		pe_yamori.dead_enter
;;;;------------
	START_PATH	e_yamori

;-----
	P_SET		skidy,hp
	P_IMPORT	pbyte1,ebyte8
	P_IFSWITCH	skidy,pbyte1,eg_remove
;	P_IGOTO		.sw_ok
;.swrem
;	P_REMOVE
.sw_ok
;-----
	P_ENEMYDMGSE	en_cry_2
	P_SET		roty,ap
	P_TRIGGER	yamori_sound,Always
	P_GOSUB		wakidashi_init
	P_RANGECHECK	OFF
	P_INVISIBLE	ON
.wlp
	P_IMPORT	pbyte1,ebyte5
	P_IFSAME	pbyte1,1,.wst
	P_GOTO		.wlp
.wst
	P_INVISIBLE	OFF
	P_RTRIGGER	.yamo_hit,WhenHit
	P_GOSUB		.mk_ashi
	P_SET		rotz,-64
	P_SET		rotx,-64
	P_SET		childx,-100<<yamori_scale
	P_SET		childy,-320+100<<yamori_scale
	P_RTRIGGER	.keep_min_hi,Always
	P_SETVEL	20
	P_SET		pbyte2,-2
	P_GOTO		.back
.lp
	P_IFSAME	rotx,64,.atack
	P_IFSAME	rotx,-64,.atack
.back
	P_IFNOTSAME	rotx,-64,.cont
	P_NEG		pbyte2
.cont
	P_ADD		rotx,pbyte2
	P_GOTO		.lp
.yamo_hit
	P_SET		pbyte1,80
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.yamo_hit,OFF
.dead_enter	LOCAL
	P_COLLISIONS	OFF
	P_TRIGGER	mk_many_damy_exp,4
	P_DO		15
	P_RANDOMGOTO	.no_fl1
	P_HITFLASHTRIG
.no_fl1
	P_NEXT
	P_DO		4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,8
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT

	P_SOUNDEFTPOS	en_death_2	;$79
	P_SOUNDEFTPOS	bs_BossExplode2	;$c0
	P_CIRCLEWINDOW	1,big
	P_GINC		b,ebyte2
	P_FLAGCHILD	1
	P_FLAGCHILD	2
	P_UNLINKCHILD	1
	P_UNLINKCHILD	2
	P_GOSUB		room_enemy_sw_dead
	P_GOSUB		make_random_item
	P_EXPLODE
.keep_min_hi
	P_IFLARGER	worldy,childx,.min_hi
	P_IFSMALLER	worldy,childy,.max_hi
	P_RETURN
.min_hi
	P_SET		worldy,childx
	P_RETURN
.max_hi
	P_SET		worldy,childy
	P_RETURN
.atack
	P_SPAWN		0,0,50,0,0,0,nullshape,e_atacker,10,10,9
	P_IGOTO		.back
.mk_ashi	LOCAL
	P_SPAWN		30<<yamori_scale,60<<yamori_scale,0,0,0,0,yamori_r,e_yamori_c,100,4,1
	P_BECOME
	P_SETANIM	0
	P_UNBECOME
	P_SPAWN		-30<<yamori_scale,60<<yamori_scale,0,0,0,0,yamori_l,e_yamori_c,100,4,2
	P_BECOME
	P_SETANIM	4
	P_UNBECOME
	P_RETURN
yamori_sound
	P_INC		childrotz
	P_IFSAME	childrotz,4,.sou
	P_RETURN
.sou
	P_SOUNDEFTDISTPOS	en_yamori_walk	;$78
	P_ZERO		childrotz
	P_RETURN
;;;;------------
	START_PATH	e_atacker

	P_WEAPON	ERing
	P_INVISIBLE	ON
	P_DO		2
	P_GOSUB		ring_fire_must_child
	P_WAIT		15
	P_NEXT
	P_REMOVE
;;;;------------
	START_PATH	e_yamori_c
	P_COLLISIONS	OFF
	P_ACTIVE	ON
	P_RTRIGGER	.yamo_anim,Always
	P_RTRIGGER	.yamo_dead,WhenFlagged
	P_END
.yamo_dead
	P_FORCE		.dead
	P_RETURN
.dead
	P_TRIGGER	.yamo_anim,OFF
	P_TRIGGER	.yamo_dead,OFF
	P_DIV2		childx
	P_DIV2		childx
	P_SET		vx,childx
	P_SETRANDOM	pbyte2,63
	P_ADD		pbyte2,-32
	P_SET		pbyte1,2
	P_DO		15
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_ADD		roty,pbyte2
	P_NEXT
	P_EXPLODE
.yamo_anim
	P_ADDANIM	1,8
	P_RETURN
;;;;------------
	START_PATH	e_pool_robo2

	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove
	P_GOSUB		wakidashi_init
	P_SET		hp,110
	P_SETBOSSNAME	name_kick
	P_GOSUB		enemy_hp_meter_hydra
	P_ENEMYDMGSE	en_cry_2
	P_ALWAYSGENVECS	OFF
	P_WEAPON	ERing
	P_RTRIGGER	.hit,WhenHit
.lp
	P_GOSUB		.set_pool_pos
	P_CLIPPING	ON
	P_SET		worldy,200
	P_WAIT		35
	P_RADAROBJ	ra_enemy
	P_WAIT		15
	P_RANDOMGOTO	.yuka_atack
	P_GOSUB		.jump_out
	P_WAIT		15
	P_RADAROBJ	ra_off
	P_WAIT		35
	P_GOTO		.lp
;------------
.hit
	P_SET		slopenum,40
	P_IFLARGER	hp,slopenum,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.hit,OFF
	P_IGOTO		pe_pool_robo.dead_enter
;------------
.yuka_atack
	P_SET		roty,childrotx
	P_SETANIM	0
	P_ADD		worldy,-200
	P_NOTHITGROUND	25<<mizukara_scale,.to_yuka
	P_GOTO		.yuka_atack
.to_yuka
	P_QSPAWN	splash,e_sp_splash_out,8,50
	P_BECOME
	P_SET		worldy,10
	P_UNBECOME
	
	P_SETVEL	45
	P_ZERO		pbyte1
	P_DO		20
	P_CHASE		roty,childroty
	P_INDEX		animframe,pool_anim_out,pbyte1
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_NEXT
	P_SET		worldy,-25<<mizukara_scale
	P_SETVEL	0
	P_SETANIM	0

	P_WAIT		1
	P_SOUNDEFTDISTPOS	en_Land_2	;$7a

	P_GOSUB		youi_jump

	P_SETANIM	0

	P_WAIT		10

	P_DO		5

	P_GOSUB		youi_jump

	P_PUSH		roty
	P_SET		roty,childroty
	P_SETVEL	25
	P_PULL		roty

	P_SOUNDEFTDISTPOS	en_mizukara_jump

	P_SET		pbyte1,3
	P_DO		14
	P_FACEPLAYER	y
	P_INDEX		animframe,pool_anim_minij,pbyte1
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_DEC		pbyte1
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_NEXT
	P_SETVEL	0
	P_WAIT		1

	P_SOUNDEFTDISTPOS	en_Land_2	;$7a
	P_GOSUB		youi_jump
	P_SETANIM	0
;	P_WAIT		1		;3
	P_SPAWN		0,0,50,0,0,0,ring_mark,e_ring_mark_child,10,10,11
;	P_WAIT		1		;2
	P_NEXT

	P_SETVEL	0
	P_GOSUB		youi_jump
	P_ZERO		pbyte1

	P_SOUNDEFTDISTPOS	en_mizukara_jump

	P_DO		20
	P_IFSAME	animframe,-117,.pass_anim
	P_INC		animframe
.pass_anim
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_CHASE		worldx,childx
	P_CHASE		worldz,childz
	P_NEXT
	P_WAIT		1
	P_QSPAWN	splash,e_sp_splash_in,8,50
	P_BECOME
	P_SET		worldy,10
	P_UNBECOME
	P_SET		worldy,200

	P_GOTO		.lp

.jump_out
	P_SETANIM	0
	P_ADD		worldy,-200
	P_NOTHITGROUND	25<<mizukara_scale,.out_pool
	P_GOTO		.jump_out
.out_pool
	P_QSPAWN	splash,e_sp_splash_out,8,50
	P_BECOME
	P_SET		worldy,10
	P_UNBECOME
	P_SETVEL	50
	P_SETANIM	11
	P_ZERO		pbyte1
	P_DO		20
	P_FACEPLAYER	y
	P_IFNOTSAME	pbyte1,10,.pass_at1
	P_GOSUB		sos_fire_must
.pass_at1
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_NEXT
	P_SET		worldy,-25<<mizukara_scale
	P_WAIT		1
	P_QSPAWN	splash,e_sp_splash_in,8,50
	P_BECOME
	P_SET		worldy,10
	P_UNBECOME
	P_SETVEL	0
	P_SET		worldy,200
	P_WAIT		10
	P_RETURN
.set_pool_pos
	P_SETRANDOM	pbyte1,3
	P_INDEX		worldx,pool2_pos_x,pbyte1
	P_INDEX		worldz,pool2_pos_z,pbyte1
	P_INDEX		childrotx,pool2_atack_roty,pbyte1
	P_SETRANDOM	pbyte2,1
	P_ADD		pbyte1,pbyte1
	P_ADD		pbyte1,pbyte2
	P_INDEX		roty,pool_roty,pbyte1
	P_SET		childroty,roty
	P_INDEX		pbyte2,pool_next,pbyte1
	P_INDEX		childx,pool2_pos_x,pbyte2
	P_INDEX		childz,pool2_pos_z,pbyte2
	P_RETURN

;.pool_atack_roty
;	db	-96,-32,32,96
;.pool_pos_x
;	dw	0,0,-1024,-1024
;.pool_pos_z
;	dw	-1024,0,0,-1024
;;;;------------
	START_PATH	e_pool_robo

	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove
	P_GOSUB		wakidashi_init
	P_SET		hp,70
	P_SETBOSSNAME	name_kick
	P_GOSUB		enemy_hp_meter_hydra
	P_ENEMYDMGSE	en_cry_2
	P_RADAROBJ	ra_off
	P_ALWAYSGENVECS	OFF
	P_WEAPON	ERing
	P_RTRIGGER	.hit,WhenHit
.lp
	P_GOSUB		.set_pool_pos
	P_CLIPPING	ON
	P_SET		worldy,100
	P_WAIT		35
	P_RADAROBJ	ra_enemy
	P_WAIT		15
	P_GOSUB		.jump_out
	P_GOSUB		.move_next_pool
	P_WAIT		15
	P_RADAROBJ	ra_off
	P_WAIT		35
	P_GOTO		.lp
.hit
	P_SET		slopenum,40
	P_IFLARGER	hp,slopenum,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.hit,OFF
.dead_enter	LOCAL
	P_COLLISIONS	OFF
	P_SETVEL	0
	P_SCREENFLASH
	P_TRIGGER	mk_many_damy_exp,4

	P_DO		15
	P_RANDOMGOTO	.no_fl
	P_HITFLASHTRIG
.no_fl
	P_NEXT

	P_GOSUB		s_group_explode

	P_SOUNDEFTPOS	en_death_2	;$79
	P_SOUNDEFTPOS	bs_BossExplode2	;$c0
	P_CIRCLEWINDOW	1,big

	P_GINC		b,ebyte2
	P_SCORE		sc_shield_robo

	P_PUSH		worldy
	P_SET		worldy,-100
	P_GOSUB		make_random_item
	P_PULL		worldy

	P_EXPLODE

.move_next_pool
	P_DO		5

	P_GOSUB		youi_jump

	P_PUSH		roty
	P_SET		roty,childroty
	P_SETVEL	25
	P_PULL		roty

	P_SOUNDEFTDISTPOS	en_mizukara_jump	;$77*

	P_SET		pbyte1,3
	P_DO		14
	P_FACEPLAYER	y
	P_INDEX		animframe,pool_anim_minij,pbyte1
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_DEC		pbyte1
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_NEXT
	P_SETVEL	0
	P_WAIT		1

	P_SOUNDEFTDISTPOS	en_Land_2	;$7a

	P_GOSUB		youi_jump
	P_SETANIM	0
	P_WAIT		3
	P_SPAWN		0,0,50,0,0,0,ring_mark,e_ring_mark_child,10,10,11
;	P_GOSUB		sos_fire_must
	P_WAIT		2
	P_NEXT

	P_SETVEL	0
	P_GOSUB		youi_jump
	P_SOUNDEFTDISTPOS	en_mizukara_jump	;$77*
	P_ZERO		pbyte1

	P_DO		20
	P_IFSAME	animframe,-117,.pass_anim
	P_INC		animframe
.pass_anim
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_CHASE		worldx,childx
	P_CHASE		worldz,childz
	P_NEXT
	P_WAIT		1
	P_QSPAWN	splash,e_sp_splash_in,8,50
	P_BECOME
	P_SET		worldy,10
	P_UNBECOME
	P_SET		worldy,100
	P_RETURN
.set_pool_pos
	P_SETRANDOM	pbyte1,3
	P_INDEX		worldx,pool_pos_x,pbyte1
	P_INDEX		worldz,pool_pos_z,pbyte1
	P_SETRANDOM	pbyte2,1
	P_ADD		pbyte1,pbyte1
	P_ADD		pbyte1,pbyte2
	P_INDEX		roty,pool_roty,pbyte1
	P_SET		childroty,roty
	P_INDEX		pbyte2,pool_next,pbyte1
	P_INDEX		childx,pool_pos_x,pbyte2
	P_INDEX		childz,pool_pos_z,pbyte2
	P_RETURN
;.pool_pos_x
;	dw	1280,1280,-1280,-1280
;.pool_pos_z
;	dw	-1280,1280,1280,-1280
.jump_out
	P_SETANIM	0
	P_ADD		worldy,-100
	P_NOTHITGROUND	25<<mizukara_scale,.out_pool
	P_GOTO		.jump_out
.out_pool
	P_QSPAWN	splash,e_sp_splash_out,8,50
	P_BECOME
	P_SET		worldy,10
	P_UNBECOME
	P_SETVEL	35
	P_ZERO		pbyte1
	P_DO		20
	P_INDEX		animframe,pool_anim_out,pbyte1
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_NEXT
	P_SET		worldy,-25<<mizukara_scale
	P_SETVEL	0
	P_SETANIM	0
	P_WAIT		1

	P_SOUNDEFTDISTPOS	en_Land_2	;$7a

	P_GOSUB		youi_jump

	P_SETANIM	0
	P_WAIT		10
	P_RETURN
youi_jump
	P_ZERO		pbyte1
	P_DO		5
	P_AUTOINDEX	b,worldy,pool_j_youi,pbyte1,5
	P_ADDANIM	1,12
	P_NEXT
	P_WAIT		1
	P_RETURN

;;;;------------
	START_PATH	e_tamanage_robo_final

	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove
	P_SET		childx,worldx
	P_SET		childz,worldz
	P_ENEMYDMGSE	en_cry_2
	P_RADAROBJ	ra_enemy
	P_INVISIBLE	ON
	P_SET		hp,100
.wlp
	P_IMPORT	pbyte1,ebyte5
	P_IFSAME	pbyte1,1,.wst
	P_GOTO		.wlp
.wst
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_IMPORT	pbyte1,KDifficulty
	P_IFSAME	pbyte1,dif_easy,.easy_hp
	P_ADD		hp,20
.easy_hp	
	P_RTRIGGER	.nage_dead_ck,WhenHit

	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		0,0,0,0,0,0,egu_2,e_enemy_shield,100,4,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childx,karakasa_cx,pbyte1
	P_INDEX		childz,karakasa_cz,pbyte1
	P_INDEX		childroty,karakasa_ry,pbyte1
	P_INC		pbyte1
	P_SETID		pbyte1
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
;	P_SPAWN		20<<karakasa_scale,0,0,0,-64,0,egu_2,e_enemy_shield,100,4,1
;	P_SPAWN		-20<<karakasa_scale,0,0,0,64,0,egu_2,e_enemy_shield,100,4,2
;	P_SPAWN		0,0,20<<karakasa_scale,0,0,0,egu_2,e_enemy_shield,100,4,3
;	P_SPAWN		0,0,-20<<karakasa_scale,0,128,0,egu_2,e_enemy_shield,100,4,4

.next_pos
	P_SOUND		p2_egu_0	;09
	P_SETRANDOM	pbyte1,3
	P_IFNOTSAME	pbyte1,3,.kokohe
	P_DEC		pbyte1
.kokohe
	P_IFZERO	slopenum,.kore
	P_DO		slopenum
	P_ADD		pbyte1,3
	P_INEXT
.kore
	P_INDEX		pbyte2,tamanage_next,pbyte1
	P_SET		slopenum,pbyte2
	P_INDEX		pword1,tamanage_pos_x,pbyte2
	P_EXPORT	gword1,childx
	P_GADD		gword1,pword1
	P_INDEX		pword1,tamanage_pos_z,pbyte2
	P_EXPORT	gword2,childz
	P_GADD		gword2,pword1
	P_QSPAWN	marker,e_marker,100,0
	P_FINDSHAPE	marker
	P_BECOME
	P_FINDSHAPE	egu_0
	P_GOSUB		impo_xz_world
;	P_IMPORT	worldx,gword1
;	P_IMPORT	worldz,gword2
	P_UNBECOME

	P_DO		10
	P_FACESHAPE
	P_NEXT
.go_mark
;	P_FACESHAPE
	P_ADD		roty,16
;	P_MOVEINSHAPE	10
;	P_SHAPEDISTLESS	30,.atack
	P_MOVEINSHAPE	50
	P_SHAPEDISTLESS	80,.atack
	P_GOTO		.go_mark
;-----------
.nage_dead_ck
	P_ZERO		pbyte1
	P_DO		4
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_HITFLASHTRIG
	P_UNBECOME
	P_INEXT
	P_SET		pbyte1,80
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.nage_dead
.ok
	P_RETURN
.nage_dead
	P_TRIGGER	.nage_dead_ck,OFF
	P_TRIGGER	mk_many_damy_exp,4
	P_DO		15
	P_RANDOMGOTO	.no_fl1
	P_HITFLASHTRIG
.no_fl1
	P_NEXT
	P_CIRCLEWINDOW	1,big
	P_SCORE		sc_shield_robo
	P_DO		4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,8
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT

	P_GOSUB		c_flag_1234
;	P_FLAGCHILD	1
;	P_FLAGCHILD	2
;	P_FLAGCHILD	3
;	P_FLAGCHILD	4
	P_GOSUB		c_unlink_1234
;	P_FLAGCHILD	1
;	P_UNLINKCHILD	1
;	P_FLAGCHILD	2
;	P_UNLINKCHILD	2
;	P_FLAGCHILD	3
;	P_UNLINKCHILD	3
;	P_FLAGCHILD	4
;	P_UNLINKCHILD	4

	P_GOSUB		make_random_item
	P_GINC		b,ebyte2
	P_EXPLODE
;-----------
.atack
	P_SOUND		port2_stop	;00_
	P_FLAGSHAPE
	P_SOUNDEFTDISTPOS	en_egu_0_open	;$a2*
	P_TRIGGER	.open_shield,Always,11

	P_QSPAWN	ring_mark,e_genkidama,10,10

	P_COLLISIONS	ON
	P_IMPORT	pbyte1,KDifficulty
	P_INDEX		pbyte1,kasa_op_time,pbyte1
	P_DO		pbyte1
	P_FACEPLAYER	y
	P_NEXT

	P_COLLISIONS	OFF

	P_SOUNDEFTDISTPOS	en_egu_0_close	;$ac
	P_TRIGGER	.crose_shield,Always,11
	P_WAIT		10
	P_GOTO		.next_pos
;;.nageru
;;	P_FLAGCHILD	9
;;	P_UNLINKCHILD	9
;;	P_RETURN
.open_shield
	P_PUSH		pbyte1
	P_ZERO		pbyte1
	P_DO		4
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_SET		shape,egu_1
	P_ADDANIM	1,12
	P_IFNOTSAME	animframe,-117,.vinc
	P_COLLISIONS	OFF
.vinc
	P_UNBECOME
	P_INEXT
	P_PULL		pbyte1
	P_RETURN

.crose_shield
	P_PUSH		pbyte1
	P_ZERO		pbyte1
	P_DO		4
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ADDANIM	-1,12
	P_IFNOTSAME	animframe,-128,.invinc
	P_COLLISIONS	ON
	P_SET		shape,egu_2
.invinc
	P_UNBECOME
	P_INEXT
	P_PULL		pbyte1
	P_RETURN
	
;---------------
	START_PATH	e_genkidama

	P_WEAPON	ERing
	P_COLLISIONS	OFF

	P_SOUNDEFTDISTPOS	en_ERing_charge	;$7b
	P_SPRITE	0,8

	P_DO		16
	P_ADD		tx,2
	P_NEXT

	P_RANDOMGOTO	.ame
	P_FACEPLAYER	IMMEDIATE
.ame
	P_GOSUB		.f
	P_WAIT		16
	P_ADD		roty,32
	P_GOSUB		.f
	P_REMOVE
.f
	P_DO		4
	P_PUSH		roty
	P_FACEPLAYER	IMMEDIATE
	P_PULL		roty
	P_FIRE
	P_ADD		roty,64
	P_INEXT
	P_RETURN
;;;;------------
	START_PATH	e_shield_robo_2_final
	P_INC		childrotx
	START_PATH	e_shield_robo_2

	P_SET		weapontype,1		;skidy
	P_IGOTO		pe_shield_robo.enter
;------------
	START_PATH	e_shield_robo_final
	P_INC		childrotx
	START_PATH	e_shield_robo

	P_ZERO		weapontype
.enter	LOCAL
	P_ACTIVE	ON
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,eg_remove
	P_ENEMYDMGSE	en_cry_2
	P_SET		skidy,hp
	P_GOSUB		.mk_shield_robo

	P_SET		slopenum,40
	P_SET		pbyte1,ap		;pbyte1 is current_point
	P_SET		hp,80
	P_GOSUB		wakidashi_init
	P_SETBOSSNAME	name_knight
	P_GOSUB		enemy_hp_meter_hydra
	P_SHADOW	OFF
	P_SET		coltab,id_1_c&WM
	P_RTRIGGER	.shield_hi,Always
	P_TRIGGER	anim_add_12_teku,Always
	P_RTRIGGER	.tun_robo_dead,WhenHit
	P_RTRIGGER	.shield_counter,WhenHit
	P_SET		roty,128
	P_SET		childy,128

.next_pos_move
	P_SETRANDOM	pbyte2,1		;pbyte2 is next_point_offset
	P_ADD		pbyte1,pbyte1
	P_ADD		pbyte1,pbyte2

	P_IFZERO	weapontype,.for_st_7
	P_INDEX		pbyte2,shield_r_next_tab_2,pbyte1
	P_IGOTO		.same_1
.for_st_7
	P_INDEX		pbyte2,shield_r_next_tab,pbyte1
.same_1
	P_SET		pbyte1,pbyte2
	P_ADD		pbyte2,pbyte2
	P_IFZERO	weapontype,.for_st7_2
	P_INDEX		childx,shield_r_x_z_2,pbyte2
	P_INC		pbyte2
	P_INDEX		childz,shield_r_x_z_2,pbyte2
	P_IGOTO		.same_2
.for_st7_2
	P_INDEX		childx,shield_r_x_z,pbyte2
	P_INC		pbyte2
	P_INDEX		childz,shield_r_x_z,pbyte2
.same_2
	P_GOSUB		put_marker
	P_BECOME
	P_FINDSHAPE	tekuteku
	P_GOSUB		impo_xz_world
;	P_IMPORT	worldx,gword1
;	P_IMPORT	worldz,gword2
	P_UNBECOME
.pos_move
	P_FACESHAPE
	P_MOVEINSHAPE	10
	P_SHAPEDISTLESS	30,.go_next_pos
	P_INC		pword1
	P_IFLARGER	pword1,childy,.atack_player
	P_GOTO		.pos_move
.go_next_pos
	P_FLAGSHAPE
	P_IGOTO		.next_pos_move

.tun_robo_dead
	P_IFLARGER	hp,slopenum,.live_ok
	P_TRIGGER	.shield_hi,OFF
	P_TRIGGER	anim_add_12_teku,OFF
	P_TRIGGER	.tun_robo_dead,OFF
	P_TRIGGER	.shield_counter,OFF
	P_FORCE		.dead_on
.live_ok
	P_RETURN

.atack_player
	P_TRIGGER	.shield_counter,OFF
	P_ZERO		pword1
.at_fire
	P_DO		20
	P_FACEPLAYER	y
	P_NEXT
	P_DO		10
	P_BECOMECHILD	1
	P_ADD		childx,18
	P_UNBECOME
	P_FACEPLAYER	y
	P_NEXT
	P_FLAGCHILD	2
	P_DO		13
	P_FACEPLAYER	y
	P_NEXT
;	P_WAIT		13
	P_DO		10
	P_BECOMECHILD	1
	P_ADD		childx,-18
	P_UNBECOME
	P_NEXT
	P_WAIT		20
	P_PLAYERINCONE	8,.at_fire
	P_INPLAYERSCONE	-15,15,.at_fire
	P_RTRIGGER	.shield_counter,WhenHit
	P_GOTO		.pos_move
.shield_counter
	P_FORCE		.atack_player
	P_RETURN
.shield_hi
	P_SET		worldy,-150		;-75
	P_RETURN
.dead_on
	P_COLLISIONS	OFF

	P_SCREENFLASH
;	P_IFZERO	childrotx,.not_final
;	P_GINC		b,ebyte2
;.not_final
	P_SCORE		sc_shield_robo

	P_TRIGGER	mk_many_damy_exp,8	;4
	P_FLAGCHILD	1
	P_UNLINKCHILD	1
	P_DO		15
	P_RANDOMGOTO	.no_fl1
	P_HITFLASHTRIG
.no_fl1
	P_NEXT

	P_BECOMECHILD	2
	P_SET		pbyte1,10
	P_UNBECOME
	P_FLAGCHILD	2
	P_UNLINKCHILD	2

	P_DO		10
	P_RANDOMGOTO	.no_fl
	P_HITFLASHTRIG
.no_fl
	P_NEXT
	P_SOUNDEFTPOS	en_death_2	;$79
	P_SOUNDEFTPOS	bs_BossExplode2	;$c0
	P_CIRCLEWINDOW	1,big
	P_DO		4
	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,8
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_NEXT

	P_IFZERO	childrotx,.not_final
	P_GINC		b,ebyte2
.not_final
	P_IFNOTZERO	childrotx,.s_final
	P_IMPORT	pbyte1,ebyte4
	P_SETSWITCH	skidy,pbyte1
	P_EXPORT	ebyte4,pbyte1
.s_final
	P_GOSUB		make_random_item
	P_EXPLODE

.mk_shield_robo	LOCAL
	P_SPAWN		0,0,160,0,0,0,teku_0,e_enemy_shield,100,4,1
	P_SPAWN		-80,0,0,0,0,0,teku_1,e_enemy_bazz,100,0,2
	P_RETURN
;;shield_r_next_tab
;;	db		1,4		;from 0
;;	db		5,4		;from 1
;;	db		4,6		;from 2
;;	db		2,7		;from 3
;;	db		3,8		;from 4
;;	db		2,3		;from 5
;;	db		7,10		;from 6
;;	db		9,10		;from 7
;;	db		1,7		;from 8
;;	db		0,8		;from 9
;;	db		3,11		;from 10
;;	db		8,9		;from 11
;;
;;shield_r_x_z
;;	dw		1536,2560
;;	dw		512,3584
;;	dw		-1536,2560
;;	dw		-512,2560
;;	dw		512,2560
;;	dw		-512,3584
;;	dw		-1536,1536
;;	dw		-512,1536
;;	dw		512,1536
;;	dw		1536,1536
;;	dw		-512,512
;;	dw		512,512
;;
;;shield_r_next_tab_2
;;	db		3,5		;from 0
;;	db		2,3		;from 1
;;	db		1,4		;from 2
;;	db		0,5		;from 3
;;	db		2,3		;from 4
;;	db		6,9		;from 5
;;	db		4,10		;from 6
;;	db		4,6		;from 7
;;	db		2,7		;from 8
;;	db		5,10		;from 9
;;	db		5,8		;from 10

;;shield_r_x_z_2
;;	dw		-1792,3328
;;	dw		-768,3840
;;	dw		1280,3840
;;	dw		-768,2816
;;	dw		768,2816
;;	dw		-768,1792
;;	dw		256,1792
;;	dw		1792,1792
;;	dw		1280,768
;;	dw		-1792,256
;;	dw		256,256

;;;;------------
	START_PATH	e_enemy_bazz

	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_ACTIVE	ON
	P_RTRIGGER	.fire,WhenFlagged
	P_END
.fire
	P_IFZERO	pbyte1,.fire_on
	P_FORCE		.body_dead
	P_RETURN
.fire_on
	P_SPAWN		-30,0,80,0,0,0,ring_mark,e_ring_mark_child,10,10,11
;	P_PUSH		childrotx
;	P_PUSH		childroty
;	P_PUSH		childrotz
;	P_FACEPLAYER	IMMEDIATE
;	P_ADJUSTROT
;	P_FIRE
;	P_PULL		childrotz
;	P_PULL		childroty
;	P_PULL		childrotx
	P_RETURN
.body_dead
	P_TRIGGER	.fire,OFF
	P_IGOTO		pe_enemy_shield.shield_dead
;;;;------------
	START_PATH	e_enemy_shield

	P_INVINCIBLE	ON
	P_SHADOW	OFF
	P_ACTIVE	ON
	P_SETANIM	0
	P_TRIGGER	reflect_laser,Always
	P_RTRIGGER	.body_dead,WhenFlagged
	P_END
.body_dead
	P_FORCE		.dead_on
	P_SET		pbyte1,30
	P_RANDOMGOTO	.npb1
	P_NEG		pbyte1
.npb1
	P_RETURN
.dead_on
	P_TRIGGER	.body_dead,OFF
.shield_dead	LOCAL
	P_IFNOTSAME	shape,egu_2,.not_egu_2
	P_SET		shape,egu_1
.not_egu_2
	P_DO		18
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte2,20
	P_ADD		roty,16
	P_ADD		worldx,pbyte1
	P_NEXT
	P_EXPLODE
;------------
	START_PATH	e_hikkomi_kabe

	P_ACTIVE	ON
	P_SET		skidy,worldy
	P_ZERO		worldy
	P_GOSUB		init_hardslope_soff
	P_IFSWITCH	skidy,.already_end
	P_SETANIM	0
.lp
	P_IFSWITCH	skidy,.down
	P_GOTO		.lp
.down
	P_SOUNDEFTDIST	ob_opendoor_s	;$ab
	P_DO		11
	P_ADDANIM	1,12
	P_NEXT
.already_end
	P_SETANIM	11
	P_SLOPE		OFF
	P_END
;------------
	START_PATH	e_damage_tatebou_movez

	P_INC		slopenum

	START_PATH	e_damage_tatebou_movex
	
	P_INC		slopenum

	START_PATH	e_damage_yokobou_move

	P_RANGECHECK	ON
	P_FIREOBJ       ON
	P_PASSSOUND	ON
	P_SET		hp,100
	P_SET		ap,4
	P_ACTIVE	ON
	P_SOUND		p2_da_ha_ta	;0D
	P_GOSUB		roty_pb2_pb1
	P_SET		skidy,pbyte1
	P_INDEX		roty,init_angle_tab,pbyte2
	P_IFSWITCH	skidy,.already_end
	P_INVINCIBLE	ON
	P_RTRIGGER	.switch_ck,Always
	P_SETANIM	0
	P_IFSAME	slopenum,1,.tatex
	P_IFSAME	slopenum,2,.tatez
.lp
	P_SOUNDEFTVIS	ob_tousen_move	;$9d
	P_DO		9
	P_ADD		worldy,16
	P_NEXT
	P_WAIT		15
	P_SOUNDEFTVIS	ob_tousen_move	;$9d
	P_DO		9
	P_ADD		worldy,-16
	P_NEXT
	P_WAIT		15
	P_GOTO		.lp
.tatex
	P_SOUNDEFTVIS	ob_tousen_move	;$9d
	P_DO		25
	P_ADD		worldx,16
	P_NEXT
	P_WAIT		15
	P_SOUNDEFTVIS	ob_tousen_move	;$9d
	P_DO		25
	P_ADD		worldx,-16
	P_NEXT
	P_WAIT		15
	P_GOTO		.tatex
.tatez
	P_SOUNDEFTVIS	ob_tousen_move	;$9d
	P_DO		25
	P_ADD		worldz,16
	P_NEXT
	P_WAIT		15
	P_SOUNDEFTVIS	ob_tousen_move	;$9d
	P_DO		25
	P_ADD		worldz,-16
	P_NEXT
	P_WAIT		15
	P_GOTO		.tatez

.switch_ck
	P_IFSWITCH	skidy,.stop
	P_RETURN
.stop
	P_FORCE		.stop_on
	P_RETURN
.stop_on
	P_TRIGGER	.switch_ck,OFF
	P_DO		3
	P_ADDANIM	1,3
	P_NEXT
.already_end
	P_PASSSOUND	OFF
	P_COLLISIONS	OFF
	P_SETANIM	3
	P_SETCOLANIM	3
	P_SOUND		port2_stop	;0D
	P_END
;------------
	START_PATH	e_damage_bou

	P_FIREOBJ       ON
	P_PASSSOUND	ON
	P_SET		hp,100
	P_SET		ap,4
	P_ACTIVE	ON
	P_SOUND		p2_da_ha_ta	;0D
	P_GOSUB		roty_pb2_pb1
	P_SET		skidy,pbyte1
	P_INDEX		roty,init_angle_tab,pbyte2
	P_IFSWITCH	skidy,.already_end
	P_INVINCIBLE	ON
	P_SETANIM	0
.lp
	P_IFSWITCH	skidy,.off
	P_GOTO		.lp
.off
	P_DO		3
	P_ADDANIM	1,3
	P_NEXT
.already_end
	P_PASSSOUND	OFF
	P_COLLISIONS	OFF
	P_SETANIM	3
	P_SETCOLANIM	3
	P_SOUND		port2_stop	;0D
	P_END
;-----------
	START_PATH	e_damage_yuka

	P_SET		hp,100
	P_SET		ap,2
	P_SOUND		p2_da_ha_ta	;0D
	P_RANGECHECK	ON
	P_INVINCIBLE	ON
	P_COLLISIONS	OFF
	P_GROUNDOBJ	ON
	P_SET		childx,worldx
	P_ADD		childx,60<<da_yuka_scale
	P_SET		ox,worldx
	P_ADD		ox,-60<<da_yuka_scale
	P_SET		childz,worldz
	P_ADD		childz,60<<da_yuka_scale
	P_SET		oz,worldz
	P_ADD		oz,-60<<da_yuka_scale
	P_SET		childy,-40

.lp
	P_IFARWING	.sky
	P_DISTLESS	70<<da_yuka_scale,.ck
.sky
	P_GOTO		.lp
.ck
	P_IMPORT	pword1,Player1_worldx
	P_IFSMALLER	pword1,ox,.out
	P_IFLARGER	pword1,childx,.out
	P_IMPORT	pword1,Player1_worldz
	P_IFSMALLER	pword1,oz,.out
	P_IFLARGER	pword1,childz,.out
	P_IMPORT	pword1,Player1_worldy
	P_IFSMALLER	pword1,childy,.outin

	P_IFNOTZERO	pbyte2,.not_hajimete
	P_COLLISIONS	ON
	P_PLRBURN	c
	P_WAIT		1
	P_COLLISIONS	OFF
	P_SET		pbyte2,1
	P_SET		pbyte1,15
.not_hajimete
	P_IFZERO	pbyte1,.damage
	P_DEC		pbyte1
	P_GOTO		.lp
.damage
	P_COLLISIONS	ON
	P_PLRBURN	c
	P_WAIT		1
	P_SET		pbyte1,15
	P_COLLISIONS	OFF
	P_GOTO		.lp

.out
	P_ZERO		pbyte1
	P_ZERO		pbyte2
.outin
	P_GOTO		.lp

;;;;------------
	START_PATH	e_tousenbo

	P_GOSUB		init_hardslope_soff
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,254,.already_end
	P_SETANIM	0
	P_RTRIGGER	.child_dead,WhenFlagged
	P_SET		pbyte1,100
.at_wait
	P_DISTLESS	1000,.at_on
	P_GOTO		.at_wait
.at_on
	P_EXPORT	gbyte1,pbyte1
	P_SPAWN		0,-150,-5<<kakureto_scale,0,128,0,room_hou,e_tousenbo_c,100,4,1
	P_BECOME
	P_IMPORT	hp,gbyte1
	P_SETRANDOM	pword1,511
	P_ADD		pword1,-256
	P_ADD		childx,pword1
	P_SETRANDOM	pword1,255
	P_ADD		pword1,-128
	P_ADD		childy,pword1
	P_INVISIBLE	ON
	P_SETANIM	0
	P_UNBECOME
	P_WAIT		60
	P_GOTO		.at_wait
.already_end
	P_SETANIM	11
	P_SLOPE		OFF
	P_END
.child_dead
	P_FORCE		.open
	P_RETURN
.open
	P_TRIGGER	.child_dead,OFF
	P_WAIT		15
	P_GOSUB		open_door
	P_GINC		b,ebyte2
	P_END
;-----------
	START_PATH	e_tousenbo_c

	P_SETANIM	0
	P_COLLISIONS	OFF
	P_RTRIGGER	.dead_ck,WhenHit

	P_GOSUB		pe_kabe_mukade.nobiru

	P_GOSUB		pe_kabe_mukade.kabe_muka_at
	P_WAIT		15

	P_GOSUB		pe_kabe_mukade.chijimu
	P_EXPORT	gbyte1,hp
	P_BECOMEMOTHER
	P_IMPORT	pbyte1,gbyte1
	P_UNBECOME
	P_REMOVE
.dead_ck
	P_SET		pbyte1,80
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.dead_ck,OFF
	P_FLAGMOTHER
	P_COLLISIONS	OFF
	P_SCORE		sc_kabe_mukade
	P_SCREENFLASH
	P_GOSUB		s_group_explode
	P_GOSUB		make_hp_item_random
	P_EXPLODE
;----------
;	START_PATH	e_tousenbo
;
;	P_GOSUB		wakidashi_init
;	P_WEAPON	ERing
;	P_TRIGGER	.hit,WhenHit
;	P_TRIGGER	.can_hit_ck,Always
;	P_HITFLASH	OFF
;	P_INVINCIBLE	ON
;;	P_SLOPE		ON
;.lp
;	P_SETANIM	7
;	P_DISTLESS	600,.mv
;	P_GOTO		.lp
;.mv
;	P_ZERO		pbyte1
;
;	P_TRIGGER	.anim_on,Always,60
;	P_WAIT		61
;;	P_TRIGGER	.anim_on,OFF
;
;	P_ADD		roty,128
;	P_ADD		rotx,128
;
;	P_SOUNDEFTDISTPOS	ob_tousen_roll	;$97*
;	P_DO		32
;	P_ADD		rotx,4
;	P_NEXT
;
;	P_WAIT		30
;
;	P_SOUNDEFTDISTPOS	ob_tousen_roll	;$97*
;	P_DO		32
;	P_ADD		rotx,4
;	P_NEXT
;
;	P_ADD		roty,128
;	P_ADD		rotx,128
;
;	P_GOTO		.lp
;	P_END
;.anim_on
;	P_RANDOMGOTO	.a
;	P_IFSAME	pbyte1,7,.atack0
;	P_IFSAME	pbyte1,22,.atack1
;.a
;	P_IFSAME	pbyte1,12,.oto
;	P_IFSAME	pbyte1,27,.oto
;.b
;	P_INDEX		animframe,.tou_anim_tab,pbyte1
;	P_INC		pbyte1
;	P_IFNOTSAME	pbyte1,30,.anim_ok
;	P_ZERO		pbyte1
;.anim_ok
;	P_RETURN
;.oto
;	P_SOUNDEFTDISTPOS	ob_tousen_move	;$9d
;	P_IGOTO		.b
;.atack0
;	P_SPAWN		-50<<tousenbo_scale,0,0,0,0,0,nullshape,e_tousenbo_fire,100,0,1
;	P_IGOTO		.a
;.atack1
;	P_SPAWN		50<<tousenbo_scale,0,0,0,0,0,nullshape,e_tousenbo_fire,100,0,1
;	P_IGOTO		.a
;.tou_anim_tab
;	db	-121,-120,-119,-118,-117,-116,-115,-114
;	db	-114,-115,-116,-117,-118,-119,-120,-121,-122,-123,-124,-125,-126,-127,-128
;	db	-128,-127,-126,-125,-124,-123,-122
;.can_hit_ck
;	P_IMPORT	worldy,Player1_worldy
;	P_ADD		worldy,32
;	P_IFNOTBETWEEN	-80,worldy,100,.yuka_ok
;	P_SET		worldy,-80
;.yuka_ok
;	P_IFNOTBETWEEN	-600,worldy,-300,.ten_ok
;	P_SET		worldy,-300
;.ten_ok
;	P_PLAYERINCONE	64,.cant
;	P_INVINCIBLE	OFF
;	P_RETURN
;.cant
;	P_INVINCIBLE	ON
;	P_RETURN
;.hit
;;	P_IFHITFLAG	.no_damage,2
;	P_HITFLASHTRIG
;	P_FORCE		.dead
;	P_RETURN
;;.no_damage
;;	P_SET		hp,100
;;	P_SOUNDEFTDIST	ob_reboundlaser_s	;$a8
;;	P_RETURN
;.dead
;	P_TRIGGER	.hit,OFF
;	P_COLLISIONS	OFF
;	P_GOSUB		hit_dead
;	P_SET		shape,tousenbo_s
;	P_GINC		b,ebyte2
;	P_EXPLODE
;;-----------
;	START_PATH	e_to_hou_fire
;
;	P_INVISIBLE	ON
;	P_WAIT		1
;
;	START_PATH	e_tousenbo_fire
;
;	P_WEAPON	ERing
;	P_GOSUB		sos_fire_must
;	P_REMOVE
;;;;------------
	START_PATH	e_guruguru_bar

	P_SET		hp,100
	P_INVISIBLE	ON
	P_SET		pbyte1,roty

	P_GSET		w,gword1,1000
	P_GSET		b,gbyte1,1
	P_DO		5
	P_SPAWN		0,0,0,0,0,0,toge_0,e_hard_obj,100,4,1
	P_BECOME
	P_SET		coltab,id_1_c&wm
	P_IMPORT	childx,gword1
	P_IMPORT	pbyte1,gbyte1
	P_SETID		pbyte1
	P_SET		pword1,childx
	P_ADD		pword1,-200
	P_EXPORT	gword1,pword1
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT

;	P_SPAWN		1000,0,0,0,0,0,toge_0,e_hard_obj,100,4,1
;	P_SPAWN		800,0,0,0,0,0,toge_0,e_hard_obj,100,4,2
;	P_SPAWN		600,0,0,0,0,0,toge_0,e_hard_obj,100,4,3
;	P_SPAWN		400,0,0,0,0,0,toge_0,e_hard_obj,100,4,4
;	P_SPAWN		200,0,0,0,0,0,toge_0,e_hard_obj,100,4,5
.lp
	P_ADD		roty,pbyte1
	P_GOTO		.lp

	START_PATH	e_hard_obj

	P_INVINCIBLE	ON
	P_RADAROBJ	ra_enemy
	P_END
;;;;------------
	START_PATH	e_tunnel_tobidashi_p_final
	P_TRIGGER	inc_final_door_lock,WhenDead
	START_PATH	e_tunnel_tobidashi_p
	P_SET		pbyte1,16
	P_IGOTO		pe_tunnel_tobidashi_m.enter
	START_PATH	e_tunnel_tobidashi_m_final
	P_TRIGGER	inc_final_door_lock,WhenDead
	START_PATH	e_tunnel_tobidashi_m
	P_SET		pbyte1,-16
.enter	LOCAL
	P_IMPORT	pbyte2,ebyte2
	P_IFSAME	pbyte2,254,eg_remove
	P_SET		pbyte2,roty
	P_GOSUB		hit_dead_init
	P_RTRIGGER	.tobidashi_face,Always
	P_TRIGGER	hit_dead,WhenDead
	P_TRIGGER	anim_add_12_teku,Always
	P_WEAPON	ELaser
.lp
	P_IFSAME	pbyte2,64,.wz
	P_IFSAME	pbyte2,-64,.wz
	P_DO		16
	P_ADD		worldx,pbyte1
	P_NEXT
	P_WAIT		8
	P_GOSUB		.tobidashi_f
	P_NEG		pbyte1
	P_DO		16
	P_ADD		worldx,pbyte1
	P_NEXT
	P_NEG		pbyte1
	P_WAIT		30
	P_GOTO		.lp
.wz
	P_DO		16
	P_ADD		worldz,pbyte1
	P_NEXT
	P_WAIT		8
	P_GOSUB		.tobidashi_f
	P_NEG		pbyte1
	P_DO		16
	P_ADD		worldz,pbyte1
	P_NEXT
	P_NEG		pbyte1
	P_WAIT		30
	P_GOTO		.lp
.tobidashi_face
	P_FACEPLAYER	y
	P_RETURN
.tobidashi_f
	P_DO		3
	P_GOSUB		sos_fire_must
	P_WAIT		4
	P_NEXT
	P_RETURN
;------------
	START_PATH	e_tunnel_robo_jump

	P_GOSUB		hit_dead_init
	P_WEAPON	ELaser
	P_TRIGGER	hit_dead,WhenDead
	P_RTRIGGER	.face,Always
.lp
	P_SOUNDEFTDISTPOS	en_teku_jump	;$87*
	P_ZERO		pbyte1
	P_DO		14
	P_IFNOTSAME	pbyte1,6,.pass_atack
	P_GOSUB		sos_fire_must
.pass_atack
	P_AUTOINDEX	b,worldy,dandou_tab,pbyte1,14
	P_NEXT
	P_SOUNDEFTDISTPOS	en_Land_2	;$7a
	P_WAIT		30
	P_GOTO		.lp
.face
	P_FACEPLAYER	y
	P_RETURN
;------------
	START_PATH	e_tunnel_robo_3_final
	P_ADD		skidy,64
	START_PATH	e_tunnel_robo_2_final
	P_ADD		skidy,64
	START_PATH	e_tunnel_robo_1_final
	P_ADD		skidy,64
	START_PATH	e_tunnel_robo_0_final
	P_TRIGGER	inc_final_door_lock,WhenDead
	P_IGOTO		pe_tunnel_robo_0.enter

	START_PATH	e_tunnel_robo_3
	P_ADD		skidy,64
	START_PATH	e_tunnel_robo_2
	P_ADD		skidy,64
	START_PATH	e_tunnel_robo_1
	P_ADD		skidy,64
	START_PATH	e_tunnel_robo_0
.enter	LOCAL
	P_IMPORT	slopenum,ebyte2
	P_IFSAME	slopenum,254,eg_remove
	P_SET		slopenum,4

	P_IFLARGER	roty,tx,.pb1_more
	P_NEG		roty
	P_NEG		slopenum
.pb1_more
	P_ADD		roty,-10
	P_IFSMALLER	roty,tx,.ok_pb1
	P_INC		pbyte1
	P_IGOTO		.pb1_more
.ok_pb1
	P_ADD		roty,10
	P_SET		pbyte2,roty
	P_SET		roty,skidy

	P_GOSUB		hit_dead_init
	P_TRIGGER	hit_dead,WhenDead
;	P_GOSUB		set_hp100_ap4_enemy
;	P_RTRIGGER	.tun_robo_dead,WhenHit		;Dead
	P_TRIGGER	anim_add_12_teku,Always
	P_TRIGGER	.tun_robo_fire,8
	P_WEAPON	ELaser
.loop
	P_IFZERO	pbyte1,.pass1
	P_ACCEL		10,1
	P_DO		pbyte1
	P_WAIT		10
	P_INEXT
	P_ACCEL		0,1
.pass1
	P_DO		16
	P_ADD		roty,slopenum
	P_NEXT

	P_IFZERO	pbyte2,.pass2
	P_ACCEL		10,1
	P_DO		pbyte2
	P_WAIT		10
	P_INEXT
	P_ACCEL		0,1
.pass2
	P_DO		16
	P_ADD		roty,slopenum
	P_NEXT

	
	P_GOTO		.loop
.tun_robo_fire
	P_PLAYERINCONE	20,.fire
	P_RETURN
.fire
	P_GOSUB		sos_fire_must
	P_RETURN
;;;;------------
	START_PATH	e_wakidashi_mukade

;;;.mini_start	LOCAL
;;;	P_SET		skidy,roty
	P_ENEMYDMGSE	en_cry_2
	P_GOSUB		set_hp100_ap4
	P_RADAROBJ	ra_enemy
	P_INC		pbyte2
	P_SET		tx,25		;mukade no hp

	P_GOSUB		set_child_xz

	P_TRIGGER	shadow_ck,Always
	P_TRIGGER	.m_hit_ck,Always
	P_TRIGGER	.m_hited,WhenHit
	P_ALWAYSGENVECS	ON
	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_INVISIBLE	ON
.again
	P_SETRANDOM	roty
	P_SET		childroty,roty

;;;	P_IFSAME	skidy,-1,.for_long_y
	P_SET		worldy,550
;;;	P_IGOTO		.same_y
;;;.for_long_y
;;;	P_SET		worldy,600
;;;.same_y
	P_SETVEL	40
	P_WAIT		30
	P_SETVEL	0

	P_GOSUB		.mukade_mk_c
	P_TRIGGER	hasami_smoke,2
	P_INVISIBLE	OFF
	P_CLIPPING	ON
	P_RADAROBJ	ra_enemy

	P_WAIT		5
	P_FLAGCHILD	1
	P_FLAGCHILD	2
	P_FLAGCHILD	3

;;;	P_FLAGCHILD	4
;;;	P_FLAGCHILD	5


	P_DO		40
	P_ADD		worldy,-10
	P_ADD		roty,8
	P_NEXT

	P_FLAGCHILD	1
	P_FLAGCHILD	2
	P_FLAGCHILD	3
;;;	P_FLAGCHILD	4
;;;	P_FLAGCHILD	5

	P_DO		15
	P_ADD		worldy,-10
	P_NEXT

	P_TRIGGER	hasami_smoke,OFF
	P_RTRIGGER	.mukade_face_p,Always

	P_WAIT		50

	P_TRIGGER	.mukade_face_p,OFF
	P_TRIGGER	hasami_smoke,2

	P_DO		15
	P_ADD		worldy,10
	P_NEXT

	P_FLAGCHILD	1
	P_FLAGCHILD	2
	P_FLAGCHILD	3
;;;	P_FLAGCHILD	4
;;;	P_FLAGCHILD	5

	P_DO		40
	P_ADD		worldy,10
	P_ADD		roty,8
	P_NEXT

	P_TRIGGER	hasami_smoke,OFF
	P_INVISIBLE	ON
	P_CLIPPING	OFF
	P_REMOVE	1
	P_REMOVE	2
	P_REMOVE	3
;;;	P_REMOVE	4
;;;	P_REMOVE	5
	P_SET		roty,childroty
	P_ADD		roty,127
	P_SETVEL	40
	P_WAIT		30
	P_SETVEL	0
	P_GOTO		.again

.mukade_face_p
	P_FACEPLAYER	y
	P_PLAYERINCONE	5,.atack
	P_IGOTO		.end_atack
.atack
	P_IFNOTZERO	childrotz,.wait_atack
;;;	P_IFSAME	skidy,-1,.long_atack
	P_BECOMECHILD	3
;;;	P_IGOTO		.short_at
;;;.long_atack
;;;	P_BECOMECHILD	5
.short_at
	P_INC		slopenum
	P_UNBECOME
	P_SET		childrotz,20
.wait_atack
	P_DEC		childrotz
.end_atack
	P_ADD		pbyte1,pbyte2
	P_ADD		roty,pbyte1
	P_IFSAME	pbyte1,3,.neg_pb2
	P_IFSAME	pbyte1,-3,.neg_pb2
	P_RETURN
.neg_pb2
	P_NEG		pbyte2
	P_RETURN

.mukade_mk_c	LOCAL
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,-180,0,0,0,0,mukade_1,e_mukade_c,100,0,1
	P_BECOME
	P_INVISIBLE	ON
	P_INC		pbyte1
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_RETURN

.m_hit_ck
	P_IFZERO	slopenum,.no_dam
	P_ADD		ty,slopenum
	P_ZERO		slopenum
	P_IFSMALLER	ty,tx,.no_dam
	P_FORCE		.mukade_down
.no_dam
	P_RETURN

.m_hited
	P_NEG		hp
	P_ADD		hp,100
	P_SET		slopenum,hp
	P_SET		hp,100
	P_RETURN
.mukade_down
	P_TRIGGER	.m_hit_ck,OFF
	P_TRIGGER	.mukade_face_p,OFF

	P_SOUNDEFTPOS	en_death_2	;$79
	P_SCREENFLASH
	P_SCORE		sc_mukade_target

	P_ZERO		pbyte1
	P_DO		5
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ACTIVE	ON
	P_INC		pbyte2
	P_UNBECOME
	P_INEXT
	P_SET		pword1,50
	P_RTRIGGER	.cry_dead,32
.up_again
	P_IFSMALLER	worldy,pword1,.up_end
	P_ADD		worldy,-10
	P_GOTO		.up_again
.up_end
	P_TRIGGER	hasami_smoke,OFF
.up_end2
	P_CHILDDEAD	1,.exp_on
	P_GOTO		.up_end2
.exp_on
	P_TRIGGER	.cry_dead,OFF
	P_WAIT		2
	P_SET		shape,mukade_2end
	P_ADD		worldy,-100
	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,32
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME

	P_GSET		b,gbyte1,40h
	P_GOSUB		set_medal

	P_ADD		worldy,100

;;;	P_IFSAME	skidy,-1,.normal
;;;	P_DEC		skidy
;;;	P_IFZERO	skidy,.normal
;;;	P_EXPORT	gbyte1,skidy
;;;	P_EXPORT	gword1,childx
;;;	P_EXPORT	gword3,childz
;;;	P_QSPAWN	mukade_1,e_mini_mukade_target,100,4
;;;	P_BECOME
;;;	P_IMPORT	worldy,gbyte1
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldz,gword3
;;;	P_INVISIBLE	ON
;;;	P_UNBECOME
;;;.normal
	P_GOSUB		wakidashi_dead_no_sc
	P_END
;;;	P_EXPLODE
.cry_dead
	P_SOUNDEFTPOS	en_death_2	;$79
	P_RETURN
;------------
	START_PATH	e_mukade_c

	P_RTRIGGER	.c_hit,WhenHit
	P_RTRIGGER	.m_dead_ck,Always
	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_SETID		pbyte1
	P_RTRIGGER	.mukade_c_start,WhenFlagged

;;;	P_IFSAME	skidy,-1,.long
	P_SET		childy,-80
	P_IFNOTSAME	pbyte1,3,.for_body
;;;	P_IGOTO		.short_head
;;;.long
;;;	P_IFNOTSAME	pbyte1,5,.for_body
;;;.short_head
	P_SET		shape,mukade_0
	P_WEAPON	ERing			;EPlasma1
	P_RTRIGGER	.atack_wait,Always
;;;	P_TRIGGER	marker_set,Always
	P_END
.atack_wait
	P_IFZERO	slopenum,.no_atack
	P_GOSUB		sos_fire_must
;;;	P_QSPAWN	nullshape,e_eplasma_hou,100,0
	P_ZERO		slopenum
.no_atack
	P_RETURN
.for_body
;;;	P_IFSAME	skidy,-1,.for_long_look
	P_ADD		childrotx,14
;;;	P_IGOTO		.short_same
;;;.for_long_look
;;;	P_ADD		childrotx,6
;;;.short_same
	P_EXPORT	gbyte2,childrotx
	P_INC		pbyte1
	P_EXPORT	gbyte1,pbyte1
	P_EXPORT	gbyte3,skidy
	P_SPAWN		0,-80,0,0,0,0,mukade_1,e_mukade_c,100,2,1	
	P_BECOME
	P_INVISIBLE	ON
	P_IMPORT	pbyte1,gbyte1
	P_IMPORT	childrotx,gbyte2
	P_IMPORT	skidy,gbyte3
	P_UNBECOME

	P_DEC		pbyte1

	P_END
.mukade_c_start
	P_FORCE		.start
	P_RETURN
.start
	P_TRIGGER	.mukade_c_start,OFF
	P_INVISIBLE	OFF
	P_IFNOTSAME	pbyte1,3,.for_body_col
	P_COLLISIONS	OFF
.for_body_col
	P_IFSAME	ap,20,.for_exp
	P_TRIGGER	shadow_ck,Always
	P_CLIPPING	ON
.for_exp
	P_SET		ty,childrotx
	P_ZERO		childrotx
	P_RTRIGGER	.mukade_look,WhenFlagged
	P_END
.mukade_look
	P_FORCE		.look
	P_RETURN
.look
	P_TRIGGER	.mukade_look,OFF
.look_again
	P_CHASE		childrotx,ty
	P_IFSAME	childrotx,ty,.look_end
	P_GOTO		.look_again
.look_end
	P_RTRIGGER	.unlook,WhenFlagged
	P_END
.unlook
	P_FORCE		.unlook_on
	P_RETURN
.unlook_on
	P_TRIGGER	.unlook,OFF
.again
	P_CHASE		childrotx,0
	P_GOTO		.again
.c_hit
	P_NEG		hp
	P_ADD		hp,100
	P_EXPORT	gbyte1,hp
	P_SET		hp,100
	P_BECOMEMOTHER
	P_IMPORT	slopenum,gbyte1
	P_UNBECOME
	P_RETURN
.m_dead_ck
	P_IFZERO	pbyte2,.live
	P_FORCE		.m_dead
.live
	P_RETURN
.m_dead
	P_TRIGGER	.m_dead_ck,OFF
	P_IFSAME	pbyte1,2,.no_exp
	P_IFSAME	pbyte1,4,.no_exp
	P_TRIGGER	mk_many_damy_exp,4
.no_exp
	P_DO		16
	P_CHASE		childrotx,0
	P_NEXT
.modae
	P_DO		2		;4
	P_DO		10		;10
	P_CHASE		childrotx,ty
	P_CHASE		childrotz,ty
	P_NEXT
	P_NEG		ty
	P_NEXT

	P_NEG		pbyte1
	P_ADD		pbyte1,10
	P_DO		pbyte1
	P_WAIT		1
	P_NEXT
	P_EXPLODE



;;;	START_PATH	e_mini_mukade_target
;;;
;;;	P_SET		skidy,worldy
;;;	P_IGOTO		pe_mukade_target.mini_start
;;;
;;;	START_PATH	e_mukade_target
;;;
;;;	P_DEC		skidy
;;;.mini_start	LOCAL
;;;	P_GOSUB		set_hp100_ap4
;;;	P_INC		pbyte2
;;;	P_SET		tx,30		;mukade no hp
;;;
;;;	P_GOSUB		set_child_xz
;;;
;;;	P_TRIGGER	shadow_ck,Always
;;;	P_TRIGGER	.m_hit_ck,Always
;;;	P_TRIGGER	.m_hited,WhenHit
;;;	P_ALWAYSGENVECS	ON
;;;	P_COLLISIONS	OFF
;;;	P_SHADOW	OFF
;;;	P_INVISIBLE	ON
;;;.again
;;;	P_SETRANDOM	roty
;;;	P_SET		childroty,roty
;;;
;;;	P_IFSAME	skidy,-1,.for_long_y
;;;	P_SET		worldy,550
;;;	P_IGOTO		.same_y
;;;.for_long_y
;;;	P_SET		worldy,600
;;;.same_y
;;;	P_SETVEL	40
;;;	P_WAIT		30
;;;	P_SETVEL	0
;;;
;;;	P_GOSUB		.mukade_mk_c
;;;	P_TRIGGER	hasami_smoke,2
;;;	P_INVISIBLE	OFF
;;;	P_CLIPPING	ON
;;;	P_RADAROBJ	ra_enemy
;;;
;;;	P_WAIT		5
;;;	P_FLAGCHILD	1
;;;	P_FLAGCHILD	2
;;;	P_FLAGCHILD	3
;;;	P_FLAGCHILD	4
;;;	P_FLAGCHILD	5
;;;
;;;
;;;	P_DO		40
;;;	P_ADD		worldy,-10
;;;	P_ADD		roty,8
;;;	P_NEXT
;;;
;;;	P_FLAGCHILD	1
;;;	P_FLAGCHILD	2
;;;	P_FLAGCHILD	3
;;;	P_FLAGCHILD	4
;;;	P_FLAGCHILD	5
;;;
;;;	P_DO		15
;;;	P_ADD		worldy,-10
;;;	P_NEXT
;;;
;;;	P_TRIGGER	hasami_smoke,OFF
;;;	P_TRIGGER	.mukade_face_p,Always
;;;
;;;	P_WAIT		50
;;;
;;;	P_TRIGGER	.mukade_face_p,OFF
;;;	P_TRIGGER	hasami_smoke,2
;;;
;;;	P_DO		15
;;;	P_ADD		worldy,10
;;;	P_NEXT
;;;
;;;	P_FLAGCHILD	1
;;;	P_FLAGCHILD	2
;;;	P_FLAGCHILD	3
;;;	P_FLAGCHILD	4
;;;	P_FLAGCHILD	5
;;;
;;;	P_DO		40
;;;	P_ADD		worldy,10
;;;	P_ADD		roty,8
;;;	P_NEXT
;;;
;;;	P_TRIGGER	hasami_smoke,OFF
;;;	P_INVISIBLE	ON
;;;	P_CLIPPING	OFF
;;;	P_REMOVE	1
;;;	P_REMOVE	2
;;;	P_REMOVE	3
;;;	P_REMOVE	4
;;;	P_REMOVE	5
;;;	P_SET		roty,childroty
;;;	P_ADD		roty,127
;;;	P_SETVEL	40
;;;	P_WAIT		30
;;;	P_SETVEL	0
;;;	P_GOTO		.again
;;;.mukade_face_p
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	5,.atack
;;;	P_IGOTO		.end_atack
;;;.atack
;;;	P_IFNOTZERO	childrotz,.wait_atack
;;;	P_IFSAME	skidy,-1,.long_atack
;;;	P_BECOMECHILD	3
;;;	P_IGOTO		.short_at
;;;.long_atack
;;;	P_BECOMECHILD	5
;;;.short_at
;;;	P_INC		slopenum
;;;	P_UNBECOME
;;;	P_SET		childrotz,20
;;;.wait_atack
;;;	P_DEC		childrotz
;;;.end_atack
;;;	P_ADD		pbyte1,pbyte2
;;;	P_ADD		roty,pbyte1
;;;	P_IFSAME	pbyte1,3,.neg_pb2
;;;	P_IFSAME	pbyte1,-3,.neg_pb2
;;;	P_RETURN
;;;.neg_pb2
;;;	P_NEG		pbyte2
;;;	P_RETURN
;;;.mukade_mk_c	LOCAL
;;;	P_EXPORT	gbyte1,skidy
;;;	P_SPAWN		0,-180,0,0,0,0,mukade_1,e_mukade_c,100,0,1
;;;	P_BECOME
;;;	P_INVISIBLE	ON
;;;	P_INC		pbyte1
;;;	P_IMPORT	skidy,gbyte1
;;;	P_UNBECOME
;;;	P_RETURN
;;;.m_hit_ck
;;;	P_IFZERO	slopenum,.no_dam
;;;	P_ADD		ty,slopenum
;;;	P_ZERO		slopenum
;;;	P_IFSMALLER	ty,tx,.no_dam
;;;	P_FORCE		.mukade_down
;;;.no_dam
;;;	P_RETURN
;;;.m_hited
;;;	P_NEG		hp
;;;	P_ADD		hp,100
;;;	P_SET		slopenum,hp
;;;	P_SET		hp,100
;;;	P_RETURN
;;;.mukade_down
;;;	P_TRIGGER	.m_hit_ck,OFF
;;;	P_TRIGGER	.mukade_face_p,OFF
;;;
;;;	P_SCREENFLASH
;;;	P_CLRDEMOSHAPE
;;;	P_SCORE		sc_mukade_target
;;;	P_GDEC		b,KEnemyNumber
;;;
;;;	P_ZERO		pbyte1
;;;	P_DO		5
;;;	P_INC		pbyte1
;;;	P_BECOMECHILD	pbyte1
;;;	P_ACTIVE	ON
;;;	P_INC		pbyte2
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_SET		pword1,50
;;;.up_again
;;;	P_IFSMALLER	worldy,pword1,.up_end
;;;	P_ADD		worldy,-10
;;;	P_GOTO		.up_again
;;;.up_end
;;;	P_TRIGGER	hasami_smoke,OFF
;;;.up_end2
;;;	P_CHILDDEAD	1,.exp_on
;;;	P_GOTO		.up_end2
;;;.exp_on
;;;	P_WAIT		2
;;;	P_SET		shape,mukade_2end
;;;	P_ADD		worldy,-100
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,32
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_ADD		worldy,100
;;;
;;;	P_IFSAME	skidy,-1,.normal
;;;	P_DEC		skidy
;;;	P_IFZERO	skidy,.normal
;;;	P_EXPORT	gbyte1,skidy
;;;	P_EXPORT	gword1,childx
;;;	P_EXPORT	gword3,childz
;;;	P_QSPAWN	mukade_1,e_mini_mukade_target,100,4
;;;	P_BECOME
;;;	P_IMPORT	worldy,gbyte1
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldz,gword3
;;;	P_INVISIBLE	ON
;;;	P_UNBECOME
;;;.normal
;;;	P_EXPLODE
;;;;------------
;;;	START_PATH	e_mukade_c
;;;
;;;	P_TRIGGER	.c_hit,WhenHit
;;;	P_TRIGGER	.m_dead_ck,Always
;;;	P_COLLISIONS	OFF
;;;	P_SHADOW	OFF
;;;	P_SETID		pbyte1
;;;	P_TRIGGER	.mukade_c_start,WhenFlagged
;;;
;;;	P_IFSAME	skidy,-1,.long
;;;	P_SET		childy,-80
;;;	P_IFNOTSAME	pbyte1,3,.for_body
;;;	P_IGOTO		.short_head
;;;.long
;;;	P_IFNOTSAME	pbyte1,5,.for_body
;;;.short_head
;;;	P_SET		shape,mukade_0
;;;	P_TRIGGER	.atack_wait,Always
;;;	P_TRIGGER	marker_set,Always
;;;	P_END
;;;.atack_wait
;;;	P_IFZERO	slopenum,.no_atack
;;;	P_QSPAWN	nullshape,e_eplasma_hou,100,0
;;;	P_ZERO		slopenum
;;;.no_atack
;;;	P_RETURN
;;;.for_body
;;;	P_IFSAME	skidy,-1,.for_long_look
;;;	P_ADD		childrotx,14
;;;	P_IGOTO		.short_same
;;;.for_long_look
;;;	P_ADD		childrotx,6
;;;.short_same
;;;	P_EXPORT	gbyte2,childrotx
;;;	P_INC		pbyte1
;;;	P_EXPORT	gbyte1,pbyte1
;;;	P_EXPORT	gbyte3,skidy
;;;	P_SPAWN		0,-80,0,0,0,0,mukade_1,e_mukade_c,100,2,1	
;;;	P_BECOME
;;;	P_INVISIBLE	ON
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_IMPORT	childrotx,gbyte2
;;;	P_IMPORT	skidy,gbyte3
;;;	P_UNBECOME
;;;
;;;	P_DEC		pbyte1
;;;
;;;	P_END
;;;.mukade_c_start
;;;	P_FORCE		.start
;;;	P_RETURN
;;;.start
;;;	P_TRIGGER	.mukade_c_start,OFF
;;;	P_INVISIBLE	OFF
;;;	P_IFSAME	ap,20,.for_exp
;;;	P_TRIGGER	shadow_ck,Always
;;;	P_CLIPPING	ON
;;;.for_exp
;;;	P_SET		ty,childrotx
;;;	P_ZERO		childrotx
;;;	P_TRIGGER	.mukade_look,WhenFlagged
;;;	P_END
;;;.mukade_look
;;;	P_FORCE		.look
;;;	P_RETURN
;;;.look
;;;	P_TRIGGER	.mukade_look,OFF
;;;.look_again
;;;	P_CHASE		childrotx,ty
;;;	P_IFSAME	childrotx,ty,.look_end
;;;	P_GOTO		.look_again
;;;.look_end
;;;	P_TRIGGER	.unlook,WhenFlagged
;;;	P_END
;;;.unlook
;;;	P_FORCE		.unlook_on
;;;	P_RETURN
;;;.unlook_on
;;;	P_TRIGGER	.unlook,OFF
;;;.again
;;;	P_CHASE		childrotx,0
;;;	P_GOTO		.again
;;;.c_hit
;;;	P_NEG		hp
;;;	P_ADD		hp,100
;;;	P_EXPORT	gbyte1,hp
;;;	P_SET		hp,100
;;;	P_BECOMEMOTHER
;;;	P_IMPORT	slopenum,gbyte1
;;;	P_UNBECOME
;;;	P_RETURN
;;;.m_dead_ck
;;;	P_IFZERO	pbyte2,.live
;;;	P_FORCE		.m_dead
;;;.live
;;;	P_RETURN
;;;.m_dead
;;;	P_TRIGGER	.m_dead_ck,OFF
;;;	P_IFSAME	pbyte1,2,.no_exp
;;;	P_IFSAME	pbyte1,4,.no_exp
;;;	P_TRIGGER	mk_many_damy_exp,4
;;;.no_exp
;;;	P_DO		16
;;;	P_CHASE		childrotx,0
;;;	P_NEXT
;;;.modae
;;;	P_DO		2		;4
;;;	P_DO		10		;10
;;;	P_CHASE		childrotx,ty
;;;	P_CHASE		childrotz,ty
;;;	P_NEXT
;;;	P_NEG		ty
;;;	P_NEXT
;;;
;;;	P_NEG		pbyte1
;;;	P_ADD		pbyte1,10
;;;	P_DO		pbyte1
;;;	P_WAIT		1
;;;	P_NEXT
;;;	P_EXPLODE
;;;;------------
;;;	START_PATH	e_saso_mark
;;;
;;;	P_CLRTYPE	enemy1
;;;.loop
;;;	P_IFFLAG	.rem
;;;	P_GOTO		.loop
;;;.rem
;;;	P_REMOVE
;;;;------------
	START_PATH	e_wakidashi_boyon

	P_GOSUB		wakidashi_init
	P_TRIGGER	wakidashi_dead,WhenHit
	P_SOUND		p2_poyon	;05
	P_WEAPON	ELaser
	P_SET		tx,5
	P_SET		ty,4
	P_TRIGGER	fly_wave,Always
	P_RTRIGGER	.anim_add_12,Always
.lp
	P_WAIT		5
	P_GOSUB		sos_fire_must
	P_WAIT		10
	P_SETRANDOM	pbyte1,7
	P_INDEX		childx,boyon_pos_x,pbyte1
	P_INDEX		childz,boyon_pos_z,pbyte1
	P_IMPORT	pword1,Player1_worldx
	P_ADD		childx,pword1
	P_IMPORT	pword1,Player1_worldz
	P_ADD		childz,pword1

	P_DO		45
	P_CHASE		worldx,childx
	P_CHASE		worldz,childz
	P_NEXT
	P_GOTO		.lp
.anim_add_12
	P_HITSLOPE	wakidashi_dead_no_sc
	P_ADDANIM	1,12
	P_ADD		roty,16
	P_RETURN
;;;;------------
	START_PATH	e_wakidashi_sasori

	P_GOSUB		wakidashi_init
	P_TRIGGER	sasori_sound,8
	P_TRIGGER	wakidashi_dead,WhenHit
	P_WEAPON	ERing
	P_SET		childroty,roty
.next_move
	P_SETVEL	40
	P_WAIT		60
	P_SETVEL	0
.face_again
	P_FACEPLAYER	y
	P_PLAYERINCONE	5,.atack
	P_GOTO		.face_again
.atack
;	P_ADD		worldy,-180
;	P_GOSUB		sos_fire_must
;	P_ADD		worldy,180
	P_SPAWN		0,-180,0,0,0,0,ring_mark,e_ring_mark_child,10,10,11
	
	P_WAIT		20
	P_ADD		childroty,128
.rot_more
	P_CHASE		roty,childroty
	P_IFSAME	roty,childroty,.next_move
	P_GOTO		.rot_more

;;;	START_PATH	e_sasori_target
;;;
;;;	P_TRIGGER	.sasori_t_dead,WhenHit		;Dead
;;;	P_TRIGGER	sasori_sound,8
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_ZERO		worldy
;;;	P_GOSUB		set_child_xz
;;;	P_SET		childrotx,roty
;;;	P_WEAPON	Eplasma1
;;;	P_RANGECHECK	OFF
;;;	P_ALWAYSGENVECS	ON
;;;
;;;	P_SET		childroty,roty
;;;.next_move
;;;	P_SETVEL	40
;;;	P_WAIT		60
;;;	P_SETVEL	0
;;;.face_again
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	5,.atack
;;;	P_GOTO		.face_again
;;;.atack
;;;	P_ADD		worldy,-180
;;;	P_GOSUB		immed_fire
;;;	P_ADD		worldy,180
;;;	P_ZERO		rotx
;;;	P_WAIT		20
;;;	P_ADD		childroty,128
;;;.rot_more
;;;	P_CHASE		roty,childroty
;;;	P_IFSAME	roty,childroty,.next_move
;;;	P_GOTO		.rot_more
;;;
;;;	P_END
;;;.sasori_t_dead
;;;	P_SCORE		sc_sasori_tank
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.sasori_t_dead,OFF
;;;	P_TRIGGER	sasori_sound,OFF
;;;	P_IGOTO		final_enemy_demo
;;;	
;;;;-----------
	START_PATH	e_new_kamakiri

	P_SET		skidy,hp

	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_dead

.wst
	P_FINDSHAPE	chika_k0
	P_SHAPEDEAD	.ag
	P_IGOTO		.start
.ag
	P_GOTO		.wst
.start
	P_SET		hp,100
	P_SET		ap,4
	P_SETBOSSNAME	name_kama
	P_GOSUB		enemy_hp_meter
	P_ENEMYDMGSE	en_cry_3
	P_RADAROBJ	ra_enemy
	P_TRIGGER	radar_change,8
	P_TRIGGER	marker_set,Always
	P_ALWAYSGENVECS	ON
	P_SET		pbyte2,3
	P_SETVEL	30
	P_RTRIGGER	.mini_atack,32
	P_RTRIGGER	.live_ck,WhenHit
	P_RTRIGGER	.live_ck2,WhenHit
.lp
	P_SHAPEDISTLESS	1000,.turn
	P_SHAPEDISTLESS	3000,.ok_dist
	P_IGOTO		.turn
.ok_dist
	P_GOTO		.lp

.mini_atack
	P_IMPORT	pbyte1,eaction1
	P_IFLARGER	pbyte1,pbyte2,.many
	P_QSPAWN	kusha_mini,e_mini_kusha,1,2
	P_GINC		b,eaction1
.many
	P_RETURN
.turn	
	P_TRIGGER	.kama_anim,OFF
	P_RTRIGGER	.kama_anim,Always
	P_TRIGGER	.fast_anim,OFF
	P_SETVEL	-30
	P_WAIT		20
	P_SETVEL	0
	P_SETRANDOM	childroty
	P_DO		30
	P_CHASE		roty,childroty
	P_NEXT
	P_SETVEL	30
	P_GOTO		.lp
.live_ck
	P_INVINCIBLE	ON
	P_TRIGGER	.invinc_off,Timer,5
	P_IFNOTBETWEEN	0,hp,50,.ok_live
	P_FORCE		.dead
.ok_live
	P_RETURN

.invinc_off
	P_INVINCIBLE	OFF
	P_RETURN
.aegu
	P_TRIGGER	.live_ck2,OFF
	P_IFBETWEEN	0,hp,50,.dead
	P_SETVEL	0
	P_PUSH		roty
	P_SET		childrotx,32
	P_RANDOMGOTO	.n
	P_NEG		childrotx
.n
	P_FACESHAPE	IMMEDIATE
	P_ZERO		rotx
	P_SET		childroty,roty
	P_ADD		childroty,childrotx
	P_PULL		roty
	P_TRIGGER	.kama_anim,OFF
	P_TRIGGER	.fast_anim,OFF
	P_SETANIM	0
	P_RTRIGGER	.fast_anim,Always
	P_SET		slopenum,-4
	P_DO		2
	P_DO		8
	P_ADD		rotx,slopenum
	P_CHASE		roty,childroty
	P_NEXT
	P_NEG		slopenum
	P_IMPORT	pbyte1,eaction1
	P_IFLARGER	pbyte1,pbyte2,.many2
	P_QSPAWN	kusha_mini,e_mini_kusha,1,2
	P_GINC		b,eaction1
.many2
	P_NEXT
	P_SETVEL	60
	P_COLLISIONS	ON
	P_RTRIGGER	.live_ck2,WhenHit
	P_GOTO		.lp
.live_ck2	
	P_FORCE		.aegu
	P_RETURN
.fast_anim
	P_ADDANIM	4,16
	P_IGOTO		.ashioto
	P_RETURN
.kama_anim
	P_ADDANIM	1,16
.ashioto
	P_IFSAME	animframe,128,.sound_on
	P_IFSAME	animframe,136,.sound_on
	P_RETURN
.sound_on
	P_SOUNDEFTDISTPOS	bs_kamakiri	;$c9
	P_RETURN
.dead
	P_TRIGGER	.live_ck,OFF
	P_TRIGGER	.live_ck2,OFF
	P_TRIGGER	marker_set,OFF
	P_COLLISIONS	OFF
	P_SCREENFLASH
	P_GOSUB		group_explode
	P_SOUNDEFTPOS	en_death_3	;$4c
	P_SOUNDEFTPOS	bs_BossExplode2	;$b1
	P_CIRCLEWINDOW	1,big
	P_EXPORT	gbyte1,skidy
	P_QSPAWN	on_d,e_sw_base_sw_drop,100,4
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_SCORE		sc_kani
	P_EXPLODE

.already_dead	LOCAL
	P_EXPORT	gbyte1,skidy
	P_QSPAWN	on_d,e_sw_base_switch,100,4
	P_BECOME
	P_IMPORT	roty,gbyte1
	P_ZERO		worldy
	P_UNBECOME
	P_REMOVE
;------------
	START_PATH	e_mini_kusha

	P_RTRIGGER	.mini_k_dead,WhenDead
	P_RTRIGGER	.mini_exp,WhenHit
	P_SOUNDEFTDISTPOS	en_missileshoot_s	;$74
	P_SET		coltab,id_1_c&wm
	P_RADAROBJ	ra_enemy
	P_FACEPLAYER	IMMEDIATE
	P_ZERO		rotx
	P_SETRANDOM	pbyte1,128
	P_ADD		pbyte1,-64
	P_ADD		roty,pbyte1
.dlp
	P_HITGROUND	0,.go
	P_ADD		worldy,50
	P_GOTO		.dlp
.go
	P_SET		worldy,-32
	P_RTRIGGER	.mini_anim,Always
	P_ALWAYSGENVECS	ON
	P_SETVEL	50
	P_WAIT		15
.lp
	P_FACEPLAYER	y
	P_DISTLESS	1000,.j_at
	P_GOTO		.lp
.j_at
	P_IMPORT	pword1,Player1_worldy
	P_ADD		pword1,-100
	P_SET		pbyte1,16
	P_IFARWING	.pass
	P_SET		pword1,-250
	P_SET		pbyte1,8

;	P_DO		8
;	P_FACEPLAYER	y
;	P_CHASE		worldy,pword1
;	P_NEXT
;	P_IGOTO		.sa
.pass
	P_DO		pbyte1
	P_FACEPLAYER	y
	P_CHASE		worldy,pword1
	P_NEXT

	P_SET		pbyte1,5
	P_TRIGGER	.mini_anim,OFF
.cya_lp
	P_HITGROUND	0,.to_lp
	P_ADD		worldy,pbyte1
	P_ADD		pbyte1,10
	P_GOTO		.cya_lp
.to_lp
	P_SET		worldy,-32
	P_RTRIGGER	.mini_anim,Always
	P_WAIT		30
	P_GOTO		.lp
.mini_anim
	P_ADDANIM	2,16
	P_HITSLOPE	.mini_exp
	P_IFSAME	animframe,128,.sound_on
	P_IFSAME	animframe,136,.sound_on
	P_RETURN
.sound_on
	P_SOUNDEFTNEARPOS	en_kamakiri_kids	;$6a*
	P_RETURN	
.mini_exp
	P_FORCE		.exp_on
	P_RETURN
.exp_on
	P_TRIGGER	.mini_anim,OFF
	P_EXPLODE

.mini_k_dead
	P_GDEC		b,eaction1
	P_RETURN
;;;;-----------
	START_PATH	e_new_kani

	P_ENEMYDMGSE	en_cry_3

	P_SET		skidy,hp
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,pe_new_kamakiri.already_dead

	P_TRIGGER	missile_fire,64
	P_RTRIGGER	.kani_laser_fire,32
	P_RTRIGGER	.kani_anim,Always
	P_SET		hp,80
	P_SET		ap,4
	P_SETBOSSNAME	name_kani
	P_GOSUB		enemy_hp_meter
	P_RADAROBJ	ra_enemy
	P_TRIGGER	radar_change,8
	P_TRIGGER	marker_set,Always
	P_GOSUB		.mk_reg
	P_RTRIGGER	.hit,WhenHit
	P_ALWAYSGENVECS	ON
	P_SETVEL	10
	P_SET		childx,worldx
	P_SET		childz,worldz

	P_SET		childy,worldx
	P_SET		oy,worldz

	P_SET		ox,childx
	P_SET		oz,childz
	P_ADD		childx,1500
	P_ADD		childx,1500
	P_ADD		ox,-1500
	P_ADD		oz,-1500
.lp
	P_IFSMALLER	worldx,ox,.out
	P_IFSMALLER	worldz,oz,.out
	P_IFLARGER	worldx,childx,.out
	P_IFLARGER	worldz,childz,.out
	P_INC		pbyte2
	P_IFSAME	pbyte2,120,.out
	P_FACEPLAYER	y
	P_GOTO		.lp
;-----------
.kani_laser_fire
	P_PLAYERINCONE	32,.fire
	P_RETURN
.fire
	P_DISTMORE	2000,.no
	P_SPAWN		0,0,200,0,0,0,nullshape,e_kani_shooter,100,0,5
.no
	P_RETURN
.kani_anim
	P_ADDANIM	1,12
	P_BECOMECHILD	4
	P_IFSAME	animframe,-128,.oto
	P_IFSAME	animframe,-120,.oto
	P_IGOTO		.oto_nashi
.oto
	P_SOUNDEFTDISTPOS	en_meteor_kani	;$86*
.oto_nashi
	P_UNBECOME
	P_RETURN
;-----------
.out
	P_SETVEL	0
	P_DO		64
	P_FACEPLAYER	y
	P_NEXT

	P_QSPAWN	marker,e_kani_backer,100,0
	P_EXPORT	gword1,childy
	P_EXPORT	gword2,oy
	P_BECOME
	P_FINDSHAPE	kani_0
	P_GOSUB		impo_xz_world
;	P_IMPORT	worldx,gword1
;	P_IMPORT	worldz,gword2
	P_FACESHAPE	IMMEDIATE
	P_EXPORT	gbyte1,roty
	P_UNBECOME
	P_IMPORT	childroty,gbyte1
	P_ADD		childroty,128

	P_DO		16
	P_CHASE		roty,childroty
	P_NEXT
	P_SETVEL	10
	P_DO		80
	P_CHASE		roty,childroty
	P_NEXT
	P_ZERO		pbyte2
	P_GOTO		.lp

.hit
	P_IFNOTBETWEEN	-1,hp,50,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.hit,OFF
	P_TRIGGER	marker_set,OFF
	P_COLLISIONS	OFF
	P_SCREENFLASH
	P_GOSUB		group_explode
	P_SOUNDEFTPOS	en_death_3	;$4c
	P_SOUNDEFTPOS	bs_BossExplode2	;$b1
	P_CIRCLEWINDOW	1,big
	P_GOSUB		c_flag_1234
;	P_FLAGCHILD	1
;	P_FLAGCHILD	2
;	P_FLAGCHILD	3
;	P_FLAGCHILD	4
	P_GOSUB		c_unlink_1234
;	P_UNLINKCHILD	1		
;	P_UNLINKCHILD	2
;	P_UNLINKCHILD	3
;	P_UNLINKCHILD	4
	P_EXPORT	gbyte1,skidy
	P_QSPAWN	on_d,e_sw_base_sw_drop,100,4
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_SCORE		sc_kani
	P_EXPLODE
.mk_reg
	P_SPAWN		-120,0,-40,0,10,0,kani_2,e_kani_l,100,4,1
	P_BECOME
	P_SETANIM	0
	P_UNBECOME
	P_SPAWN		-140,0,80,0,-15,0,kani_2,e_kani_l,100,4,2
	P_BECOME
	P_SETANIM	8
	P_UNBECOME
	P_SPAWN		120,0,-40,0,-10,0,kani_1,e_kani_r,100,4,3
	P_BECOME
	P_SETANIM	8
	P_UNBECOME
	P_SPAWN		140,0,80,0,15,0,kani_1,e_kani_r,100,4,4
	P_BECOME
	P_SETANIM	0
	P_UNBECOME
	P_RETURN
;----------
	START_PATH	e_kani_shooter

	P_INVISIBLE	ON
	P_WEAPON	ELaser
	P_DO		3
	P_FACEPLAYER	IMMEDIATE
	P_SETRANDOM	pbyte1,15
	P_ADD		pbyte1,-7
	P_ADD		roty,pbyte1
	P_SETRANDOM	pbyte1,15
	P_ADD		pbyte1,-7
	P_ADD		rotx,pbyte1
	P_ADJUSTROT
	P_FIRE
	P_WAIT		5
	P_NEXT
	P_REMOVE

	START_PATH	e_kani_backer

	P_INVISIBLE	ON
	P_REMOVE
;----------
	START_PATH	e_kani_l

	P_INC		pbyte1

	START_PATH	e_kani_r

	P_SHADOW	ON
	P_CLIPPING	ON
	P_INVINCIBLE	ON
	P_COLLISIONS	OFF
	P_ACTIVE	ON
.kani_c_loop
	P_IFFLAG	.head_dead
	P_ADDANIM	1,16
	P_GOTO		.kani_c_loop
.head_dead
	P_DO		2
	P_DIV2		childx
	P_DIV2		childz
	P_INEXT
;	P_DIV2		childx
;	P_DIV2		childz
;	P_DIV2		childx
;	P_DIV2		childz
	P_SET		vx,childx
	P_SET		vz,childz
	P_ZERO		pbyte1
	P_DO		20
	P_AUTOINDEX	b,worldy,jumptab,pbyte1,20
	P_ADD		rotx,childroty
	P_NEXT
	P_EXPLODE




;;;	START_PATH	e_kani_0
;;;kani_hp equ 60
;;;	P_SOUND		p2_kani_0
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_CLIPPING	ON
;;;	P_SET		mx,3
;;;	P_SET		slopenum,kani_hp
;;;	P_SET		childx,worldx
;;;	P_ADD		childx,kani_max_x	;childx = max x
;;;	P_SET		childy,worldx
;;;	P_ADD		childy,kani_min_x	;childy = min x
;;;	P_SET		childz,worldz
;;;	P_ADD		childz,kani_max_z	;childz = max z
;;;	P_SET		pword1,worldz
;;;	P_ADD		pword1,kani_min_z	;pword1 = min z
;;;	P_WEAPON	RelEPlasma1
;;;	P_TRIGGER	.kani_hit,WhenHit
;;;	P_GOSUB		.mk_reg_1
;;;	P_SETRANDOM	roty
;;;.atack_again
;;;	P_TRIGGER	.kani_atack_ck,64
;;;.kani_han_loop
;;;	P_IFSMALLER	worldx,childy,.out
;;;	P_IFLARGER	worldx,childx,.out
;;;	P_IFSMALLER	worldz,pword1,.out
;;;	P_IFLARGER	worldz,childz,.out
;;;	P_SET		ox,worldx
;;;	P_SET		oz,worldz
;;;	P_SETVEL	15
;;;	P_GOTO		.kani_han_loop
;;;;-------------
;;;.out
;;;	P_SET		worldx,ox
;;;	P_SET		worldz,oz
;;;	P_TRIGGER	.kani_atack_ck,OFF
;;;	P_SETVEL	0
;;;	P_GOSUB		.turn_more
;;;	P_IGOTO		.atack_again
;;;;------------
;;;.turn_more
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	5,.run_again
;;;	P_GOTO		.turn_more
;;;.run_again
;;;	P_RETURN
;;;;------------
;;;.kani_atack_ck
;;;	P_FORCE		.kusha_at_on
;;;	P_RETURN
;;;.kusha_at_on
;;;	P_TRIGGER	.kani_atack_ck,OFF
;;;	P_SETVEL	0
;;;	P_DO		3
;;;	P_GOSUB		.turn_more
;;;	P_ADD		worldy,-200
;;;;;;	P_GOSUB		immed_fire
;;;	P_GOSUB		sos_fire_must
;;;	P_ZERO		rotx
;;;	P_ADD		worldy,200
;;;	P_WAIT		10
;;;	P_NEXT
;;;	P_GOTO		.atack_again
;;;;;;;-----------
;;;.kani_hit
;;;	P_IFLARGER	hp,slopenum,.kani_ok
;;;	P_DEC		mx
;;;	P_SET		hp,100
;;;	P_IFNOTZERO	mx,.kani_ok
;;;	P_FORCE		.kani_down
;;;.kani_ok
;;;	P_RETURN
;;;.kani_down
;;;	P_TRIGGER	.kani_atack_ck,OFF
;;;	P_TRIGGER	.kani_hit,OFF
;;;
;;;	P_SCREENFLASH
;;;	P_CLRDEMOSHAPE
;;;
;;;	P_RADAROBJ	ra_off
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCORE		sc_kani
;;;
;;;	P_CLEARSTACK
;;;	P_INVINCIBLE	ON
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,32
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_IMPORT	pword1,Player1_worldx
;;;	P_CHASE		worldx,pword1
;;;	P_CHASE		worldx,pword1
;;;	P_IMPORT	pword1,Player1_worldy
;;;	P_CHASE		worldy,pword1
;;;	P_CHASE		worldy,pword1
;;;	P_IMPORT	pword1,Player1_worldz
;;;	P_CHASE		worldz,pword1
;;;	P_CHASE		worldz,pword1
;;;	P_UNBECOME
;;;	P_SETVEL	0
;;;	P_FLAGCHILD	1
;;;	P_FLAGCHILD	2
;;;	P_FLAGCHILD	3
;;;	P_FLAGCHILD	4
;;;	P_EXPORT	gword1,worldx
;;;	P_EXPORT	gword2,worldz
;;;
;;;	P_TRIGGER	kani_explode,4
;;;
;;;	IFEQ		e_boss_demo_cut
;;;
;;;	P_QSPAWN	demo_target,e_r_demo_target,100,0
;;;	P_BECOME
;;;	P_COLLISIONS	OFF
;;;	P_INVINCIBLE	ON
;;;	P_IMPORT	worldx,gword1
;;;	P_IMPORT	worldz,gword2
;;;	P_SET		worldy,-350
;;;	P_UNBECOME
;;;	P_GOSUB		make_demo_kani
;;;	P_BECOME
;;;	P_SET		tx,60			;33
;;;	P_SET		pword1,-400
;;;	P_SET		slopenum,de_for_kani
;;;	P_UNBECOME
;;;
;;;	P_GOSUB		demo_move_wait
;;;
;;;	ENDC
;;;
;;;	P_DO		15
;;;	P_RANDOMGOTO	.fl_pass
;;;	P_HITFLASHTRIG
;;;.fl_pass
;;;	P_NEXT
;;;
;;;	P_DO		5
;;;	P_INDEX		pbyte2,kani_d_tab0,childrotz
;;;	P_INDEX		pbyte1,kani_d_tab1,childrotz
;;;	P_INDEX		ty,kani_d_tab2,childrotz
;;;	P_INDEX		ap,kani_d_tab3,childrotz
;;;	P_GOSUB		.kani_down_sub
;;;	P_IFBETWEEN	-32767,worldy,-25,.pass_sound
;;;	P_SOUNDEFFECT	ob_bound_on_magma	;$aa
;;;.pass_sound		
;;;	P_INC		childrotz
;;;	P_NEXT
;;;
;;;	P_SOUND		port2_stop
;;;
;;;	P_CIRCLEWINDOW	1,big
;;;	P_EXPLODE
;;;
;;;;-----------
;;;.kani_down_sub
;;;	P_DO		pbyte1
;;;
;;;	P_ADD		pbyte2,ty
;;;	P_ADD		worldy,pbyte2
;;;	P_ZERO		tx
;;;	P_EXPORT	gbyte1,ap
;;;	P_DO		2
;;;	P_INC		tx
;;;	P_BECOMECHILD	tx
;;;	P_GADD		childrotz,gbyte1
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_NEG		ap
;;;	P_EXPORT	gbyte1,ap
;;;	P_DO		2
;;;	P_INC		tx
;;;	P_BECOMECHILD	tx
;;;	P_GADD		childrotz,gbyte1
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_NEG		ap
;;;
;;;	P_NEXT
;;;
;;;	P_RETURN
;;;.mk_reg_1	LOCAL
;;;	P_SPAWN		-240,0,-80,0,10,0,kani_2,e_kani_l,100,4,1
;;;	P_BECOME
;;;	P_SETANIM	0
;;;	P_UNBECOME
;;;	P_SPAWN		-280,0,160,0,-15,0,kani_2,e_kani_l,100,4,2
;;;	P_BECOME
;;;	P_SETANIM	8
;;;	P_UNBECOME
;;;	P_SPAWN		240,0,-80,0,-10,0,kani_1,e_kani_r,100,4,3
;;;	P_BECOME
;;;	P_SETANIM	8
;;;	P_UNBECOME
;;;	P_SPAWN		280,0,160,0,15,0,kani_1,e_kani_r,100,4,4
;;;	P_BECOME
;;;	P_SETANIM	0
;;;	P_UNBECOME
;;;	P_RETURN
;;;
;;;kani_d_tab0
;;;	db	0,-80,0,50,-12
;;;kani_d_tab1
;;;	db	16,5,5,1,4
;;;kani_d_tab2
;;;	db	5,16,10,0,0
;;;kani_d_tab3
;;;	db	-3,3,-3,-3,1
;;;;--------
;;;	START_PATH	e_kani_l
;;;
;;;	P_INC		pbyte1
;;;
;;;	START_PATH	e_kani_r
;;;
;;;	P_SHADOW	ON
;;;	P_CLIPPING	ON
;;;	P_INVINCIBLE	ON
;;;	P_COLLISIONS	OFF
;;;	P_ACTIVE	ON
;;;	P_IFZERO	slopenum,.kani_c_loop
;;;	P_SHADOW	OFF
;;;	P_CLIPPING	OFF
;;;.kani_c_loop
;;;	P_IFFLAG	.head_dead
;;;	P_ADDANIM	1,16
;;;	P_IFNOTZERO	slopenum,.for_explain
;;;	P_IFSAME	animframe,-128,.mk_sp_o
;;;	P_IFSAME	animframe,-120,.mk_sp_i
;;;.for_explain
;;;	P_GOTO		.kani_c_loop
;;;.head_dead
;;;	P_SETANIM	0
;;;	P_END
;;;
;;;.mk_sp_o
;;;	P_IFZERO	pbyte1,.r_o
;;;	P_SPAWN		-30,0,-14,0,0,0,msplash,e_kani_splash,10,0
;;;	P_IGOTO		.kani_cp
;;;.r_o
;;;	P_SPAWN		30,0,-14,0,0,0,msplash,e_kani_splash,10,0
;;;.kani_cp
;;;	P_BECOME
;;;	P_GOSUB		set_child_xz
;;;	P_UNBECOME
;;;	P_GOTO		.kani_c_loop
;;;
;;;
;;;.mk_sp_i
;;;	P_IFZERO	pbyte1,.r_i
;;;	P_SPAWN		-60,0,33,0,0,0,msplash,e_kani_splash_in,10,0
;;;	P_IGOTO		.kani_mp
;;;.r_i
;;;	P_SPAWN		60,0,33,0,0,0,msplash,e_kani_splash_in,10,0
;;;.kani_mp
;;;	P_EXPORT	gword1,worldx
;;;	P_EXPORT	gword2,worldz
;;;	P_BECOME
;;;	P_IMPORT	childx,gword1
;;;	P_IMPORT	childz,gword2
;;;	P_UNBECOME
;;;	P_GOTO		.kani_c_loop
;;;	
;;;;-------------
;;;
;;;	START_PATH	e_kani_splash_in
;;;
;;;	P_SOUNDEFTDISTPOS	en_magma_kani	;$86
;;;
;;;	START_PATH	e_kani_splash
;;;
;;;	P_ACTIVE	ON
;;;	P_CLRTYPE	enemy1
;;;	P_IFZERO	ap,.kazan_size
;;;	P_SPRITE	0,32
;;;	P_IGOTO		.same
;;;.kazan_size
;;;	P_SPRITE	0,64
;;;.same
;;;	P_RANGECHECK	OFF
;;;	P_ZERO		worldy
;;;	P_COLLISIONS	OFF
;;;	P_SETCOLANIM	0
;;;	P_DO		3
;;;	P_ADDCOLANIM	1,4
;;;	P_IFZERO	ap,.stay
;;;	P_CHASE		worldx,childx
;;;	P_CHASE		worldz,childz
;;;.stay
;;;	P_NEXT
;;;	P_REMOVE
;;;;------------
;;;	START_PATH	e_kani_dead_ashi
;;;
;;;	P_SETANIM	0
;;;	P_CLIPPING	ON
;;;	P_IGOTO		pe_nocolobj.st
;;;
;;;;----------------- KAMAKIRI KUSHA
;;;	START_PATH	e_kusha_b
;;;kusha_hp = 80
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_SET		slopenum,kusha_hp
;;;	
;;;	P_SET		childx,worldx
;;;	P_ADD		childx,1024		;childx = max x
;;;	P_SET		childy,worldx
;;;	P_ADD		childy,-1024		;childy = min x
;;;	P_SET		childz,worldz
;;;	P_ADD		childz,1024		;childz = max z
;;;	P_SET		pword1,worldz
;;;	P_ADD		pword1,-1024		;pword1 = min z
;;;	P_WEAPON	RelEplasma1
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_ZERO		rotx
;;;	P_SETANIM	0
;;;	P_TRIGGER	.ck_collision,Always
;;;	P_TRIGGER	.kusha_down_ck,WhenHit
;;;.atack_again
;;;	P_TRIGGER	.kusha_atack,64
;;;.kusha_move
;;;	P_IFSMALLER	worldx,childy,.out_min_x
;;;	P_IFLARGER	worldx,childx,.out_max_x
;;;	P_IFSMALLER	worldz,pword1,.out_min_z
;;;	P_IFLARGER	worldz,childz,.out_max_z
;;;	P_IFNOTZERO	ox,.vel_0
;;;	P_SETVEL	30
;;;.vel_0
;;;	P_GOTO		.kusha_move
;;;.out_min_x
;;;	P_SET		childroty,-64-16
;;;	P_SET		worldx,childy
;;;	P_IGOTO		.turn
;;;.out_max_x
;;;	P_SET		childroty,64-16
;;;	P_SET		worldx,childx
;;;	P_IGOTO		.turn
;;;.out_min_z
;;;	P_SET		childroty,0-16
;;;	P_SET		worldz,pword1
;;;	P_IGOTO		.turn
;;;.out_max_z
;;;	P_SET		childroty,128-16
;;;	P_SET		worldz,childz
;;;.turn
;;;	P_TRIGGER	.kusha_atack,OFF
;;;	P_SETVEL	0
;;;	P_GOSUB		.turn_more
;;;	P_IGOTO		.atack_again
;;;;------------
;;;.kusha_atack
;;;	P_FORCE		.kusha_at_on
;;;	P_RETURN
;;;.kusha_at_on
;;;	P_TRIGGER	.kusha_atack,OFF
;;;	P_SETVEL	0
;;;	P_GOSUB		.turn_more
;;;	P_ADD		worldy,-200
;;;	P_GOSUB		immed_fire
;;;	P_ZERO		rotx
;;;	P_ADD		worldy,200
;;;	P_GOTO		.atack_again
;;;.ck_collision
;;;	P_ADDANIM	1,16
;;;	P_IFSAME	animframe,128,.sound_on
;;;	P_IFSAME	animframe,136,.sound_on
;;;.back_s
;;;	P_IFZERO	ox,.coll_on
;;;	P_INC		ty
;;;	P_PUSH		tx
;;;	P_SET		tx,2
;;;	P_IFSWITCH	tx,ty,.sound_on2
;;;.back_s2
;;;	P_PULL		tx
;;;	P_IFNOTSAME	ty,8,.not_neg
;;;	P_NEG		tx
;;;.not_neg
;;;	P_ADD		rotx,tx
;;;	P_ADDANIM	2,16
;;;	P_DEC		ox
;;;	P_RETURN
;;;.coll_on
;;;	P_ZERO		rotx
;;;	P_COLLISIONS	ON
;;;	P_RETURN
;;;.sound_on
;;;	P_SOUNDEFTDISTPOS	en_kamakiri	;$69*
;;;	P_IGOTO		.back_s
;;;.sound_on2
;;;	P_SOUNDEFTDISTPOS	en_kamakiri	;$69*
;;;	P_IGOTO		.back_s2
;;;.kusha_down_ck
;;;	P_SET		ox,15
;;;	P_SET		tx,-4
;;;	P_ZERO		ty
;;;	P_SETVEL	0
;;;	P_COLLISIONS	OFF
;;;	P_IFLARGER	hp,slopenum,.live
;;;	P_FORCE		.kusha_down_on
;;;.live
;;;	P_RETURN
;;;
;;;.kusha_down_on
;;;	P_SCREENFLASH
;;;	P_CLRDEMOSHAPE
;;;	P_SCORE		sc_kusha_b
;;;	P_GDEC		b,KEnemyNumber
;;;
;;;	P_TRIGGER	.kusha_atack,OFF
;;;	P_TRIGGER	.kusha_down_ck,OFF
;;;
;;;	P_COLLISIONS	OFF
;;;	P_SETVEL	0
;;;
;;;	P_TRIGGER	.b_kusha_explode,4
;;;
;;;	IFEQ		e_boss_demo_cut
;;;
;;;	P_GOSUB		make_demo_target
;;;	P_BECOME
;;;	P_SET		tx,25
;;;	P_SET		slopenum,de_for_kusha
;;;	P_UNBECOME
;;;	P_GOSUB		demo_move_wait
;;;
;;;	ENDC
;;;
;;;	P_DO		45
;;;	P_ADDANIM	3,16
;;;	P_NEXT
;;;
;;;	P_GOSUB		many_exp_group
;;;
;;;	P_CIRCLEWINDOW	1,big		;10
;;;	P_EXPLODE
;;;
;;;.b_kusha_explode
;;;	P_SPAWN		0,-30,50,0,0,0,explosion5,e_sp_bigrandom_explosion,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_QSPAWN	explosion5,e_sp_bigrandom_explosion,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_SPAWN		0,30,-50,0,0,0,explosion5,e_sp_bigrandom_explosion,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_RETURN
;;;;------------
;;;.turn_more
;;;	P_IFZERO	childroty,.to_player
;;;	P_SETRANDOM	pbyte1,31
;;;	P_ADD		childroty,pbyte1
;;;.turn_chily
;;;	P_CHASE		roty,childroty
;;;	P_IFSAME	roty,childroty,.run_again
;;;	P_GOTO		.turn_chily
;;;.to_player
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	5,.run_again
;;;	P_GOTO		.to_player
;;;.run_again
;;;	P_ZERO		childroty
;;;	P_RETURN
;;;
;;;;ษอออออออออออออออป
;;;;บ PLAYER'S ITEM บ
;;;;ศอออออออออออออออผ
	START_PATH	e_panel_arrow

	P_SET		hp,100
	P_COLLISIONS	OFF
	P_SETANIM	0
.loop
	P_FACEVIEW	IMMEDIATE
	P_ADJUSTROT
	P_ADDANIM	1,6
	P_GOTO		.loop
;;;;-----------
	START_PATH	e_panel_flamethrower

.other_start	LOCAL
	P_SETCOLANIM	10
	P_SET		pbyte1,3
	P_IGOTO		pe_panel_smartplasma.start
;;;;-----------
	START_PATH	e_panel_twinblaster

	P_IFPLRWEAPLEVEL	3,.others

	P_SETCOLANIM	8
	P_SET		pbyte1,4
	P_IGOTO		pe_panel_smartplasma.start
.others
	P_SETRANDOM	pbyte1,3
	P_IFSAME	pbyte1,1,pe_panel_flamethrower.other_start
;;;	P_IFSAME	pbyte1,2,pe_panel_dummyplayer.other_start
	P_IFSAME	pbyte1,3,pe_panel_shieldplayer.other_start
	P_ZERO		pbyte1
	P_IGOTO		pe_panel_smartplasma.other_start
;-----------
	START_PATH	e_panel_dummyplayer

.other_start	LOCAL
	P_SETCOLANIM	6
	P_SET		pbyte1,2
	P_IGOTO		pe_panel_smartplasma.start
;-----------
	START_PATH	e_panel_shieldplayer

.other_start	LOCAL
	P_SETCOLANIM	4
	P_SET		pbyte1,1
	P_IGOTO		pe_panel_smartplasma.start
;;;;-----------
;;;	START_PATH	e_panel_1up
;;;
;;;	P_SETCOLANIM	2
;;;	P_SET		pbyte1,5
;;;	P_IGOTO		pe_panel_smartplasma.start
;;;;-----------
	START_PATH	e_panel_smartplasma

.other_start	LOCAL
	P_SETCOLANIM	0

.start	LOCAL
;	P_IMPORT	pbyte2,KDifficulty	;currentlevel
;	P_IFNOTSAME	pbyte2,dif_easy,.not_st_0
;	P_SPAWN		0,-80,0,0,0,0,arrow_0,e_panel_arrow,100,0,1
;.not_st_0
	P_ZERO		pbyte2
	P_INC		slopenum
	P_IFZERO	roty,.mugen
	P_SET		childrotz,roty
	P_IMPORT	pword1,eword1
	P_IFSWITCH	roty,pword1,.item_rem

	P_IMPORT	pbyte2,KDifficulty	;currentlevel
	P_IFNOTSAME	pbyte2,dif_easy,.mugen
	P_SPAWN		0,-80,0,0,0,0,arrow_0,e_panel_arrow,100,0,1
.mugen
	P_ZERO		roty
	P_RADAROBJ	ra_sonota
	P_GOSUB		init_hardslope_soff
	P_INC		childroty
	P_CLIPPING	ON
	P_MOVEPLAYER	ON
	P_TRIGGER	.item_panel_step,WhenSteppedOn
	P_TRIGGER	.item_anim,Always
	P_TRIGGER	.item_getted,WhenFlagged
	P_END
;------------
.item_getted
	P_FORCE		.end_panel
	P_RETURN
.end_panel
	P_TRIGGER	.item_panel_step,OFF
	P_TRIGGER	.item_anim,OFF
	P_TRIGGER	.item_getted,OFF
.item_rem
	P_STAMPSTART

	P_GOSUB		init_hardslope_soff
	P_SET		shape,itembox1
	P_RADAROBJ	ra_off
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFSAME	pbyte1,2,.magma
	P_SET		worldy,-200
	P_END
.magma
	P_SET		worldy,-230
	P_END
;------------
.item_anim
	P_ADD		colframe,childroty
	P_NEG		childroty
	P_IFNOTSAME	pbyte2,childrotx,.cont
	P_ZERO		pbyte2
.cont
	P_SET		childrotx,pbyte2
	P_RETURN
;------------
.item_panel_step
	P_FORCE		.item_panel_on
	P_RETURN
.item_panel_on
	P_TRIGGER	.item_panel_step,OFF
	P_REMOVE	1
	P_CLIPPING	ON
	P_SET		shape,itembox1
	P_EXPORT	gbyte1,pbyte1
	P_EXPORT	gbyte2,childrotz
	P_SPAWN		0,110,0,0,0,0,item_ita,e_item_sprite,100,0,1
	P_BECOME
	P_ACTIVE	ON
	P_IMPORT	pbyte1,gbyte1
	P_IMPORT	ap,gbyte2
	P_UNBECOME

	P_RADAROBJ	ra_off
	P_QSPAWN	nullshape,e_item_demo,100,0

	P_ACTIVE	ON
	P_SOUNDEFFECT	ob_item_box_up	;$95
	P_DO		20
	P_ADD		worldy,-10
	P_NEXT

	P_FLAGCHILD	1

	P_SCORE		sc_found_item
	P_WAIT		2
	P_SOUNDEFFECT	leveltrig_stop

	P_END

;;;;------------
;;;
	START_PATH	e_item_demo

	P_COLLISIONS	OFF

	P_FACEPLAYER	IMMEDIATE

	P_IMPORT	worldy,Player1_worldy
	P_ADD		worldy,-60
	P_INDEX		pbyte1,sintab,roty
	P_INDEX		pbyte2,costab,roty
	P_NEG		pbyte1

	P_DO		2
	P_DIV2		pbyte1
	P_DIV2		pbyte2
	P_INEXT

.loop
	P_DISTMORE	300,.pos_ok
	P_ADD		worldx,pbyte1
	P_ADD		worldz,pbyte2
	P_IGOTO		.loop
.pos_ok
	P_FACEPLAYER	IMMEDIATE
	P_PLAYERDEAD	.pass_demo
	P_BEGINDEMO
;	P_SETCAMERA	IMMEDIATE

	P_FINDSHAPE	item_ita
	P_EXPORT	gbyte1,roty
	P_BECOMESHAPE
	P_IMPORT	childroty,gbyte1
	P_ADD		childroty,128
	P_UNBECOME
	P_DO		28
	P_SETCAMERA
	P_SETCAMERA
	P_NEXT

	P_ENDDEMO
.pass_demo
	P_FLAGSHAPE

	P_REMOVE
;;;;;;;------------------ ITEM SW INIT FOR BATTLE
;;;	START_PATH	e_bat_sw_init
;;;
;;;	P_EXPORT	ebyte1,pbyte1
;;;	P_EXPORT	ebyte2,pbyte1
;;;	P_EXPORT	ebyte3,pbyte1
;;;	P_EXPORT	ebyte4,pbyte1
;;;	P_EXPORT	ebyte5,pbyte1
;;;	P_EXPORT	ebyte6,pbyte1
;;;	P_EXPORT	ebyte7,pbyte1
;;;	P_EXPORT	ebyte8,pbyte1
;;;	P_EXPORT	eword1,pword1
;;;	P_EXPORT	eword2,pword1
;;;	P_EXPORT	eword3,pword1
;;;
;;;	P_REMOVE
;;;;------------------ BATTLE TEST
;;;	START_PATH	e_bat_test
;;;
;;;	P_INVISIBLE	ON
;;;.lp
;;;	P_IMPORT	pword1,eword1
;;;	P_PRINT		pword1,b,eguchi
;;;	P_GOTO		.lp
;;;;;;;------------------ ITEM FOR BATTLE
;;;	START_PATH	e_item_hp_bat
;;;	P_SET		pbyte1,2
;;;	START_PATH	e_item_twin_bat
;;;	P_INC		pbyte1
;;;	START_PATH	e_item_heal_bat
;;;	P_INC		pbyte1
;;;	START_PATH	e_item_dummy_bat
;;;	P_INC		pbyte1
;;;	START_PATH	e_item_shield_bat
;;;	P_INC		pbyte1
;;;	START_PATH	e_item_smart_bat
;;;
;;;	P_IFZERO	roty,.not_inert	
;;;	P_SET		ap,roty
;;;.not_inert
;;;	P_IMPORT	pword1,eword1
;;;	P_IFSWITCH	ap,pword1,.rem
;;;.mugen
;;;	P_SPRITE	0,24
;;;	P_RANGECHECK	OFF
;;;	P_COLLISIONS	OFF
;;;	P_SET		hp,100
;;;	P_RADAROBJ	ra_sonota
;;;
;;;	P_IFSAME	pbyte1,6,.for_hp
;;;	P_IFSAME	pbyte1,4,.for_twin
;;;	P_IFSAME	pbyte1,3,.for_heal
;;;	P_IFSAME	pbyte1,2,.for_dummy
;;;	P_IFSAME	pbyte1,1,.for_shield
;;;;for_smart
;;;	P_SETSPWEAP	smartplasma
;;;	P_SET		shape,kakusan
;;;	P_IGOTO		.same
;;;.for_shield
;;;	P_SETSPWEAP	shield
;;;	P_SET		shape,shield
;;;	P_IGOTO		.same
;;;.for_dummy
;;;	P_SETSPWEAP	dummy
;;;	P_SET		shape,dummy
;;;	P_IGOTO		.same
;;;.for_heal
;;;	P_SETSPWEAP	heal
;;;	P_SET		shape,hadou
;;;	P_IGOTO		.same
;;;.for_twin
;;;	P_SET		shape,twin
;;;	P_IGOTO		.same
;;;.for_hp
;;;	P_SET		shape,item_00
;;;.same
;;;	P_PLAYER	1
;;;	P_SET		skidy,1
;;;	P_WITHINRADIUS	150,.catch_on
;;;	P_PLAYER	2
;;;	P_SET		skidy,2
;;;	P_WITHINRADIUS	150,.catch_on
;;;	P_GOTO		.same
;;;.catch_on
;;;	P_IMPORT	pword1,eword1
;;;	P_SETSWITCH	ap,pword1
;;;	P_EXPORT	eword1,pword1
;;;	P_IFSAME	pbyte1,4,.bat_twin_get
;;;	P_IFSAME	pbyte1,6,.bat_hp_get
;;;	P_INCSPWEAP	1,.bat_hp_get
;;;	P_SCORE		sc_item_get
;;;	P_SOUNDEFFECT	special_weapon	;$45
;;;.rem
;;;	P_REMOVE
;;;.bat_twin_get
;;;	P_IFPLRWEAPLEVEL	3,.bat_hp_get
;;;	P_SOUNDEFFECT	twin_blaster	;$43
;;;	P_PLRWEAPLEVELUP
;;;	P_REMOVE
;;;.bat_hp_get
;;;	P_SOUNDEFFECT	CatchHeart	;$32
;;;	P_SET		pbyte1,4
;;;	P_IFSAME	skidy,2,.p2hp
;;;	P_GADD		Player1_hpadd,pbyte1
;;;	P_REMOVE
;;;.p2hp
;;;	P_GADD		Player2_hpadd,pbyte1
;;;	P_REMOVE
;;;;------------------ ITEM SPRITE
	START_PATH	e_item_hp
.other_start	LOCAL
	P_INC		pbyte1
	START_PATH	e_item_twinblaster
	P_INC		pbyte1
	START_PATH	e_item_flamethrower
.other_start	LOCAL
	P_INC		pbyte1
	START_PATH	e_item_dummyplayer
.other_start	LOCAL
	P_INC		pbyte1
	START_PATH	e_item_shieldplayer
.other_start	LOCAL
	P_INC		pbyte1
	START_PATH	e_item_smartplasma
.other_start	LOCAL
	P_IFNOTSAME	pbyte1,4,.not_twin
	P_IFPLRWEAPLEVEL	3,.other_item
.not_twin
	P_GOSUB		sea_map_ck
	P_SET		ap,roty
	P_ZERO		rotx
	P_ZERO		roty
	P_ZERO		rotz
	P_IFZERO	ap,pe_item_sprite.start
	P_IMPORT	pword1,eword1
	P_IFSWITCH	ap,pword1,.item_rem
	P_IGOTO		pe_item_sprite.start
.other_item
	P_ZERO		pbyte1
	P_SETRANDOM	pbyte2,7
	P_IFSAME	pbyte2,1,pe_item_smartplasma.other_start
	P_IFSAME	pbyte2,2,pe_item_shieldplayer.other_start
;	P_IFSAME	pbyte2,3,pe_item_dummyplayer.other_start
	P_IFSAME	pbyte2,4,pe_item_flamethrower.other_start
	P_IGOTO		pe_item_hp.other_start
.item_rem
	P_INVISIBLE	ON
	P_REMOVE
;-----------
	START_PATH	e_item_sprite

	P_INC		slopenum
.start	LOCAL
	P_CLRTYPE	enemy1
	P_IFNOTZERO	hp,.not_inert
	P_SET		hp,100
.not_inert	LOCAL
	P_SHADOW	OFF
	P_RADAROBJ	ra_sonota
	P_IFZERO	pbyte1,.for_smartplasma
	P_IFSAME	pbyte1,1,.for_shield
;;;	P_IFSAME	pbyte1,2,.for_dummy
	P_IFSAME	pbyte1,3,.for_flamethrower
	P_IFSAME	pbyte1,4,.for_twinblaster
;;;	P_IFSAME	pbyte1,5,.for_1up
;;;for_hp
	P_SETCOLANIM	12
	P_IGOTO		.same
;;;.for_1up
;;;	P_SETCOLANIM	2
;;;	P_IGOTO		.same
.for_twinblaster
	P_SETCOLANIM	8
	P_IGOTO		.same
.for_flamethrower
	P_SETSPWEAP	HEAL	;flamethrower
	P_SETCOLANIM	10
	P_IGOTO		.same
;;;.for_dummy
;;;	P_SETSPWEAP	dummy
;;;	P_SETCOLANIM	6
;;;	P_IGOTO		.same
.for_shield
	P_SETSPWEAP	shield
	P_SETCOLANIM	4
	P_IGOTO		.same
.for_smartplasma
	P_SETSPWEAP	smartplasma
	P_SETCOLANIM	0
.same
	P_IFZERO	slopenum,.pass
	P_CLIPPING	ON
	P_IMPORT	skidy,KGameMapPtr
	P_IFNOTSAME	skidy,5,.pass
	P_CLIPPING	OFF
	P_GOSUB		sea_init_below
.pass
	P_COLLISIONS	OFF
	P_SET		pword1,1
	P_TRIGGER	item_col_anim,Always
	P_IFZERO	slopenum,.catch_loop
.waitdemo_loop
	P_IFFLAG	.catch_loop
	P_GOTO		.waitdemo_loop

.catch_loop
	P_IMPORT	weapontype,planet_mode
	P_IFNOTSAME	weapontype,pm_space,.ns
	P_SET		shape,item_itabig
.ns
	P_RTRIGGER	.catch_ck,Always
	P_IFNOTSAME	hp,100,.auto_rem
	P_END
.auto_rem
	P_DO		hp
	P_WAIT		30
	P_NEXT
	P_DO		hp
	P_INVISIBLE	ON
	P_WAIT		1
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_NEXT
	P_REMOVE
.catch_ck
	P_IFNOTZERO	slopenum,.pane
	P_IFNOTSAME	weapontype,pm_space,.ns2
	P_WITHINRADIUS	500,.catch_on
	P_RETURN
.ns2
	P_WITHINRADIUS	150,.catch_on
	P_RETURN
.pane
	P_WITHINRADIUS	70,.catch_on
	P_RETURN
.catch_on
	P_FORCE		.catch
	P_RETURN
.catch
	P_TRIGGER	.catch_ck,OFF
	P_WAIT		1
	P_IFSAME	pbyte1,4,.twin_get
	P_IFSAME	pbyte1,5,.hp_get

	P_INCSPWEAP	1,.catch_loop
	P_IFZERO	slopenum,.not_c
	P_FLAGMOTHER
.not_c
	P_GOSUB		.item_switch
	P_SCORE		sc_item_get
	P_SOUNDEFFECT	special_weapon	;$45
	P_REMOVE
.twin_get
	P_GOSUB		.item_switch
	P_SCORE		sc_item_get
	P_PLRWEAPLEVELUP
	P_SOUNDEFFECT	twin_blaster	;$43
	P_REMOVE
;;;.up1_get
;;;	P_SCORE		100
;;;	P_GOTO		.up1_get

;;;	P_GINC		b,Kw_PlayerRest1
;;;	P_GOSUB		.item_switch
;;;	P_SCORE		sc_item_get
;;;	P_SOUNDEFFECT	one_up		;$44
;;;	P_REMOVE
.hp_get
	P_GOSUB		.item_switch
	P_SET		pbyte1,8		;4
	P_GADD		Player1_hpadd,pbyte1
	P_SCORE		sc_hp_get
	P_REMOVE
.item_switch
	P_IFZERO	ap,.mugen
	P_IMPORT	pword1,eword1
	P_SETSWITCH	ap,pword1
	P_EXPORT	eword1,pword1
.mugen
	P_RETURN

item_col_anim
	P_ADD		colframe,pword1
	P_NEG		pword1
	P_FACEVIEW	IMMEDIATE
;	P_ZERO		rotx
	P_ADJUSTROT
	P_RETURN

;;;;ษอออออออออออออออป
;;;;บ PLANET TARGET บ
;;;;ศอออออออออออออออผ
;;;;------------ MISSILE DAI TARGET
;	START_PATH	e_g_dandou_yoko_final
;	P_INC		slopenum
;	START_PATH	e_g_dandou_yoko_tojikome
;
;	P_GOSUB		wakidashi_init
;
;	P_IFNOTZERO	slopenum,.nt
;.wnt
;	P_IMPORT	pbyte1,ebyte3
;	P_IFSAME	pbyte1,-1,.nt
;	P_SET		hp,100
;	P_GOTO		.wnt
;.nt
;	P_ZERO		rotx
;	P_INC		slopenum
;	P_IGOTO		pe_ground_dandou_a.enter

;;;;------------
	START_PATH	e_ground_dandou_medal

	P_INC		skidy
	P_IGOTO		pe_ground_dandou_a.medal_st
;-----------
	START_PATH	e_sea_dandou_a

	P_SHADOW	OFF
	P_SET		pword1,-1000
	P_IFLARGER	worldy,pword1,.in_sea
	P_GOSUB		sea_init_above_canhit
	P_IGOTO		.sea_st
.in_sea
	P_GOSUB		sea_init_below_canhit
.sea_st
;-----------
	START_PATH	e_ground_dandou_a
.medal_st	LOCAL
	P_GOSUB		wakidashi_init
	P_SET		rotx,-64
.enter	LOCAL
	P_SETCOLANIM	3
	P_SETANIM	0
	P_RTRIGGER	.sos_live_ck,WhenHit
	P_END

.sos_live_ck
	P_IFSAME	shape,batabata,.bata
	P_SET		pbyte1,95
	P_IFLARGER	hp,pbyte1,.live_ok
.bata
	P_FORCE		.next_step
.live_ok
	P_RETURN
.next_step
	P_TRIGGER	.sos_live_ck,OFF

	P_COLLISIONS	OFF
	P_IFSAME	shape,batabata,.bata_dead
	P_SCORE		sc_sos_strong

	P_TRIGGER	kani_explode,4
	P_TRIGGER	exp_smoke,8

	P_DO		15
	P_RANDOMGOTO	.pass_fl
	P_HITFLASHTRIG
.pass_fl
	P_NEXT
.bata_back
	P_IFZERO	slopenum,.not_tojikome
	P_IFSAME	slopenum,1,.tojiko
	P_GINC		b,ebyte2
	P_IGOTO		.not_tojikome
.tojiko
	P_GINC		b,ebyte3
.not_tojikome
	P_GOSUB		group_explode
	P_IFSAME	shape,batabata,.exp

	P_IFZERO	skidy,.not_medal
	P_EXPORT	gbyte1,roty
	P_GOSUB		set_medal
	P_BECOME
	P_ADD		worldy,300
	P_UNBECOME
.not_medal
	P_CIRCLEWINDOW	1,big			;10
	P_FINDSHAPE	miss_dai
	P_SHAPEDEAD	.exp
	P_SHAPEDISTLESS	600,.fla
	P_EXPLODE
.fla
	P_FLAGSHAPE
.exp
	P_EXPLODE
.bata_dead
	P_SCORE		sc_hit_dead
	P_IGOTO		.bata_back
;;;;------------
	START_PATH	e_yousai_laser
;;	P_INC		ox
;;	START_PATH	e_yousai_ring

	P_SET		skidy,roty
	P_GOSUB		init_hardslope_soff
	P_RANGECHECK	OFF

	P_IMPORT	pbyte1,ebyte6

	P_DO		4
	P_ADD		pbyte1,pbyte1
	P_INEXT
	P_DO		5
	P_SHIFTR	pbyte1
	P_INEXT
	P_IFSAME	pbyte1,7,.ended

	P_SPAWN		0,-440,0,0,0,0,you_0_1,e_buil_shadow_off_c,100,4,1
;	P_BECOME
;	P_RANGECHECK	OFF
;	P_UNBECOME
	P_SPAWN		-320,-280,320,0,160,0,yousai_4,e_buil_shadow_off_c,100,4,2
	P_BECOME
	P_SETANIM	0
;	P_RANGECHECK	OFF
	P_UNBECOME
	P_SPAWN		400,-520,400,0,96,0,yousai_4,e_buil_shadow_off_c,100,4,3
	P_BECOME
	P_SETANIM	1
;	P_RANGECHECK	OFF
	P_UNBECOME
	P_SPAWN		0,-720,-480,0,0,0,yousai_4,e_buil_shadow_off_c,100,4,4
	P_BECOME
	P_SETANIM	2
;	P_RANGECHECK	OFF
	P_UNBECOME

	P_IMPORT	pbyte1,ebyte6
	P_SET		pbyte2,2
;;;	P_IFZERO	ox,.ring
	P_IFSWITCH	pbyte2,pbyte1,.pas1
	P_SPAWN		-400,-380,400,0,32,0,taihou_0,e_laser_hou_c,2,4,5
.pas1
	P_INC		pbyte2
	P_IFSWITCH	pbyte2,pbyte1,.pas2
	P_SPAWN		0,-820,-600,0,127,0,taihou_0,e_laser_hou_c,3,4,6
.pas2
	P_INC		pbyte2
	P_IFSWITCH	pbyte2,pbyte1,.same_l
	P_SPAWN		490,-620,490,0,-32,0,taihou_0,e_laser_hou_c,4,4,7
;;;	P_IGOTO		.same_l
;;;.ring
;;;	P_IFSWITCH	pbyte2,pbyte1,.ppas1
;;;	P_SPAWN		-400,-380,400,0,32,0,yoi_hou,e_ring_hou_c,2,4,5
;;;.ppas1
;;;	P_INC		pbyte2
;;;	P_IFSWITCH	pbyte2,pbyte1,.ppas2
;;;	P_SPAWN		0,-820,-600,0,127,0,yoi_hou,e_ring_hou_c,3,4,6
;;;.ppas2
;;;	P_INC		pbyte2
;;;	P_IFSWITCH	pbyte2,pbyte1,.same_l
;;;	P_SPAWN		490,-620,490,0,-32,0,yoi_hou,e_ring_hou_c,4,4,7
.same_l
	P_SOUND		p2_you_0_0
	P_RTRIGGER	.hou_ck,WhenFlagged
	P_RADAROBJ	ra_enemy
	P_TRIGGER	radar_change,8
	P_TRIGGER	marker_set,Always
.lp
	P_ADD		roty,2
;	P_IFSAME	pbyte2,3,.exp
	P_GOTO		.lp
.hou_ck
	P_IMPORT	pbyte1,ebyte6
	P_DO		4
	P_ADD		pbyte1,pbyte1
	P_INEXT
	P_DO		5
	P_SHIFTR	pbyte1
	P_INEXT
	P_IFNOTSAME	pbyte1,7,.mada
	P_FORCE		.exp
.mada
	P_RETURN
.exp
	P_TRIGGER	.hou_ck,OFF
	P_TRIGGER	radar_change,OFF
	P_TRIGGER	marker_set,OFF
	P_RADAROBJ	ra_off
	P_WAIT		8
	P_SCREENFLASH
	P_WAIT		2
	P_SCORE		sc_yousai
	P_CIRCLEWINDOW	1,big
	P_GOSUB		c_flag_1234
;	P_FLAGCHILD	1
;	P_FLAGCHILD	2
;	P_FLAGCHILD	3
;	P_FLAGCHILD	4
.ended
	P_SOUND		port2_stop	;00
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,-40<<you_0_0_scale,0,0,0,0,on_d,e_sw_base_switch_c,100,4,9
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_END

;;;	START_PATH	e_yousai_0
;;;
;;;	P_SET		ty,14
;;;	P_INC		pbyte1
;;;	P_DO		roty
;;;	P_INC		pbyte1
;;;	P_CLRSWITCH	pbyte1,ty		;ty no bit = 0 put suru
;;;	P_INEXT
;;;	P_ZERO		roty
;;;	P_IMPORT	tx,ebyte6
;;;	P_GOSUB		.mk_yousai
;;;	P_GOSUB		init_hardslope_soff
;;;	P_TRIGGER	.you_rot,Always
;;;	P_TRIGGER	.you_an_dead,WhenFlagged
;;;	P_SOUND		p2_you_0_0
;;;	P_END
;;;.you_an_dead
;;;	P_IMPORT	tx,ebyte6
;;;	P_SETSWITCH	pbyte1,tx
;;;	P_EXPORT	ebyte6,tx
;;;	P_SET		pbyte1,1
;;;	P_CLRSWITCH	pbyte1,tx
;;;	P_ADD		tx,ty
;;;	P_IFSAME	tx,14,.all_clear
;;;	P_RETURN
;;;.all_clear
;;;	P_FORCE		.jibaku
;;;	P_RETURN
;;;.jibaku
;;;	P_TRIGGER	.you_rot,OFF
;;;	P_TRIGGER	.you_an_dead,OFF
;;;	P_FLAGCHILD	5
;;;	P_FLAGCHILD	6
;;;	P_FLAGCHILD	7
;;;	P_END
;;;.mk_yousai
;;;	P_SPAWN		0,-440,0,0,0,0,you_0_1,e_buil_shadow_off,100,4,1
;;;	P_SPAWN		-320,-280,320,0,160,0,yousai_4,e_buil_shadow_off,100,4,2
;;;	P_BECOME
;;;	P_SETANIM	0
;;;	P_UNBECOME
;;;	P_SPAWN		400,-520,400,0,96,0,yousai_4,e_buil_shadow_off,100,4,3
;;;	P_BECOME
;;;	P_SETANIM	1
;;;	P_UNBECOME
;;;	P_SPAWN		0,-720,-480,0,0,0,yousai_4,e_buil_shadow_off,100,4,4
;;;	P_BECOME
;;;	P_SETANIM	2
;;;	P_UNBECOME
;;;
;;;	P_SET		pbyte1,1
;;;	P_CLRSWITCH	pbyte1,tx
;;;	P_ADD		tx,ty
;;;	P_IFSAME	tx,14,.cont
;;;
;;;	P_SET		pbyte1,4
;;;	P_IFSWITCH	pbyte1,ty,.pass_1
;;;	P_IFSWITCH	pbyte1,tx,.pass_1
;;;	P_SPAWN		0,-760,-600,0,127,0,antenna,e_antenna,100,4,6
;;;	P_BECOME
;;;	P_SET		pbyte2,4
;;;	P_UNBECOME
;;;	P_IGOTO		.make_ante2
;;;.pass_1
;;;	P_SPAWN		0,-760,-600,0,127,0,taihou_0,e_taihou,2,4,6
;;;.make_ante2
;;;	P_DEC		pbyte1
;;;	P_IFSWITCH	pbyte1,ty,.pass_2
;;;	P_IFSWITCH	pbyte1,tx,.pass_2
;;;	P_SPAWN		400,-560,400,0,140,0,antenna,e_antenna,100,4,7
;;;	P_BECOME
;;;	P_SET		pbyte2,3
;;;	P_UNBECOME
;;;	P_IGOTO		.make_ante3
;;;.pass_2
;;;	P_SPAWN		490,-560,490,0,-32,0,taihou_0,e_taihou,2,4,7
;;;
;;;.make_ante3
;;;	P_DEC		pbyte1
;;;	P_IFSWITCH	pbyte1,ty,.pass_3
;;;	P_IFSWITCH	pbyte1,tx,.pass_3
;;;	P_SPAWN		-400,-320,400,0,32,0,antenna,e_antenna,100,4,5
;;;	P_BECOME
;;;	P_SET		pbyte2,2
;;;	P_UNBECOME
;;;	P_IGOTO		.cont
;;;.pass_3
;;;	P_SPAWN		-400,-320,400,0,32,0,taihou_0,e_taihou,2,4,5
;;;.cont
;;;	P_RETURN
;;;.you_rot
;;;	P_ADD		roty,2
;;;	P_RETURN
;;;;------------
;;;	START_PATH	e_taihou
;;;
;;;	P_GOSUB		sea_map_ck
;;;	P_IMPORT	pbyte1,KGameMapPtr
;;;	P_SET		hp,2
;;;	P_SET		ap,4
;;;	P_SET		ox,-1000
;;;	P_SHADOW	OFF
;;;	P_WEAPON	EPlasma1
;;;	P_RADAROBJ	ra_honmei
;;;	P_TRIGGER	.taihou_dead,WhenDead
;;;	P_TRIGGER	.jibaku_on,WhenFlagged
;;;.loop
;;;	P_ADD		roty,4
;;;	P_INC		childroty
;;;	P_PLAYERINCONE	5,.tai_fire
;;;	P_GOTO		.loop
;;;.taihou_dead
;;;	P_SCORE		sc_taihou
;;;	P_RETURN
;;;
;;;.jibaku_on
;;;	P_FORCE		.jibaku
;;;	P_RETURN
;;;.jibaku
;;;	P_TRIGGER	.jibaku_on,OFF
;;;	P_EXPLODE
;;;.tai_fire
;;;	P_IFNOTSAME	pbyte1,5,.not_sea_f
;;;	P_IMPORT	pword1,Player1_worldy
;;;
;;;	P_IFLARGER	worldy,ox,.under
;;;
;;;	P_IFSMALLER	pword1,ox,.not_sea_f
;;;	P_IGOTO		.out_range
;;;.under
;;;	P_IFSMALLER	pword1,ox,.out_range
;;;.not_sea_f
;;;	P_BEHINDKPLAYER	.out_range
;;;	P_ADD		worldy,-100
;;;	P_PUSH		roty
;;;	P_PUSH		childroty
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_ADJUSTROT
;;;	P_FIRE
;;;	P_PULL		childroty
;;;	P_PULL		roty
;;;	P_ZERO		childrotx
;;;	P_ZERO		rotx
;;;	P_ADD		worldy,100
;;;.out_range
;;;	P_WAIT		20
;;;	P_GOTO		.loop
;;;;------------
	START_PATH	e_mogura_ana_ring

	P_INC		mx

	START_PATH	e_mogura_ana_laser

	P_SET		hp,100
	P_COLLISIONS	OFF
	P_TRIGGER	shot_ck,Always
	P_TRIGGER	ana_live_ck,Always
	P_SETRANDOM	pbyte2,15
.lp
	P_IFNOTZERO	pbyte2,.cant
	P_IFSAME	mx,1,.ring_hou
	P_QSPAWN	taihou_0,e_mogura_laser_hou,1,4
.same_hou
	P_SETRANDOM	pbyte2,63
	P_WAIT		80
.cant
	P_GOTO		.lp
.ring_hou
	P_QSPAWN	yoi_hou,e_mogura_ring_hou,1,4
	P_GOTO		.same_hou
ana_live_ck
	P_IFNOTSAME	pbyte1,3,.ok
	P_FORCE		.exp
.ok
	P_RETURN
.exp
	P_SCORE		sc_mogura_ana
	P_EXPLODE
	
;-----------
	START_PATH	e_mogura_ring_hou

	P_INC		mx
	P_WEAPON	ERing
	P_IGOTO		pe_mogura_laser_hou.enter

	START_PATH	e_mogura_laser_hou

	P_WEAPON	ELaser
.enter	LOCAL
	P_TRIGGER	hit_dead,WhenDead
	P_TRIGGER	mog_hou_dead,WhenDead
	P_GOSUB		hit_dead_init
	P_CLIPPING	ON
	P_SHADOW	OFF
	P_SETRANDOM	roty
	P_SET		worldy,120
	P_FINDSHAPE	ana_0
	P_WAIT		3
	P_SET		pbyte1,8
	P_GOSUB		ran_neg_pb1

	P_SOUNDEFTDISTPOS	ob_ana_0_up	;$90*

	P_DO		16
	P_CHASE		worldy,-120
	P_NEXT

	P_SOUND		p2_yoi_hou	;08
.face_loop
	P_ADD		roty,pbyte1
	P_PLAYERINCONE	5,.atack
	P_GOTO		.face_loop
.atack
	P_SOUND		port2_stop
	P_DO		2
	P_ADD		worldy,-40
	P_GOSUB		sos_fire_must
	P_ADD		worldy,40
	P_WAIT		4
	P_NEXT
.cant
	P_SOUNDEFTDISTPOS	ob_ana_0_down	;$91*
	P_DO		12
	P_ADD		worldy,20
	P_NEXT

	P_REMOVE
mog_hou_dead
	P_BECOMESHAPE
	P_INC		pbyte1
	P_UNBECOME
	P_RETURN

;;;	START_PATH	e_mogura_base
;;;
;;;	P_SET		hp,2
;;;	P_COLLISIONS	OFF
;;;	P_INVINCIBLE	ON
;;;	P_SET		weapontype,roty
;;;	P_ZERO		roty
;;;	
;;;	P_DO		5
;;;	P_INDEX		pword1,mogu_base_x,pbyte1
;;;	P_EXPORT	gword1,pword1
;;;	P_INDEX		pword1,mogu_base_z,pbyte1
;;;	P_EXPORT	gword2,pword1
;;;	P_INC		pbyte1
;;;	P_EXPORT	gbyte1,pbyte1
;;;	P_SPAWN		0,0,0,0,0,0,ana_0,e_nocol_s_off,100,1,1
;;;	P_BECOME
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_SETID		pbyte1
;;;	P_GADD		childx,gword1
;;;	P_GADD		childz,gword2
;;;	P_UNBECOME
;;;	P_INEXT
;;;
;;;.again
;;;	P_IFSWITCH	weapontype,.mogu_end
;;;	P_GOSUB		.set_pos
;;;	P_GOSUB		.pass_pos
;;;
;;;	P_QSPAWN	antenna,e_mogura_antenna,100,4
;;;	P_EXPORT	gbyte3,weapontype
;;;	P_BECOME
;;;	P_FINDSHAPE	ana_0
;;;	P_IMPORT	tx,gbyte1
;;;	P_IMPORT	ty,gbyte2
;;;	P_IMPORT	skidy,gbyte3
;;;	P_SET		worldy,220
;;;	P_GADD		worldx,gword1
;;;	P_GADD		worldz,gword2
;;;	P_SET		pword1,-50
;;;	P_UNBECOME
;;;
;;;	P_WAIT		50
;;;.only_hou
;;;	P_DO		2
;;;	P_IFNOTZERO	slopenum,.mogu_end2
;;;	P_GOSUB		.set_pos
;;;	P_GOSUB		.pass_pos
;;;
;;;	P_QSPAWN	taihou_0,e_mogura_hou,2,4
;;;	P_BECOME
;;;	P_FINDSHAPE	ana_0
;;;	P_IMPORT	tx,gbyte1
;;;	P_IMPORT	ty,gbyte2
;;;	P_SET		worldy,150
;;;	P_GADD		worldx,gword1
;;;	P_GADD		worldz,gword2
;;;	P_UNBECOME
;;;
;;;	P_WAIT		50
;;;.mogu_end2
;;;	P_INEXT
;;;
;;;	P_RANDOMGOTO	.only_hou
;;;	P_GOTO		.again
;;;.mogu_end
;;;	P_ZERO		pbyte1
;;;	P_DO		5
;;;	P_INC		pbyte1
;;;	P_BECOMECHILD	pbyte1
;;;	P_SETCOLANIM	2
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_SETCOLANIM	2
;;;	P_END
;;;
;;;.pass_pos
;;;	P_SETSWITCH	tx,pbyte1	
;;;	P_SETSWITCH	ty,pbyte2
;;;
;;;	P_EXPORT	gbyte1,tx
;;;	P_EXPORT	gbyte2,ty
;;;	P_DEC		tx
;;;	P_DEC		tx
;;;	P_INDEX		pword1,mogu_base_x,tx
;;;	P_EXPORT	gword1,pword1
;;;	P_INDEX		pword1,mogu_base_z,tx
;;;	P_EXPORT	gword2,pword1
;;;	P_RETURN
;;;
;;;;-------------
;;;.set_pos
;;;	P_IFNOTSAME	pbyte2,7,.cont
;;;	P_RETURN
;;;.cont
;;;	P_SETRANDOM	tx,7
;;;	P_IFSMALLER	tx,hp,.set_pos		;tx= 2 -> 7
;;;
;;;	P_IFSWITCH	tx,pbyte1,.set_pos
;;;
;;;	P_SET		ty,1
;;;	P_IFSWITCH	ty,pbyte2,.pass_1
;;;	P_RETURN
;;;.pass_1
;;;	P_INC		ty
;;;	P_IFSWITCH	ty,pbyte2,.pass_2
;;;	P_RETURN
;;;.pass_2
;;;	P_INC		ty
;;;	P_RETURN
;;;	
;;;;-------------
;;;mogu_base_x
;;;	dw	0,800,800,1600,1600,0
;;;mogu_base_z
;;;	dw	-800,-800,0,-800,0,0
;;;;-----------
;;;	START_PATH	e_1_mogura_antenna
;;;
;;;	P_QSPAWN	ana_0,e_1_mogura_ana,100,0
;;;	P_STAMPSTART
;;;	P_SET		worldy,220
;;;	P_IGOTO		pe_mogura_antenna.mog_1_start
;;;	P_END
;;;;-----------
;;;	START_PATH	e_1_mogura_ana
;;;
;;;	P_BECOMEINERT
;;;	P_COLLISIONS	OFF
;;;	P_SHADOW	OFF
;;;	P_CLRTYPE	enemy1
;;;	P_SET		hp,100
;;;.wait_stop
;;;	P_IFFLAG	.col_stop
;;;	P_GOTO		.wait_stop
;;;.col_stop
;;;	P_STAMPSTART
;;;	P_COLLISIONS	OFF
;;;	P_SHADOW	OFF
;;;	P_CLRTYPE	enemy1
;;;	P_SET		hp,100
;;;	P_SETCOLANIM	2
;;;	P_SCENERY
;;;;-----------
;;;	START_PATH	e_mogura_antenna
;;;
;;;	P_SET		pbyte2,30		;flag mogura
;;;.mog_1_start	LOCAL
;;;	P_SET		ap,4
;;;	P_SHADOW	OFF
;;;	P_SETANIM	0
;;;	P_INVINCIBLE	ON
;;;	P_CLIPPING	ON
;;;	P_SET		pbyte1,antenna_hp
;;;.mogu_ante_up
;;;	P_RADAROBJ	ra_enemy
;;;	P_SOUND		p2_antenna
;;;	P_SOUNDEFTDISTPOS	ob_movewall_SL	;$90
;;;
;;;	P_DO		22
;;;	P_SET		hp,100
;;;	P_ADD		worldy,-10
;;;	P_NEXT
;;;
;;;	P_INVINCIBLE	OFF
;;;
;;;	P_TRIGGER	.mogante_hit,WhenHit
;;;	P_DO		50
;;;	P_ADD		roty,5
;;;	P_NEXT
;;;	P_CLEARSTACK
;;;	P_TRIGGER	.mogante_hit,OFF
;;;
;;;	P_INVINCIBLE	ON
;;;
;;;	P_SOUNDEFTDISTPOS	ob_movewall_down	;$91
;;;	P_DO		22
;;;	P_ADD		worldy,10
;;;	P_SET		hp,100
;;;	P_NEXT
;;;
;;;	P_IFZERO	pbyte2,.for_mog_1_ante
;;;	P_GOSUB		pe_antenna.clr_cker
;;;	P_REMOVE
;;;.for_mog_1_ante
;;;	P_RADAROBJ	ra_off
;;;	P_SOUND		port2_stop	;00
;;;.mog_1_wait
;;;	P_WAIT		60
;;;	P_RANDOMGOTO	.mog_1_wait
;;;	P_GOTO		.mogu_ante_up
;;;
;;;.mogante_hit
;;;	P_IFLARGER	hp,pbyte1,.mog_live
;;;	P_FORCE		.exp
;;;.mog_live
;;;	P_RETURN
;;;.exp
;;;	P_TRIGGER	.mogante_hit,OFF
;;;
;;;	P_IFNOTZERO	pbyte2,.not_1_mog
;;;	P_FINDSHAPE	ana_0
;;;	P_FLAGSHAPE
;;;.not_1_mog
;;;	P_IGOTO		pe_antenna.exp_mogante
;;;;----------
;;;	START_PATH	e_mogura_hou
;;;
;;;	P_SHADOW	OFF
;;;	P_CLIPPING	ON
;;;	P_WEAPON	EPlasma1
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_RADAROBJ	ra_honmei
;;;	P_TRIGGER	.mog_hou_dead,WhenDead
;;;
;;;	P_SOUNDEFTNEARPOS	ob_movewall_SL	;$90
;;;
;;;	P_DO		15
;;;	P_ADD		worldy,-10
;;;	P_NEXT
;;;
;;;	P_DO		50
;;;	P_FACEPLAYER	y
;;;	P_PLAYERINCONE	1,.mog_fire
;;;	P_IGOTO		.to_next
;;;.mog_fire
;;;	P_BREAK		.mog_fire_on
;;;.to_next
;;;	P_NEXT
;;;
;;;.mog_fire_on
;;;	P_CLEARSTACK
;;;	P_BEHINDKPLAYER	.out_range
;;;	P_ADD		worldy,-100
;;;	P_GOSUB		immed_fire
;;;	P_ZERO		rotx
;;;	P_ADD		worldy,100
;;;.out_range
;;;	P_WAIT		20
;;;	P_SOUNDEFTNEARPOS	ob_movewall_down	;$91
;;;	P_DO		15
;;;	P_ADD		worldy,10
;;;	P_NEXT
;;;
;;;	P_GOSUB		pe_antenna.clr_cker
;;;	P_REMOVE
;;;.mog_hou_dead
;;;	P_GOSUB		pe_antenna.clr_cker
;;;	P_SCORE		sc_mog_hou
;;;	P_COLLISIONS	OFF
;;;	P_IFBETWEEN	-10,worldy,30,.normal
;;;	P_SET		worldy,20
;;;.normal
;;;	P_RETURN
;;;;-----------
;;;	START_PATH	e_water_antenna
;;;
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_CLRTYPE	enemy1
;;;	P_SET		pbyte1,antenna_hp
;;;	P_SETANIM	0
;;;	P_TRIGGER	.water_ante_hit,WhenHit		;ByPlayer
;;;	P_RANGECHECK	OFF
;;;.lp
;;;	P_INVISIBLE	ON
;;;	P_WAIT		100
;;;	P_CLIPPING	ON
;;;	P_SET		worldy,220
;;;	P_INVISIBLE	OFF
;;;	P_QSPAWN	splash,e_sp_splash,7,40
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_SET		worldy,-50
;;;	P_UNBECOME
;;;	P_SOUNDEFTDISTPOS	en_outmarine	;$89
;;;	P_DO		4
;;;	P_ADD		worldy,-47
;;;	P_NEXT
;;;
;;;	P_SPAWN		0,-50,0,0,0,0,splash,e_sp_splash_cont,7,30,9
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_SPAWN		0,-50,0,0,0,0,splash,e_sp_splash_cont,7,0,10
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;	P_SOUND		p2_antenna	;08
;;;
;;;	P_DO		40
;;;	P_ADD		roty,4
;;;	P_NEXT
;;;
;;;	P_SOUND		port2_stop
;;;
;;;	P_QSPAWN	splash,e_sp_splash,7,40
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_SET		worldy,-50
;;;	P_UNBECOME
;;;	P_REMOVE	9
;;;	P_REMOVE	10
;;;
;;;	P_SOUNDEFTDISTPOS	en_inmarine	;$88
;;;	P_DO		4
;;;	P_ADD		worldy,47
;;;	P_NEXT
;;;	P_GOTO		.lp
;;;.water_ante_hit
;;;	P_IFLARGER	hp,pbyte1,.ok
;;;	P_FORCE		.ante_out
;;;.ok
;;;	P_RETURN
;;;.ante_out
;;;	P_TRIGGER	.water_ante_hit,OFF
;;;	P_CLIPPING	ON
;;;	P_SET		worldy,32
;;;	P_IGOTO		pe_antenna.exp_mogante
;;;;-----------
;;;	START_PATH	e_room_antennabig
;;;
;;;	P_SET		hp,100
;;;	P_SET		rotx,-64
;;;	P_SPAWN		0,-40<<r_anbig_scale,0,0,0,0,r_an_1big,e_room_anbig_c,100,2,1
;;;	P_BECOME
;;;	P_RANGECHECK	OFF
;;;	P_UNBECOME
;;;	P_SOUND		p2_r_an_0
;;;	P_CLRTYPE	enemy1
;;;
;;;	P_IGOTO		pe_antenna.room_st
;;;;-----
;;;	START_PATH	e_room_antenna
;;;
;;;	P_GOSUB		.mk_r_an
;;;
;;;	P_SOUND		p2_r_an_0
;;;	P_CLRTYPE	enemy1
;;;	P_IGOTO		pe_antenna.room_st
;;;	P_END
;;;
;;;.mk_r_an	LOCAL
;;;	P_SPAWN		0,-40<<r_an_scale,0,0,0,0,r_an_1,e_room_an_c,100,2,1
;;;	P_RETURN
;;;;-----------
;;;	START_PATH	e_room_anbig_c
;;;	P_INC		skidy
;;;	START_PATH	e_room_an_c
;;;
;;;	P_COLLISIONS	OFF
;;;	P_SHADOW	OFF
;;;	P_ACTIVE	ON
;;;	P_RANGECHECK	OFF
;;;	P_TRIGGER	.room_c_fl,WhenFlagged
;;;	P_IFZERO	skidy,.lp
;;;	P_END
;;;.lp
;;;	P_ADD		childroty,8
;;;	P_GOTO		.lp
;;;.room_c_fl
;;;	P_FORCE		pe_antenna_exp.room_c_exp
;;;	P_RETURN
;;;;------------
;;;	START_PATH	e_antenna
;;;antenna_hp = 89
;;;.st	LOCAL
;;;	P_GOSUB		sea_map_ck
;;;	P_SOUND		p2_antenna
;;;.room_st	LOCAL
;;;	P_RANGECHECK	OFF
;;;	P_GOSUB		set_hp100_ap4_enemy
;;;	P_SHADOW	OFF
;;;	P_SET		pbyte1,antenna_hp
;;;	P_SETANIM	0
;;;	P_IFSAME	shape,r_an_0,.room_0
;;;	P_IFSAME	shape,r_an_0big,.room_0
;;;	P_TRIGGER	.ante_hp,Always
;;;.room_0
;;;	P_TRIGGER	.ante_hit,WhenHit		;ByPlayer
;;;	P_END
;;;
;;;.ante_hit	LOCAL
;;;	P_IFLARGER	hp,pbyte1,.live_ante
;;;	P_FORCE		.exp_ante
;;;.live_ante
;;;	P_RETURN
;;;.exp_ante
;;;	P_TRIGGER	.ante_hit,OFF
;;;	P_IFSAME	shape,r_an_0,.exp_mogante
;;;	P_IFSAME	shape,r_an_0big,.exp_mogante
;;;	P_TRIGGER	.ante_hp,OFF
;;;.exp_mogante	LOCAL
;;;	P_CLEARSTACK
;;;	P_COLLISIONS	OFF
;;;
;;;	P_TRIGGER	marker_set,OFF
;;;	P_CLRDEMOSHAPE
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCORE		sc_antenna
;;;
;;;
;;;	P_IFZERO	pbyte2,.notc
;;;	P_IFNOTSAME	pbyte2,30,.not_mog_shape
;;;	P_BECOMESHAPE				;findshape=ana0
;;;	P_SET		slopenum,1
;;;	P_UNBECOME
;;;	P_GOSUB		.clr_cker
;;;	P_SETSWITCH	skidy
;;;	P_IGOTO		.notc
;;;.not_mog_shape
;;;	P_EXPORT	gbyte1,pbyte2
;;;	P_BECOMEMOTHER
;;;	P_IMPORT	pbyte1,gbyte1
;;;	P_UNBECOME
;;;	P_FLAGMOTHER
;;;	P_SETSWITCH	pbyte2
;;;
;;;	P_RELATIVE	OFF
;;;.notc
;;;	IFEQ		antenna_demo_cut
;;;
;;;	P_IFSAME	rotx,-128,.ten1
;;;	P_IFSAME	shape,r_an_0big,.bigan
;;;
;;;	P_ADD		worldy,-100
;;;	P_GOSUB		make_demo_target
;;;	P_ADD		worldy,100
;;;	P_EXPORT	gword1,worldy
;;;	P_BECOME
;;;	P_SET		tx,45
;;;	P_IMPORT	pword1,gword1
;;;	P_ADD		pword1,-150
;;;	P_SET		slopenum,de_for_sonota
;;;	P_UNBECOME
;;;
;;;.back_ten1
;;;	P_GOSUB		demo_move_wait
;;;
;;;	ENDC
;;;
;;;	P_IFNOTZERO	pbyte2,.for_yousai
;;;.mog_back
;;;	P_SPAWN		0,-60,0,0,0,0,nullshape,e_sp_random_exp_maker,100,0,1
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_IGOTO		.same
;;;.for_yousai
;;;	P_IFSAME	pbyte2,30,.mog_back
;;;	P_TRIGGER	mk_many_damy_exp,4
;;;.same
;;;	P_DO		20
;;;	P_RANDOMGOTO	.not_flash
;;;	P_HITFLASHTRIG
;;;.not_flash
;;;	P_NEXT
;;;
;;;	P_REMOVE	9		;for water_antenna
;;;	P_REMOVE	10		;remove water circle
;;;	
;;;	P_SETRANDOM	tx,31
;;;	P_SETRANDOM	ty,31
;;;	P_ADD		tx,-16
;;;	P_ADD		ty,-16
;;;
;;;	P_IFSAME	shape,r_an_0big,.anbig
;;;	P_IFNOTSAME	shape,r_an_0,.not_room
;;;.anbig
;;;	P_FLAGCHILD	1
;;;	P_UNLINKCHILD	1
;;;	P_IGOTO		.room_exp
;;;.not_room
;;;	P_SETANIM	1
;;;	P_QSPAWN	antenna_end,e_antenna_exp,100,1
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_SETANIM	2
;;;	P_UNBECOME
;;;
;;;	P_QSPAWN	explosion5,e_sp_explosion,100,24
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;	P_ADD		worldy,-124
;;;	P_SET		shape,antenna_end
;;;
;;;.room_exp
;;;
;;;	P_ZERO		slopenum
;;;	P_DO		20
;;;	P_AUTOINDEX	B,worldy,div2_jumptab,slopenum,20
;;;	P_ADD		worldx,tx
;;;	P_ADD		worldz,ty
;;;	P_ADD		rotx,16
;;;	P_ADD		roty,16
;;;	P_NEXT
;;;
;;;	P_EXPLODE
;;;
;;;	IFEQ		antenna_demo_cut
;;;.ten1
;;;	P_ADD		worldy,100
;;;	P_GOSUB		make_demo_target
;;;	P_ADD		worldy,-100
;;;	P_EXPORT	gword1,worldy
;;;	P_BECOME
;;;	P_SET		tx,45
;;;	P_IMPORT	pword1,gword1
;;;	P_ADD		pword1,150
;;;	P_SET		slopenum,de_for_sonota
;;;	P_UNBECOME
;;;	P_IGOTO		.back_ten1
;;;.bigan
;;;	P_GOSUB		make_demo_target
;;;	P_EXPORT	gword1,worldy
;;;	P_BECOME
;;;	P_SET		tx,45
;;;	P_IMPORT	pword1,gword1
;;;	P_SET		slopenum,de_for_kusha
;;;	P_UNBECOME
;;;	P_IGOTO		.back_ten1
;;;
;;;	ENDC
;;;;----------
;;;.ante_hp	LOCAL
;;;	P_ADD		childroty,4
;;;	P_ADD		roty,5
;;;	P_RETURN
;;;;-----------
;;;.clr_cker	LOCAL
;;;	P_EXPORT	gbyte1,tx
;;;	P_EXPORT	gbyte2,ty
;;;	P_BECOMESHAPE
;;;	P_IMPORT	ap,gbyte1
;;;	P_CLRSWITCH	ap,pbyte1
;;;	P_IMPORT	ap,gbyte2
;;;	P_CLRSWITCH	ap,pbyte2
;;;	P_UNBECOME
;;;	P_RETURN
;;;
;;;;-----------
;;;	START_PATH	e_antenna_exp
;;;
;;;.room_c_exp	LOCAL
;;;	P_COLLISIONS	OFF
;;;	P_INVINCIBLE	ON
;;;
;;;	P_SETRANDOM	tx,31
;;;	P_SETRANDOM	ty,31
;;;	P_ADD		tx,-16
;;;	P_ADD		ty,-16
;;;	P_ADD		worldy,-40
;;;
;;;	P_DO		15
;;;	P_AUTOINDEX	B,worldy,div2_jumptab,pbyte2,20
;;;	P_ADD		worldx,tx
;;;	P_ADD		worldz,ty
;;;	P_ADD		rotx,16
;;;	P_ADD		roty,16
;;;	P_NEXT
;;;
;;;	P_EXPLODE
;;;
;;;;------------ TARGET ROBOT SERIES
;;;	START_PATH	e_keep_track
;;;
;;;	P_SET		skidy,ap
;;;	P_GOSUB		set_hp100_ap4
;;;	P_SET		pbyte1,89
;;;	P_SOUND		p2_track_0
;;;	P_GOSUB		.mk_track_child
;;;
;;;	P_TRIGGER	.track_hit,Always
;;;
;;;.track_loop
;;;	P_CLEARSTACK
;;;	P_SET		pbyte2,skidy
;;;	P_ZERO		skidy
;;;.root_again
;;;	P_IFSAME	pbyte2,13,.track_loop
;;;	  P_INDEX		ty,track_root,pbyte2
;;;	  P_INDEX		slopenum,track_ang,ty
;;;
;;;.track_y_rot
;;;	  P_IFSAME		roty,slopenum,.track_ry_end
;;;	  P_CHASE		roty,slopenum
;;;	  P_EXPORT		gbyte1,slopenum
;;;	  P_BECOMECHILD		1
;;;	  P_IMPORT		slopenum,gbyte1
;;;	  P_IFNOTZERO		pword1,.tr_k_at1
;;;	  P_CHASE		roty,slopenum
;;;.tr_k_at1
;;;	  P_UNBECOME
;;;	  P_BECOMECHILD		2
;;;	  P_IMPORT		slopenum,gbyte1
;;;	  P_IFNOTZERO		pword1,.tr_k_at2
;;;	  P_CHASE		roty,slopenum
;;;.tr_k_at2
;;;	  P_UNBECOME
;;;	  P_GOTO		.track_y_rot
;;;.track_ry_end
;;;	  P_ADD		ty,ty
;;;	  P_INDEX		slopenum,track_move,ty
;;;	  P_INC		ty
;;;	  P_INDEX		tx,track_move,ty
;;;	  P_DO		100
;;;	    P_ADD		worldx,slopenum
;;;	    P_ADD		worldz,tx
;;;	    P_EXPORT		gbyte1,slopenum
;;;	    P_EXPORT		gbyte2,tx
;;;	    P_BECOMECHILD	1
;;;	    P_IMPORT		tx,gbyte1
;;;	    P_IMPORT		ty,gbyte2
;;;	    P_ADD		worldx,tx
;;;	    P_ADD		worldz,ty
;;;	    P_IFNOTZERO		pword1,.tr_k_att1
;;;	    P_CHASE		roty,slopenum
;;;.tr_k_att1
;;;	    P_UNBECOME
;;;	    P_BECOMECHILD	2
;;;	    P_IMPORT		tx,gbyte1
;;;	    P_IMPORT		ty,gbyte2
;;;	    P_ADD		worldx,tx
;;;	    P_ADD		worldz,ty
;;;	    P_IFNOTZERO		pword1,.tr_k_att2
;;;	    P_CHASE		roty,slopenum
;;;.tr_k_att2
;;;	    P_UNBECOME
;;;	  P_NEXT
;;;	P_INC			pbyte2
;;;	P_GOTO		.root_again
;;;
;;;.mk_track_child
;;;	P_SPAWN		0,-40,-60,-64,128,0,d_robo,e_keep_robo,10,10,3
;;;	P_BECOME
;;;	P_SET		slopenum,1
;;;	P_UNBECOME
;;;	P_SPAWN		500,-10,0,0,0,0,kumo_0,e_track_kumo,100,4,1
;;;	P_BECOME
;;;	P_SET		pbyte1,1
;;;	P_UNBECOME
;;;	P_SPAWN		-500,-10,0,0,0,0,kumo_0,e_track_kumo,100,4,2
;;;	P_BECOME
;;;	P_SET		pbyte1,10
;;;	P_UNBECOME
;;;	P_RETURN
;;;.track_hit
;;;	P_IMPORT	childz,Player1_worldy
;;;	P_IFLARGER	hp,pbyte1,.track_ok
;;;	P_FORCE		.track_dead
;;;.track_ok
;;;	P_RETURN
;;;.track_dead
;;;	P_TRIGGER	.track_hit,OFF
;;;	P_COLLISIONS	OFF
;;;	P_REMOVE	4
;;;	P_FLAGCHILD	1
;;;	P_FLAGCHILD	2
;;;	P_UNLINKCHILD	1
;;;	P_UNLINKCHILD	2
;;;
;;;	IFEQ		keep_track_demo_cut
;;;
;;;	P_GOSUB		make_demo_target
;;;	P_BECOME
;;;	P_SET		pword1,-160
;;;	P_SET		ty,32
;;;	P_SET		tx,25
;;;	P_SET		slopenum,de_for_robot
;;;	P_UNBECOME
;;;
;;;	P_GOSUB		demo_move_wait
;;;
;;;	ENDC
;;;
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,20
;;;	P_HITFLASHTRIG
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;	P_SET		pbyte1,13
;;;	P_DO		14
;;;	P_AUTOINDEX	B,worldy,slow_jumptab,pbyte1,40
;;;	P_NEXT
;;;
;;;	P_TRIGGER	mk_many_damy_exp,4
;;;
;;;	P_SET		pbyte1,-5
;;;	P_SET		pbyte2,5
;;;	P_DO		30
;;;	P_ADD		worldy,pbyte1
;;;	P_ADD		worldx,pbyte2
;;;	P_NEG		pbyte1
;;;	P_NEG		pbyte2
;;;	P_RANDOMGOTO	.no_flash
;;;	P_RANDOMGOTO	.no_flash
;;;	P_HITFLASHTRIG
;;;.no_flash
;;;	P_NEXT
;;;
;;;	P_FLAGCHILD	3
;;;	P_UNLINKCHILD	3
;;;
;;;	P_SCORE		sc_keep_track
;;;	P_SET		shape,track_0end
;;;	P_EXPLODE
;;;
;;;track_root
;;;	db	5,6,0,0,2,4,3,2,2,0,7,6,4
;track_ang
;	db	0,32,64,92,128,160,192,224
;track_move
;	db	0,10	;0
;	db	-10,10	;1
;	db	-10,0	;2
;	db	-10,-10	;3
;	db	0,-10	;4
;	db	10,-10	;5
;	db	10,0	;6
;	db	10,10	;7
;;;;------------
;;;	START_PATH	e_track_kumo
;;;
;;;	P_RADAROBJ	ra_enemy
;;;
;;;	P_RELATIVE	OFF
;;;	P_WEAPON	Eplasma1
;;;	P_TRIGGER	kumo_anim,Always
;;;	P_TRIGGER	.tr_kumo_dead,WhenHit		;Dead
;;;	P_TRIGGER	.tr_kumo_mdead,WhenFlagged
;;;.tr_kumo_st
;;;	P_CLEARSTACK
;;;	P_WAIT		40
;;;	P_TRIGGER	.tr_kumo_fipl,Always
;;;	P_END
;;;.tr_kumo_mdead
;;;	P_FORCE		.tr_kumo_orig
;;;	P_RETURN
;;;.tr_kumo_orig
;;;	P_CLEARSTACK
;;;	P_TRIGGER	.tr_kumo_mdead,OFF
;;;	P_TRIGGER	.tr_kumo_fipl,OFF
;;;	P_TRIGGER	.tr_kumo_chase,Always
;;;	P_ALWAYSGENVECS	ON
;;;	P_SETVEL	7
;;;	P_SET		pbyte2,64
;;;	P_END
;;;.tr_kumo_chase
;;;	P_FACEPLAYER	y
;;;	P_DEC		pbyte2
;;;	P_IFZERO	pbyte2,.tr_kumo_aton
;;;	P_RETURN
;;;.tr_kumo_aton
;;;	P_SET		pbyte2,64
;;;	P_GOSUB		.kumo_fire
;;;	P_RETURN
;;;.kumo_fire
;;;	P_ADD		worldy,-50
;;;	P_GOSUB		immed_fire
;;;	P_ZERO		rotx
;;;	P_ADD		worldy,50
;;;	P_RETURN
;;;
;;;.tr_kumo_dead
;;;	P_SCORE		sc_tr_kumo
;;;	P_FORCE		.must_exp
;;;	P_RETURN
;;;.must_exp
;;;	P_TRIGGER	.tr_kumo_fipl,OFF
;;;	P_TRIGGER	.tr_kumo_dead,OFF
;;;	P_TRIGGER	.tr_kumo_chase,OFF
;;;	P_IGOTO		final_enemy_demo
;;;
;;;.tr_kumo_fipl
;;;	P_SET		pword1,1
;;;	P_FORCE		.tr_kumo_attack
;;;	P_RETURN
;;;.tr_kumo_attack
;;;	P_TRIGGER	.tr_kumo_fipl,OFF
;;;	P_DISTMORE	2000,.pass_atack
;;;	P_DO		10
;;;	P_FACEPLAYER	y
;;;	P_NEXT
;;;	P_WAIT		10
;;;	P_GOSUB		.kumo_fire
;;;.pass_atack
;;;	P_ZERO		pword1
;;;	P_GOTO		.tr_kumo_st
;;;
;;;;------------
	START_PATH	e_sw_base_worm

	P_SET		skidy,hp
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,pe_sw_base_bird.already_end
	P_TRIGGER	shadow_ck,Always
	P_TRIGGER	self_invincible,Always
	P_TRIGGER	radar_change,8
	P_TRIGGER	marker_set,Always
	P_RADAROBJ	ra_enemy
	P_ENEMYDMGSE	en_cry_2
	P_CLIPPING	ON
	P_COLLISIONS	OFF

kep_w_hp = 20

	P_SET		slopenum,kep_w_hp
	P_GOSUB		set_child_xz
.kep_restart
	P_SET		worldy,300		;250
.kep_restart_wait
	P_WITHINRADIUS	2500,.work_start
	P_GOTO		.kep_restart_wait
.work_start
;	P_RADAROBJ	ra_enemy
	P_SET		worldx,childx
	P_SET		worldz,childz
	P_GOSUB		set_hp100_ap4
	P_ZERO		childrotx
	P_SET		worldy,2300			;2250
	P_ZERO		rotx
	P_SETRANDOM	roty
	P_SET		childroty,roty
	P_ADD		childroty,128
	P_SETVEL	30
	P_DO		40			;worldy=250 made agaru
	P_ADD		worldy,-50
	P_NEXT
	P_SETVEL	0
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,0,0,0,0,0,hasami_2,e_worm_c,100,4,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_INVISIBLE	ON
	P_SET		pbyte1,1
	P_UNBECOME
.wait_finish_make_c
	P_WAIT		1
	P_CHILDDEAD	4,.wait_finish_make_c
	P_SET		pbyte2,1
	P_DO		3
	P_BECOMECHILD	pbyte2
	P_SET		pbyte2,1
	P_UNBECOME
	P_INC		pbyte2
	P_INEXT
;	P_RADAROBJ	ra_off
	P_TRIGGER	hasami_smoke,2
;	P_WAIT		3
;	P_BECOMECHILD	5
;	P_SET		pword1,1
;	P_SET		pbyte1,70
;	P_UNBECOME
	P_WAIT		50
	P_SET		pbyte2,16		;add roty,16
	P_RTRIGGER	.hasami_roty,Always     ;always
	P_DO		20		;15
	P_ADD		worldy,-10
	P_NEXT

	P_SET		pword1,3
	P_RTRIGGER	.hasami_wave,Always

	P_SET		pbyte1,3
	P_DO		3
	 P_DO		9
	  P_BECOMECHILD	pbyte1
	   P_ADD		childy,-10
	  P_UNBECOME
	 P_NEXT
	 P_DEC		pbyte1
	P_NEXT

	P_DO		10
	 P_ADD		worldy,-10
	P_NEXT

	P_SET		pbyte2,2
	P_TRIGGER	hasami_smoke,OFF

	P_RTRIGGER	.kep_worm_hit,WhenHitByPlayer
	P_RTRIGGER	.kep_worm_live,Always

	P_WAIT		50

	P_TRIGGER	.kep_worm_hit,OFF
	P_TRIGGER	.kep_worm_live,OFF


	P_TRIGGER	hasami_smoke,2

;;;	P_REMOVE	5

	P_WAIT		15

	P_GOSUB		.kep_run

	P_TRIGGER	.hasami_wave,OFF

	P_DO		20			;15
	 P_ADD		worldy,10
	P_NEXT

	P_WAIT		15

	P_TRIGGER	hasami_smoke,OFF

	P_TRIGGER	.hasami_roty,OFF

	P_REMOVE	4
	P_REMOVE	3
	P_REMOVE	2
	P_REMOVE	1

	P_RADAROBJ	ra_enemy

.rem_c_wait
	P_CHILDDEAD	1,.fin_rem_c
	P_GOTO		.rem_c_wait
;-------------
.hasami_roty
	P_ADD		roty,pbyte2
	P_RETURN
;-------------
.fin_rem_c
	P_SET		roty,childroty
	P_ZERO		rotx
	P_SETVEL	30
	P_DO		40
	P_ADD		worldy,50
	P_NEXT
	P_SETVEL	0
	P_GOTO		.kep_restart
;-------------
.kep_worm_hit
	P_IFNOTZERO	childrotx,.hit_c
	P_DEC		slopenum
	P_IGOTO		.life_ck
.hit_c
	P_RETURN
.kep_worm_live
	P_IFZERO	childrotx,.life_ck
	P_DEC		slopenum
	P_ZERO		childrotx
.life_ck
	P_IFLARGER	slopenum,ap,.life_ok
	P_FORCE		.kep_w_dead
.life_ok
	P_RETURN
.kep_w_dead
	P_TRIGGER	marker_set,OFF
	P_TRIGGER	radar_change,OFF
	P_RADAROBJ	ra_enemy
	P_TRIGGER	.kep_worm_hit,OFF
	P_TRIGGER	.kep_worm_live,OFF

;;;	IFEQ		keep_worm_demo_cut
;;;
;;;	P_EXPORT	gword2,worldx
;;;	P_EXPORT	gword3,worldz
;;;
;;;	P_BECOMECHILD	5
;;;	P_EXPORT	gword1,worldy
;;;	P_IMPORT	pword1,gword2
;;;	P_NEG		pword1
;;;	P_ADD		pword1,worldx
;;;	P_EXPORT	gword2,pword1
;;;	P_IMPORT	pword1,gword3
;;;	P_NEG		pword1
;;;	P_ADD		pword1,worldz
;;;	P_EXPORT	gword3,pword1
;;;	P_UNBECOME
;;;
;;;	P_QSPAWN	demo_target,e_r_demo_target,100,0
;;;	P_BECOME
;;;	P_GADD		worldx,gword2
;;;	P_GADD		worldz,gword3
;;;	P_IMPORT	pword1,gword1
;;;	P_DIV2		pword1
;;;	P_DIV2		pword1
;;;	P_SET		worldy,pword1
;;;	P_UNBECOME
;;;	P_GOSUB		make_demo_worm
;;;	P_BECOME
;;;	P_SET		pword1,-160
;;;	P_SET		ty,15
;;;	P_SET		tx,25
;;;	P_SET		slopenum,de_for_robot
;;;	P_UNBECOME
;;;
;;;	ENDC

	P_FLAGCHILD	4
	P_UNLINKCHILD	4

	P_SOUNDEFTPOS	en_death_2	;$79
	P_RTRIGGER	.hasami_c3_anim,Always

	P_TRIGGER	hasami_smoke,2

	P_GOSUB		.kep_run

	P_TRIGGER	.hasami_wave,OFF

	P_DO		15
	 P_ADD		worldy,10
	P_NEXT

	P_TRIGGER	hasami_smoke,OFF

	P_TRIGGER	.hasami_roty,OFF
	P_TRIGGER	.hasami_c3_anim,OFF

	P_REMOVE	3
	P_REMOVE	2
	P_REMOVE	1

	P_REMOVE

.hasami_c3_anim
	P_BECOMECHILD	3
	P_ADDANIM	1,8
	P_UNBECOME
	P_RETURN
;-------------
.kep_run
	P_DO		10
	 P_ADD		worldy,10
	P_NEXT

	P_SET		pbyte2,16	;add	roty,16
	P_SET		pbyte1,1
	P_DO		3
	 P_DO		9
	  P_BECOMECHILD	pbyte1
	   P_ADD		childy,10
	  P_UNBECOME
	 P_NEXT
	 P_INC		pbyte1
	P_NEXT

	P_RETURN
;-------------
.hasami_wave
	P_ADD		rotx,pword1
	P_EXPORT	gword1,pword1
	P_ZERO		ap
	P_DO		3
	 P_INC		ap
	 P_BECOMECHILD	ap
	  P_GADD	childrotx,gword1
	 P_UNBECOME
	P_INEXT
	P_SET		ap,4
	P_IFNOTBETWEEN	-17,rotx,16,.hasa_pw1_neg
	P_IFNOTBETWEEN	-13,rotx,12,.nos
	P_IFNOTZERO	childrotz,.nos
	P_SOUNDEFTDISTPOS	ob_bun		;$98
	P_SET		childrotz,1
.nos
	P_RETURN
.hasa_pw1_neg
	P_NEG		pword1
	P_ZERO		childrotz
	P_RETURN
;-------------

	START_PATH	e_worm_c

	P_ENEMYDMGSE	en_cry_2
	P_CLIPPING	ON
	P_IFSAME	pbyte1,1,.make_c_2
	P_IFSAME	pbyte1,2,.make_c_3
	P_IFSAME	pbyte1,3,.make_c_4
	P_REMOVE

.make_c_2
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,0,0,0,0,0,hasami_2,e_worm_c,100,4,2
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_SET		pbyte1,2
	P_INVISIBLE	ON
	P_UNBECOME
	P_IGOTO		.worm_c_same
.make_c_3
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,0,0,0,0,0,hasami_1,e_worm_c,100,4,3
	P_BECOME
	P_INVISIBLE	ON
	P_IMPORT	skidy,gbyte1
	P_SET		pbyte1,3
	P_SETANIM	0
	P_UNBECOME
	P_IGOTO		.worm_c_same
.make_c_4
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,-200,0,64,0,64,on_d,e_sw_worm,100,1,4
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_INVISIBLE	ON
	P_CLIPPING	ON
	P_UNBECOME
.worm_c_same
	P_IFNOTZERO	pbyte2,.worm_c_act
	P_GOTO		.worm_c_same
.worm_c_act
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_RTRIGGER	.worm_c_hit,WhenHitByPlayer
	P_TRIGGER	self_invincible,Always
.lp
	P_IFBETWEEN	-1000,worldy,0,.out
	P_COLLISIONS	OFF
	P_GOTO		.lp
.out
	P_COLLISIONS	ON
	P_GOTO		.lp
.worm_c_hit
	P_BECOMEMOTHER
	P_INC		childrotx
	P_UNBECOME
	P_RETURN 
;-----------
	START_PATH	e_sw_worm

	P_CLRTYPE	enemy1
	P_SETCOLANIM	2
	P_SETANIM	0
	P_WAIT		3
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_SHADOW	OFF
;;;;;	P_TRIGGER	marker_set,Always
.lp
	P_IFFLAG	.on
	P_GOTO		.lp
.on
	P_TRIGGER	marker_set2,Always
	P_CLIPPING	OFF
	P_ZERO		rotz
;;;;;	P_TRIGGER	marker_set,OFF
	P_IGOTO		pe_sw_base_sw_drop.enter
;;;
;;;	START_PATH	e_keep_worm
;;;
;;;	P_TRIGGER	shadow_ck,Always
;;;	P_TRIGGER	self_invincible,Always
;;;	P_RADAROBJ	ra_enemy
;;;	P_CLIPPING	ON
;;;	P_COLLISIONS	OFF
;;;kep_w_hp = 20
;;;	P_SET		slopenum,kep_w_hp
;;;	P_GOSUB		set_child_xz
;;;.kep_restart
;;;	P_SET		worldy,250
;;;.kep_restart_wait
;;;	P_WITHINRADIUS	2500,.work_start
;;;	P_GOTO		.kep_restart_wait
;;;.work_start
;;;	P_RADAROBJ	ra_enemy
;;;	P_SET		worldx,childx
;;;	P_SET		worldz,childz
;;;	P_GOSUB		set_hp100_ap4
;;;	P_ZERO		childrotx
;;;	P_SET		worldy,2250
;;;	P_ZERO		rotx
;;;	P_SETRANDOM	roty
;;;	P_SET		childroty,roty
;;;	P_ADD		childroty,128
;;;	P_SETVEL	30
;;;	P_DO		40			;worldy=250 made agaru
;;;	P_ADD		worldy,-50
;;;	P_NEXT
;;;	P_SETVEL	0
;;;	P_SPAWN		0,0,0,0,0,0,hasami_2,e_worm_c,100,4,1
;;;	P_BECOME
;;;	P_INVISIBLE	ON
;;;	P_SET		pbyte1,1
;;;	P_UNBECOME
;;;.wait_finish_make_c
;;;	P_WAIT		1
;;;	P_CHILDDEAD	5,.wait_finish_make_c
;;;	P_SET		pbyte2,1
;;;	P_DO		3
;;;	P_BECOMECHILD	pbyte2
;;;	P_SET		pbyte2,1
;;;	P_UNBECOME
;;;	P_INC		pbyte2
;;;	P_INEXT
;;;	P_RADAROBJ	ra_off
;;;	P_TRIGGER	hasami_smoke,2
;;;	P_WAIT		3
;;;	P_BECOMECHILD	5
;;;	P_SET		pword1,1
;;;	P_SET		pbyte1,70
;;;	P_UNBECOME
;;;	P_WAIT		50
;;;	P_SET		pbyte2,16		;add roty,16
;;;	P_TRIGGER	.hasami_roty,Always     ;always
;;;	P_DO		15
;;;	P_ADD		worldy,-10
;;;	P_NEXT
;;;
;;;	P_SET		pword1,3
;;;	P_TRIGGER	.hasami_wave,Always
;;;
;;;	P_SET		pbyte1,3
;;;	P_DO		3
;;;	 P_DO		9
;;;	  P_BECOMECHILD	pbyte1
;;;	   P_ADD		childy,-10
;;;	  P_UNBECOME
;;;	 P_NEXT
;;;	 P_DEC		pbyte1
;;;	P_NEXT
;;;
;;;	P_DO		10
;;;	 P_ADD		worldy,-10
;;;	P_NEXT
;;;
;;;	P_SET		pbyte2,2
;;;	P_TRIGGER	hasami_smoke,OFF
;;;
;;;	P_TRIGGER	.kep_worm_hit,WhenHitByPlayer
;;;	P_TRIGGER	.kep_worm_live,Always
;;;
;;;	P_WAIT		50
;;;
;;;	P_TRIGGER	.kep_worm_hit,OFF
;;;	P_TRIGGER	.kep_worm_live,OFF
;;;
;;;
;;;	P_TRIGGER	hasami_smoke,2
;;;
;;;	P_REMOVE	5
;;;
;;;	P_WAIT		15
;;;
;;;	P_GOSUB		.kep_run
;;;
;;;	P_TRIGGER	.hasami_wave,OFF
;;;
;;;	P_DO		15
;;;	 P_ADD		worldy,10
;;;	P_NEXT
;;;
;;;	P_WAIT		15
;;;
;;;	P_TRIGGER	hasami_smoke,OFF
;;;
;;;	P_TRIGGER	.hasami_roty,OFF
;;;
;;;	P_REMOVE	4
;;;	P_REMOVE	3
;;;	P_REMOVE	2
;;;	P_REMOVE	1
;;;
;;;	P_RADAROBJ	ra_enemy
;;;
;;;.rem_c_wait
;;;	P_CHILDDEAD	1,.fin_rem_c
;;;	P_GOTO		.rem_c_wait
;;;	
;;;.fin_rem_c
;;;	P_SET		roty,childroty
;;;	P_ZERO		rotx
;;;	P_SETVEL	30
;;;	P_DO		40
;;;	P_ADD		worldy,50
;;;	P_NEXT
;;;	P_SETVEL	0
;;;	P_GOTO		.kep_restart
;;;
;;;;-------------
;;;.kep_worm_hit
;;;	P_IFNOTZERO	childrotx,.hit_c
;;;	P_DEC		slopenum
;;;	P_IGOTO		.life_ck
;;;.hit_c
;;;	P_RETURN
;;;.kep_worm_live
;;;	P_IFZERO	childrotx,.life_ck
;;;	P_DEC		slopenum
;;;	P_ZERO		childrotx
;;;.life_ck
;;;	P_IFLARGER	slopenum,ap,.life_ok
;;;	P_FORCE		.kep_w_dead
;;;.life_ok
;;;	P_RETURN
;;;.kep_w_dead
;;;	P_TRIGGER	.kep_worm_hit,OFF
;;;	P_TRIGGER	.kep_worm_live,OFF
;;;
;;;	P_SCORE		sc_worm
;;;
;;;	IFEQ		keep_worm_demo_cut
;;;
;;;	P_EXPORT	gword2,worldx
;;;	P_EXPORT	gword3,worldz
;;;
;;;	P_BECOMECHILD	5
;;;	P_EXPORT	gword1,worldy
;;;	P_IMPORT	pword1,gword2
;;;	P_NEG		pword1
;;;	P_ADD		pword1,worldx
;;;	P_EXPORT	gword2,pword1
;;;	P_IMPORT	pword1,gword3
;;;	P_NEG		pword1
;;;	P_ADD		pword1,worldz
;;;	P_EXPORT	gword3,pword1
;;;	P_UNBECOME
;;;
;;;	P_QSPAWN	demo_target,e_r_demo_target,100,0
;;;	P_BECOME
;;;	P_GADD		worldx,gword2
;;;	P_GADD		worldz,gword3
;;;	P_IMPORT	pword1,gword1
;;;	P_DIV2		pword1
;;;	P_DIV2		pword1
;;;	P_SET		worldy,pword1
;;;	P_UNBECOME
;;;	P_GOSUB		make_demo_worm
;;;	P_BECOME
;;;	P_SET		pword1,-160
;;;	P_SET		ty,15
;;;	P_SET		tx,25
;;;	P_SET		slopenum,de_for_robot
;;;	P_UNBECOME
;;;
;;;	ENDC
;;;
;;;	P_REMOVE	5
;;;	P_FLAGCHILD	4
;;;	P_UNLINKCHILD	4
;;;
;;;	P_TRIGGER	.hasami_c3_anim,Always
;;;
;;;	P_TRIGGER	hasami_smoke,2
;;;
;;;	P_GOSUB		.kep_run
;;;
;;;	P_TRIGGER	.hasami_wave,OFF
;;;
;;;	P_DO		15
;;;	 P_ADD		worldy,10
;;;	P_NEXT
;;;
;;;	P_TRIGGER	hasami_smoke,OFF
;;;
;;;	P_TRIGGER	.hasami_roty,OFF
;;;	P_TRIGGER	.hasami_c3_anim,OFF
;;;
;;;	P_REMOVE	3
;;;	P_REMOVE	2
;;;	P_REMOVE	1
;;;
;;;	P_REMOVE
;;;.hasami_c3_anim
;;;	P_BECOMECHILD	3
;;;	P_ADDANIM	1,8
;;;	P_UNBECOME
;;;	P_RETURN
;;;;-------------
;;;.kep_run
;;;	P_DO		10
;;;	 P_ADD		worldy,10
;;;	P_NEXT
;;;
;;;	P_SET		pbyte2,16	;add	roty,16
;;;	P_SET		pbyte1,1
;;;	P_DO		3
;;;	 P_DO		9
;;;	  P_BECOMECHILD	pbyte1
;;;	   P_ADD		childy,10
;;;	  P_UNBECOME
;;;	 P_NEXT
;;;	 P_INC		pbyte1
;;;	P_NEXT
;;;
;;;	P_RETURN
;;;;-------------
;;;.hasami_wave
;;;	P_ADD		rotx,pword1
;;;	P_EXPORT	gword1,pword1
;;;	P_ZERO		ap
;;;	P_DO		3
;;;	 P_INC		ap
;;;	 P_BECOMECHILD	ap
;;;	  P_GADD	childrotx,gword1
;;;	 P_UNBECOME
;;;	P_INEXT
;;;	P_SET		ap,4
;;;	P_IFNOTBETWEEN	-17,rotx,16,.hasa_pw1_neg
;;;	P_IFNOTBETWEEN	-13,rotx,12,.nos
;;;	P_IFNOTZERO	childrotz,.nos
;;;	P_SOUNDEFTDISTPOS	ob_bun		;$98
;;;	P_SET		childrotz,1
;;;.nos
;;;	P_RETURN
;;;.hasa_pw1_neg
;;;	P_NEG		pword1
;;;	P_ZERO		childrotz
;;;	P_RETURN
;;;;-------------
;;;.hasami_roty
;;;	P_ADD		roty,pbyte2
;;;	P_RETURN
;;;
;;;;-------------
;;;	START_PATH	e_worm_c
;;;
;;;	P_CLIPPING	ON
;;;	P_IFSAME	pbyte1,1,.make_c_2
;;;	P_IFSAME	pbyte1,2,.make_c_3
;;;	P_IFSAME	pbyte1,3,.make_c_4
;;;	P_REMOVE
;;;
;;;.make_c_2
;;;	P_SPAWN		0,0,0,0,0,0,hasami_2,e_worm_c,100,4,2
;;;	P_BECOME
;;;	P_SET		pbyte1,2
;;;	P_INVISIBLE	ON
;;;	P_UNBECOME
;;;	P_IGOTO		.worm_c_same
;;;.make_c_3
;;;	P_SPAWN		0,0,0,0,0,0,hasami_1,e_worm_c,100,4,3
;;;	P_BECOME
;;;	P_INVISIBLE	ON
;;;	P_SET		pbyte1,3
;;;	P_SETANIM	0
;;;	P_UNBECOME
;;;	P_IGOTO		.worm_c_same
;;;.make_c_4
;;;	P_SPAWN		0,-100,0,0,0,0,d_robo,e_keep_robo,100,1,4
;;;	P_BECOME
;;;	P_INVISIBLE	ON
;;;	P_SET		slopenum,4
;;;	P_CLIPPING	ON
;;;	P_UNBECOME
;;;.worm_c_same
;;;	P_IFNOTZERO	pbyte2,.worm_c_act
;;;	P_GOTO		.worm_c_same
;;;.worm_c_act
;;;	P_INVISIBLE	OFF
;;;	P_TRIGGER	.worm_c_hit,WhenHitByPlayer
;;;	P_TRIGGER	self_invincible,Always
;;;	P_END
;;;.worm_c_hit
;;;	P_BECOMEMOTHER
;;;	P_INC		childrotx
;;;	P_UNBECOME
;;;	P_RETURN 
;;;
;;;;------------	
;;;	START_PATH	e_keep_ori
;;;
;;;	P_ADD		worldx,300
;;;	P_QSPAWN	on_d,e_ori_sw,100,4
;;;	P_ADD		worldx,-300
;;;	P_STAMPSTART
;;;ori_hp = 9
;;;	P_GOSUB		init_hardslope_soff
;;;	P_RADAROBJ	ra_enemy
;;;	P_CLIPPING	ON
;;;	P_ACTIVE	ON
;;;	P_SET		ty,ori_hp
;;;
;;;	P_SET		worldy,220
;;;
;;;	P_TRIGGER	.kep_ori_on,WhenFlagged
;;;
;;;	P_END
;;;.kep_ori_on
;;;	P_FORCE		.kep_ori_look
;;;	P_RETURN
;;;.kep_ori_look
;;;	P_TRIGGER	.kep_ori_on,OFF
;;;	P_SOUNDEFFECT	ob_movewall_SL	;$a1
;;;	P_CLEARSTACK
;;;
;;;	P_WAIT		1
;;;
;;;	P_DO		4			;8
;;;	P_ADD		worldy,-20		;-10
;;;	P_NEXT
;;;
;;;	P_SOUNDEFTDISTPOS	ob_movewall_SL	;$a1
;;;
;;;	P_RADAROBJ	ra_off
;;;
;;;	P_GOSUB		.mk_child
;;;
;;;	P_WAIT		1
;;;	P_SHADOW	ON
;;;	P_ZERO		pbyte1
;;;	P_DO		9
;;;	P_AUTOINDEX	B,worldy,yane_tab,pbyte1,10
;;;	P_NEXT
;;;
;;;	P_STAMPSTART
;;;
;;;	P_IFNOTZERO	pbyte1,.not_stamp
;;;	P_GOSUB		init_hardslope_soff
;;;	P_SET		ty,ori_hp
;;;	P_GOSUB		.mk_child
;;;	P_ZERO		worldy
;;;.not_stamp
;;;	P_TRIGGER	.ori_hit,WhenHitByPlayer
;;;	P_TRIGGER	.ori_recov,Always
;;;	P_INVINCIBLE	OFF
;;;
;;;	P_END
;;;.ori_recov
;;;	P_SET		hp,100
;;;	P_RETURN
;;;.ori_hit
;;;	P_ZERO		tx
;;;	P_DO		6
;;;	P_INC		tx
;;;	P_BECOMECHILD	tx
;;;	P_HITFLASHTRIG
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_HITFLASHTRIG
;;;	P_DEC		ty
;;;	P_IFLARGER	ty,ap,.ori_ok
;;;	P_FORCE		.ori_exp_on
;;;.ori_ok
;;;	P_RETURN
;;;.ori_exp_on
;;;	P_TRIGGER	.ori_recov,OFF
;;;	P_TRIGGER	.ori_hit,OFF
;;;
;;;	IFEQ		keep_ori_demo_cut
;;;
;;;	P_ADD		worldy,-160
;;;	P_GOSUB		make_demo_target
;;;	P_ADD		worldy,160
;;;	P_BECOME
;;;	P_SET		pword1,-150
;;;	P_SET		slopenum,de_for_ori
;;;	P_SET		ty,5
;;;	P_SET		tx,18
;;;	P_UNBECOME
;;;
;;;	P_GOSUB		demo_move_wait
;;;
;;;	ENDC
;;;
;;;	P_REMOVE	4	
;;;	P_REMOVE	6
;;;	P_FLAGCHILD	1
;;;	P_FLAGCHILD	2
;;;	P_FLAGCHILD	3
;;;	P_FLAGCHILD	5
;;;	P_UNLINKCHILD	1
;;;	P_UNLINKCHILD	2
;;;	P_UNLINKCHILD	3
;;;	P_UNLINKCHILD	5
;;;
;;;	P_SPAWN		0,-190,0,0,0,0,nullshape,e_sp_random_exp_maker,100,0,7
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;	P_WAIT		5
;;;
;;;	P_ADD		worldy,-160
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,20
;;;	P_ADD		worldy,160
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;	P_WAIT		4
;;;
;;;	P_SET		pbyte1,2
;;;	P_DO		13
;;;	P_AUTOINDEX	B,worldy,jumptab,pbyte1,20
;;;	P_ADD		roty,16
;;;	P_NEXT
;;;	P_SCORE		sc_ori_dead
;;;
;;;	P_ADD		worldy,-160
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay_apsize,100,20
;;;	P_ADD		worldy,160
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;	P_START65816
;;;	s_set_alsflag	x,dontexplode
;;;	P_END65816
;;;	P_EXPLODE
;;;
;;;.mk_child
;;;	P_SPAWN		-45,-2,0,0,0,0,arch_2_1_l,e_ori_kabe,100,1,1
;;;	P_SPAWN		 45,-2,0,0,0,0,arch_2_1_r,e_ori_kabe,100,2,2
;;;	P_SPAWN		 0,-2,0,0,0,0,d_robo_ori,e_keep_robo,100,4,3
;;;	P_BECOME
;;;	P_SET		slopenum,2
;;;	P_UNBECOME
;;;	P_SPAWN		 0,-2,-40,0,0,0,arch_2_2,e_ori_kabe,100,3,5
;;;	P_SPAWN		 0,-2,40,0,0,0,arch_2_3,e_ori_kabe,100,0,6
;;;	P_ZERO		pbyte1
;;;	P_DO		6
;;;	P_INC		pbyte1
;;;	P_BECOMECHILD	pbyte1
;;;	P_ACTIVE	ON
;;;	P_CLIPPING	ON
;;;	P_UNBECOME
;;;	P_INEXT
;;;	P_RETURN
;;;yane_tab
;;;	db	-10,-20,-20,-20,-20,-20,-16,-10,-4
;;;;-----------
;;;	START_PATH	e_ori_kabe
;;;
;;;	P_COLLISIONS	OFF
;;;	P_SET		pbyte1,ap
;;;	P_SET		ap,1
;;;	P_TRIGGER	.kabe_ani,Always
;;;	P_TRIGGER	.kabe_down,WhenFlagged
;;;	P_END
;;;.kabe_ani
;;;	P_INC		tx
;;;	P_INC		ty
;;;	P_RETURN
;;;.kabe_down
;;;	P_FORCE		.kabe_on
;;;.pass_live
;;;	P_RETURN
;;;.kabe_on
;;;	P_TRIGGER	.kabe_ani,OFF
;;;	P_TRIGGER	.kabe_down,OFF
;;;	P_WAIT		10
;;;	P_SET		tx,64
;;;	P_SET		ty,10
;;;	P_IFSAME	pbyte1,1,.ori_l_down
;;;	P_IFSAME	pbyte1,2,.ori_r_down
;;;	P_IGOTO		.ori_b_down
;;;.ori_r_down
;;;	P_SET		pbyte1,-1
;;;	P_ADD		ty,5
;;;	P_NEG		tx
;;;.ori_l_down
;;;	P_DEC		worldy
;;;	P_ADD		pbyte2,pbyte1
;;;	P_ADD		rotz,pbyte2
;;;	P_IFNOTBETWEEN	-65,rotz,65,.ori_l_taore_end
;;;	P_GOTO		.ori_l_down
;;;.ori_l_taore_end
;;;	P_SET		rotz,tx
;;;	P_SET		worldy,-5
;;;	P_DO		ty
;;;	P_NEXT
;;;.ori_b_taore_end
;;;	P_SPAWN		0,-35,0,0,0,0,explosion5,e_sp_explosion_stay,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_WAIT		3
;;;	P_EXPLODE
;;;
;;;.ori_b_down
;;;	P_DEC		pbyte2
;;;	P_ADD		rotx,pbyte2
;;;	P_IFBETWEEN	-65,rotx,1,.ori_b_taore_cont
;;;	P_SET		rotx,-64
;;;	P_SET		worldy,-5
;;;	P_IGOTO		.ori_b_taore_end
;;;.ori_b_taore_cont
;;;	P_GOTO		.ori_b_down
;;;;-----------------
;;;	START_PATH	e_ori_sw
;;;
;;;	P_BECOMEINERT
;;;
;;;	P_GOSUB		init_hardslope_soff
;;;	P_SETANIM	0
;;;	P_SETCOLANIM	0
;;;	P_SET		slopenum,1
;;;	P_TRIGGER	.ori_stepped,WhenSteppedOn
;;;
;;;	P_END
;;;
;;;.ori_stepped
;;;	P_DISTMORE	100,.ori_not_cen
;;;	P_FORCE		.ori_steped_anim
;;;.ori_not_cen
;;;	P_RETURN
;;;.ori_steped_anim
;;;	P_TRIGGER	.ori_stepped,OFF
;;;	P_SLOPE		OFF
;;;	P_WAIT		1
;;;	P_CLEARSTACK
;;;	P_QSPAWN	nullshape,e_ori_sw_cam,100,0
;;;	P_ACTIVE	ON
;;;	P_SOUNDEFFECT	ob_switchon	;$34
;;;	P_DO		7
;;;	P_ADDANIM	1,8
;;;	P_NEXT
;;;
;;;	P_FINDSHAPE	arch_2_0
;;;
;;;	P_FLAGSHAPE
;;;
;;;	P_STAMPSTART
;;;
;;;	P_SET		shape,OFF_d
;;;	P_SETANIM	7
;;;	P_SETCOLANIM	1
;;;	P_GOSUB		init_hardslope_soff
;;;	P_END
;;;;-----------------
;;;	START_PATH	e_ori_sw_cam
;;;
;;;	P_INVISIBLE	ON
;;;
;;;	P_ADD		worldx,200
;;;	P_ADD		worldy,-100
;;;
;;;	P_ADD		roty,128		;ori no switch on no camera angle
;;;
;;;	P_BEGINDEMO
;;;
;;;	P_DO		25		;50
;;;
;;;	P_SETCAMERA
;;;	P_SETCAMERA
;;;
;;;	P_NEXT
;;;
;;;	P_ENDDEMO
;;;
;;;	P_REMOVE
;;;
;;;;------------
	START_PATH	e_sw_base_bird
tori_hp = 10
	P_SET		skidy,hp
	P_ADD		worldx,1111
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_end
	P_GOSUB		wakidashi_init
;	P_RANGECHECK	ON
	P_ENEMYDMGSE	en_cry_2
	P_RADAROBJ	ra_enemy
	P_GOSUB		.tori_mk_child
	P_SPACESHIP	ON
	P_ALWAYSGENVECS	ON
	P_SETANIM	0
	P_SET		childrotx,tori_hp
	
	P_TRIGGER	radar_change,8
	P_RTRIGGER	.k_tori_anim,Always
	P_RTRIGGER	.k_tori_deadck,WhenHitByPlayer
	P_TRIGGER	marker_set,Always

	P_SETVEL	30

	P_SET		rotz,4

	P_END
.k_tori_deadck
	P_DEC		childrotx
	P_IFLARGER	childrotx,ap,.tori_ok
	P_FORCE		.tori_down
.tori_ok
	P_RETURN
.tori_down
	P_TRIGGER	marker_set,OFF
	P_TRIGGER	radar_change,OFF
	P_RADAROBJ	ra_enemy
	P_TRIGGER	.k_tori_anim,OFF
	P_TRIGGER	.k_tori_deadck,OFF
	P_SETVEL	0
	P_SPACESHIP	OFF
	P_COLLISIONS	OFF
	P_RTRIGGER	.tori_down_anim,Always
	P_ZERO		rotz

	P_WAIT		3

	P_SOUNDEFFECT	en_cry1_s	;$79

	P_ZERO		pbyte1
	P_DO		20
	P_AUTOINDEX	B,worldy,jumptab,pbyte1,20
	P_NEXT

	P_SET		pbyte2,100

	P_FLAGCHILD	1
	P_UNLINKCHILD	1
.down_loop
	P_WAIT		1
	P_HITGROUND	80,.on_land
	P_CHASE		rotx,20
	P_ADD		worldy,pbyte2
	P_IGOTO		.down_loop
.on_land
	P_TRIGGER	.tori_down_anim,OFF
	P_RTRIGGER	.tori_down_anim2,Always
	P_SOUNDEFFECT	en_bird_bound	;$8c
	P_SET		worldy,-96
	P_SET		rotx,20
	P_SET		rotz,-32

	P_WAIT		20

	P_DO		10
	P_CHASE		rotx,0
	P_CHASE		rotz,0
	P_NEXT

	P_TRIGGER	.tori_down_anim2,OFF
	P_SETANIM	0
	P_ZERO		pbyte1
	P_RTRIGGER	.tori_run_anim,Always

	P_ACCEL		40,2

	P_DO		16
	P_CHASE		rotx,-32
	P_NEXT

	P_DO		50
	P_WITHINRADIUS	2000,.in_range
	P_BREAK		.out_range
.in_range	
	P_NEXT

.out_range
	P_START65816
	s_set_alsflag	x,dontexplode
	P_END65816
	P_EXPLODE

.tori_run_anim
	P_INC		pbyte1
	P_ADDANIM	4,14
	P_IFNOTSAME	pbyte1,5,.nos
	P_SOUNDEFTDISTPOS	en_feather_L	;$97
	P_ZERO		pbyte1
.nos
	P_RETURN

.tori_down_anim
	P_ADD		rotz,16
.tori_down_anim2
	P_RANDOMGOTO	.pass
	P_ADDANIM	4,16
.pass
	P_RETURN

.tori_mk_child
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,100,40,0,0,0,on_d,e_sw_worm,100,4,1
	P_BECOME
	P_INVISIBLE	ON
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_RETURN

.k_tori_anim
	P_SET		hp,100
	P_SET		rotz,4
	P_SETVEL	30
	P_IFZERO	pbyte1,.k_tori_slow
	P_IFSAME	pbyte1,1,.k_tori_stop
	P_ADDANIM	2,16
	P_AUTOINDEX	B,worldy,k_tori_tab1,pbyte2,9
	P_IFNOTSAME	pbyte2,3,.nos2
	P_SOUNDEFTDISTPOS	en_feather_L	;$82
.nos2
	P_IFNOTSAME	pbyte1,6,.k_tori_cont1_0
	P_ZERO		pbyte1
	P_ZERO		pbyte2
	P_ZERO		ty
	P_RETURN
.k_tori_cont1_0
	P_IFNOTSAME	pbyte2,8,.k_tori_cont1
	P_INC		pbyte1
	P_ZERO		pbyte2
.k_tori_cont1
	P_RETURN
.k_tori_stop
	P_ADD		worldy,4
	P_INC		pbyte2
	P_IFNOTSAME	pbyte2,35,.no_sound
	P_SOUNDEFTDISTPOS	en_bird_cry	;$60
.no_sound
	P_IFNOTSAME	pbyte2,40,.k_tori_cont2
	P_ZERO		pbyte2
	P_INC		pbyte1
	P_SETANIM	0
.k_tori_cont2
	P_RETURN
.k_tori_slow
	P_ADDANIM	1,16
	P_AUTOINDEX	B,worldy,k_tori_s_tab,ty,16
	P_IFNOTSAME	ty,8,.nosss
	P_SOUNDEFTDISTPOS	en_feather_L	;$82
.nosss
	P_IFNOTSAME	ty,16,.k_tori_slow_cont
	P_ZERO		ty
.k_tori_slow_cont
	P_INC		pbyte2
	P_IFNOTSAME	pbyte2,64,.k_tori_cont3
	P_ZERO		pbyte2
	P_INC		pbyte1
.k_tori_cont3
	P_RETURN
.already_end	LOCAL
	P_SET		shape,off_d
	P_SETANIM	7
	P_SETCOLANIM	3
	P_GOSUB		init_hardslope_soff
	P_ZERO		worldy
	P_END

;k_tori_tab1
;	db	0,0,0,-8,-8,-8,-8,-8
;k_tori_s_tab
;	db	4,4,4,4,-4,-4,-4,-4
;	db	-4,-4,-4,-4,4,4,4,4

;;;
;;;	START_PATH	e_keep_bird
;;;
;;;tori_hp = 10
;;;	P_GOSUB		set_hp100_ap4
;;;	P_ADD		worldx,1111
;;;	P_GOSUB		.tori_mk_child
;;;	P_SPACESHIP	ON
;;;	P_ALWAYSGENVECS	ON
;;;	P_SETANIM	0
;;;	P_SET		childrotx,tori_hp
;;;	
;;;	P_TRIGGER	.k_tori_anim,Always
;;;	P_TRIGGER	.k_tori_deadck,WhenHitByPlayer
;;;
;;;	P_SETVEL	30
;;;
;;;	P_SET		rotz,4
;;;
;;;	P_END
;;;.k_tori_deadck
;;;	P_DEC		childrotx
;;;	P_IFLARGER	childrotx,ap,.tori_ok
;;;	P_FORCE		.tori_down
;;;.tori_ok
;;;	P_RETURN
;;;.tori_down
;;;	P_TRIGGER	.k_tori_anim,OFF
;;;	P_TRIGGER	.k_tori_deadck,OFF
;;;	P_SCORE		sc_k_tori
;;;	P_SETVEL	0
;;;	P_SPACESHIP	OFF
;;;	P_COLLISIONS	OFF
;;;	P_TRIGGER	.tori_down_anim,Always
;;;	P_ZERO		rotz
;;;
;;;	IFEQ		keep_bird_demo_cut
;;;
;;;	P_EXPORT	gword1,worldy
;;;
;;;	P_QSPAWN	demo_target,e_r_demo_target,100,0
;;;	P_BECOME
;;;	P_IMPORT	pword1,gword1
;;;	P_DIV2		pword1
;;;	P_SET		worldy,pword1
;;;	P_UNBECOME
;;;
;;;	P_GOSUB		make_demo_worm
;;;
;;;	P_BECOME
;;;	P_SET		pword1,-160
;;;	P_SET		ty,25
;;;	P_SET		tx,25
;;;	P_SET		slopenum,de_for_robot
;;;	P_UNBECOME
;;;
;;;	ENDC
;;;
;;;	P_REMOVE	2
;;;
;;;	P_WAIT		3
;;;
;;;	P_SOUNDEFFECT	en_cry1_s	;$79
;;;
;;;	P_ZERO		pbyte1
;;;	P_DO		20
;;;	P_AUTOINDEX	B,worldy,jumptab,pbyte1,20
;;;	P_NEXT
;;;
;;;	P_SET		pbyte2,100
;;;
;;;	P_FLAGCHILD	1
;;;	P_UNLINKCHILD	1
;;;.down_loop
;;;	P_WAIT		1
;;;	P_HITGROUND	80,.on_land
;;;	P_CHASE		rotx,20
;;;	P_ADD		worldy,pbyte2
;;;	P_IGOTO		.down_loop
;;;.on_land
;;;	P_TRIGGER	.tori_down_anim,OFF
;;;	P_TRIGGER	.tori_down_anim2,Always
;;;	P_SOUNDEFFECT	en_bird_bound	;$8c
;;;	P_SET		worldy,-96
;;;	P_SET		rotx,20
;;;	P_SET		rotz,-32
;;;
;;;	P_WAIT		20
;;;
;;;	P_DO		10
;;;	P_CHASE		rotx,0
;;;	P_CHASE		rotz,0
;;;	P_NEXT
;;;
;;;	P_TRIGGER	.tori_down_anim2,OFF
;;;	P_SETANIM	0
;;;	P_ZERO		pbyte1
;;;	P_TRIGGER	.tori_run_anim,Always
;;;
;;;	P_ACCEL		40,2
;;;
;;;	P_DO		16
;;;	P_CHASE		rotx,-32
;;;	P_NEXT
;;;
;;;	P_DO		50
;;;	P_WITHINRADIUS	2000,.in_range
;;;	P_BREAK		.out_range
;;;.in_range	
;;;	P_NEXT
;;;
;;;.out_range
;;;	P_START65816
;;;	s_set_alsflag	x,dontexplode
;;;	P_END65816
;;;	P_EXPLODE
;;;
;;;.tori_run_anim
;;;	P_INC		pbyte1
;;;	P_ADDANIM	4,14
;;;	P_IFNOTSAME	pbyte1,5,.nos
;;;	P_SOUNDEFTDISTPOS	en_feather_L	;$97
;;;	P_ZERO		pbyte1
;;;.nos
;;;	P_RETURN
;;;
;;;.tori_down_anim
;;;	P_ADD		rotz,16
;;;.tori_down_anim2
;;;	P_RANDOMGOTO	.pass
;;;	P_ADDANIM	4,16
;;;.pass
;;;	P_RETURN
;;;
;;;.tori_mk_child
;;;	P_SPAWN		90,80,40,0,0,64,d_robo,e_keep_robo,10,10,1
;;;	P_BECOME
;;;	P_SET		slopenum,3
;;;	P_UNBECOME
;;;	P_RETURN
;;;
;;;.k_tori_anim
;;;	P_SET		hp,100
;;;	P_SET		rotz,4
;;;	P_SETVEL	30
;;;	P_IFZERO	pbyte1,.k_tori_slow
;;;	P_IFSAME	pbyte1,1,.k_tori_stop
;;;	P_ADDANIM	2,16
;;;	P_AUTOINDEX	B,worldy,k_tori_tab1,pbyte2,9
;;;	P_IFNOTSAME	pbyte2,3,.nos2
;;;	P_SOUNDEFTDISTPOS	en_feather_L	;$82
;;;.nos2
;;;	P_IFNOTSAME	pbyte1,6,.k_tori_cont1_0
;;;	P_ZERO		pbyte1
;;;	P_ZERO		pbyte2
;;;	P_ZERO		ty
;;;	P_RETURN
;;;.k_tori_cont1_0
;;;	P_IFNOTSAME	pbyte2,8,.k_tori_cont1
;;;	P_INC		pbyte1
;;;	P_ZERO		pbyte2
;;;.k_tori_cont1
;;;	P_RETURN
;;;.k_tori_stop
;;;	P_ADD		worldy,4
;;;	P_INC		pbyte2
;;;	P_IFNOTSAME	pbyte2,35,.no_sound
;;;	P_SOUNDEFTDISTPOS	en_bird_cry	;$60
;;;.no_sound
;;;	P_IFNOTSAME	pbyte2,40,.k_tori_cont2
;;;	P_ZERO		pbyte2
;;;	P_INC		pbyte1
;;;	P_SETANIM	0
;;;.k_tori_cont2
;;;	P_RETURN
;;;.k_tori_slow
;;;	P_ADDANIM	1,16
;;;	P_AUTOINDEX	B,worldy,k_tori_s_tab,ty,16
;;;	P_IFNOTSAME	ty,8,.nosss
;;;	P_SOUNDEFTDISTPOS	en_feather_L	;$82
;;;.nosss
;;;	P_IFNOTSAME	ty,16,.k_tori_slow_cont
;;;	P_ZERO		ty
;;;.k_tori_slow_cont
;;;	P_INC		pbyte2
;;;	P_IFNOTSAME	pbyte2,64,.k_tori_cont3
;;;	P_ZERO		pbyte2
;;;	P_INC		pbyte1
;;;.k_tori_cont3
;;;	P_RETURN
;;;
;;;k_tori_tab1
;;;	db	0,0,0,-8,-8,-8,-8,-8
;;;k_tori_s_tab
;;;	db	4,4,4,4,-4,-4,-4,-4
;;;	db	-4,-4,-4,-4,4,4,4,4
;;;
;;;;------------
;;;	START_PATH	e_keep_body
;;;
;;;	P_RANGECHECK	OFF
;;;	P_GOSUB		set_hp100_ap4
;;;	P_GOSUB		.body_mk_child
;;;	P_SET		pbyte2,85
;;;
;;;	P_TRIGGER	.body_hit,WhenHit
;;;	P_END
;;;.body_hit
;;;	P_BECOMECHILD	1
;;;	P_HITFLASHTRIG
;;;	P_UNBECOME
;;;	P_BECOMECHILD	3
;;;	P_HITFLASHTRIG
;;;	P_UNBECOME
;;;	P_IFLARGER	hp,pbyte2,.body_ok
;;;	P_FORCE		.body_dead
;;;.body_ok
;;;	P_RETURN
;;;.body_dead
;;;	P_TRIGGER	.body_hit,OFF
;;;	P_COLLISIONS	OFF
;;;	P_SHADOW	ON
;;;	P_REMOVE	4		;sp_help
;;;	P_REMOVE	2
;;;	P_FLAGCHILD	3
;;;	P_UNLINKCHILD	3
;;;
;;;	P_TRIGGER	mk_many_damy_exp,4
;;;
;;;	IFEQ		keep_body_demo_cut
;;;
;;;	P_EXPORT	gword1,worldy
;;;	P_GOSUB		make_demo_target
;;;	P_BECOME
;;;	P_SET		tx,25
;;;	P_SET		ty,15
;;;	P_IMPORT	pword1,gword1
;;;	P_SET		slopenum,de_for_robot
;;;	P_UNBECOME
;;;
;;;	P_GOSUB		demo_move_wait
;;;
;;;	ENDC
;;;
;;;	P_WAIT		20
;;;
;;;	P_FLAGCHILD	1
;;;	P_UNLINKCHILD	1
;;;
;;;	P_SET		ty,20
;;;	P_ZERO		pbyte2
;;;	P_GOSUB		.kep_bod_j
;;;
;;;	P_SET		pbyte1,100
;;;.hit_g
;;;	P_WAIT		1
;;;	P_HITGROUND	30,.jump_again
;;;	P_ADD		worldy,pbyte1
;;;	P_IGOTO		.hit_g
;;;.jump_again
;;;	P_SOUNDEFTPOS	ob_bunhard_end	;$a0
;;;	P_SET		worldy,-30
;;;	P_SET		pbyte2,5
;;;	P_SET		ty,10
;;;	P_GOSUB		.kep_bod_j
;;;
;;;	P_SET		shape,d_keep_1end
;;;	P_EXPLODE
;;;
;;;.kep_bod_j
;;;	P_DO		ty
;;;	P_ADD		worldx,-8
;;;	P_ADD		worldz,-8
;;;	P_ADD		roty,16
;;;	P_ADD		rotx,4
;;;	P_AUTOINDEX	B,worldy,jumptab,pbyte2,20
;;;	P_NEXT
;;;	P_RETURN
;;;
;;;.body_mk_child
;;;	P_SPAWN		0,160,120,0,0,0,d_keep_2,e_keep_pill,100,1,1
;;;	P_SPAWN		0,160,0,0,0,0,d_keep_0,e_nocol_s_off,100,1,2
;;;	P_SPAWN		0,160,0,0,0,0,d_robo,e_keep_robo,100,1,3
;;;	P_RETURN
;;;
;;;;-------------------
;;;	START_PATH	e_keep_pill
;;;
;;;	P_TRIGGER	.k_pil_go,WhenFlagged
;;;	P_ACTIVE	ON
;;;	P_COLLISIONS	OFF
;;;	P_INVINCIBLE	ON
;;;	P_END
;;;.k_pil_go
;;;	P_FORCE		.k_pil_exp
;;;	P_RETURN
;;;.k_pil_exp
;;;	P_TRIGGER	.k_pil_go,OFF
;;;	P_TRIGGER	.k_pil_mk_exp,4
;;;	P_QSPAWN	explosion5,e_sp_explosion_stay,100,15
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_SHADOW	ON
;;;	P_DO		20
;;;	P_ADD		worldx,8
;;;	P_ADD		worldz,8
;;;	P_ADD		roty,16
;;;	P_ADD		rotz,2
;;;	P_AUTOINDEX	B,worldy,jumptab,pbyte2,20
;;;	P_NEXT
;;;	P_TRIGGER	.k_pil_mk_exp,OFF
;;;	P_EXPLODE
;;;
;;;.k_pil_mk_exp
;;;	P_QSPAWN	explosion5,e_sp_randomsize_explosion,100,0
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_RETURN
;;;
;;;;-------------------
;;;	START_PATH	e_keep_robo
;;;
;;;	P_ACTIVE	ON
;;;	P_SET		hp,100
;;;	P_SHADOW	OFF
;;;	P_COLLISIONS	OFF
;;;	P_RADAROBJ	ra_enemy
;;;
;;;	P_SPAWN		0,-160,40,0,0,0,help,e_help_c,100,0,4
;;;	P_IFSAME	slopenum,1,.for_track
;;;	P_IFSAME	slopenum,2,.for_ori
;;;	P_IFSAME	slopenum,3,.for_tori
;;;	P_IFSAME	slopenum,4,.for_worm
;;;	P_BECOME
;;;	P_SET		childz,-80
;;;	P_UNBECOME
;;;	P_IGOTO		.same
;;;.for_worm
;;;	P_RADAROBJ	ra_off
;;;	P_BECOME
;;;	P_SETID		5
;;;	P_UNBECOME
;;;	P_WAIT		1
;;;	P_RADAROBJ	ra_enemy
;;;	P_WAIT		3
;;;	P_INVISIBLE	OFF
;;;	P_COLLISIONS	OFF
;;;	P_IGOTO		.same
;;;.for_tori
;;;	P_BECOME
;;;	P_SETID		2
;;;	P_SET		childx,40
;;;	P_UNBECOME
;;;	P_IGOTO		.same
;;;.for_ori
;;;	P_BECOME
;;;	P_SET		childz,80
;;;	P_UNBECOME
;;;	P_IGOTO		.same
;;;.for_track
;;;	P_BECOME
;;;	P_SET		childz,80
;;;	P_UNBECOME
;;;
;;;.same
;;;	P_SETANIM	2
;;;	P_TRIGGER	.kep_robo_anm,4
;;;	P_TRIGGER	.kep_robo_on,WhenFlagged
;;;	P_END
;;;.kep_robo_anm	LOCAL
;;;	P_RANDOMGOTO	.kep_robo_anm2
;;;	P_ADDANIM	8,16
;;;.kep_robo_anm2
;;;	P_RETURN
;;;
;;;.kep_robo_on
;;;	P_FORCE		.kep_robo_go
;;;	P_RETURN
;;;.kep_robo_go
;;;	P_TRIGGER	.kep_robo_anm,OFF
;;;	P_TRIGGER	.kep_robo_on,OFF
;;;	P_CLEARSTACK
;;;
;;;	IFNE		robo_quick
;;;	
;;;	P_CLRDEMOSHAPE
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCORE		sc_keep_robo
;;;
;;;	ENDC
;;;
;;;	P_SHADOW	ON
;;;	P_SETANIM	2
;;;	P_IFSAME	slopenum,1,.for_track2
;;;	P_IFSAME	slopenum,2,.for_ori2
;;;	P_IFSAME	slopenum,3,.for_tori2
;;;	P_IFSAME	slopenum,4,.for_tori2		;for_worm2
;;;	P_IGOTO		.slope_is_0
;;;.for_tori2
;;;	P_ZERO		pbyte1
;;;	P_DO		20
;;;	P_AUTOINDEX	B,worldy,jumptab,pbyte1,20
;;;	P_ADD		roty,12
;;;	P_NEXT
;;;	P_SET		pbyte2,100
;;;.robo_tori_loop
;;;	P_WAIT		1
;;;	P_HITGROUND	20,.robo_tori_land
;;;	P_ADD		worldy,pbyte2
;;;	P_ADD		roty,12
;;;	P_CHASE		rotx,-64
;;;	P_CHASE		rotz,0
;;;	P_IGOTO		.robo_tori_loop
;;;.robo_tori_land
;;;	P_SOUNDEFFECT	robot_bound	;$46
;;;	P_SET		worldy,-20
;;;	P_SET		pbyte1,4
;;;	P_DO		12
;;;	P_AUTOINDEX	B,worldy,jumptab,pbyte1,20
;;;	P_CHASE		roty,0
;;;	P_CHASE		rotz,0
;;;	P_CHASE		rotx,-64
;;;	P_NEXT
;;;
;;;	P_SOUNDEFFECT	robot_bound	;$46
;;;	P_ZERO		roty
;;;	P_ZERO		rotz
;;;	P_SET		rotx,-64
;;;
;;;	P_GOTO		.robo_stand_up
;;;.for_ori2
;;;	P_WAIT		15
;;;	P_IGOTO		.kep_robo_same
;;;.slope_is_0
;;;	P_WAIT		50
;;;.kep_robo_same	LOCAL
;;;
;;;	P_RADAROBJ	ra_off
;;;	P_DO		10
;;;	P_FACEPLAYER	y
;;;	P_NEXT
;;;
;;;	P_SOUNDEFFECT	Thanks
;;;	P_SPAWN		0,-150,80,0,0,0,thanks,e_thanks_sp,10,10,1
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;	P_DO		3
;;;	P_SET		pbyte2,5
;;;	P_DO		10
;;;	P_AUTOINDEX	B,worldy,jumptab,pbyte2,20
;;;	P_DEC		roty
;;;	P_NEXT
;;;	P_NEXT
;;;
;;;	IFEQ		robo_quick
;;;	P_CLRDEMOSHAPE
;;;	P_GDEC		b,KEnemyNumber
;;;	P_SCORE		sc_keep_robo
;;;	ENDC
;;;
;;;	P_REMOVE	1
;;;
;;;	P_SET		shape,d_robo_1
;;;	P_ALWAYSGENVECS	ON
;;;	P_SETANIM	0
;;;	P_ADD		worldy,-90
;;;
;;;	P_DO		9
;;;	P_ADDANIM	1,10
;;;	P_NEXT
;;;
;;;	P_SOUNDEFFECT	help_robot_trans	;$65
;;;	P_SOUND		p2_help_robot
;;;
;;;	P_ACCEL		30,1
;;;	P_SPACESHIP	ON
;;;	P_DO		26
;;;	P_CHASE		rotz,32
;;;	P_NEXT
;;;
;;;	P_DO		26
;;;	P_CHASE		rotz,0
;;;	P_IFSAME	rotx,-32,.pass_up
;;;	P_DEC		rotx
;;;.pass_up
;;;	P_NEXT
;;;
;;;	P_SPAWN		0,0,-50,0,0,0,boost,e_sp_boost,100,16,9
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;
;;;	P_SETVEL	50
;;;
;;;	P_WAIT		60
;;;	P_REMOVE
;;;
;;;	P_END
;;;
;;;.for_track2
;;;	P_ZERO		pbyte1
;;;	P_DO		20
;;;	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
;;;	P_NEXT
;;;.robo_landing_again
;;;	P_SET		pbyte2,50
;;;	P_HITGROUND	20,.robo_landing
;;;	P_WAIT		1
;;;	P_ADD		worldy,pbyte2
;;;	P_IGOTO		.robo_landing_again
;;;.robo_landing
;;;	P_SOUNDEFFECT	robot_bound	;$46
;;;	P_SET		worldy,-20
;;;	P_WAIT		1
;;;	P_SET		pbyte1,5
;;;	P_DO		10
;;;	P_ADDANIM	4,16
;;;	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
;;;	P_NEXT
;;;	P_SOUNDEFFECT	robot_bound	;$46
;;;.robo_stand_up
;;;	P_DO		10
;;;	P_ADDANIM	4,16
;;;	P_NEXT
;;;	P_SETANIM	11
;;;	P_DO		16
;;;	P_ADD		rotx,4
;;;	P_CHASE		worldy,0
;;;	P_NEXT
;;;	P_WAIT		1
;;;	P_ZERO		worldy
;;;	P_SETANIM	2
;;;	P_IGOTO		.kep_robo_same
;;;;---------------------
;;;	START_PATH	e_help_c
;;;
;;;	P_SPRITE	0,120
;;;.help_same	LOCAL
;;;	P_RANGECHECK	OFF
;;;	P_IFNOTZERO	skidy,.help_loop	;for_explain
;;;	P_CLIPPING	ON
;;;	P_SET		pword1,-50
;;;	P_TRIGGER	.help_ground,4		;Always
;;;	P_TRIGGER	.help_sound,64
;;;
;;;.help_loop
;;;	P_INVISIBLE	ON
;;;	P_DISTMORE	2000,.invis_wait
;;;	P_WAIT		8
;;;	P_INVISIBLE	OFF
;;;	P_COLLISIONS	OFF
;;;.invis_wait
;;;	P_WAIT		8
;;;	P_GOTO		.help_loop
;;;.help_sound
;;;	P_SOUNDEFTDISTPOS	Help
;;;	P_RETURN
;;;.help_ground
;;;	P_IFSMALLER	worldy,pword1,.pass
;;;	P_INVISIBLE	ON
;;;.pass
;;;	P_RETURN
;;;
;;;;--------------------------------------
;;;	START_PATH	e_thanks_sp
;;;
;;;	P_SPRITE	0,120
;;;	P_COLLISIONS	OFF
;;;	P_RANGECHECK	OFF
;;;	P_END
;;;
;;;;------------ TARGET EISEI SERIES
	START_PATH	e_flower_twin

	P_RADAROBJ	ra_sonota
	P_RANGECHECK	ON
	P_GOSUB		set_hp100_ap4
	P_SET		slopenum,89
	P_RTRIGGER	.open_ck,Always
	P_END
.open_ck
	P_IFLARGER	hp,slopenum,.live
	P_FORCE		.open_on
.live
	P_RETURN
.open_on
	P_TRIGGER	.open_ck,OFF
	P_COLLISIONS	OFF
	P_SET		shape,flower_1
	P_SOUNDEFTNEARPOS	en_floweropen	;$7d
	P_SETANIM	0
	P_WAIT		1
	P_DO		15
	P_ADDANIM	1,16
	P_NEXT
	P_ADD		worldy,-300
	P_QSPAWN	nullshape,e_kira_maker,40,5
	P_QSPAWN	item_ita,e_item_twinblaster,100,0
	P_SCORE		sc_found_item
.f_same
	P_ADD		worldy,300
	P_RADAROBJ	ra_off

	P_STAMPSTART

	P_SET		shape,flower_1
	P_SET		hp,100
	P_COLLISIONS	OFF
	P_SETANIM	15
	P_CLRTYPE	enemy1
	P_END
;------------
;;	START_PATH	e_final_kaijyo
;;	P_INC		skidy
;;	START_PATH	e_tojikome_kaijyo
;;
;;	P_GOSUB		hit_dead_init
;;
;;	P_IFNOTZERO	skidy,.nt
;;.wnt
;;	P_INVISIBLE	ON
;;	P_IMPORT	pbyte1,ebyte3
;;	P_IFSAME	pbyte1,-1,.nt
;;	P_GOTO		.wnt
;;
;;.nt
;;	P_INVISIBLE	OFF
;;	P_TRIGGER	hit_dead,WhenDead
;;	P_RTRIGGER	.kaijyo,WhenDead
;;	P_END
;;.kaijyo
;;	P_IFNOTZERO	skidy,.final
;;	P_GINC		b,ebyte3
;;	P_RETURN
;;.final
;;	P_GINC		b,ebyte2
;;	P_RETURN
	
;;;;-----------
;;;;-------------
;;;;-------------
;;;;------------- NEW SPEC NI YORU SENKAN
;;;;-------------
;;;;-------------
	START_PATH	e_from_carier_mother2

	P_INC		skidy

	START_PATH	e_from_carier_mother1

	P_GSET		b,eaction1,0
	P_INVISIBLE	ON
	P_RADAROBJ	ra_enemy
	P_SET		childrotx,4
.fag
	P_WAIT		1
	P_FINDSHAPE	d_sen_2
	P_SHAPEDEAD	.fag
	P_RTRIGGER	.copy_pos,Always
.lp
	P_IMPORT	pbyte1,ebyte6
	P_IFLARGER	pbyte1,childrotx,.pass_w
	P_IFSAME	skidy,1,.bou
.bata
	P_QSPAWN	batabata_space,e_from_carier_1,1,4
	P_GINC		b,ebyte6
	P_IGOTO		.pass
.bou
	P_DISTLESS	10000,.bata
	P_QSPAWN	bou_0,e_from_carier_bou,100,4
	P_GINC		b,ebyte6
.pass
	P_WAIT		25
	P_IFZERO	ap,.wait_rand
	P_DO		ap
	P_WAIT		1
	P_NEXT
	P_GOTO		.lp
.pass_w
	P_WAIT		80
	P_IGOTO		.pass
.wait_rand
	P_WAIT		10
	P_RANDOMGOTO	.lp
	P_GOTO		.wait_rand
.copy_pos
	P_FACEPLAYER	y
	P_BECOMESHAPE
	P_GOSUB		expo_world
;	P_EXPORT	gword1,worldx
;	P_EXPORT	gword2,worldy
;	P_EXPORT	gword3,worldz
	P_UNBECOME
	P_GOSUB		impo_world
;	P_IMPORT	worldx,gword1
;	P_IMPORT	worldy,gword2
;	P_IMPORT	worldz,gword3
	P_RETURN
;------------
	START_PATH	e_from_carier_bou

	P_RADAROBJ	ra_enemy
	P_QUADVECS	ON
	P_PASSSOUND	ON
	P_SETVEL	50
	P_INVINCIBLE	ON
	P_RTRIGGER	.bou_face,Always

	P_SETRANDOM	pbyte1,15
	P_ADD		pbyte1,-8

	P_WAIT		100

	P_GDEC		b,ebyte6
	P_EXPLODE
.bou_face
	P_IMPORT	pbyte2,eaction1
	P_IFZERO	pbyte2,.ok
	P_FORCE		.rem
.ok
	P_ADD		rotz,pbyte1
	P_RETURN
.rem
	P_TRIGGER	.bou_face,OFF
	P_REMOVE
;------------
	START_PATH	e_from_carier_1

	P_SET		childroty,roty
	P_GOSUB		wakidashi_init
	P_TRIGGER	from_carier_dead,WhenHit
	P_TRIGGER	from_carier_col,Always
	P_TRIGGER	anim_add_12,Always
;	P_SOUND		p2_zako_0

	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64
	P_ADD		roty,pbyte1

	P_SETRANDOM	rotx,63
	P_ADD		rotx,-32

	P_WEAPON	ELaser
	P_FACEPLAYER	y		;IMMEDIATE
	P_RELTOPLAYER	ON
	P_RANGECHECK	OFF
	P_QUADVECS	ON
.agst
	P_SETVEL	60

	P_WAIT		45

	P_WAITCHASE	rotx,0
	P_SETRANDOM	childrotx,15
	P_ZERO		childrotz
.lp
	P_DISTLESS	5000,.near
	P_FACEPLAYER	y
	P_GOTO		.lp
.near
	P_INC		childrotz
	P_IFSAME	childrotz,64,.fast
	P_IFNOTZERO	pbyte1,.tn
	P_INC		childrotx
	P_IFNOTSAME	childrotx,30,.pass_at
	P_GOSUB		sos_fire_must
	P_ZERO		childrotx
.pass_at
	P_FACEPLAYEROFS	0,0,127
	P_BEHINDPLAYER	.fast
.tn
	P_GOTO		.near
.fast
	P_SPACESHIP	ON
	P_SETRANDOM	rotz,15
	P_ADD		rotz,-8
	P_WAIT		5
	P_WAIT		20
	P_ZERO		childrotz
	P_GOTO		.near

from_carier_col

	P_IMPORT	pbyte1,eaction1
	P_IFZERO	pbyte1,.far
	P_COLLISIONS	OFF
	P_FORCE		.hazusu
.far
	P_RETURN
.hazusu
	P_TRIGGER	from_carier_col,OFF
	P_WAIT		30
	P_REMOVE
;------------
	START_PATH	e_space_carier

	P_TRIGGER	marker_set2,Always
	P_GOSUB		wakidashi_init
	P_RADAROBJ	ra_entrance
	P_INVINCIBLE	ON

	P_IMPORT	roty,Kinitroty

;	p_spawn	0,0,(120+25)<<d_sen_scale,0,0,0,d_sen_0,e_nocol_range_off,1,1,1
;	p_spawn	0,0,(033+25)<<d_sen_scale,0,0,0,d_sen_1,e_nocol_range_off,1,1,2
;	p_spawn	0,0,(-90+25)<<d_sen_scale,0,0,0,d_sen_3,e_nocol_range_off,1,1,3
;	p_spawn	0,-55<<d_sen_scale,(-40+25)<<d_sen_scale,0,0,0,d_sen_4,e_nocol_range_off,1,1,4

;!!!!!!!!!!!!>>>>
	p_set	shape,nullshape
	P_GOSUB	mk_big_senkan
;	p_spawn	0,0,-25<<d_sen_scale,0,0,0,d_sen_2,gd_d_sen_parts,1,1,1
;	p_spawn	0,0,((120)<<d_sens_scale),0,0,0,d_sen_0,gd_d_sen_parts,1,1,2
;	p_spawn	0,0,((033)<<d_sens_scale),0,0,0,d_sen_1,gd_d_sen_parts,1,3,3
;	p_spawn	0,0,((-90)<<d_sens_scale),0,0,0,d_sen_3,gd_d_sen_parts,1,6,4
;	p_spawn	0,-55<<d_sens_scale,((-40)<<d_sens_scale),0,0,0,d_sen_4,gd_d_sen_parts,1,2,5


	P_IMPORT	pbyte2,eaction2
	P_IFZERO	pbyte2,.no_cannon

	p_spawn	0,-15<<d_sens_scale,((120)<<d_sens_scale),0,0,0,d_sen_5,gd_d_sen_parts5,1,2,6
	p_spawn	0,-30<<d_sen_scale,170<<d_sen_scale,0,0,0,tamatamal,e_tametame,1,1,7
.no_cannon
;!!!!!!!!!!!!<<<<


.lp
	P_DISTLESS	6000,.on
	P_DISTLESS	15000,.beam
	P_GOTO		.lp
.beam
	P_IFNOTZERO	pbyte2,.tlp
	P_IFZERO	pbyte1,.fi
	P_DEC		pbyte1
.tlp
	P_GOTO		.lp
.fi
	P_QSPAWN	warp_laser,e_carier_beam,100,8
	P_SETRANDOM	pbyte1,31
	P_ADD		pbyte1,25
	P_GOTO		.lp
	
.on
	P_GINC		b,eaction1
	P_NEXTMAP

;!!!!!!!!!!!!>>>>
	p_export	corex,worldx
	p_export	corez,worldz
	p_export	coreroty,roty

	p_remove
;!!!!!!!!!!!!<<<<
;----------
	start_path	e_tametame

	p_collisions	off
	p_sprite	0,32

	p_set	tx,64
	P_END
;;;;------------
;;;	START_PATH	e_senkan_core
;;;
;;;	P_SET		hp,100
;;;	P_COLLISIONS	OFF
;;;	P_SPAWN		70<<s_kaku_scale,0,0,0,0,0,s_kaku_c,e_senkan_core_c,100,4,1
;;;	P_SPAWN		140<<s_kaku_scale,0,0,0,0,0,s_kaku_0,e_senkan_core_b,100,4,2
;;;	P_SET		rotx,128
;;;	P_END
;;;	START_PATH	e_senkan_core_c
;;;
;;;	P_SET		slopenum,80
;;;	P_TRIGGER	.hit,WhenHit
;;;	P_CLIPPING	ON
;;;.lp
;;;	P_ADD		childrotx,2
;;;	P_GOTO		.lp
;;;.hit
;;;	P_IFLARGER	hp,slopenum,.ok
;;;	P_FORCE		.dead
;;;.ok
;;;	P_RETURN
;;;.dead
;;;	P_TRIGGER	.hit,OFF
;;;	P_GDEC		b,KEnemyNumber
;;;	P_GDEC		b,CurrentEEnemyNumber
;;;	P_EXPLODE
;;;
;;;	START_PATH	e_senkan_core_b
;;;
;;;	P_COLLISIONS	OFF
;;;	P_END
;------------
	START_PATH	e_carier_beam

	P_PUSH		rotx
	P_FACEPLAYER	IMMEDIATE
	P_PULL		rotx
	P_DISTMORE	10000,.pas
	P_FACEPLAYER	IMMEDIATE
.pas
	P_QUADVECS	ON
	P_SETVEL	100	;40
	P_RTRIGGER	.ck,Always
	P_SET		coltab,id_2_c&wm
	P_SOUNDEFTDISTPOS	d_sen_ss_laser	;$af
	P_SOUND		p2_d_sen_ss_laser	;0F	;sdst5
	P_END
.rem_on
	P_TRIGGER	.ck,OFF
	P_WAIT		5
	P_REMOVE
.ck
	P_BEHINDPLAYER	.rem
	P_RETURN
.rem
	P_FORCE		.rem_on
	P_RETURN
;;;;-------------
;;;;-------------
;;;;------------- NEW SPEC NI YORU PLANET BASE
;;;;-------------
;;;;-------------
;;;;--------- SWITCH BASE  no SWITCH (TAOSU)
	START_PATH	e_sw_base_taosu

	P_SET		skidy,hp
	P_GOSUB		init_hardslope_soff
	P_RADAROBJ	ra_honmei
	P_SET		oy,worldz

	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.finished

	P_TRIGGER	marker_set2,Always
	P_CLRTYPE	enemy1
	P_SETCOLANIM	2
	P_INC		slopenum
	P_RTRIGGER	.taore_ck,Always
	P_SET		childx,worldx
	P_ADD		childx,80
	P_SET		ox,worldx
	P_ADD		ox,-80
	P_SET		childz,worldz
	P_ADD		childz,-40
	P_SET		oz,worldz
	P_ADD		oz,-110
	P_SET		pbyte2,26
	P_END
.taore_ck
	P_DISTMORE	250,.pass
	P_IFARWING	.pass
	P_IFNOTZERO	childrotx,.pass1
	P_IMPORT	pword1,Player1_worldx
	P_IFSMALLER	pword1,ox,.pass1
	P_IFLARGER	pword1,childx,.pass1

	P_IMPORT	pword1,Player1_worldz
	P_IFSMALLER	pword1,oz,.pass1
	P_IFLARGER	pword1,childz,.pass1
	P_SET		childrotx,1
	P_IMPORT	pbyte1,Player1_vz
	P_IFSMALLER	pbyte1,pbyte2,.pass1
	P_SOUNDEFTDIST	en_land_L
	P_FORCE		.taore_on
.pass1
	P_RETURN
.pass
	P_ZERO		childrotx
	P_RETURN

.taore_on
	P_TRIGGER	.taore_ck,OFF
	P_SETVEL	50
	P_SOUNDEFFECT	ob_slide_switch	;$ad
	P_WAIT		10			;15
	P_SOUNDEFFECT	leveltrig_stop	;$cc
	P_SETVEL	0
	P_ZERO		pbyte1
.taore_loop
	P_INC		pbyte1
	P_ADD		rotx,pbyte1
;;;	P_ADD		roty,4
	P_IFBETWEEN	-1,rotx,65,.taore_cont
	P_SET		rotx,64
	P_IGOTO		.taore_end
.taore_cont
	P_GOTO		.taore_loop
.taore_end
	P_SOUNDEFTDIST	en_land_L
	P_SET		pbyte2,6
	P_DO		8
	P_AUTOINDEX	B,worldy,jumptab,pbyte2,20
	P_NEXT

	P_SOUNDEFTDIST	ob_bunhard_end	;$a0
	P_RADAROBJ	ra_off
	P_TRIGGER	marker_set2,OFF

.finished
	P_SET		worldz,oy
	P_ADD		worldz,480
	P_ZERO		rotx
	P_SET		shape,taoreru_end
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,-40,160,0,0,0,on_d,e_sw_base_switch_c,100,4,1
	P_BECOME
	P_ADD		worldz,620
	P_ADD		worldy,-40
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_END

;;;;--------- SWITCH BASE  no SWITCH (FUNE)
	START_PATH	e_sw_base_fune

	P_SET		skidy,hp
	P_GOSUB		init_hardslope_soff
	P_SOUND		p2_f_fune
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,-85,0,0,0,0,on_d,e_sw_base_switch_c_sea,1,10,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_CLIPPING	ON
	P_UNBECOME
;	P_CLIPPING	ON
	P_GOSUB		sea_init_above
	
	P_MOVEPLAYER	ON
	P_SHADOW	OFF
	P_CLRTYPE	enemy1

.car_loop
	P_CLEARSTACK
	P_ZERO		pbyte2
.root_again
	P_IFSAME	pbyte2,16,.car_loop
	  P_INDEX		ty,fune_fuse_root,pbyte2
.same
	  P_INDEX		slopenum,track_ang,ty
	  P_ADD			slopenum,128
.car_y_rot
	  P_IFSAME		roty,slopenum,.car_ry_end
	  P_CHASE		roty,slopenum
	  P_GOTO		.car_y_rot
.car_ry_end
	  P_ADD		ty,ty
	  P_INDEX		slopenum,track_move,ty
	  P_INC		ty
	  P_INDEX		tx,track_move,ty
	  P_DO		50
	    P_DO	2
	      P_ADD		worldx,slopenum
	      P_ADD		worldz,tx
	    P_INEXT
	  P_NEXT
	P_INC			pbyte2
	P_GOTO		.root_again

;;;car_fuse_root
;;;	db	4,4,2,2,4,4,6,6,6,6,7,0,0,1,2,2
;fune_fuse_root
;	db	2,2,3,3,4,4,5,5,6,6,7,7,0,0,1,1

;;;;--------- SWITCH BASE  no SWITCH (RAPYUTA)
	START_PATH	e_sw_base_rapyuta

	P_SET		skidy,hp
	P_GOSUB		init_hardslope_soff
	P_SOUND		p2_rapyuta	;06
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,-200,0,0,0,0,on_d,e_sw_base_switch_c,1,10,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_ALWAYSGENVECS	ON
	P_MOVEPLAYER	ON
	P_SET		roty,-64
.rot_rapyu
	P_SETVEL	30
	P_WAIT		75
	P_SETVEL	0
	P_DO		32
	P_ADD		roty,-2
	P_NEXT
	P_GOTO		.rot_rapyu

;;;;;;;--------- SWITCH BASE  no SWITCH (TAKADAI)
;;;	START_PATH	e_sw_base_takadai
;;;
;;;	P_ACTIVE	ON
;;;	P_SET		skidy,roty
;;;	P_ZERO		roty
;;;	P_GOSUB		init_hardslope_soff
;;;	P_EXPORT	gbyte1,skidy
;;;	P_SPAWN		0,-400,0,0,0,0,on_d,e_sw_base_switch_takadai,1,10,1
;;;	P_BECOME
;;;	P_IMPORT	hp,gbyte1
;;;	P_UNBECOME
;;;	P_RANGECHECK	OFF
;;;.lp
;;;	P_IMPORT	pword1,PlanetSwitch
;;;	P_IFSWITCH	skidy,pword1,.on
;;;	P_GOTO		.lp
;;;.on
;;;	P_QSPAWN	chika_k1,e_switch_base_takadai,100,4
;;;	P_BECOME
;;;	P_ACTIVE	ON
;;;	P_UNBECOME
;;;	P_END
;;;;--------- SWITCH BASE  no SWITCH (KAITEN2)
	START_PATH	e_sw_base_kaiten2

	P_PASSSOUND	ON
	P_SET		hp,100
	P_COLLISIONS	OFF
	P_GROUNDOBJ	ON
	P_CLRTYPE	enemy1
	P_SET		skidy,roty
	P_ZERO		roty
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,0,0,0,0,0,suisya_0,e_kaiten2_switch_mv,100,4,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME

	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_end

	P_SPAWN		0,-550,0,0,0,0,shingo_r,e_base_shingo_sw,10,1,2
	P_BECOME
	P_IMPORT	ap,gbyte1
	P_UNBECOME

	P_SETCOLANIM	3
	P_RTRIGGER	.end,WhenFlagged
	P_RADAROBJ	ra_honmei
.already_end
	P_END
.end
	P_REMOVE	2
	P_RETURN
;.endon
;	P_TRIGGER	.end,OFF
;.already_end
;	P_END
;-----------
	START_PATH	e_kaiten2_switch_mv

	P_CLIPPING	ON
	P_CLRTYPE	enemy1

	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_end

	P_TRIGGER	self_invincible,Always
.restart
	P_RTRIGGER	.hit,WhenHitByPlayer
	P_END
.hit
	P_SET		hp,100
	P_SET		pbyte2,-22
	P_SET		pbyte1,1
	P_PLAYERINCONE	64,.plus
	P_NEG		pbyte2
	P_NEG		pbyte1
.plus
	P_FORCE		.kaiten
	P_ZERO		pword1
	P_RETURN
.kaiten
	P_ADD		pword1,pbyte2
	P_IFBETWEEN	-64,pword1,64,.nos
	P_SOUNDEFTDISTPOS	ob_roll_switch	;$ae
	P_ZERO		pword1
.nos
	P_ADD		childrotx,pbyte2
	P_IFBETWEEN	-2,pbyte2,1,.slow
	P_ADD		pbyte2,pbyte1
	P_GOTO		.kaiten
.slow
	P_IFSAME	childrotx,0,.batsu
	P_IFSAME	childrotx,128,.batsu
	P_IFSAME	childrotx,64,.maru
	P_IFSAME	childrotx,-64,.maru
	P_ADD		childrotx,pbyte2
	P_GOTO		.slow
.batsu
	P_SOUNDEFTDISTPOS	ob_roll_switch	;$ae
	P_WAIT		2
	P_SOUNDEFFECT	you_are_wrong	;$34*
	P_GOTO		.restart
.maru
	P_SOUNDEFTDISTPOS	ob_roll_switch	;$ae
	P_INVINCIBLE	ON
	P_ADD		worldy,-500
	P_GOSUB		make_demo_target
	P_ADD		worldy,500
	P_BECOME
	P_ZERO		rotz
	P_SET		tx,20
	P_SET		pword1,-400
	P_SET		slopenum,de_for_sw_base_sw_far
	P_UNBECOME

	P_GOSUB		demo_move_wait

	P_IMPORT	pword1,PlanetSwitch
	P_SETSWITCH	skidy,pword1
	P_EXPORT	PlanetSwitch,pword1
	P_GDEC		b,KEnemyNumber
	P_GDEC		b,CurrentEEnemyNumber
	P_SCORE		sc_open_key
	P_FLAGMOTHER
.already_end
	P_SET		childrotx,64
;	P_INVINCIBLE	ON
	P_COLLISIONS	OFF
	P_BECOMEMOTHER
	P_ZERO		colframe
	P_RADAROBJ	ra_off
	P_UNBECOME
	P_END

;;;;--------- SWITCH BASE  no SWITCH (KAITEN1)
	START_PATH	e_sw_base_kaiten1

	P_PASSSOUND	ON
	P_SET		skidy,roty
	P_ZERO		roty
	P_GOSUB		init_hardslope_soff
	P_RANGECHECK	OFF
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,0,200,0,0,43,ataru2_0,e_kaiten_switch_mv,100,4,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME

	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_end

	P_SPAWN		0,-500,0,0,0,0,shingo_r,e_base_shingo_sw,10,1,2
	P_BECOME
	P_IMPORT	ap,gbyte1
	P_UNBECOME
	P_SETCOLANIM	3
	P_RADAROBJ	ra_honmei
	P_TRIGGER	.fire,32
	P_TRIGGER	.end,WhenFlagged
	P_END
.end
	P_FORCE		.endon
	P_RETURN
.endon
	P_TRIGGER	.end,OFF
	P_REMOVE	2
.already_end
	P_RADAROBJ	ra_off
	P_END
.fire
	P_IFZERO	pbyte1,.pass
	P_SPAWN		0,-280,180,0,0,0,nullshape,e_sos_fire_hou_ring,100,0,3
.pass
	P_RETURN
;-----------
	START_PATH	e_kaiten_switch_mv

	P_GOSUB		init_notinvslope
	P_CLIPPING	ON
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.now_off
	P_SETCOLANIM	3
.again
	P_TRIGGER	.hit,WhenHitByPlayer
	P_END
.hit
	P_SETCOLANIM	3
	P_BECOMEMOTHER
	P_SETCOLANIM	3
	P_UNBECOME
	P_SET		hp,100
	P_PLAYERINCONE	50,.in
	P_RETURN
.in
	P_HITFLASHTRIG
	P_INVINCIBLE	ON
	P_FORCE		.on
	P_RETURN
.on
	P_TRIGGER	.hit,OFF
	P_PUSH		pbyte1
	P_SET		pbyte1,childrotz
	P_SET		pbyte2,8
	P_CLRSWITCH	pbyte2,pbyte1
	P_SET		pword1,pbyte1
	P_SET		pbyte2,22
	P_PULL		pbyte1
	P_TRIGGER	.kaiten_rot,Always
	P_WAIT		10
	P_INVINCIBLE	OFF
	P_TRIGGER	.hit_end,WhenHitByPlayer
	P_END
.hit_end
	P_SET		hp,100
	P_HITFLASHTRIG
	P_FORCE		.rot_stop
	P_RETURN
.rot_stop
	P_TRIGGER	.hit_end,OFF

	P_DO		7
	P_ADD		pbyte2,-3
	P_NEXT

	P_TRIGGER	.kaiten_rot,OFF
	P_ZERO		pbyte2

.rot_end
	P_ZERO		tx
.addloop
	P_IFZERO	childrotz,.now_just
	P_IFSAME	childrotz,43,.now_stop
	P_IFSAME	childrotz,85,.now_stop
	P_IFSAME	childrotz,128,.now_atack
	P_IFSAME	childrotz,171,.now_stop
	P_IFSAME	childrotz,213,.now_stop
	P_INC		childrotz
	P_INC		tx
	P_IFNOTSAME	tx,3,.addloop
	P_GOTO		.rot_end
.now_atack
	P_WAIT		1
	P_SOUNDEFTDISTPOS	ob_roll_switch	;$ae
	P_WAIT		2
	P_SET		colframe,0	;-128
	P_BECOMEMOTHER
	P_SET		colframe,0	;-128
	P_SET		pbyte1,1
	P_UNBECOME
	P_SOUNDEFFECT	you_are_wrong	;$34*
	P_IGOTO		.now_stop2
.now_just
	P_WAIT		1
	P_SOUNDEFTDISTPOS	ob_roll_switch	;$ae
	P_WAIT		2
	P_SET		colframe,0	;-128
	P_BECOMEMOTHER
	P_SET		colframe,0	;-128
	P_ZERO		pbyte1
	P_UNBECOME
	P_INC		pbyte2
	P_IGOTO		.now_stop2
.now_stop
	P_WAIT		1
	P_BECOMEMOTHER
	P_ZERO		pbyte1
	P_UNBECOME
	P_SOUNDEFTDISTPOS	ob_roll_switch	;$ae
.now_stop2
	P_IFZERO	pbyte2,.sonomama
.fuse_turn
	P_DO		7
	P_WAIT		1
	P_NEXT

	P_ADD		worldy,-450
	P_GOSUB		make_demo_target
	P_ADD		worldy,450
	P_BECOME
	P_ZERO		rotz
	P_SET		tx,20
	P_SET		pword1,-450
	P_SET		slopenum,de_for_sw_base_sw
	P_UNBECOME

	P_GOSUB		demo_move_wait

	P_INVINCIBLE	ON
	P_IMPORT	pword1,PlanetSwitch
	P_SETSWITCH	skidy,pword1
	P_EXPORT	PlanetSwitch,pword1
	P_GDEC		b,KEnemyNumber
	P_GDEC		b,CurrentEEnemyNumber
	P_SCORE		sc_open_key
	P_FLAGMOTHER
	P_END

.sonomama
	P_GOTO		.again

.kaiten_rot
	P_ADD		pword1,pbyte2
	P_IFBETWEEN	-1,pword1,127,.nos
	P_ADD		pword1,-127
	P_SOUNDEFTDISTPOS	ob_roll_switch	;$ae
.nos
	P_ADD		childrotz,pbyte2
	P_RETURN
.now_off
	P_ZERO		childrotz
	P_INVINCIBLE	ON
	P_END
;;;;--------- SWITCH BASE  no SWITCH (SLIDE)
	START_PATH	e_sw_base_slide

	P_SET		skidy,roty
	P_ZERO		roty
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,0,-480,0,0,0,sli_1,e_slide_switch_mv,10,4,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_SPAWN		0,-350,0,0,0,0,shingo_r,e_base_shingo_sw,10,1,2
	P_BECOME
	P_IMPORT	ap,gbyte1
	P_UNBECOME
	P_GOSUB		init_hardslope_soff
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_end
	P_RTRIGGER	.slide_ck,WhenFlagged
	P_END
.slide_ck
	P_FORCE		.already_end
	P_RETURN
.already_end
	P_SETCOLANIM	3
	P_REMOVE	2
	P_END
;------------
	START_PATH	e_slide_switch_mv
	
	P_GOSUB		init_hardslope_soff
	P_SET		slopenum,1
	P_SET		hp,10
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,Pword1,.already_end
	P_RTRIGGER	.cont_checker,Always
	P_RTRIGGER	.slide_push_ck,WhenSteppedOn
	P_END
.slide_push_ck
	P_IMPORT	pbyte1,Player1_vz
	P_IFSMALLER	pbyte1,hp,.hajime
	P_INC		ty
	P_IFNOTSAME	ty,5,.mada
	P_SET		tx,1
	P_SOUNDEFFECT	ob_slide_switch	;$ad
.mada
	P_IFZERO	tx,.hajime
	P_ADD		childz,5
	P_IFNOTSAME	childz,-240,.hajime
	P_SOUNDEFFECT	leveltrig_stop	;$cc
	P_SOUNDEFFECT	en_land_L	;$76
	P_FORCE		.push_fin
.hajime
	P_RETURN

.push_fin
	P_TRIGGER	.cont_checker,OFF
	P_TRIGGER	.slide_push_ck,OFF
	P_ADD		worldy,-150
	P_GOSUB		make_demo_target
	P_ADD		worldy,150
	P_BECOME
	P_SET		slopenum,de_for_sw_base_sli
	P_SET		tx,20
	P_UNBECOME

	P_GOSUB		demo_move_wait
	P_SETCOLANIM	3

	P_SET		shape,sli_1damy
	P_IMPORT	pword1,PlanetSwitch
	P_SETSWITCH	skidy,pword1
	P_EXPORT	PlanetSwitch,pword1
	P_GDEC		b,KEnemyNumber
	P_GDEC		b,CurrentEEnemyNumber
	P_SCORE		sc_open_key
	P_FLAGMOTHER
	P_END

.cont_checker
	P_IFNOTSAME	pbyte2,ty,.now_cont
	P_IFZERO	tx,.nos
	P_SOUNDEFFECT	leveltrig_stop	;$cc
.nos
	P_ZERO		tx
	P_ZERO		ty
.now_cont
	P_SET		pbyte2,ty
	P_RETURN
.already_end
	P_SETCOLANIM	3
	P_SET		childz,-240
	P_END

;;;;--------- SWITCH BASE  no SWITCH DROP
	START_PATH	e_sw_base_sw_drop_sea

	P_CLIPPING	ON
	P_SET		weapontype,2
	P_TRIGGER	marker_set2,Always
	P_IGOTO		pe_sw_base_sw_drop.sea_enter

	START_PATH	e_sw_base_sw_drop

	P_TRIGGER	marker_set2,Always
.enter	LOCAL
	P_ZERO		weapontype
.sea_enter	LOCAL
	P_SETANIM	0
	P_SETCOLANIM	2
	P_COLLISIONS	OFF
	P_ZERO		pbyte1
	P_ZERO		pbyte2
	P_TRIGGER	.rott,Always
;;;;;	P_TRIGGER	marker_set,Always
	P_DO		20
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_NEXT

	P_WAIT		1
	P_SET		pword1,60
.lp
	P_ADD		worldy,pword1
	P_IFSAME	pword1,100,.pw1_noadd
	P_ADD		pword1,10
.pw1_noadd
	P_HITGROUND	0,.on_g
	P_GOTO		.lp
.on_g
	P_SOUNDEFTDISTPOS	ob_bunhard_L	;$99
	P_TRIGGER	.rott,OFF
	P_ZERO		worldy
	P_WAIT		1
	P_RTRIGGER	.rottt,Always
	P_SET		pbyte1,5
	P_DO		10
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_NEXT
	P_SOUNDEFTDISTPOS	ob_bunhard_L	;$99
	P_WAIT		1
	P_SET		pbyte1,6
	P_DO		8
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_NEXT

	P_SOUNDEFTDISTPOS	ob_bunhard_end	;$a0

	P_ZERO		rotx
	P_ZERO		roty
	P_ZERO		rotz
	P_ZERO		worldy
	P_TRIGGER	.rottt,OFF
	P_ZERO		pbyte1
	P_IFNOTSAME	weapontype,2,.nottako
	P_SET		pbyte1,2
.nottako
	P_GSET		b,bossmaxhp,0
	P_IGOTO		pe_sw_base_switch.enter
.rott
	P_ADD		rotx,16
	P_ADD		roty,16
	P_RETURN
.rottt
	P_CHASE		rotx,0
	P_CHASE		roty,0
	P_RETURN

;;;;--------- SWITCH BASE  no SWITCH
	START_PATH	e_sw_base_switch_c_sea
	P_TRIGGER	marker_set2,Always
	P_IGOTO		pe_sw_base_switch_sea.enter
;---
	START_PATH	e_sw_base_switch_sea

	P_SET		skidy,roty
.enter	LOCAL
	P_SET		pbyte1,2
	P_SET		pword1,-1000
	P_IFLARGER	worldy,pword1,.in_sea
	P_GOSUB		sea_init_above
	P_IGOTO		.same_live
.in_sea
	P_GOSUB		sea_init_below
.same_live
	P_IGOTO		pe_sw_base_switch.enter
;---
	START_PATH	e_sw_base_switch_c
	P_TRIGGER	marker_set2,Always
	P_IGOTO		pe_sw_base_switch.enter
;---
	START_PATH	e_sw_base_switch_takadai
	P_INC		pbyte1
;---
	START_PATH	e_sw_base_switch
	P_SET		skidy,roty
.enter	LOCAL
	P_GOSUB		init_hardslope_soff
	P_MOVEPLAYER	ON
	P_ACTIVE	ON
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_end

	P_SETANIM	0
	P_SETCOLANIM	2
	P_INC		slopenum
	P_RTRIGGER	.stepped,WhenSteppedOn
	P_RADAROBJ	ra_honmei
	P_END
.stepped
	P_DISTMORE	150,.not_cen
	P_FORCE		.steped_anim
.not_cen
	P_RETURN
.steped_anim
	P_TRIGGER	.stepped,OFF
	P_TRIGGER	marker_set2,OFF
	P_IFSAME	pbyte1,1,.takadai
	P_IFSAME	pbyte1,2,.in_sea
	P_ADD		worldy,-50
	P_GOSUB		make_demo_target
	P_ADD		worldy,50
	P_BECOME
	P_SET		slopenum,de_for_sw_base_sw
	P_SET		tx,10	;20
	P_UNBECOME
.same_as_takadai
;;;	P_GOSUB		demo_move_wait
	P_WAIT		8
	P_SLOPE		OFF
	P_SOUNDEFFECT	ob_switchon	;$34
	P_DO		7
	P_ADDANIM	1,8
	P_NEXT
	
	P_IMPORT	pword1,PlanetSwitch
	P_SETSWITCH	skidy,pword1
	P_EXPORT	PlanetSwitch,pword1
	P_GDEC		b,KEnemyNumber
	P_GDEC		b,CurrentEEnemyNumber
	P_SCORE		sc_open_key
	P_RADAROBJ	ra_off
.already_end
	P_TRIGGER	marker_set2,OFF
	P_FINDSHAPE	arrow_0
	P_SHAPEDEAD	.no_arrow
	P_SHAPEDISTMORE	200,.no_arrow
	P_FLAGSHAPE
.no_arrow
	P_SET		shape,off_d
	P_SETANIM	7
	P_SETCOLANIM	3
	P_GOSUB		init_hardslope_soff
	P_END
.takadai
	P_ADD		worldy,200
	P_ADD		worldz,600
	P_GOSUB		make_demo_target
	P_ADD		worldy,-200
	P_ADD		worldz,-600
	P_BECOME
	P_SET		slopenum,de_for_sw_base_sw_takadai
	P_SET		pword1,-200
	P_SET		tx,50
	P_UNBECOME
	P_IGOTO		.same_as_takadai
.in_sea
	P_ADD		worldy,-50
	P_GOSUB		make_demo_target
	P_ADD		worldy,50
	P_BECOME
	P_SET		slopenum,de_for_sw_base_sw_sea
	P_SET		tx,20
	P_UNBECOME
	P_IGOTO		.same_as_takadai
;---------
	START_PATH	e_sw_marker

	P_INVISIBLE	ON
.lp
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	hp,pword1,eg_remove
	P_SETMARKER	2
	P_GOTO		.lp
;.ended
;	P_REMOVE
;;;;--------- BASE HONTAI
;;;	START_PATH	e_switch_base_takadai
;;;
;;;	P_ADD		worldz,800
;;;	P_SET		roty,64
;;;	P_GOSUB		init_hardslope_soff
;;;	P_RANGECHECK	OFF
;;;	P_SET		pbyte1,5
;;;	P_IMPORT	pword1,PlanetSwitch
;;;	P_IFSWITCH	pbyte1,pword1,.already_end
;;;
;;;	P_SET		worldy,500
;;;	P_CLIPPING	ON
;;;
;;;	P_DO		25
;;;	P_ADD		worldy,-20
;;;	P_NEXT
;;;	P_CLIPPING	OFF
;;;	P_SET		pbyte1,5
;;;	P_IMPORT	pword1,PlanetSwitch
;;;	P_SETSWITCH	pbyte1,pword1
;;;	P_EXPORT	PlanetSwitch,pword1
;;;.already_end
;;;	P_ZERO		worldy
;;;;KG	P_SPAWN		0,0,30<<planet_base_scale,0,0,0,nullshape,e_base_in_checker,100,0,5
;;;	P_SPAWN		0,0,0,0,0,0,nullshape,e_base_in_checker,100,0,5
;;;	P_RADAROBJ	ra_honmei
;;;	P_END
;-----------
	START_PATH	e_switch_base_sea

	P_GOSUB		sea_init_below
	P_SET		pbyte1,5
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	pbyte1,pword1,.no_door
	P_SPAWN		0,0,50<<planet_base_scale,0,0,0,chika_to,e_base_door,100,4,9
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
.no_door
	P_SET		slopenum,1
;------------
	START_PATH	e_switch_base

	P_SET		skidy,hp		;switch no kazu
	P_SET		roty,ap
	P_ACTIVE	ON
	P_GOSUB		init_hardslope_soff
	P_TRIGGER	reflect_laser,Always

	P_IMPORT	pbyte1,KDifficulty
	P_IFSAME	pbyte1,dif_hard,.no_hit_msg

	P_TRIGGER	base_hit_msg,WhenHitByPlayer
.no_hit_msg
	P_SET		pbyte1,5
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	pbyte1,pword1,.ended
	P_RTRIGGER	.sw_check,Always
	P_RADAROBJ	ra_entrance

	P_GOSUB		.make_lamp

	P_IFZERO	slopenum,.not_sea
	P_BECOMECHILD	1		;pbyte1
	P_ADD		childy,-33<<planet_base_scale
	P_UNBECOME
.not_sea
	P_END
.make_lamp
	P_EXPORT	gbyte1,skidy
	P_SPAWN		0,-350,0,0,0,0,shingo_w,e_shingo_waku,10,10,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_RETURN
.sw_check
	P_IMPORT	pword1,PlanetSwitch
	P_SET		pbyte1,1
	P_DO		skidy
	P_IFSWITCH	pbyte1,pword1,.ok
	P_BREAK		.mada
.ok
	P_INC		pbyte1
	P_INEXT
	P_FORCE		.all_switch_on
.mada
	P_RETURN
.all_switch_on
	P_TRIGGER	base_hit_msg,OFF
	P_TRIGGER	.sw_check,OFF

	P_IMPORT	pword1,PlanetSwitch
	P_SET		pbyte1,5
	P_SETSWITCH	pbyte1,pword1
	P_EXPORT	PlanetSwitch,pword1

	P_GOSUB		demo_move_wait2

	P_WAIT		13

	P_REMOVE	4
	P_REMOVE	3
	P_REMOVE	2
	P_REMOVE	1

.hou_base_deru	LOCAL

	P_IFZERO	slopenum,.not_sea2
	P_SPAWN		0,-650,0,0,0,0,nullshape,e_shingo_open,10,10,1
	P_IGOTO		.same_sea2
.not_sea2
	P_SPAWN		0,-350,0,0,0,0,nullshape,e_shingo_open,10,10,1
.same_sea2
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_WAIT		10

	P_CLIPPING	ON
	P_SET		shape,chika_k1

	P_IFNOTZERO	slopenum,.sea

	P_SPAWN		0,0,50<<planet_base_scale,0,0,0,chika_to,e_base_door,100,4,9
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME

	P_SET		worldy,33<<planet_base_scale
	P_BECOMECHILD	1		;pbyte1
	P_ADD		childy,-33<<planet_base_scale
	P_UNBECOME

	P_SET		pbyte1,10

	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		0,-14<<planet_base_scale,0,0,0,0,nullshape,e_smoker,10,10,10
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childx,base_smoke_x,pbyte1
	P_INDEX		childz,base_smoke_z,pbyte1
	P_ADD		pbyte1,10
	P_SETID		pbyte1
	P_GINC		b,gbyte1
	P_ACTIVE	ON
	P_UNBECOME
	P_INEXT

;	P_SPAWN		-43<<planet_base_scale,-14<<planet_base_scale,43<<planet_base_scale,0,0,0,nullshape,e_smoker,10,10,10
;	P_BECOME
;	P_ACTIVE	ON
;	P_UNBECOME
;	P_SPAWN		-43<<planet_base_scale,-14<<planet_base_scale,-43<<planet_base_scale,0,0,0,nullshape,e_smoker,10,10,11
;	P_BECOME
;	P_ACTIVE	ON
;	P_UNBECOME
;	P_SPAWN		43<<planet_base_scale,-14<<planet_base_scale,-43<<planet_base_scale,0,0,0,nullshape,e_smoker,10,10,12
;	P_BECOME
;	P_ACTIVE	ON
;	P_UNBECOME
;	P_SPAWN		43<<planet_base_scale,-14<<planet_base_scale,43<<planet_base_scale,0,0,0,nullshape,e_smoker,10,10,13
;	P_BECOME
;	P_ACTIVE	ON
;	P_UNBECOME

	P_DO		3
	P_ADD		worldy,-1<<planet_base_scale
	P_NEXT

	P_WAIT		1
	P_SOUNDEFFECT	ob_slide_switch	;$ad
	P_SOUNDEFFECT	ob_base_up	;$97*


	P_DO		30
	P_ADD		worldy,-1<<planet_base_scale
	P_NEXT
	P_SOUNDEFFECT	leveltrig_stop	;$cc
.sea
	P_FLAGCHILD	9

	P_WAIT		10
	P_REMOVE	5
	P_REMOVE	4
	P_REMOVE	3
	P_REMOVE	2
	P_REMOVE	1

.ended	LOCAL
	P_RADAROBJ	ra_entrance
	P_SET		shape,chika_k1
	P_SPAWN		0,0,0,0,0,0,nullshape,e_base_in_checker,100,0,5
	P_TRIGGER	base_hit_msg,OFF
	P_END

;;;.yure
;;;	P_ADD		worldy,pbyte1
;;;	P_NEG		pbyte1
;;;	P_RETURN
;.yure_sound
;	P_SOUNDEFFECT	ob_slide_switch	;$ad
;	P_RETURN
;----------
	START_PATH	e_smoker

	P_INVISIBLE	ON
	P_TRIGGER	hasami_smoke_nosou,4
	P_WAIT		34
	P_REMOVE
;----------
	START_PATH	e_base_door

	P_SETANIM	0
	P_COLLISIONS	OFF
	P_CLIPPING	ON
	P_SHADOW	OFF
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,5,.not_seaa
	P_CLIPPING	OFF
	P_GOSUB		sea_init_below
.not_seaa
.lp
	P_IFFLAG	.op
	P_GOTO		.lp
.op
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,5,.not_sea
	P_RTRIGGER	.mk_bubble,Always
.not_sea
	P_GOSUB		open_door_base
	P_REMOVE
.mk_bubble

	P_QSPAWN	bubble,e_bubble,10,5
	P_BECOME
	P_SETRANDOM	pbyte1,127
	P_ADD		pbyte1,-64
	P_ADD		worldx,pbyte1
	P_SETRANDOM	pbyte1,63
	P_ADD		pbyte1,-32
	P_ADD		worldy,pbyte1

	P_SET		pbyte2,-30
	P_ACTIVE	ON
	P_UNBECOME
	
	P_RETURN
;----------
	START_PATH	e_shingo_open

	P_SOUNDEFFECT	you_are_right	;$30*
	P_COLLISIONS	OFF

	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		0,0,0,0,0,0,nullshape,e_open_chr,10,10,2
	P_BECOME
	P_IMPORT	pbyte2,gbyte1
	P_INDEX		childx,open_chx_tab,pbyte2
	P_INDEX		shape,open_chs_tab,pbyte2
	P_ADD		pbyte2,2
	P_SETID		pbyte2
	P_GINC		b,gbyte1
	P_ACTIVE	ON
	P_INVISIBLE	ON
	P_UNBECOME
	P_INEXT


;	P_SPAWN		-180,0,0,0,0,0,opchr_o,e_open_chr,100,0,2
;	P_BECOME
;	P_ACTIVE	ON
;	P_UNBECOME
;	P_SPAWN		-60,0,0,0,0,0,opchr_p,e_open_chr,100,0,3
;	P_BECOME
;	P_ACTIVE	ON
;	P_UNBECOME
;	P_SPAWN		60,0,0,0,0,0,opchr_e,e_open_chr,100,0,4
;	P_BECOME
;	P_ACTIVE	ON
;	P_UNBECOME
;	P_SPAWN		180,0,0,0,0,0,opchr_n,e_open_chr,100,0,5
;	P_BECOME
;	P_ACTIVE	ON
;	P_UNBECOME


	P_RTRIGGER	.face,Always
	P_END
.face
	P_FACEVIEW	IMMEDIATE
	P_ADD		roty,128
	P_ZERO		rotx
	P_ZERO		rotz
	P_ADJUSTROT
	P_RETURN
;----------
	START_PATH	e_open_chr

	P_SETCOLANIM	1
	P_RTRIGGER	.color,Always
	P_WAIT		3
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_END
.color
	P_INDEX		colframe,open_chrtab,pbyte1
	P_INC		pbyte1
	P_IFNOTSAME	pbyte1,7,.ok
	P_ZERO		pbyte1
.ok
	P_RETURN
;open_chrtab
;	db	-128,-127,-126,-125,-126,-127,-128
;----------
	START_PATH	e_shingo_waku

	P_RANGECHECK	ON
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,5,.not_sea

	P_GOSUB		sea_init_below
;	P_CLIPPING	ON
.not_sea
	P_COLLISIONS	OFF
	P_SHADOW	OFF

	P_IFSAME	skidy,2,.bs_2
	P_SPAWN		0,0,0,0,0,0,shingo_r,e_base_shingo,10,1,2
	P_IFSAME	skidy,3,.bs_3
	P_IGOTO		.waku_rot
.bs_2
	P_SPAWN		150,0,0,0,0,0,shingo_r,e_base_shingo,10,1,2
	P_SPAWN		-150,0,0,0,0,0,shingo_r,e_base_shingo,10,2,3
	P_IGOTO		.waku_rot

.bs_3
	P_SPAWN		200,0,0,0,0,0,shingo_r,e_base_shingo,10,2,3
	P_SPAWN		-200,0,0,0,0,0,shingo_r,e_base_shingo,10,3,4
.waku_rot
	P_FACEVIEW	IMMEDIATE
;;;	P_ZERO		childrotx
;;;	P_ZERO		childrotz
	P_ZERO		rotx
	P_ZERO		rotz
	P_ADJUSTROT
	P_GOTO		.waku_rot
;-----------
	START_PATH	e_base_shingo_sw
	P_INC		mx
	START_PATH	e_base_shingo

	P_RANGECHECK	ON
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFNOTSAME	pbyte1,5,.not_sea
	P_GOSUB		sea_init_below
;	P_CLIPPING	ON
.not_sea
	P_RTRIGGER	.sw_rot,Always
	P_COLLISIONS	OFF
	P_ACTIVE	ON
	P_SHADOW	OFF
	P_SET		skidy,ap
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_end
.lp
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.on
	P_GOTO		.lp
.on
	P_IFNOTZERO	mx,.switch_no_ue
	P_GOSUB		demo_move_wait2
.switch_no_ue
	P_DO		5
	P_SET		shape,shingo_r
	P_SOUNDEFFECT	marubatsu	;$0c*
	P_WAIT		1
	P_SET		shape,shingo_b
	P_SOUNDEFFECT	marubatsu	;$0c*
	P_NEXT
.already_end
	P_SET		shape,shingo_b
	P_END
.sw_rot
	P_ADD		roty,8
	P_ADD		childroty,8
	P_RETURN
;------------
	START_PATH	e_houdai_base

	P_SET		skidy,hp		;switch no kazu
	P_SET		roty,ap
	P_ACTIVE	ON
	P_GOSUB		init_hardslope_soff
	P_TRIGGER	reflect_laser,Always	
;	P_RANGECHECK	OFF

	P_SET		pbyte1,5
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	pbyte1,pword1,pe_switch_base.ended
	P_RTRIGGER	.sw_check,Always
	P_RADAROBJ	ra_entrance

	P_GOSUB		.make_base_hou
	P_END
;.ended
;	P_END

.sw_check
	P_IMPORT	pword1,PlanetSwitch
	P_SET		pbyte1,1
	P_DO		skidy
	P_IFSWITCH	pbyte1,pword1,.ok
	P_BREAK		.mada
.ok
	P_INC		pbyte1
	P_INEXT
	P_FORCE		.all_switch_on
.mada
	P_RETURN

.all_switch_on
	P_TRIGGER	.sw_check,OFF

	P_IMPORT	pword1,PlanetSwitch
	P_SET		pbyte1,5
	P_SETSWITCH	pbyte1,pword1
	P_EXPORT	PlanetSwitch,pword1

	P_ADD		worldy,-200
	P_GOSUB		make_demo_target
	P_ADD		worldy,200
	P_BECOME
	P_SET		pword1,-200
	P_SET		slopenum,de_for_base_base
	P_SET		tx,40
	P_UNBECOME

	P_GOSUB		demo_move_wait

	P_IGOTO		pe_switch_base.hou_base_deru

.make_base_hou
	P_IFSAME	skidy,3,.mk_sanko
	P_IFSAME	skidy,2,.mk_niko
	P_SPAWN		28<<chi_hou_scale,-17<<chi_hou_scale,0,0,-64,0,chi_hou,e_hou_base_hou,0,1,1
	P_SPAWN		-28<<chi_hou_scale,-17<<chi_hou_scale,0,0,64,0,chi_hou,e_hou_base_hou,3,2,2
.mk_niko
	P_SPAWN		0,-17<<chi_hou_scale,-28<<chi_hou_scale,0,128,0,chi_hou,e_hou_base_hou,6,3,3
	P_SPAWN		0,-17<<chi_hou_scale,28<<chi_hou_scale,0,0,0,chi_hou,e_hou_base_hou,100,9,4
	P_RETURN
.mk_sanko
	P_SPAWN		0,-17<<chi_hou_scale,-28<<chi_hou_scale,0,128,0,chi_hou,e_hou_base_hou,0,1,1
	P_SPAWN		-24<<chi_hou_scale,-17<<chi_hou_scale,14<<chi_hou_scale,0,43,0,chi_hou,e_hou_base_hou,4,2,2
	P_SPAWN		24<<chi_hou_scale,-17<<chi_hou_scale,14<<chi_hou_scale,0,-43,0,chi_hou,e_hou_base_hou,8,3,3
.end_make
	P_RETURN

;------------
	START_PATH	e_hou_base_hou
	
	P_SET		skidy,ap
	P_SET		ap,8
	P_SETSWITCH	ap,hp
	P_SET		animframe,hp
	P_SET		hp,100
	P_SET		ap,4
	P_ACTIVE	ON
	P_SHADOW	OFF
;	P_CLRTYPE	enemy1
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,eg_remove
	P_RTRIGGER	.hou_hit,WhenHit
	P_TRIGGER	marker_set,Always
;	P_RTRIGGER	.chi_hou_anim,Always
.lp
	P_SETANIM	5
	P_DISTMORE	2500,.cantf
	P_PLAYERINCONE	64,.fire
.cantf
	P_GOTO		.lp
.fire
	P_SPAWN		0,-120,250,0,0,0,ring_mark,e_ring_mark_child,10,10,11
	P_BECOME
	P_INVISIBLE	ON
	P_UNBECOME
	P_WAIT		1
	P_BECOME
	P_INVISIBLE	OFF
	P_COLLISIONS	OFF
	P_UNBECOME
	P_WAIT		10
	P_DO		12
	P_ADDANIM	-1,12
	P_NEXT
	P_REMOVE	11

	P_GOTO		.lp
.hou_hit
	P_SET		slopenum,90
	P_IFLARGER	hp,slopenum,.ok
	P_COLLISIONS	OFF
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.hou_hit,OFF
	P_COLLISIONS	OFF
	P_SET		slopenum,80
	P_IFLARGER	hp,slopenum,.suguni
	P_IFZERO	skidy,.suguni
	P_DO		skidy
	P_WAIT		10
	P_NEXT
.suguni
	P_GDEC		b,KEnemyNumber
	P_GDEC		b,CurrentEEnemyNumber
	P_IMPORT	pword1,PlanetSwitch
	P_SETSWITCH	skidy,pword1
	P_EXPORT	PlanetSwitch,pword1
	P_SCORE		sc_open_key
	P_TRIGGER	marker_set,OFF
	P_SET		shape,chi_hou_s
	P_GOSUB		group_explode
;	P_SPAWN		0,-20<<chi_hou_scale,15<<chi_hou_scale,0,0,0,nullshape,e_chi_hou_damy_exp,100,0,9
;	P_GOSUB		s_group_explode
	P_EXPLODE
;.already_end
;	P_REMOVE
;------------
;	START_PATH	e_chi_hou_damy_exp
;
;	P_ACTIVE	ON
;	P_INVISIBLE	ON
;	P_GOSUB		group_explode
;	P_REMOVE
;------------
	START_PATH	e_shield_base

	P_SET		skidy,hp		;shield no kazu(2-4)
	P_SET		roty,ap
	P_RADAROBJ	ra_entrance
	P_GOSUB		init_hardslope_soff
	P_HITFLASH	OFF
	P_TRIGGER	hp100_reflect_laser,Always	
	P_IMPORT	pword1,PlanetSwitch
	P_SET		pbyte1,5
	P_IFSWITCH	pbyte1,pword1,.ended
	P_SOUND		p2_chika_k3	;0E
	P_SET		coltab,black_c&wm
	P_GOSUB		.mk_baria
.wlp
	P_IMPORT	pword1,PlanetSwitch
	P_SET		pbyte1,1
	P_DO		skidy
	P_IFSWITCH	pbyte1,pword1,.ok
	P_BREAK		.mada
.ok
	P_INC		pbyte1
	P_INEXT
	P_GOTO		.all_switch_on
.mada
	P_GOTO		.wlp
.all_switch_on
	P_SOUND		port2_stop	;00
	P_REMOVE	1
	P_ADD		worldy,-200
	P_GOSUB		make_demo_target
	P_ADD		worldy,200
	P_BECOME
	P_SET		pword1,-200
	P_SET		slopenum,de_for_base_base
	P_SET		tx,20
	P_UNBECOME

	P_GOSUB		demo_move_wait

	P_SPAWN		0,0,0,0,0,0,chika_k1,e_buil_shadow_off,100,0,9
	P_BECOME
	P_ACTIVE	ON
	P_INVINCIBLE	ON
	P_GROUNDOBJ	ON
	P_INVISIBLE	ON
	P_CLIPPING	BOSS2
	P_UNBECOME
	P_SPAWN		0,-500,0,128,0,0,clipshape,e_base_cliper,100,0,10
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME

	P_CLIPPING	BOSS
	P_SET		pbyte1,2
	P_DO		4
	P_BECOMECHILD	pbyte1
	P_CLIPPING	BOSS
	P_UNBECOME
	P_INC		pbyte1
	P_INEXT

	P_FLAGCHILD	10
	P_WAIT		1
	P_BECOMECHILD	9
	P_INVISIBLE	OFF
	P_UNBECOME
.wwlp
	P_IFFLAG	.next_step
	P_GOTO		.wwlp
.next_step
	P_REMOVE	2
	P_REMOVE	3
	P_REMOVE	4
	P_REMOVE	5
	P_REMOVE	9
	P_CLIPPING	OFF
.ended
	P_SET		shape,chika_k1
	P_SET		coltab,id_0_c
	P_IMPORT	pword1,PlanetSwitch
	P_SET		pbyte1,5
	P_SETSWITCH	pbyte1,pword1
	P_EXPORT	PlanetSwitch,pword1
;KG	P_SPAWN		0,0,70<<planet_base_scale,0,0,0,nullshape,e_base_in_checker,100,0,5
	P_SPAWN		0,0,0,0,0,0,nullshape,e_base_in_checker,100,0,5
	P_END
.mk_baria
	P_SPAWN		0,0,0,0,0,0,chi_b_0,e_invincible_obj,100,4,1
;;;	P_IFSAME	skidy,3,.bari_3
	P_IFSAME	skidy,2,.bari_2
.explain_bari4	LOCAL
	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		0,-14<<planet_base_scale,0,0,0,0,chi_b_1,e_sh_base_shield,100,1,2
	P_BECOME
	P_IMPORT	ap,gbyte1
	P_INDEX		childx,bari_4x,ap
	P_INDEX		childz,bari_4z,ap
	P_INDEX		childroty,bari_4ry,ap
	P_ADD		ap,2
	P_SETID		ap
	P_DEC		ap
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
;	P_SPAWN		-71<<planet_base_scale,-14<<planet_base_scale,71<<planet_base_scale,0,32,0,chi_b_1,e_sh_base_shield,100,1,2
;	P_SPAWN		-71<<planet_base_scale,-14<<planet_base_scale,-71<<planet_base_scale,0,96,0,chi_b_1,e_sh_base_shield,100,2,3
;	P_SPAWN		71<<planet_base_scale,-14<<planet_base_scale,-71<<planet_base_scale,0,-96,0,chi_b_1,e_sh_base_shield,100,3,4
;	P_SPAWN		71<<planet_base_scale,-14<<planet_base_scale,71<<planet_base_scale,0,-32,0,chi_b_1,e_sh_base_shield,100,4,5
	P_RETURN
.bari_2		LOCAL
	P_SPAWN		-100<<planet_base_scale,-14<<planet_base_scale,0,0,64,0,chi_b_1,e_sh_base_shield,100,1,2
	P_SPAWN		100<<planet_base_scale,-14<<planet_base_scale,0,0,-64,0,chi_b_1,e_sh_base_shield,100,2,3
	P_RETURN
;;;.bari_3
;;;	P_SPAWN		0,-14<<planet_base_scale,-100<<planet_base_scale,0,128,0,chi_b_1,e_sh_base_shield,100,1,2
;;;	P_SPAWN		-87<<planet_base_scale,-14<<planet_base_scale,50<<planet_base_scale,0,43,0,chi_b_1,e_sh_base_shield,100,2,3
;;;	P_SPAWN		87<<planet_base_scale,-14<<planet_base_scale,50<<planet_base_scale,0,-43,0,chi_b_1,e_sh_base_shield,100,3,4
;;;	P_RETURN
;------------
	START_PATH	e_henkei_offer

	P_FINDSHAPE	stg_checker
	P_BECOMESHAPE
	P_SET		weapontype,-1
	P_UNBECOME
	P_REMOVE
;----------
	START_PATH	e_base_in_checker

	P_QSPAWN	nullshape,e_henkei_offer,10,10
	P_IMPORT	pbyte1,KGameMapPtr
	P_IFSAME	pbyte1,5,.sea
	P_TRIGGER	marker_set2,Always
.sea
	P_INVISIBLE	ON

	P_NEXTMAP
;!!!!!!!!!!!!>>>>
	p_export	corex,worldx
	p_export	corez,worldz
	p_export	coreroty,roty
;!!!!!!!!!!!!<<<<
	P_END
;------------
	START_PATH	e_sh_base_shield

	P_RTRIGGER	.shield_hit,WhenHit
	P_SET		slopenum,95
	P_SET		skidy,ap
	P_SET		ap,4
	P_ACTIVE	ON
	P_SHADOW	OFF

	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	skidy,pword1,.already_end
	P_TRIGGER	marker_set,Always
	P_END
.shield_hit
	P_IFLARGER	hp,slopenum,.ok
	P_COLLISIONS	OFF
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.shield_hit,OFF
	P_SET		slopenum,85
	P_IFLARGER	hp,slopenum,.sugu
	P_IFZERO	skidy,.sugu
	P_DO		skidy
	P_WAIT		10
	P_NEXT
.sugu
	P_GDEC		b,KEnemyNumber
	P_GDEC		b,CurrentEEnemyNumber
	P_IMPORT	pword1,PlanetSwitch
	P_SETSWITCH	skidy,pword1
	P_EXPORT	PlanetSwitch,pword1
	P_QSPAWN	chi_b_2,e_wakidashi_damy_exp,10,10
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_SCORE		sc_open_key
	P_TRIGGER	marker_set,OFF
.already_end
	P_COLLISIONS	OFF
	P_SET		shape,chi_b_2
	P_END
;------------
	START_PATH	e_base_cliper

	P_GROUNDOBJ	ON
	P_COLLISIONS	OFF
	P_SET		pword1,childy
	P_ZERO		oy
.lp
	P_IFFLAG	.act1
	P_GOTO		.lp
.act1
	P_SOUNDEFFECT	ob_black_barrior	;$9b
.act
	P_CHASE		childy,100
	P_IFLARGER	childy,oy,.okk
	P_GOTO		.act
.okk
	P_FLAGMOTHER
.end
	P_REMOVE
;------------
	START_PATH	e_carier_core2_c

	P_CLIPPING	ON
	P_SHADOW	OFF
	P_COLLISIONS	OFF
	P_SET		pword1,-8<<kaku6_scale

	P_RTRIGGER	.hit,WhenHit
	P_RTRIGGER	.col_ck,Always
	P_END
.col_ck
	P_IFSMALLER	worldy,pword1,.c_on
	P_COLLISIONS	OFF
	P_RETURN
.c_on
	P_COLLISIONS	ON
	P_RETURN
.hit
	P_SET		pbyte1,80
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.hit,OFF
	P_TRIGGER	.col_ck,OFF
	P_COLLISIONS	OFF
	P_GOSUB		s_group_explode
	P_QSPAWN	kaku4_4,e_exp_self,100,0
	P_SET		shape,kaku6_2
	P_BECOMEMOTHER
	P_INC		slopenum
	P_EXPORT	gbyte1,slopenum
	P_UNBECOME
	P_FLAGMOTHER
	P_IMPORT	pbyte1,gbyte1
	P_SET		pbyte2,25
	P_DO		pbyte1
	P_ADD		pbyte2,-5
	P_INEXT
	P_SET		pbyte1,pbyte2
	P_TRIGGER	mk_spark_core,4		;Always

	P_END
;;;;	P_IGOTO		pe_spe_core_bt.flashing
;------------
	START_PATH	e_core_keeper

	P_GOSUB		hit_dead_init
	P_WEAPON	Elaser
	P_RTRIGGER	.dead,WhenDead
	P_RTRIGGER	.kene_ck,Always

	P_SOUND		p2_kaku6_4

	P_FACEPLAYER	IMMEDIATE
	P_ZERO		rotx
	P_ADD		roty,slopenum
	P_DO		4
	P_DIV2		slopenum
	P_INEXT

	P_DO		15
	P_ADD		worldy,-4<<kaku6_scale
	P_NEXT

	P_CLIPPING	OFF

	P_SETVEL	20

	P_TRIGGER	fly_wave,Always
	P_SET		tx,4
	P_SET		ty,8
	P_DO		15
	P_ADD		roty,slopenum
	P_NEXT
	
	P_ACCEL		0,1
.con
	P_FACEPLAYER
	P_PLAYERINCONE	5,.fire
	P_GOTO		.con
.fire
	P_GOSUB		sos_fire_must
	P_DO		20
	P_FACEPLAYER
	P_NEXT
	P_GOTO		.con
.dead
	P_GDEC		b,eaction1
	P_SCORE		sc_hit_dead
	P_RETURN
.kene_ck
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFNOTZERO	pbyte1,.keneok
	P_FORCE		.ene_no
.keneok
	P_RETURN
.ene_no
	P_TRIGGER	.dead,OFF
	P_TRIGGER	.kene_ck,OFF
	P_EXPLODE
;------------
	START_PATH	e_core_keeper_ring

	P_COLLISIONS	OFF
	P_RELATIVE	OFF
	P_SHADOW	OFF
	P_RTRIGGER	.umu,WhenFlagged
	P_END
.umu
	P_FORCE		.ume
	P_RETURN
.ume
	P_SET		slopenum,32
;	P_DO		1	;3
	P_IMPORT	pbyte1,eaction1
	P_SET		pbyte2,1		;max = 1 +1
	P_IFLARGER	pbyte1,pbyte2,.many
	P_EXPORT	gbyte1,slopenum
	P_QSPAWN	kaku6_4,e_core_keeper,1,4
	P_GINC		b,eaction1
	P_BECOME
	P_IMPORT	slopenum,gbyte1
	P_CLIPPING	ON
	P_ADD		worldy,30<<kaku6_scale
	P_UNBECOME
.many
	P_NEG		slopenum
	P_WAIT		15
;	P_NEXT
	P_END
;------------
	START_PATH	e_carier_core_2

	P_GSET		b,eaction1,0
	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		0,12<<kaku6_scale,0,0,0,0,kaku6_1,e_carier_core2_c,100,4,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childx,cari_core2_cx,pbyte1
	P_INDEX		childz,cari_core2_cz,pbyte1
	P_INDEX		childroty,cari_core2_ry,pbyte1
	P_INC		pbyte1
	P_SETID		pbyte1
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT


;	P_SPAWN		12<<kaku6_scale,12<<kaku6_scale,0,0,-64,0,kaku6_1,e_carier_core2_c,100,4,1
;	P_SPAWN		-12<<kaku6_scale,12<<kaku6_scale,0,0,64,0,kaku6_1,e_carier_core2_c,100,4,2
;	P_SPAWN		0,12<<kaku6_scale,12<<kaku6_scale,0,0,0,kaku6_1,e_carier_core2_c,100,4,3
;	P_SPAWN		0,12<<kaku6_scale,-12<<kaku6_scale,0,128,0,kaku6_1,e_carier_core2_c,100,4,4
	P_SPAWN		0,30<<kaku6_scale,0,0,0,0,kaku6_0,e_buil_shadow_off,100,4,5
	P_SPAWN		350,5<<kaku6_scale,-350,0,0,0,ana_0,e_core_keeper_ring,10,10,6
	P_SPAWN		-350,5<<kaku6_scale,350,0,0,0,ana_0,e_core_keeper_ring,10,10,7
	P_BECOMECHILD	5
	P_CLIPPING	ON
	P_UNBECOME

	P_GOSUB		wakidashi_init
	P_EXPORT	Corex,worldx
	P_EXPORT	Corez,worldz
	P_SHADOW	OFF
	P_RANGECHECK	OFF

	P_WAIT		5

	P_RTRIGGER	.core_c_ck,WhenFlagged
	P_BECOMECHILD	5
	P_SLOPE		OFF
	P_CLIPPING	ON
	P_UNBECOME

	P_GOSUB		crose_door_wait

;	P_INVINCIBLE	ON
;	P_SET		coltab,black_c&wm
;.wlp
;	P_IMPORT	pbyte2,ebyte2
;	P_IFSAME	pbyte2,255,.act
;	P_GOTO		.wlp
;.act
;	P_SET		coltab,id_0_c&wm
;	P_INVINCIBLE	OFF

.re_start
	P_FLAGCHILD	6
	P_FLAGCHILD	7
	P_RTRIGGER	.hit_count,WhenHitByPlayer
	P_INVINCIBLE	OFF
	P_ZERO		pbyte2
	P_END
.hit_count
	P_SET		hp,100
	P_INC		pbyte2
	P_IFNOTSAME	pbyte2,5,.non_act
	P_FORCE		.act
.non_act
	P_RETURN
.act
;	P_FLAGCHILD	6
;	P_FLAGCHILD	7
	P_TRIGGER	.hit_count,OFF
	P_INVINCIBLE	ON
	P_SOUNDEFFECT	ob_core_up_down	;$95*
	P_DO		25
	P_ADD		worldy,-1<<kaku6_scale
	P_NEXT
	P_BECOMECHILD	5
	P_SLOPE		ON
	P_UNBECOME
	P_SOUNDEFFECT	leveltrig_stop	;$cb*
	P_WAIT		75
	P_BECOMECHILD	5
	P_SLOPE		OFF
	P_UNBECOME
	P_SOUNDEFFECT	ob_core_up_down	;$95*
	P_DO		25
	P_ADD		worldy,1<<kaku6_scale
	P_NEXT
	P_SOUNDEFFECT	leveltrig_stop	;$cb*
	P_GOTO		.re_start
.core_c_ck
	P_IFSAME	slopenum,2,.first_dead
	P_IFSAME	slopenum,3,.second_dead
	P_IFNOTSAME	slopenum,4,.mada
	P_FORCE		.all_dead
.mada
	P_RETURN
.first_dead
	P_TRIGGER	shock_midc,32
	P_RETURN
.second_dead
	P_TRIGGER	shock_midc,OFF
	P_TRIGGER	shock_efe,16
	P_RETURN
.all_dead
	P_SOUNDEFFECT	leveltrig_stop	;$cb*
	P_TRIGGER	.core_c_ck,OFF
	P_IGOTO		pe_carier_core.core_dead_enter

;------------
	START_PATH	e_carier_core

	P_GOSUB		hit_dead_init
	P_EXPORT	Corex,worldx
	P_EXPORT	Corez,worldz
	P_SHADOW	OFF
	P_RANGECHECK	OFF
	P_SOUND		p2_core_motor	;0F	;sdad5
	
;	P_SET		worldy,-20<<kaku_4_scale
	P_SLOPE		ON
	P_COLLISIONS	OFF

	P_SPAWN		0,-130<<kaku_4_scale,0,0,0,0,kaku4_0,e_spe_core_bt,100,4,1

	P_SPAWN		0,-20<<kaku_4_scale,30<<kaku_4_scale,0,0,0,kaku4_3,e_spe_core_c,100,0,3
	P_SPAWN		0,-20<<kaku_4_scale,-30<<kaku_4_scale,0,128,0,kaku4_3,e_spe_core_c,100,0,4
	P_SPAWN		30<<kaku_4_scale,-20<<kaku_4_scale,0,0,-64,0,kaku4_3,e_spe_core_c,100,4,5
	P_SPAWN		-30<<kaku_4_scale,-20<<kaku_4_scale,0,0,64,0,kaku4_3,e_spe_core_c,100,4,6

	P_INVINCIBLE	ON
	P_TRIGGER	reflect_laser,Always

.lp
	P_IMPORT	pbyte2,KDifficulty
	P_IFSAME	pbyte2,dif_easy,.elp
.lpp
	P_IFSAME	slopenum,2,.first_dead
	P_IFSAME	slopenum,3,.second_dead
	P_IFSAME	slopenum,4,.all_dead
	P_GOTO		.lpp
.elp
	P_IFSAME	slopenum,1,.second_dead
	P_IFSAME	slopenum,2,.all_dead
	P_GOTO		.elp
.first_dead
	P_IFNOTZERO	pbyte1,.mou1
	P_TRIGGER	shock_midc,32
	P_INC		pbyte1
.mou1
	P_GOTO		.lp
.second_dead
	P_IFSAME	pbyte1,2,.mou1
	P_TRIGGER	shock_midc,OFF
	P_TRIGGER	shock_efe,16
	P_INC		pbyte1
	P_GOTO		.lp
.all_dead
	P_FLAGCHILD	1
	P_FLAGCHILD	2
.core_dead_enter	LOCAL
	P_RADAROBJ	ra_off
	P_SCORE		sc_base_core
	P_CIRCLEWINDOW	1,big
	P_SOUNDEFFECT	bs_core_death	;$2b*
	P_GDEC		b,KEnemyNumber
	P_GDEC		b,CurrentEEnemyNumber
	P_COLLISIONS	OFF
	P_SCREENFLASH
	P_SOUND		port2_stop	;00
	P_RTRIGGER	.cari_core_explode,4
.fl
	P_RANDOMGOTO	.nfl
	P_RANDOMGOTO	.nfl
	P_HITFLASHTRIG
	P_SOUNDEFFECT	en_explode_demo	;$8b
	P_SHOCKCAM	1,128
.nfl
	P_GOTO		.fl

.cari_core_explode
	P_GOSUB		core_explode
	P_BECOME
	P_ADD		slopenum,4
	P_UNBECOME
	P_RETURN

;------------
	START_PATH	e_spe_core_bt
	P_RTRIGGER	.core_rot,ALways
	P_INVINCIBLE	ON
	P_TRIGGER	reflect_laser,Always
	P_SHADOW	OFF
	P_COLLISIONS	OFF
	P_MOVEPLAYER	ON
.lp
	P_IFFLAG	.dead
	P_GOTO		.lp
.dead
	P_TRIGGER	.core_rot,OFF

.flashing	LOCAL
	P_RANDOMGOTO	.nfl
	P_RANDOMGOTO	.nfl
	P_HITFLASHTRIG
.nfl
	P_GOTO		.flashing

.core_rot
	P_ADD		childroty,8
;	P_DEC		childroty
	P_RETURN
;------------
	START_PATH	e_spe_core_c

	P_SHADOW	OFF
	P_IMPORT	pbyte1,KDifficulty
	P_IFNOTSAME	pbyte1,dif_easy,.not_easy
	P_IFZERO	ap,.easy
.not_easy
	P_SET		ap,4


	P_GOSUB		crose_door_wait
	P_RTRIGGER	.hit,WhenHit
	P_SETRANDOM	pbyte2,31
.lp
	P_INC		pbyte2
	P_IFSAME	pbyte2,32,.atack
	P_GOTO		.lp
.atack
	P_ZERO		pbyte2
	P_PLAYERINCONE	100,.on
	P_GOTO		.lp
.on
	P_SPAWN		0,-7<<kaku_4_scale,14<<kaku_4_scale,0,0,0,ring_mark,e_kaku_fire,100,1,9
	P_GOTO		.lp
.hit
	P_SET		pbyte1,90
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_TRIGGER	.hit,OFF
	P_COLLISIONS	OFF
	P_GOSUB		s_group_explode
	P_QSPAWN	kaku4_4,e_exp_self,100,0
	P_BECOMEMOTHER
	P_INC		slopenum
	P_EXPORT	gbyte1,slopenum
	P_UNBECOME
	P_IMPORT	pbyte1,gbyte1
	P_SET		pbyte2,25
	P_DO		pbyte1
	P_ADD		pbyte2,-5
	P_INEXT
	P_SET		pbyte1,pbyte2
	P_TRIGGER	mk_spark_core,4		;Always

	P_GOSUB		fire_cansel
.easy
	P_COLLISIONS	OFF
	P_SET		shape,kaku4_4

	P_END
;;;;	P_IGOTO		pe_spe_core_bt.flashing
mk_spark_core
	P_DEC		pbyte2
	P_IFNOTZERO	pbyte2,.nosp
	P_GOSUB		mk_many_spark_core
	P_SET		pbyte2,pbyte1
.nosp
	P_RETURN
;------------
	START_PATH	e_exp_self

	P_EXPLODE
;------------
	START_PATH	e_base_core_2

	P_SET		skidy,hp
	P_DEC		skidy
	P_GOSUB		init_hardslope_soff
	P_EXPORT	Corex,worldx
	P_EXPORT	Corez,worldz
	P_COLLISIONS	OFF
	P_SPAWN		0,-20<<kaku5_scale,0,0,0,0,kaku_0_c,e_base_core2_c,125,4,1
	P_SPAWN		0,0,0,0,0,0,kaku5_1,e_base_core_cover,100,4,2

.wlp
	P_IFLARGER	pbyte2,skidy,.all
	P_GOTO		.wlp
.all
	P_FLAGCHILD	2
	P_WAIT		50
	P_FLAGCHILD	1
.at_lp
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFZERO	pbyte1,.end
	P_GOSUB		pe_base_core.atack
	P_WAIT		32
	P_GOTO		.at_lp
.end
	P_END
;------------
	START_PATH	e_base_core_kado

	P_GOSUB		col_id_ck
	P_GOSUB		wakidashi_init
	P_COLLISIONS	OFF
	P_SPAWN		0,20<<kaku5_scale,0,0,0,0,kaku5_2,e_buil_shadow_off,10,10,1


	P_GOSUB		crose_door_wait

	P_RTRIGGER	.dead,WhenHitByPlayer

;.wlp
;	P_IMPORT	pbyte1,ebyte2
;	P_IFSAME	pbyte1,255,.act
;	P_GOTO		.wlp
;.act
	P_COLLISIONS	ON
.atack
	P_WAIT		20
.passat
	P_WAIT		1
	P_RANDOMGOTO	.passat
	P_SPAWN		-100,0,100,0,0,0,ring_mark,e_ring_mark_child,10,10,11
;;	P_GOSUB		ring_fire_must_stay
	P_GOTO		.atack
.dead
	P_SET		pbyte1,95
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.dead_change
.ok
	P_RETURN
.dead_change
	P_TRIGGER	.dead,OFF
	P_QSPAWN	kaku5_3,e_damy_exp,100,0
	P_SET		shape,kaku5_4
	P_FINDSHAPE	kaku5_0
	P_BECOMESHAPE
	P_INC		pbyte2
	P_UNBECOME
	P_RADAROBJ	ra_off
	P_COLLISIONS	OFF
	P_REMOVE	11
	P_END
;------------
	START_PATH	e_base_core_cover

	P_GOSUB		init_hardslope_soff
	P_RTRIGGER	.act,WhenFlagged
	P_END
.act
	P_FORCE		.cl
	P_RETURN
.cl
	P_WAIT		15
	P_CLIPPING	ON
	P_SOUNDEFFECT	ob_core_up_down	;$95*
	P_SOUNDEFFECT	bs_core_cover_down	;$ba
	P_DO		20
	P_ADD		childroty,4
	P_ADD		childy,2<<kaku5_scale
	P_NEXT
	P_SLOPE		OFF
	P_SOUNDEFFECT	leveltrig_stop	;$cb*
	P_SOUNDEFFECT	stop_tr2	;$cd
	P_REMOVE
;------------
	START_PATH	e_base_core2_c

	P_INVINCIBLE	ON
	P_SET		coltab,black_c&wm
.wlp
	P_IFFLAG	pe_base_core_c.act
	P_GOTO		.wlp
;------------
	START_PATH	e_base_core

	P_GOSUB		hit_dead_init
	P_EXPORT	Corex,worldx
	P_EXPORT	Corez,worldz
	P_COLLISIONS	OFF
	P_SLOPE		ON
	P_SPAWN		0,-19<<kaku_scale,0,0,0,0,kaku_0_c,e_base_core_c,125,4,1
	P_RTRIGGER	.dead,WHenFlagged
.wlp
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,255,.act
	P_GOTO		.wlp
.act
	P_GOSUB		.atack
	P_WAIT		15
	P_RTRIGGER	.atack,32
	P_END
.dead
	P_FORCE		.dead_on
	P_RETURN
.dead_on
	P_TRIGGER	.atack,OFF
	P_TRIGGER	.dead,OFF
	P_RADAROBJ	ra_off
	P_END

.atack	LOCAL
	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		0,-35<<kaku_scale,0,0,0,0,ring_mark,e_kaku_fire,100,1,2
	P_BECOME
	P_IMPORT	ap,gbyte1
	P_INDEX		childx,b_core_cx,ap
	P_INDEX		childz,b_core_cz,ap
	P_ADD		ap,2
	P_SETID		ap
	P_DEC		ap
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT

;	P_SPAWN		0,-35<<kaku_scale,35<<kaku_scale,0,0,0,ring_mark,e_kaku_fire,100,1,2
;	P_SPAWN		0,-35<<kaku_scale,-35<<kaku_scale,0,0,0,ring_mark,e_kaku_fire,100,2,3
;	P_SPAWN		35<<kaku_scale,-35<<kaku_scale,0,0,0,0,ring_mark,e_kaku_fire,100,3,4
;	P_SPAWN		-35<<kaku_scale,-35<<kaku_scale,0,0,0,0,ring_mark,e_kaku_fire,100,4,5
	P_RETURN
;------------
	START_PATH	e_kaku_fire

	P_COLLISIONS	OFF
	P_RTRIGGER	.rem_ck,Always
	P_DO		ap
	P_WAIT		5
	P_NEXT
	P_SPRITE	0,4
	P_DO		16
	P_ADD		tx,2
	P_NEXT
	P_WEAPON	ERing
;	P_IMPORT	pbyte2,KDifficulty
;	P_IFSAME	pbyte2,dif_easy,.easy
	P_GOSUB		sos_fire_must
.rem
	P_REMOVE
;.easy
;	P_FACEPLAYER	IMMEDIATE
;	P_SETRANDOM	pbyte1,63
;	P_ADD		pbyte1,-32
;	P_ADD		roty,pbyte1
;	P_FIRE
;	P_REMOVE
.rem_ck
	P_IFZERO	pbyte1,.ok
	P_FORCE		.remm
.ok
	P_RETURN
.remm
	P_TRIGGER	.rem_ck,OFF
	P_REMOVE
;------------
	START_PATH	e_base_core_c

	P_INVINCIBLE	ON
	P_SET		coltab,black_c&wm
.wlp
	P_IMPORT	pbyte1,ebyte2
	P_IFSAME	pbyte1,255,.act
	P_GOTO		.wlp
.act	LOCAL
	P_SET		coltab,id_0_c&wm
	P_INVINCIBLE	OFF
	P_RTRIGGER	.hit,WhenHit
.lp
	P_ADD		childroty,8
	P_GOTO		.lp
.hit
	P_SET		pbyte1,105
	P_IFLARGER	hp,pbyte1,.ok
	P_IFSAME	coltab,id_1_c,.sh1
	P_TRIGGER	shock_efe,32
.sh1
	P_SET		coltab,id_1_c
	P_ENEMYDMGSE	en_core_dmg_big	;$65
	P_SET		pbyte1,75
	P_IFLARGER	hp,pbyte1,.ok
	P_TRIGGER	.hit,OFF
	P_FORCE		.dead
.ok
	P_RETURN
.dead
	P_FLAGMOTHER
	P_QSPAWN	kaku_0_c,e_damy_exp,100,0
	P_CIRCLEWINDOW	1,big
	P_SOUNDEFFECT	bs_core_death	;$2b*
	P_SCORE		sc_base_core
	P_GDEC		b,KEnemyNumber
	P_GDEC		b,CurrentEEnemyNumber
	P_INVISIBLE	ON
	P_COLLISIONS	OFF
	P_SCREENFLASH
	P_TRIGGER	core_explode,4
.fl
	P_RANDOMGOTO	.nfl
	P_RANDOMGOTO	.nfl
	P_HITFLASHTRIG
	P_SOUNDEFFECT	en_explode_demo	;$8b
	P_SHOCKCAM	1,128
.nfl
	P_GOTO		.fl
;---------
	START_PATH	e_damy_exp

	P_EXPLODE
	
;;;;-------------
;;;;-------------
;;;;------------- NEW SPEC NI YORU SPACE ENEMY
;;;;-------------
;;;;-------------
	START_PATH	e_sos_jyouge_mustwork

	P_GOSUB		make_sw_num_hofap
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty

	P_GOSUB		set_hp100_ap4_enemy
	P_WEAPON	Elaser
	P_SET		pbyte1,80
	P_SET		pword1,-120<<1
	P_SET		pbyte2,9
	P_EXPORT	gbyte2,pbyte2
	P_SET		pbyte2,1
	P_GOSUB		make_boost
	P_RTRIGGER	.jyouge_hit,WhenHit
	P_SET		tx,3
	P_SET		ty,2
	P_TRIGGER	fly_wave,Always
	P_TRIGGER	far_rem_ck,32

	P_SET		childrotz,1
	P_QUADVECS	ON
	P_SETVEL	junko_speed		;12

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_enkin

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128

.wlp
	P_WITHINRADIUS	action_dist,.act
	P_DISTMORE	14000,.towlp
	P_IMPORT	pbyte1,eaction1
	P_IFSAME	pbyte1,255,.act
.towlp
	P_GOTO		.wlp
;----------
.act
	P_GSET		b,eaction1,255
	P_SETRANDOM	pbyte1,3
	P_INDEX		pbyte2,every_90,pbyte1
	P_RTRIGGER	.to_center,128
;	P_ACCEL		63,2
	P_ACCEL		63,30
	P_SPACESHIP	ON

;;;	P_TRIGGER	.pl_dist,Always

	P_RANDOMGOTO	.nez
	P_WAITCHASE	rotz,24
	P_IGOTO		.w8
.nez
	P_WAITCHASE	rotz,-24
.w8
	P_WAIT		8
	P_SET		tx,-2
	P_SET		ty,4
	P_WAITCHASE	rotz,0

	P_GOSUB		.make_circle_angle
	P_RTRIGGER	.circle_angle,Always

	P_RTRIGGER	.make_circle_angle,128
	P_RTRIGGER	.to_sos_fire_must2,32
	P_END
.go_center
	P_TRIGGER	.to_center,OFF
	P_TRIGGER	fly_wave,OFF
	P_DO		32
	P_CHASE		worldy,0
	P_NEXT
	P_RTRIGGER	.to_center,128
	P_TRIGGER	fly_wave,Always
	P_END
.to_center
	P_FORCE		.go_center
	P_RETURN
.to_sos_fire_must2
	P_RANDOMGOTO	.pass_f
	P_DISTMORE	10000,.pass_f
	P_GOSUB		sos_fire_must2
.pass_f
	P_RETURN

.circle_angle
	P_CHASE		rotz,childrotz
	P_DIV2		pbyte1
	P_CHASE		rotx,pbyte1
	P_RETURN

.make_circle_angle
	P_SETRANDOM	childrotx,7
	P_INDEX		childrotz,jyouge_turntab,childrotx
	P_RETURN

;.pl_dist
;	P_DISTMORE	13000,.ook
;	P_DISTMORE	3000,.ok
;	P_MOVEINPLAYER	-100
;	P_RETURN
;.ok
;	P_DISTLESS	10000,.ook
;	P_MOVEINPLAYER	100
;.ook
;	P_RETURN

;jyouge_turn
;	db	4,-4,8,-8,12,-12,16,-16

;;;	P_ACCEL		60,2		;35,2
;;;	P_RANDOMGOTO	.pas2
;;;.lp
;;;	P_TRIGGER	sos_fire_must2,16
;;;	P_RANDOMGOTO	.pas1
;;;	P_WAIT		30
;;;.pas1
;;;	P_GOSUB		go_up
;;;	P_TRIGGER	sos_fire_must2,OFF
;;;	P_GOSUB		cyokushin
;;;	P_TRIGGER	sos_fire_must2,16
;;;	P_RANDOMGOTO	.pas2
;;;	P_WAIT		30
;;;.pas2
;;;	P_GOSUB		go_down
;;;	P_TRIGGER	sos_fire_must2,OFF
;;;	P_GOSUB		cyokushin
;;;	P_GOTO		.lp
;-----------
.jyouge_hit
	P_FORCE		.life_out
	P_RETURN
.life_out
	P_TRIGGER	.jyouge_hit,OFF
	P_TRIGGER	.to_center,OFF
	P_RELTOPLAYER	OFF
	P_GOSUB		fighter_count_gset
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
;	P_CLRDEMOSHAPE
;	P_SCREENFLASH
;	P_GSET		b,eaction1,255
	P_SCORE		sc_enkin
	P_REMOVE	9
	P_COLLISIONS	OFF
	P_GOSUB		sos_group_explode
	P_EXPLODE
;;;;--------- SOS_STRONG NINJYA NO NEW TYPE
	START_PATH	e_sos_new_strong3

	P_SET		skidy,hp
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_GOSUB		init_sos_zaco
	P_GOSUB		set_hp100_ap4_enemy
	P_WEAPON	HomEmissile
	P_SET		childrotx,95
	P_SET		tx,3
	P_SET		ty,2
	P_TRIGGER	fly_wave,Always
	P_RTRIGGER	.new_strong_liveck,WhenHit
	P_RTRIGGER	.new_strong_liveck2,WhenHit

	P_QUADVECS	ON
	P_SETVEL	junko_speed		;12

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_sos_1

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128

.wlp
	P_WITHINRADIUS	action_dist-2000,.act
	P_DISTMORE	14000,.towlp
	P_IMPORT	pbyte1,eaction1
	P_IFSAME	pbyte1,254,.act
.towlp
	P_GOTO		.wlp
.act
	P_TRIGGER	.new_strong_liveck2,OFF
	P_RTRIGGER	.pl_dist,Always
	P_RTRIGGER	.laser_fire,128
	P_SET		pbyte1,255
	P_EXPORT	eaction1,pbyte1

	P_ACCEL		60,2			;35,2
	P_RANDOMGOTO	.st_up
	P_WAITCHASE	rotx,16
	P_IGOTO		.tu
.st_up
	P_WAITCHASE	rotx,-16
.tu
	P_SPACESHIP	ON
	P_GOSUB		decide_angle_slonum_s
	P_GOSUB		slonum_rz_waitchase
.tofl
	P_IFNOTBETWEEN	-3800,worldy,3800,.fl
	P_GOTO		.tofl
.fl
	P_WAITCHASE	rotx,0
	P_ZERO		childz
	P_TRIGGER	missile_fire_l_ran,64
.koi
	P_INC		childz
	P_IFSAME	childz,50,.change_circle
	P_IFSAME	childz,100,.change_circle
	P_IFSAME	childz,150,.kita
	P_IMPORT	pword1,Player1_worldy
	P_NEG		pword1
	P_ADD		pword1,worldy
	P_IFBETWEEN	-3000,pword1,3000,.kita
	P_GOTO		.koi
.change_circle
	P_GOSUB		decide_angle_slonum_s
	P_GOSUB		slonum_rz_waitchase
	P_IGOTO		.koi

.kita
	P_TRIGGER	missile_fire_l_ran,OFF
	P_ZERO		pword1
	P_IFLARGER	worldy,pword1,.go_up

	P_ZERO		slopenum
.go_same
	P_DO		12
	P_INDEX		pbyte1,costab,slopenum
	P_ADD		worldy,pbyte1
	P_DIV2		pbyte1
	P_CHASE		rotx,pbyte1
	P_INC		slopenum
	P_NEXT

	P_IGOTO		.tofl
.go_up
	P_SET		slopenum,128
	P_IGOTO		.go_same

.laser_fire
	P_PUSH		pbyte1
	P_IMPORT	pbyte1,KDifficulty
	P_IFSAME	pbyte1,dif_easy,.k_pass
	P_TRIGGER	kirai_maku,16,50
.k_pass
	P_PULL		pbyte1
	P_RETURN
.pl_dist
	P_DISTLESS	7000,.ok
	P_PUSH		worldy
	P_IMPORT	worldy,Player1_worldy
	P_MOVEINPLAYER	100
	P_PULL		worldy
.ok
	P_RETURN

.new_strong_liveck2
	P_SET		pbyte1,254
	P_EXPORT	eaction1,pbyte1
	P_RETURN
.new_strong_liveck
	P_IFLARGER	hp,childrotx,.live_ok1
	P_ADD		childrotx,-5
	P_QSPAWN	smoke,e_sos_almost,3,0
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_IFNOTBETWEEN	0,hp,80,.live_ok1
	P_FORCE		.next_step
.live_ok1
	P_RETURN
.next_step
	P_TRIGGER	.new_strong_liveck,OFF
	
	P_IGOTO		pe_sos_new_strong1.new_strong_dead
;------------
;;;cyokushin
;;;	P_SPACESHIP	ON
;;;.face_more
;;;	P_PUSH		roty
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_SET		childroty,roty
;;;	P_ZERO		rotx
;;;	P_PULL		roty
;;;	P_NEG		childroty
;;;	P_ADD		childroty,roty
;;;	P_IFBETWEEN	-5,childroty,5,.faceok
;;;	P_CHASE		rotz,slopenum
;;;	P_GOTO		.face_more
;;;.faceok
;;;	P_SPACESHIP	OFF
;;;	P_WAITCHASE	rotz,0
;;;	P_GOSUB		missile_fire_l
;;;	P_RETURN

missile_fire_l_ran
	P_RANDOMGOTO	missile_fire_l.pass
missile_fire_l
	P_GOSUB		sos_fire_must
	P_BECOME
	P_SET		skidy,2
	P_UNBECOME
.pass	LOCAL
	P_RETURN

;;;go_up
;;;	P_SPACESHIP	ON
;;;	P_SET		rotz,4
;;;	P_SET		slopenum,16
;;;	P_RANDOMGOTO	.neg_z11
;;;	P_NEG		rotz
;;;	P_NEG		slopenum
;;;.neg_z11
;;;	P_WAITCHASE	rotx,-50
;;;.neg_z1
;;;	P_IFNOTBETWEEN	-3800,worldy,3800,.end_upp
;;;	P_GOTO		.neg_z1
;;;.end_upp
;;;	P_IFNOTZERO	childrotz,.end_up
;;;	P_TRIGGER	missile_fire_l_ran,16
;;;.end_up
;;;	P_SPACESHIP	OFF
;;;	P_CHASE		rotz,0
;;;	P_ADD		worldy,40
;;;	P_CHASE		rotx,0
;;;	P_IFBETWEEN	-3700,worldy,3700,.inside
;;;	P_GOTO		.end_up
;;;.inside
;;;	P_IFNOTZERO	childrotz,.ret
;;;	P_TRIGGER	missile_fire_l_ran,OFF
;;;.ret
;;;	P_RETURN
;;;
;;;go_down
;;;	P_SPACESHIP	ON
;;;	P_SET		rotz,4
;;;	P_SET		slopenum,16
;;;	P_RANDOMGOTO	.neg_z22
;;;	P_NEG		rotz
;;;	P_NEG		slopenum
;;;.neg_z22
;;;	P_WAITCHASE	rotx,50
;;;.neg_z2
;;;	P_IFNOTBETWEEN	-3800,worldy,3800,.end_downn
;;;	P_GOTO		.neg_z2
;;;.end_downn
;;;	P_IFNOTZERO	childrotz,.end_down
;;;	P_TRIGGER	missile_fire_l_ran,16
;;;.end_down
;;;	P_SPACESHIP	OFF
;;;	P_CHASE		rotz,0
;;;	P_ADD		worldy,-40
;;;	P_CHASE		rotx,0
;;;	P_IFBETWEEN	-3700,worldy,3700,.inside2
;;;	P_GOTO		.end_down
;;;.inside2
;;;	P_IFNOTZERO	childrotz,.ret
;;;	P_TRIGGER	missile_fire_l_ran,OFF
;;;.ret
;;;	P_RETURN
;;;
;;;;--------- SOS_STRONG 2 NO NEW TYPE
	START_PATH	e_sos_new_strong2

	P_SET		skidy,hp
	P_GOSUB		CurrentSw_Skidy_ck
	P_GOSUB		make_bit
	P_IFZERO	pword1,.csok
	P_INVISIBLE	ON
	P_SET		hp,100
	P_WAIT		3
	P_GOSUB		c_flag_234
;	P_FLAGCHILD	2
;	P_FLAGCHILD	3
;	P_FLAGCHILD	4
	P_FLAGCHILD	5
	P_WAIT		20
	P_GOSUB		c_unlink_234
;	P_UNLINKCHILD	2
;	P_UNLINKCHILD	3
;	P_UNLINKCHILD	4
	P_UNLINKCHILD	5
	P_WAIT		3
	P_REMOVE
.csok
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	
	P_GOSUB		init_sos_zaco
	P_WEAPON	Eplasma1
	P_GOSUB		set_hp100_ap4_enemy
	P_SET		childrotx,95
	P_SET		tx,3
	P_SET		ty,2

	P_SET		pbyte2,1
	P_EXPORT	gbyte2,pbyte2
	P_SET		pword1,-140<<1
	P_SET		pbyte1,60
	P_GOSUB		make_boostbig

	P_ZERO		pbyte2
	P_RTRIGGER	.new_strong_liveck2,WhenHit
	P_RTRIGGER	.new_strong_liveck,WhenHit
	P_TRIGGER	far_rem_ck,32

	P_QUADVECS	ON
	P_SETVEL	junko_speed		;12

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_sos_2

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128

	P_WAIT		3
.wlp
	P_WITHINRADIUS	action_dist,.act
	P_IMPORT	slopenum,eaction1
	P_IFSAME	slopenum,255,.act
	P_GOTO		.wlp
;------------
.new_strong_liveck2
	P_SET		hp,100
	P_PUSH		pbyte1
	P_SET		pbyte1,255
	P_EXPORT	eaction1,pbyte1
	P_PULL		pbyte1
	P_RETURN

.new_strong_liveck
	P_IFLARGER	hp,childrotx,.live_ok1
	P_ADD		childrotx,-5
	P_QSPAWN	smoke,e_sos_almost,3,0
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
.live_ok1
	P_IFNOTBETWEEN	0,hp,94,.live_ok2
	P_FORCE		.next_step
.live_ok2
	P_RETURN
;------------
.act
	P_ZERO		slopenum
	P_EXPORT	eaction1,slopenum
	P_TRIGGER	sos_fire_must,OFF

;	P_BECOMECHILD	1
;	P_ADD		tx,50
;	P_UNBECOME
;
;	P_ACCEL		run_speed,2		;40,2

	P_CHILDDEAD	2,.ni
	P_FLAGCHILD	2
	P_WAIT		15
	P_UNLINKCHILD	2
	P_GOTO		.run
.ni
	P_CHILDDEAD	3,.san
	P_FLAGCHILD	3
	P_WAIT		15
	P_UNLINKCHILD	3
	P_GOTO		.run
.san
	P_CHILDDEAD	4,.yon
	P_FLAGCHILD	4
	P_WAIT		15
	P_UNLINKCHILD	4
	P_GOTO		.run
.yon
	P_CHILDDEAD	5,.fight
	P_FLAGCHILD	5
	P_WAIT		15
	P_UNLINKCHILD	5
.run
	P_ACCEL		60,10
	P_TRIGGER	sos_fire_must,32
	P_ZERO		pword1
	P_IFLARGER	worldy,pword1,.go_up

	P_ZERO		slopenum
	P_SET		pbyte2,128
.go_same
	P_DO		12
	P_INDEX		pbyte1,costab,slopenum
	P_ADD		worldy,pbyte1
	P_DIV2		pbyte1
	P_CHASE		rotx,pbyte1
	P_INC		slopenum
	P_NEXT
.tofl
	P_IFNOTBETWEEN	-3300,worldy,3300,.fl
	P_GOTO		.tofl
.go_up
	P_SET		slopenum,128
	P_ZERO		pbyte2
	P_IGOTO		.go_same

.fl
	P_ACCEL		junko_speed,10
	P_WAITCHASE	rotx,0

	P_WAIT		10				;20
	P_ACCEL		junko_speed,2			;12,2
	P_GOTO		.wlp
;----------
.fight
	P_ACCEL		60,2
	P_TRIGGER	.new_strong_liveck2,OFF
	P_SET		hp,100
	P_RTRIGGER	.pl_dist,Always
	P_SET		slopenum,1
.re_sta
	P_NEG		slopenum
	P_IFSAME	slopenum,1,.tri
	P_PUSH		rotx
	P_PUSH		roty
	P_FACEPLAYER	IMMEDIATE
	P_SET		childroty,roty
	P_ADD		childroty,-64
	P_PULL		roty
	P_PULL		rotx
.st_f1
	P_CHASE		roty,childroty
	P_IFSAME	roty,childroty,.to_f_lp
	P_GOTO		.st_f1
.tri
	P_PUSH		rotx
	P_PUSH		roty
	P_FACEPLAYER	IMMEDIATE
	P_SET		childroty,roty
	P_ADD		childroty,64
	P_PULL		roty
	P_PULL		rotx
.st_f2
	P_CHASE		roty,childroty
	P_IFSAME	roty,childroty,.to_f_lp
	P_GOTO		.st_f2
.to_f_lp
	P_SET		tx,-1
	P_SET		ty,2
	P_ZERO		pbyte1
	P_TRIGGER	fly_wave,Always
	P_ZERO		childx
.f_lp
	P_INC		childx
	P_IFSAME	childx,128,.change_on
	P_DIV2		pbyte1
	P_CHASE		rotx,pbyte1
	P_IFSAME	slopenum,1,.ri
	P_CIRCLEPLAYER	1
	P_PUSH		rotx
	P_PUSH		rotz
	P_FACEPLAYER	IMMEDIATE
	P_ADD		roty,-64
	P_PULL		rotz
	P_PULL		rotx
	P_GOTO		.f_lp
.ri
	P_CIRCLEPLAYER	-1
	P_PUSH		rotx
	P_PUSH		rotz
	P_FACEPLAYER	IMMEDIATE
	P_ADD		roty,64
	P_PULL		rotz
	P_PULL		rotx
	P_GOTO		.f_lp
.pl_dist
	P_DISTMORE	5000,.ok
	P_PUSH		worldy
	P_IMPORT	worldy,Player1_worldy
	P_MOVEINPLAYER	-100
	P_PULL		worldy
;.ok
	P_RETURN
.ok
	P_DISTLESS	10000,.ookk
	P_DISTMORE	15000,.ookk
	P_PUSH		worldy
	P_IMPORT	worldy,Player1_worldy
	P_MOVEINPLAYER	100
	P_PULL		worldy
.ookk
	P_RETURN
.far_dist2
	P_PUSH		worldy
	P_IMPORT	worldy,Player1_worldy
	P_MOVEINPLAYER	-50
	P_PULL		worldy
	P_RETURN

.change_on
	P_TRIGGER	sos_fire_must,16
	P_GOSUB		sos_fire_must
	P_TRIGGER	fly_wave,OFF
	P_ACCEL		0,5
	P_ZERO		pword1
	P_SET		childx,-2000
	P_SET		childrotx,-64
	P_ZERO		pbyte2
	P_IFLARGER	worldy,pword1,.go_ue
	P_NEG		childx
	P_NEG		childrotx
	P_SET		pbyte2,128
.go_ue
	P_CHASE		worldy,childx
	P_CHASE		rotx,childrotx
	P_NEG		pword1
	P_ADD		pword1,worldy
	P_IFBETWEEN	-100,pword1,100,.cha_end
	P_SET		pword1,worldy
	P_GOTO		.go_ue
.cha_end	
	P_ACCEL		60,5
	P_WAITCHASE	rotx,0
	P_TRIGGER	sos_fire_must,OFF
	P_IGOTO		.re_sta
.next_step
;;;	P_TRIGGER	.hi_change,OFF
	P_TRIGGER	.new_strong_liveck,OFF
	P_IGOTO		pe_sos_new_strong1.new_strong_dead
;make_bit
;	P_ADD		skidy,7
;	P_EXPORT	gbyte1,skidy
;	P_ADD		skidy,-7
;	P_IFSAME	ap,1,.make1
;	P_IFSAME	ap,2,.make2
;	P_IFSAME	ap,3,.make3
;	P_SPAWN		500<<2,0,0,0,0,0,kieru_0,e_bit_kieru,100,0,2
;	P_GOSUB		.beco
;.make3
;	P_SPAWN		-500<<2,0,0,0,0,0,kieru_0,e_bit_kieru,100,0,3
;	P_GOSUB		.beco
;.make2
;	P_SPAWN		0,0,500<<2,0,0,0,kieru_0,e_bit_kieru,100,128,4
;	P_GOSUB		.beco
;.make1
;	P_SPAWN		0,0,-500<<2,0,0,0,kieru_0,e_bit_kieru,100,128,5
;	P_GOSUB		.beco
;	P_RETURN

;.beco
;	P_BECOME
;	P_IMPORT	skidy,gbyte1
;	P_UNBECOME
;	P_GINC		b,gbyte1
;	P_RETURN

;-----------
	START_PATH	e_bit_kieru

	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_SET		pbyte2,ap
	P_SET		ap,4
	P_RANGECHECK	OFF
	P_RADAROBJ	ra_enemy
	P_WEAPON	Elaser
	P_SET		tx,1
	P_SET		ty,4
	P_IMPORT	pbyte1,CREDITS_ON
	P_IFNOTZERO	pbyte1,.cr
	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128
	P_IGOTO		.not_cr	
.cr
	P_RTRIGGER	.cr_che,64
	P_IFZERO	pbyte2,.not_cr
	P_SET		shape,kieru_1
.not_cr
	P_TRIGGER	sos_dead,WhenHit
	P_TRIGGER	fly_wave_c,Always
.lp
	P_CIRCLE	16
	P_IFFLAG	.bit_kie_on
	P_GOTO		.lp
.bit_kie_on
	P_TRIGGER	fly_wave_c,OFF
	P_TRIGGER	fly_wave,Always
	P_SET		tx,2
	P_SET		ty,8
	P_TRIGGER	marker_set,ALways
;	P_COLLISIONS	OFF
	P_DO		20
	P_MOVEIN	-30
	P_NEXT
	P_RTRIGGER	.kieru_spin,Always
	P_RELTOPLAYER	ON
.move_again
	P_GOSUB		sos_fire_must
	P_WAIT		10
	P_GOSUB		sos_fire_must
	P_WAIT		10
	P_GOSUB		.kie_sh_change
	P_COLLISIONS	OFF

	P_PUSH		worldx
	P_PUSH		worldy
	P_PUSH		worldz

	P_COPYPLAYERPOS

	P_SET		childx,worldx
	P_SET		childy,worldy
	P_SET		childz,worldz

	P_SETRANDOM	pword1,1023
	P_ADD		pword1,3000
	P_RANDOMGOTO	.neg1
	P_NEG		pword1
.neg1
	P_ADD		childx,pword1

	P_SETRANDOM	pword1,1023
	P_ADD		pword1,3000
	P_RANDOMGOTO	.neg2
	P_NEG		pword1
.neg2
	P_ADD		childy,pword1

	P_SETRANDOM	pword1,1023
	P_ADD		pword1,3000		;2000
	P_RANDOMGOTO	.neg3
	P_NEG		pword1
.neg3
	P_ADD		childz,pword1
	P_PULL		worldz
	P_PULL		worldy
	P_PULL		worldx

	P_DO		16
	P_CHASE		worldx,childx
	P_CHASE		worldy,childy
	P_CHASE		worldz,childz
	P_NEXT

	P_COLLISIONS	ON
	P_GOSUB		.kie_sh_change
	P_GOTO		.move_again
.cr_che	
	P_TRIGGER	.cr_on,Always,15
	P_RETURN
.cr_on
	P_GOSUB		.che
	P_RETURN
.kieru_spin
	P_ADD		roty,16
	P_RETURN

.kie_sh_change
	P_SOUNDEFTDISTPOS	en_kieru	;$8f
	P_DO		15
	P_GOSUB		.che
	P_NEXT
	P_RETURN
.che
	P_IFSAME	shape,kieru_0,.set_ki_1
	P_SET		shape,kieru_0
	P_IGOTO		.n
.set_ki_1
	P_SET		shape,kieru_1
.n
	P_RETURN
;;;;--------- SOS_STRONG 1 NO NEW TYPE
	START_PATH	e_sos_new_strong1

	P_SET		skidy,hp
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_GOSUB		init_sos_zaco
	P_GOSUB		set_hp100_ap4_enemy
	P_WEAPON	Eplasma1
	P_SET		childrotx,95
	P_SET		tx,3
	P_SET		ty,2
	P_TRIGGER	fly_wave,Always

	P_RTRIGGER	.new_strong_liveck,WhenHit
	P_RTRIGGER	.new_strong_liveck2,WhenHit

	P_QUADVECS	ON
	P_SETVEL	12

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_sos_1

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128
.wlp
	P_WITHINRADIUS	action_dist-2000,.act
	P_IMPORT	pbyte1,eaction1
	P_IFSAME	pbyte1,254,.act
	P_GOTO		.wlp
;------------
.new_strong_liveck2
	P_SET		pbyte1,254
	P_EXPORT	eaction1,pbyte1
	P_RETURN

.new_strong_liveck
	P_IFLARGER	hp,childrotx,.live_ok1
	P_ADD		childrotx,-5
	P_QSPAWN	smoke,e_sos_almost,3,0
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_IFNOTBETWEEN	0,hp,70,.live_ok1
	P_FORCE		.next_step
.live_ok1
	P_RETURN
;------------
.act
	P_TRIGGER	.new_strong_liveck2,OFF
	P_SET		pbyte1,255
	P_EXPORT	eaction1,pbyte1
	P_ACCEL		60,2			;35,2
	P_SPACESHIP	ON
	P_RANDOMGOTO	.hi
	P_WAITCHASE	rotx,16
	P_IGOTO		.fl
.hi
	P_WAITCHASE	rotx,-16
.fl
	P_GOSUB		decide_angle_slonum
	P_GOSUB		slonum_rz_waitchase
.face_lp
	P_PLAYERINCONE	30,.face_ok
	P_GOTO		.face_lp
.face_ok
	P_SET		tx,-1
	P_SET		ty,2
	P_SPACESHIP	OFF
	P_WAITCHASE	rotx,0
	P_WAITCHASE	rotz,0
	P_SETRANDOM	slopenum,7
	P_ADD		slopenum,8
.go_far
	P_CHASE		rotx,0
	P_DISTLESS	4000,.not_slofi
	P_GOSUB		.slonum_fire_16
.not_slofi
	P_DISTMORE	10000,.turn
	P_GOTO		.go_far
.turn
	P_ACCEL		0,10
	P_RELTOPLAYER	ON
	P_INPLAYERSCONE	-30,30,.turn_on
	P_GOTO		.turn
.turn_on
	P_RELTOPLAYER	OFF
	P_ACCEL		25,25
	P_SPACESHIP	ON
	P_GOSUB		decide_angle_slonum_s
	P_GOSUB		slonum_rz_waitchase
	P_IMPORT	slopenum,KDifficulty
	P_IFSAME	slopenum,dif_easy,.nf
	P_RTRIGGER	.slonum_fire_16,Always
.nf
	P_SETRANDOM	slopenum,7
	P_ADD		slopenum,8
.face_lp2
	P_PLAYERINCONE	10,.face_ok2
	P_GOTO		.face_lp2
.face_ok2
	P_ACCEL		60,30			;25,2
	P_SPACESHIP	OFF
	P_WAITCHASE	rotz,0
	P_SETRANDOM	slopenum,1
.come_lp
	P_DISTLESS	3000,.to_go_far
	P_DISTLESS	10000,.face_xmo
	P_FACEPLAYER	y
	P_GOTO		.come_lp
.face_xmo
	P_IFSAME	slopenum,1,.lef
	P_FACEPLAYEROFS	127,0,0
	P_GOTO		.come_lp
.lef
	P_FACEPLAYEROFS	-127,0,0
	P_GOTO		.come_lp
.to_go_far
	P_ACCEL		60,1
	P_IMPORT	slopenum,KDifficulty
	P_IFSAME	slopenum,dif_easy,.nfe
	P_TRIGGER	.slonum_fire_16,OFF
.nfe
	P_GOTO		.go_far

.slonum_fire_16
	P_INC		slopenum
	P_IFNOTSAME	slopenum,16,.no_f
	P_GOSUB		sos_fire_must
	P_ZERO		slopenum
.no_f
	P_RETURN

.next_step
	P_TRIGGER	.new_strong_liveck,OFF

.new_strong_dead	LOCAL
	P_COLLISIONS	OFF
	P_TRIGGER	kani_explode_big,4
	P_TRIGGER	exp_smoke,8
	P_ACCEL		60,5
	P_GOSUB		fighter_count
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
;	P_CLRDEMOSHAPE
;	P_SCREENFLASH
	P_SCORE		sc_sos_strong

	P_DO		10
	P_ADD		rotx,2
	P_ADD		rotz,-2
	P_ADD		worldy,10
	P_NEXT

	P_SCREENFLASH
	P_CIRCLEWINDOW	1,big			;10
	P_DO		4
	P_QSPAWN	explosion6,e_sp_bigrandom_explosion,100,80
	P_IFSAME	shape,jyouge_1,.jyouge
	P_BECOME
	P_ACTIVE	ON
	P_ADD		slopenum,6
	P_UNBECOME
.j_back
	P_ADD		rotx,2
	P_ADD		rotz,-2
	P_ADD		worldy,10
	P_NEXT
	P_GOSUB		make_random_item
	P_EXPLODE
.jyouge
	P_BECOME
	P_ACTIVE	ON
	P_ADD		slopenum,8
	P_UNBECOME
	P_IGOTO		.j_back	
	
;;;;--------- SPACE BAKUGEKIKI
	START_PATH	e_space_bakugeki

	P_SET		skidy,hp
	P_IMPORT	pword1,CurrentSwitch
	P_INC		skidy
	P_IFSWITCH	skidy,pword1,.r_dead
	P_INC		pbyte1
.r_dead
	P_INC		skidy
	P_IFSWITCH	skidy,pword1,.l_dead
	P_ADD		pbyte1,2
.l_dead
	P_IFNOTZERO	pbyte1,.live
	P_REMOVE
.live
	P_DEC		skidy
	P_EXPORT	gbyte1,hp
	P_SET		pbyte2,1
	P_IFSWITCH	pbyte2,pbyte1,.r_wing_ok
	P_SPAWN		-40<<bakugeki_scale,0,0,0,0,0,baku_r_b,e_bakugeki_c,1,1,1
	P_IGOTO		.mk_l_wing
.r_wing_ok
	P_SPAWN		-40<<bakugeki_scale,0,0,0,0,0,baku_r,e_bakugeki_c,1,1,1
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_INC		childrotz
.mk_l_wing
	P_GINC		b,gbyte1
	P_INC		pbyte2
	P_IFSWITCH	pbyte2,pbyte1,.l_wing_ok
	P_SPAWN		40<<bakugeki_scale,0,0,0,0,0,baku_l_b,e_bakugeki_c,-1,2,2
	P_IGOTO		.bakugeki_init
.l_wing_ok
	P_SPAWN		40<<bakugeki_scale,0,0,0,0,0,baku_l,e_bakugeki_c,-1,2,2
	P_BECOME
	P_IMPORT	skidy,gbyte1
	P_UNBECOME
	P_INC		childrotz
.bakugeki_init
	P_IMPORT	roty,Kinitroty
	P_GOSUB		init_sos_zaco
	P_GOSUB		set_hp100_ap4_enemy
	P_INVISIBLE	ON

	P_SET		childy,worldy

	P_RTRIGGER	.wing_live_ck,Always
	P_RTRIGGER	.bakugeki_yure,Always
	P_RTRIGGER	.bakugeki_keep_hi,Always

	P_QUADVECS	ON
	P_SETVEL	junko_speed

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_sos_1
;.lp
;	P_DISTMORE	8000,.t_go_lp
;	P_IMPORT	pword1,Player1_worldy
;	P_NEG		pword1
;	P_ADD		pword1,worldy
;	P_IFBETWEEN	-2000,pword1,2000,.act
;.t_go_lp
;	P_GOTO		.lp
.lp
	P_DISTLESS	8000,.act
	P_GOTO		.lp
.act
	P_GOSUB		.atack_off
	P_SPACESHIP	ON
	P_TRIGGER	.bakugeki_yure,OFF
	P_GOSUB		decide_angle_slonum_s_s
	P_GOSUB		slonum_rz_waitchase
	P_ZERO		pword1
	P_ACCEL		60,10
	P_TRIGGER	kirai_maku,16,50
	P_IFLARGER	worldy,pword1,.go_up	

	P_WAITCHASE	rotx,50
	P_ACCEL		junko_speed,5
.dw_lp
	P_SET		pword1,3000
	P_IFLARGER	worldy,pword1,.stop_hi
	P_GOTO		.dw_lp
.stop_hi
	P_ACCEL		junko_speed,10
	P_WAITCHASE	rotx,0
	P_WAITCHASE	rotz,0
	P_SPACESHIP	OFF
	P_ZERO		slopenum
	P_RTRIGGER	.bakugeki_yure,Always

	P_GOSUB		.atack_on

;	P_TRIGGER	.kirai_maku,OFF
	P_GOTO		.lp
.go_up
	P_WAITCHASE	rotx,-50
.up_lp
	P_SET		pword1,-3000
	P_IFSMALLER	worldy,pword1,.stop_hi
	P_GOTO		.up_lp

.atack_on
	P_BECOMECHILD	1
	P_SET		pbyte2,1
	P_UNBECOME
	P_BECOMECHILD	2
	P_SET		pbyte2,1
	P_UNBECOME
	P_RETURN
.atack_off
	P_BECOMECHILD	1
	P_ZERO		pbyte2
	P_UNBECOME
	P_BECOMECHILD	2
	P_ZERO		pbyte2
	P_UNBECOME
	P_RETURN

.bakugeki_keep_hi
	P_IFBETWEEN	-3500,worldy,3500,.ok_hi
	P_SET		worldy,childy
.ok_hi
	P_SET		childy,worldy
	P_RETURN
.bakugeki_yure
	P_IFSAME	childrotz,2,.no
	P_INDEX		rotz,baku_yure_tab,slopenum
	P_INC		slopenum
	P_IFNOTSAME	slopenum,60,.nono
	P_ZERO		slopenum
	P_RETURN
.no
	P_INDEX		rotz,baku_yurenai_tab,slopenum
	P_INC		slopenum
	P_IFNOTSAME	slopenum,24,.nono
	P_ZERO		slopenum
.nono
	P_RETURN
.wing_live_ck
	P_IFNOTZERO	childrotz,.wing_genki
	P_FORCE		.both_dead
.wing_genki
	P_RETURN
.both_dead
	P_TRIGGER	.wing_live_ck,OFF
	P_TRIGGER	.bakugeki_yure,OFF
	P_TRIGGER	.bakugeki_keep_hi,OFF

	P_TRIGGER	.wing_live_ck,OFF
	P_SCORE		sc_bakugekiki
	P_GOSUB		fighter_count_baku
;	P_CLRDEMOSHAPE
;	P_GDEC		b,KEnemyNumber
	P_IMPORT	pbyte1,CurrentEEnemyNumber
	P_IFBETWEEN	0,skidy,8,.lower
	P_ADD		pbyte1,-16
	P_IGOTO		.set_eenemy
.lower
	P_ADD		pbyte1,-1
.set_eenemy
	P_EXPORT	CurrentEEnemyNumber,pbyte1

	P_TRIGGER	senkan_explode,4
	P_TRIGGER	.rem_c,Timer,10

	P_SET		pword1,10

	P_DO		30
	P_ADD		rotx,2
	P_ADD		rotz,-2
	P_ADD		worldy,pword1
	P_ADD		pword1,5
	P_NEXT

	P_CIRCLEWINDOW	1,big
	P_GOSUB		sos_group_explode

	P_EXPLODE

.rem_c
	P_FLAGCHILD	1
	P_FLAGCHILD	2
	P_REMOVE	3
	P_REMOVE	4
	P_RETURN

;----------
	START_PATH	e_kirai

	P_IMPORT	pbyte1,etemp
	P_SET		pbyte2,2
	P_IFLARGER	pbyte1,pbyte2,eg_remove
	P_GINC		b,etemp
	P_SPRITE	0,32
	P_GOSUB		hit_dead_init
	P_SET		hp,100
	P_SOUND		p2_ironball	;05
	P_RTRIGGER	.hit_rem,WhenHit
	P_RTRIGGER	.come,2
.lp
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFZERO	pbyte1,.expl
	P_GOTO		.lp
.come
	P_DISTLESS	500,.pass
	P_MOVEINPLAYER	100
	P_RETURN
.pass
	P_FORCE		.expl
	P_RETURN
.expl
	P_TRIGGER	.come,OFF
	P_WAIT		50
	P_GDEC		b,etemp
	P_EXPLODE
.hit_rem
	P_FORCE		.exp
	P_RETURN
.exp
	P_SCORE		sc_kirai
	P_GDEC		b,etemp
	P_EXPLODE
;----------

	START_PATH	e_bakugeki_c

	P_INC		skidy
	P_SET		slopenum,ap
	P_SET		ap,4
	P_SET		weapontype,hp
	P_SET		hp,100
	P_IFSAME	shape,baku_r_b,.bre
	P_IFSAME	shape,baku_l_b,.bre

	P_RTRIGGER	.wing_hit,WhenHit
	P_RTRIGGER	.wing_m_dead,WhenFlagged
	P_RTRIGGER	.bakugeki_atack,32
	P_END
.bakugeki_atack
	P_DISTMORE	10000,.pass
	P_IFZERO	pbyte2,.pass
	P_IFSAME	weapontype,1,.pass
	P_ADD		childz,50<<bakugeki_scale
	P_QSPAWN	missile_l,e_bakugeki_miss,1,4
	P_ADD		childz,-50<<bakugeki_scale
.pass
	P_NEG		weapontype
.m_pass
	P_RETURN
.wing_hit
	P_SET		pbyte1,90
	P_IFLARGER	hp,pbyte1,.ok
	P_FORCE		.wing_dead
.ok
	P_RETURN
.wing_m_dead
	P_FORCE		.fl
	P_RETURN
.fl
	P_TRIGGER	.wing_hit,OFF
	P_TRIGGER	.wing_m_dead,OFF
	P_TRIGGER	.bakugeki_atack,OFF
.flp
	P_RANDOMGOTO	.fpas
	P_RANDOMGOTO	.fpas
	P_HITFLASHTRIG
.fpas
	P_GOTO		.flp
.wing_dead
	P_TRIGGER	.wing_hit,OFF
	P_TRIGGER	.bakugeki_atack,OFF
	P_COLLISIONS	OFF

	P_IMPORT	pword1,CurrentSwitch
	P_SETSWITCH	skidy,pword1
	P_EXPORT	CurrentSwitch,pword1

	P_ZERO		tx

	P_BECOMEMOTHER
	P_DEC		childrotz
	P_UNBECOME

	P_GOSUB		sos_group_explode

.bre
;;;	P_TRIGGER	kani_explode,4

	P_SPAWN		0,0,40<<bakugeki_scale,0,0,0,nullshape,e_noroshi_maker_noex,10,10,3

	P_IFSAME	slopenum,1,.r_wing
	P_BECOME
	P_ADD		childx,10<<bakugeki_scale
	P_UNBECOME
	P_SET		shape,baku_l_b
	P_END
.r_wing
	P_SET		shape,baku_r_b
	P_BECOME
	P_SET		ap,4
	P_SETID		ap
	P_ADD		childx,-10<<bakugeki_scale
	P_UNBECOME
	P_END
;-----------
	START_PATH	e_bakugeki_miss

	P_ALWAYSGENVECS	ON
	P_QUADVECS	ON
	P_BELOWPLAYER	.uchiage
	P_SOUNDEFTDISTPOS	en_missileshoot_s	;$74
	P_SET		childy,10
	P_DO		10
	P_ADD		worldy,childy
	P_ADD		childy,5
	P_NEXT
.d_lp
	P_IMPORT	pword1,Player1_worldy
	P_IFLARGER	worldy,pword1,.go_f
	P_ADD		worldy,childy
	P_IFSAME	childy,100,.na
	P_ADD		childy,5
.na
	P_GOTO		.d_lp
.go_f
	P_SOUND		p2_EMissile	;02
	P_ACCEL		45,5
	p_spawn	0,0,-480,0,0,0,boost,missileboost,80,1,1
.ugo_f
	P_RTRIGGER	.rz,Always

	P_ZERO		pword1
.go_ff
	P_INC		pword1
	P_IFSAME	pword1,100,.exp
	P_FACEPLAYER
	P_PLAYERINCONE	16,.ck_v
	P_GOTO		.go_ff
.ck_v
	P_DISTLESS	2500,.cyoku
	P_GOTO		.go_ff
.cyoku
	P_WAIT		30
.exp
	P_EXPLODE
.uchiage
	P_SET		rotx,-64
	p_spawn	0,0,-480,0,0,0,boost,missileboost,80,1,1
	P_ACCEL		45,5
.u_lp
	P_FACEPLAYER	y
	P_IMPORT	pword1,Player1_worldy
	P_IFSMALLER	worldy,pword1,.ugo_f
	P_GOTO		.u_lp
.rz
	P_ADD		rotz,16
	P_RETURN
;;;;--------- SPACE NINJA
	START_PATH	e_space_ninja

	P_SET		skidy,hp
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.csok
	P_REMOVE
.csok
	P_RTRIGGER	.wait_faceplayer,Always
	P_SETANIM	11
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_GOSUB		init_sos_zaco
	P_GOSUB		set_hp100_ap4_enemy
	P_IMPORT	hp,KDifficulty
	P_IFSAME	hp,dif_hard,.h_hp
	P_SET		hp,80
	P_IGOTO		.en_hp
.h_hp
	P_SET		hp,100
.en_hp
;	P_EXPORT	especialhp1,hp
;.hp_not_zero
	P_SETBOSSNAME	name_tectron
	P_GOSUB		enemy_hp_meter_hydra
	P_SET		childrotx,95
	P_SET		childy,3500

	P_RTRIGGER	.new_strong_liveck,WhenHit

;	P_QUADVECS	ON
;	P_SETVEL	12
;
	P_RTRIGGER	.start_pos,Always

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_ninja	;06

	P_RTRIGGER	.hit_action,WhenHit

;	P_WAIT		100
	P_DO		3
	P_DO		3
	P_GOSUB		.nin_fire
	P_WAIT		8
	P_NEXT
	P_WAIT		30
	P_NEXT

	P_TRIGGER	.wait_faceplayer,OFF
	P_SOUNDEFTPOS	en_ninja_wing	;$9f*
	P_TRIGGER	.kara_crose,Always,11
	P_TRIGGER	reflect_laser,Always
	P_IGOTO		.run_away_go
;-----------
.new_strong_liveck
	P_EXPORT	especialhp1,hp
	P_IFLARGER	hp,childrotx,.live_ok1
	P_ADD		childrotx,-5
	P_QSPAWN	smoke,e_sos_almost,3,0
	P_BECOME
	P_ACTIVE	ON
	P_UNBECOME
	P_IFNOTBETWEEN	0,hp,40,.live_ok1
	P_FORCE		.next_step
.live_ok1
	P_RETURN
.next_step
	P_TRIGGER	.new_strong_liveck,OFF

	P_GSET		b,bossmaxhp,0
	P_SET		shape,ninja_exp
	P_ZERO		pbyte1
	P_EXPORT	especialhp1,pbyte1
	P_IGOTO		pe_sos_new_strong1.new_strong_dead
;-----------
.wait_faceplayer
	P_FACEPLAYER
	P_RETURN
.start_pos
	P_DISTLESS	7000,.ok_dist
	P_MOVEINPLAYER	50
.ok_dist
	P_RETURN

.hit_action
	P_FORCE		.action_on
	P_RETURN
.action_on
	P_TRIGGER	.wait_faceplayer,OFF
	P_TRIGGER	.start_pos,OFF
	P_TRIGGER	.hit_action,OFF
	P_TRIGGER	.kara_crose,Always,5
	P_TRIGGER	reflect_laser,Always
.lp
	P_DO		3

	P_DO		3
	P_EXPORT	gword1,childy
	P_NEG		childy
	P_QSPAWN	marker,e_marker,100,0
	P_FINDSHAPE	marker
	P_BECOME
	P_FINDSHAPE	ninja
	P_COPYPLAYERPOS
	P_ADD		worldz,7000
	P_SETRANDOM	pbyte1,7
	P_INC		pbyte1
	P_DO		pbyte1
	P_CIRCLEPLAYER	32
	P_INEXT
	P_IMPORT	worldy,gword1
	P_UNBECOME

	P_DO		30
	P_SHAPEDISTLESS	500,.co_br
	P_MOVEINSHAPE	120
	P_MOVEINSHAPE	120
	P_MOVEINSHAPE	120
	P_MOVEINSHAPE	120
	P_MOVEINSHAPE	120
;	P_FACESHAPE
	P_ADD		rotx,17
	P_ADD		roty,17
	P_WAIT		1
.co_br
	P_INEXT

	P_WAIT		10

	P_NEXT

	P_TRIGGER	reflect_laser,OFF
	P_SETVEL	0

;	P_DO		12
;	P_FACESHAPE
;	P_NEXT
;
	P_FLAGSHAPE

	P_RELTOPLAYER	ON

	P_DO		10
	P_FACEPLAYER
	P_NEXT

	P_SOUNDEFTPOS	en_ninja_wing	;$9f*
	P_TRIGGER	.kara_open,Always,5

	P_DO		15
	P_FACEPLAYER
	P_NEXT

	P_TRIGGER	.nin_fire,8,30
	P_DO		65
	P_FACEPLAYER	IMMEDIATE
	P_NEXT

	P_SOUNDEFTPOS	en_ninja_wing	;$9f*
	P_TRIGGER	.kara_crose,Always,5
	P_TRIGGER	reflect_laser,Always

	P_WAIT		5

	P_RELTOPLAYER	OFF

	P_NEXT

.run_away_go
	P_ALWAYSGENVECS	OFF
	P_SETRANDOM	pbyte1,3
	P_INDEX		childroty,ninjarun_ang,pbyte1
.rlp
	P_CHASE		roty,childroty
	P_CHASE		roty,childroty
	P_CHASE		rotx,0
	P_IFSAME	roty,childroty,.go
	P_GOTO		.rlp
.go
	P_INDEX		childx,ninjarun_x,pbyte1
	P_INDEX		childz,ninjarun_z,pbyte1
	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		400,0,-4000,0,0,0,warpl,e_warp_mark,100,0,9
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childx,nin_warp_x,pbyte1
	P_INDEX		childy,nin_warp_y,pbyte1
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
;	P_SPAWN		400,0,-4000,0,0,0,warpl,e_warp_mark,100,0,9
;	P_SPAWN		-400,0,-4000,0,0,0,warpl,e_warp_mark,100,0,9
;	P_SPAWN		0,-400,-4000,0,0,0,warpl,e_warp_mark,100,0,9
;	P_SPAWN		0,400,-4000,0,0,0,warpl,e_warp_mark,100,0,9

	P_SOUNDEFTPOS	en_dash_demo	;$7e
	P_ZERO		vy
.run_away
	P_DO		20
	P_CHASE		vx,childx
	P_CHASE		vz,childz
	P_CHASE		vx,childx
	P_CHASE		vz,childz
	P_NEXT
	P_CIRCLEWINDOW	1,warp
.rem
	P_REMOVE
;.run_x
;	dw	600,600,-600,-600
;.run_z
;	dw	600,-600,600,-600
;.run_ang
;	db	224,160,32,96

.nin_fire
	P_QSPAWN	warp_laser,e_ninja_laser,100,4
	P_RETURN
.kara_open
	P_ADDANIM	1,6
	P_INVINCIBLE	OFF
	P_RETURN
.kara_crose
	P_ADDANIM	-1,6
	P_INVINCIBLE	ON
	P_RETURN

;------------
	START_PATH	e_warp_mark

	P_COLLISIONS	OFF
	P_END
;------------
	START_PATH	e_ninja_laser

	P_ALWAYSGENVECS	ON
	P_SET		hp,100
	P_SET		ap,4

	P_RANDOMGOTO	.cyo

	P_SET		pbyte1,16
	P_GOSUB		ran_neg_pb1
	P_ADD		rotx,pbyte1
	P_GOSUB		ran_neg_pb1
	P_ADD		roty,pbyte1
.cyo
	P_QUADVECS	ON
	P_SETVEL	100

	P_SOUNDEFTDISTPOS	d_sen_ss_laser	;$af

	P_DO		30
	P_INPLAYERSCONE		-10,10,.hit
	P_IGOTO		.haz
.hit
	P_FACEPLAYER	IMMEDIATE
.haz
	P_BEHINDPLAYER	.br
	P_NEXT
.rem
	P_REMOVE
.br
	P_BREAK		.rem

;;;;--------- HENTAIHIKOU SURU SOS JYAIRO NEW TYPE 1
	START_PATH	e_jyairo_hentai_1c_mustwork

	P_GOSUB		make_sw_num_hofhp
	P_INC		mx
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_IGOTO		pe_jyairo_hentai_1_c.mustwork_enter

	START_PATH	e_jyairo_hentai_1

	P_GOSUB		make_sw_num_hofhp
	P_SET		coltab,id_1_c&WM

	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty

	P_ZERO		pbyte1
	P_EXPORT	gbyte1,pbyte1
	P_EXPORT	gbyte2,skidy
	P_EXPORT	gword1,shape
	P_DO		hp
	P_GINC		b,gbyte1
	P_GINC		b,gbyte2
	P_SPAWN		0,0,0,0,0,0,nullshape,e_jyairo_hentai_1_c,2,4,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_IMPORT	skidy,gbyte2
	P_IMPORT	shape,gword1
	P_SETID		pbyte1
	P_DEC		pbyte1
	P_INDEX		childx,hentai_posx,pbyte1
	P_INDEX		childy,hentai_posy,pbyte1
	P_INDEX		childz,hentai_posz,pbyte1
	P_UNBECOME
	P_INEXT

	P_WAIT		1

	P_GOSUB		c_unlink_1234
;	P_UNLINKCHILD	1
;	P_UNLINKCHILD	2
;	P_UNLINKCHILD	3
;	P_UNLINKCHILD	4

;-----------
	START_PATH	e_jyairo_hentai_1_c

.mustwork_enter	LOCAL
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.live
	P_REMOVE
.live
	P_GOSUB		set_hp100_ap4_enemy
	P_RELATIVE	OFF

	P_WAIT		1

	P_SPAWN		0,0,0,0,0,0,speed_lr,e_jyairo_lr,100,0,1
	P_IFNOTSAME	coltab,id_1_c,.red
	P_BECOME
	P_SET		coltab,id_1_c&wm
	P_UNBECOME
.red

	P_WEAPON	Elaser
	P_SET		childroty,roty
	P_SET		childy,worldy
	P_RTRIGGER	.speed_dead,WhenHit
	P_TRIGGER	far_rem_ck,32

	P_QUADVECS	ON

	P_SETVEL	junko_speed		;12

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_speed_s

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128

.enter
	P_WITHINRADIUS	action_dist,.hentai_to_start
	P_DISTMORE	14000,.to_enter
	P_IMPORT	pbyte1,eaction1
	P_IFSAME	pbyte1,255,.hentai_to_start
	P_IFNOTZERO	pbyte1,.run_run
.to_enter
	P_GOTO		.enter
;-------------
.speed_dead
	P_FORCE		.speed_exp
	P_RETURN
.speed_exp
	P_TRIGGER	.speed_move,OFF
	P_TRIGGER	.speed_dist,OFF
	P_TRIGGER	.speed_dead,OFF
	P_RELTOPLAYER	OFF
	P_COLLISIONS	OFF
	P_REMOVE	9
	P_REMOVE	10
	P_GOSUB		fighter_count_gset
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
;	P_CLRDEMOSHAPE
;	P_SCREENFLASH
;	P_SET		pbyte1,255
;	P_EXPORT	eaction1,pbyte1
	P_SCORE		sc_sos_speed
	P_GOSUB		sos_group_explode
	P_BECOMECHILD	1
	P_INC		pbyte1
	P_UNBECOME
	P_FLAGCHILD	1
	P_UNLINKCHILD	1
	P_EXPLODE
;-------------
.run_run
	P_IFNOTZERO	mx,.hentai_to_start
	P_ACCEL		run_speed,2		;40,2
	P_BECOMECHILD	2
	P_ADD		tx,30
	P_UNBECOME
	P_BECOMECHILD	3
	P_ADD		tx,30
	P_UNBECOME
	P_ZERO		pbyte1
.run_lp
	P_INC		pbyte1
	P_IFSAME	pbyte1,45,.run_end
	P_DISTMORE	3000,.run_end
	P_GOTO		.run_lp
.run_end
	P_ZERO		pbyte1
	P_EXPORT	eaction1,pbyte1
	P_ACCEL		junko_speed,2			;12,2
	P_BECOMECHILD	2
	P_ADD		tx,-30
	P_UNBECOME
	P_BECOMECHILD	3
	P_ADD		tx,-30
	P_UNBECOME
	P_GOTO		.enter
.hentai_to_start
;	P_EXPORT	eaction1,skidy
;	P_ACCEL		60,5				;30,2
	P_ACCEL		sankai_speed,20				;30,2
	P_SPACESHIP	ON
	P_RANDOMGOTO	.d
	P_WAITCHASE	rotx,24
	P_IGOTO		.f
.d
	P_WAITCHASE	rotx,-24
.f
	P_GOSUB		decide_angle_slonum
	P_GOSUB		slonum_rz_waitchase
	P_WAITCHASE	rotx,0
	P_ZERO		pbyte1
.face_cont
	P_PLAYERINCONE	10,.face_go
	P_INC		pbyte1
	P_IFSAME	pbyte1,60,.face_go
	P_GOTO		.face_cont
.face_go
	P_SPACESHIP	OFF
	P_WAITCHASE	rotz,0
	P_RTRIGGER	.speed_dist,Always
	P_ACCEL		0,5
	P_SETVEL	0
	P_IGOTO		.hentai_atack_on
.start
.start2
	P_RELTOPLAYER	ON			;;;
	P_RTRIGGER	.speed_dist,Always
	P_FLAGCHILD	3			;OFF
	P_WAIT		1
.start_face
	P_ADD		roty,-8
	P_PLAYERINCONE	10,.re_start
	P_GOTO		.start_face
;-----------
.speed_dist
	P_DISTMORE	10000,.dist_okk
	P_DISTMORE	2000,.dist_ok
	P_MOVEINPLAYER	-60
	P_RETURN
.dist_ok
	P_DISTLESS	4000,.dist_okk
	P_MOVEINPLAYER	60
.dist_okk
	P_RETURN
;-----------
.re_start
	P_SETVEL	0
	P_FLAGCHILD	3			;ON

	P_WAIT		3
.hentai_atack_on
	P_DO		3
		P_SETRANDOM	ox,511		;255
		P_ADD		ox,-255		;-128
		P_SETRANDOM	oz,511		;255
		P_ADD		oz,-255		;-128
		P_SET		oy,400		;200
		P_GOSUB		.boost_flag	;OFF
		P_SET		pbyte2,64
		P_ABOVEPLAYER	.move_down
		P_NEG		oy
		P_NEG		pbyte2
.move_down
		P_GOSUB		.make_wing_rot
		P_WAIT		8
		P_GOSUB		.boost_flag	;ON
		P_RTRIGGER	.speed_move,Always
		P_WAIT		8
		P_GOSUB		sos_fire_must
		P_TRIGGER	sos_fire_must2,16

.speed_down_cont_noha
		P_IFBETWEEN	0,oy,10000,.shita
.sp_do_nh_lp
		P_CHASE		ox,0
		P_CHASE		oz,0
		P_BELOWPLAYER	.pass_ch
		P_DO		3
		P_CHASE		oy,0
		P_INEXT
;		P_CHASE		oy,0
;		P_CHASE		oy,0
;		P_CHASE		oy,0
.pass_ch
		P_FACEPLAYER
		P_IFZERO	oy,.end_sp_down
		P_GOTO		.sp_do_nh_lp
.shita
		P_CHASE		ox,0
		P_CHASE		oz,0
		P_ABOVEPLAYER	.pass_cha
		P_DO		3
		P_CHASE		oy,0
		P_INEXT
;		P_CHASE		oy,0
;		P_CHASE		oy,0
;		P_CHASE		oy,0
.pass_cha
		P_FACEPLAYER
		P_IFZERO	oy,.end_sp_down
		P_GOTO		.shita
.end_sp_down
		P_TRIGGER	.speed_move,OFF

		P_SETRANDOM	pbyte1,7
		P_ADD		pbyte1,-4
		P_DO		10
		P_ADD		roty,pbyte1
		P_NEXT
		P_TRIGGER	sos_fire_must2,OFF
	P_NEXT

	P_GOSUB		.boost_flag

	P_ZERO		pbyte2
	P_GOSUB		.make_wing_rot
	P_WAIT		8
	P_SET		childrotz,32
	P_IFSMALLER	worldy,childy,.ok_x_rot
	P_NEG		childrotz
.ok_x_rot
	P_SET		childrotx,childroty
	P_NEG		childrotx
	P_ADD		childrotx,roty
	P_IFSMALLER	childrotx,ty,.rev_rot
	P_FLAGCHILD	2		;ON
	P_IGOTO		.run_root
.rev_rot
	P_FLAGCHILD	3		;ON
.run_root
	P_CHASE		roty,childroty
	P_CHASE		roty,childroty
	P_CHASE		rotx,childrotz
	P_IFSAME	childroty,roty,.go_run
	P_GOTO		.run_root

.go_run
	P_TRIGGER	.speed_dist,OFF
	P_SETVEL	60		;40
	P_IFSMALLER	childrotx,ty,.rev_rot2
	
	P_FLAGCHILD	3
	P_IGOTO		.run_st	
.rev_rot2
	P_FLAGCHILD	2
.run_st
	P_DO		40
	P_IFSAME	childrotz,32,.down_ck
	P_IFLARGER	worldy,childy,.hi_cont
	P_IGOTO		.zero_x
.down_ck
	P_IFSMALLER	worldy,childy,.hi_cont
.zero_x
	P_CHASE		rotx,0
	P_CHASE		rotx,0
.hi_cont
	P_NEXT

	P_WAITCHASE	rotx,0

	P_WAIT		15			;30
	P_ACCEL		12,1
	P_RELTOPLAYER	OFF			;;;
	P_IGOTO		.enter

;------------
.speed_move
	P_ADD		worldx,ox
	P_ADD		worldy,oy
	P_ADD		worldz,oz
	P_RETURN

.make_wing_rot
	P_SOUNDEFTDISTPOS	en_wingroll	;$8d
	P_EXPORT	gbyte1,pbyte2
	P_BECOMECHILD	1
	P_EXPORT	gbyte2,childrotx
	P_UNBECOME
	P_IMPORT	childrotx,gbyte2
	P_NEG		childrotx
	P_ADD		childrotx,pbyte2
	P_SET		pbyte1,16
	P_IFLARGER	childrotx,ty,.plus
	P_NEG		pbyte1
.plus
	P_EXPORT	gbyte2,pbyte1
	P_BECOMECHILD	1
	P_IMPORT	pbyte2,gbyte1
	P_IMPORT	slopenum,gbyte2
	P_UNBECOME
	P_FLAGCHILD	1
	P_RETURN

.boost_flag
	P_FLAGCHILD	2
	P_FLAGCHILD	3
	P_RETURN
;-----------
	START_PATH	e_jyairo_lr

	P_ACTIVE	ON
	P_SETANIM	0
	P_SHADOW	OFF
	P_SET		pbyte2,2
	P_SET		slopenum,pbyte2
	P_EXPORT	gbyte2,pbyte2

	P_SET		pbyte2,2
	P_SET		pbyte1,30
	P_SET		pword1,-22<<speed_scale
	P_GOSUB		make_boost

	P_BECOMECHILD	2
	P_SET		childx,-36<<speed_scale
	P_UNBECOME
	P_BECOMECHILD	3
	P_SET		childx,36<<speed_scale
	P_UNBECOME

	P_COLLISIONS	OFF
	P_ZERO		pbyte1
.re_start
	P_RTRIGGER	.mother_flag,WhenFlagged
	P_END
.mother_flag
	P_IFZERO	pbyte1,.rot_flag
	P_FORCE		.exp
	P_RETURN
.rot_flag
	P_FORCE		.wing_rot
	P_RETURN
.wing_rot
	P_TRIGGER	.mother_flag,OFF
.wing_rot_lp
	P_IFSAME	pbyte2,childrotx,.re_start
	P_ADD		childrotx,slopenum
	P_GOTO		.wing_rot_lp
.exp
	P_SETANIM	1
	P_ADD		childx,30<<speed_scale
	P_QSPAWN	speed_lr,e_jyairo_r,100,0
	P_BECOME
	P_ACTIVE	ON
	P_SETANIM	2
	P_UNBECOME
	P_ADD		childx,-60<<speed_scale
	P_RELTOPLAYER	ON
;------------
	START_PATH	e_jyairo_r

	P_COLLISIONS	OFF
	P_SETRANDOM	pbyte1,255
	P_DIV2		pbyte1
	P_SETRANDOM	pbyte2,255
	P_DIV2		pbyte2
	P_SETRANDOM	slopenum,255
	P_DIV2		slopenum
	P_SETRANDOM	childrotx,15
	P_ADD		childrotx,16
	P_SETRANDOM	childroty,15
	P_ADD		childroty,-48
	P_DO		10
	P_ADD		worldx,pbyte1
	P_ADD		worldy,pbyte2
	P_ADD		worldz,slopenum
	P_ADD		roty,childrotx
	P_ADD		rotx,childroty
	P_NEXT
	P_EXPLODE

;;;;--------- HENTAIHIKOU SURU SOS ZAKO NEW TYPE 1
	START_PATH	e_sos_hentai_1c_mustwork

	P_GOSUB		make_sw_num_hofhp
	P_INC		mx
	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty
	P_IGOTO		pe_sos_hentai_1_c.must_enter

	START_PATH	e_sos_hentai_1

	P_GOSUB		make_sw_num_hofhp
	P_SET		coltab,id_1_c&WM

	P_GADD		worldy,ehight	; don't delete!!
	P_IMPORT	roty,Kinitroty

	P_ZERO		pbyte1
	P_EXPORT	gbyte1,pbyte1
	P_EXPORT	gbyte2,skidy
	P_EXPORT	gword1,shape
	P_DO		hp
	P_GINC		b,gbyte1
	P_GINC		b,gbyte2
	P_SPAWN		0,0,0,0,0,0,nullshape,e_sos_hentai_1_c,2,4,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_IMPORT	skidy,gbyte2
	P_IMPORT	shape,gword1
	P_SETID		pbyte1
	P_DEC		pbyte1
	P_INDEX		childx,hentai_posx,pbyte1
	P_INDEX		childy,hentai_posy,pbyte1
	P_INDEX		childz,hentai_posz,pbyte1
	P_UNBECOME
	P_INEXT

	P_WAIT		1

	P_GOSUB		c_unlink_1234
;	P_UNLINKCHILD	1
;	P_UNLINKCHILD	2
;	P_UNLINKCHILD	3
;	P_UNLINKCHILD	4
;---------
	START_PATH	e_sos_hentai_1_c

.must_enter	LOCAL
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.live
	P_REMOVE
.live
	P_GOSUB		set_hp100_ap4_enemy
	P_QUADVECS	ON
	P_TRIGGER	sos_dead,WhenHit
	P_TRIGGER	far_rem_ck,32
	P_WEAPON	ELaser
	P_WAIT		1

	P_SET		pbyte2,1
	P_EXPORT	gbyte2,pbyte2
	P_SET		pbyte1,33<<1			;boost no size
	P_SET		pword1,-160<<1			;boost no childz
	P_GOSUB		make_boost
	P_ZERO		pbyte2
	P_SET		tx,3
	P_SET		ty,4
	P_TRIGGER	fly_wave,Always

	P_SETVEL	junko_speed		;12

	P_GOSUB		wait_start_trigger

	P_SOUND		p2_sos_0

	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128

.lp
	P_WITHINRADIUS	action_dist,.act_ck
	P_DISTMORE	14000,.to_lp
	P_IMPORT	pbyte1,eaction1
	P_IFSAME	pbyte1,255,.act_must
	P_IFNOTZERO	pbyte1,.run_act
.to_lp
	P_GOTO		.lp
.run_act
	P_IFNOTZERO	mx,.act_must
	P_BECOMECHILD	1
	P_SET		tx,120
	P_UNBECOME
	P_SETVEL	30
	P_ACCEL		12,1
.run_lp
	P_WITHINRADIUS	7000,.run_end
	P_IFSAME	vel,12,.run_end
	P_GOTO		.run_lp
.run_end
	P_BECOMECHILD	1
	P_SET		tx,70
	P_UNBECOME
	P_ZERO		pbyte1
	P_EXPORT	eaction1,pbyte1
	P_GOTO		.lp
.act_ck
	P_IFNOTZERO	mx,.act_must

	P_IMPORT	pbyte1,eaction1
	P_IFNOTZERO	pbyte1,.run_act
	P_EXPORT	eaction1,skidy
.act_must
	P_SET		tx,1
	P_IFSAME	shape,taigun,.t_s
	P_INDEX		childy,hen_1_y_tab,skidy
	P_ZERO		childx
	P_ZERO		childz
	P_RTRIGGER	.fuyuu_move,Always
	P_IGOTO		.t_e
;------------
.fuyuu_move
	P_CHASE		worldy,childy
	P_ADD		worldx,childx
	P_ADD		worldz,childz
	P_SET		pword1,worldy
	P_NEG		pword1
	P_ADD		pword1,childy
	P_IFBETWEEN	-50,pword1,50,.next_hi
	P_RETURN
.next_hi
	P_SETRANDOM	childy,8191
	P_ADD		childy,-4096
	P_SETRANDOM	childx,255
	P_ADD		childx,-128
	P_SETRANDOM	childz,255
	P_ADD		childz,-128
	
	P_RETURN
;------------
.t_s
	P_SET		ty,1
	P_SET		tx,0
.t_e
;	P_ACCEL		60,2
	P_ACCEL		sankai_speed,20
	P_SPACESHIP	ON
	P_GOSUB		decide_angle_slonum_s
	P_GOSUB		slonum_rz_waitchase
.face_lp
	P_INC		pbyte1
	P_IFZERO	pbyte1,.face_ok
	P_PLAYERINCONE	30,.face_ok
	P_GOTO		.face_lp
.face_ok
	P_SPACESHIP	OFF

	P_ZERO		pbyte1
	P_EXPORT	eaction1,pbyte1

	P_DO		64
	P_CHASE		rotz,0
	P_NEXT
.go_far
;	P_ACCEL		40,1
	P_ZERO		slopenum
.go_far1
	P_INC		slopenum
	P_IFSAME	slopenum,50,.turn
	P_DISTMORE	9000,.turn
	P_GOTO		.go_far1
.turn
	P_GOSUB		decide_angle_slonum_s
	P_SPACESHIP	ON
	P_GOSUB		slonum_rz_waitchase
	P_ZERO		slopenum
.face_turn1
	P_INC		slopenum
	P_IFSAME	slopenum,100,.face_ok_2
	P_PLAYERINCONE	30,.face_ok_2
;	P_PLAYERINCONE	5,.face_ok_2
	P_GOTO		.face_turn1
.face_ok_2
;;;	P_ACCEL		20,2
	P_SPACESHIP	OFF
	P_WAITCHASE	rotz,0
	P_IFSAME	shape,sos_0,.not_ud
	P_IMPORT	slopenum,KDifficulty
	P_IFSAME	slopenum,0,.eas
	P_IFSAME	slopenum,1,.nor
	P_RANDOMGOTO	.up_down
.nor
	P_RANDOMGOTO	.up_down
.eas
	P_RANDOMGOTO	.up_down
.not_ud
	P_SETRANDOM	slopenum,7
	P_ADD		slopenum,8
.come
	P_FACEPLAYER	y
;	P_DISTMORE	7000,.no_atack
	P_INC		slopenum
	P_IFNOTSAME	slopenum,16,.no_atack
	P_ZERO		slopenum
	P_GOSUB		sos_fire_must
.no_atack
	P_DISTLESS	5000,.back_turn
	P_GOTO		.come
.back_turn
	P_ACCEL		60,2			;50,2
	P_GOSUB		decide_angle_slonum
	P_SPACESHIP	ON

	P_GOSUB		slonum_rz_waitchase
.back_turn_cont
	P_WAIT		1
	P_PLAYERINCONE	100,.back_turn_cont		;to_go_far
.to_go_far
;	P_ACCEL		60,2			;50,2
	P_SPACESHIP	OFF
	P_WAITCHASE	rotz,0
	P_GOTO		.go_far
.up_down
	P_TRIGGER	fly_wave,OFF
;	P_ACCEL		40,1
	P_TRIGGER	sos_fire_must,16
	P_ZERO		pword1
	P_IFLARGER	worldy,pword1,.up
;	P_IFBETWEEN	0,worldy,10000,.up
	P_GOSUB		.go_down
	P_TRIGGER	sos_fire_must,OFF
	P_TRIGGER	fly_wave,Always
	P_GOTO		.to_go_far
.up
	P_GOSUB		.go_up
	P_TRIGGER	sos_fire_must,OFF
	P_TRIGGER	fly_wave,Always
	P_GOTO		.to_go_far

.go_up
	P_SPACESHIP	ON
	P_SET		rotz,4
	P_SET		slopenum,16
	P_RANDOMGOTO	.neg_z11
	P_NEG		rotz
	P_NEG		slopenum
.neg_z11
	P_WAITCHASE	rotx,-50
	P_ZERO		childrotz
.neg_z1
	P_INC		childrotz
	P_IFSAME	childrotz,32,.end_up
	P_IFBETWEEN	-1500,worldy,1500,.end_up
	P_GOTO		.neg_z1
.end_up
	P_SPACESHIP	OFF
	P_WAITCHASE	rotx,0
	P_CHASE		rotz,0
	P_CHASE		worldy,0
	P_IFBETWEEN	-2000,worldy,2000,.inside
	P_GOTO		.end_up
.inside
	P_RETURN
.go_down
	P_SPACESHIP	ON
	P_SET		rotz,4
	P_SET		slopenum,16
	P_RANDOMGOTO	.neg_z22
	P_NEG		rotz
	P_NEG		slopenum
.neg_z22
	P_WAITCHASE	rotx,50
	P_ZERO		childrotz
.neg_z2
	P_INC		childrotz
	P_IFSAME	childrotz,32,.end_down
	P_IFBETWEEN	-1500,worldy,1500,.end_down
	P_GOTO		.neg_z2
.end_down
	P_SPACESHIP	OFF
	P_WAITCHASE	rotx,0
	P_CHASE		rotz,0
	P_CHASE		worldy,0
	P_IFBETWEEN	-2000,worldy,2000,.inside2
	P_GOTO		.end_down
.inside2
	P_RETURN
;.hen_1_y_tab
;	dw	0,-3000,3000,3000,0,0
;;;;ษออออออออออออออออออออออออออออออออออออออป
;;;;บ                                      บ
;;;;บ        FOR CYUURITSU EISEI           บ
;;;;บ                                      บ
;;;;ศออออออออออออออออออออออออออออออออออออออผ
;-----------
	START_PATH	e_eisei_tame_ck

	P_INVISIBLE	ON
.ag
	P_FINDSHAPE	tame
	P_SHAPEDEAD	.no1
	P_IGOTO		.aru
.no1
	P_FINDSHAPE	tamel
	P_SHAPEDEAD	.no
.aru
	P_GSET		b,etemp,1
	P_GOTO		.ag
.no
	P_GSET		b,etemp,0
	P_GOTO		.ag
;-----------
	START_PATH	e_eisei_cannon

	P_RADAROBJ	ra_entrance

	P_SPAWN		0,-175<<system_scale,95<<system_scale,0,0,0,system_0,e_nocol_s_off,100,4,1

	P_GSET		b,gbyte1,0
	P_DO		5
	P_SPAWN		0,0,0,0,0,0,nullshape,e_buil_shadow_off,100,4,2
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childx,eisei_c_x,pbyte1
	P_INDEX		childy,eisei_c_y,pbyte1
	P_INDEX		childz,eisei_c_z,pbyte1
	P_INDEX		childroty,eisei_c_ry,pbyte1
	P_INDEX		shape,eisei_c_s,pbyte1
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
;	P_SPAWN		0,-80<<system_scale,0,0,0,0,system_1,e_buil_shadow_off,100,4,2
;	P_SPAWN		-45<<system_scale,-45<<system_scale,105<<system_scale,0,0,0,system_2,e_buil_shadow_off,100,4,3
;	P_SPAWN		45<<system_scale,-45<<system_scale,-105<<system_scale,0,128,0,system_2,e_buil_shadow_off,100,4,4
;	P_SPAWN		105<<system_scale,-45<<system_scale,45<<system_scale,0,-64,0,system_2,e_buil_shadow_off,100,4,5
;	P_SPAWN		-105<<system_scale,-45<<system_scale,-45<<system_scale,0,64,0,system_2,e_buil_shadow_off,100,4,6

	P_SPAWN		-891,-75<<system_scale,891,0,32,0,virus,e_eisei_hacker,2,0,7
	P_SPAWN		20<<system_scale+65<<virus_scale,-130<<system_scale,0,0,64,32,virus,e_eisei_hacker,2,1,8
	P_SPAWN		1510,-75<<system_scale,-1510,0,32,-32,virus,e_eisei_hacker,2,2,9

	P_RTRIGGER	.rot_slow,Always
	P_RTRIGGER	.end_ck,Always
	P_SET		hp,100
	P_COLLISIONS	OFF
	P_SOUND		p2_system_3	;0F	;sdst4

	P_QSPAWN	nullshape,e_eisei_tame_ck,10,10

	P_END
.end_ck
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFNOTZERO	pbyte1,.pass
	P_FORCE		.end
.pass
	P_RETURN
.end
	P_TRIGGER	.end_ck,OFF
	P_WAIT		40
	P_MSG		107
	P_END
.rot_slow
	P_INC		roty
	P_RETURN
;-----------
	START_PATH	e_eisei_hacker

	P_TRIGGER	eiseidist_ck,Always
	P_INC		slopenum
;-----------
	START_PATH	e_fly_hacker

	P_SET		pbyte1,ap
	P_SET		skidy,ap
	P_GOSUB		CurrentSw_Skidy_ck
	P_IFZERO	pword1,.live
	P_REMOVE
.live
	P_GOSUB		set_hp100_ap4_enemy
	P_QUADVECS	ON
	P_TRIGGER	far_rem_ck,16		;8
	P_TRIGGER	sos_dead,WhenHit
	P_IFNOTZERO	slopenum,.hack_end

	P_INDEX		slopenum,hackroot_tab,pbyte1

	P_SET		pbyte2,1
	P_EXPORT	gbyte2,pbyte2
	P_SET		pbyte1,40<<1			;boost no size
	P_SET		pword1,-180<<1			;boost no childz
	P_GOSUB		make_boost

;	P_TRIGGER	far_rem_ck,16
	P_SETVEL	junko_speed		;12
	P_GOSUB		wait_start_trigger
	P_SOUND		p2_virus	;0E	;sdst4
	P_TRIGGER	near_check,64
	P_TRIGGER	use_boost_ck,128
	P_IMPORT	pbyte1,KEnemyNumber
	P_SET		pbyte2,pbyte1
.wlp
	P_IMPORT	pbyte1,KEnemyNumber
	P_IFNOTSAME	pbyte1,pbyte2,.act
	P_IFPLRWEAPLEVEL	2,.tw
	P_IFPLRWEAPLEVEL	3,.twtw
	P_FINDSHAPE	beam_0sps
	P_SHAPEDEAD	.ag
	P_IGOTO		.act
.tw
	P_FINDSHAPE	beam_1sps
	P_SHAPEDEAD	.ag
	P_IGOTO		.act
.twtw
	P_FINDSHAPE	beam_2sps
	P_SHAPEDEAD	.ag
	P_IGOTO		.act
.ag
	P_GOTO		.wlp
.act
	P_FLAGCHILD	1
	P_WAIT		3
	P_BECOMECHILD	1
	P_ADD		tx,30
	P_UNBECOME
	P_FLAGCHILD	1
	P_SET		tx,1
	P_SET		ty,4
	P_TRIGGER	fly_wave,Always
	P_ACCEL		80,5
	P_DO		64
	P_ADD		roty,slopenum
	P_NEXT
	P_ACCEL		junko_speed,5
	P_BECOMECHILD	1
	P_ADD		tx,-30
	P_UNBECOME
	P_END
.hack_end
	P_IMPORT	pbyte1,etemp
	P_IFZERO	pbyte1,.can
	P_INVINCIBLE	ON
	P_GOTO		.hack_end
.can
	P_INVINCIBLE	OFF
	P_GOTO		.hack_end
eiseidist_ck
	P_DISTLESS	5000,.h_can
.n_col
	P_COLLISIONS	OFF
	P_RETURN
.h_can
	P_PLAYERINCONE	32,.n_col
	P_COLLISIONS	ON
	P_RETURN

;hackroot_tab
;	db	0,1,-1
;;;;ษออออออออออออออออออออออออออออออออป
;;;;บ                                บ
;;;;บ        FOR OMAKE MEDAL         บ
;;;;บ                                บ
;;;;ศออออออออออออออออออออออออออออออออผ
	START_PATH	e_omake_medal_sea

	P_GOSUB		sea_init_below

	START_PATH	e_omake_medal

	P_IFNOTSAME	roty,19h,.not_eisei
	P_IMPORT	rotx,KDifficulty
	P_IFSAME	rotx,dif_hard,.not_eisei
	P_REMOVE
.not_eisei
	P_ZERO		rotx
	P_GOSUB		roty_pb2_pb1
	P_GOSUB		.read_medal_sw
	P_INC		pbyte1
	P_IFSWITCH	pbyte1,pword1,eg_remove

	P_IFNOTSAME	hp,99,.ns
	P_SOUNDEFFECT	s_metal_appear	;$29
.ns
	P_SET		hp,100

	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_RTRIGGER	.turn,Always
.wlp
	P_IMPORT	slopenum,KEnemyNumber
	P_IFZERO	slopenum,.no_col
	P_WITHINRADIUS	100,.catch
.no_col
	P_GOTO		.wlp
.catch
	P_SOUNDEFFECT	secret_metal	;$21
	P_GOSUB		.read_medal_sw
	P_GOSUB		.write_medal_sw
	P_GOSUB		count_medal
	P_RELTOPLAYER	ON
	P_TRIGGER	.turn,OFF
	P_GSET		b,player1_hpadd,40
;	P_RTRIGGER	.hp_kaifuku,Always
	P_FACEVIEW	IMMEDIATE
	P_SET		pbyte1,1
	P_RTRIGGER	.mk_kira,2
	P_DO		19
	P_AUTOINDEX	b,worldy,div2_jumptab,pbyte1,20
	P_ADD		rotx,32
	P_NEXT
;;;;;	P_QSPAWN	nullshape,e_medal_num,10,10
	P_INVISIBLE	ON
;	P_TRIGGER	.hp_kaifuku,OFF
.lp
	P_IFPLAYERFULLHP	eg_remove
	P_GINC		b,player1_hpadd
	P_GOTO		.lp
;.end
;	P_REMOVE
;.hp_kaifuku
;	P_IFPLAYERFULLHP	.kaifu_end
;	P_GINC		b,player1_hpadd
;.kaifu_end
;	P_RETURN

.mk_kira
	P_QSPAWN	kirakira,e_sp_kirakira,100,24
	P_BECOME
	P_RELTOPLAYER	ON
	P_UNBECOME
	P_RETURN
;---------
.write_medal_sw
;;;;;	P_GINC		b,emedal_num
	P_SETSWITCH	pbyte1,pword1
;;;	P_PRINT		pbyte2,d,eguchi
;;;	P_PRINT		pword1,b,eguchi
	P_IFSAME	pbyte2,2,.mdd2
	P_IFSAME	pbyte2,3,.mdd3
	P_IFSAME	pbyte2,4,.mdd4
.mdd1
	P_EXPORT	emedal_1,pword1
	P_RETURN
.mdd2
	P_EXPORT	emedal_2,pword1
	P_RETURN
.mdd3
	P_EXPORT	emedal_3,pword1
	P_RETURN
.mdd4
	P_EXPORT	emedal_4,pword1
	P_RETURN
.turn
	P_ADD		roty,4
	P_RETURN
.read_medal_sw
	P_IFSAME	pbyte2,2,.md2
	P_IFSAME	pbyte2,3,.md3
	P_IFSAME	pbyte2,4,.md4
.md1
	P_IMPORT	pword1,emedal_1
	P_RETURN
.md2
	P_IMPORT	pword1,emedal_2
	P_RETURN
.md3
	P_IMPORT	pword1,emedal_3
	P_RETURN
.md4
	P_IMPORT	pword1,emedal_4
	P_RETURN
;;;;ษอออออออออออออออออออออออออออออออออออออออออออออป
;;;;บ                                             บ
;;;;บ        FOR MISSION EXPLAIN SCREEN           บ
;;;;บ                                             บ
;;;;ศอออออออออออออออออออออออออออออออออออออออออออออผ
;---------
;PLANET_1 0
;PLANET_2 1
;PLANET_3 2
;PLANET_4 3
;PLANET_5 4
;PLANET_6 5
;SOS1     6
;SOS2     7
;SOS3     8
;EXT1     9
;EXT2     10
;EXT3     11
;EXT4     12
	START_PATH	e_explain

;;;	P_WAIT		11

	P_IMPORT	pbyte1,KGameMapPtr	;file shitei
	P_IMPORT	pbyte2,CurrentLevel	;stage shitei
	P_IFBETWEEN	-1,pbyte1,5,.planet

	P_GOSUB		.set_senkan

;;;	P_DO		10
;;;	P_ADD		worldx,-300
;;;	P_NEXT
	
.slow_rot
	P_ADD		roty,2
	P_GOTO		.slow_rot
.set_senkan
;;;	P_ADD		worldx,3000
	P_SET		roty,64
	P_SET		worldy,50
	P_SET		worldz,250
	P_SET		shape,nullshape

	P_GOSUB		mk_demo_senkan

	P_IMPORT	pbyte1,eaction2
	P_IFZERO	pbyte1,.no_cannon_ret
	p_spawn	0,-15<<d_sen_ss_scale,((120)<<d_sen_ss_scale),0,0,0,d_sen_5s,gd_d_sen_parts,1,2,6
	P_BECOME
	P_SETANIM	0
	P_SHADOW	OFF
	P_UNBECOME
.no_cannon_ret
	P_RETURN

;PLANET
.planet
	P_IFNOTSAME	pbyte1,3,.not_stg4
	P_IFNOTSAME	pbyte2,2,.not_stg4
	P_SET		tx,1
	P_EXPORT	KSoundMapPtr,tx
.not_stg4
	P_IFNOTSAME	pbyte1,2,.not_stg3
	P_IMPORT	pword1,eword3
	P_SET		tx,4
	P_IFSWITCH	tx,pword1,.not_stg3
	P_SETSWITCH	tx,pword1
	P_EXPORT	eword3,pword1
	P_SET		pword1,hajimete_maguma_msg
	P_EXPORT	eword2,pword1
.not_stg3

	P_INVISIBLE	OFF
	P_SET		hp,100
	P_RANGECHECK	OFF
	P_ZERO		worldx
	P_ZERO		worldy
	P_ZERO		worldz

	P_SET		ap,6
	P_IMPORT	pword1,PlanetSwitch
	P_IFSWITCH	ap,pword1,.only_core
	
	P_DEC		ap
	P_IFSWITCH	ap,pword1,.only_entrance

	P_IFSAME	pbyte1,0,.venom
	P_IFSAME	pbyte1,1,.taitania
	P_IFSAME	pbyte1,2,.step_nomi
	P_IFSAME	pbyte1,3,.eladard
	P_IFSAME	pbyte1,4,.meteo
	P_IFSAME	pbyte1,5,.forcyuna
.clp
;------------
.venom
	P_IFSAME	pbyte2,4,.v_hard
.step_nomi
	P_GOSUB		.set_step
;;;	P_GOSUB		.shift_step
	P_TRIGGER	.step_rot,Always,64
;;;	P_GOSUB		.shift_l_step
.put_entrance
	P_GOSUB		.rem_child
.only_entrance
	P_GOSUB		.set_base
;;;	P_GOSUB		.shift_base
	P_RTRIGGER	.base_rot,Always
	P_END
;------------
.base_rot
.baria_rot
	P_BECOMECHILD	1
	P_ADD		childroty,2
	P_UNBECOME
	P_RETURN
;------------
.v_hard
	P_GOSUB		.set_boss
	P_IGOTO		.put_entrance
;------------
.taitania
	P_IFNOTSAME	pbyte2,4,.step_nomi
	P_GOSUB		.set_slide
;;;	P_GOSUB		.shift_step
	P_TRIGGER	.slide_rot,Always,64
;;;	P_GOSUB		.shift_l_step
	P_GOSUB		.rem_child
	P_GOSUB		.set_step
;;;	P_GOSUB		.shift_step
	P_TRIGGER	.step_rot,Always,64
;;;	P_GOSUB		.shift_l_step
	P_IGOTO		.put_entrance
;------------
.macbeth
	P_IGOTO		.step_nomi
;------------
.eladard	
	P_IFSAME	pbyte2,2,.e_normal
	P_IFSAME	pbyte2,4,.e_hard
	P_GOSUB		.set_baria
;;;	P_GOSUB		.shift_base
	P_TRIGGER	.baria_rot,Always,64
;;;	P_GOSUB		.shift_l_base
	P_IGOTO		.put_entrance
.e_normal
	P_GOSUB		.set_boss
	P_IGOTO		.put_entrance
.e_hard
	P_GOSUB		.set_baria4
;;;	P_GOSUB		.shift_base
	P_TRIGGER	.baria_rot,Always,64
;;;	P_GOSUB		.shift_l_base
	P_IGOTO		.put_entrance
;------------
.meteo
	P_IFSAME	pbyte2,4,.m_hard
	P_GOSUB		.set_boss
	P_IGOTO		.put_entrance
.m_hard
	P_GOSUB		.set_kaiten1
;;;	P_GOSUB		.shift_step
	P_TRIGGER	.kaiten1_rot,Always,64
;;;	P_GOSUB		.shift_l_step
	P_GOSUB		.rem_child
	P_GOSUB		.set_kaiten2
;;;	P_GOSUB		.shift_step
	P_TRIGGER	.kaiten1_rot,Always,64
;;;	P_GOSUB		.shift_l_step
	P_IGOTO		.put_entrance
;------------
.forcyuna
	P_IFSAME	pbyte2,4,.f_hard
	P_IGOTO		.step_nomi
.f_hard
	P_GOSUB		.set_boss
	P_IGOTO		.put_entrance
;------------
.only_core
	P_IFSAME	pbyte1,2,.core_type2
	P_IFSAME	pbyte1,5,.core_type2
.core_type1
	P_GOSUB		.set_base_core1
	P_END
.core_type2
	P_GOSUB		.set_base_core2
	P_END
;------------
.set_base_core1
	P_SPAWN		0,200,1200,0,0,0,nullshape,e_explain_core1,10,10,1
;	P_SPAWN		0,200,1200,0,0,0,kaku_0_0,e_nocol_s_off,10,10,1
;	P_SPAWN		0,200-19<<kaku_scale,1200,0,0,0,kaku_0_c,e_nocol_s_off,10,10,2
	P_GOSUB		.set_chr_core
	P_RETURN
;------------
.set_base_core2
	P_SPAWN		0,200,900,0,0,0,nullshape,e_explain_core2,10,10,1
;	P_SPAWN		0,200,900,0,0,0,kaku5_0,e_nocol_s_off,10,10,1
;	P_SPAWN		0,200-20<<kaku_scale,900,0,0,0,kaku_0_c,e_nocol_s_off,10,10,2
	P_GOSUB		.set_chr_core
	P_RETURN
;------------
.set_slide
	P_GOSUB		.set_chr_switch
	P_SPAWN		0,300,800,0,0,0,nullshape,e_explain_slide,10,10,7
	P_RETURN
.set_kaiten2
	P_GOSUB		.set_chr_switch
	P_SPAWN		0,500,1200,0,-64,0,nullshape,e_explain_kaiten2,10,10,7
;	P_SPAWN		0,500,1200,0,-32,0,suisya_1,e_clip_obj,100,0,7
;	P_SPAWN		0,500,1200,0,-32,0,suisya_0,e_clip_obj,100,0,8
;	P_SPAWN		0,500,1200,0,0,0,clipshape,e_nocol_s_off,100,0,9
	P_RETURN
.set_kaiten1
	P_GOSUB		.set_chr_switch
	P_SPAWN		0,450,1000,0,-64,0,nullshape,e_explain_kaiten1,10,10,7
;	P_SPAWN		0,450,1000,0,128-16,0,ataru2_1,e_clip_obj_ground,100,0,7
;	P_SPAWN		-77,450,815,0,128-16,43,ataru2_0,e_clip_obj,100,0,8
;	P_SPAWN		0,450,1100,0,0,0,clipshape,e_nocol_s_off,100,0,9
	P_RETURN
.set_baria
	P_SPAWN		0,750,1800,0,0,0,nullshape,e_explain_baria,10,10,1

;;;	P_GOSUB		pe_shield_base.bari_2
	P_SET		pbyte2,2
	P_IGOTO		.bri_exp_lp
.set_baria4
;	P_SPAWN		-71<<planet_base_scale,-14<<planet_base_scale+750,-71<<planet_base_scale+1800,0,96,0,chi_b_1,e_sh_base_shield,100,1,1
;	P_SPAWN		-71<<planet_base_scale,-14<<planet_base_scale+750,71<<planet_base_scale+1800,0,32,0,chi_b_1,e_sh_base_shield,100,2,2
;	P_SPAWN		71<<planet_base_scale,-14<<planet_base_scale+750,-71<<planet_base_scale+1800,0,-96,0,chi_b_1,e_sh_base_shield,100,3,3
;	P_SPAWN		71<<planet_base_scale,-14<<planet_base_scale+750,71<<planet_base_scale+1800,0,-32,0,chi_b_1,e_sh_base_shield,100,4,4

	P_SPAWN		0,750,1800,0,0,0,nullshape,e_explain_baria4,10,10,1
;	P_GOSUB		pe_shield_base.explain_bari4
	P_SET		pbyte2,4
.bri_exp_lp
	P_SET		pbyte1,1
	P_DO		pbyte2
	P_INC		pbyte1
	P_BECOMECHILD	pbyte1
	P_ADD		childy,750
	P_ADD		childz,1800
	P_UNBECOME
	P_INEXT

;	P_GSET		b,gbyte1,0
;	P_DO		4
;	P_SPAWN		0,-14<<planet_base_scale+750,0,0,0,0,chi_b_1,e_sh_base_shield,100,1,1
;	P_BECOME
;	P_IMPORT	pbyte1,gbyte1
;	P_INDEX		childx,bari_exp_tab_x,pbyte1
;	P_INDEX		childz,bari_exp_tab_z,pbyte1
;	P_INDEX		childroty,bari_exp_r_y,pbyte1
;	P_GINC		b,gbyte1
;	P_INC		pbyte1
;	P_SETID		pbyte1
;	P_UNBECOME
;	P_INEXT
;	P_IGOTO		.bari_moji
.bari_moji
	P_SPAWN		0,600,1800,0,0,0,chi_b_0,e_invincible_obj,100,0,6
;	P_SPAWN		-360,-50,750,0,0,0,opchr_b,e_open_chr,100,0,7
;	P_SPAWN		-240,-50,750,0,0,0,opchr_a,e_open_chr,100,0,8
;	P_SPAWN		-120,-50,750,0,0,0,opchr_r,e_open_chr,100,0,9
;	P_SPAWN		0,-50,750,0,0,0,opchr_r,e_open_chr,100,0,10
;	P_SPAWN		120,-50,750,0,0,0,opchr_i,e_open_chr,100,0,11
;	P_SPAWN		240,-50,750,0,0,0,opchr_e,e_open_chr,100,0,12
;	P_SPAWN		360,-50,750,0,0,0,opchr_r,e_open_chr,100,0,13

	P_GSET		b,gbyte1,0
	P_DO		7
	P_SPAWN		0,-50,750,0,0,0,opchr_b,e_open_chr,10,10,1
	P_BECOME
	P_IMPORT	pbyte2,gbyte1
	P_INDEX		childx,bari_moji_x,pbyte2
	P_INDEX		shape,bari_moji_sh,pbyte2
	P_ADD		pbyte2,7
	P_SETID		pbyte2
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
	P_RETURN
.set_boss
	P_GOSUB		.set_chr_switch
;	P_SPAWN		-360,250,750,0,0,0,opchr_u,e_open_chr,100,0,7
;	P_SPAWN		-240,250,750,0,0,0,opchr_n,e_open_chr,100,0,8
;	P_SPAWN		-120,250,750,0,0,0,opchr_k,e_open_chr,100,0,9
;	P_SPAWN		0,250,750,0,0,0,opchr_n,e_open_chr,100,0,10
;	P_SPAWN		120,250,750,0,0,0,opchr_o,e_open_chr,100,0,11
;	P_SPAWN		250,250,750,0,0,0,opchr_w,e_open_chr,100,0,12
;	P_SPAWN		390,250,750,0,0,0,opchr_n,e_open_chr,100,0,13
	P_GSET		b,gbyte1,0
	P_DO		7
	P_SPAWN		0,250,750,0,0,0,opchr_u,e_open_chr,10,10,1
	P_BECOME
	P_IMPORT	pbyte2,gbyte1
	P_INDEX		childx,unknow_moji_x,pbyte2
	P_INDEX		shape,unknow_moji_sh,pbyte2
	P_ADD		pbyte2,7
	P_SETID		pbyte2
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
	P_RETURN
.set_step
	P_SPAWN		0,100,300,0,0,0,on_d,e_explain_shape,100,0,7
;	P_SPAWN		0,100,300,0,0,0,on_d,e_nocol_s_off,100,0,7
	P_BECOME
	P_SETANIM	0
	P_SETCOLANIM	2
	P_UNBECOME
	P_GOSUB		.set_chr_switch
	P_RETURN
.set_chr_switch
;	P_SPAWN		-300,-50,750,0,0,0,opchr_s,e_open_chr,100,0,1
;	P_SPAWN		-160,-50,750,0,0,0,opchr_w,e_open_chr,100,0,2
;	P_SPAWN		-45,-50,750,0,0,0,opchr_i,e_open_chr,100,0,3
;	P_SPAWN		60,-50,750,0,0,0,opchr_t,e_open_chr,100,0,4
;	P_SPAWN		180,-50,750,0,0,0,opchr_c,e_open_chr,100,0,5
;	P_SPAWN		300,-50,750,0,0,0,opchr_h,e_open_chr,100,0,6

	P_GSET		b,gbyte1,0
	P_DO		6
	P_SPAWN		0,-50,750,0,0,0,opchr_s,e_open_chr,10,10,1
	P_BECOME
	P_IMPORT	pbyte2,gbyte1
	P_INDEX		childx,switch_moji_x,pbyte2
	P_INDEX		shape,switch_moji_sh,pbyte2
	P_INC		pbyte2
	P_SETID		pbyte2
	P_GINC		b,gbyte1
	P_UNBECOME
	
	P_INEXT
	P_RETURN
.set_chr_core
;	P_SPAWN		-180,-50,750,0,0,0,opchr_c,e_open_chr,100,0,8
;	P_SPAWN		-60,-50,750,0,0,0,opchr_o,e_open_chr,100,0,9
;	P_SPAWN		60,-50,750,0,0,0,opchr_r,e_open_chr,100,0,10
;	P_SPAWN		180,-50,750,0,0,0,opchr_e,e_open_chr,100,0,11

	P_GSET		b,gbyte1,0
	P_DO		4
	P_SPAWN		0,400,750,0,0,0,opchr_c,e_open_chr,10,10,1
	P_BECOME
	P_IMPORT	pbyte2,gbyte1
	P_INDEX		childx,core_moji_x,pbyte2
	P_INDEX		shape,core_moji_sh,pbyte2
	P_ADD		pbyte2,8
	P_SETID		pbyte2
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
	P_RETURN
.set_base
	P_SPAWN		0,600,1500,0,128-32,0,chika_k1,e_explain_shape,100,0,1
;;;	P_SPAWN		0,600,-50<<planet_base_scale+1500,0,128,0,chika_to,e_building,100,4,2

;	P_SPAWN		-420,-50,750,0,0,0,opchr_e,e_open_chr,100,0,3
;	P_SPAWN		-300,-50,750,0,0,0,opchr_n,e_open_chr,100,0,4
;	P_SPAWN		-180,-50,750,0,0,0,opchr_t,e_open_chr,100,0,5
;	P_SPAWN		-60,-50,750,0,0,0,opchr_r,e_open_chr,100,0,6
;	P_SPAWN		60,-50,750,0,0,0,opchr_a,e_open_chr,100,0,7
;	P_SPAWN		180,-50,750,0,0,0,opchr_n,e_open_chr,100,0,8
;	P_SPAWN		300,-50,750,0,0,0,opchr_c,e_open_chr,100,0,9
;	P_SPAWN		420,-50,750,0,0,0,opchr_e,e_open_chr,100,0,10

	P_GSET		b,gbyte1,0
	P_DO		8
	P_SPAWN		0,-50,750,0,0,0,opchr_e,e_open_chr,10,10,1
	P_BECOME
	P_IMPORT	pbyte2,gbyte1
	P_INDEX		childx,enter_moji_x,pbyte2
	P_INDEX		shape,enter_moji_sh,pbyte2
	P_ADD		pbyte2,3
	P_SETID		pbyte2
	P_GINC		b,gbyte1
	P_UNBECOME
	P_INEXT
	P_RETURN
.rem_child
	P_WAIT		64
	P_REMOVE	1
	P_REMOVE	2
	P_REMOVE	3
	P_REMOVE	4
	P_REMOVE	5
	P_REMOVE	6
	P_REMOVE	7
	P_REMOVE	8
	P_REMOVE	9
	P_REMOVE	10
	P_REMOVE	11
	P_REMOVE	12
	P_REMOVE	13
	P_WAIT		1
	P_RETURN
;;;.shift_step
;;;	P_BECOMECHILD	7
;;;	P_ADD		childx,1000	
;;;	P_UNBECOME
;;;	P_DO		10
;;;	P_BECOMECHILD	7
;;;	P_ADD		childx,-100	
;;;	P_UNBECOME
;;;	P_NEXT
;;;	P_RETURN
;;;.shift_l_step
;;;	P_WAIT		64
;;;	P_DO		10
;;;	P_BECOMECHILD	7
;;;	P_ADD		childx,100	
;;;	P_UNBECOME
;;;	P_NEXT
;;;	P_RETURN
;;;.shift_base
;;;	P_BECOMECHILD	1
;;;	P_ADD		childx,2000	
;;;	P_UNBECOME
;;;	P_DO		10
;;;	P_BECOMECHILD	1
;;;	P_ADD		childx,-200	
;;;	P_UNBECOME
;;;	P_NEXT
;;;	P_RETURN
;;;.shift_l_base
;;;	P_WAIT		64
;;;	P_DO		10
;;;	P_BECOMECHILD	1
;;;	P_ADD		childx,200	
;;;	P_UNBECOME
;;;	P_NEXT
;;;	P_RETURN
.step_rot
.kaiten1_rot
.slide_rot
	P_BECOMECHILD	7
	P_ADD		childroty,2
	P_UNBECOME
	P_RETURN
mk_demo_senkan
	P_GSET		b,gbyte1,0
	P_DO		5
	p_spawn	0,0,0,0,0,0,d_sen_0s,e_nocol_range_off,1,1,1
	P_BECOME
	P_IMPORT	pbyte1,gbyte1
	P_INDEX		childz,d_sen_c_z,pbyte1
	P_INDEX		shape,d_sen_shap,pbyte1
	P_GINC		b,gbyte1
	P_INC		pbyte1
	P_SETID		pbyte1
	P_UNBECOME
	P_INEXT

	P_BECOME
	P_SET		childy,-55<<d_sen_ss_scale
	P_UNBECOME

	P_RETURN
;------------
	START_PATH	e_explain_shape

	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_SET		hp,100
	P_CLRTYPE	enemy1
	P_SETANIM	0
	P_END
;------------
	START_PATH	e_explain_baria4
	P_INC		pbyte1
	START_PATH	e_explain_baria

	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_IFNOTZERO	pbyte1,.b4
	P_GOSUB		pe_shield_base.bari_2
	P_END
.b4
	P_GOSUB		pe_shield_base.explain_bari4
	P_END
;------------
	START_PATH	e_explain_slide

	P_SHADOW	OFF
	P_COLLISIONS	OFF
	P_SPAWN		0,0,240,0,0,0,sli_0,e_explain_shape,10,10,8
	P_SPAWN		0,0,-240,0,0,0,sli_1,e_explain_shape,10,10,9
	P_END
;------------
	START_PATH	e_explain_kaiten2

	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_SPAWN		0,0,0,0,-32,0,suisya_1,e_clip_obj,100,0,8
	P_SPAWN		0,0,0,0,-32,0,suisya_0,e_clip_obj,100,0,9
	P_SPAWN		0,0,0,0,0,0,clipshape,e_explain_shape,100,0,10
	P_END
;------------
	START_PATH	e_explain_kaiten1

	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_SPAWN		0,0,0,0,128-16,0,ataru2_1,e_clip_obj,100,0,8
	P_SPAWN		-77,0,-250,0,128-16,43,ataru2_0,e_clip_obj,100,0,9
	P_SPAWN		0,0,100,0,0,0,clipshape,e_explain_shape,100,0,10
	P_END
;-----------
	START_PATH	e_explain_core1

	P_COLLISIONS	OFF
	P_SHADOW	OFF
	P_SPAWN		0,0,0,0,0,0,kaku_0_0,e_explain_shape,10,10,2
	P_SPAWN		0,-19<<kaku_scale,0,0,0,0,kaku_0_c,e_explain_shape,10,10,3
	P_END
;-----------
	START_PATH	e_hom_item

	P_IFTAMEHOMON	.rem
	P_RADAROBJ	ra_sonota
	P_SET		hp,100
	P_COLLISIONS	OFF
	P_SPAWN		0,0,0,0,0,0,homing_1,e_nocol_s_off,10,10,1
	P_SPAWN		0,0,0,0,0,0,item_ita,e_hom_c,10,10,2

.lp
	P_FACEVIEW	IMMEDIATE
	P_WITHINRADIUS	200,.get
	P_GOTO		.lp
.get
	P_SOUNDEFFECT	special_weapon	;$45
	P_TAMEHOMON
	P_INVISIBLE	ON
	P_REMOVE	1
	P_REMOVE	2
	P_WAIT		20
	P_MSG		214
	P_WAIT		60
	P_MSG		215
.rem
	P_REMOVE

;;-----------
;expo_world
;	P_EXPORT	gword1,worldx
;	P_EXPORT	gword2,worldy
;	P_EXPORT	gword3,worldz
;	P_RETURN
;impo_world
;	P_IMPORT	worldx,gword1
;	P_IMPORT	worldy,gword2
;	P_IMPORT	worldz,gword3
;	P_RETURN
;impo_xz_world
;	P_IMPORT	worldx,gword1
;	P_IMPORT	worldz,gword2
;	P_RETURN
;enemy_hp_meter_hydra
;	P_PUSH		hp
;	P_ADD		hp,-40
;	P_DIV2		hp
;	P_EXPORT	bossmaxhp,hp
;	P_EXPORT	bossHP,hp
;	P_PULL		hp
;	P_RTRIGGER	meterhit_hydra,WhenHit
;	P_RETURN
;meterhit_hydra
;	P_PUSH		hp
;	P_ADD		hp,-40
;	P_DIV2		hp
;	P_EXPORT	bossHP,hp
;	P_PULL		hp
;	P_RETURN
;enemy_hp_meter
;	P_ADD		hp,-50
;	P_EXPORT	bossmaxhp,hp
;	P_EXPORT	bossHP,hp
;	P_ADD		hp,50
;	P_RTRIGGER	.meterhit,WhenHit
;	P_RETURN
;.meterhit
;	P_ADD		hp,-50
;	P_EXPORT	bossHP,hp
;	P_ADD		hp,50
;	P_RETURN
;
;missile_count
;	P_GINC		w,ecountmissile
;	P_GOSUB		dec_EEnemyNumber_skidy
;	P_GDEC		b,KEnemyNumber
;	P_RETURN
;
;fighter_count_gset
;	P_GSET		b,eaction1,255
;fighter_count
;	P_SCREENFLASH
;	P_GOSUB		dec_EEnemyNumber_skidy
;fighter_count_baku
;	P_CLRDEMOSHAPE
;fighter_count_wolf
;	P_GINC		w,ecountfighter
;	P_GDEC		b,KEnemyNumber
;	P_RETURN
;
c_unlink_1234
	P_UNLINKCHILD	1
c_unlink_234
	P_UNLINKCHILD	2
c_unlink_34
	P_UNLINKCHILD	3
c_unlink_4
	P_UNLINKCHILD	4
	P_RETURN
c_flag_1234
	P_FLAGCHILD	1
c_flag_234
	P_FLAGCHILD	2
c_flag_34
	P_FLAGCHILD	3
	P_FLAGCHILD	4
	P_RETURN


