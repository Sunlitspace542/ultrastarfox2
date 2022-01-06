;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         RESULT.ASM                                          ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  Title Screen                                        ;
; DATE CREATED: 21-6-95                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
	INCPUB	result
;*********************************************************************
;*								*
;*			Miision Result				*
;*								*
;*********************************************************************
;---------------------------------------------------------------------
;mre_HiscoreFlag	: 0... retry check
;		: 1... go to hiscore input
;		: 2... look mission detail
;
;mre_CheckTrigger    : 0/1 ... chart trigger off/on
;
;kx_result		; 0,1,2 ... corneria fell , player down , game clear
;---------------------------------------------------------------------
MissionResult_l
	phb
	php
	a8i16
	db7e

	IFNE	kdebugresult
	a16
;* debug test *
	km_setval	kx_result,2
	km_setval	kdifficulty,0

;	km_setval	kx_initbattleshipkazu,0
;	km_setval	kx_initplanetkazu,0

	km_setval	kx_p1_pilotNo,0
	km_setval	kx_p2_pilotNo,1


	km_setval	kx_battleshipclearcnt,0
	km_setval	kx_planetclearcnt,0
	km_setval	kx_TotalTime,500
	km_setval	kx_CorneriaDamage,100

bst_score	equ	259999

	km_setval	kx_basicscore+0,(bst_score)&WM
	km_setval	kx_basicscore+2,(bst_score)>>16

	km_setmistotalflag	bonus
	km_setmistotalflag	partner1  ;partner continue ari nara 

;	km_setmistotalflag	playerdown
;	km_setmistotalflag	corneriafell

	a8
	ENDC

;* Hiscore Input *
	km_setval	mre_HiscoreFlag,0

	km_bitcheckgameflag	lookresult
	beq	.normal
;;;	km_clrgameflag	lookresult		;[yajima's clear]
	km_setval	mre_HiscoreFlag,2	;(Mission Detail)
	km_setval	mre_scorechart,(kmre_lookdetail-kmre_scorechart)/2
	km_setvar16	kw_MisTotalFlag,kx_resultflag

	jsl	CalcTotalScore_l
	bra	.NotHiScore

.normal
	jsl	CalcTotalScore_l
	jsl	yjcheck_hiscore_l	;(yajima)
	bcc	.NotHiScore
	km_setval	mre_HiscoreFlag,1
.NotHiScore

;* Flag Set *
	a16
	km_setgameflag		keydisable
	km_setscreenflag	screentrans	;[screen dma trans]
	km_setscreenflag	colpaltrans	;[colour palette dma trans]
	km_setscreenflag	objcolpal 	;[SCREEN MODE]
	km_setwindowflag	normalwipe	;[WINDOW FLAG]
	a8

;* params *
	km_stxval	kw_KeyEnableTimer,1*60
	km_setval.l	coltimer_4,4		;bg color flash timer
	km_setval.l	coltimermax_4,4		;bg color flash timer
	km_setval	key_tateptr1,0
	km_setval	key_tatemaxptr1,2

	km_stxval	kx_blockanmtm,0
	km_stxval	kx_blockanmptr,sprblockanm_Record
	km_stxval	mre_kirarianmtm,0
	km_stxval	mre_kirarianmptr,sprblockanm_Kirari
	km_stxval	mre_expertanmtm,0
	km_stxval	mre_expertanmptr,sprblockanm_Expert

;* Total Kazu *
	a16
	ldx	kdifficulty
	km_loblda.l	mm_planetkazutbl,x
	sta	kx_initplanetkazu
	sec
	sbc	kx_planetclearcnt
	sta	kx_planetkazu

	km_loblda.l	bs_totalkazutbl,x
	sta	kx_initbattleshipkazu
	sec
	sbc	kx_battleshipclearcnt
	sta	kx_battleshipkazu
	a8

;* Sprite Mode *
	km_setspritemode	missionresult
	km_setscreenmode	missionresult

;* SOUND SET *
	km_setsndmode
	km_ldxsoundtblptr
	KSoundBGMTrans

	km_bitcheckgameflag	lookresult
	beq	.noBGM

	IFEQ	1
	ldx	#0
	lda	kx_result
	beq	.setBGM
	dec	a
	beq	.setBGM	
	inx
	lda	kx_CorneriaDamage
	bne	.setBGM
	lda	kdifficulty
	cmp	#dif_hard
	bne	.setBGM
	inx
.setBGM
	lda.l	.resultBGMTbl,x
	KBGM_a
	ENDC

	KBGM	result		;!! RECORD BGM SOUND !!
.noBGM

;* bar meter sound init *
	ksound	upgauge_init

;* SCREEN SET *
	jsl	Init_MRScreen_l
	jsl	init_sprites_l
	jsl	yjresult_init_l	;(For Yajima)

* wipe init & open *
	km_initwipeopen	nowipe

;* Set window structs *
	jsl	init_nopolywindows_l
	km_qfadestepup

;* IRQ enable *
	km_IRQenable	titleirq,226	;[IRQ enable]
.LOOP
;;	km_SyoriOverCheckStart
;* wipe *
	jsl	setblack_l		; [black wait]
	jsl	wipe_l
	jsl	find_window_pri_l	; [window pri]

;* Sprites *
	jsl	do_sprites_l		;[sprites]
	jsl	set_kscreen_l		;[bg]

;* hvscroll *
	lda.l	kx_2FrameTm
	bne	.noscroll
	dec	kw_bg3hofs
	dec	kw_bg3vofs
.noscroll

;* Chart *
	lda	mre_ChartEnable
	bne	.chart

	jsr	check_start
	bcc	.skip
	inc	mre_ChartEnable
.chart
	ldx	mre_chartptr
	jsr	(mre_ChartTable,x)

;* Wait IRQ *
.skip
;;;	km_SyoriOverCheckEnd

	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait
	brl	.LOOP


	IFEQ	1
.resultBGMTbl	
	db	kbgm_result_over
	db	kbgm_result_clear
	db	kbgm_result_perfect
	ENDC

;*********************************************************************
;*								*
;*			HI Score Input				*
;*			Record (Look Result)			*
;*								*
;*********************************************************************
HiScoreInput_l
Record_l
	phb
	php
	a8i16
	db7e
;* Flag Set *
	a16
	km_setscreenflag	screentrans	;[screen dma trans]
	km_clrscrollflag	hdmascroll	;[SCREEN FLAG]
	km_setscreenflag	yjchartrans	;[SCREEN FLAG]
	km_setwindowflag	normalwipe	;[WINDOW FLAG]
	km_clrscreenflag	sprwbuf		;[SCREEN FLAG]

	km_bitchecktotalflag	yjscore
	bne	.hiscoreinput
;-------------------------------------------------
.record
	a8
	km_setspritemode	record
;* SCREEN SET *
	jsl	Init_HSScreen_l

;* yajima's init *
	jsl	init_bestscore_l
	bra	.common
;-------------------------------------------------
.hiscoreinput
	a8
	km_setval	key_tateptr1,0
	km_setval	key_tatemaxptr1,2

;* Sprite Mode *
	km_setspritemode	hiscoreinput
;* SCREEN SET *
	jsl	Init_HIScreen_l
;* yajima's init *
	jsl	init_nameset_l
;-------------------------------------------------
.common
;* Sprites *
	jsl	init_sprites_l

;* Screen Mode *
	km_setscreenmode	noscreen

;* SOUND SET *
	km_setsndmode
	km_ldxsoundtblptr
	KSoundBGMTrans


;* wipe init & open *
	km_initwipeopen	nowipe

;* Set window structs *
	jsl	init_nopolywindows_l
	km_qfadestepup

;* IRQ enable *
	km_IRQenable	titleirq,226	;[IRQ enable]
.loop
;* wipe *
	jsl	setblack_l		; [black fade]
	jsl	wipe_l
	jsl	find_window_pri_l	; [window pri]

;* Sprites *
	jsl	do_sprites_l		;[sprites]

;* hvscroll *
	lda.l	kx_2FrameTm
	bne	.noscroll
	dec	kw_bg3hofs
	dec	kw_bg3vofs
.noscroll

	km_bitchecktotalflag	yjscore
	bne	.hiscoreinpit
;--------------------------------------------------------------
;* yajima's main *
	jsl	main_bestscore_l
	cmp	#0
	beq	.skipaaa

	lda	mre_RecordEndFlag
	bne	.wait
	inc	mre_RecordEndFlag
;* chart pointer *
	km_setval	mre_chartptr,mrchart_recordend
.wait
	bra	.chart
;--------------------------------------------------------------
;* yajima's main *
.hiscoreinpit
	jsl	main_nameset_l
	cmp	#0
	beq	.skipaaa

	lda	mre_ChartEnable
	bne	.chart
	inc	mre_ChartEnable
;--------------------------------------------------------------
;* Chart *
.chart
	ldx	mre_chartptr
	jsr	(mre_ChartTable,x)
;--------------------------------------------------------------
.skipaaa
;******* Debug mode *******
;* force soft ware reset *
	km_Debug_reset

	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait
	bra	.loop


;*********************************************************************
;*								*
;*			Chart	Tabel				*
;*								*
;*********************************************************************
mre_ChartTable
	dw	mr_chart0&WM		;0
	dw	mr_chart1&WM		;2
	dw	mr_chart2&WM		;4
	dw	mr_chart3&WM		;6
	dw	mr_chart4&WM		;8
	dw	mr_chart5&WM		
	dw	mr_fadeout&WM
	dw	mr_fadeoutwait&WM
	dw	mr_recordend&WM
;-------------------------------------------------------------------------
	shorta
	longi
mr_chart0	;(From Mission Result Screen to ???)

	lda	mre_HiscoreFlag
	beq	.retry_check
	dec	a
	beq	.hiscoreinput
.return_record
;* clear bonus work *
	jsr	Clear_BonusWork

	km_settmpgamemode	record
	bra	.common_score
.hiscoreinput
	km_settmpgamemode	hiscoreinput

	lda	kx_expertflag
	bne	.enable_expert_common
.common_score
	brl	mr_fadeout

;-------------------------------
.retry_check
	km_bitcheckmistotalflag	gameend
	beq	.mission_failed

	lda	kx_expertflag
	km_beq	mr_chartGameEnd

.enable_expert
	km_settmpgamemode	end

.enable_expert_common
	km_setval	mre_chartptr,mrchart_chart5
	jsr	.ScreenColour_Sub
	inc	mre_expertdisplay
	rts

.mission_failed
	jsr	.ScreenColour_Sub
	bra	mr_nextchart

.ScreenColour_Sub
	km_setgameflag	keydisable
	alloc_window	hitflash,1
	lda	#%00000000
	sta.w	wm_ts,x		;212dh
	lda	#%00000010
	sta.w	wm_cgswsel,x	;2130h
	lda	#%10000110
	sta.w	wm_cgadsub,x	;2131h
	lda	#$10!%11100000
	sta.w	wm_coldata,x	;2132h
	inc	mre_mainspriteoff
	rts
;-------------------------------------------------------------------------
mr_nextchart
	inc	mre_chartptr
	inc	mre_chartptr
	rts
;-------------------------------------------------------------------------
mr_chart1
	shorta
	longi

	a16
	lda	kw_bg1hofs
	clc
	adc	#$10
	sta	kw_bg1hofs
	cmp	#$100
	a8
	beq	.finish
	rts
.finish
	km_clrgameflag	keydisable
	inc	mre_fingeron
	stz	mre_kettei
	bra	mr_nextchart
;-------------------------------------------------------------------------
	shorta
	longi
mr_chart2
	jsr	check_start
	bcs	.finish
	jsl	Check_triggerUD_l
	rts
.finish
	inc	mre_kettei
	km_stxval	mre_OKtimer,60	;120 :too long
	KBGM	FADEOUT
	brl	mr_nextchart
;-------------------------------------------------------------------------
	shorta
	longi
mr_chart3
	dec	mre_OKtimer
	beq	mr_chart4
	rts
;-------------------------------------------------------------------------
	shorta
	longi
mr_chart4
	jsr	Clear_ResultParams

	lda	key_tateptr1
	bne	.title
.retry
	km_setmistotalflag	retry		;[missiontotal flag]
	km_settmpgamemode	selectmissionplayer	;NEXT GAME MODE
	bra	.common
.title
	km_settmpgamemode	end
.common
	bra	mr_fadeout
;-------------------------------------------------------------------------
	shorta
	longi
mr_chart5
	lda	mre_expertanmtm
	cmp	#-3
	beq	.start_check
	rts
.start_check
	km_clrgameflag	keydisable
	jsr	check_start
	bcs	.finish
	rts
.finish

;* dylan's Screen IRQ Off *
	a16
	km_setval	screenon_position,gamevw_pos2
	a8
	bra	mr_fadeout
;-------------------------------------------------------------------------
	shorta
	longi
mr_chartGameEnd
;* dylan's Screen IRQ Off *
	a16
	km_setval	screenon_position,gamevw_pos2
	a8
	km_settmpgamemode	end
;-------------------------------------------------------------------------
mr_fadeout
	KBGM	Fast_FADEOUT
mr_fadeouttimeset
	km_setval	mre_OKtimer,60*1
	km_setval	mre_chartptr,mrchart_fadeoutwait
;-------------------------------------------------------------------------
	shorta
	longi
mr_fadeoutwait
	dec	mre_OKtimer
	beq	mr_chartend
	rts
;-------------------------------------------------------------------------
	shorta
	longi
mr_chartend
	km_qfadedown
	km_screenoff
	dealloc_window	hitflash,1	; x = hitflash

	a16
	km_clrscreenflag	all	;[screen flag]
	km_clrwindowflag	all	;[window flag]
	km_clrscrollflag	all	;[scroll flag]
	km_clrgameflag		kawairq
	km_clrsndflag		allstop ;[sound flag]

	km_setnextgamemode

;* expert flag clear *
	stz	kx_expertflag
	a8

	pla	;(rts)
	pla	;(rts)

	plp
	plb
	rtl
;-------------------------------------------------------------------------
	shorta
	longi
mr_recordend	;(LOOK Detail)
	km_bitcheckgameflag	lookresult
	beq	.returntitle
.lookresult
	km_settmpgamemode	detail
	brl	mr_fadeouttimeset
.returntitle
	jsr	Clear_ResultParams
;* Set Flag *
	km_setmistotalflag	explain1	;[missiontotal flag]

	km_settmpgamemode	title
	brl	mr_fadeouttimeset

;---------------------------------------------------------------------
;*								*
;*		Clear Mission Result Params			*
;*								*
;---------------------------------------------------------------------
	shorta
	longi
Clear_ResultParams
	a16
	km_clrmistotalflag	all	;[mis total flag]
	km_clrmismapflag	all	;[mismap flag]
	km_clrmismapflag2	all	;[mismap flag]
	km_clrmismapfzflag	all	;[freeze flag]
	km_clrmismapchflag	all	;[chart flag]
	km_clrmismapdemoflag	all	;[demo flag]
	km_clrmismapstflag	all	;[state flag]
	km_clrmismaptrflag	all	;[trigger flag]
	km_clrmismapevflag	all	;[event flag]

	km_clrscreenflag	yjchartrans	;[SCREEN FLAG]

;* corneria fell shita tokino tameno Clear ('95/9/5) *
	km_setmissionsyori	normal		;[Mission Syori]
	km_setval	kx_CorneriaFellSeq,cfseq_nothing

	stz	kx_CorneriaDamage
	stz	kx_TotalTime
	a8

;* clear Bonus Work *
	jsr	Clear_BonusWork

;* init wolf teams params *
	stz	ehp_algy	;( 1 byte)
	stz	ehp_leon	;( 1 byte)
	stz	ehp_pigma	;( 1 byte)
	rts

;---------------------------------------------------------------------
;*								*
;*		Clear Mission Result Bonus Work 		*
;*								*
;---------------------------------------------------------------------
Clear_BonusWork
	php

;* clearparams *
	a16
	stz	kx_basicscore
	stz	kx_basicscore+2
	stz	kx_timebonus
	stz	kx_timebonus+2
	stz	kx_damagebonus
	stz	kx_damagebonus+2
	stz	kx_plclearbonus
	stz	kx_plclearbonus+2

	stz	kx_partnerbonus
	stz	kx_partnerbonus+2

	plp
	rts
;=====================================================================
;*			Key Enable Check			*
;=====================================================================
	shorta
	longi
check_start
	lda	mre_HiscoreFlag
	cmp	#2
	beq	.look_detail

	lda	mre_scorechart
	cmp	#-1
	beq	.enable
	bra	.skip

.look_detail
	ldx	kw_KeyEnableTimer
	beq	.skip
	dex
	stx	kw_KeyEnableTimer
	bne	.skip

.enable
	km_clrgameflag	keydisable
.skip
	km_bitcheckgameflag	keydisable
	bne	.nopush
	km_testjoypad	OK
	bne	.push
.nopush
	clc
	rts
.push
	lda	#sport3_Kettei		;Kettei !!
	ksound_a

	sec
	rts

;*********************************************************************
;*								*
;*		Score Keisan & Rank Check			*
;* kokodewa temp work (kwork,kx_work etc..) wo tukauna !!)		*
;*********************************************************************
CalcTotalScore_l
	php
	phb
	a8
	db7e
	a16

	stz	kw_extrabonus1
	stz	kw_extrabonus1+2

;=====================================================================
;*	Moshi Game Clear Shite itara Add Bonus			*
;=====================================================================
;* save flag *
	km_setvar16	kx_resultflag,kw_mistotalflag

;---------------------------------------------------------------------
;* basic score *
	IFEQ	1
	km_bitcheckgameflag	lookresult
	bne	.NotCopy

	lda	kw_totalscore1
	sta	kx_basicscore
	lda	kw_totalscore1+2
	sta	kx_basicscore+2
.NOTCopy
	ENDC
;---------------------------------------------------------------------
;* planet mission clear bonus *
	km_ldaslx	kx_planetclearcnt
	lda.l	clearbonustbl,x
	sta	kx_plclearbonus
	tay
	lda	#0
	jsr	call_addbonus
;---------------------------------------------------------------------
;* battleship mission clear bonus *
	km_ldaslx	kx_battleshipclearcnt
	lda.l	clearbonustbl,x
	sta	kx_bsclearbonus
	tay
	lda	#0
	jsr	call_addbonus
;---------------------------------------------------------------------
;*** BONUS ***
	km_bitcheckmistotalflag	bonus
	km_beq	.Set_Score	;Moshi Game wo Clear Shite Inakattra !!

;(CalcTotalScore_l wo nankai ka Call Surutame Flag Clear Shinai !! )
;;;;	km_clrmistotalflag	bonus	;'95/8/9 :comment :kono flag mo back up surutame !!
;---------------------------------------------------------------------
;* time bonus *
	lda	kdifficulty
	asl	a
	tax

	lda.l	timebonustbl,x
	sta	kx_timemax

	sec
	sbc	kx_TotalTime
	bcc	.notimebonus
	tax
	jsl	kmultu16u8_l
	sta	kx_timebonus

	ldx	kdifficulty
	km_loblda.l	timebonusscaletbl,x
	tay
	lda	kx_timebonus
	jsl	Multiply_u16u16_l
	sty	kx_timebonus
	sta	kx_timebonus+2
	jsr	call_addbonus
.notimebonus
;---------------------------------------------------------------------
;* damage bonus *
	lda	#100
	sec
	sbc	kx_CorneriaDamage
	tax
	jsl	kmultu16u8_l
	ldy	#5
	jsl	Multiply_u16u16_l
	sta	kx_damagebonus+2
	sty	kx_damagebonus
	jsr	call_addbonus

	lda	kx_CorneriaDamage
	bne	.no_perfectbonus
	lda	#10000
	clc
	adc	kx_damagebonus
	sta	kx_damagebonus
	lda	#0
	adc	kx_damagebonus+2
	sta	kx_damagebonus+2

	ldy	#10000
	lda	#0
	jsr	call_addbonus
.no_perfectbonus
;---------------------------------------------------------------------
;* partner bonus *
	km_bitcheckmistotalflag	partner1
	bne	.partner_continue
	ldy	#10000
	sty	kx_partnerbonus
	lda	#0
	jsr	call_addbonus
.partner_continue
;---------------------------------------------------------------------
;* expert game appear check *
	km_bitcheckgameflag	lookresult
	bne	.Cannot

	lda	kdifficulty
	dec	a
	bne	.Cannot

	lda	kx_CorneriaDamage
	bne	.Cannot
	km_bitcheckflag.l	m_backupflags,backupflag_expert
	bne	.Cannot
	inc	kx_expertflag

	jsl	Write_backupRAM_enableexpert_l
.Cannot
;---------------------------------------------------------------------
;=============================================================
;* 		Set total score				*
;=============================================================
.Set_Score
	lda	kx_basicscore
	clc
	adc	kw_extrabonus1
	sta	kw_totalscore1

	lda	kx_basicscore+2
	adc	kw_extrabonus1+2
	sta	kw_totalscore1+2
;---------------------------------------------------------------------
	km_bitcheckgameflag	lookresult
	bne	.END
;* rank check*
	ldx	#0
	ldy	#0
.loop
	lda	kw_totalscore1+2
	cmp.l	rankchecktbl+2,x
	beq	.check_low
	bcs	.setrank
.next
	iny
	inx
	inx
	inx
	inx
	bra	.loop
.check_low
	lda	kw_totalscore1
	cmp.l	rankchecktbl,x
	bcc	.next
.setrank
	sty	kx_rank
;---------------------------------------------------------------------
;* result *
	ldx	#0
	km_bitcheckmistotalflag	corneriafell
	bne	.setspr_result
	inx
	km_bitcheckmistotalflag	playerdown
	bne	.setspr_result
	inx
.setspr_result
	stx	kx_result
;---------------------------------------------------------------------
	jsl	Write_backupRAM_hiscore_l

;;;	jsl	Write_backupRAM_defaulttwin_l
;---------------------------------------------------------------------
.END
	plb
	plp
	rtl

call_addbonus
	sta	kz_x1
	tya
	clc
	adc	kw_extrabonus1
	sta	kw_extrabonus1
	lda	kw_extrabonus1+2
	adc	kz_x1
	sta	kw_extrabonus1+2
	rts

rankchecktbl
	dw	250000&WM
	dw	(250000)>>16
	dw	200000&WM
	dw	(200000)>>16
	dw	150000&WM
	dw	(150000)>>16
	dw	100000&WM
	dw	(100000)>>16
	dw	50000&WM
	dw	(50000)>>16
	dw	00000&WM
	dw	(00000)>>16

timebonustbl
	dw	timebonus_easy
	dw	timebonus_normal
	dw	timebonus_hard

timebonusscaletbl
	db	3
	db	4
	db	5

clearbonustbl
	dw	0
	dw	10000
	dw	20000
	dw	30000
	dw	40000
	dw	50000
	dw	60000

;*********************************************************************
;*								*
;*			HI Score Display			*
;*								*
;*********************************************************************
	IFEQ	1
HiScore_l
	php
	a8i16
;* Flag Set *
	a16
	km_setscreenflag	screentrans	;[screen dma trans]
	km_setscrollflag	hdmascroll	;[SCREEN FLAG]
	km_setwindowflag	normalwipe	;[WINDOW FLAG]
	km_setscreenflag	yjchartrans	;[SCREEN FLAG]
	km_clrscreenflag	sprwbuf		;[SCREEN FLAG]
	a8
;* Sprite Mode *
	km_setspritemode	hiscore

;* Screen Mode *
	km_setscreenmode	noscreen

;* SCREEN SET *
	jsr	Init_HSScreen
	jsl	init_sprites_l

;* yajima's init *
	jsl	init_bestscore_l


;* SOUND SET *
	km_setsndmode
	km_ldxsoundtblptr
	KSoundBGMTrans

;* wipe init & open *
	km_initwipeopen	nowipe

;* Set window structs *
	jsl	init_nopolywindows_l
	km_qfadestepup

;* IRQ enable *
	km_IRQenable	titleirq,226	;[IRQ enable]
.loop

;* wipe *
	jsl	setblack_l		; [black fade]
	jsl	wipe_l
	jsl	find_window_pri_l	; [window pri]

;* Sprites *
	jsl	do_sprites_l		;[sprites]


;* yajima's main *
	jsl	main_bestscore_l
	cmp	#0
	bne	.pushstart

;******* Debug mode *******
;* force soft ware reset *
	km_Debug_reset

	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait
	bra	.loop
;==========================================================================
.pushstart
	shorta
;* kettei *
	KBGM	FADEOUT
	km_setsndflag	allstop

	km_initwipeclose	nowipe
	km_wipewait_l
;-----------------------------------------------------
;* SET GAME MODE *

;* flag clear or set *
	km_clrscreenflag	all
	km_clrwindowflag	all	;[window flag]
	km_clrscrollflag	all	;[scroll flag]
	km_clrgameflag		kawairq
	km_clrsndflag		allstop ;[sound flag]
;-----------------------------------------------------
	km_bitcheckgameflag	lookresult
	beq	.returntitle
.lookresult
	km_setgamemode	missionresult
	bra	.End
.returntitle
	km_setgamemode	title
;-----------------------------------------------------
.End
	plp
	rtl
	ENDC


;*********************************************************************
;*								*
;*	(Test Version) Select Mission MAP 			*
;*								*
;*********************************************************************
SelectTestMissionMap_l
	php
	a8i16
;* flag set *
	km_setgameflag	test
	km_setval.l	kx_CorneriaHP,100
	km_clrmissionflag	enemyrunaway

;* Initialize *
	jsr	Init_TestScreen

	km_setvar.l	key_tateptr1,kx_testmapptr_bak
	km_setval.l	KGameMapPtr,0

	km_setval	key_tatemaxptr1,(stg_demo+1)

;* IRQ Enable *
	km_IRQenable	titleirq	;[IRQ enable]

;* screen ON *
	km_fadeup
;------------------------------------------------------------------------------
.loop_mapsel
;;;	jsr	select_mapmode
	jsl	Check_autotrigUD_l
	jsr	do_spritesMMS

	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait
;------------------------------------------------------------------------------
	IFNE	kendingtest
	km_testjoypad	select
	beq	.nopushX

	ksound	cursor
	lda.l	kdifficulty
	inc	a
	cmp	#3
	bmi	.skipX
	lda	#0
.skipX
	sta.l	kdifficulty
.nopushX
	ENDC
;------------------------------------------------------------------------------
;* Cancell *
	km_testjoypad	cancel	;[cancel]
	beq	.nopushB

;;;;	km_setval.l	KGameMapPtr,(missionmaptblEND-missionmaptbl)&BM

	km_setgamemode	title	;Next Game Mode
	brl	.end
.nopushB
;------------------------------------------------------------------------------
;* Kettei *
	km_testjoypad	OK
	beq	.loop_mapsel
	lda	key_tateptr1
	sta.l	KGameMapPtr		;MAP Pointer
	sta.l	kx_testmapptr_bak
;-------------------------------------------------------------------------
	cmp	#stg_sos3
	beq	.planet
	cmp	#stg_sos1
	bpl	.enemy
.planet
	km_clrmismapflag	enemylist
	bra	.skip_mis
.enemy
	km_setmismapflag	enemylist
;-------------------------------------------------------------------------
.skip_mis
	lda	#sport3_Kettei		;Kettei !!
	ksound_a
	km_setgamemode	testplanetstep	;NEXT GAME MODE
;-----------------------------------------------------
.End
	km_qfadedown
	km_screenoff
;-----------------------------------------------------
	plp
	rtl

;=====================================================================
;*		Mission Map Select sprites	[SPRITES]	*
;=====================================================================
do_spritesMMS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	TitSPrData
	BlockTransSPrites	MMapSelSprData

;* Mission Level *
	IFNE	kendingtest
	a16
	lda	#$20e0
	sta	sprites,y
	iny
	iny
	lda	kdifficulty
	asl	a
	tax
	lda.l	kmapleveltbl,x
	sta	sprites,y
	iny
	iny
	a8
	ENDC
;Map select mark set

	lda	#$50
	sta	sprites,y
	iny

	lda	key_tateptr1
	km_multa8
	clc
	adc	#$50-1
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri0,noflip
	plb
	rts

	IFNE	kendingtest
kmapleveltbl
	SprChrDataw	conf_e,colpal0,pri3,noflip
	SprChrDataw	conf_n,colpal0,pri3,noflip
	SprChrDataw	conf_h,colpal0,pri3,noflip
	ENDC

;*********************************************************************
;*								*
;*	(Test Version) Select Planet Step 			*
;*								*
;********************************************************************
SelectTestPlanetStep_l
	php
	a8i16

;* Initialize *
	jsr	Init_TestScreen

	km_setvar.l	key_yokoptr1,kx_testskillptr_bak
	km_setval	currentlevel,0
	km_setval	key_yokomaxptr1,32
;* IRQ Enable *
	km_IRQenable	titleirq	;[IRQ enable]

;* screen ON *
	km_fadeup
.loop_mapsel

	jsl	Check_autotrigLR_l
	jsr	do_spritesPS
	a8
	lda	#iv_titleirq
	sta	trans_flag
	km_waittrans		;irq wait

;* Cancell *
	km_testjoypad	cancel	;[cancel]
	beq	.nopushB

	lda	#sport3_Kettei		;Kettei !!
	ksound_a
	km_setgamemode	testmissionmap	;NEXT GAME MODE
	jmp	.end
.nopushB

;**** Kettei *****
	km_testjoypad	OK
	beq	.loop_mapsel
	km_setvar	currentlevel,key_yokoptr1
	sta.l	kx_testskillptr_bak
;* target no  kazu *
	lda	#kennum
	sta.l	kenemynumber
	lda	#sport3_Kettei		;Kettei !!
	ksound_a
	km_setgamemode	initmission	;NEXT GAME MODE

;* satellite *
	km_clrflag16.l	kx_satelliteflag,safl_virustorituki

	lda	kgamemapptr
	cmp	#stg_sos2
	bne	.not_sos2
	lda	currentlevel
	cmp	#9
	bne	.not_sos2
	km_setflag16.l	kx_satelliteflag,safl_virustorituki
	km_setval	currentlevel,8
.not_sos2

;* special enemy *
	lda	kgamemapptr
	cmp	#stg_sos4
	bne	.not_special
	lda	currentlevel
	cmp	#$1c
	bpl	.not_special
	clc
	adc	#$1c
	sta	currentlevel
.not_special



;* demo check *
	lda	kgamemapptr
	cmp	#stg_demo
	bne	.not_demo

	km_lldx	key_yokoptr1
	lda.l	.demotbl,x
	sta	kw_DemoNumber
	km_setgamemode	demo	;NEXT GAME MODE
.not_demo
;-----------------------------------------------------
.End
	km_qfadedown
	km_screenoff
;-----------------------------------------------------
;* Player Sound *
	km_cmpcheckgamemode	initmission	;NEXT GAME MODE
	bne	.skip0
	KSoundPlayerTrans
.skip0
;-----------------------------------------------------
	plp
	rtl

.demotbl
	db	kdemo_titledemo
	db	kdemo_startenemydemo
	db	kdemo_entermshipdemo
	db	kdemo_startarwingdemo
	db	kdemo_corneriafelldemo
	db	kdemo_gamecleardemo
	db	kdemo_endingdemo
	db	kdemo_specialendemo
	db	kdemo_dummy2demo
	db	kdemo_planetcannondemo

;=====================================================================
;*		Mission Level Select sprites	[SPRITES]	*
;=====================================================================
do_spritesPS
	a8i16
	phb
	db7e
	oamclear_SG

	ldy	#0

;Map select init screen display
	BlockTransSPrites	PlanetStepSprData

;Map select mark set
;kai
	km_setspriteImXY	$98,$80
	lda	key_yokoptr1
	and	#$0f
	km_SetSpriteChrA	conf_0,colpal0,pri0,noflip
;jyoui
	km_setspriteImXY	$90,$80
	lda	key_yokoptr1
	and	#$f0
	km_divu16
	km_SetSpriteChrA	conf_0,colpal0,pri0,noflip

	plb
	rts



;*********************************************************************
;*								*
;*			Initial Test Screen			*
;*********************************************************************
Init_testscreen
	shorta
	longi
	phb
	db0
	screen_off		;screen off

	jsr	Initial_PPUregister

;	jsr	Set_TBG1CGX
;	jsr	Set_TBG1SCR
;	jsr	Set_TBG2CGX
;	jsr	Set_TBG2SCR
;	jsr	Set_TBG3CGX
;	jsr	Set_TBG3SCR
	jsr	Set_TOBJCGX
	jsr	Set_TOAM
	jsr	Set_TCOL
	plb
	rts
;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
Initial_PPUregister
	shorta
	lda	#%00001001
	sta	bgmode		;BG mode 1 ,8*8 dot ,BG3 prio off

	lda	#(t_bg1_scr>>8)&$fc	;BG1 SCR (0000h),screen 1
	sta	bg1sc				   
	lda	#(t_bg2_scr>>8)&$fc
	sta	bg2sc			;BG2 SCR (2000h),screen 1
	lda	#(t_bg3_scr>>8)&$fc
	sta	bg3sc			;BG3 SCR (6000h),screen 1

	lda	#(t_bg1_cgx1>>12)!((t_bg2_cgx>>8)&$f0)
	sta	bg12nba			;BG1 (0000) ,BG2 (0000)

	lda	#(t_bg3_cgx>>12)
	sta	bg34nba			;BG3 (4000h)

	lda	#(t_obj_cgx>>13)
	sta	objsel			;OBJ (7000h)

	lda	#%00010000
	sta	tm			;OBJ display
	sta	kw_tm
	sta.l	kw_tmbackup

	lda	#0
	sta	hdmaen_gc
	rts
;=====================================================================
;*		Initial BG1 Character Data			*
;=====================================================================
Set_TBG1CGX
	rts
;=====================================================================
;*		Initial BG1 Screen Data				*
;=====================================================================
Set_TBG1SCR

	rts

;=====================================================================
;*		Initial BG2 Character Data			*
;=====================================================================
Set_TBG2CGX
;	decvramnotrans	0,t_bg2_cgx,b0_ccr,($1e0*32)
;	decvramnotrans	0,t_bg2_cgx,b2_ccr,($c0*32)
;	decvramnotrans	0,t_bg2_cgx,b3_ccr,($110*32)
;	decvramnotrans	0,t_bg2_cgx,ti2_ccr,($c0*32)
;	dmavram		0,t_bg2_cgx,ti2_cgx,$c0*32
	rts
;=====================================================================
;*		Initial BG2 Screen Data				*
;=====================================================================
Set_TBG2SCR
;	decvramnotrans	0,t_bg2_scr,b0_pcr,$800
;	decvramnotrans	0,t_bg2_scr,b2_pcr,$800
;	decvramnotrans	0,t_bg2_scr,b3_pcr,$800
;	decvramnotrans	0,t_bg2_scr,ti2_pcr,$800
;	dmavram	0,t_bg2_scr,ti2_scr,$800
	rts
;=====================================================================
;*		Initial BG3 Character Data			*
;=====================================================================
Set_TBG3CGX
;	decvramnotrans	0,t_bg3_cgx,ti3_ccr,($80*16)
;	dmavram	0,t_bg3_cgx,ti3_cgx,$80*16
	rts

;=====================================================================
;*		Initial BG3 Screen Data				*
;=====================================================================
Set_TBG3SCR
;	decvramnotrans	0,t_bg3_scr,ti3_pcr,$800
;	dmavram	0,t_bg3_scr,ti3_scr,$800
	rts
;=====================================================================
;*			Initial OBJ Character Data		*
;=====================================================================
Set_TOBJCGX
;;;;	decvramnotrans	0,t_obj_cgx,wobj0_ccr,($c0*$20)	;(chra value)* (4 bit col)
	a8
	km_dmacgx4VRAM	0,kawaguti_cgx,cn_obj_cgx,$30
	rts

;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_TCOL
;* BG colour
;* OBJ colour
	km_decrunchpal
	dmacgram	0,$80,yaji_0_pac,$100

;;;	decrunch_palettes
;;;	dmacgram	0,0,b0_pac,$100
;;;	dmacgram	0,$80,w0_pac,$100

	rts

;=====================================================================
;*			Initial OAM Data			*
;=====================================================================
Set_TOAM
;-------------- OBJ Display Enable ------------------
	a8i16
	phb
	db7e
	oamclear_SG
	oamsuballon
	plb

;	ai16
;	ldy	#0
;	BlockTransSPrites	TitSPrData
;	sty	sprpointer
;bank0
;	a8i16
;	dmaoaram	0,0,sprites,(128*4)+(128/4)	; dma into oram

	rts
