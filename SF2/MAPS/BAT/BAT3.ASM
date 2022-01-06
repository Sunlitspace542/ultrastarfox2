	ifeq	1
;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  space1_battle (room)                    บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;;;	setbg	missionextra3
	setbg	battlestage3
	initbg
;;;	map_vscreensize_mission	6
	map_vscreensize_battle	3

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

;-----------------------------------------
;;**** MAP SET START ****
;players_position
	map_setplayerpos	1,256,-150,256,0
	map_setplayerpos	2,4*1024-256,-150,4*1024-256,deg180


	map_battlearea		-300,0,0,ground
	map_camerainit_1screen	-150,100,16,-16,70H	;55H


	map_camerainit_2screen	-150,100,16,-16,70H	;55H
	map_arwinginit		-300,-12,15,-15
;
;	map_playerblockmap_off	1
;	map_playerblockmap_off	2
;
	map_playermode		room
;dots_set
	map_setdust	coloured		
	map_dustkazu	0
;tunnel_mode
	map_playertunnel
;walker_start
	pathobj 	0,0000,00,0000,nullshape,e_auto_walker_bat,10,10
;battle_initialize
	pathobj 	0,0000,00,0000,nullshape,e_bat_sw_init,10,10
;-----------------------------------
;	BATTLE  MAP
;-----------------------------------
;	map_area 0,0000,0000,2*1024,2*1024,0,on,inactive
;;kabe
;	m_inertpath	2*1024+512,0000,1024,deg90,kabe_2_w,e_nocol_s_off
;	m_inertpath	-0512,0000,1024,-deg90,kabe_2_w,e_nocol_s_off
;	m_inertpath	1024,0000,2*1024+512,deg180,kabe_2_w,e_nocol_s_off
;	m_inertpath	1024,0000,-512,0,kabe_2_w,e_nocol_s_off
;------
	map_area 0,0000,0000,4*1024,4*1024,0,on,inactive
;kabe
	m_inertpath	1024,0000,-512,0,kabe_2_w,e_nocol_s_off
	m_inertpath	3*1024,0000,-512,0,kabe_2_w,e_nocol_s_off
	m_inertpath	4*1024+512,0000,1024,deg90,kabe_2_w,e_nocol_s_off
	m_inertpath	4*1024+512,0000,3*1024,deg90,kabe_2_w,e_nocol_s_off
	m_inertpath	-512,0000,1024,-deg90,kabe_2_w,e_nocol_s_off
	m_inertpath	-512,0000,3*1024,-deg90,kabe_2_w,e_nocol_s_off
	m_inertpath	1024,0000,4*1024+512,deg180,kabe_2_w,e_nocol_s_off
	m_inertpath	3*1024,0000,4*1024+512,deg180,kabe_2_w,e_nocol_s_off
;hako
	m_inertpath	2048,000,2048,0,t_hako_0,e_hako_2
	m_inertpath	3300,0000,3300,0,t_hako_1,e_hako_2
	m_inertpath	800,0000,800,0,t_hako_1,e_hako_2
	m_inertpath	800,0000,3300,0,t_hako_1,e_hako_2
	m_inertpath	3300,0000,800,0,t_hako_1,e_hako_2
;;kaifuku
;	m_inertpath	3600,0,0512,0,kaifuku,e_kaifuku_panel
;	m_inertpath	0512,0,3600,0,kaifuku,e_kaifuku_panel
;
;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

	endc

