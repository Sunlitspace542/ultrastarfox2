;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: oamlist.asm				*
;* 	Description	: oamlist				*
;*	Date		: 1994.8.15				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;
;
;
;***********************************************************************
;	sprite move macros
;***********************************************************************

Mspeed_add	macro	[speed,position]

	ldy	#0

	clc
	lda	{speed},x
	bpl	.skip\@
	dey				; y = 0ffffh
.skip\@	adc	{position}+0,x
	sta	{position}+0,x
	a8
	tya
	adc	{position}+2,x
	sta	{position}+2,x
	a16

	endm

;--------------------------------------------------------------------

;********************************************************************
;	------------------
;	2D SPRITE PROGRAM
;	------------------
;********************************************************************
	longa
	longi

;*********************************************************************
;	oamsetonly
;*********************************************************************

bank11_rts	rts

;***********************************************************************
;	move obj program
;***********************************************************************
moveXY
	ldx	register	; index register

	Mspeed_add	_velocityX,_positionX+1
	Mspeed_add	_velocityY,_positionY+1

	rts

;----------------------------------------------------------------------





;=======================================================================
;;
;;
;;
;;
;;
;;
;;
;***********************************************************************
;	Sprite Object Program <<<< MAIN >>>>>
;***********************************************************************
Main_OBJ
	Mbankprog
;----------------------------------------------------

	ifne	AFdebugcpuspeed
	Mdebugstart
	endc

;----------------------------------------------------
	ldx	#220h
	cpx	sprite_register
	beq	.skip
	bcc	.skip
	ldx	#0
.skip	stx	sprite_offset	;(double buffer)
;----------------------------------------------------
	lda	#word_root
	sta	Xlinklist_root
;----------------------------------------------------
	ldx	Xlinklist_root
;----------------------------------------------------
.loop	lda	_forward,x
.loopskip	cmp	Xlinklist_root
	beq	.exit
	sta	register
;- - - - - - - - - - - - - - - - - - 
	tax
	jsr	(_program,x)
;- - - - - - - - - - - - - - - - - - 
	ldx	register
	lda	_program,x	; data kill ?
	bne	.loop
;- - - - - - - - - - - - - - - - - - 
	jsr	KillLinklist
	bra	.loopskip	; Areg = next register
;----------------------------------------------------
.exit

	ifne	AFdebugcpuspeed
	Mdebugend
	endc

	Mbankrts
;-----------------------------------------------------------------------
;
;
;
;
;
;
;
;
;***********************************************************************
;	Sprite Object Program <<<< INITIAL >>>>>
;***********************************************************************

;-----------------------------------------------------------------------
;	obj list initialize
;-----------------------------------------------------------------------
Init_objlist

	lda	#word_free		; address
	sta	Xlinklist_free
	lda	#word_root
	sta	Xlinklist_root

	lda	#word_object_size	; size
	ldy	#word_object_total	; counter
	jsr	InitLinklist

	rts

;-----------------------------------------------------------------------
;	kill list
;-----------------------------------------------------------------------
;
;
;	
Kill_objlist
				; X = killobj pointer
	ldy	_forward,x	; Y = forward pointer
	lda	_backward,x
	sta.w	_backward,y
	tya
	ldy	_backward,x
	sta.w	_forward,y

	ldy	#word_free	; freelist pointer
	lda.w	_forward,y
	sta	_forward,x
	stx	_forward,y

	rts

;-----------------------------------------------------------------------
;	keep list
;-----------------------------------------------------------------------
;
;
;	
;-----------------------------------------------------------------------
Keep_objlist
	ply

	jsr	KeepLinklist	; IX = register
	bcs	.error
	jsr	ConnectLinklist	; IX = register

	lda.w	2,y
	and	#00ffh
	sta	_anime_trigger,x
	lda.w	5,y
	and	#00ffh
	sta	_axisX,x
	lda.w	6,y
	and	#00ffh
	sta	_axisY,x

	lda.w	3,y		; program address
	sta	_program+0,x

;--------------------------------------------------
	stz	_objlimit,x	; limit objcount
	stz	_charadd,x
	stz	_velocityX,x
	stz	_velocityY,x
	stz	_positionX,x
	stz	_positionY,x
;--------------------------------------------------

	phx			; >>
	lda.w	1,y		; index number
	and	#00ffh
	asl	a
	tax
	pla			; <<
	sta	objindex_table,x
	tax

.exit	tya
	clc	
	adc	#6
	pha	
	rts

.error			; <<<< object work memory full >>>>
	blink	

;-------------------------------------------------------------------




;***********************************************************************
;	LinkList library
;***********************************************************************
;	Areg	structure size
;	Yreg	structure counter
;=======================================================================
InitLinklist
;---------------------------- ; free link
	sta	Xwork0
	ldx	Xlinklist_free
	lda	#word_object
.loop	sta	_forward,x
	tax
	clc
	adc	Xwork0
	dey
	bne	.loop
	stz	_forward,x
;---------------------------- ; root reset
	ldx	Xlinklist_root
	txa
	sta	_backward,x
	sta	_forward,x
	rts
;=======================================================================
ConnectLinklist
	phy			; <
	ldy	Xlinklist_root
	sty	_backward,x	; *->prev
	txa
	ldx	_forward,y
	sta	_backward,x	; (root->next)->prev
	sta.w	_forward,y	; root->next
	txy
	tax
	sty	_forward,x	; *->next
	ply			; >>
	rts
;=======================================================================
KeepLinklist
	phy			; >>
	ldy	Xlinklist_free
	lda.w	_forward,y
	bne	.exit
	sec
	ply			; <
	rts
;- - - - - - - - - - - - - - - - - - - - - - - -
.exit	tax
	lda	_forward,x
	sta.w	_forward,y
	clc
	ply			; <
	rts
;=======================================================================
;;;; IN  X = old register
;;;; OUT A = new register
;-----------------------------------------------------------------------
KillLinklist

	ldy	_backward,x
	lda	_forward,x
	sta.w	_forward,y
	tax
	sty	_backward,x
	pha			; >>

	ldx	register
	ldy	Xlinklist_free
	lda.w	_forward,y	; IY = free root
	sta	_forward,x	; IX = kill object
	stx	_forward,y	; IY = free root

	pla			; <<<<< new regidter >>>>>
	rts
;-----------------------------------------------------------------------
;;
;;
;;
;;
;;
;=====================================================================
;=====================================================================
; END END END END END END END END END END END END END END END END END
;=====================================================================
;=====================================================================

