;ษออออออออออออออออออออออออออออออออออออออออออป
;บ STAGE 3 MAKUBES ground_room	       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;-----------------------------------------
;-----------------------------------------
;-----clear bg set-------------
	setstgclrbg	missionstage3
;-----ground or room check-----
	mapgotoifplanet	stg3room
;-----ground start inicial-------
	setbg	missionstage3
	initbg
;-----room start inicial-------
	map_demomode	off
	map_nextmap	stg3room_cnt,enter_chika	;room mode
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
;player
	map_setplayerpos	1,0000,-800,-3*1024,00
	map_playermode		ground
	map_battlearea		-1000,0,-14,magma
	map_camerainit_1screen	-400,100,16,-16,70H
	map_arwinginit		-1000,-12,15,-15
;-----------------------
;dots_set
	map_setdust	sprites,coloured	;random		
	map_dustsprite	maguma,32		;maguma
	map_dustkazu	16
;area_out_check
	map_playerblockmap_off	1	;area out off
;planet_message
	pathobj 	0,5*1024,0000,5*1024,stg_checker,e_game_maker_planet,10,10
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10
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
;;;;;	mapgotoiflevel	3,step3_2	;NOMAL_ground
	mapgotoiflevel	5,step3_4	;HARD_ground
;;;;;	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;;;;;step3_2
;base
	pathobj		0,2800,0,2500,chika_k0,e_switch_base,2,128
;building_switch
	m_inertpath	1500,-512,1500,1,on_d,e_sw_base_switch
	pathobj		0,1500,-512,1500,nullshape,e_sw_marker,1,10
	m_inertpath	1500,0,1500,0,hako_dai,e_buil_shadow_off
;center_tou_switch
	m_inertpath	-3000,0000,-3200,2,you_0_0,e_yousai_laser
	pathobj		0,-3000,-40,-3200,nullshape,e_sw_marker,2,10
;building
	m_inertpath	-2000,0,2000,0,nobiru,e_hako_2
	m_inertpath	-3000,0,1500,0,nobiru,e_hako_2
;ka_0
;;;	m_inertpath	2500,-600,2000,100,ka_0,e_wakidashi_ka
	m_inertpath	-500,-700,-1000,-100,ka_0,e_wakidashi_ka
;michi_low
	m_inertpath	-400,00000,-1000-1590,0,michi_4,e_buil_shadow_off
	m_inertpath	-400,00000,-1000,0,michi_1,e_building
	m_inertpath	-400,0000,-1000+1590,deg180,michi_4,e_buil_shadow_off
;michi_high
	m_inertpath	-1024-1088,00000,-800+216,-deg90,michi_2,e_buil_shadow_off
	m_inertpath	-512,-0208,-800+216,deg90,michi_0,e_building
	m_inertpath	512+126,-208,-800,0,michi_5,e_building
	m_inertpath	512+342,00000,-1950,0,michi_2,e_buil_shadow_off
	m_inertpath	88,00016,-800+216,deg90,michi_7,e_buil_shadow_off
;dai
	m_inertpath	-1200,0000,03100,0,hiyasu_0,e_buil_shadow_off
	m_inertpath	-3000,0000,3000,0,hiyasu_0small,e_buil_shadow_off
;taihou
	m_inertpath	-1200,-60-40,2600,0,yoi_hou,e_ring_hou
;shield_item
	m_inertpath	-3000,-30,3000,1,itembox0,e_panel_shieldplayer
;twin_item
	m_inertpath	500,-150,-900,2,item_ita,e_item_twinblaster
;kaifuku
	m_inertpath	-1200,-40,3100,0,kaifuku,e_kaifuku_panel
;missile_medal_$24
	m_inertpath	03300,-490,-3000,$24,dandou_tate,e_ground_dandou_medal
	m_inertpath	03300,0,-3000,deg90,miss_dai,e_miss_dai_live
;;;;medal_$24
;;;	m_inertpath	-400,-150,-600,$24,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step3_4
;fire_tree
	pathobj		0,0000,0000,0000,nullshape,flameburst,2,2
;base
	pathobj		0,0000,0,0000,chika_k0,e_switch_base,1,0
;rapyuta
	pathobj		0,-1000,-300,1000,rapyuta,e_sw_base_rapyuta,1,10
;michi
	m_inertpath	1150+1800+215,0,1800,0,michi_4,e_buil_shadow_off
	m_inertpath	1150+1800,0,1150+1800,0,michi_6,e_building
	m_inertpath	1800,0,1150+1800+215,-deg90,michi_4,e_buil_shadow_off

	m_inertpath	-1150-1800-215,0,-1800,deg180,michi_4,e_buil_shadow_off
	m_inertpath	-1150-1800,0,-1150-1800,deg180,michi_6,e_building
	m_inertpath	-1800,0,-1150-1800-215,deg90,michi_4,e_buil_shadow_off
;ita
	m_inertpath	03000,0,-3000,0,hiyasu_0small,e_buil_shadow_off
	m_inertpath	-3000,0,03000,0,hiyasu_0small,e_buil_shadow_off
	m_inertpath	02000,0,-2000,0,hiyasu_0small,e_buil_shadow_off
	m_inertpath	-2000,0,02000,0,hiyasu_0small,e_buil_shadow_off
	m_inertpath	01000,0,-1000,0,hiyasu_0small,e_buil_shadow_off
	m_inertpath	-1000,0,01000,0,hiyasu_0small,e_buil_shadow_off
;ka_0
	m_inertpath	1024,-800,1500,100,ka_0,e_wakidashi_ka
	m_inertpath	-500,-700,-1000,-100,ka_0,e_wakidashi_ka
;tai_hou
	m_inertpath	-2000,-60-30,2000,0,taihou_0,e_laser_hou
	m_inertpath	2000,-60-30,-2000,0,taihou_0,e_laser_hou
;heart_item
	m_inertpath	03000,-30,-3000,1,itembox0,e_panel_flamethrower
;smart_item
	m_inertpath	-2900,-180,-2900,2,item_ita,e_item_smartplasma
;kaifuku
	m_inertpath	-3000,-30,03000,0,kaifuku,e_kaifuku_panel
;medal_$34
	m_inertpath	2900,-180,2900,$34,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
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
stg3room

	map_vscreensize_mission	6

;	m_range	8192
	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick

stg3room_cnt

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

	map_setplayerpos	1,0000,-120-20,0020,0
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
	m_inertpath	00,1,5*1024-140,deg180,kaku_to,e_final_1way_door
;tsuuro_final
	pathobj		0,0000,1,4*1024+512,kabe_to,e_buil_range_off,10,10
;;;	m_inertpath	0000,1,4*1024+512,0,kabe_to,e_buil_shadow_off_g
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,-2*1024,0000,4*1024,5*1024,stg3_area0,on
	map_area 1,-1024,4*1024,2*1024,3*1024,stg3_area1,on
	map_area 2,-2*1024,4*1024,1024+512,1024,0,off,inactive
	map_area 3,512,4*1024,1024+512,1024,0,off,inactive
	map_endarea
;-----------------------------------------
stg3_area0
;final_door
	pathobj		0,0000,1,4*1024+140,kabe_aku,e_final_door,10,10
;entrance
	m_inertpath	0000,0000,-512,0,kabe_to3,e_nocol_s_off
;kabe
	m_inertpath	1024-256,0000,-512,0,kabe_3,e_nocol_s_off
	m_inertpath	-1024+256,0000,-512,0,kabe_3,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,2*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,2*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024-256,0000,4*1024+512,deg180,kabe_3,e_nocol_s_off
	m_inertpath	-1024+256,0000,4*1024+512,deg180,kabe_3,e_nocol_s_off
;level_check
	mapgotoiflevel	4,stg33_area0	;NOMAL_room
	mapgotoiflevel	6,stg35_area0	;HARD_room
	map_endarea
;-------------------------------------------------------------
stg33_area0	;NORMAL
;stg33area_inactive
	map_area 4,-2*1024,0000,512,512,0,off,inactive
	map_area 5,1024+512,0000,512,512,0,off,inactive
	map_area 6,-2*1024,3*1024+512,512,512,0,off,inactive
	map_area 7,1024+512,3*1024+512,512,512,0,off,inactive
;tekuteku
	pathobj		0,1024+512,-150,2*1024+512,tekuteku,e_shield_robo_final,1,2
;kado
	m_inertpath	-1024-512,0000,512,0,kado_0,e_buil_shadow_off
	m_inertpath	1024+512,0000,512,deg90,kado_0,e_buil_shadow_off
	m_inertpath	-1024-512,0000,3*1024+512,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	1024+512,0000,3*1024+512,deg180,kado_0,e_buil_shadow_off
;
	m_inertpath	-1024-512,0000,-512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	1024+512,0000,-512,0,kado_4,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	2*1024+512,0000,512,0,kado_4,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,3*1024+512,deg180,kado_4,e_nocol_s_off
	m_inertpath	2*1024+512,0000,3*1024+512,deg90,kado_4,e_nocol_s_off
	m_inertpath	-1024-512,0000,4*1024+512,deg180,kado_4,e_nocol_s_off
	m_inertpath	1024+512,0000,4*1024+512,deg90,kado_4,e_nocol_s_off
;hako
	m_inertpath	0000,00,1024,0,t_hako_0,e_hako_0
	m_inertpath	-1024,00,2*1024,0,t_hako_1,e_hako_2
	m_inertpath	1024,00,2*1024,0,t_hako_1,e_hako_2
	m_inertpath	0000,00,3*1024,0,t_hako_0,e_hako_0
;damage_piller
	m_inertpath	00000,-160,2*1024,$01,da_ha_ta,e_damage_bou
;area_check
	map_area 8,-256,3*1024-256,512,512,stg33_area2,on
	map_endarea
;----------------------------
stg33_area2
;medal_$25
	m_inertpath	0000,-130,3*1024,$25,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;
;-------------------------------------------------------------
stg35_area0	;HARD
;tekuteku
	pathobj		0,-2*1024+256,-150,3*1024+256,tekuteku,e_shield_robo_2_final,1,1
;kado
	m_inertpath	-2*1024-512,0000,-512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,-512,0,kado_2,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,4*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,4*1024+512,deg90,kado_2,e_nocol_s_off
;pillar
	m_inertpath	-1024+256,0000,512+256,0,t_hako_1,e_hako_2
	m_inertpath	1024-256,0000,1024+256,0,t_hako_1,e_hako_2
	m_inertpath	-256,0000,2*1024+256,0,t_hako_1,e_hako_2
	m_inertpath	2*1024-256+32,0000,3*1024-256,0,t_hako_1,e_hako_4
	m_inertpath	-2*1024+256-32,0000,2*1024-256,0,t_hako_1,e_hako_6
	m_inertpath	-1024-256,0000,4*1024-256+32,0,t_hako_1,e_hako_5
	m_inertpath	256,0000,3*1024+256,0,t_hako_1,e_hako_2
;taihou
	m_inertpath	-1024-256,-60,2*1024-256,0,taihou_0,e_laser_hou
	m_inertpath	1024-256,-60,2*1024,0,taihou_0,e_laser_hou
;;;	m_inertpath	-512,-60,3*1024+256,0,taihou_0,e_laser_hou
;kabe_hou
;;;	m_inertpath	2*1024+32,-150,512,deg90,tsu_hou_t,e_kabe_hou
;;;	m_inertpath	-2*1024-32,-150,3*1024,-deg90,tsu_hou_t,e_kabe_hou
	m_inertpath	1024,-150,4*1024+32,deg180,tsu_hou_t,e_kabe_hou
;kado
	m_inertpath	2*1024,0000,4*1024,deg180,kado_1,e_nocol_s_off
	m_inertpath	2*1024+512,0000,4*1024,deg90,kado_4,e_nocol_s_off
	m_inertpath	2*1024,0000,4*1024+512,deg90,kado_4,e_nocol_s_off
;area_check
	map_area 4,1024+512,3*1024+512,512,512,stg35_area2,on
	map_endarea
;-----------------------------------------
stg35_area2
;medal_$35
	m_inertpath	2*1024-100,-80,4*1024-100,$35,medal,e_omake_medal
;;kaifuku
;	m_inertpath	2*1024-128,0,4*1024-128,0,kaifuku,e_kaifuku_panel
	map_endarea
;-----------------------------------------
;final_core 33,35
;-----------------------------------------
stg3_area1
;b_kabe
	m_inertpath	-1024-512,0000,6*1024-256,-deg90,b_kabe_3,e_nocol_s_off
	m_inertpath	1024+512,0000,6*1024-256,deg90,b_kabe_3,e_nocol_s_off
;b_kado
	m_inertpath	-1024-512,0000,4*1024+512,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,4*1024+512,0,b_kado_3,e_nocol_s_off
	m_inertpath	-1024-512,0000,7*1024+512,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,7*1024+512,deg90,b_kado_2,e_nocol_s_off
;core_kado
	m_inertpath	1024+32,-20<<kaku5_scale,7*1024+32,64,kaku5_3,e_base_core_kado
	m_inertpath	-1024-32,-20<<kaku5_scale,7*1024+32,128,kaku5_3,e_base_core_kado
;level_check
	mapgotoiflevel	6,stg35_area1a	;HARD_room
;core_normal
	pathobj		0,00000,00,6*1024,kaku5_0,e_base_core_2,2,10
	map_endarea
;core_hard
stg35_area1a
;core
	pathobj		0,00000,00,6*1024,kaku5_0,e_base_core_2,4,10
;core_kado
	m_inertpath	1024+32,-20<<kaku5_scale,5*1024-32,0,kaku5_3,e_base_core_kado
	m_inertpath	-1024-32,-20<<kaku5_scale,5*1024-32,-64,kaku5_3,e_base_core_kado
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;-----------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp

