;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;�                                                                    �
;�                 STARFOX II - REVENGE OF PEPPY -                    �
;�                                                                    �
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
;�                                                                    �
;� FILE:         GPATHDAT.ASM                                         �
;� AUTHOR:       Takumi Kawagoe                                       �
;� DESCRIPTION:  Demo & Effect for Player                             �
;� DATE CREATED: 10-4-95                                              �
;�                                                                    �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	incpub	gpathdat

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;	TEST PATH
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	start_path	mr_debug

;	p_radarobj	ra_enemy	; display radar
;	p_collisions	off
;
;.loop	p_setmarker	1
;	p_goto	.loop
;
;	p_end

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;	TEST PATH
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	start_path	ninten_r

	p_collisions	off

	p_set	coltab,id_1_c&WM

	p_wait	25h

	p_set	coltab,id_0_c&WM

	p_end

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	rebound
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	start_path	Prebound

	p_shadow	off

	p_set		hp,REBOUNDHP
	p_set		ap,REBOUNDAP
	p_set		count,REBOUNDLIF

	p_settype	laser
	p_settype	friend
	p_clrtype	enemy1

	p_setvel	60

	p_gosub		prou_rel2player1

	p_trigger	HITREMOVE,WhenHit

	P_HITFLASH	OFF

.main	LOCAL

	p_do		count

	p_hitground	0,.remove

	p_next

.remove	p_remove


;------------------------------------------------------------------------------------
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	Preboundbat
	p_settype	laser
	p_settype	friend
	p_clrtype	enemy1
	p_setvel	60
	p_gosub		prou_rel2playerX
	p_trigger	HITREMOVE,WhenHit
.main	LOCAL
	p_do		count
	p_hitground	0,.remove
	P_START65816
	s_set_objtobealvar	y,x,al_ptr
	toheap			y,y
	lda			exal_SPweaponstatus,y
	and			#exal_SPweaponstatus_rebound
	beq			.sfoff
.sfon	s_jmp_alsflag		x,sflag1,.alive
	bra			.kill
.sfoff	s_jmpnot_alsflag	x,sflag1,.alive
.kill	s_set_alvar		B,x,al_pbyte1,#255
.alive	P_END65816
	p_ifsame		pbyte1,255,.remove
	p_next
.remove	p_collisions	off
	p_remove
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	Friend's weapon
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	IFEQ	1
	start_path	Flaser
	p_shadow	off
	p_set		count,Pplasma1LIF
	p_settype	laser
	p_settype	friend
	p_clrtype	enemy1
	p_invincible	on
	p_set		shape,beam_0
	p_set		ap,FlaserAP
	p_set		hp,FlaserHP
	p_setvel	FlaserVEL
	p_set		count,FlaserLIF
	p_add		roty,deg180
	p_trigger	HITREMOVE,WhenHit
	p_import	pbyte1,planet_mode
	P_DO		count
	p_ifsame	animframe,128,.exitanim
	p_addanim	-1,3
.exitanim	P_HITSLOPE	.remove
	P_IFSAME	pbyte1,pm_space,.cnt
	P_HITGROUND	0,.remove
.cnt	P_NEXT
.remove	P_REMOVE
	ENDC

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	SPECIAL WEAPON
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	Pmissile
	P_SOUNDEFTDISTPOS	bomshoot
	p_settype	friend
	p_clrtype	enemy1
	p_set	shape,miss_4
	p_setvel	0
	p_do	10
	p_copyplayerpos
	p_chase	childy,50
	p_add	worldy,childy
	p_next
	p_spawn	0,0,-50,0,0,0,boost,missileboost,1,1,100
	p_alwaysgenvecs	on
	p_do		100
	p_accel		80,5
	p_add		worldx,childx
	p_add		worldz,childz
	p_andframegoto	1,.next
	p_chase		childx,0
	p_chase		childz,0
.next	p_next
	p_set	hp,0
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	p_remove
	ENDC


;----------------------------------------------------------------------------------

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	arwingdummy

;	al_pword1 : life counter

	P_SOUNDEFTDISTPOS	bomshoot
	p_settype	laser
	p_settype	friend
	p_clrtype	enemy1
	p_alwaysgenvecs	on
	p_add	vel,30
	p_add	worldy,-2
	p_do		13
	p_setanim	0
	p_accel		dummyVEL,2
	p_chase		rotx,0
	p_next
	p_do		7
	p_addanim	1,8
	p_chase		rotx,0
	p_next
.hitck	P_START65816
	jsl	chk_spweappnt_srou_l
	jsl	setenemymark_srou_l
	stx	dummyptr
	P_END65816
	p_ifnotsame	pword1,300,.cnt
.kill	p_set		HP,0
.cnt	p_inc		pword1
	p_goto		.hitck

	p_remove

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;----------------------------------------------------------------------------------

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	robotdummy
;	pbyte1 : special weapon pointer
;	pword1 : special weapon pointer
;	childx : life counter
	P_SOUNDEFTDISTPOS	bomshoot
	p_settype	laser
	p_settype	friend
	p_clrtype	enemy1
	P_START65816
	s_clr_alcollflag	x,WEAPON
	P_END65816
	p_slope	on
	p_alwaysgenvecs	on
	p_set	vel,30
	p_add	worldy,-2
	p_set	rotx,-3cH
	p_do		13
	p_setanim	0
	p_accel		8,2
	p_chase		rotx,0
	p_next
	p_do		7
	p_addanim	1,8
	p_chase		rotx,0
	p_next
	p_alwaysgenvecs	off
	p_set		vx,0
	p_set		vy,2
	p_set		vz,0
.hitck	P_START65816
	stx	dummyptr
	jsl	chk_spweappnt_srou_l
	jsl	setenemymark_srou_l
	lda	al_childx,x
	bit	#7
	bne	.nockhigh
	jsl	getheight_l
	s_set_alvar	W,x,al_pword1,y1
.nockhigh	a16
	lda	al_worldy,x
	sec
	sbc	al_pword1,x
	bmi	.noton	
	lda	al_pword1,x
	sta	al_worldy,x
	a8
	lda	#0
	bra	.cxx
.noton	a8
	lda	al_childx,x
	and	#8
	bne	.cx1
.cx0	lda	#10
	bra	.cxx
.cx1	lda	#-10
.cxx	sta	al_childrotx,x
.nocx
.end65	P_END65816
	p_chase		rotx,childrotx
	p_chase		rotz,childrotx
	p_ifnotsame	childx,255,.cnt
	p_set		HP,0
.cnt	p_inc		childx
	p_goto		.hitck
	p_remove

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;--------------------------------------------------------------------------------------
spreadr	equ	60
spp_insea	equ	1<<0


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	spreadplasma
; childrotx	:	planet_mode
; pbyte1	:	find wo wait suru timer
; pbyte2	:	no hit timer
	p_collisions	on
	p_alwaysgenvecs	on
;	p_settype	laser
	p_settype	friend
;	p_invincible	on
	p_set		hp,100
	p_import	pbyte1,planet_mode
	p_ifsame	pbyte1,pm_space,.space
.ground	p_trigger	.always_g,always
	p_igoto		.gp
.space	p_trigger	.always,always
.gp	p_trigger	.whenhit,whenhit
	p_set		shape,nullshape
	p_clrtype	ENEMY1
	p_clrtype	ENEMY2
; set shape
	p_set		shape,bomb
;	p_spawn		0,0,0,0,0,0,line,e_nocol_s_off,1,1,1
	p_sprite	0,7
	p_set		pbyte1,0
	p_set		pbyte2,0	; nohit timer
	p_setvel	127	; init vel
	p_set		ptr,0
	P_DO		spreadLIF
	P_SHAPEDISTLESS	3500,.facestart
	p_set		ptr,0
.facestart	p_shapedead	.find
	p_objincone	deg90,.face4
	p_igoto		.face2
.face4	p_faceshape
	p_faceshape
.face2	p_faceshape
	p_faceshape
	P_START65816
	s_set_objtobealvar	y,x,al_ptr
	s_jmp_alsflag		y,colldisable,.findagain
	s_jmpnot_alsflag	y,nohitaffect,.cntc
.findagain	s_set_alvar		W,x,al_ptr,#0
.cntc	P_END65816
	p_igoto			.nofind
;------------
.find	p_ifnotsame		pbyte1,0,.faceplayer	;.nofind
	p_set			pbyte1,8
	P_START65816
	sm_jmp_if1screen	.findenemy
	ldy	al_pword1,x
	s_jmp_alsflag	y,player2,.p1
.p2	ldy	playpt2
	bra	.pp
.p1	ldy	playpt1
.pp
.setpp	sty	al_ptr,x
	P_END65816
	p_igoto			.nofind
.findenemy	P_END65816
	p_findenemyshape	6000,90,.findenemy2
	p_igoto			.nofind
.findenemy2	p_findenemyshape	10000,255,.faceplayer
	p_igoto			.nofind
.faceplayer	p_faceplayerofs		0,0,80
.nofind	p_dec		pbyte2
	p_ifnotsame	pbyte2,0,.coloff
	p_collisions	on
.coloff	p_ifsame	pbyte1,0,.nopbyte1
	p_dec		pbyte1
.nopbyte1	p_accel		spreadVEL,2
	p_pweaphit	.circle,.circle,.circle
	p_igoto		.next
.circle	P_CIRCLEWINDOW	1
	p_set		pbyte2,10	; nohit timer
;	p_collisions	off
.next	P_NEXT
.remove	P_CIRCLEWINDOW	1
	P_SOUNDEFTDISTPOS	bomexplode
	p_remove
;------------------------------------------------------------------------------------
.always_g	; hit ground?
	p_nothitground	30,.always
	p_set		worldy,30
	p_set		rotx,0
.always	P_START65816
	ldy	al_pword1,x
	toheap	y,y
	lda	exal_spweap_TYPE,y
	cmp	#spweap_smartplasma
	bne	.nolmt
	lda	exal_SPweaponstatus,y
	and	#exal_SPweaponstatus_counter^-1
	ora	#2
	sta	exal_SPweaponstatus,y
	lda	KEnemyNumber
	beq	.stgclr
.nolmt	P_END65816
	p_return
.stgclr	P_END65816
	p_force		.remove
	p_return
.whenhit	P_CIRCLEWINDOW	1
	p_set		hp,100
	p_set		pbyte2,10	; nohit timer
	p_collisions	off
	p_return


	p_remove

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;----------------------------------------------------------
;	start_path	spreadbeam_child
;
;	p_collisions	off
;
;	p_set		hp,1
;	p_set		ap,8
;
;	p_immune
;
;	P_START65816
;	s_set_alsflag		x,notslope
;	pl_set_area		x,-1
;	s_clr_colltype		x,ENEMY1
;	P_END65816
;	p_sprite		0,-4
;
;
;	P_DO	4
;	P_START65816
;	a16
;	lda	al_childx,x
;	jsl	perc62A_l
;	sta	al_childx,x
;	lda	al_childy,x
;	jsl	perc62A_l
;	sta	al_childy,x
;	a8
;	P_END65816
;	P_NEXT
;
;	p_remove
;

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	Tame tame
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	start_path	tametame

	p_collisions	off

	p_wait	2
	p_set		shape,tametame
	p_sprite	0,0

	p_trigger	.always,always

	p_do		8
	p_add		tx,1
	p_next


.loop	p_import	pbyte2,P1_maxMETER
	p_ifsame	pbyte1,pbyte2,.red	;powermetermax,.red
	p_goto		.loop

.red
	p_sprite	0,0
	p_set		tx,8
	p_set		shape,tamatama

	p_end


.always	P_START65816
	jsl	tametame00_path_l
	P_END65816
	p_return


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	player's powerd laser
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	start_path	Ppowerdlaser

	P_QUADVECS	ON

	p_shadow	off

	p_import	ptr,p1_markptr


;	IFEQ	tamehomon
;	p_zero		ptr
;	ENDC


	p_soundeffect	longlaser1

	p_setanim	4

;	p_set		HP,PpowerdlaserHP
;	p_set		AP,PpowerdlaserAP

	p_settype	laser
	p_settype	friend
	p_clrtype	enemy1


	p_import	pbyte2,planet_mode
	p_ifsame	pbyte2,pm_space,.sp
.gd	p_setvel	60	;PpowerdlaserVEL
	p_set		count,PpowerdlaserLIF
	p_igoto		.skip0
.sp	p_setvel	120	;PpowerdlaserVEL_space
	p_set		count,PpowerdlaserLIF_space
.skip0

	p_set	childrotx,rotx
	p_set	childroty,roty
	p_set	childrotz,rotz

	p_trigger	.rnd,always

.untilanim

	p_do		4
	p_addanim	-1,8
	p_pweaphit	.Bremove,.dmgremove,.rbdremove
	p_add		rotz,childrotz
	p_next


	p_add		count,-10
	p_set		shape,tamel


	p_do		count

	p_ifsame	animframe,128+7,.noanim
	p_addanim	1,8
.noanim
	p_set	rotx,childrotx
	p_set	roty,childroty
	p_set	rotz,childrotz

	p_shapedead	.nochase

	p_faceshape

	p_moveinshape	100
	p_moveinshape	100
	p_moveinshape	100

	p_setvel	120	;PpowerdlaserVEL_space

	p_igoto	.skip

.nochase
	p_setvel	120	;PpowerdlaserVEL_space

	p_add	vx,vx
	p_add	vy,vy
	p_add	vz,vz

.skip	p_set	childrotx,rotx
	p_set	childroty,roty
	p_set	childrotz,rotz

	p_pweaphit	.Bremove,.dmgremove,.rbdremove
	p_ifareaout	.Bremove

	p_next

;;;;.remove	LOCAL


	p_remove



.dmgremove	P_BREAK
	p_gosub		prou_dmgsound
	p_qspawn	nullshape,laserpart,10,10
	p_remove


.rbdremove	P_BREAK
	p_gosub		prou_rbdsound
	p_remove

.Bremove	P_BREAK
	p_remove


.rnd	p_setrandom	rotx,255
	p_setrandom	roty,255
	p_setrandom	rotz,255
	p_return




;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	WINGMAN
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	wingman
childno_wingman_boost	equ	10
wgmode_away		equ	1
wgmode_find		equ	2
wgmode_chase		equ	3
wgmode_fire		equ	4
wgmode_chaseplayer	equ	5
wgmode_pullup	equ	6
wgmode_pulldown	equ	7
	p_clrtype	ENEMY1
	p_settype	ENEMY2
	p_collisions	on
	p_invincible	on
	p_set		hp,100
	p_set		ap,0
	p_set		tx,0
	p_weapon	Flaser
	p_trigger	.wg_trigger,always
	p_alwaysgenvecs	on
	p_set		pbyte1,wgmode_find
	p_setvel	35
.loop	p_ifsame	pbyte1,wgmode_away,.wgmode_away
	p_ifsame	pbyte1,wgmode_chase,.wgmode_chase
	p_ifsame	pbyte1,wgmode_fire,.wgmode_fire
	p_ifsame	pbyte1,wgmode_find,.wgmode_find
	p_ifsame	pbyte1,wgmode_chaseplayer,.wgmode_chaseplayer
	p_ifsame	pbyte1,wgmode_pullup,.wgmode_pullup
	p_ifsame	pbyte1,wgmode_pulldown,.wgmode_pulldown
	p_igoto		.wgmode_find
;-----------------------------------------------------------------------------------
; goto away
.wgmode_away	p_chase		rotx,0
	p_setrandom	count,31
	p_add		count,60
	p_set		ty,2
	p_andframegoto	1,.wgmode_away0
	p_set		ty,-2
.wgmode_away0
	p_do	count
	p_add	roty,ty
	p_chase	rotx,0
	p_next
	p_set	pbyte1,wgmode_find
	p_igoto	.end
;-----------------------------------------------------------------------------------
.wgmode_chase
	p_shapedead	.wgmode_fire_find
	p_shapedistless	4000,.wgmode_chase_fire
	p_accel		40,3
	p_andframegoto	1,.end
	p_faceshape
	p_igoto		.end
.wgmode_chase_fire
	p_set	pbyte1,wgmode_fire
	p_igoto	.end
;-----------------------------------------------------------------------------------
.wgmode_fire	p_shapedead	.wgmode_fire_find
	p_shapedistless	500,.wgmode_fire_away
	p_accel		40,3
	p_faceshape
	p_objincone	30,.fire
	p_igoto		.end
.fire	p_andframegoto	7,.dofire
	p_igoto		.end
.dofire	p_fire
	p_igoto		.end
.wgmode_fire_away
	p_set	pbyte1,wgmode_away
	p_igoto	.end
.wgmode_fire_find
	p_set	pbyte1,wgmode_away
	p_igoto	.end
;-----------------------------------------------------------------------------------
.wgmode_chaseplayer
	p_distless	200,.wgmode_chaseplayer_away
	p_accel		50,5
	p_andframegoto	1,.end
	p_faceplayerofs	10,-5,10
	p_igoto		.end
.wgmode_chaseplayer_away
	p_set		pbyte1,wgmode_away
	p_igoto		.end
;-----------------------------------------------------------------------------------
.wgmode_pulldown
;	p_print		rotx,h,kawagoe
;	p_print		worldy,h,kawagoe
	p_do		8
	p_push		rotx
	p_andframegoto	1,.wgm_pd0
	p_faceplayerofs	10,-5,10
.wgm_pd0	p_pull		rotx
	p_chase		rotx,20
	p_next
	p_set		pbyte1,wgmode_chaseplayer
	p_igoto	.end
;-----------------------------------------------------------------------------------
.wgmode_pullup
;	p_print		rotx,h,kawagoe
;	p_print		worldy,h,kawagoe
;	p_print		vy,h,kawagoe
	p_do	8
	p_push		rotx
	p_andframegoto	1,.wgm_pu0
	p_faceplayerofs	10,-5,10
.wgm_pu0	p_pull		rotx
	p_chase		rotx,-20
	p_next
	p_set		pbyte1,wgmode_chaseplayer
	p_igoto	.end
;-----------------------------------------------------------------------------------
.wgmode_find	p_set		pbyte2,0
	p_do		32
	p_ifnotsame		pbyte2,7,.wgmode_find_next
	p_set			pbyte2,0
	p_findenemyshape	16000,255,.wgmode_find_next
	p_break			.wgmode_find_chase
.wgmode_find_next
	p_chase	rotx,0
	p_next
	p_set	pbyte1,wgmode_chaseplayer
	p_igoto	.end
.wgmode_find_chase
	p_set	pbyte1,wgmode_chase
	p_igoto	.end
;---------------------------------------------------------------------------------
.end	p_goto		.loop
	p_end
.wg_trigger
;	p_print	pbyte1,h,kawagoe
	p_inc		pbyte2
	p_setmarker	1
	P_START65816
	lda	al_roty,x
	sec
	sbc	al_tx,x
	asl	a
	asl	a
	asl	a
	asl	a
	sta	z1
	s_achase_alvar	B,x,al_rotz,z1,2
	P_END65816
	p_set		tx,roty
	p_import	pword1,battlearea_maxy
	p_ifsmaller	worldy,pword1,.wg_gotopulldown
	p_import	pword1,battlearea_miny
	p_add		pword1,-50
	p_iflarger	worldy,pword1,.wg_gotopullup
	p_distmore	4000,.wg_gotochaseplayer
	p_return
.wg_gotofind	p_set		pbyte1,wgmode_find
	p_return
.wg_gotopullup
	p_import	pword1,battlearea_miny
	p_chase		worldy,pword1
	p_set		pbyte1,wgmode_pullup
	p_return
.wg_gotopulldown
	p_import	pword1,battlearea_maxy
	p_chase		worldy,pword1
	p_set		pbyte1,wgmode_pulldown
	p_return
.wg_gotochaseplayer
	p_set	pbyte1,wgmode_chaseplayer
	p_return
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	ENDC



;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	ANDORF CORE
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

;	P_BOSSMODELIST	And_box0
;	P_BOSSMODE	preturn

;andboxdead_cut1	equ	1

childno_andorf	equ	1


	P_BOSSFLAGLIST
	P_BOSSFLAG	abf_ba_dead

	start_path	and_box0

	P_ENEMYDMGSE	bs_andorf_damage

	P_CLRBOSSFLAGS

	p_set		hp,50

	p_Qspawn	and_ba_0,and_ba_0,5,1

	p_trigger	andbox_ckebyte2,always

	p_shadow	off
	p_trigger	.death,Whendead
	p_trigger	.always,always

	p_export	corex,worldx
	p_export	corez,worldz

	p_invincible	on
	p_invisible	on

.loop	p_ifbossflag	abf_ba_dead,on,.make
	p_goto		.loop



.make	p_spawn	0,300,0,0,0,0,and_z_1,and_box0_partslo,1,1,1
	p_Qspawn	and_zoon,and_box0_zoon,1,1
	p_spawn	0,308,0,0,0,0,last_to,and_last_to,1,1,1
	p_invisible	off
	p_invincible	off
	p_end




.dead	p_trigger	Pcds_chika.exp,always
	P_CIRCLEWINDOW	8
	p_wait	10
	p_trigger	.flash,2
	p_wait	30
	p_nextmap
	p_remove	childno_andorf
	p_remove


.death	p_set		HP,1
	p_collisions	off
	p_force		.dead
	p_return

.always	p_add		roty,2
	p_export	coreroty,roty
	p_return


.flash	LOCAL
	p_randomgoto	.noflash
	P_SCREENFLASH
.noflash	p_return



;------------
	start_path	and_box0_zoon

	p_trigger	.add,always,30

	p_set	rotx,deg180
	p_igoto		Pand_box0_part

.add	p_add	worldy,-10
	p_return

;------------
	start_path	and_box0_partslo
	p_slope	on
;;;;;	p_groundobj	on

;------------
	start_path	and_box0_part
	p_invincible	on
	p_collisions	off
	p_shadow	off

.loop	p_add		childroty,-2
	p_goto	.loop

;------------




;-------------------------------------------------------------------------------------------
	start_path	and_last_to

	p_shadow	off
	p_collisions	off
	p_slope	on

.loop	p_setanim	0
	p_add		childroty,-2
	p_goto		.loop

;-------------------------------------------------------------------------------------------
	start_path	and_ba_0

	p_slope	on
	p_collisions	off

	p_zero	worldy

	p_invincible	on

	p_do	4
	p_spawn		0,-20<<and_zoon_scale,0,0,0,0,and_ba_1,and_ba_1,20,0,1
	p_export	gbyte1,pbyte1
	p_become
	p_import	ap,gbyte1
	p_unbecome
	p_inc		pbyte1
	p_inext

.loop	p_ifsame	hp,1,.dodown
	p_goto		.loop


.dodown
	P_SOUNDEFFECT	ob_core_up_down
	P_SOUNDEFFECT	bs_core_cover_down

	p_slope	off
	p_set	clip,plane_GROUND
	p_set	vy,20
	p_setbossflag	abf_ba_dead,on
	p_wait	15

	P_SOUNDEFFECT	leveltrig_stop
	P_SOUNDEFFECT	stop_tr2

	p_remove

;-------------------------------------------------------------------------------------------
	start_path	and_ba_1

	p_trigger	andbox_ckebyte2,always

	p_index		childx,Dand_ba_1.cx,ap
	p_index		childz,Dand_ba_1.cz,ap
	p_index		childroty,Dand_ba_1.cry,ap
	p_set		ap,1
	p_setanim	0

	p_trigger	.whendead,whendead

	p_wait		30

	p_trigger	.fire,16

	p_end

.end	p_Qspawn		explosion2,cds_explode,1,4
	P_SOUNDEFTDISTPOS	en_explode_demo
	p_circlewindow	2
	p_trigger		.whendead,off
	p_trigger		.fire,off

	p_end


.whendead
	p_trigger	andbox_ckebyte2,off

	p_becomemother
	p_dec	hp
	p_unbecome

	p_push	ptr
	P_GOSUB		fire_cansel
	p_pull	ptr

	p_set	hp,1
	p_collisions	off
	p_setanim	1
	p_force		.end
	p_set	clip,plane_GROUND
	p_return

.fire	p_playerincone	90,.dofire
	p_return
.dofire	P_SPAWN		0,-7<<kaku_4_scale,14<<kaku_4_scale,0,0,0,ring_mark,e_kaku_fire,100,1,9
	p_return






andbox_ckebyte2

	p_push	pbyte1
	p_collisions	off
	p_import	pbyte1,ebyte2
	p_ifnotsame	pbyte1,255,.ret
	p_collisions	on
	p_trigger	andbox_ckebyte2,off
.ret	p_pull	pbyte1
	p_return




	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;-------------------------------------------------------------------------------------------
	start_path	deathofand_box
	p_setdemo	andboxdead_cut1
	p_shadow	off
	P_START65816
	ldy		playpt1
	ct_set_chartptr	y,andboxdead
	P_END65816
	p_demoshape
	p_qspawn	nullshape,deathofand_box_cam_stand,1,1
	p_trigger	.always,always
	p_wait		43
	P_SOUNDEFFECT	bs_BOssexplode
	p_end
.always	p_gosub		.andboxexplode
	p_add		roty,5
	p_return
.andboxexplode
	p_andframegoto	3,.abe0
	p_return
.abe0	p_andframegoto	4,.circle
	p_qspawn	explosion5,e_explode_circle127,1,1
	p_return
.circle	p_qspawn	explosion5,e_explode_127,1,1
	p_return
;---------------------------------------------------------------------------------------
	start_path	deathofand_box_cam_stand
	p_collisions	off
	p_faceplayer	immediate
	p_spawn		0,0,500,0,0,0,nullshape,deathofand_box_cam,1,1,1
.loop	p_add		roty,2
	p_goto		.loop
	p_end
;---------------------------------------------------------------------------------------
	start_path	deathofand_box_cam
	p_collisions	off
	p_trigger	.view,always
	p_do		20
	p_next
	p_end
.view	p_copypos2view		1
	p_campandemoshape	1,0,immediate
	p_return
;---------------------------------------------------------------------------------------
	START_PATH	e_explode_circle127
	p_gosub		pe_explode_127.pos
	p_igoto		pe_explode_127.enter
	START_PATH	e_explode_127
	p_gosub	.pos
.enter	LOCAL
	P_SETCOLANIM	0
	P_WAIT		1
	P_DO		7
	P_ADDCOLANIM	1,8
	P_NEXT
	P_REMOVE
.pos	LOCAL
	P_COLLISIONS	OFF
	p_sprite	0,32
	p_setrandom	pword1,255
	p_add		worldx,pword1
	p_add		worldx,-127
	p_setrandom	pword1,255
	p_add		worldy,pword1
	p_add		worldy,-127
	p_setrandom	pword1,255
	p_add		worldz,pword1
	p_add		worldz,-127
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;�                                  �
;�     PATH for PLAYER'S EFFECT     �
;�                                  �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

;--------------------------------------------------------------------------------------
	start_path	overheat

;	[al_vel : set from player]

	p_sprite	0,0

	p_addrandom	worldx,15
	p_addrandom	worldy,15
	p_addrandom	worldz,15

	p_do		8
	p_accel		0,5
	p_addcolanim	1,8
	p_inc		pbyte1
	p_ifsame	pbyte1,7,.remove
	p_add		vy,-1
	p_next

.remove	p_remove

;--------------------------------------------------------------------------------------
	start_path	playershield

	p_collisions	off
	p_shadow	off

	p_copyplayerpos

	p_setanim	0

	p_set		pbyte1,1
	p_set		pbyte2,0

	p_import	tx,shieldinit
	p_ifnotzero	tx,.trig

	P_SOUNDEFFECT	shield_item

	p_do		9
	p_addanim	1,10
	p_next

.trig	p_trigger	.always,always

.loop	p_gset		b,shieldinit,0

	p_setanim	9
	p_ifnotsame	pbyte1,0,.cnt
	p_remove
.cnt	p_goto		.loop



.always	P_START65816

	jsl	playershield00_path_l

	lda	al_pbyte1,x
	bit	#~1
	beq	.flash

.noflash	P_END65816
	p_return



.flash	P_END65816
	p_index	animframe,playershield.tab,pbyte2
	p_inc	pbyte2
	p_return





;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;--------------------------------------------------------------------------------------
	start_path	missileboost

	p_sprite	0,16

	P_ADD		tx,hp
	P_SET		hp,100
	p_trigger	.hit,Whendead

	P_START65816
	s_set_alsflag	x,dontexplode
	P_END65816

	p_collisions	off

.loop	p_addcolanim	1,2
	p_goto		.loop



.remove	p_remove
.hit	p_force		.remove
	p_return

;--------------------------------------------------------------------------------------

;--------------------------------------------------------------------

;------------

	start_path	boost
	p_trigger	pdemoboost.ck,always

;------------

	start_path	demoboost_active
	start_path	demoboost

	p_active	on

	p_sprite	0,0

	p_collisions	off

	p_do		4
	p_addcolanim	1,4
	p_add		tx,4
	p_next

.skip	p_sprite	0,0

.loop	p_zero		pbyte1
	p_addcolanim	1,2
	p_goto		.loop



.ck	LOCAL
	P_START65816
	ldy	playpt1
	s_jmpnot_alsflag	y,insidecockpit,.ncp
	lda	#1
	sta	al_pbyte1,x
.ncp	P_END65816

	p_ifnotzero	pbyte1,.off
	p_ifplayerboost	.cnt
.off	p_force		.remove
.cnt	p_return

.remove	p_remove

;--------------------------------------------------------------------------------------
	start_path	brake

	p_sprite	0,-1

	p_collisions	off

	p_do		4
	p_addcolanim	1,4
	p_add		tx,2
	p_next

	p_sprite	0,0

.loop	p_addcolanim	1,2
	p_ifplayerbrake	.cnt
	p_remove

.cnt	p_goto		.loop

;--------------------------------------------------------------------------------------

 	start_path	healeffect
 
 	p_collisions	off
 
 	P_SOUNDEFFECT	CatchHeart
 
 	P_CIRCLEWINDOW	-8
 
 	P_START65816
	jsl	healeffect00_path_l
	P_END65816

	p_do		8
	P_START65816
	jsl	healeffect01_path_l
	P_END65816

	P_CIRCLEWINDOWPOS

	p_next

	p_remove


;--------------------------------------------------------------------------------------

	start_path	heal

healwait	equ	20-15
healint	equ	5
healtime0	equ	25-20
healtime1	equ	20	;100
healtime2	equ	10	;20
healtime3	equ	10
healposx	equ	40

	P_SOUNDEFFECT	heal_parts


	p_spawn		5,-100,-200,0,0,0,pow_l,heal_l,1,1,childno_healparts_l
	p_spawn		-5,-100,-200,0,0,0,pow_r,heal_r,1,1,childno_healparts_r

	p_do	healwait+healtime1+healtime2+10
	p_zero	rotz
	p_zero	rotx
	p_next

.remove	p_remove







	start_path	heal_l
	p_set		count,3
	p_set		pword1,healposx

	p_igoto		pheal_r.enter

	start_path	heal_r
	p_set		count,8
	p_set		pword1,-healposx

.enter	LOCAL

	p_trigger	.always,always,healwait+healtime1+healtime2

	p_clrtype	ENEMY1
	p_collisions	off

	p_do		healwait
	P_START65816
	jsl	heal_path00_l
	P_END65816
	p_next

	p_trigger	.pos0,always,healtime0+healtime1

	p_wait		healtime0

	p_setvar	b,player1_hpadd,40
	p_wait		healtime1>>1
	p_setvar	b,player1_hpadd,40
	p_wait		healtime1>>1
	p_setvar	b,player1_hpadd,40


	p_do		healtime2
	p_set		depthoffset,3
	p_andframegoto	1,.d3
	p_set		depthoffset,1
.d3	p_next

	p_set		depthoffset,3


.waitdeth	p_do		count
	p_next


	p_import	pbyte2,planet_mode
	p_ifnotsame	pbyte2,pm_marine,.g
	p_import	pword1,seadepth
	p_ifsmaller	worldy,pword1,.g

.m	; marine

	p_set		pbyte1,childx

	p_relative	off

	p_zero		childx
	p_zero		childy
	p_zero		childz

	p_do		healtime3
	p_chase		rotz,pbyte1
	p_add		worldy,-4
	p_next
	p_igoto		.kill


.g	; ground & space

	p_setrandom	pbyte1,31
	p_add		pbyte1,-16

	p_do		healtime3

	P_START65816
	jsl	heal_path02_l
	P_END65816

;	p_add		childrotx,-8
;	p_add		childy,10
;	p_add		childz,-10
;	p_add		childrotz,pbyte1
;	p_add		childroty,pbyte1

	p_hitslope	.kill
	p_next

.kill	p_set		HP,0
	p_end


.pos0
	P_START65816
	jsl	heal_path01_l
	P_END65816

;	p_chase		childx,pword1
;	p_chase		childz,0
;	p_chase		childz,0
;	p_chase		childy,0


	p_return


.always	p_push		pbyte1
	p_import	pbyte1,demomode
	p_ifzero	pbyte1,.alive
	p_force		.remove

.alive	p_pull		pbyte1
	p_return

.remove	p_remove

;--------------------------------------------------------------------------------------

	start_path	bomeffect
 
 	p_collisions	off
 
	p_spawn	0,-10,0,-25,0,0,bomb,bomeffect_child,1,1,1
	p_import	immuneptr,playpt1


	p_trigger	.always,always


	p_do	bombtimer
	p_import	ap,bombexplode	; explode trigger
	p_ifnotzero	ap,.waitdeath
	p_next
	p_igoto		.end

.waitdeath	p_break

.end	p_wait	20

	p_remove



.always	p_copyplayerpos
	p_faceplayerofs	0,0,127
	p_div2	rotx
	p_zero	rotz

	p_return






	start_path	bomeffect_child

	p_import	immuneptr,playpt1

	P_SOUNDEFFECT	bomshoot

	p_invincible	on
	p_sprite	0,0

	p_setvel	25
	p_alwaysgenvecs	on

	p_trigger	.always,always
	p_trigger	.whenhit,whenhit

.loop	p_import	ap,bombexplode	; explode trigger
	p_ifnotzero	ap,.explode
	p_ifareaout	.explode
	P_HITSLOPE	.explode
	p_goto		.loop

.whenhit	p_force	.explode
	p_return


.explode	p_trigger	.whenhit,off
	p_setvar	b,bombexplode,1

	p_shockcam	1,128


	P_START65816
	jsl	BOMBcircle_path_srou_l
	P_END65816

	P_SOUNDEFFECT	bomexplode

	p_setvel	0

	p_set	shape,nullshape

.pos	p_circlewindowpos
	p_goto	.pos
	p_end


.always	p_add	childrotx,4
	p_add	childy,vy
	p_return

;--------------------------------------------------------------------------------------
	start_path	damagespark

	p_sprite	0,-4

	p_gosub	prou_addrandom_cxyz31

.loop	p_addcolanim	1,3
	p_inc		pbyte1
	p_ifnotsame	pbyte1,3,.cnt
	p_remove

.cnt	p_goto		.loop


;--------------------------------------------------------------------------------------

	start_path	wingspark
	p_sprite	0,0
	p_do		3
	p_addcolanim	1,2
	p_next
	p_remove

;--------------------------------------------------------------------------------------
;	start_path	armerjet
;
;	p_sprite	0,-1
;
;.loop	p_addcolanim	1,2
;	p_dec		count
;	p_ifsame	count,0,.remove
;	p_goto		.loop
;
;.remove	p_remove
;
;--------------------------------------------------------------------------------------
	start_path	burnning

	p_sprite	0,-6

	p_set		pbyte1,0

.loop	p_addcolanim	1,2
	p_inc		pbyte1

	p_ifnotsame	pbyte1,2,.cnt

	p_ifplayerboost	.nomake

;	p_spawn		0,0,0,0,0,0,flame,burnning_child,1,1,1

	p_goto		.unlink
.unlink

	p_addcolanim	1,2
	p_unlinkchild	1

.nomake	p_remove

.cnt	p_goto		.loop
	p_end




;	start_path	burnning_child
;
;	p_active	on
;
;	p_clrtype	ENEMY1
;	p_collisions	off
;
;	p_sprite	0,-7
;	p_set		pbyte1,0
;	p_reltoplayer	on
;
;.loop	p_addcolanim	1,2
;	p_inc		pbyte1
;	p_ifnotsame	pbyte1,2,.cnt
;	p_remove
;	p_end
;
;.cnt	p_goto		.loop
;	p_end

;--------------------------------------------------------------------------------------

;	start_path	armerarm
;
;.loop	p_addcolanim	1,2
;
;	p_ifufo	.ufo
;	p_igoto	.remove
;
;.ufo	p_ifnotsame	pbyte1,0ffH,.cnt
;
;.remove	p_remove
;	p_end
;
;.cnt	p_goto		.loop

;--------------------------------------------------------------------------------------
;	start_path	pushobj
;
;	p_set		hp,100
;	p_set		ap,1
;
;	p_invincible	on
;
;	p_collisions	on
;	p_settype	object
;	p_end
;
;
;--------------------------------------------------------------------------------------
	start_path	p_explode_s_rnd31
	p_collisions	off

	p_set		pbyte1,0
	p_do		count
	p_ifnotsame	pbyte1,0,.nospawn
	p_spawn		0,0,0,0,0,0,explosion,p_explode_s_rnd,1,1,1
	p_set		pbyte1,5
.nospawn	p_dec		pbyte1
	p_next
	p_remove


	start_path	p_explode_s_rnd

	p_gosub	prou_addrandom_cxyz31

;	p_addrandom	childx,31
;	p_addrandom	childy,31
;	p_addrandom	childz,31


	start_path	p_explode_s
	p_soundeffect	pl_explode_s
	p_collisions	off
	p_sprite	0,-2
	P_SETCOLANIM	0
	P_WAIT		1
	P_DO		3
	P_ADDCOLANIM	1,4
	P_NEXT
	p_remove


	start_path	p_explode_l
	p_collisions	off
	p_sprite	0,10

	P_SETCOLANIM	0
	P_WAIT		1
	P_DO		7
	P_ADDCOLANIM	1,8
	P_NEXT
	p_remove

;-----------------------------------------------------------------------------
; GUNBLAZE

	start_path	gunblaze
	p_sprite	0,16
.enter	LOCAL
	p_collisions	off

	p_do		3
	p_addcolanim	1,2
	p_next
	p_remove

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	YOU WIN!
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;-------------------------------------------------
; Game over text uses NintendoPresents engine

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	START_PATH	TOBECONTINUED
	P_SET		pbyte2,tobecontinuedmsg-nintendomsg
	p_igoto		.enter
;-------------------------------------------------
; Game over text uses NintendoPresents engine
.enter	LOCAL
	P_COLLISIONS	OFF
	P_RELTOPLAYER	ON
	P_CLRBOSSFLAGS
	P_SET		worldx,-400
	P_QSPAWN	clipshape,font_clip2,10,10
	P_DO		2
	P_SET		worldx,-400
	P_GOSUB		moji_throwchars
	P_WAIT		10
	P_SET		worldx,-400
	P_ADD		worldy,200
	P_INEXT
	P_END

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC



;	P_WAIT		60
;
;	P_SETBOSSFLAG	burstout,ON
;
;	P_WAIT		100
;
;	P_ADD		worldy,-200
;	P_ADD		worldz,-200
;
;	P_SETBOSSFLAG	burstout,OFF
;
;	P_REMOVE


;-------------------------------------------------
; Game over text uses NintendoPresents engine

chrsizex	equ	120



	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	START_PATH	YOUWIN
	P_COLLISIONS	OFF

	p_trigger	.always,always

	p_spawn	-chrsizex*3,0,-100,0,0,0,chr_y,youwin_chr,1,0,childno_youwin
	p_gosub	setinside
	p_spawn	-chrsizex*2,0,-100,0,0,0,chr_o,youwin_chr,1,2,childno_youwin
	p_gosub	setinside
	p_spawn	-chrsizex*1,0,-100,0,0,0,chr_u,youwin_chr,1,4,childno_youwin
	p_gosub	setinside

	p_spawn	chrsizex*1,0,-100,0,0,0,chr_w,youwin_chr,1,6,childno_youwin
	p_gosub	setinside
	p_spawn	chrsizex*2,0,-100,0,0,0,chr_o,youwin_chr,1,8,childno_youwin
	p_gosub	setinside
	p_spawn	chrsizex*3,0,-100,0,0,0,chr_n,youwin_chr,1,10,childno_youwin
	p_gosub	setinside

	p_end

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC




;.always	LOCAL
;
;	P_COLLISIONS	OFF
;
;	p_copyviewpos
;
;	p_set	rotz,0
;
;	P_START65816
;	ldy	pathplayer&WM
;	pl_ldy_viewblk	y
;	lda.w	al_rotx+1,y
;	nega
;	sta	al_rotx,x
;	lda.w	al_roty+1,y
;	nega
;	sta	al_roty,x
;	P_END65816
;
;	p_return

;-------------------------------------------------
; Game over text uses NintendoPresents engine

;chrsizex	equ	120



	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	START_PATH	YOULOST

	P_COLLISIONS	OFF

	p_trigger	Pyouwin.always,always

	p_spawn	-chrsizex*4+60,0,-100,0,0,0,chr_y,youwin_chr,1,0,childno_youwin
	p_gosub	setinside
	p_spawn	-chrsizex*3+60,0,-100,0,0,0,chr_o,youwin_chr,1,2,childno_youwin
	p_gosub	setinside
	p_spawn	-chrsizex*2+60,0,-100,0,0,0,chr_u,youwin_chr,1,4,childno_youwin
	p_gosub	setinside

	p_spawn	chrsizex*0+60,0,-100,0,0,0,chr_l,youwin_chr,1,6,childno_youwin
	p_gosub	setinside
	p_spawn	chrsizex*1+60,0,-100,0,0,0,chr_o,youwin_chr,1,8,childno_youwin
	p_gosub	setinside
	p_spawn	chrsizex*2+60,0,-100,0,0,0,chr_s,youwin_chr,1,10,childno_youwin
	p_gosub	setinside
	p_spawn	chrsizex*3+60,0,-100,0,0,0,chr_t,youwin_chr,1,12,childno_youwin
	p_gosub	setinside

	p_end

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;-------------------------------------------------
;setinside
;	p_become
;	P_START65816
;	s_set_alsflag	x,insidecockpit
;	ldy	pathplayer&WM
;	s_jmpnot_alsflag	y,player2,.p1
;.p2	s_clr_alsflag	x,player2
;	s_set_coltab		x,#id_1_c&WM
;	bra		.end
;.p1	s_set_alsflag	x,player2
;.end	P_END65816
;	p_unbecome
;	p_return
;
;-------------------------------------------------

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	youwin_chr
	p_collisions	off
	p_shadow	off
	p_set	count,ap
	p_wait	count
	p_do	16
	p_add	childz,800/16
	p_add	childrotx,256/16
	p_add	childrotz,256/16
	p_next
	p_end
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC





;-------------------------------------------------
;----------------------------------------------------------------------------------
	SHORTA
	LONGI

;	pbyte1	: body No.
;	pword1	: timer
;	tx	: hit counter
;	ty	: anim frame
;	skidy	: HP buffer
;	pbyte2	: aki

;mode list

	P_BOSSMODELIST	superdragon
	P_BOSSMODE	sd_swim,sdm_swim
	P_BOSSMODE	sd_beam,sdm_beam
	P_BOSSMODE	sd_beam2,sdm_beam2

	P_BOSSMODE	preturn

	P_BOSSFLAGLIST
	P_BOSSFLAG	sdf_demo
	P_BOSSFLAG	sdf_coloff
	P_BOSSFLAG	sdf_toguro
	P_BOSSFLAG	sdf_bottom
	P_BOSSFLAG	sdf_attack
;WWW	P_BOSSFLAG	sdf_flash
;	P_BOSSFLAG	sdf_invincible
	P_BOSSFLAG	sdf_kireta
	P_BOSSFLAG	sdf_dead
	P_BOSSFLAG	sdf_ground
	P_BOSSFLAG	sdf_warp
	P_BOSSFLAG	sdf_firstattack
	P_BOSSFLAG	sdf_HP0

	start_path	superdragon


sd_fire_int	equ	20	; beam no hassya kankaku
sd_fire_wait	equ	4	; hassya no wait

childno_dragon_body	equ	80

	p_zero		pbyte2

	p_set		ap,4

	p_import	pbyte1,Kdifficulty
	p_index		hp,superdragon.hp,pbyte1
	p_set	skidy,hp	; set buffer

	P_IMPORT	roty,Kinitroty

	p_enemydmgse	bs_cry_1

	p_import	worldy,Ehight

	p_quadvecs	on

;------------
	p_set	tx,0	: hit counter
	p_set	ty,128	: anim frame
;------------

	p_trigger	.whenhitbyplayer,whenhitbyplayer
	p_trigger	.whendead,whendead

	p_radarobj	ra_enemy	; display radar

	p_clrbossflags
	p_set		pword1,0
	p_export	bossflags,pword1

	p_settype	ENEMY2

	p_gosub	prou_dragon

	p_alwaysgenvecs	on

	p_setbossflag	sdf_demo,on

	p_setvel	48>>2

	p_collisions	off

;-----------------------------------------------------------------------
; set HP METER

	p_do		42h-30-10h
	p_gosub		sd_swim
	p_next

	p_setbossname	name_mirage
	p_zero		pbyte2

	p_do		30
	p_ifsame	pbyte2,hp,.next
	p_inc		pbyte2
	p_export	bossmaxhp,pbyte2
	p_export	bosshp,pbyte2
.next	p_gosub		sd_swim
	p_next

	p_collisions	on

	p_zero		pbyte2


;-----------------------------------------------------------------------

.mid
	p_gosub		sd_swim
;	p_export	bosshp,hp
	P_FACEPLAYER	y
	P_MOVEINPLAYER	100
	P_DISTLESS	3000,.demooff

	p_gosub	.hp

	P_GOTO		.mid


.demooff

	p_do	10h

	p_gosub		sd_swim
;	p_export	bosshp,hp
	P_FACEPLAYER	y

;	p_export	bosshp,hp
;	p_gosub		superdragon_faceplayer
;	p_gosub		sd_beam.face

	p_gosub	.hp
	p_next


	p_setbossflag	sdf_demo,off

	p_zero		pword1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

; main loop

	P_SOUNDEFFECT	bs_cry_2

	p_setbossmode	sdm_beam	; init mode

.loop0

;-----------------------------------------------------------------------
;	p_setbossflag	sdf_invincible,OFF
;WWW	p_setbossflag	sdf_flash,OFF
	p_setbossflag	sdf_toguro,OFF
	p_invincible	off
;-----------------------------------------------------------------------

	p_gosub		.sd_setbossmode

	p_setmarker	1

	p_inc		pword1
	
;-----------------------------------------------------------------------

	p_ifzero	ty,.addanim
	p_ifsame	animframe,ty,.noanim

.addanim	p_addanim	1,16

.noanim

;-----------------------------------------------------------------------
;	P_START65816
;	jsl	superdragon01_path_l
;	P_END65816
;	p_export	bosshp,hp

	p_gosub		.hp

	p_goto		.loop0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	p_end


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;-----------------------------------------------------------------------
.hp

	P_START65816
	jsl	superdragon01_path_l
	P_END65816
	p_export	bosshp,hp

	p_return

;-----------------------------------------------------------------------

.sd_setbossmode

	p_jumpbossmode


	p_return



;************
.whenhitbyplayer
;------------
; beam wo utsu toki wa nanimo sinai.

	p_ifbossflag	sdf_toguro,ON,.wh0

;------------
	p_setbossmode	sdm_swim

	p_set		depthoffset,0
;WWW	p_setbossflag	sdf_flash,OFF
;	p_setbossflag	sdf_invincible,OFF

	p_add		rotx,-8

	p_playerincone	60,.yoko

	p_gosub		superdragon_faceplayer

	p_setvel	120
	p_igoto		.whry


.yoko	p_gosub		superdragon_faceplayer
	p_setvel	70

	P_START65816
	jsl	superdragon02_path_l
	P_END65816

.whry
.wh0
	p_return

;************

.whendead

;	P_START65816
;	jsl	superdragon01_path_l
;	P_END65816
;	p_ifzero	hp,.wd0
;	p_force		.loop0
;	p_return

.wd0
	p_set	hp,1
	p_collisions	off
	p_force	.dead
	p_return

;************
.dead
	p_trigger	.whendead,off

	p_setbossflag	sdf_HP0,ON

	p_Qspawn	explosion3,cds_explode,1,32

	P_SOUNDEFTPOS	bs_monster_down

	p_set	depthoffset,4

	p_alwaysgenvecs	off

	P_GDEC		b,KEnemyNumber

	P_SCORE		500

	p_trigger	.bom,4,60
	p_trigger	Pcds_piece.exp,4
	p_trigger	.deaddist,always

	p_copyplayerrots
	p_set	rotx,deg90
	p_set	rotz,0

	p_do	8
	p_add	roty,8
	p_import	vx,player1_vx
	p_set		vy,-20
	p_import	vz,player1_vz

	P_START65816

	jsl	superdragon03_path_l

	P_END65816

;	p_add	vx,vx
;	p_add	vz,vz
;	p_add	vx,vx
;	p_add	vz,vz
;	p_add	vx,vx
;	p_add	vz,vz

	p_next

	p_wait	40

	p_trigger	.deaddist,off
	p_trigger	.deaddist2,always

	p_wait	14

	p_setbossflag	sdf_dead,ON

	P_SOUNDEFTPOS	bs_BOSSexplode2

	p_trigger	.deaddist2,off
	p_trigger	.dvz,always

	p_faceview	immediate

	p_setvel	40

;	p_wait	35
;	p_explode

	p_end


.deaddist	p_distless	8000,.dvz
.deaddist2	p_set	vx,0
	p_set	vy,0
	p_set	vz,0
.dvz
	p_add	rotx,30
	p_clrdemoshape


	p_import	tx,bossmaxhp
	p_ifzero	tx,.nom
	p_dec		tx
	p_export	bossmaxhp,tx
.nom
	p_return



.bom	P_SOUNDEFTDISTPOS	en_explode_s
	p_return

;----------------------------------------------------------------------------------------------------
;sd_tobikomi	; mode
;
;	p_gosub	superdragon_faceplayer
;
;	p_setvel	60
;	p_distless	2000,.2tobikomi
;	p_igoto		sd_beam.face
;
;
;.2tobikomi	p_setbossmode	sdm_tobikomi2
;	p_zero		pword1
;	p_accel		5,20
;sd_tobikomi2	p_ifsame	pword1,16,.toswim
;	p_add		roty,32
;	p_return
;
;
;.toswim	p_setbossmode	sdm_swim
;	p_zero		pword1
;	p_gosub		superdragon_faceplayer
;	p_return
;
;----------------------------------------------------------------------------------------------------
sd_beam	; mode

;	p_setbossflag	sdf_invincible,ON
;WWW	p_setbossflag	sdf_flash,ON
	p_setbossflag	sdf_toguro,ON

	p_set		ty,128	; anim

	p_gosub	superdragon_faceplayer_fire

	p_setvel	0


	p_ifsame	pword1,sd_fire_wait,.fire
	p_igoto		.face


.fire	p_ifbossflag	sdf_firstattack,off,.beam

	p_randomgoto	.beam
	p_randomgoto	.beam

	p_distless	2000,.fired
	p_trigger	.magma,4,32
	p_igoto		.fired


.beam	p_setbossflag	sdf_firstattack,on

	P_SOUNDEFFECT	bs_dragon_laser2

	p_set	rotx,childrotx
	p_set	roty,childroty

	p_Qspawn	nullshape,superdragon_beam,30,6
	p_spawn		0,0,60,deg270,0,0,clipshape,superdragon_clip,1,1,1


.fired	p_set		pbyte2,1
	p_set		depthoffset,0
	p_setbossmode	sdm_beam2

; set rotation dir

	p_set		tx,1
	p_ifsame	tx,-20,.ymi
	p_add		tx,-2
.ymi

	p_set		pword1,0


.face	LOCAL

	p_chase	rotx,childrotx
	p_chase	roty,childroty
	p_chase	rotz,childrotz

	p_return


.magma	p_andframegoto	15,.ryousan
	p_Qspawn	magmaball,superdragon_magma,1,4
	p_return


.ryousan	p_Qspawn	nullshape,superdragon_garakuta,1,4
	p_return



sd_beam2
;	p_setbossflag	sdf_invincible,ON

	p_set		ty,128+8	; anim

	p_setbossflag	sdf_toguro,ON

	p_gosub		sd_beam.face

	p_inc	pbyte2

	p_ifnotsame	pword1,20,.ret

.toswim	LOCAL

	p_setbossmode	sdm_swim
	p_set		pword1,0

.ret	p_return


;----------------------------------------------------------------------------------------------------
;sd_escape	; mode
;
;	p_accel		120,5
;
;	p_ifnotsame	pword1,120,sd_swim.notzero
;
;	p_setbossmode	sdm_swim
;	p_set		pword1,0
;	p_accel		40>>2,5
;
;	p_return
;
;----------------------------------------------------------------------------------------------------
sd_swim	; mode

	P_START65816
	jsl	sd_swim00_path_l
	P_END65816

	p_zero	childrotx

	p_accel	40>>2,5

	p_set	ty,0	; anim

	p_gosub	superdragon_swim

	p_ifbossflag	sdf_demo,ON,.noface

	p_distmore	6000,.face

	p_distless	4000,.Bnear
	p_playerincone	40,.beam
.Bnear	p_playerincone	5,.beam


	p_playerincone	50,.notfast
	p_accel		80,5
.notfast
	p_ifnotsame	pword1,80,.noface
	p_zero		pword1
.face	p_gosub		superdragon_faceplayer
.noface	p_return


.beam
	p_accel		40>>2,5

	p_distless	1000,.nobeam
	P_PUSH	CHILDY
	p_set	childy,sd_fire_int
	p_ifsmaller	pword1,childy,.canbeam
	p_setbossmode	sdm_beam

	P_SOUNDEFFECT	bs_cry_2

	p_zero		pword1

; fire rotation

	p_set	tx,20
	p_randomgoto	.canbeam
	p_set	tx,-20

.canbeam	P_PULL	CHILDY

.nobeam	p_return


;----------------------------------------------------------------------------------------------------

; pbyte2: offset Z pos

;***************
	start_path	superdragon_body1s

	p_gosub		superdragon_makebodys
	p_igoto		Psuperdragon_body.enter

;***************
	start_path	superdragon_body1

	p_gosub		superdragon_makebody
	p_igoto		Psuperdragon_body.enter

;***************

	start_path	superdragon_bodys

	p_gosub		superdragon_makebodys

	p_ifnotsame	pbyte1,9,Psuperdragon_body.enter
	p_set		shape,dragon_2s

	p_igoto		Psuperdragon_body.enter

;***************

	start_path	superdragon_body

	p_gosub		superdragon_makebody

	p_ifnotsame	pbyte1,9,.enter
	p_set		shape,dragon_2

.enter	LOCAL

	p_ifbossflag	sdf_coloff,OFF,.colon
	p_collisions	off
.colon

	p_enemydmgse	bs_cry_1

	p_chainpos	childz

	P_INVISIBLE	ON
	P_WAIT		1
	P_INVISIBLE	OFF

	p_index		hp,superdragon_body.hpdat,pbyte1

	p_radarobj	ra_enemy

	p_clrtype	ENEMY1
	p_settype	ENEMY2


	p_trigger	.whendead,whendead

	p_ifbossflag	sdf_ground,OFF,.nogd
	p_groundobj	on
.nogd

.loop0
	p_ifbossflag	sdf_dead,ON,.motherdead

	P_SWAPVAR	ptr,immuneptr

	p_chainpos	childz

	p_ifbossflag	sdf_HP0,OFF,.nodp
	p_set	depthoffset,3
.nodp
;------------
	p_gosub		.bottom
	p_gosub		.toguro
;------------

	p_ifbossflag	sdf_warp,OFF,.nowarp
	p_set	rotx,0
.nowarp
;------------
	P_SWAPVAR	ptr,immuneptr

	p_goto		.loop0




;------------ Mother id dead

.motherdead	LOCAL

; copy depth

	p_set	depthoffset,4

	p_trigger	.whendead,off

	p_faceshape	immediate

	p_quadvecs	on
	p_setvel	-40

	p_set		hp,1

	p_set		count,pbyte1
	p_neg		count
	p_add		count,20

	p_setrandom	rotx
	p_setrandom	roty
	p_setrandom	rotz

	p_do	count
	p_add	worldx,vx
	p_add	worldy,vy
	p_add	worldz,vz
	p_add	rotx,32
	p_add	roty,16
	p_add	rotz,8
	p_next

	p_Qspawn	explosion3,cds_explode,1,32

	p_remove




.whendead	p_set	hp,10
	p_collisions	off
	p_return


;************

.bottom	LOCAL

	p_ifbossflag	sdf_bottom,OFF,.nobottom

	p_chase		rotx,-60
	p_chase		rotx,-60
	p_chase		rotx,-60

.nobottom	p_return

;************

.toguro	LOCAL

	p_ifbossflag	sdf_toguro,OFF,.nobottom

	p_index		childrotx,superdragon_body.toguro_dat,pbyte1

	p_chase		rotx,childrotx
	p_chase		rotx,childrotx
	p_chase		rotx,childrotx

	p_add		roty,10

.notoguro	p_return

;************
;
;.top	LOCAL
;	p_ifbossflag	sdf_top,OFF,.notop
;
;	p_chase		rotx,60
;
;	p_chase		childrotx,60
;
;	P_START65816
;	s_achase_alvar2alvar	B,x,al_rotx,x,al_childrotx,1
;	P_END65816
;
;.notop	p_return
;
;************
;
;superdragon_flash
;
;	p_ifzero	depthoffset,.5
;	p_dec	depthoffset
;	p_ifnotzero	depthoffset,.dp
;.5	p_set	depthoffset,5
;
;.dp	p_return
;
;************

superdragon_faceplayer_fire

	p_push	rotx
	p_push	roty
	p_faceplayer	immediate
	p_igoto	superdragon_faceplayer.enter

superdragon_faceplayer

	p_push	rotx
	p_push	roty
	p_faceplayer	immediate
	p_div2	rotx
.enter	LOCAL
	p_set	childrotx,rotx
	p_set	childroty,roty
	p_pull	roty
	p_pull	rotx

	p_chase	rotx,childrotx
	p_chase	roty,childroty

	p_return

;************

superdragon_swim

	P_PUSH	CHILDROTX
	p_andframegoto	8,.xmi
.xpl	p_add	childrotx,20
	p_igoto	.x
.xmi	p_add	childrotx,-20
.x	p_chase	rotx,childrotx
	P_PULL	CHILDROTX

; player no mae

	p_playerincone	80,.yoko
	p_chase	roty,childroty
	p_return

.yoko	P_PUSH	CHILDROTY
	p_andframegoto	16,.ymi
.ypl	p_add	childroty,20
	p_igoto	.y
.ymi	p_add	childroty,-20
.y	p_chase	roty,childroty
	P_PULL	CHILDROTY

	p_return

;************

superdragon_makebodys

	p_gosub		superdragon_makebody.get

	p_ifnotsame	pbyte1,9,.body
	p_return

.body	p_spawn		0,0,-(100>>2),0,0,0,dragon_1s,superdragon_bodys,1,1,childno_dragon_body
	p_ifnotsame	pbyte1,9,superdragon_makebody.mkend
	p_igoto		superdragon_makebody.mkend

superdragon_makebody

	p_gosub		.get
	p_ifnotsame	pbyte1,9,.body
	p_return

.body	p_spawn		0,0,-100,0,0,0,dragon_1,superdragon_body,1,1,childno_dragon_body
	p_igoto		.mkend

.mkend	LOCAL

	P_START65816
	s_set_objtobevar	y,becomelastobj&WM
	stx			al_immuneptr,y
	P_END65816
	p_return



.get	LOCAL

	p_push		childz
	p_relative	off
	p_pull		childz

	p_collisions	on
	p_set		hp,2
	p_set		ap,1

	p_becomemother
	p_inc		pbyte1
	p_export	x1,pbyte1
	p_unbecome

	p_import	pbyte1,x1

	p_return

;***************

	start_path	superdragon_garakuta

	p_trigger	.rot,always
	p_setrandom	pbyte1,7
	p_index		shape,superdragon_garakuta,pbyte1

	p_igoto		Psuperdragon_magma.enter

.rot	p_add	rotx,16
	p_add	roty,8
	p_add	rotz,4
	p_return


	start_path	superdragon_magma

	p_sprite	0,0

.enter	LOCAL

	p_clrtype	ENEMY1
	p_settype	ENEMY2

	p_quadvecs	on
	p_addrandom	tx,3
	p_setvel	60
	p_wait		30
	p_set	hp,0

	p_end



;***************

	start_path	superdragon_beam

	p_clrtype	ENEMY1
	p_settype	ENEMY2

	p_invincible	on

	p_quadvecs	on

;;;;	p_groundobj	on

	p_set		clip,plane_BOSS2

	p_wait		1

	p_set	shape,warpl

	p_setvel	127

	p_wait	20

	p_remove


;***************

	start_path	superdragon_clip
	p_collisions	off
	p_groundobj	on

	p_wait	20

	p_remove

;***************
dragon_warp_rou

	p_setbossflag	sdf_warp,ON
	p_return

;***************
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	superdragon_friend
;	p_clrtype	ENEMY1
;	p_settype	ENEMY2
	p_collisions	off
	p_set		hp,100
	p_set		ap,1
	p_weapon	Flaser
.loop0	p_ifbossflag	sdf_toguro,on,.exit
	p_alwaysgenvecs	on
	p_shapedead	.find
	p_igoto		.found
.find	p_findenemyshape	10000,255,.found
.found	p_shapedistless	800,.spd2
.spd1	p_accel		50,3
	p_igoto		.spd
.spd2	p_accel		40,3
.spd	p_faceshape
	p_andframegoto	15,.incone
	p_igoto		.exit
.incone	p_objincone	30,.fire
	p_igoto		.exit
.fire	p_fire
.exit	p_setmarker	1
	p_goto		.loop0
	p_end
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	TITLE DEMO
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
TITLEDEMO
	start_path	titledirector

title_nintendo_time	equ	060h

title_cut1	equ	1
title_cut2	equ	2
title_cut3	equ	3
title_cut4	equ	4
title_cut5	equ	5
title_cut6	equ	6
title_cut7	equ	7
title_cut8	equ	8
title_cut9	equ	9

childno_title	equ	1
childno_title_bwing	equ	2
childno_title_warp0	equ	3
childno_title_watch2	equ	4
childno_title_watch3	equ	5
childno_title_dragon_bwing	equ	6


title_cam_cut3_x	equ	-1000
title_cam_cut3_y	equ	-1000
title_cam_cut3_z	equ	2200

title_cam_cut4_x	equ	0
title_cam_cut4_y	equ	0
title_cam_cut4_z	equ	0

title_cam_cut5_x	equ	0
title_cam_cut5_y	equ	0
title_cam_cut5_z	equ	2000

title_cam_cut6_x	equ	0
title_cam_cut6_y	equ	0
title_cam_cut6_z	equ	0

	p_setvar	w,player1_horizon_offset,SCR4_Hofs

	p_setvar	w,player1hscroll_offset,80h+30h

	p_setvel	10
	p_export	player1_vz,vz

	p_collisions	off

	p_setdemo	title_cut1

	p_gosub	prou_posrot0

	p_copypos2player
	p_copyrot2player

	p_spawn		0,0,300,0,0,0,nullshape,title_watch,1,1,childno_title

	p_Qspawn	nullshape,nintendopresents,1,1
	p_Qspawn	nullshape,title_cam,1,0
;beam

	p_spawn	0,-800,700+300,50,deg180,0,nullshape,title_warps,1,1,childno_title_warp0

	p_wait	title_nintendo_time

	P_SOUNDEFFECT	bs_dragon_laser

	p_spawn		-300+50,-400,-1500,0,0,0,ship_0,title_ship_explode_0,1,1,childno_title
	p_Qspawn	ship_0,title_ship_1,1,5

	p_Qspawn	ryousan,title_bwing,18,0
	p_Qspawn	ryousan,title_bwing,15,1
	p_Qspawn	ryousan,title_bwing,20,2


.cut1	p_ifsamedemo	title_cut2,.cut2
	p_goto		.cut1
.cut2

	p_wait	1

	p_remove	childno_title_warp0

	p_Qspawn	dragon_0s,superdragon_demo,1,16


.cut3	p_ifsamedemo	title_cut4,.cut4
	p_goto		.cut3

.cut4	p_Qspawn	nullshape,title_watch2,1,15
.cut4_0	p_ifsamedemo	title_cut5,.cut5
	p_goto		.cut4_0

.cut5

	p_end


;----------------------------------------------------------------------------------
	start_path	title_watch

	p_collisions	off

	p_demoshape

	p_wait	title_nintendo_time+4

	P_SWAPVAR	pword1,ptr
	p_findshape	ship_0
	p_faceshape	immediate
	p_set		childrotx,rotx
	p_set		childroty,roty
	P_SWAPVAR	pword1,ptr

	p_setvel	50
	p_add		vx,-5

	p_wait		20
	p_setvel	0

.cut1_0	p_ifnotdemo	title_cut1,.cut2
	p_goto		.cut1_0


.cut2
	p_set	childx,-500
	p_set	childy,0
	p_set	childz,300

	p_wait	5

	P_SWAPVAR	pword1,ptr
	p_findshape	dragon_0s
	p_faceshape	immediate
	p_set		childrotx,rotx
	p_set		childroty,roty
	P_SWAPVAR	pword1,ptr
	p_setvel	50

	p_do	30
	p_next

.cut2_0	p_ifnotdemo	title_cut2,.cut3
	p_goto		.cut2_0

.cut3	p_remove

;----------------------------------------------------------------------------------
	start_path	title_watch2

;	p_set	shape,dragon_0

	p_collisions	off

	p_demoshape

	p_gosub	Pes0_cam.pos

;	p_set	worldx,title_cam_cut4_x-50-500
;	p_set	worldy,title_cam_cut4_y-20-200
;	p_set	worldz,title_cam_cut4_z-50+200
;
;	p_set	roty,deg180
;	p_set	rotx,20


	p_spawn	-500,0,-(123<<warpl_scale),0,0,0,warpl,title_dragon_beam2,1,1,childno_title
;	p_spawn	0,0,-123<<warp_scale,0,0,0,warp,title_dragon_beam2,1,1,childno_title
;	p_spawn	0,0,-(100+123)<<warp_scale,0,0,0,warp,title_dragon_beam2,1,1,childno_title

	p_setvel	127


	p_add	vx,vx
	p_add	vy,vy
	p_add	vz,vz


	p_wait	15+2

;	p_do	15
;	p_print	worldx,h,kawagoe
;	p_print	worldy,h,kawagoe
;	p_print	worldz,h,kawagoe
;	p_next

	p_setvel	0

	p_wait	30

	p_remove

;----------------------------------------------------------------------------------
	start_path	title_watch3

	p_collisions	off
	p_demoshape
	p_wait		17

;	p_set	shape,c_wing

	p_set		rotx,20
	p_set		roty,-30
	p_setvel	60
	p_accel		0,5

	p_wait	25+2

	p_set		rotx,0
	p_set		roty,-20
	p_setvel	30

	p_wait		40

	p_setvel	0

	p_end

;----------------------------------------------------------------------------------
	start_path	title_cam

	p_collisions	off

	p_wait		1

	p_trigger	.always,always


.cut1	p_ifsamedemo	title_cut2,.cut2
	p_import	vz,player1_vz
	p_goto		.cut1



.cut2
	P_GOSUB	.pos

.cut2_0	p_ifsamedemo	title_cut3,.cut3
	p_goto		.cut2_0


.cut3
	P_GOSUB	.pos

	p_set		vz,0

.cut3_0	p_ifsamedemo	title_cut4,.cut4
	p_goto		.cut3_0


.cut4
	P_GOSUB	.pos

.cut4_0	p_ifsamedemo	title_cut5,.cut5
	p_goto		.cut4_0


.cut5
	P_GOSUB	.pos

	p_do		18
	p_set		vz,5
	p_next

	p_wait		5

	p_do	20
	p_chase		worldx,title_cam_cut5_x+150
	p_chase		worldy,title_cam_cut5_y+100
	p_set		vz,8
	p_next


.cut5_0	p_ifsamedemo	title_cut6,.cut6
	p_goto		.cut5_0


.cut6
	p_set	vz,0

	P_GOSUB	.pos

.cut6_0
	p_ifsamedemo	title_cut6,.cut7
	p_goto		.cut6_0


.cut7
	p_end







.always
	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate
	p_return


;************
.pos	LOCAL
	p_index	worldx,title_cam.x,ap
	p_index	worldy,title_cam.y,ap
	p_index	worldz,title_cam.z,ap
	p_inc	ap
	p_return
;************
;----------------------------------------------------------------------------------
	start_path	title_bwing

	p_gosub		.pos

.enter	LOCAL

	p_alwaysgenvecs	on

	p_set		pword1,0
	p_trigger	.always,always

	p_collisions	off

	p_set	vel,hp

	p_set	rotz,-10

;>>>>>>>>>>>total 45h
	p_wait	10h
	p_ifnotsame	ap,0,.noSE
	P_SOUND		p2_demo_arwing	;GAKKI
.noSE	p_wait	35h
;<<<<<<<<<<<
	p_gosub	.child

	p_do	15
	p_gosub	.addchild
	p_next

.cut1	p_ifsamedemo	title_cut2,.cut2
	p_goto		.cut1


.cut2	p_wait		1

	p_setvel	11
	p_add		ap,3
	p_gosub		.pos
	p_gosub		.child


	p_do		count
	p_gosub		.addchild
	p_next


	p_findshape	dragon_0s


	p_do	16
	p_chase	rotz,40
	p_add	worldx,-5
	p_next

	P_SOUNDEFTPOS	ob_throughObst_L

	p_do		count
	p_faceshape
	p_setvel	50
	p_next


	p_do		10
	p_add		rotx,-1
	p_next


.cut2_0	p_ifsamedemo	title_cut3,.cut3
	p_goto		.cut2_0


.cut3	p_invisible	on

	P_SOUND		port2_stop

.cut3_0	p_ifsamedemo	title_cut4,.cut4
	p_goto		.cut3_0



.cut4	p_add		ap,3

	p_ifnotsame	ap,6,.noSE4
	P_SOUND		p2_demo_arwing	;GAKKI
.noSE4

	p_invisible	off
	p_gosub		.pos

	p_setvel	30

	p_set		rotz,0

	p_wait		4


	p_ifnotsame	count,0,.cut4_2
	p_circlewindow	0
	p_set	hp,0

.cut4_2	p_gosub		.child

	p_do		20
	p_gosub		.addchild2

	p_next


.cut4_0	p_ifsamedemo	title_cut5,.cut5
.cut4_1	p_goto		.cut4_0


.cut5
	p_add		ap,3
	p_gosub		.pos
	p_setvel	40


	p_do	count
	p_next

	p_remove




.always	p_inc		pword1
	p_collisions	off
	p_return



.pos	p_index	worldx,title_bwing.x,ap
	p_index	worldy,title_bwing.y,ap
	p_index	worldz,title_bwing.z,ap
	p_index	count,title_bwing.count,ap
	p_index	rotx,title_bwing.rotx,ap
	p_index	roty,title_bwing.roty,ap
	p_return

.child	p_index	childx,title_bwing.childx,ap
	p_index	childy,title_bwing.childy,ap
	p_index	childz,title_bwing.childz,ap
	p_index	rotz,title_bwing.crotz,ap
	p_return


.addchild2
.addchild

	P_START65816

	jsl	title_bwing_path_l

	P_END65816

;	p_chase	rotz,0
;	p_add	worldx,childx
;	p_add	worldy,childy
;	p_add	worldz,childz
;	p_chase	childx,0
;	p_chase	childy,0
;	p_chase	childz,0


	p_return

;----------------------------------------------------------------------------------

	start_path	title_ship_1

	p_groundobj	on

	p_setvel	20
	p_set		vy,-5

	p_collisions	off

	p_gosub	Ptitle_cam.pos

.cut1	p_ifsamedemo	title_cut2,.cut2
	p_goto		.cut1

.cut2	p_ifsamedemo	title_cut4,.cut4
	p_invisible	on
	p_goto		.cut2

.cut4	p_gosub	Ptitle_cam.pos
	p_invisible	off

	p_wait	14
	p_circlewindow	0,big
	P_SOUNDEFTDISTPOS	en_explode_demo
	p_wait	1

	p_set		hp,0

	p_end

;----------------------------------------------------------------------------------

	start_path	title_ship_explode_0

	p_set	vz,7

	p_collisions	off

	p_wait	20+10h

	p_spawn	50,5,0,0,3,deg90+10,clipshape,title_ship_clip,1,1,childno_title
	p_set	clip,plane_BOSS2
	p_Qspawn	ship_0,title_ship_explode_l,1,1


	p_wait	28+20-10h-4


	p_trigger	Pcds_chika.exp,always

	p_wait	4

	p_circlewindow	1,big
	p_set		hp,0

	p_end



	start_path	title_ship_explode_l

	p_groundobj	on

	p_set	vz,15

	p_collisions	off

	p_set	clip,plane_BOSS

	p_set	depthoffset,2

	p_wait	8

	p_trigger	.add,always,20

	p_wait	16

	p_set	shape,nullshape

	p_add	worldx,-200

	p_circlewindow	2
	p_trigger	Pcds_chika.exp,always
	p_wait	3
	p_set		hp,0
	p_end


.add	p_add		worldy,-6
	p_add		worldx,-3
	p_return

;--------------------------------------------------------------------------------------------------

	start_path	title_ship_clip
	p_collisions	off
	p_groundobj	on
	p_wait	65
	p_remove


	start_path	title_dragon_clip
	p_collisions	off
	p_groundobj	on
	p_end

;--------------------------------------------------------------------------------------------------
	start_path	title_warps


	p_collisions	off

	p_wait		title_nintendo_time

	p_trigger	.always,always

	p_spawn	0,0,-500,0,0,0,nullshape,title_warp_top,1,1,childno_title_warp0
	p_spawn	0,0,-(173)<<warps_scale-500,0,0,0,nullshape,title_warp_other,1,1,childno_title_warp0
	p_spawn	0,0,-(173*2)<<warps_scale-500,0,0,0,nullshape,title_warp_other,1,1,childno_title_warp0

	p_do	15
	p_add	childz,-300/15
	p_next

	p_do	8
	p_chase	childx,-400
	p_next

.cut1_0	p_ifnotdemo	title_cut1,.remove
	p_goto		.cut1_0

.remove	p_wait	1
	p_remove



.always	p_ifsame	childrotx,10,.ret
	p_add		childrotx,-1
.ret	p_return

;----------------------------------------------------------------------------------
	start_path	title_warp_top
	start_path	title_warp_other

	p_collisions	off

	p_wait	1

	p_set	shape,warps

	p_trigger	.add,always,80

	p_wait	35

	p_groundobj	on

	p_wait	45

	p_remove


.add	p_add	childz,100
	p_return

;----------------------------------------------------------------------------------
	start_path	superdragon_demo

	P_CLRBOSSFLAGS

	P_SETBOSSFLAG	sdf_ground,on

	p_groundobj	on

	p_collisions	off

;	p_set	worldx,-1500
;	p_set	worldy,-1500
;	p_add	worldz,1500
;	p_set	worldz,0b94h

	p_gosub	Pes0_cam.pos

;	p_print	worldx,h,kawagoe
;	p_print	worldy,h,kawagoe
;	p_print	worldz,h,kawagoe

	p_set	pbyte1,0

;	p_spawn		30,30,20,15,30,40,b_wing,e_nocol_s_off,1,1,childno_title
;	p_become
;	p_unbecome

	p_spawn		0,0,-(45>>2),0,0,0,dragon_1s,superdragon_body1s,1,1,childno_dragon_body

	P_START65816
	s_set_objtobevar	y,becomelastobj&WM
	stx			al_immuneptr,y
	P_END65816


.cut2
	p_do	8
	p_ifsamedemo	title_cut3,.cut2_0
	p_dec	rotx
	p_add	roty,6
	p_next

	p_do	8
	p_ifsamedemo	title_cut3,.cut2_0

	p_inc	rotx
	p_add	roty,-6
	p_next
	p_goto	.cut2

.cut2_0	p_break	.cut3



.cut3
	p_set		rotx,14h	;8+8+4
	p_set		roty,deg180

	p_demoshape

	p_alwaysgenvecs	on
	p_setvel	30

;	p_spawn		0,0,-123<<warp_scale,0,0,0,warp,title_dragon_beam,1,1,childno_title
	p_spawn		0,0,50-20-10,deg270,0,0,clipshape,title_dragon_clip,1,1,childno_title


.cut3_0
	p_setanim	15

	p_do	8
	p_addanim	1,16
	p_add	rotx,1
	p_next

	P_SOUNDEFTDISTPOS	bs_cry_1

	p_do	8
	p_addanim	1,16
	p_add	rotx,-1
	p_next

	p_do	8
	p_addanim	1,16
	p_add	rotx,-1
	p_next

	P_SOUNDEFTDISTPOS	bs_cry_1

	p_do	4
	p_addanim	1,16
	p_add	rotx,-1
	p_next





.cut3_3
	p_setanim	0
	p_do	8
	p_addanim	1,15
	p_chase	roty,deg180+50+20+5
	p_next


	P_SOUNDEFFECT	bs_dragon_laser
	P_SOUNDEFFECT	bs_cry_2
	p_spawn		0,30,-123<<warps_scale,0,0,0,warps,title_dragon_beam,1,1,childno_title

.cut3_4	p_ifsamedemo	title_cut4,.cut4
	p_add	roty,1
	p_goto	.cut3_4


.cut4	; cut5 no position de taiki.

	p_inc	ap
	p_setvel	0

	p_gosub	Pes0_cam.pos

;	p_set	worldx,title_cam_cut5_x-300+50
;	p_set	worldy,title_cam_cut5_y-150
;	p_set	worldz,title_cam_cut5_z+50+50
;	p_set	roty,deg180
;	p_set	rotx,0


.cut4_0	p_ifsamedemo	title_cut5,.cut5
	p_goto		.cut4_0



.cut5	p_setbossflag	sdf_bottom,ON

	p_Qspawn	nullshape,title_watch3,1,1

	p_do	8
	p_chase	rotz,-30
	p_chase	rotx,10
	p_next

	p_do	10
	p_chase	roty,deg180+100
	p_chase	roty,deg180+100
	p_chase	rotx,30
	p_chase	rotz,20
	p_next

	p_setvel	70

	p_accel	0,7

	p_wait	2

	p_spawn		0,20,50,0,30h,-20,ryousan,title_dragon_bwing,1,1,childno_title_dragon_bwing

	p_wait	2
	P_SOUNDEFFECT	en_dragon_kamu
	p_wait	1

	p_setanim	4
	p_do	5
	p_next


	p_Qspawn	ryousan,title_dragon_bwing2,1,19

	p_do	15
	p_chase	rotx,10
	p_chase	rotz,20
	p_chase	roty,140
	p_next



	p_do	4
	p_addanim	1,16
	p_chase	rotz,0
	p_chase	roty,20
	p_next


;	P_SOUNDEFTDISTPOS	bs_cry_1
	P_SOUNDEFFECT	bs_dragon_through

	p_do	6
	p_setanim	8
	p_chase	rotz,0
;	p_chase	roty,20

	p_chase	roty,10
	p_chase	roty,10

	p_next


	p_do	18
	p_chase	roty,0
	p_next

;	p_do	10
;	p_add	roty,5
;	p_next
;
;	p_do	8
;	p_chase	roty,00h
;	p_chase	roty,00h
;	p_chase	roty,00h
;	p_next


	p_inc	ap
	p_gosub	Pes0_cam.pos

;	p_set	worldx,title_cam_cut6_x-200
;	p_set	worldy,title_cam_cut6_y-100
;	p_set	worldz,title_cam_cut6_z
;	p_set	rotx,30+8
;	p_set	roty,-20
;	p_set	rotz,-10


.cut5_0	p_ifsamedemo	title_cut6,.cut6
	p_goto		.cut5_0


.cut6
	p_demoshape

	p_setanim	0

	p_do	8
	p_addanim	1,16
	p_chase		rotx,-20
	p_chase		rotz,20
	p_next


	P_SOUNDEFFECT	bs_dragon_cry

	p_set	pbyte1,0

	p_do	10
	p_index	childroty,superdragon_demo.dat0,pbyte1
	p_add	roty,childroty
;	p_dec	rotx
	p_inc	pbyte1

	p_next

	p_setvel	40
	p_accel		0,2

	p_do	9
	p_chase	roty,deg180
	p_chase	rotx,40
	p_next

	p_set	worldz,title_cam_cut6_z
	p_set	roty,deg270

	p_accel		0,0
	p_setvel	0

	p_end


;.always	p_push	ptr
;	p_set	ptr,viewblk1
;	p_faceshape	immediate
;	p_pull	ptr
;	p_set	rotx,18h
;
;	p_print	rotx,h,kawagoe
;	p_print	roty,h,kawagoe
;	p_print	rotz,h,kawagoe
;
;	p_return




;.loop
;	p_setanim	4
;	p_setbossflag	sdf_bottom,ON
;	p_setbossflag	sdf_top,OFF
;	p_do	30
;;	p_add	roty,8
;	p_chase	rotx,30
;	p_next
;
;
;	p_setbossflag	sdf_top,ON
;	p_setbossflag	sdf_bottom,OFF
;
;
;	p_do	30
;;	p_add	roty,8
;	p_chase	rotx,-30
;	p_next
;
;
;
;	p_goto	.loop
	p_end

;----------------------------------------------------------------------------------
;	start_path	title_dragon_warp
;
;	p_collisions	off
;;	p_groundobj	on
;	p_do	20
;;	p_add	childz,100
;;	p_next
;	p_end
;
;----------------------------------------------------------------------------------
	start_path	title_dragon_bwing

	p_collisions	off

	p_wait		27

	p_set		vx,5
	p_set		vz,40

	p_unlinkchild	childno_title_dragon_bwing

	p_do		18
	p_add		roty,16
	p_add		rotx,1
	p_add		rotz,10
	p_next

	p_circlewindow	0

	p_setvel	0
	p_set	hp,0
	p_end



;----------------------------------------------------------------------------------
	start_path	title_dragon_bwing2

	P_SOUND		p2_demo_arwing	;GAKKI

	p_collisions	off

	p_gosub	Pes0_cam.pos

;	p_add	worldx,-270
;	p_add	worldz,600
;	p_add	worldy,20
;
;
;	p_print	worldx,h,kawagoe
;	p_print	worldy,h,kawagoe
;	p_print	worldz,h,kawagoe
;
;
;	p_set	rotz,-40
;	p_set	roty,-30
;	p_set	rotx,0

	p_alwaysgenvecs	on

	p_setvel	12

	p_invisible	on

	p_do		11
	p_add		roty,-1
	p_next

	p_invisible	off

	p_do		26
	p_add		roty,-1
	p_next

	p_set	roty,-100

	p_set	rotx,6

	p_setvel	20

	p_do	18
	p_add	rotz,8
	p_next

	p_set	hp,0

	p_circlewindow	1,big

	p_end


;----------------------------------------------------------------------------------
	start_path	title_dragon_beam


	p_set		clip,plane_BOSS2

	p_collisions	off

	p_do		20
;	p_set	childz,0
	p_add	childz,100
	p_next
	p_remove

;----------------------------------------------------------------------------------
	start_path	title_dragon_beam2
	p_collisions	off

	p_wait	15

	p_setvel	127

	p_add	vx,vx
	p_add	vy,vy
	p_add	vz,vz


.cut4	p_ifsamedemo	title_cut5,.remove
	p_goto		.cut4

.remove	p_remove



	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	START_PATH	e_pla_test
	P_SOUNDEFTDISTPOS	en_ringlaser_s
	P_SETTYPE	LASER
	P_SET		shape,enemybomb
	P_SPRITE	0,24		;eweap_size
	P_ALWAYSGENVECS	ON
	P_SOUND		p2_EPlasma	;0C
	P_FACEPLAYER	IMMEDIATE
	P_ALWAYSGENVECS	ON
	P_QUADVECS	ON
	P_DISTLESS	5000,.slow
	P_DISTLESS	7500,.mid
	P_DISTLESS	10000,.fast
	P_SETVEL	10
.fast	P_ADD		vel,5
.mid	P_ADD		vel,5
.slow	P_ADD		vel,25
	P_SETRANDOM	slopenum,3
	P_SETRANDOM	pbyte2,7
	P_INDEX		childrotx,.haba_tab,pbyte2
;	P_SETRANDOM	childroty,3
	P_SETRANDOM	childroty,7
	P_ADD		childroty,4
	P_SETRANDOM	pbyte2
	P_TRIGGER	.life_ck,Always
	P_TRIGGER	.wave_dat,Always
	P_TRIGGER	.syusoku,16
.llp	P_DISTLESS	4000,.sst
	P_GOTO		.llp
.sst	P_TRIGGER	.syusoku,OFF
	P_TRIGGER	.syusoku,8
.lp	P_DISTLESS	1000,.st
	P_GOTO		.lp
.st	P_ACCEL		25,2
	P_TRIGGER	.wave_dat,OFF
	P_SET		slopenum,6
	P_IFSMALLER	childrotx,slopenum,.hazure
	P_SCORE		1
	P_FACEPLAYER	IMMEDIATE
.hazure	P_WAIT		40
.rem	P_REMOVE
	P_END
.syusoku	P_IFSAME	childrotx,8,.ok
	P_INC		childrotx
.ok	P_RETURN
.wave_dat	P_FACEPLAYER	IMMEDIATE
	P_INDEX		pbyte1,costab,pbyte2
	P_DO		childrotx		;2
	P_DIV2		pbyte1
	P_INEXT
	P_ADD		pbyte2,childroty
	P_IFZERO	slopenum,.zz
	P_IFSAME	slopenum,1,.only_x
	P_IFSAME	slopenum,2,.only_y
.nzz	P_ADD		rotx,pbyte1
	P_NEG		pbyte1
	P_ADD		roty,pbyte1
	P_RETURN
.zz	P_ADD		rotx,pbyte1
.only_y	P_ADD		roty,pbyte1
	P_RETURN
.nonly_x	P_NEG		pbyte1
.only_x	P_ADD		rotx,pbyte1
	P_RETURN
.nonly_y	P_NEG		pbyte1
	P_ADD		roty,pbyte1
	P_RETURN
.life_ck	P_INC		pword1
	P_IFNOTSAME	pword1,110,.forc
	P_FORCE		.rem
.forc	P_PRINT		pword1,d,eguchi
	P_RETURN
.haba_tab	db	1,2,3,1
	db	1,2,3,1
	P_END
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;----------------------------------------------------------------------------------
	printf	"Title demo length = ",*-TITLEDEMO,"%n"


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; DRAGON for Credits
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	start_path	credits_dragon

; !!don't use PBYTE1

;;;;	p_radarobj	ra_enemy

	P_INVISIBLE	ON

	P_TRIGGER	offcheck,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF

	p_alwaysgenvecs	on
	p_setvel	50

	p_gosub	prou_dragon

	p_setbossflag	sdf_coloff,ON

	p_set	childrotx,20
	p_zero		pbyte2
	p_rtrigger	.always,always

	p_end


.always	p_chase	rotx,childrotx

;	p_add	vy,vy
;	p_add	vy,vy
;	p_add	vy,vy
;	p_add	worldy,vy

	p_inc		pbyte2
	p_ifnotsame	pbyte2,8,.sret1
	p_zero	pbyte2
	p_neg	childrotx
.sret1	p_return



;---------------------------------------------------------------------------------------

	END
