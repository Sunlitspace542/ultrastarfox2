

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

	IFEQ	RUMBLE
	bmi	.qexit
	ELSEIF
	bpl	.irqq
.qexit	pla
	rti
	ENDC

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
; Handle sequenced rumbles
	IFEQ	1
	lda	rumble_index
	beq	.notable	; If rumble_index == 0, handle timed rumbles
	ldx	rumble_index
	lda.l	rumble_table,x - 1
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

	IFEQ	1
.rumblehan_donerumblecmd2
	cmp	#rmblloop	; Is the current table value == rmblloop?
	bne	.rumblehan_donerumblecmd
	lda	#1	; Yes! Loop rumble sequence.
	sta	rumble_index
	bra .rumblehan_recheck
	ENDC

.rumblehan_turnoffmotors
	lda	#0	; 0 = no rumble!
	sta	rumble_priority
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
	ENDC

	jsl	irqcode_l
	a8
	inc	framec
	lda	timeupr
	bra	.exit
	longa
	IFEQ	RUMBLE
.qexit	pla
	rti
	ENDC
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


