

;Copy NMI handler to RAM at $0101
copy_to_0101_l
	php
	a8i16

	ldx	#nmihanend-nmihan-1
.codeloop2	lda.l	nmihan,x
	sta.l	$0101,x
	dex
	bpl	.codeloop2

	ldx	#xlen-1
.codeloop4	lda.l	xrstart,x
	sta.l	xroutines,x
	dex
	bpl	.codeloop4

	ldx	#rampathsize-1
.codeloop5	lda.l	rampathstart,x
	sta.l	rampatharea,x
	dex
	bpl	.codeloop5

	plp
	rtl





nmihan
	blink	2
;	rti		;$0101	brk
;	nop		;$0102
;	nop		;$0103
	blink	2
;	rti		;$0104	cop
;	nop		;$0105
;	nop		;$0106
	brl	.nmi	;$0108	NMI
	nop		;$010b
.irq	ai16		;$010c	irq
	pha
	lda.l	m_sfr
	bmi	.qexit
	phb
	disable
	phx
	phy
	ai8
	lda	#0
	pha
	plb

	jsl	irqcode_l
	a8
	inc	framec
	lda	timeupr
	bra	.exit
	longa
.qexit	pla
	rti
.brk
.nmi
	ai16
	pha
	phb
	phx
	phy
	a8
	lda	#0
	pha
	plb

	jsl	fnmi_l
	a8
	lda	rdnmir

.exit	ai16
	ply
	plx
	plb
	pla	
	rti

nmihanend


