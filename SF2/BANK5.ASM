

	include	header.inc
	include	mapmacs.inc

	include	stratequ.inc
	include	mapstructs.inc

	include	bgmacs.inc
	include	marioi.inc



real_istrats =	0
	include	istrats.asm


;------------------------------------------------------------------
	bank	5
	incfile	maps\maplist.asm
	bankend	5
;------------------------------------------------------------------
	bank	13

	bankend	13
;------------------------------------------------------------------



	include	tail.inc


