	include	header.inc
	include	marioi.inc
	include	stratmac.inc
	include	stratlib.inc
	include	bgmacs.inc

	include	mapstructs.inc
	include	mapmacs.inc
	include	shmacs.inc

	include	gamelist.inc

;-------------------------------------------------------
	bank	2

	IFND	COMPRESS_XROUTINES


	incfile	ramstuff.asm

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
	incfile	trans.asm
	incfile	main.asm
	incfile	game.asm
	incfile	obj.asm
	incfile	planets.asm
	incfile	world.asm
	incfile	sysstrat.asm
	incfile	stratrou.asm
	incfile	nmi.asm

	incfile	screen.asm
	incfile	intro.asm
	incfile	bgs.asm
	incfile	windows.asm
	incfile	sound.asm

	incfile	draw.asm
	incfile	mapscr.asm

	incfile	debug.asm
	incfile	bootnmi.asm
	incfile	kcalc.asm
	incfile	titlesub.asm

	bankend	3
;------------------------------------------------------------------


	include	tail.inc




