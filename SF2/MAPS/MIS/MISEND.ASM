;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  	Title Map                      บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	missiongameover
	initbg

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,10
	setfadeup	quick

	map_setdust	coloured,moving	;asteroid&dots	
	map_dustkazu	32

	pathobj	0000,0,1000,3000,zaco_2,kroty,2,2

;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

