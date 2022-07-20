nintendo_c_waittime	equ	10
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: titleobj.asm				*
;* 	Description	: title oamset program			*
;*	Date		: 1994.12.15				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;;;;; cf	printf	"length = ",*-label,"%n"
;---------------------------------------------------------------------
;
;
;
;
;---------------------------------------------------------------------
	INCPUB	titleobj
;---------------------------------------------------------------------
BLACKcolor_message	equ	09h
WHITEcolor_message	equ	0eh
REDfrash_message	equ	10h
BLUEfrash_message	equ	11h
Xfrash_message	equ	12h
expert_message	equ	0bh
;---------------------------------------------------------------------

;*********************************************************************
;	labels
;*********************************************************************

objfaceposH		equ	79h+2
objfaceposV		equ	6eh+08h

objnintendoposH	equ	0b8h
objnintendoposV	equ	0cdh

objstartposH		equ	040h+8
objstartposV		equ	objnintendoposV

objplanetposH	equ	0c0h+10h
objplanetposV	equ	0b0h


;*********************************************************************
;	macros
;*********************************************************************

;---------------------------------------------------------------------
Mdc_set	macro	[addr,data]
	lda	#{data}
	sta	{addr},x
	endm

;---------------------------------------------------------------------

;*********************************************************************
;	memory 
;*********************************************************************

titlestruct		equ	bgdemo_switch

_dc_titleselect	equ	_dcwork+0
_dc_nintendo_c	equ	_dcwork+2

disp_faceonly	equ	1
disp_titleselect	equ	20h


;*********************************************************************
;	parameters
;*********************************************************************

;--------------------------------------------------------------------
; 	main-select
;--------------------------------------------------------------------

	ifne	debuginfo
titleselect_size	equ	12
titleselect_pX	equ	50h
titleselect_pY1	equ	4eh+titleselect_size*0
	elseif
titleselect_size	equ	14
titleselect_pX	equ	50h
titleselect_pY1	equ	57h+titleselect_size*0
	endc

titleselect_pY2	equ	titleselect_pY1+titleselect_size*1
titleselect_pY3	equ	titleselect_pY1+titleselect_size*2
titleselect_pY4	equ	titleselect_pY1+titleselect_size*3
titleselect_pY5	equ	titleselect_pY1+titleselect_size*4

;--------------------------------------------------------------------
; 	mission level select
;--------------------------------------------------------------------

missionselect_pX	equ	titleselect_pX 
missionselect_size	equ	titleselect_size
missionselect_pY1	equ	titleselect_pY1+missionselect_size*0
missionselect_pY2	equ	missionselect_pY1+missionselect_size*1
missionselect_pY3	equ	missionselect_pY1+missionselect_size*2

;--------------------------------------------------------------------
;
;
;
;
;
;
;
;--------------------------------------------------------------------
mtable_destroy	equ	84
mtable_outof		equ	85
mtable_mes		equ	86
mtable_cdamage	equ	87
mtable_score		equ	88
mtable_percent	equ	89
;---------------------------------------------------------------------
tmd_partnercontinue	equ	90
tmd_yes		equ	91
tmd_no		equ	92
tmd_retry		equ	93		;(old data)159
tmd_title		equ	94	
tmd_mission		equ	95	
tmd_battle		equ	96	
tmd_test		equ	97
tmd_traning		equ	98
tmd_config		equ	99
tmd_stereo		equ	100
tmd_mono		equ	101
tmd_easy		equ	102
tmd_normal		equ	103
tmd_hard		equ	104
tmd_ground		equ	105
tmd_space		equ	106
tmd_room		equ	107
;--------------------------------------------------------------------
tmd_cursor		equ	108
;--------------------------------------------------------------------







;=====================================================================
;
;
;
;
;*********************************************************************
;	title obj program
;*********************************************************************


Init_titleobj_l
	Mbankprog
	php
	a8
	storenasty
	ramnastyoff
	ai16

	stz	titlerogo_flag

	lda	#0
	sta.l	titlestarcolor_fade
	lda	#0
	sta.l	backup_writeflag
	lda	#0
	sta.l	m_titlefacedisp


	ldx	#titlestruct
	lda	#idx_titleobj_startdemo	
	jsr	Init_pstruct

	jsr	Init_objlist		; Object Initalize

	a8
	restorenasty
	plp
	Mbankrtl

;-----------------------------
	longa
;-----------------------------
;
;
;
;
;
;
;*********************************************************************
;	Initset Structure
;*********************************************************************
Init_pstruct
	sta	_dcinput,x
	stz	_dcwork+0,x
	stz	_dcwork+2,x
	stz	_dcwork+4,x
	rts

;*********************************************************************
        ;	title obj program
;*********************************************************************

Main_titleobj_l
	Mbankprog
	php
	a8
	storenasty
	ramnastyoff
	ai16
	sty	sprite_register

	inc	yj_framecounter
	jsr	titleobj_main

	ldy	sprite_register
	a8
	restorenasty
	plp
	Mbankrtl

;-----------------------------
	longa
;-----------------------------

;*********************************************************************
;	title obj program
;*********************************************************************

titleobj_main

	ldx	#titlestruct
	stx	dcregister
	jsr	dc_select
	Mindexliststart	
	Mindexlist	titleobj_exit
	Mindexlist	titleobj_startdemo
	Mindexlist	titleobj_startwait


;*********************************************************************
;	-----------------------
;	 titleobj key wait
;	-----------------------
;*********************************************************************
titleobj_startwait
	jsr	starcolor_anime2
	jsr	.entry		; timechart program
	jsr	Main_OBJ	; allways program
	rts

.entry	jsr	dc_program
	dwnext	startwait_X
	dwnext	startwait_1
	dwnext	startwait_2
	dwflag	startwait_3
	dwstop	startwait_4

;-------------------------------------------------------
;	initialize
;-------------------------------------------------------
startwait_X
	A8
	kbgm	stg2
	A16
	lda	#28h
	sta.l	m_titlefacedisp
	rts

;-------------------------------------------------------
startwait_1
	tyx
	Mdc_set	_dc_titleselect,disp_faceonly	; BG(Polygon)face Display

	rts

;-------------------------------------------------------
startwait_2
	jsr	disp_facecolor
	jsr	disp_titlecolor
	jsr	Init_objlist
	Mobjinit 0,ys_titleplanet,obj_commonprog,objplanetposH,objplanetposV
	Mobjinit 1,ys_titleface,obj_commonprog,objfaceposH,objfaceposV
	Mobjinit 3,ys_titlenintendo,obj_commonprog,objnintendoposH,objnintendoposV
	rts

;-------------------------------------------------------
;	nintendo(c)	wait time
;-------------------------------------------------------
startwait_3	tyx
	lda	_dc_nintendo_c,x
	bne	.next

	lda	_dccounter,x
	cmp	#nintendo_c_waittime
	bcc	.exit

.next	dec	_dcflag,x

.exit	rts
	
;-------------------------------------------------------
;	mission select mode ( message bitmap )
;-------------------------------------------------------
startwait_4
	tyx
	Mdc_set	_dc_titleselect,disp_titleselect

	rts

;-------------------------------------------------------




;*********************************************************************
;	-----------------------
;	 titleobj exit
;	-----------------------
;*********************************************************************
titleobj_exit	
	rts


;*********************************************************************
;	-----------------------
;	 titleobj demo program
;	-----------------------
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
;	planet object program
;---------------------------------------------------------------------
obj_planet_posset
	Mobjindex	0

	lda	player1hscroll
	Mnegative

	clc
	adc	#300h+objplanetposH
	and	#3ffh
	sta	_axisX,x

	lda	player1vscroll
	Mnegative
	clc
	adc	#80h+objplanetposV
	sta	_axisY,x

	rts


;---------------------------------------------------------------------
;	titledemo part(2)  program
;---------------------------------------------------------------------
titleobj_startdemo
	jsr	starcolor_anime		; color animarion
	jsr	.entry
	jsr	obj_planet_posset	; planet positin set
	jsr	Main_OBJ		; sprite set !!
	rts

.entry	jsr	dc_program
	dwnext	titleobj_planetinit	 ; planet move
	dwflag	titleobj_triggercheck	 ; trigger wait
	dwnext	titleobj_faceinit	 ; face open 
	dwnext	titleobj_bgmstart	 ; BGM start !
	dwloop	21h,titleobj_facemove	 ; face move animation
	dwloop	21h,titleobj_rogoset	 ; title rogo set
	dwnext	titleobj_messageinit	 ; push/start message
	dwloop	12,titleobj_messageloop	 ; message wait loop
	dwloop	15,titleobj_facedispstart ; BGface start
	dwnext	titleobj_nintendo_waitend ; nintendo wait end 
	dwloop	20,titleobj_endwait
	dwnext	titleobj_pushstart
	dwloop	120,titleobj_endwait	 ; openning end wait
	dwloop	120,titleobj_endwait	 ; openning end wait
	dwloop	120,titleobj_endwait	 ; openning end wait
	dwloop	120,titleobj_endwait	 ; openning end wait
	dwstop	titleobj_return		 ; restart title DEMO

;---------------------------------------------------------------------
;	Set planet Object !!
;---------------------------------------------------------------------
titleobj_planetinit
	Mobjinit 0,ys_titleplanet,obj_planetprog,80h,0b0h
	rts

;---------------------------------------------------------------------
;	Polygon Demo End Wait !!
;---------------------------------------------------------------------
titleobj_triggercheck
	lda	titlerogo_flag
	beq	.exit
	ldx	dcregister
	dec	_dcflag,x
.exit	rts

;---------------------------------------------------------------------
;	Face Object Initiailze
;---------------------------------------------------------------------
titleobj_faceinit
	Mobjinit 1,ys_titleface,obj_faceprog,objfaceposH,objfaceposV
	jmp	set_facecolor

;---------------------------------------------------------------------
;	BGM start timming
;---------------------------------------------------------------------
titleobj_bgmstart
	a8
	kbgm	stg2
	A16
	rts
;---------------------------------------------------------------------
;	Face Color Add Animation
;---------------------------------------------------------------------
titleobj_facemove
	jmp	set_facecolor

;---------------------------------------------------------------------
;	TitleROGO Color Animarion
;---------------------------------------------------------------------
titleobj_rogoset
	jmp	set_titlecolor

;---------------------------------------------------------------------
;	nintendo(c) init
;---------------------------------------------------------------------
titleobj_messageinit
	Mobjinit 3,ys_titlenintendo,obj_nintendoprog,objnintendoposH,objnintendoposV
	rts

;---------------------------------------------------------------------
;	nintendo titleobj  wait
;---------------------------------------------------------------------
titleobj_messageloop
	rts

;---------------------------------------------------------------------
;	titleobj dace
;---------------------------------------------------------------------
titleobj_facedispstart
	tyx
	Mdc_set	_dc_titleselect,disp_faceonly

	rts

;---------------------------------------------------------------------
;	nintendo wait end
;---------------------------------------------------------------------
titleobj_nintendo_waitend
	tyx
	Mdc_set	_dc_nintendo_c,0ffffh
	rts

;---------------------------------------------------------------------
;	pushstart object set
;---------------------------------------------------------------------
titleobj_pushstart
	Mobjinit 2,ys_titlestart,obj_startprog,objstartposH,objstartposV
	rts

;---------------------------------------------------------------------
;	nintendo disp wait loop
;---------------------------------------------------------------------
titleobj_endwait
	rts

;---------------------------------------------------------------------
;	title end demo return
;---------------------------------------------------------------------
titleobj_return
	inc	tiw_returndemo	
	rts

;---------------------------------------------------------------------
;---------------------------------------------------------------------
;;;
;;;
;;;
;;;
;;;
;;;
;*********************************************************************
;	sprite program
;*********************************************************************
obj_faceprog
obj_startprog

	jmp	Newoamset

;--------------------------------------------------------------------
obj_nintendoprog
	ldx	register
	lda	_objlimit,x
	inc	a
	cmp	#20
	bcs	.skip
	sta	_objlimit,x
.skip
	jmp	Newoamset

;--------------------------------------------------------------------
obj_planetprog
obj_commonprog
	jmp	Newoamset

;--------------------------------------------------------------------












;*********************************************************************
;	title color
;*********************************************************************

cgadd_count	equ	Xwork0
Rwork	equ	Xwork1
Gwork	equ	Xwork2
Bwork	equ	Xwork3
cgadd_ptn	equ	Xwork4

;---------------------------------------------------------------------
disp_facecolor
	lda	#1fh
	bra	disp_facecolor_entry

set_facecolor

	lda.l	medal_clear
	beq	.entry
	lda	#0ffffh
	sta.l	titlestarcolor_fade

.entry	

	ldx	dcregister
	lda	_dccounter,x
	cmp	#20h
	bcs	exit_set_facecolor

disp_facecolor_entry
	sta	cgadd_ptn
	lda	#8
	sta	cgadd_count

	ldy	#title_facecolor&WM
	ldx	#1e0h
	jsr	cgadd_anime

exit_set_facecolor
	rts

;---------------------------------------------------------------------
disp_titlecolor
	lda	#1fh
	bra	disp_titlecolor_entry

set_titlecolor
	ldx	dcregister
	lda	_dccounter,x
	cmp	#20h
	bcs	exit_set_titlecolor

disp_titlecolor_entry
	sta	cgadd_ptn
	lda	#20h
	sta	cgadd_count

	ldy	#title_rogocolor&WM
	ldx	#0
	jsr	cgadd_anime

exit_set_titlecolor
	rts

;---------------------------------------------------------------------

;---------------------------------------------------------------------
starcolor_anime



	lda.l	titlestarcolor_fade
	beq	.entry

;==================================================

	lda.l	starcolor_data
	dec	a
	bne	starcolor_super

	rts

;==================================================

.entry

	lda	yj_framecounter
	bit	#010h
	bne	.skip
	eor	#00fh
.skip	and	#00fh
	tax
	lda.l	star_animedata,x	


;--------------------------------------------
starcolor_super

	and	#00ffh
	sta	cgadd_ptn
	sta.l	starcolor_data

	lda	#8
	sta	cgadd_count

	ldy	#title_starcolor&WM
	ldx	#80h
	jsr	cgadd_anime

	rts

;---------------------------------------------------------------------
star_animedata	
	;--------0---1---2---3--
	db	1fh,1fh,1fh,1eh,1dh
	db	1ch,1bh,1ah,19h
	db	18h,17h,16h,15h
	db	14h,13h,12h
;---------------------------------------------------------------------
starcolor_anime2

	lda.l	medal_clear
	beq	.entry
	lda.l	starcolor_data
	dec	a
	bmi	.exit
	beq	.exit
	jmp	starcolor_super

.entry	lda.l	starcolor_data
	cmp	#12h
	bne	starcolor_anime
.exit	rts


;---------------------------------------------------------------------

;*********************************************************************
;	--------------------
;	 change color datas
;	--------------------
;*********************************************************************

title_starcolor
	dw	0
	dw	7ffah
	dw	7f07h
	dw	7e07h
	dw	7084h
	dw	4c00h
	dw	2c00h
	dw	2000h

;----------------------------------------------------------------------
title_facecolor
;;	dw	0
;;	dw	7ffah
;;	dw	7f07h
;;	dw	7e07h
;;	dw	7084h
;;	dw	4c00h
;;	dw	3000h
;;	dw	0000h
;;	dw	7fffh

	dw	0
	dw	7ffah
	dw	7fe7h
	dw	7f07h
	dw	7e07h
	dw	7084h
	dw	4c00h
	dw	3000h
	dw	7fffh







;----------------------------------------------------------------------
title_rogocolor

	dw	0
	dw	2b9eh
	dw	3a58h
	dw	4912h
	dw	490dh
	dw	4508h
	dw	7fffh
	dw	7fffh
	dw	7fffh
	dw	7fffh
	dw	4508h
	dw	7fffh
	dw	6bb9h
	dw	5f36h
	dw	4eb2h
	dw	0000h

	dw	00000H
	dw	0373FH
	dw	03E59H
	dw	04952H
	dw	048EDH
	dw	04887H
	dw	02444H
	dw	014bfh
	dw	07FFFH
	dw	07FFFH
	dw	07FFFH
	dw	07FFFH
	dw	07FFFH
	dw	07FFFH
	dw	07fffh
	dw	0

;*********************************************************************
;	--------------------
;	 color copy program
;	--------------------
;*********************************************************************
;
; (A)-reg	color change count
; (X)-reg	color buffer pointer
; (Y)-reg	ROM address
;
; data-bank	ROM bank
;
;---------------------------------------------------------------------

copy_colorbuff

	sta	cgadd_count
.loop	lda.w	0,y
	sta.l	kx_palette,x
	inx
	inx
	iny
	iny
	dec	cgadd_count
	bne	.loop
	rts

;*********************************************************************
;	-----------------------------
;	 test color addition program
;	-----------------------------
;*********************************************************************
;
; (A)-reg	color change count
; (X)-reg	color buffer pointer
; (Y)-reg	ROM address
;
; data-bank	ROM bank
;
;---------------------------------------------------------------------
;
;
;---------------------fedcba9876543210---
Rmask	equ	00000000000011111b
Gmask	equ	00000001111100000b
Bmask	equ	00111110000000000b
;---------------------------------------------------------------------
;Mtitle_coloradd macro [mask,add,work]
;	lda.l	kx_palette,x
;	and	#{mask}
;	cmp	{work}
;	bcs	.set\@
;	adc	#{add}	; clc
;.set\@	sta	{work}
;	endm
;---------------------------------------------------------------------
Mgreen_lsr	macro
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	endm

;---------------------------------------------------------------------
Mgreen_asl	macro
	asl	a
	asl	a
	asl	a
	asl	a
	asl	a
	endm

;---------------------------------------------------------------------
Mblue_lsr	macro
	xba
	lsr	a
	lsr	a
	endm

;---------------------------------------------------------------------
Mblue_asl	macro
	asl	a
	asl	a
	xba
	endm

;---------------------------------------------------------------------
cgadd_anime
.loop
	lda.w	0,y
	and	#Rmask
	jsr	cgadd_calc
	sta	Rwork

	lda.w	0,y
	and	#Gmask
	Mgreen_lsr		; ->
	jsr	cgadd_calc
	Mgreen_asl		; <-
	sta	Gwork

	lda.w	0,y
	and	#Bmask
	Mblue_lsr		; ->
	jsr	cgadd_calc
	Mblue_asl		; <-
	sta	Bwork

	lda	Rwork
	ora	Gwork
	ora	Bwork
	sta.l	kx_palette,x

	iny
	iny
	inx
	inx
	dec	cgadd_count
	bne	.loop	

	rts

;*********************************************************************
;	color animation
;*********************************************************************
;;
;;	color * time / 32
;;
;;--------------------------------------------------------------------

cgadd_calc
	a8
	sta	XMultiplicand		; 00 - 1F
	lda	cgadd_ptn
	sta	XMultiplier
	a16
	nop
	nop
	nop
	lda	Xproduct
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	rts

;====================================================================
;;
;;
;;
;;
;;
;*********************************************************************
;	----------------------
;	 BITMAP PROGRAM TITLE
;	----------------------
;*********************************************************************
;;
;;
;;
;;
;;
;;
;;
;;
;;
;*********************************************************************
;		*************************************************
; demo TITLE		*************************************************
;		*************************************************
;*********************************************************************
;;
;; Bitmap ONscreen Program !!
;;
;;--------------------------------------------------------------------

bitmapdemo_title

	a8
	poll_mario
	a16

	ldx	#titlestruct
	lda	_dc_titleselect,x
	beq	.init

	lda.l	key_tateptr1
	sta.l	m_titlecursor	;;;;; SET CURSOR

	lda.l	tiw_sprmode
	beq	.face		;;;;; 0 ... face
	dec	a		;;;;; 1 ... title2 (wait2)
	bne	.selectmode

	lda	_dc_titleselect,x
	cmp	#10h
	bcs	.title1
	bcc	.face

.selectmode
	lda.l	tiw_gamemode	;;;;; mode check
	beq	.mission

;--------------------------------------------------------------------
; battle select screen
;--------------------------------------------------------------------
.battle	ldx	#bitmapmes_missionselect&WM
	bra	.set

;--------------------------------------------------------------------
; mission select screen
;--------------------------------------------------------------------
.mission	
	jsr	SelectExpert
	bra	.set

;--------------------------------------------------------------------
; title main select
;--------------------------------------------------------------------
.title1	
	ldx	#bitmapmes_titleselect&WM
.set	jsr	Draw_bitmapmessage
	lda	#28h
	sta.l	m_titlefacedisp

	ldx	#bitmapmes_titlecursor&WM
	jsr	Draw_bitmapmessage

;--------------------------------------------------------------------
.face
	lda.l	m_titlefacedisp	
	cmp	#28h
	bcs	.skip1
	inc	a
	sta.l	m_titlefacedisp

.skip1
	call_mario	mtitleface

	bra	.exit

;--------------------------------------------------------------------
.init
.exit
	a8
	unpoll_mario
	a16

	rts




;*********************************************************************
;;
;;	Select Expert ModeCheck
;;
;;	1995/7/27	changed
;;
;*********************************************************************

SelectExpert

	a8
	storenasty
	ramnastyoff
	a16

	ldx	#bitmapmes_missionselect_disableexpert&WM
	lda.l	m_backupflags
	and	#backupflag_expert
	IFEQ	EXPERTBYDEFAULT
	beq	.skip111
	ENDC
	ldx	#bitmapmes_missionselect&WM
.skip111

	a8
	restorenasty
	a16

	rts

;*********************************************************************
;	title cursor program
;*********************************************************************

bitmapmes_titlecursor

	Mscore_start65816
		lda.l	m_titlecursor
		ora	#titleselect_size*256
		jsr	mult_u8u8
		clc
		adc	#titleselect_pY1
		sta.l	m_y1
		lda	#titleselect_pX-10
		sta.l	m_x1
	Mscore_end65816

	Mscore_setcolor		REDfrash
	Mscore_dispmessageonly	tmd_cursor
	Mscore_exit

;*********************************************************************
;	title select bitmap message
;*********************************************************************

bitmapmes_titleselect

	Mscore_messageINIT

	Mscore_setcolor		WHITEcolor
	Mscore_setB_m_xy	titleselect_pX,titleselect_pY1
	Mscore_setcursorcolor2	key_tateptr1,0
	Mscore_dispmessageonly	tmd_mission
	Mscore_setB_m_xy	titleselect_pX,titleselect_pY2
	Mscore_setcursorcolor2	key_tateptr1,1
	Mscore_dispmessageonly	tmd_battle

;-------------------------------------------------------------------

	Mscore_setB_m_xy	titleselect_pX,titleselect_pY3
	Mscore_setcursorcolor2	key_tateptr1,2
	Mscore_start65816
		lda	key_yokoptr1	; 0 OR 1    
		and	#00ffh
		clc
		adc	#tmd_stereo
		sta	yajima_temp
	Mscore_end65816
	Mscore_dispmessagework	yajima_temp

;-------------------------------------------------------------------
	ifne	debuginfo

	Mscore_setB_m_xy	titleselect_pX,titleselect_pY4
	Mscore_setcursorcolor2	key_tateptr1,3
	Mscore_dispmessageonly	tmd_test
	Mscore_setB_m_xy	titleselect_pX,titleselect_pY5
	Mscore_setcursorcolor2	key_tateptr1,4
	Mscore_dispmessageonly	tmd_traning

;;;;	Mscore_setB_m_xy	titleselect_pX,titleselect_pY5
;;;;	Mscore_setcursorcolor2	key_tateptr1,4
;;;;	Mscore_dispmessageonly	tmd_config

	endc
;-------------------------------------------------------------------

	Mscore_exit


;*********************************************************************
;	mission select bitmap message
;*********************************************************************

bitmapmes_missionselect
	
	Mscore_messageINIT

	Mscore_setcolor		WHITEcolor
	Mscore_setB_m_xy	missionselect_pX,missionselect_pY1
	Mscore_setcursorcolor2	key_tateptr1,0
	Mscore_dispmessageonly	tmd_easy
	Mscore_setB_m_xy	missionselect_pX,missionselect_pY2
	Mscore_setcursorcolor2	key_tateptr1,1
	Mscore_dispmessageonly	tmd_normal
	Mscore_setB_m_xy	missionselect_pX,missionselect_pY3
	Mscore_setcursorcolor2	key_tateptr1,2
	Mscore_dispmessageonly	tmd_hard

	Mscore_exit



bitmapmes_missionselect_disableexpert
	
	Mscore_messageINIT

	Mscore_setcolor		WHITEcolor
	Mscore_setB_m_xy	missionselect_pX,missionselect_pY1
	Mscore_setcursorcolor2	key_tateptr1,0
	Mscore_dispmessageonly	tmd_easy
	Mscore_setB_m_xy	missionselect_pX,missionselect_pY2
	Mscore_setcursorcolor2	key_tateptr1,1
	Mscore_dispmessageonly	tmd_normal

	Mscore_setB_m_xy	missionselect_pX,missionselect_pY3
	Mscore_setcolor		expert
	Mscore_dispmessageonly	tmd_hard

	Mscore_exit


;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
