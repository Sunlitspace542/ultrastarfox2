
	include	header.inc
	include	strathdr.inc
	include	bgmacs.inc
	include	scalevar.inc

	include	yajima.inc
	include	shmacs.inc

	bank	11

	incfile	coltabs.asm

this_bank	=	*&$ff0000

	incfile oamlist.asm
	incfile	oamdata.asm

	incfile d4_0.asm
	incfile d4_1.asm
	incfile	d2_0.asm
	incfile	d2_1.asm
	incfile	d2_2.asm
	incfile	d2_3.asm
	incfile	d2_4.asm
	incfile	d2_5.asm
	incfile	d2_6.asm
	incfile	d2_7.asm

	incfile	wipe.asm
	incfile	missobj.asm
	incfile	gameover.asm
	incfile	continue.asm
	incfile gameobj.asm
	incfile hell.asm
	incfile pselect.asm

	bankend	11

	include	tail.inc


