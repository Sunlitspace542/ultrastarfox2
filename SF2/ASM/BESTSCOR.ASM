sbestscore_pros_speed equ	0
;---------------------------------------------------------------------
hsbutton_cancel	equ	button_X+button_Y
hsbutton_ok		equ	button_B+button_start
;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: bestscor.asm				*
;* 	Description	: scoreview program			*
;*	Date		: 1994.5.1				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************

;---------------------------------------------------------------------
	INCPUB  bestscor
;---------------------------------------------------------------------


;*********************************************************************
;	-------------------------
;	 Init ScoreView Program
;	-------------------------
;*********************************************************************

Init_bestscore_l
	Mbankprog
	php
	ai16
;-----+++++++++++++++++++-----------------
	jsl	Check_backupRAM_l   	;; backup ram initialize
;-----+++++++++++++++++++-----------------
	jsr	Drawbuffer_bestscore
	jsl	Read_backupRAM_coindata_l

	stz	hiscore_endflag
	lda	#1
	sta	hiscore_yesnopointer	; YES/NO pointer


	Mset	bestscore_struct,idx_scoreview_open
	km_bitcheckgameflag	lookresult
	beq	.skip
	km_clrgameflag		lookresult
	Mset	bestscore_struct,idx_scoreview_lookreturn
	
	bra	.exit
.skip
	stz	hiscore_keypointer	; key pointer
	stz	hiscore_number_cursor	; number

.exit	plp
	Mbankrtl

;*********************************************************************
;	-------------------------
;	 NMI ScoreView Program
;	-------------------------
;*********************************************************************
NMI_bestscore_l

	rtl


;*********************************************************************
;	Main ScoreView Program
;*********************************************************************
Main_bestscore_l
	Mbankprog
	php
	ai16

;--------------------------------------------------------
;;;;	MsetBL	2100h,08h	
;--------------------------------------------------------

	stz	sprite_register	; oam pointer reset

	jsr	call_repeat_trigger	
	jsr	scoreview_entry

;--------------------------------------------------------
;;;;	MsetBL	2100h,0fh	
;--------------------------------------------------------

	lda	hiscore_endflag
	plp
	Mbankrtl

;=====================================================================

;*********************************************************************
;	hiscore keyselect main 
;*********************************************************************
;
; out (Y) ... keypointer
;
;-------------------------------------

Mokcheck_key	macro	[addr]
	lda	repeat_trig
	and	#hsbutton_ok
	beq	{addr}
	ksound	kettei
	endm
;-------------------------------------
Mokcheck_key2 macro	[addr]
	lda	repeat_trig
	and	#hsbutton_ok
	beq	{addr}
	endm
;-------------------------------------
Mcancelcheck_key macro [addr]
	lda	repeat_trig
	and	#hsbutton_cancel
	beq	{addr}
	ksound	cancel
	endm
;-------------------------------------
Mcancelcheck_key2 macro [addr]
	lda	repeat_trig
	and	#hsbutton_cancel
	beq	{addr}
	endm

;-------------------------------------

Mupdown_key	macro	[work,max]
	ldy	{work}
	lda	repeat_trig

;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
	bit	#button_select
	beq	.skip1\@
	iny
	cpy	#{max}
	bcc	.set\@
	ldy	#0
	bra	.set\@
.skip1\@
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

	bit	#button_down
	bne	.up\@
	bit	#button_up
	beq	.noset\@
	dey
	bpl	.set\@
	bmi	.noset\@
.up\@	iny
	cpy	#{max}
	bcs	.noset\@
.set\@	ksound	cursor
	sty	{work}
.noset\@	ldy	{work}
	endm

;-------------------------------------
Mleftright_key macro	[work,max]
	ldy	{work}
	lda	repeat_trig

;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
	bit	#button_select
	beq	.skip1\@
	iny
	cpy	#{max}
	bcc	.set\@
	ldy	#0
	bra	.set\@
.skip1\@
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

	bit	#button_right
	bne	.up\@
	bit	#button_left
	beq	.noset\@
	dey
	bpl	.set\@
	bmi	.noset\@
.up\@	iny
	cpy	#{max}
	bcs	.noset\@
.set\@	ksound	cursor
	sty	{work}
.noset\@	ldy	{work}
	endm
;-------------------------------------

hiscore_keyselect
	Mupdown_key hiscore_keypointer,3
	rts

;-------------------------------------
hiscore_barselect
	Mupdown_key hiscore_number_cursor,5
	rts
	
;-------------------------------------
hiscore_yesnoselect
	Mleftright_key hiscore_yesnopointer,2
	rts
	
;-------------------------------------




;*********************************************************************
;	-----------------
;	 object strategy
;	-----------------
;*********************************************************************
bs_strat_hsmessage
	ldx	register
	lda	_objlimit,x
	inc	a
	cmp	#20
	bcs	.skip
	sta	_objlimit,x
.skip	
	jmp	Newoamset
	
;------------------------------------------
bs_strat_erasecursor
	ldx	register
	ldy	hiscore_yesnopointer
	lda	.data&WM,y
	and	#00ffh
	sta	_axisX,x
	jmp	Newoamset

.data
	ifne	janglish
	db	0b0h-5,0d8h-5	; JAPAN Version !!!!!
	elseif
	db	0b0h-4+4,0d8h-4	; NES Version   !!!!!
	endc

;------------------------------------------
bs_strat_stop	
	rts			;;; erase object

;------------------------------------------
bs_strat_finger
	ldx	register
	ldy	hiscore_keypointer
	lda	.data&WM,y
	and	#00ffh
	sta	_axisY,x
	jmp	Newoamset

.data	db	0a7h+16*0
	db	0a7h+16*1
	db	0a7h+16*2

;---------------------------------------------
bs_strat_face
	jmp	Newoamset

;---------------------------------------------





;*********************************************************************
;	BestScore Entry !!
;*********************************************************************
;
;	keyselect opentitle mode
;	keyselect select .... titlemode
;	keyselect select .... lookscore mode
;	keyselect select .... erasescore mode
;
;
;====================================================================

scoreview_entry
	ldx	#bestscore_struct
	stx	dcregister
	jsr	dc_select
	Mindexliststart
	Mindexlist	scoreview_nothing		;(0)
	Mindexlist	scoreview_open			; openning
	Mindexlist	scoreview_titleret_entry	; title ret 
	Mindexlist	scoreview_titleret		; title ret
	Mindexlist	scoreview_lookscore_entry	; look  score
	Mindexlist	scoreview_lookscore		; look  score
	Mindexlist	scoreview_lookscore_select	; look  score
	Mindexlist	scoreview_lookscore_exec	; look  score
	Mindexlist	scoreview_lookscore_nothing	; look  score
	Mindexlist	scoreview_erasescore		; erase score
	Mindexlist	scoreview_erasescore_select	; erase select
	Mindexlist	scoreview_erasescore_okcheck	; erase score
	Mindexlist	scoreview_erasescore_exec	; erase score
	Mindexlist	scoreview_erasescore_nothing	; erase score
	Mindexlist	scoreview_lookreturn		; lookscore return
	Mindexlist	scoreview_faceclose_titlego	; title back
	
;=====================================================================
scoreview_nothing
	rts

;*********************************************************************
;	openning demo
;*********************************************************************
scoreview_lookreturn
	jsr	dc_program
	dwnext	.init
	dwstop	.exit

.init	
	jsr	Init_objlist
	Mobjinit 0,ys_bs_scorebar,bs_strat_bar_bestscore,80h,0
	Mobjinit 1,ys_bs_fingerOK,bs_strat_finger,01ch,0a7h
	Mobjinit 3,ys_bs_facemouth,bs_strat_face,0a8h,0a6h
	Mobjinit 5,ys_bs_coindisp,bs_strat_coindisp,coinposX,coinposY
	jmp	Main_OBJ

.exit	
	Mset	bestscore_struct,idx_scoreview_lookscore_select
	jmp	Main_OBJ
	

;*********************************************************************
;	openning demo
;*********************************************************************
scoreview_open
	Mset	bestscore_struct,idx_scoreview_titleret_entry
	rts

;*********************************************************************
;	title return entery
;*********************************************************************
scoreview_titleret_entry		;; << titleret Entry >>
	jsr	dc_program
	dwnext	.init
	dwflag	.main
	dwloop	60,return_title1
	dwnext	return_titlesoundfade
	dwstop	return_titleend
;---------------------------------------------
.init	jsr	Init_objlist
	Mobjinit 0,ys_bs_scorebar,bs_strat_stop,80h,0
	Mobjinit 1,ys_bs_fingerselect,bs_strat_finger,01ch,0a7h
	Mobjinit 5,ys_bs_coindisp,bs_strat_coindisp,coinposX,coinposY
;---------------------------------------------
.main
titleret_main

	Mokcheck_key	.skip
	ldx	dcregister
	dec	_dcflag,x
	kbgm	fadeout
	bra	.exit
.skip

	jsr	hiscore_keyselect
	cpy	#0
	beq	.exit
	Mset	bestscore_struct,idx_scoreview_lookscore_entry
.exit	jmp	Main_OBJ
;---------------------------------------------
return_title1
	Mobjchange 1,ys_bs_fingerOK,bs_strat_finger
	jmp	Main_OBJ
;---------------------------------------------
return_titlesoundfade
return_titleend
	lda	#0ffffh
	sta	hiscore_endflag
	jmp	Main_OBJ
	rts

;*********************************************************************
;	title return
;*********************************************************************
scoreview_titleret			;; << titleret >>
	jsr	dc_program
	dwflag	titleret_main
	dwloop	20,return_title1
	dwnext	return_titlesoundfade
	dwstop	return_titleend
;---------------------------------------------


;*********************************************************************
;	title lookscore entry
;*********************************************************************
scoreview_lookscore_entry
	jsr	dc_program
	dwnext	.init		;; initialize
	dwloop	5,.demo		;; demo object move
	dwnext	.exit		;; next jmp seq
;---------------------------------------------
.init	Mobjinit 3,ys_bs_faceopen,bs_strat_face,0a8h,0a6h
;---------------------------------------------
.demo	jmp	Main_OBJ
;---------------------------------------------
.exit	Mset	bestscore_struct,idx_scoreview_lookscore
	jmp	Main_OBJ
;---------------------------------------------
;
;
;
;*********************************************************************
;	title ( faceclose ) back
;*********************************************************************
scoreview_faceclose_titlego
	jsr	dc_program	
	dwnext	titleretdemo_init
	dwloop	5,titleretdemo_main
	dwstop	titleretdemo_exit

;---------------------------------------------
;	title return demo
;---------------------------------------------
titleretdemo_init
	Mobjchange 3,ys_bs_faceclose,bs_strat_face
;---------------------------------------------
titleretdemo_main
	jmp	Main_OBJ
;---------------------------------------------
titleretdemo_exit
	Mobjkill 3	;; kill face    !!
	Mset	bestscore_struct,idx_scoreview_titleret
	jmp	Main_OBJ
;---------------------------------------------
;
;
;*********************************************************************
;	title lookscore
;*********************************************************************
scoreview_lookscore
	jsr	dc_program	
	dwnext	lookscore_init
	dwstop	lookscore_main

;---------------------------------------------
;	keyselect
;---------------------------------------------
lookscore_init
	jmp	Main_OBJ

;---------------------------------------------
lookscore_main

	Mokcheck_key	.skip
	Mset	bestscore_struct,idx_scoreview_lookscore_select
	bra	.exit

.skip	jsr	hiscore_keyselect
	cpy	#1
	beq	.exit
	cpy	#2
	bne	.title
.erase	Mset	bestscore_struct,idx_scoreview_erasescore
	bra	.exit
.title	Mset	bestscore_struct,idx_scoreview_faceclose_titlego
.exit	jmp	Main_OBJ

;---------------------------------------------
;
;
;
;
;*********************************************************************
;	title lookscore select
;*********************************************************************
scoreview_lookscore_select
	jsr	dc_program	
	dwnext	.init
	dwflag	.main
	dwstop	.exit

;---------------------------------------------
.init
	Mobjchange 0,ys_bs_scorebar,bs_strat_bar_bestscore
	Mobjchange 1,ys_bs_fingerOK,bs_strat_finger
	Mobjinit 2,ys_bs_message_lookscore,bs_strat_hsmessage,06eh,0c3h
	stz	_objlimit,x
	Mobjchange 3,ys_bs_facemouth,bs_strat_face
	jmp	Main_OBJ

;---------------------------------------------
.main
	Mokcheck_key2	.skip0

;-----------------------------------------
	lda	hiscore_number_cursor
	ora	#hs_sizeof*256
	jsr	mult_u8u8
	tax
	lda.l	hs_score+0,x
	ora.l	hs_score+1,x
	bne	.dataARI
.dataNASHI
	ksound	you_are_wrong
	Mset	bestscore_struct,idx_scoreview_lookscore_nothing
	bra	.kill
;-----------------------------------------
.dataARI
	ksound	kettei
	Mset	bestscore_struct,idx_scoreview_lookscore_exec
	bra	.kill
;-----------------------------------------

.skip0	Mcancelcheck_key	.skip1

	Mset	bestscore_struct,idx_scoreview_lookscore
	Mobjchange 0,ys_bs_scorebar,bs_strat_stop
	Mobjchange 1,ys_bs_fingerselect,bs_strat_finger
	bra	.kill

.skip1
	jsr	hiscore_barselect
	bra	.skip5

.kill	Mobjkill 2		;;; kill message
.skip5	jmp	Main_OBJ
;---------------------------------------------
.wait
.exit

	jmp	Main_OBJ

;---------------------------------------------

;*********************************************************************
;	data look exec
;*********************************************************************
;;
;; lookscore ------> Fadeout-Score-Screen
;; lookscore ------> Data Nothing
;;
;---------------------------------------------
scoreview_lookscore_nothing
	jsr	dc_program	
	dwnext	.init
	dwloop	110,.main
	dwstop	.exit

;---------------------------------------------
.init	
	Mobjinit 2,ys_bs_message_datanothing,bs_strat_hsmessage,06eh,0c3h
	stz	_objlimit,x
	Mobjchange 3,ys_bs_facemouth,bs_strat_face

.main
	jmp	Main_OBJ

.exit
	Mset	bestscore_struct,idx_scoreview_lookscore_select
	Mobjkill 2
	jmp	Main_OBJ


;*********************************************************************
;	LOOKING BACKUP HISCORE DATA
;*********************************************************************
scoreview_lookscore_exec
	jsr	dc_program	
	dwnext	.init
	dwloop	60,.main
	dwnext	.exit
	dwstop	.wait
;---------------------------------------------
.init	kbgm	fadeout
.main	jmp	Main_OBJ
;---------------------------------------------
.exit
	jsr	Load_kxwork		; <---- Set kx parameter 

	lda	#0ffffh
	sta	hiscore_endflag		; <---- title return
	km_bitcheckgameflag	lookresult
	km_setgameflag	lookresult

.wait	jmp	Main_OBJ
;---------------------------------------------


;*********************************************************************
;	erase score
;*********************************************************************
scoreview_erasescore
	jsr	dc_program
	dwnext	.init
	dwstop	.main
;---------------------------------------------
.init	
	jmp	Main_OBJ
;---------------------------------------------
.main	

	Mokcheck_key	.skip

	Mset	bestscore_struct,idx_scoreview_erasescore_select
	bra	.exit

.skip	jsr	hiscore_keyselect
	cpy	#2
	beq	.exit
	cpy	#1
	beq	.lookscore
.titleback	Mset	bestscore_struct,idx_scoreview_faceclose_titlego
	bra	.exit
.lookscore	Mset	bestscore_struct,idx_scoreview_lookscore
.exit	jmp	Main_OBJ
;---------------------------------------------
	
;*********************************************************************
;	title erasescore select
;*********************************************************************
scoreview_erasescore_select
	jsr	dc_program	
	dwnext	.init
	dwloop	16,.wait
	dwstop	.main

;---------------------------------------------
.init
	lda	#1
	sta	hiscore_yesnopointer
	Mobjchange 0,ys_bs_scorebar,bs_strat_bar_clear
	Mobjchange 1,ys_bs_fingerOK,bs_strat_finger
	Mobjchange 3,ys_bs_facemouth,bs_strat_face

	Mobjinit 2,ys_bs_message_erasescore,bs_strat_hsmessage,06eh,0c3h
	stz	_objlimit,x
	Mobjinit 4,ys_bs_message_erasecursor,bs_strat_erasecursor,080h,0c3h

	jmp	Main_OBJ

;---------------------------------------------
.main
	Mokcheck_key2	.skip0

	lda	hiscore_yesnopointer
	bne	.cancel
	ksound	kettei
	Mset	bestscore_struct,idx_scoreview_erasescore_okcheck
	bra	.kill

.skip0
	Mcancelcheck_key2 .skip1

.cancel	
	ksound	cancel
	Mset	bestscore_struct,idx_scoreview_erasescore
	Mobjchange 0,ys_bs_scorebar,bs_strat_stop
	Mobjchange 1,ys_bs_fingerselect,bs_strat_finger
	bra	.kill

.skip1
	jsr	hiscore_yesnoselect
	bra	.skip5

.kill	Mobjkill 2		;;; kill message
	Mobjkill 4		;;; kill cursor
;---------------------------------------------
.wait
.skip5	jmp	Main_OBJ
;---------------------------------------------

;*********************************************************************
;	title erasescore select
;*********************************************************************
scoreview_erasescore_okcheck
	jsr	dc_program	
	dwnext	.init
	dwloop	16,.wait
	dwstop	.main

;---------------------------------------------
.init
	lda	#1
	sta	hiscore_yesnopointer
	Mobjchange 3,ys_bs_facemouth,bs_strat_face
	Mobjinit 2,ys_bs_message_erasescoreOK,bs_strat_hsmessage,06eh,0c3h
	stz	_objlimit,x
	Mobjinit 4,ys_bs_message_erasecursor,bs_strat_erasecursor,080h,0c3h
	jmp	Main_OBJ

;---------------------------------------------
.main
	Mokcheck_key2	.skip0

	lda	hiscore_yesnopointer
	bne	.cancel
	ksound	kettei
	Mset	bestscore_struct,idx_scoreview_erasescore_exec
	bra	.kill

.skip0	
	Mcancelcheck_key2 .skip1


.cancel	ksound	cancel
	Mset	bestscore_struct,idx_scoreview_erasescore_select
	bra	.kill

.skip1
	jsr	hiscore_yesnoselect
	bra	.skip5


.kill	Mobjkill 2		;;; kill message
	Mobjkill 4
.wait
.skip5	jmp	Main_OBJ
;---------------------------------------------

;*********************************************************************
;	data erase exec
;*********************************************************************
;###################################
;#########		    ###########
;#########  BACKUP WTITE ###########
;#########		    ###########
;###################################

scoreview_erasescore_exec
scoreview_erasescore_nothing
	jsr	dc_program
	dwnext	.init
	dwloop	88,.loop
	dwnext	.exec
	dwloop	60,.loop
	dwstop	.exit

;---------------------------------------------
.init

	Mobjinit 2,ys_bs_message_erasescoreEXEC,bs_strat_hsmessage,06eh,0c3h
	stz 	_objlimit,x
	Mobjchange 3,ys_bs_facemouth,bs_strat_face
	jmp	Main_OBJ

;---------------------------------------------
.exec
	ksound	record_clear
	jsr	ALLinit_BackupRAM	; #### BACKUP WRITE!! ####
	jsr	Drawbuffer_bestscore	;; display scores  !!

.loop	jmp	Main_OBJ
;---------------------------------------------
.exit

	stz	hiscore_number_cursor	; number

	Mset	bestscore_struct,idx_scoreview_erasescore
	Mobjchange 0,ys_bs_scorebar,bs_strat_stop
	Mobjchange 1,ys_bs_fingerselect,bs_strat_finger
	Mobjkill 2
	jmp	Main_OBJ

;#####################################################################
;#####################################################################
;#####################################################################
;
;
;
;
;
;
;=====================================================================
;=====================================================================
; END EMD END END END END END END END END END END END END END END END
;=====================================================================
;=====================================================================
