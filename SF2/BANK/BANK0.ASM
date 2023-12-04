	include	INC\header.inc
	include	INC\shmacs.inc

	include	INC\stratmac.inc
	include	INC\stratlib.inc

	include	MARIO\mmacs.mc
	include	INC\marioi.inc

	include	INC\pathmacs.inc


	incpub	bank
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
	incfile	STRAT\istrats.asm
	incfile	ASM\blink.asm
	IFNE	janglish
	inccru	e6_ccr,data\e6.ccr
	inccru	e8_ccr,data\e8.ccr
	inccru	e7_ccr,data\e7.ccr
	inccru	b4_ccr,data\b4.ccr
	ENDC
	bankend	32
	
	;; ROM HEADER

	org $00ffb0,$7fb0
	db	"01"				; Maker Code
	db	"XJ  "				; Game Code
	db	0,0,0,0,0,0,0		; Fixed Value
	db	6					; Expansion RAM Size (5 = 32kbyte, 6 = 64kbyte)
	db	0					; Special Version
	db	0					; Cartridge Type (Sub-number)

	org	$00ffc0,$7fc0

	run	" db %q%$version_name%q" ; Game Name

	; hardware info
	db	$20					; Map Mode (20 = SlowROM, 30 = FastROM) LoROM
	db	$15					; Cartridge Type
							 ; (13) Super FX 1 (StarFox 1)
							 ; (14) Super FX 2 (DOOM)
							 ; (15) Battery + Super FX 2 (Yoshi's Island, StarFox 2)
							 ; (1A) Battery + Super FX 1 (Stunt Race FX)
	db	$0a					; ROM Size (0A = 8mbit, 0B = 16mbit)
	db	$00					; RAM Size (if 0, use exp RAM size above)
	db	hdr_region			; Destination Code (from below)
	db	$33					; Fixed Value
	db	$00					; Mask ROM Version
	dw	$ffff				; Compliment Check
	dw	$0000				; Check Sum

	; region/destination codes
	IFEQ	JANGLISH

	IFEQ	PAL
; american
hdr_region	equ	$01	; Destination Code (USA)
	ELSEIF

	IFEQ	GERMAN+FRENCH
; british
hdr_region	equ	$2	; Destination Code (PAL)

	ENDC

	IFNE	GERMAN
; german
hdr_region	equ	$9	; Destination Code (GER)
	ENDC

	IFNE	FRENCH
; france
hdr_region	equ	$6 ; Destination Code (FRA)
	ENDC

	ENDC

	ELSEIF
hdr_region	equ	$0	; Destination Code (JPN)

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
