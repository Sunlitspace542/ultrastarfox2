;*********************************************************************
;*								*
;*			SOUND FLAGS		1995. 8.18	*
;*								*
;*********************************************************************
ksf_title			equ	ksf_space!kbgm_tprologue
ksf_selectmissionplayer		equ	ksf_ground!kbgm_stg1
ksf_selectmissionmap		equ	ksf_space	;!kbgm_stg1	;'95/ 6/26
ksf_selectmissionmapexp		equ	ksf_ground!kbgm_androf_base		;'95/ 3/ 4
ksf_selectmissionmapfinal	equ	ksf_ground!kbgm_stgclr		;'95/ 3/13
ksf_debugmissionmap		equ	ksf_ground	;!kbgm_stg1	;'95/ 6/26
ksf_testmissionmap		equ	ksf_nodata
ksf_missionexplain		equ	ksf_ground!kbgm_stg1


ksf_missionstage1		equ	ksf_ground!kbgm_stg1
ksf_missionstage2		equ	ksf_ground!kbgm_stg1
ksf_missionstage3		equ	ksf_ground!kbgm_stg1
ksf_missionstage4		equ	ksf_ground!kbgm_stg1
ksf_missionstage5		equ	ksf_ground!kbgm_stg1
ksf_missionstage6		equ	ksf_sea!kbgm_stg1
ksf_missionsos1			equ	ksf_space!kbgm_stg1
ksf_missionsos2			equ	ksf_space!kbgm_stg1
ksf_missionsos3			equ	ksf_space!kbgm_stg1
ksf_missionsos4			equ	ksf_space!kbgm_stg1

ksf_missionsos5			equ	ksf_space!kbgm_stg1
ksf_missionsos6			equ	ksf_space!kbgm_stg2


ksf_missionextra1		equ	ksf_space!kbgm_stg1	;'94/12/22 ;‰¼!!!
ksf_missionextra2		equ	ksf_room!kbgm_stg1
ksf_missionextra3		equ	ksf_space!kbgm_stg1
ksf_missionextra4		equ	ksf_space!kbgm_stg1

;ksf_finalstage			equ	ksf_room!kbgm_stg1	;'94/12/14

ksf_playerdown		equ	kbgm_gmover
ksf_missionresult		equ	ksf_space	;!kbgm_continue	;'95/ 6/27
ksf_detail			equ	ksf_space	;!kbgm_continue	;'95/ 6/27

ksf_record			equ	ksf_ground!kbgm_demo	;'95/ 6/26
ksf_hiscoreinput		equ	ksf_ground!kbgm_demo	;'95/ 6/26
;ksf_hiscore			equ	ksf_space!kbgm_stg2
;ksf_hiscoreinput		equ	ksf_space!kbgm_stg2

ksf_titledemo			equ	ksf_space!kbgm_map1
ksf_startenemydemo		equ	ksf_space!kbgm_map3
ksf_specialenemydemo		equ	ksf_space!kbgm_demo2
ksf_startarwingdemo  		equ	ksf_space!kbgm_demo2
ksf_corneriafelldemo		equ	ksf_space!kbgm_stg1
ksf_endingdemo			equ	ksf_ground!kbgm_end_theme
ksf_test			equ	ksf_nodata
ksf_missionandrof		equ	ksf_space!kbgm_stg1
ksf_planetcanondemo		equ	ksf_space!kbgm_map3

ksf_dummy0demo		equ	ksf_nodata
ksf_dummy1demo		equ	ksf_nodata
ksf_dummy2demo		equ	ksf_nodata

ksf_selectbattlefield		equ	ksf_ground!kbgm_stg1
ksf_selectbattleplayer		equ	ksf_ground!kbgm_stg1
ksf_battlestage1		equ	ksf_ground!kbgm_stg1
ksf_battlestage2		equ	ksf_space!kbgm_stg1
ksf_battlestage3		equ	ksf_room!kbgm_stg1
;ksf_battlestage4		equ	ksf_space!kbgm_stg1
;ksf_battlestage5		equ	ksf_sea!kbgm_stg1

ksf_training			equ	ksf_ground!kbgm_stg1
ksf_typeselect			equ	ksf_nodata

ksf_endtalk			equ	ksf_space!kbgm_stg1
ksf_endtalkconfig		equ	ksf_space!kbgm_stg1
ksf_secretstar			equ	ksf_ground!kbgm_stg1

;*********************************************************************
;*								*
;*			Sound Tables(HIGH SPEED)1995. 8.18	*
;*								*
;*********************************************************************
;--------------------------------------------------------------------
;	DB	COUNTER
;	DB	Sound_Flag
;
;	DL	SoundFileAddress1
;	DL	SoundFileAddress2
;	DL	SoundFileAddress3
;			.
;			.
;			.
;--------------------------------------------------------------------
SoundTransTbl
	sndtbldata	title,music01,sdspac,sdse2,sdst1,sdst2			;sdad1
	sndtbldata	selectmissionplayer,music03,music14,sdgrd1,sdgrd2,sdse2,sdinf
	sndtbldata	selectmissionmap,music02,sdspac,sdse2,sdst1,mapse	;sdad1	;sdst1
	sndtbldata	selectmissionmapexp,music02	;,sdspac		;HIGH SPEED
	sndtbldata	selectmissionmapfinal,music02,sdspac			;'95/ 3/10
	sndtbldata	debugmissionmap,music02,sdspac,sdse2,sdst1,mapse	;sdad1	;training start
	sndtbldata	missionexplain,music04,sdgrd1,sdgrd2,sdinf

	sndtbldata	missionstage1,music20,music05,sdgrd1,sdgrd2,sdst6,grdwtr
	sndtbldata	missionstage2,music20,music06,sdgrd1,sdgrd3,sdst3,grdwtr
	sndtbldata	missionstage3,music20,music07,sdgrd1,sdgrd2,sdst3,vlcwtr
	sndtbldata	missionstage4,music20,music08,sdgrd1,sdgrd2,sdst6,grdwtr
	sndtbldata	missionstage5,music20,music09,sdgrd1,sdgrd3,sdst3
	sndtbldata	missionstage6,music24,music10,sdspac,sdst6,seawtr

	sndtbldata	missionextra1,music24,music21,music11,sdspac
	sndtbldata	missionextra2,music24,music21,music18,sdspac,sdse2,sdst1,sdst2		;sdad1	;'94/12/22  ;‰¼!!!
	sndtbldata	missionextra3,music24,music21,music13,sdspac
	sndtbldata	missionextra4,music24,music21,music13,sdspac
	sndtbldata      missionsos1,music24,music21,music25,music11,sdspac,sdst5
	sndtbldata      missionsos2,music24,music21,music25,music12,sdspac,sdst5
	sndtbldata      missionsos3,music24,music21,music13,sdspac,sdst3,sdst7
	sndtbldata      missionsos4,music24,music21,music15,sdspac,sdst1
	sndtbldata      missionsos5,music24,music21,music16,sdspac,sdst4	;satellite
	sndtbldata      missionsos6,music24,music21,music25,sdspac,sdst5	;starwolf(new)

;	sndtbldata	finalstage,music24,music21,music12,sdspac,sdst1,sdst2		;sdad1	;'94/12/14

	sndtbldata	playerdown,music17,sdspac,sdcnt,sdovr
	sndtbldata	missionresult,music17,sdspac,sdse1	;,sdse2	;HIGH SPEED		;'95/ 6/17
	sndtbldata	detail,music17,sdspac
;ground
;	sndtbldata	playerdown,music17,sdgrd1,sdgrd2,sdcnt,sdovr
;	sndtbldata	missionresult,music17,sdgrd1,sdgrd2,sdse1	;,sdse2	;HIGH SPEED		;'95/ 6/17
;	sndtbldata	detail,music17

	sndtbldata	record,music03,sdgrd1,sdgrd2	;,sdse1,sdse2		;HIGH SPEED
	sndtbldata	hiscoreinput,music03		;,sdgrd1,sdgrd2		;HIGH SPEED

;	sndtbldata	titledemo,sdst1				;init trans test '95/6/21
	sndtbldata	titledemo,music01,sdspac,sdse1,sdst1	;,sdse2
	sndtbldata	startenemydemo
	sndtbldata	dummy0demo
	sndtbldata	startarwingdemo,music01,sdspac
	sndtbldata	corneriafelldemo,music23,sdspac,sddis
	sndtbldata	dummy1demo
	sndtbldata	endingdemo,music19,sdspac,sdend1
	sndtbldata	missionandrof,music24,music21,music18,music18b,sdspac,sdse2,sdst1	;sdad1
	sndtbldata	specialenemydemo	;,music02,sdspac		;HIGH SPEED
	sndtbldata	dummy2demo
	sndtbldata	planetcanondemo,music23,sdspac
	sndtbldata	test

	sndtbldata	selectbattlefield,music03,sdgrd1,sdgrd2
	sndtbldata	selectbattleplayer,music03,sdgrd1,sdgrd2

	sndtbldata	battlestage1,music20,music14,sdgrd1,sdgrd2,grdwtr
	sndtbldata      battlestage2,music24,music21,music15,sdspac
	sndtbldata      battlestage3,music24,music21,music16,sdspac

	sndtbldata	typeselect,music03,sdgrd1,sdgrd2
	sndtbldata	training,music22,music20,sdgrd1,sdgrd2

	sndtbldata	endtalk,music24,music21,music22,sdspac,sdtlk
	IFNE	configimprovements
	sndtbldata	endtalkconfig,music24,music21,music22,sdspac	; so other songs won't sound weird when using it in sound test
	ENDC
	sndtbldata	secretstar,music20,music05,sdgrd1,sdgrd2,sdst6,grdwtr

	sndtbldata	nodata
;
;*********************************************************************
;*								*
;*		Sound Special Tables	1994.10.22		*
;*								*
;*********************************************************************
;=====================================================================
;*		Special Sound Relative Address Table		*
;=====================================================================
SoundSpecialAddrTbl
;--------------------------------------------------------------------
;	DW	soundsp_{label}-SoundSpecialTransTbl&WM
;--------------------------------------------------------------------
	sndspaddr	nodata
	sndspaddr	data1
	sndspaddr	data2
	sndspaddr	data3
	sndspaddr	data4
	sndspaddr	data5
	sndspaddr	data6
	sndspaddr	data7
	sndspaddr	data8
	sndspaddr	data9
;=====================================================================
;*								*
;*		Special Sound Data Table			*
;*								*
;=====================================================================
SoundSpecialTransTbl
;--------------------------------------------------------------------
;	DB	COUNTER
;	DL	SoundFileAddress1
;	DL	SoundFileAddress2
;	DL	SoundFileAddress3
;			.
;			.
;			.
;--------------------------------------------------------------------
	sndsptbldata	nodata
	sndsptbldata	data1,sdst1
	sndsptbldata	data2,sdst2
	sndsptbldata	data3,sdst3
	sndsptbldata	data4,sdst4
	sndsptbldata	data5,sdst5
	sndsptbldata	data6,sdst6
	sndsptbldata	data7,sdst7
	sndsptbldata	data8,sdst1
	sndsptbldata	data9,sdst2
;---------------------------------------------------------------------
;=====================================================================
;*								*
;*		Special Sound Data Table	'95. 3.22	*
;*								*
;=====================================================================
configSNDtbl
	IFNE	configimprovements
	km_gamesoundptr	title			;0	1
	km_gamesoundptr	selectmissionmap	;1	2
	km_gamesoundptr	selectmissionplayer	;2	3+14
	km_gamesoundptr	missionexplain		;3	4
	km_gamesoundptr	missionstage1		;4	5
	km_gamesoundptr	missionstage2		;5	6
	km_gamesoundptr	missionstage3		;6	7
	km_gamesoundptr	missionstage4		;7	8	
	km_gamesoundptr	missionstage5		;8	9
	km_gamesoundptr	missionstage6		;9	10
	km_gamesoundptr	missionsos1		;a	11
	km_gamesoundptr	missionsos2		;b	12
	km_gamesoundptr	missionsos3		;c	13
	km_gamesoundptr	missionsos4		;d	15
	km_gamesoundptr	missionsos5		;e	16
	km_gamesoundptr	missionsos6		;f	25
	km_gamesoundptr	playerdown		;10	17
	km_gamesoundptr	missionextra2		;11	18
	km_gamesoundptr	missionandrof		;12	18b
	km_gamesoundptr	endtalkconfig		;13	22
	km_gamesoundptr	endingdemo		;14	19
	km_gamesoundptr	corneriafelldemo	;15	23
	ELSEIF
	km_gamesoundptr	title			;0	0
	km_gamesoundptr	title			;1	1
	km_gamesoundptr	selectmissionmap	;2	2
	km_gamesoundptr	selectmissionplayer	;3	3
	km_gamesoundptr	missionexplain		;4	4
	km_gamesoundptr	missionstage1		;5	5
	km_gamesoundptr	missionstage2		;6	6
	km_gamesoundptr	missionstage3		;7	7
	km_gamesoundptr	missionstage4		;8	8	
	km_gamesoundptr	missionstage5		;9	9
	km_gamesoundptr	missionstage6		;a	10
	km_gamesoundptr	missionsos1		;b	11
	km_gamesoundptr	missionsos2		;c	12
	km_gamesoundptr	missionsos3		;d	13
	km_gamesoundptr	battlestage1		;e	14
	km_gamesoundptr	missionsos4		;f	15
	km_gamesoundptr	missionsos5		;10	16
	km_gamesoundptr	playerdown		;11	17
	km_gamesoundptr	missionextra2		;12	18
	km_gamesoundptr	missionandrof		;13	18b
	km_gamesoundptr	endingdemo		;14	19
	km_gamesoundptr	endingdemo		;15	22
	km_gamesoundptr	corneriafelldemo	;16	23
	km_gamesoundptr	missionsos6		;17	25
	ENDC
configSNDtblEND
	km_datalen	configSNDtbl


