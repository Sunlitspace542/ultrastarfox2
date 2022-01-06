;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  final_boss_tunnel	               บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;;;	setbg	missionextra3
;;;	setbg	missionextra2
	setbg	sun
	initbg

	map_vscrolloff

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick
	map_rasterON	fire_raster
;-----------------------------------------
;**** MAP SET START ****
;-----------------------------------------
;players_position
;ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บmap_arwinginit		high,low,rotXmax,rotYmin                    บ
;บmap_battlearea		high,low,depth,type	(koudokei)          บ
;บmap_camerainit_1screen	midY,Yoffsetmax,rotXmax,rotXmin,Yoffsetrate บ
;บmap_camerainit_2screen	,,,,,	                                    บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
;;players_position
	map_playermode		room

	map_setplayerpos	1,0256,-120-20,0064,0
	map_battlearea		-300,0,0,ground
	map_camerainit_1screen	-080,100,16,-16,55H
	map_arwinginit		-300,-12,15,-15
;tunnel_mode
	map_playertunnel
;-----------------------
;dots_set
	map_setdust	coloured
	map_dustkazu	8
;shinnyuu_demo
	map_demomode	suisei
	map_nextmap	ext1_0,enter_chika
	map_rasterOFF

;planet_message
	pathobj		0,0,0,0,nullshape,e_final_map,100,0
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0
;walker_start
;;;	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;kenemynumber
;;;	setvar		kenemynumber,1
;-------------------------------------------------------------
;-------------------------------------------------------------
;**** MAP STEPSET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;-------------------------------------------------------------
;-------------------------------------------------------------
;;ANDORUF_STEP
;	mapgotoiflevel	1,ext2_0	;andoruf_boss
;	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
ext2_0	;(last_tunnel)
;EVERY_SET
;1_way_door_final
	m_inertpath	256,1,19*1024+512-140,deg180,kaku_to,e_final_1way_andorf
;tsuuro_final
	m_inertpath	256,1,19*1024,deg180,kabe_to2,e_buil_shadow_off_g
;1way_door_area1
	m_inertpath	-2*1024+140,2,7*1024+256,-64,kabe_ak1,e_1way_door
;tsuuro_area1
	m_inertpath	-1024-512,2,7*1024+256,-deg90,kabe_to2,e_buil_shadow_off_g
;1way_door_area2
	m_inertpath	2*1024+512-140,3,7*1024+256,64,kabe_ak1,e_1way_door
;tsuuro_area2
	m_inertpath	2*1024,3,7*1024+256,deg90,kabe_to2,e_buil_shadow_off_g
;1way_door_area6
	m_inertpath	-1024-140,4,15*1024+256,deg90,kabe_ak1,e_1way_door
	m_inertpath	1024+512+140,5,15*1024+256,-deg90,kabe_ak1,e_1way_door
;tsuuro_area6
	m_inertpath	-1024-512,4,15*1024+256,deg90,kabe_to2,e_buil_shadow_off_g
	m_inertpath	2*1024,5,15*1024+256,-deg90,kabe_to2,e_buil_shadow_off_g
;tsuuro
	m_inertpath	4*1024+256,0000,9*1024+512,00,kabe_to2,e_buil_shadow_off_g
	m_inertpath	-4*1024+256,0000,9*1024+512,00,kabe_to2,e_buil_shadow_off_g
	m_inertpath	256,0000,14*1024+512,deg180,kabe_to1,e_buil_shadow_off_g
;-------------------
;**** MAP SET AREA ****
;-------------------
	map_area 0,-2*1024,0000,4*1024+512,8*1024+512,ext2_area0,on
	map_area 1,-4*1024,7*1024,3*1024,3*1024,ext2_area1,on
	map_area 2,1024+512,7*1024,3*1024,3*1024,ext2_area2,on
	map_area 3,-4*1024,9*1024,3*1024,6*1024+512,ext2_area3,on
	map_area 4,1024+512,9*1024,3*1024,6*1024+512,ext2_area4,on
	map_area 5,-1024,12*1024,2*1024+512,3*1024,ext2_area5,on
	map_area 6,-2*1024,14*1024,4*1024+512,5*1024+512,ext2_area6,on
	map_area 7,-1024,18*1024+512,2*1024+512,4*1024,ext2_area7,on
;
	map_area 8,-2*1024,0000,2*1024,6*1024+512,0,off,inactive
	map_area 9,512,0000,2*1024,6*1024+512,0,off,inactive
	map_area 10,-2*1024,6*1024+512,1024+512,512,0,off,inactive
	map_area 11,1024,6*1024+512,1024+512,512,0,off,inactive
	map_area 12,-2*1024,7*1024+512,4*1024+512,1024+512,0,off,inactive
	map_area 13,-3*1024-512,9*1024,2*1024+512,5*1024+512,0,off,inactive
	map_area 14,1024+512,9*1024,2*1024+512,5*1024+512,0,off,inactive
	map_area 15,-3*1024,14*1024,3*1024,1024,0,off,inactive
	map_area 16,512,14*1024,3*1024,1024,0,off,inactive
	map_area 17,-2*1024,15*1024+512,1024+512,512,0,off,inactive
	map_area 18,1024,15*1024+512,1024+512,512,0,off,inactive
	map_area 19,-2*1024,16*1024,2*1024,3*1024+512,0,off,inactive
	map_area 20,512,16*1024,2*1024,3*1024+512,0,off,inactive
;
	mapgotoiflevel	3,ext_hard_area	;HARD_room
	map_endarea
ext_hard_area
	map_area 21,1024,12*1024,512,2*1024,0,off,inactive
	map_endarea
	;-------------------
	;-------------------
	;-------------------
ext2_area0
;entrance
	m_inertpath	256,0000,-512,0,kabe_to5,e_nocol_s_off
;kabe
	m_inertpath	-0512,0000,1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-0512,0000,3*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-0512,0000,5*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	01024,0000,1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	01024,0000,3*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	01024,0000,5*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	01024-256,0000,8*1024,deg180,kabe_1,e_nocol_s_off
	m_inertpath	-512,0000,8*1024,deg180,kabe_0,e_nocol_s_off
   ;kado
	m_inertpath	-512,0000,6*1024+512,0,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,6*1024+512,deg90,kado_0,e_buil_shadow_off
;hako_saka
	m_inertpath	256,000,2*1024+512,deg180,t_saka_0,e_hako_0
	m_inertpath	256,000,3*1024,0,t_hako_0,e_hako_0
	m_inertpath	256,000,3*1024+512,0,t_saka_0,e_hako_0
	m_inertpath	256,000,4*1024+512,deg180,t_saka_0,e_hako_1
	m_inertpath	256,000,7*1024+256,0,t_hako_0,e_hako_1
;damage_move_yoko_pillar
	m_inertpath	256,-320+88,4*1024,$01,da_ha_yo,e_damage_yokobou_move
;tobidashi_tekuteku
	m_inertpath	100,-75-64,3*1024,128,tekuteku_s,e_tunnel_tobidashi_p
;ring_houdai
	m_inertpath	256,-60-128,7*1024+256,-64,yoi_hou,e_ring_hou
;kurukuru_hit_doors
	m_inertpath	256,000,5*1024+512,8,t_to_2,e_hit_stop_door
;-----------
;level_check
	mapgotoiflevel	2,ext20_normal	;NORMAL_room
	mapgotoiflevel	3,ext20_hard	;HARD_room
	map_endarea
;-----------
ext20_hard
;;moving_damage_pillar_tate
;	m_inertpath	32,-160,5*1024+512,$01,da_ha_ta,e_damage_tatebou_movex
;hikkomi_kabe
	m_inertpath	256,1,6*1024+256,0,kakureto,e_hikkomi_kabe
;switch
	m_inertpath	256,000,5*1024-100,1,on_d,e_neta_switch_hikkomi
;jump_tekuteku
	m_inertpath	250,-74,5*1024,deg180,tekuteku_s,e_tunnel_robo_jump
	map_endarea
;-----------
ext20_normal
	map_area 21,0000,7*1024+512,512,1024,ext20_secret,on
	map_endarea
;-----------
ext20_secret
;kado
	m_inertpath	1024,0000,9*1024+32,deg90,kado_3,e_nocol_s_off
	m_inertpath	-512,0000,9*1024+32,deg180,kado_4,e_nocol_s_off
;kabe
	m_inertpath	-512,0000,8*1024+32,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	1024,0000,8*1024-256+32,deg90,kabe_3,e_nocol_s_off
;kaifuku_panel
	m_inertpath	256,0,8*1024,0,kaifuku,e_kaifuku_panel
;medal_$4d
	m_inertpath	256,-100,8*1024+256,$4d,medal,e_omake_medal
	map_endarea
	;-------------------
	;-------------------
	;-------------------
ext2_area1
;kabe
	m_inertpath	-4*1024-512,0000,8*1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	-1024-512,0000,8*1024-256,deg90,kabe_3,e_nocol_s_off
	m_inertpath	-3*1024-256,0000,9*1024+512,deg180,kabe_3,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,6*1024+512,00,kabe_0,e_nocol_s_off
;kado
	m_inertpath	-1024-512,0000,9*1024+512,deg90,kado_2,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,6*1024+512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	-1024-512,0000,6*1024+512,0,kado_4,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,9*1024+512,deg180,kado_4,e_nocol_s_off
;damage_yuka
	m_inertpath	-3*1024,512,8*1024,0,da_yuka,e_damage_yuka
;kabe_hou
	m_inertpath	-3*1024,-150,7*1024-32,0,tsu_hou_t,e_kabe_hou
	m_inertpath	-3*1024,-150,9*1024+32,deg180,tsu_hou_t,e_kabe_hou
;kabe_yamori
	pathobj		0,-4*1024-32+60,-100,8*1024,yamori_b,e_yamori,2,0
;neta_door
	m_inertpath	-4*1024+256,3,9*1024+140,0,kabe_aku,e_switch_op_door
;-----------
;level_check
	mapgotoiflevel	2,ext21_normal	;NORMAL_room
	mapgotoiflevel	3,ext21_hard	;HARD_room
;switch_wide
	m_inertpath	-3*1024,-32,8*1024,3,on_d,e_fumu_switch_door_map_aku
	m_inertpath	-3*1024,0000,8*1024,0,t_hako_lift_s,e_hako_0
	map_endarea
;-----------
ext21_normal
;switch_small
	m_inertpath	-3*1024,-80,8*1024,3,on_d,e_fumu_switch_door_map_aku
	m_inertpath	-3*1024,0000,8*1024,0,nobiru,e_hako_0
	map_endarea
;-----------
ext21_hard
;switch_cup
	m_inertpath	-3*1024,0,8*1024,3,cup_0,e_switch_cup_hard
;area_check
	map_area 21,-2*1024,8*1024+512,1024,512,ext21_secret,on
	map_endarea
;-----------
ext21_secret
;kado
	m_inertpath	-512+32,0000,9*1024+512,deg90,kado_3,e_nocol_s_off
	m_inertpath	-512+32,0000,8*1024,0,kado_4,e_nocol_s_off
;kabe
	m_inertpath	-1024-512+32,0000,8*1024,0,kabe_0,e_nocol_s_off
	m_inertpath	-2*1024+256+32,0000,9*1024+512,deg180,kabe_3,e_nocol_s_off
;kaifuku_panel
	m_inertpath	-1024-512,0,9*1024-256,0,kaifuku,e_kaifuku_panel
;medal_$3c
	m_inertpath	-1024-256,-100,9*1024-256,$3c,medal,e_omake_medal
	map_endarea
	;-------------------
	;-------------------
	;-------------------
ext2_area2
;kabe
	m_inertpath	5*1024,0000,8*1024+512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	2*1024,0000,8*1024-256,-deg90,kabe_3,e_nocol_s_off
	m_inertpath	4*1024-256,0000,9*1024+512,deg180,kabe_3,e_nocol_s_off
	m_inertpath	3*1024,0000,6*1024+512,00,kabe_0,e_nocol_s_off
;kado
	m_inertpath	2*1024,0000,9*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	5*1024,0000,6*1024+512,0,kado_2,e_nocol_s_off
	m_inertpath	2*1024,0000,6*1024+512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	5*1024,0000,9*1024+512,deg90,kado_4,e_nocol_s_off
;kabe_hou
	m_inertpath	4*1024+512,-100,8*1024,deg90,tsu_hou_t,e_kabe_hou
	m_inertpath	3*1024+512,-100,9*1024+32,deg180,tsu_hou_t,e_kabe_hou
;hashira_hou
	m_inertpath	3*1024+512,0000,8*1024,0,ha_hou_0,e_hako_hou
;-----------
;door_hou
	m_inertpath	4*1024+256,4,9*1024+140,deg180,kabe_aku,e_door_hou_door
;-----------
;level_check_to_hard
	mapgotoiflevel	3,ext22_hard	;HARD_room
;-----------
;level_check_to_normal
	mapgotoiflevel	2,ext22_normal	;NORMAL_room
;-----------
;ext22_EASY
	m_inertpath	3*1024-256,000,9*1024-256,0,t_hako_0,e_hako_0
;medal_$1d
	m_inertpath	3*1024-256,-164,9*1024-256,$1d,medal,e_omake_medal
	map_endarea
;-----------
ext22_NORMAL
	m_inertpath	4*1024+256,000,7*1024+256,0,t_hako_0,e_hako_0
;medal_$2d
	m_inertpath	4*1024+256,-164,7*1024+256,$2d,medal,e_omake_medal
	map_endarea
;-----------
ext22_hard
;;;;switch_door
;;;	m_inertpath	4*1024+256,1,9*1024+140,0,kabe_aku,e_final_door
;;;r_tank
;;;	pathobj		0,4*1024+512,00,8*1024+512,r_tank_0,e_root_tank_tojikomefinal,6,10
;;;	pathobj		0,4*1024,00,8*1024+512,r_tank_0,e_root_tank_final,6,10
;;;;neta_door
;;;	m_inertpath	4*1024+256,6,9*1024+140,0,kabe_aku,e_switch_op_door
;guruguru_trap
	m_inertpath	3*1024+512,-120,8*1024,4,toge_0,e_guruguru_bar
	map_endarea
	;-------------------
	;-------------------
	;-------------------
ext2_area3
;kabe
	m_inertpath	-4*1024-512,0000,11*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,13*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,14*1024+256,-deg90,kabe_3,e_nocol_s_off
	m_inertpath	-3*1024,0000,11*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	-3*1024,0000,13*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,16*1024,deg180,kabe_0,e_nocol_s_off
	m_inertpath	-2*1024-256,0000,14*1024+512,00,kabe_3,e_nocol_s_off
;kado
	m_inertpath	-3*1024,0000,14*1024+512,deg90,kado_0,e_buil_shadow_off
	m_inertpath	-4*1024-512,0000,16*1024,deg180,kado_2,e_nocol_s_off
;hit_open_door
	m_inertpath	-4*1024,0000,11*1024,0,t_to_1,e_hit_open_door_1
;kurukuru_not_stop_doors
	m_inertpath	-4*1024+256,000,12*1024,8,t_to_3,e_hit_dont_stop_door
;kurukuru_hit_doors
	m_inertpath	-4*1024+256,000,14*1024,-8,t_to_2,e_hit_stop_door
;hit_rot_door
	m_inertpath	-4*1024+16,0000,13*1024,0,t_to_0,e_hit_open_door_0
	m_inertpath	-3*1024-512-16,0000,13*1024,deg180,t_to_0,e_hit_open_door_0
;-----------
;level_check
;-----------
	mapgotoiflevel	1,ext23_easy	;EASY_left_tsuuro
	mapgotoiflevel	2,ext23_normal	;NORMAL_left_tsuuro
	map_endarea
;-----------
ext23_easy
;medal_$1c
	m_inertpath	-3*1024-512-100,-100,13*1024+300,$1c,medal,e_omake_medal
	map_endarea
;-----------
ext23_normal
;kabesaka
	m_inertpath	-4*1024+128-32,000,15*1024,deg180,t_saka_2,e_buil_shadow_off
;medal_$2c
	m_inertpath	-4*1024+100,-100,15*1024+512-100,$2c,medal,e_omake_medal
	map_endarea
	;-------------------
	;-------------------
	;-------------------
ext2_area4
;kabe
	m_inertpath	5*1024,0000,11*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	5*1024,0000,13*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	5*1024,0000,14*1024+256,deg90,kabe_3,e_nocol_s_off
	m_inertpath	3*1024+512,0000,11*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	3*1024+512,0000,13*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	3*1024,0000,16*1024,deg180,kabe_0,e_nocol_s_off
	m_inertpath	3*1024-256,0000,14*1024+512,00,kabe_3,e_nocol_s_off
;kado
	m_inertpath	3*1024+512,0000,14*1024+512,00,kado_0,e_buil_shadow_off
	m_inertpath	5*1024,0000,16*1024,deg90,kado_2,e_nocol_s_off
;kabesaka
	m_inertpath	4*1024+128-32,000,11*1024,deg180,t_saka_2,e_buil_shadow_off
	m_inertpath	4*1024+512-128+32,000,12*1024,deg180,t_saka_1,e_buil_shadow_off
;tobidashi_tekuteku
	m_inertpath	4*1024+100,-75,11*1024+450,128,tekuteku_s,e_tunnel_tobidashi_p
	m_inertpath	4*1024+512-100,-75,12*1024+400,128,tekuteku_s,e_tunnel_tobidashi_m
;tousenbo
	m_inertpath	4*1024+256,0,14*1024,0,kakureto,e_tousenbo
;-----------
;level_check
;-----------
	mapgotoiflevel	3,ext24_hard	;HARD_right_tsuuro
	map_endarea
;-----------
ext24_hard
;;;;moving_damage_pillar_tate
;;;	m_inertpath	4*1024+32,-160,13*1024,$03,da_ha_ta,e_damage_tatebou_movex
;;;	m_inertpath	4*1024+32,-160,13*1024+512+128,$03,da_ha_ta,e_damage_tatebou_movex
;;;	m_inertpath	4*1024+32,-160,14*1024+256,$03,da_ha_ta,e_damage_tatebou_movex
;medal_$3d
	m_inertpath	4*1024+80,-100,11*1024+350,$3d,medal,e_omake_medal
	map_endarea
	;-------------------
	;-------------------
	;-------------------
ext2_area5
;kado
	m_inertpath	-1024-512,0000,11*1024+512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	-1024-512,0000,14*1024+512,deg180,kado_2,e_nocol_s_off
;tojikome_door
	m_inertpath	256,1,14*1024+140,$04,kabe_ak1,e_tojikome_door
;-----------
;level_check
	mapgotoiflevel	3,ext25_hard	;HARD_room
;-----------
;kabe
	m_inertpath	256,0000,11*1024+512,00,kabe_3,e_nocol_s_off
;kado
	m_inertpath	2*1024,0000,11*1024+512,0,kado_2,e_nocol_s_off
	m_inertpath	2*1024,0000,14*1024+512,deg90,kado_2,e_nocol_s_off
;-----------
;ext25_easy
;yuka_mukade EASY & NORMAL
	pathobj		0,256,0000,13*1024,yuka_hou,e_yuka_hou_tojikome,5,10
;-----------
;level_check
	mapgotoiflevel	2,ext25_normal	;NOMAL_room
;-----------
;item EASY_only
	m_inertpath	-512,0,12*1024+512,1,itembox0,e_panel_flamethrower
	m_inertpath	1024,0,13*1024+512,2,itembox0,e_panel_twinblaster
;kaifuku_panel
	m_inertpath	256,0,13*1024,0,kaifuku,e_kaifuku_panel
;medal_$4c
	m_inertpath	256,-150,13*1024,$4c,medal,e_omake_medal
	map_endarea
;-----------
ext25_normal
;item NORMAL_only
	m_inertpath	-512,0,12*1024+512,1,itembox0,e_panel_smartplasma
	m_inertpath	1024,0,13*1024+512,2,itembox0,e_panel_smartplasma
;hashira_hou
	m_inertpath	256,0000,13*1024,0,ha_hou_0,e_hako_hou
	map_endarea
;-----------
ext25_hard	;HARD_only
;kabe
	m_inertpath	1024+512,0000,13*1024+256,deg90,kabe_3,e_nocol_s_off
;kado
	m_inertpath	1024+512,0000,11*1024+512,0,kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,14*1024+512,deg90,kado_3,e_nocol_s_off
;tojikome_kabe_mukade_medal_$46
	pathobj		0,0000,-150,13*1024,room_hou,e_kabe_mukade_tojikome,5,2
;hashira_hou
	m_inertpath	-256,0000,13*1024+256,0,ha_hou_0,e_hako_hou
	m_inertpath	256,0000,13*1024-256,0,ha_hou_0,e_hako_hou
;item HARD_only
	m_inertpath	-600,0,13*1024-600,1,itembox0,e_panel_shieldplayer
;;hako
;	m_inertpath	1024+512-128+32,000,13*1024+256,0,t_hako_1,e_hako_1
;	m_inertpath	1024+512-128+32,000,13*1024-256,0,t_hako_1,e_hako_1
;	m_inertpath	-1024+128-32,000,13*1024+256,0,t_hako_1,e_hako_1
;	m_inertpath	-1024+128-32,000,13*1024-256,0,t_hako_1,e_hako_1
	map_endarea
	;-------------------
	;-------------------
	;-------------------
ext2_area6
;kabe
	m_inertpath	1024,0000,14*1024+512,00,kabe_0,e_nocol_s_off
	m_inertpath	-512,0000,14*1024+512,00,kabe_0,e_nocol_s_off
	m_inertpath	1024,0000,17*1024+512,deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,17*1024+512,-deg90,kabe_2,e_nocol_s_off
;kado
	m_inertpath	-512,0000,16*1024,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,16*1024,deg180,kado_0,e_buil_shadow_off
	m_inertpath	-1024-512,0000,14*1024+512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	2*1024,0000,14*1024+512,0,kado_4,e_nocol_s_off
	m_inertpath	-1024-512,0000,16*1024,deg180,kado_4,e_nocol_s_off
	m_inertpath	2*1024,0000,16*1024,deg90,kado_4,e_nocol_s_off
;-----------
;level_check
	mapgotoiflevel	1,ext26_easy	;EASY_room
;-----------
;trap
	m_inertpath	512-180,-100,17*1024,2,toge_0,e_room_toge
	m_inertpath	180,-100,17*1024,2,toge_0,e_room_toge
;-----------
;level_check
	mapgotoiflevel	2,ext26_normal	;NORMAL_room
;-----------
	m_inertpath	512-150,-220,17*1024+512,2,toge_0,e_room_toge
	m_inertpath	150,-220,17*1024+512,2,toge_0,e_room_toge
ext26_normal
ext26_easy
	map_endarea
	;-------------------
	;-------------------
	;-------------------
;BOSS_CORE_ROOM
ext2_area7
;ANDORF
	pathobj		0,256,-300,21*1024,and_ha_1,and_box0,10,10

;	setalvar	rotx,deg180
;kabe
	m_inertpath	-1024-512,0000,21*1024,-deg90,b_kabe_0,e_nocol_s_off
	m_inertpath	2*1024,0000,21*1024,deg90,b_kabe_0,e_nocol_s_off
	m_inertpath	256,0000,23*1024,deg180,b_kabe_3,e_nocol_s_off
;kado
	m_inertpath	-1024-512,0000,19*1024,-deg90,b_kado_2,e_nocol_s_off
	m_inertpath	2*1024,0000,19*1024,0,b_kado_2,e_nocol_s_off
	m_inertpath	-1024-512,0000,23*1024,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	2*1024,0000,23*1024,deg90,b_kado_2,e_nocol_s_off
	map_endarea
;-------------------------------------------------------------
;-----------------------------------------
;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp
