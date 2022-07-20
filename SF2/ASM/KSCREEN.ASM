;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         SCREEN.ASM                                          ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  Screen Initialisation Code                          ;
; DATE CREATED: 12-5-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;

	INCPUB	kscreen
;*********************************************************************
;*		KSCREEN.ASM Routines				*
;*********************************************************************
;set_kscreen_l,Kscr_onescreen,Kscr_twoscreen
;SetCockpitCharacter,BoostMeter,DAMAGE,SCORE
;SetCockpitColor,Change_colpalette
;SetCockpitWindow
;*********************************************************************
;*		CockPit Parameters & Vars			*
;*								*
;*********************************************************************
;*********************************************************************
;*			Macro Definishion			*
;*********************************************************************
;---------------------------------------------------------------------
;*		MISSION Parameters				*
;---------------------------------------------------------------------
SetPlHeapPtr	macro	[player,obj1]
MYNARG	=	NARG
	CHK_NARG	2

	shorta
	longi
	km_plheapptr	{player},{obj1}

	lda	#{player}
	lsr	a	
	sta	kplayer

	endm
;---------------------------------------------------------------------
km_ramcpudivu16uf8	macro	[output,divisor]
;init	:a16i16
;	Acc(16 bit) / #divisor (8 bit)
;exit	:a16i16
;	syou(work),amari(work)
;	syou (x),amari(y)

MYNARG	=	NARG
	CHK_NARG	2

_cc_{output} =	2
_cc_xy	=	0
_cc_work	=	1

	km_memchecka16i16

	IFEQ	_cc_{output}-_cc_xy
	ldx	#{divisor}
		jsl	kdivu16u8_sub_l
;;;	km_jsr	ramdivu16u8_sub
	ELSEIF

		IFEQ	_cc_{output}-_cc_work
		phx
		phy
		ldx	#{divisor}
		jsl	kdivu16u8_sub_l
;;;;		km_jsr	ramdivu16u8_sub
		stx	ksyou
		sty   	kamari
		ply
		plx
		ELSEIF

		printf	"Error:(xy,work) needed\n"
		error+
		ENDC
	ENDC
	endm
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------

;*********************************************************************
;*								*
;*			PROGRAM START				*
;*								*
;*********************************************************************
;=====================================================================
;*			JMP Routine				*
;=====================================================================
set_kscreen_l
	km_PushAllReg
	a8i16
	db7e
;* No Screen Check *
	test_screenmode	noscreen
	bne	set_kscreen_end

	km_ldxscreenmode
	jsr	(KScrJmpTab,x)
set_kscreen_end
	km_PullAllReg
	rtl

;---------------------------------------------------------------------
;*			Jump Table				*
;---------------------------------------------------------------------
KScrJmpTab
	dw	Kscr_noscreen&WM
	dw	Kscr_title&WM
	dw	Kscr_mission&WM
	dw	Kscr_battle&WM
	dw	kscr_missionexplain&WM
	dw	kscr_missionmap&WM
	dw	kscr_missiongameover&WM
	dw	kscr_missioncontiune&WM
	dw	kscr_missionresult&WM

;=====================================================================
;* 			MISSION MODE				*
;* Init Mode a8i16							*
;* Data Bank 7e							*
;* X reg :player work pointer					*
;=====================================================================
Kscr_noscreen
kscr_title
kscr_missiongameover
kscr_missioncontiune
	shorta
	longi
	rts

;=====================================================================
;* 			MISSION MAP				*
;* Init Mode a8i16							*
;* Data Bank 7e							*
;=====================================================================
	shorta
	longi
kscr_missionmap
;* Set screen (screenkakikae) *
	jsr	mm_dispDamage
	jsr	mm_dispgametotaltm
	jsr	mm_dispScore
	jsr	mm_dispItem

;* debug *
	IFNE	kginfo
	jsr	mm_dispEnemyKazu
	jsr	mm_dispTimeChart
	ENDC

;* Set Colour (colour kakikae) *
	jsr	mm_changecolpal

;* flag clear *
	km_clrmismapstflag	corneriadamage
	rts

;---------------------------------------------------------------------
;*			Display Corneria Damage [Mission Map]	*
;* Data Bank :7e							*
;---------------------------------------------------------------------
	shorta
	longi
mm_dispdamage
	a16
	jsl	DecCorneriaHP_map_l
	bcc	.nodamage
	km_setmismapstflag	corneriadamage
.nodamage
	jsr	mm_dispdamage_sub
.end
	a8
	rts
;----------------------------------------------------------------------
	longa
	longi
mm_dispdamage_sub
	km_bitcheckmismapstflag	corneriadamage
	beq	.end

	km_setval	kz_x1,$02	;[top x zahyou]
	km_setval	kz_y1,$17	;[top y zahyou]
	km_setval	kz_z1,$60	;[character hosei]
	ldx	#2			;[ketasuu]
	lda	kx_CorneriaDamage
	cmp	#100
	beq	.damage_100
	jsr	SetBGNumber_16x16
	rts
.damage_100
	longa
	km_setval	kz_z1,$84	;[character hosei]
	a8
	jsr	SetScreen_16x16
	inc	kz_x1
	inc	kz_x1
	inc	kz_z1
	inc	kz_z1
	jsr	SetScreen_16x16
	a16
.end
	rts

;---------------------------------------------------------------------
;*			Game Total Timer 	[Mission Map]	*
;* Data Bank :7e							*
;---------------------------------------------------------------------
	shorta
	longi
mm_dispgametotaltm
	a16
	km_bitcheckmismapstflag	hourpast	;1 hour past flag
	beq	.end
	jsr	mm_dispgametotaltm_sub
.end
	a8
	rts
;----------------------------------------------------------------------
	longa
	longi
mm_dispgametotaltm_sub
	km_setval	kz_x1,$19	;[top x zahyou]
	km_setval	kz_y1,$18	;[top y zahyou]
	km_setval	kz_z1,$20	;[character hosei]
	lda	kx_TOTALTIME		;[kazu]
	ldx	#3			;[ketasuu]
	jsr	SetBGNumber_8x8
	rts

;---------------------------------------------------------------------
;*		Display Score 		 	[Mission Map]	*
;* Data Bank :7e							*
;---------------------------------------------------------------------
	shorta
	longi
mm_dispScore
	a16
	km_setval	kz_x1,$18	;[top x zahyou]
	km_setval	kz_y1,$1a	;[top y zahyou]
	km_setval	kz_z1,$30	;[character hosei]
	lda.l		kx_basicscore	;kw_totalscore1
	ldx	#5			;[ketasuu]
	jsr	SetBGNumber_8x8
	a8
	rts


;---------------------------------------------------------------------
;*			Display Item Number 	[Mission Map]	*
;* Data Bank :7e							*
;---------------------------------------------------------------------
	shorta
	longi
mm_dispItem
	a16
	km_bitcheckmistotalflag	explain1
	bne	.NotDisplay

	km_setval	kz_x1,$16	;[top x zahyou]
	km_setval	kz_y1,$19	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	km_loblda	p1_spweap_LMT	;kx_weaponnum1
	ldx	#1			;[ketasuu]
	jsr	SetBGNumber_8x16
.NotDisplay
	a8
	rts

;---------------------------------------------------------------------
;*		Display Enemy Kazu 		 [Mission Map]	*
;* Data Bank :7e							*
;---------------------------------------------------------------------
	shorta
	longi
mm_dispEnemyKazu
	a16
	km_setval	kz_x1,$02	;[top x zahyou]
	km_setval	kz_y1,$19	;[top y zahyou]
	km_setval	kz_z1,$30	;[character hosei]
	lda.l		kx_enemytotal
	ldx	#2			;[ketasuu]
	jsr	SetBGNumber_8x8
	a8
	rts


;---------------------------------------------------------------------
;*		Display Enemy Kazu 		 [Mission Map]	*
;* Data Bank :7e							*
;---------------------------------------------------------------------
	shorta
	longi
mm_dispTimeChart
	a16
	km_setval	kz_x1,$02	;[top x zahyou]
	km_setval	kz_y1,$1a	;[top y zahyou]
	km_setval	kz_z1,$30	;[character hosei]
	lda.l		kx_mismaptmchartNum
	ldx	#2			;[ketasuu]
	jsr	SetBGNumber_8x8
	a8
	rts

;=====================================================================
;* 			MISSION EXPLAIN				*
;* Init Mode a8i16							*
;* Data Bank 7e							*
;=====================================================================
planet_motox		equ	($1b-2)*8+4
planet_motoy		equ	(6-2)*8
planet_sakix		equ	(4-2)*8+4
planet_sakiy		equ	($e-2)*8

planet_radius	equ	$10
;---------------------------------------------------------------------
kscr_missionexplain
	shorta
	longi
;* Screen Animation *

	a16
	lda	winctimer
	and	#$3
	tax
	a8
	lda.l	me_hscrolltbl,x
	sta	kw_bg3hofs+1
	lda.l	me_vscrolltbl,x
	sta	kw_bg3vofs+1
	rts

;=====================================================================
;* 			MISSION MODE				*
;* Init Mode a8i16							*
;* Data Bank 7e							*
;* X reg :player work pointer					*
;=====================================================================
Kscr_mission
	shorta
	longi

;;;;	SetPlHeapPtr	1,x

	jsr	Change_colpalette	;[colour]
	rts

;=====================================================================
;* 			2 Player Battle				*
;* Init Mode a8i16							*
;* Data Bank 7e							*
;* X reg :player work pointer					*
;=====================================================================
	shorta
	longi
Kscr_battle
;* player 1 *
;;;	SetPlHeapPtr	1,x
;;;	jsr	SetCockpitCharacter	;[BG kakikae]
;* player 2 *
;;;	SetPlHeapPtr	2,x
;;;	jsr	SetCockpitCharacter	;[BG kakikae]
;;;;	jsr	SetCockpitColor		;[colour]


	jsr	Change_colpalette	;[colour]

	rts

;=====================================================================
;*								*
;*			Mission Result				*
;* Data Bank 7e							*
;=====================================================================
	shorta
	longi
kscr_missionresult
	php
	a16
	lda	mre_scorechart
	cmp	#-1
	beq	.end
	asl	a
	tax

	jsr	(kmre_scorechart,x)
.end
	plp
	rts

kmre_scorechart
	dw	kmre_startinit&WM
	dw	kmre_startwait&WM

	dw	kmre_bsscoreinit&WM
	dw	kmre_kurukurutmwait&WM
	dw	kmre_setbsscore&WM
	dw	kmre_tmwaitinit&WM
	dw	kmre_tmwait&WM

	dw	kmre_cdcountinit&WM
	dw	kmre_count&WM
	dw	kmre_setcdscore&WM
	dw	kmre_tmwaitinit&WM
	dw	kmre_tmwait&WM

	dw	kmre_prcountinit&WM
	dw	kmre_count&WM
	dw	kmre_setprscore&WM
	dw	kmre_tmwaitinit&WM
	dw	kmre_tmwait&WM

	dw	kmre_bonuscheck&WM

kmre_clearbonus
	dw	kmre_totaltmcountinit&WM
	dw	kmre_totaltmcount&WM
	dw	kmre_setttscore&WM
	dw	kmre_tmwaitinit&WM
	dw	kmre_tmwait&WM

	dw	kmre_damagecountinit&WM
	dw	kmre_damagecount&WM
	dw	kmre_setdmscore&WM
	dw	kmre_tmwaitinit&WM
	dw	kmre_tmwait&WM

	dw	kmre_ptscoreinit&WM
	dw	kmre_kurukurutmwait&WM
	dw	kmre_setptscore&WM
	dw	kmre_totmwaitinit&WM
	dw	kmre_tmwait&WM
kmre_clearbonusend

	dw	kmre_totalscoreinit&WM
	dw	kmre_totalscore&WM
	dw	kmre_tmwait&WM

	ifne	kdebugrsbgm
	dw	kmre_debugBGM&WM
	endc

	dw	kmre_ringBGM&WM

	dw	kmre_record&WM
	dw	kmre_tmwait&WM

	dw	kmre_fftmwaitinit&WM
	dw	kmre_tmwait&WM

	dw	kmre_end&WM

;;;;	dw	kmre_reset&WM
;;;;	dw	kmre_loop&WM

kmre_lookdetail
	dw	kmre_detail&WM

;=====================================================================
;*								*
;*			Chart Sub Program			*
;*								*
;=====================================================================
;---------------------------------------------------------------------
	longa
	longi
kmre_debugBGM
	ifne	kdebugrsbgm
	km_testjoypad	start
	beq	.keycheck
	inc	mre_scorechart
	rts

.keycheck
	km_testjoypad	select
	beq	.End
	ksound	cursor

	lda	kx_rank
	inc	a
	cmp	#6
	BMI	.SKIP1
	lda	#0
.Skip1	
	sta	kx_rank

	lda	#5
	sec
	sbc	kx_rank
	asl	a
	sta	mre_rank

	ldx	kx_rank
	km_loblda.l	fan_BGMTbl,x
	KBGM_a
.End
	rts
	ENDC
;---------------------------------------------------------------------
	longa
	longi
kmre_startinit

	km_setval	mre_chartwaittm,10*6*2
	inc	mre_scorechart
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_detail
;(basic score)
	km_setval	mre_tmpXScore,$17
	km_setval	mre_tmpYScore,$0d
	jsr	kmre_setbsscore

;(battleship gekitui)
	km_setval	mre_tmpX,$10
	km_setval	mre_tmpY,$0f
	km_setval	mre_tmpchar,$6c
	km_setvar	mre_tmpkazu,kx_battleshipclearcnt
	jsr	call_bsdestroy

	km_setval	mre_tmpYScore,$0f
	jsr	kmre_setcdscore

;(planet rescue)
	km_setval	mre_tmpX,$10
	km_setval	mre_tmpY,$11
	km_setval	mre_tmpchar,$7c
	km_setvar	mre_tmpkazu,kx_planetclearcnt
	jsr	call_bsdestroy

	km_setval	mre_tmpYScore,$11
	jsr	kmre_setprscore

;********** BONUS **********
	lda	kx_result
	cmp	#kre_gameclear
	bne	.END
;(total time)
	km_setval	mre_tmpX,$12
	km_setval	mre_tmpY,$13
	km_setvar	mre_tmpkazu,kx_TotalTime
	jsr	call_resulttime

	km_setval	mre_tmpYScore,$13
	jsr	kmre_setttscore

;(corneria damage)
	km_setval	mre_tmpX,$10
	km_setval	mre_tmpY,$15
	km_setvar	mre_tmpkazu,kx_CorneriaDamage
	jsr	call_resulttime

	km_setval	mre_tmpYScore,$15
	jsr	kmre_setdmscore

;(partner continue)
	km_setval	mre_tmpYScore,$17
	jsr	kmre_setptscore

.END
;(total score)
	km_setvar	mre_TotalScore,kw_totalscore1
	km_setvar	mre_TotalScore_h,kw_totalscore1+2
	jsr	Call_TotalScore
;(sprites)
	jsr	Check_Ranking
	km_setval	mre_rankflag,1
	km_setval	mre_meterflag,1
	km_setval	mre_scorechart,-1
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_bonuscheck
	lda	kx_result
	cmp	#kre_gameclear
	beq	.add_bonus
.no_bonus
	lda	mre_scorechart
	clc
	adc	#(kmre_clearbonusend-kmre_clearbonus)/2
	sta	mre_scorechart
.add_bonus
	inc	mre_scorechart
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_tmwaitinit
	km_setval	mre_chartwaittm,30
	bra	kmre_tmwaitinit_common
kmre_totmwaitinit
	km_setval	mre_chartwaittm,50
	bra	kmre_tmwaitinit_common
kmre_fftmwaitinit
	km_setval	mre_chartwaittm,30
kmre_tmwaitinit_common
	inc	mre_scorechart
	rts

	longa
	longi
kmre_startwait
kmre_tmwait
	dec	mre_chartwaittm	
	bne	.not_finish

	inc	mre_scorechart
.not_finish
	rts
;---------------------------------------------------------------------
kmre_bsscoreinit
	km_setval	mre_tmpXScore,$17
	km_setval	mre_tmpYScore,$0d
;(timer)
	km_setval	mre_tmpTm,1*60
	sta	mre_tmpTm

	inc	mre_scorechart
	rts

	longa
	longi
kmre_setbsscore
	lda	kx_basicscore
	ldx	kx_basicscore+2
	bra	kmre_setscore_common

kmre_setcdscore
	lda	kx_bsclearbonus
	ldx	kx_bsclearbonus+2
	bra	kmre_setscore_common

kmre_setprscore
	lda	kx_plclearbonus
	ldx	kx_plclearbonus+2
	bra	kmre_setscore_common

kmre_setttscore
	lda	kx_timebonus
	ldx	kx_timebonus+2
	bra	kmre_setscore_common

kmre_setdmscore
	lda	kx_damagebonus
	ldx	kx_damagebonus+2
	bra	kmre_setscore_common

kmre_setptscore
	lda	kx_partnerbonus
	ldx	kx_partnerbonus+2
	bra	kmre_setscore_common
kmre_setscore_common
	sta	mre_tmpscore
	stx	mre_tmpscore+2
	jsr	call_resultscore
	inc	mre_scorechart
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_cdcountinit

;(condition)
	km_setval	mre_tmpkazu,0
	km_setvar	mre_tmpmaxkazu,kx_battleshipclearcnt
	km_setval	mre_tmpchar,$6c

;(zahyou)
	km_setval	mre_tmpX,$10
	km_setval	mre_tmpY,$f
	km_setval	mre_tmpXScore,$17
	km_setval	mre_tmpYScore,$0f

;(timer)
	km_setval	mre_tmpTmMax,10
	sta	mre_tmpTm

	inc	mre_scorechart
	rts

	longa
	longi
kmre_prcountinit

;(condition)
	km_setval	mre_tmpkazu,0
	km_setvar	mre_tmpmaxkazu,kx_planetclearcnt
	km_setval	mre_tmpchar,$7c

;(zahyou)
	km_setval	mre_tmpX,$10
	km_setval	mre_tmpY,$11

	km_setval	mre_tmpXScore,$17
	km_setval	mre_tmpYScore,$11

;(timer)
	km_setval	mre_tmpTmMax,10
	sta	mre_tmpTm

	inc	mre_scorechart
	rts

kmre_count
	jsr	calc_KurukuruScore
	jsr	call_resultscore

	dec	mre_tmpTm
	bne	.end
	km_setvar	mre_tmpTm,mre_tmpTmMax	

	lda	mre_tmpkazu
	cmp	mre_tmpmaxkazu
	beq	.finish
	inc	a
	sta	mre_tmpkazu
	jsr	call_planetrescue
	rts
.finish
	inc	mre_scorechart
.end
	rts

	longa
	longi
call_planetrescue
call_bsdestroy
	km_setvar	kz_x1,mre_tmpX
	km_setvar	kz_y1,mre_tmpY
	km_setvar	kz_z1,mre_tmpchar
	km_setvar	kz_tpa,mre_tmpkazu
	jsl	Clear_BGKakikaeBuffer_l
	rts
;---------------------------------------------------------------------
kmre_ptscoreinit
	km_setval	mre_tmpXScore,$17
	km_setval	mre_tmpYScore,$17
;(timer)
	km_setval	mre_tmpTm,1*60
	sta	mre_tmpTm

	inc	mre_scorechart
	rts

;---------------------------------------------------------------------
	longa
	longi
kmre_totaltmcountinit
	km_setval	mre_tmpX,$12
	km_setval	mre_tmpY,$13
	km_setval	mre_tmpXScore,$17
	km_setval	mre_tmpYScore,$13
	km_setvar	mre_resultkazu,kx_TotalTime
	km_setvar	mre_tmpkazu,kx_timemax
	km_setval	mre_soundtimer,0

	inc	mre_scorechart
	rts

	longa
	longi
kmre_damagecountinit
	km_setval	mre_tmpX,$10
	km_setval	mre_tmpY,$15
	km_setval	mre_tmpXScore,$17
	km_setval	mre_tmpYScore,$15

	km_setvar	mre_resultkazu,kx_CorneriaDamage
	km_setval	mre_tmpkazu,100
	km_setval	mre_soundtimer,0

	inc	mre_scorechart
	rts

	longa
	longi
kmre_totaltmcount
kmre_damagecount
;* dec timer & damage *
	lda	mre_tmpkazu
	cmp	mre_resultkazu
	beq	.finish
	dec	a
	dec	a
	cmp	mre_resultkazu
	bmi	.finish
	sta	mre_tmpkazu
	bra	.end
.finish
	km_setvar	mre_tmpkazu,mre_resultkazu
	inc	mre_scorechart
.end
	jsr	call_resulttime
	jsr	kmre_kurukuruscore
	rts

;---------------------------------------------------------------------
	longa
	longi
kmre_totalscoreinit
	km_setval	mre_countupscore,811

	stz	mre_meter
	stz	mre_rank
	stz	mre_TotalScore
	stz	mre_TotalScore_h
	inc	mre_rankflag
	inc	mre_meterflag

	inc	mre_scorechart
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_totalscore
;* Add Total Score *
	lda	mre_TotalScore
	clc
	adc	mre_countupscore
	sta	mre_TotalScore

	lda	mre_TotalScore_h
	adc	#0
	sta	mre_TotalScore_h
;--------------------------------------------
;* Check Count Up Finish *
	lda	mre_TotalScore_h
	cmp	kw_totalscore1+2
	bcc	.skip		;('95/8/21 :bne ---> bcc) :65816 (1000h) no fushime de okashiku naru !!
	bne	.over

	lda	mre_TotalScore
	cmp	kw_totalscore1
	bcc	.skip
.over
	km_setvar	mre_TotalScore,kw_totalscore1
	km_setvar	mre_TotalScore_h,kw_totalscore1+2
;* time wait *
	km_setval	mre_chartwaittm,60
;* next chart *
	inc	mre_rankflag
	inc	mre_scorechart
.skip
;--------------------------------------------
;* Set Ranking (meter) & Score *
	jsr	Check_Ranking
	jsr	Call_TotalScore
;--------------------------------------------
;* Total Score Count Up Sound *
	jsr	ksound_score

;* Meter Count Up Sound *
	lda	mre_meter_back
	inc	a
	cmp	mre_meter
	bne	.skipsound
	km_setvar	mre_meter_back,mre_meter
	ksound	count_up_gauge
.skipsound
;--------------------------------------------
;* Count Up Tempo *
	lda	kw_totalscore1
	sec
	sbc	mre_TotalScore
	sta	kz_x1

	lda	kw_totalscore1+2
	sbc	mre_TotalScore_h
	sta	kz_y1
	bne	.not_slowtempo

	lda	kz_x1
	cmp	#45000
	bcs	.not_slowtempo
	cmp	#35000
	bcs	.fast
	cmp	#10000
	bcs	.middle
.slow
	km_setval	mre_countupscore,111
	bra	.not_slowtempo
.middle
	km_setval	mre_countupscore,211
	bra	.not_slowtempo
.fast
	km_setval	mre_countupscore,411
.not_slowtempo
;--------------------------------------------
	rts

;---------------------------------------------------------------------
	longa
	longi
kmre_kurukuruscore
	jsr	calc_KurukuruScore
	jsr	call_resultscore
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_kurukurutmwait
	jsr	kmre_kurukuruscore
	dec	mre_tmpTm
	bne	.skip
	inc	mre_scorechart
.skip
	rts

;---------------------------------------------------------------------
	longa
	longi
kmre_ringBGM
	ldx	kx_rank
	km_loblda.l	fan_BGMTbl,x
	KBGM_a

	txa
	asl	a
	tax
	lda.l	fanwaitTmTbl,x
	sta	mre_chartwaittm

	inc	mre_scorechart
	rts
fan_BGMTbl
	db	kbgm_result_fan_S
	db	kbgm_result_fan_A
	db	kbgm_result_fan_B
	db	kbgm_result_fan_C
	db	kbgm_result_fan_D
	db	kbgm_result_fan_E
fanwaitTmTbl
	dw	7*60	;S
	dw	7*60+30	;A
	dw	4*60+30	;B
	dw	2*60+30	;C
	dw	6*60+30	;D
	dw	3*60	;E
;---------------------------------------------------------------------
	longa
	longi
kmre_record

	inc	mre_recordflag
	inc	mre_scorechart
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_reset
	stz	mre_rankflag
	stz	mre_meterflag
	stz	mre_recordflag

	km_stxval	mre_kirarianmtm,0
	km_stxval	mre_kirarianmptr,sprblockanm_Kirari

	inc	mre_scorechart
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_loop
	stz	mre_scorechart
	rts
;---------------------------------------------------------------------
	longa
	longi
kmre_end
	km_setval	mre_scorechart,-1
	rts

;---------------------------------------------------------------------
;*								*
;*			Ranking Check				*
;* Data Bank 7e							*
;---------------------------------------------------------------------
rankmetermax	equ	50

Check_Ranking
	php
	ai16
;* total score = 0 check *
	lda	kw_totalscore1
	ora	kw_totalscore1+2
	bne	.normal
.score0
	stz	mre_meter
	stz	mre_rank
	bra	.end
;---------------------------------------
.normal
	km_setvar	kz_wkdividend_L,mre_totalscore
	km_setvar	kz_wkdividend_H,mre_totalscore_h

	ldy	#5000
	jsl	KDivide_u32u16_l
	km_setvar	mre_meter,kz_wkdividend_L

;* rank meter ga 50 ijyou ka douka Check *
	cmp	#rankmetermax
	bcc	.less_50
	km_setval	mre_meter,rankmetermax
.less_50

	km_setvar	kz_x1,mre_meter
	km_setval	kz_y1,10
	jsl	kdivu16u8_l
	asl	a
	sta	mre_rank

;* meter 1 inc *
	lda	mre_meter
	inc	a
	cmp	#rankmetermax+1
	bcs	.skip
	sta	mre_meter
.skip
;------------------------------------
.End
	plp
	rts

;---------------------------------------------------------------------
;*								*
;*		Display Number [8*8 chr] (3 keta)		*
;*								*
;---------------------------------------------------------------------
	longa
	longi
call_resulttime
	km_setvar	kz_x1,mre_tmpX	;[top x zahyou]
	km_setvar	kz_y1,mre_tmpY	;[top y zahyou]
	km_setval	kz_z1,$93	;[character offset]
	lda	mre_tmpkazu		;[number]
	ldx	#3			;[ketasuu]
	jsr	SetBGNumber_8x8
	rts

;---------------------------------------------------------------------
;*								*
;*		Display Number [8*8 chr] (5 keta)		*
;*								*
;---------------------------------------------------------------------
	longa
	longi
call_resultscore
	km_setvar	kz_x1,mre_tmpXScore	;[top x zahyou]
	km_setvar	kz_y1,mre_tmpYScore	;[top y zahyou]
	km_setvar	kz_wkdividend_L,mre_tmpscore
	km_setvar	kz_wkdividend_H,mre_tmpscore+2
	km_setval	kz_z1,$93	;[character hosei]
	ldx	#6			;[ketasuu]
	jsr	SetBGNumber32_8x8
	rts

;---------------------------------------------------------------------
;*								*
;*		Display Number [16*8] (6 keta)			*
;*								*
;---------------------------------------------------------------------
;**** Total Score ****
	longa
Call_TotalScore
	km_setval	kz_x1,$17	;[top x zahyou]
	km_setval	kz_y1,$19	;[top y zahyou]
	km_setval	kz_z1,$e0	;[character hosei]
	km_setvar	kz_wkdividend_L,mre_TotalScore
	km_setvar	kz_wkdividend_H,mre_TotalScore_H
	ldx	#6			;[ketasuu]
	jsr	SetBGNumber32_8x16
	rts

;---------------------------------------------------------------------
;*								*
;*			Kurukuru Number				*
;*								*
;---------------------------------------------------------------------
	longa
	longi
Calc_KurukuruScore

	lda	mre_KuruKuruTm
	beq	.SetTimer
	dec	a
	sta	mre_KuruKuruTm
	bra	.SetKuruKuruPtr
.SetTimer
	km_setval	mre_KuruKuruTm,2

	lda	mre_KuruKuruPtr
	clc
	adc	#4
	cmp	#10*4
	bne	.skip
	lda	#0
.skip
	sta	mre_KuruKuruPtr
.SetKuruKuruPtr
	ldx	mre_KuruKuruPtr
	lda.l	KuruKuruScore,x
	sta	mre_tmpscore
	lda.l	KuruKuruScore+2,x
	sta	mre_tmpscoreH

;* sound *
	jsr	ksound_score
	rts
KuruKuruScore
	dw	(02468)&WM
	dw	(02468)>>16

	dw	(13579)&WM
	dw	(13579)>>16

	dw	(24680)&WM
	dw	(24680)>>16

	dw	(35791)&WM
	dw	(35791)>>16

	dw	(46802)&WM
	dw	(46802)>>16

	dw	(57913)&WM
	dw	(57913)>>16

	dw	(68024)&WM
	dw	(68024)>>16

	dw	(79135)&WM
	dw	(79135)>>16

	dw	(80246)&WM
	dw	(80246)>>16

	dw	(91357)&WM
	dw	(91357)>>16

;---------------------------------------------------------------------
;*								*
;*			Score Count Up Sound			*
;*								*
;---------------------------------------------------------------------
	longa
	longi
ksound_score
;* sound *
	lda	mre_soundtimer
	beq	.sound
	dec	a
	sta	mre_soundtimer
	bra	.SKIP_Sound
.sound
	km_setval	mre_soundtimer,2
	ksound	total_score
.SKIP_Sound
	rts

;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------


	IFEQ	1
;**** Corneria Damage ****
	km_setval	kz_x1,$1a	;[top x zahyou]
	km_setval	kz_y1,$8	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	lda	kx_CorneriaDamage
	ldx	#3			;[ketasuu]
	jsr	SetBGNumber_8x16

;**** Total Score ****
	longa
	km_setval	kz_x1,$10	;[top x zahyou]
	km_setval	kz_y1,$19	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	km_setvar	kz_wkdividend_L,kw_totalscore1
	km_setvar	kz_wkdividend_H,kw_totalscore1+2
	ldx	#6			;[ketasuu]
	jsr	SetBGNumber32_8x16

;**** Total Time *****
	longa
	km_setval	kz_x1,$17	;[top x zahyou]
	km_setval	kz_y1,$19	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	lda	kx_TotalTime
	ldx	#3			;[ketasuu]
	jsr	SetBGNumber_8x16

;**** Rank *****
	a8
	km_setval	kz_x1,$1b	;[top x zahyou]
	km_setval	kz_y1,$19	;[top y zahyou]
	km_lldx	kx_rank
	lda.l	rankchartbl,x
	sta	kz_z1			;[character]
	jsr	SetScreen_24x16
	a16

;**** planet total kazu ****
	km_setval	kz_x1,$1d	;[top x zahyou]
	km_setval	kz_y1,$0e	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	lda	kx_initplanetkazu
	ldx	#1			;[ketasuu]
	jsr	SetBGNumber_8x16

;**** planet clear kazu ****
	longa
	km_setval	kz_x1,$1b	;[top x zahyou]
	km_setval	kz_y1,$0e	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	lda	kx_planetclearcnt
	ldx	#1			;[ketasuu]
	jsr	SetBGNumber_8x16

;**** battleship total kazu ****
	longa
	km_setval	kz_x1,$10	;[top x zahyou]
	km_setval	kz_y1,$13	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	lda	kx_initbattleshipkazu
	ldx	#1			;[ketasuu]
	jsr	SetBGNumber_8x16

;**** battleship clear kazu ****
	longa
	km_setval	kz_x1,$0e	;[top x zahyou]
	km_setval	kz_y1,$13	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	lda	kx_battleshipclearcnt
	ldx	#1			;[ketasuu]
	jsr	SetBGNumber_8x16

;**** missile tubushi kazu ****
	longa
	km_setval	kz_x1,$15	;[top x zahyou]
	km_setval	kz_y1,$13	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	lda	ecountmissile
	ldx	#3			;[ketasuu]
	jsr	SetBGNumber_8x16

;**** zaco tubushi kazu ****
	longa
	km_setval	kz_x1,$1b	;[top x zahyou]
	km_setval	kz_y1,$13	;[top y zahyou]
	km_setval	kz_z1,0		;[character hosei]
	lda	ecountfighter
	ldx	#3			;[ketasuu]
	jsr	SetBGNumber_8x16

;**** Colour Palette ****
	longa
	jsr	SenryouPalTrans

	rts
rankchartbl
	db	$80
	db	$a0
	db	$a3
	db	$a6
	db	$a9
	db	$ac
	ENDC


;*********************************************************************
;=====================================================================
;*			SOB ROUTINE				*
;*								*
;=====================================================================
;*********************************************************************
;=====================================================================
;*			Palette Change				*
;* mem8 idx16							*
;* data bank = 7e							*
;*colptr_0	:color table pointer (step 32)				*
;*coladr_0	:color table address					*
;*kx_palette :colour data main buffer 512 byte			*
;*kx_palette2:BG palette 4 no tameno colour table buffer		* 
;=====================================================================
pal4adr	equ	4*16*2
pallength	equ	16*2
;-------------------------------------------------
	shorta
	longi
Change_colpalette
	pl_jmp_iftranscoloff	.End

	km_bitcheckscreenflag	bgcolpal	;[SCREEN FLAG]
	beq	.End
;* colour timer set *
;* 3 GAME Flame ni 1 kai colour change *
	dec	coltimer_2
	bne	.NoColChange1
	km_setvar	coltimer_2,coltimermax_2	;Timer reset	(3 fram ni 1 kai)

	a16
	lda	colptr_2
	clc
	adc	#32
	and	#$00ff
	sta	colptr_2
	tax
	a8
;BG colour palette 4 ni colour data (haikei) wo tensou
;;;;	ldx	colptr_2
	ldy	#pal4adr
	km_blocktransXY	kx_palette2,kx_palette,pallength
.NoColChange1
;--------------------------------------------------------------------
.End
	pl_transcol		on

	rts


;=====================================================================
;*			Palette Change				*
;*colptr_0	:color table pointer (step 32)				*
;*coladr_0	:color table address					*
;=====================================================================
mm_changecolpal
	php
	a16
	km_bitcheckgameflag	pauseon
	km_bne	.end
;---------------------------------------------------------------------
	longa
;* taiyou *
	km_bitcheckscreenflag	bgcolpal	;[SCREEN FLAG]
	beq	.NoColChange

	a8
	dec	coltimer_2
	bpl	.NoColChange
	km_setvar	coltimer_2,coltimermax_2	;Timer Reset

	a16
	lda	colptr_2
	clc
	adc	#32
	and	#$00ff
	sta	colptr_2
	tax
	km_blocktransX	kx_palette2,(kx_palette+2*32),32
.NoColChange
	a16
;---------------------------------------------------------------------
;* Corneria *
	LONGA
	km_bitcheckscreenflag	bgcolpal3	;[SCREEN FLAG]
	beq	.NoColChange3
	km_bitcheckmismapflag	corneriafell
	beq	.normal
	km_setval	colptr_3,32*4			;Pointer +32 add
	bra	.set_corneriacolour
;* colour timer set *
.normal
	km_bitcheckmismapstflag	corneriaexplode
	bne	.explode
	lda	kx_CorneriaDamage
	cmp	#corneriaAttentionHP
	bmi	.NoColChange3
.Explode
	a8
	dec	coltimer_3
	bne	.NoColChange3
	km_setvar	coltimer_3,coltimermax_3	;Timer Reset

	a16
	lda	colptr_3
	clc
	adc	#32
	and	#$00ff
	sta	colptr_3
	tax
.set_corneriacolour
	ldx	colptr_3
	km_blocktransX	kx_palette3,(kx_palette+3*32),32
.NoColChange3
	a16
;--------------------------------------------------
;* Senryou Planet *
	jsr	SenryouPalTrans
;--------------------------------------------------
;* Corneria Damage *
	longa
	km_bitcheckmismapstflag	corneriadamage
	beq	.NoChange

	ldx	#6
	lda	kx_CorneriaDamage
	cmp	#corneriaDangerDamage
	bpl	.Set
	ldx	#0
	cmp	#corneriaAttentionDamage
	bmi	.NoChange
.Set
	jsr	SetDamageColour
.NoChange
;--------------------------------------------------
.end
	plp
	rts

;---------------------------------------------------------------------
;*		Corneria Damage Colour				*
;* Input : Xreg <<< Palette Pointer (0,8,16)				*
;---------------------------------------------------------------------
SetDamageColour
	php
	a8
	phb
	db7e
	a16
	ldy	#4*2*16
	lda.l	mm_palettetbl+0,x
	sta.w	kx_palette+2,y
	lda.l	mm_palettetbl+2,x
	sta.w	kx_palette+4,y
	lda.l	mm_palettetbl+4,x
	sta.w	kx_palette+6,y
	plb
	plp
	rts
mm_palettetbl
	dw	$2eff,$2f9f,$57ff
	dw	$1cf6,$1cff,$4a5f

;---------------------------------------------------------------------
;*		Planet Senryou Plarette Transfer		*
;---------------------------------------------------------------------
SenryouPalTrans
	php
	a16
	km_bitcheckscreenflag	objcolpal	;[SCREEN FLAG]
	beq	.NoObjColChange
;* colour timer set *
	a8
	dec	coltimer_4
	bne	.NoObjColChange
	km_setvar	coltimer_4,coltimermax_4	;Timer Reset
	a16
	lda	colptr_4
	sec
	sbc	#32
	and	#$00ff
	sta	colptr_4
	tax
	km_blocktransX	kx_palette4,(kx_palette+15*32),32
.NoObjColChange
	plp
	rts

;---------------------------------------------------------------------
;*								*
;*	Screen Kakiake Buffer ni Scrren Data wo copy		*
;* Init :kz_x1 :data length						*
;*      :a16i16							*
;---------------------------------------------------------------------
kcopyscreen_sub_l
	jsr	kcopyscreen_sub
	rtl

	longa
	longi
kcopyscreen_sub
	phb
	a8
	lda	#$7f
	pha
	plb
	a16
.loop
	lda.l	bitmapdecbase,x
	sta	mmxx_screenbuffer,y
	inx
	inx
	iny
	iny
	dec	kz_x1
	bne	.loop
.end
	plb
	rts


;---------------------------------------------------------------------
;*								*
;*		Clear BG Kakikae Buffer				*
;* Init :kz_x1 :x zahyou						*
;*      :kz_y1 :y zahyou						*
;*      :kz_z1 :character 						*
;*      :kz_tpa:counter						*
;* Temp :Xreg  :buffer pointer					*
;*      :Yreg  :kakikae counter					*
;---------------------------------------------------------------------
Clear_BGKakikaeBuffer_l
	php
	ai16
	km_convSCRaddr_32X

	lda	kz_z1
	ldy	kz_tpa
	beq	.END
.LOOP
	sta.l	mmxx_screenbuffer+0,x
	inx
	inx
	dey
	bne	.LOOP

.END
	plp
	rtl

;---------------------------------------------------------------------
;*								*
;*		Set BG Kakikae Buffer				*
;* Init :kz_x1 :x zahyou						*
;*      :kz_y1 :y zahyou						*
;*      :kz_z1 :character 						*
;*      :kz_tpa:counter						*
;* Temp :Xreg  :buffer pointer					*
;*      :Yreg  :kakikae counter					*
;---------------------------------------------------------------------
Set_BGKakikaeBuffer_l
	php
	ai16
	km_convSCRaddr_32X

	lda	kz_z1
	ldy	kz_tpa
	beq	.END
.LOOP
	sta.l	mmxx_screenbuffer+0,x
	inc	a
	inx
	inx
	dey
	bne	.LOOP
.END
	plp
	rtl
;---------------------------------------------
;* 	Sub Routine 			*
;* Init :kz_x1 :x zahyou			*
;*      :kz_y1 :y zahyou			*
;*      :kz_z1 :character 			*
;---------------------------------------------
	longa
	longi
SetBG_8x8
	km_convSCRaddr_32X
	lda	kz_z1
	sta.l	mmxx_screenbuffer+0,x
	rts

;---------------------------------------------
;* 	Sub Routine 			*
;* Set Order: (...,1000,100,10,1 no jyunban)	*
;* Init :kz_x1 :x zahyou			*
;*      :kz_y1 :y zahyou			*
;*      :kz_z1 :character hosei (Att nashi)	*
;*      :Acc   :Number			*
;*      :Xreg  :Ketasuu			*
;*					*
;* Tmp  :kz_tpx:ketasuu			*
;---------------------------------------------
	longa
	longi
SetBGNumber_8x8_l
	jsr	SetBGNumber_8x8
	rtl

	longa
	longi
SetBGNumber_8x8
	stx	kz_tpx
	jsr	convHextoDecimal
	km_convSCRaddr_32X

	a8
	ldy	#0
.loop
	lda	kx_DecimalBuffer,y
	clc
	adc	kz_z1
	sta.l	mmxx_screenbuffer+0,x	;hidari ue chara
	iny
	inx
	inx
	dec	kz_tpx
	bne	.loop

	a16
	rts

;---------------------------------------------
;* 	Sub Routine 			*
;* Set Order: (...,1000,100,10,1 no jyunban)	*
;* Init					*
;*      :Acc   :Score			*
;*      :Xreg  :ketasuu			*
;*      :kz_x1 :x zahyou			*
;*      :kz_y1 :y zahyou			*
;*      :kz_z1 :character hosei (Att nashi)	*
;*					*
;* Temp :kz_tpx:				*
;---------------------------------------------
	longa
	longi
SetBGNumber_8x16
	stx	kz_tpx
	jsr	convHextoDecimal
	km_convSCRaddr_32X

	a8
	ldy	#0
.loop
	lda	kx_DecimalBuffer,y
	clc
	adc	kz_z1
	sta.l	mmxx_screenbuffer+0,x	;hidari ue chara

	clc
	adc	#$10
	sta.l	mmxx_screenbuffer+64,x	;hidari shita chara
	iny
	inx
	inx
	dec	kz_tpx
	bne	.loop
	a16
	rts


;---------------------------------------------
;* 	Sub Routine 			*
;* Set Order: (...,1000,100,10,1 no jyunban)	*
;* Init :kz_x1 :top x zahyou			*
;*      :kz_y1 :top y zahyou			*
;*      :kz_z1 :character hosei (Att nashi)	*
;*      :kz_tpx:ketasuu			*
;*      :kz_wkdividend_L :Number (l)		*
;*      :kz_wkdividend_H :Number (h)		*
;---------------------------------------------
	longa
	longi
SetBGNumber32_8x8
	stx	kz_tpx
	jsr	convHextoDecimal_32
	km_convSCRaddr_32X

	a8
	ldy	#0
.loop
	lda	kx_DecimalBuffer,y
	clc
	adc	kz_z1
	sta.l	mmxx_screenbuffer+0,x	;hidari ue chara
	iny
	inx
	inx
	dec	kz_tpx
	bne	.loop
	a16
	rts

;---------------------------------------------
;* 	Sub Routine 			*
;* Set Order: (...,1000,100,10,1 no jyunban)	*
;* Init :kz_x1 :top x zahyou			*
;*      :kz_y1 :top y zahyou			*
;*      :kz_z1 :character hosei (Att nashi)	*
;*      :kz_tpx:ketasuu			*
;*      :kz_wkdividend_L :Number (l)		*
;*      :kz_wkdividend_H :Number (h)		*
;---------------------------------------------
	longa
	longi
SetBGNumber32_8x16
	stx	kz_tpx
	jsr	convHextoDecimal_32
	km_convSCRaddr_32X

	a8
	ldy	#0
.loop
	lda	kx_DecimalBuffer,y
	clc
	adc	kz_z1
	sta.l	mmxx_screenbuffer+0,x	;hidari ue chara

	clc
	adc	#$10
	sta.l	mmxx_screenbuffer+64,x	;hidari shita chara
	iny
	inx
	inx
	dec	kz_tpx
	bne	.loop
	a16
	rts

;---------------------------------------------
;* 	Sub Routine 			*
;* Set Order: (...,1000,100,10,1 no jyunban)	*
;* Init :kz_x1 :x zahyou			*
;*      :kz_y1 :y zahyou			*
;*      :kz_z1 :character hosei (Att nashi)	*
;*      :kz_tpx:ketasuu			*
;---------------------------------------------
	longa
	longi
SetBGNumber_16x16
	stx	kz_tpx
	jsr	convHextoDecimal
	km_convSCRaddr_32X

	a8
	ldy	#0
.loop
	lda	kx_DecimalBuffer,y
	cmp	#8
	bmi	.less
	clc
	adc	#$8
.less
	asl	a
	clc
	adc	kz_z1
	sta.l	mmxx_screenbuffer+0,x	;hidari ue chara
	inc	a
	sta.l	mmxx_screenbuffer+2,x	;migi ue chara
	clc
	adc	#$10-1
	sta.l	mmxx_screenbuffer+64,x	;hidari shita chara
	inc	a
	sta.l	mmxx_screenbuffer+66,x	;migi shita chara

	iny

	inx
	inx
	inx
	inx

	dec	kz_tpx
	bne	.loop
	a16
	rts
;=====================================================================
;*		Convert Hex Value to Decimal			*
;* Input	:Acc :Source Value (16 bit)				*
;*	:Xreg :ketasuu						*
;* OutPut	:kx_DecimalBuffer (...,1000,100,10,1 no jyunban)	*
;* Temp Work :kz_textpt						*
;=====================================================================
convHextoDecimal
	PHY
	php

	ai16
	dex
.loop
	phx
	km_ramcpudivu16uf8	xy,10
	stx	kz_textpt
	plx
	a8
	tya
	sta	kx_DecimalBuffer,x
	a16
	lda	kz_textpt
	dex
	bpl	.loop

	plp
	PLY
	rts

;=====================================================================
;*		Convert Hex Value to Decimal			*
;* Input	:kz_wkdividend_L					*
;*	:kz_wkdividend_H					*
;*	:Xreg :ketasuu						*
;* OutPut	:kx_DecimalBuffer (...,1000,100,10,1 no jyunban)	*
;* Temp Work :kz_textpt						*
;=====================================================================
convHextoDecimal_32
	PHY
	php

	ai16
	dex
.loop
	ldy	#10
	jsl	KDivide_u32u16_l
	a8
	sta	kx_DecimalBuffer,x
	a16
	dex
	bpl	.loop

	plp
	PLY
	rts

;=====================================================================
;*			BG Screen Kakikae			*
;* Init :kz_x1 :x zahyou (0~1f)					*
;*      :kz_y1 :y zahyou (0~1f)					*
;*      :kz_z1 :character hosei	(hidari ue hashi)		*
;=====================================================================
	shorta
	longi
SetScreen_16x16
	km_convSCRaddr_32X

	lda	kz_z1
	sta.l	mmxx_screenbuffer+0,x	;hidari ue chara
	inc	a
	sta.l	mmxx_screenbuffer+2,x	;migi ue chara
	clc
	adc	#$10-1
	sta.l	mmxx_screenbuffer+64,x	;hidari shita chara
	inc	a
	sta.l	mmxx_screenbuffer+66,x	;migi shita chara
	rts
;---------------------------------------------------------------------
SetScreen_24x16
	shorta
	longi
	km_convSCRaddr_32X

	lda	kz_z1
	sta.l	mmxx_screenbuffer+0,x	;hidari ue chara
	inc	a
	sta.l	mmxx_screenbuffer+2,x	;
	inc	a
	sta.l	mmxx_screenbuffer+4,x	;
	clc
	adc	#$10-2
	sta.l	mmxx_screenbuffer+64,x	;
	inc	a
	sta.l	mmxx_screenbuffer+66,x	;
	inc	a
	sta.l	mmxx_screenbuffer+68,x	;
	rts


;=====================================================================
;*		Convrt Screen Kakikae Address			*
;* Init :kz_x1	:x zahyou (0~$1f)				*
;       :kz_y1	:y zahyou (0~$1f)				*
;* Out  :Xreg	:address  (0~$7ff)				*
;=====================================================================
KconvSCRAddr32X
	php
	longi

	a8
	lda	kz_y1
	sta.l	wrmpya
	lda	#$20	;Screen DATa Address
	sta.l	wrmpyb

	nop	;wait
	nop	;wait
	nop	;wait
	nop	;wait

	a16
	km_loblda	kz_x1
	clc
	adc.l	rdmpylr
	asl	a
	tax
	plp
	rts

;=====================================================================
;*		Convrt Screen Check Address			*
;* Init :kz_x1	:x zahyou (0~$1f)				*
;       :kz_y1	:y zahyou (0~$1f)				*
;* Out  :Xreg	:address  (0~$3ff)				*
;=====================================================================
KconvSCRCheckAddr32X
	php
	jsr	KconvSCRAddr32X

	a16
	txa
	lsr	a
	tax

	plp
	rts


;=====================================================================
;*								*
;*			BG (CGX,SCR) KAKIKAE			*
;*								*
;=====================================================================
SetCockpitCharacter
;---------------------------------------------------------------------
;*			Radar Screen Change			*
;* Data Bank 7E							*
;* Xreg :player work pointer						*
;---------------------------------------------------------------------
RadarScreen
	ifeq	1
	shorta
	longi
;--------- Check Radar Mode Change ---------
	testjoypad	select
	beq		.nextcheck1

	eorflag.l	KRadarFlag,#P1radmodeFl
	setflag.l	KRadarFlag,#P1radScChFl
.nextcheck1
	testjoypad2	select
	beq		.SetRADSCR
	eorflag.l	KRadarFlag,#P2radmodeFl
	setflag.l	KRadarFlag,#P2radScChFl
.SetRADSCR
	KRDSCR_P1	1
	KRDSCR_p2	2
	a8
;---------------------------------------------------------------------
;*			BOOST Meter Display			*
;* Data Bank 7e							*
;* X reg :player work pointer					*
;* Attention :tensoumoto tensouski no set ni tyuui			*
;*	:tensousaki wo saki ni set (x register)			* 
;---------------------------------------------------------------------
BoostMeter
	shorta
	longi
	phx
	lda	exal_boost,x
	bmi	.BoostOn		;If 	 Boost On
	jmp	.BoostEnd		;elseif  Boost Off
;------------------------------------------------------------------
.BoostOn
	and	#%00111111
	cmp	#40
	bpl	.check1
	jmp	.ChangMeter	;if HP < 40 then HP meter set
.check1	beq	.FullHP		;if HP = 40 then HP meter Full display
 	jmp	.BoostEnd	;if HP > 40 then not character change
;------------------------------------------------------------------
.FullHP
	ifeq	1
	KcopyBitmapFixChr	8,$6f,32
	KcopyBitmapFixChr	8,$70,32
	KcopyBitmapFixChr	8,$71,32
	KcopyBitmapFixChr	8,$72,32
	KcopyBitmapFixChr	8,$73,32
	endc
 	jmp	.BoostEnd
;------------------------------------------------------------------
.ChangMeter
	km_jmpflag_a	%00000111,.BoostPatern1to7  ;If 8 no baisuu de nakereba
	km_bitcheckflag	exal_boost,BoostSign,x
	bne	.BoostPatern8			;If Meter Inc
;------------------------------------------------------------------
.BoostPatern0
;Boost Character Patern 0
;Boost Dec Meter = (40,32,24,16,8)
	a16
	lda	exal_boost,x
	and	#$3f
	km_divu8
	clc
	adc	#BmBoost
	tay			;tensou saki

	lda	#0
	clc
	adc	#RomBoost
	tax			;tensou moto
	jmp	.SetBoost
;------------------------------------------------------------------
.BoostPatern8
;Boost Character Patern 8
;Boost Inc Meter = (8,16,24,32,40)
	a16

	lda	exal_boost,x
	and	#$3f
	beq	.BoostMeterZero
	km_divu8
	dec	a
	clc
	adc	#BmBoost	;tensou saki
	tay

	lda	#8
	clc
	adc	#RomBoost
	tax			;tensou moto
	jmp	.SetBoost
;------------------------------------------------------------------
.BoostMeterZero
;Boost Character Patern 0
;Boost Meter =0
	ldx	#RomBoost
	ldy	#BmBoost
	jmp	.SetBoost
;------------------------------------------------------------------
.BoostPatern1to7
;Boost Character Patern from 1 to 8
;Case Boost Meter Inc & Dec
	a16

	lda	exal_boost,x
	and	#$3f
	km_divu8
	clc
	adc	#BmBoost
	tay			;tensou saki

	lda	exal_boost,x
	and	#7
	clc
	adc	#RomBoost
	tax			;tensou moto
;------------------------------------------------------------------
.SetBoost
	KcopyBitMapChr_xy	32
;------------------------------------------------------------------
.BoostEnd
	plx
	a8
;---------------------------------------------------------------------
;*			DAMAGE Meter				*
;* Data Bank 7E							*
;* X reg : player work pointer					* 
;* KHP   : Max 10 :b7 (flag),b3-b6 (integer HP),b0-b2 (decimal HP)	*
;---------------------------------------------------------------------
DAMAGE
	shorta
	longi

;==== Check hit damage ====
	km_jmpnotflag	KHP,kdmgflag,.NoDamage,X
;==== HP Meter Copy =====
.SetHP
	phx
	phy

	lda	#0
	xba

	lda	khp,x
	pha
	and	#%00000111
	tax
	lda.l	HPtable,x
	tax			;ROM pointer

	pla
	and	#kdmgflag^(-1)
	km_shiftRUA3
	clc
	adc	#BmDMGMT
	tay			;Mario RAM Character Pointer

	KcopyBitMapChr_xy	32

	ply
	plx
	km_clrflag		KHP,kdmgflag,x
.NoDamage
	a8
;---------------------------------------------------------------------
;*		GAME Score Meter 				*
;* Data Bank 7E							*
;* X reg : player work pointer					* 
;---------------------------------------------------------------------
SCORE
	phx
	phy

	ai16
	lda	kscore,x
	bne	.Score1
	jmp	.SCOREend
.Score1
	km_cpudivu16uf8_xy	10	;Init:Acc
				;Exit:x:syou,y:amari
	tya
	kcopyBitMapChr_a	ROMscore,BmSCORE+4,32
	cpx	#0		;shouno check
	bne	.Score10	;if syou = 0 then spr display end
	jmp	.SCOREend
.Score10
	txa
	km_cpudivu16uf8_xy	10	;Init:Acc ,Exit:x:syou,y:amari
	tya
	kcopyBitMapChr_a	ROMscore,BmSCORE+3,32
	cpx	#0
	bne	.Score100	;if syou = 0 then spr display end
	jmp	.SCOREend
.Score100
	txa
	km_cpudivu16uf8_xy	10	;Init:Acc ,Exit:x:syou,y:amari
	tya
	kcopyBitMapChr_a	ROMscore,BmSCORE+2,32
	cpx	#0
	bne	.Score1000	;if syou = 0 then spr display end
	jmp	.SCOREend
.Score1000
	txa
	km_cpudivu16uf8_xy	10	;Init:Acc 
				;Exit:x:syou,y:amari
	tya
	kcopyBitMapChr_a	ROMscore,BmSCORE+1,32
	cpx	#0		;syou no check
	bne	.Score10000	;if syou = 0 then spr display end
	jmp	.SCOREend
.Score10000
	txa
	km_cpudivu16uf8_xy	10	;Init:Acc 
				;Exit:x:syou,y:amari
	tya
	kcopyBitMapChr_a	ROMscore,BmSCORE+0,32
.SCOREend
	a8
	ply
	plx

	ENDC
	rts


;=====================================================================
;*			Color Flashing				*
;* Color Kakikae							*
;* Data Bank 7e							*
;* Xreg :player work pointer						*
;=====================================================================
	IFEQ	1
SetCockpitColor
	shorta
	phx
	i8
	lda	FlashTimer
	bne	.ColorFlashEND

	lda	#1
	sta	FlashTimer	;flashing timer reset

	lda	ColFlPnt
	inc	a
	inc	a
	cmp	#8
	bne	.skip
	lda	#0
.skip
	sta	ColFlPnt
	tax			;Color Pointer change

	a16
	lda.l	GreenFlTable,x
	sta	Grcolbuf_0

	lda.l	BlueFlTable,x
	sta	Blcolbuf_0

	lda.l	RedFlTable,x
	sta	Recolbuf_0

	lda.l	YellowFlTable,x
	sta	Yecolbuf_0
	a8
.ColorFlashEND
	i16
	plx
	rts
;---------------------------------------------------------------------
BlueFlTable
;	dw	$7ff1,$7f60,$7e80,$7f60
	dw	$7fe7,$7f40,$7ea0,$7f40
RedFlTable
;	dw	$47ff,$033f,$027f,$033f
	dw	$1dbf,$14ff,$0437,$14ff
YellowFlTable
;	dw	$56bf,$299f,$18d9,$299f
	dw	$03ff,$037b,$02f7,$037b
GreenFlTable
	dw	$17e5,$1b86,$0f23,$1b86

	ENDC


;*****************************************************************************
;*									*
;*		Polygon BG Border Screen Set	[28*24 screen size]	*
;*									*
;*****************************************************************************
;-------------------------------------------------------------------
kgameNum_col		equ	28
kgameNum_row		equ	24

kvchr_base1		equ	0
kvsc_base1		equ	22*k/2
kvchr_base2		equ	24*k/2
kvchr_physback	equ	40*k/2
kvchr_logback	equ	46*k/2
kvobj_base		equ	52*k/2
kvsc_base2		equ	56*k/2
kbg2offsets		equ	vsc_base1+32*28

knum_col	equ	28
knum_row	equ	24
kgameStRow	equ	2
;-------------------------------------------------------------------
KSetBorderScreen_2824
	IFEQ	1
	shorta
	longi
	lda	#128
	sta	vmainc

	a16
	lda	#kvsc_base1+32*kgameStRow   ;For fast 2 chr Line Blanking
	sta	vmaddl		;(0+2*32)
	lda	#1024*colpal7
	ldy	#0
;------------------------------------------------------------------------
;* saisyo no 2 char wo MASK suru !! *
.lolv
	pha
	lda	#kgamenum_col*kgamenum_row+(6<<10)
	rept	(32-kgamenum_col)/2		;clear out borders
	sta	vmdatal
	endr
	pla
;------------------------------------------------------------------------
;* aida no 28 no bit map screen wo shiku 
	ldx	#0
.lolh	sta	vmdatal
	clc
	adc	#kgamenum_row
	inx
	cpx	#kgamenum_col
	bne	.lolh
;------------------------------------------------------------------------
;* saigo no 2 char wo MASK suru !! *
	pha
	lda	#kgamenum_col*kgamenum_row+(6<<10)
	rept	(32-kgamenum_col)/2
	sta	vmdatal
	endr
	pla
;------------------------------------------------------------------------
	sec
	sbc	#kgamenum_col*kgamenum_row-1
	iny
	cpy	#kgamenum_row
	bne	.lolv
	a8
	ENDC
	rts
;**************************************************************************
;**************************************************************************
;**************************************************************************
;=============================================================
;*			Pause Window		[PAUSE]	* 
;=============================================================
	ifeq	1
PauseWindow
	shorta
	longi

	phx
	phy
	ldy	#0	;HDMA Table Pointer

	ifeq	0
;======== Player 1 Window Flash =======
	jmpnotgameflag	p12pauseflag,.PauseWindowEnd
;------- Player 1 HDMA Data Copy ------
.PauseWindowP1

	KHDMATbl	y,#(P1WinYSta-1),#NoWinXSta,#NoWinXEnd,pausehofs
	KHDMATbl	y,#(P1WinYEnd)-(P1WinYSta),#P1HtFlXSta,#P1HtFlXEnd,pausehofs
.PauseWindowP2
	KHDMATbl	y,#LineNumber8,#NoWinXSta,#NoWinXEnd,pausehofs
	KHDMATbl	y,#(P2WinYEnd)-(P2WinYSta),#P2WinXSta,#P2WinXEnd,pausehofs
.FlashEnd
	KHDMAtblEND	y,pausehofs	;Set HDMA dummy data
	endc

	ifeq	1
;======== Player 1 Window Flash =======
	jmpgameflag	p1pauseflag,.PauseWindowP1
	jmpnotgameflag	p2pauseflag,.PauseWindowEnd

.PauseWindowP2Only
	KHDMATbl	y,#(P2WinYSta-1),#NoWinXSta,#NoWinXEnd,pausehofs
	KHDMATbl	y,#(P2WinYEnd)-(P2WinYSta),#P2HtFlXSta,#P2HtFlXEnd,pausehofs
	jmp	.FlashEnd
;------- Player 1 HDMA Data Copy ------
.PauseWindowP1

	KHDMATbl	y,#(P1WinYSta-1),#NoWinXSta,#NoWinXEnd,pausehofs
	KHDMATbl	y,#(P1WinYEnd)-(P1WinYSta),#P1HtFlXSta,#P1HtFlXEnd,pausehofs

	jmpnotgameflag	p2pauseflag,.FlashEnd
.PauseWindowP2
	KHDMATbl	y,#LineNumber8,#NoWinXSta,#NoWinXEnd,pausehofs
	KHDMATbl	y,#(P2WinYEnd)-(P2WinYSta),#P2WinXSta,#P2WinXEnd,pausehofs
.FlashEnd
	KHDMAtblEND	y,pausehofs	;Set HDMA dummy data
	endc

;============ Window Register Para Set ===============
	alloc_window	pausewindow,1	; x = hitfalsh

	lda	#%00000011
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#%00010000
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda	#%11000011
	sta	wm_cgadsub,x	;2131h	;1/2 bg1 bg2

	lda	#$23
	sta	wm_coldata_r,x	;2132h	;Red

	lda	#$43
	sta	wm_coldata_g,x	;2132h	;Green

	lda	#$83
	sta	wm_coldata_b,x	;2132h	;Blue

	ldy	#xhdma_pausehofs&WM
	sty	wm_hdma,x	;4302h,4303h	:hdma table address
	lda	#xhdma_pausehofs>>16
	sta	wm_hdma+2,x	;4304h		:hdma table address
;-------------------------------------------------------------------------
.PauseWindowEnd
	ply
	plx
	a8
	rts
	endc


	ifeq	1
RingOutWindow
	shorta
	longi

	ldy	#0	;HDMA Table Pointer
;======== Player 1 Window Flash =======
	km_plheapptr	1,x
	jmpflag		KRingOutTimer,#KROutFlag,.Pl1Flash,x
	km_plheapptr	2,x
	jmpnotflag	KRingOutTimer,#KROutFlag,.RingOutWindowOff,x
.Pl2FlashOnly
	KHDMATbl	y,#(P2WinYSta-1),#NoWinXSta,#NoWinXEnd,outhofs
	KHDMATbl	y,#(P2WinYEnd)-(P2WinYSta),#P2HtFlXSta,#P2HtFlXEnd,outhofs
	jmp	.FlashEnd
;------- Player 1 HDMA Data Copy ------
.Pl1Flash
	KHDMATbl	y,#(P1WinYSta-1),#NoWinXSta,#NoWinXEnd,outhofs
	KHDMATbl	y,#(P1WinYEnd)-(P1WinYSta),#P1HtFlXSta,#P1HtFlXEnd,outhofs

	km_plheapptr	2,x
	jmpnotflag	KRingOutTimer,#KROutFlag,.FlashEnd,x
.P2Flash
	KHDMATbl	y,#LineNumber8,#NoWinXSta,#NoWinXEnd,outhofs
	KHDMATbl	y,#(P2WinYEnd)-(P2WinYSta),#P2WinXSta,#P2WinXEnd,outhofs
.FlashEnd
	KHDMAtblEND	y,outhofs	;Set HDMA dummy data

;============ Window Register Para Set ===============
	alloc_window	outofbounds,1	; x = outofbounds
	km_plheapptr	1,y		; y = player work pointer

	lda	#%00000011
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#%00010000
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda	#%10000011
	sta	wm_cgadsub,x	;2131h	;col sub (bg1,bg2)

	ifeq	0
	lda.w	kringouttimer,y
	eor	#$ff
	and	#$0f
	ora	#%11100000
	sta	wm_coldata,x	;2132h	;Red Blue Green
	endc

	ifeq	1
	lda.w	kringouttimer,y
	eor	#$ff
	and	#$0f
	ora	#$20
	sta	wm_coldata_r,x	;2132h	;Red

	lda.w	kringouttimer,y
	eor	#$ff
	and	#$0f
	ora	#$40
	sta	wm_coldata_g,x	;2132h	;Green

	lda.w	kringouttimer,y
	eor	#$ff
	and	#$0f
	ora	#$80
	sta	wm_coldata_b,x	;2132h	;Blue
	endc

	ldy	#xhdma_outhofs&WM
	sty	wm_hdma,x	;4302h,4303h	:hdma table address
	lda	#xhdma_outhofs>>16
	sta	wm_hdma+2,x	;4304h		:hdma table address

	jmp	.RingOutWindowEnd

.RingOutWindowOff
	dealloc_window	outofbounds,1	;if Ring Out Window End

.RingOutWindowEnd

;---------------------------------------------------------------------
;*			Hit Flash Window			* 
;* Init,Exit Memory Mode :mem8,idx16					*
;* Data Bank 7e							*
;* Yreg : HDMA table pointer 					*
;---------------------------------------------------------------------
HitFlashWindow
	shorta
	longi

	ldy	#0	;HDMA Table Pointer
;======== Player 1 Window Flash =======
	km_plheapptr	1,x
	s_jmp_alvarNOTzero	B,x,exal_nohit,.Pl1Flash
	km_plheapptr	2,x
	s_jmp_alvarzero		B,x,exal_nohit,.HitFlashWindowOff
.Pl2FlashOnly
	KHDMATbl	y,#(P2WinYSta-1),#NoWinXSta,#NoWinXEnd,htflhofs
	KHDMATbl	y,#(P2WinYEnd)-(P2WinYSta),#P2HtFlXSta,#P2HtFlXEnd,htflhofs
;;;;;	KHDMAtblEND	y,htflhofs
	jmp	.FlashEnd
;------- Player 1 HDMA Data Copy ------
.Pl1Flash
	KHDMATbl	y,#(P1WinYSta-1),#NoWinXSta,#NoWinXEnd,htflhofs
	KHDMATbl	y,#(P1WinYEnd)-(P1WinYSta),#P1HtFlXSta,#P1HtFlXEnd,htflhofs

	km_plheapptr	2,x
	s_jmp_alvarzero	B,x,exal_nohit,.FlashEnd
.P2Flash
	KHDMATbl	y,#LineNumber8,#NoWinXSta,#NoWinXEnd,htflhofs
	KHDMATbl	y,#(P2WinYEnd)-(P2WinYSta),#P2WinXSta,#P2WinXEnd,htflhofs
.FlashEnd
	KHDMAtblEND	y,htflhofs	;Set HDMA dummy data
;============ Window Register Para Set ===============
	alloc_window	hitflash,1	; x = hitfalsh


	lda	#00000011b
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#00010000b
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda	#00000011b
	sta	wm_cgadsub,x	;2131h	;bg1 bg2

	lda	#$03f
	sta	wm_coldata_r,x	;2132h	;Red

	lda	#$40
	sta	wm_coldata_g,x	;2132h	;Green

	lda	#$84
	sta	wm_coldata_b,x	;2132h	;Blue

	ldy	#xhdma_htflhofs&WM
	sty	wm_hdma,x	;4302h,4303h	:hdma table address
	lda	#xhdma_htflhofs>>16
	sta	wm_hdma+2,x	;4304h		:hdma table address

	jmp	.HitFlashWindowEnd
.HitFlashWindowOff
	dealloc_window	hitflash,1	;if Hit Flash End
.HitFlashWindowEnd
;---------------------------------------------------------------------
;*			Circle Window				* 
;---------------------------------------------------------------------
CircleWindow
	ldy	#0
;=============== Player1 Circle Window Enable check ==============
	km_plheapptr	1,x
	jmpflag	KBOMSHOT,#kBomShotFlag,.Pl1CirWindow,x
	km_plheapptr	2,x
	jmpnotflag	KBOMSHOT,#kBomShotFlag,.SetWindowEND,x
	KHDMATbl	y,#(P2WinYSta-1),#NoWinXSta,#NoWinXEnd,circhofs
	jmp		.SetP2Window
.Pl1CirWindow
;------- Cilcle calculate --------
	a16
	lda	KBOMSHOT,x
	and	#$7f
	asl	a
	tax

	lda	#$68
	sta.l	m_bigx		;center X
	lda	#$40
	sta.l	m_bigy		;center Y

	lda.l	CircleData,x
	sta.l	m_rotx		;Radius

	call_mario	mcalc_circle	;Circle (L,R) data calc
;------- HDMA Data Copy ------
	a8
	KHDMATbl	y,#(P1WinXSta-1),#NoWinXSta,#NoWinXEnd,circhofs
	KHDMACilcleTbl	#(P1WinYEnd-P1WinYSta),#P1WinXSta,#P1WinXEnd,#P1WinYSta,#P1WinYEnd

	km_plheapptr	2,x
	jmpnotflag	KBOMSHOT,#kBomShotFlag,.SetWinLastDt,x

	KHDMATbl	y,#LineNumber8,#NoWinXSta,#NoWinXEnd,circhofs
;======= player2 window =======
.SetP2Window
	a16
	ldx	#viewblk2
	lda	al_ptr,x
	tax
	lda	al_sword2,x
	tax
	lda	KBOMSHOT,x
	and	#$7f
	asl	a
	tax

	lda	#$98
	sta.l	m_bigx	;center X
	lda	#$a8
	sta.l	m_bigy	;center Y

	lda.l	CircleData,x
	sta.l	m_rotx	;Radius

	call_mario	mcalc_circle
;------- HDMA Data Copy ------
	a8
	KHDMACilcleTbl	#(P2WinYEnd)-(P2WinYSta),#P2WinXSta,#P2WinXEnd,#P2WinYSta,#P2WinYEnd
.SetWinLastDt
	KHDMAtblEND	y,circhofs	;Set hdma (dummy & End code) data
;============ Window Register Para Set ===============
	alloc_window	circle,1	; x = window

	lda	#00000011b
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#00010000b
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda	#00000011b
	sta	wm_cgadsub,x	;2131h	;bg1 bg2

	lda	#$3f
	sta	wm_coldata_r,x	;2132h	;Red

	lda	#$45
	sta	wm_coldata_g,x	;2132h	;Green

	lda	#$9f
	sta	wm_coldata_b,x	;2132h	;Blue

	ldy	#xhdma_circhofs&WM
	sty	wm_hdma,x	;4302h,4303h	:hdma table address
	lda	#xhdma_circhofs>>16
	sta	wm_hdma+2,x	;4304h		:hdma table address
	jmp	.SetWindowEND
.CircleWindowEnd
	dealloc_window	circle,1
;---------------------------------------------------------------------------
.SetWindowEND
	a8i16
	rts
	endc

;*********************************************************************
;*		Radar Screen Charcter Copy SubRoutine		*
;*********************************************************************
KcopyRdScChr_sub
	longa
	longi
	ifeq	1
	lda	#32-1
	db	$54
	db	bitmapbase>>16
	db	bg11_cgx>>16
	endc
	rts

;***************************************************************************

	incfile ASM\kscrdata.asm

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************


;*********************************************************************
;*								*
;*		SCREEN Transfer Method				*
;*********************************************************************
	ifeq	1
;---------------------------------------------------------------------
;*			GAME Timer Display			*
;---------------------------------------------------------------------
	ifeq	1
	shorta
	longi

;======== BG change Check =======
	lda.l	SecondTimer
	beq	.NoFlash	;if 1 second past
	cmp	#second/2
	beq	.SetFlash	;if half second past
	jmp	.TimerSetEnd
;======== Timer Flashing ========
.SetFlash
	KcopyBitMapFixChr	RSmcolFl,BmTmsemcol,32
	jmp	.TimerSetEnd
.NoFlash
	lda	#second
	sta.l	SecondTimer	;1sec counter reset
	KcopyBitMapFixChr	RSmcolNoFl,BmTmsemcol,32
;======= Time Change ============
.TimeSet
;-------- Calclate Game Time ---------------
	ai16
	lda.l	GameTimer
	dec	a
	bpl	.not_minus

	lda	#0
.not_minus
	sta.l	GameTimer

;-------- Convert 60 Min&60 sec --------
	kdivu16u8	xy,#60
	stx	kwork+0		;syou
	tya			;amari
	kdivu16u8	work,#10
				;ksyou	;10 sec
				;kamari	:01 sec
;1 seconds
	lda	kamari
	kcopyBitMapChr	RTmtop,Bmtm01sec,32

	lda	kamari
	cmp	#9
	beq	.Set10sec	;If 10 sec set
	jmp	.TimerSetEnd
;10 seconds
.Set10sec
	lda	ksyou
	kcopyBitMapChr	RTmtop,Bmtm10sec,32

	lda	ksyou
	cmp	#5
	beq	.Set01min	;If 01 min set
	jmp	.TimerSetEnd
.Set01min

	lda	kwork+0
	kdivu16u8	work,#10
				;ksyou	;10 min
				;kamari	:01 min
;1 minutes
	lda	kamari
	kcopyBitMapChr	RTmtop,Bmtm01min,32

	lda	kamari
	cmp	#9
	beq	.Set10min
	jmp	.TimerSetEnd
.Set10min
;10 minutes
	lda	ksyou
	kcopyBitMapChr	RTmtop,Bmtm10min,32

.TimerSetEnd
	a8
	endc
;---------------------------------------------------------------------
;*			GAME Timer Display			*
;---------------------------------------------------------------------
;************************* Screen Change Version ***********************
	ifeq	1
;------- Player 1 x,y,rot y ---------
	lda.l	SecondTimer
	beq	.SetTimer	;if 1 second past
	cmp	#second/2
	bne	.skip		;if not half second past

;======== Timer Flashing ========
	a16
	calcbgchar	timerchar,$2b,0,1,0
	lda	#timerchar
	sta.l	GtmScrChBuf+04
.skip
	jmp	.TimerSetEnd
.SetTimer
	shorta
	lda	#second
	sta.l	SecondTimer	;counter reset
;-------- timer flashing ---------
	a16
	calcbgchar	timerchar,$2c,0,1,0
	lda	#timerchar
	sta.l	GtmScrChBuf+04
;-------- Time Set ---------------
	lda.l	GameTimer
	dec	a
	bpl	.not_minus
	
	lda	#0
.not_minus
	sta.l	GameTimer

;---------- Display Time to screen buffer set -----------

	kdivu16u8	xy,#60

	sty	kwork+0		;amari

	txa			;syou
	kdivu16u8	xy,#10
;10 minutes

	txa
	asl	a
	tax
	lda.l	timertable,x
	sta.l	GtmScrChBuf+0

;1 minutes
	tya
	asl	a
	tax

	lda.l	timertable,x
	sta.l	GtmScrChBuf+2

	lda	kwork+0
	kdivu16u8	xy,#10
;10 seconds
	txa
	asl	a
	tax
	lda.l	timertable,x
	sta.l	GtmScrChBuf+6
;1 seconds

	tya
	asl	a
	tax
	lda.l	timertable,x
	sta.l	GtmScrChBuf+8
.TimerSetEnd
	endc
;---------------------------------------------------------------------
;*			BOOST Meter Display			*
;---------------------------------------------------------------------
;======================= Screen Transfer =============================
	ifeq	1
;======= Player1 ========
	ldx	#40*10
	lda	player1_boost
	bpl	.skip
	and	#%00111111
	kmultu8uf7	x,#10	;boost chara pointer
.skip
	a16
	lda.l	boosttable,x
	sta.l	Bo1ScrChBuf+0
	lda.l	boosttable+2,x
	sta.l	Bo1ScrChBuf+2
	lda.l	boosttable+4,x
	sta.l	Bo1ScrChBuf+4
	lda.l	boosttable+6,x
	sta.l	Bo1ScrChBuf+6
	lda.l	boosttable+8,x
	sta.l	Bo1ScrChBuf+8
	a8
;======= Player2 ========
.player2
	shorta
	LDX	#40*10
	lda	player2_boost
	bpl	.SKIP2
	and	#%00111111
	kmultu8uf7	x,#10	;boost chara pointer
.SKIP2
	a16
	lda.l	boosttable,x
	sta.l	Bo2ScrChBuf+0
	lda.l	boosttable+2,x
	sta.l	Bo2ScrChBuf+2
	lda.l	boosttable+4,x
	sta.l	Bo2ScrChBuf+4
	lda.l	boosttable+6,x
	sta.l	Bo2ScrChBuf+6
	lda.l	boosttable+8,x
	sta.l	Bo2ScrChBuf+8
	a8
	endc
;---------------------------------------------------------------------
;*		Radar CGX Data Copy 				*
;---------------------------------------------------------------------
KRDSCR_P1	macro	[pl]

	jmpnotflag.l	KRadarFlag,#P{pl}radScChFl,.P{pl}end
	jmpflag.l	KRadarFlag,#P{pl}radmodeFl,.P{pl}relative
	phb
	a16
;------ Player absolute radar ---------
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$0
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$1
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$2
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$3

	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$4
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$5
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$6
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$7

	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$8
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$9
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$a
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$b

	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$c
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$d
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$e
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$f

	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$10
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$11
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$12
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$13

	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$14
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$15
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$16
	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$17

	kcopyRdScChr	$9,BmBase_cgx+BmP1Rd_cgx+$18
	plb
	a8
	jmp	.p{pl}clsflag
.p{pl}relative
	phb
	a16
;------- relative radar -------
	kcopyRdScChr	$09,BmBase_cgx+BmP1Rd_cgx+$0
	kcopyRdScChr	$50,BmBase_cgx+BmP1Rd_cgx+$1
	kcopyRdScChr	$51,BmBase_cgx+BmP1Rd_cgx+$2
	kcopyRdScChr	$52,BmBase_cgx+BmP1Rd_cgx+$3
	kcopyRdScChr	$0a,BmBase_cgx+BmP1Rd_cgx+$4

	kcopyRdScChr	$53,BmBase_cgx+BmP1Rd_cgx+$5
	kcopyRdScChr	$54,BmBase_cgx+BmP1Rd_cgx+$6
	kcopyRdScChr	$4e,BmBase_cgx+BmP1Rd_cgx+$7
	kcopyRdScChr	$55,BmBase_cgx+BmP1Rd_cgx+$8
	kcopyRdScChr	$56,BmBase_cgx+BmP1Rd_cgx+$9

	kcopyRdScChr	$57,BmBase_cgx+BmP1Rd_cgx+$a
	kcopyRdScChr	$4e,BmBase_cgx+BmP1Rd_cgx+$b
	kcopyRdScChr	$58,BmBase_cgx+BmP1Rd_cgx+$c
	kcopyRdScChr	$59,BmBase_cgx+BmP1Rd_cgx+$d
	kcopyRdScChr	$5a,BmBase_cgx+BmP1Rd_cgx+$e

	kcopyRdScChr	$5b,BmBase_cgx+BmP1Rd_cgx+$f
	kcopyRdScChr	$4e,BmBase_cgx+BmP1Rd_cgx+$10
	kcopyRdScChr	$4e,BmBase_cgx+BmP1Rd_cgx+$11
	kcopyRdScChr	$4e,BmBase_cgx+BmP1Rd_cgx+$12
	kcopyRdScChr	$5c,BmBase_cgx+BmP1Rd_cgx+$13

	kcopyRdScChr	$0b,BmBase_cgx+BmP1Rd_cgx+$14
	kcopyRdScChr	$5d,BmBase_cgx+BmP1Rd_cgx+$15
	kcopyRdScChr	$5e,BmBase_cgx+BmP1Rd_cgx+$16
	kcopyRdScChr	$5f,BmBase_cgx+BmP1Rd_cgx+$17
	kcopyRdScChr	$0c,BmBase_cgx+BmP1Rd_cgx+$18
	plb
	a8
.p{pl}clsflag
	clsflag.l	KRadarFlag,#P{pl}radScChFl
.p{pl}end
	endm
;**********************************************************************
KRDSCR_P2	macro	[pl]
	shorta
	longi

	jmpnotflag.l	KRadarFlag,#P{pl}radScChFl,.P{pl}end
	jmpflag.l	KRadarFlag,#P{pl}radmodeFl,.P{pl}relative
	phb
	ai16
;------ Player absolute radar ---------
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$0
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$1
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$2
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$3
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$4
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$5
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$6
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$7
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$8
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$9
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$a
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$b
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$c
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$d
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$e
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$f
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$10
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$11
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$12
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$13
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$14
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$15
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$16
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$17
	kcopyRdScChr	$19,BmBase_cgx+BmP2Rd_cgx+$18
	plb
	a8
	jmp	.p{pl}clsflag
.p{pl}relative
	phb
	ai16
;------- relative radar -------
	kcopyRdScChr	$09,BmBase_cgx+BmP2Rd_cgx+$0
	kcopyRdScChr	$50,BmBase_cgx+BmP2Rd_cgx+$1
	kcopyRdScChr	$51,BmBase_cgx+BmP2Rd_cgx+$2
	kcopyRdScChr	$52,BmBase_cgx+BmP2Rd_cgx+$3
	kcopyRdScChr	$0a,BmBase_cgx+BmP2Rd_cgx+$4

	kcopyRdScChr	$53,BmBase_cgx+BmP2Rd_cgx+$5
	kcopyRdScChr	$54,BmBase_cgx+BmP2Rd_cgx+$6
	kcopyRdScChr	$4e,BmBase_cgx+BmP2Rd_cgx+$7
	kcopyRdScChr	$55,BmBase_cgx+BmP2Rd_cgx+$8
	kcopyRdScChr	$56,BmBase_cgx+BmP2Rd_cgx+$9

	kcopyRdScChr	$57,BmBase_ase_cgx+BmP2Rd_cgx+$a
	kcopyRdScChr	$4e,BmBase_cgx+BmP2Rd_cgx+$b
	kcopyRdScChr	$58,BmBase_cgx+BmP2Rd_cgx+$c
	kcopyRdScChr	$59,BmBase_cgx+BmP2Rd_cgx+$d
	kcopyRdScChr	$5a,BmBase_cgx+BmP2Rd_cgx+$e

	kcopyRdScChr	$5b,BmBase_cgx+BmP2Rd_cgx+$f
	kcopyRdScChr	$4e,BmBase_cgx+BmP2Rd_cgx+$10
	kcopyRdScChr	$4e,BmBase_cgx+BmP2Rd_cgx+$11
	kcopyRdScChr	$4e,BmBase_cgx+BmP2Rd_cgx+$12
	kcopyRdScChr	$5c,BmBase_cgx+BmP2Rd_cgx+$13

	kcopyRdScChr	$0b,BmBase_cgx+BmP2Rd_cgx+$14
	kcopyRdScChr	$5d,BmBase_cgx+BmP2Rd_cgx+$15
	kcopyRdScChr	$5e,BmBase_cgx+BmP2Rd_cgx+$16
	kcopyRdScChr	$5f,BmBase_cgx+BmP2Rd_cgx+$17
	kcopyRdScChr	$0c,BmBase_cgx+BmP2Rd_cgx+$18
	plb
	a8
.p{pl}clsflag
	shorta
	clsflag.l	KRadarFlag,#P{pl}radScChFl
.p{pl}end
	endm
;*********************************************************************
KBOOST	macro	[pl]
	a8
	lda.l	player{pl}_boost
	bmi	.BoostP{pl}		;If Boost On
	jmp	.BoostP{pl}End
.BoostP{pl}
	jmpflag_a	#07,.normalp{pl}	;If not last 3bit = 0
	checkflag.l	player{pl}_boost,#BoostSign
	bne		.incp{pl}
.decp{pl}
	a16
	ldx	#0
	lda.l	player{pl}_boost
	and	#$3f
	shiftRUA8
	tay
	KcopyBitMapChrXY	RBotop,BmBoostP{pl},32
	jmp	.BoostP{pl}End
.incp{pl}
	a16
	ldx	#8
	lda.l	player{pl}_boost
	and	#$3f
	beq	.zerop{pl}
	shiftRUA8
	dec	a
	tay
	KcopyBitMapChrXY	RBotop,BmBoostP{pl},32
	jmp	.BoostP{pl}End
.zerop{pl}
	KcopyBitmapFixChr	RBotop,BmBoostP{pl},32
	jmp	.BoostP{pl}End
.normalp{pl}
	a16
	lda.l	player{pl}_boost
	and	#$3f
	shiftRUA8
	tay

	lda.l	player{pl}_boost
	and	#7
	tax
	KcopyBitMapChrXY	RBotop,BmBoostP{pl},32
.BoostP{pl}End
	ENDM
;*********************************************************************
KDAMAGE	macro	[pl]
;==== Check hit damage ====
	phb
	db7e

	km_plheapptr	{pl},x
	jmpnotflag	KHITFLASH,#kdmgflag,.P{pl}dmgEnd,X

;==== Meter Copy (10 chr)=====
	clsflag		KHITFLASH,#kdmgflag,x
	db0			;Data Bank Reg = 0
	s_set_objtobeplayer{pl}	x	;player 1 work pnt

	lda	#0
	xba			;B reg <-- 0

	lda	al_hp,x		;player HP
	shiftRUA4
	kmultu8uf7	x,#11	;x:Rom Pointer
	ldy	#0		;y:Mario pointer
.loop{pl}
	shorta
	longi
	lda	#0
	xba			;B reg <-- 0
	lda.l	HPTable,x
	bne	.skip{pl}
	jmp	.P{pl}dmgEnd
.skip{pl}
	phx
	tax

	phy
	KcopyBitMapChrXY	0,BmDMGMTP{pl},32
	ply
	plx
	
	inx
	iny
	jmp	.loop{pl}
.P{pl}dmgEnd
	plb
	a8
	endm

	endc

;============================================================================	
;*			Mission Explain OLD				*
;============================================================================	

	IFEQ	1
	lda	kw_bg3sc
	clc
	adc	#02
	and	#%00001110
	ora	#%01111000
	ora	bg3screensize
	sta	kw_bg3sc
	ENDC

me_hscrolltbl
	db	0,1,0,1
me_vscrolltbl
	db	0,0,1,1

	IFEQ	1
kexp_makingplanet_l
	shorta
	longi
	phb
	db7e
;* Mario Access Enable *
	a8
	poll_mario
	a16

	lda KGameMapPtr
	km_loba
	asl	a
	tax
	lda.l	missionmaptbl3,x
	km_beq	.end
	sta.l	msprite
;* planet making (tensou saki)*
	lda	#planet_motox
	sta.l	m_xc
	lda	#planet_motoy
	sta.l	m_yc
	lda	#planet_radius
	sta.l	m_radius
	lda	#(15*32768)/16
	sta.l	m_scale
	sta.l	mspr_pal

	lda.l	kxswork+32
	clc
	adc	#$0020
	sta.l	kxswork+32
	sta.l	m_roty

	lda	#$0
	sta.l	m_rotx
	sta.l	m_rotz
	call_mario	MMakePlanet2

;* shadow making (tensou moto) *
	lda	#planet_sakix
	sta.l	m_xc
	lda	#planet_sakiy
	sta.l	m_yc
	lda	#shadow_spr
	sta.l	msprite

	lda	#$2000
	sta.l	m_rotx
	lda	#$4000
	sta.l	m_rotz

	call_mario	MMakePlanet2

;* merge planet *
	lda	#(4-2-2)
	sta.l	m_x1
	lda	#($e-2-2)
	sta.l	m_y1
	lda	#($1b-2-2)
	sta.l	m_bigx
	lda	#(6-2-2)
	sta.l	m_bigy
	call_mario	MMergePlanet
.end
	a8
	unpoll_mario
;;;	km_PullAllReg
	plb
	rtl
missionmaptbl3
	dw	planet1_spr	;stg1
	dw	planet2_spr	;stg2
	dw	planet3_spr	;stg3
	dw	planet4_spr	;stg4
	dw	0		;stg5
	dw	planet6_spr	;stg6
	dw	0		;sos1
	dw	0		;sos2
	dw	0		;sos3
	dw	0		;ext1
	dw	0		;ext2
	dw	0		;ext3
	dw	0		;ext4
	dw	0		;

	ENDC
	IFEQ	1
	a16
	lda	colptr_0
	and	#$ff
	clc
	adc	#kx_palette2&WM
	sta	coladr_0	;address
	a8
	lda	#kx_palette2>>16
	sta	coladr_0+2	;bank
	ENDC
;=====================================================================
;*			Radar Flash (Sprites)			*
;=====================================================================
.setradarflash
	IFEQ	1
	a16
;* pointer idou *
	km_addtimer	colptr_1,16*2*3,16*2*3*4
	lda	colptr_1
	clc
	adc	#kx_palette1&WM		;rdfl_pac&WM
	sta	coladr_1
	a8
	lda	#kx_palette1>>16	;rdfl_pac>>16
	sta	coladr_1+2

	ENDC
;--------------------------------------------------

