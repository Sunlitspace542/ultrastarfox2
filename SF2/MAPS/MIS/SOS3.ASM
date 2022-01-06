;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  SOS_SENKAN (space)  center_set type     บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;-----------------------------------------
;-----------------------------------------
;-----clear bg set-------------
	setstgclrbg	missionsos3
;-----ground or room check-----
	mapgotoifplanet	sos3room
;-----room start inicial-------
	map_demomode	off
	map_nextmap	sos3room_cnt,enter_d_sen	;room mode
;-----------------------------------------
;********************
;*****SPACE MODE*****
;********************
;-----------------------------------------
	map_vscreensize_mission	4

	setbg	missionsos3
	initbg

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

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
;player_position
	map_setplayerpos_battleship
	map_playermode		space
	map_battlearea		-3500,3500,0,ground
	map_camerainit_1screen	0,100,30,-30,0
	map_arwinginit		-3500,3500,40,-40
;-----------------------
;dots_set
	map_setdust	sprites,moving		
	map_dustsprite	asteroid,16		;asteroid only
	map_dustkazu	64
	map_ifasteroids	.nostars
	map_setdust	sprites,mixed,moving	;asteroid&dots	
	map_dustsprite	asteroid,16		;asteroid
	map_dustkazu	32
.nostars
;area_out_check
	map_playerblockmap_off	1	;area out off
;space_message_set
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_space,10,10
;-------------------------------------------------------------
;basic_senkan_set
	pathobj		0,0000,0000,000,d_sen_2,e_space_carier,10,10
;-------------------------------------------------------------
;**** MAP STEPSET AREA ****
;-------------------------------------------------------------

	mapgotoiflevel	1,stepsos3_0	;EASY_SENKAN_space
	mapgotoiflevel	3,stepsos3_2	;EASY_SENKAN_space
	mapgotoiflevel	5,stepsos3_4	;NORMAL_SENKAN_space
	mapgotoiflevel	7,stepsos3_6	;NORMAL_SENKAN_space
	mapgotoiflevel	9,stepsos3_8	;NORMAL_SENKAN_space
	mapgotoiflevel	11,stepsos3_a	;NORMAL_SENKAN_space
	mapgotoiflevel	13,stepsos3_c	;HARD_SENKAN_space
	mapgotoiflevel	15,stepsos3_e	;HARD_SENKAN_space
	mapgotoiflevel	17,stepsos3_10	;HARD_SENKAN_space
	mapgotoiflevel	19,stepsos3_12	;HARD_SENKAN_space
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos3_0
stepsos3_8
stepsos3_10
	pathobj		0,0,0,000,nullshape,e_from_carier_mother1,10,0
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos3_2
stepsos3_a
stepsos3_12
;bou+batabata
	pathobj		0,0,0,000,nullshape,e_from_carier_mother2,10,0
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos3_4
stepsos3_c
;stepsos3_14
	pathobj		0,0,0,000,nullshape,e_from_carier_mother1,10,8
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos3_6
stepsos3_e
;stepsos3_16
	pathobj		0,0,0,000,nullshape,e_from_carier_mother1,10,16
	map_endarea
;-------------------------------------------------------------
;
;
;
;
;-------------------------------------------------------------
;-------------------------------------------------------------
;*********************
;***** ROOM MODE *****
;*********************
sos3room

	map_vscreensize_mission	6

;	m_range	8192
	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick

sos3room_cnt


	setbg	room
	initbg
	map_rasterOFF

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

	map_setplayerpos	1,1024+256,-120-20,64,0
	map_battlearea		-300,0,0,ground
	map_camerainit_1screen	-080,100,16,-16,55H
	map_arwinginit		-300,-12,15,-15
;tunnel_mode
	map_playertunnel
	map_tutudepth
	map_playerblockmap_on	1	; blockmap on

;-----------------------
;dots_set
	map_setdust	coloured		
	map_dustkazu	8
;walker_start
;;;;;	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;-------------------------------------------------------------
;shinnyuu_demo
	map_demomode		start_d_sen
	map_demomode_clear	clear_d_sen
;-----------------------
;planet_message
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10
;-------------------------------------------------------------
;**** SENKAN BASIC MAP ****
;-------------------------------------------------------------
;first_1_way_door
	m_inertpath	1024+256,2,7*1024-140,deg180,kabe_ak1,e_1way_door
;final_1way_door
	m_inertpath	1024+256,1,12*1024-140,deg180,kaku_to,e_final_1way_door
;tsuuro
	m_inertpath	1024+256,0002,6*1024+512,deg180,kabe_to2,e_buil_shadow_off_g
	m_inertpath	1024+256,0001,11*1024+512,0,kabe_to1,e_buil_range_off
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;-----------------------------------------
;area
	map_area 0,1024,0000,512,7*1024,sos3_area0,on
	map_area 1,0000,6*1024,2*1024+512,6*1024,sos3_area1,on
	map_area 2,0000,11*1024,2*1024+512,3*1024,sos3_area2,on
	map_area 3,0000,6*1024,1024,1024,0,off,inactive
	map_area 4,1024+512,6*1024,1024,1024,0,off,inactive
	map_area 5,0000,11*1024,1024,1024,0,off,inactive
	map_area 6,1024+512,11*1024,1024,1024,0,off,inactive
	mapgotoiflevel	2,stepsos3_easy	;EASY_SENKAN_room
	mapgotoiflevel	4,stepsos3_easy	;EASY_SENKAN_room
	map_endarea
stepsos3_easy
	map_area 7,0000,7*1024,1024,4*1024,0,off,inactive
	map_area 8,1024+512,7*1024,1024,4*1024,0,off,inactive
	map_endarea
;-----------------------------------------
;
;-----------------------------------------
sos3_area0
;entrance
	m_inertpath	1024+256,0000,-512,0,kabe_to5,e_nocol_s_off
;kabe
	m_inertpath	512,0000,1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	512,0000,3*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	512,0000,5*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	2*1024,0000,1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	2*1024,0000,3*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	2*1024,0000,5*1024,deg90,kabe_2,e_nocol_s_off
;-----------------------------------------
;**** MAP STEPSET AREA (room)****
;-------------------------------------------------------------
	mapgotoiflevel	2,stepsos30_1	;EASY_SENKAN_room
	mapgotoiflevel	4,stepsos30_3	;EASY_SENKAN_room
	mapgotoiflevel	6,stepsos30_5	;NORMAL_SENKAN_room
	mapgotoiflevel	8,stepsos30_7	;NORMAL_SENKAN_room
	mapgotoiflevel	10,stepsos30_9	;NORMAL_SENKAN_room
	mapgotoiflevel	12,stepsos30_b	;NORMAL_SENKAN_room
	mapgotoiflevel	14,stepsos30_d	;HARD_SENKAN_room
	mapgotoiflevel	16,stepsos30_f	;HARD_SENKAN_room
	mapgotoiflevel	18,stepsos30_11	;HARD_SENKAN_room
	mapgotoiflevel	20,stepsos30_13	;HARD_SENKAN_room
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_1	;EASY
;saka
	m_inertpath	1024+256,000,2*1024,deg180,t_saka_0,e_hako_1
	m_inertpath	1024+256,000,2*1024+512,0,t_hako_0,e_hako_1
	m_inertpath	1024+256,000,3*1024,0,t_saka_0,e_hako_1
	m_inertpath	1024+256,000,5*1024,deg180,t_saka_0,e_hako_1
;kaberoof
	m_inertpath	1024+256,-320+128,4*1024,0,t_hako_roof,e_building
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_3	;EASY
;kabesaka
	m_inertpath	1024+128-32,000,2*1024,deg180,t_saka_2,e_buil_shadow_off
	m_inertpath	1024+512-128+32,000,3*1024,deg180,t_saka_1,e_buil_shadow_off
	m_inertpath	1024+128-32,000,5*1024,deg180,t_saka_2,e_buil_shadow_off
;tobidashi_tekuteku
	m_inertpath	1024+100,-75,5*1024+400,128,tekuteku_s,e_tunnel_tobidashi_p
;medal_$1f
	m_inertpath	1024+420,-100,3*1024+400,$1f,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_5	;NORMAL
;yoko_bou
	m_inertpath	1024+256,00,2*1024,0,t_hako_roof,e_buil_shadow_off
	m_inertpath	1024+256,-320+128,3*1024,0,t_hako_roof,e_building
	m_inertpath	1024+256,00,4*1024,0,t_hako_roof,e_buil_shadow_off
	m_inertpath	1024+256,0,5*1024-200,0,t_hako_roof,e_buil_shadow_off
	m_inertpath	1024+256,-320+128,5*1024+200,0,t_hako_roof,e_building
;jump_tekuteku
	m_inertpath	1024+256,-74,4*1024+400,deg180,tekuteku_s,e_tunnel_robo_jump
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_7	;NORMAL
;kabesaka
	m_inertpath	1024+128-32,000,2*1024,deg180,t_saka_2,e_buil_shadow_off
	m_inertpath	1024+512-128+32,000,3*1024,deg180,t_saka_1,e_buil_shadow_off
;kurukuru_hit_doors
	m_inertpath	1024+256,000,4*1024,-8,t_to_2,e_hit_stop_door
;kurukuru_hit_NOT_STOP_doors
	m_inertpath	1024+256,000,5*1024,8,t_to_3,e_hit_dont_stop_door
;tobidashi_tekuteku
	m_inertpath	1024+200,-75,3*1024+400,128,tekuteku_s,e_tunnel_tobidashi_p
;medal_$2f
	m_inertpath	1024+100,-100,2*1024+420,$2f,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_9	;NORMAL
;kurukuru_hit_doors
	m_inertpath	1024+256,000,2*1024,-2,t_to_2,e_hit_stop_door
	m_inertpath	1024+256,000,3*1024,8,t_to_2,e_hit_stop_door
	m_inertpath	1024+256,000,4*1024,4,t_to_2,e_hit_stop_door
	m_inertpath	1024+256,000,5*1024,-8,t_to_2,e_hit_stop_door
	map_endarea	 
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_b	;NORMAL
;hako_roof
	m_inertpath	1024+256,00,2*1024,0,t_hako_roof,e_buil_shadow_off
	m_inertpath	1024+256,-320+128,3*1024,0,t_hako_roof,e_building
;damage_pillar
	m_inertpath	1024+256,-88,4*1024,$01,da_ha_yo,e_damage_bou
;jump_tekuteku
	m_inertpath	1024+256,-74,2*1024+350,deg180,tekuteku_s,e_tunnel_robo_jump
	m_inertpath	1024+150,-74,4*1024+350,deg180,tekuteku_s,e_tunnel_robo_jump
	m_inertpath	1024+400,-74,4*1024+350,deg180,tekuteku_s,e_tunnel_robo_jump
;moving_damage_pillar_tate
	m_inertpath	1024+32,-160,5*1024+512,$01,da_ha_ta,e_damage_tatebou_movex
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_d	;HARD
;kaidan
	m_inertpath	1024+256,000,2*1024,0,t_hako_0,e_hako_0
	m_inertpath	1024+256,000,2*1024+512,0,t_hako_0,e_hako_1
	m_inertpath	1024+256,000,3*1024,0,t_hako_0,e_hako_2
;damage_pillar
	m_inertpath	1024+256,-200,4*1024,$01,da_ha_yo,e_damage_bou
	m_inertpath	1024+256,000,5*1024,deg180,t_saka_0,e_hako_1
;tai_hou
	m_inertpath	1024+400,-60-128,2*1024+512,80,taihou_0,e_laser_hou
;jump_tekuteku
	m_inertpath	1024+150,-74,3*1024+512,deg180,tekuteku_s,e_tunnel_robo_jump
	m_inertpath	1024+256,-74,5*1024+512,deg180,tekuteku_s,e_tunnel_robo_jump
;medal_$4e
	m_inertpath	1024+420,-200,4*1024+300,$4e,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_f	;HARD
;damage_pillar
	m_inertpath	1024+256,-160,2*1024,$01,da_ha_ta,e_damage_bou
;hit_rot_door
	m_inertpath	1024+16,0000,4*1024,0,t_to_0,e_hit_open_door_0
	m_inertpath	1024+512-16,0000,4*1024,deg180,t_to_0,e_hit_open_door_0
;;houdai_pillar
;	m_inertpath	1024+256,0,4*1024,0,ha_hou_0,e_hako_hou
;kurukuru_hit_NOT_STOP_doors
	m_inertpath	1024+256,000,5*1024,-8,t_to_3,e_hit_dont_stop_door
;moving_damage_pillar_tate
	m_inertpath	1024+32,-160,3*1024,$01,da_ha_ta,e_damage_tatebou_movex
	m_inertpath	1024+32,-160,5*1024+400,$01,da_ha_ta,e_damage_tatebou_movex
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_11	;HARD
;damage_pillar
	m_inertpath	1024+256,-88,2*1024,$01,da_ha_yo,e_damage_bou
	m_inertpath	1024+256,-320+88,3*1024,$01,da_ha_yo,e_damage_bou
;moving_damage_pillar_yoko
	m_inertpath	1024+256,-320+88,4*1024,$01,da_ha_yo,e_damage_yokobou_move
	m_inertpath	1024+256,-320+88,4*1024+512,$01,da_ha_yo,e_damage_yokobou_move
	m_inertpath	1024+256,-320+88,5*1024,$01,da_ha_yo,e_damage_yokobou_move
;;kabesaka
;	m_inertpath	1024+128-32,000,5*1024+200,deg180,t_saka_2,e_buil_shadow_off
;;tobidashi_tekuteku
;	m_inertpath	1024+64,-75,5*1024+500,128,tekuteku_s,e_tunnel_tobidashi_p
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
stepsos30_13	;HARD
;tousenbo
	m_inertpath	1024+256,0,2*1024-256,0,kakureto,e_tousenbo
;;damage_pillar
;	m_inertpath	1024+256,-200,2*1024,$01,da_ha_yo,e_damage_bou
;saka
	m_inertpath	1024+256,000,3*1024,deg180,t_saka_0,e_hako_1
	m_inertpath	1024+256,000,4*1024-200,0,t_saka_0,e_hako_0
;hikkomi_kabe
	m_inertpath	1024+256,1,5*1024-256,0,kakureto,e_hikkomi_kabe
;switch
	m_inertpath	1024+256,000,3*1024+400,1,on_d,e_neta_switch_hikkomi
;jump_tekuteku
	m_inertpath	1024+256,-74,3*1024+350,deg180,tekuteku_s,e_tunnel_robo_jump
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
;-----------------------------------------
;-----------------------------------------
;
;-----------------------------------------
;-----------------------------------------
sos3_area1
;kabe
	m_inertpath	-512,0000,9*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	3*1024,0000,9*1024,deg90,kabe_2,e_nocol_s_off
;kado
	m_inertpath	-512,0000,6*1024+512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	3*1024,0000,6*1024+512,0,kado_2,e_nocol_s_off
	m_inertpath	-512,0000,11*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	3*1024,0000,11*1024+512,deg90,kado_2,e_nocol_s_off
;-----------------------------------------
;**** MAP STEPSET AREA (room)****
;-------------------------------------------------------------
	mapgotoiflevel	2,stepsos31_1	;EASY_SENKAN_room
	mapgotoiflevel	4,stepsos31_3	;EASY_SENKAN_room
	mapgotoiflevel	6,stepsos31_5	;NORMAL_SENKAN_room
	mapgotoiflevel	8,stepsos31_7	;NORMAL_SENKAN_room
	mapgotoiflevel	10,stepsos31_9	;NORMAL_SENKAN_room
	mapgotoiflevel	12,stepsos31_b	;NORMAL_SENKAN_room
	mapgotoiflevel	14,stepsos31_d	;HARD_SENKAN_room
	mapgotoiflevel	16,stepsos31_f	;HARD_SENKAN_room
	mapgotoiflevel	18,stepsos31_11	;HARD_SENKAN_room
	mapgotoiflevel	20,stepsos31_13	;HARD_SENKAN_room
;
	map_endarea
;-------------------------------------------------------------
;level_f	YUKA_MUKADE_destroy
;-------------------------------------------------------------
stepsos31_f
;switch_door
	m_inertpath	1024+256,2,11*1024+140,0,kabe_aku,e_final_door
;mukade
	pathobj		0,1024+256,0000,9*1024+600,yuka_hou,e_yuka_hou_final,1,10
	pathobj		0,1024+256,0000,9*1024-600,yuka_hou,e_yuka_hou_final,2,10
;kabe_hou
	m_inertpath	-32,-150,7*1024+512,-deg90,tsu_hou_t,e_kabe_hou
	m_inertpath	2*1024+512+32,-150,7*1024+512,deg90,tsu_hou_t,e_kabe_hou
	m_inertpath	-32,-150,10*1024+512,-deg90,tsu_hou_t,e_kabe_hou
	m_inertpath	2*1024+512+32,-150,10*1024+512,deg90,tsu_hou_t,e_kabe_hou
;pillar
	m_inertpath	512,000,8*1024,0,t_hako_0,e_hako_1
	m_inertpath	512,000,10*1024,0,t_hako_0,e_hako_1
	m_inertpath	2*1024,000,8*1024,0,t_hako_0,e_hako_1
	m_inertpath	2*1024,000,10*1024,0,t_hako_0,e_hako_1
	map_endarea
;-------------------------------------------------------------
;level_b	
;-------------------------------------------------------------
stepsos31_b
;switch_door
	m_inertpath	1024+256,1,11*1024+140,0,kabe_aku,e_final_door
;yoyo_tank
	pathobj		0,1024+256,-16<<yoyo_scale,10*1024,yoyo_c,e_yoyo_tank,10,10
;;kabe_hou
;	m_inertpath	-32,-150,9*1024+512,-deg90,tsu_hou_t,e_kabe_hou
;	m_inertpath	2*1024+512+32,-150,8*1024+512,deg90,tsu_hou_t,e_kabe_hou
	map_endarea
;-----------------------
;stepsos31_b
;;switch_door
;	m_inertpath	1024+256,5,11*1024+140,0,kabe_aku,e_final_door
;;tai_hou
;	m_inertpath	512,-60-128,8*1024,-64,taihou_0,e_laser_hou_final
;	m_inertpath	2*1024,-60-128,8*1024,64,taihou_0,e_laser_hou_final
;;tobidashi_tekuteku
;	m_inertpath	2*1024,-75,10*1024+400,128,tekuteku_s,e_tunnel_tobidashi_m_final
;	m_inertpath	1024+256,-75,9*1024+100,0,tekuteku_s,e_tunnel_tobidashi_m_final
;	m_inertpath	512,-75,10*1024+400,0,tekuteku_s,e_tunnel_tobidashi_m_final
;;houdai_pillar
;	m_inertpath	1024+256,0,9*1024,0,ha_hou_0,e_hako_hou
;;guruguru_trap
;	m_inertpath	1024+256,-200,9*1024,8,toge_0,e_guruguru_bar
;;kabe_hou
;	m_inertpath	-32,-150,9*1024+512,-deg90,tsu_hou_t,e_kabe_hou
;	m_inertpath	2*1024+512+32,-150,8*1024+512,deg90,tsu_hou_t,e_kabe_hou
;	map_endarea
;-------------------------------------------------------------
;
;	meiro room
;
;-------------------------------------------------------------
stepsos31_5
stepsos31_9
stepsos31_13
;hako
	m_inertpath	256-32,000,8*1024-256,0,t_hako_1,e_hako_6
	m_inertpath	2*1024+256+32,000,8*1024-256,0,t_hako_1,e_hako_4
	m_inertpath	1024+256,000,8*1024+256,0,t_hako_1,e_hako_2
	m_inertpath	256-32,000,9*1024+256,0,t_hako_1,e_hako_6
	m_inertpath	2*1024+256+32,000,9*1024+256,0,t_hako_1,e_hako_4
	m_inertpath	1024+256,000,10*1024-256,0,t_hako_1,e_hako_2
	m_inertpath	1024-256,000,11*1024-256+32,0,t_hako_1,e_hako_5
	m_inertpath	2*1024-256,000,11*1024-256+32,0,t_hako_1,e_hako_5
;level_check (5 or 9 or 11 or 15)
;;;;;	mapgotoiflevel	6,stepsos31_5a		;NORMAL_SENKAN_room
	mapgotoiflevel	10,stepsos31_9a 	;NORMAL_SENKAN_room
	mapgotoiflevel	20,stepsos31_13a	;HARD_SENKAN_room
;;;;;	map_endarea
;-------------------------------------------------------------
;level_5	TEKUTEKU_destroy
;-------------------------------------------------------------
;;;;;stepsos31_5a
;switch_door
	m_inertpath	1024+256,4,11*1024+140,0,kabe_aku,e_final_door
;tobidashi_tekuteku
	m_inertpath	256,-75,11*1024-256,-64,tekuteku_s,e_tunnel_tobidashi_m_final
	m_inertpath	400,-75,8*1024+100,128,tekuteku_s,e_tunnel_tobidashi_p_final
	m_inertpath	1024+400,-75,10*1024+100,128,tekuteku_s,e_tunnel_tobidashi_p_final
	m_inertpath	2*1024+100,-75,9*1024+600,128,tekuteku_s,e_tunnel_tobidashi_m_final
;medal_$2e
	m_inertpath	2*1024+300,-100,8*1024+200,$2e,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;level_9	TEKUTEKU_destroy with KURUKURU_doors
;-------------------------------------------------------------
stepsos31_9a
;switch_door
	m_inertpath	1024+256,3,11*1024+140,0,kabe_aku,e_final_door
;kurukuru_no_hit_doors
	m_inertpath	512,000,8*1024+512,4,t_to_3,e_hit_dont_stop_door
	m_inertpath	2*1024-256,000,9*1024-256,-4,t_to_3,e_hit_dont_stop_door
	m_inertpath	2*1024-128,000,10*1024+128,8,t_to_3,e_hit_dont_stop_door
	m_inertpath	256,000,10*1024+256,-8,t_to_3,e_hit_dont_stop_door
;tobidashi_tekuteku
	m_inertpath	2*1024+256,-75,11*1024-256,-64,tekuteku_s,e_tunnel_tobidashi_m_final
	m_inertpath	1024+100,-75,8*1024+600,128,tekuteku_s,e_tunnel_tobidashi_m_final
	m_inertpath	1024+100,-75,10*1024+100,128,tekuteku_s,e_tunnel_tobidashi_m_final
;kabe_hou
	m_inertpath	-32,-150,10*1024-300,-deg90,tsu_hou_t,e_kabe_hou
;medal_$3e
	m_inertpath	200,-100,11*1024-200,$3e,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;level_13	R_TANK_destroy
;-------------------------------------------------------------
stepsos31_13a
;switch_door
	m_inertpath	1024+256,3,11*1024+140,0,kabe_aku,e_final_door
;r_tank
	pathobj		0,2*1024-256,00,10*1024+256,r_tank_0,e_root_tank_final,1,10
	pathobj		0,2*1024-256,00,9*1024-256,r_tank_0,e_root_tank_final,2,10
;medal_$4b
	m_inertpath	2*1024+400,-100,7*1024+256,$4b,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;
;	tsuuro room
;
;-------------------------------------------------------------
stepsos31_7
stepsos31_d
;area_check
	map_area 7,1024-512,8*1024+512,1024+512,1024,0,off,inactive
	map_area 8,1024,8*1024,512,2*1024,0,off,inactive
;r_tank
	pathobj		0,2*1024+256,00,11*1024-512,r_tank_0,e_root_tank_final2,1,10
;kado
	m_inertpath	1024+512,0000,8*1024+512,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	1024+512,0000,9*1024+512,0,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,9*1024+512,deg90,kado_1,e_buil_shadow_off
	m_inertpath	1024,0000,8*1024+512,deg180,kado_1,e_buil_shadow_off
;kabe
	m_inertpath	1024,0000,9*1024,deg90,kabe_0,e_nocol_s_off
;level_check(7 or d)
	mapgotoiflevel	14,stepsos31_da	;HARD_SENKAN_room
;-------------------------------------------------------------
;level_7	R_TANK_destroy
;-------------------------------------------------------------
;stepsos31_7a
;switch_door
	m_inertpath	1024+256,1,11*1024+140,0,kabe_aku,e_final_door
	map_endarea
;-------------------------------------------------------------
;level_d	R_TANK and YUKAMUKADE destroy
;-------------------------------------------------------------
stepsos31_da
;switch_door
	m_inertpath	1024+256,3,11*1024+140,0,kabe_aku,e_final_door
;kabe_yamori
	pathobj		0,-32+60,-100,10*1024,yamori_b,e_yamori,2,0
	pathobj		0,2*1024+512+32-60,-100,8*1024,yamori_b,e_yamori,3,128
	map_endarea
;-------------------------------------------------------------
;
;	tobira room
;
;-------------------------------------------------------------
;level_11	LAUNCHER_destroy in meiro
;-------------------------------------------------------------
stepsos31_11
;switch_door
	m_inertpath	1024+256,4,11*1024+140,0,kabe_aku,e_final_door
;
	m_inertpath	150,-60,7*1024+100,-64,taihou_0,e_laser_hou_final
	m_inertpath	100,-60,11*1024-150,128,taihou_0,e_laser_hou_final
	m_inertpath	2*1024-350,-60,9*1024+256,-64,taihou_0,e_laser_hou_final
	m_inertpath	2*1024+150,-60,8*1024-150,0,taihou_0,e_laser_hou_final
;meiro
	m_inertpath	256-32,000,8*1024-256+32,0,t_hako_1,e_hako_6
	m_inertpath	1024-256-32,000,8*1024-256+32,0,t_hako_1,e_hako_2
	m_inertpath	2*1024-256+32,000,8*1024-256+32,0,t_hako_1,e_hako_2
;
	m_inertpath	1024+256-32,000,9*1024-256-32,0,t_hako_1,e_hako_2
	m_inertpath	2*1024-256-32,000,9*1024-256-32,0,t_hako_1,e_hako_2
	m_inertpath	256-32,000,9*1024+256-32,0,t_hako_1,e_hako_6
	m_inertpath	1024+256-32,000,9*1024+256-32,0,t_hako_1,e_hako_2
;
	m_inertpath	2*1024+256+32,000,10*1024-256,0,t_hako_1,e_hako_4
	m_inertpath	1024-256+32,000,10*1024+256+32,0,t_hako_1,e_hako_2
	m_inertpath	1024+256+32,000,10*1024+256+32,0,t_hako_1,e_hako_2
	m_inertpath	1024-256+32,000,11*1024-256+32,0,t_hako_1,e_hako_5
	m_inertpath	2*1024+256+32,000,11*1024-256+32,0,t_hako_1,e_hako_5
;hit_side_open_doors
	m_inertpath	1024-256,000,7*1024,deg90,t_to_1,e_hit_open_door_1
	m_inertpath	1024,000,8*1024-256+32,0,t_to_1,e_hit_open_door_1
	m_inertpath	2*1024+512,000,9*1024-256-32,deg180,t_to_1,e_hit_open_door_1
	m_inertpath	0000,000,10*1024+256,0,t_to_1,e_hit_open_door_1
	m_inertpath	1024+256,000,10*1024,-deg90,t_to_1,e_hit_open_door_1
;medal_$4a
	m_inertpath	200,-100,8*1024+200,$4a,medal,e_omake_medal
	map_endarea

;-----------------------------------------
;-----------------------------------------
;-----------------------------------------
stepsos31_1
stepsos31_3
;kabe
	m_inertpath	512,0000,8*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	512,0000,10*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	2*1024,0000,8*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	2*1024,0000,10*1024,deg90,kabe_2,e_nocol_s_off
;kado
	m_inertpath	512,0000,6*1024+512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	2*1024,0000,6*1024+512,0,kado_4,e_nocol_s_off
	m_inertpath	512,0000,11*1024+512,deg180,kado_4,e_nocol_s_off
	m_inertpath	2*1024,0000,11*1024+512,deg90,kado_4,e_nocol_s_off
;-------------------------------------------------------------
;level_check (1 or 3 )
	mapgotoiflevel	4,stepsos31_3a	;EASY_SENKAN_room
;-----------------------------------------
;stepsos31_1
;hako
	m_inertpath	1024+64-32,000,8*1024-256,0,t_hako_1,e_hako_3
	m_inertpath	1024+512-64+32,000,10*1024-256,0,t_hako_1,e_hako_3
;batabata
	m_inertpath	1024+256,-140,9*1024,deg180,batabata,e_uso_enemy
	m_inertpath	1024+256,-140,10*1024+256,deg180,batabata,e_uso_enemy

	m_inertpath	1024+256,0000,9*1024,deg90,dan_ashi,e_nocol_s_off
	m_inertpath	1024+256,0000,10*1024+256,deg90,dan_ashi,e_nocol_s_off
;;sagyou
;	m_inertpath	1024+256,-80,9*1024+400,deg180,sagyou_r,e_new_sagyou_r
;medal_$1e
	m_inertpath	1024+100,-100,8*1024,$1e,medal,e_omake_medal
	map_endarea
;-----------------------------------------
stepsos31_3a
;hit_rot_door
	m_inertpath	1024+16,0000,8*1024,0,t_to_0,e_hit_open_door_0
	m_inertpath	1024+512-16,0000,8*1024,deg180,t_to_0,e_hit_open_door_0
	m_inertpath	1024+16,0000,9*1024+512,0,t_to_0,e_hit_open_door_0
	m_inertpath	1024+512-16,0000,9*1024+512,deg180,t_to_0,e_hit_open_door_0
;tobidashi_tekuteku
	m_inertpath	1024+100,-75,8*1024+512,128,tekuteku_s,e_tunnel_tobidashi_p
	m_inertpath	1024+400,-75,10*1024,128,tekuteku_s,e_tunnel_tobidashi_m
	map_endarea
;-----------------------------------------
;-----------------------------------------
;	CORE ROOM
;-----------------------------------------
;-----------------------------------------
sos3_area2
;b_kabe
	m_inertpath	1024+256,0000,14*1024+512,deg180,b_kabe_3,e_nocol_s_off
;b_kado
	m_inertpath	-512,0000,11*1024+512,-deg90,b_kado_2,e_nocol_s_off
	m_inertpath	3*1024,0000,11*1024+512,0,b_kado_2,e_nocol_s_off
	m_inertpath	-512,0000,14*1024+512,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	3*1024,0000,14*1024+512,deg90,b_kado_2,e_nocol_s_off
;------------------------------
;level_check
;next_core_engin
	mapgotoiflevel	10,stepsos32_next	;normal_9
	mapgotoiflevel	18,stepsos32_next	;hard_11
	mapgotoiflevel	20,stepsos32_next	;hard_13
;first_core_engin
	m_inertpath	1024+256,00,13*1024,0,kaku4_1,e_carier_core
;HOUDAI
	mapgotoiflevel	8,stepsos32_houdai	;normal_7
	mapgotoiflevel	16,stepsos32_houdai2	;hard_f
;MEDAL
	mapgotoiflevel	12,stepsos32_medal	;normal_b
	map_endarea
;------------------------------
stepsos32_houdai2
;medal_$4f
	m_inertpath	1024+256,-100,14*1024-256,$4f,medal,e_omake_medal
stepsos32_houdai
;kabe_hou
	m_inertpath	-32,-150,13*1024,-deg90,tsu_hou_t,e_kabe_hou
	m_inertpath	2*1024+512+32,-150,13*1024,deg90,tsu_hou_t,e_kabe_hou
	map_endarea
;------------------------------
stepsos32_medal
;medal_$3f
	m_inertpath	1024+256,-100,14*1024-256,$3f,medal,e_omake_medal
	map_endarea
;------------------------------
stepsos32_next
;next_core_engin
	pathobj		0,1024+256,-5<<kaku6_scale,13*1024,kaku6_3,e_carier_core_2,10,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp
