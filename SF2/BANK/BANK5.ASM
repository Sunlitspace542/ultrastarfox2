

	include	INC\header.inc
	include	INC\mapmacs.inc

	include	INC\stratequ.inc
	include	INC\mapstructs.inc

	include	INC\bgmacs.inc
	include	INC\marioi.inc



real_istrats =	0
	include	STRAT\istrats.asm


;------------------------------------------------------------------
	bank	5
	incfile	maps\maplist.asm
	bankend	5
;------------------------------------------------------------------
	bank	13

	bankend	13
;------------------------------------------------------------------



	include	INC\tail.inc


