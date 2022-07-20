;***************************************************************************
;*                              -----------                                *
;*                              StarGlider                                 *
;*                              -----------                                *
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                           Argonaut Software.      		      *	   
;*_________________________________________________________________________*
;*                                                                         *
;*   File: PLANETS.ASM                                                     *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: PLANET SELECTION SCREEN.                                        *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 10/4/92                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:                                                                 *
;*	Dylan Cuthbert.                                               *
;*                                                                         *
;***************************************************************************

	incpub	planets
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------
;----------------------------------------------------------------------

waitdma224
	php
	a8
	lda	#222
	sta	dmatemp
	jsl	waitdma_l

	lda	#0
.loop	dec	a
	bne	.loop
	plp
	rts
; --------------------------------------------------
; waitdma_l
; called from the macro 'waitdma' to save memory

waitdma_l
	php
	ai16
	phx
	pha
	a8
	stz	dmatemp+1

.waitforline
	a8
	lda	slhvr
	lda	opvctr
	xba
	lda	opvctr
	xba

;	a16
;	and	#%111111111
	cmp	dmatemp
	bne	.waitforline

;.vw1	lda	slhvr		;wait for screen off
;	ldx	opvctr
;	lda	opvctr
;	and	#1
;	bne	.vw1
;	cpx	dmatemp
;	bne	.vw1

	ai16
	pla
	plx
	plp

	rtl

	IFEQ	1
waitforirq
	php
	a8
	stz	irqtoggle
;.wait	lda	irqtoggle
;	bne	.wait
.wait2
	lda	irqtoggle
	beq	.wait2

	plp
	rts

	ENDC

;--------------------------------------------------------------
; initialise the planet selection, should only be done per game

initplanets_l
	php
	a8

; set number of lives
	lda	#3
	sta	lives

	IFEQ	debuginfo2
	stz	credits
	ELSEIF
	lda	#1
	sta	credits
	ENDC

; clear stage, map mode and screen transfer latch
	stz	stage
	stz	mapmode
	stz	bg_dmalist

	plp
	rtl


;------------------------------------------------------------------------

read_joypadt_l
; this sets up cont and trig after waiting for hvbjoy
	php
	a8
.notreadyyet2
	lda	hvbjoyr
	bit	#1
	beq	.notreadyyet2
.notreadyyet	lda	hvbjoyr
	bit	#1
	bne	.notreadyyet
	bra	read_joypad_l.readitall
	

;--------------------------------------------------------------------

read_joypad_l
; this sets up cont0-1 and trig0-1 (without timing)
	php
.readitall	LOCAL
	a16
	lda	joy1l
	pha
	eor	cont0
	and	joy1l
	sta	trig0

	lda	joy2l
	pha
	eor	cont1
	and	joy2l
	sta	trig1
	pla
	sta	cont1
	pla
	sta	cont0

	plp
	rtl

