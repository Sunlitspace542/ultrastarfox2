	ifeq	1

;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  ground1_battle (ground)                 บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	battlestage1
	initbg

	map_vscreensize_battle	2

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

;-----------------------------------------
;**** MAP SET START ****
;------------------------------
;players_position
	map_setplayerpos	1,0,-150,-3000,0
	map_setplayerpos	2,0,-150,3000,deg180


	map_battlearea		-500,0,0,ground
	map_camerainit_1screen	-250,100,16,-16,70H	;55H


	map_camerainit_2screen	-250,100,16,-16,70H	;55H
	map_arwinginit		-500,-12,15,-15

;	map_playerblockmap_off	1
;	map_playerblockmap_off	2


;--------------------
;dots_set
	map_dustkazu	16
;radar_range
;	setvar.w	kx_radarscale,-1
;kakomi
	m_inertpath	02048,512,02048,0,kakomi,e_nocol_s_off_g
	m_inertpath	-2048,512,02048,deg90,kakomi,e_nocol_s_off_g
	m_inertpath	02048,512,-2048,-deg90,kakomi,e_nocol_s_off_g
	m_inertpath	-2048,512,-2048,deg180,kakomi,e_nocol_s_off_g
;walker_start
	pathobj 	0,0000,00,0000,nullshape,e_auto_walker_bat,10,10
;battle_initialize
	pathobj 	0,0000,00,0000,nullshape,e_bat_sw_init,10,10
;-----------------------------------------
;**** MAP DATA ****
;-----------------------------------------
	map_area 0,-4*1024,-4*1024,8*1024,8*1024,0,on,inactive
;hako
	m_inertpath	2*1024,0000,2*1024,0,t_hako_1,e_hako_2
	m_inertpath	2*1024,0000,-2*1024,0,t_hako_1,e_hako_2
	m_inertpath	-2*1024,0000,2*1024,0,t_hako_1,e_hako_2
	m_inertpath	-2*1024,0000,-2*1024,0,t_hako_1,e_hako_2
;twin_item
	pathobj		0,2000,-90,0000,nullshape,e_item_twin_bat,10,1
;heart_item
	pathobj		0,-2000,-90,0000,nullshape,e_item_heal_bat,10,2
;hp_item
	pathobj		0,3000,-90,3000,nullshape,e_item_hp_bat,10,3
	pathobj		0,-3000,-90,3000,nullshape,e_item_hp_bat,10,4
	pathobj		0,3000,-90,-3000,nullshape,e_item_hp_bat,10,5
	pathobj		0,-3000,-90,-3000,nullshape,e_item_hp_bat,10,6
;dummy_item
	pathobj		0,-3500,-90,000,nullshape,e_item_hp_bat,10,7
;shield_item
	pathobj		0,3500,-90,000,nullshape,e_item_hp_bat,10,8
;;;kaifuku
;;	m_inertpath	0000,-192,0000,0,kaifuku,e_kaifuku_panel
;hako_center
	m_inertpath	0000,-96,00000,0,t_hako_0,e_hako_2
;------------------------------
;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp







;-------------------------------
;panel,ring,target
;neta_set
;  ;rpts
;	pathobj		0,0,0,0,nullshape,e_prk_5of16,2,2
;
;pyramid_panel
;	pathobj		0,0000,-0240,00000,noru_1,e_noru_small,0,0
;tunnel_panel
;	pathobj		0,-4150,-0200,00000,noru_1,e_noru_small,0,0
;hodou_panel
;	pathobj		0,4200,-0200,00000,noru_1,e_noru_small,0,0
;dandan_panel
;	pathobj		0,04900,-150,-4000,noru_1,e_noru_small,0,0
;	pathobj		0,-4900,-150,4000,noru_1,e_noru_small,0,0
;sakashita_panel
;	pathobj		0,-4150,0000,-4000,noru_1,e_noru_small,0,0
;	pathobj		0,04150,0000,04000,noru_1,e_noru_small,0,0
;;-------------------------------
;;buildings
;;center_pyramid
;	m_inertpath	0,0,0,0,pyramid0,e_buil_shadow_off
;;hodoukyou
;	m_inertpath	4150,-158,0,0,hasi0_1,e_building
;	m_inertpath	4700,0,0,0,hasi0_2,e_buil_shadow_off
;	m_inertpath	3600,0,0,0,hasi0_0,e_buil_shadow_off
;;noreru_tunnel
;;	m_inertpath	-4150,-120,0,0,arch_0_1,e_building
;;	m_inertpath	-4270,0,0,-deg90,arch_0_0,e_buil_shadow_off
;;	m_inertpath	-4030,0,0,-deg90,arch_0_2,e_buil_shadow_off
;;saka
;;	m_inertpath	-4150,000,-3600,0,saka_0_2,e_buil_shadow_off
;	m_inertpath	-4150,000,-3600,deg180,saka_0_0,e_buil_shadow_off
;	m_inertpath	-4150,-80,-4000,0,saka_0_1,e_building
;	m_inertpath	-4150,000,-4400,0,saka_0_0,e_buil_shadow_off
;
;;	m_inertpath	4150,000,04400,0,saka_0_2,e_buil_shadow_off
;	m_inertpath	4150,000,04400,deg180,saka_0_0,e_buil_shadow_off
;	m_inertpath	4150,-80,04000,0,saka_0_1,e_building
;	m_inertpath	4150,000,03600,0,saka_0_0,e_buil_shadow_off
;;switch_arch
;;	pathobj		0,0000,0,-4000,arch_1_0,e_tunnel_0,2,2
;
;;	pathobj		0,0000,0,4000,arch_1_0,e_tunnel_0,2,2
;;1p_2p_tower
;;	m_inertpath	0000,00000,-5500,0,tou_0,e_buil_shadow_off
;
;;	m_inertpath	0000,00000,05500,0,tou_0,e_buil_shadow_off
;;dandan
;
;;	m_inertpath	4200,0,-4000,0,build_4,e_buil_shadow_off
;;	m_inertpath	4600,0,-4000,0,build_5,e_buil_shadow_off
;;	m_inertpath	4900,0,-4000,0,build_6,e_buil_shadow_off
;
;;	m_inertpath	-4200,0,04000,0,build_4,e_buil_shadow_off
;;	m_inertpath	-4600,0,04000,0,build_5,e_buil_shadow_off
;;	m_inertpath	-4900,0,04000,0,build_6,e_buil_shadow_off
;;lamps
;	m_inertpath	04400,0000,-3500,0,lamp_0,e_lamp_0
;	m_inertpath	03900,0000,-3500,0,lamp_0,e_lamp_0
;	m_inertpath	-4400,0000,03500,0,lamp_0,e_lamp_0
;	m_inertpath	-3900,0000,03500,0,lamp_0,e_lamp_0
;;way
;	m_inertpath	04150,0000,-2500,0,way_0,e_nocol_s_off
;	m_inertpath	04150,0000,-0900,0,way_0,e_nocol_s_off
;	m_inertpath	04150,0000,00700,0,way_0,e_nocol_s_off
;	m_inertpath	04150,0000,02300,0,way_0,e_nocol_s_off
;
;	m_inertpath	-4150,0000,02500,0,way_0,e_nocol_s_off
;	m_inertpath	-4150,0000,00900,0,way_0,e_nocol_s_off
;	m_inertpath	-4150,0000,-0700,0,way_0,e_nocol_s_off
;	m_inertpath	-4150,0000,-2300,0,way_0,e_nocol_s_off
;
;	m_inertpath	-3000,0000,-4000,deg90,way_0,e_nocol_s_off
;	m_inertpath	-1400,0000,-4000,deg90,way_0,e_nocol_s_off
;	m_inertpath	03000,0000,-4000,deg90,way_0,e_nocol_s_off
;	m_inertpath	01400,0000,-4000,deg90,way_0,e_nocol_s_off
;
;	m_inertpath	03000,0000,04000,deg90,way_0,e_nocol_s_off
;	m_inertpath	01400,0000,04000,deg90,way_0,e_nocol_s_off
;	m_inertpath	-3000,0000,04000,deg90,way_0,e_nocol_s_off
;	m_inertpath	-1400,0000,04000,deg90,way_0,e_nocol_s_off
;;----------------------------------------
;;tunnel_pyon
;;	m_inertpath	-4150,-80,0,0,pyonta_k,e_pyonta_kz
;;hodou_pyon
;;	m_inertpath	04000,-280,0000,0,pyonta_k,e_pyonta_kx
;;----------------------------------------
	endc

