AF_namedispOFF = 0	; 1 ... plane name GA nagarete deru
		;       nowo yameru !!!
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: pselect2.asm				*
;* 	Description	: Battle player select			*
;*	Date		: 1994.11.11				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
	INCPUB  pselect
;---------------------------------------------------------------------

keytypeobjPOS	equ	2e70h-400h

;
;*******************************************************************
;	battle player select
;*******************************************************************

bpsel_p1		equ	gameobjstruct+0
bpsel_p2		equ	gameobjstruct+10

;---------------------------------------------------------------------

_bpselprocess	equ	0
_bpselcounter	equ	2
_bpselnumber		equ	4
_bpselplayerNo	equ	6
_bpselflag		equ	8
_bpsel_keyconfig	equ	9

config_keytype	equ	01h	; keytype flag
on_gogo		equ	02h	; gogo display
leftkey_exit		equ	04h
rightkey_exit	equ	08h
bpsel_cursorsound	equ	10h

;---------------------------------------------------------------------
p1_player		equ	bpsel_p1+_bpselplayerNo
p2_player		equ	bpsel_p2+_bpselplayerNo
;---------------------------------------------------------------------


;*******************************************************************
;	battle player select macro
;*******************************************************************
Mbpsel_gogo_set	macro
	lda	_bpselflag,x
	ora	#on_gogo
	sta	_bpselflag,x
	endm

;-------------------------------------------------------------------
Mbpsel_gogo_clear	macro
	lda	_bpselflag,x
	and	#on_gogo^0ffffh
	sta	_bpselflag,x
	endm

;-------------------------------------------------------------------
Mbpsel_leftkeyexit	macro
	lda	_bpselflag,x
	ora	#leftkey_exit
	sta	_bpselflag,x
	endm

;-------------------------------------------------------------------
Mbpsel_rightkeyexit	macro
	lda	_bpselflag,x
	ora	#rightkey_exit
	sta	_bpselflag,x
	endm

;-------------------------------------------------------------------
Mbpsel_keyclear	macro
	lda	_bpselflag,x
	and	#(leftkey_exit+rightkey_exit)^0ffffh
	sta	_bpselflag,x
	endm

;-------------------------------------------------------------------
Mbpsel_cursorsoundON	macro
	lda	_bpselflag,x
	ora	#bpsel_cursorsound
	sta	_bpselflag,x
	endm
;-------------------------------------------------------------------
Mbpsel_cursorsoundOFF macro
	ldx	register
	lda	_bpselflag,x
	bit	#bpsel_cursorsound
	beq	.s\@

	lda	_bpselplayerNo,x
	cmp	#6
	beq	.soundskip\@

	ksound	cursor

.soundskip\@
	lda	_bpselflag,x
	and	#bpsel_cursorsound^-1
	sta	_bpselflag,x
.s\@
	endm
;-------------------------------------------------------------------
;*******************************************************************
;	close demo
;*******************************************************************
pselect_close
	jsr	pselect_exitobj
	jsr	dc_program

	dwnext	bpselclose_0
	dwloop	50,bpselclose_startwait
	dwnext	bpselclose_1
	dwloop	tmpsel_okwait,bpselclose_2

	dwnext	bpselclose_3
	dwloop	16,bpselclose_4

	dwnext	bpselclose_5
	dwloop	30,bpselclose_6
	dwnext	bpselclose_7
	dwstop	bpselclose_8
	

;-------------------------------------------------------------------
bpselclose_0

bpselclose_startwait
bpselclose_2
	jsr	Disp_BATTLEkeytypeobj
bpselclose_4
	jsr	Main_OBJ
	rts
;-------------------------------------------------------------------
bpselclose_1
	jsr	Disp_BATTLEkeytypeobj

	Mobjchange 0,ys_foxOKpose,face_oamset_p1X
	Mobjchange 2,ys_foxOKpose,face_oamset_p2X
;-------------------------------------------
	Mobjindex	0		; player(1)
	ldy	player_owner
	lda	pseldataOK&xx,y
	and	#00ffh
	sta	_anime_trigger,x
;-------------------------------------------
	Mobjindex	2		; player(2)
	lda.l	player_friend
	tay
	lda	pseldataOK&xx,y
	and	#00ffh
	sta	_anime_trigger,x
;-------------------------------------------
	jsr	Main_OBJ
	rts
;-------------------------------------------------------------------

bpselclose_3
	ldy	#amiclear&xx	; ami P1 clear
	jsr	psel_bgdraw
	ldy	#amiclear&xx	; ami P2 clear
	jsr	psel_bgdrawP2
	ldy	#name_clear&xx	; name clear
	jsr	psel_bgdraw
	ldy	#name_clear&xx	; name clear
	jsr	psel_bgdrawP2

	jsr	Init_objlist
	Mobjinit 0,ys_faceclose,oamsetnew,30h,37h
	Mobjinit 1,ys_planeclose,oamsetnew,0c0h,planecloseYpos
	Mobjinit 2,ys_faceclose,oamsetnew,30h,37h+80h
	Mobjinit 3,ys_planeclose,oamsetnew,0c0h,planecloseYpos+80h

	jsr	Main_OBJ
	rts
;--------------------------------------------------------------------
bpselclose_5



	jsr	Init_objlist
	Mobjmoveinit 0,ys_planefire,movefire1,0100h+8*5,37h,p1_initspeed,0
	Mobjmoveinit 1,ys_foxplane,movefire1,0100h,37h,p1_initspeed,0


	Mobjindex	1	
	ldy	player_owner
	lda	pseldata2&xx,y
	and	#00ffh
	sta	_anime_trigger,x

	Mobjindex	0
 	ldy	player_owner
	lda	pfoffset&xx,y
	and	#00ffh
	clc
	adc	_axisX,x
	sta	_axisX,x
	lda	#0000h		; plane fire
	sta	_charadd,x

;--------------------------------------------------------------------
bpselclose_8
bpselclose_6
	jsr	psel_scrollset
	jsr	Main_OBJ
	rts

;-------------------------------------------------------------------
bpselclose_7
	Mobjmoveinit 2,ys_planefire,movefire2,0100h+8*5,37h+80h,p2_initspeed,0
	Mobjmoveinit 3,ys_foxplane,movefire2,0100h,37h+80h,p2_initspeed,0

	Mobjindex	3	
	lda.l	player_friend
	tay
	lda	pseldata2&xx,y
	and	#00ffh
	sta	_anime_trigger,x

	Mobjindex	2
	lda.l	player_friend
	tay
	lda	pfoffset&xx,y
	and	#00ffh
	clc
	adc	_axisX,x
	sta	_axisX,x
	stz	_charadd,x
	
	bra	bpselclose_6

;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
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
;*******************************************************************
;	----------------------
;	 2Pmode player select
;	----------------------
;*******************************************************************
Mbpsel_setnumberY	macro
	ldx	register
	ldy	_bpselnumber,x
	endm

;--------------------------------------------------------------------
Mbpsel_setprocess	macro	[process]
	lda	#idx_{process}
	sta	_bpselprocess,x
	endm

;--------------------------------------------------------------------
Mbpsel_keycheck	macro	[key]
	lda.w	trig0,y
	and	#button_{key}
	endm

;--------------------------------------------------------------------
Mbpsel_keycheck2	macro	[key,key2]
	lda.w	trig0,y
	and	#button_{key}+button_{key2}
	endm

;--------------------------------------------------------------------

;*******************************************************************
; 	---------------------------
;  	 player select conflg mode
; 	---------------------------
;*******************************************************************
pselbatt_select

	sty	bpsel_index		; DataJUMP pointer
	stx	register		; WorkRAM pointer
	lda	_bpselprocess,x
	asl	a
	txy
	tax
	jmp	(.process,x)
;-------------------------------------------------------------------
.process
	Mindexliststart
	Mindexlist	bpsel_select
	Mindexlist	bpsel_configentry
	Mindexlist	bpsel_configopen
	Mindexlist	bpsel_configselect
	Mindexlist	bpsel_configclose
	Mindexlist	bpsel_okwait
	Mindexlist	bpsel_okend

;--------------------------------------------------------------------
;	config open demo entry
;--------------------------------------------------------------------
bpsel_configentry
	ldx	register
	stz	_bpselcounter,x
	Mbpsel_setprocess	bpsel_configopen

	rts
	
;--------------------------------------------------------------------
;	config open demo
;--------------------------------------------------------------------
bpsel_configopen

	tyx
	lda	_bpselcounter,x
	beq	.entry
	inc	_bpselcounter,x
	cmp	#30
	bcc	.exit

	Mbpsel_setprocess	bpsel_configselect

.exit	
	jsr	disp_playerkeytype

	rts

;----------------------------------------------------
.entry
	MsetBL	kw_tm,17h

	inc	_bpselcounter,x
	jsr	clear_name_gogo

	ksound	openwindow

	rts

;====================================================


;--------------------------------------------------------------------
;	config select
;--------------------------------------------------------------------
bpsel_configselect

	jsr	select_playerkeytype
	jsr	disp_playerkeytype


	Mbpsel_setnumberY

	lda.w	trig0,y
	and	#button_left+button_right
	beq	.exit

	ldx	register		; WorkRAM pointer
	and	#button_left
	beq	.skip1
	lda	#5
	sta	_bpselplayerNo,x
	bra	.skip2
.skip1
	lda	#0
	sta	_bpselplayerNo,x
.skip2

	Mbpsel_setprocess	bpsel_configclose
	ksound	closewindow

.exit	rts

;--------------------------------------------------------------------
;	config closedemo
;--------------------------------------------------------------------
bpsel_configclose
	tyx
	dec	_bpselcounter,x
	bne	.exit

;--------------------------------------------
; endof onfig close
;--------------------------------------------

	ifeq	1

	ldy	#0
 	lda	_bpselflag,x
	and	#leftkey_exit
	beq	.entry
	ldy	#5
.entry	tya
	sta	_bpselplayerNo,x
	Mbpsel_keyclear

	endc

;--------------------------------------------
	Mbpsel_setprocess	bpsel_select
	stz	_bpselcounter,x

.exit	
	jsr	disp_playerkeytype
	rts

;--------------------------------------------------------------------
;	battle mode select & ok
;--------------------------------------------------------------------
bpsel_select
bpsel_okwait
bpsel_okend
	rts
	rts
	
;*********************************************************************
;	config playerkeytype select(UP/DOWN)
;*********************************************************************

select_playerkeytype
	ldx	register
	ldy	bpsel_index
	lda.w	trig0,y
	and	#button_up+button_down+button_select
	beq	.exit
	and	#button_down+button_select
	beq	.up

;------------------------------------------------------
.down	a8
	lda	_bpsel_keyconfig,x
	inc	a
	and	#03h
	sta	_bpsel_keyconfig,x
	bra	.sound
;------------------------------------------------------
.up	a8
	lda	_bpsel_keyconfig,x
	dec	a
	and	#03h
	sta	_bpsel_keyconfig,x
	bra	.sound

;------------------------------------------------------
.sound	a16
	ksound	cursor		; set sound
;------------------------------------------------------
.exit	a16
	rts


;--------------------------------------------------------------------
;	disp player keytype
;--------------------------------------------------------------------
disp_playerkeytype
	ldx	register
	lda	_bpsel_keyconfig,x
	and	#03h
	asl	a
	tax
	lda.l	.data,x
	tay
	jmp	call_bgdraw

.data	
	dw	config_A&xx
	dw	config_B&xx
	dw	config_C&xx
	dw	config_D&xx

;--------------------------------------------------------------------
;
;
;
;
;
;
;
;--------------------------------------------------------------------
;	
;
;
;*******************************************************************
;	draw player name
;*******************************************************************
draw_playername

	ldx	register
	lda	_bpselcounter,x

	ifne	AF_namedispOFF
	clc
	adc	#39
	endc

	cmp	#40
	bcs	.gogo
	inc	_bpselcounter,x
	sec
	sbc	#20
	bmi	.exit
	lsr	a
	pha
	lda	_bpselplayerNo,x
	asl	a
	tax
	ldy	name_select&WM,x
	pla
	jsr	call_bgdrawN
.skip
	rts

.exit	jmp	clear_name_gogo

.gogo	Mbpsel_gogo_set
	rts

;-------------------------------------------------------------------
call_bgdraw	
	ldx	bpsel_index
	jmp	(.process,x)
.process	dwcode	.1
	dwcode	.2
;-------------------------------------------------------------------
.1	lda	objdraw
	and	#03h
	cmp	#idx_drawBGscreen1
	bne	.skip1
	jsr	psel_bgdraw
.skip1	rts
;-------------------------------------------------------------------
.2	lda	objdraw
	and	#03h
	cmp	#idx_drawBGscreen2
	bne	.skip2
	jsr	psel_bgdrawP2
.skip2	rts
;-------------------------------------------------------------------
call_bgdrawN	
	ldx	bpsel_index
	jmp	(.process,x)
.process	dwcode	psel_bgdrawN
	dwcode	psel_bgdrawN2
;-------------------------------------------------------------------
	ifeq	1
.1	pha
	lda	objdraw
	and	#03h
	tax
	pla
	cpx	#idx_drawBGscreen1
	bne	.skip1
	jsr	psel_bgdrawN
.skip1	rts
;-------------------------------------------------------------------
.2	pha
	lda	objdraw
	and	#03h
	tax
	pla
	cpx	#idx_drawBGscreen2
	bne	.skip2
	jsr	psel_bgdrawN2
.skip2	rts
	endc
;-------------------------------------------------------------------



;-------------------------------------------------------------------
;	name clear & gogo clear
;-------------------------------------------------------------------
clear_name_gogo
	Mbpsel_gogo_clear
	ldy	#name_clear&WM
	lda	#10
	jmp	call_bgdrawN
;-------------------------------------------------------------------
;	set name   & gogo set
;-------------------------------------------------------------------
set_name_gogo
	Mbpsel_gogo_set
	lda	_bpselplayerNo,x
	asl	a
	tax
	ldy	name_select&WM,x
	lda	#10
	jmp	call_bgdrawN
;-------------------------------------------------------------------


;*******************************************************************
;	player okcursor
;*******************************************************************
cursor_okset

	Mbpsel_setnumberY

	lda	#00b8h			; position

set_pselfrashcursor
	ora	bpsel_cursorV&WM,y	; position
	pha
	lda.l	attrcount		; attribute
	and	#0110b
	xba
	tax
	ldy	#ok_data&xx
	pla
	jmp	yj_setsprite


;*******************************************************************
;	player select cursor move
;*******************************************************************
;
;	move cursor
;
;-------------------------------------------------------------------

Xcursor_move

	Mbpsel_setnumberY
	
	lda.w	trig0+1,y
	ldy	_bpselplayerNo,x
	phx				; >>

	jsr	keymove
					; Carry = sound flag
	plx				; <<
	sty	_bpselplayerNo,x

	bcc	.exit

	Mbpsel_cursorsoundON

	cpy	#6
	bne	.skip

	Mbpsel_setprocess	bpsel_configentry
.skip

.exit	rts

;-------------------------------------------------------------------
;
; A = Vposition
; Y = 0,1,2,3,4,5,6	player offset
;
;-------------------------------------------------------------------
Xcursor_set
	ldx	register
	ldy	_bpselplayerNo,x

	lda	_bpselnumber,x
	tax

set_1pnormalcursor
	lda.l	bpsel_cursorV,x
	sta	Xwork0			; V-position
	lda	bpsel_cursorchar&WM,x
	tax
	lda	p_pos&xx,y
	and	#00ffh
	ora	Xwork0
	txy
	ldx	#0
	jmp	yj_setsprite

;-------------------------------------------------------------------
bpsel_indexdata
	dw	bpsel_p2,bpsel_p1
bpsel_cursorV
	dw	6400h,8200h
;-------------------------------------------------------------------
bpsel_cursorchar
	dwcode	p1_data
	dwcode	p2_data
;-------------------------------------------------------------------
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
;*******************************************************************
;	bpsel 
;*******************************************************************
bpsel_exitsave
	a8
;--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*

	lda	#1
	trb	player_controltypeABXY
	lda	_bpsel_keyconfig+bpsel_p1
	and	#02h
	beq	.skip1	
	lda	#1
	tsb	player_controltypeABXY
.skip1
	lda	#player_controltype_1B
	trb	player_controltype
	lda	_bpsel_keyconfig+bpsel_p1
	and	#01h
	beq	.skip2
	lda	#player_controltype_1B
	tsb	player_controltype
.skip2

;--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*

	a16

	jsl	Write_backupRAM_playerconfig_l	; #### BACKUP RAM WRITE ####

	rts
;===================================================================


bpsel_initial
	ldx	#bpsel_p1
	stz	_bpselprocess,x
	stz	_bpselcounter,x
	stz	_bpselnumber,x
	stz	_bpselplayerNo,x

;--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
	ldy	#0
	lda	player_controltypeABXY
	and	#01
	beq	.skip1
	iny
	iny
.skip1
	lda	#player_controltype_1B
	bit	player_controltype
	beq	.skip2
	iny
.skip2
;--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*

	tya
	xba
	sta	_bpselflag,x

	ldx	#bpsel_p2
	stz	_bpselprocess,x
	stz	_bpselcounter,x
	stz	_bpselflag,x
	lda	#1			; Set falco
	sta	_bpselplayerNo,x
	lda	#2			; *2
	sta	_bpselnumber,x


	rts

;*******************************************************************
;	cursor set program
;*******************************************************************

;*******************************************************************
;	cursor move program
;*******************************************************************
; 
; < input >	Y = parameter address 
;	A = key data (8bit)
;
;	max min 
;
; < output > C = sec ... keymove
;	    clc	... keywait
;
;-------------------------------------------------------------------
psel_kmax	equ	7
psel_kmin	equ	0
;-------------------------------------------------------------------
keymove
	ai8
	and	#(button_left/256)+(button_right/256)+(button_select/256)
	beq	.exit
	and	#(button_right/256)+(button_select/256)
	beq	.left
	iny
	cpy	#psel_kmax
	bcc	.set
	ldy	#psel_kmin
	bra	.set

.left	dey
	bpl	.set
	ldy	#psel_kmax-1

.set	ai16
	phy			; >>
	ldx	register
	stz	_bpselcounter,x	; counter reset !!
	ply			; <<
	sec
	rts



.exit	ai16cC
	rts

;*******************************************************************
;	common programs
;*******************************************************************
;-------------------------------------------------------------------
;	oamset
;-------------------------------------------------------------------
pselsetobj
	jsr	Main_OBJ
	rts

;-------------------------------------------------------------------
;
;-------------------------------------------------------------------
;;
;;
;;
;;
;;
;;
;;
;*******************************************************************
;	SPRITE PROGRAM
;*******************************************************************


wk_pilotNo		equ	Xwork0
wk_oamadd		equ	Xwork1
wk_dmatimming	equ	Xwork2


;====================================================================

plane_oamset_p2
	ldy	bpsel_p2+_bpselplayerNo
	bra	plane_oamset_common
plane_oamset_p1
	ldy	bpsel_p1+_bpselplayerNo
plane_oamset_common
	cpy	#6
	bcs	.exit
;-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-(6/23)-x-x-x-x-x-x-
;-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-(6/23)-x-x-x-x-x-x-
	phy			; >>
	lda	cv_index2bit&WM,y
	and	#0ffh
	and.l	initial_twin_player
	beq	.skip1
	tya
	asl	a
	tay
	lda	oam_planemeter_select_twin&WM,y	; (( ROM address  ))
	bra	.skip2

.skip1	tya
	asl	a
	tay
	lda	oam_planemeter_select&WM,y	; (( ROM address  ))

.skip2	tay
	ldx	register
	lda	_axisY,x
	clc
	adc	#23h
	xba
	ora	_axisX,x		; (( position(Y/X) ))
	sec	
	sbc	#18h
	jsr	common_oamset
	ply			; <<
;-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-
;-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-

	ldx	register
	lda	pseldata2&xx,y
	and	#00ffh
	sta	_anime_trigger,x
.exit	jmp	Newoamset

;====================================================================

oam_planemeter_select
	dwcode	oam_foxmeter
	dwcode	oam_foxmeter
	dwcode	oam_peppymeter
	dwcode	oam_peppymeter
	dwcode	oam_galmeter
	dwcode	oam_galmeter

oam_planemeter_select_twin
	dwcode	oam_foxmeter_twin
	dwcode	oam_foxmeter_twin
	dwcode	oam_peppymeter_twin
	dwcode	oam_peppymeter_twin
	dwcode	oam_galmeter_twin
	dwcode	oam_galmeter_twin

oam_p1face_data	equ	140h+0e00h
oam_p2face_data	equ	180h+0a00h

;====================================================================
face_oamset_p1X
	ldx	register
	lda	#oam_p1face_data
	sta	_charadd,x	
	jmp	Newoamset

;--------------------------------------------------------------------
face_oamset_p2X
	ldx	register
	lda	#oam_p2face_data
	sta	_charadd,x
	jmp	Newoamset

;====================================================================
face_oamset_p2
	lda	p2_player
	ldx	#oam_p2face_data
	ldy	#idx_drawP2face
	bra	face_oamset_common
;-----------------------------------------------------------
face_oamset_p1
	lda	p1_player
	ldx	#oam_p1face_data
	ldy	#idx_drawP1face
;-----------------------------------------------------------
face_oamset_common
	sta	wk_pilotNo
	stx	wk_oamadd
	sty	wk_dmatimming

	ldx	register
	ldy	wk_pilotNo
	cpy	#6			; <= config mode select
	bcc	.entry
;-----------------------------------------------------------
		
	lda	#ys_keyconfig
	sta	_anime_trigger,x
	bra	.oamset 
;-----------------------------------------------------------
.entry	
.skip2	lda	objdraw			; ( DRAW timming ?)
	and	#03h
	cmp	wk_dmatimming
	bne	.faceset		; ( NO! => skip )

	jsr	set_pselfacecolor

	lda	facenomalpose_select&xx,y
	and	#00ffh
	ora	#8000h
	cmp	_anime_trigger,x
	beq	.faceset
	and	#7fffh
	sta	_anime_trigger,x

;-----------------------------------------------------------
.faceset	lda	wk_oamadd		; face player(1)
	sta	_charadd,x		; character addition
	jmp	Newoamset
;-----------------------------------------------------------
.oamset	stz	_charadd,x
.oamset2	jmp	Newoamset
;-----------------------------------------------------------


;********************************************************************
;	face color
;********************************************************************
;
; <<< input >>>
;;
;;	Y register = player number	0,1,2,3,4,5,6
;;	X register = object register
;;
;;	Xwork9 ... color counter
;;
;--------------------------------------------------------------------
init_pselfacecolor
	ldy	#0		; (1P) initialize FOX
	sty	wk_dmatimming
	jsr	set_pselfacecolor
	ldy	#1		; (2P) initialize FALCO
	sty	wk_dmatimming

set_pselfacecolor

	Mbank7e

	phy			;>>
	phx			;  >>

;------------------------------------------
	tya			; Y= player No
	asl	a		; * 20h
	asl	a
	asl	a
	asl	a
	asl	a
	tax			; ROM address pointer

	ldy	#1a0h		; (p5)
	lda	wk_dmatimming
	cmp	#idx_drawP1face
	beq	.entry
	ldy	#1e0h		; (p7)
.entry
;------------------------------------------
	lda	#10h
	sta	Xwork9
;------------------------------------------
.loop	lda	kx_palette2,x	; palette (2)
	sta	kx_palette,y	; palette (1)
	inx
	inx
	iny
	iny
	dec	Xwork9
	bne	.loop
;------------------------------------------

	plx			;  <<
	ply			;<<

	Mbankrts



;********************************************************************
;	control typeselect library
;********************************************************************

;-----------------------------------------------------------

Disp_BATTLEkeytypeobj
	km_bitchecktotalflag	battle
	beq	Disp_MISSIONkeytypeobj
	ldy	#keytypeobjPOS+8000h		; position
	ldx	#bpsel_p2
	jsr	Disp_keytypeobj
Disp_MISSIONkeytypeobj
	ldy	#keytypeobjPOS			; position
	ldx	#bpsel_p1
Disp_keytypeobj
	lda	_bpsel_keyconfig,x	; config type A/B/C/D
	and	#03h
	asl	a
	tax
	lda.l	typeobj_select,x
	tax				; Y = object address
	tya				; A = object position
	txy
	jmp	common_oamset

;-------------------------------------------------------------------
typeobj_select
	dw	obj_typeA&WM
	dw	obj_typeB&WM
	dw	obj_typeC&WM
	dw	obj_typeD&WM


;===================================================================
;===================================================================
; END END END END END END END END END END END END END END END END 
;===================================================================
;===================================================================

