;	ษออออออออออออออออออออออป
;	บ  TAIMAN hassin DEMO  บ
;	ศออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	sun	;startenemydemo
	initbg

	map_rasterON	fire_raster

	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,3

	setfadeup	quick

	pathobj		0,0,0,0,nullshape,e_andross_msg1,10,10

	map_setdust	coloured,moving	;asteroid&dots	

	map_dustkazu	32

	map_demomode	taiman

