;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                                                                   ³
;³                                                                   ³
;³  Code for drawing boxes, lines and the such                       ³
;³                                                                   ³
;³                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



bossmeter_y	equ	192-12
bossmeter_x	equ	(gameNum_col-5)*8-8

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; r0    = colour
; r1,r2 = x,y
; r3,r4 = width,height
; r3/r5-r10 unchanged, r14 corrupted
; ----- returns:
; r1/r2 point to the next row
; r4 returns as 0

mdrawsolidbox
	inc	r0
	moves	r3,r3
	beq	.nobox
	colour		; set the colour
	moves	r4,r4
	beq	.nobox
	nop

	mcache

	move	r12,r3
	move	r13,r15
	loop
	plot		; draw the top line

	with	r1
	sub	r3

	dec	r0	; decrement the colour

	dec	r4
	dec	r4
	beq	.nocando
	inc	r2

	dec	r1
	move	r14,r11
	mcall	mdrawvertline
	nop
	move	r11,r14
	inc	r1

	with	r1
	add	r3
	move	r14,r11
	mcall	mdrawvertline
	nop
	move	r11,r14
	with	r1
	sub	r3

	colour

	mcache


.nextrow
	move	r12,r3
	move	r13,r15
	loop		; draw the middle line
	plot

	with	r1
	sub	r3

	dec	r4

	bne	.nextrow
	inc	r2

.nocando
	dec	r0
	colour

	move	r12,r3
	move	r13,r15
	loop
	plot		; draw the bottom line

	with	r1
	sub	r3


.nobox	jmp	r11
	nop


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; r0    = colour
; r1,r2 = x,y
; r3,r4 = width,height
; r3/r5-r10/r14 unchanged
; ----- returns:
; r1/r2 point to the next row
; r4 returns as 0

mdrawsolidbox3
	inc	r0
	moves	r3,r3
	beq	.nobox
	colour		; set the colour
	moves	r4,r4
	beq	.nobox
	nop

	mcache

	move	r12,r3
	move	r13,r15
	loop
	plot		; draw the top line

	with	r1
	sub	r3

	dec	r0
	colour

	dec	r4
	dec	r4
	beq	.nocando
	inc	r2

.nextrow
	move	r12,r3
	move	r13,r15
	loop		; draw the middle line
	plot

	with	r1
	sub	r3

	dec	r4

	bne	.nextrow
	inc	r2

.nocando
	inc	r0
	colour

	move	r12,r3
	move	r13,r15
	loop
	plot		; draw the bottom line

	with	r1
	sub	r3


.nobox	jmp	r11
	nop


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; r0 	= colour
; r1,r2 = x,y
; r3,r4 = width,height
; r3-r10/r14 unchanged, r7-r9 corrupt
mdrawbox
	move	r9,r11
	move	r8,r4
	move	r7,r3

	ibt	r0,#9
	mcall	mdrawsolidbox3
	nop

	move	r4,r8

	with	r2
	sub	r4	; restore to old x,y

	dec	r1	; x-1
	inc	r2	; y+1
	inc	r2	; y+1

	dec	r4
	dec	r4

	ibt	r3,#1

	ibt	r0,#9
	mcall	mdrawsolidbox3
	nop

	move	r4,r8

	with	r2
	sub	r4

	dec	r1	; x-1

	with	r2
	add	#4

	with	r4
	sub	#4

	ibt	r0,#10
	mcall	mdrawvertline
	nop

	move	r4,r8

	with	r1
	add	r7
	with	r1
	inc	r1
	inc	r1	; position to end of meter

	dec	r2

	dec	r4
	dec	r4

	ibt	r0,#9
	mcall	mdrawsolidbox3
	nop

	move	r4,r8

	with	r2
	sub	r4

	inc	r1	; x+1

	with	r2
	add	#4

	with	r4
	sub	#4

	ibt	r0,#10
	mcall	mdrawvertline
	nop

	jmp	r9
	nop

;;;	move	r12,r3	; width
;;;	move	r13,r15
;;;	loop		; draw the top line
;;;	plot
;;;
;;;
;;;	move	r12,r3	; width
;;;	move	r13,r15
;;;	loop		; draw the bottom line
;;;	plot
;;;
;;;	ibt	r0,#12
;;;	colour
;;;
;;;	move	r12,r4
;;;	dec	r12
;;;	dec	r12	; height-2
;;;	move	r13,r15
;;;; vertical line loop
;;;	inc	r2	; inc y
;;;	with	r1
;;;	sub	r3
;;;	plot		; plot left side
;;;	with	r1
;;;	add	r3
;;;	dec	r1
;;;	dec	r1
;;;	loop
;;;	plot
;;;
;;;	with	r1
;;;	sub	r3	; subtract width from x
;;;	inc	r2
;;;
;;;
;;;	jmp	r11
;;;	nop

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; r0 = colour
; r1,r2 = x,y
; r3 = width
; r3-r10/r14 unchanged
mdrawhorzline
;	colour
	mcache
	moves	r12,r3
	beq	.noloop
;	nop
	colour
	move	r13,r15
	loop		; draw the bottom line
	plot

.noloop
	jmp	r11
	nop

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; r0 = colour
; r1,r2 = x,y
; r4 = height
; r3-r10/r14 unchanged
mdrawvertline
	mcache
	moves	r12,r4
	beq	.noloop
	colour
	
	move	r13,r15
	plot
	dec	r1
	loop		; draw the bottom line
	inc	r2

	with	r2
	sub	r4

.noloop
	jmp	r11
	nop

;--------------------------------------------




boostx	=	22*8
boosty	=	22*8
boostheight =	8

mboostmeter
	IFEQ	1

	mpush	r11


	move	r1,#boostx
	move	r2,#boosty
	move	r3,#40
	move	r4,#boostheight

	move	r0,#$d
	mcall	mdrawbox
	nop

;	move	r1,#boostx+1
;	move	r2,#boosty+1
;	move	r3,#38
;	move	r4,#boostheight-2

;	move	r0,#10
;	mcall	mdrawsolidbox
;	nop


	move	r3,[m_boostanim]
	with	r3
	lob
	move	r0,#36
	cmp	r3
	bge	.iiyo
	nop
	move	r3,r0
.iiyo

	move	r1,#boostx+2
	move	r2,#boosty+2
	move	r4,#boostheight-4

	move	r0,#7
	mcall	mdrawsolidbox
	nop
	

	mpop	pc
	nop




	IFEQ	1
	sub	r0
	cmode
	mcache

	lms	r12,[m_boostanim]
	with	r12
	lob
	miwt	r10,40
	with	r10		;r11=remainder
	sub	r12		;r12=number left

	miwt	r1,22*8
	miwt	r2,22*8

	ibt	r4,#8
.lp
	ibt	r0,#6
	colour
	moves	r3,r10
	beq	.elp2
	nop
.lp2	plot
	dec	r3
	bne	.lp2
	nop
.elp2
	ibt	r0,#5
	colour
	moves	r3,r12
	beq	.elp3
	nop
.lp3	plot
	dec	r3
	bne	.lp3
	nop
.elp3
	ibt	r0,#40
	with	r1
	sub	r0
	inc	r2

	dec	r4
	bne	.lp
	nop

	jmp	r11
	nop

	ENDC

	ENDC

damagex	=	1
damagey	=	11*8-2	;10*8+8+2
damageheight =	5

mdamagemeter
	IFEQ	1
	mpush	r11

	move	r1,#damagex
	move	r2,#damagey
	move	r3,#40
	move	r4,#damageheight

	move	r0,#$d
	mcall	mdrawbox
	nop

;	move	r1,#damagex+1
;	move	r2,#damagey+1
;	move	r3,#38
;	move	r4,#damageheight-2

;	move	r0,#1
;	mcall	mdrawsolidbox
;	nop

	move	r3,[m_playerhp]
	with	r3
	lob
	move	r0,#36
	cmp	r3
	bge	.iiyo
	nop
	move	r3,r0
.iiyo

	move	r1,#damagex+2
	move	r2,#damagey+2
	move	r4,#damageheight-4

	move	r0,#2
	mcall	mdrawsolidbox
	nop

	mpop	pc
	nop


	IFEQ	1
	lms	r12,[m_damage]
	with	r12
	lob
	miwt	r10,40
	with	r10		;r11=remainder
	sub	r12		;r12=number left

	miwt	r1,8
	miwt	r2,22*8

	ibt	r4,#8
.lp
	ibt	r0,#2
	colour
	moves	r3,r12
	beq	.elp2
	nop
.lp2	plot
	dec	r3
	bne	.lp2
	nop
.elp2
	ibt	r0,#1
	colour
	moves	r3,r10
	beq	.elp3
	nop
.lp3	plot
	dec	r3
	bne	.lp3
	nop
.elp3
	ibt	r0,#40
	with	r1
	sub	r0
	inc	r2

	dec	r4
	bne	.lp
	nop

	jmp	r11
	nop

	ENDC


	ENDC
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; m_bossmaxHP is the maximum
; m_bossHP is the current

bossmeterheight	=	10

mdrawbossHP
;	lm	r0,[m_bossmeter_off]
;	lob
;	beq	.con565
;	nop
;	jmp	r11
;	nop
;.con565
	mpush	r11

	move	r0,[m_bossmaxHP]
	add	#10
	to	r1
	lob

	move	r0,[m_bossHP]
	lob
	cmp	r1
	bcc	.nowt
	nop
	ibt	r0,#0
	sms	[m_bossHP],r0
.nowt

	move	r0,[m_bossmaxHP]
	to	r3
	lob
	mlbeq	.nodraw
;	bpl	.nodiv2
;	nop
;	with	r3
;	lsr
.nodiv2

	inc	r3
	inc	r3
	inc	r3
	inc	r3

	move	r4,#bossmeterheight

	move	r0,#bossmeter_x
	to	r1
	sub	r3

	move	r2,#bossmeter_y

	move	r5,r1
	move	r6,r2		; store x,y

	mcall	mdrawbox
	nop

	move	r1,r5	; restore x
	inc	r1
	inc	r1
	move	r2,r6
	inc	r2
	inc	r2

	move	r0,[m_bossHP]
	to	r3
	lob

	move	r0,[m_bossmaxHP]
	to	r7
	lob
;	bpl	.nodiv2_2
;	nop
;	with	r3
;	lsr	r3
.nodiv2_2
	move	r4,#bossmeterheight-4

	from	r7
	lsr
	lsr
	lsr
	cmp	r3
	bcc	.noflash
	nop
	lm	r0,[m_dustframe]
	and	#1
	add	r0
	add	#2
	bra	.drawit
	nop

.noflash
	move	r0,#2
.drawit
	mcall	mdrawsolidbox
	nop

	iwt	r0,#smallfont&WM
	sm	[m_font],r0
	lm	r0,[m_bossname]
	sms	[m_txtdata],r0
	mpush	r0

	mpush	r5	; push x

;	lm	r0,[m_bossname+2]
	ibt	r0,#name_wolf>>16
	sms	[m_txtdatabank],r0

	ibt	r0,#127
	sms	[m_visualwidth],r0

	mcall	mwordwrap	; returns r2 as the length in pixels
	nop

	sms	[m_z1],r0

	mpop	r0

	sub	r2
	sub	#2
	sms	[m_x1],r0
	mpush	r0

	iwt	r0,#bossmeter_y+2	;14
	sms	[m_y1],r0
	mpush	r0

	ibt	r0,#9
	sm	[m_textcolour],r0


	mcall	mprintstringn
	nop

	ibt	r0,#4
	sm	[m_textcolour],r0

	mpop	r0
	dec	r0
	sms	[m_y1],r0

	mpop	r0
	dec	r0
	sms	[m_x1],r0

	mpop	r0
	sms	[m_txtdata],r0

	ibt	r0,#-1
	sms	[m_z1],r0

	mcall	mprintstringn
	nop

	rpix

.nodraw

	sub	r0
	move	[m_bossHP],r0

	mpop	pc
	nop


;------------------------------------------------------------
; clear top section of screen for end credits sequence

clrtop_y	=	(techdata_pos2+8-16)&$ff8

mclrforcredits_l
	sub	r0
	romb
	ramb

	mcache

	lm	r1,[m_olddrawmap]

	lms	r0,[m_xright]
	inc	r0
	div2
	div2
	to	r2
	div2

	iwt	r4,#clrtop_y
	lm	r3,[m_screenheight]
	from	r3
	sub	r4
	add	r0
	to	r3
	add	r0
	
	sub	r0

.mataloop
	iwt	r12,#clrtop_y*2
	move	r13,r15

	stw	[r1]
	inc	r1
	loop
	inc	r1

	with	r1
	add	r3

	dec	r2
	bne	.mataloop
	nop

	stop
	nop




