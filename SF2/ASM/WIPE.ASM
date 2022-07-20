;;;
;;;
;=====================================================================
waittime_endingwipe	equ 80
;=====================================================================
;;;
;;;
beamtest	= 0	; OFF beamtest 
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: wipe.asm				*
;* 	Description	: Window Wipe SEQ			*
;*	Date		: 1994.10.3				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
	INCPUB  wipe
;---------------------------------------------------------------------
;
;
;
;
;
;
;
;*********************************************************************
;	wipebuffer alias
;*********************************************************************

wipe_bufferA1S	equ	wipe_bufferA1+96*4
wipe_bufferB1S	equ	wipe_bufferB1+96*4

;*********************************************************************
;	wipewindow labels
;*********************************************************************

wipe_center		equ	96		; 1p game screen
wipe_half		equ	96
wipe_full		equ	96*2

Xwipe_center		equ	112		; battle screen
Xwipe_half		equ	112    
Xwipe_full		equ	112*2

Fwipe_center		equ	112		; full screen
Fwipe_half		equ	112
Fwipe_full		equ	112*2

FullOpenData		equ	0ff00h	; Window Full Open
FullCloseData	equ	07f80h	; Window Full Close

;--------------------------------------------------------------------
; line counter
;--------------------------------------------------------------------

gamewipe_fullsize	equ	wipe_full
gamewipe_halfsize	equ	wipe_half
gamewipe_center	equ	wipe_half

mapwipe_fullsize	equ	Xwipe_full
mapwipe_halfsize	equ	Xwipe_half
mapwipe_center	equ	Xwipe_half

;--------------------------------------------------------------------
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
;	Wipe Local Macros
;*********************************************************************
;--------------------------------------------------------------------
wipeentryEX	macro	[wipelabel,wipetime]
	jsr	wipeentrysetEX
	db	idx_{wipelabel}
	db	{wipetime}
	endm

;--------------------------------------------------------------------
wipeentry	macro	[wipelabel,wipetime]
	jsr	wipeentryset
	db	idx_{wipelabel}
	db	{wipetime}
	endm

;--------------------------------------------------------------------
wipeentryL	macro	[wipelabel,wipetime]
	jsr	wipeentryset_longtime
	db	idx_{wipelabel}
	dw	{wipetime}
	endm

;--------------------------------------------------------------------
Mwipeclip	macro
	bit	#0ff00h	;
	beq	.set\@	;
	bpl	.skip\@	;
	lda	#00000h	;
	bra	.set\@	;
.skip\@	lda	#000ffh	;
.set\@
	endm

;--------------------------------------------------------------------
Mwipelimitcheck macro
	beq	.over\@
	cmp	#0ffffh
	bne	.set\@
.over\@	lda	#0feffh	; clear
.set\@
	endm

;--------------------------------------------------------------------




;*********************************************************************
;	Wipe Memory (RAM)
;*********************************************************************
;
; wipe_work 20byte ( 7ebank ram )
;
;---------------------------------------------------------------------

wipe_frame		equ	wipe_work+0

;---------------------- sos wipe ---------------------------

wipe1_L		equ	wipe_work+2
wipe1_R		equ	wipe_work+4
wipe1_LR		equ	wipe_work+6

;---------------------- rolling window ---------------------

wipe_longdata	equ	wipe_work+8	; 4
wipe_longadd		equ	wipe_work+12	; 4byte!!
wipe_addadd		equ	wipe_work+16	; 4

;-----------------------------------------------------------

;*********************************************************************
;	ZERO PAGE WORK
;*********************************************************************


temp_1L 	equ	Xwork0
temp_1R 	equ	Xwork1
temp_2L 	equ	Xwork2
temp_2R 	equ	Xwork3
temp_XX 	equ	Xwork4

Xadd	equ	Xwork8
Xcounter	equ	Xwork9
Xtemp	equ	Xwork10

;---------------------------- ; rolling animation -------

work1	equ	Xwork1
work2	equ	Xwork2
line_counter	equ	Xwork3
Ndata	equ	Xwork4
add_add	equ	Xwork5

;---------------------------------------------------------

product	equ	Xwork6	; library memory
multiplier	equ	Xwork7	; library memory

;---------------------------------------------------------
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
;*		***********************************************
;*		***********************************************
;*  PROGRAM ENTRY    ***********************************************
;*		***********************************************
;*		***********************************************
;*******************************************************************

	shorta
	longi
;===================================================================


;*******************************************************************
;	wipe initialize 
;*******************************************************************

wipeinit_l
	php

	ai16
	ldx	#wipestruct
	stz	_dcinput,x	; process reset

	plp
	rtl

;*******************************************************************
;	wipe main
;*******************************************************************

test_l
wipe_l
	Mbank7e
	php
	ai16

	Mdebugstart

	jsr	SetWipe
	inc	wipe_frame	; wipe frame counter

	Mdebugend

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
;
;
;---------------------------------------------------------------------
	longa
	longi
;=====================================================================
;=====================================================================
;===========	WIPE MAIN PROGRAM =======================================
;===========	WIPE MAIN PROGRAM =======================================
;=====================================================================
;=====================================================================
;********************************************************************
;
;	Wipe kawaguchi kun kara call sareru !
;
;********************************************************************

;--------------------------------------------- 
nowipeopen_l		wipeentry wipe_exit,10
nowipeclose_l	wipeentry wipe_exit,1
;--------------------------------------------- 
titleopen_l		wipeentry wipetitle_open,10
titleclose_l		wipeentry wipetitle_close,8
;--------------------------------------------- 
misplopen_l		wipeentry  wipepsel_open,10
misplclose_l		wipeentryL wipepsel_close,255+60+32+50
;--------------------------------------------- 
mismapopen_l		wipeentry wipestar_open,2
mismapclose_l	wipeentry wipestar_close,60	;;; 120
;--------------------------------------------- 
misexpopen_l		wipeentry wipe_exp,20
misexpclose_l	wipeentry wipe_exit,20
;--------------------------------------------- 
missionopen_l	wipeentryEX wipegame_open,30
missionclose_l	wipeentry   wipeover_close,40
;--------------------------------------------- 
pauseopen_l		wipeentry wipepause_open,30
pauseclose_l		wipeentry wipepause_close,5
;--------------------------------------------- 
endingopen_l	  	wipeentry wipeending_open,30

;--------------------------------------------- 
;	not use
;--------------------------------------------- 
batplopen_l		
batplclose_l		
batflopen_l		
batflclose_l
battleopen_l	
battleclose_l	
endingclose_l  
		rtl

;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;
;
;
;
;********************************************************************
;
;	Wipe Main
;
;********************************************************************
;--------------------------------------------------------------------

wipe_exit	rts

;--------------------------------------------------------------------

SetWipe 	lda	#wipestruct
	sta	dcregister
	jsr	dc_select

; -------------------------------------------------------------------
	Mindexliststart			;
	Mindexlist	wipe_exit	;(0) exit

; config wipe -------------------------------------------------------
	Mindexlist	wipeconf_open	; mannaka open
	Mindexlist	wipeconf_close	;  
; gamewipe ----------------------------------------------------------
	Mindexlist	wipegame_open	; hishi wipe
	Mindexlist	wipegame_close	; 
; pause wipe --------------------------------------------------------
	Mindexlist	wipepause_open	; pause wipe
	Mindexlist	wipepause_close	;  
; pselect wipe ------------------------------------------------------
	Mindexlist	wipepsel_open	; yoko shimari
	Mindexlist	wipepsel_close	; 
; map wipe ----------------------------------------------------------	
	Mindexlist	wipemap_open	; rolling open
	Mindexlist	wipemap_close	; 	
; title wipe --------------------------------------------------------
	Mindexlist	wipetitle_open	; title wipe
	Mindexlist	wipetitle_close	;
; battle playerselect config ----------------------------------------
	Mindexlist	wipeconfig	; battle player select
	Mindexlist	wipe_exp
; star wipe ---------------------------------------------------------
	Mindexlist	wipestar_open	; map star open
            	Mindexlist	wipestar_close	; map star close

; gameover ----------------------------------------------------------
	Mindexlist	wipeover_close	; gameover star close

; ending wipe -------------------------------------------------------
	Mindexlist	wipeending_open

;--------------------------------------------------------------------
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
;=====================================================================
;=====================================================================
;===========	WIPE I/O ================================================
;===========	WIPE I/O ================================================
;=====================================================================
;=====================================================================
;*******************************************************************
;	wipe call 
;*******************************************************************
;;
;; sample :	gameinit
;;	jsl	wipeinit_l
;;	jsl	titleopen_l
;;	sta	wipe_timer	; <- timer
;;
;;	gamemain
;;	jsl	wipe_l
;;	bra	gamemain
;;
;-------------------------------------------------------------------


wipeentrysetEX
	a16
	km_setgameflag	pausedisable	; pause disable
	Moff_objmeter		; meter OFF
	bra	commonEX
;------------------------------------------------------------
wipeentryset	a16
	Mon_objmeter		; meter ON
;------------------------------------------------------------
commonEX	a8
	plx			; 
	phb
	phk
	plb
	ldy	#wipestruct
	lda.w	1,x		; wipe patern select
	sta.w	_dcinput+0,y
	lda	#0
	sta.w	_dcinput+1,y
	lda	#0
	xba
	lda.w	2,x		; timer data
	plb
	rtl
	longa

;--------------------------------------------------------------------

wipeentryset_longtime
	a16
	Mon_objmeter
	a8
	plx			; <<
	phb
	phk
	plb
	ldy	#wipestruct
	lda.w	1,x		; wipe patern select
	sta.w	_dcinput+0,y
	lda	#0
	sta.w	_dcinput+1,y
	lda.w	3,x		; ( Timer High )
	xba
	lda.w	2,x		; ( Timer Low  )
	plb
	rtl
	longa

;--------------------------------------------------------------------
;
;*******************************************************************
; 	PPU-Register parameter buffer set
;*******************************************************************
;
; used Xwork1,Xwork2,Xwork3
;
;-------------------------------------------------------------------

set_param
	ply
	sty	Xwork1
	phb
	phk
	plb

	a8
;-------------------------------------------
;  1player Window/ColorADD
;-------------------------------------------

	alloc_window wipe,1
	MsetAX3 wm_hdma,wipe_bufferA1

	ldy	Xwork1
	jsr	setwipereg

;-------------------------------------------
;  2player Window/ColorADD
;-------------------------------------------

	alloc_window wipe,2
	MsetAX3 wm_hdma,wipe_bufferA2

	ldy	Xwork1
	jsr	setwipereg

;-------------------------------------------
	plb

	a16cC
	tya
	adc	#9
	pha
	
	rts

;-------------------------------------------------------------------
;-------------------------------------------------------------------

	shorta

setwipereg
	lda.w	1,y
	sta	wm_w12sel,x	; = 2123h
	lda.w	2,y
	sta	wm_w34sel,x	; = 2124h

	lda.w	3,y
	sta	wm_wobjsel,x    ; = 2125h
	lda.w	4,y
	sta	wm_wbglog,x	; = 212ah
	lda.w	5,y
	sta	wm_wobjlog,x    ; = 212bh
	lda.w	6,y
	sta	wm_ts,x		; = 212dh
	lda.w	7,y
	sta	wm_cgswsel,x	; = 2130h
	lda.w	8,y
	sta	wm_cgadsub,x	; = 2131h
	lda.w	9,y
	sta	wm_coldata,x	; = 2132h

	lda	#wf_windowon
	sta	wm_flags,x	; flag
	lda	#44h
	sta	wm_chparams,x	; = 4300h

	rts

;-------------------------------------------------------------------
	longi
	longa
;-------------------------------------------------------------------
;*********************************************************************
;	 swap buffer
;*********************************************************************
;
; window draw buffer swap
;
;	wipeframe 0.1.3.... (A)buffer draw
;	wipeframe 2.4.6.... (B)buffer draw
;
;---------------------------------------------------------------------

swap_buffer
	Mbankprog
;-------------------------------------------
	lda.l	wipe_frame
	lsr	a
	bcs	.Bwrite
;-------------------------------------------
.Awrite	ldy	#winaddr_AS&0ffffh
	jsr	setdmaaddr
	bra	swap_exit
;------------------------------------------
.Bwrite	ldy	#winaddr_BS&0ffffh
	jsr	setdmaaddr
	bra	swap_exit
;------------------------------------------
swap_bufferFULL
	Mbankprog
;-------------------------------------------
	lda.l	wipe_frame
	lsr	a
	bcs	.Bwrite
;-------------------------------------------
.Awrite	ldy	#winaddr_A&0ffffh
	jsr	setdmaaddr
	bra	swap_exit
.Bwrite 	ldy	#winaddr_B&0ffffh
	jsr	setdmaaddr
;------------------------------------------
swap_exit	sta	Xaddr+0
	lda	#7eh
	sta	Xaddr+2
	Mbankrts
;---------------------------------------------------------------------
winaddr_A	dl	wipe_bufferA1
	dl	wipe_bufferA2
winaddr_B	dl	wipe_bufferB1
	dl	wipe_bufferB2
winaddr_AS	dl	wipe_bufferA1
	dl	wipe_bufferA1S
winaddr_BS	dl	wipe_bufferB1
	dl	wipe_bufferB1S
;---------------------------------------------------------------------
setdmaaddr	phy
	alloc_window wipe,1	; <--- (rom)memory used !!!!
	ply
	lda.w	0,y
	sta	wm_hdma+0,x
	lda.w	1,y
	sta	wm_hdma+1,x

	phy
	alloc_window wipe,2	; <--- (rom)memory used !!!!
	ply
	lda.w	3,y
	sta	wm_hdma+0,x
	lda.w	4,y
	sta	wm_hdma+1,x
	lda.w	0,y
	rts

;---------------------------------------------------------------------
;*******************************************************************
;	wipe library
;*******************************************************************
;-------------------------------------------------------------------
; wipe exit
;-------------------------------------------------------------------

endofwipe	tyx
	stz	_dcprocess,x
	stz	_dcselect,x
	stz	_dcinput,x
	rts

;-------------------------------------------------------------------
; window process exit
;-------------------------------------------------------------------

offswitch	a8
	dealloc_window  wipe,1
	dealloc_window  wipe,2
	a16
	km_clrgameflag pausedisable	; pause enable
	rts

;-------------------------------------------------------------------
; wipe buffer clear
;-------------------------------------------------------------------
;
;	Yreg = ClearData window(2)
;	Areg = ClearData window(1)	
;
;	A/B buffer allclear ( initial only )
;	full-line clear
;
;-------------------------------------------------------------------

wipe_clearX
	sta	Xaddr+0
	sta	Xaddr+2
	txy		  ; x = counter
	bra	wc_common

clear_fullclose
	lda	#FullCloseData
	bra	wipe_clear	
clear_fullopen
	lda	#FullOpenData
;-------------------------------------------------------------------
wipe_clear	tay
wipe_clear2
	sta	Xaddr+0
	sty	Xaddr+2
	ldy	#Fwipe_full		    ; line count
wc_common
	ldx	#wipe_bufferA1&0ffffh

.loop	lda	Xaddr+0
	sta.w	0,x
	sta.w	Fwipe_full*4,x
	lda	Xaddr+2
	sta.w	2,x
	sta.w	Fwipe_full*4+2,x
	inx
	inx
	inx
	inx
	dey
	bne	.loop
	rts

;-------------------------------------------------------------------
;
; y = rasterline pointer
; x = set counter
; a = clear_data
;
;---------------------------------------------------- 
; 1 window only
;----------------------------------------------------

wipe_bufferset
.loop	sta	(Xaddr),y	; window 1
	iny
	iny
	iny
	iny
	dex			; 
	bne	.loop
	rts

;----------------------------------------------------
; 1/2 window
;----------------------------------------------------

wipe_bufferset12
.loop	sta	(Xaddr),y	; window 1
	iny
	iny
	sta	(Xaddr),y	; window 2
	iny
	iny
	dex			; 
	bne	.loop
	rts

;-------------------------------------------------------------------
;
;
;
;
;
;
;
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;********************************************************************
;	ending wipe open !!!
;********************************************************************
wipeending_close
wipeending_open

	jsr	dc_program
	dwnext	clear_fullopen
	dwnext	wipeending_init
	dwstop	ending_loop

;------------------------------------------------------------------------
wipeending_init
	jsr	set_param
	db	003h,033h,003h	; window switch
	db	00h,00h		; window logic
	db	00h		; 212dh
	db	00h,00h,000h	; 2130,31,32
	rts

;------------------------------------------------------------------------
;;; intro.asm
;------------------------------------------------------------------------
ending_loop
	jsr	swap_buffer

	ldx	#techdata_Pos2-15	; line
	ldy	#0
	lda	#00001h
	jsr	wipe_bufferset

	rts

;------------------------------------------------------------------------




;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;=====================================================================
;=====================================================================
;===========	WIPE CACE SWITCH ========================================
;===========	WIPE CASE SWITCH ========================================
;=====================================================================
;=====================================================================
;********************************************************************
;	wipe program/data include
;********************************************************************

	incfile ASM\wipepaus.asm	; wipe pause 
	incfile ASM\wipedoor.asm	; <<<<< door wipe data >>>>>
	incfile ASM\wipeconf.asm	; config
	incfile	ASM\wipegame.asm	; 1p game main
	incfile ASM\wipepsel.asm	; 1p player select
	incfile ASM\wipebsel.asm	; <<< battle player select >>>
	incfile ASM\wipebatt.asm	; battle game main
	incfile	ASM\wipeclea.asm	; 1p gameclear wipe
	incfile	ASM\wipeexp.asm	; moission explain wipe
	incfile ASM\wipemap.asm	; 1p map select
	incfile	ASM\wipebeam.asm	; test wipe
	incfile	ASM\wipetitl.asm	; title wipe
	incfile ASM\wipeover.asm	; gameover wipe
	
;===================================================================
;===================================================================
;;; END END END END END END END END END END END END END END END ;;;;
;===================================================================
;===================================================================
