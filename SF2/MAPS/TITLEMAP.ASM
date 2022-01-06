;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  	Title Map                      บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
;	setbg	missionsos1	;title
	setbg	title
	initbg

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,10

	map_setdust	coloured,moving	;asteroid&dots	
	map_dustkazu	32

	setfadeup	quick

;dummy
;	pathobj	0000,0,0,30000,tekikan,kroty,2,2

	map_demomode	logo

;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

