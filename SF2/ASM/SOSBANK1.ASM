
	include	INC\header.inc
	include	INC\strathdr.inc
	include	INC\bgmacs.inc
	include	INC\scalevar.inc

	include	INC\yajima.inc
	include	INC\shmacs.inc

	bank	11

	incfile	ASM\coltabs.asm

this_bank	=	*&$ff0000

	incfile ASM\oamlist.asm
	incfile	ASM\oamdata.asm

	incfile ASM\d4_0.asm
	incfile ASM\d4_1.asm
	incfile	ASM\d2_0.asm
	incfile	ASM\d2_1.asm
	incfile	ASM\d2_2.asm
	incfile	ASM\d2_3.asm
	incfile	ASM\d2_4.asm
	incfile	ASM\d2_5.asm
	incfile	ASM\d2_6.asm
	incfile	ASM\d2_7.asm

	incfile	ASM\wipe.asm
	incfile	ASM\missobj.asm
	incfile	ASM\gameover.asm
	incfile	ASM\continue.asm
	incfile ASM\gameobj.asm
	incfile ASM\hell.asm
	incfile ASM\pselect.asm

	bankend	11

	include	INC\tail.inc


