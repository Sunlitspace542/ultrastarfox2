;�����������������������������������������������������������ͻ
;� FILE:                DISPLAY.ASM                          �
;� AUTHOR:              Takumi Kawagoe   Nintendo.co.ltd  EDA�
;� DESCRIPTION:         DISPLAY FOR SCREEN                   �
;� DATE CREATED:        7-9-93                               �
;�����������������������������������������������������������ͼ

	INCPUB	display

	SHORTA
	LONGI

;WORK RAM

AMmeter1	equ	6<<1
AMmeter2	equ	7<<1
AMmeter3	equ	8<<1
AMmeter4	equ	9<<1
AMmeter5	equ	10<<1
AMmeter6	equ	11<<1

RBmeter1	equ	11<<1
RBmeter2	equ	12<<1
RBmeter3	equ	13<<1

;�������������������������������������������������������������������
;-------------------------------------------------------------------;
;                                                                   ;
; set player's altitude meter			               ;
;                                                                   ; 
;-------------------------------------------------------------------;
;�������������������������������������������������������������������
boostcol1	equ	7	; color of boost meter(normal)
boostcol2	equ	2	; color of boost meter(over heat)
boostcol3	equ	3	; color of boost meter(over heat)

pccol_normal	equ	8
pccol_light	equ	6
pccol_dark	equ	3

	SHORTA
	LONGI


set_player_cursor_P1_l	; for player 1

	PUSHXYPB

	a8i16

	BANK7E

	s_set_objtobeplayer1	x

	bra	set_player_cursor_P2_l.enter

set_player_cursor_P2_l	; for player 2

	rtl

;	PUSHXYPB
;
;	a8i16
;
;	BANK7E
;
;	s_set_objtobeplayer2	x

;-------------------------------------------------------------------------------------
.enter	LOCAL

	toheap		y,x

.start	s_copy_alvar2var	B,y,work0,exal_maxProtX

	jsr		setPcur_chr
	s_set_alvar	B,y,exal_altmeter_chr,work0

	lda	work1
	sta	exal_altmeter_flag,y

;�������������������������������������������������������������������������������������
; calc altmeter pos
;�������������������������������������������������������������������������������������

	sp_jmpNOT_playertype	x,ROBOT,.aw

.rb	a16
	lda	exal_worldy,y
	bra	.pp
.aw	a16
	lda	al_worldy,x
.pp	sta	y1

	a8

	jsr	get_altmeter_pos

;-----------------------------------------------------------------------------
;limitter of meter

; tpz : cursor flash flag

	s_set_var	B,tpz,#0	;B,work1,#0


.h0	lda	TPY	;work0
	bpl	.p
.m
	cmp	#-(altmeter_height>>1)
	bcc	.m2

	lda	#33
	sta	tpz	;work1

	lda	TPY	;work0

.m2	cmp	#-(altmeter_height>>1+altmeter_outheight)
	bcs	.exit
.min
	lda	#-(altmeter_height>>1+altmeter_outheight)
	sta	TPY	;work0
	bra	.exit

.p
	cmp	#altmeter_height>>1
	bcs	.p2
	lda	#33
	sta	tpz	;work1
	lda	TPY	;work0
.p2	cmp	#altmeter_height>>1+altmeter_outheight
	bcc	.exit
.max
	lda	#altmeter_height>>1+altmeter_outheight
	sta	TPY	;work0

.exit
	a16
	lda.l	m_screenvheight	;#(bitmapvheight_1/2)*8-4
	asra
	clc
	adc	TPY	;work0
	sec
	sbc	#4	; adjust
	and	#0ffH
	a8
; set
	sta	exal_altmeter,y

;�������������������������������������������������������������������������������������
;	set water line
;�������������������������������������������������������������������������������������
	a16

	lda	SEADEPTH
	beq	.nowater
	nega
	sta	y1
	a8
	jsr	get_altmeter_pos
	a16
	lda	#-(altmeter_height>>1)
	clc
	adc	tpy
	sta	tpy
	lda	tpy
	bpl	.setwl
.nowater	lda	#0
.setwl	sta	exal_waterline,y

	a8

;----------------------------------------------------------------------

	lda	TPZ	; cursor flash flag
	bne	.inn

	lda	gameframe
	and	#1
	bne	.dark


.light	lda	#pccol_light
	bra	.inn2
.dark	lda	#pccol_dark
	bra	.inn2
.inn	lda	#pccol_normal
.inn2	sta	exal_altmeter_col,y

;�������������������������������������������������������������������������������������
;	circle window
;����������������������������������������������������������������������������

.circleon	jsr	draw_circle
	bcc	.circleoff

; if circle priority on then addcol off!

	jsr	deccol_circle
	bcs	.coladd

.circleoff	a16
	lda	#winm_off
	sta	kx_circlewindowmode,y
	lda	#0
	sta	kx_circleTR,y
	a8
	sta	exal_circle_flag,y

;-------------------------------------------------------------------------------------
; colour add

.coladd	jsr	deccol_addcol

;������������������������������������������������������������������������������������
;set target scope
;������������������������������������������������������������������������������������

	sp_ifdisplayOFF	.targetoff
	sp_jmp_ifhudon	x,.do,y

.targetoff	lda	#100
	sta	p1_targetx
	sta	p1_targety
	jmp	.TARGETexit

.do	pl_ldy_viewblk	x
	sty	work1

; -- calc value --

	ldy	dummyobj

	s_copy_rots	y,x

;------------
; store target pos

	s_push_obj	x

	toheap	x,x

	a16

	lda	exal_target_x,x
	sta.w	al_worldx,y
	lda	exal_target_y,x
	sta.w	al_worldy,y
	lda	exal_target_z,x
	sta.w	al_worldz,y

	a8
	s_pull_obj	x


	s_push_obj	x
	tyx
	ldy	work1
	jsr	calc_scrpos_o
	s_pull_obj	x

;------------
; set value

	s_set_var	B,work0,#8	; min limiter

	a16

.LMTx	lda	#-16
	clc
	adc	xs
	bpl	.maxx
	lda	#16
	bra	.setXS

.maxx	lda	#bitmapwidth_1*8-16	;x1
	cmp	xs
	bcs	.LMTy
.setXS	sta	xs




.LMTy	lda	#-32
	clc
	adc	ys
	bpl	.maxy
	lda	#16
	bra	.setYS
.maxy	lda	#bitmapvheight_1*8-16	;y1
	cmp	ys
	bcs	.out
.setYS	sta	ys


.out
	a8

.TARGETp1
	lda		xs
	clc
	adc		#player1_wx*8+8

	sta		x1
	s_achase_var	B,p1_targetX,x1,1


	lda		ys
	clc
	adc		#2*8+8

	sta		y1
	s_achase_var	B,p1_targetY,y1,1

.TARGETexit

;�������������������������������������������������������������������������������������
; TARGET LOCKER
;�������������������������������������������������������������������������������������

	ldx	playpt1

	toheap	y,x

	IFEQ	LOCKONDEF
	sp_jmpnot_iftamehomon	.HOMOFF
	ENDC

;********************************************************
;
;	IFEQ	tamehomon
;	jmp	.lockout
;	ENDC
;
;********************************************************

	s_jmp_alvarZERO	W,y,exal_enemyaltmeter_objptr,.lockout

	s_jmp_varZERO	B,Kenemynumber,.lockout
	km_jmpgameflag	freeze,.lockout
	pl_jmp_ifcontroloff	x,.lockout,y

; lock suru?

	lda	exal_enemyaltmeter_flag,y
	bit	#exal_enemyaltmeter_flag_nolock
	rlbeq	.dolock
	s_set_var	W,p1_markptr,#0
	jmp	.lockout
.dolock


	a16
	lda	exal_enemyaltmeter_lockobjlast,y
	cmp	exal_enemyaltmeter_objptr,y
	a8
	rlbne	.lockout

	a16
	lda	#0
	sta	exal_enemyaltmeter_lockobjlast,y
	stz	p1_markptr
	a8

; check out flag

	lda	exal_enemyaltmeter_flag,y	; type
	and	#exal_enemyaltmeter_flag_out	; type

	bit	#exal_enemyaltmeter_flag_out	; type
	rlbne	.lockout

	lda	exal_enemyaltmeter_x,y
	sta	tpx

	lda	p1_targetX
	sec
	sbc	#player1_wx*8+8
	sec
	sbc	tpx
	clc
	adc	#lock_height
	bmi	.locking
	cmp	#lock_height*2
	bpl	.locking

	lda	exal_enemyaltmeter_y,y
	sta	tpy

	lda	p1_targetY
	sec
	sbc	#2*8+8
	sec
	sbc	tpy
	clc
	adc	#lock_width
	bmi	.locking
	cmp	#lock_width*2
	bpl	.locking

	s_copy_alvar2alvar	W,y,exal_enemyaltmeter_lockobjlast,y,exal_enemyaltmeter_objptr

	lda	exal_enemyaltmeter_locktimer,y
	cmp	#lock_time
	beq	.lockon
	inc	a
	sta	exal_enemyaltmeter_locktimer,y

	jmp	.exitlock



.locking	SHORTA
	s_jmp_alvarZERO	W,y,exal_enemyaltmeter_lockobj,.lockout

	lda	exal_enemyaltmeter_locktimer2,y
	beq	.lockout
	dec	a
	sta	exal_enemyaltmeter_locktimer2,y

	s_copy_alvar2var	W,y,p1_markptr,exal_enemyaltmeter_lockobj
	s_copy_alvar2alvar	W,y,exal_enemyaltmeter_lockobjlast,y,exal_enemyaltmeter_lockobj

	bne	.exitLOCK


.HOMOFF	SHORTA

	stz	p1_markptr
	stz	p1_markptr+1


.lockout	SHORTA
	s_copy_alvar2alvar	W,y,exal_enemyaltmeter_lockobjlast,y,exal_enemyaltmeter_objptr
	s_set_alvar	W,y,exal_enemyaltmeter_lockobj,#0
	s_set_alvar	B,y,exal_enemyaltmeter_locktimer,#0
	s_set_alvar	B,y,exal_enemyaltmeter_locktimer2,#0
	bra	.exitLOCK

;---------------------------------------------------------------------------------------------
.lockon	SHORTA

; init anim farme

	s_jmp_alvarnotZERO	W,y,exal_enemyaltmeter_lockobj,.noanim
	s_and_alvar		B,y,exal_enemyaltmeter_status2,#0f0h

	ksound	lock_on

.noanim
	s_copy_alvar2alvar	W,y,exal_enemyaltmeter_lockobj,y,exal_enemyaltmeter_objptr
	s_copy_alvar2alvar	W,y,exal_enemyaltmeter_lockobjlast,y,exal_enemyaltmeter_objptr
	s_copy_alvar2var	W,y,p1_markptr,exal_enemyaltmeter_lockobj
	s_set_alvar	B,y,exal_enemyaltmeter_locktimer2,#lock_time2

;---------------------------------------------------------------------------------------------

.exitLOCK

;-------------------------------------------------------------------------------------
; clear lock flag

	lda	exal_enemyaltmeter_flag,y
	and	#~exal_enemyaltmeter_flag_locked
	and	#~exal_enemyaltmeter_flag_nolock
	sta	exal_enemyaltmeter_flag,y

;������������������������������������������������������������������������������������
;	set MARIO RAM parameters
;������������������������������������������������������������������������������������

	ramnastyoff

	test_screenmode	noplayer
	bne	.off

	sp_ifdisplayON	.display_on
.off

;not draw

	a16
	lda	#0
	sta.l	m_hudrot	; mdrawtest
	sta.l	m_boostcnt	; mdrawtest
	sta.l	m_ecurptr	; mhud
	lda	#0ffffH
	sta.l	m_p_altmeter_posx

	jmp	.finish

;-------------------------------------------------------------------------------------

.display_on

;-------------------------------------------------------------------------------------
;Player's altmeter

	ai16

	lda	#P1_PaltlineposX_1
	sta.l	m_p_altmeter_posx
	lda	#P1_PaltmeterX_1
	sta.l	m_p_altmeter_x

;------------
; string data(Target)

	lda	exal_string_ofsx,y
	sexa
	sta.l	m_e_string_ofsx
	lda	exal_string_ofsy,y
	sexa
	sta.l	m_e_string_ofsy

	lda	exal_string_col,y
	sta.l	m_e_string_col

;------------
; water line

	PHX	;--->>>

	lda	exal_altmeter_chr,y
	and	#0ffH
	tax
	lda	#AWMETERtab/10000H
	sta.l	m_pcurbank
	lda.l	AWMETERtab,x
	sta.l	m_pcurptr

	PLX	;<<<---

	lda	exal_altmeter_flag-1,y	;HVflip flag
	sta.l	m_p_altmeter_flag

	lda	exal_altmeter,y
	sec
	sbc	#PA_cur_sizeY>>1
	and	#0ffH
	sta.l	m_p_altmeter_y
	lda	exal_altmeter_col,y
	and	#0ffH
	sta.l	m_p_altmeter_col

	lda	exal_waterline,y
	and	#0ffH
	sta.l	m_p_waterline


	lda	exal_enemyaltmeter_status-1,y
	rlbmi	.nodraw

;drawp1
	lda	exal_enemyaltmeter_x,y
	sta.l	m_e_altmeter_x
	lda	exal_enemyaltmeter_y,y
	sta.l	m_e_altmeter_y

	lda	exal_enemyaltmeter_status2,y
	sta	work0
	lda	exal_enemyaltmeter_status,y

;************

	and	#0fH

	asl	a

	PHX	;--->>>

	tax
	lda	#cursprtable/10000H
	sta.l	m_ecurbank
	lda.l	cursprtable,x
	sta	work1
	lda	work0
	and	#0fH
	asl	a
	asl	a
	clc
	adc	work1
	tax

	lda.l	cursprtable&0ff0000H,x
	sta.l	m_ecurptr
	lda.l	cursprtable&0ff0000H+2,x
	and	#3ffh
	sta.l	m_e_altmeter_flag		;shift times

	lda.l	cursprtable&0ff0000H+2,x
	xba
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	and	#0fh
	sta.l	m_e_altmeter_col1


	PLX	;<<<---

; -- col animation --

;	lda	work0
;	and	#010H
;	beq	.col2
;.col1	lda	#2	; flash colour
;	sta.l	m_e_altmeter_col1
;	lda	#2
;	sta.l	m_e_altmeter_col2
;	lda	#2
;	sta.l	m_e_altmeter_col3
;	bra	.exitalt
;.col2	lda	#0eH
;	sta.l	m_e_altmeter_col1
;	lda	#0eH
;	sta.l	m_e_altmeter_col2
;	lda	#0eH
;	sta.l	m_e_altmeter_col3

	bra	.exitalt

.nodraw

	lda	#0
	sta.l	m_ecurptr

.exitalt

;-------------------------------------------------------------------------------------
;boost meter (only mission mode)

	a16
	lda	#0
	sta.l	m_boostcnt
	a8

	toheap	y,x

	lda	exal_weap_power+1,y
	and	#%111111

.staanim	sta.l	m_boostanim

	lda	P1_maxMETER
	cmp.l	m_boostanim
	bne	.setcol1

	s_jmp_ANDframe		#1,.setcol1

	lda	#boostcol2
	bra	.setcol2

.setcol1	lda	#boostcol1
.setcol2	sta.l	m_boostanim+1
	a16

	lda	#1
	sta.l	m_boostcnt

	a16

;-------------------------------------------------------------------------------------
; boost meter

	lda	P1_maxMETER
	and	#0ffh
	clc
	adc	#3
	sta.l	m_boostframex

; offset x
	lda	P1_maxMETER
	and	#0ffh
	nega
	clc
	adc	#23*8+40-5
	sta.l	m_boostposx

;-------------------------------------------------------------------------------------

	lda	#string_target>>16
	sta.l	m_e_stringbank

	lda	exal_string,y
	sta.l	m_e_string
	lda	exal_string2,y
	sta.l	m_e_string2


;-------------------------------------------------------------------------------------
;head up display

	a16
	lda	exal_hudflag,y
	and	#0ffH
	sta.l	m_hudflags
	lda	exal_hudrot,y
	sta.l	m_hudrot

; HP ga sukunakereba RED ni suru.

	lda	#15
	sta.l	m_hudcolour

	lda	p1_HP
	and	#0ffh
	cmp	#3*4+1
	bcs	.finish


	lda	#2	; 15 green
	sta.l	m_hudcolour

	lda	gameframe
	bit	#%100
	bne	.finish

	bit	#%1
	bne	.finish

	lda	#14	; 15 green
	sta.l	m_hudcolour

.finish	a8


	ramnastyon

;-------------------------------------------------------------------------------------
; claer pointers

	a16
	lda	#0
	sta	exal_enemyaltmeter_objptr,y
	sta	exal_enemyaltmeter_offdist,y
	lda	#0ffffH
	sta	exal_enemyaltmeter_objdist,y
	sta	exal_enemyaltmeter_objdist_ck,y
	lda	#80h<<8
	sta	exal_enemyaltmeter_objdiry,y
	a8


	PULLXYPB

	rtl

;-------------------------------------------------------------------------------------

setPcur_chr	; set ARWING meter charactor No.

	; idX :player's pointer

	; In  : work0 (8bit) rotX max
	; Out : work0 (8bit) charactor data pointer
	;     : work1 (8bit) flip data (bit1:Vflip)

	phx
	phy
	php
	a8i16

	toheap		y,x

	sp_jmp_playertype	x,ROBOT,.ROBOT
	sp_jmp_playertype	x,UFO,.ARMER
	jmp		.ARWING

;--------------------------------------------------------------------------------------
.ROBOT
	s_set_var	B,work0,#0
	s_set_var	B,work1,#0

	a16
	lda	exal_jetRobjptr,y
	pha
	lda	exal_jetLobjptr,y
	tay

	a8
	lda.w	al_sbyte4,y	;See ROBOanimLleg_strat
	sta	x1+0	;L
	ply
	lda.w	al_sbyte4,y	;See ROBOanimLleg_strat
	sta	x1+1	;R

	s_jmp_varEQ	B,x1+0,x1+1,.RBptr0

;animframe(L) 0-3 & 12-15 then work0=2

	inc	work0

	lda	x1+0
	clc
	adc	#4
	bit	#8
	bne	.RBptr1

.RBptr2	lda	#RBmeter3
	bra	.setRBptr
.RBptr1	lda	#RBmeter2
	bra	.setRBptr
.RBptr0	lda	#RBmeter1
.setRBptr	sta	work0

.exitROBOT	jmp	.exit


;--------------------------------------------------------------------------------------
.ARMER
	s_set_var	B,work1,#0

	ldy	al_sword2,x

	lda	exal_jetrot,y
	clc
	adc	#10H
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	s_push_obj	x
	a16
	and	#7
	tax
	a8
	lda.l	.ARMERDATA,x
	s_pull_obj	x

	sta	work0

.exitARMER	jmp	.exit

.ARMERdata
	byte	AMmeter3
	byte	AMmeter4
	byte	AMmeter5
	byte	AMmeter4
	byte	AMmeter3
	byte	AMmeter2
	byte	AMmeter1
	byte	AMmeter2

;--------------------------------------------------------------------------------------
.ARWING	lda	#0
	sta	work1
;	lsr	work0
;	lsr	work0
	lsr	work0

	ldy	#0
	lda	al_rotx,x
	bpl	.pl

.mi	ldy	#3*2
	nega
.pl
	sec
	sbc	work0
	bcc	.set0
	iny
	iny
	sec
	sbc	work0
	bcc	.set1
	iny
	iny
	bra	.set1

.set0
	;lda	#0
	;sta	work1
.set1
	sty	work0

.exit	plp
	ply
	plx
	rts

;����������������������������������������������������������������������������������
;	SET TARGET ROUTINE
;����������������������������������������������������������������������������������
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;WARNING!	set_player_cursor_P1_l ni idou sita!

	SHORTA
	LONGI

set_Target_l

	phx
	phy
	php

	a8i16

	s_jmp_alsflag	x,player2,.exit
.tp1

	;test_PLtarget		p1
	;rlbeq			.exit
	bra			.do
.tp2

	;test_PLtarget		p2
	;rlbeq			.exit


.do	LOCAL

	pl_ldy_viewblk	x

	sty	work1

; -- calc value --

	ldy	dummyobj

	s_copy_rots	y,x

;�����������������������������������������������������������������������

	s_push_obj	y
	ldy	al_sword2,x
	lda	exal_acclroty+1,y
	clc
	adc	exal_acclroty+1,y
	s_pull_obj	y
	clc
	adc.w	al_roty,y
	sta.w	al_roty,y

;�����������������������������������������������������������������������

	s_add_roffs2pos	B,y,x,y,#0,#0,#100,1,1,1,2,2,2

; store target pos

	s_push_obj	x

	toheap	x,x

	a16
	lda.w	al_worldx,y
	sta	exal_target_x,x
	lda.w	al_worldy,y
	sta	exal_target_y,x
	lda.w	al_worldz,y
	sta	exal_target_z,x
	a8

	s_pull_obj	x
	s_push_obj	x

	tyx
	ldy	work1

	jsr	calc_scrpos_o

	s_pull_obj	x

; -- set value --

	s_set_var	B,work0,#8	; min limiter

	sm_jmp_if1screen	.one

.two	a16
	lda	#bitmapwidth*8-16
	sta	x1
	lda	#bitmapvheight*8-16
	sta	y1
	lda	#player1_wx*8+8
	sta	x2
	lda	#2*8+8
	sta	y2
	lda	#15*8+8
	sta	y3
	bra	.LMTx
.one	a16
	lda	#bitmapwidth_1*8-16
	sta	x1
	lda	#bitmapvheight_1*8-16
	sta	y1
	lda	#player1_wx*8+8
	sta	x2
	lda	#2*8+8
	sta	y2
.LMTx	lda	#-16
	clc
	adc	xs
	bpl	.maxx
	lda	#16
	bra	.setXS
.maxx	lda	x1
	cmp	xs
	bcs	.LMTy
.setXS	sta	xs
.LMTy	lda	#-32
	clc
	adc	ys
	bpl	.maxy
	lda	#16
	bra	.setYS
.maxy	lda	y1
	cmp	ys
	bcs	.out
.setYS	sta	ys
.out	a8
	s_jmp_alsflag	x,player2,.p2
.p1	lda		xs
	clc
	adc		x2
	sta		x1
	s_achase_var	B,p1_targetX,x1,1
	lda		ys
	clc
	adc		y2	;#2*8
	sta		y1
	s_achase_var	B,p1_targetY,y1,1
	bra		.exit
.p2	lda		xs
	clc
	lda		#player2_wx*8+24
	sta		x1
	s_achase_var	B,p2_targetX,x1,1
	lda		ys
	clc
	adc		#15*8
	sta		y1
	s_achase_var	B,p2_targetY,y1,1
.exit
stp_exit	plp
	ply
	plx
	rtl

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC

;�����������������������������������������������������������������������������
;	SET TARGET POS
;�����������������������������������������������������������������������������

set_target_l
	PUSHYP

	pl_ldy_viewblk	x

	sty	work1

; -- calc value --

	ldy	dummyobj

	s_copy_alvar2alvar	B,y,al_roty,x,al_roty
	s_set_alvar		B,y,al_rotx,p1_firerotx


	s_push_obj	y

	toheap	y,x

	lda	exal_acclroty+1,y
	clc
	adc	exal_acclroty+1,y
	s_pull_obj	y
	clc
	adc.w	al_roty,y
	sta.w	al_roty,y

	s_add_roffs2pos	B,y,x,y,#0,#0,#75,1,1,1,7,7,7

; store target pos

	s_push_obj	x

	toheap	x,x
	a16
	lda.w	al_worldx,y
	sta	exal_target_x,x
	lda.w	al_worldy,y
	sta	exal_target_y,x
	lda.w	al_worldz,y
	sta	exal_target_z,x
	a8

	s_pull_obj	x

	PULLYP

	rtl

;�����������������������������������������������������������������������������
;	altmeter no posision
;�����������������������������������������������������������������������������

get_altmeter_pos

; in	:y1 (=al_worldy)
; out	:tpy(altmeter pos y)

; using	:tpx
; 	:tpy
; 	:tpz

	PHP
;����Ŀ
;�Calc�
;������
	a16

	lda	#0
	sta	TPX	;work2

	lda	BATTLEAREA_minY
	clc
	adc	BATTLEAREA_maxY
	nega
	asra
	clc
	adc	y1	;al_worldy,x
	clc
	adc	#-11	;adjust for ROBOT

	bpl	.skip0
	nega
	pha
	lda	#-1	; sign change
	sta	TPX	;work2
	pla
.skip0	sta	TPY	;work0



	lda	altmeterrate
	sta	tpz	;work1

.loop0
	bit	#0ff00H
	beq	.out
	lsr	tpz	;work1
	lsr	TPY	;work0
	lsr	a
	bra	.loop0
.out
	lda	TPY	;work0
	sta.l	WRDIVL
	a8
	lda	tpz	;work1
	sta.l	WRDIVB
	a16
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	lda.l	RDDIVLR
	eor	TPX	;work2
	sta	TPY	;work0

	PLP

	rts

;�������������������������������������������������������������������
;-------------------------------------------------------------------;
;                                                                   ;
; Calculates the enemy's altitude meter			       ;
;                                                                   ; 
;-------------------------------------------------------------------;
;�������������������������������������������������������������������
set_Ealtstatus	macro	[setalvar,countalvar,flagvar,animvar]

;Out:	setvar
;	bit0-3	cursor type No(max16 type)
;	bit4	1:H flip on
;	bit5	1:V flip on
;	bit6	no
;	bit7	0:cursor on   1:cursor off
;
;	countvar
;	bit0-3	animation counter
;	bit4-7	flash counter

	a8

; -- set coursor ON OFF flag --

	lda	{flagvar}
	bit	#80H
	beq	.skip0\@

	lda	{setalvar},y
	bmi	.skip1\@

;	lda	gameframe
;	and	#1
;	beq	.skip2\@

	lda	#10H
.skip2\@	clc
	adc	{countalvar},y	; CURSOR FLASH COUNTER INC
	sta	{countalvar},y

	;printh	COUNTALVAR,kawagoe


	;cmp	#070H		; counter max 7(*10H)
	;bcc	.skip1\@

;****
	and	#1fh
	sta	{countalvar},y
;****

;	lda	{setalvar},y
;	ora	#80H		; SET cursor clear FLAG
;	sta	{setalvar},y
;	lda	{countalvar},y	; CLR COUNTER
;	and	#0fH
;	sta	{countalvar},y

	bra	.skip1\@

.skip0\@	lda	{countalvar},y	; CLR FLAG
	and	#0fH
	sta	{countalvar},y
	lda	{setalvar},y
	and	#7fH
	sta	{setalvar},y
.skip1\@
	lda	{setalvar},y
	and	#0e0H
	sta	{setalvar},y

	lda	{flagvar}	; CUR TYPE
	and	#1fH
	ora	{setalvar},y
	sta	{setalvar},y

; -- set coursor animation counter --

	;lda	{animvar}
	;and	#3
	;cmp	#3
	;beq	.inc\@
	;lda	gameframe
	;and	#1
	;beq	.noinc\@

.inc\@
	;lda	{countalvar},y
	;inc	a
	;sta	{countalvar},y

.noinc\@
	;lda	{countalvar},y
	;and	#0fH
	;cmp	#5		; max animation No.
	;bcc	.exit\@
	;lda	{countalvar},y
	;and	#0f0H
	;sta	{countalvar},y
.exit\@

	ENDM
;-------------------------------------------------------------------

;workflag		bit0 : right out
;		bit1 : left  out
;		bit2 : down  out
;		bit3 : up    out
;		bit7 : FRONT(0) BACK (1)
;cursor type		0    : inside screen
;		1    : right out
;		2    : left out
;		3    : down out
;		4    : up out

;Using		work0: work ram
;		work1: cursor type No.

ecsizeA		equ	16	; size of enemy cursor
ecsizeB		equ	11	; size of enemy cursor

viewsquear		equ	viewradius*viewradius	; scale oblivious radius for view(vars.inc)

;-------------------------------------------------------------------
;ECtargetptr	equ	work9

set_enemy_cursor_P1_l	; for screen #1
set_enemy_cursor_P2_l	; for screen #2


	PUSHXYPB

	a8i16

	BANK7E

	ldx	playpt1

	toheap	y,x

;-------------------------------------------------------------------
; game claer or Demo?

	s_jmp_varzero		B,Kenemynumber,.nomarkobj
	s_jmp_varnotzero	B,demomode,.nomarkobj

; player dead?

	test_playerdead		1
	bne	.nomarkobj

	km_jmpgameflag		freeze,.nomarkobj

	a16
	km_bitcheckmissionflag	enemyrunaway
	a8
	bne			.nomarkobj

;-------------------------------------------------------------------
;add inert obj 2 enemyaltmeter

	jsl	addEaltlist_inert_l

;-------------------------------------------------------------------

	a16
	lda	exal_enemyaltmeter_objptr,y
	a8
	rlbeq	.nomarkobj

;--------------------------------------------------------------------------------
;
;	sp_jmp_ifEaltmeterON	x,.start

	sp_ifdisplayON	.start

;--------------------------------------------------------------------------------
.nomarkobj

	s_or_alvar	B,y,exal_enemyaltmeter_status,#80H

	jmp	.exit

;--------------------------------------------------------------------------------

.start	s_set_var	B,work1,#0	; cursor type No.

	s_push_obj	y
	pl_ldy_viewblk	x
	jsr		setEcursor
	s_pull_obj	y

	s_set_var	B,tpx,#0

	set_Ealtstatus	exal_enemyaltmeter_status,exal_enemyaltmeter_status2,scrLMT_type,tpx

;--------------------------------------------------------------------------------
; set animation No.

	a16
	lda	exal_enemyaltmeter_lockobj,y
	a8
	rlbeq	.normanim

.locked
	lda	exal_enemyaltmeter_status,y
	and	#0f0h
	ora	#10
	sta	exal_enemyaltmeter_status,y

; lock animation 0,1,2,3,2,3,2,3,2.....

	lda	exal_enemyaltmeter_status2,y
	inc	a
	sta	exal_enemyaltmeter_status2,y
	and	#0fh
	cmp	#5
	bcc	.exitanim

	lda	exal_enemyaltmeter_status2,y
	and	#0f0h
	ora	#3
	sta	exal_enemyaltmeter_status2,y
	bra	.exitanim

.normanim

	lda	exal_enemyaltmeter_status2,y
	inc	a
	sta	exal_enemyaltmeter_status2,y
	and	#0fh
	cmp	#6
	bcc	.exitanim
	lda	exal_enemyaltmeter_status2,y
	and	#0f0h
	sta	exal_enemyaltmeter_status2,y

.exitanim



;--------------------------------------------------------------------------------
; set string's position & data

	s_push_obj	x

; set string data bank

	a16
	
	lda	exal_enemyaltmeter_status,y
	and	#15
	cmp	#9
	bcc	.stgcnt
	lda	#0
.stgcnt	asl	a
	tax
	a8
	lda.l	stringtab+0,x
	sta	x1
	lda.l	stringtab+1,x
	sta	y1



;------------
; R out?
	lda	exal_enemyaltmeter_x,y
	cmp	#bitmapwidth_1*8-4*8
	bcc	.notrout
	lda	#-32
	sta	x1
.notrout
;------------

	s_pull_obj	x

	s_achase_alvar	B,y,exal_string_ofsx,x1,2
	s_achase_alvar	B,y,exal_string_ofsy,y1,2

	a16
	lda	exal_enemyaltmeter_objptr,y
	rlbne	.target

	lda	KRingOutTimer-1,y
	rlbmi	.turn

.target	LONGA

; set target colour

	lda	exal_enemyaltmeter_lockobj,y
	beq	.normal

;------------
.green
;	lda	#0f09h	; lock
	lda	#409h
	sta	exal_string_col,y

	lda	exal_enemyaltmeter_status2,y
	bit	#1
	beq	.g0
	lda	#209h
	sta	exal_string_col,y

.g0
	lda	#string_locked&WM
	sta	exal_string,y	;.l	m_e_string
	lda	#string_locked2&WM
	sta	exal_string2,y	;.l	m_e_string
	bra	.stastr
.normal
;------------
	lda	exal_enemyaltmeter_status2,y
	bit	#10h
	beq	.yellow
.red	lda	#209h
	bra	.stacol
.yellow
;	lda	#409h
	lda	#0809h	; lock

.stacol	sta	exal_string_col,y

.tarstr
	lda	#string_target&WM
	sta	exal_string,y	;.l	m_e_string
	lda	#string_target2&WM
	sta	exal_string2,y	;.l	m_e_string


.stastr



;----------------------------------------------------------------------------------
; Andorf?

	lda	exal_enemyaltmeter_status,y
	and	#15
	cmp	#TYPE_NULL
	bne	.noNULL

	lda	#string_null&WM
	sta	exal_string,y	;	m_e_string
	sta	exal_string2,y	;	m_e_string
.noNULL
;----------------------------------------------------------------------------------
	bra	.exit

.turn	LONGA

; set turn colour

	phx
	lda	gameframe
	and	#3
	asl	a
	tax
	lda.l	string_turn_col,x
	sta	exal_string_col,y
	plx

	lda	exal_enemyaltmeter_status,y
	and	#15
	bne	.string_turn

.string_forward

	a16
	lda	#string_forward&WM
	bra	.st0
.string_turn
	a16
	lda	#string_turn&WM
.st0	sta	exal_string,y	;	m_e_string
	a8

;--------------------------------------------------------------------------------
.exit

;�������������������������������������������������������������������������������������
; clear obj ptr
;�������������������������������������������������������������������������������������
	a8

;;;;;	ramnastyon

	PULLXYPB

	rtl



stringtab

	db	8,8	;TYPE_F	equ	0
	db	8,8	;TYPE_FL	equ	1
	db	-32,8	;TYPE_FR	equ	2

	db	8,8	;TYPE_U	equ	3
	db	8,-20	;TYPE_D	equ	4
	db	8,8	;TYPE_UL	equ	5
	db	-32,8	;TYPE_UR	equ	6
	db	8,-20	;TYPE_DL	equ	7
	db	-32,-20	;TYPE_DR	equ	8


string_locked	db	"#LOCKED",0
string_target	db	"#TARGET",0
string_turn		db	"#TURN",0
string_forward	db	"#FORWARD",0


string_locked2	db	"#(LOCKED)",0
string_target2	db	"#(TARGET)",0
string_turn2		db	"#(TURN)",0
string_forward2	db	"#(FOWARD)",0


;string_fox		db	"#FOX",0
;string_falco		db	"#FALCO",0
;string_peppy		db	"#PEPPY",0
;string_slippy	db	"#SLIPPY",0
;string_gal1		db	"#GAL1",0
;string_gal2		db	"#GAL2",0

string_null		db	0

string_turn_col	dw	0409h
		dw	0209h
		dw	0309h
		dw	0409h

;��������������������������������������������������������������������������������
ck_EaltUDLR	macro	[setvar,rotvar,varmax,FNo,LNo,RNo]

	lda	{rotvar}	; obj2obj rotY
	bit	#80H		; minus?
	bne	.m\@
.p\@	cmp	#{varmax}
	bcc	.skipF\@
	bra	.skipL\@
.m\@
	nega
	and	#0ffH
	cmp	#{varmax}
	bcc	.skipF\@
.skipR\@	lda	{RNo}
	bra	.set\@
.skipL\@	lda	{LNo}
	bra	.set\@
.skipF\@	lda	{FNo}
.set\@	sta	{setvar}
	endm



; E cursor type No.

TYPE_F	equ	0
TYPE_FL	equ	1
TYPE_FR	equ	2
TYPE_BL	equ	1
TYPE_BR	equ	2

TYPE_U	equ	3
TYPE_D	equ	4
TYPE_UL	equ	5
TYPE_UR	equ	6
TYPE_DL	equ	7
TYPE_DR	equ	8

TYPE_NULL	equ	9

scrLMT_type	equ	work1	; cursor type
scrLMT_flag	equ	work6
scrLMT_ROTX	equ	work7	; rotx view ---> object
scrLMT_ROTY	equ	work8	; roty view ---> object
offdist	equ	work9	; off ni suru distance
scrLMT_rotxbuf	equ	work5
scrLMT_rotybuf	equ	work4

setEcursor

	;in	: idX(player pointer)
	;	: x1(16bit):cursor off dist
	;	: exal_enemyaltmeter_y(8bit)
	;	: exal_enemyaltmeter_x(8bit)
	;	: exal_enemyaltmeter_objdiry(16bit)
	;	: exal_enemyaltmeter_objdirx(16bit)
	;	: exal_enemyaltmeter_type(8bit)

	;out
	;	: scrLMT_type :enemy cursor status (low 4bit=CURSOR type)

	PUSHXYP

	a8i16

	ldx	#0
	stx	scrLMT_flag	; bit7=1 off


;--------------------------------------------------------

	ldx	playpt1
	toheap	y,x

;--------------------------------------------------------
; set type
;--------------------------------------------------------

.settype	lda	exal_enemyaltmeter_type,y
	and	#0fh
	sta	scrLMT_type
	beq	.notype

	stz	tpx

	lda	exal_enemyaltmeter_objdiry+1,y
	bpl	.stY_pl

.stY_mi	pha
	lda	#4
	sta	tpx
	pla
	nega
.stY_pl	cmp	#10
	bcc	.stY0
	inc	tpx
.stY0	cmp	#64
	bcc	.stY1
	inc	tpx
.stY1

	lda	exal_enemyaltmeter_objdirx+1,y
	bpl	.stX_pl

.stX_mi	cmp	#-8
	bcs	.stX1
	lda	#8
	bra	.stX0

.stX_pl	cmp	#8
	bcc	.stX1
	lda	#10H
.stX0	ora	tpx
	sta	tpx
.stX1

	a16
	PHX
	lda	tpx
	and	#0ffH
	tax
	lda.l	typetab,x
	a8
	sta	scrLMT_type
	PLX
.notype

; set off flag

;------------------------------------------------------------------------
; set outflag

	lda	scrLMT_type
	and	#0fh
	cmp	#TYPE_F
	beq	.TYPE_F

	lda	exal_enemyaltmeter_flag,y
	ora	#exal_enemyaltmeter_flag_out
	sta	exal_enemyaltmeter_flag,y
	bra	.exit

;----------------------------------------------------------------------------------
.TYPE_F
	lda	scrLMT_type
	ora	scrLMT_flag
	sta	scrLMT_type

;clear out flag

	lda	exal_enemyaltmeter_flag,y
	and	#~exal_enemyaltmeter_flag_out
	sta	exal_enemyaltmeter_flag,y

;----------------------------------------------------------------------------------
; Andorf?

	lda	andorfdead	;BOSSstatus
	beq	.fck

	lda	scrLMT_type
	and	#15
	cmp	#TYPE_F
	beq	.NULL


; freeze no toki NULL type

.fck	km_jmpNOTgameflag	freeze,.noNULL

.NULL	lda	scrLMT_type
	and	#0f0h
	ora	#TYPE_NULL
	sta	scrLMT_type

.noNULL
;----------------------------------------------------------------------------------


.exit
;**********************************************************************************
;**********************************************************************************

	PUSHXYP

	lda	exal_enemyaltmeter_type,y
	and	#0fh
	cmp	#TYPE_F
	rlbne	.exitpos

	a16
	lda	exal_enemyaltmeter_objptr,y
	rlbeq	.exitpos

	ldx	#viewblk1

	lda	exal_markx,y
	sec
	sbc	al_worldx,x
	sta	x2
	bpl	.xpl
	nega
.xpl	sta	tpz

	lda	exal_marky,y
	sec
	sbc	al_worldy,x
	sta	y2
	bpl	.ypl
	nega
.ypl	cmp	tpz
	bmi	.y2
	sta	tpz
.y2

	lda	exal_markz,y
	sec
	sbc	al_worldz,x
	sta	z2
	bpl	.zpl
	nega
.zpl	cmp	tpz
	bmi	.z2
	sta	tpz
.z2


;------------
	stz	tpx

	lda	tpz

.loop	bit	#0f000h
	beq	.lend
	lsr	a
	inc	tpx	; shift counter
	bra	.loop
.lend

	lda	tpx

.loop2	dec	tpx
	bmi	.lend2
	lda	x2
	asra
	sta	x2
	lda	y2
	asra
	sta	y2
	lda	z2
	asra
	sta	z2
	bra	.loop2
.lend2


;	lda	x2
;	printh	X2,kawagoe
;	lda	Y2
;	printh	Y2,kawagoe
;	lda	Z2
;	printh	Z2,kawagoe



	ldy	dummyobj
	lda	al_worldx,x
	clc
	adc	x2
	sta.w	al_worldx,y
	lda	al_worldy,x
	clc
	adc	y2
	sta.w	al_worldy,y
	lda	al_worldz,x
	clc
	adc	z2
	sta.w	al_worldz,y


	ldy	#viewblk1
	ldx	dummyobj
	jsr	calc_scrpos


	ldx	playpt1
	toheap	y,x

	a16
	lda	xs
	bpl	.xs0
	lda	#0
.xs0	sta	exal_enemyaltmeter_x,y

	lda	ys
	bpl	.ys0
	lda	#0
.ys0	sta	exal_enemyaltmeter_y,y


.exitpos	a8

	PULLXYP

;**********************************************************************************
;**********************************************************************************




	PULLXYP

	rts




;��������������������������������������������������������������������������������
xzdiffs_lmt_srou

	PHP

	ai16

; calc dist xz (max 0fffh)

.ckxz	lda	al_worldx,x
	sec
	sbc.w	al_worldx,y
	bpl	.xdis0
	nega
.xdis0	bit	#0f000H
	beq	.xdis1
	lda	#0fffH
.xdis1	sta	rangexz


	lda	al_worldz,x
	sec
	sbc.w	al_worldz,y
	bpl	.zdis0
	nega
.zdis0	bit	#0f000H
	beq	.zdis1
	lda	#0fffH
.zdis1	clc
	adc	rangexz
	bit	#0f000H
	beq	.xzdis0
	lda	#0fffH
.xzdis0	sta	rangexz

	PLP
	rts

;��������������������������������������������������������������������������������
yangle_lmt_srou

;	idy: view pointer
;	idx: obj pointer
;	tpx: shift kaisu-
;out	:work0 angleX
;	:work1 angleY
;	:rangexz

	PHP

	ai16

; calc dist xz (max 0fffh)

	lda.w	al_worldx,y
	asra
	sta	tpx
	lda	al_worldx,x
	asra
	sec
	sbc	tpx
	bpl	.sx
	nega
.sx	sta	rangexz

	lda.w	al_worldz,y
	asra
	sta	tpz
	lda	al_worldz,x
	asra
	sec
	sbc	tpz
	bpl	.sz
	nega
.sz
	clc
	adc	rangexz
	sta	rangexz

	stz	tpx	; clr shift kaisu-

.xzloop	bit	#0f000h
	beq	.srxz
	lsr	a
	inc	tpx	; inc shift kaisu-
	bra	.xzloop

.srxz	sta	rangexz

;-----------------------------------------------------------------------------

	s_exg_objs
; ****

;<<>> kyori ga hanare sugiruto(>1000H) hen ni naru node, check wo ireru.

	phx
	phy
	a16
	stz	smvar_byte1

;<<>>s_obj2obj_... to onaji code.

	lda	rangexz
	sta	y1

	lda	al_worldy,x
	asra
	sta	tpy
	lda.w	al_worldy,y
	asra
	sec
	sbc	tpy

.scaledown	dec	tpx
	bmi	.calc
	asra
	bra	.scaledown

.calc	sta	x1
	jsl	arctan16_l
	ai16	
	ply
	plx
;<<>>

	clc
	adc	al_rotx,x
	sta	work0


	a8
	s_jsl	Yanglexy_l
	a16
	nega
	clc
	adc	al_roty,x
	sta	work1		;scrLMT_roty
	a8
; ****



	lda.w	al_worldx,y
	sec
	sbc	al_worldx,x
	bpl	.x0
	nega
.x0	sta	rangexz

	lda.w	al_worldz,y
	sec
	sbc	al_worldz,x
	bpl	.z0
	nega
.z0	clc
	adc	rangexz
	sta	rangexz

	s_exg_objs

	PLP

	rts

;��������������������������������������������������������������������������������
;�������������������������������������������������������������������
;-------------------------------------------------------------------;
;                                                                   ;
; Call mcallarctan16						       ;
;                                                                   ; 
;-------------------------------------------------------------------;
;�������������������������������������������������������������������
call_arctan16_l

	PHP

	a16
	jsl	arctan16_l
	sta	x1

	PLP

	rtl

;�������������������������������������������������������������������
;-------------------------------------------------------------------;
;                                                                   ;
; Calculates the enemy's direction				       ;
;                                                                   ; 
;-------------------------------------------------------------------;
;�������������������������������������������������������������������
	IFEQ	1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
arctan_e_direction
	php
	a8i16
	c_obj2obj_rotY	W,x,y,work0
	a16
	lda	work0
	bit	#80h
	bne	.my_minus
.my_plus	and	#0ffH
	cmp	#10*8
	bpl	.my_max
	bra	.my_set
.my_minus	ora	#0ff00H
	cmp	#-10*8
	bcc	.my_min
	bra	.my_set
.my_max	lda	#10*8
	lda	#0ffffH
	bra	.my_set
.my_min	lda	#-10*8
	lda	#0ffffH
	bra	.my_set
.my_set	clc
	adc	#10*8
	sta	work0
	plp
	rts
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;�������������������������������������������������������������������
;-------------------------------------------------------------------;
;                                                                   ;
; Set DAMAGE METER    		                               ;
;                                                                   ; 
;-------------------------------------------------------------------;
;�������������������������������������������������������������������

lampMAXnum	equ	10
alarmS	equ	3
alarmH	equ	1


;����������������������������������������������������������������������������������

set_dmgmeterVAL_1_srou_l	; mission mode

	PUSHXYP

	a8i16

	toheap	y,x

	lda	KHP,y		; MSB set flag:clear by Kawaguchi
	bmi	.noset

	lda	exal_HP,y
	cmp	KHP,y
	beq	.noset
	bcs	.inc

.dec	lda	KHP,y
	dec	a
	bpl	.set2
	lda	#0
	bra	.set2


.inc	lda	p1_maxHP
	sta	tpx

	lda	KHP,y
	inc	a
	cmp	tpx	;#player_HP
	bcc	.set0
.max	lda	tpx	;#player_HP
.set0

.set2	ora	#80H
	sta	KHP,y

.noset	lda	KHP,y

.exit	jsr	alarm_sound_srou

	PULLXYP

	rtl





alarm_sound_srou


;	in	exal_KHPold	: mae no HP
;		KHP		: ima no HP

	PHP

	a8i16

	lda	al_HP,x
	beq	.exit

	lda	exal_HP,y
;	beq	.exit

	cmp	#40
	beq	.cpold
	cmp	exal_KHPold,y
	bcs	.cpold

	cmp	#alarmS*4+1
	bcs	.cpold
	cmp	#alarmH*4+1
	bcc	.s1

.s2	kplsound	x,salarm_s	; sound
	bra		.cpold
.s1	kplsound	x,salarm_h	; sound


.cpold	lda	exal_HP,y
	sta	exal_KHPold,y

.exit

	PLP

	rts

	IFEQ	1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;	in	exal_KHPold	: mae no HP
;		KHP		: ima no HP

	PUSHXYP

	s_start_strat

	a8i16

	ldy	al_sword2,x

;	lda	exal_KHPold,y
;	printh	KHPold,kawagoe

;	lda	KHP,y
;	printh	KHP,kawagoe



	s_set_var	B,x1,#alarmS*4
	s_set_var	B,x2,#alarmH*4

	sm_jmp_if1screen	.onescreen
;	test_screenmode	onescreen
;	bne		.onescreen
.twoscreen
	asl		x1
	asl		x2
.onescreen
	inc		x1
	inc		x2

	lda	KHP,y
	and	#7fH
	cmp	exal_KHPold,y	; mae no HP
	beq	.exit


;	lda	exal_KHPold,y	; mae no HP

.Os1	;cmp	x1		; alarm S
	;bcc	.Os2
	lda	KHP,y		; ima no HP
	and	#7fH
	cmp	x1		; alarm S
	bcs	.exit
	bra	.s2

.Os2	;cmp	x2		; alarm H
	;bcc	.exit
	lda	KHP,y
	and	#7fH
	cmp	x2		; alarm H
	bcs	.exit
	bra	.s1

.s2	kplsound	x,salarm_s	; sound
	bra		.exit
.s1	kplsound	x,salarm_h	; sound


.exit
	lda	KHP,y
	and	#7fH
	sta	exal_KHPold,y


	PULLXYP
	rts

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC
;����������������������������������������������������������������������������������
;----------------------------------------------------------------------------------
;	calc pos
;----------------------------------------------------------------------------------
;����������������������������������������������������������������������������������
;	In 	:	idX object pointer
;		:	idY camera pointer
;	Out	:	xs
;		:	ys

	SHORTA
	LONGI

calc_scrpos_o	; use for display target

	PHP

	ai16

	lda.w	al_ox,y
	sta	viewposx
	lda.w	al_oy,y
	sta	viewposy
	lda.w	al_oz,y
	bra	calc_scrpos.enter

calc_scrpos

	PHP

	ai16

	lda.w	al_worldx,y
	sta	viewposx
	lda.w	al_worldy,y
	sta	viewposy
	lda.w	al_worldz,y

.enter	LOCAL
	sta	viewposz

	lda.w	al_rotx,y
	sta	viewrotx
	lda.w	al_roty,y
	sta	viewroty
	lda.w	al_rotz,y
	sta	viewrotz

	a8

	POLL_MARIO
	jsl		rotproj_l
	UNPOLL_MARIO

	PLP

	rts

;����������������������������������������������������������������������������������
;----------------------------------------------------------------------------------
;	set hud rot(headup display)
;----------------------------------------------------------------------------------
;����������������������������������������������������������������������������������

set_hudrot_srou_l

;	In	: idX player's pointer

	phx
	phy
	php

	a8i16

	toheap	y,x

	lda	#0
	sta	exal_hudflag,y

	a16
	km_bitcheckmissionflag	enemyrunaway
	a8
	bne	.off

	km_jmpgameflag	freeze,.off

	lda	Kenemynumber
	rlbeq	.off

	test_playerdead		1
	bne	.off

	sp_ifdisplayOFF	.off

	pl_jmp_iftransrising	x,.off,y

	sp_jmp_ifcockpit	x,.on,y

.hudon	lda	#40H
	sta	exal_hudrot+1,y

	bra	.set
.off

; hudflag
; bit0:1=L wing clash
; bit1:1=R wing clash
; bit2:1=two screen mode 0=one screen mode

; hudrot
	lda	#0
	sta	exal_hudrot+1,y
	bra	.set

.on
	lda	#0c0H
	sta	exal_hudrot+1,y

	lda	#0
	sta	exal_hudflag,y

	lda	al_rotz,x
	sta	exal_hudrot+0,y

.set	sm_jmp_if1screen	.one

	lda	exal_hudflag,y
	ora	#4
	sta	exal_hudflag,y
.one

.exit
	plp
	ply
	plx
	rtl


;����������������������������������������������������������������������������������
; �����������������������������������Ŀ
; �                                   �
; � Enemy altmeter no list no program �
; �                                   �
; �������������������������������������


;����������������������������������������������������������������������������������
initEalt_srou_l

	PUSHXYP
	s_start_strat

	a8i16

	ldy	al_sword2,x

	a16
	lda	#0
	sta	exal_enemyaltmeter_objptr,y
;	sta	exal_enemyaltmeter_OFFdist,y
	sta	exal_markx,y
	sta	exal_marky,y
	sta	exal_markz,y
	lda	#0ffffH
	sta	exal_enemyaltmeter_objdist,y
	a8

; Battle mode ?

	sm_jmp_if1screen	.notplayer

;	test_screenmode	onescreen
;	bne		.notplayer

	sp_Ealtmeter_player	x

.notplayer
	sp_Ealtmeter_on	x

.exit	PULLXYP
	rtl

;�����������������������������������������������������������������������������
;	mark inert obj
;�����������������������������������������������������������������������������
addEaltlist_inert_l

aeai_dist	equ	work9
aeai_x	equ	work8
aeai_y	equ	work7
aeai_z	equ	work6

	s_start_strat

	PUSHXYP
	a8i16

	toheap	y,x

	a16
	lda	exal_enemyaltmeter_objptr,y
	a8
	rlbne	.exit

;----------------------------------------------------------------------------------

	lda	gameframe
	bit	#31
	rlbne	.addElist

;----------------------------------------------------------------------------------

	PHX
	PHY

	a16

	lda	#0ffffh
	sta	aeai_dist

	ldx	dummyobj
	ldy	inertlistptr
	rlbeq	.noinert


.loop	lda.w	i_flags,y
	bit	#if_target
	beq	.next
	bit	#if_exists	;path ga ugoite ireba ADD sinakutemo iihazu.
	bne	.next

	lda.w	i_worldx,y
	sta	al_worldx,x
	lda.w	i_worldy,y
	sta	al_worldy,x
	lda.w	i_worldz,y
	sta	al_worldz,x

	PHY
	ldy	#viewblk1
	s_jsl	xzdiffs_l
	a16
	PLY

;*******************************************************
; chikaku ni ite sonzai sitenakereba add sinai!

	lda	rangexz
	cmp	#2000
	bcc	.noreset

;*******************************************************

 
	lda	rangexz
	cmp	aeai_dist
	bcs	.noreset
	sta	aeai_dist


	lda	al_worldx,x
	sta	aeai_x
	lda	al_worldy,x
	sta	aeai_y
	lda	al_worldz,x
	sta	aeai_z

.noreset

.next	lda.w	_next,y
	tay
	bne	.loop



.noinert	PLY
	PLX



	lda	aeai_dist
	sta	exal_markdist_inert,y
	lda	aeai_x
	sta	exal_markx_inert,y
	lda	aeai_y
	sta	exal_marky_inert,y
	lda	aeai_z
	sta	exal_markz_inert,y

;----------------------------------------------------------------------------------
.addElist

	toheap	y,x

	ldx	dummyobj

	a16
	lda	exal_markdist_inert,y
	cmp	#0ffffh
	beq	.exit

	lda	exal_markx_inert,y
	sta	al_worldx,x
	lda	exal_marky_inert,y
	sta	al_worldy,x
	lda	exal_markz_inert,y
	sta	al_worldz,x
.nomark	a8

.addElist2

;*******************************************************
; chikaku ni ite sonzai sitenakereba add sinai!

	a16
	lda	exal_markdist_inert,y
	cmp	#2000
	a8
	bcc	.exit

;*******************************************************

	jsl	addEaltlist_p2_l

;----------------------------------------------------------------------------------

.exit	PULLXYP

	rtl

;����������������������������������������������������������������������������������

;ealtlist_num	equ	10
;ealtlist_sizeof	equ	ealtlist_num*ealtlist_size
;----------------------------------------------------------------------------------
aEa_objptr		equ	work9
aEa_objdiry		equ	work6
aEa_objdirx		equ	work5
aEa_currentobjdiry	equ	work4+1
aEa_currentobjdirx	equ	work4+0
aEa_objdist_ck	equ	work3
aEa_enemyatmeter_nolock		equ	work2


;using	scrLMT_ROTX	:	work7
;	scrLMT_ROTY	:	work8


addEaltlist_p2_l

	PUSHXYPB
	BANK7E

	s_start_strat

	a8i16

	lda	#exal_enemyaltmeter_flag_nolock
	sta	aEa_enemyatmeter_nolock	; lock on sinai

	bra	addEaltlist_p1_l.enter

addEaltlist_p1_l

;	in	:	idX=object's pointer

	PUSHXYPB
	BANK7E

	s_start_strat

	a8i16

	stz	aEa_enemyatmeter_nolock	; lock on suru.

.enter	LOCAL

;�������������������������������������������Ŀ
;�player kara object no kyori wo keisan suru.�
;���������������������������������������������

	stx	aEa_objptr

;�����������������������������������������������������������������������������
;************ read current obj dist & dir

	ldy	playpt1

	toheap	y,y

;�����������������������������������������������������������������������������
; locked?
	lda	exal_enemyaltmeter_flag,y
	bit	#exal_enemyaltmeter_flag_locked
	rlbne	.noset

;�����������������������������������������������������������������������������
; cursor ON!

	s_and_alvar	B,y,exal_enemyaltmeter_status,#7fh

	a16
	lda	exal_enemyaltmeter_objdist,y
	sta	rangexz
	a8

;************ calc dir

	ldy	#viewblk1

	jsl	xzdiffs_l

	a16
	lda	rangexz
	sta	aEa_objdist_ck
	a8
	jsr	yangle_lmt_srou
	a16
	lda	work1
	sta	aEa_objdiry
	lda	work0		;scrLMT_rotx
	sta	aEa_objdirx
	a8

;************ calc postion

;*****************************************************************************

	PHX	;>>>>

;*****************************************************************************

	a16

;--------------------------------------------------------
; roty no limitter
;--------------------------------------------------------

.rotylmt	ldx	#0

.ry1	lda	aEa_objdiry
	sta	aEa_objdiry

	bmi	.miy1

.ply1	cmp.l	scrlmt_1y+4,x
	bcc	.nolmty
	inc	scrLMT_type
	lda.l	scrlmt_1y+0,x
	bra	.ryset

.miy1	cmp.l	scrlmt_1y+6,x
	bcs	.nolmty
	inc	scrLMT_type
	lda.l	scrlmt_1y+2,x
	bra	.ryset
.nolmty


;--------------------------------------------------------
; set x position
;--------------------------------------------------------


	lda	aEa_objdiry-1
	sta	tpy

	lda	aEa_objdiry+1
	bit	#80H
	beq	.rypl
.rymi	rol	tpy
	jsr	gettabMI
	bra	.ryadd
.rypl	rol	tpy
	jsr	gettabPL
	nega
.ryadd	clc
	adc	#bitmapwidth_1*4

.ryset	sta	xs

;--------------------------------------------------------
; rotx no limitter
;--------------------------------------------------------

.rotxlmt
	ldx	#0

	lda	aEa_objdiry
	bpl	.rx0
	cmp	#-18*100h
	bpl	.rx1
	ldx	#16
	bra	.rx1

.rx0	cmp	#21*100h
	bcc	.rx1
	ldx	#8

.rx1	lda	aEa_objdirx
	bmi	.mix1

.plx1
	cmp.l	scrlmt_1x+4,x
	bcc	.nolmtx
	inc	scrLMT_type
	lda.l	scrlmt_1x+0,x
	bra	.rxset

.mix1
	cmp.l	scrlmt_1x+6,x
	bcs	.nolmtx
	inc	scrLMT_type
	lda.l	scrlmt_1x+2,x
	bra	.rxset
.nolmtx

;--------------------------------------------------------
; set y position
;--------------------------------------------------------

	lda	aEa_objdiry-1
	sta	tpx
	lda	aEa_objdirx+1
	bit	#80H
	beq	.rxpl
.rxmi	rol	tpx
	jsr	gettabMI
	nega
	bra	.rxadd
.rxpl	rol	tpx
	jsr	gettabPL
.rxadd	sta	tpx
	asra
	asra
	PHA
	clc
	adc	tpx
	sta	tpx
	PLA
	asra
	nega
	PHA
	clc
	adc	tpx
	sta	tpx
	PLA
	asra
	clc
	adc	tpx
	clc
	adc	#bitmapheight_1*4

.rxset	sta	ys



;*****************************************************************************

	PLX	;<<<<

;*****************************************************************************







;�����������������������������������������������������������������������������

	ldx	playpt1

	a16

	toheap	y,x

;------------
; last obj alive then lock


	lda	exal_enemyaltmeter_lockobj,y	;p1_markptr
	beq	.notlock
	cmp	aEa_objptr
	bne	.notlock

	a8
	lda	exal_enemyaltmeter_flag,y
	ora	#exal_enemyaltmeter_flag_locked
	sta	exal_enemyaltmeter_flag,y
	a16
	bra	.set

.notlock
;------------

;************
;	lda	#5000		;
;	cmp	rangexz
;	bcc	.distck
;	cmp	exal_enemyaltmeter_objdist,y
;	bcc	.distck
; dir ck
;	lda	aEa_objdiry+1
;	bit	#0c0h	; out of view?
;	bne	.noset
;	lda	aEa_currentobjdiry
;	bit	#0c0h
;	bne	.set
;************ normal dist ck


.distck	lda	aEa_objdist_ck	;rangexz
	bpl	.dpl
	nega
.dpl
	cmp	exal_enemyaltmeter_objdist_ck,y
	bcs	.noset

.set	lda	aEa_objdist_ck
	sta	exal_enemyaltmeter_objdist_ck,y

	lda	rangexz
	sta	exal_enemyaltmeter_objdist,y


	PHX	;--->>>
	ldx	aEa_objptr
	txa
	sta	exal_enemyaltmeter_objptr,y
	lda.w	al_worldx,x
	sta	exal_markx,y
	lda.w	al_worldy,x
	sta	exal_marky,y
	lda.w	al_worldz,x
	sta	exal_markz,y
	PLX	;<<<---


	lda	aEa_objdirY
	sta	exal_enemyaltmeter_objdiry,y
	lda	aEa_objdirX
	sta	exal_enemyaltmeter_objdirx,y

	a8

	lda	xs
	sta	exal_enemyaltmeter_x,y
	lda	ys
	sta	exal_enemyaltmeter_y,y

	lda	scrLMT_type
	sta	exal_enemyaltmeter_type,y

; lock on suru?

	lda	exal_enemyaltmeter_flag,y
	ora	aEa_enemyatmeter_nolock
	sta	exal_enemyaltmeter_flag,y

.noset	PULLXYPB

	rtl







;����������������������������������������������������������������������������������
; explosion circle

draw_circle	PUSHYP

	a8i16

;---------------------------------------------------------------------------------

	stz	tpx

	a16
	lda	kx_circlewindowmode,y
	cmp	#winm_nothing
	a8
	rlbeq	.off

	s_jmp_alvarAND	B,y,exal_circle_flag,#exal_circle_flag_pos,.nopos

	a16
	lda	exal_circle_x,y
	sta	tpx
	lda	exal_circle_y,y
	sta	tpy
	lda	exal_circle_z,y
	sta	tpz

	a8

	jsr	ckdir_circle

	rlbcc	.off

	pl_ldy_viewblk	x
	s_push_obj	x

	ldx	dummyobj
	jsr	calc_scrpos

; calc R inc rate

	jsr	circle_path_srou_l.pc_on

	s_pull_obj	x

;.nopos
	toheap	y,x

	a16
	lda	exal_circle_step,y
	clc
	adc	tpx
	bpl	.step
	lda	#1
.step
	sta	kx_circlestep,y

	a8



	s_jmp_alsflag	x,player2,.p2
.p1	a16
	lda		xs
	clc
	adc		#player1_wx*8
	sta		xs

	lda		ys
	clc
	adc		#2*8
	sta		ys
	bra		.pp

.p2	a16
	lda		xs
	clc
	adc		#player2_wx*8
	sta		xs

	lda		ys
	clc
	adc		#15*8
	sta		ys
.pp

	a16
	lda	xs
	sta	kx_circleCX,y
	lda	ys
	sta	kx_circleCY,y
	a8

.nopos

;----------------------------------------------------------------------------------
	PULLYP
	sec
	rts


.off	PULLYP
	clc
	rts

;����������������������������������������������������������������������������������



	LONGA
	LONGI

gettabPL	PHX

	php	; push carry
	and	#1fH
	tax
	plp
	bcs	gettabMI2
	bra	gettabMI4
	LONGA
	LONGI
gettabMI	PHX
	php	; push carry
	nega
	and	#1fH
	tax
	plp
	bcc	gettabMI2
gettabMI4	lda.l	tantab,x
	bra	gettabMI3

gettabMI2	lda.l	tantab2,x

gettabMI3	and	#0ffH

	PLX
	rts


scrlmttab
scrlmt_1
scrlmt_1y

;roty
	dw	10H
	dw	bitmapwidth_1*8-10H
	dw	24*100H
	dw	-24*100H
scrlmt_1x

;rotx
;(naka)
	dw	bitmapheight_1*8-10H
	dw	20h
	dw	20*100H
	dw	-18*100H
;(hidari)
	dw	bitmapheight_1*8-26H
	dw	20H
	dw	14*100H
	dw	-20*100H
;(migi)
	dw	bitmapheight_1*8-34H-8
	dw	34H+8
	dw	13*100h	;16*100H
	dw	-13*100h	;-16*100H





; screen center pos

	dw	bitmapwidth_1*4
	dw	bitmapheight_1*4

	dw	bitmapwidth*4
	dw	bitmapvheight*4

typetab
	db	type_f,type_fl,type_bl,0,type_f,type_br,type_fr,0
	db	type_u,type_ul,type_ul,0,type_u,type_ur,type_ur,0
	db	type_d,type_dl,type_dl,0,type_d,type_dr,type_dr,0

;	db	type_f,type_fl,type_bl,0,type_f,type_br,type_fr,0
;	db	type_u,type_ul,type_ul,0,type_u,type_ur,type_ur,0
;	db	type_d,type_dl,type_dl,0,type_d,type_dr,type_dr,0



tantab	db	0>>1	;0
	db	6>>1	;1
	db	13>>1	;2
	db	18>>1	;3
	db	25>>1	;4
	db	32>>1	;5
	db	38>>1	;6
	db	44>>1	;7
	db	51>>1	;8
	db	57>>1	;9
	db	64>>1	;10
	db	71>>1	;11
	db	78>>1	;12
	db	85>>1	;13
	db	92>>1	;14
	db	99>>1	;15
	db	106>>1	;16
	db	113>>1	;17
	db	121>>1	;18
	db	128>>1	;19
	db	136>>1	;20
	db	145>>1	;21
	db	153>>1	;22
	db	162>>1	;23
	db	171>>1	;24
	db	180>>1	;25
	db	189>>1	;26
	db	200>>1	;27
	db	210>>1	;28
	db	221>>1	;29
	db	232>>1	;30
	db	243>>1	;31
tantab2
	db	3>>1
	db	9>>1
	db	16>>1
	db	22>>1
	db	28>>1
	db	35>>1
	db	41>>1
	db	48>>1
	db	54>>1
	db	61>>1
	db	67>>1
	db	74>>1
	db	81>>1
	db	88>>1
	db	95>>1
	db	102>>1
	db	109>>1
	db	117>>1
	db	125>>1
	db	133>>1
	db	141>>1
	db	149>>1
	db	158>>1
	db	166>>1
	db	176>>1
	db	185>>1
	db	194>>1
	db	204>>1
	db	215>>1
	db	226>>1
	db	238>>1
	db	249>>1

;����������������������������������������������������������������������������������
;	dec circle colour
;����������������������������������������������������������������������������������
deccol_circle

	s_start_strat

	SHORTA
	LONGI

	PUSHYP

	a8i16

	toheap	y,x

	lda	kx_circlecolR,y
	beq	.ecpR
	sec
	sbc	exal_circle_decr,y
	bpl	.ecpR0
	lda	#0
.ecpR0	sta	kx_circlecolR,y
.ecpR

	lda	kx_circlecolG,y
	beq	.ecpG
	sec
	sbc	exal_circle_decg,y
	bpl	.ecpG0
	lda	#0
.ecpG0	sta	kx_circlecolG,y
.ecpG


	lda	kx_circlecolB,y
	beq	.ecpB
	sec
	sbc	exal_circle_decb,y
	bpl	.ecpB0
	lda	#0
.ecpB0	sta	kx_circlecolB,y
.ecpB

	lda	kx_circlecolR,y
	ora	kx_circlecolG,y
	ora	kx_circlecolB,y
	beq	.off
.exit


;	a16
;	lda.w	kx_circleTR,y
;	printh	circleTr,kawagoe
;	lda	kx_circlewindowmode,y
;	printh	circlMODE,kawagoe

	PULLYP
	sec
	rts


.off	PULLYP
	clc
	rts


;����������������������������������������������������������������������������������
;	dec addcol R,G,B
;����������������������������������������������������������������������������������
deccol_addcol

	SHORTA
	LONGI

	PUSHYP

	toheap	y,x

	a8i16

;---------------------------------------------------------------------
; screen no flash

	lda	exal_scrflash,y
	rlbeq	.skip6		; clear param

;---------------------------------------------------------------------
; set deccol
;
;	lda	exal_scrflash,y
;
;	bit	#exal_scrflash_flag_white
;
;
;.decnormal	lda	#4
;	sta	exal_deccol_r,y
;	sta	exal_deccol_g,y
;	sta	exal_deccol_b,y
;.decno
;---------------------------------------------------------------------

; set add colour

	lda	exal_scrflash_flag,y
	bit	#exal_scrflash_flag_set
	rlbeq	.skip7

; white out?

	lda	exal_scrflash_flag,y
	bit	#exal_scrflash_flag_white
	beq	.notwhite

;******
;white out
	pha
	bit	#exal_scrflash_flag_white_fast
	beq	.add2
.add4	lda	#4
	bra	.add
.add2	lda	#2
.add	sta	tpx
	pla
	and	#~(exal_scrflash_flag_white_fast!exal_scrflash_flag_white!exal_scrflash_flag_set)
	sta	exal_scrflash_flag,y

	lda	exal_addcol_r,y
	clc
	adc	tpx
	bit	#~31
	beq	.setwhite
	lda	#31
.setwhite	sta	exal_addcol_r,y
	sta	exal_addcol_g,y
	sta	exal_addcol_b,y

	lda	#4
	sta	exal_deccol_r,y
	sta	exal_deccol_g,y
	sta	exal_deccol_b,y

	jmp	.exit

;******

.notwhite	bit	#exal_scrflash_flag_lock
	bne	.dolock
	bit	#exal_scrflash_flag_lockreally
	bne	.skip7

.dolock	bit	#exal_scrflash_flag_shield
	bne	.shield
	bit	#exal_scrflash_flag_dmg
	bne	.dmg


.explode	lda	#16H
	sta	exal_addcol_r,y
	lda	#12H
	sta	exal_addcol_g,y
	lda	#12H
	sta	exal_addcol_b,y
	bra	.deccol


.dmg
	lda	#1fH
	sta	exal_addcol_r,y
	lda	#0
	sta	exal_addcol_g,y
	lda	#4
	sta	exal_addcol_b,y
	bra	.deccol



.shield	lda	#0H
	sta	exal_addcol_r,y
	lda	#0H
	sta	exal_addcol_g,y
	lda	#0cH
	sta	exal_addcol_b,y

.deccol	lda	#4
	sta	exal_deccol_r,y
	sta	exal_deccol_g,y
	sta	exal_deccol_b,y

.skip5	lda	exal_scrflash_flag,y
	and	#~exal_scrflash_flag_set
	bit	#exal_scrflash_flag_lock
	beq	.skip8
	ora	#exal_scrflash_flag_lockreally
	bra	.skip8


.skip6	lda	#0
	sta	exal_addcol_r,y
	sta	exal_addcol_g,y
	sta	exal_addcol_b,y
.skip8	sta	exal_scrflash_flag,y


.skip7

;-----------------------------------------------------------------------------------
;	a8i16

; dec add colour

.R	lda	exal_addcol_r,y
	beq	.G
	sec
	sbc	exal_deccol_r,y
	bpl	.sR
	lda	#0
.sR	sta	exal_addcol_r,y
.G	lda	exal_addcol_g,y
	beq	.B
	sec
	sbc	exal_deccol_g,y
	bpl	.sG
	lda	#0
.sG	sta	exal_addcol_g,y
.B	lda	exal_addcol_b,y
	beq	.RGB
	sec
	sbc	exal_deccol_b,y
	bpl	.sB
	lda	#0
.sB	sta	exal_addcol_b,y
.RGB

.exit

;-----------------------------------------------------------------------------------
; flash off?

	lda	exal_addcol_r,y
	ora	exal_addcol_g,y
	ora	exal_addcol_b,y
	bne	.noclr

	lda	#0
	sta	exal_scrflash,y

.noclr
;-----------------------------------------------------------------------------------

	PULLYP

	rts

;����������������������������������������������������������������������������������
;	screen flash wo set suru(use path macro).
;����������������������������������������������������������������������������������
addcol_path_srou_l

aps_playpt	equ	work9	; player pointer
aps_objpt	equ	work8	; corrent pointer
aps_viewpt	equ	work7	; view pointer

	s_start_strat

	PUSHXYP

	a8i16

	ldx	playpt1

.set	toheap	y,x

	a16
	lda	kx_circlewindowmode,y
	cmp	#winm_off
	a8
	bne	.noset

	s_jmp_alvarZERO	B,y,exal_HP,.noset
	c_addcol_cam	x,explode,4,off,y

.noset

.exit	PULLXYP


	rtl


;����������������������������������������������������������������������������������
;	set circle window parameters
;����������������������������������������������������������������������������������
BOMBcircle_path_srou_l

;	using	tpx(16bit) : step offset

	s_start_strat

	PHX
	PHP

	a8i16

	ldy	#0
	sty	tpx

	ldy	playpt1

	sm_circle_pri	y,off

	PHY
	toheap	y,y
	lda	#10
	sta	exal_paletteflag_bombtimer,y
	PLY

	lda	#%11	;cgaddsub
	sta	tpy

	lda	#31
	sta	tpz	;fade off

	jsl	circle_on_srou_l

	lda	#3
	sta	tpx
	lda	#3
	sta	tpy
	lda	#2
	sta	tpz

	jsl	circle_decRGB_srou_l

	lda	#25
	sta	tpx
	sta	tpy
	lda	#31
	sta	tpz

	jsl	circle_RGB_srou_l

	jsl	circle_objpos_srou_l

	ldy	playpt1
	sm_circle_pri	y,on

	PLP

	PLX


	rtl



BIGcircle_path_srou_l


;	in	tpx(16bit) : step offset

	s_start_strat

	PHX
	PHP

	a8i16

	asl	tpx

	lda	#%11	;cgaddsub
	sta	tpy

	lda	#31
	sta	tpz	;fade off

	jsl	circle_on_srou_l

	lda	#1
	sta	tpx
	lda	#2
	sta	tpy
	lda	#2
	sta	tpz

	jsl	circle_decRGB_srou_l

	lda	#31
	sta	tpx
	sta	tpy
	sta	tpz

	jsl	circle_RGB_srou_l

	jsl	circle_objpos_srou_l


	PLP
	PLX

	rtl



warpcircle_path_srou_l


;	in	tpx(16bit) : step offset

	s_start_strat

	PHX
	PHP

	a8i16
	lda	#%11	;cgaddsub
	sta	tpy

	lda	#31
	sta	tpz	;fade off

	jsl	circle_on_srou_l

	lda	#6
	sta	tpx
	lda	#6
	sta	tpy
	lda	#3
	sta	tpz

	bra	circle_path_srou_l.enter

circle_path_srou_l

;	in	tpx(16bit) : step offset

	s_start_strat

	PHX
	PHP

	a8i16

	lda	#%11	;cgaddsub
	sta	tpy

	lda	#31
	sta	tpz	;fade off

	jsl	circle_on_srou_l

	lda	#4
	sta	tpx
	lda	#8
	sta	tpy
	lda	#8
	sta	tpz

.enter	LOCAL

	jsl	circle_decRGB_srou_l

	lda	#31
	sta	tpx
;	lda	#0
	sta	tpy

	sta	tpz

	jsl	circle_RGB_srou_l

	jsl	circle_objpos_srou_l


	PLP
	PLX

	rtl




.pc_on	LOCAL


;	in	: ldY = #viewblk1 or #viewblk2

	SHORTA
	LONGI

;	PHY
;
;	pl_ldy_viewblk	y
;
;
;	ldy	#viewblk2

	jsr	xzdiffs_lmt_srou

;	PLY
	a16

	lda	rangexz
	xba
	and	#0ffh

	bit	#0fff0h
	beq	.po0
	lda	#0fh
.po0	eor	#0ffffh
	and	#0fh
	bne	.po1
	lda	#1
.po1	sta	tpx

	a8

	rts

;----------------------------------------------------------------------------------

circle_on_srou_l

cos_step	equ	tpx	;16bit
cos_cgaddsub	equ	tpy	;8bit
cos_fade	equ	tpz	;8bit

	stratmac_start

	PUSHYP

	a8i16

	ldy	playpt1

	toheap	y,y

; yu-sen flag on?

	s_and_alvar	B,y,exal_circle_flag,#~exal_circle_flag_pos
	s_jmp_alvarAND	B,y,exal_circle_flag,#exal_circle_flag_pri,.rts

	a16
	lda	#winm_open
	sta	kx_circlewindowmode,y

	lda	al_worldx,x
	sta	exal_circle_x,y
	lda	al_worldy,x
	sta	exal_circle_y,y
	lda	al_worldz,x
	sta	exal_circle_z,y

	lda	#255
	sta	kx_circleR,y

; step offset

	lda	cos_step
	sta	exal_circle_step,y
	bpl	.cs
	lda	#1
.cs	sta	kx_circlestep,y

	txa
	sta	exal_circle_obj,y

	a8

	lda	cos_cgaddsub
	sta	kx_circleadsub,y
	lda	cos_fade
	sta	kx_circlefade,y
.rts

.exit	PULLYP

	rtl




;-----------------------------------------------------------------------------------

circle_pos_srou_l

;	tpx:pos x
;	tpy:pos y

	s_start_strat

	PUSHYP

	a8i16

	ldy	playpt1
	jsr	.set

;	sm_jmp_if1screen	.exit
;
;	ldy	playpt2
;	jsr	.set


.exit	PULLYP

	rtl



.set

	toheap	y,y

	s_jmp_alvarAND	B,y,exal_circle_flag,#exal_circle_flag_pri,.rts

	s_or_alvar	B,y,exal_circle_flag,#exal_circle_flag_pos
	a16
	lda	tpx
	sta	kx_circleCX,y
	lda	tpy
	sta	kx_circleCY,y
	a8

.rts	rts

;-----------------------------------------------------------------------------------

circle_objpos_srou_l

;in	idX:obj pointer

	s_start_strat

	PUSHYP

	a8i16

	ldy	playpt1
	jsr	.set

;	sm_jmp_if1screen	.exit
;	test_screenmode	onescreen
;	bne	.exit
;
;	ldy	playpt2
;	jsr	.set


.exit	PULLYP

	rtl



.set	toheap	y,y

	a16
	txa
	cmp	exal_circle_obj,y
	bne	.rts

	lda	al_worldx,x
	sta	exal_circle_x,y
	lda	al_worldy,x
	sta	exal_circle_y,y
	lda	al_worldz,x
	sta	exal_circle_z,y

.rts	a8
	rts



;-----------------------------------------------------------------------------------
circle_RGB_srou_l

;in	idX:obj pointer
;	tpx:R
;	tpx:G
;	tpx:B


	s_start_strat

	PUSHYP

	a8i16

	ldy	playpt1
	jsr	.set

	sm_jmp_if1screen	.exit
;	test_screenmode	onescreen
;	bne	.exit

;	ldy	playpt2
;	jsr	.set


.exit	PULLYP

	rtl




.set	toheap	y,y

	s_jmp_alvarAND	B,y,exal_circle_flag,#exal_circle_flag_pri,.rts

	s_set_alvar	B,y,kx_circlecolR,tpx
	s_set_alvar	B,y,kx_circlecolG,tpy
	s_set_alvar	B,y,kx_circlecolB,tpz

.rts	rts



;-----------------------------------------------------------------------------------

circle_decRGB_srou_l

;in	idX:obj pointer
;	tpx:decR
;	tpx:decG
;	tpx:decB

	s_start_strat

	PUSHYP

	a8i16

	ldy	playpt1
	jsr	.set

;	sm_jmp_if1screen	.exit
;
;	test_screenmode	onescreen
;	bne	.exit
;
;	ldy	playpt2
;	jsr	.set


.exit	PULLYP

	rtl


.set	toheap	y,y

	s_jmp_alvarAND	B,y,exal_circle_flag,#exal_circle_flag_pri,.rts

	s_set_alvar	B,y,exal_circle_decr,tpx
	s_set_alvar	B,y,exal_circle_decg,tpy
	s_set_alvar	B,y,exal_circle_decb,tpz

.rts	rts



;------------------------------------------------------------------------------
;	x:player's pointer
;	tpx	: xpos
;	tpy	: ypos
;	tpz	: zpos

ckdir_circle

	PUSHYP

	a8i16

	s_push_obj	x

	ldx	dummyobj

	a16
	lda	tpx
	sta	al_worldx,x
	lda	tpy
	sta	al_worldy,x
	lda	tpz
	sta	al_worldz,x
	a8

	s_pull_obj	x
	pl_ldy_viewblk	x
	s_push_obj	x


	ldx	dummyobj

	s_obj2obj_angle	x,y,al_roty,0

	lda.w	al_roty+1,y
	nega
	sec
	sbc	al_roty,x

;	printh	CIRCLEDIR,kawagoe


	clc
	adc	#40h
	rlbmi	.ok

.ng	s_pull_obj	x
	PULLYP
	clc
	rts



.ok	s_pull_obj	x
	PULLYP
	sec
	rts



































;����������������������������������������������������������������������������������
; end of file

	incfile	curdat.asm

	end
;����������������������������������������������������������������������������������

