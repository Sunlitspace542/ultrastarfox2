; Rumble Controller Macros

printerror	MACRO	[text]
	printf	"%01%31Error: {text}%00%n"
	error+
	ENDM

; Queue up rumble command to be executed on the next NMI/IRQ cycle
queue_rumble	MACRO	[left,right,time]
	ifne	longa
	printerror	<%m: A must be in 8-bit mode!>
	endc

; Each nybble controls the strength of each motor.
; <--RIGHT--> <---LEFT-->
; R3 R2 R1 R0 L3 L2 L1 L0

	lda	rumble_priority
	bne	.\@skip
	lda	#({right}<<4)+({left})
	sta	rumble_cmd

	lda	#{time}
	sta	rumble_time
.\@skip
	ENDM

; set priority for last called timed rumble
set_rumble_priority	MACRO
	ifne	longa
	printerror	<%m: A must be in 8-bit mode!>
	endc
	lda	#1
	sta	rumble_priority
	ENDM
	
; Same as above, but correct DBR for strat/path interpreter
s_queue_rumble	MACRO	[left,right,time]
	ifne	longa
	printerror	<%m: A must be in 8-bit mode!>
	endc
	PHB
	lda	#0
	pha
	plb
	queue_rumble	{left},{right},{time}
	plb
	ENDM

; Same as above, but for PATHs
P_QUEUERUMBLE	MACRO	[left,right,time]
	P_START65816
	s_queue_rumble	{left},{right},{time}
	P_END65816
	ENDM

; PATH macro for tables
P_QUEUERUMBLETAB	MACRO	[table]
	P_START65816
	s_queue_rumble_table	{table}
	P_END65816
	ENDM

; For calling long routines from PATHs
P_EXECRUMBLE	MACRO	[label]
	P_START65816
	jsl	[label]
	P_END65816
	ENDM

; Uses a table for sequenced rumbles
s_queue_rumble_table	MACRO	[table]
	ifne	longa
	printerror	<%m: A must be in 8-bit mode!>
	endc
	phx
	lda #1
	sta rumble_index
	ldx	#0
.loop\@
	lda.l {table},x
	cmp #$19
	beq	.done2\@
	sta rumble_table,x
	inx
	cpx #40
	bmi	.loop\@
	bra	.done\@
.done2\@
	sta rumble_table,x
.done\@
	plx
	ENDM

; Terminate rumble sequence
s_end_rumble_table	MACRO
	ifne	longa
	printerror	<%m: A must be in 8-bit mode!>
	endc
	stz	rumble_index
	ENDM

;------------------------------------
; rumble sequence constants
rmblseqlen	equ	40	; rumble sequence max length

; special rumble sequence commands
rmblend		equ	$19	; end sequence
rmblloop	equ	$91	; loop sequence
