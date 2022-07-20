
;**************************************************************
;	!!!! INITIALIZE 
;**************************************************************
;;
;;
;;	STZ	m_levelmessage
;;
;;	STZ	m_mapmessage_mode
;;	STZ	m_mapmessage_pointer
;;	STZ	m_mapmessage_counter
;;
;;
;**************************************************************
;	m-chip macros
;**************************************************************
;Msta	macro	[addr,data]		; addr = #data
;Mstz	macro	[addr]			; addr = #0
;MsetROMaddr	macro	[romaddr]		; = ROM address
;Minc	macro	[work]			; = work INC
;Mindexjmp	macro	[work]			; = jmp TABLE work
;Mjmptable	macro	[addr]			; = jmp ROM address
;Mjmp	macro	[addr]			; = JMP
;Mjsr	macro	[addr]			; = JSR
;Mjsl	macro	[addr]			; = JSL
;--------------------------------------------------------------
;Mboxfill	macro	[x,y,xcount,ycount]	; box fill
;Msetcolor	macro	[color]			; plot color
;MlineX	macro	[x,y,count]		; drawline X
;MlineY	macro	[x,y,count]		; drawline Y
;==============================================================
;
;
;
;
;
;
;--------------------------------------------------------------
Maslreg	macro	[reg]
	with	{reg}
	add	{reg}
	endm
;--------------------------------------------------------------
Mlda	macro	[addr]
	lm	r0,[{addr}]
	endm
;--------------------------------------------------------------
;Mbitcheck	macro	[addr,data]
;	iwt	r1,#{data}
;	lm	r0,[{addr}]
;	and	r1
;	endm
;	
;--------------------------------------------------------------
Msta	macro	[addr,data]
	iwt	r0,#{data}	
	sm	[{addr}],r0
	endm
	
;--------------------------------------------------------------
Mstz	macro	[addr]
	sub	r0
	sm	[{addr}],r0
	endm
	
;--------------------------------------------------------------

MsetROMaddr	macro	[romaddr]
	ibt	r0,#{romaddr}>>16	; Set BANK
	romb
	iwt	r14,#{romaddr}&WM	; Set Address
	endm

;--------------------------------------------------------------

MgetROMdata	macro
	getb	
	inc	r14
	getbh
	endm

;--------------------------------------------------------------

MgetROMdataRn macro	[rn]
	to	{rn}
	getb
	inc	r14
	to	{rn}
	getbh
	endm

;--------------------------------------------------------------

Minc	macro	[work]
	lm	r0,[{work}]
	inc	r0
	sbk
	endm

;--------------------------------------------------------------

Mindexjmp	macro	[work]
	lm	r0,[{work}]
	mult	#3	; data = data*3
	inc	r0
	to	r15
	add	r15	
	db	0ffh	; = iwt r15,[addr]
	endm

;--------------------------------------------------------------

Mjmplist	macro	[addr]
	dw	({addr})&WM
	nop
	endm

;--------------------------------------------------------------

Mjmp	macro	[addr]
	iwt	r15,#{addr}&xx
	nop
	endm

;--------------------------------------------------------------

Mjsr	macro	[addr]
	link	#4
	iwt	r15,#{addr}&xx
	nop
	endm

;--------------------------------------------------------------
Mrts	macro
	jmp	r11
	nop
	endm
	
;--------------------------------------------------------------

Mjsl	macro	[addr]
	ibt	r0,#.\@p1>>16
	sm	[m_rtl+2],r0		; Set Return Bank
	iwt	r0,#.\@p1&WM
	sm	[m_rtl+0],r0		; Set Return Address
	ibt	r8,#({addr})>>16	; JUMP ADDRESS	
	iwt	r0,#({addr})&WM
	ljmp	r8			; long jump
	nop
.\@p1
	endm

;--------------------------------------------------------------



;--------------------------------------------------------------

Mboxfill	macro	[x,y,xcount,ycount]
	iwt	r2,#{y}
	iwt	r3,#{ycount}
	mcache
.\@p1	iwt	r12,#{xcount}
	iwt	r1,#{x}
	moves	r13,r15
	loop
	plot
	dec	r3
	bne	.\@p1
	inc	r2
	endm

;--------------------------------------------------------------

Msetcolor	macro	[color]
	ibt	r0,#{color}
	colour
	endm

;--------------------------------------------------------------
MlineXloop	macro
	moves	r13,r15
	loop
	plot
	endm

;--------------------------------------------------------------
MlineX	macro	[x,y,count]
	iwt	r1,#{x}
	iwt	r2,#{y}
	iwt	r12,#{count}
	moves	r13,r15
	loop
	plot
	endm

;--------------------------------------------------------------
MlineYloop	macro
	moves	r13,r15
	plot
	inc	r2
	loop
	dec	r1
	endm

;--------------------------------------------------------------
MlineY	macro	[x,y,count]
	iwt	r1,#{x}
	iwt	r2,#{y}
	iwt	r12,#{count}
	moves	r13,r15
	plot
	inc	r2
	loop
	dec	r1
	endm

;--------------------------------------------------------------

Mstop	macro
	rpix
	stop	
	nop
	endm

;--------------------------------------------------------------

Msave_r11	macro
	sm	[m_mapmessage_rts],r11	; >>
	endm

;--------------------------------------------------------------

Mload_r11	macro
	lm	r15,[m_mapmessage_rts]	; <<
	nop
	endm

;--------------------------------------------------------------






;**************************************************************
;;-------------------------------------------------------------
;;	message only macros
;;-------------------------------------------------------------
;**************************************************************
;;
;;
;; Display Map Screen Message
;;
;;
;; << MODE >>	0 draw OFF
;;		1 openning demo mapmain
;;		2 openning demo mappause		
;;		3 map nomal-message
;;		4 map pause-message
;;
;; -- OPEN ENTRY --
;;
;;	level_NO easy/nomal/hard
;;	draw pepperFace
;;
;;		dw	message1,scrollpos
;;		dw	message2,scrollpos
;;		dw	message3,scrollpos
;;		dw	0
;;
;; -- OPEN DEMO --
;;
;;
;; -- NORMAL --
;;		
;;		check trigger-message
;;		check level-message
;;		draw pepperFace
;;
;; -- PAUSE --
;;
;;		draw playerFace
;;		draw pepperFace
;;		draw vegaFace
;;
;;
;--------------------------------------------------------------
;;
;;
;;
;;
;;
;**************************************************************
;	Display Bitmap Face
;**************************************************************


Mparam_face  macro	[xpos,ypos]
	sm	[m_spra],r0	; character Number
	iwt	r0,#{xpos}
	sm	[m_x1],r0	; draw position X
	iwt	r0,#{ypos}
	sm	[m_y1],r0	; draw position Y
	endm

;==============================================================

Mdrawface_entry	macro	[xpos,ypos,faceNo,faceOffset]
	ibt	r1,#{faceNo}
	ibt	r2,#{faceOffset}
	iwt	r3,#{xpos}
	iwt	r4,#{ypos}
	Mjsr	DrawFace
	endm

;---------------------------------------------------------------
Mdrawface_call	macro	[xpos,ypos]
	iwt	r3,#{xpos}
	iwt	r4,#{ypos}
	Mjsr	DrawFace
	endm

;---------------------------------------------------------------
Mdrawface_player	macro	[xpos,ypos]
	lm	r1[m_playernumber]	; player 0,1,2,3,4,5
	with	r1			; r1 = r1*2
	add	r1
	ibt	r2,#0
	iwt	r3,#{xpos}
	iwt	r4,#{ypos}
	Mjsr	DrawFace
	endm

;---------------------------------------------------------------
Mdrawface_partner	macro	[xpos,ypos]

	Mlda	m_partnernumber		; partner 0,1,2,3,4,5
	moves	r1,r0			; if partner = -1 then skip
	bmi	.skip\@
	nop
	with	r1			; r1 = r1*2
	add	r1
	ibt	r2,#0			; face offset
	iwt	r3,#{xpos}		; face X pos
	iwt	r4,#{ypos}		; face Y pos
	Mjsr	DrawFace
.skip\@
	endm

;**************************************************************
; 	Display Bitmap Message
;**************************************************************
;
; r1 = message NO * 2
; r2 = index offset
;
;--------------------------------------------------------------

Mindex_message macro	[table]
	dec	r1			; = -1
	dec	r1
	ibt	r0,#{table}>>16	
	romb
	sm	[m_txtdatabank],r0	; Set messagedataROM BANK

	iwt	r14,#{table}&WM		; Set Address
	with	r14
	add	r1
	getb				; get pointer
	inc	r14
	getbh
	inc	r0			; poiner skip
	inc	r0
	add	r2			
	sm	[m_txtdata],r0		; Set messagedataROM POINER

	move	r14,r0
	getb
	sm	[m_messageend],r0	; Get Endcode

	endm

;--------------------------------------------------------------

Mparam_message macro	[ct,color,width,posx,posy]
	iwt	r0,#normalfont
	sm	[m_font],r0	   ; message font
	iwt	r0,#{color}
	sm	[m_textcolour],r0  ; message color
	iwt	r0,#{width}
	sm	[m_visualwidth],r0 ; message width
	ibt	r0,#{posx}
	sm	[m_x1],r0	   ; message position X
	ibt	r0,#{posy}
	sm	[m_y1],r0	   ; message position Y
	ibt	r0,#{ct}
	sm	[m_z1],r0
	endm

;--------------------------------------------------------------


Mendset_mapmessage	macro
	lm	r1,[m_messagetimer]
	cmp	r1
	bcc	.\@p1
	nop
	ibt	r1,#0			; end of message
.\@p1	sm	[m_messageend],r1
	endm

;--------------------------------------------------------------

Minc_max7fff	macro	[addr]
	lm	r0,[{addr}]
	inc	r0
	bpl	.\@p1		; 0000 - 7fff
	nop
	dec	r0		; MAX 7fff
.\@p1	sbk
	endm
	
;--------------------------------------------------------------
Mnuki_color	macro
	sub	r0
	colour
	plot
	endm

;--------------------------------------------------------------------
Mline_color	macro
	from	r7
	colour
	plot
	endm
	
;--------------------------------------------------------------------
Mset_kado	macro

	ibt	r0,#1
	cmode
	

	move	r1,r4	; Xstart
	move	r2,r8	; Ystart
	Mnuki_color
	inc	r2
	Mline_color


	from	r4
	add	r5
	to	r1
	sub	#1	; Xend
	move	r3,r1	; copy

	move	r2,r8	; Ystart
	inc	r2
	Mline_color
	dec	r2
	Mnuki_color

	move	r1,r4	; Xstart
	move	r2,r10	; Yend
	Mnuki_color
	dec	r2
	Mline_color

	move	r1,r3	; copy		
	move	r2,r10	; Yend
	dec	r2
	Mline_color
	inc	r2
	Mnuki_color

	sub	r0
	cmode

	endm
;--------------------------------------------------------------------


Mcounter_limitinc	macro [addr,limit]
	Mlda	{addr}
	inc	r0
	ibt	r1,#{limit}
	cmp	r1
	bcc	.skip\@
	nop
	sub	r0
.skip\@	sbk
	endm

;--------------------------------------------------------------------
Mdebug_polycolor	macro

	Msetcolor 1
	Mboxfill 14*1,0,14,14
	Msetcolor 2
	Mboxfill 14*2,0,14,14
	Msetcolor 3	
	Mboxfill 14*3,0,14,14
	Msetcolor 4	
	Mboxfill 14*4,0,14,14
	Msetcolor 5	
	Mboxfill 14*5,0,14,14
	Msetcolor 6	
	Mboxfill 14*6,0,14,14
	Msetcolor 7	
	Mboxfill 14*7,0,14,14
	Msetcolor 8	
	Mboxfill 14*8,0,14,14
	Msetcolor 9	
	Mboxfill 14*9,0,14,14
	Msetcolor 10	
	Mboxfill 14*10,0,14,14
	Msetcolor 11	
	Mboxfill 14*11,0,14,14
	Msetcolor 12	
	Mboxfill 14*14,0,14,14
	Msetcolor 13	
	Mboxfill 14*13,0,14,14
	Msetcolor 14	
	Mboxfill 14*14,0,14,14
	Msetcolor 15	
	Mboxfill 14*15,0,14,14

	endm

;--------------------------------------------------------------------
Mtestmoji	macro	[message,posX,posY,color]
	db	idx_testmes_{message}
	db	{posX}
	db	{posY}
	db	{color}
	endm

;--------------------------------------------------------------------

