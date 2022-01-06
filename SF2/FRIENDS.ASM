;                            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ  StarFox II ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                              º
;º  Copyright Argonaut Software Limited, 1993/1994.                       º
;º  All Rights Reserved.                                                  º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Filename:     FRIENDS.ASM                                             º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Description:  Code related to friends' message display and suchlike   º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Date:         15/6/94.                                                º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Author:       Dylan Cuthbert                                          º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Modification list:                                                    º
;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

friend_msg_maxwidth	equ	14*8
friend_msg_xoffset	equ	10*8-8	
;;friend_msg_yoffset	equ	17*8+5*8/2+5+6
friend_face_xoffset	equ	5*8-8+1
friend_face_yoffset	equ	17*8+5+6+4	; change yajima 1994.4.12
friend_face_yoffset2	equ	3*8+5+6
friend_face_yoffset3	equ	17*8+5+6+4-12	; position when bossmeter is displayed
friend_target_threshold equ	146
friend_target_threshold2 equ	124

num_of_opening_frames equ	4
num_of_speaking_frames equ	50	50
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Displays friends messages
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Display speaking frames
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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

	lda	whichsound
	and	#255
	cmp	#sound_down
	bne	.oknorm
	lda.l	.animframesdown,x
	sta.l	m_spra
	bra	.cont
.oknorm
	lda.l	.animframes,x
	sta.l	m_spra
.cont
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
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Display opening frames
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Display closing frames
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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

	lda.l	.openingframes-1,x
	sta.l	m_spra

	jsr	.displayface

	a8
	lda.l	MessageCount
	inc	a
	sta.l	MessageCount

	brl	.finished

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Display the friends face
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.displayface
	php
	a16
	lda	#friend_face_xoffset
	sta.l	m_x1
;;	lda	#friend_face_yoffset
	lda.l	friendmsg_y
	sta.l	m_y1
	a8
	call_mario	mDisplayFace
	plp
	rts
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; various tables for the animations
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.openingframes
	db	msgopening1_spr
	db	msgopening2_spr
	db	msgopening3_spr
	db	msgopening4_spr
;	db	msgopening5_spr

.closingframes
	db	msgopening4_spr
	db	msgopening3_spr
	db	msgopening2_spr
	db	msgopening1_spr

;	db	msgopening5_spr

.animframes
	db	fox1_spr,fox2_spr
	db	peppy1_spr,peppy2_spr
	db	falco1_spr,falco2_spr
	db	slippy1_spr,slippy2_spr
	db	pepper1_spr,pepper2_spr
	db	andross1_spr,andross2_spr
	db	pepper3_spr,pepper4_spr
	db	pony1_spr,pony2_spr
	db	girl1_spr,girl2_spr
	db	explain_spr,explain_spr
	db	wolf1_spr,wolf2_spr
	db	pig1_spr,pig2_spr
	db	monkey1_spr,monkey2_spr
	db	chameleon1_spr,chameleon2_spr


.animframesdown
	db	fox1_spr,fox2_spr
	db	peppy1_spr,peppy2_spr
	db	falco1_spr,falco2_spr
	db	slippy1_spr,slippy2_spr
	db	pepper3_spr,pepper4_spr
	db	andross1_spr,andross2_spr
	db	pepper3_spr,pepper4_spr
	db	pony1_spr,pony2_spr
	db	girl1_spr,girl2_spr
	db	explain_spr,explain_spr
	db	wolfdead_spr,msgopening4_spr
	db	pigdead_spr,msgopening4_spr
	db	monkeydead_spr,msgopening4_spr
	db	chameleondead_spr,msgopening4_spr

.opensound
	db	sport3_partner_message
	db	sport3_partner_message
	db	sport3_partner_message
	db	sport3_partner_message
	db	sport3_p_warning_0
	db	sport3_androf_voice_0
	db	sport3_partner_message
	db	sport3_partner_message
	db	sport3_partner_message
	db	sport3_partner_message
	db	sport3_wolf_voice
	db	sport3_pigma_voice
	db	sport3_andrew_voice
	db	sport3_leon_voice
	db	0,0

; DOWN sounds
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_p_warning_2
	db	sport3_androf_voice_2
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_wolf_voice
	db	sport3_pigma_voice
	db	sport3_andrew_voice
	db	sport3_leon_voice
	db	0,0
; HELP sounds
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_p_warning_1
	db	sport3_androf_voice_1
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	sport3_partner_warning
	db	0,0

; SPECIAL sounds
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message
	db	sport3_player_message

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; FriendMessage_l
; initialises the above routine
; A is message number
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
FriendMessage_l
	php
	a8i16

	dec	a
	sta.l	MessageNumber
	lda	#1
	sta.l	MessageCount

	lda	#friend_face_yoffset
	sta.l	friendmsg_y

	lda.l	bossmaxHP
	beq	.nohp
	lda	#friend_face_yoffset3
	sta.l	friendmsg_y
.nohp

	lda.l	p1_TargetY
	cmp	#friend_target_threshold
	bmi	.norm

.unnorm
	lda	#friend_face_yoffset2
	sta.l	friendmsg_y
	lda	#1
	bra	.set
.norm	lda	#0
.set	sta.l	message_lastpos
	lda	#0
	sta.l	friendmsg_y+1

	plp
	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Get's the information defined in the friends' message
; A = message number
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

GetFriendMessageInfo
	php

	ai16
	and	#255
	asl	a
	tax

	a8


	lda	#friend_face_yoffset
	sta.l	friendmsg_y

	lda.l	bossmaxHP
	beq	.nohp
	lda	#friend_face_yoffset3
	sta.l	friendmsg_y
.nohp

	lda.l	message_lastpos
	beq	.onechk

	lda	#friend_face_yoffset2
	sta.l	friendmsg_y

	lda.l	p1_TargetY
	cmp	#friend_target_threshold2
	bmi	.swap
	bra	.norm
.onechk
	lda.l	p1_TargetY
	cmp	#friend_target_threshold
	bmi	.norm
.swap
	lda.l	message_lastpos
	eor	#1
	sta.l	message_lastpos
.norm

	lda	#0
	pha
	plb
	a16
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; get address from table
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	lda.l	messagetable,x
	tax
	inc	a
	inc	a
	sta.l	m_txtdata


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; pull out the friend type and sound byte
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	a8
	lda.l	0+(messagetable&$ff0000),x
	sta	whichfriend
	lda.l	0+(messagetable&$ff0000)+1,x
	sta	whichsound
	sta.l	m_gamemessagetype	; Append by H.Yajima 94/11/18

	lda	whichfriend		; Append by H.Yajima 95/6/22
	cmp	#friend_andross		; Append by H.Yajima 95/6/22
	bne	.skip			; Append by H.Yajima 95/6/22
	lda	#0			; Append by H.Yajima 95/6/22
	sta.l	m_gamemessagetype	; Append by H.Yajima 95/6/22
.skip

	plp
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Draws a friends' message in the bottom area of the screen
; A = message number
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DisplayFriendMessage_l
	php
	phb

	jsr	GetFriendMessageInfo

	a16

;;;;	lda	#friend_msg_xoffset+1
;;;;	sta.l	m_x1
;;;;	lda	#friend_msg_yoffset+1
;;;;	sta.l	m_y1
;;;;	lda	#9
;;;;	sta.l	m_textcolour
;;;;	jsr	DisplayMsg

	lda	#friend_msg_xoffset
	sta.l	m_x1
;;	lda	#friend_msg_yoffset
	lda.l	friendmsg_y
	clc
	adc	#5*8/2
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


;----------------------------------------------------------------
; routines for the credit sequence
;
; credits_count1 = character count for current line
; credits_count2 = number of complete lines currently displayed
; credits_count3 = temporary counter used to count lines
; credits_count4 = temporary counter used to wait at the end of lines
; (all counts should be zero'd to initiate)

techdata_x	equ	10
techdata_y	equ	180
techdata_eolpause equ 20		;ending no gyou kan timer

;----------------------------------------------------------------

showtechdata_l
	php
	phb
	a8
	lda	#$7e
	pha
	plb

	lda	credits_on
	lbeq	.exit

	ai16

	lda	credits_count2
	asl	a
	asl	a
	asl	a
	nega
	adc	#techdata_y
	sta.l	m_y1

	lda	credits_count4
	sec
	sbc	#techdata_eolpause-4
	bmi	.noscroll
	asl	a
	sta	x1
	lda.l	m_y1
	sec
	sbc	x1
	sta.l	m_y1
	
.noscroll

	inc	credits_count1

	stz	credits_count3	; zero the line count

	ldx	#0
.lp
	lda.l	technical_data,x
	cmp	#-1
	lbeq	.out
	phx
	tax
	clc
	adc	#(technical_data_text&WM)+1
	sta.l	m_txtdata


	lda.l	m_y1
	cmp	#techdata_pos
	bpl	.okdo

	lda.l	m_y1
	clc
	adc	#8
	sta.l	m_y1
	inc	credits_count3
	bra	.nxt
.okdo

	lda	#techdata_x
	sta.l	m_x1

	lda.l	technical_data_text,x
	sta	x1
	and	#$f
	sta.l	m_textcolour

	lda	#smallfont
	sta.l	m_font

	lda	x1
	bit	#tdflag_LARGE
	beq	.notlarge
	lda	#atozfont
	sta.l	m_font
.notlarge
	lda	x1
	bit	#tdflag_SMALL
	beq	.notsmall
	lda	#displayfont
	sta.l	m_font
.notsmall
	lda	x1
	bit	#tdflag_FLASH
	beq	.notflashing
	lda	credits_count1
	and	#7
	cmp	#6
	bmi	.notflashing
	lda	#0
	sta.l	m_textcolour
.notflashing

	lda	#technical_data_text>>16
	sta.l	m_txtdatabank
	jsr	techdataline

.nxt
	plx
	inx
	inx
	brl	.lp
.out


; --- keep that last line active
	lda	credits_count3
	dec	a
	cmp	credits_count2
	bne	.noreset
;	stz	credits_count4
;	inc	credits_count5
;	lda	credits_count5
;	cmp	#50
;	bne	.noreset
;	stz	credits_count1
;	stz	credits_count2
;	stz	credits_count3
;	stz	credits_count4
;	stz	credits_count5
.noreset


	lda	#techdata_Pos-1
	sta	cly2
	sta.l	m_ybot
	lda	#(techdata_Pos-techdata_pos2)/2+techdata_pos2-15
	sta	vanishy
	sta.l	m_vanishy
	movi	(128*16384/8/(techdata_Pos/8)),ytclip

	lda	screenmode
	ora	#sm_midscreenirq!sm_creditsirq
	sta	screenmode

;	lda	#techdata_pos2+8
;	sta	screenon_position

;	lda	gameframe
;	and	#7
;	cmp	#2
;	bcc	.exit

	call_mario	mclrforcredits_l

	lda	cs_shapename
	lbeq	.exit
	sta.l	m_txtdata
	lda	#batabata_name>>16
	sta.l	m_txtdatabank

	lda	#24
	sta.l	m_y1
	lda	#9
	sta.l	m_textcolour

	lda	#32767
	sta.l	m_z1
	lda	#atozfont
	sta.l	m_font

	call_mario	mstringlen_l

	lda.l	m_bigz
	nega
	inc	a
	lsr	a
	clc
	adc	#224/2
	sta.l	m_x1

	lda	#15
	sta.l	m_textcolour
	lda	cs_shapename
	sta.l	m_txtdata

	call_mario	mprintstringn_l


.exit
	plb
	plp
	rtl


; --- display a line of technical data
; --- also displays cursor if this is the line currently being rolled out

techdataline
	php
	ai16

	lda	credits_count3	; how many lines have we displayed?
	cmp	credits_count2
	beq	.cursorline
	lbpl	.exit		; don't display any more

; --- display a full line
.fullline

	lda	#32767
	sta.l	m_z1

	call_mario	mstringlen_l

	lda.l	m_bigz
	asr	a
	eor	#255
	sec
	adc	#224/2
	sta.l	m_x1

	call_mario	mprintstringn_l

	lda.l	m_y1
	clc
	adc	#8
	sta.l	m_y1

	brl		.exit

; --- display a line character by character with a cursor
.cursorline
	lda	credits_count1
	beq	.not_eol

;	lda	credits_count4
;	cmp	#techdata_eolpause-(techdata_eolpause/4)
;	bmi	.nocolchg
;	lda.l	m_textcolour
;	and	#$f
;	ora	#$f00
;	sta.l	m_textcolour
.nocolchg

	lda	credits_count1
	sta.l	m_z1

	call_mario	mstringlen_l

	lda.l	m_bigz
	asr	a
	eor	#255
	sec
	adc	#224/2
	sta.l	m_x1

	call_mario	mprintstringn_l

	lda.l	m_z1
	beq	.not_eol
	inc	credits_count4
	lda	credits_count4
	cmp	#techdata_eolpause
	bne	.not_eol
	stz	credits_count4
	stz	credits_count1
	inc	credits_count2
.not_eol

; --- display flashing cursor

	lda.l	m_z1
	bne	.noflash

	lda	credits_count1
	and	#2
	beq	.noflash

	lda	#$fff0
	sta.l	m_textcolour
	lda	#.space&WM
	sta.l	m_txtdata
	lda	#.space>>16
	sta.l	m_txtdatabank
	lda	#10
	sta.l	m_z1
	call_mario	mprintstringn_l
.noflash
.exit
	inc	credits_count3
	plp
	rts

.space	db	"  ",0


