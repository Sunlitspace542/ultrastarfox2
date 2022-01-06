;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  Kawaguchi Test Map                      บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	missionexplain
	initbg

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,10

	setfadeup	quick

;dummy
	pathobj	0,0,125,400,nullshape,e_explain,100,0


	IFEQ	1
;-----------------------------------------
;**** MAP SET START ****
;players_position
	map_setplayerpos	1,0,-150,-5900,0
	map_setplayerpos	2,0,-150,05900,deg90
;-----------------------------------------
	pathobj	0000,-100,2000,0,pyonta_t,e_pyonta_tl,2,2
	pathobj	0500,-100,2000,0,pyonta_t,e_pyonta_tr,2,2

	ifeq	1
;buildings
;center_pyramid
	m_inertpath	0,0,0,0,pyramid0,e_buil_shadow_off
;hodoukyou
	m_inertpath	4150,-158,0,0,hasi0_1,e_building
	m_inertpath	4700,0,0,0,hasi0_2,e_buil_shadow_off
	m_inertpath	3600,0,0,0,hasi0_0,e_buil_shadow_off
;noreru_tunnel
	m_inertpath	-4400,-120,0,0,arch_0_1,e_building
	m_inertpath	-4520,0,0,0,arch_0_0,e_buil_shadow_off
	m_inertpath	-4280,0,0,0,arch_0_2,e_buil_shadow_off
;saka
	m_inertpath	0,0,-3400,0,saka_0_0,e_buil_shadow_off
	m_inertpath	0,-80,-3000,0,saka_0_1,e_building
	m_inertpath	0,0,-2600,0,saka_0_2,e_buil_shadow_off

	m_inertpath	0,0,02600,0,saka_0_0,e_buil_shadow_off
	m_inertpath	0,-80,03000,0,saka_0_1,e_building
	m_inertpath	0,0,03400,0,saka_0_2,e_buil_shadow_off

;switch_arch
	pathobj		0,-2000,0,-1000,arch_1_0,e_tunnel_0,2,2

	pathobj		0,2000,0,1000,arch_1_0,e_tunnel_0,2,2
;1p_2p_tower
	m_inertpath	-2000,00000,-5000,0,tou_0,e_buil_shadow_off

	m_inertpath	02000,00000,05000,0,tou_0,e_buil_shadow_off
;yajirobe-
;	m_inertpath	-4500,-195,-3500,0,yajiro_0,e_yajiro_0
	pathobj		0,-4500,-195,-3500,yajiro_0,e_yajiro_0,2,2
	m_inertpath	-4500,-080,-3500,0,yajiro_3,e_buil_shadow_off
;	m_inertpath	04500,-195,03500,0,yajiro_0,e_yajiro_0
	pathobj		0,04500,-195,03500,yajiro_0,e_yajiro_0,2,2
	m_inertpath	04500,-080,03500,0,yajiro_3,e_buil_shadow_off
;gate
	m_inertpath	00000,0,-5200,0,gate_0,e_gate_0

	m_inertpath	00000,0,05200,0,gate_0,e_gate_0
;--------------------------------------
;town
	m_inertpath	04100,0,-2700,0,build_2,e_buil_shadow_off
	m_inertpath	04700,0,-2700,0,build_2,e_buil_shadow_off
	m_inertpath	03800,0,-3000,0,build_2,e_buil_shadow_off
	m_inertpath	04700,0,-3000,0,build_3,e_buil_shadow_off
	m_inertpath	04100,0,-3000,0,build_3,e_buil_shadow_off
	m_inertpath	-1500,0,-4000,0,build_7,e_buil_shadow_off
	m_inertpath	-2500,0,-4000,0,build_7,e_buil_shadow_off

	m_inertpath	-4100,0,02700,0,build_2,e_buil_shadow_off
	m_inertpath	-4700,0,02700,0,build_2,e_buil_shadow_off
	m_inertpath	-3800,0,03000,0,build_2,e_buil_shadow_off
	m_inertpath	-4700,0,03000,0,build_3,e_buil_shadow_off
	m_inertpath	-4100,0,03000,0,build_3,e_buil_shadow_off
	m_inertpath	01500,0,04000,0,build_7,e_buil_shadow_off
	m_inertpath	02500,0,04000,0,build_7,e_buil_shadow_off
;dandan
	m_inertpath	3500,0,-4000,0,build_4,e_buil_shadow_off
	m_inertpath	3900,0,-4000,0,build_5,e_buil_shadow_off
	m_inertpath	4300,0,-4000,0,build_6,e_buil_shadow_off
	m_inertpath	4700,0,-4000,0,build_7,e_buil_shadow_off

	m_inertpath	-3500,0,04000,0,build_4,e_buil_shadow_off
	m_inertpath	-3900,0,04000,0,build_5,e_buil_shadow_off
	m_inertpath	-4300,0,04000,0,build_6,e_buil_shadow_off
	m_inertpath	-4700,0,04000,0,build_7,e_buil_shadow_off

;boards
;	m_inertpath	02000,0,-2750,0,ita_0,e_ita_m	
;	m_inertpath	02000,0,-3250,0,ita_0,e_ita_s	
	m_inertpath	-2000,0,-3250,0,ita_1,e_ita_m

;	m_inertpath	-2000,0,02750,0,ita_0,e_ita_m	
;	m_inertpath	-2000,0,03250,0,ita_0,e_ita_s
	m_inertpath	02000,0,03250,0,ita_1,e_ita_m
;-------------------------------
;pyontas
;center_pyon
	m_inertpath	00600,-250,-200,0,pyonta_t,e_pyonta_tl
	m_inertpath	-0600,-250,0200,0,pyonta_t,e_pyonta_tr
;yajiro_pyon
	m_inertpath	05000,-250,03500,0,pyonta_t,e_pyonta_tl
	m_inertpath	-5000,-250,-3500,0,pyonta_t,e_pyonta_tr
;tunnel_pyon
	m_inertpath	-4400,-80,0,0,pyonta_k,e_pyonta_kz
;hodou_pyon
	m_inertpath	04000,-280,0000,0,pyonta_k,e_pyonta_kx
;board_pyon
;	m_inertpath	02000,-80,-3000,0,pyonta,e_pyonta
	m_inertpath	-2000,-80,-3500,0,pyonta,e_pyonta

;	m_inertpath	-2000,-80,03000,0,pyonta,e_pyonta
	m_inertpath	02000,-80,03500,0,pyonta,e_pyonta

;kusha
	m_inertpath	02200,-150,-3500,0,kusha_1,e_kusha
	m_inertpath	02200,-150,-3500,0,kusha_1,e_kusha
;-------------------------------
;houdai
	m_inertpath	02000,-160,-1000,0,gun_0_0,e_player_hou
;	pathobj		0,02000,-160,-1000,gun_0_0,e_player_hou,1,1

	m_inertpath	-2000,-160,01000,0,gun_0_0,e_player_hou
;	pathobj		0,-2000,-160,01000,gun_0_0,e_player_hou,1,1

;-------------------------------
;panel,ring,target
;neta_set
  ;rings
;	pathobj		0,0,0,0,nullshape,e_ri_3of8,2,2
  ;panels
;	pathobj		0,0,0,0,nullshape,e_pn_3of8,2,2
  ;targets
;	pathobj		0,0,0,0,nullshape,e_ka_3of8,2,2

;pyramid_panel
	m_inertpath	00000,-0240,00000,0,noru_1,e_noru_small
;tunnel_panel
	m_inertpath	-4400,-0200,00000,0,noru_1,e_noru_small
;hodou_panel
	m_inertpath	04200,-0200,00000,0,noru_1,e_noru_small
;dandan_panel
	m_inertpath	04700,-0200,-4000,0,noru_1,e_noru_small
	m_inertpath	-4700,-0200,04000,0,noru_1,e_noru_small
;sakashita_panel
	m_inertpath	0000,0,03000,0,noru_1,e_noru_small
	m_inertpath	0000,0,-3000,0,noru_1,e_noru_small
;------------------------------

;lamps
	ifeq	1

lam_1	=		-4500
	rept		10
;tate_line
	m_inertpath	05000,0,lam_1,0,lamp_0,e_lamp_0
	m_inertpath	-5000,0,lam_1,0,lamp_0,e_lamp_0
;yoko_line
	m_inertpath	lam_1,0,-5000,0,lamp_0,e_lamp_0
	m_inertpath	lam_1,0,05000,0,lamp_0,e_lamp_0
lam_1	=	lam_1+1000
	endr

	endc
;------------------------------
;-------------------------------
	ifeq	1

;neta_order_list
	ols_positions	16		;1 or 2 or 4 or 8
	ols_pos		0,3000
	ols_pos		0,1500
	ols_pos		0,-1500
	ols_pos		0,-3000

	ols_pos		-4000,0
	ols_pos		4000,0
	ols_pos		-2500,1500
	ols_pos		2500,-1500

	ols_pos		-2500,-1500
	ols_pos		2500,1500
	ols_pos		-4000,3000
	ols_pos		4000,-3000

	ols_pos		-3000,-5000
	ols_pos		3000,5000
	ols_pos		-1500,-3000
	ols_pos		1500,3000

	rept		4
	ols_pathobj	noru_1,e_noru_small
	m_inertpath	ring_0,e_nocolobj
	endr

	endc
;-------------------------------


;	m_inertpath	0,0,3000,0,arizigok,ktest
;	m_inertpath	2000,-800,2000,0,daruma_2,ktest
;	m_inertpath	2000,-600,2000,0,daruma_0,ktest
;	m_inertpath	2000,-450,2000,0,daruma_0,ktest
;	m_inertpath	2000,-300,2000,0,daruma_0,ktest
;	m_inertpath	2000,-150,2000,0,daruma_0,ktest
;	m_inertpath	2000,0,2000,0,daruma_1,ktest
;
;	m_inertpath	-2000,-800,2000,0,daruma_2,ktest
;	m_inertpath	-2000,-600,2000,0,daruma_0,ktest
;	m_inertpath	-2000,-450,2000,0,daruma_0,ktest
;	m_inertpath	-2000,-300,2000,0,daruma_0,ktest
;	m_inertpath	-2000,-150,2000,0,daruma_0,ktest
;	m_inertpath	-2000,0,2000,0,daruma_1,ktest
;
;	m_inertpath	0,-800,-2000,0,daruma_2,ktest
;	m_inertpath	0,-600,-2000,0,daruma_0,ktest
;	m_inertpath	0,-450,-2000,0,daruma_0,ktest
;	m_inertpath	0,-300,-2000,0,daruma_0,ktest
;	m_inertpath	0,-150,-2000,0,daruma_0,ktest
;	mapobj		0,0,0,-2000,daruma_1,attack_target_istrat
;
;
	endc
;**** MAP SET END ****
	ENDC
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

