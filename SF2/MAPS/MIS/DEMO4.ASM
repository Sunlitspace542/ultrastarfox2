;ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
;Ί  senkan_zaco   (space)  short type       Ί
;ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
	setfadedown	quick
	mapwaitfade
	setbg	attackcorneriademo
	initbg

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,3

	setfadeup	quick

	map_setdust	coloured,moving	;asteroid&dots	
	map_dustkazu	32

	map_demomode	destruct_enemy

