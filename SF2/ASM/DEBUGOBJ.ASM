;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: debugobj.asm				*
;* 	Description	: debug number & alpha object		*
;*	Date		: 1994.10.23				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;;
;;
;;
;***********************************************************************
;	printd sprite set
;***********************************************************************
;
; Yregister	position
; Aregister  hex-data (0000-ffff)
;
;	OBJprint1	set 1 char
;	OBJprintB	set 2 char
;	OBJprint3	set 3 char
;	OBJprintW	set 4 char
;	OBJprintC	set Aregister char
;
;-----------------------------------------------------------------------
printattr	equ	3000h
printrom	
	db	20h,21h,22h,23h,24h,25h,26h,27h
	db	28h,29h,2ah,2bh,2ch,2dh,2eh,2fh

;-----------------------------------------------------------------------
	longa
	longi
;-----------------------------------------------------------------------
OBJprint3	pha
	xba
	jsr	OBJprint1
	pla
	bra	OBJprintB
OBJprintW	pha			;>>
	xba
	jsr	OBJprintB
	pla			;<
OBJprintB	pha			;>>
	lsr	A		;W
	lsr	A		;W
	lsr	A		;W
	lsr	A		;W
	jsr	OBJprint1
	pla			;<
OBJprint1	and	#000fh
	tax
	lda.l	printrom,x
	and	#00ffh	
	ora	#printattr
OBJprintC	ldx	sprite_register
	sta.l	sprites+2,x	;
	tya
	sta.l	sprites+0,x	;
	clc
	adc	#0008h
	inx
	inx
	inx
	inx
	stx	sprite_register	
	tay			;
	rts
;-----------------------------------------------------------------------










;***********************************************************************
;	debug number obj VRAM set
;***********************************************************************
SetNumberOBJ

	lda	#80h
	sta	Screen_step
	lda	#6200h
	sta	Screen_address

	ldy	#16
.loop0
	phy
	ldy	#8
.loop1	lda.l	moji_data,x
	and	#00ffh
	sta	Screen_write
	inx
	dey
	bne	.loop1

	ldy	#8
.loop2	stz	Screen_write
	dey
	bne	.loop2

	ply
	dey
	bne	.loop0

	rts

;=======================================================================

moji_data

	db	03CH,066H,066H,066H,066H,066H,03CH,000H	; (00) 0
	db	018H,038H,018H,018H,018H,018H,03CH,000H ; (01) 1
	db	03CH,066H,006H,01CH,038H,060H,07EH,000H	; (02) 2
	db	03CH,066H,006H,00CH,006H,066H,03CH,000H ; (03) 3
	db	00CH,01CH,03CH,06CH,06CH,07EH,00CH,000H	; (04) 4
	db	07EH,060H,07CH,066H,006H,066H,03CH,000H ; (05) 5
	db	03CH,066H,060H,07CH,066H,066H,03CH,000H ; (06) 6
	db	07EH,066H,00CH,00CH,018H,018H,018H,000H ; (07) 7
	db	03CH,066H,066H,03CH,066H,066H,03CH,000H ; (08) 8
	db	03CH,066H,066H,03EH,006H,066H,03CH,000H ; (09) 9
	db	038H,07CH,0C6H,0C6H,0FEH,0C6H,0C6H,000H	; (0A) A
	db	0FCH,0C6H,0C6H,0FCH,0C6H,0C6H,0FCH,000H	; (0B) B
	db	07CH,0C0H,0C0H,0C0H,0C0H,0C0H,07CH,000H ; (0C) C
	db	0FCH,0C6H,0C6H,0C6H,0C6H,0C6H,0FCH,000H ; (0D) D
	db	0FEH,0C0H,0C0H,0FCH,0C0H,0C0H,0FEH,000H ; (0E) E
	db	0FEH,0C0H,0C0H,0FCH,0C0H,0C0H,0C0H,000H ; (0F) F

;=======================================================================


