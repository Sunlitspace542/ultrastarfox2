;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º FILE:                MCURSOR.MC                           º
;º AUTHOR:              Takumi Kawagoe   Nintendo.co.ltd  EDAº
;º DESCRIPTION:         Draw Player cursor(altmeter etc.)    º
;º DATE CREATED:        27-8-93                              º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
; this file is included in mdrawlis.mc


;--------------------------------------------------------------
; Draw enemy cursor
;--------------------------------------------------------------
mENEMYcursor
;	In	:m_e_altmeter_x
;		:m_e_altmeter_y
;		:m_e_altmeter_col1 : colour of bit1
;		:m_e_altmeter_col2 : colour of bit2
;		:m_e_altmeter_col3 : colour of bit3
;		:m_ecurbank	   : ROM BANK of cursor data
;		:m_ecurptr	   : ROM pointer of cursor data

	mpush	r11

	mcall	mboostmeter2
	nop

	move	r0,[m_ecurptr]
	moves	r0,r0
	bne	.START
	nop

	mpop	pc
	nop

.START
;------------------------------------------------------
	move	r3,#8	; half sizeX of cursor
	move	r4,#4	; offset Y
	move	r1,[m_e_altmeter_x]
;------------------------------------------------------

.clpx0	with	r1	; clipping X
	sbc	r3
	from	r1	; offset
	sbc	r4
	bpl	.clpx1
	nop

	move	r1,r4	; set X
	add	r4
	bra	.clpy0
	nop
.clpx1
	from	r1	; X+sizex*2+offset > Xmax?
	add	r3
	add	r3
	add	r4
	move	r7,#bitmapwidth_1*8
;GGG	move	r7,[m_screenwidth]
	cmp	r7
	bmi	.clpy0
	nop
;	move	r0,#bitmapwidth*8	; set X
	move	r0,#bitmapwidth_1*8
;	move	r0,[m_screenwidth]
	sbc	r3
	sbc	r3
	to	r1
	sbc	r4

;------------------------------------------------------
.clpy0
	move	r5,#8	; half sizeY of cursor
	move	r6,#4	; offset Y
	move	r2,[m_e_altmeter_y]
;------------------------------------------------------
	with	r2	; clipping Y
	sbc	r5

	from	r2	; offset
	sbc	r6
	bpl	.clpy1
	nop

	move	r2,r6	; set Y
	add	r6

.clpy1
	from	r2	; Y+sizey*2+offset > Ymax?
	add	r5
	add	r5
	add	r6
	move	r7,#bitmapvheight_1*8
	cmp	r7
	bmi	.draw
	nop

	move	r2,#20

	move	r0,#bitmapvheight_1*8	; set Y
	sbc	r5
	sbc	r5
	to	r2
	sbc	r6

.draw
	move	[m_cur_x],r1
	move	[m_cur_y],r2

	move	r0,[m_ecurbank]
	move	[m_PROMBANK],r0
	move	r0,[m_ecurptr]
	move	[m_PROMpointer],r0
	move	r0,[m_e_altmeter_flag]
	move	[m_cur_flag],r0
	move	r0,[m_e_altmeter_col1]
	move	[m_cur_col],r0

	mcall	mdrawEcur1bit
	nop

;	mcall	mboostmeter2
;	nop

;finish
;------------------------------------------------------------------------------

;	move	r3,#24
;	move	r1,#80	;posx
;	move	r2,#80	;posy
;pos x
;	move	r0,[m_e_altmeter_x]
;	move	r1,[m_e_string_ofsx]
;	to	r1
;	add	r1
;pos y
;	move	r0,[m_e_altmeter_y]
;	move	r2,[m_e_string_ofsy]
;	sub	#1
;	to	r2
;	add	r2
;
;
;	move	r4,#9	;bstheight-4
;	move	r0,#3	;[m_boostanim]	; high byte = color
;
;	mcall	mdrawsolidbox
;	nop
	
;******
	iwt	r0,#displayfont&WM
	sms	[m_font],r0
	move	r0,[m_e_altmeter_x]
	move	r1,[m_e_string_ofsx]
	add	r1

	move	r1,#-4
	to	r1
	add	r1
	bpl	.xpl
	nop
.xout	move	r0,#4
.xpl


	move	r1,#bitmapwidth_1*8-6*8
	cmp	r1
	bmi	.stlmt
	nop
	move	r0,r1

.stlmt

	sms	[m_x1],r0
	move	r0,[m_e_altmeter_y]
	move	r1,[m_e_string_ofsy]
	add	r1

	move	r1,#-16
	to	r1
	add	r1
	bmi	.sy16
	nop

	move	r1,#16
	cmp	r1
	bpl	.sy0
	nop
.sy16	move	r0,#16
.sy0
	move	r1,#bitmapheight_1*8-16
	cmp	r1
	bmi	.sy1
	nop
	move	r0,#bitmapheight_1*8-16
.sy1	sms	[m_y1],r0


;****** print strings

	lm	r0,[m_e_stringbank]
	sm	[m_txtdatabank],r0

;************

	move	r0,[m_e_string_col]
	move	r1,#0ff00h
	and	r1
	hib	r0
	sm	[m_textcolour],r0

	lm	r0,[m_e_string2]
	sm	[m_txtdata],r0

	ibt	r0,#-1
	sms	[m_z1],r0
	mcall	mprintstringn
	nop

;************

	move	r0,[m_e_string_col]
	sm	[m_textcolour],r0

	move	r0,[m_x1]
	adc	#7
	sms	[m_x1],r0

	lm	r0,[m_e_string]
	sm	[m_txtdata],r0

	ibt	r0,#-1
	sms	[m_z1],r0
	mcall	mprintstringn
	nop



;------------------------------------------------------------------------------

	mpop	pc
	nop

;------------------------------------------------------
; Draw triangle routine fot PLAYER altmeter cursor
;------------------------------------------------------
; m_p_altmeter_x    = pos X  This value is using for check player1 or 2
; m_p_altmeter_y    = pos Y of altmeter's triangle
; m_p_altmeter_col  = colour of triangle
; m_p_altmeter_posx = pos X of altmeter's line

maltline

;altlineX
;
	mcache
	mpush	r11

	move	r1,[m_p_altmeter_posx]
	moves	r1,r1
	bpl	.draw
	nop
	mpop	pc
	nop


.draw	move	r0,#$1	; colour
	colour

;;;	move	r1,[m_p_altmeter_posx]

	move	r0,#bitmapvheight_1*8
;GGG	move	r0,[m_screenvheight]	; Ypos
	ror	r0
	move	r2,#20			; nagasa/2
	to	r2
	sub	r2

	move	r3,#7	; nagasa
	move	r12,r3	; width
	move	r13,r15
	loop		; draw the top line
	plot

	move	r1,[m_p_altmeter_posx]

	move	r0,#bitmapvheight_1*8
;GGG	move	r0,[m_screenvheight]	; Ypos
	ror	r0
	move	r2,#20			; nagasa/2
	to	r2
	add	r2

	move	r12,r3	; width
	move	r13,r15
	loop		; draw the top line
	plot




;	move	r1,[m_p_altmeter_posx]
;
;	move	r2,#28	; Ypos
;
;	move	r3,#7	; nagasa
;	move	r12,r3	; width
;	move	r13,r15
;	loop		; draw the top line
;	plot
;
;	move	r1,[m_p_altmeter_posx]
;	move	r2,#28+40
;	move	r12,r3	; width
;	move	r13,r15
;	loop		; draw the top line
;	plot
;------------------------------------------------------
;******************************************************
; draw water line

; limitter(r4:height)

	move	r0,[m_p_waterline]	; height
	sub	#1
	bmi	.nowater
	nop
	move	r4,#37
	cmp	r4
	bmi	.nolmtw
	nop
	move	r0,#37
.nolmtw
	move	r4,r0



; X pos
	move	r1,[m_p_altmeter_posx]
	with	r1
	add	#1

; Y pos
	move	r0,#bitmapvheight_1*8
;GGG	move	r0,[m_screenvheight]	; Ypos
	ror	r0
	move	r2,#19
	add	r2
	move	r2,r4	;[m_p_waterline]	; height
	to	r2
	sub	r2


	move	r3,#6			; width
;	move	r4,#20	;[m_p_waterline]	; height

	move	r0,#7		; = color

	mcall	mdrawsolidbox2
	nop
	
;	mcall	mdrawbox
;	nop

.nowater

;******************************************************
	move	r0,[m_pcurptr]
	moves	r0,r0
	bne	.START
	nop

	mpop	pc
	nop
.START

	move	r1,[m_p_altmeter_x]
	move	r1,[m_p_altmeter_x]
	move	r2,[m_p_altmeter_y]
	move	[m_cur_x],r1
	move	[m_cur_y],r2

	move	r0,[m_p_altmeter_flag]
	move	[m_cur_flag],r0


	move	r1,[m_pcurbank]
	move	[m_PROMBANK],r1
	move	r1,[m_pcurptr]
	move	[m_PROMpointer],r1

	move	r0,[m_p_altmeter_col]
	move	[m_cur_col],r0

	mcall	mdrawEcur1bit
	nop

;finish

	mpop	pc
	nop



	IFEQ	1
;******************************************************
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; r0    = none
; r1,r2 = none
;
;
; /r5-r10/r14 unchanged

	move	r1,[m_p_altmeter_x]
	move	r2,[m_p_altmeter_y]

	move	r0,[m_p_altmeter_col]
	colour

;	move	r0,#bitmapwidth*8/2
	move	r0,#bitmapwidth_1*8/2
;GGG	move	r0,[m_screenwidth]	;*
	ror	r0			;*

	from	r1
	cmp	r0

	bcc	.p2
	nop
.p1

	move	r3,#2
	mcall	maltline1
	nop
	move	r3,#4
	mcall	maltline1
	nop
	move	r3,#6
	mcall	maltline1
	nop
	move	r3,#6
	mcall	maltline1
	nop
	move	r3,#4
	mcall	maltline1
	nop
	move	r3,#2
	mcall	maltline1
	nop

.nobox
	mpop	pc
	nop

.p2
	with	r1
	add	#8

	move	r3,#2
	mcall	maltline2
	nop
	move	r3,#4
	mcall	maltline2
	nop
	move	r3,#6
	mcall	maltline2
	nop
	move	r3,#6
	mcall	maltline2
	nop
	move	r3,#4
	mcall	maltline2
	nop
	move	r3,#2
	mcall	maltline2
	nop

	mpop	pc
	nop

	ENDC

;------------------------------------------------------
maltline1

	mpush	r11
	mcache

	move	r12,r3
	move	r13,r15
	loop		; draw the bottom line
	plot

	with	r1
	sub	r3	; Xpos
	inc	r2	; Ypos

	mpop	pc
	nop

maltline2

	mpush	r11
	mcache

	with	r1
	sub	r3	; Xpos

	move	r12,r3
	move	r13,r15
	loop		; draw the bottom line
	plot

	inc	r2	; Ypos

	mpop	pc
	nop





;------------------------------------------------------
; Draw Boost meter ( only mission mode )
;------------------------------------------------------
bstx	=	23*8	;+2	;-3
bsty	=	19*8
bstheight =	8
bstframex	=	35+2
bstmeterx	=	32+2+1
bstbluex	=	25+2

mboostmeter2
	mpush	r11


	move	r0,[m_boostcnt]
	moves	r0,r0
	beq	.exit
	nop

.do
;;;;;	move	r1,#bstx
	move	r2,#bsty
;;;;;	move	r3,#bstframex
	move	r4,#bstheight

	move	r1,[m_boostposx]
	move	r3,[m_boostframex]



	move	r0,#$d
	mcall	mdrawbox
	nop



;meter(RED ZONE)

	move	r3,[m_boostanim]
	with	r3
	lob
	move	r0,#bstmeterx
	cmp	r3
	bge	.iiyo2
	nop
	move	r3,r0
.iiyo2

	move	r0,[m_boostanim]	; high byte = color
	hib
	move	r1,#7
	cmp	r1
	bne	.drawREDZONE
	nop

;	move	r0,#2	;= RED ZONE color
	move	r0,#7	;= BLUE

.drawREDZONE


;SET POS*****
	move	r1,[m_boostposx]
	with	r1
	add	#1
;************

;	move	r1,#bstx+1

	move	r2,#bsty+2
	move	r4,#bstheight-4
	mcall	mdrawsolidbox
	nop
	

;meter(BLUE)
;.iiyo3	move	r3,[m_boostanim]
;	with	r3
;	lob
;	move	r0,#bstbluex
;	cmp	r3
;	bge	.iiyo
;	nop
;	move	r3,r0
;.iiyo
;
;	move	r1,#bstx+1
;	move	r2,#bsty+2
;	move	r4,#bstheight-4
;
;	move	r0,[m_boostanim]	; high byte = color
;	hib
;
;	mcall	mdrawsolidbox
;	nop
	
.exit	mpop	pc
	nop


;---------------------------------------------------------------------------
;	water line test
;---------------------------------------------------------------------------

;mwaterlinetest
;
;	mpush	r11



;.do	;move	r1,#80			; pos x
	;move	r2,[m_waterline]	; pos y
	;moves	r2,r2
	;bpl	.clip
	;nop
	;move	r2,#0

;.clip	;move	r0,[m_screenvheight]
	;sub	#4

	;cmp	r2
	;bcs	.draw
	;nop
	;move	r2,r0

.draw	;move	r3,#80
	;move	r4,#4

	;move	r0,#$2
	;mcall	mdrawbox
	;nop

;	mpop	pc
;	nop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;	DRAW ROUTINES
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;------------------------------------------------------
; Software Sprite routine fot ENEMY cursor
;------------------------------------------------------
;	In	:m_cur_x
;		:m_cur_y
;		:m_cur_col : colour of bit1
;		:m_cur_flag : colour of bit3

;flags : m_e_altmeter_flag
ECHflipflag	equ	%100000000	;Hflip flag(0:off 1:on)
ECVflipflag	equ	%1000000000	;Vflip flag(0:off 1:on)
ECshiftflag	equ	%10000000	;flip flag(0:off 1:on)
ECshiftLR	equ	%00001111	;shift times(0-15)
ECshiftUD	equ	%11110000	;shift times(0-15)
;ECshiftNo	equ	%00001111	;shift times(0-15)
;ECshiftLR	equ	%00010000	;direction of shift(0:R 1:L)
;ECshiftUD	equ	%00100000	;direction of shift(0:U 1:D)

;unchange : r8,r9-r12

mdrawEcur1bit

	mpush	r11

	move	r1,[m_cur_x]
	move	r2,[m_cur_y]
	move	r5,[m_cur_flag]
	move	r0,[m_cur_col]
	colour

;	move	r0,#bitmapwidth*8/2
	move	r0,#bitmapwidth_1*8/2
;GGG	move	r0,[m_screenwidth]	;*
	ror	r0			;*

	from	r1
	cmp	r0

; set ROM poinetr

	move	r0,[m_PROMBANK]
	ROMB
	move	r14,[m_PROMpointer]




;------------------------------------
;V flip initial

	move	r0,#ECVflipflag
	and	r5		; r5 flag
	moves	r0,r0
	beq	.noVf
	nop
	move	r0,#16
	with	r2
	add	r0

.noVf
;------------------------------------
	move	r3,#16		; loop times = Y 16dot

	mcache

;------------------------------------
; shift U D
	move	r0,#ECshiftUD	; mask
	and	r5		; shift times
	lsr
	lsr
	lsr
	lsr
	move	r7,r0
	add	r0		; *2
	with	r14
	add	r0

	with	r7		;counter for ROM pointer change
	xor	#15
	inc	r7
.line1

;------------------------------------

	mgetwi	r4		; read ROM data

;------------------------------------
; shift L R
	from	r5		; shift times
	to	r12
	and	#ECshiftLR	; mask
	moves	r0,r12		; 0:no shift r7:tate shift times
	beq	.exitSHIFT
	nop

.shiftL
	move	r0,#0		; clear carry
	rol
	move	r13,r15		; loop pointer
	from	r4
	rol
	with	r4
	rol
	loop
	nop
.exitSHIFTLR

.exitSHIFT

;------------------------------------
; draw 1 line

	move	r12,#16		; loop times = X 16dot
	move	r13,r15		; loop pointer

	move	r0,#ECHflipflag
	and	r5		; r5 flag
	moves	r0,r0
	bne	.Hflipon
	nop

.HflipOFF

	with	r4
	rol	r4
	bcc	.noplot
	nop
	plot
	nop
	bra	.next
	nop
.HflipON
	with	r4
	ror	r4
	bcc	.noplot
	nop
	plot
	bra	.next
	nop

.noplot	inc 	r1
.next

	loop		; draw the bottom line
	nop

;------------------------------------
	move	r0,#16
	with	r1	; reset X pos
	sub	r0



;--------------------
; Vflip
	move	r0,#ECVflipflag
	and	r5		; r5 flag
	moves	r0,r0
	beq	.Vflipoff
	nop
.VflipON	dec	r2
	bra	.exit_Vflip
	nop

.Vflipoff	inc	r2	; reset Y pos

.exit_Vflip
;--------------------

	dec	r7	; set ROM pointer for tate shift
	bne	.next1
	nop
	move	r0,#32
	with	r14
	sub	r0

.next1	dec	r3
	bne	.line1
	nop
;------------------------------------
	mpop	pc
	nop

;------------------------------------------------------
; Software Sprite routine fot ENEMY cursor
;------------------------------------------------------
;	In	:m_cur_x
;		:m_cur_y
;		:m_cur_col : colour of bit1
;		:m_cur_col1 : colour of bit2
;		:m_cur_col2 : colour of bit3

;unchange : r9-r12/r14

	IFEQ	1

mdrawEcur2bit

	mpush	r11

	move	r0,#2	; col

	move	r1,[m_cur_x]
	move	r2,[m_cur_y]

	move	r6,[m_cur_col]
	move	r7,[m_cur_col1]
	move	r8,[m_cur_col2]

;	move	r0,#bitmapwidth*8/2
	move	r0,#bitmapwidth_1*8
;GGG	move	r0,[m_screenwidth]	;*
	ror	r0			;*
	from	r1
	cmp	r0

; set ROM poinetr

	move	r0,[m_PROMBANK]
	ROMB
	move	r14,[m_PROMpointer]

;------------------------------------
	move	r3,#16		; loop times = Y 16dot

	mcache

.loop0
	move	r5,#2		; loop times = 2

.line1
	mgetwi	r4		; read ROM data

;------------------------------------
; draw 1 line

	move	r12,#8		; loop times = X 16dot/2
	move	r13,r15		; loop pointer

	from	r4
	and	#3

	moves	r0,r0
	beq	.noplot
	nop
	dec	r0
	beq	.bit1
	nop
	dec	r0
	beq	.bit2
	nop

.bit3
	move	r0,r8
	bra	.plot
	nop
.bit2
	move	r0,r7
	bra	.plot
	nop
.bit1
	move	r0,r6
	bra	.plot
	nop

.plot	from	r0
	colour
	plot
	bra	.next
	nop

.noplot	inc 	r1
.next

	with	r4
	lsr	r4
	with	r4
	lsr	r4

	loop		; draw the bottom line
	nop

	with	r5
	dec	r5
	bne	.line1
	nop
;------------------------------------
	move	r0,#16
	with	r1	; reset X pos
	sub	r0
	inc	r2	; reset Y pos

	dec	r3
	bne	.loop0
	nop
;------------------------------------
	mpop	pc
	nop

	ENDC


;------------------------------------------------------
;-- using Giles's line routine(sample) --
;	move	r1,#120
;	move	r2,#10
;	move	r3,#140
;	move	r9,#20
;
;	mcall	mdodrawline
;	nop
;------------------------------------------------------

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	SPLINE ROUTINE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;{Out}=#{c1}*({T}^3) + #{c2}*({T}^2) + #{c3}*{T} + #{c4}
;using r0,r1,r4,r5,r6 as tmp

;mBTcalc	macro	[Out,T,c1,c2,c3,c4]
;
;#c3*T
;	move	r1,{T}
;	move	r6,r1
;	move	r0,#{c3}
;	mmul	r6,r0
;	add	r0
;	move	{Out},r0

;#c2*T^2
;	mmul	r6,r1	;T^2
;	add	r0
;	move	r6,r0
;	move	r0,#{c2}
;	mmul	r6,r0
;	add	r0
;	with	{Out}
;	add	r0

;#c1*T^3
;	mmul	r6,r1	;T^3
;	add	r0
;	move	r6,r0
;	move	r0,#{c1}
;	mmul	r6,r0
;	add	r0
;	with	{Out}
;	add	r0
;
;	move	r0,#{c4}
;	with	{Out}
;	add	r0
;
;	endm
;



;OutH,OutL = c1*T^3 + c2*T^2 + c3*T^1 +c4
; c1,c2,c3 = signed 15 bit

mBTcalc	macro	[OutH,OutL,T,c1,c2,c3,c4]

;#c3*T
	move	r1,{T}
	move	r6,r1
	move	r0,#{c3}
	mmul	r6,r0
	with	r4	;$
	add	r4	;$
	adc	r0

	move	{OutL},r4
	move	{OutH},r0

;#c2*T^2
	mmul	r6,r1	;T^2
	add	r0
	move	r6,r0
	move	r0,#{c2}
	mmul	r6,r0
	with	r4	;$
	add	r4	;$
	adc	r0
	with	{OutL}
	add	r4
	with	{OutH}
	adc	r0

;#c1*T^3
	mmul	r6,r1	;T^3
	add	r0
	move	r6,r0
	move	r0,#{c1}
	mmul	r6,r0
	with	r4	;$
	add	r4	;$
	adc	r0
	with	{OutL}
	add	r4
	with	{OutH}
	adc	r0

	move	r0,#{c4}
	with	{OutH}
	add	r0

	endm


;OutH,OutL = c1*T^2 + c2*T + c3
; c1,c2,c3 = signed 14 bit

mdivBTcalc	macro	[OutH,OutL,T,c1,c2,c3]

;#c1*T^2
	move	r1,{T}
	with	r1
	asr	r1

	move	r6,r1
	mmul	r6,r1

	with	r4	;*
	add	r4	;*
	adc	r0
	with	r4	;*
	add	r4	;*
	adc	r0

	move	r6,#{c1}
	mmul	r6,r0
	add	r0
	add	r0
	move	{OutH},r0
	move	{OutL},r4

;#c2*T
	move	r1,{T}
	with	r1
	asr	r1

	move	r6,#{c2}
	mmul	r6,r1
	with	r4	;*
	add	r4	;*
	adc	r0
	with	r4	;*
	add	r4	;*
	adc	r0


	with	{OutL}
	add	r4
	with	{OutH}
	adc	r0

;+#c3
	move	r0,#{c3}
	with	{OutH}
	add	r0

	endm

;OutH,OutL = c1*T + c2
; c1 = signed 14 bit

mdiv2BTcalc	macro	[OutH,OutL,T,c1,c2]

;#c1*T
	move	r1,{T}
	with	r1
	asr	r1
	asr	r1

	move	r6,#{c1}
	mmul	r6,r0
	add	r0
	add	r0
	add	r0
	move	{OutH},r0
;+#c2
	move	r0,#{c2}
	with	{OutH}
	add	r0

	endm

;------------------------------------------------------

BT	equr	7
BTL	equr	8
SPVAR	equr	9	;Out
SPDIV	equr	12	;Out
SPDIV2	equr	13	;Out
mspline
;	mcall	.mcalcspline
	nop
	stop
	nop

	IFEQ	1
.mcalcspline

	mpush	r11

; m_VAR = [m_VAR1]*B1T + [m_VAR2]*B2T + [m_VAR3]*B3T + [m_VAR4]*B4T

	mcall	.calcB1T
	nop
	mcall	.calcB2T
	nop
	mcall	.calcB3T
	nop
	mcall	.calcB4T
	nop
	sm	[m_VAR],SPVAR

; m_DIV = [m_VAR1]*divB1T + [m_VAR2]*divB2T + [m_VAR3]*divB3T + [m_VAR4]*divB4T

	mcall	.calcdivB1T
	nop
	mcall	.calcdivB2T
	nop
	mcall	.calcdivB3T
	nop
	mcall	.calcdivB4T
	nop
	sm	[m_DIV],SPDIV

; m_DIV2 = [m_VAR1]*div2B1T + [m_VAR2]*div2B2T + [m_VAR3]*div2B3T + [m_VAR4]*div2B4T

	mcall	.calcdiv2B1T
	nop
	mcall	.calcdiv2B2T
	nop
	mcall	.calcdiv2B3T
	nop
	mcall	.calcdiv2B4T
	nop
	sm	[m_DIV2],SPDIV2

	mpop	pc
	nop

	ENDC


	IFEQ	1
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
; calc B1(T) B2(T) B3(T) B4(T)
;T=signed 16
;
;in	m_splineT
;out	SPVAR
;
;using	r0(tmp)
;	r1(T)
;	r4(tmp)
;	r5(tmp)
;	r6(tmp)
;---------------------------------------------
;B1(T)  =  $eaab*(T^3) + $4000*(T^2) + $2aaa*T
;SPVAR =  m_VAR1*BT

.calcB1T	mpush	r11
	mBTcalc	BT,BTL,[m_splineT],$eaab,$4000,$d556,0
	move	r0,[m_VAR1]
	mmul	BT,r0
	to	SPVAR
	add	r0
	mpop	pc
	nop

;---------------------------------------------
;B2(T)  =  $4000*(T^3) - $8000*(T^2) + $c000*T + $7fff
;SPVAR =  m_VAR2*BT + SPVAR

.calcB2T	mpush	r11
	mBTcalc	BT,BTL,[m_splineT],$4000,$8000,$c000,$7fff
	move	r0,[m_VAR2]
	mmul	BT,r0
	add	r0
	to	SPVAR
	add	SPVAR
	mpop	pc
	nop

;---------------------------------------------
;B3(T)  =  $c000*(T^3) - $4000(T^2) + $7fff*T + 0
;SPVAR =  m_VAR3*BT + SPVAR

.calcB3T	mpush	r11
	mBTcalc	BT,BTL,[m_splineT],$c000,$4000,$7fff,$0
	move	r0,[m_VAR3]
	mmul	BT,r0
	add	r0
	to	SPVAR
	add	SPVAR
	mpop	pc
	nop

;---------------------------------------------
;B4(T)  =  $1555*(T^3) - $0(T^2) + $eaab*T + 0
;SPVAR =  m_VAR4*BT + SPVAR

.calcB4T	mpush	r11
	mBTcalc	BT,BTL,[m_splineT],$1555,$0,$eaab,$0
	move	r0,[m_VAR4]
	mmul	BT,r0
	add	r0
	to	SPVAR
	add	SPVAR
	mpop	pc
	nop
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
; calc divB1(T) divB2(T) divB3(T) divB4(T)
;T=signed 16
;
;in	m_splineT
;out	SPDIV
;
;using	r0(tmp)
;	r1(T)
;	r4(tmp)
;	r5(tmp)
;	r6(tmp)
;	1/1=$4000	$c000
;	1/2=$2000	$e000
;	1/3=$1555	$eaab
;	1/6=$0AAA	$f556
;	3/2=$6000	$A000
;	2  =$7fff	$8000
;---------------------------------------------
;divB1(T)  = (-1/2)*(T^2) + T + (1/3)
;SPDIV =  m_VAR1*BT

.calcdivB1T	mpush	r11
	mdivBTcalc	BT,BTL,[m_splineT],$e000,$4000,$eaab

	move	r0,[m_VAR1]
	mmul	BT,r0
	add	r0
	to	SPDIV
	add	r0
	mpop	pc
	nop

;---------------------------------------------
;divB2(T)  =  (3/2)*(T^2) + (-2)*T + (-1/2)
;SPDIV =  m_VAR2*BT + SPDIV

.calcdivB2T	mpush	r11
	mdivBTcalc	BT,BTL,[m_splineT],$6000,$8000,$e000

	move	r0,[m_VAR2]
	mmul	BT,r0

	add	r0
	add	r0
	to	SPDIV
	add	SPDIV
	mpop	pc
	nop

;---------------------------------------------
;divB3(T)  =  (-3/2)*(T^2) + T + 1
;SPDIV =  m_VAR3*BT + SPDIV

.calcdivB3T	mpush	r11
	mdivBTcalc	BT,BTL,[m_splineT],$a000,$4000,$4000

	move	r0,[m_VAR3]
	mmul	BT,r0

	add	r0
	add	r0

	to	SPDIV
	add	SPDIV
	mpop	pc
	nop

;---------------------------------------------
;divB4(T)  =  (1/2)*(T^2) + (-1/6)
;SPDIV =  m_VAR4*BT + SPDIV

.calcdivB4T	mpush	r11
	mdivBTcalc	BT,BTL,[m_splineT],$2000,$0,$f556

	move	r0,[m_VAR4]
	mmul	BT,r0

	add	r0
	add	r0

	to	SPDIV
	add	SPDIV
	mpop	pc
	nop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
; calc div2B1(T) div2B2(T) div2B3(T) div2B4(T)
;T=signed 16
;
;in	m_splineT
;out	SPDIV
;
;using	r0(tmp)
;	r1(T)
;	r4(tmp)
;	r5(tmp)
;	r6(tmp)
;	1=$2000	$e000
;	2=$4000	$c000
;	3=$6000	$a000
;---------------------------------------------
;div2B1(T)  = (-1)*T + 1
;SPDIV2 =  m_VAR1*BT

.calcdiv2B1T	mpush	r11
	mdiv2BTcalc	BT,BTL,[m_splineT],$e000,$2000

	move	r0,[m_VAR1]
	mmul	BT,r0
	add	r0
	add	r0
	to	SPDIV2
	add	r0
	mpop	pc
	nop

;---------------------------------------------
;div2B2(T)  =  3*T + (-2)
;SPDIV2 =  m_VAR2*BT + SPDIV2

.calcdiv2B2T	mpush	r11
	mdiv2BTcalc	BT,BTL,[m_splineT],$6000,$c000

	move	r0,[m_VAR2]
	mmul	BT,r0

	add	r0
	add	r0
	add	r0
	to	SPDIV2
	add	SPDIV2
	mpop	pc
	nop

;---------------------------------------------
;div2B3(T)  =  -3*T + 1
;SPDIV2 =  m_VAR3*BT + SPDIV2

.calcdiv2B3T	mpush	r11
	mdiv2BTcalc	BT,BTL,[m_splineT],$a000,$2000

	move	r0,[m_VAR3]
	mmul	BT,r0

	add	r0
	add	r0
	add	r0
	to	SPDIV2
	add	SPDIV2
	mpop	pc
	nop

;---------------------------------------------
;div2B4(T)  =  T
;SPDIV2 =  m_VAR4*BT + SPDIV2

.calcdiv2B4T	mpush	r11
	mdiv2BTcalc	BT,BTL,[m_splineT],$2000,$0

	move	r0,[m_VAR4]
	mmul	BT,r0

	add	r0
	add	r0
	add	r0
	to	SPDIV2
	add	SPDIV2
	mpop	pc
	nop


	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CALC POS & ROTX OF ROBOT'S LEG
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;mroboLEG0pos
;	in	m_VAR0	: body's worldx
;		m_VAR1	: body's worldy
;		m_VAR2	: body's worldz
;		m_VAR3	: body's roty
;		m_VAR4	: body's rotxoffset(mata no haba)
;	out	m_VAR0	: leg0's worldx
;		m_VAR1	: leg0's worldy
;		m_VAR2	: leg0's worldz
;
;RBXOFS	equr	1
;RBsin	equr	2
;RBcos	equr	3
;
;worldz=(body's worldz)+(body's rotxoffset)*cos(roty)
;	move	RBXOFS,[m_var4]
;	move	RBbodyROTY,[m_var3]





;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CALC POS & ROTX OF ROBOT'S LEG
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; r0    = colour
; r1,r2 = x,y
; r3,r4 = width,height
; r3/r6-r10/r14 unchanged
; ----- returns:
; r1/r2 point to the next row
; r4 returns as 0
; r5   temp(color)

mdrawsolidbox2
;	mcache
;	colour		; set the colour

	moves	r3,r3
	beq	.nobox
;	nop

	move	r5,r0	; color buffer

	colour		; set the colour
	moves	r4,r4
	beq	.nobox
	nop




	mcache



.nextrow



	moves	r12,r3

;*******************************************
; first dot
;	from	r5
;	colour
;	plot
;
;	move	r0,#0
;	colour
;	plot
;
;
;
;	dec	r12
;	beq	.nxtlin
;	nop
;
;	dec	r12
;	beq	.nxtlin
;	nop
;
;
;	nop
;	bmi	.nxtlin
;	nop
;*******************************************


.draw	move	r13,r15


;*******************************************
; final dot?
;	from	r12
;	sub	#1
;	beq	.color
;	nop
;
;*******************************************
	from	r1
	add	r2
	and	#1
	beq	.color
	nop


.clear
	move	r0,#0
	bra	.loop
	nop

.color
	from	r5
.loop	colour
	loop		; draw the bottom line
	plot


.nxtlin	with	r1
	sub	r3

	dec	r4

	bne	.nextrow
	inc	r2


.nobox	jmp	r11
	nop




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CAMERA ga mizu ni haitta tokino SPLASH wo set suru...
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	IFEQ	1
mdrawsplash

	move	r0,#60
	sms	[mspr_x],r0
	sms	[mspr_y],r0
	move	r0,#32
	sm	[m_sprsize],r0
	move	r0,#boost4_spr
	sm	[msprite],r0
	move	r0,#2
	sm	[mspr_pal],r0
	move	r0,#16
	sm	[m_sprxscale],r0
	mcall	musprite_m
	nop

	mpop	pc
	nop

	ENDC
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	stop
;	nop
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	end

