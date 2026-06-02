AFdebug_palette = 0
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: mtitle.mc				*
;* 	Description	: title bitmap program			*
;*	Date		: 1994.12.19				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;********************************************************************
;	------------------------
;	* TITLE BITMAP PROGRAM *
;	------------------------
;********************************************************************

;---------------------------------------------------------------------
Mdispface	macro	[addr]		; display face program
	dec	r0
	dec	r0
	bmi	{addr}
	nop
	endm

;---------------------------------------------------------------------
	IFNE	oldtitleteam
faceY		equ	140+6+2-8
faceX		equ	8*2
	ELSEIF
faceY		equ	140+6-8
faceX		equ	8*2+32-8
	ENDC
faceXtotalsize	equ	8*4*4
faceYsize		equ	8*4
noizy_size		equ	4
;---------------------------------------------------------------------
;;
;;
;;
;;
;;
;;
;********************************************************************
;	----------------------
;	 face display program
;	----------------------
;********************************************************************
mtitleface

	sub	r0
	ramb
	romb

	IFNE	oldtitleteam
	Mdrawface_entry	faceX+8*4*0,faceY,face_fox,0
	Mdrawface_entry	faceX+8*4*1,faceY,face_falco,0
	Mdrawface_entry	faceX+8*4*2,faceY,face_peppy,0
	Mdrawface_entry	faceX+8*4*3,faceY,face_slippy,0
	Mdrawface_entry	faceX+8*4*4,faceY,face_pony,0
	Mdrawface_entry	faceX+8*4*5,faceY,face_girl,0
	ELSEIF
	Mdrawface_entry	faceX+8*4*0,faceY,face_title1,0
	Mdrawface_entry	faceX+8*4*1,faceY,face_title2,0
	Mdrawface_entry	faceX+8*4*2,faceY,face_title3,0
	Mdrawface_entry	faceX+8*4*3,faceY,face_title4,0
	ENDC

	ibt	r0,#1
	cmode

	IFEQ	oldtitleteam
	Msetcolor	0
	Mboxfill	faceX,faceY,faceXtotalsize,8
	ENDC





;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=

	IFEQ	oldtitleteam

;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=

	lm	r10,[m_titlefacedisp]
	ibt	r0,#24h

	from	r10
	sub	r0
	bmi	.entry
	nop
.exitjmp
	miwt	r15,.exit&WM
	nop

.entry


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;&&&&&&&&&& wipe open  &&&&&&&&&&&&&&&&&&&&&&&&&&&&
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

;--------------------------------------------------
; Xsize
	ibt	r9,#28h
	from	r9
	sub	r10
	beq	.exitjmp
	nop
	add	r0	; 
	add	r0	; (0...1f)*4
	to	r5
	add	#4

;--------------------------------------------------
; Xstart
	
	moves	r0,r10
	add	r0
	add	r0	; (0...1f)*4

	iwt	r4,#faceX+noizy_size
	with	r4
	add	r0

;--------------------------------------------------

	iwt	r2,#faceY+8
	iwt	r3,#faceYsize
	mcache
.s1	move	r12,r5		; r5 = << Xsize  >>
	move	r1,r4		; r4 = << Xstart >>
	moves	r13,r15
	loop
	plot

	from	r3
	lsr	
	bcc	.skip11
	nop
	dec	r4
.skip11

	dec	r1
	dec	r3
	bne	.s1
	inc	r2


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;&&&&&&&&&& noize open &&&&&&&&&&&&&&&&&&&&&&&&&&&&
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

	ifeq	0

;--------------------------------------------------
; Xstart
	
	moves	r0,r10
	add	r0
	add	r0	; (0...1f)*4
	iwt	r3,#faceX
	with	r3
	add	r0
	iwt	r2,#faceY+8

;--------------------------------------------------

	lm	r0,[m_testcount]
	dec	r0
	sbk
	move	r8,r0		; r8 = random parameter

	Mjsr	Lrandom_parameter
	iwt	r10,#faceYsize
.dotloop
	move	r1,r3
	ibt	r12,#noizy_size	; noizy size
	move	r13,r15		; RANDOM PLOT
	Mjsr	Lrandom_prog

	from	r8
	and	#1
	beq	.dot1
	nop	

	from	r8
	and	#0fh

.dot1	colour
	loop
	plot

	
	from	r10
	lsr	
	bcc	.skip10
	nop
	dec	r3
.skip10

	dec	r10
	bne	.dotloop
	inc	r2		; position(Y)

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;&&&&&&&&&& clipping !! &&&&&&&&&&&&&&&&&&&&&&&&&&&
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

	Msetcolor	0
	Mboxfill	faceX-18,faceY+8,18,faceYsize
	Mboxfill	faceX+faceXtotalsize,faceY+8,18,faceYsize

;--------------------------------------------------

	endc


;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=

	ENDC 

;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
;=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=

.exit	
	sub	r0
	cmode


	Mstop

;=====================================================================
;=====================================================================
; end end end end end end end end end end end end end end end end end
;=====================================================================
;=====================================================================
