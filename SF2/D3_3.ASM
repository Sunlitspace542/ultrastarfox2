;**************************************************************************
;;
;;	OBJ ANIMATION DATA (d3-3.OBX)
;;
;**************************************************************************
;;
;;
;;
;;
;;
;;
;;
;---------------------------------------------------------------------
	INCPUB	chartdat
;---------------------------------------------------------------------
;
;
;
;
;
;*********************************************************************
;
; map animation program end
;
;*********************************************************************
MAend	macro
	db	81h
	endm

;---------------------------------------------------------------------




;*********************************************************************
;	map animation obj macros
;*********************************************************************

;---------------------------------------------------------------------

oamdata_pri0		equ	00h
oamdata_pri1		equ	10h
oamdata_pri2		equ	20h
oamdata_pri3		equ	30h

oamdata_attr0	equ	0
oamdata_attr1	equ	2
oamdata_attr2	equ	4
oamdata_attr3	equ	6
oamdata_attr4	equ	8
oamdata_attr5	equ	10
oamdata_attr6	equ	12
oamdata_attr7	equ	14

oamdata_hvflip	equ	0c0h
oamdata_hflip	equ	40h
oamdata_vflip	equ	80h
oamdata_nflip	equ	00h

;---------------------------------------------------------------------
mapanime_liststart	macro
mapanime_number = 0
	endm

;---------------------------------------------------------------------
mapanime_list	macro	[addr]
	dw	{addr}-ROMobjchart
cd_{addr}	equ	mapanime_number
mapanime_number = mapanime_number+1
	endm

;---------------------------------------------------------------------
mapanime_listend	macro
	printf	"list %xmapanime_number   "
	endm
;---------------------------------------------------------------------

mapobj_oamdata	macro	[h,v,fp,pno,ano,char]
	db	{h},{v}
	db	{char}&0ffh
	db	oamdata_pri{pno}+oamdata_attr{ano}+oamdata_{fp}flip+{char}/256
	endm

;---------------------------------------------------------------------
ROMobjchart
;**************************************************************************
;;
;;	OBJ ANIMATION DATA (d3-3.OBX)
;;
;**************************************************************************
;;
;;
;;
;;
;;
;;
;;
;**************************************************************************
;	macros
; 	kurukuru loop (MUTEKI ATTR)
;**************************************************************************

;-----------------------------------------------------------
; kurukuru frash
;-----------------------------------------------------------
Mmapobjbig	macro	[count]
	db	{count}
	endm

;-----------------------------------------------------------
; kurukuru frash
;-----------------------------------------------------------
Mmapobjsmall macro	[count]
	db	{count}+80h
	endm

;-----------------------------------------------------------
; kurukuru frash
;-----------------------------------------------------------
Msetmapdemo	macro	[ofs]
	db	81h	; frash
	dw	{ofs}
	endm

;-----------------------------------------------------------
; kurukuru normal
;-----------------------------------------------------------
Msetmapchar	macro	[ofs]
	db	80h	; normal
	dw	{ofs}
	endm

;-----------------------------------------------------------
; map obj jmp
;-----------------------------------------------------------
Mmapobjjmp	macro	[label]
nowaddr	=	*
	db	82h
	dw	{label}-nowaddr
	endm
;-----------------------------------------------------------
; map obj jmp
;-----------------------------------------------------------
Mmapobj16	macro
	db	83h
	endm

;==========================================================================



;**************************************************************************
;;	MAP SPRITE ANIMATION SEQ TABLE
;**************************************************************************

seqtable_d3_3
	mapanime_liststart
	mapanime_list	objtable_d3_3		;(0) =	obj address
	mapanime_list	objanime_dmmy_2		;(1) <<<<< stepup >>>>>
	mapanime_list	objanime_sos1		;(2) sos 1 start demo 
	mapanime_list	objanime_sos2		;(3) sos 2 start demo
	mapanime_list	objanime_dmmy_4		;(4) boss ship sprite
	mapanime_list	objanime_bigcursor	;(5)
	mapanime_list	objanime_smallcursor	;(6)
	mapanime_list	objanime_sosbomb	;(7)
	mapanime_list	objanime_faceopen	;(8) 
	mapanime_list	objanime_faceclose	;(9)
	mapanime_list	objanime_faceopen2	;(10)
	mapanime_list	objanime_faceclose2	;(11)
	mapanime_list	objanime_yajirushi_up	;(12)
	mapanime_list	objanime_yajirushi_dw	;(13)
	mapanime_list	objanime_dmmy_3		;(14)
	mapanime_list	objanime_crash		;(15)
	mapanime_list	objanime_dmmy_1		;(16) <<<<< stepup >>>>>
	mapanime_list	objanime_meteor		;(17)
	mapanime_list	objanime_enemyplanetstart ;(18)
	mapanime_list	objanime_enemyplanet	;(19)
	mapanime_list	objanime_nextmark	;(20)
	mapanime_list	objanime_sosplanein	;(21)
	mapanime_list	objanime_bossappear	;(22)
	mapanime_list	objanime_bossopen	;(23)
	mapanime_list	objanime_battleship	;(24) :senkan normal
	mapanime_list	objanime_battleship_dap	;(25) :senkan hatsya
	mapanime_list	objanime_battleship_app	;(26) :senkan syutugen
	mapanime_list	objanime_finalboss_dap	;(27) :final boss
	mapanime_list	objanime_explode_zaco	;(28) :bakuhatu zaco enemy
	mapanime_list	objanime_explode_planet	;(29) :bakuhatu planet
	mapanime_list	objanime_explode_bship	;(30) :bakuhatu battle ship
	mapanime_list	objanime_cannonfire1	;(31) :planet cannon fire 1
	mapanime_list	objanime_cannonfire2	;(32) :planet cannon fire 2
	mapanime_list	objanime_cannonexplode	;(33) :planetcannon explode
	mapanime_list	objanime_missileexplode	;(34) :missile explode
	mapanime_list	objanime_spenemyappear	;(35) :special enemy appear
	mapanime_list	objanime_mothership_dap	;(36) :mothership hatsya
	mapanime_list	objanime_mothership_app	;(37) :mothership syutugen
	mapanime_list	objanime_planetsenryou	;(38) :planet senryou
	mapanime_list	objanime_itemplanet	;(39) :item planet

;**************************************************************************
;;	MAP SPRITE ANIMATION OBJ TABLE
;**************************************************************************

objtable_d3_3

	mapanime_liststart

	mapanime_list	oam_clear		; clear object

	mapanime_list	oam_crash0		; crash animation
	mapanime_list	oam_crash1
	mapanime_list	oam_crash2
	mapanime_list	oam_crash3

	mapanime_list	oam_yajirushi_dw0	; yajirushi anime !
	mapanime_list	oam_yajirushi_dw1
	mapanime_list	oam_yajirushi_dw2
	mapanime_list	oam_yajirushi_up0
	mapanime_list	oam_yajirushi_up1
	mapanime_list	oam_yajirushi_up2

	mapanime_list	umare_0			; sos umareru !
	mapanime_list	umare_1
	mapanime_list	umare_2

	mapanime_list	obj_d3_d_0		; sos umareru !
	mapanime_list	obj_d3_d_1
	mapanime_list	obj_d3_d_2
	mapanime_list	obj_d3_d_3
	mapanime_list	obj_d3_d_4
	mapanime_list	obj_d3_d_5
	mapanime_list	obj_d3_d_6

	mapanime_list	oam_big1		; big cursor
	mapanime_list	oam_big2
	mapanime_list	oam_big3

	mapanime_list	oam_small1		; small cursor
	mapanime_list	oam_small2
	mapanime_list	oam_small3
	mapanime_list	oam_small4

	mapanime_list	oam_bossship1		; mappause - ship
	mapanime_list	oam_bossship2		; mappause - ship
	mapanime_list	oam_bossship3		; mappause - ship
	mapanime_list	oam_bossship4		; mappause - ship
	mapanime_list	oam_battleship1
	mapanime_list	oam_battleship2
	mapanime_list	oam_battleship3
	mapanime_list	oam_battleship4

	mapanime_list	obj_d3_7_0
	mapanime_list	obj_d3_7_1
	mapanime_list	obj_d3_7_2
	mapanime_list	obj_d3_7_3
	mapanime_list	obj_d3_7_4
	mapanime_list	obj_d3_7_5
	mapanime_list	obj_d3_7_6
	mapanime_list	obj_d3_7_7
	mapanime_list	obj_d3_7_8
	mapanime_list	obj_d3_7_9

	mapanime_list	oam_faceopen0		; faceopen animation
	mapanime_list	oam_faceopen1
	mapanime_list	oam_faceopen2
	mapanime_list	oam_faceopen3
	mapanime_list	oam_faceopen4
	mapanime_list	oam_faceopen5

	mapanime_list	frashkaiten_0		; frash kaiten patern
	mapanime_list	frashkaiten_1	
	mapanime_list	frashkaiten_2
	mapanime_list	frashkaiten_3
	mapanime_list	frashkaiten_4
	mapanime_list	frashkaiten_5
	mapanime_list	frashkaiten_6
	mapanime_list	frashkaiten_7
	mapanime_list	kaiten_0		; kaiten patern
	mapanime_list	kaiten_1
	mapanime_list	kaiten_2
	mapanime_list	kaiten_3
	mapanime_list	kaiten_4
	mapanime_list	kaiten_5
	mapanime_list	kaiten_6
	mapanime_list	kaiten_7

	mapanime_list	oam_meteor1
	mapanime_list	oam_meteor2
	mapanime_list	oam_meteor3
	mapanime_list	oam_meteor4

	mapanime_list	obj_d3_11_0
	mapanime_list	obj_d3_11_1
	mapanime_list	obj_d3_11_2
	mapanime_list	obj_d3_11_3
	mapanime_list	obj_d3_11_4
	mapanime_list	obj_d3_11_5
	mapanime_list	obj_d3_11_6
	mapanime_list	obj_d3_11_7
	mapanime_list	obj_d3_11_8
	mapanime_list	obj_d3_11_9
	mapanime_list	obj_d3_11_10
	mapanime_list	obj_d3_11_11
	mapanime_list	obj_d3_11_12
	mapanime_list	obj_d3_11_13
	mapanime_list	obj_d3_11_16
	mapanime_list	obj_d3_11_17
	mapanime_list	obj_d3_11_18
	mapanime_list	obj_d3_11_19
	mapanime_list	obj_d3_11_20
	mapanime_list	obj_d3_11_21
	mapanime_list	obj_d3_11_22
	mapanime_list	obj_d3_11_23
	mapanime_list	obj_d3_11_24

	mapanime_list	obj_nextmark
	
	mapanime_list	obj_e3_3_0
	mapanime_list	obj_e3_3_1
	mapanime_list	obj_e3_3_2
	mapanime_list	obj_e3_3_3
	mapanime_list	obj_e3_3_4
	mapanime_list	obj_e3_3_5
	mapanime_list	obj_e3_3_6
	mapanime_list	obj_e3_3_7
	mapanime_list	obj_e3_3_8
	mapanime_list	obj_e3_3_9
	mapanime_list	obj_e3_3_10
	mapanime_list	obj_e3_3_11
	mapanime_list	obj_e3_3_13
	mapanime_list	obj_e3_3_14
	mapanime_list	obj_e3_3_15
	mapanime_list	obj_e3_3_16
	mapanime_list	obj_e3_3_17
	mapanime_list	obj_e3_3_18
	mapanime_list	obj_e3_3_19
	mapanime_list	obj_e3_3_20

	mapanime_list	obj_e3_4_0
	mapanime_list	obj_e3_4_1
	mapanime_list	obj_e3_4_2
	mapanime_list	obj_e3_4_3
	mapanime_list	obj_e3_4_4
	mapanime_list	obj_e3_4_5
	mapanime_list	obj_e3_4_6
	mapanime_list	obj_e3_4_7
	mapanime_list	obj_e3_4_8
	mapanime_list	obj_e3_4_9
	mapanime_list	obj_e3_4_10
	mapanime_list	obj_e3_4_11
	mapanime_list	obj_e3_4_12
	mapanime_list	obj_e3_4_13
	mapanime_list	obj_e3_4_14
	mapanime_list	obj_e3_4_15
	mapanime_list	obj_e3_4_16
	mapanime_list	obj_e3_4_17

	mapanime_list	obj_e3_9_8
	mapanime_list	obj_e3_9_9
	mapanime_list	obj_e3_9_10
	mapanime_list	obj_e3_9_11
	mapanime_list	obj_e3_9_12

	mapanime_list	obj_e3_c_0
	mapanime_list	obj_e3_c_1
	mapanime_list	obj_e3_c_2
	mapanime_list	obj_e3_c_3
	mapanime_list	obj_e3_c_4
	mapanime_list	obj_e3_c_5
	mapanime_list	obj_e3_c_6
	mapanime_list	obj_e3_c_7
	mapanime_list	obj_e3_c_8
	mapanime_list	obj_e3_c_9
	mapanime_list	obj_e3_c_10
	mapanime_list	obj_e3_c_11

	mapanime_list	obj_e3_c_12
	mapanime_list	obj_e3_c_13
	mapanime_list	obj_e3_c_14
	mapanime_list	obj_e3_c_15
	mapanime_list	obj_e3_c_16
	mapanime_list	obj_e3_c_17
	mapanime_list	obj_e3_c_18
	mapanime_list	obj_e3_c_19
	mapanime_list	obj_e3_c_20
	mapanime_list	obj_e3_c_21
	mapanime_list	obj_e3_c_22
	mapanime_list	obj_e3_c_23

	mapanime_list	obj_e3_8_0
	mapanime_list	obj_e3_8_1
	mapanime_list	obj_e3_8_2
	mapanime_list	obj_e3_8_3
	mapanime_list	obj_e3_8_4
	mapanime_list	obj_e3_8_5
	mapanime_list	obj_e3_8_6
	mapanime_list	obj_e3_8_7
	mapanime_list	obj_e3_8_8
	mapanime_list	obj_e3_8_9
	mapanime_list	obj_e3_8_10
	mapanime_list	obj_e3_8_11
	mapanime_list	obj_e3_8_12
	mapanime_list	obj_e3_8_13
	mapanime_list	obj_e3_8_14
	mapanime_list	obj_e3_8_15
	mapanime_list	obj_e3_8_16
	mapanime_list	obj_e3_8_17
	mapanime_list	obj_e3_8_18
	mapanime_list	obj_e3_8_19
	mapanime_list	obj_e3_8_20
	mapanime_list	obj_e3_8_21


	mapanime_list	obj_e3_a_0
	mapanime_list	obj_e3_a_1
	mapanime_list	obj_e3_a_2
	mapanime_list	obj_e3_a_3
	mapanime_list	obj_e3_a_4
	mapanime_list	obj_e3_a_5
	mapanime_list	obj_e3_a_6
	mapanime_list	obj_e3_a_7
	mapanime_list	obj_e3_a_8
	mapanime_list	obj_e3_a_9
	mapanime_list	obj_e3_a_11
	mapanime_list	obj_e3_a_12
	mapanime_list	obj_e3_a_13
	mapanime_list	obj_e3_a_14

	mapanime_list	obj_e3_b_4
	mapanime_list	obj_e3_b_5
	mapanime_list	obj_e3_b_6
	mapanime_list	obj_e3_b_7
	mapanime_list	obj_e3_b_8
	mapanime_list	obj_e3_b_9
	mapanime_list	obj_e3_b_10
	mapanime_list	obj_e3_b_11

	mapanime_list	obj_itemplanet0
	mapanime_list	obj_itemplanet1
	mapanime_list	obj_itemplanet2

	mapanime_listend



;**************************************************************************
;	animation dmmy
;**************************************************************************
objanime_dmmy_1
objanime_dmmy_2
objanime_dmmy_3
objanime_dmmy_4
	db	1,cd_oam_clear
	MAend

;**************************************************************************
;	objanime nextmark
;**************************************************************************

objanime_nextmark
	db	008,cd_obj_nextmark
	db	008,cd_oam_clear
	MAend

;---------------------------------------------------------------------------
obj_nextmark
	db	81h
	db	-4,-4,056h,030h

;**************************************************************************
;	mapanime sos BomB
;**************************************************************************

objanime_sosbomb	;(45)
;	db	004h,cd_kaiten_4
;	db	004h,cd_frashkaiten_4
;	db	004h,cd_kaiten_4
;	db	004h,cd_frashkaiten_4

	db	004h,cd_obj_d3_d_0 
	db	004h,cd_obj_d3_d_1 
	db	004h,cd_obj_d3_d_2 
	db	004h,cd_obj_d3_d_3
	db	004h,cd_obj_d3_d_4
	db	004h,cd_obj_d3_d_5
	db	004h,cd_obj_d3_d_6
	db	001h,cd_oam_clear
	MAend

;**************************************************************************
;	sptepup arrived at
;**************************************************************************
objanime_bossopen

	db	003h,cd_oam_bossship1
	db	003h,cd_oam_bossship3
	db	003h,cd_oam_bossship1
	db	003h,cd_oam_bossship3

	db	003h,cd_oam_bossship1
	db	003h,cd_oam_bossship3
	db	003h,cd_oam_bossship1
	db	003h,cd_oam_bossship3
	db	003h,cd_oam_bossship1

	db	002h,cd_oam_bossship3
	db	002h,cd_oam_bossship1
	db	002h,cd_oam_bossship3
	db	002h,cd_oam_bossship1
	db	002h,cd_oam_bossship3
	db	002h,cd_oam_bossship1
	db	002h,cd_oam_bossship3
	db	002h,cd_oam_bossship1
	db	002h,cd_oam_bossship3

	db	1,cd_oam_clear
	MAend

;--------------------------------------------------------------------------

objanime_bossappear
	db	20,cd_oam_bossship1	;20
	db	20,cd_oam_bossship2	;22
	db	20,cd_oam_bossship3	;23
	db	20,cd_oam_bossship4	;24
	MAend
;--------------------------------------------------------------------------
objanime_battleship
	db	20,cd_oam_battleship1	;20
	db	20,cd_oam_battleship2	;22
	db	20,cd_oam_battleship3	;23
	db	20,cd_oam_battleship4	;24
	MAend
;--------------------------------------------------------------------------
objanime_battleship_dap	;(24 frame)
	db	3,cd_obj_e3_a_0
	db	3,cd_obj_e3_a_1
	db	3,cd_obj_e3_a_2
	db	3,cd_obj_e3_a_3
	db	3,cd_obj_e3_a_4
	db	3,cd_obj_e3_a_5
	db	3,cd_obj_e3_a_6
	db	3,cd_obj_e3_a_7
	MAend
;--------------------------------------------------------------------------
objanime_battleship_app	;(24 frame)
	db	3,cd_obj_e3_a_7
	db	3,cd_obj_e3_a_6
	db	3,cd_obj_e3_a_5
	db	3,cd_obj_e3_a_4
	db	3,cd_obj_e3_a_8
	db	3,cd_obj_e3_a_9
	db	3,cd_obj_e3_a_11
	db	3,cd_obj_e3_a_12
	MAend
;--------------------------------------------------------------------------
objanime_finalboss_dap	;(72 frame)
	db	020h,cd_obj_d3_7_0
	db	4+4,cd_obj_d3_7_1
	db	004h,cd_obj_d3_7_2
	db	004h,cd_obj_d3_7_3 
	db	004h,cd_obj_d3_7_4
	db	004h,cd_obj_d3_7_5
	db	004h,cd_obj_d3_7_6
	db	004h,cd_obj_d3_7_7
	db	004h,cd_obj_d3_7_8
	db	004h,cd_obj_d3_7_9
	MAend
;--------------------------------------------------------------------------
objanime_mothership_app	;(24 frame)
	db	3,cd_obj_e3_a_7
	db	3,cd_obj_e3_a_6
	db	3,cd_obj_e3_a_5
	db	3,cd_obj_e3_a_4
	db	3,cd_obj_e3_a_8
	db	3,cd_obj_e3_a_9
	db	3,cd_obj_e3_a_13
	db	3,cd_obj_e3_a_14
	MAend
;--------------------------------------------------------------------------
objanime_mothership_dap	;(24 frame)
	db	3,cd_obj_e3_a_14
	db	3,cd_obj_e3_a_13
	db	3,cd_obj_e3_a_9
	db	3,cd_obj_e3_a_8
	db	3,cd_obj_e3_a_4
	db	3,cd_obj_e3_a_5
	db	3,cd_obj_e3_a_6
	db	3,cd_obj_e3_a_7
	MAend
;**************************************************************************
;	start the sos enemy (1)
;**************************************************************************

objanime_sosplanein
;	db	004h,cd_kaiten_0
;	db	004h,cd_kaiten_1
;	db	004h,cd_kaiten_2
;	db	004h,cd_kaiten_3
;	db	004h,cd_kaiten_4
;	db	004h,cd_kaiten_5
;	db	004h,cd_kaiten_6
;	db	004h,cd_kaiten_7
;	db	004h,cd_kaiten_0

;	db	002h*8,cd_frashkaiten_1
;	db	002h*8,cd_frashkaiten_2
;	db	002h*8,cd_frashkaiten_3
;	db	002h*8,cd_frashkaiten_4
;	db	002h*8,cd_frashkaiten_5
;	db	002h*8,cd_frashkaiten_6
;	db	002h*8,cd_frashkaiten_7
;	db	002h*8,cd_frashkaiten_0
;	db	002h*8,cd_frashkaiten_1
;	db	002h*8,cd_frashkaiten_2
;	db	002h*8,cd_frashkaiten_3
;	db	002h*8,cd_frashkaiten_4
;	db	002h*8,cd_frashkaiten_5
;	db	002h*8,cd_frashkaiten_6
;	db	002h*8,cd_frashkaiten_7
;	db	002h*8,cd_frashkaiten_0

	db	004h,cd_umare_2
	db	004h,cd_umare_1
	db	004h,cd_umare_0
	MAend


;**************************************************************************
;	start the sos enemy (1)
;**************************************************************************

objanime_sos1 ;(80)
objanime_sos2 ;(80)

	db	004h,cd_umare_0
	db	004h,cd_umare_1
	db	004h,cd_umare_2
	db	002h,cd_frashkaiten_0
	db	002h,cd_frashkaiten_1
	db	002h,cd_frashkaiten_2
	db	002h,cd_frashkaiten_3
	db	002h,cd_frashkaiten_4
	db	002h,cd_frashkaiten_5
	db	002h,cd_frashkaiten_6
	db	002h,cd_frashkaiten_7
	db	002h,cd_frashkaiten_0
	db	002h,cd_frashkaiten_1
	db	002h,cd_frashkaiten_2
	db	002h,cd_frashkaiten_3
	db	002h,cd_frashkaiten_4
	db	002h,cd_frashkaiten_5
	db	002h,cd_frashkaiten_6
	db	002h,cd_frashkaiten_7
	db	004h,cd_kaiten_0
	db	004h,cd_kaiten_1
	db	004h,cd_kaiten_2
	db	004h,cd_kaiten_3
	db	004h,cd_kaiten_4
	db	004h,cd_kaiten_5
	db	004h,cd_kaiten_6
	db	004h,cd_kaiten_7
	db	004h,cd_kaiten_0
	MAend

;--------------------------------------------------------------------

;**************************************************************************
;	animation data
;**************************************************************************

objanime_bigcursor
	db	04,cd_oam_big1
	db	04,cd_oam_big2
	db	04,cd_oam_big3
	db	04,cd_oam_big2
	MAend

objanime_smallcursor
	db	04,cd_oam_small1
	db	04,cd_oam_small2
	db	04,cd_oam_small3
	db	04,cd_oam_small4
	MAend


objanime_meteor
	db	$10,cd_oam_meteor1
	db	$10,cd_oam_meteor2
	db	$10,cd_oam_meteor3
	db	$10,cd_oam_meteor4
	MAend

;**************************************************************************
;	enemy planet objdata
;**************************************************************************

;-----------------------------------------------------
objanime_enemyplanetstart
	db	002h,cd_oam_clear
	db	004h,cd_obj_d3_11_16 
	db	004h,cd_obj_d3_11_17 
	db	004h,cd_obj_d3_11_18 
	db	004h,cd_obj_d3_11_19 
	db	004h,cd_obj_d3_11_20 
	db	004h,cd_obj_d3_11_21 
	db	004h,cd_obj_d3_11_22 
	db	002h,cd_obj_d3_11_23 
	db	002h,cd_obj_d3_11_24
	MAend
;-----------------------------------------------------
objanime_enemyplanet
	db	002h,cd_obj_d3_11_0 
	db	002h,cd_obj_d3_11_1 
	db	002h,cd_obj_d3_11_2 
	db	002h,cd_obj_d3_11_3 
	db	002h,cd_obj_d3_11_4 
	db	002h,cd_obj_d3_11_5 
	db	002h,cd_obj_d3_11_6 
	db	002h,cd_obj_d3_11_7 
	db	002h,cd_obj_d3_11_8 
	db	002h,cd_obj_d3_11_9 
	db	002h,cd_obj_d3_11_10 
	db	002h,cd_obj_d3_11_11 
	db	002h,cd_obj_d3_11_4 
	db	002h,cd_obj_d3_11_5 
	db	002h,cd_obj_d3_11_6 
	db	002h,cd_obj_d3_11_7 
	MAend


;**************************************************************************
;*		Explode Pattern	(Zaco,Battleship,Planet)	*
;**************************************************************************
;-----------------------------------------------------
objanime_explode_planet	;(73)
	db	002h,cd_obj_e3_3_0 
	db	002h,cd_obj_e3_3_1 
	db	002h,cd_obj_e3_3_2 
	db	002h,cd_obj_e3_3_3 
	db	002h,cd_obj_e3_3_4 
	db	002h,cd_obj_e3_3_5 
	db	002h,cd_obj_e3_3_6 
	db	002h,cd_obj_e3_3_1 
	db	002h,cd_obj_e3_3_2 
	db	002h,cd_obj_e3_3_3 
	db	002h,cd_obj_e3_3_4 
	db	002h,cd_obj_e3_3_5 
	db	002h,cd_obj_e3_3_7 
	db	008h,cd_oam_clear
	db	003h,cd_obj_e3_3_8 
	db	003h,cd_obj_e3_3_9 
	db	003h,cd_obj_e3_3_10 
	db	003h,cd_obj_e3_3_11 
	db	003h,cd_obj_e3_3_13 
	db	003h,cd_obj_e3_3_14 
	db	003h,cd_obj_e3_3_15 
	db	003h,cd_obj_e3_3_16 
	db	003h,cd_obj_e3_3_17 
	db	003h,cd_obj_e3_3_18 
	db	003h,cd_obj_e3_3_19 
	db	003h,cd_obj_e3_3_20 
	MAend
;-----------------------------------------------------
objanime_planetsenryou	;(50)
	db	002h,cd_obj_e3_3_0 
	db	002h,cd_obj_e3_3_1 
	db	002h,cd_obj_e3_3_2 
	db	002h,cd_obj_e3_3_3 
	db	002h,cd_obj_e3_3_4 
	db	002h,cd_obj_e3_3_5 
	db	002h,cd_obj_e3_3_6 
	db	002h,cd_obj_e3_3_1 
	db	002h,cd_obj_e3_3_2 
	db	002h,cd_obj_e3_3_3 
	db	002h,cd_obj_e3_3_4 
	db	002h,cd_obj_e3_3_5 
	db	002h,cd_obj_e3_3_7 
	db	008h,cd_oam_clear
	db	002h,cd_obj_e3_9_8 
	db	002h,cd_obj_e3_9_9 
	db	002h,cd_obj_e3_9_10 
	db	002h,cd_obj_e3_9_11 
	db	002h,cd_obj_e3_9_12 
	db	002h,cd_obj_e3_9_11 
	db	002h,cd_obj_e3_9_10 
	db	002h,cd_obj_e3_9_9 
;-----------------------------------------------------
objanime_explode_zaco	;(64)
	db	002h,cd_obj_e3_4_0 
	db	002h,cd_obj_e3_4_1 
	db	002h,cd_obj_e3_4_2 
	db	002h,cd_obj_e3_4_3 
	db	002h,cd_obj_e3_4_4 
	db	002h,cd_obj_e3_4_5 
	db	002h,cd_obj_e3_4_6 
	db	002h,cd_obj_e3_4_1 
	db	002h,cd_obj_e3_4_2 
	db	002h,cd_obj_e3_4_3 
	db	002h,cd_obj_e3_4_4 
	db	002h,cd_obj_e3_4_5 
	db	002h,cd_obj_e3_4_7 
	db	008h,cd_oam_clear
	db	003h,cd_obj_e3_4_8 
	db	003h,cd_obj_e3_4_9 
	db	003h,cd_obj_e3_4_10 
	db	003h,cd_obj_e3_4_11 
	db	003h,cd_obj_e3_4_12 
	db	003h,cd_obj_e3_4_13 
	db	003h,cd_obj_e3_4_14 
	db	003h,cd_obj_e3_4_15 
	db	003h,cd_obj_e3_4_16 
	db	003h,cd_obj_e3_4_17 
	MAend
;-----------------------------------------------------
objanime_cannonfire1	;(36)
	db	003h,cd_obj_e3_c_0
	db	003h,cd_obj_e3_c_1
	db	003h,cd_obj_e3_c_2 
	db	003h,cd_obj_e3_c_3 
	db	003h,cd_obj_e3_c_4 
	db	003h,cd_obj_e3_c_5 
	db	003h,cd_obj_e3_c_6 
	db	003h,cd_obj_e3_c_7 
	db	003h,cd_obj_e3_c_8 
	db	003h,cd_obj_e3_c_9
	db	003h,cd_obj_e3_c_10
	db	003h,cd_obj_e3_c_11
	MAend

objanime_cannonfire2	;(36)
	db	003h,cd_obj_e3_c_12 
	db	003h,cd_obj_e3_c_13
	db	003h,cd_obj_e3_c_14 
	db	003h,cd_obj_e3_c_15
	db	003h,cd_obj_e3_c_16 
	db	003h,cd_obj_e3_c_17 
	db	003h,cd_obj_e3_c_18 
	db	003h,cd_obj_e3_c_19 
	db	003h,cd_obj_e3_c_20
	db	003h,cd_obj_e3_c_21
	db	003h,cd_obj_e3_c_22
	db	003h,cd_obj_e3_c_23
	MAend

objanime_cannonexplode	;(42)
	db	003h,cd_obj_e3_8_8 
	db	003h,cd_obj_e3_8_9 
	db	003h,cd_obj_e3_8_10
	db	003h,cd_obj_e3_8_11 
	db	003h,cd_obj_e3_8_12 
	db	003h,cd_obj_e3_8_13 
	db	003h,cd_obj_e3_8_14 
	db	003h,cd_obj_e3_8_15 
	db	003h,cd_obj_e3_8_16 
	db	003h,cd_obj_e3_8_17 
	db	003h,cd_obj_e3_8_18 
	db	003h,cd_obj_e3_8_19 
	db	003h,cd_obj_e3_8_20 
	db	003h,cd_obj_e3_8_21 
	MAend

objanime_missileexplode	;(76)
objanime_explode_bship	;(76)
	db	002h,cd_obj_e3_8_0 
	db	002h,cd_obj_e3_8_1 
	db	002h,cd_obj_e3_8_2 
	db	002h,cd_obj_e3_8_3 
	db	002h,cd_obj_e3_8_4 
	db	002h,cd_obj_e3_8_5 
	db	002h,cd_obj_e3_8_6 
	db	002h,cd_obj_e3_8_1 
	db	002h,cd_obj_e3_8_2 
	db	002h,cd_obj_e3_8_3 
	db	002h,cd_obj_e3_8_4 
	db	002h,cd_obj_e3_8_5 
	db	002h,cd_obj_e3_8_7 
	db	008h,cd_oam_clear
	db	003h,cd_obj_e3_8_8 
	db	003h,cd_obj_e3_8_9 
	db	003h,cd_obj_e3_8_10 
	db	003h,cd_obj_e3_8_11 
	db	003h,cd_obj_e3_8_12 
	db	003h,cd_obj_e3_8_13 
	db	003h,cd_obj_e3_8_14 
	db	003h,cd_obj_e3_8_15 
	db	003h,cd_obj_e3_8_16 
	db	003h,cd_obj_e3_8_17 
	db	003h,cd_obj_e3_8_18 
	db	003h,cd_obj_e3_8_19 
	db	003h,cd_obj_e3_8_20 
	db	003h,cd_obj_e3_8_21 
	MAend
;-----------------------------------------------------
;-----------------------------------------------------
objanime_spenemyappear	;(16)
	db	002h,cd_obj_e3_b_4 
	db	002h,cd_obj_e3_b_5 
	db	002h,cd_obj_e3_b_6 
	db	002h,cd_obj_e3_b_7 
	db	002h,cd_obj_e3_b_8 
	db	002h,cd_obj_e3_b_9 
	db	002h,cd_obj_e3_b_10 
	db	002h,cd_obj_e3_b_11 
;-----------------------------------------------------
objanime_itemplanet	;(48)
	db	00ch,cd_obj_itemplanet0
	db	00ch,cd_obj_itemplanet1
	db	00ch,cd_obj_itemplanet2
	db	00ch,cd_obj_itemplanet1
;-----------------------------------------------------
obj_itemplanet0
	Mmapobjbig	1
	db	0f8h,0f8h,0a6h,022h
obj_itemplanet1
	Mmapobjbig	1
	db	0f8h,0f8h,0a8h,022h
obj_itemplanet2
	Mmapobjbig	1
	db	0f8h,0f8h,0aah,022h

;-----------------------------------------------------
;-----------------------------------------------------
dbxx1	macro	
	db	\1
	db	\2
	db	\3
	db	\4&011101111b
	endm

obj_d3_11_0
	db	1
	dbxx1	0f0h,0f0h,0eah,039h

obj_d3_11_1
	db	1
	dbxx1	000h,0f0h,0eah,079h

obj_d3_11_2
	db	1
	dbxx1	000h,000h,0eah,0f9h

obj_d3_11_3
	db	1
	dbxx1	0f0h,000h,0eah,0b9h

obj_d3_11_4
	db	1
	dbxx1	0f0h,0f0h,0ech,039h

obj_d3_11_5
	db	1
	dbxx1	000h,0f0h,0ech,079h

obj_d3_11_6
	db	1
	dbxx1	000h,000h,0ech,0f9h

obj_d3_11_7
	db	1
	dbxx1	0f0h,000h,0ech,0b9h

obj_d3_11_8
	db	1
	dbxx1	0f0h,0f0h,0eeh,039h

obj_d3_11_9
	db	1
	dbxx1	000h,0f0h,0eeh,079h

obj_d3_11_10
	db	1
	dbxx1	000h,000h,0eeh,0f9h

obj_d3_11_11
	db	1
	dbxx1	0f0h,000h,0eeh,0b9h

obj_d3_11_12
	db	4
	dbxx1	000h,000h,04eh,031h
	dbxx1	0f0h,000h,04ch,031h
	dbxx1	000h,0f0h,02eh,031h
	dbxx1	0f0h,0f0h,02ch,031h

obj_d3_11_13
	db	2
	dbxx1	0f8h,010h,082h,030h
	dbxx1	0f8h,0f8h,0c0h,031h

obj_d3_11_16
	db	1
	dbxx1	0f8h,0f8h,068h,032h

obj_d3_11_17
	db	1
	dbxx1	0f8h,0f8h,06ah,032h

obj_d3_11_18
	db	1
	dbxx1	0f8h,0f8h,06ch,032h

obj_d3_11_19
	db	1
	dbxx1	0f8h,0f8h,06eh,032h

obj_d3_11_20
	db	4
	dbxx1	0feh,0feh,084h,0fah
	dbxx1	0f2h,0feh,084h,0bah
	dbxx1	0feh,0f2h,084h,07ah
	dbxx1	0f2h,0f2h,084h,03ah

obj_d3_11_21
	db	4
	dbxx1	000h,000h,084h,0fah
	dbxx1	0f0h,000h,084h,0bah
	dbxx1	000h,0f0h,084h,07ah
	dbxx1	0f0h,0f0h,084h,03ah

obj_d3_11_22
	db	4
	dbxx1	0f0h,000h,088h,0bah
	dbxx1	000h,000h,088h,0fah
	dbxx1	000h,0f0h,088h,07ah
	dbxx1	0f0h,0f0h,088h,03ah

obj_d3_11_23
	db	4
	dbxx1	0f0h,000h,00ch,0bbh
	dbxx1	000h,000h,00ch,0fbh
	dbxx1	000h,0f0h,00ch,07bh
	dbxx1	0f0h,0f0h,00ch,03bh

obj_d3_11_24
	db	4
	dbxx1	0f0h,000h,0ech,0b9h
	dbxx1	000h,000h,0ech,0f9h
	dbxx1	000h,0f0h,0ech,079h
	dbxx1	0f0h,0f0h,0ech,039h


;**************************************************************************
;	animation data
;**************************************************************************
;
;
;
;
;
;
;
;--------------------------------------------------------------------------
oam_big1	db	84h
	mapobj_oamdata	-16,-16,n,2,0,$55
	mapobj_oamdata	008,-16,h,2,0,$55
	mapobj_oamdata	-16,008,v,2,0,$55
	mapobj_oamdata	008,008,hv,2,0,$55
oam_big2	db	84h
	mapobj_oamdata	-15,-15,n,2,1,$55
	mapobj_oamdata	007,-15,h,2,1,$55
	mapobj_oamdata	-15,007,v,2,1,$55
	mapobj_oamdata	007,007,hv,2,1,$55
oam_big3	db	84h
	mapobj_oamdata	-14,-14,n,2,0,$55
	mapobj_oamdata	006,-14,h,2,0,$55
	mapobj_oamdata	-14,006,v,2,0,$55
	mapobj_oamdata	006,006,hv,2,0,$55

;--------------------------------------------------------------------------
oam_small1
	db	01
	mapobj_oamdata	-8,-8,n,2,0,$48
oam_small2
	db	01
	mapobj_oamdata	-8,-8,n,2,1,$48
oam_small3
	db	01
	mapobj_oamdata	-8,-8,n,2,0,$4a
oam_small4
	db	01
	mapobj_oamdata	-8,-8,n,2,1,$4a
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
oam_meteor1	db	05h
	mapobj_oamdata	-14,-08,n,2,0,$14a

	mapobj_oamdata	-16,-16,n,2,0,$12c
	mapobj_oamdata	000,-16,n,2,0,$12e
	mapobj_oamdata	-16,000,n,2,0,$14c
	mapobj_oamdata	000,000,n,2,0,$14e

oam_meteor2	db	05h
	mapobj_oamdata	-2,-08,n,2,0,$14a

	mapobj_oamdata	-16,-16,n,2,0,$12c
	mapobj_oamdata	000,-16,n,2,0,$12e
	mapobj_oamdata	-16,000,n,2,0,$14c
	mapobj_oamdata	000,000,n,2,0,$14e

oam_meteor3	db	05h
	mapobj_oamdata	-14,-08,v,2,0,$14a

	mapobj_oamdata	-16,-16,n,2,0,$12c
	mapobj_oamdata	000,-16,n,2,0,$12e
	mapobj_oamdata	-16,000,n,2,0,$14c
	mapobj_oamdata	000,000,n,2,0,$14e

oam_meteor4	db	05h
	mapobj_oamdata	-2,-08,v,2,0,$14a

	mapobj_oamdata	-16,-16,n,2,0,$12c
	mapobj_oamdata	000,-16,n,2,0,$12e
	mapobj_oamdata	-16,000,n,2,0,$14c
	mapobj_oamdata	000,000,n,2,0,$14e

;**************************************************************************
;	face open/close
;**************************************************************************

objanime_yajirushi_dw
	db	04,cd_oam_yajirushi_dw0
	db	04,cd_oam_yajirushi_dw1
	db	08,cd_oam_yajirushi_dw2
	MAend
objanime_yajirushi_up
	db	04,cd_oam_yajirushi_up0
	db	04,cd_oam_yajirushi_up1
	db	08,cd_oam_yajirushi_up2
	MAend



;-----------------------------------------------------------
oam_yajirushi_dw0
	db	4
	mapobj_oamdata	-16,-16-20,n,2,3,146h
	Mmapobjjmp	aaaa

;-----------------------------------------------------------
oam_yajirushi_dw1
	db	4
	mapobj_oamdata	-16,-16-22,n,2,3,146h
	mapobj_oamdata	000,-16-22,h,2,3,146h
	mapobj_oamdata	-16,000-22,n,2,3,148h
	mapobj_oamdata	000,000-22,h,2,3,148h
;-----------------------------------------------------------
oam_yajirushi_dw2
	db	4
	mapobj_oamdata	-16,-16-24,n,2,3,146h
	mapobj_oamdata	000,-16-24,h,2,3,146h
	mapobj_oamdata	-16,000-24,n,2,3,148h
	mapobj_oamdata	000,000-24,h,2,3,148h
;-----------------------------------------------------------
oam_yajirushi_up0
	db	4
	mapobj_oamdata	-16,-16+20,v,2,3,148h
	mapobj_oamdata	000,-16+20,hv,2,3,148h
	mapobj_oamdata	-16,000+20,v,2,3,146h
	mapobj_oamdata	000,000+20,hv,2,3,146h
;-----------------------------------------------------------
oam_yajirushi_up1
	db	4
	mapobj_oamdata	-16,-16+22,v,2,3,148h
	mapobj_oamdata	000,-16+22,hv,2,3,148h
	mapobj_oamdata	-16,000+22,v,2,3,146h
	mapobj_oamdata	000,000+22,hv,2,3,146h
;-----------------------------------------------------------
oam_yajirushi_up2
	db	4
	mapobj_oamdata	-16,-16+24,v,2,3,148h
	mapobj_oamdata	000,-16+24,hv,2,3,148h
	mapobj_oamdata	-16,000+24,v,2,3,146h
	mapobj_oamdata	000,000+24,hv,2,3,146h
;-----------------------------------------------------------
aaaa	mapobj_oamdata	000,-16-20,h,2,3,146h
	mapobj_oamdata	-16,000-20,n,2,3,148h
	mapobj_oamdata	000,000-20,h,2,3,148h

;-----------------------------------------------------------



;**************************************************************************
;	crash object
;**************************************************************************

;-----------------------------------------------------------
objanime_crash
	db	4,cd_oam_crash0
	db	4,cd_oam_crash1
	db	4,cd_oam_crash2
	db	4,cd_oam_crash3
	db      4*4,cd_oam_clear
	MAend

;-----------------------------------------------------------
crash_pos0	equ	0f8f8h

crash_ptn0	equ	2868h	;(0)
crash_ptn1	equ	286ah	;(1)
crash_ptn2	equ	2a6ch	;(2)
crash_ptn3	equ	2a4eh	;(3)
;-----------------------------------------------------------

oam_crash0	db	1
	dw	crash_pos0,crash_ptn0
oam_crash1	db	1
	dw	crash_pos0,crash_ptn1
oam_crash2	db	1
	dw	crash_pos0,crash_ptn2
oam_crash3	db	1
	dw	crash_pos0,crash_ptn3

;**************************************************************************
;	face open/close
;**************************************************************************

objanime_faceopen2
	db	03,cd_oam_faceopen5
	db	03,cd_oam_faceopen4
	db	03,cd_oam_faceopen3
	db	03,cd_oam_faceopen2
	db	03,cd_oam_faceopen1
	db	03,cd_oam_faceopen1
	db	01,cd_oam_clear
	MAend

objanime_faceopen
	db	01,cd_oam_clear
	db	04,cd_oam_faceopen5
	db	04,cd_oam_faceopen4
	db	03,cd_oam_faceopen3
	db	03,cd_oam_faceopen2
	db	03,cd_oam_faceopen1
	db	08,cd_oam_faceopen1
	db	01,cd_oam_clear
	MAend

objanime_faceclose
	db	10,cd_oam_clear
objanime_faceclose2
	db	12,cd_oam_clear
	db	03,cd_oam_faceopen1
	db	03,cd_oam_faceopen1
	db	03,cd_oam_faceopen2
	db	03,cd_oam_faceopen3
	db	03,cd_oam_faceopen4
	db	03,cd_oam_faceopen5
	db	01,cd_oam_clear
	MAend


;--------------------------------------------------------------------------
oam_clear	
	db	0

;--------------------------------------------------------------------------
oam_faceopen0
	db	6
	mapobj_oamdata	-16,-24,n,2,0,140h
	mapobj_oamdata	000,-24,h,2,0,140h
	mapobj_oamdata	-16,-08,n,2,0,142h
	mapobj_oamdata	000,-08,h,2,0,142h
	mapobj_oamdata	-16,008,n,2,0,144h
	mapobj_oamdata	000,008,h,2,0,144h

;--------------------------------------------------------------------------
oam_faceopen1
	db	6
	db	000h,008h,020h,0f1h
	db	0f0h,008h,020h,0b1h
	db	000h,0f8h,022h,071h
	db	000h,0e8h,020h,071h
	db	0f0h,0f8h,022h,031h
	db	0f0h,0e8h,020h,031h

;--------------------------------------------------------------------------
oam_faceopen2
	db	4
	db	000h,000h,020h,0f1h
	db	0f0h,000h,020h,0b1h
	db	000h,0f0h,020h,071h
	db	0f0h,0f0h,020h,031h

;--------------------------------------------------------------------------
oam_faceopen3
	db	4
	db	000h,0fch,020h,0f1h
	db	0f0h,0fch,020h,0b1h
	db	000h,0f4h,020h,071h
	db	0f0h,0f4h,020h,031h

;--------------------------------------------------------------------------
oam_faceopen4
	db	80h+12
	db	000h,0f8h,021h,071h
	db	008h,0f8h,020h,071h
	db	0f8h,0f8h,021h,031h
	db	0f0h,0f8h,020h,031h
	db	008h,0f8h,040h,071h
	db	000h,0f8h,041h,071h
	db	0f8h,0f8h,041h,031h
	db	0f0h,0f8h,040h,031h
	db	000h,000h,021h,0f1h
	db	008h,000h,020h,0f1h
	db	0f8h,000h,021h,0b1h
	db	0f0h,000h,020h,0b1h

;--------------------------------------------------------------------------
oam_faceopen5
	db	2
	db	000h,0f8h,02eh,030h
	db	0f0h,0f8h,02eh,030h

;--------------------------------------------------------------------------

;**************************************************************************
;		OBJ data
;**************************************************************************
bossship_common
	Mmapobj16
	db	004h,20h
	db	004h,60h
	db	006h,20h
	db	006h,60h

oam_bossship1
	Mmapobjbig	5
	db	0f6h,0f8h,00ah,000h+20h
 	Mmapobjjmp	bossship_common
oam_bossship2
	Mmapobjbig	5
	db	0fah,0f8h,00ah,040h+20h
	Mmapobjjmp	bossship_common
oam_bossship3
	Mmapobjbig	5
	db	0f6h,0f8h,00ah,080h+20h
	Mmapobjjmp	bossship_common
oam_bossship4
	Mmapobjbig	5
	db	0fah,0f8h,00ah,0c0h+20h
	Mmapobjjmp	bossship_common
;---------------------------------------------------------------
;battleship_common
;	Mmapobj16
;	SprChrDataW	$12e,colpal0,pri2,noflip,0

oam_battleship1
	Mmapobjbig	2
	SpriteDataW	-8,-8,$008,colpal0,pri2,noflip,0
	SpriteDataW	-8,-8,$12e,colpal0,pri2,noflip,0

;	Mmapobjjmp	battleship_common
oam_battleship2
	Mmapobjbig	2
	SpriteDataW	-8,-8,$008,colpal0,pri2,xflip,0
	SpriteDataW	-8,-8,$12e,colpal0,pri2,noflip,0

;	Mmapobjjmp	battleship_common
oam_battleship3
	Mmapobjbig	2
	SpriteDataW	-8,-8,$008,colpal0,pri2,yflip,0
	SpriteDataW	-8,-8,$12e,colpal0,pri2,noflip,0

;	Mmapobjjmp	battleship_common
oam_battleship4
	Mmapobjbig	2
	SpriteDataW	-8,-8,$008,colpal0,pri2,xyflip,0
	SpriteDataW	-8,-8,$12e,colpal0,pri2,noflip,0

;	Mmapobjjmp	battleship_common

;---------------------------------------------------------------
obj_e3_a_0
	MSoam_big	1
	db	0f8h,0f8h,040h,036h

obj_e3_a_1
	MSoam_big	2
	db	0f8h,0f8h,040h,036h
	db	0f8h,0f8h,06ch,034h

obj_e3_a_2
	MSoam_big	2
	db	0f8h,0f8h,040h,036h
	db	0f8h,0f8h,06eh,034h

obj_e3_a_3
	MSoam_big	5
	db	0f8h,0f8h,040h,034h
	db	000h,000h,084h,0f4h
	db	000h,0f0h,084h,074h
	db	0f0h,000h,084h,0b4h
	db	0f0h,0f0h,084h,034h

obj_e3_a_4
	MSoam_big	1
	db	0f8h,0f8h,06eh,038h

obj_e3_a_5
	MSoam_big	1
	db	0f8h,0f8h,06ch,038h

obj_e3_a_6
	MSoam_big	1
	db	0f8h,0f8h,06ah,038h

obj_e3_a_7
	MSoam_big	1
	db	0f8h,0f8h,068h,038h

obj_e3_a_8
	MSoam_big	5
	db	0f8h,0f8h,06ah,038h
	db	000h,0f0h,084h,078h
	db	000h,000h,084h,0f8h
	db	0f0h,000h,084h,0b8h
	db	0f0h,0f0h,084h,038h

obj_e3_a_9
	MSoam_big	5
	db	0f8h,0f8h,06eh,034h
	db	0f0h,000h,088h,0b4h
	db	000h,000h,088h,0f4h
	db	000h,0f0h,088h,074h
	db	0f0h,0f0h,088h,034h

obj_e3_a_11
	MSoam_big	5
	db	0f8h,0f8h,02eh,035h
	db	0f0h,000h,088h,0bch
	db	000h,000h,088h,0fch
	db	000h,0f0h,088h,07ch
	db	0f0h,0f0h,088h,03ch

obj_e3_a_12
	MSoam_big	5
	db	0f8h,0f8h,02eh,035h
	db	000h,000h,084h,0fch
	db	0f0h,0f0h,084h,03ch
	db	0f0h,000h,084h,0bch
	db	000h,0f0h,084h,07ch

obj_e3_a_13
	MSoam_big	5
	db	0f8h,0f8h,02ch,035h
	db	0f0h,000h,088h,0bch
	db	000h,000h,088h,0fch
	db	000h,0f0h,088h,07ch
	db	0f0h,0f0h,088h,03ch

obj_e3_a_14
	MSoam_big	5
	db	0f8h,0f8h,02ch,035h
	db	000h,000h,084h,0fch
	db	0f0h,0f0h,084h,03ch
	db	0f0h,000h,084h,0bch
	db	000h,0f0h,084h,07ch

;--------------------------------------------------------------------------

obj_d3_7_0
	Mmapobjbig	4
	db	000h,000h,006h,070h
	db	000h,0f0h,004h,070h
	db	0f0h,000h,006h,030h
	db	0f0h,0f0h,004h,030h

obj_d3_7_1
	Mmapobjbig	8
	db	000h,000h,006h,070h
	db	000h,0f0h,004h,070h
	db	0f0h,000h,006h,030h
	db	0f0h,0f0h,004h,030h
	db	000h,000h,084h,0fah
	db	0f0h,000h,084h,0bah
	db	000h,0f0h,084h,07ah
	db	0f0h,0f0h,084h,03ah

obj_d3_7_2
	Mmapobjbig	8
	db	0f0h,0f0h,004h,030h
	db	0f0h,000h,006h,030h
	db	000h,000h,006h,070h
	db	000h,0f0h,004h,070h
	db	000h,0f0h,088h,07ah
	db	000h,000h,088h,0fah
	db	0f0h,000h,088h,0bah
	db	0f0h,0f0h,088h,03ah

obj_d3_7_3
	Mmapobjbig	8
	db	0f0h,0f0h,004h,038h
	db	0f0h,000h,006h,038h
	db	000h,000h,006h,078h
	db	000h,0f0h,004h,078h
	db	0f0h,0f0h,088h,038h
	db	0f0h,000h,088h,0b8h
	db	000h,000h,088h,0f8h
	db	000h,0f0h,088h,078h

obj_d3_7_4
	Mmapobjbig	4
	db	0f0h,000h,084h,0b8h
	db	000h,000h,084h,0f8h
	db	000h,0f0h,084h,078h
	db	0f0h,0f0h,084h,038h

obj_d3_7_5
	Mmapobjbig	4
	db	0f2h,0feh,084h,0b8h
	db	0feh,0feh,084h,0f8h
	db	0feh,0f2h,084h,078h
	db	0f2h,0f2h,084h,038h

obj_d3_7_6
	Mmapobjbig	1
	db	0f8h,0f8h,06eh,038h

obj_d3_7_7
	Mmapobjbig	1
	db	0f8h,0f8h,06ch,038h

obj_d3_7_8
	Mmapobjbig	1
	db	0f8h,0f8h,06ah,038h

obj_d3_7_9
	Mmapobjbig	1
	db	0f8h,0f8h,068h,038h
;**************************************************************************
;	OBJ data
; 	umareru animation
;**************************************************************************

umare_0	db	1
	db	0f8h,0f8h,068h,024h

umare_1	db	1
	db	0f8h,0f8h,06ah,024h

umare_2	db	1
	db	0f8h,0f8h,06ch,024h

;**************************************************************************
;;
;;	STEPUP	KUN no OBJ blockdata
;;	SOS 	KUN
;;	SHIP	KUN
;;	GUARD	KUN
;;
;**************************************************************************
dbax	macro
	db	(-(\1+10h))&0ffh
	db	\2
	db	\3
	db	(\4)+40h
	endm

;===========================================================

frashkaiten_0
	db	1
	Msetmapdemo	0
;------------------------------------------------------------
frashkaiten_1
	db	1
	Msetmapdemo	2
;------------------------------------------------------------
frashkaiten_2
	db	1
	Msetmapdemo	4
;------------------------------------------------------------
frashkaiten_3
	db	1
	Msetmapdemo	6
;------------------------------------------------------------
frashkaiten_4
	db	1
	Msetmapdemo	8
;------------------------------------------------------------
frashkaiten_5
	db	1
	Msetmapdemo	6+4000h
;------------------------------------------------------------
frashkaiten_6
	db	1
	Msetmapdemo	4+4000h
;------------------------------------------------------------
frashkaiten_7
	db	1
	Msetmapdemo	2+4000h
;------------------------------------------------------------
kaiten_0
	db	1
	Msetmapchar	0
;------------------------------------------------------------
kaiten_1
	db	1
	Msetmapchar	2
;------------------------------------------------------------
kaiten_2
	db	1
	Msetmapchar	4
;------------------------------------------------------------
kaiten_3
	db	1
	Msetmapchar	6
;------------------------------------------------------------
kaiten_4
	db	1
	Msetmapchar	8
;------------------------------------------------------------
kaiten_5
	db	1
	Msetmapchar	6+4000h
;------------------------------------------------------------
kaiten_6
	db	1
	Msetmapchar	4+4000h
;------------------------------------------------------------
kaiten_7
	db	1
	Msetmapchar	2+4000h
;------------------------------------------------------------

;**************************************************************************
;	BAKUHATSU ANIMATION DATA
;**************************************************************************

obj_d3_d_0	;(1)
	db	1
	db	0f8h,0f8h,020h,029h

obj_d3_d_1	;(4)
	db	4
	db	0fch,0f4h,020h,029h
	db	0fch,0fch,020h,029h
	db	0f4h,0fch,020h,029h
	db	0f4h,0f4h,020h,029h

obj_d3_d_2	;(4)
	db	4
	db	0f0h,000h,00ah,0e9h
	db	000h,000h,008h,0e9h
	db	000h,0f0h,00ah,029h
	db	0f0h,0f0h,008h,029h

obj_d3_d_3	;(8)
	db	8
	db	0ffh,0f1h,00ah,02bh
	db	0ffh,0ffh,008h,0ebh
	db	0f1h,0ffh,00ah,0ebh
	db	0f1h,0f1h,008h,02bh
	db	0f0h,000h,00eh,0e3h
	db	000h,000h,00ch,0e3h
	db	000h,0f0h,00eh,023h
	db	0f0h,0f0h,00ch,023h

obj_d3_d_4	;(8)
	db	8
	db	0f0h,000h,00ch,0a3h
	db	0f0h,0f0h,00eh,063h
	db	000h,0f0h,00ch,063h
	db	000h,000h,00eh,0a3h
	db	0f1h,0ffh,008h,0adh
	db	0f1h,0f1h,00ah,06dh
	db	0ffh,0f1h,008h,06dh
	db	0ffh,0ffh,00ah,0adh

obj_d3_d_5	;(4)
	db	4
	db	0feh,0f2h,00eh,021h
	db	0f2h,0f2h,00ch,021h
	db	0feh,0feh,00ch,0e1h
	db	0f2h,0feh,00eh,0e1h

obj_d3_d_6	;(4)
	db	4
	db	0f0h,000h,022h,0a1h
	db	000h,000h,022h,0e1h
	db	000h,0f0h,022h,061h
	db	0f0h,0f0h,022h,021h

;---------------------------------------------------------------------
;* Zaco Enemy , Battle Ship , Planet Common Anime Data		*
;---------------------------------------------------------------------
obj_e3_3_0
obj_e3_4_0
	Mmapobjbig	1
	db	0f5h,0f4h,068h,038h

obj_e3_3_1
obj_e3_4_1
	Mmapobjbig	1
	db	0f5h,0f4h,06ah,038h

obj_e3_3_2
obj_e3_4_2
	Mmapobjbig	2
	db	0fch,0f6h,068h,038h
	db	0f5h,0f4h,06ah,036h

obj_e3_3_3
obj_e3_4_3
	Mmapobjbig	1
	db	0fch,0f6h,06ah,038h

obj_e3_3_4
obj_e3_4_4
	Mmapobjbig	2
	db	0f7h,0fbh,068h,038h
	db	0fch,0f6h,06ah,036h

obj_e3_3_5
obj_e3_4_5
	Mmapobjbig	1
	db	0f7h,0fch,06ah,038h

obj_e3_3_6
obj_e3_4_6
	Mmapobjbig	2
	db	0f5h,0f4h,068h,038h
	db	0f7h,0fch,06ah,036h

obj_e3_3_7
obj_e3_4_7
	Mmapobjbig	1
	db	0f7h,0fch,06ah,036h

obj_e3_3_8
obj_e3_4_8
	Mmapobjbig	1
	db	0f8h,0f8h,068h,038h

obj_e3_3_9
obj_e3_4_9
	Mmapobjbig	1
	db	0f8h,0f8h,06ah,038h

obj_e3_3_10
obj_e3_4_10
	Mmapobjbig	1
	db	0f8h,0f8h,06ch,038h

obj_e3_4_11
	Mmapobjbig	1
	db	0f8h,0f8h,008h,037h
;---------------------------------------------------------------------
;( Planet )
obj_e3_3_11
	Mmapobjbig	1
	db	0f8h,0f8h,06eh,038h

obj_e3_3_13
	Mmapobjbig	4
	db	0f0h,000h,084h,0b8h
	db	000h,000h,084h,0f8h
	db	000h,0f0h,084h,078h
	db	0f0h,0f0h,084h,038h

obj_e3_3_14
	Mmapobjbig	4
	db	0f0h,000h,088h,0b8h
	db	000h,000h,088h,0f8h
	db	000h,0f0h,088h,078h
	db	0f0h,0f0h,088h,038h

obj_e3_3_15
	Mmapobjbig	4
	db	0f8h,0fch,06eh,038h
	db	0feh,0f8h,06eh,038h
	db	0f2h,0f8h,06eh,038h
	db	0f8h,0f4h,06eh,038h

obj_e3_3_16
	Mmapobjbig	4
	db	0f8h,0fch,06ch,038h
	db	002h,0f8h,06ch,038h
	db	0eeh,0f8h,06ch,038h
	db	0f8h,0f4h,06ch,038h

obj_e3_3_17
	Mmapobjbig	7
	db	005h,0f8h,06ch,038h
	db	0ebh,0f8h,06ch,038h
	db	008h,0f8h,06ah,038h
	db	0e8h,0f8h,06ah,038h
	db	0ffh,0f8h,06ah,038h
	db	0f1h,0f8h,06ah,038h
	db	0f8h,0f8h,06ah,038h

obj_e3_3_18
	Mmapobjbig	7
	db	006h,0f8h,06ah,038h
	db	00bh,0f8h,068h,038h
	db	0eah,0f8h,06ah,038h
	db	0e5h,0f8h,068h,038h
	db	002h,0f8h,068h,038h
	db	0eeh,0f8h,068h,038h
	db	0f8h,0f8h,068h,038h

obj_e3_3_19
	Mmapobjbig	7
	db	0f8h,0f8h,068h,03ah
	db	0e7h,0f8h,06ah,03ah
	db	009h,0f8h,06ah,03ah
	db	00dh,0f8h,068h,03ah
	db	0e3h,0f8h,068h,03ah
	db	004h,0f8h,068h,03ah
	db	0ech,0f8h,068h,03ah

obj_e3_3_20
	Mmapobjbig	2
	db	00ch,0f8h,068h,03ah
	db	0e4h,0f8h,068h,03ah
;---------------------------------------------------------------------
;( Battle Ship)
obj_e3_4_12
	Mmapobjbig	4
	db	0f7h,0fah,008h,037h
	db	0fch,0f8h,06ch,038h
	db	0f9h,0f6h,008h,037h
	db	0f0h,0f8h,06ah,038h

obj_e3_4_13
	Mmapobjbig	4
	db	0f7h,0fdh,00ah,037h
	db	0f0h,0f7h,06ch,038h
	db	000h,0f9h,008h,037h
	db	0f9h,0f3h,00ah,037h

obj_e3_4_14
	Mmapobjbig	4
	db	0f7h,0fdh,00ch,037h
	db	0f0h,0f8h,008h,037h
	db	000h,0f8h,00ah,037h
	db	0f9h,0f3h,00ch,037h

obj_e3_4_15
	Mmapobjbig	4
	db	0f7h,0fch,00eh,037h
	db	0f2h,0f8h,00ah,037h
	db	0feh,0f8h,00ch,037h
	db	0f9h,0f4h,00eh,037h

obj_e3_4_16
	Mmapobjbig	2
	db	0fah,0f8h,00ch,077h
	db	0f6h,0f8h,00eh,077h

obj_e3_4_17
	Mmapobjbig	1
	db	0f8h,0f8h,00eh,037h
;---------------------------------------------------------------------
obj_e3_9_8
	MSoam_big	1
	db	0f8h,0f8h,068h,038h

obj_e3_9_9
	MSoam_big	1
	db	0f8h,0f8h,06ah,038h

obj_e3_9_10
	MSoam_big	1
	db	0f8h,0f8h,06ch,038h

obj_e3_9_11
	MSoam_big	1
	db	0f8h,0f8h,06eh,038h

obj_e3_9_12
	MSoam_big	4
	db	000h,0f0h,084h,078h
	db	000h,000h,084h,0f8h
	db	0f0h,000h,084h,0b8h
	db	0f0h,0f0h,084h,038h
;---------------------------------------------------------------------
;(planetcannon 1)

obj_e3_c_0
	MSoam_big	4
	db	0f0h,000h,084h,0b8h
	db	000h,000h,084h,0f8h
	db	000h,0f0h,084h,078h
	db	0f0h,0f0h,084h,038h

obj_e3_c_1
	MSoam_big	2
	db	0f8h,0f8h,06eh,038h
	db	0f6h,0fdh,00ch,038h

obj_e3_c_2
	MSoam_big	3
	db	0f8h,0f8h,06ch,038h
	db	0f2h,005h,00ch,038h
	db	0f6h,0fdh,00ch,038h

obj_e3_c_3
	MSoam_big	4
	db	0f8h,0f8h,06ah,038h
	db	0eeh,00dh,00ch,038h
	db	0f2h,005h,00ch,038h
	db	0f6h,0fdh,00ch,038h

obj_e3_c_4
	MSoam_big	4
	db	0eah,015h,00ch,038h
	db	0eeh,00dh,00ch,038h
	db	0f2h,005h,00ch,038h
	db	0f6h,0fdh,00ch,038h

obj_e3_c_5
	MSoam_big	4
	db	0eah,015h,00ch,038h
	db	0e6h,01dh,06ah,03ah
	db	0eeh,00dh,00ch,038h
	db	0f2h,005h,00ch,038h

obj_e3_c_6
	MSoam_big	3
	db	0eah,015h,00ch,038h
	db	0e6h,01dh,06ch,03ah
	db	0eeh,00dh,00ch,038h

obj_e3_c_7
	MSoam_big	2
	db	0eah,015h,00ch,038h
	db	0e6h,01dh,06eh,03ah

obj_e3_c_8
	MSoam_big	4
	db	0eeh,015h,084h,07ah
	db	0eeh,025h,084h,0fah
	db	0deh,025h,084h,0bah
	db	0deh,015h,084h,03ah

obj_e3_c_9
	MSoam_big	4
	db	0eeh,015h,088h,07ah
	db	0eeh,025h,088h,0fah
	db	0deh,025h,088h,0bah
	db	0deh,015h,088h,03ah

obj_e3_c_10
	MSoam_big	12
	db	0ech,033h,08eh,0fah
	db	0e0h,033h,08eh,0bah
	db	0fch,023h,08ah,0fah
	db	0fch,017h,08ah,07ah
	db	0ech,007h,08eh,07ah
	db	0e0h,007h,08eh,03ah
	db	0d0h,023h,08ah,0bah
	db	0d0h,017h,08ah,03ah
	db	0ech,017h,08ch,03ah
	db	0ech,023h,08ch,03ah
	db	0e0h,023h,08ch,03ah
	db	0e0h,017h,08ch,03ah

obj_e3_c_11
	MSoam_big	12
	db	0eeh,035h,08eh,0fch
	db	0deh,035h,08eh,0bch
	db	0feh,025h,08ah,0fch
	db	0feh,015h,08ah,07ch
	db	0eeh,005h,08eh,07ch
	db	0deh,005h,08eh,03ch
	db	0ceh,025h,08ah,0bch
	db	0ceh,015h,08ah,03ch
	db	0eeh,015h,08ch,03ch
	db	0eeh,025h,08ch,03ch
	db	0deh,025h,08ch,03ch
	db	0deh,015h,08ch,03ch
;---------------------------------------------------------------------
;(planetcannon 2)
obj_e3_c_12
	MSoam_big	4
	db	0f0h,000h,084h,0b8h
	db	000h,000h,084h,0f8h
	db	000h,0f0h,084h,078h
	db	0f0h,0f0h,084h,038h
obj_e3_c_13
	MSoam_big	2
	db	0f8h,0f8h,06eh,038h
	db	0f0h,0fbh,00eh,038h

obj_e3_c_14
	MSoam_big	3
	db	0e2h,000h,00eh,038h
	db	0f8h,0f8h,06ch,038h
	db	0f0h,0fbh,00eh,038h

obj_e3_c_15
	MSoam_big	4
	db	0d4h,005h,00eh,038h
	db	0e2h,000h,00eh,038h
	db	0f8h,0f8h,06ah,038h
	db	0f0h,0fbh,00eh,038h

obj_e3_c_16
	MSoam_big	4
	db	0c6h,00ah,00eh,038h
	db	0d4h,005h,00eh,038h
	db	0e2h,000h,00eh,038h
	db	0f0h,0fbh,00eh,038h

obj_e3_c_17
	MSoam_big	4
	db	0c6h,00ah,00eh,038h
	db	0bdh,00ch,06ah,03ah
	db	0d4h,005h,00eh,038h
	db	0e2h,000h,00eh,038h

obj_e3_c_18
	MSoam_big	3
	db	0c6h,00ah,00eh,038h
	db	0bdh,00ch,06ch,03ah
	db	0d4h,005h,00eh,038h

obj_e3_c_19
	MSoam_big	2
	db	0c6h,00ah,00eh,038h
	db	0bdh,00ch,06eh,03ah

obj_e3_c_20
	MSoam_big	4
	db	0b5h,014h,084h,0bah
	db	0c5h,014h,084h,0fah
	db	0c5h,004h,084h,07ah
	db	0b5h,004h,084h,03ah

obj_e3_c_21
	MSoam_big	4
	db	0b5h,014h,088h,0bah
	db	0c5h,014h,088h,0fah
	db	0c5h,004h,088h,07ah
	db	0b5h,004h,088h,03ah

obj_e3_c_22
	MSoam_big	12
	db	0c5h,022h,08eh,0fah
	db	0b5h,022h,08eh,0bah
	db	0c5h,0f6h,08eh,07ah
	db	0b5h,0f6h,08eh,03ah
	db	0d3h,014h,08ah,0fah
	db	0d3h,004h,08ah,07ah
	db	0a7h,014h,08ah,0bah
	db	0a7h,004h,08ah,03ah
	db	0b7h,012h,08ch,03ah
	db	0c3h,012h,08ch,03ah
	db	0c3h,006h,08ch,03ah
	db	0b5h,006h,08ch,03ah

obj_e3_c_23
	MSoam_big	12
	db	0c5h,024h,08eh,0fch
	db	0b5h,024h,08eh,0bch
	db	0c5h,0f4h,08eh,07ch
	db	0b5h,0f4h,08eh,03ch
	db	0d5h,014h,08ah,0fch
	db	0d5h,004h,08ah,07ch
	db	0a5h,014h,08ah,0bch
	db	0a5h,004h,08ah,03ch
	db	0b5h,014h,08ch,03ch
	db	0c5h,014h,08ch,03ch
	db	0c5h,004h,08ch,03ch
	db	0b5h,004h,08ch,03ch
;---------------------------------------------------------------------
;(planet cannon explode)&(missile explode)
obj_e3_8_0
	MSoam_big	1
	db	0f5h,0f4h,068h,038h

obj_e3_8_1
	MSoam_big	1
	db	0f5h,0f4h,06ah,038h

obj_e3_8_2
	MSoam_big	2
	db	0fch,0f6h,068h,038h
	db	0f5h,0f4h,06ah,036h

obj_e3_8_3
	MSoam_big	1
	db	0fch,0f6h,06ah,038h

obj_e3_8_4
	MSoam_big	2
	db	0f7h,0fbh,068h,038h
	db	0fch,0f6h,06ah,036h

obj_e3_8_5
	MSoam_big	1
	db	0f7h,0fch,06ah,038h

obj_e3_8_6
	MSoam_big	2
	db	0f5h,0f4h,068h,038h
	db	0f7h,0fch,06ah,036h

obj_e3_8_7
	MSoam_big	1
	db	0f7h,0fch,06ah,036h

obj_e3_8_8
	MSoam_big	1
	db	0f8h,0f8h,068h,038h

obj_e3_8_9
	MSoam_big	1
	db	0f8h,0f8h,06ah,038h

obj_e3_8_10
	MSoam_big	1
	db	0f8h,0f8h,06ch,038h

obj_e3_8_11
	MSoam_big	1
	db	0f8h,0f8h,008h,037h

obj_e3_8_12
	MSoam_big	4
	db	0f7h,0fbh,008h,037h
	db	0fch,0f8h,06ch,038h
	db	0f9h,0f5h,008h,037h
	db	0f0h,0f8h,06ah,038h

obj_e3_8_13
	MSoam_big	5
	db	0feh,000h,06ah,038h
	db	0f7h,0fdh,00ah,037h
	db	0f0h,0f7h,06ch,038h
	db	000h,0f9h,008h,037h
	db	0f9h,0f3h,00ah,037h

obj_e3_8_14
	MSoam_big	6
	db	0feh,000h,06ch,038h
	db	0f7h,0fdh,00ch,037h
	db	000h,0f8h,00ah,037h
	db	0f0h,0f8h,008h,037h
	db	0f9h,0f3h,00ch,037h
	db	0f2h,0f0h,06ah,038h

obj_e3_8_15
	MSoam_big	7
	db	0f2h,0feh,06ah,038h
	db	0feh,000h,008h,037h
	db	0f2h,0f8h,00ah,037h
	db	0f9h,0f4h,00eh,037h
	db	0f2h,0f0h,06ch,038h
	db	0f7h,0fch,00eh,037h
	db	0feh,0f8h,00ch,037h

obj_e3_8_16
	MSoam_big	7
	db	0f2h,0feh,06ch,038h
	db	0eah,0f6h,06ah,038h
	db	0feh,000h,00ah,037h
	db	0f6h,0f8h,00eh,077h
	db	0feh,0f0h,06ah,038h
	db	0fah,0f8h,00ch,077h
	db	0f2h,0eeh,008h,037h

obj_e3_8_17
	MSoam_big	7
	db	0f2h,0feh,008h,037h
	db	0feh,000h,00ch,037h
	db	006h,0f8h,06ah,038h
	db	0eah,0f6h,06ch,038h
	db	0feh,0f0h,06ch,038h
	db	0f2h,0eeh,00ah,037h
	db	0f8h,0f8h,00eh,037h

obj_e3_8_18
	MSoam_big	6
	db	0f2h,0feh,00ah,037h
	db	0feh,000h,00eh,037h
	db	006h,0f8h,06ch,038h
	db	0eah,0f6h,008h,037h
	db	0feh,0f0h,008h,037h
	db	0f2h,0eeh,00ch,037h

obj_e3_8_19
	MSoam_big	5
	db	0f2h,0feh,00ch,037h
	db	006h,0f8h,008h,037h
	db	0eah,0f6h,00ah,037h
	db	0feh,0f0h,00ah,037h
	db	0f2h,0eeh,00eh,037h

obj_e3_8_20
	MSoam_big	4
	db	0f2h,0feh,00eh,037h
	db	006h,0f8h,00ah,037h
	db	0eah,0f4h,00ch,037h
	db	0feh,0f0h,00ch,037h

obj_e3_8_21
	MSoam_big	3
	db	004h,0f8h,00eh,037h
	db	000h,0f0h,00eh,037h
	db	0eah,0f8h,00eh,037h


;(special enemy appear)
obj_e3_b_4
	MSoam_big	1
	db	0f8h,0f8h,068h,038h

obj_e3_b_5
	MSoam_big	1
	db	0f8h,0f8h,06ah,038h

obj_e3_b_6
	MSoam_big	1
	db	0f8h,0f8h,06ch,038h

obj_e3_b_7
	MSoam_big	1
	db	0f8h,0f8h,06eh,034h

obj_e3_b_8
	MSoam_big	5
	db	0f8h,0f8h,040h,035h
	db	0ffh,0f0h,084h,074h
	db	0ffh,0ffh,084h,0f4h
	db	0f0h,0ffh,084h,0b4h
	db	0f0h,0f0h,084h,034h

obj_e3_b_9
	MSoam_big	2
	db	0f8h,0f8h,042h,035h
	db	0f8h,0f8h,06eh,036h

obj_e3_b_10
	MSoam_big	2
	db	0f8h,0f8h,044h,035h
	db	0f8h,0f8h,06ch,036h

obj_e3_b_11
	MSoam_big	1
	db	0f8h,0f8h,042h,035h




;==========================================================================
; END END END END END END END END END END END END END END END END END END  
;==========================================================================
