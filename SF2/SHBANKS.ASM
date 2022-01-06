	include	header.inc
	include	strathdr.inc

	include	shmacs.inc
	include	bgmacs.inc
	include	marioi.inc

	INCPUB shbanks

do_hdr	=	0

;------------------------------------------------------------------
	bank	12
	incshapes	shapes.asm
	bankend	12
;------------------------------------------------------------------
	bank	13

	incshapes	pshapes.asm

	IFGT	(*&WM)-(bank13_split+$8000)	;$c000
	error	<Bank 13 overflow>
	ENDC

	bankend	13

;------------------------------------------------------------------
	bank	14
	incshapes	eshapes2.asm
	incshapes	pshapes3.asm
	bankend	14

;------------------------------------------------------------------
	bank	15
	incshapes	eshapes.asm
	bankend	15

;------------------------------------------------------------------
	bank	16
	incshapes	bshapes.asm
	incshapes	ushapes.asm
	incshapes	wshapes.asm
	bankend	16
;------------------------------------------------------------------
	bank	17
	incshapes	pshapes2.asm
	bankend	17

	bank	35
	incshapes	shapes2.asm
	bankend	35

	include	tail.inc

