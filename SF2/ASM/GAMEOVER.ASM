alldispscore = 0
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: gamover.asm				*
;* 	Description	: Gameover SEQ				*
;*	Date		: 1994.7.15				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
	INCPUB  gameover
;---------------------------------------------------------------------

overstruct	equ	bgdemo_switch

;---------------------------------------------------------------------
;
;
;
;
;
;*********************************************************************
;	Gameover Display Parameter
;*********************************************************************
;---------------------------------------------------------------------
;	gameover score
;---------------------------------------------------------------------
overscore_startX	equ	08h
overscore_startY	equ	80h
overscore_height	equ	0fh
;---------------------------------------------------------------------
;	partner continue select
;---------------------------------------------------------------------
partnercontinue_obj	equ	3025h+80h
	ifne	janglish
partnercontinue_pX	equ	30h
	elseif
partnercontinue_pX	equ	50h
	endc

partnercontinue_pY	equ	90h
partnerfaceX		equ	partnercontinue_pX-28h
partnerfaceY		equ	92h
partnercontinue_size	equ	0eh
;---------------------------------------------------------------------
;	game retry/title select
;---------------------------------------------------------------------
retryselect_pX	equ	60h
retryselect_pY	equ	90h
retryselect_size	equ	10h
;---------------------------------------------------------------------

scoredisp_demotime	equ	8

;===================================================================






********************************************************************
;	dmmy
;********************************************************************
gameover_l
gameover_process_l
	rtl

;********************************************************************
;	gameover initialize
;********************************************************************
gameover_init_l
	Mbankprog
	php
	a8
	storenasty
	ramnastyoff
	ai16

	lda.l	player_friend
	sta.l	m_partnernumber

	Mset	overstruct,idx_gameover_demowait
	MsetL	gameover_scorepointer,0

	stz	gameover_flag		; trigger wait flag
	stz	gameover_dispflag	; display control flag

	a8
	restorenasty
	plp
	Mbankrtl

         ;------------
	longa
         ;------------

;********************************************************************
;	gameover main
;********************************************************************
gameover_obj_l
	Mbankprog
	php			; >
	ai16
	sty	sprite_register	;  >>

	jsr	gameover_program

	ldy	sprite_register	;  <<
	plp			; <
	Mbankrtl	

;--------------------------------------------------------------------
;;
;;
;;
;;
;;
;;
;********************************************************************
;	---------------------
;	 gameover chart table
;	---------------------
;********************************************************************

gameover_program

	ldx	#overstruct
	stx	dcregister
	jsr	dc_select
	Mindexliststart	
	Mindexlist	gameover_exit
	Mindexlist	gameover_demowait
	Mindexlist	gameover_partnercontinue
	Mindexlist	gameover_retrycheck

;********************************************************************
;	exit
;********************************************************************
gameover_exit
	rts

;********************************************************************
;	-------------------
;	 gameover demowait
;	-------------------
;********************************************************************

gameover_demowait
	jsr	dc_program
	dwflag	demowait_wait
	dwstop	demowait_SEQselect

;--------------------------------------------------------------------
demowait_wait
	tyx

	ifne	alldispscore
	dec	_dcflag,x	; ALLWAYS NEXT
	endc

	lda	gameover_flag
	beq	.exit
	dec	_dcflag,x

	km_bitcheckmistotalflag	partner1
	bne	.exit
	a8
	kbgm	continue
	a16

.exit	rts

;--------------------------------------------------------------------
demowait_SEQselect

	km_bitcheckmistotalflag	corneriafell
	bne	.corneria_over
	lda.l	player_friend
	bmi	.player_over

;--------------------------------------------------------------------
.continue
	Mbitclr	gameover_dispflag,ON_gameover_score
	Mset	overstruct,idx_gameover_partnercontinue
	rts

;--------------------------------------------------------------------
.player_over
.corneria_over

	Mset	overstruct,idx_gameover_retrycheck
	rts

;--------------------------------------------------------------------
;
;
;********************************************************************
;	------------------------
;	 partner continue check
	kbug1
;	------------------------
;********************************************************************
_continue_status	equ	_dcwork+0
;--------------------------------------------------------------------
Mcursor_moveset	macro	[ramaddr,max]
	ldx	dcregister
	ldy	{ramaddr},x
	lda	#{max}
	jsr	Moveupdown
	sty	{ramaddr},x
	endm

;--------------------------------------------------------------------
gameover_partnercontinue

	jsr	dc_program
	dwnext	pcont_init
	dwflag	pcont_main
	dwloop	35,pcont_wait
	dwwait	10
	dwstop	pcont_exit

;--------------------------------------------------------------------
pcont_init
	tyx
	stz	_continue_status,x
	Mbitset	gameover_dispflag,ON_gameover_partner
	rts

;--------------------------------------------------------------------
pcont_main
	Mcursor_moveset	_continue_status,2
	
	lda	trig0
	and	#button_ok
	beq	.exit

	ldx	dcregister
	dec	_dcflag,x

	lda	_continue_status,x
	bne	.no
	ksound	continue_voice
	bra	.exit

.no	ksound	kettei
.exit	rts

;--------------------------------------------------------------------
pcont_wait
	ldx	dcregister
	lda	_continue_status,x
	beq	.yes
	stz	_dctimer,x	
.yes	rts

;--------------------------------------------------------------------
pcont_exit
	ldx	dcregister
	lda	_continue_status,x
	bne	.no

;--------------------------------------------------------------------
;* Partner Continue *
;Input :mem ai16
;      :data bank ???
.yes
	PHB
	a8
	db7e

;* player states swapping *
	jsl	kplswap_l		;(for kawaguchi)
	jsl	playerstatus_swap_l	;(for kawagoe)

	IFEQ	1
	km_setvar	kx_p1_TypePtr,kx_p2_TypePtr	;(sound.asm)
	km_setvar	p1_pilotNo,p2_pilotNo
	km_setvar	p1_HP,p2_HP			;Hit Point
	km_setvar	p1_MaxHP,p2_MaxHP		;Max Hit Point
	km_setvar	p1_MaxMeter,p2_MaxMeter		;Max Damage Meter
	km_setvar	p1_spweap_type,p2_spweap_type	;Special Weapon type
	km_setvar	p1_spweap_lmt,p2_spweap_lmt	;Special Weapon kazu
	km_setvar	p1_weap_level,p2_weap_level	;Laser Level
	ENDC


	a16
	km_setval	player_friend,-1  ;(For Yajima) friend wo clear suru.

;* moshi damage ga nokote itemo clear *

	stz	kx_AttackPoint		;Attack Point Clear ;('95/8/28 :inagaki !!)

;* flag *
;;;;'95/6/24	km_clrmismapflag	all		 	;[missionmap flag]

	km_clrmistotalflag	playerdown
	km_clrmistotalflag	initialmap
	km_setwindowflag	fade
    
	km_bitcheckmistotalflag	finalbossbattle		;[missiontotal flag]
	bne	.finalboss

;* douji ni shinu tokino syori *
.normal
	lda	kenemynumber	;moshi player down to mission clear ga douji ni okiteitara !!
	bne	.notclear

	km_setmismapflag	missionresult

.notclear
	km_setmistotalflag	partner1		;[missiontotal flag]
	km_settmpgamemode	selectmissionmap	;[game mode]

	PLB
	bra	.exit
;------------------------------
.finalboss
;'95/6/28 :partner continue shitatoki mother ship kara syutugeki shite irunoni 
;partner no HP ga kaifuku shiteinai tame SET!!
;;;	km_setvar	p1_HP,p1_MaxHP

	km_setmistotalflag	partner1		;[missiontotal flag]
	km_settmpgamemode	initmission		;[game mode]

	PLB
	bra	.exit
;--------------------------------------------------------------------
;* Partner Continue *
.no
	Mset	overstruct,idx_gameover_retrycheck
	km_clrmismapflag	all		 	;[missionmap flag]

;--------------------------------------------------------------------
.exit
	rts

;********************************************************************
;	------------------------
;	 retry / title
;	------------------------
;********************************************************************
retry_obj		equ	3025h+80h
retry_pX		equ	40h
retry_pY		equ	90h
;===================================================================

gameover_retrycheck

	jsr	dc_program
	dwwait	10
	dwstop	gameretry_exit

;********************************************************************
;	initialize
;********************************************************************
_retry_status	equ	_dcwork+0
;--------------------------------------------------------------------

gameretry_init
	tyx
	stz	_retry_status,x

;;;	Mbitclr	gameover_dispflag,ON_gameover_score
;;;	Mbitclr	gameover_dispflag,ON_gameover_partner
;;;	Mbitset gameover_dispflag,ON_gameover_retry

	rts

;********************************************************************
;	main
;********************************************************************

gameretry_main

;-------------------------------------------
; BITMAP PROGRAM SET
;-------------------------------------------

	Mcursor_moveset	_retry_status,2

;-------------------------------------------
; SEQ check
;-------------------------------------------

	ldx	dcregister
	lda	trig0
	and	#button_ok
	beq	.exit

	dec	_dcflag,x

	lda	_retry_status,x
	bne	.title
	ksound	continue_voice
	bra	.exit
.title
	ksound	kettei
.exit
	rts

;********************************************************************
;	wait
;********************************************************************
gameretry_wait
	ldx	dcregister
	lda	_retry_status,x
	beq	.retry
	stz	_dctimer,x
.retry
	rts

;********************************************************************
;	exit
;********************************************************************

gameretry_exit

;-------------------------------------------
; RETRY GAME
;-------------------------------------------
.retry
	km_setwindowflag	fade
	km_settmpgamemode	missionresult	;selectmissionplayer

	bra	.exit

;-------------------------------------------
; TITLE RETURN
;-------------------------------------------
.title
	km_setwindowflag	fade

;-------------------------------------------
.exit	
	rts


;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;=======================================================================
;=======================================================================
;=======================================================================
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;*********************************************************************
;	---------------------
; 	 BITMAP DRAW PROGRAM 
;	---------------------
;*********************************************************************

bitmapdemo_gameover


	ldx	#gameover_dispdata&WM	; ROM data
	ldy	#gameover_dispflag	; RAM address
	jsr	bitBjsrprogram

	rts

;--------------------------------------------------------------------
gameover_dispdata
	MbitBjsrdata	ON_gameover_partner,disp_gameover_partner
	MbitBjsrdata	ON_gameover_score,disp_gameover_score
	MbitBjsrdata	ON_gameover_retry,disp_gameover_retry
	MbitBjsrdataend

;--------------------------------------------------------------------



;*********************************************************************
;	display gameover partner
;*********************************************************************
disp_gameover_partner

	a8
	poll_mario
	a16

	ldx	#bitmapmes_partnerselect&WM
	jsr	Draw_bitmapmessage

	a8
	unpoll_mario
	a16

	rts

;*********************************************************************
;	display gameover score
;*********************************************************************
disp_gameover_retry
disp_gameover_score

	rts


;*********************************************************************
;	----------------
;	 clear program
;	---------------
;*********************************************************************

;---------------------------------------------------------------------
;	PARTNER SELECT
;-------------------------------------------------------------------

bitmapmes_partnerselect

	Mscore_partnerface

	Mscore_contmessageINIT

	Mscore_start65816
		lda	_continue_status+overstruct
		ora	#partnercontinue_size*256
		jsr	mult_u8u8
		clc
		adc	#partnercontinue_pY+10h
		sta.l	m_y1
		lda	#partnercontinue_pX+30h-14
		sta.l	m_x1
	Mscore_end65816

	Mscore_setcolor		REDfrash
	Mscore_dispmessageonly	tmd_cursor

	Mscore_setB_m_xy	partnercontinue_pX,partnercontinue_pY
	Mscore_dispmessageNo	tmd_partnercontinue,WHITEcolor
	Mscore_setB_m_xy	partnercontinue_pX+30h,partnercontinue_pY+10h
	Mscore_setcursorcolor2	_continue_status+overstruct,0
	Mscore_dispmessageonly	tmd_yes
	Mscore_setB_m_xy	partnercontinue_pX+30h,partnercontinue_pY+10h+partnercontinue_size
	Mscore_setcursorcolor2	_continue_status+overstruct,1
	Mscore_dispmessageonly	tmd_no

	Mscore_exit

;---------------------------------------------------------------------
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;=======================================================================
;=======================================================================
;=========== library's =================================================
;=========== library's =================================================
;=======================================================================
;=======================================================================
;;;
;;;
;;;
;***********************************************************************
;	Move Cursor
;***********************************************************************
;
; A register = MAX parameter
; Y register = data
;
; temp-work use
;-----------------------------------------------------------------------
temp1	equ	Xwork6	; library work
temp2	equ	Xwork7	; library work
;-----------------------------------------------------------------------

Moveupdown	dec	a
	sta	temp1
	lda	trig0

;- select ---------------------------------------
	bit	#button_select
	beq	.entry
	iny
	cpy	temp1
	beq	.set
	bcc	.set
	ldy	#0
	bra	.set
;------------------------------------------------
.entry
	bit	#button_up+button_down
	beq	.exit
	bit	#button_up
	beq	.down
;------------------------------------------------
	dey
	bmi	.exit1
	ksound	cursor	; cursor move !!!
	bra	.exit
;------------------------------------------------
.down	cpy	temp1
	bcs	.skip
	iny
.set	ksound	cursor	; cursor move !!!
	bra	.exit
;------------------------------------------------
.skip	ldy	temp1
.exit	rts
.exit1	ldy	#0
	rts
;------------------------------------------------
;
;
;
;
;
;***********************************************************************
;	Move Cursor
;***********************************************************************
; 8bit multiply
; < input  > A register low byte * A register high byte
; < output > A register lowhigh
;-------------------------------------------------------------------
mult_u8u8	sta	4202h
	pha		; wait 4 cycle
	pla		; wait 4 cycle
	nop		; wait 2 cycle
	lda	4216h
	rts


;======================================================================
;======================================================================
;; end end end end end end end end end end end end end end end end end
;======================================================================
;======================================================================


