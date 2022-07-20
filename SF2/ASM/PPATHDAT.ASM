;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                                                                    ³
;³                 STARFOX II - REVENGE OF PEPPY -                    ³
;³                                                                    ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³                                                                    ³
;³ FILE:         PPATHDAT.ASM                                         ³
;³ AUTHOR:       Takumi Kawagoe                                       ³
;³ DESCRIPTION:  Demo & Effect for Player                             ³
;³ DATE CREATED: 20-1-93                                              ³
;³                                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	incpub	ppathdat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	PATH DATA for WEAPON
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	player's normal weapon
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; laser
;--------------------------------------------------------------------------------------------

	start_path	Plaser

	p_shadow	off
	p_gosub		Plaserinit
	p_trigger	.hit,WhenHit
	P_RADAROBJ	ra_laser


	P_ZERO		skidy			;skidy=0/beam_0
	p_ifsame	pbyte2,pm_space,.space_skid
	P_ADD		skidy,12
.space_skid
	P_IFSAME	shape,beam_0,.eskid
	P_ADD		skidy,4		;skidy=2/beam_1
	P_IFSAME	shape,beam_1,.eskid
	P_ADD		skidy,4			;skidy=4/beam_2
.eskid
	P_INDEX		shape,big_shap_tab,skidy
	P_INC		skidy

	p_setanim	0
	p_pweaphit	.remove,.dmgremove,.rbdremove
	p_ifareaout	.rbdremove_s

	P_WAIT		1

	p_add	count,-18

	P_INDEX		shape,big_shap_tab,skidy
	P_INC		skidy
	p_setanim	1

	p_pweaphit	.remove,.dmgremove,.rbdremove
	p_ifareaout	.rbdremove_s

	p_add		vx,vx
	p_add		vy,vy
	p_add		vz,vz

	P_ADD		worldx,vx
	P_ADD		worldy,vy
	P_ADD		worldz,vz
	P_IFSAME	shape,beam_2sps,.twin
	P_IFSAME	shape,beam_2,.twin
	P_DO		2
	P_ADD		worldx,vx
	P_ADD		worldy,vy
	P_ADD		worldz,vz
	P_INEXT
	p_ifNOTsame	pbyte2,pm_space,.twin
	P_ADD		worldx,vx
	P_ADD		worldy,vy
	P_ADD		worldz,vz
.twin
	P_WAIT		1

.exitanim
	p_ifsame	pbyte2,pm_space,.space_laser

	P_SET		count,25
	P_IMPORT	slopenum,playerctlmode
	P_IFSAME	slopenum,map_room,.in_room_speed

	P_ADD		count,-15

	P_ADD		vx,vx
	P_ADD		vy,vy
	P_ADD		vz,vz

	P_SET		pword1,vx
	P_DIV2		pword1
	P_ADD		vx,pword1
	P_SET		pword1,vy
	P_DIV2		pword1
	P_ADD		vy,pword1
	P_SET		pword1,vz
	P_DIV2		pword1
	P_ADD		vz,pword1
	P_IGOTO		.lfly
.in_room_speed
	P_TRIGGER	.room_laser_hi,Always
.lfly
	p_do		count
	p_pweaphit	.doremove,.dodmgremove,.dorbdremove
	p_ifareaout	.dorbdremove_s
	p_add		rotz,childrotz
	p_next
	p_igoto		.remove

.room_laser_hi
	P_IFBETWEEN	-300,worldy,0,.hi_ok
	P_FORCE		.hirem
.hi_ok
	P_RETURN
.hirem
	P_TRIGGER	.room_laser_hi,OFF
	P_IGOTO		.remove
;---------------------------------------------------------------
; pbyte2 = planet mode(See Plaserinit)
.space_laser
	P_TRIGGER	.sp_collision_big,Always
	P_DO		4
	p_add		vx,vx
	p_add		vy,vy
	p_add		vz,vz
	P_INEXT
.fly_start
;---------------------------------------------------------------
	p_do		7		;count
	p_pweaphit	.doremove,.dodmgremove,.dorbdremove
	p_add		rotz,childrotz
	p_ifareaout	.dorbdremove_s
	p_next
;---------------------------------------------------------------
; pbyte2 = planet mode(See Plaserinit)
;	p_ifsame	pbyte2,pm_space,.sp
;---------------------------------------------------------------
;.gd
;	p_do		4
;	p_pweaphit	.remove,.dmgremove,.rbdremove
;	p_add		rotz,childrotz
;	p_ifareaout	.rbdremove_s
;;;;;
;	P_QSPAWN	beam_0s,e_test_2,100,0
;	P_BECOME
;	P_SETANIM	1
;	P_UNBECOME
;;;;;
;	p_next
;	p_igoto		.remove
;---------------------------------------------------------------
; space de syatei wo nagakusuru.
;.sp
;	p_add		vx,vx
;	p_add		vy,vy
;	p_add		vz,vz
;	p_add		vx,vx
;	p_add		vy,vy
;	p_add		vz,vz
;;;;;
;	P_TRIGGER	.sp_collision_big,OFF
;;;;;
;	p_do		4		;18
;	p_pweaphit	.remove,.dmgremove,.rbdremove
;	p_add		rotz,childrotz
;	p_next
;---------------------------------------------------------------

.remove	LOCAL
	p_pweapdeclmt
	p_remove

.doremove	P_BREAK
	P_IGOTO		.remove

;---------------------------------------------------------------
.sp_collision_big
	P_INC		pword1
	P_IFSAME	pword1,1,.change
	P_IFSAME	pword1,3,.change
	P_RETURN
.change
	P_INDEX		shape,big_shap_tab,skidy
	P_INC		skidy
	P_RETURN
;.big_shap_tab
;	dw	beam_0s,beam_0sps,beam_0m,beam_0b
;	dw	beam_1s,beam_1sps,beam_1m,beam_0b
;	dw	beam_2s,beam_2sps,beam_2m,beam_2b
;	dw	beam_0s,beam_0,nullshape,nullshape
;	dw	beam_1s,beam_1,nullshape,nullshape
;	dw	beam_2s,beam_2,nullshape,nullshape
;---------------------------------------------------------------
.dodmgremove	P_BREAK
.dmgremove	p_gosub		prou_dmgsound
	p_import		pbyte1,hit_noaffect_chk
	p_ifsame		pbyte1,1,.nopart
	p_qspawn		nullshape,laserpart,10,10
.nopart
	p_igoto			.remove

.dorbdremove	P_BREAK
.rbdremove	p_gosub		prou_rbdsound
	p_igoto		.remove

.dorbdremove_s
	P_BREAK
.rbdremove_s

	p_soundeftdistpos	ob_reboundlaser_s

	p_igoto		.remove




.hit	LOCAL
	p_force		.remove
	p_return


;----------------------------------------------------------------------------------
plaserinit
	p_pweapinclmt

	p_ifsame	shape,beam_2,.APtwintwin

;	P_IFNOTZERO	skidy,.partner

;	p_igoto		.pp
;.partner	P_SOUNDEFTDISTPOS	arwinglaser2	;$27
;.pp

	p_ifsame	shape,beam_1,.APtwin
.AP	p_set		AP,Plaser1AP
	p_soundeffect	arwinglaser1
	p_igoto		.cnt
.APtwin	p_set		AP,Plaser1twinAP
	p_soundeffect	twinblaster
	p_igoto		.cnt
.APtwintwin	p_set		AP,Plaser1twintwinAP

.ttp1	p_soundeffect	twinbmball1


.cnt	p_set		HP,Plaser1HP
	p_settype	laser
	p_settype	friend
	p_clrtype	enemy1
;ok?	p_invincible	on

	P_IMPORT	pbyte2,eandorf_mode
	P_IFSAME	pbyte2,pm_ground,.gd

	p_import	pbyte2,planet_mode
	p_ifsame	pbyte2,pm_space,.sp
.gd	p_setvel	Plaser1VEL
	p_set		count,Plaser1LIF
	p_return
.sp	p_setvel	Plaser1VEL_space
	p_set		count,Plaser1LIF_space
	p_return




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; twin plasma(MISIION)
	start_path	Pplasma0

	P_HITFLASH	OFF
	P_SHADOW	OFF
	P_RADAROBJ	ra_laser
	p_ifsame	shape,plasma1,.normal

.twinP1	P_SOUNDEFFECT	twinbmball1
	p_igoto			.endSE

.normal	P_SOUNDEFFECT	arwingbmball1

.endSE

; no chase
	p_gosub		Pplasmainit
	p_gosub		Pplasmainit_LIF
	p_trigger	.hit,WhenHit

;.main	LOCAL
;	P_SET		slopenum,2
	p_ifsame	pbyte2,pm_space,.pla_space
;	P_DEC		slopenum
	P_ADD		skidy,8
.pla_space
	P_IFNOTSAME	shape,plasma1,.endskid	;twintwin nara jump
;	P_TRIGGER	.pla0_tx_big,Always
	P_ADD		skidy,4
.endskid
	P_INDEX		shape,plasma_tab,skidy
	P_INC		skidy
;	P_IFNOTSAME	shape,plasma1s,.stw
;	P_IGOTO		.first_fl
	P_IFSAME	shape,plasma1s,.first_fl
.stw
	P_ADD		worldx,vx
	P_ADD		worldy,vy
	P_ADD		worldz,vz
.first_fl
	p_pweaphit	.rm,.dmgremove,.rbdremove
	p_ifareaout	.rbdremove_s
	P_wait		1

	P_INDEX		shape,plasma_tab,skidy
	P_INC		skidy

	p_add		vx,vx
	p_add		vy,vy
	p_add		vz,vz

	p_ifsame	pbyte2,pm_space,.sp_shape
	P_IMPORT	slopenum,playerctlmode
	P_IFSAME	slopenum,map_room,.in_room_speed

	P_ADD		count,-15
	p_add		vx,vx
	p_add		vy,vy
	p_add		vz,vz

	P_SET		pword1,vx
	P_DIV2		pword1
	P_ADD		vx,pword1
	P_SET		pword1,vy
	P_DIV2		pword1
	P_ADD		vy,pword1
	P_SET		pword1,vz
	P_DIV2		pword1
	P_ADD		vz,pword1
	p_ifareaout	.rbdremove_s
	p_pweaphit	.rm,.dmgremove,.rbdremove
	P_GOTO		.pl_fly

.in_room_speed
	P_TRIGGER	.room_ten,Always
	p_pweaphit	.rm,.dmgremove,.rbdremove
	p_ifareaout	.rbdremove_s
	P_GOTO		.pl_fly

.room_ten
	P_IFBETWEEN	-300,worldy,0,.ok_hi
	P_FORCE		.tenrm
.ok_hi
	P_RETURN
.tenrm
	P_TRIGGER	.room_ten,OFF
; hit check ha siteoku!
	p_pweaphit	.rm,.dmgremove,.rbdremove
	P_IGOTO		.rm


;.pla0_tx_big
;	P_ADD		tx,slopenum
;	P_RETURN



.face
;	p_alwaysgenvecs	on
;
;	p_swapvar	pword1,ptr
;	p_push		roty
;	p_shapedead	.noface
;	p_faceshape
;.noface	p_pull		roty
;	p_swapvar	pword1,ptr

	p_return

;;;--------------------------------------------
.sp_shape
	p_pweaphit	.rm,.dmgremove,.rbdremove
	p_ifareaout	.rbdremove_s
	P_ADD		worldx,vx
	P_ADD		worldy,vy
	P_ADD		worldz,vz
	P_WAIT		1

	P_DO		4
	p_add		vx,vx
	p_add		vy,vy
	p_add		vz,vz
	P_INEXT

	P_TRIGGER	.shap_chang,Always
.pl_fly
	p_do		count
	p_pweaphit	.remove,.dodmgremove,.dorbdremove
	p_ifareaout	.dorbdremove_s
	p_next
	p_igoto		.rm

.remove	p_break

.rm	p_pweapdeclmt
	p_remove

.dodmgremove	P_BREAK
.dmgremove	;;;p_soundeftdistpos	en_dmg_s
	p_gosub		prou_dmgsound
	p_import		pbyte1,hit_noaffect_chk
	p_ifsame		pbyte1,1,.nopart
	p_qspawn		nullshape,laserpart,10,10
.nopart
	p_igoto			.rm

.dorbdremove	P_BREAK
.rbdremove	p_gosub		prou_rbdsound
	p_igoto		.rm

.dorbdremove_s
	P_BREAK

.rbdremove_s	p_soundeftdistpos	ob_reboundlaser_s
	p_igoto		.rm


.shap_chang
	P_INC		pword1
	P_IFSAME	pword1,1,.cha
	P_IFSAME	pword1,4,.cha
	P_RETURN
.cha
	P_INDEX		shape,plasma_tab,skidy
	P_INC		skidy
	P_RETURN



.hit	LOCAL

	p_force		.to_rm

	p_return
.to_rm
	P_TRIGGER	.hit,OFF
	P_IGOTO		.rm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

pplasmainit
	p_pweapinclmt
	p_set		HP,100		;Pplasma1HP
	p_setvel	0
	p_settype	laser
	p_clrtype	enemy1
;ok?	p_invincible	on
	p_return

pplasmainit_LIF
	P_IMPORT	pbyte2,eandorf_mode
	P_IFSAME	pbyte2,pm_ground,.gd

	p_import	pbyte2,planet_mode
	p_ifsame	pbyte2,pm_space,.sp
.gd	p_set		count,25			;Pplasma1LIF
	p_setvel	Pplasma1vel
;	P_DIV2		vy
	p_return
.sp	p_set		count,6		;Pplasma1LIF_space
	p_setvel	Pplasma1vel_space
;	P_DIV2		vy
	p_return

;plasma_tab
;	dw	beam_2s,beam_2sps,beam_2m,beam_2b
;	dw	plasma1s,plasma1sps,plasma1m,plasma1b
;	dw	beam_2s,beam_2,nullshape,nullshape
;	dw	plasma1s,plasma1,nullshape,nullshape
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	enemy weapon
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	START_PATH	ERing
	START_PATH	RelERing

	p_import	ap,kdifficulty
	p_ifsame	ap,dif_easy,.easy
	p_ifsame	ap,dif_hard,.hard
	P_SET		ap,ERingAP
	p_igoto		.hp
.hard	P_SET		ap,ERingAP+(ERingAP>>1)
	p_igoto		.hp
.easy	P_SET		ap,ERingAP>>1
.hp	P_SET		hp,ERingHP


	P_SET		shape,ringlaser

	p_settype	LASER
	P_SPRITE	0,Eweap_size

	p_QSPAWN	boost,gunblaze,1,1
	P_SOUNDEFTDISTPOS	en_ERing_shot	;$75
	P_SOUND		p2_ERing	;03

	P_IFARWING	.ok_rotx
	P_ADD		rotx,-3
.ok_rotx
	P_QUADVECS	ON
	P_SETVEL	ERingroomVel
	P_COLLISIONS	OFF
	P_WAIT		3
	P_COLLISIONS	ON
	P_TRIGGER	HITREMOVE,WhenHit
	P_TRIGGER	.ring_hit_ck,Always
	P_WAIT		ERingroomLIF
	P_REMOVE
.ring_hit_ck
;************
	p_ifareaout	.rem
;************
	P_HITGROUND	0,.rem
	P_HITSLOPE	.rem
	P_RETURN
.rem
	P_FORCE		.remon
	P_RETURN
.remon
	P_REMOVE
;;;
;;;KAWAGOE'S RING
;;;

	IFEQ		1

	start_path	Ering
	p_set		hp,RelEplasma1HP
	p_set		ap,RelEplasma1AP
	p_set		count,RelEplasma1LIF
	p_igoto		pRelEring.enter

	start_path	RelEring
	p_set		hp,RelEplasma1HP
	p_set		ap,RelEplasma1AP
	p_set		count,RelEplasma1LIF
	p_setvel	RelEplasma1VEL
	p_gosub		prou_rel2player1

.enter	LOCAL

	p_set		shape,ringlaser
	p_sprite	0,Eweap_size


	P_SOUNDEFTDISTPOS	en_ringlaser_s

	p_trigger	.hit,whenhit

	P_DO	count
	P_HITSLOPE	.hit
	P_NEXT
	P_REMOVE

.hit1	p_force		.hit
	p_return


	SHORTA
	LONGI


.hit	P_START65816

	ldy	al_hitlist,x
	a16
	lda.w	hl_alptr,y
	tay
	a8
	cpy	playpt1
	bne	.remove


	pl_jmp_ifitemshield		y,.remove
	pl_jmpnot_ifrollingshield	y,.remove

	sp_jmp_playerctl	y,OF_ARWING,.robot
	sp_jmp_playerctl	y,CS_ARWING,.ufo


.remove	P_END65816
	p_remove

.robot	P_END65816
	p_forcetransform	ROBOT
	p_igoto			.lock

.ufo	P_END65816
	p_forcetransform	UFO

.lock
;	P_START65816
;	ldy		pathplayer&WM
;	toheap		y,y
;	s_set_alvar	B,y,exal_translocktimer,#Eringlocktime
;	P_END65816

	p_remove

	ENDC
;;;
;;;KAWAGOE'S RING END
;;;

;-----------------------------------------------------------------------------
	start_path	Eplasma1

	p_set		hp,Eplasma1HP

	P_IMPORT	ap,KDifficulty
	P_IFSAME	ap,dif_easy,.easy_ap
	P_IFSAME	ap,dif_hard,.hard_ap
	p_set		ap,Eplasma1AP
	P_IGOTO		.ap_e
.hard_ap
	p_set		ap,Eplasma1AP+(Eplasma1AP>>1)
	P_IGOTO		.ap_e
.easy_ap
	p_set		ap,Eplasma1AP>>1
.ap_e
	P_SOUND		p2_EPlasma	;0C
	P_SOUNDEFTDISTPOS	en_ringlaser_s
	P_SHADOW	OFF
	P_SETTYPE	LASER
	P_SET		shape,enemybomb
	P_SPRITE	0,eweap_size
	P_ALWAYSGENVECS	ON

	P_ALWAYSGENVECS	ON
	P_QUADVECS	ON

	P_TRIGGER	HITREMOVE,WhenHit

	P_SETRANDOM	pbyte2,7	;shinpuku_index

	P_IMPORT	pbyte1,Planet_mode
	P_IFNOTSAME	pbyte1,pm_space,.ground_plasma
;;space_plasma
	P_INDEX		childrotx,.haba_tab,pbyte2
	P_SETRANDOM	childroty,7
	P_ADD		childroty,4

	P_DISTLESS	5000,.slow
	P_DISTLESS	7500,.mid
	P_DISTLESS	10000,.fast
	P_DISTLESS	13000,.mostfar
	P_REMOVE
.mostfar
	P_SETVEL	EPlasma1spmostfarVEL
	P_IGOTO		.end_speed_set
.fast
	P_SETVEL	EPlasma1spfarVEL
	P_IGOTO		.end_speed_set
.mid
	P_SETVEL	EPlasma1spmidVEL
	P_IGOTO		.end_speed_set
.slow
	P_SETVEL	EPlasma1spnearVEL
.end_speed_set
	P_SETRANDOM	slopenum,3	;angle_type
	P_SETRANDOM	pbyte2

	P_TRIGGER	.life_ck_sp,Always
.llp
	P_FACEPLAYEROFS	0,0,64
	P_DISTLESS	4000,.sst
	P_GOTO		.llp
.sst
	P_IFBETWEEN	0,vel,Eplasma1spmidVEL,.ok_speed
	P_ACCEL		EPlasma1spmidVEL,2
.ok_speed
.lp
	P_FACEPLAYEROFS	0,0,64
	P_DISTLESS	1500,.st		;1000
	P_GOTO		.lp
.st	
	P_ACCEL		EPlasma1splastVEL,2
	P_TRIGGER	.wave_dat,Always,13
;	P_SET		slopenum,6
;	P_IFSMALLER	childrotx,slopenum,.hazure
;	P_FACEPLAYER	IMMEDIATE
;.hazure
	P_END
.rem
	P_TRIGGER	.life_ck_sp,OFF
	P_TRIGGER	HITREMOVE,OFF
	P_CLEARSTACK
	P_REMOVE
;-----------
.ground_plasma
	P_TRIGGER	.life_ck_gr,Always
	P_IFARWING	.ok_rotx
	P_ADD		rotx,-3
.ok_rotx
	P_QUADVECS	ON
	P_SETVEL	Eplasma1grVEL
	P_COLLISIONS	OFF
	P_WAIT		3
	P_COLLISIONS	ON
	P_WAIT		ERingroomLIF
	P_REMOVE
;***********
;***********
;***********
	IFEQ	1
	P_INDEX		childrotx,.haba_tab_gr,pbyte2
	P_SETRANDOM	childroty,7
	P_ADD		childroty,8
	P_TRIGGER	.life_ck_gr,Always
	P_TRIGGER	.wave_dat,Always
	P_TRIGGER	.syusoku,8
	P_SETVEL	Eplasma1grVEL
	P_SETVEL	15
.glp
	P_DISTLESS	400,.gnear
	P_GOTO		.glp
.gnear
	P_TRIGGER	.wave_dat,OFF
	P_TRIGGER	.syusoku,OFF
	P_WAIT		40
	P_REMOVE
	P_END
	ENDC
;***********
;***********
;***********
;.syusoku
;	P_IFSAME	childrotx,8,.ok
;	P_INC		childrotx
;.ok
;	P_RETURN
.wave_dat
	P_INPLAYERSCONE	-32,32,.hom
	P_RETURN
.hom
	P_FACEPLAYER
	P_RETURN
;;;	P_DISTLESS	7000,.fi
;;;	P_FACEPLAYER	y
;;;	P_RETURN
;;;.fi
;;;	P_FACEPLAYER	IMMEDIATE
;;;	P_RETURN

;	P_INDEX		pbyte1,costab,pbyte2
;	P_DO		childrotx		;2
;	P_DIV2		pbyte1
;	P_INEXT
;
;	P_ADD		pbyte2,childroty
;
;	P_IFZERO	slopenum,.zz
;	P_IFSAME	slopenum,1,.only_x
;	P_IFSAME	slopenum,2,.only_y
;.nzz
;	P_ADD		rotx,pbyte1
;	P_NEG		pbyte1
;	P_ADD		roty,pbyte1
;	P_RETURN
;.zz
;	P_ADD		rotx,pbyte1
;.only_y
;	P_ADD		roty,pbyte1
;	P_RETURN
;.nonly_x
;	P_NEG		pbyte1
;.only_x
;	P_ADD		rotx,pbyte1
;	P_RETURN
;.nonly_y
;	P_NEG		pbyte1
;	P_ADD		roty,pbyte1
;	P_RETURN
.life_ck_sp
;************
	p_ifareaout	.f_rem
;************
	P_INC		pword1
	P_IFNOTSAME	pword1,Eplasma1LIF,.forc
	P_FORCE		.rem
.forc
	P_RETURN
.life_ck_gr
;************
	p_ifareaout	.f_rem
;************
	P_INC		pword1
	P_HITSLOPE	.f_rem
	P_HITGROUND	0,.f_rem
	P_IFNOTSAME	pword1,Eplasma1LIF,.gforc
.f_rem
	P_FORCE		.rem
.gforc
	P_RETURN
.haba_tab
	db	1,1,1,1
.haba_tab_gr
	db	2,2,3,3
	db	3,3,3,3

;;;;;
;;;;;KAWAGOE'S Eplasma1
;;;;;
	IFEQ	1

	start_path	Eplasma1
	p_set		hp,Eplasma1HP
	p_set		ap,Eplasma1AP
;TEST	p_set		count,Eplasma1LIF
;TEST	p_igoto		pRelEplasma1.enter

;;;	p_trigger	.slopeck,always
	p_trigger	HITREMOVE,WhenHit

	p_igoto		pe_pla_test

;.slopeck	p_hitslope	HITREMOVE
;	p_return

	ENDC
;;;;;
;;;;;KAWAGOE'S Eplasma1
;;;;;

;-----------------------------------------------------------------------------
	start_path	RelEplasma1
	p_set		hp,RelEplasma1HP
	p_set		ap,RelEplasma1AP
	p_set		count,RelEplasma1LIF
	p_setvel	RelEplasma1VEL
	p_gosub		prou_rel2player1

.enter	LOCAL

	p_set			shape,enemybomb
	p_sprite		0,Eweap_size

	P_SOUND			p2_Eplasma
	P_SOUNDEFTDISTPOS	en_ringlaser_s
	p_igoto			Eweap.enter

;-----------------------------------------------------------------------------

	start_path	RelElaser_hsp
	p_setvel	RelElaserhspVEL
	p_add		vx,vx
	p_add		vy,vy
	p_add		vz,vz
	p_igoto		pRelElaser.enter


;-----------------------------------------------------------------------------
	start_path	RelElaser
	p_setvel	RelElaserVEL

.enter	LOCAL
	p_set		hp,RelElaserHP
	p_set		ap,RelElaserAP
	p_set		count,RelElaserLIF
	p_gosub		prou_rel2player1
	p_igoto		pElaser.enter

;-----------------------------------------------------------------------------
	start_path	Elaser

	p_set		hp,ElaserHP

	P_IMPORT	ap,KDifficulty
	P_IFSAME	ap,dif_easy,.easy_ap
	P_IFSAME	ap,dif_hard,.hard_ap
	p_set		ap,ElaserAP+(ElaserAP>>1)
	P_IGOTO		.ap_e
.hard_ap
	P_SET		ap,ElaserAP+ElaserAP
	P_IGOTO		.ap_e
.easy_ap
	p_set		ap,ElaserAP
.ap_e
	p_set		count,ElaserLIF
	P_DISTLESS	12000,.enter
	P_REMOVE

.enter	LOCAL
	P_SOUNDEFTDISTPOS	en_laser_sL
	p_shadow	off
	P_ALWAYSGENVECS	ON
	p_settype	LASER
	p_trigger	HITREMOVE,WhenHit

	P_QUADVECS	ON
	P_SETVEL	ELaserVEL

	p_set		shape,laser_0
	p_QSPAWN	boost,gunblaze,1,1
	p_import	pbyte1,planet_mode
	P_IFNOTSAME	pbyte1,pm_space,Eweap.enter		;if planet then jump

	P_TRIGGER	.life_ck_sp,Always
	P_SETVEL	63
.come
	P_DISTLESS	1000,.near	;3000
	P_MOVEINPLAYER	127	;Elaserspmovein		;100
	P_MOVEINPLAYER	127	;Elaserspmovein		;100
	P_MOVEINPLAYER	127	;Elaserspmovein		;100
	P_FACEPLAYER	IMMEDIATE
	P_GOTO		.come
.near
	P_FACEPLAYER	IMMEDIATE
;	P_SETVEL	ElasersplastVEL		;30
	P_SETVEL	63
	P_IGOTO		.jyairo_laser
	P_IFSAME	skidy,1,.jyairo_laser

	P_WAIT		ElaserspLIF
.rem
	P_REMOVE
.jyairo_laser
	P_TRIGGER	.face_cha,2
	P_TRIGGER	.throu_ck,WhenThrough
	P_DO		40
	P_NEXT
;	P_WAIT		80		;ElaserspLIF
	P_REMOVE
.throu_ck
	P_FORCE		.throued
	P_RETURN
.throued
	P_TRIGGER	.face_cha,OFF
	P_TRIGGER	.throu_ck,OFF
	P_WAIT		15
	P_REMOVE
.face_cha
	P_PLAYERINCONE	32,.fac
;	P_BEHINDPLAYER	.pass
	P_RETURN
.fac
	P_FACEPLAYER
;.pass
	P_RETURN

.life_ck_sp
;************
	p_ifareaout	.frem
;************
	P_INC		pword1
	P_IFNOTSAME	pword1,ELaserspLIF,.forc
.frem
	P_FORCE		.rem
.forc
	P_RETURN

;;;;
;;;;KAWAGOE'S ELASER
;;;;
	IFEQ		1
	start_path	Elaser
	p_set		hp,ElaserHP
	p_set		ap,ElaserAP
	p_set		count,ElaserLIF

.enter	LOCAL

	p_set		shape,laser_0
	p_spawn		0,0,0,0,0,0,boost,gunblaze,1,1


	p_wait	1

	p_igoto		Eweap.enter

	ENDC
;;;;
;;;;KAWAGOE'S ELASER END
;;;;
;-----------------------------------------------------------------------------

	start_path	Erebound

	P_HITFLASH	OFF

	p_set		count,REBOUNDLIF
	p_setvel	50

	p_ifnotsame	shape,beam_2,Eweap
	p_trigger	Eweap.faceview,always


;-----------------------------------------------------------------------------
;init

Eweap

.enter	LOCAL
	p_shadow	off
	p_settype	LASER
	p_trigger	HITREMOVE,WhenHit
	p_import	pbyte1,planet_mode
	p_ifsame	pbyte1,pm_space,.space
	p_trigger	.alwaysG,always
	p_igoto		.main
.space	p_trigger	.alwaysS,always
.main	P_do		count
	p_next

.remove	p_remove



.alwaysG	P_HITGROUND	0,.hitted
.alwaysS	P_HITSLOPE	.hitted
	p_return
.hitted	p_force	.remove
	p_return

.faceview	LOCAL
	p_faceview	immediate
	p_return
;-----------------------------------------------------------------------------

	start_path	HomEmissile

	P_SET		hp,HomEmissileHP
	P_SET		ap,HomEMissileAP
	P_DISTLESS	10000,.ok_dist
	P_REMOVE
.ok_dist
	P_SOUND		p2_EMissile	;02
	P_CLRTYPE	LASER
	P_SOUNDEFFECT	en_missileshoot_s
	p_trigger	.hit,WhenHit

	P_QUADVECS	ON
	P_SETVEL	2

	p_alwaysgenvecs	on

	p_import	pbyte1,planet_mode


	P_IFSAME	skidy,1,.mini_miss
	P_IFSAME	skidy,2,.big_miss

	P_SET		shape,missile
	P_IGOTO		.go
.big_miss
	P_SET		shape,missile_l
	P_IGOTO		.go
.mini_miss
	P_SET		shape,missile_s
.go
	P_IFNOTSAME	skidy,1,.not_kanimiss
	p_do	10
	P_ADD		worldy,10
	p_add	rotz,5
	p_next
.not_kanimiss
	P_IFNOTSAME	skidy,2,.not_strong3
	P_QUADVECS	ON
	P_SETVEL	45		;30
	P_IGOTO		.aa
.not_strong3
	P_ACCEL		20,2
.aa
	P_IFSAME	skidy,1,.mini_miss1
	P_IFSAME	skidy,2,.big_miss1
	p_spawn	0,0,-120,0,0,0,boost,missileboost,1,1,1
	P_IGOTO		.go1
.big_miss1
	p_spawn	0,0,-480,0,0,0,boost,missileboost,80,1,1
	P_IGOTO		.go1
.mini_miss1
	p_spawn	0,0,-60,0,0,0,boost,missileboost,1,1,1
.go1

	P_TRIGGER	.miss_fly,Always

;	P_WAIT		HomEmissileLIF
	P_DO		HomEmissileLIF
	P_NEXT
.remove
	P_TRIGGER	.miss_fly,OFF
.remove_b
	p_distless	1000,.exp
	p_remove
.exp	p_set	hp,0
	p_end
.miss_fly
	P_COLLISIONS	ON
	P_INPLAYERSCONE	-50,50,.able
	P_BEHINDPLAYER	.tto_remove
	P_COLLISIONS	OFF
.able
	P_IFSAME	skidy,2,.near_made
	P_DISTLESS	500,.near
.face
	P_FACEPLAYER	IMMEDIATE
	P_HITSLOPE	.to_remove
	P_IFSAME	pbyte1,pm_space,.cnt
	P_HITGROUND	0,.to_remove
.cnt
	P_ADD		rotz,5
	P_RETURN
.near_made
	P_DISTLESS	100,.near
	P_IGOTO		.face
.to_remove
	P_HITFLASHTRIG
.tto_remove
	P_FORCE		.remove
	P_RETURN
.near
	P_FORCE		.near_break
	P_RETURN
.near_break
	P_TRIGGER	.miss_fly,OFF
	P_WAIT		30
	P_IGOTO		.remove_b

.hit	p_force		.remove
	p_return

;;;;
;;;;KAWAGOE'S HomEMissile
;;;;
	IFEQ		1
	start_path	HomEmissile

	p_set		hp,HomEmissileHP
	p_set		ap,HomEmissileAP
	p_set		count,HomEmissileLIF

	p_set		shape,missile

	p_clrtype	LASER

	P_SOUNDEFFECT	en_missileshoot_s

	p_trigger	.hit,Whendead

	p_setvel	HomEmissilevel
	p_alwaysgenvecs	on

	p_import	pbyte1,planet_mode

	p_do	10
	p_add	rotz,5
	p_next

	p_spawn	0,0,-120,0,0,0,boost,missileboost,1,1,1

	p_add	count,-10
	p_do	count

	p_distless	500,.noface
	p_andframegoto	3,.face
	p_igoto		.noface
.face	p_faceplayer
.noface	P_HITSLOPE	.remove

	P_IFSAME	pbyte1,pm_space,.cnt
	P_HITGROUND	0,.remove
.cnt
	p_add	rotz,5
	p_next

.remove
	p_distless	1000,.exp
	p_remove
.exp	p_set	hp,0
	p_end

.hit	p_force		.remove
	P_CIRCLEWINDOW	-2
;	P_SCREENFLASH
	p_return

	ENDC
;;;;
;;;;KAWAGOE'S HomEMissile END
;;;;
;-----------------------------------------------------------------------------

HITREMOVE	p_force		.remove
	p_return
.remove	p_remove

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	test path
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	SHORTA
	LONGI

	start_path	spinner


	p_set		hp,100
	p_set		ap,4

	p_setvel	48

	p_collisions	off

	p_setmarker	1

	p_spawn	0,-10<<spin_scale,0,0,0,0,spin_1,spinnertop,10,10,1
	p_spawn	0,10<<spin_scale,0,deg180,0,0,spin_1,spinnerbase,10,10,1

	p_spawn	0,0,-60<<spin_scale,0,000,0,spin_0,spinnerarm,10,10,1
	p_spawn	51<<spin_scale,0,30<<spin_scale,0,085,0,spin_0,spinnerarm,10,10,1
	p_spawn	-51<<spin_scale,0,30<<spin_scale,0,170,0,spin_0,spinnerarm,10,10,1

	p_alwaysgenvecs	on

.loop0	p_add		roty,5
	p_goto		.loop0

	p_end


	start_path	spinnertop

	p_collisions	off

	p_spawn	0,-20<<spin_scale,-25<<spin_scale,0,000,0,spin_3,spinnernipple,10,10,1
	p_spawn	17<<spin_scale,-20<<spin_scale,10<<spin_scale,0,85,0,spin_3,spinnernipple,10,10,1
	p_spawn	-17<<spin_scale,-20<<spin_scale,10<<spin_scale,0,170,0,spin_3,spinnernipple,10,10,1

.loop0	p_add	childroty,5
	p_goto	.loop0
	p_end



	start_path	spinnerbase

	p_collisions	off

	p_spawn	0,-20<<spin_scale,-25<<spin_scale,0,000,0,spin_3,spinnernipple,10,10,1
	p_spawn	17<<spin_scale,-20<<spin_scale,10<<spin_scale,0,170,0,spin_3,spinnernipple,10,10,1
	p_spawn	-17<<spin_scale,-20<<spin_scale,10<<spin_scale,0,85,0,spin_3,spinnernipple,10,10,1

.loop0	p_add	childroty,-5
	p_goto	.loop0
	p_end


	start_path	spinnernipple
	p_collisions	off

	p_weapon	Eplasma1
.loop0
	p_goto		.loop0

	P_START65816
	lda	gameframe
	and	#31
	bne	.loopend
	P_END65816


	p_fire
	p_igoto		.fireend

.loopend	P_END65816

.fireend

	p_goto		.loop0

	p_end


	start_path	spinnerarm
	p_collisions	off
	p_end

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	END of FILE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	end




