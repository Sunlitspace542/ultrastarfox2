;                            旼컴컴컴컴컴컴�
;�袴袴袴袴袴袴袴袴袴袴袴袴袴孤  StarFox II 팠袴袴袴袴袴袴袴袴袴袴袴袴袴袴敲
;�                           읕컴컴컴컴컴컴�                              �
;�  Copyright Argonaut Software Limited, 1993/1994.                       �
;�  All Rights Reserved.                                                  �
;픔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캘
;�  Filename:     FRIENDS.ASM                                             �
;픔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캘
;�  Description:  Code related to friends' message display and suchlike   �
;픔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캘
;�  Date:         15/6/94.                                                �
;픔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캘
;�  Author:       Dylan Cuthbert                                          �
;픔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캘
;�  Modification list:                                                    �
;�                                                                        �
;훤袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠

friend_msg_maxwidth	equ	14*8
friend_msg_xoffset	equ	10*8-8	
friend_msg_yoffset	equ	17*8+5*8/2+5
friend_face_xoffset	equ	5*8-8
friend_face_yoffset	equ	17*8+5

num_of_opening_frames equ	5
num_of_speaking_frames equ	50
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Displays friends messages
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

DisplayMessages_l
	php
	phb
	a8i16
	lda	#0
	pha
	plb

	lda.l	MessageCount
	lbeq	.finished
	lbmi	.closing
	cmp	#num_of_opening_frames+1
	bcc	.opening

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Display speaking frames
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	lda.l	MessageNumber
	jsl	DisplayFriendMessage_l

	lda	whichfriend
	asl	a
	sta	x1
	stz	x1+1
	jsl	random_l
	a16
	and	#1
	clc
	adc	x1
	tax
	lda.l	.animframes,x
	sta.l	m_spra

	jsr	.displayface
	
	a8
	lda.l	MessageCount
	inc	a
	cmp	#num_of_speaking_frames+num_of_opening_frames
	bcc	.dontcloseyet
	lda	#-num_of_opening_frames
.dontcloseyet
	sta.l	MessageCount
.finished
	plb
	plp
	rtl
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Display opening frames
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
.opening
	dec	a
	a16
	and	#255
	tax
	cmp	#1
	bne	.nsound
	phx
	lda.l	MessageNumber
	jsr	GetFriendMessageInfo

	lda	whichsound
	and	#255
	asl	a
	asl	a
	asl	a
	asl	a	; x16
	sta	x1
	lda	whichfriend
	and	#255
	clc
	adc	x1
	tax
	a8
	lda.l	.opensound,x
	ksound_a
	a16
	plx
.nsound
	lda.l	.openingframes,x
	sta.l	m_spra

	jsr	.displayface

	a8
	lda.l	MessageCount
	inc	a
	sta.l	MessageCount

	bra	.finished
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Display closing frames
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
.closing
	nega
	a16
	and	#255
	tax
	cmp	#4
	bne	.nsound2
	a8
	ksound	tsushin_end
	a16
.nsound2

	lda.l	.openingframes,x
	sta.l	m_spra

	jsr	.displayface

	a8
	lda.l	MessageCount
	inc	a
	sta.l	MessageCount

	brl	.finished

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Display the friends face
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
.displayface
	php
	a16
	lda	#friend_face_xoffset
	sta.l	m_x1
	lda	#friend_face_yoffset
	sta.l	m_y1
	a8
	call_mario	mDisplayFace
	plp
	rts
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; various tables for the animations
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
.openingframes
	db	msgopening1_spr
	db	msgopening2_spr
	db	msgopening3_spr
	db	msgopening4_spr
	db	msgopening5_spr

.closingframes
	db	msgopening5_spr
	db	msgopening4_spr
	db	msgopening3_spr
	db	msgopening2_spr
	db	msgopening1_spr

.animframes
	db	fox1_spr,fox2_spr
	db	peppy1_spr,peppy2_spr
	db	falco1_spr,falco2_spr
	db	slippy1_spr,slippy2_spr
	db	pepper1_spr,pepper2_spr
	db	andross1_spr,andross2_spr
	db	0,0
	db	pony1_spr,pony2_spr
	db	girl1_spr,girl2_spr
	db	vega1_spr,vega2_spr

.opensound
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_p_warning_0
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	0,0,0,0,0,0

; DOWN sounds
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_p_warning_2
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	0,0,0,0,0,0
; HELP sounds
	db	sport3_player_warning
	db	sport3_player_warning
	db	sport3_player_warning
	db	sport3_player_warning
	db	sport3_p_warning_1
	db	sport3_player_warning
	db	sport3_player_warning
	db	sport3_player_warning
	db	sport3_player_warning
	db	sport3_player_warning
	db	0,0,0,0,0,0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; FriendMessage_l
; initialises the above routine
; A is message number
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
FriendMessage_l
	php
	a8i16

	dec	a
	sta.l	MessageNumber
	lda	#1
	sta.l	MessageCount

	plp
	rtl

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Get's the information defined in the friends' message
; A = message number
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

GetFriendMessageInfo
	php

	ai16
	and	#255
	asl	a
	tax

	a8
	lda	#0
	pha
	plb
	a16
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; get address from table
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	lda.l	messagetable,x
	tax
	inc	a
	inc	a
	sta.l	m_txtdata


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; pull out the friend type and sound byte
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	a8
	lda.l	0+(messagetable&$ff0000),x
	sta	whichfriend
	lda.l	0+(messagetable&$ff0000)+1,x
	sta	whichsound
	sta.l	m_gamemessagetype	; Append by H.Yajima 94/11/18

	plp
	rts

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; Draws a friends' message in the bottom area of the screen
; A = message number
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

DisplayFriendMessage_l
	php
	phb

	jsr	GetFriendMessageInfo

	a16
	lda	#friend_msg_xoffset+1
	sta.l	m_x1
	lda	#friend_msg_yoffset+1
	sta.l	m_y1
	lda	#9
	sta.l	m_textcolour

	jsr	DisplayMsg

	lda	#friend_msg_xoffset
	sta.l	m_x1
	lda	#friend_msg_yoffset
	sta.l	m_y1
	lda	#14
	sta.l	m_textcolour

	jsr	DisplayMsg

	plb
	plp
	rtl

	SHORTA
	LONGI
DisplayMsg
	php
	a16

	lda.l	m_txtdata
	pha

	lda	#messagetable>>16
	sta.l	m_txtdatabank

	lda	#friend_msg_maxwidth
	sta.l	m_visualwidth

	lda	#normalfont
	sta.l	m_font

	lda.l	m_y1
	sta	y1
	call_mario	mStringHeight

	lda.l	m_y1
	sta.l	m_gamemessageheight	; Append by H.Yajima 94/11/18
	lsr	a
 	nega
	clc
	adc	y1
	sta.l	m_y1

;--------------------------------------------------------------------
	lda.l	mapmessage_setcolor	; Append by H.Yajima 94/11/22
	sta.l	m_mapmessage_color	; Append by H.Yajima 94/11/22
	call_mario	mprintboxmessage ;Append by H.Yajima 94/11/18	
;;;;;;;	call_mario	mprintWWstring	; Comment out by H.yajima 94/11/18
;--------------------------------------------------------------------

	pla
	sta.l	m_txtdata
	plp
	rts

