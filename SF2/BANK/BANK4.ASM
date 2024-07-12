 	
	include	INC\header.inc
	include	INC\marioi.inc
	include	INC\stratmac.inc
	include	INC\stratlib.inc
	include	INC\bgmacs.inc
	include	INC\shmacs.inc
	include	INC\gamelist.inc
	include	EXT\BANK.EXT

	bank	4
;---------- Kawaguchi -------------
	incfile	ASM\sprites.asm
	incfile	ASM\kscreen.asm
	incfile	ASM\mismap.asm
	incfile	ASM\mismapsub.asm
	incfile	ASM\rammismap.asm
	incfile	ASM\title.asm
	incfile	ASM\hvscroll.asm
	bankend	4

	include	INC\tail.inc


