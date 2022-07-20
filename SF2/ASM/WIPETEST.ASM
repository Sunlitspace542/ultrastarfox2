;===================================================================
;===================================================================
;*******************************************************************
;*  WIPE (8)		***********************************************
;* (new wipetest )	***********************************************
;*	192line	***********************************************
;*		***********************************************
;*******************************************************************
;===================================================================
;===================================================================
;
;
;-------------------------------------------------------------------

winpoly_bank	equ	*&0ff0000h

;*******************************************************************
;	work 	memoery	( common )
;*******************************************************************

work_x1	equ	Xwork0		;  
work_y1	equ	Xwork1		;
work_x2	equ	Xwork2		;
work_y2	equ	Xwork3		; 
work_ycount	equ	Xwork4		; y LINE COUNT
work_pointer	equ	Xwork5		; window pointer
;---------------------------------------------
;;;;	equ	Xwork6		; multiply
;;;;	equ	Xwork7		; multiply
;---------------------------------------------
clip_min	equ	Xwork6
clip_xx	equ	Xwork7	
;---------------------------------------------
wp_minpointer equ	Xwork8	
wp_maxpointer equ	Xwork9
wp_mainpointer equ	Xwork10
;---------------------------------------------

;*******************************************************************
;	work memoery
;*******************************************************************

;--------------------------------------------------
clip_pointer	equ	wipe_test+0
clip_counter	equ	wipe_test+2
clip_mode	equ	wipe_test+4
wp_pointerend equ	wipe_test+6	; WORK !!
work_xadd	 equ	wipe_test+8	; WORK !!
wp_angle	equ	wipe_test+10	; angleset work
wp_angsin	equ	wipe_test+12	; sin angle data
wp_angcos	equ	wipe_test+14	; cos angle data
wp_test	equ	wipe_test+16	; work
wp_spotwork	equ	wipe_test+18	;
wp_romangle	equ	wipe_test+20
wp_coloranime equ	wipe_test+22	; color anime pointer
wp_zoom	equ	wipe_test+24
;--------------------------------------------------
wp_testang	equ	wipe_test+26
wp_romaddr	equ	wipe_test+28
;--------------------------------------------------
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
;*******************************************************************
; 	polywipe main program
;*******************************************************************
;
; X = winpoly shape ROM pointer
;
;-------------------------------------------------------------------
polywipe_2
	lda	#2
	sta	work_pointer
	bra	polywipe_common
polywipe_1
	stz	work_pointer
polywipe_common
	jsr	world_window		; X=pointer
	jsr	param_windowpolygon
	jsr	point_rotate
	jsr	point_clip
	jmp	rotate_window


;*******************************************************************
;	2D set matrix 
;*******************************************************************

param_windowpolygon


	lda	wp_angle
	jsr	Func_SIN
	sta	wp_angsin
	lda	wp_angle
	jsr	Func_COS
	sta	wp_angcos

	rts


;*******************************************************************
;	set world window
;*******************************************************************
;
; x = winpoly shape ROM pointer
;
;	if 0 then exit 
;
;	set wp_total
;	set wp_world
;
;
;-------------------------------------------------------------------

world_window
	txa
	beq	.exit

	ldy	#0			; RAM-pointer

	lda.l	winpoly_bank,x
	and	#00ffh
	sta	wp_total
	asl	a
	sta	Xwork0
	inx

.loop	lda.l	winpoly_bank,x

	phy			; >>
	ldy	wp_mainzoom	; ZOOM
	jsl	ML_s16s16_l
	asl	a
	ply			; <<

	sta.w	wp_world,y
	inx
	inx
	iny
	iny
	dec	Xwork0
	bne	.loop

.exit	rts



;*******************************************************************
;	wipetest
;*******************************************************************

rotate_window

;--------------------------------------------
	jsr	ymin_check

;--------------------------------------------
	ldx	wp_minpointer
	stx	wp_mainpointer
.loop1	jsr	get_leftparam
	jsr	setleft1
	ldx	wp_mainpointer
	cpx	wp_maxpointer
	bne	.loop1
;--------------------------------------------
	ldx	wp_minpointer
	stx	wp_mainpointer
.loop2	jsr	get_rightparam
	jsr	setright1
	ldx	wp_mainpointer
	cpx	wp_maxpointer
	bne	.loop2
;--------------------------------------------
;-----------------------------------------------------

	rts


;*******************************************************************
;	point clipping !!
;*******************************************************************
;;
;;
;;
;;
;-------------------------------------------------------------------
Mcliploop	macro	[clipwork,jmpaddr,x1,y1,x2,y2]

	lda	{clipwork}
	sta	clip_min	; clipping point

	jsr	copy_tmp	; copy pointdata

	ldy	wp_total	; original total
	stz	wp_total	; clipping total
	stz	clip_pointer	; clipping pointer
	ldx	#0		; original pointer
.loop\@
	lda	wp_tmprotate+0,x  ; point 1
	sta	work_{x1}
	lda	wp_tmprotate+2,x  ; (Y)
	sta	work_{y1}
	lda	wp_tmprotate+4,x  ; point 2
	sta	work_{x2}
	lda	wp_tmprotate+6,x  ; (Y)
	sta	work_{y2}

	phy			; >>
	phx			;   >>
	jsr	{jmpaddr}		;
	plx			;   <<
	ply			; <<
	
	inx	; 
	inx
	inx
	inx
	dey
	bne	.loop\@

	endm
;-------------------------------------------------------------------

point_clip

	stz	clip_mode
	Mcliploop	wp_clipYmin,clip_entry1,x1,y1,x2,y2
	Mcliploop	wp_clipYmax,clip_entry2,x1,y1,x2,y2
	dec	clip_mode
	Mcliploop	wp_clipXmin,clip_entry1,y1,x1,y2,x2
	Mcliploop	wp_clipXmax,clip_entry2,y1,x1,y2,x2

	rts


;*******************************************************************
;	copy temp buffer
;*******************************************************************
;;
;; COPY  ( rotation data ==> tmp rotation )
;;
;-------------------------------------------------------------------

copy_tmp
;-----------------------------------------------------
	lda	wp_total
	asl	a		; x,y
	tay
	asl	a
	sta	wp_pointerend	; 

;-----------------------------------------------------
	ldx	#0		  ; [point copy]
.loop	lda	wp_rotate,x
	sta	wp_tmprotate,x
	inx
	inx
	dey
	bne	.loop
;-----------------------------------------------------	
	lda	wp_rotate+0	  ; [first point]
	sta	wp_tmprotate+0,x
	lda	wp_rotate+2
	sta	wp_tmprotate+2,x
;-----------------------------------------------------
	rts


;*******************************************************************
;	------------------
;	 clipping program
;	------------------
;*******************************************************************
;
;	work_x1		X line clipping
;	work_x2
;
;	work_y1		Y line clipping
;	work_y2
;
;	clip_min
;	clip_max
;
;	X reg = clip pointer
;
;--------------------------------------------------------------------

clip_entry1

	lda	work_y1
	cmp	clip_min
	bmi	.min
	lda	work_y2
	cmp	clip_min
	bmi	safe_x1
	bpl	clip_off

.min	lda	work_y2
	cmp	clip_min
	bmi	clip_over
	bpl	safe_x2

;-------------------------------------------------------------
clip_over	
	rts
;-------------------------------------------------------------
safe_x1
	jsr	clip_off	; set position 1
	jsr	swap_x12y12	; swap parameter
	jsr	clippos_calc	; set position 2
	jmp	clip_off
;-------------------------------------------------------------
safe_x2	jsr	clippos_calc
;-------------------------------------------------------------------
clip_off
	ldx	clip_pointer

	lda	clip_mode
	beq	.clipY

.clipX	lda	work_y1		; <<<<< SWAP >>>>>
	sta	wp_rotate+0,x
	lda	work_x1
	sta	wp_rotate+2,x
	bra	.skip

.clipY	lda	work_x1
	sta	wp_rotate+0,x
	lda	work_y1
	sta	wp_rotate+2,x

.skip	inx
	inx
	inx
	inx
	stx	clip_pointer
	inc	wp_total
	rts

;-------------------------------------------------------------------
swap_x12y12
	ldx	work_y1		; swap y1,y2
	lda	work_y2
	sta	work_y1
	stx	work_y2

	ldx	work_x1		; swap x1,x2
	lda	work_x2
	sta	work_x1
	stx	work_x2

	rts
;-------------------------------------------------------------------
















;*******************************************************************
;	clippos calc
;*******************************************************************
;
;	x1,y1
;	x2,y2
;
;	x1,y1
;
;-------------------------------------------------------------
clippos_calc
	lda	work_x2
	sta	clip_xx
.loop	clc
	lda	work_y2
	cmp	clip_min
	beq	.end
	bmi	.end
	clc
	adc	work_y1
	Masr1
	cmp	clip_min
	bpl	.max
	bmi	.min

;-------------------------------------------------------------
.min	sta	work_y1
	lda	work_x1
	clc
	adc	work_x2
	Masr1
	sta	work_x1
	sta	clip_xx
	bra	.loop

;-------------------------------------------------------------
.max	sta	work_y2
	lda	work_x1
	clc
	adc	work_x2
	Masr1
	sta	work_x2
	sta	clip_xx
	bra	.loop

;-------------------------------------------------------------
.end
	lda	clip_xx
	sta	work_x1
	lda	clip_min
	sta	work_y1

	rts

;=============================================================





























;*******************************************************************
;	------------------
;	 clipping program
;	------------------
;*******************************************************************
;
;	work_x1		X line clipping
;	work_x2
;
;	work_y1		Y line clipping
;	work_y2
;
;	clip_min
;	clip_max
;
;	X reg = clip pointer
;
;--------------------------------------------------------------------
clip_max	equ	clip_min
;--------------------------------------------------------------------
clip_entry2
	lda	work_y1
	cmp	clip_max
	bpl	.out
	lda	work_y2
	cmp	clip_max
	bpl	.safe_first
	bmi	.clipoff

.out	lda	work_y2
	cmp	clip_max
	bpl	.over
	bmi	.safe_second

;-------------------------------------------------------------
.over
	rts
;-------------------------------------------------------------
.safe_first
	jsr	clip_off	; set position 1
	jsr	swap_x12y12
	jsr	clippos_calc2	; set position 2
	jmp	clip_off
;-------------------------------------------------------------
.safe_second
	jsr	clippos_calc2
;-------------------------------------------------------------------
.clipoff	jmp	clip_off
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
;
;*******************************************************************
;	clippos calc
;*******************************************************************
;
;	x1,y1
;	x2,y2
;
;	x1,y1
;
;-------------------------------------------------------------
clippos_calc2
	lda	work_x1
	sta	clip_xx
.loop	clc
	lda	work_y1
	cmp	clip_max
	beq	.end
	bmi	.end
	clc
	adc	work_y2
	Masr1
	cmp	clip_max
	bpl	.max
	bmi	.min

;-------------------------------------------------------------
.max	sta	work_y1
	lda	work_x1
	clc
	adc	work_x2
	Masr1
	sta	work_x1
	sta	clip_xx
	bra	.loop

;-------------------------------------------------------------
.min	sta	work_y2
	lda	work_x1
	clc
	adc	work_x2
	Masr1
	sta	work_x2
	sta	clip_xx
	bra	.loop

;-------------------------------------------------------------
.end
	lda	clip_xx
	sta	work_x1
	lda	clip_max
	sta	work_y1

	rts

;=============================================================
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
;*******************************************************************
;	window polygon rotation
;*******************************************************************
Mmult_winpoly macro
	jsl	ML_s16s16_l
	sty	work_x1
	asl	work_x1
	rol	a
	endm
;-------------------------------------------------------------------

point_rotate


	lda	wp_total	; vartex total
	sta	work_y1

	ldx	#0

.loop	
	lda	wp_world+0,x

	ifeq	0
	ldy	wp_angcos		; cos
	Mmult_winpoly
	sta	work_x2

	lda	wp_world+2,x
	Mnegative
	ldy	wp_angsin		; sin
	Mmult_winpoly
	clc
	adc	work_x2
	endc

	clc
	adc	wp_centerX
	sta	wp_rotate+0,x
					; X sin + Y cos
	lda	wp_world+0,x

	ifeq	0
	ldy	wp_angsin
	Mmult_winpoly
	sta	work_x2

	lda	wp_world+2,x
	ldy	wp_angcos
	Mmult_winpoly
	clc
	adc	work_x2
	endc

	clc
	adc	wp_centerY
	sta	wp_rotate+2,x

	inx
	inx
	inx
	inx
	dec	work_y1
	bne	.loop

	rts

;--------------------------------------------------------------------
;
;
;
;
;
;
;
;
;*******************************************************************
;	Ymin check & go 
;*******************************************************************
;
;
; wp_total .......	polygon window CYOUTEN NO KAZU
; wp_pointerend ..	wp_rotate NO OWARI
; wp_minpointer ..   Y min
; wp_maxpointer ..   Y max
;
;
;-------------------------------------------------------------------

ymin_check
	lda	wp_total
	tay
	asl	a
	asl	a
	sta	wp_pointerend	; 

	lda	#07fffh
	sta	work_x1		; min pointer
	lda	#0ffffh
	sta	work_x2		; max pointer

	ldx	#0
.loop	lda	wp_rotate+2,x
	cmp	work_x1		; dataY MIN
	bpl	.next1
	sta	work_x1		; dataY MIN
	stx	wp_minpointer
.next1	cmp	work_x2
	bmi	.next2
	sta	work_x2
	stx	wp_maxpointer
.next2
	inx
	inx
	inx
	inx	
	dey
	bne	.loop

	rts

;*******************************************************************
;	get right fill parameter
;*******************************************************************

get_rightparam

	ldx	wp_mainpointer

	lda	wp_rotate+0,x	; ( point 1 )
	sta	work_x1
	lda	wp_rotate+2,x
	sta	work_y1

	inx
	inx
	inx
	inx
	cpx	wp_pointerend
	bcc	.next1
	ldx	#0

.next1	lda	wp_rotate+0,x	; ( point 2 )
	sta	work_x2
	lda	wp_rotate+2,x
	sta	work_y2

	stx	wp_mainpointer
	rts

;*******************************************************************
;	get left fill parameter
;*******************************************************************

get_leftparam
	ldx	wp_mainpointer

	lda	wp_rotate+0,x	; ( point 1 )
	sta	work_x1
	lda	wp_rotate+2,x
	sta	work_y1

	cpx	#0
	bne	.skip
	ldx	wp_pointerend

.skip	dex
	dex
	dex
	dex

	lda	wp_rotate+0,x	; ( point 2 )
	sta	work_x2
	lda	wp_rotate+2,x
	sta	work_y2

	stx	wp_mainpointer
	rts

;*******************************************************************
;	WRITE WIPE BUFFER
;*******************************************************************
;
; [window polygon] 
;
;  Xaddr .... window pointer
;  x1    ...  xposition
;  y1    ...  yposition
;
;-------------------------------------------------------------------
; (1) LEFT WINDOW LINE
;-------------------------------------------------------------------

setright1
	lda	#1
	tsb	work_pointer
;--------------------------------------
setleft1	

	lda	work_y2	
	sec
	sbc	work_y1		; Y2 - Y1
	sta	work_ycount
	tax
	bmi	setwinbuff_exit
	beq	setwinbuff_exit

	lda	work_x2
	sec
	sbc	work_x1		; X2 - X1
	php
	Mabsolute
	xba
	Mdiv_u16u8_X		; X
	plp
	Mabsolute
	sta	work_xadd	; x addinc

;--------------------------------------

	lda	work_x1
	xba
	sta	work_x1		; initial x data
	ldx	work_ycount	; 
	lda	work_y1		; initial y pointer
	asl	a
	asl	a
	adc	work_pointer
	tay			; y Counter

.loop	a8
	lda	work_x1+1
	sta	(Xaddr),y	; left OR right
	iny
	iny
	iny
	iny
	a16cC
	lda	work_x1
	adc	work_xadd
	sta	work_x1
	dex
	bne	.loop

setwinbuff_exit
	rts

;*******************************************************************
;	COS/SIN
;*******************************************************************
; 
; Aregister Angle 0000 - FFFF
;
;
;-------------------------------------------------------------------
Func_cos	clc
	adc	#04000h
Func_sin	and	#0ff00h
	xba
	tax
	lda.l	ramsintab,x
	and	#000ffh
	xba
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
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;
;
;
;*******************************************************************
;	-------------------
;	 star wipe program
;	-------------------
;*******************************************************************

wipestar_close
	jsr	dc_program
	dwnext	clear_fullopen
	dwnext	starclose_wipeinit1
	dwloop	4,starclose_wipeinit2
	dwloop	24,starclose_loop
	dwstop	starclose_end

;-------------------------------------------------------------------
;	starclose initialize (1)
;-------------------------------------------------------------------
starclose_wipeinit1

	jsr	set_param
	db	0ffh,0ffh,00fh	; window switch
	db	055h,055h	; window logic
	db	00h		; 212dh
	db	00h,000h,0e0h	; 2130,31,32
	rts

;-------------------------------------------------------------------
;	starclose initialize (2)
;-------------------------------------------------------------------
starclose_wipeinit2

	jsr	swap_bufferFULL
	jmp	open_alldisplay	; full open

;-------------------------------------------------------------------
;	starclose main loop
;-------------------------------------------------------------------
starclose_loop

	jsr	Set_displayclip
	jsr	swap_bufferFULL
	jsr	clear_alldisplay	


; Set Angle ------------------------------
	lda	wp_mainangle
	clc
	adc	#00300h
	sta	wp_mainangle

; Set Zoom  ------------------------------
	ldx	dcregister
	lda	_dctimer,x	; 0000h - 6000h
	xba
	asl	a
	asl	a
	clc
	adc	#1600h	
	sta	wp_mainzoom

; Set Center ------------------------------

	lda.l	mmx_wipeposX	; (X) POSITION
	and	#00ffh
	sta	wp_centerX
	lda.l	mmx_wipeposY	; (Y) POSITION
	and	#00ffh
	sta	wp_centerY


; Draw window polygon ---------------------

	lda	wp_mainangle
	sta	wp_angle
	ldx	#winpoly_star&WM	; ROM-pointer
	jsr	polywipe_1
	lda	wp_mainangle
	clc	
	adc	#8000h
	sta	wp_angle
	ldx	#winpoly_star&WM	; ROM-pointer
	jmp	polywipe_2

;-------------------------------------------------------------------
;	starclose end square
;-------------------------------------------------------------------
wp_clipleft	equ	002h
wp_clipright	equ	0feh
wp_clipup	equ	002h
wp_clipdown	equ	0deh
;--------------------------------

starclose_end

	jsr	swap_bufferFULL
	jsr	clear_alldisplay

	Mset	wp_mainzoom,7fffh
	Mset	wp_angle,0

	ldx	#cube_wipestop&WM	; ROM-pointer
	jmp	polywipe_1

;-------------------------------------------------------------------
cube_wipestop
	db	4
	dw	17,-17
	dw	17,17
	dw	-17,17
	dw	-17,-17

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
;*******************************************************************
;	-------------------
;	 beam wipe program 
;	-------------------
;*******************************************************************
wipebeam_open

	jsr	dc_program
	dwstart			
	dwwait	5
	dwnext	clear_fullclose
	dwnext	beam_wipeinit
	dwstop	beam_wipemain

;*******************************************************************
;	initialize
;*******************************************************************

beam_wipeinit

	stz	wp_testang

	jsr	set_param
	db	000h,000h,0a0h	; window switch
	db	00h,00h		; window logic
	db	00h		; 212dh
	db	10h,03fh,0e8h	; 2130,31,32

	rts

;*******************************************************************
;	window program
;*******************************************************************



;-------------------------------------------------------------------

beam_wipemain
	
	ldx	dcregister	
	lda	_dccounter,x
	and	#80h
	beq	.beam

	jmp	bomb_program

;-------------------------------------------------------------------
;	BOMB !!!
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
;-------------------------------------------------------------------
;-------------------------------------------------------------------

.beam

;
;
;-------------------------------------------------------------------
; point 1,2 / x,y
;-------------------------------------------------------------------
; P1 (30h,80h)
; P2 (80h,20h)
;================================================
; Set corneria Position
;================================================

	ldx	kx_corneriaptr
	lda.w	mmx_planetcx,x
	and	#00ffh
	sta	p2A_x
	lda.w	mmx_planetcy,x
	and	#00ffh
	sta	p2A_y

;================================================
; enemy planet position
;================================================

	ldx	dcregister
	lda	_dccounter,x
	and	#01111111b
	bne	.setskip

.loop	ldx	wp_testang
	bne	.entry

	ldx	kx_planetlistptr
	stx	wp_testang

.entry	cpx	kx_corneriaptr
	bne	.aaa
	lda.w	mmx_planetnext,x
	sta	wp_testang
	bra	.loop

.aaa

	lda.w	mmx_planetcx,x
	and	#00ffh
	sta	p1_x
	lda.w	mmx_planetcy,x
	and	#00ffh
	sta	p1_y
	lda.w	mmx_planetnext,x
	sta	wp_testang


.setskip

;================================================
; enemy planet position
;================================================


	sec
	lda	p2A_x
	sbc	p1_x
	asl	a
	asl	a
	tay

	ldx	dcregister
	lda	_dccounter,x
	bit	#0040h
	beq	.s1
	lda	#003fh
.s1	and	#003fh
	xba
	pha

	jsl	ML_s16s16_l

	clc
	adc	p1_x
	sta	p2_x



	sec
	lda	p2A_y
	sbc	p1_y
	asl	a
	asl	a
	tay
	pla
	jsl	ML_s16s16_l

	clc
	adc	p1_y
	sta	p2_y


;----------------------------------------
; calc arctan
;----------------------------------------

	sec
	lda	p2_x
	sbc	p1_x
	pha
  	sta	x1	; p2(x)-p1(x)

	sec
	lda	p2_y
	sbc	p1_y	; p2(y)-p1(y)
	pha
	sta	y1

	jsl	arctan16_l

;----------------------------------------

	tax			; <<
;----------------------------------------
; <<<<< hosei program >>>>>
;----------------------------------------
	clc
	lda	#200h
	ply
	beq	.entry2
	bpl	.skip2
.entry2	sbc	#080h	
.skip2	
;-------------------------------
	ply			; X ga minus no toki ha hirogeru !!!
	beq	.entry3
	bpl	.skip3
.entry3	adc	#180h
.skip3	sta	Xwork2
;----------------------------------------
	txa			; <<
;----------------------------------------
;
;
;
;
;
;
;----------------------------------------
; x1 * cos 
;----------------------------------------
	pha			; >>
	jsr	Func_cos
	ldy	Xwork2
	jsl	ML_s16s16_l
	xba
	Msex
	sta	Xwork0

;----------------------------------------
; x1 * sin
;----------------------------------------
	pla			; <<
	jsr	Func_sin
	tay
	lda	Xwork2
	Mnegative		;
	jsl	ML_s16s16_l
	xba
	Msex
	sta	Xwork1

;----------------------------------------
;
; <<<<< make beam polygon >>>>>
;
;----------------------------------------

	lda	Xwork0
	Mnegative
	clc
	adc	p1_x		; ( point 1 )
	sta	wp_world+0


	lda	Xwork1
	Mnegative
	clc
	adc	p1_y
	sta	wp_world+2

;----------------------------------------

	lda	Xwork0		; ( point 2 )
	clc
	adc	p1_x
	sta	wp_world+4

	lda	Xwork1
	clc
	adc	p1_y
	sta	wp_world+6

;----------------------------------------

	lda	Xwork0		; ( point 3 )
	clc
	adc	p2_x
	sta	wp_world+8

	lda	Xwork1
	clc
	adc	p2_y
	sta	wp_world+10

;----------------------------------------

	lda	Xwork0
	Mnegative
	clc
	adc	p2_x		; ( point 4 )
	sta	wp_world+12

	lda	Xwork1
	Mnegative
	clc
	adc	p2_y
	sta	wp_world+14

;--------------------------------------------------------------------

	jsr	Set_displayclip
	jsr	swap_bufferFULL
	jsr	clear_alldisplay	
	jsr	winpoly_coloranime

	Mset	wp_total,4	; total 4
	stz	wp_angle	; angle 0
	Mset	wp_centerX,000h	; Set Center X 
	Mset	wp_centerY,000h	; Set Center Y
	ldx	#0
	jsr	polywipe_1

	rts

;===================================================================
;	--------------
;	 star program
;	--------------
;===================================================================

bomb_end	rts
bomb_program

	jsr	winpoly_coloranime_XX
	jsr	swap_bufferFULL
	jsr	clear_alldisplay

;---------------------------------------------
; set zoom
	ldx	dcregister	
	lda	_dccounter,x
	and	#7fh
	cmp	#20h
	bcs	bomb_end
	xba
	sta	wp_mainzoom

;---------------------------------------------
; set angle
	lda	wp_mainangle
	clc
	adc	#0d00h
	sta	wp_mainangle	; Set Angle
	sta	wp_angle
;---------------------------------------------
; set center
	lda	p2_x		; Set Center
	sta	wp_centerX
	lda	p2_y
	sta	wp_centerY

;---------------------------------------------
; draw window
	jsr	Draw_star1window

.exit	rts


;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------








;
;
;
;
;
;-------------------------------------------------------------------




;*******************************************************************
;	---------------------------
;	 title wipe program (test)
;	---------------------------
;*******************************************************************

;*******************************************************************
;	title wipe close
;*******************************************************************

wipetitle_close

	a8
	alloc_window wipe,1
	stz	wm_coldata_r,x	; 
	stz	wm_coldata_g,x	; 
	stz	wm_coldata_b,x	; 
	a16
		
	rts

;*******************************************************************
;	title wipe open
;*******************************************************************
wipetitle_open

	lda.l	kw_GameMode
	and	#00ffh
	cmp	#kmode_title
	bne	.exit

	jsr	dc_program
	dwstart			
	dwwait	5
	dwnext	clear_fullclose
	dwnext	title_wipeinit
	dwstop	title_wipemain

.exit	rts


;*******************************************************************
;	-----------------------
;	 wipe title initialize
;	-----------------------
;*******************************************************************

title_wipeinit
	jsr	set_param
	db	000h,000h,0a0h	; window switch
	db	00h,00h		; window logic
	db	00h		; 212dh
	db	10h,03fh,0e8h	; 2130,31,32

	rts

;*******************************************************************
;	-----------------
;	 wipe title main
;	-----------------
;*******************************************************************

title_wipemain

	jsr	set_bitmapclip
	jsr	swap_buffer
	jsr	clear_polygondisplay
	jsr	winpoly_coloranime_XX

	Mset	wp_centerX,080h	; Set Center X 
	Mset	wp_centerY,080h	; Set Center Y

	lda	#1000h
	sta	wp_mainzoom

	lda	wp_mainangle
	clc
	adc	#0300h
	sta	wp_mainangle
	sta	wp_angle

	jmp	Draw_star1window



;====================================================================
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
;*******************************************************************
;	---------
;	 LIBRARY
;	---------
;*******************************************************************
;*******************************************************************
;	set clipping position
;*******************************************************************

Set_displayclip
	Mset	wp_clipYmin,wp_clipup
	Mset	wp_clipYmax,wp_clipdown
	Mset	wp_clipXmin,wp_clipleft
	Mset	wp_clipXmax,wp_clipright
	rts

;-------------------------------------------------------------------

Set_bitmapclip
	Mset	wp_clipYmin,020h
	Mset	wp_clipYmax,0c0h
	Mset	wp_clipXmin,020h
	Mset	wp_clipXmax,0e0h
	rts

;********************************************************************
;	wipebuffer clear
;********************************************************************


;--------------------------------------------------------------------
clear_polygondisplay
	ldx	#192
	bra	clear_commondisplay
clear_alldisplay
	ldx	#224
clear_commondisplay
	ldy	#0		; clear window
	lda	#0001h
	jmp	wipe_bufferset12

;--------------------------------------------------------------------

open_alldisplay
	ldx	#224
	lda	#0ff00h
	ldy	#0
	jmp	wipe_bufferset12

;*******************************************************************
;	star 1 window
;*******************************************************************

Draw_star1window
	ldx	#winpoly_data&WM
	jsr	polywipe_1
	lda	wp_angle
	clc	
	adc	#4000h
	sta	wp_angle
	ldx	#winpoly_data&WM
	jmp	polywipe_2

;-------------------------------------------------------------------

winpoly_data
	db	4
	dw	0,-60*2
	dw	150*2,0
	dw	0,60*2
	dw	-150*2,0

;-------------------------------------------------------------------
winpoly_star
	db	3
	dw	0,-60*4
	dw	52*4,30*4
	dw	-52*4,30*4

;********************************************************************
;	color animation 1
;********************************************************************

winpoly_coloranime_XX

	a8
	alloc_window wipe,1

	txy
	ldx	dcregister	
	lda	_dccounter,x
	and	#1fh
	eor	#1fh
	sta.w	wm_coldata_r,y	; 

	lda	#0
	sta.w	wm_coldata_g,y	; 
	sta.w	wm_coldata_b,y	; 
	sta.w	wm_coldata,y	; set color

	a16

	rts

;********************************************************************
;	color animation 2
;********************************************************************

winpoly_coloranime

	a8
	alloc_window wipe,1


;---------------------------------------
	ifeq	1

	lda	wp_coloranime
	inc	a
	and	#000111111b
	sta	wp_coloranime
	bit	#000100000b
	beq	.setcol
	eor	#000011111b
.setcol
	endc
;---------------------------------------

	txy
	inc	wp_coloranime
	lda	wp_coloranime
	and	#07h
	tax

	lda.l	.R,x
	sta.w	wm_coldata_r,y	; 
	lda.l	.G,x
	sta.w	wm_coldata_g,y	; 
	lda.l	.B,x
	sta.w	wm_coldata_b,y	; 
	lda	#0
	sta.w	wm_coldata,y	; set color

	a16

;---------------------------------------------
	rts

;--------------------------------------------------------------------

.R	db	1fh,1fh,1fh,00h,00h,00h,1fh,1fh
.G	db	1fh,00h,1fh,1fh,00h,1fh,00h,00h
.B	db	1fh,00h,00h,1fh,1fh,00h,00h,1fh

;--------------------------------------------------------------------
;;;;
;;;;
;;;;
;;;;
;;;;
;====================================================================
;====================================================================
; END END END END END END END END END END END END END END END END
;====================================================================
;====================================================================

