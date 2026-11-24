;Copy IRQ handler to RAM at $010C
copy_to_010c_l
	php
	phb

	ai16
	ldx	#irqhan&WM ; src data addr
	ldy	#$010C ; dest data addr
	lda	#irqhanend-irqhan-1 ; len of data to copy
	_mvn	(irqhan>>16),$00

	ldx	#xrstart&WM ; src data addr
	ldy	#xroutines&WM ; dest data addr
	lda	#xlen-1 ; len of data to copy
	_mvn	(xrstart>>16),(xroutines>>16)

	ldx	#rampathstart&WM ; src data addr
	ldy	#rampatharea&WM ; dest data addr
	lda	#rampathsize-1 ; len of data to copy
	_mvn	(rampathstart>>16),(rampatharea>>16)

	plb
	plp
	rtl

irqhan
.irq	;$010C IRQ
	ai16
	pha
	lda.l	m_sfr
	bpl	.irqq		; Thanks Randy
.qexit	pla
	rti

.irqq
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

.exit	ai16
	ply
	plx
	plb
	pla
	rti
irqhanend
