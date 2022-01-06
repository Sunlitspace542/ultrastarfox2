;
; File:	MDRAWP.MC
;
; Use: 	Draw graphics
; Code:	MARIO
; By:  	Peter Warnes
;      	Copyright 1991
;

; Routines

; mscanstart	polygon drawer
; mtscanstart	texture mapped polygon drawer



polytesting	equ	0



;************************************************

mpoly	macro

	miwt	r1,m_polybuf

	ibt	r0,#\1
	mstwi	r1
	ibt	r0,#\2
	mstwi	r1

	ibt	r0,#\3
	mstwi	r1
	ibt	r0,#\4
	mstwi	r1

	ibt	r0,#\5
	mstwi	r1
	ibt	r0,#\6
	mstwi	r1

	ibt	r0,#\7
	mstwi	r1
	ibt	r0,#\8
	mstwi	r1

	endm

mtpoly	macro

	ibt	r0,#\1
	mstwi	r1
	ibt	r0,#\2
	mstwi	r1

	ibt	r0,#\3
	mstwi	r1
	ibt	r0,#\4
	mstwi	r1

	ibt	r0,#\5
	mstwi	r1
	ibt	r0,#\6
	mstwi	r1

	ibt	r0,#\7
	mstwi	r1
	ibt	r0,#\8
	mstwi	r1

	endm




;------------------------------------------------



; IFEQ	mpolylist			; IF mpolylist=0
;
;
;;	ifeq	0
;
;; draw texture mapped polygon
;
;; 0
;; 1  rx
;; 2  ry
;; 3  rdy2
;; 4  tr1
;; 5  tr2
;; 6  rcnt
;; 7  rx1
;; 8  rx1inc
;; 9  rx2
;; 10 rx2inc
;; 11 rdy1
;; 12 loop cnt
;; 13 loop label
;; 14
;
;
;rx	equr	1
;ry	equr	2
;rdy2	equr	3
;rtr1	equr	4
;rtr2	equr	5
;rcnt	equr	6
;rx1	equr	9
;rx1inc	equr	7
;rx2	equr	10
;rx2inc	equr	8
;rdy1	equr	11
;rdx	equr	12
;
;rymax	equr	8
;rnpts	equr	3
;rtr	equr	6
;
;rxp1	equr	0
;rxp1inc	equr	0
;ryp1	equr	0
;ryp1inc	equr	0
;rxp2	equr	0
;rxp2inc	equr	0
;ryp2	equr	0
;ryp2inc	equr	0
;
;
;	ifeq	1
;;testcode
;mtesttscanstart
;	ibt	r0,#15
;	colour
;
;;	mpoly	80,48,48,80,80,112,112,80
;
;	miwt	r1,m_polybuf
;;	mtpoly	80,48,0,0,48,80,0,64
;;	mtpoly	80,112,64,64,112,80,64,0
;
;;	mtpoly	80,48,0,0,48,80,0,127
;;	mtpoly	80,112,127,127,112,80,127,0
;
;;	mtpoly	80,48,0,0,48,80,64,0
;;	mtpoly	80,112,64,64,112,80,0,64
;
;;	mtpoly	80,16,0,0,32,80,0,64
;;	mtpoly	80,112,64,64,138,80,64,0
;
;;	mtpoly	70,14,0,0,62,64,0,64
;;	mtpoly	82,82,64,64,162,25,64,0
;;	mtpoly	162,25,64,0,70,14,0,0
;;	mtpoly	62,64,0,64,82,82,64,64
;;	mtpoly	82,82,64,64,162,25,64,0
;;	mtpoly	70,14,0,0,62,64,0,64
;;	mtpoly	62,64,0,64,82,82,64,64
;;	mtpoly	162,25,64,0,70,14,0,0
;	mtpoly	62,64,64,64,82,82,64,0
;	mtpoly	162,25,0,0,70,14,0,64
;
;;	mtpoly	112,14,0,0,62,64,0,32
;;	mtpoly	112,114,32,32,162,50,32,0
;
;
;;	mpoly	100,92,92,100,100,108,108,100
;;	mpoly	108,100,100,92,92,100,100,108
;
;;	mpoly	100,108,108,100,100,92,92,100
;
;;	mpoly	92,100,100,108,108,100,100,92
;
;
;
;;	mpoly	0,0,0,127,127,127,127,0
;;	mpoly	0,0,0,127,128,127,128,0
;;	mpoly	16,0,0,127,176,126,160,1
;;	mpoly	0,0,0,127,223,127,223,0
;;	mpoly	4,4,0,127,200,120,220,5
;
;	ibt	r0,#4
;	endc
;
;
;
;	ifeq	0
;
;; draw texture mapped polygon
;
;mdrawtpoly
;
;mtscanstart
;	dec	r0
;	dec	r0
;	mlbeq	mline
;
;	inc	r0
;	inc	r0
;
;	move	r12,r0		; init loop count
;	add	r0
;	add	r0
;	add	r0
;	move	rnpts,r0	; npts << 3
;
;	miwt	rtr1,m_polybuf	; tr1 = m_polybuf
;	from	rtr1
;	to	rtr2
;	add	r0		; tr2 = tr1 + (npts << 3) 
;
;
;	ifne	mario_stats3d
;	mincm	m_polys_drawn
;	endc
;
;
;	miwt	ry,1023		; init ymin
;	ibt	rymax,#0		; init ymax
;
;;	mcache
;
;	move	r13,pc		; init loop label
;
;; find ymin and copy pnts
;;----------------------------
;;Carl woz here
;	IFNE	1
;;----------------------------
;	ldb	[rtr1]		; copy x
;	inc	rtr1
;	inc	rtr1
;	stb	[rtr2]
;	inc	rtr2
;	inc	rtr2
;
;	ldb	[rtr1]		; copy y
;	stb	[rtr2]
;
;	cmp	ry		; find ymin
;	bpl	.1
;	nop
;	move	ry,r0
;	move	rtr,rtr1
;.1
;
;	cmp	rymax		; find ymax
;	bmi	.2
;	nop
;	move	rymax,r0
;.2
;
;	inc	rtr1
;	inc	rtr1
;	inc	rtr2
;	inc	rtr2
;
;	sub	r0
;	inc	rtr1
;	ldb	[rtr1]		; copy xp
;	dec	rtr1
;	stb	[rtr1]
;	inc	rtr1
;	inc	rtr1
;	stb	[rtr2]
;	inc	rtr2
;	inc	rtr2
;
;	inc	rtr1
;	ldb	[rtr1]		; copy yp
;	dec	rtr1
;	stb	[rtr1]
;	inc	rtr1
;	inc	rtr1
;	stb	[rtr2]
;	inc	rtr2
;;----------------------------
;	ELSEIF
;;----------------------------
;	ldb	[rtr1]		; copy x
;	inc	rtr1
;	inc	rtr1
;	stb	[rtr2]
;	inc	rtr2
;	inc	rtr2
;
;	ldb	[rtr1]		; copy y
;	stb	[rtr2]
;
;	cmp	ry		; find ymin
;	bpl	.1
;	nop
;	move	ry,r0
;	move	rtr,rtr1
;.1
;
;	cmp	rymax		; find ymax
;	bmi	.2
;	nop
;	move	rymax,r0
;.2
;
;	inc	rtr1
;	inc	rtr1
;	inc	rtr2
;	inc	rtr2
;
;	ldb	[rtr1]		; copy xp
;	inc	rtr1
;	inc	rtr1
;	stb	[rtr2]
;	inc	rtr2
;	inc	rtr2
;
;	ldb	[rtr1]		; copy yp
;	inc	rtr1
;	inc	rtr1
;	stb	[rtr2]
;	inc	rtr2
;
;;----------------------------
;	ENDC
;
;	loop			; next vertex
;	inc	rtr2
;
;
;; init scan converter
;
;	from	ry
;	sub	rymax
;	mlbeq	mtscanhline
;
;	move	rtr1,rtr	; tr1 = tr - 2
;	dec	rtr1
;	dec	rtr1
;
;	from	rtr1
;	to	rtr2
;	add	rnpts		; tr2 = tr1 + npts
;
;	ldb	[rtr1]
;	inc	rtr1
;	inc	rtr1
;	to	rx1
;	swap			; x1
;	move	rx2,rx1		; x2
;
;;	to	ry		; already there
;;	ldb	[rtr1]
;	inc	rtr1
;	inc	rtr1		; and skip y
;
;	ldb	[rtr1]		; xp
;	swap
;	sms	[m_xp1],r0
;	sms	[m_xp2],r0
;	inc	rtr1
;	inc	rtr1
;
;	ldb	[rtr1]		; yp
;	swap
;	sms	[m_yp1],r0
;	sms	[m_yp2],r0
;	inc	rtr1
;	inc	rtr1
;
;	sms	[m_tr1],rtr1
;	sms	[m_tr2],rtr2
;
;	ibt	rdy1,#0		; init both
;	ibt	rdy2,#0
;
;	lms	r0,[m_tcmodecol]
;	colour
;	swap
;
;	cmode
;
;	ifeq	1
;	ibt	r0,#$20		; texture palette number
;	colour
;	ibt	r0,#8		; 256 colour mode, 16 colour texture
;	cmode
;	endc
;
;	mcache
;
;	miwt	pc,mtnewx1	; jump to init tracers
;	nop
;
;
;; scan converter loop
;
;; x1
;; x1inc
;; x2
;; x2inc
;; ycnt
;
;; xp1
;; xp1inc
;; xp2
;; xp2inc
;; yp1
;; yp1inc
;; yp2
;; yp2inc
;
;; x xlen xp yp xpi ypi
;
;rx	equr	1
;ry	equr	2
;rmask	equr	3
;rspdata	equr	4
;rxpi	equr	5
;rypi	equr	6
;ryp	equr	7
;rxp	equr	8
;
;;rt	equr	4
;;rshift	equr	10
;
;
;
;mthlines
;	sms	[m_x1inc],rx1inc
;	sms	[m_x2inc],rx2inc
;
;	ifeq	0
;	from	rdy1
;	sub	rdy2
;	bmi	.1
;	nop
;
;	sms	[m_dy1],r0
;	from	rdy2
;	swap
;	to	ry
;	or	ry
;	sub	r0
;	sms	[m_dy2],r0
;	bra	.2
;	nop
;
;.1
;	from	rdy2
;	sub	rdy1
;	sms	[m_dy2],r0
;	from	rdy1
;	swap
;	to	ry
;	or	ry
;	sub	r0
;	sms	[m_dy1],r0
;.2	
;	endc
;
;thlines1	
;;	sms	[m_x1],rx1
;;	sms	[m_x1inc],rx1inc
;;	sms	[m_x2],rx2
;;	sms	[m_x2inc],rx2inc
;;	sms	[m_dy1],rdy1
;;	sms	[m_dy2],rdy2
;
;	from	rx1		; x = (rx1)>>8
;	to	rx
;	hib
;
;	from	rx2
;	hib
;	to	r12
;	sub	rx		; r12 = x - (rx2>>8)
;	bcs	.1		; if (rx2>>8) < (rx1>>8) no hline
;	inc	r12		; one for luck
;	ibt	r12,#1
;.1
;
;	ifeq	1
;	ibt	r0,#15		; plot endpoints of hline
;	colour
;	plot
;	move	r0,rx
;	with	rx
;	add	r12
;	plot
;	move	rx,r0
;	endc
;
;	miwt	r0,reciptab16s	; romtab
;	add	r12
;	to	r14
;	add	r12		; r14 = reciptab16s + dx*2
;
;	to	r6
;	getb
;	inc	r14
;	with	r6
;	getbh			; r6 = 32768 / dx
;
;	lms	r0,[m_xp2inc]
;	lms	r4,[m_xp2]
;	add	r4
;	sbk			; xp2 += xp2inc
;
;	lms	rxp,[m_xp1]
;	from	r4
;	sub	rxp
;
;	fmult			; rxpi = (xp2-xp1)/dx
;	to	rxpi
;	rol
;
;	lms	r0,[m_xp1inc]
;	add	rxp
;	sms	[m_xp1],r0	; xp1 += xp1inc
;
;	ifeq	0
;	lms	r0,[m_yp2inc]
;	lms	r4,[m_yp2]
;	add	r4
;	sbk			; yp2 += yp2inc
;
;	lms	ryp,[m_yp1]
;	from	r4
;	sub	ryp
;
;	fmult			; rypi = (yp2-yp1)/dx
;	to	rypi
;	rol
;
;	lms	r0,[m_yp1inc]
;	add	ryp
;	sms	[m_yp1],r0	; yp1 += yp1inc
;
;	ifeq	0
;	lms	rspdata,[m_sprxscroll]
;	with	rxp
;	add	rspdata
;
;	lms	rspdata,[m_spryscroll]
;	with	ryp
;	add	rspdata
;	endc
;
;	lms	r0,[m_sprbank]
;	romb			; set sprite ROM bank and data addr
;	lms	rspdata,[m_sprdata]
;	lms	rmask,[m_sprmask]
;	endc
;
;cthlines
;
;	lms	r0,[m_texturemap]
;	inc	r0
;	bne	.1
;	nop
;
;	ifeq	0	; texture map
;	move	r13,pc
;
;	merge		; r0 = (ryp & $ff00) + (rxp & $ff00)>>8
;	and	rmask
;	to	r14
;	add	rspdata
;	with	ryp
;	add	rypi
;	with	rxp
;	add	rxpi
;	getc
;
;	ifne	0
;	getb
;	ldb	[r0]
;	colour
;	endc
;
;	loop
;	plot		; = 11	( uses 10 regs )
;
;	mlbra	cthlinesrts
;	endc
;
;.1
;	ifeq	0	; smooth shading with rnd
;	ibt	r0,#mrndtab>>16
;	romb
;	from	ry
;	add	ry
;	add	r0
;	mult	#13
;	add	ry
;	add	rx
;	lob
;	miwt	r14,mrndtab&$ffff
;	to	r14
;	add	r14
;	move	r13,pc
;
;	getb
;	inc	r14
;	add	rxp
;	hib
;	colour
;	with	rxp
;	add	rxpi
;	loop
;	plot
;	endc
;
;
;;	ifeq	1	; dithering smooth shading with rnd
;;	ibt	r0,#mrndtab>>16
;;	romb
;;	from	ry
;;	add	ry
;;	add	r0
;;	mult	#13
;;	add	ry
;;	add	rx
;;	lob
;;	miwt	r14,mrndtab&$ffff
;;	to	r14
;;	add	r14
;;
;;	ifeq	1
;;	from	r12
;;	lsr
;;	bcc	.3
;;	nop
;;	beq	.0
;;	nop
;;.3
;;	with	rxpi
;;	add	rxpi
;;	endc
;;	
;;	move	r13,pc
;;
;;	getb
;;	inc	r14
;;	add	rxp
;;	hib
;;	colour
;;	with	rxp
;;	add	rxpi
;;	from	r1
;;	xor	r2
;;	lsr
;;	bcs	.2
;;	inc	r1
;;	dec	r1
;;	plot
;;.2
;;	loop
;;	nop
;;	endc
;
;
;;	ifeq	1	; smooth shading
;;	move	r0,rxp
;;	move	r13,pc
;;
;;	swap
;;	colour
;;	swap
;;	add	rxpi
;;	loop
;;	plot
;;	endc
;;
;;
;
;
;cthlinesrts
;	sub	r0
;	romb
;
;;	lms	rx1,[m_x1]
;	lms	rx1inc,[m_x1inc]
;;	lms	rx2,[m_x2]
;	lms	rx2inc,[m_x2inc]
;;	lms	rdy1,[m_dy1]
;;	lms	rdy2,[m_dy2]
;
;	with	rx1		; rx1+=rx1inc
;	add	rx1inc
;
;	bpl	.3		; *** temp hack ***
;	nop
;	miwt	r0,$0800
;	add	rx1
;	bmi	.3
;	nop
;	ibt	rx1,#0
;.3
;
;	with	rx2		; rx2+=rx2inc
;	add	rx2inc
;
;	bpl	.2		; *** temp hack ***
;	nop
;	miwt	r0,$0800
;	add	rx2
;	bmi	.2
;	nop
;	ibt	rx2,#0
;.2
;
;	ifeq	0
;	inc	ry
;
;	from	ry
;	swap
;	dec	r0
;	to	ry
;	swap
;
;	from	ry
;	hib
;	mlbne	thlines1	; *** change ***
;;	nop
;
;	lms	rdy1,[m_dy1]
;	lms	rdy2,[m_dy2]
;	endc
;
;	ifeq	1
;	dec	rdy1		; dy1-=1
;	dec	rdy2		; dy2-=1
;	from	rdy1
;	and	rdy2
;	beq	.1
;	inc	ry		; inc y
;	miwt	pc,thlines1	; loop if (dy1 or dy2) >= 0
;	nop
;.1
;	endc
;
;
;
;; New x1
;
;mtnewx1
;
;htscansize	=	mtnewx1-mthlines
;;	?htscansize
;
;	moves	r0,rdy1
;	mlbne	mtnewx2
;
;;	with	rx1		; x1 = x1 >> 8
;;	hib
;
;	ibt	r0,#127
;	add	rx1
;	to	rx1		; x1 = x1 >> 8
;	hib
;
;	lms	r0,[m_xp1]
;	hib
;	sbk
;	lms	r0,[m_yp1]
;	hib
;	sbk
;
;	lms	rtr,[m_tr1]
;mtnewx11
;	move	rdx,rx1		; dx = x1
;
;	lms	r0,[m_xp1]
;	sms	[m_dxp1],r0
;	lms	r0,[m_yp1]
;	sms	[m_dyp1],r0
;
;	to	rx1
;	ldb	[rtr]		; x1
;	inc	rtr
;	inc	rtr
;
;	to	r4
;	ldb	[rtr]		; y1
;	inc	rtr
;	inc	rtr
;
;	ldb	[rtr]		; xp1
;	sms	[m_xp1],r0
;	inc	rtr
;	inc	rtr
;
;	ldb	[rtr]		; yp1
;	sms	[m_yp1],r0
;	inc	rtr
;	inc	rtr
;
;	from	r4
;	to	rdy1
;	sub	ry		; dy1 = y1 - y
;	beq	mtnewx11	; if dy1=0 then get next vertex
;	nop
;
;	mlbmi	mtscanexit	; if dy1<0 then exit
;
;	sms	[m_tr1],rtr
;
;	miwt	r0,reciptab16s
;	add	rdy1
;	to	r14
;	add	rdy1		; r14 = reciptab + dy1 * 2
;
;	to	r6
;	getb
;	inc	r14
;	with	r6
;	getbh			; r6 = 32768 / dy1
;
;	from	rx1
;	sub	rdx		; r0 = (x1 - dx)
;;	swap
;
;; x1inc = (r6 * r0) << 1
;
;	from	rdx		; x1 = dx
;	to	rx1
;	swap
;
;	lmult
;	with	r4
;	add	r4
;	rol			; x1inc = (r6 * r0) << 1
;
;	lob
;	swap
;	with	r4
;	hib
;	to	rx1inc
;	or	r4
;
;
;;	ifeq	1
;;	fmult
;;	to	rx1inc
;;	rol
;;
;;	from	rdx		; x1 = dx
;;	to	rx1
;;	swap
;;	endc
;
;
;
;	lms	r0,[m_xp1]
;	lms	r1,[m_dxp1]
;	sub	r1
;	lob
;	swap
;
;; xp1inc = (r6 * r0) << 1
;
;	fmult
;	rol
;	sms	[m_xp1inc],r0
;
;	lms	r0,[m_dxp1]
;	swap
;	sms	[m_xp1],r0
;
;
;	lms	r0,[m_yp1]
;	lms	r1,[m_dyp1]
;	sub	r1
;	lob
;	swap
;
;; yp1inc = (r6 * r0) << 1
;
;	fmult
;	rol
;	sms	[m_yp1inc],r0
;
;	lms	r0,[m_dyp1]
;	swap
;	sms	[m_yp1],r0
;
;
;
;; New x2
;
;mtnewx2
;	moves	r0,rdy2
;	mlbne	mthlines
;
;;	with	rx2		; x2 = x2 >> 8
;;	hib
;
;	ibt	r0,#127
;	add	rx2
;	to	rx2		; x2 = x2 >> 8
;	hib
;
;	lms	r0,[m_xp2]
;	hib
;	sbk
;	lms	r0,[m_yp2]
;	hib
;	sbk
;
;	lms	rtr,[m_tr2]
;mtnewx21
;	move	rdx,rx2		; dx = x2
;
;	lms	r0,[m_xp2]
;	sms	[m_dxp2],r0
;	lms	r0,[m_yp2]
;	sms	[m_dyp2],r0
;
;	dec	rtr
;	dec	rtr
;	ldb	[rtr]		; yp2
;	sms	[m_yp2],r0
;
;	dec	rtr
;	dec	rtr
;	ldb	[rtr]		; xp2
;	sms	[m_xp2],r0
;
;	dec	rtr
;	dec	rtr
;	ldb	[rtr]		; y2
;
;	dec	rtr
;	dec	rtr
;	to	rx2
;	ldb	[rtr]		; x2
;
;	to	rdy2
;	sub	ry		; dy2 = y2 - y
;	beq	mtnewx21	; if dy2=0 then get next vertex
;	nop
;
;	mlbmi	mtscanexit     	; if dy2<0 then exit
;
;	sms	[m_tr2],rtr
;
;	miwt	r0,reciptab16s
;	add	rdy2
;	to	r14
;	add	rdy2		; r14 = reciptab + dy2
;
;	to	r6
;	getb
;	inc	r14
;	with	r6
;	getbh			; r6 = 32768 / dy2
;
;	from	rx2
;	sub	rdx		; r0 = (x2 - dx)
;;	swap
;
;; x2inc = (r6 * r0) << 1
;
;	from	rdx		; x2 = dx
;	to	rx2
;	swap
;
;	lmult
;	with	r4
;	add	r4
;	rol			; x2inc = (r6 * r0) << 1
;
;	lob
;	swap
;	with	r4
;	hib
;	to	rx2inc
;	or	r4
;
;
;;	ifeq	1
;;	fmult
;;	to	rx2inc
;;	rol
;;
;;	from	rdx		; x2 = dx
;;	to	rx2
;;	swap
;;	endc
;;
;;
;
;	lms	r0,[m_xp2]
;	lms	r1,[m_dxp2]
;	sub	r1
;	lob
;	swap
;
;; xp2inc = (r6 * r0) << 1
;
;	fmult
;	rol
;	sms	[m_xp2inc],r0
;
;	lms	r0,[m_dxp2]
;	swap
;	sms	[m_xp2],r0
;
;
;	lms	r0,[m_yp2]
;	lms	r1,[m_dyp2]
;	sub	r1
;	lob
;	swap
;
;; yp2inc = (r6 * r0) << 1
;
;	fmult
;	rol
;	sms	[m_yp2inc],r0
;
;	lms	r0,[m_dyp2]
;	swap
;	sms	[m_yp2],r0
;
;
;	miwt	pc,mthlines
;	nop
;
;
;mtscanhline
;mtscanexit
;	mlbra	mfacelabel
;
;;	stop
;
;tscansize	=	mtscanexit-mtscanstart
;;	?tscansize
;	endc
;
; ENDC					; IF mpolylist=0
;
;
;

;************************************************




 IFNE	mpolylist			; IF mpolylist=1


;	ifeq	0

; draw texture mapped polygon

; 0
; 1  rx
; 2  ry
; 3  rdy2
; 4  tr1
; 5  tr2
; 6  rcnt
; 7  rx1
; 8  rx1inc
; 9  rx2
; 10 rx2inc
; 11 rdy1
; 12 loop cnt
; 13 loop label
; 14


rpolyptr	equr	1


rx	equr	1
ry	equr	2
rdy2	equr	3
rtr1	equr	4
rtr2	equr	5
rcnt	equr	6
rx1	equr	9
rx1inc	equr	7
rx2	equr	10
rx2inc	equr	8
rdy1	equr	11
rdx	equr	12

rymax	equr	8
rnpts	equr	3
rtr	equr	6

rxp1	equr	0
rxp1inc	equr	0
ryp1	equr	0
ryp1inc	equr	0
rxp2	equr	0
rxp2inc	equr	0
ryp2	equr	0
ryp2inc	equr	0


	ifeq	1
;testcode
mtesttscanstart
	ibt	r0,#15
	colour

;	mpoly	80,48,48,80,80,112,112,80

	miwt	r1,m_polybuf
;	mtpoly	80,48,0,0,48,80,0,64
;	mtpoly	80,112,64,64,112,80,64,0

;	mtpoly	80,48,0,0,48,80,0,127
;	mtpoly	80,112,127,127,112,80,127,0

;	mtpoly	80,48,0,0,48,80,64,0
;	mtpoly	80,112,64,64,112,80,0,64

;	mtpoly	80,16,0,0,32,80,0,64
;	mtpoly	80,112,64,64,138,80,64,0

;	mtpoly	70,14,0,0,62,64,0,64
;	mtpoly	82,82,64,64,162,25,64,0
;	mtpoly	162,25,64,0,70,14,0,0
;	mtpoly	62,64,0,64,82,82,64,64
;	mtpoly	82,82,64,64,162,25,64,0
;	mtpoly	70,14,0,0,62,64,0,64
;	mtpoly	62,64,0,64,82,82,64,64
;	mtpoly	162,25,64,0,70,14,0,0
	mtpoly	62,64,64,64,82,82,64,0
	mtpoly	162,25,0,0,70,14,0,64

;	mtpoly	112,14,0,0,62,64,0,32
;	mtpoly	112,114,32,32,162,50,32,0


;	mpoly	100,92,92,100,100,108,108,100
;	mpoly	108,100,100,92,92,100,100,108

;	mpoly	100,108,108,100,100,92,92,100

;	mpoly	92,100,100,108,108,100,100,92



;	mpoly	0,0,0,127,127,127,127,0
;	mpoly	0,0,0,127,128,127,128,0
;	mpoly	16,0,0,127,176,126,160,1
;	mpoly	0,0,0,127,223,127,223,0
;	mpoly	4,4,0,127,200,120,220,5

	ibt	r0,#4
	endc



	ifeq	0

; draw texture mapped polygon

mdrawtpoly

mtscanstart
;	dec	r0
;	dec	r0
;	mlbeq	mline

;	inc	r0
;	inc	r0

	lob

;	sub	#4
;	mlbne	mdrawpolylistexit	; end of list?
;	add	#4

	move	r12,r0		; init loop count
	add	r0
	add	r0
	add	r0
	move	rnpts,r0	; npts << 3

	mldbi	rpolyptr
	sms	[m_sprbank],r0

	sub	r0
	cmode

	mldwi	rpolyptr
;	sms	[m_tcmodecol],r0

	colour
	swap
	cmode
	mldwi	rpolyptr
	sms	[m_sprdata],r0
	mldwi	rpolyptr
	sms	[m_sprmask],r0
		
;	miwt	rtr1,m_polybuf	; tr1 = m_polybuf
;	from	rtr1
;	to	rtr2
;	add	r0		; tr2 = tr1 + (npts << 3) 

	from	rpolyptr
	add	rnpts
	sms	[m_polylistptr],r0

;	mlbra	mdrawpolylistloop	; don't draw it



	move	rtr2,rpolyptr

	from	rpolyptr
	to	rtr1
	sub	rnpts

	ifne	mario_stats3d
	mincm	m_polys_drawn
	endc


	miwt	ry,1023		; init ymin
	ibt	rymax,#0    	; init ymax

;	mcache

	move	r13,pc		; init loop label

; find ymin and copy pnts
;----------------------------
;Carl woz here
	IFNE	1
;----------------------------
	ldb	[rtr2]		; copy x
	stb	[rtr1]
	inc	rtr1
	inc	rtr1
	inc	rtr2
	inc	rtr2

	ldb	[rtr2]		; copy y
	stb	[rtr1]

	cmp	ry		; find ymin
	bpl	.1
	nop
	move	ry,r0
	move	rtr,rtr1
.1

	cmp	rymax		; find ymax
	bmi	.2
	nop
	move	rymax,r0
.2

	inc	rtr1
	inc	rtr1
	inc	rtr2
	inc	rtr2

	sub	r0
	inc	rtr2
	ldb	[rtr2]		; copy xp
	dec	rtr2
	stb	[rtr2]
	inc	rtr2
	inc	rtr2
	stb	[rtr1]
	inc	rtr1
	inc	rtr1

	inc	rtr2
	ldb	[rtr2]		; copy yp
	dec	rtr2
	stb	[rtr2]
	inc	rtr2
	inc	rtr2
	stb	[rtr1]
	inc	rtr1

	loop			; next vertex
	inc	rtr1

;----------------------------
	ELSEIF
;----------------------------

	ldb	[rtr1]		; copy x
	inc	rtr1
	inc	rtr1
	stb	[rtr2]
	inc	rtr2
	inc	rtr2

	ldb	[rtr1]		; copy y
	stb	[rtr2]

	cmp	ry		; find ymin
	bpl	.1
	nop
	move	ry,r0
	move	rtr,rtr1
.1

	cmp	rymax		; find ymax
	bmi	.2
	nop
	move	rymax,r0
.2

	inc	rtr1
	inc	rtr1
	inc	rtr2
	inc	rtr2

	ldb	[rtr1]		; copy xp
	inc	rtr1
	inc	rtr1
	stb	[rtr2]
	inc	rtr2
	inc	rtr2

	ldb	[rtr1]		; copy yp
	inc	rtr1
	inc	rtr1
	stb	[rtr2]
	inc	rtr2

	loop			; next vertex
	inc	rtr2

;----------------------------
	ENDC


; init scan converter

	from	ry
	sub	rymax
	mlbeq	mtscanhline

	move	rtr1,rtr	; tr1 = tr - 2
	dec	rtr1
	dec	rtr1

	from	rtr1
	to	rtr2
	add	rnpts		; tr2 = tr1 + npts

	ldb	[rtr1]
	inc	rtr1
	inc	rtr1
	to	rx1
	swap			; x1
	move	rx2,rx1		; x2

;	to	ry		; already there
;	ldb	[rtr1]
	inc	rtr1
	inc	rtr1		; and skip y

	ldb	[rtr1]		; xp
	swap
	sms	[m_xp1],r0
	sms	[m_xp2],r0
	inc	rtr1
	inc	rtr1

	ldb	[rtr1]		; yp
	swap
	sms	[m_yp1],r0
	sms	[m_yp2],r0
	inc	rtr1
	inc	rtr1

	sms	[m_tr1],rtr1
	sms	[m_tr2],rtr2

	ibt	rdy1,#0		; init both
	ibt	rdy2,#0

;	lms	r0,[m_tcmodecol]
;	colour
;	swap
;	cmode

;	ifeq	1
;	ibt	r0,#$20		; texture palette number
;	colour
;	ibt	r0,#8		; 256 colour mode, 16 colour texture
;	cmode
;	endc

	mcache

	miwt	pc,mtnewx1	; jump to init tracers
	 nop

; scan converter loop

; x1
; x1inc
; x2
; x2inc
; ycnt

; xp1
; xp1inc
; xp2
; xp2inc
; yp1
; yp1inc
; yp2
; yp2inc

; x xlen xp yp xpi ypi

rx	equr	1
ry	equr	2
rmask	equr	3
rspdata	equr	4
rxpi	equr	5
rypi	equr	6
ryp	equr	7
rxp	equr	8

;rt	equr	4
;rshift	equr	10



mthlines
	sms	[m_x1inc],rx1inc
	sms	[m_x2inc],rx2inc

	ifeq	0
	from	rdy1
	sub	rdy2
	bmi	.1
	nop

	sms	[m_dy1],r0
	from	rdy2
	swap
	to	ry
	or	ry
	sub	r0
	sms	[m_dy2],r0
	bra	.2
	nop

.1
	from	rdy2
	sub	rdy1
	sms	[m_dy2],r0
	from	rdy1
	swap
	to	ry
	or	ry
	sub	r0
	sms	[m_dy1],r0
.2	
	endc

thlines1	
;	sms	[m_x1],rx1
;	sms	[m_x1inc],rx1inc
;	sms	[m_x2],rx2
;	sms	[m_x2inc],rx2inc
;	sms	[m_dy1],rdy1
;	sms	[m_dy2],rdy2

	from	rx1		; x = (rx1)>>8
	to	rx
	hib

	from	rx2
	hib
	to	r12
	sub	rx		; r12 = x - (rx2>>8)
	bcs	.1		; if (rx2>>8) < (rx1>>8) no hline
	inc	r12		; one for luck
	ibt	r12,#1
.1

	ifeq	1
	ibt	r0,#15		; plot endpoints of hline
	colour
	plot
	move	r0,rx
	with	rx
	add	r12
	plot
	move	rx,r0
	endc

	miwt	r0,reciptab16s	; romtab
	add	r12
	to	r14
	add	r12		; r14 = reciptab16s + dx*2

	to	r6
	getb
	inc	r14
	with	r6
	getbh			; r6 = 32768 / dx

	lms	r0,[m_xp2inc]
	lms	r4,[m_xp2]
	add	r4
	sbk			; xp2 += xp2inc

	lms	rxp,[m_xp1]
	from	r4
	sub	rxp

	fmult			; rxpi = (xp2-xp1)/dx
	to	rxpi
	rol

	lms	r0,[m_xp1inc]
	add	rxp
	sms	[m_xp1],r0	; xp1 += xp1inc

	ifeq	0
	lms	r0,[m_yp2inc]
	lms	r4,[m_yp2]
	add	r4
	sbk			; yp2 += yp2inc

	lms	ryp,[m_yp1]
	from	r4
	sub	ryp

	fmult			; rypi = (yp2-yp1)/dx
	to	rypi
	rol

	lms	r0,[m_yp1inc]
	add	ryp
	sms	[m_yp1],r0	; yp1 += yp1inc

	ifeq	0
	lms	rspdata,[m_sprxscroll]
	with	rxp
	add	rspdata

	lms	rspdata,[m_spryscroll]
	with	ryp
	add	rspdata
	endc

	lms	r0,[m_sprbank]
	lob
	romb			; set sprite ROM bank and data addr
	lms	rspdata,[m_sprdata]
	lms	rmask,[m_sprmask]
	endc

cthlines

 IFNE	msmooth_shading
	lms	r0,[m_texturemap]
	inc	r0
	bne	.1
	nop
 ENDC

	ifeq	0	; texture map
	move	r13,pc

	merge		; r0 = (ryp & $ff00) + (rxp & $ff00)>>8
	and	rmask
	to	r14
	add	rspdata
	with	ryp
	add	rypi
	with	rxp
	add	rxpi
	getc

	ifne	0
	getb
	ldb	[r0]
	colour
	endc

	loop
	plot		; = 11	( uses 10 regs )
	endc


 IFNE	msmooth_shading
	mlbra	cthlinesrts

.1
	ifeq	0	; smooth shading with rnd
	ibt	r0,#mrndtab>>16
	romb
	from	ry
	add	ry
	add	r0
	mult	#13
	add	ry
	add	rx
	lob
	miwt	r14,mrndtab&$ffff
	to	r14
	add	r14
	move	r13,pc

	getb
	inc	r14
	add	rxp
	hib
	colour
	with	rxp
	add	rxpi
	loop
	plot
	endc
 ENDC

	ifeq	1	; dithering smooth shading with rnd
	ibt	r0,#mrndtab>>16
	romb
	from	ry
	add	ry
	add	r0
	mult	#13
	add	ry
	add	rx
	lob
	miwt	r14,mrndtab&$ffff
	to	r14
	add	r14

	ifeq	1
	from	r12
	lsr
	bcc	.3
	nop
	beq	.0
	nop
.3
	with	rxpi
	add	rxpi
	endc
	
	move	r13,pc

	getb
	inc	r14
	add	rxp
	hib
	colour
	with	rxp
	add	rxpi
	from	r1
	xor	r2
	lsr
	bcs	.2
	inc	r1
	dec	r1
	plot
.2
	loop
	nop
	endc


	ifeq	1	; smooth shading
	move	r0,rxp
	move	r13,pc

	swap
	colour
	swap
	add	rxpi
	loop
	plot
	endc




cthlinesrts
	sub	r0
	romb

;	lms	rx1,[m_x1]
	lms	rx1inc,[m_x1inc]
;	lms	rx2,[m_x2]
	lms	rx2inc,[m_x2inc]
;	lms	rdy1,[m_dy1]
;	lms	rdy2,[m_dy2]

	with	rx1		; rx1+=rx1inc
	add	rx1inc

 IFNE	1
	bpl	.3		; *** temp hack ***
	nop
	miwt	r0,$0800
	add	rx1
	bmi	.3
	nop
	ibt	rx1,#0
.3
 ENDC

	with	rx2		; rx2+=rx2inc
	add	rx2inc

 IFNE	1
	bpl	.2		; *** temp hack ***
	nop
	miwt	r0,$0800
	add	rx2
	bmi	.2
	nop
	ibt	rx2,#0
.2
 ENDC

	ifeq	0
	inc	ry

	from	ry
	swap
	dec	r0
	to	ry
	swap

	from	ry
	hib
	mlbne	thlines1	; *** change ***
;	nop

	lms	rdy1,[m_dy1]
	lms	rdy2,[m_dy2]
	endc

	ifeq	1
	dec	rdy1		; dy1-=1
	dec	rdy2		; dy2-=1
	from	rdy1
	and	rdy2
	beq	.1
	inc	ry		; inc y
	miwt	pc,thlines1	; loop if (dy1 or dy2) >= 0
	nop
.1
	endc



; New x1

mtnewx1

htscansize	=	mtnewx1-mthlines
;	?htscansize

	moves	r0,rdy1
	mlbne	mtnewx2

;	with	rx1		; x1 = x1 >> 8
;	hib

	ibt	r0,#127
	add	rx1
	to	rx1		; x1 = x1 >> 8
	hib

	lms	r0,[m_xp1]
	hib
	sbk
	lms	r0,[m_yp1]
	hib
	sbk

	lms	rtr,[m_tr1]
mtnewx11
	move	rdx,rx1		; dx = x1

	lms	r0,[m_xp1]
	sms	[m_dxp1],r0
	lms	r0,[m_yp1]
	sms	[m_dyp1],r0

	to	rx1
	ldb	[rtr]		; x1
	inc	rtr
	inc	rtr

	to	r4
	ldb	[rtr]		; y1
	inc	rtr
	inc	rtr

	ldb	[rtr]		; xp1
	sms	[m_xp1],r0
	inc	rtr
	inc	rtr

	ldb	[rtr]		; yp1
	sms	[m_yp1],r0
	inc	rtr
	inc	rtr

	from	r4
	to	rdy1
	sub	ry		; dy1 = y1 - y
	beq	mtnewx11	; if dy1=0 then get next vertex
	nop

	mlbmi	mtscanexit	; if dy1<0 then exit

	sms	[m_tr1],rtr

	miwt	r0,reciptab16s
	add	rdy1
	to	r14
	add	rdy1		; r14 = reciptab + dy1 * 2

	to	r6
	getb
	inc	r14
	with	r6
	getbh			; r6 = 32768 / dy1

	from	rx1
	sub	rdx		; r0 = (x1 - dx)
;	swap

; x1inc = (r6 * r0) << 1

	from	rdx		; x1 = dx
	to	rx1
	swap

	lmult
	with	r4
	add	r4
	rol			; x1inc = (r6 * r0) << 1

	lob
	swap
	with	r4
	hib
	to	rx1inc
	or	r4


	ifeq	1
	fmult
	to	rx1inc
	rol

	from	rdx		; x1 = dx
	to	rx1
	swap
	endc



	lms	r0,[m_xp1]
	lms	r1,[m_dxp1]
	sub	r1
	lob
	swap

; xp1inc = (r6 * r0) << 1

	fmult
	rol
	sms	[m_xp1inc],r0

	lms	r0,[m_dxp1]
	swap
	sms	[m_xp1],r0


	lms	r0,[m_yp1]
	lms	r1,[m_dyp1]
	sub	r1
	lob
	swap

; yp1inc = (r6 * r0) << 1

	fmult
	rol
	sms	[m_yp1inc],r0

	lms	r0,[m_dyp1]
	swap
	sms	[m_yp1],r0



; New x2

mtnewx2
	moves	r0,rdy2
	mlbne	mthlines

;	with	rx2		; x2 = x2 >> 8
;	hib

	ibt	r0,#127
	add	rx2
	to	rx2		; x2 = x2 >> 8
	hib

	lms	r0,[m_xp2]
	hib
	sbk
	lms	r0,[m_yp2]
	hib
	sbk

	lms	rtr,[m_tr2]
mtnewx21
	move	rdx,rx2		; dx = x2

	lms	r0,[m_xp2]
	sms	[m_dxp2],r0
	lms	r0,[m_yp2]
	sms	[m_dyp2],r0

	dec	rtr
	dec	rtr
	ldb	[rtr]		; yp2
	sms	[m_yp2],r0

	dec	rtr
	dec	rtr
	ldb	[rtr]		; xp2
	sms	[m_xp2],r0

	dec	rtr
	dec	rtr
	ldb	[rtr]		; y2

	dec	rtr
	dec	rtr
	to	rx2
	ldb	[rtr]		; x2

	to	rdy2
	sub	ry		; dy2 = y2 - y
	beq	mtnewx21	; if dy2=0 then get next vertex
	nop

	mlbmi	mtscanexit     	; if dy2<0 then exit

	sms	[m_tr2],rtr

	miwt	r0,reciptab16s
	add	rdy2
	to	r14
	add	rdy2		; r14 = reciptab + dy2

	to	r6
	getb
	inc	r14
	with	r6
	getbh			; r6 = 32768 / dy2

	from	rx2
	sub	rdx		; r0 = (x2 - dx)
;	swap

; x2inc = (r6 * r0) << 1

	from	rdx		; x2 = dx
	to	rx2
	swap

	lmult
	with	r4
	add	r4
	rol			; x2inc = (r6 * r0) << 1

	lob
	swap
	with	r4
	hib
	to	rx2inc
	or	r4


	ifeq	1
	fmult
	to	rx2inc
	rol

	from	rdx		; x2 = dx
	to	rx2
	swap
	endc



	lms	r0,[m_xp2]
	lms	r1,[m_dxp2]
	sub	r1
	lob
	swap

; xp2inc = (r6 * r0) << 1

	fmult
	rol
	sms	[m_xp2inc],r0

	lms	r0,[m_dxp2]
	swap
	sms	[m_xp2],r0


	lms	r0,[m_yp2]
	lms	r1,[m_dyp2]
	sub	r1
	lob
	swap

; yp2inc = (r6 * r0) << 1

	fmult
	rol
	sms	[m_yp2inc],r0

	lms	r0,[m_dyp2]
	swap
	sms	[m_yp2],r0


	miwt	pc,mthlines
	nop


mtscanhline
mtscanexit
	mlbra	mdrawpolylistloop

;	mlbra	mfacelabel

;	stop

tscansize	=	mtscanexit-mtscanstart
;	?tscansize
	endc

 ENDC						; IF mpolylist=1





;************************************************
;************************************************




 IFEQ	mpolylist				; IF mpolylist=0


; draw polygon


; draw hline timing
;
; n = bytes covered by line
; c = total mario cycles taken
; r = RAM byte read  time in MARIO cycles * number of bit planes
; w = RAM byte write time in MARIO cycles * number of bit planes
;
; if n = 1 then c=r+w
; if n > 1 then c=2*r+n*w
;
; If r=3*4, w=3*4
;
; n	r/w	 c
;---   -----   ----
; 1	 6	 24
; 2	12	 48
; 3	15	 60
; 4	18	 72
; 5	21	 84
; 6	24	 96
; 7	27	108
; 8	30	120
; -	--	---
;28	90	360
;

; 0
; 1  rx
; 2  ry
; 3  rdy2
; 4  tr1
; 5  tr2
; 6  rcnt
; 7  rx1
; 8  rx1inc
; 9  rx2
; 10 rx2inc
; 11 rdy1
; 12 loop cnt
; 13 loop label
; 14

rx	equr	1
ry	equr	2
rdy2	equr	3
rtr1	equr	4	; m_tr1
rtr2	equr	5
rtr	equr	6
rx1	equr	7
rx1inc	equr	8
rx2	equr	9
rx2inc	equr	10
rdy1	equr	11
rdx1	equr	rx1inc
rdx2	equr	rx2inc

rnpts	equr	3
rymax	equr	8


	ifeq	1

;testcode
;	ibt	r0,#0	
;	sms	[m_texturemap],r0

;	ibt	r0,#15
;	colour

;	mpoly	80,48,48,80,80,112,112,80
;	mpoly	99,33,48,80,91,120,112,80

;	mpoly	100,92,92,100,100,108,108,100
;	mpoly	108,100,100,92,92,100,100,108

;	mpoly	100,108,108,100,100,92,92,100

;	mpoly	92,100,100,108,108,100,100,92

;	mpoly	0,0,0,127,127,127,127,0
;	mpoly	0,0,0,127,128,127,128,0
;	mpoly	16,0,0,127,176,126,160,1
;	mpoly	0,0,0,127,223,127,223,0
;	mpoly	4,4,0,127,200,120,220,5
;	ibt	r0,#4

	endc


mdrawpoly
mscanstart
	mcache

	lms	r1,[m_texturemap]
	mtest	r1
	mlbne	mtscanstart
;	mlbne	mscanexit

	dec	r0
	dec	r0
	mlbeq	mline
;	mlbeq	mscanexit

	inc	r0
	inc	r0

	move	r12,r0		; init loop count
	add	r0
	add	r0
	move	rnpts,r0	; npts << 2

	miwt	rtr1,m_polybuf	; tr1 = m_polybuf
	from	rtr1
	to	rtr2
	add	r0		; tr2 = tr1 + (npts << 2) 



	ifne	mario_stats3d
	mincm	m_polys_drawn
	endc


	
	miwt	ry,1023		; init ymin
	ibt	rymax,#0		; init ymax

	move	r13,pc		; init loop label

; find ymin and copy pnts

	ldb	[rtr1]		; copy x
	stb	[rtr2]
	inc	rtr1
	inc	rtr1
	inc	rtr2
	inc	rtr2
	ldb	[rtr1]		; copy y
	stb	[rtr2]

	cmp	ry		; find ymin
	bpl	.1
	inc	rtr2
	move	ry,r0
	move	rtr,rtr1
.1
;	cmp	rymax		; find ymax
	sub	rymax
	bmi	.2
	inc	rtr2
;	move	rymax,r0
	to	rymax
	add	rymax
.2
	inc	rtr1
	loop			; next vertex
	inc	rtr1

; init scan converter

	from	ry
	sub	rymax
	mlbeq	mscanhline

	dec	rtr		; tr = tr - 2
	dec	rtr

	from	rtr
	to	rtr2
	add	rnpts		; tr2 = tr1 + npts

	to	rdx1
	ldb	[rtr]		; get x1

;	sms	[m_tr2],rtr2

	with	rtr		; skip x,y
	add	#4

	to	rx2
	from	rdx1
	swap			; x2 = x1 * 256

	miwt	r13,hlines2	; init hline loop label
				; (saves 2 cycles/hline)

	with	rdy2		; dy2 = 0
	bra	mnewx1init	; and jump to init tracers
	sub	rdy2

; scan converter loop

; New x1

mnewx1
	moves	r0,rdy1
	bne	mnewx2
	nop

	ibt	r0,#127
	add	rx1
	to	rx1		; x1 = x1 >> 8
	hib

	lms	rtr,[m_tr1]
mnewx11
	move	rdx1,rx1	; dx = x1

mnewx1init
	to	rx1
	ldb	[rtr]		; x1
	inc	rtr
	inc	rtr

	ldb	[rtr]		; y1
	inc	rtr
	inc	rtr

	to	rdy1
	sub	ry		; dy1 = y1 - y
	bpl		.1		; if dy1<0 then exit
	nop
	mlbra	mscanexit
.1
	beq	mnewx11		; if dy1=0 then get next vertex
	nop

	miwt	r0,reciptab16s
	add	rdy1
	to	r14
	add	rdy1		; r14 = reciptab + dy1 * 2

	sms	[m_tr1],rtr

	from	rx1
	sub	rdx1		; r0 = (x1 - dx)

	to	r6
	getb
	inc	r14

	from	rdx1		; x1 = dx
	to	rx1
	swap

	with	r6
	getbh			; r6 = 32768 / dy1

	lmult
	with	r4
	add	r4
	rol			; x1inc = (r6 * r0) << 1

	lob
	swap
	with	r4
	hib
	to	rx1inc
	or	r4

; New x2

mnewx2
	moves	r0,rdy2
	bne	mhlines
	nop

	ibt	r0,#127
	add	rx2
	to	rx2		; x2 = x2 >> 8
	hib

;	lms	rtr,[m_tr2]
mnewx21
	move	rdx2,rx2	; dx = x2

	dec	rtr2
	dec	rtr2
	ldb	[rtr2]		; y2

	dec	rtr2
	dec	rtr2
	to	rx2
	ldb	[rtr2]		; x2

	to	rdy2
	sub	ry		; dy2 = y2 - y

	bpl	.1
	nop
	mlbra	mscanexit	; if dy2<0 then exit
.1
	beq	mnewx21		; if dy2=0 then get next vertex
	nop

;	sms	[m_tr2],rtr

	miwt	r0,reciptab16s
	add	rdy2
	to	r14
	add	rdy2		; r14 = reciptab + dy2

	from	rx2
	sub	rdx2		; r0 = (x2 - dx)

	to	r6
	getb
	inc	r14

	from	rdx2		; x2 = dx
	to	rx2
	swap

	with	r6
	getbh			; r6 = 32768 / dy2

	lmult
	with	r4
	add	r4
	rol			; x2inc = (r6 * r0) << 1

	lob
	swap
	with	r4
	hib
	to	rx2inc
	or	r4

; draw trapezoid loop

; cycles = (x*2 + 23)*y + plot_wait

mhlines
hlines1	
	ifeq	mtowerofplots

	from	rx1		; x = (rx1)>>8
	to	rx
	hib

	from	rx2
	hib
	to	r12
	sub	rx		; length, r12 = x - (rx2>>8)
	bmi	hlines3		; if length < 0 then no hline
	inc	r12		; one for luck
hlines2
	loop			; plot horizontal line
	plot
hlines3
	with	rx1		; rx1+=rx1inc
	add	rx1inc

	ifne	1		; temp hack to stop x1 going <0
	bpl	.1
	dec	rdy1		; dy1-=1
	miwt	r0,$0800
	add	rx1
	bmi	.1
	nop
	ibt	rx1,#0
.1
	endc

	with	rx2		; rx2+=rx2inc
	add	rx2inc

	ifne	1		; temp hack to stop x2 going <0
	bpl	.2
	dec	rdy2		; dy2-=1
	miwt	r0,$0800
	add	rx2
	bmi	.2
	nop
	ibt	rx2,#0
.2
	endc

;	dec	rdy1		; dy1-=1
;	dec	rdy2		; dy2-=1
	from	rdy1
	and	rdy2
	bne	hlines1		; loop until dy1=0 or dy2=0
	inc	ry

	endc

	ifne	mtowerofplots

	from	rx1		; x = (rx1)>>8
	to	rx
	hib

	from	rx2
	hib
	to	r12
	sub	rx		; r12 = x - (rx2>>8)
	bpl	hlines2		; if (rx2>>8) < (rx1>>8) no hline
	nop
	ibt	r12,#0
;	inc	r12		; one for luck
hlines2
	miwt	r0,(hlines3&$ffff)
	to	pc
	sub	r12

	rept	224
	plot
	endr
hlines3
	with	rx1		; rx1+=rx1inc
	add	rx1inc

	bpl	.1
	nop
	miwt	r0,$0800
	add	rx1
	bmi	.1
	nop
	ibt	rx1,#0
.1

	with	rx2		; rx2+=rx2inc
	add	rx2inc

	bpl	.2
	nop
	miwt	r0,$0800
	add	rx2
	bmi	.2
	nop
	ibt	rx2,#0
.2

	inc	ry
	dec	rdy1		; dy1-=1
	dec	rdy2		; dy2-=1
	from	rdy1
	and	rdy2
	mlbne	hlines1
;	inc	ry

	endc



	miwt	pc,mnewx1
	nop

mscanhline
mscanexit
	mlbra	mfacelabel

;	stop


	ifeq	1
	miwt	r0,223
	sub	r12
	to	pc
	add	pc
	rept	224
	plot
	endr
	endc



scansize	=	mscanexit-mscanstart
;	?scansize


;mdrawpoly	=	mscanstart
;mdrawpoly	=	msc_poly



	ifne	1

;-----------------------------------
;line draw
rx1	equr	r1
ry1	equr	r2
rx2	equr	r3
ry2	equr	r4
rxi	equr	r5
ryi	equr	r6
rmpt	equr	r7
rlgrad	equr	r8

rcnt	equr	r12

;------
mline
;	mlbra	mfacelabel

	ifne	mario_stats3d
	mincm	m_lines_drawn
	endc

	mcache

	miwt	rmpt,m_polybuf
	to	rx1
	mldwi	rmpt
	to	ry1
	mldwi	rmpt
	to	rx2
	mldwi	rmpt
	to	ry2
	ldw	[rmpt]

	ibt	rxi,#1
	with	rx2
	sub	rx1
	bpl	.1
	nop
	ibt	rxi,#-1
	mneg	rx2
.1
	ibt	ryi,#1
	with	ry2
	sub	ry1
	bpl	.3
	nop
	ibt	ryi,#-1
	mneg	ry2
.3
	from	rx2
	sub	ry2
	bmi	.largery
	nop

	move	rcnt,rx2
	inc	rcnt
	lsr
	sub	ry2
	move	r13,pc

;Loop			8/11 cycles
	bcs	.5
	plot
	add	rx2
	with	ry1
	add	ryi
.5
	dec	rx1
	with	rx1
	add	rxi
	loop
	sub	ry2

	mlbra	mfacelabel


.largery
	move	rcnt,ry2
	inc	rcnt
	mneg	r0
	lsr

	sub	rx2
	move	r13,pc
;Loop			8/11 cycles
	bcs	.6
	plot
	add	ry2
	with	rx1
	add	rxi
.6
	dec	rx1
	with	ry1
	add	ryi
	loop
	sub	rx2

	mlbra	mfacelabel

mlinelen	equ	*-mline
;	?mlinelen

	endc

 ENDC					; ENDC mpolylist=0








 IFNE	mpolylist			; IF mpolylist=1


; draw polygon


; draw hline timing
;
; n = bytes covered by line
; c = total mario cycles taken
; r = RAM byte read  time in MARIO cycles * number of bit planes
; w = RAM byte write time in MARIO cycles * number of bit planes
;
; if n = 1 then c=r+w
; if n > 1 then c=2*r+n*w
;
; If r=3*4, w=3*4
;
; n	r/w	 c
;---   -----   ----
; 1	 6	 24
; 2	12	 48
; 3	15	 60
; 4	18	 72
; 5	21	 84
; 6	24	 96
; 7	27	108
; 8	30	120
; -	--	---
;28	90	360
;

; 0
; 1  rx
; 2  ry
; 3  rdy2
; 4  tr1
; 5  tr2
; 6  rcnt
; 7  rx1
; 8  rx1inc
; 9  rx2
; 10 rx2inc
; 11 rdy1
; 12 loop cnt
; 13 loop label
; 14

rx	equr	1
ry	equr	2
rdy2	equr	3
rtr1	equr	4	; m_tr1
rtr2	equr	5
rtr	equr	6
rx1	equr	7
rx1inc	equr	8
rx2	equr	9
rx2inc	equr	10
rdy1	equr	11
rdx1	equr	rx1inc
rdx2	equr	rx2inc

rnpts	equr	3
rymax	equr	8
rxmax	equr	8


	ifne	polytesting

mtestdrawpoly
	miwt	r0,100
	sms	[m_cnt],r0
	
	ibt	r0,#0	
	sms	[m_texturemap],r0

	ibt	r0,#14
	colour

;	mpoly3	4,0,0,180,57,59			;  100p 12h 3e

;	mpoly3	154,50,144,62,161,59			;  100p 12h 3e
	mpoly3	50,50,40,62,57,59			;  100p 12h 3e

;	mpoly3	50,50,40,62,56,56			;o  100p 10h 3e
;	mpoly3	55,50,45,62,61,56			;o  100p 10h 3e

;	mpoly	80,48,48,80,80,112,112,80
;	mpoly	99,33,48,80,91,120,112,80

;	mpoly	100,92,92,100,100,108,108,100
;	mpoly	108,100,100,92,92,100,100,108

;	mpoly	100,108,108,100,100,92,92,100

;	mpoly	92,100,100,108,108,100,100,92

;	mpoly	0,0,0,127,127,127,127,0
;	mpoly	0,0,0,127,128,127,128,0
;	mpoly	16,0,0,127,176,126,160,1
;	mpoly	0,0,0,127,223,127,223,0
;	mpoly	4,4,0,127,200,120,220,5

mtestdrawpolyloop
;	ibt	r0,#0	
;	sms	[m_x1],r0
;	sms	[m_x2],r0

	ibt	r0,#3

	endc


mdrawpoly
mscanstart
	mcache


 ifne	mpolylist

rpolyptr	equr	1


mdrawpolylistchk
	mlbeq	mline				; line?

	inc	r0
	inc	r0

	beq	mdrawpolylistexit		; 0 = exit ?
	 not					; get npnts (NOTed)

	mlbra	mtscanstart			; must be texture map

mdrawpolylistexit
	miwt	rpolyptr,m_polylist		; init polylist ptr
	sms	[m_polylistptr],rpolyptr

;	stop
;	nop

	lms	r0,[m_shapebank]		; switch back to shape bank
	romb

	lms	rsp,[m_polyrsp]			; restore rsp and return
	mpop	pc
	 nop


; Draw everything in the polylist pointed to by [m_polylistptr]
;
; in:
; out: r1 = [m_polylistptr] = m_polylist
;	ROMB = [m_shapebank]
; dead:all regs, COLOUR, CMODE

mdrawpolylist
	lms	rpolyptr,[m_polylistptr]
	miwt	r0,m_polylist
	sub	rpolyptr
	bne	.1				; null list?
	 nop

	jmp	r11
	 nop
	
.1
	mpush	r11
	sms	[m_polyrsp],rsp			; save rlink and rsp

	sub	r0
	stw	[rpolyptr]			; 0 terminate polylist

	miwt	rpolyptr,m_polylist		; init polylist ptr
	sms	[m_polylistptr],rpolyptr

	ifne	mario_stats3d
	mincm	m_poly_lists
	endc

	ibt	r0,#reciptab16s>>16		; change ROM bank
	romb

mdrawpolylistloop
	lms	rpolyptr,[m_polylistptr]

	ldb	[rpolyptr]	; npnts
	sex
	inc	rpolyptr

	sub	#3
	bmi	mdrawpolylistchk	; <3?
	 inc	r0

	mcache

	inc	r0
	inc	r0

	move	r12,r0		; init loop count
	add	r0
	add	r0
	move	rnpts,r0	; npts << 2

	ifne	mario_stats3d
	mincm	m_polys_drawn
	endc

	ibt	r0,#$70
	colour
	ibt	r0,#2		;2	;8     	; dither on
	cmode

	ldb	[rpolyptr]	; get colour
	inc	rpolyptr
	colour

;	miwt	rtr1,m_polybuf	; tr1 = m_polybuf
;	from	rtr1
;	to	rtr2
;	add	r0		; tr2 = tr1 + (npts << 2) 

	from	rpolyptr	; move to next poly
	add	rnpts
	sms	[m_polylistptr],r0

	move	rtr2,rpolyptr	; tr2 = rpolyptr

	from	rpolyptr	; tr1 = rpolyptr - npnts<<2
	to	rtr1
	sub	rnpts

 endc


 ifeq	mpolylist

	lms	r1,[m_texturemap]
	mtest	r1
	mlbne	mtscanstart
;	mlbne	mscanexit

	dec	r0
	dec	r0
	mlbeq	mline
;	mlbeq	mscanexit
	inc	r0
	inc	r0

	move	r12,r0		; init loop count
	add	r0
	add	r0
	move	rnpts,r0	; npts << 2

	miwt	rtr1,m_polybuf	; tr1 = m_polybuf
	from	rtr1
	to	rtr2
	add	r0		; tr2 = tr1 + (npts << 2) 

 endc


	miwt	ry,1023		; init ymin
	ibt	rymax,#0	; init ymax

	move	r13,pc		; init loop label

; find ymin and copy pnts

	ifeq	mpolylist
	ldb	[rtr1]		; copy x
	stb	[rtr2]
	endc
	ifne	mpolylist
	ldb	[rtr2]		; copy x
	stb	[rtr1]
	endc

	inc	rtr1
	inc	rtr1
	inc	rtr2
	inc	rtr2

	ifeq	mpolylist
	ldb	[rtr1]		; copy y
	stb	[rtr2]
	endc
	ifne	mpolylist
	ldb	[rtr2]		; copy y
	stb	[rtr1]
	endc

	cmp	ry		; find ymin
	bpl	.1
	inc	rtr2

	move	ry,r0
	move	rtr,rtr1
.1
;	cmp	rymax		; find ymax
	sub	rymax
	bmi	.2
	inc	rtr2

;	move	rymax,r0
	to	rymax
	add	rymax
.2
	inc	rtr1
	loop			; next vertex
	inc	rtr1

; init scan converter

	from	rymax
	sub	ry
	dec	r0
	dec	r0
;	mlbmi	mscanhline	; if ymax-y < 2 then draw one hline
	mlbmi	mscanexit

	dec	rtr		; tr = tr - 2
	dec	rtr

	from	rtr
	to	rtr2
	add	rnpts		; tr2 = tr1 + npts

	dec	rtr2
	dec	rtr2

	to	rdx1
	ldb	[rtr]		; get x1

;	sms	[m_tr2],rtr2

	with	rtr		; skip x,y
	add	#4

	to	rx2
	from	rdx1
	swap			; x2 = x1 * 256

	miwt	r13,hlines2	; init hline loop label
				; (saves 2 cycles/hline)

	with	rdy2		; dy2 = 0
	bra	mnewx1init	; and jump to init tracers
	sub	rdy2

; scan converter loop

; New x1

mnewx1
	mtest	rdy1
	bne	mnewx2
	nop

	ibt	r0,#127
	add	rx1
	to	rx1		; x1 = x1 >> 8
	hib

	lms	rtr,[m_tr1]
mnewx11
	move	rdx1,rx1	; dx = x1

mnewx1init
	to	rx1
	ldb	[rtr]		; x1
	inc	rtr
	inc	rtr

	ldb	[rtr]		; y1
	inc	rtr

	to	rdy1
	sub	ry		; dy1 = y1 - y
	bpl		.1		; if dy1<0 then exit
	nop
	mlbra	mscanexit
.1
	beq	mnewx11		; if dy1=0 then get next vertex
	inc	rtr

	miwt	r0,reciptab16s
	add	rdy1
	to	r14
	add	rdy1		; r14 = reciptab + dy1 * 2

	sms	[m_tr1],rtr

	from	rx1
	sub	rdx1		; r0 = (x1 - dx)

	to	r6
	getb
	inc	r14

	from	rdx1		; x1 = dx
	to	rx1
	swap

	with	r6
	getbh			; r6 = 32768 / dy1

	lmult
	with	r4
	add	r4
	rol			; x1inc = (r6 * r0) << 1

	lob
	swap
	with	r4
	hib
	to	rx1inc
	or	r4

; New x2

mnewx2
	mtest	rdy2
	bne	mhlines
	nop

	ibt	r0,#127
	add	rx2
	to	rx2		; x2 = x2 >> 8
	hib

;	lms	rtr,[m_tr2]
mnewx21
	move	rdx2,rx2	; dx = x2

;	dec	rtr2
;	dec	rtr2
	ldb	[rtr2]		; y2
	dec	rtr2
	dec	rtr2

;	dec	rtr2
;	dec	rtr2
	to	rx2
	ldb	[rtr2]		; x2
	dec	rtr2

	to	rdy2
	sub	ry		; dy2 = y2 - y

	bpl	.1
	nop
	mlbra	mscanexit	; if dy2<0 then exit
.1
	beq	mnewx21		; if dy2=0 then get next vertex
	dec	rtr2

;	sms	[m_tr2],rtr

	miwt	r0,reciptab16s
	add	rdy2
	to	r14
	add	rdy2		; r14 = reciptab + dy2

	from	rx2
	sub	rdx2		; r0 = (x2 - dx)

	to	r6
	getb
	inc	r14

	from	rdx2		; x2 = dx
	to	rx2
	swap

	with	r6
	getbh			; r6 = 32768 / dy2

	lmult
	with	r4
	add	r4
	rol			; x2inc = (r6 * r0) << 1

	lob
	swap
	with	r4
	hib
	to	rx2inc
	or	r4

; draw trapezoid loop

; cycles = (x*2 + 23)*y + plot_wait

mhlines
hlines1	
	ifne	0
hlines2
	with	rx1		; rx1+=rx1inc
	add	rx1inc
	with	rx2		; rx2+=rx2inc
	add	rx2inc
	dec	rdy1
	beq	hlinesx
	dec	rdy2
	bne	hlines1		; loop until dy1=0 or dy2=0
hlinesx
	inc	ry
	endc


	ifeq	mtowerofplots
	from	rx1		; x = (rx1)>>8
	to	rx
	hib

;- Cark check
;	iwt	r0,#208
;	sub	rx
;	bpl	.okx1
;	nop
;	sm	[m_dynchecksum_ok],rx1
;.okx1

	from	rx2
	hib
	to	r12
	sub	rx		; length, r12 = x - (rx2>>8)
	bmi	hlines3		; if length < 0 then no hline
	inc	r12		; one for luck
hlines2
;	mincm	m_x1
	loop			; plot horizontal line
	plot
;	nop
hlines3
;	mincm	m_x2

	with	rx1		; rx1+=rx1inc
	add	rx1inc

	ifne	1		; temp hack to stop x1 going <0
	bpl	.1
	dec	rdy1		; dy1-=1
;	nop

	miwt	r0,$0800
	add	rx1
	bmi	.1
	nop
	ibt	rx1,#0
.1
	endc

	with	rx2		; rx2+=rx2inc
	add	rx2inc

	ifne	1		; temp hack to stop x2 going <0
	bpl	.2
	dec	rdy2		; dy2-=1
;	nop

	miwt	r0,$0800
	add	rx2
	bmi	.2
	nop
	ibt	rx2,#0
.2
	endc

	ifne	1
;	dec	rdy1		; dy1-=1
;	dec	rdy2		; dy2-=1
	from	rdy1
	and	rdy2
	bne	hlines1		; loop until dy1=0 or dy2=0
	inc	ry
	endc

	ifne	0
	dec	rdy1
	beq	hlinesx
	dec	rdy2
	bne	hlines1		; loop until dy1=0 or dy2=0
hlinesx
	inc	ry
	endc

	endc

	mlbra	mnewx1



mscanhline
mscanexit
	ifne	polytesting

	mdecm	m_cnt
	mlbne	mtestdrawpolyloop

	stop
	nop
	endc

	ifeq	mpolylist
	mlbra	mfacelabel
	endc

	ifne	mpolylist
	mlbra	mdrawpolylistloop
	endc




 IFNE	0

mscanhline
;	mlbra	mfacelabel

	from	rnpts
	lsr
	to	r12
	lsr

	miwt	rtr1,m_polybuf	; tr1 = m_polybuf

	miwt	rx,1023		; init xmin
	ibt	rxmax,#0	; init xmax

	move	r13,pc		; init loop label

; find xmin and xmax

	ldb	[rtr1]		; x
	cmp	rx		; find xmin
	bpl	.1
	inc	rtr1
	move	rx,r0
.1
	sub	rxmax		; find xmax
	bmi	.2
	inc	rtr1
	to	rxmax
	add	rxmax
.2
	inc	rtr1
	loop			; next vertex
	inc	rtr1

	from	rxmax
	to	r12
	sub	rx
	beq	.n
	nop
	bmi	.n
	nop

	move	r13,pc		; init loop label

	loop
	plot

.n
	mlbra	mfacelabel

 ENDC


scansize	=	mscanexit-mscanstart
;	?scansize





;-----------------------------------
;line draw

rx1	equr	r1
ry1	equr	r2
rx2	equr	r3
ry2	equr	r4
rxi	equr	r5
ryi	equr	r6
rmpt	equr	r7

rcnt	equr	r12

;------

mline

	ifne	mario_stats3d
	mincm	m_lines_drawn
	endc

	ibt	r0,#$70
	colour
	ibt	r0,#0		;2	;8     	; dither on
	cmode

	move	rmpt,rpolyptr
	mldbi	rmpt
	colour

	to	rx1
	mldbi	rmpt
	inc	rmpt
	to	ry1
	mldbi	rmpt
	inc	rmpt
	to	rx2
	mldbi	rmpt
	inc	rmpt
	to	ry2
	ldb	[rmpt]

	inc	rmpt
	inc	rmpt
	sms	[m_polylistptr],rmpt

	ibt	rxi,#1
	with	rx2
	sub	rx1
	bpl	.1
	 nop
	ibt	rxi,#-1
	mneg	rx2
.1
	ibt	ryi,#1
	with	ry2
	sub	ry1
	bpl	.3
	 nop
;- Fudge to bottom clip for Dylan by Carl
	lms	r0,[m_ybot]
	dec	r0
	sub	ry1
	bpl	.1botok
	nop
	dec	ry1
	inc	ry2
	dec	ry1
	inc	ry2
.1botok
;-^

	ibt	ryi,#-1
	mneg	ry2
	
;- Fudge to bottom clip for Dylan by Carl
	bra	.3a
	 nop
.3
 
	lms	r0,[m_ybot]
	dec	r0
	sub	ry2
	sub	ry1
	bpl	.3a
	nop
	dec	ry2
; dec ry1

.3a
;-^
	from	rx2
	sub	ry2
	bmi	.largery
	 nop

	move	rcnt,rx2
	inc	rcnt
	lsr
	sub	ry2
	move	r13,pc

;Loop			8/11 cycles
	bcs	.5
	 plot
	add	rx2
	with	ry1
	add	ryi
.5
	dec	rx1
	with	rx1
	add	rxi
	loop
	 sub	ry2

	mlbra	mdrawpolylistloop

.largery
	move	rcnt,ry2
	inc	rcnt
	mneg	r0
	lsr

	sub	rx2
	move	r13,pc
;Loop			8/11 cycles
	bcs	.6
	 plot
	add	ry2
	with	rx1
	add	rxi
.6
	dec	rx1
	with	ry1
	add	ryi
	loop
	 sub	rx2

	mlbra	mdrawpolylistloop

	printf	"poly+line cache = ",*-mdrawpolylistloop,"%n"

 ENDC					; endc mpolylist=1



