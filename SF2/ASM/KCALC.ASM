;*****************************************************************************
;* FILES:		KCALC.ASM						*
;* AUTHOR:		Yasuhiro Kawaguchi					*
;* DESCRIPTION:	Calculation						*
;* DATE:		16-06-95						*
;*****************************************************************************
	INCPUB	kcalc

;**********************************************************************
;*		Kakesan Sub Routine			*
;* 8bit*8bit unsign multiply					*
;*Init 							*
;*   Acc  :							*
;*   Xreg :							*
;*Out							*
;*   Acc  :							*
;**********************************************************************
kmultu8u8
	php
	a8
	sta.l	wrmpya
	txa
	sta.l	wrmpyb
;8 cycle wait
	nop
	nop
	nop
	nop

	a16
	lda.l	rdmpylr
	plp
	rts


;*********************************************************************
;*		Kakesan Sub Routine				*
;* 16bit*8bit unsign multiply					*
;*Init 								*
;*   Acc  :16 bit							*
;*   Xreg :8 bit							*
;*Out								*
;*   Acc  :16 bit							*
;*********************************************************************
kmultu16u8_l
	php
	a16
	longi
	bit	#$FF00
	beq	.less256
	pha
	km_loba
	jsr	kmultu8u8
	sta	kz_tpa
	pla
	km_hibswapa
	jsr	kmultu8u8

	xba
	pha
	km_loba
	tax
	pla
	km_hiba

	clc
	adc	kz_tpa
	plp
	rtl
.less256
	jsr	kmultu8u8
	ldx	#0
	plp
	rtl



