;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         SOUND.ASM                              	       ;
; AUTHOR:       YASUHIRO KAWAGUCHI                                  ;
; DESCRIPTION:  Code for sound                        	       ;
; DATE CREATED: 28-7-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;

	INCPUB	sound

;TransferSoundProg_l,TransferSoundBGM_l,TransferSoundPlayer_l
;*********************************************************************
;*			Initial Sound 				*
;*	Sound Transfer						*
;*Acc  :Sound Data Bank						*
;*Yreg :Sound Data Address						*
;*********************************************************************
;=====================================================================
;*		Sound Program Transfer				*
;*Data Bank 0							*
;*Input:Acc	:sound data bank					*
;*     ;Yreg	:sound data address					*
;=====================================================================
TransferSoundProg_l
	shorta
	longi
	phb
	phx
	php

	km_db0				;Acc Keep
	jsl	sbootapu_l		;sound transfer

	plp
	plx
	plb
	rtl
;=====================================================================
;*								*
;*	Transfer Sound BGM Data & Ring BGM			*
;*Data Bank0								*
;*Input:								*
;*	:Xreg :sound table pointer				*
;=====================================================================
TransferSoundBGM_l
	shorta
	longi

	km_PushAllReg
	db0		;Data Bank 0

;* port clear *
	stz	apu_port0
	stz	apu_port1
	stz	apu_port2
	stz	apu_port3

;* port 0 *
	stz	bgm_musicptr
	stz	bgm_musicptr_limt
	stz	bgmcnt

;;	stz	bgm_music
;;;	stz	bgm_back

	a16

;* port2 initial (16 bit mode) *
	stz	sdchkptr2	;check alien pointer
	stz	sdchkptr2tmp	;tmp check alien pointer
	stz	sdbakptr2	;back alien pointer

;* port3 initial (16 bit mode) *
	stz	sdgpt3	;(sdgpt3 ... SOUND DATA wo SET surutameno POINTER)
	stz	sdspt3	;(sdspt3 ... SOUND DATA wo buffer ni touroku suru tameno POINTER)

;* port1,2 (8 bit mode) *
	a8
	stz	sdport1		;sound port 2
	stz	sdport2		;sound port 2
	stz	sdport2tmp	;tmp sound port 2
	stz	sdbakport2	;back sound port 2

	stz	sdchkno2	;check sound No
	stz	sdchkno2tmp	;tmp check sound No
	sta	sdbakno2	;back sound No
;* port 3 (8 bit mode) *
	stz	sdpck3	;(sdpck3 ... before sound)

;*************** Stereo or Monoral ******************************
	km_bitchecksndflag	sndmode
	beq	.stereo
	km_clrsndflag	sndmode
	lda	monoral		;conf_sound
	beq	.stereo
	jsl	Stereo_l
.stereo

;***************** Ending Mode **********************************
	km_cmpcheckgamemode	demo
	bne	.notending
	km_cmpcheck	kw_DemoNumber,kdemo_endingdemo
	bne	.notending
	ksound	trig_se_unable
.notending

;**** BGM No Set *****
	a8
;* flag dakewa sound file ga nakutemo set !! *
	ldx	kw_setsndaddr
	lda.l	SoundTransTbl+1,x	;sound flag (port0)
	and	#$f
	beq	.NoBGM
	KBGM_a				;BGM set
.NoBGM

;* Sound Flag (MISSION/BATTLE) *
	shorta
	km_cmpcheckgamemode	selectmissionplayer
;;	beq	.snd_mis
	bne	.snd_skip

	IFNE	kbattle
	km_bitchecktotalflag	battle
	bne	.snd_bat
	ENDC
.snd_mis
	a16
	km_andcmpvarval.l	m_backupflags,backupflag_twinall
	a8
	bne	.notall

	KBGM	StarFox1
.notall
	Ksound	mission_mode

	IFNE	kbattle
	bra	.snd_skip
.snd_bat
	Ksound	battle_mode
	ENDC
.snd_skip

;* Place Flag Set *
	lda.l	SoundTransTbl+1,x	;sound flag (port0)
	km_shiftrua4			;(space,room,ground,sea)
	clc
	adc	#ksf_baseplace		;place flag set	:port3
	a16
	km_loba
	sta	bgm_place
	ksound_a

;* Normal Stage Sound Transfer *
	lda.l	SoundTransTbl+0,x
	km_loba
	km_beq	.NoTransBGM	;No Sound Data Transfer
	tay		;sound data transfer counter
	a8
.soundtrans
	phy
	a16	
	lda.l	SoundTransTbl+2,x
	tay				;address
	a8
	lda.l	SoundTransTbl+4,x	;bank
	jsl	Initial_sound_l
	ply
	inx
	inx
	inx
	dey
	bne	.soundtrans

;* Special Sound Transfer *
	a16
	km_lldaslx	ksoundmapptr	;Sound Data Soutai Address Get
	lda.l	SoundSpecialAddrTbl,x
	tax		;Sound Data Table Pointer 
	km_loblda.l	SoundSpecialTransTbl+0,x
	beq	.NoTransBGM
	tay		;counter
.soundtrans2
	phy

	a16
	lda.l	SoundSpecialTransTbl+1,x
	tay					;address
	a8
	lda.l	SoundSpecialTransTbl+3,x	;bank
	jsl	Initial_sound_l

	ply
	inx
	inx
	inx
	dey
	bne	.soundtrans2
	stz	ksoundmapptr
;----------------------------------------------------
.NoTransBGM

	km_PullAllReg

	rtl

;=====================================================================
;*								*
;*		Player Sound SE Transfer			*
;* Data Bank 0							*
;=====================================================================
TransferSoundPlayer_l
	shorta
	longi
	km_PUSHAllReg
	db0
;-------------------------------------------------------------------------
;*** Pilot Type Check ****
;* player1 *
	lda	p1_pilotNo
	sta	kw_plsndptr
	jsr	TransPlSnd_sub
;* player2 *
	ldx	#partchar_start
	stx	kw_sndhenkouaddr
	lda	p2_pilotNo
	sta	kw_plsndptr

	km_setsndflag	addrchange
	jsr	TransPlSnd_sub
	km_clrsndflag	addrchange
;------------------------------------------------------------------------
;*** Arwing Type Check (Player1)****
	a16
	lda.l	kx_p1_TypePtr
	asl	a
	tax
	lda.l	Player1SoundTbl,x
	tay
	a8
	lda.l	Player1SoundTbl+2,x
	tyx
	jsl	Initial_sound_l	;transfer sound data to APU 
;----------------------------------------------
;* battle mode ka check suru ? *
	IFNE	kbattle
	km_bitchecktotalflag	battle
	km_beq	.end

	km_bitcheck_arwingtype	2,GG
	bne	.bat_GG
	km_bitcheck_arwingtype	2,SP
	bne	.bat_SP
.bat_FF
	KSoundTrans	FFset2
	bra	.end
.bat_SP
	KSoundTrans	SPset2
	bra	.end
.bat_GG
	KSoundTrans	GGset2
	ENDC
;----------------------------------------------
.end
	km_PULLAllReg
	rtl
;---------------------------------------------------------------------
;*		Transfer PLayer Sound Sub routine		*
;* Input :kw_plsndptr (0~12)						*
;---------------------------------------------------------------------
TransPlSnd_sub
	a16
	km_multvar3	kw_plsndptr,x
	lda.l	plsndtbl,x
	tay
	a8
	lda.l	plsndtbl+2,x
	jsl	Initial_sound_l	;transfer sound data to APU 

	rts
plsndtbl
	dl	foxvox
	dl	falvox
	dl	pepvox
	dl	slpvox
	dl	ga1vox
	dl	ga2vox

Player1SoundTbl
	dw	FFset1&WM
	dw	FFset1>>16
	dw	SPset1&WM
	dw	SPset1>>16
	dw	GGset1&WM
	dw	GGset1>>16

;=====================================================================
;*		BGM Interrupt Trans				*
;=====================================================================
BGMInterruptTrans
	php
	a8i16

	waittrans	;moshi IRQ no syori yori MAIN SEQUENCE no

	km_setsndflag	translock
	lda	#iv_sndwaitirq
	sta	trans_flag	;[irq flag]

	ldy	kw_soundtransaddr
	lda	kw_soundtransaddr+2
	jsl	Initial_sound_l	;transfer sound data to APU 

;* port3 initial (16 bit mode) *
	ldy	#0
	sty	sdgpt3	;(sdgpt3 ... SOUND DATA wo SET surutameno POINTER)
	sty	sdspt3	;(sdspt3 ... SOUND DATA wo buffer ni touroku suru tameno POINTER)

;* port 3 (8 bit mode) *
	stz	sdpck3	;(sdpck3 ... before sound)

	km_clrsndflag	translock
	waittrans	;moshi IRQ no syori yori MAIN SEQUENCE no

	plp
	rts
;=====================================================================
;*		 Sound Data Transfer				*
;* INPUT	:							*
;*	: Acc,Yreg:(sound address)				*
;* OUTPUT	:							*
;*	:X reg ha sonomama kaesu				*
;=====================================================================
	shorta
	longi
Initial_sound_l
	phb
	phx
	php

;--------------------------------
;* sound transfer *
	pha
	db0	;Data Bank <<< 0
		lda	#kbgm_soundtrans
		sta	apu_port0	;tensou start :port 0 <--- $0F
	pla

	jsl	sbootapu_l	;sound transfer

;--------------------------------
;* sound rady check *
	KSoundTransWait
;--------------------------------

	plp
	plx
	plb
	rtl

;=====================================================================
;*			STEREO MONORAL 				*
;* monoral : 0/1 ... stereo / monoral				*
;=====================================================================
Stereo_l
	shorta
	longi
	bne	.monoral
.stereo
	ksound	stereo
	bra	.end
.monoral
	ksound	monoral
.end
	jsl	Write_backupRAM_soundmode_l

	rtl
;=====================================================================
;*		Sound boot loader				*
;* INPUT :								*
;* Data Bank 0							*
;* Yreg :sound initial addres					*
;* Acc  :sound initial bank						*
;=====================================================================
;-----------------------------------------------------------------------
;Sound_program(sound_address)
;		DW	04000H			;count
;		DW	08000H			;address
;		DB	0A9H,000H,.......	;data
;		 |
;		DW	04000H			;count
;		DW	0C000H			;address
;		DB	000H,........		;data
;		 |
;		DW	00000H			;end
;-----------------------------------------------------------------------
		SHORTA
		LONGI
SbootAPU_l
;SOUND Data Address = (bank)(00)(00),y
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		STA	address+2	;B	:bank
		ldx	#0	
		stx	address+0	;base address <--- 0
;Yreg :Active address
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		LDX	#$BBAA		;W
boot_initial		CPX	apu_port0	;W
		BNE	boot_initial
		LDA	#0CCH		;B
		BRA	boot_entry1
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
boot_repeat		JSR	get_data
		XBA
		LDA	#0		;B
		BRA	boot_entry2
boot_loop		XBA			;	:2 cycle=36+7n
		JSR	get_data	;B	
		XBA			;	:2 cycle
boot_wait1		CMP	apu_port0	;B	:4 maximam responce=17
		BNE	boot_wait1	;	:2/3 cycle
		INC	A		;B	:2 cycle
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
boot_entry2
		A16			;2
		STA	apu_port0	;W	;5 cycle
		A8			;2
		DEX			;W	;2 cycle
		BNE	boot_loop		;3/2 cycle
boot_wait2		CMP	apu_port0	;W
		BNE	boot_wait2
boot_zero		ADC	#3		;B
		BEQ	boot_zero
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
boot_entry1	PHA				;>
		JSR	get_data
		XBA
		JSR	get_data
		XBA
		TAX			;W-->W :counter
;**** kairyou (94/2/23)****
		km_bitchecksndflag	addrchange
		bne	.addrhenkou
		JSR	get_data	;dummy address (l) get
		STA	apu_port2	;	:address (l)
		JSR	get_data	;dummy address (h) get
		STA	apu_port3	;W	:address (h)
		bra	.skip
.addrhenkou
		JSR	get_data	;get dummy address data
		JSR	get_data	;get dummy address data

		lda	kw_sndhenkouaddr
		STA	apu_port2	;	:address (l)
		lda	kw_sndhenkouaddr+1
		STA	apu_port3	;W	:address (h)
.skip
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		CPX	#1		;W
		LDA	#0		;B
		ROL	A		;B
		STA	apu_port1	;B (1)or(0)
		ADC	#07FH		;B CLC
	PLA				;<
		STA	apu_port0	;B
boot_wait3		CMP	apu_port0	;B
		BNE	boot_wait3
		BVS	boot_repeat	

	RTL
;-----------------------------------------------------------------------
	SHORTA
	LONGI
get_data		LDA	[address],Y	;W	; data count
		INY			;W
		BNE	get_exit
		INC	address+2	;B (bank)

		LDY	#$8000		;W
get_exit	RTS

;-----------------------------------------------------------------------
;***  END FILE ***
;-----------------------------------------------------------------------
	incfile	sndtbl.asm
	

;=====================================================================
;*		Set BGM (port 0) Data				*
;=====================================================================
	ifeq	1
SetBGM_l
	shorta
	longi
	phx
	phy
;----------------------------------------------------
;----------------------------------------------------
.NoTransBGM
	ply
	plx
	rtl
	endc

	ifeq	1
;*** Game Mode [Mission /Battle] ****
	km_ldxgamemode
	lda.l	bgmmodetable,x
	sta	bgm_music	;geme mode (mission / battle) b7 (0/1)

;*** Sound,Game Stage [Ground/Sea/Space] ***
	i8
	lda.l	kgamemap
	tax
	lda.l	bgmsoundtable,x
	ora	bgm_music
	sta	bgm_music	;sound No set
	i16

	lda	bgm_music
	and	#%00110000
	cmp	#%00110000
	bne	.NoSoundTrans

	ksoundtrans	sound1
	endc


