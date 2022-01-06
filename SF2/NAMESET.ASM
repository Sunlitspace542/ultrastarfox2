	ifne	debuginfo
AFscoredebug	= 0
	elseif
AFscoredebug	= 0
	endc
;---------------------------------------------------------------------
;;;;;
;;;;;
;;;;;
;;;;;
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: nameset.asm				*
;* 	Description	: nameset				*
;*	Date		: 1994.5.1				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************

;---------------------------------------------------------------------
	INCPUB nameset
;---------------------------------------------------------------------

;*********************************************************************
;	BACKUP Parameter's
;*********************************************************************

initABCrank	equ	5	; 5 de naito dame !!
	
;*********************************************************************
;	Parameter's
;*********************************************************************

use_backupscore	equ	1	; backup use code 1/0 ON/OFF
coinposX		equ	0b8h	; cointotal OBJ positon X
coinposY		equ	015h	; cointotal OBJ position Y

barpositionY		equ	3fh	; bestscore BAR setposition(Y)

dan0_Xcount		equ	10	; nameinput Xkey count
dan1_Xcount		equ	10
dan2_Xcount		equ	10

;---------------------------------------------------------------------
Mcursor_okset macro
	lda	#10		;;;; next cursor position
	sta	nameset_keyX
	lda	#2
	sta	nameset_keyY
	endm

;---------------------------------------------------------------------
;
;
;
;
;
;
;
;*********************************************************************
;	SEQ work's
;*********************************************************************
bestscore_struct	equ	bgdemo_switch


nameset_keyX		equ  bestscore_struct+_dcwork+0
nameset_keyY		equ  bestscore_struct+_dcwork+2
repeat_trig		equ  bestscore_struct+_dcwork+4
repeat_timer		equ  bestscore_struct+_dcwork+6

hiscore_number_cursor equ  gameobjstruct+0
nameset_cursor	equ  gameobjstruct+2

hiscore_keypointer	equ  gameobjstruct+4
hiscore_barpointer	equ  gameobjstruct+6
hiscore_yesnopointer	equ  gameobjstruct+8

hiscore_endflag	equ  gameobjstruct+10

;*********************************************************************
;
;	Local Macros
;
;*********************************************************************
bestscore_messagebuffer	equ textdraw


;=====================================================================
MsetMB	macro
	sta.l	bestscore_messagebuffer,x
	inx
	endm

;=====================================================================
MsetMB_attr	macro	[attr]
	lda	#idx_bs_data_eorattr{attr}
	MsetMB
	endm

;=====================================================================
MsetMB_attrclear macro
	lda	#idx_bs_data_clearattr
	MsetMB
	endm

;=====================================================================
MsetMB_skip1	macro
	lda	#idx_bs_data_skip1
	MsetMB
	endm

;=====================================================================
MsetMB_skip2	macro
	lda	#idx_bs_data_skip2
	MsetMB
	endm

;=====================================================================
MsetMB_dataend macro
	lda	#0ffh		; End !!
	MsetMB
	endm

;=====================================================================
MtestMB_index  macro
	lda	#0
	xba
	lda	yj_framecounter
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	and	#07h
	tay
	endm

;=====================================================================
MtestMB_alpha macro
	lda	yj_framecounter
	lsr	a
	lsr	a
	lsr	a
	endm

;=====================================================================
MreadRAM	macro	[offset]
	phx				; >>
	lda	#0
	xba
	ldx	bs_rampointer
	lda.l	{offset},x
	tay
	plx				; <<
	endm

;=====================================================================
Mset_screenbuffer	macro	[pos]
	ldy	#{pos}
	ldx	bs_datapointer		; 7fRAM buffer pointer
	jsr	BS_BGset
	endm

;=====================================================================
Mset_bsbuffer	macro	[offset]
	ldy	#{offset}
	jsr	Set_BESTscorelist
	endm

;*********************************************************************
;
;	Cassette Rest BestScore Data
;
;*********************************************************************
__a equ 0ah
__b equ 0bh
__c equ 0ch
__d equ 0dh
__e equ 0eh
__f equ 0fh
__g equ 10h
__h equ 11h
__i equ 12h
__j equ 13h
__k equ 14h
__l equ 15h
__m equ 16h
__n equ 17h
__o equ 18h
__p equ 19h
__q equ 1ah
__r equ 1bh
__s equ 1ch
__t equ 1dh
__u equ 1eh
__v equ 1fh
__w equ 20h
__x equ 21h
__y equ 22h
__z equ 23h
__dot equ	24h

__fox	equ	0
__falco	equ	1
__peppy	equ	2
__slippy	equ	3
__miyu	equ	4
__fay	equ	5
__pepper	equ	6
__clear	equ	7


;; name	



ClearBackupData

;-----------------------------------------------------------------
	dw	0000h+backupflag_cameramode	; backup flags
;-----------------------------------------------------------------
	dw	00000h				; total coin 0
	dw	00000h				; total coin 2
	dw	00000h				; total coin 4
	dw	00000h				; total coin 6
;-----------------------------------------------------------------
	db	0	; coincount easy
	db	0	; coincount normal
	db	0	; coincount hard
	db	0
;-----------------------------------------------------------------
	dw	0000h				; random backup
;-----------------------------------------------------------------
	db	0			;1byte (code)
	db	1			;1byte (rank)
	db	__dot,__dot,__dot	;3byte (name)
	db	__clear,__clear		;2byte (pilot)
;;;;;;	db	__fox,__falco		;2byte (pilot)
	dl	0			;3byte (total score)
	dw	0000			;2byte (clear time)
	db	initABCrank		;1byte (ABC rank)	
	db	0,0,0			;1(percent)
					;1(planets)
					;1(battleships)
	db	0			;K difficult
	db	0			;  ! result
	dw	0			;2 ecount missile
	dw	0			;2 ecount fighter
	dl	0			;3byte  basic score
	dw	0			;2byte  result flag
;-----------------------------------------------------------------
	db	0			;1byte (code)
	db	2			;(rank)
	db	__dot,__dot,__dot	;3byte (name)
	db	__clear,__clear		;2byte (pilot)
;;;;;;	db	__peppy,__slippy	;2byte (pilot)
	dl	0			;(total score)
	dw	0000			;(clear time)
	db	initABCrank		;(ABC rank)	
	db	0,0,0
	db	0			;K difficult
	db	0			;  ! result
	dw	0			;2 ecount missile
	dw	0			;2 ecount fighter
	dl	0			;3byte  basic score
	dw	0			;1byte  result flag
;-----------------------------------------------------------------
	db	0			;1byte (code)
	db	3			;(rank)
	db	__dot,__dot,__dot	;3byte (name)
	db	__clear,__clear		;2byte (pilot)
;;;;;;;	db	__miyu,__fay		;2byte (pilot)
	dl	0			;(total score)
	dw	0000			;(clear time)
	db	initABCrank		;(ABC rank)	
	db	0,0,0
	db	0			;K difficult
	db	0			;  ! result
	dw	0			;2 ecount missile
	dw	0			;2 ecount fighter
	dl	0			;3byte  basic score
	dw	0			;1byte  result flag
;-----------------------------------------------------------------
	db	0			;1byte (code)
	db	4			;(rank)
	db	__dot,__dot,__dot	;3byte (name)
	db	__clear,__clear		;2byte (pilot)
	dl	0			;(total score)
	dw	0000			;(clear time)
	db	initABCrank		;(ABC rank)	
	db	0,0,0
	db	0			;K difficult
	db	0			;  ! result
	dw	0			;2 ecount missile
	dw	0			;2 ecount fighter
	dl	0			;3byte  basic score
	dw	0			;1byte  result flag
;-----------------------------------------------------------------
	db	0			;1byte (code)
	db	5			;(rank)
	db	__dot,__dot,__dot	;3byte (name)
	db	__clear,__clear		;2byte (pilot)
	dl	0			;(total score)
	dw	0000			;(clear time)
	db	initABCrank		;(ABC rank)	
	db	0,0,0
	db	0			;K difficult
	db	0			;  ! result
	dw	0			;2 ecount missile
	dw	0			;2 ecount fighter
	dl	0			;3byte  basic score
	dw	0			;1byte  result flag
;-----------------------------------------------------------------

;*********************************************************************
;	-----------------------------
;	 Highscore ScreenMakeProgram
;	-----------------------------
;*********************************************************************

Drawbuffer_bestscore


	ldx	#0				
	Mset_bsbuffer	hs_sizeof*0
	Mset_bsbuffer	hs_sizeof*1
	Mset_bsbuffer	hs_sizeof*2
	Mset_bsbuffer	hs_sizeof*3
	Mset_bsbuffer	hs_sizeof*4

	stz	bs_datapointer	
	Mset_screenbuffer	1c4h+000h
	Mset_screenbuffer	1c4h+080h
	Mset_screenbuffer	1c4h+100h
	Mset_screenbuffer	1c4h+180h
	Mset_screenbuffer	1c4h+200h

	rts


;*********************************************************************
;	Init nameset Program
;*********************************************************************
Init_nameset_l
	Mbankprog
	php
	ai16

;---------------------------------------------------------------------
;;; debug initial
;---------------------------------------------------------------------
	jsl	Check_backupRAM_l   	;; backup ram initialize
;---------------------------------------------------------------------
	jsl	Write_backupRAM_hiscore_l ;; set hiscore number
;---------------------------------------------------------------------
	jsr	Drawbuffer_bestscore	;; display scores  !!
;---------------------------------------------------------------------
	jsl	Read_backupRAM_coindata_l
;---------------------------------------------------------------------
	
	lda	#0ffffh
	sta.l	check_bestscore_mode

	lda	#idx_bestscore_open
	sta	bestscore_struct
	stz	nameset_keyX
	stz	nameset_keyY
	stz	repeat_trig
	stz	repeat_timer	
	stz	nameset_cursor
	stz	hiscore_endflag

;---------------------------------------------------------------------
	plp
	Mbankrtl

;*********************************************************************
;	NMI nameset Program
;*********************************************************************

NMI_nameset_l

	rtl


;*********************************************************************
;	Main nameset Program
;*********************************************************************
Main_nameset_l

	Mbankprog
	php		; >>
	ai16

	stz	sprite_register

;;;;	a8
;;;;	lda	#08h
;;;	sta	2100h
;;;	a16

	jsr	call_repeat_trigger	
	jsr	bestscore_entry



;;;;	a8
;;;;	lda	#0fh
;;;	sta	2100h
;;;	a16

	lda	hiscore_endflag
	plp		; <<
	Mbankrtl



;*********************************************************************
;	-----------
; 	 SEQ main
;	-----------
;*********************************************************************

bestscore_entry

	ldx	#bestscore_struct
	stx	dcregister
	jsr	dc_select
	Mindexliststart
	Mindexlist	bestscore_nothing	;(0)
	Mindexlist	bestscore_open		;(1)
	Mindexlist	bestscore_keyselect	;(2) <<< select >>>
	Mindexlist	bestscore_keydemo	;(3)
	Mindexlist	bestscore_keyOKselect	;(4)
	Mindexlist	bestscore_keyOKend	;(5)

bestscore_nothing
	rts

;*********************************************************************
;	-----------
; 	 SEQ main
;	-----------
;*********************************************************************

;=====================================================================
bestscore_open
	jsr	dc_program
	dwnext	.init
	dwflag	.main
	dwstop	.exit
;------------------------------------------------------------
.init
	jsr	Init_objlist
	Mobjinit 0,ys_bs_cursoropen,bs_strat_cursor,80h,80h
	Mobjinit 1,ys_bs_scorebar,bs_strat_bar,80h,0
	Mobjinit 2,ys_bs_message1,bs_strat_message,050h,0cch
	Mobjinit 3,ys_bs_namecursor,bs_strat_namecursor,0,0
	Mobjinit 5,ys_bs_coindisp,bs_strat_coindisp,coinposX,coinposY
	jmp	Main_OBJ
;------------------------------------------------------------
.exit	Mset	bestscore_struct,idx_bestscore_keyselect
;------------------------------------------------------------
.main	jmp	Main_OBJ
;------------------------------------------------------------
	



;=====================================================================
;	BESTSCORE KEYSELECT
;=====================================================================
bestscore_keyselect
	jsr	dc_program
	dwnext	.init
	dwstop	.main

;------------------------------------------------------------
.init	Mobjchange 0,ys_bs_cursor,bs_strat_cursor
	jmp	Main_OBJ

;------------------------------------------------------------
.main
	jsr	bs_keyselect


	lda	trig0
	and	#button_B
	beq	.exit
	Mset	bestscore_struct,idx_bestscore_keydemo
.exit	jmp	Main_OBJ
;------------------------------------------------------------


;=====================================================================
;	BESTSCORE KEY DEMO
;=====================================================================

;------------------------------------------------------------
bestscore_keydemo
	jsr	dc_program
	dwnext	.init
	dwloop	10,.main
	dwnext	.sound
	dwflag	.main
	dwstop	.exit

;------------------------------------------------------------
.init
	ksound	longlaser1
	jsr	bs_nameinput
	lda	nameset_cursor
	cmp	#3
	beq	.okselect
	bcs	.okend
.init_exit	Mobjchange 0,ys_bs_fire,bs_strat_cursor
	jmp	Main_OBJ

.okselect	Mset	bestscore_struct,idx_bestscore_keyOKselect
	jmp	Main_OBJ

.okend	Mset	bestscore_struct,idx_bestscore_keyOKend
	jmp	Main_OBJ

;------------------------------------------------------------
.sound	ksound	en_explode_s
.main	
	jmp	Main_OBJ
	
;------------------------------------------------------------
.exit	Mset	bestscore_struct,idx_bestscore_keyselect
	jmp	Main_OBJ

;------------------------------------------------------------
;
;
;
;
;
;
;=====================================================================
; 	BESTSCORE KEY OK
;=====================================================================
bestscore_keyOKselect
	jsr	dc_program
	dwnext	.init
	dwloop	10,.main1	;;;; OK zoom
	dwnext	.sound
	dwflag	.main1
	dwnext	.main2
	dwflag	.main3
	dwnext	.select_init
	dwflag	.select	;;;; OK select
	dwstop	.exit

;------------------------------------------------------------
.init	
	Mobjchange 0,ys_bs_fireOK,bs_strat_cursor
	jmp	Main_OBJ

;------------------------------------------------------------
.sound	ksound	en_explode_s
.main1	jmp	Main_OBJ
;------------------------------------------------------------
.main2	
	Mcursor_okset

	Mobjchange 0,ys_bs_cursoropen,bs_strat_cursor
	jmp	Main_OBJ

;------------------------------------------------------------
.main3	jmp	Main_OBJ
	
;------------------------------------------------------------
.select_init
	Mobjchange 0,ys_bs_cursor,bs_strat_cursor
;------------------------------------------------------------
.select


;---- cancel mode ---------------------

	lda	repeat_trig
	and	#800h+200h+100h	; up/left/right/
	beq	.select_skip
	jsr	bs_keyselect

	Mset	bestscore_struct,idx_bestscore_keyselect
	dec	nameset_cursor
	bra	.exit

;---- OK check ------------------------

.select_skip
	lda	trig0
	and	#button_B
	beq	.exit
	Mset	bestscore_struct,idx_bestscore_keyOKend
	bra	.exit

;------------------------------------------------------------
.exit	jmp	Main_OBJ



;=====================================================================
; 	BESTSCORE KEY OK keyselect
;===================================================================== 

bestscore_keyOKend

	jsr	dc_program
	dwnext	.init
	dwloop	10,.main
	dwnext	.sound
	dwflag	.main
	dwnext	.endwaitinit
	dwloop  110,.endwait
	dwnext	.exit
	dwstop	.endloop

;------------------------------------------------------------
.init	
	ksound	longlaser1
	Mobjchange 0,ys_bs_fireOK,bs_strat_cursor
	jmp	Main_OBJ

;------------------------------------------------------------
.sound	ksound	bomexplode
.main	jmp	Main_OBJ
;------------------------------------------------------------
.exit
	lda	#0ffffh
	sta	hiscore_endflag
	stz	nameset_cursor	;(cursor)
	stz	nameset_keyX	;(X)
	stz	nameset_keyY	;(Y)

	jsl	yjresult_init_l	; object initialzie

	rts

;------------------------------------------------------------
.endwaitinit	Mobjkill 2
	Mobjkill 1
	MObjkill 0
.endwait	jsr	Main_obj
	rts

;------------------------------------------------------------
.endloop	rts
	
;------------------------------------------------------------




;*********************************************************************
;	------------------
;	 Sprite Strategy 
;            ------------------
;*********************************************************************
div_10	sty	XDividend	;<<IN>> equ 4204h ( unsigned 16bits )
	a8
	lda	#10
	sta	XDivisor	;<<IN>> equ 4206h ( unsigned 8bits ) 
	a16
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ldy	XQuotient	;<<OUT>> equ 4214h ( unsigned 16bits )
	lda	XResidue	;<<OUT>> equ 4216h ( unsigned 16bits )
	rts

;-------------------------------------------------
coin_draw
;-------------------------------------------------
;; input Aregister 0 ... 99 (byte)
;;
;----------------------------------------------------------
	phy			; >>
	tay			;
	jsr	div_10		;
	sta	Xwork0		;
	jsr	div_10		;
	asl	a		;
	asl	a		;
	asl	a		;	
	asl	a		;
	ora	Xwork0		;
	ply			; <<  ( Position )
;----------------------------------------------------------
	pha			;>>
	lsr	A		;W
	lsr	A		;W
	lsr	A		;W
	lsr	A		;W
	jsr	.digit
	pla			;<
.digit	and	#000fh
	ora	#00c0h
	and	#00ffh	
	ora	#3000h
.set	ldx	sprite_register
	sta.l	sprites+2,x	;
	tya
	sta.l	sprites+0,x	;
	clc
	adc	#0008h
	inx
	inx
	inx
	inx
	stx	sprite_register ; <<
	tay			;
	rts

;===============================================








;---------------------------------------------
setYposition
	ldx	register
	lda.l	hiscore_number
	asl	a
	asl	a
	asl	a
	asl	a
	adc	#barpositionY
	sta	_axisY,x
	rts

;---------------------------------------------
bs_strat_coindisp

	jsr	Newoamset

	ldy	#obj_cointotal_message&WM
	lda.l	medal_clear
	beq	.skip

	ldy	#obj_coinclear_message&WM
	ldx	register
	lda	_axisY,x
	xba
	ora	_axisX,x
	jmp	common_oamset


.skip	
	ldx	register
	lda	_axisY,x
	xba
	ora	_axisX,x
	jsr	common_oamset
	
	ldy	#coinposX+28h+coinposY*100h
	lda.l	medal_counter
	jsr	coin_draw

	rts

;---------------------------------------------
bs_strat_message
	jmp	Newoamset

;---------------------------------------------
bs_strat_bar_bestscore
	ldx	register
	lda	hiscore_number_cursor
	asl	a
	asl	a
	asl	a
	asl	a
	adc	#barpositionY
	sta	_axisY,x
	jmp	Newoamset
;---------------------------------------------
bs_strat_bar
	jsr	setYposition
	jmp	Newoamset
;---------------------------------------------
bs_strat_bar_clear
	lda	#barpositionY+00h
	ldx	register
	sta	_axisY,x
	jsr	Newoamset

	lda	#barpositionY+10h
	jsr	set_bar_clear
	lda	#barpositionY+20h
	jsr	set_bar_clear
	lda	#barpositionY+30h
	jsr	set_bar_clear
	lda	#barpositionY+40h
	jmp	set_bar_clear
	
set_bar_clear
	ldx	register
	sta	_axisY,x
	jmp	Newoamset_next

;---------------------------------------------

bs_strat_namecursor
	jsr	setYposition
	lda	nameset_cursor
	cmp	#3
	bcs	.exit
	asl	a
	asl	a
	asl	a
	adc	#2fh
	sta	_axisX,x
	jmp	Newoamset

.exit	rts

;---------------------------------------------
bs_strat_cursor	
	
	ldx	register

	lda	nameset_keyY
	asl	a
	tay
	lda	nameset_keyX
	asl	a
	asl	a
	asl	a
	asl	a
	adc	.offset&WM,y
	sta	_axisX,x

	lda	nameset_keyY
	asl	a
	asl	a
	asl	a
	asl	a
	adc	#09fh
	sta	_axisY,x

;-<< special >>-------
;;	lda	nameset_keyY	;; 0/1/2
;;	cmp	#2
;;	bne	.entry
;;
;;	lda	nameset_keyX	;; 9
;;	cmp	#dan2_Xcount
;;	bne	.entry
;;	lda	_axisX,x
;;	clc
;;	adc	#8
;;	sta	_axisX,x
;-<< special >>-------


.entry	jmp	Newoamset



.offset	dw 52,52-8,52



;*********************************************************************
;	---------------------------
;	 nameset input name !!
;	---------------------------
;*********************************************************************
;###################################
;#########		    ###########
;#########  BACKUP WTITE ###########
;#########		    ###########
;###################################

cursorcode_back	equ	0f0h
cursorcode_for	equ	0f1h
cursorcode_ok	equ	0f2h
cursorcode_oldname	equ	0f3h

;=-=-=-=-=-=-=

bs_nameinput

	lda.l	hiscore_number
	ora	#hs_sizeof*256
	jsr	mult_u8u8
	clc
	adc	#hs_name&WM
	sta	Xaddr+0
	lda	#hs_name>>16
	sta	Xaddr+2



; ------ Calc Data Pointer ---------------------
	lda	nameset_keyY	
	ora	#0b00h	
	jsr	mult_u8u8
	clc	
	adc	nameset_keyX
	tax			; Yreg = 11*Ypos + Xpos

; ------ Calc Name Pointer ---------------------

	ldy	nameset_cursor
	lda	.inputdata&WM,x
	and	#00ffh
	cmp	#cursorcode_back
	beq	.code_back
	cmp	#cursorcode_for
	beq	.code_for
	cmp	#cursorcode_ok
	beq	.code_ok
	a8
	sta	[Xaddr],y	; #### BACKUP RAM WRITE ####
	a16	
	jsr	calc_set_sum	; #### BACKUP SUMSET    ####

	jsr	Drawbuffer_bestscore
	inc	nameset_cursor		;;;; cursor INC
	rts
	
;------------------------------------------
.code_back	
;;;;;;	MBRK

	tya			; X nameset_cursor
	dec	a
	bmi	.skip11
	sta	nameset_cursor
	cmp	#2
	bcs	.noset
.skip11
	a8
	lda	#idx_bs_data_space
	sta	[Xaddr],y	; #### BACKUP RAM WRITE ####
	a16
	jsr	calc_set_sum	; #### BACKUP SUMSET    ####
	jsr	Drawbuffer_bestscore
	rts

;------------------------------------------
.code_for	tya			; X nameset_cursor
	inc	a
	bra	.exitset	

;------------------------------------------
.code_ok	lda	#4
;------------------------------------------
.exitset	sta	nameset_cursor
;------------------------------------------
.noset	rts

;####################################################################
;####################################################################
;####################################################################
;
;
;
;
;
;
;
;
;
;================================================

;;	
	;;--------0---1---2---3---4---5---6---7---8---9--10
.inputdata
	db	__a,__b,__c,__d,__e,__f,__g,__h,__i,__j,__k
	db	__l,__m,__n,__o,__p,__q,__r,__s,__t,__u,__v
	db	__w,__x,__y,__z
	db	idx_bs_data_sdot	;;
	db	idx_bs_data_sten	;;
	db	idx_bs_data_sbou	;;
	db	idx_bs_data_swaru	;;
	db	cursorcode_back
	db	cursorcode_for
	db	cursorcode_ok
 

;;; back_cur

;*********************************************************************
;	---------------------------
;	 nameset keyselect program
;	---------------------------
;*********************************************************************


bs_keyselect

	lda	nameset_keyX
	ldx	nameset_keyY
	phx			; >>
	pha			;   >>
	jsr	.entry
	pla			;   <<
	plx			; <<
	cmp	nameset_keyX
	bne	.sound
	cpx	nameset_keyY
	beq	.exit

.sound	ksound name_set_cursol
.exit	rts

;-----------------------------------------------------------------

.entry
	jsr	.UD		; up down key select
	jsr	.LR		; left right key select


;------------------------------------
	ldy	nameset_keyY
	lda	.offset&WM,y
	and	#00ffh
	sta	bs_work0

;------------------------------------
	lda	nameset_keyX
	bmi	.skip
	cmp	bs_work0
	beq	.end
	bcc	.end

;------------------------------------
	lda	nameset_keyY
	cmp	#2
	bcs	.s0
	inc	nameset_keyY
	lda	#0
	bra	.end
.s0	lda	bs_work0
	bra	.end

;------------------------------------
.skip	lda	nameset_keyY
	bne	.s1
	lda	#0
	bra	.end
.s1	dec	a
	tay
	sta	nameset_keyY
	lda	.offset&WM,y
	and	#00ffh
.end	sta	nameset_keyX

;------------------------------------

	rts

;--------------------------------------


.offset	db	dan0_Xcount,dan1_Xcount,dan2_Xcount

;--------------------------------------
.UD	lda	repeat_trig
	bit	#button_up
	bne	.up
	bit	#button_down
	bne	.down
	rts
;--------------------------------------
.LR	lda	repeat_trig
	bit	#button_left
	bne	.left
	bit	#button_right
	bne	.right
	rts
;--------------------------------------


;--------------------------------------
.right	inc	nameset_keyX
	rts

;--------------------------------------
.left	dec	nameset_keyX
	rts

;--------------------------------------
.up
	lda	nameset_keyY
	dec	a
	bmi	.exit3
	sta	nameset_keyY

;--------------------------- special keymove ------>>>>>>>>>>>>
;;;;	cmp	#1
;;;;	bne	.exit3
;;;;	ldy	nameset_keyX
;;;;	cpy	#dan2_Xcount
;;;;	bne	.exit3
;;;;	inc	nameset_keyX

;--------------------------- special keymove ------>>>>>>>>>>>>
.exit3	rts

;--------------------------------------
.down
	lda	nameset_keyY
	inc	a
	cmp	#3
	bcs	.exit4
	sta	nameset_keyY
.exit4	rts

;--------------------------------------








;*********************************************************************
;
; Screen Buffer Draw Library
;
;*********************************************************************
;
;
;  
;
;-------------------------------------------------------------------

bs_attr		equ	Xwork0
bs_bufferpointer	equ	Xwork1
bs_datapointer	equ	Xwork2
bs_temp		equ	Xwork3
bs_rampointer	equ	Xwork4
bs_work0		equ	Xwork5
bs_work1		equ	Xwork6


;=====================================================================
;------------------------------------------------
select_rank		db idx_bs_data_rank1 	; dmmy
		db idx_bs_data_rank1 
		db idx_bs_data_rank2 
		db idx_bs_data_rank3 
		db idx_bs_data_rank4 
		db idx_bs_data_rank5 
		db idx_bs_data_rank5 	; dmmy
		db idx_bs_data_rank5 	; dmmy
;------------------------------------------------
select_ABCrank 	db idx_bs_data_rankA	; dmmy
		db idx_bs_data_rankB
		db idx_bs_data_rankC
		db idx_bs_data_rankD
		db idx_bs_data_rankE
		db idx_bs_data_rankF
		db idx_bs_data_rankF  	; dmmy
		db idx_bs_data_rankF	; dmmy
;------------------------------------------------
select_pilot		db idx_bs_data_fox	; 0
		db idx_bs_data_falco	; 1
		db idx_bs_data_peppy	; 2
		db idx_bs_data_slippy	; 3
		db idx_bs_data_miyu	; 4	
		db idx_bs_data_fay	; 5	
		db idx_bs_data_pepper	; 6
		db idx_bs_data_pilotclear ; 7
;------------------------------------------------



Set_BESTscorelist
;--------------------------------------------------------------------
;;;; input [X] .......................... 7fram pointer
;--------------------------------------------------------------------
	sty	bs_rampointer
;--------------------------------------------------------------------
	a8
;-----------------------------------------------
					; 12345 Rank Display
;;;;;	MreadRAM  hs_rank
;;;;;	lda	select_rank&WM,y
;;;;;	MsetMB

	MsetMB_skip1	;(rank display )
	MsetMB_skip1	;(rank display )
	MsetMB_skip1
;-----------------------------------------------
 					; Name Data Display
	MreadRAM  hs_name+0
	and	#3fh		; alphabet only !!
	MsetMB
	MreadRAM  hs_name+1
	and	#3fh
	MsetMB
	MreadRAM  hs_name+2
	and	#3fh
	MsetMB
;-----------------------------------------------
	MsetMB_skip1			
	
	MsetMB_attr 1
	MsetMB_skip1			; Pilot Data Display
	MreadRAM  hs_pilot+0
	and	#0fh
	tay
	lda	select_pilot,y
	MsetMB
	MreadRAM  hs_pilot+1
	and	#0fh
	tay
	lda	select_pilot,y
	MsetMB
	MsetMB_attrclear

	MsetMB_skip1			

;-----------------------------------------------
	MsetMB_attr 7
	MsetMB_skip1			; Score Display
	jsr	Set6_score
	MsetMB_attrclear
;-----------------------------------------------
	MsetMB_skip1			; Time Display
	jsr	Set3_time		
	MsetMB_skip1
;-----------------------------------------------
					; ABC Rank Display
	MreadRAM  hs_state+0
	and	#0fh
	tay
	lda	select_ABCrank,y
	MsetMB
;-----------------------------------------------
	MsetMB_dataend

;--------------------------------------------------------------------
;;;; output [X] .......................... 7fram pointer
;--------------------------------------------------------------------

	a16

	rts



;*********************************************************************
;	BestScore BGset Program
;*********************************************************************

BS_BGset	
	sty	bs_bufferpointer	; Screen buffer Pointer
	stx	bs_datapointer		; Data Pointer
	stz	bs_attr
.loop
	ldx	bs_datapointer
	lda.l	bestscore_messagebuffer,x  	; data read !!
	inx
	stx	bs_datapointer
	and	#00ffh
	cmp	#00ffh				; end code 
	beq	.exit
	asl	a
	tax
	lda	BSchardata&WM,x
	tay
	lda.w	0,y
	and	#00ffh
	asl	a
	tax
	jsr	(.prog,x)
	stx	bs_bufferpointer
	bra	.loop
.exit	
	rts

.prog	Mindexliststart
	Mindexlist	bs_1x2		; BGdraw    1x2
	Mindexlist	bs_2x2		; BGdraw    2x2
	Mindexlist	bs_3x2		; BGdraw    3x2
	Mindexlist	bs_skip		; drawskip  N
	Mindexlist	bs_setattr
	

;*********************************************************************
;	attribute set
;*********************************************************************

bs_setattr	lda.w	0,y
	and	#0ff00h
	sta	bs_attr
	ldx	bs_bufferpointer
	rts

;*********************************************************************
;	skip BG-draw
;*********************************************************************

bs_skip	lda.w	1,y			; counter
	and	#00ffh
	tay
	ldx	bs_bufferpointer
.loop	inx
	inx
	dey
	bne	.loop
	rts

;********************************************************************
;	3x2 BG-draw
;********************************************************************
bs_3x2	ldx	bs_bufferpointer
	lda.w	1,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+00h,x
	lda.w	3,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+02h,x
	lda.w	5,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+04h,x
	lda.w	7,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+40h,x
	lda.w	9,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+42h,x
	lda.w	11,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+44h,x
	inx
	inx
	inx
	inx
	inx
	inx
	rts

;********************************************************************
;	2x2 BG-draw
;********************************************************************
bs_2x2	ldx	bs_bufferpointer
	lda.w	1,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+00h,x
	lda.w	3,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+02h,x
	lda.w	5,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+40h,x
	lda.w	7,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+42h,x
	inx
	inx
	inx
	inx
	rts

;********************************************************************
;	1x2 BG-draw
;********************************************************************
bs_1x2	ldx	bs_bufferpointer
	lda.w	1,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+00h,x
	lda.w	3,y
	eor	bs_attr
	sta.l	mmxx_screenbuffer+40h,x
	inx
	inx
	rts

;*********************************************************************
;
;*********************************************************************

;=====================================================================
Mbs_1x2	macro	[d1,d2]
	db	idx_bs_1x2
	dw	{d1},{d2}	
	endm
;=====================================================================
Mbs_2x2	macro	[d1,d2,d3,d4]
	db	idx_bs_2x2
	dw	{d1},{d2},{d3},{d4}	
	endm
;=====================================================================
Mbs_3x2	macro	[d1,d2,d3,d4,d5,d6]
	db	idx_bs_3x2
	dw	{d1},{d2},{d3}
	dw	{d4},{d5},{d6}
	endm
;=====================================================================
Mbs_skip	macro	[data]
	db	idx_bs_skip
	db	{data}
	endm
;=====================================================================
Mbs_setattr	macro	[data]
	db	idx_bs_setattr
	db	{data}
	endm
;=====================================================================


BSchardata
	Mindexliststart
	Mindexlist 	bs_data_s0		;(00)
	Mindexlist	bs_data_s1
	Mindexlist	bs_data_s2
	Mindexlist	bs_data_s3
	Mindexlist 	bs_data_s4
	Mindexlist	bs_data_s5
	Mindexlist	bs_data_s6
	Mindexlist	bs_data_s7
	Mindexlist 	bs_data_s8
	Mindexlist	bs_data_s9
	Mindexlist	bs_data_sA
	Mindexlist	bs_data_sB
	Mindexlist 	bs_data_sC
	Mindexlist	bs_data_sD
	Mindexlist	bs_data_sE
	Mindexlist	bs_data_sF
	Mindexlist 	bs_data_sG		;(10)
	Mindexlist	bs_data_sH		;(11)
	Mindexlist	bs_data_sI		;(12)
	Mindexlist	bs_data_sJ		;(13)
	Mindexlist 	bs_data_sK		;(14)
	Mindexlist	bs_data_sL		;(15)
	Mindexlist	bs_data_sM		;(16)
	Mindexlist	bs_data_sN		;(17)
	Mindexlist 	bs_data_sO		;(18)
	Mindexlist	bs_data_sP		;(19)
	Mindexlist	bs_data_sQ		;(1A)
	Mindexlist	bs_data_sR		;(1B)
	Mindexlist 	bs_data_sS		;(1C)
	Mindexlist	bs_data_sT		;(1D)
	Mindexlist	bs_data_sU		;(1E)
	Mindexlist	bs_data_sV		;(1F)
	Mindexlist	bs_data_sW		;(20)
	Mindexlist	bs_data_sX		;(21)
	Mindexlist	bs_data_sY		;(22)
	Mindexlist	bs_data_sZ		;(23)
	Mindexlist	bs_data_sdot		;(24)
	Mindexlist	bs_data_sten		;(25)
	Mindexlist	bs_data_sbou		;(26)
	Mindexlist	bs_data_swaru		;(27)
	Mindexlist	bs_data_space		;(28)

	Mindexlist	bs_data_rank1 		;(29)
	Mindexlist	bs_data_rank2 		;(2A)
	Mindexlist	bs_data_rank3 		;(2B)
	Mindexlist	bs_data_rank4 		;(2C)
	Mindexlist	bs_data_rank5 		;(2D)

	Mindexlist	bs_data_rankA 		;(2E)
	Mindexlist	bs_data_rankB 		;(2F)
	Mindexlist	bs_data_rankC 		;(30)
	Mindexlist	bs_data_rankD 		;(31)
	Mindexlist	bs_data_rankE 		;(32)
	Mindexlist	bs_data_rankF		;(33)

	Mindexlist	bs_data_fox		;(34)	
	Mindexlist	bs_data_falco		;(35)
	Mindexlist	bs_data_peppy		;(36)
	Mindexlist	bs_data_slippy		;(37)
	Mindexlist	bs_data_miyu		;(38)		
	Mindexlist	bs_data_fay		;(39)	
	Mindexlist	bs_data_pepper		;(3A)
	Mindexlist	bs_data_pilotclear	;(3B)

	Mindexlist	bs_data_skip1		;(3C)
	Mindexlist	bs_data_skip2		;(3D)
	Mindexlist	bs_data_clearattr	;(3E)
	Mindexlist	bs_data_eorattr1	;(3F)
	Mindexlist	bs_data_eorattr2
	Mindexlist	bs_data_eorattr3
	Mindexlist	bs_data_eorattr4
	Mindexlist	bs_data_eorattr5
	Mindexlist	bs_data_eorattr6
	Mindexlist	bs_data_eorattr7

;;;;	endcode					;(FF)

;=====================================================================

bs_data_skip1	Mbs_skip	1
bs_data_skip2	Mbs_skip	2
bs_data_clearattr	Mbs_setattr	00h
bs_data_eorattr1	Mbs_setattr	04h
bs_data_eorattr2	Mbs_setattr	08h
bs_data_eorattr3	Mbs_setattr	0ch
bs_data_eorattr4	Mbs_setattr	10h
bs_data_eorattr5	Mbs_setattr	14h
bs_data_eorattr6	Mbs_setattr	18h
bs_data_eorattr7	Mbs_setattr	1ch

bs_data_s0		Mbs_1x2	0c00h,0c10h	;(0)
bs_data_s1		Mbs_1x2	0c01h,0c11h	;(1)
bs_data_s2		Mbs_1x2	0c02h,0c12h	;(2)
bs_data_s3		Mbs_1x2	0c03h,0c13h	;(3)
bs_data_s4		Mbs_1x2	0c04h,0c14h	;(4)
bs_data_s5		Mbs_1x2	0c05h,0c15h	;(5)
bs_data_s6		Mbs_1x2	0c06h,0c16h	;(6)
bs_data_s7		Mbs_1x2	0c07h,0c17h	;(7)
bs_data_s8		Mbs_1x2	0c08h,0c18h	;(8)
bs_data_s9		Mbs_1x2	0c09h,0c19h	;(9)
bs_data_sA		Mbs_1x2	0c0ah,0c1ah	;(A)
bs_data_sB		Mbs_1x2	0c0bh,0c1bh	;(B)
bs_data_sC		Mbs_1x2	0c0ch,0c1ch	;(C)
bs_data_sD		Mbs_1x2	0c0dh,0c1dh	;(D)
bs_data_sE		Mbs_1x2	0c0eh,0c1eh	;(E)
bs_data_sF		Mbs_1x2	0c0fh,0c1fh	;(F)
bs_data_sG		Mbs_1x2	0c20h,0c30h	;(G)
bs_data_sH		Mbs_1x2	0c21h,0c31h	;(H)
bs_data_sI		Mbs_1x2	0c22h,0c32h	;(I)
bs_data_sJ		Mbs_1x2	0c23h,0c33h	;(J)
bs_data_sK		Mbs_1x2	0c24h,0c34h	;(K)
bs_data_sL		Mbs_1x2	0c25h,0c35h	;(L)
bs_data_sM		Mbs_1x2	0c26h,0c36h	;(M)
bs_data_sN		Mbs_1x2	0c27h,0c37h	;(N)
bs_data_sO		Mbs_1x2	0c28h,0c38h	;(O)
bs_data_sP		Mbs_1x2	0c29h,0c39h	;(P)
bs_data_sQ		Mbs_1x2	0c2ah,0c3ah	;(Q)
bs_data_sR		Mbs_1x2	0c2bh,0c3bh	;(R)
bs_data_sS		Mbs_1x2	0c2ch,0c3ch	;(S)
bs_data_sT		Mbs_1x2	0c2dh,0c3dh	;(T)
bs_data_sU		Mbs_1x2	0c2eh,0c3eh	;(U)
bs_data_sV		Mbs_1x2	0c2fh,0c3fh	;(V)
bs_data_sW		Mbs_1x2	0c40h,0c50h	;(W)
bs_data_sX		Mbs_1x2	0c41h,0c51h	;(X)
bs_data_sY		Mbs_1x2	0c42h,0c52h	;(Y)
bs_data_sZ		Mbs_1x2	0c43h,0c53h	;(Z)
bs_data_sdot		Mbs_1x2	0c44h,0c54h	;(.)
bs_data_sten		Mbs_1x2	0c45h,0c55h	;(:)
bs_data_sbou		Mbs_1x2	0c4dh,0c5dh	;(-)
bs_data_swaru	Mbs_1x2	0c4eh,0c5eh	;(/)
bs_data_space	Mbs_1x2	0c44h,0c44h	;( )

bs_data_rank1 	Mbs_2x2 0c46h,0c47h,0c56h,0c57h
bs_data_rank2 	Mbs_2x2 0c48h,0c49h,0c58h,0c59h
bs_data_rank3 	Mbs_2x2 0c48h,0c49h,08c48h,08c49h
bs_data_rank4 	Mbs_2x2 0c4ah,0c4bh,0c5ah,0c5bh
bs_data_rank5 	Mbs_2x2 0c4ch,08c59h,0c5ch,08c49h

bs_data_rankA 	Mbs_3x2 0c80h,0c81h,0c82h,0c90h,0c91h,0c92h
bs_data_rankB 	Mbs_3x2 0ca0h,0ca1h,0ca2h,0cb0h,0cb1h,0cb2h
bs_data_rankC 	Mbs_3x2 0ca3h,0ca4h,0ca5h,0cb3h,0cb4h,0cb5h
bs_data_rankD 	Mbs_3x2 0ca6h,0ca7h,0ca8h,0cb6h,0cb7h,0cb8h
bs_data_rankE 	Mbs_3x2 0ca9h,0caah,0cabh,0cb9h,0cbah,0cbbh
bs_data_rankF 	Mbs_3x2 0cach,0cadh,0caeh,0cbch,0cbdh,0cbeh

bs_data_fox		Mbs_2x2	0cc0h,0cc1h,0cd0h,0cd1h
bs_data_falco	Mbs_2x2	0cc2h,0cc3h,0cd2h,0cd3h
bs_data_peppy	Mbs_2x2	0cc4h,0cc5h,0cd4h,0cd5h
bs_data_slippy	Mbs_2x2	0cc6h,0cc7h,0cd6h,0cd7h
bs_data_miyu		Mbs_2x2	0cc8h,0cc9h,0cd8h,0cd9h
bs_data_fay		Mbs_2x2	0ccah,0ccbh,0cdah,0cdbh
bs_data_pepper	Mbs_2x2	0ccch,0ccdh,0cdch,0cddh

bs_data_pilotclear	Mbs_2x2 0cceh,0cceh,0cdeh,0cdeh

;=====================================================================
;	Auto Repeat !!!
;=====================================================================


call_repeat_trigger

	ldy	repeat_timer
	lda	cont0
	and	#00f00h


;-----------------------------------------------
; Auto Repeat Program
;-----------------------------------------------
main_repeat	
	STY	bs_temp			;
	CLC				;(auto repeat)
	TAY				;
	BEQ	.store			;
	SEC				;
	LDY	bs_temp			;
	BEQ	.step			;
	CPY	#15			;
	BCC	.step			;
	LDY	#12			;
.step	INY				;
.store	BCS	.repeat			;
	LDA	#0			;
.repeat
;-----------------------------------------------

	sty	repeat_timer
	sta	bs_temp
	lda	trig0
	and	#0f0ffh
	ora	bs_temp
	sta	repeat_trig

	rts


;=====================================================================
;	Divide Program
;=====================================================================
;;
;; Xreg ... 	draw buffer pointer
;;
;;
;-------------------------------------
Set3_time
	php			
	a16

	lda	#3
	sta	bs_temp

	phx			; >>
	ldx	bs_rampointer
	lda.l	hs_time,x
	plx			; <<
	sta	kz_wkdividend_L	 ; (low)  16bit
	stz	kz_wkdividend_H	 ; (high)  8bit
	bra	set_decimal_disp

Set6_score	
	php
	a16

	lda	#6
	sta	bs_temp
	phx					; >>
	ldx	bs_rampointer
	lda.l	hs_score+0,x
	sta	kz_wkdividend_L	 		; (low)  16bit
	lda.l	hs_score+2,x
	and	#00ffh
	sta	kz_wkdividend_H	 		; (high)  8bit
	plx					; <<

;--------------------------------------------------------------
set_decimal_disp

	txa
	clc
	adc	bs_temp
	tax

	phx		; >>
.loop	ldy	#10
	jsl	KDivide_u32u16_l
	a8
	sta.l	bestscore_messagebuffer-1,x
	a16
	dex
	dec	bs_temp
	bne	.loop
	plx		; <<

	plp
	rts

;********************************************************************
;;	------------------------
;;	 result finger program
;;	------------------------
;********************************************************************



;=====================================================
yjresult_init_l
	Mbankprog
	php
	ai16

	jsr	Init_objlist
	Mobjinit 0,ys_bs_fingerselect,bs_result_finger,000h,0e1h

	lda.l	check_bestscore_mode
	beq	.skip
	lda	#0
	sta.l	check_bestscore_mode

	Mobjinit 1,ys_bs_coindisp,bs_strat_coindisp,coinposX,coinposY
.skip

	plp
	Mbankrtl

;=====================================================
yjresult_main_l
	Mbankprog
	php
	ai16
	sty	sprite_register

	Mobjindex 0
	lda	tpx
	sta	_axisX,x
	lda	tpy
	sta	_axisY,x

	lda	tpa
	beq	.skip

	lda	#ys_bs_fingerOK
	sta	_anime_trigger,x

.skip	
	jsr	Main_OBJ

	ldy	sprite_register
	plp
	Mbankrtl

;=====================================================
;   <<<<< finger object program >>>>>
;=====================================================
bs_result_finger
	jmp	Newoamset
;=====================================================
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
;###############################################################
;###############################################################
;#########		    				###########
;#########  		BACKUP PROGRAMS 		###########
;#########		    				###########
;###############################################################
;###############################################################



;********************************************************************
;;	---------------------
;;	 backupRAM parameter
;;	---------------------
;********************************************************************
;###################################
;#########		    ###########
;#########  BACKUP WTITE ###########
;#########		    ###########
;###################################
;********************************************************************
;	Wite BackupRAM local macros
;********************************************************************

M_WriteBRAMflag macro	[work,checkbit,backupRAMbit]

	lda.l	{work}
	and	#{checkbit}
	beq	.skip\@
	lda	#{backupRAMbit}
	ora.l	m_backupflags		; Set FLAG
	sta.l	m_backupflags
	bra	.exit\@
.skip\@	lda	#{backupRAMbit}^0ffffh	; Clear FLAG
	and.l	m_backupflags
	sta.l	m_backupflags
.exit\@	
	endm

;--------------------------------------------------------------------
M_ReadBRAMflag macro	[work,checkbit,backupRAMbit]

	lda.l	m_backupflags		; <== BACKUP RAM READ
	and	#{backupRAMbit}
	beq	.skip\@
	lda	#{checkbit}
	ora.l	{work}			; Set FLAG
	sta.l	{work}
	bra	.exit\@
.skip\@	lda	#{checkbit}^0ffffh	; Clear FLAG
	and.l	{work}
	sta.l	{work}
.exit\@
	endm

;--------------------------------------------------------------------
;********************************************************************
;	Wite BackupRAM local library
;********************************************************************
MbackupRAM_common	macro	[addr]
{addr}	php
	ai16
	phx
	phy

	ldx	#({addr}_entry)&WM
	bra	backupRAM_common
	endm

;--------------------------------------------------------------------


; twin mode ------------
	MbackupRAM_common Read_backupRAM_defaulttwin_l
; expert mode ----------
	MbackupRAM_common Write_backupRAM_enableexpert_l
; sound  config --------
	MbackupRAM_common Read_backupRAM_soundmode_l
	MbackupRAM_common Write_backupRAM_soundmode_l
; player config --------
	MbackupRAM_common Read_backupRAM_playerconfig_l
	MbackupRAM_common Write_backupRAM_playerconfig_l
; camera config --------
	MbackupRAM_common Read_backupRAM_playertype_l
	MbackupRAM_common Write_backupRAM_playertype_l
; coinmedal total ------
	MbackupRAM_common Read_backupRAM_coindata_l
	MbackupRAM_common Write_backupRAM_coindata_l
; hiscore backup -------
	MbackupRAM_common Write_backupRAM_hiscore_l
; SUMcheck backupRAM ---
	MbackupRAM_common Check_backupRAM_l


;--------------------------------------------------------------------
backupRAM_common
	;			;>        --- php already
	phb			; >
	phk			;  >
	plb			;  <
	a8
	storenasty
	ramnastyoff
	ai16

	stx	backup_jmpwork
	ldx	#backup_jmpwork
	jsr	(0,x)

	a8
	restorenasty
	plb			;<


	ply
	plx
	plp			; <
	rtl

;--------------------------------------------------------------------
	longa
;--------------------------------------------------------------------


;********************************************************************
;	<<<<< default twin mode >>>>>
;********************************************************************

Read_backupRAM_defaulttwin_l_entry

	lda.l	m_backupflags+1		; twin player flag check
	and	#0111111b		; 6 player 
	sta.l	initial_twin_player	; Set Work

	rts

;-------------------------------------------
cv_index2bit
	db	1
	db	2
	db	4
	db	8
	db	10h
	db	20h
	db	40h
	db	80h
;-------------------------------------------



;********************************************************************
;	Read/Write playerconfig
;********************************************************************
Read_backupRAM_playerconfig_l_entry

	M_ReadBRAMflag	player_controltypeABXY,1,backupflag_playerABXY
	M_ReadBRAMflag	player_controltype,player_controltype_1B,backupflag_playerUPDW

	rts

;--------------------------------------------------------------------
Write_backupRAM_playerconfig_l_entry

	jsl	Check_backupRAM_l

; #### BACKUP RAM WRITE ####
	M_WriteBRAMflag	player_controltypeABXY,1,backupflag_playerABXY
	M_WriteBRAMflag player_controltype,player_controltype_1B,backupflag_playerUPDW

	jsr	calc_set_sum	;#### BACKUP SUMSET    ####
	rts

;--------------------------------------------------------------------
;
;
;********************************************************************
;	Write expert flag
;********************************************************************

Write_backupRAM_enableexpert_l_entry
	jsl	Check_backupRAM_l

	lda	#backupflag_expert	; expert enable
	ora.l	m_backupflags		; Set FLAG
	sta.l	m_backupflags

	jsr	calc_set_sum	;#### BACKUP SUMSET    ####
	rts

;********************************************************************
;	Read/Write soundmode
;********************************************************************
Read_backupRAM_soundmode_l_entry

	M_ReadBRAMflag	monoral,1,backupflag_soundmode

	rts
;--------------------------------------------------------------------
Write_backupRAM_soundmode_l_entry

	jsl	Check_backupRAM_l

	M_WriteBRAMflag	monoral,1,backupflag_soundmode

	jsr	calc_set_sum	;#### BACKUP SUMSET    ####
	rts

;--------------------------------------------------------------------



;********************************************************************
;	Read/Write playertype
;********************************************************************
Read_backupRAM_playertype_l_entry

	M_ReadBRAMflag	playerimportflag,pif_cockpit_on,backupflag_cameramode

	rts
;--------------------------------------------------------------------
Write_backupRAM_playertype_l_entry

	jsl	Check_backupRAM_l

; #### BACKUP RAM WRITE ####
	M_WriteBRAMflag	playerimportflag,pif_cockpit_on,backupflag_cameramode

	jsr	calc_set_sum	;#### BACKUP SUMSET    ####
	rts	

;********************************************************************
;	Read/Write playercoin
;********************************************************************
Mmedalcount	macro	[addr]
	ldy	#16
	lda.l	{addr}
.loop\@	lsr	a
	bcc	.skip\@
	inx
.skip\@	dey
	bne	.loop\@
	endm
;--------------------------------------------------------------------

Read_backupRAM_coindata_l_entry

	lda.l	m_backupcoin+0
	sta.l	emedal_1
	lda.l	m_backupcoin+2
	sta.l	emedal_2
	lda.l	m_backupcoin+4
	sta.l	emedal_3
	lda.l	m_backupcoin+6
	sta.l	emedal_4

;------------------------------------------
	a8
	lda.l	m_backupcoincount+0
	sta.l	emedaleasy
	lda.l	m_backupcoincount+1
	sta.l	emedalnormal
	lda.l	m_backupcoincount+2
	sta.l	emedalhard
	a16	
;------------------------------------------

	ldx	#0
	Mmedalcount	emedal_1
	Mmedalcount	emedal_2
	Mmedalcount	emedal_3
	Mmedalcount	emedal_4
	txa	
	sta.l	medal_counter
	cmp	#CLEAR_MEDAL_TOTAL
	bcc	.noclear

	lda	#0ffffh
	bra	.exit
.noclear	lda	#0
.exit	sta.l	medal_clear

	rts

;--------------------------------------------------------------------
Write_backupRAM_coindata_l_entry

	jsl	Check_backupRAM_l

	lda.l	emedal_1
	sta.l	m_backupcoin+0	;#### BACKUP WRITE     ####
	lda.l	emedal_2
	sta.l	m_backupcoin+2	;#### BACKUP WRITE     ####
	lda.l	emedal_3
	sta.l	m_backupcoin+4	;#### BACKUP WRITE     ####
	lda.l	emedal_4
	sta.l	m_backupcoin+6	;#### BACKUP WRITE     ####

	a8
	lda.l	emedaleasy
	sta.l	m_backupcoincount+0	;#### BACKUP WRITE     ####
	lda.l	emedalnormal
	sta.l	m_backupcoincount+1	;#### BACKUP WRITE     ####
	lda.l	emedalhard
	sta.l	m_backupcoincount+2	;#### BACKUP WRITE     ####
	a16	

	jsr	calc_set_sum	;#### BACKUP SUMSET    ####

	rts


;********************************************************************
;	Read Hiscore
;********************************************************************
;
;	ON,OFF hiscore
;	
;-------------------------------------------------------------------

yjcheck_hiscore_l
	php
	a8
	storenasty
	ramnastyoff


	lda.l	backup_writeflag	; Backup Draw ON ?
	bne	.hiscoreON		; yes -> ON


	ifne	AFscoredebug
	a16
	lda	#980
	sta.l	kw_totalscore1+1
	lda	#0
	sta.l	kx_rank
	a8
	endc


	lda.l	kw_totalscore1+2
	cmp.l	hs_score+hs_sizeof*4+2	
	bcc	.hiscoreOFF
	beq	.next
	bcs	.hiscoreON

.next	a16
	lda.l	kw_totalscore1+0
	cmp.l	hs_score+hs_sizeof*4+0
	beq	.hiscoreOFF
	bcc	.hiscoreOFF

.hiscoreON	a8
	restorenasty	
	plp
	sec
	rtl

.hiscoreOFF	a8
	restorenasty	
	plp
	clc
	rtl

;--------------------------------------------------------------------
	longa

;********************************************************************
;	BackupRAM SUM check & initialize 
;********************************************************************

backup_totalsize	equ 	m_backupram_sumexit-m_backupram_start
magic_data		equ	3480h+hs_sizeof

;--------------------------------------------------------------------

Check_backupRAM_l_entry


;;	MBRK

	lda	#magic_data
	cmp.l	m_magicnumber			; id  check
	bne	.backup_subcheck

	ldx	#(m_backupram_sumstart)&WM
	jsr	calc_sum			; sum check
	cmp.l	m_backupcheck

	beq	.exit


;--------------------- sub buffer dead ? --------------

.backup_subcheck

	lda	#magic_data
	cmp.l	m_backupram_subbuffer+2		; 2 === MAGIC NUMBER
	bne	.backup_init

	ldx	#(m_backupram_subbuffer+4)&WM	; 4 ... SUM CHECK 
	jsr	calc_sum			;             
	cmp.l	m_backupram_subbuffer+0		; 0 === SUM DATA
	bne	.backup_init

	Mmvn	m_backupram_subbuffer,m_backupram_start,m_backupram_count
	bra	.exit

;--------------------- backup initialzie --------------
.backup_init

	lda	#magic_data
	sta.l	m_magicnumber		; #### BACKUP WRITE!! ####

	jsr	ALLinit_BackupRAM	; #### BACKUP WRITE!! ####
	bra	.exit

;------------------------------------------------------

.exit	rts

;------------------------------------------------------
;
;
;
;
;
;********************************************************************
;	BackupRAM write hiscore
;********************************************************************
Write_backupRAM_hiscore_l_entry

	jsl	Check_backupRAM_l

	lda.l	backup_writeflag	; Backup Draw ?
	bne	.exit			; No ---> exit

	jsl	yjcheck_hiscore_l
	bcc	.exit

	jsr	Set_backupRAM_hiscore	; #### BACKUP WRITE!! ####

	lda	#00ffh			; Backup Draw ON !!
	sta.l	backup_writeflag

.exit	rts


;********************************************************************
;	-------------------------
;	 KUWASHIKU MIRU SET DATA
;	-------------------------
;********************************************************************


Load_kxwork

; xcalc

	lda	hiscore_number_cursor	; ( Bestscore.asm Work )
	ora	#hs_sizeof*256
	jsr	mult_u8u8
	tax

	a8

; code  ---
; score ---
	lda.l	hs_score+0,x
	sta.l	kw_totalscore1+0	; low 
	lda.l	hs_score+1,x
	sta.l	kw_totalscore1+1	; high 
	lda.l	hs_score+2,x
	sta.l	kw_totalscore1+2	; bank
; name ----
; pilot ---
	lda.l	hs_pilot+0,x
	sta.l	kx_p1_pilotNo
	lda.l	hs_pilot+1,x
	sta.l	kx_p2_pilotNo
; time ----
	a16
	lda.l	hs_time+0,x
	sta.l	kx_totaltime+0
	a8
; state rank ----
	lda.l	hs_state,x		;
	sta.l	kx_rank

; corneria % ----
	lda.l	hs_percent,x		; (%) counter
	sta.l	kx_corneriadamage
; help planets --
	lda.l	hs_planets,x		; planet counter
	sta.l	kx_planetclearcnt
; bomb battleships --
	lda.l	hs_battleships,x	; battleship counter
	sta.l	kx_battleshipclearcnt
; game mode --
	lda.l	hs_kdifficulty,x	; easy normal hard
	sta.l	Kdifficulty
	asl	a
	sta.l	Kdifficulty2

	lda.l	hs_kxresult,x		; clear/gameover/fail
	sta.l	kx_result

; basic score ------

	lda.l	hs_basicscore+0,x
	sta.l	kx_basicscore+0
	lda.l	hs_basicscore+1,x
	sta.l	kx_basicscore+1
	lda.l	hs_basicscore+2,x
	sta.l	kx_basicscore+2


	a16

; pertner continue ---

	lda.l	hs_resultflag,x
	sta.l	kx_resultflag

; bomb missile/fighter --

	lda.l	hs_ecountmissile,x
	sta.l	ecountmissile
	lda.l	hs_ecountfighter,x
	sta.l	ecountfighter
	
;----------------------------

	rts

;---------------------------------------------------------------------
;
;
;
;
;###################################==================================
;###################################==================================
;###################################==================================
;###################################==================================
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
;********************************************************************
;;	------------------------
;;	 backup ram sumcheck
;;	------------------------
;********************************************************************
;###################################
;#########		    ###########
;#########  BACKUP WTITE ###########
;#########		    ###########
;###################################
;-------------------------------------------------------------------
calc_sum
	stz	backup_sumwork
	ldy	#(m_backupram_sumexit-m_backupram_sumstart)&WM

.loop	lda.l	700000h,x
	and	#00ffh
	clc
	adc	backup_sumwork
	sta	backup_sumwork
	inx
	dey
	bne	.loop

	rts

;-------------------------------------------------------------------

m_backupram_count	equ	m_backupram_sumexit-m_backupram_start

;-------------------------------------------------------------------
calc_set_sum
	phx	; >>
	phy	;   >>

;;	MBRK

;------- main buffer ------

	ldx	#(m_backupram_sumstart)&WM
	jsr	calc_sum		; sumcheck calclation
	sta.l	m_backupcheck		; ; #### BACKUP WRITE!! ####

;------- sub buffer -------

	Mmvn	m_backupram_start,m_backupram_subbuffer,m_backupram_count

;--------------------------

	ply	;   <<
	plx	; <<
	rts
	

;-------------------------------------------------------------------
;#####################################################################
;#####################################################################
;#####################################################################





;-------------------------------------------------------

;#####################################################################
;#####################################################################
;#####################################################################



;********************************************************************
;;	------------------------
;;	 hiscore rank check
;;	------------------------
;********************************************************************
;###################################
;#########		    ###########
;#########  BACKUP WTITE ###########
;#########		    ###########
;###################################


;--------------------------------------------------------------------
Set_backupRAM_hiscore



	ldy	#5
	ldx	#hs_sizeof*4+0

.loop	a8
	lda.l	kw_totalscore1+2
	cmp.l	hs_score+2,x	
	a16
	bcc	.hiscoreOFF
	beq	.next
	bcs	.hiscoreON

.next	lda.l	kw_totalscore1+0
	cmp.l	hs_score+0,x	
	beq	.hiscoreOFF
	bcc	.hiscoreOFF

;------------------------------------------
.hiscoreON
;;;;	MBRK
	dey			;  4,3,2,1,0
	jsr	write_backupram	; #### BACKUP WRITE!! ####
	txa
	sec
	sbc	#hs_sizeof
	tax
	bpl	.loop

;------------------------------------------
.hiscoreOFF
	cpy	#5
	bne	.set

	blink

.set	tya
	sta.l	hiscore_number	 ; hiscore rank number
	lda	#0ffh
	sta.l	backup_writeflag ; write OK !!!

.exit	rts

;------------------------------------------
;#####################################################################
;#####################################################################
;#####################################################################


;;*******************************************************************
;;	backuprRAM "write"
;;*******************************************************************
;###################################
;#########		    ###########
;#########  BACKUP WTITE ###########
;#########		    ###########
;###################################

write_backupram

;; -------------------------------------------------

	cpy	#4	
	beq	.set_entry

;; -------------------------------------------------
;; sort data
;; -------------------------------------------------

	phy
	phx
	ldy	#hs_sizeof

.loop1	a8
	lda.l	hs_structstart,x		; source
	sta.l	hs_structstart+hs_sizeof,x	; dest ; #### BACKUP WRITE!! ####
	inx
	dey
	bne	.loop1
	a16

	plx
	ply

;; -------------------------------------------------
;; set data
;; -------------------------------------------------

.set_entry

	a8
; code  ----
	lda	#use_backupscore	; #### BACKUP WRITE!! ####
	sta.l	hs_code,x		; used backup code
; score ----
	lda.l	kw_totalscore1+0	; low 
	sta.l	hs_score+0,x		; #### BACKUP WRITE!! ####
	lda.l	kw_totalscore1+1	; high 
	sta.l	hs_score+1,x		; #### BACKUP WRITE!! ####
	lda.l	kw_totalscore1+2	; bank
	sta.l	hs_score+2,x		; #### BACKUP WRITE!! ####
; name -----
	lda	#idx_bs_data_space
	sta.l	hs_name+0,x		; #### BACKUP WRITE!! ####
	sta.l	hs_name+1,x		; #### BACKUP WRITE!! ####
	sta.l	hs_name+2,x		; #### BACKUP WRITE!! ####
; pilot -----
	lda.l	kx_p1_pilotNo
	sta.l	hs_pilot+0,x		; #### BACKUP WRITE!! ####
	lda.l	kx_p2_pilotNo
	sta.l	hs_pilot+1,x		; #### BACKUP WRITE!! ####

; time ----
	lda.l	kx_totaltime+0
	sta.l	hs_time+0,x		; #### BACKUP WRITE!! ####
	lda.l	kx_totaltime+1
	sta.l	hs_time+1,x		; #### BACKUP WRITE!! ####

; state rank ----
	lda.l	kx_rank
	and	#07h
	sta.l	hs_state,x		; #### BACKUP WRITE!! ####


; corneria % ----

	lda.l	kx_corneriadamage
	sta.l	hs_percent,x		; #### BACKUP WRITE!! ####

; help planets --

	lda.l	kx_planetclearcnt
	sta.l	hs_planets,x		; #### BACKUP WRITE!! ####

; bomb battleships --

	lda.l	kx_battleshipclearcnt
	sta.l	hs_battleships,x	; #### BACKUP WRITE!! ####

; game mode -----

	lda.l	Kdifficulty
	sta.l	hs_kdifficulty,x	; #### BACKUP WRITE!! ####
	lda.l	kx_result
	sta.l	hs_kxresult,x		; #### BACKUP WRITE!! ####

; basic score ------

	lda.l	kx_basicscore+0
	sta.l	hs_basicscore+0,x	; #### BACKUP WRITE!! ####
	lda.l	kx_basicscore+1
	sta.l	hs_basicscore+1,x	; #### BACKUP WRITE!! ####
	lda.l	kx_basicscore+2
	sta.l	hs_basicscore+2,x	; #### BACKUP WRITE!! ####

; bomb missile --
	a16

; pertner continue ---

	lda.l	kx_resultflag
	sta.l	hs_resultflag,x


	lda.l	ecountmissile
	sta.l	hs_ecountmissile,x	; #### BACKUP WRITE!! ####
	lda.l	ecountfighter
	sta.l	hs_ecountfighter,x	; #### BACKUP WRITE!! ####

;; -------------------------------------------------

; save twin player -------

	a8


	lda.l	hs_state,x		; if 0 then Arank pilot
	bne	.no_twin		; 

	phy				; >>

	lda.l	hs_pilot+0,x		; Arank pilot(1)
	and	#07h
	tay
	lda	cv_index2bit&WM,y
	ora.l	m_backupflags+1
	sta.l	m_backupflags+1

	lda.l	hs_pilot+1,x		; Arank pilot(2)
	and	#07h
	tay
	lda	cv_index2bit&WM,y
	ora.l	m_backupflags+1
	sta.l	m_backupflags+1

	ply				; <<

.no_twin
	a16
	
;; -------------------------------------------------
;; calcration SUMcheck data
;; --------------------------

	jsr	calc_set_sum		; #### BACKUP SUMSET ####

;; -------------------------------------------------

	rts


;--------------------------------------------------------------------
.set_twin	
	rts
;-------------------------------------------


;#####################################################################
;#####################################################################
;#####################################################################


;*********************************************************************
;	Init nameset Program
;*********************************************************************
;###################################
;#########		    ###########
;#########  BACKUP WTITE ###########
;#########		    ###########
;###################################

ALLinit_BackupRAM
	ai16

	ldx	#0

	a8
.loop	
	lda.l	ClearBackupData,x
	sta.l	m_backupram_sumstart,x	; #### BACKUP WRITE!! ####
	inx
	cpx	#(m_backupram_sumexit-m_backupram_sumstart)&WM
	bne	.loop
	a16

;---------------------------------------------------
;;; Eguchi SAN No Work NI coindata WO set SURU !!
	jsl	Read_backupRAM_coindata_l
	jsl	Read_backupRAM_playerconfig_l
	jsl	Read_backupRAM_playertype_l
;---------------------------------------------------
	jsr	calc_set_sum	; #### BACKUP SUMSET ####
;---------------------------------------------------

	rts

;#####################################################################
;#####################################################################
;#####################################################################
;;;
;;;
;;;
;;;
;;;
;====================================================================
	longa
;====================================================================
;;;
;;;
;;;
;;;
;;;
;=====================================================================
;=====================================================================
; END END END END END END END END END END END END END END END
;=====================================================================
;=====================================================================

