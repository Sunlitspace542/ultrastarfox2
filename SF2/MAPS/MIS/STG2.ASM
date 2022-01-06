;ษออออออออออออออออออออออออออออออออออออออออออป
;บ STAGE 2 TAITANIA ground_room	       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;-----------------------------------------
;-----------------------------------------
;-----clear bg set-------------
	setstgclrbg	missionstage2
;-----ground or room check-----
	mapgotoifplanet	stg2room
;-----ground start inicial-------
	setbg	missionstage2
	initbg
;-----room start inicial-------
	map_demomode	off
	map_nextmap	stg2room_cnt,enter_chika	;room mode

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
	map_battlearea		-600,0,0,sand
	map_camerainit_1screen	-300,1,16,-16,55H
	map_arwinginit		-600,-12,15,-15
;-----------------------
;dots_set
;;;	map_setdust	sprites,mixed		
;;;	map_dustsprite	dokuro,8		;dokuro,size
;;;	map_dustkazu	32
	map_setdust	coloured		
;	map_dustsprite	118,16		;kusa
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
;;;;;	mapgotoiflevel	1,step2_0	;EASY_ground
	mapgotoiflevel	3,step2_2	;NOMAL_ground
	mapgotoiflevel	5,step2_4	;HARD_ground
;;;;;	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;;;;;step2_0
;base
	pathobj		0,0000,0,0000,chika_k0,e_switch_base,2,-64
;hako_switch
	m_inertpath	1700,0,1000,0,hako_dai1,e_buil_shadow_off
	m_inertpath	1700,-56,1000,1,on_d,e_sw_base_switch
	pathobj		0,1700,-56,1000,nullshape,e_sw_marker,1,10
	m_inertpath	1700,-200,1000,0,arrow_0,e_sw_arrow
;ground_switch
	m_inertpath	-1700,00,-1000,2,on_d,e_sw_base_switch
	pathobj		0,-1700,00,-1000,nullshape,e_sw_marker,2,10
	m_inertpath	-1700,-140,-1000,0,arrow_0,e_sw_arrow
;block
	m_inertpath	-1700,0,1000,0,nobiru,e_hako_1
	m_inertpath	1700,0,-1000,0,nobiru,e_hako_1
;sekizou
	m_inertpath	0000,0020,-2000,deg180,kao_man,e_kao_man
;flying_kaoman
	m_inertpath	00000,-180,0000,0,kao_man,e_round_dosun
;rocks
	m_inertpath	-2000,0000,03000,0,m_iwa_0,e_for_m_iwa
	m_inertpath	-3000,0000,-1000,0,m_iwa_2,e_for_m_iwa
;totem
	m_inertpath	-1000,0,-1700,0,totem_2,e_totem_pole
	m_inertpath	1000,0,0500,0,totem_2,e_totem_pole
	m_inertpath	200,0,-2400,0,totem_2,e_totem_pole
;kumo
	m_inertpath	2500,-50,700,deg90,kumo_0,e_wakidashi_kumo
;	m_inertpath	1900,-50,1300,deg90,kumo_0,e_wakidashi_kumo
;hae
	m_inertpath	-500,-300,-1500,100,hae_0,e_wakidashi_hae
	m_inertpath	-1000,-200,1500,-100,hae_0,e_wakidashi_hae
;missile
	m_inertpath	3000,-350,-3000,0,dandou_tate,e_ground_dandou_a
;twin_item
	m_inertpath	02000,0000,-1200,1,itembox0,e_panel_twinblaster
;smart_item
	m_inertpath	-3500,0,-1200,2,itembox0,e_panel_smartplasma
;kaifuku _panel
	m_inertpath	00000,0000,-2500,0,kaifuku,e_kaifuku_panel
	m_inertpath	0000,-120,-2500,0,arrow_0,e_sw_arrow
;sekizou_medal_$43
	m_inertpath	0000,0040,2000,deg90,kao_man,e_kao_man
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step2_2
;base
	pathobj		0,0000,0,0000,chika_k0,e_switch_base,2,0
;tori
	pathobj		0,2500,-500,2500,k_tori_0,e_sw_base_bird,1,10
;hasami
	pathobj		0,-2500,00,-2500,hasami_2,e_sw_base_worm,2,10
;stone			 
	m_inertpath	02500,0000,2500,0,yama_1_0,e_buil_shadow_off
	m_inertpath	02500,0000,2500,0,yama_1_2,e_buil_shadow_off
;rock
	m_inertpath	2500,0000,1700,0,m_iwa_5,e_for_m_iwa
	m_inertpath	3300,0000,2500,0,m_iwa_5,e_for_m_iwa
	m_inertpath	1700,0000,2500,0,m_iwa_5,e_for_m_iwa
	m_inertpath	2500,0000,3300,0,m_iwa_5,e_for_m_iwa
;nasuka
	m_inertpath	-2500,0000,-2500,-deg22,nazca_0,e_nocol_s_off_g
;hae
	m_inertpath	0000,-200,2500,100,hae_0,e_wakidashi_hae
	m_inertpath	-300,-250,-2200,100,hae_0,e_wakidashi_hae
;kumo
;;;	m_inertpath	500,-50,1500,deg90,kumo_0,e_wakidashi_kumo
	m_inertpath	-2800,-50,1200,deg180,kumo_0,e_wakidashi_kumo
;missile
	m_inertpath	-3000,-400,3000,0,dandou_tate,e_ground_dandou_a
;sekizou
	m_inertpath	3000,0020,-2800,0,kao_man,e_kao_man
	m_inertpath	2800,0000,-3000,deg90,kao_man,e_buil_shadow_off
	m_inertpath	3200,0000,-3000,-deg90,kao_man,e_buil_shadow_off
	m_inertpath	3000,0000,-3200,deg180,kao_man,e_buil_shadow_off
;totem
	m_inertpath	-200,0,-2400,0,totem_2,e_totem_pole
	m_inertpath	0200,0,-2000,0,totem_2,e_totem_pole
;kaifuku_panel
	m_inertpath	-3000,0000,3000,0,kaifuku,e_kaifuku_panel
;twin_item
	m_inertpath	3000,0000,-3000,1,itembox0,e_panel_twinblaster
;heart_item
	m_inertpath	-3000,0,0000,2,itembox0,e_panel_flamethrower
;mukade_medal_$40
	m_inertpath	000,0000,000,0,mukade_1,e_wakidashi_mukade
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
step2_4
;base
	pathobj		0,2500,0,-500,chika_k0,e_switch_base,2,64
;slide_switch
	m_inertpath	-2800,0,-500,1,sli_0,e_sw_base_slide
	pathobj		0,-2800,0,-500,nullshape,e_sw_marker,1,10
;taosu_switch
	pathobj		0,2500,0,2500,taoreru1,e_sw_base_taosu,2,10
	pathobj		0,2500,0,2500,nullshape,e_sw_marker,2,10
;rock
	m_inertpath	2800,0000,2200,0,m_iwa_5,e_for_m_iwa
	m_inertpath	2200,0000,2200,0,m_iwa_5,e_for_m_iwa
;missile_dai
	m_inertpath	-3500,-350,3000,0,dandou_tate,e_ground_dandou_a
;dosun_kaoman
	m_inertpath	00000,-300,-1700,deg180,kao_man,e_dosun
;taihou
	m_inertpath	-1500,-60,-1000,0,taihou_0,e_laser_hou
	m_inertpath	01500,-60,-1000,0,taihou_0,e_laser_hou
;;;;;	m_inertpath	0000,-160-60,0000,0,taihou_0,e_laser_hou
	m_inertpath	0000,-30-60,3000,0,taihou_0,e_laser_hou
;kaifuku _panel
	m_inertpath	00000,000,03000,0,kaifuku,e_kaifuku_panel
;kumo
	m_inertpath	-1500,-50,2000,deg180,kumo_0,e_wakidashi_kumo
;	m_inertpath	2000,-50,1000,deg90,kumo_0,e_wakidashi_kumo
	m_inertpath	1600,-50,-1500,deg90,kumo_0,e_wakidashi_kumo
;hae
	m_inertpath	-800,-300,-2000,150,hae_0,e_wakidashi_hae
	m_inertpath	2000,-200,2000,100,hae_0,e_wakidashi_hae
;heart_item
	m_inertpath	-3000,0,3000,1,itembox0,e_panel_flamethrower
;smart_item
	m_inertpath	0000,-100,-1800,2,item_ita,e_item_smartplasma
;center_pyramid
	m_inertpath	0,0,0,0,pyramid0,e_buil_shadow_off
;area_check
	map_area 1,-256,-256,512,512,stg24_area1,on
	map_endarea
;----------------------------
stg24_area1
;medal_$32
	m_inertpath	00,-240,00,$32,medal,e_omake_medal
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
stg2room

	map_vscreensize_mission	6

;	m_range	8192
	m_scale	1
	mapcode_jsl	initblack_l
	setvar		stayblack,1
	setfadeup	quick
stg2room_cnt

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

	map_setplayerpos	1,0256,-120-20,0020,0
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
;
	map_demomode		start_chika
	map_demomode_clear	clear_chika

;planet_message
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0
;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_planet,10,10
;;walker_start
;	pathobj 	0,0000,00,0000,nullshape,e_auto_walker,10,10
;-----------------------------------------
;**** MAP STEPSET AREA (room)****
;-------------------------------------------------------------
;;;;;	mapgotoiflevel	2,step2_1	;EASY_room
	mapgotoiflevel	4,step2_3	;NOMAL_room
	mapgotoiflevel	6,step2_5	;HARD_room
;;;;;	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
;;;;;step2_1
;1_way_door_final
	m_inertpath	1024,1,10*1024-140,deg180,kaku_to,e_final_1way_door
;final_tsuuro
	m_inertpath	1024,1,9*1024+512,0,kabe_to,e_buil_shadow_off_g
;1way_door
	m_inertpath	256,2,7*1024-140,deg180,kabe_ak1,e_1way_door
;tsuuro
	m_inertpath	256,2,6*1024+512,deg180,kabe_to2,e_buil_shadow_off_g
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,0000,0000,512,7*1024,stg21_area0,on
	map_area 1,0000,6*1024,2*1024,4*1024,stg21_area1,on
	map_area 2,0000,9*1024,2*1024,3*1024,stg21_area2,on
	map_area 3,0512,6*1024,1024+512,1024,0,off,inactive
	map_area 4,0000,9*1024,512,1024,0,off,inactive
	map_area 5,1024+512,9*1024,512,1024,0,off,inactive
	map_endarea
;-----------------------------------------
stg21_area0
;kabe
	m_inertpath	-512,0000,1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,3*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,5*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,3*1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,5*1024,deg90,kabe_2,e_nocol_s_off
;entrance
	m_inertpath	0256,0000,-512,0,kabe_to5,e_nocol_s_off
;damage_pillar
	m_inertpath	0256,-80,2*1024,$01,da_ha_yo,e_damage_bou
	m_inertpath	100,-160,3*1024,$01,da_ha_ta,e_damage_bou
	m_inertpath	444,-160,4*1024,$01,da_ha_ta,e_damage_bou
	m_inertpath	0256,-250,5*1024,$01,da_ha_yo,e_damage_yokobou_move
;medal_$13
	m_inertpath	450,-80,4*1024+180,$13,medal,e_omake_medal
	map_endarea
;-----------------------------------------
stg21_area1
;final_door
	m_inertpath	1024,1,9*1024+140,0,kabe_aku,e_final_door
;r_tank
	pathobj		0,1024+512,00,8*1024+512,r_tank_0,e_root_tank_final,1,10
;kabe
	m_inertpath	-512,0000,8*1024-256,-deg90,kabe_1,e_nocol_s_off
	m_inertpath	2*1024+512,0000,8*1024+256,deg90,kabe_3,e_nocol_s_off
	m_inertpath	1024-256,0000,7*1024-512,0,kabe_3,e_nocol_s_off
;kado
	m_inertpath	2*1024+512,0000,7*1024-512,0,kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,9*1024+512,deg90,kado_3,e_nocol_s_off
	m_inertpath	-512,0000,9*1024+512,deg180,kado_3,e_nocol_s_off
	m_inertpath	-512,0000,6*1024+512,-deg90,kado_4,e_nocol_s_off
;hako
	m_inertpath	1024,00,8*1024,0,t_hako_1,e_hako_2
	map_endarea
;-----------------------------------------
stg21_area2
;b_kabe
	m_inertpath	2*1024+512,0000,11*1024-256,deg90,b_kabe_3,e_nocol_s_off
	m_inertpath	-512,0000,11*1024-256,-deg90,b_kabe_3,e_nocol_s_off
;b_kado
	m_inertpath	2*1024+512,0000,12*1024+512,deg90,b_kado_2,e_nocol_s_off
	m_inertpath	-512,0000,12*1024+512,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	2*1024+512,0000,9*1024+512,0,b_kado_3,e_nocol_s_off
	m_inertpath	-512,0000,9*1024+512,-deg90,b_kado_3,e_nocol_s_off
;core
	m_inertpath	01024,00,11*1024,0,kaku_0_0,e_base_core
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step2_3
;1_way_door_final
	m_inertpath	0256,1,6*1024+512-140,deg180,kaku_to,e_final_1way_door
;tsuuro_final
	m_inertpath	256,1,6*1024,deg180,kabe_to2,e_buil_range_off
;;;	m_inertpath	256,1,6*1024,deg180,kabe_to2,e_buil_shadow_off_g
;final_door
	m_inertpath	256,2,5*1024+512+140,0,kabe_aku,e_final_door
;left_tsuuro
	m_inertpath	-1024,0,5*1024-256,-deg90,kabe_to2,e_buil_shadow_off
	m_inertpath	-1024-512+140,1,5*1024-256,$c0,kabe_ak1,e_tojikome_door
;right_tsuuro
	m_inertpath	1024+512,0,5*1024-256,deg90,kabe_to2,e_buil_shadow_off_g
	m_inertpath	2*1024-140,1,5*1024-256,$41,kabe_ak1,e_tojikome_door
;;tobidashi_tekuteku
;	m_inertpath	100,-75,4*1024,128,tekuteku_s,e_tunnel_tobidashi_p
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,-1024-512,0000,3*1024+512,6*1024+512,stg23_area0,on
	map_area 1,-3*1024-512,3*1024,3*1024,2*1024,stg23_area1,on
	map_area 2,1024,3*1024,3*1024,2*1024,stg23_area2,on
	map_area 3,-512,5*1024+512,1024+512,2*1024+512,stg23_area3,on
	map_area 4,-1024-512,0000,1024+512,4*1024,0,off,inactive
	map_area 5,512,0000,1024+512,4*1024,0,off,inactive
	map_area 6,-1024-512,4*1024,1024,512,0,off,inactive
	map_area 7,1024,4*1024,1024,512,0,off,inactive
	map_area 8,-1024-512,5*1024,1024,512,0,off,inactive
	map_area 9,1024,5*1024,1024,512,0,off,inactive
	map_area 10,-1024-512,5*1024+512,1024+512,1024,0,off,inactive
	map_area 10,512,5*1024+512,1024+512,1024,0,off,inactive
	map_endarea
;-----------------------------------------
stg23_area0
;entrance
	m_inertpath	0256,0000,-512,0,kabe_to5,e_nocol_s_off
;kabe
	m_inertpath	-512,0000,1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,1024,deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,3*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,3*1024,deg90,kabe_2,e_nocol_s_off
;kado
	m_inertpath	-512,0000,4*1024,0,kado_1,e_buil_shadow_off
	m_inertpath	1024,0000,4*1024,deg90,kado_1,e_buil_shadow_off
	m_inertpath	-512,0000,5*1024+512,-deg90,kado_1,e_buil_shadow_off
	m_inertpath	1024,0000,5*1024+512,deg180,kado_1,e_buil_shadow_off
;saka
	m_inertpath	512-128+32,000,2*1024,deg180,t_saka_1,e_buil_shadow_off
	m_inertpath	128-32,000,3*1024+512,deg180,t_saka_2,e_buil_shadow_off
;kurukuru_no_hit_doors
	m_inertpath	256,000,3*1024,8,t_to_3,e_hit_dont_stop_door
;medal_$23
	m_inertpath	450,-80,2*1024+400,$23,medal,e_omake_medal
	map_endarea
;-----------------------------------------
stg23_area1
;kabe
	m_inertpath	-2*1024,0000,5*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	-1024,0000,4*1024+256,deg90,kabe_3,e_nocol_s_off
;kado
	m_inertpath	-4*1024,0000,5*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	-4*1024,0000,2*1024+512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	-1024,0000,2*1024+512,0,kado_2,e_nocol_s_off
	m_inertpath	-1024,0000,5*1024+512,deg90,kado_4,e_nocol_s_off
;hako
	m_inertpath	-2*1024-512,00,4*1024,0,t_hako_1,e_hako_2
;r_tank_left
	pathobj		0,-3*1024,1,4*1024-512,r_tank_0,e_root_tank_tojikomefinal,1,10
	map_endarea
;-----------------------------------------
stg23_area2
;kabe
	m_inertpath	2*1024+512,0000,5*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	1024+512,0000,4*1024+256,-deg90,kabe_3,e_nocol_s_off
;kado
	m_inertpath	4*1024+512,0000,5*1024+512,deg90,kado_2,e_nocol_s_off
	m_inertpath	4*1024+512,0000,2*1024+512,0,kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,2*1024+512,-deg90,kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,5*1024+512,deg180,kado_4,e_nocol_s_off
;hako
	m_inertpath	3*1024,00,4*1024,0,t_hako_0,e_hako_1
;lazer_hou
	m_inertpath	3*1024,-60-128,4*1024,80,taihou_0,e_laser_hou
;r_tank_right
	pathobj		0,3*1024+512,00,4*1024+512,r_tank_0,e_root_tank_tojikomefinal,2,10
	map_endarea
;-----------------------------------------
stg23_area3
;b_kabe
	m_inertpath	-1024,0000,7*1024+256,-deg90,b_kabe_3,e_nocol_s_off
;b_kado
	m_inertpath	-1024,0000,6*1024,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,6*1024,0,b_kado_3,e_nocol_s_off
	m_inertpath	-1024,0000,8*1024+512,deg180,b_kado_3,e_nocol_s_off
	m_inertpath	1024+512,0000,8*1024+512,deg90,b_kado_2,e_nocol_s_off
;core
	m_inertpath	0256,00,7*1024+512,0,kaku_0_0,e_base_core
	map_endarea
;-------------------------------------------------------------
;
;
;-------------------------------------------------------------
step2_5
;1_way_door_final
	m_inertpath	2*1024+512,1,6*1024-140,deg180,kaku_to,e_final_1way_door
;tsuuro_final
	pathobj		0,2*1024+512,1,5*1024+512,kabe_to,e_buil_range_off,10,10
;;;	m_inertpath	2*1024+512,1,5*1024+512,0,kabe_to,e_buil_shadow_off_g
;final_switch_door
	pathobj		0,2*1024+512,1,5*1024+140,kabe_aku,e_final_door,10,10
;runner
	pathobj		0,256,0000,2*1024,runner_3,boss_runner,10,10
;kabe
	m_inertpath	1024+256,0000,-512,0,kabe_1,e_nocol_s_off
	m_inertpath	1024+512,0000,1024,deg180,kabe_0,e_nocol_s_off
	m_inertpath	3*1024,0000,-512,0,kabe_2,e_nocol_s_off
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,0000,0000,2*1024+512,5*1024,stg25_area0,on
	map_area 1,2*1024+512,0000,2*1024+512,5*1024,stg25_area1,on
	map_area 2,512,-1024,4*1024,1024+512,stg25_area2,on
	map_area 3,0000,3*1024,5*1024,3*1024,stg25_area3,on
	map_area 4,1024+512,5*1024,2*1024,2*1024+512,stg25_area4,on
	map_area 5,2*1024,-1024,1024,1024,stg25_area5,on
;
	map_area 6,1024,512,3*1024,4*1024,0,off,inactive
	map_area 7,512,1024,4*1024,3*1024,0,off,inactive
	map_area 8,0000,5*1024,2*1024,1024,0,off,inactive
	map_area 9,3*1024,5*1024,2*1024,1024,0,off,inactive
	map_area 10,512,-1024,1024+512,1024,0,off,inactive
	map_area 11,3*1024,-1024,1024+512,1024,0,off,inactive
	map_endarea
;-----------------------------------------
stg25_area0
;entrance
	m_inertpath	0256,0000,-512,0,kabe_to4,e_nocol_s_off
;kabe
	m_inertpath	-512,0000,1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	-512,0000,3*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,2*1024-256,deg90,kabe_1,e_nocol_s_off
	m_inertpath	1024,0000,3*1024+256,deg90,kabe_1,e_nocol_s_off
;kado
	m_inertpath	-512,0000,-512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	1024,0000,1024,deg180,kado_0,e_buil_shadow_off
	m_inertpath	-512,0000,5*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	1024,0000,4*1024,deg90,kado_0,e_buil_shadow_off
	map_endarea
;-----------------------------------------
stg25_area1
;kabe
	m_inertpath	5*1024+512,0000,2*1024-256,deg90,kabe_1,e_nocol_s_off
	m_inertpath	5*1024+512,0000,3*1024+256,deg90,kabe_1,e_nocol_s_off
	m_inertpath	4*1024,0000,2*1024+512,-deg90,kabe_2,e_nocol_s_off
;kado
	m_inertpath	5*1024+512,0000,5*1024+512,deg90,kado_2,e_nocol_s_off
	m_inertpath	4*1024,0000,4*1024,0,kado_0,e_buil_shadow_off
	m_inertpath	5*1024+512,0000,-512,0,kado_2,e_nocol_s_off
	m_inertpath	4*1024,0000,1024,-deg90,kado_0,e_buil_shadow_off
	map_endarea
;-----------------------------------------
stg25_area2
;kabe
	m_inertpath	3*1024,0000,1024,deg180,kabe_2,e_nocol_s_off
	map_endarea
;-----------------------------------------
stg25_area3
;kabe
	m_inertpath	2*1024-256,0000,4*1024,0,kabe_1,e_nocol_s_off
	m_inertpath	3*1024+256,0000,4*1024,0,kabe_1,e_nocol_s_off
;kabe
	m_inertpath	1024+512,0000,5*1024+512,deg180,kabe_0,e_nocol_s_off
	m_inertpath	3*1024+512,0000,5*1024+512,deg180,kabe_0,e_nocol_s_off
	map_endarea
;-----------------------------------------
stg25_area4
;b_kado
	m_inertpath	1024,0000,5*1024+512,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	4*1024,0000,5*1024+512,0,b_kado_3,e_nocol_s_off
	m_inertpath	1024,0000,8*1024,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	4*1024,0000,8*1024,deg90,b_kado_2,e_nocol_s_off
;core
	m_inertpath	2*1024+512,00,7*1024-256,0,kaku_0_0,e_base_core
	map_endarea
;-----------------------------------------
stg25_area5
;b_kado
	m_inertpath	3*1024+512,0000,-1024-512-32,0,kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,-1024-512-32,-deg90,kado_4,e_nocol_s_off
;b_kabe
	m_inertpath	1024+512,0000,-512-32,-deg90,kabe_0,e_nocol_s_off
;medal_$33
	m_inertpath	2*1024+512,-80,-1024+256,$33,medal,e_omake_medal
;kaifuku_panel
	m_inertpath	2*1024+512,0000,-512,0,kaifuku,e_kaifuku_panel
	map_endarea
;-----------------------------------------
;-----------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp


	ifeq	1

;-------------------------------------------------------------
step2_5
;1_way_door_final
	m_inertpath	2*1024+512,2,1024+512-140,deg180,kaku_to,e_final_1way_door
;tsuuro_final
	m_inertpath	2*1024+512,2,1024,0,kabe_to,e_buil_shadow_off_g
;final_switch_door
	m_inertpath	2*1024+512,1,512+140,0,kabe_aku,e_final_door
;runner
	pathobj		0,256,0000,2*1024,runner_3,boss_runner,10,10
;entrance
	m_inertpath	0256,0000,-512,0,kabe_to4,e_nocol_s_off
;kabe
	m_inertpath	1024+512,0000,-512,0,kabe_2,e_nocol_s_off
	m_inertpath	2*1024-256,0000,1024,deg180,kabe_3,e_nocol_s_off
	m_inertpath	-512,0000,1024,-deg90,kabe_2,e_nocol_s_off
;kado
	m_inertpath	-512,0000,-512,-deg90,kado_4,e_nocol_s_off
	m_inertpath	5*1024+512,0000,-512,0,kado_2,e_nocol_s_off
	m_inertpath	-512,0000,5*1024+512,deg180,kado_2,e_nocol_s_off
	m_inertpath	5*1024+512,0000,5*1024+512,deg90,kado_2,e_nocol_s_off
;
	m_inertpath	1024,0000,1024,deg180,kado_0,e_buil_shadow_off
	m_inertpath	4*1024,0000,1024,-deg90,kado_0,e_buil_shadow_off
	m_inertpath	1024,0000,4*1024,deg90,kado_0,e_buil_shadow_off
	m_inertpath	4*1024,0000,4*1024,0,kado_0,e_buil_shadow_off
;-----------------------------------------
;**** MAP SET AREA ****
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;
;area
	map_area 0,0512,0000,4*1024+512,1024+512,stg25_area0,on
	map_area 1,0000,0000,1024+512,5*1024,stg25_area1,on
	map_area 2,0000,3*1024+512,5*1024,2*1024+512,stg25_area2,on
	map_area 3,3*1024+512,0000,1024+512,5*1024,stg25_area3,on
	map_area 4,1024+512,512,2*1024,3*1024,stg25_area4,on
	map_area 5,512,1024,1024,3*1024,0,off,inactive
	map_area 6,3*1024+512,1024,1024,3*1024,0,off,inactive
	map_area 7,1024,512,1024,1024,0,off,inactive
	map_area 8,3*1024,512,1024,1024,0,off,inactive
	map_area 9,1024,3*1024+512,3*1024,1024,0,off,inactive
	map_area 10,0000,5*1024,2*1024,1024,0,off,inactive
	map_area 11,3*1024,5*1024,2*1024,1024,0,off,inactive
	map_endarea
;-----------------------------------------
stg25_area0
;kabe
	m_inertpath	3*1024+256,0000,-512,0,kabe_1,e_nocol_s_off
	m_inertpath	3*1024+256,0000,1024,deg180,kabe_3,e_nocol_s_off
	map_endarea
;-----------------------------------------
stg25_area1
;kabe
	m_inertpath	-512,0000,3*1024,-deg90,kabe_2,e_nocol_s_off
	m_inertpath	1024,0000,2*1024+512,deg90,kabe_2,e_nocol_s_off
	map_endarea
;-----------------------------------------
stg25_area2
;kabe
	m_inertpath	2*1024-256,0000,5*1024+512,deg180,kabe_1,e_nocol_s_off
	m_inertpath	3*1024+256,0000,5*1024+512,deg180,kabe_1,e_nocol_s_off
	m_inertpath	2*1024+512,0000,4*1024,0,kabe_2,e_nocol_s_off
;area_check
	map_area 12,2*1024,5*1024,1024,1024,stg25_area5,on
	map_endarea
;-----------------------------------------
stg25_area3
;kabe
	m_inertpath	5*1024+512,0000,2*1024-256,deg90,kabe_1,e_nocol_s_off
	m_inertpath	5*1024+512,0000,3*1024+256,deg90,kabe_1,e_nocol_s_off
	m_inertpath	4*1024,0000,2*1024+512,-deg90,kabe_2,e_nocol_s_off
;kado
	m_inertpath	5*1024+512,0000,5*1024+512,deg90,kado_2,e_nocol_s_off
	map_endarea
;-----------------------------------------
stg25_area4
;b_kabe
	m_inertpath	1024,0000,2*1024+256,-deg90,b_kabe_3,e_nocol_s_off
	m_inertpath	4*1024,0000,2*1024+256,deg90,b_kabe_3,e_nocol_s_off
;b_kado
	m_inertpath	1024,0000,1024,-deg90,b_kado_3,e_nocol_s_off
	m_inertpath	4*1024,0000,1024,0,b_kado_3,e_nocol_s_off
	m_inertpath	1024,0000,4*1024,deg180,b_kado_2,e_nocol_s_off
	m_inertpath	4*1024,0000,4*1024,deg90,b_kado_2,e_nocol_s_off
;core
	m_inertpath	2*1024+512,00,2*1024+512,0,kaku_0_0,e_base_core
	map_endarea
;-----------------------------------------
stg25_area5
;b_kado
	m_inertpath	3*1024+512,0000,6*1024+512+32,deg90,kado_2,e_nocol_s_off
	m_inertpath	1024+512,0000,6*1024+512+32,deg180,kado_4,e_nocol_s_off
;b_kabe
	m_inertpath	1024+512,0000,5*1024+512+32,-deg90,kabe_0,e_nocol_s_off
;medal_$33
	m_inertpath	2*1024+512,-80,6*1024-256,$33,medal,e_omake_medal
;kaifuku_panel
	m_inertpath	2*1024+512,0000,5*1024+512,0,kaifuku,e_kaifuku_panel
	map_endarea
;-----------------------------------------

	endc
