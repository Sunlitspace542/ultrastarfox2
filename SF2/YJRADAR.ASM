DBscale	equ	0
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: yjradar.asm				*
;* 	Description	: object radar ( blockmap )		*
;*	Date		: 1994.7.26				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
	INCPUB  yjradar
;---------------------------------------------------------------------
	incfile yajima.inc
;---------------------------------------------------------------------
;
;
;
;
;
;*********************************************************************
;	labels
;*********************************************************************

ON_CHAR		equ	303eh+40h+obj_p5	; radar OBJ character
OFF_CHAR		equ	303fh+40h+obj_p5	;	//

DATAyjradarposH	equ	0c7h
DATAyjradarposV	equ	02fh


;*********************************************************************
;	blockmap radar 0page work memory
;*********************************************************************

radarcharROMaddr	equ	Xaddr

radarHV		equ	Xwork0
RAMradar_flag	equ	Xwork1
countV		equ	Xwork2
temp1		equ	Xwork3	; temp.work
blockmap_mask	equ	Xwork4
radar_X		equ	Xwork5
radar_Z		equ	Xwork6
blockmap_indexroot	equ	Xwork7
radar_scroll		equ	Xwork8

blockmap_index	equ	Xwork9
blockmap_maskroot	equ	Xwork10



;*********************************************************************
;	blockmap radar macros
;*********************************************************************

;--------------------------------------------------------------------
Mscale_mask	macro
	phx
	and	#0110b
	asl	a
	tax
	lda.l	XXbitmasks,x
	plx
	endm

;--------------------------------------------------------------------
Mblockmap_scale_x	macro
	xba
	lsr	a
	and	#7fh
	endm

;--------------------------------------------------------------------
Mblockmap_scale_z	macro
	;---------fedcba9876543210----
	and	#%1111110000000000
	xba
	asl	a
	asl	a
	asl	a
	endm

;--------------------------------------------------------------------
ldaxx	macro
	lda	\1
	sec
	sbc	#200h
	endm

;--------------------------------------------------------------------
XXbitmasks	dw	000000001b	;(0)
	dw	000000010b
	dw	000000100b	;(2)
	dw	000001000b
	dw	000010000b	;(4)
	dw	000100000b	
	dw	001000000b	;(6)
	dw	010000000b
;---------------------------------------------------------------------
Moamgame	macro
	dw	\1+40h
	endm

;--------------------------------------------------------------------

;*********************************************************************
;	yjradar main program
;*********************************************************************
;
; y = oam pointer
; program RAM move
;
;---------------------------------------------------------------------

yjradar_l
	Mbank7e
	php
	ai16


	jsr	yjradar_select		; planet/space select

	ldaxx	kpx			; player position X
	sta	radarplayer_x
	ldaxx	kpz			; player position Z
	sta	radarplayer_z
	lda	#DATAyjradarposH
	sta	yjradarposH		; radarOBJ posiiton (H)
	lda	#DATAyjradarposV*256
	sta	yjradarposV		; radarOBJ posiiton (V)

	jsr	yjradar_entry

	plp
	Mbankrtl

;*********************************************************************

yjradar_color


;;	dw	196ah,0cc5h,196ah,196ah
;;	dw	1986h,10e4h,10e4h,1986h
;;	dw	2505h,18a4h,18a4h,18a4h
;;	dw	196ah,0cc5h,196ah,196ah


	dw	3651h,1d49h,3651h,3651h
	dw	324ch,2168h,2168h,324ch
	dw	41ebh,2d49h,2d49h,2d49h
	dw	3651h,1d49h,3651h,3651h


	ifeq	1
	dw	2e2bh,2e2bh	; 0  arai	16 mode
	dw	25e9h,2e2bh	; 1		 8 mode
	dw	25e9h,25e9h	; 2  komakai     4 mode
	dw	2e2bh,2e2bh	; 0
	endc

;*********************************************************************
;	yjradar main program
;*********************************************************************
;;
;;	RAM radar_flag	-1   planet
;;			0    space  1
;;			1    space  2
;;			2    space  3
;;			3    space  4
;;
;---------------------------------------------------------------------
change_palet9 equ	1ach	; OBJ palet 5 color 6
change_palet0 equ	1aeh	; OBJ palet 5 color 7
change_palet1 equ	1b0h	; OBJ palet 5 color 8
change_palet2 equ	1b2h	; OBJ palet 5 color 9
;---------------------------------------------------------------------
yjradar_select
	phx
	phy
;---------------------------------------------
	lda	#-1
	sta	RAMradar_flag

	km_bitcheckmismapflag	autoradar
	beq	.skip


	ifeq	DBscale
	lda	kx_radarscale	; 0,1,2 
	and	#0011b
	tax
	elseif
;+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!
	ldx	#0
	lda	cont0
	and	#button_X
	beq	.sss
	inx
	lda	cont0
	and	#button_R
	beq	.sss
	inx
;+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!+!
	endc

.sss	txa
	sta	RAMradar_flag
	asl	a
	asl	a
	asl	a
	tax

	lda.l	yjradar_color+0,x
	sta	kx_palette+change_palet9	
	lda.l	yjradar_color+2,x
	sta	kx_palette+change_palet0
	lda.l	yjradar_color+4,x
	sta	kx_palette+change_palet1	
	lda.l	yjradar_color+6,x
	sta	kx_palette+change_palet2

.skip	

;---------------------------------------------
	ply
	plx

	rts


;*********************************************************************
;	yjradar_entry
;*********************************************************************

yjradar_entry

;---------------------------------------

	lda	radarplayer_x
	and	#0fc00h
	sec
	sbc	#0800h
	sta 	radar_X		; radar X position

	lda	radarplayer_z
	and	#0fc00h
	sec
	sbc	#0800h	
	sta 	radar_Z		; radar Z position

;---------------------------------------

	lda	radarplayer_x
	and	#0380h
	asl	a
	xba
	Mnegative
	clc
	adc	yjradarposH
	sta	temp1		; >> obj X offset

	lda	radarplayer_z
	and	#0380h
	asl	a
	clc
	adc	yjradarposV
	ora	temp1		; << obj X offset

				; A = sprite position
	tyx			; X = oam pointer
	jsr	setradar
	txy

	rts

;---------------------------------------------------------------------

;*********************************************************************
;	battle radar
;*********************************************************************

battle_radarpos	equ	Xwork0
battle_radarcenter	equ	Xwork1
battle_radarlimitX	equ	Xwork2
battle_radarlimitY	equ	Xwork3

battle_boxcount1	equ	Xwork4
battle_boxcount2	equ	Xwork5

;---------------------------------------------------------------------

yjbattle_radar

	rtl

;=====================================================================



		




;*********************************************************************
;	radar character datas
;*********************************************************************

yjradar_datas
;----------------------------------------------
	Moamgame 2a3fh		; 00 00
	Moamgame 2a1ch		; 00 01
	Moamgame 2a1dh		; 00 10
	Moamgame 2a2ah		; 00 11
;------------------------------------;---------
	Moamgame 2a0ch		; 01 00
	Moamgame 2a3bh		; 01 01
	Moamgame 0		; 01 10
	Moamgame 2a0bh		; 01 11
;------------------------------------;---------
	Moamgame 2a0dh		; 10 00
	Moamgame 0		; 10 01
	Moamgame 2a3ah		; 10 10
	Moamgame 2a0ah		; 10 11
;------------------------------------;---------
	Moamgame 2a2bh		; 11 00
	Moamgame 2a1bh		; 11 01
	Moamgame 2a1ah		; 11 10
	Moamgame 2a7fh		; 11 11	;7f <<< 3e :'95/3/2
;----------------------------------------------





;*********************************************************************
;	set blockmap radar obj
;*********************************************************************

;---------------------------------------------------------------------
McalcX	macro
	pha
	phx

	lda	radar_X
	Mblockmap_scale_x
	tax			; >>
	lsr	a		; bitmap pointer X
	lsr	a
	lsr	a
	sta	temp1		; = bitmap pointer X
	txa			; <<
	Mscale_mask
	sta	blockmap_maskroot	;; <---- initial mask
	sta	blockmap_mask

	lda	radar_Z		; position Z
	Mblockmap_scale_z
	clc
	adc	temp1
	sta	blockmap_indexroot	;; <----- initial index
	sta	blockmap_index

	plx
	pla
	endm

;---------------------------------------------------------------------
;;
;;
;;
;;
;;
;*********************************************************************
;	DRAW-RADAR
;*********************************************************************
;
; Areg ... start position
; Xreg ... oam pointer
;
;=====================================================================

setradar_loopH	equ	6
setradar_loopV	equ	6

;=====================================================================
;
;
;
;---------------------------------------------------------------------
setradar
;------------------------------------------
	ldy	#setradar_loopV
	sty	countV
;------------------------------------------
	McalcX				; << index & mask CALC >>
;------------------------------------------
.loop1	sta	radarHV
	ldy	#setradar_loopH		; 
;------------------------------------------
.loop2	sta.l	sprites+0,x
	clc
	adc	#0008h
	PHY			; counter
	PHA			; >> SPRITE POSITION
	PHX			; >> SPRITE INDEX

;-------------------------------------

	bit	RAMradar_flag	; MODE check !!!
	bpl	.space
	jsr	planet_calc
	bra	.oamset
.space	jsr	space_calc	; 0,1,2,3 space 
.oamset

;-------------------------------------
	PLX			; << SPRITE INDEX
	sta.l	sprites+2,x
;-------------------------------------
	lda	blockmap_mask	; maskdata++;
	asl	a
	sta	blockmap_mask
	bit	#0ff00h
	beq	.next
	xba
	sta	blockmap_mask
;-------------------------------------
	lda	blockmap_index  ; X indexdata ++
	inc	a
	eor	blockmap_index
	and	#0fh
	eor	blockmap_index
	sta	blockmap_index
;-------------------------------------

.next	

;------------------------------------------

	PLA		; << SPRITE POSITION >>
	PLY		; << counter
	inx 
	inx
	inx
	inx
	dey	
	bne	.loop2

;------------------------------------------
.exit1
	lda	blockmap_indexroot	; Y indexdaya ++
	clc
	adc	#20h
	and	#7ffh
	sta	blockmap_indexroot
	sta	blockmap_index		; <== copy index
	lda	blockmap_maskroot
	sta	blockmap_mask		; <== copy mask

	lda	radarHV			; position dec
	sec
	sbc	#0800h			; sub sprite position
	dec	countV
	beq	.end
	jmp	.loop1

;------------------------------------------
.end
	rts




;*********************************************************************
;	planet mode blockmap bit calc
;*********************************************************************
;;
;;
;; Y .... bitflag
;; X .... blockmap index
;;
;---------------------------------------------------------------------

Mset_char_index 	macro	[data]
	pha
	tya
	ora	#{data}
	tay
	pla
	endm
;---------------------------------------------------------------------

planet_calc
	ldy	#0	; bit ==== flag
	ldx	blockmap_index

	lda.l	solidblockmap,x	
	bit	blockmap_mask	
	beq	.s1
	Mset_char_index	000010b

.s1
	asl	blockmap_mask
	bit	blockmap_mask
	beq	.s2
	Mset_char_index	000100b

.s2	lsr	blockmap_mask
	lda.l	solidblockmap+10h,x	; Z pointer ++ 
	bit	blockmap_mask
	beq	.s3
	Mset_char_index	001000b
.s3
	asl	blockmap_mask
	bit	blockmap_mask
	beq	.s4
	Mset_char_index	010000b
.s4

	tyx
	lda.l	yjradar_datas,x
	rts


;*********************************************************************
;	space radar calclation		
;*********************************************************************
yjradar_datas_space

	Moamgame 2a7eh	; 0
	Moamgame 2a6eh	; 2
	Moamgame 2a7fh	; 4
	Moamgame 2a6fh	; 6 

	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh
	Moamgame 2a6eh


;--------------------------------------------------------------------

space_calc
	asl	blockmap_mask

	ldx	#0
	lda	blockmap_mask
	;;;	0076543210
	and	#011001100b	;;;; (X) check ...
	beq	.skip
	ldx	#4

.skip	lda	blockmap_index	;;;; (Y) check ...
	;	543210543210
	and	#00000100000b	;; 20h 
	beq	.skip2
	inx
	inx
.skip2
	lda.l	yjradar_datas_space,x

	rts



;====================================================================
;====================================================================
;END END END END END END END END END END END END END END END END END 
;====================================================================
;====================================================================

