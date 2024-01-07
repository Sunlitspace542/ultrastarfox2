;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         SCREEN.ASM                                          ;
; AUTHOR:       Dylan Cuthbert & Yasuhiro Kawaguchi                 ;
; DESCRIPTION:  Screen Initialisation Code                          ;
; DATE CREATED: 19-2-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;

	INCPUB	screen


screensetup_l
	php
	a8i16

	disable
	stz	nmitimen
	stz	trans_flag

;kawaguchi :94/8/3 :fade =  0 wa kokode shinai !!!!
;	stz	fade

	lda	timeupr		; clear IRQ's
	a16
	lda.l	m_sfr

	lda	#gamevw_pos2
	sta	screenon_position

; set mario chip for 16 colours 16 pixels high
	a8

	lda	screenheight
	cmp	#128
	beq	.16chars
	cmp	#192
	beq	.24chars
	lda	#height_160!colours_16
	bra	.onescreen
.24chars
	lda	#height_192!colours_16
	bra	.onescreen
.16chars
	lda	#height_128!colours_16
.onescreen
	sta	mario_draw_mode

; clear video RAM:
	screen_off
	stz	cgadd
	stz	vmaddl
	stz	vmaddh
	lda	#$80
	sta	inidisp
	sta	vmainc

; clear VRAM
	a16
	lda	#0
	ldx	#127*256
.li	sta	vmdatal
	dex
	bne	.li

; set character map:
	a8i16
	jsl	setcharmap_l

; set VRAM double buffering
	ldx	vram_bg1_cgx1
	stx	vmap1
	ldx	vram_bg1_cgx2
	stx	vmap2

	ldx	#bitmap1
	stx	drawmap
	a16
	txa
	sta.l	m_drawmap
	a8

	ldx	#bitmap1_dbl
	stx	showmap


; set mario chip to point to the screen
	lda	drawmap+1
	lsr	a
	lsr	a
	sta	m_scbr

; set PPU to point to the screen cgx

;;	lda	#(bg2_cgx>>8)&$f0
	lda	vram_bg2_cgx+1
	and	#$f0
	sta	x1
;94/11/10 :comment (kawaguchi)
;;	lda	screenmode	; bg2cgx points to 3d if glasses worn
;;	bit	#sm_3dglasses
;;	beq	.norm
;;	lda	#(bg1_cgx1_real>>8)&$f0
;;	lda	vram_bg1_cgx1+1
;;	and	#$f0
;;	sta	x1
;;.norm
	lda	vmap1+1
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	ora	x1	;#(bg2_cgx>>8)&$f0
	sta	bg12nba

; set screen base address
	test_screenmode	swapbg1bg2
	beq	.normalthankgod

; bg2 is 3d, bg1 is background
	lda	#bg1hofs&$ff
	sta	x1

;;	lda	#bg1_scr>>8
	lda	vram_bg1_scr+1
	sta	bg2sc

;94/11/10 :comment (kawaguchi)
;;	lda	screenmode
;;	bit	#sm_3dglasses
;;	beq	.normnot3dnn
;;	lda	#bg2_scr>>8
;;	lda	vram_bg2_scr+1
;;	bra	.setbg2scnn
.normnot3dnn
	lda	vram_bg2_scr+1
	inc	a
;	lda	#bg2_scr>>8+1
.setbg2scnn
	sta	bg1sc

	bra	.swapped

; bg1 is 3d, bg2 is background
.normalthankgod
;* '94/11/22 :syuusei
	km_cmpcheckgamemode	missionexplain
	bne	.normal
.bg1scroll
;* h-dma nomi BG1 (polygon screen) ni kakeru !! *
	lda	#bg1hofs&$ff
	sta	x1
	bra	.skip1
.normal
	lda	#bg2hofs&$ff
	sta	x1
.skip1
;;	lda	#bg1_scr>>8
	lda	vram_bg1_scr+1
	sta	bg1sc

;94/11/10 :comment (kawaguchi)
;;	lda	screenmode
;;	bit	#sm_3dglasses
;;	beq	.normnot3d
;;	lda	#bg2_scr>>8
	lda	vram_bg2_scr+1
	bra	.setbg2sc
.normnot3d
;;	lda	#bg2_scr>>8+1
	lda	vram_bg2_scr+1
	inc	a
.setbg2sc
	sta	bg2sc
.swapped

; set BG3 base address
	lda	vram_bg3_cgx+1
	km_divu16
	sta	bg34nba

;;;	lda	vram_bg3_scr+1
;;;	sta	bg3sc

;* BG3 Scr Size Clear *
	km_clrbg3size

; set object base address
;;	lda	#(0<<5)!(obj_cgx>>13)
	lda	vram_obj_cgx+1
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	objsel

; set hv-offset table base address
;;	lda	#(hvofs_base1>>8)&~3
	lda	vram_hvofs_base1+1
	and	#~3
	sta	bg3sc
	sta	kw_bg3sc

;;	lda	#(((hvofs_base1)>>5)&31)<<3
	lda	vram_hvofs_base1
	lsr	a
	lsr	a
	and	#31<<3
	sta	bg3vofs
	stz	bg3vofs
;;	lda	#(hvofs_base1&31)<<3
	lda	vram_hvofs_base1
	rol	a
	rol	a
	rol	a
	and	#31<<3
	sta	bg3hofs
	stz	bg3hofs



; set game palette
	lda	#1
	jsl	setpal_l

; set window logic, position & size
	stz	w12sel
	stz	w34sel
	stz	wobjsel
	stz	wbglog
	stz	wobjlog
	stz	tmw
	stz	tsw
	stz	wh0
	stz	wh1
	stz	ts

; set positions of inidisp hdma table
	jsl	setnoclash_l

; set up the inidisp hdma channel
;	lda	#0		;inidisp
;	sta	ch1params
;	lda	#inidisp&$ff
;	sta	ch1addrb
;	ldx	#xhdma_inidisp&WM
;	stx	ch1addra1tl
;	lda	#xhdma_inidisp>>16
;	sta	ch1atbank
;	stz	ch1databank
; set up the bg2scroll hdma channel
;	lda	#%01000011	;bg2scroll
;	sta	ch2params
;	lda	#bg2hofs&$ff
;	sta	ch2addrb
;	ldx	#xhdma_bg2scroll&WM
;	stx	ch2addra1tl
;	lda	#xhdma_bg2scroll>>16
;	sta	ch2atbank
;	sta	ch2databank
;-------------------------------------------------------------------------
;Set Up TM hdma channel
;0 page RAM used 7 byte
	IFEQ	1
	stz	kw_tmoff

	lda	#gameVW_Pos2+1
	sta	hdma_tm+0
	ldx	#kw_tmoff&WM
	stx	hdma_tm+1
	lda	#1
	sta	hdma_tm+3
	ldx	#kw_tm&WM
	stx	hdma_tm+4
	stz	hdma_tm+5

	lda	#%01000000
	sta	ch1params
	lda	#tm&$ff
	sta	ch1addrb
	ldx	#hdma_tm&WM
	stx	ch1addra1tl
	lda	#hdma_tm>>16
	sta	ch1atbank
	sta	ch1databank
	ENDC
;-------------------------------------------------------------------------
; set up the bg2vscroll hdma channel
	lda	#%01000010	;kw_vscrollmode
	sta	ch2params	(indirect mode)
	lda	x1		;(bg2hofs:battle or bg1hofs:mission)
	inc	a
	sta	ch2addrb
	ldx	#xhdma_bg2vscroll_mis&WM
	stx	ch2addra1tl
	lda	#xhdma_bg2vscroll_mis>>16
	sta	ch2atbank
	sta	ch2databank

; set up the bg2hscroll hdma channel
	lda	#%01000010	;kw_hscrollmode
	sta	ch3params	;(indirect mode)
	lda	x1		;(bg2hofs:battle or bg1hofs:mission)
	sta	ch3addrb
	ldx	#xhdma_bg2hscroll_mis&WM
	stx	ch3addra1tl
	lda	#xhdma_bg2hscroll_mis>>16
	sta	ch3atbank
	sta	ch3databank

;* battle mode no baai *
	test_screenmode	onescreen
	bne	.nottwoscreen
	ldx	#xhdma_bg2vscroll_bat&WM ;battle V scroll address
	stx	ch2addra1tl
	ldx	#xhdma_bg2hscroll_bat&WM ;battle H scroll address
	stx	ch3addra1tl
.nottwoscreen

; set up the hvofs hdma channel
	lda	#%10		;[HV OFFSET]
	sta	ch4params
	lda	#bg3vofs&$ff
	sta	ch4addrb
	ldx	#xhdma_hvofs&WM
	stx	ch4addra1tl
	lda	#xhdma_hvofs>>16
	sta	ch4atbank
	stz	ch4databank

; set up the circle hdma channel
	lda	#%01000001	;window	[indirect mode]
	sta	ch5params
	lda	#wh0&$ff
	sta	ch5addrb
	ldx	#xhdma_window_mission&WM
	stx	ch5addra1tl
	lda	#xhdma_window_mission>>16
	sta	ch5atbank
	lda	#$7e
	sta	ch5databank

	test_screenmode	onescreen
	bne	.skip
	ldx	#xhdma_window_battle&WM
	stx	ch5addra1tl
.skip
;-------------------------------------------------------------------------
	km_cmpcheckgamemode	title
	beq	.title
;	km_cmpcheckgamemode	typeselect
;	beq	.typeselect
	km_cmpcheckgamemode	selectmissionmap
	beq	.selmismap
	km_cmpcheckgamemode	MISSIONEXPLAIN
	beq	.misexplain

	lda	screenmode
	bit	#sm_3dglasses
	bne	.3dglas
	bit	#sm_twoscreen
	bne	.2scrhdma
;(hdmaf_ :hdmatabs.asm)
	lda	#hdmaf_bg2vscroll+hdmaf_bg2hscroll+hdmaf_hvofs+hdmaf_circle	;!hdmaf_inidisp
	bra	.1scrhdma
.title
	lda	#hdmaf_circle!hdmaf_bg2hscroll!hdmaf_bg2vscroll
	bra	.1scrhdma
.selmismap
;.typeselect	lda	#0	;hdmaf_circle
;	bra	.1scrhdma
.misexplain
	lda	#hdmaf_bg2vscroll+hdmaf_bg2hscroll+hdmaf_circle			;hdmaf_bg2vscroll+hdmaf_bg2hscroll+hdmaf_circle
	bra	.1scrhdma
.3dglas	lda	#0
	bra	.1scrhdma
.2scrhdma	lda	#hdmaf_bg2vscroll+hdmaf_bg2hscroll+hdmaf_hvofs+hdmaf_circle	;!hdmaf_inidisp
.1scrhdma	sta	hdmaen_gc

; set up the sprites
	jsl	init_sprites_l

; enable joypads + hdma tables
	ldx	#gamevw_pos
	stx	vtimel
	ldx	#0
	stx	htimel

	lda	#$80
	setinidisp1
	sta	inidisp
;kawaguchi :94/8/3 :fade =  0 wa kokode shinai !!!!
;	stz	fade

; wait for hdma to get going
	waitdma	190
	waitdma	100

	lda	rdnmir
	lda	#%00110001
	sta	nmitimen


	plp
	enable
	rtl



;---------------------------------------------
; set the character map:



;---------------------------------------------
; set the character map:

setcharmap_l
	php
	a8i16
	lda	#128
	sta	vmainc

;==========================================================================
;==========================================================================
;*			Not Using Area Start			* 
;==========================================================================
;==========================================================================
	IFEQ	1
	lda	screenmode
	bit	#sm_3dglasses
	lbeq	no3dglasses
; one player screen with no cockpit but with overlapped bg2 for stereoscopics

threedeeglasses
	ai16

blankchar	=	(1<<13)!(1024*7)!(bg1_firstchar+bitmapwidth_3d*bitmapheight_3d*2)
; clear the blanking character:
	lda	#bg1_cgx1+(blankchar&%1111111111)*16
	sta	vmaddl
	test_screenmode	blankborder
	beq	.setit
	lda	#0
	bra	.clred
.setit	lda	#$ffff
.clred
	ldx	#16
.clrchar1	sta	vmdatal
	dex
	bne	.clrchar1

; in both buffers
	ldx	#bg1_cgx2+(blankchar&%1111111111)*16
	stx	vmaddl
	ldx	#16
.clrchar2	sta	vmdatal
	dex
	bne	.clrchar2


	lda	#bg1_scr
	sta	vmaddl
	lda	#blankchar
	ldx	#32*32
.clrscr
	sta	vmdatal
	dex
	bne	.clrscr
	
	lda	#bg1_scr+32*gameStRow
	sta	vmaddl
	lda	#1024*1+bg1_firstchar

	IFEQ	0
; ### player 1's screen: (3d glasses)
	ldy	#0
.lolv
; set the borders

	pha
	lda	#blankchar
	REPT	player1_wx_3d
	sta	vmdatal
	ENDR
	pla

	ldx	#0
.lolh	sta	vmdatal
	clc
	adc	#bitmapheight_3d
	inx
	cpx	#bitmapwidth_3d
	bne	.lolh

; set the borders
	pha
	lda	#blankchar
	REPT	(32-bitmapwidth_3d)-player1_wx_3d
	sta	vmdatal
	ENDR
	pla

	sec
	sbc	#bitmapwidth_3d*bitmapheight_3d-1

	iny
	cpy	#bitmapvheight_3d
	bne	.lolv

	ENDC
; now set bg2 to be the same as bg1 but pointing to player 2's screen
; (for 3d glasses)

stbg2
	lda	#bg2_scr
	sta	vmaddl
	lda	#blankchar
	ldx	#32*32
.clrscr
	sta	vmdatal
	dex
	bne	.clrscr
	
	lda	#bg2_scr+32*gameStRow
	sta	vmaddl

	lda	#(1024*3)!(bg1_firstchar+bitmapwidth_3d*bitmapheight_3d)

	IFEQ	0
; ### player 1's screen:

	ldy	#0
.lolv
; set the borders

	pha
	lda	#blankchar
	REPT	player1_wx_3d
	sta	vmdatal
	ENDR
	pla

	ldx	#0
.lolh	sta	vmdatal
	clc
	adc	#bitmapheight_3d
	inx
	cpx	#bitmapwidth_3d
	bne	.lolh

; set the borders
	pha
	lda	#blankchar
	REPT	(32-bitmapwidth_3d)-player1_wx_3d
	sta	vmdatal
	ENDR
	pla

	sec
	sbc	#bitmapwidth_3d*bitmapheight_3d-1

	iny
	cpy	#bitmapvheight_3d
	bne	.lolv

	ENDC
	jmp	setupfinished

no3dglasses
	ENDC
;==========================================================================
;==========================================================================
;*			Not Using Area Finish			* 
;==========================================================================
;==========================================================================

	SHORTA

	lda	screenmode
	bit	#sm_cockpit
	lbeq	.nocockpit	; cockpit required?
	a16
	lda	#0
	sta.l	m_decoffset
	lda	cockpitscrptr+2
	and	#255
	sta.l	m_enddatabnk
	lda	cockpitscrptr
	sta.l	m_enddata
	a8
	jsl	dec_chr_l

	a8i16
	call_mario	mconvertscreen

	ldx	vram_bg1_scr
	dmaxvram		0,($700000+dec_base),32*32*2

; copy Vram data into Mario ram

	a16
	lda	#0
	sta.l	m_decoffset
	lda	cockpitcgxptr+2
	and	#255
	sta.l	m_enddatabnk
	lda	cockpitcgxptr
	sta.l	m_enddata
	a8
	jsl	dec_chr_l

	km_blocktrans	($700000+dec_base),cockpitcgx_buf,cockpit_cgx_len

.nocockpit
	a8
	call_mario	msetupscreen
; now copy bg1 into vram
	a16
	lda	vram_bg1_scr
	ldx	#dec_base
	jsr	copybgintovram

;94/11/10 :comment (kawaguchi)
;	test_screenmode	3dglasses
;	beq		.nobg2
;	lda	vram_bg2_scr
;	ldx	#dec_base+32*32*2
;	jsr	copybgintovram
;.nobg2

	test_screenmode	noborder
	bne		.noblankingchar

; clear the blanking character:
	lda	blankchar
	asl	a
	asl	a
	asl	a
	asl	a
	sta	x1
	
;;;	test_screenmode	3dglasses
;;;	bne	.doubleit
	test_screenmode	twoscreen
	beq	.nodouble
.doubleit
	asl	x1

.nodouble
; in one buffer
	lda	x1
	clc
	adc	vram_bg1_cgx1	;#bg1_cgx1+bg1_firstchar
	sta	vmaddl

;	lda	#bg1_cgx1+(bg1_firstchar+bitmapwidth_1*bitmapheight_1)*16
;	sta	vmaddl

	test_screenmode	blankborder
	beq	.setit
	lda	#0
	bra	.clred
.setit	lda	#$ffff
.clred
	ldx	#16
.clrchar1	sta	vmdatal
	dex
	bne	.clrchar1

; in both buffers
	pha
	lda	x1
	clc
	adc	vram_bg1_cgx2	;#bg1_cgx2
	sta	vmaddl
	pla

;	lda	#bg1_cgx2+(bg1_firstchar+bitmapwidth_1*bitmapheight_1)*16
;	sta	vmaddl
	ldx	#16
.clrchar2	sta	vmdatal
	dex
	bne	.clrchar2

.noblankingchar

;-------------------------------
; the following code is obsolete
;-------------------------------

	IFEQ	1
	a8

	test_screenmode	twoscreen
	lbne	twoscreenmode
;----------------------------------------

	test_screenmode	cockpit
	lbeq	oneplayernocock

oneplayerwithcock
; one player screen with cockpit

	ai16

; clear the blanking character:
	lda	#bg1_cgx1+(bg1_firstchar+bitmapwidth_1c*bitmapheight_1c)*16
	sta	vmaddl
	lda	#$ffff
	ldx	#16
.clrchar1	sta	vmdatal
	dex
	bne	.clrchar1

; in both buffers
	lda	#bg1_cgx2+(bg1_firstchar+bitmapwidth_1c*bitmapheight_1c)*16
	sta	vmaddl
	lda	#$ffff
	ldx	#16
.clrchar2	sta	vmdatal
	dex
	bne	.clrchar2

blankchar	=	(1<<13)!(1024*0)!(bg1_firstchar+bitmapwidth_1c*bitmapheight_1c)

	lda	#bg1_scr+32*gameStRow
	sta	vmaddl
	lda	#1024*pal3d+bg1_firstchar

	IFEQ	1
; ### player 1's screen:

	ldy	#0
.lolv
; set the borders

	pha
	lda	#(1<<13)!(1024*0)!(bg1_firstchar+bitmapwidth_1c*bitmapheight_1c)
	REPT	player1_wx_1
	lda	vmdatalr
	ENDR
	pla

	ldx	#0
.lolh	sta	vmdatal
	clc
	adc	#bitmapheight_1c
	inx
	inx
	inx
	inx
	inx
	inx
	inx
	inx
	cpx	screenwidth	;#bitmapwidth_1c
	bne	.lolh

; set the borders
	pha
	lda	#32*8-player1_wx_1*8
	sec
	sbc	screenwidth
	asra
	asra
	asra
	tax
	
.lp
	lda	vmdatalr
	dex
	bne	.lp
	tya
	clc
	adc	#8
	tay
	pla

	sec
	sbc	#bitmapwidth_1c*bitmapheight_1c-1

	cpy	screenvheight	;#bitmapvheight_1c
	bne	.lolv

	ENDC

	jmp	setupfinished


;----------------------------------------
; one player screen with no cockpit

oneplayernocock
	ai16

; clear the blanking character:
	lda	#bg1_cgx1+(bg1_firstchar+bitmapwidth_1*bitmapheight_1)*16
	sta	vmaddl
	lda	#$ffff
	ldx	#16
.clrchar1	sta	vmdatal
	dex
	bne	.clrchar1

; in both buffers
	lda	#bg1_cgx2+(bg1_firstchar+bitmapwidth_1*bitmapheight_1)*16
	sta	vmaddl
	lda	#$ffff
	ldx	#16
.clrchar2	sta	vmdatal
	dex
	bne	.clrchar2

blankchar	=	(1<<13)!(1024*0)!(bg1_firstchar+bitmapwidth_1*bitmapheight_1)

	IFEQ	1

	lda	#bg1_scr
	sta	vmaddl
	lda	#blankchar
	ldx	#32*32
.clrscr
	sta	vmdatal
	dex
	bne	.clrscr
	
	lda	#bg1_scr+32*gameStRow
	sta	vmaddl
	lda	#1024*pal3d+bg1_firstchar

; ### player 1's screen:

	ldy	#0
.lolv
; set the borders

	pha
	lda	#(1<<13)!(1024*0)!(bg1_firstchar+bitmapwidth_1*bitmapheight_1)
	REPT	player1_wx_1
	sta	vmdatal
	ENDR
	pla

	ldx	#0
.lolh	sta	vmdatal
	clc
	adc	#bitmapheight_1
	inx
	cpx	#bitmapwidth_1
	bne	.lolh

; set the borders
	pha
	lda	#(1<<13)!(1024*0)!(bg1_firstchar+bitmapwidth_1*bitmapheight_1)
	REPT	(32-bitmapwidth_1)-player1_wx_1
	sta	vmdatal
	ENDR
	pla

	sec
	sbc	#bitmapwidth_1*bitmapheight_1-1

	iny
	cpy	#bitmapvheight_1
	bne	.lolv

	ENDC

	jmp	setupfinished


;----------------------------------------

twoscreenmode
	ai16
	lda	#bg1_scr+32*gameStRow
	sta	vmaddl
	lda	#1024*pal3d+bg1_firstchar


; ### player 1's screen:

player1screen
	ldy	#0
.lolv
; set the borders

	pha
	REPT	player1_wx
	lda	vmdatalr
	ENDR
	pla

	ldx	#0
.lolh	sta	vmdatal
	clc
	adc	#bitmapheight
	inx
	cpx	#bitmapwidth
	bne	.lolh

; set the borders
	pha
	REPT	(32-bitmapwidth)-player1_wx
	lda	vmdatalr
	ENDR
	pla

	sec
	sbc	#bitmapwidth*bitmapheight-1

	iny
	cpy	#bitmapvheight
	bne	.lolv

	clc
	adc	#bitmapwidth*bitmapheight-bitmapvheight

	pha
	ldy	#32
.missline
	lda	vmdatalr
	dey
	bne	.missline
	
	pla


; ### player 2's screen:
player2screen
	ldy	#0
.lolv
; set the borders

	pha
	REPT	player2_wx
	lda	vmdatalr
	ENDR
	pla

	ldx	#0
.lolh	sta	vmdatal
	clc
	adc	#bitmapheight
	inx
	cpx	#bitmapwidth
	bne	.lolh

; set the borders
	pha
	REPT	(32-bitmapwidth)-player2_wx
	lda	vmdatalr
	ENDR
	pla

	sec
	sbc	#bitmapwidth*bitmapheight-1

	iny
	cpy	#bitmapvheight
	bne	.lolv


	ENDC
setupfinished
	plp
	rtl


	LONGA
copybgintovram
	sta	vmaddl
	ldy	#32*32
.copybg1
	lda.l	$700000,x
	cmp	#-1
	beq	.readit
	sta	vmdatal
	bra	.written
.readit	lda	vmdatalr
.written
	inx
	inx
	dey
	bne	.copybg1
	rts



;--------------------------------------------------------------
; deal with horizontal and vertical scrolls for both players

bg2horzvertscroll_l
	php
;* hscroll *
	a8i16
	ldx	#viewblk1
	a16
	lda	#0
	sta	y2
	lda	al_roty,x
	sta	y1

	asl	y1
	rol	y2
	asl	y1
	rol	y2

	lda	y1+1
	sta	player1hscroll

	lda	player1hscroll_offset

;	printh	OFFSET

	clc
	adc	player1hscroll
	sta	player1hscroll


	IFEQ	1
;95/5/24 :comment (kawaguchi)
;* vscroll *
	a8
	lda	al_rotx+1,x
	a16
	and	#255
	eor	#255
	inc	a
	asl	a
	asl	a
	asl	a
	clc
	adc	#48
	sta	player1vscroll
	a8
	
	ldx	#viewblk2

	a16
	lda	#0
	sta	y2
	lda	al_roty,x
	sta	y1

	asl	y1
	rol	y2
	asl	y1
	rol	y2

	lda	y1+1
	sta	player2hscroll

	a8
	lda	al_rotx+1,x
	a16
	and	#255
	eor	#255
	inc	a
	asl	a
	asl	a
	asl	a
	clc
	adc	#48-bitmapvheight*8-8
	sta	player2vscroll
	a8
	ENDC
.end
	plp
	rtl

;************************************************************************
;**
;** set_cockpit_l
;**
;** if the cockpit data is corrupted or just hasn't been set yet this will
;** copy the data over into mario ram
;**
;************************************************************************
Bmbase_cgx	equ	$4c
;player 1
BmP1SC_cgx	equ	$00
BmP1GL_cgx	equ	$05
BmP1Rd_cgx	equ	$0a
BmP1BS_cgx	equ	$23
BmP1HP_cgx	equ	$28

;player 2

BmP2SC_cgx	equ	$32
BmP2GL_cgx	equ	$37
BmP2Rd_cgx	equ	$3c
BmP2BS_cgx	equ	$55
BmP2HP_cgx	equ	$5a
;-------------------------------------------------------------------------
set_cockpit_l
	php
	a8
	lda	screenmode
	and	#sm_cockpit	; cockpit flagged to be displayed?
	lbeq	.notrans

;**** To Mario RAM  copy ***
	lda.l	cockpit_transferred	;to Mario RAM copy Flag
	lbne	.notrans		;1 kai copy shitara mou shinai 
;(if flag = 0 copy)
	lda	#1
 	sta.l	cockpit_transferred	;1 kai copy shitara mou shinai tameno flag

	lda.l	screenmode
	bit	#sm_twoscreen
	lbeq	.nokset			; 1 screen mode dattra !!

	IFEQ	1
	a16
	phb
;------ Player 1 absolute radar ---------
	IFEQ	P1radar
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$0
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$1
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$2
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$3
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$4
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$5
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$6
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$7
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$8
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$9
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$a
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$b
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$c
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$d
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$e
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$f
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$10
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$11
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$12
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$13
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$14
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$15
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$16
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$17
	kcopyIntChr	$9,BmBase_cgx+BmP1Rd_cgx+$18
	endc

;------- relative radar -------
	ifne	P1radar
	kcopyIntChr	$09,BmBase_cgx+BmP1Rd_cgx+$0
	kcopyIntChr	$50,BmBase_cgx+BmP1Rd_cgx+$1
	kcopyIntChr	$51,BmBase_cgx+BmP1Rd_cgx+$2
	kcopyIntChr	$52,BmBase_cgx+BmP1Rd_cgx+$3
	kcopyIntChr	$0a,BmBase_cgx+BmP1Rd_cgx+$4

	kcopyIntChr	$53,BmBase_cgx+BmP1Rd_cgx+$5
	kcopyIntChr	$54,BmBase_cgx+BmP1Rd_cgx+$6
	kcopyIntChr	$4e,BmBase_cgx+BmP1Rd_cgx+$7
	kcopyIntChr	$55,BmBase_cgx+BmP1Rd_cgx+$8
	kcopyIntChr	$56,BmBase_cgx+BmP1Rd_cgx+$9

	kcopyIntChr	$57,BmBase_cgx+BmP1Rd_cgx+$a
	kcopyIntChr	$4e,BmBase_cgx+BmP1Rd_cgx+$b
	kcopyIntChr	$58,BmBase_cgx+BmP1Rd_cgx+$c
	kcopyIntChr	$59,BmBase_cgx+BmP1Rd_cgx+$d
	kcopyIntChr	$5a,BmBase_cgx+BmP1Rd_cgx+$e

	kcopyIntChr	$5b,BmBase_cgx+BmP1Rd_cgx+$f
	kcopyIntChr	$4e,BmBase_cgx+BmP1Rd_cgx+$10
	kcopyIntChr	$4e,BmBase_cgx+BmP1Rd_cgx+$11
	kcopyIntChr	$4e,BmBase_cgx+BmP1Rd_cgx+$12
	kcopyIntChr	$5c,BmBase_cgx+BmP1Rd_cgx+$13

	kcopyIntChr	$0b,BmBase_cgx+BmP1Rd_cgx+$14
	kcopyIntChr	$5d,BmBase_cgx+BmP1Rd_cgx+$15
	kcopyIntChr	$5e,BmBase_cgx+BmP1Rd_cgx+$16
	kcopyIntChr	$5f,BmBase_cgx+BmP1Rd_cgx+$17
	kcopyIntChr	$0c,BmBase_cgx+BmP1Rd_cgx+$18
	endc

	ifeq	1
;------ score ------
	kcopyIntChr	$4d,BmBase_cgx+BmP1sc_cgx+$0
	kcopyIntChr	$4d,BmBase_cgx+BmP1sc_cgx+$1
	kcopyIntChr	$4d,BmBase_cgx+BmP1sc_cgx+$2
	kcopyIntChr	$4d,BmBase_cgx+BmP1sc_cgx+$3
	kcopyIntChr	$43,BmBase_cgx+BmP1sc_cgx+$4
;------ gold --------
	kcopyIntChr	$4d,BmBase_cgx+BmP1GL_cgx+$0
	kcopyIntChr	$4d,BmBase_cgx+BmP1GL_cgx+$1
	kcopyIntChr	$4d,BmBase_cgx+BmP1GL_cgx+$2
	kcopyIntChr	$4d,BmBase_cgx+BmP1GL_cgx+$3
	kcopyIntChr	$43,BmBase_cgx+BmP1GL_cgx+$4
;------ boost -------
	kcopyIntChr	$08,BmBase_cgx+BmP1BS_cgx+$0
	kcopyIntChr	$08,BmBase_cgx+BmP1BS_cgx+$1
	kcopyIntChr	$08,BmBase_cgx+BmP1BS_cgx+$2
	kcopyIntChr	$08,BmBase_cgx+BmP1BS_cgx+$3
	kcopyIntChr	$08,BmBase_cgx+BmP1BS_cgx+$4
;------ HP -------
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$0
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$1
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$2
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$3
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$4
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$5
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$6
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$7
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$8
	kcopyIntChr	$0e,BmBase_cgx+BmP1HP_cgx+$9
	endc

;------ Player 2 absolute radar ---------
	IFEQ	P2radar
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$0
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$1
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$2
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$3
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$4
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$5
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$6
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$7
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$8
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$9
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$a
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$b
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$c
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$d
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$e
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$f
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$10
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$11
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$12
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$13
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$14
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$15
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$16
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$17
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$18
	endc

;------- relative radar -------
	ifne	P2radar
	kcopyIntChr	$1a,BmBase_cgx+BmP2Rd_cgx+$0
	kcopyIntChr	$60,BmBase_cgx+BmP2Rd_cgx+$1
	kcopyIntChr	$61,BmBase_cgx+BmP1Rd_cgx+$2
	kcopyIntChr	$62,BmBase_cgx+BmP2Rd_cgx+$3
	kcopyIntChr	$19,BmBase_cgx+BmP2Rd_cgx+$4

	kcopyIntChr	$63,BmBase_cgx+BmP2Rd_cgx+$5
	kcopyIntChr	$64,BmBase_cgx+BmP2Rd_cgx+$6
	kcopyIntChr	$4e,BmBase_cgx+BmP2Rd_cgx+$7
	kcopyIntChr	$65,BmBase_cgx+BmP2Rd_cgx+$8
	kcopyIntChr	$66,BmBase_cgx+BmP2Rd_cgx+$9

	kcopyIntChr	$67,BmBase_cgx+BmP2Rd_cgx+$a
	kcopyIntChr	$68,BmBase_cgx+BmP2Rd_cgx+$b
	kcopyIntChr	$69,BmBase_cgx+BmP2Rd_cgx+$c
	kcopyIntChr	$4e,BmBase_cgx+BmP2Rd_cgx+$d
	kcopyIntChr	$6a,BmBase_cgx+BmP2Rd_cgx+$e

	kcopyIntChr	$6b,BmBase_cgx+BmP2Rd_cgx+$f
	kcopyIntChr	$4e,BmBase_cgx+BmP2Rd_cgx+$10
	kcopyIntChr	$4e,BmBase_cgx+BmP2Rd_cgx+$11
	kcopyIntChr	$4e,BmBase_cgx+BmP2Rd_cgx+$12
	kcopyIntChr	$6c,BmBase_cgx+BmP2Rd_cgx+$13

	kcopyIntChr	$1c,BmBase_cgx+BmP2Rd_cgx+$14
	kcopyIntChr	$6d,BmBase_cgx+BmP2Rd_cgx+$15
	kcopyIntChr	$6e,BmBase_cgx+BmP2Rd_cgx+$16
	kcopyIntChr	$6f,BmBase_cgx+BmP2Rd_cgx+$17
	kcopyIntChr	$1b,BmBase_cgx+BmP2Rd_cgx+$18
	endc

	ifeq	1
;------ score ------
	kcopyIntChr	$4d,BmBase_cgx+BmP2sc_cgx+$0
	kcopyIntChr	$4d,BmBase_cgx+BmP2sc_cgx+$1
	kcopyIntChr	$4d,BmBase_cgx+BmP2sc_cgx+$2
	kcopyIntChr	$4d,BmBase_cgx+BmP2sc_cgx+$3
	kcopyIntChr	$43,BmBase_cgx+BmP2sc_cgx+$4
;------ gold --------
	kcopyIntChr	$4d,BmBase_cgx+BmP2GL_cgx+$0
	kcopyIntChr	$4d,BmBase_cgx+BmP2GL_cgx+$1
	kcopyIntChr	$4d,BmBase_cgx+BmP2GL_cgx+$2
	kcopyIntChr	$4d,BmBase_cgx+BmP2GL_cgx+$3
	kcopyIntChr	$43,BmBase_cgx+BmP2GL_cgx+$4
;------ boost -------
	kcopyIntChr	$08,BmBase_cgx+BmP2BS_cgx+$0
	kcopyIntChr	$08,BmBase_cgx+BmP2BS_cgx+$1
	kcopyIntChr	$08,BmBase_cgx+BmP2BS_cgx+$2
	kcopyIntChr	$08,BmBase_cgx+BmP2BS_cgx+$3
	kcopyIntChr	$08,BmBase_cgx+BmP2BS_cgx+$4
;------ HP -------
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$0
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$1
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$2
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$3
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$4
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$5
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$6
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$7
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$8
	kcopyIntChr	$0e,BmBase_cgx+BmP2HP_cgx+$9
	endc
	plb
	ENDC

.nokset
.transfer
	ai16

_len	=	(bitmapheight-bitmapvheight)*32
_srcaddr	=	cockpitcgx_buf
_dstaddr	=	bitmapbase+bitmap1

	lda	#_dstaddr&WM
	sta	z2

;----------------------------------------------------------
; block copy the cgx file into the unused portions of mario
; ram at the bottom of each screen column.
.dotwice
	phb

	ai16

	ldx	#_srcaddr&WM

	lda.l	screenvheight
	asl	a
	asl	a
	clc
	adc	z2
	tay

	lda.l	screenvheight
	asra
	asra
	asra
	sta	x1

	lda.l	screenheight
	asl	a
	asl	a
	sta	y2

	lda.l	screenheight
	asra
	asra
	asra
	sta	y1
	sec
	sbc	x1
	sta	x2		; unused characters at end of column

	asl	a
	asl	a
	asl	a
	asl	a
	asl	a		; * 32 = unused bytes at end of column
	sta	z1

	lda	#0
.nxtblock	pha
	phx
	phy

	lda	z1	; bytes at end of column
	db	$54	; MVN instruction
	db	(_dstaddr)>>16
	db	(_srcaddr)>>16

	ply
	plx

	txa
	clc
	adc	z1
	tax

	tya
	clc
	adc	y2
	tay

	pla
	clc
	adc	x2
	cmp	#cockpit_cgx_len/32
	bcc	.nxtblock

	plb

	test_screenmode	twoscreen
	bne		.notrans

	lda	#(bitmap1_dbl+bitmapbase)&WM
	cmp	z2
	beq	.notrans
	sta	z2
	brl	.dotwice

.notrans
	plp
	rtl

;=====================================================================
;*								*
;*	Cockpit CGX Data wo XXRAM (cockpitcgx_buf) ni COPY	*
;*								*
;=====================================================================
kcopyIntChr_sub
	ifeq	1
	lda	#32-1
	km_mvn	bg11_cgx,cockpitcgx_buf
	endc
	rts

;=====================================================================
;*		Cockpit CGX Data wo XXRAM ni Tensou		*
;*Init	:Acc	= Mario CGX No					*
;*	:Xreg	= Source Address				*
;*	:Yreg	= Counter (okuru CHARACTER no kosuu)		*
;=====================================================================
	IFEQ	1
ktranscockpitCGX
	longa
	longi
.loop	sta	kwork
	and	#%1111111111111100
	km_multa4
	sta	kwork+2

	lda	kwork
	and	#%0000000000000011
	clc
	adc	kwork+2
	clc
	adc	#bitmapvheight
	km_multa32
	clc
	adc	#cockpitcgx_buf&WM

	jsr	ktranscockpitCGX_sub
	dey
	beq	.exit

	txa
	clc
	adc	#32
	tax

	lda	kwork
	inc	a
	bra	.loop
.exit
	rts
ktranscockpitCGX_sub
	longa
	longi
	phx

	sta	wmaddl			;dest address (RAM Addres)
	stx	ch0addra1tl		;source address (ROM address)
	a8
	lda	#(wmdata&$ff)
	sta	ch0addrb

	lda	#(cockpitcgx_buf>>16)&1
	sta	wmaddh

	lda	#(bg11_cgx>>16)
	sta	ch0atbank

	ldx	#32
	stx	ch0dataddrl
	stz	ch0params
	lda	#1<<0
	sta	mdmaen

	a16
	plx
	rts
	ENDC
;-------------------- Macro definitions -----------------------------

stype	=	0
defscreen	macro	[name]
st_{name}	equ	stype
stype	=	stype+2
	dw	{name}&WM
	endm

;����������
st_init	macro	[x,vy,y]

	ai16

	lda	#{vy}*8
	sta	screenvheight
	dec	a
	sta	cly2
	inc	a
	asra
	sta	vanishy

	stz	cly1
	stz	clx1

	lda	#{y}*8
	sta	screenheight

	lda	#{x}*8
	sta	screenwidth
	dec	a
	sta	clx2
	inc	a
	asra
	sta	vanishx

;- Carl 			Texture clip planes
	movi	(128*16384/8/({x})),xtclip
	movi	(128*16384/8/({vy})),ytclip

	lda	#{y}*{x}
	sta	blankchar

	endm

;����������
st_blankchar	macro	[char]
	lda	#{char}
	sta	blankchar
	endm
;����������
st_xypos	macro	[x,y,x2,y2]

	lda	#{x}
	sta	screen3dxpos_1
	lda	#{y}
	sta	screen3dypos_1

	IFEQ	NARG-4

	lda	#{x2}
	sta	screen3dxpos_2
	lda	#{y2}
	sta	screen3dypos_2

	ENDC

	endm

;����������
st_palette	macro	[blankpal,pal3d,pal3d2]

	lda	#{pal3d}
	sta	screen3dpalette_1
	lda	#{blankpal}
	sta	blankpalette

	IFEQ	NARG-3
	lda	#{pal3d2}
	sta	screen3dpalette_2
	ENDC

	endm

;����������
st_screenmode macro	[screenmode]
	lda	#{screenmode}
	sta	screenmode
	endm


;����������
st_cockpitcgx macro	[cockpitcgx]
	lda	#{cockpitcgx}&WM
	sta	cockpitcgxptr
	a8
	lda	#{cockpitcgx}>>16
	sta	cockpitcgxptr+2
	a16
	endm

;����������
st_cockpitscr macro	[cockpitscr]
	lda	#{cockpitscr}&WM
	sta	cockpitscrptr
	a8
	lda	#{cockpitscr}>>16
	sta	cockpitscrptr+2
	a16
	endm

;����������
st_vramlayout	macro	[bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs1,hvofs2]

; set up the vram layout for bg1
	lda	#_{bg1_cgx1}
	sta	vram_bg1_cgx1
	lda	#_{bg1_cgx2}
	sta	vram_bg1_cgx2
	lda	#_{bg1_scr}
	sta	vram_bg1_scr

; set up the vram layout for bg2
	lda	#_{bg2_cgx}
	sta	vram_bg2_cgx
	lda	#_{bg2_scr}
	sta	vram_bg2_scr

; set up the vram layout for sprites
	lda	#_{obj_cgx}
	sta	vram_obj_cgx

; set up the vram layout for hvofs
	lda	#_{hvofs1}
	sta	vram_hvofs_base1
	lda	#_{hvofs2}
	sta	vram_hvofs_base2

		endm

;����������
st_vramlayoutbg3	macro	[bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,bg3_cgx,bg3_scr,obj_cgx]

; set up the vram layout for bg1
	lda	#_{bg1_cgx1}
	sta	vram_bg1_cgx1
	lda	#_{bg1_cgx2}
	sta	vram_bg1_cgx2
	lda	#_{bg1_scr}
	sta	vram_bg1_scr

; set up the vram layout for bg2
	lda	#_{bg2_cgx}
	sta	vram_bg2_cgx
	lda	#_{bg2_scr}
	sta	vram_bg2_scr

; set up the vram layout for bg3
	lda	#_{bg3_cgx}
	sta	vram_bg3_cgx

; set up the vram layout for sprites
	lda	#_{obj_cgx}
	sta	vram_obj_cgx

; set up the vram layout for hvofs
	lda	#_{bg3_scr}
	sta	vram_hvofs_base1
	sta	vram_bg3_scr
		endm
;����������
st_end	macro

	jmp	setemall

	endm


;-------------------- End macro definitions -------------------------
setscreentype_l
	php
	jsr	setscreentype
	plp
	rtl

setscreentype
	ai8
	ldx	screentype
	jmp	(.tab&WM,x)

.tab	defscreen	normalscr	;0
	defscreen	twoplayerscr	;2
	defscreen	threedeescr	;4
	defscreen	typeselectscr	;6
	defscreen	trainingscr	;8
	defscreen	explainscr	;A
	defscreen	titlescr	;C
	defscreen	mismapscr	;E
	defscreen	demoscr		;10
titlescr
	st_init		28,24,24
	st_xypos	2,2
	st_palette	(0<<10)!(1<<13),(pal3d<<10)!(1<<13)
	st_vramlayout	bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs_base1,hvofs_base2
	st_screenmode	sm_onescreen!sm_swapbg1bg2
	st_end

mismapscr

	st_init		28,24,24
	st_xypos	2,2
	st_palette	(0<<10)!(1<<13),(pal3d<<10)!(1<<13)
	st_vramlayout	bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs_base1,hvofs_base2
	st_screenmode	sm_onescreen!sm_novofs!sm_noplayer!sm_noborder
	st_end

normalscr
	st_init		28,24,24
	st_xypos	2,2
	st_palette	(0<<10)!(1<<13),(pal3d<<10)!(1<<13)
;;;	st_cockpitcgx	bg1_ccr
;;;	st_cockpitscr	bg1p_pcr
	st_vramlayout	bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs_base1,hvofs_base2
	st_screenmode	sm_onescreen!sm_swapbg1bg2	;!sm_nosprites
	st_end

twoplayerscr
	st_init		22,12,16
	st_xypos	2,2,8,15
	st_palette	(7<<10)!(1<<13),pal3d<<10,pal3d<<10
;;;	st_cockpitcgx	b13_ccr
;;;	st_cockpitscr	b13_pcr
	st_vramlayout	bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs_base1,hvofs_base2
	st_screenmode	sm_twoscreen!sm_cockpit!sm_midscreenirq!sm_noborder
	st_end

demoscr
	st_init		28,24,24
	st_xypos	2,2
	st_palette	(0<<10)!(1<<13),(pal3d<<10)!(1<<13)
	st_vramlayout	bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs_base1,hvofs_base2
	st_screenmode	sm_onescreen!sm_swapbg1bg2!sm_nosprites!sm_noscreen
	st_end

threedeescr
	st_init		22,16,16
	st_xypos	5,2
	st_palette	(7<<10)!(1<<13),1<<10,3<<10
	st_vramlayout	bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs_base1,hvofs_base2
	st_screenmode	sm_3dglasses
	st_end

typeselectscr
	st_init		28,12,24
	st_xypos	2,4
	st_palette	(0<<10),pal3d<<10
	st_vramlayout	bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs_base1,hvofs_base2
;;;;	st_screenmode	sm_onescreen!sm_nosprites!sm_novofs
	st_screenmode	sm_onescreen!sm_nosprites!sm_novofs!sm_noplayer
	st_end

trainingscr
	st_init		28,24,24	;22,12
	st_xypos	2,2
	st_palette	(0<<10)!(1<<13),(pal3d<<10)!(1<<13)
;;;	st_cockpitcgx	b3_ccr
;;;	st_cockpitscr	b3_pcr
	st_vramlayout	bg1_cgx1,bg1_cgx2,bg1_scr,bg2_cgx,bg2_scr,obj_cgx,hvofs_base1,hvofs_base2
	st_screenmode	sm_onescreen!sm_training!sm_swapbg1bg2	;!sm_cockpit
	st_end

explainscr
	st_init		28,24,24
	st_xypos	$2,2
	st_blankchar	28*24
	st_palette	(0<<10),pal3d<<10
	st_vramlayoutbg3	me_bg1_cgx1,me_bg1_cgx2,me_bg1_scr,me_bg2_cgx,me_bg2_scr,me_bg3_cgx,me_bg3_scr,me_obj_cgx
;;;	st_vramlayout	me_bg1_cgx1,me_bg1_cgx2,me_bg1_scr,me_bg2_cgx,me_bg2_scr,me_obj_cgx,hvofs_base1,hvofs_base2
;;;	st_screenmode	sm_onescreen!sm_nosprites!sm_novofs!sm_noplayer
	st_screenmode	sm_onescreen!sm_novofs!sm_noplayer!sm_blankborder
	st_end
;-------------------------------------------------------------------
; copy initial vars into mario ram

setemall
	a16
	lda	screenheight
	sta.l	m_screenheight
	lda	screenvheight
	sta.l	m_screenvheight
	lda	screenwidth
	sta.l	m_screenwidth
	lda	screen3dxpos_1
	sta.l	m_screen3dxpos_1
	lda	screen3dxpos_2
	sta.l	m_screen3dxpos_2
	lda	screen3dypos_1
	sta.l	m_screen3dypos_1
	lda	screen3dypos_2
	sta.l	m_screen3dypos_2

	lda	screen3dpalette_1
	sta.l	m_screen3dpalette_1
	lda	screen3dpalette_2
	sta.l	m_screen3dpalette_2
	lda	blankpalette
	sta.l	m_blankpalette
	lda	blankchar
	sta.l	m_blankchar

	lda	screenmode
	sta.l	m_screenmode
	a8
	rts


