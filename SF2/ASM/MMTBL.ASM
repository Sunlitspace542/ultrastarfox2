;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         MMTBL.ASM                                           ;
; AUTHOR:       YASUHIRO KAWAGUCHI                                  ;
; DESCRIPTION:  Mario Chip tono Parallel Program                    ;
; DATE CREATED: 09-9-94                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
	INCPUB	mmtbl

km_setenseq	macro	[label]
	lda	#enseq_{label}
	sta.w	mmx_ensequence,y
	endm
;*********************************************************************
;*								*
;*		Mario Progame Paralell Start			*
;*								*
;*********************************************************************
mm_startmario_l
	shorta
	longi
;---------------------------------------------
* 	Mario Program Start		*
;---------------------------------------------
.callmario
	nastyon		;ROM & RAM Nasty ON
	lda	#MMakePlanet>>16
	sta.l	m_pbr
 	a16
	lda	#MMakePlanet&WM
	sta.l	mr15	; GO!
	km_clrmismapstflag	noirqsyori	;[1 frame syori Enable]
	a8
;---------------------------------------------
;*	WAIT Mario Draw	(IRQ Wait)	*
;---------------------------------------------
;* Mario Wait *
	km_waitmario
	nastyoff	;ROM & RAM Nasty OFF
	rtl

;*********************************************************************
;*								*
;*		Game Frame Routine Start  [Running On RAM]	*
;*					{1GameFrame = 8Frame}	*
;*********************************************************************
mm_GameFrameRAMRoutine_l
	php
;	km_bitcheckmismapstflag	gmframesyori
;	beq	.end

	ai16
	ldx	kw_gameframeptr
	jsr	(.syoritbl,x)
.end
	plp
	rtl
;---------------------------------------------------------------------
;*		Syori Table					*
;---------------------------------------------------------------------
.syoritbl
	dw	mm_frame0&WM	;0
	dw	mm_frame0&WM	;1
	dw	mm_frame0&WM	;2
	dw	mm_frame0&WM	;3
	dw	mm_frame0&WM	;4
	dw	mm_frame0&WM	;5
	dw	mm_frame0&WM	;6
	dw	mm_frame0&WM	;7
;=====================================================================
;*		Game Frame Syori				*
;=====================================================================
mm_frame0
	longa
	longi
	jsr	mm_EveryFrameRAMRoutine

	rts

;*********************************************************************
;*								*
;*		Every Frame Routine Start  [Running On RAM]	*
;*								*
;*********************************************************************
	longa
	longi
mm_EveryFrameRAMRoutine
	km_bitcheckmismapfzflag	enemyfreeze	;kono check wa player check to tomoni hituyou !!
	bne	.stratage_skip
	jsr	mm_PlanetSequence
	jsr	mm_BattleShipSequence
	jsr	mm_VirusSequence
	jsl	mm_SatelliteSequence_l
	jsr	mm_EnemySequence
	jsr	mm_sosenemycollision
	jsr	mm_sosenemymove
.stratage_skip
	rts

;*********************************************************************
;*								*
;*		Paralell Routine Start  [Running On RAM]	*
;* Using By Normal Mission 						*
;*********************************************************************
	shorta
	longi
Parallel_mismap_l
	storenasty
	nastyon		;ROM & RAM Nasty ON
	ai16
	km_bitcheckflag	kw_Gameflag,(kgf_keydisable!kgf_test!kgf_freeze)
	bne	.end
	km_bitcheckflag	kw_missionflag,kmif_parallel
	beq	.end
	km_bitcheckflag	kw_missionflag,kmif_enemymove
	beq	.end
	km_bitcheckmistotalflag	finalbossbattle
	bne	.end
;-----------------------------------------------------
	a8
	phb
	db7e
	jsl	mm_GameFrameRAMRoutine_l
	plb
;-----------------------------------------------------
.end
	a8
	restorenasty
	rtl

;*********************************************************************
;*								*
;*			Satellite Chart 			*
;* Data Bank :7e							*
;* ai16								*
;* Yreg :Satellite List Pointer (Enemy List)				*
;*********************************************************************
	longa
	longi
mm_SatelliteSequence_l
	km_bitcheckmismapfzflag	timefreeze
	bne	.End

	ldy	kx_satelliteenptr
	lda	kx_satelliteSeq
	asl	a
	tax
	jsr	(.SatelliteSeq,x)
.end
	rtl
.SatelliteSeq
	dw	sa_chargecannon&WM
	dw	sa_anglecheck&WM
	dw	sa_explodeenemy&WM
	dw	sa_resettame&WM
;-----------------------------------------------------------------
	longa
	longi
sa_chargecannon
;* houdai angle *
	jsr	rotate_angle
;* charge check *
	lda.w	mmx_enwaittm,y
	dec	a
	sta.w	mmx_enwaittm,y
	bne	.notcharge	;(?? sec tattra charge OK !!)

	km_setflag16.w	mmx_enflags2,enfl2_fireenable,y	;
	km_setflag16	kx_satelliteflag,safl_tamedama	;display tamedama
	km_clrflag16	kx_satelliteflag,safl_charge
	km_setval.w	mmx_enwaittm,sa_lockontm,y
	km_setflag16	kw_mmsoundflag,mmsndf_tamedama
	inc	kx_satelliteSeq
.notcharge
	rts

;-----------------------------------------------------------------
	longa
	longi
sa_anglecheck	;(lock on check)
	km_bitcheckflag	kx_satelliteflag,(safl_lockon)
	beq	.checkangle

;* moshi map kara mission ni hairu syunkan ni lock on shite shimattara *
	lda	kx_satellitetype
	bne	.skip1	;(enemy side)

;(mikata side no toki lock on flag ga tatteitara)
	km_bitcheckmistotalflag	mission
	bne	.mission_tyuu	;(mission syuu)
.skip1
	rts

.mission_tyuu
	ldx	kx_salockonptr
	km_clrflag	kx_satelliteflag,safl_lockon	;(flag clear)
	bra	.message_mission

.checkangle
;* houdai angle *
	jsr	rotate_angle
;* Lock on Check *
	lda.w	mmx_enwaittm,y
	dec	a
	sta.w	mmx_enwaittm,y
	beq	.check_object
	rts
.check_object
	km_setval.w	mmx_enwaittm,sa_lockontm,y

	km_bitcheckflag16.w	mmx_enflags2,enfl2_tyuuritu,y

	lda	kx_satellitetype
	beq	.friend
;---------------------------------------------
;*		Attack Corneria		*
;---------------------------------------------
.enemy
	ldx	kx_CorneriaPtr
	lda.w	mmx_planetcx,x
	sta	kz_x2
	lda.w	mmx_planetcy,x
	sta	kz_y2
	jsr	kcheck_lockon_corneria
	bcs	.lockon_corneria
	rts
.lockon_corneria
	km_setflag	kx_satelliteflag,safl_lockon
	rts

	IFEQ	1
	km_bitcheckmistotalflag	mission
	beq	.map_lockon_corneria
	rts
.map_lockon_corneria
	inc	kx_SatelliteBeemChart	;[for map]
	inc	kx_satelliteSeq		;[next]
	bra	sa_explodeenemy
	ENDC
;---------------------------------------------
;*		Attack Enemy		*
;---------------------------------------------
	longa
	longi
.friend
	ldx	kx_enlistptr
	beq	.end
.LOOP
	km_bitcheckflag16.w	mmx_enflags,enfl_lockonskip,x ;(enfl_lockonskip = kalcs.inc)
	beq	.check
.next
	lda.w	mmx_ennext,x
	tax
	bne	.LOOP
.end	rts

.check
	km_loblda.w	mmx_enposx+1,x
	sta	kz_x2
	km_loblda.w	mmx_enposy+1,x
	sta	kz_y2

	jsr	kcheck_lockon
	bcc	.next
	stx	kx_salockonptr

	km_bitcheckmistotalflag	mission
	bne	.message_mission
.message_map
	km_setflag16.w	mmx_enflags,enfl_nocollision,x	;enemy collision OFF
	km_setflag	kx_satelliteflag,safl_lockon
	rts

;	inc	kx_SatelliteBeemChart	;[for map]
;	inc	kx_satelliteSeq		;[next]
;	bra	sa_explodeenemy

.message_mission
	txy
	km_setflag16	mmx_message_sos,mesosfl_zacotubushi	;[for yajima's]
	jsl	mm_freeenemylistptr_l
	bra	sa_resettame
;-----------------------------------------------------------------
sa_explodeenemy
	lda	kx_SatelliteBeemChart
	beq	sa_resettame
	rts
;-----------------------------------------------------------------
sa_resettame
	ldy	kx_satelliteenptr
	km_clrflag16.w	mmx_enflags2,enfl2_fireenable,y	;reset tame
	km_clrflag16	kx_satelliteflag,safl_tamedama
	km_setflag16	kx_satelliteflag,safl_charge

;* reset time *
	ldx	kdifficulty2
	lda.l	.tametimetbl,x
	sta.w	mmx_enwaittm,y
	stz	kx_satelliteSeq
	rts

.tametimetbl
	dw	sa_tametimeE
	dw	sa_tametimeN
	dw	sa_tametimeH
;-----------------------------------------------------------------
	longa
	longi
rotate_angle

;* rotate houdai *
	lda.w	mmx_enmvwaittm,y
	dec	a
	sta.w	mmx_enmvwaittm,y
	beq	.change_angle
	rts
.change_angle
	km_setval.w	mmx_enmvwaittm,sa_angletm,y
	km_addstaval.w	mmx_enangY,$1000,y

	xba
	clc
	adc	#8
	and	#$f0
	km_divu4
	sta	kx_houdaiangle
	rts

;-------------------------------------------------------------
;*		Lock On Check				*
;* Yreg :Satellite List Pointer				*
;-------------------------------------------------------------
	longa
	longi
kcheck_lockon
	ldy	kx_satelliteenptr
	km_loblda.w	mmx_enangY+1,y
	sta	kz_tpy

	km_loblda.w	mmx_enposx+1,y
	sta	kz_x1
	km_loblda.w	mmx_enposy+1,y
	sta	kz_y1
	jsl	calobjangle_l

	a8
	xba
	sec
	sbc	kz_tpy
	cmp	#sa_lockonang
	bcc	.lock_on	;ANGY < sa_lockonang
	beq	.lock_on	;ANGY = sa_lockonang
	cmp	#-sa_lockonang
	bcc	.no_lockon	;ANGY > abs[-sa_lockonang]
.lock_on
	a16
	sec
	rts
.no_lockon
	a16
	clc
	rts

;-------------------------------------------------------------
;*		Lock On Corneria Check			*
;* Yreg :Satellite List Pointer				*
;-------------------------------------------------------------
	longa
	longi
kcheck_lockon_corneria
	ldy	kx_satelliteenptr
	km_loblda.w	mmx_enangY+1,y
	sta	kz_tpy

	km_loblda.w	mmx_enposx+1,y
	sta	kz_x1
	km_loblda.w	mmx_enposy+1,y
	sta	kz_y1
	jsl	calobjangle_l

	a8
	xba
	sec
	sbc	kz_tpy
	cmp	#sa_lockonang_co
	bcc	.lock_on	;ANGY < sa_lockonang_co
	beq	.lock_on	;ANGY = sa_lockonang_co
	cmp	#-sa_lockonang_co
	bcc	.no_lockon	;ANGY > abs[-sa_lockonang_co]
.lock_on
	a16
	sec
	rts
.no_lockon
	a16
	clc
	rts


;*********************************************************************
;*								*
;*		Born Virus Chart [From Hankyuu Toshi]		*
;* Data Bank :7e							*
;* ai16								*
;*********************************************************************
	longa
	longi
mm_VirusSequence
	km_bitcheckmismapfzflag	timefreeze
	bne	.end
	km_bitcheckmismapevflag	virusbornfreeze
	bne	.end

	ldy	kx_FinalBossPlPtr
	km_loblda.w	mmx_psos,y
	asl	a
	tax
	jsr	(.virustbl,x)
.end
	rts
.virustbl
	dw	virseq_appearcheck&WM
	dw	virseq_appearwait&WM
	dw	virseq_appear&WM
	dw	virseq_move&WM
;-------------------------------------------------
	longa
	longi
virseq_appearcheck
	tyx

	lda	kx_satellitetype
	beq	.appear_virus
	rts
.appear_virus
	lda	kdifficulty
	dec	a
	bne	.hard
.normal
	lda	#vir_appeartmN
	bra	.set_time
.hard
	lda	#vir_appeartmH
.set_time
	sta.w	mmx_soswaittm,x
	inc.w	mmx_psos,x
.skip
	rts
;-------------------------------------------------
	longa
	longi
virseq_appearwait
	tyx
	jsr	soswait
	rts
;-------------------------------------------------
	longa
	longi
virseq_appear
	tyx
	km_cmpcheck	kx_enemytotal,mm_enemymax	;(kalcs.inc)
	bpl	.end
	jsr	mm_initsoslist
	inc.w	mmx_psos,x
.end
	rts
;-------------------------------------------------
	longa
	longi
virseq_move
	tyx
	rts
;-------------------------------------------------

;*********************************************************************
;*								*
;*		Born Missile Chart [From Planet]		*
;* Data Bank :7e							*
;* ai16								*
;*********************************************************************
mm_PlanetSequence_l
	jsr	mm_PlanetSequence
	rtl

	longa
	longi
mm_PlanetSequence
;'95/7/3 :comment :missile hyouji ga totyuu de kierutame
;;	km_bitcheckmismapevflag	misbornfreeze
;;	bne	.end

	ldx	kx_planetlistptr
	beq	.end
.loop
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,x
	beq	.nextplanet
	km_bitcheckflag16.w	mmx_planetflag,(mmpnf_complete!mmpnf_bornfreeze),x
	bne	.nextplanet

	km_loblda.w	mmx_psos,x
	asl	a
	txy
	tax
	jsr	(.sostbl,x)
.nextplanet
	lda.w	mmx_planetnext,x
	tax
	bne	.loop
.end
	rts
;----------------------------------------------------------------------
.sostbl
	dw	misseq_nothing&WM
	dw	misseq_inittime&WM
	dw	misseq_wait&WM
	dw	misseq_born&WM

;=====================================================================
;*								*
;*		Missile Sub Sequence				*
;*								*
;* Xreg :Planet List Pointer 					*
;* Yreg :Enemy  List Pointer						*
;=====================================================================
misseq_nothing
	longa
	tyx
	rts
;----------------------------------------------------------------------
	longa
misseq_inittime
	tyx	;kanarazu 1 ban ue :'95/7/3

	km_bitcheckmismapevflag	misbornfreeze
	bne	.skip

	phx	;	>>>> PUSH X
	ldx	kdifficulty
	lda.l	SOSAppeartmBase,x
	clc
	adc.w	mmx_stage,y	;Mission Stage Number
	km_loba
	asl	a
	tax
	lda.l	SOSappeartmtbl,x
	sta.w	mmx_soswaittm,y
	plx	;	<<<< PULL X
	inc.w	mmx_psos,x
.skip
	rts
;-------------------------------------------------
misseq_wait
	longa
	tyx
	km_bitcheckflag.w	mmx_planetflag,(mmpnf_battleplayer!mmpnf_bornfreeze),x
	bne	..skip_wait
	jsr	soswait
..skip_wait
	rts
;-------------------------------------------------
	longa
	longi
misseq_born
	tyx
;* enemy total no kazu >= 16 (16 piki ijyou deteireba)*
	km_cmpcheck	kx_enemytotal,mm_enemymax	;(kalcs.inc)
	bpl	.end
	km_cmpcheck	kx_missilecurrent,mm_missilemax	;(gamelist.inc)
	bpl	.end
	km_bitcheckflag.w	mmx_planetflag,(mmpnf_complete!mmpnf_sosappear!mmpnf_bornfreeze!mmpnf_battleplayer),x
	bne	.end

	jsr	mm_initsoslist
	km_setflag16.w	mmx_planetflag,mmpnf_sosappear,x
	km_setval.w	mmx_psos,enbase_nothing,x
.end
	rts

;====================================================================================================
;====================================================================================================

;*********************************************************************
;*								*
;*								*
;*		Battle Ship Main Sequence			*
;* Data Bank :7e							*
;* Input :Xreg :Planet List Pointer					*
;* Set   :Yreg :Enemy List Pointer					*
;*********************************************************************
mm_BattleShipSequence_l
	jsr	mm_BattleShipSequence
	rtl

	longa
	longi
mm_BattleShipSequence
;---------------------------------------------------------------------
	km_bitcheckmismapevflag	btshipfreeze
	bne	.end

	km_setval	kx_PlanetcannonTmPriCheck,-1

	ldy	kx_enlistptr
	beq	.end	;no list
.loop
	ldx.w	mmx_ennext,y
	PHX	;>>> PUSH Next Pointer

	km_bitcheckflag16.w	mmx_enflags,enfl_battleship,y
	beq	.nextlist

	lda.w	mmx_ensequence,y
	asl	a
	tax
	jsr	(.bstbl,x)
.nextlist
	longa
	PLY	;Yreg (Next Pointer) <<< Xreg (!!! Z flag ON !!!)
	bne	.loop
;---------------------------------------------------------------------
.end
	rts

;---------------------------------------------------------------------
;*		Battle ship Sequence Table			*
;---------------------------------------------------------------------
.bstbl
	dw	battleship_nothing&WM
	dw	battleship_appeardemowait&WM
	dw	battleship_appeardemotrig&WM
	dw	battleship_appeardemo1&WM
	dw	battleship_appeardemo2&WM
	dw	battleship_appeardemo3&WM
	dw	battleship_move&WM
	dw	battleship_battleplayer&WM
	dw	battleship_attackcorneria&WM

;=====================================================================
;*								*
;*		Battleship Sub Sequence				*
;*								*
;* Xreg :Planet List Pointer  (Break)				*
;* Yreg :Enemy  List Pointer	 (Break)				*
;=====================================================================
battleship_nothing
	longa
	longi
	rts
;---------------------------------------------------------------------
battleship_appeardemowait
	longa
	jsr	enemywait
	bcc	.skip
	km_setval.w	mmx_ensequence,bsseq_appeardemotrig,y
.skip
	rts
;---------------------------------------------------------------------
battleship_appeardemotrig
	longa
	km_setval.w	mmx_enanmpatt,cd_objanime_battleship_dap,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_ensequence,bsseq_appeardemo1,y
	km_setval.w	mmx_enwaittm,24,y
	sta.w	mmx_enanmmax,y

	dec	kx_battleshipzaico	;battle ship no nokori !!
	rts
;---------------------------------------------------------------------
battleship_appeardemo1	;(Senkan kieru)
	longa
	jsr	enemywait
	bcc	.skip

	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_enanmpatt,-1,y
	km_setval.w	mmx_enstratptr,enstrat_straight,y
	km_setval.w	mmx_enwaittm,1,y
	km_setval.w	mmx_ensequence,bsseq_appeardemo2,y
.skip
	rts
;---------------------------------------------------------------------
battleship_appeardemo2	;(Senkan idou)
	longa
	lda.w	mmx_enwaittm,y
	beq	.FinishDemo2
.idou_demo
	jsr	check_enemyarrive	;collision check
	bcc	.skip1
	lda	#0
	sta.w	mmx_enwaittm,y
.skip1

	IFEQ	1
	lda.w	mmx_enchildlinkptr,y
	tax
.loop
	lda.w	mmx_enwaittm,x
	beq	.setchild
	dec	a
	sta.w	mmx_enwaittm,x
	bne	.next
.setchild
	lda.w	mmx_enposx,x
	clc
	adc.w	mmx_envelx,x
	sta.w	mmx_enposx,x

	lda.w	mmx_enposy,x
	clc
	adc.w	mmx_envely,x
	sta.w	mmx_enposy,x
.next
	lda.w	mmx_enchildlinkptr,x
	tax
	bne	.loop
	ENDC

	rts
;-------------------------------------------------
.FinishDemo2
	lda.w	mmx_enlinkptr,y
	tax
	a8
	lda.w	mmx_planetcx,x
	sta.w	mmx_enposx+1,y

	lda.w	mmx_planetcy,x
	dec	a
	sta.w	mmx_enposy+1,y

	a16
	km_setval.w	mmx_enanmpatt,cd_objanime_battleship_app,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_ensequence,bsseq_appeardemo3,y
	km_setval.w	mmx_enwaittm,27,y
	sta.w	mmx_enanmmax,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
;* sound *
	km_setflag16	kw_mmsoundflag,mmsndf_battleshipappear
	rts
;---------------------------------------------------------------------
battleship_appeardemo3	;(Senkan Syutugen)
	longa
	jsr	enemywait
	bcc	.skip
	jsl	bs_moveparams_l

	IFEQ	1
	jsl	mm_freechildlist_l
	ENDC

.skip
	rts
;---------------------------------------------------------------------
	longa
	longi
battleship_move
	lda.w	mmx_enlinkptr,y
	tax
	a8
	lda.w	mmx_enposx+1,y
	sta.w	mmx_planetcx,x
	lda.w	mmx_enposy+1,y
	sta.w	mmx_planetcy,x
	a16
;'95/9/5	km_bitcheckflag.w	mmx_enflags,enfl_encountplayer,y
;	bne	.encountplayer_sub

	km_bitcheckflag.w	mmx_enflags,enfl_arrive,y
	bne	.cannonarea_IN
;* zaco enemy born *
	jsr	mm_ZacoEnemyAppear
	rts
;---------------------------------------------------------------------
;'95/9/5
	IFEQ	1
.encountplayer_sub
	longa
	lda.w	mmx_ensequence,y
	sta.w	mmx_ensequence_bak,y
	lda.w	mmx_enstratptr,y
	sta.w	mmx_enstratptr_bak,y

	lda	#enstrat_nothing
	sta.w	mmx_enstratptr,y
	lda	#bsseq_battleplayer
	sta.w	mmx_ensequence,y
	rts
	ENDC
;---------------------------------------------------------------------
.cannonarea_IN
	longa
	km_clrflag16.w	mmx_enflags,(enfl_demo!enfl_arrive),y
	km_setflag16.w	mmx_enflags2,(enfl2_nojet),y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setval.w	mmx_ensequence,bsseq_attackcorneria,y

;* planetcannon initial *
	IFEQ	kcannonsw
	km_setflag16.w	mmx_battleshipflag,mmbsf_cannonareain,x
	km_setval.w	mmx_planetcannontm,planetcannonchargetm,x
	km_setval.w	mmx_planetcannonchart,pcspr_charge,x
	km_setval.w	mmx_pwork1,sprblockanm_cannonCharge,x
	km_setval.w	mmx_pwork2,0,x

;* Message Display *
	km_bitcheckmistotalflag	mission
	bne	.message_mission
.message_map
	km_setflag16	map_trigmessage,ymes_planetcannonarea
	rts

.message_mission
	km_setflag16	mmx_message_sos,mesosfl_planetcannonarea
	ENDC
	rts
;---------------------------------------------------------------------
	longa
	longi
battleship_attackcorneria
	jsr	setplanetcannontm
	jsr	mm_ZacoEnemyAppear
	rts
;---------------------------------------------------------------------
	longa
	longi
battleship_battleplayer
	jsr	setplanetcannontm
	rts


;'95/9/5
	IFEQ	1
	km_bitcheckflag.w	mmx_enflags,enfl_encountplayer,y
	bne	..battleplayer_skip
	lda.w	mmx_ensequence_bak,y
	sta.w	mmx_ensequence,y
	lda.w	mmx_enstratptr_bak,y
	sta.w	mmx_enstratptr,y
..battleplayer_skip
	rts
	ENDC


;---------------------------------------------------------------------
;*		Set Planet cannon Timer				* 
;* Init :Yreg :Enmey List (Battle Ship)				*
;* Break:Xreg :Planet List Pointer					*
;---------------------------------------------------------------------
	longa
	longi
setplanetcannontm
	km_bitcheckmismapfzflag	timefreeze
	bne	.end

	lda.w	mmx_enlinkptr,y
	tax
	km_bitcheckflag16.w	mmx_battleshipflag,mmbsf_cannonareain,x
	beq	.end
;* Dec timer *
	lda.w	mmx_planetcannontm,x
	beq	.Fire
	dec	a
	sta.w	mmx_planetcannontm,x
	beq	.Fire
	cmp	kx_PlanetcannonTmPriCheck	;Time no chiisai houno oto wo dasu (dec timer dakara)!!
	bcs	.end
.Charge
	km_bitcheckmismapflag	cannonstart
	bne	.end

	stx	kx_PlanetcannonListPtr
	lda.w	mmx_planetcannontm,x
	sta	kx_PlanetcannonTmPri
	sta	kx_PlanetcannonTmPriCheck
	km_setval	kx_PlanetcannonPtr,pcchart_charge
	bra	.end
.Fire
	km_bitcheckmismapflag	cannonstart
	bne	.end

	stx	kx_PlanetcannonListPtr
	lda.w	mmx_planetcannontm,x
	sta	kx_PlanetcannonTmPri
	km_setval	kx_PlanetcannonPtr,pcchart_messagetrig
	km_setmismapflag	cannonstart
.end
	rts

;---------------------------------------------------------------------
;*		Check Planet cannon Sound Prioity 		* 
;* Init :Yreg :Enmey List (Battle Ship)				*
;* Break:Xreg :Planet List Pointer					*
;---------------------------------------------------------------------
	longa
	longi
CheckPCTmPri_l
	PHX
	PHY

	km_setval	kx_PlanetcannonTmPriCheck,-1

	ldy	kx_enlistptr
	beq	.end	;no list
.loop
	km_bitcheckflag16.w	mmx_enflags,enfl_battleship,y
	beq	.nextlist
	jsr	CheckPCTmPri_sub
.nextlist
	lda.w	mmx_ennext,y
	tay
	bne	.loop
.end
	PLY
	PLX
	rtl
;-----------------------------------------------------
;*		Sub Routine			*
;-----------------------------------------------------
	longa
	longi
CheckPCTmPri_sub
	km_bitcheckmismapflag	cannonstart
	bne	.end
	
	lda.w	mmx_enlinkptr,y
	tax
	km_bitcheckflag16.w	mmx_battleshipflag,mmbsf_cannonareain,x
	beq	.end

	lda.w	mmx_planetcannontm,x
	cmp	kx_PlanetcannonTmPriCheck	;Time no chiisai houno oto wo dasu (dec timer dakara)!!
	bcs	.end
.Charge
	stx	kx_PlanetcannonListPtr
	sta	kx_PlanetcannonTmPri
	sta	kx_PlanetcannonTmPriCheck
	km_setsndflag	cannoncharge
.end
	rts
;=====================================================================
;*		Battle Ship Move Params				*
;=====================================================================
bs_moveparams_l
	longa
	longi

	lda.w	mmx_enlinkptr,y
	tax
	a8
	lda.w	mmx_planetcy,x
	sta.w	mmx_enposy+1,y

	lda.w	mmx_planetcannonsx,x	;mmx_destx,x
	sta.w	mmx_endestx,y
	lda.w	mmx_planetcannonsy,x	;mmx_desty,x
	sta.w	mmx_endesty,y
	a16

;* enemy animation *
	lda	#0
	sta.w	mmx_enanmtm,y
	lda	#cd_objanime_battleship
	sta.w	mmx_enanmpatt,y
	lda	#80
	sta.w	mmx_enanmmax,y
;* flag *
	km_clrflag16.w	mmx_enflags,(enfl_nocollision),y
	km_setflag16.w	mmx_enflags,enfl_demo,y
	km_setflag16.w	mmx_enflags2,(enfl2_nojet!enfl2_anmloop),y

	lda	#enstrat_straight
	sta.w	mmx_enstratptr,y
	lda	#bsseq_move
	sta.w	mmx_ensequence,y
;* animation *
	lda	#cd_objanime_battleship
	sta.w	mmx_enanmpatt,y
;* velocity *
	lda	#btship_speed
	jsr	calc_bsspeed
	rtl
;---------------------------------------------------------------------
;*		Calculate Battle Ship Speed			*
;* (Angle Y & Velocity)						*
;---------------------------------------------------------------------
calc_bsspeed_L
	jsr	calc_bsspeed
	rtl
calc_bsspeed
	longa
	longi
	sta.w	mmx_envel,y	;velocity
	jsl	calc_enangvelxy_l
	lda.w	mmx_enlinkptr,y
	tax
	lda.w	mmx_enangY,y
	sta.w	mmx_bsangY,x	;Battle Ship Dest Angle
	rts


;=====================================================================
;*								*
;*		Enemy Arrived Dest Postion Check		*
;* Yreg= Enemy List Pointer						*
;* sec = Hit								*
;* clc = No Hit							*
;=====================================================================
check_enemyarrive_l
	jsr	check_enemyarrive
	rtl
check_enemyarrive
	longa
	longa
	km_loblda.w	mmx_enposx+1,y
	sta	kz_x1
	km_loblda.w	mmx_enposy+1,y
	sta	kz_y1
	lda.w	mmx_endestx,y
	sta	kz_x2
	lda.w	mmx_endesty,y
	sta	kz_y2
	lda.w	mmx_encoll,y
	sta	kz_z2
	jsr	en_collcheck_sub
	rts

;*********************************************************************
;*								*
;*		Zaco Enemy Appear (Form BattleShip)		*
;* Data Bank :7e							*
;* Yreg :Enemy List Pointer						*
;*********************************************************************
	longa
	longi
mm_ZacoEnemyAppear
	PHY
	lda.w	mmx_enlinkptr,y
	tay	;<<< Yreg <<< Planet List Pointer
	tax

	inc.w	mmx_timer2,x

	km_bitcheckmismapevflag	sosbornfreeze
	bne	.end
	km_loblda.w	mmx_psos,y
	asl	a
	tax
	jsr	(.sostbl,x)
.end
	PLY
	rts

;----------------------------------------------------------------------
.sostbl
	dw	zacoseq_nothing&WM
	dw	zacoseq_inittime&WM
	dw	zacoseq_wait&WM
	dw	zacoseq_born&WM
	dw	zacoseq_jetattackwait&WM

;=====================================================================
;*								*
;*		Zaco Enemy Sub Sequence				*
;* Xreg :temporary							*
;* Yreg :Enemy  List Pointer						*
;*(Return :Xreg <<< Planet List Pointer)				*
;=====================================================================
zacoseq_nothing
	longa
	rts
;----------------------------------------------------------------------
zacoseq_inittime
;Init: Yreg <<< Planet List Pointer
	longa
	km_cmpcheck	kx_enemytotal,mm_enemymax	;(gamelist.inc)
	bpl	.enemykazu_over
	km_cmpcheck	kx_zacocurrent,mm_zacomax	;(gamelist.inc)
	bmi	.check_chart
.enemykazu_over
	rts

.check_chart
	ldx.w	mmx_zacochartptr,y
	PHX	;>>> PUSH X reg (Zaco Chart Pointer)
	km_loblda.l	mm_ZacoChartTable+0,x
	asl	a
	tax
	jmp	(.table,x)	;jsr wa tukaenai (phx)!!
.table
	dw	.end&WM
	dw	.trigger&WM
	dw	.waittrig&WM
	dw	.wait&WM
	dw	.looptrig&WM
	dw	.loop&WM
;--------------------------------------------
.end
	longa
	plx
	rts
.trigger
	longa
	plx
	jsr	.set_timekazu
	bra	.rts_trigger
.waittrig
	longa
	plx
	jsr	.set_timekazu
	km_setflag16.w	mmx_planetflag,mmpnf_deadwait,y

	km_loblda.l	mm_ZacoChartTable+4,x
	sta.w	mmx_zacochartcnt,y	;[BIG LOOP Counter :Zaco teki Macro Loop] 
	bra	.rts_looptrig		;.rts_trigger

.wait
	longa
	plx
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_deadwait,y
	beq	.wait_finish	;link enemy dead
	rts

.wait_finish
;'95/8/25 :zaco enemy ga corneria ni HIT shinakunaru BUG taisaku !!
	km_setflag16.w	mmx_planetflag,mmpnf_deadwait,y
	bra	.loop_sub

.looptrig
	longa
	plx
	jsr	.set_timekazu
	km_loblda.l	mm_ZacoChartTable+4,x
	sta.w	mmx_zacochartcnt,y	;kx_zacochartcnt
	bra	.rts_looptrig
.loop
	longa
	plx
.loop_sub
	lda.w	mmx_zacochartcnt,y	;Check Loop Counter [soslist.asm de set shiteiru kazu]
	dec	a
	beq	.rts_loop
	sta.w	mmx_zacochartcnt,y

	dex	
	dex	
	dex	
	dex	
	dex	
	jsr	.set_timekazu
	
	bra	.next_seq

.rts_looptrig
	inx
.rts_trigger
	inx
	inx
	inx
	inx
	txa
	sta.w	mmx_zacochartptr,y
.next_seq
	tyx
	inc.w	mmx_psos,x
.rts
	rts
.rts_loop
.rts_wait
	longa
	inx
	txa
	sta.w	mmx_zacochartptr,y
	km_clrflag16.w	mmx_planetflag,mmpnf_deadwait,y
	rts
;-----------------------------------------------------------------------
.set_timekazu
;Yreg :Planet List Pointer
	longa
	longi
	lda.l	mm_ZacoChartTable+1,x
	sta.w	mmx_soswaittm,y

	km_loblda.l	mm_ZacoChartTable+3,x
	sta	kz_x1

	lda	kx_battleshipcurrent
	dec	a
	bne	.kazu2
	inc	kz_x1
.kazu2
	lda	kz_x1
	sta.w	mmx_sosdeadcnt,y	;Zaco Enemy no kazu
	sta.w	mmx_sosapcnt,y		;Zaco Enemy Appear Counter

	km_setflag16.w	mmx_planetflag,mmpnf_borndemotrig,y
	rts

;	printf	"difficulty ",:$kdifficulty,"%n"
;	printf	"difficulty2 ",:$kdifficulty2,"%n"
;	printf	"ram paths ",:$rampatharea
;	printf	"cockpitcgx ",:$cockpitcgx_buf
;	printf	"debugaddr",:$*,"%n"
;----------------------------------------------------------------------
zacoseq_wait
	longa
	tyx
;* senkan to player ga battle chyuu no toki !! *
	km_bitcheckflag.w	mmx_planetflag,mmpnf_battleplayer,x
	bne	..skip_wait
	jsr	soswait
..skip_wait
	rts
;----------------------------------------------------------------------
zacoseq_born
	longa
	tyx
.loop
	km_cmpcheck	kx_enemytotal,mm_enemymax	;(gamelist.inc)
	bpl	.end
	km_cmpcheck	kx_zacocurrent,mm_zacomax	;(gamelist.inc)
	bpl	.end

	lda.w	mmx_sosapcnt,x
	beq	.nextseq
	dec	a
	sta.w	mmx_sosapcnt,x
	jsr	mm_initsoslist
	bra	.loop
.nextseq
	longa
	km_setval.w	mmx_psos,enbase_inittime,x
.end
	rts
;----------------------------------------------------------------------
zacoseq_jetattackwait
	longa
	tyx
	jsr	soswait
	bcc	.skip
	lda	#enbase_nothing
	sta.w	mmx_psos,x

	lda.w	mmx_bslinkptr,x
	tay
	km_clrflag16.w	mmx_enflags2,enfl2_nojet,y
;* velocity *
	lda	#btship_speed*16
	jsr	calc_bsspeed

.skip
	rts

;*********************************************************************
;*								*
;*		SOS Enemy Appear				*
;* Data Bank :7e							*
;*********************************************************************
	longa
	longi
mm_EnemySequence
	km_bitcheckmismapevflag	sosfreeze
	bne	.end
;----------------------------------------------------------------------
	ldy	kx_enlistptr
	beq	.end
.loop
	ldx.w	mmx_ennext,y
	PHX	;>>> PUSH Next Pointer

	km_bitcheckflag16.w	mmx_enflags,(enfl_itemplanet!enfl_satellite!enfl_battleship!enfl_finalboss!enfl_mothership),y ;!enfl_child
	bne	.nextSOS

	km_loblda.w	mmx_ensequence,y
	asl	a
	tax
	jsr	(ksostbl,x)

.nextSOS
	PLY	;Yreg (Next Pointer) <<< Xreg (!!! Z flag ON !!!)
	bne	.loop
.end
	rts
;----------------------------------------------------------------------
;----------------------------------------------------------------------
ksostbl
	dw	sosseq_nothing&WM
	dw	sosseq_appeardemo&WM
	dw	sosseq_chaseangle&WM

	dw	sosseq_spenappear1&WM
	dw	sosseq_spenappear2&WM

	dw	sosseq_planetsenryou1&WM
	dw	sosseq_planetsenryou2&WM

	dw	sosseq_move&WM
	dw	sosseq_attackcorneria&WM
	dw	sosseq_friendbattle&WM

	dw	sossqq_virusmove&WM
	dw	sossqq_virustorituki&WM

	dw	sosseq_beemexplodetrig&WM
	dw	sosseq_beemexplodeLtrig&WM
	dw	sosseq_beemexplode&WM

	dw	sosseq_enterdemo1&WM
	dw	sosseq_enterdemo2&WM
	dw	sosseq_explodedemo&WM
	dw	sosseq_disappear&WM

;=====================================================================
;*								*
;*		SOS Enemy Sub Sequence				*
;*								*
;* Xreg :Planet List Pointer (Break)					*
;* Yreg :Enemy  List Pointer	(Break)					*
;=====================================================================
sosseq_nothing
	longa
	rts
;----------------------------------------------------------------------
	longa
	longi
sosseq_spenappear1
	jsr	check_enemyarrive	;collision check
	bcc	.skip1

	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setval.w	mmx_enanmpatt,cd_objanime_spenemyappear,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_ensequence,enseq_spenappear2,y
	km_setval.w	mmx_enwaittm,16,y
	sta.w	mmx_enanmmax,y
.skip1
	rts

	longa
	longi
sosseq_spenappear2
	lda.w	mmx_enwaittm,y
	dec	a
	sta.w	mmx_enwaittm,y
	bne	.skip

	km_clrflag16.w	mmx_enflags,enfl_demo,y
	km_setval.w	mmx_ensequence,enseq_move,y
	dec	mmx_specialapcocnt
.skip
	rts
;----------------------------------------------------------------------
	longa
	longi
sosseq_planetsenryou1
	jsr	check_enemyarrive	;collision check
	bcc	.skip1
	km_setflag.w	mmx_enflags,enfl_demo,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setval.w	mmx_enanmpatt,cd_objanime_planetsenryou,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_ensequence,enseq_planetsenryou2,y
	km_setval.w	mmx_enwaittm,50,y
	sta.w	mmx_enanmmax,y
	ksound	en_explode_demo
.skip1
	rts

	longa
	longi
sosseq_planetsenryou2
	lda.w	mmx_enwaittm,y
	dec	a
	sta.w	mmx_enwaittm,y
	bne	.skip
	jsl	mm_freeenemylistptr_l
	dec	mmx_specialapcocnt
.skip
	rts
;----------------------------------------------------------------------
	longa
	longi
sosseq_appeardemo
	jsr	enemywait
	bcc	.wait

;* chase planet initial (For Missile) *
	km_bitcheckflag16.w	mmx_enflags,enfl_missile,y
	beq	sosseq_initparams

	km_setval.w	mmx_enwork1,$200,y	;Chase Step Angle
	jsr	init_chaseparams8
	km_setval.w	mmx_envel,512,y		;velocity
	km_setval.w	mmx_enstratptr,enstrat_chase,y
.wait
	rts
;----------------------------------------------------------------------
	longa
	longi
sosseq_chaseangle	;(For Missile)
	lda.w	mmx_enwaittm,y
	beq	sosseq_initparams
	rts
;----------------------------------------------------------------------
	longa
	longi
sosseq_initparams
	longa
	jsr	InitSOSmoveParams
;* next sequence *
	km_setval.w	mmx_ensequence,enseq_move,y

	lda	mmx_expwaitcnt
	beq	.skip
	dec	a
	sta	mmx_expwaitcnt
.skip

;* message check *
	km_bitcheckmistotalflag	mission
	beq	.no_message
	km_bitcheckflag16.w	mmx_enflags,enfl_missile,y
	bne	.mes_missileappear
.mes_zacoappear
	km_setflag16	mmx_message_sos,mesosfl_zacoappear	;[for yajima's]
	bra	.no_message
.mes_missileappear
	km_setflag16	mmx_message_sos,mesosfl_missileappear	;[for yajima's]
.no_message
	rts

	IFEQ	1
;* Explain demo wait *
	lda	mmx_expwaitcnt
	beq	.zacoappear
	dec	a
	sta	mmx_expwaitcnt
	beq	.zacoappear
	rts
.zacoappear
	km_setmismapstflag	expdemostart
	ENDC
;=====================================================================
;*								*
;*			Enemy Move Routine			*
;* Yreg :Enemy  List Pointer						*
;=====================================================================
	longa
	longi
sosseq_move
	km_bitcheckflag.w	mmx_enflags,enfl_attackcorneria,y
	bne	sosseq_attackcorneria
	km_bitcheckflag.w	mmx_enflags2,enfl2_searchenemy,y
	km_bne	sosmv_searchenemy
	km_bitcheckflag16.w	mmx_enflags,enfl_special,y
	km_bne	sosmv_taimankun
	rts

;-------------------------------------------------------------
;*		attack corneria 			*
;-------------------------------------------------------------
	longa
	longi
sosseq_attackcorneria
;X,Y reg :Planet List Pointer 
	lda.w	mmx_enwaittm,y
	beq	.attack
	dec	a
	sta.w	mmx_enwaittm,y
	bne	.skip
.attack
	jsr	SetAttackPoint
	km_setval.w	mmx_enwaittm,2*60,y
.skip
	rts


;-------------------------------------------------------------
;*			taiman kun			*
;-------------------------------------------------------------
	longa
	longi
sosmv_taimankun
	km_bitcheckflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	bne	.GoToCorneria	;player ga battle tyuu no toki wa
.StayCorneria

.Search
	lda.w	mmx_enwaittm,y
	beq	.Lock_ON
	dec	a
	sta.w	mmx_enwaittm,y
	rts
.Lock_ON
	jsr	mm_playerdest
	km_setval.w	mmx_enstratptr,enstrat_posvel,y
	km_setval.w	mmx_envel,sos_specialsp,y

	lda.w	mmx_enskill,y
	sec
	sbc	#$1c
	asl	a
	tax
	lda.l	.typetbl,x
	sta.w	mmx_enwaittm,y
	rts
.typetbl
	dw	1*60
	dw	2*60
	dw	3*60
	dw	4*60

	longa
.GoToCorneria
	km_bitcheckflag16.w	mmx_enflags,enfl_arrive,y ;(mm_sosenemycollision_sub)
	bne	.AttackCorneria

	km_setval.w	mmx_envel,sos_zacosp1_easy,y
	km_setval.w	mmx_enstratptr,enstrat_posvel,y
	jsr	mm_enemydest
	rts

	longa
.AttackCorneria
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	rts

;---------------------------------------------------------------------
;*			Virus Move Routine			*
;---------------------------------------------------------------------
	longa
	longi
sossqq_virusmove
	jsr	check_enemyarrive
	bcc	.end

; arrive virus *
	ldx	kx_satelliteenptr
	lda.w	mmx_enposx,x
	sta.w	mmx_enposx,y
	lda.w	mmx_enposy,x
	sta.w	mmx_enposy,y

	km_setval	kx_satellitetype,2		;andross side
	km_setflag16.w	mmx_enflags2,enfl2_tyuuritu,X	;andross side :(satellite list pointer)
	km_setflag16.w	kx_satelliteflag,safl_virustorituki
	km_setval.w	mmx_ensequence,enseq_virustorituki,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setflag16	mmx_message_sos,mesosfl_virustorituki	;[for yajima's]

;* torituki sprite animation flag *
	km_bitcheckmistotalflag	mission
	bne	.mission
	km_setflag16.w	kx_satelliteflag,safl_toritukitrig
.mission

;* mou sudeni enemy ni lockon sareteitara kaijyo ('95/6/25) *
	km_bitcheckflag	kx_satelliteflag,safl_lockon
	beq	.End
	km_clrflag	kx_satelliteflag,safl_lockon
	ldx	kx_salockonptr
	km_clrflag16.w	mmx_enflags,enfl_nocollision,x	;enemy collision ON
.end
	rts
;-------------------------------------------------
	longa
	longi
sossqq_virustorituki
	rts
;-------------------------------------------------
sosseq_friendbattle	;Now Not Using :'95/9/8
	longa
	lda.w	mmx_enwaittm,y
	bne	.skip
	jsr	kenemybomb_sub

	km_bitcheckmismapflag	returnmap
	bne	.demo_cancel
.demo_on	;(map)
	km_setval.w	mmx_ensequence,enseq_explodedemo,y
.skip
	rts

.demo_cancel	;(mission)
	km_setflag16	mmx_message_sos,mesosfl_missileattack	;[for yajima's]
	jsr	SetAttackPoint
	brl	sosseq_disappear
;-------------------------------------------------
sosseq_beemexplodetrig
	tyx
	km_setval.w	mmx_enanmpatt,cd_objanime_explode_zaco,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setflag16.w	mmx_enflags,(enfl_nocollision!enfl_demo),y
	km_setval.w	mmx_enwaittm,(64-1),y
	sta.w	mmx_enanmmax,y
	km_setval.w	mmx_ensequence,enseq_beemexplode,y
	rts
;-------------------------------------------------
sosseq_beemexplodeLtrig
	tyx
	km_setval.w	mmx_enanmpatt,cd_objanime_missileexplode,y
	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setflag16.w	mmx_enflags,(enfl_nocollision!enfl_demo),y
	km_setval.w	mmx_enwaittm,(76-1),y
	sta.w	mmx_enanmmax,y
	km_setval.w	mmx_ensequence,enseq_beemexplode,y
	rts
;-------------------------------------------------
sosseq_beemexplode
	tyx
	jsr	enemywait
	bcc	.wait
	jsl	FreeEnemyList_l
	km_clrflag16	kx_satelliteflag,safl_explodewait
	km_setval	kx_MisMapDemoNumber,kdemo_nothingdemo
.wait
	rts
;-------------------------------------------------
sosseq_enterdemo1
	tyx
	km_bitcheckmismapflag	returnmap
	bne	sosseq_misdemocancel	;(mission tyuu)

	jsr	enemywait
	bcc	.wait_end
	km_setval.w	mmx_enwaittm,12,y
	sta.w	mmx_enanmmax,y
	km_setval.w	mmx_enanmpatt,cd_objanime_sosplanein,y
	km_setval.w	mmx_enanmtm,0,y
	km_setflag16.w	mmx_enflags,enfl_demo,y
;;;	km_setflag16	kw_mmsoundflag,mmsndf_missilein
.wait_end
	rts
;-------------------------------------------------
sosseq_enterdemo2
	tyx
	km_bitcheckmismapflag	returnmap
	bne	sosseq_misdemocancel	;(mission tyuu)

	jsr	enemywait
	bcc	.wait_end

;* Corneria Damage *
	jsr	SetAttackPoint
;* bakuhatu animation pattern *
	jsr	kenemybomb_sub

.wait_end
	rts
;-------------------------------------------------
sosseq_explodedemo
	km_bitcheckmismapflag	returnmap
	bne	sosseq_disappear	;(mission tyuu)

	jsr	enemywait
	rts
;-------------------------------------------------
sosseq_misdemocancel
;* Corneria Damage *
	jsr	SetAttackPoint
	km_setflag16	mmx_message_sos,mesosfl_missileattack	;[for yajima's]
	bra	sosseq_disappear
;-------------------------------------------------
sosseq_disappear
; Yreg :Enemy  List Pointer
	longa
	jsl	mm_freeenemylistptr_l

	rts

;-------------------------------------
;*	Missile Ferll		*
;-------------------------------------
kmissilefell_sub_l
	a16
	km_setflag16.w	mmx_enflags,enfl_nocollision,y
	km_setflag16.w	mmx_enflags2,(enfl2_nojet),y

	km_setval.w	mmx_enstratptr,enstrat_spin,y
	km_setval.w	mmx_ensequence,enseq_enterdemo1,y
	km_setval.w	mmx_enwaittm,60,y	;Rotation Time
	km_setval.w	mmx_enwork1,$400,y	;Rotation Angle  Accell

	ldx	#0
	km_loblda.w	mmx_enposx+1,y
	cmp	#$4*8
	bmi	.skip
	inx
	cmp	#$6*8
	bmi	.skip
	inx
	cmp	#$8*8
	bmi	.skip
	inx
.skip
	txa
	asl	a
	asl	a
	tax

	lda.l	entervelxtbl,x
	sta.w	mmx_envelx_l,y
	lda.l	entervelytbl,x
	sta.w	mmx_envely_l,y
	a8
	lda.l	entervelxtbl+2,x
	sta.w	mmx_envelx+1,y
	lda.l	entervelytbl+2,x
	sta.w	mmx_envely+1,y
	a16
	rtl

;-----------------------------
;* SOS Zaco no Gekitui !!	*
;-----------------------------
kenemybomb_sub_l
	jsr	kenemybomb_sub
	rtl

kenemybomb_sub
	km_setval.w	mmx_enanmpatt,cd_objanime_missileexplode,y

	km_setval.w	mmx_enwaittm,(76-1),y
	sta.w	mmx_enanmmax,y

	km_setval.w	mmx_enanmtm,0,y
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setflag16.w	mmx_enflags,(enfl_nocollision!enfl_demo),y
	rts

;-------------------
;*  search enemy   *
;-------------------
	longa
	longi
sosmv_searchenemy
	km_bitcheckmismapstflag	wolfgone
	beq	.normal
.wolfgone
	rts

.normal
	lda.w	mmx_enmvchart,y
	asl	a
	tax
	jmp	(.table,x)

.table
	dw	EEEE&WM		;move quick initial
	dw	FFFF&WM		;move quick
	dw	GGGG&WM		;chart reset
	dw	AAAA&WM		;move (straight) initial
	dw	BBBB&WM		;move (straight) 

AAAA
	km_setval.w	mmx_envel,100*2,y	;velocity
	jsr	calc_enangvelxy
	km_setval.w	mmx_enstratptr,enstrat_straight,y
	km_setval.w	mmx_enmvwaittm,3*60,y

	tyx
	inc.w	mmx_enmvchart,x
	rts
BBBB
	jsr	qqqq
	rts

EEEE
	jsr	mm_playerdest			;player postion
	km_setval.w	mmx_enstratptr,enstrat_posvel,y
	km_setval.w	mmx_enmvwaittm,60*2,y
	km_setval.w	mmx_envel,sos_wolfsp,y	;velocity

	km_bitcheckmismapflag2	wolfboss
	beq	.skipAAA
	km_setval.w	mmx_envel,1200,y	;velocity
	km_setval.w	mmx_enmvwaittm,60*5,y
.skipAAA
	tyx
	inc.w	mmx_enmvchart,x
	rts
FFFF
	jsr	mm_playerdest			;player postion
	jsr	qqqq
	rts

GGGG
	lda	#0
	sta.w	mmx_enmvchart,y
	rts

QQQQ
	tyx
	lda.w	mmx_enmvwaittm,y
	beq	.finish_wait
	dec	a
	sta.w	mmx_enmvwaittm,y
	rts
.finish_wait
	inc.w	mmx_enmvchart,x
	rts





	IFEQ	1
sosmv_searchenemy
	lda.w	mmx_enmvchart,y
	asl	a
	tax
	jmp	(.table,x)

.table
	dw	AAAA&WM		;move (straight) initial
	dw	BBBB&WM		;move (straight) 
	dw	CCCC&WM		;chase
	dw	DDDD&WM		;chase wait
	dw	EEEE&WM		;move quick initial
	dw	FFFF&WM		;move quick
	dw	GGGG&WM		;chart reset

AAAA
	km_setval.w	mmx_envel,100*2,y	;velocity
	jsr	calc_enangvelxy
	km_setval.w	mmx_enstratptr,enstrat_straight,y
	km_setval.w	mmx_enmvwaittm,3*60,y

	tyx
	inc.w	mmx_enmvchart,x
	rts
BBBB
	jsr	qqqq
	rts

CCCC
	km_bitcheckflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	bne	.search_planet
	jsr	mm_playerdest			;player postion

	bra	.search_skip
.search_planet
	jsr	mm_enemydest
.search_skip
	km_setval.w	mmx_enwork1,$400,y	;Chase Step Angle
	km_setval.w	mmx_envel,0,y		;velocity

	jsr	init_chaseparams16
	lda.w	mmx_enwaittm,y
	sta.w	mmx_enmvwaittm,y
	km_setval.w	mmx_enstratptr,enstrat_chase,y
	km_setval.w	mmx_enwork4,3*60,y

	tyx
	inc.w	mmx_enmvchart,x
	rts

DDDD
	jsr	qqqq
	rts

EEEE
	km_setval.w	mmx_enstratptr,enstrat_angvel,y
	km_setval.w	mmx_enmvwaittm,60*2,y
	km_setval.w	mmx_envel,1800,y		;velocity
	tyx
	inc.w	mmx_enmvchart,x
	rts
FFFF
	jsr	qqqq
	rts

GGGG
	lda	#0
	sta.w	mmx_enmvchart,y
	rts

QQQQ
	tyx
	lda.w	mmx_enmvwaittm,y
	beq	.finish_wait
	dec	a
	sta.w	mmx_enmvwaittm,y
	rts
.finish_wait
	inc.w	mmx_enmvchart,x
	rts
	ENDC

;-------------------
;*
;-------------------
	longa
	longi
	IFEQ	1
sosmv_searchenemy
	lda.w	mmx_enmvchart,y
	asl	a
	tax
	jmp	(.table,x)

.table
	dw	AAAA&WM
	dw	BBBB&WM

	dw	CCCC&WM
	dw	DDDD&WM
	dw	EEEE&WM
	dw	FFFF&WM
	dw	GGGG&WM

AAAA
	tyx
	km_setval.w	mmx_enmvwaittm,$40*3+$20,y
	km_setval.w	mmx_enwork1,$20,y
	km_setval.w	mmx_enwork3,$200,y
	inc.w	mmx_enmvchart,x
	rts
BBBB
	jsr	qqqq

	lda.w	mmx_enwork1,y
	beq	.abc
	dec	a
	sta.w	mmx_enwork1,y

	lda.w	mmx_enwork2,y
	bit	#1
	bne	.minus
.plas
;	lda.w	mmx_enangY,y
;	clc
;	adc.w	mmx_enwork3,y
;	sta.w	mmx_enangY,y
	bra	.def
.minus
;	lda.w	mmx_enangY,y
;	sec
;	sbc.w	mmx_enwork3,y
;	sta.w	mmx_enangY,y
.def
	rts

.abc
;	lda.w	mmx_enwork2,y
;	eor	#1
;	sta.w	mmx_enwork2,y

	km_setval.w	mmx_enwork1,$40,y
;;;	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	rts
CCCC
	km_setval.w	mmx_enwork1,$400,y	;Chase Step Angle
	jsr	setchaseparams
	lda.w	mmx_enwaittm,y
	sta.w	mmx_enmvwaittm,y
	km_setval.w	mmx_envel,0,y		;velocity
	tyx
	inc.w	mmx_enmvchart,x
	rts

DDDD
	jsr	qqqq
	rts

EEEE
	km_setval.w	mmx_enstratptr,enstrat_angvel,y
	km_setval.w	mmx_enmvwaittm,60*2,y
	km_setval.w	mmx_envel,1000*2,y		;velocity
	tyx
	inc.w	mmx_enmvchart,x
	rts
FFFF
	jsr	qqqq
	rts

GGGG
	lda	#0
	sta.w	mmx_enmvchart,y
	km_setval.w	mmx_envel,100*2,y		;velocity
	jsr	calc_enangvelxy
	km_setval.w	mmx_enstratptr,enstrat_straight,y
	rts

QQQQ
	tyx
	dec.w	mmx_enmvwaittm,x
	beq	.finish_wait
	rts
.finish_wait
	inc.w	mmx_enmvchart,x
	rts

	ENDC

;-------------------
;*  Search enemy   *
;-------------------
	IFEQ	1
	longa
	longi
sosmv_searchenemy
	km_bitcheckflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	bne	.GoToCorneria
	lda.w	mmx_enwork4,y
	beq	.skip111
	dec	a
	sta.w	mmx_enwork4,y
	rts
.skip111
	km_setval.w	mmx_enwork1,$080,y	;Chase Step Angle
	jsr	setchaseparams
	rts

.GoToCorneria
	km_bitcheckflag16.w	mmx_enflags,enfl_searchon,y
	beq	.noreset_searchtm
	km_setval.w	mmx_enwork4,1,y
.noreset_searchtm

	km_setval.w	mmx_envel,sos_specialsp,y
	km_setval.w	mmx_enstratptr,enstrat_posvel,y
	jsr	mm_enemydest
	rts
	ENDC

;---------------------
;* Set Chase Params	*
;---------------------
	longa
	longi
setchaseparams
	km_setflag16.w	mmx_enflags2,enfl2_searchon,y
	jsr	mm_playerdest			;player postion
	km_setval.w	mmx_envel,600,y		;velocity
	jsr	init_chaseparams16
	km_setval.w	mmx_enstratptr,enstrat_chase,y
	km_setval.w	mmx_enwork4,3*60,y
	rts

;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
	IFEQ	1
;-------------------
;*  battle player  *
;-------------------
	longa
	longi
battleplayer_sub
	lda	#0
	sta.w	mmx_enanmpatt,y
	sta.w	mmx_enanmtm,y

	lda.w	mmx_ensequence,y
	sta.w	mmx_ensequence_bak,y
	lda.w	mmx_enstratptr,y
	sta.w	mmx_enstratptr_bak,y

	lda	#enstrat_nothing	;battleplayer
	sta.w	mmx_enstratptr,y
	lda	#enseq_battleplayer
	sta.w	mmx_ensequence,y
	rts
;-------------------------------------------------
	longa
	longi
sosseq_battleplayer
; Yreg :Enemy  List Pointer
	km_bitcheckflag.w	mmx_enflags,enfl_encountplayer,y
	bne	..battleplayer_skip
	lda.w	mmx_ensequence_bak,y
	sta.w	mmx_ensequence,y
	lda.w	mmx_enstratptr_bak,y
	sta.w	mmx_enstratptr,y

..battleplayer_skip
	rts

	ENDC
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------

;=====================================================================
;*								*
;*		SOS Enemy Self Destruction			*
;* Yreg :Enemy  List Pointer						*
;=====================================================================
Self_destruction_l
	longa
	longi
	jsr	kenemybomb_sub
	km_setval.w	mmx_ensequence,enseq_explodedemo,y
	rtl

;=====================================================================
;*		Enemy Wait					*
;* Yreg :Enemy  List Pointer						*
;=====================================================================
enemywait
	longa
	longi
	lda	#1
	jsl	kspeedupA_l
	sta	kz_x1
	lda.w	mmx_enwaittm,y
	sec
	sbc	kz_x1
	sta.w	mmx_enwaittm,y
	beq	.finish_wait
	bcs	.waiting
.finish_wait
	lda.w	mmx_ensequence,y
	inc	a
	sta.w	mmx_ensequence,y
	sec
	rts
.waiting
	clc
	rts

;=====================================================================
;*		Corneria HP Decriment				*
;* Yreg:Enemy List Pointer						*
;* 16 frame oki ni 1 kai						*
;=====================================================================
SetAttackPoint_l
	jsr	SetAttackPoint
	rtl

	longa
	longi
SetAttackPoint
	km_bitcheckflag16.w	mmx_enflags,enfl_missile,y
	bne	.missile
	km_setflag16	kw_mmsoundflag,mmsndf_corneriaexplode
	bra	.common
.missile
	km_setflag16	kw_mmsoundflag,mmsndf_missilein
.common
	lda.w	mmx_enattackpo,y
	ifne	kdamage0
	lda	#0
	endc

	sta	kz_x1
	lda.w	mmx_enkazu,y
	sta	kz_y1
	jsl	kcpumultu8u8_l
	clc
	adc	kx_AttackPoint
	sta	kx_AttackPoint
.skip
	rts

;-----------------------------------------------------
;*	Calc Corneria HitPoint Sub Routine	*
;* Input :kz_x1 :Attack Point			*
;-----------------------------------------------------
	longa
	longi
DecCorneriaHP_mission_l
	km_bitcheckmismapflag2	damagedisable
	bne	.disable

	lda	kx_AttackPoint
	bne	.SetDamage
.disable
	lda	msx_ExplodeDispTm
	beq	.skip
	dec	a
	sta	msx_ExplodeDispTm
	bne	.skip
	km_clrscreenflag	damagetrig
.skip
	clc
	rtl
;---------------------------------------------------
.SetDamage
	dec	kx_AttackPoint
	dec	kx_CorneriaHP
	km_setmismapflag	attackcorneria	;corneria kougeki tyuu
	km_setscreenflag	damagetrig
	km_setval	msx_ExplodeDispTm,50

	lda	#100
	sec
	sbc	kx_CorneriaHP
	sta	kx_CorneriaDamage
	cmp	#100
	bne	.end
;* trigger *
.damage100
	km_setmissionsyori	corneriafell	;[for mission]

;('95/9/5) :moshi 100% damage ni natta syunkani map ni modottara !!
	km_setval kx_CorneriaFellSeq,cfseq_felltrig 	;[for map]
	km_setmismapflag	corneriafell		;[for map]

	km_setflag16	kw_gameFlag,(kgf_pausedisable!kgf_keydisable)
	km_setmismapflag2	damagedisable
.end
	sec
	rtl


;-----------------------------------------------------
;*	Calc Corneria HitPoint Sub Routine	*
;* Input :kz_x1 :Attack Point			*
;-----------------------------------------------------
DecCorneriaHP_map_l
	km_bitcheckmismapflag2	damagedisable
	bne	.disable

	lda	kx_2FrameTm
	bne	.disable

	lda	kx_AttackPoint
	bne	.SetDamage
.disable
	clc
	rtl
;----------------------------------
.SetDamage
	dec	kx_AttackPoint
	dec	kx_CorneriaHP

	km_setmismapflag	attackcorneria	;corneria kougeki tyuu

	lda	#100
	sec
	sbc	kx_CorneriaHP
	sta	kx_CorneriaDamage
	cmp	#100
	bne	.end
;* trigger *
.damage100
	km_setval kx_CorneriaFellSeq,cfseq_felltrig 	;[for map]
	km_setmismapflag	corneriafell		;[for map]

	km_setmismapfzflag	gamefreeze		;[for map]
	km_clrflag16	mmx_cursorflag,curf_all		;[for map]
	km_clrflag16	mmx_cursorflag2,curf2_all	;[for map]
	km_clrflag16	mmx_arwingflag,mmf_all		;[for map]
	km_clrflag16	mmx_partnerflag,mmf_all		;[for map]

	km_setval	mmx_warpseltrig,0	;warp select cursor display OFF

	km_setflag16	kw_gameFlag,(kgf_pausedisable!kgf_keydisable)
	km_setmismapflag2	damagedisable

.end
	sec
	rtl

;=====================================================================
;*			SOS Wait				*
;* Xreg:Planet Pointer						*
;=====================================================================
soswait
	longa
	longi
	lda	#1
	jsl	kspeedupA_l
	sta	kz_x1
	lda.w	mmx_soswaittm,x
	sec
	sbc	kz_x1
	sta.w	mmx_soswaittm,x
	beq	.finish_wait
	bpl	.wait_end
.finish_wait
	inc.w	mmx_psos,x
	sec
	rts
.wait_end
	clc
	rts


;=====================================================================
;*		SOS Enemy List Initial Set			*
;* moshi SOS enemy ga APPEAR shitara					*
;* Init :Xreg :Appear Planet Popinter				*
;*      :Yreg :Enemy Popinter					*
;=====================================================================
mm_initsoslist
	php
	PHX
	ai16
;* get enemy list memory *
	jsr	mm_getenemylistptr
	tya
	sta.w	mmx_sosenlistptr,x	;Link Enemy List to Planet List

;* Enemy Sequence *
	lda	#enseq_appeardemo
	sta.w	mmx_ensequence,y
;* flag *
	km_setflag16.w	mmx_enflags,enfl_nocollision,y

;* source postion * <<<<
	txa
	sta.w	mmx_enlinkptr,y
	sta.w	mmx_ensourplanetptr,y
	km_lobswaplda.w	mmx_planetcx,x
	sta.w	mmx_enposx,y		;postion X
	km_lobswaplda.w	mmx_planetcy,x
	sta.w	mmx_enposy,y		;postion Y

;* dest postion *
	lda.w	mmx_destx,x
	sta.w	mmx_endestx,y
	lda.w	mmx_desty,x
	sta.w	mmx_endesty,y
;* Enemy Stratage *
	lda	#enstrat_straight
	sta.w	mmx_enstratptr,y	;stratage pointter

;* muteki Timer *
	lda	#3*8
	sta.w	mmx_eninvtm,y

;* skill *
	jsr	sosenemyskill

;--------------------------------------------------------------------
.end
	PLX
	plp
	rts

;=====================================================================
;*		SOS Move Parameters Initial			*
;* Yreg :Enemy Pointer						*
;=====================================================================
	longa
	longi
InitSOSmoveParams

	km_bitcheckflag16.w	mmx_enflags,enfl_virus,y
	km_bne	.End

;* dest *
	lda.w	mmx_ensourplanetptr,y
	tax
	lda.w	mmx_destx,x
	sta.w	mmx_endestx,y
	lda.w	mmx_desty,x
	sta.w	mmx_endesty,y

;* enemy velocity *
	phx
	a8
	km_hib0
	ldx	kdifficulty
	lda.w	mmx_entype,y	;sos type
	asl	a
	clc
	adc.l	SOSspeedBase,x
	a16
	tax
	lda.l	enemyspeedtbl,x
	sta.w	mmx_envel,y	;sosvel
	plx

	km_bitcheckflag16.w	mmx_enflags,(enfl_missile!enfl_battleship),y
	bne	.missile

.zaco
.normalenemy
	km_bitcheckflag16.w	mmx_enflags2,(enfl2_type),y
	bne	.typeB
	km_setval.w	mmx_enangY,$b000,y
	km_setval.w	mmx_enwork1,$80,y
	km_setval.w	mmx_enwork2,-$40,y
	bra	.skipaaa
.typeB
	km_setval.w	mmx_enangY,$3000,y
	km_setval.w	mmx_enwork1,$80,y
	km_setval.w	mmx_enwork2,$40,y
.skipaaa
	km_setval.w	mmx_enwork3,($9000/$40),y
	km_setval.w	mmx_enstratptr,enstrat_scurve,y

;--------------------
;!! debug !!
;	km_setflag16.w	mmx_enflags,enfl_searchenemy,y
;	bra	.searchenemy
;--------------------
	km_bitcheckflag16.w	mmx_enflags2,enfl2_searchenemy,y
	beq	.skip
.searchenemy
	km_setval.w	mmx_enmvchart,0,y
	km_setval.w	mmx_enmvwaittm,0,y
	bra	.skip
;AAAA
;	km_setval.w	mmx_enwork4,10*60,y
;BBBB
;	lda.w	mmx_bsangy,x
;	sta.w	mmx_enangy,y
;	jsr	calc_envelxy24
;	km_setval.w	mmx_enstratptr,enstrat_posvel,y
;	bra	.skip
.missile
	jsr	calc_enangvelxy
	dec	kx_missileappcnt
	km_setval.w	mmx_enstratptr,enstrat_straight,y
.skip
;* enemy animation *
	lda	#0
	sta.w	mmx_enanmpatt,y
	sta.w	mmx_enanmtm,y

;*** enemy flags ***
	km_clrflag16.w	mmx_enflags,(enfl_demo!enfl_nocollision),y
	km_clrflag16.w	mmx_enflags2,(enfl2_nojet),y
.End
	rts
;=====================================================================
;*			Get Enemy List Pointer			*
;* Yreg :Enemy List Pointer						*
;=====================================================================
mm_getenemylistptr_l
	jsr	mm_getenemylistptr
	rtl

mm_getenemylistptr
	PHX
	jsl	mm_getenemylistptrX_l
	txy
	PLX
	inc	kx_enemytotal
	rts

mm_getenemylistptrX_l
	php
	a16
	ldx	#0
	l_add.w	kx_enlistptr,kx_enfreeptr,mm_blink1
	plp
	rtl
;=====================================================================
;*		Free Enemy List Pointer				*
;* Xreg :Keep							*
;* Yreg :Enemy List Pointer	(Break)					*
;=====================================================================
mm_freeenemylistptr_l
	php
	a16
	longi
	phx
;-------------------------------------------------------------
	km_bitcheckflag16.w	mmx_enflags,enfl_missile,y
	bne	.missile
	bit	#enfl_special
	bne	.special
	bit	#enfl_virus
	bne	.virus
	bit	#enfl_wolf
	bne	.wolf

;------------------
;*   Zaco Enemy   *
;------------------
.zaco
	lda.w	mmx_ensourplanetptr,y
	tax		;Xreg <<< Battle Ship Pointer
	km_bitcheck.w	mmx_enflags2,enfl2_deadcnt,y
	beq	.skip_deadcnt
	dec.w	mmx_sosdeadcnt,x
	bne	.skip_deadcnt
	km_clrflag16.w	mmx_planetflag,mmpnf_deadwait,x
.skip_deadcnt
	dec	kx_zacocurrent
	bra	.common

;------------------
;*     Missile    *
;------------------
.missile
	lda.w	mmx_ensourplanetptr,y
	tax	;Set Planet List
	km_clrflag.w	mmx_planetflag,mmpnf_sosappear,x
	km_setval.w	mmx_psos,enbase_inittime,x
	dec	kx_missilecurrent

	km_bitcheckmismapdemoflag	missilefelldemo
	beq	.common
	stz	kx_playerdemowait
	km_setval	kx_MisMapDemoNumber,kdemo_nothingdemo
	bra	.common
;------------------
;*     Taimankun  *
;------------------
.special
	dec	kx_specialclearcnt
	dec	kx_specialcurrent
	bra	.common
;------------------
;*     virus      *
;------------------
.virus
	bra	.common

;------------------
;*     wolf      *
;------------------
.wolf
	dec	kx_wolfcurrent
;-------------------------------------------------------------
.common
;* free enemy states stack pointer (For Eguchi's)*
	lda.w	mmx_enstackptr,y
	tax
	a8
	stz.w	kx_stackbuffer,x
	stz.w	EEnemyNumber_0,x

	a16
	txa
	asl	a
	tax
	stz.w	SebangoSwitch_0,x
;-------------------------------------------------------------
;* List Free *
.list_free
	tyx	;Xreg <<<< Enemy List Pointer
	jsr	FreeEnemyList_sub
;-------------------------------------------------------------
;* Dec Enemy Total Kazu *
	dec	kx_enemytotal

	plx
	plp
	rtl

;---------------------------------------------------------------------
;*		Enemy List Free					*
;* Input :Xreg = Enemy List Pointer (Break)				*
;* Keep  :Yreg = Keep						*
;---------------------------------------------------------------------
	longa
	longi
FreeEnemyList_l
	jsr	FreeEnemyList_sub
	rtl

	longa
	longi
FreeEnemyList_sub
	phy
	km_clrflag16.w	mmx_enflags,enfl_all,x
	km_clrflag16.w	mmx_enflags2,enfl2_all,x
	stz.w	mmx_enanmmax,x
	stz.w	mmx_ensequence,x
	l_rem.w	kx_enlistptr,kx_enfreeptr
	ply
	rts
;=====================================================================
;*			Free Child List				*
;* data bank 7e							*
;* Yreg :Enemy List Pointer						*
;* Xreg :Keep							*
;=====================================================================
	IFEQ	1
mm_freechildlist_l
	phx
	phy
	php
	a16
	lda.w	mmx_enchildlinkptr,y
	beq	.end
	tax				;Get Child List Pointer
	lda	#0
	sta.w	mmx_enchildlinkptr,y	;mother-child Link Free
.loop
	lda.w	mmx_enchildlinkptr,x
	tay	; Next Pointer >>>> Yreg Push
	jsr	FreeEnemyList_sub
	tyx
	bne	.loop
.end
	plp
	ply
	plx
	rtl
	ENDC
;=====================================================================
;*								*
;* 		SOS Enemy Skill&Type  Set			*
;* a8i16								*
;* Xreg :Planet List Pointer						*
;* Yreg :Enemy List Pointer						*
;=====================================================================
sosenemyskill
	a16
	longi
	PHX
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_finalboss,x
	km_bne	.Virus

	km_bitcheckflag16.w	mmx_planetflag,mmpnf_battleship,x
	km_beq	.Planet

;-----------------------------------------------------------------------
.BattleShip	;(Zaco Enemy)
	inc	kx_zacocurrent	;genzai no zaco enemy no kazu

	km_setflag16.w	mmx_enflags,(enfl_zaco),y

	km_bitcheckflag16.w	mmx_planetflag,mmpnf_deadwait,x
	beq	.skipb
	km_setflag16.w	mmx_enflags2,(enfl2_deadcnt),y
.skipb

	lda	#15
	sta.w	mmx_enwaittm,y			;Demo Animation Timer

	km_setflag16.w	mmx_enflags2,(enfl2_nojet),y

	phx
	lda.w	mmx_sosapcnt,x
	asl	a
	tax
	lda.l	soszacovelxtbl,x
	sta.w	mmx_envelx,y	;velocity X
	lda.l	soszacovelytbl,x
	sta.w	mmx_envely,y	;velocity Y
	plx

;* enemy type *
	lda.w	mmx_sosapcnt,x
	and	#1
	beq	.skipc
	km_setflag16.w	mmx_enflags2,(enfl2_type),y
.skipc

	lda	#stg_sos1
	sta.w	mmx_enstage,y	;mission stage

	a8
	STORENASTY
	NASTYOFF
	ldx	sos_rnd_offset
	lda.l	sos_random,x	;(eguchi's plaent random table)
	sta	kz_x1		;(0~15)

	km_hib0
	ldx	kdifficulty
	lda.l	sosskilloffset,x
	clc
	adc	kz_x1
	sta.w	mmx_enskill,y	;SOS skill
	tax
	lda.l	sostypetbl,x
	sta.w	mmx_entype,y	;enemy type
;* search enemy *
	cmp	#entyp_zaco3
	bne	.skipa
;;;;	km_setflag16.w	mmx_enflags,enfl_searchenemy,y
.skipa

	lda.l	SOS1_target,x
	sta	kz_tpa
	lda.l	SOS1_target_shape_A,x
	sta	kz_tpx
	lda.l	SOS1_target_shape_B,x
	sta	kz_tpy
	RESTORENASTY
	jsr	eg_states	;(For Eguchi's States)

	lda	sos_rnd_offset
	inc	a
	and	#127
	sta	sos_rnd_offset
	km_setval.w	mmx_enattackpo,sos_zacoatpo,y

	a16
	km_setflag16	kw_mmsoundflag,mmsndf_sosappear

;* collision *
	km_setval.w	mmx_encoll,zaco_collision,y
	brl	.end
;-----------------------------------------------------------------------
.Planet	;(Missile)
	longa
	inc	kx_missilecurrent
	lda	#50
	sta.w	mmx_enwaittm,y			;Demo Animation Timer

	lda	#0
	sta.w	mmx_envelx,y	;velocity X
	lda	#-sos_appearspeed*2
	sta.w	mmx_envely,y	;velocity Y

	lda	kdifficulty
	asl	a
	tax
	lda.l	missiletable,x
	clc
	adc	miss_rnd_offset
	tax
	jsl	eg_sosskill_l

	lda	miss_rnd_offset
	inc	a
	and	#$f
	sta	miss_rnd_offset

	lda	#stg_sos2
	sta.w	mmx_enstage,y

	km_setval.w	mmx_entype,entyp_missile,y
	km_setval.w	mmx_enattackpo,sos_misatpo,y

	a16
	km_setval.w	mmx_enangY,0,y
	km_setflag16.w	mmx_enflags,enfl_missile,y
	km_setflag16	kw_mmsoundflag,mmsndf_missileappear

;* collision *
	km_setval.w	mmx_encoll,mis_collision,y
	brl	.end
;-----------------------------------------------------------------------
	longa
	longi
.Virus	;(Virus)
	km_setval.w	mmx_ensequence,enseq_virusmove,y
	km_setval.w	mmx_enstage,stg_sos2,y	;mission stage
	km_setflag16.w	mmx_enflags,enfl_virus,y
	km_clrflag16.w	mmx_enflags,enfl_nocollision,y
	km_setval.w	mmx_entype,entyp_virus,y
	km_setval.w	mmx_envel,sos_virussp,y
	km_setval.w	mmx_encoll,vir_collision,y

	jsl	calc_enangvelxy_l

	ldx	#VIRUS_SKILL-EASY_MISS_RAND
	jsl	eg_sosskill_l

;-----------------------------------------------------------------------
.end
	lda.w	mmx_entype,y
	asl	a
	tax
	lda.l	sosbittbl,x
	sta	mmx_sosappear	;(for yajima's message)

	PLX
	rts

;=====================================================================
;*		Set Eguchi's Target States			*
;* Input :Xreg :Enemy Skill Ptr					*
;=====================================================================
eg_sosskill_l
	php
	a8
	km_hib0
	STORENASTY
	NASTYOFF
	lda.l	easy_miss_rand,x
	sta.w	mmx_enskill,y
	tax
	lda.l	SOS2_target,x
	sta	kz_tpa
	lda.l	SOS2_target_shape_A,x
	sta	kz_tpx
	lda.l	SOS2_target_shape_B,x
	sta	kz_tpy
	RESTORENASTY
	NASTYON
	jsr	eg_states	;(For Eguchi's States)
	plp
	rtl
;---------------------------------------------------------------------
;*		Set KEnemy Number States			*
;*        :a8i16							*
;* Input  :kz_x1,kz_y1,kz_z1						*
;* Temp   :kz_x1							*
;---------------------------------------------------------------------
;* KEnemy Number List (For Eguchi's) *
eg_states_l
	php
	a8
	jsr	eg_states
	plp
	rtl

eg_states
	shorta
	longi
;* stack *
	jsr	mm_setenstack
	sta.w	mmx_enstackptr,y	;(0,1,2,3,...,14,15)
	tax

	lda	kz_tpx
	sta.w	EEnemyShapeA_0,x
	lda	kz_tpy
	sta.w	EEnemyShapeB_0,x

	lda	kz_tpa
	sta.w	EEnemyNumber_0,x
	jsr	kconv_zacokazu
	sta.w	mmx_enkazu,y	;enemy no kazu

	a16
	txa
	asl	a
	tax
	stz.w	sebangoSwitch_0,x
	a8
	rts

;*********************************************************************
;*		Get Enemy States Free Area			*
;* OutPut :Acc  <<< Stack Pointer					*
;* Keep   :Yreg <<< Enemy List Pointer				*
;*        :Xreg							*
;*********************************************************************
mm_setenstack_l
	jsr	mm_setenstack
	rtl

mm_setenstack
	phx
	php
	a8
	longi
;* debug Initial*
	ifne	debuginfo
	lda	#16
	sta	kz_x1
	endc
;--------------------------------------
;* Search Stack Empty Buffer *
	km_hib0
	ldx	kx_stackbaseptr	;(0~15)
.loop_search
	lda	kx_stackbuffer,x
	beq	.found_emptybox
;* debug *
	ifne	debuginfo
	dec	kz_x1
	km_beq	mm_blink3
	endc

	txa
	inc	a
	and	#$f
	tax
	bra	.loop_search
;--------------------------------------
.found_emptybox
	shorta
	inc	a
	sta	kx_stackbuffer,x	;Buffer Using Flag ON
	stx	kx_stackbaseptr

	a16
	txa				;Out Put
	a8

	plp
	plx
	rts

;---------------------------------------------------------------------
;*		Convert Zaco Enemy Kazu				*
;* Init   : Acc :zaco enemy base number data				*
;* OutPut : Acc :zaco enemy no kazu					* 
;* Temp: kz_x1							*
;---------------------------------------------------------------------
kconv_zacokazu
	shorta
	longi
	pha
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	kz_x1
	pla
	and	#$0f
	clc
	adc	kz_x1
	rts
;-----------------------------------------------------------------------
missiletable
	dw	easy_miss_rand-easy_miss_rand
	dw	norm_miss_rand-easy_miss_rand
	dw	hard_miss_rand-easy_miss_rand

;=====================================================================
;*			Set Planet Skill Level			*
;* Input  :Xreg :Planet List Pointer					*
;* Memo   :Yreg Keep							*
;*        :a16i16							*
;=====================================================================
	IFEQ	1
ksetplanetskill_l
	phy		;>>> PUSH Y
	PHP
	a8
;* planet skill *
	TXY		;>>> Push Planet Pointer
	ldx	pl_rnd_offset
	STORENASTY
	ROMNASTYOFF
	lda.l	planet_random,x	;(eguchi's plaent random table)
	sta	kz_x1		;(number = 0~7)
	RESTORENASY
	TYX		;<<< Pull Planet Pointer

;	lda.w	mmx_stagecnt,x
	lda	#0
	sta	kz_tpa

	lda	pl_rnd_offset
	inc	a
	and	#127
	sta	pl_rnd_offset	;(next random pointer)

	ldy	kdifficulty
	cpy	#dif_hard
	beq	.hard
.easy_normal
	lda	kz_tpa
	beq	.skill_a
	dec	a
	beq	.skill_b
	bra	.skill_c
.hard
	lda	kz_tpa
	beq	.skill_b
	dec	a
	beq	.skill_c
	bra	.skill_d
.skill_a
	lda	kz_x1
	and	#%11
	bra	.setskill
.skill_b
	lda	kz_x1
	and	#%11
	clc
	adc	#4
	bra	.setskill
.skill_c
	lda	kz_x1
	and	#%111
	clc
	adc	#5
	bra	.setskill
.skill_d
	lda	kz_x1
	and	#%11
	clc
	adc	#9

	PLP
	ply		;<<< PULL Y
	rtl
	ENDC


	IFEQ	1		;(1994/12/21)
	ldx	kdifficulty
	lda.l	planetskilloff,x
	km_loba
	tax
; Input  :Xreg :warukazu
	jsl	KGetRandomValue_l	;(irq.asm)
; OutPut : Acc
; easy   : 0~3
; normal : 0~7
; hard   : 0~12
	a8
	plx		;<<< PULL X
	ENDC

.setskill
	sta.w	mmx_planetskill,x

;	cmp	#3
;	beq	.missilebase
;	cmp	#7
;	beq	.missilebase
;	cmp	#11
;	bne	.notmissilebase
;.missilebase
;	km_setflag16.w	mmx_planetflag,mmpnf_missilebase,x
;.notmissilebase
;* Stage Level Up *
;1995/1/25
;	inc.w	mmx_stagecnt,x

;* Planet Stack Pointer * 
;	jsr	mm_setenstack
;	sta.w	mmx_plstackptr,x

;*********************************************************************
;*								*
;*		Enemy Collision Check				*
;* data bank :7e							*
;* Return :ai16							*
;*********************************************************************
	longa
	longi
mm_sosenemycollision
;* flag clear *
	km_clrmismapflag	attackcorneria

	ldy	kx_enlistptr
	beq	.end	;No Enemy
.LOOP
	jsr	mm_sosenemycollision_sub

.nextenemycheck
	lda.w	mmx_ennext,y
	beq	.end
	tay
	bra	.LOOP
.end
	rts

;=====================================================================
;*			Collision Check Sub			*
;=====================================================================
	longa
	longi
mm_sosenemycollision_sub

;**** collision check ****
	km_bitcheckflag.w	mmx_enflags,(enfl_nocollision!enfl_invisible),y
	beq	.check_coll
	rts

;*****************************************************
;*						*
;*	Player tono Battle Collision Check 	*
;*						*
;*****************************************************
	longa
	longi
.check_coll
	km_bitcheckflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	bne	.Disable_PlCollisionCheck

	lda.w	mmx_eninvtm,y
	beq	.check_enable
	dec	a
	sta.w	mmx_eninvtm,y
	bra	.Disable_PlCollisionCheck
.check_enable
	km_loblda.w	mmx_encoll,y
	sta	kz_z2
	jsr	CollEnemytoPlayer
	bcc	.Disable_PlCollisionCheck

;****   Mission Start   ****
.ENCOUNTPlayer
	sty	kx_SOSEnemyptr	;enemy pointer keep
	jsr	battleplayer_sub
	km_setflag16.w	mmx_enflags,(enfl_encountplayer!enfl_nocollision),y
	km_setflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll!kmimpf_enemylist)
	km_setflag16	kw_mismapfreezeflag,kfz_battlefreeze	;[stratage off]
	km_setmismapsyori	missionstart
	jsr	EnemyBGCheck
	sta	kx_NearPlanetNum	;Haikei no Number Set
	brl	.nextenemycheck
.Disable_PlCollisionCheck

;*****************************************************
;*						*
;*	Wolf Rannyuu Check			*
;*						*
;*****************************************************
	longa
	longi
	km_bitcheckmismapflag2	rannyuenable
	beq	.NoCheck_Rannyu		;rannyu kyoka ari ?
	bit	#kmimpf2_rannyutrig
	bne	.NoCheck_Rannyu		;rannyu trig ari ?

	km_bitcheckflag16.w	mmx_enflags,(enfl_wolf),y
	beq	.NoCheck_Rannyu		;wolf team ?
	bit	#enfl_encountplayer
	bne	.NoCheck_Rannyu		;player to battle tyuu ?

	km_loblda.w	mmx_encoll,y
	sta	kz_z2
	jsr	CollEnemytoPlayer
	bcc	.NoCheck_Rannyu

	km_setmismapflag2	rannyutrig
	km_setval	RannyuModeSwitch,1

	a8
	lda.w	mmx_enwolfnum,y
	sta	StarWolfNo
	a16

	sty	kx_RannyuEnemyptr
	lda.w	mmx_enstratptr,y
	sta	kx_RannyuStratptr
	lda.w	mmx_ensequence,y
	sta	kx_RannyuSeqPtr
	km_setval.w	mmx_enstratptr,enstrat_nothing,y
	km_setval.w	mmx_ensequence,enseq_nothing,y

.NoCheck_Rannyu
;*****************************************************
;*						*
;*     Corneria ni touchyaku shitak douka no check 	*
;*						*
;*****************************************************
	longa
	longi
.Check_CorneriaArrive
	km_memchecka16
	km_clrflag16.w	mmx_enflags2,enfl2_asteroid,y
	km_clrflag16.w	mmx_enflags,enfl_arrive,y

	jsr	EnemyBGCheck
	cmp	#bgchk_corneria
	beq	.arrive_sos
	cmp	#bgchk_cannon
	beq	.arrive_battleship

;* Hit Asteroid Check *
	cmp	#bgchk_Asteroid
	bne	.not_asteroid
	km_setflag16.w	mmx_enflags2,enfl2_asteroid,y

.not_asteroid
	bra	.nextenemycheck
;--------------------------------------------------------------------------------------------------
	LONGA
;* SOS Enemy ga Corneria ni Touchaku *
.arrive_sos
	km_bitcheckflag16.w	mmx_enflags,(enfl_encountplayer),y
	bne	.nextenemycheck
	bit	#(enfl_zaco!enfl_missile!enfl_special)
	beq	.nextenemycheck

	jsr	attackcorneria_sub
	bra	.nextenemycheck
;----------------------------------------------------------------------
;* Senkan ga Mokutekichi ni Touchaku *
.arrive_battleship
	LONGA
	km_bitcheckflag16.w	mmx_enflags,enfl_battleship,y
	beq	.nextenemycheck
	km_setflag16.w	mmx_enflags,enfl_arrive,y
;----------------------------------------------------------------------
.nextenemycheck
	rts

;--------------------------------------------
	IFEQ	1
.special
	km_bitcheckflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	bne	.set_flag	;player ga sentou tyuu

;* MAP tyuu *
	km_bitcheckflag16.w	mmx_enflags,(enfl_attackcorneria),y
	beq	.skip111
	km_clrflag16.w	mmx_enflags,(enfl_arrive!enfl_attackcorneria),y
	km_setval.w	mmx_enwaittm,1,y
.skip111
	bra	.nextenemycheck
	ENDC
;---------------------------------------------------------------------
;*								*
;*			Attack Corneria				*
;*								*
;---------------------------------------------------------------------
	longa
	longi
attackcorneria_sub
	km_bitcheckflag16.w	mmx_enflags,enfl_special,y
	bne	.taiman
	km_bitcheckflag.w	mmx_enflags,enfl_attackcorneria,y
	km_bne	.always_setflag
	km_bitcheckflag16.w	mmx_enflags,enfl_missile,y
	bne	.missile
;----------------------------
.zaco
;;;;	km_setval.w	mmx_ensequence,enseq_attackcorneria,y
	km_setval.w	mmx_enwaittm,1,y	;corneria no mawari wo mawaru time

	km_setval.w	mmx_enwork1,$400,y		;angel step
	km_setval.w	mmx_envel,sos_aroundspeed,y	;around speed
	jsr	init_turn

	km_loblda.w	mmx_enposx+1,y
	sta.w	mmx_endestx,y

	km_loblda.w	mmx_enposy+1,y
	sta.w	mmx_endesty,y

;* message *
	km_bitcheckmismapflag	returnmap
	beq	.nozacomes
	km_setflag16	mmx_message_sos,mesosfl_zacoattack	;[for yajima's]
.nozacomes
	bra	.always_setflag
;----------------------------
.missile
	km_bitcheckmismapflag	returnmap
	bne	.mission
.map
	jsl	kmissilefell_sub_l	
	bra	.always_setflag
.mission
	km_setflag16	mmx_message_sos,mesosfl_missileattack	;[for yajima's]
	km_setmismapflag	attackcorneria	;corneria kougeki tyuu
	jsr	SetAttackPoint
	jsl	mm_freeenemylistptr_l
	rts

;;	km_setval.w	mmx_ensequence,enseq_disappear,y
;;	bra	.always_setflag
;----------------------------
.taiman
	km_bitcheckmismapflag	returnmap
	beq	.always_clrflag	;[map tyuu]
.taiman_mission
	km_bitcheckflag.w	mmx_enflags,enfl_attackcorneria,y
	bne	.always_setflag
	km_setflag16	mmx_message_sos,mesosfl_zacoattack	;[for yajima's]
;-----------------------------
.always_setflag	;(corneria ni irutoki wa itumo set)
	km_setflag16.w	mmx_enflags,(enfl_attackcorneria!enfl_arrive),y	;trigger
	km_setmismapflag	attackcorneria	;corneria kougeki tyuu
	rts
;-----------------------------
.always_clrflag
;moshi corneria kara ridatu shitara
	km_clrflag16.w	mmx_enflags,enfl_attackcorneria,y
	rts

;-------------------------------------------------------------
;*							*
;*		battle player				*
;*							*
;-------------------------------------------------------------
	longa
	longi
battleplayer_sub
	km_bitcheckflag16.w	mmx_enflags,(enfl_battleship!enfl_itemplanet),y
	bne	.not_clear
	lda	#0
	sta.w	mmx_enanmpatt,y
	sta.w	mmx_enanmtm,y
.not_clear
	lda.w	mmx_ensequence,y
	sta.w	mmx_ensequence_bak,y
	lda.w	mmx_enstratptr,y
	sta.w	mmx_enstratptr_bak,y

	km_bitcheckflag16.w	mmx_enflags,(enfl_battleship),y
	bne	.battleship

	lda	#enstrat_nothing	;battleplayer
	sta.w	mmx_enstratptr,y
	lda	#enseq_nothing		;battleplayer
	sta.w	mmx_ensequence,y
	rts
.battleship
	lda	#enstrat_nothing	;battleplayer
	sta.w	mmx_enstratptr,y
	lda	#bsseq_battleplayer
	sta.w	mmx_ensequence,y
	rts
;-------------------------------------------------------------
;*							*
;*		Enemy BG Check				*
;*							*
;-------------------------------------------------------------
EnemyBGCheck
	km_loblda.w	mmx_enposx+1,y
	sta	kz_x1
	km_loblda.w	mmx_enposy+1,y
	sta	kz_y1
	jsr	mm_BGCheck
	RTS
;----------------------------------------------------------------------
	IFEQ	1
;* always asteroid check flag clear *
	km_clrflag16.w	mmx_enflags,enfl_asteroid,y
	km_loblda.w	mmx_enposx+1,y
	sta	kz_x1
	km_loblda.w	mmx_enposy+1,y
	sta	kz_y1
	jsr	mm_BGCheck

.Asteroid_Check
	cmp	#$70
	bcs	.NoHitBG
	cmp	#$6a
	bcc	.Defence_Check
	km_setflag16.w	mmx_enflags,enfl_asteroid,y
.Defence_Check
	cmp	#$67
	bcs	.NoHitBG
	cmp	#$60
	bcs	.Defence2
	cmp	#$50
	bcs	.Defence1
	bra	.NoHitBG
.Defence1
	km_bitcheckflag.w	mmx_enflags,enfl_stepup,y
	bne	.NoHitBG
	km_bitcheckflag.w	mmx_enflags,enfl_defence1,y
	bne	.NoHitBG
	km_setflag16.w	mmx_message_sos,mesosfl_defence1
	km_setflag16.w	mmx_enflags,enfl_defence1,y
	bra	.NoHitBG

;******* Saisyuu Bouei Line ********
.Defence2
	km_bitcheckflag.w	mmx_enflags,(enfl_stepup!enfl_defence2),y
	bne	.NoHitBG

	km_setflag16.w	mmx_message_sos,mesosfl_defence2
	km_setflag16.w	mmx_enflags,enfl_defence2,y
.NoHitBG
	ENDC

;*****************************************************
;*	 Search Enemy Check			*
;*****************************************************
	IFEQ	1
	LONGA
;***** Search Player Area IN Check ********
	km_clrflag16.w	mmx_enflags2,enfl2_SearchAreaIn,y
	km_bitcheckflag16	kw_mismapflag,(kmimpf_battleplayer!kmimpf_playernocoll)
	km_bne	.Disable_SearchPlayer
	km_bitcheckflag.w	mmx_enflags,(enfl_searchenemy),y
	beq	.Disable_SearchPlayer
	km_bitcheckflag.w	mmx_enflags,enfl_defence2,y
	bne	.Disable_SearchPlayer
	lda	#sos_plsearchcoll
	sta	kz_z2
	jsr	CollEnemytoPlayer
	bcc	.Disable_SearchPlayer
	km_setflag16.w	mmx_enflags2,enfl2_SearchAreaIn,y
;* enmey ga muteki no jyoutai dattara player tono atari naishi *
.Disable_SearchPlayer
	ENDC


;*************************************
;*	Search Enemy Dest	*
;*************************************
	IFEQ	1
	a16
	km_bitcheckflag16.w	mmx_enflags,enfl_special,y
	bne	.search_player
	km_bitcheckflag16.w	mmx_enflags,enfl_searchenemy,y
	beq	.search_skip
	km_bitcheckflag16.w	mmx_enflags2,enfl2_SearchAreaIn,y
	beq	.search_planet
.search_player
	jsr	mm_playerdest

	km_setval.w	mmx_envel,sos_zacosp3_easy,y
	km_bitcheckflag16.w	mmx_enflags,enfl_special,y
	beq	.search_skip
	km_setval.w	mmx_envel,sos_specialsp,y
	bra	.search_skip
.search_planet
	lda.w	mmx_endestplanetptr,y
	tax
	km_setval.w	mmx_envel,sos_zacosp1_easy,y
	jsr	mm_enemydest
.search_skip
	ENDC

;*********************************************************************
;*								*
;*			Enemy Move				*
;*								*
;*********************************************************************
	longa
	longi
mm_enemydemosequence_l
	km_loblda.w	mmx_ensequence,y
	asl	a
	tax
	jsr	(ksostbl,x)
	rtl
;---------------------------------------------------------------------
	longa
	longi
mm_enemydemomove_l
	km_ldasla.w	mmx_enstratptr,y
	tax
	jsr	(enemymovetbl,x)
	rtl
;---------------------------------------------------------------------
	longa
	longi
mm_enemydemoseqmove_l
	km_loblda.w	mmx_ensequence,y
	asl	a
	tax
	jsr	(ksostbl,x)

	km_ldasla.w	mmx_enstratptr,y
	tax
	jsr	(enemymovetbl,x)
	rtl
;---------------------------------------------------------------------
	longa
	longi
mm_enemydemoseqmovecoll_l
;* sequence *
	km_loblda.w	mmx_ensequence,y
	asl	a
	tax
	jsr	(ksostbl,x)
;* move *
	km_ldasla.w	mmx_enstratptr,y
	tax
	jsr	(enemymovetbl,x)

;* collision *
	jsr	mm_sosenemycollision_sub
	rtl
;---------------------------------------------------------------------
	longa
	longi
mm_sosenemymove

	ldy	kx_enlistptr
	km_beq	.end
.loop
;* Enemy Move *
	km_ldasla.w	mmx_enstratptr,y
	tax
	jsr	(enemymovetbl,x)
.nextenemycheck
	longa
	longi
	lda.w	mmx_ennext,y
	beq	.end
	tay
	brl	.loop
.end
	rts

;---------------------------------------------------------------------
;*			Data Table				*
;---------------------------------------------------------------------
enemymovetbl
	dw	enmv_nothing&WM
	dw	enmv_straight&WM
	dw	enmv_angvel&WM
	dw	enmv_posvel&WM
	dw	enmv_turn&WM
	dw	enmv_hachinoji&WM
	dw	enmv_spin&WM
	dw	enmv_chase&WM
	dw	enmv_scurve&WM
;=====================================================================
;*			Not Move				*
;=====================================================================
	longa
	longi
enmv_nothing
	rts
;=====================================================================
;*			Go Straight				*
;* (mmx_envelx,mmx_envely) de idou ga kimaru !!			*
;=====================================================================
	longa
	longi
enmv_straight
;* enemy velocity calc *
;	jsr	en_speedupmode
	brl	Setenemypostion

;=====================================================================
;*		 Around Planet					*
;=====================================================================
	longa
	longi
enmv_turn
	lda.w	mmx_enangY,y
	clc
	adc.w	mmx_enwork1,y
	sta.w	mmx_enangY,y
	brl	enmv_angvel
;----------------------------------------
	longa
	longi
init_turn
	lda.w	mmx_enposy,y
	cmp	#($13*8)<<8
	bmi	.skip_angle
	lda.w	mmx_enwork1,y
	km_nega
	sta.w	mmx_enwork1,y
.skip_angle
	km_clrmismapstflag	speedup			;speedup nashi
	km_setval.w	mmx_enstratptr,enstrat_turn,y	;battleplayer,y
	rts
;=====================================================================
;*			8 noji Move				*
;* Angle to Angle Step ni Chyuui !! Initial de AND shiteoku !!	*
;=====================================================================
	longa
	longi
enmv_hachinoji
	km_bitcheckflag.w	mmx_enflags2,enfl2_hachinoji,y
	bne	.sub_angle
.add_angle
	lda.w	mmx_enangY,y
	clc
	adc.w	mmx_enwork1,y
	sta.w	mmx_enangY,y
	bne	.Set_pos
	bra	.change_sign
.sub_angle
	lda.w	mmx_enangY,y
	sec
	sbc.w	mmx_enwork1,y
	sta.w	mmx_enangY,y
	bne	.Set_pos
.change_sign
	km_eorflag.w	mmx_enflags2,enfl2_hachinoji,y
.Set_pos
	brl	enmv_angvel

;=====================================================================
;*			Enter Planet				*
;=====================================================================
	longa
	longi
enmv_spin
	lda.w	mmx_enwork1,y
	clc
	adc	#$80
	sta.w	mmx_enwork1,y

	lda.w	mmx_enangY,y
	clc
	adc.w	mmx_enwork1,y
	sta.w	mmx_enangY,y
	brl	Setenemypostion_Normal

;=====================================================================
;*			Chase Planet				*
;* Yreg :Enemy  List Pointer	(Break)					*
;*      :mmx_work1 :rotation step					*
;=====================================================================
	longa
	longi
enmv_chase
	lda.w	mmx_enwaittm,y
	beq	.NoaddangY
	dec	a
	sta.w	mmx_enwaittm,y

	lda.w	mmx_enangY,y
	clc
	adc.w	mmx_enwork1,y
	sta.w	mmx_enangY,y
.NoaddangY
	brl	enmv_angvel
;---------------------------------------------------------------------
;*		Get Chase Planet Params				*
;* Yreg :Enemy  List Pointer	(Break)					*
;* In Put :mmx_enwork1  :chase step (angle)				*
;* OutPut :mmx_enwaittm :chase counter				*
;---------------------------------------------------------------------
	longa
	longi
init_chaseparams8
	jsr	calc_enangle
	sec
	sbc.w	mmx_enangY,y
	bit	#$8000
	beq	.skip
	eor	#-1
	inc	a
.skip
	and	#$ff00
	xba
	sta	kz_x1		;Chase Angle

	lda.w	mmx_enwork1,y
	xba
	sta	kz_y1
	jsl	kdivu16u8_l
	sta.w	mmx_enwaittm,y	;Chase Count
	rts
;---------------------------------------------------------------------
	longa
	longi
init_chaseparams16
	ldx	#0
	jsr	calc_enangle
	sec
	sbc.w	mmx_enangY,y
	bit	#$8000
	beq	.skip
	eor	#-1
	inc	a
	dex
.skip
	sta	kz_wkdividend_L	;Chase Angle
	stz	kz_wkdividend_H

	phy
	lda.w	mmx_enwork1,y
	tay
	jsl	KDivide_u32u16_l
	ply

	lda.w	mmx_enwork1,y
	cpx	#0
	bpl	.skip2
	eor	#-1
	inc	a
.skip2
	sta.w	mmx_enwork1,y


	lda	kz_wkdividend_L
	sta.w	mmx_enwaittm,y	;Chase Count
	rts

;=====================================================================
;*			S Curve					*
;=====================================================================
	longa
	longi
enmv_scurve
	lda.w	mmx_enangY,y
	clc
	adc.w	mmx_enwork2,y
	sta.w	mmx_enangY,y

	lda.w	mmx_enwork3,y
	dec	a
	sta.w	mmx_enwork3,y
	km_bne	enmv_angvel

	jsr	init_chaseparams16
	km_setval.w	mmx_enstratptr,enstrat_chase,y
	rts
;=====================================================================
;*			Player Search				*
;* Input :Source (x,y),Dest (x,y),Velocity				*
;=====================================================================
	longa
	longi
enmv_posvel
	jsr	calc_enangvelxy
;	jsr	en_speedupmode
	brl	Setenemypostion

;=====================================================================
;*		Normal Move					*
;* Input :AngleY,Velocity						*
;=====================================================================
	longa
	longi
enmv_angvel
	jsr	calc_envelxy24
;	jsr	en_speedupmode
	brl	Setenemypostion

;=====================================================================
;*			Sin Curve				*
;* Input :AngleY,Velocity						*
;=====================================================================
	IFEQ	1
	longa
	longi
init_sincurve
	lda.w	mmx_envely,y
	sta.w	mmx_work1,y
	rts

	longa
	longi
enmv_sincurve
	ENDC
;---------------------------------------------------------------------
;*			Easy Search Move			*
;---------------------------------------------------------------------
	IFEQ	1
	longa
	longi
enmv_easysearch
	PHX
	ldx	#0

	km_loblda.w	mmx_enposx+1,y
	cmp.w	mmx_endestx,y
	bne	.skip1
	inx
	bra	.checky
.skip1
	bpl	.rightX
.leftx
	lda.w	mmx_enposx,y
	clc
	adc	#$0060
	bra	.setx
.rightx
	lda.w	mmx_enposx,y
	sec
	sbc	#$0060
.setx
	sta.w	mmx_enposx,y
.checky
	km_loblda.w	mmx_enposy+1,y
	cmp.w	mmx_endesty,y
	bne	.skip2
	inx
	cpx	#2
	bne	.end
	bra	.finish
.skip2
	bpl	.righty
.lefty
	lda.w	mmx_enposy,y
	clc
	adc	#$0060
	bra	.sety
.righty
	lda.w	mmx_enposy,y
	sec
	sbc	#$0060
.sety
	sta.w	mmx_enposy,y
.end
	clc
	PLX
	rts
.finish
	sec
	plx
	rts
	ENDC
;=====================================================================
;*			Around Planet 				*
;* Temp Work  : 							*
;=====================================================================
enmv_aroundplanet_l
	jsr	enmv_turn
	rtl
;=====================================================================
;*			Move Planet Search			*
;* Temp Work  : 							*
;=====================================================================
enmv_searchplanet_l
	jsr	enmv_straight
	rtl

;=====================================================================
;*			Enemy Postion Main Set			*
;* Init :velocity (mmx_spx_dec,mmx_spx_int)				*
;=====================================================================
Setenemypostion_l
	jsr	Setenemypostion
	rtl
;---------------------------------------------------------------------
	LONGA
	LONGI
Setenemypostion
	km_bitcheckmismapstflag	speedup
	bne	Setenemypostion_SpeedUp
;-------------------------------------------------------------
;*		Normal Speed Mode			*
;-------------------------------------------------------------
Setenemypostion_Normal
.SetXpos
	lda.w	mmx_envelx_l,y
	clc
	adc.w	mmx_enposx_l,y
	sta.w	mmx_enposx_l,y

	a8
	lda.w	mmx_envelx_l+2,y
	adc.w	mmx_enposx_l+2,y
	cmp	#screen_leftedge
	bcc	.Skip_SetXpos
	cmp	#screen_rightedge
	bcs	.Skip_SetXpos
	sta.w	mmx_enposx_l+2,y
.Skip_SetXpos
;-----------------------------------------
.SetYpos
	a16
	lda.w	mmx_envely_l,y
	clc
	adc.w	mmx_enposy_l,y
	sta.w	mmx_enposy_l,y

	a8
	lda.w	mmx_envely_l+2,y
	adc.w	mmx_enposy_l+2,y
	cmp	#screen_topedge
	bcc	.Skip_SetYpos
	cmp	#screen_bottomedge
	bcs	.Skip_SetYpos
	sta.w	mmx_enposy_l+2,y
.Skip_SetYpos
;-----------------------------------------
.end
	a16
	rts
;-------------------------------------------------------------
;*			Speed Up Mode			*
;-------------------------------------------------------------
	longa
	longi
Setenemypostion_SpeedUp
;* vel X *
	km_sexvar.w	mmx_envelx_l+2,y
	sta	kz_textpt+2
	lda.w	mmx_envelx_l,y
	sta	kz_textpt+0

	jsl	kspeedup3_l		;*8 or &16

	km_setvar	mmx_spx_dec,kz_textpt+0
	a8
	km_setvar	mmx_spx_int,kz_textpt+2
	a16	
;* vel Y *
	km_sexvar.w	mmx_envely_l+2,y
	sta	kz_textpt+2
	lda.w	mmx_envely_l,y
	sta	kz_textpt+0

	jsl	kspeedup3_l		;*8 or &16

	km_setvar	mmx_spy_dec,kz_textpt+0
	a8
	km_setvar	mmx_spy_int,kz_textpt+2

	a16
	lda	mmx_spx_dec
	clc
	adc.w	mmx_enposx_l,y
	sta.w	mmx_enposx_l,y
	a8
	lda	mmx_spx_int
	adc.w	mmx_enposx_l+2,y
	cmp	#screen_leftedge
	bcc	.checkY
	cmp	#screen_rightedge
	bcs	.checky
	sta.w	mmx_enposx_l+2,y
.checkY
	a16
	lda	mmx_spy_dec
	clc
	adc.w	mmx_enposy_l,y
	sta.w	mmx_enposy_l,y
	a8
	lda	mmx_spy_int
	adc.w	mmx_enposy_l+2,y
	cmp	#screen_topedge
	bcc	.end
	cmp	#screen_bottomedge
	bcs	.end
	sta.w	mmx_enposy_l+2,y
.end
	a16
	rts


;=====================================================================
;*			Speed UP				*
;* Init	:Acc							*
;*	:mmw_speedup = *8					*
;* OutPut	:Acc							*
;=====================================================================
kspeedupA_l
	longa
	longi
	pha
	km_bitcheckmismapstflag	speedup
	beq	kspeedupA_end
	pla
	asl	a	;*4
	asl	a
;	asl	a
	rtl
;------------------------------------------------------------------------
kspeedupA_end
	pla
	rtl

;=====================================================================
;*			Speed Up				*
;* Init	:kz_textpt (32 bit) 					*
;* OutPut	:kz_textpt (32 bit)					*
;=====================================================================
kspeedup3_l
	longa
	longi
	km_bitcheckmismapstflag	speedup
	bne	kspeedup_sub
kspeedup_end
	rtl

kreplayspeedup_sub
kspeedup16_l
;*16
 	asl	kz_textpt
	rol	kz_textpt+2
kspeedup_sub
kspeedup8_l
;*8
	asl	kz_textpt
	rol	kz_textpt+2

kspeedup4_l
;*4
	asl	kz_textpt
	rol	kz_textpt+2

	IFEQ	1
kspeedup2_l
;*2
	asl	kz_textpt
	rol	kz_textpt+2
	ENDC

	rtl


;=====================================================================
;*			Speed Down				*
;* Init	:kz_textpt (32 bit) 					*
;* OutPut	:kz_textpt (24 bit)					*
;=====================================================================
	IFEQ	1
gamespeed_l
	longa
	longi
	km_bitcheckmissionflag	parallel
	bne	kspeedup_end
kspeeddown8
;/8
	lsr	kz_textpt+2
	ror	kz_textpt+0
kspeeddown4
;/4
	lsr	kz_textpt+2
	ror	kz_textpt+0
kspeeddown2
;/2
	lsr	kz_textpt+2
	ror	kz_textpt+0
	rtl
	ENDC
;------------------------------------------------------------------------
asteroidspeed_l
	longa
	longi
;	km_bitcheckflag16.w	mmx_enflags,enfl_asteroid,y
;	beq	kspeedup_end
;	bra	kspeeddown8
;=====================================================================
;*			Speed UP CHECK				*
;* OutPut :								*
;* Tmp Work :kz_textpt (4 byte)					*
;=====================================================================
	IFEQ	1
	longa
	longi
en_speedupmode
	km_bitcheckmismapstflag	speedup
	bne	.SpeedUp
;---------------------------------------------------------------------
.Normal
	lda.w	mmx_envelx_l+2,y
	sta	mmx_spx_int
	lda.w	mmx_envely_l+2,y
	sta	mmx_spy_int

	lda.w	mmx_envelx_l,y
	sta	mmx_spx_dec
	lda.w	mmx_envely_l,y
	sta	mmx_spy_dec
	rts
;---------------------------------------------------------------------
.SPeedUp
;* vel X *
	km_sexvar.w	mmx_envelx_l+2,y
	sta	kz_textpt+2
	lda.w	mmx_envelx_l,y
	sta	kz_textpt+0

	jsl	kspeedup3_l		;*8 or &16

	km_setvar	mmx_spx_dec,kz_textpt+0
	a8
	km_setvar	mmx_spx_int,kz_textpt+2
	a16	
;* vel Y *
	km_sexvar.w	mmx_envely_l+2,y
	sta	kz_textpt+2
	lda.w	mmx_envely_l,y
	sta	kz_textpt+0

	jsl	kspeedup3_l		;*8 or &16

	km_setvar	mmx_spy_dec,kz_textpt+0
	a8
	km_setvar	mmx_spy_int,kz_textpt+2
	a16	
	rts
	ENDC

;=============================================================================
;*									*
;*			 BG Check					*
;* data bank :7e								*
;* Init :kz_x1 :x postion							*
;*      :kz_y1 :y postion							*
;* Out  :Acc   :Character No							*
;=============================================================================
mm_BGCheck_l
	jsr	mm_BGCheck
	rtl
mm_BGCheck
	longa
	longi
	km_convVRAMSCRaddr_256	kz_x1,kz_y1
	PHX
	tax
	km_loblda.l	BGCheckBuffer,x
	PLX
	rts

;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------

	IFEQ	1
	longa
	longi
Setenemypostion
	a16
	lda	mmx_spx_dec
	clc
	adc.w	mmx_enposx_l,y
	sta.w	mmx_enposx_l,y

	a8
	lda	mmx_spx_int
	adc.w	mmx_enposx_l+2,y
	cmp	#screen_leftedge
	bcc	.checkY
	cmp	#screen_rightedge
	bcs	.checky
	sta.w	mmx_enposx_l+2,y
.checkY

	a16
	lda	mmx_spy_dec
	clc
	adc.w	mmx_enposy_l,y
	sta.w	mmx_enposy_l,y
	a8
	lda	mmx_spy_int
	adc.w	mmx_enposy_l+2,y
	cmp	#screen_topedge
	bcc	.end
	cmp	#screen_bottomedge
	bcs	.end
	sta.w	mmx_enposy_l+2,y
.end
	a16
	rts

	ENDC

;=====================================================================
;*		Calculation Enmy Angle				*
;* Yreg :Enemy List Pointer						*
;* Out Put :Acc							*
;=====================================================================
	longa
	longi
calc_enangle
	km_hibswaplda.w	mmx_enposx,y
	sta	kz_x1
	km_hibswaplda.w	mmx_enposy,y
	sta	kz_y1
	km_loblda.w	mmx_endestx,y
	sta	kz_x2
	km_loblda.w	mmx_endesty,y
	sta	kz_y2
	jsl	calobjangle_l
	rts

;=====================================================================
;*		Calculation Enmy Velocity			*
;* Yreg :Enemy List Pointer						*
;=====================================================================
calc_enangvelxy_l
	jsr	calc_enangvelxy
	rtl
;---------------------------------------------------
calc_enangvelxy
;* calc angle *
;* entry:
;*	x1 : source postion x	16bit
;*	y1 : source postion y	16bit
;*	x2 : dest postion x	16bit
;*	y2 : dest postion y	16bit
;* exit:
;*	Acc: Angle :16 bit (0~$ffff) :HI byte = integer,LOW byte = decimal

	longa
	longi
	jsr	calc_enangle
	sta.w	mmx_enangY,y	;16 bit
;---------------------------------------------------------------------
;*								*
;*		Calculate Enemy Velocity (X,Y)	[24 bit]	*
;* ( jsr conv_velxy )						*
;* Used Work :kz_x1,kz_y1,kz_x2,kz_y2,kz_tpx,kz_tpy,kz_texpt		*
;---------------------------------------------------------------------
calc_envelxy24
	longa
	longi
	lda.w	mmx_envel,y
	km_nega
	sta	kz_x1			:enemy vel   (16 bit :(h) integer,(l) decimal
	lda.w	mmx_enangY+1,y		;(HI byte ha nandemo yoi)
	sta	kz_y1			:enemy angle (16 bit :(h) dummy,(l) integer

	jsr	conv_velxy
	lda	tpx
	sta.w	mmx_envelx_l,y
	lda	kz_textpt
	sta.w	mmx_envely_l,y

 	a8
	lda	tpx+2
	sta.w	mmx_envelx_l+2,y
	lda	kz_textpt+2
	sta.w	mmx_envely_l+2,y
	a16
	rts

;*** ue ni oitara dame !! ***
calc_envelxy24_l
	jsr	calc_envelxy24
	rtl
;---------------------------------------------------------------------
;*		Calculate Velocity (X,Y)			*
;* Input	:kz_x1	  :vel     :16 bit (integer 8bit,decimal 8bit)	*
;*	:kz_y1	  :angle   :16 bit HI byte ha NOT Use		*
;* OutPut	:kz_tpx	  :velx /8 :24 bit (integer 8bit,decimal 16bit)	*
;*	:kz_textpt:vely /8 :24 bit (integer 8bit,decimal 16bit)	*
;* Temp Work :kz_x2,kz_y2						*
;---------------------------------------------------------------------
conv_velxy_l
	jsr	conv_velxy
	rtl
conv_velxy
	phx
	phy
	longa
	i8
	lda	kz_y1
	clc
	adc	#$40
	tax
	km_sexvar.l	ramcostab,x
	sta	kz_x2
	km_sexvar.l	ramsintab,x
	sta	kz_y2
	i16
	ldy	kz_x2
	lda	kz_x1
	km_nega
	jsl	ML_s16s16_l
	sta	kz_tpx+2
	sty	kz_tpx

	ldy	kz_y2
	lda	kz_x1
	jsl	ML_s16s16_l
	sta	kz_textpt+2
	sty	kz_textpt

;/8 :motomoto kotae ga /2 dakara /4 de /8 shitakotoni naru!!
	lsr	kz_tpx+2
	ror	kz_tpx
	lsr	kz_tpx+2
	ror	kz_tpx
;/8
	lsr	kz_textpt+2
	ror	kz_textpt
	lsr	kz_textpt+2
	ror	kz_textpt

	ply
	plx
	rts
;---------------------------------------------------------------------
;*								*
;*		Calculate Enemy Velocity (X,Y)	[16 bit]	*
;* Used Work :kz_x1,kz_y1,kz_x2,kz_y2,kz_tpx,kz_texpt		*
;*								*
;---------------------------------------------------------------------
	IFEQ	0
calc_envelxy16
	longa
	longi
;* calc velx,vely *
;* entry:
;*	A  : Y angle	8bit
;*	x1 : dummy = 0	8bit
;*	y1 : velocity	8bit
;* exit:
;*	x2 : velocity x vector 16bit
;*	y2 : velocity y vector 16bit

	A8
	lda.w	mmx_envel,y
	sta	kz_y1
	stz	kz_x1
	lda.w	mmx_enangY+1,y
	jsl	rotate_8yx_l
	A16
	lda	kz_x2
	sta.w	mmx_envelx,y
	lda	kz_y2
	sta.w	mmx_envely,y
	rts
	ENDC
;----------------------------------------------------------------------------
;* Calculate Object Angle *
;* db = $7e
;* a16 i16
;* In   :source = (x1,y1),dest = (x2,y2)
;* Exit :Acc = Angle (16 bit) :0 to 359 degrees is $0000 to $ffff
;----------------------------------------------------------------------------
calobjangle_l
	php
	a16
	longi
;* zahyou set *
	km_substavarvar	x1,x2
	km_substavarvar	y1,y2

;* area check  (amari kyori ga chikasugiru to angle ga motomerarenai!!)*
;* dakra kyori ga chikasugiru tokino angle wa motomenai *
	IFEQ	1
	lda	x1
	bpl	.plasX1
	nega
.plasX1
	cmp	#16
	bpl	.calc_angle

	lda	y1
	bpl	.plasY1
	nega
.plasY1
	cmp	#16
	bmi	.chikasugi
	ENDC
;---------------------------------
;* angle wo motome ru *
.calc_angle
	jsl	arctan16_l
;---------------------------------
.chikasugi
	plp
	rtl


;=====================================================================
;*								*
;*		Enemy to Player tono Collision Check		*
;* Init :kz_x2 :collision Area					*
;=====================================================================
CollEnemytoPlayer
	longa
	longi
	km_loblda.w	mmx_arwingposx+1
	sta	kz_x1
	km_loblda.w	mmx_arwingposy+1
	sta	kz_y1
;* enemy postion *
;( sudeni maede set shiteiru params dakedo plannet arrive no tokini hituyou !!)
	lda.w	mmx_enposx,y
	km_hibswapa
	sta	kz_x2

	lda.w	mmx_enposy,y
	km_hibswapa
	sta	kz_y2
	jsr	en_collcheck_sub
	rts

;=====================================================================
;*								*
;*			Enmey Dest Postion Set	(Mother Planet)	*
;* Xreg :Planet Pointer						*
;* Yreg :Enemy Pointer						*
;=====================================================================
mm_enemydest_l
	jsr	mm_enemydest
	rtl
mm_enemydest
	phx
	php
	a8
	ldx	kx_corneriaptr
	lda.w	mmx_planetcx,x
	sta.w	mmx_endestx,y
	lda.w	mmx_planetcy,x
	sta.w	mmx_endesty,y

	plp
	plx
	rts


	ifeq	1
	ldx	kx_enemydestptr
	lda.l	enemydestxtbl,x
	sta.w	mmx_endestx,y
	lda.l	enemydestytbl,x
	sta.w	mmx_endesty,y

	lda	kx_enemydestptr
;;;;;	sta.w	mmx_endestptr,y
	inc	a
	and	#3
	sta	kx_enemydestptr

	plp
	plx
	rts
	endc

	IFEQ	1
enemydestxtbl
	db	endestposAX
	db	endestposBX
	db	endestposCX
	db	endestposDX
enemydestytbl
	db	endestposAY
	db	endestposBY
	db	endestposCY
	db	endestposDY
	ENDC

;=====================================================================
;*								*
;*			Enmey Dest Postion Set	(Player)	*
;* Yreg :Enemy Pointer						*
;=====================================================================

	longa
	longi
mm_playerdest
	a8
	lda.w	mmx_arwingposx+1
	sta.w	mmx_endestx,y
	lda.w	mmx_arwingposy+1
	sta.w	mmx_endesty,y
	a16
	rts


	IFEQ	1
	bne	.planet
	lda.w	mmx_arwingposx+1
	sta.w	mmx_endestx,y
	lda.w	mmx_arwingposy+1
	sta.w	mmx_endesty,y
	bra	.end
.planet
	phx
	a16
	km_loba
	asl	a
	tax
	a8
	lda.l	mm_destpostbl,x
	sta.w	mmx_endestx,y
	lda.l	mm_destpostbl+1,x
	sta.w	mmx_endesty,y
	plx
	ENDC
.end

;=====================================================================
;*								*
;*			Collision Check Sub Routine		*
;* InPut : (kz_x1,kz_y1),(kz_x2,kz_y2), z2 = collision		*
;* OutPut								*
;*	sec = Hit						*
;* 	clc = No Hit						*
;=====================================================================
en_collcheck_sub
	longa
	longi
;* X collision check *
	lda	kz_x2
	clc
	adc	kz_z2
	cmp	kz_x1
	bmi	.nohit
	lda	kz_x2
	sec
	sbc	kz_z2
	cmp	kz_x1
	bpl	.nohit
;* Y collision check *
	lda	kz_y2
	clc
	adc	kz_z2
	cmp	kz_y1
	bmi	.nohit
	lda	kz_y2
	sec
	sbc	kz_z2
	cmp	kz_y1
	bpl	.nohit
.hit
	sec
	rts
.nohit
	clc
	rts
;*********************************************************************
;*********************************************************************
mm_blink1
	a8
	kbug1
	bra	skip_mm_blink
mm_blink2
	a8
	kbug2
	bra	skip_mm_blink
mm_blink3
	a8
	kbug3
skip_mm_blink
	blink	3

;*********************************************************************
;*********************************************************************

;*		Not Using Area			*

;*********************************************************************
;*********************************************************************
	IFEQ	1
;=====================================================================
;*		Calculate Random Planet Pointer			* 
;* Input :a16i16							*
;* OutPut = Xreg :Planet Pointer (If X = -1 then No Enemy Appear)	*
;=====================================================================
checkendcnt	=	kz_tpx
planetkazu	=	kz_x1
planetnumber	=	kz_x2
;-----------------------------------
CalcRandomPlanetPtr
	longa
	longi

	lda	kx_missionplanetkazu
	sta	planetkazu
	sta	CheckEndCnt

;**** Get Saisyo no Planet kouhoti Number (Random Pointer / planet no kazu) ****
;OutPut:(kamari) = Planet (Saisyo no kouhoti) Number Get
	lda	kw_randomptr
	clc
	adc	kw_randomptr2
	sta	kw_randomptr2
	km_cpudivu16u8_work	planetkazu
	km_setvar	planetnumber,kamari
;**** SOS Enemy no syutugen basyo Search ****
.Search_start
	ldx	kx_planetlistptr
.loop
	dec	a
	bmi	.GetPointer
	pha
	lda.w	mmx_planetnext,x
	tax
	pla
	bra	.loop
.getpointer
	km_bitcheckflag.w	mmx_planetflag,mmpnf_complete,x
	bne	.NextPlanet
	km_bitcheckflag.w	mmx_planetflag,mmpnf_neutral,x
	beq	.FoundAppearPlanet
.NextPlanet
	dec	CheckEndCnt
	beq	.CantAppear

	km_addstaval	planetnumber,1
	cmp	kx_missionplanetkazu
	bne	.Search_start
	lda	#0
	sta	planetnumber
	beq	.Search_start
;* Syutugen Dekinai *
.CantAppear
	ldx	#-1
.FoundAppearPlanet
	rts
	ENDC
;==========================================================================
;==========================================================================
;==========================================================================
	IFEQ	1
	ldx	mmw_planetdataptr
.LOOP
;--- PLANET DRAW ---
	lda.l	planetdata+0,x
	sta.l	m_xc		;Center X
	lda.l	planetdata+2,x
	sta.l	m_yc		;Center Y

	lda.l	planetdata+4,x
	sta.l	m_radius	;Hankei
	bra	.planet

	ifeq	1
	km_bitcheckmissionflag	planet
	beq	.planet
;------------
.shadow
	lda	#shadow_spr
	sta.l	msprite

	lda.l	planetdata+8,x
	sta.l	m_rotx
	lda	#0
	sta.l	m_roty
	lda.l	planetdata+10,x
	sta.l	m_rotz
	bra	.callmario
	endc
;------------
.planet
	lda.l	planetdata+6,x
	sta.l	msprite

	lda.l	mmx_planetangx
	sta.l	m_rotx
	lda.l	mmx_planetangy
	sta.l	m_roty
	lda.l	mmx_planetangz
	sta.l	m_rotz

;* planet next pointer *
	lda	mmw_planetdataptr		;dono planet wo draw suruka no pointer
	clc
	adc	#planetdatalen			;planet data length
	sta	mmw_planetdataptr
	cmp	#planetdatalen*mm_planetnumber	;planet data length * planet number
	bne	.next
	km_setval	mmw_planetdataptr,0
	ENDC


	ifeq	1
;* ROM Nasty ON *
	nastyon
* Mario Program Start *
	lda	#MMakePlanet>>16
	sta.l	m_pbr
	a16
	lda	#MMakePlanet&WM
	sta.l	mr15	; GO!
	a8
;* Mario Wait *
	km_waitmario
	endc

;*********************************************************************
;*								*
;*		Step Up Enemy Appear				*
;* Data Bank :7e							*
;*********************************************************************
	IFEQ	1
neutralcnt	equ	kz_x1
;-------------------------------------------------
mm_StepUpEnemyAppear
	shorta
	longi
	php
	lda	kx_stepupstock
	bne	.skip			;StepUp no zaico nashi

;* Enemy Stock = 0 *
	lda	kx_neutralplanetkazu
	clc
	adc	kx_clearplanetkazu
	cmp	kx_missionplanetkazu
	bne	.jmp_end

;* Mission Map CLear *
	km_setmismapflag	missionallclear
	km_setmismapsyori	missionallclear
.jmp_end
	brl	.end
;* step up enemy appear Wait *
.skip
	lda	kx_stepupappeartm	;Appear Wait
	beq	.WaitEnd
	dec	a
	sta	kx_stepupappeartm
	brl	.end
;--------------------------------------------------------------------
.WaitEnd
	shorta
	lda	kx_stepupdemoptr
	beq	.normal_check
	cmp	#stupdm_demoend
	km_beq	.SetParams
	cmp	#stupdm_initial
	km_beq	.initial
	brl	.end
;--------------------------------------------------------------------
.initial
	km_setmismapstflag	stepupdemo	
	km_setval	kx_stepupdemoptr,stupdm_open
	brl	.end
;--------------------------------------------------------------------
.normal_check
;* enemy total no kazu >= 8 *
	shorta
	km_cmpcheck	kx_enemytotal,mm_enemymax	;(kalcs.inc)
	km_bpl	.end

;* Neutral no  hoshi no kazu wo Check *
	shorta
	lda	kx_neutralplanetkazu
	km_beq	.end
	dec	a
	beq	.neutral1	;neutral no kazu = 1
	bra	.check_stupkazu	;neutral no kazu >= 2

;* clear planet no kazu = planet no kazu-1 ka CHECK *
.neutral1
	shorta
	lda	kx_missionplanetkazu
	dec	a
	cmp	kx_clearplanetkazu
	km_bne	.end

;* neutral no kazu > stepup no kazu *
.check_stupkazu
	shorta
	lda	kx_neutralplanetkazu
	cmp	kx_stepuptotal
	km_beq	.end	;neutral no kazu = stepup no kazu
	km_bmi	.end	;neutral no kazu < stepup no kazu

;* neutral planet search *
.search_neutral
	a16
	ldx	kx_planetlistptr
.loop
	cpx	kx_corneriaptr
	km_beq	.end

	km_bitcheckflag.w	mmx_planetflag,mmpnf_neutral,x
	bne	.found_neutral
.nextplanet
	lda.w	mmx_planetnext,x
	tax
	bne	.loop
	brl	.end

;**** Sono Mokuteki no Planet ni sudeni StepUp Enemy ga mukatte iruka CHECK ****
;Xreg :Planet List Pointer
;Yreg :Enemy  List Pointer
.found_neutral
	longa
	ldy	kx_enlistptr
.loop2
	km_bitcheckflag.w	mmx_enflags,enfl_stepup,y
	beq	.nextenlist
.stepupenemy
	txa
	cmp.w	mmx_endestplanetptr,y
	beq	.nextplanet

.nextenlist
	lda.w	mmx_ennext,y
	beq	.search_end
	tay
	bne	.loop2
.search_end	;mokuteki Planet ni mukatteiru SteuUp Enemy nashi
	stx	kx_stepupdestptr

;* Mission Map ka Game tyuu ka Check *
	a8
	km_bitcheckmismapflag	missionstart
	km_bne	.SetParams

	km_setval	kx_stepupdemoptr,stupdm_initial
	km_setval	kx_stepupappeartm,5*8
	brl	.end
;-------------------------------------------------------------
;*		Enemy no Params Set			*
;-------------------------------------------------------------
.SetParams
;* step up no stock wo 1tu hrasu *
	a8
	dec	kx_stepupstock
	dec	kx_neutralplanetkazu
	inc	kx_stepuptotal
	
	a16
	km_setval	kx_stepupdemoptr,0
	km_clrmismapstflag	stepupdemo	

;* Enemy List Poinrter Get *
;OutPut :Yreg
	jsr	mm_getenemylistptr
;* flag *
	km_setflag16.w	mmx_enflags,enfl_stepup,y
	km_clrflag16.w	mmx_enflags,enfl_extra,y

;* source *
	km_setval.w	mmx_enposx,(stepup_posx1<<8),y
	km_setval.w	mmx_enposy,(stepup_posy1<<8),y

;* dest *
	lda	kx_stepupdestptr
	sta.w	mmx_endestplanetptr,y
	tax
	jsr	mm_enemydest

;* velocity *
	lda	#-15
	sta.w	mmx_envel,y	;velocity
	jsr	calc_enangvelxy

;* battle stage *
	a8
	lda	#stg_sos1
	sta.w	mmx_enstage,y

;* skill *
	a8
	lda	kw_RandomPtr
	and	#7
	sta.w	mmx_enskill,y

;* stratage pointer *
	a8
	lda	#0
	sta.w	mmx_enstratptr,y

;* collision *
	lda	#10
	sta.w	mmx_encoll,y		;collision

;* Character No *
	PHX
	ldx	#0
	a8
	lda	#0
	sta.w	mmx_enanmptr,y

	lda.l	mm_enemychart+6,x
	sta.w	mmx_enchrbase,y		;character Base No

	a16
	lda.l	mm_enemychart+8,x
	sta.w	mmx_enanmpatt,y		;animtion pattern pointer
	tax

	a8
	lda.l	mm_sprenpattdata+0,x
	sta.w	mmx_enanmmaxptr,y	;anime pattern max pointer

	lda.l	mm_sprenpattdata+1,x
	clc
	adc.w	mmx_enchrbase,y
	sta.w	mmx_enchranm,y		;sprite anim chr No 

	lda.l	mm_sprenpattdata+2,x
	sta.w	mmx_enanmtm,y		;Animation change Timer
	PLX

;--------------------------------------------------------------------
.end
	plp
	rts

;======================================================================
;======================================================================
;======================================================================

;neutral find check
	ldy	kx_planetlistptr
.checkloop
	km_bitcheckflag.w	mmx_planetflag,mmpnf_neutral,y
	beq	.nextplanet
.foundnetralplanet
.nextplanet
	a16
	lda.w	mmx_planetnext,y
	beq	.checkend
	tay
	a8
	bra	.checkloop
.checkend
	ENDC
;*********************************************************************
;*		SOS Enemy Appear Routine			*
;* Data Bank :7e							*
;* Yreg :Enemy List Pointer						*
;*********************************************************************
;---------------------------
	IFEQ	1
mm_sosenemyappear
	php
	a16
	longi
;* total no kazu check *
	lda	kx_enemytotal
	cmp	#1	;mm_enemymax
	km_bpl	.end

;* time check *
	km_bitcheckmismapstflag	hourpast
	km_beq	.end
	km_clrmismapstflag	hourpast

	lda	kx_TOTALTIME
	cmp	#1
	beq	.appearenemy
	km_andcmpval	$3f
	bne	.end
.appearenemy
	jsr	mm_initsoslist
.end
	plp
	rts
	ENDC
;**************************************************************************
	IFEQ	1
;---------------------------------------------
;*	Enemy Chart			*
;---------------------------------------------
;===========================================================================
;	dw	CX,CY			;0,2
;	dw	vel,charaNo		;4,6
;	dw	AnmPtr,DestNo		;8,10
;	dw	level			;12
;===========================================================================
obj_gesso	equ	$80
obj_gohst	equ	$84
obj_oni	equ	$88
obj_carbi	equ	$8c
obj_stepup	equ	$a0
obj_sos	equ	$aa
obj_enap1	equ	$0c
obj_enap2	equ	$0e
;--------------------------------------------------------------------------
	IFEQ	1
mm_enemychart
	dw	1,obj_sos,enstrat_nothing,enanm_nothing
mm_enemychartEND
	dw	1,obj_sos,enstrat_nothing,enanm_nothing
	dw	2*8,obj_sos,enstrat_stepupappear,enanm_turn
	dw	0,obj_sos,enstrat_searchplanet,enanm_nothing
	km_datalen	mm_enemychart
	ENDC

;=====================================================================
;*								*
;*			Enemy Anime Pattern			*
;*								*
;=====================================================================
mm_sprenpattdata
;------------------------------
;*  Enemy Pattern Data (Gesso)*
;------------------------------
mm_sprgesso
	km_datacnt	b,mm_sprgesso
      	db	$0,40,$2,40,$0,40,$2,40
      	db	$0,40,$2,40,$0,40,$2,40
	db	$0,08,$2,08,$0,08,$2,08
mm_sprgessoEND
	km_datalen	mm_sprgesso
;--------------------------------
;*  Enemy Pattern Data (Ghost 1)*
;--------------------------------
mm_sprghost1
	km_datacnt	b,mm_sprghost1
      	db	$0,40,$2,40,$0,40,$2,40
      	db	$0,40,$2,40,$0,40,$2,40
      	db	$0,40,$2,40,$0,40,$2,40
	db	$0,04,$2,04,$0,04,$2,04
	db	$0,04,$2,04,$0,04,$2,04
mm_sprghost1END
	km_datalen	mm_sprghost1
;--------------------------------
;*  Enemy Pattern Data (Ghost 2)*
;--------------------------------
mm_sprghost2
	km_datacnt	b,mm_sprghost2
      	db	$0,40,$2,40,$0,40,$2,40
	db	$0,40,$2,40,$0,40,$2,40
	db	$0,10,$2,10,$0,10,$2,10
mm_sprghost2END
	km_datalen	mm_sprghost2


;**** Sono Mokuteki no Planet ni sudeni StepUp Enemy ga mukatte iruka CHECK ****
;Xreg :Planet List Pointer
;Yreg :Enemy  List Pointer
	longa
	ldy	kx_enlistptr
.loop2
	km_bitcheckflag.w	mmx_enflags,enfl_stepup,y
	beq	.nextenlist
.stepupenemy
	txa
	cmp.w	mmx_endestplanetptr,y
	beq	.nextplanet

.nextenlist
	lda.w	mmx_ennext,y
	beq	.search_end
	tay
	bne	.loop2
.search_end	;mokuteki Planet ni mukatteiru SteuUp Enemy nashi
	stx	kx_stepupdestptr
;-------------------------------------------------------------
;*		Enemy no Params Set			*
;-------------------------------------------------------------
.SetParams
;* step up no stock wo 1tu hrasu *
	a8
	dec	kx_stepupstock
	dec	kx_neutralplanetkazu
	inc	kx_stepuptotal
	a16
;* Enemy List Poinrter Get *
;OutPut :Yreg
	jsr	mm_getenemylistptr
;* flag *
	km_setflag16.w	mmx_enflags,enfl_stepup,y
	km_clrflag16.w	mmx_enflags,enfl_extra,y

;* Wait Time *
	km_setval.w	mmx_enappearwaittm,30*16,y

;* source *
	km_setval.w	mmx_enposx,(stepup_posx1<<8),y
	km_setval.w	mmx_enposy,(stepup_posy1<<8),y

;* dest *
	lda	kx_stepupdestptr
	sta.w	mmx_endestplanetptr,y
	tax
	jsr	mm_enemydest

;* velocity *
	lda	#-32
	sta.w	mmx_envel,y	;velocity
	jsr	calc_enangvelxy

	a8
;* battle stage *
	lda	#stg_sos1
	sta.w	mmx_enstage,y

;* skill *
	lda	kw_RandomPtr
	and	#7
	sta.w	mmx_enskill,y

;* stratage pointer *
	lda	#0
	sta.w	mmx_enstratptr,y

;* collision *
	lda	#10
	sta.w	mmx_encoll,y		;collision

;* Character No *
	lda	#0
	sta.w	mmx_enanmptr,y

	lda.l	#obj_sos		;mm_enemychart+6,x
	sta.w	mmx_enchrbase,y		;character Base No

	a16
	PHX
	ldx	#(mm_sprgesso-mm_sprenpattdata)&WM
	lda.l	mm_enemychart+6,x
	sta.w	mmx_enanmpatt,y		;animtion pattern pointer
	tax
	a8
	lda.l	mm_sprenpattdata+0,x
	sta.w	mmx_enanmmaxptr,y	;anime pattern max pointer

	lda.l	mm_sprenpattdata+1,x
	clc
	adc.w	mmx_enchrbase,y
	sta.w	mmx_enchranm,y		;sprite anim chr No 

	lda.l	mm_sprenpattdata+2,x
	sta.w	mmx_enanmtm,y		;Animation change Timer
	PLX

;--------------------------------------------------------------------
.end
	plp
	rts

;neutral find check
	ldy	kx_planetlistptr
.checkloop
	km_bitcheckflag.w	mmx_planetflag,mmpnf_neutral,y
	beq	.nextplanet
.foundnetralplanet
.nextplanet
	a16
	lda.w	mmx_planetnext,y
	beq	.checkend
	tay
	a8
	bra	.checkloop
.checkend
;==========================================================================
	a16
	PHX
	lda	#(mm_sprgesso-mm_sprenpattdata)&WM
	lda.l	mm_enemychart+6,x
	sta.w	mmx_enanmpatt,y		;animtion pattern pointer
	tax
	a8
	lda.l	mm_sprenpattdata+0,x
	sta.w	mmx_enanmmaxptr,y	;anime pattern max pointer

	lda.l	mm_sprenpattdata+1,x
	clc
	adc.w	mmx_enchrbase,y
	sta.w	mmx_enchranm,y		;sprite anim chr No 

	lda.l	mm_sprenpattdata+2,x
	sta.w	mmx_enanmtm,y		;Animation change Timer
	PLX
	ENDC



	IFEQ	1
;************ Enemy no idou **************
.SetEnemyPostion
	km_memchecka16
;* enemy velocity calc *
	lda.w	mmx_endestplanetptr,y
	tax
	jsr	mm_enemydest
	jsr	calc_enangvelxy
;* enemy postion set *
	jsr	en_speedupmode

	lda	mm_spx
	clc
	adc.w	mmx_enposx,y
	sta.w	mmx_enposx,y

	lda	mm_spy
	clc
	adc.w	mmx_enposy,y
	sta.w	mmx_enposy,y

	ENDC

	IFEQ	1
	tyx
;* X,Y reg = planet pointer *

	lda	#1
	jsl	kspeedupA_l
	sta	kz_x1
	lda.w	mmx_soswaittm,x
	sec
	sbc	kz_x1
	sta.w	mmx_soswaittm,x
	beq	.next_demo
	bpl	.demo_end
.next_demo
;* X reg = chart pointer  *
;* Y reg = planet pointer *
	km_addstaval.w	mmx_soschartptr,mm_enemychartlen,y
	tax
	lda.l	mm_enemychart+0,x
	sta.w	mmx_soswaittm,y
	bne	.demo_set
	
	lda.w	mmx_psos,y
	inc	a
	sta.w	mmx_psos,y
.demo_set
	phy
;* Y reg = enemy pointer *
	lda.w	mmx_sosenlistptr,y	;Enemy List Pointer
	tay
	lda.l	mm_enemychart+2,x
	sta.w	mmx_enchrbase,y		;character Base No
	lda.l	mm_enemychart+4,x
	sta.w	mmx_enstratptr,y
	ply
.demo_end
;* Y reg = planet pointer *
	rts
	ENDC
	IFEQ	1
;* Character No *
	PHX
;;;	ldx	#mm_enemychartlen
	a8
	lda	#0
	sta.w	mmx_enanmptr,y

;	lda.l	mm_enemychart+6,x
;	sta.w	mmx_enchrbase,y		;character Base No

	a16
;;;;	lda.l	mm_enemychart+8,x
;;;;	lda	#(mm_sprgesso-mm_sprenpattdata)&WM
;;;;	sta.w	mmx_enanmpatt,y		;animtion pattern pointer
	tax
	a8
	lda.l	mm_sprenpattdata+0,x
	sta.w	mmx_enanmmaxptr,y	;anime pattern max pointer

	lda.l	mm_sprenpattdata+1,x
	clc
	adc.w	mmx_enchrbase,y
	sta.w	mmx_enchranm,y		;sprite anim chr No 

;;;;	lda.l	mm_sprenpattdata+2,x
;;;;	sta.w	mmx_enanmtm,y		;Animation change Timer
	PLX

;* Next Chart Pointer *
	a16
	lda	kx_enemychartptr
	clc
	adc	#(mm_enemychartEND-mm_enemychart)&WM
	cmp	#(mm_enemychartFinish-mm_enemychart)&WM
	bne	.skip1
	lda	#0
.skip1
	sta	kx_enemychartptr

	ENDC



;=====================================================================
;*			Planet cannon				*
;=====================================================================
	ifeq	1
mm_planetcannon
	longa
	longi

;	lda.w	mmx_timer2,x
;	cmp	#5*60
;	bne	.end

	km_testjoypad	TLeft
	beq	.end


	phy

	ldy	kx_CorneriaPtr
	lda	#idx_wipebeam_open
	sta	wipestruct

;	lda.w	mmx_planetcx,x
;	sec
;	sbc	#4

	lda	#enemybaseX
	sta	finalbeam_sx

;	lda.w	mmx_planetcy,x
;	clc
;	adc	#8

	lda	#enemybaseY
	sta	finalbeam_sy

	lda.w	mmx_planetcx,y
	sta	finalbeam_dx
	lda.w	mmx_planetcy,y
	sta	finalbeam_dy

	ply
.end
	rts
	endc


	rept	300
	db	0
	endr

	incfile	ASM\soslist.asm 
