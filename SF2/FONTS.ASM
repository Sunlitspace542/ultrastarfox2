smallfont
	incbinfile	font_1.bin
largefont
;	incbinfile	font_0.bin
normalfont
	IFEQ	JANGLISH
	incbinfile	mme.bin
	fileslog	mmj.bin
	ELSEIF
	incbinfile	mmj.bin
	fileslog	mme.bin
	ENDC

displayfont
	incbinfile	mf.bin

atozfont	incbinfile	atoz.bin

