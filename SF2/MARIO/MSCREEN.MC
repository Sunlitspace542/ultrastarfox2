;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;
; Program to decode screen data and other bits and pieces.
;
; Author: Dylan Cuthbert

mconvertscreen
	sub	r0
	ramb
	romb

	lm	r0,[m_screenvheight]
	div2
	div2
	to	r5
	div2
	ibt	r4,#0	;bg1_firstchar
	with	r4
	add	r5		; set index into each column

	iwt	r1,#dec_base	; source address
	iwt	r2,#%1111110000000000	; char info mask
	iwt	r3,#%0000001111111111	; char no. mask
	lm	r0,[m_screenheight]	; number of chars per column
	div2
	div2
	to	r6
	div2
	from	r6
	to	r5
	sub	r5	; number of chars at bottom of each column

	mcache

	iwt	r12,#(32*32)
	move	r13,r15
; loop
	ldw	[r1]
	to	r8
	and	r2	; save char info into r8 for later

	and	r3	; just change the character no.

	ibt	r7,#-1	; count up how many columns
.lp
	sub	r5
	bcs	.lp
	inc	r7

	add	r5

	with	r7
	umult	r6	; no. of cols x size of column

	add	r7	; add 
	add	r4	; add offset of first column
	or	r8	; mask in colour info.

	stw	[r1]
	inc	r1
	inc	r1
	loop
	nop

	stop
	nop


;----------------------------------------------------------------------
; routine to create bg1 screen data with 3d area.
; mvars needed:
;         m_screenwidth    - width of 3d area in pixels
;         m_screenheight   - height of 3d area in pixels
;         m_screenvheight  - height of visible area
;         m_screenmode     - flags
;         m_screen3dxpos_1 - position of 3d area (player 1)
;         m_screen3dxpos_2 - position of 3d area (player 2)
;         m_screen3dypos_1 - position of 3d area (player 1)
;         m_screen3dypos_2 - position of 3d area (player 2)

mchk_smflag	macro	[reg,flag]
	iwt	{reg},#sm_{flag}
	lm	r0,[m_screenmode]
	and	{reg}
	endm

div8_r0	macro
	div2
	div2
	div2
	endm

msetupscreen
	sub	r0
	romb
	ramb

	iwt	r7,#dec_base

	ibt	r10,#-1
	mchk_smflag	r1,noborder
	bne		.noset
	nop

	lm	r10,[m_blankchar]	; load blanking char

	mchk_smflag	r1,3dglasses
	bne		.by2
	nop

	mchk_smflag	r1,twoscreen
	beq		.noby2
	nop
.by2
	with	r10
	add	r10	; if two player screen then *2

.noby2
	lm	r1,[m_blankpalette]
	iwt	r0,#0	;bg1_firstchar
	or	r1
	to	r10
	add	r10

.noset

	mcache

	lm	r12,[m_screen3dypos_1]
	mcall	msetblank
	nop

	lm	r9,[m_screen3dpalette_1]
	iwt	r0,#0	;bg1_firstchar
	to	r9
	add	r9

	lm	r4,[m_screenwidth]
	lm	r5,[m_screen3dxpos_1]
	lm	r6,[m_screenvheight]
	lm	r8,[m_screenheight]

	mcall	mset3dscreen
	nop

	mchk_smflag	r1,twoscreen
	beq		.clrtherest
	nop

; set up second screen

	lm	r1,[m_screen3dypos_1]
	lm	r0,[m_screen3dypos_2]
	sub	r6
	to	r12
	sub	r1

	mcall	msetblank
	nop

	with	r4		; screenwidth
	umult	r8		; *screenheight
	iwt	r0,#%1111111111
	and	r9
	add	r4
	sub	r6
	lm	r1,[m_screen3dpalette_2]
	to	r9
	add	r1

	lm	r4,[m_screenwidth]
	lm	r5,[m_screen3dxpos_2]
	lm	r6,[m_screenvheight]
	lm	r8,[m_screenheight]
	mcalls	mset3dscreen
	nop

	lm	r2,[m_screen3dypos_2]
	bra	.clrtherest3
	nop

.clrtherest
	mchk_smflag	r1,3dglasses
	beq		.clrtherest2
	nop

; set up second bg for the 3d glasses

	lm	r2,[m_screen3dypos_1]
	ibt	r0,#32
	to	r12
	sub	r6
	mcalls	msetblank	; clear the rest of the screen and part of the next
	nop

	with	r4		; screenwidth
	umult	r8		; *screenheight
	iwt	r0,#%1111111111
	and	r9
	add	r4
	sub	r6
	lm	r1,[m_screen3dpalette_2]
	to	r9
	add	r1

	lm	r4,[m_screenwidth]
	lm	r5,[m_screen3dxpos_1]
	lm	r6,[m_screenvheight]
	lm	r8,[m_screenheight]

	mcalls	mset3dscreen
	nop

	lm	r2,[m_screen3dypos_1]
	ibt	r0,#32
	sub	r6
	to	r12
	sub	r2
	mcalls	msetblank
	nop


.clrtherest2
	
	lm	r2,[m_screen3dypos_1]
.clrtherest3
	ibt	r0,#32
	sub	r6
	to	r12
	sub	r2
	mcalls	msetblank
	nop

	stop
	nop

; r7  = destination
; r10 = blanking char
; r12 = number of lines to clear (ie. 32*r12 words are cleared

msetblank

	iwt	r0,#32
	to	r12
	umult	r12
	beq	.noblank
	nop
	move	r0,r10
	move	r13,r15

	stw	[r7]

	inc	r7
	loop
	inc	r7	; fill non-3d area with border character
.noblank
	jmp	r11
	nop


; r4 = width (pixels)
; r5 = x position of window
; r6 = vheight (pixels)  (visible height of 3d screen)
; r7 = destination
; r8 = height  (pixels)  (actual height of 3d screen)
; r9 = initial character id
; r10= blanking character

mset3dscreen
	from	r4
	div8_r0
	move	r4,r0	; r4/8

	from	r6
	div8_r0
	move	r6,r0	; r6/8
	move	r3,r0

	from	r8
	div8_r0
	move	r8,r0	; r8/8
	

.looparound

	moves	r12,r5	; x position of window
	beq	.noleft
	nop

	move	r0,r10	; blanking character
	move	r13,r15

	stw	[r7]

	inc	r7
	loop
	inc	r7
.noleft

	move	r12,r4	; width of view area

	move	r0,r9	; current char in 3d area

	move	r13,r15

	stw	[r7]
	add	r8	; horizontal increment

	inc	r7
	loop
	inc	r7

	inc	r9	; next row

	ibt	r0,#32
	sub	r4
	to	r12
	sub	r5	; r12 = 32-(screenwidth+screen3d_xpos)
	beq	.noright
	nop

	move	r0,r10	; blanking char
	move	r13,r15

	stw	[r7]

	inc	r7
	loop
	inc	r7

.noright

	dec	r3	;	vertical counter
	bne	.looparound
	nop

	jmp	r11
	nop

