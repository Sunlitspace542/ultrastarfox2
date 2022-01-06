;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: mapanime.asm				*
;* 	Description	: mission map				*
;*			; object animation program		*
;*	Date		: 1994.10.13				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
nextobj_position3g	equ	0ceah	; !!! LOOK!! yjmap.asm
nextobj_position2g	equ	06eah	; 
;
;---------------------------------------------------------------------
;
;
;
;
;--------------------------------------------------------------------
	include	yajima.inc
;--------------------------------------------------------------------
;
;********************************************************************
;	<<<<< README >>>>>>
;********************************************************************
;;;
;;;
;;; kawaguchi used --------------------------------------------------
;;;
;;;	mapanime_set		map-main (objanimation)
;;;	set_kawaobj		sprite program
;;;
;;; kawaguchi called ------------------------------------------------
;;;
;;;	mappause_objset		mappause no toki ni call 
;;;	corneria_HPmeter	disp HPmeter
;;;	yajirushi_animation	map-explain yajirushi anime
;;;				disp yajirushi
;;;	corneria_crash		map-crash objectset
;;;
;;; mapanime library ------------------------------------------------
;;;
;;;	set_blockobj		obj blockset
;;;
;;;

;********************************************************************
;	WORK LABEL
;********************************************************************
;-----------------------------------------------
; zero page RAM
;-----------------------------------------------

obj_temp		equ	Xwork0
obj_counter		equ	Xwork1
obj_ROMpointer	equ	Xwork2
obj_blockpointer	equ	Xwork3
obj_animecount	equ	Xwork4
obj_subdata		equ	Xwork5
obj_attrdata		equ	Xwork6
obj_charcheck	equ	Xwork7


;********************************************************************
;	LOCAL macros
;********************************************************************
;-----------------------------------------------
;	pausemap RAM pointer
;-----------------------------------------------
Mpausemap_rampointer	macro	[RAMaddr]
	lda	#({RAMaddr})>>8
	sta	Xaddr+1
	lda.l	{RAMaddr}
	sta	Xaddr+0
	endm

;-----------------------------------------------
; 	OAM SUB set loop
;-----------------------------------------------
mapanime_oamsub	macro
	lda	oam_pointer	; calc SUB address
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	a8
.\@p1	lda	obj_subdata
	sta.l	sprites+200h,x	; Set OAM-SUB
	iny
	inx
	dec	obj_temp	
	bpl	.\@p1
	a16
	endm

;-----------------------------------------------
; 	OAM MAIN countset
;-----------------------------------------------
mapanime_oamcount	macro
	lda.l	ROMobjchart+0,x	; <Y> position
	and	#00ffh
	sta	obj_counter
	inx
	endm

;-----------------------------------------------
;
;
;
;
;
;
;
;
;
;####################################################################
;####################################################################
;	
;------------ PROGRAM ENTRY (MAIN)-----------------------------------
;
;####################################################################
;####################################################################
;********************************************************************
;	----------------
;	 map pause main 
;	----------------
;********************************************************************

mappause_objset
	rts


;********************************************************************
;	--------------------------
; 	 Demo YAJIRUSHI animation
;	--------------------------
;********************************************************************
;
; kawaguchi no program kara call sareru !!!
;
; mode = ai16 
; DBR  = 7eh
;
; Y .... object pointer
;
;--------------------------------------------------------------------

yajirushi_animation

	php
	phx
	sty	oam_pointer
	ai16

;;;;;;;;	jsr	test_animation		  ; debug program
	jsr	set_yajirushiobj	  ; yajirushi object
	jsr	face_animation		  ; face open/close animation
	jsr	message_nextobj		  ; message nextset object
	jsr	set_enemyplanet_yajirushi ; enemyplanet yajirushi

	ldy	oam_pointer
	plx
	plp
	rts

;***********************************************************************
;	------------------------
;	 CORNERIA CRASH PROGRAM
;	------------------------
;***********************************************************************
;
; kawaguchi no program kara call sareru !!!
;
; mode = ai16 
; DBR  = 7eh
;
; Y .... object pointer
;
;--------------------------------------------------------------------

corneria_crash

	php			;>
	phx			; >>
	sty	oam_pointer	;   >>

	ai16

;;;;;	stz	map_corneriacrash_offset
;;;;;	inc	map_corneriacrash_anime

	phx

	lda	map_corneriacrash_anime
	clc
	adc	map_corneriacrash_offset
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	and	#07h
	asl	a
	tax

	lda	map_corneriacrash_posX
	clc
	adc.l	.xoffset,x
	sta	oam_centerX			; set px
	lda	map_corneriacrash_posY
	clc
	adc.l	.yoffset,x
	sta	oam_centerY			; set py

	plx

	lda	map_corneriacrash_anime
	clc
	adc	map_corneriacrash_offset
	and	#1fh
	sta	oam_tcount

	Mset	oam_animeNo,cd_objanime_crash	; set char
	jsr	Set_blockobj


	lda	#75
	clc
	adc	map_corneriacrash_offset
	sta	map_corneriacrash_offset


	ldy	oam_pointer	;   <<
	plx			; <<
	plp			;<
	rts

.xoffset	dw	0,4,1,-3,-4,2,-2,1
.yoffset	dw	0,3,-3,2,-2,3,1,-4


;********************************************************************
;			****************************************
;			****************************************
; enmeyplanet animation	****************************************
;			****************************************
;			****************************************
;********************************************************************

enemyplanet	php
	phx
	sty	oam_pointer

	ai16
	jsr	call_enemyplanet

	ldy	oam_pointer
	plx
	plp
	rts

call_enemyplanet

	lda	enemyplanet_animecount
	inc	a
	and	#001fh
	sta	enemyplanet_animecount

	ldx	kx_planetlistptr	; X= planet pointer
	beq	.exit

.loop	
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,x
	beq	.next

	lda.w	mmx_planetcx,x		; << Set Position >>
	and	#00ffh
	sta	oam_centerX		; Xposition
	lda.w	mmx_planetcy,x
	and	#00ffh
	sta	oam_centerY		; Yposition

	lda.w	mmx_dokuroanm,x
	beq	.next
	bmi	.over
	inc	a
	cmp	#34
	bcc	.skip
	lda	#7fffh
	bra	.over
.skip	sta.w	mmx_dokuroanm,x
	sta	oam_tcount

	phx
	Mset	oam_animeNo,cd_objanime_enemyplanetstart
	jsr	Set_blockobj
	plx

.next	lda.w	mmx_planetnext,x
	tax
	bne	.loop


.exit	rts


;-------------------------------------------
;; normal loop
;-------------------------------------------

.over	inc	a
	and	#801fh
	sta.w	mmx_dokuroanm,x
	and	#001fh
	sta	oam_tcount

	phx
	Mset	oam_animeNo,cd_objanime_enemyplanet
	jsr	Set_1sprite
	plx

	bra	.next


;====================================================================
;====================================================================
;====================================================================
;
;
;
;
;
;####################################################################
;####################################################################
;	
;------------ PROGRAM ENTRY (SUB)------------------------------------
;
;####################################################################
;####################################################################
;********************************************************************
;	yajirushi object
;********************************************************************

set_yajirushiobj

	lda	mapexp_objNo	; Set Animation Number 
	beq	.exit
	sta	oam_animeNo

	lda	mapexp_objcount	; Set Animation Timer
	inc	a
	sta	mapexp_objcount
	and	#000fh
	sta	oam_tcount

	lda	mapexp_objpos	; Set Animation X/Y Position
	jsr	set_objentry

.exit	
	rts



;***********************************************************************
;	all planet yajirushi set program
;***********************************************************************

setenemyyaji
	PHX	; >>

	ldy	#cd_objanime_yajirushi_up
	a8
	lda.w	mmx_enposy+1,x
	cmp	#60h
	bcc	.skip
	ldy	#cd_objanime_yajirushi_dw
.skip	xba
	lda.w	mmx_enposx+1,x
	a16
	sty	oam_animeNo
	jsr	set_objentry		; Aregister position

	PLX	; <<
	rts

;======================================= zako yajirushi !! =======
zakomiss_yajirushi
	ldx	kx_enlistptr
.loop	km_bitcheckflag16.w	mmx_enflags,(enfl_missile),x
	beq	.next
	jsr	setenemyyaji
.next	lda.w	mmx_ennext,x
	tax
	bne	.loop
.exit	rts

;======================================= zako yajirushi !! =======
zakosos_yajirushi
	ldx	kx_enlistptr
	beq	.exit
.loop	km_bitcheckflag16.w	mmx_enflags,(enfl_wolf!enfl_finalboss!enfl_missile!enfl_satellite!enfl_mothership!enfl_itemplanet),x
	bne	.next

	jsr	setenemyyaji

.next	lda.w	mmx_ennext,x
	tax
	bne	.loop
.exit	rts

;======================================= enemy yajirushi !! =======
set_enemyplanet_yajirushi

	ldx	yajirushi_flag
	beq	.exit
	Manime	yajirushi_anime,10h
	sta	oam_tcount		; anime time count
	cpx	#ON_zakoyaji
	beq	zakosos_yajirushi
	cpx	#ON_missyaji
	beq	zakomiss_yajirushi
;---------------------------------------------------
	ldx	kx_planetlistptr
	beq	.exit
.loop	
	lda.w	mmx_planetflag,x
	bit	#mmpnf_corneria
	bne	.next
	bit	#mmpnf_planet		; 1 = neutoral planet	
	beq	.next
	bit	#mmpnf_senryou
	beq	.next


	phx				; <<
	jsr	set_enemy_yajirushi
	plx				; >>

;---------------------------------------------------
.next	lda.w	mmx_planetnext,x
	tax
	bne	.loop

;---------------------------------------------------
.exit	rts
















;---------------------------------------------------







;---------------------------------------------------
; display yajirushi
;---------------------------------------------------
set_enemy_yajirushi

	ldy	#cd_objanime_yajirushi_up
	a8
	lda.w	mmx_planetcy,x		 ; sprite position
	cmp	#60h
	bcc	.skip
	ldy	#cd_objanime_yajirushi_dw
.skip	xba
	lda.w	mmx_planetcx,x		 ; sprite position
	a16
	sty	oam_animeNo

	jsr	set_objentry		; Aregister position

	rts

;--------------------------------------------------------------------
;;
;;
;;
;;
;;
;********************************************************************
;			****************************************
;			****************************************
; Face open/close animation	****************************************
;			****************************************
;			****************************************
;********************************************************************


face_animation

;-------------------------------------------------
	lda	openface_count
	beq	.exit
	sta	oam_tcount
	inc	a
	cmp	#40h
	bcc	.set
	lda	#40h
.set	sta	openface_count
;-------------------------------------------------
	lda	#cd_objanime_faceopen2	; << open anime >>
	sta	oam_animeNo
	lda	faceobj_position	; << message position >>
	jsr	set_objentry
;-------------------------------------------------

.exit

;-------------------------------------------------
	lda	closeface_count
	beq	.exit2
	sta	oam_tcount
	inc	a
	cmp	#40h
	bcc	.set2
	lda	#40h
.set2	sta	closeface_count
;-------------------------------------------------
	lda	#cd_objanime_faceclose2	; << close anime >>
	sta	oam_animeNo
	lda	faceobj_position	; << message position >>
	jsr	set_objentry
;-------------------------------------------------
.exit2

	rts

;********************************************************************
;	message next object
;********************************************************************

message_nextobj


	lda	mapexp_nextobj
	bmi	.exit
	beq	.exit
	a8
	lda	mapexp_nextobj
	inc	mapexp_nextobj
	and	#0fh
	a16
	sta	oam_tcount
	lda	#cd_objanime_nextmark	;
	sta	oam_animeNo

;----------------------------------------------
	lda	mapexp_linecheck
	beq	.skip1
	lda	#nextobj_position2g
	bra	.skip2
.skip1	lda	#nextobj_position3g
.skip2	clc	
	adc	faceobj_position
	jsr	set_objentry
;----------------------------------------------


.exit	rts

;***********************************************************************
;	STEPUP KOUGEKI PROGRAM
;***********************************************************************




;***********************************************************************
;	ENEMY KOUGEKI PROGRAM
;***********************************************************************

crash_entry

;-------------------------------------------------







;=====================================================================
;=====================================================================
;=====================================================================
;=====================================================================
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
;####################################################################
;####################################################################
;	
;------------ Kawaguchi's MapSet ------------------------------------
;
;####################################################################
;####################################################################
;********************************************************************
;	----------------------
;	 Map Animation Program
;	-----------------------
;********************************************************************
;
; kawaguchi no program kara call sareru !!!
;
; mode = ai16 
; DBR  = 7eh
;
; X .... map enemylist pointer
; Y .... object pointer
;
;--------------------------------------------------------------------
mapanime_set
	php			; >
	phx			;   >>
	sty	oam_pointer	;     ----->

	a16
	jsr	Set_objparameter	;
	jsr	Set_blockobj		;

	ldy	oam_pointer	;    <-----
	plx			;  <<
	plp			; <
	rts

;********************************************************************
;	-------------------------
;	 library mapanime objset
;	-------------------------
;********************************************************************
;
; << INPUT >>
;	oam_centerX	; (low) OBJ center posX
;	oam_centerY	; (low) OBJ center posY
;	oam_animeNo	; object animation number
;	oam_tcount	; time chart object
;
; mode 	= a?i16
; DBR	= 7eh
;
; << EXECUTE >>
;	draw OAM buffer
;
;
;--------------------------------------------------------------------
set_kawaobj
	php			;>>
	phx			;  >>
	sty	oam_pointer	;    >>
	a8
	stz	oam_centerX+1	; high clear
	stz	oam_centerY+1	; high clear
	stz	oam_animeNo+1	; high clear
	stz	oam_tcount+1	; high clear
	a16

	jsr	Set_blockobj

	ldy	oam_pointer	;    <<
	plx			;  <<		
	plp			;<<		
	rts

;********************************************************************
;	boss ship OBJ set
;********************************************************************
;
; << INPUT >>
;	Aregister = position
;	oam_animeNo	; object animation number
;	oam_tcount	; time chart object
;
; << EXECUTE >>
;	draw OAM buffer
;
;--------------------------------------------------------------------
set_objentry
	stz	oam_centerX	; position-X
	stz	oam_centerY	; position-Y
	a8
	sta	oam_centerX	; <- position X
	xba
	sta	oam_centerY	; <- position Y
	a16

	jsr	Set_blockobj

	rts

;--------------------------------------------------------------------
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
;====================================================================
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
;
;
;####################################################################
;####################################################################
;	
;------------ PROGRAM ENTRY (LIB) -----------------------------------
;
;####################################################################
;####################################################################

;********************************************************************
; 	Set Animation Object Parameter
;********************************************************************
;
; <in> 	IX ... enemy index
;
;--------------------------------------------------------------------
; final boss animation
;--------------------------------------------------------------------
Set_bossanime
	phx				; >> enemy pointer
	jsr	Set_objparametermain
	jsr	Set_blockobj		;
	plx				; << enemy pointer
;	lda	#cd_objanime_stepup
	bra	Set_objparametermain

;--------------------------------------------------------------------
; normal program
;--------------------------------------------------------------------
Set_objparameter

	lda.w	mmx_enanmpatt,x
;;;;;;;;;	lda	#cd_objanime_bossappear
;;;;;;;;;	cmp	#cd_objanime_bossappear	; special object pattern
;;;;;;;;;	beq	Set_bossanime

Set_objparametermain
	sta	oam_animeNo	; animation No

	lda.w	mmx_entype,x	; character select
	asl	a
	and	#00ffh
	sta	obj_charcheck

	lda.w	mmx_enposx+1,x
	and	#00ffh
	sta	oam_centerX	; position X

	lda.w	mmx_enposy+1,x
	and	#00ffh
	sta	oam_centerY	; position Y

	lda.w	mmx_enanmtm,x	
	and	#0ffh
	sta	oam_tcount	; animation Timer


	rts

;***********************************************************************
;	display corneria HP meter
;***********************************************************************
disp_HPmeter
	rts

;********************************************************************
;	blockobj animation program
;********************************************************************
;
; << INPUT >>
;	oam_centerX	; OBJ center posX
;	oam_centerY	; OBJ center posY
;	oam_animeNo	; object animation number
;	oam_tcount	; time chart object
;
; << EXECUTE >>
;	draw OAM buffer
;
;--------------------------------------------------------------------


Set_1sprite

	jsr	Set_animeobj

	ldy	oam_pointer
	km_MMSetSpriteSizeDouble

	ldx	obj_ROMpointer	; ROM pointer

	a8
	lda.l	ROMobjchart+2,x
	clc
	adc	oam_centerY
	xba
	lda.l	ROMobjchart+1,x
	clc
	adc	oam_centerX
	a16

	sta	sprites+0,y
	lda.l	ROMobjchart+3,x
	sta	sprites+2,y

	iny
	iny
	iny
	iny
	sty	oam_pointer
	rts


;********************************************************************
;	blockobj animation program
;********************************************************************
;
; << INPUT >>
;	oam_centerX	; OBJ center posX
;	oam_centerY	; OBJ center posY
;	oam_animeNo	; object animation number
;	oam_tcount	; time chart object
;
; << EXECUTE >>
;	draw OAM buffer
;
;--------------------------------------------------------------------

Set_blockobj
	jsr	Set_animeobj	; <-- animation program
	lda	oam_animeNo	; <-- animation number
	beq	.exit
	jsr	oam_skip
	jsr	set_oam
	jsr	oam_skip
.exit	rts

;********************************************************************
;	animation object program
;********************************************************************

Set_animeobj
;---------------------------------------------
; chart pointer set
;---------------------------------------------

	lda.l	ROMobjchart	; OBJ block address
	sta	obj_blockpointer

;---------------------------------------------
; chart calclation
;---------------------------------------------

	lda	oam_animeNo	; <--- animation number
	beq	.end

	asl	a
	tax
	lda.l	ROMobjchart,x
	tax			; SEQ address

	a8
	stz	obj_animecount

.calcloop	clc
	lda.l	ROMobjchart+0,x
	bmi	.over
	adc	obj_animecount
	sta	obj_animecount
	cmp	oam_tcount
	bcs	.exit
	inx
	inx
	bra	.calcloop

.over	dex
	dex
;---------------------------------------------

.exit	a16
	lda.l	ROMobjchart+1,x	; character No
	and	#00ffh
	asl	a
	adc	obj_blockpointer
	tax

	lda.l	ROMobjchart,x
	sta	obj_ROMpointer	; ROMpointer


.end	rts


;********************************************************************
;	OAM
;********************************************************************
;;
;; X = OAMset ROMpointer
;; Y = OAM data address
;;
;;
;====================================================================

set_oam
	ldx	obj_ROMpointer	; ROM pointer

	lda	#0aah		; <==
	sta	obj_subdata
	lda.l	ROMobjchart+0,x	; <== Counter Data Read
	bit	#0080h
	beq	.entry
	stz	obj_subdata

.entry	and	#007fh		; <== counter AND
	beq	.exit		; 0 no toki ha set shinai !!

	sta	obj_counter
	inx
	dec	a
	lsr	a
	lsr	a
	sta	obj_temp

	phx			; >>
	mapanime_oamsub		;	( sub set )
	plx			; <<

	ldy	oam_pointer
	jsr	mapanime_oammain  ;	( main set )

;--------------------------------------------------------------------

	sty	oam_pointer

.exit	rts			;	( exit )


;***********************************************************************
;	OAM main set program
;***********************************************************************

mapanime_oammain	

oammain_loop
	lda.l	ROMobjchart+1,x	; <Y> position
	Msex
	clc
	adc	oam_centerY
	bpl	.skip
	cmp	#0ffe0h
	bcs	.skip
	lda	#0e0e0h
.skip	xba

	a8
	lda.l	ROMobjchart+0,x	; <X> position
	bpl	.entry
	bit	#001111000b	; 80...87 special codes
	beq	special_objset

.entry	clc
	adc	oam_centerX
	a16
	sta	sprites+0,y

	lda.l	ROMobjchart+2,x	; set character
	sta	sprites+2,y

	inx			; INC DATA pointer
	inx
	inx
	inx

next_object
	iny			; INC OAM  pointer
	iny
	iny
	iny

	dec	obj_counter
	bne	oammain_loop

	rts


;***********************************************************************
;	special object
;***********************************************************************
;
; << input >> a8
;	 X = ROM pointer
;	 Y = OAM RAM poitner
;
; special codes ----------------------------------
;
;	80h  .... kurukuru normal
;	81h  .... kurukuru frash
;	82h  .... program rom jmp
;	83h  .... mapobj 16
;	84h  ....
;	85h  ....
;	86h  ....
;	87h  ....
;
;-----------------------------------------------------------------------
special_objset
	stx	obj_temp
	a16
	and	#07h
	beq	setobj_kurukuru_normal	;;;; 80h mormal
	dec	a
	beq	setobj_kurukuru_frash	;;;; 81h frash
	dec	a
	beq	setobj_romjmp		;;;; 82h romjmp
;-----------------------------------------------------------------------
; code 83h
;-----------------------------------------------------------------------
	BRL	setobj_16
;-----------------------------------------------------------------------
; code 82h
;-----------------------------------------------------------------------
setobj_romjmp
	txa
	clc
	adc.l	ROMobjchart+1,x
	tax
	bra	oammain_loop

;-----------------------------------------------------------------------
; code 80h
;-----------------------------------------------------------------------
setobj_kurukuru_normal
	jsr	set_16obj_posxy		; set position
	ldx	obj_charcheck
	lda.l	kurukuru_normal,x	; kurukuru data
	bra	setobj_kurukuru
;-----------------------------------------------------------------------
; code 81h
;-----------------------------------------------------------------------
setobj_kurukuru_frash
	jsr	set_16obj_posxy
	ldx	obj_charcheck
	lda.l	kurukuru_frash,x	; kurukuru data
;-----------------------------------------------------------------------
setobj_kurukuru
	bne	.set
	lda	#0e0e0h		; off sprite
	sta	sprites+0,y
.set	clc
	ldx	obj_temp
	adc.l	ROMobjchart+1,x
	sta	sprites+2,y	; set character
	inx			; pointer INC
	inx
	inx
	bra	next_object

;-----------------------------------------------------------------------
set_16obj_posxy

	a8
	lda	oam_centerY
	sec
	sbc	#8
	xba
	lda	oam_centerX
	sec
	sbc	#8
	a16
	sta	sprites+0,y
	rts

;-----------------------------------------------------------------------
Msetobj_16hv	macro	[x,y]
	lda	oam_centerX
	clc
	adc	#{x}
	a8
	sta	sprites,y
	a16
	iny
	lda	oam_centerY
	clc
	adc	#{y}
	a8
	sta	sprites,y
	a16
	iny
	endm
;-----------------------------------------------------------------------
Msetobj_16ca	macro
	lda.l	ROMobjchart+0,x
	sta	sprites,y
	iny
	iny
	inx
	inx
	endm
;-----------------------------------------------------------------------
setobj_16
	inx
	Msetobj_16hv	00f0h,00f0h
	Msetobj_16ca
	Msetobj_16hv	0000h,00f0h
	Msetobj_16ca
	Msetobj_16hv	00f0h,0000h
	Msetobj_16ca
	Msetobj_16hv	0000h,0000h
	Msetobj_16ca
	rts
	

;***********************************************************************
;	OAM Skip program
;***********************************************************************

oam_skip
;-------------------------------------------
	lda	oam_pointer
;- - - - - - - - - - - - - - - - - - - - - -
	ldy	#0e0e0h
.loop	bit	#01111b
	beq	.skip
	tax
	tya
	sta	sprites,x
	txa
	inc	a
	inc	a
	inc	a
	inc	a
	bra	.loop
;- - - - - - - - - - - - - - - - - - - - - -
.skip	sta	oam_pointer
	rts


;********************************************************************
;			****************************************
;			****************************************
; Openning Enemy Animation	****************************************
;			****************************************
;			****************************************
;********************************************************************
;
;
;
;
;********************************************************************
;	-------------------------
;	 debug animation program
;	-------------------------
;********************************************************************

test_animation

	ifne	0
;-------------------------------------------------------
	lda	debug_work
	inc	a
	and	#00ffh
	sta	debug_work

	stz	obj_charcheck

	jsr	Set_blockobj

	Mset	oam_centerX,60h
	Mset	oam_centerY,60h
	Mset	oam_animeNo,cd_objanime_stepup	; stepup arrived !!
	Mmov	oam_tcount,debug_work

	jsr	Set_blockobj

;-------------------------------------------------------
	endc

	rts

;*********************************************************************
;	---------------------------
;	 map namedisplay animation
;	---------------------------
;*********************************************************************
;;
;; input  Yregister oam_pointer
;; output Yregister oam_pointer
;;
;;=====================

;;map_nameobjdisp

;*********************************************************************
;	-------------------------
;	 map sos character datas
;	-------------------------
;*********************************************************************

sos1_demo	equ	180h+2000h+0400h
sos2_demo	equ	160h+2000h+0400h
sos3_demo	equ	1c0h+2000h+0400h
miss_demo	equ	1a0h+2000h+0400h
boss_demo	equ	0

sos1_char	equ	180h+2000h
sos2_char	equ	160h+2000h
sos3_char	equ	1c0h+2000h
miss_char	equ	1a0h+2000h
boss_char	equ	0

;------------------------------------------------------------
kurukuru_frash
	dw	sos1_demo
	dw	sos2_demo
	dw	sos3_demo
	dw	miss_demo
	dw	boss_demo

;------------------------------------------------------------
kurukuru_normal
	dw	sos1_char
	dw	sos2_char
	dw	sos3_char
	dw	miss_char
	dw	boss_char

;=====================================================================
; end end end end end end end end end end end end end end end end end
;=====================================================================








;=======================================================================
;====================================================================
;====================================================================
; END END END END END END END END END END END END END END END END 
;====================================================================
;====================================================================
