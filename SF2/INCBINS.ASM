
	include	header.inc
	include	bgmacs.inc
	include	gamelist.inc

	incpub	incbins

;*********************************************************************
;*								*
;*		Watanabe's Graphic Area				*
;*								*
;*********************************************************************
	bank	18
msprites1	incbinfile	msprites\spt_01.bin
	bankend	18

	bank	19

	IFEQ	PAL
	ifne	janglish
msprites2	incbinfile	msprites\spt_23.bin
	elseif
msprites2	incbinfile	msprites\spt_23A.bin
	endc
	ELSEIF
msprites2	incbinfile	msprites\spt_23P.bin
	ENDC

	bankend	19

	bank	20
	IFEQ	PAL
	ifne	janglish
msprites3	incbinfile	msprites\spt_45.bin
	elseif
msprites3	incbinfile	msprites\spt_45a.bin
	endc
	ELSEIF
msprites3	incbinfile	msprites\spt_45p.bin
	ENDC
mworldspr	equ	msprites3
	bankend	20

;*********************************************************************
;*								*
;*		Arimoto's Graphic Area				*
;*								*
;*********************************************************************

	IFEQ	PAL
;=====================================================================
;*			Japanese Version			*
;=====================================================================
	ifne	janglish
	bank	21
	inccru	a0_ccr,data\a0.ccr
	inccru	a1_ccr,data\a1.ccr
	inccru	a2_ccr,data\a2.ccr
	inccru	a3_ccr,data\a3.ccr
	inccru	a4_ccr,data\a4.ccr
	inccru	a5_ccr,data\a5.ccr
	inccru	a6_ccr,data\a6.ccr
	inccru	a7_ccr,data\a7.ccr
	inccru	a15_ccr,data\a15.ccr

	bankend	21

	bank	22
	inccru	a11_ccr,data\a11.ccr
	inccru	a13_ccr,data\a13.ccr

	inccru	a0_pcr,data\a0.pcr
	inccru	a1_pcr,data\a1.pcr
	inccru	a2_pcr,data\a2.pcr
	inccru	a3_pcr,data\a3.pcr
	inccru	a5_pcr,data\a5.pcr
	inccru	a6_pcr,data\a6.pcr
	inccru	a10_pcr,data\a10.pcr
	inccru	a11_pcr,data\a11.pcr
	inccru	a4_pcr,data\a4.pcr
	inccru	a7_pcr,data\a7.pcr
	inccru	a8_ccr,data\a8.ccr
	inccru	a8_pcr,data\a8.pcr
	inccru	a9_pcr,data\a9.pcr
	inccru	a12_pcr,data\a12.pcr
	inccru	a13_pcr,data\a13.pcr
	inccru	a15_pcr,data\a15.pcr
	inccru	a18_pcr,data\a18.pcr

	inccru	w0_ccr,data\w0.ccr
	inccru	w1_ccr,data\w1.ccr
	inccru	e5_ccr,data\e5.ccr
	inccru	e6_ccr,data\e6.ccr
	inccru	e8_ccr,data\e8.ccr

	ifeq	kyear-95
	inccru	e9_ccr,data\e9.ccr
	endc
	ifeq	kyear-96
	inccru	e9_ccr,data\e9_96.ccr
	endc
	ifeq	kyear-97
	inccru	e9_ccr,data\e9_97.ccr
	endc

	bankend	22

	bank	23
	inccru	e0_ccr,data\e0.ccr
	inccru	e1_ccr,data\e1.ccr
	inccru	e2_ccr,data\e2.ccr
	inccru	e3_ccr,data\e3.ccr
	inccru	e7_ccr,data\e7.ccr
	inccru	b4_ccr,data\b4.ccr
	bankend	23

	bank	24

	incfile d3_3.asm
	incfile	sprdata.asm
	inccru	e4_ccr,data\e4.ccr
kawaguti_cgx	inccgx4	data\kawaguti.cgx,$30
	inccru	allcolscru,data\allcols.pac
keyscr_l	incfile	keyscr.asm

	inccru	b0_ccr,data\b0.ccr
	inccru	b1_ccr,data\b1.ccr
	inccru	b8_ccr,data\b8.ccr
	inccru	b12_ccr,data\b12.ccr
	bankend	24

	bank	25
	inccru	b7_ccr,data\b7.ccr
	inccru	b9_ccr,data\b9.ccr
	inccru	b14_ccr,data\b14.ccr
	inccru	b15_ccr,data\b15.ccr
	inccru	b16_ccr,data\b16.ccr

	inccru	b0_pcr,data\b0.pcr
	inccru	b1_pcr,data\b1.pcr
	inccru	b2_pcr,data\b2.pcr
	inccru	b3_pcr,data\b3.pcr
	inccru	b4_pcr,data\b4.pcr
	inccru	b5_pcr,data\b5.pcr
	inccru	b6_pcr,data\b6.pcr
	inccru	b7_pcr,data\b7.pcr
	inccru	b8_pcr,data\b8.pcr
	inccru	b10_pcr,data\b10.pcr
	inccru	b11_pcr,data\b11.pcr
	inccru	b12_pcr,data\b12.pcr
	inccru	b13_pcr,data\b13.pcr
	inccru	b14_pcr,data\b14.pcr
	inccru	b15_pcr,data\b15.pcr
	inccru	b16_pcr,data\b16.pcr
	incfile	mdata.mc
	bankend	25

;=====================================================================
;*			English Version				*
;=====================================================================
	elseif

	bank	21
	inccru	a0_ccr,data\a0.ccr
	inccru	a1_ccr,data\a1.ccr
	inccru	a2_ccr,data\a2.ccr
	inccru	a3_ccr,data\a3.ccr
	inccru	a4_ccr,data\a4.ccr
	inccru	a5_ccr,data\a5.ccr
	inccru	a6_ccr,data\a6.ccr
	inccru	a7_ccr,data\a7.ccr
	inccru	a15_ccr,data\a15.ccr

	bankend	21

	bank	22
	inccru	a11_ccr,data\a11.ccr
	inccru	a13_ccr,data\a13.ccr

	inccru	a0_pcr,data\a0.pcr
	inccru	a2_pcr,data\a2.pcr
	inccru	a3_pcr,data\a3.pcr
	inccru	a5_pcr,data\a5.pcr
	inccru	a6_pcr,data\a6.pcr
	inccru	a10_pcr,data\a10.pcr
	inccru	a4_pcr,data\a4.pcr
	inccru	a7_pcr,data\a7.pcr
	inccru	a8_ccr,data\a8.ccr
	inccru	a8_pcr,data\a8.pcr
	inccru	a9_pcr,data\a9.pcr
	inccru	a11_pcr,data\a11.pcr
	inccru	a13_pcr,data\a13.pcr
	inccru	a15_pcr,data\a15.pcr
	inccru	a18_pcr,data\a18.pcr

	inccru	w0_ccr,data\w0_a.ccr
	inccru	w1_ccr,data\w1_a.ccr
	inccru	e5_ccr,data\e5_a.ccr
	inccru	e6_ccr,data\e6_a.ccr
	inccru	e8_ccr,data\e8_a.ccr

	ifeq	kyear-95
	inccru	e9_ccr,data\e9_a.ccr
	endc
	ifeq	kyear-96
	inccru	e9_ccr,data\e9_a_96.ccr
	endc
	ifeq	kyear-97
	inccru	e9_ccr,data\e9_a_97.ccr
	endc

	inccru	b4_ccr,data\b4_a.ccr

	bankend	22

	bank	23
	inccru	e0_ccr,data\e0_a.ccr
	inccru	e2_ccr,data\e2_a.ccr
	inccru	e3_ccr,data\e3_a.ccr

	inccru	b1_ccr,data\b1_a.ccr
	inccru	b8_ccr,data\b8_a.ccr
	bankend	23

	bank	24
	inccru	e4_ccr,data\e4_a.ccr
	inccru	e7_ccr,data\e7_a.ccr
kawaguti_cgx	inccgx4	data\kawaguti.cgx,$30
	inccru	allcolscru,data\allcols.pac

	incfile d3_3.asm
	incfile	sprdata.asm
keyscr_l	incfile	keyscr.asm

	inccru	e1_ccr,data\e1_a.ccr

	inccru	b0_ccr,data\b0_a.ccr
	inccru	b12_ccr,data\b12_a.ccr

	inccru	a1_pcr,data\a1.pcr
	inccru	a12_pcr,data\a12.pcr
	bankend	24

	bank	25
	inccru	b7_ccr,data\b7_a.ccr
	inccru	b9_ccr,data\b9_a.ccr
	inccru	b14_ccr,data\b14_a.ccr
	inccru	b15_ccr,data\b15_a.ccr
	inccru	b16_ccr,data\b16_a.ccr

	inccru	b0_pcr,data\b0_a.pcr
	inccru	b1_pcr,data\b1_a.pcr
	inccru	b2_pcr,data\b2_a.pcr
	inccru	b3_pcr,data\b3_a.pcr
	inccru	b4_pcr,data\b4_a.pcr
	inccru	b5_pcr,data\b5_a.pcr
	inccru	b6_pcr,data\b6_a.pcr
	inccru	b7_pcr,data\b7_a.pcr
	inccru	b8_pcr,data\b8_a.pcr
	inccru	b10_pcr,data\b10_a.pcr
	inccru	b11_pcr,data\b11_a.pcr
	inccru	b12_pcr,data\b12_a.pcr
	inccru	b13_pcr,data\b13_a.pcr
	inccru	b14_pcr,data\b14_a.pcr
	inccru	b15_pcr,data\b15_a.pcr
	inccru	b16_pcr,data\b16_a.pcr

	incfile	mdata.mc
	bankend	25
	endc
;=====================================================================
;*			France Version				*
;=====================================================================
	ELSEIF

	bank	21
	inccru	a0_ccr,data\a0.ccr
	inccru	a1_ccr,data\a1.ccr
	inccru	a2_ccr,data\a2.ccr
	inccru	a3_ccr,data\a3.ccr
	inccru	a4_ccr,data\a4.ccr
	inccru	a5_ccr,data\a5.ccr
	inccru	a6_ccr,data\a6.ccr
	inccru	a7_ccr,data\a7.ccr
	inccru	a15_ccr,data\a15.ccr

	bankend	21

	bank	22
	inccru	a11_ccr,data\a11.ccr
	inccru	a13_ccr,data\a13.ccr

	inccru	a0_pcr,data\a0.pcr
	inccru	a1_pcr,data\a1.pcr
	inccru	a2_pcr,data\a2.pcr
	inccru	a3_pcr,data\a3.pcr
	inccru	a5_pcr,data\a5.pcr
	inccru	a6_pcr,data\a6.pcr
	inccru	a10_pcr,data\a10.pcr
	inccru	a11_pcr,data\a11.pcr
	inccru	a4_pcr,data\a4.pcr
	inccru	a7_pcr,data\a7.pcr
	inccru	a8_ccr,data\a8.ccr
	inccru	a8_pcr,data\a8.pcr
	inccru	a9_pcr,data\a9.pcr
	inccru	a13_pcr,data\a13.pcr
	inccru	a15_pcr,data\a15.pcr
	inccru	a18_pcr,data\a18.pcr

	inccru	w0_ccr,data\w0.ccr
	inccru	w1_ccr,data\w1.ccr
	inccru	e5_ccr,data\e5.ccr
	inccru	e6_ccr,data\e6.ccr
	inccru	e8_ccr,data\e8.ccr
	inccru	e9_ccr,data\e9.ccr

	bankend	22

	bank	23
	inccru	e0_ccr,data\e0.ccr
	inccru	e1_ccr,data\e1.ccr
	inccru	e2_ccr,data\e2.ccr
	inccru	e3_ccr,data\e3.ccr
	bankend	23

	bank	24

	incfile d3_3.asm
	incfile	sprdata.asm
	inccru	e4_ccr,data\e4.ccr
	inccru	e7_ccr,data\e7.ccr
kawaguti_cgx	inccgx4	data\kawaguti.cgx,$30
	inccru	allcolscru,data\allcols.pac
keyscr_l	incfile	keyscr.asm

	inccru	b0_ccr,data\b0.ccr
	inccru	b1_ccr,data\b1.ccr
	inccru	b4_ccr,data\b4.ccr
	inccru	b8_ccr,data\b8.ccr
	inccru	b12_ccr,data\b12.ccr
	bankend	24

	bank	25
	inccru	b7_ccr,data\b7.ccr
	inccru	b9_ccr,data\b9.ccr
	inccru	b14_ccr,data\b14.ccr
	inccru	b15_ccr,data\b15.ccr
	inccru	b16_ccr,data\b16.ccr

	inccru	b0_pcr,data\b0.pcr
	inccru	b1_pcr,data\b1.pcr
	inccru	b2_pcr,data\b2.pcr
	inccru	b3_pcr,data\b3.pcr
	inccru	b4_pcr,data\b4.pcr
	inccru	b5_pcr,data\b5.pcr
	inccru	b6_pcr,data\b6.pcr
	inccru	b7_pcr,data\b7.pcr
	inccru	b8_pcr,data\b8.pcr
	inccru	b10_pcr,data\b10.pcr
	inccru	b11_pcr,data\b11.pcr
	inccru	b12_pcr,data\b12.pcr
	inccru	b13_pcr,data\b13.pcr
	inccru	b14_pcr,data\b14.pcr
	inccru	b15_pcr,data\b15.pcr
	inccru	b16_pcr,data\b16.pcr
	incfile	mdata.mc
	bankend	25
	ENDC

	include	tail.inc
