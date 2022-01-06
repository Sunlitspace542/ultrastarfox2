;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  room_course    (room)                   บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	IFEQ	1



	setfadedown	quick
	mapwaitfade
	setbg	missionextra4
	initbg

	map_vscreensize_mission	2

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick
	setvar		kenemynumber,4

;-----------------------------------------
;**** MAP SET START ****
;-----------------------------------------



;JOUTYUU
;;tsuuro
;;0-1
;	m_inertpath	00512,0000,-512,0,kabe_to,e_buil_shadow_off
;;1-2
;	m_inertpath	00512,0000,1024+512,0,kabe_to,e_buil_shadow_off
;;2-3
;	m_inertpath	00512,0000,03*1024+512,0,kabe_to,e_buil_shadow_off
;;2-4
;	m_inertpath	2*1024+512,0000,2*1024+512,deg90,kabe_to,e_buil_shadow_off
;;4-5
;	m_inertpath	3*1024+512,0000,3*1024+512,0,kabe_to,e_buil_shadow_off
;-----------------------------------------
;-----------------------------------------
;dots_set
	map_setdust	coloured		
;players_position
	km_mapareaout	off

	map_playermode		room
	map_setplayerpos	1,512,-150,-1000,0
	map_battlearea		-300,0,0,ground
	map_camerainit_1screen	-080,100,16,-16,55H
	map_arwinginit		-300,-12,15,-15
	map_playertunnel

;;	pathobj	0,512,-150,-100,stg_checker,e_stgroom_checker,100,0
;player_walker_change
;;	pathobj	0,00000,0000,00000,nullshape,e_change_walker,1,1


	ifeq	0


;-------------------------------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;

	map_area 0,0000,-1024,1024,512,ext4_0,on
	map_area 1,0000,-512,1024,2*1024,ext4_1,on
	map_area 2,0000,1024+512,2*1024+512,2*1024,ext4_2,on
	map_area 3,0000,3*1024+512,1024,1024+512,ext4_3,on
	map_area 4,2*1024+512,2*1024,1024+512,1024+512,ext4_4,on
	map_area 5,3*1024,3*1024+512,2*1024,2*1024+512,ext4_5,on
	map_area 6,1024,1024,1024+512,1024,0,off,inactive
	map_area 7,1024,3*1024,1024+512,1024,0,off,inactive
	map_area 8,4*1024,3*1024,1024,1024,0,off,inactive

	map_endarea
;-------------------------------------------------------------
;;;Lavel;;;
ext4_0
;rouka
	m_inertpath	00512,0000,-512,0,kabe_to,e_buil_shadow_off
;door
	m_inertpath	0512,0000,-1024+60,0,kabe_aku,e_free_door
;sub_door
	m_inertpath	00512,0000,-60,0,kabe_akufar,e_buil_shadow_off

	map_endarea
;-----------------------------------------
;-----------------------------------------
ext4_1
;rouka
	m_inertpath	00512,0000,-512,0,kabe_to,e_buil_shadow_off
	m_inertpath	00512,0000,1024+512,0,kabe_to,e_buil_shadow_off
;door
	m_inertpath	00512,0000,-60,0,kabe_aku,e_free_door
	m_inertpath	00512,0000,1024+60,0,kabe_aku,e_free_door
;sub_door
	m_inertpath	0512,0000,-1024+60,0,kabe_akufar,e_buil_shadow_off
	m_inertpath	00512,0000,2*1024-60,0,kabe_akufar,e_buil_shadow_off

;kabe
	m_inertpath	01024+512,0000,512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	-0512,0000,512,-deg90,kabe_0,e_nocol_s_off

;;	m_inertpath	0250,-100,250,0,taihou_0,e_room_taihou_1
;;	m_inertpath	0250,-060,250,0,kinoko_d,e_kinoko
;   ;orderlist4_1
;	ols_positions	1		;1 or 2 or 4 or 8
;	ols_pos		0250,-100,250
;	ols_pathobj	taihou_0,e_taihou
;	ols_wait	onedead
;	pathobj		0,00512,0000,1024+60,kabe_aku,e_door_0a,2,2

	map_endarea

;-----------------------------------------
;-----------------------------------------
ext4_2
;rouka
	m_inertpath	00512,0000,1024+512,0,kabe_to,e_buil_shadow_off
	m_inertpath	00512,0000,03*1024+512,0,kabe_to,e_buil_shadow_off
	m_inertpath	2*1024+512,0000,2*1024+512,deg90,kabe_to,e_buil_shadow_off
;door
	m_inertpath	00512,0000,2*1024-60,0,kabe_aku,e_free_door
	m_inertpath	2*1024+60,0000,2*1024+512,deg90,kabe_aku,e_free_door
	m_inertpath	00512,0000,3*1024+60,0,kabe_aku,e_free_door
;sub_door
	m_inertpath	00512,0000,1024+60,0,kabe_akufar,e_buil_shadow_off
	m_inertpath	00512,0000,4*1024-60,0,kabe_akufar,e_buil_shadow_off
	m_inertpath	3*1024-60,0000,2*1024+512,deg90,kabe_akufar,e_buil_shadow_off

;kabe
	m_inertpath	01024+512,0000,1024+512,0,kabe_0,e_nocol_s_off
	m_inertpath	01024+512,0000,3*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	-0512,0000,2*1024+512,-deg90,kabe_0,e_nocol_s_off

;;	m_inertpath	1024+512,0,2*1024+512,0,taihou_0,e_room_taihou_2
;   ;orderlist4_2
;	ols_positions	1		;1 or 2 or 4 or 8
;	ols_pos		01024,-100,2500
;	ols_pathobj	taihou_0,e_taihou
;	ols_wait	onedead
;	pathobj		0,2*1024+60,0000,2*1024+512,kabe_aku,e_door_2,2,2
;	pathobj		0,512,0000,3*1024+60,kabe_aku,e_door_2,2,2
	map_endarea
;-----------------------------------------
;-----------------------------------------
ext4_3
;rouka
	m_inertpath	00512,0000,03*1024+512,0,kabe_to,e_buil_shadow_off
;door
	m_inertpath	00512,0000,4*1024-60,0,kabe_aku,e_free_door
;sub_door
	m_inertpath	00512,0000,3*1024+60,0,kabe_akufar,e_buil_shadow_off

;kabe
	m_inertpath	01024+512,0000,4*1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	-0512,0000,4*1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	512,0000,5*1024+512,deg180,kabe_0,e_nocol_s_off

;;	m_inertpath	0512,0,4*1024+512,0,taihou_0,e_room_taihou_3
	map_endarea
;-----------------------------------------
;-----------------------------------------
ext4_4
;rouka
	m_inertpath	2*1024+512,0000,2*1024+512,deg90,kabe_to,e_buil_shadow_off
	m_inertpath	3*1024+512,0000,3*1024+512,0,kabe_to,e_buil_shadow_off
;door
	m_inertpath	3*1024-60,0000,2*1024+512,deg90,kabe_aku,e_free_door
	m_inertpath	3*1024+512,0000,3*1024+60,0,kabe_aku,e_free_door
;sub_door
	m_inertpath	2*1024+60,0000,2*1024+512,deg90,kabe_akufar,e_buil_shadow_off
	m_inertpath	3*1024+512,0000,4*1024-60,0,kabe_akufarfinal,e_buil_shadow_off

;kabe
	m_inertpath	3*1024+512,0000,2*1024-512,0,kabe_0,e_nocol_s_off
	m_inertpath	4*1024+512,0000,2*1024+512,deg90,kabe_0,e_nocol_s_off

;;	m_inertpath	3*1024+512,0,2*1024+512,0,taihou_0,e_room_taihou_4
;   ;orderlist4_4
;	ols_positions	1		;1 or 2 or 4 or 8
;	ols_pos		03500,-100,2500
;	ols_pathobj	taihou_0,e_taihou
;	ols_wait	onedead
;	pathobj		0,3*1024+512,0000,3*1024+60,kabe_aku,e_door_0a,2,2
	map_endarea
;-----------------------------------------
;-----------------------------------------
ext4_5
;rouka
	m_inertpath	3*1024+512,0000,3*1024+512,0,kabe_to,e_buil_shadow_off
;door
	m_inertpath	3*1024+512,0000,4*1024-60,0,kabe_akufinal,e_free_door
;sub_door
	m_inertpath	3*1024+512,0000,3*1024+60,0,kabe_akufar,e_buil_shadow_off

;kabe
	m_inertpath	4*1024+512,0000,4*1024-512,0,kabe_0,e_nocol_s_off
	m_inertpath	5*1024+512,0000,4*1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	5*1024+512,0000,5*1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	3*1024+512,0000,6*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	4*1024+512,0000,6*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	3*1024-512,0000,4*1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	3*1024-512,0000,5*1024+512,-deg90,kabe_0,e_nocol_s_off

	map_endarea

	endc


;-----------------------------------------
;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp
;ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ 0256,0768,1280,1792,2304,2816,3328,3840,4352,4864,5376,5888,,, บ
;บ                                                                บ
;บ   0512,1024,1536,2048,2560,3072,3584,4096,4608,5120,5632,6144,,บ
;ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

	IFEQ	1

;-------------------------------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;

	map_area 0,-1024,-1024,2048,2048,ext4_0,on
	map_area 1,1024,-1024,2048,2048,ext4_1,on
	map_area 2,1024,1024,3072,3072,ext4_2,on
	map_endarea
;-------------------------------------------------------------
;;;Lavel;;;
ext4_0
	m_inertpath	-1024,0000,00000,-deg90,kabe_0,e_buil_shadow_off
	m_inertpath	00000,0000,01024,deg180,kabe_0,e_buil_shadow_off
	m_inertpath	01024,0000,00000,deg90,kabe_to,e_buil_shadow_off
	m_inertpath	00000,0000,-1024,00,kabe_0,e_buil_shadow_off
;	m_inertpath	00570,0000,00000,deg270,kabe_aku,e_door_hard
	m_inertpath	01470,0000,00000,deg270,kabe_aku,e_buil_shadow_off

	m_inertpath	-0250,-060,00180,0,kinoko_d,e_kinoko
;	m_inertpath	00250,0000,00200,0,t_hako_0,e_buil_shadow_off
;	m_inertpath	00250,0000,-0180,0,t_hako_0,e_buil_shadow_off
;	m_inertpath	-0250,0000,-0180,0,t_hako_0,e_buil_shadow_off
   ;orderlist4_1
	ols_positions	1		;1 or 2 or 4 or 8
	ols_pos		-0250,-100,0180
	ols_pathobj	taihou_0,e_taihou
	ols_wait	onedead
;	pathobj		0,00570,0000,00000,kabe_aku,e_door_0a,2,2
	setalvar	roty,deg270
	map_endarea

ext4_1
	m_inertpath	01024,0000,00000,deg90,kabe_to,e_buil_shadow_off
	m_inertpath	02048,0000,01024,deg180,kabe_to,e_buil_shadow_off
	m_inertpath	03072,0000,00000,deg90,kabe_0,e_buil_shadow_off
	m_inertpath	02048,0000,-1024,00,kabe_0,e_buil_shadow_off
	m_inertpath	00570,0000,00000,deg270,kabe_aku,e_buil_shadow_off
;	m_inertpath	01470,0000,00000,deg270,kabe_aku,e_door_1
;	m_inertpath	02048,0000,00570,0,kabe_aku,e_door_hard
	m_inertpath	02048,0000,01470,0,kabe_aku,e_buil_shadow_off

	m_inertpath	02048,0000,00000,deg90,kao_man,e_kao_man
   ;orderlist4_1
	ols_positions	2		;1 or 2 or 4 or 8
	ols_pos		02304,0000,0256
	ols_pos		02048,0000,-256
	ols_pathobj	taihou_0,e_taihou
	ols_pathobj	taihou_0,e_taihou
	ols_wait	alldead
	m_inertpath	01792,0000,00256,0,kaifuku,e_kaifuku_p
;	pathobj		0,02048,0000,00570,kabe_aku,e_door_0a,1,1
	map_endarea

ext4_2
	m_inertpath	01024,0000,02048,192,kabe_0,e_buil_shadow_off
	m_inertpath	01024,0000,03072,192,kabe_0,e_buil_shadow_off
	m_inertpath	02048,0000,04096,128,kabe_0,e_buil_shadow_off
	m_inertpath	03072,0000,04096,128,kabe_0,e_buil_shadow_off
	m_inertpath	04096,0000,02048,64,kabe_0,e_buil_shadow_off
	m_inertpath	04096,0000,03072,64,kabe_0,e_buil_shadow_off
	m_inertpath	03072,0000,01024,00,kabe_0,e_buil_shadow_off
	m_inertpath	02048,0000,01024,deg180,kabe_to,e_buil_shadow_off
	m_inertpath	02048,0000,00570,00,kabe_aku,e_buil_shadow_off
;	m_inertpath	02048,0000,01470,00,kabe_aku,e_door_0a

	m_inertpath	02560,0000,02560,0,flower_0,e_flower
	m_inertpath	03072,0000,02560,0,t_hako_0,e_buil_shadow_off
;	m_inertpath	03072,0000,02048,0,guru2bar,e_guru2_r
	m_inertpath	02048,0000,02048,0,t_hako_0,e_buil_shadow_off
	m_inertpath	03072,0000,03072,0,t_hako_0,e_buil_shadow_off

	switchpath	1,02560,-100,03072,saru_2,e_jumpsaru
	map_endarea


	ENDC


	ENDC
