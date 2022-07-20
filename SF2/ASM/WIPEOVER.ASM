;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: wipeover.asm				*
;* 	Description	: gameover wipe close			*
;*	Date		: 1995.3.28				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
;*********************************************************************
;	------------------------------
; 	 Test Title Open Wipe Window
;	------------------------------
;*********************************************************************

wipeover_close
	jsr	dc_program
	dwnext	clear_fullopen
	dwwait	5
	dwnext	overclose_init
	dwloop	24,overclose_main
	dwwait	10
	dwnext	offswitch 	
	dwwait	2		
	dwnext	endofwipe	


;****************************************************************
;
;
;
;-------------------------------------------------------------------
overclose_init
	jsr	set_param
	db	0ffh,0ffh,00fh	; window switch
	db	055h,055h	; window logic
	db	00h		; 212dh
	db	00h,000h,0e0h	; 2130,31,32


	rts

;-------------------------------------------------------------------
overclose_main

	Mset	wp_clipYmin,000h
	Mset	wp_clipYmax,0c0h
	Mset	wp_clipXmin,010h
	Mset	wp_clipXmax,0f0h

	jsr	swap_buffer
	jsr	clear_alldisplay

	lda	#0028h
	sta	wp_centerX
	lda	#0018h
	sta	wp_centerY

	lda	wp_mainangle
	clc
	adc	#00300h
	sta	wp_mainangle

	ldx	dcregister
	lda	_dctimer,x
	xba
	asl	a
	asl	a
	sta	wp_mainzoom

	lda	wp_mainangle
	sta	wp_angle
	ldx	#winpoly_star2&WM	; ROM-pointer
	jsr	polywipe_1
	lda	wp_mainangle
	clc	
	adc	#8000h
	sta	wp_angle
	ldx	#winpoly_star2&WM	; ROM-pointer
	jmp	polywipe_2


;=====================================================================
;	End !!
;=====================================================================
