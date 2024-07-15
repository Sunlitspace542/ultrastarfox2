;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         INTRO.ASM                                           ;
; AUTHOR:       Dylan Cuthbert & Yasuhiro Kawaguchi                 ;
; DESCRIPTION:  Game Intro Code                                     ;
; DATE CREATED: 16-2-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
	incpub	intro
; INTRO SEQUENCE

;*********************************************************************
;*								*
;*			GAME SEQUENCE				*
;*								*
;*********************************************************************
intro_l
	km_pushallreg			;registers PUSH
	a8i16
	km_screenoff			;Screen OFF

	km_setgamemode		demo
	km_setdemonumber	titledemo
;--------------------------------------------------------------------
.MAINLOOP
	km_cmpcheckgamemode	end
	beq	.intro_end

	km_nastycheck
;*kawaguchi Tmporary RAM Clear *
;(kokode Clear shinaito dame !!)
	km_clrKAWARAM			;[WORK RAM CLEAR]

;* Initial Sequence Parameters *
	jsr	InitialSequence

;* GAME Sequence Jump *
	a16
	km_ldxsequenceptr		;GAME Sequence Pointer
	lda.l	kgamesequence+2,x
	sta	kw_setsndaddr		;Sound Set Address
	a8
	jsr	(kgamesequence,x)	;Jump Sequence
	bra	.MAINLOOP
;--------------------------------------------------------------------
.intro_end
	km_pullallreg			;PULL registers
	rtl


;=====================================================================
;*			ROM&RAM Nasty Check			*
;=====================================================================
knastycheck_l
	php
	a8
	lda	mario_draw_mode
	bit	#mm_ramn+mm_romn
	beq	.OK
	kbug6
	blink	3
.OK
	plp
	rtl

;=====================================================================
;*		Kawaguchi Temporary RAM Clear			*
;=====================================================================
clear_kawaram_l
	php
	a8i16
	km_clralc   kwork		;[work RAM 0 clear]
	km_clralc   kw_swork		;[work RAM 0 clear]
	km_clralc   keywork		;[work RAM 0 clear]
	km_clrxalc  kxwork		;[work RAM 0 clear]
	km_clrxalc  kxswork		;[work RAM 0 clear]
	plp
	rtl

;=====================================================================
;*		Initial Sequence States				*
;=====================================================================
InitialSequence
	a16
;* flags *
	km_clrmissionflag	parallel	;[MISSION FLAG]

;* Key States *
;	stz	cont0	:'95/6/27 :cont no value wa clear suruna !! (yajima's dvice)
;	stz	cont1	:'95/6/27 :cont no value wa clear suruna !! (yajima's dvice)
	stz	trig0
	stz	trig1

;* Screen Mode *
	stz	screenmode

;* mission syori initial *
	km_setmissionsyori	normal
;* wipe initial *
	km_clrwipeclose
	a8
	rts

;=====================================================================
;*								*
;*			JUMP TABLE				*
;*								*
;=====================================================================
;---------------------------------------------------------------------
;	dw jump_{addr}&WM			;0 :sequence mode
;	dw (sound_{addr}-SoundTransTbl)&WM	;2 :sound mode
;---------------------------------------------------------------------
kgamesequence
;**** Polygon Screen ****
	km_gamemode	title			;
	km_gamemode	initmission,nosnd	;
	km_gamemode	missionexplain		;
	km_gamemode	playerdown		;
	km_gamemode	demo,nosnd		;
	km_gamemode	training		;

;**** No Polygon Screen ****
	km_gamemode	selectmissionplayer	;
	km_gamemode	selectmissionmap	;
	km_gamemode	missionresult		;
	km_gamemode	hiscoreinput		;
	km_gamemode	record			;
	km_gamemode	detail			;
;*** TEST ***
	km_gamemode	debugmissionmap		;
	km_gamemode	testmissionmap,nosnd	;
	km_gamemode	testplanetstep,nosnd	;
	km_gamemode	config,nosnd		;
;*** END ***
	km_gamemode	end,nosnd		;

;	km_gamemode	3dglasses,nosnd		;
;	km_gamemode	testbattlefield,nosnd	;
;	km_gamemode	testgamemode,nosnd	;
;	km_gamemode	testlocation,nosnd	;
;	km_gamemode	testplayer,nosnd	;
;	km_gamemode	testuser,nosnd		;
;	km_gamemode	testmissionlevel,nosnd	;
;	km_gamemode	selectbattlefield	;
;	km_gamemode	selectbattleplayer	;
;	km_gamemode	typeselect		;
;	km_gamemode	initbattle,nosnd	;
;*********************************************************************
;*								*
;*			Game Routine				*
;*								*
;*********************************************************************
;=====================================================================
;*								*
;*			Title					*
;*								*
;=====================================================================
	shorta
	longi
jump_title
;* SCREEN SET UP *
	a16
	km_clrgameflag		battle		;[GAME FLAG]
	km_clrgameflag		test		;[GAME FLAG]
	km_setscreenflag	sprwbuf		;[SCREEN FLAG]
;	km_setscrollflag	raster		;[h-v scroll flag]
	a8
	lda	#st_titlescr
	sta	screentype			;[SCREEN TYPE]
	km_setspritemode	title		;[SPRITE MODE]
	km_setscreenmode	title		;[SCREEN MODE]

;* MAP *
	lda	#titlemap>>16
	ldx	#titlemap&$7fff
	sta	mapbank
	stx	mapptr
	km_setvar	key_yokoptr1,monoral
	km_setval	key_yokomaxptr1,2

* wipe init & open *
	km_initwipeopen	title
	brl	main_intro

;=====================================================================
;*								*
;*		Mission Game Initial Main			*
;*								*
;=====================================================================
	shorta
	longi
jump_initmission
	lda	#st_normalscr
	sta	screentype			;[SCREEN TYPE]

	km_setspritemode	mission		;[SPRITE MODE]
	km_setscreenmode	mission		;[SCREEN MODE]
;;;	km_setgamesyori		main		;[GAME SYORI]
	a16
	km_clrgameflag		battle		;[GAME FLAG]
	km_setmistotalflag	mission		;[GAME FLAG]
	km_setscreenflag	sprwbuf		;[SCREEN FALG]
	km_setscreenflag	screenadd	;[SCREEN FLAG]
	km_setscreenflag	halfadd		;[SCREEN FLAG]
;;;	km_setscreenflag	objcolpal	;[SCREEN FLAG]
	km_setscrollflag	raster		;[h-v scroll flag]
	a8

;*'95/8/23 :zaco tekini beem ga ataranai bug (report :arimoto)*
	km_setval.l	eandorf_mode,0		;(For Eguchi)

;* wipe init & open *
	km_initwipeopen	mission

;* wolf boss check *
	a16
	km_bitcheckmismapflag2	wolfboss	;kono flag wa InitWolfTeam2 no maeni oku !!
	beq	.not_wolfboss
	km_setmissionflag	enemygonefreeze
.not_wolfboss
;* enemy number initial *
	km_bitcheckmistotalflag	finalbossbattle
	beq	.skip

	km_setmissionflag	enemygonefreeze

  	km_setval.l	kenemynumber,1
	lda.l	kdifficulty
	sta	currentlevel
	jsl	init_ealcs_l
.skip

;* Game Map Setting *
	a8
	lda	KGameMapPtr
	inc	a
	sta	kGameMap

;* Game Time Copy *
	a16
	lda.l	kx_TOTALTIME
	sta.l	kx_TOTALTIMEBak

;* Radar Scale Initial *
	km_clrmismapflag	autoradar
	km_cmpcheck	KGameMapPtr,stg_sos1
	bmi	.skip2
	km_setmismapflag	autoradar
.skip2
	a8
;* *
	ldx	kgamemapptr
	lda.l	missionmapCOLtbl,x
	sta	kw_PlanetCol		;Near Planet Screen !!

;* sound *
	a16
	txa
	asl	a
	asl	a
	tax
	lda.l	MissionSequence+2,x
	sta	kw_setsndaddr			;Sound Set Address

;---------------------------------------
	longa
	longi
;* sound special syori *
	lda	KGameMapPtr
	cmp	#stg_sos2
	bne	.skip_sound
	lda	currentlevel
	cmp	#sa_skill
	beq	.satellite
	cmp	#wolf_teamskill
	beq	.wolfteam
	cmp	#wolf_bossskill
	bne	.skip_sound
	km_setmissionflag	wolfboss
.wolfteam
	km_setval	kw_setsndaddr,(sound_missionsos6-SoundTransTbl)
	bra	.skip_sound
.satellite
	km_bitcheckflag16.l	kx_satelliteflag,safl_virustorituki
	beq	.skip_sound
	km_setval	kw_setsndaddr,(sound_missionsos5-SoundTransTbl)
.skip_sound
;---------------------------------------
;* Player Sound *
	a8
	KSoundPlayerTrans
;---------------------------------------
	jmp	(MissionSequence,x)		;Jump Sequence

;---------------------------------------------------------------------
;*			Mission Sequence Table			*
;---------------------------------------------------------------------
MissionSequence
;---------------------------------------------------------------------
;	dw jump_{addr}&WM			;0 :sequence mode
;	dw (sound_{addr}-SoundTransTbl)&WM	;2 :sound mode
;---------------------------------------------------------------------
	km_gamemode	missionstage1		;00
	km_gamemode	missionstage2		;01
	km_gamemode	missionstage3		;02
	km_gamemode	missionstage4		;03
	km_gamemode	missionstage5		;04
	km_gamemode	missionstage6		;05
	km_gamemode	missionsos1		;06
	km_gamemode	missionsos2		;07
	km_gamemode	missionsos3		;08
	km_gamemode	missionsos4		;09
	km_gamemode	missionextra1		;12
	km_gamemode	missionextra2		;13
	km_gamemode	missionextra3		;14
	km_gamemode	missionextra4		;15

;---------------------------------------------------------------------
;*			Colour Table				*
;---------------------------------------------------------------------
missionmapCOLtbl
	db	pal_3		;stg1
	db	pal_4		;stg2
	db	pal_5		;stg3
	db	pal_1		;stg4
	db	pal_nopal	;stg5
	db	pal_2		;stg6
	db	pal_nopal	;sos1
	db	pal_nopal	;sos2
	db	pal_nopal	;sos3
	db	pal_nopal	;sos4
	db	pal_nopal	;ext1
	db	pal_nopal	;ext2
	db	pal_nopal	;ext3
	db	pal_nopal	;ext4

;---------------------------------------------------------------------
;*			Mission Stage 1				*
;---------------------------------------------------------------------
jump_missionstage1
	shorta
	longi

	lda	#stg1map>>16
	ldx	#stg1map&$7fff
	sta	mapbank
	stx	mapptr
	a16
	km_clrgameflag		fade1		;[GAME FLAG]
;;;;	km_setscreenflag	bgcolpal	;[SCREEN FLAG]
	km_setscreenflag	halfadd		;[SCREEN FLAG]
	a8
;;;	km_setrdmap	missionstage1		;[RADAR MAP MODE]
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission Stage 2				*
;---------------------------------------------------------------------
jump_missionstage2
	shorta
	longi
	lda	#stg2map>>16
	ldx	#stg2map&$7fff
	sta	mapbank
	stx	mapptr
	a16
;	km_setrdmap	missionstage2
	km_clrgameflag		fade1		;[GAME FLAG]
	km_setscreenflag	bgcolpal
	km_setscreenflag	halfadd
	a8
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission Stage 3				*
;---------------------------------------------------------------------
jump_missionstage3
	shorta
	longi
	lda	#stg3map>>16
	ldx	#stg3map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionstage3
	a16
	km_clrgameflag		fade1		;[GAME FLAG]
	km_setscreenflag	halfadd
	a8
	jmp	main_intro
;---------------------------------------------------------------------
;*			Mission Stage 4				*
;---------------------------------------------------------------------
jump_missionstage4
	shorta
	longi

	lda	#stg4map>>16
	ldx	#stg4map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionstage4

	a16
	km_clrgameflag		fade1		;[GAME FLAG]
	km_setscreenflag	halfadd
	km_setscreenflag	bgcolpal
	a8
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission Stage 5				*
;---------------------------------------------------------------------
jump_missionstage5
	shorta
	longi
	lda	#stg5map>>16
	ldx	#stg5map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionstage5
	km_clrgameflag		fade1		;[GAME FLAG]
	km_setscreenflag	halfadd
;;;	km_setscreenflag	bgcolpal
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission Stage 6				*
;---------------------------------------------------------------------
jump_missionstage6
	shorta
	longi
	lda	#stg6map>>16
	ldx	#stg6map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionstage6
	a16
	km_clrgameflag		fade1		;[GAME FLAG]
	km_setscreenflag	halfadd
;;;	km_setscreenflag	bgcolpal
	a8
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission Extra 1				*
;---------------------------------------------------------------------
jump_missionextra1
	shorta
	longi
	lda	#ext1map>>16
	ldx	#ext1map&$7fff
	sta	mapbank
	stx	mapptr

;	km_setrdmap	missionextra1
	a16
	km_clrgameflag		fade1		;[GAME FLAG]
	km_setscreenflag	bgcolpal
	a8
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission Extra 2				*
;---------------------------------------------------------------------
jump_missionextra2
	shorta
	longi
	lda	#ext2map>>16
	ldx	#ext2map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionextra2
	a16
	km_clrgameflag		fade1		;[GAME FLAG]
;	km_setscreenflag	bgcolpal
	a8
	jmp	main_intro
;---------------------------------------------------------------------
;*			Mission Extra 3				*
;---------------------------------------------------------------------
jump_missionextra3
	shorta
	longi
	lda	#ext3map>>16
	ldx	#ext3map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionextra3
	a16
	km_clrgameflag		fade1		;[GAME FLAG]
	km_setscreenflag	halfadd
	a8
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission Extra 4				*
;---------------------------------------------------------------------
jump_missionextra4
	shorta
	longi
	lda	#ext4map>>16
	ldx	#ext4map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionextra4
	km_clrgameflag		fade1		;[GAME FLAG]
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission SOS 1				*
;---------------------------------------------------------------------
jump_missionsos1
jump_missionsos4
	shorta
	longi
	lda	#sos1map>>16
	ldx	#sos1map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionsos1
	km_clrgameflag		fade1		;[GAME FLAG]
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission SOS 2				*
;---------------------------------------------------------------------
jump_missionsos2
	shorta
	longi
	lda	#sos2map>>16
	ldx	#sos2map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionsos2
	km_clrgameflag		fade1		;[GAME FLAG]
	jmp	main_intro

;---------------------------------------------------------------------
;*			Mission SOS 3				*
;---------------------------------------------------------------------
jump_missionsos3
	shorta
	longi
	lda	#sos3map>>16
	ldx	#sos3map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	missionsos3
	km_clrgameflag		fade1		;[GAME FLAG]
	jmp	main_intro

;---------------------------------------------------------------------
;*			Training				*		
;---------------------------------------------------------------------
	shorta
	longi
jump_training

	IFEQ	1
	lda	#st_trainingscr
	sta	screentype			;[SCREEN TYPE]
;;;;	km_setgamesyori		training	;[GAME   SYORI]
	km_setspritemode	mission		;[SPRITE MODE]
	km_setscreenmode	mission		;[SCREEN MODE]
	a16
	km_clrgameflag		battle		;[GAME   FLAG]
	km_setscreenflag	sprwbuf		;[SCREEN FLAG]
	km_setscreenflag	screenadd	;[SCREEN FLAG]
	km_setscreenflag	halfadd		;[SCREEN FLAG]
;;;;	km_clrscreenflag	swapbg		;[SCREEN FLAG]
	a8
;* map *
	lda	#tra1map>>16
	ldx	#tra1map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	trainstage1

;* wipe init & open *
	km_initwipeopen	mission

	jmp	main_intro
	ENDC

;=====================================================================
;*			Game Over [Player Down]			*
;=====================================================================
	shorta
	longi
jump_playerdown
	lda	#pldownmap>>16
	ldx	#pldownmap&$7fff
	sta	mapbank
	stx	mapptr

;* kokono Flag Clear wa Game tyuu ni shite itemo mouitido Okonau !!! *
	stz	screenmode
	km_setmissionsyori	normal
	km_setmismapsyori	normal

;* SCREEN SET UP *
	a16
	km_setscreenflag	sprwbuf		;[SCREEN FLAG]
	km_setscreenflag	screenadd	;[SCREEN FLAG]
	a8

	lda	#st_titlescr
	sta	screentype				;[SCREEN TYPE]
;* sprite mode *
	km_setspritemode	missiongameover		;[SPRITE MODE]
	km_setscreenmode	missiongameover		;[SCREEN MODE]

* wipe init & open *
	km_initwipeopen	nowipe
	jmp	main_intro

;=====================================================================
;*			Mission Explain				*
;=====================================================================
	shorta
	longi
jump_missionexplain
	lda	#st_explainscr
	sta	screentype			;SCREEN TYPE
	km_setspritemode	explain		;SPRITE MODE
	km_setscreenmode	explain		;SCREENMODE
	a16
	km_setgameflag		fade1		;GAME FLAG
	km_setmissionflag	explain		;MISSION FLAG
	km_setscreenflag	sprwbuf		;SCREEN FLAG
	km_setscrollflag	raster		;[h-v scroll flag]
	a8

;;;	km_setgamesyori		explain		;GAME SYORI

	lda	#exp1map>>16
	ldx	#exp1map&$7fff
	sta	mapbank
	stx	mapptr				;MAP Address

;* explain shape & strat set *
;;;	jsr	setexpshape
* wipe init & open *
	km_initwipeopen	misexp
	jmp	main_intro

;=============================================================================
;*				Demo					*
;=============================================================================
jump_demo
	shorta
	longi
	ldx	kw_DemoNumber
	a16
	lda.l	.DemoTable+2,x
	sta	kw_setsndaddr			;Sound Set Address
	a8
	jmp	(.DemoTable,x)
.DemoTable
	km_gamemode	end,nosnd
	km_gamemode	titledemo
	km_gamemode	startenemydemo	
	km_gamemode	dummy0demo	
	km_gamemode	startarwingdemo
	km_gamemode	corneriafelldemo
	km_gamemode	dummy1demo
	km_gamemode	endingdemo
	km_gamemode	specialenemydemo
	km_gamemode	dummy2demo
	km_gamemode	planetcanondemo
;-----------------------------------------------------------------------------------
jump_titledemo
	shorta
	longi

	ifne	kdemoinfo!skiptitledemo
	km_setgamemode	title
	rts
	endc

	km_settmpgamemode	title
	km_setsndflag	sndmode
;* MAP *
	lda	#titledemomap>>16
	ldx	#titledemomap&$7fff
	sta	mapbank
	stx	mapptr
	brl	common_demo
;-----------------------------------------------------------------------------------
jump_startenemydemo
	shorta
	longi

;	ifne	demoinfo
	ifne	kdemoinfo
	km_setgamemode	selectmissionmap
	rts
	endc
;	endc

	km_settmpgamemode	selectmissionmap
;* MAP *
	lda	#startenemydemomap>>16
	ldx	#startenemydemomap&$7fff
	sta	mapbank
	stx	mapptr
	brl	common_demo
;-----------------------------------------------------------------------------------
jump_startarwingdemo
	shorta
	longi
;	ifne	demoinfo
	ifne	kdemoinfo
	km_setgamemode	selectmissionmap
	rts
	endc
;	endc
	km_settmpgamemode	selectmissionmap
;* MAP *
	lda	#startarwingdemomap>>16
	ldx	#startarwingdemomap&$7fff
	sta	mapbank
	stx	mapptr
	brl	common_demo
;-----------------------------------------------------------------------------------
	shorta
	longi
jump_endingdemo
	km_settmpgamemode	missionresult
;* MAP *
	lda	#endingdemomap>>16
	ldx	#endingdemomap&$7fff
	sta	mapbank
	stx	mapptr

	IFNE	kendingtest	;(easy,normal,hard :demo ver)
	km_setmistotalflag	gameend
	ENDC

;* Hiscore Input *
	jsl	CalcTotalScore_l
	brl	common_demo
;-----------------------------------------------------------------------------------
jump_corneriafelldemo
	shorta
	longi

	lda	#corneriafelldemomap>>16
	ldx	#corneriafelldemomap&$7fff
	sta	mapbank
	stx	mapptr

	km_settmpgamemode	missionresult
	km_setspritemode	mission		;[SPRITE MODE]
	km_setscreenmode	mission		;[SCREEN MODE]
	km_setgameflag		fade1		;[GAME FLAG]
;* no wipe set *
	jsl	wipeinit_l

	brl	common_demo
;-----------------------------------------------------------------------------------
jump_specialenemydemo
	shorta
	longi
	km_settmpgamemode	selectmissionmap
;* MAP *
	lda	#specialenemydemomap>>16
	ldx	#specialenemydemomap&$7fff
	sta	mapbank
	stx	mapptr
	brl	common_demo
;-----------------------------------------------------------------------------------
jump_planetcanondemo
	km_settmpgamemode	selectmissionmap
;* MAP *
	lda	#cannondemomap>>16
	ldx	#cannondemomap&$7fff
	sta	mapbank
	stx	mapptr
	brl	common_demo
;-----------------------------------------------------------------------------------
jump_dummy0demo
	km_settmpgamemode	selectmissionmap
;* MAP *
	lda	#dummy0demomap>>16
	ldx	#dummy0demomap&$7fff
	sta	mapbank
	stx	mapptr
	brl	common_demo
;-----------------------------------------------------------------------------------
jump_dummy1demo
	km_settmpgamemode	selectmissionmap
;* MAP *
	lda	#dummy1demomap>>16
	ldx	#dummy1demomap&$7fff
	sta	mapbank
	stx	mapptr
	brl	common_demo
;-----------------------------------------------------------------------------------
jump_dummy2demo
	km_settmpgamemode	selectmissionmap
;* MAP *
	lda	#dummy2demomap>>16
	ldx	#dummy2demomap&$7fff
	sta	mapbank
	stx	mapptr
	brl	common_demo
;-----------------------------------------------------------------------------------
	shorta
	longi
common_demo
	lda	#st_demoscr
	sta	screentype			;[SCREEN TYPE]
	km_setspritemode	nosprite	;[SPRITE MODE]
	km_setscreenmode	noscreen	;[SCREEN MODE]

	km_cmpcheck	kw_DemoNumber,kdemo_corneriafelldemo
	bne	.skip
	km_setspritemode	missiongameover		;[SPRITE MODE]
.skip
	a16
	km_setscreenflag	sprwbuf		;[SCREEN FLAG]
	km_setscrollflag	raster		;[h-v scroll flag]
	km_setscreenflag	screenadd	;[SCREEN FLAG]
	a8

* wipe init & open *
	km_cmpcheck	kw_DemoNumber,kdemo_endingdemo
	beq	.ending
.normal
	km_initwipeopen	nowipe
	brl	main_intro

.ending
	km_initwipeopen	ending
	brl	main_intro
;*********************************************************************
;*								*
;*			TEST		[GAME towa kankei nai]	*
;*								*
;*********************************************************************
;---------------------------------------------------------------------
;*			Map Select				*
;---------------------------------------------------------------------
jump_testmissionmap
	shorta
	longi
	jsl	SelectTestMissionMap_l
	rts

;---------------------------------------------------------------------
;*			Skill Select				*
;---------------------------------------------------------------------
jump_testplanetstep
	shorta
	longi
	jsl	SelectTestPlanetStep_l
	rts

;---------------------------------------------------------------------
;*			CONFIG MODE				*
;---------------------------------------------------------------------
jump_config
	shorta
	longi
	IFNE	enableconfig
	jsl	configmode_l
	ENDC
	rts

;=====================================================================
;*			GAME END				*
;=====================================================================
jump_end
	shorta
	longi
	km_setgamemode	end
	rts

;*********************************************************************
;*								*
;*		No Polygon Screen				*
;*								*
;*********************************************************************
;---------------------------------------------------------------------
;*			GAME igai no syori			*
;---------------------------------------------------------------------
jump_selectmissionmap
	shorta
	longi
	jsl	SelectMissionMap_l
	rts
;---------------------------------------------------------------------
jump_debugmissionmap
	shorta
	longi
	km_setval.l	kdifficulty,ktdifficulty
	km_setval.l	kdifficulty2,ktdifficulty*2
	km_clrmistotalflag		explain1
	km_setmistotalflag		retry
	jsl	SelectMissionMap_l
	rts

;---------------------------------------------------------------------
jump_selectmissionplayer
	shorta
	longi
	jsl	SelectMissionPlayer_l
	rts
;---------------------------------------------------------------------
jump_missionresult
jump_detail
	shorta
	longi
	jsl	MissionResult_l
	rts
;---------------------------------------------------------------------
	shorta
	longi
jump_record
	km_clrtotalflag	yjscore
	jsl	Record_l	;Hiscore_l
	rts
;---------------------------------------------------------------------
	shorta
	longi
jump_hiscoreinput
	km_settotalflag	yjscore
	jsl	HiscoreInput_l
	rts
;---------------------------------------------------------------------

;*********************************************************************
;*								*
;*			GAME INTRO				*
;*								*
;*********************************************************************
	shorta
	longi
main_intro
;-----------------------------------------------------
;* BGM Tensou *
	KSoundBGMTrans
;-----------------------------------------------------
;* H-V Offset *
;* hv scroll initial *
; kono initial wo irenaito mission explain screen no bg1 de scroll ga zureru !!
	jsl	init_mmhvscroll_l

;***(H,V scroll) H-DMA Table Address ****
	ldx	#xh_hscrolltbl1&WM
	stx	kw_hdma_hscraddr1
	ldx	#xh_hscrolltbl2&WM
	stx	kw_hdma_hscraddr2
	km_setflag	kw_hdma_hscrflag1,khsf_repeat
	km_setflag	kw_hdma_hscrflag2,khsf_repeat
;-----------------------------------------------------
;* Set Game initial *
	jsl	initgame_l
;-----------------------------------------------------
;* Set window structs *
	km_clrwindowflag	windowwbuf
	jsl	find_window_pri_l
	km_eorwindowflag	windowwbuf
;-----------------------------------------------------
;* IRQ Enable *
	enable
;-----------------------------------------------------
.GAMELOOP
	km_ldaslxgamesyori
	jsr	(kgamesyoritbl,x)
	waittrans	;moshi IRQ no syori yori MAIN SEQUENCE no
			;syori no hou ga hayai baai ni hituyou.
	bra	.GAMELOOP

;=====================================================
;*		Table				*
;=====================================================
kgamesyoritbl
	dw	game_rts&WM		;00
	dw	game_main&WM		;01
	dw	game_pause&WM		;02
	dw	game_bgmtrans&WM	;03

;*********************************************************************
;*								*
;*			RTS					*
;*								*
;*********************************************************************
	shorta
	longi
game_rts

;* Wait IRQ Syori Finish *
	waittrans	;moshi IRQ no syori yori MAIN SEQUENCE no
			;syori no hou ga hayai baai ni hituyou.
;* Screen OFF *
 	km_screenoff		;[SCREEN OFF]

;* OAM Clear *
	jsl	oamclear_l

;* CAMERA Postion & Angle Clear *
;(For Mission Explin Screen) :For Kawaguchi *
	jsr	camerainit	;CAMERA

;* Window ALL OFF *
	km_clrwipeclose

;* h-v SCROLL CLEAR *
	jsl	init_mmhvscroll_l

;* Raster Buffer 0 Clera *
	jsl	Clear_AllRaster_buffer_l

;* HV OFFSET RAM Clear *
;	set_vofsoff	1
;	set_vofsoff	2

	jsl	hvofsRAMClear1_l
	jsl	hvofsRAMClear2_l


;* Flag Clear *
;* common *
	a16
	km_clrgameflag		freeze		;[gameflag]
	km_clrscreenflag	all		;[screenflag]
	km_clrscrollflag	all		;[scrollflag]
	km_clrwindowflag	all		;[windowflag]
	km_clrsndflag		all		;[soundflag]
	km_clrgameoverflag	all		;[gameoverflag]


;* Coin data Save *
	jsl	Write_backupRAM_coindata_l

;* Next Game Mode Set & Flag *
	km_setnextgamemode			;[GAME MODE]
	a8
	pla
	pla	;[rts]
	rts
;=====================================================================
;*								*
;*			CAMERA INITIAL				*
;*								*
;=====================================================================
	shorta
	longi
camerainit
	a16
	ldx	#viewblk1
	lda	#0
	sta.l	al_worldx,x
	sta.l	al_worldy,x
	sta.l	al_worldz,x
	sta.l	al_rotx,x
	sta.l	al_roty,x
	sta.l	al_rotz,x
	a8
	rts

;=====================================================================
;*		Radar Map Data RAM Transfer			*
;*	KRDMapBuffer(bank 7e) <---- radmaptbl (bank 05)		* 
;* init,exit :mem16,idx16						*
;=====================================================================
	ifeq	1
setrdmap
	longa
	longi
	ldy	#(KRDMapBuffer)&WM
	km_mvn	radarmaptbl,KRDMapBuffer
	rts
	endc

;*********************************************************************
;*								*
;*			GAME PAUSE				*
;*								*
;*********************************************************************
;=====================================================================
;*			Pause Main			[PAUSE]	*
;* data bank 7e							*
;=====================================================================
game_pause
	shorta
	longi
	phb
	db7e
;* initial *
	ksound		pauseon			;PAUSE ON SOUND 
	km_setval	key_tateptr1,0		;Initial Pause key postion
	km_setval	key_tatemaxptr1,3
	km_setvar	key_yokoptr1,pause_viewselect
	km_setval	key_yokomaxptr1,2

	sp_ifviewchangeon	.skip
	km_setval	key_tatemaxptr1,2
.skip
;* mode check *
	ifne	kbattle
	km_bitcheckgameflag	battle
	km_bne	gamepause_battle
	endc
;---------------------------------------------------------------------
;*			Pause (Mission)				*
;---------------------------------------------------------------------
gamepause_mission
	oamallclear
	km_setmissionflag	spriteswap
.loop
;*** ko IRQ no SET ichi ni cyuui !! ***
	lda	#iv_pauseirq
	sta	trans_flag		;irq pointer
	waittrans			;irq wait

;--------------------------------------------------------
	km_bitcheckmistotalflag	finalbossbattle
	bne	.finalboss
	km_bitcheckmissionflag	wolfboss
	bne	.finalboss
;--------------------------------------------------------
.normal
	jsl	Check_triggerUD_l	;[key check]

	testjoypad	OK		;Pause Off Check
	km_bne	.pausecancel_mission

	lda	key_tateptr1
	cmp	#2
	km_bne	.key_skip
.yoko_check
	jsl	Check_triggerLR_l
	km_bitcheckflag	keyflag,key_push
	bne	.view_change

	testjoypad	B		;Pause Off Check
	beq	.view_change
	lda	key_yokoptr1
	inc	a
	and	#1
	sta	key_yokoptr1
	ksound	cursor
	bra	.view_change
;--------------------------------------------------------
.finalboss
	testjoypad	Start		;Pause Off Check
	bne	.pausecancel_mission

	sp_ifviewchangeoff	.key_skip
	jsl	Check_triggerLR_l
	km_bitcheckflag	keyflag,key_push
	beq	.key_skip
;--------------------------------------------------------
.view_change
	km_setvar	pause_viewselect,key_yokoptr1
	bne	.cockpit_mode
	sp_cockpit	off
	bra	.key_skip
.cockpit_mode
	sp_cockpit	on
;--------------------------------------------------------
.key_skip
	jsl	do_sprites_l		;[SPRITES]
	jsl	wipe_l			;[window]
	jsl	find_window_pri_l	;[Window]
	brl	.loop

;=====================   Pause Off  =========================
.pausecancel_mission
	a16
	km_clrgameflag		pausedisable	;[enable pause]
	km_clrmissionflag	pause		;[pause on]
	km_setval	msx_CorneriaDispTm,0

;* Key Status Back Up (For Yajima) *

	jsl	write_backupram_playertype_l

	km_bitcheckmissionflag	finalboss
	km_bne	.return_game
.check1
	ksound	kettei

	km_loblda	key_tateptr1
	beq	.return_game
	dec	a
	bne	.return_game
;------------------------------------------
.return_map
	km_bitcheckgameflag	test
	bne	..testmode
;-------------------------
..not_testmode
;* SAVE Game States *
	IFEQ	1
	km_bitcheckmismapflag	enemylist
	bne	..notplanet
	km_bitcheckmismapflag	battleship
	bne	..notplanet
	ldx	kx_currentplanetptr
	lda	currentlevel
	sta.w	mmx_planetskill,x
	lda	PlanetSwitch
	sta.w	mmx_planetswitch,x
..notplanet
	ENDC

	km_settmpgamemode	selectmissionmap ;[GAME MODE]
	bra	..skip_retmap
;------------------------
..testmode
	jsl	playerstatus_init_l
	km_settmpgamemode	testmissionmap	;[GAME MODE]
;------------------------
..skip_retmap

	km_clrmismapflag	enemygone	;[mission map flag]
	km_clrmismapflag	missionresult	;[mission map flag]
	km_clrmissionflag	all		;[mission flag]
	km_setgamesyori		rts
	km_setmissionsyori	normal
	km_clrflag16		kw_mmsoundflag,mmsndf_all
	a8
	km_fadedown
	plb
	rts
;------------------------------------------
.return_game
	km_pullgamesyori		;return sequence
	km_pullspritemode		;return sprite mode
	a8
;* window off *
	jsl	pauseclose_l		;[yajima]
;;;	jsl	PauseWindow_l		;Window OFF

;* sound *
	ksound	pauseoff
;* irq wait *
;kono irq wa key read no tame .moshi kono irq ga naito pause routine de zutto
;LOOP shite shimau
	oamallclear
	km_setmissionflag	spriteswap
	lda	#iv_pauseirq
	sta	trans_flag		;irq pointer
	waittrans			;irq wait
	plb
	rts

;---------------------------------------------------------------------
;*			Pause (Battle)				*
;---------------------------------------------------------------------
	ifne	kbattle
gamepause_battle
	shorta
	longi
;*** ko IRQ no SET ichi ni cyuui !! ***
	lda	#iv_pauseirq
	sta	trans_flag		;irq pointer
	waittrans			;irq wait

;;;;	jsr	RadarModeCheck		;Flag

	jsl	do_sprites_l		;[SPRITES]

	jsl	PauseWindow_l		;Window
	jsl	find_window_pri_l	;Window

;=========== Check Pause Off ============
	testjoypad	START
	beq	.P1nothing
	km_clrbattleflag	p1pause
.P1nothing
	testjoypad2	START
	beq	.P2nothing
	km_clrbattleflag	p2pause
.P2nothing
	km_bitcheckbattleflag	p12pauseflag
	beq	.pause_cancel

	brl	gamepause_battle

;===========   Pause Cancel  ===========
.pause_cancel
;* flag set *
	km_pullgamesyori		;return sequence
	km_pullspritemode		;return sprite mode

;* sound *
	ksound	pauseoff

	jsl	PauseWindow_l		;Window OFF

;* irq wait *
;kono irq wa key read no tame .moshi kono irq ga naito pause routine de zutto
;LOOP shite shimau
	lda	#iv_pauseirq
	sta	trans_flag		;irq pointer
	waittrans			;irq wait
gamepauseEND
	plb
	rts
	ENDC

;*********************************************************************
;*								*
;*		Sound BGM Interrupt Transfer			*
;*								*
;*********************************************************************
game_bgmtrans
	shorta
	longi
	jsr	BGMInterruptTrans
	km_pullgamesyori		;return sequence
	rts


	IFEQ	1
	phb
	db7e

	lda	kx_soundchartptr
	beq	.chart0
	dec	a
	beq	.chart1
	dec	a
	beq	.chart2
	brl	.end
.chart0
;* (Black Screen) *
	shorta
	lda	#-1
	sta	fadedir
	lda	#0
	sta	fade
	inc	kx_soundchartptr
	bra	.end
.chart1
;* (Sound Trans) *
	shorta
	KBGMInterruptTrans

	inc	kx_soundchartptr
	bra	.end
.chart2
;* (Black Screen OFF) *
	shorta
	lda	#1
	sta	fadedir
	lda	#$0e
	sta	FADE	;kw_screenfade
	km_pullgamesyori		;return sequence
	stz	kx_soundchartptr
.end
	plb
	rts
	ENDc
;*********************************************************************
;*								*
;*			GAME MAIN				*
;*								*
;*********************************************************************
	shorta
	longi
game_main
	jsl	setblack_l		; [black fade]
	jsl	wipe_l			; [wipe (yajima)]
;;;	jsl	stratdebug_l		; [stratage debugging]
	jsl	transfer_l		; [main]
	jsl	checkgame_l		; [check]
	rts

;=====================================================================
;*								*
;*			Check Main				*
;*								*
;=====================================================================
checkgame_l
	shorta
	longi

;* soundport 2 *
	km_stxval	sddist2,$ffff	; [SOUND DISTANCE clear]

	jsl	kdebugmodecheck_l	; [debug check]
	jsl	DbugMode1_l		; [print display]
            	km_ldxaslgamemode
	jsr	(kchecktbl,x)
	rtl
;---------------------------------------------------------------------
;*			TABLE					*
;---------------------------------------------------------------------
kchecktbl
	dw	check_title&WM
	dw	check_mission1&WM
	dw	check_missionexplain&WM
	dw	check_playerdown&WM
	dw	check_demo&WM

;*********************************************************************
;*			Check Nothing				*
;*********************************************************************
check_nothing
	rts
;*********************************************************************
;*			Check Player Down			*
;*********************************************************************
	shorta
	longi
check_playerdown
	jsl	kfadeout_l
	bcc	.end
	a16
	km_clrmissionflag	all	;[mission flag]	:kono flag clear wa fade no atoni suru !!
	km_setgamesyori		rts
	km_setmissionsyori	normal
	km_clrflag16		kw_mmsoundflag,mmsndf_all
	a8
.end
	rts
;*********************************************************************
;*			Check Demo				*
;*********************************************************************
	shorta
	longi
check_demo
	phb
	db7e
	a16
;------------------------------------------------------------------------
	km_bitcheckwindowflag	fade
	bne	.fadedown
;* dec timer *
	lda	kw_wipetimer
	beq	.skip
	dec	kw_wipetimer
	brl	.exit
.skip

;* game over demo finish check *
	km_bitcheckmissionflag	godemofinish
	bne	.End_demoTrigger

	km_cmpcheck	kw_DemoNumber,kdemo_corneriafelldemo
	beq	.exit
	cmp	#kdemo_planetcannondemo
	beq	.exit
	cmp		#kdemo_endingdemo
	bne	.check_keyenable
	km_bitcheckmissionflag	keycheckenable
	beq	.exit
	km_testjoypad	start
	beq	.exit
	ksound	end_push_start
	km_setmissionflag	godemofinish
	bra	.exit

.check_keyenable
	km_testjoypad	democancel
	beq	.exit
	km_setmissionflag	godemofinish
	ksound	demo_cancel
	bra	.exit
;----------------------------------------------------
.End_DemoTrigger
	longa
	km_setwindowflag	fade
	lda	kw_DemoNumber

	lsr	a
	lsr	a
	tax
	a8
	lda.l	demofadetmtbl,x
	sta	fade
	a16
	km_bitcheckgameflag	test
	beq	.skip3
	km_settmpgamemode	testmissionmap
.skip3
;----------------------------------------------------
;* fade down *
.fadedown
	jsl	kfadeout_l
	a16
	bcc	.exit
.fadefinished
	km_clrmissionflag	all		;[mission flag]
	km_setgamesyori		rts
;----------------------------------------------------
.exit
	a8
	plb
	rts
demofadetmtbl
	db	10			;nothing
	db	fade_titledemo		;title
	db	fade_startenemydemo	;startenemydemo
	db	8			;dummy0
	db	fade_startarwingdemo	;startarwingdemo
	db	fade_corneriafelldemo	;corneriafelldemo
	db	8			;dummy1
	db	fade_endingdemo		;endingdemo
	db	fade_specialenemydemo	;specialenemydemo
	db	8			;dummy2
	db	fade_planetcannondemo	;planetcannondemo


;*********************************************************************
;*								*
;*			Check Title				*
;*								*
;*********************************************************************
	shorta
	longi
check_title
;* wipe opening check *
	km_bitcheckwindowflag	wipeopen
	km_bne	.wipeopen
;* wipe closing check *
	km_bitcheckwindowflag	wipeclose
	km_bne	.wipeclose
;* Key Enable Check *
	jsr	keyenablewait
	bcs	.exit
;---------------------------------------------------------------------
;* return prolouge demo *
	lda	tiw_returndemo
	bne	.returndemo		;title demo scroll flag ON

	lda	tiw_sprmode
	beq	.skip_keycheck		;0/1 ... demo tyuu / key enable

	jsl	Check_triggerUD_l	;[key check]

	lda	tiw_sprmode
	dec	a
	bne	.CheckCancel
;-----------------------------------------------------------------------
;* Stereo or Monoral Check *
	lda	key_tateptr1
	IFEQ	debuginfo
	cmp	#2
	ELSEIF
	cmp	#(4+enableconfig)
	ENDC
 	bne	.notcheck_StereoMonoral

	jsl	Check_triggerLR_l	;[key check]
	km_bitcheckflag	keyflag,key_push
	bne	.push_LR

	km_testjoypad	OK
 	beq	.notcheck_StereoMonoral
	ksound	cursor
	lda	key_yokoptr1
	inc	a
	and	#1
	sta	key_yokoptr1
.push_LR
	lda	key_yokoptr1
	sta	monoral		;conf_sound
	jsl	Stereo_l
.notcheck_StereoMonoral
;-----------------------------------------------------------------------
;* Cancel Check *
.CheckCancel
	km_testjoypad	Cancel		;[key check]
	km_bne	.pushcancel

.skip_keycheck
	lda	tiw_sprmode
	dec	a
	bne	.skipaaa
	IFEQ	debuginfo
	lda	key_tateptr1
	cmp	#2
	beq	.exit
	ENDC
.skipaaa
;-----------------------------------------------------------------------
;* Start Check *
	km_testjoypad	OK		;[key check]
	bne	.pushstart
;-----------------------------------------------------------------------
.exit
	rts
;=====================================================================
;*			Return demo				*
;=====================================================================
.returndemo
	stz	tiw_returndemo
	km_setdemonumber	titledemo	;Gamemode&Number
	brl	.setwipeinit
;=====================================================================
;*			Push Start				*
;=====================================================================
.pushstart
;* kettei sound *
	ksound	kettei		;kettei [sound]

	km_hib0
	lda	tiw_sprmode
	asl	a
	tax
	jmp	(.titleseqtable,x)
.titleseqtable
	dw	.democancel&WM
	dw	.gameselect&WM
	dw	.levelselect&WM
;------------------------------------------------------------------------------------
.democancel
	shorta
;* !!! kokoni wa yajima san no flag shika ireruna !! ***
	inc	tiw_sprmode
	km_stxval	titlestruct,idx_titleobj_startwait
	km_stxval	kw_KeyEnableTimer,15*1

;* parameter init set *
	ifeq	debuginfo
	km_setval	key_tatemaxptr1,3	;(kgamemodetblEND-kgamemodetbl)
	km_setval	key_yokomaxptr1,2
	elseif
	km_setval	key_tatemaxptr1,(5+enableconfig)	;(kgamemodetblEND-kgamemodetbl)
	km_setval	key_yokomaxptr1,2
	endc
	brl	.exit
;------------------------------------------------------------------------------------
	shorta
	longi
.gameselect
;**** 1 kaimeno Start Push ****
 	km_ldatbl_i8x	.kgamemodetbl,key_tateptr1
	cmp	#kmode_stereomonoral
	km_beq	.exit		;If stereo/monoral mode wo select shitara !!
	km_statmpgamemode	;Set Game Mode
 
	IFNE	debuginfo
	lda	key_tateptr1
	cmp	#1
	bpl	.setwipeinit
	ELSEIF
;honban game
	lda	key_tateptr1
	dec	a
	beq	.setwipeinit	;RECORD Select
	ENDC

;* random pointer *
	a16
	jsl	KGetRandomPtr_l
	sta	kw_RndPlanetPtr
	a8

;* reset cursor params *
	lda	key_tateptr1
	sta	tiw_gamemode

	km_setval	key_tateptr1,0
	km_setval	key_tatemaxptr1,2

	km_bitcheckflag.l	m_backupflags,backupflag_expert
	IFEQ	EXPERTBYDEFAULT
	beq	.NoExpert
	ENDC
	km_setval	key_tatemaxptr1,3
.NoExpert
	inc	tiw_sprmode
	brl	.exit
;------------------------------------------------------------------------------------
;*** 2 kaimeno Start Push ****
.levelselect
	shorta
	longi
	lda	tiw_gamemode
	bne	.battle
;------------------------------------------------------------------------------------
.mission
	shorta
;* game level (easy,normal,hard) *
	a16
	km_loblda	key_tateptr1
	sta.l	kdifficulty
	asl	a
	sta.l	kdifficulty2
	km_clrtotalflag		battle		;[TOTAL FLAG]
	km_setdemonumber	startenemydemo

	a8
	bra	.setwipeinit
;------------------------------------------------------------------------------------
.battle
	a16
	longi
	km_lldx	key_tateptr1
	km_loblda.l	.battlemaptbl,x
	sta.l	KGameMapPtr
;	km_settotalflag		battle		;[GAME FLAG]
	a8
;------------------------------------------------------------------------------------
;* wipe close init *
.setwipeinit
	km_initwipeclose	title
	brl	.exit
;=====================================================================
;*			Wipe Open Finish Check			*
;=====================================================================
* wipe open *
.wipeopen
	jsl	check_wipeopen_l
	brl	.exit
;=====================================================================
;*			Wipe Close Finish Check			*
;=====================================================================
* wipe close *
.wipeclose
	jsl	check_wipeclose_l
	km_bitcheckwindowflag	wipeclose
	bne	.skip

	km_setgamesyori		rts
	km_clrscreenflag	all
.skip
	brl	.exit
;=====================================================================
;*			Cancell					*
;=====================================================================
.pushcancel
	lda	tiw_sprmode
	km_beq	.exit
	dec	a
	km_beq	.exit

	km_setval	tiw_sprmode,1
	km_setval	key_tateptr1,0
	ifeq	debuginfo
	km_setval	key_tatemaxptr1,3
	elseif
	km_setval	key_tatemaxptr1,5
	endc
	ksound	cancel
	brl	.exit
;=====================================================================
;*			Mode Table				*
;=====================================================================
.kgamemodetbl
	db	kmode_demo		;[MISSION]
	db	kmode_record
	db	kmode_testmissionmap	;testmissionmap  ;missionresult
	db	kmode_debugmissionmap	;debugmissionmap ;missionresult
	IFNE	enableconfig
	db	kmode_config
	ENDC
	db	kmode_stereomonoral		;STEREO/MONORAL
.kgamemodetblEND

;=====================================================================
;*		Battle Map Table				*
;=====================================================================
.battlemaptbl
	db	stg_bat1	;ground
	db	stg_bat2	;space
	db	stg_bat3	;in door


;=====================================================================
;*			Key Enable Wait Timer Check		*
;=====================================================================
keyenablewait
	shorta
	longi
	ldx	kw_KeyEnableTimer
	beq	.finish
	dex
	stx	kw_KeyEnableTimer
	sec
	rts
.finish
	clc
	rts

;*********************************************************************
;*								*
;*			GAME EXPLAIN				*
;*								*
;*********************************************************************
check_missionexplain
	shorta
	longi
	php

;* wipe opening check *
	km_bitcheckwindowflag	wipeopen
	km_bne	.wipeopen
;* wipe closing check *
	km_bitcheckwindowflag	wipeclose
	km_bne	.wipeclose

	lda	mew_ketteiflag
	km_beq	.exit
	km_settmpgamemode	initmission
	km_setwindowflag	wipeclose
	km_initwipeclose	misexp
	km_setval	fade,8	;so fast fade

	bra	.exit

;=====================================================================
;*			Wipe Open Finish Check			*
;=====================================================================
* wipe open *
.wipeopen
	jsl	check_wipeopen_l
	brl	.exit
;----------------------------------------------------------------------
;=====================================================================
;*			Wipe Close Finish Check			*
;=====================================================================
* wipe close *
.wipeclose
	jsl	check_wipeclose_l

;* wipe close check *
	km_bitcheckwindowflag	wipeclose
	km_bne	.exit
;----------------------------------------------------------------------
	km_setval	kw_BossPtr,0		;BOSS meter Pointer Clear
;----------------------------------------------------------------------
	km_setgamesyori		rts		;[game syori]
	km_clrmissionflag	all		;[mission flag]

;;;	km_clrgameoverflag	all		;[gameover flag]
;;;	km_clrscreenflag	all		;[screenflag]
;;;	km_clrsndflag		all		;[sound flag]
;;;	km_clrhvscrollflag	explain		;[hvscroll flag]
;----------------------------------------------------------------------
.exit
	plp
	rts

;*********************************************************************
;*								*
;*		Mission Game Main Check				*
;*								*
;*********************************************************************
;=====================================================================
;*								*
;*		Check Mission Game				*
;*								*
;=====================================================================
check_mission1
	shorta
	longi

	jsl	kpausecheck_l		; [pause check]
	jsl	check_missionseq_l	; [game flag check]
	rts
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;=====================================================================
;*		Main Game Check Routine				*
;* data bank 7e							*
;=====================================================================
	shorta
	longi
check_missionseq_l
	phb
	db7e
;*** parameter ***
	jsr	ksetparameter

;=====================================================================
;*								*
;*			 Check Mission 				*
;*								*
;=====================================================================
	a16
	km_bitcheckwindowflag	fade
	km_bne	.game_fadedown
	km_bitcheckwindowflag	wipeclose
	km_bne	.game_wipeclose

	lda	kw_missionsyori
	asl	a
	tax
	jmp	(.table,x)

.table
	dw	.mission_normal&WM
	dw	.mission_wait&WM
	dw	.mission_playerdown&WM
	dw	.mission_corneriafell&WM
	dw	.mission_stageclear&WM
	dw	.mission_gameclear&WM
	dw	.mission_enemyrunawaytrig&WM
	dw	.mission_enemyrunaway&WM

;---------------------------------------------------------------------------
;* Inc Game Timer *
	longa
	longi
.mission_normal
	km_bitcheckflag	kw_gameflag,(kgf_freeze!kgf_keydisable)
	km_bne	.exit
	km_loblda	demomode
	km_bne	.exit
	km_loblda	kenemynumber
	km_beq	.exit
	lda	gameclear_yjflag
	km_bne	.exit

;---------------------------------
;* '95/9/5 :moshi map de 100% ni chyoudo natta toki no taisaku
	km_bitcheckmismapflag	corneriafell
	beq	.skipa

	km_setmissionsyori	corneriafell	;[for mission]
	km_setflag16	kw_gameFlag,(kgf_pausedisable!kgf_keydisable)
	km_setmismapflag2	damagedisable

.skipa

;---------------------------------
;* '95/2/11 :chart.asm (kawagoe's) ni check idou !! *
;* enemy ga subete nigetaka CHECK *
;	km_bitcheckmissionflag	enemyrunaway
;	beq	.check_StratTimer
;	km_setmissionsyori	enemyrunawaytrig

;---------------------------------
;* (daitai 10 frame ni 1 kai enemy stratage wo syori suru !) *
;* normal game frame =5frame de ugoite iru !!5*2= 10 game frame ni 1 kai syori *

	longa
	longi
.check_StratTimer
	km_clrmissionflag enemymove	;parallel routine call disable
	dec	kx_EnStratTm
	bne	.check_GameTimer
	km_setval	kx_EnStratTm,enstrattm
	km_setmissionflag enemymove	;parallel routine call enable
;---------------------------------
	longa
	longi
.check_GameTimer
	jsl	DecCorneriaHP_mission_l

	km_bitcheckmissionflag	timemax
	bne	.notTimeChange

	inc	kx_GameTmAdd
 	dec	kx_GameTmSub
	bne	.notTimeChange

	lda	kw_GameTimer
	cmp	#gametimemax_mission
	beq	.maxtime

	km_setval	kx_GameTmAdd,0
	km_setval	kx_GameTmSub,missgftm	;(25*20)

	inc	kw_GameTimer

	lda	kx_TOTALTIME
	cmp	#gametimemax_map
	beq	.notTimeChange
	inc	a
	sta	kx_TOTALTIME
.notTimeChange
	brl	.exit
.maxtime
	km_setval	kx_GameTmAdd,missgftm-1
	km_setmissionflag	timemax	
	brl	.exit
;---------------------------------------------------------------------------
	longa
.mission_wait
	dec	kw_miswaittm
	bne	..skip1
	km_setvar	kw_MissionSyori,kw_nextmissionsyori
..skip1
	brl	.exit
;---------------------------------------------------------------------------
.mission_enemyrunawaytrig
 	longa
	km_setmissionflag	transsprcgx 
	km_setgameflag		keydisable
 	km_setval	kw_NEXTmissionsyori,msy_enemyrunaway
 	km_setval	kw_miswaittm,4*15
	km_setval	gameobjstruct,idx_demo_enemygone
	km_setmissionsyori	wait
	km_setsndflag	port2stop
	brl	.exit
;---------------------------------------------------------------------------
;=================== Player Down (MISSION) ====================
	longa
.mission_playerdown
	km_clrmismapflag	missionresult
	km_setmistotalflag	playerdown
	km_settmpgamemode	playerdown  ;[gamemode]

	km_setflag8	kx_p1_pilotNo,$80


	IFEQ	1
	km_bitcheckmistotalflag	partner1
	bne	.p2dead
	km_setflag8	kx_p1_pilotNo,$80
	km_setmistotalflag	p1dead
	bra	.skip_dead
.p2dead
	km_setflag8	kx_p2_pilotNo,$80
	km_setmistotalflag	p2dead
.skip_dead
	ENDC

;	km_setwindowflag	fade
	bra	.mission_common
;---------------------------------------------------------------------------
;* !! (gamepause_mission) no routine de okonatte iru !!
;.mission_returnmap
;	longa
;	bra	..skip2

;=================== Mission Exit ====================
.mission_enemyrunaway
	longa
	km_setmismapflag	enemygone
..skip2
	km_clrmismapflag	missionresult
	km_settmpgamemode	selectmissionmap	;[GAME MODE]
	bra	.mission_common
;----------------------------------------------------------------------
;=================== Corneria Fell (MISSION) ======================
	longa
.mission_corneriafell
;'95/6/6 :set
	kbgm	corneria100
	ksound	trig_unable

;'94/12/23
	km_setdemonumber	corneriafelldemo ;gamemode&Demo Number
	km_setmistotalflag	corneriafell
	km_setwindowflag	wipeclose
	bra	.game_wipeclose
;---------------------------------------------------------------------------
;=================== Game Clear (MISSION) ======================
	longa
.mission_gameclear
	km_setmistotalflag	bonus
	km_setmistotalflag	gameend

	IFEQ	kendingskip
	km_setdemonumber	endingdemo
	ELSEIF
	km_settmpgamemode	missionresult
	jsl	CalcTotalScore_l
	ENDC
	bra	.mission_common
;---------------------------------------------------------------------------
;=================== Stage Clear (MISSION) ====================
.mission_stageclear
	longa
	km_settmpgamemode	selectmissionmap	;[GAME MODE]
	km_setmismapflag	missionresult
	bra	.mission_common
;---------------------------------------------------------------------------
.mission_common
;* !! mem:moshi koko ni aratani prog wo kuwaetara gamepause_mission (.return_map)
;         :nimo onnaji prog wo kuwaeru !! *
	longa
	km_setwindowflag	fade		 ;[fade down start flag]
	bra	.game_fadedown

;* SAVE Game States *
	IFEQ	1
	km_bitcheckmismapflag	enemylist
	bne	..notplanet
	km_bitcheckmismapflag	battleship
	bne	..notplanet
	ldx	kx_currentplanetptr
	lda	currentlevel
	sta.w	mmx_planetskill,x
	lda	PlanetSwitch
	sta.w	mmx_planetswitch,x
..notplanet
	ENDC
;----------------------------------------------------------------------
;* wipe fade *
.game_wipeclose
	longa
	jsl	kwipeclose_l
	a16
	bcc	.exit
	bra	.finish_syori
;----------------------------------------------------------------------
;* fade down *
.game_fadedown
	longa
	jsl	kfadeout_l
	a16
	bcc	.exit
.fadefinished
;--------------------------
.finish_syori
;* testmode check *
	km_bitcheckgameflag	test
	beq	..not_testmode
	km_settmpgamemode	testmissionmap	;[GAME MODE]
..not_testmode
;-------------------------
	km_clrmissionflag	all	;[mission flag]	:kono flag clear wa fade no atoni suru !!
	km_setgamesyori		rts
	km_setmissionsyori	normal
	km_clrflag16		kw_mmsoundflag,mmsndf_all

;==================== EXIT ======================
.exit
	a8
	plb
	rtl

;=====================================================================
;*		    	Parameter				*
;* Init :data bank 7e						*
;=====================================================================
ksetparameter
;* Mission or Player1 *
	php
	phb

	a8
	db7e
	km_plheapptr	1,y
;* player score *
	a16
	lda.w	kscore,y
	sta	kx_basicscore	;kw_totalscore1
	a8
	lda.w	kscore+2,y
	sta	kx_basicscore+2	;kw_totalscore1+2
.end
	plb
	plp
	rts

;*********************************************************************
;*								*
;*			Pause Check			[PAUSE]	*
;* data bank 0							*
;*								*
;*********************************************************************
KPauseCheck_l
	a16
	longi

	km_bitcheckflag	kw_gameflag,(kgf_keydisable!kgf_pausedisable!kgf_freeze)
	km_bne	.end
	lda.l	kenemynumber
	km_beq	.end
	km_bitcheckgameflag	battle
	bne	.KPauseCheck_battle
;-------------------------------------------------------------------------
.KPauseCheck_mission
;	km_bitcheckgameflag	player
;	bne	.player2
.player1
	km_testjoypad	START
	beq	.END	;pause start button push ?
	bra	.setflag
;.player2
;	km_testjoypad2	START
;	beq	.END		;pause start button push ?
.SETFLAG
	km_setgameflag		pausedisable	;[pause disable]
	km_setmissionflag	pause	;[pause on]
	jsl	pauseopen_l	;[yajima]
	jsl	init_pausemap_l	;[yajima]

;PS.naraberu ichi ni tyuui !!!
.Init_Pause
	a8
	km_pushgamesyori
	km_pushspritemode
	km_setgamesyori		pause
	km_setspritemode	missionpause
;---------------------------
;* return main sequence *
.return
	pla
	pla
	pla	;[rtl]
	rts
;---------------------------
.end
	a8
	rtl
;-------------------------------------------------------------------------
.KPauseCheck_battle
	longa
	longi
	km_testjoypad	START
	beq	.NotPauseP1_bat	;pause start button push ?
	km_setbattleflag	p1pause
	bra	.Pause_bat
.NotPauseP1_bat
	km_testjoypad2	START
	beq	.end		;pause start button push ?
	km_setbattleflag	p2pause
.Pause_bat
	a8
	km_pushgamesyori
	km_pushspritemode
	km_setgamesyori		pause
	km_setspritemode	battlepause
	bra	.return

;=====================================================================
;*			DEBUG MODE CHECK 			*
;=====================================================================
	shorta
	longi
kdebugmodecheck_l
	IFNE	debuginfo
;*********** RESET ***********
	km_debug_reset

	km_cmpkeydown2	bg1	;select & Right
	bne	.not_bg1
	lda	kw_tm
	ora	#1
	sta	kw_tm
.not_bg1
	km_cmpkeydown2	bg2	;select & Left
	bne	.not_bg2
	lda	kw_tm
	ora	#2
	sta	kw_tm
.not_bg2

	km_cmpkeydown2	bg3	;select & Up 
	bne	.not_bg3
	lda	kw_tm
	ora	#4
	sta	kw_tm
.not_bg3

	km_cmpkeydown2	obj	;select & Down
	bne	.not_obj
	lda	kw_tm
	ora	#$10
	sta	kw_tm
.not_obj
	km_cmpkeydown2	bgall	;select & TLeft
	bne	.not_bgall
	lda	#$13
	sta	kw_tm
.not_bgall

	km_cmpkeydown2	bgclr	;select & TRight
	bne	.not_bgclr
	stz	kw_tm
.not_bgclr

;********** STAGE CLEAR *************
	km_cmpkeydown	stageclear	;TR,A,B,Y
	bne	.nostageclear
	km_setval.l	kenemynumber,0
.nostageclear

;****** PLAYER DOWN *******
	km_cmpkeydown	playerdown	;TL,TR,A,Y
	bne	.nopldown
	ldx	playpt1
	lda	#0
	sta.w	al_hp,x
.nopldown

;********** Staff Roll *************
	km_cmpkeydown2	start	;start
	bne	.notgameclear
	km_setmissionsyori	gameclear
.notgameclear

;***** Enemy Gone ********
	km_cmpkeydown2	enemygone	;A!B (2)
	bne	.notenemygone
	km_setmissionflag	enemyrunaway
.notenemygone


;********** Corneria Damage *************
	IFEQ	1
	km_cmpkeydown2	select	;select
	bne	.nodamage
	km_setval.l	kx_AttackPoint,10
.nodamage
	ENDC

;*********** Message Debug (yajima) **************
	ifeq	1
	km_testjoypad2	select
	beq	.zacotubushi
	km_setflag16.l	mmx_message_sos,mesosfl_zacotubushi	;[for yajima's]
.zacotubushi
	endc
;********** BOSS APPEAR *************
;	km_cmpkeydown2	bossappear	;TL,TR,select,right
;	bne	.nobossappear
;	km_setmissionflag	bossappear
;.nobossappear

;********** Game Over **************
;	km_cmpkeydown2	gameover	;TL,TR,select,left
;	bne	.notgameover
;	km_setmissionsyori	gameover
;.notgameover

;****** Time Up *******
;	km_cmpkeydown	timeup	;TL,TR,select,Right
;	bne	.notimer0
;	km_setmissionflag	timeup
;	lda	#0
;	sta	kw_gametimer
;	sta	kw_gametimer+1
;.notimer0


;---------------------------------------------------------------------
	ENDC
.end
	rtl

;=====================================================================
;*			CAMERA TEST				*
;=====================================================================
kcameratest
	shorta
	longi
	IFEQ	1
	ldx	#viewblk1
	km_testkeydown	up
	bne	.up
	km_testkeydown	down
	bne	.down
	km_testkeydown	right
	bne	.right
	km_testkeydown	left
	bne	.left
	km_testkeydown	tright
	bne	.tright
	km_testkeydown	tleft
	bne	.tleft
	bra	.cameraend
.up
	a16
	lda.l	al_worldz,x
	clc
	adc	#$8
	sta.l	al_worldz,x
	bra	.cameraend
.down
	a16
	lda.l	al_worldz,x
	sec
	sbc	#$8
	sta.l	al_worldz,x
	bra	.cameraend

.right
	a16
	lda.l	al_worldx,x
	clc
	adc	#$8
	sta.l	al_worldx,x
	bra	.cameraend
.left
	a16
	lda.l	al_worldx,x
	sec
	sbc	#$8
	sta.l	al_worldx,x
	bra	.cameraend
.tright
	a16
	lda.l	al_worldy,x
	clc
	adc	#$8
	sta.l	al_worldy,x
	bra	.cameraend
.tleft
	a16
	lda.l	al_worldy,x
	sec
	sbc	#$8
	sta.l	al_worldy,x
	bra	.cameraend
.cameraend
	a8
	ENDC
	rts



;=====================================================================
;*								*
;*			Check Battle				*
;*								*
;=====================================================================
	IFNE	kbattle
check_battle
	shorta
	longi
	jsl	kpausecheck_l		; [pause check]
	jsl	check_battleseq_l	; [game flag check]
	rts
;---------------------------------------------------------------------
;*			Battle Sequence				*
;---------------------------------------------------------------------
check_battleseq_l
	shorta
	longi

	phb
	db7e
;* parameter *
	jsr	ksetparameter

;* battle check sequence *
	km_bitcheckgameflag	freeze
	km_bne	.exit

	ldx	kw_battlesyori
	jmp	(.table,x)
.table
	dw	.battle_normal&WM
	dw	.battle_timeup&WM
	dw	.battle_timeupwait&WM
	dw	.battle_result&WM
	dw	.battle_resultwait&WM
	dw	.battle_continue&WM
;------------------------------------------------------------------------
;* Game Timer *
.battle_normal
	shorta
.p1HP_check
	lda	p1_status
	bit	#p1_status_battleend
	beq	.p2HP_check
	km_setbattleflag	p1dead
	bra	.hp_common
.p2HP_check
	lda	p2_status
	bit	#p2_status_battleend
	beq	.time_check
	km_setbattleflag	p2dead
.hp_common
	km_setbattleflag	gameover
	km_setbattlesyori	result
	brl	.exit
;-------------------------------------------------------------------------
;* time check *
.time_check
	lda	p1_status
	bit	#p1_status_hp0
	bne	.skip1
	lda	p2_status
	bit	#p2_status_hp0
	bne	.skip1

	lda	SecondTimer
	km_bne	.exit
	lda	#second
	sta	SecondTimer	;1sec counter reset
	a16
	dec	kw_GameTimer
	a8
	bne	.skip1		; if not time up
	km_setbattlesyori	timeup
.skip1
	brl	.exit
;------------------------------------------------------------------------
.battle_timeup
;;;	km_setval	KW_FadeWaitTm,30
;;;	KBGM	fadeout
;;;	jsr	kScoreKeisan
	km_setbattleflag	gameover
	km_setbattleflag	timeup
	km_setbattlesyori	timeupwait
	km_stxval	kw_charttm,0*15

	brl	.exit
;------------------------------------------------------------------------
.battle_timeupwait
	jsr	kchartwait
	bcc	.skip2

	km_setbattlesyori	result
.skip2
	brl	.exit
;------------------------------------------------------------------------
.battle_result
	km_setbattlesyori	resultwait
	km_stxval	kw_charttm,0*15
	brl	.exit
;------------------------------------------------------------------------
.battle_resultwait
	jsr	kchartwait
	bcc	.skip3
	km_setval	KW_FadeWaitTm,30
	KBGM	fadeout
	km_setbattlesyori	continue
.skip3
	brl	.exit
;------------------------------------------------------------------------
;* game over *
.battle_continue
	lda	KW_FadeWaitTm
	beq	.fade_battle
	dec	a
	sta	KW_FadeWaitTm
	bne	.exit
.fade_battle
	lda	fade
	km_beq	.fadefinished2
	km_qfadestepdown
	bra	.exit
.fadefinished2
	km_setgamesyori		rts
	km_settmpgamemode	selectmissionplayer
	km_clrmissionflag	all	;(radar in check wo shiteiru tame !!)
	km_clrbattleflag	all
	km_setbattlesyori	normal
;==================== EXIT ======================
.exit
	a8
	plb
	rtl
;=====================================================================
;*			Chart Timer Dec				*
;* Xreg ga kowareru !!						*
;=====================================================================
kchartwait
	shorta
	longi
	ldx	kw_charttm
	beq	.wait_finish
	dex
	stx	kw_charttm
	clc
	rts
;-----------------
.wait_finish
	sec
	rts
	ENDC

;*********************************************************************
;*								*
;*			GAME OVER				*
;*								*
;*********************************************************************
;=====================================================================
;*								*
;*			Game Over Demo Check			*
;*								*
;=====================================================================
	IFEQ	1
check_missgameoverdemo
	shorta
	longi
	phb
	db7e

	a16
	km_bitcheckwindowflag	fade
	km_bne	.fadedown

;* game over demo finish check *
	km_bitcheckmissionflag	godemofinish
	km_bne	.mission_gameover

	ifne	kbugsw
	km_testkeydown	OK
	beq	.end
	km_setmissionflag	godemofinish
	endc
.end
	a8
	plb
	rts

;=================== Game Over (MISSION) ======================
.mission_gameover
	longa
	km_setwindowflag	fade
;* fade down *
.fadedown
	jsl	kfadeout_l
	a16
	bcc	.exit

	IFEQ	1
	km_bitcheckgameoverflag	init
	bne	.initOK
	km_setgameoverflag	init
	km_setval	KW_FadeWaitTm,1
	a8
	km_soundallstop
	a16
.initOK	km_dectimer0	KW_FadeWaitTm
	km_bne	.exit
.fadestart
	km_loblda	fade
	beq	.fadefinished
	a8
	km_qfadestepdown
	a16
	bra	.exit
	ENDC

.fadefinished
	km_settmpgamemode	missiongameover  ;[gamemode]
	km_setgamesyori		rts

;* kokono Flag Clear wa Game tyuu ni shite itemo mouitido Okonau !!! *
	stz	screenmode
	km_setmissionsyori	normal
	km_setmismapsyori	normal
	km_clrmismapflag	all		 ;[missionmap flag]
	km_clrmismapflag2	all		 ;[missionmap flag]
	km_clrmissionflag	all		 ;[mission flag]

;;;	km_clrscreenflag	all		 ;[screenflag]
;;;	km_clrsndflag		all		 ;[sound flag]
;;;	km_clrgameoverflag	all

.exit
	a8
	plb

	rts
	ENDC

;*********************************************************************
;*								*
;*			MAP Return				*
;*								*
;*********************************************************************
	ifeq	1
game_retmap
	shorta
	longi
;* Screen OFF *
 	km_screenoff		;[SCREEN OFF]
;* *
	stz	windowmode1

;* Next Game Mode Set & Flag *
	km_setgamemode		selectmissionmap	;[GAME MODE]
;;;	km_setgameflag		syorigae		;[GAME FLAG]

	pla
	pla	;[rts]
	rts
	endc

;*********************************************************************
;*								*
;*			PLAYER DOWN				*
;*								*
;*********************************************************************
	IFEQ	1
game_restart
	shorta
	longi
;-----------------------------------------------------
;* wipe init & open *
	jsl	wipeinit_l
;* fade on *
	jsl	initblack_l
	km_fadestepup

;* Set window structs *
	km_clrscreenflag	windowwbuf
	jsl	find_window_pri_l
	km_eorscreenflag	windowwbuf
;---------------------------------------------------------------------
;* sound *
	lda	bgm_back
	kbgm_a
;---------------------------------------------------------------------
;;;	km_bitcheckmissionflag	timeup
;;;	beq	.nottimeup
;;;	jsr	kmisgametimeset
.nottimeup
;* mode & flag *
	km_setgamesyori		main	;[gamesyori]
	km_clrgameflag		freeze	;[game flag]
	km_clrmissionflag	all	;[mission flag]
	km_clrsndflag		all	;[sound flag]
	km_setgameflag		plreset	;[game flag]

	phb
	db7e
	km_stxval	kw_basicscore1,0 ;score
	km_substaval	kw_PlayerRest1,1 ;zanki
	km_stxval	bossmaxhp,0	 ;dylan's boss hp
	plb
;---------------------------------------------------------------------
	stz	trans_flag
	rts
	ENDC

;*********************************************************************
;*								*
;*		Return MISSION MAP SELECT			*
;*								*
;*********************************************************************
	IFEQ	1
game_mismap
	shorta
	longi
;---------------------------------------------------------------------
;* sound fade *
;	KBGM	FadeOut
;	km_setsoundport1	stop
;	km_setsoundport2	stop
;---------------------------------------------------------------------
.stageclear
	km_settmpgamemode	selectmissionmap ;[gamemode]
	km_setgamesyori		rts		 ;[gamesyori]
;;;	km_clrgameflag		gaming		 ;[gameflag]
	km_clrmissionflag	all		 ;[mission flag]
	km_clrscreenflag	all		 ;[screenflag]
	km_clrsndflag		all		 ;[sound flag]
;---------------------------------------------------------------------
.battle
	stz	trans_flag
	rts
	ENDC
;*********************************************************************
;*								*
;*			GAME OVER				*
;*								*
;*********************************************************************
	IFEQ	1
game_over
	shorta
	longi
;* game over sequence select *
	km_bitcheckgameflag	battle
	beq	.mission
.battle
	jmp	gameover_battle
.mission
	jmp	gameover_mission
;=====================================================================
;*			MISSION GAME OVER			*
;=====================================================================
gameover_mission
	shorta
	longi
;* kokode fade out wo shitewa dame *
;* sound fade *
;	KBGM	FadeOut
;	km_setsoundport1	stop
;	km_setsoundport2	stop
;---------------------------------------------------------------------
.stageclear
;;;	km_bitcheckmissionflag	stageclear
;;;	beq	.gameover
	km_settmpgamemode	selectmissionmap  ;[gamemode]
	bra	.clearflags
;---------------------------------------------------------------------
.gameover
	km_settmpgamemode	missiongameover  ;[gamemode]
	km_clrmismapflag	all		 ;[missionmap]
	km_clrmismapflag2	all		 ;[missionmap]
;---------------------------------------------------------------------
.clearflags
	km_setgamesyori		rts		 ;[gamesyori]
;;;;	km_clrgameflag		gaming		 ;[gameflag]
	km_clrmissionflag	all		 ;[mission flag]
	km_clrscreenflag	all		 ;[screenflag]
	km_clrsndflag		all		 ;[sound flag]
;---------------------------------------------------------------------
	stz	trans_flag
	rts
	ENDC

;=====================================================================
;*		BATTLE GAME OVER				*
;=====================================================================
	IFEQ	1
gameover_battle
	shorta
	longi
;* maeno syori no wait *
	waittrans			;[irq wait]

	km_screenoff			;[screen off]
	ifeq	0
	stz	bg1hofs
	stz	bg1vofs
	stz	bg2hofs
	stz	bg2vofs
	stz	bg3hofs
	stz	bg3vofs
	stz	cgadsub
	stz	tm
	stz	ts
	lda	#%11100000
	sta	coldata
	endc

	km_setsoundport1	stop
	km_setsoundport2	port2_stop
	km_setgamesyori		main
	km_clrbattleflag	gameover

	dec	kw_gameround
	beq	.skip
	jmp	.gameover_end
.skip
	jsl	Init_BattleGameOver_l

	km_fadeup
;;;	jsl	kscreenfadeIN_l

.loop
	km_testjoypad	start
	bne	.retry
	lda	#iv_titleirq
	sta	trans_flag		;[irq flag]
	km_waittrans			;[irq wait]
	bra	.loop
.retry
	km_settmpgamemode	title		;[gamemode]
	km_setgamesyori	rts			;[gamesyori]
;;;;	km_clrgameflag		gaming		;[gameflag]
	km_clrbattleflag	all		;[battleflag]
	km_clrscreenflag	bgcolpal	;[screenflag]
	km_clrscreenflag	objcolpal	;[screenflag]
;;;	stz	trans_flag
	rts

.gameover_end
;;;;;	jsl	startsfx_l
	pla		;[rts]
	pla		;[rts]
	rts
	ENDC


;*********************************************************************
;*								*
;*			TRAINING				*
;*								*
;*********************************************************************
;=====================================================================
;*			TYPE SELECT (TRAINING)			*
;=====================================================================
game_typesel
	IFEQ	1
	shorta
	longi
	lda	#2
	sta.l	tsx_keyyokoptr
.loop
	jsl	ktypeselcheck_l	;[typeselect check]
	jsl	do_sprites_l	;[SPRITES]

	jsl	sethvscroll_l	;[h,v scroll]

	lda	#iv_typeselirq
	sta	trans_flag
	waittrans		;[IRQ WAIT]

	km_testjoypad	ok
	beq	.loop
;* return *
	km_cmpcheck.l	tsx_keyyokoptr,2
	bne	.loop

	km_bitcheck.l	tsx_keytateflag,8
	beq	.return_training
.return_title
	km_setgamesyori		rts
	km_settmpgamemode	title
	rts
.return_training
;;;	km_setscreenflag	swapbg
;;;	km_setgamesyori		swapbg
	rts
	ENDC
;---------------------------------------------------------------------
;*			TYPE SELECT KEY CHECK			*
;---------------------------------------------------------------------
	IFEQ	1
ktypeselcheck_l
	shorta
	longi
	phb
	db7e

	km_testjoypad	start
	bne	.start
	km_testjoypad	A
	bne	.Abutton
	km_testjoypad	right
	bne	.right
	km_testjoypad	left
	km_bne	.left
	km_testjoypad	up
	km_bne	.up
	km_testjoypad	down
	km_bne	.down
	brl	.end
;-----------------------------------
.start
	lda	#2
	sta	tsx_keyyokoptr
	brl	.end
;-----------------------------------
.Abutton
	lda	tsx_keyyokoptr
	beq	.pltypesel
	dec	a
	beq	.conttypesel
	brl	.end
.pltypesel
	km_addmaxtomin	tsx_keyyokoptr,1,3,0
;	km_setval	tsx_keytateptr,0
	brl	.end
.conttypesel
	km_addmaxtomin	tsx_keyyokoptr,1,3,0
;	km_setval	tsx_keytateptr,0
	brl	.end
;-----------------------------------
.right
	km_addmaxtomin	tsx_keyyokoptr,1,3,0

	ifeq	1
	km_setval	tsx_keytateptr,0
;--- waku ---
	km_addmaxtomin.l	tsx_wakuposX,10*8,10*8*2,0
;--- aicon ---
	km_addmaxtomin.l	tsx_aiconposX,10*8,10*8*2,0
	km_setval.l		tsx_aiconposY,0
	endc

	brl	.end
;-----------------------------------
.left
	km_subltsmintomax	tsx_keyyokoptr,1,0,2
;	km_setval	tsx_keytateptr,0

	ifeq	1
;--- waku ---
	km_submintomax.l	tsx_wakuposX,10*8,0,10*8*2
;--- aicon ---
	km_submintomax.l	tsx_aiconposX,10*8,0,10*8*2
	km_setval.l		tsx_aiconposY,0
	endc
	brl	.end
;-----------------------------------
.up
	lda	tsx_keyyokoptr
	beq	.playersel_up
	dec	a
	beq	.contsel_up
	bra	.return_up

.playersel_up
	lda	tsx_keytateflag
	and	#$3
	dec	A
	bpl	.skip1
	lda	#2
.skip1
	sta	kz_x1

	lda	tsx_keytateflag
	and	#3^(-1)
	clc
	adc	kz_x1
	sta	tsx_keytateflag

;	km_submintomax	tsx_keytateptr,1,0,2
	brl	.end
.contsel_up
	km_eorflag	tsx_keytateflag,4
;	km_submintomax	tsx_keytateptr,1,0,1
	bra	.end
.return_up
	km_eorflag	tsx_keytateflag,8
;	km_submintomax	tsx_keytateptr,1,0,1
	bra	.end

;----------------------------------
.down
	lda	tsx_keyyokoptr
	beq	.playersel_down
	dec	a
	beq	.contsel_down
	bra	.return_down

.playersel_down
	lda	tsx_keytateflag
	and	#$3
	inc	A
	cmp	#3
	bne	.skip2
	lda	#0
.skip2
	sta	kz_x1

	lda	tsx_keytateflag
	and	#3^(-1)
	clc
	adc	kz_x1
	sta	tsx_keytateflag
	bra	.end
.contsel_down
	km_eorflag	tsx_keytateflag,4
;;;	km_addmaxtomin	tsx_keytateptr,1,1,0
	bra	.end
.return_down
	km_eorflag	tsx_keytateflag,8
;;	km_addmaxtomin	tsx_keytateptr,1,1,0
;-------------------------------
.end
	plb
	rtl
;=====================================================================
;*			BG SWAPPING (TRAINING)			*
;=====================================================================
game_swapbg
	shorta
	longi
	lda	fade
	km_qfadestepdown
	km_fadedownwait

;;;	km_bitcheckscreenflag	swapbg
;;	km_beq	.typeselect
;---------------------------------------------------------------------
.training
	init_bg	mode2,HORZ,16

	bg2chr	a13
	bg2scr	a13
	palette	col_1
	set_bg		;[cgx,scr,colour transfer to VRAM]
	palette	a13,3,4
	set_palette
	palette	w0,8,8
	set_palette

	km_setspritemode	mission		;[SPRITE MODE]
	jsl	init_sprites_l

;* ikinari fade in *
	jsl	initblack_l
	km_setval	stayblack,1
	km_setval	kw_blackfadestep,31
;;;	km_clrhvscrollflag	typesel
;;;	km_setgamesyori		training	;[GAME SYORI]
	km_screenon	;<--- set suru ichi ni tyuui!!(initblack_l no ushiro)
	rts
;----------------------------------------------
.typeselect
	shorta
	longi
	init_bg	mode1,HORZ,8
	bg2chr	b2		;[Trasnsfer cgx to Mario RAM]
	bg2scr	b2		;[Trasnsfer scr to Mario RAM]
	palette	b2,16,0
	set_bg
	km_setspritemode	typesel		;[SPRITE MODE]
	jsl	init_sprites_l
;* key pointer *
	km_setval.l	tsx_keyyokoptr,0
	sta.l	tsx_keytateptr
	sta.l	tsx_wakuposX
	sta.l	tsx_wakuposY

;;;	km_sethvscrollflag	typesel
;;;	km_setgamesyori		typesel		;[GAME SYORI]
	km_screenon	;<--- set suru ichi ni tyuui!!(initblack_l no ushiro)
	rts
;----------------------------------------------
;=====================================================================
;*								*
;*			GAME TRAINING				*
;=====================================================================
game_training
	shorta
	longi
	jsl	ktrainingcheck_l	; [training check]
	jsl	setblack_l		; [black fade]
	jsl	wipe_l			; [wipe]
	jsl	transfer_l
	rts
;---------------------------------------------------------------------
;*			TRAINING CHECK				*
;---------------------------------------------------------------------
ktrainingcheck_l
	shorta
	longi

	km_cmpcheckgamemode	typeselect
	beq	.typeselect
	km_cmpcheckgamemode	training
	beq	.training
	bra	.exit
;---------------------------------------------------------------------
.typeselect
	km_testjoypad	start
	bne	.goto_training

	km_testjoypad	X
	beq	.goto_camera
.goto_title
	km_settmpgamemode	title
	km_setgamesyori	rts
	bra	.exit

.goto_training
	km_settmpgamemode	training
	km_setgamesyori	rts
	bra	.exit

.goto_camera
	jsr	kcameratest
	bra	.exit
;---------------------------------------------------------------------
.training
	km_testjoypad	start
	beq	.exit

;;;	km_setgamesyori		swapbg
;;;	km_clrscreenflag	swapbg	;[type select]

;---------------------------------------------------------------------
.exit
	rtl

	ENDC

;============================================================================
;*
;*
;============================================================================
	IFEQ	1
setexpshape
	shorta
	longi
	a16
	lda	kGameMapPtr
	km_loba
	asl	a
	asl	a
	tax
	lda.l	missionmaptbl3+0,x
	sta.l	kx_expshape
	lda.l	missionmaptbl3+2,x
	sta.l	kx_exppath
	a8
	rts
	ENDC
;-------------------------------------------------------------
;*		Game Map Set				*
;-------------------------------------------------------------
	IFEQ	1
setgamemap
	shorta
	longi
	lda	KGameMapPtr
	inc	a
	sta	kGameMap

	i8
	ldx	KGameMapPtr
	i16
;;;;	km_ldatbl_i8x	missionmaptbl,KGameMapPtr
;;;;	km_stagamemode_Nofl

	lda.l	missionmaptbl2,x
	sta	kw_PlanetCol

	rts

;* planet colour *
missionmaptbl2
	db	pal_3		;stg1
	db	pal_4		;stg2
	db	pal_5		;stg3
	db	pal_1		;stg4
	db	pal_nopal	;stg5
	db	pal_2		;stg6
	db	pal_nopal	;sos1
	db	pal_nopal	;sos2
	db	pal_nopal	;sos3
	db	pal_nopal	;ext1
	db	pal_nopal	;ext2
	db	pal_nopal	;ext3
	db	pal_nopal	;ext4
	db	pal_nopal	;
	ENDC
;-------------------------------------------------------------
;*		Game Map Set				*
;-------------------------------------------------------------
	IFEQ	1
setbattlemap
	shorta
	longi
	km_ldatbl_i8x	battlemaptbl,KGameMapPtr
	km_stagamemode_NoFl
	rts

	ENDC
;-------------------------------------------------------------
;*		Game Map Set				*
;-------------------------------------------------------------
	IFEQ	1
settestmap
	shorta
	longi
	km_ldatbl_i8x	testmaptbl,KGameMapPtr
	km_stagamemode
	rts
testmaptbl
	db	kmode_kmap
	db	kmode_tmap
	db	kmode_dmap
	db	kmode_emap
	db	kmode_ymap
testmaptblEND
	db	kmode_testlocation
	ENDC
;--------------------------------------

;=====================================================================
;*		    	Total Score Keisan			*
;* Init :data bank 7e						*
;=====================================================================
	IFEQ	1
ScoreKeisan
	shorta
	longi
;* Round basic score *
	a16
	km_player	1,x
	lda	al_hp,x
	and	#$3F
	km_shiftrua2
	xba
	sta	khpscore1

	km_plheapptr	1,x
	lda	kscore,x
	sta	kroundscore1

	lda	kringout,x
	and	#$3F
	xba
	sta	Kringoutscore2
	
	km_player	2,x
	lda	al_hp,x
	and	#$3F
	xba
	km_shiftrua2
	sta	khpscore2

	km_plheapptr	2,x
	lda	kscore,x
	sta	kroundscore2

	lda	kringout,x
	and	#$FF
	xba
	sta	Kringoutscore1

;* round total score *
	lda	kroundscore1
	clc
	adc	khpscore1
	clc
	adc	Kringoutscore1
	sta	kroundtotalscore1

	lda	kroundscore2
	clc
	adc	khpscore2
	clc
	adc	Kringoutscore2
	sta	kroundtotalscore2

;* total score *
	lda	ktotalscore1
	clc
	adc	kroundtotalscore1
	sta	ktotalscore1

	lda	ktotalscore2
	clc
	adc	kroundtotalscore2
	sta	ktotalscore2
	a8

	ENDC
	rts
;*********************************************************************
;*								*
;*		Initial Battle Game Over 			*
;*********************************************************************
	shorta
	longi
	IFEQ	1
Init_BattleGameOver_l
	phb
	db0
	screen_off
	jsr	Initial_BGO_PPUreg
;--------------------------------------------------------------------
	jsr	Set_BGO_BG1CGX
	jsr	Set_BGO_BG1SCR

	jsr	Set_BGO_BG2CGX
	jsr	Set_BGO_BG2SCR

;	jsr	Set_BGO_BG3CGX
;	jsr	Set_BGO_BG3SCR

	jsr	Set_BGO_COL

	jsr	Set_BGO_OBJCGX
	jsr	Set_BGO_OAM

	km_IRQenable	titleirq	;[IRQ enable]

	plb
	rtl

;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
;---------------------------------------------------------------------
bgo_bg1_cgx	equ	(0*k)/2
bgo_bg1_scr	equ	(40*k)/2
bgo_bg2_cgx	equ	(0*k)/2
bgo_bg2_scr	equ	(40*k)/2
bgo_bg3_cgx	equ	(0*k)/2
bgo_bg3_scr	equ	(40*k)/2
bgo_obj_cgx	equ	_obj_cgx	;(50*k)/2
;---------------------------------------------------------------------
Initial_BGO_PPUreg
	shorta
	lda	#%00000001
	sta	bgmode		;BG mode 1 ,8*8 dot

	lda	#(bgo_bg1_scr>>8)&$fc	;BG1 SCR screen 1
	sta	bg1sc				   

	lda	#(bgo_bg2_scr>>8)&$fc
	sta	bg2sc			;BG2 SCR screen 1
	sta	kw_bg2sc

	lda	#(bgo_bg3_scr>>8)&$fc
	sta	bg3sc			;BG3 SCR ,screen 1

	lda	#(bgo_bg1_cgx>>12)!((bgo_bg2_cgx>>8)&$f0)
	sta	bg12nba			;BG1 (0000) ,BG2 (0000)

	lda	#(bgo_bg3_cgx>>12)
	sta	bg34nba			;BG3

	lda	#(bgo_obj_cgx>>13)
	sta	objsel			;OBJ

	lda	#%00000001
	sta	tm			;BG1,OBJ display
	sta	kw_tmbackup
	lda	#%00000000
	sta	ts
;* color add clear *
	stz	wobjsel
;* scroll initial *
	stz	bg1hofs
	stz	bg1hofs
	stz	bg1vofs
	stz	bg1vofs
	stz	bg2hofs
	stz	bg2hofs
	stz	bg2vofs
	stz	bg2vofs
	rts
;=====================================================================
;*			Initial BG1 Character Data		*
;=====================================================================
Set_BGO_BG1CGX
	decvramnotrans	0,bgo_bg1_cgx,b0_ccr,($1e0*32)
	rts
;=====================================================================
;*			Initial BG1 Screen Data			*
;=====================================================================
Set_BGO_BG1SCR
	decvramnotrans	0,bgo_bg1_scr,b5_pcr,$800
	rts
;=====================================================================
;*			Initial BG2 Character Data		*
;=====================================================================
Set_BGO_BG2CGX
	rts
;=====================================================================
;*			Initial BG2 Screen Data			*
;=====================================================================
Set_BGO_BG2SCR
	rts
;=====================================================================
;*			Initial BG3 Character Data		*
;=====================================================================
Set_BGO_BG3CGX
	rts

;=====================================================================
;*			Initial BG3 Screen Data			*
;=====================================================================
Set_BGO_BG3SCR
	rts
;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_BGO_COL
	decrunch_palettes
	dmacgram	0,0,b5_pac,$200
	rts

;=====================================================================
;*			Initial OBJ Character Data		*
;=====================================================================
Set_BGO_OBJCGX
	rts

;=====================================================================
;*			Initial OAM Data			*
;* Data Bank:0							*
;=====================================================================
Set_BGO_OAM
;-------------- OBJ Display Enable ------------------
	a8i16
	oamclear_SG		;[OAM clear]
	oamsuballon		;[OAM display ON]

;bank0
	a8i16
	dmaoaram	0,0,sprites,(128*4)+(128/4)	; dma into oram
	rts

	ENDC

;*****************************************************************************
;*			NotUseing AREA START				*
;*									*
;*****************************************************************************
		IFEQ	1
;=============================================================
;*		Radar Mode Check		[PAUSE]	*
;* Data Bank 7e						*
;=============================================================
RadarModeCheck
	shorta
	longi
;=========================== Player 1 ========================
;--- push select ---
	testjoypad	select
	bne		.PushP1
;--- push left -----
	testjoypad	Left
	beq		.CheckP1_R
	km_checkflag.l	KRadarFlag,P1radmodeFl
	beq		.player2
	bra		.PushP1
;--- push right ----
.CheckP1_R
	testjoypad	RIGHT
	beq		.player2
	km_checkflag.l	KRadarFlag,P1radmodeFl
	bne		.player2
.PushP1
	km_eorflag.l	KRadarFlag,P1radmodeFl
	km_setflag.l	KRadarFlag,P1radScChFl
	ksound	cursor		;sound
;=========================== Player 2 =========================
.player2
;--- push select ---
	testjoypad2	select
	bne		.PushP2
;--- push left -----
	testjoypad2	Left
	beq		.CheckP2_R
	km_checkflag.l	KRadarFlag,P2radmodeFl
	beq		.exit
	bra		.PushP2
;--- push right ----
.CheckP2_R
	testjoypad2	RIGHT
	beq		.exit
	km_checkflag.l	KRadarFlag,P2radmodeFl
	bne		.exit
.pushP2
	km_eorflag.l	KRadarFlag,P2radmodeFl
	km_setflag.l	KRadarFlag,P2radScChFl
	ksound	cursor
;-------------------------------------------------------------
.exit
	rts
;=====================================================================
;*			3D MEGANE Ver				* 
;* 18/10/93								*
;=====================================================================
beta_scr	dw	$2001
nuki_scr	dw	$2000
	a8i16
;	test_screenmode	3dglasses
;	bne	.picture3D	;If 3D megane mode then jmp (.picture3D)
	jmp	.NormalGame
;----------------------------------------------------------------------
.picture3D
	kwaitvbl		;V blank wait
	stz	hdmaen		;hdma off
	stz	mdmaen		;dma off
	lda	#$80
	sta	inidisp		;Blanking on
;----------------------------------------------------------------------
;BG3 cgx set (2 bit mode)
	lda	#$80
	sta	vmainc
	ldx	#bg3_cgx_3D
	stx	vmaddl
;*** character No 0 (NUKI)***
	ldy	#8	;(2 bitmode)
	ldx	#nuki
.setcgx0
	stx	vmdatal
	dey
	bne	.setcgx0

;*** character No 1 (BETA)***
	ldy	#8
	ldx	#beta
.setcgx1
	stx	vmdatal
	dey
	bne	.setcgx1
;----------------------------------------------------------------------
;BG3 SCR set
	kbetascr_l bg3_scr_3D,beta_scr,$400
	kbetascr_h bg3_scr_3D,beta_scr+1,$400

	ldy	#12			;loop counter

	ldx	#bg3_scr_3D+$c0		;VRAM set start address
	stx	vmaddl
.loop_2
	ldx	#$2001
	rept	5
	stx	vmdatal
	endr

	ldx	#$2000
	rept	22
	stx	vmdatal
	endr

	ldx	#$2001
	rept	5
	stx	vmdatal
	endr
	dey
	bne	.loop_2
;----------------------------------------------------------------------
;BG1,2 Screen Color Palette change

	lda	#%10000000
	sta	vmainc

	ldx	#bg1_scr
	stx	vmaddl

;***** BG1 color palette Set *****
	ldy	#$1e0
.loop1
	lda	vmdatahr	;dummy read
	lda	vmdatahr	;VRAM SCR Data Read
	and	#%11100011
	ora	#%00000000	;color Palette No.0
	stx	vmaddl		;address reset
	sta	vmdatah		:SCR Data Set
	inx
	dey
	bne	.loop1

;***** BG2 color palette Set *****
	ldy	#$200
.loop2
	lda	vmdatahr	;dummy read
	lda	vmdatahr	;VRAM Scr Data READ
	and	#%11100011
	ora	#%00001000	;color Palette No.2
	stx	vmaddl		;address reset
	sta	vmdatah
	inx
	dey
	bne	.loop2
;----------------------------------------------------------------------
;* Color Data Set
	dmacgram	0,0,test3d_pac,$80
;----------------------------------------------------------------------
;PPU CPU Register Set
	lda	#1!1<<3
	sta	bgmode

	lda	#bg2_scr_3D>>8
	sta	bg2sc

	lda	#%00000111
	sta	bg34nba

	lda	#$74
	sta	bg3sc
;---------------------------------------------------------------------
;Color ADD/SUB
	lda	#%00000010
	sta	cgswsel
	lda	#%10100010
	sta	cgadsub
	lda	#%01
	sta	ts
	lda	#%110
	sta	tm
;---------------------------------------------------------------------
	kwaitvbl		;V blank wait
	lda	rdnmir
	lda	#%00110001
	sta	nmitimen	;H,V Counter enable
	lda	#%00000010
	sta	hdmaen		;HDMA ON
	sta	hdmaen_gc	;For Screen ON

	lda	#$0f
	sta	inidisp		;Blanking Off 
.NormalGame

;=====================================================================
;*		Check Flags (2P Battle)		[GAME OVER]	*
;=====================================================================
KGMOVCheck_2BT
	shorta
	longi

	s_set_objtobeplayer1	x
	jsr	KGMOVCheck_sub	;Flag Check Player 1
	s_set_objtobeplayer2	x
	jsr	KGMOVCheck_sub	;Flag Check Player 2

;=========== GAME OVER ( DO? OR NOT DO? )CHECK ====
	km_checkflag.l	KGameStates,GameOverFlag
	beq	.exit
;---------------------------------------------------------------------
.GameOver
	jsr	Do_GmOvDemoBT	;Display Game Over Demo
	jsr	Do_GameOverBT	;For 2p Battle Game Over

	screen_off		;screen blanking & HDMA OFF
	rtl
;---------------------------------------------------------------------
.exit
	jmp	game_main

;---------------------------------------------------------------------
;*		 Set Game over Flag (2P Battle)	[GAME OVER]	* 
;---------------------------------------------------------------------
KGMOVCheck_sub
;data bank 7e
	shorta
	longi
	phb
	db7e
	km_plheapptrSD		x,y
;=========== GAME TIME OVER CHECK ============
	lda	GameTimer
	ora	GameTimer+1
	bne	.nextcheck1
	km_setflag	KGMOVER,TimeUpFlag,y
	km_setflag	KGameStates,GameOverFlag
;=========== Shoot Down Check ================
.nextcheck1
	lda	al_hp,x
	bne	.nextcheck2

	km_setflag	KGMOVER,ShtDownFlag,y		;GAME OVER factor
	km_setflag	KGameStates,GameOverFlag	;GAME OVER Flag ON

;	km_setflag	KHITFLASH,kdmgflag,y 		;damage meter <--- 0
	lda	#DmgIntTm
	ora	#kdmgallflag
;	sta	KHITFLASH,y
	kplsound	x,damage_l		;hit damage sound
;=========== Ring Out Check ==================
.nextcheck2
	km_checkflag	KGMOVER,RingOutFlag,y
	beq	.exit
	km_setflag	KGameStates,GameOverFlag
.exit
	plb
	rts

;*********************************************************************
;*		Game Over Demo			[GAME OVER]	*
;*********************************************************************
Do_GmOvDemoBT
	shorta
	longi

	lda	#10
	sta.l	demoTimer
.loop
	jsl	transfer_l   ; call this every frame to update aliens
	a8
	lda.l	demoTimer
	bne	.loop
	rts
;*********************************************************************
;*	2P Battle GAME OVER Main Routine	[GAME OVER]	*
;*		(the issue of the battle)			*	
;*********************************************************************
Do_GameOverBT
;==================== Clear Parameter & Alien block ==================
	a8i16
	waittrans

	jsl	kill_list_l		; remove all alien blocks
	jsl	initmem_l
	jsl	mapsysteminit_l

	a16
	lda	#0
	sta	playpt1
	sta	playpt2
	sta.l	m_dlptr
	sta.l	m_numshapes
	a8
;=========================== Demo Display =============================

	ldy	#viewblk1		; address of view #1's block
	jsl	init_objvars_l

	ldy	#viewblk2		; address of view #1's block
	jsl	init_objvars_l

; set position, al_sword1 is zoom on camera

	a8i16
;	lda	#gameovermap>>16
;	sta	mapbank
;	ldx	#gameovermap&$7fff
;	stx	mapptr
;	jsl	newobjs_l		; add objects to alien blocks

	a8
;	jsl	initgame_strats_l	;initialise game

;Initialise parameters
	lda	#0
	sta.l	KwindowTm

	lda	#25
	sta.l	demoTimer
.waitfornotstart
	waittrans			;irq wait
;****************************************************************************

;****************************************************************************
	ifeq	1
	ldx	#viewblk1		; address of view #1's block

	testkeydown	TLEFT
	beq	.skip
	s_add_alvar	W,x,al_roty,#256

.skip
	testkeydown	TRIGHT
	beq	.skip2
	s_add_alvar	W,x,al_roty,#-256

.skip2
	testkeydown	up
	beq	.skip3
	s_add_alvar	W,x,al_worldz,#30
.skip3
	testkeydown	down
	beq	.skip4
	s_add_alvar	W,x,al_worldz,#-30
.skip4
	testkeydown	left
	beq	.skip5
	s_add_alvar	W,x,al_worldx,#-30
.skip5

	testkeydown	right
	beq	.skip6
	s_add_alvar	W,x,al_worldx,#30
.skip6
	endc
;****************************************************************************
;****************************************************************************
	phb
	jsl	transfer_l		; call this every frame to update aliens
	plb

	ifeq	0
;	oamclear_SG			;sprites
;	oamsuballon			;sprites
	jsr	GMOVWindow		;Window
	jsl	find_window_pri_l	;Window
	endc
;-------------------------------------------------------------
	a8
	lda.l	demoTimer
	beq	.exit
	jmp	.waitfornotstart
.exit
	lda	#1
	sta.l	KGameStates
	rts
;=====================================================================
;*			GAME OVER WINDOW	[GAME OVER]	*
;=====================================================================
GMOVWindow
	shorta
	longi

	ldy	#0		;HDMA Table Pointer
;======== Player 1 Window Flash =======
;------- Player 1 HDMA Data Copy ------
.PauseWindowP1

	KHDMATbl	y,#(P1WinYSta-1),#NoWinXSta,#NoWinXEnd,pausehofs
	KHDMATbl	y,#(P1WinYEnd)-(P1WinYSta),#P1HtFlXSta,#P1HtFlXEnd,pausehofs
.PauseWindowP2
	KHDMATbl	y,#LineNumber8,#NoWinXSta,#NoWinXEnd,pausehofs
	KHDMATbl	y,#(P2WinYEnd)-(P2WinYSta),#P2WinXSta,#P2WinXEnd,pausehofs
.FlashEnd
	KHDMAtblEND	y,pausehofs	;Set HDMA dummy data

;============ Window Register Para Set ===============
	ai8
	lda.l	KwindowTm
	tax
	lda.l	GMOVWINDATA+0,x
	bne	.skip

	lda	#$3f
	sta	kwork+0
	lda	#$5f
	sta	kwork+1
	lda	#$9f
	sta	kwork+2
	bra	.skip2
.skip
	sta	kwork+0
	lda.l	GMOVWINDATA+1,x
	sta	kwork+1
	lda.l	GMOVWINDATA+2,x
	sta	kwork+2

	txa
	clc
	adc	#3
	sta.l	KwindowTm
.skip2

	i16
	alloc_window	pausewindow,1	; x = hitfalsh

	lda	#%00000011
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#%00010000
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda	#%10000011
	sta	wm_cgadsub,x	;2131h	;bg1,bg2

	lda	kwork+0
	sta	wm_coldata_r,x	;2132h	;Red

	lda	kwork+1
	sta	wm_coldata_g,x	;2132h	;Green

	lda	kwork+2
	sta	wm_coldata_b,x	;2132h	;Blue

	ldy	#xhdma_pausehofs&WM
	sty	wm_hdma,x	;4302h,4303h	:hdma table address
	lda	#xhdma_pausehofs>>16
	sta	wm_hdma+2,x	;4304h		:hdma table address
.exit
	rts

;=====================================================================
;*		Init Game Colour Palette			*
;=====================================================================
	IFEQ	1
InitGamePalette_l
	shorta
	longi

	km_bitcheckscreenflag	bgcolpal
	km_bne	.DecrunchPalette
	km_bitcheckscreenflag	objcolpal
	km_bne	.DecrunchPalette
	brl	.exit
.DecrunchPalette
	decrunch_palettes
;------------------------------------------------
;* mission stage 1 *
	km_cmpcheckgamemode	missionstage1
	bne	.notmisstg1
;* heap memory get *
	phb
	db7e
	a16
	lda	#512*3
	jsl	alloc_l
	sta	democolor_pointer
	a8
	plb
;* copy screen data  to heap RAM *
	ldx	democolor_pointer
	km_dmaromXRAM	0,(tcol1_pac),xheap,512*3
.notmisstg1
;------------------------------------------------
;* select mission map *
	km_cmpcheckgamemode	selectmissionmap
	bne	.CheckGameMap
	dmaramram	0,kx_palette2,(b8_pac),256
	brl	.exit
.CheckGameMap

;------------------------------------------------
;* game map *
	km_cmpcheckgamesyori	main
	km_bne	.exit
;* radar color pallet to SFX RAM copy [3 palette *4 hon (1palette = 32 byte)]
	km_bitcheckscreenflag	objcolpal
	km_beq	.Check_bgpal
	dmaramram	0,kx_palette1,rdfl_pac,384
.Check_bgpal
;* BG 2 screen colour palette to SFX RAM copy *
	lda.l	KGameMap
	cmp	#map_stg2
	beq	.desert
	cmp	#map_stg6	;(kvars.inc)
	beq	.marine
	cmp	#map_stg5	;(kvars.inc)
	km_beq	.sun
	cmp	#map_ext1	;(kvars.inc)
	beq	.space
	cmp	#map_ext2	;(kvars.inc)
	beq	.space
	cmp	#map_ext3	;(kvars.inc)
	beq	.space
	BRL	.exit
.desert
	km_blocktrans	(c0_pac),kx_palette2,256
	bra	.exit
.marine
	km_blocktrans	(c1_pac+8*16*2),kx_palette2,256
	bra	.exit
.space
	km_blocktrans	(c1_pac),kx_palette2,256
	bra	.exit
.sun
	km_blocktrans	(c0_pac+8*16*2),kx_palette2,256
.exit

	rtl

;=====================================================================
;*		Mission Explain Screen Change			*
;=====================================================================
InitExplainScreen_l
	php
	shorta
	longi

	km_cmpcheckgamesyori	explain
	bne	.end

	lda	#$0
	sta	vmainc
	ldx	#_me_bg1_scr+4*32+$19
	stx	kpointer

	lda	#4
	sta	kcounter

.bigloop
	ldy	#5
.loop
	stx	vmaddl
	lda	vmdatahr
	and	#%11100011
	ora	#%00010000
	sta	vmdatah
.	inx
	dey
	bne	.loop

	a16
	lda	kpointer
	clc
	adc	#32
	sta	kpointer
	tax
	a8
	dec	kcounter
	bne	.bigloop
.end
	plp
	rtl
;=====================================================================
;*			DEC RAM	(Yajima's)			*
;=====================================================================
InitGameScreen_l
	php
	a8i16
;* mission stage 1 *
	km_cmpcheckgamestage	stg4
	km_bne	.notmisstg4

;* heap memory get *
	phb
	db7e
	a16
	lda	#2048
	jsl	alloc_l
	sta	heaven_bgpointer

	lda	#2048
	jsl	alloc_l
	sta	hell_bgpointer
	a8
	plb

;* copy screen data  to heap RAM *
	decram	a3_pcr,0
	ldy	heaven_bgpointer
	km_blocktransY	($700000+dec_base),xheap,2048
	decram	a4_pcr,0
	ldx	hell_bgpointer
	km_blocktransY	($700000+dec_base),xheap,2048
.notmisstg4
	plp
	rtl
	ENDC

;*****************************************************************************
;*			NOT USEING AREA END				*
;*									*
;*****************************************************************************
	ENDC


;*****************************************************************************
;*****************************************************************************
;*****************************************************************************
;*****************************************************************************
;*									*
;*			DEBUG MODE					*
;*									*
;*****************************************************************************
;*****************************************************************************
;*****************************************************************************
;*****************************************************************************
DbugMode1_l
	shorta
	longi
	km_pushallreg

	a8i16

	db7e
;*********************************************************************
;=====================================================================
;*								*
;*			DISPLAY START				*
;*								*
;=====================================================================
;*********************************************************************
	IFNE	kginfo

;=====================================================================
;*			Memeory Length				*
;=====================================================================
;* Kawaguchi using Memory Length Check *
	ifeq	1
	a16
	lda	#(kw_end-kw_start)&WM
	printh	alc
	lda	#(kx_end-kx_start)&WM
	printh	xalc
	a8
	endc
;=====================================================================
;*								*
;*			Total Game				*
;*								*
;=====================================================================
	IFEQ	1
	a16
	lda.l	mmx_message_sos
	printd	<Message Trigger>
	lda	pepper_message
	printh	<Pepper Message>
	a8
	ENDC

	ifeq	1
	lda.w	kw_GameFlag
	printb	<GAME FLAG>
	lda.w	kw_gamemode
	printd	<Game Mode>
	endc

	IFEQ	1
	lda	p1_hp
	printd	HP
	ENDC
;=====================================================================
;*								*
;*			Mission Map				*
;*								*
;=====================================================================
;---------------------------------------------------------------------
;*			Flags					*
;---------------------------------------------------------------------
	ifeq	1
	a16
	lda	kw_MisMapFlag
	printb	mismapflag
	lda	kw_MisMapStateFlag
	printb	mismapstflag
	lda	kw_MisMapSyori
	printb	mismapsyori
	a8
	ENDC
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;*** Zaco Enemy Mission BG Check Number ***
	ifeq	1
	lda	kx_NearPlanetNum
	printh	BGcolor2
	endc

;* Mission Map no Clear kazu *
	ifeq	1
	lda	kx_missiontotal
	printh	<kazu>
	lda	kx_planetkazu
	printh	<planet kazu>
	lda	kx_battleshipkazu
	printh	<bs kazu>
	lda	kx_enemytotal
	printh	<en total>
	endc

;=====================================================================
;*								*
;*			Mission 				*
;*								*
;=====================================================================
;---------------------------------------------------------------------
;*			Flags					*
;---------------------------------------------------------------------
	IFEQ	1
	a16
	lda	rannyumodeswitch
	printh	rannyu
	a8
	ENDC

	IFEQ	1
	a16
	lda	kw_RandomPtr
	printh	<randonm>
	lda	kw_RndPlanetPtr
	printh	<planet randonm>
	a8
	ENDC

	IFEQ	1
	a16
	lda	kw_MissionFlag
	printh	<mission flag>
	lda	kw_MissionSyori
	printh	<mission syori>
	a8
	ENDC

	ifeq	1
	lda	kgamemapptr
	printh	<kgamemapptr>
	lda	currentlevel
	printh	<currentlevel>
	lda	KStackNumber
	printh	<kstacknumber>
	lda	kenemynumber
	printh	<kenemynumber>
	lda	PlanetSwitch
	printh	<planetswitch>
	endc

;* Player & Enemy Initial Postion *
	ifeq	1
	a16
	lda	p1_worldx_init
	printh	<Pl Xzahyou>
	lda	p1_worldz_init
	printh	<Pl Zzahyou>
	a8
	lda	p1_roty_init
	printh	<Pl RotY>
	a16
	lda	p1_dist2enemy
	printh	<pl dist>


	lda	e_worldx_init
	printh	<En Xzahyou>
	lda	e_worldz_init
	printh	<En Zzahyou>
	a8
	lda.w	mmx_enangY+1,y
	printh	<En RotY>
	ENDC

	IFEQ	1
	a16
	lda	KStackNumber
	printh	<stack number>
	tax
	asl	a
	tay
	lda.w	SebangoSwitch_0,y
	printb	<sebango>
   	a8
	lda.l	EEnemyNumber_0,x
  	printh	<eenemy number>
	ENDC


;**** Planet List *****
	IFEQ	1
	a16
	lda	kx_currentplanetptr
	printh	<current planetptr>
	a8
	ENDC

	IFEQ	1
	a16

	lda	kx_clrenemytotal
	printh	<sos total>
	lda	kx_enemytotal
	printh	<display enemy>

	lda	kx_planetlistptr
	printh	planetlistptr
	lda	kx_currentplanetptr
	printh	<current planetptr>
	tay
	clc
	adc	#mmx_planetflag&WM
	printh	<planetflag addr>
	lda.w	mmx_planetflag,y
	printh	<current planetflag>
	lda.w	mmx_psos,y
	printh	<current psos>
	a8
	ENDC

;*** Enemy List ****
	IFEQ	1
	a16
	lda	kx_SOSEnemyptr
	printh	<current enemyptr>
	a8
	ENDC

	IFEQ	1
	a16
	lda	kx_enlistptr
	printh	<enemy listptr>

	lda	kx_SOSEnemyptr
	printh	<current enemyptr>
	tay

;	clc
;	adc	#mmx_enflags&WM
;	printh	<enemyflag addr>

	lda.w	mmx_enflags,y
	printh	<enemy flag>

	lda.w	mmx_ensourplanetptr,y
	printh	<moto planetptr>
	lda.w	mmx_endestplanetptr,y
	printh	<saki planetptr>
	a8
	ENDC

;****** Radar Scale ******
	IFEQ	1
	a16
	lda	kx_radarscale
	printh	<radar scale>

;	lda	kx_radarmin
;	printh	<radar min>
;	lda	kx_radarmax
;	printh	<radar max>

	a8
	ENDC

;*********************************************************************
;*			SOUND					*
;*********************************************************************
	kbugapuport

	IFEQ	1
	lda	ksoundmapptr
	printh	<special sound>
	ENDC
	IFEQ	1
	a16
	lda	#bgm_music
	printh	<port0 addr>
	a8
	lda	bgm_music
	printh	<port0 addr>

	a16
	lda	#al_inertptr&WM	; zero its inert connection
	printh	<BUG Addr>

	lda	#bgm_back&WM
	printh	<Back Addr>

	a8
	lda	bgm_back
	printh	<BGM Back>
	ENDC

;================== PORT 2 =============================
	IFEQ	1
	lda	sdchkno2
	printh	<sound No>

	lda	sdport2
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	printb	<port2 flag>

;;;	lda	sdport2
;;;	printh	<port2>
;;;	lda	sdchkptr2
;;;	printh	<alien pointer>

	a16
	lda	sdchklen2
	printh	<distance>
	a8
	ENDC
;================== SOUND =============================
	IFEQ	1
	lda	sdchkno2
	printh	<sound No>
	lda	sdbakno2
	printh	<sound BACKNo>
	a16
	lda	sdchkptr2
	printh	<alien ptr>
	lda	sdbakptr2
	printh	<alien BACKptr>
	a8
	ENDC
;================== SOUND PATH CHECK ==================

	IFEQ	1
	a16
	lda	sdbakptr2
	printh	<alien>
	a8
	ENDC

	IFEQ	1
	a8
	lda.w	kw_swork+0
	printh	<ANGLE>

	a16
	lda.w	kw_swork+2
	printh	<Sound POS>
	a8

	A16
	lda.w	kw_swork+4
	printh	<DIST>
	A8

	A16
	lda.w	kw_swork+6
	printh	<Sound DIST>
	a8

	lda.w	kw_swork+9
	printh	<Player ANGLE>

	lda.w	kw_swork+8
	printh	<Camera ANGLE>
	ENDC
;=====================================================================
*		SCORE						*
;=====================================================================
	IFEQ	1
	a8
	lda	kx_HP1
	printd	<HP>
	lda	kx_weaponnum1
	printd	<WEAPON>
	lda	kw_PlayerRest1
	printd	<ZANKI>
	a16
	lda	kx_bonustm
	printd	<REST TIME>
	lda	kw_basicscore1
	printd	<basic>
	lda	kw_extrabonus1
	printd	<extra>
	lda	kw_timebonus1
	printd	<time>
	lda	kw_totalscore1
	printd	<total>
	a8
	ENDC
;=====================================================================
;*			Double Buffer Flag			*
;=====================================================================
	IFEQ	1
	a16
	lda.l	drawmap
	printh	<draw map1>
	lda.l	showmap
	printh	<show map1>
	a8
	ENDC
;=====================================================================
;*			HEAP					*
;=====================================================================
	IFEQ	1
	a16
	lda	#heap
	printh	<heap addr>
	lda	heap
	printh	<heap>
	lda	hell_bgpointer
	printh	<hell>
	lda	heaven_bgpointer
	printh	<heaven>
	a8
	ENDC
;================== KSCREEN CHECK =====================

	IFEQ	1	
	lda	windowmode1
	printh	<window>
	ENDC

	ifeq	1
	lda.w	kw_spritemode
	printd	<sprite mode>
	endc

;--------- Screen Flag -------------
	ifeq	1
	a16
	lda	kw_screenflag
	printb	<screen flag>
	a8
	endc

;=============== Player heap pointer ===================
	ifeq	1
	a16
	s_set_objtobeplayer1	x
	lda.w	al_sword2,x
	printh	heap1

	s_set_objtobeplayer2	x
	lda.w	al_sword2,x
	printh	heap2
	a8
	endc
;=============== Camera parameters =====================
	ifeq	1
	a16
	ldx	#viewblk1
	lda.l	al_worldx,x
	printh	camera1X
	lda.l	al_worldy,x
	printh	camera1Y
	lda.l	al_worldz,x
	printh	camera1Z
	a8
	endc

	ifeq	1
	ldx	#viewblk1
	lda.l	al_rotx,x
	printh	angleX
	lda.l	al_roty,x
	printh	angleY
	lda.l	al_rotz,x
	printh	angleZ
	endc


	ifeq	1
	a16
	ldx	#viewblk2
	lda.l	al_worldx,x
	printh	camera2X
	lda.l	al_worldy,x
	printh	camera2y
	lda.l	al_worldz,x
	printh	camera2z
	a8
	lda.l	al_roty,x
	printh	rotY
	endc
;**************** Player 1 x,y,rot y ******************
;======== X,Y,Z postion ========
;player1
	ifeq	1
	a16
	s_set_objtobeplayer1	x
	lda.l	al_worldx,x
	printh	player1X

	lda.l	al_worldy,x
	nega
	printh	player1Y

	lda.l	al_worldz,x
	printh	player1Z

	a8
	endc
;player2
	ifeq	1
	a16
	s_set_objtobeplayer2	x
	lda.l	al_worldx,x
	printh	player2X
	lda.l	al_worldy,x
	nega
	printh	player2Y
	lda.l	al_worldz,x
	printh	player2Z
	a8
	endc
;======== Xrot,Yrot,Zrot =======
;player1
	ifeq	1
	s_set_objtobeplayer1	x
	lda.l	al_rotx,x
	printh	pl1rotX
	lda.l	al_roty,x
	printh	pl1rotY
	lda.l	al_rotz,x
	printh	pl1rotZ
	endc
;player2
	ifeq	1

	s_set_objtobeplayer2	x
	lda.l	al_rotx,x
	printh	pl2rotX
	lda.l	al_roty,x
	printh	pl2rotY
	lda.l	al_rotz,x
	printh	pl2rotZ
	endc
;======= VEL,velx,vely,velz ========

	ifeq	1
	s_set_objtobeplayer1	x
	a8
	lda.l	al_vel,x
	printd	pl1VEL
	endc

	ifeq	1
	lda	al_vx,x
	printd	pl1VELX
	lda	al_vy,x
	printd	pl1VELY
	lda	al_vz,x
	printd	pl1VELZ
	endc
;======== BoostFlag ============
	ifeq	1
	a8
	km_plheapptr	1,x
	lda	exal_boost,x
	printd	pl1boost

	km_plheapptr	2,x
	lda	exal_boost,x
	printd	pl2boost

	endc
;======= Animation Flame =========
	ifeq	1
	s_set_objtobeplayer1	x
	lda	al_animframe,x
	printd	planmflame
	endc
;======= Ring Out Timer ==========
;player1
	ifeq	1
	lda.l	P1RingOutTm
	printd	pl1ringouttime
	endc
;player2
	ifeq	1
	lda.l	P2RingOutTm
	printd	pl2ringouttime
	endc
;======= Player HP ===============
;player1
	ifeq	1
	s_set_objtobeplayer1	x
	lda	al_hp,x
	printd	pl1HP
	endc
;player2
	ifeq	1
	s_set_objtobeplayer2	x
	lda	al_hp,x
	printd	pl2HP
	endc

	ifeq	1
	km_plheapptr	1,x
	lda.w	khp,x
	printh	pl1HP
	endc

	ifeq	1
	km_plheapptr	2,x
	lda.w	khp,x
	printh	pl2HP
	endc

;================= player H,V scroll ====================
	ifeq	1
	a16
	km_ldahvscrollflag
	printh	<scroll flag>

	lda.l	player1vscroll
	printh	vscroll
	lda.l	player1hscroll
	printh	hscroll
	a8
	endc
;======== Player work ==========
	ifeq	1
	km_plheapptr	1,x

	lda	kgbyte1,x
	printb	22,0
	lda	kgbyte2,x
	printb	22,1
	lda	kgbyte3,x
	printb	22,2
	lda	kgbyte4,x
	printb	22,3
	lda	KBOMSHOT,x
	printb	22,4
	lda	kgbyte6,x
	printb	22,5
	plb
	endc

	IFEQ	1
	s_set_objtobeplayer1	x
	lda	al_pbyte1,x
	printb	22+7,0
	lda	al_pbyte2,x
	printb	22+7,1

	lda	al_sbyte1,x
	printb	22+7,2
	lda	al_sbyte2,x
	printb	22+7,3
	lda	al_sbyte3,x
	printb	22+7,4
	lda	al_sbyte4,x
	printb	22+7,5

	a16
	lda	al_pword1,x
	printw	22+5,6
	lda	al_sword2,x
	printw	22+5,7
	a8
	endc

;--------- ENEMY NUMBER ---------------
	ifeq	1
	lda.l	Kenemynumber
	printd	<Enemy Number>
	endc

;--------- Game MODE ---------------
	ifeq	1
	lda.l	KGameMap
	printd	<Game Mode>
	endc
;--------- Game Timer ---------------
	ifeq	1
	a16
	lda.l	GameTimer
	printd	GameTimer
	a8
	endc

;---------- SCROLL ------------------
	ifeq	1
	a16
	lda.l	kx_check
	printh	vscroll
	a8
	endc
;--------- BOSS sprites -------------

	ifeq	1
	a16
	lda	kw_dmasaddr
	printh	<boss saddr>
	lda	kw_dmadaddr
	printh	<boss daddr>
	a8
	lda	kw_BossMeterDMAsw
	printh	<dma switch>
	endc

;*** Inert alien Number ****
InertDisplay
	IFEQ	1
	shorta
	longi

	a16
	ldy	#0
	ldx	inertlistptr
	beq	.exit		;if = 0 :alien nothing

.next	iny
	lda.w	_next,x
	tax
	bne	.next

.exit	tya
	printd	inert
	a8
	ENDC
;**** Alien Number *****
AlienDisplay
	IFEQ	1
	shorta
	longi

	a16
	ldy	#0
	ldx	allst		;alien pointer
	beq	.exit		;if = 0 :alien nothing

.next	iny
	lda.w	_next,x
	tax
	bne	.next
.exit	tya
	printd	alien
	a8
	ENDC
BugSprEnd
	ENDC
	km_pullallreg
	rtl





;**************************************************************************************
;**************************************************************************************
;**************************************************************************************
;			Not Using Area
;**************************************************************************************
;**************************************************************************************
;**************************************************************************************
;---------------------------------------------------------------------
;---------------------------------------------------------------------

	IFEQ	1
jump_test
	shorta
	longi
	lda	#testmap>>16
	ldx	#testmap&$7fff
	sta	mapbank
	stx	mapptr
	km_clrgameflag		fade1		;[GAME FLAG]
	jmp	main_intro

jump_testgamemode
	shorta
	longi
	jsl	testgamemode_l
	rts

jump_testmissionlevel
	shorta
	longi
	jsl	SelectTestMissionLevel_l
	rts
jump_testlocation
	shorta
	longi
	jsl	testlocation_l
	rts

jump_testplayer
	shorta
	longi
	jsl	SelectTestPlayer_l
	rts
jump_testuser
	shorta
	longi
	jsl	SelectTestMap_l
	jsr	settestmap
	rts

	shorta
	longi
jump_3dglasses
	lda	#st_threedeescr
	sta	screentype
	lda	#stg1map>>16
	ldx	#stg1map&$7fff
	sta	mapbank
	stx	mapptr
	jmp	main_intro

	ENDC
;*********************************************************************
;*								*
;*			BATTLE					*
;*								*
;*********************************************************************
;---------------------------------------------------------------------
;*		GAME igai no syori				*
;---------------------------------------------------------------------
	IFNE	kbattle
jump_selectbattlefield
	shorta
	longi
	km_clrscreenflag	sprwbuf		;SCREEN FLAG
	km_setspritemode	selectbattlefield
	jsl	Selectbattlefield_l
	km_setgamemode	testbattlefield
	rts
	shorta
	longi
jump_selectbattleplayer
	km_clrscreenflag	sprwbuf		;SCREEN FLAG
	jsl	Selectbattleplayer_l
	rts
jump_testbattlefield
	shorta
	longi
	km_clrscreenflag	sprwbuf		;SCREEN FLAG
	jsl	SelectTestBattleMap_l
	km_setgamemode	initbattle
	rts	
;=====================================================================
;*								*
;*		Battle Game Initial Main			*
;*								*
;=====================================================================
	shorta
	longi
jump_initbattle
	lda	#st_twoplayerscr
	sta	screentype

	km_setspritemode	battle		;[SPRITE MODE]
	km_setscreenmode	battle		;[SCREEN MODE]
	a16
	km_setgameflag		battle		;[GAME FLAG]
	km_setscreenflag	sprwbuf		;[SCREEN FLAG]
;;;	km_setgamesyori		main		;[GAME SYORI]
;;;	km_setscreenflag	objcolpal	;[SCREEN FLAG]
	a8
;* wipe init & open *
	km_initwipeopen	battle

;* game round *
	km_setval	kw_gameround,3	;game round init

	a16
	lda	kgamemapptr
	asl	a
	asl	a
	tax
	lda.l	BattleSequence+2,x
	sta	kw_setsndaddr		;Sound Set Address
	a8
	jmp	(BattleSequence,x)	;Jump Sequence

;---------------------------------------------------------------------
;*			Battle Sequence Table			*
;---------------------------------------------------------------------
BattleSequence
	km_gamemode	battlestage1		;
	km_gamemode	battlestage2		;
	km_gamemode	battlestage3		;
	km_gamemode	battlestage4		;
	km_gamemode	battlestage5		;
;---------------------------------------------------------------------
;*			Battle Stage 1				*
;---------------------------------------------------------------------
jump_battlestage1
	shorta
	longi
	lda	#bat1map>>16
	ldx	#bat1map&$7fff
	sta	mapbank
	stx	mapptr
	km_setrdmap	battlestage1
	jmp	main_intro
;---------------------------------------------------------------------
;*			Battle Stage 2				*
;---------------------------------------------------------------------
jump_battlestage2
	shorta
	longi
	lda	#bat2map>>16
	ldx	#bat2map&$7fff
	sta	mapbank
	stx	mapptr
;;;	km_setrdmapptr	battlestage1
	jmp	main_intro
;---------------------------------------------------------------------
;*			Battle Stage 3				*
;---------------------------------------------------------------------
jump_battlestage3
	shorta
	longi
	lda	#bat3map>>16
	ldx	#bat3map&$7fff
	sta	mapbank
	stx	mapptr
;;;;	km_setrdmapptr	battlestage1
	jmp	main_intro
;---------------------------------------------------------------------
;*			Battle Stage 4				*
;---------------------------------------------------------------------
jump_battlestage4
	shorta
	longi
	lda	#bat4map>>16
	ldx	#bat4map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmapptr	battlestage4
	jmp	main_intro
;---------------------------------------------------------------------
;*			Battle Stage 5				*
;---------------------------------------------------------------------
jump_battlestage5
	shorta
	longi
	lda	#bat5map>>16
	ldx	#bat5map&$7fff
	sta	mapbank
	stx	mapptr
	km_setscreenflag	bgcolpal
;	km_setrdmapptr	battlestage5
	jmp	main_intro

	ENDC

;*********************************************************************
;*								*
;*								*
;*			Type Select				*
;*								*
;*********************************************************************
	IFEQ	1
	shorta
	longi
jump_typeselect
	lda	#st_trainingscr
	sta	screentype			;[SCREEN TYPE]
;;;	km_setgamesyori		typesel		;[GAME   SYORI]
	km_setspritemode	typesel		;[SPRITE MODE]
	km_setscreenmode	mission		;[SCREEN MODE]
	a16
	km_clrgameflag		battle		;[GAME   FLAG]
	km_setscreenflag	sprwbuf		;[SCREEN FLAG]
	km_setscreenflag	screenadd	;[SCREEN FLAG]
	km_setscreenflag	halfadd		;[SCREEN FLAG]
;;;;;	km_clrscreenflag	swapbg		;[SCREEN FLAG]
	a8
;* map *
	lda	#tra1map>>16
	ldx	#tra1map&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	trainstage1
	jmp	main_intro
	ENDC

	IFEQ	1
	lda	#st_typeselectscr
	sta	screentype			;SCREEN TYPE
	lda	#typemap>>16
	ldx	#typemap&$7fff
	sta	mapbank
	stx	mapptr
;	km_setrdmap	typeselect
	jsr	camerainit
	jmp	main_intro
	ENDC
;---------------------------------------------------------------------

;=====================================================================
;*
;=====================================================================
	IFEQ	1
debugshape
	php
	a16
	longi
	stz	kz_x1
	stz	kz_z1
;---------------------------------------------------------------------
;* key check *
	km_testkeydown	Right
	beq	.NoRight
	km_setval	kz_x1,8
.NoRight
	km_testkeydown	Left
	beq	.NoLeft
	km_setval.w	kz_x1,-8
.NoLeft
	km_testkeydown	X
	beq	.NoX
	km_setval.w	kz_z1,$10
.NoX
	km_testkeydown	Y
	beq	.NoY
	km_setval.w	kz_z1,-$10
.NoY
;---------------------------------------------------------------------
	ldx	allst		;alien pointer
.NextAlien
	lda.w	al_worldx,x
	clc
	adc	kz_x1
	sta.w	al_worldx,x

	lda.w	al_worldz,x
	clc
	adc	kz_z1
	sta.w	al_worldz,x

	lda.w	_next,x
	tax
	bne	.NextAlien	;If Prog haven't finished Alien List Check

	plp
	rts
	ENDC
	IFEQ	1
;* kettei *
	km_testjoypad	ok
;	beq	.nextcheck
	beq	.exit

	km_settmpgamemode	initmission
	bra	.fadedown

.nextcheck
;* cancell *
	km_testjoypad	B
	km_beq	.exit
	km_settmpgamemode	selectmissionmap

;* fade down *
.fadedown
	km_bitcheckwindowflag	init
	bne	.initSKIP
	km_setwindowflag	init

	km_setwindowflag	fade
	km_soundallstop
	km_initwipeclose	misexp
.initSKIP
	km_decwipetimer
	km_bne	.exit

	ifeq	1
	km_dectimer0	KW_FadeWaitTm
	km_bne	.exit
.fadestart
	lda	fade
	beq	.fadefinished
	km_qfadestepdown
	brl	.exit

.fadefinished
	endc
	ENDC


	IFEQ	1
	km_bitchecwindowflag	init
	bne	.initOK
	km_setwindowflag	init
	km_setval	KW_FadeWaitTm,1
	a8
	km_soundallstop
	a16
.initOK	km_dectimer0	KW_FadeWaitTm
	km_bne	.exit
.fadestart
	km_loblda	fade
	beq	.fadefinished
;* fade tyuu ni 1 line no turatuki ga deru tame *
	a8
;1994/12/14 :1 line black line ni naranai
	km_qfadestepdown
	a16
	bra	.exit
	ENDC

;---------------------------------------------------------------------
;*		Moshi Game wo Clear shitara !!			*
;---------------------------------------------------------------------
	IFEQ	1
	shorta
	km_bitcheckgameflag	score
	km_beq	.player2
	km_clrgameflag	score

	lda	kw_totalscore1+2
	sta	kw_basicscore1+2
	a16
	lda	kw_totalscore1
	sta	kw_basicscore1

;* HP bonus *
	lda	p1_hp	;kx_HP1
	bit	#%11
	beq	.nosyuusei
	clc
	adc	#4
.nosyuusei
	km_shiftrua2
	ldx	#5
	jsr	kmultu8u8
	sta	kz_x1

;* weapon bonus*
	lda	p1_spweap_LMT	;kx_weaponnum1
	ldx	#10
	jsr	kmultu8u8
	sta	kz_x2

;* time bonus *
	ldx	kx_MissionType
	km_loblda.l	timebonustbl,x
	sec
	sbc	kw_GameTimer
	bpl	.skip
	lda	#0
.skip
	ldx	#10
	jsr	kmultu16u8
	sta	kw_timebonus1
;---------------------------------------------------------------------
;* extra bonus *
	lda	kz_x1			;HP bonus
	clc
	adc	kz_x2			;weapon nokori bonus
	clc
	adc	kw_timebonus1		;time bonus
	sta	kw_extrabonus1
;---------------------------------------------------------------------
;* total score *
	lda	kw_totalscore1
	clc
	adc	kw_extrabonus1
	bcc	.nobitup1
	inc	kw_totalscore1+2
.nobitup1
	sta	kw_totalscore1
	sta.w	kscore,y
	a8
	lda	kw_totalscore1+2
	sta.w	kscore+2,y
;---------------------------------------------------------------------
;* Player2 *
.player2
	shorta
	km_plheapptr	2,y
	a16
	lda.w	kscore,y
	sta	kw_basicscore2
	a8
	lda.w	khp,y
	sta	p2_hp	;kx_HP2

	lda.w	exal_spweap_lmt,y
	and	#%00001111
	sta	p2_spweap_LMT	;kx_weaponnum2
;---------------------------------------------------------------------
timebonustbl
	db	6
	db	5
	db	3
	db	3
	db	10
	db	10
	ENDC
