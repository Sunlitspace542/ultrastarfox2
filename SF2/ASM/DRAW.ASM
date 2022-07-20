
	INCPUB	draw

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; run through the debug list and display the data

displaydebugging_l
	phb
	phx
	phy
	pha
	php
	a8i16
	lda	#$7e
	pha
	plb

; Mario chip test bay ---------
;
;;	timer_on	temp1
;;	call_mario	mtestit
;;	timer_off	temp1,<Mario Test>,Dylan
; -----------------------------

	a16
	lda	#smallfont&WM
	sta.l	m_font

	lda	#17
	sta.l	m_y1
	
	lda	#4
	sta.l	m_x1

	ldx	#0
	ldy	debugcount
.nxtone	a8
	lda	de_type,x
	lbeq	.nxt

	dey

	km_bitcheckgameflag	debug
	bne			.okdraw

;	km_setgameflag	freeze
;	bra	.wob12
;	dec			de_count,x
;	lbne			.nxt
	stz			de_count,x
	stz			de_type,x
	dec			debugcount
	brl			.nxt
.okdraw
;	km_clrgameflag	freeze
.wob12
	a16
	lda	#$90e
	sta.l	m_textcolour
	lda	de_text,x
	sta.l	m_txtdata
	a8
	lda	de_text+2,x
	sta.l	m_txtdatabank

	phx
	call_mario	mprintstring
	plx

	dec	de_count,x
	bne	.con
	stz	de_type,x
	dec	debugcount
.con
	a16
	lda.l	m_x1
	clc
	adc	#4
	sta.l	m_x1
	lda	#$409
	sta.l	m_textcolour
	lda	de_value,x
	sta.l	m_txtdata
	a8
	lda	de_type,x
	cmp	#dt_nonumber
	beq	.incy

	cmp	#dt_bin
	bne	.dec
	phx
	call_mario	mprintbinary
	plx
	bra	.incy
.dec
	cmp	#dt_dec
	bne	.hex

	phx
	call_mario	mprintdecimal
	plx
	bra	.incy
.hex
	phx
	call_mario	mprinthex
	plx

.incy
	a16
	lda.l	m_x1
	clc
	adc	#4
	sta.l	m_x1
	cmp	#64
	bcc	.nxt
	lda	#4
	sta.l	m_x1
	lda.l	m_y1
	clc
	adc	#10
	sta.l	m_y1
	clc
	adc	#10+16
	cmp	screenvheight
	bcs	.out

.nxt	a16
	txa
	clc
	adc	#de_sizeof
	tax
	cpy	#0
	lbne	.nxtone
.out

	plp
	pla
	ply
	plx
	plb
	rtl


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; add print number to debug buffer

addprintw_l
	phb
	phx
	phy
	pha
	php
	i8
	ldx	#$7e
	phx
	plb
	a8i16

	pha

	jsr	findsameslot
	pla
	cpx	#-1
	bne	.foundsame

	pha
	jsr	findemptyslot
	pla
	cpx	#-1
	beq	.noway

	inc	debugcount

.foundsame
	sta	de_type,x
	lda.l	textpt+2
	sta.l	de_text+2,x
	lda	#debug_delay
	sta	de_count,x
	a16
	lda	printpt
	sta	de_value,x
	lda.l	textpt
	sta	de_text,x

.noway
	plp
	pla
	ply
	plx
	plb
	
	rtl

findemptyslot
	php
	a16
	ldx	#0
	ldy	#number_debug
.nxtslot
	lda	de_type,x
	and	#255
	beq	.foundone
	txa
	clc
	adc	#de_sizeof
	tax
	dey
	bne	.nxtslot
.notfound
	ldx	#-1
.foundone
	plp
	rts

;-----------
findsameslot
	php
	a16
	ldx	#0
	ldy	debugcount
	beq	.notfound
.nxtslot
	a8
	lda	de_type,x
	beq	.nxt
	dey
	lda	de_count,x
	cmp	#debug_delay
	beq	.nxt

	a16
	lda	textpt
	cmp	de_text,x
	bne	.nxt
	a8
	lda	textpt+2
	cmp	de_text+2,x
	beq	.foundone
	
.nxt
	a16
	txa
	clc
	adc	#de_sizeof
	tax
	cpy	#0
	bne	.nxtslot
.notfound
	ldx	#-1
.foundone
	plp
	rts





;-----------------------------------------------------
; set screen size and offsets to add when printing

setprintparams
	php
	a16
	lda	screenmode
	bit	#sm_onescreen
	beq	.2scr
	lda	#char_size*bitmapheight_1*bitmapwidth_1
	sta	tpx
	lda	#char_size*bitmapheight_1
	bra	.1scr
.2scr
	lda	#col_size*num_col
	sta	tpx
	lda	#col_size
.1scr	sta	tpa
	plp
	rts

	IFEQ	1

clip_plot_l
	jsr	clip_plot
	rtl
noplot	rts

clip_plot	php
	ai16
	lda	xs
	sta	plotx1
	lda	ys
	sta	ploty1
	lda	plotx1
	cmp	clx1
	bmi	noplot
	lda	clx2
	cmp	plotx1
	bmi	noplot
	lda	ploty1
	cmp	cly1
	bmi	noplot
	lda	cly2
	cmp	ploty1
	bmi	noplot
	jmp	plot0


plot
	php
	ai16
plot0
	phx
	phy
	lda	plotx1	;0
	asl	a
	tay
	lda	ploty1
	asl	a
	tax		;17
	lda	pyoftab,x
	adc	pxoftab,y
	adc	drawmap
	tax		;17
	lda.l	bitmapbase,x
	and	pbittabn,y
	sta	pmask
	lda	mask1
	and	pbittab,y
	ora	pmask	;30
	sta.l	bitmapbase,x
	lda.l	bitmapbase+16,x
	and	pbittabn,y
	sta	pmask
	lda	mask2
	and	pbittab,y	;30
	ora	pmask
	sta.l	bitmapbase+16,x	;10
	ply
	plx
	plp
	rts

	ENDC

	IFNE	0 debuginfo

printt_l
	phb
	php
	ai16
	pha
	phx
	phy

	a8i16
	lda	#0
	pha
	plb

	ldy	#0

.andagain
	lda.l	[textpt],y
	beq	.finished
	phy

	cmp	#"_"
	bne	.notunder
	lda	#42
	bra	.drawit
.notunder
	cmp	#" "
	bne	.notspace
	lda	#-1
	bra	.drawit
.notspace
	cmp	#"a"
	bcc	.notlow
	sec
	sbc	#"a"-10
	bra	.drawit
.notlow
	cmp	#"A"
	bcc	.notchar
	sec
	sbc	#"A"-10
	bra	.drawit
.notchar	sec
	sbc	#"0"
.drawit
	jsr	printchar
	ply
	iny
	jmp	.andagain
.finished

	ai16
	ply
	plx
	pla
	plp
	plb
	rtl



	rts


printw_l
	pha
	xba
	jsl	printb_l
	xba
	jsl	printb_l
	pla
	rtl

printbd_l
	phb
	pha
	phx
	phy
	php

	a8i16
	sta	printbtemp
	lda	#0
	pha
	plb

	lda	printbtemp
	jsr	printbd

	plp
	ply
	plx
	pla
	plb
	rtl

printbsd_l
	phb
	pha
	phx
	phy
	php

	a8i16
	sta	printbtemp
	lda	#0
	pha
	plb

	lda	printbtemp
	jsr	printbsd

	plp
	ply
	plx
	pla
	plb
	rtl
	

printb_l
	phb
	pha
	phx
	phy
	php

	a8i16
	sta	printbtemp
	lda	#0
	pha
	plb
	lda	printbtemp
	jsr	printb

	plp
	ply
	plx
	pla
	plb
	rtl

	ENDC

	shorta
printbsd
	IFEQ	0 debuginfo
	rts
	ELSEIF

	pha

	cmp	#0
	bpl	.ok
	lda	#26+10
	jsr	printchar
	pla
	eor	#255
	inc	a
	jmp	printbd
.ok
	lda	#26+15
	jsr	printchar
	pla
	jmp	printbd

	ENDC

	shorta
printbd
	IFEQ	0 debuginfo
	rts
printb_l
printbsd_l
printbd_l
printw_l
printt_l
	rtl
	ELSEIF

	cmp	#200
	bcc	.not200
	sec
	sbc	#200
	pha
	lda	#2
	bra	.printit
.not200	cmp	#100
	bcc	.nofirstchar
	sec
	sbc	#100
	pha
	lda	#1
	bra	.printit
.nofirstchar	pha
	lda	#-1	; print space
.printit
	pha
	cmp	#-1
	beq	.noprt2
	jsr	printchar
.noprt2
	pla
	a16
	and	#255
	tay
	a8
	pla

	a16
	and	#255
	tax

	a8
	lda.l	.decimaltable,x
	pha
	lsr	a	
	lsr	a	
	lsr	a	
	lsr	a
	bne	.nochk
	cpy	#255
	beq	.noprt
.nochk
	jsr	printchar
.noprt

	pla
	and	#$f
	jsr	printchar

	rts

	IFEQ	1

.decimaltable
tmp	=	0

	REPT	100
	defs	1,tmp
;	run	" db $",tmp/10,tmp-((tmp/10)*10)
tmp	=	tmp+1
	ENDR


	ENDC

printchar
	php
	ai16
	pha
	jsr	setprintparams
	lda	printpt
	clc
	adc	drawmap
	tax
	pla
	inc	a
	and	#$00ff
	asl	a
	asl	a
	asl	a
	asl	a
	tay

	lda	#8
	sta	tpy
	phx

.1	lda	debugspace,y		;plot
	eor	hilite
	and	#$ff00
	sta.l	bitmapbase,x		;plane0,plane1
	lda	debugspace,y
	sta.l	bitmapbase+16,x		;plane2,plane3
	inx
	inx
	iny
	iny
	dec	tpy
	bne	.1
	pla
	clc
	adc	tpa	;#col_size
	tax
	sec
	sbc	drawmap

	cmp	tpx	;#col_size*num_col
	bcc	.booboo
	sec
	sbc	tpx	;#col_size*num_col-32
	sec
	sbc	#32
	
.booboo
	sta	printpt
.exit
	plp
	rts


	ENDC

printb
	IFEQ	0 debuginfo
	rts
	ELSEIF

	php
	ai16
	pha
	lda	printpt
	clc
	adc	drawmap
	tax
	pla
	pha
	and	#$00f0
	tay

	jsr	setprintparams

	lda	#8
	sta	tpy
	phx

.1	lda	debugchars,y
	and	#$ff00
	sta.l	bitmapbase,x
	lda	debugchars,y
	sta.l	bitmapbase+16,x
	inx
	inx
	iny
	iny
	dec	tpy
	bne	.1
	pla
	clc
	adc	tpa	;#col_size
	tax
	adc	tpa	;#col_size
	sec
	sbc	drawmap

	cmp	tpx
	bcc	.booboo
	sec
	sbc	tpx	;#col_size*num_col-32
	sec
	sbc	#32
	
.booboo
	sta	printpt
	pla
	and	#$000f
	asl	a
	asl	a
	asl	a
	asl	a
	tay
	lda	#8
	sta	tpy
.2	lda	debugchars,y
	and	#$ff00
	sta.l	bitmapbase,x
	lda	debugchars,y
	sta.l	bitmapbase+16,x
	inx
	inx
	iny
	iny
	dec	tpy
	bne	.2
	plp
	rts


;binary print byte
printbb_l
	php
	ai8
	sta	tpy
	rept	4
	lda	#0
	lsr	tpy
	php
	lsr	tpy
	rol	a
	asl	a
	asl	a
	asl	a
	plp
	rol	a
	pha
	endr
	rept	4
	pla
	jsr	printb
	endr
	plp
	rtl

	ENDC



