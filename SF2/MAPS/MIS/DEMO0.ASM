;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  senkan_zaco   (space)  short type       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	titledemo
	initbg
	map_vscreensize_mission		4

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,3

	setfadeup	quick

;dots_set
	map_setdust	coloured,moving	;asteroid&dots	
	map_dustkazu	64


;	map_demomode	destruct_enemy
	map_demomode	title

.self	mapwait	5000
	mapgoto	.self
