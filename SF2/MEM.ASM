;**************************************************************************
;*                                                                         *
;*                              StarGlider                                 *
;*                              ----------                                 *
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                           Argonaut Software.      		      *	   
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*   File: MEM.ASM                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: MEMORY ALLOCATION ROUTINES FOR STRATEGIES.                      *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 28/10/92                                                        *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:		Dylan Cuthbert.      				      *	
;*                                                                         *
;***************************************************************************

	INCPUB	mem

; free memory structure

	structure	heap
	struct		fm_next,2
	struct		fm_prev,2
	struct		fm_length,2
	struct		fm_size,0
fm_sizeof	equ		fm_size-heap

; stack structure

	structure	heap
	struct		sp_prev,2
	struct		sp_data,4
	struct		sp_size,0
sp_sizeof	equ		sp_size-heap

firstblock	=	2	; location 0 is pointer to first freeblock



;---------------------------------------------------------
; initialise_memory_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Initialises free memory list
;---------------------------------------------------------

initmem_l
	php
	phb
	a8
	lda	#$7e
	pha
	plb		; switch data bank
	ai16

; set first free block to maximum size of heap

	ldx	#firstblock
	stz	fm_next,x
	stz	fm_prev,x

	lda	#heapsize-firstblock
	sta	fm_length,x

	stx	heap

	plb
	plp
	rtl


;---------------------------------------------------------
; avail_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Exit: a16 = amount of memory free
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: returns an approximate value for free mem
;---------------------------------------------------------

avail_l	LONGA
	php
	phb
	phx
	phy
	a8
	lda	#$7e
	pha
	plb
	a16

	ldx	heap
	lda	#0
.addagain	clc
	adc	fm_length,x
	ldy	fm_next,x
	tyx
	bne	.addagain

	ply
	plx
	plb
	plp
	rtl

;---------------------------------------------------------
; free_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = address of block to be freed
; assumes dbr=7e
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Frees the specified block
;---------------------------------------------------------
 
free_l	LONGA
	cmp	#0
	bne	.tisok
	rtl
.tisok
	phx
	phy
	php

	dec	a
	dec	a
	sta	fmtemp1
	a8
	storenasty
	nastyon		; run the mario chip in parallel
	a16
	lda	fmtemp1		; start pos
	tax
	clc
	adc	heap,x
	sta	fmtemp2		; end pos
	lda	heap,x
	sta	fmtemp3		; length

; search for free block to add memory to (easy insert)
	ldy	heap
	lbeq	.newlist	; if no freelist then create one
.scanfree
	tya
	clc
	adc	fm_length,y
	cmp	fmtemp1
	beq	.afterit

	cpy	fmtemp2
	beq	.beforeit

	lda	fm_next,y
	tay
	bne	.scanfree

; if there is no easy insertion create a new block

	lda	heap,x
	sta	fm_length,x

	ldy	heap
	stx	heap

	txa
	sta	fm_prev,y
	tya
	sta	fm_next,x
	stz	fm_prev,x

	bra	.success

.afterit
; the block to free is after the block in y (easy insert #1)

	lda	fm_length,y
	clc
	adc	heap,x
	sta	fm_length,y	; just increase the length to include it
	tyx
	jsr	.optimise
	bra	.success

.beforeit
; the block to free is before the block in y (easy insert #2)

	lda	fm_length,y
	clc
	adc	heap,x
	sta	fm_length,x
	lda	fm_next,y
	sta	fm_next,x
	lda	fm_prev,y
	sta	fm_prev,x

; alter pointers to point to x rather than y
	txa
	ldy	fm_next,x
	beq	.endoflist	
	sta	fm_prev,y
.endoflist	ldy	fm_prev,x
	beq	.first
	sta	fm_next,y
	bra	.notfirst
.first	sta	heap
.notfirst

	jsr	.optimise
	bra	.success
	
.newlist
	stx	heap
	lda	heap,x
	sta	fm_length,x
	stz	fm_prev,x
	stz	fm_next,x
.success
.cantfree
	sta	fmtemp1
	a8
	restorenasty
	a16
	lda	fmtemp1
	plp
	ply
	plx
	rtl

;**********
.delink
; delink x from free list (corrupts y)
	lda	fm_prev,x
	ldy	fm_next,x
	beq	.endoflist2
	sta	fm_prev,y
.endoflist2	tax
	beq	.first2
	tya
	sta	fm_next,x
	bra	.notfirst2
.first2	sty	heap
.notfirst2	rts

;**********
.optimise
; scans for blocks to optimise, block to optimise in x
; to yuu no wa: joins adjacent free blocks together
	stx	fmtemp1	; start position
	txa
	clc
	adc	fm_length,x
	sta	fmtemp2	; end position

	ldy	heap
.nextscan	cpy	fmtemp2
	beq	.joinxy
	tya
	clc
	adc	fm_length,y
	cmp	fmtemp1
	beq	.joinyx

	lda	fm_next,y
	tay
	bne	.nextscan
	rts
; ok, if x<y
.joinxy
	lda	fm_length,x
	clc
	adc	fm_length,y
	sta	fm_length,x

	stx	fmtemp1
	tyx		; delink y from free block list
	jsr	.delink

	ldx	fmtemp1
	rts

; ok, if y<x
.joinyx
	lda	fm_length,y
	clc
	adc	fm_length,x
	sta	fm_length,y

	sty	fmtemp1
	jsr	.delink	; delink x from free block list

	ldx	fmtemp1
	rts

	

;---------------------------------------------------------
; alloc_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = length of block wanted
; assumes dbr=7e
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Exit:  a16 = address of block wanted (0 if unavailable)
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Allocates memory block
;---------------------------------------------------------

alloc_l	LONGA
	phx
	phy
	php

	sta	fmtemp1
	a8
	storenasty	; run in parallel with the mario chip
	nastyon
	a16

	lda	fmtemp1

	inc	a
	and	#$fffe	; round to nearest word
	beq	.notfound
	inc	a
	inc	a		; allow for mem block header (length of block)
	cmp	#fm_sizeof	; minimum size is size of free block
	bcs	.noadjust
	lda	#fm_sizeof
.noadjust

	ldx	heap	; get first pointer
	beq	.notfound
.scanfree
	cmp	fm_length,x
	bcc	.getit
	beq	.getit
	ldy	fm_next,x
	tyx
	bne	.scanfree
	lda	#0
	bra	.notfound

; found a block in x; adjust free blocks
.getit
	sta	fmtemp1		; length to allocate
	lda	fm_length,x
	sec
	sbc	fmtemp1		; get difference
	cmp	#fm_sizeof	; enough room for free block?
	bcc	.remfreeblock
	beq	.remfreeblock
; if room for free block just adjust current free block's values
	sta	fm_length,x
	txa
	clc
	adc	fm_length,x
	tax
	lda	fmtemp1
	sta	heap,x		; store length of block
	inx
	inx
	txa			; return the alloc'd address
	bra	.success
.remfreeblock
	lda	fm_length,x	; set length to allocate max
	sta	fmtemp1
	stx	fmtemp2
; adjust the pointers to ignore current free block
	lda	fm_next,x
	ldy	fm_prev,x
	beq	.first
	sta	fm_next,y
	bra	.notfirst
.first	sta	heap
.notfirst	tax
	beq	.endoflist
	tya
	sta	fm_prev,x
.endoflist	ldx	fmtemp2		; restore pointer to block
	lda	fmtemp1
	sta	heap,x		; store length
	inx
	inx
	txa

.success
.notfound
	sta	fmtemp1
	a8
	restorenasty
	a16
	lda	fmtemp1
	plp
	ply
	plx
	rtl

;---------------------------------------------------------
; salloc_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = length of block wanted
;        x16 = alien to allocate block for
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Exit:  a16 = address of block wanted (0 if unavailable)
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Allocates memory block for alien
;---------------------------------------------------------

salloc_l	longa
	longi

	clc
	adc	#2

	jsl	alloc_l
	cmp	#0
	beq	.exit
	phy
	tay

	lda	al_memptr,x
	sta	heap,y

	tya
	sta	al_memptr,x

	ply

	inc	a
	inc	a

.exit	rtl


;---------------------------------------------------------
; sfree_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = address of block to be freed
;        x16 = alien to free block for
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Frees memory block for an alien
;---------------------------------------------------------

sfree_l	longa
	longi

	phy
	phx

	dec	a
	dec	a

	sta	fmtemp1

	ldy	al_memptr,x
	beq	.none
	phx
	ldx	#0
.nextone
	cpy	fmtemp1
	beq	.found
	tyx
	ldy	heap,x
	bne	.nextone

	plx
	ply
	blink	2

	rtl
.found	lda	heap,y
	cpx	#0
	beq	.setstrat
	sta	heap,x	; store next alien ptr
	plx
	bra	.nosetstrat
.setstrat	plx
	sta	al_memptr,x
.nosetstrat
	tya
	jsl	free_l	; free it
	
.none
	plx
	ply
	rtl

;---------------------------------------------------------
; sallfree_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: x16 = alien block
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Frees ALL memory blocks for an alien
;---------------------------------------------------------

sallfree_l
	longi
	phx
	phy
	php
	phb
	a8
	lda	#$7e
	pha
	plb
	a16

	ldy	al_memptr,x
	beq	.nothing
	phx
.andagain
	ldx	heap,y
	tya
	jsl	free_l
	txy
	bne	.andagain

	plx
	stz	al_memptr,x
.nothing
	stz	al_resources,x
	stz	al_stackptr,x
	stz	al_stratmem,x
	plb
	plp
	ply
	plx
	rtl


;-------------------------------------------------------------
; mpush_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = stack pointer
;        stackdata.32 = data to push
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Exit:  returns a16=0 if failed
;        returns carry if failed
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Pushes values in stackdata onto a virtual stack
;-------------------------------------------------------------

mpush_l	longa
	blink 3
	phx
	php
	phb
	pha
	a8
	lda	#$7e
	pha
	plb
	a16

	lda	#sp_sizeof
	jsl	alloc_l
	cmp	#0
	bne	.notfailed
	plx	; dummy, irimasen
	plb
	plp
	plx
	sec
	rtl

.notfailed	tax
	pla
	sta	sp_prev,x
	lda	stackdata
	sta	sp_data,x
	lda	stackdata+2
	sta	sp_data+2,x
	txa
.failed
	plb
	plp
	plx
	clc
	rtl


;-------------------------------------------------------------
; smpush_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = stack pointer
;        x16 = alien block
;        stackdata.32 = data to push
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Exit:  returns a16=0 if failed
;        returns carry if failed
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Pushes values in stackdata onto a virtual stack
;              and resource tracks the alloc for a strategy
;-------------------------------------------------------------

smpush_l	longa
	phx
	php
	phb
	pha
	a8
	lda	#$7e
	pha
	plb
	a16

	IFEQ	1
; Method #1
; allocates structure for each stack item

	lda	#sp_sizeof
	jsl	salloc_l
	cmp	#0
	bne	.notfailed
	plx	; dummy, irimasen
	plb
	plp
	plx
	sec
	rtl

.notfailed	tax
	pla
	sta	sp_prev,x
	lda	stackdata
	sta	sp_data,x
	lda	stackdata+2
	sta	sp_data+2,x
	txa
.failed
	ELSEIF
; Method #2
; allocates new structure if exceeds current stack's boundaries

	pla
	phy
	tay
	bne	.notnew	; begin fresh stack if one doesn't exist

	lda	#1+4*8
	jsl	salloc_l
	tay
	a8
	lda	#1
	sta	heap,y
	a16
	bra	.norealloc
.notnew	LONGA
	lda.w	heap,y
	and	#255
	inc	a
	a8
	sta.w	heap,y
	bit	#7
	a16
	bne	.norealloc

; calculate size of new block
	clc
	adc	#8
	asl	a
	asl	a
	inc	a
	jsl	srealloc_l	; re-allocate it
	cmp	#0
	bne	.okcarryon
	blink	3
.okcarryon
	tay			; new block into y
	
.norealloc	LONGA
	phy
	lda.w	heap,y
	and	#255
	asl	a
	asl	a	; *4
	sty	fmtemp1
	sec
	adc	fmtemp1
	tay		; y = y + (*y)*4 +1

	lda	stackdata
	sta	heap-4,y
	lda	stackdata+2
	sta	heap-2,y
		
	pla		; return pointer to stack
	ply
	ENDC
	plb
	plp
	plx
	clc
	rtl




;-------------------------------------------------------------
; mpull_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = stack pointer
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Exit:  returns a16=0 if failed
;        stackdata.32 = pulled data
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Pulls values from the stack to stackdata
;-------------------------------------------------------------

mpull_l	longa
	phx
	php
	phb
	i8
	ldx	#$7e
	phx
	plb
	i16

	IFEQ	1
; method #1
; searches through link list of stack structures

	tax
	beq	.endofstack
	lda	sp_prev,x
	pha
	lda	sp_data,x
	sta	stackdata
	lda	sp_data+2,x
	sta	stackdata+2
	txa
	jsl	free_l
	pla
.endofstack
	ELSEIF
; Method #2
; gets data from end of list (reallocs list if decreases past certain
; boundaries in order to preserve memory) -- not yet

	phy
	tay
	bne	.nobl2
	blink	3
.nobl2
	phy

	lda.w	heap,y
	and	#255
	bne	.nobl
	blink	3
.nobl	dec	a
	a8
	sta.w	heap,y
	a16
	asl	a
	asl	a
	sty	fmtemp1
	sec
	adc	y1
	tay
	lda	heap,y
	sta	stackdata
	lda	heap+2,y
	sta	stackdata+2

	pla	; return the stack ptr
	ply
	ENDC
	plb
	plp
	plx
	rtl


;-------------------------------------------------------------
; smpull_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = stack pointer
;        x16 = alien block
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Exit:  returns a16=0 if failed
;        stackdata.32 = pulled data
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Pulls values from the stack to stackdata
;              with resource tracking for strategies
;-------------------------------------------------------------

smpull_l	longa
	phx
	phy
	php
	phb
	pha
	a8
	lda	#$7e
	pha
	plb
	a16
	ply

	IFEQ	1
; method #1
; searches through link list of stack structures

	beq	.endofstack
	lda	sp_prev,y
	pha
	lda	sp_data,y
	sta	stackdata
	lda	sp_data+2,y
	sta	stackdata+2
	tya
	jsl	sfree_l
	pla
.endofstack

	ELSEIF
; Method #2
; gets data from end of list (reallocs list if decreases past certain
; boundaries in order to preserve memory)

	phy
	lda.w	heap,y
	and	#255
	bne	.nobl
	blink	3		; pulled past beginning of stack
.nobl	dec	a
	a8
	sta.w	heap,y
	a16
	asl	a
	asl	a
	sty	fmtemp1
	sec
	adc	fmtemp1
	tay
	lda	heap,y
	sta	stackdata
	lda	heap+2,y
	sta	stackdata+2

	pla	; return the stack ptr
	ENDC

	plb
	plp
	ply
	plx
	rtl


;---------------------------------------------------------
; realloc_l
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Entry: a16 = length of block wanted
; Entry: y = block to reallocate
; Entry: x = alien to resource track for
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Exit:  a16 = address of block wanted (0 if unavailable)
; Exit:  x unchanged
; Exit:  y trashed
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; Description: Re-allocates memory block to a new size
;---------------------------------------------------------
	LONGA
	LONGI
srealloc_l
; store the new length wanted
	cpy	#0
	lbeq	salloc_l

	sta	smtemp1

	a8
	storenasty	; runs in parallel with the mario chip
	nastyon
	a16

	lda	smtemp1
; allocate the new amount
	jsl	salloc_l
	beq	.exiterr

; preserve data
	pha
	phy
	phx
; copy the data over from old to new
	tyx	; x=source
	tay	; y=destination
; copy the minimum length
	lda	fm_length-(fm_sizeof+2),x
	cmp	smtemp1
	bcs	.usenewlen
	sta	smtemp1
.usenewlen	a8
.copy
	lda.w	heap,x
	sta.w	heap,y
	inx
	iny

	a16
	dec	smtemp1
	a8
	bne	.copy

	a16

; free the old data area

	plx
	pla	; restore y as a for the sfree routine

	jsl	sfree_l	

	pla	; restore the newly allocated address
	sta	smtemp1

	a8
	restorenasty
	a16

	lda	smtemp1
	rtl
.exiterr
	blink 3
	rtl

