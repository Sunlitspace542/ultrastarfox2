;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: raster.asm				*
;* 	Description	: H-V scroll raster			*
;*			; raster demo				*
;*			; Hoffset calculation			*	
;*	Date		: 1994.7.15				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
	INCPUB  raster
;---------------------------------------------------------------------
;
;
;
;

;*******************************************************************
;	
;*******************************************************************

Hraster_pointer	equ	kz_address	
Vraster_pointer	equ	kz_tempaddrl

;*******************************************************************
;	work
;*******************************************************************

;;		equ	Xaddr		; 4byte

Vzoomcenter		equ	Xwork0

scrollH		equ	Xwork0		; 2
loop_counter		equ	Xwork1		; 2
data_amp		equ	Xwork2		; 2
data_freq		equ	Xwork3		; 2
add_freq		equ	Xwork4		; 2
work_mult		equ	Xwork5		; 2
;;		---	Xwork6		; ( library )
;;		---	Xwork7		; ( library )
stock1		equ	Xwork8		;
horizon_work		equ	Xwork9		;
tempwork		equ	Xwork10		;

;-------------------------------------------------------------------
; 7f work memory
;-------------------------------------------------------------------

Vzoomtotal		equ	Voffset_total
Vzoomadd		equ	Voffset_add

;-------------------------------------------------------------------
; ROM table
;-------------------------------------------------------------------

RasterData		equ	ramsintab	; sintable

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
;*******************************************************************
;	raster only macros
;*******************************************************************

MVzoomadd	macro
	clc
	lda	Vzoomtotal+0	; DDA zoom
	adc	Vzoomadd+0
	sta	Vzoomtotal+0
	lda	Vzoomadd+2
	adc	Vzoomtotal+2
	sta	Vzoomtotal+2
	endm

;---------------------------------------------------------------------
Mraster_nastyoff	macro
	phb		;>
	a8
	lda	#7eh
	pha		; >
	plb		; <
	romnastyoff
	plb		;<
	a16
	endm

;---------------------------------------------------------------------
Mraster_nastyon	macro
	a8
	phb		;>
	lda	#7eh	
	pha		; >
	plb		; <
	nastyon
	a16
	plb		;<
	endm

;---------------------------------------------------------------------
;;
;;
;;
;;
;;
;;
;;
;*******************************************************************
;	input program
;*******************************************************************
	longi
        	shorta
;===================================================================
raster_l	Mbank7f
	storenasty		
	nastyon				; MARIO START
	ai16

	jsl	MessageTrigger_l
	jsr	raster_main

  	a8
  	restorenasty			; MARIO STOP	
	Mbankrtl

;===================================================================
;
;   
;
;
;
;-------------------------------------------------------------------
	longa

;********************************************************************
;			****************************************
; 1p-game raster		****************************************
;			****************************************
;********************************************************************

raster_main

	lda.l	raster_control
	and	#00ffh
	asl	a
	tax
	jmp	(.raster,x)

;-------------------------------------------------------------------
.raster	Mindexliststart
	Mindexlist	no_raster	;;
	Mindexlist	sea_raster	;;
	Mindexlist	test_raster	;;
	Mindexlist	boss_raster	;;
	Mindexlist	map1_bossVzoom	;;
	Mindexlist	explain_raster	;;
	Mindexlist	title_raster	;;
	Mindexlist	gameover_raster ;;
	Mindexlist	continue_raster ;;
	Mindexlist	reset_raster	;;
	Mindexlist	random_raster	;;
	Mindexlist	fire_raster	;;
	Mindexlist	yogan_raster	;;
	Mindexlist	sea_chikaraster	;;
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
;********************************************************************
;	reset_raster
;********************************************************************

reset_raster

	ldy	Hraster_pointer
	ldx	#displayline	; X = loop counter
	lda	#0
	jsr	LfillRAM

	ldy	Vraster_pointer
	ldx	#displayline
	lda	#0
	jmp	LfillRAM

;********************************************************************
;	title raster
;********************************************************************

title_raster
	rts
	

;********************************************************************
;	continue raster
;********************************************************************

continue_raster
	rts
	

;********************************************************************
;	gameover raster
;********************************************************************

gameover_raster
	rts
	

;********************************************************************
;	set
;********************************************************************


;---------------------------------------------
seademo_check
	lda.l	player1_horizon_wofs
	and	#00ffh
	bne	.demomode
;---------------------------------------------
	lda.l	player1_horizon
	bra	.set_work
;---------------------------------------------
.demomode	asl	a
	adc	#090h
.set_work	sta	horizon_work
	rts
;---------------------------------------------


;********************************************************************
;			****************************************
; test raster parameter	****************************************
;			****************************************
;********************************************************************

sos_raster
	jsr	set_rasterparam
	db	10h,0feh,0f0h
	jmp	sin_raster


;********************************************************************
;			****************************************
; explain mode raster	****************************************
;			****************************************
;********************************************************************

random_raster

;;; H scroll reset

	lda.l	kz_tempaddrl	; buffer address pointer
	tay
	lda	#0		; A = fill value
	ldx	#displayline	; X = loop counter
	jsr	LfillRAM


	lda	raster_noizestart
	beq	.exit
	asl	a
	adc.l	kz_tempaddrl	; buffer address pointer
	tay			; Y = buffer pointer

	ldx	#0
.loop	lda.l	.data,x
	sta.w	0,y
	iny
	iny
	inx
	inx
	cpx	#20
	bne	.loop

	
.exit	rts

;;;;	stz	scrollH
;;;;	lda	raster_noizesize
;;;;	sta	loop_counter
;;;;	jmp	many_rasterentry

.data	dw	0008h	;(0)
	dw	0010h	;(1)
	dw	0020h	;(2)
	dw	0010h	;(3)
	dw	0008h	;(4)
	dw	0	
	dw	0
	dw	0
	dw	0
	dw	0

;------------------------------------------------------------------

explain_raster

;-----------------------------------
; testmove
;-------------

;;	Mdebugkeymove	raster_amp+2,1,cont1,left,right,X
;;	Mdebugkeymove	raster_freq+2,1,cont1,up,down,X
;;	Mdebugkeymove	raster_speed+2,1,cont1,L,R,X

;=================================== 
; (V)raster
;-------------

	lda.l	kz_address
	tay			; Y = Vscroll raster pointer 
	lda	#0		; A = fill value
	ldx	#displayline	; X = loop counter
	jsr	LfillRAM

;=================================== 
; (H)raster
;-------------
	lda.l	kz_tempaddrl	; buffer address pointer
	tay
	ldx	#0		; 
	stz	scrollH
	lda	#displayline	; set linecounter
	sta	loop_counter
	jmp	many_rasterentry

;-----------------------------------


;********************************************************************
;			****************************************
; yogan stage raster		****************************************
;			****************************************
;********************************************************************

yogan_raster

; KeyMove------------------------------------

;;	Mdebugkeymove    raster_amp,1,cont1,up,down,X
;;	Mdebugkeymove	raster_freq,1,cont1,left,right,X
;;	Mdebugkeymove  raster_speed,1,cont1,A,B,X

;Scroll(H)-----------------------------------

	Mset	raster_amp,06h
	Mset	raster_freq,18h
	Mset	raster_speed,0ch

	jmp	sin_raster

;---------------------------------------------
;;	Mset	raster_amp,0feh
;;	Mset	raster_freq,0ffh
;;	Mset	raster_speed,1
;Scroll(V)-----------------------------------
;;	Mset	raster_amp+2,20
;;	Mset	raster_freq+2,4
;;	Mset	raster_speed+2,6
;--------------------------------------------
;;	jmp	HV_allraster

;===================================================================

;********************************************************************
;			****************************************
; ucyu stage raster		****************************************
;			****************************************
;********************************************************************

fire_raster
ucyu_raster	

;Scroll(H)-----------------------------------
	Mset	raster_amp,020h
	Mset	raster_freq,0feh
	Mset	raster_speed,-4
	jmp	sin_raster
;---------------------------------------------

;********************************************************************
;			****************************************
; chika stage raster		****************************************
;			****************************************
;********************************************************************


sea_chikaraster

;Scroll(H)-----------------------------------
	Mset	raster_amp,008h
	Mset	raster_freq,011h
	Mset	raster_speed,8
	jmp	sin_raster
;---------------------------------------------


;********************************************************************
;			****************************************
; fire stage raster		****************************************
;			****************************************
;********************************************************************

xxxx	jsr	set_rasterparam
	db	04h,0ffh,0e0h
	jmp	sin_raster

;********************************************************************
;			****************************************
; sea stage raster		****************************************
;			****************************************
;********************************************************************

rasterchange1 equ	100h
rasterchange2 equ	270h
displayline	 equ	192

;--------------------------------------------------------------------

Msearaster1	macro
	phy
	ldy	#0
	jsr	set_rasterparam_Y
	db	000h,000h,000h
	ply
	jsr	many_raster1
	endm

;---------------------------------------------------------------------

Msearaster2	macro
	phy
	ldy	#2
	jsr	set_rasterparam_Y
	db	0c8h,04ch,002h
	ply
	jsr	many_raster2
	endm

;---------------------------------------------------------------------

Msearaster3	macro
	phy
	ldy	#4
	jsr	set_rasterparam_Y
	db	008h,011h,008h		;;;;;;	db 0c8h,04ch,002h
	ply
	jsr	many_raster3
	endm

;---------------------------------------------------------------------
sea_raster

	ifeq	0

;=================================================
	jsr	seademo_check	; Vscroll check
	jsr	seaVzoom	; Vscroll
;=================================================


	lda.l	kz_tempaddrl	; buffer address pointer
	tay

	lda	#rasterchange1
	sec
	sbc	horizon_work	; = 90h
	beq	sea_entry
	bmi	sea_entry

;--------------------------------------------
; sky mode process
;--------------------------------------------
;
; A = display line count
;
;--------------------------------------------

sky_entry	

	cmp	#displayline
	bcc	.skip
	lda	#displayline
.skip	sta	loop_counter
	sta	stock1

	Msearaster1

	lda	#displayline
	sec
	sbc	stock1
	beq	sea_exit
	sta	loop_counter

	Msearaster2

	rts

;--------------------------------------------
; sea mode process
;--------------------------------------------

sea_entry	stz	stock1
	lda	horizon_work
	sec
	sbc	#rasterchange2
	bcs	.exit

	Mnegative

	cmp	#displayline
	beq	sea_exit
	bcc	.skip
	lda	#displayline

.skip	sta	loop_counter
	sta	stock1

	Msearaster2

.exit	lda	#displayline
	sec
	sbc	stock1
	beq	sea_exit
	bmi	sea_exit
	sta	loop_counter

	Msearaster3

;--------------------------------------------
sea_exit	rts
;--------------------------------------------


	endc

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
;===================================================================
;===================================================================
;===================================================================
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
;*********************************************************************
;		*************************************************
; SEA VzoomRaster	*************************************************
;		*************************************************
;*********************************************************************

seaVraster1		equ	090h	; line 1
seaVraster2		equ	150h	; line 2
seaVraster3		equ	210h	; line 3

seaVstopscroll	equ	270h	; scroll stop line

;--------------------------------------------------------------------
;;;;; displayline	equ	192

;--------------------------------------------------------------------

seaVzoom
	ldx	#displayline
	lda.l	kz_address
	tay				; Y = Vscroll raster pointer 
					;

;============================================================
; Voffset mode check
;============================================================
	lda.l	player1_horizon_wofs	; nomal mode
	beq	.sky_nomal		;
	cmp	#100h
	beq	.sea_nomal
;============================================================

	lda	horizon_work		; <<<< raster scroll >>>>

;------------------------------------------------
	cmp	#seaVraster1
 	bcc	.sky_nomal
;------------------------------------------------
	cmp	#seaVraster2	
	bcc	.demo1
;------------------------------------------------
	cmp	#seaVraster3
	bcc	.demo2
;------------------------------------------------
	jmp	.demo3

;---------------------------------------------------------------------
; (SKY) mode Voffset
;---------------------------------------------------------------------
.sky_nomal	lda	#90h
	ldx	#displayline	; X = loop counter
	jsr	LfillRAM
	jmp	voffsetON
;---------------------------------------------------------------------
; (SEA) mode Voffset
;---------------------------------------------------------------------
.sea_nomal				; Y = Vraster pointer
	lda.l	player1_horizon
	ldx	#displayline	; X = loop counter
	jsr	LfillRAM
	jmp	voffsetOFF
;---------------------------------------------------------------------






;---------------------------------------------------------------

.demo1	jsr	seaVdemo1
	jmp	voffsetOFF	; demo --> Voffset OFF

.demo2	jsr	seaVdemo2
	jmp	voffsetOFF	; demo --> Voffset OFF

.demo3	jsr	seaVdemo3
	jmp	voffsetOFF

;---------------------------------------------------------------------
;	Voffset flag draw
;---------------------------------------------------------------------

voffsetOFF	lda.l	voffsetflag
	ora	#voffsetflag_p1off
	sta.l	voffsetflag
	rts

voffsetON	lda.l	voffsetflag
	and	#voffsetflag_p1off^0ffffh	
	sta.l	voffsetflag
	rts

;---------------------------------------------------------------------
;	((((( sea -> sky scroll demo )))))
;---------------------------------------------------------------------

seaVdemo3

	lda	#210h
	sec	
	sbc	horizon_work
	clc
	adc	#060h
	tax
	sta	tempwork
	beq	.next
	bmi	.next2

	lda	#210h
	sec	
	sbc	horizon_work
	clc
	adc	horizon_work

	jsr	LfillRAM

.next	lda	#192		; display line
	sec
	sbc	tempwork
	beq	.exit	
	tax			; X = counter
	lda	#290h
	jsr	LfillRAM


	


.exit	rts

.next2	stz	tempwork
	bra	.next

;---------------------------------------------------------------------
;	((((( sea -> sky scroll demo )))))
;---------------------------------------------------------------------

seaVdemo2
	ldx	#060h		; <<<<< sky >>>>>
	lda	#seaVraster1
	jsr	LfillRAM
	ldx	#060h		; <<<<< sea >>>>>
	lda	#290h		; scroll stop
	jsr	nomalloop



	lda.l	kz_address
	clc
	adc	#5fh*2		;;;;
	tay

	lda	#seaVraster3
	stz	Vzoomtotal+0
	stz	Vzoomtotal+2
	sta	Vzoomtotal+1

;-------------------------------------

	lda	#seaVraster3	; 210h
	sec
	sbc	horizon_work	; 150h - 20fh
	and	#0fffeh	
	tax

	jsr	load_TAN

	Mnegative
	asl	a
	sta	Vzoomadd+0
	bpl	.ss1
	lda	#0ffffh
	bra	.sss
.ss1	lda	#0
.sss	sta	Vzoomadd+2


;-------------------------------------

	ldx	#60h		; move scroll counter

.loop2	lda	Vzoomtotal+1
	cmp	#1f0h
	bcc	.exit
	sta.w	0,y
	dey
	dey

	MVzoomadd

	dex
	bne	.loop2
	bra	.exit

;-------------------------------------
.over
.exit
	txa
	Mnegative
	clc
	adc	#60h+seaVraster1+10h
	sta	horizon_work
	rts

;---------------------------------------------------------------------
;	((((( sky -> sea scroll demo )))))
;---------------------------------------------------------------------

seaVdemo1

;---------------------------------------
; stop scroll

	ldx	#060h
	lda	#seaVraster1
	jsr	LfillRAM

	lda	#seaVraster1	; =90h
	stz	Vzoomtotal+0
	stz	Vzoomtotal+2
	sta	Vzoomtotal+1

;---------------------------------------

	lda	#seaVraster1	; 090h
	sec
	sbc	horizon_work	; 090h - 14fh
	Mnegative
	and	#0fffeh		; 000h - 0c0h
	tax
	
	jsr	load_TAN

	asl	a
	sta	Vzoomadd+0
	stz	Vzoomadd+2

	ldx	#60h		; move scroll counter

;-----------------------------------------------------

.loop2	lda	Vzoomtotal+1
	cmp	#120h
	bcs	.over
	sta.w	0,y
	iny
	iny

	MVzoomadd

	dex
	bne	.loop2
	bra	.exit

;-----------------------------------------------------
.over
	lda	#290h		; scroll 
	jsr	nomalloop

;-------------------------------------

.exit	lda	#seaVraster1+10h
	sta	horizon_work
	rts

;*********************************************************************
;	line scroll wo kotei no line ni suru
;*********************************************************************
;
; A = line stop scroll
; Y = pointer 
; X = counter
;
;---------------------------------------------------------------------
linestop
.loop	sta.w	0,y
	iny
	iny
	dec	a
	dex
	bne	.loop
	rts

;---------------------------------------------------------------------
nomalloop	sta.w	0,y
	iny
	iny
	dex
	bne	nomalloop
	rts
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
;*********************************************************************
;		*************************************************
; VzoomRaster	*************************************************
;		*************************************************
;*********************************************************************

map1_bossVzoom

	jsr	.entry
	jmp	no_raster

;======================================================================

.entry	stz	Vzoomtotal+0
	stz	Vzoomtotal+2
	lda.l	player1_horizon
	sta	Vzoomtotal+1

	ldx	#0
	lda	raster_Vadd
	Mnegative
	sta	Vzoomadd+0
	bpl	.skip
	dex
.skip	stx	Vzoomadd+2

;-------------------------------------------------------

	lda	raster_Vcenter	; Vzoom start scroll
	sec
	sbc.l	player1_horizon
	bmi	.exit		; error exit
	cmp	#190h
	bcs	.exit		; error exit

	sta	Vzoomcenter
	asl	a
	adc.l	kz_address
	tay			; Y = pointer address
	phy

	lda	#192
	sec
	sbc	Vzoomcenter
	tax			; X = total bytecount

	lda.l	player1_horizon
.loop	sta.w	0,y
	iny
	iny
	dex
	bne	.loop

;-------------------------------------------------------
	ply
	dey
	dey
	ldx	Vzoomcenter

.loop2
	lda	Vzoomtotal+1
	pha
	clc
	adc	Vzoomcenter
	bpl	.go
	pla
	lda	Vzoomcenter
	Mnegative
	bra	.go2
.go	pla
.go2	sta.w	0,y
	dey
	dey

	MVzoomadd

	dec	Vzoomcenter
	bne	.loop2

;-------------------------------------------------------

.exit	rts

;=====================================================================
;
;
;
;
;*********************************************************************
;		*************************************************
; raster parameter	*************************************************
;		*************************************************
;*********************************************************************

set_rasterparam
	ldy	#0
set_rasterparam_Y
	plx
	lda.w	1,x
	and	#00ffh
	sta	raster_amp,y
	lda.w	2,x
	and	#00ffh
	sta	raster_freq,y
	lda.w	3,x
	and	#00ffh
	sta	raster_speed,y
	inx
	inx
	inx
	phx
	rts	

;*********************************************************************
;		*************************************************
; NO raster		*************************************************
;		*************************************************
;*********************************************************************
no_raster

;----------------------------------------------------------------------
;;;;;	lda	#100h
;;;;;	sta.l	player1hscroll

	lda	#0
	sta	raster_counter
	sta	raster_freq
	sta	raster_amp
	sta	raster_speed
;----------------------------------------------------------------------
;
;
;
;
;
;
;
;----------------------------------------------------------------------
	lda.l	p1_camrotzbuf	; player 1 rolling parameter
	and	#0ff00h
	bne	VoffsetEntry
;----------------------------------------------------------------------
	ldx	#192
	lda.l	kz_tempaddrl	; buffer address pointer
	tay
	lda.l	player1hscroll	; H scroll 
.loop	sta.w	0,y
	iny
	iny
	dex
	bne	.loop
	rts
;---------------------------------------------------------------------
VoffsetEntry
	jsr	V_hosei
;- - - - - - - - - - - - - - - - - - - - -
	lda.l	player1hscroll
	sta	scrollH
;- - - - - - - - - - - - - - - - - - - - -

	lda.l	kz_tempaddrl	; buffer address pointer
	tay
	ldx	#192		; raster line

.loop	lda	scrollH		; Set H scroll
	clc
	adc	Voffset_total+1	;
	sta.w	0,y
	iny
	iny

	MVzoomadd

	dex
	bne	.loop

;- - - - - - - - - - - - - - - - - -
.exit	rts
;---------------------------------------------------------------------

	
;*********************************************************************
;		*************************************************
; Vsin wave raster	*************************************************
;		*************************************************
;*********************************************************************


boss_raster
test_raster

	ifeq	0
;==================================================================
; Calclation
;==================================================================

	Mraster_nastyoff
	jsl	calc_bossraster_l
	Mraster_nastyon


HV_allraster

	jsr	VoffsetOFF

;==================================================================
; Vscroll raster
;==================================================================

	Mset	loop_counter,192

	lda.l	kz_address	; Vraster buffer pointer
	tay
	ldx	#2		; data 2
	lda.l	player1_horizon
	and	#03ffh
	sta	scrollH
	jsr	many_rasterentry

;==================================================================
; Hscroll raster
;==================================================================

	Mset	loop_counter,192

	lda.l	kz_tempaddrl	; Vraster buffer pointer
	tay
	ldx	#0		; data 2
	lda.l	player1hscroll	; scroll V
	sta	scrollH
	jsr	many_rasterentry

;===================================================================

	rts


	endc


;*********************************************************************
;		*************************************************
; sin raster many	*************************************************
;		*************************************************
;*********************************************************************
;
; X = 0,2,4  raster parameter sample's 
; Y = 	buffer start address (H/V)
; scrollH .. offset scroll (H/V)
;
;----------------------------------------------------------------------

many_raster3	ldx	#4
	bra	many_raster
many_raster2	ldx	#2
	bra	many_raster
many_raster1	ldx	#0
;- - - - - - - - - - - - - - - - - -
many_raster	
	lda.l	player1hscroll
	sta	scrollH
many_rasterentry
	phx			; >>
	lda	raster_counter,x
	pha			;   >>
	asl	a
	sta	add_freq	; <----- SPEED
;- - - - - - - - - - - - - - - - - -
	lda	raster_freq,x
	and	#00ffh
	sta	data_freq	; <----- FREQ
	lda	raster_amp,x
	sta	data_amp	; <----- AMP
	plx			;   <<
;- - - - - - - - - - - - - - - - - -
	jsr	SetRasterdata2
;- - - - - - - - - - - - - - - - - -
	clc
	plx			; <<
	lda	raster_speed,x	; <----- SPEED
	adc	raster_counter,x
	and	#00ffh
	sta	raster_counter,x
;- - - - - - - - - - - - - - - - - -
	rts



;*********************************************************************
; 	speed up raster program
;*********************************************************************

SetRasterdata2
;-------------------------------------------
.loop
	a8
	lda.l	RasterData,x
	sta	work_mult+1
	bpl	.skip11
	Mnegative
.skip11	sta.l	XMultiplicand	; = 4202h
	lda	data_amp
	sta.l	XMultiplier	; = 4203h
	nop			; 	  2 cycle
	a16cC			; 	  3 cycle
	lda	#00ffh		; 	  3 cycle
	and.l	XProduct+1	; = 4217h
	bit	work_mult+0
	bpl	.skip12
	Mnegative
.skip12
	adc	scrollH	; Set H parameter
	sta.w	0,y
	iny
	iny

	lda	add_freq	; F parameter  add
	clc
	adc	data_freq
	and	#01ffh
	sta	add_freq
	lsr	a
	tax

	dec	loop_counter
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
;*********************************************************************
;		*************************************************
; sin wave raster	*************************************************
;		*************************************************
;*********************************************************************

sin_raster

	lda	raster_freq
	ora	raster_amp
	ora	raster_speed
	bne	.entry

	jmp	no_raster

;- - - - - - - - - - - - - - - - - - - - - -
.entry
	
;- - - - - - - - - - - - - - - - - - - - - -
	jsr	V_hosei
;- - - - - - - - - - - - - - - - - - - - - -


	lda	#192		; raster line counter
	sta	loop_counter

;- - - - - - - - - - - - - - - - - -
	ldx	raster_counter
	txa
	asl	a
	sta	add_freq
;- - - - - - - - - - - - - - - - - -
	lda	raster_freq
	and	#00ffh
	sta	data_freq	; <----- FREQ
	lda	raster_amp
	sta	data_amp	; <----- AMP
;- - - - - - - - - - - - - - - - - -
	lda.l	kz_tempaddrl	; buffer address pointer
	tay
	jsr	SetRasterdata
;- - - - - - - - - - - - - - - - - -
	clc
	lda	raster_speed	; <----- SPEED
	adc	raster_counter
	and	#00ffh
	sta	raster_counter
;- - - - - - - - - - - - - - - - - -
	rts

;*********************************************************************
;		 ************************************************
; sin raster mainloop ************************************************
;		 ************************************************
;*********************************************************************
;
; x ... NOW sintable index
;
;;
;; loop_counter	;
;;
;; add_freq		; sintable add
;; data_freq		; sintable pointer
;;
;;
;; scrollH		; now bg scroll
;; work_mult 	: 
;; Voffset_total	; ( V-offset )
;; Voffset_add	; ( V-offset )
;;
;;
;=====================================================================

SetRasterdata

	lda.l	player1hscroll
	sta	scrollH

;-------------------------------------------
.loop
	a8
	lda.l	RasterData,x
	sta	work_mult+1
	bpl	.skip11
	eor	#0ffh
	inc	a
.skip11	sta.l	4202h	
	lda	data_amp
	sta.l	4203h
	nop			; 2 cycle
	a16			; 3 cycle
	lda	#00ffh		; 3 cycle
	and.l	4217h
	bit	work_mult+0
	bpl	.skip12
	eor	#0ffffh
	inc	a
.skip12
	clc
	adc	scrollH	; Set H parameter
	clc
	adc	Voffset_total+1
	sta.w	0,y
	iny
	iny

	lda	add_freq	; F parameter  add
	clc
	adc	data_freq
	and	#01ffh
	sta	add_freq
	lsr	a
	tax

	MVzoomadd

	dec	loop_counter
	bne	.loop
	rts

;*********************************************************************
;		*************************************************
; mode2 Vbank hosei	*************************************************
;		*************************************************
;*********************************************************************


V_hosei
	ldy	#70h		; center of screen

;-----------------------------------------

	lda.l	p1_camrotzbuf	; player 1 rolling parameter
	cmp	#0
	bpl	.skip1
	cmp	#0f900h
	bcs	.skip2
	lda	#0f900h
	bra	.skip2
.skip1	cmp	#00700h
	bcc	.skip2
	lda	#00700h
.skip2
;-----------------------------------------
	ldx	#7
	cmp	#0
	Mdiv
;- - - - - - - - - - - - - - - - - - - - - -
	Masr1
	Masr1
	Masr1
	sta	Voffset_add+0
;- - - - - - - - - - - - - - - - - - - - - -

	jsl	MLS16S16

	sty	Voffset_total+0
	sta	Voffset_total+2

	ldx	#0
	lda	Voffset_add+0
	eor	#0ffffh
	inc	a
	sta	Voffset_add+0
	bpl	.skip
	dex
.skip	stx	Voffset_add+2

	rts

;=====================================================================
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
;=====================================================================
;=====================================================================
;============= Library Program =======================================
;============= Library Program =======================================
;=====================================================================
;=====================================================================

load_TAN	Mbank7e
	a8
	romnastyoff
	a16
	lda.l	keyscr_l,x	;;;;; TanData
	pha			; <<
	a8
	nastyon
	a16
	pla			; >>

	Mbankrts

;---------------------------------------------------------------------
call_fireraster
	Mraster_nastyoff
	jsl	calc_fireraster_l
	Mraster_nastyon
	rts

;---------------------------------------------------------------------

	


;---------------------------------------------------------------------
;
;
;
;
;
;
;
;*********************************************************************
;		*************************************************
; CLEAR RAM		*************************************************
;		*************************************************
;*********************************************************************
;
; A = clear data
; Y = clear RAM index
; X = counter
;
; DBR = clear RAM bank
;
;--------------------------------------------------------------------

LfillRAM	sta.w	0,y
	iny
	iny
	dex
	bne	LfillRAM
	rts

;*********************************************************************
;		*************************************************
; MULTIPLY		*************************************************
;		*************************************************
;*********************************************************************
;
; MULTIPLY signed 16bit * signed 16bit
;
; Usage: sBA*sYY=sBAYY ;mW:xW
;
;	jsl	ML_s16s16_l
;
;--------------------------------------------------------------------

product		equ	Xwork6	; library memory
multiplier		equ	Xwork7	; library memory

;--------------------------------------------------------------------
ML_s16s16_l
MLS16S16
	Mbank0
	PHX		
	JSR	Xml_s16s16
	PLX
	Mbankrtl

;- - - - - - - - - - - - - - - - - - - - - - - - - - -
Xml_s16s16	TYX			  	    	;W
	BPL	Multiply_s16u16
	TAY				;W
	BPL	s16s16_skip
	EOR	#0ffffh			;W
	INC	A			;W
	TAY				;W
	TXA				;W
	EOR	#0ffffh			;W
	INC	A			;W
	BRA	Multiply_s16u16
s16s16_skip	TXA				;W
	BRA	Multiply_s16u16	    	;mW:xW
;-----------------------------------------------------------------------
						;sBA*uYY=sBAYY
Multiply_s16u16 
	CMP	#8000h			;W
	BCC	Multiply_u16u16	
	EOR	#0ffffh			;W
	INC	A			;W
	JSR	Multiply_u16u16
	EOR	#0ffffh			;W
	TAX				;W
	TYA				;W
	EOR	#0ffffh			;W
	TAY				;W
	INY				;W
	BNE	s16u16_skip		;W
	INX				;W
s16u16_skip	TXA				;W
	RTS
;-----------------------------------------------------------------------
Multiply_u16u16_l
	Mbank0
	phx
	jsr	Multiply_u16u16
	plx
	Mbankrtl

Multiply_u16u16 
	STY	multiplier		;W
	SEP	#00110000B
	STA	XMultiplicand		;B
	STY	XMultiplier		;B
	REP	#00100001B
	XBA
	TAX				;B
	LDY	multiplier+1		;B
	LDA	XProduct		;W
	STY	XMultiplier		;B
	STA	product			;W
	XBA
	AND	#00ffh			;W
	ADC	XProduct		;W
	LDY	multiplier+0		;B
	STX	XMultiplicand		;B
	STY	XMultiplier		;B
	NOP
	LDY	multiplier+1		;B
	ADC	XProduct		;W
	STY	XMultiplier		;B
	STA	product+1		;W
	AND	#0ff00h			;W
	ADC	#0			;W
	XBA
	REP	#00010001B
	LDY	product			;W
	ADC	XProduct		;W
	RTS				;mW:xW

;====================================================================
;====================================================================
; END END END END END END END END END END END END END END END END 
;====================================================================
;====================================================================

