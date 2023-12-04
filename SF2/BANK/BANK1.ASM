	

	include	INC\header.inc
	include	INC\marioi.inc
  	include	INC\shmacs.inc
	include	INC\gridvars.inc

	include	INC\stratequ.inc



	incpub	mario
	incpub	mslopes

;------------------------------------------------------------------
	bank	1

	mario_on
     	incfile	MARIO\mmacs.mc
	incfile	MARIO\mshtab.mc	; must be at start of bank
	mario_off

	incfile	ASM\coltabs.asm

rztab
mariobegin
yyy	mario_on

; Mario register defs ------------------------
rsp	equr	10
rlink	equr	11
;---------------------------------------------

	incfile	MARIO\mmaths.mc
	incfile	MARIO\mwrot.mc
	incfile	MARIO\mwcrot.mc
	incfile	MARIO\mobj.mc
	incfile	MARIO\mclip.mc
	incfile	MARIO\mtxtclp.mc
;	incfile	MARIO\mdrawc.mc
	incfile	MARIO\mdrawp.mc
	incfile	MARIO\msprite.mc
	incfile	MARIO\mgdots.mc
	incfile	MARIO\mcircle.mc
	incfile	MARIO\mdrawlis.mc
	incfile	MARIO\mdecru.mc
	incfile	MARIO\mtxtprt.mc
	incfile	MARIO\mplanet.mc
	incfile	MARIO\mdsprite.mc
;	incfile	MARIO\mhofs.mc		;Kristers .mc files
	incfile	MARIO\mpart.mc
	incfile	MARIO\mbumwipe.mc
	incfile	MARIO\mhud.mc
	incfile	MARIO\mhofs.mc
	incfile	MARIO\mdebug.mc
	incfile	MARIO\mplanclp.mc
	incfile	MARIO\mboxes.mc
	incfile	MARIO\mslopes.mc
	mario_off


	incfile	ASM\fontdata.asm

mariocodelen	=	*-mariobegin

oopspal	;incbin	data\oops.pal
oopschr	;incbin	data\oops.chr
oopspic	;incbin	data\oops.pic

	bankend	1


	include	INC\tail.inc


