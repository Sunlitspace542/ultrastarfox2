;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  sea_battle    (sea)                     บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	battlestage5
	initbg

	map_vscreensize_battle	2

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

	map_seadepth		1000

;-----------------------------------------
;**** MAP SET START ****
;players_position
	map_setplayerpos	1,300,-1100,-3000,0
	map_setplayerpos	2,-300,-1100,-3000,0

;ships
	pathobj		0,500,0,0,ship_0,ktest,0,0
	pathobj		0,-500,-1000,0,ship_0,ktest,0,0
	mapobj		0,0,-400,5000,ship_0,kturn360r_istrat
	pathobj		0,0,-500,3000,ship_0,ktest,0,0




;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

