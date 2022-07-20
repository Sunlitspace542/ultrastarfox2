AFcleartime	= 0
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: gameobj.asm				*
;* 	Description	: Game Object 				*
;*	Date		: 1994.10.1				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
	INCPUB  gameobj
;---------------------------------------------------------------------
;
;
;
;
;
;*********************************************************************
;	position data
;*********************************************************************
;
;---------------------------------------------------------------------
clearobjdata		equ	3040h
scoreobjoffset	equ	1800h
;---------------------------------------------------------------------
;
;*********************************************************************
;	-------------------------
;	* game object initalize *
;	-------------------------
;*********************************************************************
init_gameobj_l
	Mbankprog
	php
	ai16

;--------------------------------------------------------
;;
	lda	#0
	sta.l	gameclear_yjflag

	km_cmpcheckgamemode	initmission
	bne	.nogame
	stz	gameobjstruct
	Mset	gameobjstruct,idx_demo_stagestart
;;
;--------------------------------------------------------
	jsr	Init_objlist	; initialize object list
;--------------------------------------------------------

.nogame	plp
	Mbankrtl

;*********************************************************************
;	-------------------------
;	* game object main      *
;	-------------------------
;*********************************************************************
gameobj_l
	Mbankprog
	php
	ai16
	sty	sprite_register	

	jsr	debug_display	; ROM debug display

	km_cmpcheckgamemode	initmission
	bne	.nogame

;-------------------------------------------------------
; Score debug TEST
;-------------------------------------------------------
;;	lda	trig0
;;	and	#button_R
;;	beq	.skip
;;	Mset	gameobjstruct,idx_demo_gameclearobj
;;.skip
;-------------------------------------------------------



	jsr	Bigtarget_SETcheck
	jsr	gameobj_mainprog
	jsr	set_bombcorneria

;-------------------------------------------------------


.nogame	ldy	sprite_register
	plp
	Mbankrtl


;*********************************************************************
;	-------------------------
;	* game object IRQ       *
;	-------------------------
;*********************************************************************
irq_gameobj_l
	rtl


;=====================================================================
;=====================================================================
;===========	gameobj programs ========================================
;===========	gameobj programs ========================================
;=====================================================================
;=====================================================================
;********************************************************************
;	Kenemy number check
;********************************************************************

Bigtarget_SETcheck

	lda.l	gameclear_yjflag	; Now Clear ?
	cmp	#1
	bne	.noclear

	Mset	gameobjstruct,idx_demo_gameclearobj

	lda	#0ffh
	sta.l	gameclear_yjflag	; Set ClearFlag
	bra	.exit

;----------------------------------------------
.noclear	lda.l	KEnemyNumber
	and	#00ffh
	cmp.l	Kenemy_backup
	beq	.exit
	sta.l	Kenemy_backup
	cmp	#0
	beq	.exit

.skip1	Mset	gameobjstruct,idx_demo_targetcount
.exit
	rts

	

;********************************************************************
;	gameobj demo
;********************************************************************

gameobj_mainprog
	Mset	dcregister,gameobjstruct
	jsr	dc_select
	Mindexliststart
	Mindexlist	.demoexit		; (0)
	Mindexlist	demo_stagestart	 	; (1)
	Mindexlist	demo_targetcount 	; (2)
	Mindexlist	demo_gameclearobj	; (3)
	Mindexlist	demo_enemygone		; (4)



.demoexit	rts

;--------------------------------------------------------------------



;********************************************************************
;		************************************************
; enemygone		************************************************
;		************************************************
;********************************************************************



demo_enemygone
	jsr	dc_program
	dwstart
	dwwait	2
	dwnext	gone_init
	dwstop	gone_main

;********************************************************************
gone_init
	jsr	Init_objlist
	Mobjinit 0,ys_enemygone,xxoamset,80h,70h
	rts

;********************************************************************

gone_main	jmp	Main_OBJ
	

;********************************************************************

xxoamset	ldx	register
	lda	_objlimit,x
	inc	a
	inc	a
	cmp	#40
	bcs	.skip
	sta	_objlimit,x
.skip	jmp	Newoamset

;********************************************************************

;
;
;
;
;
;
;********************************************************************
;		************************************************
; corneria bomb	************************************************
;		************************************************
;********************************************************************


set_bombcorneria

;--------------------------------------------------


;--------------------------------------------------
		
;	km_bitcheckmismapflag	attackcorneriaX
	km_bitcheckscreenflag	damagetrig
	bne	.entry

.exit
	lda	#0
	sta.l	corneria_bombanime	; animation reset
	rts

;--------------------------------------------------
.entry
	lda.l	meterswitch
	beq	.exit
	lda.l	corneria_bombanime	; counter inc
	inc	a
	cmp	#4*3
	bcc	.set
	lda	#1
.set	sta.l	corneria_bombanime

	asl	a
	asl	a
	tax				; INDEX

	lda.l	bombdatatable+2,x	; ROM pointer
	tay
	lda.l	bombdatatable+0,x	; position
	jmp	common_oamset		; (RTS)

;--------------------------------------------------

bombdatatable
	dw	1e1dh,.data_3&WM
	dw	1e1dh,.data_0&WM
	dw	1e1dh,.data_1&WM
	dw	1e1dh,.data_2&WM

	dw	2228h,.data_3&WM
	dw	2228h,.data_0&WM
	dw	2228h,.data_1&WM
	dw	2228h,.data_2&WM

	dw	2c22h,.data_3&WM
	dw	2c22h,.data_0&WM
	dw	2c22h,.data_1&WM
	dw	2c22h,.data_2&WM

;--------------------------------------------------

.data_0	MSoam_small	1
	db	-4,-4,0a8h,30h
.data_1	MSoam_big	1
	db	-8,-8,0c8h,30h
.data_2	MSoam_big	1
	db	-8,-8,0cah,30h
.data_3	db	0	
	
;--------------------------------------------------





;********************************************************************
;		************************************************
; demo_gameclearobj	************************************************
;		************************************************
;********************************************************************


;---- OBJ dot character ------------

OBJ_dotchar	equ	307eh
OBJ_hchar	equ	3469h

_cleartime_high 	equ	_dcwork+0
_cleartime_low	equ	_dcwork+2
_totaltime_countup	equ	_dcwork+4

;====================================================================

demo_gameclearobj
	jsr	dc_program
	dwnext	clearobj_init
	dwloop	26,clearobj_dispdemo
	dwflag	clearobj_scorecountUP
	dwloop	20,clearobj_dispwait
	dwstop	clearobj_exit

;---------------------------------------------------------------------
;	Gameclear Object Initialize
;---------------------------------------------------------------------
clearobj_init
	

;------------------------------------------------------

	ldx	dcregister
;-- Set clear time -----
	lda.l	kw_gametimer
	ifne	AFcleartime
	lda	#99			;;; debug
	endc
	sta	_cleartime_high,x	; clear time (1)
	lda.l	kx_yjGameTm
	sta	_cleartime_low,x	; clear time (2)

;-- Set MAP time (RESET) -------
;;;;	lda	#000			;;; debug
	lda.l	kx_totaltimebak
	sta	_totaltime_countup,x	; clear time (3)

;------------------------------------------------------
	Moff_objmeter

;---------------------------------------------------------------------
;	Gameclear Object Main
;---------------------------------------------------------------------
clearobj_dispdemo

	lda	sprite_register
	pha			; ====>

	jsr	disp_cleartotalobj

	plx			; <====
	ldy	dcregister
	lda.w	_dccounter,y
	cmp	#007fh
	bcs	.exit
	asl	a
	tay
	jsr	Lanime_objerace

.exit
	rts


;---------------------------------------------------------------------
;	Gameclear Object Main
;---------------------------------------------------------------------

clearobj_scorecountUP

	ldx	dcregister
	lda	_dccounter,x
	sec
	sbc	#10*3		; hispeed set time
	bpl	.hispeed
	ldy	#0
	bra	.loop
;------------------------------------------
.hispeed	tay
;------------------------------------------
.loop	dec	_cleartime_low,x
	bpl	.next

.skip	lda	_cleartime_high,x
	beq	.timecount_end
	dec	_cleartime_high,x
	lda	#9
	sta	_cleartime_low,x
	lda	_totaltime_countup,x
	cmp	#999			; Counter Max
	bcs	.next
	inc	_totaltime_countup,x

.next	dey
	bpl	.loop
;------------------------------------------
.timecount_nextframe

	ksound	add_time
	jmp	disp_cleartotalobj 	;(rts)
	


;------------------------------------------
.timecount_end
	stz	_cleartime_low,x
	dec	_dcflag,x		; end of process
	jmp	disp_cleartotalobj 	;(rts)

;---------------------------------------------------------------------
;	Gameclear Object Main
;---------------------------------------------------------------------

clearobj_dispwait

	jmp	disp_cleartotalobj 	;(rts)

;---------------------------------------------------------------------
;	Gameclera Object Exit
;---------------------------------------------------------------------
clearobj_exit
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
;********************************************************************
;	display clear/total time object
;********************************************************************

disp_cleartotalobj

; disp cleartime message --------
	ldy	#obj_cleartime&WM
	lda	#clearobjdata
	jsr	common_oamset

; disp gametimer(1) -------------
	ldx	dcregister
	lda	_cleartime_high,x
	jsr	dec_00_65535
	ldy	#clearobjdata+60h
	lda	Xwork0
	jsr	WOBJ_byte		; TIME (1)

; disp dot ----------------------
	ldy	#clearobjdata+6eh+800h
	lda	#OBJ_dotchar
	jsr	OBJ_set			; DOT !!
	ldy	#clearobjdata+6eh+800h
	lda	#OBJ_dotchar
	jsr	OBJ_set			; DOT !!

; disp gametimer(2) -------------
	ldy	#clearobjdata+74h
	ldx	dcregister
	lda	_cleartime_low,x	; clear time(2)
	jsr	WOBJ_digit		; TIME (2)

;---------------------------------------------

; disp totaltime message --------
	ldy	#obj_totaltime&WM
	lda	#clearobjdata+scoreobjoffset
	jsr	common_oamset

; disp totaltime message --------

	ldx	dcregister
	lda	_totaltime_countUP,x
	jsr	dec_00_65535
	lda	Xwork0
	ldy	#clearobjdata++60h+scoreobjoffset
	jsr	OBJ_three

;---------------------------------------------
	rts

;********************************************************************
;		************************************************
; DISP BIG TARGET	************************************************
;		************************************************
;********************************************************************

demo_targetcount
	jsr	dc_program
	dwnext	init_gametarget
	dwloop	24,main_gametarget
	dwstop	exit_gametarget

;---------------------------------------------------------------------

init_gametarget
	jsr	Init_objlist
      	Mobjinit 0,ys_big0,oamset_gametarget,080h,30h
	rts

;---------------------------------------------------------------------
oamset_gametarget
	jmp	Newoamset

;---------------------------------------------------------------------
main_gametarget
	lda.w	_dccounter,y
	lsr	a
	lsr	a
	lsr	a
	bcc	.exit

 	lda.l	KEnemyNumber
	and	#00ffh
	cmp	#10
	bcc	.skip
	lda	#9
.skip	clc
	adc	#ys_big0
 	Mobjanime 0
	

	jsr	Main_OBJ

.exit	rts

;---------------------------------------------------------------------
exit_gametarget
	stz	gameobjstruct
	rts


;********************************************************************
;		************************************************
; STAGE START	************************************************
;		************************************************
;********************************************************************

demo_stagestart
	jsr	dc_program
	dwstart
	dwwait	16/2
	dwnext	init_stageready
	dwloop	20h,main_stageready
	dwend	

;---------------------------------------------------------------------

init_stageready
	jsr	Init_objlist
      	Mobjinit 0,ys_ready4,oamset_stagestart,080h,70h
      	Mobjinit 1,ys_ready3,oamset_stagestart,080h,70h
      	Mobjinit 2,ys_ready2,oamset_stagestart,080h,70h
      	Mobjinit 3,ys_ready1,oamset_stagestart,080h,70h
      	Mobjinit 4,ys_ready0,oamset_stagestart,080h,70h

	rts
;---------------------------------------------------------------------
oamset_stagestart	

	jsr	moveXY
	jmp	Newoamset

;---------------------------------------------------------------------
main_stageready
	jsr	Main_OBJ
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
;********************************************************************
;	--------------------
;	* LIBRARY PROGRAMS *
;	--------------------
;********************************************************************



;********************************************************************
;	sprite erase Animation
;********************************************************************
;
; X reg		= sprite buffer pointer
; Y reg		= skip obj count
; sprite_register	= NOW sprite pointer
;
;--------------------------------------------------------------------
anime_objerace_loop
	dey
	bpl	.skip
	lda	#0e0e0h
	sta.l	sprites,x
.skip
	inx
	inx
	inx
	inx
Lanime_objerace
	cpx	sprite_register
	bcc	anime_objerace_loop

	rts

;---------------------------------------------


;********************************************************************
;	gamemode select index jump
;********************************************************************
;
; x = data address
; y = total counter
;
;--------------------------------------------------------------------

Lgamemode_idxjmp
.loop	lda.l	Lgamemode_idxjmp&0ff0000h,x
	and	#00ffh
	cmp	kw_GameMode
	beq	.entry
	inx
	inx
	inx
	dey
	bne	.loop
	rts
.entry	jmp	(1,x)

;====================================================================
;====================================================================
;	gamobj END 
;====================================================================
;====================================================================
;;
;;
;;
;;
;;
;;
;*********************************************************************
;	----------------------------
;	* game parameter initalize *
;	----------------------------
;*********************************************************************
;
; clear game parameter 	
;
;    -------------------------------------------	
;     map initial yori mo mae de okonau koto !!
;    -------------------------------------------
;
;---------------------------------------------------------------------

yjparam_gamemode_table
	Mgamemode_liststart
	Mgamemode_list	kmode_initmission,yjparam_game
	Mgamemode_list	kmode_title,yjparam_title
	Mgamemode_list	kmode_missionexplain,yjparam_explain
	Mgamemode_list	kmode_playerdown,yjparam_gameover
	Mgamemode_listend	yjparam_tabletotal

;---------------------------------------------------------------------

clear_YJgameparam_l
	Mbank7e
	php
	ai16

	jsr	clear_triggermessage	; trigger all clear !!

	stz	pepper_message		; now messageNo clear !!
	stz	gameclear_flag		; gameclear OFF

	lda	#0			; raster parameter
	sta.l	raster_control		; control OFF
	ldx	#4
.loop	sta.l	raster_amp,x
	sta.l	raster_freq,x
	sta.l	raster_speed,x
	sta.l	raster_counter,x
	dex
	dex
	bpl	.loop

	lda	#0
	sta.l	raster_chart
	sta.l	raster_timer

;-------------------------------------------------------------

	ldx	#yjparam_gamemode_table&WM
	ldy	#yjparam_tabletotal&WM
	jsr	Lgamemode_idxjmp

;-------------------------------------------------------------
	plp
	Mbankrtl

;--------------------------------------------------------------------
;
;********************************************************************
;	[continue]
;********************************************************************
;********************************************************************
;	[gameover]
;********************************************************************
yjparam_continue
yjparam_gameover
;;;;;	lda	#idx_reset_raster
;;;;;	sta.l	raster_control
	rts

;********************************************************************
;	[title]
;********************************************************************
yjparam_title
	rts

;********************************************************************
;	[explain]
;********************************************************************
yjparam_explain
	lda	#idx_explain_raster
	sta.l	raster_control
	rts

;********************************************************************
;	[battle]
;********************************************************************
yjparam_battle
	rts

;********************************************************************
;	[game]
;********************************************************************
yjparam_game
	lda.l	KGameMapPtr
	cmp	#(mapraster_end-mapraster_table)
	bcs	.exit
	tax
	lda.l	mapraster_table,x
	and	#0ffh
	sta.l	raster_control
.exit	rts
;---------------------------------------------------------------------
mapraster_table
	db	idx_no_raster	; (00) planet 0
	db	idx_no_raster	; (01) planet 1
	db	idx_no_raster   ; (02) planet 2
 	db	idx_no_raster 	; (03) planet 3
	db	idx_no_raster   ; (04) planet 4
	db	idx_sea_raster  ; (05) planet 5
	db	idx_no_raster   ; (06) planet 6
mapraster_end equ	*

;********************************************************************
;	[LIBRARY]	game initialize
;********************************************************************

;----------------
; message init
;----------------
clear_gamemessage
	lda	#0
	sta.l	pepper_message

	rts


;********************************************************************
;
;	<< FIRE >> raster program
;
; DBR = 7F
;
;********************************************************************

calc_fireraster_l


	rtl

;********************************************************************
;
;	<< BOSS >> raster program
;
; DBR = 7F
;
;********************************************************************

calc_bossraster_l


;;	Mdebugkeymove	raster_freq,1,cont1,L,R,X
;;	Mdebugkeymove	raster_speed,1,cont1,left,right,X


	lda	raster_chart
	asl	a
	tax
	jsr	(.process,x)


	rtl

.process	Mindexliststart
	Mindexlist	bossraster_init		; initialize
	Mindexlist	bossraster_demo1	; demo part(1)
	Mindexlist	bossraster_demo2	; demo part(2)
	Mindexlist	bossraster_demo3	; return


;====================================================================

;--------------------------------------------
bossraster_init

; Set V Raster ------------------------------
	lda	#20h
	sta	raster_amp+2	
	lda	#8
	sta	raster_freq+2
	lda	#0fh
	sta	raster_speed+2
; Set H Raster ------------------------------
	lda	#0fh
	sta	raster_speed
	lda	#0fch
	sta	raster_freq
	stz	raster_amp

	jmp	calcraster_next

;--------------------------------------------
bossraster_demo1

;;;;	Mdebugkeymove    raster_amp,1,cont1,A,B,X
;;;;	Mdebugkeymove	raster_freq,1,cont1,L,R,X

	lda	raster_timer
	bit	#80h
	beq	.skip
	eor	#7fh
.skip	and	#7fh
	lsr	a
	sta	raster_amp

	lda	#400h
	jmp	calcraster_wait

;--------------------------------------------
bossraster_demo2

	lda	raster_timer
	bit	#80h
	beq	.skipV
	eor	#7fh
.skipV	and	#7fh
	clc
	adc	#20h
	sta	raster_amp+2	

	lda	#100h
	jmp	calcraster_wait

;--------------------------------------------
bossraster_demo3
	stz	raster_chart
	jmp	bossraster_init

;====================================================================




;--------------------------------------------
calcraster_wait
	inc	raster_timer
	cmp	raster_timer
	bcs	calcraster_exit
calcraster_next
	stz	raster_timer
	inc	raster_chart
calcraster_exit
	rts
;--------------------------------------------
calcraster_jmp
	sta	raster_chart
	stz	raster_timer
	rts
;--------------------------------------------
calcraster_loop
	inc	raster_timer
	rts

;********************************************************************
;
; Clear ALL raster buffer
;
;********************************************************************

Clear_ALLraster_buffer_l

	Mbankprog
	php
	ai16


	lda	#idx_no_raster
	sta.l	raster_control

	ldx	#0
	lda	#0			; Vscroll Buffer ALLclear
.loop	sta.l	xh_yajiVtbl1_buf1,x
	sta.l	xh_yajiVtbl2_buf1,x
	sta.l	xh_yajiVtbl1_buf2,x
	sta.l	xh_yajiVtbl2_buf2,x
	inx
	inx
	cpx	#(bitmapvheight)*8*2
	bne	.loop

	plp
	Mbankrtl

;====================================================================
;====================================================================
; END END END END END END END END END END END END END END END END END
;====================================================================
;====================================================================
































