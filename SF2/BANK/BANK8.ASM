

	include	INC\header.inc
	include	INC\strathdr.inc
	include	INC\bgmacs.inc
	include	INC\marioi.inc
	include	INC\shmacs.inc
	include	INC\gamelist.inc

;------------------------------------------------------------------
	bank	8
	incfile	PATH\paths.asm
	bankend	8

	bank	9
	incfile	PATH\paths2.asm
	bankend 9


	bank	13

	org	((13)*$10000)+(bank13_split+$8000),$8000*13+bank13_split	;$4000

	incfile	ASM\slopes.asm
	incfile	ASM\chart.asm
	incfile	ASM\mapcode.asm
	incfile	ASM\weapons.asm

	incfile	ASM\fonts.asm
	incfile	ASM\result.asm

	incfile	INC\arctan.inc

	bankend	13

;------------------------------------------------------------------

	printf	"TOTALSAVED=",totalsaved,"%n"

	include	INC\tail.inc



