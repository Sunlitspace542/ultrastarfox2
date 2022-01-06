;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: missobj.asm				*
;* 	Description	: Mission Explain 			*
;*			; OBJ-Animation & Display Message	*
;*	Date		: 1994.9.14				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
	INCPUB  missobj
;---------------------------------------------------------------------
;
;
;
;
;
;
;*********************************************************************
; 	mission explain initialize
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
messageN	equ	Xwork3
message_px	equ	Xwork4
message_py	equ	Xwork5
message_ptr	equ	Xwork6
message_wid	equ	Xwork7
message_col	equ	Xwork8
;---------------------------------------------------------------------
;

missobj_struct equ	bgdemo_switch
;
;=====================================================================
;=====================================================================
;===========	MISSION EXPLAIN =========================================
;===========	MISSION EXPLAIN =========================================
;=====================================================================
;=====================================================================
;*********************************************************************
; 	mission explain initialize
;*********************************************************************

init_missobj_l
	Mbankprog
	php

	ai16
	jsr	Init_objlist
	Mset	missobj_struct,idx_missexp_openning

	plp
	Mbankrtl

;*********************************************************************
; 	mission explain main
;*********************************************************************

missobj_l	Mbankprog
	php

	ldy	sprpointer
	sty	sprite_register

	ai16
	jsr	missobj_entry

	ldy	sprite_register
	sty	sprpointer

	plp
	Mbankrtl

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
;---------------------------------------------------------------------
	longa
	longi
;=====================================================================
;=====================================================================
;===========	MISSION EXPLAIN =========================================
;===========	MISSION EXPLAIN =========================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	explain
;*********************************************************************

missobj_entry
;-----------------------------------------------------
 	lda.l	KEnemyNumber
	and	#00ffh
	sta.l	Kenemy_backup
;-----------------------------------------------------
	ldx	#missobj_struct
	stx	dcregister
;-----------------------------------------------------
	jsr	dc_select
	Mindexliststart
	Mindexlist	missexp_exit	  ;(0)
	Mindexlist	missexp_openning  ;(1)
;-----------------------------------------------------








;*********************************************************************
;	mission object demo
;*********************************************************************
missexp_exit

	rts

;*********************************************************************
;	mission object demo
;*********************************************************************
Mkeep_numpointer	macro
	cmp	#10
	bcc	.skip\@
	lda	#0
.skip\@	asl	a
	tax
	lda.l	big_numberobj,x
	tay
	endm

;---------------------------------------------------------------------
big_numberobj
	dw	obj_w0_1_0&WM
	dw	obj_w0_1_1&WM
	dw	obj_w0_1_2&WM
	dw	obj_w0_1_3&WM
	dw	obj_w0_1_4&WM
	dw	obj_w0_1_5&WM
	dw	obj_w0_1_6&WM
	dw	obj_w0_1_7&WM
	dw	obj_w0_1_8&WM
	dw	obj_w0_1_9&WM
;---------------------------------------------------------------------


missexp_openning
	jsr	dc_program
	dwnext	   init_target
	dwloop	 8,wait_target
	dwloop	 6,open_target
	dwloop	 1,main_target1
	dwloop	 2,main_target4		; open
	dwloop 100,main_target5		; main
	dwloop 100,main_target5		; main
	dwloop 40h,main_target6		; main
	dwloop   8,main_target_exit1
	dwnext     main_target_exit2
	dwloop   3,main_target_exit3
	dwnext     main_target_end
	dwend

;=====================================================================
;
;
; random noize address
; screen noize address
; main display address
; screen parameter address
; abc noize skip Random
; main_screen program
;
;
;
;
;=====================================================================

wait_target
init_target

	lda	#0
	sta.l	barnoize_counter
	sta.l	videonoize_counter
	sta.l	raster_noizestart
	lda	#1
	sta.l	raster_noizesize

	MsetBL	kw_tm,12h	; OBJ/BG2
	lda	#0
	jsr	raster_move
	rts

;---------------------------------------------------------------------
open_target

	ldx	sprite_register
	phx				; >>
	jsr	Set_enemytargetOBJ
	plx				; <<
	ldy	dcregister
	lda.w	_dccounter,y
	asl	a
	tay

	jmp	Lanime_objerace	; erace program

;---------------------------------------------------------------------
main_target1
	MsetBL	kw_tm,13h		; OBJ/BG1/BG2/(BG3)
	jmp	main_target_objset

;---------------------------------------------------------------------
main_target4
	ldx	dcregister
	lda	_dccounter,x
	bne	.skip
	ksound	disp_noise
	bra	.skip2
;---------------------------------------------------------------------
.skip	cmp	#2		; Gakky !!!!! noize-off
	bne	.skip2
	ksound	stop_tr4

;---------------------------------------------------------------------
.skip2
	lda	#10
	jsr	raster_move
	jsr	main_target_keyexit
	jmp	main_target_objset

;---------------------------------------------------------------------
main_target6

	lda.l	videonoize_counter
	dec	a
	and	#3fh
	sta.l	videonoize_counter
	jsr	small_barnoize
main_target5

	lda	#idx_random_raster	;
	sta.l	raster_control		;
	jsr	small_rasternoize

	jsr	main_target_keyexit
	jmp	main_target_objset

;---------------------------------------------------------------------
main_target_exit1

	lda	#0			; endof video noize
	sta.l	videonoize_counter
	lda	#idx_explain_raster	; change sin raster
	sta.l	raster_control


	ldx	dcregister
	lda	_dccounter,x
	bne	.skip1
	pha
	ksound	disp_noise
	pla
.skip1	cmp	#8
	bcs	.skip
	eor	#007h
	jsr	raster_move
.skip	jsr	main_target_objset
	jmp	main_target_keyexit

;---------------------------------------------------------------------
main_target_exit2
	ksound	disp_sand_storm
main_target_exit3
	lda	#-1
	sta.l	barnoize_counter	
	rts

;---------------------------------------------------------------------
main_target_end
;;;;;;;	ksound	exp_good_luck
	inc	mew_ketteiflag
	rts

;---------------------------------------------------------------------
;;
;;
;;
;;
;;
;;
;;
;;
;;
;;
;;
;;
;---------------------------------------------------------------------
; main target objset
;---------------------------------------------------------------------
main_target_objset

	jsr	Set_enemytargetOBJ
	jsr	Set_enemynumberOBJ
	rts

;---------------------------------------------------------------------
; main target key exit
;---------------------------------------------------------------------
main_target_keyexit

	Mkeycheck trig0,button_ok	; <<<<< exit check >>>>>
	beq	.exit
	
	lda	mew_ketteiflag
	bne	.exit
	ksound	exp_good_luck
	inc	mew_ketteiflag	 	; mission explain exit !!

.exit	rts

;=================================================================





;*********************************************************************
;	raster move
;*********************************************************************
;	;	Hraster ; Vraster
;---------------------------------------------------------------------
wipefreq	equ	0cah	; 59h
wipespeed	equ	010h	; 05h
;---------------------------------------------------------------------


raster_move

	pha			; >>
	lda	#wipespeed
	sta.l	raster_speed	; [speed]
	lda	#wipefreq
	sta.l	raster_freq	; [freq]
	pla			; <<

	cmp	#08
	bcs	.end
	pha			; >>
	asl	a		;
	asl	a		;
	asl	a		;
	eor	#03fh
	sta.l	barnoize_counter
	pla			; <<
	asl	a		; 
	asl	a		; 
	asl	a		; 
	eor	#03fh
	sta.l	raster_amp	; [amp]

.exit	rts

;=====================================================

.end	lda	#0
	sta.l	raster_speed
	sta.l	raster_freq
	sta.l	raster_amp
	sta.l	barnoize_counter
	rts

;*********************************************************************
;	small noize
;*********************************************************************

small_barnoize

	rts

;---------------
; SMALL-NOIZEBAR ======================================================
;---------------

	ldx	dcregister

	lda	_dccounter,x
	clc
	adc	#08h
	and	#1fh
	bit	#10h
	beq	.skip
	eor	#1fh
.skip	cmp	#8
	bcs	.entry
	lda	#0
.entry	lsr	a		; 1,2,3,4
	lsr	a
	sta.l	barnoize_counter

	rts

;---------------
; NOIZE-RASTER ======================================================
;---------------

small_rasternoize

;-------------------------------------------
; <<<<< raster noize >>>>>
;-------------------------------------------

	ifeq	1

	ldy	#0

	lda	_dccounter,x
	;;;;;	 76543210
	bit	#00010000b
	beq	.skip
	and	#00001111b
	bit	#00001000b
	beq	.sos1
	eor	#00001111b	; 00 - max 0F
.sos1	asl	a		; 00 - max 1F
	asl	a		; 00 - max 3F
	lda	#3fh
	tay
.skip	tya
	sta.l	raster_amp
	adc	#20h
	sta.l	raster_freq

	endc

;-------------------------------------------
; mini noize
;-------------------------------------------

	ldx	dcregister
	lda	_dccounter,x
	bit	#00010000b
	beq	.exit
	bit	#00001100b
	bne	.exit
;;;;;	bit	#00000011b
;;;;;	bne	.stop

;-------------------------------------------
; set image noize 
;-------------------------------------------

	a8
	jsl	random_l
	a16
	and	#0fh
	sta	Xwork0
	ldx	dcregister
	lda	_dccounter,x
	and	#20h		; 32
	adc	#60h	
	adc	Xwork0
	sta.l	raster_noizestart	; set start noize
.stop	rts

;-------------------------------------------
; noize exit
;-------------------------------------------

.exit	lda	#0
	sta.l	raster_noizestart
	rts

;-------------------------------------------
;;
;;
;;
;;
;;
;*********************************************************************
;	enemy target message set
;*********************************************************************

Set_enemytargetOBJ
;------------------------------------------
	ldx	dcregister
	lda	_dcwork,x
	inc	a
	and	#0003h
	sta	_dcwork,x
	tax
	lda.l	.attr,x
	and	#00ffh
	xba
;------------------------------------------
	tax			; X = attribute
	ldy	#obj_target&WM	; Y = oam-block
	lda	#263ah		; A = position
;------------------------------------------
	jmp	common_oamset_moveattr
;------------------------------------------
.attr	db	6*2
	db	5*2
	db	4*2
	db	5*2
;------------------------------------------

;*********************************************************************
;	enemy number set
;*********************************************************************

Set_enemynumberOBJ
	ldx	dcregister	; attribute move
	lda	_dcwork+2,x
	inc	a
	cmp	#6
	bcc	.skip
	lda	#0
.skip	sta	_dcwork+2,x
	tax
	lda.l	.attr,x
	and	#00ffh
	xba
	pha

;-------------------------------------------------
;;	ldx	dcregister
;;	lda	_dccounter,x
;;	lsr	a
;;	lsr	a
;;	and	#07h
;;	inc	a
;-------------------------------------------------

 	lda.l	KEnemyNumber	; 0 = 9
	Mkeep_numpointer	; oam-pointer
	lda	#2b80h		; position
	plx			; attribute
	jmp	common_oamset_moveattr


;---------------------------------------------------------------------
.attr	db 4*2
	db 5*2
	db 6*2
	db 7*2
	db 6*2
	db 5*2

;*********************************************************************
;	mission exp sprite program
;*********************************************************************
oamset_target
	jmp	Newoamset
;---------------------------------------------------------------------





















;*********************************************************************
;	
;	Bitmap Program
;
;*********************************************************************
;*********************************************************************
;		*************************************************
; demo Battle	*************************************************
;		*************************************************
;*********************************************************************

bitmapdemo_explain

	a8
	poll_mario
	ramnastyoff
	a16
	lda.l	barnoize_counter	; memory copy	
	sta.l	m_barnoize_counter
	lda.l	videonoize_counter
	sta.l	m_videonoize_counter
	a8
	call_mario	noize_test
	unpoll_mario
	a16

	rts

;====================================================================
;====================================================================
; END END END END END END END END END END END END END END END END  
;====================================================================
;====================================================================

