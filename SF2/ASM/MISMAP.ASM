;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         MISMAP.ASM                                          ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  Mission Map Select Main Routine                     ;
; DATE CREATED: 10-3-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
	INCPUB	mismap

;=====================================================================
;*		Label Definition				*
;=====================================================================
mm_sx	=	kz_x1		;2 byte
mm_sy	=	kz_x2		;2 byte
mm_ex	=	kz_y1		;2 byte
mm_ey	=	kz_y2		;2 byte

mm_mx	=	kz_x3		;2 byte
mm_my	=	kz_y3		;2 byte

mm_dx	=	kz_z1		;2 byte
mm_dy	=	kz_z2		;2 byte
mm_dxdy	=	kz_tempaddrl	;2 byte

mm_sp	=	kz_tpa		;2 byte
mm_spx	=	kz_tpx		;2 byte
mm_spy	=	kz_tpy		;2 byte

mm_flag	=	kz_textpt	;2 byte
;---------------------------------------------------------------------
;*********************************************************************
;*								*
;*		Select Mission Map 	[MISSION]		*
;*								*
;*********************************************************************
SelectMissionMap_l
	php
	a8i16
;* Initial *
	jsr	Init_MisMapParams

;* IRQ enable *
	km_IRQenable	mismapirq,226	;[IRQ enable]

;*********************************************************************
;*			 Main Loop				*
;*********************************************************************
	shorta
	longi
	phb
	db7e
;* gameover check *
	km_cmpcheckmismapsyori	corneriafell
	km_beq	.CorneriaFell

.LOOP
;* Game no Syori Frame Initial *
	a16
	km_setmismapstflag	noirqsyori	;[irq syori skip]
	km_clrmismapstflag	finishtrans	;[planet trans enable]
	km_setmismapstflag	gmframesyori	;[1 game fram (8frame) ni 1kai syori]
	a8

;* Syori Over Check *
	ifne	kbugsw
	stz	checkirq
	stz	kw_gameframeptr
	endc
;-------------------------------------------------------------
;* 		GAME FRAME Routine  [ROM Access Enable]	*
;* memo :kokoni program wo okuto Game Frame ni natte shimau	*
;-------------------------------------------------------------
	shorta
	jsr	mm_GameFrameROMRoutine

;-------------------------------------------------------------
;*		Draw Planet	[RAM Parallel]		* 
;-------------------------------------------------------------
	jsr	mm_setmarioparms
	jsl	mm_startmario_l
;* Draw Map Swap *
	swapdrawmap
;-------------------------------------------------------------
;*		Wait Bitmap Data Transfer Wait		*
;-------------------------------------------------------------
;* wait irq *
	a16
.waittrans	;(8 frame wait)
	km_bitcheckmismapstflag	finishtrans
	beq	.waittrans

	ifne	kbugsw
	a8
	km_setvar	checkirq2,checkirq
	a16
	endc

;-------------------------------------------------------------
;*		Jump Sequence				*
;-------------------------------------------------------------
;-------------------------------------------------------------
;94/11/10 :kono flag set wa hazusanaikoto !!!!
; nazenara WIPE Close surutokini IRQ ga kiteshimauto (wipe_l ,find_window_pri_l)
;no syori ga dabute shimau kara !!!

	km_setmismapstflag	noirqsyori	;[irq syori skip]
;-------------------------------------------------------------
	km_nastycheck
;-------------------------------------------------------------
	km_lldaslx	kw_mismapsyori
	a8
	jmp	(.mapsyori,x)
.mapsyori
	dw	.loop&WM		;[main]
	dw	.ExplainFinish&WM	;[explain demo finish]
	dw	.Missionstart&WM	;[mission start]
	dw	.Corneriafell&WM	;[mission game over]
	dw	.SpecialEnemy&WM	;[special enemy appear]
	dw	.PlanetcannonDemo&WM	;[planet cannon demo]


;=============================================================
;*		Planet cannon Demo			*
;=============================================================
	shorta
	longi
.PlanetcannonDemo
	km_settmpgamemode	demo
	km_setdemonumber	planetcannondemo
;* flag *
	km_setmismapflag	returnmap
;* wipe close pos *
	ldy	kx_PlanetcannonListPtr
	lda.w	mmx_planetcannonsx,y
	sta	mmx_wipeposX
	lda.w	mmx_planetcannonsy,y
	sta	mmx_wipeposY
;* BGM *
	brl	.startwipeclose

;=============================================================
;*		Special Enemy Appear			*
;=============================================================
	shorta
	longi
.SpecialEnemy
;* demo sequence *
	km_settmpgamemode	demo
	km_setdemonumber	specialendemo
;* flag *
	km_setmismapflag	returnmap
	km_setmismapflag	spenappear
;* wipe close pos *
	km_setval	mmx_wipeposX,$1d*8
	km_setval	mmx_wipeposY,$04*8
;* BGM *
;;;	kbgm	fadeout
	ksound	en_map_encount2
	brl	.startwipeclose

;=============================================================
;*		Mission Explain Demo Finish		*
;=============================================================
.ExplainFinish
	shorta
	km_settmpgamemode	selectmissionplayer	;[game mode]
	a16
	km_clrmistotalflag	initialmap
	km_clrmistotalflag	explain1
	km_clrmismapfzflag	gamefreeze
;;;	km_clrflag16	kw_mismapfreezeflag,kfz_allfreeze
	a8
	brl	.screenfade

;=============================================================
;*		Corneria Fell				*
;=============================================================
.Corneriafell
	shorta
;'95/8/30 :cursor ga display shite shimau tame !!
;;;;	km_clrmismapfzflag	gamefreeze

	km_setmistotalflag	corneriafell

	km_settmpgamemode	demo
	km_setdemonumber	corneriafelldemo	;[game mode]

	km_setval	mmx_wipeposX,$04*8
	km_setval	mmx_wipeposY,$18*8

	brl	.startwipeclose

;=============================================================
;*		Mission Game Start			*
;=============================================================
.MissionStart
;* Get Mission Type *
	a16
	km_setmismapflag	returnmap
	jsl	init_ealcs_l

	km_bitcheckmistotalflag	finalbossbattle
	bne	.typ_finalboss
	km_bitcheckmismapflag	enemylist
	km_beq	.Typ_Planet

	ldy	kx_SOSEnemyptr	;enemy pointer keep
	km_clrmismapflag	asteroid   ;[MISSION MAP FLAG]
	km_bitcheckflag16.w	mmx_enflags2,enfl2_asteroid,y
	beq	.skip2
	km_setmismapflag	asteroid   ;[MISSION MAP FLAG]
.skip2
	a8
	lda.w	mmx_arwingposx+1
	sta	mmx_wipeposx	;wipe postion CX
	lda.w	mmx_arwingposy+1
	sta	mmx_wipeposy	;wipe postion CY

	a16
	km_bitcheckflag16.w	mmx_enflags,enfl_itemplanet,y
	bne	.typ_itemplanet
	km_bitcheckflag16.w	mmx_enflags,enfl_battleship,y
	bne	.typ_battleship
	km_bitcheckflag16.w	mmx_enflags,enfl_special,y
	km_bne	.typ_special
	brl	.typ_zaco

;---------------------------------------------
;*	Mission Type Syori		*
;* Yreg :Enemy List Pointer(planet wa nashi)	*
;---------------------------------------------
	longa
.typ_itemplanet
	km_setval	currentlevel,itemplanetskill
	km_setval	KGameMapPtr,stg_stg1	;stage pointer
	km_setval	KEnemyNumber,1
	km_setval	kx_missiontype,mistyp_itemplanet
	km_settmpgamemode	initmission	;[game mode]

	ksound	en_map_encount2
	brl	.startwipeclose

	longa
.typ_finalboss
	km_settmpgamemode	initmission	;[game mode]
	km_setmissionflag	finalboss	;[for mission pause screen cancel]
	a8
;;;	kbgm	fadeout
	ksound	en_map_encount2
	brl	.startwipeclose
.typ_planet
	a8
;;;	kbgm	demo2
;;;	kbgm	fadeout
	ksound	en_map_encount2
	km_settmpgamemode	missionexplain	;[game mode]
	jsr	start_misplanet			;[for eguchi's]
	brl	.startwipeclose

.typ_battleship
	longa
	km_setval	kx_missiontype,mistyp_battleship
	lda.w	mmx_enlinkptr,y
	tax
	km_setflag16.w	mmx_planetflag,mmpnf_battleplayer,x

	km_bitcheckflag16.w	mmx_battleshipflag,mmbsf_cannonareain,x
	beq	.no_planetcannon
	a8
	km_setval	eaction2,1
.no_planetcannon
	a8
	km_settmpgamemode	missionexplain	;[game mode]
;	kbgm	demo2
;;;;	kbgm	fadeout
	ksound	en_map_encount2
	bra	.setspace
.typ_special
	longa
	km_setval	kx_missiontype,mistyp_special
	bra	.skipaaa
.typ_zaco
	longa
	km_setval	kx_missiontype,mistyp_sosenemy

	km_bitcheckflag16.w	mmx_enflags,enfl_virus,y
	bne	.virus
	bit	#enfl_wolf
	bne	.skipaaa

;* missile or zaco *
	km_setmismapflag2	rannyuenable
	bra	.skipaaa

;* virus (satellite battle check) *
.virus
	km_bitcheckflag16	kx_satelliteflag,safl_virustorituki
	beq	.skipaaa
	km_setflag16	kx_satelliteflag,safl_satellitebattle
.skipaaa
	a8
	km_settmpgamemode	initmission	;[game mode]
;;;	kbgm	fadeout
	ksound	en_map_encount
.setspace
	shorta
	jsr	start_sosenemy

;* player states (kawagoe's)*
	a16
	km_loblda.w	mmx_arwingposx+1
	sta	p1_worldx_init
	km_loblda.w	mmx_arwingposy+1
	km_nega
	km_loba
	sta	p1_worldz_init
	a8
	lda.w	mmx_arwingangY+1
	sta	p1_roty_init

;* enemy states (eguchi's)*
	a16
	ldy	kx_SOSEnemyptr	;enemy pointer keep
	lda.w	mmx_enposx,y
	km_hibswapa
	sta	e_worldx_init

	lda.w	mmx_enposy,y
	km_hibswapa
	km_nega
	km_loba
	sta	e_worldz_init
	a8
	lda.w	mmx_enangY+1,y
	sta	Kinitroty
;-----------------------------------------------------------------------
;* wipe close *
.startwipeclose
	a8
	kbgm	fadeout
	km_setsndflag	allstop
	km_initwipeclose	mismap
	km_wipefadewait_l
	bra	.init_mem
;-----------------------------------------------------------------------
;* screen fade *
.screenfade
	km_screenfade	60
;-----------------------------------------------------------------------
;* heap ram all free *
.init_mem
	jsl	initmem_l		;[heap RAM free]
;-------------------------------------------------------
;* clear flags *
	a16
	km_setnextgamemode		;[game mode]
	km_setmismapsyori	normal
	km_setval	kx_MotherShipSeq,0

;'95/6/28 :set
	km_clrflag16	kw_gameFlag,(kgf_pausedisable!kgf_keydisable)

	km_clrmismapfzflag	gamefreeze	;[freeze flag]
	km_clrmismapstflag	all 		;[state  flag]
	km_clrmismapchflag	allenable	;[chart  flag]
	km_clrscreenflag	all		;[screen flag]
	km_clrwindowflag	all		;[window flag]
	km_clrscrollflag	all		;[scroll flag]
	km_clrsndflag		allstop 	;[sound  flag]

	km_clrflag16	mmx_arwingflag,mmf_all
	km_clrflag16	mmx_partnerflag,mmf_all
	km_clrflag16	mmx_cursorflag,curf_all
	km_clrflag16	mmx_cursorflag2,curf2_all

;* message ga dete shimau !! *
	km_clrflag16	mmx_mapcursor,%00000001	;(For Message) :yajima !!
;-------------------------------------------------------
	plb
	plp
	rtl


;=====================================================================
;*		Initial Eguchi's Work RAM			*
;* data bank :7e							*
;=====================================================================
init_ealcs_l
	phb
	php
	a8
	db7e
	ai16
	stz	ebyte1
	stz	ebyte3
	stz	ebyte5
	stz	ebyte7
	stz	eword1
	stz	eword2
	stz	switchflags
	stz	RannyuModeSwitch

;* enemy hight *
	jsl	KGetRandomPtr_l
	and	#%1110		;(0,2,4,6,8,10,12,14)	:8 type
	tax
	lda.l	enemy_ehight,x
	sta	ehight

	a8
	stz	eaction1
	stz	etrigger
	plp
	plb
	rtl

;=====================================================================
;*			Mission Planet 	Start			*
;* data bank :7e							*
;=====================================================================
	shorta
	longi
start_misplanet
	ldx	mmx_arwingdestptr
	lda.w	mmx_stage,x
	km_loba
	sta	KGameMapPtr	;stage pointer
	lda.w	mmx_planetskill,x
	sta	currentlevel
	lda.w	mmx_planetswitch,x
	sta	PlanetSwitch

	km_hib0
	ldx	KGameMapPtr
	lda	EEnemyNumPlanet1,x
	bne	.got_params
	lda	KGameMapPtr
	asl	a
	clc
	adc	KGameMapPtr	;*3
	clc
	adc	kdifficulty
	tax
	lda.l	KEnum_tab,x
.got_params
	sta	KEnemyNumber
	sta	CurrentEEnemyNumber
	rts

;=====================================================================
;*		Mission Planet States Save			*
;* data bank :7e							*
;* Xreg :Planet List Pointer (keep)					*
;=====================================================================
return_misplanet
	phx
	php
	a16
	lda	currentlevel
	sta.w	mmx_planetskill,x
	lda	PlanetSwitch
	sta.w	mmx_planetswitch,x
	a8
	ldx	KGameMapPtr
	lda	CurrentEEnemyNumber
	sta	EEnemyNumPlanet1,x
	plp
	plx
	rts	

;=====================================================================
;*			SOS Enemy Start				*
;* data bank :7e							*
;* tmp work :kz_x1,kz_tpx						*
;=====================================================================
	shorta
	longi
start_sosenemy

	ldy	kx_SOSEnemyptr	;enemy pointer keep
	lda.w	mmx_enstage,y
	sta	kgamemapptr	;sos1/sos2/sos3
	lda.w	mmx_enskill,y
	sta	currentlevel	;skill (step)
	lda.w	mmx_enstackptr,y
	sta	kstacknumber

	lda.w	mmx_enwolfnum,y
	sta	starwolfNo	;start wolf team No

	lda	kx_MissionType
	cmp	#mistyp_battleship
	bne	.sosenemy
;----------------------------------------------------------------------
.battleship
	km_setval	kenemynumber,1
	brl	.end
;----------------------------------------------------------------------
.sosenemy
	a16
	ldx	kstacknumber
	txa
	asl	a
	sta	kz_tpx
	a8
	lda	EEnemyNumber_0,x

	IFEQ	1
	bne	.got_params
	a16
	ldx	kz_tpx
	lda	#0
	sta	sebangoSwitch_0,x

	ldx	currentlevel	;skill (step)
	km_bitcheckflag16.w	mmx_enflags,enfl_missile,y
	a8
	bne	.missile

	lda.l	sos1_target,x
	bra	.got_params
.missile
	lda.l	sos2_target,x
.got_params
	ENDC

	sta	CurrentEEnemyNumber
	pha
	and	#%1111
	sta	kz_x1
	pla
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	clc
	adc	kz_x1
	sta	kenemynumber

	a16
	ldx	kz_tpx
	lda	SebangoSwitch_0,x
	sta	CurrentSwitch
	a8
;----------------------------------------------------------------------
.end
	rts

;=====================================================================
;*		SOS Enemy States Save				*
;* data bank :7e							*
;* Xreg :Planet List Pointer (keep)					*
;* Yreg :Enemy  List Pointer (keep)					*
;=====================================================================
return_sosenemy
	phx
	php
	a8
	ldx	kstacknumber
	lda	CurrentEEnemyNumber
	sta	EEnemyNumber_0,x
	a16

;---------------------------------------------------------------------
;Memo   :RannyuModeSwitch
;       :-2 :wolf rannyuu ari   & dead   ,kenemynumber dec wo sareteiru !!
;       :-1 :wolf rannyuu ari   & dead   ,kenemynumber inc no mama
;       : 0 :wolf rannyuu ari   & arrive ,kenemynumber inc no mama
;       : 1 :wolf rannyuu nashi & arrive ,kenemynumber wa kawaranai
;---------------------------------------------------------------------
;(mmtbl.asm :rannyutrig on , RannyuModeSwitch<-- 1 shiteiru)
	km_bitcheckmismapflag2	rannyutrig
	beq	.rannyuu_nashi

	lda	RannyuModeSwitch
	beq	.wolf_arrive	;(0)
	cmp	#1
	beq	.rannyuu_nashi	;(1)
	cmp	#-2
	beq	.rannyuu_nashi	;(-2)
;;;		#-1		;(-1)
.wolf_arrive	;(rannyuu & Wolf Arrive)
	lda	kenemynumber
	dec	a
	sta.w	mmx_enkazu,y
	bra	.skip111
.rannyuu_nashi
	lda	kenemynumber
	sta.w	mmx_enkazu,y
.skip111
;---------------------------------------------------------------------
	LONGA
	txa
	asl	a
	tax
	lda	CurrentSwitch
	sta	SebangoSwitch_0,x
	
	plp
	plx
	rts	

;*********************************************************************
;*								*
;*		Mission CompleteCheck				*
;* Data bank 7e							*
;* Ret :a8i16							*
;*********************************************************************
mm_checkmiscomplete
	a8
	phb
	db7e
	a16
;-------------------------------------------------------------
;*		Mission Complete Check			*
;-------------------------------------------------------------
	LONGA
	km_bitcheckmismapflag	returnmap	;[Init_MisMapParams] de clear
	km_beq	.end
.complete
	km_clrflag16		mmx_cursorflag,(curf_destdisp!curf_readyspup)
	km_clrflag16		mmx_cursorflag2,(curf2_hitplanet!curf2_hitplanettrig!curf2_goplanet)
	km_clrmismapflag	battleplayer	;[player ga mission tyuu no flag]
	km_clrflag16	kw_mismapflag2,(kmimpf2_rannyuenable)

;* Demo Basic States *
	km_stxval	kx_MMPlayerSeq,plseq_wipeopen	;
	km_setval	kx_demoflag,demof_wipeopen	;(For Yajima's)
	km_setmismapflag2	damagedisable

;* sound *
	ifeq	kinagaki
	ksound	map_open_wipe
	endc

;* Enemy List Return *
;'95/9/5 :moshi kono 2 tu no check wo irenaito planet cannon wo utta ato
;mienai tekini utareru !! 
	km_bitcheckmismapflag2	planetcannondemo
	bne	.planetlist
	km_bitcheckmismapflag	spenappear
	bne	.planetlist

	km_bitcheckmismapflag	enemylist
	beq	.planetlist

	ldy	kx_SOSEnemyptr		;enemy List pointer
	lda.w	mmx_ensequence_bak,y
	sta.w	mmx_ensequence,y
	lda.w	mmx_enstratptr_bak,y
	sta.w	mmx_enstratptr,y
.planetlist

;* KANARA ZU  CLEAR !!*
	km_clrmismapflag	enemylist	;'95/9/5
;----------------------------------------------------------
;* Satellite Shot Check *
	km_bitcheckflag	kx_satelliteflag,safl_lockon
	beq	.Skip_LockOn
	lda	kx_satellitetype
	beq	.Skip_LockOn
.AndorossSide
	km_bitcheckflag16	kx_satelliteflag,safl_satellitebattle
	beq	.Skip_LockOn
	km_clrflag16	kx_satelliteflag,safl_satellitebattle

	km_bitcheckmismapflag	missionresult
	beq	.Skip_LockOn	;Mission failed
.Clear_LockOnFlag
	km_clrflag	kx_satelliteflag,safl_lockon
.Skip_LockOn
;----------------------------------------------------------
;* planet cannon demo *
	km_bitcheckmismapflag2	planetcannondemo
	bne	.planetcannondemo
;* special enemy appear *
	km_bitcheckmismapflag	spenappear
	bne	.appear_specialenemy

;* Check Battle Mission Return *
.normal_mission
	km_bitcheckmismapflag	missionresult
	beq	.skip1
	km_clrmismaptrflag	timechartstop	;[stopper kaijyo]
	km_clrmismaptrflag	eventdisable	;[event enable]
.skip1
	ldx	kx_MissionType
	jsr	(.TypeTbl,x)
	km_setvar	mmx_wipeposX,mmx_arwingposx+1	;[wipe center X]
	km_setvar	mmx_wipeposY,mmx_arwingposy+1	;[wipe center Y]
	bra	.end
;-----------
.appear_specialenemy
	km_clrmismapflag	spenappear
	km_setval	mmx_wipeposX,$80
	km_setval	mmx_wipeposY,$60
	km_setval	kx_MMPlayerSeq_next,plseq_tmcharttrig
	bra	.end
;-----------
.planetcannondemo
	km_clrmismapflag2	planetcannondemo
	km_setval	kx_MMPlayerSeq_next,plseq_tmcharttrig
	bra	.end
;-----------
.end
	a8
	plb
	rts

;-----------------------------
;*	Table		*
;-----------------------------
.TypeTbl
	dw	comp_PlanetList&WM		;[planet]
	dw	comp_BattleShip&WM		;[battle ship]
	dw	comp_EnemyList&WM		;[sos enemy]
	dw	comp_SpecialEnemyList&WM	;[taiman kun]
	dw	comp_EnemyList&WM		;[final boss]
	dw	comp_ItemPlanet&WM		;[item planet]
;=====================================================================
;*								*
;*			Mission Planet				*
;*								*
;=====================================================================
;*** Mission ga Planet no baai !! ***
comp_PlanetList
	LONGA
	ldx	mmx_arwingdestptr	;Planet List Pointer
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_battleship,x
	bne	comp_BattleShip

;	km_bitcheckmismapfzflag	misbornfreeze
;	bne	.freeze
	km_clrflag16.w	mmx_planetflag,mmpnf_battleplayer,x
;.freeze

;* Mission Planet Params Save *
	jsr	return_misplanet	;[for eguchi's]

;* Moshi Mission no totyuu de escape shitara !! *
	km_setval	kx_MMPlayerSeq_next,plseq_plareturnmaptrig

	km_bitcheckmismapflag	missionresult
	beq	.skip1
	jsr	clearplanet
	km_setval	kx_MMPlayerSeq_next,plseq_plamiscleardemotrig
.skip1
	rts
;---------------------------------------------------------------------
;*		Mission Planet Clear				*
;---------------------------------------------------------------------
	longa
	longi
clearplanet
	km_setflag16.w	mmx_planetflag,mmpnf_complete,x	;mission planet complete
	km_setval.w	mmx_dokuroanm,0,x		;dokuro animation off

;* moshi battle shiteita planet no missile ga born wait jyoutai dattara !! * 
	lda.w	mmx_psos,x
	beq	.skip1
	km_clrflag16.w	mmx_planetflag,mmpnf_sosappear,x
	lda	#enbase_inittime
	sta.w	mmx_psos,x
.skip1
	lda	#step_Neutral
	sta.w	mmx_planetskill,x	;neutral

	dec	kx_senryoucurrent
	dec	kx_planetkazu
	dec	kx_missiontotal
	inc	kx_planetclearcnt

	jsr	CheckMissionNokori1
	rts
;---------------------------------------------------------------------
;*		Mission ga nokori 1 tu ni nattaka douka Check	*
;---------------------------------------------------------------------
	longa
	longi
CheckMissionNokori1
	lda	kx_missiontotal
	cmp	#1
	bne	.end
	km_setmismapstflag	nokori1
.end
	rts

;=====================================================================
;*								*
;*			Battle Ship				*
;*								*
;=====================================================================
comp_BattleShip
;* Xreg = planet list pointer
;* Yreg = enemy list pointer
;* Moshi Mission no totyuu de escape shitara !! *
	LONGA

	a8
	km_setval	eaction2,0
	a16
	km_clrmismapflag	enemylist	;'95/9/5

	km_bitcheckmismapflag	missionresult
	beq	.battleship_failed
	km_setval	kx_MMPlayerSeq_next,plseq_batmiscleardemotrig
	rts

.battleship_failed
	longa
	ldy	kx_SOSEnemyptr		;enemy List pointer
	lda.w	mmx_enlinkptr,y
	tax
	km_clrflag16.w	mmx_planetflag,mmpnf_battleplayer,x
	km_clrflag16.w	mmx_enflags,(enfl_nocollision),y
	km_setval	kx_MMPlayerSeq_next,plseq_batreturnmaptrig
	rts

;---------------------------------------------------------------------
;*								*
;*		Mission Battle Ship Clear			*
;* Input :Xreg = Planet List Pointer					*
;*       :Yreg = Enemy List Pointer					*			*
;---------------------------------------------------------------------
	longa
	longi
clearbattleship
;* planet cannon cancell *
	cpx	kx_PlanetcannonListPtr
	bne	.NotCharge_cannon
	stz	kx_PlanetcannonPtr
	stz	kx_PlanetcannonListPtr
	km_clrmismapflag	cannonstart
.NotCharge_cannon

	jsr	freeplanetlistptr
	jsr	freeenemylistptr
	dec	kx_battleshipcurrent	;ima deteiru battle ship no kazu
	dec	kx_battleshipkazu
	dec	kx_missiontotal
	inc	kx_battleshipclearcnt

	jsr	CheckMissionNokori1
	rts

;=====================================================================
;*								*
;*			Item Planet				*
;*								*
;=====================================================================
	LONGA
comp_ItemPlanet
	ldy	kx_SOSEnemyptr		;enemy List pointer
	lda.w	mmx_enlinkptr,y
	tax
	km_clrflag16.w	mmx_planetflag,mmpnf_battleplayer,x
	km_clrflag16.w	mmx_enflags,(enfl_nocollision),y

	km_setval	kx_MMPlayerSeq_next,plseq_plareturnmaptrig
	rts
;=====================================================================
;*								*
;*			Zaco Enemy				*
;*								*
;=====================================================================
;**** MIssion ga Enemy no baai !!! ****
	LONGA
	LONGI
comp_SpecialEnemyList
	ldy	kx_SOSEnemyptr		;enemy List pointer
	km_clrflag16.w	mmx_enflags,enfl_attackcorneria,y	;[battle tyuu ni taiman kougeki wo clear surutame !!]
comp_EnemyList
	ldy	kx_SOSEnemyptr		;enemy List pointer
	km_clrflag16.w	mmx_enflags,(enfl_nocollision),y
	jsr	return_sosenemy

	km_bitcheckmismapflag	missionresult
	km_beq	.sosmis_failed
;----------------------------------------------
.sosmis_clear
	km_bitcheckflag16.w	mmx_enflags,enfl_virus,y
	bne	.sos_virus
	bit	#enfl_missile
	bne	.sos_missile
	bit	#enfl_special
	bne	.sos_special
	bit	#enfl_wolf
	bne	.sos_wolf
.sos_zaco
	inc	kx_zacoclearcnt	;(jyokenga mitaseba reset shite shimau)
	inc	kx_zacogekitui	;(reset shinai)
	bra	.sos_common
.sos_missile
	km_clrmismapflag	missilefell	;['95/8/21 :missile ga ochita to douji ni clear shitatoki no tame !!]

	inc	kx_missileclearcnt ;(jyokenga mitaseba reset shite shimau)
	inc	kx_missilegekitui  ;(reset shinai)
	bra	.sos_common
	
.sos_virus
	ldx	kx_FinalBossPlPtr
	stz.w	mmx_psos,x		;Virus Sequence Reset

	lda	kx_satellitetype	;Satellite dakkan Check
	beq	.sos_common		;moshi friend dattra
	km_setflag16.w	kx_satelliteflag,safl_virusgekitui
	bra	.sos_common
.sos_special
	bra	.sos_common
.sos_wolf
	km_bitcheckmismapflag2	wolfboss
	beq	.wolf_kobun
.wolf_boss
	km_setmismapstflag	wolfbossdead
	bra	.sos_common
.wolf_kobun
	ldx.w	mmx_enlinkptr,y
	km_clrflag16.w	mmx_planetflag,mmpnf_wolfprotect,x
.sos_common
	km_clrmismapflag	enemylist
	km_setval	kx_MMPlayerSeq_Next,plseq_sosmiscleardemotrig
	rts
;----------------------------------------------
.sosmis_failed
	km_bitcheckmismapflag	missilefell	;[mission map flag]
	bne	.sosmis_missilefell
	km_bitcheckmismapflag	enemygone	;[mission map flag]
	beq	.sosmis_returnmap
;--------------------------
.sosmis_enemygone
	km_clrmismapflag	enemygone	;[mission map flag]
	km_setval	mmw_wolfgonetrig,1
	km_setval	kx_MMPlayerSeq_next,plseq_sosgonedemotrig

;* postion syuusei *
	lda.w	mmx_enposx,y
	sta	mmx_arwingposx
	lda.w	mmx_enposy,y
	sta	mmx_arwingposy
	rts
;--------------------------
.sosmis_missilefell
	km_clrflag16	kw_mismapflag,(kmimpf_enemygone!kmimpf_missilefell)	;[mission map flag]
	km_setval	kx_MMPlayerSeq_next,plseq_missilefelltrig
	rts
;--------------------------
.sosmis_returnmap
	km_bitcheckmismapflag2	wolfboss
	bne	.sosmis_partnercontinue_wolfboss
	km_setval	kx_MMPlayerSeq_next,plseq_sosreturnmaptrig
	rts
;--------------------------
.sosmis_partnercontinue_wolfboss
	km_setval	kx_MMPlayerSeq_next,plseq_ptcont_wolfboss
	rts
;----------------------------------------------

;*********************************************************************
;*								*
;* 		Every FRAME Routine  [ROM Access Enable]	*
;* Call From IRQ.ASM	:1frame						*
;* Data bank 7e							*
;*********************************************************************
mm_ROMRoutine_l
	php
	a8
	phb
	db7e
;---------------------------------------------------------------------
	a16
	lda	kw_gameframeptr
	inc	a
	inc	a
	and	#$f
	sta	kw_gameframeptr

	jsr	mm_romroutinecommon	

	ldx	kw_gameframeptr
	jsr	(mm_romsyoritbl,x)
;---------------------------------------------------------------------
	plb
	plp
	rtl

	longa
	longi
mm_romroutinecommon
	km_bitcheckflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_corneriafell)
	bne	.End

	jsr	mm_maincheck

	km_bitcheckmismapdemoflag	all
	beq	.nodemo
	jsr	mm_sosdemosequence
.nodemo

	jsr	mm_objdemochart
	jsr	SelectWarpPlace
.End
	rts

mm_romsyoritbl
	dw	mm_romroutine0&WM
	dw	mm_romroutine1&WM
	dw	mm_romroutine2&WM
	dw	mm_romroutine3&WM
	dw	mm_romroutine4&WM
	dw	mm_romroutine5&WM
	dw	mm_romroutine6&WM
	dw	mm_romroutine7&WM

mm_romroutine0
mm_romroutine1
mm_romroutine2
mm_romroutine3
mm_romroutine4
mm_romroutine5
mm_romroutine6
mm_romroutine7
	rts

;*********************************************************************
;*								*
;*			Select Main Check			*
;* data bank :7e							*
;*********************************************************************
	LONGA
	LONGI
mm_maincheck
;---------------------------------------------
;*	Itumo ugoku routine	  	*
;---------------------------------------------
;* Key Enable Check *
;* Bug Mode Check *
	jsr	mm_bugcheck
;* Button Check *
	jsr	mm_pausecheck	;{Game Frame Syori}
.SkipKeyCheck1

;---------------------------------------------
;*		Cursor			*
;---------------------------------------------
;*** flag clear ****
	LONGA
;'94/10/12 :kono basyo ga good !! (for yajima) :Pause notoki wa val keep
	km_clrflag16	mmx_mapcursor,%00000001	;(For Message)

	km_bitcheckflag16	mmx_cursorflag,curf_demo
	bne	.demo_cursor
	bit	#curf_warpselect
	bne	.skip_cursor

	km_bitcheckmismapfzflag	cursorfreeze
	bne	.skip_cursor
;* cursor *
	LONGA
	km_clrflag16	mmx_cursorflag,(curf_pushA!curf_samearwing)
	km_clrflag16	mmx_cursorflag2,(curf2_hitplanet)
	jsr	mm_movecursor		;[move cursor]
	jsr	mm_CollisionCursor	;[collision check]
	bra	.skip_cursor
;;;.warp_cursor
;;;	jsr	SelectWarpPlace
;;;	bra	.skip_cursor

.demo_cursor
	LONGA
	jsr	mm_demomovecursor	;[move cursor]
.skip_cursor

;---------------------------------------------
;*	Check Button			*
;---------------------------------------------
;* Normal button Check*
;cursor check no ushironi oku 
;nazenara planet hit check wo maeni shinaito arwing ga okashina tokoroni tobu !!
	LONGA
	jsr	mm_checkbutton

;---------------------------------------------
;*	Game Timer			*
;---------------------------------------------
	LONGA
	jsr	mm_gametotaltm

;---------------------------------------------
;*	Player Stratage			*
;---------------------------------------------
.playerstratage
	longa
	km_bitcheckmismapfzflag	playerfreeze
	bne	.skip_move
;* main arwing *
	km_bitcheckflag16	mmx_arwingflag,mmf_demo
	bne	.skip_move
	LONGA
	jsr	mm_checkplayerdestpos	;[player dest postion check]
	jsr	mm_calcplayerangle	;[player angle]
	jsr	mm_calcplayercgxptr	;[player cgx ptr]
	jsr	mm_moveplayer		;[player move]
.skip_move
;* partner arwing *
	LONGA
	km_bitcheckmistotalflag	partner1
	bne	.skip_movepartner	;moshi partner continue shite itara SKIP !!

	km_bitcheckflag16	mmx_partnerflag,mmf_demo
	bne	.skip_movepartner
	jsr	mm_calcpartnercgxptr	;[player cgx ptr]
	jsr	mm_MovePartner
.skip_movepartner
;---------------------------------------------
;*	Dsiplay Routine			*
;---------------------------------------------
;* Set Sound *
.Sound
	a8
	jsr	mm_soundBGM
;---------------------------------------------
;*	     End			*
;---------------------------------------------
.end
	a16
	km_bitcheckmismapstflag	gmframesyori
	beq	.noclearflag
	km_clrgmjoypad
	km_clrgmkeydown
	km_clrmismapstflag	gmframesyori
	km_clrflag16	mmx_cursorflag,curf_gospup
.noclearflag
;---------------------------------------------
	rts

;=====================================================================
;*								*
;*			Mission Map Sound			*
;* kw_mmBGM [0.. normal,1.. attention,2.. danger]			*
;=====================================================================
mm_soundBGM
	php
	a16
	longi
;* Select BGM & Corneria Flashing *
	ldx	kx_CorneriaHP
	lda	kw_mmBGMPtr
	beq	.AttentionCheck
	dec	a
	beq	.DangerCheck
	bra	.NoTChangeBGM
;--------------------------------------------------
.AttentionCheck
	cpx	#corneriaAttentionHP+1
	bcs	.NotChangeBGM
.Attention
	inc	kw_mmBGMPtr
	lda	#kbgm_attention	;[BGM Type]
	bra	.SetBGM
;--------------------------------------------------
.DangerCheck

	cpx	#corneriaDangerHP+1
	bcs	.NotChangeBGM
.Danger
	km_setval	coltimer_3,4		;bg color flash timer
	km_setval	coltimermax_3,4		;bg color flash timer

	inc	kw_mmBGMPtr
	lda	#kbgm_danger	;[BGM Type]
;--------------------------------------------------
.SetBGM
	a8
	sta	kw_mmBGM	;BGM Set (0,1,2)
	KBGM_a
	a16
.NoTChangeBGM
;------------------------------------------------------------------------
;Arwing Boost
	LONGA
	km_bitcheckflag16	mmx_arwingflag,mmf_go
	beq	.stop

	km_bitcheckflag16	mmx_cursorflag,curf_gospup
	bne	.speedup
	lda	#sport1_eng
	bra	.ArwingSndEnd
.speedup
	lda	#sport1_boost
	bra	.ArwingSndEnd
.stop
	lda	#sport1_stop
.ArwingSndEnd
	a8
	km_setsoundport1

;************* Trigger Sound *************
	a16
	ldx	#0
	km_bitcheckflag16	kw_mmsoundflag,mmsndf_all
	beq	.end
.loop
	lsr	a
	bcs	.found
	beq	.end
	inx
	bra	.loop
.found
	lda.l	mm_soundtable,x
	ksound_A
.end
	km_clrflag16	kw_mmsoundflag,mmsndf_all

;---------------------------------------------------------------------
;*		Planet cannon Charge Sound			*
;---------------------------------------------------------------------
	longa
	longi
.pcchargesound
	km_bitchecksndflag	cannoncharge
	beq	.pc_nosound

	lda	pc_sndtm
	beq	.check_pcsnd
	dec	a
	sta	pc_sndtm
	bne	.pc_nosound

.check_pcsnd

	ldx	#0
.pc_loop
	lda	kx_PlanetcannonTmPri
	bmi	.soon
	cmp.l	.soundtbl,x
	bcs	.pc_setsound

	inx
	inx
	inx
	inx
	bra	.pc_loop
.soon
	ldx	#$14
.pc_setsound
	km_loblda.l	.soundtbl+2,x
	sta	pc_sndtm

	km_loblda.l	.soundtbl+3,x
	ksound_a
.pc_nosound
;---------------------------------------------------------------------
	plp
	rts

;---------------------------------------------------------------------
.soundtbl
;(1)
	dw	9*60
	db	$14
	db	sport3_map_laser_charge1

;(2)
	dw	7*60
	db	$10
	db	sport3_map_laser_charge1

;(3)
	dw	4*60
	db	$0d
	db	sport3_map_laser_charge1
;(4)
	dw	2*60
	db	$0a
	db	sport3_map_laser_charge2
;(5)
	dw	1*60
	db	$08
	db	sport3_map_laser_charge2
;(6)
	dw	0*60
	db	$06
	db	sport3_map_laser_charge3

;=====================================================================
;*								*
;*			Check Button & Key			*
;*								*
;=====================================================================
mm_checkbutton
	php
	a16
 	longi

	km_bitcheckgameflag	keydisable
	km_bne	.End

;---------------------------------------------------------------------
;* cancel ready speed up *
;'95/8/28 :cursor wo ugokashi nagara kettei button 
;         :wo oshitemo kettei dekinai bug taisaku !!

	km_testkeydown	UDLR
;;;	km_testjoypad	UDLR
	beq	.CancelReadySpeedUp
	km_clrflag16	mmx_cursorflag,curf_readyspup
.CancelReadySpeedUp
;---------------------------------------------------------------------
;* arwing ga cursor postion to onaji dattra !! *
	a8
	lda	mmx_curposx
	cmp	mmx_arwingposx+1
	bne	.CheckArwingMove
	lda	mmx_curposy
	cmp	mmx_arwingposy+1
	bne	.CheckArwingMove
.SamePostion
	a16
	km_setflag16	mmx_cursorflag,curf_samearwing
.CheckArwingMove
;---------------------------------------------------------------------
	a16
	km_bitcheckmismapfzflag	ketteifreeze
	km_bne	.end

;* ketei button check *
;('95/6/6)
;	km_testkeydown	kettei
;	km_beq	.NoPushOK

;* ketei button check (trigger) *
	km_testjoypad	kettei
	beq	.SpeedUpTimerCheck	;No Push

;* moshi cursor to arwing ga onaji zahyou ni itara !! *
;* tadashi planet or enemy ni Cursor ga Hit shiteirutoki wo nozopku !!)
	km_bitcheckflag16	mmx_cursorflag2,(curf2_hitplanet!curf2_hitenemy)
         	bne	.SkipA
	km_bitcheckflag16	mmx_cursorflag,curf_samearwing
         	bne	.SpeedUp
.SkipA
	km_clrflag16	kw_MisMapFreezeFlag,(kfz_timefreeze!kfz_enemyfreeze!kfz_pausefreeze)

	km_bitcheckflag16	mmx_cursorflag,curf_readyspup
	bne	.Force_Timer0
	km_clrflag16	mmx_arwingflag,(mmf_arvx!mmf_arvy!mmf_boostsnd)
	km_setflag16	mmx_arwingflag,(mmf_initmove!mmf_go)
	km_setflag16	mmx_cursorflag,(curf_destdisp!curf_pushA!curf_readyspup)
	km_setval	mmx_curwaittm,15

	km_setvar	kx_currentplanetptr,kx_tmpplanetptr

	ksound	map_place_set

	km_bitcheckflag16	mmx_cursorflag,curf_fzcancel
	beq	.nofreeze
	km_clrflag16	mmx_cursorflag,curf_fzcancel
	STZ	kx_playerdemowait
.nofreeze
	bra	.SpeedUpTimerCheck	
;-----------------------------------------------------------------------
.Force_Timer0
	km_setval	mmx_curwaittm,0
;-----------------------------------------------------------------------
.SpeedUpTimerCheck
;('95/6/6)
;	bra	.NoPushOK

	IFEQ	1
	lda	mmx_curwaittm
	beq	.SpeedUp
	dec	a
	sta	mmx_curwaittm
	bne	.NoPushOK
	ENDC
;-----------------------------------------------------------------------
.SpeedUp
;('95/6/6)
	IFEQ	1
	km_setflag16	mmx_cursorflag,curf_gospup
	km_bitcheckflag16	mmx_arwingflag,mmf_boostsnd
	bne	.nosnd_boost
	km_bitcheckflag16	mmx_arwingflag,mmf_go
	beq	.nosnd_boost

	km_setflag16	mmx_arwingflag,mmf_boostsnd
	ksound	boost
.nosnd_boost
	ENDC
;-----------------------------------------------------------------------
.NoPushOK
;* arwing stop *
	km_testjoypad	Cancel
	beq	.NotCancelCheck

;	km_bitcheckflag16	mmx_cursorflag,curf_destdisp
;	beq	.NotCancel

	km_bitcheckflag16	kw_MisMapFreezeFlag,(kfz_timefreeze)
	bne	.NotCancelCheck

	jsr	KTimeStop
	ksound	cancel
.NotCancelCheck
;------------------------------------------------------------
	km_testjoypad	TLeft
	beq	.NoPushTleft
.NoPushTleft
;---------------------------------------------------------------------
	ifne	kspeedup
	km_clrmismapstflag	speedup
	km_testkeydown2	speedup
	beq	.NoPushSelect
	km_setmismapstflag	speedup
.NoPushSelect
	endc
;---------------------------------------------------------------------
.CheckSpeedUp
	km_bitcheckmismapstflag	gmframesyori
	beq	.Skip_SpeedUp

	km_bitcheckflag16	mmx_cursorflag,curf_gospup
	beq	.NormalSpeed

;95/2/21
	km_setmismapstflag	arwingspup
;	km_setmismapstflag	speedup
;	km_setval	mmw_speedup,8
	bra	.Skip_SpeedUp
.NormalSpeed
	km_clrmismapstflag	arwingspup
;	km_clrmismapstflag	speedup
;	km_setval	mmw_speedup,1
.Skip_SpeedUp
;---------------------------------------------------------------------
.end
	plp
	rts

;---------------------------------------------------------------------
;*			Player & Time Stop			*
;---------------------------------------------------------------------
	longa
	longi
KTimeStop
	km_setflag16	kw_MisMapFreezeFlag,(kfz_timefreeze!kfz_enemyfreeze!kfz_pausefreeze)
;* sound *
;	kbgm	muteon
KPlayerStop
	km_clrflag16	mmx_arwingflag,mmf_go!mmf_initmove
	km_clrflag16	mmx_cursorflag,(curf_destdisp!curf_readyspup)
	km_clrflag16	mmx_cursorflag2,(curf2_goplanet!curf2_gomothership)
	rts

;=====================================================================
;*								*
;*	Mission Map Demo Scroll (StepUp Go !!)			*
;*								*
;=====================================================================
	LONGA
	LONGI
mm_pausecheck
	km_bitcheckmistotalflag	explain1
	beq	.Normal
;---------------------------------------------------------------------
;* explain demo totyuu cancel check *
.Explain_Demo
	km_bitcheckmismapfzflag	pausefreeze	;renda shitatokini bugru taisaku!!
	bne	.end	;(mission map explain demo hityuyou :renda taisaku !!)

	km_bitcheckmismapfzflag	expcancelfreeze
	bne	.End
	km_testjoypad	start
	beq	.End
	ksound	demo_cancel	;next_message
	km_setval	kx_MisMapSeq,mmseq_explainfinish
.end
	rts
;---------------------------------------------------------------------
.Normal
	ldx	kx_PartnerChangeSeq
	jmp	(.PartnerChange,x)

.PartnerChange
	dw	ptch_keycheck&WM
	dw	ptch_changedemowait&WM
	dw	ptch_swapplayer&WM

;---------------------------------------------------------------------
;*			Chart Sequence				*
;---------------------------------------------------------------------
	LONGA
	LONGI
ptch_nextchart
	inc	kx_PartnerChangeSeq
	inc	kx_PartnerChangeSeq
	rts
;---------------------------------------------------------------------
	LONGA
	LONGI
ptch_keycheck
	km_bitcheckmismapfzflag	ketteifreeze
	bne	.End
	km_testjoypad	select
	beq	.end

	km_bitcheckmistotalflag	partner1	;p1dead
	bne	.end	;No Partner
.trigger
	jsr	KTimeStop
	km_setgameflag	keydisable
	km_setval	kx_objdemonumber,odm_partnerchange
	ksound	viewchange
	bra	ptch_nextchart
.end
	rts
;---------------------------------------------------------------------
ptch_changedemowait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
;---------------------------------------------------------------------
	LONGA
	LONGI
ptch_swapplayer
	stz	kx_PartnerChangeSeq

	jsl	kplswap_l		;(for kawaguchi)
	jsl	PlayerStatus_Swap_l	;(for kawagoe)

	km_clrgameflag	keydisable
	rts


;=====================================================================
;*		Player Status Swapping				*
;* Input :data bank 7e						*
;=====================================================================
kplswap_l
	php
	ai8
	ldx	kx_p1_pilotNo
	lda	kx_p2_pilotNo
	stx	kx_p2_pilotNo
	sta	kx_p1_pilotNo

	ai16
	ldx	kx_p1_TypePtr
	lda	kx_p2_TypePtr
	sta	kx_p1_TypePtr
	stx	kx_p2_TypePtr


	ldx	mm_arwingcgxptr1
	ldy	mm_arwingcgxptr2
	lda	mm_arwingcgxptr1_pt
	sta	mm_arwingcgxptr1
	lda	mm_arwingcgxptr2_pt
	sta	mm_arwingcgxptr2
	stx	mm_arwingcgxptr1_pt
	stx	mm_arwingcgxptr2_pt

	plp
	rtl
;=====================================================================
;*								*
;*		Debug Key Command		[DebugMode]	*
;*								*
;=====================================================================
;(joy pad 1)
pad_CorneriaHP1	equ	pad_Tleft!pad_Tright!pad_A
padl_CorneriaHP1	equ	padl_Tleft!padl_Tright!padl_A
pad_CorneriaHP0	equ	pad_Tleft!pad_Tright!pad_X
padl_CorneriaHP0	equ	padl_Tleft!padl_Tright!padl_X
pad_FinalBoss	equ	pad_Tleft!pad_Tright!pad_Y
padl_FinalBoss	equ	padl_Tleft!padl_Tright!padl_Y
pad_SpecialEnemy	equ	pad_Tleft!pad_Tright!pad_B
padl_SpecialEnemy	equ	padl_Tleft!padl_Tright!padl_B
pad_MisBornFreeze	equ	pad_Tright!pad_A
padl_MisBornFreeze	equ	padl_Tright!padl_A

;(joy pad 2)
pad_ZacoKill		equ	pad_A
padl_ZacoKill	equ	padl_A
pad_MissileKill	equ	pad_Y
padl_MissileKill	equ	padl_Y
pad_BattleShipKill	equ	pad_B
padl_BattleShipKill	equ	padl_B
pad_PlanetKill	equ	pad_X
padl_PlanetKill	equ	padl_X
pad_AllKill		equ	pad_Tright!pad_Tleft
padl_AllKill		equ	padl_Tright!pad_Tleft

pad_TameOK		equ	pad_TRight
padl_TameOK		equ	padl_TRight

pad_TmChartSkip	equ	pad_Select
padl_TmChartSkip	equ	padl_Select

pad_MissileBorn	equ	pad_TLeft
padl_MissileBorn	equ	padl_TLeft

pad_SpeedUp		equ	pad_Start
padl_SpeedUp		equ	padl_Start
;---------------------------------------------------------------------
	longa
	longi
mm_bugcheck
	ifne	kbugsw

	km_bitcheckgameflag	keydisable
	km_bne	.end
	km_bitcheckmismapflag2	debugenable
	km_beq	.end
;---------------------------------------------------------------------
;* Corneria Hit Point <-- 0 *
.check1
	km_acmpkeydown	CorneriaHP1
	bne	.check2
	km_setval	kx_corneriaHP,1
	km_setval	kx_corneriaDamage,99
	km_setmismapstflag	corneriadamage
;---------------------------------------------------------------------
.check2
	km_acmpkeydown	CorneriaHP0
	bne	.check3
	km_setval	kx_corneriaHP,0
	km_setval	kx_corneriaDamage,100
	km_setmissionsyori	corneriafell
	km_setval	kx_CorneriaFellSeq,cfseq_felltrig
	km_setmismapstflag	corneriadamage
;---------------------------------------------------------------------
.CHECK3
	IFEQ	1
	km_testkeydown	select
	beq	.check4
	km_bitcheckflag16	mmx_cursorflag,curf_hitplanet
	beq	.check4

	ldy	kx_tmpplanetptr	;Planet List Pointer
	km_testjoypad	Tright
	beq	.skip3_1
	a8
	lda.w	mmx_planetskill,y
	inc	a
	sta.w	mmx_planetskill,y
	a16
	bra	.skip3_end
.skip3_1
	km_testjoypad	Tleft
	beq	.skip3_end
	a8
	lda.w	mmx_planetskill,y
	dec	a
	a16
	sta.w	mmx_planetskill,y
.skip3_end
	ENDC
;---------------------------------------------------------------------
.CHECK4
	IFEQ	1
	km_testkeydown	select
	beq	.check5
	km_bitcheckflag16	mmx_cursorflag2,curf2_hitenemy
	beq	.check5
	ldy	kx_enarrivetmptr
	km_testjoypad	Tright
	beq	.skip4_1
	a8
	lda.w	mmx_enskill,y
	inc	a
	sta.w	mmx_enskill,y
	a16
	bra	.skip4_end
.skip4_1
	km_testjoypad	Tleft
	beq	.skip4_end
	a8
	lda.w	mmx_enskill,y
	dec	a
	sta.w	mmx_enskill,y
	a16
.skip4_end
	ENDC
;---------------------------------------------------------------------
.check5
	km_acmpkeydown	FinalBoss	;pad_Tleft!pad_Tright!pad_Y
	bne	.check6

	jsr	mm_enemyallkill
	km_setmismapchflag	fbchartenable
	km_setmistotalflag	finalbossbattle	;[missiontotal flag]
	km_setval	kx_FinalBossSeq,fbseq_finalbosstrig
;---------------------------------------------------------------------
.check6
	km_testjoypad2	ZacoKill
	beq	.check6_a
	km_setval	kx_FinalBossSeq,fbseq_zacoenemykill
.check6_a
	km_testjoypad2	MissileKill
	beq	.check6_aa
	km_setval	kx_FinalBossSeq,fbseq_missilekill
.check6_aa
	km_testjoypad2	PlanetKill
	beq	.check6_b
	km_setval	kx_FinalBossSeq,fbseq_planetkill
.check6_b
	km_testjoypad2	BattleshipKill
	beq	.check6_c
	km_setval	kx_FinalBossSeq,fbseq_battleshipkill
.check6_c
	km_acmpjoypad2	AllKill
	bne	.check6_d
	km_setval	kx_FinalBossSeq,fbseq_allenemykill
.check6_d
;---------------------------------------------------------------------
.check7
	km_acmpkeydown	SpecialEnemy		;pad_Tleft!pad_Tright!pad_B
	bne	.check8
	km_setval	kx_MisMapSeq,mmseq_capture2_2
.check8
;---------------------------------------------------------------------
	km_acmpkeydown	MisBornFreeze		;pad_Tleft!pad_Tright!pad_B
	bne	.check9
	km_setmismapevflag	misbornfreeze
.check9
;---------------------------------------------------------------------
	IFEQ	1
	km_testjoypad	Tleft
	beq	.check10a
	km_setflag16	map_trigmessage,ymes_planetcannonarea
.check10a
	km_testjoypad	TRight
	beq	.check10b
	km_setflag16	map_trigmessage,ymes_planetcannonfire
.check10b
	km_testjoypad	Select
	beq	.check10c
	km_setflag16	mmx_message_sos,mesosfl_virustorituki	;[for yajima's]
.check10c
	ENDC
;---------------------------------------------------------------------
	IFEQ	1
	km_testjoypad	select
	beq	.check11
	km_setval	kx_AttackPoint,10
.check11
	ENDC
;---------------------------------------------------------------------
	IFEQ	0
	km_testjoypad2	TameOK
	beq	.check12
	ldy	kx_satelliteenptr
	km_setval.w	mmx_enwaittm,1,y
.check12
	ENDC
;---------------------------------------------------------------------
	IFEQ	1
	longa
	longi

	km_testjoypad2	MissileBorn
	beq	.check13

	ldx	kx_planetlistptr
	beq	.check13
.loop13
 	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,x
	beq	.next13

	lda	#1
	sta.w	mmx_soswaittm,x
.next13
	lda.w	mmx_planetnext,x
	tax
	bne	.loop13

.check13
	ENDC
;---------------------------------------------------------------------
.end
	endc
	rts

;=====================================================================
;*								*
;*			Total Game Timer			*
;* Data Bank :7e							*
;=====================================================================
	longa
	longi
mm_gametotaltm
	km_clrmismapstflag	hourpast	;1 hour past flag

	km_bitcheckmismapfzflag	timefreeze
	bne	.end

;**** Sub Timer Count Up ****
	lda	#1
	jsl	kspeedupA_l
	clc
	adc	kx_TotalSubTime
	sta	kx_TotalSubTime

;* Main Timer Check *
	lda	kx_TotalSubTime
	cmp	#mapgftm	;60
	bmi	.notTimeChange
	sec
	sbc	#mapgftm	;60
	sta	kx_TotalSubTime
	km_setmismapstflag	hourpast	;1 hour past flag

	lda	kx_TOTALTIME
	cmp	#gametimemax_map
	bcc 	.AddTime

	lda	#(gametimemax_map-1)
.AddTime
	inc	a
	sta	kx_TOTALTIME
.notTimeChange
.end
	rts
;*********************************************************************
;*								*
;* 		GAME FRAME Routine  [ROM Access Enable]		*
;* Game Frame 1 Cycle						*
;* Data bank 7e							*
;*********************************************************************
	shorta
	longi
mm_GameFrameROMRoutine
;******* Debug mode *******
;* force soft ware reset *
	km_Debug_reset
;-------------------------------------------------------------
;*		Window Timer Check			*
;-------------------------------------------------------------
	ldx	kw_wipetimer
	beq	.DoGameFrameSyori
	dex
	stx	kw_wipetimer
	bne	.end
.Enable
	a16
;;;	km_clrgameflag		keydisable
	km_clrwindowflag	wipeopen
	a8
;-------------------------------------------------------------
;*		Mission Map Main Chart			*
;-------------------------------------------------------------
.DoGameFrameSyori
	ai16
	jsr	mm_corneriafellchart

	km_bitcheckflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_corneriafell)
	bne	.fell_skip

	jsr	mm_playerdemochart

	km_bitcheckmismapflag2	warpwait	;(moshi warp tyuu dattara Skip)
	bne	.warp_skip

	jsr	mm_planetcannonchart
	jsr	mm_satellitebeemchart

	jsr	mm_finalbosschart
	jsr	mm_mismapchart
	jsr	mm_missileallchart
	jsr	mm_bstotugekichart
.warp_skip
	jsr	mm_mothershipchart
.fell_skip

;* Game Frame flag clear *
	km_clrflag16	mmx_arwingflag,mmf_arrive

;-------------------------------------------------------------
;*			END				*
;-------------------------------------------------------------
.end
	a8
	rts

;*********************************************************************
;*								*
;*			MotherShipChart		[Game Frame]	*
;* Data bank 7e							*
;* Ret :ai16								*
;*********************************************************************
	longa
	longi
mm_mothershipchart
	ldx	kx_MotherShipSeq
	jsr	(.MotherShipTbl,x)
.End
	rts
.MotherShipTbl
	dw	mother_nothing&WM
	dw	mother_arrivetrig&WM
	dw	mother_partnerwait&WM
	dw	mother_messagewait&WM
	dw	mother_keycheck&WM
	dw	mother_planetseltrig&WM
	dw	mother_planetselect&WM
	dw	mother_warptrig&WM
	dw	mother_warpwait&WM
	dw	mother_warpcancelwait&WM
;-------------------------------------------------------------------------
	longa
	longi
mother_nothing
	rts
;-------------------------------------------------------------------------
	longa
	longi
mother_arrivetrig
	IFEQ	1
	km_bitcheckmismapfzflag	ketteifreeze
	beq	.Nocheck
	km_testjyopad	OK
	bne	.ReWarp
	rts
.ReWarp
	brl	mother_next
.Nocheck
	km_setval	kx_MotherShipSeq,motherseq_nothing
	rts
	ENDC
;-------------------------------------------------------------------------
mother_partnerwait
	km_bitcheckflag16	 mmx_partnerflag,mmf_go
	beq	.trigger
	rts
.trigger
	km_setmismapfzflag	gamefreeze
	km_setflag16.w	mmx_arwingflag,mmf_notdisplay
	Mstart_demomapmessage	105
	km_setval	kx_mshipwaittm,4

;	kbgm	muteon
	ksound	kettei
	brl	mother_next
;-------------------------------------------------------------------------
	longa
	longi
mother_messagewait
	dec	kx_mshipwaittm
	beq	.finish
	rts
.finish
	km_setval	mmx_warpselect,0
	km_setval	mmx_warpseltrig,1
	brl	mother_next
;-------------------------------------------------------------------------
	longa
	longi
mother_keycheck
	km_testgmjoypad	Kettei
	bne	.Bpush
	km_testgmjoypad	X
	bne	.Xpush
	km_testgmjoypad	UP
	bne	.UP
	km_testgmjoypad	Down
	bne	.Down
	rts
.UP
	lda	mmx_warpselect
	dec	a
	bra	.CommonLR
.Down
	lda	mmx_warpselect
	inc	a
.CommonLR
	and	#1
	sta	mmx_warpselect
	ksound	cursor
	rts

.Bpush	;(Warp Planet Select)
	lda	mmx_warpselect
	bne	.Xpush
	Mnext_demomapmessage	106
	ksound	kettei
	km_setval	mmx_warpseltrig,0
	brl	mother_next

.Xpush	;(Warp Cancell)
	km_setval	mmx_warpseltrig,0
	brl	mother_cancel
;-------------------------------------------------------------------------
	longa
	longi
mother_planetseltrig
	km_setflag16	mmx_cursorflag,curf_warpselect
	jsr	CheckWarpPlace
	jsr	SetWarpCursorParams

	km_setvar	kx_mshipcurrentnum,mmx_planetname
	km_setvar	kx_planetbufnum_bak,kx_planetbufnum
	brl	mother_next
;-------------------------------------------------------------------------
	longa
	longi
mother_planetselect
	km_bitcheckflag16	mmx_cursorflag,curf_warpselect
	beq	.finish	
	rts
.finish
	bit	#curf_warpcancel
	bne	mother_cancel
	km_setvar	kx_mshipcurrentnum,mmx_planetname
	brl	mother_next
;-------------------------------------------------------------------------
	longa
	longi
mother_warptrig
	km_setval	kx_objdemonumber,odm_normalwarp
	brl	mother_next
;-------------------------------------------------------------------------
	longa
	longi
mother_warpwait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	IFEQ	1	
	a8
	lda	kx_mshipx
	sta	mmx_arwingposx+1
	sta	mmx_partnerposx+1

	lda	kx_mshipy
	sta	mmx_arwingposy+1
	sta	mmx_partnerposy+1
	a16
	ENDC

	km_clrflag16.w	mmx_enflags,enfl_demo,y
	bra	mother_common

;-------------------------------------------------------------------------
	longa
	longi
mother_cancel
	ksound	cancel
	km_setval	kx_objdemonumber,odm_warpcancel
	km_setval	kx_MotherShipSeq,motherseq_warpcancelwait
;-------------------------------------------------------------------------
	longa
	longi
mother_warpcancelwait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
;-------------------------------------------------------------------------
mother_common
	a8
	km_setvar	p1_hp,p1_maxHP
	km_setvar	p2_hp,p2_maxHP
	a16
	km_clrflag16	mmx_cursorflag2,curf2_hitplanet	;{clear shite okanito dame !!)

	km_stxval	kx_MMPlayerSeq,plseq_cursortrig
	km_clrflag16	mmx_cursorflag,curf_warpcancel
;;	km_clrmismapdemoflag	warpdemo	;cursor (pldemo_cursorwait) hokano event ga kakaranaiyouni surutame !!
	km_setval	kx_MotherShipSeq,motherseq_nothing
	Mend_demomapmessage
	rts
;-------------------------------------------------------------------------
	longa
	longi
mother_next
	inc	kx_MotherShipSeq
	inc	kx_MotherShipSeq
	rts
;*********************************************************************
;*								*
;*			PlayerChart				*
;* Data bank 7e							*
;* Ret :ai16								*
;*********************************************************************
	longa
	longi
mm_playerdemochart
	ldx	kx_MMPlayerSeq
	jsr	(.PlayerDemoTbl,x)
	rts
.PlayerDemoTbl
	dw	pldemo_nothing&WM

	dw	pldemo_enterplanet&WM
	dw	pldemo_escapebattle&WM
	dw	pldemo_planetclear&WM
	dw	pldemo_enemyclear&WM

	dw	pldemo_starttrig&WM
	dw	pldemo_startwait&WM
	dw	pldemo_startmothershiptrig&WM
	dw	pldemo_startmothershipwait&WM
	dw	pldemo_partnerwait&WM

	dw	pldemo_planetcleardemotrig&WM
	dw	pldemo_planetcleardemo&WM
	dw	pldemo_planetrtmaptrig&WM
	dw	pldemo_planetrtmapwait&WM

	dw	pldemo_battleshipcleardemotrig&WM
	dw	pldemo_battleshipcleardemo&WM
	dw	pldemo_battleshiprtmaptrig&WM
	dw	pldemo_battleshiprtmapwait&WM

	dw	pldemo_sosmiscleardemotrig&WM
	dw	pldemo_sosmiscleardemo&WM

	dw	pldemo_sosgonedemotrig&WM
	dw	pldemo_sosgonedemowait&WM

	dw	pldemo_sosreturnmaptrig&WM
	dw	pldemo_sosreturnmapwait&WM
	dw	pldemo_zacoexplodewait&WM

	dw	pldemo_missilefelltrig&WM
	dw	pldemo_missilefellwait&WM

	dw	pldemo_rannyuCheck&WM
	dw	pldemo_rannyuwait&WM

	dw	pldemo_ptcont_wolfboss&WM
	dw	pldemo_ptcont_wolfboss2&WM

	dw	pldemo_messagetrig&WM
	dw	pldemo_messagewait&WM

	dw	pldemo_tmcharttrig&WM
	dw	pldemo_tmchartwait&WM
	dw	pldemo_tmchartwait2&WM

	dw	pldemo_tgdemotrig&WM
	dw	pldemo_tgdemowait&WM

	dw	pldemo_fbdemotrig&WM
	dw	pldemo_fbdemowait&WM

	dw	pldemo_pcdemotrig&WM
	dw	pldemo_pcdemowait&WM

	dw	pldemo_msdemotrig&WM
	dw	pldemo_msdemowait&WM

	dw	pldemo_sademotrig&WM
	dw	pldemo_sademowait&WM

	dw	pldemo_cursortrig&WM
	dw	pldemo_cursorwait&WM
	dw	pldemo_yjbeginwait&WM
	dw	pldemo_yjwait&WM
	dw	pldemo_ketteiwait&WM
	dw	pldemo_safetywait&WM
	dw	pldemo_wipeopen&WM
;---------------------------------------------------------------------
pldemo_nothing
pldemo_enterplanet
pldemo_escapebattle
pldemo_planetclear
pldemo_enemyclear
	longa
	rts

;=============================================
;*					*
;*	Arwing Start From mother	*
;*					*
;=============================================
pldemo_starttrig
	longa
;* arwing states (kanarazu mother ship wo set shita atoni oku !!)*
	km_stxval	mmx_arwingsp,arwingstartspeed
	km_stxval	kx_playerdemowait,3
	km_stxval	kx_MMPlayerSeq,plseq_startwait
	rts
;---------------------------------------------
pldemo_startwait
	longa
	lda	kx_playerdemowait
	dec	a
	sta	kx_playerdemowait
	bne	.skip
	km_stxval	kx_MMPlayerSeq,plseq_startmothershiptrig
.skip
	rts
;---------------------------------------------
pldemo_startmothershiptrig
	longa
	km_clrmismapfzflag	playerfreeze
	km_clrflag16	mmx_arwingflag,mmf_notdisplay
	km_setflag16	mmx_arwingflag,(mmf_initmove!mmf_go)
	km_stxval	kx_MMPlayerSeq,plseq_startmothershipwait
;* source *
	a8
	km_setvar	mmx_arwingposx+1,kx_mshipx
	sta	mmx_partnerposx+1
	km_setvar	mmx_arwingposy+1,kx_mshipy
	sta	mmx_partnerposy+1
;* dest *
	km_setval	mmx_curposx,init_cursorX
	km_setval	mmx_curposy,init_cursorY
;* angle *
	a16
	km_setval	mmx_arwingangY,$d800
	sta	mmx_partnerangY
	km_setval	mmx_arwinganmptr,13
	sta	mmx_partneranmptr
	rts
;---------------------------------------------
	longa
	longi
pldemo_startmothershipwait
	km_bitcheckflag16	mmx_arwingflag,mmf_arrive
	bne	.finish_wait
	rts
.finish_wait
	km_stxval	kx_MMPlayerSeq,plseq_partnerwait
;---------------------------------------------
	longa
	longi
pldemo_partnerwait
	km_bitcheckflag16	mmx_partnerflag,mmf_go
	beq	.finish_wait
	rts
.finish_wait
	jsr	mm_MissileBornEnable
	km_stxval	mmx_arwingsp,arwingspeed
	brl	pldemo_yjbegintrig
;---------------------------------------------
	longa
	longi
mm_MissileBornEnable
	ldx	kx_planetlistptr
.loop
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,x
	beq	.nextplanet
	km_clrflag16.w	mmx_planetflag,mmpnf_bornfreeze,x
.nextplanet
	lda.w	mmx_planetnext,x
	tax
	bne	.loop
	rts

;=============================================
;*					*
;*	Planet Mission Demo 		*
;*					*
;=============================================
	longa
	longi
pldemo_planetcleardemotrig
	km_clrmismapfzflag	playerfreeze
	km_setflag16	mmx_arwingflag,mmf_demo
	km_setval	kx_MMPlayerSeq,plseq_plamiscleardemo
	km_setval	kx_objdemonumber,odm_planetexplode
	rts
;---------------------------------------------
	longa
	longi
pldemo_planetcleardemo
	lda	kx_objdemonumber
	beq	pldemo_placommon
	rts
;---------------------------------------------
	longa
	longi
pldemo_planetrtmaptrig
	km_setval	kx_MMPlayerSeq,plseq_plareturnmapwait
	km_setval	kx_objdemonumber,odm_returnmap
	rts
;---------------------------------------------
	longa
	longi
pldemo_planetrtmapwait
	lda	kx_objdemonumber
	beq	pldemo_placommon
	rts

;---------------------------------------------------------------------
	longa
	longi
pldemo_ptcont_wolfboss
	km_stxval	kx_MMPlayerSeq,plseq_wipeopen
	km_stxval	kx_MMPlayerSeq_Next,plseq_ptcont_wolfboss2
	km_setval	kx_demoflag,demof_wipeopen	;(For Yajima)
	rts

	longa
	longi
pldemo_ptcont_wolfboss2
	km_clrflag16	kw_MisMapFreezeFlag,(kfz_enemyfreeze!kfz_timefreeze)
	km_clrmismapflag	playernocoll	;[player ga collision nashi no flag]
	km_stxval	kx_MMPlayerSeq,plseq_nothing
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_placommon
	km_clrflag16	mmx_arwingflag,mmf_demo
	km_setmismapfzflag	playerfreeze
	km_stxval	kx_MMPlayerSeq,plseq_wipeopen
	km_stxval	kx_MMPlayerSeq_Next,plseq_messagetrig
	km_setval	kx_demoflag,demof_wipeopen	;(For Yajima)
	rts
;---------------------------------------------------------------------

;=============================================
;*					*
;*       Battle Ship Mission Clear Demo 	*
;*					*
;=============================================
	longa
	longi
pldemo_battleshipcleardemotrig
	km_clrmismapfzflag	playerfreeze
	km_setflag16	mmx_arwingflag,mmf_demo
	km_setval	kx_objdemonumber,odm_bshipexplode
	km_setval	kx_MMPlayerSeq,plseq_batmiscleardemo
	rts
;---------------------------------------------
	longa
	longi
pldemo_battleshipcleardemo
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	ldy	kx_SOSEnemyptr		;enemy List pointer
	lda.w	mmx_enlinkptr,y
	tax
	jsr	clearbattleship
	km_clrmismapflag	battleplayer		;[player ga mission tyuu no flag]
	bra	pldemo_placommon
;---------------------------------------------
	longa
	longi
pldemo_battleshiprtmaptrig
	km_setval	kx_MMPlayerSeq,plseq_batreturnmapwait
	km_setval	kx_objdemonumber,odm_returnmap
	rts
;---------------------------------------------
	longa
	longi
pldemo_battleshiprtmapwait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	ldy	kx_SOSEnemyptr
	km_clrflag16.w	mmx_enflags,enfl_encountplayer,y
	brl	pldemo_placommon

;=============================================
;*					*
;*       SOS Enemy Mission Clear Demo 	*
;*					*
;=============================================
;-------------------------------------
;*	Clear Demo		*
;-------------------------------------
	longa
	longi
pldemo_sosmiscleardemotrig
	km_setval	kx_MMPlayerSeq,plseq_sosmiscleardemo

	ldy	kx_SOSEnemyptr
	km_bitcheckflag16.w	mmx_enflags,enfl_wolf,y
	bne	.wolf
.zaco
	km_setval	kx_objdemonumber,odm_zacoexplode
	rts
.wolf
	sty	kx_RannyuEnemyptr
	km_setval	kx_objdemonumber,odm_wolfexplode
	rts
;---------------------------------------
	longa
	longi
pldemo_sosmiscleardemo
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	km_bitcheckflag16.w	kx_satelliteflag,safl_virusgekitui
	bne	.virusGekitui
	brl	pldemo_rannyuCheck

;(For Virus)
.virusGekitui
	km_setval	kx_satellitetype,0
	km_clrflag16	kx_satelliteflag,(safl_virustorituki!safl_virusgekitui)

	ldy	kx_satelliteenptr
	km_clrflag16.w	mmx_enflags2,enfl2_tyuuritu,y	;friend
	brl	pldemo_placommon

;-------------------------------------
;*	Gone Demo		*
;-------------------------------------
	longa
	longi
pldemo_sosgonedemotrig
	km_bitcheckmismapflag2	rannyutrig
	beq	.enemygone

	lda	RannyuModeSwitch	;2 byte
	bmi	.enemygone	;= -1,-2 (zaco enemy gone) :wolf dead
;(RannyuModeSwitch = 1 notoki )
	cmp	#1
	beq	.enemygone	;wolf rannyu nashi (taiki jyoutai!!)

;(RannyuModeSwitch = 0 notoki )
	lda	kenemynumber
	cmp	#2
	bcs	.enemygone	;=2,3,4,.. (all enemy gone)
;				;=1 ... wolf arrive,zaco all dead
.enemydead	;(kenemynumber =1 : wolf gone & enemy all dead)
	km_setval	kx_objdemonumber,odm_zacoexplode
	bra	.gone_common

.enemygone	;(kenemynumber > 2 ,wolf dead)
	ldy	kx_SOSEnemyptr
	km_clrflag16.w	mmx_enflags,enfl_encountplayer,y
	km_setval	kx_objdemonumber,odm_enemygone
.gone_common
	km_setval	kx_MMPlayerSeq,plseq_sosgonedemowait
	rts

	longa
	longi
pldemo_sosgonedemowait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	brl	pldemo_rannyuCheck

;-------------------------------------
;*	Return Map Demo		*
;-------------------------------------
	longa
	longi
pldemo_sosreturnmaptrig
	km_setval	kx_objdemonumber,odm_returnmap
	km_setval	kx_MMPlayerSeq,plseq_sosreturnmapwait
	rts

	longa
	longi
pldemo_sosreturnmapwait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	ldy	kx_SOSEnemyptr
	km_clrflag16.w	mmx_enflags,enfl_encountplayer,y

	km_bitcheckmismapflag2	rannyutrig
	km_beq	pldemo_placommon

;(kenemynumber = 0 no toki) :(RannyuModeSwitch = 1 no toki mo aru)
	lda	kenemynumber
	beq	.explode
;(kenemynumber >=2 no toki)
	cmp	#2
	bcs	pldemo_rannyuCheck	;(enemy alive)
;(kenemynumber =1 no toki )
	lda	RannyuModeSwitch
	bmi	pldemo_rannyuCheck	;wolf team dead (enemy alive)

;RannyuModeSwitch = 0,1 no toki		;enemy all dead (wolf alive)
.explode
	km_setval	kx_objdemonumber,odm_zacoexplode
	km_setval	kx_MMPlayerSeq,plseq_zacoexplodewait

pldemo_zacoexplodewait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	brl	pldemo_rannyuCheck
;---------------------------------------------------------------------
	longa
	longi
pldemo_missilefelltrig
	km_setmismapdemoflag	missilefelldemo		;[mmtbl.asm declear] :reason :list ni nai enemy wo ugokashite shimau
	km_setval	kx_MisMapDemoNumber,kdemo_missilefelldemo
	km_setval	kx_objdemonumber,odm_missilefell
	km_setval	kx_MMPlayerSeq,plseq_missilefellwait
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_missilefellwait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	km_clrmismapdemoflag	missilefelldemo
	brl	pldemo_rannyuCheck

;-------------------------------------
;*	Rannyu Mode Check	*
;-------------------------------------
	longa
	longi
pldemo_rannyuCheck
	km_bitcheckmismapflag2	rannyutrig
	km_beq	pldemo_placommon
	km_clrmismapflag2	rannyutrig

	lda	RannyuModeSwitch
	bmi	.wolfdead	;(= -1 )
.wolfarrive
	ldy	kx_RannyuEnemyptr
	lda	kx_RannyuStratptr
	sta.w	mmx_enstratptr,y
	lda	kx_RannyuSeqPtr
	sta.w	mmx_ensequence,y

	lda	RannyuModeSwitch
	cmp	#1
	km_beq	pldemo_placommon	;(rannyuu taiki jyoutai dattatra !!)

	lda	mmw_wolfgonetrig
	bne	.wolfgone	;(wolf ga rannyu shiteite katu nigetara !!)
	brl	pldemo_placommon
.wolfgone
	km_setval	kx_MMPlayerSeq,plseq_rannyuwait
	km_setval	kx_objdemonumber,odm_wolfgone
	bra	pldemo_rannyuwait

.wolfdead
	km_setval	kx_MMPlayerSeq,plseq_rannyuwait
	km_setval	kx_objdemonumber,odm_wolfexplode

	longa
	longi
pldemo_rannyuwait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	brl	pldemo_placommon
;---------------------------------------
;=============================================
;*					*
;*	Mission Chart Check		*
;*					*
;=============================================
	longa
	longi
pldemo_messagetrig
	km_bitcheckmismapstflag	nokori1
	bne	.Last1
	bit	#kmimpstf_wolfbossdead
	beq	pldemo_tmcharttrig
.WolfDead
	km_setflag16	mmx_trigmessage,ymes_wolfdead
	bra	.mes_common
.Last1
	km_setflag16	mmx_trigmessage,ymes_target_last1
.mes_common
	jsr	kcall_trigmessage	
	km_setval	kx_MMPlayerSeq,plseq_messagewait
	km_setval	kx_messagedemowait,1	;[yajima ga clear]

	longa
	longi
pldemo_messagewait
	lda	kx_messagedemowait	;[yajima ga clear]
	beq	pldemo_tmcharttrig
	rts
;---------------------------------------------------------------------
pldemo_tmcharttrig
	longa
	km_setmismapchflag	tmchartenable
	km_clrmismaptrflag	mapgameenable
	km_stxval	kx_MMPlayerSeq,plseq_tmchartwait
	rts

	longa
	longi
pldemo_tmchartwait
	km_bitcheckmismapchflag	tmchartwait
	beq	pldemo_pcdemotrig
	rts

;---------------------------------------------------------------------
	longa
pldemo_pcdemotrig
	km_clrmismapchflag	allenable
	km_setmismapchflag	pcchartenable
	km_stxval	kx_MMPlayerSeq,plseq_pcdemowait
	rts

	longa
	longi
pldemo_pcdemowait
	km_bitcheckmismapchflag	pcdemowait
	beq	pldemo_sademotrig
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_sademotrig
	km_clrmismapchflag	allenable
	km_setmismapchflag	sachartenable
	km_stxval	kx_MMPlayerSeq,plseq_sademowait
	rts

	longa
	longi
pldemo_sademowait
	km_bitcheckmismapchflag	sademowait
	beq	pldemo_fbdemotrig	
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_fbdemotrig
	km_clrmismapchflag	allenable
	km_setmismapchflag	fbchartenable
	km_stxval	kx_MMPlayerSeq,plseq_fbdemowait
	rts

	longa
	longi
pldemo_fbdemowait
	km_bitcheckmismapchflag	fbdemowait
	beq	pldemo_tgdemotrig
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_tgdemotrig
	km_clrmismapchflag	allenable
	km_setmismapchflag	tgchartenable
	km_stxval	kx_MMPlayerSeq,plseq_tgdemowait

	km_bitcheckmismaptrflag	bstotugeki
	beq	.skip
	km_setmismapchflag	tgdemowait
.skip

;;;	jsr	check_bstotugeki

	longa
	longi
pldemo_tgdemowait
	km_bitcheckmismapchflag	tgdemowait
	beq	pldemo_msdemotrig
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_msdemotrig
	km_clrmismapchflag	allenable
	km_setmismapchflag	mschartenable
	km_stxval	kx_MMPlayerSeq,plseq_msdemowait
	rts

	longa
	longi
pldemo_msdemowait
	km_bitcheckmismapchflag	msdemowait
	beq	.check_cancel
	rts
.check_cancel
	km_bitcheckmismaptrflag	misallcancel
	beq	pldemo_ChartOnceCheck

.cancel_missileall
	km_clrmismaptrflag	misallcancel
	km_setmismapchflag	tmchartenable
	km_stxval	kx_MMPlayerSeq,plseq_tmchartwait2
	rts

	longa
	longi
pldemo_tmchartwait2
	km_bitcheckmismapchflag	tmchartwait
	beq	pldemo_ChartOnceCheck
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_ChartOnceCheck
	jsr	mm_WolfFreeChart
	jsl	CheckPCTmPri_l
;---------------------------------------------------------------------
	longa
	longi
pldemo_cursortrig
	km_clrmismapchflag	allenable

;-----------------------
;'95/9/8 :mission kara modotte event chart ga owattara disable
	km_setmismaptrflag	eventdisable	;[mission clear nomi enable !!]
;-----------------------

;('95/9/1  koko kara pldemo_ketteiwait ni idou)
;;;	km_setmismapchflag	mainenable

	km_setflag16	mmx_cursorflag,curf_demo
	km_stxval	kx_MMPlayerSeq,plseq_cursorwait
	km_stxval	kx_playerdemowait,1
	km_stxval	mmx_curwaittm,cursor_shuttime
	jsr	initpos_cursordemo
	ksound	ship_cursor_set

pldemo_cursorwait
	longa
	lda	kx_playerdemowait
	beq	.finish
	rts
.finish
	km_clrmismapfzflag	gamefreeze
	km_setflag16	kw_mismapfreezeflag,(kfz_timefreeze!kfz_enemyfreeze!kfz_ketteifreeze!kfz_pausefreeze)
	km_clrflag16	mmx_cursorflag,curf_demo
	km_clrmismapdemoflag	warpdemo ;(mm_mothershipchart) hokano event ga kakaranaiyouni surutame !!

	a8
	km_setvar	mmx_curposx,mmx_arwingposx+1
	km_setvar	mmx_curposy,mmx_arwingposy+1

	a16
	lda	kdifficulty
	km_bne	pldemo_ketteitrig	;(normal & hard)

	a8
	lda	p1_MaxHP
	lsr	a
	cmp	p1_hp
	a16
	bcc	.moreHP20
	beq	.moreHP20
.lessHP20
	km_setval	mapexp_pointer,mapexp_easyret_message	;(yajima)
	bra	pldemo_yjtrig
.moreHP20
	km_setval	mapexp_pointer,mapexp_easyret_normal	;(yajima)
	bra	pldemo_yjtrig
;---------------------------------------------------------------------
	longa
pldemo_yjbegintrig
	lda	kdifficulty
	km_bne	pldemo_cursortrig

	km_setval	mapexp_pointer,mapexp_easystart		;(yajima)
	km_stxval	kx_messagedemowait,1	;(yajima's set 0)
	km_stxval	kx_MMPlayerSeq,plseq_yjbeginwait
	rts
;---------------------------------------------------------------------
	longa
pldemo_yjbeginwait
	lda	kx_messagedemowait
	km_beq	pldemo_cursortrig
	rts
;---------------------------------------------------------------------
pldemo_yjtrig	;(easy)
	longa
.easy
	km_stxval	kx_MMPlayerSeq,plseq_yjwait
	km_stxval	kx_messagedemowait,1	;(yajima's set 0)
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_yjwait
	lda	kx_messagedemowait
	beq	pldemo_ketteitrig
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_ketteitrig
	km_clrgameflag		keydisable
	km_clrflag16	kw_MisMapFreezeFlag,kfz_ketteifreeze
	km_clrmismapflag2	warpwait
	km_stxval	kx_MMPlayerSeq,plseq_ketteiwait
	km_setflag16	mmx_cursorflag,curf_fzcancel
	km_stxval	kx_playerdemowait,1
	rts
;---------------------------------------------------------------------
	longa
	longi
pldemo_ketteiwait
	lda	kx_playerdemowait
	bne	.skip

;('95/9/1 :pldemo_cursortrig kara kokoni idou)
	km_setmismapchflag	mainenable
	km_setmismaptrflag	mapgameenable

	km_stxval	kx_MMPlayerSeq,plseq_safetywait
	km_stxval	kx_playerdemowait,safetywaittm	;(gamelist.inc)
	km_clrflag16	kw_MisMapFreezeFlag,(kfz_ketteifreeze!kfz_timefreeze!kfz_enemyfreeze)
.skip
	rts
;---------------------------------------------------------------------
pldemo_safetywait
	longa
	dec	kx_playerdemowait
	bne	.skip

	km_stxval	kx_MMPlayerSeq,plseq_nothing
	km_clrflag16	kw_mismapfreezeflag,(kfz_pausefreeze)
	km_clrmismapflag	playernocoll	;[player ga collision nashi no flag]
	km_setmismapflag2	debugenable

.skip
	rts
;---------------------------------------------------------------------
pldemo_wipeopen
	longa
	lda	kx_demoflag	;kx_playerdemowait
	bit	#1
	bne	.skip
	km_setvar	kx_MMPlayerSeq,kx_MMPlayerSeq_next
	km_clrmismapflag2	damagedisable
.skip
	rts
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------

;*********************************************************************
;*								*
;*		Mission Map Chart	[8fram ni 1 kai]	*
;* Data bank 7e							*
;* Ret :ai16								*
;*********************************************************************
	longa
	longi
mm_mismapchart
	km_bitcheckmismapchflag	tmchartenable
	beq	.end
	ldx	kx_MisMapSeq
	jsr	(KMisMapChartTbl,x)
.end
	rts
;---------------------------------------------------------------------
;*			Jump Table				*
;---------------------------------------------------------------------
KMisMapChartTbl
	dw	mmchart_nothing&WM

	dw	mmchart_TimeChartCheck&WM

	dw	mmchart_messagetrig&WM
	dw	mmchart_messagestartwait&WM
	dw	mmchart_messagestarttrig&WM
	dw	mmchart_messagewait&WM

	dw	mmchart_eventwait&WM
	dw	mmchart_clearwait&WM

	dw	mmchart_start&WM
	dw	mmchart_startdemowait&WM
	dw	mmchart_explaindo&WM
	dw	mmchart_explainfinish&WM

	dw	mmchart_Capture1_1&WM
	dw	mmchart_Capture1_2&WM

	dw	mmchart_Capture2_1&WM
	dw	mmchart_Capture2_2&WM
	dw	mmchart_Capture2_3&WM
	dw	mmchart_Capture2_4&WM
	dw	mmchart_Capture2_5&WM

	dw	mmchart_Capture3_1&WM
	dw	mmchart_Capture3_2&WM
	dw	mmchart_Capture3_3&WM
	dw	mmchart_Capture3_4&WM

	dw	mmchart_Capture4_1&WM
	dw	mmchart_Capture4_2&WM
	dw	mmchart_Capture4_3&WM
	dw	mmchart_Capture4_4&WM

	dw	mmchart_Capture5_1&WM
	dw	mmchart_Capture5_2&WM
	dw	mmchart_Capture5_3&WM
	dw	mmchart_Capture5_4&WM
	dw	mmchart_Capture5_5&WM
	dw	mmchart_Capture5_6&WM
	dw	mmchart_Capture5_7&WM

	dw	mmchart_misallcancelcheck&WM
	dw	mmchart_totugekicancelcheck&WM
;=====================================================================
;*								*
;*			Time Chart				*
;*								*
;=====================================================================
	longa
	longi
mmchart_TimeChartCheck
	km_clrmismaptrflag	enemytotal0	;forceevent

;* time chart finish check *
	ldx	kx_mismaptmchart
	lda.l	mmchart_timechart,x
	cmp	#-1
	beq	.end

;* kazu check *
	jsr	mm_checktotalenemy
	bcs	.clear_flagon

;* time chart *
	ldx	kx_mismaptmchart
	lda.l	mmchart_timechart,x
	cmp	#-2		;wolf boss appear check
	beq	.chart_trigger
	cmp	kx_TotalTime
	beq	.chart_trigger
	bmi	.chart_trigger
.end
	rts

.clear_flagon
	km_clrmismaptrflag	eventdisable	;[event enable]
.chart_trigger
	lda.l	mmchart_timechart+2,x
	dec	a
	pha	;[jump addr]

	inx
	inx
	inx
	inx
	stx	kx_mismaptmchart		;[next chart pointer]
	inc	kx_mismaptmchartNum
	rts
;---------------------------------------------------------------------
;*			Event Wait				*
;---------------------------------------------------------------------
	longa
	longi
mmchart_eventwait
	jsr	mm_checktotalenemy
	bcs	.force_start	;force jump
	km_bitcheckmismaptrflag	timechartstop	;[event stopper :game clear shita baai !!]
	beq	.start_event
	rts
.force_start
	km_setmismaptrflag	enemytotal0	;forceevent
.start_event
;* player stop *
	jsr	KPlayerStop

	km_setvar	kx_MisMapSeq,kx_MisMapNextSeq	;kono set wo nukuna !! event check ni jump shinaku naru !!
	ldx	kx_MisMapSeq
	jmp	(KMisMapChartTbl,x)

;---------------------------------------------------------------------
;*		Time Chart Force Step				*
;---------------------------------------------------------------------
	longa
	longi
mm_checktotalenemy
	lda	kx_senryoucurrent	;senryou sareteiru hoshi no kazu
	ora	kx_battleshipcurrent	;senkan nomkazu
	ora	kx_enemytotal		;zaco enemy
	beq	.sec
.clc
	clc
	rts
.sec
	sec
	rts
;---------------------------------------------------------------------
;*			Chart Do Nothing			*
;---------------------------------------------------------------------
	longa
	longi
mmchart_nothing
	rts

;---------------------------------------------------------------------
;*		Syori ga owareba mouichido Time Chart Check	*
;---------------------------------------------------------------------
	longa
	longi
mmchart_missilefreeze
	km_setmismapevflag	misbornfreeze
	brl	mmchart_TimeChartCheck
;---------------------------------------------------------------------
	longa
	longi
mmchart_virusbornenable
	km_clrmismapevflag	virusbornfreeze
	ldy	kx_FinalBossPlPtr
	km_setval.w	mmx_psos,virbase_appear,y
	brl	mmchart_TimeChartCheck
;---------------------------------------------------------------------
	longa
	longi
mmchart_wolfteamfree
	km_setmismaptrflag	wolffree
	inc	kx_wolffreestock
	brl	mmchart_TimeChartCheck
;---------------------------------------------------------------------
	longa
	longi
mmchart_missileall
	lda	kx_senryoucurrent
	bne	.Hassya_enable
	brl	mmchart_TimeChartCheck

.Hassya_enable
	km_setmismaptrflag	missileall
	km_setval	kx_MisMapSeq,mmseq_misallcancelcheck
	rts

	longa
	longi
mmchart_misallcancelcheck
;'95/8/29
;!! moshi missile all no trig ga tatte ite planet wo subete clear shitatoki
;tugino time chart ni step surutame no syori !!

	lda	kx_planetkazu
	beq	.cancel		;planet all clear
	rts
.cancel
	km_clrmismaptrflag	missileall
	km_clrmismapevflag	misbornfreeze
	brl	mmchart_TimeChartCheck

;---------------------------------------------------------------------
	longa
	longi
mmchart_senkantotugeki
	lda	kx_battleshipcurrent
	bne	.totugeki_enable
	brl	mmchart_TimeChartCheck

.totugeki_enable
	km_setmismaptrflag	bstotugeki
	km_setval	kx_TotugekiSeq,tgseq_totugeki1
	km_setval	kx_MisMapSeq,mmseq_totugekicancelcheck
	rts

	longa
	longi
mmchart_totugekicancelcheck
;'95/9/4
;!! moshi senkan totugeki no trig ga tatte ite battleship wo clear shita toki
;tugino time chart ni step surutame no syori !!
	lda	kx_battleshipcurrent	;ima deteiru battle ship no kazu
	beq	.cancel			;battle ship all clear
	rts
.cancel
	jsr	Cancel_BStotugeki
	brl	mmchart_TimeChartCheck
;---------------------------------------------------------------------
	longa
	longi
mmchart_timanappear
	km_bitcheckmismaptrflag	eventdisable
	bne	.disable_event
.enable_event
	km_setval	kx_MisMapSeq,mmseq_capture2_1
	brl	mmchart_Capture2_1

.disable_event
	km_setval	kx_MisMapNextSeq,mmseq_capture2_1
	bra	mmchart_eventwaitcommon
;---------------------------------------------------------------------
	longa
	longi
mmchart_senkanhojyuu
	km_bitcheckmismaptrflag	eventdisable
	bne	.disable_event
.enable_event
	km_setval	kx_MisMapSeq,mmseq_capture3_1
	brl	mmchart_Capture3_1
.disable_event
	km_setval	kx_MisMapNextSeq,mmseq_capture3_1
	bra	mmchart_eventwaitcommon
;---------------------------------------------------------------------
	longa
	longi
mmchart_planethojyuu
	km_bitcheckmismaptrflag	eventdisable
	bne	.disable_event
.enable_event
	km_setval	kx_MisMapSeq,mmseq_capture4_1
	brl	mmchart_Capture4_1

.disable_event
	km_setval	kx_MisMapNextSeq,mmseq_capture4_1
	bra	mmchart_eventwaitcommon
;---------------------------------------------------------------------
	longa
	longi
mmchart_wolfappear
	km_bitcheckmismaptrflag	eventdisable
	bne	.disable_event
.enable_event
	km_setval	kx_MisMapSeq,mmseq_capture5_1
	brl	mmchart_Capture5_1

.disable_event
	km_setval	kx_MisMapNextSeq,mmseq_capture5_1
	bra	mmchart_eventwaitcommon
;---------------------------------------------------------------------
	longa
	longi
mmchart_eventwaitcommon
	km_setmismaptrflag	timechartstop	;[event stopper]
	km_setval	kx_MisMapSeq,mmseq_eventwait
	rts
;---------------------------------------------------------------------
;*			Mission Map Start Demo			*
;---------------------------------------------------------------------
	longa
	longi
mmchart_start
	km_setval	kx_objdemonumber,odm_start_easy
	km_setval	kx_MisMapSeq,mmseq_startdemowait
;-------------------------------
	longa
	longi
mmchart_startdemowait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	km_bitcheckmistotalflag	retry
	bne	.retry
.Game_1st
	km_setflag16	kw_MisMapFreezeFlag,kfz_enemyfreeze
	km_clrflag16	kw_MisMapFreezeFlag,kfz_expcancelfreeze!kfz_pausefreeze
	km_setval	kx_MisMapSeq,mmseq_explaindo
	rts
.Retry 
	km_stxval	kx_MMPlayerSeq,plseq_starttrig
	km_clrflag16	kw_mismapfreezeflag,kfz_gamefreeze
	km_setflag16	kw_MisMapFreezeFlag,(kfz_enemyfreeze!kfz_cursorfreeze!kfz_timefreeze!kfz_pausefreeze!kfz_ketteifreeze) ;ketteifreeze ha arwing ga dash shinai tame !!
	km_setval	kx_MisMapSeq,mmseq_timechartcheck
	rts
;-------------------------------
mmchart_explaindo
	longa
	rts
;-------------------------------
mmchart_explainfinish
	longa
	km_setmismapflag	expcancel
	km_setmismapsyori	explainfinish
;* FREEZE SHITE OKNAITO MOUOICHIDO START BUTTON CHECK SHITE SHIMAU !! *
	km_setflag16	kw_MisMapFreezeFlag,(kfz_gamefreeze)	;!kfz_sosbornfreeze
	km_setval	kx_MisMapSeq,mmseq_timechartcheck
	rts

	longa
mmchart_nextsequence
	inc	kx_MisMapSeq
	inc	kx_MisMapSeq
	rts
;---------------------------------------------------------------------
;*
;---------------------------------------------------------------------
mmchart_Capture1_1
mmchart_Capture1_2

;---------------------------------------------------------------------
;*			Dragon Go !!				*
;---------------------------------------------------------------------
	longa
mmchart_Capture2_1
	jsr	Check_forceevent
mmchart_Capture2_2
	km_setmismaptrflag	specialenemy
	km_setmismapchflag	tmchartwait
	km_setval	kx_MisMapNextSeq,mmseq_capture2_3
	km_setval	kx_expdemowait,5*8

	ldx	kdifficulty2
	lda.l	.taimanmes,x
	tsb	mmx_trigmessage
	brl	mmchart_messagetrig

.taimanmes
	dw	ymes_taimanE
	dw	ymes_taimanN
	dw	ymes_taimanH

mmchart_Capture2_3
	longa

	ldx	kdifficulty
	beq	.set_taiman1

	lda	kw_RandomPtr
	and	#3
	tax
.set_taiman1
	a8
	lda.l	.taimantbl,x
	sta	demotaiman

	lda	kdifficulty
	cmp	#2
	bne	.skip_taiman

	inx
	lda.l	.taimantbl,x
	sta	demotaiman2
.skip_taiman
	a16

	km_setvar	kw_MisMapFreezeFlag,kw_MisMapFreezeFlagBak
	km_setmismapsyori	specialenemy
	km_setval	kx_MisMapSeq,mmseq_capture2_4
	rts
.taimantbl
	db	dt_dragon	;0
	db	dt_stepup	;1
	db	dt_crusher	;2
	db	dt_ninja	;3
	db	dt_dragon	;0

mmchart_Capture2_4
	longa
	km_bitcheckmismapdemoflag	all
	beq	.OK
	rts
.OK
	km_setmismapchflag	tmchartwait
	km_setmismapdemoflag	specialenemydemo
	km_setval	kx_MisMapDemoNumber,kdemo_specialenemydemo

	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
	jsr	SetSpecialEnemy
	km_setval	kx_MisMapSeq,mmseq_capture2_5
	rts

mmchart_Capture2_5
	longa
	lda	mmx_specialapcocnt
	bne	.skip
	km_clrmismapchflag	tmchartwait
	km_clrmismapdemoflag	specialenemydemo
	km_setval	kx_MisMapDemoNumber,kdemo_nothingdemo
	km_setval	kx_MisMapSeq,mmseq_timechartcheck
	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
.skip
	rts


	IFEQ	1	;OLD Ver
mmchart_Capture2_1	;trigger check wo shiteita toki
	km_clrmismapchflag	tmchartwait
	km_setval	kx_clearcondition,2
	km_setval	kx_MisMapSeq,mmseq_clearwait
	km_setval	kx_MisMapNextSeq,mmseq_capture2_2
	brl	mmchart_cleartrig
	ENDC

;---------------------------------------------------------------------
;*		Senkan Hojyuu & Zaco Enemy Hassya 1st		*
;---------------------------------------------------------------------
	longa
	longi
mmchart_Capture3_1
	lda	kx_battleshipcurrent
	ora	kx_zacocurrent
	beq	.Next_Check	;zaco ga inaku narumade count !!
	rts
.Next_Check
	km_bitcheckmismapdemoflag	all
	beq	mmchart_Capture3_2
	rts

	longa
	longi
mmchart_Capture3_2
	jsr	Check_forceevent

	km_setmismapchflag	tmchartwait
	km_setval	kx_expdemowait,5*8
	km_setval	kx_MisMapNextSeq,mmseq_capture3_3
	km_setmismapdemoflag	battleshiphojyuudemo

	lda	kdifficulty
	cmp	#2
	beq	.hard
.normal
	km_setflag16	mmx_trigmessage,ymes_battleshipaddN
	bra	.skip
.hard
	km_setflag16	mmx_trigmessage,ymes_battleshipaddH
.skip
	brl	mmchart_messagetrig

;---------------------------------------------------------------------
	longa
	longi
mmchart_Capture3_3
;	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
;	km_setmismapfzflag	gamefreeze	;allfreeze

	jsr	SetBattleShip	;sankan hojyuu !!
	km_stxval	mmx_expwaitcnt,zacokazu_2nd
	km_setmistotalflag	bshojyuu	;hojyuu shita
	km_setval	kx_MisMapDemoNumber,kdemo_battleshiphojyuudemo
	km_setval	kx_MisMapSeq,mmseq_capture3_4

;	km_clrmismapstflag	expdemostart
;;;	km_clrmistotalflag	bstotugeki	;totugeki flag clear
;;;	jsr	mm_planethojyuuchart
;---------------------------------------------------------------------
	longa
	longi
mmchart_Capture3_4
	lda	kx_battleshipcurrent
	beq	.waiting
	lda	mmx_expwaitcnt
	beq	.finish
.waiting
	rts
.finish
	km_clrmismapdemoflag	battleshiphojyuudemo
	km_clrmismapchflag	tmchartwait

	km_setval	kx_MisMapDemoNumber,kdemo_nothingdemo
	km_setval	kx_MisMapSeq,mmseq_timechartcheck

;'95/9/7
	km_bitcheckmismaptrflag	forceevent
	bne	.force_event

	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
	rts
.force_event
	km_clrmismaptrflag	enemytotal0
	km_stxval	kx_MMPlayerSeq,plseq_cursortrig
	rts

;-----------------------------------------------------
;*		Force Event Check		*
;-----------------------------------------------------
	longa
	longi
Check_forceevent
;'95/9/7
;* player stop *
	km_bitcheckmismaptrflag	forceevent
	beq	.not_force
	jsr	KPlayerStop
	km_setmismapfzflag	gamefreeze
.not_force
	rts

;---------------------------------------------------------------------
;*			Planet Hojyuu				*
;---------------------------------------------------------------------
	longa
	longi
mmchart_Capture4_1
	lda	kx_missilecurrent
	beq	.check2
	rts
.check2
	km_bitcheckmismapdemoflag	all
	beq	.check3
	rts
.check3
	km_bitcheckmismaptrflag	eventdisable	;[mission clear nomi enable !!]
	beq	.start_planethojyuu	;event enable no toki

	jsr	mm_checktotalenemy
	bcs	.start_planethojyuu	;enemy ga inakereba
	rts

.start_planethojyuu
	jsr	Check_forceevent

	km_setmismapdemoflag	planethojyuudemo
	km_setmismapchflag	tmchartwait
	km_setflag16	mmx_trigmessage,ymes_taimanN
	km_setval	kx_expdemowait,5*8
	km_setval	kx_MisMapNextSeq,mmseq_capture4_2
	brl	mmchart_messagetrig

mmchart_Capture4_2
	km_setmistotalflag		plhojyuu	;wolf on/off switch
	km_setval	kx_objdemonumber,odm_planethojyuu
	km_setval	kx_MisMapSeq,mmseq_capture4_3

mmchart_Capture4_3
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	km_clrmistotalflag		plhojyuu

	km_bitcheckmismapflag2	returnmother
	beq	mmchart_Capture4_Finish

	km_clrmismapflag2	returnmother
	km_setval	kx_planetbufnum,planet_corneria
	sta	kx_mshipcurrentnum
	km_setvar	kx_warpplaceptr,kx_corneriaptr
	km_setval	kx_objdemonumber,odm_runawaywarp
	km_setval	kx_MisMapSeq,mmseq_capture4_4

mmchart_Capture4_4
	lda	kx_objdemonumber
	beq	mmchart_Capture4_Finish
	rts

mmchart_Capture4_Finish
;( missile isseihassya no tame comment )
;	km_setval	kx_MisMapSeq,mmseq_timechartcheck
;	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak :satellite ga tubushita to ki comment !!
;-------------
;'95/9/7 :Comment
;	km_clrmismapdemoflag	planethojyuudemo
;	km_clrmismapchflag	tmchartwait
;-------------
;* missile all params *
	km_setmismaptrflag	planethojyuu
	km_setmismapchflag	mschartenable	;satellite ga tubushita to ki comment !!
	km_setmismaptrflag	missileall
	km_setval	kx_MisMapSeq,mmseq_nothing
	rts

;=====================================================================
;*								*
;*		Wolf Boss Appear Chart				*
;*								*
;=====================================================================
	longa
mmchart_Capture5_1
	lda	kx_missiontotal
	ora	kx_specialclearcnt
	ora	kx_enemytotal
	beq	.Next_Check	;zaco ga inaku narumade count !!
	rts
.Next_Check
;'95/8/25
;* moshi missile all no flag ga tatte itemo kokomade kitara clear *
	km_clrmismaptrflag	missileall

	km_bitcheckmismapdemoflag	all
	beq	.MissionClearTRIGGER
	rts

.MissionClearTRIGGER
	jsr	KPlayerStop	;arwing stop

	km_setmismapchflag	tmchartwait
	km_setmismapevflag	virusbornfreeze
	km_setflag16	mmx_trigmessage,ymes_attacklastboss ;(pepper message) :[teki wo issou shita !!]
	km_setval	kx_expdemowait,10*8
	km_setval	kx_MisMapNextSeq,mmseq_capture5_2
	brl	mmchart_messagetrig

mmchart_Capture5_2
	km_setval	kx_objdemonumber,odm_LAST1warp
	brl	mmchart_nextsequence

mmchart_Capture5_3
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
	km_setmismapdemoflag	wolfbossdemo
	km_setflag16	mmx_trigmessage,ymes_wolfappear
	km_setval	kx_expdemowait,5*8
	km_setval	kx_MisMapNextSeq,mmseq_capture5_4

	km_setmismapflag2	wolfboss	;kono flag wa InitWolfTeam2 no maeni oku !!
	jsr	InitWolfTeam2
	km_setval	kx_MisMapDemoNumber,kdemo_wolfbossdemo
	km_setval	mmx_specialapcocnt,1
	jsr	KPlayerStop
;* sound *
	KBGM	last_wolf	;inagaki
	ksound	en_wolf_appear
	brl	mmchart_messagetrig

mmchart_Capture5_4

	longa
	longi
mmchart_Capture5_5
	lda	mmx_specialapcocnt
	beq	.finish
	rts
.finish
	km_clrmismapflag2	wolffreecurrent
	km_setmismaptrflag	wolffree

	jsr	mm_WolfFreeChart

	km_clrmismapdemoflag	wolfbossdemo
	km_clrmismapchflag	tmchartwait
	km_setval	kx_MisMapDemoNumber,kdemo_nothingdemo
	km_setval	kx_MisMapSeq,mmseq_capture5_6

	km_clrmismapflag	playernocoll	;[player ga collision nashi no flag]
	km_clrmismapfzflag	enemyfreeze
	km_stxval	kx_MMPlayerSeq,plseq_nothing
	rts

;;;	brl	mmchart_ForceEventCheck

mmchart_Capture5_6
	lda	kx_wolfcurrent
	beq	.finish
	rts
.finish
	km_setval	kx_MisMapSeq,mmseq_nothing
	km_setval	kx_FinalBossSeq,fbseq_finalbosstrig
	rts
mmchart_Capture5_7


;=====================================================================
;*								*
;*		Wolf Team Free Chart				*
;*								*
;=====================================================================

	longa
	longi
mm_WolfFreeChart
	km_bitcheckmismaptrflag	wolffree
	beq	.end
	km_bitcheckmismapflag2	wolffreecurrent
	bne	.end
	lda	kx_wolfcurrent
	bne	.Search_FreeEnemy
	km_clrmismaptrflag	wolffree
.end
	rts

	longa
	longi
.Search_FreeEnemy
	ldy	kx_enlistptr
.LOOP
;	km_bitcheckflag16.w	mmx_enflags,enfl_wolf,y
;	beq	.next

	km_bitcheckflag16.w	mmx_enflags2,enfl2_planetprotect,y
	bne	.Found_WolfTeam
.next
	lda.w	mmx_ennext,y
	tay
	bne	.LOOP

	km_clrmismaptrflag	wolffree
	rts

	longa
	longi
.Found_WolfTeam
	km_clrflag16.w	mmx_enflags,enfl_nocollision,y
	km_setflag16.w	mmx_enflags2,(enfl2_searchenemy),y
	km_clrflag16.w	mmx_enflags2,enfl2_planetprotect,y
	km_setmismapflag2	wolffreecurrent
	km_setval.w	mmx_ensequence,enseq_move,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setval.w	mmx_encoll,wolf_freecollision,y

	ldx.w	mmx_enlinkptr,y
	km_clrflag16.w	mmx_planetflag,mmpnf_wolfprotect,x

	rts
;---------------------------------------------------------------------
;*			Message Display				*
;---------------------------------------------------------------------
	longa
	longi
mmchart_messagetrig
	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
	km_setmismapfzflag	gamefreeze	;messagefreeze

	IFEQ	1
	km_setval	kx_messtartwait,1
	km_setval	kx_MisMapSeq,mmseq_messagestartwait
	rts
	ENDC
mmchart_messagestartwait
	IFEQ	1
	dec	kx_messtartwait
	bne	.skip
	km_setval	kx_MisMapSeq,mmseq_messagestarttrig
.skip
	rts
	ENDC

	longa
mmchart_messagestarttrig
	jsr	kcall_trigmessage	
	km_setval	kx_MisMapSeq,mmseq_messagewait
	rts

	longa
	longi
kcall_trigmessage
	km_setvar	map_trigmessage,mmx_trigmessage
	stz	mmx_trigmessage
	stz	mapexp_pointer	;[for yaijma]
	rts

mmchart_messagewait
	longa
	dec	kx_expdemowait
	bne	.waiting
;	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
	km_setvar	kx_MisMapSeq,kx_MisMapNextSeq
.waiting
	rts
;---------------------------------------------------------------------
;*		Next Chart Wait					*
;---------------------------------------------------------------------
mmchart_cleartrig
	longa
	stz	kx_planetclearcnt
	stz	kx_battleshipclearcnt
	stz	kx_missileclearcnt
	stz	kx_zacoclearcnt
	rts
;---------------------------------------------------------------------
mmchart_clearwait
	longa
	longi
	lda	kx_planetclearcnt
	clc
	adc	kx_battleshipclearcnt
	adc	kx_missileclearcnt
	adc	kx_zacoclearcnt
	cmp	kx_clearcondition
	bmi	.waiting	;zaco ga inaku narumade count !!

	km_setmismapchflag	tmchartwait
	km_setvar	kx_MisMapSeq,kx_MisMapNextSeq
.waiting
	rts

;=====================================================================
;*								*
;*		Planet Hojyuu Chart				*
;* Data bank 7e							*
;* Ret :a8i16							*
;=====================================================================
	IFEQ	1
mm_planethojyuuchart
	longa
	longi
	km_bitcheckmistotalflag		plhojyuu
	bne	.skip

	lda	kdifficulty
	cmp	#dif_hard
	bne	.skip
	km_setmistotalflag		plhojyuu
	km_setval	mmx_senryoucnt,planetkazu_hard_2nd
	jsr	SenryouPlanet
.skip
	rts
	ENDC

;=====================================================================
;*								*
;*			Message  Chart				*
;* Data bank 7e							*
;=====================================================================
mm_messagechart
	php
	ai16
	ldx	kx_MessageSeq
	jsr	(.messagecharttbl,x)
	plp
	rts
.messagecharttbl
	dw	meschart_nothing&WM
	dw	meschart_messagetrig&WM
	dw	meschart_messagestartwait&WM
	dw	meschart_messagestarttrig&WM
	dw	meschart_messagewait&WM	
;---------------------------------------------------------------------
;*			Message Display				*
;---------------------------------------------------------------------
meschart_nothing
	longa
	longi
	rts
meschart_messagetrig
	longa
	longi
;	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
;	km_setmismapfzflag	gamefreeze
;	km_setval	kx_messtartwait,1*8
;	km_setval	kx_MessageSeq,messeq_messagestartwait

meschart_messagestartwait
;	longa
;	dec	kx_messtartwait
;	beq	meschart_messagestarttrig
;	rts

meschart_messagestarttrig
	longa
	km_setvar	map_trigmessage,mmx_trigmessage
	stz	mmx_trigmessage
	stz	mapexp_pointer		;[for yaijma]
	km_setval	kx_MessageSeq,messeq_messagewait
meschart_messagewait
	longa
	dec	kx_messagewait
	bne	.waiting
;;;	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
	km_setval	kx_MessageSeq,messeq_nothing
.waiting
	rts

;*********************************************************************
;*								*
;*		Missile All Fire Chart				*
;* Data bank 7e							*
;* Ret :ai16								*
;*********************************************************************
	longa
	longi
mm_missileallchart
	km_bitcheckmismapchflag	mschartenable
	beq	.end
	km_bitcheckmismaptrflag	missileall
	beq	.end
	km_bitcheckmismapdemoflag	all
	beq	.do_chart
	km_bitcheckmismapdemoflag	missilealldemo
	bne	.do_chart
	km_bitcheckmismapdemoflag	planethojyuudemo
	beq	.end
.do_chart
	ldx	kx_MissileAllSeq
	jsr	(.missilealltbl,x)
.end
	rts
.missilealltbl
	dw	ms_missileall0&WM
	dw	ms_missileall1&WM
	dw	ms_missileall2&WM
	dw	ms_missileall3&WM
	dw	ms_missileall4&WM
	dw	ms_missileall5&WM
;----------------------------------------------------------------------
	longa
	longi
ms_missileall0
	km_bitcheckmismaptrflag	planethojyuu
	bne	.all_fire
	lda	kx_senryoucurrent
	beq	.stop_fire
	lda	kx_missilecurrent
	bne	.end

	km_bitcheckmismaptrflag	eventdisable
	beq	.all_fire
	jsr	mm_checktotalenemy
	bcc	.end
.all_fire
	km_setmismapchflag	msdemowait
	km_setval	kx_MissileAllSeq,msseq_missileall1
.end
	rts

.stop_fire
	km_clrmismaptrflag	missileall
	km_clrmismapevflag	misbornfreeze
	km_setmismaptrflag	misallcancel
	km_setval	kx_MisMapSeq,mmseq_timechartcheck
	rts

ms_missileall1
	longa
	jsr	ms_GoAll
	bne	.missileall

;* planet nashi *
	km_clrmismapchflag	msdemowait
	km_clrmismaptrflag	missileall
	km_clrmismapevflag	misbornfreeze
	km_setval	kx_MissileAllSeq,msseq_missileall0
	rts

.missileall
	km_bitcheckmismaptrflag	planethojyuu
	bne	..planethojyuu
..normal
	jsr	Check_forceevent
	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
	bra	..skip
..planethojyuu	;Freeze ha Planet Hojyuu de shitearu !!
	km_clrmismaptrflag	planethojyuu
..skip
	km_setmismapdemoflag	missilealldemo
	km_setmismapfzflag	gamefreeze

	km_setval	kx_messagewait,10*8
	km_setval	kx_MessageSeq,messeq_messagetrig
	km_setval	kx_MissileAllSeq,msseq_missileall2

	km_setflag16	mmx_trigmessage,ymes_missileallfire

;	km_bitcheckmistotalflag		bshojyuu
;	bne	.2times
;.1times
;
;	km_setflag16	mmx_trigmessage,ymes_missileallfire
;
;	bra	.skip
;.2times
;	km_setflag16	mmx_trigmessage,ymes_missileallfire2
;.skip

ms_missileall2
	longa
	jsr	mm_messagechart
	lda	kx_MessageSeq
	beq	ms_missileall3
	rts
ms_missileall3
	longa

	km_setval	kx_MisMapDemoNumber,kdemo_missilealldemo
	km_clrmismapevflag	misbornfreeze
	km_clrmismapevflag	misbornfreeze
	km_setval	kx_MissileAllSeq,msseq_missileall4
ms_missileall4
	lda	kx_missileappcnt
	beq	ms_missileall5
	rts
ms_missileall5
	km_clrmismapchflag	msdemowait
	km_clrmismaptrflag	missileall
	km_clrmismapdemoflag	missilealldemo
	km_clrmismapchflag	mschartenable	;satellite ga tubushita to ki comment !!

	km_setval	kx_MisMapDemoNumber,kdemo_nothingdemo

	km_setval	kx_MissileAllSeq,msseq_missileall0
	km_setval	mapexp_pointer,0	;[for yaijma]

	km_setval	kx_MisMapSeq,mmseq_timechartcheck

;	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
;	brl	mmchart_ForceEventCheck

;-----------------
;'95/9/7 :Add
	km_bitcheckmismapdemoflag	planethojyuudemo
	beq	.not_PLhojyuu
	km_clrmismapdemoflag	planethojyuudemo
	km_clrmismapchflag	tmchartwait
.not_PLhojyuu
;-----------------
	km_bitcheckmismaptrflag	forceevent
	bne	.force_event
	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
	km_clrmismapevflag	misbornfreeze	;Return Freeze Flag no atoni oke !!
.waiting
	rts

.force_event
	km_clrmismapevflag	misbornfreeze	;Return Freeze Flag no atoni oke !!
	km_clrmismaptrflag	enemytotal0	;forceevent
	km_stxval	kx_MMPlayerSeq,plseq_cursortrig
	rts

;-----------------------------------------------------
;*		Missile Issei Hassya !!		*
;*						*
;-----------------------------------------------------
ms_goall
	longa
	longi
	stz	kz_x1
	ldx	kx_planetlistptr
	beq	.noplanet
.loop
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,x
	beq	.next
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_senryou,x
	beq	.next
	km_bitcheckflag16.w	mmx_planetflag,(mmpnf_complete!mmpnf_sosappear),x
	bne	.next

	km_clrflag16.w	mmx_planetflag,mmpnf_bornfreeze,x	;[missile hassya kaijyo]
	km_setval.w	mmx_psos,enbase_wait,x
	km_setval.w	mmx_soswaittm,1,x
	inc	kz_x1
.next
	lda.w	mmx_planetnext,x
	tax
	bne	.loop

	lda	kz_x1
	beq	.noplanet
.issei_hassya
	cmp	#mm_missilemax+1
	bmi	.skipaaa
	lda	#mm_missilemax
.skipaaa
	sta	kx_missileappcnt
.noplanet
	rts

;*********************************************************************
;*								*
;*		Battle Ship Totugeki Chart			*
;* Data bank 7e							*
;* Ret :ai16								*
;*********************************************************************
	longa
	longi
mm_bstotugekichart
	km_bitcheckmismapchflag	tgchartenable
	beq	.end
	km_bitcheckmismaptrflag	bstotugeki
	beq	.end
	km_bitcheckmismapdemoflag	all
	beq	.do_chart
	km_bitcheckmismapdemoflag	battleshiptotugekidemo
	beq	.end
.do_chart

	ldx	kx_TotugekiSeq
	jsr	(.totugekitbl,x)
.end
	rts
.totugekitbl
	dw	tg_totugeki0&WM
	dw	tg_totugeki1&WM
	dw	tg_totugeki2&WM
	dw	tg_totugeki3&WM
;----------------------------------------------------------------------
	longa
	longi
tg_totugeki0
	rts

	longa
	longi
tg_totugeki1
	lda	kx_battleshipcurrent	;ima deteiru battle ship no kazu
	beq	Cancel_BStotugeki

	jsr	tg_enablecheck
	bcc	Cancel_BStotugeki

	km_setmismapdemoflag	battleshiptotugekidemo
	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
	km_setmismapfzflag	gamefreeze

	km_setflag16	mmx_trigmessage,ymes_battleshiptotugeki	;[for yajima's]
	km_setval	kx_messagewait,5*8
	km_setval	kx_MessageSeq,messeq_messagetrig

	km_setval	kx_TotugekiSeq,tgseq_totugeki2

	longa
	longi
tg_totugeki2
	jsr	mm_messagechart
	lda	kx_MessageSeq
	beq	tg_totugeki3
	rts

	longa
	longi
tg_totugeki3
	jsr	bs_totugeki

	longa
	longi
tg_totugekiend
	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
	km_setval	mapexp_pointer,0	;[for yaijma]
	km_clrmismapdemoflag	battleshiptotugekidemo

	longa
	longi
Cancel_BStotugeki
	km_clrmismapchflag	tgdemowait
	km_clrmismaptrflag	bstotugeki

	km_setval	kx_TotugekiSeq,tgseq_totugeki0
	km_setval	kx_MisMapSeq,mmseq_timechartcheck
	rts
;=====================================================================
;*								*
;*			Senkan totugeki !!			*
;*								*
;=====================================================================
check_bstotugeki
	longa
	longi

	IFEQ	1
;	km_bitcheckmismapdemoflag	battleshiptotugekidemo
;	bne	.end

	km_bitcheckmistotalflag	bstotugeki
	bne	.end
	lda	kx_battleshipcurrent	;ima deteiru battle ship no kazu
	beq	.stop_totugeki

.check_totugeki
	km_bitcheckmistotalflag	bshojyuu
	bne	.easy

	lda	kdifficulty
	beq	.easy
	dec	a
	beq	.normal
	dec	a
	beq	.hard
;------------------------------
.easy
	lda	kx_planetkazu
	bne	.end
	bra	.totugeki
;------------------------------
.normal
	lda	kx_planetkazu
	cmp	#1
	bne	.end
	bra	.totugeki
;------------------------------
.hard
	lda	kx_planetkazu
	cmp	#3
	bne	.end
	bra	.totugeki
;------------------------------
.totugeki
	km_setmismapchflag	tgdemowait
	km_setmistotalflag	bstotugeki
	km_setmismaptrflag	bstotugeki
	km_setval	kx_TotugekiSeq,tgseq_totugeki1
	rts

.stop_totugeki
	km_setmistotalflag	bstotugeki
.end
	rts
	ENDC
;-----------------------------------------------------
;*	Battle Ship Totugeki Enable Check	*
;* Xreg :Planet List					*
;* Yreg :Enemy List					*
;* temp work : kz_x1					*
;* Out Put :clc/sec ... totugeki disable / enable	*
;-----------------------------------------------------
	longa
	longi
tg_enablecheck
	stz	kz_x1
	ldx	kx_planetlistptr
	beq	.tg_disable
.loop
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_battleship,x
	beq	.next
	km_bitcheckflag16.w	mmx_battleshipflag,mmbsf_cannonareain,x
	bne	.next
	inc	kz_x1
.next
	lda.w	mmx_planetnext,x
	tax
	bne	.loop

	lda	kz_x1
	bne	.tg_enable
.tg_disable
	clc
	rts
.tg_enable
	sec
	rts
;-----------------------------------------------------
;*		Battle Ship Totugeki		*
;* Xreg :Planet List					*
;* Yreg :Enemy List					*
;-----------------------------------------------------
	longa
	longi
bs_totugeki
	ldx	kx_planetlistptr
	beq	.end
.loop
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_battleship,x
	beq	.next

	km_bitcheckflag16.w	mmx_battleshipflag,mmbsf_cannonareain,x
	bne	.next

	lda.w	mmx_bslinkptr,x
	tay
	km_clrflag16.w	mmx_enflags2,enfl2_nojet,y
	lda	#btship_speed*8
	jsl	calc_bsspeed_L
.next
	lda.w	mmx_planetnext,x
	tax
	bne	.loop
.end
	rts


;*********************************************************************
;*								*
;*		Planet cannon Chart				*
;* data bank :7e							*
;*********************************************************************
	longa
	longi
mm_planetcannonchart
	km_bitcheckmismapchflag	pcchartenable
	beq	.end

	km_clrsndflag	cannoncharge

	ldy	kx_PlanetcannonListPtr
	beq	.end
	lda	kx_PlanetcannonPtr
	asl	a
	tax
	jsr	(.PlanetcannonSeq,x)
.end
	rts

.PlanetcannonSeq
	dw	pc_nothing&WM
	dw	pc_cannonCharge&WM
	dw	pc_FireMessageTrig&WM
	dw	pc_FireMessageWait&WM
	dw	pc_PolygonDemoTrig&WM
	dw	pc_PlanetcannonTrigger&WM
	dw	pc_PlanetcannonWait&WM
	dw	pc_MessageWait&WM

;=====================================================================
;*			Sub Routine				*
;=====================================================================
	longa
	longi
pc_nothing
	rts
;---------------------------------------------------------------------
	longa
	longi
pc_cannonCharge
	km_setsndflag	cannoncharge
	rts
;---------------------------------------------------------------------
	longa
	longi
pc_FireMessageTrig
	km_setsndflag	cannoncharge

	km_setmismapchflag	pcdemowait
	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
	km_setmismapfzflag	gamefreeze
	km_setflag16	map_trigmessage,ymes_planetcannonfire
	km_setval	kx_PlanetcannonTm,5*8
	inc	kx_PlanetcannonPtr
	rts
;---------------------------------------------------------------------
	longa
	longi
pc_FireMessageWait
	km_setsndflag	cannoncharge

	jsr	pc_waittimer
	bcc	.waiting
	inc	kx_PlanetcannonPtr
.waiting
	rts
;---------------------------------------------------------------------
pc_PolygonDemoTrig
	km_setsndflag	cannoncharge

	km_setmismapflag2	planetcannondemo
	km_setmismapsyori	planetcannon
	inc	kx_PlanetcannonPtr
	rts
;---------------------------------------------------------------------
pc_PlanetcannonTrigger
	longa
	longi
	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag

	km_setval.w	mmx_planetcannonchart,pcspr_fire,y
	km_setval.w	mmx_pwork1,cd_objanime_cannonfire1,y
	km_setval.w	mmx_pwork2,0,y
	km_bitcheckflag16.w	mmx_battleshipflag,mmbsf_type,y
	beq	.typea
	km_setval.w	mmx_pwork1,cd_objanime_cannonfire2,y
.typea
	ksound	stop
	ksound	map_laser
	inc	kx_PlanetcannonPtr
	rts
;---------------------------------------------------------------------
	longa
	longi
pc_PlanetcannonWait
	km_bitcheckmismapstflag	corneriaexplode
	bne	.skip

	lda.w	mmx_planetcannonchart,y
	cmp	#pcspr_finish
	bne	.skip

;* clear params *
	km_setval.w	mmx_planetcannonchart,pcspr_nothing,y
	lda	kx_CorneriaHP
	beq	pc_CorneraiaHP0
	km_setval	kx_PlanetcannonTm,5*8
	km_setflag16	mmx_message_sos,mesosfl_planetcannonhit
	inc	kx_PlanetcannonPtr
.skip
	rts
;---------------------------------------------------------------------
	longa
	longi
pc_MessageWait
	jsr	pc_waittimer
	bcs	pc_cannonFireEnd
	rts
;---------------------------------------------------------------------
	longa
	longi
pc_cannonFireEnd
	km_clrmismapchflag	pcdemowait
	km_clrmismapflag	cannonstart
pc_CorneraiaHP0
	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
	km_setval.w	mmx_planetcannontm,planetcannonchargetm,y
	km_setval.w	mmx_planetcannonchart,pcspr_charge,y
	km_setval.w	mmx_pwork1,sprblockanm_cannonCharge,y
	km_setval.w	mmx_pwork2,0,y
;'95/7/6: set ich henkou !!
	jsr	Check_PchargeSndPri	;set suru basyoni cyuui !!
	rts
;---------------------------------------------------------------------
pc_waittimer
	longa
	longi
	lda	kx_PlanetcannonTm
	beq	.waitend
	dec	a
	sta	kx_PlanetcannonTm
	clc
	rts
.waitend
	sec
	rts
;=====================================================================
;*								*
;*	Planet Cannon Charge Sound Priority Check		*
;*								*
;=====================================================================

	longa
	longi
Check_PchargeSndPri
	PHX
	km_setval	kx_PlanetcannonTmPriCheck,-1
	km_setval	kx_PlanetcannonPtr,pcchart_nothing

	lda	kx_CorneriaHP
	beq	.END

	ldx	kx_planetlistptr
.LOOP
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_battleship,x
	beq	.NEXT
	km_bitcheckflag16.w	mmx_battleshipflag,mmbsf_cannonareain,x
	bne	.ChargeCheck
.NEXT
	lda.w	mmx_planetnext,x
	tax
	bne	.LOOP

.END
	PLX
	rts

.ChargeCheck
	lda.w	mmx_planetcannontm,x
	cmp	kx_PlanetcannonTmPriCheck	;Time no chiisai houno oto wo dasu (dec timer dakara)!!
	bcs	.NEXT
.Charge
	stx	kx_PlanetcannonListPtr
	sta	kx_PlanetcannonTmPri
	sta	kx_PlanetcannonTmPriCheck
	km_setval	kx_PlanetcannonPtr,pcchart_charge
	bra	.NEXT


;*********************************************************************
;*								*
;*			Satellite Chart				*
;* data bank :7e							*
;*********************************************************************
mm_satellitebeemchart
	php
	ai16
	km_bitcheckmismapchflag	sachartenable
	beq	.end
	km_bitcheckmismapdemoflag	all
	beq	.do_chart
	km_bitcheckmismapdemoflag	satellitebeemdemo
	beq	.end
.do_chart
	lda	kx_SatelliteBeemChart
	asl	a
	tax
	jsr	(.SatelliteSeq,x)
.end
	plp
	rts

.SatelliteSeq
	dw	sa_nothing&WM
	dw	sa_beeminit&WM
	dw	sa_beemfire&WM
	dw	sa_beemexplodewait&WM
	dw	sa_messagewait&WM
;---------------------------------------------------------------------------
	longa
	longi
sa_nothing
	km_bitcheckflag16	kx_satelliteflag,safl_lockon
	bne	.lockon
	rts
.lockon
	km_clrflag16	kx_satelliteflag,safl_lockon	;koko ga ii !! ('95/6/25)
	inc	kx_SatelliteBeemChart	;[mismap.asm]
	inc	kx_satelliteSeq		;[mmtbl.asm]
;---------------------------------------------------------------------------
	longa
	longi
sa_beeminit
.Initial
	km_setmismapchflag	sademowait
	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
	km_setmismapfzflag	gamefreeze
	km_setmismapdemoflag	satellitebeemdemo
	km_setval	kx_MisMapDemoNumber,kdemo_satellitebeemdemo	;[mmtbl de clear]

	jsl	mm_getenemylistptrX_l
	stx	kx_sabeemptr		;satellite beem pointer
	stz.w	mmx_ensequence,x
	stz.w	mmx_entype,x		;tama char !!
;* source *
	ldy	kx_satelliteenptr	;satellite pointer
	lda.w	mmx_enposx,y
	sta.w	mmx_enposx,x
	lda.w	mmx_enposy,y
	sta.w	mmx_enposy,x

	jsr	sa_beemdest

	lda	#sa_beemvel
	sta.w	mmx_envel,x

	km_setflag16.w	mmx_enflags,(enfl_nocollision),x
	km_setflag16.w	mmx_enflags2,(enfl2_nojet),x

	lda	#enstrat_posvel
	sta.w	mmx_enstratptr,x	;stratage pointter

	lda	#sa_beemcoll
	sta.w	mmx_encoll,x		;collision

	km_clrflag16	kx_satelliteflag,safl_tamedama
;* satellite beem sound *
	ksound	system_shot
	inc	kx_SatelliteBeemChart
	rts
;---------------------------------------------------------------------------
	longa
	longi
sa_beemfire
	km_bitcheckflag16	kx_satelliteflag,safl_beemhit
	bne	.hit
	rts
.hit
	km_setflag16	kx_satelliteflag,safl_explodewait
	inc	kx_SatelliteBeemChart
	ksound	en_explode_demo

	ldx	kx_sabeemptr		;satellite beem pointer
	lda	kx_satellitetype
	beq	.attack_enemy
;* attack corneria *
.attackcorneria
	ldy	kx_satelliteenptr
	jsl	SetAttackPoint_l
	km_setval.w	mmx_ensequence,enseq_beemexplodeLtrig,x
	rts

;* attack enemy *
.attack_enemy
	km_setval.w	mmx_ensequence,enseq_beemexplodetrig,x
	ldy	kx_salockonptr
	jsl	mm_freeenemylistptr_l
	rts
;---------------------------------------------------------------------------
	longa
	longi
sa_beemexplodewait
	km_bitcheckflag16	kx_satelliteflag,safl_explodewait
	beq	.finish
	rts
.finish
	lda	kx_satellitetype
	beq	sa_beemfinish

	km_setflag16	map_trigmessage,ymes_sabeemfire
	km_setval	kx_SatelliteBeemChartTm,5*8
	inc	kx_SatelliteBeemChart
;---------------------------------------------------------------------------
	longa
	longi
sa_messagewait
	dec	kx_SatelliteBeemChartTm
	beq	sa_beemfinish
	rts
;---------------------------------------------------------------------------
	longa
	longi
sa_beemfinish
	km_clrmismapdemoflag	satellitebeemdemo
	km_clrmismapchflag	sademowait
	km_clrflag16	kx_satelliteflag,safl_beemhit	;kono flag no clear wa saigo ni shinaito tachippanashi ni naru!!
	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
	stz	kx_SatelliteBeemChart
	rts
;---------------------------------------------------------------------------

;-------------------------------------------------------------
;*		Set Beem destination Postion		*
;-------------------------------------------------------------
	longa
	longi
sa_beemdest
	a8
	lda	kx_satellitetype
	beq	.friend
.enemy
	ldy	kx_CorneriaPtr
	lda.w	mmx_planetcx,y
	sta.w	mmx_endestx,x
	lda.w	mmx_planetcy,y
	sta.w	mmx_endesty,x
	bra	.check_coll
.friend
	ldy	kx_salockonptr
	lda.w	mmx_enposx+1,y
	sta.w	mmx_endestx,x
	lda.w	mmx_enposy+1,y
	sta.w	mmx_endesty,x
.check_coll
	a16
	rts

;-----------------------------------------------------
;*		Satellite Mode Check		*
;-----------------------------------------------------
	IFEQ	1
	km_testkeydown	TLeft
	beq	.skip
	ldy	kx_satelliteptr
	km_clrflag16.w	mmx_enflags2,enfl2_fireenable,y
	km_setval.w	mmx_enwaittm,sa_tametime,y	;reset timer
	km_setval	kx_satelliteSeq,0
	km_clrflag16	kx_satelliteflag,safl_tamedama

	km_setval	kx_satellitetype,0
	km_eorflag16.w	mmx_enflags2,enfl2_tyuuritu,y
	km_bitcheckflag16.w	mmx_enflags2,enfl2_tyuuritu,y
	beq	.friend
	km_setval	kx_satellitetype,2
.friend
.skip
	ENDC
;------------------------------------------------

;*********************************************************************
;*								*
;*			Select Warp Place			*
;* data bank :7e							*
;*********************************************************************
SelectWarpPlace
	php
	a16
	km_bitcheckflag16	mmx_cursorflag,curf_warpselect
	km_beq	.End

	km_testjoypad	kettei
	bne	.Kettei
	km_testjoypad	X
	bne	.Cancell
	km_testjoypad	Right
	bne	.Right
	km_testjoypad	Left
	bne	.Left
	bra	.End
;---------------------------------------------------------------------
.Right
	lda	kx_planetbufnum
	inc	a
	cmp	#7
	bmi	.SetRight
	lda	#0
.SetRight
	sta	kx_planetbufnum

	jsr	CheckWarpPlace
	bcc	.Right
	bra	.SetParams
;---------------------------------------------------------------------
.Left
	lda	kx_planetbufnum
	dec	a
	bpl	.SetLeft
	lda	#6
.SetLeft
	sta	kx_planetbufnum
	jsr	CheckWarpPlace
	bcc	.Left
;---------------------------------------------------------------------
.SetParams
	ksound	star_select
	jsr	SetWarpCursorParams
	bra	.End
;---------------------------------------------------------------------
.Kettei
	km_clrflag16	mmx_cursorflag,curf_warpselect

	lda	kx_planetbufnum
	cmp	kx_mshipcurrentnum
	bne	.End
;---------------------------------------------------------------------
.Cancell
	km_clrflag16	mmx_cursorflag,curf_warpselect	;[Kettei de Set shiteitemo kesuna !!]
	km_clrflag16	mmx_cursorflag2,curf2_hitplanet
	km_setvar	kx_planetbufnum,kx_planetbufnum_bak
	km_setflag16	mmx_cursorflag,curf_warpcancel
;---------------------------------------------------------------------
.End
	plp
	rts

;---------------------------------------------------------------------
;*			Check Cursor Place [For Warp]		*
;---------------------------------------------------------------------
	longa
	longi
CheckWarpPlace
	ldx	kx_planetlistptr
.LOOP
	km_bitcheckflag16.w	mmx_planetflag,(mmpnf_battleship!mmpnf_mothership!mmpnf_finalboss!mmpnf_satellite!mmpnf_itemplanet),x
	bne	.Next
	km_bitcheckflag16.w	mmx_planetflag,(mmpnf_complete),x
	beq	.Next

	lda.w	mmx_name,x
	cmp	kx_planetbufnum
	beq	.Found
.Next
	lda.w	mmx_planetnext,x
	tax
	bne	.LOOP
	clc
	rts

.Found
	stx	kx_warpplaceptr
	sec
	rts
;----------------------------------------------------------------------
	longa
	longi
SetWarpCursorParams
	ldx	kx_warpplaceptr
	lda.w	mmx_name,x
	sta	mmx_planetname

	lda.w	mmx_planetcx,x
	sta	mmx_bigcurposX
	lda.w	mmx_planetcy,x
	sta	mmx_bigcurposY
	rts


;*********************************************************************
;*								*
;*			 OBJ Demo Chart				*
;* data bank :7e							*
;*********************************************************************
objdemotype	macro	[addr]
	dw	(objdemo_{addr}-mm_objdemotypetbl)&WM
	endm
objdemoseq	macro	[addr]
	dw	{addr}&WM
	endm
objdemoseqend	macro
	dw	1
	endm
;=====================================================================
;*								*
;*		OBJ Demo Main Sequence				*
;*								*
;* kx_objdemonumber  :demo number					*
;*		:=0 : end code					*
;*		:=-1: chart syori tyuu				*
;=====================================================================
	longa
	longi
mm_objdemochart

.Initial
	ldx	kx_objdemonumber
	beq	.End
	bmi	.Main

	lda.l	mm_objdemotypetbl,x
	sta	kx_objdemopointer
	km_setval	kx_objdemonumber,-1
.Main	
	ldx	kx_objdemopointer
	ldy	kx_objdemolistptr

	lda.l	mm_objdemotypetbl,x
	dec	a
	beq	.ChartFinish
	pha	;[jump addr]
	rts
.ChartFinish
	km_setval	kx_objdemonumber,0
.End
	rts
;---------------------------------------------------------------------
;*		OBJ DEMO TYPE Table				*
;---------------------------------------------------------------------
mm_objdemotypetbl
	objdemotype	nothing		;00 :(nothing)
	objdemotype	finalwarp	;02 :(mothership)
	objdemotype	returnmap	;04 :(player)
	objdemotype	normalwarp	;06 :(mothership)
	objdemotype	missilefell	;08 :(missile)
	objdemotype	zacoexplode	;0a :(sos zaco)
	objdemotype	enemygone	;0c :(sos zaco)
	objdemotype	wolfgone	;0e :(wolf)
	objdemotype	bshipexplode	;10 :(battleship)
	objdemotype	planetexplode	;12 :(planet)
	objdemotype	wolfexplode	;14 :(wolf team)
	objdemotype	wolfappear	;16 :(wolf boss appear)
	objdemotype	start_easy	;18 :(planet senryou,battleship&zaco&missile appear)
	objdemotype	start_normal	;1a :(planet senryou,battleship&zaco&missile appear)
	objdemotype	start_hard	;1c :(planet senryou,battleship&zaco&missile appear)
	objdemotype	last1warp	;1e :(mothership)
	objdemotype	planethojyuu	;20 :(planet)
	objdemotype	warpcancel	;22 :(mothership)
	objdemotype	runawaywarp	;24 :(mothership)
	objdemotype	partnerchange	;26 :(player)

;---------------------------------------------------------------------
;*		OBJ Demo Chart					*
;---------------------------------------------------------------------
objdemo_nothing
	objdemoseqend

objdemo_returnmap
	objdemoseq	ardemo_returnmaptrig
	objdemoseq	ardemo_returnmap
	objdemoseq	ardemo_partnerwait
	objdemoseqend

objdemo_finalwarp
	objdemoseq	ardemo_returnmothertrig
	objdemoseq	ardemo_returnmotherwait
	objdemoseq	ardemo_partnerwait
	objdemoseq	dm_mshipdisappeartrig
	objdemoseq	dm_animewait
	objdemoseq	dm_mshipwarptrig
	objdemoseq	dm_mshipwarpwait
	objdemoseqend

objdemo_last1warp
	objdemoseq	dm_motherwarpdestpos
	objdemoseq	dm_mshipdisappeartrig
	objdemoseq	dm_animewait
	objdemoseq	dm_mshipwarptrig
	objdemoseq	dm_mshipwarpwait
	objdemoseq	dm_mshipappeartrig
	objdemoseq	dm_animewait
	objdemoseq	dm_warpfinishtrig
	objdemoseq	dm_returnmothertimetrig
	objdemoseq	dm_returnmothertimewait
	objdemoseqend

objdemo_normalwarp
	objdemoseq	dm_setwarpdestpos
	objdemoseq	dm_mshipdisappeartrig
	objdemoseq	dm_animewait
	objdemoseq	dm_mshipwarptrig
	objdemoseq	dm_mshipwarpwait
	objdemoseq	dm_mshipappeartrig
	objdemoseq	dm_mshipanimewait
	objdemoseq	dm_warpfinishtrig

objdemo_warpcancel
	objdemoseq	ardemo_playerwarptrig
	objdemoseq	ardemo_returnmaptrig_mship
	objdemoseq	ardemo_returnmap
	objdemoseq	ardemo_partnerwait
	objdemoseqend

objdemo_runawaywarp
	objdemoseq	dm_setwarpdestpos
	objdemoseq	dm_mshipdisappeartrig
	objdemoseq	dm_animewait
	objdemoseq	dm_mshipwarptrig
	objdemoseq	dm_mshipwarpwait
	objdemoseq	dm_mshipappeartrig
	objdemoseq	dm_mshipanimewait
	objdemoseq	dm_warpfinishtrig
	objdemoseqend

objdemo_missilefell
	objdemoseq	dm_missilefelltrig
	objdemoseq	dm_missilefellwait
	objdemoseqend

objdemo_zacoexplode	
	objdemoseq	dm_sosexpdemotrig
	objdemoseq	dm_animewait
	objdemoseq	dm_sosdisappear
	objdemoseqend

objdemo_wolfexplode
	objdemoseq	dm_wolfexpdemotrig
	objdemoseq	dm_animewait
	objdemoseq	dm_sosdisappear
	objdemoseqend

objdemo_enemygone
	objdemoseq	dm_engonedemotrig
	objdemoseq	dm_engonedemowait
	objdemoseqend

objdemo_wolfgone
	objdemoseq	dm_wolfgonedemotrig
	objdemoseq	dm_engonedemowait
	objdemoseqend

objdemo_bshipexplode	
	objdemoseq	ardemo_returnmaptrig
	objdemoseq	ardemo_returnmap
	objdemoseq	ardemo_partnerwait
	objdemoseq	dm_batexpdemotrig
	objdemoseq	dm_animewait
	objdemoseqend

objdemo_planetexplode
	objdemoseq	ardemo_returnmaptrig
	objdemoseq	ardemo_returnmap
	objdemoseq	ardemo_partnerwait
	objdemoseq	dm_planetexpdemotrig	
	objdemoseq	dm_planetexpdemowait
	objdemoseqend

objdemo_wolfappear
	objdemoseqend


objdemo_start_easy
objdemo_start_normal
objdemo_start_hard
	objdemoseq	dm_bsappeartrig
	objdemoseq	dm_bsappearwait
	objdemoseq	dm_senryouplanettrig
	objdemoseq	dm_senryouplanetwait
	objdemoseq	dm_plappeartrig
	objdemoseq	dm_plappearwait
	objdemoseqend

objdemo_planethojyuu
	objdemoseq	dm_senryouplanettrig
	objdemoseq	dm_senryouplanetwait
	objdemoseq	dm_plappeartrig
	objdemoseqend

objdemo_partnerchange
	objdemoseq	ardemo_joinwait
	objdemoseq	ardemo_swappartnertrig
	objdemoseq	ardemo_swappartner
	objdemoseq	ardemo_joinwait2
	objdemoseqend
;----------------------------------------------------------------------
	longa
	longi
objdemo_next
	inc	kx_objdemopointer
	inc	kx_objdemopointer
	rts
;----------------------------------------------------------------------
	longa
	longi
dm_animewait
	lda.w	mmx_enwaittm,y
	dec	a
	sta.w	mmx_enwaittm,y
	beq	.objdemo_next
	rts
.objdemo_next
	bra	objdemo_next
;---------------------------------------------------------------
	longa
	longi
dm_bsappeartrig
	jsr	SetBattleShip
	km_stxval	mmx_expwaitcnt,2	;explain demo wait counter (sos no kazu)
	km_clrflag16.w	kw_MisMapFreezeFlag,kfz_enemyfreeze
	bra	objdemo_next
;---------------------------------------------------------------
	longa
	longi
dm_plappeartrig
	km_stxval	mmx_expwaitcnt,1	;explain demo wait counter (sos no kazu)
	ldx	kdifficulty
	km_loblda.l	pl_senryoukazutbl,x
	sta	mmx_senryoucnt
	jsr	SenryouPlanet
	bra	objdemo_next

pl_senryoukazutbl

	db	planetkazu_easy
	db	planetkazu_normal
	db	planetkazu_hard_1st
;---------------------------------------------------------------
dm_bsappearwait
dm_plappearwait
	lda	mmx_expwaitcnt
	beq	.finish
	rts
.finish
	bra	objdemo_next
;---------------------------------------------------------------
	longa
	longi
dm_senryouplanettrig
	ldx	kdifficulty
	km_loblda.l	pl_senryoukazutbl,x
	sta	mmx_senryoucnt		;Senryou sareru Planet no Kazu
	sta	mmx_specialapcocnt
	sta	kcounter

	ldx	kx_senryoustgptr	;<<< Planet Stage Pattern Pointer
.LOOP
	stx	kx_objdemolistptr
	km_loblda.l	randomtbl,x
	sta	kpointer

	ldy	kx_planetlistptr
.Planet_Search
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,y
	beq	.tugino_kouhochi

	lda.w	mmx_stage,y
	cmp	kpointer
	bne	.tugino_kouhochi
.Found_planet
	tyx
	jsr	InitWolfTeam2
	txy

	dec	kcounter	
	beq	.Finish

	ldx	kx_objdemolistptr
	inx
	BRA	.LOOP
.tugino_kouhochi
	lda.w	mmx_planetnext,y
	tay
	bne	.Planet_Search
.Finish
	km_setval	kx_MisMapDemoNumber,kdemo_wolfbossdemo
	brl	objdemo_next
;---------------------------------------------------------------
	longa
	longi
dm_senryouplanetwait
	lda	mmx_specialapcocnt
	beq	.finish
	rts
.finish
	km_setval	kx_MisMapDemoNumber,kdemo_nothing
	brl	objdemo_next
;---------------------------------------------------------------
	longa
	longi
dm_returnmothertimetrig
	km_setval	kx_objdemowaittm,30
	km_stxval	mmx_arwingsp,arwingspeed
	bra	ardemo_returnmothertrig_common

ardemo_returnmothertrig
;kono speed wo hayaku surutokiwa tyuui !!
;partner ga collision check ni ataranaku naru !!
	km_stxval	mmx_arwingsp,arwingspeed*4

ardemo_returnmothertrig_common
	km_setflag16	mmx_arwingflag,(mmf_initmove!mmf_go!mmf_demo!mmf_nocoll)
	km_setvar	mmx_arwingdestposx,kx_mshipx
	km_setvar	mmx_arwingdestposy,kx_mshipy
	jsr	mm_calcplayerangle	;[player angle]
	jsr	mm_calcplayercgxptr	;[player cgx ptr]
	brl	objdemo_next

	longa
	longi
ardemo_returnmotherwait
	jsr	mm_demomoveplayer_sub
	jsr	ardemo_collcheck
	bcs	.finish
	rts
.finish
	km_clrflag16	mmx_arwingflag,mmf_go	;Stop Arwing
	km_setflag16	mmx_arwingflag,mmf_notdisplay

	ldy	kx_MotherShipEnPtr
	km_setval.w	mmx_endestx,enemybaseX,y
	km_setval.w	mmx_endesty,enemybaseY,y
	brl	objdemo_next

	longa
	longi
dm_returnmothertimewait
	jsr	mm_demomoveplayer_sub
	dec	kx_objdemowaittm	;kx_mismapdemotm
	beq	.finish
	rts
.finish
	brl	objdemo_next
;----------------------------------------------------------------------
	longa
	longi
dm_setwarpdestpos
	ldx	kx_warpplaceptr
	ldy	kx_MotherShipEnPtr
	a8
	lda.w	mmx_planetcx,x
	sta	kx_mshipx
	sta.w	mmx_endestx,y
	lda.w	mmx_planetcy,x
	sta.w	mmx_endesty,y
	sta	kx_mshipy
	a16
	brl	objdemo_next

	longa
	longi
dm_warpfinishtrig
	ldx	kx_MotherShipPlPtr
	ldy	kx_MotherShipEnPtr
	a8
	lda	kx_mshipx
	sta.w	mmx_planetcx,x
	sta.w	mmx_enposx+1,y

	lda	kx_mshipy
	sta.w	mmx_planetcy,x
	sta.w	mmx_enposy+1,y
	a16
	km_clrflag16.w	mmx_enflags,enfl_demo,y	;[demo off]
	brl	objdemo_next

	longa
	longi
dm_mshipdisappeartrig
	ldy	kx_MotherShipEnPtr
	km_setval.w	mmx_enanmpatt,cd_objanime_mothership_dap,y
	ksound	mother_ship_warp
	bra	dm_mshipcommon

	longa
	longi
dm_mshipappeartrig
	ldy	kx_MotherShipEnPtr
	km_setval.w	mmx_enanmpatt,cd_objanime_mothership_app,y

	ksound	en_b_ship_appear
	bra	dm_mshipcommon

dm_mshipcommon
	km_setflag16.w	mmx_enflags,enfl_demo,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_enwaittm,24,y
	sta.w	mmx_enanmmax,y
	sty	kx_objdemolistptr
	brl	objdemo_next
;----------------------------------------------------------------------
	longa
	longi
dm_mshipwarptrig
	ldy	kx_MotherShipEnPtr
	km_setval.w	mmx_enanmpatt,-1,y
	jsl	calc_enangvelxy_l
	ksound	en_sos_appear
	brl	objdemo_next

	longa
	longi
dm_mshipwarpwait
	ldy	kx_MotherShipEnPtr
	jsl	Setenemypostion_l
	jsl	check_enemyarrive_l
	bcs	.finish
	rts
.finish
	a8
	lda.w	mmx_endestx,y
	sta.w	mmx_enposx+1,y
	lda.w	mmx_endesty,y
	sta.w	mmx_enposy+1,y
	a16
	km_setval.w	mmx_enanmpatt,0,y
	brl	objdemo_next
;----------------------------------------------------------------------
	longa
	longi
dm_motherwarpdestpos
	ldy	kx_MotherShipEnPtr
	km_setvar	kz_x1,mmx_arwingposx+1
	sta	mmx_posxbak
	km_setvar	kz_y1,mmx_arwingposy+1
	sta	mmx_posybak

	km_setval	kz_tpx,$18
	km_setval	kz_tpy,$18
	jsr	SetNearPos
	km_setvar	kx_mshipx,kz_tpx
	km_setvar	kx_mshipy,kz_tpy
	brl	objdemo_next
;----------------------------------------------------------------------
	longa
	longi
dm_mshipanimewait
	lda.w	mmx_enwaittm,y
	dec	a
	sta.w	mmx_enwaittm,y
	beq	.objdemo_next
	rts
.objdemo_next
	km_clrflag16.w	mmx_enflags,enfl_demo,y	;[demo off]
	brl	objdemo_next
;----------------------------------------------------------------------
	longa
	longi
ardemo_playerwarptrig

;* BG check & Arwing Angle Calc Params Initial *
	stz	kz_x1
	stz	kz_y1
	stz	kz_x2
	stz	kz_y2

	a8
	lda	kx_mshipx
	sta	mmx_arwingposx+1
	sta	mmx_partnerposx+1
	sta	kz_x1

	lda	kx_mshipy
	sta	mmx_arwingposy+1
	sta	mmx_partnerposy+1
	sta	kz_y1
	a16

	jsl	mm_BGCheck_l
	cmp	#0
	beq	.corneriain
	cmp	#8
	beq	.corneriain
.space
	ldx	kx_CorneriaPtr
	bra	.skipa
.corneriain
	ldx	kx_FinalBossPlPtr
.skipa
	a8
	lda.w	mmx_planetcx,x
	sta	mmx_arwingdestposX
	sta	kz_x2

	lda.w	mmx_planetcy,x
	sta	mmx_arwingdestposY
	sta	kz_y2
	a16

	jsr	kconv_PlayerPosToAngY
	brl	objdemo_next

	longa
	longi
kconv_PlayerPosToAngY
;Input :(kz_x1,kz_y1) (kz_x2,kz_y2)

;---------------
	IFEQ	1
	km_loblda	mmx_arwingposx+1
	sta	kz_x1
	km_loblda	mmx_arwingposy+1
	sta	kz_y1
	km_loblda	mmx_arwingdestposX
	sta	kz_x2
	km_loblda	mmx_arwingdestposY
	sta	kz_y2
	ENDC
;---------------
	jsr	calcarwingangle

	km_setvar	mmx_arwingangy,kz_tpy
	km_setvar	mmx_arwinganmptr,kz_tpa		;angle pointer (16 pattern) 0,1,2,3,...15
	km_setvar	mmx_partnerangy,kz_tpy
	km_setvar	mmx_partneranmptr,kz_tpa	;angle pointer (16 pattern) 0,1,2,3,...15
	rts
;----------------------------------------------------------------------
	longa
	longi
ardemo_returnmaptrig_mship
	km_setval	mmx_arwingdemotimer,15
	bra	ardemo_returnmaptrig_common
ardemo_returnmaptrig
	km_setval	mmx_arwingdemotimer,25
ardemo_returnmaptrig_common
	km_clrflag16.w	mmx_arwingflag,mmf_notdisplay
	km_clrmismapfzflag	playerfreeze
	km_setflag16	mmx_arwingflag,mmf_demo

	ifeq	kinagaki
	ksound	map_run_away
	endc

	km_setval	mmx_arwingdemoptr,ardm_returnmap
	a16
	km_setflag16	mmx_arwingflag,(mmf_initmove!mmf_go)
	km_stxval	mmx_arwingsp,arwingreturnspeed
	brl	objdemo_next

	longa
	longi
ardemo_returnmap
	dec	mmx_arwingdemotimer
	beq	.finish
	jsr	mm_demomoveplayer_sub
	rts
.finish
	km_clrflag16	mmx_arwingflag,(mmf_initmove!mmf_go)
	brl	objdemo_next

	longa
	longi
ardemo_partnerwait
	km_bitcheckflag16	 mmx_partnerflag,mmf_go
	beq	.finish
	rts
.finish
	km_stxval	mmx_arwingsp,arwingspeed
	km_clrflag16	mmx_arwingflag,mmf_demo
	brl	objdemo_next

	longa
	longi
ardemo_joinwait
	km_bitcheckflag16	 mmx_partnerflag,mmf_go
	bne	.rts
	km_bitcheckflag16	 mmx_partnerflag,mmf_notdisplay
	bne	.finish
.rts
	rts
.finish
	brl	objdemo_next

ardemo_swappartnertrig
	km_setflag16	mmx_arwingflag,mmf_demo
	km_setflag16	mmx_partnerflag,mmf_demo
	km_clrflag16	mmx_partnerflag,mmf_notdisplay

	km_stxval	mmx_arwingsp,arwingreturnspeed
	km_stxval	mmx_partnersp,-arwingreturnspeed
	km_setval	mmx_arwingdemotimer,256/8
	km_setvar	kx_objdemocx,mmx_arwingposx
	km_setvar	kx_objdemocy,mmx_arwingposy
	brl	objdemo_next

ardemo_swappartner
	lda.w	mmx_arwingangY
	clc
	adc	#$800
	sta.w	mmx_arwingangY

	lda.w	mmx_partnerangY
	adc	#$800
	sta.w	mmx_partnerangY

	dec	mmx_arwingdemotimer
	beq	.finish
	jsr	ArwingAngVeltoPos
	jsr	PartnerAngVeltoPos
	rts
.finish
	km_setvar	mmx_arwingposx,kx_objdemocx
	sta	mmx_partnerposx
	km_setvar	mmx_arwingposy,kx_objdemocy
	sta	mmx_partnerposy
	km_setval	mmx_arwingsp,arwingspeed
	sta	mmx_partnersp
	km_clrflag16	mmx_arwingflag,mmf_demo
	km_clrflag16	mmx_partnerflag,mmf_demo
	brl	objdemo_next

	longa
	longi
ardemo_joinwait2
	km_setvar	mmx_partnerposx,mmx_arwingposx
	km_setvar	mmx_partnerposy,mmx_arwingposy
	km_clrflag16	mmx_partnerflag,mmf_demo
	brl	objdemo_next
;---------------------------------------------------------------
	longa
	longi
dm_missilefelltrig
	ldy	kx_SOSEnemyPtr
	jsl	kmissilefell_sub_l
	km_stxval	kx_playerdemowait,1
	brl	objdemo_next
;---------------------------------------------------------------------
dm_missilefellwait
	lda	kx_playerdemowait
	beq	.finish
	rts
.finish
	brl	objdemo_next
;---------------------------------------------------------------------
	longa
	longi
dm_sosexpdemotrig
	km_styvar	kx_objdemolistptr,kx_SOSEnemyPtr  ;[For Anime Wait]
	jsr	mm_explode_zaco
	ksound	en_explode_demo
	brl	objdemo_next
;---------------------------------------------------------------------
	longa
	longi
dm_wolfexpdemotrig
	km_styvar	kx_objdemolistptr,kx_RannyuEnemyptr  ;[For Anime Wait]

	ldx.w	mmx_enlinkptr,y
	km_clrflag16.w	mmx_planetflag,mmpnf_wolfprotect,x

	km_bitcheckflag16.w	mmx_enflags2,enfl2_planetprotect,y
	bne	.skip
;* moshi free jyoutai no wolf team wo taoshitara !! *
	km_clrmismapflag2	wolffreecurrent
	dec	kx_wolffreestock
	bne	.skip
	km_clrmismaptrflag	wolffree
.skip
	jsr	mm_explode_zaco
	ksound	en_explode_demo
	brl	objdemo_next
;---------------------------------------------------------------------
	longa
	longi
dm_sosdisappear
	jsl	mm_freeenemylistptr_l
	brl	objdemo_next
;---------------------------------------------------------------------
	longa
	longi
dm_engonedemotrig
	km_styvar	kx_objdemolistptr,kx_SOSEnemyPtr
	bra	dm_engonedemotrig_common

dm_wolfgonedemotrig
	km_styvar	kx_objdemolistptr,kx_RannyuEnemyptr

	longa
	longi
dm_engonedemotrig_common
	km_bitcheckflag16.w	mmx_enflags,enfl_wolf,y
	beq	.normal_zaco
;------------------------
.wolfteam
	km_bitcheckflag16.w	mmx_enflags2,enfl2_planetprotect,y
	bne	.protect
.free
	km_setmismapstflag	wolfgone

	lda.w	mmx_enstratptr,y
	sta	kx_wolfgonestratptr_bak
	km_setval.w	mmx_enstratptr,enstrat_straight,y
	
	lda	#60
	bra	.next
.protect
	km_setval	kx_objdemowaittm,1
	brl	objdemo_next
;------------------------
.normal_zaco
	km_bitcheckflag16.w	mmx_enflags,enfl_attackcorneria,y
	bne	.attack_corneria
.normal_move
	km_setmismapstflag	speedup

	lda	#40
	bra	.next
.attack_corneria
	lda	#30
.next
	sta	kx_objdemowaittm

;* run away sound *
.sound
	ksound	map_run_away
.end
	brl	objdemo_next
;---------------------------------------------------------------------
	longa
	longi
dm_engonedemowait
	dec	kx_objdemowaittm
	bne	.gone_enemy

	km_bitcheckmismapstflag	wolfgone
	beq	.skip
	km_clrmismapstflag	wolfgone
	lda	kx_wolfgonestratptr_bak
	sta.w	mmx_enstratptr,y
.skip
	km_clrmismapstflag	speedup
	brl	objdemo_next

	longa
	longi
.gone_enemy
	jsl	mm_enemydemoseqmovecoll_l
	rts
;---------------------------------------------------------------------
	IFEQ	1
.gone_enemy
	km_bitcheckflag16.w	mmx_enflags,enfl_attackcorneria,y
	bne	.attack_corneria
	jsl	Setenemypostion_l

;;;	jsl	enmv_searchplanet_l
	rts

	longa
	longi
.attack_corneria
	jsl	enmv_aroundplanet_l
	rts
	ENDC

;---------------------------------------------------------------------
	longa
	longi
dm_batexpdemotrig
	km_styvar	kx_objdemolistptr,kx_SOSEnemyPtr
	jsr	mm_explode_bship
	ksound	en_explode_demo
	brl	objdemo_next
;---------------------------------------------------------------------
	longa
	longi
dm_planetexpdemotrig
	ldy	mmx_arwingdestptr	;Planet List Pointer
	km_setflag16.w	mmx_planetflag,mmpnf_dakkan,y
	km_setval.w	mmx_dokuroanm,cd_objanime_explode_planet,y
	km_setval.w	mmx_timer2,0,y

	km_setval	kx_objdemowaittm,(73-1)
	ksound	en_explode_demo
	brl	objdemo_next
;---------------------------------------------------------------------
	longa
	longi
dm_planetexpdemowait
	dec	kx_objdemowaittm	;kx_mismapdemotm
	beq	.finish
	rts
.finish
	ldy	mmx_arwingdestptr	;Planet List Pointer
	km_clrflag16.w	mmx_planetflag,mmpnf_dakkan,y
	brl	objdemo_next

;---------------------------------------------------------------------
;*			Move Player Sub Routine			*
;---------------------------------------------------------------------
	longa
	longi
ardemo_collcheck
	km_lobstavar	kz_x1,mmx_arwingposx+1
	km_lobstavar	kz_y1,mmx_arwingposy+1
	km_lobstavar	kz_x2,mmx_arwingdestposx
	km_lobstavar	kz_y2,mmx_arwingdestposy
	km_setval	kz_z1,4
	a8
	jsr		mm_checkcollision
	a16
	rts

;---------------------------------------------------------------------
;*		Arwing Near Postion Set				*
;* Input :kz_x1 :Offset X zahyou					*
;*       :kz_y1 :Offset Y zahyou					*
;*       :kz_tpx:syuusei X value					*
;*       :kz_tpy:syuusei Y value					*
;---------------------------------------------------------------------
	LONGA
	LONGI
SetNearPos
	a8
;*** X pos ***
	lda	kz_x1
;;;	lda	mmx_arwingposx+1
	cmp	#$80
	bcc	.leftside
.rightside
	sec
	sbc	kz_tpx
	bra	.setx
.leftside
	clc
	adc	kz_tpx
.setx
	sta.w	mmx_endestx,y
	sta	kz_tpx

;*** Ypos ***
	lda	kz_y1
;;;	lda	mmx_arwingposy+1
	cmp	#$60
	bcs	.downside
.upside
	clc
	adc	kz_tpy
	bra	.sety
.downside
	sec
	sbc	kz_tpy
.sety
	sta.w	mmx_endesty,y
	sta	kz_tpy
	a16
	rts
;*********************************************************************
;*								*
;*			SOS Demo Sequence			*
;* data bank :7e							*
;*********************************************************************
	longa
	longi
mm_sosdemosequence
	ldx	kx_MisMapDemoNumber
	jsr	(.seqtable,x)
	rts
.seqtable
	dw	mm_nothing&WM
	dw	mm_missilefell&WM
	dw	mm_missileall&WM
	dw	mm_battleshiphojyuudemo&WM
	dw	mm_satellitebeemdemo&WM
	dw	mm_specialenemy&WM
	dw	mm_wolfbossdemo&WM
;-------------------------------------------
mm_nothing
	rts
;-------------------------------------------
mm_specialenemy
	ldy	kx_enlistptr
.LOOP
	ldx.w	mmx_ennext,y
	PHX	;>>> PUSH Next Pointer

	km_bitcheckflag16.w	mmx_enflags,enfl_special,y
	beq	.next
	jsl	mm_enemydemoseqmove_l
.next
	PLY
	bne	.loop
	rts

;-------------------------------------------
	longa
	longi
mm_battleshiphojyuudemo
	jsl	mm_BattleShipSequence_l

	ldy	kx_enlistptr
.LOOP
	ldx.w	mmx_ennext,y
	PHX	;>>> PUSH Next Pointer

	km_bitcheckflag16.w	mmx_enflags,(enfl_zaco),y
	beq	.move

	jsl	mm_enemydemosequence_l

.move
	km_bitcheckflag16.w	mmx_enflags,(enfl_zaco!enfl_battleship),y
	beq	.next
	jsl	mm_enemydemomove_l
.next
	PLY
	bne	.loop

	rts
;-------------------------------------------
	longa
	longi
mm_missilefell
	ldy	kx_SOSEnemyptr	;enemy List pointer
	jsl	mm_enemydemoseqmove_l
	rts

;-------------------------------------------
	longa
	longi
mm_missileall
	jsl	mm_PlanetSequence_l

	ldy	kx_enlistptr
.LOOP
	ldx.w	mmx_ennext,y
	PHX	;>>> PUSH Next Pointer

	km_bitcheckflag16.w	mmx_enflags,enfl_missile,y
	beq	.next

	jsl	mm_enemydemoseqmove_l

.next
	PLY	;<<< PULL Next Pointer
	bne	.LOOP
	rts
;-------------------------------------------
mm_wolfbossdemo
	ldy	kx_enlistptr
.LOOP
	ldx.w	mmx_ennext,y
	PHX	;>>> PUSH Next Pointer

	km_bitcheckflag16.w	mmx_enflags,enfl_wolf,y
	beq	.next

	jsl	mm_enemydemoseqmove_l
.next
	PLY
	bne	.loop
	rts
;-------------------------------------------
	longa
	longi
mm_satellitebeemdemo
;collision check wo shitekara move suru !!
	ldy	kx_sabeemptr
	jsl	mm_enemydemoseqmove_l
	ldx	kx_sabeemptr		;satellite beem pointer
	jsr	sa_beemdest
	jsr	mm_enemycollisioncheck
	bcs	.finsh
	rts
.finsh
	km_setflag16	kx_satelliteflag,safl_beemhit
	rts

;*********************************************************************
;*								*
;*			Collision Check Routine			*
;*								*
;*********************************************************************
	longa
	longi
mm_enemycollisioncheck
	a8
	lda.w	mmx_enposx+1,x
	sta	kz_x1
	lda.w	mmx_enposy+1,x
	sta	kz_y1
	lda.w	mmx_endestx,x
	sta	kz_x2
	lda.w	mmx_endesty,x
	sta	kz_y2
	lda.w	mmx_encoll,x		;collision
	sta	kz_z1
	jsr	mm_checkcollision
	a16
	rts
;---------------------------------------------------------------------
;*			Move Player Sub Routine			*
;---------------------------------------------------------------------
	longa
	longi
mm_demomoveplayer_sub
	a16
	lda	mmx_arwingsp
	km_nega
	sta	kz_x1
	lda	mmx_arwingangy+1	;(HI byte ha nandemo yoi)
	sta	kz_y1
	jsr	calcarwingxyvelocity
	lda	kz_tpx+1
	sta	mmx_arwingspx
	lda	kz_textpt+1
	sta	mmx_arwingspy
;* calc arwing anm pattern *
	a8
	lda	mmx_arwingangy+1	;(HI byte ha nandemo yoi)
	clc
	adc	#8
	km_divu16
	sta	mmx_arwinganmptr
	jsr	mm_calcplayercgxptr	;[player cgx ptr]

;* set partner postion *
	a16
	lda	mmx_arwingposx
	clc
	adc	mmx_arwingspx
	cmp	#screen_leftedge<<8
	bcc	.notset_xpos
	cmp	#screen_rightedge<<8
	bcs	.notset_xpos
	sta	mmx_arwingposx
.notset_xpos
	lda	mmx_arwingposy
	clc
	adc	mmx_arwingspy
	cmp	#screen_topedge<<8
	bcc	.notset_ypos
	cmp	#screen_bottomedge<<8
	bcs	.notset_ypos
	sta	mmx_arwingposy
.notset_ypos
	rts
;---------------------------------------------------------------------

;---------------------------------------------------------------------
mm_explode_zaco
	longa
	longi
	km_setval.w	mmx_enanmpatt,cd_objanime_explode_zaco,y
	km_setval.w	mmx_enwaittm,(64-1),y
	sta.w	mmx_enanmmax,y
	bra	mm_explode_common
mm_explode_bship
	longa
	longi
	km_setval.w	mmx_enanmpatt,cd_objanime_explode_bship,y
	km_setval.w	mmx_enwaittm,(76-1-5),y
	sta.w	mmx_enanmmax,y
	bra	mm_explode_common
mm_explode_common
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setflag16.w	mmx_enflags,(enfl_nocollision!enfl_demo),y
	km_setval.w	mmx_ensequence,enseq_explodedemo,y
	rts



	IFEQ	1
;---------------------------------------------------------------
ardemo_rushboss
	jsr	mm_demomoveplayer_sub
	jsr	ardemo_collcheck
	bcs	.finish
	rts
.finish
	km_stxval	mmx_arwingdemotimer,256/4
	brl	objdemo_next
;---------------------------------------------------------------
	longa
	longi
ardemo_loopmove
	lda	mmx_arwingdemotimer
	dec	a
	sta	mmx_arwingdemotimer
	beq	.finish
	lda	mmx_arwingangY
	clc
	adc	#$400
	sta	mmx_arwingangY
	jsr	mm_demomoveplayer_sub
	rts
.finish
	km_setvar	mmx_arwingdestposx,kx_mshipx
	km_setvar	mmx_arwingdestposy,kx_mshipy
	km_clrflag16	mmx_arwingflag,mmf_nocoll
	brl	objdemo_next
;---------------------------------------------------------------
	longa
	longi
ardemo_checkmother
	jsr	mm_demomoveplayer_sub
	jsr	ardemo_collcheck
	bcs	.finish
	rts
.finish
	brl	objdemo_next
;---------------------------------------------------------------
	ENDC

;=====================================================================
;*		Initial Cursor Demo Postion			*
;=====================================================================
initpos_cursordemo
	longa
	longi

	ldx	#0
	ldy	#0
.loop
	km_loblda	mmx_arwingposx+1
	clc
	adc.l	cursorpostblX,x
	sta.w	mmx_curdemox+1,y

	km_loblda	mmx_arwingposy+1
	clc
	adc.l	cursorpostblY,x
	sta.w	mmx_curdemoy+1,y

	lda.l	cursormovetblX,x
	sta.w	mmx_curdemovx,y
	a8
	lda.l	cursorsigntblX,x
	sta.w	mmx_curdemovx_h,y
	a16

	lda.l	cursormovetblY,x
	sta.w	mmx_curdemovy,y
	a8
	lda.l	cursorsigntblY,x
	sta.w	mmx_curdemovy_h,y
	a16

	lda.l	cursorchartbl,x
	sta.w	mmx_curdemochar,y

	tya
	clc
	adc	#curdemoworklen
	tay

	inx
	inx
	cpx	#(cursorpostblXEND-cursorpostblX)&WM
	bne	.loop
	rts
;=====================================================================
;*								*
;*			Data Table				*
;*								*
;=====================================================================
cursorpostblX
	dw	(-init_cursorwidth)
	dw	(init_cursorwidth)
	dw	(-init_cursorwidth)
	dw	(init_cursorwidth)
cursorpostblXEND

cursorpostblY
	dw	(-init_cursorwidth)
	dw	(-init_cursorwidth)
	dw	(init_cursorwidth)
	dw	(init_cursorwidth)

cursormovetblX
	dw	cursor_vel
	dw	-cursor_vel
	dw	cursor_vel
	dw	-cursor_vel

cursorsigntblX
	dw	(cursor_vel&$ffff0000)>>16
	dw	((-cursor_vel)&$ffff0000)>>16
	dw	(cursor_vel&$ffff0000)>>16
	dw	((-cursor_vel)&$ffff0000)>>16

cursormovetblY
	dw	cursor_vel
	dw	cursor_vel
	dw	-cursor_vel
	dw	-cursor_vel

cursorsigntblY
	dw	(cursor_vel&$ffff0000)>>16
	dw	(cursor_vel&$ffff0000)>>16
	dw	((-cursor_vel)&$ffff0000)>>16
	dw	((-cursor_vel)&$ffff0000)>>16

cursorchartbl
	SprChrDataW	$2c,colpal5,pri3,noflip,mm_obj_offset
	SprChrDataW	$2c,colpal5,pri3,xflip,mm_obj_offset
	SprChrDataW	$2c,colpal5,pri3,yflip,mm_obj_offset
	SprChrDataW	$2c,colpal5,pri3,xyflip,mm_obj_offset


;*****************************************************************************
;*									*
;*									*
;*			Arwing Move					*
;*									*
;*									*
;*****************************************************************************
;=====================================================================
;*		Check Arwing Destination Postion		*
;* data bank :7e							*
;=====================================================================
	longa
	longi
mm_checkplayerdestpos
;(chirari to planet or battle ship ga deteitano wa kono check ga nakatta tame !!)
	km_bitcheckmismapflag	battleplayer	;[player ga mission tyuu no flag]
	bne	.end	;(moshi kono check wo shinaito return map shitatoki demo cyuu ni arwing dest pointer wo kaete imau !!)

	km_bitcheckflag16	mmx_arwingflag,mmf_initmove
	beq	.end
 	km_bitcheckmismapflag	finalboss
	bne	.finalboss
	km_bitcheckflag16	mmx_cursorflag2,curf2_hitplanet
	beq	.notplanet	;Not Big Cursor

	a8
	ldy	kx_currentplanetptr	;Planet List Pointer
	lda.w	mmx_planetcx,y	;planet center Y
	sta	mmx_arwingdestposx
	lda.w	mmx_planetcy,y	;planet center X
	sta	mmx_arwingdestposy
	a16

;* Moshi Planet no baai !!! *
;95/2/25 :Flag ga tatta mama nanode 1 do clear shiteoku !!
	km_clrflag16	mmx_cursorflag2,(curf2_goplanet!curf2_gomothership)

	km_bitcheckflag.w	mmx_planetflag,(mmpnf_mothership),y
	bne	.mothership
	km_bitcheckflag.w	mmx_planetflag,(mmpnf_complete!mmpnf_corneria!mmpnf_mothership!mmpnf_battleship),y
	bne	.end
	sty	mmx_arwingdestptr	;Planet Destnition Pointer
	km_setflag16	mmx_cursorflag2,curf2_goplanet
	bra	.end
.mothership
	km_setflag16	mmx_cursorflag2,curf2_gomothership
	bra	.end
;-------------------------------------------------------------------------
.notplanet
	longa
	km_clrflag16	mmx_cursorflag2,(curf2_goplanet!curf2_gomothership)
	a8
	km_setvar	mmx_arwingdestposX,mmx_curposx
	km_setvar	mmx_arwingdestposY,mmx_curposy
	bra	.end
;-------------------------------------------------------------------------
.finalboss
	a8
	ldy	kx_FinalBossEnPtr
	lda.w	mmx_enposx+1,y
	sta	mmx_arwingdestposx
	lda.w	mmx_enposy+1,y
	sta	mmx_arwingdestposy
.end
	a16
	rts

;=====================================================================
;*		Calculate Arwing Angle	(16 pattern)		*
;* data bank :7e							*
;=====================================================================
	longa
	longi
mm_calcplayerangle
	longi
	km_bitcheckflag16	mmx_arwingflag,mmf_initmove
	km_bne	.Set_dest

;* moshi arwing ga idou tyu dattra !! *
	km_bitcheckflag16	mmx_arwingflag,mmf_go
	km_bne	.end

	km_lobstavar	x2,mmx_curposx
	km_lobstavar	y2,mmx_curposy
	bra	.SetSource
.Set_dest
	km_lobstavar	x2,mmx_arwingdestposx
	km_lobstavar	y2,mmx_arwingdestposy
.SetSource
	km_lobstavar	x1,mmx_arwingposx+1
	km_lobstavar	y1,mmx_arwingposy+1
;--------------------------------------------------------------------
.CheckDistance
;( source pos = dest pos )
	km_subvar	x1,x2
	bne	.CalcAngle
	km_subvar	y1,y2
	bne	.CalcAngle
	bra	.end

;(2 ten kan no kyori ga 8 ika ni nattara !!)
;	km_abssubvar	x1,x2
;	cmp	#8
;	bpl	.CalcAngle
;------------------------------------
;	km_abssubvar	y1,y2
;	cmp	#8
;	bpl	.CalcAngle
;	bra	.end
;--------------------------------------------------------------------
.CalcAngle
	jsr	calcarwingangle
	km_setvar	mmx_arwingangy,kz_tpy
	km_setvar	mmx_arwinganmptr,kz_tpa		;angle pointer (16 pattern) 0,1,2,3,...15

	km_bitcheckflag16	mmx_partnerflag,(mmf_go!mmf_demo)
	bne	.skip_partnerang
	km_setvar	mmx_partnerangy,kz_tpy
	km_setvar	mmx_partneranmptr,kz_tpa	;angle pointer (16 pattern) 0,1,2,3,...15
.skip_partnerang
.end
	a16
	rts





	IFEQ	1
.go_planet
;* cursor hit check *
	km_bitcheckflag16	mmx_cursorflag,curf_hitplanet
	bne	.go_planet
;* key push check *
	km_bitcheckflag16	mmx_cursorflag,curf_keypush
	bne	.go_planet
;* 360 kuru kuru turn *
	km_subltsmintomax	mmx_arwinganmtm,1,0,8
	cmp	#8
	bne	.end
	km_addgeumaxtomin	mmx_arwinganmptr,1,$10,0
	bra	.end

	km_testjoypad	TLeft
	beq	.skip1
	km_addgeumaxtomin	mmx_arwinganmptr,1,$10,0
.skip1

	km_testjoypad	TRight
	beq	.skip2
	km_subltsmintomax	mmx_arwinganmptr,1,0,$0f
.skip2
	bra	.end
	ENDC

;=============================================================================
;*									*
;*		Calc Arwing Angle&Animation Pattern			*
;* Input  :kz_x1  <<< source postion X					*
;*        :kz_y1  <<< source postion Y					*
;*        :kz_x2  <<< dest postion X						*
;*        :kz_y2  <<< dest postion Y						*
;* OutPut :kz_tpy <<< search angle						*
;*        :kz_tpa <<< animation pointer					*
;=============================================================================
	longa
	longi
calcarwingangle
	jsl	calobjangle_l
;-----------------------------------
; 0 to 359 degrees is $0000 to $ffff
;-----------------------------------
; 4 sya 5 nyuu
	bit	#$0080
	beq	.nostepup
	inc	a
.nostepup
;-----------------------------------
	sta	kz_tpy
	xba
	clc
	adc	#8
	km_loba
	km_divu16
	sta	kz_tpa
	rts

;=============================================================================
;*									*
;*		Calc Arwing Angle&Animation Pattern			*
;* Input  :kz_x1  <<< basic velocity						*
;*        :kz_y1  <<< angle Y (Hi Byte ha nandemo yoi)			*
;* OutPut :kz_tpx   (3 byte) <<< velocity X					*
;*        :kz_textpt(3 byte) <<< velocity Y					*
;=============================================================================
	longa
	longi
calcarwingxyvelocity
	jsl	conv_velxy_l

	IFNE	kspeedup
	km_bitcheckflag16	mmx_arwingflag,mmf_initmove
	bne	.notspeedup
	km_bitcheckmismapstflag	arwingspup	;speedup
	beq	.notspeedup
	asl	kz_tpx
	rol	kz_tpx+2
	asl	kz_tpx
	rol	kz_tpx+2
	asl	kz_tpx
	rol	kz_tpx+2

	asl	kz_textpt
	rol	kz_textpt+2
	asl	kz_textpt
	rol	kz_textpt+2
	asl	kz_textpt
	rol	kz_textpt+2
.notspeedup
	ENDC
	rts

;=============================================================================
;*									*
;*		Calculate Arwing CGX Pointer				*
;* data bank :7e								*
;=============================================================================
mm_calcplayercgxptr
;* kuru kuru Arwing Chara CGXAddress Calc *
	php
	a16
	longi
	lda	p1_pilotNo
	sta	kz_x1
	km_loblda	mmx_arwinganmptr
	sta	kz_y1
	jsr	mm_calcplayercgxptr_sub
	stx	mm_arwingcgxptr1
	sty	mm_arwingcgxptr2
	plp
	rts

;=============================================================================
;*									*
;*		Calculate Partner Arwing CGX Pointer			*
;* data bank :7e								*
;=============================================================================
	longa
	longi
mm_calcpartnercgxptr
;* kuru kuru Arwing Chara CGXAddress Calc *
	lda	p2_pilotNo
	sta	kz_x1
	km_loblda	mmx_partneranmptr
	sta	kz_y1
	jsr	mm_calcplayercgxptr_sub
	stx	mm_arwingcgxptr1_pt
	sty	mm_arwingcgxptr2_pt

	rts

;---------------------------------------------------------------------
;*		Calculate Player Pattern			*
;* Input  :Acc
;* OutPut :Xreg
;*        :Yreg
;---------------------------------------------------------------------
mm_calcplayercgxptr_sub
	longa
	longi
	lda	kz_x1
	lsr	a
	and	#3
	tay		 
	lda	kz_y1
	cpy	#0
	beq	.setaddr1
	clc
	adc	#16	;GGarwing
	dey
	beq	.setaddr1
	clc
	adc	#16	;SParwing
.setaddr1
;* ue 2chra tensou *
	clc
	adc	mmx_sprarwingaddr
	tax

	lda.w	heap,x
	and	#$ff
	km_multa32
	clc
	adc	mmx_objcgxaddr
	tax

;* shita 2 chr tensou *
	clc
	adc	#$200
	tay
	rts

;=============================================================================
;*									*
;*			Set Player Postion				*
;* data bank :7e								*
;=============================================================================
mm_moveplayer
;************** Arwing Move Routine Part3 ('95/1/28) ***************
	phx
	longa
	longi
;'95/4/11 :comment
;	km_bitcheckmismapflag	playernocoll	;[player collision off]
;	km_bne	.end

	km_bitcheckflag16	mmx_arwingflag,mmf_initmove
	bne	.initial
	km_bitcheckflag16	mmx_arwingflag,mmf_go
	km_bne	.playermove
	brl	.end
;---------------------------------------------------------------------
.initial
	longa

;* calc unit velocity *
	lda	mmx_arwingsp
	km_nega
	sta	kz_x1
	lda	mmx_arwingangy+1	;(HI byte ha nandemo yoi)
	sta	kz_y1
	jsr	calcarwingxyvelocity

	km_absstavar	kz_x1,kz_tpx+1		;³mm_dx³
	km_absstavar	kz_y1,kz_textpt+1	;³mm_dy³

	lda	kz_x1
	cmp	kz_y1
	bcc	.biggerDY
.biggerDX
	km_setvar	mm_sp,kz_x1
	bra	.skip1
.biggerDY
	km_setvar	mm_sp,kz_y1
.skip1

	km_lobstavar	mm_sx,mmx_arwingposx+1
	km_lobstavar	mm_sy,mmx_arwingposy+1
	km_lobstavar	mm_ex,mmx_arwingdestposX
	km_lobstavar	mm_ey,mmx_arwingdestposY

	jsr	mm_calcdxdy
	
	longa
	km_stavar	mmx_arwingspx,mm_spx
	km_stavar	mmx_arwingspy,mm_spy
	a8
	km_stavar	mmx_arwingdx,mm_dx
	km_stavar	mmx_arwingdy,mm_dy
	km_stavar	mmx_arwingdxdy,mm_dxdy
	a16
	km_clrflag16	mmx_arwingflag,mmf_initmove
;---------------------------------------------------------------------
.playermove
	longa
	km_stavar	mm_sx,mmx_arwingposx
	km_stavar	mm_sy,mmx_arwingposy
	km_lobstavar	mm_ex,mmx_arwingdestposX
	km_lobstavar	mm_ey,mmx_arwingdestposY

	km_stavar	mm_sp,mmx_arwingsp
	km_stavar	mm_spx,mmx_arwingspx
	km_stavar	mm_spy,mmx_arwingspy

	km_lobstavar	mm_dx,mmx_arwingdx
	km_lobstavar	mm_dy,mmx_arwingdy
	km_lobstavar	mm_dxdy,mmx_arwingdxdy
	km_stavar	mm_flag,mmx_arwingflag

;------------------------------------------
	jsr	mm_speedupmode
;------------------------------------------
	longa
	jsr	mm_2pointmove
	km_stavar	mmx_arwingposx,mm_sx
	km_stavar	mmx_arwingposy,mm_sy
	km_stavar	mmx_arwingflag,mm_flag
	a8
	km_stavar	mmx_arwingdxdy,mm_dxdy
	a16

;94/11/11 :kono check wa postion (x,y) wo set shitekara okonau !!
	km_bitcheckflag16	mm_flag,mmf_finish
	km_beq	.end
.finish
	longa
	km_clrflag16	mmx_cursorflag,(curf_destdisp!curf_readyspup)
	km_clrflag16	mmx_arwingflag,mmf_all
	km_setflag	mmx_arwingflag,mmf_arrive

	km_bitcheckflag16	mmx_cursorflag2,curf2_gomothership
	km_bne	.ArriveMotherShip

	km_bitcheckflag16	mmx_cursorflag2,curf2_goplanet	;(corneria,battleship,mothership) no baai wa SKIP
	km_beq	.end

	ldx	mmx_arwingdestptr
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_wolfprotect,x
	km_bne	.end

;-------------------------------------
;*	Mission Start		*
;-------------------------------------
	km_setvar	mmx_wipeposX,mmx_arwingdestposX
	km_setvar	mmx_wipeposY,mmx_arwingdestposY
	km_setmismapsyori	missionstart
	km_clrflag16	mmx_cursorflag2,(curf2_goplanet)
	km_clrmismapflag	enemylist
	km_setflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	km_setflag16	kw_mismapfreezeflag,kfz_battlefreeze	;[stratage off]

;* X reg = Planet Pointer *
	km_setval	kx_missiontype,mistyp_planet
	ldx	mmx_arwingdestptr
	km_setflag16.w	mmx_planetflag,mmpnf_battleplayer,x	;Disable Missile Appear !!
	bra	.end

;-------------------------------------
;*	Arrive Mother Ship	*
;-------------------------------------
.ArriveMotherShip
	km_bitcheckmismapfzflag	timefreeze
	bne	.End
	km_bitcheckmismapflag	battleplayer
	bne	.End
	km_bitcheckmismapdemoflag	all
	bne	.end
.warptrigger_on
	km_clrflag16	mmx_cursorflag2,curf2_gomothership
	km_setmismapfzflag	gamefreeze
	km_clrmismapfzflag	playerfreeze
	km_setmismapdemoflag	warpdemo

	km_setmismapflag2	warpwait
	km_setval	kx_MotherShipSeq,motherseq_partnerwait
;---------------------------------------------------------------------
.end
	a16
	plx
	rts


;************** Arwing Move Routine Part2  ('95/1/27) ***************
	IFEQ	1

	php
	a16
	longi
	km_bitcheckmismapflag	playernocoll	;[player collision off]
	km_bne	.end
	km_bitcheckflag16	mmx_arwingflag,mmf_go
	km_beq	.end
;---------------------------------------------------------------------
.playermove
	longa
;* calc velocity *
	lda	mmx_arwingsp
	km_nega
	sta	kz_x1
	lda	mmx_arwingangy+1	;(HI byte ha nandemo yoi)
	sta	kz_y1
	jsr	calcarwingxyvelocity

;* set partner postion *
	km_bitcheckflag16	mmx_arwingflag,mmf_arvx
	bne	.noaddx
	lda	mmx_arwingposx_l
	clc
	adc	kz_tpx
	sta	mmx_arwingposx_l
	a8
	lda	mmx_arwingposx_l+2
	adc	kz_tpx+2
	sta	mmx_arwingposx_l+2
	cmp	mmx_arwingdestposX
	a16
	bne	.noaddx
	km_setflag16	mmx_arwingflag,mmf_arvx	
.noaddx

	km_bitcheckflag16	mmx_arwingflag,mmf_arvy
	bne	.noaddy

	lda	mmx_arwingposy_l
	clc
	adc	kz_textpt
	sta	mmx_arwingposy_l
	a8
	lda	mmx_arwingposy_l+2
	adc	kz_textpt+2
	sta	mmx_arwingposy_l+2
	cmp	mmx_arwingdestposY
	a16
	bne	.noaddy
	km_setflag16	mmx_arwingflag,mmf_arvy
.noaddy
;---------------------------------------------------------------------
;94/11/11 :kono check wa postion (x,y) wo set shitekara okonau !!
	km_andcmpcheckflag	mmx_arwingflag,(mmf_arvy!mmf_arvx)
	bne	.end
.finish
	longa
	km_clrflag16	mmx_cursorflag,(curf_destdisp!curf_readyspup)
	km_clrflag16	mmx_arwingflag,mmf_all

	km_bitcheckflag16	mmx_cursorflag,curf_goplanet
	km_beq	.end
	km_bitcheckflag16	mmx_cursorflag,curf_corneria
	km_bne	.end

;* MissionStart *
	km_setvar	mmx_wipeposX,mmx_arwingdestposX
	km_setvar	mmx_wipeposY,mmx_arwingdestposY
	km_setmismapsyori	missionstart
	km_clrflag16	mmx_cursorflag,curf_goplanet
	km_clrmismapflag	enemy
	km_setflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	km_setflag16	kw_mismapfreezeflag,(kfz_playerfreeze!kfz_enemyfreeze)	;[stratage off]

;* Y reg = Planet Pointer *
	ldy	mmx_arwingdestptr
	lda.w	mmx_stage,y
	km_loba
	sta	KGameMapPtr	;stage pointer
	lda.w	mmx_planetskill,y
	sta	currentlevel
	lda.w	mmx_planetswitch,y
	sta	PlanetSwich
	lda.w	mmx_plstackptr,y
	sta	kstacknumber

	km_setflag16.w	mmx_planetflag,mmpnf_battleplayer,y

;;;;	km_setmismapstflag	missionstart
;---------------------------------------------------------------------
.end
	plp
	rts
	ENDC

;************** Arwing Move Routine Part1 ***************
	IFEQ	1
	php
	a16
	longi
	km_bitcheckmismapflag	playernocoll	;[player collision off]
	km_bne	.end

	km_bitcheckflag16	mmx_arwingflag,mmf_initmove
	bne	.initial
	km_bitcheckflag16	mmx_arwingflag,mmf_go
	bne	.playermove
	brl	.end
;---------------------------------------------------------------------
.initial
	longa
	km_lobstavar	mm_sx,mmx_arwingposx+1
	km_lobstavar	mm_sy,mmx_arwingposy+1
	km_stavar	mm_sp,mmx_arwingsp
	km_lobstavar	mm_ex,mmx_arwingdestposX
	km_lobstavar	mm_ey,mmx_arwingdestposY

	jsr	mm_calcdxdy
	
	longa
	km_stavar	mmx_arwingspx,mm_spx
	km_stavar	mmx_arwingspy,mm_spy
	a8
	km_stavar	mmx_arwingdx,mm_dx
	km_stavar	mmx_arwingdy,mm_dy
	km_stavar	mmx_arwingdxdy,mm_dxdy
	a16
	km_clrflag16	mmx_arwingflag,mmf_initmove
;---------------------------------------------------------------------
.playermove
	longa
	km_stavar	mm_sx,mmx_arwingposx
	km_stavar	mm_sy,mmx_arwingposy
	km_lobstavar	mm_ex,mmx_arwingdestposX
	km_lobstavar	mm_ey,mmx_arwingdestposY

	km_stavar	mm_sp,mmx_arwingsp
	km_stavar	mm_spx,mmx_arwingspx
	km_stavar	mm_spy,mmx_arwingspy

	km_lobstavar	mm_dx,mmx_arwingdx
	km_lobstavar	mm_dy,mmx_arwingdy
	km_lobstavar	mm_dxdy,mmx_arwingdxdy
	km_stavar	mm_flag,mmx_arwingflag

;------------------------------------------
	jsr	mm_speedupmode
;------------------------------------------

	longa
	jsr	mm_2pointmove
	km_stavar	mmx_arwingposx,mm_sx
	km_stavar	mmx_arwingposy,mm_sy
	km_stavar	mmx_arwingflag,mm_flag
	a8
	km_stavar	mmx_arwingdxdy,mm_dxdy
	a16

;94/11/11 :kono check wa postion (x,y) wo set shitekara okonau !!
	km_bitcheckflag16	mm_flag,mmf_finish
	beq	.end
.finish
	longa
	km_clrflag16	mmx_cursorflag,(curf_destdisp!curf_readyspup)
	km_clrflag16	mmx_arwingflag,mmf_all

	km_bitcheckflag16	mmx_cursorflag,curf_goplanet
	km_beq	.end
	km_bitcheckflag16	mmx_cursorflag,curf_corneria
	km_bne	.end

;* Mission Start *
	km_setvar	mmx_wipeposX,mmx_arwingdestposX
	km_setvar	mmx_wipeposY,mmx_arwingdestposY
	km_setmismapsyori	missionstart
	km_clrflag16	mmx_cursorflag,curf_goplanet
	km_clrmismapflag	enemy
	km_setflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	km_setflag16	kw_mismapfreezeflag,(kfz_playerfreeze!kfz_enemyfreeze)	;[stratage off]

;* Y reg = Planet Pointer *
	ldy	mmx_arwingdestptr
	lda.w	mmx_stage,y
	km_loba
	sta	KGameMapPtr	;stage pointer
	lda.w	mmx_planetskill,y
	sta	currentlevel
	lda.w	mmx_planetswitch,y
	sta	PlanetSwich
	lda.w	mmx_plstackptr,y
	sta	kstacknumber

	km_setflag16.w	mmx_planetflag,mmpnf_battleplayer,y

;;;;	km_setmismapstflag	missionstart
;---------------------------------------------------------------------
.end
	plp
	rts
	ENDC


;=====================================================================
;*			Move Partner Arwing			*
;* data bank :7e							*
;=====================================================================
	longa
	longi
mm_MovePartner
;;;	km_clrflag16	 mmx_partnerflag,(mmf_notdisplay)

;******************* Search Host Player  **********************
;* Main Arwing Moving Check *
;* Collision Check *
	km_setvar	mmx_partnersp,mmx_arwingsp
	km_lobstavar	kz_x1,mmx_partnerposx+1
	km_lobstavar	kz_y1,mmx_partnerposy+1
	km_lobstavar	kz_x2,mmx_arwingposx+1
	km_lobstavar	kz_y2,mmx_arwingposy+1

	km_bitcheckflag16	mmx_arwingflag,mmf_go
	beq	.stop_mainarwing
.move_mainarwing
	km_clrflag16	 mmx_partnerflag,mmf_notdisplay

	km_setval	kz_z1,12
	jsr		mm_checkcollision
	bcs	.stop_partner
	km_setflag16	 mmx_partnerflag,mmf_go
	jsr	pt_search_player
	rts
.stop_partner
	km_clrflag16	 mmx_partnerflag,mmf_go
	rts
;---------------------------------------------------
.stop_mainarwing
	km_bitcheckflag16	 mmx_partnerflag,mmf_notdisplay
	bne	.End

	lda	mmx_arwingsp
	asl	a
	asl	a
	sta	mmx_partnersp

	km_setval	kz_z1,2
	jsr		mm_checkcollision
	bcs	.disappear_partner
	km_setflag16	 mmx_partnerflag,mmf_go

	jsr	pt_search_player
	rts
.disappear_partner
	km_clrflag16	 mmx_partnerflag,mmf_go
	km_setflag16	 mmx_partnerflag,mmf_notdisplay
;---------------------------------------------------
.End
	rts

;---------------------------------------------------------------------
;*			Attack Zaco Enemy			*
;---------------------------------------------------------------------
	IFEQ	1
pt_attack_zaco
	php
	a16
	stz	kwork
	km_bitcheckmismapflag	attackcorneria
	beq	.end
	ldy	kx_enemyinptr
	beq	.end
;* Collision Check *
	km_setval	mmx_partnersp,arwingspeed*8
	km_lobstavar	kz_x1,mmx_partnerposx+1
	km_lobstavar	kz_y1,mmx_partnerposy+1
	km_loblda.w	mmx_enposx+1,y
	sta	kz_x2
	km_loblda.w	mmx_enposy+1,y
	sta	kz_y2
	km_setval	kz_z1,14
	jsr		mm_checkcollision
	bcs	.skip
	jsr	pt_search_player
.skip
	inc	kwork
.end
	plp
	rts
	ENDC
;---------------------------------------------------------------------
;*			Search Host Player			*
;---------------------------------------------------------------------
pt_search_player
	php
	a16
	longi
;* calc angle *
	jsr	calcarwingangle
	km_setvar	mmx_partnerangy,kz_tpy
	km_setvar	mmx_partneranmptr,kz_tpa	;angle pointer (16 pattern) 0,1,2,3,...15
	jsr	PartnerAngVeltoPos
	plp
	rts

;=====================================================================
;*								*
;*		Partner Move (Vel,AngY) --->(posx,posy)		*
;* Input	:mmx_partnersp						*
;*	:mmx_partnerangy					*
;=====================================================================
	longa
	longi
ArwingAngVeltoPos
	lda	mmx_arwingsp
	km_nega
	sta	kz_x1
	lda	mmx_arwingangy+1	;(HI byte ha nandemo yoi)
	sta	kz_y1
	jsr	calcarwingxyvelocity
	lda	kz_tpx+1
	sta	mmx_arwingspx
	lda	kz_textpt+1
	sta	mmx_arwingspy
;* set main player postion *

	lda	mmx_arwingposx
	clc
	adc	mmx_arwingspx
	sta	mmx_arwingposx

	lda	mmx_arwingposy
	clc
	adc	mmx_arwingspy
	sta	mmx_arwingposy
	rts
;=====================================================================
;*								*
;*		Partner Move (Vel,AngY) --->(posx,posy)		*
;* Input	:mmx_partnersp						*
;*	:mmx_partnerangy					*
;=====================================================================
	longa
	longi
PartnerAngVeltoPos
	lda	mmx_partnersp
	km_nega
	sta	kz_x1
	lda	mmx_partnerangy+1	;(HI byte ha nandemo yoi)
	sta	kz_y1
	jsr	calcarwingxyvelocity
	lda	kz_tpx+1
	sta	mmx_partnerspx
	lda	kz_textpt+1
	sta	mmx_partnerspy
;* set partner postion *
.set_partnerxy
	lda	mmx_partnerposx
	clc
	adc	mmx_partnerspx		;mm_spx
	sta	mmx_partnerposx
	lda	mmx_partnerposy
	clc
	adc	mmx_partnerspy		;mm_spy
	sta	mmx_partnerposy
	rts


;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
	IFEQ	1
	km_bitcheckmismapstflag	speedup
	beq	.notspeedup
	asl	kz_tpx
	rol	kz_tpx+2
	asl	kz_tpx
	rol	kz_tpx+2
	asl	kz_tpx
	rol	kz_tpx+2

	asl	kz_textpt
	rol	kz_textpt+2
	asl	kz_textpt
	rol	kz_textpt+2
	asl	kz_textpt
	rol	kz_textpt+2
.notspeedup
;* calc postrion
	a8
	lda	mmx_partnerposx_l
	clc
	adc	kz_tpx
	sta	mmx_partnerposx_l
	a16
	lda	mmx_partnerposx
	clc
	adc	kz_tpx+1
	sta	mmx_partnerposx

	a8
	lda	mmx_partnerposy_l
	clc
	adc	kz_textpt
	sta	mmx_partnerposy_l
	a16
	lda	mmx_partnerposy
	clc
	adc	kz_textpt+1
	sta	mmx_partnerposy
	ENDC

	IFEQ	1
	km_lobstavar	mm_sx,mmx_partnerposx+1
	km_lobstavar	mm_sy,mmx_partnerposy+1
	km_stavar	mm_sp,mmx_partnersp
	km_lobstavar	mm_ex,mmx_arwingposX+1
	km_lobstavar	mm_ey,mmx_arwingposY+1

;* calc velocity (mm_spx,mm_spy,mm_dx,mm_dy,mm_dxdy) *
	jsr	mm_calcdxdy
	jsr	mm_speedupmode

	a8
	km_stavar	mmx_partnerdxdy,mm_dxdy
	a16
	km_stavar	mm_sx,mmx_partnerposx
	km_stavar	mm_sy,mmx_partnerposy

	jsr	mm_2pointmove

	km_stavar	mmx_partnerposx,mm_sx
	km_stavar	mmx_partnerposy,mm_sy
	a8
	km_stavar	mmx_partnerdxdy,mm_dxdy
	a16
	ENDC
;=====================================================================
;*			Speed UP CHECK				*
;=====================================================================
mm_speedupmode
	longa
	lda	mm_spx
	jsr	arspeedupA
	sta	mm_spx

	lda	mm_spy
	jsr	arspeedupA
	sta	mm_spy
	rts

arspeedupA
	longa
	longi
	pha
	km_bitcheckmismapstflag	arwingspup
	beq	.notspeedup
	pla
	asl	a	;*8
	asl	a
	asl	a
	rts
.notspeedup
	pla
	rts
;------------------------------------------------------------------------
	IFEQ	1
kasteroidA
	longa
	longi
	pha
	km_bitcheckflag	mmx_arwingflag,mmf_asteroid
	beq	.end

	pla
	km_asra
	km_asra
	km_asra
	rts
.end
	pla
	rts
	ENDC
;------------------------------------------------------------------------

	ifeq	1
	km_setval	mm_sp,$0100
	lda	mm_spx
	bmi	.minusspx
.plasspx
	lda	#$0100
	bra	.staspx
.minusspx
	lda	#-$100
.staspx
	sta	mm_spx

	lda	mm_spy
	bmi	.minusspy
.plasspy
	lda	#$100
	bra	.staspy
.minusspy
	lda	#-$100
.staspy
	sta	mm_spy

	endc
;=====================================================================
;*		2 tenkan no idou				*
;* data bank :7e							*
;=====================================================================
;=====================================================================
;*		Calculation (DY/DX)				*
;=====================================================================
mm_calcdxdy
	php

	a16
;* calc DX *
	km_subvar	mm_ex,mm_sx
	sta	mm_dx
	bpl	.incx
.decx
	km_negstavar	mm_spx,mm_sp	;speed x
	bra	.skip_dx
.incx
	km_setvar	mm_spx,mm_sp	;speed x
.skip_dx
;--------------------------------------------------------
;* calc DY *
	km_subvar	mm_ey,mm_sy
	sta	mm_dy
	bpl	.incy
.decy
	km_negstavar	mm_spy,mm_sp	;speed y
	bra	.skip_dy
.incy
	km_setvar	mm_spy,mm_sp	;speed y
.skip_dy
;--------------------------------------------------------
	km_absstavar	mm_dx		;³mm_dx³
	km_absstavar	mm_dy		;³mm_dy³
;--------------------------------------------------------
.end
	stz	mm_dxdy
	plp
	rts
;=====================================================================
;*		2 tenkan no idou				*
;* out:clc/sei ... continue / end					* 
;=====================================================================
mm_2pointmove
	php
;---------------------------------------------
;* If (sx,sy) = (ex,ey) Then Not Move Player *
	a8
	lda	mm_sx+1
	cmp	mm_ex
	bne	.skip1
	lda	mm_sy+1
	cmp	mm_ey
	bne	.skip1
	a16
	brl	.finish_move
.skip1
;--------------------------------------------
;* special move (mm_dx =0,mm_dy =0) *
	a16
	lda	mm_dx
	beq	.dx0
	lda	mm_dy
	beq	.dy0
;-----------------------------------------
	lda	mm_dx
	sec
	sbc	mm_dy
	bmi	.addy
;-----------------------------------------
;dx > dy
.addx
;* ikisugi boushi flag check *
	km_bitcheckflag16	mm_flag,mmf_arvx
	bne	.skipaddx1
	km_addstavarvar	mm_sx,mm_spx
;;;	km_substavarltsmin	mm_cntx,mm_sp,0
.skipaddx1
	km_bitcheckflag16	mm_flag,mmf_arvy
	bne	.skipaddy1

	lda	mm_dxdy
	clc
	adc	mm_dy
	cmp	mm_dx
	bmi	.noaddy
	pha
	km_addstavarvar	mm_sy,mm_spy
;;;	km_substavarltsmin	mm_cnty,mm_sp,0
	pla
	sec
	sbc	mm_dx
.noaddy
	sta	mm_dxdy
.skipaddy1
	bra	.endcheck
;-----------------------------------------
;dy > dx
.addy
	km_bitcheckflag16	mm_flag,mmf_arvy
	bne	.skipaddy2
	km_addstavarvar	mm_sy,mm_spy
;;;	km_substavarltsmin	mm_cnty,mm_sp,0
.skipaddy2
	km_bitcheckflag16	mm_flag,mmf_arvx
	bne	.skipaddx2
	lda	mm_dxdy
	clc
	adc	mm_dx
	cmp	mm_dy
	bmi	.noaddx

	pha
	km_addstavarvar	mm_sx,mm_spx
;;;	km_substavarltsmin	mm_cntx,mm_sp,0
	pla
	sec
	sbc	mm_dy
.noaddx
	sta	mm_dxdy
.skipaddx2
	bra	.endcheck
;---------------------------------------------------------------------
;*		Special Move	(suityoku,myoko no idou)	*
;---------------------------------------------------------------------
.dx0	;suityoku houkou ni idou
	km_addstavarvar	mm_sy,mm_spy
	bra	.endcheck
;-----------------------------------------
.dy0	;myoko ni idou
	km_addstavarvar	mm_sx,mm_spx
;-----------------------------------------
.endcheck
	a8
	lda	mm_sx+1
	cmp	mm_ex
	a16
	bne	.nohitx
	km_setflag16	mm_flag,mmf_arvx
.nohitx
	a8
	lda	mm_sy+1
	cmp	mm_ey
	a16
	bne	.nohity
	km_setflag16	mm_flag,mmf_arvy
.nohity
	km_andcmpcheckflag	mm_flag,(mmf_arvy!mmf_arvx)
	bne	.exit
.finish_move
	km_setflag16	mm_flag,mmf_finish
.exit
	plp
	rts

;*********************************************************************
;*								*
;*		Final Boss Appear Demo Chart			*
;* Data bank 7e							*
;* Return :ai16							*
;* Break  :X,Y,Acc							*
;*********************************************************************
	longa
	longi
mm_finalbosschart
	km_bitcheckmismapchflag	fbchartenable
	beq	.end
;	jsr	check_finalbossappear
	ldx	kx_FinalBossSeq
	jsr	(.FianlBossTbl,x)
.end
	rts
;-----------------------------
;* 	Table 		*
;-----------------------------
.FianlBossTbl
	dw	fbdemo_nothing&WM
	dw	fbdemo_finalbosstrig&WM
	dw	fbdemo_sosdestwait&WM
	dw	fbdemo_warpwait&WM
	dw	fbdemo_battlestart&WM


	dw	fbdemo_zacoenemykill&WM
	dw	fbdemo_missilekill&WM
	dw	fbdemo_planetkill&WM
	dw	fbdemo_battleshipkill&WM
	dw	fbdemo_allenemykill&WM

	IFEQ	1
	dw	fbdemo_wait1&WM
	dw	fbdemo_bossinittrig&WM
	dw	fbdemo_bossdisappeardemo&WM
	dw	fbdemo_bossmovedemo&WM
	dw	fbdemo_bossappeartrig&WM
	dw	fbdemo_bossappeardemo&WM
	dw	fbdemo_waitplayer&WM
	dw	fbdemo_battlestart&WM
                               	ENDC
;---------------------------------------------------------------------
;* nothing to do *
fbdemo_nothing
	longa
	rts
;---------------------------------------------------------------------
;* sos destruction trigger *
	longa
	longi
fbdemo_zacoenemykill
	jsr	mm_zacoenemykill
	bra	fbdemo_kill_common
fbdemo_missilekill
	jsr	mm_missilekill
	bra	fbdemo_kill_common
fbdemo_planetkill
	jsr	mm_planetkill
	bra	fbdemo_kill_common

fbdemo_battleshipkill
	jsr	mm_battleshipkill
	bra	fbdemo_kill_common

fbdemo_allenemykill
	jsr	mm_enemyallkill
	bra	fbdemo_kill_common

fbdemo_kill_common
	km_setval	kx_FinalBossSeq,fbseq_nothing
	rts
;---------------------------------------------------------------------
	longa
	longi
mm_enemyallkill
	jsr	mm_planetkill
	jsr	mm_battleshipkill
	jsr	mm_zacoenemykill
	jsr	mm_missilekill
	rts

;--------------------
	longa
	longi
mm_planetkill
;* Planet All Clear *
	km_setval	kcounter,1

	ldx	kx_planetlistptr
	beq	.end11
.loop11
	lda.w	mmx_planetnext,x
	sta	kwork

 	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,x
	beq	.skip11
	bit	#mmpnf_battleship
	bne	.skip11
	bit	#mmpnf_complete
	bne	.skip11
	jsr	clearplanet

	dec	kcounter
	beq	.end11
.skip11
	ldx	kwork		;Get Next Pointer
	bne	.loop11
.end11
	rts

;--------------------
	longa
	longi
mm_battleshipkill
;* Battle Ship All Clear *
	km_setval	kcounter,1

	ldx	kx_planetlistptr
	beq	.end22
.loop22
	lda.w	mmx_planetnext,x
	sta	kwork
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_battleship,x
	beq	.skip22
	lda.w	mmx_bslinkptr,x
	tay
	jsr	clearbattleship

	dec	kcounter
	beq	.end22
.skip22
	ldx	kwork		;Get Next Pointer
	bne	.loop22
.end22
	rts
;--------------------
	longa
	longi
mm_zacoenemykill
;*memo : SOS Enemy no jibaku Mode wo Set !! *
	km_setval	kcounter,1

	ldy	kx_enlistptr
	beq	.end1
.loop1
	lda.w	mmx_ennext,y
	sta	kwork
	km_bitcheckflag16.w	mmx_enflags,(enfl_missile!enfl_battleship!enfl_finalboss!enfl_satellite!enfl_mothership!enfl_itemplanet),y
	bne	.next1
	km_bitcheckflag16.w	mmx_enflags,enfl_wolf,y
	beq	.skip11
	ldx.w	mmx_enlinkptr,y
	km_clrflag16.w	mmx_planetflag,mmpnf_wolfprotect,x
.skip11
	jsl	mm_freeenemylistptr_l
	dec	kcounter
	beq	.sound11
.next1
	ldy	kwork
	bne	.loop1
.sound11
	ksound	en_explode_demo
.end1
	rts
;---------------------------------------------------------------------
	longa
	longi
mm_missilekill
	km_setval	kcounter,1
;*memo : SOS Enemy no jibaku Mode wo Set !! *
	ldy	kx_enlistptr
	beq	.end1
.loop1
	lda.w	mmx_ennext,y
	sta	kwork
	km_bitcheckflag16.w	mmx_enflags,(enfl_zaco!enfl_battleship!enfl_finalboss!enfl_satellite!enfl_mothership!enfl_itemplanet!enfl_wolf!enfl_virus),y
	bne	.next1
	km_bitcheckflag16.w	mmx_enflags,enfl_wolf,y
	beq	.skip11
	ldx.w	mmx_enlinkptr,y
	km_clrflag16.w	mmx_planetflag,mmpnf_wolfprotect,x
.skip11
	jsl	mm_freeenemylistptr_l
	dec	kcounter
	beq	.sound11
.next1
	ldy	kwork
	bne	.loop1
.sound11
	ksound	mis_explode
.end1
	rts


;---------------------------------------------------------------------
	longa
	longi
fbdemo_finalbosstrig
	km_setmismapchflag	fbdemowait
	km_setmistotalflag	finalbossbattle	;[missiontotal flag]
	km_setmismapfzflag	all
	km_clrmismapfzflag	enemyfreeze
	km_setmismapevflag	bossfreeze
	km_clrflag16	mmx_arwingflag,mmf_go
	km_setval	kx_FinalBossSeq,fbseq_sosdestwait

;	km_clrmismapfzflag	all
;	km_setflag16	kw_MisMapFreezeFlag,(kfz_timefreeze!kfz_cursorfreeze)

	rts
;---------------------------------------------------------------------
;* sos enemy destruction wait *
	longa
	longi
fbdemo_sosdestwait
	lda	kx_enemytotal
	bne	.skip
	km_setmismapfzflag	enemyfreeze
	km_clrmismapfzflag	playerfreeze
	km_setval	kx_objdemonumber,odm_finalwarp
	km_setval	kx_FinalBossSeq,fbseq_warpwait
.skip
	rts
;---------------------------------------------------------------------
fbdemo_warpwait
	lda	kx_objdemonumber
	beq	.finish
	rts
.finish
	km_setval	mmx_wipeposX,enemybaseX
	km_setval	mmx_wipeposY,enemybaseY
	km_setval	kx_FinalBossSeq,fbseq_battlestart
	rts
;---------------------------------------------------------------------
fbdemo_battlestart
	longa
	a8
	km_setvar	p1_hp,p1_MaxHp
	km_setvar	p2_hp,p2_MaxHp
	a16
	km_setval	KGameMapPtr,stg_ext2
	km_setvar	currentlevel,kdifficulty
	km_setval	kx_missiontype,mistyp_finalboss
	km_setval	kw_MisMapSyori,mmsy_missionstart
	rts
;---------------------------------------------------------------------








	IFEQ	1
;---------------------------------------------------------------------
fbdemo_wait1
	longa
	dec	mmx_FinalBossTm
	bne	.skip
	km_setval	kx_FinalBossSeq,fbseq_bossinittrig
.skip
	rts
;---------------------------------------------------------------------
;* final boss start trig *
fbdemo_bossinittrig
	longa
	km_setmismapflag	finalboss
	km_setmismapstflag	finalbosstrig	;(For Yajima)
	km_setval	kx_FinalBossSeq,fbseq_bossdisappeardemo
	km_setval	mmx_FinalBossTm,72/8

	ldy	kx_FinalBossEnPtr
	lda	#cd_objanime_finalboss_dap
	sta.w	mmx_enanmpatt,y
	lda	#0
	sta.w	mmx_enanmtm,y

	rts
;---------------------------------------------------------------------
fbdemo_bossdisappeardemo
	longa
	dec	mmx_FinalBossTm
	bne	.skip
	ldy	kx_FinalBossEnPtr
	lda	#0
	sta.w	mmx_enanmtm,y
	sta.w	mmx_enanmpatt,y
	km_setval	kx_FinalBossSeq,fbseq_bossmovedemo
	km_setval	mmx_FinalBossTm,1
.skip
	rts
;---------------------------------------------------------------------
fbdemo_bossmovedemo
	longa
	dec	mmx_FinalBossTm
	bne	.skip
	km_setval	kx_FinalBossSeq,fbseq_bossappeartrig
.skip
	rts
;---------------------------------------------------------------------
fbdemo_bossappeartrig
	longa
	km_setval	kx_FinalBossSeq,fbseq_bossappeardemo
	km_setval	mmx_FinalBossTm,18+8
	km_setval	kx_hscrollp1,$120
	km_setval	kx_vscrollp1,0

	IFEQ	1
;* BG colour change *
	km_setscreenflag	bgcolpal4
	km_stxval	coladr_4,(kx_palette4+7*32)&WM	;address
	km_setval	coladr_4+2,kx_palette4>>16	;bank
	km_stxval	colptr_4,7*40
	km_setval	coltimer_4,6		;bg color flash timer
	km_setval	coltimermax_4,6		;bg color flash timer
	ENDC
	rts
;---------------------------------------------------------------------
fbdemo_bossappeardemo
	longa
	dec	mmx_FinalBossTm
	beq	.finish_appear

	IFEQ	1
	lda	mmx_FinalBossTm
	cmp	#8
	bne	.end
	km_setval	coltimer_4,1		;bg color flash timer
	km_setval	coltimermax_4,1		;bg color flash timer
	ENDC

	bra	.end
;---------------------------
.finish_appear
	km_clrscreenflag	bgcolpal4
	km_setval	kx_FinalBossSeq,fbseq_waitplayer
	km_setval	kx_MMPlayerSeq,plseq_finaldemotrig
	km_clrmismapfzflag	playerfreeze
	km_setval	mmx_FinalBossTm,1
.end
	rts

	ENDC
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------

;*********************************************************************
;*		Final Boss Appear Check				*
;*********************************************************************
	IFEQ	1
check_finalbossappear
	php
	a16
	longi
	km_bitcheckmistotalflag	finalbossbattle
	bne	.skip

	lda	kx_missiontotal
	ora	kx_enemytotal
	ora	kx_specialclearcnt
	bne	.skip
	km_setmistotalflag	finalbossbattle
	km_setval		kx_FinalBossSeq,fbseq_sosdesttrig
.skip
	plp
	rts
	ENDC
;*********************************************************************
;*								*
;*		Corneria Fell Demo Chart			*
;*								*
;*********************************************************************
	longa
	longi
mm_corneriafellchart
	ldx	kx_CorneriaFellSeq
	jsr	(.FellDemoTbl,x)
	rts
.FellDemoTbl
	dw	corneria_nothing&WM
	dw	corneria_felltrig&WM
	dw	corneria_felldemo&WM
;---------------------------------------------------------------------
corneria_nothing
	rts
;---------------------------------------------------------------------
corneria_felltrig
	longa
	km_setmismapfzflag	gamefreeze
	km_setflag16	kx_demoflag,demof_fell
	km_setflag16	mmx_message_sos,mesosfl_corneriafell
	km_setval	kx_CorneriaFellSeq,cfseq_felldemo
	rts
;---------------------------------------------------------------------
corneria_felldemo
	longa
	km_bitcheckflag16	kx_demoflag,demof_fell
	bne	.skip

;'95/8/30 ;;;	km_clrmismapflag	corneriafell
	km_setmismapsyori	corneriafell	;missiongameover
	km_setval	kx_CorneriaFellSeq,cfseq_nothing
.skip
	rts
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------

;*********************************************************************
;=====================================================================
;*								*
;*		Initial Mission Map Params			*
;*								*
;=====================================================================
;*********************************************************************
Init_MisMapParams
;!!!! kono Routine wa itiban saisyo ni oku !!!!
	ifne	kdemosw
	km_setmismapflag	explain
	endc
;* Flag Clear * :kono ichi ni tyuui !!
	a16
	km_clrmismapstflag	all
	a8

;* Planet Enemy List Initial *
	jsl	Init_MMList_l

;* Copy RAM Program & Data to HEAP RAM *
	jsr	mm_heapcopy

;* flags *
	a8
 	km_setspritemode	mismap	   ;[SPRITE MODE]
	km_setscreenmode	mismap	   ;[SCREEN MODE]
	a16
	km_clrmistotalflag	mission	   ;[GAME FLAG]
	km_clrmissionflag	parallel   ;[MISSION FLAG]
	km_setmismapfzflag	gamefreeze ;[FREEZE FLAG]

	km_clrscreenflag	sprwbuf		;[SCREEN FLAG]
	km_setscreenflag	colpaltrans	;[SCREEN MODE]
	km_setscreenflag	bgcolpal 	;[SCREEN MODE]
	km_setscreenflag	bgcolpal3	;[SCREEN MODE]
	km_setscreenflag	objcolpal 	;[SCREEN MODE]
	km_setscreenflag	screenadd	;[SCREEN MODE]

	km_setwindowflag	normalwipe ;[SCREEN FLAG]
	km_setscrollflag	hdmascroll ;[SCREEN MODE]
	km_setmismapstflag	noirqsyori ;[MISSIONMAPSTATE FLAG]

	km_clrsndflag	port2stop		;[SOUND FLAG]

;* Key Read State Clear *
	km_clrgmjoypad
	km_clrgmkeydown

;* Mario Chip Set Up *
	a8
	lda	#height_128!colours_16
	sta	mario_draw_mode		;V hight = 128dot (16 chr),colour = 16
	sta.l	mio_mode
	a16
	lda	#mm_bitmaphight*8
	sta.l	m_screenheight		;Screen Hight
	a8

;* Set VRAM double buffering *
	km_stxval	vmap1,mm_bg1_bitmap1	;VRAM bitmap base1 addr ($1000)
	km_stxval	vmap2,mm_bg1_bitmap2	;VRAM bitmap base2 addr ($3000)
	km_stxval	drawmap,bitmap1		;Mario Write Buffer	($4000)
	km_stxval	showmap,bitmap1_dbl	;Mario Transfer Buffer	($a000)

;* Parameter initial *
	phb
	db7e

	jsr	init_playerparams	

	km_setval	key_tatemaxptr1,6
	km_setval	mmw_wbuffercounter,(2*mm_planetnumber)	;double buffer swap counter
	km_setval	mmx_destmarktm,8			;dest mark flash timer

	km_stxval	kx_showmapsize,0
	km_stxval	mmw_vramadr,(($100*$20)+mm_bg1_cgx_2)/2	;VRAM(BG1) write start adderss

	km_stxval	mapexp_pointer,0	;[for yaijma]

	km_stxval	kx_sachargeanmtm,0
	km_stxval	kx_sachargeanmptr,sprblockanm_TamaCharge

	km_clrflag16	kx_satelliteflag,safl_toritukitrig
	km_stxval	kx_satoritukianmtm,0
	km_stxval	kx_satoritukianmptr,sprblockanm_Torituki

;	km_setval	mmw_speedup,1		;normal speed
;	km_setval	kx_TotalSubTime,mapgftm
;	km_setval	mmx_stationtm,20
;	km_setval	mmw_planetdataptr,0	;planet data pointer ;(cx,cy,R,swsprite)
;	km_stxval	mmx_curanmpat,$0102	;cur sor anim pattern
;	km_stxval	mmx_curanmpat2,$0100
;	km_stxval	mmx_planetangx,$1000	;planet angle X
;	km_stxval	mmx_planetangz,$1000	;planet angle Z
;	km_stxval	mmw_planetanmptr,$800	;Radius

;* Colour Buffer Pointer *
;* sun no colour palette *
;	km_stxval	coladr_2,kx_palette2&WM		;address
;	km_setval	coladr_2+2,kx_palette2>>16	;bank
	km_setval	coltimer_2,10			;bg color flash timer
	km_setval	coltimermax_2,10		;bg color flash timer

;* corneria no colour palette *
;	km_stxval	coladr_3,kx_palette3&WM		;address
;	km_setval	coladr_3+2,kx_palette3>>16	;bank
	km_setval	coltimer_3,10			;bg color flash timer
	km_setval	coltimermax_3,10		;bg color flash timer

;* senryou planet *
;	km_stxval	coladr_4,(kx_palette4+15*32)&WM	;address
;	km_setval	coladr_4+2,kx_palette4>>16	;bank
	km_stxval	colptr_4,0
	km_setval	coltimer_4,4		;bg color flash timer
	km_setval	coltimermax_4,4		;bg color flash timer

	lda	kw_mmBGMPtr
	beq	..skip
	dec	a
	beq	..setflag
	km_setval	coltimer_3,4		;bg color so danger flash timer
	km_setval	coltimermax_3,4		;bg color so danger flash timer
..setflag
	km_setscreenflag	bgcolpal3	;colour change enable
..skip
	plb

;* wipe init & open *
;* kono check wa "mm_checkmiscomplete'" no syori no mae ni kanarazu oku !!! *
	km_setgameflag	keydisable

	km_bitcheckmismapflag	returnmap
	beq	.no_wipe
	km_initwipeopen	mismap
	bra	.skip_wipe
.no_wipe
	jsl	wipeinit_l	;[yajima]
	km_stxval	kw_wipetimer,allfreezetm	;[wipe timer = 0 ni narumade keydiable]
	km_setwindowflag	wipeopen
.skip_wipe

;* Screen Set *
	jsr	Init_MMScreen		;[SCREEN INITIAL]
	jsl	init_sprites_l		;[SPRITES]
	jsr	Init_MarioDrawRAM	;[Mario RAM Clear] :Init_MMscreen no atoni oku !!!

;********* Check Complete **********
;kanarazu flag set no ushiro oku !!
;kanarazu Init_MMSound no ushiro ni oku !!
;kanarazu yjmapinit_l no mae oku !!
	jsr	mm_checkmiscomplete

;* SOUND BGM SET *
	jsr	Init_MMSound	;set ichi syuusei :'95/6/26

	a16
	km_bitcheckmismapflag	returnmap
	beq	.skip
	km_clrmismapflag	returnmap	;[mission kara modotte kita flag]
	ksound	map_open_wipe
.skip
	a8

;* message initial *
	jsl	yjmapinit_l		;[yajima] :yjmap.asm

;* Set H-DMA Params *
	jsl	init_mmhvscroll_l
	jsr	init_hdmaparams
	jsl	init_nopolywindows_l

;* kuru kuru arwing CGX pointer Initial *
	phb
	db7e
	jsr	mm_calcplayercgxptr
	plb
	rts

;===============================================================================
;*			Player Params					*
;===============================================================================
init_playerparams
	php
	a8
	km_setval	mmx_arwingdestposx,corneriaX
	km_setval	mmx_arwingdestposy,corneriaY

	km_setvar	mmx_playerNo,p1_pilotNo			;[For Message]
	km_setvar	mmx_partnerposx+1,mmx_arwingposx+1	;[partner postion x]
	km_setvar	mmx_partnerposy+1,mmx_arwingposy+1	;[partner postion y]

	a16
	km_setflag16	mmx_arwingflag,mmf_initmove
	jsr	mm_calcplayerangle	;[player angle]
	km_clrflag16	mmx_arwingflag,mmf_initmove

	jsr	mm_calcplayercgxptr	;[player cgx ptr]
	jsr	mm_calcpartnercgxptr	;[partner cgx pointer]
	plp
	rts

;*****************************************************************************
;*									*
;*									*
;*		Initial Mission Map Params				*
;*									*
;* data bank :7e								*
;*****************************************************************************
Init_MMList_l
	shorta
	longi
	php
	phb
	db7e
	a16

;* Map Explain,Game Start,Retry,Partner Continue *
	km_bitcheckmistotalflag	initialmap
	km_bne	mmlist_end

	km_setmistotalflag	initialmap

;* kono check wa mismap flag clear no maeni oku !! '95/6/25 *
	km_bitcheckmistotalflag	partner1
	km_bne	init_partnercontinue

;* flag & params clear *
	km_clrmismapflag	all
	km_clrmismapflag2	all
;;;;	km_clrmismapfzflag	all
	km_clrmissionflag	all
	km_setmismapsyori	normal

;* Game Type Check *
	lda	kw_MisTotalFlag
	bit	#kmtof_explain1
	km_bne	init_explain
	bit	#kmtof_retry
	km_bne	init_retry
	brl	init_normal

;---------------------------------------------------------------------
;*		Initial Mission Map Game			*
;* hajimeno 1kai dake !!
;---------------------------------------------------------------------
init_retry
init_explain
	longa
;* event syori disable *
	km_setmismaptrflag	eventdisable
;======================================
;*   MISSION MAP Work RAM All Clear	 *
;======================================
	km_dmaWRAMClear	0,MISSIONXRAM,MISSIONXRAMLen

;======================================
;*   Enemy Stack Buffer Clear (Eguchi)*
;======================================
	ldy	#kstacklen-1
	lda	#0
	sta	kx_stackbaseptr
	A8
.loop_stackclear
	sta.w	kx_stackbuffer,y
	sta.w	eenemyNumber_0,y
	sta.w	SebangoSwitch_0,y
	sta.w	SebangoSwitch_0+kstacklen,y
	dey
	bpl	.loop_stackclear

	ldy	#planetkazu_max-1
	lda	#0
.loop_planetclear
	sta.w	EEnemyNumPlanet1,y
	dey
	bpl	.loop_planetclear

;=====================================
;*   	Set Random 		*
;=====================================
	a16
;* sos enemy stage random *
	lda	kw_RndPlanetPtr
	and	#127
	sta	sos_rnd_offset
;* missile radom *
	lda	kw_RndPlanetPtr
	and	#15
	sta	miss_rnd_offset
;* planet stage random *
	lda	kw_RndPlanetPtr
	and	#127
	sta	pl_rnd_offset
;* stepup  enemy stage random *
	jsl	KGetRandomPtr_l
	and	#31
	sta	step_rnd_offset
	a8

;======================================
;*   MISSION MAP Params Set		 *
;======================================
	shorta
	longi
;* Corneria HP *
	km_setval	kx_CorneriaHP,corneriaHP

;* Clear Params *
	ldx	#0
	stx	kx_basicscore	;kw_totalscore1
	stx	kx_basicscore+2	;kw_totalscore1+2
	stx	kx_TOTALTIME
	stx	ecountmissile
	stx	ecountfighter

	a16
	ldx	kdifficulty
	km_loblda.l	mm_planetkazutbl,x
	sta	kx_planetkazu		;planet no kazu
	sta	kx_initplanetkazu

	km_loblda.l	bs_totalkazutbl,x
	sta	kx_initbattleshipkazu
	sta	kx_battleshipkazu
	sta	kx_battleshipzaico
	sta	kx_battleshipzaicoptr

	km_loblda.l	clrtotalkazutbl,x
	sta	kx_initmissiontotal
	sta	kx_missiontotal		;mission no tatal kazu
	a8

;=====================================================================
;*								*
;*		Planet & Enemy List Initial 			* 
;* data bank :7e							*
;=====================================================================
;battle ship base skill *
	ldx	kdifficulty
	lda.l	bsskillbasetbl,x
	sta	kx_battleshipskillptr
;---------------------------------------------------------------------
;* Planet Free List Format *
	jsr	FormatPlanetList
;* Enemy Free List Format *
	jsr	FormatEnemyList
;---------------------------------------------------------------------
;******** Planet List (Enemy List) *********
;* Corneria Planet Set *
	jsr	SetCorneria

;* Random Planet Set *
	jsr	SetRandomPlanet

;* Item Planet *
	jsr	SetItemPlanet

;* Set Battle Ship *
	jsr	Init_BattleShipPtr

;* Set Hankyuu Toshi *
	jsr	SetFinalBoss

;* Set satellite *
	jsr	SetSatellite

;* mother ship states*
	jsr	SetMotherShip	;satellite yori ushiro de priority UP !!

;---------------------------------------------------------------------
;* BGM Initial *
	km_stxval	kw_mmBGMPtr,0

;* mission map time chart initial pointer *
	a16
	ldx	kdifficulty2
	lda.l	.chartinitptr,x
	sta	kx_mismaptmchart

;* timan kazu initial *
	ldx	kdifficulty
	km_loblda.l	.taimankazutbl,x
	sta	kx_specialclearcnt

;* virus freeze *
	km_setmismapevflag	virusbornfreeze

;* moshi mission explain wo surunara !! *
	km_bitcheckmistotalflag	explain1
	beq	.RetryGame

;------------------
;* Mission Explain*
;------------------
	longa
.Explain
	km_setmismapchflag	tmchartenable
	km_stxval	kx_MisMapSeq,mmseq_TimeChartCheck
	brl	mmlist_common
;------------------------------------------------------------------------------
	longa
.RetryGame
	km_setmismapchflag	tmchartenable
	km_stxval	kx_MisMapSeq,mmseq_TimeChartCheck
;* BGM *
	a8
	km_setval	kw_mmBGM,1
	a16
	brl	mmlist_common
;------------------------------------------------------------------------------
.chartinitptr
	dw	(mmchart_easy-mmchart_timechart)&WM
	dw	(mmchart_normal-mmchart_timechart)&WM
	dw	(mmchart_hard-mmchart_timechart)&WM

.taimankazutbl
	db	sp_easykazu
	db	sp_normalkazu
	db	sp_hardkazu
;------------------------------------------------------------------------------

;=====================================================================
;*								*
;*			Start Mother Ship	[RETRY]		*
;*								*
;=====================================================================
;------------------
;* Normal Mission *
;------------------
init_normal
	longa
	km_setval	kx_MMPlayerSeq,plseq_starttrig
	brl	mmlist_common

;=====================================================================
;*								*
;*			Partner Continue			*			
;*								*
;=====================================================================
init_partnercontinue
	a8
	longi
;* flag *
	km_setmismapflag	returnmap		;[mission kara modotte kita flag]

;* player type *	;(gameover.asm)
;;;	km_setvar	p1_pilotNo,p2_pilotNo
;;;	km_setvar	karpltype1,karpltype2
;* player HP *	;(gameover.asm)
;;;	jsl	playerstatus_init_l	;(For Kawagoe)

;* arwing initial postion *
;	km_setvar	mmx_arwingposx+1,kx_mshipx
;	km_setvar	mmx_arwingposy+1,kx_mshipy
;* Player Sound *
	KSoundPlayerTrans
	bra	mmlist_end
;=====================================================================
;*			Common Sequence				*
;=====================================================================
mmlist_common
	longa
	km_setflag16	mmx_arwingflag,mmf_notdisplay
;=====================================================================
;*			END of Sequence				*
;=====================================================================
mmlist_end
	plb
	plp
	rtl

;---------------------------------------------------------------------
;*		Planet no kazu Table				*
;---------------------------------------------------------------------
mm_planetkazutbl
	db	planetkazu_easy		;easy
	db	planetkazu_normal	;normal
	db	planetkazu_hard		;hard

bs_totalkazutbl
	db	bskazu_easy		;easy
	db	bskazu_normal		;normal
	db	bskazu_hard		;hard

clrtotalkazutbl
	db	clrtotal_easy		;easy
	db	clrtotal_normal		;normal
	db	clrtotal_hard		;hard

;=====================================================================
;*		Free Enemy List Pointer				*
;* Yreg :Enemy List Pointer						*
;=====================================================================
freeenemylistptr
	phx
	phy
	php

	a16
	longi
	tyx	;Xreg <<<< Enemy List Pointer
	jsl	FreeEnemyList_l
	dec	kx_enemytotal

	plp
	ply
	plx
	rts

;=====================================================================
;*		Free Enemy List Pointer				*
;* Xreg :Enemy List Pointer						*
;=====================================================================
freeplanetlistptr
	phx
	phy
	php

	a16
	longi
	km_clrflag16.w	mmx_planetflag,mmpnf_all,x
	km_clrflag16.w	mmx_battleshipflag,mmbsf_all,x

	l_rem.w	kx_planetlistptr,kx_planetfreeptr

	plp
	ply
	plx
	rts
;=====================================================================
;*		Format	Planet List				*
;* Data Bank 7e							*
;=====================================================================
FormatPlanetList
	shorta
	longi
	a16
	stz	kx_planetlistptr
	stz	kx_corneriaptr
	fmtfreelst.w	kx_planetfreeptr,kx_planetlist&WM,planetkazumax,planetlistlen
	a8
	rts

;=====================================================================
;*		Format	Enemy List				*
;* Data Bank 7e							*
;=====================================================================
FormatEnemyList
	shorta
	longi
	a16
	stz	kx_enemychartptr
	stz	kx_enemytotal

	stz	kx_enlistptr
	fmtfreelst.w	kx_enfreeptr,kx_enemylist&WM,_enemynum,mmx_enemylen
	a8
	rts

;=====================================================================
;*								*
;*		Set Corneria Params				*
;* data bank :7e							*
;* Yreg :Corneria List Pointer					*
;=====================================================================
mmz_rndposptr	=	kz_y1	;2 byte
mmz_rndstgptr	=	kz_z1	;2 byte
mmz_planetcnt	=	kz_tpx	;2 byte
mmz_planetskill	=	kz_tpy	;1 byte
mmz_rndstgbaseptr	=	kz_x2	;2 byte
mmz_tmpwork		=	kz_y2	;2 bute
mmz_difficultyptr	=	kz_z2	;2 byte
;--------------------------------------------------
	SHORTA
	LONGI
SetCorneria
	km_setval	mmx_RndPlanetSX,corneriaX	;Planet Center X
	km_setval	mmx_RndPlanetSY,corneriaY	;Planet Center Y
	km_setval	mmx_RndPlanetStage,stg_stg1
	km_setval	mmx_RndPlanetName,planet_corneria

	jsr	SetPlanetList
	km_setflag16.w	mmx_planetflag,(mmpnf_corneria!mmpnf_complete),y
	sty	kx_corneriaptr
	rts

;=====================================================================
;*								*
;*		Set Mother Ship Params				*
;* data bank :7e							*
;* Yreg :Corneria List Pointer					*
;=====================================================================
	shorta
	longi
SetMotherShip

;********************** Planet List **********************
	lda	#mshipx
	sta	kx_mshipx		;Mother Ship Center X
	lda	#mshipx
	sta	mmx_RndPlanetSX		;Mother Ship Center X

	lda	#mshipy
	sta	kx_mshipy		;Mother Ship Center Y
	lda	#mshipy
	sta	mmx_RndPlanetSY		;Mother Ship Center Y
	km_setval	mmx_RndPlanetStage,planet_mothership
	km_setval	mmx_RndPlanetName,planet_mothership
	jsr	SetPlanetList

	a16
	km_setflag16.w	mmx_planetflag,(mmpnf_mothership!mmpnf_senryou),y
	km_setvar	kx_warpplaceptr,kx_CorneriaPtr

	km_setval	kx_planetbufnum,planet_corneria
	sta	kx_mshipcurrentnum

	sty	kx_MotherShipPlPtr

;********************** Enemy List **********************
	jsl	mm_getenemylistptrX_l
	txy
	sty	kx_MotherShipEnPtr
;* source *
	a8
	km_setval.w	mmx_enposx+1,mshipx,y
	km_setval.w	mmx_enposy+1,mshipy,y

	a16
	km_setval.w	mmx_envel,mshipwarpsp,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setflag16.w	mmx_enflags,(enfl_nocollision!enfl_mothership),y
	km_setval.w	mmx_entype,entyp_mothership,y
	km_setval.w	mmx_encoll,6,y		;collision

	a8
	rts

;=====================================================================
;*								*
;*		Set Random Planet Params			*
;* data bank :7e							*
;=====================================================================
;--------------------------------------------------
SetRandomPlanet
	php
	longi
;******* Planet 6 Planet Initial ***********
	ldx	#5*4
	ldy	#5
.Loop_Init
	PHX	;>>> Push Xreg
	PHY	;>>> Push Yreg

	a8
	lda.l	planetpostbl+0,x
	sta	mmx_RndPlanetSX		;Planet Center X
	lda.l	planetpostbl+1,x
	sta	mmx_RndPlanetSY		;Planet Center Y
	lda.l	planetpostbl+2,x
	sta	mmx_RndPlanetDX		;Planet Center X
	lda.l	planetpostbl+3,x
	sta	mmx_RndPlanetDY		;Planet Center Y

	tya
	sta	mmx_RndPlanetStage	;Planet Stage	    :(1 byte)
	sta	mmx_RndPlanetName	;Planet Name Number :(1 byte)

	jsr	SetPlanetList

;OutPut :Yreg (Planet List Pointer)
	a16
	km_setflag16.w	mmx_planetflag,(mmpnf_planet!mmpnf_bornfreeze!mmpnf_complete),y

	PLY	;<<< Pull Yreg
	PLX	;<<< Pull Xreg

	dey
	dex
	dex
	dex
	dex
	bpl	.Loop_Init	

;****** Senryou Sareru Planet no kouhochi Initial Pointer Get **** 
;----------------------------------------------------
;* Get Planet Pattern Pointer *
;easy   :0~5  :05 pattern
;normal :0~14 :20 pattern
;hard   :0~14 :15 pattern
;----------------------------------------------------
	longa
	longi
	lda	kdifficulty2	;Read Difficulty
	asl	a
	tax

	lda.l	randomtbl+2,x
	sta	kz_x1		;senryou planet base pointer

	lda.l	randomtbl+0,x	;pattern suu
	tax
	lda	kw_RndPlanetPtr	;ran suu
	jsl	kdivu16u8_sub_l
	tyx	;X reg (Pattern) <<< amari (Yreg)

	a8
	lda	kx_planetkazu
	km_cpumultu8u8	x
	a16
	clc
	adc	kz_x1
	sta	kx_senryoustgptr	;<<< Planet Stage Pattern Pointer
;-------------------------------------------------------------------------
	plp
	RTS





	IFEQ	1
mmz_rndposptr	=	kz_y1	;2 byte
mmz_rndstgptr	=	kz_z1	;2 byte
mmz_planetcnt	=	kz_tpx	;2 byte
mmz_planetskill	=	kz_tpy	;1 byte
mmz_rndstgbaseptr	=	kz_x2	;2 byte
mmz_tmpwork		=	kz_y2	;2 bute
mmz_tmpwork2		=	kz_z2	;2 bute
mmz_difficultyptr	=	kz_x3	;2 byte
;*** planet no kazu ***
	lda	kx_planetkazu
	sta	mmz_planetcnt

	km_lldm4x	kdifficulty	;Read Difficulty
	sta  	mmz_difficultyptr

;----------------------------------------------------
;* Planet Stage Base Pointer *
	lda.l	randomtbl+2,x
	sta	mmz_tmpwork
;----------------------------------------------------
;* Get Planet Pattern Pointer *
;easy   :0~5  :05 pattern
;normal :0~14 :20 pattern
;hard   :0~14 :15 pattern

	lda.l	randomtbl+0,x	;pattern suu
	tax
	beq	.no_pattern
	lda	kw_RndPlanetPtr
	jsl	kdivu16u8_sub_l
	tyx	;X reg (Pattern) <<< amari (Yreg)
.no_pattern
	ifne	randominfo
	ldx	#0
	endc

	a8
	lda	kx_planetkazu
	km_cpumultu8u8	x
	a16
	clc
	adc	mmz_tmpwork
	sta	mmz_rndstgptr	;<<< Planet Stage Pattern Pointer
;----------------------------------------------------
;* Initial Random Planet Order Number *
	longa
	km_setval	mmx_RndPlanetCnt,0
.LOOP
;* Random Postion Set
	ldx	mmz_rndstgptr		;stage number read pointer
	lda.l	randomtbl,x
	km_loba
	sta	mmx_RndPlanetStage	;Planet Stage
	sta	mmx_RndPlanetName	;Planet Name Number
	asl	a
	asl	a
	tax

	a8
	lda.l	planetpostbl+0,x
	sta	mmx_RndPlanetSX		;Planet Center X
	lda.l	planetpostbl+1,x
	sta	mmx_RndPlanetSY		;Planet Center Y
	lda.l	planetpostbl+2,x
	sta	mmx_RndPlanetDX		;Planet Center X
	lda.l	planetpostbl+3,x
	sta	mmx_RndPlanetDY		;Planet Center Y

	jsr	SetWarpStage
	jsr	SetPlanetList
;OutPut :Yreg (PLanet List Pointer)
	a16
	km_setflag16.w	mmx_planetflag,(mmpnf_planet!mmpnf_bornfreeze),y

	inc	mmz_rndstgptr
	inc	mmx_RndPlanetCnt
	dec	mmz_planetcnt
	km_BNE	.LOOP
.end
	plp
	rts

PlanetKazuTbl
	db	planetkazu_easy
	db	planetkazu_normal
	db	planetkazu_hard
	ENDC

;---------------------------------------------------------------------
;*			Set Warp Stage				*
;---------------------------------------------------------------------
	IFEQ	1
	shorta
	longi
SetWarpStage
;* Warp Select Postion *
	ldx	kx_planetmaxptr
	lda	mmx_RndPlanetName
	sta.w	kx_planetnamebuf,x
	lda	mmx_RndPlanetSX
	sta.w	kx_planetcxbuf,x
	lda	mmx_RndPlanetSY
	sta.w	kx_planetcybuf,x
	inc	kx_planetmaxptr
	rts
	ENDC

;=====================================================================
;*								*
;*	Appear Enemy in Enemy Base (Planet & BattleShip)	*
;* data bank :7e							*
;* Input:kz_tpx :loop counter					*
;* Yreg :planet List Pointer						*
;=====================================================================
SenryouPlanet
	php
	a16
	longi
.Next_Planet
	longa
	ldx	kx_senryoustgptr	;<<< Planet Stage Pattern Pointer
	km_loblda.l	randomtbl,x
	sta	kz_x1
;------------------------------------------
	ldy	kx_planetlistptr
.Planet_Search
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,y
	beq	.tugino_kouhochi
	lda.w	mmx_stage,y
	cmp	kz_x1
	beq	.Found
.tugino_kouhochi
	lda.w	mmx_planetnext,y
	tay
	bne	.Planet_Search
;------------------------------------------
;(Missile 1st Hassya)
.Found	;Yreg = Planet List Pointer
	km_bitcheckmistotalflag	missile_1st
	bne	.normal

	km_setmistotalflag	missile_1st
	lda	#1
	sta.w	mmx_soswaittm,y
	km_clrflag16.w	mmx_planetflag,mmpnf_bornfreeze,y
	bra	.set_tmpparams
;-------------------------------------------------------------------------
;(Normal Senryou)
.normal
	km_loblda.w	mmx_stage,y
	asl	a
	tax
	lda.l	.SOSappeartbl,x
	sta.w	mmx_soswaittm,y
;-------------------------------------------------------------------------
;* sos states *
.set_tmpparams
;(planet List)
	km_setflag16.w	mmx_planetflag,mmpnf_senryou,y
	km_clrflag16.w	mmx_planetflag,mmpnf_complete,y
	km_setval.w	mmx_psos,enbase_wait,y	;missile enable
	lda	#$8000
	sta.w	mmx_dokuroanm,y		;dokuro anime start
	inc	kx_senryoustgptr	;<<< Planet Stage Pattern Pointer

;* Check Init Wolf *
	lda	kdifficulty
	cmp	#dif_hard
	bne	.setwolfteam

	km_bitcheckmistotalflag		plhojyuu
	beq	.nosetwolfteam

	lda	kx_mshipcurrentnum
	cmp	#planet_corneria
	beq	.setwolfteam
	cmp.w	mmx_name,y
	bne	.setwolfteam
	km_setmismapflag2	returnmother
.setwolfteam
	tyx
	km_setflag16.w	mmx_planetflag,mmpnf_wolfprotect,y
	jsr	InitWolfTeam
.nosetwolfteam
;-------------------------------------------------------------------------
;* Planet no Kazu Check *
	inc	kx_senryoucurrent
	dec	mmx_senryoucnt
	km_bne	.Next_Planet
;-------------------------------------------------------------------------
.set_finish
;* OBJ colour change *
	km_setscreenflag	objcolpal
;-------------------------------------------------------------------------
.end
	plp
	rts
;=====================================================
;*		Appear Table			*
;=====================================================
.SOSappeartbl
	dw	sos_intstg1tm	;1
	dw	sos_intstg2tm	;2
	dw	sos_intstg3tm	;3
	dw	sos_intstg4tm	;4
	dw	sos_intstg5tm	;5
	dw	sos_intstg6tm	;6
	dw	sos_intshiptm	;7

;=====================================================================
;*								*
;*			Set Item Planet Params			*
;* data bank :7e							*
;* 								*
;=====================================================================
	SHORTA
	LONGI
SetItemPlanet
	ifeq	0
	ldx	kdifficulty
	lda	emedaleasy,x
	cmp.l	kemedaltbl,x
	km_bmi	.End
	endc
;******************  Planet List Pointer *****************
	km_setval	mmx_RndPlanetSX,itemplanetCX	;Planet Center X
	km_setval	mmx_RndPlanetSY,itemplanetCY	;Planet Center Y
	km_setval	mmx_RndPlanetStage,stg_stg1
	km_setval	mmx_RndPlanetName,planet_itemplanet
	jsr	SetPlanetList

	a16
	km_setval.w	mmx_planetskill,itemplanetskill,y
	km_setflag16.w	mmx_planetflag,(mmpnf_itemplanet!mmpnf_senryou),y
	km_setmismapflag2	itemplanet
	a8
	sty	kx_itemplanetplptr

;******************  Enemy List Pointer *****************
;* List Get *
	jsl	mm_getenemylistptrX_l
	txy
	sty	kx_itemplanetenptr

	a16
	lda	kx_itemplanetplptr
	sta.w	mmx_enlinkptr,y
	tax
	tya
	sta.w	mmx_bslinkptr,x

;* clear states *
	lda	#0
	sta.w	mmx_ensequence,y
	sta.w	mmx_enstratptr,y

;* postion *
	a8
	lda	#itemplanetCX
	sta.w	mmx_enposx+1,y	;
	lda	#itemplanetCY
	sta.w	mmx_enposy+1,y	;
;* flag *
	a16
	km_setflag16.w	mmx_enflags,(enfl_itemplanet),y
	km_setval.w	mmx_entype,entyp_itemplanet,y

;* animation *
	km_setval.w	mmx_enanmpatt,cd_objanime_itemplanet,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_enanmmax,48,y
	km_setflag16.w	mmx_enflags,enfl_demo,y
	km_setflag16.w	mmx_enflags2,enfl2_anmloop,y

;* collision *
	km_setval.w	mmx_encoll,3,y

	a8
.End
	rts

kemedaltbl
	db	kemedal_easy		
	db	kemedal_normal
	db	kemedal_hard		

;=====================================================================
;*								*
;*			Wolf Team Initial			*
;* data bank :7e							*
;* 								*
;* Xreg :Planet List Pointer						*
;* Yreg :Enemy  List Pointer						*
;=====================================================================
	longa
	longi
InitWolfTeam
	inc	kx_wolfcurrent

	jsl	mm_getenemylistptr_l
;* link *
	txa
	sta.w	mmx_enlinkptr,y	;planet list to LINK
;* dest *
	a8
	lda.w	mmx_planetcx,x
	clc
	adc	#4
	sta.w	mmx_enposx+1,y
	sta.w	mmx_endestx,y

	lda.w	mmx_planetcy,x
	sec
	sbc	#4
	sta.w	mmx_enposy+1,y
	sta.w	mmx_endesty,y

	a16
	lda	#0
	sta.w	mmx_enposx_l,y
	sta.w	mmx_enposy_l,y

	km_setval.w	mmx_ensequence,enseq_nothing,y
	km_setval.w	mmx_enstage,stg_sos2,y
	km_setflag16.w	mmx_enflags,enfl_wolf,y
	km_clrflag16.w	mmx_enflags,enfl_nocollision,y
	km_setflag16.w	mmx_enflags2,enfl2_planetprotect,y
	km_setval.w	mmx_entype,entyp_wolf,y
	km_setval.w	mmx_encoll,wolf_planetcollision,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y

	lda	mmx_senryoucnt
	sta.w	mmx_enwolfnum,y

;* enemy skill *
	ldx	#WOLF_SKILL-EASY_MISS_RAND
	jsl	eg_sosskill_l
	rts

;=====================================================================
;*								*
;*			Wolf Team Initial			*
;* data bank :7e							*
;* 								*
;* Xreg :Planet List Pointer						*
;* Yreg :Enemy  List Pointer						*
;=====================================================================
	longa
	longi
InitWolfTeam2
	PHX
	jsl	mm_getenemylistptr_l
;* source *
	a16
	km_setval.w	mmx_enposx,enemybaseX<<8,y
	km_setval.w	mmx_enposy,enemybaseY<<8,y

	km_bitcheckmismapflag2	wolfboss
	bne	.wolfboss
;----------------------------------------------------
.wolfteam
;* dest *
	a8
	lda.w	mmx_planetcx,x
	sta.w	mmx_endestx,y

	lda.w	mmx_planetcy,x
	sta.w	mmx_endesty,y
	a16
;* vel *
	km_setval.w	mmx_envel,$1800,y
	km_setval.w	mmx_ensequence,enseq_planetsenryou1,y

	ldx	#WOLF_SKILL-EASY_MISS_RAND
	bra	.set_common
;----------------------------------------------------
.wolfboss

;* link *
	lda	kx_FinalBossPlPtr
	sta.w	mmx_enlinkptr,y	;planet list to LINK
;* flag *
	km_setflag16.w	mmx_enflags2,enfl2_planetprotect,y
;* dest *
	km_setvar	kz_x1,mmx_posxbak
	km_setvar	kz_y1,mmx_posybak
	km_setval	kz_tpx,$0e
	km_setval	kz_tpy,$0e
	jsr	SetNearPos
;* vel *
	km_setval.w	mmx_envel,$2000,y

	km_setval.w	mmx_ensequence,enseq_spenappear1,y

;* enemy skill *
	ldx	#WOLFBOSS_SKILL-EASY_MISS_RAND
;----------------------------------------------------
.set_common
	jsl	eg_sosskill_l
	inc	kx_wolfcurrent
;* Set Angle  *
	km_setflag16.w	mmx_enflags,enfl_wolf,y
	km_setflag16.w	mmx_enflags,enfl_nocollision,y

	km_setval.w	mmx_enstage,stg_sos2,y
	km_setval.w	mmx_entype,entyp_wolf,y
	km_setval.w	mmx_encoll,wolf_appearcollision,y
	km_setval.w	mmx_enstratptr,enstrat_posvel,y
	km_setval.w	mmx_enwolfnum,0,y

	PLX
	rts






	IFEQ	1

	ldx	#0
	ldy	kx_planetlistptr
.LOOP
;* moshi mother ship nara SKIP !! *
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,y
	beq	.nextplanet
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_senryou,y
	bne	.nextplanet
;-------------------------------------------------------------------------
	km_bitcheckmistotalflag	missile_1st
	bne	.normal

	km_setmistotalflag	missile_1st
	lda	#1
	sta.w	mmx_soswaittm,y
	km_clrflag16.w	mmx_planetflag,mmpnf_bornfreeze,y
	bra	.set_tmpparams
;-------------------------------------------------------------------------
.normal
	km_loblda.w	mmx_stage,y
	asl	a
	tax
	lda.l	.SOSappeartbl,x
	sta.w	mmx_soswaittm,y
;-------------------------------------------------------------------------
;* sos states *
.set_tmpparams
	km_setflag16.w	mmx_planetflag,mmpnf_senryou,y
	km_setval.w	mmx_psos,enbase_wait,y	;missile enable

	lda	#$8000
	sta.w	mmx_dokuroanm,y		;dokuro anime start

	dec	kz_tpx
	beq	.set_finish
;-------------------------------------------------------------------------
.nextplanet
	inx
	inx
	lda.w	mmx_planetnext,y
	tay
	km_bne	.LOOP
;-------------------------------------------------------------------------
.set_finish
;* OBJ colour change *
	km_setscreenflag	objcolpal
;-------------------------------------------------------------------------
.end
	plp
	rts
	ENDC

;=====================================================================
;*								*
;*			Planet List Initial			*
;* data bank :7e							*
;* OutPut 								*
;* Yreg :Planet List Pointer						*
;=====================================================================
	shorta
	longi
SetPlanetList
	phx
;* Get Planet List Buffer & Pointer *
	ldx	#0
	l_add.w	kx_planetlistptr,kx_planetfreeptr,mim_blink
	txy

;* Planet Params *
	lda	mmx_RndPlanetSX		;Planet Center X
	sta.w	mmx_planetcx,y
	km_divu8
	sta.w	mmx_scrcx,y

	lda	mmx_RndPlanetSY		;Planet Center Y
	sta.w	mmx_planetcy,y
	km_divu8
	sta.w	mmx_scrcy,y

	lda	mmx_RndPlanetDX
	sta.w	mmx_destx,y
	lda	mmx_RndPlanetDY
	sta.w	mmx_desty,y

	lda	kdifficulty
	asl	a
	sta.w	mmx_planetskill,y	Set Planet Skill

	a16
	km_loblda	mmx_RndPlanetStage
	sta.w	mmx_stage,y		;Planet Stage No
	km_loblda	mmx_RndPlanetName
	sta.w	mmx_name,y		;Planet Name
;* flag *
	a8
	plx
	rts

;=====================================================================
;*		Mission Battle Ship Initial			*
;=====================================================================
	shorta
	longi
Init_BattleShipPtr
	a16
	lda	kdifficulty
	asl	a
	tax
	lda.l	bs_basedata,x
	sta	kx_battleshipptr
	a8
	rts

;=====================================================================
;*								*
;*		Set Battle Ship States				*
;* data bank :7e							*
;* Yreg <<< Enemy List Pointer					*
;=====================================================================
SetBattleShip
	php

	a16
	ldx	kx_battleshipptr
	lda.l	bs_basedata,x
	km_beq	.end

	inx
	inx
	stx	kx_battleshipptr	;Next Data Pointer
	tax
	a8

	lda.l	bs_basedata,x
	sta	kx_battleshipcurrent	;Battle ship no kazu
	sta	mmx_battleshipcnt	;tmp loop counter set
	inx
.loop
	lda	kx_battleshipzaico
	km_beq	.end

;******** Planet List ni Set *********

	km_setval	mmx_RndPlanetName,planet_battleship
	km_setval	mmx_RndPlanetStage,stg_sos3

	lda.l	bs_basedata,x
	sta	mmx_BShipType	;Battle Ship Type
	inx

	a16
	lda.l	bs_basedata,x
	inx
	inx
	PHX	;>>>>>
	tax
	a8
	lda.l	bs_basedata,x
	sta	mmx_RndPlanetSX	;Battle Ship Appear Postion X
	lda.l	bs_basedata+1,x
	sta	mmx_RndPlanetSY	;Battle Ship Appear Postion Y
	lda.l	bs_basedata+2,x
	sta	mmx_RndPlanetDX	;SOS Enemy Dest Postion X
	lda.l	bs_basedata+3,x
	sta	mmx_RndPlanetDY	;SOS Enemy Dest Postion Y
	jsr	SetPlanetList

	lda.l	bs_basedata+4,x
	sta.w	mmx_planetcannonsx,y
	sta	mmx_cannonPointX		;Planet cannon Fire Enable Pos X
	lda.l	bs_basedata+5,x
	sta.w	mmx_planetcannonsy,y
	sta	mmx_cannonPointY		;Planet cannon Fire Enable Pos Y
	lda.l	bs_basedata+6,x
	sta.w	mmx_planetcannondx,y	;Planet cannon Fire Dest Pos X
	lda.l	bs_basedata+7,x
	sta.w	mmx_planetcannondy,y	;Planet cannon Fire Dest Pos Y

; Yreg = Planet List Pointer 
	sty	mmx_RndPlanetPtr
;* flag set *
	a16
	km_setflag16.w	mmx_planetflag,(mmpnf_battleship!mmpnf_senryou),y
	km_clrflag16.w	mmx_battleshipflag,mmbsf_type,y

;* battle ship type *
	lda	mmx_battleshipcnt	;tmp loop counter set
	and	#1
	beq	.skipaaa
	km_setflag16.w	mmx_battleshipflag,mmbsf_type,y
.skipaaa
;******** Enemy List ni SET ***********
	km_loblda	mmx_BShipType
	tax
	lda.l	mm_ZacoChartTable,x
	sta.w	mmx_zacochartptr,y
	km_setval.w	mmx_psos,enbase_inittime,y
	a8
	jsr	SetBSEnlist

;******** Child List wo SET ***********
;* Battle Ship Appear (Child List) *
;;;	jsr	Init_BSAppear

	inc	kx_battleshipskillptr
	inc	kx_battleshipskillptr
	a8
	PLX	;<<<<<
	dec	mmx_battleshipcnt
	km_bne	.loop
.end
	plp
	rts
;=====================================================================
;*								*
;*		Set Enemy List (Battle Ship)			*
;*								*
;=====================================================================
SetBSEnlist
	php

	ai16
;* List Get *
	jsl	mm_getenemylistptr_l
;* source * <<<<
	dec	kx_battleshipzaicoptr	;battle ship no nokori !!

	lda	kx_battleshipzaicoptr	;battle ship no nokori !!
	asl	a
	tax
	a8
	lda.l	BS_ZaicoData+0,x
	clc
	adc	#8
	sta.w	mmx_enposx+1,y	;Battle Ship Disappear Point X
	lda.l	BS_ZaicoData+1,x
	clc
	adc	#8
	sta.w	mmx_enposy+1,y	;Battle Ship Disappear Point Y

;* dest * <<<<
	lda	mmx_RndPlanetSX
	sta.w	mmx_endestx,y	;Battle Ship Appear Point X
	lda	mmx_RndPlanetSY
	sta.w	mmx_endesty,y	;Battle Ship Appear Point Y

;* velocity (x,y), AngY <---[source(x,y),dest(x,y)] *
	a16
	km_setval.w	mmx_envel,btship_apsp,y	;syutugen speed
	jsl	calc_enangvelxy_l
	a8

;* stage *
	lda	mmx_RndPlanetStage
	sta.w	mmx_enstage,y

;* flag *
	a16
	km_setflag16.w	mmx_enflags,(enfl_battleship!enfl_demo!enfl_nocollision),y
	km_setflag16.w	mmx_enflags2,enfl2_nojet,y

;* Enemy Stratage *
	lda	#enstrat_nothing
	sta.w	mmx_enstratptr,y	;stratage pointter

;* Sprite Animation *
	a16
	lda	#0
	sta.w	mmx_enanmpatt,y
	lda	#bsseq_appeardemowait
	sta.w	mmx_ensequence,y

	lda	#btship_aptm
	sta.w	mmx_enwaittm,y		;Battle Ship Appear Timing
	a8
;* collision *
	lda	#btship_collision
	sta.w	mmx_encoll,y		;collision

	a16
; Xreg = Planet List Pointer 
; Yreg = Enemy List Pointer 
	ldx	mmx_RndPlanetPtr
	tya
	sta.w	mmx_bslinkptr,x	;Enemy List ni Link
	txa
	sta.w	mmx_enlinkptr,y	;Planet List Link

	lda	#entyp_battleship
	sta.w	mmx_entype,y
;* skill *
	lda	kx_battleshipskillptr
	sta.w	mmx_planetskill,x
	sta.w	mmx_enskill,y
;* planet cannon attack point *
	lda	#PlanetcannonAp
	sta.w	mmx_enattackpo,y
	lda	#1
	sta.w	mmx_enkazu,y

	plp
	rts


;=====================================================================
;*								*
;*		Initila Battle Ship Appear Demo			*
;* Xreg   :Child  List Pointer (Break)				*
;* Yreg   :Enemy List Pointer  (Input,Keep)				*
;* kwork  :Link Pointer						*
;* kwork+2:Loop Counter						*
;=====================================================================
	IFEQ	1
Init_BSAppear
	php
	a16
	km_setval	kwork,0	;link end code
	km_setval	kwork+2,6
.LOOP
	jsr	GetChildList
	km_setflag16.w	mmx_enflags,(enfl_child!enfl_nocollision),x
	lda	kwork
	sta.w	mmx_enchildlinkptr,x
	lda.w	mmx_enposx,y
	sta.w	mmx_enposx,x
	lda.w	mmx_enposy,y
	sta.w	mmx_enposy,x
	lda.w	mmx_endestx,y
	sta.w	mmx_endestx,x
	lda.w	mmx_endesty,y
	sta.w	mmx_endesty,x
	lda.w	mmx_envelx,y
	sta.w	mmx_envelx,x
	lda.w	mmx_envely,y
	sta.w	mmx_envely,x
	lda	#5
	sta.w	mmx_encoll,x
	lda	kwork+2
	sta.w	mmx_enwaittm,x

	lda	#enstrat_nothing
	sta.w	mmx_enstratptr,x

	stx	kwork		;Link Pointer
	dec	kwork+2
	dec	kwork+2
	bne	.LOOP	

	txa
	sta.w	mmx_enchildlinkptr,y
	plp
	rts
;---------------------------------------------------------------------
;*			Get Child List				*
;* Out Put :Xreg = Child List Pointer				*
;* Yreg    :Keep							*
;---------------------------------------------------------------------
GetChildList
	phy
	php
	a16

;* Get Child List Buffer & Pointer *
	ldx	#0
	l_add.w	kx_enlistptr,kx_enfreeptr,mim_blink

	plp
	ply
	rts
	ENDC


;=====================================================================
;*			Data Tables				*
;=====================================================================
bs_basedata
	dw	bs_easy_ptr-bs_basedata
	dw	bs_normal_ptr-bs_basedata
	dw	bs_hard_ptr-bs_basedata
;-----------------------------------------------------
;* data pointer address *
bs_easy_ptr	dw	bs_easy-bs_basedata
	dw	0	;end code

bs_normal_ptr
	dw	bs_normal1-bs_basedata
	dw	bs_normal2-bs_basedata
	dw	0

bs_hard_ptr	dw	bs_hard1-bs_basedata
	dw	bs_hard2-bs_basedata
	dw	0
;-----------------------------------------------------
bs_easy
	db	2
	db	btship_zacotype1
	dw	btship_A-bs_basedata	;(source,dest)
	db	btship_zacotype2
	dw	btship_C-bs_basedata	;(source,dest)
bs_normal1
	db	2
	db	btship_zacotype3
	dw	btship_A-bs_basedata	;(source,dest)
	db	btship_zacotype4
	dw	btship_C-bs_basedata	;(source,dest)
bs_normal2
	db	2
	db	btship_zacotype5
	dw	btship_A-bs_basedata	;(source,dest)
	db	btship_zacotype6
	dw	btship_C-bs_basedata	;(source,dest)
bs_hard1
	db	2
	db	btship_zacotype7
	dw	btship_A-bs_basedata	;(source,dest)
	db	btship_zacotype8
	dw	btship_C-bs_basedata	;(source,dest)
bs_hard2
	db	2
	db	btship_zacotype9
	dw	btship_A-bs_basedata	;(source,dest)
	db	btship_zacotype10
	dw	btship_C-bs_basedata	;(source,dest)
;-----------------------------------------------------
btship_A
	db	btship_ASX,btship_ASY
	db	btship_AEX,btship_AEY
	db	cannon_ASX,cannon_ASY
	db	cannon_AEX,cannon_AEY

btship_C
	db	btship_CSX,btship_CSY
	db	btship_CEX,btship_CEY
	db	cannon_CSX,cannon_CSY
	db	cannon_CEX,cannon_CEY

;=====================================================================
;*								*
;*		Set Satellite Params				*
;* data bank :7e							*
;* Yreg :Enemy List Pointer						*
;=====================================================================
	shorta
	longi
SetSatellite
	php
;******************  Planet List Pointer *****************
	a8
	km_setval	mmx_RndPlanetSX,satellitecx
	km_setval	mmx_RndPlanetSY,satellitecy
	km_setval	mmx_RndPlanetName,planet_friendside
	jsr	SetPlanetList

	a16
	km_setflag16.w	mmx_planetflag,(mmpnf_satellite!mmpnf_senryou),y
	sty	kx_satelliteplptr

;******************  Enemy List Pointer *****************
;* List Get *
	jsl	mm_getenemylistptrX_l
	txy
	sty	kx_satelliteenptr

	lda	kx_satelliteplptr
	sta.w	mmx_enlinkptr,y
	tax
	tya
	sta.w	mmx_bslinkptr,x

;* clear states *
	lda	#0
	sta.w	mmx_ensequence,y
	sta.w	mmx_enstratptr,y

;* postion *
	a8
	lda	#satellitecx
	sta.w	mmx_enposx+1,y	;
	lda	#satellitecy
	sta.w	mmx_enposy+1,y	;
;* flag *
	a16
	km_setflag16.w	mmx_enflags,(enfl_satellite!enfl_nocollision),y
	km_setflag16	kx_satelliteflag,safl_charge

	km_setval.w	mmx_entype,entyp_satellite,y
;* angle *
	lda	#0
	sta.w	mmx_enangY,y	;

	km_setval.w	mmx_enmvwaittm,sa_angletm,y

;* Attack Point *
	km_setval.w	mmx_enattackpo,sa_atpo,y
	km_setval.w	mmx_enkazu,1,y

;* collision *
	lda	#8
	sta.w	mmx_encoll,y	;collision

;* init tame time *
	ldx	kdifficulty2
	lda.l	.tametimetbl,x
	sta.w	mmx_enwaittm,y

	plp
	rts

.tametimetbl
	dw	sa_tameinittmE
	dw	sa_tameinittmN
	dw	sa_tameinittmH
;=====================================================================
;*								*
;*		Set Special Enemy States			*
;* data bank :7e							*
;* Yreg <<< Enemy List Pointer					*
;=====================================================================
SetSpecialEnemy
	php
	ai16
	lda	kx_specialclearcnt
	sta	mmx_specialapcocnt	;appear suru special enemy no kazu !!
	dec	a
	sta	mmx_specialaploop
.LOOP
;* List Get *
	jsl	mm_getenemylistptr_l
;* flag *
	km_setflag16.w	mmx_enflags,(enfl_special!enfl_demo),y


;* stage *
	lda	#stg_sos4
	sta.w	mmx_enstage,y
	lda	#entyp_special
	sta.w	mmx_entype,y	;enemy type

	lda	#1
	sta.w	mmx_enkazu,y

	lda	#sos_taimanatpo
	sta.w	mmx_enattackpo,y

;* eguchi's states *
	a8
	ldx	mmx_specialaploop	;appear suru special enemy no kazu !!

	km_loblda.l	.mm_taimanposXtbl,x
	sta.w	mmx_endestx,y		;dest postion X

	lda	#$1c
	clc
	adc.w	demotaiman,x
	a16	
	and	#$ff
	sta.w	mmx_enskill,y
	tax
	lda.l	SOS1_target,x
	sta	kz_tpa
	lda.l	SOS1_target_shape_A,x
	sta	kz_tpx
	lda.l	SOS1_target_shape_B,x
	sta	kz_tpy
	jsl	eg_states_l	;(For Eguchi's States)

	lda	#enemybaseX<<8
	sta.w	mmx_enposx,y
	lda	#enemybaseY<<8
	sta.w	mmx_enposy,y

	km_setval.w	mmx_envel,$2000,y

	lda	#$60
	sta.w	mmx_endesty,y
	jsl	calc_enangvelxy_l

	lda	#enseq_spenappear1
	sta.w	mmx_ensequence,y
	lda	#enstrat_straight
	sta.w	mmx_enstratptr,y
	km_setval.w	mmx_enanmpatt,-1,y
	km_setval.w	mmx_enwaittm,1,y

;* collision *
	lda	#taiman_collision
	sta.w	mmx_encoll,y		;collision

;* muteki Timer *
	lda	#3*8
	sta.w	mmx_eninvtm,y

	inc	kx_specialcurrent

	dec	mmx_specialaploop	;appear suru special enemy no kazu !!
	km_BPL	.LOOP
	km_setflag16	kw_mmsoundflag,mmsndf_specialappear
.end
	plp
	rts


.mm_taimanposXtbl
	db	$40
	db	$70
	db	$a0
	db	$d0

;=====================================================================
;*								*
;*		Set Final Boss Params				*
;* data bank :7e							*
;* Yreg :Enemy List Pointer						*
;=====================================================================
	shorta
	longi
SetFinalBoss
;************ Planet List *************
	km_setval	mmx_RndPlanetSX,enemybaseX
	km_setval	mmx_RndPlanetSY,enemybaseY
	km_setval	mmx_RndPlanetDX,satellitecx
	km_setval	mmx_RndPlanetDY,satellitecy
	km_setval	mmx_RndPlanetStage,stg_ext1
	km_setval	mmx_RndPlanetName,planet_nothing
	jsr	SetPlanetList
	km_setflag16.w	mmx_planetflag,mmpnf_finalboss,y
	sty	kx_FinalBossPlPtr

;************ Enemy List **************
	jsl	mm_getenemylistptrX_l
	txy
	sty	kx_FinalBossEnPtr
;* source *
	a8
	km_setval.w	mmx_enposx+1,enemybaseX,y
	km_setval.w	mmx_enposy+1,enemybaseY,y
;* dest * 
	a16
	km_setval.w	mmx_endestx,satellitecx,y
	km_setval.w	mmx_endesty,satellitecy,y
	km_setval.w	mmx_enstage,stg_ext2,y

	km_setval.w	mmx_enanmpatt,cd_objanime_bossappear,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_enanmmax,80,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setval.w	mmx_encoll,6,y

	km_setflag16.w	mmx_enflags,(enfl_demo!enfl_nocollision!enfl_finalboss),y
	km_setval.w	mmx_entype,entyp_finalboss,y
	km_setflag16.w	mmx_enflags2,(enfl2_anmloop),y
	a8
	rts

;=====================================================================
;*								*
;*			Initial Mission Map Sound		*
;*								*
;=====================================================================
Init_MMSound
;memo :kanarazu mm_checkmiscomplete no atoni set !!!
	a16
	km_setsndmode
	km_bitcheckmistotalflag	explain1
	bne	.sound_explain

	km_bitcheckmismapstflag	wolfbossdead
;;;;	km_bitcheckmistotalflag	finalbossbattle	;[missiontotal flag]
	bne	.sound_finalboss
;----------------------------------------------------------------------
.normal_sound
	a8
	km_ldxsoundtblptr
	KSoundBGMTrans
;	kbgm	muteon
	lda	kw_mmBGM
	KBGM_a
	bra	.end_sound
;----------------------------------------------------------------------
	longa
.sound_finalboss
;(inagaki :comment)
	km_setsndmode	selectmissionmapfinal
	bra	.skip_sound
;----------------------------------------------------------------------
.sound_explain
	longa
	km_setsndmode	selectmissionmapexp
;----------------------------------------------------------------------
.skip_sound
	a8
	km_ldxsoundtblptr
	KSoundBGMTrans
;----------------------------------------------------------------------
.end_sound
	rts

;=====================================================================
;*								*
;*			Initial Mario Params			*
;* data bank 7e							*
;=====================================================================
mm_setmarioparms
	shorta
	longi
;---------------------------------------------
;* 	Mario Program Initial		*
;---------------------------------------------
;--- Draw Map Set ----
	lda	drawmap+1
	lsr	a
	lsr	a
	sta.l	mscrbase
	a16
	lda	drawmap
	sta.l	m_drawmap

;* Base Address Set *
	longa
	lda	#bitmapbase&WM	;$700000
	clc
	adc	drawmap
	sta.l	m_x1		;top address

	km_setval.l	m_x2,mm_wbuflength	;16chr(yoko)*16chr(tate)*32
	km_setval.l	m_scale,(15*32768)/16
	sta.l	mspr_pal

;---------------------------------------------
;* Planet Data Copy ( Mario Data Copy)	*
;---------------------------------------------
	longa
;--- For Message ---
	km_stxvar	mmx_mapstates,mmx_cursorflag

;----- Message List Copy to Mario RAM ------
	km_bitcheckmismapflag	finalboss
	bne	.finalboss_skip
	jsl	yjmapmain_l
	lda.l	m_mapBG1scrollY
	sta.l	kx_vscrollp1
.finalboss_skip

	km_blocktrans	kx_messagelist,m_mapcursor,messagelistlen

	a8
	rts

;=====================================================================
;*			COPY to HEAP RAM			*
;* data bank :7e							*
;=====================================================================
mm_heapcopy
	shorta
	longi
	phb
	db7e
;**** Initialises free memory list ****
	jsl	initmem_l

;*************************
;*    RAM PROGRAM COPY   *
;*************************
	a16
	lda	#heap_proglen
	jsl	alloc_l
	sta	mmx_ramprogaddr
;* program copy *
	tay
	ldx	#0	
	a8
.nxt
	lda.l	heap_runmariostart_l,x
	sta.w	heap,y
	inx
	iny
	cpx	#heap_proglen
	bne	.nxt

	a16
	lda	mmx_ramprogaddr
	clc
	adc	#heap
	sec
	sbc	#heap_runmariostart_l&WM
	sta	mmx_ramprogptr
	a8
;*******************************************************
;*    OBJ CGX RAM KEEP (HEAP)  kurukuru Arwing no CGX  *
;*******************************************************
objcgxbuffer_len	equ	$1000

	a16
	lda	#objcgxbuffer_len&WM
	jsl	alloc_l
	sta	mmx_objcgxaddr

;* arwing cgx (OBJ CGX) wo heap RAM ni copy *
	decram	e7_ccr,0

	a8
	ldx	mmx_objcgxaddr
	km_dmaromXram	0,($700000+dec_base),heap,cgxbuffer_len

;*************************************************************
;* OAM Pattern Data (Arwing kuru kuru pattern Data) Copy 	*
;*************************************************************
	a16
	lda	#mm_sprarwinglen
	jsl	alloc_l
	sta	mmx_sprarwingaddr

;* sprite (arwing) no pattern datacopy *
	tay
	ldx	#0
	a8
.nxt_arwing
	lda.l	mm_sprarwing,x
	sta.w	heap,y
	inx
	iny
	cpx	#mm_sprarwinglen
	bne	.nxt_arwing

;-------------------------------------
	plb
	rts

;*********************************************************************
;*								*
;*		Initial Mission Map Select			*
;*								*
;*********************************************************************
	shorta
	longi
Init_MMScreen
	phb
	db0
	screen_off
	
	jsr	Initial_MissionMap_PPUreg

	jsl	VRAMClear_l

	jsr	Set_MMBG1CGX
	jsr	Set_MMBG1SCR

	jsr	Set_MMBG2CGX
	jsr	Set_MMBG2SCR

	jsr	Set_MMBG3CGX
	jsr	Set_MMBG3SCR

	jsr	Set_MMCOL

	plb
	rts

;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
Initial_MissionMap_PPUreg
	shorta

	lda	#%00001001
	sta	bgmode		;BG mode1,bg3 pri

	lda	#(mm_bg1_scr>>8)&$fc!scrsizeyoko2 ;BG1 SCR screen yoko 2
	sta	bg1sc

	lda	#(mm_bg2_scr>>8)&$fc!scrsizeyoko2
	sta	bg2sc			;BG2 SCR screen 2
	sta	kw_bg2sc

	lda	#(mm_bg3_scr>>8)&$fc!scrsizeyoko2
	sta	bg3sc			;BG3 SCR ,screen 2

; set mario chip to point to the screen
	lda	vmap2+1
	sec
	sbc	#(mm_fixbg1cgxlength/2)>>8
	and	#$0f0
;;;;	sta	kz_x1
	lsr	a
	lsr	a
	lsr	a
	lsr	a
;;;	ora	kz_x1
;;;	and	#$0f0
;;;	ora	#(mm_bg1_cgx_1>>12)&$0f
	sta	bg12nba			;BG1 (0000) ,BG2 (0000)
	sta	kw_bg12nba

	lda	#(mm_bg3_cgx>>12)&$0f	;BG3 (32*k/2)
	sta	bg34nba

	lda	#(mm_obj_cgx>>13)
	sta	objsel			;OBJ

	lda	#%00010111
	sta	tm	 		;BG1,BG2,BG3,OBJ display
	sta	kw_tm
	sta	kw_tmbackup
	lda	#%00000000
	sta	ts
	rts
;=====================================================================
;*			Initial BG1 Character Data		*
;=====================================================================
Set_MMBG1CGX
;	decvramnotrans	0,mm_enbase_cgx_1,b10_ccr,($40*32)
;	decvramnotrans	0,mm_enbase_cgx_2,b10_ccr,($40*32)
	rts
;=====================================================================
;*			Initial BG1 Screen Data			*
;=====================================================================
Set_MMBG1SCR
	decvramnotrans	0,mm_bg1_scr,b7_pcr,$800*2
	rts
;=====================================================================
;*			Initial BG2 Character Data		*
;=====================================================================
Set_MMBG2CGX
	decvramnotrans	0,mm_bg2_cgx_1,b7_ccr,($c0*32)
	decvramnotrans	0,mm_bg2_cgx_2,b8_ccr,($c0*32)
	rts
;=====================================================================
;*			Initial BG2 Screen Data			*
;=====================================================================
Set_MMBG2SCR
	decvramnotrans	0,mm_bg2_scr,b8_pcr,$800*2
;----------------------------------------------------------------------
;* Screen kakikae Buffer *
	a16
	ldx	#mm_bitmapbg2start
	ldy	#mm_scrbufbg2start
	km_setval	kz_x1,mm_scrbg2len/2
	jsr	kcopyscreen_sub

	phb
	db7e
	km_setmismapstflag	corneriadamage
;;;	jsr	mm_dispdamage_sub
	jsr	mm_dispgametotaltm_sub
	plb

	a8
;----------------------------------------------------------------------
;* BGCheck Buffer *
;* mario RAM ni BG check data wo tenkai !! *
	km_decrunchscr	b11

	phb
	db7f
	ldx	#0
	ldy	#0
.nxt_scr
;400h byte copy
	lda.l	bitmapdecbase,x
	sta.w	BGcheckBuffer,y
	inx
	inx
	iny
	cpx	#$800
	bne	.nxt_scr
	plb

	IFEQ	1
;* senkan *
	km_setval	kz_x1,cannon_ASX/8
	km_setval	kz_y1,cannon_ASY/8
	km_convSCRCheckaddr_32X
	lda	#9
	sta.l	BGcheckBuffer+00,x
	sta.l	BGcheckBuffer-01,x

	km_setval	kz_x1,cannon_CSX/8
	km_setval	kz_y1,cannon_CSY/8
	km_convSCRCheckaddr_32X
	lda	#9
	sta.l	BGcheckBuffer+00,x
	sta.l	BGcheckBuffer-32,x
	sta.l	BGcheckBuffer+32,x
	ENDC

.end
	rts


;=====================================================================
;*			Initial BG3 Character Data		*
;=====================================================================
Set_MMBG3CGX
	decvramnotrans	0,mm_bg3_cgx,b4_ccr,($100*16)
	rts
;=====================================================================
;*			Initial BG3 Screen Data			*
;=====================================================================
Set_MMBG3SCR
	decvramnotrans	0,mm_bg3_scr,b10_pcr,$800*2
	rts
;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_MMCOL
	decrunch_palettes
	km_IRQdmaRAMtoCGRAM	b7_pac,0,$200
	km_IRQdmaRAMtoColBuf	b7_pac,16
	km_IRQdmaRAMtoRAM	b8_pac,kx_palette2,256
	km_IRQdmaRAMtoRAM	b11_pac,kx_palette3,256
	km_IRQdmaRAMtoRAM	b9_pac,kx_palette4,256

	lda.l	kx_CorneriaDamage
	cmp	#corneriaAttentionDamage
	bcc	.NoChange
	ldx	#0
	cmp	#corneriaDangerDamage
	bcc	.set
	ldx	#6
.Set
	jsr	SetDamageColour
.NoChange
	rts

;*********************************************************************
;*								*
;*		Planet Screen Data Transfer			*
;*								*
;*********************************************************************
	IFEQ	1
;---------------------------------------------------------------------
kcx	= kz_X1	 ;planet CX zahyou
kcy	= kz_Y1	 ;planet CY zahyou
kwidthcnt	= kz_z1
kplanettype	= kz_X2	 ;planet colour type
kplanetNo	= kz_Y2	 ;Planet no jyunban
kscrbase	= kz_x3
kscraddr	= kz_y3
kchrbase	= kz_textpt
kchrorder	= kz_tpx
;---------------------------------------------------------------------
trans_planetscr
	php
	a16
	longi

	phb
	db7e
	ldy	kx_planetlistptr
.loop
	lda.w	mmx_scrcx,y
	km_loba
	sta	kcx
	lda.w	mmx_scrcy,y
	km_loba
	sta	kcy
	lda.w	mmx_planetcol,y
	sta	kplanettype

;* character Base Pointer *
	km_loblda.w	mmx_charabaseptr,y
	sta	kplanetNo
;-------------------------------------------------------------------------
	jsr	trans_planetscr_sub
;-------------------------------------------------------------------------
	lda.w	mmx_planetnext,y
	tay
	bne	.loop

	plb
	plp
	rts
;=====================================================================
;*								*
;*		Planet Screen Data Transfer	[SubRoutine]	*
;*								*
;=====================================================================
trans_planetscr_sub
	longa
	longi
	phx
	phy
	php
	phb
	db0
;* Screen Base Address Calc *
	km_substaval	kcx,2
	km_substaval	kcy,2
	a8
	km_setval	vmainc,%10000000
	a16
	km_convVRAMSCRaddr_32	kcx,kcy,mm_bg2_scr
	sta	kscrbase

;* charcter Base No Calc *
	km_lldx	kplanetNo
	lda.l	mm_planetbaseNOTbl,x
	ora	kplanettype
	sta	kchrbase

;* Screen Data Set *
	km_setval	kwidthcnt,4
.loop1
	ldy	#4
	ldx	kchrbase
	km_setvar	kscraddr,kscrbase
.loop2
	sta	vmaddl
	stx	vmdatal

	km_addstaval	kscraddr,$20
	inx
	dey
	bne	.loop2

	dec	kwidthcnt
	beq	.end

	inc	kscrbase
	km_addstaval	kchrbase,mm_bitmaphight
	bra	.loop1
.end
	plb
	plp
	ply
	plx
	rts
	ENDC

;*********************************************************************
;*								*
;*		Initial Mario Draw RAM				*
;*********************************************************************
Init_MarioDrawRAM
	shorta
	longi
	phb
	db0

;--- MARIO RAM Clear ----
	a16
	km_setval.l	m_x1,(bitmapbase+bitmap1)&WM
	km_setval.l	m_x2,mm_wbuflength	;data size :16chr(yoko)*16chr(tate)
	a8
	call_mario	MRAMClear

	a16
	km_setval.l	m_x1,(bitmapbase+bitmap1_dbl)&WM
	km_setval.l	m_x2,mm_wbuflength	;data size :16chr(yoko)*16chr(tate)
	a8
	call_mario	MRAMClear
	plb
	rts
;*****************************************************************************
;*									*
;*			MISSION MAP BG H,V Scroll			*
;*									*
;*****************************************************************************
;=============================================================================
;*			Initial H-DMA params				*
;=============================================================================
init_hdmaparams
	shorta
	longi
;=========================== BG1,2 H,V scroll ==================================
; set up the bg1hscroll hdma channel	(message screen)
	lda	#%01000011	;2 address 2write
	sta	ch2params	;(indirect mode)
	lda	#bg1hofs&BM
	sta	ch2addrb
	ldx	#xhdma_bg1hvscroll_mismap&WM
	stx	ch2addra1tl
	lda	#xhdma_bg1hvscroll_mismap>>16
	sta	ch2atbank
	sta	ch2databank

; set up the bg2hscroll hdma channel	(planet screen)
	lda	#%01000011	;2 address 2write
	sta	ch3params	;(indirect mode)
	lda	#bg2hofs&BM
	sta	ch3addrb
	ldx	#xhdma_bg2hvscroll_mismap&WM
	stx	ch3addra1tl
	lda	#xhdma_bg2hvscroll_mismap>>16
	sta	ch3atbank
	sta	ch3databank

	km_orastaval	hdmaen_gc,%00001100
	RTS

;=============================================================================
;*			Initial H,V scroll params			*
;=============================================================================
init_mmhvscroll_l
	php
	phb

	a8
	db0
	a16
	lda	#0
	sta.l	kx_hscrollp1
	sta.l	kx_hscrollp2
	sta.l	kx_vscrollp1
	sta.l	kx_vscrollp2
	sta	player1hscroll
	sta	player2hscroll
	sta	player1vscroll
	sta	player2vscroll

	sta.l	xh_hscrolltbl1
	sta.l	xh_hscrolltbl2
	sta.l	xh_vscrolltbl1
	sta.l	xh_vscrolltbl2
	sta	kw_bg1hofs
	sta	kw_bg1vofs
	sta	kw_bg2hofs
	sta	kw_bg2vofs
	sta	kw_bg3hofs
	sta	kw_bg3vofs
	a8
	sta	bg1hofs
	sta	bg1hofs
	sta	bg1vofs
	sta	bg1vofs
	sta	bg2hofs
	sta	bg2hofs
	sta	bg2vofs
	sta	bg2vofs
	sta	bg3hofs
	sta	bg3hofs
	sta	bg3vofs
	sta	bg3vofs

	plb
	plp
	rtl
;*****************************************************************************
;*									*
;*									*
;*			DataTables			[ROM DATA]	*
;*									*
;*									*
;*****************************************************************************
;---------------------------------------------------------------------
;*		Battle Ship Skill Tanble			*
;---------------------------------------------------------------------
bsskillbasetbl
	db	bsskill_easy
	db	bsskill_normal
	db	bsskill_hard

;---------------------------------------------------------------------
;*								*
;*		Mario RAM Set Postion (X,Y)			*
;*								*
;* Mario RAM ni Set surutameno Planet Center Postion (CX,CY) Data	*
;* kono (CX,CY) kara Mario RAM no Address wo Calc suru		*
;---------------------------------------------------------------------
planetdata
	db	$10,$10
planetdataSZ
	km_datasize	planetdata

	db	$10,$30
	db	$10,$50
	db	$30,$10
	db	$30,$30
	db	$30,$50
	db	$50,$10

;=====================================================================
;*		Planet Base Character No Table			*
;=====================================================================
;* BG Screen Data no Top Character Number 
;* No 192~ Start ,Max 12ko no Planet ga kakeru
mm_planetbaseNOTbl
	dw	mm_planetbaseNO+(mm_bitmaphight*0)+0	;0
	dw	mm_planetbaseNO+(mm_bitmaphight*0)+4	;1
	dw	mm_planetbaseNO+(mm_bitmaphight*0)+8	;2
	dw	mm_planetbaseNO+(mm_bitmaphight*4)+0	;3
	dw	mm_planetbaseNO+(mm_bitmaphight*4)+4	;4
	dw	mm_planetbaseNO+(mm_bitmaphight*4)+8	;5
	dw	mm_planetbaseNO+(mm_bitmaphight*8)+0	;6
	dw	mm_planetbaseNO+(mm_bitmaphight*8)+4	;7
	dw	mm_planetbaseNO+(mm_bitmaphight*8)+8	;8
	dw	mm_planetbaseNO+(mm_bitmaphight*12)+0	;9
	dw	mm_planetbaseNO+(mm_bitmaphight*12)+4	;10
	dw	mm_planetbaseNO+(mm_bitmaphight*12)+8	;11

;---------------------------------------------------------------------
;*								*
;*								*
;*		Random Planet Pos & Stage Data Table		*
;*								*
;---------------------------------------------------------------------
;* Random Table Base Address *
randomtbl
;easy
	dw	6	;6 pattern
	dw	rndstg_easy-randomtbl
;normal
	dw	20	;20 pattern
	dw	rndstg_normal-randomtbl
;hard
	dw	20	;20 pattern
	dw	rndstg_hard-randomtbl
;---------------------------------------------------------------------
;*		Random Planet Postion Pointer Table	[EASY]	*
;---------------------------------------------------------------------
rndpos_easy
;---------------------------------------------------------------------
;*		Random Planet Stage Table		[EASY]	*
;* 6 pattern								*
;---------------------------------------------------------------------
rndstg_easy
	db	1,0	;0
	db	3,0	;1
	db	4,0	;2
	db	3,1	;3
	db	4,1	;4
	db	4,3	;5
;---------------------------------------------------------------------
;*		Random Planet Postion Pointer Table 	[NORMAL]*
;---------------------------------------------------------------------
rndpos_normal
;---------------------------------------------------------------------
;*		Random Planet Stage Table		[NORMAL]*
;* 20 pattern							*
;---------------------------------------------------------------------
rndstg_normal
	db	0,1,2	;0
	db	0,1,3	;1
	db	0,1,4	;2
	db	5,1,0	;3
	db	0,2,3	;4
	db	0,2,4	;5
	db	0,2,5	;6
	db	0,3,4	;7
	db	5,3,0	;8
	db	0,4,5	;9

	db	1,2,3	;10
	db	4,2,1	;11
	db	1,2,5	;12
	db	1,3,4	;13
	db	5,3,1	;14
	db	1,4,5	;15

	db	4,3,2	;16
	db	5,3,2	;17
	db	2,4,5	;18

	db	3,4,5	;19

;---------------------------------------------------------------------
;*		Random Planet Postion Pointer Table 	[HARD]	*
;---------------------------------------------------------------------
rndpos_hard
;---------------------------------------------------------------------
;*		Random Planet Stage Table		[HARD]	*
;* 20 pattern							*
;---------------------------------------------------------------------
rndstg_hard
	db	0,1,2,3,4,5	;0
	db	0,1,3,5,4,2	;1
	db	0,1,4,5,2,3	;2
	db	5,1,0,2,3,4	;3
	db	0,2,3,4,5,1	;4
	db	0,2,4,1,3,5	;5
	db	0,2,5,3,1,4	;6
	db	0,3,4,2,5,1	;7
	db	5,3,0,4,1,2	;8
	db	0,4,5,1,2,3	;9

	db	1,2,3,4,5,0	;10
	db	4,2,1,5,3,0	;11
	db	1,2,5,3,0,4	;12
	db	1,3,4,2,0,5	;13
	db	5,3,1,0,2,4	;14
	db	1,4,5,0,3,2	;15

	db	4,3,2,1,5,0	;16
	db	5,3,2,1,4,0	;17
	db	2,4,5,0,1,3	;18

	db	3,4,5,2,0,1	;19

;=====================================================================
;*		Planet Postion Tables 				*
;=====================================================================
planetpostbl
	db	venomCX,venomCY		;0	;venom
	db	venomDX,venomDY		;0	;venom
planetpostblSZ
	db	taitaniaCX,taitaniaCY	;1	;taitania
	db	taitaniaDX,taitaniaDY	;1	;taitania

	db	macbethCX,macbethCY	;2	;macbeth
	db	macbethDX,macbethDY	;2	;macbeth

	db	eladardCX,eladardCY	;3	;eladard
	db	eladardDX,eladardDY	;3	;eladard

	db	meteorCX,meteorCY	;4	;meteor
	db	meteorDX,meteorDY	;4	;meteor

	db	fortunaCX,fortunaCY	;5	;fortuna
	db	fortunaDX,fortunaDY	;5	;fortuna

	db	mshipx,mshipy		;6	;mother ship
	db	$08*8,$1b*8
	km_datasize	planetpostbl

;--------------------------------
;*  Arwing Angle Pattern Data   *
;--------------------------------
mm_sprarwing
;obj No
	db	$20,$e,$c,$a
	db	$8,$6,$4,$2
	db	$0,$2,$4,$6
	db	$8,$a,$c,$e

	db	$42,$40,$2e,$2c
	db	$2a,$28,$26,$24
	db	$22,$24,$26,$28
	db	$2a,$2c,$2e,$40

	db	$64,$62,$60,$4e
	db	$4c,$4a,$48,$46
	db	$44,$46,$48,$4a
	db	$4c,$4e,$60,$62
mm_sprarwingEND
	km_datalen	mm_sprarwing

;*****************************************************************************
;*			Debug Mode					*
;*****************************************************************************
mim_blink
	a8
	kbug2
	blink	3

;*****************************************************************************
;*****************************************************************************
;*			Not Using Area					*
;*****************************************************************************
;*****************************************************************************
	IFEQ	1
;* Planet Perfect Clear Count *
	ldy	kx_currentplanetptr
	lda.w	mmx_completecnt,y
	dec	a
	sta.w	mmx_completecnt,y
	bne	.set_neutral
.planet_perfectclear
	km_setflag16.w	mmx_planetflag,mmpnf_complete,y
	lda	#step_Clear
	sta.w	mmx_planetskill,y
	lda	kx_clearplanetkazu
	inc	a
	sta	kx_clearplanetkazu
	cmp	kx_missionplanetkazu
	bne	.notclear
	km_setmismapflag	missionallclear
.notclear	
	brl	.end
	ENDC

;------------------------------------------
;* Initial Battle Planet no kazu*
	a16
	ifeq	1
	ldx	kdifficulty
	km_loblda.l	PlanetKazuTbl,x
	sta	mmx_stepupsetcnt
	asl	a
	sta	kz_x1
;* table data wo set surutame no base pointer *
	ldx	#stup_easytmbase
	lda	kdifficulty
	beq	.skip	;easy
	ldx	#stup_normaltmbase
	dec	a
	beq	.skip	;normal
	ldx	#stup_hardtmbase
.skip
	txa
	clc
	adc	kz_x1
	sta	mmx_stepupsetptr
	endc

	ifeq	1
	ldx	kdifficulty
	dex
	beq	.random		;if normal
.fix	;(easy,hard)
	lda	#0
	bra	.set_pointer
.random	;(normal)
	lda	kw_RndPlanetPtr
	and	#7
.set_pointer
	sta	mmz_rndposptr	;Random Postion Pointer
	sta	mmz_rndstgptr	;Random Stage Pointer
	endc
	ifeq	1
	ldx  	mmz_difficultyptr
	lda.l	randomtbl+2,x
	sta	mmz_tmpwork		;stage tabel base pointer
	lda	kx_planetkazu
	ldx	mmz_rndstgptr
	a8
	km_cpumultu8u8	x
	a16
	clc
	adc	mmz_tmpwork
	sta	mmz_rndstgptr
	endc
;---------------------------------------
;;* initial states *
;	lda	#0
;	sta.w	mmx_stagecnt,y
;---------------------------------------
;* Planet Character Base No (For Planet Screen Data Pointer)*
;('95/2/3) :comment
;	ldx	mmw_bitmapptr
;	txa
;	sta.w	mmx_charabaseptr,y
;---------------------------------------
;* Planet Bitmap Base (X,Y) *
;('95/2/3) :comment
;	a16
;	lda.l	planetdata,x
;	km_loba
;	sta.w	mmx_bitmapcx,y
;	lda.l	planetdata+1,x
;	km_loba
;	sta.w	mmx_bitmapcy,y
;	a8
;---------------------------------------
;('95/2/3) :comment
;	cmp	#planet_stage5		;(gamelist.inc)
;	bne	.NotMeteor
;	sty	kx_MeteorPtr		;Meteor List Pointer Set
;.NotMeteor
;('95/2/3) :comment
;	a16
;	lda	kx_RndPlanetR		;Planet Center R
;	sta.w	mmx_planetR,y
;	lda	kx_RndPlanetSpr		;Maping Sprite
;	sta.w	mmx_planetsprite,y
;	lda	kx_RndPlanetCol		;Colour No
;	sta.w	mmx_planetcol,y
;-------------------------------------------------------------------------
;.end
;	a8
;	inx
;	inx
;	stx	mmw_bitmapptr	Next Bitmap Pointer (0,2,4,6,...)
;	rts

;---------------------------------------------------------------------
;*								*
;*			SOS Enemy Clear				*
;* Yrg = Enemy List Pointer						*
;---------------------------------------------------------------------
	IFEQ	1
clearsosenemy
	longa
	longi
;* kono test wa debug mode notame *
	lda	kx_enemytotal
	km_beq	mim_blink
;* Free SOS Alien *
	jsl	mm_freeenemylistptr_l	;(enemy flag mo clear)

;* Planet/SOS Flag Clear *
	km_clrmismapflag	enemylist
;;;	km_clrmismapstflag	complete
	rts
	ENDC

;---------------------------------------------------------------------
;*								*
;*			Player Mission Failed			*
;*								*
;---------------------------------------------------------------------
	IFEQ	1
playerfailed
	longa
	longi
	km_setval	kz_x1,$10
	km_setval	kz_y1,$10
	a8
	lda	mmx_arwingposx+1
	bpl	.less80H_X
	pha
	km_negstavar	kz_x1
	pla
.less80H_X
	clc
	adc	kz_x1
	sta	mmx_arwingposx+1
	sta	mmx_partnerposx+1

	lda	mmx_arwingposy+1
	bpl	.less80H_Y
	pha
	km_negstavar	kz_y1
	pla
.less80H_Y
	clc
	adc	kz_y1
	sta	mmx_arwingposy+1
	sta	mmx_partnerposy+1
	rts

	ENDC
;-------------------------------------------------
	ifeq	1
.enemy_gone
	a8
	lda.w	mmx_enposx+1,y
	bpl	.less80H_enX
	pha
	km_negstavar	kz_x1
	pla
.less80H_enX
	clc
	adc	kz_x1
	sta.w	mmx_enposx+1,y

	lda.w	mmx_enposy+1,y
	cmp	#$50
	bcc	.nochangeY
	sec
	sbc	kz_y1
	
sta.w	mmx_enposy+1,y
.nochangeY
	a16
	jsl	calc_enangvelxy_l
	a8
	endc

	ifeq	1
;* Stack Number Clear *
	phy
	lda.w	mmx_plstackptr,x
	tay
	lda	#0
	sta.w	kx_stackbuffer,y
	sta.w	eenemyNumber_0,y
	ply

;* Step Up Initial *
	km_setstepupmode	nothing,x	;inittime,x
	LONGA
	km_setflag16.w	mmx_planetflag,mmpnf_complete,x

	km_setval.w	mmx_dokuroanm,0,x	;dokuro animation off

;* moshi battle shiteita planet no sos ga born wait jyoutai dattara !! *
	lda.w	mmx_psos,x
	beq	.skip1
	cmp	#sos_born
	bpl	.skip1
	km_clrflag16.w	mmx_planetflag,mmpnf_sosappear,x
	km_setsosmode	inittime,x
.skip1
	A8
	lda	#step_Neutral
	sta.w	mmx_planetskill,x	;neutral
	dec	kx_clrenemytotal	;Enemy Clear Toal Dec
	bne	.skip2

	km_setmismapstflag	finalbosstrig	;(For Yajima)
	km_setval	kx_FinalBossSeq,fbseq_sosdesttrig
	km_setflag16	kw_MisMapFreezeFlag,(kfz_timefreeze!kfz_cursorfreeze!kfz_bossfreeze)
	brl	.end
.skip2
	ENDC

	ifeq	1
;* stepup or sos check *
	km_bitcheckflag.w	mmx_enflags,enfl_stepup,y
	beq	.sos
;----------------------------------------------------------------------
;*** Mission ga Step UP no baai !! ***
.stepup
;* Xreg = DESTINATION planet pointer
	longa
	lda.w	mmx_endestplanetptr,y
	tax
	km_setstepupmode	inittime,x
	dec	kx_clrenemytotal	;Enemy Clear Toal Dec
	bne	.skip5
	km_setmismapstflag	finalbosstrig	;(For Yajima)
	km_setval	kx_FinalBossSeq,fbseq_sosdesttrig
	km_setflag16	kw_MisMapFreezeFlag,(kfz_timefreeze!kfz_cursorfreeze!kfz_bossfreeze)
.skip5
	bra	.skip
	endc

;=====================================================================
;*			Set Replay Params			*
;=====================================================================
return_replayparams
	ifeq	1
	php
	a16
	longi
;********* Current Buffer Keep ************
;* Total Time & Total Enemy number *
	km_blocktrans	kx_replaytmplist,kx_replaycurlist,replaylistlen

;* Planet Buffer Keep *
	LONGA
	ldx	kx_planetlistptr
.loop_planet
	ldy	#planetreplaysize/2
	phx
.loop_states
;* Planet List*
	lda.w	mmx_planetflag,x
	sta.w	mmx_Curplanetflag,x
	inx
	inx
	dey
	bne	.loop_states

	plx
	lda.w	mmx_planetnext,x
	beq	.finish_planet
	tax
	bra	.loop_planet
.finish_planet
;* Enemy List *
	LONGA
	km_stxvar	kx_CURenlistptr,kx_enlistptr
	km_stxvar	kx_CURenfreeptr,kx_enfreeptr
	km_blocktrans	kx_enemylist,kx_CURenemylist,mmx_enemylen*_enemynum
;----------------------------------------------------------------------------
;* Replay Initial *
	km_blocktrans	kx_replaybaklist,kx_replaytmplist,replaylistlen

;* Replay Return *
	LONGA
	ldx	kx_planetlistptr
.loop_planet2
	ldy	#planetreplaysize/2
	phx
.loop_states2
	lda.w	mmx_Repplanetflag,x
	sta.w	mmx_planetflag,x
	inx
	inx
	dey
	bne	.loop_states2

	plx
	lda.w	mmx_planetnext,x
	beq	.finish_planet2
	tax
	bra	.loop_planet2
.finish_planet2
;* Enmey List Replay *
	LONGA
	km_stxvar	kx_enlistptr,kx_REPenlistptr
	km_stxvar	kx_enfreeptr,kx_REPenfreeptr
	km_blocktrans	kx_repenemylist,kx_enemylist,mmx_enemylen*_enemynum
	plp
	endc
	rts

;=====================================================================
;*
;=====================================================================
return_currentparams
	LONGA
	LONGI
	ifeq	1
;* Return Currnet Params *
	km_blocktrans	kx_replaycurlist,kx_replaytmplist,replaylistlen

;* Planet *
	ldx	kx_planetlistptr
.loop_planet
	ldy	#planetreplaysize/2
.loop_states
	lda.w	mmx_Curplanetflag,x
	sta.w	mmx_planetflag,x
	inx
	inx
	dey
	bne	.loop_states

	lda.w	mmx_planetnext,x
	beq	.finish_planet
	tax
	bra	.loop_planet
.finish_planet

;* Return Current Enemy List *
	km_stxvar	kx_enlistptr,kx_CURenlistptr
	km_stxvar	kx_enfreeptr,kx_CURenfreeptr
	km_blocktrans	kx_CURenemylist,kx_enemylist,mmx_enemylen*_enemynum
	endc
	RTS





;1995/1/31 :(comment)
	IFEQ	1
;--- Draw List size ---
	km_setval.l	m_planetlen,m_planetdrawlen	;planetdrawsize
;* shadow list *

;* planet List *
	ldx	#0
	ldy	kx_planetlistptr
	stz	mmx_DrawPlanetCnt
.LOOP
	cpy	kx_MeteorPtr
	beq	.Skip
	lda.w	mmx_bitmapcx,y
	sta.l	mmm_planetcx,x
	lda.w	mmx_bitmapcy,y
	sta.l	mmm_planetcy,x
	lda.w	mmx_planetR,y
	sta.l	mmm_planetR,x
	lda.w	mmx_planetsprite,y
	sta.l	mmm_planetsprite,x

	inc	mmx_DrawPlanetCnt		;planet no kazu
	txa
	clc
	adc	#m_planetdrawlen	;planetdrawsize
	tax
.Skip
	lda.w	mmx_planetnext,y
	tay				;NEXT Planet List Pointer
	bne	.LOOP
;--- planet no kazu ---
	lda	mmx_DrawPlanetCnt
	sta.l	m_planetcnt
;--- planet angle y ----
	km_addstaval	mmw_planetroty,$100
	sta.l	m_planetroty
	ENDC


	IFEQ	1
;---------------------------------------------------------
;******* Debug mode *******
;* force soft ware reset *
	km_Debug_reset
;* prev check *
	km_acmpjoypad	prev
	bne	.noprev
	km_settmpgamemode	selectmissionplayer	;[GAME MODE]
	ksound	cancel
	bra	.bgmfade
.noprev
	ENDC
;---------------------------------------------------------------------
;*			Now Not Using				*
;---------------------------------------------------------------------
;-------------------------------------------------------------
;*		Planet Making (CGX kakikae Ver)		*
;-------------------------------------------------------------
	IFEQ	1
	lda.l	KCGSCTransTimer
	beq	.changeADDR
	dec	a
	sta.l	KCGSCTransTimer
	bra	.skip
.changeADDR
	lda	#20
	sta.l	KCGSCTransTimer

	a16
	lda.l	KCGXSCRTransCPUAddr
	clc
	adc	#$800
	cmp	#$2000
	bne	.setadr
	lda	#0
.setadr
	sta.l	KCGXSCRTransCPUAddr
.skip
	a8
	ENDC


;*******************************
;* Collision (Size) List Copy *
;*******************************
	IFEQ	1
	a16
	lda	#$400
	jsl	alloc_l
	sta	kx_BGcolltbladdr
	ENDC
;*******************************
;* Sprite Sub (Size) List Copy *
;*******************************
	IFEQ	1
	a16
	lda	#mm_SpriteSizeLen
	jsl	alloc_l
	sta	mmx_sprsizeaddr

;* sprite size list copy *
	tay
	ldx	#0
	a8
.nxt_size
	lda.l	SpriteSizeFlag,x
	sta.w	heap,y
	inx
	iny
	cpx	#mm_SpriteSizeLen
	bne	.nxt_size
	ENDC
;******************************
;* OAM Data (Station) Copy *
;******************************
	IFEQ	1
	a16
	lda	#mm_sprstationlen
	jsl	alloc_l
	sta	mmx_sprstationaddr

;* sprite (station) copy *
	tay
	ldx	#0
	a8
.nxt_station
	lda.l	mm_sprstation,x
	sta.w	heap,y
	inx
	iny
	cpx	#mm_sprstationlen
	bne	.nxt_station
	ENDC
;*********************************************
;* Enemy Chart Data Copy 	*
;*********************************************
	IFEQ	1
	a16
	lda	#mm_enemychartlen
	jsl	alloc_l
	sta	mmx_enemychartddr

;* enemy chart data copy *
	tay
	ldx	#0
	a8
.nxt_chart
	lda.l	mm_enemychart,x
	sta.w	heap,y
	inx
	iny
	cpx	#mm_enemychartlen
	bne	.nxt_chart
	ENDC

;*********************************************
;* OAM Data (Gesso ANM pattern) Copy 	*
;*********************************************
	IFEQ	1
	a16
	lda	#mm_sprgessolen
	jsl	alloc_l
	sta	mmx_sprgessoaddr

;* sprite (gesso) copy *
	tay
	ldx	#0
	a8
.nxt_gesso
	lda.l	mm_sprgesso,x
	sta.w	heap,y
	inx
	iny
	cpx	#mm_sprgessolen
	bne	.nxt_gesso

	ENDC

;******************************
;* Sprite Data (ball) Copy    *
;******************************
	ifeq	1
	a16
	lda	#(mmx_balllen*3)
	jsl	alloc_l
	sta	mmx_sprballaddr
	a8
	endc
;*************************
;* Collision List Copy   *
;*************************
	IFEQ	1
	a16
	lda	#mm_col_listlen
	jsl	alloc_l
	sta	mmx_collisaddr
;* collision list copy *
	tay

	ldx	#0	
	a8
.nxt_col
	lda.l	mm_col_list,x
	sta.w	heap,y
	inx
	iny
	cpx	#mm_col_listlen
	bne	.nxt_col
	ENDC
;=====================================================================
;*			Keep Replay Params			*
;=====================================================================
	ifeq	1
keep_replayparams
	shorta
	longi
	phb
	db7e
;* Save Params *
	km_blocktrans	kx_replaytmplist,kx_replaybaklist,replaylistlen

;* Planet *
	a16
	ldx	kx_planetlistptr
.loop_planet
	ldy	#planetreplaysize/2
.loop_states
	lda.w	mmx_planetflag,x
	sta.w	mmx_Repplanetflag,x
	inx
	inx
	dey
	bne	.loop_states

	lda.w	mmx_planetnext,x
	beq	.finish_planet
	tax
	bra	.loop_planet
.finish_planet

;* Enemy List *
	km_setvar	kx_repenlistptr,kx_enlistptr
	km_setvar	kx_repenfreeptr,kx_enfreeptr
	km_blocktrans	kx_enemylist,kx_repenemylist,mmx_enemylen*_enemynum

	a8
	plb
	rts

	endc

	IFEQ	1
;---------------------------------------------------------------------
;*		Missile Issei Hassya				*
;---------------------------------------------------------------------
mmchart_Capture3_1
mmchart_Capture3_2
mmchart_Capture3_3
mmchart_Capture3_4
	longa
	km_setmismaptrflag	missileall
	brl	mmchart_Capture5_1

	IFEQ	1
mmchart_Capture3_2
	longa
	lda	kx_planetkazu
	km_beq	mmchart_capture5_1	;mm_noplanet
	lda	kx_missilecurrent
	beq	.missle_allhassya

.missle_allhassya
	longa
	km_clrmismapfzflag	misbornfreeze
	jsr	ms_GoAll
	km_beq	mmchart_capture5_1	;mm_noplanet

	km_setmismapchflag	demowait
	km_setval	kx_expdemowait,10*8
	km_setval	kx_MisMapNextSeq,mmseq_capture3_3

	km_bitcheckmistotalflag		bshojyuu
	bne	.2times
.1times
	km_setflag16	mmx_trigmessage,ymes_missileallfire1
	bra	.skip
.2times
	km_setflag16	mmx_trigmessage,ymes_missileallfire2
.skip
	brl	mmchart_messagetrig

mmchart_Capture3_3
	longa
	km_setmismapdemoflag	missilealldemo
	km_clrflag16.w	kw_MisMapFreezeFlag,kfz_misbornfreeze
	km_setval	kx_MisMapSeq,mmseq_capture3_4
	rts
mmchart_Capture3_4
	longa
	lda	kx_missileappcnt
	beq	.finish
	rts
.finish
	km_clrmismapdemoflag	missilealldemo
	brl	mmchart_Capture5_1
	ENDC
;---------------------------------------------------------------------

;---------------------------------------------------------------------
;*		Senkan Hojyuu & Zaco Enemy Hassya 1st		*
;---------------------------------------------------------------------
mmchart_Capture1_1
	longa
	lda	kx_zacocurrent
	ora	kx_missilecurrent
	ora	kx_battleshipcurrent
	beq	.trigger_on	;zaco ga inaku rarumade count !!
	rts
.trigger_on
	km_setmismapchflag	demowait	;demo start trigger
	km_setflag16	mmx_trigmessage,ymes_battleshipadd
	km_setval	kx_expdemowait,7*8
	km_setval	kx_MisMapNextSeq,mmseq_capture1_2
	brl	mmchart_messagetrig
;---------------------------------------------------------------------
mmchart_Capture1_2
	longa

	km_setvar	kw_MisMapfreezeFlagBak,kw_MisMapFreezeFlag
	km_setmismapfzflag	gamefreeze	;allfreeze

	jsr	SetBattleShip	;sankan hojyuu !!
	km_setmistotalflag	bshojyuu	;hojyuu shita
	km_clrmistotalflag	bstotugeki	;totugeki flag clear

	jsr	mm_planethojyuuchart

	km_clrmismapfzflag	btshipfreeze
	km_clrmismapfzflag	sosfreeze
	km_clrmismapstflag	expdemostart
	km_setmismapdemoflag	battleshiphojyuudemo
	km_setval	kx_MisMapSeq,mmseq_capture1_3
;---------------------------------------------------------------------
mmchart_Capture1_3
	longa
	lda	kx_battleshipcurrent
	beq	.waiting
	km_bitcheckmismapstflag	expdemostart
	beq	.waiting

	km_clrmismapdemoflag	battleshiphojyuudemo
	km_clrmismapstflag	expdemostart	;[moshi subeteno zaco ga syutugeki shitara no flag!!]
	km_clrmismapchflag	demowait
	km_setval	kx_MisMapSeq,mmseq_Capture2_1

	km_setvar	kw_MisMapFreezeFlag,kw_MisMapfreezeFlagBak
.waiting
	rts
;---------------------------------------------------------------------
;*		Zaco Enemy Hassya 2nd				*
;---------------------------------------------------------------------
mmchart_Capture2_1
	longa
	km_setmismapfzflag	misbornfreeze
	km_setval	kx_clearcondition,2
	km_setval	kx_MisMapSeq,mmseq_clearwait
	km_setval	kx_MisMapNextSeq,mmseq_capture3_1
	brl	mmchart_cleartrig
;---------------------------------------------------------------------
mmchart_Capture2_2

;---------------------------------------------------------------------
;*		Missile Issei Hassya				*
;---------------------------------------------------------------------
mmchart_Capture3_1
mmchart_Capture3_2
mmchart_Capture3_3
mmchart_Capture3_4
	longa
	km_setmismaptrflag	missileall
	brl	mmchart_Capture5_1

	IFEQ	1
mmchart_Capture3_2
	longa
	lda	kx_planetkazu
	km_beq	mmchart_capture5_1	;mm_noplanet
	lda	kx_missilecurrent
	beq	.missle_allhassya

.missle_allhassya
	longa
	km_clrmismapfzflag	misbornfreeze
	jsr	ms_GoAll
	km_beq	mmchart_capture5_1	;mm_noplanet

	km_setmismapchflag	demowait
	km_setval	kx_expdemowait,10*8
	km_setval	kx_MisMapNextSeq,mmseq_capture3_3

	km_bitcheckmistotalflag		bshojyuu
	bne	.2times
.1times
	km_setflag16	mmx_trigmessage,ymes_missileallfire1
	bra	.skip
.2times
	km_setflag16	mmx_trigmessage,ymes_missileallfire2
.skip
	brl	mmchart_messagetrig

mmchart_Capture3_3
	longa
	km_setmismapdemoflag	missilealldemo
	km_clrflag16.w	kw_MisMapFreezeFlag,kfz_misbornfreeze
	km_setval	kx_MisMapSeq,mmseq_capture3_4
	rts
mmchart_Capture3_4
	longa
	lda	kx_missileappcnt
	beq	.finish
	rts
.finish
	km_clrmismapdemoflag	missilealldemo
	brl	mmchart_Capture5_1
	ENDC
;---------------------------------------------------------------------
;*
;---------------------------------------------------------------------
mmchart_Capture4_1
mmchart_Capture4_2

;---------------------------------------------------------------------
;*			Dragon Go !!				*
;---------------------------------------------------------------------
mmchart_Capture5_1
	longa
	km_clrmismapchflag	demowait
	km_setval	kx_clearcondition,2
	km_setval	kx_MisMapSeq,mmseq_clearwait
	km_setval	kx_MisMapNextSeq,mmseq_capture5_3
	brl	mmchart_cleartrig

mmchart_Capture5_2
	longa

mmchart_Capture5_3
	longa
	km_setmismapchflag	demowait
	km_setval	kx_expdemowait,10*8
	km_setval	kx_MisMapNextSeq,mmseq_capture5_4

	km_bitcheckmistotalflag		bshojyuu
	bne	.2times
.1times
	km_setflag16	mmx_trigmessage,ymes_dragongo1
	bra	.skip
.2times
	km_setflag16	mmx_trigmessage,ymes_dragongo2
.skip
	brl	mmchart_messagetrig

mmchart_Capture5_4
	longa
	km_setmismapsyori	specialenemy
	km_setval	kx_MisMapSeq,mmseq_capture5_5
	rts

mmchart_Capture5_5
	longa
	km_setmismapchflag	demowait
	km_setmismapdemoflag	specialenemydemo
	jsr	SetSpecialEnemy
	km_setval	kx_MisMapSeq,mmseq_capture5_6
	rts

mmchart_Capture5_6
	longa
	lda	mmx_specialapcocnt
	bne	.skip
	km_clrmismapchflag	demowait
	km_clrmismapdemoflag	specialenemydemo
	km_setval	kx_MisMapSeq,mmseq_capture6_1

.skip
	rts

;---------------------------------------------------------------------
;*			Loop Chart				*
;---------------------------------------------------------------------
mmchart_Capture6_1
	longa
	lda	kx_battleshipcurrent
	beq	.check_hojyuu
	rts
.check_hojyuu
	lda	kx_battleshipzaico
	bne	.next_chart
.finish_chart
	km_setval	kx_MisMapSeq,mmseq_nothing
	rts
.next_chart
	brl	mmchart_capture1_1

	ENDC

