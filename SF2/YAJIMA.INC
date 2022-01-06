next_marge	    = 0		; kondo marge surutoki 1 ni suru !!!
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*	File 		: yajima.def				*
;*	Description	; macros				*
;*			; memory alocate			*
;*			; labels				*
;*			; asemble flags				*
;*	Date		: 1994.11.18				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;*********************************************************************
;	game label
;*********************************************************************
;
;----------------------------------------------------------
CLEAR_MEDAL_TOTAL	equ	52	; medal total data
;----------------------------------------------------------
fell_message		equ	110	; gameover message
area_message		equ	115
viru_message		equ	209
;----------------------------------------------------------
;
;
;
;
;
;=====================================================================
;;;;;
;;;;;	mismap.asm
;;;;;
;=====================================================================
;
;objdemo_start_easy
;objdemo_start_normal
;objdemo_start_hard
;	objdemoseq	dm_bsappeartrig
;	objdemoseq	dm_bsappearwait
;;;	objdemoseq	dm_senryouplanettrig
;;;	objdemoseq	dm_senryouplanetwait
;	objdemoseq	dm_plappeartrig
;	objdemoseq	dm_plappearwait
;	objdemoseqend
;=====================================================================
;=====================================================================
;===========	GAME PARAMETR ===========================================
;===========	GAME PARAMETR ===========================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	SET GAME PARAMETER
;*********************************************************************

hellchange_count	equ	1	; heaven <-> hell timming

;---------------------------------------------------------------------
;
;
;
;
;
;=====================================================================
;=====================================================================
;===========	BANK11 ASSEMBLE FLAGS ===================================
;===========	BANK11 ASSEMBLE FLAGS ===================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	ASSEMBLE FLAGS
;*********************************************************************
;
;----------------------------------------------------------------------


;----------------------------------------------------------------------
	ifne	debuginfo
;----------------------------------------------------------------------
AFdebugprint	    		= 1 ; ( hell.asm )	    0/1 game/on(printd)
AFpauselook	    		= 1 ; ( pausemap/wipepause )0/1 game/debug
AFdebugwipe	    		= 0 ; ( wipe.asm )	    0/1 game/debug(wipespeedup)
AFdebugcpuspeed  		= 0 ; objdraw cpuspeed	    0/1 game/speed-check
AFmapanimeobj    		= 0 ; map animation test    0/1 game/debug
AFdebugpselect   		= 0 ;
;----------------------------------------------------------
AFdebugmode_mapmessageON	= 1 ; ON ALL MESSAGE LOOKAT
;----------------------------------------------------------
AFdebugmpde_trigmessageON	= 0 ; ROM(map)      message test
AFrammessage_debug 		= 0 ; RAM(game&map) message test
AFrammessage_debuggameover	= 0 ; RAM(game&map) message test
;----------------------------------------------------------------------
	elseif
;----------------------------------------------------------------------
AFdebugprint	    		= 0 ; OFF
AFpauselook	    		= 0 ; OFF
AFdebugwipe	    		= 0 ; OFF
AFdebugcpuspeed  		= 0 ; OFF
AFdebugpselect   		= 0 ; OFF
AFmapanimeobj    		= 0 ; OFF
AFdebugset_score 		= 0 ; OFF
AFdebugmode_mapmessageON	= 0 ; OFF
AFdebugmpde_trigmessageON	= 0 ; OFF
AFrammessage_debug 		= 0 ; OFF
AFrammessage_debuggameover	= 0 ; OFF
;----------------------------------------------------------------------
	endc
;----------------------------------------------------------------------
;
;
;
;
;
;
;=====================================================================
;=====================================================================
;===========	labels ==================================================
;===========	labels ==================================================
;=====================================================================
;=====================================================================



;*********************************************************************
;	player select label
;*********************************************************************

xfriend_fox		equ	0
xfriend_falco	equ	1
xfriend_peppy	equ	2
xfriend_slippy	equ	3
xfriend_cat		equ	4
xfriend_girl		equ	5

;*********************************************************************
;	message label
;*********************************************************************

message_kinkyujitai	equ	31

mapmessage_blackcolor 	equ	0
mapmessage_bluecolor	 	equ	1 
mapmessage_redcolor   	equ	2
mapmessage_gameovercolor	equ	3
mapmessage_enemycolor	equ	4
mapmessage_enemycolor2	equ	5
mapmessage_enemycolor3	equ	6
mapmessage_wolfcolor		equ	7


mapmessage_limitHP_1		equ	15	; 85% -- 100%
mapmessage_limitHP_2		equ	40	; 60% -- 100%


;=====================================================================
;=====================================================================
;===========	TIMMING DATAS ===========================================
;===========	TIMMING DATAS ===========================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	player select
;*********************************************************************
;
; wipeopen shite keymati made no timming
;
;---------------------------------------------------------------------

tmpsel_opentotal	equ	50

;---------------------------------------------------------------------
;
; (A)key wo oshitekara wipeend made no timming
;
;---------------------------------------------------------------------

tmpsel_okwait	equ	70+32
oam_okwait2		equ	30

tmpsel_wipebefore1	equ	tmpsel_okwait
tmpsel_wipebefore2	equ	70

tmpsel_closetotal	equ	30+tmpsel_okwait+tmpsel_wipebefore2

;*********************************************************************
;	mission explain
;*********************************************************************
;
; (A)key wo oshitekara wipeend made no timming
;
;---------------------------------------------------------------------

tmexp_closetotal	equ	44
;;tmexp_closetotal	equ	33	; raster off time

tmexp_okpose		equ	22

tmexp_okwait		equ	20+10	;
tmexp_polyoff	equ	1	; <<polygonscreen>> off after wait


;*********************************************************************
;	obj animation data
;*********************************************************************

oam_okwait1		equ	10

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
;=====================================================================
;=====================================================================
;===========	stepup demo =============================================
;===========	stepup demo =============================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	object macro
;*********************************************************************


;-----------------------------------------

stepup_workcount	equ	8
stepup_worktotal	equ	8

;-----------------------------------------

_stepup_flag		equ	0
_stepup_posx		equ	2
_stepup_posy		equ	4
_stepup_anime	equ	6

;-----------------------------------------


;=====================================================================
;=====================================================================
;===========	object macros ===========================================
;===========	object macros ===========================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	object macro
;*********************************************************************

;---------------------------------------------------------------------

MDmaVram	macro	[vramstep,vramaddr,code,Baddress,Aaddress,bytecount]
	jsr	DmaVram
	db	{vramstep}
	dw	{vramaddr}
	db	{code}
	db	({Baddress})&0ffh
	dl	{Aaddress}
	dw	{bytecount}
	endm

;---------------------------------------------------------------------

M2dOBJdata	macro
	db	1		; program code
	dw	\1&0ffffh	; program address
	db	\2		; animation SEQ number
	dw	\3		; position X
	dw	\4		; position Y
	dw	\5		; speed X
	dw	\6		; speed Y
	db	\7
	endm

;---------------------------------------------------------------------

Mdataend	macro
	db	0
	endm

;---------------------------------------------------------------------

Mmessage 	macro			; OBJ display message
	ldx	#(\2)*256+\1
	jsr	OBJ_print
	endm

;---------------------------------------------------------------------

Mdispdigit 	macro			; OBJ display digit
	ldy	#(\2)*256+\1
	jsr	OBJ_digit
	endm	

;---------------------------------------------------------------------

Mobjinit	macro	[index,anime,program,px,py]
	jsr	Keep_objlist
	db	{index}
	db	{anime}
	dw	{program}&0ffffh
	db	{px}
	db	{py}
	endm

;---------------------------------------------------------------------

Mobjchange	macro	[index,anime,program]
	ldy	#{index}*2
	ldx	objindex_table,y	; x = register
	lda	#{anime}
	sta	_anime_trigger,x
	lda	#{program}&WM
	sta	_program,x
	endm

;---------------------------------------------------------------------

Mobjmoveinit	macro	[index,anime,program,px,py,vx,vy]
	jsr	Keep_objlist
	db	{index}
	db	{anime}
	dw	{program}&0ffffh
	db	({px})&00ffh
	db	({py})&00ffh
	lda	#{px}
	sta	_axisX,x
	lda	#{py}
	sta	_axisY,x
	lda	#{vx}
	sta	_velocityX,x
	lda	#{vy}
	sta	_velocityY,x
	endm

;---------------------------------------------------------------------

Mobjindex	macro	[index]
	ldy	#{index}*2
	ldx	objindex_table,y	; x = register
	endm

;---------------------------------------------------------------------

Mobjkill	macro	[index]
	ldy	#{index}*2
	ldx	objindex_table,y
	jsr	Kill_objlist
	endm

;---------------------------------------------------------------------
;
; Areg = trigger number
;
;----------------------------------------------

Mobjanime	macro	[index]		
	ldy	#{index}*2
	ldx	objindex_table,y	; x = register
	sta	_anime_trigger,x
	endm

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
;*******************************************************************
;	calclration macro 1 ( add )
;*******************************************************************
;
; position = position + speed
;
; <in/out> ai16
; dead A,Y
;
; DBR = rombank or 7e
;
;	position S******* ********.******** 00000000
;	speed	          S*******.********
;
;-------------------------------------------------------------------

Mposadd	macro	[pos,speed]
	ldy	#0
	clc
	lda	{speed},x
	bpl	.\@p1
	dey
.\@p1	adc	{pos}+1,x
	sta	{pos}+1,x
	a8
	tya
	adc	{pos}+3,x
	sta	{pos}+3,x
	a16
	endm

;-------------------------------------------------------------------
;
; speed = speed + #accel
;
;	speed	S*******.********
;	accel	S*******.********
;
;-------------------------------------------------------------------

Mspeedadd	macro	[speed,accel]
	clc
	lda	{speed},x
	adc	#{accel}
	sta	{speed},x
	endm

;-------------------------------------------------------------------
;
; position limit
;
;-------------------------------------------------------------------

Mposbound	macro	[pos,limit,speed]
	lda	#{limit}
	cmp	{pos}+2,x
	bmi	.\@p1
	sta	{pos}+2,x	; position limit
	stz	{pos}+0,x

	lda	{speed},x	; speed bound
	Mnegative
	Mdivasr			; 1/2 speed
	Mdivasr			; 1/2 speed
	Mdivasr			; 1/2 speed
	sta	{speed},x

.\@p1
	endm

;-------------------------------------------------------------------
;
; position initialize
;
;-------------------------------------------------------------------

Mposinit	macro	[index,pos,initdata]
	lda	#{initdata}
	s_sta	{pos}+2,{index}	; set initial position
	lda	#0
	s_sta	{pos},{index}
	endm

;-------------------------------------------------------------------
;
; speed initialize
;
;-------------------------------------------------------------------

Mspeedinit	macro	[index,speed,initspeed]
	lda	#{initspeed}
	s_sta	{speed},{index}	; set initial speed
	endm
	

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
;=====================================================================
;=====================================================================
;===========	DEMO/WIPE Strcucture ====================================
;===========	DEMO/WIPE Strcucture ====================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	DEMO Structure	( total 16bytes )
;*********************************************************************
;
_dcinput	equ	0	; input trigger
_dcselect	equ	2	; pattern
_dcprocess	equ	4	; SEQ
_dctimer	equ	6	; dec time
_dccounter	equ	8	; inc time
_dcflag	equ	10	; exit flag
;---------------------------------------------------------------------
_dcwork	equ	12	; dcwork-0
;;;	equ	14	; dcwork-1
;;;	equ	16	; dcwork-2
;;;	equ	18	; dcwork-3
;---------------------------------------------------------------------


;*********************************************************************
;	dc macros
;*********************************************************************
;----------------------------------------------------

dwstart	macro
	db	80h
	dw	bank11_rts&0ffffh
	endm

;----------------------------------------------------

dwnext	macro	[address]
	db	80h
	dw	{address}&0ffffh
	endm

;----------------------------------------------------

dwstop	macro	[address]
	db	81h
	dw	{address}&0ffffh
	endm

;----------------------------------------------------

dwflag	macro	[address]
	db	82h
	dw	{address}&0ffffh
	endm

;----------------------------------------------------

dwwait	macro	[time]
	db	{time}
	dw	bank11_rts&0ffffh
	endm

;----------------------------------------------------

dwloop	macro	[code,address]
	db	{code}
	dw	{address}&0ffffh
	endm

;----------------------------------------------------

dwend	macro
	db	0
	endm

;---------------------------------------------------


;=====================================================================
;=====================================================================
;===========	2D objecy Strcucture ====================================
;===========	2D objecy Strcucture ====================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	2D OBJECT Structure
;			total 50 byte ( *4 )
;*********************************************************************

_backward		equ	0	;
_forward		equ	2	;
_program		equ	4	; JSR (program code )
				; Low
				; High
_positionX		equ	8
_axisX		equ	10
_positionY		equ	12
_axisY		equ	14
_velocityX		equ	16
_velocityY		equ	18

; <<<<< animation >>>>> ----------------------------------------------

_anime_trigger	equ	20	; INPUT animation number 
_anime_pointer	equ	22	; animation program counter
_anime_counter	equ	24	; animation time counter
_obj_pointer		equ	26	; objblock pointer
_charadd		equ	28	; 2byte
_OBJaddress		equ	30	; objblock 
_objlimit		equ	32	; setcount limit

;=====================================================================
;=====================================================================
;===========	WIPE MACROS =============================================
;===========	WIPE MACROS =============================================
;=====================================================================
;=====================================================================
;*******************************************************************
;	WIPE MACROS
;*******************************************************************

;-------------------------------------------------------------------

MsetAX	macro   
	lda	#\2
	sta	\1,x
	endm

;-------------------------------------------------------------------

MsetAX3	macro
	lda	#\2&00ffh
	sta	\1+0,x
	lda	#\2>>8&00ffh
	sta	\1+1,x
	lda	#\2>>16
	sta	\1+2,x
	endm

;-------------------------------------------------------------------







;=====================================================================
;=====================================================================
;===========	LABELS ==================================================
;===========	LABELS ==================================================
;=====================================================================
;=====================================================================

;*********************************************************************
;	work RAM label
;*********************************************************************


marioRAM	equ	700000h
bank7eRAM	equ	7e0000h
bank7fRAM	equ	7f0000h


;*********************************************************************
;	CPU/PPU registers
;*********************************************************************


;---------------------------------------------------------------------
; PPU register alias
;---------------------------------------------------------------------

;---------------------------------------------------------------------- 
PPU_control		equ	2100h
Through_screen	equ	212ch
;---------------------------------------------------------------------- 
Color_address	equ	2121h		;8bits
Color_write		equ	2122h		;11bits duplicate 
Color_read		equ	213bh		;11bits duplicate 
Color_control	equ	2130h		;----..** 
Color_brend		equ	2131h		;SH****** 
Color_bias		equ	2132h		;BGR***** 
;---------------------------------------------------------------------- 
Sprite_size		equ	2101h		;***----- 
Sprite_address	equ	2102h		;9bits
Sprite_write		equ	2104h		;8bits or 16bits duplicate
Sprite_read		equ	2138h		;8bits or 16bits duplicate
;---------------------------------------------------------------------- 
Through_window	equ	212eh
Window_control	equ	2123h		;6digits
Window_range		equ	2126h		;4bytes 
Window_logic		equ	212ah		;6*2bits
Window_switch	equ	2132h		;****..-- 
;---------------------------------------------------------------------- 
Screen_size		equ	2105h		;SSSS.--- 
Screen_mode		equ	2105h		;----.MMM 
Screen_mosaic	equ	2106h
Mode7_flip		equ	211ah		;***
Screen_bank		equ	2107h		;4bytes 
Character_bank	equ	210bh		;4digits
Screen_step		equ	2115h
Screen_address	equ	2116h
Screen_write		equ	2118h
;---------------------------------------------------------------------- 
Scroll_BG1H		equ	210dh
Scroll_BG1V		equ	210eh
Scroll_BG2H		equ	210fh
Scroll_BG2V		equ	2110h
Scroll_BG3H		equ	2111h
Scroll_BG3V		equ	2112h
Scroll_BG4H		equ	2113h
Scroll_BG4V		equ	2114h
Scroll_		equ	210dh
Scroll_H		equ	210dh		;4plane step2 10bits duplicate
Scroll_V		equ	210eh		;4plane step2 10bits duplicate
;---------------------------------------------------------------------- 
Rotation_A		equ	211bh
Rotation_B		equ	211ch
Rotation_C		equ	211dh
Rotation_D		equ	211eh
Rotation_X		equ	211fh
Rotation_Y		equ	2120h
;---------------------------------------------------------------------- 

;---------------------------------------------------------------------
; CPU register alias
;---------------------------------------------------------------------

;----------------------------------------------------------------------
NMI_control		equ	4200h		;1--**--* 
NMI_status		equ	4210h		;1------- 
Blank_status		equ	4212h		;11-----* 
;---------------------------------------------------------------------- 
Timer_H		equ	4207h		;9bits
Timer_V		equ	4209h		;9bits
Timer_trigger	equ	4200h		;*-11---* 
IRQ_status		equ	4211h		;1------- 
Timer_status		equ	4211h		;1------- 
;---------------------------------------------------------------------- 
XMultiplicand	equ	4202h		;unsigned 8bits
XMultiplier		equ	4203h		;unsigned 8bits
XProduct		equ	4216h		;unsigned 16bits
XDividend		equ	4204h		;unsigned 16bits
XDivisor		equ	4206h		;unsigned 8bits 
XQuotient		equ	4214h		;unsigned 16bits
XResidue		equ	4216h		;unsigned 16bits
;---------------------------------------------------------------------- 
DMA_burst		equ	420bh
DMA_syncro		equ	420ch
DMA_0		equ	4300h
;---------------------------------------------------------------------- 
DMA_control		equ	0
DMA_register		equ	1		;8bits 021XXH 
DMA_address		equ	2		;24bits 
DMA_count		equ	5		;16bits 
DMA_databank		equ	7		;24bits 
DMA_table		equ	8
DMA_line		equ	10 
;---------------------------------------------------------------------- 



;*********************************************************************
;	Key
;*********************************************************************

button_B		equ	8000h
button_Y		equ	4000h
button_select	equ	2000h
button_start		equ	1000h
button_up		equ	0800h
button_down		equ	0400h
button_left		equ	0200h
button_right		equ	0100h

button_A		equ	0080h
button_X		equ	0040h
button_L		equ	0020h
button_R		equ	0010h

button_ok		equ	button_B+button_start
button_cancel	equ	button_X+button_Y
button_Any		equ	button_B+button_Y+button_A+button_X

button_anyall	equ	0fff0h
button_messageok	equ	button_B+button_up+button_down+button_left+button_right
button_jyuujikey	equ	button_up+button_down+button_left+button_right

;*********************************************************************
;	OBJ palette
;*********************************************************************


oamdata_pri0		equ	00h
oamdata_pri1		equ	10h
oamdata_pri2		equ	20h
oamdata_pri3		equ	30h

oamdata_attr0	equ	0
oamdata_attr1	equ	2
oamdata_attr2	equ	4
oamdata_attr3	equ	6
oamdata_attr4	equ	8
oamdata_attr5	equ	10
oamdata_attr6	equ	12
oamdata_attr7	equ	14

oamdata_hvflip	equ	0c0h
oamdata_hflip	equ	40h
oamdata_vflip	equ	80h
oamdata_nflip	equ	00h

;*********************************************************************
;	message color ( POLYGON 16-COLOR )
;*********************************************************************


messagecolor_red	equ	02h
messagecolor_blue	equ	06h
messagecolor_black	equ	09h
messagecolor_white	equ	0eh
messagecolor_green	equ	0fh
messagecolor_frash	equ	80h

;*********************************************************************
;	OAMDATA labels
;*********************************************************************

nomal		equ	0
hflip		equ	40h
vflip		equ	80h
hvflip		equ	hflip+vflip
attr0		equ	00h
attr1		equ	02h
attr2		equ	04h
attr3		equ	06h
attr4		equ	08h
attr5		equ	0ah
attr6		equ	0ch
attr7		equ	0eh

obj_p0		equ	0000h
obj_p1		equ	0200h
obj_p2		equ	0400h
obj_p3		equ	0600h
obj_p4		equ	0800h
obj_p5		equ	0a00h
obj_p6		equ	0c00h
obj_p7		equ	0e00h

;*********************************************************************
;	Alpha
;*********************************************************************

_a		equ	0ah
_b		equ	0bh
_c		equ	0ch
_d		equ	0dh
_e		equ	0eh
_f		equ	0fh
_g		equ	10h
_h		equ	11h
_i		equ	12h
_j		equ	13h
_k		equ	14h
_l		equ	15h
_m		equ	16h
_n		equ	17h
_o		equ	18h
_p		equ	19h
_q		equ	1ah
_r		equ	1bh
_s		equ	1ch
_t		equ	1dh
_u		equ	1eh
_v		equ	1fh
_w		equ	20h
_x		equ	21h
_y		equ	22h
_z		equ	23h

ed		equ	0ffh


_za		equ	41h
_zb		equ	42h
_zc		equ	43h
_zd		equ	44h
_ze		equ	45h
_zf		equ	46h
_zg		equ	47h
_zh		equ	48h
_zi		equ	49h
_zj		equ	4ah
_zk		equ	4bh
_zl		equ	4ch
_zm		equ	4dh
_zn		equ	4eh
_zo		equ	4fh
_zp		equ	50h
_zq		equ	51h
_zr		equ	52h
_zs		equ	53h
_zt		equ	54h
_zu		equ	55h
_zv		equ	56h
_zw		equ	57h
_zx		equ	58h
_zy		equ	59h
_zz		equ	5ah


;--------------------------------------------
;	test
;--------------------------------------------
;amloop	macro	[count,address]
;.\@p1	db	87h			; code
;	db	{count}			; loop counter
;	db	(.\@p1-{address})	; loop address
;	endm
;--------------------------------------------
;.test
;	db	0
;	db	0
;	amloop	4,.test
;--------------------------------------------



;=====================================================================
;=====================================================================
;===========	YAJIMA MACROS ===========================================
;===========	YAJIMA MACROS ===========================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	vram draw macros
;*********************************************************************

Mvramclear_soft	macro	[vramaddr,vramcount,clearchar]
	jsr	Clearvram_soft
	dw	{vramaddr}
	dw	{vramcount}
	dw	{clearchar}
	endm

;*********************************************************************
;	key check macros
;*********************************************************************

Mkeycheck	macro	[keyaddr,keydata]
	lda	{keyaddr}
	and	#{keydata}
	endm

;*********************************************************************
;	key debug macros
;*********************************************************************

;--------------------------------------------------------------------
Mpsel_keymove	macro	[key1,key2,addr,max]

	ldy	{addr}
	lda	trig0
	clc				; <= SOUND FLAG OFF
	and	#button_{key1}+button_{key2}+button_select
	beq	.exit\@
	and	#button_{key2}+button_select
	beq	.skip\@
	iny
	cpy	#{max}
	bcc	.set\@
	ldy	#0
	bra	.set\@
.skip\@	dey
	bpl	.set\@
	ldy	#{max}-1
.set\@	sty	{addr}
	sec				; <= SOUND FLAG ON
.exit\@
	endm



;--------------------------------------------------------------------

Mdebugkeycheck macro [keyaddr,keydata]
	lda	{keyaddr}
	and	#{keydata}
	endm

;--------------------------------------------------------------------

Mdebugsecretcheck macro [keyNO,buttondata,triggerdata,jump]
	lda	cont{keyNO}
	and	#{buttondata}
	cmp	#{buttondata}
	bne	{jump}
	lda	trig{keyNO}
	and	#{triggerdata}
	beq	{jump}
	endm

;--------------------------------------------------------------------

Mdebugkeymove macro	[address,add,keyaddr,key1,key2,key3]

	lda.l	{keyaddr}
	bit	#button_{key1}+button_{key2}
	beq	.\@p2
	ldy	#{add}
	bit	#button_{key3}
	beq	.\@p0

	ldy	#{add}*8	; *8 speed 
.\@p0	bit	#button_{key1}
	bne	.\@p1
	tya
	Mnegative
	tay

.\@p1	tya
	clc
	adc.l	{address}
	sta.l	{address}

.\@p2
	endm

;---------------------------------------------------------------------

Mdebugcolor	macro	
	a8
	lda	#1
	sta	Color_Address
	lda	#0
	sta	Color_Write
	lda	#0
	sta	Color_Write
	lda	#0ffh
	sta	Color_Write
	lda	#0ffh
	sta	Color_Write
	lda	#0ffh
	sta	Color_Write
	lda	#0ffh
	sta	Color_Write
	a16
	endm

;---------------------------------------------------------------------

Mkeytrigger	macro	[key]
	lda	trig0
	and	#button_{key}
	endm

;---------------------------------------------------------------------
Mkeybutton	macro	[key]
	lda	cont0
	and	#button_{key}
	endm

;---------------------------------------------------------------------
Mobj_printpos macro	[h,v]
	lda	#({v})*256+{h}
	sta	debug_printpos
	endm

;---------------------------------------------------------------------
Mobj_printh	macro	
	ldy	debug_printpos
	phy		  	; >>
	jsr	OBJprintW	; print word
	pla		  	; <<
	clc
	adc	#0800h
	sta	debug_printpos
	endm

;---------------------------------------------------------------------
Mobj_printd	macro	
	ldy	debug_printpos
	phy			; >>
	jsr	OBJprintW	; print word	
	pla			; <<
	clc
	adc	#0800h
	sta	debug_printpos
	endm

;---------------------------------------------------------------------
Mdebug_cpuspeed macro	[key,color]	
	lda	cont0
	and	#button_{key}
	beq	.\@p1
	a8
	lda	#{color}
	sta	PPU_control
	a16
.\@p1
	endm

;---------------------------------------------------------------------


;====================================================================
;====================================================================
;END END END END END END END END END END END END END END END END END 
;====================================================================
;====================================================================
