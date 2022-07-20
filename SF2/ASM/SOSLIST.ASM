;*****************************************************************************
;*									*
;*									*
;*			Data Table					*
;*									*
;* Total BYTE = 192 byte							*
;*****************************************************************************
km_zacoappearend	macro
	db	0
	endm
km_zacoappeartrigger	macro	[time,kazu]
	db	1
	dw	{time}
	db	{kazu}
	endm
km_zacoappearwaittrig	macro	[time,kazu,loop]
	db	2
	dw	{time}
	db	{kazu}
	db	{loop}
	endm
km_zacoappearwait	macro
	db	3
	endm
km_zacoappearlooptrig	macro	[time,kazu,loop]
	db	4
	dw	{time}
	db	{kazu}
	db	{loop}
	endm

km_zacoappearloop	macro
	db	5
	endm
;*********************************************************************
;*								*
;*		Zaco Chart (Battle Ship)			*
;*								*
;*********************************************************************
mm_ZacoChartTable
	dw	mm_ZacoType1-mm_ZacoChartTable
	dw	mm_ZacoType2-mm_ZacoChartTable
	dw	mm_ZacoType3-mm_ZacoChartTable
	dw	mm_ZacoType4-mm_ZacoChartTable
	dw	mm_ZacoType5-mm_ZacoChartTable
	dw	mm_ZacoType6-mm_ZacoChartTable
	dw	mm_ZacoType7-mm_ZacoChartTable
	dw	mm_ZacoType8-mm_ZacoChartTable
	dw	mm_ZacoType9-mm_ZacoChartTable
	dw	mm_ZacoType10-mm_ZacoChartTable
	dw	mm_ZacoType11-mm_ZacoChartTable
	dw	mm_ZacoType12-mm_ZacoChartTable
	dw	mm_ZacoType13-mm_ZacoChartTable
;* easy *
mm_ZacoType1
mm_ZacoType2
	km_zacoappearwaittrig	1,1,1
	km_zacoappearwait
	km_zacoappearwaittrig	sos_zacotmE,1,255
	km_zacoappearwait
	km_zacoappearend

mm_ZacoType3
mm_ZacoType4
mm_ZacoType5
mm_ZacoType6
	km_zacoappearwaittrig	1,1,1
	km_zacoappearwait
	km_zacoappearwaittrig	sos_zacotmN,1,255
	km_zacoappearwait
	km_zacoappearend
mm_ZacoType7
mm_ZacoType8
mm_ZacoType9
mm_ZacoType10
mm_ZacoType11
mm_ZacoType12
mm_ZacoType13
	km_zacoappearwaittrig	1,1,1
	km_zacoappearwait
	km_zacoappearwaittrig	sos_zacotmH,1,255
	km_zacoappearwait
	km_zacoappearend
;=====================================================================
;*								*
;*		Sprites Size Flag Table				*
;*								*
;=====================================================================
;* 4 chr mode *
mm_SpriteSizeFlag	;(4 byte)
	db	%00000010	;0
	db	%00001000	;4
	db	%00100000	;8
	db	%10000000	;c
;* 16 chr mode *
mm_SpriteSizeFlag16	;(8 byte)
	db	%10101010	;all
	db	%00000000
	db	%10101000
	db	%00000010
	db	%10100000
	db	%00001010
	db	%10000000
	db	%00101010
;---------------------------------------------------------------------
mm_objnumbertbl
;10 byte
	db	2,3,4,5,6,$12,$13,$14,$15,$16
sendmarktbl
;4 byte
	db	$2e,$2f,$3e,$3f

;=====================================================================
;*		Planet Destination Postion Table		*
;=====================================================================
mm_destpostbl	;(16 byte)
	db	0,0
	db	mm_planet1x,mm_planet1y
	db	mm_planet2x,mm_planet2y
	db	mm_planet3x,mm_planet3y
	db	mm_planet4x,mm_planet4y
	db	mm_planet5x,mm_planet5y
	db	mm_planet6x,mm_planet6y
	db	mothercx,mothercy

;=====================================================================
;*			Enemy Tables				*
;=====================================================================
sostypetbl	;(32 byte)
	db	entyp_zaco1	;00
	db	entyp_zaco2	;01
	db	entyp_zaco1	;02
	db	entyp_zaco2	;03
	db	entyp_zaco1	;04
	db	entyp_zaco3	;05
	db	entyp_zaco2	;06
	db	entyp_zaco1	;07
	db	entyp_zaco2	;08
	db	entyp_zaco1	;09
	db	entyp_zaco1	;0a
	db	entyp_zaco3	;0b
	db	entyp_zaco2	;0c
	db	entyp_zaco1	;0d
	db	entyp_zaco1	;0e
	db	entyp_zaco2	;0f
	db	entyp_zaco1	;10
	db	entyp_zaco2	;11
	db	entyp_zaco3	;12
	db	entyp_zaco1	;13
	db	entyp_zaco3	;14
	db	entyp_zaco1	;15
	db	entyp_zaco1	;16
	db	entyp_zaco2	;17
	db	entyp_zaco1	;18
	db	entyp_zaco2	;19
	db	entyp_zaco1	;1a
	db	entyp_zaco3	;1b
	db	entyp_zaco1	;1c
	db	entyp_zaco2	;1d
	db	entyp_zaco1	;1e
	db	entyp_zaco2	;1f
;-------------------------------------------------------------------------
;---------------------------------------------------------------------
;*			SOS Enemy Appear Velocity		*
;---------------------------------------------------------------------
soszacovelxtbl	;(8 byte)
	dw	sos_appearspeed*4
	dw	-sos_appearspeed*4
	dw	-sos_appearspeed*1
	dw	sos_appearspeed*3

soszacovelytbl	;(8 byte)
	dw	sos_appearspeed*2
	dw	-sos_appearspeed*2
	dw	-sos_appearspeed*3
	dw	-sos_appearspeed

;---------------------------------------------------------------------
;*			SOS Enemy Velocity			*
;---------------------------------------------------------------------
enemyspeedtbl	;(24 byte)
;* easy *
	dw	sos_zacosp1_easy
	dw	sos_zacosp2_easy
	dw	sos_zacosp3_easy
	dw	sos_missilesp_easy
enemyspeedtblEND
	km_datalen	enemyspeedtbl

;* normal *
	dw	sos_zacosp1_normal
	dw	sos_zacosp2_normal
	dw	sos_zacosp3_normal
	dw	sos_missilesp_normal
;* hard *
	dw	sos_zacosp1_hard
	dw	sos_zacosp2_hard
	dw	sos_zacosp3_hard
	dw	sos_missilesp_hard

SOSSpeedBase
;(3 byte)
	db	enemyspeedtbllen*0	;easy
	db	enemyspeedtbllen*1	;normal
	db	enemyspeedtbllen*2	;hard
;---------------------------------------------------------------------	
;*			Bit Table				*
;---------------------------------------------------------------------
sosbittbl	;12 byte	(1,2,4,8,16,32,64,128,256,512)
	dw	%0000000000000001
	dw	%0000000000000010
	dw	%0000000000000100
	dw	%0000000000001000
	dw	%0000000000010000
	dw	%0000000000100000
	dw	%0000000001000000
	dw	%0000000010000000
	dw	%0000000100000000
	dw	%0000001000000000
;---------------------------------------------------------------------
;*								*
;*		SOS Appear Wait Time Table			*
;*								*
;---------------------------------------------------------------------
SOSAppeartmBase
;3 byte
	db	sos_easytmbase		;easy base pointer
	db	sos_normaltmbase	;normal base pointer
	db	sos_hardtmbase		;hard base pointer

SOSappeartmtbl
;36 byte
;* easy *
	dw	sos_stg1tmE
	dw	sos_stg2tmE
	dw	sos_stg3tmE
	dw	sos_stg4tmE
	dw	sos_stg5tmE
	dw	sos_stg6tmE
	dw	sos_shiptmE
;* normal *
	dw	sos_stg1tmN
	dw	sos_stg2tmN
	dw	sos_stg3tmN
	dw	sos_stg4tmN
	dw	sos_stg5tmN
	dw	sos_stg6tmN
	dw	sos_shiptmN
;* hard *
	dw	sos_stg1tmH
	dw	sos_stg2tmH
	dw	sos_stg3tmH
	dw	sos_stg4tmH
	dw	sos_stg5tmH
	dw	sos_stg6tmH
	dw	sos_shiptmH
;---------------------------------------------------------------------
;*		Planet Skill Offset				*
;* currentlevel (0~)<<<< planet skill ofset + random ptr (0~7)	*
;---------------------------------------------------------------------
planetskilloff	;(3 byte)
	db	planetoff_easy		;4
	db	planetoff_normal	;8
	db	planetoff_hard		;13
;---------------------------------------------------------------------
;*			SOS Enemy Skill Offset			*
;* currentlevel (0~f)<<<< sos skill ofset + random ptr (0~0f)	*
;---------------------------------------------------------------------
sosskilloffset	;(3 byte)
	db	sosoff_easy	;easy	;$00
	db	sosoff_normal	;normal	;$08
	db	sosoff_hard	;hard	;$10
;---------------------------------------------------------------------
MissileSkillOffset	;(3 byte)
	db	misoff_easy	;easy	;$18
	db	misoff_normal	;normal	;$1a
	db	misoff_hard	;hard	;$1c

;---------------------------------------------------------------------
;*		Enter Planet Zaco Enemy Velocity		*
;---------------------------------------------------------------------
entervelxtbl	;(32 byte)
	dw	endestvelAX
	dw	endestvelAX>>16
	dw	endestvelBX
	dw	endestvelBX>>16
	dw	endestvelCX
	dw	endestvelCX>>16
	dw	endestvelDX
	dw	endestvelDX>>16
entervelytbl
	dw	endestvelAY
	dw	endestvelAY>>16
	dw	endestvelBY
	dw	endestvelBY>>16
	dw	endestvelCY
	dw	endestvelCY>>16
	dw	endestvelDY
	dw	endestvelDY>>16

mm_soundtable
	db	sport3_en_sos_appear	;1
	db	sport3_en_mis_hassha	;2
	db	sport3_corneria_explode	;4
	db	sport3_mis_explode	;8
	db	sport3_en_b_ship_appear	;16
	db	sport3_en_taiman_appear	;32
	db	sport3_system_charge	;64
