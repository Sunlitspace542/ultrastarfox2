;*************************************************************
;* FILE:		HVSCROLL.ASM				*
;* AUTHOR:		Yasuhiro Kawaguchi			*
;* DESCRIPTION:	Set H,V Scroll				*
;* DATE:		26-10-93				*
;*************************************************************
	INCPUB	hvscroll

;*****************************************************************************
;*			H-V SCROLL MAIN ROUTINE				*
;*									*
;*Memory Mode: mem8 idx16							*
;*Data Bank:	  0								*
;*****************************************************************************
sethvscroll_l
	km_PushAllReg
	a8i16
	db0
;* h-v scroll priority check *
	km_bitcheckscrollflag	raster
	bne	.raster_scroll
.normal_scroll
	jsr	Normalscroll
	bra	.hvscrollEND
.raster_scroll
	jsr	RasterScroll
.hvscrollEND
	km_PullAllReg
	rtl



	IFEQ	1
	ldx	#0
	ldy	#kscrollmax
	km_ldaHVscrollflag
	beq	.jmp
.loop
	inx
	inx
	lsr	a
	bcs	.jmp
	dey
	bne	.loop
	km_blink
.jmp
	jsr	(.jmptable,x)
	ENDC

;-----------------------------------------------------------------------------
;*									*
;*		H-V scroll states set	[Normal mode]			*
;* (Repeat Data),(hdama scroll)						*
;* Using Method								*
;* player1hscroll :H scroll Value						*
;* player1vscroll :V scroll Value						*
;* Data Bank :0								*
;-----------------------------------------------------------------------------
	shorta
	longi
Normalscroll
;* Hscroll *
	km_setflag	kw_hdma_hscrflag1,khsf_repeat
	km_setflag	kw_hdma_hscrflag2,khsf_repeat

	ldx	#xh_hscrolltbl1&WM
	stx	kw_hdma_hscraddr1
	ldx	#xh_hscrolltbl2&WM
	stx	kw_hdma_hscraddr2
;* Vscroll *
	km_setflag	kw_hdma_vscrflag1,kvsf_repeat
	km_setflag	kw_hdma_vscrflag2,kvsf_repeat

	ldx	#xh_vscrolltbl1&WM
	stx	kw_hdma_vscraddr1
	ldx	#xh_vscrolltbl2&WM
	stx	kw_hdma_vscraddr2

	rts
;-----------------------------------------------------------------------------
;*									*
;*			Marine Diving H-V OFSEET			*
;*									*
;-----------------------------------------------------------------------------
DivingScroll
	shorta
	longi
;;;;;	jsl	waterline_pros_l	
	a8i16
	rts

;-----------------------------------------------------------------------------
;*									*
;*		H-V scroll states set	[Explain mode]			*
;*									*
;* Data Bank :0								*
;-----------------------------------------------------------------------------
	IFEQ	1
ExplainScroll
	shorta
	longi

;* h-dma table data 
	km_clrflag	kw_hdma_hscrflag1,khsf_repeat
	km_clrflag	kw_hdma_hscrflag2,khsf_repeat

;*** Double Buffer ***
.HdmaScroll
;(0... buffer2 write,buffer1 transfer)
;(1... buffer1 write,buffer2 transfer)
	km_eorscreenflag	hvscrollwbuf

	km_bitcheckscreenflag	hvscrollwbuf
	beq	.writebuf2
.writebuf1
	ldx	#xh_yajiHtbl1_buf2&WM
	stx	kw_hdma_hscraddr1
	stx	kz_tempaddrl

	ldx	#xh_yajiHtbl2_buf2&WM
	stx	kw_hdma_hscraddr2
	bra	.AddrSetEnd
.writebuf2
	ldx	#xh_yajiHtbl1_buf1&WM
	stx	kw_hdma_hscraddr1
	stx	kz_tempaddrl

	ldx	#xh_yajiHtbl2_buf1&WM
	stx	kw_hdma_hscraddr2
.AddrSetEnd

;* Vscroll *
	km_setflag	kw_hdma_vscrflag1,kvsf_repeat
	km_setflag	kw_hdma_vscrflag2,kvsf_repeat

	ldx	#xh_vscrolltbl1&WM
	stx	kw_hdma_vscraddr1
	ldx	#xh_vscrolltbl2&WM
	stx	kw_hdma_vscraddr2

;* explain select *
	a16	 
	lda	#0
	sta.l	xh_vscrolltbl1
	sta.l	xh_vscrolltbl2
	a8

	jsl	raster_l
	rts
	ENDC
;-----------------------------------------------------------------------------
;*									*
;*		H scroll states set	[Raster mode]			*
;*									*
;* Data Bank :0								*
;-----------------------------------------------------------------------------
RasterScroll
	shorta
	longi
;* h-dma table data 
	km_clrflag	kw_hdma_hscrflag1,khsf_repeat
	km_clrflag	kw_hdma_hscrflag2,khsf_repeat

;*** Double Buffer ***
.HdmaScroll
;(0... buffer2 write,buffer1 transfer)
;(1... buffer1 write,buffer2 transfer)
	km_eorscrollflag	hvscrollwbuf

	km_bitcheckscrollflag	hvscrollwbuf
	beq	.writebuf2
.writebuf1
	ldx	#xh_yajiHtbl1_buf2&WM
	stx	kw_hdma_hscraddr1
	stx	kz_tempaddrl

	ldx	#xh_yajiHtbl2_buf2&WM
	stx	kw_hdma_hscraddr2
	bra	.AddrSetEnd
.writebuf2
	ldx	#xh_yajiHtbl1_buf1&WM
	stx	kw_hdma_hscraddr1
	stx	kz_tempaddrl

	ldx	#xh_yajiHtbl2_buf1&WM
	stx	kw_hdma_hscraddr2
.AddrSetEnd
;-----------------------------------------------------------------------------
;*		V scroll states set	[Raster mode]			*
;-----------------------------------------------------------------------------
RasterVscroll
;* h-dma table data 
	km_clrflag	kw_hdma_vscrflag1,kvsf_repeat
	km_clrflag	kw_hdma_vscrflag2,kvsf_repeat

;*** Double Buffer ***
	km_bitcheckscrollflag	hvscrollwbuf
	beq	.writebuf2
.writebuf1
	ldx	#xh_yajiVtbl1_buf2&WM
	stx	kw_hdma_vscraddr1
	stx	kz_address

	ldx	#xh_yajiVtbl2_buf2&WM
	stx	kw_hdma_vscraddr2
	bra	.AddrSetEnd
.writebuf2
	ldx	#xh_yajiVtbl1_buf1&WM
	stx	kw_hdma_vscraddr1
	stx	kz_address

	ldx	#xh_yajiVtbl2_buf1&WM
	stx	kw_hdma_vscraddr2
.AddrSetEnd
	jsl	raster_l
	rts

;-----------------------------------------------------------------------------
;*			HV OFFSET RAM CLEAR (player1)			*
;-----------------------------------------------------------------------------
hvofsRAMClear1_l
	a16
	longi
	ldx	#0		;player 1 pointer
	txa
	clc
	adc	#((hvofs_buf2-hvofs_buf1)/2)&WM	;64
	sta	kpointer
	jsr	hvscrollRAMclear
	a8
	rtl
;-----------------------------------------------------------------------------
;*			HV OFFSET RAM CLEAR (player2)			*
;-----------------------------------------------------------------------------
hvofsRAMClear2_l
	a16
	longi
	ldx	#((hvofs_buf2-hvofs_buf1)/2)&WM	;player 2 pointer
	txa
	clc
	adc	#((hvofs_buf2-hvofs_buf1)/2)&WM	;64
	sta	kpointer
	jsr	hvscrollRAMclear
	a8
	rtl

;-------------------------------------------------------------
;*		V OFFSET RAM clear	(H-V offset OFF)*
;* data bank  :0						*
;* x register :H-V offset pointer				*
;-------------------------------------------------------------
hvscrollRAMclear
	longa
	longi
.loop
	stz	hvofs_buf1+64,x		;0
	stz	hvofs_buf1+66,x		;2
	stz	hvofs_buf1+68,x		;4
	stz	hvofs_buf1+70,x		;6
	stz	hvofs_buf1+72,x		;8
	stz	hvofs_buf1+74,x		;10
	stz	hvofs_buf1+76,x		;12
	stz	hvofs_buf1+78,x		;14

	txa
	clc
	adc	#16
	tax
	cpx	kpointer
	bne	.loop
	rts
;*****************************************************************************
;*									*
;*			TEST RASTER					*
;*									*
;*****************************************************************************
	IFEQ	1

;* kawaguchi ver *
;	km_setrasterptr
;	jsr	(.jmptable,x)
;	rts
;.jmptable
;	dw	Normalscroll&WM
;	dw	MarineScroll&WM
;	dw	CoronaScroll&WM


;-----------------------------------------------------------------------------
;*									*
;*		H-V scroll states set	[Corona mode]			*
;*									*
;* Xregister :H-V scroll data pointer					*
;* Yregister :H-V scroll data buffer pointer					*
;* Data Bank :7f bank							*
;-----------------------------------------------------------------------------
Coronascroll
	php
	a16
	longi

	km_bitcheckgameflag	battle
	bne	.battle
.mission
	lda	#bitmapvheight*2*8*2
	sta.l	xxpointer
	bra	.skip
.battle
	lda	#bitmapvheight*8*2
	sta.l	xxpointer
.skip
;*** sin wave pointer change ***
	lda.l	khscrollptr
	inc	a
	inc	a
	and	#$1f
	sta.l	khscrollptr
	tax
;*** hdma table data set ***
	phb
	db7f
	LDY	#0
;===== buffer 1 =======
.loop1
	lda.l	player1hscroll
	clc
	adc.l	CoronaWaveData0,x
	sta	(kz_tempaddrl),y	;xh_yajiHtbl1_1,y

	txa
	inc	a
	inc	a
	and	#$001f
	tax

	iny
	iny
	cpy	xxpointer
	bne	.loop1

;===== buffer 2 =======
	km_bitcheckgameflag.l	battle
	beq	.exit
	km_aslsta	xxpointer
.loop2
	lda.l	player2hscroll
	clc
	adc.l	CoronaWaveData0,x
	sta	(kz_tempaddrl),y	;xh_yajiHtbl2_1,y

	txa
	inc	a
	inc	a
	and	#$001f
	tax

	iny
	iny
	cpy	xxpointer
	bne	.loop2
.exit
	plb
	plp
	rts

;-----------------------------------------------------------------------------
;*									*
;*		H-V scroll states set	[Marine mode]			*
;*									*
;* Xregister :H-V scroll data pointer					*
;* Yregister :H-V scroll data buffer pointer					*
;* Data Bank :7f bank							*
;-----------------------------------------------------------------------------
Marinescroll
	php
	a16
	longi

	km_bitcheckgameflag	battle
	bne	.battle
.mission
	lda	#bitmapvheight*2*8*2
	sta.l	xxpointer
	bra	.skip
.battle
	lda	#bitmapvheight*8*2
	sta.l	xxpointer
.skip
;*** sin wave pointer change ***
	lda.l	kseascroll
	inc	a
	inc	a
	and	#$0f
	sta.l	kseascroll
	tax
;*** hdma table data set ***
	phb
	db7f
	LDY	#0
;===== buffer 1 =======
.loop1
	lda.l	hwavedata,x
	sta	(kz_tempaddrl),y	;xh_yajiHtbl1_1,y

	txa
	inc	a
	inc	a
	and	#$0f
	tax

	iny
	iny
	cpy	xxpointer
	bne	.loop1
;===== buffer 2 =======
	km_bitcheckgameflag.l	battle
	beq	.exit
	km_aslsta	xxpointer
.loop2
	lda.l	hwavedata,x
	sta	(kz_tempaddrl),y	;xh_yajiHtbl2_1,y
	txa
	inc	a
	inc	a
	and	#$0f
	tax

	iny
	iny
	cpy	xxpointer
	bne	.loop2

.exit
	plb
	plp
	rts

hwavedata
	dw	0000,0001,0002,0002,0003,0003,0004,0004
	dw	0004,0004,0003,0003,0002,0002,0001,0000

;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
	IFEQ	1
	a16
	lda.l	khscrollptr
	inc	a
	inc	a
	and	#$1f
	sta.l	khscrollptr
	tax
	ldy	#0
	lda	#bitmapheight*8*2
	sta.l	xxpointer


	lda	player1hscroll
	sta.l	xh_player1hscroll
	lda	player1vscroll
	sta.l	xh_player1vscroll

	test_screenmode	onescreen
	beq	.twoscreenmode		;If Cockpit Display
.onescreenmode
;	lda	player1hscroll
;	sta.l	xh_player2hscroll
;	lda	player1vscroll
;	sta.l	xh_player2vscroll
	bra	.end
.twoscreenmode
	lda	player2hscroll
	sta.l	xh_player2hscroll
	lda	player2vscroll
	sta.l	xh_player2vscroll
.end

	ENDC

;----------------------------------------------------------------------------
;** Now Not Using Area
;----------------------------------------------------------------------------
;*** hv-offset buffer clear ****
	ifeq	1
	km_cmpcheckgamesyori	rts
	bne	.noclear	
	jsl	hvofsRAMClear1_l
.noclear
	endc
;----------------------------------------------------------------------------
	IFEQ	1
	a16
	km_testkeydown	UP
	beq	.noup
	lda.l	kx_check
	INC	A
	INC	A
	INC	A
	INC	A
	STa.l	kx_check
	bra	.skip1
.noup
	km_testkeydown	Down
	beq	.skip1
	lda.l	kx_check
	Dec	A
	Dec	A
	Dec	A
	Dec	A
	STa.l	kx_check
.skip1
	a8
	ENDC

;*****************************************************************************
;*									*
;*			Raster Scroll					*
;*									*
;*****************************************************************************
	IFEQ	1
;-------------------------------------------------------------
;*		PLayer 1 & Player 2			*
;-------------------------------------------------------------
;-------------------------------------------------------------
;*		PLayer 1				*
;-------------------------------------------------------------
	a16
	ldx	#0		;player 1 pointer
	txa
	clc
	adc	#((hvofs_buf2-hvofs_buf1)/2)&WM	;64
	sta	kpointer
	jsr	hvscrollRAMclear

	lda.l	khscrollptr
	inc	a
	inc	a
	and	#$1f
	sta.l	khscrollptr
	tax

	ldy	#0

	lda	#bitmapheight*8*2
	sta.l	xxpointer
	jsr	MarineHVscroll
;-------------------------------------------------------------
;*		PLayer 2				*
;-------------------------------------------------------------
	ldx	kpointer		;player 2 pointer
	txa
	clc
	adc	#((hvofs_buf2-hvofs_buf1)/2)&WM	;64
	sta	kpointer
	jsr	hvscrollRAMclear

	lda.l	kseascrollptr
	inc	a
	inc	a
	and	#$1f
	sta.l	kseascrollptr
	tax

	lda.l	xxpointer
	tay
	asl	a
	sta.l	xxpointer
	jsr	MarineHVscroll
;-------------------------------------------------------------
	ENDC

;*****************************************************************************
;*									*
;*			Raster Scroll Data				*
;*									*
;*****************************************************************************
CoronaWaveData0
;;;	km_DataVal	CoronaWaveData0
	dw	0*1,1*1,2*1,3*1,3*1,3*1,4*1,4*1
	dw	4*1,4*1,3*1,3*1,2*1,2*1,1*1,0*1
	dw	-1&$1ff,-1&$1ff,-2&$1ff,-3&$1ff,-3&$1ff,-3&$1ff,-4&$1ff,-4&$1ff
	dw	-4&$1ff,-4&$1ff,-3&$1ff,-3&$1ff,-2&$1ff,-2&$1ff,-1&$1ff,0
CoronaWaveData0END

	ifeq	1
CoronaWaveData1
	dw	0*1,1*1,1*1,2*1
	dw	2*1,1*1,1*1,0*1
	dw	-1&$3ff,-1&$3ff,-2&$3ff,-2&$3ff
	dw	-2&$3ff,-2&$3ff,-1&$3ff,-1&$3ff

CoronaWaveData2
	dw	0*1,1*1
	dw	1*1,0*1
	dw	0&$1ff,-1&$1ff
	dw	-1&$1ff,0&$1ff

CoronaWaveData5
	dw	0*1,1*1,2*1,3*1,3*1,3*1,4*1,4*1
	dw	4*1,4*1,3*1,3*1,2*1,2*1,1*1,0*1
	dw	0*1,1*1,2*1,3*1,3*1,3*1,4*1,4*1
	dw	4*1,4*1,3*1,3*1,2*1,2*1,1*1,0*1
	endc
;------------------------------------------------------------------------------
	ifeq	1
hwavedata2
	dw	0,0*1,0,1*1,0,2*1,0,3*1,0,3*1,0,3*1,0,4*1,0,4*1
	dw	0,4*1,0,4*1,0,3*1,0,3*1,0,2*1,0,2*1,0,1*1,0,0*1
hwavedata3
	dw	0,0*2,0,1*1,0,2*2,0,3*1,0,3*2,0,3*1,0,4*1,0,4*1
	dw	0,4*2,0,4*1,0,3*2,0,3*1,0,2*2,0,2*1,0,1*2,0,0*1
hwavedata4
	dw	000,0*1,000,1*1,000,000,2*1,000,3*1
	dw	000,000,3*2,000,3*1,000,4*1,000,4*1
	dw	000,0*1,000,000,4*1,000,4*1,000,3*1
	dw	000,3*1,000,2*1,000,2*1,000,1*1,000
hwavedata5
	dw	0,0*1,0,1*1,0,2*1,0,3*1,0,3*1,0,3*1,0,4*1,0,4*1
	dw	0,4*1,0,4*1,0,3*1,0,3*1,0,2*1,0,2*1,0,1*1,0,0*1
	dw	0,-1&$1ff,0,-1&$1ff,0,-2&$1ff,0,-3&$1ff,0,-3&$1ff,0,-3&$1ff,0,-4&$1ff,0,-4&$1ff
	dw	0,-4&$1ff,0,-4&$1ff,0,-3&$1ff,0,-3&$1ff,0,-2&$1ff,0,-2&$1ff,0,-2&$1ff,0,-1&$1ff
	endc
;*****************************************************************************
;*****************************************************************************
;*			Raster Test End					*
;*****************************************************************************
;*****************************************************************************
	ENDC

