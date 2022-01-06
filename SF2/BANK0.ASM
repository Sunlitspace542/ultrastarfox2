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

	incfile	blink.asm

	incfile	sgtabs.asm
	incfile	sgdata.asm

	incfile	istrats.asm

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

	org    $00ffb0,$7fb0

    db    $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db    $ff,$ff,$ff,$ff,$ff,$06,$ff,$00

	run	" db %q%$version_name%q"

	IFEQ	JANGLISH

	IFEQ	PAL
; american
	db	$20,$15,$a,$0,$1,$1,$0,$ff,$ff,$0,$0
	ELSEIF

	IFEQ	GERMAN+FRENCH
; british
	db	$20,$15,$a,$0,$2,$1,$0,$ff,$ff,$0,$0

	ENDC

	IFNE	GERMAN
; german
	db	$20,$15,$a,$0,$9,$1,$0,$ff,$ff,$0,$0
	ENDC

	IFNE	FRENCH
; france
	db	$20,$15,$a,$0,$6,$1,$0,$ff,$ff,$0,$0
	ENDC

	ENDC

	ELSEIF

	db	$20,$15,$a,$0,$0,$1,$0,$ff,$ff,$0,$0

	ENDC

;------------------------------------

;Hardware Vectors	-------------------------
	org	$00ffe4,$7fe4
	dw	cop_vn
	dw	break_vn
	dw	abort_vn
	dw	$0108
	dw	$0000
	dw	$010c

	org	$00fff4,$7ff4
	dw	cop_ve
	dw	0
	dw	abort_ve
	dw	nmi_ve
	dw	start
	dw	irq_ve



;------------------------------------


	include	tail.inc


