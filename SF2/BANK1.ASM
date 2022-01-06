	

	include	header.inc
	include	marioi.inc
  	include	shmacs.inc
	include	gridvars.inc

	include	stratequ.inc



	incpub	mario

;------------------------------------------------------------------
	bank	1

	mario_on
     	incfile	mmacs.mc
	incfile	mshtab.mc	; must be at start of bank
	mario_off

	incfile	coltabs.asm

rztab
mariobegin
yyy	mario_on

; Mario register defs ------------------------
rsp	equr	10
rlink	equr	11
;---------------------------------------------

	incfile	mmaths.mc
	incfile	mwrot.mc
	incfile	mwcrot.mc
	incfile	mobj.mc
	incfile	mclip.mc
	incfile	mtxtclp.mc
;	incfile	mdrawc.mc
	incfile	mdrawp.mc
	incfile	msprite.mc
	incfile	mgdots.mc
	incfile	mcircle.mc
	incfile	mdrawlis.mc
	incfile	mdecru.mc
	incfile	mtxtprt.mc
	incfile	mplanet.mc
	incfile	mdsprite.mc
;	incfile	mhofs.mc		;Kristers .mc files
	incfile	mpart.mc
	incfile	mbumwipe.mc
	incfile	mhud.mc
	incfile	mhofs.mc
	incfile	mdebug.mc
	incfile	mplanclp.mc
	incfile	mboxes.mc
	incfile	mslopes.mc
	mario_off


	incfile	fontdata.asm

mariocodelen	=	*-mariobegin

oopspal	;incbin	data\oops.pal
oopschr	;incbin	data\oops.chr
oopspic	;incbin	data\oops.pic

	bankend	1


	include	tail.inc


