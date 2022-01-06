;ษออออออออออออออออออออออออออออออออออออออออออป
;บ STAGE 6 FORTUNA 	sea_room	       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;-----------------------------------------
;-----------------------------------------
;-----clear bg set-------------
	setstgclrbg	missionstage6
;-----ground or room check-----
	mapgotoifplanet	stg6room
;-----ground start inicial-------
	setbg	missionstage6
	initbg
;-----room start inicial-------
	map_demomode	off
	map_nextmap	stg6room_cnt,enter_kaitei	;room mode
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
	map_playermode		marine
	map_setplayerpos	1,0000,-1150,-3*1024,0
	map_battlearea		-1400,0,-1000,water
	map_camerainit_1screen	-1180,100,16,-16,55H
	map_arwinginit		-1400,-1012,15,-15
;-------------------------------
;dots_set
	map_setdust	sprites,bubbles		
	map_dustsprite	awa,16		;awa
	map_dustkazu	32
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
	m_inertpath	02048,-488,02048,0,kakomi,e_sea_outline
	m_inertpath	-2048,-488,02048,deg90,kakomi,e_sea_outline
	m_inertpath	02048,-488,-2048,-deg90,kakomi,e_sea_outline
	m_inertpath	-2048,-488,-2048,deg180,kakomi,e_sea_outline
;-------------------------------------------------------------
;**** MAP STEPSET AREA (sea)****
;-------------------------------------------------------------
;;;;;	mapgotoiflevel	3,step6_2	;NOMAL_ground
	mapgotoiflevel	5,step6_4	;HARD_ground
;;;;;	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;;;;;step6_2
;base
	pathobj		0,-1000,0,0000,chika_k1,e_switch_base_sea,2,64
;fune
	pathobj		0,1000,-1010,3000,f_fune,e_sw_base_fune,1,64
;ryuuhyou_switch
	m_inertpath	1800,-1045,580,2,on_d,e_sw_base_switch_sea
	pathobj		0,1800,-1050,580,nullshape,e_sw_marker,2,10
;ryuuhyou
	m_inertpath	1900,-1000,0500,0,koori_0,e_sea_buil_above_soff
	m_inertpath	1600,-1000,-100,0,koori_0,e_sea_buil_above_soff
	m_inertpath	1800,-1000,-1000,0,koori_1,e_sea_buil_above_soff
;;hyouzan
;	m_inertpath	-2800,-1000,03300,deg90,hyouzan,e_hyouzan
;	m_inertpath	3200,-1000,02500,0,hyouzan,e_hyouzan
;rocks
	m_inertpath	02500,0000,03000,0,m_iwa_0,e_sea_buil_below_soff
	m_inertpath	-3200,0000,-3200,-deg45,m_iwa_6,e_sea_buil_below_soff
;missile
	m_inertpath	03500,-490,-3500,0,dandou_tate,e_sea_dandou_a
	m_inertpath	03500,0000,-3500,32,miss_dai,e_miss_dai_live_sea
;iwashi
	m_inertpath	02000,-300,2500,0,iwashi_0m,e_wakidashi_iwashi
	m_inertpath	-2500,-300,1500,0,iwashi_0m,e_wakidashi_iwashi
	m_inertpath	2500,-300,-2000,0,iwashi_0m,e_wakidashi_iwashi
;amenbo
	m_inertpath	-800,-1040,-1500,0,amenbo,e_wakidashi_amenbo
;;kozakana
;	m_inertpath	-1500,-300,02500,4,kozakana,e_kozakana
;	m_inertpath	0000,-300,-2500,4,kozakana,e_kozakana
;twin_item
	m_inertpath	2800,-300,3000,1,item_ita,e_item_twinblaster
;smart_item
	m_inertpath	-2500,-80,-2500,2,item_ita,e_item_smartplasma
;kaifuku
	m_inertpath	-1000,0000,2500,0,kaifuku,e_kaifuku_panel_sea
;ryuuhyou
	m_inertpath	-4500,-1000,4500,0,koori_1,e_sea_buil_above_soff
;small_fishes
	pathobj		0,0000,0000,0000,nullshape,fishburst,2,2
;medal_sea_$2a
	m_inertpath	-4500,-100,4500,$2a,medal,e_omake_medal_sea
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step6_4
;base
	pathobj		0,000,0,000,chika_k1,e_switch_base_sea,1,-64
;boss_tako
	pathobj		0,1500,-450,1500,tako_0,boss_tako,1,10
;heart_item
	m_inertpath	0000,-200,-3500,1,item_ita,e_item_flamethrower
;smart_item
	m_inertpath	3100,-450,3300,2,item_ita,e_item_smartplasma
;kaifuku
	m_inertpath	02800,0000,-2500,0,kaifuku,e_kaifuku_panel_sea
;;rocks
;	m_inertpath	-3450,0000,03000,deg180,m_iwa_0,e_sea_buil_below_soff
;missile
	m_inertpath	-6750,-490+150,6050,0,dandou_tate,e_sea_dandou_a
;medal_sea_$3a
	m_inertpath	-7000,-80,6000,$3a,medal,e_omake_medal_sea
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
stg6room
	map_vscreensize_mission	6

;	m_range	8192
	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick

stg6room_cnt
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
	map_playermode		room,robot

	map_setplayerpos	1,0000,-120-20,0000,0
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
	map_demomode		start_kaitei
	map_demomode_clear	clear_kaitei
;-----------------------
;planet_message
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10
;;walker_start
;	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;-------------------------------------------------------------
;**** MAP STEPSET AREA (room)****
;-------------------------------------------------------------
	mapgotoiflevel	4,step6_3	;NOMAL_room
	mapgotoiflevel	6,step6_5	;HARD_room
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step6_3
;1_way_door_final
	m_inertpath	3*1024-140,1,0000,deg90,kaku_to,e_final_1way_door
;tsuuro_final
	pathobj		0,2*1024+512,1,0000,kabe_to,e_buil_range_off_hp,-deg90,10
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,-2*1024,-2*1024,5*1024,4*1024,stg63_area0,on
	map_area 1,2*1024,-1024,3*1024,2*1024,stg63_area1,on
	map_area 2,2*1024,-2*1024,1024,1024+512,0,off,inactive
	map_area 3,2*1024,512,1024,1024+512,0,off,inactive
	map_endarea
;-----------------------------------------
stg63_area0
;switch_door
	pathobj		0,2*1024+140,1,0000,kabe_aku,e_final_door_hp,-deg90,10
;teki
	pathobj		0,1024+256,0,-1024-256,mizukara,e_pool_robo,10,10
;kabe
	m_inertpath	0000,0000,-2*1024-512,0,kabe_2,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,0000,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,-512-256,deg90,kabe_3,e_nocol_s_off
	m_inertpath	2*1024+512,0000,512+256,deg90,kabe_3,e_nocol_s_off
	m_inertpath	0000,0000,2*1024+512,deg180,kabe_2,e_nocol_s_off
;kado	   
	m_inertpath	-2*1024-512,0000,-2*1024-512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,-2*1024-512,0,kado_2,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,2*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,2*1024+512,deg90,kado_2,e_nocol_s_off
;saka
	m_inertpath	-1024+256-64,00,-256-32,deg90,t_saka_0,e_hako_1
	m_inertpath	-1024+256-64,00,256+32,deg90,t_saka_0,e_hako_1
	m_inertpath	1024-256+64,00,-256-32,-deg90,t_saka_0,e_hako_1
	m_inertpath	1024-256+64,00,256+32,-deg90,t_saka_0,e_hako_1
;houdai_pillar
	m_inertpath	1024+768,0,1024+768,0,ha_hou_0,e_hako_hou
	m_inertpath	-1024-768,0,-1024-768,0,ha_hou_0,e_hako_hou
;entrance_pool
	m_inertpath	0000,00,0000,0,pools_0,e_ike_0
;pool
	m_inertpath	-1024-256,00,-1024-256,0,pools_0,e_ike_0
	m_inertpath	1024+256,00,-1024-256,0,pools_0,e_ike_0
	m_inertpath	-1024-256,00,1024+256,0,pools_0,e_ike_0
	m_inertpath	1024+256,00,1024+256,0,pools_0,e_ike_0


	m_inertpath	0000,00,1024-256,0,t_hako_1,e_hako_3
	m_inertpath	0000,00,-1024+256,0,t_hako_1,e_hako_3
;area_check
	map_area 4,2*1024,-2*1024,1024,512,stg63_area2,on
	map_endarea
;---------------------------------
stg63_area2
;kado	   
	m_inertpath	3*1024+512+32,0000,-2*1024-512,0,kado_3,e_nocol_s_off
	m_inertpath	3*1024+512+32,0000,-1024,deg90,kado_4,e_nocol_s_off
;kabe
	m_inertpath	2*1024+256+32,0000,-2*1024-512,0,kabe_3,e_nocol_s_off
	m_inertpath	2*1024+512+32,0000,-1024,deg180,kabe_0,e_nocol_s_off
;medal_$2b
	m_inertpath	3*1024-256,-80,-2*1024+256,$2b,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stg63_area1
;b_kado	   
	m_inertpath	2*1024+512,0000,-1024-512,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,-1024-512,0,b_kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,1024+512,deg180,b_kado_3,e_nocol_s_off
	m_inertpath	5*1024+512,0000,1024+512,deg90,b_kado_2,e_nocol_s_off
;b_kabe
	m_inertpath	4*1024-256,0000,-1024-512,0,b_kabe_3,e_nocol_s_off
	m_inertpath	4*1024-256,0000,1024+512,deg180,b_kabe_3,e_nocol_s_off
;core
	pathobj		0,4*1024+256,00,0000,kaku5_0,e_base_core_2,2,10
;core_kado
	m_inertpath	5*1024+32,-20<<kaku5_scale,-1024-32,0,kaku5_3,e_base_core_kado
	m_inertpath	5*1024+32,-20<<kaku5_scale,1024+32,64,kaku5_3,e_base_core_kado
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step6_5
;1_way_door_final
	m_inertpath	-512,1,-4*1024+140,0,kaku_to,e_final_1way_door
;tsuuro_final
	pathobj		0,-512,1,-3*1024-512,kabe_to,e_buil_range_off_hp,deg180,10
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,-2*1024,-4*1024,3*1024,7*1024,stg65_area0,on
	map_area 1,-1024-512,-6*1024,2*1024,3*1024,stg65_area1,on
	map_area 2,-2*1024,-4*1024,1024,1024,0,off,inactive
	map_area 3,0000,-4*1024,1024,1024,0,off,inactive
	map_area 4,-2*1024,2*1024,1024,1024,0,off,inactive
	map_area 5,0000,2*1024,1024,1024,0,off,inactive
	map_endarea
;-----------------------------------------
stg65_area0
;switch_door
	pathobj		0,-512,1,-3*1024-140,kabe_aku,e_final_door_hp,deg180,10
;teki
	pathobj		0,0000,0,-1024,mizukara,e_pool_robo2,10,10
;kabe
	m_inertpath	1024+512,0000,0,deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024+512,0000,-1024-512,deg90,kabe_0,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,0,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,-1024-512,-deg90,kabe_0,e_nocol_s_off
	m_inertpath	-512,0000,2*1024+512,deg180,kabe_0,e_nocol_s_off
;kado	   
	m_inertpath	1024+512,0000,-3*1024-512,0,kado_2,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,-3*1024-512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	-2*1024-512,0000,2*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,2*1024+512,deg90,kado_2,e_nocol_s_off
;hako
	m_inertpath	-512,0000,1024+256,0,t_hako_1,e_hako_2
	m_inertpath	-512,0000,-2*1024-256,0,t_hako_1,e_hako_2
;entrance_pool
	m_inertpath	0000,00,0000,0,pools_0,e_ike_0
;pool
	m_inertpath	-1024,00,-1024,0,pools_0,e_ike_0
	m_inertpath	-1024,00,00000,0,pools_0,e_ike_0
	m_inertpath	00000,00,-1024,0,pools_0,e_ike_0
;hou_piller
	m_inertpath	-512,0,-512,0,ha_hou_0,e_hako_hou
;kabe_hou
	m_inertpath	-1024-512,-150,2*1024+32,deg180,tsu_hou_t,e_kabe_hou
	m_inertpath	512,-150,2*1024+32,deg180,tsu_hou_t,e_kabe_hou
	m_inertpath	-1024-512,-150,-3*1024-32,0,tsu_hou_t,e_kabe_hou
	m_inertpath	512,-150,-3*1024-32,0,tsu_hou_t,e_kabe_hou
;tobidashi_tekuteku
	m_inertpath	-800,-75,-3*1024+300,0,tekuteku_s,e_tunnel_tobidashi_m
	m_inertpath	-200,-75,2*1024-300,deg180,tekuteku_s,e_tunnel_tobidashi_m
;area_check
	map_area 6,-1024,2*1024,1024,1024,stg65_area2,on
	map_endarea
;-----------------------------------------
stg65_area2
;kado	   
	m_inertpath	512,0000,3*1024+512+32,deg90,kado_2,e_nocol_s_off
	m_inertpath	-1024-512,0000,3*1024+512+32,deg180,kado_4,e_nocol_s_off
;kabe
	m_inertpath	-1024-512,0000,2*1024+512+32,-deg90,kabe_0,e_nocol_s_off
;kaifuku
	m_inertpath	-512,0000,2*1024+512,0,kaifuku,e_kaifuku_panel
;medal_$3b
	m_inertpath	-512,-80,3*1024-200,$3b,medal,e_omake_medal
	map_endarea
;-----------------------------------------
;
;
;-----------------------------------------
stg65_area1
;b_kado	   
	m_inertpath	1024,0000,-3*1024-512,deg90,b_kado_3,e_nocol_s_off
	m_inertpath	-2*1024,0000,-3*1024-512,deg180,b_kado_3,e_nocol_s_off
	m_inertpath	1024,0000,-6*1024-512,0,b_kado_2,e_nocol_s_off
	m_inertpath	-2*1024,0000,-6*1024-512,-deg90,b_kado_2,e_nocol_s_off
;b_kabe
	m_inertpath	1024,0000,-5*1024+256,deg90,b_kabe_3,e_nocol_s_off
	m_inertpath	-2*1024,0000,-5*1024+256,-deg90,b_kabe_3,e_nocol_s_off
;core
	pathobj		0,-512,00,-5*1024,kaku5_0,e_base_core_2,4,10
;core_kado
	m_inertpath	512+32,-20<<kaku5_scale,-6*1024-32,0,kaku5_3,e_base_core_kado
	m_inertpath	-1024-512-32,-20<<kaku5_scale,-6*1024-32,-64,kaku5_3,e_base_core_kado
	m_inertpath	512+32,-20<<kaku5_scale,-4*1024+32,64,kaku5_3,e_base_core_kado
	m_inertpath	-1024-512-32,-20<<kaku5_scale,-4*1024+32,128,kaku5_3,e_base_core_kado
	map_endarea
;-----------------------------------------
;-------------------------------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp




