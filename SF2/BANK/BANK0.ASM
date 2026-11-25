	include	INC\header.inc
	include	INC\shmacs.inc

	include	INC\stratmac.inc
	include	INC\stratlib.inc

	include	MARIO\mmacs.mc
	include	INC\marioi.inc

	include	INC\pathmacs.inc


	incpub	bank
;------------------------------------
; Write BANKS.CSV header
	fopen	+BANKS.CSV
	printf	"Bank number,Bytes free%n"
	fclose	BANKS.CSV
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

cop_vn
break_vn
	IFNE usenewblink
	jml	newblink
	ENDC

cop_ve
abort_ve
nmi_ve
nmi_vn
irq_ve
reset_vn
abort_vn
	rti


	bankend	0
	bank	32
	incfile	ASM\sgtabs.asm
	incfile	STRAT\istrats.asm
	IFEQ usenewblink
	incfile	ASM\blink.asm
	ELSEIF	;IFNE	usenewblink
	incfile	ASM\newblink.asm
	ENDC
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
	IFEQ	RUMBLE
	db	0					; Cartridge Type (Sub-number)
	ELSEIF
	db	'R'					; Rumble controller support
	ENDC

	org	$00ffc0,$7fc0

	run	" db %q%$version_name%q" ; Game Name

	; hardware info
	db	$20					; Map Mode (20 = SlowROM, 30 = FastROM) LoROM
	IFEQ	SUPERFX3
	db	$15					; Cartridge Type
	ELSEIF
	db	$18
	ENDC
							 ; (13) MARIO Chip 1 / Super FX 1 (StarFox 1)
							 ; (14) Super FX 2 (DOOM)
							 ; (15) Battery + Super FX 2 (Yoshi's Island, StarFox 2)
							 ; (17) Super FX 3 (The Ultimate DOOM)
							 ; (18) Super FX 3 + Battery
							 ; (1A) Battery + Super FX 1 (Stunt Race FX
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

;Hardware Vectors--------------------

	;Native (65816 Mode)
	org	$00ffe4,$7fe4
	dw	cop_vn&WM			; COP
	dw	break_vn&WM			; BRK
	dw	abort_vn&WM			; ABORT
	dw	nmi_vn&WM			; NMI
	dw	$0000				; unused (would be RESET, but the SNES always boots in Emulation mode)
	dw	$010C				; IRQ

	;Emulation (6502 Mode)
	org	$00fff4,$7ff4
	dw	cop_ve&WM			; COP
	dw	$00					; unused (would be BRK, but BRK and IRQ share the same vector in Emulation mode)
	dw	abort_ve&WM			; ABORT
	dw	nmi_ve&WM			; NMI
	dw	start&WM			; RESET
	dw	irq_ve&WM			; IRQ/BRK

;------------------------------------


	include	INC\tail.inc


