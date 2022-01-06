

	include	header.inc
	include	strathdr.inc
	include	bgmacs.inc
	include	marioi.inc
	include	shmacs.inc
	include	gamelist.inc

;------------------------------------------------------------------
	bank	8
	incfile	paths.asm
	bankend	8

	bank	9
	incfile	paths2.asm
	bankend 9


	bank	13

	org	((13)*$10000)+(bank13_split+$8000),$8000*13+bank13_split	;$4000

	incfile	slopes.asm
	incfile	chart.asm
	incfile	mapcode.asm
	incfile	weapons.asm

	incfile	fonts.asm
	incfile	result.asm

	incfile	data\arctan.asm

	bankend	13

;------------------------------------------------------------------

	printf	"TOTALSAVED=",totalsaved,"%n"

	include	tail.inc



