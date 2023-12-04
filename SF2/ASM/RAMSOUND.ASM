;=====================================================================
;*			Set BGM Sound				*
;=====================================================================

	incpub	ramsound

kbgm_l
	PHX
	php
	ai8
	sta	bgm_music	;sound No set
	stz	bgmcnt		;BGM SET ENABLE

	IFEQ	1
	beq	.skip
	cmp	#4
	bcs	.skip
	sta	bgm_back
.skip
	stz	bgmcnt		;BGM SET ENABLE
	ENDC

	IFEQ	1
	ldx	bgm_musicptr_limt
	sta	bgm_music,x	;sound No set
	txa
	inc	a
	and	#3
	sta	bgm_musicptr_limt
	ENDC

	plp
	PLX
	rtl
;=====================================================================
;*		Set Level Sound (port2) Data			* 
;* Init :Acc
;* Exit
;=====================================================================
	shorta
	longi
setport2_l
	sta	sdport2
	rtl

;=====================================================================
;*	Set Trigger Sound (port3) Data to Buffer		* 
;* Init,EXIT :ai16							*
;=====================================================================
	longa
	longi
setport3_l
	phx
	ldx	sdspt3
	sta	sdport3,x
	a8
	txa
	inc	a
	inc	a
	and	#$1f
	sta	sdspt3

	a16
	plx
	rtl

