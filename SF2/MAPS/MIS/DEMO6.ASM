;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  senkan_zaco   (space)  short type       บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	titledemo
	initbg

	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,3

	setfadeup	quick

	map_setdust	coloured,moving	;asteroid&dots	
	map_dustkazu	32

	map_demomode	credits

;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

