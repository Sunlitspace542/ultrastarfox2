

;===================================================================
;===================================================================
;===================================================================
;*******************************************************************
;*		***********************************************
;*  WIPE (4)		***********************************************
;*		***********************************************
;* ( objmask wipe )	***********************************************
;*		***********************************************
;*******************************************************************
;===================================================================
;===================================================================
;===================================================================
;
;
;
;
;
;
;
;
;
;*******************************************************************
;	  << open >>
;*******************************************************************
wipedemo_open
	jsr	dc_program
	dwnext	objmask_wipeinit
	dwnext	objmask_wipemain
	dwstop	objmask_wipeloop

;-------------------------------------------------------------------
objmask_wipeinit
	lda	#0f010h
	jmp	wipe_clear

;-------------------------------------------------------------------
objmask_wipemain
	jsr	set_param
	db	000h,000h,00fh	; window switch
	db	00h,00h		; window logic
	db	00h		; 212dh
	db	00h,00h,000h	; 2130,31,32
	rts

;-------------------------------------------------------------------
objmask_wipeloop
	rts

;-------------------------------------------------------------------
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
;===================================================================
;===================================================================
;===================================================================
;*******************************************************************
;*		***********************************************
;*  WIPE (4)		***********************************************
;*		***********************************************
;* ( game wipe )	***********************************************
;*		***********************************************
;*******************************************************************
;===================================================================
;===================================================================
;===================================================================
;*******************************************************************
;	  << close >>
;*******************************************************************
wipegame_close
	jsr	dc_program
	dwnext	clear_fullclose
	dwnext	w4close_init
	dwloop	50,w4close_main
	dwnext	offswitch
	dwwait	2
	dwstop	endofwipe

;*******************************************************************
;	  << open >>
;*******************************************************************
wipegame_open	
	jsr	dc_program
	dwnext	clear_fullclose
	dwnext	w4open_init1
	dwnext	w4open_init2
	dwloop	34/2,w4open_main
	dwnext	offswitch
	dwwait	2
	dwnext	clear_fullopen
	dwstop	endofwipe

;-------------------------------------------------------------------

w4open_init1

	ldx	dcregister	; >>	CAUTION !!
	phx	
	jsl	init_gameobj_l	; << gameobj >> / << hell >>
	plx
	stx	dcregister	; <<	CAUTION !!


w4close_init
w4init_common

	km_bitcheckscreenflag halfadd 
	bne	.half

	jsr	set_param
	db	0ffh,0ffh,00fh	; window switch
	db	00h,00h		; window logic
	db	03h		; 212dh
	db	02h,10h,0e0h	; 2130,31,32
	rts

.half	jsr	set_param
	db	0ffh,0ffh,00fh	; window switch
	db	00h,00h		; window logic
	db	03h		; 212dh
	db	02h,50h,0e0h	; 2130,31,32
	rts

;-------------------------------------------------------------------
w4open_init2
	Mon_objmeter	
	bra	w4init_common
;-------------------------------------------------------------------
;
;
;
;*******************************************************************
;	  << open >>
;*******************************************************************
w4open_main
w4close_main
;-------------------------------------------------------------------
;; Set HDMA Paramter


	jsr	swap_buffer

	jsr	w4_calc1
	jsr	w4_calc2
	jsr	w4_copy

	rts

;-------------------------------------------------------------------

w4_copy

	lda	#191*4
	clc
	adc	Xaddr
	tay

	lda	#12*4
	clc
	adc	Xaddr
	tax

	lda	#108-16
	sta	Xcounter
.loop
	lda.w	0,x
	sta.w	0,y
	lda.w	2,x
	sta.w	2,y
	inx
	inx
	inx
	inx
	dey
	dey
	dey
	dey
	dec	Xcounter

	bne	.loop
	rts


;*******************************************************
;	  calc
;*******************************************************

w4_calc1
	ldx	dcregister
	ldy	#0
	lda	#120-16
	sta	Xcounter

	lda	#0
	sta	temp_1L
	sta	temp_2L
	lda	_dccounter,x
	asl	a		;; speed up

	asl	a
	asl	a
	asl	a
	asl	a
	sec	
	sbc	#256+40
	sta	temp_1R
	sta	temp_2R

.loop1
	lda	Xcounter
	and	#01000b
	beq	.skip1
	jsr	set_w4		; windwow anmation
	bra	.skip2
.skip1  iny
	iny
	iny
	iny

.skip2
	lda	temp_1R
	clc
	adc	#2
	sta	temp_1R
	sta	temp_2R

	dec	Xcounter
	bne	.loop1

	rts

;------------------------------------------------------
w4_calc2
	ldx	dcregister
	ldy	#0
	lda	#120-16
	sta	Xcounter


	lda	#0ffh
	sta	temp_1R
	sta	temp_2R
	lda	_dccounter,x	
	asl	a		; speed up
	asl	a
	asl	a
	eor	#0ffffh
	inc	a	  
	clc
	adc	#64-1
	asl	a
	asl	a
	clc
	adc	#256+40
	sta	temp_1L
	sta	temp_2L

.loop2  

	lda	Xcounter
	and	#01000b
	bne	.skip1
	jsr	set_w4		; windwow anmation
	bra	.skip2
.skip1  	iny
	iny
	iny
	iny

.skip2
	lda	temp_1L
	sec
	sbc	#2
	sta	temp_1L
	sta	temp_2L

	dec	Xcounter
	bne	.loop2

	rts
;------------------------------------------------------

;*******************************************************
;	  1 line window set
;*******************************************************
set_w4
;----------------------------------------
.loop

	lda	temp_1R	    ; window 1 right
	Mwipeclip
	xba
	sta	Xtemp

	lda	temp_1L		; window 1 left
	Mwipeclip
	ora	Xtemp
	Mwipelimitcheck
	sta	[Xaddr],y

	iny
	iny

	lda	temp_2R	    ; window 2 right
	Mwipeclip
	xba
	sta	Xtemp

	lda	temp_2L	    ; window 2 left
	Mwipeclip
	ora	Xtemp
	Mwipelimitcheck
	sta	[Xaddr],y

	iny
	iny

	rts


;====================================================================
;====================================================================


