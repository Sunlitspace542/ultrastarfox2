;**********************************************************
;**
;** MSLOPEHEIGHT:
;** m_bigx = object's x
;** m_bigz = object's z
;** m_spra = x normal
;** m_sprb = y normal
;** m_sprc = z normal
;** m_bigy = distance of plane
;**
;** Exit: m_bigy = y position intersecting the plane
;**
;** m_bigy = -(m_bigx*m_spra + m_bigz*m_sprc - m_bigy)
;**           ----------------------------------------
;**                        m_sprb
;**
;**********************************************************


rsp	equr	10

mslopeheight
	sub	r0
	romb
	ramb

	miwt	r10,m_stack&WM


	lms	r0,[m_bigx]
	lms	r6,[m_spra]
	fmult	
	to	r1		; x*nx
	add	r0


	lms	r0,[m_bigz]
	lms	r6,[m_sprc]
	fmult
	add	r0
	to	r1
	add	r1		; + z*nz

	lms	r0,[m_bigy]
	with	r1
	sub	r0		; - d

	move	r5,r1
	ibt	r4,#0
	lms	r6,[m_sprb]

	mcall	mdivs3216_s	; r4.r5/r6 = r4
	nop

	with	r4
	asr
	sms	[m_bigy],r4

	stop
	nop
		 


;************************************************


; Square root of 32 bit number
;
; in:	rsqr   = low  16 bits of square
; 	rsqrhi = high 16 bits of square
; out:	rsqrt = square root
; dead: rt,rt2,r11,r12,r13


rsqrhi	equr	4
rsqr	equr	5
rsqrt	equr	6
rt2	equr	7
rt	equr	8


;************************************************

msqrt32_s
	ibt	rsqrt,#0
	ibt	rt,#0
	ibt	r12,#16
	miwt	r13,.2
	with	rsqr
.2
	add	rsqr
	with	rsqrhi
	rol
	with	rt
	rol

	with	rsqr
	add	rsqr
	with	rsqrhi
	rol
	with	rt
	rol

	with	rsqrt
	add	rsqrt
	from	rsqrt
	to	rt2
	add	rsqrt
	from	rt2
	sub	rt

	bcs	.1
;	nop
	with	rt
	sbc	rt2
	inc	rsqrt
.1
	loop
	with	rsqr

	jmp	r11
	nop


;************************************************


;************************************************

; Signed 32 bit by 16 bit divide
; with signed 16 bit quotient and 15 bit unsigned remainder
;
; In:	r5 = dividend.h
;	r4 = dividend.l
;	r6 = divisor
; Out:	r0 = remainder
;	r4 = quotient
;	r6 = divisor
;	r7 = sign of quotient
; Uses:	r7,r12,r13
; Cycles:	140-176
; Bytes:	53

rdividendlo	equr	4
rdividendhi	equr	5
rdivisor	equr	6
rdivsign	equr	7


mdivs3216_s
	mcache

	from	rdividendhi
	to	rdivsign
	xor	rdivisor	; = 3

	sub	r0	
	moves	rdivisor,rdivisor
	bpl	.16m
;	nop
	to	rdivisor
	sub	rdivisor
.16m				; = 6/7

	moves	rdividendhi,rdividendhi
	bpl	.32p
;	nop
	to	rdividendlo
	sub	rdividendlo
	to	rdividendhi
	sbc	rdividendhi
.32p				; = 5/9

; unsigned divide

	with	rdividendlo	; 1
	add	rdividendlo	; 1
	from	rdividendhi	; 1
	rol			; 1
	ibt	r12,#16		; 2
	move	r13,pc		; 2 = 8

mdivs3216loop_s
	sub	rdivisor	; 1
	bcc	mdivs3216cc_s	; 2
	nop			; 1
	with	rdividendlo	; 1
	rol		        ; 1
	loop		        ; 1
	rol			; 1 = 8

	bra	mdivs3216end_s	; 1
	nop			; 1

mdivs3216cc_s
	add	rdivisor	; 1
	with	rdividendlo	; 1
	add	rdividendlo	; 1
	loop			; 1
	rol			; 1 = 9

; sign result

mdivs3216end_s
	moves	rdivsign,rdivsign
	bpl	mdivs3216rts_s
;	nop
	with	rdividendlo
	not
	inc	rdividendlo

mdivs3216rts_s	; 5/7 
	jmp	r11
	nop




;**********************************************************
;**
;** MSCALEXZ (air or slope)
;** m_bigx = vec x
;** m_bigz = vec z
;**
;**********************************************************

mscalexz_a
	iwt	r7,#$7800	; almost zero friction
	bra	mscalexz
	nop
mscalexz_s
	iwt	r7,#$2000	; $6000
mscalexz
	sub	r0
	romb
	ramb

	lms	r0,[m_bigx]
	move	r6,r7
	add	r0		; friction
	fmult
	sms	[m_bigx],r0


	lms	r0,[m_bigz]
	move	r6,r7
	add	r0		; friction
	fmult
	sms	[m_bigz],r0

	stop
	nop

;**********************************************************
;**
;** MSLOPEBOUNCE
;** m_bigx = vec x
;** m_bigy = vec y
;** m_bigz = vec z
;** m_spra = x normal
;** m_sprb = y normal
;** m_sprc = z normal
;** m_sprd = bouncyness (fraction) 0-ffffh
;** m_spr0 = distance beneath slope (momentum of slope)
;**
;** Exit: m_bigx,m_bigy,m_bigz = new vec x,y,z.
;**
;** val = m_bigx*m_spra + m_bigy*m_spry + m_bigz*m_sprc
;**
;** m_bigx += m_spra*val+m_spra*m_spr0
;** m_bigy += m_sprb*val+m_sprb*m_spr0
;** m_bigz += m_sprc*val+m_sprc*m_spr0
;**
;** m_bigx *= m_sprd
;** m_bigy *= m_sprd
;** m_bigz *= m_sprd
;**
;**********************************************************


mslopebounce
	sub	r0
	romb
	ramb

	miwt	r10,m_stack&WM

; first, r1 = x*nx+y*ny+z*nz

	lms	r0,[m_bigx]
	lms	r6,[m_spra]
	add	r0
	to	r1
	fmult			; x*nx

	lms	r0,[m_bigy]
	lms	r6,[m_sprb]
	add	r0
	fmult	
	to	r1
	add	r1		; + y*ny

	lms	r0,[m_bigz]
	lms	r6,[m_sprc]
	add	r0
	fmult
	to	r1
	add	r1		; + z*nz

; then multiply the normals by r1
	lms	r2,[m_bigx]
	lms	r3,[m_bigy]
	lms	r4,[m_bigz]
	lms	r5,[m_sprd]	; bounciness
	lms	r7,[m_spr0]	; slope velocity

	iwt	r7,#0
	iwt	r5,#$4000	; no bounce

	with	r1
	add	r1

	lms	r8,[m_spra]
	move	r6,r7
	from	r8
	fmult
	to	r9
	add	r0
	
	move	r6,r1
	from	r8
	fmult
	move	r6,r5
	add	r0
	fmult			; bigx += r1*nx*scale
	add	r0
	add	r2
	add	r9
	sms	[m_bigx],r0

	lms	r8,[m_sprb]
	iwt	r0,#-1
	to	r6
	xor	r7
	from	r8
	fmult
	to	r9
	add	r0

	iwt	r0,#-1
	to	r6
	xor	r1
	from	r8
	fmult
	move	r6,r5
	add	r0
	fmult			; bigy += r1*ny*scale
	add	r0
	add	r3
	add	r9
	sms	[m_bigy],r0

	lms	r8,[m_sprc]
	move	r6,r7
	from	r8
	fmult
	to	r9
	add	r0
	lms	r0,[m_sprc]
	move	r6,r1
	from	r8
	fmult
	move	r6,r5
	add	r0
	fmult			; bigz += r1*nz*scale
	add	r0
	add	r4
	add	r9
	sms	[m_bigz],r0


	stop
	nop

;************************************************************
;**
;** mveclen
;**
;** calculates |R| (m_z1)
;** where R = bigx+bigy+bigz
;**
;**     _____________________________
;**    /
;**  \/ bigx*bigx+bigy*bigy+bigz*bigz
;**
;************************************************************

rsqr	equr	5
rsqrhi	equr	4
rsqrt	equr	6
mveclen
	sub	r0
	romb
	ramb

	iwt	r10,#m_stack&WM

	lms	r0,[m_bigx]
	move	r6,r0
	lmult

	move	r1,r0
	move	r2,r4
	

	lms	r0,[m_bigy]
	move	r6,r0
	lmult

	with	r2
	add	r4
	to	r1
	adc	r1

	lms	r0,[m_bigz]
	move	r6,r0
	lmult

	with	r2
	add	r4
	to	r1
	adc	r1

; now for the sqroot (r1,r2)

	move	rsqrhi,r1
	move	rsqr,r2

	mcall	msqrt32_s
	nop

	sms	[m_z1],rsqrt

	stop
	nop



;************************************************

; Approx. unsigned 32 bit by 16 bit divide
; with 16 bit quotient
;
; In:	r0 = dividend.h
;	r4 = dividend.l
;	r6 = divisor
; Out:	r0 = remainder
;	r4 = quotient
;	r6 = divisor
; Uses:	r12,r13
; Cycles:	150-171
; Bytes:	39

mdivu3216_s 			; NB this is not accurate!
	mtest	r0
	bmi	mdivu3216m_s	; if divisor > $7fff 
	nop
	mtest	rdivisor
	bpl	mdivu3115_s	; or dividend > $7fffffff
	nop
mdivu3216m_s	  		; then halve divisor and dividend
	with	rdivisor
	lsr
	lsr
	with	rdividendlo
	ror


;************************************************

; Unsigned 31 bit by 15 bit divide
; with 16 bit quotient and 15 bit remainder
;
; In:	r0 = dividend.h
;	r4 = dividend.l
;	r6 = divisor
; Out:	r0 = remainder
;	r4 = quotient
;	r6 = divisor
; Uses:	r12,r13
; Cycles:	137-153
; Bytes:	24


mdivu3115_s
	ibt	r12,#16		; 2
	with	rdividendlo	; 1	asl32	r0,rdividendlo 
	add	rdividendlo	; 1
	rol			; 1
	move	r13,pc		; 2 = 7

mdivu3115loop_s
	sub	rdivisor	; 1
	bcc	mdivu3115cc_s	; 2
	nop			; 1
	with	rdividendlo	; 1
	rol		        ; 1
	loop		        ; 1
	rol			; 1 = 8

	jmp	r11		; 1
	lsr			; 1

mdivu3115cc_s
	add	rdivisor	; 1
	with	rdividendlo	; 1
	add	rdividendlo	; 1
	loop			; 1
	rol			; 1 = 9

	jmp	r11
	lsr

;*********************************************88
; normalise a 16 bit x,y,z vector in r1,r2,r3

rx	equr	1
ry	equr	2
rz	equr	3
rxhi	equr	7
ryhi	equr	8
rshiftcnt	equr	9

rsqrhi	equr	4
rsqr	equr	5
rsqrt	equr	6
rt2	equr	7
rt	equr	8

mnormalise16_s
	mpush	r11

	mmul	rx,rx
	mmuladd	ry,ry
	mmuladd	rz,rz		; r0,r5 = x*x + y*y + z*z

	mtest	r0
	bne	.1		; check for r0,r5 = 0
	nop
	mtest	r5
	bne	.1
	nop
	ibt	rx,#0
	ibt	ry,#0
	ibt	rz,#0
	mpop	pc
	nop
.1
;	move	rsqr,r5
	move	rsqrhi,r0
	mcall	msqrt32_s	; rsqrt = sqrt(rsqrhi,rsqr)
	nop
	move	r0,rsqrt

	ibt	rshiftcnt,#0
.vnormlp
	lsr
	beq	.novalshft
	nop
	bra	.vnormlp
	inc	rshiftcnt
.novalshft

	sub	r0
	miwt	r4,32767	; r0,r4 = 32767

	moves	r12,rshiftcnt
	beq	.noshift
	nop

	move	r13,pc
.shift
	with	r4
	add	r4
	loop
	rol
.noshift

	move	r6,rsqrt
	mcall	mdivu3216_s	; r4 = r0,r4 / r6
	nop
	move	r6,r4

	from	rx
	to	rxhi
	lmult
	move	rx,r4

	from	ry
	to	ryhi
	lmult
	move	ry,r4

	from	rz
	lmult
	move	rz,r4

	moves	r12,rshiftcnt
	beq	.noshift2
	nop

	move	r13,pc
.shift2
	with	rxhi
	asr
	with	rx
	ror

	with	ryhi
	asr
	with	ry
	ror

	asr
	with	rz
	ror

	loop
	nop
.noshift2

	mpop	pc
	nop




;****************************************************************************
;**
;** mdividevecs
;**
;** calculates the unit vector and multiplies it by m_x1
;** ie. it resizes a vector (the direction is kept)
;**     mdividevecs(mveclen()) == original vector (give or take a few errors)
;**
;****************************************************************************



mdividevecs
	sub	r0
	romb
	ramb

	iwt	r10,#m_stack&WM

	lms	r1,[m_bigx]
	lms	r2,[m_bigy]
	lms	r3,[m_bigz]
	mcall	mnormalise16_s
	nop

	lms	r6,[m_x1]
	with	r6
	add	r6

	from	r1
	fmult
	sms	[m_bigx],r0

	from	r2
	fmult
	sms	[m_bigy],r0

	from	r3
	fmult
	sms	[m_bigz],r0

	stop
	nop


;**********************************************************************
;**
;** mwhichside
;**
;** bigx*x1+bigy*y1+bigz*z1 = m_spra
;**
;**********************************************************************

mwhichside
	sub	r0
	romb
	ramb


; first, r1 = x*nx+y*ny+z*nz

	lms	r0,[m_bigx]
	lms	r6,[m_x1]
	add	r0
	to	r1
	fmult			; x*nx

	lms	r0,[m_bigy]
	lms	r6,[m_y1]
	add	r0
	fmult	
	to	r1
	add	r1		; + y*ny

	lms	r0,[m_bigz]
	lms	r6,[m_z1]
	add	r0
	fmult
	add	r1		; + z*nz

	sms	[m_spra],r0	; store the result
	

	stop
	nop


;**********************************************************************
;**
;** mrevec    
;**
;** spra*x1+bigx -> bigx
;** spra*y1+bigy -> bigy
;** spra*z1+bigz -> bigz
;**
;**********************************************************************


mrevec
	sub	r0
	romb
	ramb

	lms	r0,[m_spra]
	to	r6
	not
	inc	r6

	lms	r0,[m_x1]
	add	r0
	fmult			; x1*spra
	lms	r1,[m_bigx]
	add	r1		; + bigx
	sbk

	lms	r0,[m_y1]
	add	r0
	fmult			; y1*spra
	lms	r1,[m_bigy]
	add	r1		; + bigy
	sbk

	lms	r0,[m_z1]
	add	r0
	fmult			; z1*spra
	lms	r1,[m_bigz]
	add	r1		; + bigz
	sbk


	stop
	nop


;**********************************************************
; MWithinPoly
;
; Go through a list of polygon points and check if the position
; M_BIGX and M_BIGZ is within the polygon's bounds.
;
; M_BIGX = x relative to slope's centre
; M_BIGY = z relative to slope's centre
;
; M_PNTPTR = list of word points (first byte is count)
; returns M_PNTPTR = -1 if point is outside polygon

mwp_scale	MACRO	[reg]

	lms	{reg},[m_scale]
	moves	{reg},{reg}
	beq	.ns\@

.l\@	dec	{reg}
	bne	.l\@
	add	r0		; scale it up
.ns\@
	move	{reg},r0
	ENDM

MWithinPoly
	ibt	r0,#$70
	ramb
	ibt	r0,#slopedata>>16
	romb

	lms	r14,[m_pntptr]

	lms	r1,[m_bigx]
	lms	r2,[m_bigz]

	to	r12
	getb
	inc	r14

	dec	r12

	mcache

; get first x coord
	getbs
	inc	r14

	mwp_scale	r7

; get first z coord
	getbs
	inc	r14

	mwp_scale	r8

	move	r13,r15
.loop

; get next x coord
	getbs
	inc	r14

	mwp_scale	r9

; get next z coord
	getbs
	inc	r14

	mwp_scale	r10

; calculate coords into relative values (r3,r5 are free)

	from	r9
	to	r3
	sub	r7	; r3 = dx1

	from	r10
	to	r5
	sub	r8	; r5 = dz1

	from	r1
	to	r7
	sub	r7	; r7 = dx2

	from	r2
	to	r8
	sub	r8	; r8 = dz2

; now to cross multiply dz1*dx2 - dz2*dx1

	move	r6,r8
	with	r3
	lmult		; r3(h):r4(l) = dz2*dx1
	move	r8,r4	; r3:r8 = result
	
	move	r6,r5
	with	r7
	lmult		; r7(h):r4(l) = dz2*dx1
	move	r5,r4	; r7:r5 = result

	with	r5
	sub	r8
	with	r7
	sbc	r3	; subtract the two results

	bmi	.reject

	move	r7,r9	; old x = new x
	move	r8,r10	; old z = new z
	loop
	nop

	ibt	r0,#0
	bra	.zeroit
	nop
.reject	ibt	r0,#-1
.zeroit	sms	[m_pntptr],r0

	stop
	nop


;**********************************************************
; MRotatePoint
;
; Rotates m_x1, m_z1 by m_roty
;


MRotatePoint
	ibt	r0,#sintab>>16
	romb
	ibt	r0,#$70
	ramb

	iwt	r10,#m_stack&WM

	lms	r0,[m_x1]
	add	r0
	to	r1
	add	r0
	lms	r0,[m_z1]
	add	r0
	to	r3
	add	r0
	lms	r0,[m_roty]
	to	r2
	lob

	mcall	mrotpnty_s	; go ahead and rotate
	nop

	sms	[m_x1],r3
	sms	[m_z1],r1

	stop
	nop


;**********************************************************
; MClosestLine
;
; Goes through a list of polygon points and checks which side
; M_BIGX and M_BIGZ is closest to and then generates a 'clip'
; along the side where the normal would cross.
;
; M_BIGX = x relative to slope's centre
; M_BIGY = z relative to slope's centre
;
; M_PNTPTR = list of word points (first byte is count)
; returns M_PNTPTR = -1 if point is outside polygon
;
; Method:
; This calculates a normal to the line and then makes one of the
; points of the line relative to m_bigx,m_bigz. (ie. m_bigx,m_bigz = origin)
; Then the distance to the line is calculated by the following:
; d = x*nx + z*nz (nx,nz = normal, x,z = relative point anywhere along line)
;
; To calculate the 'clipped' point, d+1 is multiplied by the normal and added
; to m_bigx and m_bigz.

rbx	equr	r1
rbz	equr	r2

rx1	equr	r7
rz1	equr	r8

rx2	equr	r3
rz2	equr	r5

rnx	equr	r7
rnz	equr	r8

rclosest	equr	r13

MClosestLine
	ibt	r0,#$70
	ramb
	ibt	r0,#slopedata>>16
	romb

	iwt	r10,#m_stack&WM

	lms	r14,[m_pntptr]

	lms	rbx,[m_bigx]
	lms	rbz,[m_bigz]

	to	r12
	getb
	inc	r14

	dec	r12

;------------------
; get first x coord
;------------------

	getbs
	inc	r14

	mwp_scale	rx1

;------------------
; get first z coord
;------------------

	getbs
	inc	r14

	mwp_scale	rz1

	ibt	rclosest,#-1	; set default distance to 65535

	mcache

;------------------
; begin the loop
;------------------
.loop

	mpush	r12
;------------------
; get next x coord
;------------------

	getbs
	inc	r14

	mwp_scale	rx2

;------------------
; get next z coord
;------------------

	getbs
	inc	r14

	mwp_scale	rz2

;---------------------------------------------------------------------
; Calculate the normal (first rotating the vector through 90 degrees)
;---------------------------------------------------------------------

	mpush	rclosest

	mpush	rx2
	mpush	rz2
	mpush	rbx
	mpush	rbz

	from	rx2
	to	r3	; set vx (x2-x1)
	sub	rx1
	mneg	r3	; z = -vx

	from	rz2	; set vz (z2-z1)
	to	r1
	sub	rz1	; x = vz

	ibt	r2,#0	; zero y
	
	mcall	mnormalise16_s
	nop

	move	rnx,r1
	move	rnz,r3		; nx,nz

	mpop	rbz
	mpop	rbx
	mpop	rz2
	mpop	rx2

;---------------------------------------------------------
; Now to calculate D = (nx*(rx2-rbx)+nz*(rz2-rbz))
;---------------------------------------------------------

	move	r6,rnx
	from	rx2
	sub	rbx
	add	r0	; *2
	to	rclosest ; store result of (nx*(rx2-rbx)
	fmult

	move	r6,rnz
	from	rz2
	sub	rbz
	add	r0	; *2
	fmult
	add	rclosest ; add previously stored result

	bpl	.ok
	nop
	mneg	r0	; if negative make it positive
.ok
	mpop	rclosest

	cmp	rclosest
	bcs	.notclose
	nop

	move	rclosest,r0
	sms	[m_spra],rnx
	sms	[m_sprc],rnz	; store the closest normal

.notclose
;------------------
; end of loop
;------------------

	move	rx1,rx2	; old x = new x
	move	rz1,rz2	; old z = new z

	mpop	r12
;------------------
	dec	r12
	mlbne	.loop
;------------------
	sms	[m_pntptr],rclosest

;------------------
; now to calculate the new 'clipped' coordinates

	lms	rnx,[m_spra]
	lms	rnz,[m_sprc]

	with	rclosest
	add	#6	 ; this value is mainly to correct math errors
	with	rclosest ; and to make sure the object definitely isn't within the polygon
	add	rclosest	; multiply by 2 and add 4

	move	r6,rclosest
	from	rnx
	fmult
	sms	[m_bigx],r0
	
	move	r6,rclosest
	from	rnz
	fmult
	sms	[m_bigz],r0

	
;------------------

	stop
	nop




;****************************************************


	ifne	1

; Y rotate 16 bit x,z pos by 8 bit angle
;
; In:	rx = x pos
;	rz = z pos
;	ryrot = y rot angle
;
; Out:	rx = y rotated x pos
;	rz = y rotated x pos
;
; Dead: r0-r9

rx	equr	1
ryrot	equr	2
rt	equr	2
rz	equr	3
rcosy	equr	5
rprodlo	equr 7
rprodhi	equr 8
rsiny	equr	9

mrotpnty_s
	mpush	r11
	
	miwt	r0,costab
	to	r14
	add	ryrot
	getb
	to	rcosy
	swap

	miwt	r0,sintab
	to	r14
	add	ryrot
	getb
	to	rsiny
	swap

	move	r6,rx
	from	rsiny
	to	rprodhi
	lmult
	move	rprodlo,r4

	move	r6,rz
	from	rcosy
	lmult
	with	rprodlo
	add	r4
	adc	rprodhi
	to	rt
	asr

	move	r6,rz
	from	rsiny
	to	rprodhi
	lmult
	move	rprodlo,r4

	move	r6,rx
	from	rcosy
	lmult
	with	rprodlo
	sub	r4
	sbc	rprodhi
	to	rz
	asr

	move	rx,rt

	mpop	pc
	nop
;	jmp	r11
;	nop
	
	endc

