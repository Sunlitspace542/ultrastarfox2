;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                                                                    ³
;³                 STARFOX II - REVENGE OF PEPPY -                    ³
;³                                                                    ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³                                                                    ³
;³ FILE:         TPATHDAT.ASM                                         ³
;³ AUTHOR:       Takumi Kawagoe                                       ³
;³ DESCRIPTION:  Effect,enemy & weapon strategy                       ³
;³ DATE CREATED: 16-3-93                                              ³
;³                                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	incpub	tpathdat

childno_base_t	equ	50
childno_base_u	equ	51
childno_base_rb	equ	52
childno_base_rf	equ	53
childno_base_rh	equ	54
childno_base_lf	equ	55
childno_base_lb	equ	56
childno_base_lh	equ	57

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	DUMMY PATH
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	path_dummy

;	p_remove

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	STARFOX ARE GO!
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	logodirector
	start_path	letsgodirector

letsgo_opentime	equ	40h
letsgo_entertime	equ	0a7h
letsgo_turntime	equ	10h

ld_warp		equ	09ah

	p_rtrigger	.always,always

	p_collisions	off

	p_setvar	w,player1hscroll_offset,300h	;-200h

	p_set	vz,10

	p_setdemo	1

	p_setvar	w,player1_horizon_offset,SCR2_Hofs-10h
	p_gosub		prou_posrot0

	p_Qspawn	nullshape,letsgo_cam,1,3
	p_Qspawn	nullshape,letsgo_base,1,1

	p_end



.always	p_import	pword1,player1_horizon
	p_export	player1vscroll,pword1

	p_return


;----------------------------------------------------------------------------------

	start_path	letsgo_base
	p_trigger	letsgo_key,always

	p_alwaysgenvecs	on

	p_setvel	10

	p_spawn	-55<<base_scale,194h-368h-20h-40h,480h,50,deg180,0,nullshape,letsgo_friend,1,4,1
	p_spawn	55<<base_scale,194h-368h-20h,500h,50,deg180,0,nullshape,letsgo_awing,1,1,1
	p_spawn	0,0,70<<base_scale,64,0,0,nullshape,letsgo_clip,10,10,1

	p_spawn	55<<base_scale,15<<base_scale,80<<base_scale,64,0,0,base_h,letsgo_base_h,10,58h,childno_es0_base_hr
	p_spawn	-55<<base_scale,15<<base_scale,80<<base_scale,64,0,0,base_h1,letsgo_base_h,10,52h,childno_es0_base_hl

	p_gosub		prou_makebase_h

	p_becomechild	childno_base_rf
	p_groundobj	on
	p_unbecome
	p_becomechild	childno_base_rb
	p_groundobj	on
	p_unbecome

	p_wait	110

	p_gosub	prou_remove_hatch

	p_accel	20,1

	p_wait	40

	p_wait	ld_warp-40-110

	p_spawn	0,-(90-40)<<base_scale,-130<<warpl_scale,0,0,0,warpl,letsgo_warp,1,1,1

	p_alwaysgenvecs	off

	p_quadvecs	on
	p_accel	0,0
	p_setvel	100

	p_add	vy,-20

	P_SOUNDEFFECT	en_dash_demo

	p_wait	20

	p_circlewindow	8,warp

	p_wait	20

	p_remove



.always	p_inc		pbyte1
	p_ifsame	shape,base1_lh,.l
.r	p_set		shape,base1_rf
	p_igoto		.noh
.l	p_set		shape,base1_lf
.noh	p_return


;------------ hatch

	start_path	letsgo_base_h

	p_collisions	off

	p_set	count,ap
	p_wait	count

	p_igoto	Pscramble_base_h.close2

;----------------------------------------------------------------------------------
	start_path	letsgo_cam

; pbyte1	: flag

	p_rtrigger	.key,always

	p_gosub	Pes0_cam.pos	; set AP = 3

	p_set	vz,10

	p_copypos2view	1,immediate

	p_rtrigger	.always,always

	p_wait	2bh

	p_set	vy,-10
	p_set	vz,7
	p_set	vx,5

	p_wait	48h-2bh

	p_set	vy,15
	p_set	vx,4+2
	p_set	vz,-10

	p_wait	40

	p_set	vy,0
	p_set	vx,-4

	p_wait	40

	p_set	vx,0

	p_wait	ld_warp-40-40-48h

	p_set	vy,0

	p_copyviewrots_demo
	p_trigger	.always,off
	p_rtrigger	.always3,always

	p_set	roty,0
	p_set	rotx,0
	p_set	rotz,0

	p_set	vz,10
	p_end

;************

.key	P_START65816
	lda	tiw_sprmode
	cmp	#1
	beq	.remove
	P_END65816
	p_return


.remove	P_END65816

	p_trigger	.key,off
	p_trigger	.always,off
	p_trigger	.always3,off

	p_add	worldx,8000h
	p_add	worldz,8000h

	p_set	vx,0
	p_set	vz,10
	p_set	vy,0

	p_copyviewrots_demo
	p_zero	rotx

	p_copypos2view	1,immediate
	p_copyrot2view	1,immediate

	p_force	.pushed
	p_return



.pushed	p_zero	roty	; ROTY no scroll no houga ROTX yori hayaitame,
			; ROTY no set wo okuraseteiru!

.ploop	p_copypos2view	1,immediate
	p_copyrot2view	1,immediate
	p_goto		.ploop

	p_end



.always	p_campandemoshape	1,1,immediate
	P_START65816
	jsl	letsgo_cam00_path_l
	P_END65816
	p_copypos2view		1
	p_return


.always3	p_copypos2view		1
	p_copyrot2view		1
	p_copyrot2view		1
	p_chase			rotx,0

	p_return

;----------------------------------------------------------------------------------
	start_path	letsgo_friend

	p_import	pbyte1,demoNo
	p_ifsame	pbyte1,demo_logo,.logo

	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.remove
	P_GOSUB		set_friend_shape
	p_igoto		Pletsgo_awing.enter

.remove	p_remove

.logo	p_playershape
	p_igoto		Pletsgo_awing.enter






	start_path	letsgo_awing

	p_demoshape

	p_import	pbyte1,demoNo
	p_ifsame	pbyte1,demo_logo,.logo

	p_playershape
	p_igoto	.enter

.logo	p_gosub		prou_titlepilotNo


.enter	LOCAL

	p_collisions	off

	p_alwaysgenvecs	on
	p_setvel	20

	p_set	count,ap
	p_wait	count

	p_do	52
	p_dec	childrotx
	p_next

	p_set	clip,plane_BOSS

	p_accel	10,1

	p_wait	30

	P_SOUND		port2_stop

	p_wait	7

	p_accel		0,0
	p_setvel	0

	p_end

;----------------------------------------------------------------------------------
;
;	start_path	letsgo_watch
;
;	p_rtrigger	letsgo_key,always
;
;	p_collisions	off
;
;	p_demoshape
;
;	p_set	vy,-40
;
;	p_wait	10h
;
;	p_set	vy,0
;	p_set	vz,10
;
;	p_end
;
;----------------------------------------------------------------------------------

	start_path	letsgo_clip

	p_wait		1
	p_set		shape,clipshape
	p_groundobj	on

	p_end

;----------------------------------------------------------------------------------
	start_path	letsgo_warp

	p_rtrigger	letsgo_key,always

;	p_shadow	off
	p_collisions	off

	p_wait		31

	p_remove

;----------------------------------------------------------------------------------
letsgo_key
	P_START65816
	lda	tiw_sprmode
	cmp	#1
	bpl	.remove
	P_END65816
	p_return

.remove	P_END65816
	p_force	demoobj_remove
	p_return




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; SUISEI for Credits
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	credits_suisei

	p_rangecheck	off

	P_INVISIBLE	ON

	P_TRIGGER	offcheck,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF

	p_setvel	10

	p_igoto		Parmada_suisei.enter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; CRUSHER for Credits
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	credits_crusher

	p_collisions	off
	p_set	hp,127

	P_INVISIBLE	ON

	p_set	childroty,2
	p_rtrigger	.roty,always

	P_TRIGGER	offcheck,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF

	p_setvel	50

	p_gosub	prou_crusher

	p_wait	120
	p_wait	62

	p_do	32
	p_inc	childroty
	p_next

	p_end


.roty	p_add		roty,childroty
	p_return



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; STEPUP for Credits
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	credits_stepup

	p_collisions	off

	p_set	hp,20

	P_INVISIBLE	ON

	P_TRIGGER	offcheck,ALWAYS
	P_WAIT		1
	P_INVISIBLE	OFF

	p_setvel	50

	p_gosub	prou_armada_stepup_init

	p_set	shape,stepup_0

	p_end

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	STAR WOLF
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	STARWOLFdirector

;childno_kiran	equ	99


	P_START65816
	KBGM	stg2
	P_END65816



	start_path	STARWOLFdirector_demo

	p_setvar	w,player1_horizon_offset,SCR4_Hofs

	p_import	pbyte1,demomode
	p_ifzero	pbyte1,.nodemo0
	p_demosetmap	; map start
.nodemo0



	p_active	on
	p_collisions	off
	p_copyplayerpos

	P_START65816
	jsl	STARWOLFdirector_demo_path_l
	P_END65816

;	p_add	worldx,8000h
;	p_add	worldy,8000h
;	p_add	worldz,8000h

;	p_set	rotx,26
;	p_set	roty,deg90
;	p_zero	rotz

	p_setvel	30

	p_spawn		100,10,-3500,0,0,50,nullshape,sw_wolf,1,1,1

	p_wait	2

	p_set	count,95+15+1

	p_ifnotzero	pbyte1,.do
	P_BEGINDEMO

	p_add	count,-15

.do	p_do	count

	p_copypos2view	1,immediate
	p_campandemoshape	1,1,immediate

	P_START65816
	jsl	STARWOLFdirector00_path_l
	P_END65816
	p_next


	p_ifzero	pbyte1,.enddemo
	p_setvar	b,Etrigger,1

	p_copyplayerrots
	p_copyrot2view	1,immediate

	p_remove

.enddemo	P_ENDDEMO
	p_remove

;----------------------------------------------------------------------------------

	start_path	sw_wolf

	p_sound		p2_wolf_arwing

	p_import	ap,starwolfNo

	p_spawn	0,0,60,0,0,0,nullshape,e_nocol_s_off,1,1,1
	p_become
	p_demoshape
	p_unbecome

	p_active	on

	p_collisions	off
	p_alwaysgenvecs	on

	p_import	pbyte1,demomode
	p_ifzero	pbyte1,.nodemo0

	p_wait	15

.nodemo0

;---- kiran! ----
	p_wait	5

	p_set	shape,kiran

	P_SOUNDEFFECT	wolf_flash

	p_setanim	0

	p_wait	1

	p_do	6
	p_addanim	1,6
	p_next

	p_set	shape,nullshape

	p_wait	8

	p_setvel	120

;---- wolf ----

	p_index	shape,sw_wolf,ap

	p_wait	14h

	p_accel	15,7

	p_ifsame	ap,3,.andrew
	p_ifsame	ap,2,.pigma
	p_ifsame	ap,1,.leon

.wolf	P_MSG	176
	p_igoto	.endmsg
.leon	P_MSG	169
	p_igoto	.endmsg
.pigma	P_MSG	170
	p_igoto	.endmsg
.andrew	P_MSG	171
.endmsg

	p_rtrigger	.always2,always

	p_wait	10h+8

	p_accel	120,1

	p_wait	10

	p_setvel	80

	p_spawn	0,0,-(40<<wolf_scale),0,0,0,boost_big,demoboost_active,1,1,childno_cds
	p_become
	p_active	on
	p_unbecome
	P_SOUNDEFFECT	boost

	p_end


.always2	p_dec	childrotz
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	PLANET CANON
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	creditseqdirector

	p_setdemo	1
	p_collisions	off

	p_setvar	w,player1_horizon_offset,SCR4_Hofs

	p_wait	60

	p_fadein

	p_Qspawn	nullshape,creditseq,1,1

	p_end

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	PLANET CANON
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	planetcannondirector

childno_pc	equ	1
pc_cut1	equ	1

	p_setdemo	pc_cut1

	p_collisions	off
	p_gosub		prou_posrot0

	p_Qspawn	nullshape,pc_cam,1,4
	p_Qspawn	d_sen_2,pc_d_sen,5,127
	p_become
	p_demoshape
	p_unbecome

.cut1	p_ifnotdemo	pc_cut1,.cut2
	p_goto		.cut1

.cut2	p_setvar	w,player1hscroll_offset,0h
	p_set	rotx,18h
	p_spawn	400,-250,-8200,0,0,0,nullshape,pc_warp,1,1,1

	p_wait	53h

	P_SOUNDEFTDISTPOS	bs_BossExplode2

	p_end

;------------------------------------------------------------------------------
;	start_path	pc_inseki
;
;	p_shadow	off
;	p_collisions	off
;
;	p_set	vz,-10
;
;
;	p_do	20
;	p_inc	childrotx
;	p_inc	childroty
;	p_inc	childrotz
;	p_next
;
;	p_set		clip,plane_BOSS
;	p_Qspawn	clipshape,pc_clip,1,1
;
;	p_end




;	start_path	pc_clip
;
;	p_collisions	off
;
;	p_set		shape,clipshape
;
;	p_add		worldz,-200
;
;	p_wait	3
;
;	p_set		vz,200
;
;	p_end
;
;------------------------------------------------------------------------------

	start_path	pc_d_sen

	p_collisions	off

	p_set	depthoffset,4

	p_spawn	0,-15<<d_sen_scale,(-50)<<d_sen_scale,0,0,0,nullshape,pc_watch,1,1,childno_a_d_sen
	p_spawn	0,-15<<d_sen_scale,(120)<<d_sen_scale,0,0,0,d_sen_5,pc_d_sen_cannon,1,1,childno_a_d_sen

	p_Qspawn	d_sen_0,pc_d_sen_parts_g,1,0
	p_Qspawn	d_sen_1,pc_d_sen_parts_g,1,1
	p_Qspawn	d_sen_3,pc_d_sen_parts,1,2
	p_Qspawn	d_sen_4,pc_d_sen_parts,1,3

	p_wait	0c4h

.remove	p_remove




	start_path	pc_d_sen_parts_g

	p_groundobj	on

	start_path	pc_d_sen_parts

;	p_shadow	off
	p_collisions	off

	p_set	depthoffset,4

	p_index	worldy,pc_d_sen_parts.y,ap
	p_index	worldz,pc_d_sen_parts.z,ap

	p_wait	0c5h
	p_remove

;------------------------------------------------------------------------------
	start_path	pc_d_sen_cannon

;	p_shadow	off
	p_collisions	off

	p_trigger	Pcds_d_sen_parts_circle.depthofs4,always

	p_setanim	0

	p_spawn	0,-10<<d_sen_scale,40<<d_sen_scale,0,0,0,tamatamal,pc_tametame,1,1,1

	p_wait	98h

	p_do	9
	p_addanim	1,10
	p_next

	p_setanim	9

	p_end

;------------

	start_path	pc_tametame

	p_collisions	off
	p_sprite	0,64

	p_wait	98h-2

	p_do	9
	p_add	childz,106
	p_add	childy,-17
	p_next

	p_wait		8

	p_invisible	on
	p_spawn		0,0,0,0,0,0,p_cannon,pc_d_sen_beam,1,1,1

	p_end

;------------------------------------------------------------------------------

	start_path	pc_d_sen_beam

	p_collisions	off

	p_setanim	0

	p_wait	1

	p_do	9
	p_index	childz,pc_d_sen_beam,pbyte1
	p_inc	pbyte1
	p_addanim	1,10
	p_next

	p_wait	1

	p_add	worldz,120<<5
	p_set	childz,120<<5

	p_set	shape,warp_laser_l

	p_end

;------------------------------------------------------------------------------

	start_path	pc_watch

	p_collisions	off
	p_demoshape

	p_set	vz,50

	p_wait	5

	p_do	26
	p_chase	vz,100
	p_next

	p_wait	35

	p_do	100
	p_chase	vz,5
	p_next

	p_end

;------------------------------------------------------------------------------

	start_path	pc_warp

	p_collisions	off

	p_wait	10
	p_set	shape,warp_laser_l
	p_set	vz,400
	p_wait	2eh

	p_invisible	on

	p_wait	10

	p_set	shape,nullshape

	p_set	pword1,0

	p_set	childz,3000


	p_set	vz,0

	p_wait	11h

	p_Qspawn	nullshape,pc_explode_l,1,1
	p_Qspawn	nullshape,pc_explode_r,1,1

	p_end






	start_path	pc_explode_r

	p_set		roty,deg270
	p_set		childroty,7
	p_set	count,15
	p_igoto		Ppc_explode_l.enter


	start_path	pc_explode_l
	p_set		roty,deg90
	p_set		childroty,-2
	p_set	count,30
.enter	LOCAL

	p_alwaysgenvecs	on

	p_add	worldy,-200
	p_add	worldx,-200
	p_set	rotx,15
	p_setvel	50
	p_trigger	.2,2

	p_wait	count

	p_remove


.2	p_Qspawn	explosion2,pc_explode,1,1
	p_add		roty,childroty
	p_return







	start_path	pc_explode
	p_collisions	off
	p_sprite	0,0
	p_addrandom	tx,15
	p_addrandom	worldx,127
	p_addrandom	worldy,127
	p_addrandom	worldz,511
	p_wait	7
	p_remove

;------------------------------------------------------------------------------

	start_path	pc_cam

	p_collisions	off

	p_gosub	Pes0_cam.pos

;	p_set	worldx,0fbach
;	p_set	worldy,0f789h
;	p_set	worldz,0fbd8h

	p_rtrigger	.always,always

	p_set	vz,45

	p_wait	35

	p_do	60-10
	p_chase	vy,30
	p_next

	p_set	vx,5

	p_do	50+10+5+5
	p_chase	vy,-5
	p_chase	vz,55
	p_next

.cut1	p_ifnotdemo	pc_cut1,.cut2
	p_chase		vz,10
	p_chase		vy,-5
	p_goto		.cut1

.cut2
	p_trigger	.always,off
	p_rtrigger	.always2,always

	P_START65816
	jsl	pc_cam_path_l
	P_END65816

;	p_zero	vx
;	p_zero	vy
;	p_set	vz,10
;	p_zero	worldx
;	p_zero	worldy
;	p_zero	worldz
;	p_set	rotx,10h
;	p_set	roty,deg180-30

	p_copyrot2view		1,immediate

	p_wait	20

	p_do	5
	p_add	roty,-18
	p_add	rotx,-9
	p_next

	p_end




.always2	p_copypos2view		1,immediate
	p_copyrot2view		1
	p_return
.always	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate
	p_return



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENDING SEQUENCE - 0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	endseq0director

childno_es0		equ	10
childno_es0_suisei	equ	11
childno_es0_starfox	equ	12
childno_es0_SF	equ	13
childno_es0_base_hl	equ	14
childno_es0_base_hr	equ	15
childno_es0_watch	equ	16

es0_cam_4x	equ	-55<<base_scale+50	;-5*25
es0_cam_4y	equ	400+200+5*30+5*8
es0_cam_4z	equ	840+400+5*30+5*8

es0_cut1	equ	1
es0_cut2	equ	2
es0_cut3	equ	3
es0_cut4	equ	4
es0_cutZ	equ	5

es0_cut1time	equ	0a4h

es0_w	equ	0

	P_SOUNDPLACE	ROOM

	p_setdemo	es0_cut1

	p_Qspawn	nullshape,es0_cam,1,1
	p_Qspawn	nullshape,es0_arwing,1,1

	p_Qspawn	last_ka,es0_last_ka,1,0
	p_Qspawn	last_ka,es0_last_ka,1,1

	p_Qspawn	nullshape,es0_clip,1,1

.cut1wait	p_ifsamedemo	es0_cut2,.cut2
	p_goto		.cut1wait

;----------------------------------------------------------------------------

.cut2
	P_SOUNDPLACE	SPACE

	p_setvar	b,sdport1,%0

	p_Qspawn	extra1_1,es0_suisei,1,1

.cut2wait	p_ifsamedemo	es0_cutz,.cutz
	p_goto		.cut2wait

;----------------------------------------------------------------------------
.cutZ
;;;;;;	p_Qspawn	nullshape,creditseq,1,1

	p_remove

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------------

	start_path	es0_cam

	p_trigger	.always,always

	p_zero	ap	; pos pointer
	p_gosub	.pos

	p_copypos2view		1,immediate
	p_copyrot2view		1,immediate

	p_wait	30

	p_do	14
	p_add	roty,-(91/14)
	p_next

	p_wait	50h-30-14-10

	p_set	rotx,50

	P_SOUNDEFFECT	tunnel_explode

	p_wait	10

	p_do	8
	p_add	roty,91/8
	p_next

	p_wait	30

	p_trigger	.always,off
	p_trigger	.always2,always

	p_wait	20

	p_set	rotx,3

	p_trigger	.always2,off
	p_trigger	.always3,always

.cut1wait	p_ifsamedemo	es0_cut2,.cut2
	p_goto		.cut1wait

;----------------------------------------------------------------------------
.cut2
	p_trigger	.always3,off
	p_trigger	.always4,always

	p_inc	ap	; pos pointer
	p_gosub	.pos

	p_copyrot2view	1,immediate

;;;;;	p_spawn	-1700,-850,1900,20,180,0,batabata,es0_zako,1,1,childno_es0

	p_wait	120

	p_Qspawn	nullshape,es0_arwing2_friend2,1,8	; friend

.cut2wait	p_ifsamedemo	es0_cut3,.cut3
	p_goto		.cut2wait


;----------------------------------------------------------------------------
.cut3
	p_setvar	w,player1_horizon_offset,SCR4_Hofs+0c0h

	p_trigger	.always4,off

	p_inc	ap	; pos pointer
	p_gosub	.pos

	p_Qspawn	nullshape,es0_arwing3,1,14	; player
	p_Qspawn	nullshape,es0_fox1,1,13
	p_Qspawn	nullshape,es0_fox2,1,12
	p_Qspawn	nullshape,es0_fox3,1,11
	p_Qspawn	nullshape,es0_fox4,1,10
	p_Qspawn	nullshape,es0_fox5,1,9

	p_do	5
	p_copypos2view	1,immediate
	p_campandemoshape	1,1,immediate
	p_next

	p_rtrigger	.always5,always

	p_wait	64

	p_copyviewrots_demo

	p_zero	rotx
	p_zero	rotz

	p_do	20
	p_add	worldy,-10
	p_next

	p_Qspawn	nullshape,es0_base,1,29

.cut3_0	p_ifnotdemo	es0_cut3,.cut4
	p_goto		.cut3_0

;----------------------------------------------------------------------------
.cut4

	p_trigger	.always5,off
	p_rtrigger	.always6,always

	p_set	ap,5
	p_gosub	.pos

;	p_gosub	prou_posrot0
;	p_set	worldx,es0_cam_4x
;	p_set	worldy,es0_cam_4y
;	p_set	worldz,es0_cam_4z

	p_Qspawn	nullshape,e_nocol_s_off,1,6
	p_become
	p_gosub	.pos
;	p_set	worldx,0
;	p_set	worldy,15<<base_scale
;	p_set	worldz,40<<base_scale
	p_demoshape
	p_unbecome

	p_set	vy,-5
	p_set	vz,-5

	p_wait		13

	p_qspawn	nullshape,es0_arwing4_p,1,1	; partner
	p_qspawn	nullshape,es0_arwing4_f_s,1,3	; friend
	p_wait		25

	p_wait		30
	p_qspawn	nullshape,es0_arwing4_f,1,4
	p_qspawn	nullshape,es0_arwing4,1,0


	p_set	vx,-1

	p_wait	50

	p_qspawn	nullshape,es0_arwing4_f_s,1,2	; friend
	p_qspawn	nullshape,es0_arwing4_f_s,1,5

	p_wait	40

	p_do	20
	p_chase	vy,0
	p_next

	p_do	30
	p_chase	vz,0
	p_next

	p_zero	vx
	p_zero	vy
	p_zero	vz

	p_rtrigger	.always7,always

	p_wait		109h-208

	p_trigger	.always6,off

	p_end


;----------------------------------------------------------------------------

.remove	p_remove

;----------------------------------------------------------------------------

.always7	p_import	pword1,player1_horizon_offset
	p_dec		pword1
	p_export	player1_horizon_offset,pword1
	p_copypos2view	1,immediate
	p_return


.always6	p_copypos2view	1,immediate
	p_campandemoshape	1,1,immediate
	p_return


.always5	p_copypos2view	1
	p_campandemoshape	1,1
	p_return


.always3	p_add	rotz,1
	p_neg	rotx
	p_copyrot2view	1
	p_return



.always2	p_add	rotz,1
.always	p_neg	rotx
	p_chase	rotx,0

	p_copyrot2view	1
	p_copypos2view	1

	p_return


.always4	p_campandemoshape	1,0,immediate

	P_START65816
	ldy	#viewblk1
	a16
	lda	#deg180<<8
	sta.w	al_roty,y
	a8
	P_END65816

	p_copypos2view	1,immediate

	p_setvar	w,player1_horizon_offset,SCR4_Hofs+80h

	p_return

;----------------------------------------------------------------------------------
.pos	LOCAL
	p_index	worldx,es0_cam.x,ap
	p_index	worldy,es0_cam.y,ap
	p_index	worldz,es0_cam.z,ap
	p_index	rotx,es0_cam.rx,ap
	p_index	roty,es0_cam.ry,ap
	p_index	rotz,es0_cam.rz,ap
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	es0_watch

	p_collisions	off

	p_wait	1

	p_demoshape

	p_wait	13+25+30+50-1

	p_do	60
	p_add	childx,-2
	p_next

	p_end



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	es0_arwing

	p_set	worldx,-80

	p_rtrigger	.always,always
	p_trigger	es0_cut1_always,always

	p_collisions	off

	p_trigger	prou_playerdmg,always
	p_playershape

	p_setvel	12

	p_demoshape

	p_set	worldz,-450

	p_set	rotz,-40

	p_wait	40h-10

	p_accel	0,2

	p_wait	10h

	p_accel		0,0
	p_setvel	20


	p_do	25
	p_chase	vz,-20
	p_add	rotx,6
	p_add	rotz,16
	p_next

	p_do	20
	p_chase	vz,-5
	p_add	rotx,4
	p_add	rotz,8
	p_next

	p_do	20
	p_chase	vz,0
	p_chase	rotx,0
	p_chase	rotz,-30
	p_next

	p_set	rotx,0
	p_set	rotz,0
	p_set	childrotz,30

	p_wait	10

	p_set	vz,40

	p_gosub		prou_demoboost

;	p_spawn		0,0,-20,0,0,0,boost,demoboost,1,1,childno_cds

	P_SOUNDEFFECT	boost

	p_end


.always	p_add	rotz,childrotz
	p_chase	childrotz,0

	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------------

	start_path	es0_last_ka

	p_trigger	es0_cut1_always,always
	p_groundobj	on
	p_set	clip,plane_BOSS
	p_index	worldz,.zdat,ap

	p_collisions	off

	p_set	rotx,deg90
	p_set	vz,-4<<last_ka_scale

.loop	p_wait	80/4
	p_add	worldz,80<<last_ka_scale
	p_igoto	.loop

	p_end


.zdat	LOCAL

	dw	120<<last_ka_scale
	dw	-(120<<last_ka_scale)


;------------
	start_path	goto_es0_last_ka

	p_collisions	off
	p_groundobj	on




.loop	p_import	vx,player1_vx
	p_import	vz,player1_vz
	p_neg	vx
	p_neg	vz
	p_copyplayerrots
	p_set	rotx,deg90
	p_set	rotz,deg180
	p_goto		.loop

	p_end

;----------------------------------------------------------------------------------

	start_path	es0_clip

	p_set		rotx,deg90
	p_set		worldz,-(200<<last_ka_scale)

	p_collisions	off
	p_set		shape,clipshape

	p_groundobj	on

	p_wait		50h

	p_set		worldz,-(150<<last_ka_scale)

	p_set	vz,60

	p_trigger	.4,2

	p_wait	15
	p_rtrigger	.always,always
	p_wait	15
	p_Qspawn	explosion2,cds_explosions,1,6
	p_wait	10
	p_Qspawn	explosion2,cds_explosions,1,7


.cut1	p_ifnotdemo	es0_cut1,.cut2
	p_goto		.cut1


.cut2	p_setvel	0

	p_trigger	.4,off
	p_trigger	.always,off

	p_set	worldy,2418h
	p_set	worldz,1000
	p_set	rotx,0

.cut2_0	p_ifnotdemo	es0_cut2,.remove
	p_goto		.cut2_0

.remove	p_remove



.always	p_gosub	prou_ramdomexpsound
	p_return


.4	p_Qspawn	explosion2,cds_explode,1,1
	p_export	gword1,vz

	p_become
	p_import	vz,gword1
	p_addrandom	worldx,255
	p_addrandom	worldy,255
;	p_add		worldx,-128
;	p_add		worldy,-128
	p_set		vy,-30
	p_unbecome

	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	es0_suisei

	p_set	worldy,50<<extra1_scale

	p_collisions	off

	p_trigger	es0_cut2_always,always
	p_trigger	Pcds_d_sen_parts_circle.depthofs4,always

	p_spawn		0,-50<<extra1_scale,0,0,0,0,extra1_0,es0_suisei_part,10,10,childno_es0_suisei
	p_spawn		0,50<<extra1_scale,0,0,0,0,extra1_2,es0_suisei_part0,10,10,childno_es0_suisei
	p_spawn		0,20<<extra1_scale,0,0,0,0,extra1_3,es0_suisei_part1,10,10,childno_es0_suisei

	p_rtrigger	.always,always

	p_set	rotx,-8
	p_set	roty,-64

	p_set	vy,20

	p_wait	4bh

	p_groundobj	on

	p_trigger	.always,off
	p_rtrigger	.always3,always

	p_wait	5ch-4bh

	p_set	vy,60

	p_trigger	.always2,always,50

	p_do	20
	p_circlewindowpos
	p_next

	p_wait	50

	p_Qspawn	nullshape,es0_arwing2,1,7

	p_set		clip,plane_BOSS

	p_wait	20h

	p_rtrigger	.always4,always

	p_end


.always4	p_add	rotx,-2
.always2	p_add	rotx,1
	p_return






.always	p_andframegoto	15,.flash
	p_igoto		.always3
.flash	p_randomgoto	.always3

.always3	p_add	roty,1
	p_return

;-----------------------------------------------------------------------------------

	start_path	es0_suisei_part

	p_demoshape
	p_trigger	Pcds_chika.exp,always,0f8h
	p_igoto		Pes0_suisei_part0.enter

	start_path	es0_suisei_part1
	p_set		pword1,4bh
	p_igoto		Pes0_suisei_part0.enter

	start_path	es0_suisei_part0
	p_set		pword1,40h

.enter2	LOCAL

	p_rtrigger	.g,always

.enter	LOCAL
	p_collisions	off
	p_trigger	es0_cut2_always,always
	p_trigger	Pcds_d_sen_parts_circle.depthofs4,always
	p_wait	130h-es0_cut1time
	p_set	clip,plane_BOSS
	p_end

.g	p_dec	pword1
	p_ifnotzero	pword1,.g0
	p_groundobj	on
.g0	p_return

;-----------------------------------------------------------------------------------
;	start_path	es0_zako
;
;	p_collisions	off
;
;	p_trigger	.4,4
;
;	p_setvel	90
;
;	p_end
;
;.4	p_Qspawn	explosion2,cds_explode,1,1
;	p_return
;-----------------------------------------------------------------------------------
	start_path	es0_arwing2

	p_set		depthoffset,4
	p_collisions	off

	p_copyviewpos_demo

	p_gosub	Pes0_cam.pos

;	p_add		worldx,-350
;	p_add		worldz,-450
;	p_add		worldy,1700+300

	p_alwaysgenvecs	on

	p_playershape

;	p_set	rotx,0
;	p_set	rotz,0

	p_set	ptr,viewblk1

;	p_set	roty,06dh
;	p_set	rotx,-15

	p_setvel	60

	p_wait	5

	p_trigger	es0_cut2_always,always
	p_rtrigger	.always,always

	p_set	childroty,-7

	p_wait	20

	p_do	10
	p_chase	childroty,0
	p_next

	p_wait	6

	p_accel	50,2

	p_trigger	.rx0,always,50

	p_wait	40

	p_remove


.always	p_add	roty,childroty
	p_return


.rx0	p_chase	childroty,0
	p_add	rotx,-3
	p_return
;-----------------------------------------------------------------------------------

	start_path	es0_arwing2_friend2	; friend

	p_trigger	es0_cut2_always,always

	p_set	depthoffset,3

	p_collisions	off

;	p_add	worldx,-50+20
;	p_add	worldy,-200
;	p_add	worldz,-100-20

	p_gosub	Pes0_cam.pos

;	p_print	worldx,h,kawagoe
;	p_print	worldy,h,kawagoe
;	p_print	worldz,h,kawagoe

;	p_set	rotx,75
;	p_set	roty,deg180+8+8


	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.remove
	P_GOSUB		set_friend_shape


	p_alwaysgenvecs	on

	p_setvel	60

	p_accel	20,1

	p_wait	5

	P_SOUNDEFTDISTPOS	ob_throughobst_l

	p_do	30
	p_add	rotx,-2
	p_add	roty,2
	p_next

	p_do	32
	p_add	roty,4
	p_next

	p_accel	60,1

	p_do	25
	p_add	roty,1
	p_add	rotx,-3
	p_next

	p_do	14
	p_add	rotx,-2
	p_add	roty,-4
	p_next

	p_do	14
	p_add	rotx,-4
	p_add	roty,-5
	p_next


	p_do	10
	p_add	rotx,-1
	p_next

;	p_remove
;	p_do	100
;	p_add	rotx,-4
;	p_add	roty,-2
;	p_next
;	p_end

.remove	p_remove



;-----------------------------------------------------------------------------------
	start_path	es0_fox5	; friend

	p_gosub	Pes0_cam.pos

;	p_add	worldx,-300
;	p_add	worldy,-50
;	p_add	worldz,-400
;
;	p_print	worldx,h,kawagoe
;	p_print	worldy,h,kawagoe
;	p_print	worldz,h,kawagoe
;	p_print	rotx,h,kawagoe
;	p_print	roty,h,kawagoe
;	p_print	rotz,h,kawagoe

	p_set	count,60-5

	p_spawn	0,0,0,0,0,0,nullshape,es0_fx5,1,1,1

	p_igoto		Pes0_arwing3.in

;------------
	start_path	es0_fx5

	p_collisions	off


	p_wait	46h

;************
	p_setvar	b,tpx,3
	p_gosub	prou_friendNo_shape
	P_SOUND		p2_demo_arwing2
;************

	p_wait	0b5h-46h

	p_set	childx,-300-200
	p_set	childz,-800
	p_set	childy,-50

	p_setvel	20

	p_end

;-----------------------------------------------------------------------------------
	start_path	es0_fox4	; friend

	p_set	count,60-5

	p_gosub	Pes0_cam.pos

;	p_add	worldx,-100	;230
;	p_add	worldy,200	;-50
;	p_add	worldz,400


	p_spawn	0,0,0,0,0,0,nullshape,es0_fx4,1,1,1

;	p_print	worldx,h,kawagoe
;	p_print	worldy,h,kawagoe
;	p_print	worldz,h,kawagoe
;
;	p_print	rotx,h,kawagoe
;	p_print	roty,h,kawagoe
;	p_print	rotz,h,kawagoe
;

	p_igoto		Pes0_arwing3.in


;------------
	start_path	es0_fx4

	p_collisions	off

	p_wait	46h

;************
	p_setvar	b,tpx,2
	p_gosub	prou_friendNo_shape
	P_SOUND		p2_demo_arwing2
;************

	p_wait	9ah-46h

	p_accel	20,2

	p_wait	30

	p_accel	0,2

	p_end

;-----------------------------------------------------------------------------------
	start_path	es0_fox3	; friend

	p_gosub	Pes0_cam.pos

;	p_add	worldx,130
;	p_add	worldy,-50
;	p_add	worldz,-230

	p_set	count,60-5

	p_spawn	0,0,-300,0,0,0,nullshape,es0_fx3,1,1,1

	p_igoto	Pes0_arwing3.in


;------------
	start_path	es0_fx3

	p_collisions	off

	p_wait	46h

;************
	p_setvar	b,tpx,1
	p_gosub	prou_friendNo_shape
	P_SOUND		p2_demo_arwing2

;************

	p_do	40
	p_add	childz,300/40
	p_next

	p_end

;-----------------------------------------------------------------------------------
	start_path	es0_fox2	; friend

	p_gosub	Pes0_cam.pos

;	p_add	worldx,-130
;	p_add	worldy,-230
;	p_add	worldz,-150

	p_set	count,60-5

	p_spawn	0,0,-300,0,0,0,nullshape,es0_fx2,1,1,1
	p_igoto	Pes0_arwing3.in



;------------
	start_path	es0_fx2

	p_collisions	off

	p_wait	46h

;************
	p_setvar	b,tpx,0
	p_gosub	prou_friendNo_shape
	P_SOUND		p2_demo_arwing2

;************

	p_do	40
	p_add	childz,300/40
	p_next

	p_end

;-----------------------------------------------------------------------
	start_path	es0_fox1	; partner

	p_gosub	Pes0_cam.pos

	p_set	count,60-5

	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.remove
	P_GOSUB		set_friend_shape
	p_trigger	prou_player2dmg,always

	p_igoto	Pes0_arwing3.in

.remove	p_remove


;------------
	start_path	es0_arwing3

	p_playershape
	p_trigger	prou_playerdmg,always

	p_set	count,60
	p_demoshape

	P_SOUND		p2_demo_arwing2

.in	LOCAL

	p_gosub	Pes0_cam.pos

	p_collisions	off

	p_alwaysgenvecs	on

	p_rtrigger	.always,always

	p_setvel	20

	p_wait	count

	p_do	4
	p_chase	rotz,70
	p_add	roty,2
	p_next


	p_zero	pbyte1

	p_do	17h
	p_chase	rotx,0
	p_add	roty,4
	p_chase	rotz,70
	p_next


	p_wait	2

;.enter	LOCAL

	p_do	3dh
	p_chase	rotx,0
	p_add	roty,2
	p_chase	rotz,30
	p_next

	p_do	10h
	p_add	roty,4
	p_chase	rotz,50
	p_next

	p_do	10h
	p_chase	rotz,0
	p_add	rotx,-2
	p_next

.cut3	p_ifnotdemo	es0_cut3,.cut4
	p_goto		.cut3

.cut4	p_remove


.always	p_add	rotx,childrotx
	p_add	roty,childroty
	p_add	rotz,childrotz
	p_chase	childrotz,0
	p_return



;------------

	start_path	es0_arwing4_f_s	; friend0

	P_SOUND		p2_demo_arwing2	;GAKKI

	start_path	es0_arwing4_f	; friend0

	p_set		pbyte1,ap
	p_add		pbyte1,-2
	p_export	tpx,pbyte1

	p_gosub		prou_friendNo_shape
	p_igoto		Pes0_arwing4.enter

;------------

	start_path	es0_arwing4_p	; partner

	P_SOUND		p2_demo_arwing2

	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.remove
	P_GOSUB		set_friend_shape
	p_trigger	prou_player2dmg,always

	p_igoto		Pes0_arwing4.enter

.remove	p_remove

;------------
	start_path	es0_arwing4

	p_playershape
	p_trigger	prou_playerdmg,always

.enter	LOCAL

	p_set		clip,plane_BOSS

	p_collisions	off

	p_setvel	20
	p_alwaysgenvecs	on

	p_index	worldx,es0_arwing4.x,ap


	p_index	childy,es0_arwing4.y,ap
	p_add	worldy,childy
	p_index	childz,es0_arwing4.z,ap
	p_add	worldz,childz

	p_index	rotx,es0_arwing4.rx,ap
	p_index	roty,es0_arwing4.ry,ap
	p_index	rotz,es0_arwing4.rz,ap


	p_index	count,es0_arwing4.count0,ap
	p_wait	count


	p_ifnotzero	ap,.nokiran
	p_spawn		5,-10,-10,0,deg180,0,kirans,es0_kiran,1,1,1
.nokiran

	p_index	count,es0_arwing4.count1,ap
	p_wait	count

	p_index	count,es0_arwing4.count2,ap

	p_do	count
	p_chase	roty,deg180
	p_add	rotx,1
	p_chase	rotz,0
	p_next

	p_remove

;	p_accel	10,2
;
;	p_wait	count
;	p_remove



;------------
	start_path	es0_kiran

	p_collisions	off

	p_do	6
	p_addanim	1,6
	p_next

	p_remove


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	es0_base

	p_collisions	off

	p_gosub	Pes0_cam.pos	; set AP = 29

;	p_set	worldx,03beh+500+500
;	p_set	worldy,0f875h-800-500-800
;	p_set	worldz,0f9ceh-1000-500
;
;	p_set	rotx,0
;	p_set	roty,20
;	p_set	rotz,0

	p_gosub	prou_makebase_h
	p_spawn	55<<base_scale,15<<base_scale,80<<base_scale,00,0,0,base_h,scramble_base_h_s2,10,35,childno_es0_base_hr
	p_spawn	-55<<base_scale,15<<base_scale,80<<base_scale,00,0,0,base_h1,scramble_base_h2,10,40,childno_es0_base_hl


.cut3	p_ifnotdemo	es0_cut3,.cut4
	p_goto		.cut3

.cut4	p_gosub	prou_posrot0

	p_spawn	0,0,80<<base_scale,64,0,0,clipshape,scramble_clip,10,10,childno_scramble_clip

	p_spawn	0,15<<base_scale,40<<base_scale,0,0,0,nullshape,es0_watch,1,1,childno_es0_watch

	p_wait	0b0h+10


	p_trigger	.rx,16,90

	p_gosub	prou_remove_hatch

	p_wait	10

	p_trigger	.ry,always,80

	p_wait	80

	p_becomechild	childno_base_t
	p_groundobj	off
	p_unbecome

	p_accel	5,1

	p_Qspawn	nullshape,es0_hypers,1,1

	p_wait	50

	p_quadvecs	on
	p_accel		120,120

	p_gosub	Plogo_base.warp

	p_wait	20

	P_CIRCLEWINDOW	16,warp

	p_remove


.rx	p_dec	rotx
	p_return



.ry	p_chase	vy,-3
	p_chase	rotz,-5
	p_add	roty,-1
	p_return




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	es0_hypers

	p_collisions	off

	p_trigger	.hyper,2	;,50

	p_set	worldx,0205h<<1
	p_set	worldy,-13ah-80h
	p_set	worldz,-(0cfh<<1)+100h

	p_wait	60

	p_end


.hyper	p_qspawn	hyper,es0_hyper,1,1
	p_return





	start_path	es0_hyper

	p_groundobj	on

	p_collisions	off

	p_rtrigger	.z,always

	p_setrandom	rotz
	p_addrandom	worldx,511
	p_addrandom	worldy,511

	p_setvel	-127

	p_wait	10

	p_remove


.z	LOCAL
	p_add	rotz,ap
	p_return


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-----------------------------------------------------------------------------------
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	es0_gal1
	start_path	es0_fox
	p_collisions	off
	p_alwaysgenvecs	on
	p_neg	roty
	p_index	pword1,es0_starfox.x,ap
	p_add	worldx,pword1
	p_index	pword1,es0_starfox.y,ap
	p_add	worldy,pword1
	p_index	pword1,es0_starfox.z,ap
	p_add	worldz,pword1
	p_index	pbyte1,es0_starfox.rx,ap
	p_add	rotx,pbyte1
	p_index	pbyte1,es0_starfox.ry,ap
	p_add	roty,pbyte1
	p_index	pbyte1,es0_starfox.rz,ap
	p_add	rotz,pbyte1
	p_index	vel,es0_starfox.vel,ap
	p_index	count,es0_starfox.count,ap
	p_wait	count
	p_index	count,es0_starfox.count1,ap
	p_do	count
	p_chase	rotx,0
	p_add	roty,2
	p_chase	rotz,30
	p_next
	p_set	childroty,roty
	p_trigger	.always,always
	p_index	count,es0_starfox.count2,ap
	p_do	count
	p_chase	rotz,50
	p_next
	p_index	count,es0_starfox.count3,ap
	p_do	count
	p_chase	rotz,0
	p_next
	p_accel	30,2
	p_do	10h
	p_add	rotx,-2
	p_next
	p_end
.always	p_chase	roty,childroty
	p_chase	childroty,09eh
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC
;-----------------------------------------------------------------------------------
;	start_path	es0_suisei_explode
;	p_collisions	off
;	p_trigger	.exp,always
;	p_set		vy,es0_suisei_vy
;	p_end
;
;
;.exp	p_add	roty,16
;	p_andframegoto	1,.exp2
;	p_randomgoto	.exp2
;	p_spawn	0,0,80<<extra1_scale,0,0,0,explosion4,cds_explode,1,2
;	p_randomgoto	.exp2
;	p_become
;	p_set	shape,explosion3
;	p_unbecome
;.exp2	p_return
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------------
;
;	start_path	es0_base
;
;	p_collisions	off
;
;	p_alwaysgenvecs	on
;
;	p_setvel	20
;
;	p_spawn		0,-90<<bases_scale,-25<<bases_scale,0,0,0,base1s_t,base_parts,10,10,childno_base_t
;	p_spawn		0,100<<bases_scale,-50<<bases_scale,0,0,0,base1s_u,base_parts,10,10,childno_base_u
;	p_spawn		-95<<bases_scale,0,-75<<bases_scale,0,0,0,base1s_rb,base_parts,10,10,childno_base_rb
;	p_spawn		95<<bases_scale,0,-75<<bases_scale,0,0,0,base1s_lb,base_parts,10,10,childno_base_lb
;	p_spawn		55<<bases_scale,0,45<<bases_scale,0,0,0,base1s_lh,base_parts,10,10,childno_base_lh
;	p_spawn		-55<<bases_scale,0,45<<bases_scale,0,0,0,base1s_rh,base_parts,10,10,childno_base_rh
;
;	p_wait	40
;
;
;	p_do	40
;	p_add	roty,-1
;	p_next
;
;
;	p_end
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------------
es0_cut1_always

	p_ifnotdemo	es0_cut1,demoobj_remove_force

	p_return


es0_cut2_always

	p_ifnotdemo	es0_cut2,demoobj_remove_force

	p_return


es0_cut3_always

	p_ifnotdemo	es0_cut3,demoobj_remove_force

	p_return
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	DESTRUCTION DEMO-CORE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	destruct_coredirector

childno_dc	equ	1
dc_cut1	equ	1

	P_SET	AREA,-1

	p_setdemo	dc_cut1

	P_SOUNDEFFECT	ob_core_explode

	p_collisions	off

	p_set		worldy,-160
	p_import	worldx,corex
	p_import	worldz,corez

	p_trigger	.hahen,4
	p_rtrigger	.exp,always

	p_zero		rotx
	p_zero		roty
	p_zero		rotz

	p_Qspawn	nullshape,dc_cam,1,1
	p_Qspawn	nullshape,dc_watch,1,1

;off!	p_set		shape,kaku_0_c

	p_Qspawn	nullshape,e_nocol_s_off,1,1
;off!	p_Qspawn	kaku_0_0,e_nocol_s_off,1,1
	p_become
	p_set		worldy,0
	p_trigger	Pcds_d_sen_parts_circle.depthofs4,always
	p_unbecome

	p_Qspawn	nullshape,dc_arwing,1,1

	p_end


.hahen
	p_Qspawn	hahen,dc_hahen,1,1
	p_gosub		.pos
	p_become
	p_set		worldy,-300
	p_unbecome

.nohahen	p_return


;************
.exp	LOCAL

	p_randomgoto	.expset
	p_return


.expset
	p_Qspawn	explosion3,cds_explode,1,1
	p_gosub		.pos
	p_return






.pos	p_become


;	p_setrandom	childx,1023
;	p_setrandom	childz,1023
;	p_add		childx,-512
;	p_add		childz,-512
;	p_add	worldx,childx
;	p_add	worldz,childz


	p_addrandom	worldx,1023
	p_addrandom	worldz,1023

	p_andframegoto	4,.up
	p_set		worldy,-150
	p_unbecome

.noexp	p_return

.up	p_set		worldy,150
	p_unbecome
	p_return


;---------------------------------------------------------------------------------

	start_path	dc_hahen

	p_collisions	off

	p_set	vy,15

	p_wait	10

	p_remove

;---------------------------------------------------------------------------------

	start_path	dc_watch

	P_SET	AREA,-1

	p_rtrigger	.always,always
	p_trigger	.4,4

	p_add		worldz,200

	p_collisions	off

	p_demoshape

	p_set	vx,5

	p_wait	30h

	p_set	vx,-40

	p_set	vz,-10

	p_wait	10

	p_set	vx,5

	p_wait	50h-30h-10

	p_set	vx,0

	p_end


.always	p_neg	childy
	p_add	worldy,childy
	p_chase	childy,0
	p_return

.4	p_randomgoto	.no
	p_set		childy,40
.no	p_return

;---------------------------------------------------------------------------------

	start_path	dc_cam

	P_SET	AREA,-1

	p_collisions	off

	p_add	worldz,400
	p_add	worldx,-50

	p_copypos2view	1,immediate
	p_campandemoshape	1,1,immediate
	p_rtrigger		.always,always

	p_screenflash

	p_do	20
	p_add	worldz,10
	p_next

	p_screenflash

	p_wait	38h-20

	p_set	vz,-10
	p_set	vx,-5

	p_end


.always	p_copypos2view		1,immediate
	p_campandemoshape	1,1

	p_return


;-----------------------------------------------------------------------------

	start_path	dc_arwing

	P_SET	AREA,-1

;************
	p_setvar	b,sdport1,%100
;************

	p_playershape
	p_trigger	prou_playerdmg,always

	p_add		worldz,-1000-50
	p_set		worldy,0

	p_set		roty,deg270+40
	p_set		rotz,40
	p_set		rotx,0

	p_set		pbyte1,0

	p_collisions	off

	p_setvel	40

	p_alwaysgenvecs	on

	p_do	20
	p_chase	rotx,-5
	p_next

	p_rtrigger	.always,always

	p_wait		14

	p_trigger	.always,off
	p_rtrigger	.always2,always

	p_do	3
	p_add	pbyte1,1
;	p_chase	rotx,-10
	p_next

	p_do	15
;	p_chase	rotx,-10
	p_next

	p_set	pbyte1,0

	p_do	20
	p_chase	roty,deg180+5
	p_chase	rotx,5
	p_next


	p_end


.always	p_chase	roty,20
	p_return

.always2	p_add	roty,pbyte1
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CLEAR DEMO-SENKAN(D-SEN)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	clear_kaiteidirector
	p_setvar	w,player1_horizon_offset,SCR6_Hofs
	p_setvar	b,sdport1,0
	p_igoto		Pclear_d_sendirector.enter

	start_path	clear_chikadirector
	p_setvar	w,player1_horizon_offset,SCR2_Hofs
	p_igoto		Pclear_d_sendirector.enter

	start_path	clear_d_sendirector
	p_setvar	w,player1_horizon_offset,SCR4_Hofs
.enter	LOCAL


;==================================================================================

childno_cds	equ	1

cds_time0		equ	34h

cds_scoretime	equ	20h

cds_cut1		equ	2


	p_gosub	prou_posrot0

	p_setdemo	cds_cut1

	p_collisions	off

	p_import	pbyte1,demoNo
	p_ifnotsame	pbyte1,demo_clear_d_sen,.chika

	P_SOUNDPLACE	SPACE

	p_Qspawn	nullshape,cds_d_sen,1,1
	p_igoto		.mkaw

.chika	p_Qspawn	nullshape,cds_chika,1,1

	p_Qspawn	m_iwa_1,cds_iwa,1,20
	p_Qspawn	m_iwa_0,cds_iwa,1,21

	P_SOUNDPLACE	GROUND

.aw	p_ifnotsame	pbyte1,demo_clear_kaitei,.mkaw
	p_Qspawn	nullshape,cds_robo,1,1
	p_igoto		.cam

.mkaw	p_Qspawn	nullshape,cds_arwing,1,1

.cam	p_Qspawn	nullshape,cds_cam,1,1

	p_end

;------------------------------------------------------------------------------

	start_path	cds_iwa

	p_groundobj	on
	p_gosub	Pes0_cam.pos

	p_end

;------------------------------------------------------------------------------

	start_path	cds_piece

	p_end


.exp	LOCAL

	p_Qspawn	explosion3,cds_explode,1,12

	p_become
	p_addrandom	worldx,511
	p_addrandom	worldy,511
	p_addrandom	worldz,511
	p_unbecome

	p_return


.always	p_add	rotx,5
	p_add	roty,4
	p_add	rotz,3
	p_return

;------------------------------------------------------------------------------

	start_path	cds_explosions

	p_index		rotx,cds_explosions.rx,ap
	p_index		roty,cds_explosions.ry,ap

	p_index		pword1,cds_explosions.z,ap
	p_add		worldz,pword1

	p_index		pbyte1,cds_explosions.count,ap
	p_index		vel,cds_explosions.vel,ap

	p_collisions	off

	p_quadvecs	on

	p_alwaysgenvecs	on

	p_Rtrigger	.exp,2	;RRR

	p_set		pbyte2,13

	p_iflarger	pbyte1,pbyte2,.nodec
	p_accel		0,8


.nodec	p_wait		pbyte1

	p_Qspawn	explosion3,cds_explode,1,22
	p_gosub		.spr

	p_remove



.exp	LOCAL

	p_Qspawn	explosion3,cds_explode_s,1,17
	p_gosub		.spr
	p_return

.spr	p_export	gword1,shape
	p_become
	p_import	shape,gword1
	p_unbecome
	p_return

;------------

	start_path	cds_explode_s

	p_set		pbyte1,-1
	p_igoto		Pcds_explode.enter


	start_path	cds_explode

	p_zero		pbyte1

;ap : size

.enter	LOCAL

	p_sprite	0,0
	p_set		tx,ap

	p_collisions	off

	p_do	8
	P_ADDCOLANIM	1,8
	p_add	tx,pbyte1
	p_next
	p_remove

;------------------------------------------------------------------------------

	start_path	cds_cam

	p_collisions	off


	p_import	pbyte1,demoNo
	p_ifnotsame	pbyte1,demo_clear_kaitei,.normal

	p_add	worldx,-225+30
	p_add	worldy,-430
	p_add	worldz,7200-50

	p_trigger	.always4,always,69h
	p_rtrigger	.always5,always

	p_wait	5

	p_Qspawn	nullshape,cds_robo_friend,1,1

	p_end


.normal

	p_add	worldx,-225
	p_add	worldy,-1075+600
	p_add	worldz,7375

	p_spawn		-80,25,-200,0,0,0,b_robo,e_nocol_s_off,1,1,childno_cds
	p_become
	p_invisible	on
	p_unbecome

	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate

	p_wait	1

	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate

	p_rtrigger	.always,always

	p_wait	4dh-4

	p_set	vy,-8

	p_wait	4

	p_trigger	.always,off
	p_rtrigger	.always2,always

	p_wait	3+10+2

	p_do	5
	p_add	vx,-1
	p_next

;	p_wait		10



	p_import	pbyte1,demoNo
	p_ifsame	pbyte1,demo_clear_chika,.nopiece
; test	p_Qspawn	d_sen_4,cds_piece,30,0
.nopiece

	p_wait	77h-5-3-4-4ch-10

	p_trigger	.always2,off
	p_rtrigger	.always3,always

	p_wait	7fh-77h

	p_set	vx,-7
	p_set	vy,-1ch
	p_set	vz,26h

	p_end

.always2	p_chase	vy,0ffe6h
	p_chase	vz,027h

.always	p_copypos2view		1,immediate
	p_campandemoshape	1,3
	p_return

.always3	p_copypos2view		1,immediate
	p_return


.always4	; kaitei

	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate

	p_return

.always5	; kaitei

	p_campandemoshape	1,1
	p_return


;.always5	; kaitei
;	p_campandemoshape	1,1
;	p_return
;------------------------------------------------------------------------------

	start_path	cds_chika

	p_Rtrigger	.exp,always	;RRR

	p_groundobj	on

	p_collisions	off

	p_set	shape,chika_k1

	p_add	worldy,0
	p_add	worldz,6000

	p_wait		8
	p_screenflash
	p_Qspawn	explosion2,cds_explosions,1,4

	p_wait		8
	p_Qspawn	explosion2,cds_explosions,1,5

	p_wait	30h
	p_screenflash
	p_wait	8h+2

	P_SOUNDEFFECT	bs_base_explode

	p_circlewindow	4,big

	p_trigger	.exp,off

	p_wait	40

	p_remove






.exp	LOCAL

	p_andframegoto	1,.bom
	p_return




.bom
	p_gosub	prou_ramdomexpsound

	p_Qspawn	explosion4,cds_explode,1,2

	p_become
	p_andframegoto	4,.b
	p_set		shape,explosion3
.b
	p_addrandom	worldx,511
	p_addrandom	worldy,255
	p_addrandom	worldz,511
	p_add		worldy,-256

	p_unbecome

	p_return

;------------------------------------------------------------------------------

	start_path	cds_d_sen

	p_rtrigger	.exp,always

	p_collisions	off

	p_set	depthoffset,4
	p_add	worldz,2000
	p_set	rotz,10

	p_gosub	prou_d_sen

	p_set	vy,10

	p_wait	10

	p_screenflash

	p_spawn	0,0,3000,0,0,0,nullshape,cds_explode,1,18,childno_cds

	p_wait	10

	p_screenflash
	p_Qspawn	explosion3,cds_explosions,1,0

	p_wait	10

	p_Qspawn	explosion3,cds_explosions,1,1

	p_set	vx,40
	p_set	vy,20
	p_set	vz,-10
	p_rtrigger	.2,always

	p_wait	20

	p_Qspawn	explosion3,cds_explosions,1,2

	p_wait	12

	p_screenflash
	p_wait	8

	p_circlewindow	4,big

	p_trigger	.exp,off

	P_SOUNDEFFECT	bs_base_explode

	p_Qspawn	explosion3,cds_explosions,1,3

	p_do		30
	p_andframegoto	3,.bom_l
	p_igoto		.nobom
.bom_l
	p_Qspawn	explosion4,cds_explode,1,32
.nobom	p_next
	p_remove


.2	p_inc	rotz
	p_return


.exp	LOCAL
	p_andframegoto	1,.bom
	p_return

.bom	p_randomgoto		.SE
	p_randomgoto		.SE2
.SE1	P_SOUNDEFTDISTPOS	en_explode_s
	p_igoto			.SE
.SE2	P_SOUNDEFTDISTPOS	en_explode_demo
.SE

	p_Qspawn	explosion4,cds_explode,1,18
	p_andframegoto	4,.b
	p_become
	p_set		shape,explosion3
	p_unbecome

.b	p_become

	p_addrandom	worldx,2047
	p_setrandom	childy,511
	p_setrandom	childz,2047
	p_neg		childz
	p_add		worldy,childy
	p_add		worldz,childz
	p_unbecome
	p_return





	start_path	cds_d_sen_parts_circle
	p_rtrigger	.depthofs4,always
	p_set		depthoffset,4

	p_igoto		Pcds_d_sen_parts

.depthofs4	LOCAL

	p_randomgoto	.4
	p_randomgoto	.2

.4	p_ifsame	depthoffset,4,.ret
	p_add		depthoffset,1
.ret	p_return

.2	p_set		depthoffset,2
	p_return





	start_path	cds_d_sen_parts
	p_groundobj	on
	p_set		depthoffset,4
	p_collisions	off
	p_end

;-----------------------------------------------------------------------------

	start_path	cds_watch

	p_collisions	off

	p_demoshape

	p_wait	58h

	p_do	20
	p_add	childz,200/20
	p_next

	p_end

;-----------------------------------------------------------------------------

	start_path	cds_arwing

;************
	p_setvar	b,sdport1,%100
;************

	p_spawn	0,0,0,0,0,0,nullshape,cds_watch,1,1,childno_cds

	p_collisions	off

	p_add		worldz,4640+500

	p_wait		8	; wait fade

	p_playershape
	p_trigger	prou_playerdmg,always
	p_alwaysgenvecs	on

	p_setvel	50

	p_set	pword1,viewblk1

	p_wait		28

	p_findshape	b_robo

	p_do	cds_time0-28-8+2
	p_faceshape
;	p_faceshape
	p_next

;	p_wait	2

;************
	p_setvar	b,sdport1,%1000
;************

	p_do	20+2
	p_add	rotx,-10
	p_add	worldy,-2
	p_next

;************
	p_setvar	b,sdport1,%100
;************
	p_do	7
	p_chase	rotx,-45
	p_chase	roty,5
	p_add	worldy,-2
	p_next

	p_Qspawn	nullshape,cds_friend,1,1

	p_do	40
	p_chase	roty,0
	p_next



; dush!
	p_accel		50,2
	p_setvel	35

	p_do	6
	p_chase	roty,18
	p_next

	p_gosub	.dush

;************
	p_setvar	b,sdport1,%11000
;************
	p_wait		100
;************
	p_setvar	b,sdport1,0
;************

	p_end



.dush	LOCAL
	p_accel		0,0
	p_alwaysgenvecs	off
	p_setvel	100

	p_gosub		prou_demoboost
;	p_spawn		0,0,-20,0,0,0,boost,demoboost,1,1,childno_cds

	P_SOUNDEFFECT	boost
	p_return

;----------------------------------------------------------------------------------

	start_path	cds_robo_friend

	p_collisions	off

	p_add	worldx,-200
	p_add	worldz,0
	p_add	worldy,50
	p_set	rotx,-32
	p_set	roty,20

	p_wait	10

	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.remove
	P_GOSUB		set_friend_shape
	p_set		pword1,shape

; store trans shape


;;;;;	P_SOUNDEFFECT	transrobo2arwing

	P_START65816
	jsl	cds_robo00F_path_l
	P_END65816
	p_set		childx,shape
	P_START65816
	jsl	cds_robo01F_path_l
	P_END65816
	p_set		childy,shape

;;;;;	P_SOUNDEFFECT	transrobo2arwingend

	p_gosub	prou_friendshape_rb

	p_spawn	30,0,0,50,0,0,nullshape,cds_ashi_friend_r,1,1,childno_kaitei
	p_spawn	-30,0,0,50,0,0,nullshape,cds_ashi_friend_l,1,1,childno_kaitei

	p_wait	25+20+30

	p_igoto	Pcds_robo.enter

.remove	p_remove

;------------
	start_path	cds_ashi_friend_r

	P_START65816
	jsl	SASHI_friend_R_path_l
	P_END65816
	p_wait	1
	p_igoto	Pkaitei_ashi_r.enter


	start_path	cds_ashi_friend_l

	P_START65816
	jsl	SASHI_friend_L_path_l
	P_END65816
	p_wait	1
	p_igoto	Pkaitei_ashi_r.enter

;----------------------------------------------------------------------------------

	start_path	cds_robo

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºCHILDX,CHILDY,PWORD1º <--- tsuketteru!!!
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

	p_demoshape
	p_collisions	off
	p_add		worldz,4640+500+1000-100

	p_set	vz,10
	p_wait	10

; store shape

	p_trigger	prou_playerdmg,always
	p_playershape
	p_set	pword1,shape

; store trans shape


	P_START65816
	jsl	cds_robo00_path_l
	P_END65816
	p_set		childx,shape
	P_START65816
	jsl	cds_robo01_path_l
	P_END65816
	p_set		childy,shape



	p_gosub	Pkaitei_robo.init

	p_rtrigger	.always,always

	p_wait	25

	p_trigger	.rx,always,36

	p_do	20
	p_add	roty,1
	p_next

	p_wait	30

	p_trigger	.always,off

.enter	LOCAL

	p_alwaysgenvecs	off

	p_accel		0,0
	p_setvel	20

	p_div2	vy
	p_set	childrotx,32
	p_rtrigger	.addrx,always
	p_wait	8+1
	p_trigger	.addrx,off
	p_rtrigger	.addrx2,always

	p_do	10h
	p_add	roty,-2
	p_next

	P_SOUNDEFFECT	transrobo2arwing

	p_set	shape,childx

;	P_START65816
;	jsl	cds_robo00_path_l
;	P_END65816

	p_setanim	0

	p_do	7
	p_addanim	1,7
	p_next


	p_set	shape,childy

;	P_START65816
;	jsl	cds_robo01_path_l
;	P_END65816

	p_setanim	0

	p_do	7
	p_addanim	1,7
	p_next

	P_SOUNDEFFECT	transrobo2arwingend

	p_alwaysgenvecs	on

	p_set	shape,pword1

	p_accel	50,4	;setvel	50

	p_do	8
	p_add	rotx,-2
	p_next

	p_trigger	Pkaitei_robo.bubble,off

	p_do	25-8
	p_add	rotx,-2
	p_next

	p_end



.always	LOCAL
	p_addanim	1,16
	p_ifsame	animframe,128+6,.accl
	p_accel		0,2
	p_return
.accl	p_setvel	35
	p_return

.addrx2	p_chase	childrotx,0

	p_do	2
	p_chase	vx,0
	p_chase	vy,0
	p_chase	vz,0
	p_inext

.addrx	p_add	rotx,childrotx
	p_return

.rx	p_dec	rotx
	p_return

;-----------------------------------------------------------------------------
	start_path	cds_friend

	p_trigger	.always,always,40
	p_rtrigger	.always2,always

	P_SOUND	p2_demo_arwing

	p_alwaysgenvecs	on
	p_collisions	off

	p_setvel	45

	p_add	worldz,400-200
	p_add	worldy,-150+50+50
	p_add	worldx,160

	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.remove
	P_GOSUB		set_friend_shape

	p_trigger	prou_player2dmg,always

	p_do	40
	p_chase	roty,0
	p_next

	p_wait	10

	p_accel		50,2
	p_setvel	40

	p_do	5
	p_chase	roty,18
	p_next

	p_gosub	Pcds_arwing.dush

	p_end

.remove	LOCAL
	p_remove



.always	p_set	childx,-5
	p_set	rotz,10
	p_return


.always2	p_add	worldx,childx
	p_chase	childx,0
	p_chase	rotz,0
	p_return

;-----------------------------------------------------------------------------
;
;	start_path	cds_friend0
;
;	P_SOUND	p2_demo_arwing
;
;	p_alwaysgenvecs	on
;	p_collisions	off
;
;	p_setvel	30
;
;	p_add	worldz,-600
;	p_add	worldy,-400
;	p_add	worldx,500
;	p_set	roty,40-5-5
;	p_set	rotx,28
;	p_set	rotz,-30
;
;	P_IMPORT	pbyte1,Player_friend
;	P_IFSAME	pbyte1,-1,Pcds_friend.remove
;
;	P_GOSUB		set_friend_shape
;
;	p_wait	8
;
;	p_do	5
;	p_chase	rotz,-20
;	p_add	rotx,-1
;	p_add	roty,-1
;	p_next
;
;	p_do	40
;	p_add	rotx,-1
;	p_chase	rotz,30
;	p_add	roty,1
;	p_next
;
;	p_remove
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENTER CHIKA DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	enter_chikadirector

childno_ec	equ	1
ec_cut1	equ	100

	P_SOUNDPLACE	ROOM

	p_setdemo	ec_cut1

	p_collisions	off

	p_gosub	prou_posrot0

	p_spawn	0,0,15<<planet_base_scale,0,deg180,0,chika_k2,e_nocol_s_off,1,1,childno_ec
	p_become
	p_groundobj	on
	p_unbecome

	p_spawn	0,50<<planet_base_scale,(105+15)<<planet_base_scale,0,0,0,kabe_ak4,meteo_ak4_x,1,28h+60h,childno_ec
	p_become
	p_groundobj	on
	p_unbecome

	p_Qspawn	nullshape,ec_cam,1,1

	p_spawn	100,-10<<planet_base_scale,-100<<planet_base_scale,5,0,0,nullshape,ec_watch,1,1,childno_ec
	p_become
	p_demoshape
	p_unbecome
	p_spawn	0,-10<<planet_base_scale,-100<<planet_base_scale,5,0,0,nullshape,ec_arwing,1,1,childno_ec

	p_end

;----------------------------------------------------------------------------
	start_path	ec_arwing

	p_setvar	b,sdport1,%100
	p_playershape


	p_gosub		prou_playershield
	p_trigger	prou_playerdmg,always


	start_path	ec_watch

	p_setvel	40

	p_alwaysgenvecs	on

	p_rtrigger	.always,always
	p_rtrigger	ec_always,always

	p_collisions	off

	p_do		22
	p_chase		childrotx,20
	p_next

	p_accel	10,1

	p_do	10
	p_add	childrotx,-2
	p_next

	p_end


.always	p_return


;----------------------------------------------------------------------------
	start_path	ec_cam

	p_rtrigger	ec_always,always

	p_set		rotx,15

	p_add		worldx,-75
	p_add		worldy,25
	p_add		worldz,-475

	p_set		vy,3+2
	p_set		vz,5+5

	p_collisions	off

	p_rtrigger	.always,always

	p_end

.always	p_copypos2view		1,immediate
	p_campandemoshape	1,2,immediate

	p_return
;----------------------------------------------------------------------------------

ec_always	p_ifnotdemo	ec_cut1,demoobj_remove_force

	p_return






;*****************************************************************************
;meteo_arwing_remove
;
;	p_alwaysgenvecs	off
;	p_set	vx,0
;	p_set	vz,0
;
;	P_START65816
;	PHX
;	lda	al_vel,x
;	PHY
;	ldx	playpt1
;	toheap	y,x
;	sta	al_vel,x
;	sta	exal_vel,y
;	PLY
;	PLX
;	P_END65816
;
;	p_copypos2player
;	p_copyrot2player
;
;	p_wait	1
;
;	p_remove


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	KAITEI DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	enter_kaiteidirector
	start_path	kaiteidirector

childno_kaitei	equ	1
kaitei_cut1		equ	20
;kaitei_cut2		equ	21


	p_gosub	prou_posrot0


;************
	p_setvar	b,sdport1,%0
;************
	p_setvar	w,player1_horizon_offset,SCR6_Hofs

	p_setdemo	kaitei_cut1

	p_collisions	off

	p_set		roty,deg180

	p_Qspawn	nullshape,kaitei_cam,1,1

	p_spawn	0,-35<<planet_base_scale-120,70<<planet_base_scale+300,20,deg180,0,nullshape,kaitei_robo,1,1,childno_chika

	p_spawn	0,0,0,0,deg180,0,nullshape,kaitei_watch,1,1,childno_kaitei

	p_Qspawn	chika_k4,e_nocol_s_off,1,1
	p_become
	p_add		worldy,-30<<planet_base_scale
	p_groundobj	on
	p_unbecome

	p_end

;---------------------------------------------------------------------------------

	start_path	kaitei_watch

	p_setvel	2
	p_demoshape
	p_collisions	off
	p_wait		20
	p_accel		10,1
	p_end

;----------------------------------------------------------------------------------
	start_path	kaitei_cam

	p_collisions	off

	p_add	worldx,-125
	p_add	worldy,75
	p_add	worldz,150

	p_rtrigger	kaitei_always,always

	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate

	p_rtrigger	.always,always

	p_set	vz,-2

	p_end


.always	p_copypos2view		1,immediate
	p_campandemoshape	1,1


;	p_import	pword1,testx
;	p_add		childx,pword1
;	p_import	pword1,testy
;	p_add		childy,pword1
;	p_import	pword1,testz
;	p_add		childz,pword1
;	p_print		childx,d,kawagoe
;	p_print		childy,d,kawagoe
;	p_print		childz,d,kawagoe

	p_return
;----------------------------------------------------------------------------------

	start_path	kaitei_robo

	p_demoshape
	p_gosub	.init

	p_gosub		prou_playershield
	p_rtrigger	.always,always

.cut2	p_wait	58h-3dh+12

	p_do	10
	p_add	childrotx,-1
	p_next

	p_do	40
	p_add	childrotx,-2
	p_next

	p_end



.init	LOCAL
	p_gosub	prou_playershape_rb
	p_spawn	30,0,0,50,0,0,nullshape,kaitei_ashi_r,1,1,childno_kaitei
	p_spawn	-30,0,0,50,0,0,nullshape,kaitei_ashi_l,1,1,childno_kaitei
	p_alwaysgenvecs	on
	p_collisions	off
	p_Rtrigger	.bubble,8
	p_return


.always	LOCAL
	p_addanim	1,16
	p_ifsame	animframe,128+6,.accl
	p_accel		0,2
	p_return

.accl	p_setvel	40
	p_return



.bubble	LOCAL

	p_randomgoto		.ret

	P_SOUNDEFTDISTPOS	ob_bubble1

	p_Qspawn	bubble,kaitei_bubble,1,1

.ret	p_return

;------------
	start_path	kaitei_ashi_l

	P_START65816
	jsl	SASHI_player_L_path_l
	P_END65816

	p_igoto	Pkaitei_ashi_r.enter


	start_path	kaitei_ashi_r

	P_START65816
	jsl	SASHI_player_R_path_l
	P_END65816

.enter	LOCAL


	p_rtrigger	.always,always

	p_invisible	on
	p_wait	1
	p_invisible	off
	p_collisions	off


	p_import	pbyte1,demoNo
	p_ifnotsame	pbyte1,demo_clear_kaitei,.end

	p_wait	52h-1

	p_do	6eh-52h-10-9
	p_setanim	6
	p_next

	p_do	9
	p_chase		childrotx,0
	p_next

	p_remove


.end	p_end


.always	p_addanim	1,16

;	p_randomgoto	.ret
;	p_ifnotsame	animframe,128,.noBse
;	P_SOUNDEFTDISTPOS	ob_bubble1
;.noBse
	p_ifnotsame	animframe,128+8,.retal
	p_SOUNDEFTDISTPOS	roboswim

.retal	p_return

;----------------------------------------------------------------------------------
	start_path	kaitei_bubble

	p_sprite	0,-4

	p_collisions	off

	p_addrandom	worldx,15
	p_addrandom	worldy,15
	p_addrandom	worldz,15

	p_set	vy,-5

	p_wait	10

	p_remove


;----------------------------------------------------------------------------------
kaitei_always

	p_ifsamedemo	kaitei_cut1,.ret
;	p_ifsamedemo	kaitei_cut2,.ret
	p_igoto		demoobj_remove_force

.ret	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	START FINAL
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	start_finaldirector

sf_time	equ	70
childno_sf	equ	1
sf_cut1	equ	2

	p_copyplayerpos
	p_copyplayerrots
	p_set	rotx,0
	p_set	rotz,0

	p_trigger	.2,2
	p_rtrigger	sf_always,always

	p_gosub	prou_copyplayerinitpos

	p_setdemo	sf_cut1
	p_collisions	off
	p_spawn	0,0,0,0,0,0,nullshape,sf_cam,1,1,childno_sf
	p_spawn	0,0,380,-20,0,-40,nullshape,sf_arwing,1,1,childno_sf
	p_set	vz,30

	p_demosetmap

;	P_SOUNDPLACE	SPACE
;
;	P_START65816
;	KM_PUSHSNDPLACE
;	P_END65816

	p_end


.2	p_randomgoto	.noflash
	p_screenflash
.noflash	p_return

;----------------------------------------------------------------------------------
	start_path	sf_arwing

	P_START65816
	jsl	copy_final_Splayer_shield_l
	P_END65816

	p_playershape
 
	p_rtrigger	sf_always,always
	p_rtrigger	.always,always
	p_collisions	off

	p_do	sf_time

	p_chase	childrotx,0
	p_chase	childrotz,0
	p_add	childz,-(300/sf_time)	;580-150

	p_next

	p_trigger	Pclrawof.rz,always
	p_end

.always	p_copypos2player
	p_copyrot2player
	p_return

;----------------------------------------------------------------------------------
	start_path	sf_cam
	p_rtrigger	sf_always,always
	p_collisions	off
	p_rtrigger	.always,always

	p_wait	30

	p_end


.always	p_copypos2view		1,immediate
	p_copyrot2view		1,immediate
	p_return

;----------------------------------------------------------------------------------
sf_always	p_ifnotdemo	sf_cut1,demoobj_remove_force
	p_return




	IFEQ	1
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	START FINAL
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	start_finaldirector
sf_time	equ	70
childno_sf	equ	1
sf_cut1	equ	2
	p_copyplayerpos
	p_copyplayerrots
	p_set	rotx,0
	p_set	rotz,0
	p_rtrigger	sf_always,always
	p_gosub	prou_copyplayerinitpos
	p_setdemo	sf_cut1
	p_collisions	off
	p_spawn	0,0,0,0,0,0,nullshape,sf_cam,1,1,childno_sf
	p_spawn	0,-180,580,-20,0,-40,nullshape,sf_arwing,1,1,childno_sf
	p_set	vz,30
	p_demosetmap
	P_SOUNDPLACE	SPACE
	P_START65816
	KM_PUSHSNDPLACE
	P_END65816
	p_end
;----------------------------------------------------------------------------------
	start_path	sf_arwing

	p_playershape
;	p_gosub		prou_player1shape_aw
	p_rtrigger	sf_always,always
	p_rtrigger	.always,always
	p_collisions	off
	p_do	sf_time
	p_chase	childrotx,0
	p_chase	childrotz,0
	p_chase	childy,0
	p_add	childz,-(500/sf_time)	;580-150
	p_next
	p_rtrigger	Pclrawof.rz,always
	p_end
.always	p_copypos2player
	p_copyrot2player
	p_return
;----------------------------------------------------------------------------------
	start_path	sf_cam
	p_rtrigger	sf_always,always
	p_collisions	off
	p_rtrigger	.always,always
	p_end
.always	p_copypos2view		1,immediate
	p_copyrot2view		1,immediate
	p_return
;----------------------------------------------------------------------------------
sf_always	p_ifnotdemo	sf_cut1,demoobj_remove_force
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GAME START DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	attackdirector

ad_cut1		equ	2
childno_ad		equ	1
childno_ad_boost	equ	10

;	P_SOUNDEFFECT	sos_demo_on

	p_collisions	off

	p_demoshape

	p_set	worldx,0
	p_set	worldz,0

	P_IMPORT	roty,Kinitroty

	p_setvel	48

	p_import	pbyte1,attackrnd
	p_index		rotx,attackdirector.rotxtab,pbyte1

	p_index		worldy,attackdirector.Ehighttab,pbyte1
	p_export	Ehight,worldy

	p_import	roty,p1_roty_init

	p_setdemo	ad_cut1

	p_demosetmap

	p_spawn		0,0,2000,0,0,0,nullshape,ad_cam,1,1,childno_ad
	p_Qspawn	nullshape,ad_SE,1,1


; enemy start!

; 38h
	p_wait		18h

	p_do		20h
	P_START65816
	jsl	TSTRAT_000_l
	P_END65816
	p_next

	p_setvar	b,Etrigger,1


.wait	p_ifnotdemo	ad_cut1,.finish
	p_goto		.wait

.finish

	p_wait	4
	p_remove


;----------------------------------------------------------------------------------
	start_path	ad_cam

	p_collisions	off

	p_trigger	ad_always,always

	p_import	childx,p1_dist2cam

	p_set		vz,-70

	p_wait		2

	p_copypos2view	1,immediate

	p_rtrigger	.pan,always

	p_wait		10

;	p_do		35
;	p_add		vz,-10
;	p_next


;>>>>
	p_do		35
	p_import	pword1,p1_vz2enemy
	p_add		vz,pword1
	p_next
;<<<<


	p_trigger	.pan,off
	p_rtrigger	.pan2,always

	p_export	x1,rotx
	p_import	childrotx,x1
	p_neg		childrotx
	p_set		rotx,0

	p_spawn	-80,-20,0,0,-48,40,nullshape,ad_arwing,1,1,childno_ad

; set a_wing's rotx

	p_set	pbyte1,roty
	p_neg	pbyte1

.loop	p_chase	vz,30
	p_goto	.loop
	p_end


.pan	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate
	p_return


.pan2	p_copypos2view		1,immediate

	p_push	roty
	p_set	roty,pbyte1
	p_copyrot2view	1
	p_copyrot2view	1
	p_pull	roty

	p_return

;----------------------------------------------------------------------------------

	start_path	ad_arwing

	p_playershape

	p_collisions	off

	p_alwaysgenvecs	on

	p_trigger	ad_always,always
	p_rtrigger	.always,always

	p_setvel	40
	p_accel		5,2

	p_spawn		0,0,-20,0,0,0,boost,demoboost,1,1,childno_ad_boost

	P_SOUNDEFFECT	boost
	p_setvar	b,sdport1,%00001000

	p_do	8
	p_add	childroty,6
	p_next

	p_accel	0,0

	p_set	pbyte2,38

	p_setvar	b,sdport1,%00001011

	p_remove	childno_ad_boost

	p_do	10
	p_chase	vel,-30
	p_chase	childx,0
	p_next

	p_setvar	b,sdport1,%00000100

	p_do	40
	p_chase	vel,-30
	p_chase	childx,0
	p_next

	p_end


.always	p_push	rotx
	p_copypos2player
	p_set	rotx,0
	p_copyrot2player
	p_pull	rotx

	p_chase	pword1,0
	p_chase	pbyte2,0
	p_add	childrotz,pbyte2

	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ATTACK DEMO SOUND
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	ad_SE

	p_collisions	off

	p_wait	5

	P_START65816
	jsl	attackSE_srou_l
	P_END65816

.loop	p_import	pbyte1,Etrigger
	p_ifnotzero	pbyte1,.remove
	p_goto		.loop

.remove	p_remove

;----------------------------------------------------------------------------------

ad_always	p_ifnotdemo	ad_cut1,demoobj_remove_force
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	BACK ATTACK DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	attackbackdirector


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
abd_cut1		equ	2
childno_abd		equ	1
childno_abd_arwing	equ	10
childno_abd_watch	equ	11
;	P_SOUNDEFFECT	demo_on
	p_setvar	b,demoflag,demoflag_dustoff
	p_set	worldx,0
	p_set	worldy,0
	p_set	worldz,0
	P_IMPORT	roty,Kinitroty
	p_Qspawn	a_robo,abd_watch,1,1
	p_setvar	w,Ehight,0
	p_setdemo	abd_cut1
	p_demosetmap
	p_spawn		0,0,0,0,0,0,nullshape,abd_chair,1,1,childno_abd
	p_wait	38h
	p_setvar	b,Etrigger,1
	p_setvar	b,demoflag,0
.wait	p_ifnotdemo	abd_cut1,.finish
	p_goto		.wait
.finish
;	P_SOUNDEFFECT	demo_off
	p_wait	4
	p_remove


	start_path	abd_chair
	p_collisions	off
	p_quadvecs	on
;	p_setvel	-50
;	p_accel		-100,10
	p_setvel	-30
	p_accel		-50,2
;	p_spawn		300,1200,8000,0,0,0,nullshape,abd_carrier,1,1,childno_abd
	p_spawn		300,800,8000,0,0,0,nullshape,abd_carrier,1,1,childno_abd
.wait	p_ifnotdemo	abd_cut1,.finish
	p_goto		.wait
.finish	p_wait	4
	p_remove
;----------------------------------------------------------------------------------
	start_path	abd_cam
	p_collisions	off
	p_rtrigger	abd_always,always
	p_rtrigger	.always,always
	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate
	p_wait	48h-5
	p_do	5
	p_add	childy,-16
	p_add	childz,10
	p_next
	p_end
.always	p_copypos2view		1,immediate
	p_campandemoshape	1,0
	p_return
;----------------------------------------------------------------------------------
	start_path	abd_cam_carrier
	p_collisions	off
	p_rtrigger	abd_always,always
	p_rtrigger	.always,always
;	p_spawn	0,80,-180,0,0,0,nullshape,abd_cam,1,1,childno_abd
	p_spawn	0,80,-180,0,0,0,nullshape,abd_cam,1,1,childno_abd
	p_wait	40h
	p_trigger	.always,off
	p_do	100
	p_chase	childroty,0
	p_next
	p_end
.always
;	P_START65816
;	lda	Kinitroty
;	clc
;	adc	#deg180
;	sec
;	sbc	p1_roty_init
;	sta	al_childroty,x
;	P_END65816
	p_findshape	ship_0
	p_faceshape	immediate
	P_START65816
	ldy	al_childrotobj,x
	lda	al_roty,x
	sec
	sbc.w	al_roty,y
	sta	al_childroty,x
	P_END65816
	p_return
;----------------------------------------------------------------------------------
	start_path	abd_carrier
	p_collisions	off
	p_rtrigger	abd_always,always
	p_rtrigger	.always,always
	P_START65816
	lda	p1_roty_init
	sec
	sbc	Kinitroty
	sta	al_childroty,x
	P_END65816
;	p_spawn		0,0,150,0,0,0,nullshape,abd_cam_carrier,1,1,childno_abd
;	p_spawn		0,0,0,0,0,0,nullshape,abd_arwing,1,1,childno_abd
	p_spawn		0,0,0,0,0,0,nullshape,abd_arwing,1,1,childno_abd
	p_end
.always	p_return
;----------------------------------------------------------------------------------
	start_path	abd_arwing
	p_rtrigger	abd_always,always
	p_rtrigger	.always,always
	p_export	player1_vz,vz
	p_demoshape
	p_spawn		0,0,0,0,0,0,nullshape,abd_cam_carrier,1,1,childno_abd
	p_collisions	off
	p_playershape
	p_end
.always	p_setvel	40
	p_export	player1_vx,vx
	p_export	player1_vy,vy
	p_export	player1_vz,vz
	p_set	vx,0
	p_set	vy,0
	p_set	vz,0
	p_copyrot2player
	p_copypos2player
	p_return
;----------------------------------------------------------------------------------
	start_path	abd_watch
	p_rtrigger	abd_always,always
	p_collisions	off
;	p_demoshape
;	p_set	shape,a_robo
	p_set	shape,ship_0
	p_invisible	on
	p_setvel	junko_speed
;	p_add	worldx,vx
;	p_add	worldy,vy
;	p_add	worldz,vz
;	p_add	worldx,vx
;	p_add	worldy,vy
;	p_add	worldz,vz
	p_end
;----------------------------------------------------------------------------------
abd_always	p_ifnotdemo	abd_cut1,demoobj_remove_force
	p_return

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	START CHIKA
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	start_chikadirector

childno_sc	equ	1
childno_scaw	equ	11
sc_cut1	equ	2
sc_wait	equ	8


	p_import	pword1,KGameMapPtr
	p_ifsame	pword1,stg_stg2,.notrans

	p_forcetransform	ROBOT
.notrans
;-----------------------------------------------------------------------------------

	start_path	start_d_sendirector

	p_setvar	w,player1_horizon_offset,SCR6_Hofs

	P_SOUNDPLACE	ROOM

	P_START65816
	KM_PUSHSNDPLACE
	P_END65816

	p_trigger	sc_always,always

	p_gosub	prou_copyplayerinitpos
	p_set	worldy,0
	p_setdemo	sc_cut1
	p_collisions	off
	p_spawn	0,-100,159,0,0,0,nullshape,sc_cam,1,1,childno_sc
	p_spawn	0,-120,-200,0,0,0,nullshape,sc_arwing,1,1,childno_scaw
	p_spawn	0,-50<<planet_base_scale,-105<<planet_base_scale,0,deg180,0,chika_k2,e_nocol_s_off,1,1,childno_ec
	p_become
	p_set	depthoffset,2
	p_unbecome

	p_Qspawn	kabe_ak4,meteo_ak4,1,4
	p_become
	p_trigger	sc_always,always
	p_gosub		col_id_ck
	p_unbecome

	p_demosetmap

	p_end

;----------------------------------------------------------------------------------

	start_path	sc_arwing

	p_demoshape

	P_START65816
	jsl	copy_Splayer_shield_l
	P_END65816

	p_playershape
	p_trigger	prou_playerdmg,always

	p_trigger	sc_always,always
	p_rtrigger	.always,always
	p_collisions	off

	p_alwaysgenvecs	on
	p_setvel	30

	p_end

.always	p_copypos2player
	p_copyrot2player
	p_return


;----------------------------------------------------------------------------------
	start_path	sc_cam

	p_rtrigger	sc_always,always

	p_collisions	off
	p_rtrigger	.always,always

	p_end

.always	p_copypos2view		1,immediate
	p_campandemoshape	1,3,immediate

;	p_import	pword1,testx
;	p_add		childx,pword1
;	p_import	pword1,testy
;	p_add		childy,pword1
;	p_import	pword1,testz
;	p_add		childz,pword1

	p_return

;----------------------------------------------------------------------------------

sc_always	p_ifnotdemo	sc_cut1,demoobj_remove_force
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENTER KAITEI DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	start_kaiteidirector

childno_sk	equ	1
sk_cut1	equ	2
sk_waittime	equ	8
sk_jmptime	equ	14h

	p_setvar	b,sdport1,%0

	P_SOUNDPLACE	ROOM

	P_START65816
	KM_PUSHSNDPLACE
	P_END65816

	p_trigger	sk_always,always

	p_demosetmap

	p_gosub	prou_copyplayerinitpos

	p_setdemo	sk_cut1

	p_collisions	off

	p_Qspawn	pools_0,e_nocol_s_off,1,1

	p_spawn	-30,-100,25<<planet_base_scale,0,0,0,nullshape,sk_cam,1,1,childno_sk

	p_spawn	0,100,10<<planet_base_scale,0,0,0,nullshape,sk_robo,1,1,childno_sk

	p_end

;----------------------------------------------------------------------------------
	start_path	sk_cam

	p_trigger	sk_always,always

	p_collisions	off
	p_copypos2view	1,immediate
	p_campandemoshape	1,0,immediate

	p_wait	sk_waittime+2

	p_rtrigger	.always,always

	p_set	vz,-2

	p_end

.always	p_copypos2view		1,immediate
	p_campandemoshape	1,3

	p_return

;---------------------------------------------------------------------------------
;
;	start_path	sk_watch
;
;	p_demoshape
;
;	p_collisions	off
;
;
;	p_set		shape,c_wing
;
;	p_end
;
;---------------------------------------------------------------------------------
	start_path	sk_smoke

	p_collisions	off
	p_sprite	0,5
	p_set		worldy,-4
	p_set	vy,-1
	p_sprite	0,1

	P_SOUNDEFTDISTPOS	roboland_l

	p_igoto		Psk_splash.enter

;---------------------------------------------------------------------------------
	start_path	sk_splash

	p_set		worldy,-10

	p_sprite	0,10

	P_SOUNDEFTDISTPOS	outmarine

.enter	LOCAL

	p_collisions	off

	p_do		8
	p_addcolanim	1,8
	p_next

	p_remove

;---------------------------------------------------------------------------------

	start_path	sk_robo

	p_trigger	sk_always,always

	p_set		clip,plane_GROUND

	p_demoshape

	p_gosub	prou_playershape_rb

	p_rtrigger	.always,always

; body yofs --> pword1

	p_gosub	prou_rbotyofstab


	p_collisions	off

	p_invisible	on

	p_wait	sk_waittime

	p_spawn	30,0,0,20,0,0,nullshape,sk_ashi_r,1,1,childno_sk
	p_spawn	-30,0,0,20,0,0,nullshape,sk_ashi_l,1,1,childno_sk

	p_setvel	15

	p_set	vy,-52

	p_do	3
	p_add	vy,4
	p_next

	p_Qspawn	splash,sk_splash,1,1

	p_invisible	off

	P_START65816
	jsl	copy_kaitei_Splayer_shield_l
	P_END65816

	p_do	16
	p_add	vy,4
	p_next

	p_set	clip,plane_off

	p_wait	sk_jmptime-19

	p_set	vy,0

	p_set	childy,pword1

	p_do	10
	p_chase	vz,0
	p_chase	vx,0
	p_next

	p_end


.always
	p_push	worldy
	p_set	worldy,pword1
	p_copypos2player
	p_copyrot2player
	p_pull	worldy

;	p_print	worldy,h,kawagoe

	p_return

;------------

	start_path	sk_ashi_l

	P_START65816
	jsl	ASHI_player_L_path_l
	P_END65816

	p_igoto	Psk_ashi_r.enter

	start_path	sk_ashi_r

	P_START65816
	jsl	ASHI_player_R_path_l
	P_END65816

.enter	LOCAL

	p_rtrigger	sk_always,always

	p_set	clip,plane_GROUND

	p_set	pbyte1,80

	p_rtrigger	.always,always


	p_setanim	12

	p_invisible	on
	p_wait		3
	p_invisible	off

	p_wait		sk_jmptime-3-2-4
	p_set		pbyte1,0

	p_set		clip,plane_off

	p_wait		4+2

	p_Qspawn	smoke,sk_smoke,1,1

	p_setanim	11

	p_set	childrotx,0

	p_wait	2

	p_setanim	0

	p_end



.always	p_chase	childrotx,pbyte1
	p_return

;----------------------------------------------------------------------------------

sk_always	p_ifnotdemo	sk_cut1,demoobj_remove_force
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GOTO kaitei
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	start_path	gotokaiteidirector

childno_gk		equ	5
gk_time0	equ	30h
gk_cut1	equ	2
	p_set	pbyte1,0
	p_copyplayerpos
	p_copyplayerrots
	p_import	worldx,corex
	p_import	worldz,corez
	p_set		worldy,0
	p_import	roty,coreroty
	p_set		rotx,0
	p_set		rotz,0
.wait	p_distmore	2000,.cnt
	p_playerincone	8,.make
.cnt	p_goto		.wait
.make	p_setdemo	gc_cut1
;	p_spawn		0,0,0,0,0,0,nullshape,gk_rb_carrier,1,1,childno_gk
	p_end
.always	p_inc	pbyte1
;	p_print	pbyte1,h,kawagoe
	p_return
;-----------------------------------------------------------------------------
	start_path	gk_rb_carrier
	p_collisions	off
	p_set	shape,c_wing
	P_START65816
	jsl	rotateplrpos2childpos_l
	lda	al_childroty,x
	clc
	adc	#40h
	bmi	.c180
	P_END65816
	p_set		pbyte1,0
	p_spawn		0,0,0,0,0,0,nullshape,gc_arwing0,1,1,childno_gc
	p_igoto		.skip
.c180	P_END65816
	p_set		pbyte1,deg180
	p_spawn		0,0,0,0,0,0,nullshape,gc_arwing180,1,1,childno_gc
.skip	p_spawn	80,-200,200,0,0,0,nullshape,gk_cam,1,1,childno_gc
	p_rtrigger	.always,always
	p_wait	20
	p_trigger	.always,off
	p_rtrigger	.always2,always
	p_end
.always2	p_chase	childx,0
.always	p_chase	childroty,pbyte1
	p_return
;-----------------------------------------------------------------------------
	start_path	gk_cam
	p_collisions	off
	p_wait	1
	p_campandemoshape	1,1,immediate
	p_copypos2view		1,immediate
	p_rtrigger	.always,always
	p_end
.always	p_campandemoshape	1,1,immediate
	p_copypos2view		1,immediate
	p_return
;----------------------------------------------------------------------------------
	start_path	gk_robo
	p_demoshape
	p_gosub	prou_playershape_rb
	p_spawn	30,0,0,50,0,0,nullshape,kaitei_ashi_r,1,1,childno_kaitei
	p_spawn	-30,0,0,50,0,0,nullshape,kaitei_ashi_l,1,1,childno_kaitei
	p_alwaysgenvecs	on
	p_collisions	off
	p_rtrigger	.bubble,always
	p_rtrigger	.always,always
	p_do	30
	p_add	childy,150/30
	p_next
	p_do	3bh-30
	p_chase	childx,0
	p_next
	p_invisible	on
.cut1	p_ifsamedemo	kaitei_cut2,.cut2
	p_goto		.cut1
.cut2	p_invisible	off
	p_set	childx,0
	p_set	childy,-35<<planet_base_scale
	p_set	childz,70<<planet_base_scale
	p_set	childrotx,20
	p_set	childroty,deg180
	p_wait	58h-3dh
	p_do	10
	p_add	childrotx,-1
	p_next
	p_do	40
	p_add	childrotx,-2
	p_next
	p_end
.always	p_addanim	1,16
	p_ifsame	animframe,128+6,.accl
	p_accel		0,2
	p_return
.accl	p_setvel	40
	p_return
.bubble	p_andframegoto	8,.ret
	p_andframegoto	1,.ret
	p_Qspawn	bubble,kaitei_bubble,1,1
.ret	p_return


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GOTO d_sen
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	gotod_sendirector

childno_gd		equ	1
childno_gd_arwing	equ	50
childno_gd_start	equ	60
childno_gd_d_sen	equ	70

gd_cut1	equ	2
gd_cut2	equ	3
gd_cut3	equ	4
gd_cut1_time	equ	70

	p_collisions	off

; set pos & rot

	p_setvar	w,player1_horizon_offset,SCR4_Hofs

	p_setdemo	gd_cut1

	p_gosub		Pgotochikadirector.init

	p_Qspawn	nullshape,gd_d_sen,1,10
	p_Qspawn	nullshape,gd_arwing_start,1,1

	p_gosub		prou_inclevel_d_sen

.cut1	p_ifsamedemo	gd_cut2,.cut2
	p_goto		.cut1

.cut2	p_remove	childno_gd_start

	p_set	roty,0

	p_spawn	0,0,0,0,0,0,nullshape,gd_cam,1,1,childno_gd

	p_wait		1

	p_Qspawn	nullshape,gd_d_sen_2,1,0ffh

.wait	p_wait	2ch

	p_end

;-----------------------------------------------------------------------------
	start_path	gd_d_sen

	p_collisions	off
	p_gosub	prou_d_sen3

	p_trigger	Pgd_d_sen_2.fire,8,64

	p_wait		30
	p_remove



	start_path	gd_d_sen_2

	p_collisions	off
	p_gosub	prou_d_sen3

	p_import	ap,coreENTERroty
	p_index	count,gd_cam.count,ap
	p_add	count,-8

	p_do	count
	p_andframegoto	3,.dofire
	p_igoto	.next
.dofire	p_gosub	.fire
.next	p_next

	p_end


.fire	LOCAL
	P_IMPORT	ap,eaction2
	P_IFNOTZERO	ap,.nofire
	p_Qspawn	nullshape,gd_warp,1,1
.nofire	p_return

;----------------------------------------------------------------------------
	start_path	gd_warp

	p_addrandom	worldx,511
	p_addrandom	worldz,1023
	p_set		worldy,-100

	P_SOUNDEFTDISTPOS	d_sen_ss_laser	;$af
	p_set	shape,warp_laser_ls

	p_import	ptr,demoshapeptr
	p_faceshape	immediate
	p_set	rotx,-5

	p_addrandom	rotx,7

	p_collisions	off

	p_quadvecs	on
	p_setvel	127
	p_add	vx,vx
	p_add	vy,vy
	p_add	vz,vz

	p_wait	10

	p_remove

;----------------------------------------------------------------------------


	start_path	gd_d_sen_parts5

	p_trigger	Pgd_d_sen_parts.anim,always


	p_ifnotdemo	0,.noSE
	p_trigger	Pgd_d_sen_parts.SE,2
.noSE

	start_path	gd_d_sen_parts
	p_collisions	off
	p_groundobj	on
	p_set		depthoffset,3
	p_end



.anim	LOCAL
	p_setanim	0
	p_return



.SE	LOCAL

	P_SOUNDEFTDISTPOS	en_laser_charge
	p_return


;-----------------------------------------------------------------------------

	start_path	gd_cam

	p_collisions	off

	p_import	ap,coreENTERroty

	p_index	childx,gd_cam.cx,ap
	p_index	childy,gd_cam.cy,ap
	p_index	childz,gd_cam.cz,ap


	P_START65816
	s_or_var	B,demoflag,#demoflag_nextmap_trapped
	P_END65816

	p_wait	1

	p_trigger	.always2,always,2

	p_set	vz,4
	p_set	vy,5

;************
	p_Qspawn	nullshape,gd_arwing0,1,0
	P_BECOME
	p_demoshape
	p_collisions	off
	p_alwaysgenvecs	on
	p_playershape

	P_START65816
	jsl	gd_arwing0_path_l
	P_END65816

;	p_setvel	50
;	p_import	ap,coreENTERroty
;	p_index	childx,gd_arwing.x,ap
;	p_index	childy,gd_arwing.y,ap
;	p_index	childz,gd_arwing.z,ap
;	p_index	childrotx,gd_arwing.irx,ap
;	p_index	pbyte1,gd_arwing.iry,ap
;	p_index	childrotz,gd_arwing.irz,ap
;	p_index	rotx,gd_arwing.rx,ap
;	p_index	roty,gd_arwing.ry,ap
;	p_index	rotz,gd_arwing.rz,ap
;	p_index	count,gd_arwing.count,ap
;	p_add	worldx,childx
;	p_add	worldy,childy
;	p_add	worldz,childz
	P_UNBECOME

;************

	p_wait	2

	p_zero	pbyte1

	p_rtrigger	.always3,always

	p_index	count,gd_cam.count,ap

	p_do	count
	p_next

	p_trigger	.always3,off

	p_end



.always2	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate
	p_return

.always3	p_copypos2view		1,immediate
	p_campandemoshape	1,1
	p_return

;-----------------------------------------------------------------------------

	start_path	gd_obj
	p_collisions	off

	p_set	vy,8
	p_set	vz,30

	p_end

;-----------------------------------------------------------------------------
; usiro
;************
	start_path	gd_arwing0

	p_gosub		prou_playershield

	p_trigger	prou_playerdmg,always

	p_wait	count

	p_index	count,gd_arwing.count2,ap

	p_accel	20,2

	p_do	count
	p_chase	childroty,pbyte1
	p_chase	rotx,childrotx
	p_add	roty,childroty
	p_next

	p_index	count,gd_arwing.count3,ap

	p_do	count
	p_chase	rotx,0
	p_chase	rotz,0
	p_chase	roty,deg180
	p_next

	p_set	shape,nullshape

	p_wait	5

;************
; DEMO END
	P_START65816
	s_or_var	B,demoflag,#demoflag_nextmap_start
	P_END65816

;************

	p_end

;-----------------------------------------------------------------------------

	start_path	gd_arwing_start

	p_demoshape

	p_trigger	gd_cut1_always,always

	p_copyplayerpos
	p_copyplayerrots

	p_set		rotx,0
	p_set		rotz,0

	p_collisions	off

	p_set		vz,5

	p_spawn	0,0,0,0,0,0,nullshape,gd_arwing_start_dummy,1,1,1	;childno_gd_start
	p_spawn	0,0,0,0,0,0,nullshape,gd_cam_start_carrier,1,1,1	;childno_gd_start

	p_wait	38

	p_Qspawn	nullshape,gd_d_sen_start,1,1

	P_START65816
	jsl	gd_arwing_start00_path_l
	P_END65816

	p_wait	32

	p_remove

;-----------------------------------------------------------------------------

	start_path	gd_arwing_start_dummy

	p_demoshape

	p_gosub		prou_playershield
	p_trigger	prou_playerdmg,always
	p_playershape

	p_trigger	gd_cut1_always,always
	p_trigger	Pclrawof.rz,always

	p_collisions	off


	p_wait	30

	p_trigger	Pclrawof.rz,off

	p_set	vz,-10
	p_do	8
	p_add	childrotz,32
	p_next

	p_Qspawn	nullshape,gd_asd,1,1

	p_set	shape,nullshape

	p_end


;------------

	start_path	gd_asd	; arwing

	p_gosub		prou_playershield
	p_trigger	prou_playerdmg,always
	p_trigger	gd_cut1_always,always


	p_playershape
	p_alwaysgenvecs	on
	p_demoshape
	p_collisions	off

	p_setvel	30

	p_gosub		prou_demoboost

	P_SOUNDEFFECT	boost

	p_set		childroty,roty


.loop
	p_shapedead	.find
	p_igoto		.face

.find	p_findshape	d_sen_0
	p_push		roty
	p_faceshape	immediate
	p_set		childroty,roty
	p_pull		roty

.face	p_chase		rotz,0
	p_set		rotx,0

	p_chase		roty,childroty

	p_goto		.loop

;-----------------------------------------------------------------------------

	start_path	gd_cam_start_carrier

	p_trigger	gd_cut1_always,always
	p_collisions	off
	p_spawn		0,50,-100,0,0,0,nullshape,gd_cam_start,1,1,childno_gd_start
	p_rtrigger	.always,always

	p_do		16
	p_add		childroty,-6
	p_next

	p_end

.always	p_return

;-----------------------------------------------------------------------------

	start_path	gd_cam_start

	p_trigger	gd_cut1_always,always
	p_collisions	off
	p_wait	1
	p_rtrigger	.always,always


	p_wait	38

	p_do	20
	p_add	childy,-1
	p_next
	p_end

.always	p_copypos2view		1	;,immediate
	p_campandemoshape	1,0	;,immediate
	p_return

;-----------------------------------------------------------------------------

	start_path	gd_d_sen_start

	p_trigger	Pgd_d_sen_2.fire,8,64
	p_trigger	gd_cut1_always,always

	p_collisions	off
	p_slope		off

	p_wait	1

	p_gosub	prou_d_sen3

	p_wait	32	;33

	p_remove

;----------------------------------------------------------------------------
	start_path	gd_d_sen_start_parts

	p_collisions	off
	p_invisible	on
	p_wait	1
	p_invisible	off
	p_wait	31	;32

	p_remove

;*****************************************************************************
gd_cut1_always

	p_ifnotdemo	gd_cut2,.cnt
	p_set		shape,nullshape
	p_igoto		demoobj_remove_force
.cnt	p_return

;*****************************************************************************
gd_arwing_init

;	p_demoshape
	p_trigger	gd_aw_always,always
	p_playershape
	p_collisions	off
	p_alwaysgenvecs	on
	p_return

;*****************************************************************************
gd_aw_always
	p_add	worldx,childx
	p_add	worldz,childz

	p_chase	childx,0
	p_chase	childz,0
	p_add	rotz,childrotz
	p_chase	childrotz,0
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GOTO chika
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	gotokaiteidirector

childno_gkwatch	equ	20
childno_gk		equ	5

gk_time0	equ	30h
gk_cut1	equ	128	; bit 7 = 1 then player trapped

	p_gosub		Pgotochikadirector.init
	p_collisions	off

; set pos & rot

	p_set	pword1,200	; width

.wait
	p_setmarker	2

	P_PLRFORCEWAY	deg180,pword1,pword1,1000
	p_playerincone	20h,.in
	p_plrturn	on
	p_igoto		.cnt

.in	p_ifplrturn	on,.cnt
	p_plrcontrol	off
	p_chase		pword1,10

	p_gosub		prou_inclevel

	p_distmore	500,.cnt

	p_gosub		Pgotochikadirector.through

.cnt	p_goto		.wait


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GOTO chika
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	gotochikadirector

childno_gcwatch	equ	20
childno_gc		equ	5

gc_time0	equ	30h
gc_cut1	equ	128	; bit 7 = 1 then player trapped

	p_collisions	off

; set pos & rot

	p_gosub		.init

	p_set	pword1,100	; width
	p_set	childy,300	; width

.wait

	P_PLRFORCEWAY	deg180,pword1,childy,1000
	p_playerincone	20h,.in
	p_plrturn	on
	p_igoto		.cnt
.in	p_ifplrturn	on,.cnt
	p_igoto		.next
.cnt	p_goto		.wait




.next

	p_plrcontrol		off
	p_forcetransform	GDARWING

	p_gosub		prou_inclevel

.loop2	p_chase		pword1,10
	p_chase		pword1,100
	p_distmore	200,.cnt
	p_gosub		.through
.cnt2	p_goto		.loop2

	p_end




.through	LOCAL

	P_START65816
	s_or_var	B,demoflag,#demoflag_nextmap_start
	P_END65816
	p_return


.init	LOCAL
	p_setvar	w,p1_camrotzbuf,0
	p_import	worldx,corex
	p_import	worldz,corez

	p_set		worldy,0
	p_import	roty,coreroty

	p_set		rotx,0
	p_set		rotz,0
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GOTO FINAL
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	gotofinaldirector

childno_gfwatch	equ	20
childno_gf		equ	5
childno_gf_cam	equ	6
childno_gf_arwing	equ	7
childno_gf_watch	equ	8
childno_gf_arwing_boost	equ	9

gf_time0	equ	30h
gf_cut1	equ	128+1	; bit 7 = 1 then player trapped
gf_cut2	equ	2

	P_SET	AREA,-1

	p_collisions	off
	p_demoshape

; set pos & rot

	p_trigger	Pcds_chika.exp,always,20
	p_trigger	Pdestruct_coredirector.exp,4
	p_trigger	Pand_box0.flash,2

	p_gosub		Pgotochikadirector.init

	p_zero	rotx
	p_zero	roty
	p_zero	rotz

	p_set		worldy,0
	p_setdemo	gf_cut1
	p_set		shape,nullshape
;cut1
	p_rtrigger	.always,always

	p_Qspawn	and_ha_1,gf_and_box,1,1
	p_Qspawn	and_z_1,gf_and_z_1,1,1

	p_spawn	0,-310-50,-300,-8,0,0,nullshape,gf_cam,1,1,childno_gf_cam

	p_wait	30h
	p_ifarwing	.aw0
	P_SOUNDEFFECT	transRobo2Arwing
.aw0	p_wait	8
	p_ifarwing	.aw1
	P_SOUNDEFFECT	transRobo2Arwingend
.aw1	p_wait	8
	p_setvar	b,sdport1,8

	p_wait	5

	p_spawn	0,-280,-550+92,0,0,0,nullshape,gf_arwing,1,1,childno_gf_arwing

	p_trigger	Pand_box0.flash,off

	p_wait	60h-45h

	p_setdemo	gf_cut2

	p_remove	childno_gf

	p_trigger	Pdestruct_coredirector.exp,off

	p_end

.16	;p_screenflash
	p_return



.always	p_add	roty,2
	p_return

;--------------------------------------------------------------------------------------

; camera
	start_path	gf_cam

	P_SET	AREA,-1

	p_collisions	off

	p_rtrigger	.always,always
	p_rtrigger	.flash,always


	p_do	30h
	p_add	childz,-150/30h
	p_next


	p_do	8
	p_add	childrotx,-1
	p_next

	p_wait	16


	p_do	32
	p_add	childz,500/32
	p_add	vy,1
	p_add	childrotx,-2
	p_next

	p_do	20
	p_add	vy,3
	p_next

	p_end


.always	p_copypos2view		1,immediate
	p_neg		roty
	p_copyrot2view		1,immediate
	p_neg		roty

.a0
	p_return


.flash

.noflash	p_return

;-----------------------------------------------------------------------------

	start_path	gf_arwing

	P_SET	AREA,-1

	p_rtrigger	.always,always

	p_collisions	off
	p_setvel	40

	p_gosub		prou_playershield

	p_playershape

	p_gosub	prou_demoboost

	P_SOUNDEFFECT	boost

	p_alwaysgenvecs	on

	p_wait	4

	p_set	pbyte2,-8

	p_do	16
	p_accel	30,1
	p_add	childrotx,4
	p_next

	p_set	pbyte2,-4




	p_do	16
	p_accel	30,1
	p_next

	p_set	pbyte2,-2

	p_do	10
	p_accel	92,3
	p_next

	p_accel	92,4


	IFEQ	1

	p_wait	30
	p_set	vy,92

	ENDC


;	p_alwaysgenvecs	off
;
;	p_zero	vx
;	p_zero	vz
;
;	p_wait	58h-16-16-10-30
;
;	p_remove	childno_gf_arwing_boost
;
;	p_set	pbyte2,0
;
;	p_set	vy,80
;
;	p_wait	4
;
;	p_set	vy,110
;
;	p_spawn		0,0,-20,0,0,0,boost,demoboost,1,1,childno_gf_arwing_boost
;	P_SOUNDEFFECT	boost

	p_end


.always
	p_add	childrotz,pbyte2
	p_return


;-----------------------------------------------------------------------------
;	start_path	gf_watch
;
;	p_demoshape
;
;	p_collisions	off
;
;	p_wait		30
;
;	p_do	20
;	p_add	childy,10
;	p_next
;
;	p_wait	48h-20-30
;
;	p_set	vy,20
;
;	p_wait	10
;
;	p_do	20
;	p_add	vy,1
;	p_next
;
;	p_add	vy,100
;
;	p_end
;
;-----------------------------------------------------------------------------

	start_path	gf_and_z_1

	P_SET	AREA,-1

	p_groundobj	on

	p_Qspawn	last_to,gf_last_to,1,1
	p_become
	p_add		worldy,0<<last_to_scale
	p_unbecome

	p_collisions	off

	p_setanim	0

	p_wait		30

	p_Qspawn	last_ka,e_nocol_s_off,1,1
	p_become
	p_add		worldy,120<<last_ka_scale
	p_groundobj	on
	p_unbecome

	p_wait	40h-30

	p_groundobj	off

	p_igoto		Pgf_and_box.loop

;-----------------------------------------------------------------------------
	start_path	gf_last_to

	P_SET	AREA,-1

	p_groundobj	on

	p_collisions	off

	p_setanim	0

	p_wait		28h

	P_SOUNDEFFECT	ob_opendoor_s

	p_do	10
	p_addanim	1,11
	p_next

	p_wait	3fh-10-28h

	p_groundobj	on

	p_igoto		Pgf_and_box.loop

;-----------------------------------------------------------------------------
	start_path	gf_and_box

	p_trigger	prou_ramdomexpsound,2,120

	P_SET	AREA,-1

	p_add		worldy,-300

	p_collisions	off

	p_set	pbyte1,0
	p_rtrigger	.always,always

	p_do	10h
	p_add	childroty,1
	p_next
	p_wait	28h

	P_SOUNDEFFECT	bs_core_fall

	p_do	10h
	p_add	vy,120/10h
	p_add	childrotx,1
	p_next

	p_wait	46h-38h

	p_remove
	p_end


.always	p_add	roty,childroty
	p_return


.loop	LOCAL
	p_ifnotdemo	gf_cut1,.remove
	p_goto		.loop

.remove	p_remove
	p_end



;-----------------------------------------------------------------------------
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	gc_aw_carrier
	p_trigger	gotochika_always,always
	p_collisions	off
	p_set	shape,c_wing
	P_START65816
	jsl	rotateplrpos2childpos_l
	lda	al_childroty,x
	clc
	adc	#40h
	bpl	.c180
	P_END65816
	;;;;P_PLRFORCEWAY	deg90,100,4000
	p_end
;	p_set		pbyte1,deg180
;	p_spawn		0,0,0,0,0,0,nullshape,gc_arwing0,1,1,childno_gc
;	p_spawn		80,-120,200+200,0,0,0,nullshape,gc_cam,1,1,childno_gc
;	p_igoto		.skip
.c180	P_END65816
	p_set		pbyte1,0
	p_spawn		0,0,0,0,0,0,nullshape,gc_arwing180,1,1,childno_gc
	p_spawn		80,-200,-200,0,0,0,nullshape,gc_cam,1,1,childno_gc
.skip	p_playershape
	p_trigger	.always,always
	p_wait	20
	p_trigger	.always,off
	p_trigger	.always2,always
	p_end
.always2	p_chase	childx,0
.always	p_chase	childroty,pbyte1
	p_chase	childx,0
	p_return
;-----------------------------------------------------------------------------
	start_path	gc_arwing180
	p_trigger	gotochika_always,always
	p_alwaysgenvecs	on
	p_demoshape
	p_collisions	off
	p_set		pbyte1,0
	p_trigger	.always,always
	p_playershape
	p_setvel	45
	p_wait	18
	p_do	2fh-18
	p_chase	pbyte1,-6
	p_chase	childrotx,-20
	p_chase	childrotz,-40
	p_next
	p_do	48h-2fh
	p_chase	pbyte1,2
	p_chase	childrotx,25
	p_chase	childrotz,8
	p_next
	p_trigger	.always,off
	p_trigger	.always2,always
	p_end
.always	p_add	childroty,pbyte1
;	p_print	childx,h,kawagoe
;	p_print	childroty,h,kawagoe
	p_return
.always2	LOCAL
	p_chase	childx,0
	p_chase	childy,-70
	p_chase	childroty,deg180
	p_chase	childrotx,0
	p_copypos2player
	p_return
;-----------------------------------------------------------------------------
	start_path	gc_arwing0
	p_trigger	gotochika_always,always
	p_alwaysgenvecs	on
	p_demoshape
	p_collisions	off
	p_trigger	.always,always
	p_playershape
	p_setvel	30
	p_end
.always	LOCAL
	p_chase	childx,0
	p_chase	childroty,0
	p_copypos2player
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC




	IFEQ	1
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	p_alwaysgenvecs	on
	p_demoshape
	p_collisions	off
	p_setvel	30
	p_gosub		prou_player1shape_aw
	p_wait	5
	p_trigger	.always,always
	p_wait	16
	p_trigger	.always,off
	p_set	childrotx,-64
	p_do	8
	p_add	childroty,-128/8
	p_next
	p_do	32
	p_add	childrotx,-4
	p_next
	p_accel	50,1
	p_do	16
	p_add	childrotx,-4
	p_next
	p_end
.always	p_add	childrotx,-4
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC
;-----------------------------------------------------------------------------

	start_path	gc_cam

;	P_START65816
;	ldy	al_ptr,x
;	s_jmp_distmore	x,y,#1000,.skip
;
;	s_or_var	B,demoflag,#demoflag_nextmap_start
;
;	P_END65816
;	p_end
;
;
;
;.skip	P_END65816

	p_trigger	gotochika_always,always
	p_collisions	off
	p_wait	1
	p_copypos2view		1	;,immediate
	p_campandemoshape	1,1,immediate
	p_trigger	.always,always
	p_end

.always
	p_copypos2view		1	;,immediate
	p_campandemoshape	1,1,immediate
	p_return


;----------------------------------------------------------------------------------

gotochika_always

	p_ifsamedemo	gc_cut1,.ret
	p_igoto		demoobj_remove_force

.ret	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CHIKA DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	chikadirector

childno_chika	equ	1
chika_cut1		equ	2
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	p_setdemo	chika_cut1
	p_trigger	chika_always,always
	p_set		shape,chika_k1
	p_collisions	off
	p_set		roty,deg180
	p_spawn		50,-200,800,0,deg180,0,nullshape,chika_cam,1,1,childno_chika
	p_spawn		0,-80,1550,0,deg180,0,nullshape,chika_arwing,1,1,childno_chika
	p_end
;----------------------------------------------------------------------------------
	start_path	chika_arwing
	p_demoshape
	p_playershape
	p_collisions	off
	p_trigger	.always,always
	p_alwaysgenvecs	on
	p_setvel	30
	p_set	pbyte1,0
	p_set	pbyte2,0
	p_end
.always	p_return
;----------------------------------------------------------------------------------
	start_path	chika_cam
	p_collisions	off
	p_copypos2view	1,immediate
	p_trigger	chika_always,always
	p_trigger	.always,always
	p_set	vy,170/1bh
	p_wait	1bh
	p_set	vy,0
	p_wait	10
	p_accel	50,2
	p_do	30h-1bh-10
	p_chase	childx,0
	p_next
	p_do	0eh
	p_chase	childy,-70
	p_chase	childx,0
	p_next
	p_set	vz,0
	p_accel	0,0
	p_end
.always	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate
	p_chase	pword1,0
	p_add	childy,pword1
	p_return
;----------------------------------------------------------------------------------
chika_always	p_ifnotdemo	chika_cut1,demoobj_remove_force
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	D_SEN DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

d_sen_camx1	equ	-1980
d_sen_camy1	equ	-2965
d_sen_camz1	equ	-5210
d_sen_camvz	equ	100

d_sen_cut1	equ	2

	start_path	d_sendirector

childno_d_sen	equ	1
childno_d_sen_arwing	equ	2


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	p_setvar	w,p1_camrotzbuf,0
	p_setvar	w,player1_horizon_offset,SCR4_Hofs
	p_spawn	0,0,0,0,0,0,d_sen_2,d_sen,1,1,childno_d_sen
	p_spawn	0,0,(120+25)<<d_sens_scale,0,0,0,d_sen_0,d_sen_parts,1,1,childno_d_sen
	p_spawn	0,0,(033+25)<<d_sens_scale,0,0,0,d_sen_1,d_sen_parts,1,1,childno_d_sen
	p_spawn	0,0,(-90+25)<<d_sens_scale,0,0,0,d_sen_3,d_sen_parts,1,1,childno_d_sen
	p_spawn	0,-55<<d_sens_scale,(-40+25)<<d_sens_scale,0,0,0,d_sen_4,d_sen_parts,1,1,childno_d_sen
	p_spawn		d_sen_camx1,d_sen_camy1,d_sen_camz1,0,0,0,nullshape,d_sen_cam,1,1,childno_d_sen
	p_setdemo	d_sen_cut1
	p_Qspawn	nullshape,d_sen_watch,1,1
	p_become
	p_add		worldy,-1000
	p_add		worldz,d_sen_camz1+1700
	p_unbecome
	p_trigger	d_sen_always,always
	p_wait	8fh
	p_end
;------------------------------------------------------------------------------
; camera
	start_path	d_sen_cam
	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate
	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate
	p_collisions	off
	p_trigger	.always,always
	p_set		vz,d_sen_camvz
	p_set		vx,25-1
	p_set		vy,25+5+5
	p_spawn		150,0,-200,30,15,-30,nullshape,d_sen_arwing,1,1,childno_d_sen_arwing
	p_wait	10h
	p_do	20h
	p_add		vz,2
	p_next
	p_do		25
	p_add		vz,2
	p_next
	p_wait	55h-20h-10h-25
; stop
	p_set		vx,0
	p_set		vy,0
	p_set		vz,0
	p_end
.always	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate
	p_igoto			d_sen_always
;------------------------------------------------------------------------------
	start_path	d_sen_watch
	p_demoshape
	p_collisions	off
	p_trigger	.always,always
	p_set		vz,d_sen_camvz
	p_set		vy,1000/(18h+38h)
	p_wait	18h
	p_do	38h
	p_add	vz,3
	p_next
	p_set	vx,5
	p_set	vy,5
	p_set	vz,-65+5
	p_wait	70h-38h-18h
	p_set	vx,-3
	p_set	vy,-5
	p_end
.always	p_add		worldz,5
	p_igoto		d_sen_always
;------------------------------------------------------------------------------
	start_path	d_sen_beam
	p_collisions	off
	p_index		childx,.x,pbyte1
	p_index		childy,.y,pbyte1
	p_index		childz,.z,pbyte1
	p_add		worldx,childx
	p_add		worldy,childy
	p_add		worldz,childz
	P_SOUNDEFTDISTPOS	en_laser_sL
	p_trigger	d_sen_always,always
.a	p_findshape	a_wing
	p_shapedead	.b
	p_igoto		.face
.b	p_findshape	b_wing
	p_shapedead	.c
	p_igoto		.face
.c	p_findshape	c_wing
.face	p_faceshape	immediate
	p_setvel	120
	p_add		vx,vx
	p_add		vy,vy
	p_add		vz,vz
	p_add		vx,vx
	p_add		vy,vy
	p_add		vz,vz
	p_wait	32
	p_remove
.x	dw	-200
	dw	-600
	dw	-1000
.y	dw	-800
	dw	-600
	dw	-300
.z	dw	400
	dw	800
	dw	1000
;------------------------------------------------------------------------------
	start_path	d_sen
	p_trigger	.fire,8
	p_igoto		Pd_sen_parts
.fire	p_inc		pbyte1
	p_ifnotsame	pbyte1,4,.make
	p_set		pbyte1,0
.make	p_export	gbyte1,pbyte1
	p_Qspawn	warp,d_sen_beam,1,1
	p_become
	p_import	pbyte1,gbyte1
	p_unbecome
	p_return
;------------
	start_path	d_sen_parts
	p_set		depthoffset,3
	p_collisions	off
	p_trigger	d_sen_always,always
	p_wait		58h
	p_add		childx,100
	p_add		childy,800-50
	p_set		vz,60
	p_set		vy,-13
	p_wait		85h-58h
	p_set		vx,-10
	p_wait		8eh-85h
	p_setvel	0
	p_end
;------------------------------------------------------------------------------
	start_path	d_sen_arwing
	P_SOUND		p2_demo_arwing
	p_wait	10h
	p_set	pword1,0
	p_add	worldz,-200	;	0	;worldz,d_sen_camz1+800
	p_gosub		prou_player1shape_aw
	p_alwaysgenvecs	on
	p_setvel	70
	p_collisions	off
	p_trigger	.always,always
	p_accel		10,4
	P_SOUNDEFTDISTPOS	ob_throughobst_l
	p_do	13
	p_chase	childrotx,0
	p_add	childroty,-1
	p_next
	p_alwaysgenvecs	off
	p_accel	0,0
	p_do	20-2
	p_chase	vx,5
	p_add	vz,-2
	p_chase	childrotx,0
	p_add	childroty,-1
	p_chase	vy,-6
	p_next
	p_set	pword1,30
	p_set	pbyte1,1ch
	P_SOUNDEFTDISTPOS	ob_throughobst_l
	p_alwaysgenvecs	on
	p_setvel	20
	p_do	15+5
	p_chase	childrotx,-32
	p_next
	p_do	20
	p_chase	childrotz,40
	p_add	childroty,5
	p_add	childx,vx
	p_add	childrotx,1
	p_next
	p_do	9
	p_add	childx,vx
	p_add	childroty,5
	p_chase	childrotx,20
	p_next
	p_set	childrotz,0
	p_set	pbyte1,20h
	p_do	10
	p_chase	childroty,deg180+2+3
	p_chase	childrotx,20
	p_accel	40,40
	p_next
	p_wait	6dh-10-9-20-(15+5)-(20-2)-13-10h
	P_SOUNDEFFECT	ob_throughobst_l
	p_accel	20,2
	p_wait	4
	p_do	50
	p_chase	childrotx,0
	p_next
	p_end
.r000
.always	p_add		childx,pword1
	p_chase		pword1,0
	p_ifzero	pbyte1,.a0
	p_add		childrotz,pbyte1
	p_dec		pbyte1.a0
;----------------------------------------------------------------------------------
d_sen_always	p_ifnotdemo	d_sen_cut1,demoobj_remove_force
	p_add		worldz,5
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENTER D_SEN DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	enter_d_sendirector

childno_ed	equ	1
ed_cut1	equ	100
ed_cut2	equ	101

	P_SOUNDPLACE	ROOM

	p_setdemo	ed_cut1

	p_collisions	off

	p_gosub	prou_posrot0

	p_spawn	0,0,0<<kabe_dem_scale,0,0,0,kabe_ak4,meteo_ak4_x,1,1ah+60h,childno_ed
	p_spawn	60<<kabe_dem_scale,0,-(55<<kabe_dem_scale),0,deg180,0,KABE_DEM,e_nocol_s_off,1,1,childno_ed

	p_Qspawn	nullshape,ed_cam,1,1

	p_spawn		0,-120,-90<<kabe_dem_scale,0,0,0,nullshape,ed_arwing,1,1,childno_ed
	p_become
	p_demoshape
	p_unbecome

	p_end

;----------------------------------------------------------------------------
	start_path	ed_arwing

	p_gosub		prou_playershield

	p_demoshape
	p_trigger	ed_always,always
	p_collisions	off

	p_setvar	b,sdport1,%100
	p_trigger	prou_playerdmg,always
	p_playershape
	p_alwaysgenvecs	on

	p_setvel	40

	p_end

.always	p_return

;----------------------------------------------------------------------------
	start_path	ed_cam

	p_collisions	off
	p_add	worldx,-40
	p_add	worldy,-80
	p_add	worldz,-75<<kabe_dem_scale
	p_rtrigger	.always,always
	p_trigger	ed_always,always
	p_accel		30,1


	p_end


.always	p_copypos2view		1,immediate
	p_campandemoshape	1,3,immediate
	p_return

;----------------------------------------------------------------------------------

ed_always	p_ifnotdemo	ed_cut1,demoobj_remove_force

	p_return

;----------------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ARMADA DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	armadadirector

	p_setvar	b,demotaiman,dt_d_sen

	start_path	taimandirector

childno_a_d_sen	equ	20


	p_collisions	off

	p_setvar	w,player1_horizon_offset,SCR4_Hofs+0c0h

	;p_setvar	b,demotaiman,dt_ninja
	;p_setvar	b,demotaiman,dt_dragon
	;p_setvar	b,demotaiman,dt_d_sen
	;p_setvar	b,demotaiman,dt_stepup
	;p_setvar	b,demotaiman,dt_crusher
	;p_setvar	b,demotaiman,dt_d_sen2
	;p_setvar	b,demotaiman2,0
	;p_setvar	b,demotaiman2,dt_dragon
	;p_setvar	b,demotaiman2,dt_d_sen
	;p_setvar	b,demotaiman2,dt_stepup
	;p_setvar	b,demotaiman2,dt_crusher
	;p_setvar	b,demotaiman2,dt_d_sen2


	p_slope		off

	p_setdemo	1

	p_setvel	10

	p_gosub	prou_posrot0

;make camera

	p_Qspawn	nullshape,armada_cam,1,1

	p_end


;----------------------------------------------------------------------------------
	start_path	armada_cam

armada_zofs	equ	-500
armada_zofs2	equ	-200	;-600

	p_collisions	off

	p_gosub	prou_posrot0

	p_Qspawn	extra1_1,armada_suisei,1,1

	p_set	roty,deg180

	p_rtrigger	.pan,always

	p_import	ap,demotaiman
	p_import	pbyte1,Kdifficulty

;-----------------------------------------------------------------------------
;	p_ifnotsame	ap,dt_d_sen2,.d_sen2
;	p_Qspawn	d_sen_2s,armada_d_sen,5,68
;	p_Qspawn	d_sen_2s,armada_d_sen,6,90+15
;	p_igoto		.maked
;.d_sen2
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_d_sen,.d_sen

	p_ifzero	pbyte1,.easy
;normal,hard
	p_Qspawn	d_sen_22,armada_d_sen,1,255	;68
	p_Qspawn	d_sen_22,armada_d_sen,2,255	;90
	p_Qspawn	d_sen_ss,armada_d_sen_ss,3,90	;255
	p_Qspawn	d_sen_ss,armada_d_sen_ss,4,68	;255
	p_igoto		.maked

.easy	p_Qspawn	d_sen_22,armada_d_sen,1,68
	p_Qspawn	d_sen_22,armada_d_sen,2,90
	p_igoto		.maked

;.easy2	p_Qspawn	d_sen_22,armada_d_sen,5,68
;	p_Qspawn	d_sen_22,armada_d_sen,6,90+15
;	p_igoto		.maked

.d_sen
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_dragon,.dragon
	p_Qspawn	dragon_0,armada_dragon,62,30
.dragon
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_stepup,.stepup
	p_Qspawn	stepup_0,armada_stepup,72,1
.stepup
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_crusher,.crusher
	p_Qspawn	nullshape,armada_crusher,72-30,1
.crusher
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_ninja,.ninja
	p_Qspawn	ninja,armada_ninja,58h,1
.ninja
;-----------------------------------------------------------------------------


;-----------------------------------------------------------------------------
	p_set		ap,2
	p_ifnotsame	pbyte1,ap,.maked
	p_import	ap,demotaiman2
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_dragon,.dragon_x
	p_Qspawn	dragon_0,armada_dragon_x,62-20,1
.dragon_x
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_stepup,.stepup_x
	p_Qspawn	stepup_0,armada_stepup_x,40-20,1
.stepup_x
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_crusher,.crusher_x
	p_Qspawn	nullshape,armada_crusher_x,32-15-5,1
.crusher_x
;-----------------------------------------------------------------------------
	p_ifnotsame	ap,dt_ninja,.ninja_x
	p_Qspawn	ninja,armada_ninja_x,2dh-10,1
.ninja_x
;-----------------------------------------------------------------------------





;************
.maked
	p_do	2
	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate
	p_next

	p_end

.pan	p_copypos2view		1,immediate
	p_campandemoshape	1,1
	p_return


;---------------------------------------------------------------------------------------
;	start_path	armada_senkan
;
;	p_rtrigger	Parmada_stepup.always,always
;	p_igoto		Parmada_stepup.enter
;
;---------------------------------------------------------------------------------------
;	start_path	armada_stepup2
;	p_set		vy,-(armadacamdownvel>>1)
;	p_igoto		Parmada_stepup.enter
;
;---------------------------------------------------------------------------------------
	start_path	armada_d_sen

.nodemo	LOCAL

	p_gosub	prou_d_sen2

	p_sound	p2_d_sen_ss

	start_path	armada_d_sen_ss

	p_set	depthoffset,3

	p_set	pbyte1,hp
	p_dec	pbyte1
	p_index	worldx,armada_d_sen.x,pbyte1
	p_index	worldy,armada_d_sen.y,pbyte1
	p_index	worldz,armada_d_sen.z,pbyte1
	p_index	vz,armada_d_sen.vz,pbyte1
	p_index	vy,armada_d_sen.vy,pbyte1
	p_zero	rotx
	p_zero	roty
	p_zero	rotz

	p_ifsame	HP,5,.ds
	p_ifnotsame	HP,1,.nw
.ds	p_Qspawn	nullshape,armada_watch,1,1
.nw

	p_collisions	off

	p_set		count,AP

	p_do		count
	p_next

	p_Qspawn	nullshape,armada_warp,15,1

	p_wait	1

	p_quadvecs	on
	p_setvel	100

	p_set	vy,-20

	P_SOUNDEFFECT	en_dash_demo	;GAKKI

	p_wait		15

	p_set		shape,nullshape
	P_CIRCLEWINDOW	8,warp

	p_wait	4

	p_setvel	0

	p_remove	childno_a_d_sen
	p_remove

.end	p_end




	start_path	armada_d_sen_parts

	p_collisions	off

	p_set	depthoffset,3

	p_end




	start_path	armada_ninja_warp

	p_zero		roty
	p_zero		rotx

	p_index		pword1,armada_ninja_warp.nwx,ap
	p_add		worldx,pword1
	p_index		pword1,armada_ninja_warp.nwy,ap
	p_add		worldy,pword1

	p_set	vz,200<<2

	p_igoto		Parmada_warp.enter


	start_path	armada_warp_dragon
	p_set		vz,200<<2
	p_igoto		Parmada_warp.enter


	start_path	armada_warp
	p_set	vz,100<<2

.enter	LOCAL


	p_set	shape,warpl
	p_set	vy,-20


	p_collisions	off

	p_add	worldz,-130<<warpl_scale


	p_set	count,hp

	p_wait	count	;15
	p_set	vz,200<<2
	p_wait	5

	p_remove



	start_path	armada_watch

	p_demoshape

	p_set	vz,30

	p_add	worldx,-400
	p_add	worldy,400

	p_do	40
	p_add	worldy,-400/40
	p_add	worldx,400/40
	p_next

	p_wait	68-40

	p_set	vz,100<<2

	p_wait	20

	p_set	vz,0

	p_end

;---------------------------------------------------------------------------------------

	start_path	armada_ninja

	p_gosub		armada_demoshape_rou
;	p_demoshape

	p_add	worldx,200
	p_add	worldy,-1800
	p_add	worldz,-4000

	p_igoto	Parmada_ninja_x.enter


	start_path	armada_ninja_x

	p_add	worldx,3500
	p_add	worldy,-600	;800-600
	p_add	worldz,-5000

.enter	LOCAL

	p_set	vy,-5

	p_gosub	Parmada_stepup_x.init2

	p_alwaysgenvecs	on

	p_setvel	80

	p_setanim	0

	p_set	count,hp
	p_wait	count

	p_alwaysgenvecs	off

	P_QSPAWN	nullshape,armada_ninja_warp,12-5,0
	P_QSPAWN	nullshape,armada_ninja_warp,12-5,1
	P_QSPAWN	nullshape,armada_ninja_warp,12-5,2
	P_QSPAWN	nullshape,armada_ninja_warp,12-5,3

	p_accel	0,0

.warp	LOCAL

	P_SOUNDEFFECT	en_dash_demo	;GAKKI

	p_set	vz,200<<2
	p_set	vy,-20

	p_wait	10

	P_CIRCLEWINDOW	8,warp
	p_set	vz,0
	p_remove
	p_end



;---------------------------------------------------------------------------------------

	start_path	armada_crusher

	p_gosub		armada_demoshape_rou2

	p_demoshape

	p_set	vz,90

	p_add	worldx,200
	p_add	worldy,-1000
	p_add	worldz,-3000

	p_import	ap,Kdifficulty	;demotaiman2
	p_ifnotsame	ap,2,.self

	p_set	vz,120

.self
	p_igoto		Parmada_crusher_x.enter


	start_path	armada_crusher_x

	p_add	worldx,2800
	p_add	worldy,-400	;-1000
	p_add	worldz,-4000

	p_set		vz,90

.enter	LOCAL


	p_sound	p2_crusher

	p_gosub	Parmada_stepup_x.init2

	p_gosub	prou_crusher

	p_set		childroty,3

	p_rtrigger	.always,always

	p_set		count,hp
	p_wait		count

	p_do		20
	p_add		vz,-4
	p_add		childroty,1
	p_next

	p_wait		10

	P_QSPAWN	nullshape,armada_ninja_warp,12,0
	P_QSPAWN	nullshape,armada_ninja_warp,12,1
	P_QSPAWN	nullshape,armada_ninja_warp,12,3

	p_set		vz,200<<2

	p_igoto		Parmada_ninja_x.warp



.always	p_add	roty,childroty
	p_return

;------------

	start_path	armada_watch2

	p_add		worldx,1000

	p_demoshape

	p_set		vz,90

	p_wait		72
	p_wait		20
	p_wait		10

	p_set		vz,200<<2

	p_wait		10

	p_set		vz,0

	p_end

;------------
	start_path	armada_crusher_top

	P_SPAWN		0,0,-25<<spin_scale,0,0,0,spin_3,armada_crusher_parts,10,10,childno_dragon_body
	P_SPAWN		22<<spin_scale,0,12<<spin_scale,0,deg120,0,spin_3,armada_crusher_parts,10,10,childno_dragon_body
	P_SPAWN		-22<<spin_scale,0,12<<spin_scale,0,-deg120,0,spin_3,armada_crusher_parts,10,10,childno_dragon_body

	p_igoto		Parmada_crusher_bottom.enter

;------------

	start_path	armada_crusher_bottom

	P_SPAWN		0,0<<spin_scale,-25<<spin_scale,0,0,0,spin_4,armada_crusher_parts,10,10,childno_dragon_body
	P_SPAWN		22<<spin_scale,0<<spin_scale,12<<spin_scale,0,deg120,0,spin_4,armada_crusher_parts,10,10,childno_dragon_body
	P_SPAWN		-22<<spin_scale,0<<spin_scale,12<<spin_scale,0,-deg120,0,spin_4,armada_crusher_parts,10,10,childno_dragon_body

.enter	LOCAL

	p_gosub		Parmada_stepup_x.init2
	p_rtrigger	.always,always

	p_end




.always2	LOCAL
	p_add	childroty,-8
.always	LOCAL
	p_add	childroty,-8
	p_return

;------------
	start_path	armada_crusher_parts
	p_gosub		Parmada_stepup_x.init2
	p_end

;------------
	start_path	armada_crusher_arm

	p_gosub		Parmada_stepup_x.init2

	p_wait	30

	p_import	pbyte1,demoNo

	p_ifsame	pbyte1,demo_taiman,.taiman

	p_wait	120


.taiman	p_do	32
	p_add	childrotz,-2
	p_next

	p_end

;---------------------------------------------------------------------------------------

	start_path	armada_stepup

	p_gosub		armada_demoshape_rou
;	p_demoshape

	p_add	worldx,0
	p_add	worldy,1200
	p_add	worldz,-1400

	p_igoto	Parmada_stepup_x.enter


	start_path	armada_stepup_x

	p_add	worldx,1500
	p_add	worldy,-200
	p_add	worldz,-1700

.enter	LOCAL

	p_sound	p2_stepup_0

	p_gosub	.init2

	p_gosub	prou_armada_stepup_init

	p_become
	p_groundobj	on
	p_unbecome

;	p_export	gbyte1,hp
;	P_SPAWN		280,0,0,0,0,0,stepup_1,armada_stepup_arm,100,2,childno_dragon_body
;	p_become
;	p_import	count,gbyte1
;	p_unbecome
;	P_SPAWN		-280,0,0,0,0,0,stepup_1,armada_stepup_arm,100,2,childno_dragon_body
;	p_become
;	p_import	count,gbyte1
;	p_unbecome

	p_setvel	20
	p_set		vx,8
	p_set		vy,-20	;-30

	p_set		count,hp
	p_wait		count

	p_wait	10

	p_Qspawn	nullshape,armada_warp_dragon,10,1

;	p_become
;	p_add		worldz,0	;100<<2
;	p_unbecome

	P_SOUNDEFFECT	en_dash_demo	;GAKKI

	p_set	vz,200<<2
	p_set	vy,-20

	p_wait	10

	P_CIRCLEWINDOW	8,warp
	p_set	vz,0
	p_remove

	p_end



.init2	LOCAL

	p_collisions	off
	p_zero	rotx
	p_zero	roty
	p_zero	rotz

	p_return

;------------

	start_path	armada_stepup_arm

	p_collisions	off

	p_setanim	0


	p_add	count,-15
	p_wait	count

	p_do	7
	p_addanim	1,8
	p_next

	p_end

;---------------------------------------------------------------------------------------

	start_path	armada_dragon

	p_setvel	30

	p_gosub		armada_demoshape_rou

	p_add	worldx,500
	p_add	worldz,-900<<2

	p_trigger	.anim,always,32

	p_igoto		Parmada_dragon_x.enter


.anim	p_addanim	1,16

	p_ifnotsame	animframe,128+8,.ar
	P_SOUNDEFFECT	bs_cry_1
.ar	p_return


	start_path	armada_dragon_x

; !!don't use PBYTE1

	p_add	worldx,3000-1000
	p_add	worldz,-5500
	p_add	worldy,-1200+500

	p_setvel	60-10

	p_set		hp,30+30


.enter	LOCAL

	p_quadvecs	on

	p_alwaysgenvecs	on

	p_sound	p2_dragon

	p_setanim	0


	p_set	rotx,0
	p_set	roty,0
	p_zero	rotz


	p_gosub	prou_dragon
;	P_CLRBOSSFLAGS
;	p_collisions	off
;	p_spawn		0,0,-45,0,0,0,dragon_1,superdragon_body1,1,1,childno_dragon_body
;	P_START65816
;	s_set_objtobevar	y,becomelastobj&WM
;	stx			al_immuneptr,y
;	P_END65816

	p_set	childrotx,20

	p_zero		pbyte2
	p_rtrigger	.always,always

	p_set	count,hp
	p_wait	count


	p_trigger	.always,off

	p_accel	0,1

	p_do	10
	p_chase	rotx,0
	p_next

	p_gosub		dragon_warp_rou

	p_Qspawn	nullshape,armada_warp_dragon,10,1
	p_become
	p_add		worldy,100
	p_add		worldz,-1400<<2
	p_unbecome

;.warp	LOCAL

	p_alwaysgenvecs	off
	p_accel	0,0


	P_SOUNDEFFECT	en_dash_demo	;GAKKI
	p_set	vz,200<<2
	p_set	vy,-20

	P_CIRCLEWINDOW	8,warp
	p_set	vz,0
	p_remove
	p_end



.always	p_chase	rotx,childrotx

	p_inc		pbyte2
	p_ifnotsame	pbyte2,8,.sret1
	p_zero	pbyte2
	p_neg	childrotx
.sret1	p_return


;---------------------------------------------------------------------------------------
	start_path	armada_suisei

	p_import	pbyte1,demotaiman

	p_index	worldx,armada_suisei.x,pbyte1
	p_index	worldy,armada_suisei.y,pbyte1
	p_index	worldz,armada_suisei.z,pbyte1


.enter	LOCAL

	p_set	roty,-40h

	p_collisions	off

	p_groundobj	on

	p_set		depthoffset,3
	p_spawn		0,-50<<extra1_scale,0,0,deg180,0,extra1_0,armada_suisei_parts,10,10,1
	p_spawn		0,50<<extra1_scale,0,0,0,0,extra1_2,armada_suisei_parts2,10,10,2
	p_become
	p_set		depthoffset,1
	p_unbecome
	p_spawn		0,20<<extra1_scale,0,0,0,0,extra1_3,armada_suisei_parts,10,10,3

.loop	p_add		roty,1
	p_goto		.loop
	p_end


;------------

	start_path	armada_suisei_parts
	p_set		depthoffset,2

	start_path	armada_suisei_parts2
	p_collisions	off
	p_rangecheck	off
	p_groundobj	on
	p_end


;------------
armada_demoshape_rou

	p_import	tx,demotaiman2
	p_ifzero	tx,armada_demoshape_rou2.demo

	p_spawn	1000,0,0,0,0,0,nullshape,e_nocol_s_off,1,1,1
	p_become
	p_demoshape
	p_unbecome

armada_demoshape_rou2

	p_import	tx,kdifficulty
	p_ifnotsame	tx,2,.noofs

	p_import	tx,demotaiman
	p_index	hp,armada_taiman.hp,tx
	p_index	vel,armada_taiman.vel,tx

.noofs
	p_return



.demo	LOCAL
	p_demoshape
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	LOGO DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
LOGODEMO

logo_turnwait_time	equ	100

childno_logo_cam	equ	10
childno_logo_warp	equ	11


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	start_path	logodirector

	p_gosub	prou_posrot0

	p_spawn		0,0,0,0,0,0,nullshape,logocam,1,1,childno_logo_cam
	p_Qspawn	nullshape,logo_base,1,1

	p_alwaysgenvecs	on

	p_setvel	10

	p_do	80h

	p_import	pbyte1,tiw_sprmode

	p_ifnotsame	pbyte1,2,.cansel
	p_ifnotsame	pbyte1,1,.nobreak
.cansel	p_set		roty,-40h
	p_igoto		.next
.nobreak	p_andframegoto	1,.addy
	p_igoto		.next
.addy	p_add		roty,-1
.next	p_next

	p_end


;--------------------------------------------------------------------------------

	start_path	logocam

	p_collisions	off

	p_set		pword1,0

	p_rtrigger	.always,always

	p_do	80h

	P_START65816

	ldy	#viewblk1
	a16
	lda	tiw_sprmode
	and	#0ffh
	cmp	#1
	bpl	.pushed
	lda.w	al_roty,y
	clc
	adc	#80h
	sta.w	al_roty,y
	bra	.next

.pushed	lda	#4000h+8000h
	sta.w	al_roty,y

;	lda	#(512+256+128+128)>>1
	lda	#(512+256+128+128)>>2
	sta	player1hscroll_offset

	a8

	P_END65816


	P_becomemother
	p_setvel	-10
	p_unbecome

	p_next

	p_end



.next	a8
	P_END65816
	p_next

	p_end



.always	p_copypos2view	1,immediate
	p_return


;--------------------------------------------------------------------------------
	start_path	logo_base

	p_add	worldz,-1000
	p_add	worldy,-100
	p_add	worldx,1800

	p_add	rotx,0
	p_add	roty,deg180-4-deg90
	p_add	rotz,-10

	p_set	vz,10

	p_rtrigger	.always,always
	p_collisions	off
	p_gosub		prou_makebase
	p_wait		logo_turnwait_time-8


	p_do		61
	p_chase		rotz,10
	p_add		roty,2
	p_next

	p_quadvecs	on
	p_setvel	120

	p_add		vx,vx
	p_add		vy,vy

	p_add		vz,vz
	p_add		vx,vx

	p_add		vy,vy
	p_add		vz,vz

	p_gosub		.warp

	p_wait	32

.remove
	p_add	worldz,8000h
	p_add	worldy,8000h
	p_add	worldx,8000h

	p_remove


.always	P_START65816
	lda	tiw_sprmode
	cmp	#1
	bpl	.start
	P_END65816
	p_return



.start	P_END65816
	p_force	.remove
	p_return

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


	start_path	logo_base

.warp	LOCAL
	P_SOUNDEFFECT	en_dash_demo
	p_spawn	0,-(90-40)<<base_scale,-130<<warpl_scale,0,0,0,warpl,letsgo_warp,1,1,childno_logo_warp
	p_return


;---------------------------------------------------------------------------------------

;	start_path	logo_base_h
;
;	p_collisions	off
;	p_set	count,ap
;
;	p_wait	logo_turnwait_time-32
;	p_wait	count
;
;	p_do	32
;	p_add	childrotx,-2
;	p_next
;
;	p_remove

;----------------------------------------------------------------------------------

;	start_path	logo_arwing
;
;	p_collisions	off
;
;	p_index	worldx,.x,ap
;	p_index	worldy,.y,ap
;	p_index	worldz,.z,ap
;
;	p_alwaysgenvecs	on
;
;	p_setvel	40
;
;	p_set	rotz,-10
;
;	p_wait		15
;
;	p_findshape	base1_lf
;
;	p_do	30
;	p_faceshape
;	p_next
;	p_remove
;
;
;.x	dw	0
;	dw	0
;	dw	0
;.y	dw	0
;	dw	0
;	dw	0
;.z	dw	0
;	dw	0
;	dw	0
;


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GAMEOVERLOGO DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
GAMEOVERLOGODEMO

	start_path	gameoverlogodirector

	p_gosub	prou_posrot0

	p_Qspawn	nullshape,gameover,1,1

	p_set	rotx,10

	p_copypos2view	1,immediate
	p_copyrot2view	1,immediate

	p_end

;----------------------------------------------------------------------------------

	start_path	meteo_ak4_x

	P_SPAWN		0,200,300,0,128,0,ak4_beta,e_nocol_range_off,10,10,88
	P_BECOME
	P_GROUNDOBJ	ON
	P_UNBECOME


	start_path	meteo_ak4

	p_set	depthoffset,1

	p_collisions	off

	p_set		count,AP

	p_do	count
	p_setanim	11		;0
	p_next

	P_SOUNDEFTDIST	ob_demo_door

	p_do		11
	p_addanim	-1,12		;1,12
	p_next

	P_SOUNDEFTDIST	hatch_move_end

	p_do		30
	p_setanim	0		;11
	p_next

	p_end




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GAME STRAT DEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	scrambledirector

scramble_time_a	equ	50
scramble_time_b	equ	50
scramble_cam_y	equ	1000
scramble_cam_z	equ	-600

childno_scramble		equ	1
childno_scramble_boost1	equ	80
childno_scramble_boost2	equ	81
childno_scramble_boost3	equ	82
childno_scramble_clip	equ	83
childno_scramble_arwing1	equ	84
childno_scramble_arwing2	equ	85

	p_setvar	w,player1_horizon_offset,SCR4_Hofs+60h

	p_slope		off
	p_collisions	off
	p_setdemo	1

;make camera

	p_spawn	0,0,0,0,-20h,0,nullshape,scramblecam_carrier,1,1,childno_scramble
	p_spawn	0,0,0,0,0,0,nullshape,scramble_base,1,1,childno_scramble

	p_set	vz,5
	p_end

;----------------------------------------------------------------------------------
	start_path	scramblecam_carrier

	p_slope		off
	p_collisions	off

	p_spawn	0,scramble_cam_y,scramble_cam_z,0,0,0,nullshape,scramblecam,1,1,childno_scramble

	p_do	4ch	;-08h
	p_add	childroty,-1
	p_next

.loop	p_andframegoto	3,.next0
	p_igoto	.next1
.next0	p_add	childroty,-1
.next1	p_goto	.loop
	p_end







	start_path	scramblecam

	p_slope		off
	p_collisions	off

	p_wait		1

	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate

	p_rtrigger	.rot,always


	p_do	scramble_time_a
	p_add	childy,-scramble_cam_y/scramble_time_a
	p_add	childz,-1
	p_next



	p_do		16
	p_add		childz,-4
	p_andframegoto	1,.next1
	p_add		childy,-1
.next1	p_next

	p_trigger		.rot,off
	p_rtrigger		.rot2,always

	p_set		pbyte1,0

	p_do		40h
	p_add		childz,-4
	p_andframegoto	1,.next
	p_add		childy,-1
.next	p_next


.loop	p_inc		pbyte1
	p_ifnotsame	pbyte1,14h,.next2
	p_Qspawn	nullshape,scramble_arwing_d,22,22
.next2	p_goto		.loop

.rot	p_campandemoshape	1,0,immediate
	p_copypos2view	1
	p_return

.rot2	p_campandemoshape	1,1,immediate
	p_copypos2view	1
	p_return


;-------------------------------------------------------------------------------------------
;	SHAPE
;-------------------------------------------------------------------------------------------
	a8i16

	start_path	scramble_base

	p_collisions	off

	p_spawn		-500,500,200,64,0,0,inseki_2,scramble_inseki_snd,10,10,childno_scramble
	p_spawn		0,0,2900,64,0,0,inseki_2,scramble_inseki,10,10,childno_scramble

	p_spawn		0,0,80<<base_scale,64,0,0,clipshape,scramble_clip,10,10,childno_scramble_clip
	p_gosub		prou_makebase

	p_Qspawn	nullshape,scramble_arwing_p,10,24
;	p_spawn		-55<<base_scale,0,40<<base_scale,0,0,0,nullshape,scramble_arwing_p,10,102,childno_scramble_arwing2
	p_Qspawn	nullshape,scramble_arwing_p_c,10,23

	p_wait		52h

	p_gosub		prou_makebase_h.h
	p_spawn		-55<<base_scale,15<<base_scale,80<<base_scale,0,0,0,base_h1,scramble_base_h,10,8,childno_scramble
	p_spawn		55<<base_scale,15<<base_scale,80<<base_scale,0,0,0,base_h,scramble_base_h_s,10,1,childno_scramble

	p_wait		1
	p_remove	childno_base_lh
	p_remove	childno_base_rh
	p_end



	start_path	scramble_base_h_s2
	p_set		pbyte1,1

	start_path	scramble_base_h2
	p_collisions	off
	p_wait	127

	p_set		pbyte2,255

	p_igoto		Pscramble_base_h




	start_path	scramble_base_h_s

	p_set		pbyte1,1

	start_path	scramble_base_h

	p_collisions	off

	p_set	count,ap

	p_do	count
	p_next

	p_ifzero	pbyte1,.se
	P_SOUNDEFTPOS	ob_mothership_hatch	;GAKKI
.se
	p_do	32
	p_add	childrotx,2
	p_next

	P_SOUNDEFTPOS	hatch_move_end		;GAKKI

	p_ifsame	pbyte2,255,.close

	p_end


;------------

.close	p_wait	100

.close2	LOCAL

	P_SOUNDEFTDISTPOS	ob_mothership_hatch	;GAKKI
	p_do		10h
	p_add		childrotx,-4
	p_next
	P_SOUNDEFTDISTPOS	hatch_move_end	;GAKKI
	p_end


;-----------------------------------------------------------------------------
	start_path	scramble_inseki_snd

	p_collisions	off

	p_set	vz,-10

	p_wait	1

	P_SOUND		p2_inseki

	p_rtrigger	.sound,always

	p_igoto		Pscramble_inseki

.sound	p_inc	pbyte1
	p_ifsame	pbyte1,50,.stop
	p_return
.stop	P_SOUND		port2_stop
	p_return


	start_path	scramble_inseki

	p_collisions	off

	p_set	vz,-10

.loop	p_inc	childrotx
	p_inc	childroty
	p_inc	childrotz
	p_goto	.loop





;-----------------------------------------------------------------------------
	start_path	scramble_clip

	p_groundobj	on
	p_collisions	off

	p_end

;-----------------------------------------------------------------------------

	start_path	scramble_arwing_p_c

	p_gosub	Pes0_cam.pos

	p_set	vz,5

	P_GOSUB		set_friend_shape

	p_gosub		Pscramble_arwing_p.init
	p_wait		97	;count
	p_accel		40,1
	p_wait		20

	p_gosub	prou_demoboost

	p_wait		10h

	p_remove

;-----------------------------------------------------------------------------

	start_path	scramble_arwing_p

	p_set	vz,5

	p_gosub	Pes0_cam.pos

	p_spawn		0,0,0,0,0,0,nullshape,scramble_watch,10,10,childno_scramble

	p_playershape
	p_gosub		.init

	p_wait		102

	P_SOUND		p2_demo_arwing

	p_accel		40,1
	p_wait		20

	p_gosub	prou_demoboost

	p_wait		0ch
	P_SOUNDEFTPOS	ob_throughObst_L
	p_wait		4h

	p_alwaysgenvecs	on
	p_rtrigger	.always,always
	p_wait	4
	p_do		4
	p_chase		rotz,-30
	p_next
	p_do		10
	p_chase		rotz,0
	p_next
	p_end


.always	p_dec	rotx
	p_return



.init	LOCAL

	p_set		clip,plane_BOSS
	p_collisions	off
	p_set		count,ap

	p_return



	start_path	scramble_watch

	p_collisions	off
	p_demoshape
	p_wait	scramble_time_a
	p_do	30
	p_add	childx,+(55<<base_scale)/30
	p_next
	p_wait	112-30-scramble_time_a
	p_do	40
	p_add	childx,-(55<<base_scale)/40
	p_next
	p_end




	start_path	scramble_arwing_d

	P_GOSUB		set_friend_shape

	p_collisions	off

	p_gosub	Pes0_cam.pos

	p_alwaysgenvecs	on
	p_setvel	60


	p_set	rotx,-4


	p_gosub	prou_demoboost

	P_SOUNDEFTPOS	ob_throughObst_L
	p_rtrigger	.always,always
	p_wait	2
	p_do	6
	p_chase	rotz,-30
	p_add	roty,-2
	p_next
	p_end



.always	p_add	rotx,-1
	p_return



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CLEARDEMO(ROBOT)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	start_path	clrrbofdirector


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	p_demoshape
	p_collisions	off
	p_setdemo	1
	P_START65816
	ldy	playpt1
	toheap	y,y
	lda	exal_rotyoffset+1,y
	nega
	sta	al_childroty,x
	P_END65816
	p_set		pword1,worldy
	p_wait		1
	p_rtrigger	.always,always
	p_spawn		0,0,0,0,0,0,nullshape,clrrbofcam_carrier,1,1,childno_clrdemo1
	p_spawn		50<<1,-50h<<1,-40h<<2,20h,0,0,nullshape,clrrbofarwing,1,1,childno_clrdemo1
	p_wait		2dh-5
;	p_spawn		0,0,0,0,0,0,c_wing,e_nocol_s_off,1,1,childno_clrdemo1
;	p_spawn		0,0,0,0,0,0,c_wing,clrrbof_watch,1,1,childno_clrdemo1
;.loop	P_START65816
;	ldy	pathplayer&WM
;	s_copy_alvar2alvar	W,x,al_worldx,y,al_worldx
;	s_copy_alvar2alvar	W,x,al_worldz,y,al_worldz
;	P_END65816
;
;	p_chase		childroty,0
;
;	p_goto	.loop
	p_end
.always	P_START65816
	ldy	pathplayer&WM
	s_copy_alvar2alvar	W,x,al_worldx,y,al_worldx
	s_copy_alvar2alvar	W,x,al_worldz,y,al_worldz
	P_END65816
	p_chase		childroty,0
	p_return
;----------------------------------------------------------------------------------
	start_path	clrrbofcam_carrier
	p_collisions	off
	p_set		pword1,worldy
	p_wait		1
	p_spawn		0,0,-125,0,0,0,nullshape,clrrbofcam,1,1,childno_clrdemo1
	p_rtrigger	prou_faceclrdemoshape,always
	p_end
;----------------------------------------------------------------------------------
	start_path	clrrbofarwing
	P_SOUND		p2_demo_arwing	;GAKKI
	P_GOSUB		set_friend_shape
;	p_gosub		prou_friendshape_aw
	p_rtrigger	.always,always
	p_alwaysgenvecs	on
	p_setvel	20h
	p_collisions	off
	p_set		pword1,worldy
	p_do		10h
	p_chase		vel,0
	p_chase		childrotx,0
	p_add		childy,vy
	p_next
	p_do		10h
	p_chase		childx,0
	p_chase		childrotx,0
	p_chase		childrotz,50
	p_next
	p_do		5
	p_chase		childx,0
	p_chase		childz,0
	p_chase		childrotz,-20
	p_next
	p_spawn		0,-30,0,0,0,0,a_wing_1,clrrbofrb,1,1,childno_clrdemo1
	p_do		4
	p_chase		childx,0
	p_chase		childy,40
	p_next
	p_do		4
	p_chase		childx,0
	p_chase		childy,0
	p_next
	p_spawn		0,0,-20,0,0,0,boost,demoboost,1,1,childno_clrdemo1
	p_demoshape
	p_do		45
	p_chase		childrotz,0
	p_add		childrotx,-1
;	p_add		childroty,-1
	p_accel		80,5
	p_next
;	p_do		40
;	p_accel		80,5
;	p_add		childrotx,-1
;	p_add		childroty,-1
;	p_next
	p_end
.always	P_START65816
	ldy	pathplayer&WM
	lda.w	al_roty,y
	ldy	al_childrotobj,x
	sec
	sbc.w	al_roty,y
	sta	al_childroty,x
	P_END65816
	p_chase	childz,-50
	p_return
;----------------------------------------------------------------------------------
	start_path	clrrbof_watch
	p_collisions	off
;	p_demoshape
	p_accel		50,5
	p_end
;----------------------------------------------------------------------------------
	start_path	clrrbofcam
	p_collisions	off
	p_wait	1
	p_rtrigger	.always,always
	p_end
.always	p_copypos2view		1,immediate
	p_campandemoshape	1,1
	p_return
;----------------------------------------------------------------------------------
	start_path	clrrbofrb
	p_collisions	off
	p_import	pbyte1,p1_pilotNo
	p_index		shape,wingman_RB_shape,pbyte1
	p_index		coltab,wingman_RB_col,pbyte1
.loop	p_setanim	1
	p_goto		.loop
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC




prou_ramdomexpsound
	p_randomgoto		.SE
	p_randomgoto		.SE2
.SE1	P_SOUNDEFTDISTPOS	en_explode_s
	p_return
.SE2	P_SOUNDEFTDISTPOS	en_explode_demo
.SE	p_return

;----------------------------------------------------------------------------------
prou_friendNo_shape

	P_START65816
	jsl	friendNo_shape_srou_l
	P_END65816

	p_return

;----------------------------------------------------------------------------------
prou_armada_stepup_init

	p_export	gbyte1,hp

	P_SPAWN		-280,0,0,0,0,0,stepup_1,armada_stepup_arm,100,2,childno_dragon_body
	p_become
	p_import	count,gbyte1
	p_unbecome

	P_SPAWN		280,0,0,0,0,0,stepup_1,armada_stepup_arm,100,2,childno_dragon_body
	p_become
	p_import	count,gbyte1
	p_unbecome

	p_return

;----------------------------------------------------------------------------------

;prou_facegotodemoshape	; kichi,d_sen ni totsunyu- suru tsunagi de tsu kau.
;
;	P_START65816
;	ldy	dummyobj
;	a16
;	lda	corex
;	sta.w	al_worldx,y
;	lda	#0
;	sta.w	al_worldy,y
;	lda	corez
;	sta.w	al_worldz,y
;	tya
;	sta	al_pword1,x
;	a8
;	s_jmp_distless	x,y,#800,.notface
;	P_END65816
;
;	p_swapvar	pword1,ptr
;
;	p_push		roty
;	p_faceshape	immediate
;	p_set		childroty,roty
;	p_pull	roty
;
;	P_START65816
;	lda	al_childroty,x
;	sec
;	sbc	al_roty,x
;	asra
;	sta	tpz
;	s_achase_alvar	B,x,al_rotz,tpz,3
;	P_END65816
;
;	p_chase	roty,childroty
;
;	p_swapvar	pword1,ptr
;	p_return
;
;
;.notface	P_END65816
;	p_return
;

;prou_faceclrdemoshape
;
;	P_START65816
;	ldy	dummyobj
;	a16
;	lda	clrdemoshape_x
;	sta.w	al_worldx,y
;	lda	clrdemoshape_y
;	sta.w	al_worldy,y
;	lda	clrdemoshape_z
;.enter	LOCAL
;	sta.w	al_worldz,y
;	tya
;	sta	al_pword1,x
;	a8
;	P_END65816
;
;
;	p_push	roty
;
;	p_swapvar	pword1,ptr
;
;	p_faceshape	immediate
;
;	p_player	1
;	P_START65816
;	ldy	pathplayer&WM
;	lda	al_roty,x
;	sec
;	sbc.w	al_roty,y
;	sta	tpy
;	s_achase_alvar	B,x,al_childroty,tpy,3
;
;	lda	tpy
;	asra
;	sta	tpz
;
;	s_achase_alvar	B,x,al_childrotz,tpz,3
;
;	P_END65816
;
;	p_pull	roty
;
;
;.notface	p_swapvar	pword1,ptr
;	p_return
;



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	clear demo (space)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	clrawof

	p_zero		pbyte2

	p_collisions	off

	p_trigger	prou_playerdmg,always
	p_playershape

	p_set	childrotz,30h

	p_rtrigger	.always1,always

	p_alwaysgenvecs	on

	p_Qspawn	nullshape,clrawof_watch,1,1

	p_do	8
	p_accel	25,5
	p_add	rotx,-1
	p_next

	p_accel		0,0
	p_setvel	35

	P_SOUNDEFFECT	boost

	p_spawn		0,0,-20,0,0,0,boost,demoboost,100,100,childno_clrdemo1

	p_trigger	.always1,off

	p_import	childx,player1_vx
	p_import	childz,player1_vz

	p_trigger	.always2,always


	p_do	2
	p_add	rotx,-1
	p_next

	p_do	20
	p_add	rotx,-1
	p_next


	p_end


.always1	p_add	rotz,childrotz
	p_chase	childrotz,0
	p_return


.rz	LOCAL
	p_index	rotz,rotzofsdat,pbyte2
	p_inc	pbyte2
	p_ifnotsame	pbyte2,32,.rzrt
	p_set		pbyte2,0
.rzrt	p_return



.always2	LOCAL

	p_add	worldx,childx
	p_add	worldz,childz
	p_chase	rotz,0
	p_return


;----------------------------------------------------------------------------------

	start_path	clrawof_watch

	p_collisions	off

	p_trigger	Pclrawof.always2,always

	p_import	childx,player1_vx
	p_import	childz,player1_vz

	P_START65816

	jsl	clrawof_watch00_path_l

	P_END65816

	p_wait	8

	p_demoshape

	p_set	rotx,-10

	p_setvel	30

	p_end


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	DESTRUCTION DIRECTOR
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
DESTRUCTDEMO
	start_path	destructdirector

destruct_space	equ	1
destruct_ground	equ	2
destruct_gameover	equ	3

destruct_space_camx	equ	0
destruct_space_camy	equ	0
destruct_space_camz	equ	0

destruct_ground_camx1	equ	0e1h
destruct_ground_camy1	equ	-1cch	;0fe34h
destruct_ground_camz1	equ	0200h	;5c0h

destruct_ground_camx2	equ	0e1h
destruct_ground_camy2	equ	-1cch	;0fe34h
destruct_ground_camz2	equ	-2dfh	;0fd21h

destruct_space_cam_time0	equ	100
destruct_ground_cam_time0	equ	80

destruct_ground_camz_rate	equ	(destruct_ground_camz1-destruct_ground_camz2)/destruct_ground_cam_time0


childno_destruct	equ	1

	p_trigger	DESTRUCT_REMOVE,always

	P_SOUNDPLACE	space

; boss meter off

	p_collisions	off

	p_gosub	prou_posrot0

;----------------------------------------------------------------------------
; space
;;;;	P_SOUNDEFFECT	en_tekikan_demo	; GAKKI0

	p_setdemo	destruct_space

	p_setbg		attackcorneriademo

	p_setvar	w,player1_horizon_offset,SCR4_Hofs+60h-8
	p_setvar	w,player1hscroll_offset,0

	p_Qspawn	nullshape,destructcam,1,27

.space0	p_ifnotdemo	destruct_space,.ground
	p_goto		.space0

;----------------------------------------------------------------------------
; ground

.ground
	P_SOUNDEFFECT	stop_tr5	; GAKKI0
	P_SOUNDEFFECT	stop	; GAKKI0

	p_fadein
	p_setbg		explodecorneriademo

	p_setvar	w,player1_horizon_offset,SCR2_Hofs-10h-10h

	p_spawn		0,-1000-400,2000,0,0,0,nullshape,destruct_g_look,1,1,3
	p_spawn		0,-500,2000,68,-4,0,clipshape,destruct_g_clip,1,1,4
	p_spawn		00000,-25<<extra1s_scale,1000,0,deg270,0,extra1_0s,destruct_g_buil0,1,1,5

	p_Qspawn	machi_0_3,destruct_g_buil0,1,0
	p_Qspawn	machi_0_3,destruct_g_buil0,1,1

	p_Qspawn	machi_0_2,destruct_g_buil0,1,2
	p_Qspawn	machi_0_2,destruct_g_buil0,1,3
	p_Qspawn	machi_0_2,destruct_g_buil0,1,4
	p_Qspawn	machi_0_2,destruct_g_buil0,1,5
	p_Qspawn	machi_0_2,destruct_g_buil0,1,6

	p_wait		5

	P_SOUNDEFFECT	talking02

	p_trigger	.exp1,4
	p_wait		40
	p_trigger	.exp1,off
	p_trigger	.exp2,4
	p_wait		50
	p_trigger	.exp2,off

.ground0	p_ifnotdemo	destruct_ground,.gameover
	p_goto		.ground0

.gameover	p_Qspawn	nullshape,corneriafell,1,1

.gameover0	p_ifnotdemo	destruct_gameover,.remove
	p_goto		.gameover0

.remove	p_remove










.exp1	p_qspawn	explosion3,cds_explode,1,0
	p_become


	p_addrandom	worldx,127
	p_addrandom	worldy,512
	p_addrandom	worldz,127

	p_add	worldz,900+64
	p_add	worldy,-400+256

	p_igoto	.exp00


.exp2	p_qspawn	explosion3,cds_explode,1,0

	p_become


	p_addrandom	worldx,2047
	p_addrandom	worldy,255
	p_add		worldy,-300+128
	p_addrandom	worldz,512


.exp00
	P_SOUNDEFTDISTPOS	en_explode_demo

	p_unbecome

	p_return


;----------------------------------------------------------------------------------

	start_path	destructcam

	p_collisions	off

.space
	p_gosub	Pes0_cam.pos	; set AP = 27

;	p_set		worldx,destruct_space_camx
;	p_set		worldy,destruct_space_camy
;	p_set		worldz,destruct_space_camz

	p_Qspawn	batabata,destruct_s_drop0,1,0
	p_Qspawn	batabata,destruct_s_drop0,1,1
	p_Qspawn	batabata,destruct_s_drop0,1,2
	p_Qspawn	batabata,destruct_s_drop1,1,3
	p_Qspawn	batabata,destruct_s_drop0,1,4
	p_Qspawn	batabata,destruct_s_drop0,1,5
	p_Qspawn	batabata,destruct_s_drop0,1,6


.endinit	p_setvel	30

	p_wait		1
	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate

.space0	p_ifnotdemo	destruct_space,.ground
	p_copypos2view	1,immediate
	p_campandemoshape	1,1	;,immediate


	p_andframegoto		7,.exp
	p_igoto			.noexp

.exp	p_spawn	600,500,600,0,0,0,explosion5,destruct_s_exp,1,1,16
.noexp
	p_goto			.space0


.ground
	p_inc	ap
	p_gosub	Pes0_cam.pos	; set AP = 28

;	p_set		worldx,destruct_ground_camx1
;	p_set		worldy,destruct_ground_camy1
;	p_set		worldz,destruct_ground_camz1

	p_copypos2view		1,immediate	; init
	p_campandemoshape	1,0,immediate

	p_alwaysgenvecs	on
	p_set		roty,deg180
	p_setvel	destruct_ground_camz_rate



.fc
	p_spawn		-1100,-2300,-2300,64,-40,10,batabata,destruct_g_enemy_facecamera,1,17,17
	p_spawn		-600,-1800,-2000,64,-40,20,batabata,destruct_g_enemy_facecamera,1,20,18

.maked
	p_set		pbyte1,0

	p_do		destruct_ground_cam_time0-4
	p_inc		pbyte1

	p_import	pbyte2,demono
	p_ifnotsame	pbyte2,demo_destruct_enemy,.nomake

	p_ifnotsame	pbyte1,52,.nomake

	p_spawn	-200,-300,100,17,deg180+10,7,batabata,destruct_g_enemy_goaway,1,1,19
	p_spawn	-30,-150,200,17,deg180+10,7,batabata,destruct_g_enemy_goaway,1,1,20

.nomake
	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate

	p_next


.ground0
	p_andframegoto	1,.noaccl
	p_accel		0,1
.noaccl

	p_ifnotdemo		destruct_ground,.gameover
	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate

	p_goto		.ground0



.gameover
.gameover0


	p_gosub	prou_posrot0

;	p_set	worldx,0
;	p_set	worldy,0
;	p_set	worldz,0

	p_set	rotx,10

;	p_set	roty,0
;	p_set	rotz,0

	p_copypos2view		1,immediate
	p_copyrot2view		1,immediate

;	p_set		pword1,80h
;	p_export	player1hscroll_offset,pword1


;	p_wait	25
;
;	p_do	10
;	p_inc	rotx
;	p_copyrot2view		1,immediate
;	p_next

.end	p_end


;OO	.pos	p_copypos2view	1,immediate
;OO		p_return

;----------------------------------------------------------------------------------
; SHAPE(SPACE)
;----------------------------------------------------------------------------------

;	start_path	destruct_s_missile
;	p_demoshape
;	p_igoto		Pdestruct_s_drop0.enter

	start_path	destruct_s_drop1
	P_SOUND		p2_zako_0	; GAKKI0
	p_demoshape


	start_path	destruct_s_drop0

	p_index	worldx,destruct_s_drop0.cx,ap
	p_index	worldy,destruct_s_drop0.cy,ap
	p_index	worldz,destruct_s_drop0.cz,ap
	p_index	count,destruct_s_drop0.count,ap
	p_set	rotx,20

.enter	LOCAL

	p_gosub		destruct_g_init

	p_alwaysgenvecs	on

	p_quadvecs	on
	p_setvel	32

	p_trigger	DESTRUCT_S_REMOVE,always


	p_do		count

; for missile's rotation

	p_add		childrotz,childroty
	p_setanim	0
	p_next

.loop	p_setanim	8
	p_add		rotx,1
	p_add		rotz,-3
	p_add		roty,-2
	p_goto		.loop





	start_path	destruct_s_exp

	p_gosub		destruct_g_init

	p_sprite	0,48

	p_unlinkchild

	p_addrandom	worldx,03ffh
	p_addrandom	worldz,03ffh
	p_add		worldy,400

	P_SOUNDEFTDISTPOS	en_explode_demo	; GAKKI0

	p_do	3
	p_add	tx,-6
	p_next

	p_do	5
	p_setcolanim	3
	p_add	tx,-6
	p_next
	p_remove



	start_path	destruct_s_tekikan3
	p_setvel	40
	p_igoto		pdestruct_s_tekikan.enter
	start_path	destruct_s_tekikan2
	p_setvel	45
	p_igoto		pdestruct_s_tekikan.enter
	start_path	destruct_s_tekikan
	p_setvel	50

.enter	LOCAL
	p_gosub		destruct_s_init
	p_trigger	DESTRUCT_S_REMOVE,always
	p_set		depthoffset,3
	p_end

;----------------------------------------------------------------------------------
; SHAPE(GROUND)
;----------------------------------------------------------------------------------

	start_path	destruct_g_look

	p_demoshape

	p_trigger	DESTRUCT_G_REMOVE,always

	p_collisions	off
	p_set		pword1,40	; vel y

.loop	p_ifzero	pword1,.noadd
	p_add		pword1,-1
	p_add		childy,pword1
.noadd	p_add		childrotz,2
	p_add		childroty,-1
	p_add		childrotx,1
	p_goto	.loop

;-----------------------------------------------------------------------------
	start_path	destruct_g_clip

	p_trigger	DESTRUCT_G_REMOVE,always

	p_groundobj	on
	p_collisions	off
	p_wait	destruct_ground_cam_time0-20

.loop	p_add		childz,-30
	p_goto	.loop

;-----------------------------------------------------------------------------

	start_path	destruct_g_buil0

	p_groundobj	on

	p_set		pbyte2,8
	p_set		pbyte1,ap
	p_add		pbyte1,ap

	p_trigger	DESTRUCT_G_REMOVE,always

	p_set		depthoffset,3

	p_index		worldx,destruct_g_buil0.x,ap
	p_index		worldz,destruct_g_buil0.z,ap
	p_gosub		destruct_g_init

	p_wait		40

	p_set		clip,plane_BOSS2

	p_end

;----------------------------------------------------------------------------------

	start_path	destruct_g_enemy_facecamera

	P_SOUND		p2_zako_0	;GAKKI0

	p_trigger	DESTRUCT_G_REMOVE,always

	p_unlinkchild

	p_set		pbyte1,12
	p_set		count,ap

	p_gosub		destruct_g_init
	p_set		depthoffset,1

	p_setvel	90

	p_alwaysgenvecs	on

	p_set	ptr,viewblk1

	p_do		count
	p_andframegoto	1,.noface
	p_faceshape
.noface	p_next

	p_do		pbyte1
	p_andframegoto	3,.fire
	p_igoto		.notfire
.fire	p_qspawn	laser_0,destruct_g_enemy_laser0,1,1

	;;;;P_SOUNDEFTDISTPOS	en_laser_sL	;GAKKI

.notfire
	p_faceshape
	p_next

	p_do		20
	p_add		rotx,-2
	p_add		roty,1
	p_next

	p_remove

;----------------------------------------------------------------------------------

	start_path	destruct_g_enemy_goaway

	P_SOUND		p2_zako_0	;GAKKI

	p_trigger	DESTRUCT_G_REMOVE,always

	p_set		depthoffset,1

	p_gosub		destruct_g_init

	p_unlinkchild

	p_setvel	100
	p_alwaysgenvecs	on

	p_do		15
	p_add		rotx,-2
	p_add		roty,1
	p_andframegoto	3,.fire
	p_igoto		.notfire
.fire	p_qspawn	laser_0,destruct_g_enemy_laser1,1,1

	;;;;P_SOUNDEFTDISTPOS	en_laser_sL	;GAKKI

.notfire	p_next

	p_do		20
	p_add		rotx,-2
	p_add		roty,1
	p_next

	p_remove

;----------------------------------------------------------------------------------

	IFEQ	1
	start_path	destruct_g_exp
	p_gosub		destruct_g_init
	p_rtrigger	DESTRUCT_G_REMOVE,always
	p_sprite	0,32
	p_setrandom	pword1,255
	p_add		pword1,pword1
	p_add		pword1,pword1
	p_add		pword1,-200h
	p_add		worldx,pword1
	p_setrandom	pword1,07fh
	p_add		pword1,60h
	p_add		worldy,pword1
	p_setrandom	pword1,255
	p_add		pword1,pword1
	p_add		pword1,pword1
	p_add		pword1,300		;-100h+500
	p_add		worldz,pword1
	P_SOUNDEFTDISTPOS	en_explode_demo	;GAKKI0
.anim	p_do	8
	p_next
	p_remove
	ENDC

;----------------------------------------------------------------------------------
	start_path	destruct_g_enemy_laser1

	p_set		rotx,20

	start_path	destruct_g_enemy_laser0

	p_add		rotx,-5

	p_setvel	127
	p_set		depthoffset,1

	p_trigger	DESTRUCT_G_REMOVE,always

	p_gosub		destruct_g_init

	p_wait		10

	P_SOUNDEFTDIRECT	en_explode_s,far
	p_qspawn	explosion5,e_explode_buil_nosound_l,10,1

	p_remove




	start_path	e_explode_buil_nosound_l

	p_sprite	0,64
	p_set		ap,15	; size(see e_sp_explosion)
	p_igoto		pe_sp_explosion.same	;start

;----------------------------------------------------------------------------------

;	start_path	destruct_g_enemy_missile
;
;	p_trigger	DESTRUCT_G_REMOVE,always
;
;	p_add	worldx,5000
;	p_add	worldy,-10000+1000
;	p_add	worldz,3500
;
;	p_set		rotx,45
;	p_set		roty,80
;	p_setvel	127
;
;	p_set		depthoffset,1
;
;	p_gosub		destruct_g_init
;
;	p_do		5eh
;	p_add		rotz,5
;	p_next
;
;	p_remove


destruct_s_init

destruct_g_init

	p_collisions	off
	p_return


;-------------------------------------------------------------------------
DESTRUCT_S_REMOVE

	p_ifnotdemo	destruct_space,DESTRUCT_REMOVE.do
	p_return

;-------------------------------------------------------------------------
DESTRUCT_G_REMOVE

	p_ifnotdemo	destruct_ground,DESTRUCT_REMOVE.do
	p_return

;-------------------------------------------------------------------------
DESTRUCT_REMOVE

	p_ifdemoend	.do
	p_return

.do	LOCAL
	p_set		shape,nullshape
	p_force		DEMOOBJ_REMOVE
	p_return

	printf	"Destruct length = ",*-DESTRUCTDEMO,"%n"

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	SUISEIDEMO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DEMO0START	start_path	suiseidirector

;------------------------------------------------
childno_suisei_aw0	equ	70
childno_suisei_aw1	equ	71
childno_suisei_aw2	equ	72
childno_suisei	equ	73
;------------------------------------------------
suisei_warp		equ	1
;suisei_attack	equ	2
;suisei_charge	equ	3
suisei_enter		equ	2
suisei_into		equ	3
suisei_final		equ	4

suisei_attack_camx	equ	-200
suisei_attack_camy	equ	0
suisei_attack_camz	equ	5000

;suisei_charge_camx	equ	0h
;suisei_charge_camy	equ	0f011h
;suisei_charge_camz	equ	0f22eh
;------------------------------------------------
suisei_enter_camx	equ	0fff7h
suisei_enter_camy	equ	0fe7ah
suisei_enter_camz	equ	0f709h

suisei_enter_laserx	equ	(suisei_enter_camx+20)&WM
suisei_enter_lasery	equ	(suisei_enter_camy-80)&WM
suisei_enter_laserz	equ	suisei_enter_camz

;suisei_enter_enemy2x	equ	(suisei_enter_camx-1200-200)&WM
;suisei_enter_enemy2y	equ	(suisei_enter_camy+1200)&WM
;suisei_enter_enemy2z	equ	(suisei_enter_camz+1000+400)&WM

;suisei_enter_enemy1x	equ	(suisei_enter_camx-1200)&WM
;suisei_enter_enemy1y	equ	(suisei_enter_camy+1300)&WM
;suisei_enter_enemy1z	equ	(suisei_enter_camz+1000+1000)&WM

;suisei_enter_enemy0x	equ	(suisei_enter_camx-1200)&WM
;suisei_enter_enemy0y	equ	(suisei_enter_camy+1200)&WM
;suisei_enter_enemy0z	equ	(suisei_enter_camz+1000)&WM

;------------------------------------------------

suisei_into_camx	equ	000ffh
suisei_into_camy	equ	00078h
suisei_into_camz	equ	0f82bh

	P_SOUNDPLACE	space

	p_setvar	w,player1_horizon_offset,SCR4_Hofs+0c0h

	p_trigger	suiseiremove,always

	p_collisions	off

	p_zero		worldx
	p_zero		worldy
	p_zero		worldz
	p_zero		rotx
	p_zero		roty
	p_zero		rotz

	p_setdemo	suisei_warp

	p_spawn		0,0,0,0,0,0,extra1_1,suisei_gate,100,100,3
	p_spawn		-1000,-4000,3000,0,0,0,nullshape,suiseicam,1,1,2

.warp
.warp0	p_ifnotdemo	suisei_warp,.enter
	p_goto		.warp0

;.attack
;.attack0	p_ifnotdemo	suisei_attack,.charge
;	p_goto		.attack0


;************
;.charge
;	p_qspawn	nullshape,suisei_arwing_charge,1,1
;
;.charge0	p_ifsamedemo	suisei_final,.final
;	p_goto		.charge0
;
;************
.enter
	p_setvar	w,player1_horizon_offset,SCR4_Hofs+0c0h
.enter0	p_ifsamedemo	suisei_final,.final
	p_goto		.enter0

;************
.final
	; generate kabe(ext3 no iriguchi to onaji)

	p_wait	1

	p_Qspawn	kabe_to6,suisei_to1,1,1
	p_Qspawn	kabe_ak4,suisei_ak1,1,1
	p_Qspawn	kabe_2,suisei_kabe0,1,1
	p_Qspawn	kabe_2,suisei_kabe1,1,1

	p_wait		11	;14

	p_demosetmap

.final0	p_ifnotdemo	suisei_final,.owari
	p_goto		.final0

.owari	p_remove

;----------------------------------------------------------------------------------------
; Camera
;----------------------------------------------------------------------------------------

	start_path	suiseicam

	p_gosub		suisei_enter_init1


;************ attack

.warp	p_Qspawn	nullshape,suisei_base,1,1
	p_rtrigger	.always1,always

;;;;	p_Qspawn	batabata,suisei_zako,1,13
	p_wait	60h

	p_Qspawn	batabata,suisei_zako,1,4
	p_Qspawn	batabata,suisei_zako,1,5
	p_Qspawn	batabata,suisei_zako,1,6
	p_Qspawn	batabata,suisei_zako,1,7
	p_Qspawn	batabata,suisei_zako,1,8
	p_Qspawn	batabata,suisei_zako,1,9

	p_wait	10h

	p_Qspawn	nullshape,suisei_friends,1,0
	p_Qspawn	nullshape,suisei_friends,1,1
	p_Qspawn	nullshape,suisei_friends,1,2
	p_Qspawn	nullshape,suisei_friends,1,3

	p_wait	30h

	p_Qspawn	batabata,suisei_zako,1,10
	p_Qspawn	batabata,suisei_zako,1,11
	p_Qspawn	batabata,suisei_zako,1,12

.warp0	p_ifnotdemo	suisei_warp,.enter
	p_goto		.warp0

;************ attack
;
;.attack
;	p_trigger	.always1,off
;	p_rtrigger	.always1,always
;
;	p_wait		1
;
;	p_campandemoshape	1,0,immediate
;
;	p_set		childx,suisei_attack_camx
;	p_set		childy,suisei_attack_camy
;	p_set		childz,suisei_attack_camz
;
;.attack0	p_ifnotdemo	suisei_attack,.charge
;	p_setvar	w,player1_horizon_offset,SCR4_Hofs+0c0h
;	p_goto		.attack0
;
;************ charge
;
;.charge
;	p_trigger	.always,off
;
;	p_set		childx,suisei_charge_camx
;	p_set		childy,suisei_charge_camy
;	p_set		childz,suisei_charge_camz
;
;	p_goto		.charge0
;
;.charge0	p_ifnotdemo	suisei_charge,.enter
;
;	;p_copypos2view		1,immediate
;	;p_campandemoshape	1,0,immediate
;	p_goto			.charge0
;
;************ enter

.enter	p_set		childx,suisei_enter_camx
	p_set		childy,suisei_enter_camy
	p_set		childz,suisei_enter_camz
	p_goto		.enter0

.enter0	p_ifnotdemo	suisei_enter,.intocut
	p_goto			.enter0

;************ into

.intocut
;	p_trigger	.always1,off
	p_set		childx,suisei_into_camx-200
	p_set		childy,suisei_into_camy
	p_set		childz,suisei_into_camz
	p_goto		.intocut0

.intocut0	p_rtrigger	.always1,always
	p_ifnotdemo	suisei_into,.finalcut
	p_add		childz,5+3
	p_add		childy,2
	p_goto		.intocut0


;************ final cut
.finalcut
	p_import	childx,p1_worldx_init
	p_import	childy,p1_worldy_init
	p_import	childz,p1_worldz_init

	p_add		childy,20	;+10+10+20+20
	p_add		childz,250
	p_add		childx,-50
	p_goto		.finalloop0

.finalloop0

	p_trigger	.always1,off
	p_rtrigger	.always2,always

	p_setvar	w,player1_horizon_offset,SCR6_Hofs


.finalloop	p_copypos2view	1,immediate
	p_add		childz,10
	p_add		childy,-4
	p_add		childx,2
	;p_campandemoshape	1,0,immediate
	p_ifnotdemo	suisei_final,demoobj_remove
	p_goto		.finalloop


.always	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate
	p_return

.always1	p_copypos2view		1,immediate
	p_campandemoshape	1,0,immediate
	p_return

.always2	p_copypos2view		1,immediate
	p_campandemoshape	1,1,immediate
	p_return


demoobj_remove1

	p_goto	demoobj_remove


demoobj_remove_force

	p_force		DEMOOBJ_REMOVE
	p_return


demoobj_remove
	p_remove



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Demo shape
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	suisei_base

	p_demoshape

	p_collisions	off

	p_rtrigger	.always,always

	p_add		worldx,250

	p_add		worldy,-1120h-100h-100h-25
	p_add		worldz,12a4h+200h

	p_add		roty,deg180

	p_set		rotx,30

	p_spawn	-180,0,260,0,0,0,nullshape,suisei_aw_watch,1,1,childno_suisei_aw2

	p_spawn	55<<base_scale,0,40<<base_scale,0,0,0,nullshape,suisei_aw,10,1,childno_suisei_aw0
	p_spawn	-55<<base_scale,0,40<<base_scale,0,0,0,nullshape,suisei_aw_f,10,65,childno_suisei_aw1

;	p_spawn		55<<base_scale,0,40<<base_scale,0,0,0,nullshape,suisei_aw,10,90,childno_suisei_aw
;	p_spawn		-55<<base_scale,0,40<<base_scale,0,0,0,nullshape,suisei_aw,10,100,childno_suisei_aw
;	p_spawn		55<<base_scale,0,40<<base_scale,0,0,0,nullshape,suisei_aw,10,110,childno_suisei_aw
;	p_spawn		-55<<base_scale,0,40<<base_scale,0,0,0,nullshape,suisei_aw,10,120,childno_suisei_aw

	p_wait	20

	P_CIRCLEWINDOW	8,warp

	p_spawn		0,0,80<<base_scale,64,0,0,clipshape,scramble_clip,10,10,childno_scramble_clip
	p_gosub		prou_makebase_h

	p_spawn		55<<base_scale,15<<base_scale,80<<base_scale,0,0,0,base_h,scramble_base_h_s,10,20,childno_scramble
	p_spawn		-55<<base_scale,15<<base_scale,80<<base_scale,0,0,0,base_h1,scramble_base_h,10,28,childno_scramble

	p_quadvecs	on

	p_setvel	62

	p_wait	20

	p_accel	3,5

	p_wait	68-20-20

;	p_unlinkchild	childno_suisei_aw0


	p_wait	70h-68

	p_remove

;	p_remove	childno_base_t
;	p_remove	childno_base_u
;	p_remove	childno_base_rb
;	p_remove	childno_base_lb
;	p_remove	childno_base_lf
;	p_remove	childno_base_rf
;	p_remove	childno_scramble
;	p_remove	childno_scramble
;
;.loop	p_ifnotdemo	suisei_warp,.remove
;	p_goto		.loop
;.remove	p_remove


.always	p_return

;-----------------------------------------------------------------------------------
	start_path	suisei_aw

	p_trigger	suisei_warp_always,always

	p_collisions	off

	p_gosub		Pscramble_arwing_p.init

	p_playershape

	p_demoshape

	p_wait	68

	p_sound		p2_demo_arwing

	p_unlinkchild	childno_suisei_aw0

	p_alwaysgenvecs	on
	p_setvel	30

	p_wait	12

	P_SOUNDEFTPOS	ob_throughobst_l

	p_wait	10

	p_do	20
	p_add	roty,3
	p_chase	rotz,55
	p_next

	p_set	childroty,3

	p_do	20
	p_add	rotx,1
	p_chase	childroty,-3
	p_add	roty,childroty
	p_chase	rotz,-55
	p_next

	p_end



	start_path	suisei_aw_f

	p_trigger	suisei_warp_always,always

	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.remove
	P_GOSUB		set_friend_shape

.enter	LOCAL

	p_gosub		Pscramble_arwing_p.init

	p_set	count,ap
	p_wait	count

	p_unlinkchild	childno_suisei_aw1

	p_alwaysgenvecs	on

	p_setvel	30

	p_wait	10

	;p_do	15
	;p_add	roty,-3
	;p_chase	rotz,-40
	;p_next

	;p_do	30
	;p_add	roty,3
	;p_chase	rotz,50
	;p_next

	p_end

.remove	p_remove




	start_path	suisei_aw_watch

	p_wait	2
	p_demoshape
	p_wait	50h

	p_unlinkchild	childno_suisei_aw2

	p_setvel	30
	p_wait	8
	p_setvel	100

	p_wait	2

	p_accel	0,5

	p_end


;	p_wait	2
;	p_demoshape
;	p_wait	50h
;	p_set	vz,30
;	p_wait	8
;	p_set	vz,100
;
;	p_wait	2
;
;	p_do	40
;	p_chase	vz,0
;	p_next
;
;	p_end



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	suisei_zako

	p_quadvecs	on

	p_trigger	suisei_warp_always,always

	p_collisions	off

	p_index		pword1,suisei_friends.y,ap
	p_add	worldy,pword1
	p_index		pword1,suisei_friends.z,ap
	p_add	worldz,pword1

	p_rtrigger	.always,always
	p_igoto		Psuisei_friends.enter

.always	;;;p_dec	hp
	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	start_path	suisei_friends

	p_sound		p2_demo_arwing

	p_trigger	suisei_warp_always,always

	p_collisions	off

;************
	p_export	tpx,ap
	p_gosub		prou_friendNo_shape
;************


	p_add	worldy,-200
	p_add	worldz,200


.enter	LOCAL

	p_index		pword1,suisei_friends.x,ap
	p_add		worldx,pword1

	p_index		rotx,suisei_friends.rx,ap
	p_index		roty,suisei_friends.ry,ap
	p_index		rotz,suisei_friends.rz,ap
	p_index		childroty,suisei_friends.cry,ap
	p_index		childrotx,suisei_friends.crx,ap

	p_index		count,suisei_friends.count,ap

	p_wait	count

	p_alwaysgenvecs	on
	p_index		vel,suisei_friends.vel,ap

	p_index		count,suisei_friends.count2,ap
	p_wait	count


	p_ifsame	ap,13,.loop
	p_set		pbyte1,4
	p_iflarger	ap,pbyte1,.e
	p_trigger	.fire,4,8
	p_igoto		.loop
.e	p_trigger	.efire,4,8


.loop	p_index		count,suisei_friends.count4,ap

	p_do	count
	p_add	roty,childroty
	p_add	rotx,childrotx
	p_next

	p_set		hp,0
	p_end



.fire	p_Qspawn	elaser2,suisei_laser,10,10
	P_SOUNDEFFECT	arwinglaser1
	p_return


.efire	p_Qspawn	laser_0,suisei_laser,10,10
	P_SOUNDEFTDISTPOS	en_laser_sL	;GAKKI
	p_return



	start_path	suisei_laser

	p_invisible	on
	p_setanim	3

	p_collisions	off

	p_quadvecs	on
	p_setvel	80

	p_wait	1

	p_invisible	off

	p_wait	8

	p_remove

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
suisei_warp_always

	p_ifnotdemo	suisei_warp,demoobj_remove_force

	p_return

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; *********** attack
	start_path	suisei
	p_set		depthoffset,3	;depth_large
	p_gosub		suisei_enter_init1
	p_set		worldx,0
	p_set		worldy,150
	p_set		worldz,0
	p_spawn		0,-50<<extra1s_scale,0,0,0,0,extra1_0s,suisei_parts,10,10,1
	p_spawn		0,50<<extra1s_scale,0,0,0,0,extra1_2s,suisei_parts,10,10,2
	p_spawn		0,20<<extra1s_scale,0,0,0,0,extra1_3s,suisei_parts,10,10,3
	p_qspawn	nullshape,suisei_attack_sound,10,10
.loop	p_ifnotdemo	suisei_attack,.remove
	p_add		roty,1
	p_add		worldz,20
	p_ifsame	worldz,58*20,.fire1
	p_ifsame	worldz,57*20,.fire2
	p_ifsame	worldz,66*20,.fire3
	p_goto		.loop
.fire1	p_qspawn	plasma1,suisei_suisei_beam,10,10	;aw
	p_goto		.loop
.fire2	p_qspawn	plasma1,suisei_suisei_beam2,10,10	;aw
	p_goto		.loop
.fire3	p_qspawn	plasma1,suisei_suisei_beam3,10,10	;ship
	p_goto		.loop
.remove	p_goto		demoobj_remove
;------------CAMERA
	start_path	suisei_attack_sound
	p_set		worldx,suisei_attack_camx
	p_set		worldz,800h
	p_gosub		suisei_enter_init1
	P_SOUND		p2_enemy_base
.loop	p_ifnotdemo	suisei_attack,demoobj_remove
	p_add		worldz,20
	p_goto		.loop
;--------------------------
	start_path	suisei_parts
	p_collisions	off
	p_set		depthoffset,3
.loop	p_ifnotdemo	suisei_attack,.remove
	p_goto		.loop
.remove	p_goto		demoobj_remove
;------------CAMERA
	start_path	suisei_attack_watch
	p_demoshape
	p_do		49h
	p_add		childx,700/49h
	p_next
;	p_wait		49h
	p_relative	off
.loop	p_ifnotdemo	suisei_attack,demoobj_remove
	p_add		worldz,-30
	p_goto		.loop
;------------FIGHTER
	start_path	suisei_fighter2
;	p_set		worldx,suisei_attack_camx+400
;	p_set		worldy,suisei_attack_camy-100
;	p_set		worldz,suisei_attack_camz+1400+600
	p_set		pbyte1,1
	p_setvel	40
	p_igoto		psuisei_fighter.enter
	start_path	suisei_fighter
;	p_set		worldx,suisei_attack_camx+600
;	p_set		worldy,suisei_attack_camy+50
;	p_set		worldz,suisei_attack_camz+1400+900
	p_set		pbyte1,-1
	p_setvel	50
.enter	LOCAL
	p_index	worldx,.x,ap
	p_index	worldy,.y,ap
	p_index	worldz,.z,ap
	p_gosub		suisei_enter_init1
	p_spaceship	on
	p_alwaysgenvecs	on
	p_wait		70
	p_do		8
	p_chase		rotz,-30
	p_add		rotx,pbyte1
	p_gosub		psuisei_freetexplode.freetexplode3_nosnd
	p_next
.loop	p_ifnotdemo	suisei_attack,demoobj_remove
	p_chase		rotz,0
	p_gosub		psuisei_freetexplode.freetexplode3_nosnd
	p_goto		.loop

.x	dw	suisei_attack_camx+600
	dw	suisei_attack_camx+400
.y	dw	suisei_attack_camy+50
	dw	suisei_attack_camy-100
.z	dw	suisei_attack_camz+1400+900
	dw	suisei_attack_camz+1400+600

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;------------BATTLE SHIP


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	suisei_freet0
	p_gosub		prou_makebase
	p_spawn		0,-50,0,0,0,0,nullshape,suisei_attack_watch,1,1,1
	p_gosub		suisei_enter_init1
	p_set		rotx,0
	p_set		roty,deg180
	p_set		rotz,0
	p_export	gbyte1,rotx
	p_qspawn	nullshape,suisei_fighter,1,0
	p_become
	p_gosub		prou_othershape
	p_unbecome
	p_qspawn	nullshape,suisei_fighter2,1,1
	p_become
	p_gosub		prou_othershape
	p_unbecome
	p_gosub		.pos
	p_gosub		.init
	P_SOUND		p2_ship_0	;***
	P_WAIT		49h
	p_gosub		psuisei_freetexplode.lexp
	P_SOUND		port2_stop	;***
	p_do		15
	p_chase		rotz,20
	p_add		rotx,1
	p_next
	p_spaceship	off
.loop	p_ifnotdemo	suisei_attack,.remove
;	p_add		rotz,5
	p_gosub		psuisei_freetexplode.freetexplode7_nosnd
	p_goto		.loop
.remove	p_goto		demoobj_remove
.pos	LOCAL
	p_set		worldx,700
	p_set		worldy,suisei_attack_camy+100
	p_set		worldz,suisei_attack_camz+1400
	p_return
.init	LOCAL
	p_spaceship	on
;	p_rtrigger	suiseiremove,always
	p_gosub		suisei_enter_init0
	p_alwaysgenvecs	on
	p_setvel	30
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;------------EXPLODING BATTLE SHIP

	start_path	suisei_freetexplode

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	p_set		worldx,suisei_attack_camx-70	;-120
	p_set		worldy,suisei_attack_camy+150	;+150
	p_set		worldz,suisei_attack_camz-500+(2*30h)	;-700
.enter	LOCAL
	p_gosub		suisei_enter_init0
	p_wait	30h
.loop	p_ifsamedemo	suisei_charge,.charge
	p_gosub		.add
	p_gosub		psuisei_freetexplode.freetexplode3
	p_goto		.loop
.charge	p_goto		.pos2
.pos2	p_set		worldx,suisei_charge_camx-400
	p_set		worldy,-2500
	p_set		worldz,suisei_charge_camz+200
.loop1	p_ifsamedemo	suisei_enter,.remove
	p_gosub		psuisei_freetexplode.freetexplode3
	p_gosub		.add
	p_goto		.loop1
.remove	p_goto		demoobj_remove
.add	p_add		rotz,-2
	p_add		roty,1
	p_add		rotx,2
	p_add		worldz,2
	p_return
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;------------EXPLOSION
.freetexplode7_nosnd	LOCAL
	p_andframegoto	7,.snd
	p_return
.freetexplode3_nosnd	LOCAL
	p_andframegoto	3,.snd
	p_return
.freetexplode3	LOCAL
	p_andframegoto	3,.exp
	p_return
.freetexplodeL3	LOCAL
	p_andframegoto	3,.lexp
	p_return
.exp	LOCAL
	P_SOUNDEFTDIRECT	en_explode_demo,explode3	LOCAL
	p_andframegoto	3,.exp
	p_return
.freetexplodeL3	LOCAL
	p_andframegoto	3,.lexp
	p_return
.exp	LOCAL
	P_SOUNDEFTDIRECT	en_explode_demo,midR
.snd	p_qspawn	explosion5,e_demo_expnosound_m,10,1
	p_return
.lexp	LOCAL
	P_SOUNDEFTDIRECT	en_explode_demo,far
	p_qspawn	explosion5,e_demo_expnosound_l,10,1
	p_return
;------------EXPLOSION
	start_path	e_demo_expnosound_m
	p_sprite	0,16
	p_igoto		pe_demo_expnosound_l.enter
	start_path	e_demo_expnosound_l
	p_sprite	0,32
.enter	LOCAL
;	p_igoto		pe_worm_smoke.start
	p_set		ap,15	; size(see e_sp_explosion)
	p_igoto		pe_sp_explosion.same	;start
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC





;------------BEAM(suisei)

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	start_path	suisei_suisei_beam3
	p_set		pword1,25
	p_igoto		psuisei_suisei_beam.enter
	start_path	suisei_suisei_beam2
	p_set		pword1,1
	p_igoto		psuisei_suisei_beam.enter
	start_path	suisei_suisei_beam
	p_set		pword1,4
.enter	LOCAL
	p_gosub		suisei_enter_init1
	P_SOUNDEFTDIRECT	en_laser_sL,far
	p_set		worldy,-100
	p_sprite	0,10
	p_do		20
	p_add		worldz,250
	p_add		worldy,pword1
	p_next
	p_remove
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;------------LASER (BATTLESHIP)
;	start_path	suisei_ship_laser
;	p_gosub		suisei_enter_init1
;	p_setrandom	rotx,7
;	p_add		rotx,-3
;	p_add		worldy,-30
;	p_setvel	127
;	p_do		20
;	p_setanim	3
;	p_next
;	p_remove
;
;--------------------------------------------------------------------------
;	charge
;--------------------------------------------------------------------------



;	start_path	suisei_arwing_charge
;
;	P_SOUND		p2_demo_arwing
;
;;	p_spawn		-50,115,-100,0,0,0,c_wing,suisei_friend1_charge,100,100,2
;
;	p_import	pbyte1,player_friend
;	p_ifsame	pbyte1,-1,.nofriend
;
;	p_spawn		50,-100,-200,0,0,0,nullshape,suisei_friend2_charge,100,100,3
;
;.nofriend	p_demoshape
;
;	p_set		worldx,suisei_charge_camx+100
;	p_set		worldy,suisei_charge_camy-600
;	p_set		worldz,suisei_charge_camz-500
;
;	p_set		pbyte1,0
;
;.enter	LOCAL
;
;	p_playershape	; set player shape
;	p_gosub		suisei_enter_init1
;
;	p_alwaysgenvecs	on
;	p_setvel	50
;
;	p_set	rotx,40
;	p_set	roty,0
;	p_set	rotz,-40
;
;.loop	p_chase		rotz,-40
;	p_ifnotdemo	suisei_charge,demoobj_remove
;
;	p_ifsame	pbyte1,10h,.snd
;	p_ifnotsame	pbyte1,0ch,.nosnd
;.snd	P_SOUNDEFFECT	ob_throughobst_l
;.nosnd
;	p_inc		pbyte1
;
;	p_goto		.loop
;
;
;************
;	start_path	suisei_friend2_charge
;	P_GOSUB		set_friend_shape
;;	p_gosub		prou_friendshape_aw
;
;	start_path	suisei_friend1_charge
;	p_gosub		suisei_enter_init0
;
;	p_add		childz,-5
;	p_add		childy,-2
;	p_add		childrotx,-1
;
;	p_end
;
;--------------------------------------------------------------------------
;	enter
;--------------------------------------------------------------------------

	start_path	suisei_gate

	p_gosub		suisei_enter_init0

	p_gosub	prou_suisei

;	p_spawn		0,-50<<extra1_scale,0,0,0,0,extra1_0,suisei_extra1,10,suisei_into,1
;	p_spawn		0,50<<extra1_scale,0,0,0,0,extra1_2,suisei_extra1,10,suisei_final,2
;	p_spawn		0,20<<extra1_scale,0,0,0,0,extra1_3,suisei_extra1,10,suisei_final,3
;
	p_rtrigger	.always,always
; --- warp*

.warp	p_ifsamedemo	suisei_enter,.enter

;	p_set	childz,-1000

	p_goto		.warp

; --- CHARGE*
;.charge
;	p_set	childy,-2000
;	p_set	childz,-1000
;
;	p_ifsamedemo	suisei_enter,.enter
;	p_goto		.charge
;
; --- ENTER*
.enter

	p_zero	childy
	p_zero	childz

	p_spawn		0,15<<extra1_scale,82<<extra1_scale,0,0,0,nullshape,suisei_extra1_demoshape,100,suisei_final,3
	p_spawn		0,15<<extra1_scale,120<<extra1_scale,0,0,0,a_robo,suisei_enter_buoy,10,10,4

	p_set		childroty,50h+25

.loop

	p_ifnotsame	childroty,75h,.nols0
	p_qspawn	elaser2,suisei_enter_laser0,1,1
.nols0
	p_ifnotsame	childroty,77h,.nols1
	p_qspawn	elaser2,suisei_enter_laser1,1,1
.nols1
	p_ifnotsame	childroty,80h,.noaw
	p_qspawn	nullshape,suisei_arwing_enter,1,26
.noaw
	p_ifnotsame	childroty,88h,.noaw2


	p_push		pbyte1
	p_import	pbyte1,player_friend
	p_ifsame	pbyte1,-1,.NOFR
	p_qspawn	nullshape,suisei_friend_enter,1,25
.NOFR	p_pull		pbyte1

;	p_qspawn	nullshape,suisei_friend_enter,1,1


.noaw2
	p_ifnotsame	childroty,51h+25,.noe0

	p_qspawn	batabata,suisei_enemy0,15,0
	p_qspawn	batabata,suisei_enemy1,60,1
	p_qspawn	batabata,suisei_enemy2,19,2

.noe0	p_ifsamedemo	suisei_into,.into
	p_goto		.loop

.into	p_ifnotdemo	suisei_into,demoobj_remove1
	p_set		childroty,deg180
	p_goto		.into



.always	p_add	childroty,1
	p_return


;************
	start_path	suisei_friend_enter

	P_SOUND		p2_demo_arwing

	P_IMPORT	pbyte1,Player_friend
	P_IFSAME	pbyte1,-1,.remove
	P_GOSUB		set_friend_shape

	p_gosub		suisei_enter_init1

	p_alwaysgenvecs	on
	p_setvel	50

	p_gosub	Pes0_cam.pos	; set AP = 25

;	p_set		worldx,suisei_enter_camx
;	p_set		worldy,suisei_enter_camy-250
;	p_set		worldz,suisei_enter_camz
;	p_set		rotx,50
;	p_set		roty,-12
;	p_set		rotz,-20

	p_do		8
	p_add		rotx,-2
	p_add		rotz,1
	p_add		roty,-2
	p_next

.loop	p_ifnotdemo	suisei_enter,.remove
	p_add		rotx,-4
	p_add		roty,1
	p_add		rotz,2
	p_goto		.loop
.remove	p_goto		demoobj_remove


;************
	start_path	suisei_arwing_enter

	P_SOUND		p2_demo_arwing

	p_playershape	; set player shape

	p_gosub		suisei_enter_init1

	p_gosub	Pes0_cam.pos	; set AP = 26

;	p_set		worldx,suisei_enter_camx
;	p_set		worldy,suisei_enter_camy-100
;	p_set		worldz,suisei_enter_camz

	p_findshape	a_robo
	p_faceshape	immediate

	p_set		rotz,-30

	p_alwaysgenvecs	on
	p_setvel	50

.loop	p_add		rotz,1

	p_ifnotsame	rotz,-26,.nosnd
	P_SOUNDEFFECT	ob_throughobst_l
.nosnd
	p_faceshape	immediate
	p_ifnotdemo	suisei_enter,.into
	p_goto		.loop


.into	p_demoshape

	p_set	ap,30
	p_gosub	Pes0_cam.pos	; set AP = 30

;	p_set		worldx,suisei_into_camx-600
;	p_set		worldy,suisei_into_camy
;	p_set		worldz,suisei_into_camz+100
;	p_set		roty,deg270
;	p_set		rotx,0
;	p_set		rotz,40

	p_setvel	30

	p_do		23
	p_faceshape
	p_next


.intoloop	p_ifnotdemo	suisei_into,.final
	p_chase		rotx,0
	p_chase		rotz,0
	p_goto		.intoloop


.final
	P_SOUND		port2_stop	;***


	p_setvel	50
	p_copyplayerpos
	p_add		worldz,-700+250
	p_faceplayer	immediate


.finalloop	p_ifdemoend	.remove
	p_chase		rotz,0
	p_goto		.finalloop

.remove	p_copypos2player
	p_copyrot2player
	p_remove



;************

	start_path	suisei_enter_sprobj
	p_sprite	0,0
	p_gosub		suisei_enter_init1
.loop	p_ifnotdemo	suisei_enter,demoobj_remove
	p_goto		.loop

;************
	start_path	suisei_extra1_demoshape

	p_demoshape

	start_path	suisei_extra1

	p_gosub		suisei_enter_init0

.loop	p_import	pbyte1,demomode
	p_ifsame	pbyte1,ap,demoobj_remove1
	p_goto		.loop


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;************
	start_path	suisei_extra1_charge
	p_gosub		suisei_enter_init0
.loop	p_ifsamedemo	suisei_enter,demoobj_remove1
	p_goto		.loop
;************
	start_path	suisei_extra1_enterdemoshape
	p_demoshape
	start_path	suisei_extra1_chargeenterinto
	p_gosub		suisei_enter_init0
.loop	p_ifsamedemo	suisei_final,demoobj_remove1
	p_goto		.loop
	start_path	suisei_extra1_chargeenter
	p_gosub		suisei_enter_init0
.loop	p_ifsamedemo	suisei_into,demoobj_remove1
	p_goto		.loop
.remove	p_goto		demoobj_remove
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;	start_path	suisei_enter_obj
;	p_gosub		suisei_enter_init0
;.loop	p_ifsamedemo	suisei_into,demoobj_remove1
;	p_goto		.loop
;
;************

	start_path	suisei_enter_laser1
	p_set		rotx,30
	p_igoto		psuisei_enter_laser0.enter

	start_path	suisei_enter_laser0
	p_set		rotx,37

.enter	LOCAL

	p_ifplrweaplevel	1,.normal

.twin	p_spawn			50,0,0,0,0,0,elaser2,e_nocol_s_off,10,10,1
	p_ifplrweaplevel	2,.normal

.twintwin	p_set		shape,plasma1
	p_sprite	0,0
	p_becomechild	1
	p_add		childx,20
	p_set		shape,plasma1
	p_sprite	0,0
	p_unbecome
	P_SOUNDEFFECT	twinbmball1
	p_igoto		.normal2

.normal
	P_SOUNDEFFECT	arwinglaser1

.normal2	p_set		roty,30+5
	p_set		rotz,-30
	p_set		worldx,suisei_enter_laserx	;20+suisei_enter_camx
	p_set		worldy,suisei_enter_lasery	;-80+suisei_enter_camy
	p_set		worldz,suisei_enter_laserz	;suisei_enter_camz

	p_gosub		suisei_enter_init1

	p_setvel	100
	p_relative	off

	p_do		30
	p_setanim	3
	p_next
	p_remove

;************

	start_path	suisei_enemy2
	p_ifplrweaplevel	3,Psuisei_enemy0.start
	p_set		hp,60
	p_igoto		Psuisei_enemy0.start

	start_path	suisei_enemy1
	P_SOUND		p2_zako_0
	p_ifplrweaplevel	1,psuisei_enemy0.start
	p_set		hp,17

	start_path	suisei_enemy0
.start	LOCAL

	p_index	worldx,suisei_enemy0.x,ap
	p_index	worldy,suisei_enemy0.y,ap
	p_index	worldz,suisei_enemy0.z,ap
	p_index	rotx,suisei_enemy0.rx,ap
	p_index	roty,suisei_enemy0.ry,ap

	p_gosub		suisei_enter_init1

	p_setvel	100
	p_alwaysgenvecs	on

	p_set		depthoffset,1

	p_do		1ch
	p_dec		hp
	p_chase		roty,0a4h
	p_chase		rotx,-36
	p_next
	p_remove


;************
	start_path	suisei_enter_buoy

	p_invisible	on

	p_gosub		suisei_enter_init1

	p_wait	25

	p_do	15
	p_add	childz,10
	p_next

.loop	p_add		childz,-30
	p_ifsamedemo	suisei_into,.into
	p_goto		.loop

.into	p_set		childz,suisei_into_camz+400h
	p_set		childy,50<<extra1_scale	;15

.loopinto	p_ifsamedemo	suisei_final,demoobj_remove
	p_goto		.loopinto

;****initial****

suisei_enter_init0
	p_set		depthoffset,2	;depth_large
suisei_enter_init1
	p_trigger	suiseiremove,always
	p_collisions	off
	p_return

;-----------------------------------------------------------------------------------
;	final
;-----------------------------------------------------------------------------------

	start_path	suisei_kabe0
	p_set		worldx,1024
	p_set		roty,deg90
	p_igoto		psuisei_kabe1.enter

	start_path	suisei_kabe1
	p_set		worldx,-512
	p_set		roty,-deg90

.enter	LOCAL
	p_trigger	suiseiremove,always
	p_set		worldz,1024
.loop	p_ifnotdemo	suisei_final,demoobj_remove


	p_goto		.loop
	p_end

;-----------------------------------------------------------------------------------

	start_path	suisei_to1
	p_set	worldz,-512
	p_trigger	suiseiremove,always
	p_gosub		psuisei_ak1.init
	p_end




	start_path	suisei_ak1

	p_set	worldz,-60

	p_gosub		.init

	p_do		7
	p_setanim	11
	p_next

	P_SOUNDEFFECT	ob_demo_door

	p_do		3
	p_addanim	-4,12
	p_next

	P_SOUNDEFTDIST	hatch_move_end

	p_do		20
	p_setanim	0
	p_next
	p_end

.init	LOCAL
	p_set	worldx,256
	p_trigger	suiseiremove,always
	p_set		worldy,0
	p_return

;-------------------------------------------------------------------------
suiseiremove	LOCAL
	p_ifdemoend	.do
	p_return

.do	p_force		demoobj_remove
	p_return

	printf	"Demo0 length = ",*-DEMO0START,"%n"

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	sub routines
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
prou_crusher

	P_SPAWN		0,0,0,0,0,0,spin_1,armada_crusher_top,10,10,childno_dragon_body
	P_SPAWN		0,40<<spin_scale,0,0,0,0,spin_2,armada_crusher_bottom,10,10,childno_dragon_body
	P_SPAWN		0,20<<spin_scale,60<<spin_scale,0,deg180,0,spin_0,armada_crusher_arm,10,10,childno_dragon_body
	P_SPAWN		52<<spin_scale,20<<spin_scale,-30<<spin_scale,0,deg180-deg120,0,spin_0,armada_crusher_arm,10,10,childno_dragon_body
	P_SPAWN		-52<<spin_scale,20<<spin_scale,-30<<spin_scale,0,deg180+deg120,0,spin_0,armada_crusher_arm,10,10,childno_dragon_body

	p_return

prou_dragon
	P_CLRBOSSFLAGS
	p_collisions	off
	p_spawn		0,0,-45,0,0,0,dragon_1,superdragon_body1,1,1,childno_dragon_body
	P_START65816
	s_set_objtobevar	y,becomelastobj&WM
	stx			al_immuneptr,y
	P_END65816

	p_return


prou_d_sen
	p_spawn	0,0,-2000,0,0,0,d_sen_2,cds_d_sen_parts_circle,1,1,childno_d_sen
	p_spawn	0,0,((120+25)<<d_sens_scale)-2000,0,0,0,d_sen_0,cds_d_sen_parts_circle,1,1,childno_d_sen
	p_spawn	0,0,((033+25)<<d_sens_scale)-2000,0,0,0,d_sen_1,cds_d_sen_parts,1,3,childno_d_sen
	p_spawn	0,0,((-90+25)<<d_sens_scale)-2000,0,0,0,d_sen_3,cds_d_sen_parts,1,6,childno_d_sen
	p_spawn	0,-55<<d_sens_scale,((-40+25)<<d_sens_scale)-2000,0,0,0,d_sen_4,cds_d_sen_parts,1,2,childno_d_sen

	p_gosub	prou_d_sen3.makecannon
	p_become
	p_add	childz,-2000
	p_unbecome
;	p_spawn	0,-15<<d_sen_scale,120<<d_sen_scale-2000,0,0,0,d_sen_5,cds_d_sen_parts,1,1,childno_d_sen

	p_return

prou_d_sen2
	p_spawn	0,0,(120+25)<<d_sen_2_scale,0,0,0,d_sen_02,armada_d_sen_parts,1,1,childno_a_d_sen
	p_spawn	0,0,(033+25)<<d_sen_2_scale,0,0,0,d_sen_12,armada_d_sen_parts,1,1,childno_a_d_sen
	p_spawn	0,0,(-90+25)<<d_sen_2_scale,0,0,0,d_sen_32,armada_d_sen_parts,1,1,childno_a_d_sen
	p_spawn	0,-55<<d_sen_2_scale,(-40+25)<<d_sen_2_scale,0,0,0,d_sen_42,armada_d_sen_parts,1,1,childno_a_d_sen

	p_return


prou_d_sen3	; set cannon

	p_spawn	0,0,-25<<d_sen_scale,0,0,0,d_sen_2,gd_d_sen_parts,1,1,childno_gd_d_sen
	p_spawn	0,0,((120)<<d_sens_scale),0,0,0,d_sen_0,gd_d_sen_parts,1,1,childno_gd_d_sen
	p_spawn	0,0,((033)<<d_sens_scale),0,0,0,d_sen_1,gd_d_sen_parts,1,3,childno_gd_d_sen
	p_spawn	0,0,((-90)<<d_sens_scale),0,0,0,d_sen_3,gd_d_sen_parts,1,6,childno_gd_d_sen
	p_spawn	0,-55<<d_sens_scale,((-40)<<d_sens_scale),0,0,0,d_sen_4,gd_d_sen_parts,1,2,childno_gd_d_sen

	p_gosub	prou_d_sen3.makecannon
	p_return



.makecannon	LOCAL
	p_push		ap
	P_IMPORT	ap,eaction2
	P_IFZERO	ap,.nocannon
	p_spawn	0,-15<<d_sen_scale,120<<d_sen_scale,0,0,0,d_sen_5,gd_d_sen_parts5,1,1,childno_a_d_sen


.nocannon	p_pull	ap
	p_return


;-----------------------------------------------------------------------------------
prou_rel2player1

	P_START65816
	jsl		weap_relative2player1_srou_l
	P_END65816

	p_return

;prou_rel2playerX	; al_ptr = pointer of player1 or player2(shooter)
;
;	P_START65816
;	jsl		weap_relative2player_srou_l
;	P_END65816
;
;	p_return


prou_posrot0

	p_zero	rotx
	p_zero	roty
	p_zero	rotz
	p_zero	worldx
	p_zero	worldy
	p_zero	worldz

	p_return



;prou_othershape	; gbyte1 as pointer
;
;	p_push	pbyte1
;	P_START65816
;.next	lda	gbyte1
;	cmp	#6
;	bmi	.cnt
;	lda	#0
;.cnt	inc	gbyte1
;	cmp	p1_pilotNo
;	beq	.next
;	cmp	Player_friend
;	beq	.next
;
;	sta	al_pbyte1,x
;	P_END65816
;	p_igoto		prou_friendshape_aw.enter

;prou_player1shape_aw
;
;	p_push		pbyte1
;	p_import	pbyte1,p1_pilotNo
;
;	p_index		shape,wingman_AW_shape,pbyte1
;	p_index		coltab,wingman_AW_col,pbyte1
;	p_pull		pbyte1
;	p_return
;
;
;	p_igoto		prou_friendshape_aw.enter
;
;prou_friendshape_aw
;
;
;	p_push		pbyte1
;
;.continue	LOCAL
;	p_import	pbyte1,Player_friend
;.enter	LOCAL
;
;	p_index		shape,wingman_AW_shape,pbyte1
;	p_index		coltab,wingman_AW_col,pbyte1
;	p_pull		pbyte1
;	p_return

;-------------------------------------------------------------------------
;prou_playershape_trans_0
;
;	p_push		pbyte1
;	p_import	pbyte1,Player_friend
;	p_import	pbyte1,p1_pilotNo
;	p_index		shape,wingman_RB_shape,pbyte1
;	p_index		coltab,wingman_RB_col,pbyte1
;	p_pull		pbyte1
;	p_return
;
;prou_playershape_trans_1
;
;	p_push		pbyte1
;	p_import	pbyte1,Player_friend
;	p_import	pbyte1,p1_pilotNo
;	p_index		shape,wingman_RB_1_shape,pbyte1
;	p_index		coltab,wingman_RB_col,pbyte1
;	p_pull		pbyte1
;	p_return
;
;-------------------------------------------------------------------------
prou_playershape_rb


	P_START65816
	jsl	RB_SHAPE_player_path_l	;player
	P_END65816

	p_return


prou_friendshape_rb

	P_START65816
	jsl	RB_SHAPE_friend_path_l	;player
	P_END65816

	p_return




;	p_push		pbyte1
;
;.continue	LOCAL
;	p_import	pbyte1,Player_friend
;	p_import	pbyte1,p1_pilotNo
;
;.enter	LOCAL
;	p_index		shape,player_RB_shape,pbyte1
;.enter2	LOCAL
;	p_index		coltab,wingman_RB_col,pbyte1
;	p_pull		pbyte1
;	p_return
;
;
;-------------------------------------------------------------------------
;prou_playershape_rb_l
;
;	p_push		pbyte1
;	p_import	pbyte1,p1_pilotNo
;	p_index		shape,player_l_shape,pbyte1
;	p_igoto		prou_playershape_rb_swim_l.enter

;prou_playershape_rb_r
;
;	p_push		pbyte1
;	p_import	pbyte1,p1_pilotNo
;	p_index		shape,player_r_shape,pbyte1
;	p_igoto		prou_playershape_rb_swim_r.enter

;prou_playershape_rb_swim_l
;
;	p_push		pbyte1
;	p_import	pbyte1,p1_pilotNo
;	p_index		shape,player_swim_l_shape,pbyte1
;.enter	LOCAL
;	p_index		childx,pprb_posx,pbyte1
;	p_neg		childx
;	p_igoto		prou_playershape_rb.enter2

;prou_playershape_rb_swim_r
;
;	p_push		pbyte1
;	p_import	pbyte1,p1_pilotNo
;	p_index		shape,player_swim_r_shape,pbyte1
;.enter	LOCAL
;	p_index		childx,pprb_posx,pbyte1
;	p_igoto		prou_playershape_rb.enter2

prou_rbotyofstab

	p_push		pbyte1
	p_import	pbyte1,p1_pilotNo
	p_index		pword1,pprb_posy,pbyte1
	p_pull		pbyte1
	p_return

prou_copyplayerinitpos

	p_import	worldx,p1_worldx_init
	p_set		worldy,0
	p_import	worldz,p1_worldz_init

	p_set		rotx,0
	p_import	roty,p1_roty_init
	p_set		rotz,0

	p_return




prou_dmgsound	; x1 ha "P_WEAPHIT" de set sareru.

	p_push		pbyte1
	p_import	pbyte1,x1

	p_ifsame	pbyte1,ese_en_dmg_2,.6
	p_ifsame	pbyte1,ese_bs_andorf_damage,.5
	p_ifsame	pbyte1,ese_en_core_dmg_big,.4
	p_ifsame	pbyte1,ese_en_cry_3,.3
	p_ifsame	pbyte1,ese_en_cry_2,.2
	p_ifsame	pbyte1,ese_bs_cry_1,.1

.0	p_soundeftdistpos	en_dmg_s	;normal
	p_igoto		.exit
.1	p_soundeftdistpos	bs_cry_1	;dragon
	p_igoto		.exit
.2	p_soundeftdistpos	en_cry_2	;seibutsu small
	p_igoto		.exit
.3	p_soundeftdistpos	en_cry_3	;seibutsu large
	p_igoto		.exit
.4	p_soundeftdistpos	en_core_dmg_big	;core
	p_igoto		.exit
.5	p_soundeftdistpos	bs_andorf_damage	;core
	p_igoto		.exit
.6	p_soundeftdistpos	en_dmg_2	;?
.exit	p_pull	pbyte1
	p_return





prou_rbdsound	; x1 ha "P_WEAPHIT" de set sareru.

	p_push		pbyte1


	p_import	pbyte1,x1

	p_ifsame	pbyte1,rse_reboundlaser2,.1

.normal
	p_soundeftdistpos	ob_reboundlaser_s	;normal
	p_igoto		.exit

.1	p_soundeftdistpos	reboundlaser2	;dragon

.exit	p_pull	pbyte1
	p_return









;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
prou_inclevel

	P_START65816
	jsl	inclevel_path_l
	P_END65816

	p_return



prou_inclevel_d_sen

	P_START65816
	s_or_var	B,demoflag,#demoflag_nextmap_inclevel
	P_END65816
	p_return


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

prou_makebase
	p_collisions	off

	p_gosub	prou_makebase_h.make

.h	LOCAL

	p_spawn		55<<base_scale,0,45<<base_scale,0,0,0,base1_lh,base_parts,10,10,childno_base_lh
	p_spawn		-55<<base_scale,0,45<<base_scale,0,0,0,base1_rh,base_parts,10,10,childno_base_rh

	p_return


prou_makebase_h

	p_gosub	.make

.h	LOCAL
	p_spawn		55<<base_scale,0,45<<base_scale,0,0,0,base1_lf,base_parts,10,10,childno_base_lf
	p_spawn		-55<<base_scale,0,45<<base_scale,0,0,0,base1_rf,base_parts,10,10,childno_base_rf
	p_return

.make	LOCAL

	p_spawn		0,-90<<base_scale,-25<<base_scale,0,0,0,base1_t,base_parts_g,10,10,childno_base_t
	p_spawn		0,100<<base_scale,-50<<base_scale,0,0,0,base1_u,base_parts,10,10,childno_base_u
	p_spawn		-95<<base_scale,0,-75<<base_scale,0,0,0,base1_rb,base_parts,10,10,childno_base_rb
	p_spawn		95<<base_scale,0,-75<<base_scale,0,0,0,base1_lb,base_parts,10,10,childno_base_lb

	p_return


	start_path	base_parts_g
	p_groundobj	on
	start_path	base_parts
	p_collisions	off

	p_end

prou_remove_hatch

	p_remove	childno_es0_base_hl
	p_remove	childno_es0_base_hr
	p_remove	childno_base_lf
	p_remove	childno_base_rf
	p_gosub		prou_makebase.h

	p_return


prou_demoboost
	p_spawn		0,0,-20,0,0,0,boost,demoboost,100,100,77
	p_return


prou_suisei
	p_spawn		0,-50<<extra1_scale,0,0,0,0,extra1_0,suisei_extra1,10,suisei_into,1
	p_spawn		0,50<<extra1_scale,0,0,0,0,extra1_2,suisei_extra1,10,suisei_final,2
	p_spawn		0,20<<extra1_scale,0,0,0,0,extra1_3,suisei_extra1,10,suisei_final,3
	p_return


prou_titlepilotNo

	p_playershape

	P_START65816

	jsl	titlepilot00_path_l

;	lda	P1_PILOTNo
;	inc	a
;	and	#7
;	cmp	#6
;	bmi	.sta
;	lda	#0
;.sta	sta	P1_PILOTNo
	P_END65816

	p_return


prou_addrandom_cxyz31

	p_addrandom	childx,31
	p_addrandom	childy,31
	p_addrandom	childz,31

	p_return

;-----------------------------------------------------------------------------------
prou_playerdmg

	p_push	pbyte1

	P_START65816
	jsl	copy_player_damage_l

	bra	prou_player2dmg.enter


prou_player2dmg

	p_push	pbyte1

	P_START65816
	jsl	copy_player2_damage_l

.enter	LOCAL
	P_END65816

	p_ifzero	pbyte1,.exit

	p_andframegoto	1,.exit

	p_spawn	0,0,0,0,0,0,wallflash,damagespark,1,1,99

.exit	p_pull	pbyte1

	p_return

;-------------------------------------------------------------------------------------------
prou_playershield

	P_START65816

	jsl	copy_player_shield_l

	P_END65816

	p_return

;-------------------------------------------------------------------------------------------

