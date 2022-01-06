;ษออออออออออออออออออออออออออออออออออออออออออป
;บ  training_sea_map                        บ
;ศออออออออออออออออออออออออออออออออออออออออออผ
	IFEQ	1

	setfadedown	quick
	mapwaitfade
	setbg	training
	initbg

;	m_range	8192
	m_scale	1

	mapcode_jsl	initblack_l
	setvar		stayblack,10

	setfadeup	quick

;-----------------------------------------
;**** MAP SET START ****
;-------------------------------
;players_position
	map_setplayerpos	1,0,-1150,-4500,0
;-------------------------------
;ships
	m_inertpath	0,-200,2000,0,ship_0,e_building
	m_inertpath	-2000,-200,2000,0,ship_0,e_building
	m_inertpath	-2000,-200,-2000,0,ship_0,e_building
;-------------------------------
;rings
	ifeq	0

	ols_positions	8		;1 or 2 or 4 or 8
	ols_pos		00000,-200,-1500
	ols_pos		00000,-200,01000
	ols_pos		-2500,-200,03000
	ols_pos		02500,-200,03000

	ols_pos		03500,-200,00000
	ols_pos		-3500,-200,00000
	ols_pos		00000,-200,03500
	ols_pos		00000,-200,-3500

	rept		5
	ols_pathobj	training,kring
	endr

	endc
;-------------------------------
;posters
	ifeq	0

	ols_positions	8		;1 or 2 or 4 or 8
	ols_pos		-4800,0,4800
	ols_pos		0,0,5000
	ols_pos		0,0,3000
	ols_pos		0,0,500

	ols_pos		04000,0,03000
	ols_pos		04000,0,-1500
	ols_pos		-4000,0,-3000
	ols_pos		03000,0,-4000

	rept		5
	ols_pathobj	kakashi,e_building
	endr

	endc
;-------------------------------
;panels
	ifeq	1

	ols_positions	8		;1 or 2 or 4 or 8
	ols_pos		00200,0,01500
	ols_pos		-3000,0,00500
	ols_pos		00000,0,00000
	ols_pos		-3500,0,02000

	ols_pos		-4000,0,04000
	ols_pos		04000,0,04000
	ols_pos		04000,0,-4000
	ols_pos		-4000,0,-4000

	rept		5
	ols_pathobj	noru_dai,e_noru_dai_0
	endr

	endc
;-------------------------------
;targets
	ifeq	1

	ols_positions	8		;1 or 2 or 4 or 8
	ols_pos		-4000,0,02800
	ols_pos		-4500,0,-3200
	ols_pos		00000,0,04500
	ols_pos		00300,0,00100

	ols_pos		02500,0,-4000
	ols_pos		04000,0,04000
	ols_pos		02000,0,02000
	ols_pos		00000,0,-5000

	rept		5
	ols_pathobj	pyonta,e_building
	endr

	endc
;-------------------------------------------------

;ex

	ifeq	1

	map_setplayerpos	1,X,Y,Z,deg180		;1 or 2

	m_inertobj	X,Y,Z,YROT,SHAPE,_ISTRAT
	m_inertpath	X,Y,Z,YROT,SHAPE,PATH
	mapobj		0,X,Y,Z,SHAPE,_ISTRAT
	pathobj		0,X,Y,Z,SHAPE,PATH,HP,AP
	setalver	rotx,deg90	;rotx,roty,rotz

	ols_positions	1		;1 or 2 or 4 or 8
	ols_pos		X,Z
	ols_object	SHAPE,_ISTRAT
	ols_pathobj	SHAPE,PATH

	ols_linkstart
	,,,,,
	ols_linkend

loop
	mapgoto		.loop

lineZ	=		3000
	rept		5
	m_inertobj	100,0,lineZ,line_shape,path
lineZ	=		lineZ+1000
	endr

	mapend


	endc




;**** MAP SET END ****
;-----------------------------------------
.lp	mapwait	5000
	mapgoto	.lp

	ENDC
