;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  SOS_MISSILE   (space) center_set type   บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	missionsos2
	initbg

	map_vscreensize_mission	4

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

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
;;radar
;	setvar.w	kx_radarscale,1
;
;dots_set
	map_setdust	sprites,moving		
	map_dustsprite	asteroid,16		;asteroid
	map_dustkazu	64
	map_ifasteroids	.nostars
	map_setdust	sprites,mixed,moving	;asteroid&dots	
	map_dustsprite	asteroid,16		;asteroid
	map_dustkazu	32
.nostars
;;player
;	km_mapareaout	off

;;;;;	map_setplayerpos	1,0000,0000,-5000,0
	map_setplayerpos_relative
	map_playermode		space
	map_battlearea		-3500,3500,0,ground
	map_camerainit_1screen	0,100,30,-30,0
	map_arwinginit		-3500,3500,40,-40

;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_space,10,10
;message_set
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0

	map_playerblockmap_off	1	;area out off


;--------STEP SET TEST----------------

;-------------------------------------------------------------
;**** MAP STEPSET AREA ****
;-------------------------------------------------------------
;star_wolf
	mapgotoiflevel	11,stepsos2_a
	mapgotoiflevel	12,stepsos2_b
;
	map_demomode	attack
;missiles
	mapgotoiflevel	1,stepsos2_0
	mapgotoiflevel	2,stepsos2_1
	mapgotoiflevel	3,stepsos2_2
	mapgotoiflevel	4,stepsos2_3
	mapgotoiflevel	5,stepsos2_4
	mapgotoiflevel	6,stepsos2_5
	mapgotoiflevel	7,stepsos2_6
	mapgotoiflevel	8,stepsos2_7
;virus & eisei
	mapgotoiflevel	9,stepsos2_8
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_0
;dandou=1
	pathobj		0,000,00,000,dandou,e_sos_dandou,0,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_1
;dandou=2
	pathobj		0,0000,00000,00000,dandou,e_sos_dandou,0,10
	pathobj		0,-2500,-1500,-3000,dandou,e_sos_dandou,1,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_2
;miss2_1=2
	pathobj		0,0000,000,0000,miss2_1,e_sos_baramiss_2,0,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_3
;dandou=3
	pathobj		0,00000,0000,0000,dandou,e_sos_dandou,0,10
	pathobj		0,1000,0800,-2000,dandou,e_sos_dandou,1,10
	pathobj		0,02000,1400,2500,dandou,e_sos_dandou,2,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_4
;miss2_1=4
	pathobj		0,0000,00,0000,miss2_1,e_sos_baramiss,0,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_5
;tate_miss=1
	pathobj		0,0000,00,00000,tate_m_0,e_tate_missile,10,0
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_6
;miss2_1=4,dandou=2
	pathobj		0,-0500,-1400,0000,miss2_1,e_sos_baramiss,0,-25
	pathobj		0,01700,0000,-1500,dandou,e_sos_dandou,8,-35
	pathobj		0,-1500,1400,-3000,dandou,e_sos_dandou,9,-30
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_7
;enban_missils=1
	pathobj		0,0000,400,00000,enban_1,e_gattai_enban,10,0
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos2_8
	mapgotoifsatellite	stepsos2_9
;virus
	pathobj		0,0000,00,3000,virus_big,e_fly_hacker,10,0
	pathobj		0,3500,-1800,000,virus_big,e_fly_hacker,10,1
	pathobj		0,-2500,1200,-2000,virus_big,e_fly_hacker,10,2
	map_endarea
;-------------------------------------------------------------
stepsos2_9
;eisei_cannon
	pathobj		0,0000,00,00000,system_3,e_eisei_cannon,3,10
;medal_$19
	m_inertpath	700,-1200,-700,$19,medal,e_omake_medal
	map_endarea
;-------------------------------------------------------------
stepsos2_a
;star_wolf_easy
	map_demomode	starwolf	;attack
	pathobj		0,0000,00,00000,wolf_1_eg,e_star_wolf,10,10
	map_endarea
;-------------------------------------------------------------
stepsos2_b
;star_wolf_strong
	map_demomode	starwolf	;attack
	pathobj		0,0000,00,00000,wolf_eg,e_star_wolf,10,10
	map_endarea
;-------------------------------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp



;-----------------------------------------
;	pathobj		0,100,200,200,ray_0,ytest_path,0,10
;	pathobj		0,-400,-300,500,ray_0,ytest_path,20,10
;	pathobj		0,-200,-800,2000,ray_0,ytest_path,-30,10
;	pathobj		0,500,800,1000,ray_0,ytest_path,-30,10
;	pathobj		0,00000,0400,03000,training,e_nocol_s_off,10,0
;	pathobj		0,02000,000,04000,training,e_nocol_s_off,10,0
;	pathobj		0,-1000,-400,05000,training,e_nocol_s_off,10,0
;	pathobj		0,-2000,-800,07000,training,e_nocol_s_off,10,0
;	pathobj		0,-3000,1400,09000,training,e_nocol_s_off,10,0
;	pathobj		0,-3000,1400,09500,training,e_nocol_s_off,10,0
;	pathobj		0,-3000,1400,01000,training,e_nocol_s_off,10,0
