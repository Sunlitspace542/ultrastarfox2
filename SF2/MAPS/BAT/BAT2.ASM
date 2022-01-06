	ifeq	1
;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  space_battle (space)	               บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;;	setbg	missionextra3
	setbg	battlestage2
	initbg

	map_vscreensize_battle	2

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

;-----------------------------------------
;**** MAP SET START ****
;-----------------------------------------
;players_position
	map_setplayerpos	1,0,000,-3000,0
	map_setplayerpos	2,0,000,3000,deg180


	map_playermode		space

;;	map_battlearea		-500,0,0,ground
	map_battlearea		-2000,2000,0,ground
	map_camerainit_1screen	-250,100,16,-16,70H	;55H


	map_camerainit_2screen	-250,100,16,-16,70H	;55H
	map_arwinginit		-500,-12,15,-15

	map_playerblockmap_off	1
	map_playerblockmap_off	2

;	map_playermode		room
;dots_set
	map_setdust	coloured,moving		
	map_dustkazu	32
;battle_initialize
	pathobj 	0,0000,00,0000,nullshape,e_bat_sw_init,10,10
;-----------------------------------------
;**** MAP DATA ****
;-----------------------------------------
;ITEM_battle
;twin_item
	pathobj		0,2000,-1000,0000,nullshape,e_item_twin_bat,10,1
;heart_item
	pathobj		0,-2000,-1000,0000,nullshape,e_item_heal_bat,10,2
;hp_item
	pathobj		0,3000,-500,3000,nullshape,e_item_hp_bat,10,3
	pathobj		0,-3000,-500,3000,nullshape,e_item_hp_bat,10,4
	pathobj		0,3000,500,-3000,nullshape,e_item_hp_bat,10,5
	pathobj		0,-3000,500,-3000,nullshape,e_item_hp_bat,10,6
;dummy_item
	pathobj		0,-3500,000,000,nullshape,e_item_dummy_bat,10,7
;shield_item
	pathobj		0,3500,000,000,nullshape,e_item_shield_bat,10,8
;smart_item
	pathobj		0,0000,000,000,nullshape,e_item_smart_bat,10,9


;-----------------------------------------
;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp






;;**** MAP SET START ****
;;players_position
;	map_setplayerpos	1,0500,-150,-5900,0
;	map_setplayerpos	2,-500,-150,5900,deg180
;
;
;---------------------------------------
;neta_set
;panels
;	pathobj		0,0,0,0,nullshape,e_pn_3of8,2,2
;-------------------------------
;
;;switch_arch
;;	pathobj		0,02000,0,01000,arch_1_0,e_tunnel_0,2,2
;;	pathobj		0,-2000,0,-1000,arch_1_0,e_tunnel_0,2,2
;;1p_2p_tower & kumo
;;	m_inertpath	-4500,000,-4500,0,tou_0,e_buil_shadow_off
;;	m_inertpath	-4500,-50,-4500,0,kumo_0,e_kumo_tou
;;	m_inertpath	04500,000,04500,0,tou_0,e_buil_shadow_off
;;	m_inertpath	04500,-50,04500,0,kumo_0,e_kumo_tou
;;tower_pyon
;;	m_inertpath	05000,-250,04300,0,pyonta_t,e_pyonta_tl
;;	m_inertpath	-5000,-250,-4300,0,pyonta_t,e_pyonta_tr
;;yajirobe-
;;	pathobj		0,0000,-195,0000,yajiro_0,e_yajiro_0,2,2
;;	m_inertpath	0000,-080,0000,0,yajiro_3,e_buil_shadow_off
;;	m_inertpath	0000,0000,0400,0,build_4,e_buil_shadow_off
;;	m_inertpath	0000,0000,-400,0,build_4,e_buil_shadow_off
;
;;gate
;	pathobj		0,0500,0,-3500,gate_0,e_gate_0,0,0
;	pathobj		0,-500,0,03500,gate_0,e_gate_0,0,0
;;boards
;;	m_inertpath	04500,0000,0250,0,ita_0,e_ita_s	
;;	m_inertpath	04500,0000,-250,0,ita_0,e_ita_s	
;;	m_inertpath	04000,0000,0000,0,ita_1,e_ita_m90	
;  ;board_pyon
;;	m_inertpath	04300,-80,0000,0,pyonta,e_pyonta
;;houdai
;;	pathobj		0,-3500,-160,-3500,gun_0_0,e_player_hou,1,1
;;	pathobj		0,03500,-160,03500,gun_0_0,e_player_hou,1,1
;;kusha
;	m_inertpath	03800,-150,-3800,0,kusha_1,e_kusha
;	m_inertpath	-3800,-150,03800,0,kusha_1,e_kusha
;
;;kakashi
;;	m_inertpath	-4300,0000,0800,0,kakashi,e_kakashi_0
;;	m_inertpath	-4300,0000,-800,0,kakashi,e_kakashi_0
;  ;kakashi_town
;;	m_inertpath	-4800,0000,0800,0,build_3,e_buil_shadow_off
;;	m_inertpath	-3700,0000,0800,0,build_3,e_buil_shadow_off
;;	m_inertpath	-4800,0000,0000,0,build_2,e_buil_shadow_off
;;	m_inertpath	-3700,0000,0000,0,build_2,e_buil_shadow_off
;;	m_inertpath	-4800,0000,-800,0,build_3,e_buil_shadow_off
;;	m_inertpath	-3700,0000,-800,0,build_3,e_buil_shadow_off
;;town
;;	m_inertpath	04300,0000,-4300,0,build_3,e_buil_shadow_off
;;	m_inertpath	04500,0000,-4300,0,build_2,e_buil_shadow_off
;;	m_inertpath	04500,0000,-4500,0,build_1,e_buil_shadow_off
;;	m_inertpath	04300,0000,-4500,0,build_0,e_buil_shadow_off
;
;;	m_inertpath	-4300,0000,04300,0,build_3,e_buil_shadow_off
;;	m_inertpath	-4500,0000,04300,0,build_2,e_buil_shadow_off
;;	m_inertpath	-4500,0000,04500,0,build_1,e_buil_shadow_off
;;	m_inertpath	-4300,0000,04500,0,build_0,e_buil_shadow_off
;  ;town_panel
;;	pathobj		0,04300,-0200,-4300,noru_1,e_noru_small,0,0
;;	pathobj		0,-4300,-0200,04300,noru_1,e_noru_small,0,0
;
;
;
;
	endc
