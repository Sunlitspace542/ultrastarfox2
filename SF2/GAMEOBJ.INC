;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: gameobj.inc				*
;* 	Description	: Game Object OAM DATA			*
;*	Date		: 1994.7.15				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
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
;********************************************************************
;	labels
;********************************************************************

readyobj_H	equ	80h
readyobj_V	equ	80h

;--------------------------------------------------------------------


;====================================================================
;====================================================================
;============ move data =============================================
;============ move data =============================================
;====================================================================
;====================================================================
;********************************************************************
;;	move macros
;********************************************************************

;--------------------------------------------------------------------

Mgsposset	macro	[posX,posY]
	db	0
	db	{posX},{posY}
	endm

;--------------------------------------------------------------------

Mgsstop	macro
	db	1
	endm

;--------------------------------------------------------------------

Mgsspeedset	macro	[speedX,speedY]
	db	2
	dw	{speedX},{speedY}
	endm

;--------------------------------------------------------------------

Mgsobjset	macro	
	db	3
	dw	\1&xx
	endm

;--------------------------------------------------------------------

Mgstimeset	macro	[time]
	db	4
	db	({time})-1
	endm

;--------------------------------------------------------------------

Mgsspeedstop	macro
	db	5
	endm

;--------------------------------------------------------------------

Mgsjmp	macro	[addr]
	db	6
	dw	{addr}&xx
	endm

;--------------------------------------------------------------------

;********************************************************************
;;	game object
;********************************************************************
;
; p_ready_r
; p_ready_e
; p_ready_a
; p_ready_d
; p_ready_y
;
; p_start_s
; p_start_t
; p_start_a
; p_start_r
; p_start_t2
;
;
;
;
;
;
;--------------------------------------------------------------------


p_ready_r	Mgsobjset	s_ready_r
	Mgsposset	readyobj_H,readyobj_V

.loop	Mgsspeedset	-800h,0000h
	Mgstimeset	6
	Mgsspeedstop
	Mgstimeset	30
	Mgsspeedset	 800h,0000h
	Mgstimeset	6
	Mgsspeedstop
	Mgstimeset	10
	Mgsjmp		.loop

;--------------------------------------------------------------------

p_ready_e	Mgsobjset	s_ready_e
	Mgsposset	readyobj_H,readyobj_V

.loop	Mgsspeedset	-400h,0000h
	Mgstimeset	6
	Mgsspeedstop
	Mgstimeset	30
	Mgsspeedset	 400h,0000h
	Mgstimeset	6
	Mgsspeedstop
	Mgstimeset	10
	Mgsjmp		.loop

;--------------------------------------------------------------------

p_ready_a	Mgsobjset	s_ready_a
	Mgsposset	readyobj_H,readyobj_V
	Mgsstop

;--------------------------------------------------------------------

p_ready_d	Mgsobjset	s_ready_d
	Mgsposset	readyobj_H,readyobj_V

.loop	Mgsspeedset	400h,0000h
	Mgstimeset	6
	Mgsspeedstop
	Mgstimeset	30
	Mgsspeedset	-400h,0000h
	Mgstimeset	6
	Mgsspeedstop
	Mgstimeset	10
	Mgsjmp		.loop


;--------------------------------------------------------------------

p_ready_y	Mgsobjset	s_ready_y
	Mgsposset	readyobj_H,readyobj_V

.loop	Mgsspeedset	800h,0000h
	Mgstimeset	6
	Mgsspeedstop
	Mgstimeset	30
	Mgsspeedset	-800h,0000h
	Mgstimeset	6
	Mgsspeedstop
	Mgstimeset	10
	Mgsjmp		.loop


;--------------------------------------------------------------------



























;=====================================================================
;=====================================================================
;============ object data ============================================
;============ object data ============================================
;=====================================================================
;=====================================================================
;*********************************************************************
;	dataset macros
;*********************************************************************

Mmesobj	macro
	db	\1+40h
	db	\2+\3+30h
	endm

;--------------------------------------------------------------------

Mmesobj_str	macro	
	dw	\1&xx
	dw	\2&xx
	endm

;*********************************************************************
;	READY DATA
;*********************************************************************

s_ready_r	Mmesobj_str	obj_message_p1,obj_ready_r
s_ready_e	Mmesobj_str	obj_message_p1,obj_ready_e
s_ready_a	Mmesobj_str	obj_message_p1,obj_ready_a
s_ready_d	Mmesobj_str	obj_message_p1,obj_ready_d
s_ready_y	Mmesobj_str	obj_message_p1,obj_ready_y

s_start_s	Mmesobj_str	obj_message_p1,obj_start_s
s_start_t	Mmesobj_str	obj_message_p1,obj_start_t
s_start_a	Mmesobj_str	obj_message_p1,obj_start_a
s_start_r	Mmesobj_str	obj_message_p1,obj_start_r

;--------------------------------------------------------------------

obj_message_p1
	db 4	  ; counter
	db -8,-8  ; position H,V
	db 0,-8
	db -8,0
	db 0,0

;--------------------------------------------------------------------

obj_ready_r
	Mmesobj	70h,nomal,attr0		; ready
	Mmesobj	60h,hflip,attr0		; 
	Mmesobj	73h,nomal,attr1
	Mmesobj	74h,nomal,attr1
obj_ready_e	
	Mmesobj	70h,nomal,attr0
	Mmesobj	71h,nomal,attr0
	Mmesobj	70h,vflip,attr1
	Mmesobj	71h,vflip,attr1
obj_ready_a
	Mmesobj	63h,nomal,attr0	
	Mmesobj	63h,hflip,attr0
	Mmesobj	73h,nomal,attr1
	Mmesobj	73h,hflip,attr1
obj_ready_d
	Mmesobj	76h,vflip,attr0
	Mmesobj	64h,hflip,attr0
	Mmesobj	76h,nomal,attr1
	Mmesobj	64h,hvflip,attr1
obj_ready_y
	Mmesobj	75h,nomal,attr0
	Mmesobj	75h,hflip,attr0
	Mmesobj	72h,nomal,attr1
	Mmesobj	72h,hflip,attr1

;--------------------------------------------------------------------

;*********************************************************************
;	START DATA
;*********************************************************************

obj_start_s
	messet	60h,nomal,attr0		; start
	messet	61h,nomal,attr0
	messet	61h,hvflip,attr1
	messet	60h,hvflip,attr1
obj_start_t
	messet	62h,nomal,attr0
	messet	62h,hflip,attr0
	messet	72h,nomal,attr1
	messet	72h,hflip,attr1
obj_start_a
	messet	63h,nomal,attr0
	messet	63h,hflip,attr0
	messet	73h,nomal,attr1
	messet	73h,hflip,attr1
obj_start_r
	messet	70h,nomal,attr0
	messet	60h,hflip,attr0
	messet	73h,nomal,attr1
	messet	74h,nomal,attr1

;--------------------------------------------------------------------

