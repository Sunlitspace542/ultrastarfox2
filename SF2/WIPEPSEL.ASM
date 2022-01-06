;===================================================================
;===================================================================
;===================================================================
;*******************************************************************
;*		***********************************************
;*  WIPE (8)		***********************************************
;*		***********************************************
;* (leftright door )	***********************************************
;*		***********************************************
;*	224line	***********************************************
;*******************************************************************
;===================================================================
;===================================================================
;===================================================================
;
;
;
;
;
;-------------------------------------------------------------------

this_bank	= 	*&$ff0000

;-------------------------------------------------------------------
_dcpos	equ	_dcwork+0	; 4byte	( low  )
_dcaxis	equ	_dcwork+2	;	( high )
_dcspeed	equ	_dcwork+4	; 2byte
;-------------------------------------------------------------------
;
;*******************************************************************
;-------------------------------------------------------------------
; CLOSE CLOSE CLOSE CLOSE CLOSE CLOSE CLOSE CLOSE CLOSE CLOSE CLOSE
;-------------------------------------------------------------------
;*******************************************************************

wipepsel_close	

	ifne	debuginfo
	lda	trig0
	and	#button_ok
	beq	.skip
	lda	#1
	sta.l	kw_wipetimer
	endc

.skip	jsr	dc_program
	dwnext	w8close_init1
	dwnext	w8close_init2
	dwwait	50
	dwwait	tmpsel_wipebefore1
	dwwait	tmpsel_wipebefore2
	dwwait	80		; debug
	dwwait	60		; debug
	dwloop	80,w8close_main

	dwnext	offswitch 	; not reach
	dwwait	2		; not reach
	dwstop	endofwipe	; not reach

;--------------------------------------------------
w8close_init1
	jsr	bpsel_exitsave	
	Mset	bgdemo_switch,idx_pselect_close

	ldy	dcregister
	tyx
	Mposinit	x,_dcpos,190
	Mspeedinit	x,_dcspeed,-0800h

	ldy	#FullCloseData	; window 2
	lda	#FullOpenData	; window 1
	jsr	wipe_clear2
	rts

;--------------------------------------------------
w8close_init2

	jsr	set_param
	db	033h,033h,003h	; window switch
	db	00h,00h		; window logic
	db	10h		; 212dh
	db	02h,02h,0e0h

	rts

;-------------------------------------------------------------------
w8close_main
	jsr	swap_bufferFULL
	

;=================================================

	ifeq	1

	ldx	#224

	ldy	#0
	lda	#0c040h
.loop	sta	[Xaddr],y
	iny
	iny
	sta	[Xaddr],y
	iny
	iny
	dex	
	bne	.loop

	endc

;=================================================


	ldx	dcregister

	Mposadd		_dcpos,_dcspeed	   ; 
	Mspeedadd	_dcspeed,-020h	   ;

	lda	_dcpos+2,x	; position
	sta	temp_1L  

	lda	#Fwipe_full    ; = line-full
	sta	Xcounter
	ldx	#wipedoor&0ffffh
	ldy	#0
	jsr	setcall



	rts

;-------------------------------------------------------------------
;
;w8close_close
;
;	jsr	swap_bufferFULL
;
;	lda	#FullCloseData	; data
;	ldy	#0		; counter
;	ldx	#Fwipe_full	; line count
;	jmp	wipe_bufferset
;
;-------------------------------------------------------------------





;*******************************************************************




;*******************************************************************
;-------------------------------------------------------------------
; OPEN OPEN OPEN OPEN OPEN OPEN OPEN OPEN OPEN OPEN OPEN OPEN OPEN  
;-------------------------------------------------------------------
;*******************************************************************
wipepsel_open
	jsr	dc_program
	dwnext	clear_fullclose
	dwnext	w8open_init
	dwloop	24,w8open_main
	dwnext	offswitch,2
	dwwait	2
	dwstop	endofwipe
;--------------------------------------------------

w8open_init
	tyx
	Mposinit	x,_dcpos,0
	Mspeedinit	x,_dcspeed,400h


	jmp	w8close_init2	; window register set

w8open_main
;-------------------------------------------------------------------
	jsr	swap_bufferFULL

	ldx	dcregister
	Mposadd		_dcpos,_dcspeed		; 
	Mspeedadd 	_dcspeed,40h		; 

	lda	_dcpos+2,x			; position
	sta	temp_1L  

	lda	#Fwipe_full
	sta	Xcounter

	ldx	#wipedoor&0ffffh
	ldy	#0
	jmp	setcall
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
;
;
;
;
;
;********************************************************************
;
;	draw window buffer ( 1data window )
;
;********************************************************************
;;
;; x = (ROM)data address
;; y = wipe rasterline pointer
;;
;; temp_1L ... data center kara no offset
;;
;--------------------------------------------------------------------
;;	clear	0100 .. feff	
;;	left 	0000 .. 00ff
;;	right	0000 .. ff00
;--------------------------------------------------------------------
setcall

.loop   
	lda.l	this_bank+0,x	; Window1 Left
	and	#00ffh
	sec
	sbc	temp_1L
	Mwipeclip
	sta	Xtemp

	lda.l	this_bank+1,x	; Window1 Right 
	and	#00ffh
	clc
	adc	temp_1L
	Mwipeclip

	xba
	ora	Xtemp
	sta	(Xaddr),y

	iny
	iny
	iny
	iny
	inx
	inx

	dec	Xcounter
	bne	.loop

	rts


;********************************************************************
;
;	draw window buffer ( 2data window )
;
;********************************************************************
;
; x = (ROM)data address
; y = wipe rasterline pointer
;
; temp_1L ... data center kara no offset
;
;--------------------------------------------------------------------

;-------------------------
	ifeq	1
;-------------------------

setcall
;============================================
.loop   
	
	lda.l	this_bank+0,x	; Window1 Left
	and	#00ffh
	sec	
	sbc	temp_1L
	bpl	.skip1
	lda	#00000h
	bra	.set1
.skip1  	bit	#0ff00h
	beq	.set1
	lda	#000ffh
.set1   	sta	Xtemp

	lda.l	this_bank+1,x	; Window1 Right 
	and	#00ffh
	clc
	adc	temp_1L
	bpl	.skip2
	lda	#00000h
	bra	.set2
.skip2  	bit	#0ff00h
	beq	.set2
	lda	#000ffh
.set2   	xba
	ora	Xtemp
	sta	(Xaddr),y

	iny
	iny
	inx
	inx


	lda.l	this_bank+0,x	; Window1 Left
	and	#00ffh
	clc	
	adc	temp_1L

	bpl	.skip3
	lda	#00000h
	bra	.set3
.skip3  	bit	#0ff00h
	beq	.set3
	lda	#000ffh
.set3   	

	sta	Xtemp

	lda.l	this_bank+1,x	; Window1 Right 
	and	#00ffh
	clc
	adc	temp_1L

	bpl	.skip4
	lda	#00000h
	bra	.set4
.skip4  	bit	#0ff00h
	beq	.set4
	lda	#000ffh
.set4   	
	xba
	ora	Xtemp
	sta	(Xaddr),y

	iny
	iny
	inx
	inx

	dec	Xcounter
	bne	.loop


;-------------------------
	endc
;-------------------------


;===================================================================
;===================================================================
;END END END END END END END END END END END END END END END END END
;===================================================================
;===================================================================

