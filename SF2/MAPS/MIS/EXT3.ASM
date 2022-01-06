;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  station_stage     (room)  short type    บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	IFEQ	1



	setfadedown	quick
	mapwaitfade
	setbg	missionextra3
	initbg
	map_vscreensize_mission	4
;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

;-----------------------------------------
;**** MAP SET START ****
;-----------------------------------------
;dots_set
	map_setdust	coloured		
;players_position
	km_mapareaout	off
;player set
	map_playermode		room
	map_setplayerpos	1,0512,-120,0000,0
	map_battlearea		-300,0,0,ground
	map_camerainit_1screen	-080,100,16,-16,55H
	map_arwinginit		-300,-12,15,-15
	map_playertunnel


	map_demomode	1


;	pathobj	0,256,-120,-9*1024,stg_checker,e_stgtun_checker,100,0
;;player_arwimg_change
;	pathobj	0,00000,0000,00000,nullshape,e_change_arwing,1,1


;Target No.
	setvar		KenemyNumber,1
;-------------------------------------------------------------
;**** MAP STEPSET AREA ****
;-------------------------------------------------------------
	mapgotoiflevel	1,step_e5_0
	mapgotoiflevel	2,step_e5_1
	mapgotoiflevel	3,step_e5_2
	mapgotoiflevel	4,step_e5_3
	mapgotoiflevel	5,step_e5_4
	mapgotoiflevel	6,step_e5_5
	mapgotoiflevel	7,step_e5_6
	mapgotoiflevel	8,step_e5_7
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step_e5_0
	map_area 1,0000,0000,1024,3*1024,0,on,inactive
;rouka
	m_inertpath	00512,0000,0512,0,kabe_to,e_buil_shadow_off
	m_inertpath	00512,0000,2*1024+512,0,kabe_to,e_buil_shadow_off
;door
	m_inertpath	00512,0000,1024-60,0,kabe_aku,e_free_door
	m_inertpath	0512,0000,2*1024+60,0,kabe_aku,e_free_door
;sub_door
	m_inertpath	0512,0000,0060,0,kabe_akufar,e_buil_shadow_off
	m_inertpath	0512,0000,3*1024,0,kabe_akufar,e_buil_shadow_off
;kabe
	m_inertpath	01024+512,0000,1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	-0512,0000,1024+512,-deg90,kabe_0,e_nocol_s_off
;neta
;;;	m_inertpath	0250,0000,1024+250,0,taihou_0,e_room_taihou_1

	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step_e5_1
;-------------------------------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;

	map_area 0,0000,0000,2*1024+512,2*1024+512,ext3_area0,on
	map_area 1,2*1024+512,1024,1024+512,1024,ext3_area1,on
	map_area 2,0000,2*1024+512,1024,1024+512,ext3_area2,on
	map_area 3,1024,0000,2*1024,1024,0,off,inactive
	map_area 4,1024,2*1024,2*1024,1024,0,off,inactive

	map_endarea
;-------------------------------------------------------------
ext3_area0

;rouka
	m_inertpath	00512,0000,0512,0,kabe_to,e_buil_shadow_off
	m_inertpath	00512,0000,2*1024+512,0,kabe_to,e_buil_shadow_off
	m_inertpath	2*1024+512,0000,1024+512,deg90,kabe_to,e_buil_shadow_off
;door
	m_inertpath	00512,0000,1024-60,0,kabe_aku,e_free_door
	m_inertpath	0512,0000,2*1024+60,0,kabe_aku,e_free_door
	m_inertpath	2*1024+60,0000,1024+512,deg90,kabe_aku,e_free_door
;sub_door
	m_inertpath	0512,0000,0060,0,kabe_akufar,e_buil_shadow_off
	m_inertpath	0512,0000,3*1024-60,0,kabe_akufar,e_buil_shadow_off
	m_inertpath	3*1024-60,0000,1024+512,deg90,kabe_akufar,e_buil_shadow_off
;kabe
	m_inertpath	-0512,0000,1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	01024+512,0000,512,0,kabe_0,e_nocol_s_off
	m_inertpath	01024+512,0000,2*1024+512,deg180,kabe_0,e_nocol_s_off

	map_endarea
	;-------------------
ext3_area1
;rouka
	m_inertpath	2*1024+512,0000,1024+512,deg90,kabe_to,e_buil_shadow_off
;door
	m_inertpath	3*1024-60,0000,1024+512,-deg90,kabe_aku,e_free_door
;sub_door
	m_inertpath	2*1024+60,0000,1024+512,-deg90,kabe_akufar,e_buil_shadow_off
;kabe
	m_inertpath	3*1024+512,0000,1024-512,0,kabe_0,e_nocol_s_off
	m_inertpath	3*1024+512,0000,2*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	4*1024+512,0000,1024+512,deg90,kabe_0,e_nocol_s_off


	map_endarea
	;-------------------
ext3_area2
;rouka
	m_inertpath	00512,0000,2*1024+512,0,kabe_to,e_buil_shadow_off
;door
	m_inertpath	0512,0000,3*1024-60,deg180,kabe_aku,e_free_door
;sub_door
	m_inertpath	0512,0000,2*1024+60,deg180,kabe_akufar,e_buil_shadow_off
;kabe
	m_inertpath	01024+512,0000,3*1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	-0512,0000,3*1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	512,0000,4*1024+512,deg180,kabe_0,e_nocol_s_off

	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step_e5_2
	map_setplayerpos	1,0256,-120,0000,0

	map_area 0,0000,0000,1024,1024,0,on,inactive
	map_area 1,0000,1024,7*1024,6*1024,0,on,inactive
	map_area 2,1024,3*1024,4*1024,3*1024,0,off,inactive
	map_area 3,2*1024,2*1024,3*1024,1024,0,off,inactive
   ;iriguchi
	m_inertpath	00256,0000,512,00,kabe_to1,e_buil_shadow_off
	m_inertpath	00256,0000,1024-60,00,kabe_ak1,e_free_door
	m_inertpath	00256,0000,0000+60,00,kabe_ak1,e_free_door

   ;kabe
	m_inertpath	-0512,0000,2*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-0512,0000,4*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-0512,0000,6*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	01024,0000,4*1024+512,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	5*1024,0000,3*1024+256,-deg90,kabe_1,e_buil_shadow_off
	m_inertpath	5*1024,0000,5*1024-256,-deg90,kabe_1,e_buil_shadow_off
	m_inertpath	7*1024+512,0000,3*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	7*1024+512,0000,5*1024,deg90,kabe_2,e_nocol_s_off

	m_inertpath	1024+512,0000,0512,0,kabe_2,e_nocol_s_off
	m_inertpath	3*1024+512,0000,0512,0,kabe_2,e_nocol_s_off
	m_inertpath	5*1024+256,0000,0512,0,kabe_1,e_nocol_s_off
	m_inertpath	3*1024+512,0000,2*1024,deg180,kabe_2,e_buil_shadow_off
	m_inertpath	1024,0000,7*1024+0512,deg180,kabe_2,e_nocol_s_off
	m_inertpath	3*1024,0000,7*1024+0512,deg180,kabe_2,e_nocol_s_off
	m_inertpath	5*1024,0000,7*1024+0512,deg180,kabe_2,e_nocol_s_off
	m_inertpath	2*1024+256,0000,6*1024,0,kabe_1,e_buil_shadow_off
	m_inertpath	4*1024-256,0000,6*1024,0,kabe_1,e_buil_shadow_off
   ;kado
	m_inertpath	5*1024,0000,2*1024,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	5*1024,0000,6*1024,0,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,6*1024,deg90,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,3*1024,deg180,kado_0,e_buil_shadow_off
	m_inertpath	2*1024,0000,2*1024,deg180,kado_0,e_buil_shadow_off
	m_inertpath	6*1024+512,0000,1024+512,deg90,kado_0,e_buil_shadow_off
	m_inertpath	6*1024,0000,6*1024+512,deg180,kado_0,e_buil_shadow_off
   ;build
	m_inertpath	00256,0000,3500,deg180,t_saka_0,e_saka_low
	pathobj		0,0256,-432,4500,t_saka_0,e_saka_mid,1,1
	setalvar	rotx,deg180

	m_inertpath	00256,0000,5500,deg180,t_saka_0,e_saka_mid
   ;build_door
	m_inertpath	3000,0000,07000+208-64,-deg90,t_to_0,e_hit_open_door_0
	m_inertpath	3000,0000,07000-208-64,deg90,t_to_0,e_hit_open_door_0
   ;build_door
	m_inertpath	6*1024+256+270,0000,5000,deg180,t_to_2,e_hit_open_door_2
	m_inertpath	6*1024+256-270,0000,5000,0,t_to_2,e_hit_open_door_2
   ;build_door
	m_inertpath	5*1024+512,0000,3500,0,t_to_1,e_hit_open_door_1
	m_inertpath	7*1024,0000,3500,deg180,t_to_1,e_hit_open_door_1
;if-then
;;	switchpath	1,1000,0000,02000,lock_man,e_lockman_0
;;	switchpath	2,0512,0000,07000-512,lock_man,e_lockman_0
;;	switchpath	3,6700,0000,02800,lock_man,e_lockman_0
;;	switchpath	4,6*1024+256,0000,04500,lock_man,e_lockman_0

	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step_e5_3
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step_e5_4
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step_e5_5
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step_e5_6

	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step_e5_7
	map_area 0,0000,0000,1024,1024,0,on,inactive
	map_area 1,0000,1024,2*1024,2*1024,0,on,inactive
;rouka
	m_inertpath	00512,0000,0512,0,kabe_to,e_buil_shadow_off
;door
	m_inertpath	00512,0000,1024-60,0,kabe_aku,e_free_door
;sub_door
	m_inertpath	0512,0000,0060,0,kabe_akufar,e_buil_shadow_off
;kabe
	m_inertpath	2*1024+512,0000,1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	2*1024+512,0000,2*1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	-0512,0000,1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	-0512,0000,2*1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	512,0000,3*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	1024+512,0000,3*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	1024+512,0000,512,0,kabe_0,e_nocol_s_off
;pool
	m_inertpath	1024,00,2*1024,0,pools_0,e_buil_shadow_off

	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp



	ENDC
