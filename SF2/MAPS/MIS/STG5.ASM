;ษออออออออออออออออออออออออออออออออออออออออออป
;บ STAGE 5 METEOBASE ground_room	       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;-----------------------------------------
;-----------------------------------------
;-----clear bg set-------------
	setstgclrbg	missionstage5
;-----ground or room check-----
	mapgotoifplanet	stg5room
;-----ground start inicial-------
	setbg	missionstage5
	initbg
;-----room start inicial-------
	map_demomode	off
	map_nextmap	stg5room_cnt,enter_chika	;room mode
;-----------------------------------------
;*********************
;*****GROUND MODE*****
;*********************
;-----------------------------------------
	map_vscreensize_mission	2

;	m_range	8192
	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

;-----------------------------------------
;**** MAP SET START ****
;-----------------------------------------
;ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บmap_arwinginit		high,low,rotXmax,rotYmin                    บ
;บmap_battlearea		high,low,depth,type	(koudokei)          บ
;บmap_camerainit_1screen	midY,Yoffsetmax,rotXmax,rotXmin,Yoffsetrate บ
;บmap_camerainit_2screen	,,,,,	                                    บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
;players_position
	map_playermode		desert
	map_setplayerpos	1,0000,-300,-3500,0
	map_battlearea		-800,0,0,sand
	map_camerainit_1screen	-300,0,16,-16,55H
	map_arwinginit		-800,-12,15,-15
;-----------------------
;dots_set
	map_setdust	sprites		
	map_dustsprite	asteroid,8		;inseki,size
	map_dustkazu	32
;area_out_check
	map_playerblockmap_off	1	;area out off
;planet_message
	pathobj 	0,5*1024,0000,5*1024,stg_checker,e_game_maker_planet,10,10
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10
;walker_start
	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;---------------------------------
;map_area_set
	map_area 0,-4*1024,-4*1024,8*1024,8*1024,0,on,inactive
;rader_area_message
	map_mapareaout	on
;view_range
	map_maxrange	4000
;kakomi
	m_inertpath	02048,512,02048,0,kakomi,e_nocol_s_off_g
	m_inertpath	-2048,512,02048,deg90,kakomi,e_nocol_s_off_g
	m_inertpath	02048,512,-2048,-deg90,kakomi,e_nocol_s_off_g
	m_inertpath	-2048,512,-2048,deg180,kakomi,e_nocol_s_off_g
;-------------------------------------------------------------
;**** MAP STEPSET AREA (ground)****
;-------------------------------------------------------------
;;;;;	mapgotoiflevel	1,step5_0	;EASY_ground
	mapgotoiflevel	3,step5_2	;NOMAL_ground
	mapgotoiflevel	5,step5_4	;HARD_ground
;-------------------------------------------------------------
;-------------------------------------------------------------
;;;;;step5_0
;base
	pathobj		0,0000,0,2800,chika_k0,e_switch_base,1,-64
;kani
	pathobj		0,2000,-350,2000,kani_0,e_new_kani,1,10
;way
	m_inertpath	00000,00,0800,0,way_0,e_nocol_s_off_g
	m_inertpath	00000,00,-800,0,way_0,e_nocol_s_off_g
	m_inertpath	00000,00,-2400,0,way_0,e_nocol_s_off_g
;hodoukyou
	m_inertpath	0000,-158,-2000,0,hasi0_1,e_building
	m_inertpath	0550,0000,-2000,0,hasi0_2,e_buil_shadow_off
	m_inertpath	-550,0000,-2000,0,hasi0_0,e_buil_shadow_off
;mogura
	m_inertpath	500,0000,000,0,ana_0,e_mogura_ana_laser
;build
	m_inertpath	0500,00,-3200,0,nobiru,e_hako_1
;teki
	m_inertpath	2000,-500,-3000,64,boyon,e_wakidashi_boyon
	m_inertpath	-3000,-500,2000,-100,boyon,e_wakidashi_boyon
;heart_item
	m_inertpath	3000,0,-3000,1,itembox0,e_panel_flamethrower
;twin_item
	m_inertpath	-100,-050,-2000,2,item_ita,e_item_twinblaster
;kaifuku
	m_inertpath	-500,0000,0000,0,kaifuku,e_kaifuku_panel
	m_inertpath	-500,-120,0000,0,arrow_0,e_sw_arrow
;missile_medal_$18
	m_inertpath	-3000,-490,-3000,$18,dandou_tate,e_ground_dandou_medal
	m_inertpath	-3000,0000,-3000,-deg90,miss_dai,e_miss_dai_live
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step5_2
;base
	pathobj		0,0000,0,1000,chika_k0,e_houdai_base,3,64
;way
	m_inertpath	01000,00,02000,-deg45,way_0,e_nocol_s_off_g
	m_inertpath	-1000,00,00000,-deg45,way_0,e_nocol_s_off_g
	m_inertpath	-1000,00,02000,deg45,way_0,e_nocol_s_off_g
	m_inertpath	01000,00,00000,deg45,way_0,e_nocol_s_off_g
;machi
	m_inertpath	03000,0,3000,-deg90,machi_0,e_buil_shadow_off
;build_taihou
;;;	m_inertpath	-3000,00,00500,0,nobiru,e_hako_2
;;;	m_inertpath	-3000,-290,500,0,taihou_0,e_laser_hou
	m_inertpath	3000,00,-0500,0,nobiru,e_hako_2
	m_inertpath	3000,-290,-500,0,taihou_0,e_laser_hou
	m_inertpath	-3500,-60,3500,0,taihou_0,e_laser_hou
;sagyou
;;;	m_inertpath	-2800,-80,500,64,sagyou_r,e_new_sagyou_r
	m_inertpath	3400,-320-80,2900,00,sagyou_r,e_new_sagyou_r
;teki
	m_inertpath	1500,-400,1500,100,boyon,e_wakidashi_boyon
	m_inertpath	00,-300,-1500,-100,boyon,e_wakidashi_boyon
;saka1
	m_inertpath	1000,000,-2900,0,saka_0_0,e_buil_shadow_off
	m_inertpath	1000,-80,-2500,0,saka_0_1,e_building
	m_inertpath	1000,000,-2100,deg180,saka_0_0,e_buil_shadow_off
	m_inertpath	-1000,000,-2900,0,saka_0_0,e_buil_shadow_off
	m_inertpath	-1000,-80,-2500,0,saka_0_1,e_building
	m_inertpath	-1000,000,-2100,deg180,saka_0_0,e_buil_shadow_off
;shield_item
	m_inertpath	-3200,0,3200,1,itembox0,e_panel_shieldplayer
;twin_item
	m_inertpath	-1000,-50,-2500,2,item_ita,e_item_twinblaster
;kaifuku
	m_inertpath	02000,0000,-2500,0,kaifuku,e_kaifuku_panel
;missile_medal_$28
	m_inertpath	-3200,-490,-3200,$28,dandou_tate,e_ground_dandou_medal
	m_inertpath	-3200,0000,-3200,-deg90,miss_dai,e_miss_dai_live
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step5_4
;base
	pathobj		0,-1000,0,500,chika_k0,e_switch_base,2,00
;suisya_switch
	m_inertpath	-1000,00,3500,1,suisya_1,e_sw_base_kaiten2
	pathobj		0,-1000,000,3500,nullshape,e_sw_marker,1,10
;rouret_switch
	m_inertpath	3200,0,-3200,2,ataru2_1,e_sw_base_kaiten1
	pathobj		0,3200,000,-3200,nullshape,e_sw_marker,2,10
;way
	m_inertpath	02800,00,02220,00,way_2,e_nocol_s_off_g
	m_inertpath	02200+40,00,02530,deg45,way_0,e_nocol_s_off_g
	m_inertpath	01400-5,00,03375,deg45,way_2,e_nocol_s_off_g
	m_inertpath	00400,00,03200,deg90,way_0,e_nocol_s_off_g
;
	m_inertpath	-0800,00,-1600,deg90,way_1,e_nocol_s_off_g
	m_inertpath	-0800,00,-2800,00,way_0,e_nocol_s_off_g
	m_inertpath	00400,00,-1600,deg90,way_0,e_nocol_s_off_g
	m_inertpath	00700,00,-1600,deg90,way_0,e_nocol_s_off_g
	m_inertpath	01850,00,-1600,-deg90,way_2,e_nocol_s_off_g
	m_inertpath	02200,00,-1000,-deg45,way_0,e_nocol_s_off_g
	m_inertpath	03000,00,-0200,-deg45,way_2,e_nocol_s_off_g
;tunnel
	m_inertpath	2800-0540,0000,0800,-deg90,yama_0_1,e_buil_shadow_off
	m_inertpath	02800,-310,0800,0,yama_0_0,e_building
	m_inertpath	2800+0540,0000,0800,deg90,yama_0_1,e_buil_shadow_off
;mogura
	m_inertpath	-3200,0000,3200,0,ana_0,e_mogura_ana_laser
	m_inertpath	3500,0000,-1000,0,ana_0,e_mogura_ana_laser
;missile
	m_inertpath	-3200,-490,-3000,0,dandou_tate,e_ground_dandou_a
	m_inertpath	-3200,0000,-3000,-deg90,miss_dai,e_miss_dai_live
;boyon
	m_inertpath	-2000,-400,2000,100,boyon,e_wakidashi_boyon
	m_inertpath	1800,-400,-1800,00,boyon,e_wakidashi_boyon
;kaifuku
	m_inertpath	02800,0000,0800,0,kaifuku,e_kaifuku_panel
;twin_item
	m_inertpath	-3700,0000,-3700,1,itembox0,e_panel_twinblaster
;shield_item
	m_inertpath	3500,0,3500,2,itembox0,e_panel_shieldplayer
;medal_$38
	m_inertpath	2800,-100,1000,$38,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;;suisya_switch
;	m_inertpath	800,00,2500,1,suisya_1,e_sw_base_kaiten2
;	pathobj		0,800,000,2500,nullshape,e_sw_marker,1,10
;;way
;	m_inertpath	02800,00,02220,00,way_2,e_nocol_s_off_g
;	m_inertpath	02200+40,00,02530,deg45,way_0,e_nocol_s_off_g
;	m_inertpath	01400-5,00,03375,deg45,way_2,e_nocol_s_off_g
;	m_inertpath	00400,00,03200,deg90,way_0,e_nocol_s_off_g
;	m_inertpath	-0800,00,03200,deg90,way_1,e_nocol_s_off_g
;	m_inertpath	-0800,00,02000,0,way_0,e_nocol_s_off_g
;	m_inertpath	-0800,00,00800,-deg90,way_1,e_nocol_s_off_g
;	m_inertpath	-2000,00,00800,deg90,way_0,e_nocol_s_off_g
;	m_inertpath	-3200,00,00800,deg90,way_1,e_nocol_s_off_g
;	m_inertpath	-3200,00,-0400,0,way_0,e_nocol_s_off_g
;	m_inertpath	-3200,00,-1600,deg180,way_1,e_nocol_s_off_g
;	m_inertpath	-2000,00,-1600,deg90,way_0,e_nocol_s_off_g
;	m_inertpath	-0800,00,-1600,00,way_3,e_nocol_s_off_g
;	m_inertpath	-0800,00,-2800,00,way_0,e_nocol_s_off_g
;	m_inertpath	00400,00,-1600,deg90,way_0,e_nocol_s_off_g
;	m_inertpath	00700,00,-1600,deg90,way_0,e_nocol_s_off_g
;	m_inertpath	01850,00,-1600,-deg90,way_2,e_nocol_s_off_g
;	m_inertpath	02200,00,-1000,-deg45,way_0,e_nocol_s_off_g
;	m_inertpath	03000,00,-0200,-deg45,way_2,e_nocol_s_off_g
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
stg5room
	map_vscreensize_mission	6

;	m_range	8192
	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick

stg5room_cnt

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
;players_position
	map_playermode		room

	map_setplayerpos	1,1024+512,-120-20,20,0
	map_battlearea		-300,0,0,ground
	map_camerainit_1screen	-080,100,16,-16,55H
	map_arwinginit		-300,-12,15,-15

	map_playerblockmap_on	1	;block map on

;tunnel_mode
	map_playertunnel
	map_tutudepth
;-----------------------
;dots_set
	map_setdust	coloured		
	map_dustkazu	8
;-------------------------------------------------------------
;shinnyuu_demo

	map_demomode		start_chika
	map_demomode_clear	clear_chika
;-----------------------
;planet_message
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10
;;walker_start
;	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;-----------------------------------------
;**** MAP STEPSET AREA (room)****
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
;1_way_door_final
	m_inertpath	1024+512,1,7*1024-140,deg180,kaku_to,e_final_1way_door
;tsuuro_final
	m_inertpath	1024+512,1,6*1024+512,0,kabe_to,e_buil_shadow_off_g
;1way_door
	m_inertpath	1024+512,2,4*1024-140,deg180,kabe_ak1,e_1way_door
;tsuuro
	m_inertpath	1024+512,2,3*1024+512,0,kabe_to,e_buil_shadow_off_g
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area_check
	map_area 0,0000,0000,3*1024,4*1024,stg5_area0,on
	map_area 1,512,3*1024,2*1024,4*1024,stg5_area1,on
	map_area 2,512,6*1024,2*1024,2*1024+512,stg5_area2,on
	map_area 3,0000,3*1024,1024,1024,0,off,inactive
	map_area 4,2*1024,3*1024,1024,1024,0,off,inactive
	map_area 5,512,6*1024,512,1024,0,off,inactive
	map_area 6,2*1024,6*1024,512,1024,0,off,inactive
	map_endarea
;-----------------------------------------
stg5_area0
;entrance
	m_inertpath	1024+512,0000,-512,0,kabe_to3,e_nocol_s_off
;switch_door
	m_inertpath	1024+512,1,3*1024+140,0,kabe_aku,e_switch_op_door
;kado
	m_inertpath	-512,0000,-512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	3*1024+512,0000,-512,0,kado_2,e_nocol_s_off
	m_inertpath	-512,0000,3*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	3*1024+512,0000,3*1024+512,deg90,kado_2,e_nocol_s_off
;-----------------------------------------
;level_check
	mapgotoiflevel	6,stg55_area0	;HARD_area0
;-----------------------------------------
;hashira_houdai
	m_inertpath	512+300,000,2*1024+512-300,0,ha_hou_0,e_hako_hou
	m_inertpath	2*1024+512-300,000,2*1024+512-300,0,ha_hou_0,e_hako_hou
;-----------------------------------------
;level_check
	mapgotoiflevel	4,stg53_area0	;NOMAL_area0
;stg51_area0	;EASY_area0
;kabe
	m_inertpath	-512,0000,1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	3*1024+512,0000,1024+512,deg90,kabe_0,e_nocol_s_off
;switch_robo
	m_inertpath	2*1024+512,-80,2*1024-256,$41,sagyou_r,e_sagyou_walk_switch_aku
;wall
	m_inertpath	1024+512,000,1024+512,deg90,t_hako_1,e_hako_0
;sagyou_box_medal_$41
	m_inertpath	512,-80,1024+256,-deg90,sagyou_r,e_sagyou_walk_box
	map_endarea
;-----------------------------------------
stg53_area0	;NOMAL_area1
;kabe
	m_inertpath	-512,0000,1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	3*1024+512,0000,1024+512,deg90,kabe_0,e_nocol_s_off
;switch_cup
	m_inertpath	1024+512,0,1024+512-256,1,cup_0,e_switch_cup_hard
;wall
	m_inertpath	1024-400,000,256-32,0,t_hako_1,e_hako_0
	m_inertpath	2*1024+400,000,256-32,0,t_hako_1,e_hako_0
;tobidashi_tekuteku
	m_inertpath	3*1024-200,-75,400,deg90,tekuteku_s,e_tunnel_tobidashi_p
;medal_$29
	m_inertpath	200,-80,200,$29,medal,e_omake_medal
	map_endarea
;-----------------------------------------
stg55_area0	;HARD_area1
;kado_right
	m_inertpath	3*1024,0000,1024+512,deg90,kado_1,e_buil_shadow_off
	m_inertpath	3*1024,0000,1024+512,deg180,kado_1,e_buil_shadow_off
	m_inertpath	3*1024+512,0000,1024+512,0,kado_4,e_nocol_s_off
	m_inertpath	3*1024+512,0000,1024+512,deg90,kado_4,e_nocol_s_off
;door_switch
	m_inertpath	1024+512,0,1024+400,1,on_d,e_fumu_switch_door_map_aku
;saka
	m_inertpath	1024-32,000,1024+256+32+256,deg90,t_saka_0,e_hako_2
	m_inertpath	2*1024+32,000,1024+256+32+256,-deg90,t_saka_0,e_hako_2
	m_inertpath	1024-32,000,1024-256-32+256,deg90,t_saka_0,e_hako_2
	m_inertpath	2*1024+32,000,1024-256-32+256,-deg90,t_saka_0,e_hako_2
;damage_pillar
	m_inertpath	1024+512,-100,1024-450+256,$01,da_ha_yo,e_damage_bou
	m_inertpath	1024+512,-100,1024+450+256,$01,da_ha_yo,e_damage_bou

;;taihou
;	m_inertpath	512+300,-60,2*1024+512-300,0,taihou_0,e_laser_hou
;	m_inertpath	2*1024+512-300,-60,2*1024+512-300,0,taihou_0,e_laser_hou
;;guruguru_trap
;	m_inertpath	1024+512,000,1024+512,0,nobiru,e_hako_1
;	m_inertpath	1024+512,-40,1024+512,-8,toge_0,e_guruguru_bar
;;open_switch
;	m_inertpath	1024+512,-160,1024+512,1,on_d,e_fumu_switch_door_map_aku
;kado_left
	m_inertpath	0000,0000,1024+512,0,kado_1,e_nocol_s_off
	m_inertpath	0000,0000,1024+512,-deg90,kado_1,e_nocol_s_off
;
	m_inertpath	-512,0000,1024+512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	-512,0000,1024+512,deg180,kado_4,e_nocol_s_off
;area_check
	map_area 7,0000,1024,512,1024,stg55_area3,on
	map_endarea
;-----------------------------------------
stg55_area3
;kabe_secret
	m_inertpath	-512,0000,1024+512,-deg90,kabe_0,e_nocol_s_off
;medal_$39
	m_inertpath	120,-80,1024+512,$39,medal,e_omake_medal
	map_endarea
;-----------------------------------------
;
;-----------------------------------------
stg5_area1	;ALL_level
;kabe
	m_inertpath	0000,0000,5*1024,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	3*1024,0000,5*1024,deg90,kabe_0,e_nocol_s_off
;kado
	m_inertpath	0000,0000,3*1024+512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	3*1024,0000,3*1024+512,0,kado_3,e_nocol_s_off
	m_inertpath	0000,0000,6*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	3*1024,0000,6*1024+512,deg90,kado_3,e_nocol_s_off
;-----------------------------------------
;level_check
	mapgotoiflevel	4,stg53_area1	;NOMAL_area1
	mapgotoiflevel	6,stg55_area1	;NOMAL_area1
;-----------------------------------------
	;EASY_area1
;final_door
	m_inertpath	1024+512,1,6*1024+140,0,kabe_aku,e_final_door
;pillar
	m_inertpath	1024+256,00,5*1024+256,0,t_hako_1,e_hako_3
	m_inertpath	2*1024-256,00,5*1024-256,0,t_hako_1,e_hako_3
;karakasa_robot
	pathobj		0,1024-128,-150,5*1024+512+128,egu_0,e_tamanage_robo_final,1,0
	map_endarea
;-----------------------------------------
stg53_area1	;NOMAL_area1
;final_door
	m_inertpath	1024+512,2,6*1024+140,0,kabe_aku,e_final_door
;pillar
	m_inertpath	1024+128,00,4*1024+512+100,0,t_hako_1,e_hako_1
	m_inertpath	2*1024-128,00,5*1024+512-100,0,t_hako_1,e_hako_1
;kabe_yamori
	pathobj		0,512-32+60,-100,5*1024,yamori_b,e_yamori,1,0
	pathobj		0,2*1024+512+32-60,-100,5*1024,yamori_b,e_yamori,2,128
	map_endarea
;-----------------------------------------
stg55_area1	;HARD_area1
;final_door
	m_inertpath	1024+512,2,6*1024+140,0,kabe_aku,e_final_door
;pillar
	m_inertpath	1024+512,00,5*1024-256,deg90,t_hako_1,e_hako_0
	m_inertpath	1024+512,00,5*1024+256,deg90,t_hako_1,e_hako_0
;tenjou_yamori
	pathobj		0,1024+512,-320+60,5*1024,yamori_b,e_tenjyou_yamori,1,10
;karakasa_robot
	pathobj		0,1024-128,-150,5*1024+512+128,egu_0,e_tamanage_robo_final,1,0
	map_endarea
;-----------------------------------------
;-----------------------------------------
;
;-----------------------------------------
stg5_area2
;b_kado
	m_inertpath	0000,0000,6*1024+512,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	3*1024,0000,6*1024+512,0,b_kado_3,e_nocol_s_off
	m_inertpath	0000,0000,9*1024,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	3*1024,0000,9*1024,deg90,b_kado_2,e_nocol_s_off
;core
	m_inertpath	1024+512,00,8*1024-256,0,kaku_0_0,e_base_core
	map_endarea
;-----------------------------------------
;-----------------------------------------
;;-------------------------------------------------------------
;-------------------------------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp







;-------------------------------------------------------------
;-------------------------------------------------------------
;
;
;
;
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;
;
;
;
;-------------------------------------------------------------
;-------------------------------------------------------------

	IFEQ	1
;*********************
;***** ROOM MODE *****
;*********************
stg5room
	map_vscreensize_mission	6

;	m_range	8192
	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick

stg5room_cnt

	setbg	tutu
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
;radar
;	setvar	kx_radarscale,-1
;tunnel_mode
	map_playertunnel
	map_tutudepth
;-----------------------
;dots_set
	map_setdust	coloured		
	map_dustkazu	8
;planet_message
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0
;---
;---

	map_playermode		space
	map_setplayerpos	1,0,512,0000,0
	map_playerblockmap_off	1	;area out off
	map_arwinginit		-300,1024,15,-15

	map_playerblockmap_on	1	;block map on

;-------------------------------------------------------------
;shinnyuu_demo

	map_demomode		start_chika
	map_demomode_clear	clear_chika


;	map_demomode	meteo
;	map_demomode	off
;-----------------------------------------
;player_ufo_change
	pathobj	0,00000,0000,00000,nullshape,e_auto_ufo_lock,10,10
;-------------------

;**** MAP STEPSET AREA (room)****
;-------------------------------------------------------------
;core_engin
;	m_inertpath	0000,600,-1000,0,kaku_0_0,e_base_core
;	m_inertpath	1000,600,00000,0,kaku_0_0,e_base_core
	m_inertpath	0000,600,01000,0,kaku_0_0,e_base_core
;
	mapgotoiflevel	2,step5_1	;EASY_room
	mapgotoiflevel	4,step5_3	;NOMAL_room
	mapgotoiflevel	6,step5_5	;HARD_room
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step5_1
;players_position
	map_playerTUTUmode	down,tutu1
;;room_antenna
;	m_inertpath	0000,512,1800,00,r_an_0big,e_room_antennabig
;	m_inertpath	1559,512,-900,-85,r_an_0big,e_room_antennabig
;	m_inertpath	-1559,512,-900,85,r_an_0big,e_room_antennabig
;kabe_hou
	m_inertpath	0000,700,-1800,00,tsu_hou,e_kabe_hou
	m_inertpath	1559,512,0900,85,tsu_hou,e_kabe_hou
	m_inertpath	-1559,256,900,-85,tsu_hou,e_kabe_hou
;roof
	m_inertpath	00000,-300,0000,0,yuka_1,e_nocol_s_off_g
;bottom
;	m_inertpath	00000,4*1024+512,0000,0,yuka_1,e_nocol_s_off
	m_inertpath	00000,1224,0000,0,yuka_1,e_nocol_s_off_g

;kabe
	m_inertpath	00900,0512,01559,105,tsutsu_0,e_nocol_s_off
	m_inertpath	01800,0512,00000,64,tsutsu_0,e_nocol_s_off
	m_inertpath	00900,0512,-1559,21,tsutsu_0,e_nocol_s_off
	m_inertpath	-0900,0512,-1559,-21,tsutsu_0,e_nocol_s_off
	m_inertpath	-1800,0512,00000,-64,tsutsu_0,e_nocol_s_off
	m_inertpath	-0900,0512,01559,-105,tsutsu_0,e_nocol_s_off

	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step5_3
;players_position
	map_playerTUTUmode	down,tutu3
;roof
	m_inertpath	00000,-300,0000,0,yuka_1,e_nocol_s_off_g
;bottom
	m_inertpath	00000,1224+512,0000,0,yuka_1,e_nocol_s_off_g
;kabe
	m_inertpath	00900,0512,01559,105,tsutsu_0,e_nocol_s_off
	m_inertpath	01800,1024,00000,64,tsutsu_0,e_nocol_s_off
	m_inertpath	00900,0512,-1559,21,tsutsu_0,e_nocol_s_off
	m_inertpath	-0900,1024,-1559,-21,tsutsu_0,e_nocol_s_off
	m_inertpath	-1800,0512,00000,-64,tsutsu_0,e_nocol_s_off
	m_inertpath	-0900,1024,01559,-105,tsutsu_0,e_nocol_s_off
;;kabe_hou
;	m_inertpath	0000,600,-1800,00,tsu_hou,e_kabe_hou
;	m_inertpath	1559,600,0900,85,tsu_hou,e_kabe_hou
;	m_inertpath	-1559,600,900,-85,tsu_hou,e_kabe_hou
;	m_inertpath	1559,000,-900,43,tsu_hou,e_kabe_hou
;	m_inertpath	-1559,000,-900,-43,tsu_hou,e_kabe_hou
;	m_inertpath	00000,000,1800,127,tsu_hou,e_kabe_hou
;;missile
;	m_inertpath	1559,800+512,-0900,0,dandou_tate,e_ground_dandou_a
;	m_inertpath	-1559,800+512,-900,0,dandou_tate,e_ground_dandou_a
;	m_inertpath	00000,800+512,1800,0,dandou_tate,e_ground_dandou_a

	m_inertpath	01800,0512,00200,deg90,te_0_1,ktest
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step5_5
;players_position
	map_playerTUTUmode	down,tutu5
;roof
	m_inertpath	00000,-300,0000,0,yuka_1,e_nocol_s_off_g
;bottom
	m_inertpath	00000,1224,0000,0,yuka_1,e_nocol_s_off_g
	map_endarea
;-----------------------------------------



;;;-------------------------------------------------------------
;-------------------------------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp


tutu1	dw	1024
	dw	0

tutu3	dw	4096
	dw	0

tutu5	dw	1024
	dw	1024
	dw	1024
	dw	1024
	dw	1024
	dw	0
;--------------------------------
;--------------------------------
	ENDC
