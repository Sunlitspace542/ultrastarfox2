;-----------------------------------------------
;
;	 MPLANCLP.MC		Carl Graham 1994
;

* Set up a plane equation as part of a shape definition.
* The plane can then be used for clipping later objects



 IFEQ mpolylist
	ERROR	<Polygon list only>
 ENDC

;------------------------------------------------------------------------
; Shape language command to setup a plane equation as part of a shape def

rx	equr	1
ry	equr	2
rz	equr	3

rx2	equr	7
ry2	equr	8
rz2	equr	9

rsumlo	equr	7
routptr equr	9

rmmat11	equr	10
rmmat21	equr	11
rmmat31	equr	13

rmmat12	equr	4
rmmat22	equr	7
rmmat32	equr	8


msh_clip_plane

	lms	r0,[m_objflags]	;- Skip if shadow
	miwt	r1,drawshadow
	and	r1
	beq	.isns
	nop
.ex	with	rshapeptr
	add	#13
	mshape_rts			;- Next shape cmd
	

.isns
	getb
	inc	rshapeptr

	sm	[m_cl_pn],r0	;- Save plane number

	ibt	r12,#2		; define plane from 2 16 bit points
				; 4095 apart representing the normal 
				; to the plane
	miwt	routptr,m_cl_plane

	sms	[m_sp],rsp		; Save stack pointer

	lms	rmmat11,[m_mat11]	; First two cols of matrix
	lms	rmmat21,[m_mat21]	; into regs
	lms	rmmat31,[m_mat31]
	lms	rmmat12,[m_mat12]
	lms	rmmat22,[m_mat22]
	lms	rmmat32,[m_mat32]

	
.1
	mgetwi	rx		; get x,y,z
	mgetwi	ry
	mgetwi	rz
				; Mult by matrix (rotate)
	mdotprod16mqr	rmmat11,rmmat21,rmmat31	; uses r5,r6
	mstwi	routptr
	mdotprod16mqr	rmmat12,rmmat22,rmmat32	; uses r5,r6
	mstwi	routptr
	mdotprod16mq	m_mat13,m_mat23,m_mat33	; uses r5,r6
	mstwi	routptr

	dec	r12
	bne	.1		; Get second point
	nop

	lms	rsp,[m_sp]		; restore stack pointer

; Generate plane equation from two rotated points
				;----------

	lm	r6,[m_cl_p2x]	; dx
	lm	rx,[m_cl_p1x]
	from	r6
	sub	rx

	add	r0		; r6 = dx<<3
	add	r0
	to	r6
	add	r0

	from	r6
	sbk

	lms	r0,[m_bigx]
	to	rx
	add	rx

	to	rx2		; x component d
	from	rx
	fmult
	with	rx2
	adc	rx2
				;----------

	lm	r6,[m_cl_p2y]	; dy
	lm	ry,[m_cl_p1y]
	from	r6
	sub	ry

	add	r0		; r6 = dy<<3 
	add	r0
	to	r6
	add	r0
	from	r6
	sbk
	

	lms	r0,[m_bigy]
	to	ry
	add	ry

	to	ry2		; y component d
	from	ry
	fmult
	with	ry2
	adc	ry2
				;----------

	lm	r6,[m_cl_p2z]	; dz
	lm	rz,[m_cl_p1z]
	from	r6
	sub	rz

	add	r0		; r6= dz<<3
	add	r0
	to	r6
	add	r0
	from	r6
	sbk

	lms	r0,[m_bigz]
	to	rz
	add	rz

	from	rz		; z component d
	fmult
	adc	r0
				;----------

	add	rx2		; add components
	add	ry2
	sm	[m_cl_pd],r0

	lm	r0,[m_cl_pn]	;- store in plane array
	dec	r0
	umult	#8
	miwt	r1,m_cl_pls
	with	r1
	add	r0

	lm	r0,[m_cl_p1x]	;- a
	mstwi	r1

	lm	r0,[m_cl_p1y]	;- b
	mstwi	r1

	lm	r0,[m_cl_p1z]	;- c
	mstwi	r1

	lm	r0,[m_cl_pd]	;- d
	mstwi	r1

	mshape_rts			; Next shape cmd

;--- end --- msh_clip_plane --------------




;------------------------------------------------------------
;
; Setup plane equation for y= n
;
; Called from start of drawist
;
; IN-
; R0 : Plane Y
; R1 : Plane number

rx	equr	1
ry	equr	2
rz	equr	3

rx2	equr	7
ry2	equr	8
rz2	equr	9

rsumlo	equr	7
routptr equr	9

rmmat11	equr	10
rmmat21	equr	11
rmmat31	equr	13

rmmat12	equr	4
rmmat22	equr	7
rmmat32	equr	8


mGen_clip_plane
	mpush	r11

	sm	[m_cl_pn],r1	;- Save plane number

; Define plane from 2 points 4095 apart representing the normal 
; to the plane
	miwt	routptr,m_cl_plane


	sms	[m_sp],rsp		; Save stack pointer

	lms	rmmat11,[m_wmat11]	; First two cols of matrix
	lms	rmmat21,[m_wmat21]	; into regs
	lms	rmmat31,[m_wmat31]
	lms	rmmat12,[m_wmat12]
	lms	rmmat22,[m_wmat22]
	lms	rmmat32,[m_wmat32]

	

	ibt	rx,#0	; get x,y,z

	move	ry,r0
	lms	r0,[m_viewposy]
	with	ry
	sub	r0

	ibt	rz,#0

				; Mult by matrix (rotate)
	mdotprod16mqr	rmmat11,rmmat21,rmmat31	; uses r5,r6
	mstwi	routptr
	mdotprod16mqr	rmmat12,rmmat22,rmmat32	; uses r5,r6
	mstwi	routptr
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33	; uses r5,r6
	mstwi	routptr


	;- flip normal to face at cammera
	mtest	ry
	bpl	.reverse
	 nop

	iwt	r0,#4095
	with	ry
	bra	.norm
	 add	r0

.reverse
	iwt	r0,#-4095
	with	ry
	add	r0
.norm
				; Mult by matrix (rotate)
	mdotprod16mqr	rmmat11,rmmat21,rmmat31	; uses r5,r6
	mstwi	routptr
	mdotprod16mqr	rmmat12,rmmat22,rmmat32	; uses r5,r6
	mstwi	routptr
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33	; uses r5,r6
	mstwi	routptr


	lms	rsp,[m_sp]		; restore stack pointer

; Generate plane equation from two rotated points
				;----------

	lm	r6,[m_cl_p2x]	; dx
	lm	rx,[m_cl_p1x]
	from	r6
	sub	rx
	add	r0
	add	r0
	to	r6
	add	r0

	from	r6
	sbk

	to	rx2		; x component d
	from	rx
	fmult
	with	rx2
	adc	rx2
				;----------

	lm	r6,[m_cl_p2y]	; dy
	lm	ry,[m_cl_p1y]
	from	r6
	sub	ry
	add	r0
	add	r0
	to	r6
	add	r0
	from	r6
	sbk
	

	to	ry2		; y component d
	from	ry
	fmult
	with	ry2
	adc	ry2
				;----------

	lm	r6,[m_cl_p2z]	; dz
	lm	rz,[m_cl_p1z]
	from	r6
	sub	rz
	add	r0
	add	r0
	to	r6
	add	r0
	from	r6
	sbk

	from	rz		; z component d
	fmult
	adc	r0
				;----------

	add	rx2		; add components
	add	ry2
	sm	[m_cl_pd],r0


	lm	r0,[m_cl_pn]	;- store in plane array
	dec	r0
	umult	#8
	miwt	r1,m_cl_pls
	with	r1
	add	r0

	lm	r0,[m_cl_p1x]	;- a
	mstwi	r1

	lm	r0,[m_cl_p1y]	;- b
	mstwi	r1

	lm	r0,[m_cl_p1z]	;- c
	mstwi	r1

	lm	r0,[m_cl_pd]	;- d
	mstwi	r1

	mpop	pc
	 nop

;-- end --- mGen_clip_plane -------------------

	


;------------------------------------------------------------
;
; Calc distance from plane of all verts
;
; Called from endpoints before project
;

rplannum	equr	1	;- Entry hold plane number
rplx	equr	2
rply	equr	3
rplz	equr	4
rpld	equr	5
rpolyptr	equr	6

rrotptr	equr	7
rvdptr	equr	8
raccd	equr	9

mcalc_d_verts
	mcache
	miwt	rrotptr,m_rotpnts	;- ptr to source rot points
	miwt	rvdptr,m_vert_d	;- ptr to output buffer

	miwt	raccd,-1		;- check sign all verts d

;- Get plane equation
	miwt	r0,m_cl_pls		;- Plane array addr
	dec	rplannum
	with	rplannum
	umult	#8
	with	rplannum
	add	r0

	to	rplx
	mldwi	rplannum
	sm	[m_cl_p1x],rplx

	to	rply
	mldwi	rplannum
	sm	[m_cl_p1y],rply

	to	rplz
	mldwi	rplannum
	sm	[m_cl_p1z],rplz

	to	rpld
	mldwi	rplannum
	sm	[m_cl_pd],rpld

	lms	r6,[m_bigx]		;- x comp obj center
	from	rplx
	to	r1
	fmult
	with	r1
	adc	r1

	lms	r6,[m_bigy]	     	;- y comp obj center
	from	rply
	fmult
	adc	r0
	to	r1
	add	r1

	lms	r6,[m_bigz]	     	;- z comp obj center
	from	rplz
	fmult
	adc	r0
	add	r1

	with	rpld		;- adjust d for center
	sub	r0
;	sm	[m_cl_obj_pd],rpld

; do each vert
	lms	r12,[m_numpnts]
	move	r13,pc

	to	r6  		;- x comp
	mldwi	rrotptr
	from	rplx
	to	r1
	fmult
	with	r1
	adc	r1

	to	r6	     	;- y comp
	mldwi	rrotptr
	from	rply
	fmult
	adc	r0
	to	r1
	add	r1

	to	r6	     	;- z comp
	mldwi	rrotptr
	from	rplz
	fmult
	adc	r0
	add	r1

	sub	rpld		;- sub plane d

	to	raccd		;- check sign in
	and	raccd

	stw	[rvdptr]		;- Store in m_vert_d
	inc	rvdptr
	loop			;- next
	inc	rvdptr

	from	raccd
	hib
	sex
	hib
	sex
	jmp	r11
	inc	r0		;- nz = some verts ok


;-- end -- mcalc_d_verts ------------------




;------------------------------------------------------------
;
; Check verts of a polygon against clip plane using vals for d
; from m_vert_d
;
; To be called from mchkpoly
;

rdtabptr	equr	2
rdtabbsptr	equr	3
randd	equr	4
rord	equr	5
rshapeptr	equr	14

mplane_check

	lms	r12,[m_fnumpnts]

	with	rshapeptr	;- Back up shape pointer to start poly
	sub	r12

	miwt	rdtabbsptr,m_vert_d

	ibt	rord,#0
	ibt	randd,#-1

	move	r13,pc

	getb		;- Next vert index
	inc	rshapeptr

	add	r0	;- Look up d
	to	rdtabptr
	add	rdtabbsptr
	to	r1
	ldw	[rdtabptr]

	with	randd
	and	r1

	with	rord
	or	r1

	loop
	 nop

	mtest	rord
	bmi	.n
	 sub	r0
	inc	r0
.n	
	sm	[m_cl_face],r0

	mtest	randd	;- exit zero if all behind
	bmi	.out
	sub	r0
	inc	r0
.out	
 	jmp	r11
	 nop


;-- End -- mplane_check ---------------------------




;---------------------------------------------------------
;
; Clip polygon to 3d plane
;
rd1	equr	1
rd2	equr	2
rpv	equr	3

routcode	equr	5
rtempd	equr	5
rnumpnts	equr	9
rcpolyptr	equr	8
rpolyptr	equr	9
rptcnt	equr	14

m3d_planeclip
	mpush	r11		;- ret addr on stack

	mpush	rshapeptr		;- save pointer to shape

	mpush	r6		;- rpolybuf ( end poly hdr)

	mpush	r7		;- rpolyptr ( end poly )

	mpush	routcode

	
	lms	r0,[m_fnumpnts]	;- check poly type
	dec	r0
	dec	r0
	mlbeq	m3d_planeclipline	;- is line ?

;- is poly

	lms	r0,[m_texturemap]	;- is texture map ?
	mtest	r0
	mlbne	m3d_planecliptexture

;- is not texture map

	lms	rnumpnts,[m_fnumpnts]
	sms	[m_cnt],rnumpnts

	with	rshapeptr		;- reset to start of poly points
	sub	rnumpnts

	mcall	mrebuild_poly_withd	;- create d,x,y,z version
	 nop

	ibt	rptcnt,#0		;- number output points

	miwt	rpolyptr,m_polybuf	;- input ptr

	miwt	rcpolyptr,m_clippolybuf	;- output ptr

.vertloop
	ldw	[rpolyptr]		;- First d
	mtest	r0
	bmi	.behind
	 nop

	inc	rpolyptr		;- output vertex without d
	inc	rpolyptr

	mldwi	rpolyptr		;- x
	mstwi	rcpolyptr
	
	mldwi	rpolyptr		;- y
	mstwi	rcpolyptr
	
	ldw	[rpolyptr]		;- z
	mstwi	rcpolyptr

	inc	rptcnt		;- vertex count

	with	rpolyptr		;- backup input ptr
	sub	#6
	
.behind
	mcall	mintplane		;- calc intersection with plane
	 nop

	lms	r0,[m_fnumpnts]
	dec	r0
	bne	.vertloop
	 sbk
	
	sm	[m_cl_tmp],rptcnt	;***** debug

	from	rptcnt		;- check: is still a poly ?
	sub	#3
	bmi	.exit
	 nop
	

	sms	[m_cnt],rptcnt	;- save vertex count

	sm	[m_xyz_avail],rptcnt	;- Flag xyz version exists

	dec	rsp		;- discard outcode off stack
	dec	rsp

	mpop	rprojptr		;- polybuf ptr

	dec	rsp		;- discard old polylistptr
	dec	rsp

	mpush	rprojptr		;- polybuf ptr (temp)

	mcall	mplclipproj		;- project vert
	 nop
   	
	move	r6,rprojptr		;- set new end poly

	mpop	r7		;- restore end poly hdr

	lms	routcode,[m_or_of_outcodes]
	lms	r0,[m_fnumpnts]

	dec	r7
	dec	r7

	stb	[r7]

	inc	r7
	inc	r7

	mpop	rshapeptr
	mpop	pc
             nop




.exit		          		;- abort fail exit
	sub	r0
;	sms	[m_cnt],r0
	sms	[m_fnumpnts],r0
	mpop	routcode
	mpop	r7		;- rpolybuf ( end poly hdr)
	mpop	r6		;- rpolyptr ( end poly )
	mpop	rshapeptr
	mpop	pc
	 nop







rprojptr	equr	8


;- Clip line to a 3d plane

m3d_planeclipline
	

	lms	r0,[m_texturemap]	;- is texturemapped ? ?
	mtest	r0
	mlbne	.exit

	lms	rnumpnts,[m_fnumpnts]
	sms	[m_cnt],rnumpnts
	with	rshapeptr		;- reset to start of poly points
	sub	rnumpnts


	mcall	mrebuild_poly_withd	;- create d,x,y,z version
	 nop

	ibt	rptcnt,#0		;- number output points

	miwt	rpolyptr,m_polybuf	;- input ptr

	miwt	rcpolyptr,m_clippolybuf	;- output ptr

	ldw	[rpolyptr]		;- First d
	mtest	r0
	bmi	.p1bh
	 nop

	inc	rpolyptr		;- output p1
	inc	rpolyptr
	mldwi	rpolyptr		;- x
	mstwi	rcpolyptr
	
	mldwi	rpolyptr		;- y
	mstwi	rcpolyptr
	
	ldw	[rpolyptr]		;- z
	mstwi	rcpolyptr

	inc	rptcnt

	with	rpolyptr		;- backup input ptr
	sub	#6
	
.p1bh
	mcall	mintplane		;- calc intersection with plane
	 nop

	ldw	[rpolyptr]		;- Last d

	mtest	r0
	bmi	.p2bh
	 nop

	inc	rpolyptr		;- output p2
	inc	rpolyptr
	mldwi	rpolyptr		;- x
	mstwi	rcpolyptr
	
	mldwi	rpolyptr		;- y
	mstwi	rcpolyptr
	
	ldw	[rpolyptr]		;- z
	mstwi	rcpolyptr

	inc	rptcnt
	
.p2bh
;	sm	[m_cl_tmp],rptcnt	;***** debug

	ibt	r0,#2		;- check: is still a line ?
	sub	rptcnt
	bne	.exit
	 nop
	

	sms	[m_cnt],rptcnt	;- save vertex count

	sm	[m_xyz_avail],rptcnt	;- Flag xyz version exists

	dec	rsp		;- discard outcode of stack
	dec	rsp

	mpop	rprojptr		;- polybuf ptr

	dec	rsp		;- discard old polylistptr
	dec	rsp

	mpush	rprojptr		;- polybuf ptr (temp)

	mcall	mplclipproj		;- project vert
	 nop
   	
	move	r6,rprojptr		;- set new end poly

	mpop	r7		;- restore end poly hdr

	lms	routcode,[m_or_of_outcodes]
	lms	r0,[m_fnumpnts]

	mpop	rshapeptr
	mpop	pc
             nop




.exit		          		;- abort fail exit
	sub	r0
	sms	[m_cnt],r0
	sms	[m_fnumpnts],r0
	mpop	routcode
	mpop	r7		;- rpolybuf ( end poly hdr)
	mpop	r6		;- rpolyptr ( end poly )
	mpop	rshapeptr
	mpop	pc
	 nop





m3d_planecliptexture
	lms	rnumpnts,[m_fnumpnts]
	sms	[m_cnt],rnumpnts

	with	rshapeptr		;- reset to start of poly points
	sub	rnumpnts


;- uses R6 as as external rpolybuf
	mcall	mrebuild_txpoly_withd	;- create d,x,y,z version
	 nop

	ibt	rptcnt,#0		;- number output points

	miwt	rpolyptr,m_polybuf	;- input ptr

	miwt	rcpolyptr,m_clippolybuf	;- output ptr

.vertloop
	ldw	[rpolyptr]		;- First d
	mtest	r0
	bmi	.behind
	 nop

	inc	rpolyptr		;- output vertex without d
	inc	rpolyptr

	mldwi	rpolyptr		;- x
	mstwi	rcpolyptr
	
	mldwi	rpolyptr		;- y
	mstwi	rcpolyptr
	
	mldwi	rpolyptr		;- z
	mstwi	rcpolyptr
	
	mldwi	rpolyptr		;- u
	mstwi	rcpolyptr
	
	ldw	[rpolyptr]		;- v
	mstwi	rcpolyptr

	inc	rptcnt		;- vertex count

	with	rpolyptr		;- backup input ptr
	sub	#10
	
.behind
	mcall	mtxintplane		;- calc intersection with plane
	 nop

	lms	r0,[m_fnumpnts]
	dec	r0
	bne	.vertloop
	 sbk
	
;	sm	[m_cl_tmp],rptcnt	;***** debug

	from	rptcnt		;- check: is still a poly ?
	sub	#3
	bmi	.exit
	 nop
	

	sms	[m_cnt],rptcnt	;- save vertex count

	sm	[m_xyz_avail],rptcnt	;- Flag xyz version exists

	dec	rsp		;- discard outcode off stack
	dec	rsp

	mpop	rprojptr		;- polybuf ptr

	dec	rsp		;- discard old polylistptr
	dec	rsp

	mpush	rprojptr		;- polybuf ptr (temp)

	mcall	mpltxclipproj	;- project vert
	 nop
   	
	move	r6,rprojptr		;- set new end poly

	mpop	r7		;- restore end poly hdr

	lms	routcode,[m_or_of_outcodes]

	lms	r0,[m_fnumpnts]
				;- Num verts
	with	r7
	sub	#8

	not
	stb	[r7]		;- Update Poly list hdr
	not

	with	r7
	add	#8

	mpop	rshapeptr
	mpop	pc
             nop




.exit		          		;- abort fail exit
	sub	r0
;	sms	[m_cnt],r0
	sms	[m_fnumpnts],r0
	mpop	routcode
	mpop	r7		;- rpolybuf ( end poly hdr)
	mpop	r6		;- rpolyptr ( end poly )
	mpop	rshapeptr
	mpop	pc
	 nop



******************************************************



;- Find intersection of line segment with plane
;-

rdividendlo	equr	4
rdividendhi	equr	5
rdivisor	equr	6
rdivsign	equr	7


;rd1	equr	1
;rd2	equr	2
;rpv	equr	3
;rdividendlo	equr	4
;routcode	equr	5
;rtempd	equr	5
;rdividendhi	equr	5
;rdivisor	equr	6
;rdivsign	equr	7
;rcpolyptr	equr	8
;rnumpnts	equr	9
;rpolyptr	equr	9
;rptcnt	equr	14

mintplane
	mpush	r11

	to	rd1		;- get d1 & d2
	ldw	[rpolyptr]

	ibt	r0,#8
	add	rpolyptr

	to	rd2
	ldw	[r0]

	from	rd1		;- check different signs
	to	rtempd
	xor	rd2
	bpl	.no_int		;- no intersect ?
	 nop

	mtest	rd1		;- Get abs of both
	bpl	.1pos
	 sub	r0
	to	rd1
	bra	.bothpos
	 sub	rd1
.1pos
	to	rd2
	sub	rd2
.bothpos

	to	rtempd		;- |d1| + |d2| 
	from	rd1
	add	rd2
	
        	mcall	.xyzloop		;- x
	nop
        	mcall	.xyzloop		;- y
	nop
        	mcall	.xyzloop		;- z
	nop

	inc	rptcnt

	inc	rpolyptr
	mpop	pc
	inc	rpolyptr


.no_int
	move	rpolyptr,r0
	mpop	pc
	 nop

;- get q1 , q1 from [rpolyptr]
;- calc (q1 * |rd2| + q2 * |rd1| )/ rtempd
;- output to [rcpolyptr]
.xyzloop
	mpush	r11

	inc	rpolyptr
	inc	rpolyptr
	to	r6		;- get q1 (x1,y1,z1,u1 or v1)
	ldw	[rpolyptr]
	
	mpush	rd1
	mpush	rd2

	with	rd2		;- rpv,rd2 = q1 * rd2
	lmult
	move	rpv,r4

	ibt	r0,#8		;- get q2 (x2,y2,z2,u2 or v2)
	add	rpolyptr

	to	r6
	ldw	[r0]

	with	rd1		;- q2 * rd1 + rpv
	lmult

	move	rdivisor,rtempd
	mpush	rtempd

	to	rdividendlo
	from	r4
	add	rpv

	to	rdividendhi
	from	rd1
	adc	rd2


	mcall	mdivs3216
	nop

	from	rdividendlo
	mstwi	rcpolyptr

	mpop	rtempd
	mpop	rd2
	mpop	rd1

	mpop	pc
	 nop

;
;-- end mintplane ----------------------------------------



	

;************************************************

;- Make world coord version polygon with distances from plane
;- for use in world plane clipper

rpolin	equr	1
rpolout	equr	2
rbigx	equr	5
rbigy	equr	6
rbigz	equr	7
rnumpnts	equr	9

mrebuild_poly_withd
;- to	D,X,Y,Z
;


;- Put D & X,Y,Z world coords into buffer

	lms	rbigx,[m_bigx]
	lms	rbigy,[m_bigy]
      	lms	rbigz,[m_bigz]

	miwt	rpolout,m_polybuf
	move	r12,rnumpnts
	move	r13,pc
;-----

;- Copy vertex distance from plane "d"

	getb			;- vert index
	add	r0

	miwt	rpolin,m_vert_d
	with	rpolin
	add	r0		;- rpolin = m_vert_d + vn*2
	
	ldw	[rpolin]		;- d
	mstwi	rpolout	

	getb			;- vert index again
	inc	rshapeptr
	umult	#6		;- *6

; copy vert x,y,z to poly buffer & add object center

	miwt	rpolin,m_rotpnts
	with	rpolin
	add	r0		; rpolin = m_rotpnts + vn*6

	mldwi	rpolin		;- x
	add	rbigx
	mstwi	rpolout

	mldwi	rpolin		;- y
	add	rbigy
	mstwi	rpolout

	ldw	[rpolin]		;- z
	add	rbigz
	mstwi	rpolout

	loop
	 nop
;-----
	from	rnumpnts
	sub	#2
	beq	.isline
	 nop

;- If not line round of buffer with first vert

	miwt	rpolin,m_polybuf	;- copy first to end

	mldwi	rpolin		;- d
	mstwi	rpolout
	
	mldwi	rpolin		;- x
	mstwi	rpolout
	
	mldwi	rpolin		;- y
	mstwi	rpolout
	
	mldwi	rpolin		;- z
	mstwi	rpolout
	
.isline
       	jmp	r11
	 nop

;-end mrebuild_poly_withd ------------





;------------------------------------------------------------
 IFNE mfastproj		; pete 26/10/93
			;- Carl. Modified to take world coords
			;- 14/4/94


; fast project poly points

rx	equr	1
ry	equr	2
;rscale	equr	3
rmlo	equr	4
rmhi	equr	5
rz	equr	6
rbigx	equr	3
rbigy	equr	13
rbigz	equr	9
rrotptr	equr	7
rprojptr	equr	8

routcode	equr	4
rxmax	equr	5
rymax	equr	5

; re-project points

mplclipproj
	mpush	r11

	mcache


	ibt	r0,#ztab>>16
	romb			      	; ztab rom bank

	sub	r0
	sms	[m_or_of_outcodes],r0		; outcode = 0


;	sms	[m_shapeptr],rshapeptr		; save shapeptr

	lms	r12,[m_cnt]

	miwt	rrotptr,m_clippolybuf		;- from clip buffer



.projloop
	to	rx
	mldwi	rrotptr			;- x

	to	ry
	mldwi	rrotptr			;- y

	to	rz
	mldwi	rrotptr			;- z

	mcall	mfastproject		;- Project point
	nop

	from	rx
	mstwi	rprojptr			;- output x

	from	ry
	mstwi	rprojptr			;- output y


	lms	rz,[m_or_of_outcodes]
	or	rz
	dec	r12
	bne	.projloop
	sbk			;- store back or_of_outcodes

	lms	r0,[m_shapebank]	; rom bank = shapebank
	romb
;	lms	rshapeptr,[m_shapeptr]

	lms	r0,[m_cnt]
	sms	[m_fnumpnts],r0
	mpop	pc
	nop

 ELSEIF

	error

 ENDC

.exit

	mpop	pc
	nop


;- mplclipproj
;-----------------------------------------------------------











;************************************************

;- Make world coord version texture mapped polygon with 
;- distances from plane
;- for use in world plane clipper

rpolin	equr	1
rpolout	equr	2
rpolold	equr	3
rbigx	equr	5
rbigy	equr	6
rbigz	equr	7
rnumpnts	equr	9

mrebuild_txpoly_withd
;- to	D,X,Y,Z,U,V
;

;	lms	rpolold,[m_polybufptr]	;- Projected X,Y,U,V ver
	move	rpolold,r7

;- Put D & X,Y,Z world coords into buffer

	lms	rbigx,[m_bigx]	;- Center object
	lms	rbigy,[m_bigy]
      	lms	rbigz,[m_bigz]

	
	miwt	rpolout,m_polybuf
	move	r12,rnumpnts
	move	r13,pc
;-----

;- Copy vertex distance from plane "d"

	getb			;- vert index
	add	r0

	miwt	rpolin,m_vert_d
	with	rpolin
	add	r0		;- rpolin = m_vert_d + vn*2
	
	ldw	[rpolin]		;- d
	mstwi	rpolout	

	getb			;- vert index again
	inc	rshapeptr
	umult	#6		;- *6

; copy vert x,y,z to poly buffer & add object center

	miwt	rpolin,m_rotpnts
	with	rpolin
	add	r0		; rpolin = m_rotpnts + vn*6

	mldwi	rpolin		;- x
	add	rbigx
	mstwi	rpolout

	mldwi	rpolin		;- y
	add	rbigy
	mstwi	rpolout

	ldw	[rpolin]		;- z
	add	rbigz
	mstwi	rpolout

	with	rpolold		;- skip over x,y to get uv
	add	#4

	mldwi	rpolold		;- u
	mstwi	rpolout

	mldwi	rpolold		;- v
	mstwi	rpolout

	loop
	 nop
;-----


	miwt	rpolin,m_polybuf	;- copy first to end

	mldwi	rpolin		;- d
	mstwi	rpolout
	
	mldwi	rpolin		;- x
	mstwi	rpolout
	
	mldwi	rpolin		;- y
	mstwi	rpolout
	
	mldwi	rpolin		;- z
	mstwi	rpolout
	
	mldwi	rpolin		;- u
	mstwi	rpolout
	
	mldwi	rpolin		;- v
	mstwi	rpolout
	
       	jmp	r11
	 nop

;-end mrebuild_txpoly_withd ------------





******************************************************



;- Find intersection of line segment with plane
;- Texture map version

rdividendlo	equr	4
rdividendhi	equr	5
rdivisor	equr	6
rdivsign	equr	7


;rd1	equr	1
;rd2	equr	2
;rpv	equr	3
;rdividendlo	equr	4
;routcode	equr	5
;rtempd	equr	5
;rdividendhi	equr	5
;rdivisor	equr	6
;rdivsign	equr	7
;rcpolyptr	equr	8
;rnumpnts	equr	9
;rpolyptr	equr	9
;rptcnt	equr	14

mtxintplane
	mpush	r11

	to	rd1		;- get d1 & d2
	ldw	[rpolyptr]

	ibt	r0,#12
	add	rpolyptr

	to	rd2
	ldw	[r0]

	from	rd1		;- check different signs
	to	rtempd
	xor	rd2
	bpl	.no_int		;- no intersect ?
	 nop

	mtest	rd1		;- Get abs of both
	bpl	.1pos
	 sub	r0
	to	rd1
	bra	.bothpos
	 sub	rd1
.1pos
	to	rd2
	sub	rd2
.bothpos

	to	rtempd		;- |d1| + |d2| 
	from	rd1
	add	rd2
	
        	mcall	.xyzuvloop		;- x
	nop
        	mcall	.xyzuvloop		;- y
	nop
        	mcall	.xyzuvloop		;- z
	nop
        	mcall	.xyzuvloop		;- u
	nop
        	mcall	.xyzuvloop		;- v
	nop

	inc	rptcnt

	inc	rpolyptr
	mpop	pc
	inc	rpolyptr


.no_int
	move	rpolyptr,r0
	mpop	pc
	 nop

;- get q1 , q1 from [rpolyptr]
;- calc (q1 * |rd2| + q2 * |rd1| )/ rtempd
;- output to [rcpolyptr]
.xyzuvloop
	mpush	r11

	inc	rpolyptr
	inc	rpolyptr
	to	r6		;- get q1 (x1,y1,z1,u1 or v1)
	ldw	[rpolyptr]
	
	mpush	rd1
	mpush	rd2

	with	rd2		;- rpv,rd2 = q1 * rd2
	lmult
	move	rpv,r4

	ibt	r0,#12		;- get q2 (x2,y2,z2,u2 or v2)
	add	rpolyptr

	to	r6
	ldw	[r0]

	with	rd1		;- q2 * rd1 + rpv
	lmult

	move	rdivisor,rtempd
	mpush	rtempd

	to	rdividendlo
	from	r4
	add	rpv

	to	rdividendhi
	from	rd1
	adc	rd2


	mcall	mdivs3216
	nop

	from	rdividendlo
	mstwi	rcpolyptr

	mpop	rtempd
	mpop	rd2
	mpop	rd1

	mpop	pc
	 nop

;
;-- end mtxintplane ----------------------------------------



;------------------------------------------------------------
 IFNE mfastproj		; pete 26/10/93
			;- Carl. Modified to take world coords
			;- 14/4/94


; fast project poly points for texture maps

rx	equr	1
ry	equr	2
;rscale	equr	3
rmlo	equr	4
rmhi	equr	5
rz	equr	6
rbigx	equr	3
rbigy	equr	13
rbigz	equr	9
rrotptr	equr	7
rprojptr	equr	8

routcode	equr	4
rxmax	equr	5
rymax	equr	5

; re-project points

mpltxclipproj
	mpush	r11

	mcache


	ibt	r0,#ztab>>16
	romb			      	; ztab rom bank

	sub	r0
	sms	[m_or_of_outcodes],r0		; outcode = 0


;	sms	[m_shapeptr],rshapeptr		; save shapeptr

	lms	r12,[m_cnt]

	miwt	rrotptr,m_clippolybuf		;- from clip buffer



.projloop
	to	rx
	mldwi	rrotptr			;- x

	to	ry
	mldwi	rrotptr			;- y

	to	rz
	mldwi	rrotptr			;- z

	mcall	mfastproject		;- Project point
	nop

	from	rx
	mstwi	rprojptr			;- output x

	from	ry
	mstwi	rprojptr			;- output y


	to	rz   			;- Get U
	mldwi	rrotptr
	from	rz
	mstwi	rprojptr			;- output U

	to	rz			;- Get V
	mldwi	rrotptr
	from	rz
	mstwi	rprojptr			;- output V

	lms	rz,[m_or_of_outcodes]
	or	rz
	dec	r12
	bne	.projloop
	sbk			;- store back or_of_outcodes

	lms	r0,[m_shapebank]	; rom bank = shapebank
	romb
;	lms	rshapeptr,[m_shapeptr]

	lms	r0,[m_cnt]
	sms	[m_fnumpnts],r0
	mpop	pc
	nop

 ELSEIF

	error

 ENDC

.exit

	mpop	pc
	nop


;- mpltxclipproj
;-----------------------------------------------------------


