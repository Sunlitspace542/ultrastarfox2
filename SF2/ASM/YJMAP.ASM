;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: yjmap.asm				*
;* 	Description	: mission map screen 			*
;*	Date		: 1994.10.12				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
	incpub	yjmap
;
;
;
;
;
;*********************************************************************
;	-------
;	 flags
;	-------
;*********************************************************************
;----------------------------------------------------------------------
;	flags
;----------------------------------------------------------------------
TGmessage_speedup	equ	08000h
LVmessage_speedup	equ	04000h
ALLmessage_speedup	equ	TGmessage_speedup+LVmessage_speedup
mapmessage_planetinit equ	0ffffh

;----------------------------------------------------------------------
;	flags
;----------------------------------------------------------------------
OFF_nextobj		equ	-1
ON_nextobj		equ	0


ON_demomessage	equ	-1
OFF_demomessage	equ	0
OFF_mapmessage	equ	0

;*********************************************************************
;	----------------
;	 Map Parameters
;	----------------
;*********************************************************************

;---------------------------------------------------------------------
; 	times
;---------------------------------------------------------------------

TIME_demomessage	equ	127	; demomessage MAX time
TIME_mapmessage	equ	33	; mapmessage display time

;---------------------------------------------------------------------
; 	mapmessage face&scroll POSITION
;---------------------------------------------------------------------
;;nextobj_positon		look mapanime.asm

faceobjposH_entry		equ	00068h+7bh-0ch ; dx_vram
faceobjposV_down		equ	0c700h         ; screen OBJ position
faceobjposV_up		equ	0c700h-0a000h  ; position up
message_scrollpos_down 	equ	0f4h
message_scrollpos_up		equ	0f4h-060h

message_change_updown 	equ	90h	; up/down change OBJ position

;---------------------------------------------------------------------
; 	VRAM 
;---------------------------------------------------------------------
mapdraw_startNo	equ	00100h	 ;draw start char+attr

;---------------------------------------------------------------------
; 	MAP	face draw screen
;---------------------------------------------------------------------
facedraw_vram	equ	mm_bg1_scr+2abh+4+11-1
facedraw_charNo	equ	1+mapdraw_startNo
facedraw_Vadd	equ	1
facedraw_Hadd	equ	16
facedraw_Vloop	equ	6
facedraw_Hloop	equ	5

;---------------------------------------------------------------------
; 	MAP	3gyou message VRAM address
;---------------------------------------------------------------------
dx_vram		equ	mm_bg1_scr+28fh-5-1
dx_charNo		equ	8+mapdraw_startNo
dx_Vadd		equ	1
dx_Hadd		equ	16
dx_Vloop		equ	7
dx_Hloop		equ	16


;*********************************************************************
;	-----------------------------
;	 MISSION MAP INITIAL PROGRAM
;	-----------------------------
;*********************************************************************
yjmapinit_l	
	Mbank7e
	php
	ai16

	lda	#0ffh			; 	
	sta.l	Kenemy_backup

	stz	mapicon_flag		; iconflag OFF;
	stz	mapexp_kawaflag
	stz	mapexp_messageskipflag	; skip reset
	
	MsetL	m_mapBG1scrollY,0	; scroll Reset !!
	Mset	yajirushi_flag,OFF_enemyyaji

	jsr	init_mapmessage_mode	; set   mode(demo/main)



	jsr	init_mapmessageVRAM	; set   VRAM
	jsr	init_mapmessage		; init  messageparameter
	jsr	clear_messageparam	; clear message
	jsr	clear_triggermessage	; clear trigger bit

	jsr	Set_mapexp_pointer	; mapexp_poitner


	plp
	Mbankrtl


;*********************************************************************
;	--------------------------
;	 MISSION MAP MAIN PROGRAM
;	--------------------------
;*********************************************************************
yjmapmain_l

	Mbank7e
	php	; >>
	ai16

;-------------------------------------------------------
	ifne	AFdebugmode_mapmessageON
	jsr	debugmode_mapmessage
	endc
;-------------------------------------------------------

	jsr	set_yjmap_parameter	; START PARAMETER SET
					; MODE CHECK


	km_bitcheckmismapflag	corneriafell
	bne	.fell

	lda.l	m_mapmessage_mode	; demo mode ?
	bne	.skip
	lda	mapexp_demoflag		; demo message ?
	bne	.skip

.fell
	jsr	check_mapmessage

.skip
	jsr	expdemo_main	

	stz	gameframe_trigger	; gameframe_trigger

	plp
	Mbankrtl

;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
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
;####################################################################
;####################################################################
;	
;------------ INITALIZE (SUB) ---------------------------------------
;
;####################################################################
;####################################################################

Set_mapexp_pointer

	km_bitcheckmistotalflag	explain1
	beq	.exit

	lda	#mapexp_openning&WM
	sta	mapexp_pointer

.exit	rts


;*********************************************************************
;	initialize mapmessage mode
;*********************************************************************

init_mapmessage_mode

	ldx	#-1				; demo mode
	km_bitcheckmistotalflag	explain1
	bne	.setmode
	km_bitcheckmismapstflag	finalbosstrig
	bne	.setmode
	ldx	#0				; normal mode
.setmode	txa
	sta.l	m_mapmessage_mode

	rts

;*********************************************************************
;	map message initialize
;*********************************************************************

init_mapmessage

	stz	mapexp_linecheck	; 3gyou initialize

	stz	mapexp_demoflag
	stz	mapexp_planettimer	; RESET planet timer
	stz	mapexp_planetlist	; RESET planet list
	stz	gameframe_trigger	; RESET trigger

	stz	mapexp_nextobj		; RESET nextobj
	lda	#0
	sta.l	m_mapmessage_faceflag	; RESET faceflag
	sta.l	m_mapBG1scrollY		; RESET scroll
	sta.l	m_mapmessage_counter	; RESET counter
	lda	#mapmessage_blackcolor	; RESET color
	sta.l	m_mapmessage_color	;
	stz	mapexp_objNo	   	; RESET Yajirushi OBJ

	lda	faceobj_initpos		; INIT  faceobj position
	ora	#faceobjposV_down
	sta	faceobj_position

	MsetL	m_messagetimer,TIME_mapmessage

	stz	mapexp_pointer


	lda.l	m_mapmessage_mode	; demomode ?
	beq	.exit

	MsetL	m_messagetimer,TIME_demomessage

.exit

	rts

;*********************************************************************
; 	clear trigger message
;*********************************************************************

clear_triggermessage
	stz	double_message+0	; double 
	stz	double_message+2
	stz	map_trigmessage
	stz	mmx_message_sos		; trigger message OFF
	stz	mmx_planet_stepup
	stz	mmx_sosappear
	stz	pepper_message
	lda	#0
	sta.l	m_mapmessageNo		; check message number
	rts


;*********************************************************************
; 	<<<<< Map Screen Message Initialize >>>>>
;*********************************************************************

clear_messageparam

	stz	mapmessage_messagestatus ; <<< clear flag >>>
	stz	openface_count		 ; <<< face initial >>>
	stz	closeface_count

	stz	pepper_message		 ; <<< trigger initial >>>
	MsetL	m_mapmessageNo,0	 ; <<< message clear >>>>

	rts

;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;;
;;
;;
;;
;*********************************************************************
; 	message & face VRAM initialize
;*********************************************************************
Msetbox	macro	[vram,char,Hloop,Vloop,Hadd,Vadd]
	jsr	Msetboxcall
	dw	{vram}
	dw	{char}
	dw	{Hloop}
	dw	{Vloop}
	dw	{Hadd}
	dw	{Vadd}
	endm

;=====================================================================

init_mapmessageVRAM

	Mbankprog

	Msetbox	dx_vram,dx_charNO,dx_Hloop,dx_Vloop,dx_Hadd,dx_Vadd
	Msetbox	facedraw_vram,facedraw_charNO,facedraw_Hloop,facedraw_Vloop,facedraw_Hadd,facedraw_Vadd
	lda	#faceobjposH_entry
	sta.l	faceobj_initpos

	Mbankrts


;-----------	library's -----------------------------------------------
;
;*********************************************************************
;	BOX FILL PROGRAM
;*********************************************************************
setbox_vramaddr	equ	Xwork0
setbox_charNo	equ	Xwork1
setbox_Vloop		equ	Xwork2
setbox_Hadd		equ	Xwork3
setbox_Vadd		equ	Xwork4
setbox_counter	equ	Xwork5
;----------------------------------------------------------------------
mapBGscreen_pri	equ	2000h
;----------------------------------------------------------------------
Msetbox_Hadd	macro
	lda	setbox_charNo
	clc
	adc	setbox_Hadd
	sta	setbox_charNo
	endm

;----------------------------------------------------------------------
setbox_parameters
	lda.w	1,x		 ; message draw
	sta	setbox_vramaddr	 ; start address
	lda.w	3,x
	sta	setbox_charNo	 ;
	ldy.w	5,x		; Y = Hloop
	lda.w	7,x
	sta	setbox_Vloop
	lda.w	9,x
	sta	setbox_Hadd
	lda.w	11,x
	sta	setbox_Vadd
	txa
	clc
	adc	#12		; parameter count
	rts

;*********************************************************************
;	set boxcall
;*********************************************************************

;---------------------------------------------------------------------
; VRAM(screen VRAM draw )
;---------------------------------------------------------------------
Msetboxcall
	plx			; <<
	jsr	setbox_parameters
	pha			; >>

	lda	#81h		 ;
	sta	Screen_step	 ;

.skip2	ldx	setbox_Vloop
	lda	setbox_vramaddr	; draw address
	sta	Screen_address

	lda	setbox_charNo	; characterNo
	clc
.skip1	ora	#mapBGscreen_pri
	sta	Screen_write
	adc	setbox_Vadd
	dex
	bne	.skip1

	Msetbox_Hadd

	inc	setbox_vramaddr	; draw address
	dey
	bne	.skip2

	rts

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
;####################################################################
;####################################################################
;	
;------------ MAINPROGRAM (SUB) -------------------------------------
;
;####################################################################
;####################################################################

;*********************************************************************
; 	debug mode map explain
;*********************************************************************

debugmode_mapmessage

	lda	cont1
	and	#button_L+button_R
	cmp	#button_L+button_R
	bne	.skip

	lda	#mapexp_debugdisplay&WM
	sta	mapexp_pointer
.skip
	rts


;*********************************************************************
;	set parameter
;*********************************************************************
;
; sfx RAM ---> mario RAM
;
;----------------------------------------------------------------------

set_yjmap_parameter

	lda	p1_pilotNO
	and	#0ffh
	sta.l	m_playernumber		; copy pilot number
	lda.l	player_friend		; friend partner
	sta.l	m_partnernumber		; copy partner number

	rts

;*********************************************************************
;;	-----------------
;;	 trigger message 
;;	-----------------
;*********************************************************************

MessageTrigger_exp

	ifne AFdebugmpde_trigmessageON
	Mdebug_trigmessage		; Debug message
	endc

	lda	pepper_message		; 1byte messagedata
	bne	.exit
	
	ldx	#0			; pepper trigger message number
.loop	lda.l	tgmessage_select,x
	beq	.exit
	trb	map_trigmessage
	bne	.setmessage		; message ON
	Madx	6
	bra	.loop

.setmessage
	lda.l	tgmessage_select+2,x	; Read Message !!
	and	#00ffh
	beq	.exit
	sta	pepper_message+0	; Message-Number

	lda.l	tgmessage_select+3,x
	and	#00ffh
	sta	double_message+0	; double message (1)

	lda.l	tgmessage_select+4,x
	and	#00ffh
	sta	double_message+2	; double message (2)

	lda.l	tgmessage_select+5,x	
	and	#00ffh
	sta.l	mapmessage_setcolor	; Message-Color

.exit
	rts

;--------------------------------------------------------------------


;*********************************************************************
;	mapmessage entry
;*********************************************************************

check_mapmessage

;;;;;	Mdebug_demomapmessage	105	;;; debug display check


;==== fell ? =====

	km_bitcheckmismapflag	corneriafell
	beq	.nofell
	
	lda	pepper_message
	cmp	#fell_message
	beq	.skip
	stz	pepper_message
	stz	mapexp_pointer

.skip	lda	#mesosfl_corneriafell^0ffffh
	trb	mmx_message_sos		; message clear
	stz	map_trigmessage		; message clear
	bra	.fell

;=================

.nofell
	jsr	MessageTrigger_exp	; ( Map ONLY   )
.fell
	jsl	MessageTrigger_l	; ( Game & Map )
	
	lda	pepper_message		; ( TriggerMessage ON ? )	
	bne	Set_Triggermessage

	km_bitcheckmismapflag	corneriafell
	beq	.nofell2

	stz	mapexp_pointer
	stz	pepper_message

.nofell2
	jmp	Set_Levelmessage


;*********************************************************************
;	----------------
;	 trigger message
;	----------------
;*********************************************************************
;
; IF message-used THEN LVmessage speedup
; 	     ELSE TGmessage start
;
;---------------------------------------------------------------------

Set_Triggermessage

	lda	mapexp_pointer
	bne	.exit

	MsetL	m_gyoulimit,100
	MsetL	m_mapmessage_counter,0
	Mset	mapexp_pointer,mapexp_triggermessage&WM

	MmovL	m_mapmessageNo,pepper_message
	MmovL	m_mapmessage_color,mapmessage_setcolor

	lda	mmx_curposy
	ldx	mapmessage_setcolor
	cpx	#mapmessage_redcolor
	bcc	.skip
	lda	#0e0h
.skip	jsr	set_faceobjpos		; set position


;----------------------------------------------------------------------
.exit

	lda.l	m_mapmessageNo
	cmp	#area_message
	beq	.allck
	cmp	#viru_message
	bne	.normal
	


.allck	lda.l	mmx_message_sos
	and	#mesosfl_all
	bne	.allup
	lda.l	map_trigmessage
	and	#ymes_all
	bne	.allup

.normal
	Mset	mapmessage_messagestatus,LVmessage_speedup
	rts

.allup	Mset	mapmessage_messagestatus,ALLmessage_speedup
	rts

;----------------------------------------------------------------------
;;
;;
;;
;;
;;
;*********************************************************************
;	----------------
;	 level message
;	----------------
;*********************************************************************
;
; IF message-used THEN LVmessage speedup
; 	     ELSE TGmessage start
;
;---------------------------------------------------------------------

Set_levelmessage



	lda	mmx_mapcursor	; cursor hit ?
	beq	.cursor_out
	bra	.entry

.cursor_out

	lda	mmx_cursorflag2
	and	#curf2_hitenemy
	bne	.hitenemy_message

	Mset	mapmessage_messagestatus,LVmessage_speedup
	Mset	LVmessage_planetname,mapmessage_planetinit
	
	rts

;*********************************************************************
;	------------------
;	 hitenemy message
;	------------------
;*********************************************************************

.hitenemy_message
	lda	mapexp_pointer
	beq	.entry2
	lda.l	m_mapmessageNo
	cmp	#255
	beq	.exit
	bne	.wait

.entry2	lda	mmx_bigcurposy
	jsr	set_faceobjpos		; set position
	lda	#255			; EnemyName Message Mode
	sta.l	m_mapmessageNo		; Set Message Number

					; level message initialize
	Mset	LVmessage_planetname,mapmessage_planetinit

	lda	#mapmessage_blackcolor	
	sta.l	m_mapmessage_color	; Set Message Color
	stz	mapmessage_messagestatus
	MsetL	m_mapmessage_counter,0
	Mset	mapexp_pointer,mapexp_levelmessage2&WM
	rts

;*********************************************************************
;	------------------
;	 planet message
;	------------------
;*********************************************************************
.entry
	lda	cont0			; cont stop ?
	and	#button_up+button_down+button_left+button_right
	bne	.exit	

	lda	mmx_planetname		; same planet ?
	cmp	LVmessage_planetname
	beq	.exit
	lda	mapexp_pointer
	bne	.wait

;;;;;;	lda	mapexp_messageskipflag
;;;;;;	bne	.messageskip

	lda	mmx_bigcurposy
	jsr	set_faceobjpos		 ; set position
	jsr	set_LVmessageNumber
	jsr	set_LVmessageColor

	stz	mapmessage_messagestatus
	MsetL	m_mapmessage_counter,0
	Mset	mapexp_pointer,mapexp_levelmessage&WM

	rts

;-------------------------------------
.wait
	Mset	mapmessage_messagestatus,LVmessage_speedup
	rts

;-------------------------------------
.exit	rts


;-------------------------------------
.messageskip
	stz	mapexp_messageskipflag	; message skip flag OFF
	lda	mmx_planetname		; Now Planet Name
	sta	LVmessage_planetname	; Set Backup Planet Name
	rts


;---------------------------------------------------------------------




;*********************************************************************
;	set LVmessage number
;*********************************************************************
;
;
; (jap) cursor wo planet ni awaseta toki no message
;
;
;
;---------------------------------------------------------------------

set_LVmessageNumber
	lda	mmx_planetname		; name copy !!!!!
	sta	LVmessage_planetname	; planetname bakcup !!!!!
	tax
	lda.l	mapmessage_planetinfo,x	; message enntry
	and	#0ffh
	sta.l	m_mapmessageNo		; Set Message number
	rts

;*********************************************************************
;	set LVmessage color
;*********************************************************************

set_LVmessageColor

	lda	#mapmessage_blackcolor
	ldx	mmx_planetstep
	cpx	#000fh			;;; planet_safetime
	bne	.set
	lda	#mapmessage_bluecolor
.set	sta.l	m_mapmessage_color
	rts


;*********************************************************************
;	faceobj position check
;*********************************************************************
;
; << INPUT >>  --- register cursor position
;
;
; << workRAM >>
;
; faceobj_position  YX(16bit)	up/down
; faceobj_initpos   *X
;
; m_mapBG1scrollY   BGscroll		up/down
;
;---------------------------------------------------------------------
set_faceobjpos


;-------------------------------------------
;;; Enemy Voise Position
	ldy	#faceobjposV_up
	ldx	#message_scrollpos_up

;-------------------------------------------
	phx
	lda.l	m_mapmessage_color
	tax
	lda.l	mapmessage_color_messageposdata,x
	plx
	and	#00ffh
	bne	.skip

	ldx	#message_scrollpos_down
	ldy	#faceobjposV_down

.skip	txa				; X...scroll position
	sta.l	m_mapBG1scrollY
	tya				; Y...sprite position
set_faceobjcommon
	ora	faceobj_initpos
	sta	faceobj_position
	rts

;=====================================================================



;====================================================================
;====================================================================
; END END END END END END END END END END END END END END END END 
;====================================================================
;====================================================================

















































