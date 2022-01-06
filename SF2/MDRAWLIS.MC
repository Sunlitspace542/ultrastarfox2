;*********************************************************************
;*		mnorm16	(Normalise)
;* Init
;*	m_x1	= vector X
;*	m_y1	= vector Y
;*	m_z1	= vector z
;* Exit
;*	m_x1	= unit vector X
;*	m_y1	= unit vector Y
;*	m_z1	= unit vector z
;*********************************************************************
mnorm16
	miwt	r10,m_stack&WM
	lm	r1,[m_x1]
	lm	r2,[m_y1]
	lm	r3,[m_z1]
	mcall	mnormalise16
	nop	
	sm	[m_x1],r1
	sm	[m_y1],r2
	sm	[m_z1],r3
	stop
	nop

***************************************************************
**
**  Draw polygon list by Krister Wombell/Dylan
**
**
**

rlistptr	equr	r1
rzstore	equr	r2
rshapehdrptr	equr	r3
rsflags	equr	r4
rwork	equr	r5
rzspare	equr	r6

;;;;	ldx	#m_drawlist
;;;;
;;;;.again
;;;;	lda.l	dl_next,x
;;;;	beq	.exit
;;;;
;;;;	pha
;;;;
;;;;	lda.l	dl_x,x
;;;;	
;;;;
;;;;	plx
;;;;
;;;;	bra	.again
;;;;.exit
;;;;
;Drawlist in format :
; struct dl_xxxxx in STRUCTS.INC
;
;
;	dl_rotx,1
;	dl_roty,1
;	dl_rotz,1
;	dl_sflags,1
;	dl_shape,2
;	dl_shadx,2
;	dl_shady,2
;	dl_shadz,2
;	dl_y,2
;	dl_x,2
;	dl_z,2
;	dl_coltab,2
;	dl_expcnt,1
;	dl_animframe,1
;	dl_colframe,1
;	dl_depth,1
;	dl_tscrollx,1
;	dl_tscrolly,1
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
mbegin_3d_display
;	ibt	r0,#$70
	sub	r0
	ramb
;	sub	r0
	romb

	lms	r1,[m_drawmap]
	sm	[m_olddrawmap],r1
	mcall	mclrbitmap
	nop

;;;;	miwt	r10,(m_stack&WM)+mmaxstack/2
;;;;	lms	r0,[m_cnt]
;;;;	mpush	r0
;;;;	sub	r0
;;;;	sms	[m_cnt],r0

;;;;	lm	r0,[m_mariopoll]
;;;;	moves	r0,r0
;;;;	beq	.nopoll
;;;;	nop
;;;;
;;;;	mcall	manswerpoll
;;;;	nop
;;;;	mpop	r0
;;;;	sms	[m_cnt],r0
;;;;.nopoll

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Draw space dust or ground dots?
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	lms	r0,[m_dotsorstars]	;do nodots/spacedust/gnd dots
	sm	[m_stackptr_bak],r0	; temporary store
	and	#1
	beq	.nogdots
	nop
;	mcall	mshowgrid
	nop
.nogdots

	lm	r0,[m_stackptr_bak]
	and	#2
	beq	.nostars
	nop
	mcall	mshowdust
	nop
.nostars


mdo_3d_display

	ifne	mario_stats3d
	sub	r0
	sm	[m_shapes_notdrawn],r0
	sm	[m_lines_drawn],r0
	sm	[m_polys_drawn],r0
	sm	[m_polys_clip2d],r0
	sm	[m_polys_clip3d],r0
	sm	[m_points_done],r0
	sm	[m_visis_done],r0
	endc

;	miwt	r10,(m_stack&WM)+mmaxstack/2
;	lms	r0,[m_clrbitmaps]
;	lob
;	beq	.noclr
;	nop
;	mcall	mclrbitmaps		;Clear bitmaps
;	nop
;.noclr
;	lms	r0,[m_dotsorstars]	;do nodots/spacedust/gnd dots
;	moves	r0,r0
;	beq	.skip
;	nop
;	bmi	.stars
;	nop
;	mcall	mshowgrid
;	nop
;	bra	.skip
;	nop
;.stars
;	mcall	mshowdust
;	nop
;.skip




; SHOW ALL OBJECTS
mshowview
	miwt	r10,(m_stack&WM)+mmaxstack/2

;----------------------------------------
;----------------------------------------
; Ground Clip plane -----------------------
	lm	r0,[m_groundlevel]	; set ground clipping plane (#1)
	ibt	r1,#plane_GROUND

	mcall	mGen_clip_plane
	 nop
;----------------------------------------
; Player 1 Pool Clip plane -----------------------
	lm	r0,[m_poolclip1]
	ibt	r1,#plane_POOL1

	mcall	mGen_clip_plane
	 nop
;----------------------------------------
; Player 2 Pool Clip plane -----------------------
	lm	r0,[m_poolclip2]
	ibt	r1,#plane_POOL2

	mcall	mGen_clip_plane
	 nop
;----------------------------------------
;----------------------------------------

	mcall	mallrotzsort		;Clear bitmaps
	nop

	mibt	r1,SPACE_MODE
	lms	r0,[m_pfm]
	and	r1
	bne	.noshad
	nop

	ibt	r0,#1
	sms	[m_shadowpass],r0
	mcall	mshow
	nop
.noshad
	sub	r0
	sms	[m_shadowpass],r0
	mcall	mshow
	nop

	miwt	r10,m_stack&WM

	sub	r0
	cmode


;	lm	r0,[m_meters]
;	lob
;	beq	.skip
;	nop
;	mcall	mboostmeter
;	nop
;	mcall	mdamagemeter
;f7-7	nop
	mcall	mENEMYcursor
	nop
	mcall	maltline
	nop

	nop
	mcall	mdrawbossHP
	nop
;	mcall	mmand
;	nop
;.skip

	mcall	mdrawhud	;KAWAGOE changed
	nop			;KAWAGOE changed

	lm	r0,[m_particlesON]
	mtest	r0
	beq	.npart
	nop
	mcall	mupdate_particles
	nop
.npart


	mrpix

;;	mlbra	mTurboSprites

	stop
	nop


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; this continues the drawloop after it has been interrupted

mdrawloop_con
	sub	r0
	romb

	lm	r10,[m_stackptr_bak]
	mpop	r0
	sms	[m_wmat33],r0
	mpop	r0
	sms	[m_wmat32],r0
	mpop	r0
	sms	[m_wmat31],r0
	mpop	r0
	sms	[m_wmat23],r0
	mpop	r0
	sms	[m_wmat22],r0
	mpop	r0
	sms	[m_wmat21],r0
	mpop	r0
	sms	[m_wmat13],r0
	mpop	r0
	sms	[m_wmat12],r0
	mpop	r0
	sms	[m_wmat11],r0
	mpop	r11
	mpop	rlistptr

	mlbra	mdrawloop_backagain


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; main draw loop for 3d system

mshow
	lm	rlistptr,[m_dlptr]
	moves	rlistptr,rlistptr
	bne	.tisok
	nop
	jmp	r11
	nop
.tisok
	mpush	r11	; store the caller

mdrawloop
	sub	r0			;clear r0.w
	romb

	sms	[m_numpnts],r0		; for particles

	lm	r0,[m_debugcount]
	inc	r0
	sbk

mdrawloop_backagain
	lm	r0,[m_mariopoll]
	moves	r0,r0
	beq	mdrawloop_in
	nop

	mpush	rlistptr
	mpush	r11
	lms	r0,[m_wmat11]
	mpush	r0
	lms	r0,[m_wmat12]
	mpush	r0
	lms	r0,[m_wmat13]
	mpush	r0
	lms	r0,[m_wmat21]
	mpush	r0
	lms	r0,[m_wmat22]
	mpush	r0
	lms	r0,[m_wmat23]
	mpush	r0
	lms	r0,[m_wmat31]
	mpush	r0
	lms	r0,[m_wmat32]
	mpush	r0
	lms	r0,[m_wmat33]
	mpush	r0
	sm	[m_stackptr_bak],r10
	sub	r0
	sm	[m_mariopoll],r0
	iwt	r0,#mdrawloop_con>>16
	sm	[m_pollcon+2],r0
	iwt	r0,#mdrawloop_con&WM
	sm	[m_pollcon],r0

	stop
	nop


mdrawloop_in

	mcache
	mpush	rlistptr

	inc	rlistptr
	inc	rlistptr
	inc	rlistptr
	inc	rlistptr

	ldb	[rlistptr]		;rotx
	sms	[m_rotx],r0
	inc	rlistptr
	ldb	[rlistptr]		;roty
	sms	[m_roty],r0
	inc	rlistptr
	ldb	[rlistptr]		;rotz
	sms	[m_rotz],r0
	inc	rlistptr

	to	rsflags
	ldb	[rlistptr]		;sflags
	inc	rlistptr

	to	rshapehdrptr
	ldw	[rlistptr]		;shape header
	inc	rlistptr
	inc	rlistptr


; shadow pass-through only-----
	lms	r0,[m_shadowpass]
	lob
	beq	.z		; not the shadow pass
	nop

	move	r0,#0
	ibt	rwork,#asf_shadowshape
	from	rsflags
	and	rwork
	beq	.nottruecolourset
	nop
	iwt	r0,#truecolourshadow
.nottruecolourset
	sms	[m_objflags],r0

	ibt	rwork,#asf_shadow!asf_shadowshape
	from	rsflags
	and	rwork
	mlbeq	.nextobj	; this object doesn't have a shadow

	ibt	r14,#sh_shadow
	from	rshapehdrptr
	to	r14
	add	r14
	mgetw	rshapehdrptr	; change the current shape to it's shadow shape
	ldw	[rlistptr]
	sms	[m_bigy],r0	; shadow's y
	inc	rlistptr
	inc	rlistptr
	ldw	[rlistptr]
	sms	[m_bigx],r0	; shadow's x
	inc	rlistptr
	inc	rlistptr
	ldw	[rlistptr]
	sms	[m_bigz],r0	; shadow's z

	inc	rlistptr
	inc	rlistptr
	inc	rlistptr
	inc	rlistptr
	inc	rlistptr
	inc	rlistptr	; skip normal x,y,z
	bra	.shady
	nop
.z
;------------------------------

	ibt	rwork,#asf_shadowshape
	from	rsflags
	and	rwork
	mlbne	.nextobj	; if it is a shadowshape, then don't draw normal shape


	inc	rlistptr
	inc	rlistptr	; shady

	inc	rlistptr
	inc	rlistptr	; shadx

	inc	rlistptr
	inc	rlistptr	; shadz

.doneshad

	ldw	[rlistptr]		;bigy
	sms	[m_bigy],r0
	inc	rlistptr
	inc	rlistptr

	ldw	[rlistptr]		;bigx
	sms	[m_bigx],r0
	inc	rlistptr
	inc	rlistptr

	ldw	[rlistptr]		;bigz
	sms	[m_bigz],r0
.shady
	move	rzspare,r0
	inc	rlistptr
	inc	rlistptr



	ifne	1			; quick object reject checks


	miwt	rwork,asf_partobj!asf_ssprite
	from	rsflags
	and	rwork
	mlbne	.okobj


rrad	equr	5
rzrad	equr	8
	
	sub	r0
	romb

	ibt	r14,#sh_size
	with	r14
	add	rshapehdrptr
	mgetw	rrad

	mtest	rrad
	bmi	.okobj
	nop
;	mlbmi	.okobj
;	mlbeq	.okobj
;	mlbra	.okobj
;	mlbra	.rejectobj

	lms	r0,[m_bigz]
	to	rzrad
	asr
	from	rzrad
	add	rrad
	bmi	.rejectobj		; if (z + radius) < 0 reject
	nop

	with	rrad
	add	rrad

	with	rzrad
;	asr

	lms	r7,[m_bigx]
	mtest	r7
	bmi	.xmi			; if (x >= 0)
	nop

	from	r7
	sub	rrad
	sub	rzrad
	bpl	.rejectobj
	nop

;	mlbra	.okobj
	mlbra	.checky

.xmi
	from	rrad
	not
	inc	r0
	sub	r7
	sub	rzrad
	bpl	.rejectobj
	nop

;	mlbra	.okobj

.checky
	lms	r2,[m_bigy]
	mtest	r2
	bmi	.ymi			; if (y >= 0)
	nop

	from	r2
	sub	rrad
	sub	rzrad
	bpl	.rejectobj
	nop

	mlbra	.okobj

.ymi
	from	rrad
	not
	inc	r0
	sub	r2
	sub	rzrad
	bpl	.rejectobj
	nop

	mlbra	.okobj


.rejectobj

	ifne	mario_stats3d
	lm	r0,[m_shapes_notdrawn]
	swap
	inc	r0
	swap
	sm	[m_shapes_notdrawn],r0
	endc

	mlbra	.nextobj

.okobj
	endc

;------------------------------------------------------------
	miwt	rwork,asf_partobj
	from	rsflags
	and	rwork
	beq	.notpart
	nop

	ibt	r0,#-12
	to	rlistptr
	add	rlistptr

;----------------------------
; unique number used for particle object.
	ldw	[rlistptr]		
	sms	[m_numgroups],r0
;----------------------------
.here
	inc	rlistptr
	inc	rlistptr	; shady

;----------------------------
; parameters for particle obj.
	ldb	[rlistptr]		; amount
	lob
	sms	[m_groupnum],r0

	inc	rlistptr

	ldb	[rlistptr]		; life
	lob
	sms	[m_grouptab],r0

	inc	rlistptr	; shadx

	ldb	[rlistptr]		; type
	lob
	sm	[m_debugvar2],r0
	ibt	rwork,#7
	and	rwork
	bne	.isinit
	nop
	ibt	r0,#-1
.isinit
	sms	[m_numpnts],r0
	sm	[m_debugvar1],r0


;************************************************
; particles use these as tempary MARIO vars:
; 	
; 		 m_numpnts
; 		 m_numgroups
; 		 m_groupnum
; 		 m_grouptab
; 	
; 	
	lm	r0,[m_particlesON]
	mtest	r0
	beq	.nopart
	nop


	lms	r0,[m_numpnts]
	mtest	r0
	beq	.nopart
	nop	
	bmi	.ninit
	nop	

	lms	r1,[m_grouptab]		; life
	lms	r2,[m_numgroups]	; unique object number.
	lms	r3,[m_groupnum]		; amount
	mcall	mmake_particles
	nop

.ninit
	lms	r2,[m_numgroups]	; unique object number.
	mcall	mshow_particles
	nop

.nopart
	mlbra	.nextobj

;************************************************

.notpart

; check for scaled text
	ibt	rwork,#asf_textobj
	from	rsflags
	and	rwork
	beq	.nottext
	nop


	ldw	[rlistptr]
	sms	[m_shapeptr],r0
	ibt	r0,#mariomsgs>>16
	sms	[m_shapebank],r0

	inc	rlistptr
	inc	rlistptr
	inc	rlistptr	; coltab and explode counter
	inc	rlistptr
	inc	rlistptr	; animframe and colframe
	ldb	[rlistptr]	; depth offset = colour
	inc	rlistptr
	to	rwork
	ldb	[rlistptr]		; tscrollx = size (signed)
	with	rwork
	sex
	sms	[m_sprsize],rwork	; store size

; depth cue:

	ibt	rwork,#15
	cmp	rwork
	bne	.norm
	nop
	from	rzspare
	hib
	lsr
	lsr
	ibt	rwork,#5
	cmp	rwork
	bcc	.daijobu
	nop
	move	r0,rwork
.daijobu
	ibt	rwork,#14
	from	rwork
	sub	r0

.norm
	mcall	msprint
	nop

	mlbra	.nextobj

.nottext




	ibt	rwork,#asf_hitflash
	from	rsflags
	and	rwork
	bne	.hf
	nop
	ibt	rwork,#asf_special
	from	rsflags
	and	rwork
	beq	.normal
	nop
.spec	miwt	rwork,id_1_c
	sms	[m_colourptr],rwork
	bra	.gotcptr
	nop
.spechf	miwt	rwork,red_c
	sms	[m_colourptr],rwork
	bra	.gotcptr
	nop
.hf	ibt	rwork,#asf_ssprite
	from	rsflags
	and	rwork
	bne	.normal	; if a software sprite, then always use normal colour table
	nop
	ibt	rwork,#asf_special
	from	rsflags
	and	rwork
	bne	.spechf
	nop
	miwt	rwork,white_c
	sms	[m_colourptr],rwork
	bra	.gotcptr
	nop
.normal
	ldw	[rlistptr]
	moves	r0,r0			;sets the sign flag
	bne	.gotcptr2
	nop
	
	ibt	r14,#sh_col_ptr		;store colour ptr
	from	rshapehdrptr
	to	r14
	add	r14
	mgetw	r0
	iwt	rwork,#ID_0_C&WM
	cmp	rwork
	bne	.gotcptr2
	nop
	lm	rwork,[m_defaultID]
	moves	rwork,rwork
	beq	.gotcptr2
	nop
	move	r0,rwork
.gotcptr2
	sms	[m_colourptr],r0
.gotcptr
	inc	rlistptr
	inc	rlistptr

	ibt	r14,#sh_shift		;store shift
	from	rshapehdrptr
	to	r14
	add	r14
	getb
	sms	[m_shift],r0
	mpush	rshapehdrptr

	move	r0,rzspare
	miwt	rwork,3000
	cmp	rwork
	bge	.simplest
	nop
	miwt	rwork,2000
	cmp	rwork
	bge	.middle
	nop
;	miwt	rwork,1000
;	cmp	rwork
;	bcs	.large
;	nop
	bra	.gotshapehd
	nop
.simplest
	ibt	r14,#sh_simple3
	from	rshapehdrptr
	to	r14
	add	r14
	mgetw	rshapehdrptr
	bra	.gotshapehd
	nop
.middle	ibt	r14,#sh_simple2
	from	rshapehdrptr
	to	r14
	add	r14
	mgetw	rshapehdrptr
	bra	.gotshapehd
	nop
.large	ibt	r14,#sh_simple1
	from	rshapehdrptr
	to	r14
	add	r14
	mgetw	rshapehdrptr
.gotshapehd

;---------------------------------------
;;; col box drawing
;;	ibt	r14,#sh_xmax
;;	from	rshapehdrptr
;;	to	r14
;;	add	r14
;;	mgetwi	r0
;;	miwt	rwork,m_boxX
;;	stw	[rwork]
;;	
;;	mgetwi	r0
;;	miwt	rwork,m_boxY
;;	stw	[rwork]
;;
;;	mgetwi	r0
;;	miwt	rwork,m_boxZ
;;	stw	[rwork]
;---------------------------------------

	ibt	r14,#sh_points		;store pntptr
	from	rshapehdrptr
	to	r14
	add	r14
	mgetw	r0
	sms	[m_pntptr],r0

	ibt	r14,#sh_bank		;store shape bank
	from	rshapehdrptr
	to	r14
	add	r14
	getb
	sms	[m_shapebank],r0

	ibt	r14,#sh_faces		;store faceptr
	from	rshapehdrptr
	to	r14
	add	r14
	mgetw	r0
	sms	[m_faceptr],r0


	mpop	rshapehdrptr

	ldb	[rlistptr]		;expcnt
	inc	rlistptr
	sms	[m_expcnt],r0

	ldb	[rlistptr]		;animframe
	sms	[m_framenum],r0
	inc	rlistptr
	ldb	[rlistptr]
	sms	[m_colframe],r0
	inc	rlistptr

; check for simple scaled sprite:

	ibt	rwork,#asf_ssprite
	from	rsflags
	and	rwork
	beq	.notssprite
	nop

	lms	r0,[m_shadowpass]
	lob
	bne	.notssprite		; the shadow pass?
	nop

	sub	r0
	romb

	ibt	r14,#sh_size
	from	rshapehdrptr
	to	r14
	add	r14
	mgetw	r0
	sms	[m_spra],r0

	ldb	[rlistptr]	; depth offset = colour in coltab
	sms	[m_spr0],r0
	inc	rlistptr
	ldb	[rlistptr]		; tscrollx = size (signed)
	sex
	sms	[m_sprxscale],r0	; store size

;	lms	r0,[m_pntptr]
;	mtest	r0
;	beq	.notsprite
;	nop

	mcall	mssprite
	nop

.notsprite
	mlbra	.nextobj




; show shape

.notssprite

	ldb	[rlistptr]
	sms	[m_depthoffset],r0	; depth cued z offset
	inc	rlistptr

	sub	r0
	ldb	[rlistptr]
	swap
	sms	[m_sprxscroll],r0
	inc	rlistptr		; texture map x

	ldb	[rlistptr]
	swap
	sms	[m_spryscroll],r0
	inc	rlistptr		; texture map y


	sub	r0			; set the clipping planes
	ldb	[rlistptr]
	sm	[m_clipplanes],r0
	inc	rlistptr

;	sub	r0
;	sms	(m_player),r0
;	iwt	rzspare,myship_0&WM
;	with	rshapehdrptr
;	cmp	rzspare
;	bne	.ok
;	nop
;	ibt	r0,1
;	sms	(m_player),r0
;.ok

	lms	r0,[m_faceptr]
	moves	r0,r0
	beq	.nextobj
	nop

; --- old reject was here ---

	lms	r0,[m_ybot]
	inc	r0
	sbk


	mcall	mshowobj2
	nop

	lms	r0,[m_ybot]
	dec	r0
	sbk


.nextobj
	mpop	rlistptr
	to	rlistptr
	ldw	[rlistptr]
	moves	rlistptr,rlistptr
	mlbne	mdrawloop
	nop

	mpop	pc
	mnop		; return to caller


planBMPSZ	equ	16*16*64


mclrmapscreen
	sub	r0
	miwt	r1,bitmap1+bitmapbase
	miwt	r12,planbmpsz/2
	mcache
	move	r13,r15
	stw	[r1]
	inc	r1
	loop
	inc	r1

	stop
	nop

pepperscreensize	=	16*24*32


mclrpepperscreen
	sub	r0
	miwt	r1,bitmap1+bitmapbase
	miwt	r12,pepperscreensize/2
	mcache
	move	r13,r15
	stw	[r1]
	inc	r1
	loop
	inc	r1

	stop
	nop

mclrbitmaps	; clear the second half of the bitmap
	sub	r0
	miwt	r1,bitmap1+gametranlen1
	miwt	r12,gametranlen2/2
	mcache
	move	r13,r15
	stw	[r1]
	inc	r1
	loop
	inc	r1

	jmp	r11
	nop


mclrbitmap1	; clear player 1's bitmap
	lms	r1,[m_drawmap]
	mcalls	mclrbitmap
	nop
	stop
	nop
mclrbitmap
	lms	r0,[m_xright]
	inc	r0
	div2
	div2
	to	r2
	div2

	lm	r4,[m_screenvheight]
	lm	r3,[m_screenheight]
	from	r3
	sub	r4
	add	r0
	to	r3
	add	r0

;	iwt	r3,#32*4

	sub	r0

	mcache

.mataloop
;;	lms	r12,[m_ybot]
	lm	r12,[m_screenvheight]
;;	inc	r12	;+1
	with	r12
	add	r12	;*2 (words)
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

	jmp	r11
	nop


mclrbitmap2	; clear player 2's bitmap
	iwt	r1,#bitmap2
	mcalls	mclrbitmap
	nop
	stop
	nop


mclrbitmaps2	; clear the first half of the bitmap, called from trans
	lms	r0,[m_clrbitmaps]
	lob
	beq	.noclr
	nop
	sub	r0
	miwt	r1,bitmap1
	miwt	r12,gametranlen1/2
	mcache
	move	r13,r15
	stw	[r1]
	inc	r1
	loop
	inc	r1
.noclr
	stop
	nop


mclrbitmaps3	; clear the second half of the bitmap
	lms	r0,[m_clrbitmaps]
	lob
	beq	.noclr
	nop
	sub	r0
	miwt	r1,bitmap1+gametranlen1
	miwt	r12,gametranlen2/2
	mcache
	move	r13,r15
	stw	[r1]
	inc	r1
	loop
	inc	r1
.noclr
	stop
	nop



	IFEQ	1


basetunnely	=	60
zmax		=	4000
stepsize	=	60


moffsetsize	equ	4000/4


rx		equr	1
ry		equr	2
rz		equr	3
rlasty		equr	4
routcode	equr	5
rptr		equr	6
rtog		equr	7

mtunnelv
	sub	r0
	ramb
	iwt	rx,#0
	iwt	ry,#basetunnely
	iwt	rz,#zmax
	mcall	mprojectpnt
	nop
	iwt	r0,#32
	with	ry
	add	r0
	move	rlasty,ry

	iwt	rz,#zmax-stepsize
;;---	iwt	rptr,#m_tunvoffsets&WM
	iwt	r10,#m_stack&WM
	mcache
.lp
	iwt	rx,#0		;just the y component is needed
	iwt	ry,#basetunnely
	mpush	rtog
	mpush	rptr
	mpush	rlasty
	mpush	rz
	mcall	mprojectpnt	;project the point
	nop
	iwt	r0,#32		;y = 96-192
	with	ry
	add	r0		;y = 128-224
	mpop	rz
	mpop	rlasty
	mpop	rptr
	mpop	rtog

	from	ry		;get difference between this and last frame
	sub	rlasty
	beq	.skip		;we don't want to stop HDMA so skip this line
	nop
	move	rlasty,ry	;last frame=this frame
	stb	[rptr]		;store it
	inc	rptr

	with	rtog
	xor	#1
	bne	.2
	nop
	sub	r0
	bra	.d
	nop
.2	iwt	r0,#256		;add 128
.d
	stb	[rptr]		;store it low byte, high byte
	inc	rptr
	swap
	stb	[rptr]
	inc	rptr
.skip
	iwt	r0,#stepsize	;subtract the step size from the z
	with	rz
	sub	r0
	bmi	.end		;if it is not behind, continue
	nop
;;---	iwt	r0,#(m_tunvoffsets+224*3)&WM
	cmp	rptr
	bmi	.lp
	nop

.end
	sub	r0
	stb	[rptr]
	inc	rptr
	stb	[rptr]
	inc	rptr
	stb	[rptr]
	inc	rptr
	stop
	nop

	ENDC

;--------------------------------------------------------------
; MALLROTZSORT
; This routine rotates and z sorts all the DL blocks

rsumhi	equr	r0	;8
rdlptr	equr	r9
rptr	equr	r8
rzptr	equr	r7

rtemp	equr	r1
rtemp2	equr	r2
rtemp3	equr	r3
rtemp4	equr	r4
rtemp5	equr	r5
rx	equr	r1
ry	equr	r2
rz	equr	r3

mldi	macro	[reg,offset]
	ibt	rptr,#{offset}&127
	with	rptr
	add	rdlptr
	IFNE	{reg}
	to	{reg}
	ENDC
	IFC	"\0","W"
	ldw	[rptr]
	ELSEIF
	ldb	[rptr]
	ENDC
	endm


msti	macro	[offset,reg]
	ibt	rptr,#{offset}&127
	with	rptr
	add	rdlptr
	IFNE	{reg}
	from	{reg}
	ENDC
	IFC	"\0","W"
	stw	[rptr]
	ELSEIF
	stb	[rptr]
	ENDC
	endm

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mallrotzsort

; clear the first ptr
	sub	r0
	romb
	sm	[m_dlptr],r0

	iwt	rdlptr,#m_drawlist&WM

	lms	r12,[m_numshapes]
	with	r12
	lob
	bne	.noret
	nop
	jmp	r11
	nop
.noret
	mcache
	move	r13,r15
.sortloop

	lm	rtemp,[m_viewposx]
	mldi.w	r0,dl_xx
	sub	rtemp
	msti.w	dl_x,r0

	lm	rtemp,[m_viewposy]
	mldi.w	r0,dl_yy
	sub	rtemp
	msti.w	dl_y,r0

	lm	rtemp,[m_viewposz]
	mldi.w	r0,dl_zz
	sub	rtemp
	msti.w	dl_z,r0
	

	mldi.b	r0,dl_sflags
	ibt	rtemp,#asf_shadow
	and	rtemp
	beq	.noshadrot
	nop

; rotate shadow's coordinates
	mldi.w	rx,dl_x
	lm	r0,[m_shadowheight]
	lms	ry,[m_viewposy]
	to	ry
	sub	ry
	mldi.w	rz,dl_z

	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	msti.w	dl_shadx,rsumhi
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	msti.w	dl_shady,rsumhi
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33
	msti.w	dl_shadz,rsumhi

.noshadrot
; rotate shape's coordinates
	mldi.w	rx,dl_x
	mldi.w	ry,dl_y
	mldi.w	rz,dl_z

	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	msti.w	dl_x,rsumhi
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	msti.w	dl_y,rsumhi
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33
	msti.w	dl_z,rsumhi

	mldi.b	r0,dl_sflags
	ibt	rtemp,#asf_shadowshape
	and	rtemp
	beq	.notfakeshadow
	nop

	mldi.w	r0,dl_x
	msti.w	dl_shadx,r0
	mldi.w	r0,dl_y
	msti.w	dl_shady,r0
	mldi.w	r0,dl_z
	msti.w	dl_shadz,r0
.notfakeshadow

; now to z sort it

	mldi.w	r0,dl_shape
	iwt	rtemp,#sh_sortz
	to	r14
	add	rtemp	; get the sort z from the shape (r0+rtemp->r14)
	getb
	inc	r14
	mldi.w	rtemp,dl_z

	mldi.w	rtemp2,dl_y
	mabs	rtemp2,rtemp2
	ibt	rtemp2,#0
	with	rtemp
	add	rtemp2

	mldi.w	rtemp2,dl_x
	mabs	rtemp2,rtemp2
	with	rtemp
	add	rtemp2
	add	rtemp2

	getbh
	to	rtemp
	add	rtemp		; add it to the z of the shape
	mldi.w	r0,dl_sortz
	to	rtemp
	add	rtemp		; add current sort z
; rtemp = sort z of shape

	ibt	rtemp2,#0	; last pointer
	lm	rzptr,[m_dlptr]
	moves	rzptr,rzptr
	bne	.zsortit
	nop
	sm	[m_dlptr],rdlptr
	move	rzptr,rtemp2
	bra	.setit
	nop
.zsortit
	inc	rzptr
.zsortit2
	inc	rzptr
	movew	r0,[rzptr]
	dec	rzptr
	dec	r0
	cmp	rtemp		; compare with sort z of current shape
	bpl	.notyet
	dec	rzptr

	moves	rtemp2,rtemp2
	bne	.notfirst	; insert right at beginning?
	nop

	sm	[m_dlptr],rdlptr
	bra	.setit
	nop

.notfirst
	movew	[rtemp2],rdlptr
	bra	.setit
	nop
.notyet

	move	rtemp2,rzptr
	movew	rzptr,[rzptr]
	moves	rzptr,rzptr	; rzptr = rzptr->next
	bne	.zsortit
	nop
;	inc	rzptr		; crashes if use .zsortit2

; add to end of list
	bra	.notfirst
	nop

.setit	msti.w	dl_sortz,rtemp	; store the sort z of the shape
	msti.w	dl_next,rzptr	; store the next pointer to rtemp2

	ibt	r0,#dl_sizeof
	to	rdlptr
	add	rdlptr

	loop
	nop

	jmp	r11
	nop


;--------------------------------------------------------------


;--------------------------------------------------------------
;--------------------------------------------------------------

; Kawagoe testing


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mradarrot

; clear the first ptr
	sub	r0
	romb

	iwt	rdlptr,#m_drawlist&WM

	to 	r12
	ldb	[rdlptr]
	with	r12
	lob
	bne	.noret
	nop
	stop
	nop
.noret
	inc 	rdlptr
	inc 	rdlptr

	mcache
	move	r13,r15
.rotloop

	lm	rtemp,[m_viewposx]
	mldi.w	r0,rl_x
	sub	rtemp
	msti.w	rl_outx,r0

	lm	rtemp,[m_viewposy]
	mldi.w	r0,rl_y
	sub	rtemp
	msti.w	rl_outy,r0

	lm	rtemp,[m_viewposz]
	mldi.w	r0,rl_z
	sub	rtemp
	msti.w	rl_outz,r0
	

; rotate shape's coordinates
	mldi.w	rx,rl_outx
	mldi.w	ry,rl_outy
	mldi.w	rz,rl_outz

	mdotprod16mq	m_wmat11,m_wmat21,m_wmat31
	msti.w	rl_outx,rsumhi
	mdotprod16mq	m_wmat12,m_wmat22,m_wmat32
	msti.w	rl_outy,rsumhi
	mdotprod16mq	m_wmat13,m_wmat23,m_wmat33
	msti.w	rl_outz,rsumhi



	ibt	r0,#rl_sizeof
	to	rdlptr
	add	rdlptr

	loop
	nop

	stop
	nop



;-------------------------------------------------------------
; project point that can be called from 65816
; m_x1,m_y1,m_z1 => m_x1, m_y1

mproject_a_point
	sub	r0
	ramb
	romb

	miwt	r10,m_stack&WM
	

	lms	r1,[m_x1]
	lms	r2,[m_y1]
	lms	r3,[m_z1]

	mcall	mprojectpnt
	nop

	sms	[m_x1],r1
	sms	[m_y1],r2

	stop
	nop


;;;;manswerpoll
;;;;	mpush	rlistptr
;;;;	mpush	r11
;;;;	lms	r0,[m_wmat11]
;;;;	mpush	r0
;;;;	lms	r0,[m_wmat12]
;;;;	mpush	r0
;;;;	lms	r0,[m_wmat13]
;;;;	mpush	r0
;;;;	lms	r0,[m_wmat21]
;;;;	mpush	r0
;;;;	lms	r0,[m_wmat22]
;;;;	mpush	r0
;;;;	lms	r0,[m_wmat23]
;;;;	mpush	r0
;;;;	lms	r0,[m_wmat31]
;;;;	mpush	r0
;;;;	lms	r0,[m_wmat32]
;;;;	mpush	r0
;;;;	lms	r0,[m_wmat33]
;;;;	mpush	r0
;;;;	sm	[m_stackptr_bak],r10
;;;;	sub	r0
;;;;	sm	[m_mariopoll],r0
;;;;	iwt	r0,#.con>>16
;;;;	sm	[m_pollcon+2],r0
;;;;	iwt	r0,#.con&WM
;;;;	sm	[m_pollcon],r0
;;;;
;;;;	stop
;;;;	nop
;;;;
;;;;.con
;;;;	sub	r0
;;;;	romb
;;;;	ramb
;;;;	lm	r10,[m_stackptr_bak]
;;;;	mpop	r0
;;;;	sms	[m_wmat33],r0
;;;;	mpop	r0
;;;;	sms	[m_wmat32],r0
;;;;	mpop	r0
;;;;	sms	[m_wmat31],r0
;;;;	mpop	r0
;;;;	sms	[m_wmat23],r0
;;;;	mpop	r0
;;;;	sms	[m_wmat22],r0
;;;;	mpop	r0
;;;;	sms	[m_wmat21],r0
;;;;	mpop	r0
;;;;	sms	[m_wmat13],r0
;;;;	mpop	r0
;;;;	sms	[m_wmat12],r0
;;;;	mpop	r0
;;;;	sms	[m_wmat11],r0
;;;;	mpop	r11
;;;;	mpop	rlistptr
;;;;
;;;;.nopoll
;;;;
;;;;	jmp	r11
;;;;	nop


	incfile	mscreen.mc

	incfile	mcursor.mc

