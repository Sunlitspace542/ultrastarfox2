;*****************************************************************************
;* FILES:		KRAMCALC.ASM						*
;* AUTHOR:		Yasuhiro Kawaguchi					*
;* DESCRIPTION:	Calculation						*
;* DATE:		16-06-95						*
;*****************************************************************************
	INCPUB	kramcalc
;===================================================================
;* 		Normalise 2D
;* Init: 	kvecx:16 bit
;*	kvecy:16 bit
;* Exit	kvecx:8 bit	(normalise X)
;*	kvecy:8 bit	(normalise Y)
;===================================================================
	IFEQ	1
knormalise2D_l
	longa
	longi

	phb
	phx
	phy

	lda	kvecx
	sta.l	m_x1	;vec X
	lda	#0
	sta.l	m_y1	;vec Y
	lda	kvecz
	sta.l	m_z1	;vec Z

	call_mario	mnorm16

	a8
	lda.l	m_x1+1
	sta	kvecx

	lda.l	m_z1+1
	sta	kvecz

	ply
	plx
	plb
	rtl

	ENDC

;อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
;*
;* 			 arctan16
;* 65816 no baai
;* Init: (kz_x1,kz_y1) :16bit :kz_x1 = X zahyou , kz_y1 = Y zxahyou
;* Exit: Acc	:16bit :Acc_h = seisuu,Acc_l = syousuu
;*
;* Mario no baai
;* Init: (m_x1,m_y1) :16bit :m_x1 = X zahyou , m_y1 = Y zxahyou
;* Exit: (m_cnt)	:16bit :m_cnt+1 = seisuu,m_cnt = syousuu
;อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
karctan16_l
	phx
	phy
	phb
	php
;----------------------------------
; call mario
	ai16
	jsl	arctan16_l		;(65816 no baai) :[ramsrou.asm]

;;;	call_mario	mcallarctan16	;(mario chip no baai)
;----------------------------------
	plp
	plb
	ply
	plx
	rtl
;=====================================================================
;*								*
;*			Multiply				*
;*								*
;=====================================================================
;=====================================================================
;*		Mulitply  UnSin_8 * UnSin8			*
;* Input	:kz_x1 		:8 bit (usin)				*
;*	:kz_y1		:8 bit (unsin)				*
;* Out Put	:Acc		:16bit (unsin)				*
;=====================================================================
kcpumultu8u8_l
	a8
	lda	kz_x1
	sta.l	wrmpya
	lda	kz_y1
	sta.l	wrmpyb
	nop
	nop
	nop
	nop
	a16
	lda.l	rdmpylr
	rtl
;=====================================================================
;*		Mulitply  Sin_8 * UnSin8			*
;* Input	:Acc 		:8 bit (sin)				*
;*	:kseki		:8 bit (unsin)				*
;* Out Put	:kseki		:8 bit	(sin)				*
;=====================================================================
	IFEQ	1
Mults8u8_l
	shorta
	longi
	phx
	bmi	.minus
.plas
	ldx	#0
	bra	.skip
.minus
	ldx	#1
	km_nega
.skip
	sta.l	wrmpya
	lda	kseki
	sta.l	wrmpyb
;8 cycle wait
	nop
	nop
	nop
	nop

	a16
	lda.l	rdmpylr
	dex
	bne	.skip2
	km_nega
.skip2
	sta	kseki
	a8
	plx
	rtl
	ENDC
;---------------------------------------------------------------------
;*		CPU Multiply  [sign 8bit/sign 8bit]		*
;* Init :kz_x1,kz_x2							*
;* Exit :kz_x1 or XReg						*
;* a16,i16								*
;---------------------------------------------------------------------
kcpumults8s8_l
	shorta
	longi
;* fugou check *
	ldx	#0
	lda	kz_x1
	eor	kz_x2
	bit	#$80
	beq	.plas
	dex
.plas	
;* fugou hanten (minus) *

	lda	kz_x1
	bpl	.plas_x1
	km_nega
	sta	kz_x1
.plas_x1

	lda	kz_x2
	bpl	.plas_x2
	km_nega
	sta	kz_x2
.plas_x2

	lda	kz_x1
	sta.l	wrmpya
	lda	kz_x2
	sta.l	wrmpyb
;8 cycle wait
	nop
	nop
	nop
	nop

	a16
	lda.l	rdmpylr
	inx
	bne	.plas1
	km_nega
.plas1
	sta	kz_x1
	tax
	a8
	rtl
;=====================================================================
;*								*
;*			DIVISION				*
;=====================================================================
;---------------------------------------------------------------------
;*		DIVISION [unsign 16bit/unsign 8bit]		*
;* Init :kz_x1 (warareru kazu), kz_y1 (waru kazu)			*
;* Exit :Acc (syou)							*
;* a16,i16								*
;---------------------------------------------------------------------
kdivu16u8_l
	longa
	longi
	lda	kz_x1
	sta.l	wrdivl	;warareru kazu
	a8
	lda	kz_y1
	sta.l	wrdivb	;waru kazu
	a16
;* 16 cycle wait *
	nop	;2
	nop	;4
	nop	;6
	nop	;8
	nop	;10
	nop	;12
	nop	;14
	nop	;16

	lda.l	rddivlr		;syou
	rtl
;---------------------------------------------------------------------
;*		DIVISION [unsign 16bit/unsign 8bit]		*
;* Init :Acc (warareru kazu), Xreg (waru kazu)			*
;* Exit :Xreg (syou) ,Yreg(amari)					*
;* a16,i16								*
;---------------------------------------------------------------------
kdivu16u8_sub_l
	longa
	longi

	sta.l	wrdivl	;warareru kazu
	txa
	a8
	sta.l	wrdivb	;waru kazu
	a16
;* 16 cycle wait *
	nop	;2
	nop	;4
	nop	;6
	nop	;8
	nop	;10
	nop	;12
	nop	;14
	nop	;16

	lda.l	rddivlr		;syou
	tax
	lda.l	rdmpylr		;amari
	tay
	rtl


;*******************************************************************
;	Divide unsigned 32 by unsigned 16
;*******************************************************************
;
;	u32/u16 ---> u32...u16
;
;
; <IN>		kz_wkdividend_L,2
;		kz_wkdividend_H,2
;		Y .... wkdivisor,2
; <OUT>		kz_wkdividend_L,2
;		kz_wkdividend_H,2
;		A ..... Residue
;
; dead 		Y
;
;-------------------------------------------------------------------
	LONGA
	LONGI
KDivide_u32u16_l				;mW:xW
	STY	kz_wkdivisor		;W
	LDY	#32			;W
	ROL	kz_wkdividend_L		;W
	ROL	kz_wkdividend_H		;W
	LDA	#0			;W
.u32u16_loop	ROL	A			;W
	CMP	kz_wkdivisor		;W
	BCC	.u32u16_skip
	SBC	kz_wkdivisor		;W
.u32u16_skip	ROL	kz_wkdividend_L		;W
	ROL	kz_wkdividend_H		;W
	DEY				;W
	BNE	.u32u16_loop
	RTL				;mW:xW
;-------------------------------------------------------------------
