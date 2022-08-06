	include	INC\header.inc
	include	INC\strathdr.inc
	include	INC\marioi.inc
	include	INC\shmacs.inc
;------------------------------------------------------------------
	bank	6
	incfile	ASM\tstrats.asm
	incfile	INC\players.inc
	incfile	ASM\player.asm
	incfile	ASM\kplayer.asm
	incfile	ASM\tplayer.asm
	incfile	ASM\gakki.asm

	bankend	6

	bank	36
	incfile	ASM\egdata.asm
	bankend	36

	include	INC\tail.inc



