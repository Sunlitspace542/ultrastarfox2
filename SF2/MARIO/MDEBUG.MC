;                            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ  StarFox II ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                              º
;º  Copyright Argonaut Software Limited, 1993.                            º
;º  All Rights Reserved.                                                  º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Filename:     mdebug.mc                                               º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Description:  Text and number printing routines.                      º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Date:         15/3/94.                                                º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Author:       Dylan Cuthbert                                          º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Modification list:                                                    º
;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
;
;
;
;
; 
; macro for decimal print routine
;

	IFEQ	1
do_digit	MACRO	[unit]
	IFNE	{unit}-1
	iwt	r8,#{unit}
	ibt	r5,#0
.divlp\@
	sub	r8
	bcs	.divlp\@
	inc	r5

	add	r8

	ELSEIF

	move	r5,r0
	inc	r5

	ENDC

	move	r8,r0		; store the number temporarily.

	IFNE	{unit}-1
	with	r10
	add	r5
	dec	r10

	moves	r10,r10
	beq	.noprint\@
	nop
	ENDC

	ibt	r0,#"0"-1
	add	r5

	mcall	mprintascii	; "0"-"9" is actually r5=1-10
	nop
.noprint\@
	move	r0,r8
	ENDM
	ENDC
; 
;--------------------------------------------------------------



;**************************************************************
;**************************************************************
;**************************************************************
;**************************************************************
;**************************************************************
;**************************************************************


;------------------------------------

mprint_mapmessage

	ibt	r8,#mmapmessage_entry>>16
	iwt	r0,#mmapmessage_entry&WM
	ljmp	r8
	nop

	stop
	nop

;------------------------------------
; m_x1,m_y1 = x,y
; m_textcolour = colour
; m_txtdata = value

; r9 unused

mprintdecimal2
mprintdecimal
	ibt	r0,#$70
	ramb

	lms	r1,[m_x1]
	lms	r2,[m_y1]	; get x,y

	lm	r0,[m_textcolour]
	to	r4
	hib
	to	r3
	lob			; set colour reg's up

	lm	r0,[m_txtdata]
	moves	r0,r0
	bpl	.noneg
	nop
	ibt	r0,#"-"
	mcall	mprintascii
	nop
	lm	r0,[m_txtdata]
	mneg	r0
.noneg
	ibt	r10,#0

	do_digit	10000
	do_digit	1000
	do_digit	100
	do_digit	10
	do_digit	1


	iwt	r11,#mboxtext&WM
	jmp	r11
	nop


;------------------------------------
; m_x1,m_y1 = x,y
; m_textcolour = colour
; m_txtdata = value

; r9 unused

mprintbinary
	ibt	r0,#$70
	ramb

	lms	r1,[m_x1]
	lms	r2,[m_y1]	; get x,y

	lm	r0,[m_textcolour]
	to	r4
	hib
	to	r3
	lob			; set colour reg's up

	lm	r0,[m_txtdata]

	ibt	r12,#16		; check 15 bits
	move	r13,r15

	rol
	bcs	.okfound
	nop
	loop
	nop
	inc	r12

.okfound	move	r10,r12
	ror
	move	r9,r0

.oknext	with	r9
	rol
	bcs	.prt1
	nop

	ibt	r0,#"0"
	mcall	mprintascii
	nop
	bra	.con
	nop

.prt1
	ibt	r0,#"1"
	mcall	mprintascii
	nop
.con

	dec	r10
	bne	.oknext
	nop

	ibt	r0,#"b"
	mcall	mprintascii
	nop

	iwt	r11,#mboxtext&WM
	jmp	r11
	nop


;---------------------------------------
mboxtext
	move	r3,r1

	lms	r1,[m_x1]
	sms	[m_x1],r3
	with	r3
	sub	r1
	inc	r3
	dec	r1
	lms	r2,[m_y1]
	dec	r2


	move	r0,r4		; colour
	lms	r4,[m_bigy]
	inc	r4
	inc	r4
;	mcall	mdrawbox
	nop

	rpix

	stop
	nop


;--------------------------------------------------------------

;-----------------------------------
; m_x1,m_y1 = x,y
; m_textcolour = colour
; m_txtdata = value

mprinthex
	ibt	r0,#$70
	ramb

	lms	r1,[m_x1]
	lms	r2,[m_y1]	; get x,y

	lm	r0,[m_textcolour]
	to	r4
	hib
	to	r3
	lob			; set colour reg's up

	ibt	r8,#4
	ibt	r10,#15

; (this isn't written to be fast)
.nxthex
	lm	r0,[m_txtdata]
	rol
	rol
	rol
	rol
	rol
	move	r5,r0
	ror
	sm	[m_txtdata],r0

	with	r5
	and	r10

	ibt	r0,#9
	cmp	r5
	bcc	.doatof
	nop
	ibt	r0,#"0"
	add	r5
	bra	.norm
	nop
.doatof
	ibt	r0,#"A"-10
	add	r5
.norm
	mcall	mprintascii
	nop

	dec	r8
	bne	.nxthex
	nop

	ibt	r0,#"h"
	mcall	mprintascii
	nop
	
	iwt	r11,#mboxtext&WM
	jmp	r11
	nop


;------------------------------------------
; get length of text in pixels
; parameters are the same as for a normal print
; returns m_bigz as length in pixels

mstringlen_l
	iwt	r0,#32767
	sms	[m_visualwidth],r0

	iwt	r10,#m_stack&WM
	mcall	mwordwrap
	nop
	sms	[m_bigz],r2
	stop
	nop


;------------------------------------------
; Calculate maximum length of line to fit
; into screen width m_visualwidth
;
; m_txtdata = address in rom of text string
; m_txtdatabank = bank number of text string
; m_visualwidth = maximum length allowable (in pixels)
; returns r0 as length of printable string
; returns r2 as the length in pixels of the line
; returns r14 as next character to print from on next line

mwordwrap
	ibt	r0,#smallfont>>16
	romb
	ibt	r0,#$70
	ramb

	lms	r14,[m_font]
	mcache

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Get relevant information from the header.
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	inc	r14
	getb
	sms	[m_bigy],r0	; store height of font (used to calculate width of space)

	ibt	r0,#fh_firstentry-1
	to	r14
	add	r14
	to	r6
	getb		; r6 = fh_firstentry
	inc	r14

	to	r7
	getb		; r7 = fh_lastentry
	inc	r14
	inc	r7

	to	r8
	getb		; r8 = fh_spacing
	inc	r14
	
	inc	r14	; skip fh_offset
	inc	r14

	move	r9,r14	; keep base value of r14
	lms	r12,[m_txtdata]
	
	ibt	r0,#-1
	sms	[m_lastspace],r0
	ibt	r13,#0	; set width value

.looparound
	lms	r0,[m_txtdatabank]
	romb		; set font bank

	move	r14,r12
	inc	r12
	getb		; get a character
	moves	r5,r0	; check for zero termination
	bne	.nozero
	nop

	dec	r12

	move	r2,r13		; return pixel length of string in r2
	lms	r13,[m_txtdata]
	from	r12
	sub	r13

	move	r14,r12	; next string pointer set to zero-termination

	jmp	r11
	nop		; exit
.nozero

	ibt	r0,#smallfont>>16
	romb		; set font bank

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; now look up the character in the ascii table.
; r9 points to an ascii table beginning at 'fh_firstentry' and
; ending at 'fh_lastentry'
;
; r3 is corrupted
; r4 is result (width of character)
; r5 is character to look up
; r6,r7 is firstentry,lastentry+1
; r8 is spacing
; r9 is table pointer
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	move	r14,r9

	from	r5
	sub	r6
	bcc	.notdefined
	nop

	with	r5
	cmp	r7
	bcc	.withinr2
	nop
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; illegal character (out of bounds of table) (make it a space)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.notdefined
	ibt	r0,#"#"
	cmp	r5
	bne	.notspecial
	nop
	ibt	r4,#0
	iwt	r15,#.exit&WM
	nop
.notspecial
	lms	r0,[m_bigy]
	lsr
	to	r4
	sub	r8	; subtract the spacing value
	iwt	r15,#.exit&WM
	nop
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; normal character so carry on
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.withinr2

	to	r14
	add	r14
	getb		; get index into width table

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; if entry in ascii look-up table==255 then it should be drawn as a space
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	iwt	r14,#255
	cmp	r14
	beq	.notdefined
	nop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; now look up the width and x-offset of the character in the compacted font
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	add	r0	; *2

	add	r9	; add old value of r14 to index
	add	r7	; + fh_lastentry
	to	r14	; initiate read from width table
	sub	r6	; - fh_firstentry

	inc	r14

	getb		; get encoded width

	lsr
	lsr
	to	r4
	lsr		; r6 = width = startwidth>>11

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; at this point:
; r4 = width, r8 = spacing, r9 = base of tables, r6 = firstentry, r7 = lastentry+1
.exit
	move	r2,r13		; return pixel length of string in r2

	with	r13
	add	r4	; add to max width
	with	r13
	add	r8	; (character spacing)

; exceeded the max width allowable?

	lms	r0,[m_visualwidth]
	cmp	r13
	bcs	.notyet
	nop

	lms	r13,[m_txtdata]
	lms	r1,[m_lastspace]
	inc	r1
	bne	.notminus1
	dec	r1		; check if there hasn't been a space

	move	r1,r12
	dec	r1
	dec	r13		; if no space then print everything so far
.notminus1
	from	r1
	sub	r13		; return r0 as length of line

	inc	r1		; skip the space
	move	r14,r1

; returns r0 as length of line and r14 as pointer to next position to start from
	jmp	r11
	nop

.notyet


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; check for last space passed over
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	ibt	r0,#" "
	cmp	r5
	bne	.nospace
	nop
	dec	r12
	sms	[m_lastspace],r12
	inc	r12

.nospace

	iwt	r15,#.looparound&WM
	nop


;------------------------------------------
; m_txtdata = address in rom of text string
; m_txtdatabank = bank number of text string
; m_x1 = starting x coord
; m_y1 = starting y coord
; m_textcolour = colour  (lo = fg, hi = bg)

mprintstring
	iwt	r10,#m_stack&WM

	ibt	r0,#-1
	sms	[m_z1],r0

	mcall	mprintstringn
	nop

	iwt	r15,#mboxtext&WM
	nop


;------------------------------------------
; m_txtdata = address in rom of text string
; m_txtdatabank = bank number of text string
; m_x1 = starting x coord
; m_y1 = starting y coord
; m_textcolour = colour  (lo = fg, hi = bg)
; m_visualwidth = maximum width of string on screen (pixels)

mprintWWstringn_l
	link	#4
	iwt	r15,#mprintWWstringn_s2&WM
	nop
	lm	r8,[m_rtl+2]	; << return long bank	 >>
	lm	r0,[m_rtl+0]	; << return long address >>
	ljmp	r8
	nop
;------------------------------------------------
mprintWWstring
	link	#4
	iwt	r15,#mprintWWstring_s&WM
	nop
	stop
	nop
;------------------------------------------------
mprintWWstringn
	link	#4
	iwt	r15,#mprintWWstringn_s&WM
	nop
	stop
	nop
;------------------------------------------------

mprintWWstring_s

	iwt	r0,#32767
	sms	[m_z1],r0

;------------------------------------------
; m_txtdata = address in rom of text string
; m_txtdatabank = bank number of text string
; m_x1 = starting x coord
; m_y1 = starting y coord
; m_z1 = length in chars
; m_textcolour = colour  (lo = fg, hi = bg)
; m_visualwidth = maximum width of string on screen (pixels)

mprintWWstringn_s
	ibt	r0,#100
	sm	[m_gyoulimit],r0	; Add Yajima !!
mprintWWstringn_s2
	sm	[m_returnaddr],r11	; Add Yajima !!
	sub	r0			; Add Yajima !!
	sm	[m_gyoucount],r0	; Add Yajima !!

	iwt	r10,#m_stack&WM
	lms	r2,[m_z1]
.tsuginogyou
	mpush	r2

	mcall	mwordwrap
	nop

	moves	r0,r0
	beq	.exit
	nop

	mpop	r2

	with	r2
	sub	r0
	bpl	.notyet

	from	r2
	add	r0	; r0 = old value of r2

	ibt	r2,#0	; zero r2
	
.notyet

	sms	[m_z1],r0

	mpush	r2	; get length

	lms	r0,[m_x1]
	mpush	r0
	mpush	r14

	mcall	mprintstringn
	nop

	mpop	r0
	sms	[m_txtdata],r0

	mpop	r0
	sms	[m_x1],r0

; check for n characters displayed
	mpop	r2
	moves	r2,r2
	beq	.finished
	nop

	lms	r0,[m_bigy]
	lms	r1,[m_y1]
	add	r1
	add	#1			; Change Yajima !! 1995.4.6
	sbk

	lm	r6,[m_gyoulimit]
	lm	r0,[m_gyoucount]
	cmp	r6
	bcs	.exit
	inc	r0
	sbk

	iwt	r15,#.tsuginogyou&WM
	nop
.finished
.exit
	lm	r15,[m_returnaddr]	; Change Yajima !!
	nop				; Change Yajima !!



;------------------------------------------
; m_txtdata = address in rom of text string
; m_txtdatabank = bank number of text string
; m_visualwidth = maximum width of string on screen (pixels)
; returns m_y1 as total height of text (word wrapped so height may contain multiple lines)

mStringHeight
	link	#4
	iwt	r15,#mStringHeight_s&WM
	nop
	stop
	nop

;------------------------------------------------
mStringHeight_l
	link	#4
	iwt	r15,#mStringHeight_s&WM
	nop
	lm	r8,[m_rtl+2]	; << return long bank	 >>
	lm	r0,[m_rtl+0]	; << return long address >>
	ljmp	r8
	nop

;------------------------------------------------
mStringHeight_s
	sm	[m_returnaddr],r11	; Append by H.Yajima 1994/11/22
	iwt	r10,#m_stack&WM
	ibt	r0,#0
	sms	[m_y1],r0
	lms	r0,[m_txtdata]
	mpush	r0
.tsuginogyou
	mcall	mwordwrap
	nop

	moves	r0,r0
	beq	.exit
	nop

	sms	[m_txtdata],r14

	lms	r0,[m_bigy]
	lms	r1,[m_y1]
	add	r1
	add	#2
	sbk

	iwt	r15,#.tsuginogyou&WM
	nop

.exit	mpop	r0
	sms	[m_txtdata],r0

	lm	r15,[m_returnaddr]	; Change Yajima 1994/11/22
	nop				; Change Yajima 1994/11/22


;------------------------------------------
; m_txtdata = address in rom of text string
; m_txtdatabank = bank number of text string
; m_x1 = starting x coord
; m_y1 = starting y coord
; m_z1 = length of string to print (-1 if zero terminated)
; m_textcolour = colour  (lo = fg, hi = bg)

mprintstringn_l
	iwt	r10,#m_stack&WM
	mcalls	mprintstringn
	nop
	sms	[m_x1],r1
	stop
	nop
mprintstringn
	mpush	r11

	ibt	r0,#$70
	ramb

	lms	r1,[m_x1]
	lms	r2,[m_y1]	; get x,y

	lm	r0,[m_textcolour]
	to	r4
	hib
	to	r3
	lob			; set colour reg's up

.nxtchar
	lm	r0,[m_txtdatabank]
	lob
	romb	; set rom bank
	lm	r14,[m_txtdata]	; begin fetch of char num

	getb

	moves	r0,r0
	beq	.exit		; if zero, then exit
	nop

	inc	r14
	sm	[m_txtdata],r14

	mcalls	mprintascii
	nop

	lms	r0,[m_z1]
	dec	r0
	sbk

	bne	.nxtchar
	nop
	

.exit
	mpop	r15
	nop

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;³   MPRINTASCII   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
; r1=x
; r2=y
; r3=fg colour
; r4=bg colour
; r5=char  r0 = ascii char (if mprintascii is called)

; uses everything except r10
; returns r1,r2 pointing to next character position
; it also uses the stack starting at m_stack+16&WM
; due to the fact some routines that call this use the stack
; and some don't
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

mprintascii
	move	r5,r0

	move	r0,r10
	iwt	r10,#(m_stack+16)&WM
	mpush	r0
	mpush	r6
	mpush	r7
	mpush	r8
	mpush	r9

	ibt	r0,#smallfont>>16
	romb
	ibt	r0,#$70
	ramb

	lms	r14,[m_font]

.cachelimit
	mcache

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; first read the header
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	getb		; fh_width
	inc	r14
	sms	[m_bigx],r0

	getb		; fh_height
	inc	r14
	sms	[m_bigy],r0

	to	r6
	getb		; fh_firstentry
	inc	r14

	to	r7
	getb		; fh_lastentry
	inc	r14
	inc	r7

	to	r8
	getb		; fh_spacing
	inc	r14

	getb		; fh_offset
	inc	r14
	getbh
	inc	r14
	add	r14
	ibt	r9,#fh_offset+2
	sub	r9
	sms	[m_pntptr],r0	; store address of bitmap data

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; now look up the character in the ascii table.
; r14 points to an ascii table beginning at 'fh_firstentry' and
; ending at 'fh_lastentry'
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	from	r5
	sub	r6
	bcc	.notdefined
	nop

	with	r5
	cmp	r7
	bcc	.withinr2
	nop
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; illegal character (out of bounds of table) (make it a space)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.notdefined
	ibt	r6,#0		; char width = 0
	ibt	r0,#""		; check for no space
	cmp	r5
	bne	.nck1
	nop
	dec	r1
	ibt	r6,#-1		; char width = 0
	iwt	r15,#.nodo&WM
	nop
.nck1
	ibt	r0,#"#"
	cmp	r5
	beq	.special	; if a special character then just space
	nop
	lms	r0,[m_bigy]	; character height
	to	r8
	lsr			; r8 = character spacing = charheight/2
.special
	iwt	r15,#.entry&WM
	nop
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; normal character so carry on
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.withinr2
	move	r5,r14	; keep r14 for later

	to	r14
	add	r14
	getb		; get index into width table

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; if entry in ascii look-up table==255 then it should be drawn as a space
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	iwt	r14,#255
	cmp	r14
	beq	.notdefined
	nop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; now look up the width and x-offset of the character in the compacted font
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	add	r0	; *2

	add	r5	; add old value of r14 to index
	add	r7	; + fh_lastentry
	to	r14	; initiate read from width table
	sub	r6	; - fh_firstentry

	to	r7
	getb		; r7 = x offset into compacted font lo byte
	inc	r14

	with	r7
	getbh		; get encoded width and start x offset hi byte

	from	r7
	hib
	lsr
	lsr
	to	r6
	lsr		; r6 = width = startwidth>>11

	iwt	r0,#$7ff	; mask
	lms	r14,[m_pntptr]
	and	r7
	lsr
	lsr
	lsr		; divide by 8 to get offset in bytes
	to	r14
	add	r14	; add x offset in bytes

	with	r7
	and	#7	; get r7 = offset in pixels

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; at this point:
; r14 = address of first byte of character data
; r1  = x
; r2  = y
; r3 = fg
; r4 = bg
; r6 = width
; r7 = x shift of first pixel to begin drawing at
; r8 = size of space between chars
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.entry
	sub	r0
	cmode

	sms	[m_y1],r2

	lms	r0,[m_bigy]
	mpush	r0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; begin outer loop (charheight)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.oloop
	moves	r0,r6	; if r6 (charwidth) == 0 then just do spacing
	beq	.dospacing
	nop
	bmi	.nospacing
	nop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; get first byte of character data
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	move	r9,r14
	getbh		; get data=r0
	inc	r14

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; is character data at an offset within the byte?
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	moves	r12,r7
	beq	.noshift	; no shift required
	nop
	move	r13,r15
	loop
	rol		; skip bits from other characters

.noshift
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; calculate length until next byte has to be read
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	ibt	r5,#9
	with	r5
	sub	r7	; 8 - xoffset

	move	r12,r6	; inner loop count
	move	r13,r15
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; inner loop
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.iloop
	dec	r5
	beq	.fetch
.backin
	rol		; get next bit in c
	bcs	.plotit
	from	r3
	from	r4
	
.plotit
	colour		; set fg/bg

	loop
	plot

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; add space after the data
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.dospacing
	from	r4
	colour		; set bg colour

	move	r12,r8
	move	r13,r15

	loop
	plot

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; restore x to original x coord
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	with	r1
	sub	r6	; restore x
	with	r1
	sub	r8
.nospacing
	inc	r2	; next row down

	lms	r14,[m_bigx]
	with	r14
	add	r9		; add width of compacted font

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; loop back round for next row in char
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	lms	r0,[m_bigy]	; height of char
	dec	r0
	bne	.oloop
	sbk

	mpop	r0
	sms	[m_bigy],r0	; restore the font height

	lms	r2,[m_y1] ; adjust y


	with	r1
	add	r6	; add width of char

	with	r1
	add	r8	; add spacing between chars
.nodo

	rpix		; flush

	mpop	r9
	mpop	r8
	mpop	r7
	mpop	r6
	mpop	r10	; restore the stack pointer

	jmp	r11
	nop

	move	r15,r11
	nop

.fetch	getbh
	inc	r14
	ibt	r5,#8
	bra	.backin
	nop

	IFGE	(*-.cachelimit)-512
	error	<printascii exceeds cache limit>
	ENDC

;--------------------------
mdb_tlx	=	4
mdb_tly	=	24+blockmap_numblocks
mdrawblockmap
	IFNE	debuginfo

	sub	r0
	romb
	ramb
	cmode

	mcache

	ibt	r1,#mdb_tlx
	iwt	r2,#mdb_tly

	ibt	r3,#9
	ibt	r4,#12

	iwt	r9,#m_drawlist&WM

	iwt	r7,#blockmap_numblocks
.yloop
	ibt	r8,#blockmap_numblocks/16

.xloop
	ldw	[r9]
	inc	r9
	inc	r9

	iwt	r12,#16
	move	r13,r15
.bitloop
	ror
	bcc	.cango
	from	r3
	from	r4
.cango
	colour

	loop
	plot

	dec	r8
	bne	.xloop
	nop

	ibt	r1,#4
	dec	r2
	dec	r7
	bne	.yloop
	nop

	ibt	r0,#3
	colour

	lms	r1,[m_x1]
	lms	r2,[m_z1]

	ibt	r0,#mdb_tlx
	to	r1
	add	r1

	iwt	r0,#mdb_tly
	to	r2
	sub	r2

	plot

	rpix

	stop
	nop

	ENDC
;--------------------------

mtestit


