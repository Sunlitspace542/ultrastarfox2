;=====================================================================
;*		Radar Map Character No				*
;=====================================================================
;;;sprrdmap_saku		equ	$2f
sprrdmap_saku_kado		equ	$a0+$1b
sprrdmap_saku_yoko		equ	$a0+$1c
sprrdmap_saku_tate		equ	$a0+$1d

enemytotal_battlestage1	equ	1
;--------------------------
radarmaptbl
;=====================================================================
;*			Battle Stage 1				*
;=====================================================================
	km_rdmapstart	battlestage1
;* migi tate (shita) >>> (ue) *
	km_rdmap	4*1024,-4*1024,saku_kado,obj_xyflip_h
	km_rdmap	4*1024,-3*1024,saku_tate,obj_xflip_h
	km_rdmap	4*1024,-2*1024,saku_tate,obj_xflip_h
	km_rdmap	4*1024,-1*1024,saku_tate,obj_xflip_h
	km_rdmap	4*1024,0000000,saku_tate,obj_xflip_h
	km_rdmap	4*1024,01*1024,saku_tate,obj_xflip_h
	km_rdmap	4*1024,02*1024,saku_tate,obj_xflip_h
	km_rdmap	4*1024,03*1024,saku_tate,obj_xflip_h
	km_rdmap	4*1024,04*1024,saku_kado,obj_xflip_h

;* hidari tate (shita) >>> (ue) *
	km_rdmap	-4*1024,-4*1024,saku_kado,obj_yflip_h
	km_rdmap	-4*1024,-3*1024,saku_tate
	km_rdmap	-4*1024,-2*1024,saku_tate
	km_rdmap	-4*1024,-1*1024,saku_tate
	km_rdmap	-4*1024,0000000,saku_tate
	km_rdmap	-4*1024,01*1024,saku_tate
	km_rdmap	-4*1024,02*1024,saku_tate
	km_rdmap	-4*1024,03*1024,saku_tate
	km_rdmap	-4*1024,04*1024,saku_kado

;* ue yoko (hidari) >>> (migi) *
	km_rdmap	-3*1024,04*1024,saku_yoko
	km_rdmap	-2*1024,04*1024,saku_yoko
	km_rdmap	-1*1024,04*1024,saku_yoko
	km_rdmap	0000000,04*1024,saku_yoko
	km_rdmap	01*1024,04*1024,saku_yoko
	km_rdmap	02*1024,04*1024,saku_yoko
	km_rdmap	03*1024,04*1024,saku_yoko

;* shita yoko (hidari) >>> (migi) *
	km_rdmap	-3*1024,-4*1024,saku_yoko,obj_yflip_h
	km_rdmap	-2*1024,-4*1024,saku_yoko,obj_yflip_h
	km_rdmap	-1*1024,-4*1024,saku_yoko,obj_yflip_h
	km_rdmap	0000000,-4*1024,saku_yoko,obj_yflip_h
	km_rdmap	01*1024,-4*1024,saku_yoko,obj_yflip_h
	km_rdmap	02*1024,-4*1024,saku_yoko,obj_yflip_h
	km_rdmap	03*1024,-4*1024,saku_yoko,obj_yflip_h


	km_rdmapend	battlestage1
;=====================================================================






	IFEQ	1



;BASIC
sprrdmap_ron		equ	$3e	;rader_on
sprrdmap_roff	equ	$3f	;rader_off
;------------------------------------
sprrdmap_hodou	equ	$80
sprrdmap_saka	equ	$82
sprrdmap_gate	equ	$83
sprrdmap_houdai	equ	$84
sprrdmap_tunnel	equ	$85
sprrdmap_tower	equ	$86
sprrdmap_switch	equ	$87
sprrdmap_dandan	equ	$88
sprrdmap_yajiro	equ	$8a
sprrdmap_board	equ	$8b
sprrdmap_kabe	equ	$8c
;------------------------------------
;stage1

sprrdmap_mika1	equ	$8c
sprrdmap_mika2	equ	$9c
sprrdmap_mika3	equ	$8d
sprrdmap_mika4	equ	$9d
sprrdmap_ike1	equ	$8e
sprrdmap_ike2	equ	$9e
sprrdmap_ike3	equ	$8f
sprrdmap_ike4	equ	$9f
sprrdmap_iwa		equ	$97
sprrdmap_iwatate	equ	$99
sprrdmap_iwayoko	equ	$98
sprrdmap_hana	equ	$92
sprrdmap_iwasmall	equ	$92
sprrdmap_guruguru	equ	$95
sprrdmap_kinoko	equ	$90
sprrdmap_skinoko	equ	$91
sprrdmap_hako	equ	$92
;------------------------------------
;stage2

sprrdmap_totem	equ	$94
sprrdmap_yashi	equ	$94
sprrdmap_kao		equ	$92
sprrdmap_ori		equ	$87
sprrdmap_pyrasmall	equ	$92
sprrdmap_pyramid	equ	$81
sprrdmap_iwaita	equ	$87
;------------------------------------
;stage3
sprrdmap_volcano	equ	$81

;=====================================================================
;*		Enemy no total number				*
;=====================================================================
	ifeq	0
enemytotal_title		equ	1

enemytotal_missionstage1	equ	1
enemytotal_missionstage2	equ	1	
enemytotal_missionstage3	equ	1
enemytotal_missionstage4	equ	1
enemytotal_missionstage5	equ	1
enemytotal_missionstage6	equ	1
enemytotal_missionextra1	equ	7
enemytotal_missionextra2	equ	8
enemytotal_missionextra3	equ	6
enemytotal_missionextra4	equ	4
enemytotal_missionsos1	equ	1
enemytotal_missionsos2	equ	2
enemytotal_missionsos3	equ	3
enemytotal_battlestage1	equ	1
enemytotal_battlestage2	equ	1
enemytotal_battlestage3	equ	1
enemytotal_battlestage4	equ	1
enemytotal_battlestage5	equ	1

enemytotal_typeselect	equ	1
enemytotal_trainstage1	equ	12
enemytotal_trainstage2	equ	1
enemytotal_trainstage3	equ	1

enemytotal_kmap	equ	1
enemytotal_tmap	equ	1
enemytotal_dmap	equ	1
enemytotal_ymap	equ	1
enemytotal_emap	equ	1
	endc
;*********************************************************************
;*								*
;*			MAP START				*
;*								*
;*********************************************************************
radarmaptbl
;=====================================================================
;*			TITLE					*
;=====================================================================
	km_rdmapstart	title

	km_rdmapend	title
;=====================================================================
;*			Mission Stage 1				*
;=====================================================================
;-----------------------
	
	km_rdmapstart	missionstage1
;
;	km_rdmap	01024,256,mika3
;	km_rdmap	01024,-256,mika4
;	km_rdmap	-1024,256,mika1
y;	km_rdmap	-1024,-256,mika2
;
	km_rdmapend	missionstage1
;=====================================================================
;*			Mission Stage 2				*
;=====================================================================
	km_rdmapstart	missionstage2

;	km_rdmap	00000,00000,pyramid
	km_rdmapend	missionstage2

;=====================================================================
;*			Mission Stage 3				*
;=====================================================================

	km_rdmapstart	missionstage3
	km_rdmapend	missionstage3

;=====================================================================
;*			Mission Stage 4				*
;=====================================================================
	km_rdmapstart	missionstage4
	km_rdmapend	missionstage4
;=====================================================================
;*			Mission Stage 5				*
;=====================================================================
	km_rdmapstart	missionstage5
	km_rdmapend	missionstage5
;=====================================================================
;*			Mission Stage 6				*
;=====================================================================
	km_rdmapstart	missionstage6
	km_rdmapend	missionstage6
;=====================================================================
;*		Mission Extrra Stage 1				*
;=====================================================================
	km_rdmapstart	missionextra1
	km_rdmapend	missionextra1
;=====================================================================
;*		Mission Extrra Stage 2				*
;=====================================================================
	km_rdmapstart	missionextra2
	km_rdmapend	missionextra2
;=====================================================================
;*		Mission Extrra Stage 3				*
;=====================================================================
	km_rdmapstart	missionextra3
;	km_rdmap	-3*1024-512,-512,roff
;	km_rdmap	-2*1024-512,-512,roff
;	km_rdmap	-1024-512,-512,roff
;	km_rdmap	-512,-512,roff
;	km_rdmap	-4*1024-512,1024+512,roff
;	km_rdmap	-3*1024-512,1024+512,roff
;	km_rdmap	-2*1024-512,1024+512,roff
;	km_rdmap	-1024-512,1024+512,roff
;	km_rdmap	-5*1024-512,6*1024+512,roff
;	km_rdmap	-4*1024-512,7*1024+512,roff
;	km_rdmap	-3*1024-512,7*1024+512,roff
;	km_rdmap	-2*1024-512,7*1024+512,roff
;	km_rdmap	-1024-512,7*1024+512,roff
;	km_rdmap	-512,7*1024+512,roff
;	km_rdmap	-8*1024-512,7*1024+512,roff
;	km_rdmap	-8*1024-512,8*1024+512,roff
;	km_rdmap	-7*1024-512,8*1024+512,roff
;	km_rdmap	-8*1024-512,512,roff
;	km_rdmap	8*1024+512,8*1024+512,roff
;	km_rdmap	8*1024+512,14*1024+512,roff
;;
	km_rdmapend	missionextra3
;=====================================================================
;*		Mission Extrra Stage 4				*
;=====================================================================
	km_rdmapstart	missionextra4
	km_rdmapend	missionextra4
;=====================================================================
;*		Mission Sos Stage 1				*
;=====================================================================
	km_rdmapstart	missionsos1
	km_rdmapend	missionsos1
;=====================================================================
;*		Mission Sos Stage 2				*
;=====================================================================
	km_rdmapstart	missionsos2
	km_rdmapend	missionsos2
;=====================================================================
;*		Mission Sos Stage 3				*
;=====================================================================
	km_rdmapstart	missionsos3
	km_rdmapend	missionsos3

;=====================================================================
;*			Battle Stage 1				*
;=====================================================================
	km_rdmapstart	battlestage1
	km_rdmapend	battlestage1
;=====================================================================
;*			Battle Stage 2				*
;=====================================================================
	km_rdmapstart	battlestage2
	km_rdmapend	battlestage2
;=====================================================================
;*			Battle Stage 3				*
;=====================================================================
	km_rdmapstart	battlestage3
	km_rdmapend	battlestage3
;=====================================================================
;*			Battle Stage 4				*
;=====================================================================
	km_rdmapstart	battlestage4
	km_rdmapend	battlestage4
;=====================================================================
;*			Battle Stage 5				*
;=====================================================================
	km_rdmapstart	battlestage5
	km_rdmapend	battlestage5
;=====================================================================
;*		Type Select					*
;=====================================================================
	km_rdmapstart	typeselect
	km_rdmapend	typeselect
;=====================================================================
;*		Training Stage 1			[GROUND]*
;=====================================================================
	km_rdmapstart	trainstage1
;
;	km_rdmap	-0500,02000,ike1
;	km_rdmap	-0500,01000,ike2
;	km_rdmap	00500,02000,ike3
;	km_rdmap	00500,01000,ike4
;
;	km_rdmap	03800,-1200,ike1
;	km_rdmap	03800,-2200,ike2
;	km_rdmap	04800,-1200,ike3
;	km_rdmap	04800,-2200,ike4
;
;	km_rdmap	-2000,-2900,saka
;	km_rdmap	02200,-3200,pyramid
;	km_rdmap	-4000,01800,hodou
;	km_rdmap	03600,04000,tower
;
;	km_rdmap	00600,-1500,switch
;	km_rdmap	00600,-3100,switch
;	km_rdmap	-3100,-3400,switch
;	km_rdmap	-0600,-2700,switch
;	km_rdmap	-2000,-0800,board
;	km_rdmap	-1000,-0800,board
;	km_rdmap	-3400,-0900,switch
;	km_rdmap	-2000,00800,switch
;	km_rdmap	02000,00000,switch
;	km_rdmap	-4600,-2500,switch
;	km_rdmap	-4600,-0800,switch
;	km_rdmap	03600,01800,tunnel
;	km_rdmap	-1000,4600,mika1
;	km_rdmap	-1000,4000,mika2
;	km_rdmap	01500,3800,iwa
;
;	km_rdmap	-4000,04200,gate
;
	km_rdmapend	trainstage1
;=====================================================================
;*		Training Stage 2			[SPACE]	*
;=====================================================================
	km_rdmapstart	trainstage2
	km_rdmapend	trainstage2
;=====================================================================
;*		Training Stage 3			[SEA]	*
;=====================================================================
	km_rdmapstart	trainstage3
	km_rdmapend	trainstage3
;=====================================================================
;*		Test Kawaguchi Map				*
;=====================================================================
	km_rdmapstart	kmap
	km_rdmapend	kmap
;=====================================================================
;*		Test kawagoe Map				*
;=====================================================================
	km_rdmapstart	tmap
	km_rdmapend	tmap
;=====================================================================
;*		Test Dylan Map					*
;=====================================================================
	km_rdmapstart	dmap
	km_rdmapend	dmap
;=====================================================================
;*		Test Yamada Map					*
;=====================================================================
	km_rdmapstart	ymap
	km_rdmapend	ymap
;=====================================================================
;*		Test Eguchi Map					*
;=====================================================================
	km_rdmapstart	emap
	km_rdmapend	emap


	ENDC
