;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: oamset.asm				*
;* 	Description	: oamset				*
;*	Date		: 1994.11.3				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;
;*********************************************************************
;         -----------------	
;	OAMset macros
;         -----------------
;*********************************************************************
;*********************************************************************
;	SEQ MACROS
;*********************************************************************
MSseq_code	macro	[code]
	db	80h+{code}
	endm

;---------------------------------------------------------------------
MSseq_end	macro	
	MSseq_code	idx_anime_repeat
	endm

;---------------------------------------------------------------------
MSseq_repeat	macro	
	MSseq_code	idx_anime_repeat
	endm

;---------------------------------------------------------------------
MSseq_kill	macro	
	MSseq_code	idx_anime_kill
	endm

;---------------------------------------------------------------------
MSseq_sound	macro	[sound]
	MSseq_code	idx_anime_sound
	db	{sound}
	endm

;---------------------------------------------------------------------
MSseq_BGM	macro	[sound]
	MSseq_code	idx_anime_bgm
	db	{sound}
	endm

;---------------------------------------------------------------------
MSseq_attr	macro	[attr]
	MSseq_code	idx_anime_attr
	db	{attr}
	endm

;---------------------------------------------------------------------
MSseq_attrW	macro	[attr]
	MSseq_code	idx_anime_attrW
	dw	{attr}
	endm

;---------------------------------------------------------------------
MSseq_jmp	macro	[addr]
	MSseq_code	idx_anime_jmp
	dw	{addr}&WM
	endm

;---------------------------------------------------------------------
MSseq_objlimit	macro	[data]
	MSseq_code	idx_anime_objlimit
	db	{data}
	endm

;---------------------------------------------------------------------
MSseq_setVX	macro	[offsetX]
	MSseq_code	idx_anime_setVX
	db	{offsetX}
	endm

;---------------------------------------------------------------------
MSseq_friendwait	macro	[num]
	MSseq_code	idx_anime_friendwait
	db	xfriend_{num}
	endm
;---------------------------------------------------------------------
MSseq_flagset	macro
	MSseq_code	idx_anime_flagset
	endm

;=====================================================================
;
;
;
;
;
;
;
;
;
;
;*********************************************************************
;	OAM PROGRAM MACROS
;*********************************************************************
MS_getBS	macro
	lda.w	0,y
	iny
	Msex
	endm

;---------------------------------------------------------------------
MS_getW	macro
	lda.w	0,y
	iny
	iny
	endm

;---------------------------------------------------------------------
MS_setsubpointer	macro
	lda	sprite_register
	sec
	sbc	sprite_offset	; 0 or 220h
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	clc
	adc	sprite_offset	; 0 or 220h
	endm

;=====================================================================
;
;
;
;
;
;***********************************************************************
;	OAMset works
;***********************************************************************

SWrompointer	equ	Xaddr	; ROM address-pointer
SWcenterH	equ	Xwork0	; ******** VVVVVVVV.
SWcenterV	equ	Xwork1	; ******** HHHHHHHH.
SWobjcounter	equ	Xwork2	; 00000000 00******
SWobjadd	equ	Xwork4
SWsubset	equ	Xwork5	; subset counter
SWobjlimit	equ	Xwork6	; object limitter

;=====================================================================
;
;
;
;
;
;***********************************************************************
;          ------------------
;	oamset programs
;          ------------------
;***********************************************************************
;***********************************************************************
;	oamset program
;***********************************************************************

Newoamset	Mbankprog

	jsr	New_skipoam	; OAM skip
	jsr	New_setanime	; OAM animation
	jsr	New_setoamparam	; OAM parameter set
	jsr	New_setoam	; OAM set
	jsr	New_skipoam	; OAM skip

	Mbankrts


Newoamset_next
	Mbankprog
	jsr	New_setoamparam	; OAM parameter set
	jsr	New_setoam	; OAM set
	jsr	New_skipoam	; OAM skip
	Mbankrts

;***********************************************************************
;	oamset program		; HANYOU PROGRAM
;***********************************************************************
;
; <input>	X = animeSEQ  Number
;	Y = animation No
; 	A = position center Y/X
;
; <execute>	SetOAMbuffer 
;
;-----------------------------------------------------------------------
;;	anime_counter
;;	anime_pointer
;-----------------------------------------------------------------------
;;
;;common_oamanime
;;	pha	
;;	txa	
;;	asl	a
;;	asl	a
;;	tax
;;	tya			; y = animation Number
;;	asl	a		; clc
;;	adc.l	New_oamlist+2,x
;;	tax
;;	lda.w	0,x		; Read Object Pointer
;;	sta	SWrompointer	; 
;;	stz	SWobjadd	; Attribute
;;	bra	common_oamset_entry
;;
;***********************************************************************
;	oamset program		; HANYOU PROGRAM
;***********************************************************************
;
; <input>	Y = sprite ROM pointer
; 	A = position center Y/X
;
; <execute>	SetOAMbuffer 
;
;-----------------------------------------------------------------------

common_oamset
	ldx	#0
common_oamset_moveattr
	stx	SWobjadd
	sty	SWrompointer	; ROM-poitner
	tay			; 
	and	#00ffh
	sta	SWcenterH
	tya
	xba
	and	#00ffh
	sta	SWcenterV
	stz	SWobjlimit
;-----------------------------------------------------------------------
common_oamset_entry
	ldx	#220h
	cpx	sprite_register
	beq	.skip
	bcc	.skip
	ldx	#0
.skip	stx	sprite_offset	;(double buffer)
;-----------------------------------------------------------------------
	jsr	New_skipoam
	jsr	New_setoam
	jsr	New_skipoam
;-----------------------------------------------------------------------
	rts

;=======================================================================
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;***********************************************************************
;          --------------
;	set OAM lib
;          --------------
;***********************************************************************
;***********************************************************************
;	Set oam parameter
;***********************************************************************

New_setoamparam

	ldx	register
	Mcp_work	x,SWobjadd,_charadd
	Mcp_work	x,SWcenterH,_axisX
	Mcp_work	x,SWcenterV,_axisY
	Mcp_work	x,SWobjlimit,_objlimit

	rts

;***********************************************************************
;	oamset skip
;***********************************************************************
New_skipoam
	lda	sprite_register
	bit	#01111b
	beq	.exit
	ldy	#0e0e0h
.loop	tax
	tya
	sta.l	sprites,x
	txa
	inc	a
	inc	a
	inc	a
	inc	a
	bit	#01111b
	bne	.loop
	sta	sprite_register
.exit	rts

;;
;;
;;
;;
;;
;;
;;
;***********************************************************************
;          --------------------
;	oamset animation
;          --------------------
;***********************************************************************
;***********************************************************************
;	new Set sprite animation
;***********************************************************************
New_setanime

	ldx	register
	lda	_anime_trigger,x
	bpl	.newanime
;------------------------------------------------------------------------
	lda	_anime_counter,x	;time-wait
	beq	.entryanime
	dec	a
	sta	_anime_counter,x
.exitanime
	lda	_obj_pointer,x		; copy rom pointer
	sta	SWrompointer
	rts
;------------------------------------------------------------------------
;
;
;
;
;------------------------------------------------------------------------
.newanime	ora	#8000h			; set flag
	sta	_anime_trigger,x	; reset animation trigger
	stz	_anime_counter,x	; reset animation counter  
	jsr	anime_make
;------------------------------------------------------------------------
.entryanime
	ldy	_anime_pointer,x	; ROM pointer
.nextcode
	lda.w	0,y			; ROM-READ
	bit	#0080h
	beq	.timerset
	and	#007fh
	asl	a
	tax
	jsr	(.newanime_code,x)
	sty	_anime_pointer,x
	bra	.nextcode
;------------------------------------------------------------------------
.timerset	and	#007fh
	dec	a
	sta	_anime_counter,x
;------------------------------------------------------------------------
	lda.w	1,y			; ROM-READ
	and	#00ffh
	asl	a
	adc	_OBJaddress,x		; basic address
	tax
	lda.w	0,x			; pointer address
	ldx	register
	sta	_obj_pointer,x
	iny				; pointer++ (INC)
	iny
	sty	_anime_pointer,x	; pointer next
	bra	.exitanime

;------------------------------------------------------------------------
;	ANIMATION PROGRAM CODE TABLE
;------------------------------------------------------------------------
.newanime_code
	Mindexliststart
	Mindexlist	anime_repeat
	Mindexlist	anime_kill
	Mindexlist	anime_sound
	Mindexlist	anime_jmp
	Mindexlist	anime_setVX
	Mindexlist	anime_friendwait
	Mindexlist	anime_bgm
	Mindexlist	anime_attr
	Mindexlist	anime_attrW
	Mindexlist	anime_objlimit
	Mindexlist	anime_flagset

;------------------------------------------------------------------------
; 	FRIEND WAIT (SPECIAL)
;------------------------------------------------------------------------
anime_friendwait
	ldx	register

	lda.w	1,y
	and	#00ffh
	cmp.l	player_friend
	bne	.exit

	lda	#1fh			; wait counter set
	sta	_anime_counter,x
	jmp	exit_animedata_d2

.exit	iny
	iny
	rts

;------------------------------------------------------------------------
; 	NEXT FRAME SPEED-X MOVE
;------------------------------------------------------------------------
anime_setVX
	lda.w	1,y
	and	#00ffh
	xba
	ldx	register
	sta	_velocityX,x
	iny		 		; code 
	iny		 		; data
	rts

;------------------------------------------------------------------------
; 	animation 
;------------------------------------------------------------------------
anime_attr
	lda.w	1,y
	and	#00ffh
	xba
	ldx	register
	sta	_charadd,x
	iny		 		; code 
	iny		 		; data
	rts

anime_attrW
	lda.w	1,y
	ldx	register
	sta	_charadd,x
	iny		 		; code 
	iny		 		; data
	iny
	rts

;------------------------------------------------------------------------
; 	objlimit program
;------------------------------------------------------------------------
anime_objlimit
	lda.w	1,y
	and	#00ffh
	ldx	register
	sta	_objlimit,x
	iny		 		; code 
	iny		 		; data
	rts

;------------------------------------------------------------------------
; 	JMP ADDRESS
;------------------------------------------------------------------------
anime_jmp
	ldx	register
	lda.w	1,y		; jmp new pointer
	tay
	rts

;------------------------------------------------------------------------
; 	SET SOUND TRIGGER
;------------------------------------------------------------------------
anime_sound
	phy			; >>
	lda.w	1,y
	and	#00ffh
	ksound_a
	ply			; <<
	ldx	register
	iny
	iny
	rts

;------------------------------------------------------------------------
; 	Set DCFLAG
;------------------------------------------------------------------------
anime_flagset
	lda	#0ffffh
	sta	_dcflag+bestscore_struct
	ldx	register
	iny
	rts

;------------------------------------------------------------------------
; 	SET BGM TRIGGER
;------------------------------------------------------------------------
anime_bgm
	phy			; >>
	lda.w	1,y
	and	#00ffh
	a8
	kbgm_a
	a16
	ply			; <<
	ldx	register
	iny
	iny
	rts

;------------------------------------------------------------------------
; 	KILL OBJ-LIST 
;------------------------------------------------------------------------
anime_kill
	ldx	register
	stz	_program,x
	stz	SWrompointer
	pla			; << return program
	rts
;------------------------------------------------------------------------
; 	REPEAT ANIMATION DATA
;------------------------------------------------------------------------
anime_repeat	
	ldx	register
	jsr	anime_make
	ldy	_anime_pointer,x
	rts

;------------------------------------------------------------------------
; 	<<<< newdata store >>>>
;------------------------------------------------------------------------
anime_make	phy
	lda	_anime_trigger,x
	txy				; y = register
	asl	a
	tax
	lda.l	New_oamlist+0,x
	sta.w	_anime_pointer,y	; anime SEQ address
	lda	#oam_testtable&WM	; table index
	sta.w	_OBJaddress,y		; object table address
	tyx
	ply
	rts

;------------------------------------------------------------------------
; 	<<<< animation exit >>>>
;------------------------------------------------------------------------
exit_animedata_d2
	iny
exit_animedata_d1
	iny
exit_animedata
	sty	_anime_pointer,x	; set pointer next
	PLA				; << DEL RETURN

	lda	_obj_pointer,x		; copy rom pointer
	sta	SWrompointer
	rts

;------------------------------------------------------------------------
;
;
;
;
;
;***********************************************************************
;          --------------------
;	oamset blockobj
;          --------------------
;***********************************************************************
;***********************************************************************
;	Set oam parameter
;***********************************************************************
;;
;; Y ... sprite pointer
;; X ... rom pointer
;;
;=======================================================================

oamsetlib
	Mbankprog
	sty	sprite_register
	stx	SWrompointer
	jsr	New_setoam
	ldy	sprite_register
	Mbankrts

;***********************************************************************
;	Set oam parameter
;***********************************************************************
exit_setoam	rts
;-----------------------------------------------------------------------

New_setoam
	ldy	SWrompointer	
	beq	exit_setoam

	ldx	sprite_register

;-----------------------------------------------------------------------
;	nomal set sprite
;-----------------------------------------------------------------------

	lda.w	0,y
	iny
	bit	#0c0h
	beq	.bigonly
	bit	#080h
	beq	.smallonly

;-----------------------------------------------------------------------
;	subset object		code (11)
;-----------------------------------------------------------------------
	and	#003fh
	beq	exit_setoam
	sta	SWobjcounter
	dec	a
	lsr	a
	lsr	a
	sta	SWsubset
;
	MS_setsubpointer
	tax			; X = subpointer
;
	a8
.subsetloop	lda.w	0,y		; sizedata READ
	iny
	sta.l	sprites+200h,x	; Set OAM-SUB
	inx
	dec	SWsubset
	bpl	.subsetloop
	a16
	bra	.oamset

;-----------------------------------------------------------------------
;	big only object		code (00)
;-----------------------------------------------------------------------
.bigonly	and	#003fh
	beq	exit_setoam
	PHY			; >>
	sta	SWobjcounter
	dec	a
	lsr	a
	lsr	a
	tay			; Y = loopcounter
;
	MS_setsubpointer
	tax			; X = subpointer
;
	a8
	lda	#0aah		; size big
.bigloop	sta.l	sprites+200h,x	; Set OAM-SUB
	inx
	dey
	bpl	.bigloop
	a16
	PLY			; <<
	bra	.oamset

;-----------------------------------------------------------------------
;	small only object	code (01)
;-----------------------------------------------------------------------
.smallonly	and	#03fh
	beq	.exit
	sta	SWobjcounter

;-----------------------------------------------------------------------
;	nomal set sprite
;-----------------------------------------------------------------------
.oamset
	ldx	sprite_register
.oamloop
	MS_getBS
	cmp	#0ff80h		; special code check
	bne	.oamentry 
	lda.w	0,y		; set new oamset pointer
	tay
	bra	.oamloop

.oamentry	
	clc
	adc	SWcenterH
	cmp	#100h
	bcc	.entry
	iny
	lda	#0e0h		; overflow(H)
	bra	.setV

.entry	sta.l	sprites+0,x

	MS_getBS
	clc
	adc	SWcenterV
.setV	a8
	sta.l	sprites+1,x
	a16

	MS_getW
	eor	SWobjadd
	sta.l	sprites+2,x

	Minx4

	dec	SWobjlimit	; objset limit
	beq	.setend
	dec	SWobjcounter
	bne	.oamloop

	stx	sprite_register
	
.exit	rts
;-----------------------------------------------------------------------
; <<<< obj >>>>  countlimit
;-----------------------------------------------------------------------
.setendloop
	lda	#0e0e0h
	sta.l	sprites+0,x	
	Minx4
.setend
	dec	SWobjcounter
	bne	.setendloop
	stx	sprite_register
	rts
		

;-----------------------------------------------------------------------
;
;
;
;
;
;
;
;
;***********************************************************************
;          ---------------------------------
;	oamset simpleobj ( Debugmode )
;          ---------------------------------
;***********************************************************************
;***********************************************************************
;	Print Display Message
;***********************************************************************
;; 
;; < input >	Y = message pointer
;;	X = position YX
;;	sprite_register
;;
;;message	db	_a,_b,_c,_d,_e,_f,ed
;;
;-----------------------------------------------------------------------
message_attr	equ	3000h
pos_work	equ	Xwork7
;-----------------------------------------------------------------------
OBJ_print
	ply			; <
	stx	pos_work
	ldx	sprite_register
.loop	lda.w	1,y
	iny
	and	#00ffh
	cmp	#ed		;
	beq	.exit
	ora	#message_attr
	sta.l	sprites+2,x	;
	lda	pos_work
	sta.l	sprites+0,x	;
	clc
	adc	#0008h
	sta	pos_work
	inx
	inx
	inx
	inx
	bra	.loop
.exit	stx	sprite_register
	ldx	pos_work	; next position
	phy			; 
	rts



;***********************************************************************
;	score count 00 - 65535
;***********************************************************************
;
;	Areg = 
;
;	Xwork0	low 1
;	Xwork1
;	Xwork2
;=======================================================================
dec_00_65535
;---------------------------------------------------
	tay
	a8
;---------------------------------------------------
	jsr	call_div_u16u8
	sta	Xwork0+0	; 
	jsr	call_div_u16u8	;
	asl	a
	asl	a
	asl	a
	asl	a		; 
	ora	Xwork0+0	; 
	sta	Xwork0+0
;---------------------------------------------------
	jsr	call_div_u16u8
	sta	Xwork0+1	; 
	jsr	call_div_u16u8
	asl	a
	asl	a
	asl	a
	asl	a		; 
	ora	Xwork0+1	; 
	sta	Xwork0+1
;---------------------------------------------------
	jsr	call_div_u16u8
	sta	Xwork1+0	; 
	stz	Xwork1+1
;---------------------------------------------------
	a16
	rts
;=======================================================================
	shorta
call_div_u16u8
	sty	4204h
	lda	#10
	sta	4206h
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ldy	4214h	; KOTAE !!
	lda	rdmpylr		; 
	rts
	longa
;=======================================================================

;***********************************************************************
;	Print Decimal Object
;***********************************************************************
;; 
;; < input >	A = hex-data (0000-ffff)
;;	Y = position YX
;;	sprite_register
;;
;-----------------------------------------------------------------------
number_data	db	70h,71h,72h,73h,74h,75h,76h,77h,78h,79h
;-----------------------------------------------------------------------

OBJ_three	pha
	xba
	jsr	OBJ_digit
	pla
	bra	OBJ_byte
OBJ_word	pha			;>>
	xba
	jsr	OBJ_byte
	pla			;<
OBJ_byte	pha			;>>
	lsr	A		;W
	lsr	A		;W
	lsr	A		;W
	lsr	A		;W
	jsr	OBJ_digit
	pla			;<
OBJ_digit	and	#000FH
	tax
	lda.l	number_data,x
	and	#00ffh	
	ora	#3200h
OBJ_set	ldx	sprite_register
	sta.l	sprites+2,x	;
	tya
	sta.l	sprites+0,x	;
	clc
	adc	#0008h
	inx
	inx
	inx
	inx
	stx	sprite_register ; <<
	tay			;
	rts


;=============================================================
wnumber_dataH
	messet  15h,nomal,attr1
	messet  16h,nomal,attr1
	messet  10h,hflip,attr1
	messet  17h,nomal,attr1
	messet  18h,nomal,attr1
	messet  27h,vflip,attr1
	messet  7ch,nomal,attr1
	messet  24h,hvflip,attr1
	messet  19h,nomal,attr1
	messet  15h,hflip,attr1
;===============================================
wnumber_dataL
	messet  15h,vflip,attr1
	messet  21h,nomal,attr1
	messet  27h,nomal,attr1
	messet  17h,vflip,attr1
	messet  28h,nomal,attr1
	messet  26h,nomal,attr1
	messet  12h,vflip,attr1
	messet  14h,hvflip,attr1
	messet  19h,vflip,attr1
	messet  7ch,hvflip,attr1
;===============================================


WOBJ_three	pha
	xba
	jsr	WOBJ_digit
	pla
	bra	WOBJ_byte
WOBJ_word	pha			;>>
	xba
	jsr	WOBJ_byte
	pla			;<
WOBJ_byte	pha			;>>
	lsr	A		;W
	lsr	A		;W
	lsr	A		;W
	lsr	A		;W
	jsr	WOBJ_digit
	pla			;<
WOBJ_digit	and	#000FH
	asl	a
	tax
	lda.l	wnumber_dataL,x
	pha			;>>
	lda.l	wnumber_dataH,x
	ldx	sprite_register
	sta.l	sprites+2,x	;
	pla			;<<
	sta.l	sprites+2+4,x
;-----------------------------------------
	tya
	sta.l	sprites+0,x	;
	pha			;>>
	clc	
	adc	#0800h
	sta.l	sprites+4,x	;
;-----------------------------------------
	pla			;<<
	clc
	adc	#0008h
	tay
	txa
	clc
	adc	#0008h
	tax
	stx	sprite_register ; <<
	rts

;=============================================================
;;
;;
;;
;;
;;
;;
;;
;======================================================================
;======================================================================
; END END END END END END END END END END END END END END END END END 
;======================================================================
;======================================================================

