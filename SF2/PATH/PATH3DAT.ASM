;
; PATHDATA3.ASM - Title Demo and Expansion Paths
; Add new path routines here using START_PATH / P_* macros.
;

;============================================================================================
;	TITLE DEMO
;============================================================================================
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

; inlined prou_posrot0 (cross-bank gosub broken; PATH3DAT lives in different SNES bank than PATHS/PATHS2)
	p_zero	rotx
	p_zero	roty
	p_zero	rotz
	p_zero	worldx
	p_zero	worldy
	p_zero	worldz

	p_copypos2player
	p_copyrot2player

	p_spawn		0,0,300,0,0,0,nullshape,title_watch,1,1,childno_title

	p_qxspawn	nullshape,nintendopresents,1,1	; cross-bank: lives in BPATHDAT ($44)
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


;????????????
.pos	LOCAL
	p_index	worldx,title_cam.x,ap
	p_index	worldy,title_cam.y,ap
	p_index	worldz,title_cam.z,ap
	p_inc	ap
	p_return
;????????????
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

	p_qxgosub	Pes0_cam.pos

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


	p_trigger	Pcds_chika_xb,always

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
	p_trigger	Pcds_chika_xb,always
	p_wait	3
	p_set		hp,0
	p_end


.add	p_add		worldy,-6
	p_add		worldx,-3
	p_return

;--------------------------------------------------------------------------------------------------
; Trampoline: trigger fires this in bank $52, then cross-bank gosubs into TPATHDAT bank $44.
	start_path	cds_chika_xb
	p_qxgosub	Pcds_chika.exp
	p_return

; Trampoline for spawned dragon body: spawned in bank $52 by superdragon_demo,
; this jumps into GPATHDAT bank $44 superdragon_body1s which runs forever.
	start_path	superdragon_body1s_xb
	p_qxgosub	Psuperdragon_body1s
	p_end
;--------------------------------------------------------------------------------------------------

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

	p_qxgosub	Pes0_cam.pos

	p_set	pbyte1,0

	p_spawn		0,0,-(45>>2),0,0,0,dragon_1s,superdragon_body1s_xb,1,1,childno_dragon_body

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


.cut4
	p_inc	ap
	p_setvel	0

	p_qxgosub	Pes0_cam.pos


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


	P_SOUNDEFFECT	bs_dragon_through

	p_do	6
	p_setanim	8
	p_chase	rotz,0

	p_chase	roty,10
	p_chase	roty,10

	p_next


	p_do	18
	p_chase	roty,0
	p_next


	p_inc	ap
	p_qxgosub	Pes0_cam.pos


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

	p_qxgosub	Pes0_cam.pos

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

