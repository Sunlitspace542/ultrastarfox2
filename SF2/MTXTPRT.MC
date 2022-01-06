******************************************************
**  entry:
**	m_txtdata has ptr to line of text
**	m_x1 = position to print text
**	m_y1 = position to print text
**  exit:
**	m_y1 = last line plotted to
**

fonthgt		equ	12
spacewid	equ	5


rnumchars	equr	10	;vars used by both routines

rtransptr	equr	3	;vars for get line length routine
rwidthptr	equr	4
rtransst	equr	5
rwidthst	equr	6
rlinelen	equr	7
rspare	equr	8

rtransptr	equr	3	;vars used by print routine
rwidthptr	equr	4
rfontptr	equr	5
rwidthval	equr	6
rwidthbak	equr	7
rspare2	equr	8
rxbak	equr	9

msprintstr
	IFEQ	1

	ibt	r0,#fontdata>>16
	romb
	sub	r0
	ramb
	cmode

	lms	r1,[m_x1]
	iwt	r0,#224-50+1
	sub	r1
	sms	[m_textrightclip],r0

	lms	r14,[m_txtdata]
	ibt	r0,#9

	bra	mprintstrin2
	nop

	ENDC

mgprintstr
	IFEQ	1
	ibt	r0,#fontdata>>16
	romb
	sub	r0
	ramb
	cmode

	lms	r1,[m_x1]

	lms	r0,[m_textrightclip]
	sub	r1
	sms	[m_textrightclip],r0

	lm	r0,[m_textcolour]
	lob
	colour

	lms	r14,[m_txtdata]
	inc	r14

	bra	mprintstrin3
	nop

	ENDC
mfprintstr
	IFEQ	1
	ibt	r0,#fontdata>>16
	romb
	sub	r0
	ramb
	cmode

	lms	r1,[m_x1]
	iwt	r0,#224-50
	sub	r1
	sms	[m_textrightclip],r0

	bra	mprintstrin
	nop

	ENDC

mprintclippedstr
	IFEQ	1

	ibt	r0,#fontdata>>16
	romb
	sub	r0
	ramb
	cmode

	bra	mprintstrin
	nop

	ENDC
mprintstr
	IFEQ	1
	ibt	r0,#fontdata>>16
	romb
	sub	r0
	ramb
	cmode

	iwt	r0,#224
	sms	[m_textrightclip],r0

	ENDC
mprintstrin
	IFEQ	1
	lms	r14,[m_txtdata]	;1st byte is colour
	getb
	ENDC
mprintstrin2
	IFEQ	1
	inc	r14
	lob
	colour

	ibt	r0,#-1
	sms	[m_totalchars],r0

	ENDC
mprintstrin3
 
	IFEQ	1
	lms	r2,[m_y1]		;set initial y

	sub	r0
	sms	[m_lastchar],r0

	iwt	rtransptr,#(font0trn-32)&WM
	iwt	rwidthptr,#(font0wid)&WM
	sms	[m_lastspace],r14
	sms	[m_lastwidth],rwidthptr
	sms	[m_lasttrans],rtransptr

.wrap	call	mgetlinelen
	nop

	moves	rnumchars,rnumchars
	mlbeq	.ok

	lms	r1,[m_x1]		;calculate centering

	iwt	rtransptr,#m_transst&WM
	iwt	rwidthptr,#m_widthst&WM
	iwt	rfontptr,#font0fon&WM
	move	rxbak,r1

	mcache
.mainloop
	lms	r0,[m_totalchars]
	moves	r0,r0
	bne	.dontstop
	nop
	ldb	[rtransptr]
	lob
	sms	[m_lastchar],r0
	bra	.ok
	nop
.dontstop
	nop
	dec	r0
	sms	[m_totalchars],r0
	ldb	[rtransptr]
	inc	rtransptr		;r0 has char
	lob
	bne	.charok
	nop
	with	r9
	add	#spacewid
	inc	rwidthptr
	dec	rnumchars
	bra	.mainloop
	nop
.charok
	umult	#12		;*12
	add	r0		;==*24
	from	rfontptr
	to	r14
	add	r0		;r14 has address of font

	to	rwidthval
	ldb	[rwidthptr]
	inc	rwidthptr

	moves	rwidthval,rwidthval
	beq	.nodraw
	nop

	move	rwidthbak,rwidthval	;draw char to screen
	ibt	r12,#fonthgt
	move	r13,r15

	getb
	inc	r14
	getbh
	inc	r14
	move	r1,rxbak
	move	rwidthval,rwidthbak
.xloop	add	r0
	bcc	.noplot
	nop
	plot
	dec	r1
.noplot	dec	rwidthval
	bne	.xloop
	inc	r1
	loop
	inc	r2

.nodraw
	with	r2
	sub	#fonthgt
	with	rxbak
	add	rwidthbak
.zero
	dec	rnumchars
	bne	.mainloop
	nop

	lms	r14,[m_linewrap]
	moves	r14,r14
	beq	.ok
	nop
	with	r2
	add	#fonthgt+1	
	iwt	r15,#.wrap&WM
	nop
.ok
	mrpix
	stop
	nop

	ENDC



;* Copy line of text from ROM to mario ram, storing widths and trans values.
;* Also detect for line wrap etc.
mgetlinelen
	IFEQ	1
	lms	r14,[m_lastspace]
	lms	rtransptr,[m_lasttrans]
	lms	rwidthptr,[m_lastwidth]

	iwt	rtransst,#m_transst&WM
	iwt	rwidthst,#m_widthst&WM
	ibt	rlinelen,#0
	sms	[m_linewrap],rlinelen
	ibt	rnumchars,#0	;num chars to be printed
	mcache
.copy	getb
	lob
	bne	.charok		;char 0 = end of text
	inc	r14
	jmp	r11
	nop
.charok

	lms	rspare,[m_textrightclip]
	with	rspare
	cmp	rlinelen
	bcs	.notwrap
	nop
	lms	r14,[m_lastspace]
	lms	rtransptr,[m_lasttrans]
	lms	rwidthptr,[m_lastwidth]
	lms	rnumchars,[m_lastnumchars]
	lms	rlinelen,[m_lastlen]
	sms	[m_linewrap],r14
	sms	[m_linetrn],rtransptr
	sms	[m_linewid],rwidthptr
	jmp	r11
	nop
.notwrap
	ibt	rspare,#32		;check for space
	cmp	rspare
	bne	.notspace
	nop
	sms	[m_lastspace],r14
	sms	[m_lasttrans],rtransptr
	sms	[m_lastwidth],rwidthptr
	sms	[m_lastnumchars],rnumchars
	sms	[m_lastlen],rlinelen
.notspace
	move	rspare,r14		;get translation value to r0
	from	rtransptr
	to	r14
	add	r0		;r14 has ptr to trn. val.
	getb			;r0 has trans value of char
	stb	[rtransst]		;store trans
	inc	rtransst

	from	rwidthptr
	to	r14
	add	r0		;r14 has ptr to width of char
	getb			;r0 has width of char
	with	rlinelen		;add to total line length
	add	r0
	stb	[rwidthst]		;store width
	inc	rwidthst
	move	r14,rspare		;restore r14

	inc	rnumchars		;numchars=numchars+1
	iwt	r15,#.copy&WM
	nop

	ENDC

;---------------------------------------------------------------------------------------------------------------------
;X1,Y1=position    XP2=VALUE
mshowpercgraph
	IFEQ	1
	ibt	r0,#14
	lms	r1,[m_x1]
	lms	r2,[m_y1]
	iwt	r3,#100+4
	iwt	r4,#8+4
	mcall	mdrawbox
	nop

	ibt	r0,#7
	lms	r1,[m_x1]
	inc	r1
	inc	r1
	lms	r2,[m_y1]
	inc	r2
	inc	r2
	lms	r3,[m_xp2]
	iwt	r4,#8
	mcall	mdrawsolidbox
	nop

	mrpix

	stop
	nop

	ENDC

;calculates the percentage of m_x1 to m_y1 and stops with result in m_x1
mcalcperc
	IFEQ	1
	lms	r0,[m_x1]
	ibt	r2,#100
	to	r4
	mult	r2
	sub	r0
	lms	r6,[m_y1]
	call	mdivu3216
	nop
	sms	[m_x1],r4
	stop
	nop
	ENDC

mkrisdivu3115
	IFEQ	1
	sub	r0
	lms	r4,[m_x1]
	lms	r6,[m_y1]
	call	mdivu3115
	nop
	sms	[m_x1],r4
	stop
	nop

	ENDC

;nearly the same as prtdec, but does an x justify
mprtperc
	IFEQ	1

	lms	r4,[m_z1]

	ibt	r3,#100
	with	r3
	cmp	r4
	beq	.do
	nop
	bge	.ok2
	nop
.do	lms	r0,[m_x1]
	sub	#8
	sms	[m_x1],r0
	bra	.ok
	nop
.ok2
	ibt	r3,#9
	with	r3
	cmp	r4
	blt	.ok
	nop
	lms	r0,[m_x1]
	add	#8
	sms	[m_x1],r0
.ok	mcall	mprtdec
	nop
	stop
	nop

	ENDC

;calls mprtdec and then stops
mprtdecstop
	IFEQ	1

	mcall	mprtdec
	nop
	stop
	nop

	ENDC

;prints a decimal number in m_z1 at m_x1,m_y1 and returns
mprtdec
	IFEQ	1
	move	r10,r11
	sub	r0
	cmode
	ibt	r0,#14
	colour
	mcache

	ibt	r0,#fontdata>>16
	romb

	sub	r0
	lms	r3,[m_z1]
	ibt	r4,#100
	ibt	r5,#0
.lp	with	r3
	sub	r4
	bpl	.lp
	inc	r0
	with	r3
	add	r4
	sms	[m_z1],r3
	dec	r0
	beq	.skip100
	nop
	mcall	mprtnum
	nop
	inc	r5
.skip100
	sub	r0
	lms	r3,[m_z1]
	ibt	r4,#10
.lp2	with	r3
	sub	r4
	bpl	.lp2
	inc	r0
	with	r3
	add	r4
	sms	[m_z1],r3
	dec	r0
	bne	.prt
	nop
	mtest	r5
	beq	.skip10
	nop
.prt	mcall	mprtnum
	nop
.skip10
	sub	r0
	lms	r3,[m_z1]
	ibt	r4,#1
.lp3	dec	r3
	bpl	.lp3
	inc	r0
	dec	r0
	mcall	mprtnum
	nop

	mrpix
	jmp	r10
	nop

	ENDC

mprt2zeros
	IFEQ	1

	sub	r0
	call	mprtnum
	nop
	sub	r0
	call	mprtnum
	nop
	stop
	nop

	ENDC

;print one digit in r0
mprtnum
	IFEQ	1

	miwt	r14,font0fon&WM
	mult	#12
	add	r0
	with	r14
	add	r0		;r14=ptr to font data

	lms	r1,[m_x1]
	lms	r2,[m_y1]

	sub	r0
	ibt	r12,#fonthgt+1
	move	r13,r15
	ibt	r3,#15
.xloop	add	r0
	bcc	.noplot
	nop
	plot
	dec	r1
.noplot	dec	r3
	bne	.xloop
	inc	r1

	getb			;get new byte
	inc	r14
	getbh			;get new byte
	inc	r14

	lms	r1,[m_x1]
	loop
	inc	r2

	with	r1
	add	#8
	sms	[m_x1],r1

	jmp	r11
	nop

	ENDC

mshowteammate
	IFEQ	1

	lms	r0,[m_z1]
	lob
	beq	.dead
	nop

	sub	r0
	cmode

	ibt	r0,#14
	lms	r1,[m_x1]
	lms	r2,[m_y1]
	iwt	r3,#40+4
	iwt	r4,#8+4
	mcall	mdrawbox
	nop

	ibt	r0,#2
	lms	r1,[m_x1]
	inc	r1
	inc	r1
	lms	r2,[m_y1]
	inc	r2
	inc	r2
	lms	r3,[m_z1]
	iwt	r4,#8
	mcall	mdrawsolidbox
	nop

	mrpix
.dead
	stop
	nop

	ENDC

mshowteammate2

	IFEQ	1

	sub	r0
	cmode

	ibt	r0,#14
	lms	r1,[m_x1]
	lms	r2,[m_y1]
	iwt	r3,#40+4
	iwt	r4,#8+4
	mcall	mdrawbox
	nop

	lms	r1,[m_x1]
	inc	r1
	inc	r1
	lms	r2,[m_y1]
	inc	r2
	inc	r2
	lms	r3,[m_z1]
	from	r3
	lob
	beq	.dead
	nop
	ibt	r0,#2
	iwt	r4,#8
	mcall	mdrawsolidbox
	nop

	mrpix
.dead
	stop
	nop

	ENDC







