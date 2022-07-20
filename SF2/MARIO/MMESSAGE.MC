;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: mmessage.mc				*
;* 	Description	: map-screen bitmap message		*
;*	Date		: 1994.10.7				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;--------------------------------------------------------------
;; README !!
;;
;; 1995.4.6. 	MOSHI message waku! no HABA wo kaeru 
;;		gamemessage_startoffsetY
;;		gamemessage_endoffsetY
;;
;;      5.9		255 no toki hontou ni 3gyou size de OK nano ?
;;		mmessage.mc WO check shiteoitene !!
;;
;;
;;
;;
;;
;--------------------------------------------------------------
	include INC\mmessage.inc
;--------------------------------------------------------------
;;
;;
;;
;;
;;
;;
;**************************************************************
;	README
;**************************************************************
;;
;; m_mapmessageNo ..... 0   		( OFF )
;;	    ..... 1,2.... 254   ( MESSAGE NUMBER )
;;
;;	    ..... 255		( ENEMY DISPLAY )
;;	    ..... ffff		( END MESSAGE )
;;
;--------------------------------------------------------------
enemyname_mode equ	0ffh	;(m_mapmessageNo )
;--------------------------------------------------------------
;;
;;
;**************************************************************
;	macros
;**************************************************************


;**************************************************************
;	Parameter's
;**************************************************************

;---------------------------------------------------------------
; game messageBOX
;---------------------------------------------------------------
gamemessage_cornerX		equ	4ch-8
gamemessage_sizeX		equ	110

gamemessage_startoffsetY	equ	1
gamemessage_endoffsetY	equ	0

;---------------------------------------------------------------

mapmessage_waittime		equ	10

;---------------------------------------------------------------

androf_messageY		equ	8*12

;---------------------------------------------------------------
; mapmessage parameter's
;---------------------------------------------------------------
mapmessage_wakuXcorner	equ	0
mapmessage_wakuXsize		equ	127
mapmessage_width		equ	127
mapmessage_initlength	equ	100 	; 100 moji !!
mapmessage_messagecolor	equ	0eh
mapmessage_Ycenter		equ	5ch
mapmessage_messageX		equ	mapmessage_wakuXcorner+5
;--------------------------------------------------------------
;
;
;
;
;
;**************************************************************
;	---------------------
;	 MAP message program
;	---------------------
;**************************************************************

mmapmessage_entry
mmapmessage_l

	Mlda	m_mapmessageNo		; check message number
	moves	r0,r0
	beq	.exit
	nop
	bmi	.exit
	nop

	Mjsr	DrawMapMessage	

	lm	r0,[m_messageend]  	; END ?
	moves	r0,r0
	beq	.exit_call
	nop
	Mstop


.exit_call	Msta	m_mapmessageNo,0ffffh	; ( exit )
	Mstop

.exit
	Mstz	m_mapmessageNo		; number reset	!!
	Mstz	m_mapmessage_counter	; counter reset !!
	Mstop

;--------------------------------------------------------------
;
;
;
;**************************************************************
;	Draw Message&Face(pepper)
;**************************************************************
Mif_enemyname_mode	macro [addr]
	iwt	r1,#enemyname_mode
	lm	r0,[m_mapmessageNo]
	sub	r1
	bne	.skip\@
	nop	
	iwt	r15,#{addr}&WM
	nop
.skip\@
	endm

;--------------------------------------------------------------
Mif_missionexplain_mode macro [addr]
	Mlda	m_mapmessage_faceflag
	moves	r0,r0
	bpl	.skip\@
	nop
	iwt	r15,#{addr}&WM
	nop
.skip\@	
	endm

;--------------------------------------------------------------
Mswitch	macro	[addr]
	lm	r1,[{addr}]
	endm

;--------------------------------------------------------------
Mcase	macro	[casedata,addr]
	ibt	r0,#{casedata}
	from	r1
	sub	r0
	bne	.skip\@
	nop
	iwt	r15,#{addr}&WM
	nop
.skip\@
	endm

;--------------------------------------------------------------
Mif_cmpbeq	macro	[ramaddr,data,jmpaddr]
	Mswitch	[{ramaddr}]
	Mcase	[{data},{jmpaddr}]
	endm

;--------------------------------------------------------------



;---------------------------------------------------------------
;;
;; < input  > r1 = messageNo * 2
;;
;; < output > DISPLAY face
;;		 message
;;
;--------------------------------------------------------------
DrawMapMessage
	Msave_r11			; >>
;--------------------------------------------------------------
	Mif_enemyname_mode	DrawEnemyData
	Mif_missionexplain_mode	DrawMissionExplain

	Mswitch	m_mapmessage_color 
	Mcase	mapmessage_enemycolor,DrawAndrossMessage
	Mcase	mapmessage_enemycolor2,DrawAndrossMessage
	Mcase	mapmessage_enemycolor3,DrawAndrossMessage
	Mcase	mapmessage_wolfcolor,DrawWolfMessage
	Mcase	mapmessage_redcolor,DrawRedPepperMessage
	Mcase	mapmessage_gameovercolor,DrawDownPepperMessage

;--------------------------------------------------------------
DrawPepperMessage
	Mjsr	mcalc_map_messageindex
	Mjsr	mdraw_map_messagebox
	Mjsr	mdraw_map_message
	Mjsr	mcalc_map_mouth		; (out)r2 = anime data
	ibt	r1,#face_pepper		; r1 = face number		
	Mjsr	mdraw_map_face
	Mjsr	mmessage_counterINC
	Mload_r11

;--------------------------------------------------------------
DrawDownPepperMessage
	Mjsr	mcalc_map_messageindex
	Mjsr	mdraw_map_messagebox
	Mjsr	mdraw_map_message
	MsetROMaddr gameover_animedata
	Mjsr	mcalc_map_faceanime	 ; (out)r2 = anime data
	ibt	r1,#face_pepper_gameover ; r1 = face number		
	Mjsr	mdraw_map_face
	Mjsr	mmessage_counterINC
	Mload_r11

;--------------------------------------------------------------
DrawRedPepperMessage
	Mjsr	mcalc_map_messageindex
	Mjsr	mdraw_map_messagebox
	Mjsr	mdraw_map_message
	Mjsr	mcalc_map_mouth		; (out)r2 = anime data
	ibt	r1,#face_pepper_red	; r1 = face number		
	Mjsr	mdraw_map_face
	Mjsr	mmessage_counterINC
	Mload_r11

;--------------------------------------------------------------
DrawEnemyData
	Mjsr	mdraw_map_messagebox
	ibt	r1,#face_enemydata	; r1 = face number
	ibt	r2,#0
	Mjsr	mdraw_map_face
	ibt	r0,#1
	sm	[m_messageend],r0 
	Mload_r11

;--------------------------------------------------------------
DrawMissionExplain
	Mjsr	mcalc_map_messageindex
	Mjsr	mdraw_map_messagebox
	Mjsr	mdraw_map_message
	ibt	r1,#face_explain	; r1 = face number		
	ibt	r2,#0
	Mjsr	mdraw_map_face
	Mjsr	mmessage_counterINC
	Mload_r11

;--------------------------------------------------------------
DrawAndrossMessage
	Mjsr	mcalc_map_messageindex
	Mjsr	mdraw_map_messagebox
	Mjsr	mdraw_map_message
	Mjsr	mcalc_map_mouth		; (out)r2 = mouth data
	ibt	r1,#face_andross	; r1 = face number		
	Mjsr	mdraw_map_face
	Mjsr	mmessage_counterINC
	Mload_r11

;--------------------------------------------------------------
DrawWolfMessage
	Mjsr	mcalc_map_messageindex
	Mjsr	mdraw_map_messagebox
	Mjsr	mdraw_map_message
	Mjsr	mcalc_map_mouth		; (out)r2 = mouth data
	ibt	r1,#face_wolf		; r1 = face number		
	Mjsr	mdraw_map_face
	Mjsr	mmessage_counterINC
	Mload_r11

;--------------------------------------------------------------
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
;	Calc MessageIndex & MessageCornerY
;********************************************************************

mcalc_map_messageindex

	sm	[m_subrts],r11

	Mlda	m_mapmessageNo
	to	r1			;<< input >> message number
	add	r0
	ibt	r2,#0			;<< input >> index offset
	Mindex_message	messagetable

	iwt	r0,#normalfont
	sms	[m_font],r0
	iwt	r0,#mapmessage_width
	sms	[m_visualwidth],r0
	Mjsl	mStringHeight_l

	lms	r0,[m_y1]
	sm	[m_gamemessageheight],r0
	lms	r0,[m_y1]
	lsr	a
	not
	inc	r0
	iwt	r3,#mapmessage_Ycenter
	add	r3
	sms	[m_y1],r0	; m_y1 ... draw corner Y

	lm	r15,[m_subrts]
	nop


;********************************************************************
;	Draw mapmessage
;********************************************************************

mdraw_map_message
	sm	[m_subrts],r11

	lms	r0,[m_y1]
	inc	r0
	inc	r0			;;;; message down 
	sms	[m_y1],r0
	ibt	r0,#mapmessage_messageX
	sms	[m_x1],r0
	ibt	r0,#mapmessage_initlength
	sms	[m_z1],r0
	Mjsl	mprintWWstringN_l

	lm	r15,[m_subrts]
	nop


;**************************************************************
;	mouth ON/OFF 
;**************************************************************
;--------------------------------------------------------------
; << input >>
;
; << ouput >> r2
;		0 ... mouth stop
;		1 ... mouth move
;--------------------------------------------------------------
mcalc_map_mouth

	MsetROMaddr	mouth_data

mcalc_map_faceanime

	Mlda	m_mapmessage_counter
	iwt	r2,#8*4
	cmp	r2
	bcc	.skip1
	nop

	sub	r0		; r0 = 0

.skip1	with	r14
	add	r0	

	to	r2
	getb

	Mrts

;********************************************************************
;	Draw mapface
;********************************************************************
;;
;; << input >> r1 face index
;; 	  r2 mouth ( animation offset )
;;
;---------------------------------------------------------------
mdraw_map_face

	iwt	r3,#0			; X position
	iwt	r4,#8			; Y position

;---------------------------------------------------------------
Drawface
	sm	[m_facerts],r11		; return address
	sm	[m_x1],r3		; draw position X
	sm	[m_y1],r4		; draw position Y

	MsetROMaddr	face_anime	; texture address
	with	r14
	add	r1			; face number
	with	r14
	add	r2			; animation offset
	getb	
	sm	[m_spra],r0		; character Number

	Mjsl	mDisplayFace_l

	lm	r15,[m_facerts]
	nop

;********************************************************************
;	counter INC
;********************************************************************

mmessage_counterINC

	Minc	m_mapmessage_counter
	lm	r1,[m_messagetimer]
	cmp	r1
	bcc	.skip
	nop
	ibt	r1,#0			; end of message
.skip	sm	[m_messageend],r1
	
	Mrts
	

;--------------------------------------------------------------
;
;
;
;
;
;
;
;
;
;==============================================================
;==============================================================
;==============================================================
;==============================================================

;**************************************************************
;	bitmap player-face message data
;**************************************************************
Mfacemovestart macro
yj_faceNo    = 0
	endm

;--------------------------------------------------------------
Mfacemovedata_1 	macro	[name,data1]
{name}	equ	yj_faceNo
	db	{data1}
yj_faceNo	= yj_faceNo+1
	endm

;--------------------------------------------------------------
Mfacemovedata_2 	macro	[name,data1,data2]
{name}	equ	yj_faceNo
	db	{data1}
	db	{data2}
yj_faceNo	= yj_faceNo+2
	endm

;--------------------------------------------------------------
Mfacemovedata_3	macro	[name,data1,data2,data3]
{name}	equ	yj_faceNo
	db	{data1}
	db	{data2}
	db	{data3}
yj_faceNo	= yj_faceNo+3
	endm

;--------------------------------------------------------------
face_anime	
   Mfacemovestart
   Mfacemovedata_2	face_fox,fox1_spr,fox2_spr		;(0)
   Mfacemovedata_2	face_falco,falco1_spr,falco2_spr	;(1)
   Mfacemovedata_2	face_peppy,peppy1_spr,peppy2_spr	;(2)
   Mfacemovedata_2	face_slippy,slippy1_spr,slippy2_spr	;(3)
   Mfacemovedata_2	face_pony,pony1_spr,pony2_spr		;(4)
   Mfacemovedata_2	face_girl,girl1_spr,girl2_spr		;(5)
;------------------------------------------------------------------
   Mfacemovedata_2	face_pepper,pepper1_spr,pepper2_spr	;(extra)
   Mfacemovedata_2	face_andross,andross1_spr,andross2_spr
   Mfacemovedata_1	face_explain,explain_spr
   Mfacemovedata_1	face_enemydata,enemydata_spr
   Mfacemovedata_2	face_wolf,wolf1_spr,wolf2_spr
   Mfacemovedata_2	face_pepper_red,pepper3_spr,pepper4_spr
   Mfacemovedata_3	face_pepper_gameover,pepper3_spr,pepper4_spr,msgopening4_spr
   Mfacemovedata_1	face_title1,titlechar1_spr
   Mfacemovedata_1	face_title2,titlechar2_spr
   Mfacemovedata_1	face_title3,titlechar3_spr
   Mfacemovedata_1	face_title4,titlechar4_spr


;--------------------------------------------------------------
;  mouth animation data
;--------------------------------------------------------------
mouth_data	db	0,1,0,1,0,1,0,1
	db	0,0,0,1,0,1,0,0
	db	0,0,1,0,1,0,1,0
	db	0,0,1,0,1,0,1,0
;--------------------------------------------------------------
;  dead animation data
;--------------------------------------------------------------
gameover_animedata	
	db	0,1,0,1,0,2,0,1
	db	2,0,1,0,2,1,2,1
	db	0,2,1,2,1,2,0,1
	db	2,2,0,2,2,1,2,2
;--------------------------------------------------------------
;
;
;
;
;
;
;
;
;********************************************************************
;		************************************************
; gamemessage BOX	************************************************
;		************************************************
;********************************************************************

mprintboxmessage

	iwt	r4,#gamemessage_cornerX	 ; <<< Set Xpostion >>>
	iwt	r5,#gamemessage_sizeX

;====================================================================

	Msta	m_mapmessage_color,mapmessage_blackcolor


	Mlda	m_gamemessagetype	 ; <<< Set Color >>>
	to	r1
	lob

	from	r1
	sub	#sound_down	;(down)
	bne	.skip
	nop
	Msta	m_mapmessage_color,mapmessage_redcolor
	bra	.entry
	nop

.skip	from	r1
	sub	#sound_help	;(down)
	bne	.entry
	nop
	Msta	m_mapmessage_color,mapmessage_enemycolor

;====================================================================
.entry


	ibt	r0,#38
	lm	r1,[m_gamemessageheight]
	dec	r1			; r1 height-Y
	from	r1
	sub	r0
	bcc	.skip1
	nop
	dec	r1
.skip1


	lm	r0,[m_y1]		; r0 start-Y
	inc	r0
	sm	[m_y1],r0

	Mjsr	mdraw_messagebox	; <<< Set box >>>

	ibt	r0,#100			; <<< Set message >>>
	sms	[m_z1],r0		; 
	sm	[m_gyoulimit],r0	; Add Yajima !!
	Mjsl	mprintWWstringN_l

	Mstop				; <<< exit >>>



;********************************************************************
;		************************************************
; BOXmessage draw	************************************************
;		************************************************
;********************************************************************
;
; <<<<< input >>>>>
;	r0 ..... BOX CORNER Y1 	( m_y1_boxdraw	   )
;	r1 ..... BOX HEIGHT 	( m_height_boxdraw )
;
; <<<<< register >>>>>
;
; r0   ..........
; r1   plot
; r2   plot
; r3   Y lineloop counter
; r4   X-start point
; r5   X-size
; r6   ..........
; r7   waku color
; r8   Y-start point
; r9   Y-size
; r10  Y-end
; r11  return address
; r12  loop
; r13  loop
; r14  ROM pointer
;
;--------------------------------------------------------------------
;
; gamemessagetype = 0 black
;	     = 1 red 
;
;--------------------------------------------------------------------

REDfrash_table	db	1,2,3,4,4,4,3,2
BLUEfrash_table	db	5,6,7,8,8,8,7,6
Xfrash_table		db	0eh,07h,02h,0fh
		db	0eh,07h,02h,0fh
	
;--------------------------------------------------------------------
; box color & waku color & moji color
;--------------------------------------------------------------------
mcolor_table	db	09h,0eh,0eh		;(0) color_black
	db	05h,0eh,0eh		;(1) color_blue
	db	01h,00h,0eh		;(2) color_red
	db	01h,00h,0eh		;(3) color_special
	db	05h,0eh,0eh		;(4) enemy speak(1)
	db	05h,0eh,0eh		;(5) enemy speak(2)
	db	05h,0eh,0eh		;(6) enemy speak(3)
	db	05h,0eh,0eh		;(7) enemy speak(4)

;--------------------------------------------------------------------
mapmessage_color_sounddata
	db	sport3_p_warning_2	;(0)
	db	sport3_p_warning_2	;(1)
	db	sport3_p_warning_2	;(2)
	db	sport3_p_warning_2	;(3)
	db	sport3_androf_voice_0	;(4)	enemycolor1
	db	sport3_androf_voice_1	;(5)	enemucolor2
	db	sport3_androf_voice_2	;(6)	enemucolor3
	db	sport3_wolf_voice	;(7)	wolf sound

;--------------------------------------------------------------------
mespos_down	equ	0
mespos_up	equ	1
;--------------------------------------------------------------------
mapmessage_color_messageposdata
	db	mespos_down		;(0)
	db	mespos_down		;(1)
	db	mespos_down		;(2)
	db	mespos_down		;(3)
	db	mespos_up		;(4)
	db	mespos_up		;(5)
	db	mespos_up		;(6)
	db	mespos_up		;(7)

;--------------------------------------------------------------------
;
;
;
;
;
;====================================================================

mdraw_map_messagebox

	iwt	r4,#mapmessage_wakuXcorner	
	iwt	r5,#mapmessage_wakuXsize
	ibt	r0,#49h		; start Y
	ibt	r1,#39		; height


mdraw_messagebox

;--------------------------------------------------------------------
	sm	[m_y1_boxdraw],r0	; <<< Set box Y1 >>>
	sm	[m_height_boxdraw],r1	; <<< Set height  >>>

;--------------------------------------------------------------------
; set frash color

	MsetROMaddr		REDfrash_table
	Mcounter_limitinc	m_gamemessagecolor,8
	with	r14
	add	r0
	to	r3		; r3 = frash color
	getb

;--------------------------------------------------------------------

	MsetROMaddr		mcolor_table

	lm	r0,[m_mapmessage_color]
	mult	#3
	with	r14
	add	r0

;---------------------------------------------------------
				; r2 = BOX color
	getb
	inc	r14
	moves	r2,r0
	bne	.skip1
	nop
	move	r2,r3		; SET BOX FRASH

;---------------------------------------------------------
.skip1	getb
	inc	r14
	moves	r7,r0		; r7 = WAKU color
	bne	.skip2
	nop
	move	r7,r3		; SET WAKU FRASH !!!

;---------------------------------------------------------
.skip2				; r0 = MOJI color
	getb	
	sm	[m_textcolour],r0


;--------------------------------------------------------------------
; BOX FILL
;--------------------------------------------------------------------
;;	ibt	r0,#010b
	sub	r0
	cmode

	from	r2		; r2 = BOX color
	colour

;-------------------------------------
; calc Y ... (start)
;-------------------------------------
	lm	r8,[m_y1_boxdraw]	; (Ystart)
	with	r8
	sub	#gamemessage_startoffsetY
;-------------------------------------
; calc Y ... (size)
;-------------------------------------
	lm	r9,[m_height_boxdraw]	; Y=size
;-------------------------------------
; calc Y ... (end)
;-------------------------------------
	from	r8		; start
	add	r9		; size
	to	r10
	add	#gamemessage_startoffsetY+gamemessage_endoffsetY-1
;-------------------------------------
	with	r9
	add	#gamemessage_startoffsetY+gamemessage_endoffsetY
;-------------------------------------
	move	r2,r8
	move	r3,r9
;-------------------------------------
; draw box loop
;-------------------------------------

	mcache	
.loop	move	r12,r5
	move	r1,r4
	move	r13,r15
	loop
	plot
	dec	r3
	bne	.loop
	inc	r2

;--------------------------------------------------------------------
; LINE FILL
;--------------------------------------------------------------------
;;	sub	r0
;;	cmode

	from	r7
	colour

;-------------------------------------
; set line X1
;-------------------------------------
	move	r1,r4	; X start !!
	move	r2,r8	; Y start !!
	move	r12,r5  ; X size
	MlineXloop

;-------------------------------------
; set line X2
;-------------------------------------
	move	r1,r4	; Xstart !!
	move	r2,r10	; Yend
	move	r12,r5	; Xsize
	MlineXloop

;-------------------------------------
; set line Y1
;-------------------------------------
	move	r1,r4	; Xstart
	move	r2,r8	; Y start
	move	r12,r9	; Y size
	MlineYloop

;-------------------------------------
; set line Y2
;-------------------------------------
	to	r1
	from	r4	; Xstart+Xsize
	add	r5
	move	r2,r8	; Ystart
	move	r12,r9	; Ysize
	MlineYloop

;-------------------------------------
; set kado
;-------------------------------------

	Mset_kado	; Mset kado

;-------------------------------------
; exit
;-------------------------------------

	jmp	r11
	nop

;----------------------------------------------------------------
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;;;
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;********************************************************************
;	-----------------------
;	* BITMAP-DEMO-PROGRAM *
;	-----------------------
;********************************************************************
;;
;;
;;
;********************************************************************
;;	color bar noize
;********************************************************************
;;--------------------------------------------
;; macro [addr,xstart,xloop,ystart,yloop]
;;--------------------------------------------
;;
;;
;;============================================

noize_test


;---------------------
; random counter INC
;---------------------
	lm	r0,[m_testcount]
	dec	r0
	sbk
	move	r8,r0		; r8 = random parameter

;---------------------
; random parameter
;---------------------

	Mjsr	Lrandom_parameter

;---------------------
; make video noize
;---------------------

	lm	r0,[m_videonoize_counter]
	moves	r0,r0
	beq	.skip
	add	r0
	ibt	r2,#038h
	with	r2
	add	r0

	iwt	r3,#2
	Mjsr	Lvideo_noize

.skip
;---------------------
; set counter
;---------------------

	lm	r0,[m_barnoize_counter]
	moves	r10,r0
	beq	.exit
	nop
	bmi	.manynoize
	nop

	mcache
;---------------------------------

.loop
	Mjsr	Lrandom_prog
	from	r8
	lob
	lsr
	inc	r0
	move	r12,r0		; X Counter


	Mjsr	Lrandom_prog
	from	r8
	lob
	lsr
	inc	r0
	move	r1,r0		; X position

	iwt	r3,#0d8h
	from	r1	; Xstart
	add	r12	; Xsize
	cmp	r3
	bcc	.drawentry
	nop

	from	r3	; max-start = size
	to	r12
	sub	r1

.drawentry
	Mjsr	Lrandom_prog
	from	r8
	lob
	lsr
	ibt	r3,#3ch
	add	r3
	inc	r0
	move	r2,r0		; Y position
	


	move	r13,r15		; RANDOM PLOT
	Mjsr	Lrandom_prog	
	from	r8
	and	#0fh
	colour
	loop
	plot

	dec	r10
	bne	.loop
	nop

.exit
	Mstop

;--------------------------------------------------------------------

.manynoize
	ibt	r2,#038h
	iwt	r3,#087h

	Mjsr	Lvideo_noize

	Mstop

;--------------------------------------------------------------------
;
;
;
;
;
;********************************************************************
;	-----------------------
;	* BITMAP-DEMO-LIBRARY *
;	-----------------------
;********************************************************************
;;
;;
;;
;;
;********************************************************************
; 	TV noize
;********************************************************************

Lvideo_noize
	move	r10,r11
	mcache
.loop
	ibt	r1,#0
	iwt	r12,#0deh
	move	r13,r15		; RANDOM PLOT
	Mjsr	Lrandom_prog	
	from	r8
	and	#01h
	add	#8		; 8/9
	colour
	loop
	plot
	dec	r3
	bne	.loop
	inc	r2

	jmp	r10
	nop


;********************************************************************
; 	make random
;********************************************************************
;
;	r0  ...	work
;
;	r4  ...	use parameter
;	r5  ...	use parameter
;	r6  ...	use parameter
;	r7  ...	use parameter
;	r8  ...	RANDOM
;	r9  ...	use parameter
;
;	r11 ... return address
;
;--------------------------------------------------------------------
;<< exsample >>
;
;	lm	r8,[random]		; load random
;	Mjsr	Lrandom_parameter
;	Mjsr	Lrandom_prog
;	sm	[random].r8		; save random
;
;--------------------------------------------------------------------

Lrandom_prog	

	from	r8
	cmp	r9
	bne	.entry
	nop
	with	r8
	sub	r8

.entry	move	r0,r8
	and	r4
	swap
	xor	r8
	swap
	moves	r8,r0

	swap
	and	r4
	add	r0
	xor	r8
	lsr
	bcc	.skip
	nop
	xor	r5
	xor	r6
	bra	.exit
	nop
;-------------------------------------------------------
.skip	xor	r5
	cmp	r7
	bne	.exit
	nop
	sub	r0
.exit	move	r8,r0
	
	jmp	r11
	nop

;-----------------------------------------------------------------

Lrandom_parameter

	iwt	r9,#0560ah	;
	iwt	r7,#0aa55h
	iwt	r6,#08180h
	iwt	r5,#0ff80h
	iwt	r4,#000ffh
	jmp	r11
	nop

;--------------------------------------------------------------------



;==============================================================
;==============================================================
; END END END END END END END END END END END END END END END
;==============================================================
;==============================================================


