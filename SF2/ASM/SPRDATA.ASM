	INCPUB	sprdata

;*********************************************************************
;*								*
;*			Sprites Data				* 
;*								*
;*********************************************************************
objcolpaltable
	dw	obj_colpal0
	dw	obj_colpal1
	dw	obj_colpal2
	dw	obj_colpal3
	dw	obj_colpal4
	dw	obj_colpal5
	dw	obj_colpal6
	dw	obj_colpal7

map_HPtamaPosTbl
	DW	(($19*8-2)<<8)+($e*8+2)+4
	DW	(($19*8-2)<<8)+($e*8+2)
	DW	(($19*8-2)<<8)+($e*8+2)+8
mis_HPtamaPosTbl
	DW	($be<<8)+$c6+8
	DW	($be<<8)+$c6
	DW	($be<<8)+$c6+16

arjettbl_x
;16 byte
	db	00,02,04,05,07,06,04,02,00,-2,-4,-5,-7,-6,-4,-2
arjettbl_y
;16 byte
	db	05,05,04,02,00,-2,-4,-5,-5,-5,-4,-2,00,02,04,05

arjettbl_char
	SprChrDataW	0,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	$68,colpal4,pri2,noflip,mm_obj_offset
	SprChrDataW	$6a,colpal2,pri2,noflip,mm_obj_offset

SpecialWeaponTbl		;(MISSION)
	SprChrDataW	$80,colpal0,pri3,noflip
	SprChrDataW	$82,colpal1,pri3,noflip
	SprChrDataW	$84,colpal0,pri3,noflip
	SprChrDataW	$86,colpal0,pri3,noflip

mm_SpecialWeaponTbl		;(MAP)
	SprChrDataW	sproff_spweapon+0,colpal3,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_spweapon+2,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_spweapon+4,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_spweapon+6,colpal3,pri2,noflip,mm_obj_offset

;---------------------------------------------------------------------
;*
;---------------------------------------------------------------------
pause_enemydata	;(mmx_entype)
	dw	30f6h	; 0 - sos(1)
	dw	30f6h	; 1 - sos(2)
	dw	30f6h	; 2 - sos(3)
	dw	30f5h	; 3 - missile
	dw	30e6h	; 4 - taiman
	dw	30fbh	; 5 - virus
	dw	30dbh	; 6 - wolf
	dw	30e7h	; 7 - ship(1)
	dw	32cbh	; 8 - mothership
	dw	36cch	; 9 - satellite
	dw	0000h	;10 - finalboss		;dummy
	dw	307Ch	;11 - itemplanet

;---------------------------------------------------------------------
;*
;---------------------------------------------------------------------
spr_warpselChrtbl
	SprChrDataW	$1df,colpal1,pri3,noflip,0
	SprChrDataW	$1df,colpal1,pri3,noflip,0
	SprChrDataW	$1ef,colpal1,pri3,noflip,0

;---------------------------------------------------------------------
;*			Data Table				*
;---------------------------------------------------------------------
;* Top Bit :0/1 ... Fire OFF/ON  
mm_enemytbl	;(23 byte)
	dw	$160		;0
	dw	$160!$8000	;1
	dw	$162!$8000	;2
	dw	$164!$8000	;3
	dw	$166		;4
	dw	$168		;5
	dw	$180!$8000	;6
	dw	$182		;7
	dw	$184		;8
	dw	$186		;9
	dw	$188!$8000	;10
	dw	$1a0!$8000	;11
	dw	$1a2!$8000	;12
	dw	$1a4!$8000	;13
	dw	$1a6!$8000	;14
	dw	$1a8		;15
	dw	$1c0		;16
	dw	$1c2!$8000	;17
	dw	$1c4		;18
	dw	$1c6!$8000	;19
	dw	$1c8		;20
	dw	$1e0		;21
	dw	$0ac!$8000	;22
	dw	$0ae!$8000	;23

mm_enemyjettbl	;(8 byte)
	SprChrDataW	$0,colpal0,pri0,noflip,0	;dummy
	SprChrDataW	$68,colpal4,pri3,noflip,0
	SprChrDataW	$6a,colpal2,pri3,noflip,0
	SprChrDataW	$6c,colpal3,pri3,noflip,0

mm_enemynametbl	;(14 byte)
	SprChrDataW	$1e2,colpal0,pri3,noflip,0	;zaco1
	SprChrDataW	$1e2,colpal0,pri3,noflip,0	;zaco2
	SprChrDataW	$1e2,colpal0,pri3,noflip,0	;zaco3
	SprChrDataW	$1f8,colpal0,pri3,noflip,0	;missile
	SprChrDataW	$1f2,colpal0,pri3,noflip,0	;special
	SprChrDataW	$1fc,colpal0,pri3,noflip,0	;virus
	SprChrDataW	$1e2,colpal0,pri3,noflip,0	;wolf

mm_enemytypetbl	;(28 byte)
	dw	(spr32x32_ZacoWaku1)&WM
	dw	(spr32x32_ZacoWaku2)&WM
	dw	(spr32x32_ZacoWaku1)&WM
	dw	(spr32x32_ZacoWaku2)&WM
	dw	(spr32x32_ZacoWaku1)&WM
	dw	(spr32x32_ZacoWaku2)&WM
	dw	(spr32x32_MissileWaku1)&WM
	dw	(spr32x32_MissileWaku2)&WM
	dw	(spr32x32_SpecialWaku1)&WM
	dw	(spr32x32_SpecialWaku2)&WM
	dw	(spr32x32_VirusWaku1)&WM
	dw	(spr32x32_VirusWaku2)&WM
	dw	(spr32x32_ZacoWaku1)&WM
	dw	(spr32x32_ZacoWaku2)&WM

kurukurutbl	;(missile)
;16 byte
	SprChrDataW	sproff_missile+0,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_missile+1,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_missile+2,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_missile+1,colpal0,pri2,yflip,mm_obj_offset
	SprChrDataW	sproff_missile+0,colpal0,pri2,yflip,mm_obj_offset
	SprChrDataW	sproff_missile+1,colpal0,pri2,xyflip,mm_obj_offset
	SprChrDataW	sproff_missile+2,colpal0,pri2,xflip,mm_obj_offset
	SprChrDataW	sproff_missile+1,colpal0,pri2,xflip,mm_obj_offset

Satellitetbl
	SprChrDataW	sproff_satellite,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_satellite,colpal1,pri2,noflip,mm_obj_offset


HoudaiTbl
;(64 byte)
	db	0fch,0f6h,0c0h,030h	;0
	db	0f9h,0f6h,0c1h,030h	;1
	db	0f8h,0f6h,0c2h,030h	;2
	db	0f8h,0f7h,0c3h,030h	;3
	db	0f8h,0fah,0d0h,030h	;4
	db	0f8h,0fdh,0c3h,0b0h	;5
	db	0f8h,0feh,0c2h,0b0h	;6
	db	0f9h,0feh,0c1h,0b0h	;7
	db	0fch,0feh,0c0h,0b0h	;8
	db	0ffh,0feh,0c1h,0f0h	;9
	db	000h,0feh,0c2h,0f0h	;10
	db	000h,0fdh,0c3h,0f0h	;11
	db	000h,0fah,0d0h,070h	;12
	db	000h,0f7h,0c3h,070h	;13
	db	000h,0f6h,0c2h,070h	;14
	db	0ffh,0f6h,0c1h,070h	;15

TameDamaXYTbl
	db	0fch,0f2h	;0
	db	0f8h,0f2h	;1
	db	0f6h,0f4h	;2
	db	0f4h,0f6h	;3
	db	0f2h,0fah	;4
	db	0f4h,0feh	;5
	db	0f6h,000h	;6
	db	0f8h,002h	;7
	db	0fch,002h	;8
	db	000h,002h	;9
	db	002h,000h	;10
	db	004h,0feh	;11
	db	006h,0fah	;12
	db	004h,0f6h	;13
	db	002h,0f4h	;14
	db	000h,0f2h	;15

TameDamaCharTbl
	SprChrDataW	$000,colpal2,pri2,noflip,mm_obj_offset	;dummy
	SprChrDataW	sproff_tamedama1,colpal4,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_tamedama2,colpal1,pri2,noflip,mm_obj_offset

SprSpecialTbl
	SprChrDataW	sproff_taiman+0,colpal1,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_taiman+2,colpal1,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_taiman+4,colpal1,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_taiman+2,colpal1,pri2,noflip,mm_obj_offset
SprVirusTbl
	SprChrDataW	sproff_virus+0,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_virus+1,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_virus+2,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_virus+1,colpal0,pri2,noflip,mm_obj_offset

SprWolfTbl
	SprChrDataW	sproff_wolf+0,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_wolf+1,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_wolf+2,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_wolf+1,colpal0,pri2,noflip,mm_obj_offset
EnemyJetXData
	db	00,03,04,03,00,-3,-4,-3
EnemyJetYData
	db	04,03,00,-3,-4,-3,00,03
EnemyJetData
	SprChrDataW	$00,colpal7,pri2,noflip,mm_obj_offset	;dummy
	SprChrDataW	$1af,colpal4,pri2,noflip,mm_obj_offset
	SprChrDataW	$1bf,colpal2,pri2,noflip,mm_obj_offset

BSJetData
	SprChrDataW	$06c,colpal2,pri2,noflip,0	;dummy
	SprChrDataW	$06c,colpal2,pri2,noflip,0
	SprChrDataW	$06e,colpal3,pri2,noflip,0

;=====================================================================
;*								*
;*	Sprite (32*32) Char Data				*
;*								*
;* (For example)							*
;*	kz_tpx <<< CX zahyou					*
;*	kz_tpy <<< CY zahyou					*
;*	kz_tpa <<< Character Pointer				*
;*	jsr	SetSprite_32x32					*
;=====================================================================
Sprite32x32Data
	Spr32x32AddrStart
	Spr32x32Addr	MotherShip	; (spr32x32_mothership)
	Spr32x32Addr	Corneria	; (spr32x32_corneria)
	Spr32x32Addr	CorneriaBL	;
	Spr32x32Addr	CorneriaRE	;
	Spr32x32Addr	SenryouPlanet_L	;
	Spr32x32Addr	SenryouPlanet_M	;
	Spr32x32Addr	SenryouPlanet_S	;

	Spr32x32Addr	ZacoWaku1	;
	Spr32x32Addr	ZacoWaku2	;
	Spr32x32Addr	MissileWaku1	;
	Spr32x32Addr	MissileWaku2	;
	Spr32x32Addr	SpecialWaku1	;
	Spr32x32Addr	SpecialWaku2	;
	Spr32x32Addr	VirusWaku1	;
	Spr32x32Addr	VirusWaku2	;
	Spr32x32Addr	FOX
	Spr32x32Addr	FALCO
	Spr32x32Addr	PEPPY
	Spr32x32Addr	SLIPPY
	Spr32x32Addr	MYU
	Spr32x32Addr	FAY
	Spr32x32Addr	SAND1
	Spr32x32Addr	SAND2

	Spr32x32Addr	RANKS
	Spr32x32Addr	RANKA
	Spr32x32Addr	RANKB
	Spr32x32Addr	RANKC
	Spr32x32Addr	RANKD
	Spr32x32Addr	RANKE


;=====================================================================
SprMotherShipData
	SprChrDataW	$128,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	$12a,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	$12c,colpal0,pri2,noflip,mm_obj_offset
	SprChrDataW	$12e,colpal0,pri2,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprCorneriaData	;(Mission)
	SprChrDataW	$48,colpal0,pri3,noflip
	SprChrDataW	$4a,colpal0,pri3,noflip
	SprChrDataW	$4c,colpal0,pri3,noflip
	SprChrDataW	$4e,colpal0,pri3,noflip
;---------------------------------------------------------------------
SprCorneriaBLData	;(Result)
	SprChrDataW	$0c,colpal2,pri3,noflip,mm_obj_offset
	SprChrDataW	$0e,colpal2,pri3,noflip,mm_obj_offset
	SprChrDataW	$2c,colpal2,pri3,noflip,mm_obj_offset
	SprChrDataW	$2e,colpal2,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprCorneriaReData	;(Result)
	SprChrDataW	$0c,colpal3,pri3,noflip,mm_obj_offset
	SprChrDataW	$0e,colpal3,pri3,noflip,mm_obj_offset
	SprChrDataW	$2c,colpal3,pri3,noflip,mm_obj_offset
	SprChrDataW	$2e,colpal3,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprSenryouPlanet_LData
	SprChrDataW	$c8,colpal7,pri2,noflip,mm_obj_offset
	SprChrDataW	$c8,colpal7,pri2,xflip,mm_obj_offset
	SprChrDataW	$ca,colpal7,pri2,noflip,mm_obj_offset
	SprChrDataW	$ca,colpal7,pri2,xflip,mm_obj_offset
;---------------------------------------------------------------------
SprSenryouPlanet_MData
	SprChrDataW	$cc,colpal7,pri2,noflip,mm_obj_offset
	SprChrDataW	$cc,colpal7,pri2,xflip,mm_obj_offset
	SprChrDataW	$ce,colpal7,pri2,noflip,mm_obj_offset
	SprChrDataW	$ea,colpal7,pri2,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprSenryouPlanet_SData
	SprChrDataW	$ec,colpal7,pri2,noflip,mm_obj_offset
	SprChrDataW	$ec,colpal7,pri2,xflip,mm_obj_offset
	SprChrDataW	$ee,colpal7,pri2,noflip,mm_obj_offset
	SprChrDataW	$ee,colpal7,pri2,xflip,mm_obj_offset
;---------------------------------------------------------------------
SprZacoWaku1Data
	SprChrDataW	$12a,colpal1,pri3,noflip,mm_obj_offset
	SprChrDataW	$12a,colpal1,pri3,xflip,mm_obj_offset
	SprChrDataW	$12a,colpal1,pri3,yflip,mm_obj_offset
	SprChrDataW	$12a,colpal1,pri3,xyflip,mm_obj_offset
;---------------------------------------------------------------------
SprZacoWaku2Data
	SprChrDataW	$1e6,colpal1,pri3,noflip,mm_obj_offset
	SprChrDataW	$1e6,colpal1,pri3,xflip,mm_obj_offset
	SprChrDataW	$1e6,colpal1,pri3,yflip,mm_obj_offset
	SprChrDataW	$1e6,colpal1,pri3,xyflip,mm_obj_offset
;---------------------------------------------------------------------
SprMissileWaku1Data
	SprChrDataW	$12a,colpal3,pri3,noflip,mm_obj_offset
	SprChrDataW	$12a,colpal3,pri3,xflip,mm_obj_offset
	SprChrDataW	$12a,colpal3,pri3,yflip,mm_obj_offset
	SprChrDataW	$12a,colpal3,pri3,xyflip,mm_obj_offset
;---------------------------------------------------------------------
SprMissileWaku2Data
	SprChrDataW	$1e6,colpal3,pri3,noflip,mm_obj_offset
	SprChrDataW	$1e6,colpal3,pri3,xflip,mm_obj_offset
	SprChrDataW	$1e6,colpal3,pri3,yflip,mm_obj_offset
	SprChrDataW	$1e6,colpal3,pri3,xyflip,mm_obj_offset
;---------------------------------------------------------------------
SprSpecialWaku1Data
	SprChrDataW	$12a,colpal2,pri3,noflip,mm_obj_offset
	SprChrDataW	$12a,colpal2,pri3,xflip,mm_obj_offset
	SprChrDataW	$12a,colpal2,pri3,yflip,mm_obj_offset
	SprChrDataW	$12a,colpal2,pri3,xyflip,mm_obj_offset
;---------------------------------------------------------------------
SprSpecialWaku2Data
	SprChrDataW	$1e6,colpal2,pri3,noflip,mm_obj_offset
	SprChrDataW	$1e6,colpal2,pri3,xflip,mm_obj_offset
	SprChrDataW	$1e6,colpal2,pri3,yflip,mm_obj_offset
	SprChrDataW	$1e6,colpal2,pri3,xyflip,mm_obj_offset
;---------------------------------------------------------------------
SprVirusWaku1Data
	SprChrDataW	$12a,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$12a,colpal0,pri3,xflip,mm_obj_offset
	SprChrDataW	$12a,colpal0,pri3,yflip,mm_obj_offset
	SprChrDataW	$12a,colpal0,pri3,xyflip,mm_obj_offset
;---------------------------------------------------------------------
SprVirusWaku2Data
	SprChrDataW	$1e6,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$1e6,colpal0,pri3,xflip,mm_obj_offset
	SprChrDataW	$1e6,colpal0,pri3,yflip,mm_obj_offset
	SprChrDataW	$1e6,colpal0,pri3,xyflip,mm_obj_offset
;---------------------------------------------------------------------
SprFoxData
	SprChrDataW	$100,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$102,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$120,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$122,colpal0,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprFalcoData
	SprChrDataW	$104,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$106,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$124,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$126,colpal0,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprPeppyData
	SprChrDataW	$108,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$10a,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$128,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$12a,colpal0,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprSlippyData
	SprChrDataW	$10c,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$10e,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$12c,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$12e,colpal0,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprMyuData
	SprChrDataW	$140,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$142,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$160,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$162,colpal0,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprFayData
	SprChrDataW	$144,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$146,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$164,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$166,colpal0,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprSand1Data
	SprChrDataW	$0e0,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$0e2,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$0e4,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$0e6,colpal0,pri3,noflip,mm_obj_offset
;---------------------------------------------------------------------
SprSand2Data
	SprChrDataW	$0e2,colpal0,pri3,xflip,mm_obj_offset
	SprChrDataW	$0e0,colpal0,pri3,xflip,mm_obj_offset
	SprChrDataW	$0e6,colpal0,pri3,xflip,mm_obj_offset
	SprChrDataW	$0e4,colpal0,pri3,xflip,mm_obj_offset
;---------------------------------------------------------------------
SprRankSData
	SprChrDataW	$02c,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$02c,colpal0,pri3,xflip,mm_obj_offset
	SprChrDataW	$02e,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$02e,colpal0,pri3,xflip,mm_obj_offset
;---------------------------------------------------------------------
SprRankAData
	SprChrDataW	$04c,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$04c,colpal0,pri3,xflip,mm_obj_offset
	SprChrDataW	$04e,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$04e,colpal0,pri3,xflip,mm_obj_offset
;---------------------------------------------------------------------
SprRankBData
	SprChrDataW	$06c,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$06e,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$06c,colpal0,pri3,yflip,mm_obj_offset
	SprChrDataW	$06e,colpal0,pri3,yflip,mm_obj_offset
;---------------------------------------------------------------------
SprRankCData
	SprChrDataW	$08c,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$08e,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$08c,colpal0,pri3,yflip,mm_obj_offset
	SprChrDataW	$08e,colpal0,pri3,yflip,mm_obj_offset
;---------------------------------------------------------------------
SprRankDData
	SprChrDataW	$0ac,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$0ae,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$0ac,colpal0,pri3,yflip,mm_obj_offset
	SprChrDataW	$0ae,colpal0,pri3,yflip,mm_obj_offset
;---------------------------------------------------------------------
SprRankEData
	SprChrDataW	$0cc,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$0ce,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$0cc,colpal0,pri3,yflip,mm_obj_offset
	SprChrDataW	$0ce,colpal0,pri3,yflip,mm_obj_offset
;---------------------------------------------------------------------
;*********************************************************************
;*								*
;*		Block Trans Data				*
;*								*
;*********************************************************************
SpriteBlockAnime
	SprBlockAnimeAddrStart
;	SprBlockAnimeAddr	PauseON
;	SprBlockAnimeAddr	PauseOFF
	SprBlockAnimeAddr	cannonCharge
	SprBlockAnimeAddr	Record
	SprBlockAnimeAddr	AndorosEye
;	SprBlockAnimeAddr	AndorosHandR
;	SprBlockAnimeAddr	AndorosHandL
	SprBlockAnimeAddr	TamaCharge
	SprBlockAnimeAddr	Torituki
	SprBlockAnimeAddr	Kirari
	SprBlockAnimeAddr	Expert

;-----------------------------------------------------------------------------------------------
	IFEQ	1
BlockAnime_PAUSEON
	SprBlockAnime	4,pause1
	SprBlockAnime	4,pause2
	SprBlockAnime	4,pause3
	SprBlockAnimeWait

BlockAnime_PAUSEOFF
	SprBlockAnime	4,pause2
	SprBlockAnime	4,pause1
	SprBlockAnimeEnd
	ENDC

BlockAnime_cannonCharge
	SprBlockAnime	3,pccharge0
	SprBlockAnime	3,pccharge1
	SprBlockAnime	3,pccharge2
	SprBlockAnime	3,pccharge3
blockanmjump_cannonCharge
	SprBlockAnime	3,pccharge4
	SprBlockAnime	3,pccharge5
	SprBlockAnime	3,pccharge6
	SprBlockAnime	3,pccharge5
	SprBlockAnimeJump	blockanmjump_cannonCharge

BlockAnime_Record
	SprBlockAnime	8,record1
	SprBlockAnime	8,record2
	SprBlockAnime	8,record3
	SprBlockAnimeJump	BlockAnime_Record

BlockAnime_AndorosEye
	SprBlockAnime	2,eye1
	SprBlockAnime	2,eye2
	SprBlockAnime	2,eye3
	SprBlockAnime	2,eye4
	SprBlockAnime	2,eye3
	SprBlockAnime	2,eye2
	SprBlockAnimeJump	BlockAnime_AndorosEye

	IFEQ	1
BlockAnime_AndorosHandR
	SprBlockAnime	6,handr1
	SprBlockAnime	2,handr2
	SprBlockAnime	6,handr3
	SprBlockAnime	2,handr2
	SprBlockAnimeJump	BlockAnime_AndorosHandR
BlockAnime_AndorosHandL
	SprBlockAnime	6,handl1
	SprBlockAnime	2,handl2
	SprBlockAnime	6,handl3
	SprBlockAnime	2,handl2
	SprBlockAnimeJump	BlockAnime_AndorosHandL
	ENDC

BlockAnime_TamaCharge
	SprBlockAnime	2,sacharge0
	SprBlockAnime	2,sacharge1
	SprBlockAnime	2,sacharge2
	SprBlockAnime	2,sacharge3
	SprBlockAnime	2,sacharge4
	SprBlockAnime	2,sacharge5
	SprBlockAnime	2,sacharge6
	SprBlockAnime	2,sacharge7
	SprBlockAnimeJump	BlockAnime_TamaCharge

BlockAnime_Torituki
	SprBlockAnime	4,satorituki0
	SprBlockAnime	4,satorituki1
	SprBlockAnime	4,satorituki2
	SprBlockAnime	4,satorituki3
	SprBlockAnime	4,satorituki4
	SprBlockAnimeEnd

BlockAnime_Kirari
	SprBlockAnime	4,kirari0
	SprBlockAnime	4,kirari1
	SprBlockAnime	4,kirari2
	SprBlockAnime	4,kirari3
	SprBlockAnime	4,kirari4
	SprBlockAnime	4,kirari5
	SprBlockAnime	4,kirari6
	SprBlockAnimeEnd

BlockAnime_Expert
	SprBlockAnime	4,expert0
	SprBlockAnime	4,expert1
	SprBlockAnime	4,expert2
	SprBlockAnimeWait
;-----------------------------------------------------------------------------------------------
SpriteBlockData
	SprBlockAddrStart	;sprblock_
	SprBlockAddr	CorneriaFell
	SprBlockAddr	ShootDown
	SprBlockAddr	MissionClear
;	SprBlockAddr	FOX
;	SprBlockAddr	FALCO
;	SprBlockAddr	PEPPY
;	SprBlockAddr	SLIPPY
;	SprBlockAddr	MYU
;	SprBlockAddr	FAY
;	SprBlockAddr	SAND1
;	SprBlockAddr	SAND2
;	SPrBlockAddr	PAUSE1
;	SPrBlockAddr	PAUSE2
;	SPrBlockAddr	PAUSE3
	SPrBlockAddr	pccharge0
	SPrBlockAddr	pccharge1
	SPrBlockAddr	pccharge2
	SPrBlockAddr	pccharge3
	SPrBlockAddr	pccharge4
	SPrBlockAddr	pccharge5
	SPrBlockAddr	pccharge6
	SPrBlockAddr	record1
	SPrBlockAddr	record2
	SPrBlockAddr	record3
	SPrBlockAddr	eye1
	SPrBlockAddr	eye2
	SPrBlockAddr	eye3
	SPrBlockAddr	eye4

;	SPrBlockAddr	handL1
;	SPrBlockAddr	handL2
;	SPrBlockAddr	handL3
;	SPrBlockAddr	handR1
;	SPrBlockAddr	handR2
;	SPrBlockAddr	handR3

	SPrBlockAddr	sacharge0
	SPrBlockAddr	sacharge1
	SPrBlockAddr	sacharge2
	SPrBlockAddr	sacharge3
	SPrBlockAddr	sacharge4
	SPrBlockAddr	sacharge5
	SPrBlockAddr	sacharge6
	SPrBlockAddr	sacharge7

	SPrBlockAddr	satorituki0
	SPrBlockAddr	satorituki1
	SPrBlockAddr	satorituki2
	SPrBlockAddr	satorituki3
	SPrBlockAddr	satorituki4

	SPrBlockAddr	kirari0
	SPrBlockAddr	kirari1
	SPrBlockAddr	kirari2
	SPrBlockAddr	kirari3
	SPrBlockAddr	kirari4
	SPrBlockAddr	kirari5
	SPrBlockAddr	kirari6

	SPrBlockAddr	expert0
	SPrBlockAddr	expert1
	SPrBlockAddr	expert2

;-----------------------------------------------------------------------------------------------
SprCorneriaFellData
_sprbaseCX = $19*8
_sprbaseCY = $06*8-1
	km_datacntbig	W,SprCorneriaFellData

	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+010h)&BM,064h,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+010h)&BM,062h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+010h)&BM,060h,032h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+000h)&BM,044h,036h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+000h)&BM,042h,036h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+000h)&BM,040h,036h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+0f0h)&BM,024h,036h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+0f0h)&BM,022h,036h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+0f0h)&BM,020h,036h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+0e0h)&BM,08ah,036h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+0e0h)&BM,088h,036h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+0e0h)&BM,086h,036h


	IFEQ	1
	SpriteDataW	_sprbaseCX-32,_sprbaseCY-32-8,$c0,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-32-8,$c2,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-32-8,$c4,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY-32-8,$c6,colpal1,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY-16,$e0,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-16,$e2,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-16,$e4,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY-16,$e6,colpal3,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY+00,$100,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+00,$102,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$104,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+00,$106,colpal3,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY+16,$120,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+16,$122,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+16,$124,colpal3,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+16,$126,colpal3,pri3,noflip,mm_obj_offset
	ENDC
SprCorneriaFellDataEND
;-----------------------------------------------------------------------------------------------
SprShootDownData
_sprbaseCX = $19*8
_sprbaseCY = $06*8-1
	km_datacntbig	W,SprShootDownData
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+010h)&BM,06ah,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+010h)&BM,068h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+010h)&BM,066h,032h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+000h)&BM,04ah,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+000h)&BM,048h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+000h)&BM,046h,032h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+0f0h)&BM,02ah,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+0f0h)&BM,028h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+0f0h)&BM,026h,032h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+0e0h)&BM,0aah,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+0e0h)&BM,0a8h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+0e0h)&BM,0a6h,032h

	IFEQ	1
	SpriteDataW	_sprbaseCX-32,_sprbaseCY-32-8,$c8,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-32-8,$ca,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-32-8,$cc,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY-32-8,$ce,colpal1,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY-16,$e8,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-16,$ea,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-16,$ec,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY-16,$ee,colpal1,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY-00,$108,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-00,$10a,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-00,$10c,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY-00,$10e,colpal1,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY+16,$128,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+16,$12a,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+16,$12c,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+16,$12e,colpal1,pri3,noflip,mm_obj_offset
	ENDC
SprShootDownDataEnd
;-----------------------------------------------------------------------------------------------
SprMissionClearData
_sprbaseCX = $19*8
_sprbaseCY = $06*8-1
	km_datacntbig	W,SprMissionClearData
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+010h)&BM,0c4h,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+010h)&BM,0c2h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+010h)&BM,0c0h,032h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+000h)&BM,0a4h,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+000h)&BM,0a2h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+000h)&BM,0a0h,032h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+0f0h)&BM,084h,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+0f0h)&BM,082h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+0f0h)&BM,080h,032h
	db	(_sprbaseCX+008h)&BM,(_sprbaseCY+0e0h)&BM,0cah,032h
	db	(_sprbaseCX+0f8h)&BM,(_sprbaseCY+0e0h)&BM,0c8h,032h
	db	(_sprbaseCX+0e8h)&BM,(_sprbaseCY+0e0h)&BM,0c6h,032h

	IFEQ	1
	SpriteDataW	_sprbaseCX-32,_sprbaseCY-32-8,$0a8,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-32-8,$0aa,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-32-8,$0ac,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY-32-8,$0ae,colpal1,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY-16,$140,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-16,$142,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-16,$144,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY-16,$146,colpal1,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY-00,$160,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-00,$162,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-00,$164,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY-00,$166,colpal1,pri3,noflip,mm_obj_offset

	SpriteDataW	_sprbaseCX-32,_sprbaseCY+16,$180,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+16,$182,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+16,$184,colpal1,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+16,$186,colpal1,pri3,noflip,mm_obj_offset
	ENDC
SprMissionClearDataEnd
;-----------------------------------------------------------------------------------------------
	IFEQ	1
SprFoxData
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprFoxData
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-24,$148,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-24,$14a,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-08,$168,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-08,$16a,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+08,$188,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+08,$18a,colpal0,pri3,noflip,mm_obj_offset
SprFoxDataEnd
;-----------------------------------------------------------------------------------------------
SprFalcoData
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprFalcoData
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-24,$14c,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-24,$14e,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-08,$16c,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-08,$16e,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+08,$18c,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+08,$18e,colpal0,pri3,noflip,mm_obj_offset
SprFalcoDataEnd
;-----------------------------------------------------------------------------------------------
SprPeppyData
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPeppyData
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-24,$1a0,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-24,$1a2,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-08,$1c0,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-08,$1c2,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+08,$1e0,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+08,$1e2,colpal0,pri3,noflip,mm_obj_offset
SprPeppyDataEnd
;-----------------------------------------------------------------------------------------------
SprSlippyData
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprSlippyData
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-24,$1a4,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-24,$1a6,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-08,$1c4,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-08,$1c6,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+08,$1e4,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+08,$1e6,colpal0,pri3,noflip,mm_obj_offset
SprSlippyDataEnd
;-----------------------------------------------------------------------------------------------
SprMyuData
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprMyuData
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-24,$1a8,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-24,$1aa,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-08,$1c8,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-08,$1ca,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+08,$1e8,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+08,$1ea,colpal0,pri3,noflip,mm_obj_offset
SprMyuDataEnd
;-----------------------------------------------------------------------------------------------
SprFayData
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprFayData
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-24,$1ac,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-24,$1ae,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-08,$1cc,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-08,$1ce,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+08,$1ec,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+08,$1ee,colpal0,pri3,noflip,mm_obj_offset
SprFayDataEnd
;-----------------------------------------------------------------------------------------------
SprSand1Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprSand1Data
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-24,$80,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-24,$82,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-08,$90,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-08,$92,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+08,$80,colpal0,pri3,yflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+08,$82,colpal0,pri3,yflip,mm_obj_offset
SprSand1DataEnd
;-----------------------------------------------------------------------------------------------
SprSand2Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprSand2Data
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-24,$82,colpal0,pri3,xflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-24,$80,colpal0,pri3,xflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-08,$92,colpal0,pri3,xyflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-08,$90,colpal0,pri3,xyflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+08,$82,colpal0,pri3,xyflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+08,$80,colpal0,pri3,xyflip,mm_obj_offset
SprSand2DataEnd
	ENDC
;-----------------------------------------------------------------------------------------------
	IFEQ	1
SprPause1Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPause1Data
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$2e,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+00,$2e,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+32,_sprbaseCY+00,$2e,colpal0,pri3,noflip,mm_obj_offset
SprPause1DataEnd
;-----------------------------------------------------------------------------------------------
SprPause2Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPause2Data
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$042,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+00,$043,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+32,_sprbaseCY+00,$042,colpal0,pri3,xflip,mm_obj_offset
SprPause2DataEnd
;-----------------------------------------------------------------------------------------------
SprPause3Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPause3Data
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$124,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+00,$126,colpal0,pri3,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+32,_sprbaseCY+00,$128,colpal0,pri3,noflip,mm_obj_offset
SprPause3DataEnd
	ENDC
;-----------------------------------------------------------------------------------------------
SprPccharge0Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPccharge0Data
	SpriteDataW	_sprbaseCX-08,_sprbaseCY-08,$68,colpal5,pri2,noflip,mm_obj_offset
SprPccharge0DataEnd
;-----------------------------------------------------------------------------------------------
SprPccharge1Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPccharge1Data
	SpriteDataW	_sprbaseCX-08,_sprbaseCY-08,$6a,colpal5,pri2,noflip,mm_obj_offset
SprPccharge1DataEnd
;-----------------------------------------------------------------------------------------------
SprPccharge2Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPccharge2Data
	SpriteDataW	_sprbaseCX-08,_sprbaseCY-08,$6c,colpal5,pri2,noflip,mm_obj_offset
SprPccharge2DataEnd
;-----------------------------------------------------------------------------------------------
SprPccharge3Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPccharge3Data
	SpriteDataW	_sprbaseCX-08,_sprbaseCY-08,$6e,colpal5,pri2,noflip,mm_obj_offset
SprPccharge3DataEnd
;-----------------------------------------------------------------------------------------------
SprPccharge4Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPccharge4Data
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-16,$14a,colpal5,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-16,$14a,colpal5,pri2,xflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+00,$14a,colpal5,pri2,yflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$14a,colpal5,pri2,xyflip,mm_obj_offset
SprPccharge4DataEnd
;-----------------------------------------------------------------------------------------------
SprPccharge5Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPccharge5Data
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-16,$14c,colpal5,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-16,$14c,colpal5,pri2,xflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+00,$14c,colpal5,pri2,yflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$14c,colpal5,pri2,xyflip,mm_obj_offset
SprPccharge5DataEnd
;-----------------------------------------------------------------------------------------------
SprPccharge6Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprPccharge6Data
	SpriteDataW	_sprbaseCX-16,_sprbaseCY-16,$14e,colpal5,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY-16,$14e,colpal5,pri2,xflip,mm_obj_offset
	SpriteDataW	_sprbaseCX-16,_sprbaseCY+00,$14e,colpal5,pri2,yflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$14e,colpal5,pri2,xyflip,mm_obj_offset
SprPccharge6DataEnd
;-----------------------------------------------------------------------------------------------
SprRecord1Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprRecord1Data
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$180,colpal1,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+00,$182,colpal1,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+32,_sprbaseCY+00,$184,colpal1,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+48,_sprbaseCY+00,$186,colpal1,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+64,_sprbaseCY+00,$188,colpal1,pri2,noflip,mm_obj_offset
SprRecord1DataEnd
;-----------------------------------------------------------------------------------------------
SprRecord2Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprRecord2Data
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$180,colpal2,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+00,$182,colpal2,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+32,_sprbaseCY+00,$184,colpal2,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+48,_sprbaseCY+00,$186,colpal2,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+64,_sprbaseCY+00,$188,colpal2,pri2,noflip,mm_obj_offset
SprRecord2DataEnd
;-----------------------------------------------------------------------------------------------
SprRecord3Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprRecord3Data
	SpriteDataW	_sprbaseCX+00,_sprbaseCY+00,$180,colpal3,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+16,_sprbaseCY+00,$182,colpal3,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+32,_sprbaseCY+00,$184,colpal3,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+48,_sprbaseCY+00,$186,colpal3,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+64,_sprbaseCY+00,$188,colpal3,pri2,noflip,mm_obj_offset
SprRecord3DataEnd
;-----------------------------------------------------------------------------------------------
Spreye1Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprEye1Data
	db	008h,010h,002h+$40,0f8h
	db	018h,010h,000h+$40,0f8h
	db	008h,000h,00ah+$40,0f8h
	db	018h,000h,008h+$40,0f8h
	db	0f8h,010h,002h+$40,0b8h
	db	0e8h,010h,000h+$40,0b8h
	db	0f8h,000h,00ah+$40,0b8h
	db	0e8h,000h,008h+$40,0b8h
	db	018h,0e0h,006h+$40,038h
	db	008h,0e0h,004h+$40,038h
	db	0f8h,0e0h,002h+$40,038h
	db	0e8h,0e0h,000h+$40,038h
	db	018h,0f0h,00eh+$40,038h
	db	008h,0f0h,00ch+$40,038h
	db	0f8h,0f0h,00ah+$40,038h
	db	0e8h,0f0h,008h+$40,038h
Spreye1DataEnd
;-----------------------------------------------------------------------------------------------
Spreye2Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprEye2Data
	db	008h,010h,002h+$40,0fah
	db	018h,010h,000h+$40,0fah
	db	008h,000h,00ah+$40,0fah
	db	018h,000h,008h+$40,0fah
	db	0f8h,010h,002h+$40,0bah
	db	0e8h,010h,000h+$40,0bah
	db	0f8h,000h,00ah+$40,0bah
	db	0e8h,000h,008h+$40,0bah
	db	018h,0e0h,006h+$40,03ah
	db	008h,0e0h,004h+$40,03ah
	db	0f8h,0e0h,002h+$40,03ah
	db	0e8h,0e0h,000h+$40,03ah
	db	018h,0f0h,00eh+$40,03ah
	db	008h,0f0h,00ch+$40,03ah
	db	0f8h,0f0h,00ah+$40,03ah
	db	0e8h,0f0h,008h+$40,03ah
Spreye2DataEnd
;-----------------------------------------------------------------------------------------------
Spreye3Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprEye3Data
	db	008h,010h,002h+$40,0fch
	db	018h,010h,000h+$40,0fch
	db	008h,000h,00ah+$40,0fch
	db	018h,000h,008h+$40,0fch
	db	0f8h,010h,002h+$40,0bch
	db	0e8h,010h,000h+$40,0bch
	db	0f8h,000h,00ah+$40,0bch
	db	0e8h,000h,008h+$40,0bch
	db	018h,0e0h,006h+$40,03ch
	db	008h,0e0h,004h+$40,03ch
	db	0f8h,0e0h,002h+$40,03ch
	db	0e8h,0e0h,000h+$40,03ch
	db	018h,0f0h,00eh+$40,03ch
	db	008h,0f0h,00ch+$40,03ch
	db	0f8h,0f0h,00ah+$40,03ch
	db	0e8h,0f0h,008h+$40,03ch
Spreye3DataEnd
;-----------------------------------------------------------------------------------------------
Spreye4Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprEye4Data
	db	008h,010h,002h+$40,0feh
	db	018h,010h,000h+$40,0feh
	db	008h,000h,00ah+$40,0feh
	db	018h,000h,008h+$40,0feh
	db	0f8h,010h,002h+$40,0beh
	db	0e8h,010h,000h+$40,0beh
	db	0f8h,000h,00ah+$40,0beh
	db	0e8h,000h,008h+$40,0beh
	db	018h,0e0h,006h+$40,03eh
	db	008h,0e0h,004h+$40,03eh
	db	0f8h,0e0h,002h+$40,03eh
	db	0e8h,0e0h,000h+$40,03eh
	db	018h,0f0h,00eh+$40,03eh
	db	008h,0f0h,00ch+$40,03eh
	db	0f8h,0f0h,00ah+$40,03eh
	db	0e8h,0f0h,008h+$40,03eh
Spreye4DataEnd
;-----------------------------------------------------------------------------------------------
	IFEQ	1
SprHandR1Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprHandR1Data
	db	0e0h,008h,066h+$40,070h
	db	0f0h,008h,064h+$40,070h
	db	000h,008h,062h+$40,070h
	db	010h,008h,060h+$40,070h
	db	0e0h,0f8h,046h+$40,070h
	db	0f0h,0f8h,044h+$40,070h
	db	000h,0f8h,042h+$40,070h
	db	010h,0f8h,040h+$40,070h
	db	0e0h,0e8h,026h+$40,070h
	db	0f0h,0e8h,024h+$40,070h
	db	000h,0e8h,022h+$40,070h
	db	010h,0e8h,020h+$40,070h
SprHandR1DataEnd
;-----------------------------------------------------------------------------------------------
SprHandR2Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprHandR2Data
	db	0e0h,008h,06eh+$40,070h
	db	0f0h,008h,06ch+$40,070h
	db	000h,008h,06ah+$40,070h
	db	010h,008h,068h+$40,070h
	db	0e0h,0f8h,04eh+$40,070h
	db	0f0h,0f8h,04ch+$40,070h
	db	000h,0f8h,04ah+$40,070h
	db	010h,0f8h,048h+$40,070h
	db	0e0h,0e8h,02eh+$40,070h
	db	0f0h,0e8h,02ch+$40,070h
	db	000h,0e8h,02ah+$40,070h
	db	010h,0e8h,028h+$40,070h
SprHandR2DataEnd
;-----------------------------------------------------------------------------------------------
SprHandR3Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprHandR3Data
	db	0e0h,008h,08eh+$40,070h
	db	0f0h,008h,08ch+$40,070h
	db	000h,008h,08ah+$40,070h
	db	010h,008h,088h+$40,070h
	db	0e0h,0f8h,0a6h+$40,070h
	db	0f0h,0f8h,0a4h+$40,070h
	db	000h,0f8h,0a2h+$40,070h
	db	010h,0f8h,0a0h+$40,070h
	db	0e0h,0e8h,086h+$40,070h
	db	0f0h,0e8h,084h+$40,070h
	db	000h,0e8h,082h+$40,070h
	db	010h,0e8h,080h+$40,070h
SprHandR3DataEnd
;-----------------------------------------------------------------------------------------------
SprHandL1Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprHandL1Data
	db	010h,008h,066h+$40,030h
	db	000h,008h,064h+$40,030h
	db	0f0h,008h,062h+$40,030h
	db	0e0h,008h,060h+$40,030h
	db	010h,0f8h,046h+$40,030h
	db	000h,0f8h,044h+$40,030h
	db	0f0h,0f8h,042h+$40,030h
	db	0e0h,0f8h,040h+$40,030h
	db	010h,0e8h,026h+$40,030h
	db	000h,0e8h,024h+$40,030h
	db	0f0h,0e8h,022h+$40,030h
	db	0e0h,0e8h,020h+$40,030h
SprHandL1DataEnd
;-----------------------------------------------------------------------------------------------
SprHandL2Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprHandL2Data
	db	010h,008h,06eh+$40,030h
	db	000h,008h,06ch+$40,030h
	db	0f0h,008h,06ah+$40,030h
	db	0e0h,008h,068h+$40,030h
	db	010h,0f8h,04eh+$40,030h
	db	000h,0f8h,04ch+$40,030h
	db	0f0h,0f8h,04ah+$40,030h
	db	0e0h,0f8h,048h+$40,030h
	db	010h,0e8h,02eh+$40,030h
	db	000h,0e8h,02ch+$40,030h
	db	0f0h,0e8h,02ah+$40,030h
	db	0e0h,0e8h,028h+$40,030h
SprHandL2DataEnd
;-----------------------------------------------------------------------------------------------
SprHandL3Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprHandL3Data
	db	010h,008h,08eh+$40,030h
	db	000h,008h,08ch+$40,030h
	db	0f0h,008h,08ah+$40,030h
	db	0e0h,008h,088h+$40,030h
	db	010h,0f8h,0a6h+$40,030h
	db	000h,0f8h,0a4h+$40,030h
	db	0f0h,0f8h,0a2h+$40,030h
	db	0e0h,0f8h,0a0h+$40,030h
	db	010h,0e8h,086h+$40,030h
	db	000h,0e8h,084h+$40,030h
	db	0f0h,0e8h,082h+$40,030h
	db	0e0h,0e8h,080h+$40,030h
SprHandL3DataEnd
;-----------------------------------------------------------------------------------------------
	ENDC

SprSACharge0Data
	km_datacnt	W,SprSACharge0Data
	db	0f2h,006h,057h,036h
	db	00ah,0fch,057h,036h
	db	0f4h,0f4h,057h,034h
	db	0fch,006h,057h,034h
	db	002h,0f6h,057h,032h
	db	0fch,0ebh,057h,036h
SprSACharge0DataEnd

SprSACharge1Data
	km_datacnt	W,SprSACharge1Data
	db	0f3h,005h,057h,036h
	db	008h,0fch,057h,034h
	db	0f5h,0f5h,057h,034h
	db	0fch,004h,057h,032h
	db	007h,007h,057h,036h
	db	0fch,0ech,057h,036h
SprSACharge1DataEnd

SprSACharge2Data
	km_datacnt	W,SprSACharge2Data
	db	0f4h,004h,057h,034h
	db	006h,0fch,057h,034h
	db	0f6h,0f6h,057h,032h
	db	006h,006h,057h,036h
	db	0ebh,0fch,057h,036h
	db	0fch,0eeh,057h,036h
SprSACharge2DataEnd

SprSACharge3Data
	km_datacnt	W,SprSACharge3Data
	db	0f5h,003h,057h,034h
	db	004h,0fch,057h,032h
	db	007h,0f1h,057h,036h
	db	0ech,0fch,057h,036h
	db	005h,005h,057h,036h
	db	0fch,0f0h,057h,034h

SprSACharge3DataEnd

SprSACharge4Data
	km_datacnt	W,SprSACharge4Data
	db	0f6h,002h,057h,032h
	db	0fch,00dh,057h,036h
	db	006h,0f2h,057h,036h
	db	0eeh,0fch,057h,036h
	db	004h,004h,057h,034h
	db	0fch,0f2h,057h,034h
SprSACharge4DataEnd

SprSACharge5Data
	km_datacnt	W,SprSACharge5Data
	db	0f0h,0f0h,057h,036h
	db	0fch,00ch,057h,036h
	db	005h,0f3h,057h,036h
	db	0f0h,0fch,057h,034h
	db	003h,003h,057h,034h
	db	0fch,0f4h,057h,032h

SprSACharge5DataEnd

SprSACharge6Data
	km_datacnt	W,SprSACharge6Data
	db	00dh,0fch,057h,036h
	db	0f2h,0f2h,057h,036h
	db	0fch,00ah,057h,036h
	db	004h,0f4h,057h,034h
	db	0f2h,0fch,057h,034h
	db	002h,002h,057h,032h
SprSACharge6DataEnd

SprSACharge7Data
	km_datacnt	W,SprSACharge7Data
	db	0f0h,008h,057h,036h
	db	00ch,0fch,057h,036h
	db	0f3h,0f3h,057h,036h
	db	0fch,008h,057h,034h
	db	003h,0f5h,057h,034h
	db	0f4h,0fch,057h,032h
SprSACharge7DataEnd
;-----------------------------------------------------------------------------------------------
SprSATorituki0Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprSaTorituki0Data
	SpriteDataW	_sprbaseCX+$f8,_sprbaseCY+$f8,$68,colpal4,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+$f8,_sprbaseCY+$f8,$c6,colpal0,pri2,noflip,mm_obj_offset
SprSATorituki0DataEnd

SprSATorituki1Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprSaTorituki1Data
	SpriteDataW	_sprbaseCX+$f8,_sprbaseCY+$f8,$6a,colpal1,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+$f8,_sprbaseCY+$f8,$c6,colpal0,pri2,noflip,mm_obj_offset
SprSATorituki1DataEnd

SprSATorituki2Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprSaTorituki2Data
	SpriteDataW	_sprbaseCX+$f8,_sprbaseCY+$f8,$6c,colpal5,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+$f8,_sprbaseCY+$f8,$c6,colpal0,pri2,noflip,mm_obj_offset
SprSATorituki2DataEnd

SprSATorituki3Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprSaTorituki3Data
	SpriteDataW	_sprbaseCX+$f8,_sprbaseCY+$f8,$6e,colpal5,pri2,noflip,mm_obj_offset
SprSATorituki3DataEnd

SprSATorituki4Data
_sprbaseCX = 0
_sprbaseCY = 0
	km_datacntbig	W,SprSaTorituki4Data
	SpriteDataW	_sprbaseCX+$f8,_sprbaseCY+$f8,$c6,colpal1,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+$f0,_sprbaseCY+$f0,$84,colpal5,pri2,noflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+000,_sprbaseCY+$f0,$84,colpal5,pri2,xflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+$f0,_sprbaseCY+000,$84,colpal5,pri2,yflip,mm_obj_offset
	SpriteDataW	_sprbaseCX+000,_sprbaseCY+000,$84,colpal5,pri2,xyflip,mm_obj_offset
SprSATorituki4DataEnd
;-----------------------------------------------------------------------------------------------
Sprkirari0Data
	km_datacntbig	W,SprKirari0Data
	db	0e8h,000h,068h,031h
	db	0e8h,0f0h,048h,031h
Sprkirari0DataEnd
;-----------------------------------------------------------------------------------------------
Sprkirari1Data
	km_datacntbig	W,SprKirari1Data
	db	0f8h,000h,06dh,031h
	db	0e8h,0f0h,04ah,031h
	db	0f8h,0f0h,04dh,031h
	db	0e8h,000h,06ah,031h
Sprkirari1DataEnd
;-----------------------------------------------------------------------------------------------
Sprkirari2Data
	km_datacntbig	W,SprKirari2Data
	db	008h,0f0h,04dh,031h
	db	008h,000h,06dh,031h
	db	0e8h,000h,06ah,031h
	db	0e8h,0f0h,04ah,031h
	db	0f8h,000h,06bh,031h
	db	0f8h,0f0h,04bh,031h
Sprkirari2DataEnd
;-----------------------------------------------------------------------------------------------
Sprkirari3Data
	km_datacntbig	W,SprKirari3Data
	db	008h,000h,04ah,0f1h
	db	008h,0f0h,06ah,0f1h
	db	0f8h,000h,06bh,031h
	db	0e8h,000h,06ah,031h
	db	0e8h,0f0h,04ah,031h
	db	0f8h,0f0h,04bh,031h
Sprkirari3DataEnd
;-----------------------------------------------------------------------------------------------
Sprkirari4Data
	km_datacntbig	W,SprKirari4Data
	db	008h,000h,04ah,0f1h
	db	008h,0f0h,06ah,0f1h
	db	0f8h,0f0h,04bh,031h
	db	0e8h,000h,04dh,0f1h
	db	0e8h,0f0h,06dh,0f1h
	db	0f8h,000h,06bh,031h
Sprkirari4DataEnd
;-----------------------------------------------------------------------------------------------
Sprkirari5Data
	km_datacntbig	W,SprKirari5Data
	db	0f8h,000h,04dh,0f1h
	db	0f8h,0f0h,06dh,0f1h
	db	008h,000h,04ah,0f1h
	db	008h,0f0h,06ah,0f1h
Sprkirari5DataEnd
;-----------------------------------------------------------------------------------------------
Sprkirari6Data
	km_datacntbig	W,SprKirari6Data
	db	008h,000h,048h,0f1h
	db	008h,0f0h,068h,0f1h
Sprkirari6DataEnd
;-----------------------------------------------------------------------------------------------
SprExpert0Data
	km_datacntbig	W,SprExpert0Data
	db	020h,0f8h,08dh,071h
	db	010h,0f8h,08eh,031h
	db	000h,0f8h,08eh,031h
	db	0f0h,0f8h,08eh,031h
	db	0e0h,0f8h,08eh,031h
	db	0d0h,0f8h,08dh,031h
SprExpert0DataEnd
;-----------------------------------------------------------------------------------------------
SprExpert1Data
	km_datacntbig	W,SprExpert1Data
	db	020h,0f8h,08ah,071h
	db	010h,0f8h,08bh,031h
	db	000h,0f8h,08bh,031h
	db	0f0h,0f8h,08bh,031h
	db	0e0h,0f8h,08bh,031h
	db	0d0h,0f8h,08ah,031h
SprExpert1DataEnd
;-----------------------------------------------------------------------------------------------
SprExpert2Data
	km_datacntbig	W,SprExpert2Data
	db	020h,000h,0cah,031h
	db	010h,000h,0c8h,031h
	db	000h,000h,0c6h,031h
	db	0f0h,000h,0c4h,031h
	db	0e0h,000h,0c2h,031h
	db	0d0h,000h,0c0h,031h
	db	020h,0f0h,0aah,031h
	db	010h,0f0h,0a8h,031h
	db	000h,0f0h,0a6h,031h
	db	0f0h,0f0h,0a4h,031h
	db	0e0h,0f0h,0a2h,031h
	db	0d0h,0f0h,0a0h,031h
SprExpert2DataEnd
;-----------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------
;*********************************************************************
;*								*
;*			MISSION					*
;*								*
;*********************************************************************
;;;;;;;	sprites value
;;;;;;;	SpriteDataW	x,y,chr,col,pri,flp

SpriteMaskData
	km_datacnt	W,SpriteMaskData
;* hidari tate *
_sprbasex = 0
_sprbasey = 0
	SpriteDataW	_sprbasex+$17*8,_sprbasey+5*8,sprmask,colpal0,pri0,noflip
	SpriteDataW	_sprbasex+$17*8,_sprbasey+7*8,sprmask,colpal0,pri0,noflip

;* shita yoko *
_sprbasex = -4
_sprbasey = 0
	SpriteDataW	_sprbasex+$19*8,_sprbasey+7*8,sprmask,colpal0,pri0,noflip
	SpriteDataW	_sprbasex+$1b*8,_sprbasey+7*8,sprmask,colpal0,pri0,noflip
	SpriteDataW	_sprbasex+$1d*8,_sprbasey+7*8,sprmask,colpal0,pri0,noflip
	SpriteDataW	_sprbasex+$1e*8,_sprbasey+7*8,sprmask,colpal0,pri0,noflip
;* migi tate *
_sprbasex = 0
_sprbasey = 0
	SpriteDataW	_sprbasex+$1e*8,_sprbasey+5*8,sprmask,colpal0,pri0,noflip
	SpriteDataW	_sprbasex+$1e*8,_sprbasey+3*8,sprmask,colpal0,pri0,noflip
	SpriteDataW	_sprbasex+$1e*8,_sprbasey+1*8,sprmask,colpal0,pri0,noflip
SpriteMaskDataEnd

;=====================================================================
;*		MISSION SPRITE BASE DATA			*
;*								*
;=====================================================================
SpritesMissionData
_sprbasex = 0
_sprbasey = 0
	km_datacnt	W,SpritesMissionData
;---- Target ---
	SpriteDataW	_sprbasex+$0e*8,_sprbasey+1*8,$50,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$10*8,_sprbasey+1*8,$52,colpal0,pri3,noflip

;---- shield ----
	SpriteDataW	_sprbasex+$19*8+2+4,_sprbasey+$16*8-2,$54,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1b*8+2+4,_sprbasey+$16*8-2,$56,colpal0,pri3,noflip

;---- braster ----
	SpriteDataW	_sprbasex+$19*8+2+4,_sprbasey+$14*8-2,$44,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1b*8+2+4,_sprbasey+$14*8-2,$46,colpal0,pri3,noflip

SpritesMissionDataEnd

;=====================================================================
;*		MISSION SPRITE Boost DATA			*
;=====================================================================
_sprbasex = 0
_sprbasey = 0

SprBoostData
	km_datacnt	W,SprBoostData
	SpriteDataW	_sprbasex+$19*8+2,_sprbasey+$14*8,$44,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1b*8+2,_sprbasey+$14*8,$46,colpal0,pri3,noflip
SprBoostDataEnd

;*********************************************************************
;*								*
;*			BATTLE					*
;*								*
;*********************************************************************
	IFNE	kbattle
;=====================================================================
;*		Battle Base Data				*
;=====================================================================
;---- Time Second ---
	SpriteDataW	_sprbasex+$1c*8+4,_sprbasey+$03*8-0,$29,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$02*8+6,_sprbasey+$10*8-0,$29,colpal0,pri3,noflip

SpritesBattleData4
_sprbasex = 0
_sprbasey = 0
	km_datacnt	W,SpritesBattleData4
;***** player1 *****
;---- boost -----
	SpriteDataW	_sprbasex+$1a*8-4,_sprbasey+$9*8+2,$44,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1c*8-4,_sprbasey+$9*8+2,$46,colpal0,pri3,noflip
;---- shield ----
	SpriteDataW	_sprbasex+$1a*8-4,_sprbasey+$a*8+2,$54,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1c*8-4,_sprbasey+$a*8+2,$56,colpal0,pri3,noflip
;**** player2 *****
;---- boost -----
	SpriteDataW	_sprbasex+$03*8-4,_sprbasey+$16*8+2,$44,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$05*8-4,_sprbasey+$16*8+2,$46,colpal0,pri3,noflip
;---- shield ----
	SpriteDataW	_sprbasex+$03*8-4,_sprbasey+$17*8+2,$54,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$05*8-4,_sprbasey+$17*8+2,$56,colpal0,pri3,noflip
SpritesBattleData4End
;----------------------------------------------------------------------------------------
SpritesBattleData
_sprbasex = 0
_sprbasey = 0
	km_datacnt	W,SpritesBattleData
	SpriteDataW	_sprbasex+$1c*8+4,_sprbasey+$03*8-2,$29,colpal2,pri3,noflip
	SpriteDataW	_sprbasex+$05*8+4,_sprbasey+$10*8-2,$29,colpal2,pri3,noflip
SpritesBattleDataEnd
;=====================================================================
;*		Battle Round Display				*
;=====================================================================
;---------------------------------------------------------------------
RoundData
	IFEQ	1
	km_datacnt	W,RoundData
	SpriteDataW	$8*8,4*8,gamemoji_r,colpal1,pri3,noflip
	SpriteDataW	$9*8,4*8,gamemoji_o,colpal1,pri3,noflip
	SpriteDataW	$a*8,4*8,gamemoji_u,colpal1,pri3,noflip
	SpriteDataW	$b*8,4*8,gamemoji_n,colpal1,pri3,noflip
	SpriteDataW	$c*8,4*8,gamemoji_d,colpal1,pri3,noflip
	ENDC
RoundDataEnd
;---------------------------------------------------------------------
RoundOverData
	IFEQ	1
	km_datacnt	W,RoundOverData
	SpriteDataW	$0a*8,1*8+2,gamemoji_p,colpal1,pri3,noflip

	SpriteDataW	$0c*8,1*8+2,gamemoji_s,colpal1,pri3,noflip
	SpriteDataW	$0d*8,1*8+2,gamemoji_c,colpal1,pri3,noflip
	SpriteDataW	$0e*8,1*8+2,gamemoji_o,colpal1,pri3,noflip
	SpriteDataW	$0f*8,1*8+2,gamemoji_r,colpal1,pri3,noflip
	SpriteDataW	$10*8,1*8+2,gamemoji_e,colpal1,pri3,noflip

	SpriteDataW	$03*8,4*8+0,gamemoji_b,colpal2,pri3,noflip
	SpriteDataW	$04*8,4*8+0,gamemoji_a,colpal2,pri3,noflip
	SpriteDataW	$05*8,4*8+0,gamemoji_s,colpal2,pri3,noflip
	SpriteDataW	$06*8,4*8+0,gamemoji_i,colpal2,pri3,noflip
	SpriteDataW	$07*8,4*8+0,gamemoji_c,colpal2,pri3,noflip

	SpriteDataW	$03*8,5*8+4,gamemoji_e,colpal2,pri3,noflip
	SpriteDataW	$04*8,5*8+4,gamemoji_x,colpal2,pri3,noflip
	SpriteDataW	$05*8,5*8+4,gamemoji_t,colpal2,pri3,noflip
	SpriteDataW	$06*8,5*8+4,gamemoji_r,colpal2,pri3,noflip
	SpriteDataW	$07*8,5*8+4,gamemoji_a,colpal2,pri3,noflip

	SpriteDataW	$03*8,7*8+0,gamemoji_p,colpal2,pri3,noflip
	SpriteDataW	$04*8,7*8+0,gamemoji_e,colpal2,pri3,noflip
	SpriteDataW	$05*8,7*8+0,gamemoji_n,colpal2,pri3,noflip
	SpriteDataW	$06*8,7*8+0,gamemoji_a,colpal2,pri3,noflip
	SpriteDataW	$07*8,7*8+0,gamemoji_l,colpal2,pri3,noflip
	SpriteDataW	$08*8,7*8+0,gamemoji_t,colpal2,pri3,noflip
	SpriteDataW	$09*8,7*8+0,gamemoji_y,colpal2,pri3,noflip
	ENDC
RoundOverDataEND
;----------------------------------------------------------------------
Totaloffx	equ	$18
Totaloffy	equ	$48
TotalData
	IFEQ	1
	km_datacnt	W,TotalData
	SpriteDataW	totaloffx+$00,totaloffy+$00,gamemojiBU_t,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$00,totaloffy+$08,gamemojiBD_t,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$08,totaloffy+$00,gamemojiBU_o,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$08,totaloffy+$08,gamemojiBD_o,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$10,totaloffy+$00,gamemojiBU_t,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$10,totaloffy+$08,gamemojiBD_t,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$18,totaloffy+$00,gamemojiBU_a,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$18,totaloffy+$08,gamemojiBD_a,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$20,totaloffy+$00,gamemojiBU_l,colpal0,pri3,noflip
	SpriteDataW	totaloffx+$20,totaloffy+$08,gamemojiBD_l,colpal0,pri3,noflip
	ENDC
TotalDataEnd
;----------------------------------------------------------------------
;----------------------------------------------------------------------

;=====================================================================
;*			Time Up					*
;=====================================================================
TimeUPData
timeupbasex	equ	$06*8
timeupbasey	equ	$04*8
	km_datacnt	W,TimeUpData
	SpriteDataW	timeupbasex+$00*8,timeupbasey+0*8,gamemoji_t,colpal1,pri3,noflip
	SpriteDataW	timeupbasex+$01*8,timeupbasey+0*8,gamemoji_i,colpal1,pri3,noflip
	SpriteDataW	timeupbasex+$02*8,timeupbasey+0*8,gamemoji_m,colpal1,pri3,noflip
	SpriteDataW	timeupbasex+$03*8,timeupbasey+0*8,gamemoji_e,colpal1,pri3,noflip

	SpriteDataW	timeupbasex+$05*8,timeupbasey+0*8,gamemoji_u,colpal1,pri3,noflip
	SpriteDataW	timeupbasex+$06*8,timeupbasey+0*8,gamemoji_p,colpal1,pri3,noflip
TimeUpDataEND

	ENDC
;*****************************************************************************
;*****************************************************************************
;*			Not Using Area					*
;*****************************************************************************
		IFEQ	1
;*****************************************************************************
;---- Score ----
;	SpriteDataW	_sprbasex+$0d*8,_sprbasey+1*8,$50,colpal0,pri3,noflip
;	SpriteDataW	_sprbasex+$0f*8,_sprbasey+1*8,$52,colpal0,pri3,noflip

;---- crystal -----
;	SpriteDataW	_sprbasex+$8*8+2,_sprbasey+2*8,$44,colpal0,pri3,noflip

_sprbasex = 0
_sprbasey = -2
;* BOM *
	SpriteDataW	_sprbasex+$2*8-1,_sprbasey+$18*8,$0a,colpal2,pri3,noflip
	SpriteDataW	_sprbasex+$3*8-1,_sprbasey+$18*8,$0b,colpal2,pri3,noflip
	SpriteDataW	_sprbasex+$2*8-1,_sprbasey+$19*8,$1a,colpal2,pri3,noflip
	SpriteDataW	_sprbasex+$3*8-1,_sprbasey+$19*8,$1b,colpal2,pri3,noflip

	SpriteDataW	_sprbasex+$4*8-1,_sprbasey+$19*8,$3a,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$5*8-1,_sprbasey+$19*8,$33,colpal0,pri3,noflip
;------ HP ------
	SpriteDataW	_sprbasex+$19*8-1,_sprbasey+$18*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1a*8-1,_sprbasey+$18*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1b*8-1,_sprbasey+$18*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1c*8-1,_sprbasey+$18*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1d*8-1,_sprbasey+$18*8,$ab,colpal0,pri3,noflip

	SpriteDataW	_sprbasex+$19*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1a*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1b*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1c*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1d*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip

;( AMI DATA )
SpriteRadarMapData
_sprbasex = -1
_sprbasey = 0
	km_datacnt	W,SpriteRadarMapData
	SpriteDataW	_sprbasex+$19*8,_sprbasey+2*8,$40,colpal5,pri3,noflip
	SpriteDataW	_sprbasex+$1B*8,_sprbasey+2*8,$40,colpal5,pri3,noflip
	SpriteDataW	_sprbasex+$1D*8,_sprbasey+2*8,$46,colpal5,pri3,noflip
	SpriteDataW	_sprbasex+$19*8,_sprbasey+4*8,$40,colpal5,pri3,noflip
	SpriteDataW	_sprbasex+$1B*8,_sprbasey+4*8,$40,colpal5,pri3,noflip
	SpriteDataW	_sprbasex+$1D*8,_sprbasey+4*8,$46,colpal5,pri3,noflip
	SpriteDataW	_sprbasex+$19*8,_sprbasey+6*8,$42,colpal5,pri3,noflip
	SpriteDataW	_sprbasex+$1B*8,_sprbasey+6*8,$42,colpal5,pri3,noflip
	SpriteDataW	_sprbasex+$1D*8,_sprbasey+6*8,$44,colpal5,pri3,noflip
SpriteRadarMapDataEnd

PilotOAMData
	dw	(FOXYokoPT-PilotOAMData)&WM
	dw	(FALCOYokoPT&WM-PilotOAMData)&WM
	dw	(PeppyYokoPT-PilotOAMData)&WM
	dw	(SlippyYokoPT&WM-PilotOAMData)&WM
	dw	(BossYokoPT&WM-PilotOAMData)&WM
	dw	(LadyYokoPT-PilotOAMData)&WM
;----------------------------------------------------------------------
FoxYokoPT
	km_datacnt	W,FOXYokoPT
	SpriteDataB	-$08,-$18,$0a0,colpal2,pri3,noflip
	SpriteDataB	 $00,-$18,$0a1,colpal2,pri3,noflip
	SpriteDataB	 $08,-$18,$0a2,colpal2,pri3,noflip

	SpriteDataB	-$10,-$10,$0a3,colpal2,pri3,noflip
	SpriteDataB	-$08,-$10,$0a4,colpal2,pri3,noflip
	SpriteDataB	 $00,-$10,$0a5,colpal2,pri3,noflip
	SpriteDataB	 $08,-$10,$0a6,colpal2,pri3,noflip

	SpriteDataB	-$18,-$08,$0a7,colpal2,pri3,noflip
	SpriteDataB	-$10,-$08,$0a8,colpal2,pri3,noflip
	SpriteDataB	-$08,-$08,$0a9,colpal2,pri3,noflip
	SpriteDataB	 $00,-$08,$0aa,colpal2,pri3,noflip
	SpriteDataB	 $08,-$08,$0ab,colpal2,pri3,noflip

	SpriteDataB	-$18,$000,$0ac,colpal2,pri3,noflip
	SpriteDataB	-$10,$000,$0ad,colpal2,pri3,noflip
	SpriteDataB	-$08,$000,$0ae,colpal2,pri3,noflip
	SpriteDataB	 $00,$000,$0af,colpal2,pri3,noflip
	SpriteDataB	 $08,$000,$0b0,colpal2,pri3,noflip

	SpriteDataB	-$10,$008,$0b1,colpal2,pri3,noflip
	SpriteDataB	-$08,$008,$0b2,colpal2,pri3,noflip
	SpriteDataB	 $00,$008,$0b3,colpal2,pri3,noflip
	SpriteDataB	 $08,$008,$0b4,colpal2,pri3,noflip
FoxYokoPTEnd
;---------------------------------------------------------------------------
FalcoYokoPT
	km_datacnt	W,FalcoYokoPT
	SpriteDataB	-$08,-$18,$0d0,colpal2,pri3,noflip
	SpriteDataB	 $00,-$18,$0d1,colpal2,pri3,noflip
	SpriteDataB	 $08,-$18,$0d2,colpal2,pri3,noflip

	SpriteDataB	-$10,-$10,$0d3,colpal2,pri3,noflip
	SpriteDataB	-$08,-$10,$0d4,colpal2,pri3,noflip
	SpriteDataB	 $00,-$10,$0d5,colpal2,pri3,noflip
	SpriteDataB	 $08,-$10,$0d6,colpal2,pri3,noflip

	SpriteDataB	-$10,-$08,$0d7,colpal2,pri3,noflip
	SpriteDataB	-$08,-$08,$0d8,colpal2,pri3,noflip
	SpriteDataB	 $00,-$08,$0d9,colpal2,pri3,noflip
	SpriteDataB	 $08,-$08,$0da,colpal2,pri3,noflip

	SpriteDataB	-$10,$000,$0db,colpal2,pri3,noflip
	SpriteDataB	-$08,$000,$0dc,colpal2,pri3,noflip
	SpriteDataB	 $00,$000,$0dd,colpal2,pri3,noflip
	SpriteDataB	 $08,$000,$0de,colpal2,pri3,noflip

	SpriteDataB	-$10,$008,$0df,colpal2,pri3,noflip
	SpriteDataB	-$08,$008,$0e0,colpal2,pri3,noflip
	SpriteDataB	 $00,$008,$0e1,colpal2,pri3,noflip
	SpriteDataB	 $08,$008,$0e2,colpal2,pri3,noflip
FalcoYokoPTEnd
;--------------------------------------------------------------------------
PeppyYokoPT
	km_datacnt	W,PeppyYokoPT
	SpriteDataB	-$18,-$18,$100,colpal2,pri3,noflip
	SpriteDataB	-$10,-$18,$101,colpal2,pri3,noflip
	SpriteDataB	-$08,-$18,$102,colpal2,pri3,noflip
	SpriteDataB	 $00,-$18,$103,colpal2,pri3,noflip
	SpriteDataB	 $08,-$18,$104,colpal2,pri3,noflip

	SpriteDataB	-$18,-$10,$105,colpal2,pri3,noflip
	SpriteDataB	-$10,-$10,$106,colpal2,pri3,noflip
	SpriteDataB	-$08,-$10,$107,colpal2,pri3,noflip
	SpriteDataB	 $00,-$10,$108,colpal2,pri3,noflip
	SpriteDataB	 $08,-$10,$109,colpal2,pri3,noflip

	SpriteDataB	-$10,-$08,$10a,colpal2,pri3,noflip
	SpriteDataB	-$08,-$08,$10b,colpal2,pri3,noflip
	SpriteDataB	 $00,-$08,$10c,colpal2,pri3,noflip
	SpriteDataB	 $08,-$08,$10d,colpal2,pri3,noflip

	SpriteDataB	-$10,$000,$10e,colpal2,pri3,noflip
	SpriteDataB	-$08,$000,$10f,colpal2,pri3,noflip
	SpriteDataB	 $00,$000,$110,colpal2,pri3,noflip
	SpriteDataB	 $08,$000,$111,colpal2,pri3,noflip

	SpriteDataB	 -$10,$008,$112,colpal2,pri3,noflip
	SpriteDataB	 -$08,$008,$113,colpal2,pri3,noflip
	SpriteDataB	  $00,$008,$114,colpal2,pri3,noflip
	SpriteDataB	  $08,$008,$115,colpal2,pri3,noflip
PeppyYokoPTEnd
;--------------------------------------------------------------------------
SlippyYokoPT
	km_datacnt	W,SlippyYokoPT

	SpriteDataB	-$10,-$10,$130,colpal2,pri3,noflip
	SpriteDataB	-$08,-$10,$131,colpal2,pri3,noflip
	SpriteDataB	 $00,-$10,$132,colpal2,pri3,noflip

	SpriteDataB	-$18,-$08,$133,colpal2,pri3,noflip
	SpriteDataB	-$10,-$08,$134,colpal2,pri3,noflip
	SpriteDataB	-$08,-$08,$135,colpal2,pri3,noflip
	SpriteDataB	 $00,-$08,$136,colpal2,pri3,noflip

	SpriteDataB	-$18,$000,$137,colpal2,pri3,noflip
	SpriteDataB	-$10,$000,$138,colpal2,pri3,noflip
	SpriteDataB	-$08,$000,$139,colpal2,pri3,noflip
	SpriteDataB	 $00,$000,$13a,colpal2,pri3,noflip
	SpriteDataB	 $08,$000,$13b,colpal2,pri3,noflip

	SpriteDataB	-$10,$008,$13c,colpal2,pri3,noflip
	SpriteDataB	-$08,$008,$13d,colpal2,pri3,noflip
	SpriteDataB	 $00,$008,$13e,colpal2,pri3,noflip
	SpriteDataB	 $08,$008,$13f,colpal2,pri3,noflip
SlippyYokoPTEnd
;---------------------------------------------------------------------------
LadyYokoPT
	km_datacnt	W,LadyYokoPT
	SpriteDataB	-$10,-$18,$160,colpal2,pri3,noflip
	SpriteDataB	-$08,-$18,$161,colpal2,pri3,noflip
	SpriteDataB	 $00,-$18,$162,colpal2,pri3,noflip
	SpriteDataB	 $08,-$18,$163,colpal2,pri3,noflip

	SpriteDataB	-$10,-$10,$164,colpal2,pri3,noflip
	SpriteDataB	-$08,-$10,$165,colpal2,pri3,noflip
	SpriteDataB	 $00,-$10,$166,colpal2,pri3,noflip
	SpriteDataB	 $08,-$10,$167,colpal2,pri3,noflip

	SpriteDataB	-$18,-$08,$168,colpal2,pri3,noflip
	SpriteDataB	-$10,-$08,$169,colpal2,pri3,noflip
	SpriteDataB	-$08,-$08,$16a,colpal2,pri3,noflip
	SpriteDataB	 $00,-$08,$16b,colpal2,pri3,noflip
	SpriteDataB	 $08,-$08,$16c,colpal2,pri3,noflip

	SpriteDataB	-$18,$000,$16d,colpal2,pri3,noflip
	SpriteDataB	-$10,$000,$16e,colpal2,pri3,noflip
	SpriteDataB	-$08,$000,$16f,colpal2,pri3,noflip
	SpriteDataB	 $00,$000,$170,colpal2,pri3,noflip
	SpriteDataB	 $08,$000,$171,colpal2,pri3,noflip

	SpriteDataB	-$10,$008,$172,colpal2,pri3,noflip
	SpriteDataB	-$08,$008,$173,colpal2,pri3,noflip
	SpriteDataB	 $00,$008,$174,colpal2,pri3,noflip
	SpriteDataB	 $08,$008,$175,colpal2,pri3,noflip
LadyYokoPTEnd
;---------------------------------------------------------------------------
BossYokoPT
	km_datacnt	W,BossYokoPT
	SpriteDataB	-$08,-$18,$190,colpal2,pri3,noflip
	SpriteDataB	 $00,-$18,$191,colpal2,pri3,noflip
	SpriteDataB	 $08,-$18,$192,colpal2,pri3,noflip

	SpriteDataB	-$10,-$10,$193,colpal2,pri3,noflip
	SpriteDataB	-$08,-$10,$194,colpal2,pri3,noflip
	SpriteDataB	 $00,-$10,$195,colpal2,pri3,noflip
	SpriteDataB	 $08,-$10,$196,colpal2,pri3,noflip

	SpriteDataB	-$10,-$08,$197,colpal2,pri3,noflip
	SpriteDataB	-$08,-$08,$198,colpal2,pri3,noflip
	SpriteDataB	 $00,-$08,$199,colpal2,pri3,noflip
	SpriteDataB	 $08,-$08,$19a,colpal2,pri3,noflip

	SpriteDataB	-$18,$000,$19b,colpal2,pri3,noflip
	SpriteDataB	-$10,$000,$19c,colpal2,pri3,noflip
	SpriteDataB	-$08,$000,$19d,colpal2,pri3,noflip
	SpriteDataB	 $00,$000,$19e,colpal2,pri3,noflip
	SpriteDataB	 $08,$000,$19f,colpal2,pri3,noflip

	SpriteDataB	-$18,$008,$1a0,colpal2,pri3,noflip
	SpriteDataB	-$10,$008,$1a1,colpal2,pri3,noflip
	SpriteDataB	-$08,$008,$1a2,colpal2,pri3,noflip
	SpriteDataB	 $00,$008,$1a3,colpal2,pri3,noflip
	SpriteDataB	 $08,$008,$1a4,colpal2,pri3,noflip
BossYokoPTEnd

;=========================================================================
;*
;=========================================================================
ArwingOAMData
	dw	(FFArwing-ArwingOAMData)&WM
	dw	(FFArwing-ArwingOAMData)&WM
	dw	(SPArwing-ArwingOAMData)&WM
	dw	(SPArwing-ArwingOAMData)&WM
	dw	(GGArwing-ArwingOAMData)&WM
	dw	(GGArwing-ArwingOAMData)&WM
;--------------------------------------------------------------------
FFArwing
	km_datacnt	W,FFArwing
	SpriteDataB	-$20,-$10,$022,colpal4,pri3,noflip
	SpriteDataB	-$10,-$10,$024,colpal4,pri3,noflip
	SpriteDataB	 $00,-$10,$026,colpal4,pri3,noflip
	SpriteDataB	 $10,-$10,$028,colpal4,pri3,noflip

	SpriteDataB	-$30,$000,$02a,colpal4,pri3,noflip
	SpriteDataB	-$20,$000,$02c,colpal4,pri3,noflip
	SpriteDataB	-$10,$000,$02e,colpal4,pri3,noflip
	SpriteDataB	 $00,$000,$040,colpal4,pri3,noflip
	SpriteDataB	 $10,$000,$042,colpal4,pri3,noflip
FFArwingEND
;--------------------------------------------------------------------
GGArwing
	km_datacnt	W,GGArwing
	SpriteDataB	-$20,-$10,$044,colpal4,pri3,noflip
	SpriteDataB	-$10,-$10,$046,colpal4,pri3,noflip
	SpriteDataB	 $00,-$10,$048,colpal4,pri3,noflip
	SpriteDataB	 $10,-$10,$04a,colpal4,pri3,noflip

	SpriteDataB	-$30,$000,$04c,colpal4,pri3,noflip
	SpriteDataB	-$20,$000,$04e,colpal4,pri3,noflip
	SpriteDataB	-$10,$000,$060,colpal4,pri3,noflip
	SpriteDataB	 $00,$000,$062,colpal4,pri3,noflip
	SpriteDataB	 $10,$000,$064,colpal4,pri3,noflip
GGArwingEND
;--------------------------------------------------------------------
SPArwing
	km_datacnt	W,SPArwing
	SpriteDataB	-$30,-$10,$066,colpal4,pri3,noflip
	SpriteDataB	-$20,-$10,$068,colpal4,pri3,noflip
	SpriteDataB	-$10,-$10,$06a,colpal4,pri3,noflip
	SpriteDataB	 $00,-$10,$06c,colpal4,pri3,noflip
	SpriteDataB	 $10,-$10,$06e,colpal4,pri3,noflip

	SpriteDataB	-$30,$000,$080,colpal4,pri3,noflip
	SpriteDataB	-$20,$000,$082,colpal4,pri3,noflip
	SpriteDataB	-$10,$000,$084,colpal4,pri3,noflip
	SpriteDataB	 $00,$000,$086,colpal4,pri3,noflip
	SpriteDataB	 $10,$000,$088,colpal4,pri3,noflip
SPArwingEND
;--------------------------------------------------------------------
testx	equ	0
testy	equ	0
testchr	equ	0
TestSprData
	km_datacnt	W,TestSprData

	SpriteDataB	testx+$1b*8,testy+$07*8,testchr+$00,colpal2,pri3,noflip
	SpriteDataB	testx+$1c*8,testy+$07*8,testchr+$01,colpal2,pri3,noflip
	SpriteDataB	testx+$1d*8,testy+$07*8,testchr+$02,colpal2,pri3,noflip
	SpriteDataB	testx+$1b*8,testy+$08*8,testchr+$10,colpal2,pri3,noflip
	SpriteDataB	testx+$1c*8,testy+$08*8,testchr+$11,colpal2,pri3,noflip
	SpriteDataB	testx+$1d*8,testy+$08*8,testchr+$12,colpal2,pri3,noflip

	SpriteDataB	testx+$1b*8,testy+$0c*8,testchr+$03,colpal2,pri3,noflip
	SpriteDataB	testx+$1c*8,testy+$0c*8,testchr+$04,colpal2,pri3,noflip
	SpriteDataB	testx+$1d*8,testy+$0c*8,testchr+$05,colpal2,pri3,noflip
	SpriteDataB	testx+$1b*8,testy+$0d*8,testchr+$13,colpal2,pri3,noflip
	SpriteDataB	testx+$1c*8,testy+$0d*8,testchr+$14,colpal2,pri3,noflip
	SpriteDataB	testx+$1d*8,testy+$0d*8,testchr+$15,colpal2,pri3,noflip

	SpriteDataB	testx+$1b*8,testy+$11*8,testchr+$06,colpal2,pri3,noflip
	SpriteDataB	testx+$1c*8,testy+$11*8,testchr+$07,colpal2,pri3,noflip
	SpriteDataB	testx+$1d*8,testy+$11*8,testchr+$08,colpal2,pri3,noflip
	SpriteDataB	testx+$1b*8,testy+$12*8,testchr+$16,colpal2,pri3,noflip
	SpriteDataB	testx+$1c*8,testy+$12*8,testchr+$17,colpal2,pri3,noflip
	SpriteDataB	testx+$1d*8,testy+$12*8,testchr+$18,colpal2,pri3,noflip

	SpriteDataB	testx+$1b*8,testy+$16*8,testchr+$09,colpal2,pri3,noflip
	SpriteDataB	testx+$1c*8,testy+$16*8,testchr+$0a,colpal2,pri3,noflip
	SpriteDataB	testx+$1d*8,testy+$16*8,testchr+$0b,colpal2,pri3,noflip
	SpriteDataB	testx+$1b*8,testy+$17*8,testchr+$19,colpal2,pri3,noflip
	SpriteDataB	testx+$1c*8,testy+$17*8,testchr+$1a,colpal2,pri3,noflip
	SpriteDataB	testx+$1d*8,testy+$17*8,testchr+$1b,colpal2,pri3,noflip

TestSprDataEnd
;---------------------------------------------------------------------
SprHPTable
	db	$0e	;0/4	;empty
	db	$0d	;1/4	; |
	db	$0c	;2/4	; |
	db	$0c	;3/4	; |
	db	$0b	;4/4	;full

SprModoreData
	km_datacnt	W,SprModoreData

	SpriteDataB	RetMarkoffX-$28,RetMarkoffY+0,$08,colpal0,pri2,noflip
	SpriteDataB	RetMarkoffX-$28,RetMarkoffY+8,$08,colpal0,pri2,yflip
	SpriteDataB	RetMarkoffX-$20,RetMarkoffY+0,$08,colpal0,pri2,noflip
	SpriteDataB	RetMarkoffX-$20,RetMarkoffY+8,$08,colpal0,pri2,yflip

	SpriteDataB	RetMarkoffX+$30,RetMarkoffY+0,$08,colpal0,pri2,xflip
	SpriteDataB	RetMarkoffX+$30,RetMarkoffY+8,$08,colpal0,pri2,xyflip
	SpriteDataB	RetMarkoffX+$28,RetMarkoffY+0,$08,colpal0,pri2,xflip
	SpriteDataB	RetMarkoffX+$28,RetMarkoffY+8,$08,colpal0,pri2,xyflip
SprModoreDataEnd


;=============================================================================
;*									*
;*			BATTLE FIELD SELECT				*
;*									*
;=============================================================================
sprOKoffx	equ	$17*8+6
sprOKoffy	equ	7*8
;patern 0
bfs_sprOKchrval
	km_datacnt	B,bfs_sprOKchrval
bfs_sprOKchrdata
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+0*8,$df,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+0*8,$df,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+0*8,$df,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+1*8,$df,colpal3,pri3,yflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+1*8,$df,colpal3,pri3,yflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+1*8,$df,colpal3,pri3,yflip
bfs_sprOKchrvalEND
;patern 1
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+0*8,$ce,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+0*8,$cf,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+0*8,$ce,colpal3,pri3,xflip
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+1*8,$ce,colpal3,pri3,yflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+1*8,$cf,colpal3,pri3,yflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+1*8,$ce,colpal3,pri3,xyflip
;patern 2
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+0*8,$d6,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+0*8,$d7,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+0*8,$d8,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+1*8,$e6,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+1*8,$e7,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+1*8,$e8,colpal3,pri3,noflip
;patern 3
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+0*8,$d9,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+0*8,$da,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+0*8,$db,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+1*8,$dc,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+1*8,$dd,colpal3,pri3,noflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+1*8,$de,colpal3,pri3,noflip
;patern 4
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+0*8,$d9,colpal2,pri3,noflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+0*8,$da,colpal2,pri3,noflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+0*8,$db,colpal2,pri3,noflip
	SpriteDataB	sprOKoffx+0*8,sprOKoffy+1*8,$dc,colpal2,pri3,noflip
	SpriteDataB	sprOKoffx+1*8,sprOKoffy+1*8,$dd,colpal2,pri3,noflip
	SpriteDataB	sprOKoffx+2*8,sprOKoffy+1*8,$de,colpal2,pri3,noflip
;=====================================================================
;*			Game Timer				*
;=====================================================================
SprGameTimerWaku
;;;;;;;	sprites value
;;;;;;;	SpriteDataW	x,y,chr,col,pri,flp
	dw	16*4
	SpriteData	SprTmWkOffX+0*8,SprTmWkOffY+0*8,SprTmWkChr+0,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+1*8,SprTmWkOffY+0*8,SprTmWkChr+1,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+2*8,SprTmWkOffY+0*8,SprTmWkChr+2,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+3*8,SprTmWkOffY+0*8,SprTmWkChr+2,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+4*8,SprTmWkOffY+0*8,SprTmWkChr+2,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+5*8,SprTmWkOffY+0*8,SprTmWkChr+2,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+6*8,SprTmWkOffY+0*8,SprTmWkChr+3,colpal7,pri3,noflip

	SpriteData	SprTmWkOffX+0*8,SprTmWkOffY+1*8,SprTmWkChr+$14,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+6*8,SprTmWkOffY+1*8,SprTmWkChr+004,colpal7,pri3,noflip

	SpriteData	SprTmWkOffX+0*8,SprTmWkOffY+2*8,SprTmWkChr+$10,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+1*8,SprTmWkOffY+2*8,SprTmWkChr+$11,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+2*8,SprTmWkOffY+2*8,SprTmWkChr+$11,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+3*8,SprTmWkOffY+2*8,SprTmWkChr+$11,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+4*8,SprTmWkOffY+2*8,SprTmWkChr+$11,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+5*8,SprTmWkOffY+2*8,SprTmWkChr+$12,colpal7,pri3,noflip
	SpriteData	SprTmWkOffX+6*8,SprTmWkOffY+2*8,SprTmWkChr+$13,colpal7,pri3,noflip
;=====================================================================
;*			Pause Mode				*
;=====================================================================
SprRadarMapP1
	IFEQ	1
;---------------------------------------------------------------------
;*			Radar Select Message			*
;---------------------------------------------------------------------
;========= pause message & map========
P1radselmesX	equ	$38
P1radselmesY	equ	$20
P2radselmesX	equ	$68
P2radselmesY	equ	$88

radmeschroff	equ	$82
radselchroff	equ	$a4

PauseMesVal	equ	13*4
PauseMapVal	equ	8*4
PushStarVal	equ	9*4
;---------------------------------------------------------------------
SprRadSelMesP1
;	DW	sporites value
;	DB	SpriteData	x zahyo,y zahyo,character,color,prio,flip
;============ message ================
	dw	PauseMesVal+PauseMapVal
	SpriteData	P1radselmesX+$00,P1radselmesY+$00,radmeschroff+$15,colpal0,pri3,noflip ;S
	SpriteData	P1radselmesX+$08,P1radselmesY+$00,radmeschroff+$04,colpal0,pri3,noflip ;E
	SpriteData	P1radselmesX+$10,P1radselmesY+$00,radmeschroff+$0b,colpal0,pri3,noflip :L
	SpriteData	P1radselmesX+$18,P1radselmesY+$00,radmeschroff+$04,colpal0,pri3,noflip ;E
	SpriteData	P1radselmesX+$20,P1radselmesY+$00,radmeschroff+$02,colpal0,pri3,noflip ;C
	SpriteData	P1radselmesX+$28,P1radselmesY+$00,radmeschroff+$16,colpal0,pri3,noflip ;T

	SpriteData	P1radselmesX+$38,P1radselmesY+$00,radmeschroff+$14,colpal0,pri3,noflip ;R
	SpriteData	P1radselmesX+$40,P1radselmesY+$00,radmeschroff+$00,colpal0,pri3,noflip ;A
	SpriteData	P1radselmesX+$48,P1radselmesY+$00,radmeschroff+$03,colpal0,pri3,noflip ;D
	SpriteData	P1radselmesX+$50,P1radselmesY+$00,radmeschroff+$00,colpal0,pri3,noflip ;A
	SpriteData	P1radselmesX+$58,P1radselmesY+$00,radmeschroff+$14,colpal0,pri3,noflip ;R

	SpriteData	P1radselmesX+$28,P1radselmesY+$1C,radmeschroff+$11,colpal0,pri3,noflip ;O
	SpriteData	P1radselmesX+$30,P1radselmesY+$1C,radmeschroff+$14,colpal0,pri3,noflip ;R
;============== MAP ==============
SprRadarMapP1
	SpriteData	P1radselmesX+$08,P1radselmesY+$10,$80,colpal0,pri3,noflip
	SpriteData	P1radselmesX+$18,P1radselmesY+$10,$80,colpal0,pri3,xflip
	SpriteData	P1radselmesX+$08,P1radselmesY+$20,$80,colpal0,pri3,yflip
	SpriteData	P1radselmesX+$18,P1radselmesY+$20,$80,colpal0,pri3,xyflip
	SpriteData	P1radselmesX+$38,P1radselmesY+$10,$a0,colpal0,pri3,noflip
	SpriteData	P1radselmesX+$48,P1radselmesY+$10,$a0,colpal0,pri3,xflip
	SpriteData	P1radselmesX+$38,P1radselmesY+$20,$a2,colpal0,pri3,noflip
	SpriteData	P1radselmesX+$48,P1radselmesY+$20,$a2,colpal0,pri3,xflip

;============== Push Start =============
SprPushStartP1
	dw	PushStarVal
	SpriteData	P1radselmesX+$08,P1radselmesY+$38,radmeschroff+$12,colpal0,pri3,noflip ;P
	SpriteData	P1radselmesX+$10,P1radselmesY+$38,radmeschroff+$17,colpal0,pri3,noflip ;U
	SpriteData	P1radselmesX+$18,P1radselmesY+$38,radmeschroff+$15,colpal0,pri3,noflip ;S
	SpriteData	P1radselmesX+$20,P1radselmesY+$38,radmeschroff+$07,colpal0,pri3,noflip ;H

	SpriteData	P1radselmesX+$30,P1radselmesY+$38,radmeschroff+$15,colpal0,pri3,noflip ;S
	SpriteData	P1radselmesX+$38,P1radselmesY+$38,radmeschroff+$16,colpal0,pri3,noflip ;T
	SpriteData	P1radselmesX+$40,P1radselmesY+$38,radmeschroff+$00,colpal0,pri3,noflip ;A
	SpriteData	P1radselmesX+$48,P1radselmesY+$38,radmeschroff+$14,colpal0,pri3,noflip ;R
	SpriteData	P1radselmesX+$50,P1radselmesY+$38,radmeschroff+$16,colpal0,pri3,noflip ;T
;============== Select Waku ============
SprRadSelWakuP1
	dw	4
	SpriteData	P1radselmesX+$08,P1radselmesY+$10,radselchroff+$00,colpal0,pri3,noflip
	SpriteData	P1radselmesX+$18,P1radselmesY+$10,radselchroff+$00,colpal0,pri3,xflip
	SpriteData	P1radselmesX+$08,P1radselmesY+$20,radselchroff+$00,colpal0,pri3,yflip
	SpriteData	P1radselmesX+$18,P1radselmesY+$20,radselchroff+$00,colpal0,pri3,xyflip
;========================================================================================================
;========================================================================================================
SprRadSelMesp2
;	sporites value
;	SpriteData	x zahyo,y zahyo,character,color,prio,flip

	dw	21*4
	SpriteData	p2radselmesX+$00,p2radselmesY+$00,radmeschroff+$15,colpal0,pri3,noflip ;S
	SpriteData	p2radselmesX+$08,p2radselmesY+$00,radmeschroff+$04,colpal0,pri3,noflip ;E
	SpriteData	p2radselmesX+$10,p2radselmesY+$00,radmeschroff+$0b,colpal0,pri3,noflip :L
	SpriteData	p2radselmesX+$18,p2radselmesY+$00,radmeschroff+$04,colpal0,pri3,noflip ;E
	SpriteData	p2radselmesX+$20,p2radselmesY+$00,radmeschroff+$02,colpal0,pri3,noflip ;C
	SpriteData	p2radselmesX+$28,p2radselmesY+$00,radmeschroff+$16,colpal0,pri3,noflip ;T

	SpriteData	p2radselmesX+$38,p2radselmesY+$00,radmeschroff+$14,colpal0,pri3,noflip ;R
	SpriteData	p2radselmesX+$40,p2radselmesY+$00,radmeschroff+$00,colpal0,pri3,noflip ;A
	SpriteData	p2radselmesX+$48,p2radselmesY+$00,radmeschroff+$03,colpal0,pri3,noflip ;D
	SpriteData	p2radselmesX+$50,p2radselmesY+$00,radmeschroff+$00,colpal0,pri3,noflip ;A
	SpriteData	p2radselmesX+$58,p2radselmesY+$00,radmeschroff+$14,colpal0,pri3,noflip ;R

	SpriteData	p2radselmesX+$28,p2radselmesY+$1C,radmeschroff+$11,colpal0,pri3,noflip ;O
	SpriteData	p2radselmesX+$30,p2radselmesY+$1C,radmeschroff+$14,colpal0,pri3,noflip ;R
;============== MAP ==============
	SpriteData	P2radselmesX+$08,P2radselmesY+$10,$80,colpal0,pri3,noflip
	SpriteData	P2radselmesX+$18,P2radselmesY+$10,$80,colpal0,pri3,xflip
	SpriteData	P2radselmesX+$08,P2radselmesY+$20,$80,colpal0,pri3,yflip
	SpriteData	P2radselmesX+$18,P2radselmesY+$20,$80,colpal0,pri3,xyflip
	SpriteData	P2radselmesX+$38,P2radselmesY+$10,$a0,colpal0,pri3,noflip
	SpriteData	P2radselmesX+$48,P2radselmesY+$10,$a0,colpal0,pri3,xflip
	SpriteData	P2radselmesX+$38,P2radselmesY+$20,$a2,colpal0,pri3,noflip
	SpriteData	P2radselmesX+$48,P2radselmesY+$20,$a2,colpal0,pri3,xflip

;============== Push Start =============
SprPushStartP2
	dw	9*4
	SpriteData	p2radselmesX+$08,p2radselmesY+$38,radmeschroff+$12,colpal0,pri3,noflip ;P
	SpriteData	p2radselmesX+$10,p2radselmesY+$38,radmeschroff+$17,colpal0,pri3,noflip ;U
	SpriteData	p2radselmesX+$18,p2radselmesY+$38,radmeschroff+$15,colpal0,pri3,noflip ;S
	SpriteData	p2radselmesX+$20,p2radselmesY+$38,radmeschroff+$07,colpal0,pri3,noflip ;H

	SpriteData	p2radselmesX+$30,p2radselmesY+$38,radmeschroff+$15,colpal0,pri3,noflip ;S
	SpriteData	p2radselmesX+$38,p2radselmesY+$38,radmeschroff+$16,colpal0,pri3,noflip ;T
	SpriteData	p2radselmesX+$40,p2radselmesY+$38,radmeschroff+$00,colpal0,pri3,noflip ;A
	SpriteData	p2radselmesX+$48,p2radselmesY+$38,radmeschroff+$14,colpal0,pri3,noflip ;R
	SpriteData	p2radselmesX+$50,p2radselmesY+$38,radmeschroff+$16,colpal0,pri3,noflip ;T
;============== Select Waku ============
SprRadSelWakuP2
	dw	4
	SpriteData	P2radselmesX+$08,P2radselmesY+$10,radselchroff+$00,colpal0,pri3,noflip
	SpriteData	P2radselmesX+$18,P2radselmesY+$10,radselchroff+$00,colpal0,pri3,xflip
	SpriteData	P2radselmesX+$08,P2radselmesY+$20,radselchroff+$00,colpal0,pri3,yflip
	SpriteData	P2radselmesX+$18,P2radselmesY+$20,radselchroff+$00,colpal0,pri3,xyflip

	ENDC
;=====================================================================
;*			Normal	Mode				*
;=====================================================================
;---------------------------------------------------------------------
;*		Sprites Sub mode
;---------------------------------------------------------------------
	ifeq	1
SprSubChrMd
	db	1<<1
	db	1<<3
	db	1<<5
	db	1<<7
	endc
;---------------------------------------------------------------------
;*		Player yajirushi data				*
;---------------------------------------------------------------------
	IFEQ	1
yajidata
	SpriteData	$0d8,$020,$00,0,3,0
	SpriteData	$020,$088,$00,0,3,0
	SpriteData	$000,$0f8,$13,0,3,0
	SpriteData	$000,$0f8,$13,0,3,0
yajidata_end
	endc
;---------------------------------------------------------------------
;*		 Area out Waku					*
;---------------------------------------------------------------------
AreaMap1	equ	1	;18432*18432
AreaMap2	equ	1	;
AreaMap3	equ	1	;
;========================== Map Data 1 ===============================
	ifeq	AreaMap1
MapWakuData
;	dw	worldx , worldz
;	dw	sprite character
;0
	dw	1024,1024*9
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

	dw	1024*3,1024*9
	SprChrDataW	WakuChr1,colpal0,pri1,noflip

	dw	1024*5,1024*9
	SprChrDataW	WakuChr1,colpal0,pri1,noflip

	dw	1024*7,1024*9
	SprChrDataW	WakuChr1,colpal0,pri1,noflip

	dw	1024*9,1024*9
	SprChrDataW	WakuChr0,colpal0,pri1,xflip

;1
	dw	1024,1024*7
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	1024*9,1024*7
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
;2
	dw	1024,1024*5
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	1024*9,1024*5
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
;3
	dw	1024,1024*3
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	1024*9,1024*3
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
;4
	dw	1024,1024*1
	SprChrDataW	WakuChr0,colpal0,pri1,yflip

	dw	1024*3,1024*1
	SprChrDataW	WakuChr1,colpal0,pri1,yflip

	dw	1024*5,1024*1
	SprChrDataW	WakuChr1,colpal0,pri1,yflip

	dw	1024*7,1024*1
	SprChrDataW	WakuChr1,colpal0,pri1,yflip

	dw	1024*9,1024*1
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip

;end code
	dw	$8000
	endc
;======================= Map Waku Data 2 =============================
	ifeq	AreaMap2
MapWakuData
;	dw	worldx , worldz
;	dw	sprite character
;0	(1dot.. 256 ,1chr .. 2048) 
	dw	1024,1024*13
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

	dw	1024*3,1024*13
	SprChrDataW	WakuChr1,colpal0,pri1,noflip

	dw	1024*5,1024*13
	SprChrDataW	WakuChr1,colpal0,pri1,noflip

	dw	1024*7,1024*13
	SprChrDataW	WakuChr1,colpal0,pri1,noflip

	dw	1024*9,1024*13
	SprChrDataW	WakuChr1,colpal0,pri1,noflip

	dw	1024*11,1024*13
	SprChrDataW	WakuChr1,colpal0,pri1,noflip

	dw	1024*13,1024*13
	SprChrDataW	WakuChr0,colpal0,pri1,xflip

;1
	dw	1024,1024*11
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	1024*13,1024*11
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
;2
	dw	1024,1024*9
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	1024*13,1024*9
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
;3
	dw	1024,1024*7
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	1024*13,1024*7
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
;4
	dw	1024,1024*5
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	1024*13,1024*5
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
;5
	dw	1024,1024*3
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	1024*13,1024*3
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
;4
	dw	1024,1024*1
	SprChrDataW	WakuChr0,colpal0,pri1,yflip

	dw	1024*3,1024*1
	SprChrDataW	WakuChr1,colpal0,pri1,yflip

	dw	1024*5,1024*1
	SprChrDataW	WakuChr1,colpal0,pri1,yflip

	dw	1024*7,1024*1
	SprChrDataW	WakuChr1,colpal0,pri1,yflip

	dw	1024*9,1024*1
	SprChrDataW	WakuChr1,colpal0,pri1,yflip

	dw	1024*11,1024*1
	SprChrDataW	WakuChr1,colpal0,pri1,yflip

	dw	1024*13,1024*1
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip

;end code
	dw	$8000

	endc


;=====================================================================
;*			Waku Table				*
;=====================================================================
	IFEQ	AreaMap3

MapWakuTable
	dw	(MapWakuData44-MapWakuData)	;0
	dw	(MapWakuData55-MapWakuData)	;2
	dw	(MapWakuData66-MapWakuData)	;4
	dw	(MapWakuData77-MapWakuData)	;6
	dw	(MapWakuData88-MapWakuData)	;8
;*********************************************************************
;*								*
;*			Map Waku Data				*
;*								*
;*********************************************************************
;**** LABEL ****
rad1dotlength	equ	256>>radscale		;1dot no nagasa
wkhosei		equ	4*rad1dotlength		;waku no hosei (0.5 chr)
radlength		equ	8*rad1dotlength		;1 chr no nagasa
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
;--------------------- REPT LOAD SPACE FILLER DO NOT REMOVE-----------------
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
MapWakuData
;=====================================================================
;*		FIELD MAP AREA 	(8192*8192)	[4chr * 4chr]	*
;=====================================================================
MapWakuData44
mapchr = 4
wakusx = -(mapchr-1)*8*256/2
wakusy = -(mapchr-1)*8*256/2
;0	(1dot.. 256 ,1chr .. 2048) 
mapoffset = 0
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = mapoffset+1

	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;1-2
	REPT	mapchr-2
	dw	wakusx+0,wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+2048*(mapchr-1),wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;3
	dw	wakusx+0,wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,yflip
mapoffset = 1

	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*0
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------------
;end code
	dw	$8000
MapWakuData44End
;=====================================================================
;*		FIELD MAP AREA 	(10240*10240)	[5chr * 5chr]	*
;=====================================================================
MapWakuData55
	ifeq	radscale
mapchr = 5
wakusx = (-(mapchr-1)*8*256)/2
wakusy = (-(mapchr-1)*8*256)/2

;1	(1dot.. 256 ,1chr .. 2048 (256*8)) 
mapoffset = 0
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = mapoffset+1

	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;2 - 4
	REPT	mapchr-1
	dw	wakusx+0,wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+2048*(mapchr-1),wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;5
	dw	wakusx+0,wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,yflip
mapoffset = 1
	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*0
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------
;end code
	dw	$8000
;---------------------------------------------------------------------
;*		Scale 2 Times Ver				*
;---------------------------------------------------------------------
	elseif

mapchr = 5<<radscale
;wakusx = (-(mapchr-1)*8*256-4*256)/2	;4608
;wakusy = (-(mapchr-1)*8*256-4*256)/2
wakusx = -mapchr*radlength/2+wkhosei
wakusy = wakusx
;1	(1dot.. 128 ,1chr ..  (8dot*128)) 
mapoffset = 0
	dw	wakusx+radlength*mapoffset,wakusy+radlength*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = mapoffset+1
	REPT	mapchr-2
	dw	wakusx+radlength*mapoffset,wakusy+radlength*(mapchr-1)
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+radlength*(mapchr-1),wakusy+radlength*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;2 - 9
	REPT	mapoffset	;mapchr-2
	dw	wakusx+0,wakusy+radlength*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+radlength*(mapchr-1),wakusy+radlength*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;10
mapoffset = 0
	dw	wakusx+radlength*mapoffset,wakusy
	SprChrDataW	WakuChr0,colpal0,pri1,yflip

mapoffset = mapoffset+1
	REPT	mapchr-2
	dw	wakusx+radlength*mapoffset,wakusy
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+radlength*mapoffset,wakusy
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------------
;end code
	dw	$8000
	endc
MapWakuData55End
;=====================================================================
;*		FIELD MAP AREA 	(12288*12288)	[6chr * 6chr]	*
;=====================================================================
MapWakuData66
mapchr = 6
wakusx = -(mapchr-1)*8*256/2
wakusy = -(mapchr-1)*8*256/2
;0	(1dot.. 256 ,1chr .. 2048) 
mapoffset = 0
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = mapoffset+1

	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;1 - 4
	REPT	mapchr-1
	dw	wakusx+0,wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+2048*(mapchr-1),wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;6
	dw	wakusx+0,wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,yflip
mapoffset = 1
	REPT	mapchr-1
	dw	wakusx+2048*mapoffset,wakusy+2048*0
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------------
;end code
	dw	$8000
MapWakuData66End
;=====================================================================
;*		FIELD MAP AREA 	(14336*14336)	[7chr * 7chr]	*
;=====================================================================
MapWakuData77
mapchr = 7
wakusx = -(mapchr-1)*8*256/2
wakusy = -(mapchr-1)*8*256/2
;0	(1dot.. 256 ,1chr .. 2048) 
mapoffset = 0
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = mapoffset+1
	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;1 - 5
	REPT	mapchr-1
	dw	wakusx+0,wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+2048*(mapchr-1),wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;6
	dw	wakusx+0,wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,yflip
mapoffset = 1
	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*0
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------------
;end code
	dw	$8000
MapWakuData77End
;---------------------------------------------------------------------------
;=====================================================================
;*		FIELD MAP AREA 	(14336*14336)	[8chr * 8chr]	*
;=====================================================================
MapWakuData88
mapchr = 8
wakusx = -(mapchr-1)*8*256/2
wakusy = -(mapchr-1)*8*256/2
;0	(1dot.. 256 ,1chr .. 2048) 
mapoffset = 0
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = mapoffset+1
	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;1 - 6
	REPT	mapchr-1
	dw	wakusx+0,wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+2048*(mapchr-1),wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;7
	dw	wakusx+0,wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,yflip
mapoffset = 1
	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*0
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------------
;end code
	dw	$8000
MapWakuData88End
;---------------------------------------------------------------------------

;	dw	worldx , worldz
;	dw	sprite character

	ifeq	1
;0	(1dot.. 256 ,1chr .. 2048) 
	dw	wakusx+2048*0,wakusy+2048*6
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = 1
	REPT	5
	dw	wakusx+2048*mapoffset,wakusy+2048*6
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*6,wakusy+2048*6
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;1 - 5
mapoffset = 5
	REPT	5
	dw	wakusx+0,wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+2048*6,wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip

mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;6
	dw	wakusx+0,wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,yflip

mapoffset = 1
	REPT	5
	dw	wakusx+2048*mapoffset,wakusy+2048*0
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*6,wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------------
;end code
	dw	$8000
	endc
	ENDC
;---------------------------------------------------------------------
;*	World Map (x,y) coordinate Data				*
;---------------------------------------------------------------------
	ifeq	1
;map1pos	equ	$10c8
;MapHosei
;sprites postion,player X pos hosei,player Z pos hosei
;0
	dw	map1pos+$0000,-$3000,-$3000,map1pos+$0008,-$2000,-$3000,map1pos+$0010,-$1000,-$3000
	dw	map1pos+$0018,$00000,-$3000,map1pos+$0020,$01000,-$3000,map1pos+$0028,$02000,-$3000

;1
	dw	map1pos+$0800,$-3000,-$2000,map1pos+$0808,$-2000,-$2000,map1pos+$0810,-$1000,-$2000
	dw	map1pos+$0818,$00000,-$2000,map1pos+$0820,$01000,-$2000,map1pos+$0828,$02000,-$2000

;2
	dw	map1pos+$1000,-$3000,-$1000,map1pos+$1008,-$2000,-$1000,map1pos+$1010,-$1000,-$1000
	dw	map1pos+$1018,$00000,-$1000,map1pos+$1020,$01000,-$1000,map1pos+$1028,$02000,-$1000
;3
	dw	map1pos+$1800,-$3000,$00000,map1pos+$1808,-$2000,$00000,map1pos+$1810,-$1000,$00000
	dw	map1pos+$1818,$00000,$00000,map1pos+$1820,$01000,$00000,map1pos+$1828,$02000,$00000

;4
	dw	map1pos+$2000,-$3000,$01000,map1pos+$2008,-$2000,$01000,map1pos+$2010,-$1000,$01000
	dw	map1pos+$2018,$00000,$01000,map1pos+$2020,$01000,$01000,map1pos+$2028,$02000,$01000

;5
	dw	map1pos+$2800,-$3000,$02000,map1pos+$2808,-$2000,$02000,map1pos+$2810,-$1000,$02000
	dw	map1pos+$2818,$00000,$02000,map1pos+$2820,$01000,$02000,map1pos+$2828,$02000,$02000
;end code
	dw	$ffff
	endc
;---------------------------------------------------------------------
;*	World Map (x,y) coordinate Data				*
;---------------------------------------------------------------------
	ifeq	1
map1Xpos	equ	$c0
map1Zpos	equ	$08
map2Xpos	equ	$08
map2Zpos	equ	$70

RMap1Hosei
;sprites postion,player X pos hosei,player Z pos hosei

;0
	db	map1Xpos+$00,map1Zpos+$00,-$03,-$30,map1Xpos+$08,map1Zpos+$00,-$02,-$30
	db	map1Xpos+$10,map1Zpos+$00,-$01,-$30,map1Xpos+$18,map1Zpos+$00,$000,-$30
	db	map1Xpos+$20,map1Zpos+$00,$001,-$30,map1Xpos+$28,map1Zpos+$00,$002,-$30
;1
	db	map1Xpos+$00,map1Zpos+$08,-$03,-$20,map1Xpos+$08,map1Zpos+$08,-$02,-$20
	db	map1Xpos+$10,map1Zpos+$08,-$01,-$20,map1Xpos+$18,map1Zpos+$08,$000,-$20
	db	map1Xpos+$20,map1Zpos+$08,$001,-$20,map1Xpos+$28,map1Zpos+$08,$002,-$20
;2
	db	map1Xpos+$00,map1Zpos+$10,-$03,-$10,map1Xpos+$08,map1Zpos+$10,-$02,-$10
	db	map1Xpos+$10,map1Zpos+$10,-$01,-$10,map1Xpos+$18,map1Zpos+$10,$000,-$10
	db	map1Xpos+$20,map1Zpos+$10,$001,-$10,map1Xpos+$28,map1Zpos+$10,$002,-$10
;3
	db	map1Xpos+$00,map1Zpos+$18,-$03,$000,map1Xpos+$08,map1Zpos+$18,-$02,$000
	db	map1Xpos+$10,map1Zpos+$18,-$01,$000,map1Xpos+$18,map1Zpos+$18,$000,$000
	db	map1Xpos+$20,map1Zpos+$18,$001,$000,map1Xpos+$28,map1Zpos+$18,$002,$000
;4
	db	map1Xpos+$00,map1Zpos+$20,-$03,$010,map1Xpos+$08,map1Zpos+$20,-$02,$010
	db	map1Xpos+$10,map1Zpos+$20,-$01,$010,map1Xpos+$18,map1Zpos+$20,$000,$010
	db	map1Xpos+$20,map1Zpos+$20,$001,$010,map1Xpos+$28,map1Zpos+$20,$002,$010
;5
	db	map1Xpos+$00,map1Zpos+$28,-$03,$020,map1Xpos+$08,map1Zpos+$28,-$02,$020
	db	map1Xpos+$10,map1Zpos+$28,-$01,$020,map1Xpos+$18,map1Zpos+$28,$000,$020
	db	map1Xpos+$20,map1Zpos+$28,$001,$020,map1Xpos+$28,map1Zpos+$28,$002,$020
;endcode
	db	0
	endc

	ifeq	1
RMap2Hosei
;0
	db	map2Xpos+$00,map2Zpos+$00,-$03,-$30,map2Xpos+$08,map2Zpos+$00,-$02,-$30
	db	map2Xpos+$10,map2Zpos+$00,-$01,-$30,map2Xpos+$18,map2Zpos+$00,$000,-$30
	db	map2Xpos+$20,map2Zpos+$00,$001,-$30,map2Xpos+$28,map2Zpos+$00,$002,-$30
;1
	db	map2Xpos+$00,map2Zpos+$08,-$03,-$20,map2Xpos+$08,map2Zpos+$08,-$02,-$20
	db	map2Xpos+$10,map2Zpos+$08,-$01,-$20,map2Xpos+$18,map2Zpos+$08,$000,-$20
	db	map2Xpos+$20,map2Zpos+$08,$001,-$20,map2Xpos+$28,map2Zpos+$08,$002,-$20
;2
	db	map2Xpos+$00,map2Zpos+$10,-$03,-$10,map2Xpos+$08,map2Zpos+$10,-$02,-$10
	db	map2Xpos+$10,map2Zpos+$10,-$01,-$10,map2Xpos+$18,map2Zpos+$10,$000,-$10
	db	map2Xpos+$20,map2Zpos+$10,$001,-$10,map2Xpos+$28,map2Zpos+$10,$002,-$10
;3
	db	map2Xpos+$00,map2Zpos+$18,-$03,$000,map2Xpos+$08,map2Zpos+$18,-$02,$000
	db	map2Xpos+$10,map2Zpos+$18,-$01,$000,map2Xpos+$18,map2Zpos+$18,$000,$000
	db	map2Xpos+$20,map2Zpos+$18,$001,$000,map2Xpos+$28,map2Zpos+$18,$002,$000
;4
	db	map2Xpos+$00,map2Zpos+$20,-$03,$010,map2Xpos+$08,map2Zpos+$20,-$02,$010
	db	map2Xpos+$10,map2Zpos+$20,-$01,$010,map2Xpos+$18,map2Zpos+$20,$000,$010
	db	map2Xpos+$20,map2Zpos+$20,$001,$010,map2Xpos+$28,map2Zpos+$20,$002,$010
;5
	db	map2Xpos+$00,map2Zpos+$28,-$03,$020,map2Xpos+$08,map2Zpos+$28,-$02,$020
	db	map2Xpos+$10,map2Zpos+$28,-$01,$020,map2Xpos+$18,map2Zpos+$28,$000,$020
	db	map2Xpos+$20,map2Zpos+$28,$001,$020,map2Xpos+$28,map2Zpos+$28,$002,$020
;endcode
	db	0
	endc



	ifeq	1
map1pos	equ	$08c0

MapHosei
;0
	dw	map1pos+$0000,-$03,-$30,map1pos+$0008,-$02,-$30,map1pos+$0010,-$01,-$30
	dw	map1pos+$0018,$000,-$30,map1pos+$0020,$001,-$30,map1pos+$0028,$002,-$30
;1
	dw	map1pos+$0800,$-03,-$20,map1pos+$0808,$-02,-$20,map1pos+$0810,-$01,-$20
	dw	map1pos+$0818,$000,-$20,map1pos+$0820,$001,-$20,map1pos+$0828,$002,-$20

;2
	dw	map1pos+$1000,-$03,-$10,map1pos+$1008,-$02,-$10,map1pos+$1010,-$01,-$10
	dw	map1pos+$1018,$000,-$10,map1pos+$1020,$001,-$10,map1pos+$1028,$002,-$10
;3
	dw	map1pos+$1800,-$03,$000,map1pos+$1808,-$02,$000,map1pos+$1810,-$01,$000
	dw	map1pos+$1818,$000,$000,map1pos+$1820,$001,$000,map1pos+$1828,$002,$000

;4
	dw	map1pos+$2000,-$03,$010,map1pos+$2008,-$02,$010,map1pos+$2010,-$01,$010
	dw	map1pos+$2018,$000,$010,map1pos+$2020,$001,$010,map1pos+$2028,$002,$010

;5
	dw	map1pos+$2800,-$03,$020,map1pos+$2808,-$02,$020,map1pos+$2810,-$01,$020
	dw	map1pos+$2818,$000,$020,map1pos+$2820,$001,$020,map1pos+$2828,$002,$020
;end code
	dw	$ffff
	endc
;-------------------------------------------------------------
;*	World Map Sprites Character Data		*
;-------------------------------------------------------------
map_data
;sprite No,color,prio,flip

	ifeq	1
;0
	SprChrDataB	$19,3,1,0	;0
	SprChrDataB	$19,3,1,0	;1	
	SprChrDataB	$19,3,1,0	;2
	SprChrDataB	$19,3,1,0	;3
	SprChrDataB	$19,3,1,0	;4
	SprChrDataB	$19,3,1,0	;5
	SprChrDataB	$1a,3,1,0	;6
	SprChrDataB	$1b,3,1,0	;7
	SprChrDataB	$1b,3,1,0	;8
	SprChrDataB	$1a,3,1,1	;9
	SprChrDataB	$19,3,1,0	;a
	SprChrDataB	$19,3,1,0	;b
	SprChrDataB	$19,3,1,0	;c
	SprChrDataB	$19,3,1,0	;d
	SprChrDataB	$19,3,1,0	;e
	SprChrDataB	$19,3,1,0	;f

;10
	SprChrDataB	$19,3,1,0	;0
	SprChrDataB	$19,3,1,0	;1	
	SprChrDataB	$1c,3,1,0	;2
	SprChrDataB	$1d,3,1,0	;3
	SprChrDataB	$1d,3,1,0	;4
	SprChrDataB	$1d,3,1,0	;5
	SprChrDataB	$1e,3,1,0	;6
	SprChrDataB	$18,3,1,0	;7
	SprChrDataB	$18,3,1,0	;8
	SprChrDataB	$1e,3,1,1	;9
	SprChrDataB	$1d,3,1,0	;a
	SprChrDataB	$1d,3,1,0	;b
	SprChrDataB	$1d,3,1,0	;c
	SprChrDataB	$1f,3,1,0	;d
	SprChrDataB	$1c,3,1,1	;e
	SprChrDataB	$19,3,1,0	;f
;20
	SprChrDataB	$19,3,1,0	;0
	SprChrDataB	$20,3,1,0	;1	
	SprChrDataB	$21,3,1,0	;2
	SprChrDataB	$18,3,1,0	;3
	SprChrDataB	$18,3,1,0	;4
	SprChrDataB	$18,3,1,0	;5
	SprChrDataB	$18,3,1,0	;6
	SprChrDataB	$22,3,1,0	;7
	SprChrDataB	$22,3,1,1	;8
	SprChrDataB	$18,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$18,3,1,0	;b
	SprChrDataB	$18,3,1,0	;c
	SprChrDataB	$18,3,1,0	;d
	SprChrDataB	$21,3,1,1	;e
	SprChrDataB	$23,3,1,0	;f
;30
	SprChrDataB	$24,3,1,0	;0
	SprChrDataB	$25,3,1,0	;1	
	SprChrDataB	$21,3,1,0	;2
	SprChrDataB	$18,3,1,0	;3
	SprChrDataB	$18,3,1,0	;4
	SprChrDataB	$18,3,1,0	;5
	SprChrDataB	$26,3,1,0	;6
	SprChrDataB	$18,3,1,0	;7
	SprChrDataB	$18,3,1,0	;8
	SprChrDataB	$26,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$18,3,1,0	;b
	SprChrDataB	$18,3,1,0	;c
	SprChrDataB	$18,3,1,0	;d
	SprChrDataB	$21,3,1,1	;e
	SprChrDataB	$27,3,1,0	;f

;40
	SprChrDataB	$28,3,1,0	;0
	SprChrDataB	$28,3,1,0	;1	
	SprChrDataB	$21,3,1,0	;2
	SprChrDataB	$18,3,1,0	;3
	SprChrDataB	$18,3,1,0	;4
	SprChrDataB	$18,3,1,0	;5
	SprChrDataB	$18,3,1,0	;6
	SprChrDataB	$18,3,1,0	;7
	SprChrDataB	$18,3,1,0	;8
	SprChrDataB	$18,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$18,3,1,0	;b
	SprChrDataB	$18,3,1,0	;c
	SprChrDataB	$18,3,1,0	;d
	SprChrDataB	$21,3,1,1	;e
	SprChrDataB	$28,3,1,0	;f
;50
	SprChrDataB	$18,3,1,0	;0
	SprChrDataB	$18,3,1,0	;1	
	SprChrDataB	$29,3,1,0	;2
	SprChrDataB	$29,3,1,1	;3
	SprChrDataB	$18,3,1,0	;4
	SprChrDataB	$18,3,1,0	;5
	SprChrDataB	$26,3,1,0	;6
	SprChrDataB	$29,3,1,0	;7
	SprChrDataB	$29,3,1,1	;8
	SprChrDataB	$26,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$18,3,1,0	;b
	SprChrDataB	$29,3,1,0	;c
	SprChrDataB	$29,3,1,1	;d
	SprChrDataB	$18,3,1,0	;e
	SprChrDataB	$18,3,1,0	;f

;60
	SprChrDataB	$2a,3,1,0	;0
	SprChrDataB	$18,3,1,0	;1	
	SprChrDataB	$2b,3,1,0	;2
	SprChrDataB	$2b,3,1,1	;3
	SprChrDataB	$18,3,1,0	;4
	SprChrDataB	$2a,3,1,0	;5
	SprChrDataB	$18,3,1,0	;6
	SprChrDataB	$2b,3,1,0	;7
	SprChrDataB	$2b,3,1,1	;8
	SprChrDataB	$18,3,1,0	;9
	SprChrDataB	$2a,3,1,0	;a
	SprChrDataB	$18,3,1,0	;b
	SprChrDataB	$2b,3,1,0	;c
	SprChrDataB	$2b,3,1,1	;d
	SprChrDataB	$18,3,1,0	;e
	SprChrDataB	$2a,3,1,0	;f
;70
	SprChrDataB	$18,3,1,0	;0
	SprChrDataB	$18,3,1,0	;1	
	SprChrDataB	$29,3,1,0	;2
	SprChrDataB	$29,3,1,1	;3
	SprChrDataB	$18,3,1,0	;4
	SprChrDataB	$18,3,1,0	;5
	SprChrDataB	$18,3,1,0	;6
	SprChrDataB	$29,3,1,0	;7
	SprChrDataB	$29,3,1,1	;8
	SprChrDataB	$18,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$18,3,1,0	;b
	SprChrDataB	$29,3,1,0	;c
	SprChrDataB	$29,3,1,1	;d
	SprChrDataB	$18,3,1,0	;e
	SprChrDataB	$18,3,1,0	;f
;80
	SprChrDataB	$18,3,1,0	;0
	SprChrDataB	$18,3,1,0	;1	
	SprChrDataB	$18,3,1,0	;2
	SprChrDataB	$18,3,1,0	;3
	SprChrDataB	$26,3,1,0	;4
	SprChrDataB	$18,3,1,0	;5
	SprChrDataB	$26,3,1,0	;6
	SprChrDataB	$18,3,1,0	;7
	SprChrDataB	$18,3,1,0	;8
	SprChrDataB	$2c,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$26,3,1,0	;b
	SprChrDataB	$18,3,1,0	;c
	SprChrDataB	$18,3,1,0	;d
	SprChrDataB	$18,3,1,0	;e
	SprChrDataB	$18,3,1,0	;f
;90
	SprChrDataB	$18,3,1,0	;0
	SprChrDataB	$2d,3,1,0	;1	
	SprChrDataB	$29,3,1,0	;2
	SprChrDataB	$29,3,1,1	;3
	SprChrDataB	$18,3,1,0	;4
	SprChrDataB	$18,3,1,0	;5
	SprChrDataB	$18,3,1,0	;6
	SprChrDataB	$29,3,1,0	;7
	SprChrDataB	$29,3,1,1	;8
	SprChrDataB	$18,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$18,3,1,0	;b
	SprChrDataB	$29,3,1,0	;c
	SprChrDataB	$29,3,1,1	;d
	SprChrDataB	$2e,3,1,0	;e
	SprChrDataB	$2f,3,1,0	;f
;a0
	SprChrDataB	$18,3,1,0	;0
	SprChrDataB	$30,3,1,0	;1	
	SprChrDataB	$25,3,1,3	;2
	SprChrDataB	$31,3,1,0	;3
	SprChrDataB	$32,3,1,0	;4
	SprChrDataB	$18,3,1,0	;5
	SprChrDataB	$26,3,1,0	;6
	SprChrDataB	$18,3,1,0	;7
	SprChrDataB	$18,3,1,0	;8
	SprChrDataB	$26,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$26,3,1,0	;b
	SprChrDataB	$18,3,1,0	;c
	SprChrDataB	$18,3,1,0	;d
	SprChrDataB	$33,3,1,0	;e
	SprChrDataB	$34,3,1,0	;f
;b0
	SprChrDataB	$31,3,1,1	;0
	SprChrDataB	$35,3,1,0	;1	
	SprChrDataB	$36,3,1,0	;2
	SprChrDataB	$37,3,1,0	;3
	SprChrDataB	$38,3,1,0	;4
	SprChrDataB	$39,3,1,0	;5
	SprChrDataB	$3a,3,1,0	;6
	SprChrDataB	$18,3,1,0	;7
	SprChrDataB	$18,3,1,0	;8
	SprChrDataB	$3b,3,1,0	;9
	SprChrDataB	$18,3,1,0	;a
	SprChrDataB	$18,3,1,0	;b
	SprChrDataB	$3c,3,1,0	;c
	SprChrDataB	$31,3,1,0	;d
	SprChrDataB	$3d,3,1,0	;e
	SprChrDataB	$18,3,1,0	;f
;c0
	SprChrDataB	$3e,3,1,0	;0
	SprChrDataB	$19,3,1,0	;1	
	SprChrDataB	$3f,3,1,0	;2
	SprChrDataB	$40,3,1,0	;3
	SprChrDataB	$3f,3,1,0	;4
	SprChrDataB	$41,3,1,0	;5
	SprChrDataB	$42,3,1,0	;6
	SprChrDataB	$18,3,1,0	;7
	SprChrDataB	$43,3,1,0	;8
	SprChrDataB	$44,3,1,0	;9
	SprChrDataB	$45,3,1,0	;a
	SprChrDataB	$46,3,1,0	;b
	SprChrDataB	$40,3,1,1	;c
	SprChrDataB	$3f,3,1,1	;d
	SprChrDataB	$47,3,1,0	;e
	SprChrDataB	$48,3,1,0	;f
;d0
	SprChrDataB	$19,3,1,0	;0
	SprChrDataB	$19,3,1,0	;1	
	SprChrDataB	$19,3,1,0	;2
	SprChrDataB	$49,3,1,0	;3
	SprChrDataB	$19,3,1,0	;4
	SprChrDataB	$49,3,1,0	;5
	SprChrDataB	$47,3,1,0	;6
	SprChrDataB	$4a,3,1,0	;7
	SprChrDataB	$4b,3,1,0	;8
	SprChrDataB	$4c,3,1,0	;9
	SprChrDataB	$4d,3,1,0	;a
	SprChrDataB	$4e,3,1,0	;b
	SprChrDataB	$49,3,1,1	;c
	SprChrDataB	$19,3,1,0	;d
	SprChrDataB	$19,3,1,0	;e
	SprChrDataB	$19,3,1,0	;f
;e0
	SprChrDataB	$19,3,1,0	;0
	SprChrDataB	$19,3,1,0	;1	
	SprChrDataB	$3f,3,1,0	;2
	SprChrDataB	$4f,3,1,0	;3
	SprChrDataB	$3f,3,1,0	;4
	SprChrDataB	$50,3,1,0	;5
	SprChrDataB	$19,3,1,0	;6
	SprChrDataB	$47,3,1,0	;7
	SprChrDataB	$4e,3,1,0	;8
	SprChrDataB	$19,3,1,0	;9
	SprChrDataB	$50,3,1,1	;a
	SprChrDataB	$3f,3,1,1	;b
	SprChrDataB	$4f,3,1,1	;c
	SprChrDataB	$3f,3,1,1	;d
	SprChrDataB	$19,3,1,0	;e
	SprChrDataB	$19,3,1,0	;f
;f0
	SprChrDataB	$19,3,1,0	;0
	SprChrDataB	$19,3,1,0	;1	
	SprChrDataB	$19,3,1,0	;2
	SprChrDataB	$49,3,1,0	;3
	SprChrDataB	$19,3,1,0	;4
	SprChrDataB	$49,3,1,0	;5
	SprChrDataB	$19,3,1,0	;6
	SprChrDataB	$19,3,1,0	;7
	SprChrDataB	$19,3,1,0	;8
	SprChrDataB	$19,3,1,0	;9
	SprChrDataB	$49,3,1,1	;a
	SprChrDataB	$19,3,1,0	;b
	SprChrDataB	$49,3,1,1	;c
	SprChrDataB	$19,3,1,0	;d
	SprChrDataB	$19,3,1,0	;e
	SprChrDataB	$19,3,1,0	;f
	endc
;--------------------------------------------------------------------
;========= Playercocjpit data =====
cockpit1X	equ	$30
cockpit1Y	equ	$68
cockpit2X	equ	$60
cockpit2Y	equ	$0d0

;	SpriteData	x zahyo,y zahyo,character,color,prio,flip
	
cockpit_data
	ifeq	1
	SpriteData	cockpit1X+$08,cockpit1Y+$0,$16,3,3,0
	SpriteData	cockpit1X+$10,cockpit1Y+$0,$17,3,3,0
	SpriteData	cockpit1X+$18,cockpit1Y+$0,$18,3,3,0
	SpriteData	cockpit1X+$20,cockpit1Y+$0,$19,3,3,0
	SpriteData	cockpit1X+$28,cockpit1Y+$0,$1a,3,3,0
	SpriteData	cockpit1X+$30,cockpit1Y+$0,$1b,3,3,0
	SpriteData	cockpit1X+$38,cockpit1Y+$0,$1b,3,3,1
	SpriteData	cockpit1X+$40,cockpit1Y+$0,$1a,3,3,1
	SpriteData	cockpit1X+$48,cockpit1Y+$0,$19,3,3,1
	SpriteData	cockpit1X+$50,cockpit1Y+$0,$18,3,3,1
	SpriteData	cockpit1X+$58,cockpit1Y+$0,$17,3,3,1
	SpriteData	cockpit1X+$60,cockpit1Y+$0,$16,3,3,1

	SpriteData	cockpit1X+$00,cockpit1Y+$08,$1c,3,3,0
	SpriteData	cockpit1X+$08,cockpit1Y+$08,$1d,3,3,0
	SpriteData	cockpit1X+$10,cockpit1Y+$08,$1e,3,3,0
	SpriteData	cockpit1X+$18,cockpit1Y+$08,$1f,3,3,0
	SpriteData	cockpit1X+$20,cockpit1Y+$08,$20,3,3,0
	SpriteData	cockpit1X+$28,cockpit1Y+$08,$21,3,3,0
	SpriteData	cockpit1X+$30,cockpit1Y+$08,$22,3,3,0
	SpriteData	cockpit1X+$38,cockpit1Y+$08,$22,3,3,1
	SpriteData	cockpit1X+$40,cockpit1Y+$08,$21,3,3,1
	SpriteData	cockpit1X+$48,cockpit1Y+$08,$20,3,3,1
	SpriteData	cockpit1X+$50,cockpit1Y+$08,$1f,3,3,1
	SpriteData	cockpit1X+$58,cockpit1Y+$08,$1e,3,3,1
	SpriteData	cockpit1X+$60,cockpit1Y+$08,$1d,3,3,1
	SpriteData	cockpit1X+$68,cockpit1Y+$08,$1c,3,3,1

	SpriteData	cockpit2X+$08,cockpit2Y+$0,$16,4,3,0
	SpriteData	cockpit2X+$10,cockpit2Y+$0,$17,4,3,0
	SpriteData	cockpit2X+$18,cockpit2Y+$0,$18,4,3,0
	SpriteData	cockpit2X+$20,cockpit2Y+$0,$19,4,3,0
	SpriteData	cockpit2X+$28,cockpit2Y+$0,$1a,4,3,0
	SpriteData	cockpit2X+$30,cockpit2Y+$0,$1b,4,3,0
	SpriteData	cockpit2X+$38,cockpit2Y+$0,$1b,4,3,1
	SpriteData	cockpit2X+$40,cockpit2Y+$0,$1a,4,3,1
	SpriteData	cockpit2X+$48,cockpit2Y+$0,$19,4,3,1
	SpriteData	cockpit2X+$50,cockpit2Y+$0,$18,4,3,1
	SpriteData	cockpit2X+$58,cockpit2Y+$0,$17,4,3,1
	SpriteData	cockpit2X+$60,cockpit2Y+$0,$16,4,3,1

	SpriteData	cockpit2X+$00,cockpit2Y+$08,$1c,4,3,0
	SpriteData	cockpit2X+$08,cockpit2Y+$08,$1d,4,3,0
	SpriteData	cockpit2X+$10,cockpit2Y+$08,$1e,4,3,0
	SpriteData	cockpit2X+$18,cockpit2Y+$08,$1f,4,3,0
	SpriteData	cockpit2X+$20,cockpit2Y+$08,$20,4,3,0
	SpriteData	cockpit2X+$28,cockpit2Y+$08,$21,4,3,0
	SpriteData	cockpit2X+$30,cockpit2Y+$08,$22,4,3,0
	SpriteData	cockpit2X+$38,cockpit2Y+$08,$22,4,3,1
	SpriteData	cockpit2X+$40,cockpit2Y+$08,$21,4,3,1
	SpriteData	cockpit2X+$48,cockpit2Y+$08,$20,4,3,1
	SpriteData	cockpit2X+$50,cockpit2Y+$08,$1f,4,3,1
	SpriteData	cockpit2X+$58,cockpit2Y+$08,$1e,4,3,1
	SpriteData	cockpit2X+$60,cockpit2Y+$08,$1d,4,3,1
	SpriteData	cockpit2X+$68,cockpit2Y+$08,$1c,4,3,1
	endc
cockpit_data_end

SpritesBossMeterData
_sprbasex = 0
_sprbasey = 0
	IFEQ	1
	km_datacnt	W,SpritesBossMeterData
	SpriteDataW	_sprbasex+$1d*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1d*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1d*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip
	SpriteDataW	_sprbasex+$1d*8-1,_sprbasey+$19*8,$ab,colpal0,pri3,noflip
	ENDC
SpritesBossMeterDataEnd
;************************************************************************************
;************************************************************************************
;************************************************************************************
;************************************************************************************
	ENDC
