
planeobjYpos 	equ 	30h-4
planecloseYpos 	equ	37h-4

;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: pselect.asm				*
;* 	Description	: player select screen 			*
;*	Date		: 1994.8.1				*
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
;
;*********************************************************************
;	readme
;*********************************************************************
;
; player_owner   .... 1p player  0...5
; player_friend  .... 2p player  0...5
;
;
;
;
;
;
;
;*********************************************************************
;	obj set macros
;*********************************************************************

Mobjset_message	macro	[count]
		db	idx_objset_message
		db	{count}
		endm

Mobjset_end		macro
		db	idx_objset_exit
		endm

Mobjset_Vposadd	macro	[count]
		db	idx_objset_Vadd
		db	{count}
		endm

;*********************************************************************
;	player select macors
;*********************************************************************
Mpsel_bgdrawall	macro	[romaddr]
		ldy	#{romaddr}&WM
		jsr	psel_bgdrawall
		endm

;---------------------------------------------------------------------
Mpsel_ifeasymodeNO	macro	[addr]
		lda	Kdifficulty	; if = 0 EASY MODE
		bne	{addr}
		endm

;---------------------------------------------------------------------
Mpsel_ifeasymodeYES	macro	[addr]
		lda	Kdifficulty
		beq	{addr}
		endm

;---------------------------------------------------------------------

;*******************************************************************
;	vram address
;*******************************************************************

bg1_vram		equ	mp_bg1_scr
ami_vram		equ	bg1_vram+72h		
name_vram		equ	bg1_vram+6bh
spec_vram		equ	bg1_vram+138h

;-------------------------------------------------------------------

bg3_vram		equ	5000h
config_vram		equ	bg3_vram+6ah+07h
bg3_clearcharNO	equ	001bh
bg3_clearcount	equ	0400h

;-------------------------------------------------------------------


;*******************************************************************
;	work used
;*******************************************************************

wkans_L		equ	Xwork6	; BCD DEC(10) data	low
wkans_H		equ	Xwork7	;			high
wkdividend_L		equ	Xwork8	;     HEX(16) data	low
wkdividend_H		equ	Xwork9	;			high
wkdivisor		equ	Xwork10 

;-------------------------------------------------------------------

pselstruct		equ	bgdemo_switch

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
;=====================================================================
;=====================================================================
;===========	PLAYER SELECT ===========================================
;===========	PLAYER SELECT ===========================================
;=====================================================================
;=====================================================================
;*******************************************************************
;	<<< INIT >>> player select screen
;*******************************************************************
init_pselect_l

	Mbankprog_start

;-------------------------------------------------
;	INITIALIZE PARAMETER
;-------------------------------------------------

	jsl	Read_backupRAM_playerconfig_l
	jsl	Read_backupRAM_defaulttwin_l

	lda	#0
	sta.l	backup_writeflag

	stz	p1_player	
	stz	p2_player
	MsetBL	kw_tm,13h

;-------------------------------------------------
;	INITIALIZE VRAM
;-------------------------------------------------

	jsr	psel_PPU_init
	jsr	psel_scrollclear
	jsr	psel_scrollset

	Mclear_vram	bg3_vram,bg3_clearcount,bg3_clearcharNo

	MsetL	textdraw_pointer,textdraw&WM	; drawpointer RESET
	Mpsel_BGdrawall	config_draw		; BUFFER write
	jsr	XDrawVram			; VRAM 	 write
	MsetL	textdraw_pointer,textdraw&WM	; drawpointer RESET

	jsr	bpsel_initial
	MsetL	mapexp_pointer,0

	ifeq	1
	Mpsel_ifeasymodeNO	.skip
	MsetL	mapexp_pointer,mapexp_easystart&WM
.skip
	endc

	MsetL	LVmessage_planetname,0ffffh
	Mset	pselstruct,idx_pselect_start

	lda	p1_pilotNO
	and	#00ffh
	sta	player_owner

;-------------------------------------------------
; 	EXIT
;-------------------------------------------------
.exit

	jsr	init_pselfacecolor

	Mbankrtl_end


;*******************************************************************
;	<<< MAIN >>> player select screen
;*******************************************************************
pselect_l
	Mbankprog_start

	sty	sprite_register		; oam-pointer

;;	MsetBL	2100h,07h

.1pmode
	jsr	pselmain_1p		; pselect main program
	jsr	pselcounterinc		; counter inc


;;	MsetBL	2100h,0fh

	

	ldy	sprite_register		; oam-pointer
	cpy	#128*4
	bcc	.exit

	blink				; OAM over blink

.exit
	Mbankrtl_end

;*******************************************************************
;	<<< NMI >>> player select screen
;*******************************************************************
draw_pselect_l
	Mbankprog_start

	jsr	anime_color	 ; Animation Color !!
	
	lda	objdraw
	and	#03h		; 0,1,2,3
	asl	a
	tax
	jsr	(.select,x)
	inc	objdraw

	Mbankrtl_end
	
;--------------------------------------------------------------------
.select	Mindexliststart
	Mindexlist	drawP1face	;(0)
	Mindexlist	drawBGscreen1	;(1)
	Mindexlist	drawP2face	;(2)
	Mindexlist	drawBGscreen2	;(3)

;====================================================================
;====================================================================
;====================================================================
;====================================================================
;
;
;
;
;
;*******************************************************************
;	animation color
;*******************************************************************
anime_color	a8
	lda	objdraw
	lsr	a
	lsr	a
	lsr	a
	and	#1
	asl	a
	tax
	lda	#1
	sta	Color_address
	lda.l	.data+0,x
	sta	Color_write
	lda.l	.data+1,x
	sta	Color_write
	a16
	rts

;-------------------------------------------------------------------
.data	dw	0842h
	dw	7fffh
;====================================================================







;*******************************************************************
;	draw select
;*******************************************************************
drawP1face	lda	player_owner
	ldy	#1400h
	jmp	drawfaceVRAM

;-------------------------------------------------------------------
drawP2face	lda.l	player_friend
	ldy	#1800h
	jmp	drawfaceVRAM

;-------------------------------------------------------------------
drawBGscreen1
drawBGscreen2
	jsr	XDrawVram	 ; <<<<< BG2 draw >>>>>
	lda	#textdraw&xx	 ; BGdrawpointer RESET
	sta.l	textdraw_pointer
	rts

;-------------------------------------------------------------------



;-------------------------------------------------------------------
;
;
;*******************************************************************
;	draw face character
;*******************************************************************
; Aregister = player Number
; Yregister = VRAM offset
;------------------------------------------------------------------
ptndata	dw	0000h	; 0 fox 	charcter offset
	dw	0800h	; 1 falco
	dw	1000h	; 2 peppy
	dw	1800h	; 3 slippy
	dw	4000h	; 4 cat
	dw	4800h	; 5 girls

;------------------------------------------------------------------
drawfaceVRAM	and	#00ffh
	asl	a
	tax
	lda.l	ptndata,x
	tax
	a8
	km_dmaXromYVRAM	0,(700000h+dec_base),6000h,800h
	a16
	rts

;*******************************************************************
;	pselect Counter Inc
;*******************************************************************
pselcounterinc

; INC framecounter -------------------------------------------------

	inc	yj_framecounter

; frash sprite counter ---------------------------------------------

	lda.l	attrcount
	inc	a
	cmp	#3*2
	bcc	.exit
	lda	#0
.exit	sta.l	attrcount

;------------------------------------------------------------------

	rts

;------------------------------------------------------------------
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
;
;
;===================================================================
;===================================================================
;=========== player select initialze ===============================
;=========== player select initialze ===============================
;===================================================================
;===================================================================
	longi
	longa

;*******************************************************************
;	player select scroll
;*******************************************************************

;----------------------------------------
; initialize scroll register
;----------------------------------------
psel_PPU_init	
	ai8
	ldx	#3*2-1
.loop	stz	Scroll_BG1H,x
	stz	Scroll_BG1H,x
	dex
	dex
	bpl	.loop
	ai16
	rts

;----------------------------------------
; scroll work clear
;----------------------------------------
psel_scrollclear
	lda	#0
	sta.l	psel_p1scroll
	sta.l	psel_p1speed
	sta.l	psel_p2scroll
	sta.l	psel_p2speed
	rts

;----------------------------------------
; scroll work set
;----------------------------------------
psel_scrollset

	clc
	lda.l	psel_p1scroll
	adc.l	psel_p1speed
	sta.l	psel_p1scroll	
	clc
	lda.l	psel_p2scroll
	adc.l	psel_p2speed
	sta.l	psel_p2scroll	

	a8
	lda.l	psel_p1scroll+1
	sta.l	kx_hscrollp1
	lda.l	psel_p2scroll+1
	sta.l	kx_hscrollp2
	a16

	rts

;-------------------------------------------------------------------
;
;
;
;
;
;
;
;
;-------------------------------------------------------------------
p1_initspeed	equ	-380h
p2_initspeed	equ	-380h
;-------------------------------------------------------------------
;===================================================================
;===================================================================
;=========== player select main ====================================
;=========== player select main ====================================
;===================================================================
;===================================================================
;
;*********************************************************************
;	
;*********************************************************************

pselect_exitobj
	jsr	set_cursor_1pX
	jmp	disp_friend

;*********************************************************************
;	1pgame player select
;*********************************************************************

pselmain_1p

	jsr	.sos
	lda	bpsel_p1+_bpselplayerNo
	cmp	#6
	bcs	.skip
	sta	player_owner
	a8
	sta.l	bps_keyptr1	; ===> Set player select pointer
	a16
.skip
	lda	bpsel_p2+_bpselplayerNo
	sta.l	player_friend
	rts

.sos
	ldx	#pselstruct
	stx	dcregister	; input register
	jsr	dc_select
	Mindexliststart
	Mindexlist	pselect_exit
	Mindexlist	pselect_start	; openning demo
	Mindexlist	pselect_close	; close <--- kyoutsu
	Mindexlist	pselect_select	; player select
	Mindexlist	pselect_okdemo	; pselect okdemo
	Mindexlist	pselect_okdemo2
	Mindexlist	pselect_okcheck
	Mindexlist	pselect_cancel
	Mindexlist	pselect_configdemo


pselect_exit
	rts



;*********************************************************************
;	1pgame config open
;*********************************************************************

pselect_configdemo

	jsr	set_cursor_1p
	jsr	OBJdisp_partner
	jsr	.entry
	jsr	Disp_BATTLEkeytypeobj
	jsr	Main_OBJ		; oamset 
	rts

.entry	jsr	dc_program
	dwnext	config_0
	dwflag	config_1

;--------------------------------------------------------------------
config_0
	ldx	#bpsel_p1
	lda	#idx_bpsel_configopen
	sta	_bpselprocess,x
	stz	_bpselcounter,x
;--------------------------------------------------------------------
config_1
	ldx	#bpsel_p1
	ldy	#0
	jsr	pselbatt_select

	ldx	register		; end-check
	lda	_bpselprocess,x
	cmp	#idx_bpsel_select
	bne	.exit

	ldx	dcregister
	Mset	pselstruct,idx_pselect_select

.exit	rts


;--------------------------------------------------------------------


;*********************************************************************
;	1pgame player select
;*********************************************************************

pselect_start
	jsr	dc_program
	dwstart
	dwwait	25
	dwnext	   pselect_open_0
	dwloop	14,pselect_open_1
	dwnext	   pselect_open_2
	dwloop	10,pselect_open_3
	dwstop	   pselect_open_exit	; keycheck loop	

;------------------------------------------------------------------
pselect_open_0
	jsr	Init_objlist
	Mobjinit 0,ys_faceopen,oamsetnew,30h,37h
	Mobjinit 1,ys_planeopen,oamsetnew,0c0h,planeobjYpos
	jsr	Main_OBJ
	rts

;------------------------------------------------------------------
pselect_open_3
pselect_open_1
	jsr	Main_OBJ
	rts

;------------------------------------------------------------------
pselect_open_2

	Mset	wipestruct,idx_wipeconf_open
	Mset	objdraw,idx_drawBGscreen1

	ldy	#amiset&xx
	jsr	psel_bgdraw
	Mobjchange 0,ys_foxSTpose,face_oamset_p1
	Mobjchange 1,ys_foxplane,plane_oamset_p1
	jsr	Main_OBJ
	rts
;------------------------------------------------------------------
pselect_open_exit
	Mset	pselstruct,idx_pselect_select
	jsr	Main_OBJ
	rts

;*********************************************************************
;	pselect select
;*********************************************************************
index_bpsel_p1
	ldy	#0
	sty	bpsel_index
	ldx	#bpsel_p1
	stx	register
	rts

;=====================================================================

pselect_select

	jsr	Disp_BATTLEkeytypeobj
	jsr	index_bpsel_p1
	jsr	move_cursor_1p
	jsr	set_cursor_1p
	jsr	OBJdisp_partner		

	jsr	dc_program
	dwnext	pselect_select_0
	dwstop	pselect_select_1

;=====================================================================
pselect_select_0
	ldx	register
	stz	_bpselcounter,x

pselect_select_1

	jsr	draw_playername

	lda	random_friend		; <<<<< random loop >>>>>
	inc	a
	cmp	#5
	bcc	.skip1
	lda	#0
.skip1	sta	random_friend

	lda	p1_player
	cmp	#6
	bcs	.exit

	Mkeytrigger	ok
	beq	.exit
	ksound	kettei
	Mset	pselstruct,idx_pselect_okdemo
	MsetBL	kw_tm,13h

.exit	
	jsr	Main_OBJ
	rts







;*********************************************************************
;	pselect okdemo
;*********************************************************************
pselect_okdemo

	jsr	Disp_BATTLEkeytypeobj
	jsr	OBJdisp_partner

	jsr	dc_program
	dwnext	      pselect_okdemo_00
	dwloop	3*5*2,pselect_okdemo_01
	dwstop	      pselect_okdemo_02

;=====================================================================
pselect_okdemo_00
	lda	#5
	sta.l	player_friend
	bra	pselect_okdemo_cm

;-------------------------------------------
pselect_okdemo_01
	Mkeytrigger	ok
	beq	pselect_okdemo_cm
	bne	pselect_okdemo_02next		; <= demo next

;-------------------------------------------
pselect_okdemo_02
	tyx					; Auto Stop !!
	lda	_dccounter,x
	lsr	a
	lsr	a
	cmp	random_friend
	bne	pselect_okdemo_cm

;-------------------------------------------
pselect_okdemo_02next
	ksound	kettei
	Mset	pselstruct,idx_pselect_okdemo2

;-------------------------------------------
pselect_okdemo_cm
	jsr	slot_friend
	jmp	pselect_1pfulldisp

;-------------------------------------------

;*******************************************************************
;	player select <<<<< OK DEMO >>>>>
;*******************************************************************
pselect_okdemo2
	jsr	Disp_BATTLEkeytypeobj
	jsr	disp_friend
	
	jsr	dc_program
	dwnext	   pselect_okdemo2_1
	dwloop	14,pselect_okdemo2_2
	dwnext	   pselect_okdemo2_3
	dwstop	   pselect_okdemo2_4

;------------------------------------------------------------------
pselect_okdemo2_1
	Mobjinit 2,ys_faceopen,oamsetnew,30h,37h+80h
	Mobjinit 3,ys_planeopen,oamsetnew,0c0h,planeobjYpos+80h

;------------------------------------------------------------------
pselect_okdemo2_2
	jmp	pselect_1pfulldisp

;------------------------------------------------------------------
pselect_okdemo2_3
	Mset	objdraw,idx_drawBGscreen1
	ldy	#amiset&WM
	jsr	psel_bgdrawP2
	bra	pselect_okdemo2_2

;------------------------------------------------------------------
pselect_okdemo2_4

	Mobjchange 2,ys_foxSTpose,face_oamset_p2
	Mobjchange 3,ys_foxplane,plane_oamset_p2

	Mset	pselstruct,idx_pselect_okcheck
	jmp	pselect_1pfulldisp

;------------------------------------------------------------------

;*********************************************************************
;	pselect okcheck
;*********************************************************************

pselect_okcheck
	jsr	Disp_BATTLEkeytypeobj
	jsr	drawname2
	jsr	set_OKcursor	; OK cursor set

	jsr	dc_program
	dwnext	pselect_okcheck_0
	dwflag	pselect_okcheck_1
	dwloop	4,pselect_okcheck_2
	dwstop	pselect_okcheck_3

;------------------------------------------------------------------

pselect_okcheck_0
	; set pselstart
;------------------------------------------------------
pselect_okcheck_1
	jsr	move_cursor_2p
	jsr	disp_friend	

	Mkeytrigger	cancel		; ( cancel )
	beq	.entry	
	ksound	cancel
	Mset	pselstruct,idx_pselect_cancel
	bra	.exit

.entry	Mkeytrigger	ok		; ( OK )
	beq	.exit

	ksound	good_luck
	ldx	dcregister
	dec	_dcflag,x

.exit	jmp	pselect_1pfulldisp	
;------------------------------------------------------
pselect_okcheck_3
	inc	mpw_misplayerflag	; <<< exit player select >>>
pselect_okcheck_2
	jsr	move_cursor_2p
	jsr	disp_friend	
	jmp	pselect_1pfulldisp	
;------------------------------------------------------

;*********************************************************************
;	pselect cancel
;*********************************************************************

pselect_cancel

	jsr	Disp_BATTLEkeytypeobj
	jsr	set_cursor_1pX

	jsr	dc_program
	dwnext	   pselect_cancel_1
	dwloop	14,pselect_cancel_2
	dwstop	   pselect_cancel_3

;------------------------------------------------------------------
pselect_cancel_1				; ( ami exit )


	Mset	objdraw,idx_drawBGscreen1
	ldy	#name_clear&xx		; cancel BG name
	jsr	psel_bgdrawP2
	ldy	#amiclear&WM
	jsr	psel_bgdrawP2

	Mobjchange 2,ys_faceclose,oamsetnew
	Mobjchange 3,ys_planeclose,oamsetnew

;------------------------------------------------------------------
pselect_cancel_2
	jmp	pselect_1pfulldisp

;------------------------------------------------------------------
pselect_cancel_3				; ( select return )
	Mset	pselstruct,idx_pselect_select
	jmp	pselect_1pfulldisp

;------------------------------------------------------------------







;
;
;
;

;*******************************************************************
;	-------------------
;	 set player sprite 
;	-------------------
;*******************************************************************


;*******************************************************************
;	full display 
;*******************************************************************

pselect_1pfulldisp

	ldx	#bpsel_p1	; player(1)
	lda	_bpselflag,x
	ora	#on_gogo
	sta	_bpselflag,x

	jsr	drawname
	jsr	Main_OBJ
	rts

;*******************************************************************
;	slot
;*******************************************************************
;----------------------------------------------
; <<<<< select friend >>>>>
;----------------------------------------------

slot_friend
	ldx	dcregister
	lda	_dccounter,x
	and	#03h
	bne	disp_friend

next_friend	lda	p2_player
	inc	a
	cmp	#6
	bcc	.skip
	lda	#0
.skip	sta	p2_player

;----------------------------------------------
; <<<<< friend display >>>>>
;----------------------------------------------

disp_friend	
	jsr	set_cursor_1pX

	lda	p2_player
	cmp	p1_player
	beq	next_friend
	tax
	lda	p_pos&xx,x
	and	#00ffh
	ora	#08200h

	ldx	#0		; attr
	ldy	#p_data&xx	; ROMaddress
	jmp	yj_setsprite


;*******************************************************************
;	player-1 OKcursor move
;*******************************************************************

set_OKcursor
	lda.l	attrcount
	and	#0110b
	xba
	tax			; attribute
	lda	#64b8h		; position
	ldy	#ok_data2&xx	; ROM address
	jmp	yj_setsprite

;*******************************************************************
;	player-1 cursor move
;*******************************************************************
move_cursor_1p
	lda	p1_player
	pha			; >>
	Mpsel_keymove	left,right,p1_player,7
	bcc	.skip

	ldx	register	; battle mode process register
	stz	_bpselcounter,x
	ldx	p1_player
	cpx	#6		; if 6 then soundskip !!
	bcs	.skip

	ksound	cursor

.skip	pla			; <<
	ldx	p1_player
	cpx	#6
	bcc	.exit

	Mset	pselstruct,idx_pselect_configdemo


.exit	rts

;--------------------------------------------------------------------

move_cursor_2p

.loop	Mpsel_keymove	left,right,p2_player,6
	lda	p2_player
	eor	p1_player
	beq	.loop	
	bcc	.exit
	ksound	cursor		; cursor sound !!
.exit
	rts

	
;*******************************************************************
;	player-1 cursor set
;*******************************************************************
set_cursor_1p
	ldy	#0
	ldx	p1_player
	lda	p_pos&xx,x
	and	#00ffh
	jmp	set_pselfrashcursor

;*******************************************************************
;	player-1 cursor set
;*******************************************************************
set_cursor_1pX
	ldy	p1_player
	ldx	#0
	jmp	set_1pnormalcursor

;*********************************************************************
;	display ONLY OBJECT
;*********************************************************************
OBJdisp_partner
	ldx	#3600h		; attribute
	ldy	#partner_data&WM
	lda	#0b048h
	jmp	yj_setsprite

;---------------------------------------------------------------------
partner_data
	Mobjset_message	14
	dw	3122h,3123h,3124h,3125h,3126h,3127h,3128h
	dw	3129h,312ah,312bh,312ch,312dh,312eh,312fh
	Mobjset_Vposadd 8
	Mobjset_message	14
	dw	3132h,3133h,3134h,3135h,3136h,3137h,3138h
	dw	3139h,313ah,313bh,313ch,313dh,313eh,313fh
	Mobjset_end
;---------------------------------------------------------------------

;*********************************************************************
;	cursor datas
;*********************************************************************
p_pos	db	48h  ;0
	db	58h  ;1
	db	68h  ;2
	db	78h  ;3
	db	88h  ;4
	db	98h  ;5
	db	0a8h ;
;---------------------------------------------------------------------

;-------------------------------------------------------------------
; player1 move next
;-------------------------------------------------------------------
movefire1x	ldx	register
	inc	_velocityX,x	; <- wait timer
	lda	_velocityX,x	; <- wait timer
	cmp	#80		; <- 60s  timer
	bne	exitfire

	ksound	boost

	stz	_velocityX,x	; <- speed work
	lda	#movefire1y&XX
	sta	_program,x
;---------------------------------------------

movefire1y	

	ldx	register
	lda	_velocityX,x
	clc
	adc	#-080h		; speed up
	sta	_velocityX,x
	jsr	Vspeedanime	; Vposition anime
	jsr	moveXY		; move X/Y
exitfire	
	jmp	Newoamset

;-------------------------------------------------------------------
; player1 move program
;-------------------------------------------------------------------
movefire1	jsr	speedmove
	sta.l	psel_p1speed
	jsr	planemove
	jmp	Newoamset

;-------------------------------------------------------------------
; player2 move next
;-------------------------------------------------------------------
movefire2	jsr	speedmove
	sta.l	psel_p2speed
	jsr	planemove
	jmp	Newoamset


;*******************************************************************
;	close demo lib
;*******************************************************************
;-------------------------------------------------------------------
; player move library
;-------------------------------------------------------------------
speedmove	ldx	register
	clc
	lda	_velocityX,x
	adc	#-p1_initspeed
	Mnegative
	asl	a
	rts

;-------------------------------------------------------------------

planemove
	ldy	register
	jsr	VYmove
	tyx

	lda	_velocityX,x
	bmi	.skip
	tay
	lda	#movefire1x&XX	; ( program change )
	sta	_program,x
	stz	_velocityX,x
	tya
.skip
	clc
	adc	#0eh
	sta	_velocityX,x
	jmp	moveXY

;-------------------------------------------------------------------

VYmove	rts

	lda	yj_framecounter
	asl	a
	asl	a
	asl	a
	and	#0ffh
	tax
	lda.l	ramsintab,x
	Msex
	sta.w	_velocityY,y
	rts

;-------------------------------------------------------------------

Vspeedanime	rts

	stz	_velocityY,x
	lda	yj_framecounter
	lsr	a
	bcc	.skip
	inc	_axisY,x
	rts

.skip	dec	_axisY,x
	rts

;-------------------------------------------------------------------





;*******************************************************************
;	<< char name >> & << plane neme >>
;*******************************************************************

drawname	lda	player_owner	 ;  NAME draw
	asl	a
	tax
	ldy	name_select&xx,x ; 
	jmp	psel_bgdraw    

;-------------------------------------------------------------------

drawname2	


	lda.l	player_friend	 ;  NAME friend
	asl	a
	tax
	ldy	name_select&xx,x ; 
	jmp	psel_bgdrawP2    

;===================================================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
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
;	buffer copy
;*******************************************************************
;
; Y = draw rom address
;
; A = draw character counter
;
;
;  psel_bgdrawall  ...... 1,2 all
;
;  psel_bgdraw     ...... player1-BG(VRAM) draw buffer
;  psel_bgdrawP2   ...... player2-BG(VRAM) draw buffer
;
;  psel_bgrawN     ...... player1 countup
;  psel_bgrawN2    ...... player2 countup
;
;-------------------------------------------------------------------
drawcount	equ	Xwork0
drawadd	equ	Xwork1
;-------------------------------------------------------------------
	
psel_bgdrawall
	phy			; >>
	jsr	psel_bgdraw
	ply			; <<
	jmp	psel_bgdrawP2

;----------------------------------------------
psel_bgdrawN2
	ldx	#200h
	bra	psel_common
psel_bgdrawP2
	ldx	#200h
	lda	#100
	bra	psel_common
;----------------------------------------------
psel_bgdraw	lda	#100
psel_bgdrawN	ldx	#0
;----------------------------------------------
psel_common	sta	drawcount 
	stx	drawadd
;----------------------------------------------
	lda.l	textdraw_pointer
	tax

.loop	lda.w	0,y
	beq	.exit
	cmp	drawcount
	bcc	.set
	lda	drawcount	
.set	sta.l	bank7fRAM,x	; counter

	lda.w	2,y		; ROM address
	sta.l	bank7fRAM+2,x
	lda.w	4,y		; VRAN address
	clc
	adc	drawadd
	sta.l	bank7fRAM+4,x

	inx
	inx
	inx
	inx
	inx
	inx

	iny
	iny
	iny
	iny
	iny
	iny

	bra	.loop


.exit	sta.l	bank7fRAM,x	; end code
	txa
	sta.l	textdraw_pointer

	rts

;--------------------------------------------------------------------
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
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;=========== player select OAM data ================================
;=========== player select OAM data ================================
;=========== player select OAM data ================================
;=========== player select OAM data ================================
;=========== player select OAM data ================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;*******************************************************************
;	oamset programs
;*******************************************************************
;
;
;
;
;
;
;-------------------------------------------------------------------
oamsetnew
	ldx	register
	stz	_charadd,x
	jmp	Newoamset

;-------------------------------------------------------------------
;
;
;
;
;
;*********************************************************************
;	display ONLY OBJECT
;*********************************************************************


;----------------------------------------------

p_data	Mobjset_message	2
	dw	301bh,301ch
	Mobjset_end

;----------------------------------------------

p1_data	Mobjset_message 2
	dw	3090h,3091h
	Mobjset_end

;----------------------------------------------
p2_data	Mobjset_message 2
	dw	3092h,3093h
	Mobjset_end

;----------------------------------------------

ok_data	Mobjset_message 2
	dw	3094h,3095h
	Mobjset_end

;----------------------------------------------
ok_data2	Mobjset_message 2
	dw	3094h,3095h
	Mobjset_Vposadd	1eh
	Mobjset_message 2
	dw	3094h,3095h
	Mobjset_end
;----------------------------------------------
;
;
;
;
;*********************************************************************
;	sprite set (8x8)
;*********************************************************************
objset_basicpos	equ	Xwork0
objset_counter	equ	Xwork1
objset_attr		equ	Xwork2
;---------------------------------------------------------------------
yj_setsprite
	stx	objset_attr
	sta	objset_basicpos
.loop	lda.w	0,y
	iny
	and	#00ffh
	asl	a
	tax
	jsr	(.process,x)
	bra	.loop

.process	Mindexliststart
	Mindexlist	objset_exit	; end
	MIndexlist	objset_message	; H+8,V,(attr),(char)
	Mindexlist	objset_Vadd	; basicV+8

;--------------------------------------------------
objset_Vadd	
	lda.w	0,y			; position addition
	and	#00ffh
	xba
	iny
	clc
	adc	objset_basicpos
	sta	objset_basicpos
	rts
;--------------------------------------------------
objset_exit	
	pla	; << 
	rts
;--------------------------------------------------
objset_message
	lda.w	0,y
	and	#00ffh
	iny
	sta	objset_counter	

	ldx	sprite_register	; = OAM pointer
	lda	objset_basicpos
.loop	sta.l	sprites,x
	clc
	adc	#0008h
	inx
	inx
	pha			; >>
	lda.w	0,y
	ora	objset_attr
	sta.l	sprites,x
	pla			; <<
	iny
	iny
	inx
	inx
	dec	objset_counter
	bne	.loop
	stx	sprite_register	; = OAM pointer

	rts
;--------------------------------------------------







;*********************************************************************
; 	player type select data
;*********************************************************************
;---------------------------------------------------------------------
; NOMAL pose
;---------------------------------------------------------------------
facenomalpose_select
pseldata	db	ys_foxSTpose
	db	ys_falcoSTpose
	db	ys_peppySTpose	
	db	ys_slippySTpose
	db	ys_catSTpose
	db	ys_girlSTpose

;---------------------------------------------------------------------
; OK pose
;---------------------------------------------------------------------
faceOKpose_select
pseldataOK	db	ys_foxOKpose
	db	ys_falcoOKpose
	db	ys_peppyOKpose
	db	ys_slippyOKpose
	db	ys_catOKpose
	db	ys_girlOKpose

;---------------------------------------------------------------------
; PLANE POSE
;---------------------------------------------------------------------
playerplane_select
pseldata2	db	ys_foxplane
	db	ys_falcoplane
	db	ys_peppyplane
	db	ys_slippyplane
	db	ys_catplane
	db	ys_girlplane
	db	ys_foxplane

;---------------------------------------------------------------------
; PLANE FIRE OFFSET
;---------------------------------------------------------------------
pfoffset	db	8 ; 0
	db	8 ; 1
	db	8 ; 2
	db	8 ; 3
	db	8 ; 4 
	db	8 ; 5
	db	0 ; 6

;---------------------------------------------------------------------
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
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;=========== player select screen data BG1/BG3 =====================
;=========== player select screen data BG1/BG3 =====================
;=========== player select screen data BG1/BG3 =====================
;=========== player select screen data BG1/BG3 =====================
;=========== player select screen data BG1/BG3 =====================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
;-------------------------------------------------


;*******************************************************************
;	bg1 player plane ami data
;*******************************************************************

;-------------------------------------------------
amiset
	dw	12,amidata0&xx,ami_vram+000h
	dw	12,amidata1&xx,ami_vram+020h
	dw	12,amidata1&xx,ami_vram+040h
	dw	12,amidata1&xx,ami_vram+060h
	dw	12,amidata2&xx,ami_vram+080h
	dw	12,itemdata1&xx,ami_vram+0a0h
	dw	12,itemdata2&xx,ami_vram+0c0h
	dw	0
;-------------------------------------------------
itemdata1	dw	0cb6h,0cb7h,0cb8h,0cb9h,0cbah,0cbbh,0cbch
	dw	0cbdh,0cbeh,0cbfh,0cd0h,0cd1h
;-------------------------------------------------
itemdata2	dw	0cc6h,0cc7h,0cc8h,0cc9h,0ccah,0ccbh,0ccch
	dw	0ccdh,0cceh,0ccfh,0ce0h,0ce1h
;-------------------------------------------------
amidata0
	dw	0c60h
	dw	0c61h,0c61h
	dw	0c61h,0c61h
	dw	0c61h,0c61h
	dw	0c61h,0c61h
	dw	0c61h,0c61h
	dw	0c62h

amidata1	
	dw	0c63h
	dw	0c64h,0c64h
	dw	0c64h,0c64h
	dw	0c64h,0c64h
	dw	0c64h,0c64h
	dw	0c64h,0c64h
	dw	0c65h

amidata2	
	dw	0c66h
	dw	0c67h,0c67h
	dw	0c67h,0c67h
	dw	0c67h,0c67h
	dw	0c67h,0c67h
	dw	0c67h,0c67h
	dw	0c68h

;-------------------------------------------------
amiclear	dw	12,amidata3&xx,ami_vram+000h
	dw	12,amidata3&xx,ami_vram+020h
	dw	12,amidata3&xx,ami_vram+040h
	dw	12,amidata3&xx,ami_vram+060h
	dw	12,amidata3&xx,ami_vram+080h
	dw	12,amidata3&xx,ami_vram+0a0h
	dw	12,amidata3&xx,ami_vram+0c0h
	dw	0

;------------------------------------------------
amidata3
	dw	2,2,2,2,2,2,2,2
	dw	2,2,2,2


;-------------------------------------------------


;*******************************************************************
;	bg1 player plane name/spec data
;*******************************************************************

name_select	dwcode	name_fox
	dwcode	name_falco
	dwcode	name_peppy
	dwcode	name_slippy
	dwcode	name_cat
	dwcode	name_girl
;--------------------------------------------------






;-------------------------------------------------
name_fox	dw	6,.fox1&xx,name_vram+00h
	dw	6,.fox2&xx,name_vram+20h
	dw	0
;-------------------------------------------------
.fox1	dw	0c90h,0c91h,0c92h,0002h,0002h,0002h
.fox2	dw	0ca0h,0ca1h,0ca2h,0002h,0002h,0002h
;-------------------------------------------------
name_falco	dw	6,.falco1&xx,name_vram+00h
	dw	6,.falco2&xx,name_vram+20h
	dw	0
;-------------------------------------------------
.falco1	dw	0c90h,0c93h,0c94h,0c95h,0c91h,0002h
.falco2	dw	0ca0h,0ca3h,0ca4h,0ca5h,0ca1h,0002h
;-------------------------------------------------
name_peppy	dw	6,.peppy1&xx,name_vram+00h
	dw	6,.peppy2&xx,name_vram+20h
	dw	0
;-------------------------------------------------
.peppy1	dw	0c96h,0c97h,0c96h,0c96h,0c98h,0002h
.peppy2	dw	0ca6h,0ca7h,0ca6h,0ca6h,0ca8h,0002h
;-------------------------------------------------
name_slippy	dw	6,.slippy1&xx,name_vram+00h
	dw	6,.slippy2&xx,name_vram+20h
	dw	0
;-------------------------------------------------
.slippy1	dw	0c99h,0c94h,0c9ah,0c96h,0c96h,0c98h
.slippy2	dw	0ca9h,0ca4h,0caah,0ca6h,0ca6h,0ca8h
;-------------------------------------------------
name_cat	dw	6,.cat1&xx,name_vram+00h
	dw	6,.cat2&xx,name_vram+20h
	dw	0
;-------------------------------------------------
.cat1	dw	0c9bh,0c9ah,0c98h,0c9fh,0002h,0002h
.cat2	dw	0cabh,0caah,0ca8h,0cafh,0002h,0002h
;-------------------------------------------------
name_girl	dw	6,.girl1&xx,name_vram+00h
	dw	6,.girl2&xx,name_vram+20h
	dw	0
;-------------------------------------------------
.girl1	dw	0c90h,0c93h,0c98h,0002h,0002h,0002h
.girl2	dw	0ca0h,0ca3h,0ca8h,0002h,0002h,0002h
;-------------------------------------------------
name_clear	dw	6,.clear&xx,name_vram+00h
	dw	6,.clear&xx,name_vram+20h
	dw	0
;-------------------------------------------------
.clear	dw	0002h,0002h,0002h,0002h,0002h,0002h
;-------------------------------------------------
;
;
;
;
;
;
;





;*******************************************************************
; config BG
;*******************************************************************


config_draw
	dw	13,Xconfig0&xx,config_vram+000h
	dw	13,Xconfig7&xx,config_vram+0e0h
config_A
	dw	13,.config1&xx,config_vram+020h
	dw	13,.config2&xx,config_vram+040h
	dw	13,.config3&xx,config_vram+060h
	dw	13,.config4&xx,config_vram+080h
	dw	13,.config5&xx,config_vram+0a0h
	dw	13,.config6&xx,config_vram+0c0h
	dw	0

	;-----------0------1------2------3------4------5------6------7------8-----9-----10-----11-----12------
.config1	dw	03000h,03001h,03002h,03003h
	dw	03004h,03005h,03006h,03007h,03008h,03009h,0300Ah,0300Bh,0300Ch
.config2	dw	03010h,03011h,03012h,03013h
	dw	03014h,03015h,03016h,03017h,03018h,03019h,0301Ah,0301Bh,0301Ch
.config3	dw	03020h,03021h,03022h,03023h
	dw	03024h,03025h,03026h,03027h,03028h,03029h,0302Ah,0302Bh,0302Ch
.config4	dw	03030h,03031h,03032h,03033h
	dw	03034h,03035h,03036h,03037h,03038h,03039h,0303Ah,0303Bh,0303Ch
.config5	dw	03040h,03041h,03042h,03043h
	dw	03044h,03045h,03046h,03047h,03048h,03049h,0304Ah,0304Bh,0304Ch
.config6	dw	03050h,03051h,03052h,03053h
	dw	03054h,03055h,03056h,03057h,03058h,03059h,0305Ah,0305Bh,0305Ch

Xconfig7	dw	0300Eh,0300Eh,0300Eh,0300Eh
	dw	0300Eh,0300Eh,0a00Dh,0300Eh,0300Eh,0300Eh,0300Eh,0300Eh,0300Eh
Xconfig0	dw	0300Eh,0300Eh,0300Eh,0300Eh
	dw	0300Eh,0300Eh,0200Dh,0300Eh,0300Eh,0300Eh,0300Eh,0300Eh,0300Eh

config_B	dw	13,.configb1&xx,config_vram+020h
	dw	13,.configb2&xx,config_vram+040h
	dw	13,.configb3&xx,config_vram+060h
	dw	13,.configb4&xx,config_vram+080h
	dw	13,.configb5&xx,config_vram+0a0h
	dw	13,.configb6&xx,config_vram+0c0h
	dw	0

.configb1	dw	03400h,03460h,03461h,03462h,03463h,03405h,03406h,03407h,03408h,03409h,0340Ah,0340Bh,0340Ch
.configb2	dw	03410h,03470h,03471h,03472h,03473h,03415h,03416h,03417h,03418h,03419h,0341Ah,0341Bh,0341Ch
.configb3	dw	03420h,03421h,03422h,03423h,03424h,03425h,03426h,03427h,03428h,03429h,0342Ah,0342Bh,0342Ch
.configb4	dw	03430h,03431h,03432h,03433h,03434h,03435h,03436h,03437h,03438h,03439h,0343Ah,0343Bh,0343Ch
.configb5	dw	03440h,03480h,03481h,03482h,03483h,03445h,03446h,03447h,03448h,03449h,0344Ah,0344Bh,0344Ch
.configb6	dw	03450h,03451h,03452h,03453h,03454h,03455h,03456h,03457h,03458h,03459h,0345Ah,0345Bh,0345Ch

config_C	dw	13,.configc1&xx,config_vram+020h
	dw	13,.configc2&xx,config_vram+040h
	dw	13,.configc3&xx,config_vram+060h
	dw	13,.configc4&xx,config_vram+080h
	dw	13,.configc5&xx,config_vram+0a0h
	dw	13,.configc6&xx,config_vram+0c0h
	dw	0

.configc1	dw	03800h,03801h,03802h,03803h,03804h,03805h,03806h,03864h,03865h,03866h,03867h,03868h,0380Ch
.configc2	dw	03810h,03811h,03812h,03813h,03814h,03815h,03816h,03874h,03875h,03876h,03877h,03878h,0381Ch
.configc3	dw	03820h,03821h,03822h,03823h,03824h,03825h,03826h,03884h,03885h,03886h,03887h,03888h,0382Ch
.configc4	dw	03830h,03831h,03832h,03833h,03834h,03835h,03836h,03869h,0386Ah,0386Bh,0386Ch,0386Dh,0383Ch
.configc5	dw	03840h,03841h,03842h,03843h,03844h,03845h,03846h,03879h,0387Ah,0387Bh,0387Ch,0387Dh,0384Ch
.configc6	dw	03850h,03851h,03852h,03853h,03854h,03855h,03856h,03857h,03858h,03859h,0385Ah,0385Bh,0385Ch

config_D	dw	13,.configd1&xx,config_vram+020h
	dw	13,.configd2&xx,config_vram+040h
	dw	13,.configd3&xx,config_vram+060h
	dw	13,.configd4&xx,config_vram+080h
	dw	13,.configd5&xx,config_vram+0a0h
	dw	13,.configd6&xx,config_vram+0c0h
	dw	0

.configd1	dw	03C00h,03C60h,03C61h,03C62h,03C63h,03C05h,03C06h,03C64h,03C65h,03C66h,03C67h,03C68h,03C0Ch
.configd2	dw	03C10h,03C70h,03C71h,03C72h,03C73h,03C15h,03C16h,03C74h,03C75h,03C76h,03C77h,03C78h,03C1Ch
.configd3	dw	03C20h,03C21h,03C22h,03C23h,03C24h,03C25h,03C26h,03C84h,03C85h,03C86h,03C87h,03C88h,03C2Ch
.configd4	dw	03C30h,03C31h,03C32h,03C33h,03C34h,03C35h,03C36h,03C69h,03C6Ah,03C6Bh,03C6Ch,03C6Dh,03C3Ch
.configd5	dw	03C40h,03C80h,03C81h,03C82h,03C83h,03C45h,03C46h,03C79h,03C7Ah,03C7Bh,03C7Ch,03C7Dh,03C4Ch
.configd6	dw	03C50h,03C51h,03C52h,03C53h,03C54h,03C55h,03C56h,03C57h,03C58h,03C59h,03C5Ah,03C5Bh,03C5Ch






;===================================================================
;===================================================================
;===================================================================
;===================================================================
;===================================================================
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
;===================================================================
;===================================================================
;=========== library programs ======================================
;=========== library programs ======================================
;===================================================================
;===================================================================
;*******************************************************************
;	clear vram
;*******************************************************************
; 
; character/screen VRAM clear
;
; MODE	DBR ...... databank
; 	ai16 
;
; <<<< EXSAMPLE >>>>>
;
;	jsr	yjclear_vram
;	dw	vram_address
;	dw	vram_datacount
;	dw	clear_charcterNo
;
;-------------------------------------------------------------------
yjclear_vram
	plx			; >>
	txa
	clc
	adc	#6
	pha			; <<

	lda	#80h		; ( hI INC )
	sta	Screen_step
	lda.w	1,x		; ( vram address )
	sta	Screen_address
	ldy.w	3,x		; ( data byte counter )
	lda.w	5,x
.loop	sta	Screen_write
	dey
	bne	.loop

	rts

;===================================================================
;===================================================================
;=========== bg draw library =======================================
;=========== bg draw library =======================================
;===================================================================
;===================================================================
;*******************************************************************
; 
; VRAM draw	( software )
;
;*******************************************************************
;
; ((( ldx #BG buffer address )))
;
; databank = programbank
;
;===================================================================
XDrawVram	Mbankprog


;------------------------------------------------------
	ldx	#textdraw&xx    ; BG buffer address
;------------------------------------------------------
	lda	#80h
	sta	Screen_step
;------------------------------------------------------
			  ; first check
	lda.l	bank7fRAM,x ; DRAW counter
	beq	.exit
	tay
	lda	#0
	sta.l	bank7fRAM,x	
	tya
;------------------------------------------------------
.next	pha		  ; >>
;---------------------------------------------
	inx
	inx
;---------------------------------------------
	lda.l	bank7fRAM,x ; ROM  address
	tay
	inx
	inx
;---------------------------------------------
	lda.l	bank7fRAM,x ; VRAM address
	sta	Screen_address
	inx
	inx
;---------------------------------------------
	pla		  ; <<
	phx		  ; >>
	tax		  ; X = counter 
;---------------------------------------------
.loop2	lda.w	0,y	  ; draw loop
	sta	Screen_write
	iny
	iny
	dex
	bne	.loop2
;---------------------------------------------
	plx		  ; <<
	lda.l	bank7fRAM,x ; DRAW counter
	bne	.next
;------------------------------------------------------

.exit
	Mbankrts

;===================================================================
;;
;;
;;
;;
;;
;;
;==============================================================
;==============================================================
; END END END END END END END END END END END END END END END
;==============================================================
;==============================================================
