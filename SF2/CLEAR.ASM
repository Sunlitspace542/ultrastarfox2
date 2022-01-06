;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: clear.asm				*
;* 	Description	: Game Clear 				*
;*	Date		: 1994.9.1				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
	INCPUB	clear
;---------------------------------------------------------------------
;
;
;
;
;
;
;
;
;*********************************************************************
;	COLOR DATAS
;*********************************************************************
;
;
;
;*********************************************************************
;	------------------
;	bitmap demoprogram
;	------------------
;*********************************************************************

bitmapdemo_table
	Mgamemode_liststart
	Mgamemode_list	kmode_initmission,bitmapdemo_game
	Mgamemode_list	kmode_title,bitmapdemo_title
	Mgamemode_list	kmode_missionexplain,bitmapdemo_explain
	Mgamemode_list	kmode_playerdown,bitmapdemo_gameover
	Mgamemode_listend	bitmapdemo_total

;----------------------------------------------------------------------

main_gameclear_l
	Mbankprog
	php
	ai16

	ldx	#bitmapdemo_table&WM
	ldy	#bitmapdemo_total
	jsr	Lgamemode_idxjmp

	plp
	Mbankrtl

;*********************************************************************
;		*************************************************
; demo continue	*************************************************
;		*************************************************
;*********************************************************************

bitmapdemo_continue
bitmapdemo_battle
bitmapdemo_game
	rts

;======================================================================
;======================================================================
;======================================================================
;======================================================================
;======================================================================
;======================================================================
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
;
;
;
;*********************************************************************
;
;	--------------------------------------
; 	  score&message display library !!!!!
;	--------------------------------------
;
;*********************************************************************
;;
;;
;*********************************************************************
;	MACROS
;*********************************************************************

dispscore_addr =	*&0ff0000h


;---------------------------------------------------------------------
Mscore_dispdecimal	macro	[addr,color]
	db	idx_score_dispdecimal	
	db	{color}_message
	dw	{addr}&WM
	endm

;---------------------------------------------------------------------
Mscore_dispmessage	macro	[messageNo,color]
	db	idx_score_dispmessage
	db	{color}_message
	db	mtable_{messageNo}
	endm

;---------------------------------------------------------------------
Mscore_setcolor	macro	[color]
	db	idx_score_setcolor
	db	{color}_message
	endm

;---------------------------------------------------------------------
Mscore_dispascii	macro	[messageNo]
MYNARG	=	NARG
	CHK_NARG	1
	db	idx_score_dispascii
	db	idx_testmes_{messageNo}
	endm

;---------------------------------------------------------------------
Mscore_dispmessageNO	macro	[messageNo,color]
	db	idx_score_dispmessage
	db	{color}_message
	db	{messageNo}
	endm

;---------------------------------------------------------------------
Mscore_dispmessageONLY macro	[messageNo]
MYNARG	=	NARG
	CHK_NARG	1
	db	idx_score_dispmessageonly
	db	{messageNo}
	endm

;---------------------------------------------------------------------
Mscore_dispmessagework macro	[workaddr]
	db	idx_score_dispmessagework
	dw	{workaddr}&WM
	endm

;---------------------------------------------------------------------
Mscore_setcursorcolor macro	[addr,data]
	db	idx_score_setcursorcolor
	dw	{addr}
	db	{data}
	endm

;---------------------------------------------------------------------
Mscore_setcursorcolor2 macro	[addr,data]
	db	idx_score_setcursorcolor2
	dw	{addr}
	db	{data}
	endm

;---------------------------------------------------------------------
Mscore_exit		macro
	db	idx_score_codeexit
	endm

;---------------------------------------------------------------------
Mscore_setL_varB	macro	[addr,var]
	db	idx_score_setL_varB
	dl	{addr}
	db	{var}
	endm

;---------------------------------------------------------------------
Mscore_setB_m_xy	macro	[x,y]
	db	idx_score_setB_m_xy
	db	{x}
	db	{y}
	endm

;---------------------------------------------------------------------
Mscore_setB_m_x1	macro	[data]
	db	idx_score_setB_m_x1
	db	{data}
	endm

;---------------------------------------------------------------------
Mscore_setB_m_y1	macro	[data]
	db	idx_score_setB_m_y1
	db	{data}
	endm

;---------------------------------------------------------------------
Mscore_addB_m_x1	macro	[data]
	db	idx_score_addB_m_x1
	db	{data}
	endm

;---------------------------------------------------------------------
Mscore_partnerface	macro
	db	idx_score_partnerface
	endm

;---------------------------------------------------------------------
Mscore_messageINIT	macro
	db	idx_score_messageINIT
	endm

;---------------------------------------------------------------------
Mscore_contmessageINIT	macro
	db	idx_score_contmessageINIT
	endm

;---------------------------------------------------------------------
Mscore_start65816	macro
	db	idx_score_start65816
	endm
	
;---------------------------------------------------------------------
Mscore_end65816	macro
	pea	.addr\@&WM
	plx			; set pointer
	rts
.addr\@
	endm

;---------------------------------------------------------------------
	
;*********************************************************************
;	PROGRAMS
;*********************************************************************
Draw_bitmapmessage

.loop	lda.l	dispscore_addr,x
	and	#00ffh
	asl	a
	txy
	iny
	tax
	jsr	(.process,x)
	bra	.loop

;-----------------------------------------------------
.process	Mindexliststart
	Mindexlist	score_dispdecimal
	Mindexlist	score_dispmessage
	Mindexlist	score_dispmessageonly
	Mindexlist	score_dispmessagework
	Mindexlist	score_setL_varB
	Mindexlist	score_setB_m_xy
	Mindexlist	score_setB_m_x1
	Mindexlist	score_setB_m_y1
	Mindexlist	score_addB_m_x1
	Mindexlist	score_codeexit
	Mindexlist	score_dispascii
	Mindexlist	score_partnerface
	Mindexlist	score_messageINIT
	Mindexlist	score_start65816
	Mindexlist	score_setcursorcolor
	Mindexlist	score_setcursorcolor2
	Mindexlist	score_setcolor
	Mindexlist	score_contmessageINIT
	


;====================================================================
score_setcolor
	tyx
	lda.l	dispscore_addr,x
	and	#00ffh
	jsr	set_messagecolor

	inx
	rts

;====================================================================
score_start65816
	dey
	phy
	rts

;====================================================================
score_codeexit	
	pla	; <<
	rts

;====================================================================
score_setB_m_xy
	jsr	score_setB_m_x1
	txy
	bra	score_setB_m_y1

;====================================================================
score_setB_m_x1
	tyx
	lda.l	dispscore_addr,x
	and	#00ffh
	sta.l	m_x1
	inx
	rts

;====================================================================
score_setB_m_y1
	tyx
	lda.l	dispscore_addr,x
	and	#00ffh
	sta.l	m_y1
	inx
	rts

;====================================================================
score_addB_m_x1
	tyx
	lda.l	dispscore_addr,x
	and	#00ffh
	clc
	adc.l	m_x1
	sta.l	m_x1
	inx
	rts

;====================================================================
score_setL_varB
	phy
	tyx

	lda.l	dispscore_addr+1,x	; address
	sta	Xaddr+0
	lda.l	dispscore_addr+3,x	; bank
	sta	Xaddr+2

	lda.l	dispscore_addr+0	; value
	and	#00ffh
	sta	[Xaddr]

	inx
	inx
	inx
	inx
	
	rts

;====================================================================
score_setcursorcolor
	tyx
	phx

	lda.l	dispscore_addr+0,x	; address
	tay
	lda.l	dispscore_addr+2,x	; data
	and	#00ffh	
	tyx				; work address
	cmp.l	7e0000h,x
	beq	.frash

	lda	#WHITEcolor_message
	bra	.skip

.frash	lda	#BLUEfrash_message
.skip	jsr	set_messagecolor

	plx
	inx		; address
	inx
	inx		; data
	rts	


;====================================================================
score_setcursorcolor2
	tyx
	phx

	lda.l	dispscore_addr+0,x	; address
	tay
	lda.l	dispscore_addr+2,x	; data
	and	#00ffh	
	tyx				; work address
	cmp.l	7e0000h,x
	beq	.frash

	lda	#08h
	bra	.skip

.frash	lda	#REDfrash_message
.skip	jsr	set_messagecolor

	plx
	inx		; address
	inx
	inx		; data
	rts	


;====================================================================
score_dispdecimal
	phy				; >>
	tyx

	lda.l	dispscore_addr+0,x	;(B)
	and	#00ffh
	jsr	set_messagecolor

	lda.l	dispscore_addr+1,x	;(W) RAM address
	tax
	lda.l	7e0000h,x		; 7ebank RAM

	sta.l	m_txtdata

	call_mario	mprintdecimal

	plx				; <<
	inx
	inx
	inx
	rts

;====================================================================
score_dispmessagework
	tyx	
	lda.l	dispscore_addr+0,x
	inx				; +1
	phx
	tax
	lda.l	7e0000h,x
	bra	score_messagework_entry

;----------------------------------------------
score_dispmessageonly	
	tyx
	phx			; >>
	bra	score_messageonly_entry

;----------------------------------------------
score_dispmessage
	tyx

	lda.l	dispscore_addr+0,x
	and	#00ffh
	jsr	set_messagecolor
	inx
	phx			; >>	

score_messageonly_entry
	lda.l	dispscore_addr+0,x
score_messagework_entry
	and	#00ffh		
	dec	a		 ; >> address
	asl	a
	tax
	lda	#messagetable>>16
	sta.l	m_txtdatabank

	lda.l	messagetable,x
	inc	a		; DMMY DATA
	inc	a
	sta.l	m_txtdata

	call_mario	mprintWWstring


	plx			; <<
	inx

	rts


;====================================================================
score_dispascii
	phy
	tyx

	lda.l	dispscore_addr+0,x
	and	#00ffh	
	dec	a
	asl	a
	tax
	lda	#testmessage_table>>16
	sta.l	m_txtdatabank

	lda.l	testmessage_table,x
	inc	a
	inc	a
	sta.l	m_txtdata

	call_mario	mprintWWstring

	plx
	inx
	rts

;====================================================================

score_partnerface
	phy	; >>

	call_mario	mover_partnerdisp

	plx	; <<
	rts



;====================================================================
score_contmessageINIT
	lda	#normalfont
	bra	common_messageINIT
score_messageINIT
	lda	#atozfont
common_messageINIT
	tyx
	sta.l	m_font
	lda	#000eh
	sta.l	m_textcolour
	lda	#255
	sta.l	m_visualwidth

	lda.l	frashdata
	inc	a
	cmp	#8
	bcc	.set
	lda	#0
.set	sta.l	frashdata

	rts


;*********************************************************************
;	LIBRARYS
;*********************************************************************
;;;
;;; A register  =  color 
;;;	
;;; 
;;;	db	5,6,7,8,7,6
;---------------------------------------------------------------------

set_messagecolor
	phx				; >>
	phy				;   >>
	tay
	cpy	#10h
	bcc	.set
	lda.l	frashdata
	tax
	lda.l	REDfrash_table,x
	cpy	#REDfrash_message
	beq	.colorset
	lda.l	Xfrash_table,x
	cpy	#Xfrash_message
	beq	.colorset
	lda.l	BLUEfrash_table,x
.colorset	and	#00ffh
	tay
.set	tya
	sta.l	m_textcolour
	ply				; <<
	plx				;   <<
	rts


;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;====================================================================
;
;********************************************************************
;	BitJSR program
;********************************************************************
;
; X .... workRAM address
; Y .... ROM address
;
; DBR program address
;
;--------------------------------------------------------------------
bitBjsrprogram
.loop	lda.w	0,x
	and	#00ffh
	beq	.exit
	and.w	0,y
	beq	.nextbit

	phx		; >>
	phy		;   >>
	jsr	(1,x)	; Program
	ply		;   <<
	plx		; <<
.nextbit
	inx
	inx
	inx
	bra	.loop

.exit	rts

;====================================================================
;====================================================================
;END END END END END END END END END END END END END END END END END 
;====================================================================
;====================================================================

