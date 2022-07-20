	include	INC\header.inc
	include	INC\shmacs.inc

	include	INC\stratmac.inc
	include	INC\stratlib.inc

	include	MARIO\mmacs.mc
	include	INC\marioi.inc

	include	INC\pathmacs.inc

;------------------------------------
	bank	0		;Bank 0

	db	0,0,0,0,0,0
	incfile	ASM\sgdata.asm

Do_HDR	=	1
	INCPUB	shapes

	incfile	SHAPES\ushapes.asm
	incfile	SHAPES\pshapes.asm
	incfile	SHAPES\pshapes2.asm
	incfile	SHAPES\pshapes3.asm
	incfile	SHAPES\shapes.asm
	incfile	SHAPES\shapes2.asm
	incfile SHAPES\bshapes.asm
	incfile SHAPES\wshapes.asm
	incfile SHAPES\eshapes.asm
	incfile SHAPES\eshapes2.asm


;------------------------------------------------------------
; relocated mario chip routines:

;	mario_on
;	mario_off
;------------------------------------------------------------



start	sei
	clc
	xce
	jmp.l	startboot


cop_ve
abort_ve
nmi_ve
irq_ve
cop_vn
reset_vn
break_vn
abort_vn
	rti


	bankend	0
	bank	32
	incfile	ASM\sgtabs.asm
	incfile	ASM\istrats.asm
	incfile	ASM\blink.asm

	bankend	32
	org    $00ffb0,$7fb0

    db    $30,$31,$58,$4a,$20,$20,$00,$00
    db    $00,$00,$00,$00,$00,$06,$00,$00

	run	" db %q%$version_name%q"

	IFEQ	JANGLISH

	IFEQ	PAL
; american
	db	$20,$15,$0a,$0,$1,$1,$0,$ff,$ff,$0,$0
	ELSEIF

	IFEQ	GERMAN+FRENCH
; british
	db	$20,$15,$0a,$0,$2,$1,$0,$ff,$ff,$0,$0

	ENDC

	IFNE	GERMAN
; german
	db	$20,$15,$0a,$0,$9,$1,$0,$ff,$ff,$0,$0
	ENDC

	IFNE	FRENCH
; france
	db	$20,$15,$0a,$0,$6,$1,$0,$ff,$ff,$0,$0
	ENDC

	ENDC

	ELSEIF

	db	$20,$15,$0a,$0,$0,$1,$0,$ff,$ff,$0,$0

	ENDC

;------------------------------------

;Hardware Vectors	-------------------------
	org	$00ffe4,$7fe4
	dw	cop_vn&WM
	dw	break_vn&WM
	dw	abort_vn&WM
	dw	$0108
	dw	$0000
	dw	$010c

	org	$00fff4,$7ff4
	dw	cop_ve&WM
	dw	0
	dw	abort_ve&WM
	dw	nmi_ve&WM
	dw	start&WM
	dw	irq_ve&WM



;------------------------------------


	include	INC\tail.inc


