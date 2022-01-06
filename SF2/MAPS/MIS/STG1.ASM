;ษออออออออออออออออออออออออออออออออออออออออออป
;บ STAGE 1 VENOM ground_room		       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;-----------------------------------------
;-----------------------------------------
;-----clear bg set-------------
	setstgclrbg	missionstage1
;-----ground or room check-----
	mapgotoifplanet	stg1room
;-----ground start inicial-------
	setbg	missionstage1
	initbg
;-----room start inicial-------
	map_demomode	off
	map_nextmap	stg1room_cnt,enter_chika
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
	map_playermode		ground
	map_setplayerpos	1,0000,-300,-3500,0
	map_battlearea		-600,0,0,ground
	map_camerainit_1screen	-300,1,16,-16,55H
	map_arwinginit		-600,-12,15,-15
;-----------------------
;dots_set
	map_setdust	sprites		
	map_dustsprite	kusa,8		;kusa
	map_dustkazu	32
;;---------------------------------
;;area_out_check
;	map_playerblockmap_off	1	;area out off
;;planet_message
;	pathobj 	0,5*1024,0000,5*1024,stg_checker,e_game_maker_planet,10,10
;;enemy_count
;	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10
;;walker_start
;	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;;---------------------------------
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
;---------------------------------
;planet_message
	pathobj 	0,5*1024,0000,5*1024,stg_checker,e_game_maker_planet,10,10
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10
;---------------------------------
;;;;; training mode check ;;;;;
;---------------------------------
	mapgotoiflevel	7,training_mode
;---------------------------------
;area_out_check
;---------------------------------
	map_playerblockmap_off	1	;area out off
;---------------------------------
;walker_start
	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;---------------------------------
;-------------------------------------------------------------
;**** MAP STEPSET AREA (ground)****
;-------------------------------------------------------------
;;;	mapgotoiflevel	1,step1_0	;EASY_ground
	mapgotoiflevel	3,step1_2	;NOMAL_ground
	mapgotoiflevel	5,step1_4	;HARD_ground
;;;	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;step1_0
;base
	pathobj		0,1500,0,2000,chika_k0,e_switch_base,2,32
;switch
	m_inertpath	0000,000,3200,1,on_d,e_sw_base_switch
	pathobj		0,000,000,3200,nullshape,e_sw_marker,1,10
	m_inertpath	0000,-120,3200,0,arrow_0,e_sw_arrow
;rock_switch
	m_inertpath	-3000,0000,-2800,deg90,m_iwa_1,e_for_m_iwa
	m_inertpath	-3000,-160,-2800,2,on_d,e_sw_base_switch
	pathobj		0,-3000,-160,-2800,nullshape,e_sw_marker,2,10
	m_inertpath	-3000,-200,-2800,0,arrow_0,e_sw_arrow
;kinoko
	m_inertpath	00000,0,03400,4,kinoko_d,e_kinoko
;cyou
	m_inertpath	1500,-300,-200,100,batabata,e_wakidashi_cyou
	m_inertpath	-1000,-250,2000,100,batabata,e_wakidashi_cyou
	m_inertpath	-2800,-250,-1500,100,batabata,e_wakidashi_cyou
;sasori
	m_inertpath	1200,000,000,64,sasori_0,e_wakidashi_sasori
;rocks
	m_inertpath	3400,0000,2800,0,m_iwa_2,e_for_m_iwa
	m_inertpath	-3400,0000,2000,-deg45,m_iwa_6,e_for_m_iwa
 	m_inertpath	1000,0000,-2800,0,m_iwa_0,e_for_m_iwa
;missile
	m_inertpath	03400,-490,-3000,$30,dandou_tate,e_ground_dandou_a
	m_inertpath	03400,0,-3000,deg90,miss_dai,e_miss_dai_live
;twin_item
	m_inertpath	00000,0000,-3500,1,itembox0,e_panel_twinblaster
;shield_item
	m_inertpath	-3000,0,3000,2,itembox0,e_panel_shieldplayer
;kaifuku _panel
	m_inertpath	0000,0000,-1800,0,kaifuku,e_kaifuku_panel
	m_inertpath	0000,-120,-1800,0,arrow_0,e_sw_arrow
;medal_kinoko_$10
	m_inertpath	02000,$10,0400,6,kinoko_d,e_kinoko
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step1_2
;base
	pathobj		0,-3000,0,2300,chika_k0,e_switch_base,3,128+32
;guruguru_switch
	m_inertpath	2800,000,2800,1,on_d,e_sw_base_switch
	pathobj		0,2800,000,2800,nullshape,e_sw_marker,1,10
	m_inertpath	03200,0000,03200,0,guru2bar,e_guru2_bar
;ike_switch
	m_inertpath	0000,000,0000,2,on_d,e_sw_base_switch
	pathobj		0,000,000,0000,nullshape,e_sw_marker,2,10
	m_inertpath	00000,0000,0000,0,ike_1_0,e_ike_0
;missile_switch
	m_inertpath	-3000,-88,-3000,3,on_d,e_sw_base_switch
	pathobj		0,-3000,-88,-3000,nullshape,e_sw_marker,3,10
	m_inertpath	-3000,-490-20,-3000,0,dandou_tate,e_ground_dandou_a
	m_inertpath	-3000,0,-3000,-deg90,miss_dai,e_miss_dai_live
;hana_hou
	m_inertpath	-1000,-160,-2000,0,hana_hou,e_hana_hou
	m_inertpath	3500,-160,0000,0,hana_hou,e_hana_hou
	m_inertpath	3200,-160,-3000,0,hana_hou,e_hana_hou
;kaifuku _panel
	m_inertpath	0000,0000,3500,0,kaifuku,e_kaifuku_panel
;p-hat
	m_inertpath	2000,-250,-200,100,zaco_2,e_wakidashi_helico
	m_inertpath	-3000,-250,-2800,-100,zaco_2,e_wakidashi_helico
;sasori
	m_inertpath	-2200,000,2000,127,sasori_0,e_wakidashi_sasori
;cyou
	m_inertpath	500,-300,1500,127,batabata,e_wakidashi_cyou
;flower_twin_item
	m_inertpath	0000,00,02800,1,flower_0,e_flower_twin
;;dummy_item
;	m_inertpath	3400,0000,-3000,2,itembox0,e_panel_dummyplayer
;smart_item
	m_inertpath	3400,0000,-3000,2,itembox0,e_panel_smartplasma
;medal_kinoko_$20
	m_inertpath	0800,$20,-800,4,kinoko_d,e_kinoko
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step1_4
;base
	pathobj		0,0000,0,0000,chika_k0,e_switch_base,1,-64
;kamakiri
	pathobj		0,2000,-250,0000,kusha_1,e_new_kamakiri,1,10
;rocks
	m_inertpath	-3500,0000,-2000,-deg90,m_iwa_0,e_for_m_iwa
	m_inertpath	-500,0000,-3500,deg90,m_iwa_0,e_for_m_iwa
	m_inertpath	500,0000,-3000,-deg90,m_iwa_0,e_for_m_iwa
	m_inertpath	3400,0000,1500,0,m_iwa_2,e_for_m_iwa
	m_inertpath	-2800,0000,2800,deg45,m_iwa_6,e_for_m_iwa
;missile
	m_inertpath	3200,-490,-3200,0,dandou_tate,e_ground_dandou_a
	m_inertpath	3200,0,-3200,deg90,miss_dai,e_miss_dai_live
;kinoko
	m_inertpath	03000,0,03000,1,kinoko_d,e_kinoko
	m_inertpath	-3000,0,03000,2,kinoko_d,e_kinoko
	m_inertpath	-3000,0,-3000,3,kinoko_d,e_kinoko
	m_inertpath	-200,0,-2800,4,kinoko_d,e_kinoko
;kaifuku _panel
	m_inertpath	-3300,0000,-3300,0,kaifuku,e_kaifuku_panel
;shield_item
	m_inertpath	3200,0,3200,1,itembox0,e_panel_shieldplayer
;twin_item
	m_inertpath	-3200,0,3200,2,itembox0,e_panel_twinblaster
;medal_kinoko_$30
	m_inertpath	-3400,$30,-400,6,kinoko_d,e_kinoko
	map_endarea
;-------------------------------------------------------------
;***** SPECIAL MODE *****
;-------------------------------------------------------------
training_mode
;tate_way
	m_inertpath	00000,0000,-800,0,way_0,e_nocol_s_off
	m_inertpath	00000,0000,-2400,0,way_0,e_nocol_s_off
;hodoukyou
	m_inertpath	0000,-158,-900,0,hasi0_1,e_building
	m_inertpath	0550,0000,-900,0,hasi0_2,e_buil_shadow_off
	m_inertpath	-550,0000,-900,0,hasi0_0,e_buil_shadow_off
;house
	m_inertpath	-650,0000,1000,deg180,house_2,e_buil_shadow_off
	m_inertpath	-750,0000,-3000,-deg90,house_0,e_buil_shadow_off
	m_inertpath	0750,0000,-3000,deg90,house_1,e_buil_shadow_off
;;yashi
;	m_inertpath	-1200,0000,-300,0,yashi_0,e_buil_shadow_off
;	m_inertpath	-1200,0000,-1200,0,yashi_0,e_buil_shadow_off
;	m_inertpath	01200,0000,-300,0,yashi_0,e_buil_shadow_off
;	m_inertpath	01200,0000,-1200,0,yashi_0,e_buil_shadow_off
;kao_man
	m_inertpath	1500,0000,1000,deg180,kao_man,e_buil_shadow_off
;uso_enemy
	m_inertpath	-1200,-40,1200,-64,amenbo,e_uso_enemy2
	m_inertpath	3000,000,-3000,64,sasori_0,e_uso_enemy2
	m_inertpath	3000,-200,-2000,64,batabata,e_uso_enemy2
	m_inertpath	3000,-80,-1000,64,sagyou_r,e_uso_enemy2
	m_inertpath	3000,-250,0000,64,ka_0,e_uso_enemy2
	m_inertpath	3000,-110,1000,64,mizukara,e_uso_enemy2
	m_inertpath	3000,-150,2000,64,zaco_2,e_uso_enemy2
	m_inertpath	3000,-60,3000,96,taihou_0,e_uso_enemy2
	m_inertpath	-3000,-250,-3000,-64,kusha_1,e_uso_enemy2
	m_inertpath	-3000,-200,-2000,-deg90,hae_0,e_uso_enemy2
	m_inertpath	-3000,-50,-1000,-deg90,kumo_0,e_uso_enemy2
	m_inertpath	-3000,-200,0000,-64,k_tori_0,e_uso_enemy2
	m_inertpath	-3000,-75,1000,-64,tekuteku_s,e_uso_enemy2
	m_inertpath	-3000,-200,2000,-64,boyon,e_uso_enemy2
	m_inertpath	-3000,-60,3000,-96,yoi_hou,e_uso_enemy2
;kaifuku _panel
	m_inertpath	0000,0000,2800,0,kaifuku,e_kaifuku_panel
;twin_item
	m_inertpath	-1000,0000,2800,1,itembox0,e_panel_twinblaster
;heart_item
	m_inertpath	-2000,0000,2800,2,itembox0,e_panel_flamethrower
;shield_item
	m_inertpath	1000,0000,2800,3,itembox0,e_panel_shieldplayer
;smart_item
	m_inertpath	2000,0000,2800,4,itembox0,e_panel_smartplasma
;homing _panel
	pathobj		0,-700,-400,1000,homing,e_hom_item,10,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
;-------------------------------------------------------------
;*********************
;***** ROOM MODE *****
;*********************
stg1room

	map_vscreensize_mission	6

	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick

stg1room_cnt

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
;radar
;	setvar	kx_radarscale,-1
;;players_position
	map_playermode		room

	map_setplayerpos	1,0000,-120-20,0010,0
	map_battlearea		-300,0,0,ground
	map_camerainit_1screen	-080,100,16,-16,55H
	map_arwinginit		-300,-12,15,-15
;tunnel_mode
	map_playertunnel
	map_tutudepth

	map_playerblockmap_on	1	;block map on
;-----------------------
;dots_set
	map_setdust	coloured
	map_dustkazu	8

;-------------------------------------------------------------
;;shinnyuu_demo

	map_demomode		start_chika
	map_demomode_clear	clear_chika
;-----------------------
;;walker_start
;	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;planet_message
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10

;-----------------------------------------
;**** MAP STEPSET AREA (room)****
;-------------------------------------------------------------
;;;	mapgotoiflevel	2,step1_1	;EASY_room
	mapgotoiflevel	4,step1_3	;NOMAL_room
	mapgotoiflevel	6,step1_5	;HARD_room
;;;	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
;;;step1_1
;1_way_door_final
	m_inertpath	00,1,6*1024-140,deg180,kaku_to,e_final_1way_door
;tsuuro_final
	m_inertpath	0000,1,5*1024+512,0,kabe_to,e_buil_shadow_off_g
;1_way_door
	m_inertpath	00,2,3*1024-140,deg180,kabe_ak1,e_1way_door
;tsuuro
	m_inertpath	0000,2,2*1024+512,0,kabe_to,e_buil_shadow_off_g
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,-1024,0000,2*1024,3*1024,stg11_area0,on
	map_area 1,-1024,2*1024,2*1024,4*1024,stg11_area1,on
	map_area 2,-1024,5*1024,2*1024,3*1024,stg11_area2,on
	map_area 3,-1024,2*1024,512,1024,0,off,inactive
	map_area 4,-1024,5*1024,512,1024,0,off,inactive
	map_area 5,00512,2*1024,512,1024,0,off,inactive
	map_area 6,00512,5*1024,512,1024,0,off,inactive

	map_endarea
;-----------------------------------------
stg11_area0
;kabe
	m_inertpath	-1024-512,0000,1024,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	1024+512,0000,1024,deg90,kabe_0,e_nocol_s_off
;kado
	m_inertpath	-1024-512,0000,-512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,-512,0,kado_3,e_nocol_s_off
	m_inertpath	-1024-512,0000,2*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,2*1024+512,deg90,kado_3,e_nocol_s_off
;entrance
	m_inertpath	0000,0000,-512,0,kabe_to3,e_nocol_s_off
;switch_door
	m_inertpath	0000,1,2*1024+140,0,kabe_aku,e_switch_op_door
	m_inertpath	0512+256,-64,1024+256,1,on_d,e_fumu_switch_door_map_aku
;hako
	m_inertpath	0512+256,0000,1024+256,0,t_hako_0,e_hako_0
	m_inertpath	-512-256,0000,1024+256,0,t_hako_0,e_hako_0
;saka
	m_inertpath	0512+256,000,512+256-32,deg180,t_saka_0,e_hako_0
	m_inertpath	-512-256,000,512+256-32,deg180,t_saka_0,e_hako_0
;tai_hou
	m_inertpath	-512-256,-60-64,1024+256,0000,taihou_0,e_laser_hou_final
;;;;switch_door
;;;	m_inertpath	0000,1,2*1024+140,0,kabe_aku,e_switch_op_door
;;;	m_inertpath	0000,0,1024,1,on_d,e_fumu_switch_door_map_aku
;;;;saka
;;;	m_inertpath	-512-32,000,1024,deg90,t_saka_0,e_hako_2
;;;	m_inertpath	512+32,000,1024,-deg90,t_saka_0,e_hako_2
;;;;damage_pillar
;;;	m_inertpath	0000,-100,1024-210,$01,da_ha_yo,e_damage_bou
;;;	m_inertpath	0000,-100,1024+210,$01,da_ha_yo,e_damage_bou
	map_endarea
;-----------------------------------------
stg11_area1
;kabe
	m_inertpath	-1024-512,0000,4*1024,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	1024+512,0000,4*1024,deg90,kabe_0,e_nocol_s_off
;kado
	m_inertpath	-1024-512,0000,3*1024-512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,3*1024-512,0,kado_3,e_nocol_s_off
	m_inertpath	-1024-512,0000,5*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,5*1024+512,deg90,kado_3,e_nocol_s_off
;kabe_hou
	m_inertpath	-1024-32,-150,4*1024,-deg90,tsu_hou_t,e_kabe_hou
	m_inertpath	1024+32,-150,4*1024,deg90,tsu_hou_t,e_kabe_hou
;pillar
	m_inertpath	-512,000,3500,0,t_hako_1,e_hako_3
	m_inertpath	0512,000,3500,0,t_hako_1,e_hako_3
;door_hou
	m_inertpath	0000,2,5*1024+140,deg180,kabe_aku,e_door_hou_door_final
	map_endarea
;-----------------------------------------
stg11_area2
;b_kabe
	m_inertpath	-1024-512,0000,7*1024-256,-deg90,b_kabe_3,e_nocol_s_off
	m_inertpath	1024+512,0000,7*1024-256,deg90,b_kabe_3,e_nocol_s_off
;b_kado
	m_inertpath	-1024-512,0000,6*1024-512,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,6*1024-512,0,b_kado_3,e_nocol_s_off
	m_inertpath	-1024-512,0000,8*1024+512,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,8*1024+512,deg90,b_kado_2,e_nocol_s_off
;core
	m_inertpath	00000,00,7*1024,0,kaku_0_0,e_base_core
;medal_$11
	m_inertpath	00000,-80,8*1024-256,$11,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step1_3
;1_way_door_final
	m_inertpath	2*1024-140,1,6*1024,deg90,kaku_to,e_final_1way_door
;final_tsuuro
	m_inertpath	1024+512,1,6*1024,-deg90,kabe_to,e_buil_shadow_off_g
;tsuuro
	m_inertpath	0000,0000,4*1024+512,0,kabe_to,e_buil_shadow_off_g
	m_inertpath	-1024-512,0000,6*1024,deg90,kabe_to,e_buil_shadow_off_g
;switch_door
	m_inertpath	0000,1,4*1024+140,deg180,kabe_aku,e_door_hou_door
;-------------------------------------------------------------
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,-1024,0000,2*1024,5*1024,stg13_area0,on
	map_area 1,-2*1024,4*1024,4*1024,3*1024,stg13_area1,on
	map_area 2,1024,5*1024,3*1024,2*1024,stg13_area2,on
	map_area 3,-4*1024,5*1024,3*1024,2*1024,stg13_area3,on
	map_area 4,-1024,4*1024,512,1024,0,off,inactive
	map_area 5,512,4*1024,512,1024,0,off,inactive
	map_area 6,-2*1024,4*1024,1024,1024+512,0,off,inactive
	map_area 7,1024,4*1024,1024,1024+512,0,off,inactive
	map_area 8,-2*1024,6*1024+512,1024,512,0,off,inactive
	map_area 9,1024,6*1024+512,1024,512,0,off,inactive
	map_endarea
;-----------------------------------------
stg13_area0
;kado
	m_inertpath	-1024-512,0000,-512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,-512,0,kado_3,e_nocol_s_off
	m_inertpath	-1024-512,0000,4*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,4*1024+512,deg90,kado_3,e_nocol_s_off
;kabe
	m_inertpath	-1024-512,0000,1024+256,-deg90,kabe_1,e_nocol_s_off
	m_inertpath	1024+512,0000,1024+256,deg90,kabe_1,e_nocol_s_off
	m_inertpath	-1024-512,0000,3*1024-256,-deg90,kabe_1,e_nocol_s_off
	m_inertpath	1024+512,0000,3*1024-256,deg90,kabe_1,e_nocol_s_off
;entrance
	m_inertpath	0000,0000,-512,0,kabe_to3,e_nocol_s_off
;pool
	m_inertpath	0000,00,1024+256,0,pools_0,e_ike_0
	m_inertpath	0000,00,3*1024-256,0,pools_0,e_ike_0
;guruguru_trap
	m_inertpath	0000,-100,2*1024,8,toge_0,e_guruguru_bar
;hashira_houdai
	m_inertpath	0000,000,2*1024,0,ha_hou_0,e_hako_hou
;tobidashi_tekuteku
	m_inertpath	-400,-75,2*1024+200,128,tekuteku_s,e_tunnel_tobidashi_m
	m_inertpath	1024-400,-75,1024,deg90,tekuteku_s,e_tunnel_tobidashi_p
	map_endarea
;-----------------------------------------
stg13_area1
;final_door
	m_inertpath	1024+140,1,6*1024,-deg90,kabe_aku,e_final_door
;yuka_mukade
	pathobj		0,0000,00,6*1024,yuka_hou,e_yuka_hou_final,1,10
;kado
	m_inertpath	-1024-512,0000,4*1024+512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,4*1024+512,0,kado_3,e_nocol_s_off
	m_inertpath	-1024-512,0000,7*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,7*1024+512,deg90,kado_3,e_nocol_s_off
;kabe
	m_inertpath	0000,0000,7*1024+512,deg180,kabe_0,e_nocol_s_off
;pool
	m_inertpath	0000,00,6*1024,0,pools_0,e_ike_0
	map_endarea
;-----------------------------------------
stg13_area2
;b_kado
	m_inertpath	1024+512,0000,4*1024+512,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	4*1024+512,0000,4*1024+512,0,b_kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,7*1024+512,deg180,b_kado_3,e_nocol_s_off
	m_inertpath	4*1024+512,0000,7*1024+512,deg90,b_kado_2,e_nocol_s_off
;b_kabe
	m_inertpath	3*1024-256,0000,4*1024+512,0,b_kabe_3,e_nocol_s_off
	m_inertpath	3*1024-256,0000,7*1024+512,deg180,b_kabe_3,e_nocol_s_off
;core
	m_inertpath	3*1024,00,6*1024,0,kaku_0_0,e_base_core
	map_endarea
;-----------------------------------------
stg13_area3
;kado
	m_inertpath	-4*1024-512,0000,4*1024+512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	-1024-512,0000,4*1024+512,0,kado_3,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,7*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	-1024-512,0000,7*1024+512,deg90,kado_3,e_nocol_s_off
;kabe
	m_inertpath	-3*1024+256,0000,4*1024+512,0,kabe_3,e_nocol_s_off
	m_inertpath	-3*1024+256,0000,7*1024+512,deg180,kabe_3,e_nocol_s_off
;pool
	m_inertpath	-3*1024,00,6*1024,0,pools_0,e_ike_0
;tojikome_kabe_mukade_$44
	m_inertpath	-2*1024+140,1,6*1024,$c1,kabe_ak1,e_tojikome_door
	pathobj		0,-3*1024,-150,6*1024,room_hou,e_kabe_mukade_tojikome,2,0
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step1_5
;1_way_door_final
	m_inertpath	2*1024-140,1,8*1024-256,deg90,kaku_to,e_final_1way_door
;tsuuro
	m_inertpath	1024+512,0000,1024,-deg90,kabe_to,e_buil_shadow_off
	m_inertpath	-1024-512,0000,1024,deg90,kabe_to,e_buil_shadow_off
	m_inertpath	-4*1024+256,0000,2*1024+512,0,kabe_to2,e_buil_shadow_off_g
;final_tsuuro
	m_inertpath	1024+512,1,8*1024-256,deg90,kabe_to2,e_buil_shadow_off_g
;switch_door
	m_inertpath	-1024-140,1,1024,deg90,kabe_aku,e_switch_op_door
	m_inertpath	000,000,1800,1,on_d,e_fumu_switch_door_map_aku

	m_inertpath	-4*1024+256,2,2*1024+140,0,kabe_aku,e_switch_op_door
	m_inertpath	-3*1024-512,00,512,2,on_d,e_fumu_switch_door_map_aku
;final_door
	m_inertpath	1024+140,3,8*1024-256,-deg90,kabe_aku,e_final_door
;tousenbo
	m_inertpath	-2*1024,0,8*1024-256,-deg90,kakureto,e_tousenbo
	m_inertpath	-1024,0,8*1024-256,-deg90,kakureto,e_tousenbo
	m_inertpath	0000,0,8*1024-256,-deg90,kakureto,e_tousenbo
;tobidashi_tekuteku
	m_inertpath	-4*1024+100,-75,7*1024+400,128,tekuteku_s,e_tunnel_tobidashi_p
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,-2*1024,0000,4*1024,2*1024,stg15_area0,on
	map_area 1,1024,0000,3*1024,2*1024,stg15_area1,on
	map_area 2,-4*1024,0000,3*1024,3*1024,stg15_area2,on
	map_area 3,-4*1024,2*1024,6*1024,6*1024,stg15_area3,on
	map_area 4,1024,6*1024,3*1024,2*1024,stg15_area4,on
	map_area 5,1024,0000,1024,512,0,off,inactive
	map_area 6,1024,1024+512,1024,512,0,off,inactive
	map_area 7,-2*1024,0000,1024,512,0,off,inactive
	map_area 8,-2*1024,1024+512,1024,512,0,off,inactive
	map_area 9,-3*1024-512,2*1024,5*1024+512,5*1024,0,off,inactive
	map_area 10,-3*1024,7*1024,5*1024,512,0,off,inactive
	map_endarea
;-----------------------------------------
stg15_area0
;kado
	m_inertpath	-1024-512,0000,-512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,-512,0,kado_3,e_nocol_s_off
	m_inertpath	-1024-512,0000,2*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,2*1024+512,deg90,kado_3,e_nocol_s_off
;kabe
	m_inertpath	0000,0000,2*1024+512,deg180,kabe_0,e_nocol_s_off
;entrance
	m_inertpath	0000,0000,-512,0,kabe_to3,e_nocol_s_off
;hako
	m_inertpath	0000,000,2*1024-256-512-32,deg180,t_saka_0,e_hako_2
	m_inertpath	0000,-192+64,2*1024-256,0,t_hako_lift,e_building
;hashira_houdai
	m_inertpath	-500,000,1300,0,ha_hou_0,e_hako_hou
	m_inertpath	500,000,1300,0,ha_hou_0,e_hako_hou
	map_endarea
;-----------------------------------------
stg15_area1
;kado
	m_inertpath	4*1024+512,0000,-512,0,kado_2,e_nocol_s_off
	m_inertpath	4*1024+512,0000,2*1024+512,deg90,kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,2*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,-512,-deg90,kado_3,e_nocol_s_off
;kabe
	m_inertpath	3*1024-256,0000,-512,0,kabe_3,e_nocol_s_off
	m_inertpath	3*1024-256,0000,2*1024+512,deg180,kabe_3,e_nocol_s_off
;pool
	m_inertpath	3*1024,00,1024,0,pools_0,e_ike_0
;trap
	m_inertpath	2*1024+256,-80,1024+200,2,toge_0,e_room_toge
	m_inertpath	4*1024-256,-80,1024-200,2,toge_0,e_room_toge
	m_inertpath	3*1024-256,-120,256,1,toge_0,e_room_toge
	m_inertpath	3*1024+256,-120,2*1024-200,1,toge_0,e_room_toge
;tojikome_door
	m_inertpath	2*1024-140,1,1024,$40,kabe_ak1,e_tojikome_door
;tojikome_kabe_mukade_medal_$47
	pathobj		0,3*1024,-150,1024,room_hou,e_kabe_mukade_tojikome,1,3
	map_endarea
;-----------------------------------------
stg15_area2
;kado
	m_inertpath	-1024-512,0000,-512,0,kado_3,e_nocol_s_off
	m_inertpath	-1024-512,0000,2*1024+512,deg90,kado_3,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,-512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,2*1024+512,deg180,kado_4,e_nocol_s_off
;kabe
	m_inertpath	-3*1024+256,0000,-512,0,kabe_3,e_nocol_s_off
	m_inertpath	-3*1024,0000,2*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,1024+512,-deg90,kabe_0,e_nocol_s_off
;guruguru_trap
	m_inertpath	-3*1024,000,1024,0,t_hako_1,e_hako_3
	m_inertpath	-3*1024,-40,1024,4,toge_0,e_guruguru_bar
;tobidashi_tekuteku
	m_inertpath	-3*1024,-75,1024+200,128,tekuteku_s,e_tunnel_tobidashi_m
	map_endarea
;-----------------------------------------
stg15_area3
;kado
	m_inertpath	-3*1024,0000,7*1024,deg90,kado_1,e_buil_shadow_off
	m_inertpath	-4*1024-512,0000,8*1024+512,deg180,kado_2,e_nocol_s_off
;kabe
	m_inertpath	-4*1024-512,0000,4*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-3*1024,0000,4*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	-4*1024-512,0000,6*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-3*1024,0000,6*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	-2*1024,0000,7*1024,0,kabe_2,e_nocol_s_off
	m_inertpath	-2*1024,0000,8*1024+512,deg180,kabe_2,e_nocol_s_off
	m_inertpath	0000,0000,7*1024,0,kabe_2,e_nocol_s_off
	m_inertpath	0000,0000,8*1024+512,deg180,kabe_2,e_nocol_s_off
;kabesaka
	m_inertpath	-4*1024+128-32,00,4*1024,deg180,t_saka_2,e_hako_0
	m_inertpath	-3*1024-512-128+32,00,6*1024,deg180,t_saka_1,e_hako_0
	m_inertpath	-4*1024+128-32,00,7*1024,deg180,t_saka_2,e_hako_0
;;pillar
;	m_inertpath	-4*1024+256,-160,5*1024,$03,da_ha_ta,e_damage_bou
;hit_not_stop_rot_door
	m_inertpath	-4*1024+256,0000,5*1024,8,t_to_3,e_hit_dont_stop_door
	map_endarea
;-----------------------------------------
stg15_area4
;kado
	m_inertpath	1024+512,0000,5*1024+512,-deg90,b_kado_2,e_nocol_s_off
	m_inertpath	4*1024+512,0000,5*1024+512,0,b_kado_2,e_nocol_s_off
	m_inertpath	4*1024+512,0000,8*1024+512,deg90,b_kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,8*1024+512,deg180,b_kado_4,e_nocol_s_off
;b_kabe
	m_inertpath	1024+512,0000,7*1024+256,-deg90,b_kabe_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,8*1024+512,deg180,b_kabe_0,e_nocol_s_off
;core
	m_inertpath	3*1024,00,7*1024,0,kaku_0_0,e_base_core
	map_endarea
;-----------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp
