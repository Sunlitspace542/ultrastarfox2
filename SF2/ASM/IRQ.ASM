
	incpub	irq


; size and position of mid screen blanking area.

midscreenirq_pos	=	bitmapvheight*8+gameStRow*8+2
midscreenirq_depth	=	2

NOBGTRANS	=	0

	shorta
	shorti
irqcode_l	;ADDRESS =7f0008h
	ldx	trans_flag2
	bne	.forcejmp
	ldx	trans_flag
.forcejmp	jmp	(.tab&WM,x)
.tab	irvlist
	irv	irqblank	;$00
	irv	randtrans_i	;$02
	irv	newbg2chr	;$04
	irv	newbg2scr	;$06
	irv	newbg3		;$08
	irv	irqsetmode1	;$0a
	irv	irqsetmode2	;$0c
	irv	gameirq1	;$0e
	irv	gameirq2	;$10
	irv	gameirq3	;$12
	irv	gameirq4	;$14
	irv	screenonirq	;$16
	irv	titleirq	;$18
	irv	mapirq		;$1a
	irv	newpalette	;$1c
	irv	pauseirq	;$1e
	irv	gameirq1_1	;$20
	irv	gameirq2_1	;$22
	irv	gameirq3_1	;$24
	irv	midscreenirq	;$26
	irv	gameirq4_1	;$28
	irv	typeselirq	;$2a
	irv	testirq		;$2c
	irv	sndwaitirq	;$2e
	irv	mismapirq	;$30
	irv	creditsirq	;$32
	irv	creditsirq2	;$34
	irv	creditsirq3	;$36
	irv	creditsirq4	;$38

;*****************************************************************************
;*									*
;*			Macro Definition				*
;*									*
;*****************************************************************************

;=====================================================================
;*			Wait H Blanking				*
;=====================================================================
; macro to wait until hblanking time.. if currently in the middle of a hblank
; waits until the next line's hblank

waithbl	MACRO
.wait\@
	lda	hvbjoyr
	bit	#64
	bne	.wait\@		;no hblank wait

.wait2\@
	lda	hvbjoyr
	bit	#64
	beq	.wait2\@	;hblank wait
	ENDM

;=====================================================================
;*			Start IRQ				*
;*(Screen Off:Blanking)						*
;=====================================================================
; macro that should begin any irq's that require the screen to be turned
; off when they begin.

start_irq	MACRO

	IFNE	LONGA
	printf	"start_irq should be in SHORTA mode%n"
	ENDC

	waithbl

	lda	#$8F
	sta	inidisp

	ENDM

;=====================================================================
;*			End IRQ					*
;* (window,music,irq Vtimer)						*
;=====================================================================
; macro that should end all irq macros.. it turns the screen back on at
; the correct time. (at the top of the screen)

end_irq	MACRO
	IFNE	LONGA
	error	<end_irq should be in SHORTA mode>
	ENDC
	IFEQ	LONGI
	error	<end_irq should be in LONGI mode>
	ENDC

;* sound *
	jsr	startmus	;Music

	lda	#iv_screenonirq
	sta	trans_flag2

	ldx	screenon_position	;#14			;(14)
	stx	vtimel

	IFNE	kbattle
	km_bitcheckgameflag	battle
	bne	.skip
	ldx	#gamevw_pos2	;+2		;(12+2)
	stx	vtimel
.skip
	ENDC
	jmp	endirq
	ENDM
;------------------------------------------------------
; table of code that is run at the end of every irq:
endirq
	ai8
	ldx	irqend_flag
	jmp	(.tab&WM,x)

.tab	irvlist
	irv	nothing
	irv	kirq1frame

;*********************************************************************
;*								*
;*	Every Flame Interrupt Routine (1/60 second IRQ )	*
;*								*
;*********************************************************************
; irq ends:

	SHORTA
	SHORTI
nothing
	rtl

;-------------------------------------------------------
	SHORTA
	SHORTI
kirq1frame
colourcycle1
	rtl

; tatoeba
; ON:
;	lda	#iv_kirq1frame
;	sta	irqend_flag

;OFF:
;	lda	#iv_nothing
;	sta	irqend_flag


;*********************************************************************
; Credit sequence IRQ
;
	SHORTA
	SHORTI

creditsirq
	i16
	dec	framec

	waithbl

	stz	inidisp

	lda	#iv_creditsirq2
	sta	trans_flag2
	ldx	#techdata_pos+7+15		;(220)
	stx	vtimel
	rtl

creditsirq2
	i16
	dec	framec

	waithbl

	lda	#2
	sta	tm
	lda	#1
	sta.l	credits_fade
;	lda.l	xinidisp1
	sta	inidisp
	lda	#iv_creditsirq4
	sta	trans_flag2
;	ldx	#gamevw_pos-2		;(220)
	ldx	#techdata_pos+7+15+2
	stx	vtimel
	rtl

creditsirq3
	i16
	dec	framec

	waithbl

	stz	inidisp

	lda	#1+2+16
	sta	tm
	stz	trans_flag2
	ldx	#gamevw_pos		;(220)
	stx	vtimel
	rtl

creditsirq4
	i16
	dec	framec

	waithbl

	lda.l	credits_fade
	inc	a
	inc	a
	sta.l	credits_fade
	sta	inidisp
	cmp	#15
	beq	.setirq3
	a16
	and	#255
	inc	a
	inc	a
;	asl	a
	adc	#techdata_pos+7+15
	tax
	stx	vtimel
	rtl

	shorta
.setirq3
	lda	#iv_creditsirq3
	sta	trans_flag2
	ldx	#gamevw_pos-2		;(220)
	stx	vtimel
	rtl


;*********************************************************************
; Irq which occurs in the middle of the screen (for cosmetic changes)
;
	SHORTA
	SHORTI
midscreenirq
	i16
	dec	framec	; not a proper irq

	test_screenmode	midscreenirq
	bne	.twoscreen
; if not two screen, then just return..
	stz	trans_flag2
	ldx	#gamevw_pos		;(220)
	stx	vtimel
	rtl
.twoscreen
	test_screenmode	creditsirq
	beq	.notcredits
	lda	#iv_creditsirq
	sta	trans_flag2
	ldx	#techdata_Pos+15
	stx	vtimel
	rtl

.notcredits	;(Battle Mode)
	brl	mm_blink3

	IFNE	kbattle
	waithbl
	lda	#$8f
	sta	inidisp

	stz	trans_flag2
	ldx	#gamevw_pos		;(220)
	stx	vtimel

	ldx	windowptr2		;Set window values
	beq	.setwindow
	km_bitcheckwindowflag	windowwbuf
	beq	.Pl1buf2
.Pl1buf1	ldx	#kw_windowstructP2_buf1
	bra	.setwindow
.Pl1buf2	ldx	#kw_windowstructP2_buf2
.setwindow
	jsr	setwindowpri

	a8
.waitforline
	lda	slhvr
	lda	opvctr
	xba
	lda	opvctr
	xba
	cmp	#midscreenirq_pos+midscreenirq_depth
	bne	.waitforline

	waithbl
	lda.l	xinidisp1
	sta	inidisp

	rtl
	ENDC

;*********************************************************************
;*		Yajima's test irq Routine			*
;*********************************************************************
	SHORTA
	SHORTI
testirq
	start_irq
	stz	trans_flag
	rtl

;*********************************************************************
;*								*
;*		Title no IRQ Routine				*
;*********************************************************************
	SHORTA
	SHORTI
titleirq
	a8i16
	start_irq	;[h-dma wait & Blanking]
	stz	trans_flag

;=====================================================================
;*		Mission Player Character Transfer (Yajima)	*
;=====================================================================
	km_cmpcheckgamemode	selectmissionplayer
	bne	.nomispl
	jsl	draw_pselect_l
	km_IRQdmaRAMtoCGRAM	kx_palette+12*32,12*16,32*4
.nomispl
;=====================================================================
;*		HI Score no Charcter Transfer (Yajima)		*
;=====================================================================
	km_bitcheckscreenflag	yjchartrans
	beq	.notrans

	km_cmpcheckgamemode	record	;hiscore
	bne	.nameset
	jsl	NMI_BestScore_l
	bra	.notrans
.nameset
	jsl	NMI_NameSet_l
.notrans
;=====================================================================
;*			Common IRQ Routine			*
;=====================================================================
	jsr	kcommonirq

;=====================================================================
;*			NEXT IRQ V timer			*
;=====================================================================
SetIRQHVTime
;* irq (h,v) timer set *
	ldx	#0
	stx	htimel
	ldx	kw_vtimel
	bne	.vcntset
	ldx	#226
.vcntset
	stx	vtimel		;irq V pos
	stx	kw_vtimel
	rtl


;*********************************************************************
;*								*
;* 	     IRQs For Mission Map Select			*
;*								*
;*********************************************************************
mm_irqcount	=	8	;8frame/draw bit map
mm_tsize	=	mm_wbuflength/mm_irqcount
mm_maxtsize	=	mm_wbuflength
	shorta
	shorti
mismapirq
	i16
	inc	checkirq	;Game no Syori Frame Check
	km_clrmismapstflag	irqfinish

;* Moshi Game Frame Routine wo Syori shiteiru tokini IRQ ga kakattata !! *
	km_bitcheckmismapstflag	noirqsyori
	bne	.subirq
;---------------------------------------------------------------------
;*		Main IRQ Routine	[mario chip parallel]	*
;*								*
;---------------------------------------------------------------------
.mainirq
	start_irq
	jsr	mm_transbitmap
	jsr	mm_commonirq
	jsr	kcommonirq

	jsr	mm_EveryFrameRoutine

	bra	mismapirqEND

;---------------------------------------------------------------------
;*		Sub IRQ Routine	[mario chip stop]		*
;---------------------------------------------------------------------
.subirq
	inc	checkirq1	;Game no Syori Frame Check

;---------------------------------------------------------------------
;*			NEXT IRQ V timer			*
;---------------------------------------------------------------------
mismapirqEND
	a16
	longi
;* Key States Read *
	km_setgmjoypad
	km_setgmkeydown
	a8
	brl	SetIRQHVTime

;=====================================================================
;*								*
;*		Planet CGX Transfer	(MISSION MAP)		*
;=====================================================================
mm_transbitmap
	a16
	km_bitcheckmismapstflag	finishtrans
	km_bne	.skip_trans

;* tensou saki (VRAM address)*
	lda.l	kx_showmapsize
	tay
	lsr	a
	clc
	adc	vmap1
	tax
;* tensou moto *
	tya
	clc
	adc	showmap
	tay
;* tensou *
	a8
	storenasty
	ramnastyoff
	km_IRQdmayxvram	bitmapbase,mm_tsize
	restorenasty

;* trans all finish check *
	a16
	km_addstaval.l	kx_showmapsize,mm_tsize
	cmp	#mm_maxtsize
	bne	.skip_trans
.finishtrans
	km_setmismapstflag	finishtrans	;[tensou syuuryou]
	km_setmismapstflag	noirqsyori	;[irq syori skip]
	km_setval.l	kx_showmapsize,0
	a8
	swapshowmap

	lda	vmap1+1			;Double buffer screen
	sec
	sbc	#(mm_fixbg1cgxlength/2)>>8
	and	#$0f0
;;;	sta	iwork		('95/1/31 :comment)
	lsr	a
	lsr	a
	lsr	a
	lsr	a		;BG1
;;;	ora	iwork		;BG2 ('95/1/31 :comment)
	sta	bg12nba

	ldx	vmap1			;Bitmap double buffering
	ldy	vmap2
	stx	vmap2
	sty	vmap1
.skip_trans
	rts

;*********************************************************************
;*								*
;*		MISSION MAP COMMON IRQ				*
;*								*
;*********************************************************************
mm_commonirq
	a8
	longi
;=====================================================================
;*		Mission Map Arwing CGX Transfer [256 byte]	*
;=====================================================================
	shorta
;***** Main Character ******
;* ue 2chra tensou (64 BYTE) *
	ldx	mm_arwingcgxptr1
	km_IRQdmaXRomVRAM	xheap,mm_obj_cgx,(2*32)
;* shita 2 chr tensou (64 BYTE) *
	ldx	mm_arwingcgxptr2
	km_IRQdmaXRomVRAM	xheap,mm_obj_cgx+$100,(2*32)

;****** Partner Character ******
;* ue 2chra tensou (64 BYTE) *
	ldx	mm_arwingcgxptr1_pt
	km_IRQdmaXRomVRAM	xheap,mm_obj_cgx+32,(2*32)

;* shita 2 chr tensou (64 BYTE) *
	ldx	mm_arwingcgxptr2_pt
	km_IRQdmaXRomVRAM	xheap,mm_obj_cgx+$100+32,(2*32)

;=====================================================================
;*		Mission Map Clock (scr)  Data Transfer		*
;*		Mission Map Enemy Number Data Transfer		*
;=====================================================================
;(every :192 byte tensou) : 4 char Line
	km_IRQdmaromVRAM	mm_scrbg2souraddr,mm_vmscrbg2addr,mm_vmscrbufbg2len
	rts

;*********************************************************************
;*								*
;*		Every Frame Routine	[1 frame]		*
;*								*
;* IRQ routine no nakakara Call shitekuru				*
;*********************************************************************
	shorta
	longi
mm_EveryFrameRoutine
	STORENASTY	;kono code wo irete okanaito
			;trans wait shiteirutoki ni nasty no value ga kawaru :(mismap.asm)
			;'95/6/22 :cf. bug report
	NASTYOFF	;ROM Access Enable
;============ syori over check start ================
;;;	km_SyoriOverCheckStart
;************ wipe *****************
	jsl	setblack_l		; [black fade]
	jsl	wipe_l			; [wipe]
	jsl	find_window_pri_l	; [window pri]

;*** Sprite ***
	jsl	do_sprites_l		; [sprites]

;*** BG & Colour kakikae ***
	jsl	set_kscreen_l		; [screen]
;*** Every Frame Routine ***
	jsl	mm_ROMRoutine_l		;[rom access]

;************* RAM parallel Program Start ***************
	NASTYON		;ROM Access Disable
;---------------
;rtl address push
	a8
	lda	#.ret>>16
	pha
	pea	(.ret-1)&WM
;---------------
;push jsl address
	lda	#$7e
	pha
	a16
	lda.l	mmx_ramprogaddr
	clc
	adc	#heap-1
	pha
	a8
	rtl
.ret
	RESTORENASTY	;'95/6/22 :cf. bug report
;--------------------------------------------------------------------------
;============ syori over check end ============
;;;	km_SyoriOverCheckEnd

	rts


;-----------------------------------------------------
;*		Not Using			*
;-----------------------------------------------------
;=====================================================================
;*		Planet CGX Transfer	(MISSION MAP)		*
;* Memo :every IRQ ni 1 planet tensou(planet ka shadow dochiraka)	*
;* Mario RAM wa bitmap1+bitmapbase
;=====================================================================
	IFEQ	1
;* cgx transfer enable check *
	km_cmpcheckgamemode	selectmissionmap
	km_bne	.noplanet	;if not mission map select then .noplanet

;* syori over check *
	km_bitcheckmissionflag	planettrans
	km_beq	.noplanet	;if planet data transfer disable then .noplanet

;******* Double Buffer Chang Check **********
	dec	mmw_wbuffercounter
	bpl	.nochgWbuffer	;if not W Buffer change then .nochgWbuffer

;* Double Buffer Change Counter *
	lda	#mm_planetnumber*2	;5planet*2(planet/shadow)
	sta	mmw_wbuffercounter

;* BG1 base change *
;;;;	km_eorflag	kw_bg12nba,2
;;;;	sta	bg12nba			;Screen Base Set

;* planet rotation *
	a16
	km_addstaval.l	mmx_planetangY,$100	;Y rot +1
	a8
;---------------------------------------
;94/8/2 :test ver
;* planet R change *
	a16
	lda	mmw_planetanmptr
	clc
	adc	#$0040
	cmp	#$400
	bmi	.smaller
	cmp	#$1100
	bpl	.bigger
	bra	.skipR
.smaller
.bigger
	lda	#$400
.skipR
	sta	mmw_planetanmptr
	a8
;---------------------------------------
.nochgWbuffer

;****************** Planet Transfer ***************
	shorta
	longi

;* DMA parameters *
	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	lda	#%00000001
	sta	ch0params

;*** moto (Mario RAM)***
	ldx	#(bitmap1+bitmapbase)&WM
	stx	mmw_dmabase_moto
	stx	mmw_mrambase
	stx	ch0addra1tl	;tensou moto address

	lda	#(bitmap1+bitmapbase)>>16
	sta	ch0atbank	;tensou moto bank

;*** saki (V-RAM)***
	a16
	km_bitcheckmissionflag	planet
	beq	.map	;planet/shadow select
;------------------
.shadow
	longa
	lda	#(mm_planetCGXstart+16)/2 ;shadow CGX start address
	clc
	adc	mmw_dmabase_sakistep
	sta	mmw_vrambase

;--- tugino planet no address ---
	lda	mmw_dmabase_sakistep
	clc
	adc	#$0040		;step val
	tax			;address keep
	cmp	#$440
	beq	.planetStart
	and	#$00ff
	bne	.setaddr_saki
.nextplanet	;tugi no unit
	tax
	clc
	adc	#$100*4		;16 chr
	tax
	bra	.setaddr_saki
.planetStart
	ldx	#0
	bra	.setaddr_saki
.setaddr_saki
	stx	mmw_dmabase_sakistep
	bra	.set
;---------------------------------
.map
	longa
	lda	#(mm_planetCGXstart)/2 ;planet CGX start address
	clc
	adc	mmw_dmabase_sakistep
	sta	mmw_vrambase
;--------------------
.set
	lda	kw_bg12nba		;CGX base address
	xba
	and	#$0ff00
	km_multa16
	eor	#mm_planetCGXBase
	ora	mmw_vrambase
	sta	mmw_vrambase
	sta	mmw_vramadr
	sta	vmaddl

	km_eormissionflag	planet		;0/1...planet/shadow

;***** 1 Planet Transfer ******
	longa
	i8
	ldx	#4		;width = 4 chr
.SetPlanet
;--------------------------------------
;* tate 4 chr wo tensou (planet ka shadow) *
	ldy	#4		;vert = 4chr
.set1unit
	lda	#16
	sta	ch0dataddrl	;DMA trans value (1 Chr)

	a8
	lda	#1
	sta	mdmaen		;DMA START
	a16
	lda	mmw_vramadr
	clc
	adc	#$10
	sta	mmw_vramadr
	sta	vmaddl
	dey
	bne	.set1unit
;---------------------------------------
;* tugino yoko chra no address wo set * 
	lda	mmw_vrambase
	clc
	adc	#$100
	sta	mmw_vrambase
	sta	mmw_vramadr
	sta	vmaddl

	lda	mmw_mrambase
	clc
	adc	#$100
	sta	mmw_mrambase
	sta	ch0addra1tl
	dex			;dec	mmw_planethctr
	bne	.SetPlanet	
;-----------------------------------------------------------
	a8i16
	km_clrmissionflag	planettrans
.noplanet
	ENDC
;STAR no CGX wo DIRECT tensou
;IMA WA tukatte inai.
	IFEQ	1
	km_cmpcheckgamemode	selectmissionmap
	bne	.skip
	a16
	lda.l	KCGXSCRTransCPUAddr	
	tay
	a8
	km_dmacgx4_cpu	0,$100*32/2,KCGXSCRTransBuf,64
.skip
	endc

;*********************************************************************
;*								*
;*		Common IRQ Syori				*
;*								*
;* OAM Transfer,Colour Transfer,Window,Scroll			*
;* Key Read,Sound,Blanking ON Timer					*
;*********************************************************************
kcommonirq
	php
	a8
	longi
;=====================================================================
;*		Sprite Data DMA Transfer			*
;=====================================================================
;*Sprites buffer = Double buffer *
;(0... buffer2 write,buffer1 transfer)
;(1... buffer1 write,buffer2 transfer)
	km_jmpscreenflag	oamtensou,.transfer_buffer2
.transfer_buffer1
	km_IRQdmaoaram	sprites,(128*4)+(128/4)	; dma into oram

	km_cmpcheckgamemode	selectmissionmap
	BNE	.SKIP
	storenasty
	nastyoff		;<<<<< ROM&RAM NASTY OFF (ROM NASTY OFF wo WASURERUNA !!!!
	km_IRQdmasprbufclr
	restorenasty
.SKIP
	bra	.OAMtransEnd
.transfer_buffer2
	km_IRQdmaoaram	(sprites+128*4+128/4),(128*4)+(128/4) ; dma into oram
.OamTransEnd

;---------------------------------------------------------------------
;*			Color Data Transfer			*
;* BG & OBJ Colour Data Transfer					*
;---------------------------------------------------------------------
	km_bitcheckscreenflag	colpaltrans
	beq	.nocolourtrans
	km_IRQdmaRAMtoCGRAM	kx_palette,0,512
.nocolourtrans

	IFEQ	1
;'94/8/27
	km_bitcheckscreenflag	bgcolpal
	beq	.nopalcol
	km_IRQdmatranscolpal.l	coladr_2,2,1
.nopalcol
	km_bitcheckscreenflag	bgcolpal3
	beq	.nopalcol3
	km_IRQdmatranscolpal.l	coladr_3,3,1
.nopalcol3
	km_bitcheckscreenflag	bgcolpal4
	beq	.nopalcol4
	km_IRQdmatranscolpal.l	coladr_4,4,1
.nopalcol4
	ENDC
;=====================================================================
;*		Screen Transfer			[missionresult]	*
;=====================================================================
	km_bitcheckscreenflag	screentrans
	beq	.notrans
	km_IRQdmaromVRAM	mmxx_screenbuffer,mr_bg2_scr,($20*$1d*2)
.notrans

;=====================================================================
;*		Screen Base Change				*
;=====================================================================
;* BATTLE FIELD SELECT
	IFNE	kbattle
	km_cmpcheckgamemode	selectbattlefield
	bne	.noscchange
	lda	kw_bg2sc
	sta	bg2sc		;BG2 SCR ,screen 1
.noscchange
	ENDC

;=====================================================================
;*			Window					*
;=====================================================================
	jsr	KSetWindowParams

;=====================================================================
;*			SCROLL					*
;=====================================================================
	km_bitcheckscrollflag	hdmascroll
	beq	.normalscroll
.hdmascroll
	a16
	lda.l	kx_hscrollp1
	sta.l	xh_hscrolltbl1
	lda.l	kx_hscrollp2
	sta.l	xh_hscrolltbl2
	lda.l	kx_vscrollp1
	sta.l	xh_vscrolltbl1
	lda.l	kx_vscrollp2
	sta.l	xh_vscrolltbl2
	a8
	bra	.scrollend
;--------------------------------------------------------------------
.normalscroll
	shorta
;*** bg1 scroll ***
	lda	kw_bg1hofs
	sta	bg1hofs
	lda	kw_bg1hofs+1
	sta	bg1hofs

	lda	kw_bg1vofs
	sta	bg1vofs
	lda	kw_bg1vofs+1
	sta	bg1vofs
;*** bg2 scroll ***
	lda	kw_bg2hofs
	sta	bg2hofs
	lda	kw_bg2hofs+1
	sta	bg2hofs

	lda	kw_bg2vofs
	sta	bg2vofs
	lda	kw_bg2vofs+1
	sta	bg2vofs
.scrollend
;--------------------------------------------------------------------
;*** bg3 scroll ***
	jsr	SetHVScroll_BG3
;=====================================================================
;*			MOZAIKU					*
;=====================================================================
	IFEQ	1
	km_bitcheckflag	kw_mozaikuflag,$80
	beq		.NoMozaiku	;moshi mozaiku wo shinainara

	lda	kw_mozaikuflag
	and	#$7f
	ora	kw_mozaikunumber
	sta	mosaic
.NoMozaiku
	ENDC
;---------------------------------------------------------------------
;*		Screen Display Switch				*
;---------------------------------------------------------------------
;'94/8/18
	lda	kw_tm
	sta	tm
;=====================================================================
;*			BLANKING OFF	& FADE (IN,OUT)		*
;=====================================================================
	jsr	setinidisp
	lda.l	xinidisp1
	sta	inidisp		;[Blanking Off or Fade]

;---------------------------------------------------------------------
;*		SOUND DATA					* 
;---------------------------------------------------------------------
	jsr	startmus
;---------------------------------------------------------------------
;*		JOY PADS READ					*
;---------------------------------------------------------------------
	jsr	readjoypads

;---------------------------------------------------------------------
;*			Soft Ware Timer				*
;---------------------------------------------------------------------
	JSR	SoftWareTimer
	plp
	rts

;=====================================================================
;*								*
;*			Soft Ware Timer				*
;*								*
;=====================================================================
SoftWareTimer
	shorta
	longi
	INCTIMER	B,Binctimer,Binctmend
	INCTIMER	W,Winctimer,Winctmend
	DECTIMER	B,Bdectimer,Bdectimerend
	DECTIMER	W,Wdectimer,Wdectmend
	jsl	KGetRandomPtr_l
	rts

;=====================================================================
;*								*
;*			Get Random Pointer			*
;*								*
;=====================================================================
KGetRandomPtr_l
	ifeq	randominfo
	inc	kw_RandomPtr

	jsr	random
	lda	kw_RandomPtr
	clc
	adc	kx_TotalTime
	clc
	adc	rand
	sta	kw_RandomPtr

	elseif
	lda	#0
	sta	kw_RandomPtr
	endc
	rtl
;=====================================================================
;*								*
;*			Get Random Value			*
;* Input  :Xreg :warukazu						*
;* Output :Acc  :Random Value					*
;* Break  :Xreg,Yreg							*
;=====================================================================
KGetRandomValue_l
	longa
	longi
	jsl	KGetRandomPtr_l
	jsl	kdivu16u8_sub_l
	tya
	rtl

;*********************************************************************
;*								*
;*		Type Select no IRQ Routine			*
;*								*
;*********************************************************************
	SHORTA
	SHORTI
typeselirq
	a8i16
	start_irq
	stz	trans_flag
;=====================================================================
;*		Screen CGX Transfer				*
;=====================================================================
;=====================================================================
;*		Sprite Data DMA Transfer			*
;=====================================================================
;*Sprites buffer = Double buffer *
;* sprstates (0... buffer1 transfer ,1... buffer2 transfer) *
	km_jmpscreenflag	oamtensou,.transfer_buffer2
.transfer_buffer1
	km_IRQdmaoaram	sprites,(128*4)+(128/4)	; dma into oram
	bra	.OAMtransEnd
.transfer_buffer2
	km_IRQdmaoaram	(sprites+128*4+128/4),(128*4)+(128/4) ; dma into oram
.OamTransEnd
;=====================================================================
;*			SCROLL					*
;=====================================================================
;*** bg1 scroll ***
	jsr	SethdmaHVScroll
;*** bg3 scroll ***
	jsr	SetHVScroll_BG3
;=====================================================================
;*			BLANKING OFF	& FADE (IN,OUT)		*
;=====================================================================
	jsr	setinidisp

	lda.l	xinidisp1
	sta	inidisp		;[Blanking Off or Fade]
;---------------------------------------------------------------------
;*		SOUND DATA					* 
;---------------------------------------------------------------------
	jsr	startmus
;---------------------------------------------------------------------
;*		JOY PADS READ					*
;---------------------------------------------------------------------
	jsr	readjoypads
;---------------------------------------------------------------------
;*			NEXT IRQ V timer			*
;---------------------------------------------------------------------
	ldx	#128
	stx	htimel

	ldx	#225	;kw_vtimel
	stx	vtimel	;irq V pos
	rtl

;----------------------------------------------------------
; SCREENONIRQ: turns the screen back on after an irq occurs
;----------------------------------------------------------
	shorta
	shorti
screenonirq
; restore the trans_flag
	i16
	ldx	#midscreenirq_pos
	stx	vtimel

	i8
	lda	#64
.wait1	bit	hvbjoyr
	bne	.wait1		;no hblank wait
	lda.l	xinidisp1
	tax

	lda	#64
.wait2	bit	hvbjoyr
	beq	.wait2		;hblank wait
	stx	inidisp

	i16
	lda	#iv_midscreenirq
	sta	trans_flag2
	dec	framec	; not a proper irq
	rtl

;***************************************************************************
;-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-
;
; IRQs FOR TRANSFER OF ONE SCREEN/PLAYER MODE
;
;-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-
;***************************************************************************

;---------------------------------------
;--- GAME IRQ #1 - DMA THIRD OF SCREEN

	IFEQ	PAL
tsize3	=	3092	;(bitmapsize_1/4+768

tsize1	=	(bitmapsize_1-tsize3)/2
tsize2	=	tsize1
	ELSEIF
tsize3	=	0	;(bitmapsize_1/4+768

tsize1	=	(bitmapsize_1-tsize3)/2+5*1024
tsize2	=	bitmapsize_1-tsize1-tsize3
	ENDC

	shorta
	shorti
gameirq1_1
	start_irq
;* debug 1 *
;	km_setvar	checkirq1,checkirq
;	km_setval	checkirq,0

	i16
	ldx	vmap1
	ldy	showmap

	storenasty
	ramnastyoff
	km_IRQdmayxvram	bitmapbase,tsize1

	restorenasty
;	ramnastyon

	lda	#iv_gameirq2_1
	sta	trans_flag
	end_irq
	rtl

;---------------------------------------
;--- GAME IRQ #2 - DMA 2ND THIRD OF SCREEN

	shorta
	shorti
gameirq2_1
	start_irq
;* debug 2 *
;	km_setvar	checkirq2,checkirq
;	km_setval	checkirq,0

	ai16
	lda	vmap1
	clc
	adc	#tsize1/2
	tax

	lda	showmap
	clc
	adc	#tsize1
	tay
	a8

	storenasty
	ramnastyoff
	km_IRQdmayxvram	bitmapbase,tsize2

	restorenasty
;	ramnastyon

	IFEQ	PAL
	lda	#iv_gameirq3_1
	sta	trans_flag
	end_irq
	rtl
	ELSEIF
	brl	gameirq3_1.in
	ENDC

;---------------------------------------
;--- GAME IRQ #3 - DMA LAST THIRD OF SCREEN

	shorta
	shorti
gameirq3_1
	start_irq
.in	LOCAL
;* debug 3 *
;	km_setvar	checkirq3,checkirq
;	km_setval	checkirq,0

	IFEQ	PAL

	ai16
	lda	vmap1
	clc
	adc	#tsize1/2+tsize2/2
	tax

	lda	showmap
	clc
	adc	#tsize1+tsize2
	tay
	a8

	storenasty
	ramnastyoff
	km_IRQdmayxvram	bitmapbase,tsize3

	restorenasty
;	ramnastyon

	ELSEIF
	a8i16
	ENDC

	swapshowmap

	jmp	gameirq4.in	; comment out if 4 frame transfer

;Moshi $ frame de ugokasu baai wa ueno jump wo comment ni suru *
	lda	#iv_gameirq4_1
	sta	trans_flag
	end_irq
	rtl

;---------------------------------------
;--- GAME IRQ #4 - DMA SPRITES AND SCREEN DATA

	shorta
	shorti

gameirq4_1
	start_irq

;* debug 4 *
;	km_setvar	checkirq4,checkirq
;	km_setval	checkirq,0

	a8i16
	jmp	gameirq4.in	;jump .in

;-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-
;
; IRQs FOR TRANSFER OF TWO SCREEN/PLAYER MODE
;
;-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-

tsize1	=	bitmapsize/2+1024
tsize2	=	bitmapsize/2-1024

;---------------------------------------
;--- GAME IRQ #1 - DMA HALF OF SCREEN #1
	shorta
	shorti
gameirq1
	IFNE	kbattle
	start_irq

	i16

	ldx	vmap1

	storenasty
	ramnastyoff

	km_IRQdmaxvram	(bitmapbase+bitmap1),tsize1

	restorenasty
;	ramnastyon

	lda	#iv_gameirq2
	sta	trans_flag
	end_irq
	rtl
	ENDC

;-------------------------------------------
;--- GAME IRQ #2 - DMA 2ND HALF OF SCREEN #1
	shorta
	shorti
gameirq2
	IFNE	kbattle
	start_irq
	ai16
	lda	vmap1
	clc
	adc	#tsize1/2
	tax
	a8

	storenasty
	ramnastyoff
	
	km_IRQdmaxvram	(bitmapbase+bitmap1+tsize1),tsize2

	restorenasty
;	ramnastyon


	stz	trans_flag
	end_irq

;	rtl
	ENDC
;---------------------------------------
;--- GAME IRQ #3 - DMA HALF OF SCREEN #2
	shorta
	shorti
gameirq3
	IFNE	kbattle
	start_irq
	ai16
	lda	vmap1
	clc
	adc	#bitmapsize/2
 	tax
	a8

	storenasty
	ramnastyoff
	km_IRQdmaxvram	(bitmapbase+bitmap2),tsize1

	restorenasty
;	ramnastyon

	lda	#iv_gameirq4
	sta	trans_flag
	end_irq
;	rtl
	ENDC
;-------------------------------------------
;--- GAME IRQ #4 - DMA 2ND HALF OF SCREEN #2
	shorta
	shorti
gameirq4
	IFNE	kbattle
	start_irq
	ai16
	lda	vmap1
	clc
	adc	#(tsize1+bitmapsize)/2
	tax
	a8

	storenasty
	ramnastyoff
	km_IRQdmaxvram	(bitmapbase+bitmap2+tsize1),tsize2

	restorenasty
 ;	ramnastyon

	ENDC

;*****************************************************
;*	One Screen Last IRQ Start		*
;*****************************************************
.in	LOCAL
;- Kawagoe's hv-offset dma routine -----------------------------------
	shorta
	longi
	test_screenmode	novofs
	bne	.nodmahvofs
	ldx	vram_hvofs_base1
	km_IRQdmaxvram		hvofs_buf1,128

	IFNE	kbattle
	test_screenmode	twoscreen
	beq		.nodmahvofs
	ldx	vram_hvofs_base2
	km_IRQdmaxvram		hvofs_buf2,128
	ENDC
.nodmahvofs

;*********************************************************************
;*								*
;*		KAWAGUCHI IRQ ROUTINE				*
;*	(OAM transfer,CGX,SCR,color change,Timer)		*
;*********************************************************************
	a8i16
;---------------------------------------------------------------------
;*			OAM Data DMA Transfer			*
;---------------------------------------------------------------------
;*Sprites buffer = Double buffer *
;* sprstates (0... buffer1 transfer ,1... buffer2 transfer) *
	km_jmpscreenflag	oamtensou,.transfer_buffer2
.transfer_buffer1
	km_IRQdmaoaram	sprites,(128*4)+(128/4)	; dma into oram
	bra	.OAMtransEnd
.transfer_buffer2
	km_IRQdmaoaram	(sprites+128*4+128/4),(128*4)+(128/4) ; dma into oram
.OamTransEnd

;---------------------------------------------------------------------
;*			Color Data Transfer			*
;* BG & OBJ Colour Data Transfer					*
;---------------------------------------------------------------------
	km_IRQdmaRAMtoCGRAM	kx_palette,0,512

;---------------------------------------------------------------------
;*		Screen Data Transfer	(Yajima's)		*
;---------------------------------------------------------------------
	storenasty
	romnastyoff		;ROM nasty OFF
	jsl	irq_gameobj_l
	restorenasty

;---------------------------------------------------------------------
;*		Player H,V Scroll				*
;---------------------------------------------------------------------
	jsr	SethdmaHVScroll
	jsr	SetHVScroll_BG3

;---------------------------------------------------------------------
;*		VRAM Screen Double Buffer Swapping		*
;---------------------------------------------------------------------
	test_screenmode	swapbg1bg2
	beq	.normnoswap
	lda	vmap1+1			;Double buffer screen
	and	#$f0
	sta	nmitemp
;;	ora	#(bg2_cgx>>12)
	lda	vram_bg2_cgx+1
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	ora	nmitemp
	bra	.setit3d
.normnoswap
	lda	vmap1+1			;Double buffer screen
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	nmitemp
;;	ora	#(bg2_cgx>>8)&$f0
	lda	vram_bg2_cgx+1
	and	#$f0
	ora	nmitemp
.setit3d
	sta	bg12nba

	ldx	vmap1			;Bitmap double buffering
	ldy	vmap2
	stx	vmap2
	sty	vmap1

;---------------------------------------------------------------------
;*		Window	Double Buffer Swapping			*
;---------------------------------------------------------------------
	jsr	KSetWindowParams

;---------------------------------------------------------------------
;*		Read JOY Controller				*
;---------------------------------------------------------------------
	jsr	readjoypads		;Controller

;---------------------------------------------------------------------
;*		Screen Display Switch				*
;---------------------------------------------------------------------
;'94/8/15
	lda	kw_tm
	sta	tm
;---------------------------------------------------------------------
;*		Screen On notameno kari set			*
;---------------------------------------------------------------------
	jsr	setinidisp

;---------------------------------------------------------------------
;*			Soft Ware Timer				*
;---------------------------------------------------------------------
	shorta
	longi
	JSR	SoftWareTimer

;---------------------------------------------------------------------
;*		Kawaguchi IRQ END				*
;---------------------------------------------------------------------
KAWAGUCHI_IRQ_END
	stz	trans_flag	;[Clear IRQ flag]
	end_irq

;-------------
;*   Data    *
;-------------
data0
	dw	0

;*********************************************************************
;*			Window & Sound Call			*
;*********************************************************************
KSetWindowParams
	php
	a8i16
	km_eorwindowflag	windowwbuf
;* window *
	ldx	windowptr1	;Set window values
	beq	.setwindow

	km_bitcheckwindowflag	windowwbuf
	beq	.Pl1buf2
.Pl1buf1
	ldx	#kw_windowstructP1_buf1
	ldy	#kw_windowstructP2_buf1
	bra	.setwindow
.Pl1buf2
	ldx	#kw_windowstructP1_buf2
	ldy	#kw_windowstructP2_buf2
.setwindow
	jsr	setwindowpri
	plp
	rts

;-----------------------------------------------------------------------
	shorta
	longi
setwindowpri
	cpx	#0
	lbeq	.noreq	;no window flag

;* colour add/sub set *
	lda	wm_cgadsub,x
	sta	cgadsub		;2131h
;* colour data set *
	lda	wm_coldata,x
	beq	.nowrite
	sta	coldata		;2132h
	bra	.notindiv
.nowrite
	lda	wm_coldata_r,x
	and	#%11111
	ora	#%100000
	sta	coldata
	lda	wm_coldata_g,x
	and	#%11111
	ora	#%1000000
	sta	coldata
	lda	wm_coldata_b,x
	and	#%11111
	ora	#%10000000
	sta	coldata
;* through sub *
.notindiv
	lda	wm_ts,x
	sta	ts		;212dh

;* hdma table parameter *
	km_bitcheckwindowflag	normalwipe
	bne	.normalwipe
	test_screenmode	onescreen
	bne	.onescreenmode
	bra	.twoscreenmode

;***** Normal MODE *****
.normalwipe
	a16
	lda	wm_hdma,x
	sta.l	hdmawindow1
	clc
	adc	#112*2
	sta.l	hdmawindow2

	phx
	tyx
	lda	wm_hdma,x
	sta.l	hdmawindow2
	plx
	brl	.winend

;***** MISSION MODE *****
.onescreenmode
	a16
	lda	wm_hdma,x
	bne	.ok_mission1

	lda	#scrolloff&WM
	sta.l	hdmawindow_mission1
	sta.l	hdmawindow_mission2
	bra	.repeatdata_mission
.ok_mission1
	sta.l	hdmawindow_mission1

	phx
;;;	ldx	windowptr2	 	;Set window values
	tyx
	lda	wm_hdma,x
;;;	bne	.ok_mission2
;;;	lda	#scrolloff&WM
.ok_mission2
	sta.l	hdmawindow_mission2
	plx

	lda	wm_flags,x		;8/10/93 amendment
	bit	#wf_datarepeat
	bne	.repeatdata_mission
.notrepeatdata_mission
	lda.l	hdmawindow_mission1-1
	ora	#128
	sta.l	hdmawindow_mission1-1
	lda.l	hdmawindow_mission2-1
	ora	#128
	sta.l	hdmawindow_mission2-1
	brl	.winend
.repeatdata_mission
	lda.l	hdmawindow_mission1-1
	and	#~128
	sta.l	hdmawindow_mission1-1
	lda.l	hdmawindow_mission2-1
	and	#~128
	sta.l	hdmawindow_mission2-1
	bra	.winend
;*************************************************************************
;***** BATTLE ****
.twoscreenmode
	IFNE	kbattle
	a16
	lda	wm_hdma,x
	bne	.ok
;* window off *
	lda	#hdmawindowoff&WM
	cpx	#kw_windowstructP1_buf1
	beq	.win1_off
	cpx	#kw_windowstructP1_buf2
	beq	.win1_off

;;;	cpx	#windowarray1+maxwindows*wm_sizeof
;;;	bcc	.win1_off
.win2_off	sta.l	hdmawindow_battle2
	bra	.repeatdata
.win1_off	sta.l	hdmawindow_battle1
	bra	.repeatdata2
;--------------
.ok
	cpx	#kw_windowstructP1_buf1
	beq	.win1
	cpx	#kw_windowstructP1_buf2
	beq	.win1

;;;	cpx	#windowarray1+maxwindows*wm_sizeof
;;;	bcc	.win1

.win2	sta.l	hdmawindow_battle2

	lda	wm_flags,x
	bit	#wf_datarepeat
	bne	.repeatdata
	lda.l	hdmawindow_battle2-1
	ora	#128
	sta.l	hdmawindow_battle2-1
	bra	.winend
.repeatdata
	lda.l	hdmawindow_battle2-1
	and	#~128
	sta.l	hdmawindow_battle2-1
	bra	.winend

.win1	sta.l	hdmawindow_battle1
	lda	wm_flags,x		;8/10/93 amendment
	bit	#wf_datarepeat
	bne	.repeatdata2
	lda.l	hdmawindow_battle1-1
	ora	#128
	sta.l	hdmawindow_battle1-1
	bra	.winend
.repeatdata2
	lda.l	hdmawindow_battle1-1
	and	#~128
	sta.l	hdmawindow_battle1-1
	ENDC
;*************************************************************************
.winend
;--------------
	lda	wm_flags,x
	bit	#wf_windowon
	bne	.windowon
.windowoff
	lda	#hdmawindowoff&WM
	bra	.setwinmode
.windowon
	lda	#hdmawindowon&WM
.setwinmode
	sta.l	xhdma_window_battle+1
	sta.l	hdmawindow_battle1+3
	sta.l	hdmawindow_battle2+3
;--------------
	a8
;'95/3/31 :comment
;	lda	wm_cgswsel,x	;2130H
;	bit	#%110000
;	bne	.colwindow
;.normalwindow
	lda	wm_cgswsel,x
	sta	cgswsel		;2130H
	lda	wm_w12sel,x
	sta	w12sel		;2123H
	lda	wm_w34sel,x
	sta	w34sel		;2124H
	lda	wm_wobjsel,x
	sta	wobjsel		;2125H
	lda	wm_wbglog,x
	sta	wbglog		;212ah
	lda	wm_wobjlog,x
	sta	wobjlog		;212bh
	lda	wm_chparams,x
	sta	ch5params	;4350h
	bra	.donereq

	ifeq	1
	ora	#%00010000
	sta	cgswsel
	lda	#%10000000
	sta	wobjsel		; enable window 2
	lda	#0
	sta	wh2
	lda	#255
	sta	wh3
	endc

;'95/3/31 :comment
;.colwindow
;	sta	cgswsel		;2130h
;	stz	w12sel		;2123H
;	stz	w34sel		;2124H
;	lda	wm_wobjsel,x
;	sta	wobjsel		;2125h
;	lda	wm_chparams,x
;	sta	ch5params	;4350h
;	bra	.donereq

;-----------------------------------------------------------------------
;***** screen add *****
.noreq
;--- no window ---
	stz	wobjsel		;window off :2125h
	stz	w12sel		;switch off :2123h
	stz	w34sel		;switch off :2124h
	lda	#$e0
	sta	coldata		;colour data clear

	km_bitcheckscreenflag	screenadd
	beq	.noscradd
	lda	#%00000010
	sta	cgswsel		;screen add

;	km_cmpcheckgamemode	selectbattlefield
;	beq	.selbtfl

	km_bitcheckscreenflag	halfadd
	bne	.scrhalfadd
	lda	#%00010000  ;obj no gamen ni bg1,2 wo kasan
	bra	.scradd
.scrhalfadd
	lda	#%01010000  ;obj no gamen ni bg1,2 wo 1/2 kasan
.scradd
	sta	cgadsub
	lda	#%00000111	;
	sta	ts
	bra	.donereq
.selbtfl
;	lda	#%10000001  ;bg1 no gamen ni bg2 wo gensan
;	sta	cgadsub
;	lda	#%00000010
;	sta	ts
;	bra	.donereq
.noscradd
;(Initial no setting ni shitagau !!)
;	lda	#0
;	sta	cgswsel
;	sta	cgadsub
;	sta	ts
;----------
.donereq

;'94/9/15 :henkou shita
;'95/4/21 :comment
;	km_cmpcheckgamemode	missiongameover
;	beq	.tmwoff
;	km_cmpcheckgamemode	missioncontinue
;	beq	.tmwoff
;.tmwon

	km_setval	tmw,$1f

;	bra	.skip
;.tmwoff
;	km_setval	tmw,0
;.skip
;;;	stz	w12sel
;;;	stz	w34sel
;;;	stz	wbglog
;;;	stz	tmw
;;;	lda	#%1100
;;;	sta	wobjlog

.exit
	rts

;--------------------------------------------------------------------------------------
window_buffer	php
	a16
	ldx	hdmacirclebuf1		;Double buffer windows
	lda	hdmacirclebuf2
	stx	hdmacirclebuf2
	sta	hdmacirclebuf1
	sta	ch3addra1tl
	a8
	lda	whichcircle
	eor	#1
	sta	whichcircle
	plp
	rts
;=====================================================================
;*		Mission Sprite CGX Trans			*
;=====================================================================
mis_sprcgxtrans
	km_IRQdmaXromVRAM	(SwapCGXBuffer1&$ff0000),swapsprvram,swapsprlen
	rts

;=====================================================================
;*			Dma Transfer Params			*
;* Xreg,Acc :Address&Bank						*
;* Yreg     :Length							*
;=====================================================================
SetDmaVramParams_l
	shorta
	longi
	sta	ch0atbank
	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	lda	#%00000001
	bra	SetDmaSub
SetDmaCOLAdrLen_l
	shorta
	longi
	sta	ch0atbank
	lda	#(cgdata&$ff)	;2122h
	sta	ch0addrb
	lda	#%00000010
	bra	SetDmaSub

SetDmaOARAMClrParams_l
	shorta
	longi
	ldx	#sprites&WM
	stx	wmaddl		;RAM address
	lda	#(sprites&$10000)>>16
	sta	wmaddh		;RAM bank

	lda	#wmdata&BM
	sta	ch0addrb	;PPU reg
	lda	#oambufclr_data>>16
	sta	ch0atbank
	ldx	#oambufclr_data&WM
	ldy	#obj_val*4
	lda	#%00001000	;1 adr only write ,Abus -->B bus,adr FIX
	bra	SetDmaSub
SetDmaOARAMParams_l
	shorta
	longi
	sta	ch0atbank
	lda	#oamdata&$ff
	sta	ch0addrb
	lda	#0
	sta	oamaddl
	sta	oamaddl+1
	lda	#0
SetDmaSub
	sta	ch0params
	stx	ch0addra1tl
	sty	ch0dataddrl
	lda	#1
	sta	mdmaen		;dma switch
	rtl

SetDmaRomRamParams_l
SetDmaRamRamParams_l
SetDmaMRamRamParams_l
	shorta
	longi
	sta	wmaddh
	stx	wmaddl
	bra	SetDmaRamRam_sub	

SetDmaColRAMParams_l
	shorta
	longi
;********* Clour Data Transfer *********
;* XRAM Address *
	a16
	lda	palettestart
	asl	a
	clc
	adc	#kx_palette&WM
	sta	wmaddl
	a8
	lda	#kx_palette>>16
	sta	wmaddh
SetDmaRamRam_sub
	shorta
	longi
	lda	#(wmdata&$ff)
	sta	ch0addrb
;* Mario RAM address *
	ldx	vram3addr
	stx	ch0addra1tl
	lda	vram3addr+2
	sta	ch0atbank
;* Length *
	ldx	vram3len
	stx	ch0dataddrl

	stz	ch0params
	lda	#1
	sta	mdmaen
	rtl

;=====================================================================
;*								*
;*			H,V scroll Set				*
;*								*
;=====================================================================
SethdmaHVScroll
	shorta
	longi
	php

	IFNE	kbattle
	km_bitcheckgameflag	battle
	km_bne	.twoscreen
	ENDC
;---------------------------------
;*	Mission Version	    *
;---------------------------------
.onescreen
;************* H scroll ****************
;* h-dma Hscroll table address *
	a16
	lda	#scrolloff&WM
	sta.l	xh_hscrolladr0_mis
	lda	kw_hdma_hscraddr1
	sta.l	xh_hscrolladr1_mis
	lda	kw_hdma_hscraddr2
	sta.l	xh_hscrolladr2_mis
	a8
;* h-dma Hscroll repeat flag *
	lda	kw_hdma_hscrflag1
	bit	#khsf_repeat
	beq	.notrepeat1_mis
.repeat1_mis
	lda.l	xh_hscrolladr1_mis-1
	and	#~128
	sta.l	xh_hscrolladr1_mis-1
	sta.l	xh_hscrolladr2_mis-1
	bra	.hrepeatend_mis
.notrepeat1_mis
	lda.l	xh_hscrolladr1_mis-1
	ora	#128
	sta.l	xh_hscrolladr1_mis-1
	sta.l	xh_hscrolladr2_mis-1
.hrepeatend_mis
;************* V scroll ****************
;* h-dma Vscroll table address *
	a16
	lda	#scrolloff&WM
	sta.l	xh_vscrolladr0_mis
	lda	kw_hdma_vscraddr1
	sta.l	xh_vscrolladr1_mis
	lda	kw_hdma_vscraddr2
	sta.l	xh_vscrolladr2_mis
	a8
;* h-dma V scroll repeat flag *
	lda	kw_hdma_vscrflag1
	bit	#kvsf_repeat
	beq	.notrepeatv1_mis
.repeatv1_mis
	lda.l	xh_vscrolladr1_mis-1
	and	#~128
	sta.l	xh_vscrolladr1_mis-1
	sta.l	xh_vscrolladr2_mis-1
	bra	.vrepeatend_mis
.notrepeatv1_mis
	lda.l	xh_vscrolladr1_mis-1
	ora	#128
	sta.l	xh_vscrolladr1_mis-1
	sta.l	xh_vscrolladr2_mis-1
.vrepeatend_mis
;-------------------------------------------
	a16
;* normal scroll no baai *
	km_bitcheckscrollflag	raster
	bne	.notnormal_mis
	lda	player1hscroll
	sta.l	xh_hscrolltbl1
	sta.l	xh_hscrolltbl2
	lda	player1vscroll
	sta.l	xh_vscrolltbl1
	sta.l	xh_vscrolltbl2
.notnormal_mis

;* H-V offset no buffer2 gawano settei *
;;	lda	#((hvofs_base1>>5)&31)<<3
	lda	vram_hvofs_base1
	ror	a
	ror	a
	and	#31<<3
	sta.l	xh_hvofs	;(hdma tabs.asm)
	brl	.hvscrollEND
;**************************************************************************
	IFNE	kbattle
;---------------------------------
;*	BATTLE Version	    *
;---------------------------------
.twoscreen
;************* H scroll ****************
;* h-dma address *
	a16
	lda	#scrolloff&WM
	sta.l	xh_hscrolladr0_bat
	lda	kw_hdma_hscraddr1
	sta.l	xh_hscrolladr1_bat
	lda	kw_hdma_hscraddr2
	sta.l	xh_hscrolladr2_bat
	a8
;* h-dma flag *
	lda	kw_hdma_hscrflag1
	bit	#khsf_repeat
	beq	.notrepeat1_bat
.repeat1_bat
	lda.l	xh_hscrolladr1_bat-1
	and	#~128
	sta.l	xh_hscrolladr1_bat-1
	bra	.check_repeat2_bat
.notrepeat1_bat
	lda.l	xh_hscrolladr1_bat-1
	ora	#128
	sta.l	xh_hscrolladr1_bat-1
.check_repeat2_bat
	lda	kw_hdma_hscrflag2
	bit	#khsf_repeat
	beq	.notrepeat2_bat
.repeat2_bat
	lda.l	xh_hscrolladr2_bat-1
	and	#~128
	sta.l	xh_hscrolladr2_bat-1
	bra	.hrepeatend_bat
.notrepeat2_bat
	lda.l	xh_hscrolladr2_bat-1
	ora	#128
	sta.l	xh_hscrolladr2_bat-1
.hrepeatend_bat
;************* V scroll ****************
;* h-dma address *
	a16
	lda	#scrolloff&WM
	sta.l	xh_vscrolladr0_bat
	lda	kw_hdma_vscraddr1
	sta.l	xh_vscrolladr1_bat
	lda	kw_hdma_vscraddr2
	sta.l	xh_vscrolladr2_bat
	a8
;* h-dma flag *
	lda	kw_hdma_vscrflag1
	bit	#kvsf_repeat
	beq	.notrepeatv1_bat
.repeatv1_bat
	lda.l	xh_vscrolladr1_bat-1
	and	#~128
	sta.l	xh_vscrolladr1_bat-1
	bra	.check_repeatv2_bat
.notrepeatv1_bat
	lda.l	xh_vscrolladr1_bat-1
	ora	#128
	sta.l	xh_vscrolladr1_bat-1
.check_repeatv2_bat
	lda	kw_hdma_vscrflag2
	bit	#kvsf_repeat
	beq	.notrepeatv2_bat
.repeatv2_bat
	lda.l	xh_vscrolladr2_bat-1
	and	#~128
	sta.l	xh_vscrolladr2_bat-1
	bra	.vrepeatend_bat
.notrepeatv2_bat
	lda.l	xh_vscrolladr2_bat-1
	ora	#128
	sta.l	xh_vscrolladr2_bat-1
.vrepeatend_bat
;-----------------------------------------------------
;* normal scroll no baai *
	a16
	km_bitcheckscrollflag	raster
	bne	.notnormal_bat
	lda	player1hscroll
	sta.l	xh_hscrolltbl1
	lda	player2hscroll
	sta.l	xh_hscrolltbl2
	lda	player1vscroll
	sta.l	xh_vscrolltbl1
	lda	player2vscroll
	sta.l	xh_vscrolltbl2
.notnormal_bat
;* H-V offset no buffer2 gawano settei *
;;	lda	#((hvofs_base2>>5)&31)<<3
	lda	vram_hvofs_base2
	ror	a
	ror	a
	and	#31<<3
	sta.l	xh_hvofs
	ENDC
;**************************************************************************

.hvscrollEND
	plp
	rts

;=====================================================================
;*			Set HV Scroll (BG3)			*
;*								*
;=====================================================================
SetHVScroll_BG3
	shorta
	longi
	lda	kw_bg3hofs
	sta	bg3hofs
	lda	kw_bg3hofs+1
	sta	bg3hofs

	lda	kw_bg3vofs
	sta	bg3vofs
	lda	kw_bg3vofs+1
	sta	bg3vofs
	rts
;----------------------------------------------
;*	Not Using Area	

;----------------------------------------------
	IFEQ	1
;* change hdma indirect flags *
;* V scroll *
	lda	kw_vscrollmode
	sta	ch2params	;(indirect mode)
	ldx	kw_hdma_vscrolladdr
	stx	ch2addra1tl
	lda	kw_hdma_vscrollbank
	sta	ch2atbank
;* H scroll *
	lda	kw_hscrollmode
	sta	ch3params	;(indirect mode)
	ldx	kw_hdma_hscrolladdr
	stx	ch3addra1tl
	lda	kw_hdma_hscrollbank
	sta	ch3atbank
;-----------------------------------------------------
	a16
	longi
	test_screenmode	onescreen
	beq	.twoscreenmode		;If Cockpit Display
.onescreenmode
;94/5/18 :kawaguchi ga kaemashita.
	lda	player1hscroll
	sta.l	xh_hscrolltbl1
	sta.l	xh_hscrolltbl2

;;;	sta.l	xh_hscrolladr1_normal
;;;	sta.l	xh_hscrolladr2_normal

	lda	player1vscroll
	sta.l	xh_player1vscroll
	sta.l	xh_halfvscroll
	sta.l	xh_player2vscroll

;;	lda	#((hvofs_base1>>5)&31)<<3
	lda	vram_hvofs_base1
	ror	a
	ror	a
	and	#31<<3
	sta.l	xh_hvofs

;--- Not Using ---
	ifeq	1
	lda	player1hscroll
	sta.l	xh_player1hscroll
	sta.l	xh_halfhscroll
	sta.l	xh_player2hscroll
	endc
	ifeq	1
	lda	player1hscroll
	sta.l	xh_player1hscroll_one
	lda	player1vscroll
	sta.l	xh_player1vscroll_one
	endc
	bra	.hvscrollEND

.twoscreenmode
;94/5/18 :kawaguchi ga kaemashita.
	lda	player1hscroll
	sta.l	xh_hscrolltbl1

;;;	sta.l	xh_hscrolladr1_normal
;;	sta.l	xh_hscrolladr2_normal
	lda	player2hscroll
	sta.l	xh_hscrolltbl2

	lda	player2vscroll
	sta.l	xh_player2vscroll

;;	lda	#((hvofs_base2>>5)&31)<<3
	lda	vram_hvofs_base2
	ror	a
	ror	a
	and	#31<<3
	sta.l	xh_hvofs
;--- Not using ----
	ifeq	1
	lda	player1hscroll
	sta.l	xh_player1hscroll
	endc
	lda	player1vscroll
	sta.l	xh_player1vscroll
	ifeq	1
	lda	player2hscroll
	sta.l	xh_player2hscroll
	endc
.hvscrollEND
	a8
	ENDC




;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
	shorta
	shorti
irqsetmode1	start_irq
	i16
	lda	#1
	ora	bg2charsize
	ora	bg3charsize
	sta	bgmode
.same	LOCAL
	lda	hdmaen_gc
	sta	hdmaen
	stz	gamemode
	lda	kw_tmptm	;#1+2+16
	sta	tm
	sta	kw_tm

	stz	bg2vofs
	stz	bg2vofs

	stz	bg3scrollflag
	stz	flashtunnelon
	stz	flashbg
	stz	dospacesc

	km_setgamepal

	set_zdepthtable	normal
	a16
	lda	#128
	sta.l	m_scrollXoff
	stz	lastpalfade
	stz	defaultID
	stz	bg2Xscroll
	lda	#0
	sta.l	bholescaleval
	a8
	stz	noxrot
	stz	fadepal
;	stz	tunnelscroll

	test_screenmode	vertconnect
	beq	.1way
	lda	#2
	bra	.set2
.1way	lda	#1
.set2	sta	nmitemp
;;	ora	#bg2_scr>>8
	lda	vram_bg2_scr+1
	ora	nmitemp
	sta	nmitemp
	test_screenmode	swapbg1bg2
	beq	.norm
	lda	nmitemp
	sta	bg1sc
	bra	.notnorm
.norm	lda	nmitemp
	sta	bg2sc
.notnorm
	lda	kw_bg3sc
	ora	bg3screensize
	sta	bg3sc

	stz	trans_flag
	end_irq
	rtl

	shorta
	shorti
irqsetmode2
	start_irq
	i16
	lda	#2
	ora	bg2charsize
	sta	bgmode
	brl	irqsetmode1.same


	shorta
	shorti
newbg2chr
	start_irq
	i16

;* dma crash boushi no tame no check !!! *
	km_bitcheckscreenflag	noset_col
	bne	.skip
	jsl	SetDmaColRAMParams_l
.skip
	km_clrscreenflag	noset_col

	IFEQ	1
	lda	#cgdata&$ff		;DNLD palette
	sta	ch0addrb
	lda	palettestart
	sta	cgadd
	ldx	vram3addr
	stx	ch0addra1tl
	lda	vram3addr+2
	sta	ch0atbank
	ldx	vram3len
	stx	ch0dataddrl
	stz	ch0params
	lda	#1
	sta	mdmaen
	ENDC

;********* BG2 CGX Data Transfer *********
	shorta
	longi
	lda	#$80		;DNLD chars
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	ldx	vram1addr
	stx	vmaddl
	ldx	#($700000+dec_base)&WM
	stx	ch0addra1tl
	lda	#(($700000+dec_base)>>16)
	sta	ch0atbank
	ldx	vram1len
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen

	inc	trans_flag
	inc	trans_flag
	end_irq
	rtl


	shorta
	shorti
newbg2scr
	start_irq
	i16
;*********** BG2 Scr Data Transfer ***************
	lda	#$80		;DNLD screen
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	ldx	vram2addr
	stx	vmaddl
	ldx	#($700000+dec_base+bg2_cgx_len)&WM
	stx	ch0addra1tl
	lda	#(($700000+dec_base+bg2_cgx_len)>>16)
	sta	ch0atbank
	ldx	vram2len
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen

;********** Game Palette Transfer ************
	IFEQ	1		; obsolete
	lda	#cgdata&$ff		;DNLD game palette
	sta	ch0addrb
	lda	#16*pal3d
	sta	cgadd
	a16
	lda	#gamepalbuff&WM
	sta	ch0addra1tl
	a8
	lda	#gamepalbuff>>16
	sta	ch0atbank
	ldx	#32
	stx	ch0dataddrl
	stz	ch0params
	lda	#1
	sta	mdmaen

	ENDC

	stz	trans_flag
	end_irq
	rtl



	shorta
	shorti
newbg3	i16
;********* BG3 CGX Data Transfer *********
	lda	#$80		;DNLD chars
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
;;;;	ldx	vram1addr
	ldx	vram_bg3_cgx
	stx	vmaddl
	ldx	#($700000+dec_base)&WM
	stx	ch0addra1tl
	lda	#(($700000+dec_base)>>16)
	sta	ch0atbank
	ldx	vram1len
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen

;*********** BG3 Scr Data Transfer ***************
	lda	#$80		;DNLD screen
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
;;;;	ldx	vram2addr
	ldx	vram_bg3_scr
	stx	vmaddl
	ldx	#($700000+dec_base+bg2_cgx_len)&WM
	stx	ch0addra1tl
	lda	#(($700000+dec_base+bg2_cgx_len)>>16)
	sta	ch0atbank
	ldx	vram2len
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen


	IFEQ	1
	lda	#$80		;DNLD chars
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	ldx	vram1addr
	stx	vmaddl
	ldx	#($700000+dec_base)&WM
	stx	ch0addra1tl
	lda	#(($700000+dec_base)>>16)
	sta	ch0atbank
	ldx	vram1len
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen

	lda	#$80		;DNLD screen
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	ldx	vram2addr
	stx	vmaddl
	ldx	#($700000+dec_base+6144)&WM
	stx	ch0addra1tl
	lda	#(($700000+dec_base+6144)>>16)
	sta	ch0atbank
	ldx	vram2len
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen
	ENDC

	stz	trans_flag
	rtl



	shorta
	shorti
randtrans_i
	start_irq
	jsl	randtrans
	a8i16
	end_irq

randtrans
	i16
	IFEQ	NOBGTRANS
	lda	#$80
	sta	vmainc
	lda	#(vmdatal&$ff)
	sta	ch0addrb
	ldx	vram1addr
	stx	vmaddl
	ldx	#($700000+dec_base)&WM
	stx	ch0addra1tl
	lda	#(($700000+dec_base)>>16)
	sta	ch0atbank
	ldx	vram1len
	stx	ch0dataddrl
	lda	#1
	sta	ch0params
	lda	#1
	sta	mdmaen
	ENDC
	stz	trans_flag
	rtl
;--------------------------------------------------------------------------
	shorta
	shorti
irqblank
	km_bitcheckgameflag	kawairq
	bne	.kawairq
	start_irq
;	inc	checkirq
	jsr	startmus
	i16
	end_irq
	rtl

.kawairq
	jsr	startmus
	rtl
;--------------------------------------------------------------------------
	shorta
	shorti
irqkawablank

	jsr	startmus
	i16
	rtl
;--------------------------------------------------------------------------
	shorta
	shorti
sndwaitirq
	start_irq	;[h-dma wait & Blanking]
	km_bitchecksndflag	translock
	bne	.skip
	stz	trans_flag
.skip
	i16
	jsr	readjoypads

	jsr	setinidisp

;	lda.l	xinidisp1
;	sta	inidisp		;[Blanking Off or Fade]

	stz	htimel

	lda	#iv_screenonirq
	sta	trans_flag2
	ldx	screenon_position
	stx	vtimel
	rtl
;--------------------------------------------------------------------------
readjoypads
	php
	a8

.notreadyyet1
;(DAME) :kono check wo ireruto kanzen ni key read wo suru kotoga dekiruga
;       :1 frame osoku narukotoga aru noga ketten !!
;	lda	hvbjoyr
;	bit	#1
;	beq	.notreadyyet1	;joycont enable check1

.notreadyyet2
	lda	hvbjoyr
	bit	#1
	bne	.notreadyyet2	;joycont enable check2

	a16
	lda	joy1l
	pha
	eor	cont0
	and	joy1l
	sta	trig0

	lda	joy2l
	pha
	eor	cont1
	and	joy2l
	sta	trig1
	pla
	sta	cont1
	pla
	sta	cont0
	plp
	rts

;--------------------------------------------------------------------------
	shorta
	longi
setbg2vofs	a8
	IFEQ	1
	lda	bg2vofsoverride
	beq	.ok
	lda	bg2vofsreq
	sta	bg2vofs
	lda	bg2vofsreq+1
	sta	bg2vofs
	lda	bg2hofsreq
	sta	bg2hofs
	lda	bg2hofsreq+1
	sta	bg2hofs
	rts
.ok
	lda	inatunnel
	beq	.skipdd

	a16
	lda	oldviewposz
	lsr	a
	lsr	a
	and	#62
	tax
	lda.l	chequered_tables,x
	tay
	a8
	phb
	lda	#chequered_tables>>16
	pha
	plb
	ldx	#0
.lp	lda.w	0,y
	bpl	.norm
	and	#127
	sta.l	xhdma_bg2vofs+3,x
	inx
	lda	#cscr2&BM
	sta.l	xhdma_bg2vofs+3,x
	inx
	lda	#cscr2>>8
	sta.l	xhdma_bg2vofs+3,x
	bra	.finishoff
.norm	sta.l	xhdma_bg2vofs+3,x
	inx
	lda	#cscr1&BM
	sta.l	xhdma_bg2vofs+3,x
	inx
	lda	#cscr1>>8
	sta.l	xhdma_bg2vofs+3,x
.finishoff
	inx
	iny
	cpx	#224*3
	bne	.lp
	plb
.skipdd
	ENDC
	rts

;--------------------------------------------------------------------------
	shorta
setinidisp
	lda	stayblack
	inc	a
	beq	.nowait
.blackwait
	lda	#$8F
	sta.l	xinidisp1
	sta.l	xinidisp2
	brl	.done
.nowait
	lda	fadedir		;Set inidisp
	lbeq	.done
	bpl	.fadeup
.fadedown	cmp	#-2
	beq	.qfadedown
	cmp	#-3
	beq	.sfadedown
.fade1	lda	fade
.setdown	beq	.off
	dec	a
	beq	.off
;	sta.l	xinidisp1
;	sta.l	xinidisp2
;	sta.l	xinidisp1a
;	sta	fade
;	bra	.done
	bra	.setfade	;.done

.off	lda	#$8F
	sta.l	xinidisp1
	sta.l	xinidisp2
	sta.l	xinidisp1a
	stz	fadedir
	stz	fade
	bra	.done
.sfadedown	lda	gameframe
	and	#1
	beq	.fade1
	rts
.qfadedown	lda	fade
	beq	.off
	dec	a
	beq	.off
	bra	.setdown
.fadeup	cmp	#2
	beq	.qfadeup

	cmp	#3
	beq	.sfadeup

.getfade	lda	fade
.setup	cmp	#15
	beq	.on
	inc	a
;.setqup
;	sta.l	xinidisp1
;	sta.l	xinidisp2
;	sta.l	xinidisp1a
;	sta	fade
	bra	.setfade	;.done
;---------------------------------
.on	stz	fadedir
	lda	#15
;---------------------------------
;1994/12/16 :comment
;1995/3/9 :comment kaijyo !!
;nazenara blanking OFF kara Blanking ON wo ikinari surutoki konosyori wo
;irenaito BLANKING wo kaijyo shinai !!!
.setfade
.setqup
	sta	fade
	sta.l	xinidisp1
	sta.l	xinidisp2
	sta.l	xinidisp1a
	bra	.done
;---------------------------------
.qfadeup	lda	fade
	cmp	#15
	beq	.on
	inc	a
	cmp	#15
	beq	.setqup
	inc	a
	bra	.setqup
;---------------------------------
.sfadeup
	dec	kw_fadetm
	bne	.done
	km_setvar	kw_fadetm,kw_fadetmcmp
	bra	.getfade
;---------------------------------
.done
	rts

;-----------------------------------------------------------------------


;-----------------------------------------------------------------------
	longa
	longi
ramchase
	stx	nmitemp
	cmp	nmitemp
	sty	nmitemp
	beq	.nc
	bmi	.pos
	sec
	sbc	nmitemp
	bra	.nc
.pos	clc
	adc	nmitemp
.nc
	rts
;**********************************************************************
;---------------------------------------------------------------------
;*			Set sound data				*
;*						[kawaguchi]	*
;* Acc 8,idx 8							*
;---------------------------------------------------------------------
;**********************************************************************
startmus
	php
	ai8
;---------------------------------------------------------------------
;*			BGM	 			[BGM]	*
;---------------------------------------------------------------------
.setport0
	lda	bgmcnt
	beq	.start	;if bgmcnt = 0 then .start
	dec	a
	beq	.check	;if bgmcnt = 1 then .check
	bra	.sound_effect
;----------------------------------------------------------
.start
	lda	bgm_music
	sta	apu_port0	;Set sound port 0
	km_setval	bgmcnt,1
	brl	.ret
;----------------------------------------------------------
.check
	lda	apu_port0
	cmp	bgm_music
	beq	.check_ok
	brl	.ret		;if now sound = before sound then sound clear
.check_ok
	km_setval	bgmcnt,2
	bra	.sound_effect
;----------------------------------------------------------

;-----------------------------------------------------
;*		Buffer Type			*
;-----------------------------------------------------
;Port 3 wo taterutokorode Set
;;;;	lda	bgm_music_back	;buffer type :'95/6/30

	IFEQ	1
	ldx	bgm_musicptr

	lda	bgmcnt
	bne	.check
.start
	cpx	bgm_musicptr_limt
	beq	.sound_effect
	lda	bgm_music,x
	sta	apu_port0	;Set sound port 0
	sta	bgm_music_back
	km_setval	bgmcnt,1
	brl	.ret
;----------------------------------------------------------
.check
	lda	apu_port0
	cmp	bgm_music,x
	beq	.check_ok
	brl	.ret		;if now sound = before sound then sound clear
.check_ok
	lda	bgm_musicptr
	inc	a
	and	#3
	sta	bgm_musicptr

	km_setval	bgmcnt,0
	bra	.sound_effect
	ENDC
;----------------------------------------------------------
;**************************************************************************

;'94/9/4 :
	ifeq	1
	lda	bgmcnt
	bne	.NotChangeBGM

	km_setvar	apu_port0,bgm_music	;Set Port 0
	km_setval	bgmcnt,1
.NotChangeBGM
	endc
;*********************************************************************
;* 94/4/18
;* imawa kono ROUTINE wa tukawarete inai *
.sound_effect
	km_bitchecksndflag	allstop
	beq	.skip1
	stz	sdport1
	stz	sdport2
.skip1
	km_bitchecksndflag	port2stop
	beq	.skip2
	stz	sdport2
.skip2
;---------------------------------------------------------------------
;*			PORT1	 			[LEVEL]	*
;---------------------------------------------------------------------
	km_setvar	apu_port1,sdport1
;---------------------------------------------------------------------
;*			PORT2	 			[LEVEL]	*
;---------------------------------------------------------------------
;* port2 *
	shorta
	i16
;--- sound No ga onajika check ---
	lda	sdchkno2
	cmp	sdbakno2
	bne	.setport2	;chigau sound No
;--- onaji alien ka check ---
	ldx	sdchkptr2
	cpx	sdbakptr2
	beq	.setport2	;onaji alien ptr
.clrport2
	km_setval	apu_port2,0
	bra	.setbackval
.setport2
	km_setvar	apu_port2,sdport2
.setbackval
	km_setvar	sdbakno2,sdchkno2
	km_stxvar	sdbakptr2,sdchkptr2
.nosnd2
;---------------------------------------------------------------------
;*			PORT3				[SE]	*
;---------------------------------------------------------------------
;* SOUND no modorichi wa INPUT DATA to onaji *
;*modorichi no CHECK *
.setport3
	i8
	lda	sdpck3		;(sdpck3 ... before sound)
;'94/9/5 :comment
;;;;	beq	.sndp040	;if before sound = 0 then [sound set ok]

	cmp	apu_port3
	bne	.ret		;moshi sound tensou ga owatte inakattra

;* TRIGGER DATA SET *
.sndp040
	lda	pausesnd
	bne	.pause		;if pause sound

	ldx	sdgpt3	;sdgpt3 .. SOUND DATA wo SET surutameno POINTER
	cpx	sdspt3	;sdspt3	.. SOUND DATA wo buffer ni touroku suru tameno POINTER
	beq	.ret	;Moshi = 0 nara SET suru DATA ganai

;* APU PORT3 *
	lda	sdport3,x
	cmp	sdpck3
	beq	.samesound	;moshi maeno sound to onaji dattara
	sta	apu_port3
	sta	sdpck3		;before sound

	lda	sdgpt3
	inc	a
	inc	a
	and	#31
	sta	sdgpt3

;* APU PORT0 *
	lda	bgm_music
;;;;	lda	bgm_music_back	;buffer type :'95/6/30
	and	#%00001111
	ora	sdport3+1,x
	sta	apu_port0	;Set sound port 0
.ret
	plp
	rts

.samesound
	stz	apu_port3
	stz	sdpck3
.reject
;* kokoni kitara BUG desu *
	plp
	rts
.pause
	sta	apu_port3
	sta	sdpck3
	stz	sdspt3
	stz	sdgpt3
	stz	pausesnd
	plp
	rts
;-----------------------------------------------------------------------
	IFEQ	1
startmus
	php
	ai8
	lda	bgmcnt
	beq	.start
	dec	a
	beq	.check
	bra	.trig3
.start	lda	bgm_music
	sta	apu_port0
	inc	bgmcnt
	bra	.trig3
.check	lda	apu_port0
	cmp	bgm_music
	bne	.start
	stz	apu_port0
	inc	bgmcnt
.trig3

	lda	sdpck3		;check last sound
	beq	.sndp040
	cmp	apu_port3
	bne	.reject

	stz	sdpck3
	stz	apu_port3
.sndp040
	lda	pausesnd
	bne	.pause

	ldx	sdgpt3
	cpx	sdspt3
	beq	.ret
	lda	sdport3,x
	sta	apu_port3
	sta	sdpck3
	lda	sdgpt3
	inc	a
	and	#15
	sta	sdgpt3
.ret	plp
	rts
.reject
	plp
	rts

.pause
	sta	apu_port3
	sta	sdpck3
	stz	sdspt3
	stz	sdgpt3
	stz	pausesnd
	plp
	rts
	ENDC


;-----------------------------------------------------------------------
irqrand	lda	rand
	clc
	sbc	rand+1
	sta	rand+1
	sbc	rand+2
	sta	rand+2
	sbc	rand+3
	sta	rand+3
	sbc	rand
	sta	rand
	rts
;-----------------------------------------------------------------------
	ifeq	1
	shorta
	longi
threedeeglasscsub
	lda	#%00000010
	sta	cgswsel
	lda	#2
	sta	tm
	sta	kw_tm
	lda	#1
	sta	ts
	lda	#%10100010
	sta	cgadsub
	rts
	endc
;--------------------------------------------------------------------------------------
dealwithfade
	a8
	lda	fadedir
	beq	.set
	clc
	adc	fade
	bpl	.ok
	lda	#0
	bra	.set2
.ok	cmp	#16
	bmi	.set2
	lda	#15
.set2	sta	fade
.set	lda	fade
	sta	inidisp
	rts
	
;--------------------------------------------------------------------------------------
	shorta
	shorti
mapirq
	a8i16
	stz	trans_flag
	km_IRQdmaoaram	sprites,(128*4)+(128/4)	; dma into oram
	jsr	dealwithfade
	jsr	startmus
	jsr	readjoypads
	rtl


;--------------------------------------------------------------------------------------
	shorta
	shorti
newpalette
	start_irq
	i16

;* XRAM Address *
	a16
	lda	palettestart
	asl	a
	clc
	adc	#kx_palette&WM
	sta	wmaddl
	a8
	lda	#((kx_palette>>16)&1
	sta	wmaddh

;* Mario RAM address *
	ldx	vram3addr
	stx	ch0addra1tl
	lda	vram3addr+2
	sta	ch0atbank
;* Length *
	ldx	vram3len
	stx	ch0dataddrl

	lda	#(wmdata&$ff)
	sta	ch0addrb

	stz	ch0params
	lda	#1
	sta	mdmaen

	ifeq	1
	lda	#cgdata&$ff		;DNLD palette
	sta	ch0addrb
	lda	palettestart
	sta	cgadd
	ldx	vram3addr
	stx	ch0addra1tl
	lda	vram3addr+2
	sta	ch0atbank
	ldx	vram3len
	stx	ch0dataddrl
	stz	ch0params
	lda	#1
	sta	mdmaen
	endc

	stz	trans_flag
	end_irq
	rtl

;*********************************************************************
;*								*
;*			Pause IRQ Routine			*
;*********************************************************************
	shorta
	shorti
pauseirq
	a8i16
	start_irq
	stz	trans_flag
;---------------------------------------------------------------------
;*			READ JOYPADS				*
;---------------------------------------------------------------------
;'94/10/6 :key read enable no tokoro ni idou
	jsr	readjoypads
;---------------------------------------------------------------------
;*			Sprite CGX Swap				*
;---------------------------------------------------------------------
	km_bitcheckmissionflag	spriteswap
	beq	.NotSpriteSwap

	ldx	#SwapCGXBuffer1&WM	;w1_cgx&WM	;pause off
	km_bitcheckgameflag	pausedisable
	beq	.skip
	ldx	#SwapCGXBuffer2&WM	;w2_cgx&WM	;pause on
.skip
	jsr	mis_sprcgxtrans
	km_clrmissionflag	spriteswap
.NotSpriteSwap
;---------------------------------------------------------------------
;*		Sprite Data DMA Transfer			*
;---------------------------------------------------------------------
;*Sprites buffer = Double buffer *
;* sprstates (0... buffer1 transfer ,1... buffer2 transfer) *
	km_jmpscreenflag	oamtensou,.transfer_buffer2
.transfer_buffer1
	km_IRQdmaoaram	sprites,(128*4)+(128/4)			; dma into oram
	bra	.OAMtransEnd
.transfer_buffer2
	km_IRQdmaoaram	(sprites+128*4+128/4),(128*4)+(128/4)	; dma into oram
.OamTransEnd
;---------------------------------------------------------------------
;*			Window					*
;---------------------------------------------------------------------
	jsr	KSetWindowParams

;---------------------------------------------------------------------
;*		Pause IRQ End 					*
;---------------------------------------------------------------------
	end_irq

;-----------------------------------------------------------------------
; find the window with the highest priority for screen #1 and screen #2
; and flag it to be displayed

find_window_pri_l
	php
	a8i16
	storenasty
	nastyon

	a16
;*** player1 ***
	lda	windowmode1	;pri flag
	ldx	#windowarray1
	jsr	find_window_pri
	stx	windowptr1
;* W buffer kirikae *
	ldy	#kw_windowstructP1_buf1
	km_bitcheckwindowflag	windowwbuf
	beq	.Pl1buf1
.Pl1buf2
	ldy	#kw_windowstructP1_buf2
.Pl1buf1
	cpx	#0
	beq	.offwindow1
.onwindow1
	lda	#wm_sizeof-1
	km_mvn	0,0
	bra	.player2
.offwindow1
	a8
	km_setval.w	wm_wobjsel,0,y		;window off
	km_setval.w	wm_coldata,$e0,y	;colour add off
	a16
;*** player 2 ***
.player2
	lda	windowmode2
	ldx	#windowarray2
	jsr	find_window_pri
	stx	windowptr2
;* W buffer kirikae *
	ldy	#kw_windowstructP2_buf1
	km_bitcheckwindowflag	windowwbuf
	beq	.pl2buf1
.pl2buf2
	ldy	#kw_windowstructP2_buf2
.pl2buf1
	cpx	#0
	beq	.offwindow2
.onwindow2
	lda	#wm_sizeof-1
	km_mvn	0,0
	bra	.end
.offwindow2
	a8
	km_setval.w	wm_wobjsel,0,y		;window off
	km_setval.w	wm_coldata,$e0,y	;colour add off
;--------------------------------------------------------------------
.end
	a8
	restorenasty
	plp
	rtl

	LONGA
find_window_pri
	sta	kw_findwindpri		;tpa
;;;	stz	kw_findwindpri+1	;tpa+1
	beq	.nothing
	txa
	ldx	#maxwindows
.findhighest
	ror	kw_findwindpri		;tpa
	bcs	.found
	adc	#wm_sizeof
	dex
	bne	.findhighest
.nothing	lda	#0
.found	tax
	rts




	IFEQ	1
;*********************************************************************
;*								*
;*		KAWAGUCHI IRQ ROUTINE				*
;*	(OAM transfer,CGX,SCR,color change,Timer)		*
;*********************************************************************
	a8i16
;=====================================================================
;*			Sprite CGX transfer			*
;=====================================================================
	IFEQ	1
	km_bitcheckmissionflag	transsprcgx
	beq	.nottranscgx
	ldx	#w5_cgx&WM
	jsr	mis_sprcgxtrans
	km_clrmissionflag	transsprcgx
.nottranscgx
	ENDC
;---------------------------------------------------------------------
;*			OAM Data DMA Transfer			*
;---------------------------------------------------------------------
;*Sprites buffer = Double buffer *
;* sprstates (0... buffer1 transfer ,1... buffer2 transfer) *
	km_jmpscreenflag	oamtensou,.transfer_buffer2
.transfer_buffer1
	km_IRQdmaoaram	sprites,(128*4)+(128/4)	; dma into oram
	bra	.OAMtransEnd
.transfer_buffer2
	km_IRQdmaoaram	(sprites+128*4+128/4),(128*4)+(128/4) ; dma into oram
.OamTransEnd
;=====================================================================
;*		Planet CGX Transfer	(MISSION EXPLAIN)	*
;=====================================================================
;---------------------------------------------------------------------
;*		BOSS Meter CGX Transfer				*
;---------------------------------------------------------------------
	IFEQ	1
	shorta
	longi
	lda	kw_BossMeterDMAsw
	km_beq	.noCGXtrans

	lda	kw_BossPtr
	dec	a
	beq	.clear	
	dec	a
	beq	.trans
	brl	.noCGXtrans
;---------------------------------------------------------------------
.clear
	shorta
	longi

	lda	#$81
	sta	vmainc

	a16
	lda	kw_dmadaddr
	clc
	adc	#bossmeter_cgx&WM
	sta	vmaddl

	ldy	#$20
.loop1	stz	vmdatal
	dey
	bne	.loop1

	inc	kw_dmadaddr
	A8
	dec	kw_BossMeterDMAsw	;DEC CGX Transfer Counter
	brl	.noCGXtrans
;---------------------------------------------------------------------
;* tensou address change *
.trans
	storenasty
	romnastyoff		;ROM nasty OFF

	lda	#$81
	sta	vmainc

	A16
	lda	kw_dmadaddr
	clc
	adc	#bossmeter_cgx&WM
	sta	vmaddl
;* 1chr goto tensou *

	ldx	kw_dmasaddr
	ldy	#$20

.loop	lda.l	w1_cgx+0,x
	sta	vmdatal

	txa
	clc
	adc	#$40
	tax
	dey
	bne	.loop
	a8
	restorenasty

	A16
	inc	kw_dmasaddr
	inc	kw_dmasaddr
	inc	kw_dmadaddr
	A8
	dec	kw_BossMeterDMAsw	;DEC CGX Transfer Counter
;-----------------------------------------------------------------------

	IFEQ	1
	a16
	lda	kw_dmasaddr
	tax
	lsr	a
	tay
	txa
	clc
	adc	#$0020
	sta	kw_dmasaddr
	a8
	storenasty
	romnastyoff		;ROM nasty OFF
	km_dmaromVRAM_XY	0,w1_cgx,bossmeter_cgx,$20
	restorenasty

	dec	kw_BossMeterDMAsw	;DEC CGX Transfer Counter
	ENDC
.noCGXtrans

	ENDC
;---------------------------------------------------------------------
;*		Screen  Data Transfer				*	
;---------------------------------------------------------------------
;*** IMA WA TUKATTE INAI **
	IFEQ	1
;========= Timer SCR Data Change ============
	dmascrw	0,bg1_scr,$0d,$0e,GtmScrChBuf,10
;========= Player 1 Boost Meter Change ====== 
	dmascrw	0,bg1_scr,$19,$0b,Bo1ScrChBuf,10
;========= Player 2 Boost Meter Change ====== 
	dmascrw	0,bg1_scr,$02,$18,Bo2ScrChBuf,10
	ENDC
;---------------------------------------------------------------------
;*			Color Data Transfer			*
;* BG & OBJ Colour Data Transfer					*
;---------------------------------------------------------------------
	km_IRQdmaRAMtoCGRAM	kx_palette,0,512
;---------------------------------------------------------------------
;*
;---------------------------------------------------------------------
;****************************************
;* koreyori ushiro wa imawa tukatteinai *
;****************************************
	ifeq	1
;* Marine & Sun color change *
	km_bitcheckscreenflag	bgcolpal
	beq	.nopalcol
	km_IRQdmatranscolpal.l	coladr_2,4,1
.nopalcol

;* OBJ Color Flashing *
	km_bitcheckscreenflag	objcolpal
	beq	.noobjpalchange
	km_IRQdmatranscolpal.l	coladr_3,8,3
	endc
.noobjpalchange
	ifeq	1
	ColChange	OBJ,0,$0c,Grcolbuf_0
	ColChange	OBJ,0,$0d,Blcolbuf_0
	ColChange	OBJ,0,$0e,Yecolbuf_0
	ColChange	OBJ,0,$0f,Recolbuf_0

	ColChange	OBJ,1,$0c,Grcolbuf_1
	ColChange	OBJ,1,$0d,Blcolbuf_1
	ColChange	OBJ,1,$0e,Yecolbuf_1
	ColChange	OBJ,1,$0f,Recolbuf_1

	ColChange	OBJ,2,$0c,Grcolbuf_2
	ColChange	OBJ,2,$0d,Blcolbuf_2
	ColChange	OBJ,2,$0e,Yecolbuf_2
	ColChange	OBJ,2,$0f,Recolbuf_2
	ENDC
;---------------------------------------------------------------------
;*		Screen Data Transfer	(Yajima's)		*
;---------------------------------------------------------------------
	storenasty
	romnastyoff		;ROM nasty OFF
	jsl	irq_gameobj_l
	restorenasty
;---------------------------------------------------------------------
;*		Player H,V Scroll				*
;---------------------------------------------------------------------
	jsr	SethdmaHVScroll
	jsr	SetHVScroll_BG3
;--------------------------------------------------------------------
;*
;--------------------------------------------------------------------
	IFEQ	1
	test_screenmode	3dglasses
	beq	.normno3d
	lda	vmap1+1
	and	#$f0
	sta	nmitemp
	lda	vmap1+1			;Double buffer screen
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	ora	nmitemp
	bra	.setit3d
.normno3d
	ENDC

	test_screenmode	swapbg1bg2
	beq	.normnoswap
	lda	vmap1+1			;Double buffer screen
	and	#$f0
	sta	nmitemp
;;	ora	#(bg2_cgx>>12)
	lda	vram_bg2_cgx+1
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	ora	nmitemp
	bra	.setit3d
.normnoswap
	lda	vmap1+1			;Double buffer screen
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	nmitemp
;;	ora	#(bg2_cgx>>8)&$f0
	lda	vram_bg2_cgx+1
	and	#$f0
	ora	nmitemp
.setit3d
	sta	bg12nba

	ldx	vmap1			;Bitmap double buffering
	ldy	vmap2
	stx	vmap2
	sty	vmap1
;---------------------------------------------------------------------
;*			Window					*
;---------------------------------------------------------------------
	km_eorwindowflag	windowwbuf

;---------------------------------------------------------------------
;*			Controller				*
;---------------------------------------------------------------------
	jsr	readjoypads		;Controller

;---------------------------------------------------------------------
;*		Screen Display Switch				*
;---------------------------------------------------------------------
;'94/8/15
	lda	kw_tm
	sta	tm
;---------------------------------------------------------------------
;*		Screen On notameno kari set			*
;---------------------------------------------------------------------
	jsr	setinidisp

;---------------------------------------------------------------------
;*			Soft Ware Timer				*
;---------------------------------------------------------------------
	shorta
	longi
	JSR	SoftWareTimer


KAWAGUCHI_IRQ_END
	stz	trans_flag	;[Clear IRQ flag]
	end_irq

;;;	rtl
data0
	dw	0

	ENDC
