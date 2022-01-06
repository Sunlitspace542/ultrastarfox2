;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: pausemap.asm				*
;* 	Description	: game pause process			*
;*	Date		: 1994.10.1				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;---------------------------------------------------------------------
	INCPUB  pausemap
;---------------------------------------------------------------------
;#-!!!-###############################################################
;
; << README >>	pause position wo kaeru tokiha 
;		wipepause.asm 
;		wo miru koto !!
;
;#-!!!-###############################################################
;
;
;
;
;
;*********************************************************************
;	<< README >>
;*********************************************************************
;
; gamepause map display
;
; init_pausemap_l
; main_pausemap_l
;
;*********************************************************************
;	pause obj display labels
;*********************************************************************

XXoffset		equ	-1	; pausemap offset Y
pauseobj_cX		equ	40h
pauseobj_cY		equ	28h	; 28 
pauseobj_cYX		equ	pauseobj_cX+pauseobj_cY*256

;*********************************************************************
;	pause obj ZeroPage Memory
;*********************************************************************

pauseobj_pos		equ	Xwork0
Xposwork		equ	Xwork0+0
Yposwork		equ	Xwork0+1

pauseobj_attr	equ	Xwork1
pauseobj_char	equ	Xwork2
pauseobj_counter	equ	Xwork3
pauseobj_add		equ	Xwork4
pauseobj_temp	equ	Xwork5
pause_objpointer	equ	Xwork6
pauseobj_size	equ	Xwork7
pauseobj_flip	equ	Xwork8

pauseobj_work	equ	Xwork9
		
;====================================================================
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
;	-----------------------	
;	 pauseobj local macros
;	-----------------------	
;*********************************************************************

;---------------------------------------------------------------------
Mpd	macro	[x,y,c,a]
	db	{x}
	db	{y}
	db	{c}+40h
	db	{a}
	endm

;---------------------------------------------------------------------
poam	macro
	dw	\1+40h
	endm

;--------------------------------------------------------------------
poamV	macro
	dw	\1+40h+8000h
	endm

;--------------------------------------------------------------------
poamH	macro
	dw	\1+40h+4000h
	endm

;--------------------------------------------------------------------
poamHV	macro
	dw	\1+40h+0c000h
	endm

;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
Mpauseobj_exit	macro
	db	idx_pauseobj_exit
	endm

;--------------------------------------------------------------------

Mpauseobj_pos	macro	[posH,posV]
	db	idx_pauseobj_posset
	db	{posH},{posV}
	endm

;--------------------------------------------------------------------
Mpauseobj_posadd	macro	[posH,posV]
	db	idx_pauseobj_posadd
	db	{posH},{posV}
	endm

;--------------------------------------------------------------------

Mpauseobj_programjmp	macro	[prog]
	db	idx_pauseobj_programjmp
	dw	{prog}&WM
	endm

;--------------------------------------------------------------------

Mpauseobj_attr	macro	[hv,pri,attr]
	db	idx_pauseobj_attrset
	db	oamdata_{pri}+oamdata_{attr}+oamdata_{hv}flip
	endm

;--------------------------------------------------------------------

Mpauseobj_Hsameloop	macro	[count,char]
	db	idx_pauseobj_Hsameloop
	db	{count}
	db	{char}
	endm

;--------------------------------------------------------------------

Mpauseobj_Vsameloop	macro	[count,char]
	db	idx_pauseobj_Vsameloop
	db	{count}
	db	{char}
	endm

;--------------------------------------------------------------------

Mpauseobj_nomalset	macro	[count]
	db	idx_pauseobj_nomalset
	db	{count}
	endm

;--------------------------------------------------------------------

Mpauseobj_Hdiffloop	macro	[count]
	db	idx_pauseobj_Hdiffloop
	db	{count}
	endm

;--------------------------------------------------------------------

Mpauseobj_Vdiffloop	macro	[count]
	db	idx_pauseobj_Vdiffloop
	db	{count}
	endm

;--------------------------------------------------------------------

Mpauseobj_sizebig	macro
	db	idx_pauseobj_sizebig
	endm

;--------------------------------------------------------------------

Mpauseobj_sizesmall	macro
	db	idx_pauseobj_sizesmall
	endm

;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------






;=====================================================================
;=====================================================================
;=========== DATAS ===================================================
;=========== DATAS ===================================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	----------------	
;	 pauseobj datas
;	----------------	
;*********************************************************************


;*********************************************************************
;	satellite animation
;*********************************************************************
pause_satellite
	Mpd	0,-4,29h,30h		;(0)
	Mpd	-4,-4,8ah,30h+040h	;(1)
	Mpd	-4,0,9ah,30h+040h	;(2)
	Mpd	-4,4,8ah,30h+0c0h	;(3)
	Mpd	0,4,29h,30h+080h	;(4)
	Mpd	4,4,8ah,30h+080h	;(5)
	Mpd	4,0,9ah,30h		;(6)
	Mpd	4,-4,8ah,30h		;(7)

;*********************************************************************
;	stop pause object
;*********************************************************************

;--------------------------------------------------------------------
pauseobj_process
	Mindexliststart
	Mindexlist	pauseobj_exit		; (0)
	Mindexlist	pauseobj_posset		; (1)
	Mindexlist	pauseobj_attrset	; (2)
	Mindexlist	pauseobj_Hsameloop	; (3)
	Mindexlist	pauseobj_Vsameloop	; (4)
	Mindexlist	pauseobj_nomalset	; (5)
	Mindexlist	pauseobj_Hdiffloop	; (6)
	Mindexlist	pauseobj_Vdiffloop	; (7)
	Mindexlist	pauseobj_sizebig	; (8)
	Mindexlist	pauseobj_sizesmall	; (9)
	Mindexlist	pauseobj_programjmp	; (10)
	Mindexlist	pauseobj_posadd		; (11)

;*********************************************************************
;	pause obj enemy character
;*********************************************************************
;;
;;pause_enemydata
;;
;;	kawaguchi's program
;;
;;--------------------------------------------------------------------

;*********************************************************************
;	pause obj planet character number
;*********************************************************************

yarare
	MoamCA	n,pri3,attr0,0e4h ; (p0)
	MoamCA	n,pri3,attr3,0e4h ; (p1)
	dw	0		  ; (p2)

;*********************************************************************
;	pause obj planet burn data
;*********************************************************************

pause_burndata
	dw	30e0h
	dw	30f0h
	dw	30f1h
	dw	0
	dw	30e0h
	dw	30f0h
	dw	30f1h
	dw	0

;*********************************************************************
;	pause obj planet burn data
;*********************************************************************

yarare_data
	Mpauseobj_sizesmall
	Mpauseobj_programjmp	yarare_select
	dw	yarare_1&WM,yarare_2&WM,yarare_3&WM,yarare_4&WM

yarare_1	Mpauseobj_Hdiffloop	2
	poam	30a4h	;(0)
	poam	30a5h	;(1)
	Mpauseobj_exit


yarare_2	Mpauseobj_posadd	00h,08h
	Mpauseobj_Hdiffloop	2
	poam	30a5h+0c000h
	poam	30a4h+0c000h
	Mpauseobj_exit


yarare_3	Mpauseobj_posadd	08h,00h
	Mpauseobj_Vdiffloop	2
	poam	30a4h+4000h
	poam	30a5h+8000h
	Mpauseobj_exit


yarare_4	Mpauseobj_Vdiffloop	2
	poam	30a5h+4000h
	poam	30a4h+8000h
	Mpauseobj_exit


;*********************************************************************
;	pause obj main daata
;*********************************************************************

pox 	equ 0
poy 	equ 0
poymove	equ 4	; map-obj move offset

waku_data1
waku_data2
	Mpauseobj_sizesmall
	Mpauseobj_nomalset	7

;--------------------------------------------------
	dw	3c00h+pauseobj_cYX,30e8h
	dw	3c08h+pauseobj_cYX,30e9h
	dw	3c10h+pauseobj_cYX,30eah
	dw	4410h+pauseobj_cYX,30f7h
	dw	4418h+pauseobj_cYX,30f8h
	dw	4c18h+pauseobj_cYX,30f9h
	dw	5418h+pauseobj_cYX,30fah
;--------------------------------------------------


	Mpauseobj_sizebig
	Mpauseobj_nomalset	2
	db	pox+(taitaniaCX/2)+pauseobj_cX-8,poy+(taitaniaCY/2)+pauseobj_cY-8,0e2h,034h 	;taitania
	db	pox+(fortunaCX/2)+pauseobj_cX-8,poy+(fortunaCY/2)+pauseobj_cY-8,0e2h,032h 	;fortuna
	Mpauseobj_sizesmall
	Mpauseobj_nomalset	4
	db	pox+(meteorCX/2)+pauseobj_cX-4,poy+(meteorCY/2)+pauseobj_cY-4,0f4h,032h 	;meteor
	db	pox+(venomCX/2)+pauseobj_cX-4,poy+(venomCY/2)+pauseobj_cY-4,0e1h,032h 		;venom
	db	pox+(macbethCX/2)+pauseobj_cX-4,poy+(macbethCY/2)+pauseobj_cY-4,0e1h,030h 	;macbeth
	db	pox+(eladardCX/2)+pauseobj_cX-4,poy+(eladardCY/2)+pauseobj_cY-4,0e1h,034h 	;eladard

	Mpauseobj_exit


;=====================================================================
view_data1
	Mpauseobj_sizesmall
	Mpauseobj_pos		80h,0b3h
	Mpauseobj_Hdiffloop	1
	poam	3231h
	Mpauseobj_exit

;=====================================================================
view_data2
	Mpauseobj_sizesmall
	Mpauseobj_pos		80h,0b3h
	Mpauseobj_Hdiffloop	1
	poam	3232h
	Mpauseobj_exit

;=====================================================================
waku_data
	Mpauseobj_sizesmall

;; waku X1 -----------------------------------------------------------
	Mpauseobj_sizebig
	Mpauseobj_pos		pauseobj_cX,pauseobj_cY
	Mpauseobj_attr		h,pri3,attr0
	Mpauseobj_Hsameloop	1,0deh
	Mpauseobj_attr		n,pri3,attr0
	Mpauseobj_Hsameloop	6,0ddh
	Mpauseobj_Hsameloop	1,0deh

;; waku X2 -----------------------------------------------------------
	Mpauseobj_pos		pauseobj_cX,pauseobj_cY+50h
	Mpauseobj_attr		hv,pri3,attr0
	Mpauseobj_Hsameloop	1,0deh
	Mpauseobj_attr		v,pri3,attr0
	Mpauseobj_Hsameloop	6,0ddh
	Mpauseobj_Hsameloop	1,0deh

;; waku Y1,Y2 -----------------------------------------------------------

	Mpauseobj_pos		pauseobj_cX,pauseobj_cY+10h
	Mpauseobj_attr		h,pri3,attr0
	Mpauseobj_Vsameloop	4,0eeh
	Mpauseobj_pos		pauseobj_cX+70h,pauseobj_cY+10h
	Mpauseobj_attr		n,pri3,attr0
	Mpauseobj_Vsameloop	4,0eeh

;------------------------------------------------------
; pause off
;------------------------------------------------------

	Mpauseobj_pos		60h,9bh
	Mpauseobj_Hdiffloop	10
	poam	3080h
	poam	3081h
	poam	3082h
	poam	3083h
	poam	3084h
	poam	3085h
	poam	3086h
	poam	3087h
	poam	3088h
	poam	3089h

;------------------------------------------------------
; return to map
;------------------------------------------------------
	Mpauseobj_pos		60h,0a7h
	Mpauseobj_Hdiffloop	10
	poam	3090h
	poam	3091h
	poam	3092h
	poam	3093h
	poam	3094h
	poam	3095h
	poam	3096h
	poam	3097h
	poam	3098h
	poam	3099h

	Mpauseobj_exit

;------------------------------------------------------
; VIEW
;------------------------------------------------------
viewmessage_data
	Mpauseobj_sizesmall
	Mpauseobj_pos		60h,0b3h
	Mpauseobj_Hdiffloop	3
	poam	328dh	;(0)
	poam	328eh	;(1)
	poam	328fh	;(2)


	Mpauseobj_exit


;=====================================================================
;=====================================================================
;=====================================================================
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
;	---------------------
;	 pausemap initialize
;	---------------------
;*********************************************************************

init_pausemap_l
	rtl

;*********************************************************************
;	---------------------
;	 pausemap main
;	---------------------
;*********************************************************************

main_pausemap_l
	Mbank7e
	php
	sty	pause_objpointer 
	ai16

	inc	yj_framecounter

;-------------------------------------------
.modeswitch_case

	ifne	AFpauselook
	Mkeycheck	cont0,button_X	
	bne	.exit
	endc

	km_bitcheckmistotalflag finalbossbattle
 	Mbnejsr	pause_finalboss,.exit
	km_bitcheckmissionflag wolfboss
	Mbnejsr	pause_finalboss,.exit

;-------------------------------------------
.default
	jsr	pause_normal

;-------------------------------------------

.exit	ldy	pause_objpointer 
	plp
	Mbankrtl

;====================================================================

;*********************************************************************
;	pausemap mode ( normal pause )
;*********************************************************************

pause_normal
	jsr	disp_waku	; WAKU OBJECT
	jsr	disp_player	; player ARWING
	jsr	disp_burn	; planet burn animation
	jsr	disp_enemy	; SOS enemy
	jsr	disp_waku2	; WAKU OBJECT
	jsr	disp_viewobj	;

	rts

;*********************************************************************
;	pausemap mode
;*********************************************************************

pause_finalboss

	a8
	sp_ifviewchangeOFF .exit
	a16

	ldx	#viewmessage_data&xx
	jsr	pauseobj_entry
	jsr	disp_viewobj	;

.exit	rts




;====================================================================
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
;	waku obj data common
;*********************************************************************
;*********************************************************************
;	waku obj data common
;*********************************************************************

yarare_select
	lda	yj_framecounter
	and	#00110b
	sta	pauseobj_temp
	txa
	clc
	adc	pauseobj_temp
	tax
				; X = ROM index
	lda.l	this_bank+2,x	; index select
	tay			; y = nextpointer
	rts

;=====================================================================	
	
;=====================================================================
;=====================================================================
;=========== PROGRAMS ================================================
;=========== PROGRAMS ================================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	program macros
;*********************************************************************

Mpmap_getpos	macro	[Xaddr,Xoffset,Yaddr,Yoffset]
	a8
	lda.w	{Yaddr},x
	lsr	a
	clc
	adc	#pauseobj_cY+poymove-({Yoffset})
	xba
	lda.w	{Xaddr},x
	lsr	a
	clc
	adc	#pauseobj_cX-({Xoffset})
	a16
	endm

;---------------------------------------------------------------------






;*********************************************************************
;	waku set (1)
;*********************************************************************
disp_waku

	ldx	#waku_data&xx
	jmp	pauseobj_entry

;*********************************************************************
;	waku set (2)
;*********************************************************************
disp_waku2

	ldx	#waku_data2&xx	;; mode only
	jsr	pauseobj_entry

	a8
	sp_ifviewchangeOFF .end
	a16

	ldx	#viewmessage_data&xx
	jsr	pauseobj_entry

.end	a16
	rts


;*********************************************************************
;	Set View object
;*********************************************************************
disp_viewobj

	a8
	sp_ifviewchangeOFF .end
	a16

	ldx	#view_data1&xx	; camera(1) ... cockpit mode 

	lda	playerimportflag
	and	#pif_cockpit_on
	bne	.entry

	ldx	#view_data2&xx	; camera(2) ... normal  mode
.entry	jsr	pauseobj_entry


.end	a16
	rts

;*********************************************************************
;	----------------------
;	 pause map enemy set 
;	----------------------
;*********************************************************************

disp_enemy
	inc	pause_enemyanime
	ldx	kx_enlistptr
	beq	.exit
	ldy	pause_objpointer
.loop

	km_bitcheckflag16.w	mmx_enflags,(enfl_finalboss),x
	bne	.next

	Mpmap_getpos	mmx_enposx+1,4,mmx_enposy+1,4+XXoffset
	sta	pauseobj_work

	phx			; >>
	lda.w	mmx_entype,x	; character select
	and	#00ffh
	asl	a
	tax
	lda.l	pause_enemydata,x
	jsr	set_1pauseobj
	plx			; <<

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; +++ satellite angleset +++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	lda.w	mmx_entype,x	; character select
	cmp	#entyp_satellite
	bne	.next

	phx				; >>

	lda	kx_houdaiangle	; 0,4,8,12,,,,,,, 62
	
;-------------------------------------
;;	lda	yajima_temp
;;	inc	a
;;	sta	yajima_temp
;;	lsr	a
;;	lsr	a
;;	lsr	a
;;	lsr	a
;;	lsr	a
;-------------------------------------
	and	#00111000b
	lsr	a
	tax

	a8
	lda.l	pause_satellite+0,x	; Xposition
	clc
	adc	pauseobj_work+0
	sta	pauseobj_work+0
	lda.l	pause_satellite+1,x	; Yposition
	clc
	adc	pauseobj_work+1
	sta	pauseobj_work+1
	a16

	lda.l	pause_satellite+2,x	; Char
	jsr	set_1pauseobj

	plx				; <<

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


.next	lda.w	mmx_ennext,x
	tax
	bne	.loop

.exit
	sty	pause_objpointer
	rts




;*********************************************************************
;	Set 1 Pause OBJ
;*********************************************************************
set_1pauseobj
	sta	sprites+2,y	; Character
	lda	pauseobj_work
	sta	sprites+0,y	; Position
	iny			; Pointer INC
	iny
	iny
	iny
	rts

;*********************************************************************
;	player set
;*********************************************************************

disp_player
	ldy	pause_objpointer
	sty	sprite_register
	ldx	#0
	Mpmap_getpos	mmx_arwingposx+1,0,mmx_arwingposy+1,XXoffset+4

	phb
	phk
	plb
	pha

	lda.l	pause_playeranime
	inc	a
	cmp	#0ch*3
	bcc	.skip
	lda	#0
.skip	sta.l	pause_playeranime
	Mdiv_u16u8	3
	asl	a
	tax
	ldy	.objchar&WM,x
	pla
	jsr	common_oamset
	plb
	ldy	sprite_register
	sty	pause_objpointer

	rts

.objchar	
	dw	obj_w0_2_0&WM
	dw	obj_w0_2_1&WM
	dw	obj_w0_2_2&WM
	dw	obj_w0_2_3&WM
	dw	obj_w0_2_4&WM
	dw	obj_w0_2_5&WM
	dw	obj_w0_2_6&WM
	dw	obj_w0_2_7&WM
	dw	obj_w0_2_8&WM
	dw	obj_w0_2_9&WM
	dw	obj_w0_2_10&WM
	dw	obj_w0_2_11&WM







;***********************************************************************
;	CORNERIA CRASH PROGRAM
;***********************************************************************

attack_check
	stz	pauseobj_temp		; clear flag
	phx			;>>
	ldx	kx_enlistptr
	beq	.exit

.loop	lda.w	mmx_enflags,x
	and	#enfl_attackcorneria
	ora	pauseobj_temp
	sta	pauseobj_temp

	lda.w	mmx_ennext,x
	tax
	bne	.loop

.exit	plx			; <<
	lda	pauseobj_temp		; set flag
	rts

;*********************************************************************
;	planet burn
;*********************************************************************

Mburnobj	macro
	lda	Xposwork
	adc	#\1	
	sta	Xposwork
	lda.l	pause_burndata,x
	beq	.\@p1
	sta	sprites+2,y
	lda	Xposwork
	sta	sprites+0,y	; position
	iny	
	iny
	iny
	iny
.\@p1
	inx
	inx
	endm

;--------------------------------------------------------------------

disp_burn
	inc	pause_planetanime

	ldx	kx_planetlistptr
	bne	.entry
	rts
;-----------------------------------------------

.entry
	ldy	pause_objpointer

.loop

;-----------------------------------------------
; CALC position
;-----------------------------------------------

	Mpmap_getpos	mmx_planetcx,8,mmx_planetcy,13+XXoffset
	sta	Xposwork

;------------------------------------------------
; yarare OBJECT display
;------------------------------------------------

	lda.w	mmx_name,x
	cmp	#planet_battleship
	bcs	.skip21
	lda.w	mmx_planetflag,x
	bit	#mmpnf_mothership+mmpnf_complete+mmpnf_corneria
	bne	.skip21

	phx			 ; >>
	sty	pause_objpointer
	ldx	#yarare_data&WM
	jsr	pauseobj_entry
	ldy	pause_objpointer
	plx			 ; <<

.skip21

;-----------------------------------------------
; burn objct check
;-----------------------------------------------
	lda.w	mmx_planetflag,x
	bit	#mmpnf_corneria
	beq	.skip10
;-----------------------------------------------
	jsr	attack_check		; corneria attack ??
	beq	.skip10

;-----------------------------------------------
; burn objct 3 character set
;-----------------------------------------------
	phx			; >>
	lda	pause_planetanime
	and	#000011000b
	lsr	a
	lsr	a
	tax
	clc
	Mburnobj	00200h
	Mburnobj	00707h
	Mburnobj	0f802h
	plx

;-----------------------------------------------
; next
;-----------------------------------------------

.skip10
	lda.w	mmx_planetnext,x
	tax
	beq	.exit
	jmp	.loop

;-----------------------------------------------
; exit
;-----------------------------------------------
.exit
	sty	pause_objpointer

	rts

;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
























;=====================================================================
;=====================================================================
;=========== LIBRARY =================================================
;=========== LIBRARY =================================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	objset library
;*********************************************************************

;--------------------------------------------------------------------

pauseobj_sizebig
	lda	#0ffffh
	sta	pauseobj_size
	rts

pauseobj_sizesmall
	stz	pauseobj_size
	rts

;--------------------------------------------------------------------

pauseobj_programjmp
	tyx
	jmp	(0,x)

;--------------------------------------------------------------------

pauseobj_exit	
	pla
	rts

;--------------------------------------------------------------------

pauseobj_posset
	tyx
	lda.l	this_bank,x
	sta	pauseobj_pos
	inx
	inx
	txy
	rts

;--------------------------------------------------------------------
pauseobj_posadd
	tyx
	lda.l	this_bank,x
	clc
	adc	pauseobj_pos
	sta	pauseobj_pos
	inx
	inx
	txy
	rts

;--------------------------------------------------------------------

pauseobj_attrset
	tyx
	lda.l	this_bank,x
	xba
	and	#0ff00h
	sta	pauseobj_attr
	inx
	txy
	rts

;--------------------------------------------------------------------

pauseobj_Vsameloop
	lda	#0800h
	bra	pauseobj_sameloop
pauseobj_Hsameloop
	lda	#0008h
pauseobj_sameloop
	bit	pauseobj_size
	beq	.set
	asl	a
.set	sta	pauseobj_add

		
	tyx
	phy			; >>

	lda.l	this_bank+1,x	; Character No
	and	#00ffh
	ora	pauseobj_attr	; Attribute
	sta	pauseobj_char

	lda.l	this_bank+0,x	; Counter
	and	#00ffh
	tax


	ldy	pause_objpointer	;   --->

.loop
	lda	pauseobj_pos
	sta	sprites+0,y	; position
	clc
	adc	pauseobj_add
	sta	pauseobj_pos

	lda	pauseobj_char
	sta	sprites+2,y	; character

	jsr	pauseobj_subset	; y = objpointer

	iny
	iny
	iny
	iny

	dex
	bne	.loop

	sty	pause_objpointer	;   <---

	ply			; <<
	iny
	iny
	rts

;--------------------------------------------------------------------

pauseobj_nomalset

	tyx
	lda.l	this_bank+0,x
	and	#00ffh
	sta	pauseobj_counter
	inx

	ldy	pause_objpointer

.loop	lda.l	this_bank+0,x
	sta	sprites+0,y	; position
	lda.l	this_bank+2,x
	sta	sprites+2,y	; character
	inx
	inx
	inx
	inx

	jsr	pauseobj_subset	; y = objpointer

	iny
	iny
	iny
	iny

	dec	pauseobj_counter
	bne	.loop	

	sty	pause_objpointer
	txy
	rts

;--------------------------------------------------------------------


pauseobj_Vdiffloop
	lda	#0800h
	bra	pauseobj_diffloop
pauseobj_Hdiffloop
	lda	#0008h
pauseobj_diffloop
	sta	pauseobj_add
		
	tyx

	lda.l	this_bank+0,x	; Counter
	and	#00ffh
	sta	pauseobj_counter
	inx

	ldy	pause_objpointer	;   --->
	clc
.loop
	lda	pauseobj_pos
	sta	sprites+0,y	; position
	adc	pauseobj_add
	sta	pauseobj_pos

	lda.l	this_bank,x
	beq	.next
	sta	sprites+2,y	; character

	iny	
	iny
	iny
	iny

.next	inx
	inx
	dec	pauseobj_counter
	bne	.loop

	sty	pause_objpointer	;   <---

	txy
	rts

;*********************************************************************
;	size calc
;*********************************************************************

pauseobj_subset

	lda	pauseobj_size
	beq	.exit

	phx		; >>
	phy		;   >>

	tya
	cmp	#220h
	bcs	.entry2

;----------------------------------------------
.entry1					; DOUBLEBUFFER (1)
	lsr	a
	tax
	lsr	a
	lsr	a
	lsr	a
	tay				; oam sub pointer
	txa
	and	#0110b
	tax

	lda	sprites+200h,y
	ora.l	objsub_size,x
	sta	sprites+200h,y

	ply		;   <<
	plx		; <<

.exit	rts

;----------------------------------------------
.entry2	sbc	#220h	; SEC		; DOUBLEBUFFER (2)
	lsr	a
	tax
	lsr	a
	lsr	a
	lsr	a
	tay				; oam sub pointer
	txa
	and	#0110b
	tax

	lda	sprites+420h,y
	ora.l	objsub_size,x
	sta	sprites+420h,y

	ply		;   <<
	plx		; <<

	rts

;---------------------------------------------------------------------

objsub_size	dw	000000010b
	dw	000001000b
	dw	000100000b
	dw	010000000b


;*********************************************************************
;	pause obj set mainloop
;*********************************************************************

pauseobj_entry

.loop	lda.l	this_bank,x		; X=ROM pointer
	and	#00ffh
	asl	a
	inx
	txy				; Y=ROM pointer
	tax
	jsr	(pauseobj_process,x)
	tyx				; Y=ROM pointer
	bra	.loop

;--------------------------------------------------------------------
;--------------------------------------------------------------------








;=====================================================================
;=====================================================================
; END END END END END END END END END END END END END END END END END
;=====================================================================
;=====================================================================
