
	incpub	ramstuff


;-------------------------------------------------------
; Locate ramstuff into ram

xrstart =	*
	org	xroutines,$8000*(xrstart>>16)+(xrstart&$7fff)
;---------------------------------------------------------

	dw	0	; debugger data (write to .l xroutines)
	dw	0
	dw	0
	dw	0	; 8 bytes
	incfile ASM\hdmatabs.asm

	incfile ASM\irq.asm

	incfile ASM\showview.asm

;;;;	incfile ASM\hdmatabs.asm

	incfile ASM\mem.asm

	incfile ASM\ramsrou.asm

	incfile ASM\coldet.asm

	incfile ASM\ramspr.asm

	incfile ASM\mmtbl.asm

	incfile ASM\kramcalc.asm

	incfile ASM\ramsound.asm

	incfile ASM\yjradar.asm

	incfile ASM\raster.asm

	incfile ASM\rammes.asm
;-------------------------------------
; POLL MARIO ROUTINE ------------------
;-------------------------------------
	shorta
	longi
pollmario_l
	phb
	lda	#0
	pha
	plb

	lda	pollstack
	bne	.exit

;�����������������������������������������������������������������
; mario chip running?

	lda	m_sfr
	and	#$20
	beq	.nopoll

;�����������������������������������������������������������������
; tell the chip to stop when it gets the chance

	ramnastyoff
	lda	#1
	sta.l	m_mariopoll

	nastyon

;�����������������������������������������������������������������
; wait for chip to stop

;	a16
;	lda.l	xroutines
;	inc	a
;	sta.l	xroutines
;	a8

.stillgoing
	IFNE	polllaginfo
	a16
	lda.l	xroutines
	clc
	adc	#5+5+5+5+2+3+3+2+2+3+3+3
	sta.l	xroutines
	lda.l	xroutines+2
	adc	#0
	sta.l	xroutines+2
	ENDC
	a8
	lda	m_sfr
	and	#$20
	bne	.stillgoing	; wait for chip to stop

	lda.l	m_mariopoll
	eor	#1
	sta.l	m_mariopoll

.exit
	inc	pollstack
.nopoll
	nastyoff
	plb
	rtl

;-------------------------------------
; UNPOLL MARIO ROUTINE ----------------
;-------------------------------------
	shorta
	longi
unpollmario_l
;�������������������������������������������������������������������
; we've called our program so now to set mdrawlist running again
	phx
	phb
	lda	#0
	pha
	plb

	dec	pollstack
	bne	.alreadyfinished

	lda.l	m_mariopoll		; if zero then mario program
	beq	.alreadyfinished	; actually finished rather than was interrupted

	lda	#0
	sta.l	m_mariopoll		; clear the poll'ed flag

	lda.l	m_pollcon+2
;	lda	#mdrawloop_con>>16
	sta	m_pbr
	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
	a16
	lda.l	m_pollcon
	tax
	a8
;	ldx	#mdrawloop_con&WM
	stx	mr15

.alreadyfinished

	plb
	plx
	
	rtl
	

;-------------------------------------
; RUN MARIO ROUTINE ------------------
;-------------------------------------
	shorta
	longi
runmario_l
	sta	mariocodebank	; code bank

	phb
	lda	#0
	pha
	plb

	lda	m_sfr
	and	#$20
	beq	.nopoll

;���������������������������������������������������������������������
; if the mario chip is already running (mdrawloop)
; then poll it to stop, execute the wanted routine, and then continue.

	storenasty

	ramnastyoff
	lda	#1
	sta.l	m_mariopoll
	nastyon
.stillgoing
	lda	m_sfr
	and	#$20
	bne	.stillgoing	; wait for chip to stop

;��������������������������������������������������������������������
; ok, the chip is ready for our evil deed

	lda	mariocodebank
	sta	m_pbr

	stz	m_sfr	; = 3030h Append By H.Yajima 1994.10.12
	stx	mr15	; GO!
.stillgoing2
	lda	m_sfr
	and	#$20
	bne	.stillgoing2	; wait for our program to stop

;�������������������������������������������������������������������
; we've called our program so now to set mdrawlist running again

	lda.l	m_mariopoll		; if not zero then mario program
	bne	.alreadyfinished	; actually finished rather than was interrupted

	lda.l	m_pollcon+2
;	lda	#mdrawloop_con>>16
	sta	m_pbr
	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
	a16
	lda.l	m_pollcon
	tax
	a8
;	ldx	#mdrawloop_con&WM
	stx	mr15
	bra	.running

.alreadyfinished
	lda	#0
	sta.l	m_mariopoll		; clear the poll'ed flag
.running
	restorenasty

	plb
	rtl

;�������������������������������������������������������������������
; normal call_mario case (not parallel)

.nopoll
	lda	mariocodebank
	sta	m_pbr

	storenasty
	nastyon

	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
	stx	mr15
.dowait	lda	m_sfr
	and	#$20
	bne	.dowait

	restorenasty
	plb
	rtl


cop	blink




do_3d_display1_l
;;	ai16
;;	lda	defaultID
;;	sta.l	m_defaultID
;;	a8
;;	jsl	getview1_l
;;
;;	lda	drawmap+1
;;	lsr	a
;;	lsr	a
;;	sta	m_scbr
;;
;;	a16
;;	lda	drawmap
;;	sta.l	m_drawmap
;;
;;	lda	#m_dustpnts1&WM
;;	sta.l	m_dustptr
;;
;;	lda	#0
;;	sta.l	m_mariopoll
;;	a8
;;
;;	lda	gamemode
;;	sta.l	m_pfm
;;			
;;	jsl	mshowgrid_l
;;
;;	a8i16
;;
;;	lda	#mdo_3d_display>>16
;;	ldx	#mdo_3d_display&WM
;;	sta	m_pbr
;;	nastyon
;;	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
;;	stx	mr15
;;	jsr	parallel_stuff_1
;;
;;	a8
;;.dowait
;;	lda	m_sfr
;;	and	#$20
;;	bne	.dowait
;;	nastyoff
;;
;;	rtl


;����������������������������������������������������
; This sets the 3d display drawing process going.
; If your code is in ram and doesn't access rom
; then do a nastyoff and it will run in parallel.
; If it is in ram and accesses rom occasionally
; then do a romnastyoff->on around the rom accesses.
; This is two player mode's scren #1
;������������������������������������������������������
begin_3d_display1_l
;����������������������������������������������������
; first generate the view
	ai16
	lda	defaultID
	sta.l	m_defaultID
	a8
	jsl	getview1_l

	lda	drawmap+1
	lsr	a
	lsr	a
	sta	m_scbr

;����������������������������������������������������
; set up various mario variables needed for the 3d
	a16
	lda	drawmap
	sta.l	m_drawmap

	lda	#m_dustpnts1&WM
	sta.l	m_dustptr

	lda	#0
	sta.l	m_mariopoll
	a8

	lda	gamemode
	sta.l	m_pfm
			
;����������������������������������������������������
; draw the ground dots or stars
	jsl	mshowgrid_l

;����������������������������������������������������
; start the 3d going

	a8i16
	lda	#mbegin_3d_display>>16
	ldx	#mbegin_3d_display&WM
	sta	m_pbr
	nastyon
	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
	stx	mr15
	jsr	parallel_stuff_1

	a8
	nastyoff
	stz	pollstack

	rtl

do_3d_display2_l
;;	a8
;;	lda	screenmode
;;	bit	#sm_3dglasses
;;	bne	.continue
;;	bit	#sm_twoscreen
;;	bne	.continue
;;	jsr	parallel_stuff_2
;;	rtl
;;.continue
;;	ai16
;;	lda	defaultID
;;	sta.l	m_defaultID
;;	a8
;;
;;	jsl	getview2_l
;;
;;	lda	#bitmap2>>10
;;	sta	m_scbr
;;	a16
;;	lda	#m_dustpnts2&WM
;;	sta.l	m_dustptr
;;	lda	#0
;;	sta.l	m_mariopoll
;;	a8
;;	lda	gamemode
;;	sta.l	m_pfm
;;
;;	jsl	mshowgrid_l
;;
;;	a8i16
;;	lda	#mdo_3d_display>>16
;;	ldx	#mdo_3d_display&WM
;;	sta	m_pbr
;;	nastyon
;;	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
;;	stx	mr15
;;	jsr	parallel_stuff_2
;;
;;	a8
;;.dowait	lda	m_sfr
;;	and	#$20
;;	bne	.dowait
;;	nastyoff
;;
;;	rtl

;����������������������������������������������������
; This sets the 3d display drawing process going.
; If your code is in ram and doesn't access rom
; then do a nastyoff and it will run in parallel.
; If it is in ram and accesses rom occasionally
; then do a romnastyoff->on around the rom accesses.
; This is two player mode's scren #2
;������������������������������������������������������
begin_3d_display2_l
	a8
	lda	screenmode
	bit	#sm_3dglasses
	bne	.continue
	bit	#sm_twoscreen
	bne	.continue
	jsr	parallel_stuff_2
	rtl
.continue
;����������������������������������������������������
; first generate the view

	ai16
	lda	defaultID
	sta.l	m_defaultID
	a8

	jsl	getview2_l

;����������������������������������������������������
; set up various mario variables needed for the 3d

	lda	#bitmap2>>10
	sta	m_scbr
	a16
	lda	#bitmap2&WM
	sta.l	m_drawmap

	lda	#m_dustpnts2&WM
	sta.l	m_dustptr
	lda	#0
	sta.l	m_mariopoll
	a8
	lda	gamemode
	sta.l	m_pfm

;����������������������������������������������������
; draw the ground dots or stars

	jsl	mshowgrid_l

;����������������������������������������������������
; start the 3d going

	a8i16
	lda	#mbegin_3d_display>>16
	ldx	#mbegin_3d_display&WM
	sta	m_pbr
	nastyon
	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
	stx	mr15
	jsr	parallel_stuff_2

	a8
	nastyoff
	stz	pollstack

	rtl


;����������������������������������������������������
; this waits for the 3d display to finish - if
; it hasn't already

finish_3d_display1_l
finish_3d_display2_l
	php
	a8i16
	lda	#0
	pha
	plb	; set dbr 0

	nastyon		; all nasty modes on

;����������������������������������������������������
; wait for the mario chip to finish

.dowait
	lda	m_sfr
	and	#$20
	bne	.dowait
	nastyoff

	plp
	rtl


;����������������������������������������������������
; This sets the 3d display drawing process going.
; If your code is in ram and doesn't access rom
; then do a nastyoff and it will run in parallel.
; If it is in ram and accesses rom occasionally
; then do a romnastyoff->on around the rom accesses.

begin_3d_display_l
;����������������������������������������������������
; first generate the view

	ai16
	lda	defaultID
	sta.l	m_defaultID
	a8
	jsl	getview1_l

	lda	drawmap+1
	lsr	a
	lsr	a
	sta	m_scbr

;����������������������������������������������������
; set up various mario variables needed for the 3d
	lda	#0
	sta.l	m_bossmeter_off

	lda.l	MessageCount
	beq	.con565

	lda.l	message_lastpos
	bne	.con565

	lda	#1
	sta.l	m_bossmeter_off
.con565

	a16
	lda	drawmap
	sta.l	m_drawmap

	lda	#m_dustpnts1&WM
	sta.l	m_dustptr

	lda	#0
	sta.l	m_mariopoll
	sta.l	m_debugcount

	a8
	lda	gamemode
	sta.l	m_pfm

;��� Set the boss meter up properly ���

	lda.l	bossmaxHP
	asl	a
	cmp.l	m_bossmaxHP
	beq	.nochange
	bcc	.noinc

	lda.l	m_bossmaxHP
	inc	a
	inc	a
	sta.l	m_bossmaxHP
	bra	.nochange
.noinc
	lda.l	m_bossmaxHP
	dec	a
	dec	a
	sta.l	m_bossmaxHP
.nochange
	lda.l	bossHP
	bit	#128
	beq	.nohpreset
	lda	#0
	sta.l	bossHP
.nohpreset	asl	a
	and	#255
	cmp.l	m_bossmaxHP
	bcc	.noclamp
	lda.l	m_bossmaxHP
.noclamp	sta.l	m_bossHP
;���
	a16

	lda.l	bossname
	sta.l	m_bossname
	lda.l	bossname+2
	sta.l	m_bossname+2

;����������������������������������������������������
; draw the ground dots or stars

	lda.l	player1_vx
	nega
;	asl	a
	sta.l	m_p1_vx
	lda.l	player1_vy
	nega
;	asl	a
	sta.l	m_p1_vy
	lda.l	player1_vz
	nega
;	asl	a
	sta.l	m_p1_vz


	jsl	mshowgrid_l

;����������������������������������������������������
; start the 3d going

	a8i16

	lda	#mbegin_3d_display>>16
	ldx	#mbegin_3d_display&WM
	sta	m_pbr
	nastyon
	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
	stx	mr15
	jsr	parallel_stuff_3

	a8
	nastyoff
	stz	pollstack

	rtl


finishit_l
	php
	a8i16
	nastyon
.waitfin	lda.l	m_sfr
	and	#$20
	bne	.waitfin
	plp
	rtl

;����������������������������������������������������
; this waits for the 3d display to finish - if
; it hasn't already

finish_3d_display_l
	php
	a8i16
	lda	#0
	pha
	plb	; set dbr 0

	nastyon		; all nasty modes on

;����������������������������������������������������
; wait for the mario chip to finish

.dowait
	lda	m_sfr
	and	#$20
	bne	.dowait
	nastyoff

;����������������������������������������������������
; switch over to the other buffer

	swapdrawmap
	a16
	lda	drawmap
	sta.l	m_drawmap
	plp
	rtl



do_3d_display_l
	ai16
	lda	hudrot
	sta.l	m_hudrot
	lda	defaultID
	sta.l	m_defaultID
	a8
	lda	#mdo_3d_display>>16
	ldx	#mdo_3d_display&WM
	sta	m_pbr	;code bank
	nastyon
	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
	stx	mr15

	jsr	parallel_stuff

	a8
.dowait	lda	m_sfr
	and	#$20
	bne	.dowait
	nastyoff

	jsl	alienflags_l

	rtl


;---------------------------------------------------


KG_3d_display_l

;	ai16
;	lda	defaultID
;	sta.l	m_defaultID
;	a8
;	jsl	getview1_l
;
;	lda	#bitmap1>>10
;	sta	m_scbr
;	a16
;	lda	#m_dustpnts1&WM
;	sta.l	m_dustptr
;	a8
;	lda	gamemode
;	sta.l	m_pfm
;			
;
;	jsl	mshowgrid_l
;
;	a8i16
;	lda	#mdo_3d_display>>16
;	ldx	#mdo_3d_display&WM
;	sta	m_pbr
;	lda	mario_draw_mode
;	ora	#%00011000
;	sta	m_scmr
;	stz	m_sfr	; = 3030h Append By D.Cuthbert 1994.11.18
;	stx	mr15
;	jsr	parallel_stuff
;
;	a8
;.dowait	lda	m_sfr
;	and	#$20
;	bne	.dowait
;	lda	mario_draw_mode
;	sta	m_scmr

	rtl



parallel_stuff_1
; in parallel with IRQ #3 and IRQ #4

;	swapdrawmap

	rts

	SHORTA
	LONGI
parallel_stuff_3
	jsl	init_strats_ram_l
	rts

parallel_stuff_2
; in parallel with IRQ #1 and IRQ #2

	jsl	init_strats_ram_l	; collision detection
	jsl	showview1_l
	rts

parallel_stuff
	jsl	init_strats_ram_l
	rts



random_l
	jsr	random
	rtl
random

;	lda	rand
;	rol	a
;	eor	rand+1
;	sta	rand+1
;	adc	#4
;	sta	rand
	
	lda rand
	clc
	sbc rand+1
	sta rand+1
	sbc rand+2
	sta rand+2
	sbc rand+3
	sta rand+3
	sbc rand
	sta rand
	rts







;---------------------------------------------------

;-------------------------------------------------------
; Relocate back into rom

xrend	equ	xrstart+(*-xroutines)
	org	xrend,$8000*(xrend>>16)+(xrend&$7fff)

	ifgt	xrend-xrstart-xlen
	error	<Extended code more than xlen>
	endc

;;	printf	xrend-xrstart," - ",xlen,"%n"
;----------------------------------------------------------------


