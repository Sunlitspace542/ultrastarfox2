;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º FILE:                VOFFSET.ASM                          º
;º AUTHOR:              Takumi Kawagoe   Nintendo.co.ltd  EADº
;º DESCRIPTION:         Set V offset buffer                  º
;º DATE CREATED:        26-3-93                              º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
	INCPUB	voffset

voffsetdisable	EQU	0	; 1 = off

lm_plyrvofsetadr	EQU	twork+2
lm_voffsetinit	EQU	twork+4
lm_carry		EQU	twork+6
lm_tan		EQU	twork+8
vwork0		EQU	twork+10
vwork1		EQU	twork+12
;centerpos		EQU	twork+14
vdatadr		EQU	twork+16
vofsmask		EQU	twork+18
vofsenable		EQU	twork+20
camrotz		EQU	twork+30


bg1vofsmask		EQU	%1011111111111111	;bg1 mask
bg1vofsenable 	EQU	%1010000000000000	;bg1 enable
bg2vofsmask		EQU	%1101111111111111	;bg2 mask
bg2vofsenable 	EQU	%1100000000000000	;bg2 enable

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³set V offset data to player1voffset         ³
;³        & playyer2voffset                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;	in	player1_horizon	:scroll value (16bit)
;		player2_horizon	:scroll value (16bit)
;	out	hvofs_buf1
;		hvofs_buf2
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³HV Offset data format                       ³
;³                                            ³
;³d0  - d9  : Offset data                     ³
;³d10 - d12 : no using                        ³
;³d13       : BG1 enable                      ³
;³d14       : BG2 enable                      ³
;³d15       : H or V (0:H offset  1:V offset) ³
;³player 1 & 2 V offset buffer  	         ³
;³	hvofs_buf1 128(bytes)            ³
;³	hvofs_buf2 128(bytes)            ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

setvofst_l

	phx
	phy
	php

;--------------------------------------------

	test_screenmode	novofs
	bne		.return
	ai16

	test_screenmode	noplayer

;	lda	screenmode
;	bit	#sm_noplayer

	beq	.goahead

.return
	plp
	ply
	plx
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-----------------------------------------
.goahead
;-----------------------------------------
; set mask & enable value

.bg2	ldx	#bg2vofsmask	;BG2 enable
	ldy	#bg2vofsenable
	test_screenmode	swapbg1bg2
	beq	.MEend
.bg1	ldx	#bg1vofsmask	;BG1 enable
	ldy	#bg1vofsenable
.MEend	stx	vofsmask
	sty	vofsenable
;-----------------------------------------
;player 1

.p1vofs


	IFNE	voffsetdisable
	bra	.clear
	ENDC

	test_vofsoff	1
	beq	.p1vofs_start

.clear	ldx	#hvofs_buf1+64
	jsr	.clearpros
;	vofson	1
	bra	.p1vofs_end

.p1vofs_start


	lda	#vinitdata&0ffffH
	sta	vdatadr
	test_screenmode	onescreen
	beq	.noadd
	lda	#vinitdata&0ffffH
	sta	vdatadr
	lda	#vinitdata_1&0ffffH
	sta	vdatadr
.noadd


	lda.l	player1_horizon

	tay
;	ldy	player1_horizon
;	ldx	#VIEWBLK1
;	lda	al_rotz,x

	lda.l	p1_camrotzbuf
	sta	camrotz

	lda	#hvofs_buf1+64
	jsr	.mainpros


.p1vofs_end


;player 2

	jmp	.allclear

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.p2vofs	test_screenmode	onescreen
	bne	.allclear
.p2vofs_000	test_vofsoff	2
	beq	.p2vofs_start
	ldx	#hvofs_buf2+64	;+14
	jsr	.clearpros
	;vofson	2
	bra	.p2vofs_end
.p2vofs_start
	lda	#vinitdata2&0ffffH
	sta	vdatadr
	lda.l	player2_horizon
	clc
	adc	#10H
	tay
;	ldy	player2_horizon
;	ldx	#VIEWBLK2
	lda.l	p2_camrotzbuf
	sta	camrotz
	lda	#hvofs_buf2+64	;+14
	jsr	.mainpros
.p2vofs_end
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;------------------------------------------
.allclear
	jmp	.return

;------------------------------------------

.mainpros
;	idy : v offset init value
;	A   : v offset buffer's address

	sty	lm_voffsetinit
	sta	lm_plyrvofsetadr

;	lda	AL_ROTZ,x	; get rotZ
	lda	camrotz
	tay
	bpl	.skip3
	nega

.skip3
	xba
	and	#0ffH
	bit	#%11111000
	beq	.skip0
	lda	#7		; max value = 7
.skip0	asl	a
	tax
	tya
	bmi	.Lup
;------------------------------------------ * offset set loop
.Rup	lda.l	vofst_tan_table,x	; get V offset data
	sta	lm_tan

	txa
	clc
	adc	vdatadr
	tax

	lda	lm_voffsetinit
	sec
	sbc.l	vinitdata&0ff0000H,x	;vinitdata,x
	sta	vwork1

;	ora	#%1100000000000000
	ora	vofsenable
;------------------------------------------
	ldx	lm_plyrvofsetadr
	and	vofsmask
;	and	#%1101111111111111

	sta.l	0,x		; first offset data (R)
	ldy	#0
	sty	vwork0

.incsetloopR

	lda	vwork0
	clc
	adc	lm_tan
	sta	vwork0

	lda	vwork1
	adc	#0
	sta	vwork1
	and	vofsmask
	ora	vofsenable
;	and	#%0001111111111111
;	ora	#%1100000000000000

	sta.l	2,x
	inx
	inx
	iny
	cpy	#32
	bne	.incsetloopR

	rts
;------------------------------------------ * offset set loop
.Lup
	lda.l	vofst_tan_table,x	; get V offset data
	sta	lm_carry		; V offset data -> kwork+0
	sta	lm_tan

	txa
	clc
	adc	vdatadr
	tax

	lda	lm_voffsetinit
	clc
	adc.l	vinitdata&0ff0000H,x	;vinitdata,x
	sta	vwork1

	ora	vofsenable
; 	ora	#%1100000000000000
;------------------------------------------
	ldx	lm_plyrvofsetadr
	and	#%1100001111111111

	sta.w	0,x

	ldy	#0
	sty	vwork0
.incsetloopL
	lda	vwork0
	sec
	sbc	lm_tan
	sta	vwork0
;--------------------------------------------

	lda	vwork1
	sbc	#0
	sta	vwork1
	and	vofsmask
	ora	vofsenable
;	and	#%0001111111111111
;	ora	#%1100000000000000

	sta.l	2,x
	inx
	inx
	iny
	cpy	#32
	bne	.incsetloopL

	rts
;------------------------------------------
; clear v offset

.clearpros
	ai16
	ldy	#32
	lda	vofsenable
	and	vofsmask
.cloop0
	lda	#0
	sta.l	0,x	;hvofs_buf1+64,x
	sta.l	0,x	;hvofs_buf2+64,x
	inx
	inx
	dey
	bne	.cloop0

	rts

;------------------------------------------
vofst_tan_table
	word	0
	word	324bH	;1
	word	649cH	;2
	word	9711H	;3
	word	0c9b5H	;4
	word	0fc98H	;5
	word	0ffffH	;6
	word	0ffffH	;7


	word	196bH
	word	32d8H
	word	4c4aH
	word	65c1H
	word	7f41H
	word	98caH
	word	0b260H	;7
	word	0cc04H	;8
	word	0e5b8H	;9
	word	0ff7eH	;10
	word	0ffffH	;11

;------------------------------------------

vinitdata	; battle mode screen1 V offset initial data

	word	0
	word	(324bH*13)/10000H	;1
	word	(649cH*13)/10000H	;2
	word	(9711H*13)/10000H	;3
	word	(0c9b5H*13)/10000H	;4
	word	(0fc98H*13)/10000H	;5
	word	(0ffffH*13)/10000H	;6
	word	(0ffffH*13)/10000H	;7

vinitdata2	; battle mode screen2 V offset initial data

	word	0
	word	(324bH*19)/10000H	;1
	word	(649cH*19)/10000H	;2
	word	(9711H*19)/10000H	;3
	word	(0c9b5H*19)/10000H	;4
	word	(0fc98H*19)/10000H	;5
	word	(0ffffH*19)/10000H	;6
	word	(0ffffH*19)/10000H	;7

;------------------------------------------

vinitdata_1	; V offset initial data

; 1 screen mode

	word	0
	word	(324bH*16)/10000H	;1
	word	(649cH*16)/10000H	;2
	word	(9711H*16)/10000H	;3
	word	(0c9b5H*16)/10000H	;4
	word	(0fc98H*16)/10000H	;5
	word	(0ffffH*16)/10000H	;6
	word	(0ffffH*16)/10000H	;7




