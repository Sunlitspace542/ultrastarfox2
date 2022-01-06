;*****************************************************************************
;*									*
;*			MISSION MAP RAM PROGRAM				*
;*									*
;*****************************************************************************
	INCPUB	rammismap

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
;=====================================================================
;*								*
;*			Flag Definition				*
;*								*
;=====================================================================
;---------------------------------------------------------------------
;=====================================================================
;*								*
;*		Macro Definition				*
;*								*
;=====================================================================
;--------------------------------------------------------------------
km_MMSetSpriteSizeDouble	macro
;Init	Yregister... sprites pointer
	km_jsr	mm_SetSprSize_double_sub
	endm
;---------------------------------------------------------------------
km_MMSetSpriteSize16Double	macro
;Init	Yregister... sprites pointer
	km_jsr	mm_SetSprSize16_double_sub
	endm
;---------------------------------------------------------------------


;*********************************************************************
;*								*
;*								*
;*			On RAM PROGRAM 	[Main Routine ]		*
;* Data Bank 7e				[1 Frame Running]	*
;*								*
;*********************************************************************
;---------------------------------------------------------------------
;*  MEMO *
;* This Program is running 1 frame
;---------------------------------------------------------------------
heap_runmariostart_l
	php
	phb
	a8
	db7e

	a16
	jsl	mm_GameFrameRAMRoutine_l

	plb
	plp
	rtl

;=====================================================================
;*								*
;*		Demo Cursor Move Routine			*
;*								*
;=====================================================================
	longa
	longi
mm_demomovecursor
	php
	km_setval	kz_x1,-1
	lda	mmx_curwaittm
	beq	.end
	dec	a
	sta	mmx_curwaittm
	bne	.skip
;-----------------------------------------------------
;* Finish Cursor Demo *
	stz	kx_playerdemowait
	bra	.end
;-----------------------------------------------------
;* Cursor Colour Change *
.skip
	cmp	#cursor_colpaltm
	bne	.skip2
	km_setval	kz_x1,(obj_colpal1)^-1
.skip2

;-----------------------------------------------------
	ldx	#4
	ldy	#0
.loop
;* X pos *
	lda.w	mmx_curdemox,y
	clc
	adc.w	mmx_curdemovx,y
	sta.w	mmx_curdemox,y
	a8
	lda.w	mmx_curdemox_h,y
	adc.w	mmx_curdemovx_h,y
	sta.w	mmx_curdemox_h,y
	a16

;* Y pos *
	lda.w	mmx_curdemoy,y
	clc
	adc.w	mmx_curdemovy,y
	sta.w	mmx_curdemoy,y
	a8
	lda.w	mmx_curdemoy_h,y
	adc.w	mmx_curdemovy_h,y
	sta.w	mmx_curdemoy_h,y
	a16
;* Character *
	lda.w	mmx_curdemochar,y
	and	kz_x1
	sta.w	mmx_curdemochar,y

;* Next Address *
	tya
	clc
	adc	#curdemoworklen
	tay
	dex
	bne	.loop
.end
	plp
	rts


;=====================================================================
;*								*
;*		Recover Hit Point	[Game Frame Syori]	*
;*								*
;=====================================================================
mm_recoverHP
	IFEQ	1
	php
	a8
	longi
	km_bitcheckmismapstflag	gmframesyori
	beq	.end
;* Collision Check
	km_setvar	kz_x1,mmx_arwingposx+1
	km_setvar	kz_y1,mmx_arwingposy+1
	km_setvar	kz_x2,kx_mshipx
	km_setvar	kz_y2,kx_mshipy
	km_setval	kz_z1,mshipcoll
	km_jsr	mm_checkcollision
	bcc	.end
;* Time Check *
	a16
	lda	#1
	jsl	kspeedupA_l
	a8
	clc
	adc	kx_mshiprecovertm
	sta	kx_mshiprecovertm
	cmp	#recovertm
	bcc	.end
	sec
	sbc	#recovertm
	sta	kx_mshiprecovertm
;* Recover Hit Point *
	lda	p1_hp
	cmp	#player_HP
	beq	.end
	and	#%11111100
	clc
	adc	#4
	sta	p1_hp
	ksound	CatchHeart
.end
	plp
	rts
	ENDC

;*********************************************************************
;*								*
;*		On RAM PROGRAM (Sub Routine)			*
;*								*
;*********************************************************************
;=====================================================================
;*								*
;*	Mission Map Demo Scroll (StepUp Go !!)			*
;*								*
;=====================================================================
	LONGA
	LONGI
	IFEQ	1
mm_pausecheck
	km_bitcheckmismapfzflag	pausefreeze	;renda shitatokini bugru taisaku!!
	bne	.end	;(mission map explain demo hityuyou :renda taisaku !!)

	km_bitcheckmistotalflag	explain1
	beq	.End
;---------------------------------------------------------------------
;* explain demo totyuu cancel check *
.Explain_Demo
	km_bitcheckmismapfzflag	expcancelfreeze
	bne	.End
	km_testgmjoypad	start
	beq	.End
	ksound	demo_cancel	;next_message
	km_setval	kx_MisMapSeq,mmseq_explainfinish
.end
	rts

	km_bitcheckmismapfzflag	pausefreeze
	bne	.end
;---------------------------------------------------------------------
;*			Check Start				*
;---------------------------------------------------------------------
	km_bitcheckmismapstflag	gmframesyori
	beq	.end
	km_bitcheckmistotalflag	explain1
	beq	.Normal_Game
;---------------------------------------------------------------------
;* explain demo totyuu cancel check *
.Explain_Demo
	km_bitcheckmismapfzflag	expcancelfreeze
	bne	.Explain_Demo_Skip
	km_testgmjoypad	start
	beq	.Explain_Demo_Skip
	ksound	demo_cancel	;next_message
	km_setval	kx_MisMapSeq,mmseq_explainfinish
.Explain_Demo_Skip
	bra	.end
;---------------------------------------------------------------------
;* Scroll Wait Finish Check *
.Normal_Game
	lda	mmx_scrollwaittm
	beq	.nowait			;wait timer = 0
	dec	a
	sta	mmx_scrollwaittm
	bne	.END		;waiting timer

	lda	mmx_pausescroll
	cmp	#scrl_openscrollwait
	beq	.openscroll
	cmp	#scrl_closescrollwait
	beq	.closescroll
	cmp	#scrl_pausekeywait
	beq	.pauseenable
	jml	mim_blink
;-------------------------------------------
.pauseenable
	lda	#scrl_pause
	bra	.SetScrollTrigger
.openscroll
	lda	#scrl_openscroll
	bra	.SetScrollTrigger
.closescroll
	lda	#scrl_closescroll
.SetScrollTrigger
	sta	mmx_pausescroll
;-------------------------------------------
.END
	
	rts
;=====================================================================
;*		Demo Ver / Normal Game Map Ver 			*
;=====================================================================
.nowait

;	km_bitcheckmismapflag	finalboss
;	bne	.FinalBossDemoCheck
;	km_bitcheckmistotalflag	explain1
;	bne	.ExplainDemoCheck

	brl	.NormalGame
;---------------------------------------------------------------------
;*			Final Boss Demo				*
;---------------------------------------------------------------------
.FinalBossDemoCheck
;---------------------------------------------------------------------
;*			Explain Demo				*
;---------------------------------------------------------------------
.ExplainDemoCheck
;'95/3/1 :comment
	brl	.END

	IFEQ	1
	lda	mmx_pausescroll
	beq	.Noscroll_democheck
	cmp	#scrl_pause
	beq	.Noscroll_democheck
	cmp	#scrl_closefinish
	beq	.closescroll_finish
	bra	.END
.Noscroll_Democheck
	km_cmpcheck	kx_demonumber,demo_scrollopentrig
	beq	.opendemo_start
	km_cmpcheck	kx_demonumber,demo_scrollclosetrig
	beq	.closedemo_start
	km_cmpcheck	kx_demonumber,demo_explainfinish
	km_beq	.Explain_DemoFinish
	brl	.END

	km_cmpcheck	kx_demonumber,demo_explainstart
	beq	.END
	km_cmpcheck	kx_demonumber,demo_enemyappeartrig
	km_beq	.END

.opendemo_start
	km_setval	kx_demonumber,demo_scrollopen
	km_setval	mmx_pausescroll,scrl_openscrollwait
	km_setval	mmx_scrollwaittm,3
	km_setmismapstflag	bg1scrtrans
	brl	.END

.closedemo_start
	km_setval	kx_demonumber,demo_scrollclose
	km_setval	mmx_pausescroll,scrl_closescrollwait
	km_setval	mmx_scrollwaittm,5
	stz	faceshutter_count
	brl	.END

.closescroll_finish
	lda	#scrl_normal
	sta	mmx_pausescroll
	km_clrmismapstflag	bg1scrtrans

	km_bitcheckmismapflag	finalboss
	bne	..finalboss
..explain
	km_setval	kx_demonumber,demo_enemyappeartrig
	brl	.END
..finalboss
	km_setval	kx_FinalBossSeq,fbseq_bossappeartrig
	brl	.END
	ENDC
;---------------------------------------------------------------------
;*			Normal Game Check			*
;---------------------------------------------------------------------
;* Pause Key Enable Check *
.NormalGame
	lda	mmx_pausescroll
	beq	.pausekeycheck
	cmp	#scrl_pause
	beq	.pausekeycheck
	cmp	#scrl_closefinish
	beq	.closefinish
	brl	.END
;* pause check *
.pausekeycheck
	km_bitcheckflag16	kw_mismapfreezeflag,(kfz_bossfreeze)
	km_bne	.END

	km_testgmjoypad	Pause
	km_beq	.END
	km_eorflag16	mmx_cursorflag,curf_pausecheck
	km_bitcheckflag16	mmx_cursorflag,curf_pausecheck
	beq	.pauseoff
	bra	.pauseon
.pauseon
	km_setgameflag	pauseon		;[pause on]
;	km_setmismapstflag	bg1scrtrans
	km_setmismapfzflag	timefreeze
	km_setval	mmx_pausescroll,scrl_openscrollwait
	km_setval	mmx_scrollwaittm,3
	ksound	pauseon
	stz	kx_blockanmtm
	km_stxval	kx_blockanmptr,sprblockanm_PauseON
	brl	.END
;------------------------------------------------
.pauseoff
	ksound	pauseoff
	km_setval	mmx_pausescroll,scrl_closescrollwait
	km_setval	mmx_scrollwaittm,5
	stz	faceshutter_count

	stz	kx_blockanmtm
	km_stxval	kx_blockanmptr,sprblockanm_PauseOFF
	brl	.END
;------------------------------------------------
.closefinish
	lda	#scrl_normal
	sta	mmx_pausescroll
	km_clrgameflag		pauseon		;[pause off]
	km_clrmismapfzflag	timefreeze	;[timer start]
	km_clrmismapstflag	bg1scrtrans
	brl	.END

;=====================================================================
;*			Pause Scroll				*
;* data bank 7e							*
;=====================================================================
mm_PauseScroll
	a16
	longi
;* Pause Scroll Type Check *
	lda	mmx_pausescroll
	cmp	#scrl_openscroll
	beq	.open_scroll
	cmp	#scrl_closescroll
	beq	.close_scroll
	bra	.end
;---------------------------------------------------------------------
.open_scroll

;;;	km_setval	kx_hscrollp2,$100

	IFEQ	1
;* andorof screen *
	lda	kx_hscrollp2
	cmp	#$100
	beq	.scrollfinish_pauseon
	clc
	adc	#$10
	sta	kx_hscrollp2
	sta	kw_bg3hofs

;* pepper screen *
	lda	kx_hscrollp1
	sec
	sbc	#$10
	and	#$1ff
	sta	kx_hscrollp1
	bra	.end
	ENDC


.scrollfinish_pauseon
	km_setval	mmx_pausescroll,scrl_pausekeywait
	km_setval	mmx_scrollwaittm,3
	bra	.end
;---------------------------------------------------------------------
.close_scroll
;;;	km_setval	kx_hscrollp2,0

	IFEQ	1
;* andorof screen *
	lda	kx_hscrollp2
	beq	.scrollfinish_pauseoff
	sec
	sbc	#$10
	sta	kx_hscrollp2
	sta	kw_bg3hofs

;* pepper screen *
	lda	kx_hscrollp1
	clc
	adc	#$10
	and	#$1ff
	sta	kx_hscrollp1
	bra	.end
	ENDC
.scrollfinish_pauseoff

	km_setval	mmx_pausescroll,scrl_closefinish
;---------------------------------------------------------------------
.end
	a8
	rts
	ENDC

;=====================================================================
;*								*
;*			Check Button & Key			*
;*								*
;=====================================================================
	IFEQ	1
mm_checkbutton
	php
	a16
 	longi
;---------------------------------------------------------------------
;* cancel ready speed up *
	km_testjoypad	UDLR
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
	beq	.SpeedUpTimerCheck

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

	km_clrflag16	mmx_arwingflag,mmf_go
	km_clrflag16	mmx_cursorflag,(curf_destdisp!curf_readyspup)
	km_clrflag16	mmx_cursorflag2,(curf2_goplanet!curf2_gomothership)

	km_setflag16	kw_MisMapFreezeFlag,(kfz_timefreeze!kfz_enemyfreeze!kfz_pausefreeze)
	ksound	cancel
.NotCancelCheck
;------------------------------------------------------------
	km_testjoypad	TLeft
	beq	.NoPushTleft
.NoPushTleft
;---------------------------------------------------------------------
	ifne	kspeedup
	km_clrmismapstflag	speedup
	km_testkeydown	select
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
	ENDC

	IFEQ	1
;---------------------------------------------------------------------
;* speed up *
	km_testjoypad	kettei
	beq	.NotPush_SpeedUP
;* 2 kaime ikou *
	km_bitcheckflag16	mmx_cursorflag,curf_readyspup
	bne	.speedupStart
.readyspeedup
;1 kai dake kuru (trigger)
	km_clrmismapstflag	speedup
	km_setflag16	mmx_cursorflag,curf_readyspup
	km_clrflag16	mmx_cursorflag,curf_gospup
	km_setval	mmx_curwaittm,15
	ksound	map_place_set
.NotPush_SpeedUP
;------------------------------------------------------------
;* kettei button wo zutto oshiteiruto arwing kasoku !! *
	km_testkeydown	kettei
	beq	.CancellSpeedUp

	dec	mmx_curwaittm
	bne	.NotTimerSpeedUp
;------------------------------------------------------------
.SpeedUPStart
	km_bitcheckflag16	mmx_cursorflag,curf_gospup
	bne	.NotPush_SpeedUP
	km_setflag16	mmx_cursorflag,curf_gospup
	ksound	boost
	bra	.NotTimerSpeedUp
.cancellSpeedUp
	km_clrflag16	mmx_cursorflag,curf_gospup
.NotTimerSpeedUp
	ENDC

;=====================================================================
;*			Set Cursor Postion			*
;* db 7e								*
;=====================================================================
mm_movecursor
	longa
	longi
	php
;-------------------------------------------------------
;* moshi arwing no idoutyuu dattara cursor wa ugokanai *
;	km_bitcheckflag	mmx_arwingflag,mmf_go
;	km_bne	.end
;	km_bitcheckgameflag	keydisable
;	km_bne	.end
;-------------------------------------------------------
;* key push check *
.check_tenkey
	km_readkeydown
	bit	#(pad_up!pad_down!pad_left!pad_right)
	bne	.push_tenkey
;----------------------
.nopush_tenkey
	km_clrflag16	mmx_cursorflag,curf_keypush
	km_stxval	mmx_curaccel,0
	km_stxval	mmx_curaccelx,0
	km_stxval	mmx_curaccely,0
	brl	.end
;----------------------
.push_tenkey
	longa
;* Inc Random Pointer *
; 1995/1/12
;;;	jsl	KGetRandomPtr_l
;* cursor speed *
	km_addgtumax	mmx_curaccel,$80,$400

;;;; 1995/1/12 * cursor ga PLANET ni HIT shiteite sono cursor no idou check *
;;;	km_andcmpcheckflag	mmx_cursorflag,(curf_keypush!curf_hitplanet)
;;;	km_beq	.end

	km_setflag16	mmx_cursorflag,curf_keypush ;REPEAT FLAG ON

	km_bitcheckflag16	mmx_cursorflag2,curf2_hitplanet
	km_bne	.specialmove
;******** cursor Move **********
.checkmove
	a8
	km_readkeydown_h
	bit	#padl_up
	bne	.up
	bit	#padl_down
	bne	.down
	km_stxval	mmx_curaccely,0
	bra	.check_lr
;-----------------------------------
.up
	km_negstavar	mmx_curspeedy,mmx_curspeed
	bra	.check_lr
;-----------------------------------
.down
	km_setvar	mmx_curspeedy,mmx_curspeed
;-----------------------------------
.check_lr
	km_readkeydown_h
	bit	#padl_left
	bne	.left
	bit	#padl_right
	bne	.right
	km_stxval	mmx_curaccelx,0
	bra	.set_postion
;-----------------------------------
.left
	km_negstavar	mmx_curspeedx,mmx_curspeed
	bra	.set_postion
;-----------------------------------
.right
	km_setvar	mmx_curspeedx,mmx_curspeed
;*************** cursor zahyou set **************
.set_postion
	km_jsr	mm_setcurpos_sub
	BRA	.end
;---------------------------------------------------------------------
;*		Planet wo kakomu cursor no cancell		*
;---------------------------------------------------------------------
.specialmove
	a8
	LONGI
	km_readkeydown_h
	bit	#padl_up
	bne	.sp_up
	bit	#padl_down
	bne	.sp_down
	bra	.check_lrsp
;-----------------------------------
.sp_up
	km_stxval	mmx_curspeedy,-32-1
	bra	.check_lrsp
;-----------------------------------
.sp_down
	km_setval	mmx_curspeedy,16+1
;-----------------------------------
.check_lrsp
	km_readkeydown_h
	bit	#padl_left
	bne	.sp_left
	bit	#padl_right
	bne	.sp_right
	bra	.set_postion2
;-----------------------------------
.sp_left
	km_setval	mmx_curspeedx,-32-1
	bra	.set_postion2
;-----------------------------------
.sp_right
	km_setval	mmx_curspeedx,16+1
;-----------------------------------
.set_postion2
	km_jsr	mm_setcurpos_sub

	a16
	km_setflag16	mmx_cursorflag,curf_wkcancel
	km_stxval	mmx_curaccel,0
	km_stxval	mmx_curaccelx,0
	km_stxval	mmx_curaccely,0
.end
	plp
	rts

;---------------------------------------------------------------------
;*								*
;*			Cur Postion Set				*
;*								*
;---------------------------------------------------------------------
mm_setcurpos_sub
	shorta
	longi
;* cursor X zahyou *
	lda	mmx_curposx
	clc
	adc	mmx_curspeedx
	cmp	#screen_leftedge
	bcc	.LeftEdgeX
	cmp	#screen_rightedge
	bcs	.RightEdgeX
	bra	.SetXpos
.RightEdgeX
	lda	#screen_rightedge	;Right edge
	bra	.SetXpos
.LeftEdgeX
	lda	#screen_leftedge	;Left edge
.SetXpos
	sta	mmx_curposx


;* cursor Y zahyou *
	lda	mmx_curposy
	clc
	adc	mmx_curspeedy
	cmp	#screen_topedge		;Top edge
	bcc	.TopEdgeY
	cmp	#screen_bottomedge	;Bottom edge
	bcs	.BottomEdgeY
	bra	.SetYpos
.TopEdgeY
	lda	#screen_topedge		;Top edge
	bra	.SetYpos
.BottomEdgeY
	lda	#screen_bottomedge	;Bottom edge
.SetYpos
	sta	mmx_curposy
	rts





	IFEQ	1
	bra	.skipx
.LeftEdgeX
	a16
	lda	kx_hscrollp2
	beq	.skipx
	dec	a
	dec	a
	and	#$1ff
	sta	kx_hscrollp2
	sta	kw_bg3hofs
	bra	.skipx
.RightEdgeX
	a16
	lda	kx_hscrollp2
	cmp	#$100
	beq	.skipx
	inc	a
	inc	a
	and	#$1ff
	sta	kx_hscrollp2
	sta	kw_bg3hofs
	bra	.skipx
.skipx
	a8
	ENDC


	ifeq	1
	bra	.skipy
.TopEdgeY
	a16
	lda	kx_vscrollp2
	cmp	#$100
	beq	.skipy
	dec	a
	dec	a
	and	#$1ff
	sta	kx_vscrollp2
	sta	kw_bg3vofs
	bra	.skipy
.BottomEdgeY
	a16
	lda	kx_vscrollp2
	beq	.skipy
	inc	a
	inc	a
	and	#$1ff
	sta	kx_vscrollp2
	sta	kw_bg3vofs
	bra	.skipy
.skipy
	a8
	endc
;=====================================================================
;*								*
;*			Cursor Collision Check 			*
;* data bank :7e							*
;=====================================================================
mm_CollisionCursor
	php
	a16
	longi

;* flag clear *
	km_clrflag16	mmx_cursorflag2,curf2_clrhitflag

;---------------------------------------------------------------------
;*		Cursor Hit Check To Planet			*
;---------------------------------------------------------------------
	a8
	lda	mmx_curposx
	sta	kz_x1			;X postion
	lda	mmx_curposy
	sta	kz_y1			;Y postion
	lda	#cursor_plcoll
	sta	kz_z1			;Collision Area
	km_styvar	kz_textpt,0	;Planet List Check End Pointer
	km_jsr	PlanetCollisionCheck
	km_bcc	.NoHitPlanet		;(Hit)
;--------------------------------------
;* planet ni hit shitatoki no trigger check *
.HitPlanet
;* corneria *
	cpy	kx_corneriaptr
	km_beq	.NoHitPlanet

;* item planet *
	cpy	kx_itemplanetplptr
	beq	.SetPlanetParams

;* satellite *
	cpy	kx_satelliteplptr
	bne	.SetPlanetParams

	km_bitcheckmismapfzflag	enemyfreeze
	beq	.NoHitPlanet	;move enemy

.SetPlanetParams
	lda.w	mmx_planetcx,y
	sta	mmx_bigcurposX
	sta	mmx_mapcursorX		;(For Message)
	lda.w	mmx_planetcy,y
	sta	mmx_bigcurposY
	sta	mmx_mapcursory		;(For Message)
	lda.w	mmx_name,y		;Planet Name
	sta	mmx_planetname
	lda.w	mmx_planetskill,y
	sta	mmx_planetstep
	lda.w	mmx_stage,y
	sta	kx_currentplanetnum	;Planet List Number
	a16
	km_setflag16	mmx_mapcursor,1	;(For Message)
;-----------------------------------------------------------------
	longa
;* item planet *
	cpy	kx_itemplanetplptr
	km_beq	.End		;Big Cursor wo dasanai !!

;* satellite *
	cpy	kx_satelliteplptr
	bne	.SkipA		;Big Cursor wo dasanai !!

	lda	kx_satellitetype
	beq	.End
	km_setval	mmx_planetname,planet_enemyside
	bra	.End
.SkipA
;-----------------------------------------------------------------
	longa
	km_setflag16	mmx_cursorflag2,curf2_hitplanet
	sty	kx_tmpplanetptr		;Kari Planet List Pointer
;* trigger *
	km_bitcheckflag16	mmx_cursorflag2,curf2_hitplanettrig
	bne	.nottrigger
	km_setflag16	mmx_cursorflag2,curf2_hitplanettrig
	ksound	star_select
.nottrigger
	km_bitcheckflag.w	mmx_planetflag,mmpnf_battleship,y
	bne	.battleship
	bit	#mmpnf_mothership
	beq	.noset_flag
.mothership
	lda	#curf2_hitmothership
	bra	.set_flag
.battleship
	lda	#curf2_hitbattleship	
.set_flag
	tsb	mmx_cursorflag2
.noset_flag
	bra	.End

;(No Hit)
.NoHitPlanet
	a16
	km_clrflag16	mmx_cursorflag2,curf2_hitplanettrig
;---------------------------------------------------------------------
;*		Cursor Hit Check For SOS Enemy			*
;---------------------------------------------------------------------
	longa
.SOSEnemy
	km_bitcheckmismapfzflag	enemyfreeze
	beq	.end

	a8
	lda	mmx_curposx
	sta	kz_x1			;X postion
	lda	mmx_curposy
	sta	kz_y1			;Y postion
	lda	#cursor_encoll
	sta	kz_z1			;Collision Area
	km_jsr	SOSCollisionCheck
	bcc	.End			;(No Hit)

.HitEnemy
	km_setflag16	mmx_cursorflag2,curf2_hitenemy
	sty	kx_enarrivetmptr
;---------------------------------------------------------------------
.End
	plp
	RTS

;=====================================================================
;*		Cursor Hit Check To SOS Enemy			*
;* data bank :7e							*
;* InPut	:(kz_x1,kz_y1) = (x,y) postion				*
;*	:kz_z1 = collision area					*
;* OutPut	:clc/sec  :No Hit / Hit					*
;*	:Yreg :Enemy List Pointer				*
;=====================================================================
SOSCollisionCheck
	shorta
	longi
	ldy	kx_enlistptr
;--------------------------------------
.CollisionCheck
	km_bitcheckflag16.w	mmx_enflags,(enfl_battleship!enfl_finalboss!enfl_satellite!enfl_mothership!enfl_itemplanet),y
	bne	.NextCheck

	lda.w	mmx_enposx+1,y
	sta	kz_x2
	lda.w	mmx_enposy+1,y
	sta	kz_y2
	km_jsr	mm_checkcollision
	bcs	.End	;(Hit Planet)
;--------------------------------------
.NextCheck
	ldx.w	mmx_ennext,y
	txy
	bne	.CollisionCheck
	clc
;--------------------------------------
.End
	rts


;=====================================================================
;*		Collision Check Player to Planet		*
;* data bank :7e							*
;* Yreg	:Planet List Pointer					*
;* OutPut	:							*
;*	:kx_NearPlanetPtr :0... Near Planet Nashi		*
;=====================================================================
mm_CheckNearPlanet
	shorta
	longi

	IFEQ	1
	km_setvar	kz_x1,mmx_arwingposx+1
	km_setvar	kz_y1,mmx_arwingposy+1
	km_setval	kz_z1,nearplanetarea
	km_styval	kz_textpt,0
	km_setval	kx_NearPlanetNum,planet_nothing
	km_jsr	PlanetCollisionCheck
	bcc	.end
	sty	kx_NearPlanetPtr
	lda.w	mmx_stage,y
	sta	kx_NearPlanetNum
.end
	ENDC
	rts

;=====================================================================
;*		Cursor Hit Check To Planet			*
;* data bank :7e							*
;* InPut	:(kz_x1,kz_y1) = (x,y) postion				*
;*	:kz_z1 = collision area					*
;*	:kz_textpt = check end pointer				*
;* OutPut	:clc/sec  :No Hit / Hit					*
;*	:(0~5):stage1~6, 6= corneria,7 = no near planbet	*
;*	:Yreg :Planet Pointer					*
;=====================================================================
PlanetCollisionCheck
	shorta
	longi
	ldy	kx_planetlistptr
;--------------------------------------
.CollisionCheck
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_complete,y
	bne	.NextCheck
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_senryou,y
	beq	.nextcheck

	lda.w	mmx_planetcx,y
	sta	kz_x2
	lda.w	mmx_planetcy,y
	sta	kz_y2
	km_jsr	mm_checkcollision
	bcs	.End	;(Hit Planet)
;--------------------------------------
.NextCheck
	ldx.w	mmx_planetnext,y
	txy
	cpy	kz_textpt
	bne	.CollisionCheck
	clc
;--------------------------------------
.End
	rts

;=====================================================================
;*								*
;*		Collision Check Routine				*
;* Inppt  :2 zahyou (kz_x1,kz_y1),(kz_x2,kz_y2)			*
;*        :collision Area kz_z1					*
;* OutPut :Hit    :sec						*
;*        :No Hit :clc						*
;=====================================================================
	shorta
	longi
mm_checkcollision
;* X collision check *
	lda	kz_x2
	clc
	adc	kz_z1
	cmp	kz_x1
	bcc	.nohit
	lda	kz_x2
	sec
	sbc	kz_z1
	cmp	kz_x1
	bcs	.nohit
;* Y collision check *
	lda	kz_y2
	clc
	adc	kz_z1
	cmp	kz_y1
	bcc	.nohit
	lda	kz_y2
	sec
	sbc	kz_z1
	cmp	kz_y1
	bcs	.nohit
.hit
	sec
	rts
.nohit
	clc
	rts

;=====================================================================
;*		Move Ball ( From Arwing To Planet )		*
;=====================================================================
	IFEQ	1
moveball
	shorta
	longi
	php

;* ball set timer *
	km_submin	mmx_ballsettm,1,0

;* ball set check *
	ldx	mmx_sprballaddr
.LOOP
	shorta
	lda.w	mmx_ballflags,x		;ball buffer ari ?
	km_bne	.moveball

	lda	mmx_ballsettm		;ball set enable ?
	km_bne	.end
;---------------------------------------------------------------------
.initial
	shorta
;* flag on *
	km_setflag16.w	mmx_ballflags,1,x	;ball set flag ON
	km_setval	mmx_ballsettm,8		;timer Set
	km_setval	mmx_ballsp,8,x		;ball speed

	a16
	km_lobstavar	mm_sx,mmx_arwingposx
	km_lobstavar	mm_sy,mmx_arwingposy
	km_lobstavar	mm_ex,mmx_curposX
	km_lobstavar	mm_ey,mmx_curposY

	lda	mmx_ballsp,x
	and	#$ff
	sta	mm_sp

	km_jsr	mm_calcdxdy

	a8
	lda	mm_sx
	sta	mmx_ballsx,x
	lda	mm_sy
	sta	mmx_ballsy,x
	lda	mm_ex
	sta	mmx_ballex,x
	lda	mm_ey
	sta	mmx_balley,x
	lda	mm_spx
	sta	mmx_ballspx,x
	lda	mm_spy
	sta	mmx_ballspy,x
	lda	mm_dx
	sta	mmx_balldx,x
	sta	mmx_ballcntx,x
	lda	mm_dy
	sta	mmx_balldy,x
	sta	mmx_ballcnty,x
	lda	mm_dxdy
	sta	mmx_balldxdy,x
;---------------------------------------------------------------------
.moveball
	a16
	km_loblda	mmx_ballsx,x
	sta	mm_sx
	km_loblda	mmx_ballsy,x
	sta	mm_sy
	km_loblda	mmx_ballex,x
	sta	mm_ex
	km_loblda	mmx_balley,x
	sta	mm_ey
	km_loblda	mmx_ballsp,x
	sta	mm_sp
	km_sexvar	mmx_ballspx,x
	sta	mm_spx
	km_sexvar	mmx_ballspy,x
	sta	mm_spy
	km_loblda	mmx_balldx,x
	sta	mm_dx
	km_loblda	mmx_balldy,x
	sta	mm_dy
	km_loblda	mmx_balldxdy,x
	sta	mm_dxdy
	km_loblda	mmx_balldxdy,x
	sta	mm_dxdy
	km_loblda	mmx_ballcntx,x
;;	sta	mm_cntx
	km_loblda	mmx_ballcnty,x
;;;	sta	mm_cnty
	a8
	km_jsr	mm_2pointmove
	bcc	.skip
	km_clrflag16.w	mmx_ballflags,1,x
.skip
	lda	mm_sx
	sta	mmx_ballsx,x
	lda	mm_sy
	sta	mmx_ballsy,x
	lda	mm_dxdy
	sta	mmx_balldxdy,x
;;;	lda	mm_cntx
	sta	mmx_ballcntx,x
;;	lda	mm_cnty
	sta	mmx_ballcnty,x
.end
	a16
	txa
	clc
	adc	#mmx_balllen
	tax
	sec
	sbc	mmx_sprballaddr
	a8
	cmp	#mmx_balllen*3
	km_bne	.LOOP
	plp
	rts

	ENDC

;=============================================================================
;*									*
;*			 BG Check					*
;* data bank :7e								*
;=============================================================================
	IFEQ	1
	longa
	longi
mm_PlayerBGCheck
	km_loblda.w	mmx_arwingposx+1
	sta	kz_x1
	km_loblda.w	mmx_arwingposy+1
	sta	kz_y1
	jsl	mm_BGCheck_l
;;;	sta	mmx_arwingbgcheck
;;;	sta	kx_NearPlanetNum
	rts
	ENDC
;=============================================================================
;*									*
;*			 Asteroid Hit Check				*
;* data bank :7e								*
;=============================================================================
mm_HitCheckAsteroid
	ifeq	1
	a16
	longi
	km_clrflag16	mmx_arwingflag,mmf_asteroid

	LONGA
	km_loblda	mmx_arwingposx+1
	sta	kz_x1
	km_loblda	mmx_arwingposy+1
	sta	kz_y1
	km_convVRAMSCRaddr_256	kz_x1,kz_y1
	PHX
	tax
	km_loblda.l	BGCheckBuffer,x
	PLX
.Asteroid_Check
	cmp	#$70
	bcs	.NoHitAsteroid
	cmp	#$6a
	bcc	.NoHitAsteroid
	km_setflag16.w	mmx_arwingflag,mmf_asteroid
.NoHitAsteroid
.end
	A8
	endc
	rts

;**************** COMMENT START ******************
	IFEQ	1
;*********************************************************************
;*								*
;*			Set Sprites				*
;* data bank :7e							*
;*********************************************************************
mm_dosprites
	shorta
	longi
	ldy	sprpointer
;=====================================================================
;*			Frame Timer Set				*
;=====================================================================
	lda	mmx_8frameTm
	inc	a
	and	#$7
	sta	mmx_8frameTm
	and	#$3
	sta	mmx_4frameTm
	and	#$1
	sta	mmx_2frameTm
;=====================================================================
;*		Pause tyuu mo deteiru				*
;=====================================================================
;***** Pause Sprite (for yajima) ****
	IFEQ	1
	lda	mmx_pausescroll
	cmp	#scrl_pausekeywait
	beq	.pauseobj
	cmp	#scrl_closescrollwait
	beq	.pauseobj
	cmp	#scrl_pause
	beq	.pauseobj
	bra	.skip
.pauseobj
	km_jsr	mappause_objset
.skip
	ENDC
;-----------------------------------------------------------------------
;**** yajirushi (for mission map explain :yajima's) *****
	IFEQ	1
	km_jsr	yajirushi_animation	; demo yajirushi animetion
	ENDC
;***** Player HP *********
	a16
	lda	p1_hp
	and	#$3f
	sta	kz_x1	;HP

	lda	#$1325
	sta	kz_x2	;(X,Y) offset postion
	a8
	jsl	SetSprDamageMeter_l

;***** player character *****
	a16
;* main player *
	km_SetSpriteImXY	$2*8,($3*8-4)
	km_mmsetspritesizedouble
	km_lldasla	p1_pilotNo
	km_SetSpriteChrA	$20,colpal0,pri2,noflip,mm_obj_offset
;* partner *
	km_SetSpriteImXY	$1c*8,($3*8-4)
	km_mmsetspritesizedouble
	km_lldasla	p2_pilotNo
	km_SetSpriteChrA	$20,colpal0,pri2,noflip,mm_obj_offset

;***** Enemy Mark ******
	longa
	lda	mmx_2frameTm
	bne	.DisplayDokuroMark

	lda	mmx_DokuroMark
	inc	a
	inc	a
	and	#7
	sta	mmx_DokuroMark
.DisplayDokuroMark
	lda	#($18*8+3*8<<8)
	km_jsr	dokuro_enemy

	lda	mmx_8frameTm
	bne	.DisplaySOSMark
	lda	mmx_SOSMark
	inc	a
	and	#7
	sta	mmx_SOSMark
.DisplaySOSMark
	km_setval	kz_tpx,$17*8
	km_setval	kz_tpy,4*8
	km_setvar	kz_x1,mmx_SOSMark
	km_setval	kz_x2,spr_stepup
	km_jsr	kurukuru_enemy
;=====================================================================
;*		Pause tyuu wa denai				*
;=====================================================================
;* pause check *
	a8
	lda	mmx_pausescroll
	beq	.disp_obj
	cmp	#scrl_openscrollwait
	beq	.disp_obj
	cmp	#scrl_closefinish
	beq	.disp_obj
	brl	.end
.disp_obj
;***** Corneria HP Meter *****
	IFEQ	1
;* HP Meter (yajima's)
	km_jsr	corneria_HPmeter
	ENDC

	km_bitcheckmistotalflag	explain1
	km_bne	.demosprite
	km_bitcheckmismapflag	battleplayer
	km_bne	.ArwingDisplay

;***** cursor *****
	km_bitcheckmismapfzflag	cursorfreeze
	km_bne	.notdisplay_cursor

	km_bitcheckflag16	mmx_cursorflag,curf_hitplanet
	bne	.hit
;------------------------------------------------------------------------
.nohit
	shorta
	lda	mmx_curposX
	sta	oam_centerX	; <- position X
	lda	mmx_curposY
	sta	oam_centerY	; <- position Y
	lda	#cd_objanime_smallcursor
	sta	oam_animeNo	; animation No
	lda	mmx_curanmtm
	sta	oam_tcount	; animation Timer
	a16
	km_jsr	set_kawaobj
	a8
	brl	.skipcursor

;------------------------------------------------------------------------
	ifeq	1
;* normal cursor Animation *
	lda	mmx_4frameTm
	bne	.NotChangeChr
	km_eorflag	mmx_curchar,2
.NotChangeChr

	km_setspriteC4X	mmx_curposx
	km_setspriteC4Y	mmx_curposy

	km_mmsetspritesizedouble
	lda	mmx_curchar
	km_SetSpriteChrA	$48,colpal0,pri2,noflip,mm_obj_offset
	endc
;------------------------------------------------------------------------
.hit
	shorta
	lda	mmx_bigcurposX
	sta	oam_centerX	; <- position X
	lda	mmx_bigcurposY
	sta	oam_centerY	; <- position Y
	lda	#cd_objanime_bigcursor
	sta	oam_animeNo	; animation No
	lda	mmx_curanmtm
	sta	oam_tcount	; animation Timer
	a16
	km_jsr	set_kawaobj
	a8
;**** planet name *****
	shorta
	lda	mmx_planetname
	cmp	#planet_corneria
	km_bpl	.NotDisplayName
	a16
	km_loba
	km_multa16
	clc
	adc	#$16a
	sta	kz_x1		;get name pointer

	a8
	lda	mmx_bigcurposY
	cmp	#$80
	bcs	.name_up
.name_down
	clc
	adc	#19
	bra	.skip_ypos
.name_up
	sec
	sbc	#19+4+2
.skip_ypos
	sta	kz_tpy

	lda	mmx_bigcurposX
	clc
	adc	#-28
	sta	kz_tpx

	ldx	#5
.loop
	lda	#8
	clc
	adc	kz_tpx
	sta	kz_tpx
	km_SetSpriteX	kz_tpx
	km_SetSpriteY	kz_tpy
	a16
	km_SetSpriteChrVar	x1,0,colpal1,pri2,noflip,mm_obj_offset
	inc	x1
	a8
	dex
	bne	.loop
.NotDisplayName
;============================================================================
.skipcursor
	shorta
	lda	mmx_curanmtm
	inc	a
	and	#$f
	sta	mmx_curanmtm
.notdisplay_cursor
;============================================================================
.SOSarrivetime
	ifne	ksosskill
	a16
	km_bitcheckflag16	mmx_cursorflag2,curf2_hitenemy
	km_beq	.notdispSOStm
	ldx	kx_enarrivetmptr
	km_loblda.w	mmx_enskill,x	;mmx_enstackptr,x	;
	sta	kwork
	a8
	lda.w	mmx_enposx+1,x
	sta	kwork+2
	lda.w	mmx_enposy+1,x
	sta	kwork+3
	a16
	lda	#2
	sta	kwork+4
	km_jsr	mm_SetSprScoreMeter
	a8
	endc

;-----------------------------------------------------------
	ldx	kx_enarrivetmptr
	lda.w	mmx_enposx,x
	sta	kz_x1
	lda.w	mmx_enposy,x
	sta	kz_y1
	km_lobswaplda.w	mmx_endestx,x
	sta	kz_x2
	km_lobswaplda.w	mmx_endesty,x
	sta	kz_y2

	lda	kz_x2
	sec
	sbc	kz_x1
	bpl	.plasx
	km_nega
.plasx
	sec
	sbc	#$0400
	sta	kz_tpx

	lda	kz_y2
	sec
	sbc	kz_y1
	bpl	.plasy
	km_nega
.plasy
	sec
	sbc	#$0400
	sta	kz_tpy
;-----------------------------------------------------------
	lda	kz_tpx
	cmp	kz_tpy
	bmi	.biggerY
.biggerX
	lda	kz_tpx
	sta	kz_wkdividend_H
	lda.w	mmx_envelx_l,x
	bpl	.plas_velx
	km_nega
.plas_velx
	bra	.division
.biggerY
	lda	kz_tpy
	sta	kz_wkdividend_H
	lda.w	mmx_envely_l,x
	bpl	.plas_vely
	km_nega
.plas_vely
.division
	sta	kz_wkdivisor
	PHY		;>>>	PUSH Enemy List Pointer
	jsl	KDivide_u32u16_l
	PLY		;<<<	PUSH Enemy List Pointer 

	lda	kz_wkdividend_L
	km_divu8
	sta	kwork
	a8
	lda.w	mmx_enposx+1,x
	sta	kwork+2
	lda.w	mmx_enposy+1,x
	sta	kwork+3
	a16
	lda	#3
	sta	kwork+4
	km_jsr	mm_SetSprScoreMeter
;============================================================================
.notdispSOStm
	a8
;---------------------------------------------------------------------
;* destination *
	km_bitcheckflag16	mmx_cursorflag,curf_destdisp
	km_beq	.NotdestDisplay

	dec	mmx_destmarktm
	bne	.nochangepattern

	lda	mmx_destmarkptr
	eor	#1
	sta	mmx_destmarkptr
	km_setval	mmx_destmarktm,4
.nochangepattern

	km_mmsetspritesizedouble
	a16
	km_SetSpriteC4XY	mmx_arwingdestposX,mmx_arwingdestposY

	lda	mmx_destmarkptr
	km_SetSpriteCol		$4c,pri2,noflip,mm_obj_offset

;;	lda.l	destmarkanmtbl,x
;;	km_loba
;;;	km_setspriteChrA	$40,colpal0,pri2,noflip,mm_obj_offset
	a8
.NotdestDisplay
;---------------------------------------------------------------------
;********** Arwing Display *********
.ArwingDisplay
	lda	mmx_arwinganmptr
	sec
	sbc	#5
	cmp	#7
	bcs	.pri_jet
.pri_arwing
	km_jsr	mm_disparwing
	km_jsr	mm_dispjet
	bra	.skip_arwing
.pri_jet
	km_jsr	mm_dispjet
	km_jsr	mm_disparwing
.skip_arwing
;---------------------------------------------------------------------
;****** mother ship ******
	a8
;* mother Left (UP)*
	km_mmsetspritesizedouble
	lda	kx_mshipx
	sec
	sbc	#16
	km_SetSpriteX
	lda	kx_mshipy
	sec
	sbc	#16	;8
	km_SetSpriteY
	a16
	lda	#0
 	km_setspritechrA	spr_mshipL,colpal0,pri2,noflip,mm_obj_offset
	a8

;* mother Right (UP)*
	km_mmsetspritesizedouble
	lda	kx_mshipx
	km_SetSpriteX
	lda	kx_mshipy
	sec
	sbc	#16	;8
	km_SetSpriteY
	a16
	lda	#0
	km_setspritechrA	spr_mshipL,colpal0,pri2,xflip,mm_obj_offset
	a8

;* mother Left (Down)*
	km_mmsetspritesizedouble
	lda	kx_mshipx
	sec
	sbc	#16
	km_SetSpriteX
	lda	kx_mshipy
;;	sec
;;	sbc	#8
	km_SetSpriteY
	a16
	lda	#0
 	km_setspritechrA	spr_mshipR,colpal0,pri2,noflip,mm_obj_offset
	a8

;* mother Right (Down)*
	km_mmsetspritesizedouble
	lda	kx_mshipx
	km_SetSpriteX
	lda	kx_mshipy
;;	sec
;;	sbc	#8
	km_SetSpriteY
	a16
	lda	#0
	km_setspritechrA	spr_mshipR,colpal0,pri2,xflip,mm_obj_offset
	a8
;---------------------------------------------------------------------
;**** planet skill ******
	a16
	IFNE	kplanetskill
	km_bitcheckflag16	mmx_cursorflag,curf_hitplanet
	beq	.nodisp_skill
	ldx	kx_tmpplanetptr	;Planet List Pointer
	lda.w	mmx_planetcx,x
	sec
	sbc	#$0400
	sta	kwork+2

	km_loblda.w	mmx_planetskill,x	;mmx_plstackptr,x	;
	cmp	#step_Neutral
	beq	.nodisp_skill
	sta	kwork+0
	km_setval	kwork+4,3
	km_jsr	mm_SetSprScoreMeter

.nodisp_skill
	ENDC
;---------------------------------------------------------------------
.demosprite
;---------------------------------------------------------------------
;* enemy *
	longa
	km_jsr	mm_Setsprenemy
	shorta
;---------------------------------------------------------------------
;* Planet dokuro *
	a16
	km_bitcheckmismapflag	battleplayer
	bne	.skip2
	km_jsr	enemyplanet
.skip2
	a8
;---------------------------------------------------------------------
;* meteor *
	IFEQ	1
	a8
	LDX	kx_MeteorPtr
	beq	.NoMeteor

	lda	mmx_meteoranmptr
	inc	a
	and	#$3f
	sta	mmx_meteoranmptr

	lda.w	mmx_planetcx,x
	sta	oam_centerX	; <- position X
	lda.w	mmx_planetcy,x
	sta	oam_centerY	; <- position Y
	lda	#cd_objanime_meteor
	sta	oam_animeNo	; animation No
	lda	mmx_meteoranmptr
	sta	oam_tcount	; animation Timer
	a16
	km_jsr	set_kawaobj
	a8
.NoMeteor
	bra	.end
	ENDC
;---------------------------------------------------------------------
.end
	sty	sprpointer
	rts
;=====================================================================
;*								*
;*		Display Sprite Arwing				*
;*								*
;=====================================================================
mm_disparwing
;* arwing *
;* (kz_x1,kz_x2) <<<<< (X,Y) Postion 
	a8
	lda	mmx_arwingposx+1
	sta	kz_tpx
	lda	mmx_arwingposy+1
	sta	kz_tpy

;* X flip check *
;mmx_arwinganmptr = kuru kru pattern (16) pointer :0 ~ 15
	ldx	#0
	stx	kz_tpa

	lda	mmx_arwinganmptr
	bit	#8		;pattern 8 ~ 15 check
	bne	.noflip1
	inx
.noflip1
	lda	p1_pilotNo
	and	#1
	asl	a		;0/1 ... Blue / Red Arwing 
;Xreg =0/1 ... noflip / flip
	dex
	bne	.noflip2
	clc
	adc	#obj_xflip_h
.noflip2
	sta	kz_tpa+1
	km_jsr	mm_setSprite_4

;* partner display *
	km_bitcheckmistotalflag	partner1
	bne	.notpartner

	ifeq	0
	lda	mmx_partnerposx+1
	sta	kz_tpx
	lda	mmx_partnerposy+1
	sta	kz_tpy
	km_jsr	mm_setSprite_4
	endc
.notpartner
	rts

;=====================================================================
;*		Display Sprite Arwing Jet			*
;=====================================================================
mm_dispjet
	shorta
	longi
	km_bitcheckflag16	 mmx_arwingflag,mmf_go
	beq	.end

	lda	mmx_2frameTm
	bne	.NoChangeJet
	lda	mmx_jetanmptr
	inc	a
	cmp	#3
	bne	.skip
	lda	#0
.skip
	sta	mmx_jetanmptr
.NoChangeJet
	lda	mmx_jetanmptr
	beq	.end

	a16
	km_loba
	asl	a
	clc
	adc	#obj_colpal2+$122
	sta	kz_tpa
	a8

	ldx	mmx_arwinganmptr
	lda.l	arjettbl_x,x
	clc
	adc	mmx_arwingposx+1
	sta	kz_tpx

	lda.l	arjettbl_y,x
	clc
	adc	mmx_arwingposy+1
	sta	kz_tpy

	km_jsr	mm_setSprite_4

;* partner display *
	km_bitcheckmistotalflag	partner1
	bne	.notpartner

	ifeq	0
	ldx	mmx_arwinganmptr
	lda.l	arjettbl_x,x
	clc
	adc	mmx_partnerposx+1
	sta	kz_tpx

	lda.l	arjettbl_y,x
	clc
	adc	mmx_partnerposy+1
	sta	kz_tpy
	km_jsr	mm_setSprite_4
	endc
.notpartner
.end
	rts

;=====================================================================
;*	Set Sprite (2*2) = (X,Y),Char,Att			*
;* Input	:kz_tpx :x zahyou					*
;*	:kz_tpy :y zahyou					*
;*	:kz_tpa :char&Att					*
;* data bank 7e 							*
;=====================================================================
mm_setSprite_4
	shorta
	longi
	km_mmsetspritesizedouble
	lda	kz_tpx
	sec
	sbc	#8
	km_SetSpriteX

	lda	kz_tpy
	sec
	sbc	#8
	km_SetSpriteY

	a16
	lda	kz_tpa
	km_SetSpriteChrA	0,colpal0,pri2,noflip,mm_obj_offset
	a8
	rts

;=====================================================================
;*	Set Sprite (4*4)	(X,Y),Char,Att			*
;* Input	:kz_tpx :x zahyou					*
;*	:kz_tpy :y zahyou					*
;*	:kz_tpa :char&Att					*
;* data bank 7e 							*
;=====================================================================
mm_setSprite_16
	shorta
	longi
	km_mmsetspritesizedouble
	lda	kz_tpx
	sec
	sbc	#8
	km_SetSpriteX

	lda	kz_tpy
	sec
	sbc	#8
	km_SetSpriteY

	a16
	lda	kz_tpa
	km_SetSpriteChrA	0,colpal0,pri2,noflip,mm_obj_offset
	a8
	rts

;=====================================================================
;*		Enemy Sprite Set				*
;* Xreg :Enemy List Pointer						*
;* Yreg :Sprite Pointer						*
;=====================================================================
mm_Setsprenemy
	a16
	longi
	ldx	kx_enlistptr	;no enemy
	km_beq	.noenemy
.loop
	longa
	km_bitcheckflag16.w	mmx_enflags,enfl_invisible,x
	km_bne	.nextenemy
	km_bitcheckflag.w	mmx_enflags,enfl_demo,x
	bne	.anime_demo

;*** normal enemy set (2*2 chr) ***
;* (X,Y) postion *
	a8
	lda.w	mmx_enposx+1,x
	sta	kz_tpx
	lda.w	mmx_enposy+1,x
	sta	kz_tpy
;* x flip check *
	a16
	lda.w	mmx_enangY+1,x
	clc
	adc	#8
	km_loba
	km_divu32
	sta	kz_x1		;angle	(0~7)

	km_loblda.w	mmx_entype,x	;sos type
	lsr	a
	phx
	tax
	km_loblda.l	enemychrtbl,x
	plx
	clc
	adc	#spr_enoffset
	sta	kz_x2		;charcter base No
	km_jsr	kurukuru_enemy
	bra	.nextenemy
;---------------------------------
;* demo animation (yajima's) *
.anime_demo
	longa
	lda.w	mmx_enanmpatt,x
	beq	.skip_anime
;;;;	km_jsr	SOSEnemyAnimation
	lda	#1
	jsl	kspeedupA_l
	clc
	adc.w	mmx_enanmtm,x
	sta.w	mmx_enanmtm,x
	km_jsr	mapanime_set
.skip_anime
;---------------------------------
;* next enmy set *
.nextenemy
	longa
	longi
	lda.w	mmx_ennext,x
	beq	.loopend
	tax
	brl	.loop
.loopend
;* Corneria Explosion (yajima's) *
	km_jsr	corneria_crash
.noenemy
	a8
	rts

;=====================================================================
;*			 Dokuro Display				*
;=====================================================================
dokuro_enemy
	longa
	longi
	km_SetSpriteXY
	km_mmsetspritesizedouble
	lda	mmx_DokuroMark
	km_SetSpriteChrA	$a0,colpal0,pri2,noflip,mm_obj_offset
	rts

;=====================================================================
;*			Enemy Kurukru Rotation			*
;* Init:								*
;*     : kz_tpx :center X zahyo					*
;*     : kz_tpy :center Y zahyo					*
;*     : kz_x1 :rotation angle (0~8)					*
;*     : kz_y1 :base charcter					*
;=====================================================================
kurukuru_enemy
	longa
	longi
	km_SetSpriteC4XY	kz_tpx,kz_tpy

	phx
	ldx	kz_x1
	km_loblda.l	kurukurutbl,x
	clc
	adc.w	kz_x2		;mmx_enchrbase,x
	bit	#$10
	beq	.skip2
	clc
	adc	#$10
.skip2
	sta	kz_x3

	lda	kz_x1
	cmp	#4
	bmi	.skip1
	km_addstaval	kz_x3,obj_xflip
.skip1
;* character set *
	km_MMSetSpriteSizeDouble
	lda	kz_x3
	km_setspriteChrA	0,colpal0,pri2,noflip,mm_obj_offset
	plx
	rts


:************ COMMENT END *****************

	ENDC


;=====================================================================
;*								*
;*		Set Spites Size		[double buffer]		*
;*								*
;* data bank = 7e							*
;* Yreg = sprites pointer						*
;=====================================================================
mm_SetSprSize_double_sub
	php
	phx
	phy

	ai16
	tya
	cmp	#(128*4)+(128/4)
	bmi	.buf1		;if < (128*4+128/4) THEN write buffer 1
.buf2
	sec
	sbc	#(128*4)+(128/4)
	km_shiftRUA2		;oam (*0,*4,*8,*c)---->(*0,*1,*2,*3)
	pha
	and	#$0003
	tax			;loop counter

	pla
	km_shiftRUA2	;oam (*0,*16,*32,*48)---->(*0,*1,*2,*3)
	clc
	adc	#(128*4)+(128/4)
	tay			;set sprite sub pointer
	bra	.SET
.buf1
	km_shiftRUA2	;oam (*0,*4,*8,*c)---->(*0,*1,*2,*3)
	pha
	and	#3
	tax
	pla
	km_shiftRUA2	;oam (*0,*16,*32,*48)---->(*0,*1,*2,*3)
	tay		;sprites sub pointer (0,1,2,3,..,31)
.SET
;	a16
;	txa
;	clc
;	adc	mmx_sprsizeaddr
;	tax

	a8
	lda.l	mm_SpriteSizeFlag,x
;;;;	lda.w	heap,x
	ora	sprites_sub,y
	sta	sprites_sub,y

	ply
	plx
	plp
	rts
;=====================================================================
;*								*
;*		Set Spites Size	(16chr mode)	[double buffer]	*
;* data bank = 7e							*
;* Yreg = sprites pointer						*
;=====================================================================
mm_SetSprSize16_double_sub
	php
	phx
	phy

	ai16
	km_setval	kx_sprdouble,0
	cpy	#(128*4)+(128/4)
	bmi	.buf1		;if < (128*4+128/4) THEN write buffer 1
.buf2
	km_setval	kx_sprdouble,(128*4)+(128/4)
.buf1
	tya
	sec
	sbc	kx_sprdouble
	km_shiftRUA2		;oam (*0,*4,*8,*c)---->(*0,*1,*2,*3)
	pha
	and	#3
	asl	a
	tax			;loop counter
	pla
	km_shiftRUA2	;oam (*0,*16,*32,*48)---->(*0,*1,*2,*3)
	clc
	adc	kx_sprdouble
	tay			;set sprite sub pointer

	lda.l	mm_SpriteSizeFlag16,x
	ora.w	sprites_sub,y
	sta.w	sprites_sub,y

	ply
	plx
	plp
	rts

;=====================================================================
;*								*
;*			SCORE Meter	[MISSION]		*
;* Mem16 idx16							*
;* Data Bank:7e							*
;* Yreg:Sprites Pointer						*
;* kwork  :Game Score						*
;* kwork+2:(X,Y) Postion (ichiban ushiro no kazu)			*
;* kwork+4:keta suu							*
;=====================================================================
mm_SetSprScoreMeter
	php
	ai16
	PHX
;* 1 no kurai *
	lda	kwork
	km_cpudivu16uf8_work	10
	lda	kamari
	ora	#obj_colpal1
	sta	tpa			;Character
	km_setvar	kz_x1,kwork+2	;(X,Y)
	km_jsr	mm_SetSprSmallNumber

;* 10~10000 no kurai *
	ldx	kwork+4
.loop
	dex
	beq	.end

	phx
	km_jsr	mm_SetSprScoreMeter_sub
	plx
	bra	.loop
.end
	PLX
	plp
	rts
;--------------------------------------------------
mm_SetSprScoreMeter_sub
	longa
	longi
	a8
	km_substaval	kwork+2,8
	a16
	lda	ksyou
	km_cpudivu16uf8_work	10
	lda	kamari
	ora	#obj_colpal1
	sta	tpa			;Character
	km_setvar	kz_x1,kwork+2	;(X,Y)
	km_jsr	mm_SetSprSmallNumber
	rts

;*********************************************************************
;*			Small Number Display			*
;*Init :a16i16							*
;* kz_x1	:(x,y) zahyou (2byte)					*
;* kz_tpa	:chracterNo (2 byte)					*
;*********************************************************************
mm_SetSprSmallNumber
	php
	a16
	longi
	phx
	km_SetSpriteXY	kz_x1
	km_lldx	tpa
	lda.l	mm_objnumbertbl,x
	km_loba
	km_SetSpriteChrA	0,colpal0,pri3,noflip,mm_obj_offset
	plx
	plp
	rts

	incfile	mapanime.asm
;---------------------------------------------------------------------
;*** PORGRAM END ****
heap_runmarioEnd_l
;---------------------------------------------------------------------
heap_proglen	equ	heap_runmarioEnd_l-heap_runmariostart_l


;****************************************************************************
;****************************************************************************
;
;			Not Using Area
;****************************************************************************
;****************************************************************************

;**************************************************************************
;**************************************************************************
;* 			Not Use					*
;**************************************************************************
;**************************************************************************
;**************************************************************************


;=====================================================================
;*		Step Up Enemy Appear Scroll			*
;* data bank 7e							*
;=====================================================================
	IFEQ	1
mm_StepUpScroll
	shorta
	longi
	lda	kx_stepupdemoptr
	cmp	#stupdm_open
	beq	.openscroll
	cmp	#stupdm_close
	beq	.closescroll
	cmp	#stupdm_demo1
	beq	.demowait
	bra	.end
.demowait
	a16
	dec	kx_stepupdemowait
	a8
	bne	.end

	lda	#stupdm_close
	sta	kx_stepupdemoptr
	bra	.end
.openscroll
	lda	khscrollp1
	cmp	#$90
	beq	.openend
	clc
	adc	#$10
	sta	khscrollp1

	ldx	#64
	stx	kx_stepupdemowait
	bra	.end
.openend
	lda	#stupdm_demo1
	sta	kx_stepupdemoptr
	bra	.end
;----------------------------------------------------------------
.closescroll
	lda	khscrollp1
	cmp	#0
	beq	.closeend
	sec
	sbc	#$10
	sta	khscrollp1
	bra	.end
.closeend
	lda	#stupdm_demoend
	sta	kx_stepupdemoptr
	bra	.end
;----------------------------------------------------------------
.end
	rts

	ENDC

;=========================================================================



	IFEQ	1
;* BIG cursor animation check *
	km_addgesmaxtomin	mmx_curanmtm,1,4,0
	bne	.nochange_curanm
	km_addgesmaxtomin	mmx_curanmptr,1,4,0
.nochange_curanm

	km_lldx	mmx_curanmptr
	lda	mmx_curanmpat,x
	sta	kz_z1

	lda	mmx_bigcurposX
	sec
	sbc	kz_z1
	sta	kz_x1

	lda	mmx_bigcurposX
	clc
	adc	kz_z1
	sta	kz_x2

	lda	mmx_bigcurposY
	sec
	sbc	kz_z1
	sta	kz_y1

	lda	mmx_bigcurposY
	clc
	adc	kz_z1
	sta	kz_y2

	km_SetSpriteXY_ImOff	kz_x1,kz_y1,-17,-17
	km_SetSpriteChrVal	$8,colpal0,pri2,noflip,mm_obj_offset
	km_SetSpriteXY_ImOff	kz_x2,kz_y1,9,-17
	km_SetSpriteChrVal	$8,colpal0,pri2,xflip,mm_obj_offset
	km_SetSpriteXY_ImOff	kz_x1,kz_y2,-17,9
	km_SetSpriteChrVal	$8,colpal0,pri2,yflip,mm_obj_offset
	km_SetSpriteXY_ImOff	kz_x2,kz_y2,9,9
	km_SetSpriteChrVal	$8,colpal0,pri2,xyflip,mm_obj_offset
	ENDC

	IFEQ	1
	a16
	lda	mmx_stationanmptr
	and	#$ff
	clc
	adc	mmx_sprstationaddr
	tax

	km_mmsetspritesizedouble
	km_SetSpriteImXY	$0e*8,$9*8
	lda.w	heap,x
	km_SetSprite
	inx
	inx

	km_mmsetspritesizedouble
	km_SetSpriteImXY	$10*8,$9*8
	lda.w	heap,x
	km_SetSprite
	inx
	inx

	km_mmsetspritesizedouble
	km_SetSpriteImXY	$0e*8,$b*8
	lda.w	heap,x
	km_SetSprite
	inx
	inx

	km_mmsetspritesizedouble
	km_SetSpriteImXY	$10*8,$b*8
	lda.w	heap,x
	km_SetSprite
	inx
	inx
	a8

	ENDC
	ifeq	1
;---------------------------------------------------------------------
;**** Total Add Timer ****
	brl	.notdemo

	km_bitcheckmismapstflag	replay
	km_beq	.notdemo
;* time *
	a16
	km_setvar	kwork+0,kw_Gametimer
	km_setval	kwork+2,($b*8+(2*8+7)<<8)
	km_setval	kwork+4,2
	km_jsr	mm_SetSprScoreMeter
;* s *
	SetSprXYChr_Im	$c*8,2*8+7,$7,colpal0,pri2,noflip,mm_obj_offset

;* Timer waku *
	km_SetSpriteImXY	$8*8-1,$2*8+3
	km_mmsetspritesizedouble
	km_SetSpriteChrVal	$9,colpal1,pri2,noflip,mm_obj_offset

	km_SetSpriteImXY	$a*8-1,$2*8+3
	km_mmsetspritesizedouble
	km_SetSpriteChrVal	$a,colpal1,pri2,noflip,mm_obj_offset

	km_SetSpriteImXY	$c*8-1,$2*8+3
	km_mmsetspritesizedouble
	km_SetSpriteChrVal	$9,colpal1,pri2,xflip,mm_obj_offset

;* Add Yajirushi *
	km_bitcheckgameflag	keydisable
	bne	.notdemo

	a16
	lda	Winctimer
	km_andcmpval	3
	bne	.skip1
	lda	mmx_TMSendAnmPtr
	inc	a
	and	#3
	sta	mmx_TMSendAnmPtr
.skip1
	ldx	mmx_TMSendAnmPtr
	km_loblda.l	sendmarktbl,x
	sta	kz_x1

	km_SetSpriteImXY	$e*8-2,$2*8+3
	km_setspriteChrVar	kz_x1,$0,colpal1,pri2,noflip,mm_obj_offset

	km_SetSpriteImXY	$f*8-2,$2*8+3
	km_setspriteChrVar	kz_x1,$0,colpal1,pri2,noflip,mm_obj_offset

	km_SetSpriteImXY	$e*8-2,$3*8+3
	km_setspriteChrVar	kz_x1,$0,colpal1,pri2,yflip,mm_obj_offset

	km_SetSpriteImXY	$f*8-2,$3*8+3
	km_setspriteChrVar	kz_x1,$0,colpal1,pri2,yflip,mm_obj_offset
	a8
.notdemo
	endc
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;* ball *
	ifeq	1
	a8
	ldx	mmx_sprballaddr
.LOOP_BALL
	lda.w	mmx_ballsx,x
	km_SetSpriteX

	lda.w	mmx_ballsy,x
	km_SetSpriteY

	km_SetSpriteChrVal	9,colpal0,pri2,noflip,mm_obj_offset

	a16
	txa
	clc
	adc	#mmx_balllen
	tax
	sec
	sbc	mmx_sprballaddr
	a8
	cmp	#mmx_balllen*3
	km_bne	.LOOP_BALL
	endc
;=====================================================================
;*								*
;*			Enemy Animation				*
;*								*
;=====================================================================
	IFEQ	1
SOSEnemyAnimation
;* character Anmation *
	SHORTA
	LONGI


	PHX
	PHY

	TXY
	lda.w	mmx_enanmtm,y
	dec	a
	sta.w	mmx_enanmtm,y
	bne	.nochangeanm

	lda.w	mmx_enanmptr,y
	inc	a
	inc	a
	cmp.w	mmx_enanmmaxptr,y
	bne	.notmax
	lda	#0
.notmax
	sta.w	mmx_enanmptr,y
	a16
	and	#$ff
	clc
	adc.w	mmx_enanmpatt,y
	tax
	a8
	lda.l	mm_sprenpattdata+1,x
	clc
	adc.w	mmx_enchrbase,y
	sta.w	mmx_enchranm,y		;anime pattern max pointer
	lda.l	mm_sprenpattdata+2,x
	sta.w	mmx_enanmtm,y
.nochangeanm
	PLY
	PLX
	rts
	ENDC
;============================================================================
;============================================================================
;============================================================================
;*** Arwing Move Calc ***
	IFEQ	1
;* calc DX *
	a16
	lda	mmx_arwingposx
	and	#$ff
	sta	kz_x1

	lda	mmx_destposX
	and	#$ff
	sec
	sbc	kz_x1
	sta	mmx_arwingdx
	bmi	.decx
.incx
	km_setval	mmx_arwingmovx,1
	bra	.skip_dx
.decx
	km_setval	mmx_arwingmovx,-1
.skip_dx

;* calc DY *
	lda	mmx_arwingposy
	and	#$ff
	sta	kz_x1

	lda	mmx_destposY
	and	#$ff
	sec
	sbc	kz_x1
	sta	mmx_arwingdy
	eor	mmx_arwingdx
	bmi	.minusdydx
.plasdydx
	lda	mmx_arwingmovx
	bmi	.minusmovy
.plasmovy
	km_setval	mmx_arwingmovy,1
	bra	.skip2
.minusmovy
	km_setval	mmx_arwingmovy,-1

	bra	.skip2
.minusdydx
	lda	mmx_arwingmovx
	bmi	.plasmovy
	bra	.minusmovy
.skip2
	km_absstavar	mmx_arwingdx
	km_absstavar	mmx_arwingdy
	stz	mmx_arwingH
;---------------------------------------------------
.playermove
	lda	mmx_arwingdx
	sec
	sbc	mmx_arwingdy
	bmi	.addy
;-----------------------------------------
;dx > dy
.addx
	km_addstavar	mmx_arwingposx,mmx_arwingmovX
	lda	mmx_arwingH
	clc
	adc	mmx_arwingdy
	cmp	mmx_arwingdx
	bmi	.noaddy

	pha
	km_addstavar	mmx_arwingposy,mmx_arwingmovy
	pla

	sec
	sbc	mmx_arwingdx
.noaddy
	sta	mmx_arwingH
	bra	.endcheck
;-----------------------------------------
;dy > dx
.addy
	km_addstavar	mmx_arwingposy,mmx_arwingmovY
	lda	mmx_arwingH
	clc
	adc	mmx_arwingdx
	cmp	mmx_arwingdy
	bmi	.noaddx

	pha
	km_addstavar	mmx_arwingposx,mmx_arwingmovx
	pla

	sec
	sbc	mmx_arwingdy
.noaddx
	sta	mmx_arwingH
;-----------------------------------------
.endcheck
	a8
	lda	mmx_arwingposx
	cmp	mmx_destposX
	bne	.end
	lda	mmx_arwingposy
	cmp	mmx_destposY
	bne	.end
	km_setflag16	mmw_ok,7
;-----------------------------------------
	ENDC

;---------------------------------------------------------
;* kawaguchi ga tukutta enmy List free area get program  *
;---------------------------------------------------------
	ifeq	1
	ldx	kw_enlistptr
	bne	.lastcheck
;* fast enemy *
	ldx	#kx_enemylist&WM
	stx	kw_enlistptr
	brl	.setparams

;* enemy list last pointer search *
.lastcheck
	lda.w	mmx_ennext,x
	beq	.foundlast
	tax
	bra	.lastcheck
.foundlast
	txy
	inc	a
	sta.w	mmx_ennext,x

;* blank list search *
	ldx	kw_enlistptr
.checkblank
	lda.w	mmx_ennext,x
	beq	.foundblank
	txa
	clc
	adc	#mmx_len
	tax
	bra	.checkblank
.foundblank
	txa
	sta.w	mmx_ennext,y
	endc

;----------------------------------------------
;* kawaguchi ga tukutta enmy free program *
;----------------------------------------------
	ifeq	1
	ldy	kw_enlistptr
	ldx	kx_SOSEnemyptr
	cpy	kx_SOSEnemyptr
	beq	.loop

	lda.w	mmx_ennext,y
	bne	.check1
	stz	kw_enlistptr
	bra	.end
.check1
	lda.w	mmx_ennext,x
	sta	kw_enlistptr
	bra	.end
;----------------------------------------------
.loop
	lda.w	mmx_ennext,y
	cmp	kx_SOSEnemyptr
	beq	.found
	tay
	bra	.loop
.found
	lda.w	mmx_ennext,x
	sta.w	mmx_ennext,y
;----------------------------------------------
	endc

	IFEQ	1
;----------------------------------------------------------------------------
;* Calculate Object Angle *
;* db = $7e
;* a16 i16
;* In   :source = (x1,y1),dest = (x2,y2)
;* Exit :Acc = Angle (16 bit) :0 to 359 degrees is $0000 to $ffff
;----------------------------------------------------------------------------
calobjangle
	php
	a16
	longi
;* zahyou set *
	km_substavar	x1,x2
	km_substavar	y1,y2

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
	km_jsl	arctan16_l
;---------------------------------
.chikasugi
	plp
	rts
	ENDC

;=====================================================================
;*								*
;*			Check Pause				*
;*								*
;=====================================================================
	IFEQ	1
mm_pausecheck
	LONGA
	LONGI
	km_bitcheckmismapstflag	gmframesyori
	beq	.end

;* Scroll Wait Finish Check *
	lda	mmx_scrollwaittm
	beq	.nowait			;wait timer = 0
	dec	a
	sta	mmx_scrollwaittm
	bne	.ClearKeyStates			;waiting
	lda	mmx_pausescroll
	cmp	#scrl_openscrollwait
	beq	.openscroll
	cmp	#scrl_closescrollwait
	beq	.closescroll
	cmp	#scrl_pausekeywait
	beq	.pauseenable
	jml	mim_blink
;---------------------------------------------------------------------
.pauseenable
	lda	#scrl_pause
	sta	mmx_pausescroll
	bra	.ClearKeyStates
.openscroll
	lda	#scrl_openscroll
	sta	mmx_pausescroll
	bra	.ClearKeyStates
.closescroll
	lda	#scrl_closescroll
	sta	mmx_pausescroll
	bra	.ClearKeyStates
.closefinish
	lda	#scrl_normal
	sta	mmx_pausescroll
	km_clrgameflag		pause		;[pause off]
	km_clrmismapstflag	timestop	;[timer start]
;---------------------------------------------------------------------
.ClearKeyStates
	km_clrgmjoypad
	km_clrgmkeydown
.end
;* 1 Game Frame Key Read *
	km_setgmjoypad
	km_setgmkeydown
	rts
;---------------------------------------------------------------------
.nowait
;* Pause Key Enable Check *
	lda	mmx_pausescroll
	beq	.pausekeycheck
	cmp	#scrl_pause
	beq	.pausekeycheck
	cmp	#scrl_closefinish
	beq	.closefinish
	bra	.ClearKeyStates
;---------------------------------------------------------------------
;* pause check *
.pausekeycheck
	km_testgmjoypad	Pause
	beq	.ClearKeyStates

	km_eorflag16	mmx_cursorflag,curf_pausecheck

	km_bitcheckflag16	mmx_cursorflag,curf_pausecheck
	beq	.pauseoff
.pauseon
	km_setgameflag	pause		;[pause on]
	km_setmismapstflag	timestop
	km_setval	mmx_pausescroll,scrl_openscrollwait
	km_setval	mmx_scrollwaittm,3
	ksound	pauseon
	bra	.ClearKeyStates
.pauseoff
	km_setval	mmx_pausescroll,scrl_closescrollwait
	km_setval	mmx_scrollwaittm,5
	stz	faceshutter_count
	ksound	pauseoff
	brl	.ClearKeyStates
	ENDC

;=====================================================================
;*		Trigger Routine (For Demo Enemy Appear)		*
;=====================================================================
	IFEQ	1
mm_DemoStepUpAppear
	a16
	longi
	km_bitcheckmistotalflag	explain1
	beq	.end
	km_cmpcheck	kx_demonumber,demo_enemyappeartrig
	bne	.end

	ldx	#stup_easytmbase
	lda	kdifficulty
	beq	.skip	;easy
	ldx	#stup_normaltmbase
	dec	a
	beq	.skip	;normal
	ldx	#stup_hardtmbase
.skip
	ldy	kx_planetlistptr
	a8
	storenasty
	romnastyoff
	a16
.loop
;* step up states *
;* step up wo 6 game fram okini appear !
.stupappear
	km_setstepupmode	wait,y
	lda.l	StepupAppTmTbl,x		;wait time
	sta.w	mmx_stupwaittm,y
.nextplanet
	inx
	inx

	lda.w	mmx_planetnext,y
	tay
	dec	mmx_stepupsetcnt
	cpy	kx_corneriaptr	;check suru planet = corneria 
	bne	.loop
	km_setval	kx_demonumber,demo_enemyappear

	a8
	restorenasty
.end
	a8
	rts

StepupAppTmTbl
	dw	stup_initappeartmE1
	dw	stup_initappeartmE2
	dw	stup_initappeartmE3
	dw	stup_initappeartmE4
	dw	stup_initappeartmE5
	dw	stup_initappeartmE6

	dw	stup_initappeartmN1
	dw	stup_initappeartmN2
	dw	stup_initappeartmN3
	dw	stup_initappeartmN4
	dw	stup_initappeartmN5
	dw	stup_initappeartmN6

	dw	stup_initappeartmH1
	dw	stup_initappeartmH2
	dw	stup_initappeartmH3
	dw	stup_initappeartmH4
	dw	stup_initappeartmH5
	dw	stup_initappeartmH6
	ENDC

;=====================================================================
;*								*
;*		Trigger Routine (For Demo Enemy Appear)		*
;*								*
;=====================================================================
	IFEQ	1
mm_DemoBtShipAppear
	a16
	longi
	km_bitcheckmistotalflag	explain1
	beq	.end
	km_cmpcheck	kx_demonumber,demo_enemyappeartrig
	bne	.end

	ldx	#stup_easytmbase
	lda	kdifficulty
	beq	.skip	;easy
	ldx	#stup_normaltmbase
	dec	a
	beq	.skip	;normal
	ldx	#stup_hardtmbase
.skip
	ldy	kx_planetlistptr
	a8
	romnastyoff
	a16
.loop
;* step up states *
;* step up wo 6 game fram okini appear !
.stupappear
	km_setstepupmode	wait,y
	lda.l	StepupAppTmTbl,x		;wait time
	sta.w	mmx_stupwaittm,y
.nextplanet
	inx
	inx

	lda.w	mmx_planetnext,y
	tay
	dec	mmx_stepupsetcnt
	cpy	kx_corneriaptr	;check suru planet = corneria 
	bne	.loop
	km_setval	kx_demonumber,demo_enemyappear

	a8
	romnastyon
.end
	a8
	rts

StepupAppTmTbl
	dw	stup_initappeartmE1
	dw	stup_initappeartmE2
	dw	stup_initappeartmE3
	dw	stup_initappeartmE4
	dw	stup_initappeartmE5
	dw	stup_initappeartmE6

	dw	stup_initappeartmN1
	dw	stup_initappeartmN2
	dw	stup_initappeartmN3
	dw	stup_initappeartmN4
	dw	stup_initappeartmN5
	dw	stup_initappeartmN6

	dw	stup_initappeartmH1
	dw	stup_initappeartmH2
	dw	stup_initappeartmH3
	dw	stup_initappeartmH4
	dw	stup_initappeartmH5
	dw	stup_initappeartmH6
	ENDC

