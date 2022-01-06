;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  hidora_course (space)                   บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
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
	setvar		kenemynumber,6

;-----------------------------------------
;**** MAP SET START ****
;-----------------------------------------
;dots_set
	map_setdust	coloured		
;players_position
	km_mapareaout	off
;player set
	map_playermode		ground	;room
	map_setplayerpos	1,256,-120,-9*1024,0
	map_battlearea		-300,0,0,ground
	map_camerainit_1screen	-080,100,16,-16,55H
	map_arwinginit		-300,-12,15,-15
	map_playertunnel
;player_arwimg_change
	pathobj	0,00000,0000,00000,nullshape,e_change_arwing,1,1

;-------------------------------------------------------------
;**** MAP SET AREA ****
;-------------------------------------------------------------
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;

	map_area 0,00000,-9*1024,1024,1024+512,ext3_0,on
	map_area 1,00000,-8*1024+512,1024,7*1024,ext3_1,on
	map_area 2,-3*1024-512,-512,5*1024,5*1024,ext3_2,on
	map_area 3,-3*1024-512,4*1024+512,7*1024,10*1024+512,ext3_3,on
	map_area 4,3*1024+512,8*1024,5*1024+512,7*1024,ext3_4,on
	map_area 5,-9*1024,0000,5*1024+512,8*1024+512,ext3_5,on
	map_area 6,0,0,512,8*1024,ext3_6,on
	map_area 7,-8*1024,0,8*1024,1024,ext3_7,on
	map_area 8,-7*1024,8*1024,7*1024,1024,ext3_8,on
	map_area 9,0,8*1024,8*1024,2*1024,ext3_9,on
	map_area 10,0,12*1024,8*1024,3*1024,ext3_10,on
	map_area 11,-7*1024,1024,2*1024,5*1024,0,off,inactive
	map_area 12,-4*1024,9*1024,4*1024,6*1024,0,off,inactive
	map_area 13,1024,9*1024,6*1024,5*1024,0,off,inactive
	map_area 14,1024,4*1024,3*1024,4*1024,0,off,inactive
	map_area 15,-5*1024,2*1024,5*1024,5*1024,0,off,inactive

	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;;;Lavel;;;
ext3_0	;SOUTH_EDGE_DOOR
   ;iriguchi
	m_inertpath	00256,0000,-8*1024+512,00,kabe_to1,e_buil_shadow_off
	m_inertpath	00256,0000,-8*1024,00,kabe_ak1,e_door_3
	m_inertpath	00256,0000,-7*1024,00,kabe_ak1,e_buil_shadow_off
   ;kabe
	m_inertpath	1024,0000,-9*1024,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	-0512,0000,-9*1024,-deg90,kabe_2,e_nocol_s_off
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_1	;SOUTH
   ;iriguchi
	m_inertpath	00256,0000,-8*1024+512,00,kabe_to1,e_buil_shadow_off
	m_inertpath	00256,0000,-8*1024,00,kabe_ak1,e_buil_shadow_off
	m_inertpath	00256,0000,-7*1024,00,kabe_ak1,e_door_3
;1-2
	m_inertpath	00256,0000,-0512,00,kabe_to1,e_buil_shadow_off
	m_inertpath	00256,0000,-1024,00,kabe_ak1,e_door_3
	m_inertpath	00256,0000,00000,00,kabe_ak1,e_buil_shadow_off
   ;kabe
	m_inertpath	1024,0000,-6*1024,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	1024,0000,-4*1024,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	1024,0000,-2*1024,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	-0512,0000,-6*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-0512,0000,-4*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-0512,0000,-2*1024,-deg90,kabe_2,e_nocol_s_off
   ;build
	m_inertpath	00256,0000,-6000,deg180,t_saka_0,e_buil_shadow_off
	pathobj		0,0256,-432,-4000,t_saka_0,e_buil_shadow_off,1,1
	setalvar	rotx,deg180
	m_inertpath	00256,0000,-3000,deg180,t_saka_0,e_buil_shadow_off

	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_2	;CENTER
   ;iriguchi
;1-2
	m_inertpath	00256,0000,-0512,00,kabe_to1,e_buil_shadow_off
	m_inertpath	00256,0000,-1024+60,00,kabe_ak1,e_buil_shadow_off
	m_inertpath	00256,0000,-60,00,kabe_ak1,e_door_3
   ;kabe
	m_inertpath	-1024,0000,-0512,0,kabe_2,e_buil_shadow_off
	m_inertpath	-2*1024-512,0000,-512,0,kabe_0,e_buil_shadow_off
	m_inertpath	-512,0000,3*1024+256,-deg90,kabe_1,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,1024,deg180,kabe_0,e_buil_shadow_off
	m_inertpath	1024,0000,1024,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	1024,0000,3*1024,deg90,kabe_2,e_buil_shadow_off
   ;kado
	m_inertpath	-1024-512,0000,1024,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	-512,0000,2*1024,-deg90,kado_0,e_buil_shadow_off
;if-then
	switchpath	1,-500,0000,01000,kakashi,e_lockman_0

   ;build
	m_inertpath	-0208+256,0000,03500,0,t_to_0,ktest
	m_inertpath	00208+256,0000,03500,deg180,t_to_0,ktest

	map_endarea

;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_3	;NORTH
;3-end
	m_inertpath	00256,0000,15*1024+512,00,kabe_to1,e_buil_shadow_off
	m_inertpath	00256,0000,15*1024+60,00,kabe_ak1,e_lockman_door
   ;kabe
	m_inertpath	1024,0000,6*1024,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	1024,0000,10*1024+512,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	1024,0000,12*1024+512,deg90,kabe_2,e_buil_shadow_off
	m_inertpath	-512,0000,6*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,10*1024+512,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,12*1024+512,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,14*1024+256,-deg90,kabe_1,e_nocol_s_off
	m_inertpath	-2*1024,0000,9*1024,deg180,kabe_2,e_buil_shadow_off
	m_inertpath	-2*1024,0000,7*1024+512,0,kabe_2,e_nocol_s_off
	m_inertpath	2*1024+256,0000,9*1024,deg180,kabe_1,e_buil_shadow_off
   ;kado
	m_inertpath	-512,0000,7*1024+512,0,kado_0,e_buil_shadow_off
	m_inertpath	-512,0000,9*1024,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,7*1024+512,deg90,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,9*1024,deg180,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,14*1024,deg90,kado_0,e_buil_shadow_off
;if-then
	switchpath	2,256,0000,08400,kakashi,e_lockman_0


	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------

ext3_4	;NORTH
   ;kabe
	m_inertpath	7*1024,0000,15*1024+512,deg180,kabe_2,e_nocol_s_off
	m_inertpath	9*1024+512,0000,13*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	9*1024+512,0000,11*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	9*1024+512,0000,9*1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	5*1024,0000,7*1024+512,0,kabe_2,e_nocol_s_off
	m_inertpath	7*1024,0000,7*1024+512,0,kabe_2,e_nocol_s_off
	m_inertpath	6*1024+512,0000,12*1024+512,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	6*1024+512,0000,10*1024+512,-deg90,kabe_2,e_nocol_s_off
   ;kado
	m_inertpath	6*1024+512,0000,14*1024,0,kado_0,e_buil_shadow_off
	m_inertpath	6*1024+512,0000,9*1024,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	8*1024+512,0000,14*1024+512,deg180,kado_0,e_buil_shadow_off
	m_inertpath	8*1024+512,0000,8*1024+512,deg90,kado_0,e_buil_shadow_off
;if-then
	map_ifswitch	lockext3_4_1,3
	pathobj		0,08000,00,13000,kakashi,e_lockman_0,2,2
	map_defswitch	3
	mapgoto		lockext3_4_2
lockext3_4_1
	m_inertpath	08000,00,13000,00,taihou_0,e_taihou
lockext3_4_2
	switchpath	4,08000,0000,10000,kakashi,e_lockman_0


	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_5	;WEST
   ;kabe
	m_inertpath	-5*1024,0000,-512,0,kabe_2,e_nocol_s_off
	m_inertpath	-7*1024,0000,-512,0,kabe_2,e_nocol_s_off
	m_inertpath	-9*1024-512,0000,2*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-9*1024-512,0000,4*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-9*1024-512,0000,6*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-6*1024-512,0000,2*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	-6*1024-512,0000,4*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	-6*1024-512,0000,5*1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	-5*1024,0000,1024,deg180,kabe_2,e_buil_shadow_off
	m_inertpath	-5*1024,0000,9*1024,deg180,kabe_2,e_buil_shadow_off
	m_inertpath	-6*1024-512,0000,9*1024,deg180,kabe_0,e_buil_shadow_off
	m_inertpath	-4*1024-512,0000,7*1024+512,0,kabe_0,e_buil_shadow_off
   ;kado
	m_inertpath	-8*1024-512,0000,512,0,kado_0,e_buil_shadow_off
	m_inertpath	-8*1024-512,0000,7*1024,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	-7*1024-512,0000,8*1024,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	-6*1024-512,0000,6*1024+512,deg90,kado_0,e_buil_shadow_off
	m_inertpath	-5*1024-512,0000,7*1024+512,deg90,kado_0,e_buil_shadow_off
	m_inertpath	-6*1024-512,0000,1024,deg180,kado_0,e_buil_shadow_off

	m_inertpath	-8*1024,0000,4*1024,-deg45,kado_0,e_buil_shadow_off
	m_inertpath	-8*1024,0000,4*1024,deg90+deg45,kado_0,e_buil_shadow_off

;if-then
	map_ifswitch	lockext3_5_1,5
	pathobj		0,-7500,0000,5500,kakashi,e_lockman_0,2,2
	map_defswitch	5
	mapgoto		lockext3_5_2
lockext3_5_1
	m_inertpath	-7500,0000,5500,00,taihou_0,e_taihou
lockext3_5_2
;if-then
	switchpath	6,-8500,0000,02800,kakashi,e_lockman_0


	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_6	;CENTER_DOOR
;2-3
	m_inertpath	00256,0000,4*1024+512,00,kabe_to1,e_buil_shadow_off
	m_inertpath	00256,0000,4*1024+60,00,kabe_ak1,e_door_2
	m_inertpath	00256,0000,5*1024-60,00,kabe_ak1,e_door_2
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_7	;SOUTH_WEST_DOOR
;3-5_south
	m_inertpath	-3*1024-512,0000,256,deg90,kabe_to1,e_buil_shadow_off
	m_inertpath	-3*1024-60,0000,256,deg90,kabe_ak1,e_door_2
	m_inertpath	-4*1024+60,0000,256,deg90,kabe_ak1,e_door_2
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_8	;NORTH_WEST_DOOR
;3-5_north
	m_inertpath	-3*1024-512,0000,8*1024+256,deg90,kabe_to1,e_buil_shadow_off
	m_inertpath	-3*1024-60,0000,8*1024+256,deg90,kabe_ak1,e_door_2
	m_inertpath	-4*1024+60,0000,8*1024+256,deg90,kabe_ak1,e_door_2
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_9	;SOUTH_EAST_DOOR
;3-4_south
	m_inertpath	3*1024+512,0000,8*1024+256,-deg90,kabe_to1,e_buil_shadow_off
	m_inertpath	3*1024+60,0000,8*1024+256,-deg90,kabe_ak1,e_door_2
	m_inertpath	4*1024-60,0000,8*1024+256,-deg90,kabe_ak1,e_door_2
   ;kabe
	m_inertpath	5*1024,0000,9*1024,deg180,kabe_2,e_buil_shadow_off
	m_inertpath	2*1024+256,0000,7*1024+512,0,kabe_1,e_nocol_s_off
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext3_10	;NORTH_EAST_DOOR
;3-4_north
	m_inertpath	3*1024+512,0000,15*1024-256,-deg90,kabe_to1,e_buil_shadow_off
	m_inertpath	3*1024+60,0000,15*1024-256,-deg90,kabe_ak1,e_door_2
	m_inertpath	4*1024-60,0000,15*1024-256,-deg90,kabe_ak1,e_door_2
   ;kabe
	m_inertpath	2*1024+256,0000,14*1024,0,kabe_1,e_buil_shadow_off
	m_inertpath	5*1024,0000,14*1024,0,kabe_2,e_buil_shadow_off
	m_inertpath	1024+256,0000,15*1024+512,deg180,kabe_1,e_nocol_s_off
	m_inertpath	2*1024+512,0000,15*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	5*1024,0000,15*1024+512,deg180,kabe_2,e_nocol_s_off
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;-----------------------------------------
;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

;----------------------------------------------

;;;;;;;;switchpath	No,x,y,z,Shape,Path	;;;;;	(Shape	Jump)	;;;;;;
;;
;;;if-then
;;	map_ifswitch	Adress,NO(1,2,3,,,16)
;;
;;   ;kakashi
;;	pathobj		Timer,X,Y,Z,Shape_name,Path_name,Hp,Ap
;;	map_defswitch	NO
;;Adress
;;	,,,,,
;------------
;;;;;;;;	Shape	Change	;;;;;
;;
;;;if-then
;;	map_ifswitch	Adress_1,NO(1,2,3,,,16)
;;
;;   ;kakashi
;;	pathobj		Timer,X,Y,Z,Shape_name,Path_name,Hp,Ap
;;	map_defswitch	NO
;;	mapgoto		Adress_2
;;Adress_1
;;	m_inertpath	X,Y,Z,Rot,Shape_2_name,Path_2_name
;;Adress_2
;;	,,,,,
;------------
;   ;orderlist3_1
;	ols_positions	4		;1 or 2 or 4 or 8
;	ols_pos		05200,0000,0000
;	ols_pos		-4096,0000,2000
;	ols_pos		-4352,0000,3000
;	ols_pos		04352,0000,4096
;	ols_pathobj	kakashi,e_kakashi_0
;	ols_pathobj	kakashi,e_kakashi_0
;	ols_pathobj	kakashi,e_kakashi_0
;	ols_pathobj	kakashi,e_kakashi_0
;	ols_wait	alldead
;	m_inertpath	05120,0000,-0560,deg180,kabe_ak1,e_door_0b
