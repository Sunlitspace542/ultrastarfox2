;Copy NMI/IRQ handler to RAM at $0101
copy_to_0101_l
	php
	phb

	ai16
	ldx	#nmihan&WM ; src data addr
	ldy	#$0101 ; dest data addr
	lda	#nmihanend-nmihan-1 ; len of data to copy
	_mvn	(nmihan>>16),$00

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

nmihan
	blink	2
	blink	2
;;;;
	rti				; $0108 NMI
	nop				; (there was a brl .nmi here and the IRQ handler hates being moved
	nop				; so i have to NOP out the same footprint as the original code)
;;;;
	nop				;$010B
.irq	ai16		;$010C IRQ
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
nmihanend
