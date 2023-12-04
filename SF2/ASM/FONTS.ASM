	incpub	fonts

smallfont
	incbinfile	FONT\font_1.bin
largefont
;	incbinfile	FONT\font_0.bin
normalfont
	IFEQ	JANGLISH
	incbinfile	FONT\mme.bin
	fileslog	FONT\mmj.bin
	ELSEIF
	incbinfile	FONT\mmj.bin
	fileslog	FONT\mme.bin
	ENDC

displayfont
	incbinfile	FONT\mf.bin

atozfont	incbinfile	FONT\atoz.bin

