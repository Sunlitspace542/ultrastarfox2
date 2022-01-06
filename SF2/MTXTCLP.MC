;--------------------------------------------------------
;--------------------------------------------------------
; FILE : MTXTCLIP.MC
; Z Clip & true 3D clip texture mapped polygons
;--------------------------------------------------------
; By C N Graham Dec 1993
;--------------------------------------------------------

;_________________________
; Giles please read this :
;~~~~~~~~~~~~~~~~~~~~~~~~~
; Add m_xtclip & m_ytclip to mvars.mc & ...ext

; also 65816 versions for xlmain.asm to setup

; Copy 65816 ver to mario copies in obj.asm..initmario3d_l (16 bit)



; m_xtclip & m_ytclip are the constants for the clipping plane equations
; in xlmain.asm
; m_ytclip <=	(128*16384/8/(gamenum_row))	; One player
; m_xtclip <=	(128*32768/8/(gamenum_col))
;
; m_ytclip <=	(128*16384/8/(gamenum_row2))	; Two player
; m_xtclip <=	(128*32768/8/(gamenum_col2))




CLIP_ABORT_COUNT	equ	12


;TTOPCLP	equ	128*16384/8/gamenum_row
;TRIGCLP	equ	128*32768/8/gamenum_col

;	printf "TTOPCLP = ",TTOPCLP,"%n"
;	printf "TRIGCLP = ",TRIGCLP,"%n"


;************************************************

;- Make world coord version of texture mapped polygon
;- for use in world space clipper

rrotptr	equr	1
rpolyptr	equr	2
rbigx	equr	5
rbigy	equr	6
rbigz	equr	7
rnumpnts	equr	9

mrebuildtxtmap
;- Data in m_polybuf format change
;- from X,Y,U,V
;- to	X,Y,Z,U,V
;
;- Move U,V to new pos
	mcache
 	lm	r0,[m_xyz_avail]
	mtest	r0
	mlbne	.alreadydone

 IFEQ mpolylist
	miwt	rpolyptr,m_polybuf+4-8	;change spacing of u & v
;	miwt	rrotptr,m_polybuf+6-10	;from every 6 to every 10 bytes

 ELSEIF
	lms	r0,[m_polybufptr]
	to	rpolyptr
	sub	#4
;	to	rrotptr
;	sub	#4
 ENDC
	miwt	rrotptr,m_polybuf+6-10	;from every 6 to every 10 bytes


	from	rnumpnts
	umult	#8
	to	rpolyptr
	add	rpolyptr

	from	rnumpnts
	umult	#10
	to	rrotptr
	add	rrotptr
	

	move	r12,rnumpnts
	move	r13,pc
;-----
	to	r3
	mldwi	rpolyptr
	ldw	[rpolyptr]

	from	r3
	mstwi	rrotptr
	stw	[rrotptr]

	with	rpolyptr
	sub	#10

	with	rrotptr
	sub	#12
	loop
	nop
;-----

;- Insert X,Y,Z world coords into buffer next to u & v

	lms	rbigx,[m_bigx]
	lms	rbigy,[m_bigy]
	lms	rbigz,[m_bigz]

	miwt	rpolyptr,m_polybuf

	move	r12,rnumpnts
	move	r13,pc
;-----

; copy poly rotpnts to poly buffer

	getb			; p1
	inc	rshapeptr
	umult	#6		; p1*6
	miwt	rrotptr,m_rotpnts
	with	rrotptr
	add	r0		; rrotptr = m_rotpnts + p1*6

	mldwi	rrotptr	; x
	add	rbigx
	mstwi	rpolyptr

	mldwi	rrotptr	; y
	add	rbigy
	mstwi	rpolyptr

	ldw	[rrotptr]	; z
	add	rbigz
	stw	[rpolyptr]

	with	rpolyptr	;skip ove z,u,v
	add	#6
	loop
	nop
;-----
       	jmp	r11
	nop


.alreadydone
	miwt	rpolyptr,m_polybuf
	miwt	rrotptr,m_clippolybuf

	to	r12
	from	rnumpnts
	umult	#10

	move	r13,pc

	mldwi	rrotptr
	mstwi	rpolyptr

	loop
	 nop

	with	rshapeptr
	add	rnumpnts

       	jmp	r11
	 nop


;-end mrebuildtxtmap



;-Cutter ---------start-----------------------------------


;--------------------
;- Try Z slicing polygons with strong perspective

rrotptr	equr	1
rpolyptr equr	2
rmaxz	equr	4
rminz	equr	5
rz	equr	6
rrotptr	equr	7
rprojptr	equr	8	;- As used in proj loop

mperspec_cut
	mpush	r11
;--------------------
 IFNE 1		;- Z slicing
;--------------------


;- Find Min Max Z
	iwt	rminz,#16000
	iwt	rmaxz,#-16000
	lms	r12,[m_cnt]
;-			Check which buffer poly is in, as m_polybuf will be
;-		 	overwritten by project
	miwt	r0,m_polybuf	;- If in poly m_polybuf
	lms	rrotptr,[m_tr1]
	sub	rrotptr
	beq	.copytst	;- Move while testing min max
	nop
	with	rrotptr
	add	#4
	move	r13,pc
;--				;- Check min max in buffer
	to	rz
	ldw	[rrotptr]
	from	rmaxz		;- Check for max
	sub	rz
	bpl	.ntmax
	nop
	move	rmaxz,rz
	bra	.ntmin
	nop
.ntmax
	from	rminz		;- Check for min
	sub	rz
	bmi	.ntmin
	nop
	move	rminz,rz
.ntmin
	with	rrotptr
	add	#10
	loop
	nop
	bra	.minmaxdone
	nop
.copytst
	lms	rpolyptr,[m_tr2]
	move	r13,pc		;- Check min max while copying
;--
	mldwi	rrotptr		;- copy x
	mstwi	rpolyptr

	mldwi	rrotptr		;- copy y
	mstwi	rpolyptr


	to	rz		;- copy and test z
	mldwi	rrotptr
	from	rz
	mstwi	rpolyptr
	
	from	rmaxz		;- min z
	sub	rz
	bpl	.ntmaxc
	nop
	move	rmaxz,rz
	bra	.ntminc
	nop
.ntmaxc
	from	rminz		;- max z
	sub	rz
	bmi	.ntminc
	nop
	move	rminz,rz
.ntminc
	mldwi	rrotptr		;- copy u
	mstwi	rpolyptr

	mldwi	rrotptr		;- copy v
	mstwi	rpolyptr
;--
	loop
	nop
	lms	r1,[m_tr1]	;- Swap input output pointers
	lms	r2,[m_tr2]
	sms	[m_tr1],r2
	sms	[m_tr2],r1
	
.minmaxdone
;--


	lms	r0,[m_cnt]	;- Make copy of original poly spec
	sms	[m_clippnts],r0

;-			 Test if ratio of near to far Z exceeds 3
;-			 and if not skip Z slicing

	from	rminz		;- Is max z > minz x 3
	add	rminz
	add	rminz
	to	rz
	sub	rmaxz
	mlbpl	.skipit		;- skip to projecting clipped poly
	nop

;-			Calc Z at which to cut polygon
;-			For tests use 1/4 from near to far Z

	from	rmaxz		;- Cut Z at (minz x 3 + maxz)/4
	add	r0
	lsr
	lsr

	mpush	r0		;- Push cut Z
;-				Create new poly preserving original
	mcall	mzcut_txt	;- Cut poly to Z greater than r0
	nop

	lms	r1,[m_tr1]	;- Swap input output pointers
	lms	r2,[m_tr2]
	sms	[m_tr1],r2
	sms	[m_tr2],r1

;;	lms	r0,[m_sprdata]
;;	ibt	r1,#32
;;	add	r1
;;	sbk

	mpop	r1		;- Get cut Z of stack while testing for exit
	mtest	r0
;	bra	.exit		;- abort
	beq	.exit		;- abort
	nop

	mpush	r1		;- put back cut Z

 IFEQ mpolylist

	mcall	mclipproj	;- Project poly
	nop

	mpush	r14
	mcall	mdrawapoly	;- Draw poly
	nop
	mpop	r14
 ELSEIF

	lms	r2,[m_polybufptr]
	with	r2
	sub	#8
	not
	stb	[r2]
	not
 	mpush	r2

	mcall	mclipproj	;- Project poly
	nop

	mpop	r1
	nop
	mldwi	r1		;- Copy header for next poly
	mstwi	rprojptr

	mldwi	r1
	mstwi	rprojptr

	mldwi	r1
	mstwi	rprojptr

	mldwi	r1
	mstwi	rprojptr

	sms	[m_polybufptr],rprojptr	

 ENDC

;-				Reset pointers to uncut version
	miwt	r0,m_polybuf
	sms	[m_tr2],r0
	miwt	r0,m_clippolybuf
	sms	[m_tr1],r0
;-				Restore poly spec
	lms	r0,[m_clippnts]
	sms	[m_cnt],r0

	mpop	r0		;- Pop cut Z
	mneg	r0		;- neg to cut to other side

	mcall	mzcut_txt	;- Cut poly to Z les than -r0
	nop

	mtest	r0
	beq	.exit		;- abort
	nop

	lms	r1,[m_tr1]	;- Swap input output pointers
	lms	r2,[m_tr2]
	sms	[m_tr1],r2
	sms	[m_tr2],r1

;;	lms	r0,[m_sprdata]
;;	ibt	r1,#32
;;	add	r1
;;	sbk
.skipit
	lms	r0,[m_cnt]
.exit
;--------------------
 ENDC	;- Z slicing end
;--------------------
	mpop	pc
	nop
	

;-Cutter --------------end------------------------------





;------------------------------------------------------------

;-3D texture map clipper ---Start----------------------------

;------------------------------------------------------------
;[m_tr1] - [m_tr2] -> m_polybuf - m_clippolybuf

routcode	equr	5

;
;Clip a texture mapped polygon in world space

m3dcliptexturemap
	mpush	r11
;;-
;	iwt	r1,#TTOPCLP
;	sms	[m_ytclip],r1
;	iwt	r1,#TRIGCLP
;	sms	[m_xtclip],r1
;;-

	sms	[m_or_of_outcodes],routcode
	lms	rnumpnts,[m_fnumpnts]
	sms	[m_cnt],rnumpnts
	with	rshapeptr		; reset to start of poly points
	sub	rnumpnts

	mcall	mrebuildtxtmap	;- Make x,y,z,u,v version
	nop

;- Set pointers to buffers

	miwt	r0,m_polybuf

	sms	[m_tr1],r0
	miwt	r0,m_clippolybuf
	sms	[m_tr2],r0

;--------------------
 IFNE 1		;- Clipping
;--------------------


	lms	routcode,[m_or_of_outcodes]
	ibt	r1,#$10		;-If Z clip then full treatment
	with	r1
	and	routcode
	beq	.zok
	nop
	ibt	routcode,#$f
	sms	[m_or_of_outcodes],routcode
.zok
;- Clip to botton of view cone
	from	routcode
	to	r1
	and	#2
	beq	.notbot
	nop

	mcall	mbotcliptxt
	nop
	lms	r1,[m_tr1]	;- Swap input output pointers
	lms	r2,[m_tr2]
	sms	[m_tr1],r2
	sms	[m_tr2],r1

	mtest	r0
	mlbeq	.exit

	lms	routcode,[m_or_of_outcodes]
.notbot
;- Clip to top of view cone
	from	routcode
	to	r1
	and	#1
	beq	.nottop
	nop

	mcall	mtopcliptxt
	nop
	lms	r1,[m_tr1]	;- Swap input output pointers
	lms	r2,[m_tr2]
	sms	[m_tr1],r2
	sms	[m_tr2],r1

	mtest	r0
	mlbeq	.exit
	lms	routcode,[m_or_of_outcodes]
.nottop
;- Clip to right of view cone
	from	routcode
	to	r1
	and	#8
	beq	.notright
	nop

	mcall	mrigcliptxt
	nop
	lms	r1,[m_tr1]	;- Swap input output pointers
	lms	r2,[m_tr2]
	sms	[m_tr1],r2
	sms	[m_tr2],r1

	mtest	r0
	mlbeq	.exit
	lms	routcode,[m_or_of_outcodes]
.notright
;- Clip to left of view cone
	from	routcode
	to	r1
	and	#4
	beq	.notleft
	nop

	mcall	mlefcliptxt
	nop
	lms	r1,[m_tr1]	;- Swap input output pointers
	lms	r2,[m_tr2]
	sms	[m_tr1],r2
	sms	[m_tr2],r1

	mtest	r0
	mlbeq	.exit
.notleft

;--------------------
 ENDC	;-Clipping done
;--------------------


	mcall	mperspec_cut	;- Sub-divide polygons with hi perspective
	nop
	mtest	r0
	beq	.exit
	nop

	mcall	mclipproj	;- Project poly
	nop
	mpop	pc
	nop

.exit
	sub	r0
	sms	[m_cnt],r0
	mpop	pc
	nop
	
;- exit back to main loop & a test of r0 before jumping to
;- mfaceon
;------------------------------------------------------------





;------------------------------------------------------------
 IFNE mfastproj		; pete 26/10/93
			;- Carl. Modified Dec 93 to force clipped
			;- points on screen

mclipproj
	mpush	r11

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
rxmax		equr	5
rymax		equr	5

; project points

	mcache

;	lms	rbigx,[m_bigx]		; world x,y,z
;	lms	rbigy,[m_bigy]
;	lms	rbigz,[m_bigz]

	ibt	r0,#ztab>>16
	romb			      	; ztab rom bank

	sub	r0
	sms	[m_or_of_outcodes],r0	; outcode = 0


	sms	[m_shapeptr],rshapeptr	; save shapeptr

	lms	r12,[m_cnt]
	lms	rrotptr,[m_tr1]		;- load pointer to clipped points

 IFEQ	mpolylist
	miwt	rprojptr,m_polybuf
 ELSEIF
	lms	rprojptr,[m_polybufptr]
 ENDC


.projloop
	to	rx
	mldwi	rrotptr	; x

	to	ry
	mldwi	rrotptr	; y

	to	rz
	mldwi	rrotptr	; z

	mcall	mfastproject		;- Project point
	nop
;---------------------
 IFNE 1		;Force on screen
;---------------------
	mpush	r0
	and	#15			;- Check outcodes
	beq	.outcodes_ok
	lsr				;- Force on screen
	bcc	.ntop
	lsr
	lms	ry,[m_ytop]
.ntop
	bcc	.nbot
	lsr
	lms	ry,[m_ybot]
.nbot
	bcc	.nlef
	lsr
	lms	rx,[m_xleft]
	ibt	rx,#0
.nlef
	bcc	.nrig
	nop
	lms	rx,[m_xright]
.nrig
	
;;	lms	r0,[m_sprdata]
;;	ibt	rz,#32
;;	add	rz
;;	sbk

.outcodes_ok
	mpop	r0
;---------------------
 ENDC		;Force on screen
;---------------------
	from	rx
	mstwi	rprojptr	; output x

	from	ry
	mstwi	rprojptr	; output y

	to	rz   		;- Get U
	mldwi	rrotptr
	from	rz
	mstwi	rprojptr	;- output U

	to	rz		;- Get V
	mldwi	rrotptr
	from	rz
	mstwi	rprojptr	;- output V


	lms	rz,[m_or_of_outcodes]
	or	rz
	dec	r12
	bne	.projloop
	sbk				; store back or_of_outcodes

	lms	r0,[m_shapebank]	; rom bank = shapebank
	romb
	lms	rshapeptr,[m_shapeptr]


	sub	r0		     	;- Zero outcodes
	sms	[m_or_of_outcodes],r0

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



;*******************************************************
;Clipping routines
;*******************************************************



	

rx1	equr	1
ry1	equr	2
rz1	equr	3
rx2	equr	4
ry2	equr	5
rcc	equr	6
rz2	equr	7
ru1	equr	8
rv1	equr	9
rzm	equr	11
rabortc	equr	10	;- Warning over stack pointer
ru2	equr	12
rv2	equr	13
rxym	equr	14


;bottst	macro	;(x~y),z
;	from	\1
;	add	\1
;	from	\2
;	sub	r0
;;	div2
;	endm

bottst	macro	;(x~y),z
	from	\1
	fmult
	adc	r0
	add	r0
	add	r0
	from	\2
	sub	r0
	endm
	



;- Clip 3d line p1,p2 with texture U & V to bottom of screen

mbotcliptxt3dline
	mcache
	mpush	r11
	mpush	r14

	bottst	ry1,rz1
	bmi	.mmp2
	nop
	bottst	ry2,rz2
	bmi	.mmpc1
	nop

	mpop	r14
	sub	r0
	mpop	pc
	nop

.mmp2			;- Point 1 out
	bottst	ry2,rz2
	mlbpl	.mmpc2
	nop
	mpop	r14
	ibt	r0,#-1	;- Both out
	mpop	pc
	nop

.mmpc1			;- 1 in 2 out
			;-Save point 1
	sms	[m_clipx],rx1
	sms	[m_clipy],ry1
	sms	[m_clipz],rz1

	mpush	ru1
	mpush	rv1
	mpush	ru2
	mpush	rv2
       	sms	[m_clip2drsp],rsp	;- save stack pointer

	ibt	rabortc,#CLIP_ABORT_COUNT


	mexg	rx1,rx2,r0	;-Swap
	mexg	ry1,ry2,r0
	mexg	rz1,rz2,r0

	lms	ru1,[m_cu2]
	lms	rv1,[m_cv2]
	lms	ru2,[m_cu1]
	lms	rv2,[m_cv1]

.mmp0			
	from	ry1
	add	ry2
	to	rxym
	div2

	from	rz1
	add	rz2
	to	rzm
	div2
	bottst	rxym,rzm
	beq	.mmpx
	nop
	bmi	.mmp1
	 dec	rabortc
	beq	.mmpx
	 nop

	move	rz2,rzm

	from	rx1
	add	rx2
	to	rx2
	div2

	move	ry2,rxym

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	bra	.mmp0
	nop

.mmp1
	beq	.mmpx
	 nop
	move	rz1,rzm

	from	rx1
	add	rx2
	to	rx1
	div2

	move	ry1,rxym

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2

	bra	.mmp0
	nop

.mmpx
	move	rz2,rzm		;- New point 2

	from	rx1
	add	rx2
	to	rx2
	div2

	move	ry2,rxym

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	lms	rx1,[m_clipx]	;- Restore point 1
	lms	ry1,[m_clipy]
	lms	rz1,[m_clipz]

	sms	[m_cu2],ru2
	sms	[m_cv2],rv2

       	lms	rsp,[m_clip2drsp]	;- load stack pointer

	mpop	rv2
	mpop	ru2
	mpop	rv1
	mpop	ru1

	mpop	r14
	ibt	r0,#1
	mpop	pc
	nop


.mmpc2				;- 1 out 2 in
	sms	[m_clipx],rx2	;- Save point 2
	sms	[m_clipy],ry2
	sms	[m_clipz],rz2

	mpush	ru1
	mpush	rv1
	mpush	ru2
	mpush	rv2
       	sms	[m_clip2drsp],rsp	;- save stack pointer
	ibt	rabortc,#CLIP_ABORT_COUNT	

	lms	ru1,[m_cu1]
	lms	rv1,[m_cv1]
	lms	ru2,[m_cu2]
	lms	rv2,[m_cv2]

.mmp20
	from	ry1
	add	ry2
	to	rxym
	div2

	from	rz1
	add	rz2
	to	rzm
	div2
	bottst	rxym,rzm
	beq	.mmp2x
	nop
	bmi	.mmp21
	 dec	rabortc
	beq	.mmp2x
	 nop

	move	rz2,rzm

	from	rx1
	add	rx2
	to	rx2
	div2

	move	ry2,rxym

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	bra	.mmp20
	nop

.mmp21
	beq	.mmp2x
	 nop
	move	rz1,rzm

	from	rx1
	add	rx2
	to	rx1
	div2

	move	ry1,rxym

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2

	bra	.mmp20
	nop

.mmp2x
	move	rz1,rzm		;- new point 1

	from	rx1
	add	rx2
	to	rx1
	div2

	move	ry1,rxym

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2
				;- Restore point 2
	lms	rx2,[m_clipx]
	lms	ry2,[m_clipy]
	lms	rz2,[m_clipz]

	sms	[m_cu1],ru1
	sms	[m_cv1],rv1

       	lms	rsp,[m_clip2drsp]	;- load stack pointer

	mpop	rv2
	mpop	ru2
	mpop	rv1
	mpop	ru1

	mpop	r14
	ibt	r0,#1
	mpop	pc
	nop


;****************************

mbotcliptxt
rx1	equr	1
ry1	equr	2
rz1	equr	3
rx2	equr	4
ry2	equr	5
rcc	equr	6
rz2	equr	7
rcpolyptr	equr	8
rpolyptr	equr	9
rptcnt	equr	14

;[m_tr1] - [m_tr2] -> m_polybuf - m_clippolybuf
  
	mpush	r11
	mpush	r14

;	iwt	rcc,#TTOPCLP
	lms	rcc,[m_ytclip]

;	lms	r0,[m_sprdata]
;	ibt	r1,#32
;	sub	r1
;	sbk

; 3d clip poly

	lms	rptcnt,[m_cnt]
	sub	r0
	sms	[m_cnt],r0

	lms	rcpolyptr,[m_tr1]
	lms	rpolyptr,[m_tr2]

	from	rptcnt
	sub	#2
	mlbeq	mbotcliptxt3dexit	; check for line
	nop
	

;- Not a line. Is poly

mbotcliptxt3dloop
;	mlbra	mbotcliptxt3dexit

	to	rx1		; get p1
	mldwi	rcpolyptr
	to	ry1
	mldwi	rcpolyptr
	to	rz1
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu1],r0
	mldwi	rcpolyptr
	sms	[m_cv1],r0

	move	r0,rptcnt	; if numptsin = 1 then wrap ptr
	dec	r0
	bne	.nowrap
	nop
	lms	rcpolyptr,[m_tr1]
.nowrap

	to	rx2		; get p2
	mldwi	rcpolyptr
	to	ry2
	mldwi	rcpolyptr
	to	rz2
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu2],r0
	ldw	[rcpolyptr]
	sms	[m_cv2],r0
	
;-Move ptr back to after p1
	with	rcpolyptr
	sub	#8

	bottst	ry1,rz1
	bpl	.oky1
	nop

	bottst	ry2,rz2
	mlbmi	mbotcliptxt3doff	; if z1<0  and z2<0  nextline

; if z1<0  and z2>=0 clip: addp1: nextline

	bra	.p1off
	nop

.oky1
; addp1			; if z1>=0 and z2>=0 addp1: nextline

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

; if z1>=0 and z2<0  addp1: clip: addp2: nextline


	bottst	ry2,rz2
	bpl	mbotcliptxt3doff
	nop

	mcall	mbotcliptxt3dline
	nop

; addp2

	from	rx2
	mstwi	rpolyptr
	from	ry2
	mstwi	rpolyptr
	from	rz2
	mstwi	rpolyptr
	lms	r0,[m_cu2]
	mstwi	rpolyptr
	lms	r0,[m_cv2]
	mstwi	rpolyptr
	
	lms	r0,[m_cnt]
	inc	r0
	sbk

	mlbra	mbotcliptxt3doff

;-Z1 neg
.p1off
	mcall	mbotcliptxt3dline
	nop

; addp1

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

mbotcliptxt3doff
	dec	rptcnt	;-Count down & do next vert
	mlbne	mbotcliptxt3dloop

	lms	r0,[m_cnt]
	to	r1
	sub	#3	
	mlbmi	mbotcliptxt3dexit		; exit if <3 points left


	mpop	r14
	mpop	pc
	nop

mbotcliptxt3dexit
	mpop	r14
	sub	r0
	mpop	pc
	nop


;*******************************************************



	

rx1	equr	1
ry1	equr	2
rz1	equr	3
rx2	equr	4
ry2	equr	5
rcc	equr	6
rz2	equr	7
ru1	equr	8
rv1	equr	9
rzm	equr	11
rabortc	equr	10	;- Warning over stack pointer
ru2	equr	12
rv2	equr	13
rxym	equr	14


;rigtst	macro	;(x~y),z
;	from	\1
;	div2
;	div2
;	add	\1
;	from	\2
;	sub	r0
;	endm

rigtst	macro	;(x~y),z
	from	\1
	fmult
	adc	r0
	add	r0
	add	r0
	from	\2
	sub	r0
	endm



; Clip 3d line p1,p2 with texture U & V to right of screen
mrigcliptxt3dline
	mcache
	mpush	r11
	mpush	r14

	rigtst	rx1,rz1
	bmi	.mmp2
	nop
	rigtst	rx2,rz2
	bmi	.mmpc1
	nop

	mpop	r14
	sub	r0
	mpop	pc
	nop

.mmp2			;- 1 out
	rigtst	rx2,rz2
	mlbpl	.mmpc2
	nop
	mpop	r14
	ibt	r0,#-1	;- Both out
	mpop	pc
	nop

.mmpc1			;- 1 in 2 out
			;-Save point 1
	sms	[m_clipx],rx1
	sms	[m_clipy],ry1
	sms	[m_clipz],rz1

	mpush	ru1
	mpush	rv1
	mpush	ru2
	mpush	rv2
       	sms	[m_clip2drsp],rsp	;save stack pointer

	ibt	rabortc,#CLIP_ABORT_COUNT

	mexg	rx1,rx2,r0	;-Swap
	mexg	ry1,ry2,r0
	mexg	rz1,rz2,r0

	lms	ru1,[m_cu2]
	lms	rv1,[m_cv2]
	lms	ru2,[m_cu1]
	lms	rv2,[m_cv1]
.mmp0			
	from	rx1
	add	rx2
	to	rxym
	div2

	from	rz1
	add	rz2
	to	rzm
	div2
	rigtst	rxym,rzm
	beq	.mmpx
	 nop
	bmi	.mmp1
	 dec	rabortc
	beq	.mmpx
	 nop

	move	rz2,rzm

	from	ry1
	add	ry2
	to	ry2
	div2

	move	rx2,rxym

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	bra	.mmp0
	nop

.mmp1
	beq	.mmpx
	 nop
	move	rz1,rzm

	from	ry1
	add	ry2
	to	ry1
	div2

	move	rx1,rxym

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2

	bra	.mmp0
	nop

.mmpx
	move	rz2,rzm		;- New point 2

	from	ry1
	add	ry2
	to	ry2
	div2

	move	rx2,rxym

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	lms	rx1,[m_clipx]	;- Restore point 1
	lms	ry1,[m_clipy]
	lms	rz1,[m_clipz]

	sms	[m_cu2],ru2
	sms	[m_cv2],rv2

       	lms	rsp,[m_clip2drsp]	;- load stack pointer

	mpop	rv2
	mpop	ru2
	mpop	rv1
	mpop	ru1

	mpop	r14
	ibt	r0,#1
	mpop	pc
	nop


.mmpc2				;- 1 out 2 in
	sms	[m_clipx],rx2	;- Save point 2
	sms	[m_clipy],ry2
	sms	[m_clipz],rz2

	mpush	ru1
	mpush	rv1
	mpush	ru2
	mpush	rv2
       	sms	[m_clip2drsp],rsp	;- save stack pointer
	ibt	rabortc,#CLIP_ABORT_COUNT	

	lms	ru1,[m_cu1]
	lms	rv1,[m_cv1]
	lms	ru2,[m_cu2]
	lms	rv2,[m_cv2]

.mmp20
	from	rx1
	add	rx2
	to	rxym
	div2

	from	rz1
	add	rz2
	to	rzm
	div2
	rigtst	rxym,rzm
	beq	.mmp2x
	nop
	bmi	.mmp21
	 dec	rabortc
	beq	.mmp2x
	 nop

	move	rz2,rzm

	from	ry1
	add	ry2
	to	ry2
	div2

	move	rx2,rxym

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	bra	.mmp20
	nop

.mmp21
	beq	.mmp2x
	 nop
	move	rz1,rzm

	from	ry1
	add	ry2
	to	ry1
	div2

	move	rx1,rxym

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2

	bra	.mmp20
	nop

.mmp2x
	move	rz1,rzm		;- new point 1

	from	ry1
	add	ry2
	to	ry1
	div2

	move	rx1,rxym

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2
				;- Restore point 2
	lms	rx2,[m_clipx]
	lms	ry2,[m_clipy]
	lms	rz2,[m_clipz]

	sms	[m_cu1],ru1
	sms	[m_cv1],rv1

       	lms	rsp,[m_clip2drsp]	;- load stack pointer

	mpop	rv2
	mpop	ru2
	mpop	rv1
	mpop	ru1

	mpop	r14
	ibt	r0,#1
	mpop	pc
	nop


;****************************

mrigcliptxt
rx1	equr	1
ry1	equr	2
rz1	equr	3
rx2	equr	4
ry2	equr	5
rcc	equr	6
rz2	equr	7
rcpolyptr	equr	8
rpolyptr	equr	9
rptcnt	equr	14

;[m_tr1] - [m_tr2] -> m_polybuf - m_clippolybuf
  
	mpush	r11
	mpush	r14

;	iwt	rcc,#TRIGCLP
	lms	rcc,[m_xtclip]

; 3d clip poly

	lms	rptcnt,[m_cnt]
	sub	r0
	sms	[m_cnt],r0

	lms	rcpolyptr,[m_tr1]
	lms	rpolyptr,[m_tr2]

	from	rptcnt
	sub	#2
	mlbeq	mrigcliptxt3dexit	; check for line
	nop
	

;- Not a line. Is poly

mrigcliptxt3dloop
;	mlbra	mrigcliptxt3dexit

	to	rx1		; get p1
	mldwi	rcpolyptr
	to	ry1
	mldwi	rcpolyptr
	to	rz1
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu1],r0
	mldwi	rcpolyptr
	sms	[m_cv1],r0

	move	r0,rptcnt	; if numptsin = 1 then wrap ptr
	dec	r0
	bne	.nowrap
	nop
	lms	rcpolyptr,[m_tr1]
.nowrap

	to	rx2		; get p2
	mldwi	rcpolyptr
	to	ry2
	mldwi	rcpolyptr
	to	rz2
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu2],r0
	ldw	[rcpolyptr]
	sms	[m_cv2],r0
	
;-Move ptr back to after p1
	with	rcpolyptr
	sub	#8

	rigtst	rx1,rz1
	bpl	.oky1
	 nop

	rigtst	rx2,rz2
	mlbmi	mrigcliptxt3doff	; Both out

; if z1<0  and z2>=0 clip: addp1: nextline

	bra	.p1off
	nop
.oky1
; addp1			; if z1>=0 and z2>=0 addp1: nextline

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

; if z1>=0 and z2<0  addp1: clip: addp2: nextline

	rigtst	rx2,rz2
	bpl	mrigcliptxt3doff
	nop

	mcall	mrigcliptxt3dline
	nop

; addp2

	from	rx2
	mstwi	rpolyptr
	from	ry2
	mstwi	rpolyptr
	from	rz2
	mstwi	rpolyptr
	lms	r0,[m_cu2]
	mstwi	rpolyptr
	lms	r0,[m_cv2]
	mstwi	rpolyptr
	
	lms	r0,[m_cnt]
	inc	r0
	sbk

	mlbra	mrigcliptxt3doff

;-Z1 neg
.p1off
	mcall	mrigcliptxt3dline
	nop

; addp1

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

mrigcliptxt3doff
	dec	rptcnt	;-Count down & do next vert
	mlbne	mrigcliptxt3dloop

	lms	r0,[m_cnt]
	to	r1
	sub	#3	
	mlbmi	mrigcliptxt3dexit		; exit if <3 points left

;****

	mpop	r14
	mpop	pc
	nop

mrigcliptxt3dexit
	mpop	r14
	sub	r0
	mpop	pc
	nop

;*******************************************************



; IFNE 0
;leftst	macro	;(x~y),z
;	from	\1
;	div2
;	div2
;	add	\1
;	from	\2
;	add	r0
;	endm
; ELSEIF
;leftst	macro	;(x~y),z
;	from	\1
;	add	\1
;	add	r0
;	add	\1
;	from	\2
;	add	r0
;	from	\2
;	add	r0
;	from	\2
;	add	r0
;	from	\2
;	add	r0
;	endm
; ENDC
	

leftst	macro	;(x~y),z
	from	\1
	fmult
	adc	r0
	add	r0
	add	r0	;-
	from	\2
	add	r0
	endm



;****************************


mlefcliptxt
rx1	equr	1
ry1	equr	2
rz1	equr	3
rx2	equr	4
ry2	equr	5
rcc	equr	6
rz2	equr	7
rcpolyptr	equr	8
rpolyptr	equr	9
rptcnt	equr	14

;[m_tr1] - [m_tr2] -> m_polybuf - m_clippolybuf
  
	mpush	r11
	mpush	r14

;	iwt	rcc,#TRIGCLP
	lms	rcc,[m_xtclip]

;	lms	r0,[m_sprdata]
;	ibt	r1,#32
;	sub	r1
;	sbk

; 3d clip poly

	lms	rptcnt,[m_cnt]
	sub	r0
	sms	[m_cnt],r0

	lms	rcpolyptr,[m_tr1]
	lms	rpolyptr,[m_tr2]

	from	rptcnt
	sub	#2
	mlbeq	mlefcliptxt3dexit	; check for line
	nop
	

;- Not a line. Is poly

mlefcliptxt3dloop
;	mlbra	mlefcliptxt3dexit

	to	rx1		; get p1
	mldwi	rcpolyptr
	to	ry1
	mldwi	rcpolyptr
	to	rz1
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu1],r0
	mldwi	rcpolyptr
	sms	[m_cv1],r0

	move	r0,rptcnt	; if numptsin = 1 then wrap ptr
	dec	r0
	bne	.nowrap
	nop
	lms	rcpolyptr,[m_tr1]
.nowrap

	to	rx2		; get p2
	mldwi	rcpolyptr
	to	ry2
	mldwi	rcpolyptr
	to	rz2
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu2],r0
	ldw	[rcpolyptr]
	sms	[m_cv2],r0
	
;-Move ptr back to after p1
	with	rcpolyptr
	sub	#8

	leftst	rx1,rz1
	bpl	.oky1
	 nop

	leftst	rx2,rz2
	mlbmi	mlefcliptxt3doff	; if z1<0  and z2<0  nextline

; if z1<0  and z2>=0 clip: addp1: nextline

	bra	.p1off
	nop
.oky1
; addp1			; if z1>=0 and z2>=0 addp1: nextline

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

; if z1>=0 and z2<0  addp1: clip: addp2: nextline

	leftst	rx2,rz2
	bpl	mlefcliptxt3doff
	nop

	mneg	rx1
	mneg	rx2
	mcall	mrigcliptxt3dline
;	mcall	mlefcliptxt3dline
	nop
	mneg	rx2

; addp2

	from	rx2
	mstwi	rpolyptr
	from	ry2
	mstwi	rpolyptr
	from	rz2
	mstwi	rpolyptr
	lms	r0,[m_cu2]
	mstwi	rpolyptr
	lms	r0,[m_cv2]
	mstwi	rpolyptr
	
	lms	r0,[m_cnt]
	inc	r0
	sbk

	mlbra	mlefcliptxt3doff

;-Z1 neg
.p1off
	mneg	rx1
	mneg	rx2
	mcall	mrigcliptxt3dline
;	mcall	mlefcliptxt3dline
	nop
	mneg	rx1

; addp1

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

mlefcliptxt3doff
	dec	rptcnt	;-Count down & do next vert
	mlbne	mlefcliptxt3dloop

	lms	r0,[m_cnt]
	to	r1
	sub	#3	
	mlbmi	mlefcliptxt3dexit		; exit if <3 points left

;****

	mpop	r14
	mpop	pc
	nop

mlefcliptxt3dexit
	mpop	r14
	sub	r0
	mpop	pc
	nop



;*******************************************************





;toptst	macro	;(x~y),z
;	from	\1
;	add	\1
;	from	\2
;	add	r0
;	div2
;	endm

toptst	macro	;(x~y),z
	from	\1
	fmult
	adc	r0
	add	r0
	add	r0
	from	\2
	add	r0
	endm
	


;****************************

mtopcliptxt
rx1	equr	1
ry1	equr	2
rz1	equr	3
rx2	equr	4
ry2	equr	5
rcc	equr	6
rz2	equr	7
rcpolyptr	equr	8
rpolyptr	equr	9
rptcnt	equr	14

;[m_tr1] - [m_tr2] -> m_polybuf - m_clippolybuf
  
	mpush	r11
	mpush	r14

;	iwt	rcc,#TTOPCLP
	lms	rcc,[m_ytclip]

;	lms	r0,[m_sprdata]
;	ibt	r1,#32
;	sub	r1
;	sbk

; 3d clip poly

	lms	rptcnt,[m_cnt]
	sub	r0
	sms	[m_cnt],r0

	lms	rcpolyptr,[m_tr1]
	lms	rpolyptr,[m_tr2]

	from	rptcnt
	sub	#2
	mlbeq	mtopcliptxt3dexit	; check for line
	nop
	

;- Not a line. Is poly

mtopcliptxt3dloop
;	mlbra	mtopcliptxt3dexit

	to	rx1		; get p1
	mldwi	rcpolyptr
	to	ry1
	mldwi	rcpolyptr
	to	rz1
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu1],r0
	mldwi	rcpolyptr
	sms	[m_cv1],r0

	move	r0,rptcnt	; if numptsin = 1 then wrap ptr
	dec	r0
	bne	.nowrap
	nop
	lms	rcpolyptr,[m_tr1]
.nowrap

	to	rx2		; get p2
	mldwi	rcpolyptr
	to	ry2
	mldwi	rcpolyptr
	to	rz2
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu2],r0
	ldw	[rcpolyptr]
	sms	[m_cv2],r0
	
;-Move ptr back to after p1
	with	rcpolyptr
	sub	#8

	toptst	ry1,rz1
	bpl	.oky1
	nop

	toptst	ry2,rz2
	mlbmi	mtopcliptxt3doff	; if z1<0  and z2<0  nextline

; if z1<0  and z2>=0 clip: addp1: nextline


	bra	.p1off
	nop

.oky1
; addp1			; if z1>=0 and z2>=0 addp1: nextline

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

; if z1>=0 and z2<0  addp1: clip: addp2: nextline


	toptst	ry2,rz2
	bpl	mtopcliptxt3doff
	nop

	mneg	ry1
	mneg	ry2
	mcall	mbotcliptxt3dline
;;;;	mcall	mtopcliptxt3dline
	nop
	mneg	ry2

; addp2

	from	rx2
	mstwi	rpolyptr
	from	ry2
	mstwi	rpolyptr
	from	rz2
	mstwi	rpolyptr
	lms	r0,[m_cu2]
	mstwi	rpolyptr
	lms	r0,[m_cv2]
	mstwi	rpolyptr
	
	lms	r0,[m_cnt]
	inc	r0
	sbk

	mlbra	mtopcliptxt3doff

;-Z1 neg
.p1off
	mneg	ry1
	mneg	ry2
	mcall	mbotcliptxt3dline
;;;	mcall	mtopcliptxt3dline
	nop
	mneg	ry1

; addp1

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

mtopcliptxt3doff
	dec	rptcnt	;-Count down & do next vert
	mlbne	mtopcliptxt3dloop

	lms	r0,[m_cnt]
	to	r1
	sub	#3	
	mlbmi	mtopcliptxt3dexit		; exit if <3 points left

;****

	mpop	r14
	mpop	pc
	nop

mtopcliptxt3dexit
	mpop	r14
	sub	r0
	mpop	pc
	nop



;
;rx1	equr	1
;ry1	equr	2
;rz1	equr	3
;rx2	equr	4
;ry2	equr	5
;rz2	equr	7
;ru1	equr	8
;rv1	equr	9
;rzm	equr	11
;rabortc	equr	10	;- Warning over stack pointer
;ru2	equr	12
;rv2	equr	13
;rxym	equr	14
;
; IFNE 0
;
;; Clip 3d line p1,p2 with texture U & V to left of screen
;mlefcliptxt3dline
;	mcache
;	mpush	r11
;	leftst	rx1,rz1
;	bmi	.mmp2
;	nop
;	leftst	rx2,rz2
;	bmi	.mmpc1
;	nop
;
;	sub	r0
;	mpop	pc
;	nop
;
;.mmp2			;- Z1 neg
;	leftst	rx2,rz2
;	mlbpl	.mmpc2
;	nop
;	ibt	r0,#-1	;- lefh Z neg
;	mpop	pc
;	nop
;
;.mmpc1			;-Z1 pos Z2 neg
;			;-Save point 1
;	sms	[m_clipx],rx1
;	sms	[m_clipy],ry1
;	sms	[m_clipz],rz1
;
;	mpush	ru1
;	mpush	rv1
;	mpush	ru2
;	mpush	rv2
;       	sms	[m_clip2drsp],rsp	;save stack pointer
;
;	ibt	rabortc,#CLIP_ABORT_COUNT
;
;	mexg	rx1,rx2,r0	;-Swap
;	mexg	ry1,ry2,r0
;	mexg	rz1,rz2,r0
;
;	lms	ru1,[m_cu2]
;	lms	rv1,[m_cv2]
;	lms	ru2,[m_cu1]
;	lms	rv2,[m_cv1]
;.mmp0			
;	from	rx1
;	add	rx2
;	to	rxym
;	div2
;
;	from	rz1
;	add	rz2
;	to	rzm
;	div2
;	leftst	rxym,rzm
;	beq	.mmpx
;	 nop
;	bmi	.mmp1
;	 dec	rabortc
;	beq	.mmpx
;	 nop
;
;	move	rz2,rzm
;
;	from	ry1
;	add	ry2
;	to	ry2
;	div2
;
;	move	rx2,rxym
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	bra	.mmp0
;	nop
;
;.mmp1
;	beq	.mmpx
;	 nop
;	move	rz1,rzm
;
;	from	ry1
;	add	ry2
;	to	ry1
;	div2
;
;	move	rx1,rxym
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;
;	bra	.mmp0
;	nop
;
;.mmpx
;	move	rz2,rzm		;- New point 2
;
;	from	ry1
;	add	ry2
;	to	ry2
;	div2
;
;	move	rx2,rxym
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	lms	rx1,[m_clipx]	;- Restore point 1
;	lms	ry1,[m_clipy]
;	lms	rz1,[m_clipz]
;
;	sms	[m_cu2],ru2
;	sms	[m_cv2],rv2
;
;       	lms	rsp,[m_clip2drsp]	;- load stack pointer
;
;	mpop	rv2
;	mpop	ru2
;	mpop	rv1
;	mpop	ru1
;
;	ibt	r0,#1
;	mpop	pc
;	nop
;
;
;.mmpc2				;-Z1 neg Z2 pos
;	sms	[m_clipx],rx2	;- Save point 2
;	sms	[m_clipy],ry2
;	sms	[m_clipz],rz2
;
;	mpush	ru1
;	mpush	rv1
;	mpush	ru2
;	mpush	rv2
;       	sms	[m_clip2drsp],rsp	;- save stack pointer
;	ibt	rabortc,#CLIP_ABORT_COUNT	
;
;	lms	ru1,[m_cu1]
;	lms	rv1,[m_cv1]
;	lms	ru2,[m_cu2]
;	lms	rv2,[m_cv2]
;
;.mmp20
;	from	rx1
;	add	rx2
;	to	rxym
;	div2
;
;	from	rz1
;	add	rz2
;	to	rzm
;	div2
;	leftst	rxym,rzm
;	beq	.mmp2x
;	nop
;	bmi	.mmp21
;	 dec	rabortc
;	beq	.mmp2x
;	 nop
;
;	move	rz2,rzm
;
;	from	ry1
;	add	ry2
;	to	ry2
;	div2
;
;	move	rx2,rxym
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	bra	.mmp20
;	nop
;
;.mmp21
;	beq	.mmp2x
;	 nop
;	move	rz1,rzm
;
;	from	ry1
;	add	ry2
;	to	ry1
;	div2
;
;	move	rx1,rxym
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;
;	bra	.mmp20
;	nop
;
;.mmp2x
;	move	rz1,rzm		;- new point 1
;
;	from	ry1
;	add	ry2
;	to	ry1
;	div2
;
;	move	rx1,rxym
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;				;- Restore point 2
;	lms	rx2,[m_clipx]
;	lms	ry2,[m_clipy]
;	lms	rz2,[m_clipz]
;
;	sms	[m_cu1],ru1
;	sms	[m_cv1],rv1
;
;       	lms	rsp,[m_clip2drsp]	;- load stack pointer
;
;	mpop	rv2
;	mpop	ru2
;	mpop	rv1
;	mpop	ru1
;
;	ibt	r0,#1
;	mpop	pc
;	nop
; ENDC
;





;**************************************************


rx1	equr	1
ry1	equr	2
rz1	equr	3
rx2	equr	4
ry2	equr	5
rz2	equr	7
ru1	equr	8
rv1	equr	9
rzm	equr	11
rabortc	equr	10	;- Warning over stack pointer
ru2	equr	12
rv2	equr	13
rdepth	equr	14

; IFNE 0
;deptst	macro	;(x~y),z
;	from	\1
;	sub	rdepth
;	endm
; ELSEIF
;deptst	macro	;(x~y),z
;	from	rdepth
;	sub	\1
;	endm
; ENDC



deptst	macro
	moves	r0,rdepth
	bpl	.\@
	sub	\1
	from	rdepth
	add	\1
.\@
	endm



;- cut 3d line p1,p2 with texture U & V to depth rdepth

mzcut_txt3dline
	mcache
	mpush	r11
	deptst	rz1
	bmi	.mmp2
	nop
	deptst	rz2
	bmi	.mmpc1
	nop

	sub	r0
	mpop	pc
	nop

.mmp2			;- Point 1 out
	deptst	rz2
	mlbpl	.mmpc2
	nop
	ibt	r0,#-1	;- Both out
	mpop	pc
	nop

.mmpc1			;- 1 in 2 out
			;-Save point 1
	sms	[m_clipx],rx1
	sms	[m_clipy],ry1
	sms	[m_clipz],rz1

	mpush	ru1
	mpush	rv1
	mpush	ru2
	mpush	rv2
       	sms	[m_clip2drsp],rsp	;- save stack pointer

	ibt	rabortc,#CLIP_ABORT_COUNT


	mexg	rx1,rx2,r0	;-Swap
	mexg	ry1,ry2,r0
	mexg	rz1,rz2,r0

	lms	ru1,[m_cu2]
	lms	rv1,[m_cv2]
	lms	ru2,[m_cu1]
	lms	rv2,[m_cv1]

.mmp0			

	from	rz1
	add	rz2
	to	rzm
	div2
	deptst	rzm
	beq	.mmpx
	nop
	bmi	.mmp1
	 dec	rabortc
	beq	.mmpx
	 nop

	move	rz2,rzm

	from	rx1
	add	rx2
	to	rx2
	div2

	from	ry1
	add	ry2
	to	ry2
	div2

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	bra	.mmp0
	nop

.mmp1
	beq	.mmpx
	 nop
	move	rz1,rzm

	from	rx1
	add	rx2
	to	rx1
	div2

	from	ry1
	add	ry2
	to	ry1
	div2

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2

	bra	.mmp0
	nop

.mmpx
	move	rz2,rzm		;- New point 2

	from	rx1
	add	rx2
	to	rx2
	div2

	from	ry1
	add	ry2
	to	ry2
	div2

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	lms	rx1,[m_clipx]	;- Restore point 1
	lms	ry1,[m_clipy]
	lms	rz1,[m_clipz]

	sms	[m_cu2],ru2
	sms	[m_cv2],rv2

       	lms	rsp,[m_clip2drsp]	;- load stack pointer

	mpop	rv2
	mpop	ru2
	mpop	rv1
	mpop	ru1

	ibt	r0,#1
	mpop	pc
	nop


.mmpc2				;- 1 out 2 in
	sms	[m_clipx],rx2	;- Save point 2
	sms	[m_clipy],ry2
	sms	[m_clipz],rz2

	mpush	ru1
	mpush	rv1
	mpush	ru2
	mpush	rv2
       	sms	[m_clip2drsp],rsp	;- save stack pointer
	ibt	rabortc,#CLIP_ABORT_COUNT	

	lms	ru1,[m_cu1]
	lms	rv1,[m_cv1]
	lms	ru2,[m_cu2]
	lms	rv2,[m_cv2]

.mmp20

	from	rz1
	add	rz2
	to	rzm
	div2
	deptst	rzm
	beq	.mmp2x
	nop
	bmi	.mmp21
	 dec	rabortc
	beq	.mmp2x
	 nop

	move	rz2,rzm

	from	rx1
	add	rx2
	to	rx2
	div2

	from	ry1
	add	ry2
	to	ry2
	div2

	from	ru1
	add	ru2
	to	ru2
	div2

	from	rv1
	add	rv2
	to	rv2
	div2

	bra	.mmp20
	nop

.mmp21
	beq	.mmp2x
	 nop
	move	rz1,rzm

	from	rx1
	add	rx2
	to	rx1
	div2

	from	ry1
	add	ry2
	to	ry1
	div2

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2

	bra	.mmp20
	nop

.mmp2x
	move	rz1,rzm		;- new point 1

	from	rx1
	add	rx2
	to	rx1
	div2

	from	ry1
	add	ry2
	to	ry1
	div2

	from	ru1
	add	ru2
	to	ru1
	div2

	from	rv1
	add	rv2
	to	rv1
	div2
				;- Restore point 2
	lms	rx2,[m_clipx]
	lms	ry2,[m_clipy]
	lms	rz2,[m_clipz]

	sms	[m_cu1],ru1
	sms	[m_cv1],rv1

       	lms	rsp,[m_clip2drsp]	;- load stack pointer

	mpop	rv2
	mpop	ru2
	mpop	rv1
	mpop	ru1

	ibt	r0,#1
	mpop	pc
	nop






;****************************

mzcut_txt
rx1	equr	1
ry1	equr	2
rz1	equr	3
rx2	equr	4
ry2	equr	5
rz2	equr	7
rcpolyptr	equr	6
rpolyptr	equr	8
rnumptsin	equr	9

;[m_tr1] - [m_tr2] -> m_polybuf - m_clippolybuf
  
	mpush	r11
	mpush	r14
	move	rdepth,r0

;	lms	r0,[m_sprdata]
;	ibt	r1,#32
;	sub	r1
;	sbk

; 3d cut poly

	lms	rnumptsin,[m_cnt]
	sub	r0
	sms	[m_cnt],r0

	lms	rcpolyptr,[m_tr1]
	lms	rpolyptr,[m_tr2]

	from	rnumptsin
	sub	#2
	mlbeq	mzcut_txt3dexit	; check for line
	nop
	

;- Not a line. Is poly

mzcut_txt3dloop
;	mlbra	mzcut_txt3dexit

	to	rx1		; get p1
	mldwi	rcpolyptr
	to	ry1
	mldwi	rcpolyptr
	to	rz1
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu1],r0
	mldwi	rcpolyptr
	sms	[m_cv1],r0

	move	r0,rnumptsin	; if numptsin = 1 then wrap ptr
	dec	r0
	bne	.nowrap
	nop
	lms	rcpolyptr,[m_tr1]
.nowrap

	to	rx2		; get p2
	mldwi	rcpolyptr
	to	ry2
	mldwi	rcpolyptr
	to	rz2
	mldwi	rcpolyptr
	mldwi	rcpolyptr
	sms	[m_cu2],r0
	ldw	[rcpolyptr]
	sms	[m_cv2],r0
	
;-Move ptr back to after p1
	with	rcpolyptr
	sub	#8

	deptst	rz1
	bpl	.oky1
	nop

	deptst	rz2
	mlbmi	mzcut_txt3doff	; if z1<0  and z2<0  nextline

; if z1<0  and z2>=0 cut: addp1: nextline

	bra	.p1off
	nop

.oky1
; addp1			; if z1>=0 and z2>=0 addp1: nextline

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

; if z1>=0 and z2<0  addp1: cut: addp2: nextline


	deptst	rz2
	bpl	mzcut_txt3doff
	nop

	mcall	mzcut_txt3dline
	nop

; addp2

	from	rx2
	mstwi	rpolyptr
	from	ry2
	mstwi	rpolyptr
	from	rz2
	mstwi	rpolyptr
	lms	r0,[m_cu2]
	mstwi	rpolyptr
	lms	r0,[m_cv2]
	mstwi	rpolyptr
	
	lms	r0,[m_cnt]
	inc	r0
	sbk

	mlbra	mzcut_txt3doff

;-Z1 neg
.p1off
	mcall	mzcut_txt3dline
	nop

; addp1

	from	rx1
	mstwi	rpolyptr
	from	ry1
	mstwi	rpolyptr
	from	rz1
	mstwi	rpolyptr
	lms	r0,[m_cu1]
	mstwi	rpolyptr
	lms	r0,[m_cv1]
	mstwi	rpolyptr

	lms	r0,[m_cnt]
	inc	r0
	sbk

mzcut_txt3doff
	dec	rnumptsin	;-Count down & do next vert
	mlbne	mzcut_txt3dloop

	lms	r0,[m_cnt]
	to	r1
	sub	#3	
	mlbmi	mzcut_txt3dexit		; exit if <3 points left


	mpop	r14
	mpop	pc
	nop

mzcut_txt3dexit
	mpop	r14
	sub	r0
	mpop	pc
	nop


;*******************************************************








;rx1	equr	1
;ry1	equr	2
;rz1	equr	3
;rx2	equr	4
;ry2	equr	5
;rz2	equr	7
;ru1	equr	8
;rv1	equr	9
;rzm	equr	11
;rabortc	equr	10	;- Warning over stack pointer
;ru2	equr	12
;rv2	equr	13
;rxym	equr	14
; IFNE 0
;
;; Clip 3d line p1,p2 with texture U & V to toptom of screen
;mtopcliptxt3dline
;	mcache
;	mpush	r11
;	toptst	ry1,rz1
;	bmi	.mmp2
;	nop
;	toptst	ry2,rz2
;	bmi	.mmpc1
;	nop
;
;	sub	r0
;	mpop	pc
;	nop
;
;.mmp2			;- Z1 neg
;	toptst	ry2,rz2
;	mlbpl	.mmpc2
;	nop
;	ibt	r0,#-1	;- toph Z neg
;	mpop	pc
;	nop
;
;.mmpc1			;-Z1 pos Z2 neg
;			;-Save point 1
;	sms	[m_clipx],rx1
;	sms	[m_clipy],ry1
;	sms	[m_clipz],rz1
;
;	mpush	ru1
;	mpush	rv1
;	mpush	ru2
;	mpush	rv2
;       	sms	[m_clip2drsp],rsp	;save stack pointer
;
;	ibt	rabortc,#CLIP_ABORT_COUNT
;
;
;	mexg	rx1,rx2,r0	;-Swap
;	mexg	ry1,ry2,r0
;	mexg	rz1,rz2,r0
;
;	lms	ru1,[m_cu2]
;	lms	rv1,[m_cv2]
;	lms	ru2,[m_cu1]
;	lms	rv2,[m_cv1]
;
;.mmp0			
;	from	ry1
;	add	ry2
;	to	rxym
;	div2
;
;	from	rz1
;	add	rz2
;	to	rzm
;	div2
;	toptst	rxym,rzm
;	beq	.mmpx
;	nop
;	bmi	.mmp1
;	 dec	rabortc
;	beq	.mmpx
;	 nop
;
;	move	rz2,rzm
;
;	from	rx1
;	add	rx2
;	to	rx2
;	div2
;
;	move	ry2,rxym
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	bra	.mmp0
;	nop
;
;.mmp1
;	beq	.mmpx
;	 nop
;	move	rz1,rzm
;
;	from	rx1
;	add	rx2
;	to	rx1
;	div2
;
;	move	ry1,rxym
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;
;	bra	.mmp0
;	nop
;
;.mmpx
;	move	rz2,rzm		;- New point 2
;
;	from	rx1
;	add	rx2
;	to	rx2
;	div2
;
;	move	ry2,rxym
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	lms	rx1,[m_clipx]	;- Restore point 1
;	lms	ry1,[m_clipy]
;	lms	rz1,[m_clipz]
;
;	sms	[m_cu2],ru2
;	sms	[m_cv2],rv2
;
;       	lms	rsp,[m_clip2drsp]	;- load stack pointer
;
;	mpop	rv2
;	mpop	ru2
;	mpop	rv1
;	mpop	ru1
;
;	ibt	r0,#1
;	mpop	pc
;	nop
;
;
;.mmpc2				;-Z1 neg Z2 pos
;	sms	[m_clipx],rx2	;- Save point 2
;	sms	[m_clipy],ry2
;	sms	[m_clipz],rz2
;
;	mpush	ru1
;	mpush	rv1
;	mpush	ru2
;	mpush	rv2
;       	sms	[m_clip2drsp],rsp	;- save stack pointer
;	ibt	rabortc,#CLIP_ABORT_COUNT	
;
;	lms	ru1,[m_cu1]
;	lms	rv1,[m_cv1]
;	lms	ru2,[m_cu2]
;	lms	rv2,[m_cv2]
;
;.mmp20
;	from	ry1
;	add	ry2
;	to	rxym
;	div2
;
;	from	rz1
;	add	rz2
;	to	rzm
;	div2
;	toptst	rxym,rzm
;	beq	.mmp2x
;	nop
;	bmi	.mmp21
;	 dec	rabortc
;	beq	.mmp2x
;	 nop
;
;	move	rz2,rzm
;
;	from	rx1
;	add	rx2
;	to	rx2
;	div2
;
;	move	ry2,rxym
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	bra	.mmp20
;	nop
;
;.mmp21
;	beq	.mmp2x
;	 nop
;	move	rz1,rzm
;
;	from	rx1
;	add	rx2
;	to	rx1
;	div2
;
;	move	ry1,rxym
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;
;	bra	.mmp20
;	nop
;
;.mmp2x
;	move	rz1,rzm		;- new point 1
;
;	from	rx1
;	add	rx2
;	to	rx1
;	div2
;
;	move	ry1,rxym
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;				;- Restore point 2
;	lms	rx2,[m_clipx]
;	lms	ry2,[m_clipy]
;	lms	rz2,[m_clipz]
;
;	sms	[m_cu1],ru1
;	sms	[m_cv1],rv1
;
;       	lms	rsp,[m_clip2drsp]	;- load stack pointer
;
;	mpop	rv2
;	mpop	ru2
;	mpop	rv1
;	mpop	ru1
;
;	ibt	r0,#1
;	mpop	pc
;	nop
; ENDC



;===================================================================
;rx1	equr	1
;ry1	equr	2
;rz1	equr	3
;rx2	equr	4
;ry2	equr	5
;rz2	equr	6
;ru1	equr	8
;rv1	equr	9
;ru2	equr	12
;rv2	equr	13
;
;;--------------Z Clipper not used
; IFNE 0
;
;; Clip 3d line p1,p2 with texture U & V to Z = 0
;mzcliptxt3dline
;	mcache
;;=================
;;	iwt	r0,#128
;;	with	rz1
;;	sub	r0
;;	with	rz2
;;	sub	r0
;;=================
;
;
;	moves	rz1,rz1
;	bmi	.mmp2
;	nop
;	moves	rz2,rz2
;	bmi	.mmpc1
;	nop
;;=================
;;	iwt	r0,#128
;;	with	rz1
;;	add	r0
;;	with	rz2
;;	add	r0
;;=================
;
;	sub	r0
;	jmp	r11
;	nop
;
;.mmp2			;- Z1 neg
;	moves	rz2,rz2
;	mlbpl	.mmpc2
;	nop
;;=================
;;	iwt	r0,#128
;;	with	rz1
;;	add	r0
;;	with	rz2
;;	add	r0
;;=================
;	ibt	r0,#-1	;- Both Z neg
;	jmp	r11
;	nop
;
;.mmpc1			;-Z1 pos Z2 neg
;			;-Save point 1
;	sms	[m_clipx],rx1
;	sms	[m_clipy],ry1
;	sms	[m_clipz],rz1
;
;	mpush	ru1
;	mpush	rv1
;	mpush	ru2
;	mpush	rv2
;
;
;	mexg	rx1,rx2,r0	;-Swap
;	mexg	ry1,ry2,r0
;	mexg	rz1,rz2,r0
;
;	lms	ru1,[m_cu2]
;	lms	rv1,[m_cv2]
;	lms	ru2,[m_cu1]
;	lms	rv2,[m_cv1]
;
;.mmp0			
;	from	rz1
;	add	rz2
;	div2
;	beq	.mmpx
;	nop
;	bmi	.mmp1
;	nop
;
;	move	rz2,r0
;
;	from	rx1
;	add	rx2
;	to	rx2
;	div2
;
;	from	ry1
;	add	ry2
;	to	ry2
;	div2
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	bra	.mmp0
;	nop
;
;.mmp1
;	move	rz1,r0
;
;	from	rx1
;	add	rx2
;	to	rx1
;	div2
;
;	from	ry1
;	add	ry2
;	to	ry1
;	div2
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;
;	bra	.mmp0
;	nop
;
;.mmpx
;	move	rz2,r0		;- New point 2
;	from	rx1
;	add	rx2
;	to	rx2
;	div2
;
;	from	ry1
;	add	ry2
;	to	ry2
;	div2
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	lms	rx1,[m_clipx]	;- Restore point 1
;	lms	ry1,[m_clipy]
;	lms	rz1,[m_clipz]
;
;	sms	[m_cu2],ru2
;	sms	[m_cv2],rv2
;
;
;	mpop	rv2
;	mpop	ru2
;	mpop	rv1
;	mpop	ru1
;
;;=================
;;	iwt	r0,#128
;;	with	rz1
;;	add	r0
;;	with	rz2
;;	add	r0
;;=================
;	ibt	r0,#1
;	jmp	r11
;	nop
;
;
;.mmpc2				;-Z1 neg Z2 pos
;	sms	[m_clipx],rx2	;- Save point 2
;	sms	[m_clipy],ry2
;	sms	[m_clipz],rz2
;
;	mpush	ru1
;	mpush	rv1
;	mpush	ru2
;	mpush	rv2
;	lms	ru1,[m_cu1]
;	lms	rv1,[m_cv1]
;	lms	ru2,[m_cu2]
;	lms	rv2,[m_cv2]
;
;.mmp20
;	from	rz1
;	add	rz2
;	div2
;	beq	.mmp2x
;	nop
;	bmi	.mmp21
;	nop
;	move	rz2,r0
;
;	from	rx1
;	add	rx2
;	to	rx2
;	div2
;
;	from	ry1
;	add	ry2
;	to	ry2
;	div2
;
;	from	ru1
;	add	ru2
;	to	ru2
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv2
;	div2
;
;	bra	.mmp20
;	nop
;
;.mmp21
;	move	rz1,r0
;
;	from	rx1
;	add	rx2
;	to	rx1
;	div2
;
;	from	ry1
;	add	ry2
;	to	ry1
;	div2
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;
;	bra	.mmp20
;	nop
;
;.mmp2x
;	move	rz1,r0		;- new point 1
;
;	from	rx1
;	add	rx2
;	to	rx1
;	div2
;
;	from	ry1
;	add	ry2
;	to	ry1
;	div2
;
;	from	ru1
;	add	ru2
;	to	ru1
;	div2
;
;	from	rv1
;	add	rv2
;	to	rv1
;	div2
;				;- Restore point 2
;	lms	rx2,[m_clipx]
;	lms	ry2,[m_clipy]
;	lms	rz2,[m_clipz]
;
;	sms	[m_cu1],ru1
;	sms	[m_cv1],rv1
;
;	mpop	rv2
;	mpop	ru2
;	mpop	rv1
;	mpop	ru1
;
;;=================
;;	iwt	r0,#128
;;	with	rz1
;;	add	r0
;;	with	rz2
;;	add	r0
;;=================
;	ibt	r0,#1
;	jmp	r11
;	nop
; ENDC
;;- Z Clipper not used replaced by 3D view cliper
; IFNE 0
;
;;************************************************
;; 3d polygon Z clip
;;- Clip polygon to Z = 0
;
;;- Entry r0 is number of verts
;
;mzcliptxt
;;	move	rnumpnts,r0
;	mpush	r11
;	bra	mzcliptxtent
;	nop
;
;mzcliptxtpoly3d
;	move	rnumpnts,r0
;
;	mpush	r11
;
;;	lms	r0,[m_sprdata]
;;	ibt	r1,#32
;;	sub	r1
;;	sbk
;
;	mcall	mrebuildtxtmap
;	nop
;
;mzcliptxtent
;
;rx1	equr	1
;ry1	equr	2
;rz1	equr	3
;rx2	equr	4
;ry2	equr	5
;rz2	equr	6
;rcpolyptr	equr	7
;rpolyptr	equr	8
;rnumptsin	equr	9
;
;
;; 3d clip poly
;
;	move	rnumptsin,rnumpnts
;	sub	r0
;	sms	[m_cnt],r0
;
;	miwt	rcpolyptr,m_polybuf
;	miwt	rpolyptr,m_clippolybuf
;
;	from	rnumptsin
;	sub	#2
;	mlbeq	mzcliptxt3dexit	; check for line
;	nop
;	
;
;;- Not a line. Is poly
;
;mzcliptxt3dloop
;;	mlbra	mzcliptxt3dexit
;
;	to	rx1		; get p1
;	mldwi	rcpolyptr
;	to	ry1
;	mldwi	rcpolyptr
;	to	rz1
;	mldwi	rcpolyptr
;	mldwi	rcpolyptr
;	sms	[m_cu1],r0
;	mldwi	rcpolyptr
;	sms	[m_cv1],r0
;
;	move	r0,rnumptsin	; if numptsin = 1 then wrap ptr
;	dec	r0
;	bne	.nowrap
;	nop
;	miwt	rcpolyptr,m_polybuf
;.nowrap
;
;	to	rx2		; get p2
;	mldwi	rcpolyptr
;	to	ry2
;	mldwi	rcpolyptr
;	to	rz2
;	mldwi	rcpolyptr
;	mldwi	rcpolyptr
;	sms	[m_cu2],r0
;	ldw	[rcpolyptr]
;	sms	[m_cv2],r0
;	
;;-Move ptr back to after p1
;	with	rcpolyptr	; I forgot about this!
;	sub	#8
;
;	from	rz2
;	and	rz1
;	mlbmi	mzcliptxt3doff	; if z1<0  and z2<0  nextline
;
;; if z1<0  and z2>=0 clip: addp1: nextline
;
;	mtest	rz1
;	mlbmi	.p1off
;
;; addp1			; if z1>=0 and z2>=0 addp1: nextline
;
;	from	rx1
;	mstwi	rpolyptr
;	from	ry1
;	mstwi	rpolyptr
;	from	rz1
;	mstwi	rpolyptr
;	lms	r0,[m_cu1]
;	mstwi	rpolyptr
;	lms	r0,[m_cv1]
;	mstwi	rpolyptr
;
;	lms	r0,[m_cnt]
;	inc	r0
;	sbk
;
;; if z1>=0 and z2<0  addp1: clip: addp2: nextline
;
;
;	mcall	mzcliptxt3dline
;;-	mcall	mclip3dline
;	nop
;
;; addp2
;
;	from	rx2
;	mstwi	rpolyptr
;	from	ry2
;	mstwi	rpolyptr
;	from	rz2
;	mstwi	rpolyptr
;	lms	r0,[m_cu2]
;	mstwi	rpolyptr
;	lms	r0,[m_cv2]
;	mstwi	rpolyptr
;	
;	lms	r0,[m_cnt]
;	inc	r0
;	sbk
;
;	mlbra	mzcliptxt3doff
;
;;-Z1 neg
;.p1off
;	mcall	mzcliptxt3dline
;;-	mcall	mclip3dline
;	nop
;
;; addp1
;
;	from	rx1
;	mstwi	rpolyptr
;	from	ry1
;	mstwi	rpolyptr
;	from	rz1
;	mstwi	rpolyptr
;	lms	r0,[m_cu1]
;	mstwi	rpolyptr
;	lms	r0,[m_cv1]
;	mstwi	rpolyptr
;
;	lms	r0,[m_cnt]
;	inc	r0
;	sbk
;
;mzcliptxt3doff
;	dec	rnumptsin	;-Count down & do next vert
;	mlbne	mzcliptxt3dloop
;
;	lms	r0,[m_cnt]
;	sub	#3	
;	mlbmi	mzcliptxt3dexit		; exit if <3 points left
;
;;****
;
; ENDC
;
;
; IFNE mfastproj		; pete 26/10/93
;
;
;
;; fast project poly points
;
;rx	equr	1
;ry	equr	2
;;rscale	equr	3
;rmlo	equr	4
;rmhi	equr	5
;rz	equr	6
;rbigx	equr	3
;rbigy	equr	13
;rbigz	equr	9
;rrotptr	equr	7
;rprojptr	equr	8
;
;routcode	equr	4
;rxmax		equr	5
;rymax		equr	5
;
;; project points
;
;mprojecttxtpoly
;;	mlbra	mzcliptxt3dexit
;	
;	lms	rbigx,[m_bigx]		; world x,y,z
;	lms	rbigy,[m_bigy]
;	lms	rbigz,[m_bigz]
;
;	ibt	r0,#ztab>>16
;	romb			      	; ztab rom bank
;
;	sub	r0
;	sms	[m_or_of_outcodes],r0	; outcode = 0
;
;
;	sms	[m_shapeptr],rshapeptr	; save shapeptr
;
;	lms	r12,[m_cnt]
;	miwt	rrotptr,m_clippolybuf
;	miwt	rprojptr,m_polybuf
;
;.projloop
;	to	rx
;	mldwi	rrotptr	; x
;
;	to	ry
;	mldwi	rrotptr	; y
;
;	to	rz
;	mldwi	rrotptr	; z
;
;	mcall	mfastproject
;	nop
;
;		
;	from	rx
;	mstwi	rprojptr	; output x
;
;	from	ry
;	mstwi	rprojptr	; output y
;
;	to	rz   		;- Get U
;	mldwi	rrotptr
;	from	rz
;	mstwi	rprojptr	;- output U
;
;	to	rz		;- Get V
;	mldwi	rrotptr
;	from	rz
;	mstwi	rprojptr	;- output V
;
;
;	lms	rz,[m_or_of_outcodes]
;	or	rz
;	dec	r12
;	bne	.projloop
;	sbk				; store back or_of_outcodes
;
;	lms	r0,[m_shapebank]	; rom bank = shapebank
;	romb
;	lms	rshapeptr,[m_shapeptr]
;
;	lms	r0,[m_cnt]
;
;	mpop	pc
;	nop
;
; ELSEIF
;
;	error
;
; ENDC
;
;
;
;mzcliptxt3dexit
;	sub	r0
;	mpop	pc
;	nop
;
;;end mzcliptxtpoly3d





	printf	*-mrebuildtxtmap," Tex clipper size %n"


