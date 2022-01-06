;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  senkan_course (space)  short type       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	initbg

	map_vscreensize_mission	4

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick


ext1_0
	setbg	missionextra1

	setvar.b	andorfdead,255

	map_vscreensize_mission	4

;-----------------------------------------
;**** MAP SET START ****
;----------------------------------------
;area_out_off
	map_mapareaout	off
;-----------------------------------------
;RASTER
	map_rasterON	boss_raster
;;dots_set
;	map_setdust	sprites,moving		
;	map_dustsprite	asteroid,16		;asteroid
;player_position
	map_playermode		space
	map_setplayerpos	1,0,-0200,0,0
	map_battlearea		-3500,3500,0,ground
	map_camerainit_1screen	0,100,30,-30,0
	map_arwinginit		-3500,3500,40,-40

;	map_playerturn		off,000H,0000,0000,500
	map_playerblockmap_off	1


	map_demomode	start_final

;-------------------------------------------------------------
;**** MAP SET AREA ****
;-------------------------------------------------------------
;;;;;;;;;;;;;map_area <NO=0-15>,X,Z,W,L,Lavel;;;;;;;;;;

;-----------------------------------------
;-----------------------------------------
	pathobj		0,0,0,3000,nullshape,boss_andorf,10,10


;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

