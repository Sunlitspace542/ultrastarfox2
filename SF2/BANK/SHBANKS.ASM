	include	INC\header.inc
	include	INC\strathdr.inc

	include	INC\shmacs.inc
	include	INC\bgmacs.inc
	include	INC\marioi.inc

	INCPUB shbanks

do_hdr	=	0

;------------------------------------------------------------------
	bank	12
	incshapes	SHAPES\shapes.asm
	bankend	12
;------------------------------------------------------------------
	bank	13

	incshapes	SHAPES\pshapes.asm

	IFGT	(*&WM)-(bank13_split+$8000)	;$c000
	error	<Bank 13 overflow>
	ENDC

	bankend	13

;------------------------------------------------------------------
	bank	14
	incshapes	SHAPES\eshapes2.asm
	incshapes	SHAPES\pshapes3.asm
	bankend	14

;------------------------------------------------------------------
	bank	15
	incshapes	SHAPES\eshapes.asm
	bankend	15

;------------------------------------------------------------------
	bank	16
	incshapes	SHAPES\bshapes.asm
	incshapes	SHAPES\ushapes.asm
	incshapes	SHAPES\wshapes.asm
	bankend	16
;------------------------------------------------------------------
	bank	17
	incshapes	SHAPES\pshapes2.asm
	bankend	17

	bank	35
	incshapes	SHAPES\shapes2.asm
	bankend	35

	include	INC\tail.inc

