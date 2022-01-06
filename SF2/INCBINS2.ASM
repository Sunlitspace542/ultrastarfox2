;*********************************************************************
;			sound files list 
;		(NTSC or PAL & JAPANESE or ENGLISH)
;			1995. 7. 3(MON)
;*********************************************************************
;
	include	header.inc
	include	bgmacs.inc

	incpub	incbins2

;------------------------------------------------------------------

firstsndbnk	=	26
musicsize	=	0

	incsnd	fox2snd,sound\fox2snd.bin
	incsnd	sdse1,sound\sdse1.bin
	incsnd	sdse2,sound\sdse2.bin

	incsnd	ffset1,sound\ffset1.bin
	incsnd	ffset2,sound\ffset2.bin
	incsnd	spset1,sound\spset1.bin
	incsnd	spset2,sound\spset2.bin
	incsnd	ggset1,sound\ggset1.bin
	incsnd	ggset2,sound\ggset2.bin

	incsnd	foxvox,sound\foxvox.bin
	incsnd	falvox,sound\falvox.bin
	incsnd	pepvox,sound\pepvox.bin
	incsnd	slpvox,sound\slpvox.bin
	incsnd	ga1vox,sound\ga1vox.bin
	incsnd	ga2vox,sound\ga2vox.bin


	ifeq	PAL
;**** music for NTSC ****
	incsnd	music01,sound\music01.bin
	incsnd	music02,sound\music02.bin
	incsnd	music03,sound\music03.bin
	incsnd	music04,sound\music04.bin
	incsnd	music05,sound\music05.bin
	incsnd	music06,sound\music06.bin
	incsnd	music07,sound\music07.bin
	incsnd	music08,sound\music08.bin
	incsnd	music09,sound\music09.bin
	incsnd	music10,sound\music10.bin
	incsnd	music11,sound\music11.bin
	incsnd	music12,sound\music12.bin
	incsnd	music13,sound\music13.bin
	incsnd	music14,sound\music14.bin
	incsnd	music15,sound\music15.bin
	incsnd	music16,sound\music16.bin
	incsnd	music17,sound\music17.bin
	incsnd	music18,sound\music18.bin
	incsnd	music18b,sound\music18b.bin
	incsnd	music19,sound\music19.bin
	incsnd	music20,sound\music20.bin
	incsnd	music21,sound\music21.bin
	incsnd	music22,sound\music22.bin
	incsnd	music23,sound\music23.bin
	incsnd	music24,sound\music24.bin
	incsnd	music25,sound\music25.bin

	elseif
;**** music for PAL ****
	incsnd	music01,sound\m01_p.bin
	incsnd	music02,sound\m02_p.bin
	incsnd	music03,sound\m03_p.bin
	incsnd	music04,sound\m04_p.bin
	incsnd	music05,sound\m05_p.bin
	incsnd	music06,sound\m06_p.bin
	incsnd	music07,sound\m07_p.bin
	incsnd	music08,sound\m08_p.bin
	incsnd	music09,sound\m09_p.bin
	incsnd	music10,sound\m10_p.bin
	incsnd	music11,sound\m11_p.bin
	incsnd	music12,sound\m12_p.bin
	incsnd	music13,sound\m13_p.bin
	incsnd	music14,sound\m14_p.bin
	incsnd	music15,sound\m15_p.bin
	incsnd	music16,sound\m16_p.bin
	incsnd	music17,sound\m17_P.bin
	incsnd	music18,sound\m18_p.bin
	incsnd	music18b,sound\m18b_p.bin
	incsnd	music19,sound\m19_p.bin
	incsnd	music20,sound\m20_p.bin
	incsnd	music21,sound\m21_p.bin
	incsnd	music22,sound\m22_p.bin
	incsnd	music23,sound\m23_p.bin
	incsnd	music24,sound\m24_p.bin
	incsnd	music25,sound\m25_p.bin
	endc

	incsnd	sdgrd1,sound\sdgrd1.bin
	incsnd	sdgrd2,sound\sdgrd2.bin
	incsnd	sdgrd3,sound\sdgrd3.bin
	incsnd	sdend1,sound\sdend1.bin
	incsnd	sdspac,sound\sdspac.bin

	incsnd	sdcnt,sound\sdcnt.bin
;	incsnd	sdopn,sound\sdopn.bin
	incsnd	sdovr,sound\sdovr.bin
;	incsnd	sdad1,sound\sdad1.bin
	incsnd	sddis,sound\sddis.bin

	ifne	janglish
	incsnd	sdtlk,sound\sdtlk.bin
	elseif
	incsnd	sdtlk,sound\sdtlk2.bin
	endc

	incsnd	sdinf,sound\sdinf.bin
	incsnd	sdst1,sound\sdst1.bin
	incsnd	sdst2,sound\sdst2.bin
	incsnd	sdst3,sound\sdst3.bin
	incsnd	sdst4,sound\sdst4.bin
	incsnd	sdst5,sound\sdst5.bin
	incsnd	sdst6,sound\sdst6.bin
	incsnd	sdst7,sound\sdst7.bin
;	incsnd	sdst8,sound\sdst8.bin
;	incsnd	sdst9,sound\sdst9.bin

	incsnd	grdwtr,sound\grdwtr.bin
	incsnd	vlcwtr,sound\vlcwtr.bin
	incsnd	seawtr,sound\seawtr.bin
	incsnd	mapse,sound\mapse.bin



	ifgt	@-$100000
	PRINTF	"%N%N  MORE THAN 8 MEGA-BITS OF ROM USED!! %N%N"
	FAIL
	endc

	include	tail.inc



