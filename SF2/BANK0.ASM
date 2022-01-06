	include	header.inc
	include	shmacs.inc

	include	stratmac.inc
	include	stratlib.inc

	include	mmacs.mc
	include	marioi.inc

	include	pathmacs.inc

;------------------------------------
	bank	0		;Bank 0

	db	0,0,0,0,0,0
	incfile	sgdata.asm

Do_HDR	=	1
	INCPUB	shapes

	incfile	ushapes.asm
	incfile	pshapes.asm
	incfile	pshapes2.asm
	incfile	pshapes3.asm
	incfile	shapes.asm
	incfile	shapes2.asm
	incfile bshapes.asm
	incfile wshapes.asm
	incfile eshapes.asm
	incfile eshapes2.asm


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
	incfile	sgtabs.asm
	incfile	istrats.asm
	incfile	blink.asm
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


	include	tail.inc


