;ษออออออออออออออออออออออออออออออออออออออออออป
;บ STAGE 4 ERADARD ground_room	       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;-----------------------------------------
;-----------------------------------------
;-----clear bg set-------------
	setstgclrbg	missionstage4
;-----ground or room check-----
	mapgotoifplanet	stg4room
;-----ground start inicial-------
	setbg	missionstage4
	initbg
;-----room start inicial-------
	map_demomode	off
	map_nextmap	stg4room_cnt,enter_chika	;room mode
;-----------------------------------------
;*********************
;*****GROUND MODE*****
;*********************
;-----------------------------------------
	map_vscreensize_mission	2

	m_range	8192
 	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick

;-----------------------------------------
;**** MAP SET START ****
;-------------------------------
;ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บmap_arwinginit		high,low,rotXmax,rotYmin                    บ
;บmap_battlearea		high,low,depth,type	(koudokei)          บ
;บmap_camerainit_1screen	midY,Yoffsetmax,rotXmax,rotXmin,Yoffsetrate บ
;บmap_camerainit_2screen	,,,,,	                                    บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
;players_position
	map_playermode		ground
	map_setplayerpos	1,0000,-180,-3*1024,0
	map_battlearea		-600,0,0,ground
	map_camerainit_1screen	-300,1,16,-16,70H
	map_arwinginit		-600,-12,15,-15
;-------------------------------
;dots_set
	map_setdust	coloured,raining		
;;	map_dustsprite	119,16		;maguma
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
;;;;;	mapgotoiflevel	1,step4_0	;EASY_ground
	mapgotoiflevel	3,step4_2	;NOMAL_ground
	mapgotoiflevel	5,step4_4	;HARD_ground
;;;;;	map_endarea
;-------------------------------------------------------------
;;;;;step4_0
;shield_base
	pathobj		0,0000,0,2500,chika_k3,e_shield_base,2,128
;tunnel
	m_inertpath	-0540,0000,-1024,-deg90,yama_0_1,e_buil_shadow_off
	m_inertpath	00000,-310,-1024,0,yama_0_0,e_building
	m_inertpath	00540,0000,-1024,deg90,yama_0_1,e_buil_shadow_off
;way
	m_inertpath	00000,00,-1400,0,way_0,e_nocol_s_off_g
	m_inertpath	00000,00,00200,0,way_0,e_nocol_s_off_g
	m_inertpath	00000,00,01400,0,way_3,e_nocol_s_off_g
	m_inertpath	01200,00,01400,deg90,way_0,e_nocol_s_off_g
	m_inertpath	-1200,00,01400,deg90,way_0,e_nocol_s_off_g
;missile
	m_inertpath	3400,-490,1400,0,dandou_tate,e_ground_dandou_a
	m_inertpath	3400,0000,1400,deg90,miss_dai,e_miss_dai_live
;sagyou
	m_inertpath	0050,-80,-500,80,sagyou_r,e_new_sagyou_r
	m_inertpath	-2300,-80,-2200,-deg45,sagyou_r,e_new_sagyou_r
	m_inertpath	2500,-80,-2450,deg180,sagyou_r,e_new_sagyou_r
;hae
	m_inertpath	400,-300,-2000,0,hae_0,e_wakidashi_hae
	m_inertpath	-2200,-300,-1200,0,hae_0,e_wakidashi_hae
;;sagyou_box
;	m_inertpath	03200,-80,-1500,deg180,sagyou_r,e_sagyou_walk_box
;box
	m_inertpath	2500,-50,-2800,00,box_0,e_kowareru_box
	m_inertpath	3000,000,-3500,00,box_0,e_kowareru_box
	m_inertpath	3600,000,-2200,00,box_0,e_kowareru_box
;build
	m_inertpath	-2000,00,-2000,0,nobiru,e_hako_2
	m_inertpath	-2800,00,-2800,0,nobiru,e_hako_2
;twin_item
	m_inertpath	2500,0,-2800,1,itembox0,e_panel_twinblaster
;;shield_item
;	m_inertpath	2500,0,-2800,1,itembox0,e_panel_shieldplayer
;smart_item
	m_inertpath	-3200,0,1400,2,itembox0,e_panel_smartplasma
;kaifuku
	m_inertpath	-2500,000,-2500,0,kaifuku,e_kaifuku_panel
	m_inertpath	-2500,-120,-2500,0,arrow_0,e_sw_arrow
;hae_box_medal_$42
	m_inertpath	-2800,-300,1800,-64,hae_0,e_hae_fly_box
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step4_2
;base
	pathobj		0,0000,0,0000,chika_k0,e_switch_base,1,128
;dodora_switch
	pathobj		0,-1500,-450,00000,dodora_2,boss_dodora,1,10
;machi
	m_inertpath	3200,0,3200,0,machi_0,e_buil_shadow_off
;build
	m_inertpath	200,00,-2500,0,nobiru,e_hako_2
	m_inertpath	-3600,00,-3600,0,nobiru,e_hako_1
	m_inertpath	-3000,00,3600,0,nobiru,e_hako_2
;missile
	m_inertpath	3400,-490,-3400,0,dandou_tate,e_ground_dandou_a
	m_inertpath	3400,0000,-3400,deg90,miss_dai,e_miss_dai_live
;heart_item
	m_inertpath	-3200,0,-3200,1,itembox0,e_panel_flamethrower
;twin_item
	m_inertpath	-3400,0,3400,2,itembox0,e_panel_twinblaster
;kaifuku
	m_inertpath	3200,000,2500,0,kaifuku,e_kaifuku_panel
;medal_$26
	m_inertpath	3300,-440,3600,$26,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step4_4
;shield_base
	pathobj		0,0000,0,0000,chika_k3,e_shield_base,4,128
;machi
	m_inertpath	0000,0,3200,0,machi_0,e_buil_shadow_off
;way
stg4way4	=		-800
	rept		2
	m_inertpath	stg4way4,00,02000,deg90,way_0,e_nocol_s_off_g
	m_inertpath	stg4way4,00,-2000,deg90,way_0,e_nocol_s_off_g
	m_inertpath	02000,00,stg4way4,0,way_0,e_nocol_s_off_g
	m_inertpath	-2000,00,stg4way4,0,way_0,e_nocol_s_off_g
stg4way4	=	stg4way4+1600
	endr
;way
	m_inertpath	02000,00,02000,0,way_1,e_nocol_s_off_g
	m_inertpath	02000,00,-2000,-deg90,way_1,e_nocol_s_off_g
	m_inertpath	-2000,00,02000,deg90,way_1,e_nocol_s_off_g
	m_inertpath	-2000,00,-2000,deg180,way_1,e_nocol_s_off_g
;missile
	m_inertpath	3200,-490,0000,0,dandou_tate,e_ground_dandou_a
	m_inertpath	3200,0000,0000,deg90,miss_dai,e_miss_dai_live
;taihou_build
	m_inertpath	-3200,0000,03200,0,nobiru,e_hako_2
	m_inertpath	-3200,-240-60,3200,0,taihou_0,e_laser_hou
	m_inertpath	03200,0000,-3200,0,nobiru,e_hako_2
	m_inertpath	03200,-240-60,-3200,0,taihou_0,e_laser_hou
	m_inertpath	-3200,0000,-3200,0,nobiru,e_hako_2
;pool
	m_inertpath	03000,00,3000,0,pools_0,e_buil_shadow_off
;yoi_hou
	m_inertpath	01500,-60,0000,deg90,yoi_hou,e_ring_hou
	m_inertpath	-1500,-60,0000,-deg90,yoi_hou,e_ring_hou
;;;;	m_inertpath	00000,-60,1500,deg180,yoi_hou,e_ring_hou
;hae_0
	m_inertpath	2500,-320,1024,100,hae_0,e_wakidashi_hae
	m_inertpath	-500,-320,-1800,-100,hae_0,e_wakidashi_hae
;;;;	m_inertpath	-2800,-320,0000,-100,hae_0,e_wakidashi_hae
;twin_item
	m_inertpath	-3200,-40-280,-3200,1,item_ita,e_item_twinblaster
;smart_item
	m_inertpath	03000,-40-100,03000,2,item_ita,e_item_smartplasma
;kaifuku
	m_inertpath	-3200,000,0000,0,kaifuku,e_kaifuku_panel
;;;map_area_check
;;	map_area 1,-512,3*1024,512,512,stg44_area1,on
;;	map_endarea
;;;--------------------------------
;;stg44_area1
;hako
	m_inertpath	-850,0000,3400,0,nobiru,e_hako_4
;;;medal_$3,6
	m_inertpath	-180-450,-80,3400,$36,medal,e_omake_medal
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
stg4room

	map_vscreensize_mission	6

;	m_range	8192
	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick

stg4room_cnt

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
;players_position
	map_playermode		room

	map_setplayerpos	1,1024,-120-20,0020,0
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
	mapgotoiflevel	2,step4_1	;EASY_room
	mapgotoiflevel	4,step4_3	;NOMAL_room
	mapgotoiflevel	6,step4_5	;HARD_room
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step4_1
;1_way_door_final
	m_inertpath	4*1024-140,1,4*1024+512,deg90,kaku_to,e_final_1way_door
;tsuuro_final
	m_inertpath	3*1024+512,1,4*1024+512,-deg90,kabe_to,e_buil_shadow_off_g
;1way_door
	m_inertpath	1024+512,2,3*1024-140,deg180,kabe_ak1,e_1way_door
;tsuuro
	m_inertpath	1024+512,2,2*1024+512,0,kabe_to,e_buil_shadow_off_g
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,0000,0000,2*1024,3*1024,stg41_area0,on
	map_area 1,1024,2*1024,3*1024,3*1024,stg41_area1,on
	map_area 2,3*1024,4*1024,3*1024,2*1024,stg41_area2,on
	map_area 3,0000,2*1024,1024,1024,0,off,inactive
	map_area 4,2*1024,2*1024,2*1024,1024,0,off,inactive
	map_area 5,3*1024,3*1024,1024,1024,0,off,inactive
	map_area 6,3*1024,5*1024,1024,1024,0,off,inactive
	map_area 7,3*1024-512,3*1024,512,512,stg41_area3,on
	map_endarea
;-----------------------------------------
stg41_area0
;switch_door
	m_inertpath	1024+512,1,2*1024+140,0,kabe_aku,e_switch_op_door
	m_inertpath	1024,-64,1024,1,on_d,e_fumu_switch_door_map_aku
;entrance
	m_inertpath	1024,0000,-512,0,kabe_to3,e_nocol_s_off
;kabe
	m_inertpath	-512,0000,1024-256,-deg90,kabe_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,1024+256,deg90,kabe_1,e_nocol_s_off
;kado
	m_inertpath	-512,0000,-512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,-512,0,kado_3,e_nocol_s_off
	m_inertpath	-512,0000,2*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,2*1024+512,deg90,kado_4,e_nocol_s_off
;hako
	m_inertpath	1024,0000,1024,0,t_hako_0,e_hako_0
;trap
	m_inertpath	800,-60,512+100,1,toge_0,e_room_toge
;jump_tekuteku
	m_inertpath	1024+256,-74,1024+400,deg180,tekuteku_s,e_tunnel_robo_jump
	m_inertpath	1024-256,-74,1024+400,deg180,tekuteku_s,e_tunnel_robo_jump
;kabe_hou
	m_inertpath	-32,-150,1024,-deg90,tsu_hou_t,e_kabe_hou
	m_inertpath	2*1024+32,-150,1024,deg90,tsu_hou_t,e_kabe_hou
	map_endarea
;-----------------------------------------
stg41_area1
;final_door
	m_inertpath	3*1024+140,1,4*1024+512,-deg90,kabe_aku,e_final_door
;yamori
	pathobj		0,2*1024,-100,5*1024+32-60,yamori_b,e_yamori,1,-64
;kabe
	m_inertpath	512,0000,3*1024+512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	2*1024+512,0000,5*1024+512,deg180,kabe_0,e_nocol_s_off
;kado
	m_inertpath	3*1024+512,0000,2*1024+512,0,kado_2,e_nocol_s_off
	m_inertpath	512,0000,5*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	512,0000,2*1024+512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	3*1024+512,0000,5*1024+512,deg90,kado_4,e_nocol_s_off
;damage_floor
	m_inertpath	2*1024,512,4*1024,0,da_yuka,e_damage_yuka
;secret_kado
	m_inertpath	3*1024,0000,3*1024,deg90,kado_1,e_nocol_s_off
	m_inertpath	3*1024,0000,3*1024-512,0,kado_4,e_nocol_s_off
	m_inertpath	3*1024+512,0000,3*1024,0,kado_4,e_nocol_s_off
	map_endarea
;-----------------------------------------
stg41_area2
;b_kabe
	m_inertpath	4*1024+512,0000,3*1024+512,0,b_kabe_0,e_nocol_s_off
;b_kado
	m_inertpath	6*1024+512,0000,3*1024+512,0,b_kado_2,e_nocol_s_off
	m_inertpath	3*1024+512,0000,6*1024+512,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	6*1024+512,0000,6*1024+512,deg90,b_kado_2,e_nocol_s_off
	m_inertpath	3*1024+512,0000,3*1024+512,-deg90,b_kado_4,e_nocol_s_off
;core
	m_inertpath	5*1024,00,5*1024,0,kaku_0_0,e_base_core
	map_endarea
;-----------------------------------------
stg41_area3
;medal_$17
	m_inertpath	3*1024-100,-80,3*1024+100,$17,medal,e_omake_medal
	map_endarea
;-----------------------------------------
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step4_3
;1_way_door_final
	m_inertpath	8*1024-256,1,2*1024+140,0,kaku_to,e_final_1way_door
;tsuuro_final
	m_inertpath	8*1024-256,1,2*1024+512,0,kabe_to2,e_buil_shadow_off_g
;tsuuro
	m_inertpath	256,0000,2*1024+512,0,kabe_to2,e_buil_shadow_off_g
;final_door
	m_inertpath	8*1024-256,2,3*1024-140,deg180,kabe_aku,e_final_door
;tousenbo
	m_inertpath	8*1024-256,0,6*1024,deg180,kakureto,e_tousenbo
	m_inertpath	8*1024-256,0,4*1024,deg180,kakureto,e_tousenbo
;kado
	m_inertpath	1024,0000,7*1024,deg90,kado_1,e_buil_shadow_off
	m_inertpath	7*1024,0000,7*1024,0,kado_1,e_buil_shadow_off
	m_inertpath	-512,0000,8*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	8*1024+512,0000,8*1024+512,deg90,kado_2,e_nocol_s_off
;;1way_door_area0
;	m_inertpath	256,4,3*1024-140,deg180,kabe_ak1,e_1way_door
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,0000,0000,2*1024,3*1024,stg43_area0,on
	map_area 1,0000,2*1024,2*1024,6*1024,stg43_area1,on
	map_area 2,0000,6*1024,8*1024,2*1024,stg43_area2,on
	map_area 3,6*1024,2*1024,2*1024,6*1024,stg43_area3,on
	map_area 4,6*1024,0000,2*1024,3*1024,stg43_area4,on
	map_area 5,0512,2*1024,1024+512,5*1024,0,off,inactive
	map_area 6,6*1024,2*1024,1024+512,5*1024,0,off,inactive
	map_area 7,1024,6*1024,6*1024,1024+512,0,off,inactive
	map_endarea
;-----------------------------------------
stg43_area0
;switch_door
	m_inertpath	256,1,2*1024+140,0,kabe_aku,e_switch_op_door
;switch_cup
	m_inertpath	1024,0,1024,1,cup_0,e_switch_cup
;entrance
	m_inertpath	1024,0000,-512,0,kabe_to3,e_nocol_s_off
;kabe
	m_inertpath	1024-256,0000,2*1024+512,deg180,kabe_3,e_nocol_s_off
	m_inertpath	-512,0000,1024+256,-deg90,kabe_1,e_nocol_s_off
	m_inertpath	2*1024+512,0000,1024-256,deg90,kabe_3,e_nocol_s_off
;kado
	m_inertpath	-512,0000,-512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,-512,0,kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,2*1024+512,deg90,kado_2,e_nocol_s_off
	m_inertpath	-512,0000,2*1024+512,deg180,kado_4,e_nocol_s_off
	map_endarea
;-----------------------------------------
stg43_area1
;kabe
	m_inertpath	-512,0000,4*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,6*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,4*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,6*1024,deg90,kabe_2,e_nocol_s_off
;rot_doors
	m_inertpath	0256,0000,4*1024,-8,t_to_2,e_hit_stop_door
	m_inertpath	0256,0000,5*1024,-8,t_to_2,e_hit_stop_door
	m_inertpath	0256,0000,6*1024,-8,t_to_2,e_hit_stop_door
	map_endarea
;-----------------------------------------
stg43_area2
;kabe
	m_inertpath	2*1024,0000,8*1024+512,deg180,kabe_2,e_nocol_s_off
	m_inertpath	4*1024,0000,8*1024+512,deg180,kabe_2,e_nocol_s_off
	m_inertpath	6*1024,0000,8*1024+512,deg180,kabe_2,e_nocol_s_off
	m_inertpath	2*1024,0000,7*1024,0,kabe_2,e_nocol_s_off
	m_inertpath	4*1024,0000,7*1024,0,kabe_2,e_nocol_s_off
	m_inertpath	6*1024,0000,7*1024,0,kabe_2,e_nocol_s_off
;saka_roof
	m_inertpath	3*1024,0000,8*1024-256,deg90,t_saka_0,e_hako_1
	m_inertpath	5*1024+100,0000,8*1024-256,deg90,t_saka_0,e_hako_1
	m_inertpath	6*1024-100,0000,8*1024-256,-deg90,t_saka_0,e_hako_0
;damage_piller
	m_inertpath	4*1024,-320+80,8*1024-256,$43,da_ha_yo,e_damage_yokobou_move
	m_inertpath	7*1024,-160+90,8*1024-256,$43,da_ha_yo,e_damage_bou
	m_inertpath	7*1024,-160-90,8*1024-256,$43,da_ha_yo,e_damage_bou
;pillar_switch
	m_inertpath	5*1024+512,00,8*1024-256,3,on_d,e_neta_switch_bou
	map_endarea
;-----------------------------------------
stg43_area3
;kabe
	m_inertpath	7*1024,0000,4*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	7*1024,0000,6*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	8*1024+512,0000,4*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	8*1024+512,0000,6*1024,deg90,kabe_2,e_nocol_s_off
	map_endarea
;-----------------------------------------
stg43_area4
;b_kabe
	m_inertpath	7*1024+256,0000,2*1024+512,deg180,b_kabe_3,e_nocol_s_off
	m_inertpath	8*1024+512,0000,1024+512,deg90,b_kabe_0,e_nocol_s_off
;b_kado
	m_inertpath	5*1024+512,0000,-512,-deg90,b_kado_2,e_nocol_s_off
	m_inertpath	8*1024+512,0000,-512,0,b_kado_2,e_nocol_s_off
	m_inertpath	5*1024+512,0000,2*1024+512,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	8*1024+512,0000,2*1024+512,deg90,b_kado_4,e_nocol_s_off
;core
	m_inertpath	7*1024,00,1024,0,kaku_0_0,e_base_core
;medal_$27
	m_inertpath	6*1024+256,-80,256,$27,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step4_5
;1_way_door_final
	m_inertpath	4*1024,1,9*1024-140,deg180,kaku_to,e_final_1way_door
;tsuuro_final
	m_inertpath	4*1024,1,8*1024+512,0,kabe_to,e_buil_range_off
;;;	m_inertpath	4*1024,1,8*1024+512,0,kabe_to,e_buil_shadow_off_g
;tsuuro
	m_inertpath	1024,0000,2*1024+512,0,kabe_to,e_buil_shadow_off_g
	m_inertpath	7*1024,0000,2*1024+512,deg180,kabe_to,e_buil_shadow_off_g
	m_inertpath	4*1024,2,5*1024+512,0,kabe_to,e_buil_shadow_off_g
	m_inertpath	2*1024+512,0000,4*1024,-deg90,kabe_to,e_buil_shadow_off_g
	m_inertpath	5*1024+512,0000,4*1024,-deg90,kabe_to,e_buil_shadow_off_g
;1way_door
	m_inertpath	4*1024,2,6*1024-140,deg180,kabe_ak1,e_1way_door

;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,0000,0000,2*1024,3*1024,stg45_area0,on
	map_area 1,0000,2*1024,3*1024,3*1024,stg45_area1,on
	map_area 2,2*1024,2*1024,4*1024,4*1024,stg45_area2,on
	map_area 3,5*1024,2*1024,3*1024,3*1024,stg45_area3,on
	map_area 4,6*1024,0000,2*1024,3*1024,stg45_area4,on
	map_area 5,3*1024,5*1024,2*1024,4*1024,stg45_area5,on
	map_area 6,3*1024,8*1024,2*1024,3*1024,stg45_area6,on
	map_area 7,0000,2*1024,512,1024,0,off,inactive
	map_area 8,1024+512,2*1024,5*1024,1024,0,off,inactive
	map_area 9,7*1024+512,2*1024,512,1024,0,off,inactive
	map_area 10,2*1024,3*1024,1024,512,0,off,inactive
	map_area 11,5*1024,3*1024,1024,512,0,off,inactive
	map_area 12,2*1024,4*1024+512,1024,512,0,off,inactive
	map_area 13,5*1024,4*1024+512,1024,512,0,off,inactive
	map_area 14,2*1024,5*1024,1024+512,1024,0,off,inactive
	map_area 15,4*1024+512,5*1024,1024+512,1024,0,off,inactive
	map_area 16,3*1024,8*1024,512,1024,0,off,inactive
	map_area 17,4*1024+512,8*1024,512,1024,0,off,inactive
	map_endarea
;-----------------------------------------
stg45_area0
;entrance
	m_inertpath	1024,0000,-512,0,kabe_to3,e_nocol_s_off
;kabe
	m_inertpath	-512,0000,1024,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	2*1024+512,0000,1024,deg90,kabe_0,e_nocol_s_off
;kado
	m_inertpath	-512,0000,-512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,-512,0,kado_3,e_nocol_s_off
	m_inertpath	-512,0000,2*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,2*1024+512,deg90,kado_3,e_nocol_s_off
;damage_yuka
	m_inertpath	1024,512,1024+256,0,da_yuka,e_damage_yuka
	m_inertpath	256+128,00,1024+256,0,t_hako_1,e_hako_0
	m_inertpath	2*1024-256-128,00,1024+256,0,t_hako_1,e_hako_0
;yuka_mukade
	m_inertpath	1024,0,1024+256,128,yuka_hou,e_yuka_hou_kotei
	map_endarea
;-----------------------------------------
stg45_area1
;kabe
	m_inertpath	-512,0000,4*1024-256,-deg90,kabe_3,e_nocol_s_off
	m_inertpath	1024+256,0000,5*1024+512,deg180,kabe_3,e_nocol_s_off
;kado
	m_inertpath	-512,0000,2*1024+512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,2*1024+512,0,kado_3,e_nocol_s_off
	m_inertpath	-512,0000,5*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,5*1024+512,deg90,kado_3,e_nocol_s_off
;hako
	m_inertpath	512-64,00,4*1024,0,t_hako_0,e_hako_2
	m_inertpath	1024,00,4*1024,0,t_hako_0,e_hako_0
	m_inertpath	1024,00,4*1024+512+64,0,t_hako_0,e_hako_2
;tai_hou
	m_inertpath	1024,-64-60,4*1024,0,taihou_0,e_laser_hou
;jump_tekuteku
	m_inertpath	400,-74,4*1024+256+100,96,tekuteku_s,e_tunnel_robo_jump
	map_endarea
;-----------------------------------------
stg45_area2
;kabe
	m_inertpath	4*1024,0000,2*1024+512,0,kabe_0,e_nocol_s_off
;kado
	m_inertpath	2*1024+512,0000,2*1024+512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,2*1024+512,0,kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,5*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,5*1024+512,deg90,kado_3,e_nocol_s_off
;kakomi
	m_inertpath	5*1024-256+32,0,3*1024+460,0,t_hako_1,e_hako_4
;door_switch
	m_inertpath	5*1024-70,00,3*1024+70,1,on_d,e_fumu_switch_door_map_aku
;switch_door
	m_inertpath	4*1024,1,5*1024+140,0,kabe_aku,e_switch_op_door
;switch_bou
	m_inertpath	4*1024+780,-160,3*1024+70,$20,da_ha_ta,e_damage_bou
	m_inertpath	4*1024+600,-160,3*1024+70,$20,da_ha_ta,e_damage_bou
;houdai_pillar
	m_inertpath	3*1024+512+256,0,4*1024+256,0,ha_hou_0,e_hako_hou
	map_endarea
;-----------------------------------------
stg45_area3
;kabe
	m_inertpath	8*1024+512,0000,4*1024-256,deg90,kabe_3,e_nocol_s_off
	m_inertpath	7*1024-256,0000,5*1024+512,deg180,kabe_3,e_nocol_s_off
;kado
	m_inertpath	5*1024+512,0000,2*1024+512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	8*1024+512,0000,2*1024+512,0,kado_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,5*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	8*1024+512,0000,5*1024+512,deg90,kado_2,e_nocol_s_off
;hako
	m_inertpath	7*1024,00,4*1024-256,0,t_hako_0,e_hako_0
	m_inertpath	7*1024+512+64,00,4*1024-256,0,t_hako_0,e_hako_2
	m_inertpath	7*1024,00,4*1024+256+64,0,t_hako_0,e_hako_2
;tai_hou
	m_inertpath	7*1024,-64-60,4*1024-256,0,taihou_0,e_laser_hou
;bou_switch
	m_inertpath	7*1024+512+100,00,4*1024+256+100,2,on_d,e_neta_switch_bou
;switch_bou
	m_inertpath	6*1024+256,-160,3*1024+256,$20,da_ha_ta,e_damage_bou
	map_endarea
;-----------------------------------------
stg45_area4
;kabe
	m_inertpath	5*1024+512,0000,1024+256,-deg90,kabe_3,e_nocol_s_off
	m_inertpath	8*1024+512,0000,1024+256,deg90,kabe_3,e_nocol_s_off
;kado
	m_inertpath	5*1024+512,0000,-512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	8*1024+512,0000,-512,0,kado_2,e_nocol_s_off
	m_inertpath	5*1024+512,0000,2*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	8*1024+512,0000,2*1024+512,deg90,kado_3,e_nocol_s_off
;damage_yuka
	m_inertpath	7*1024,512,1024,0,da_yuka,e_damage_yuka
;tojikome_door
	m_inertpath	7*1024,1,2*1024+140,$00,kabe_ak1,e_tojikome_door
;kabe_mukade_medal_$45
	pathobj		0,7*1024,-120,1024,room_hou,e_kabe_mukade_tojikome,1,1
	map_endarea
;-----------------------------------------
stg45_area5
;final_door
	m_inertpath	4*1024,1,8*1024+140,0,kabe_aku,e_final_door
;roof_yamori
	pathobj		0,4*1024,-320+60,7*1024,yamori_b,e_tenjyou_yamori,2,10
;kabe
	m_inertpath	2*1024+512,0000,7*1024,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	5*1024+512,0000,7*1024,deg90,kabe_0,e_nocol_s_off
;kado
	m_inertpath	2*1024+512,0000,5*1024+512,-deg90,kado_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,5*1024+512,0,kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,8*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,8*1024+512,deg90,kado_3,e_nocol_s_off
;damage_yuka
	m_inertpath	4*1024,512,7*1024,0,da_yuka,e_damage_yuka
	map_endarea
;-----------------------------------------
stg45_area6
;b_kabe
	m_inertpath	2*1024+512,0000,10*1024-256,-deg90,b_kabe_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,10*1024-256,deg90,b_kabe_3,e_nocol_s_off
;b_kado
	m_inertpath	2*1024+512,0000,8*1024+512,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,8*1024+512,0,b_kado_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,11*1024+512,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	5*1024+512,0000,11*1024+512,deg90,b_kado_2,e_nocol_s_off
;core
	m_inertpath	4*1024,00,10*1024,0,kaku_0_0,e_base_core
	map_endarea
;;-------------------------------------------------------------
;-------------------------------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp

