; 94/6/28
; Author :kawaguchi

;=============================================================
;*		MARIO RAM CLEAR Sub Routine		*
;=============================================================
;R1 :MARIO RAM ADDRESS
;R2 :DATA COUNTER
MRAMClear_mc
	lm	r1,[m_x1]	;ram address
	lm	r2,[m_x2]	;counter

	mcache
.loop
	stw	[r1]	;RAM Clear
	inc	r1	; data pointer
	dec	r2	; data size /2
	bne	.loop
	inc	r1

	jmp	r11
	nop
;=============================================================
;*		Mario RAM Clear				*
;* Init: m_x1 = clear ram start address			*
;*     : m_x2 = length					*
;=============================================================
MRAMClear
	sub	r0
	ramb
	romb

	mcall	MRAMClear_mc
	nop

	stop
	nop

;=============================================================
;*		MAKE PLANET		[MISSION MAP]	*
;=============================================================
MMAKEPLANET
	sub	r0
	ramb
	romb
;********* Mario RAM Clear ************
	mcall	MRAMClear_mc
	nop

	miwt	r15,mmapmessage_l	; caution!! STOP - yajima
	nop

	stop
	nop


	IFEQ	1
;1995/1/31 :(comment)
	miwt	r1,m_planetdrawbuf
	sm	[m_planetptr],r1	;m_planetptr (R1) <<<< Planet Draw List Top Address
;********* shadow planet draw ***********
.LOOP
;R1 = Planet Draw List Address
;* shadow draw *
	miwt	r3,$80

	ldw	[r1]
	add	r3
	sms	[m_xc],r0
	sm	[m_motox],r0
	inc	r1
	inc	r1

	ldw	[r1]
	sms	[m_yc],r0
	sm	[m_motoy],r0
	inc	r1
	inc	r1

	ldw	[r1]		R0 <<< Radius Address
	sms	[m_radius],r0

	miwt	r0,shadow_spr
	sms	[msprite],r0

	miwt	r0,$2000
	sms	[m_rotx],r0
	miwt	r0,$4000
	sms	[m_rotz],r0

	Mjsl	mdrawsphere_l

	lm	r1,[m_planetptr]
	lm	r0,[m_planetlen]
	add	r1
	sm	[m_planetptr],r0

;********* Planet Draw ************

	lm	r0,[m_planetroty]
	sms	[m_roty],r0
	sub	r0
	sms	[m_rotx],r0
	sms	[m_rotz],r0
	move	r11,r1

;* planet draw *
	ldw	[r1]
	sms	[m_xc],r0
	sm	[m_sakix],r0
	inc	r1
	inc	r1

	ldw	[r1]
	sms	[m_yc],r0
	sm	[m_sakiy],r0
	inc	r1
	inc	r1

	ldw	[r1]
	sms	[m_radius],r0
	inc	r1
	inc	r1

	ldw	[r1]
	sms	[msprite],r0


	lm	r0,[m_planetroty]
	sms	[m_roty],r0

	miwt	r0,$1000
	sms	[m_rotx],r0

	sub	r0
	sms	[m_rotz],r0

;* draw planet *
	Mjsl	mdrawsphere_l

;* merge data *
	lm	r0,[m_motox]
	sms	[m_x1],r0
	lm	r0,[m_motoy]
	sms	[m_y1],r0
	lm	r0,[m_sakix]
	sms	[m_bigx],r0
	lm	r0,[m_sakiy]
	sms	[m_bigy],r0
	mcall	MMERGEPLANET_mc
	nop

;* next pointer *
	lm	r1,[m_planetptr]
	lm	r0,[m_planetcnt]
	dec	r0
	beq	.End
	sbk				;m_planetcnt <<<< R0
	miwt	r15,.loop
	nop
.end
	miwt	r15,mmapmessage_l	; caution!! STOP - yajima
	nop
	ENDC
;=============================================================
;*		MAKE PLANET	[MISSION EXPLAIN]	*
;=============================================================
MMAKEPLANET2
	sub	r0
	ramb
	romb

	Mjsl	mdrawsphere_l

	stop
	nop
;=============================================================
;*		MERGE PLANET Routine			*
;=============================================================
MMERGEPLANET
	sub	r0
	ramb
	romb

	mcall	MMERGEPLANET_mc
	nop

	stop
	nop
;=============================================================
;*		MERGE PLANET Sub Routine		*
;=============================================================
MMERGEPLANET_mc
;* init *
;(m_x1,m_y1)     = (source x,source y)	:(0~$ff)
;(m_bigx,m_bigy) = (dest x,dest y)		:(0~$ff)
;m_drawmap       = Mario RAM Base address
;m_screenhight   = (BitMapRAM hight)*8
;---------------------------------------------------------------------------
;r1 :bitmap mase
;r2 :screen hight
;r3 :source base address
;r4 :dest base address
;r5 :source address
;r6 :dest address
;r7 :next yoko slit address
;r8 :tmp
;r9 :yoko chara no kazu
;r10:tate chara no kazu
;r11:return address
;r12:loop counter
;r13:loop address
;---------------------------------------------------------------------------
	lms	r1,[m_drawmap]		;mario ram base address
	lm	r2,[m_screenheight]	;mario screen hight*8
;---------------------------------------------------------------------------
	mibt	r5,$10

;* source address calc *
;* (xpos*Vhight+ypos)*32 *
	lms	r0,[m_x1]	;x postion
	sub	r5		;center zahou wo top zahyou ni hosei
	lsr	;/2
	lsr	;/4
	lsr	;/8		;(0~FF) zahyou ---> (0~1f)
	to	r3		;R3 <--- Xpos * (Vhight*8) :V hight wa motomoto 8 bai shitearu !!
	umult	r2

	lms	r0,[m_y1]
	sub	r5		;center zahou wo top zahyou ni hosei
;;;;	umult	#8		;R0 <--- Y postion	;*8
	add	r3		;R0 <--- (Xpos*Vhight+Ypos)*8
	add	r0	;*2
	add	r0	;*4
	to	r3		;R3 <-- bitmapbase+(Xpos*Vhight+Ypos)*32
	add	r1
;---------------------------------------------------------------------------
;* dest address calc (ue 2bit ni tensou)*
;* (xpos*Vhight+ypos)*32+16 *
	lms	r0,[m_bigx]	;x postion
	sub	r5		;center zahou wo top zahyou ni hosei
	lsr	;/2
	lsr	;/4
	lsr	;/8		;(0~FF) zahyou ---> (0~1f)
	to	r4
	umult	r2		;R4 <--- xpos*(Vhight*8)

	lms	r0,[m_bigy]
	sub	r5		;center zahou wo top zahyou ni hosei
;;;	umult	#8		;R0 <--- Y postion*8
	add	r4		;R0 <--- (Xpos*Vhight+Ypos)*8
	add	r0	;*2
	add	r0	;*4
	add	r1
	to	r4		;R4 <-- bitmapbase+(Xpos*Vhight+Ypos)*32+16
	add	#15
	inc	r4
;---------------------------------------------------------------------------
;* data merge main routine
	mcache
	move	r5,r3	;moto address copy
	move	r6,r4	;saki address copy
	from	r2
	umult	#4
	move	r7,r0	;tugino tate chara no addr (screen hight *8*4)
	move	r10,#5	;yoko chara no kazu
.mergebigloop
	move	r9,#4	;tate chara no kazu
.mergeloop
	move	r12,#8	;loop counter (1chara under 2 bit data)
	move	r13,pc	;loop start
	ldw	[r5]
	inc	r5
	inc	r5
	stw	[r6]
	inc	r6
	loop
	inc	r6

	move	r12,#16
	with	r5
	add	r12
	with	r6
	add	r12
	dec	r9		;tate chara check
	bne	.mergeloop
	nop

	with	r3
	add	r7
	move	r5,r3		;next slit source address

	with	r4
	add	r7
	move	r6,r4		;next slit dest address

	dec	r10		;yoko chara check
	bne	.mergebigloop
	nop
;---------------------------------------------------------------------------
	jmp	r11
	nop
