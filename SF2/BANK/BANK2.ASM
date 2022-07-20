	include	INC\header.inc
	include	INC\marioi.inc
	include	INC\stratmac.inc
	include	INC\stratlib.inc
	include	INC\bgmacs.inc

	include	INC\mapstructs.inc
	include	INC\mapmacs.inc
	include	INC\shmacs.inc

	include	INC\gamelist.inc

;-------------------------------------------------------
	bank	2

	IFND	COMPRESS_XROUTINES


	incfile	ASM\ramstuff.asm

	ELSEIF

;	incpublics	xroutines.ext
;	include		xroutines.sym
;	incbin		xroutines.bin

	ENDC

;----------------------------------------------------------------
; NO FILES SHOULD BE PLACED BETWEEN HERE AND THE END OF THE BANK!

	bankend	2

;------------------------------------------------------------------
	bank	3
planetdmapos1	dw	228
planetdmapos2	dw	100
	incfile	ASM\trans.asm
	incfile	ASM\main.asm
	incfile	ASM\game.asm
	incfile	ASM\obj.asm
	incfile	ASM\planets.asm
	incfile	ASM\world.asm
	incfile	ASM\sysstrat.asm
	incfile	ASM\stratrou.asm
	incfile	ASM\nmi.asm

	incfile	ASM\screen.asm
	incfile	ASM\intro.asm
	incfile	ASM\bgs.asm
	incfile	ASM\windows.asm
	incfile	ASM\sound.asm

	incfile	ASM\draw.asm
	incfile	ASM\mapscr.asm

	incfile	ASM\debug.asm
	incfile	ASM\bootnmi.asm
	incfile	ASM\kcalc.asm
	incfile	ASM\titlesub.asm

	bankend	3
;------------------------------------------------------------------


	include	INC\tail.inc




