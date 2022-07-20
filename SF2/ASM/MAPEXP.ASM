;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: mapexp.asm				*
;* 	Description	: map explain 				*
;*	Date		: 1994.10.22				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;;
;;
;;
;*********************************************************************
;	message Number define
;*********************************************************************

overmessage_number	equ	110	; gameover message number





;*********************************************************************
;	README
;*********************************************************************

xxstart	equ	11

;---------------------------------------------------------------------
;
;---- map -----------------------
; mapexp_easystart		; <<< easy >>> 	strat message
; mapexp_easyret_normal	; <<< easy >>>	return normal
; mapexp_easyret_message	; <<< easy >>>	return message
;
; mapexp_bokan_idou		; free demo message (kawaguchi)
;
; mapexp_speedend
;
;---- openning explain ----------
; mapexp_openning		; openning explain
;
;---- debug message display -----
; mapexp_debugdisplay	; debug mode display
;	
;
;
;*********************************************************************
;	explain
;*********************************************************************
;
; mapexp_dispflag
;
; counter
;
;---------------------------------------------------------------------
;
; ME_enddemo		;;; demomessage NO owari
;		;;; mapmessage GA initialize SARERU
;
; ME_stop		;;; demomessage NO owari
;		;;; kono address de wait sareru
;
; ME_endmessage	;;; mapmessage NO owari
;		;;; tsugi no message wo wait suru
;
;---------------------------------------------------------------------
;
;*********************************************************************
;	Display Message Lang.
;*********************************************************************
;
;
;xME_init		macro	
;xME_initdemo	macro	
;ME_end		macro
;ME_program		macro	[progaddr]
;xME_jmp		macro	[jmpaddr]
;xME_sound		macro	[sound]
;xME_objset		macro	[posX,posY,characterNo]
;xME_faceopen	macro
;xME_faceclose 	macro
;ME_wait		macro	[waittime]
;xME_objclear	macro
;ME_stop		macro
;ME_enddemo		macro
;ME_endmessage 	macro
;xME_sos		macro
;xME_planet		macro
;ME_message		macro	[messageNo]
;ME_messageSPEED	macro	[messageNo]
;ME_messageONvoise	macro	[messageNo]
;ME_levelmessage 	macro
;ME_triggermessage 	macro
;xME_setW		macro	[addr,data]
;xME_clrbit		macro	[addr,data]
;xME_setbit		macro	[addr,data]
;xME_setWmario 	macro	[addr,data]
;xME_moveposY	macro	[data]
;xME_timestart 	macro	[data]
;xME_messagepos_UP 	macro
;xME_messagepos_DOWN	macro
;MEcode_end		macro
;
;
;*********************************************************************
;	flags
;*********************************************************************
;
;-------------------------------------------------
; next object WO hyouji saseru
;-------------------------------------------------
;
; mapexp_nextobj	0000h ..... ON wait
;		4000h ..... ON display
;		FFFFh ..... OFF
;
;-------------------------------------------------


;*********************************************************************
;	explain message macros
;*********************************************************************

;---------------------------------------------------------------------
xME_init	macro	
	db	idx_mapexp_init
	endm

;---------------------------------------------------------------------
xME_initdemo	macro	
	db	idx_mapexp_initdemo
	endm

;---------------------------------------------------------------------
ME_program	macro	[progaddr]
	db	idx_mapexp_program
	dw	({progaddr})&WM
	endm

;---------------------------------------------------------------------
xME_jmp	macro	[jmpaddr]
	db	idx_mapexp_jmp
	dw	({jmpaddr})&WM
	endm

;---------------------------------------------------------------------
xME_sound	macro	[sound]
	db	idx_mapexp_sound
	db	{sound}
	endm

;---------------------------------------------------------------------
xME_objset	macro	[posX,posY,characterNo]
	db	idx_mapexp_objset
	db	{posX}
	db	{posY}
	db	{characterNo}
	endm

;---------------------------------------------------------------------
xME_faceopen	macro
	db	idx_mapexp_faceopen
	endm
;---------------------------------------------------------------------
xME_faceclose macro
	db	idx_mapexp_faceclose
	endm

;---------------------------------------------------------------------
ME_wait	macro	[waittime]
	db	idx_mapexp_wait
	db	{waittime}
	endm

;---------------------------------------------------------------------
xME_objclear	macro
	db	idx_mapexp_objclear
	endm

;---------------------------------------------------------------------
ME_stop	macro
	db	idx_mapexp_stop
	endm

;---------------------------------------------------------------------
ME_enddemo	macro
	db	idx_mapexp_enddemo
	endm

;---------------------------------------------------------------------
ME_endmessage macro
	db	idx_mapexp_endmessage
	endm

;---------------------------------------------------------------------
ME_message	macro	[messageNo]
	db	idx_mapexp_message
	db	{messageNo}
	endm

;---------------------------------------------------------------------
ME_messagedemo	macro	[messageNo]
	db	idx_mapexp_messagedemo
	db	{messageNo}
	endm

;---------------------------------------------------------------------
ME_message_kawaflag	macro
	db	idx_mapexp_message_kawaflag
	endm

;---------------------------------------------------------------------
ME_messageSPEED	macro	[messageNo]
	db	idx_mapexp_messageSPEED
	db	{messageNo}
	endm

;---------------------------------------------------------------------
ME_messageONvoise	macro	[messageNo]
	db	idx_mapexp_message
	db	{messageNo}
	endm

;---------------------------------------------------------------------
ME_levelmessage macro
	db	idx_mapexp_LVmessage
	endm

;---------------------------------------------------------------------
ME_triggermessage macro
	db	idx_mapexp_TGmessage
	endm

;---------------------------------------------------------------------
xME_setW	macro	[addr,data]
	db	idx_mapexp_setW
	dw	({addr})&WM
	dw	{data}
	endm

;---------------------------------------------------------------------
xME_clrbit	macro	[addr,data]
	db	idx_mapexp_clrbit
	dw	({addr})&WM
	dw	{data}^0ffffh
	endm

;---------------------------------------------------------------------
xME_setbit	macro	[addr,data]
	db	idx_mapexp_setbit
	dw	({addr})&WM
	dw	{data}
	endm

;---------------------------------------------------------------------
xME_setWmario macro	[addr,data]
	db	idx_mapexp_setWmario
	dw	({addr})&WM
	dw	{data}
	endm

;---------------------------------------------------------------------
xME_moveposY	macro	[data]
	db	idx_mapexp_moveposY
	db	{data}
	endm

;---------------------------------------------------------------------
xME_timestart macro	[data]
	db	idx_mapexp_timestart
	endm

;---------------------------------------------------------------------
xME_messagepos_UP macro
	db	idx_mapexp_messagepos_UP
	endm

;---------------------------------------------------------------------
xME_messagepos_DOWN macro
	db	idx_mapexp_messagepos_DOWN
	endm

;---------------------------------------------------------------------
ME_easywait	macro
	db	idx_mapexp_easywait
	endm
;---------------------------------------------------------------------


;---------------------------------------------------------------------
;	ME program 
;---------------------------------------------------------------------
xMEprogram_dataNEXT	macro
	sec
	rts
	endm

;---------------------------------------------------------------------
MEprogram_dataWAIT	macro
	clc
	rts
	endm

;---------------------------------------------------------------------

;
;
;
;
;
;
;---------------------------------------------------------------------

mapexp_addr	=	*&$ff0000
m_marioaddr	=	700000h



;*********************************************************************
;	---------------------
;	 speedup demomessage
;	---------------------
;*********************************************************************


;speedup_demomessage
;
;	lda	mapexp_demoflag
;	beq	.exit
;
;	lda	kx_mmplayerseq
;	cmp	#plseq_yjwait
;	beq	.skip
;	cmp	#plseq_yjbeginwait
;	bne	.exit
;.skip
;
;	lda	mmw_trigger	
;	and	#button_start
;	beq	.exit
;
;	ksound	next_message
;
;	lda	#mapexp_speedend&WM
;	sta	mapexp_pointer
;
;.exit
;	rts
;
;*********************************************************************
;	----------------------
;	 demo message program
;	----------------------
;*********************************************************************
expdemo_main
	Mbank7e
	php
	ai16

	jsr	mapexp_nextcode
;;;;;;;	jsr	speedup_demomessage

	plp
	Mbankrts

;======================================================================


mapexp_nextcode
	ldx	mapexp_pointer
	beq	.exit
.next
	lda.l	mapexp_addr,x
	inx			; code inc
	txy
	and	#00ffh
	asl	a
	tax
	jsr	(.process,x)
	stx	mapexp_pointer	; x = ROM pointer
	bra	.next
.exit	rts
;----------------------------------------------------------------------
.process
	Mindexliststart
	Mindexlist	mapexp_end
	Mindexlist	mapexp_init
	Mindexlist	mapexp_initdemo
	Mindexlist	mapexp_jmp
	Mindexlist	mapexp_faceopen
	Mindexlist	mapexp_faceclose
	Mindexlist	mapexp_wait
	Mindexlist	mapexp_message
	Mindexlist	mapexp_messagedemo
	Mindexlist	mapexp_message_kawaflag
	Mindexlist	mapexp_messageSPEED
	Mindexlist	mapexp_objset
	Mindexlist	mapexp_objclear
	Mindexlist	mapexp_setW
	Mindexlist	mapexp_setbit
	Mindexlist	mapexp_clrbit
	Mindexlist	mapexp_setWmario
	Mindexlist	mapexp_moveposY
	Mindexlist	mapexp_stop
	Mindexlist	mapexp_enddemo
	Mindexlist	mapexp_endmessage
	Mindexlist	mapexp_program
	Mindexlist	mapexp_sound
	Mindexlist	mapexp_timestart
	Mindexlist	mapexp_LVmessage
	Mindexlist	mapexp_TGmessage
	Mindexlist	mapexp_messagepos_UP
	Mindexlist	mapexp_messagepos_DOWN
	Mindexlist	mapexp_easywait

;*********************************************************************
;	ME codes
;*********************************************************************
MEcode_end	macro
	pla		; << del return value
	rts		
	endm

;---------------------------------------------------------------------
mapexp_moveposY
	tyx
	a8
	clc
	lda.l	mapexp_addr+0,x
	adc	mapexp_objpos+1		; Y position
	sta	mapexp_objpos+1
	a16

	inx
	rts

;=====================================================================

mapexp_easywait
	tyx
	lda	kx_mmplayerseq
	cmp	#plseq_yjbeginwait
	beq	.next
	lda	kx_mmplayerseq
	cmp	#plseq_yjwait
	beq	.next
	MEcode_end
;------------------------------------------
.next	stx	mapexp_pointer
	MEcode_end
;------------------------------------------



;=====================================================================
mapexp_messagepos_UP
	tyx
	lda	#message_scrollpos_up
	ldy	#faceobjposV_up
	bra	mapexp_messagepos_common

mapexp_messagepos_DOWN
	tyx
	lda	#message_scrollpos_down
	ldy	#faceobjposV_down

mapexp_messagepos_common
	sta.l	m_mapBG1scrollY
	tya
	ora	faceobj_initpos
	sta	faceobj_position
	rts

;=====================================================================
mapexp_setW
	tyx
	lda.l	mapexp_addr+0,x
	tay
	lda.l	mapexp_addr+2,x
	sta.w	0,y

	inx
	inx
	inx
	inx
	rts

;=====================================================================
mapexp_setbit
	tyx
	lda.l	mapexp_addr+0,x
	tay
	lda.l	mapexp_addr+2,x
	ora.w	0,y
	sta.w	0,y

	inx
	inx
	inx
	inx
	rts

;=====================================================================
mapexp_clrbit
	tyx
	lda.l	mapexp_addr+0,x
	tay
	lda.l	mapexp_addr+2,x
	and.w	0,y
	sta.w	0,y

	inx
 	inx
	inx
	inx
	rts

;=====================================================================
mapexp_setWmario
	tyx
	lda.l	mapexp_addr+0,x
	tay
	lda.l	mapexp_addr+2,x
	phx			; >>
	tyx
	sta.l	m_marioaddr,x	; 
	plx			; <<
	inx
	inx
	inx
	inx
	rts
;=====================================================================
mapexp_init
	tyx
	bra	mapexp_initcommon

;=====================================================================
mapexp_initdemo

;---------------------------------------------------
	tyx

	MsetL	m_mapmessageNo,0
	MsetL	m_messagetimer,TIME_demomessage

	lda	mapexp_pointer	; NOW pointer set
	sta	mapexp_demoflag

mapexp_initcommon
	stz	mapexp_objNo	; RESET object
	stz	mapexp_counter	; RESET counter
	stz	mapexp_nextobj	; RESET nextobj

	rts

;=====================================================================
mapexp_end	
	tyx
	MEcode_end

;=====================================================================
mapexp_jmp	tyx
	lda.l	mapexp_addr+0,x
	tax
	rts

;=====================================================================
mapexp_faceopen
	tyx
	lda	#1
	sta	openface_count
	sta.l	m_mapmessage_faceflag
	rts

;=====================================================================
mapexp_faceclose
	tyx
	lda	#1
	sta	closeface_count
	lda	#0		; message off
	sta.l	m_mapmessageNo
	sta.l	m_mapmessage_faceflag
	stz	mapexp_objNo
	stz	mapicon_flag
	rts

;=====================================================================
mapexp_sound
	tyx
	lda.l	mapexp_addr+0,x
	and	#00ffh
	ksound_a
	inx
	rts

;=====================================================================
mapexp_enddemo
	tyx
	stz	mapexp_pointer
	stz	mapexp_demoflag

	MsetL	m_mapmessage_faceflag,0
	MsetL	m_gyoulimit,127
	MsetL	m_mapmessageNO,0
	MsetL	m_messagetimer,TIME_mapmessage

	jsr	clear_messageparam

	MEcode_end

;=====================================================================
mapexp_endmessage
	tyx
	stz	mapexp_pointer	;  pointer Reset
	MEcode_end

;=====================================================================
mapexp_stop
	tyx
	MEcode_end

;=====================================================================
mapexp_program
	tyx
	jsr	(0,x)
	bcc	.exit
	inx			; next code 
	inx
	rts			; next code entry

.exit	MEcode_end

;=====================================================================
mapexp_wait
	tyx
	lda.l	mapexp_addr+0,x
	and	#00ffh
	cmp	mapexp_counter
	bcs	.exit
	stz	gameframe_trigger
	stz	mapexp_counter
	inx
	stx	mapexp_pointer
	MEcode_end

;-----------------------------------------------------
.exit	inc	mapexp_counter
	MEcode_end

;=====================================================================
mapexp_TGmessage
	lda.l	m_redpepper_anime
	inc	a
	cmp	#6
	bcc	.s
	lda	#0
.s	sta.l	m_redpepper_anime

	lda	#TGmessage_speedup
	bra	mapexp_CMmessage
;=====================================================================
mapexp_LVmessage

.entry	lda	#LVmessage_speedup
mapexp_CMmessage
	tyx
	and	mapmessage_messagestatus
	bne	.speedup

	lda.l	m_mapmessageNo
	bpl	.exit

.speedup
	stz	mapmessage_messagestatus
	MsetL	m_mapmessageNo,0

	rts			; next !!!


.exit	MEcode_end

;=====================================================================
Mmessage_nextcheck	macro	[data]

	lda	mapexp_counter		; nextobj check
	cmp	#xxstart-1-{data}
	bcc	.skip\@

	jsr	Setbit_nextobj

.skip\@	jsr	Check_nextkey		; key check
	beq	.EXIT_DEMOMESSAGE

	lda	mapexp_counter		; timer check
	cmp	#xxstart-{data}
	bcs	.NEXT_DEMOMESSAGE
	cmp	#xxstart-3-{data}
	bcs	.EXIT_DEMOMESSAGE

	lda	#xxstart-3-{data}	; speedup set
	sta	mapexp_counter
	sta.l	m_mapmessage_counter
	bra	.EXIT_DEMOMESSAGE

	endm

;----------------------------------------------------------------------
Setbit_nextobj
	pha			; >>
	lda	#4000h		; nexmark start
	tsb	mapexp_nextobj	;
	pla			; <<
	rts
;-------------------------------------------------
; next object GA arutoki TO naitoki
;-------------------------------------------------
Check_nextkey
	lda	mapexp_nextobj
	bpl	.skip1
	lda	#button_B+button_Y+button_jyuujikey
	bra	.skip2
.skip1	lda	#button_B+button_Y+button_jyuujikey
.skip2	and	mmw_trigger
	rts
;-------------------------------------------------
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
;----------------------------------------------------------------------

mapexp_message_kawaflag

	tyx

	lda	mapexp_kawanumber ;
	sta.l	m_mapmessageNo	  ; Set message number

;==========================================
;;	lda	cont0
;;	and	#button_R
;;	beq	.s
;;
;;	Mend_demomapmessage
;;.s
;==========================================

	lda	mapexp_kawaflag	 ; Flag check
	beq	.exit

	stz	mapexp_kawaflag	 ;
	lda	#0
	sta.l	m_mapmessageNo	 ; 
	rts			 ; next code

.exit	MEcode_end		 ; same code


;----------------------------------------------------------------------

mapexp_messageSPEED
	lda	#00010h
	bra	mapexp_message_common

;- - - - - - - - - - - - - - - - - - - - - - -
mapexp_messagedemo

	lda	mmw_trigger	
	and	#button_start
	beq	mapexp_message
	ksound	next_message
	lda	#mapexp_speedend&WM
	sta	mapexp_pointer


	MBRK

	pla			; << sub routine skip
	jmp	mapexp_nextcode

;- - - - - - - - - - - - - - - - - - - - - - -
mapexp_message
	lda	#0

;- - - - - - - - - - - - - - - - - - - - - - -
mapexp_message_common

	sta	Xwork0
	tyx
	lda	mapexp_counter
	bne	.endcheck

;-------------------------------------------------
; initialize
;-------------------------------------------------
	bit	Xwork0
	bpl	.offsound

	ksound	p_warning_0
.offsound
	lda	Xwork0		 ; Reset Counter
	and	#00ffh
	sta.l	m_mapmessage_counter
	lda.l	mapexp_addr+0,x	 ; Set Bitmap message
	and	#00ffh
	sta.l	m_mapmessageNo
	bra	.EXIT_DEMOMESSAGE

;-------------------------------------------------
.endcheck
	cmp	#100		; AUTO NEXT TIME
	bcs	.NEXT_DEMOMESSAGE_nosound
	lda.l	m_gamemessageheight
	cmp	#36
	bcs	.3line

;-------------------------------------------------
; 	(2)line mode 
;-------------------------------------------------

.2line	Mset	mapexp_linecheck,1
	Mmessage_nextcheck	4

.3line	stz	mapexp_linecheck
	Mmessage_nextcheck	0
		
;----------------------------------- 
; 	SAMEprocess
;----------------------------------- 
.EXIT_DEMOMESSAGE
	inc	mapexp_counter
	lda.l	m_mapmessage_counter	; <<< Set gyoulimit >>>
	lsr	a
	lsr	a
	sta.l	m_gyoulimit
	MEcode_end

;----------------------------------- 
; 	NEXTprocess
;----------------------------------- 
.NEXT_DEMOMESSAGE
	ksound	next_message

.NEXT_DEMOMESSAGE_nosound
	stz	mapexp_counter	; counter reset
	stz	mapexp_nextobj	; nextmark clear
	inx
	stx	mapexp_pointer	; next pointer
	MEcode_end

;=====================================================================

mapexp_objset			; <<<<< yajirushi obj set >>>>>
	tyx

	lda.l	mapexp_addr+0,x  ; Set sprite X
	sta	mapexp_objpos
	lda.l	mapexp_addr+2,x
	and	#00ffh
	sta	mapexp_objNo

	jsr	set_yajirushi

	inx
	inx
	inx
	rts

;=====================================================================

mapexp_objclear
	tyx
	stz	mapexp_objpos
	stz	mapexp_objNo
	rts

;=====================================================================


set_yajirushi
	phx
	phy
	ai8

	ldy	mapexp_objpos+1
	beq	.exit
	cpy	#60h
	bcs	.Ydown
	lda	#cd_objanime_yajirushi_up
	bra	.set
.Ydown	lda	#cd_objanime_yajirushi_dw
.set	sta	mapexp_objNo

.exit	ai16
	ply
	plx
	rts

;=====================================================================
mapexp_timestart
	tyx
	km_setval.l	kx_messagedemowait,0
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
;=====================================================================
;=====================================================================
;	program end 
;=====================================================================
;=====================================================================
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;*********************************************************************
;
;*********************************************************************
;
;          -----------------
;	MESSAGE DATAS
;          -----------------
;
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
;	----------------------------------
;	 Level Message ( Planet Explain )
;	----------------------------------
;*********************************************************************

mapexp_levelmessage
	xME_init		; message initialize
	xME_messagepos_DOWN	
	xME_setWmario	m_gyoulimit,127
	xME_sound	sport3_e_message_open
	xME_faceopen		; open face 
	ME_wait		1	; wait 2 gameframe
	ME_program	set_iconflag
	ME_wait		1	; wait 2 gameframe
	ME_levelmessage		; levelmessage program
	xME_faceclose		; close face
	ME_wait		3	; wait 2 gameframe
	ME_endmessage		; message end

;--------------------------------------------------------------------
set_iconflag
	lda.l	m_mapmessageNo
	cmp	#255
	bne	.exit
	lda	#0ffffh
	sta	mapicon_flag
.exit	xMEprogram_dataNEXT

;*********************************************************************
;	---------------------------------
;	 Level Message ( Enemy Display )
;	---------------------------------
;*********************************************************************

mapexp_levelmessage2  		;;; enemy display message
	xME_init		;;  message initialize
	xME_messagepos_DOWN	;;
	xME_sound	sport3_e_message_open
	ME_wait		1	;;  wait 2 gameframe
	ME_program	set_iconflag
	ME_wait		1	;;  wait 2 gameframe
	ME_levelmessage		; levelmessage program
	xME_setW	mapicon_flag,0
	ME_endmessage		;;  message end

;*********************************************************************
;	-----------------
;	 Trigger Message
;	-----------------
;*********************************************************************
mapexp_triggermessage
	xME_init
	ME_program	trigger_sound
	xME_setWmario	m_gyoulimit,127
	xME_setWmario	m_redpepper_anime,0
	xME_faceopen
	ME_wait		2
	ME_triggermessage
	ME_program	check_double
	ME_program	trigger_sound
	ME_triggermessage
trigger_messageend
	xME_sound	sport3_tsushin_end	; sound
	xME_faceclose
	ME_wait		3
	ME_program	overtrigger_check
	xME_timestart
	xME_setW	pepper_message,0	; trigger OFF
	ME_endmessage


;--------------------------------------------------------------------
;	trigger double message
;--------------------------------------------------------------------

check_double
	lda	double_message
	beq	.skip
	sta	pepper_message
	sta.l	m_mapmessageNo
	MsetL	m_mapmessage_counter,0
	stz	double_message
	xMEprogram_dataNEXT

.skip
	ldx	#(trigger_messageend&WM)-2
	xMEprogram_dataNEXT

;--------------------------------------------------------------------
;	sound
;--------------------------------------------------------------------

trigger_sound
	PHX				;>>
	lda.l	m_mapmessage_color
	tax
	lda.l	mapmessage_color_sounddata,x
	and	#00ffh
	ksound_a
	PLX				;<<
	xMEprogram_dataNEXT

;--------------------------------------------------------------------
;	check gameover message
;--------------------------------------------------------------------

overtrigger_check
	lda	pepper_message
	cmp	#overmessage_number
	bne	.exit
	lda	#demof_fell
	trb	kx_demoflag
	MsetBL	kw_tm,010110b
	jsr	clear_triggermessage	; all trigger messag clear

.exit	xMEprogram_dataNEXT

;--------------------------------------------------------------------
;*********************************************************************
;	---------------
;	 Bpush message
;	---------------
;*********************************************************************

mapexp_speedend
	xME_objclear
	xME_setWmario	m_mapmessageNO,0
	xME_setW	mapexp_nextobj,OFF_nextobj
	ME_wait		2
	xME_timestart
	ME_enddemo

;*********************************************************************
;	------------------------
; 	 Easy Map Start message
;	------------------------
;*********************************************************************

mapexp_easystart
	xME_initdemo
	ME_easywait
	xME_sound	sport3_e_message_open
	xME_setWmario	m_mapmessage_faceflag,-1
	xME_messagepos_DOWN	
	ME_messagedemo	22
	ME_messagedemo	20
	ME_messagedemo	212
	xME_setW	mapexp_nextobj,OFF_nextobj
	ME_messagedemo	21
	xME_timestart
	ME_enddemo
	
;*********************************************************************
;	-----------------
; 	 Easy Map Return 
;	-----------------
;*********************************************************************

mapexp_easyret_normal
	ME_program	easyret_wait
	ME_wait	2
	xME_timestart
	ME_endmessage

;*********************************************************************
;	--------------------------------
; 	 Easy Map Return ( message ON )
;	--------------------------------
;*********************************************************************

mapexp_easyret_message
	ME_program	easyret_wait
	ME_wait	2
	xME_initdemo
	xME_messagepos_DOWN
	xME_setWmario	m_mapmessage_color,0
	xME_setWmario	m_mapmessage_faceflag,-1
	xME_setW	mapexp_nextobj,OFF_nextobj
	xME_sound	sport3_e_message_open
	ME_messagedemo	109
	xME_timestart
	ME_enddemo

;-----------------------------------------------------
easyret_wait
	lda	kx_mmplayerseq
	cmp	#plseq_yjwait
	bne	.wait

	xMEprogram_dataNEXT

.wait	MEprogram_dataWAIT

;---------------------------------------------------------------------
;
;
;
;
;
;
;
;
;*********************************************************************
;	--------------------
;	 Message ON Display
;	--------------------
;*********************************************************************

mapexp_bokan_idou
	xME_init		; message initialize
	ME_program	clear_tgmessage
	xME_messagepos_DOWN
	xME_setWmario	m_mapmessage_color,mapmessage_blackcolor
	xME_setWmario	m_mapmessage_faceflag,-1
	xME_setWmario	m_gyoulimit,127
	ME_message_kawaflag
	xME_setW	mapexp_messageskipflag,-1
	ME_endmessage

;---------------------------------------------------------------------
clear_tgmessage
	jsr	clear_triggermessage
	xMEprogram_dataNEXT

;---------------------------------------------------------------------
;
;
;
;
;
;
;*********************************************************************
;	-------------------
;	 Openning Message
;	-------------------
;*********************************************************************

mapexp_openning
	xME_init

	ME_wait			50

	xME_messagepos_DOWN	
	xME_sound	sport3_tsushin_start
	xME_faceopen

	ME_messageONvoise	1
	ME_messageONvoise	2

	xME_objset	030h,080h,cd_objanime_yajirushi_dw
	ME_messageONvoise	3
	xME_objclear

	xME_setW	yajirushi_flag,ON_zakoyaji
	ME_messageONvoise	4
	ME_messageONvoise	5
	xME_setW	yajirushi_flag,ON_enemyyaji
	ME_messageONvoise	6
	xME_setW	yajirushi_flag,ON_missyaji
	ME_messageONvoise	7
	xME_setW	yajirushi_flag,OFF_enemyyaji

;----- corneria HP ----------
	xME_objset	030h,080h,cd_objanime_yajirushi_dw
	ME_messageONvoise	8
	ME_messageONvoise	9
	xME_objclear

	xME_objset	020h,0c0h,cd_objanime_yajirushi_dw
	ME_messageONvoise	10
	ME_messageONvoise	11
	xME_objclear

;-----------------------------

	xME_setW	mapexp_nextobj,OFF_nextobj
	ME_messageONvoise	12
	ME_wait		4
	xME_sound	sport3_tsushin_end
	xME_faceclose
	ME_wait		3

	xME_setW	kx_MisMapSeq,mmseq_explainfinish
	ME_stop


;*********************************************************************
;	----------------------------
; 	 debug mode message display
;	----------------------------
;*********************************************************************

mapexp_debugdisplay

.loop
	xME_initdemo
	xME_faceopen

;-----------------------------------------	; debug datas
	ME_message	1
	ME_message	2
	ME_message	3
	ME_message	4
	ME_message	5
	ME_message	6
	ME_message	7
	ME_message	8
	ME_message	9
	ME_message	10
	ME_message	11
	ME_message	12
	ME_message	13
	ME_message	14
	ME_message	15
	ME_message	16
	ME_message	17
	ME_message	18
	ME_message	19
	ME_message	20
	ME_message	21
	ME_message	22
	ME_message	23
	ME_message	24
	ME_message	25
	ME_message	26
	ME_message	27
	ME_message	28
	ME_message	29
	ME_message	30
	ME_message	31
	ME_message	32
	ME_message	33
	ME_message	34
	ME_message	35
	ME_message	36
	ME_message	37
	ME_message	38
	ME_message	39
	ME_message	40
	ME_message	41
	ME_message	42
	ME_message	43
	ME_message	44
	ME_message	45
	ME_message	46
	ME_message	47
	ME_message	48
	ME_message	49
;-----------------------------------------	
	ME_message	98
	ME_message	99
	ME_message	100
	ME_message	101
	ME_message	102
	ME_message	103
	ME_message	104
	ME_message	105
	ME_message	106
	ME_message	107
	ME_message	108
	ME_message	109
	ME_message	110
	ME_message	111
	ME_message	112
	ME_message	113
	ME_message	114
	ME_message	115
	ME_message	116
	ME_message	117
;-----------------------------------------	
	ME_message	124
	ME_message	125
	ME_message	126
;-----------------------------------------	

	xME_faceclose
	ME_wait		5

	xME_jmp	.loop

;;	printf	"mapexp_pointer",:$mapexp_pointer
;;	printf	"message_easystart",:$mapexp_easystart
;;	printf	"message_easyretnormal",:$mapexp_easyret_normal
;;	printf	"message_easyretmes",:$mapexp_easyret_message
;;	printf	"message_speedend",:$mapexp_speedend


;=====================================================================
;=====================================================================
; END END END END END END EDN END END END END END END END END END END
;=====================================================================
;=====================================================================

