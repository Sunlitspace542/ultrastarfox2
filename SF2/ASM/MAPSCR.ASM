;                            �������������Ŀ
;���������������������������͵  StarFox II ������������������������������ͻ
;�                           ���������������                              �
;�  Copyright Argonaut Software Limited, 1993.                            �
;�  All Rights Reserved.                                                  �
;������������������������������������������������������������������������Ķ
;�  Filename:     MAPSCR.ASM                                              �
;������������������������������������������������������������������������Ķ
;�  Description:  The Map Screen (Mission Control).                       �
;������������������������������������������������������������������������Ķ
;�  Date:         18/6/93.                                                �
;������������������������������������������������������������������������Ķ
;�  Author:       Dylan Cuthbert                                          �
;������������������������������������������������������������������������Ķ
;�  Modification list:                                                    �
;�                                                                        �
;������������������������������������������������������������������������ͼ

	IFEQ	1
	incpublics	mapscr.ext


;  �����������������������������ͻ
;  �                             ǿ
;  � VRAM Layout For MAP Screen  ��
;  �                             ��
;  �����������������������������ͼ�
;   �������������������������������

m_obj_cgx	equ	(0*k)/2
m_bg1_cgx	equ	(16*k)/2
m_bg2_cgx	equ	(16*k)/2
m_bg3_cgx	equ	(32*k)/2
m_bg1_scr	equ	(40*k)/2
m_bg2_scr	equ	(48*k)/2
m_bg3_scr	equ	(56*k)/2

m_bg1_cgx_len	equ	16*k
m_bg2_cgx_len	equ	16*k
m_bg3_cgx_len	equ	8*k
m_obj_cgx_len	equ	16*k
m_bg1_scr_len	equ	8*k
m_bg2_scr_len	equ	8*k
m_bg3_scr_len	equ	2*k



mapscreen_l
	a8i16
	jsl	mapscreensetup_l
	jsr	init_blox
	jsr	add_blox


.self
	lda	#iv_mapirq
	sta	trans_flag
	waittrans

	TESTJOYPAD	START
	bne	.exitreturn

	jsr	process_blox

	bra	.self

.exitreturn
	lda	#-1
	sta	fadedir
.loop
	lda	#iv_mapirq
	sta	trans_Flag
	waittrans
	lda	fade
	bne	.loop

	screen_off

	rtl



;------------------------------------------------------
; set the screen up for the map

mapscreensetup_l
	php
	a8i16

	disable
	stz	nmitimen
	stz	trans_flag
	stz	fade

	lda	timeupr		; clear IRQ's
	a16
	lda.l	mflags

	a8
; clear video RAM:
	screen_off

	stz	cgadd
	stz	vmaddl
	stz	vmaddh
	lda	#$80
	sta	inidisp
	sta	vmainc

; clear VRAM
	lda	#0
	ldx	#127*256
.li	sta	vmdatal
	dex
	bne	.li

; set character map:
	a8i16

; set PPU to point to the screen
	lda	#(m_bg1_cgx>>12)!((m_bg2_cgx>>8)&$f0)
	sta	bg12nba
	lda	#(m_bg3_cgx>>12)
	sta	bg34nba

; set screen base address
	lda	#m_bg1_scr>>8
	sta	bg1sc
	lda	#m_bg2_scr>>8
	sta	bg2sc
	lda	#m_bg3_scr>>8
	sta	bg3sc

; set object base address
	lda	#(0<<5)!(m_obj_cgx>>13)
	sta	objsel

; set window logic, position & size
	stz	w12sel
	stz	w34sel
	stz	wobjsel
	stz	wbglog
	stz	wobjlog
	stz	tmw
	stz	tsw
	stz	wh0
	stz	wh1
	stz	ts


; transfer bg1 data
;	decvramnotrans	0,m_bg1_cgx,mapa_ccr,m_bg1_cgx_len
; transfer bg1 screen
;	decvramnotrans	0,m_bg1_scr,mapa_pcr,m_bg1_scr_len
; transfer bg3 data
;	decvramnotrans	0,m_bg3_cgx,bg3_ccr,m_bg3_cgx_len
; transfer bg3 screen
;	decvramnotrans	0,m_bg3_scr,bg3_pcr,m_bg3_scr_len
; transfer map objects
;	decvramnotrans	0,m_obj_cgx,mapobj_ccr,m_obj_cgx_len
; transfer palette
;	dmacgram	0,0,map_pac,15*16

; enable joypads + hdma tables
	ldx	#gamevw_pos
	stx	vtimel
	ldx	#0
	stx	htimel

	lda	#0
	sta	hdmaen

	lda	#%101
	sta	tm
	lda	#1!(1<<3)
	sta	bgmode

	stz	fade
	lda	#1
	sta	fadedir

	lda	rdnmir
	lda	#%00110001
	sta	nmitimen
	plp
	enable
	rtl

;--------------------------------------------------------------
; initialise object blocks..

init_blox	php
	phb
	a8
	lda	#$7e
	pha
	plb

	ai16
	stz	oblist

	fmtfreelst.w	obfree,obblocks&WM,number_ob,ob_sizeof

	plb
	plp
	rts

;--------------------------------------------------------------
; go through the list of blox and process them

process_blox
	php
	phb
	a8i16
	lda	#$7e
	pha
	plb

	ldx	oblist
	beq	.nowt


.nowt
	lda	#30
	sta	sprites
	sta	sprites+1
	sta	sprites+2
	sta	sprites+3
	
	plb
	plp
	rts

;--------------------------------------------------------------
; adds blox taken from the map pointed to with x
add_blox
	php
	phb
	a8i16
	lda	#$7e
	pha
	plb

	ldx	#map1&WM
.again
	lda.l	mapscreenbase,x
	txy
	iny
	a16
	and	#255
	tax
	a8
	jmp	(.tab,x)
.tab	jmplist		ms
	jmpentry	.end
	jmpentry	.addbase

	SHORTA
.addbase	tyx
	jsr	addmapobjspr
	inx
	inx
	inx
	inx
	inx
	inx	; add 6
	jmp	.again

	SHORTA
.end	bra	.overanddonewith

.overanddonewith
	plb
	plp
	rts

;--------------------------------------------------------------
; x points to address containing address of sprite list
addmapobjspr
	php
	phx
	a16
	lda.l	mapscreenbase+4,x
	pha
	lda.l	mapscreenbase,x
	pha
	lda.l	mapscreenbase+2,x
	pha
	ldx	oblist
	l_add.w	oblist,obfree,.nocando

	pla
	sta.w	ob_path,x

	pla
	sta.w	ob_spr,x

	pla
	a8
	sta.w	ob_x,x
	xba
	sta.w	ob_y,x

	stz.w	ob_flags,x
	
	txy	

	plx
	plp
	rts

.nocando	blink	4

;-------------------------------------------------------------
;-------------------------------------------------------------
; data:
	incfile	ASM\maps\maps.asm

	ENDC
