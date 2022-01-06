;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  SOS_ZACO   (space)  center_set type     บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	missionsos1
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
;dots_set
	map_setdust	sprites,moving		
	map_dustsprite	asteroid,16		;asteroid only
	map_dustkazu	64
	map_ifasteroids	.nostars
	map_setdust	sprites,mixed,moving	;asteroid&dots	
	map_dustsprite	asteroid,16		;asteroid
	map_dustkazu	32
.nostars
;player
	map_setplayerpos_relative
;;;;;	map_setplayerpos	1,8000,0000,-8000,0
	map_playermode		space
	map_battlearea		-3500,3500,0,ground
	map_camerainit_1screen	0,100,30,-30,0
	map_arwinginit		-3500,3500,40,-40

	map_demomode	attack

;enemy_count
	pathobj		0,0,0,0,nullshape,e_checker_space,10,10
;message_set
	pathobj		0,0,0,0,stg_checker,e_game_maker_space,100,0

;--------STEP SET TEST----------------
	map_playerblockmap_off	1	;area out off

;-------------------------------------------------------------
;**** MAP STEPSET AREA ****
;-------------------------------------------------------------
	mapgotoiflevel	1,stepsos1_0	;e
	mapgotoiflevel	2,stepsos1_1	;e
	mapgotoiflevel	3,stepsos1_2	;e
	mapgotoiflevel	4,stepsos1_3	;e
	mapgotoiflevel	5,stepsos1_4	;e
	mapgotoiflevel	6,stepsos1_5	;e
	mapgotoiflevel	7,stepsos1_6	;e_n
	mapgotoiflevel	8,stepsos1_7	;e_n
;
	mapgotoiflevel	9,stepsos1_8	;e_n
	mapgotoiflevel	10,stepsos1_9	;e_n
	mapgotoiflevel	11,stepsos1_a	;e_n
	mapgotoiflevel	12,stepsos1_b	;e_n
	mapgotoiflevel	13,stepsos1_c	;e_n_h
	mapgotoiflevel	14,stepsos1_d	;e_n_h
	mapgotoiflevel	15,stepsos1_e	;e_n_h
	mapgotoiflevel	16,stepsos1_f	;e_n_h
;
	mapgotoiflevel	17,stepsos1_10	;n_h
	mapgotoiflevel	18,stepsos1_11	;n_h
	mapgotoiflevel	19,stepsos1_12	;n_h
	mapgotoiflevel	20,stepsos1_13	;n_h
	mapgotoiflevel	21,stepsos1_14	;n_h
	mapgotoiflevel	22,stepsos1_15	;h
	mapgotoiflevel	23,stepsos1_16	;h
	mapgotoiflevel	24,stepsos1_17	;h
;
	mapgotoiflevel	25,stepsos1_18	;h
	mapgotoiflevel	26,stepsos1_19	;h
	mapgotoiflevel	27,stepsos1_1a	;h
	mapgotoiflevel	28,stepsos1_1b	;h
	mapgotoiflevel	29,stepsos1_1c	;taiman
	mapgotoiflevel	30,stepsos1_1d	;taiman
	mapgotoiflevel	31,stepsos1_1e	;taiman
	mapgotoiflevel	32,stepsos1_1f	;taiman
;
	map_endarea
;-------------------------------------------------------------
;EASY_LEVEL(0-Fh)
;-------------------------------------------------------------
stepsos1_0	;EASY
;sos_0=3
	pathobj		0,000,0000,0000,sos_0,e_sos_hentai_1,$02,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1	;EASY
;taigun=3
	pathobj		0,01500,-600,2500,taigun,e_sos_hentai_1c_mustwork,$01,10
	pathobj		0,0000,0000,-1500,taigun,e_sos_hentai_1c_mustwork,$11,10
	pathobj		0,-1200,600,1500,taigun,e_sos_hentai_1c_mustwork,$21,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_2	;EASY
;jyouge=3
	pathobj		0,00000,0000,0000,jyouge,e_sos_jyouge_mustwork,10,$01
	pathobj		0,-2000,2000,-3000,jyouge,e_sos_jyouge_mustwork,10,$11
	pathobj		0,2000,-1000,03000,jyouge,e_sos_jyouge_mustwork,10,$21
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_3	;EASY
;speed_s=3
	pathobj		0,02000,-200,1500,speed_s,e_jyairo_hentai_1c_mustwork,$01,10
	pathobj		0,00000,0300,-1500,speed_s,e_jyairo_hentai_1c_mustwork,$11,10
	pathobj		0,-2000,-400,1500,speed_s,e_jyairo_hentai_1c_mustwork,$21,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_4	;EASY
;sos_1=1,sos_0=2
	pathobj		0,000,0000,00000,sos_1,e_sos_new_strong1,0,10
	pathobj		0,2500,0500,-3500,sos_0,e_sos_hentai_1c_mustwork,$81,10
	pathobj		0,-2500,0500,-3500,sos_0,e_sos_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_5	;EASY
;jyouge=1,taigun=3
	pathobj		0,000,1000,-2500,jyouge,e_sos_jyouge_mustwork,10,$01
	pathobj		0,000,000,1000,taigun,e_sos_hentai_1,$82,10
	map_endarea
;-------------------------------------------------------------
;NORMAL_LEVEL(6-15h)
;-------------------------------------------------------------
stepsos1_6	;EASY_NORMAL
;sos_0=4
	pathobj		0,000,0000,000,sos_0,e_sos_hentai_1,$02,10
	pathobj		0,000,800,4000,sos_0,e_sos_hentai_1c_mustwork,$31,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_7	;EASY_NORMAL
;taigun=4
	pathobj		0,000,000,000,taigun,e_sos_hentai_1,$02,10
	pathobj		0,000,-600,4000,taigun,e_sos_hentai_1c_mustwork,$31,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_8	;EASY_NORMAL
;jyouge=1,speed_s=2
	pathobj		0,0000,600,2800,jyouge,e_sos_jyouge_mustwork,10,$01
	pathobj		0,-2500,01500,000,speed_s,e_jyairo_hentai_1c_mustwork,$81,10
	pathobj		0,2000,-0600,-2800,speed_s,e_jyairo_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_9	;EASY_NORMAL
;jyouge_1=1,sos_0=3
	pathobj		0,0000,-1000,2500,jyouge,e_sos_jyouge_mustwork,10,$01
	pathobj		0,000,0000,-500,sos_0,e_sos_hentai_1,$82,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_a	;EASY_NORMAL	10
;speed_s=1,sos_0=2
	pathobj		0,0000,01500,2500,speed_s,e_jyairo_hentai_1c_mustwork,$01,10
	pathobj		0,2000,-1000,-2000,sos_0,e_sos_hentai_1c_mustwork,$81,10
	pathobj		0,-2000,0000,-2000,sos_0,e_sos_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_b	;EASY_NORMAL	11
;sos_0=2,taigun=2
	pathobj		0,000,-1500,2500,sos_0,e_sos_hentai_1c_mustwork,$01,10
	pathobj		0,000,1500,-2500,sos_0,e_sos_hentai_1c_mustwork,$11,10
	pathobj		0,2500,-800,0000,taigun,e_sos_hentai_1c_mustwork,$81,10
	pathobj		0,-2500,800,0000,taigun,e_sos_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;HARD_LEVEL(1ch-1bh)
;-------------------------------------------------------------
stepsos1_c	;EASY_NORMAL	12
	map_dustkazu	16
;sos_0=5
	pathobj		0,000,000,2000,sos_0,e_sos_hentai_1,$04,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_d	;EASY_NORMAL	13
;taigun=5
	pathobj		0,-1000,-1800,04000,taigun,e_sos_hentai_1c_mustwork,$01,10
	pathobj		0,1800,-1000,02000,taigun,e_sos_hentai_1c_mustwork,$11,10
	pathobj		0,0000,0000,00000,taigun,e_sos_hentai_1c_mustwork,$21,10
	pathobj		0,-1800,1000,-2000,taigun,e_sos_hentai_1c_mustwork,$31,10
	pathobj		0,1000,1800,-4000,taigun,e_sos_hentai_1c_mustwork,$41,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_e	;EASY_NORMAL	14
;sos_1=1,taigun=3
	pathobj		0,000,0000,1500,sos_1,e_sos_new_strong1,0,10
	pathobj		0,000,-1000,-3000,taigun,e_sos_hentai_1,$82,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_f	;EASY_NORMAL	15
;jyouge=2,taigun=2
	pathobj		0,2500,600,500,jyouge,e_sos_jyouge_mustwork,10,$01
	pathobj		0,-2500,-600,-500,jyouge,e_sos_jyouge_mustwork,10,$11
	pathobj		0,0500,-1400,2500,taigun,e_sos_hentai_1c_mustwork,$81,10
	pathobj		0,-500,1400,-2500,taigun,e_sos_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_10	;NORMAL_HARD	16
;enkin=4
	pathobj		0,2500,-1200,2500,enkin,e_sos_enkin_mustwork,10,$01
	pathobj		0,-1000,1200,0000,enkin,e_sos_enkin_mustwork,10,$11
	pathobj		0,1000,700,-1500,enkin,e_sos_enkin_mustwork,10,$21
	pathobj		0,-2500,000,-2500,enkin,e_sos_enkin_mustwork,10,$31
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_11	;NORMAL_HARD	17
;sos_0=3,enkin=2
	pathobj		0,000,0000,1500,sos_0,e_sos_hentai_1,$02,10
	pathobj		0,3000,700,-3000,enkin,e_sos_enkin_mustwork,10,$81
	pathobj		0,-3000,-700,-3000,enkin,e_sos_enkin_mustwork,10,$91
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_12	;NORMAL_HARD	18
;BAKUGEKI=1,sos_0=2
	pathobj		0,0000,0000,1500,nullshape,e_space_bakugeki,0,4
	pathobj		0,2500,-1000,-2500,sos_0,e_sos_hentai_1c_mustwork,$81,10
	pathobj		0,-2500,0000,-2500,sos_0,e_sos_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_13	;NORMAL_HARD	19
;sos_1=1,speed_s=2
	pathobj		0,000,0000,2500,sos_1,e_sos_new_strong1,0,10
	pathobj		0,-3000,01500,-1500,speed_s,e_jyairo_hentai_1c_mustwork,$81,10
	pathobj		0,2800,-0600,-2500,speed_s,e_jyairo_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_14	;NORMAL_HARD	20
;sos_2=1,kieru=2
	pathobj		0,000,0000,0000,sos_2,e_sos_new_strong2,0,2
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_15	;NORMAL_HARD	21
;sos_2,kieru=3
	pathobj		0,000,0000,00000,sos_2,e_sos_new_strong2,0,4
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_16	;HARD		22
;jyouge=2,speed_s=2
	pathobj		0,3500,600,500,jyouge,e_sos_jyouge_mustwork,10,$01
	pathobj		0,-3500,-600,-500,jyouge,e_sos_jyouge_mustwork,10,$11
	pathobj		0,-500,01500,3000,speed_s,e_jyairo_hentai_1c_mustwork,$81,10
	pathobj		0,0500,-1500,-3000,speed_s,e_jyairo_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_17	;HARD		23
;BAKUGEKI=1,taigun=2
	pathobj		0,0000,0000,1000,nullshape,e_space_bakugeki,0,4
	pathobj		0,3000,-400,-4000,taigun,e_sos_hentai_1c_mustwork,$81,10
	pathobj		0,-3000,-400,-4000,taigun,e_sos_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;
;-------------------------------------------------------------
stepsos1_18	;HARD		24
;kuru1_u=1,kuru0_u=2
	pathobj		0,0000,-200,0000,kuru1_u,e_kamereon_core,$02,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_19	;HARD		25
;kuru1_u=1,kuru0_u=4
	pathobj		0,0000,-200,0000,kuru1_u,e_kamereon_core,$04,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1a	;HARD		26
;jyouge_1=1,enkin=3
	pathobj		0,000,0000,-1000,jyouge_1,e_sos_new_strong3,0,10
	pathobj		0,500,-800,2500,enkin,e_sos_enkin_mustwork,10,$81
	pathobj		0,-3500,800,-4000,enkin,e_sos_enkin_mustwork,10,$91
	pathobj		0,3500,1800,-4000,enkin,e_sos_enkin_mustwork,10,$a1
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1b	;HARD		27
;jyouge_1=1,enkin=2
	pathobj		0,000,0000,3000,jyouge_1,e_sos_new_strong3,0,10
	pathobj		0,2500,01000,-1500,speed_s,e_jyairo_hentai_1c_mustwork,$81,10
	pathobj		0,-3000,-1200,-2500,speed_s,e_jyairo_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;
;	TAIMAN_KUN
;
;-------------------------------------------------------------
stepsos1_1c	;HARD	28
;HEBI=1
	pathobj		0,0000,0000,0000,dragon_0,superdragon,16,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1d	;HARD	29
;hydra=1
	pathobj		0,0000,0000,0000,stepup_0,e_step_hydra,0,4
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1e	;HARD	30
;NINJA=1
	pathobj		0,0000,0000,0000,ninja,e_space_ninja,0,4
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1f	;HARD	31
;shielder=1
	pathobj		0,0000,00,0000,nullshape,BOSS_Crusher,10,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;------------------------------
;**** MAP SET END ****
;-----------------------------------------

.lp	mapwait	5000
	mapgoto	.lp



	ifeq	1
;-------------------------------------------------------------
;EASY_LEVEL(0-Fh)
;-------------------------------------------------------------
stepsos1_0	;EASY
;sos_0=3
	pathobj		0,000,0000,0000,sos_0,e_sos_hentai_1,$02,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1	;EASY
;taigun=3
	pathobj		0,01500,-600,2500,taigun,e_sos_hentai_1c_mustwork,$01,10
	pathobj		0,0000,0000,-1500,taigun,e_sos_hentai_1c_mustwork,$11,10
	pathobj		0,-1200,600,1500,taigun,e_sos_hentai_1c_mustwork,$21,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_2	;EASY
;speed_s=3
	pathobj		0,02000,-200,1000,speed_s,e_jyairo_hentai_1c_mustwork,$01,10
	pathobj		0,00000,0300,-1000,speed_s,e_jyairo_hentai_1c_mustwork,$11,10
	pathobj		0,-2000,-400,1000,speed_s,e_jyairo_hentai_1c_mustwork,$21,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_3	;EASY
;sos_0=3
	pathobj		0,000,-1000,2000,sos_0,e_sos_hentai_1c_mustwork,$01,10
	pathobj		0,1000,0000,0000,sos_0,e_sos_hentai_1c_mustwork,$11,10
	pathobj		0,-1500,1000,-2000,sos_0,e_sos_hentai_1c_mustwork,$21,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_4	;EASY
;sos_1=1,sos_0=2
	pathobj		0,000,0000,00000,sos_1,e_sos_new_strong1,0,10
	pathobj		0,2000,0500,-2500,sos_0,e_sos_hentai_1c_mustwork,$81,10
	pathobj		0,-2000,0500,-2500,sos_0,e_sos_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_5	;EASY
;enkin=3
	pathobj		0,2500,-1200,2500,enkin,e_sos_enkin_mustwork,10,$01
	pathobj		0,0000,1200,0000,enkin,e_sos_enkin_mustwork,10,$11
	pathobj		0,1000,700,-1500,enkin,e_sos_enkin_mustwork,10,$21
	map_endarea
;-------------------------------------------------------------
;NORMAL_LEVEL(6-15h)
;-------------------------------------------------------------
stepsos1_6	;EASY_NORMAL
;jyouge=2
	pathobj		0,00000,0000,0000,jyouge,e_sos_jyouge_mustwork,10,$01
	pathobj		0,-2000,2000,-3000,jyouge,e_sos_jyouge_mustwork,10,$11
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_7	;EASY_NORMAL
;sos_2=1,kieru=2
	pathobj		0,000,0000,0000,sos_2,e_sos_new_strong2,0,2
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_8	;EASY_NORMAL
;speed_s=3
	pathobj		0,0000,000,000,speed_s,e_jyairo_hentai_1,$02,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_9	;EASY_NORMAL
;jyouge_1=1,enkin=2
	pathobj		0,000,0000,0000,jyouge_1,e_sos_new_strong3,0,10
	pathobj		0,1500,-800,3500,enkin,e_sos_enkin_mustwork,10,$81
	pathobj		0,-1500,800,-3500,enkin,e_sos_enkin_mustwork,10,$91
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_a	;EASY_NORMAL	10
;sos_0=4
	pathobj		0,000,0000,000,sos_0,e_sos_hentai_1,$02,10
	pathobj		0,000,800,4000,sos_0,e_sos_hentai_1c_mustwork,$31,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_b	;EASY_NORMAL	11
;BAKUGEKI=1
	pathobj		0,0000,0000,0000,nullshape,e_space_bakugeki,0,4
	map_endarea
;-------------------------------------------------------------
;HARD_LEVEL(1ch-1bh)
;-------------------------------------------------------------
stepsos1_c	;EASY_NORMAL	12
;speed_s=2,jyouge=1
	pathobj		0,000,00600,02500,speed_s,e_jyairo_hentai_1c_mustwork,$01,10
	pathobj		0,1000,-0600,-2500,speed_s,e_jyairo_hentai_1c_mustwork,$11,10
	pathobj		0,-1000,00,00,jyouge,e_sos_jyouge_mustwork,10,$81
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_d	;EASY_NORMAL	13
;sos_0=3,enkin=1
	pathobj		0,000,0000,0000,sos_0,e_sos_hentai_1,$02,10
	pathobj		0,0000,1000,-3000,enkin,e_sos_enkin_mustwork,10,$81
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_e	;EASY_NORMAL	14
;speed_s=2,taigun=2
	pathobj		0,-2000,0000,0000,speed_s,e_jyairo_hentai_1c_mustwork,$01,10
	pathobj		0,-1000,-1000,-1500,speed_s,e_jyairo_hentai_1c_mustwork,$11,10
	pathobj		0,2000,-2000,-3000,taigun,e_sos_hentai_1c_mustwork,$81,10
	pathobj		0,-1000,1000,1500,taigun,e_sos_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_f	;EASY_NORMAL	15
;sos_1=1,taigun=3
	pathobj		0,000,0000,1000,sos_1,e_sos_new_strong1,0,10
	pathobj		0,000,-1000,-3000,taigun,e_sos_hentai_1,$82,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_10	;NORMAL_HARD	16
	map_dustkazu	16
;sos_0=5
	pathobj		0,000,000,000,sos_0,e_sos_hentai_1,$04,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_11	;NORMAL_HARD	17
;sos_0=3,jyouge_1=1
	pathobj		0,000,0000,0000,sos_0,e_sos_hentai_1,$02,10
	pathobj		0,0000,1000,-3000,jyouge_1,e_sos_new_strong3,8,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_12	;NORMAL_HARD	18
;sos_2=1,kieru=3
	pathobj		0,000,0000,0000,sos_2,e_sos_new_strong2,0,3
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_13	;NORMAL_HARD	19
;jyouge_1=1,speed_s=2
	pathobj		0,0000,0000,0000,jyouge_1,e_sos_new_strong3,0,10
	pathobj		0,-3000,-500,-3000,speed_s,e_jyairo_hentai_1c_mustwork,$81,10
	pathobj		0,03000,-500,-3000,speed_s,e_jyairo_hentai_1c_mustwork,$91,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_14	;NORMAL_HARD	20
;kamereon_big,kururin0=3
	pathobj		0,0000,-200,0000,kuru1_u,e_kamereon_core,$02,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_15	;NORMAL_HARD	21
;taigun=3,jyouge=1
	pathobj		0,000,000,000,taigun,e_sos_hentai_1,$02,10
	pathobj		0,000,1000,-2500,jyouge,e_sos_jyouge_mustwork,10,$81
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_16	;HARD		22
;speed_s=1,jyouge=2
	pathobj		0,00000,0000,0000,speed_s,e_jyairo_hentai_1c_mustwork,$01,10
	pathobj		0,-2500,1000,-3000,jyouge,e_sos_jyouge_mustwork,10,$81
	pathobj		0,2500,1000,-3000,jyouge,e_sos_jyouge_mustwork,10,$91
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_17	;HARD		23
;enkin=5
	pathobj		0,3600,-800,0000,enkin,e_sos_enkin_mustwork,10,$01
	pathobj		0,1800,400,2000,enkin,e_sos_enkin_mustwork,10,$11
	pathobj		0,00000,000,-2000,enkin,e_sos_enkin,10,$21
	pathobj		0,-1800,400,2000,enkin,e_sos_enkin_mustwork,10,$31
	pathobj		0,-3600,800,0000,enkin,e_sos_enkin_mustwork,10,$41
	map_endarea
;-------------------------------------------------------------
;
;-------------------------------------------------------------
stepsos1_18	;HARD		24
;BAKUGEKI=1,taigun=2
	pathobj		0,0000,0000,1000,nullshape,e_space_bakugeki,0,4
	pathobj		0,3000,-400,-4000,taigun,e_sos_hentai_1c_mustwork,$91,10
	pathobj		0,-3000,-400,-4000,taigun,e_sos_hentai_1c_mustwork,$a1,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_19	;HARD		25
;kamereon_big,kururin0=5
	pathobj		0,0000,-200,0000,kuru1_u,e_kamereon_core,$04,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1a	;HARD		26
;taigun=5
	pathobj		0,-1000,-800,04000,taigun,e_sos_hentai_1c_mustwork,$01,10
	pathobj		0,1800,-400,02000,taigun,e_sos_hentai_1c_mustwork,$11,10
	pathobj		0,0000,0000,00000,taigun,e_sos_hentai_1c_mustwork,$21,10
	pathobj		0,-1800,0400,-2000,taigun,e_sos_hentai_1c_mustwork,$31,10
	pathobj		0,1000,0800,-4000,taigun,e_sos_hentai_1c_mustwork,$41,10
	map_endarea
;-------------------------------------------------------------
;-------------------------------------------------------------
stepsos1_1b	;HARD		27
;sos_2,kieru=3
	pathobj		0,000,0000,00000,sos_2,e_sos_new_strong2,0,4
	map_endarea
;-------------------------------------------------------------


	endc
