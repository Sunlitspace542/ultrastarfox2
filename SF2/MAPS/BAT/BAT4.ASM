;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  space2_battle (space)                   บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	setfadedown	quick
	mapwaitfade
	setbg	battlestage4
	initbg

	map_vscreensize_battle	4
;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,1

	setfadeup	quick

;-----------------------------------------
;;**** MAP SET START ****
;
;;players_position
;	map_setplayerpos	1,3000,0,-3000,deg45
;	map_setplayerpos	2,-3000,0,3000,deg180+deg45
;
;;ships
;	mapobj		0,0,0,0,ship_0,kturn360r_istrat
;	setalvar	rotx,deg45
;	setalvar	roty,deg45
;	setalvar	rotz,deg45
;	mapobj		0,2000,300,2000,ship_0,kturn360r_istrat
;	setalvar	rotx,deg45
;	setalvar	roty,-deg45
;	setalvar	rotz,deg45
;	mapobj		0,-2000,-300,-2000,ship_0,kturn360r_istrat
;	setalvar	rotx,-deg45
;	setalvar	roty,deg45
;	setalvar	rotz,deg45
;



;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

