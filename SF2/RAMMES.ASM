;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: raster.asm				*
;* 	Description	: RAM message				*
;*	Date		: 1994.9.30				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;---------------------------------------------------------------------
	INCPUB	rammes
;---------------------------------------------------------------------
;
;
;
;
;
;*********************************************************************
;	parameter's
;*********************************************************************
;---------------------------------------------------------------------
code_HPoverline	equ	30	; 70%
code_HPattack_1	equ	15	; 85%
code_HPattack_2	equ	50	; 50%
;---------------------------------------------------------------------
;
;
;
;
;
;
;*********************************************************************
;	----------------------------
;	 game cyu no pepper message
;	----------------------------
;*********************************************************************

MTGgamemessage macro	[flag,m0,color]
	dw	mesosfl_{flag}		; check message flag
	db	{m0}			; message 1
	db	mapmessage_{color}	; message color
	endm

;=====================================================================

MessageTrigger_l

	Mbank7e
	php
	ai16

;----------------------------------------------------
.debug

	ifne AFrammessage_debug
	Mdebug_gamemessage
	endc

	ifne AFrammessage_debuggameover
	Mdebug_gameovermessage
	endc

;----------------------------------------------------
.modecheck
	lda	kw_GameMode
	and	#00ffh
	cmp	#kmode_initmission
	bne	.entry	
	lda	wipestruct
	cmp	#idx_wipegame_open
	beq	.exit

;----------------------------------------------------
.entry
	lda	pepper_message	; 1byte messagedata
	bne	.exit

;----------------------------------------------------
; Trigger Message BIT Check !!!

	ldx	#0		; pepper trigger message number

.loop	lda.l	xxmessage_select+0,x
	beq	.exit
	trb	mmx_message_sos
	bne	.setmessage
	Madx	4
	bra	.loop

;----------------------------------------------------
.setmessage
	lda.l	xxmessage_select+2,x	; Read Message !!
	and	#00ffh
	bne	.skip

	jsr	check_soszakoattack	; zakoattack

.skip	sta	pepper_message+0	; Message-Number

	lda.l	xxmessage_select+3,x	; Read Color !!
	and	#00ffh
	sta.l	mapmessage_setcolor+0	; Message-Color

	stz	double_message+0	; double 1
	stz	double_message+2	; double 2
;----------------------------------------------------

.exit	plp
	Mbankrtl

;*********************************************************************
;;	----------------------------
;; 	 red message check 8bitmode
;;	----------------------------
;*********************************************************************
;------------------------------------------
; SOS zako GA KOUGEKI CYU !!!
;------------------------------------------
check_soszakoattack
	lda	#17		; ### messageNo yarare 0...50
	ldy	kx_CorneriaHP
	cpy	#code_HPattack_1
	bcc	.set
	lda	#16		; ### messageNo yarare 51..84
	cpy	#code_HPattack_2
	bcc	.set
	lda	#15		; ### messageNo yarare 85..99
.set	rts


;------------------------------------------


;*********************************************************************
;	--------------
;	 message data	
;	--------------
;*********************************************************************
;
; 115 missile ga atatta toki !!
;
;---------------------------------------------------------------------
;
; 0 .... zako attack special message
;
;
;
;---------------------------------------------------------------------
xxmessage_select

 MTGgamemessage corneriafell,fell_message,gameovercolor  ;(0)  " gameover message "
 MTGgamemessage zacoattack,0,redcolor	   	;(1)  "zako yararecheck "
 MTGgamemessage missileattack,18,redcolor	   	;(2)  "missile ga atatta !!"
 MTGgamemessage planetcannonhit,19,redcolor	  	 ;(3)  "cannon  ga atatta !!"
 MTGgamemessage missileappear,81,blackcolor	  	 ;(4)  "missile ga deta! "
 MTGgamemessage zacoappear,80,blackcolor 	  	 ;(5)  "kuubo kara sos ga deta !"
 MTGgamemessage battleshipappear,82,blackcolor 	 ;(6)  "kuubo ga deta! "
 MTGgamemessage planetcannonarea,135,blackcolor	 ;(7)  "planet cannon syatei "
 MTGgamemessage virustorituki,viru_message,redcolor	 ;(8)  "satellite ni enemy ga torituita !!"
 MTGgamemessage zacotubushi,197,redcolor	  	 ;(9)  "satellite ga teki wo tubushita !!"
 dw	   0				  	 ;(endcode)

;=====================================================================
; end end end end end end end end end end end end end end end end end
;=====================================================================
