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

	IFNE	RUMBLE
; Randy's rumble controller fix for hardware
; HACK: Force re-read of controller bits to get timing right for rumble handler

; This part is to make sure that you don't overrun blanking
	lda	slhvr				; Latch Raster Position
	lda	stat78r				; Update H/V Counters
	lda	opvctr				; Get Low 8Bits VPos
	xba
	lda	opvctr				; Get High 8Bits VPos
	xba
	cmp	#40
	bcc	.to_skip_rumble
	cmp	#220
	bcc	.readjoy
.to_skip_rumble
	brl	.skip_rumble

; This part does the equivalent of the auto-read of the controllers,
; which is what the rumble hardware is looking for
.readjoy
	lda	#$01
	sta	JOYSER0				; Reset Data Counter
	nop
	nop
	stz	JOYSER0
	nop
	nop

;	ldy	#16-1				; Read 16 Controller Bits
;.readjoy2
;	lda	JOYSER0				; Controller I
;	dey
;	bpl	.readjoy2

; Clock controller port 1 16 times
; Saves 70 cycles
	jsl	clkjoyser016x_l

; Handle rumble controller commands

	ldx	#$40

; Send magic number 01110010 (rumble sentry)
; send a bit, clock controller port 1
	stz	WRIO				; %0
	bit	JOYSER0

	stx	WRIO				; %1
	bit	JOYSER0

;							; %1
	bit	JOYSER0

;							; %1
	bit	JOYSER0

	stz	WRIO				; %0
	bit	JOYSER0

;							; %0
	bit	JOYSER0

	stx	WRIO				; %1
	bit	JOYSER0

	stz	WRIO				; %0
	bit	JOYSER0
.rumblehan_recheck
	IFNE	RUMBLETABLES
; Handle sequenced rumbles
	lda	rumble_index
	beq	.notable	; If rumble_index == 0, handle timed rumbles
	ldx	rumble_index
	lda.l	rumble_table-1,x	; Turns out Kando's 'fix' wasn't actually doing anything with the -1 outside the operands
	inx
	stx	rumble_index
	cmp #0
	beq	.rumblehan_turnoffmotors
	cmp #rmblend	; So I don't have to pull X twice - Kando
	bne	.rumblehan_donerumblecmd2	; If you hit a rmblend, end it all. Otherwise, run it.
	stz	rumble_index
	bra	.rumblehan_turnoffmotors
	ENDC

.notable
; Check rumble timer
; Only send a nonzero rumble command if the timer is nonzero
	lda	rumble_time
	beq	.rumblehan_turnoffmotors	; if 0, turn off motors!
	lda	rumble_cmd		; get rumble cmd bits
	bra	.rumblehan_donerumblecmd

	IFNE	RUMBLETABLES
.rumblehan_donerumblecmd2
	cmp	#rmblloop	; Is the current table value == rmblloop?
	bne	.rumblehan_donerumblecmd
	lda	#1	; Yes! Loop rumble sequence.
	sta	rumble_index
	bra .rumblehan_recheck
	ENDC

.rumblehan_turnoffmotors
	lda	#0	; 0 = no rumble!
.rumblehan_donerumblecmd

; send rumble command bits out to controller port 1
; read in a bit, send it, clock controller port 1

	lsr	a				; .7 -> .6 / .0 -> .C
	sta	WRIO
	bit	JOYSER0

	rol	a				; .6 / .C -> .0
	sta	WRIO
	bit	JOYSER0

	asl	a				; .5
	sta	WRIO
	bit	JOYSER0

	asl	a				; .4
	sta	WRIO
	bit	JOYSER0

	asl	a				; .3
	sta	WRIO
	bit	JOYSER0

	asl	a				; .2
	sta	WRIO
	bit	JOYSER0

	asl	a				; .1
	sta	WRIO
	bit	JOYSER0

	asl	a				; .0
	sta	WRIO
	bit	JOYSER0

	lda	#$ff				; Restore WRIO
	sta	WRIO

; Check rumble timer
	lda	rumble_time
	beq	.rumblehan_dontdectime	; If 0, don't decrement or we'll overflow!!
	dec	rumble_time
.rumblehan_dontdectime

.skip_rumble
	ENDC	;RUMBLE

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

	IFNE	RUMBLE
;Copy IRQ handler to RAM at $010C
upload_simple_irqhan_l
	public	upload_simple_irqhan_l
	php
	phb

	ai16
	ldx	#irqhanalt&WM ; src data addr
	ldy	#$010C ; dest data addr
	lda	#irqhanaltend-irqhanalt-1 ; len of data to copy
	_mvn	(irqhanalt>>16),$00

	plb
	plp
	rtl

irqhanalt
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
irqhanaltend
	ENDC