	incpub	fonts

smallfont
	incbinfile	FONT\font_1.bin
largefont
;	incbinfile	FONT\font_0.bin
normalfont
	IFEQ	JANGLISH
	IFNE	aeongenesis
	incbinfile	FONT\mmag.bin
	fileslog	FONT\mmag.bin
	ELSEIF
	incbinfile	FONT\mme.bin
	fileslog	FONT\mme.bin
	ENDC
	ELSEIF
	incbinfile	FONT\mmj.bin
	fileslog	FONT\mmj.bin
	ENDC

displayfont
	incbinfile	FONT\mf.bin

atozfont	incbinfile	FONT\atoz.bin

