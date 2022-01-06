
;**************************************************************
;
; mprintdecimal2	( make 20 bit decimal data )
;		  0 ... +0fffff(1048575) 
;
;	1994.9.2	apend by H.Yajima
;
;**************************************************************
; input	r6 = divisor
;	r5 = HIGH dividend
;	r4 = LOW  dividend
;--------------------------------------------------------------
; output	r6 = divisor
;	r5 = HIGH	
;	r4 = LOW
;	r0 = REST
;--------------------------------------------------------------
;	r9  = counter
;	r10 = pointer
;--------------------------------------------------------------

Mdivyajima	macro

	iwt	r13,#.\@ploop&0ffffh	; return address

;-------------------------------------
.\@p2	sub	r0			; clear 0

	with	r4
	rol				; <<<<< data low >>>>>
	with	r5
	rol				; <<<<< data high >>>>>

	ibt	r12,#32			; loopcount = 32
;-------------------------------------
.\@ploop
	rol
	cmp	r6
	bcc	.\@p1
	nop
	sbc	r6
.\@p1	with	r4		; <<<<< LOW >>>>>
	rol
	with	r5		; <<<<< HIGH >>>>>
	rol
	loop
	nop

;-------------------------------------
				; <<<<< r0 = rest >>>>>
	stb	[r10]
	dec	r9
	bne	.\@p2
	inc	r10

	endm

;--------------------------------------------------------------
mprintdecimal2
;--------------------------------------------------------------

	ibt	r0,#$70
	ramb

	lm	r4,[m_txtdata]	; low  (8000,ffff)
	moves	r0,r4
	bmi	.entry
	nop
	lm	r5,[m_z1]	; high (10000,fffff)
	moves	r0,r5
	bne	.entry
	nop
	iwt	r15,#mprintdecimal&0ffffh
	nop
.entry

	lm	r5,[m_z1]

;------------------------------------------------
	iwt	r10,#m_yajima&0ffffh	; <- workRAM poitner
	ibt	r9,#6			; <- counter
	ibt	r6,#10			; <- decimal convert
	mcache
;------------------------------------------------

	Mdivyajima

;------------------------------------------------

	lms	r1,[m_x1]
	lms	r2,[m_y1]		 ; get x,y
	lm	r0,[m_textcolour]
	to	r4
	hib
	to	r3
	lob				 ; set colour reg's up

	iwt	r10,#(m_yajima+5)&0ffffh ; <- workRAM poitner
	ibt	r9,#6			 ; <- counter
	ibt	r6,#"0"

;------------------------------------------------

.loop1	ldb	[r10]
	moves	r0,r0
	bne	.next
	dec	r10
	dec	r9
	bne	.loop1
	nop
	bra	.exit		; (r9=0)->exit
	nop

.loop2	ldb	[r10]
	dec	r10
.next	add	r6
	mcall	mprintascii	; "0"-"9" is actually r5=1-10
	nop
	dec	r9
	bne	.loop2
	nop

;------------------------------------------------
.exit	iwt	r11,#mboxtext&WM
	jmp	r11
	nop			; exit

