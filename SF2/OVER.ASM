;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: gamover.asm				*
;* 	Description	: Gameover SEQ				*
;*	Date		: 1994.12.22				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;---------------------------------------------------------------------
gameover_struct	equ	bgdemo_switch
;---------------------------------------------------------------------
;
;
;*********************************************************************
;	Initialize
;*********************************************************************


	lda	#idx_overobj_entry
	sta	gameover_struct

	rts

;*********************************************************************
;	main
;*********************************************************************



	
	ldx	#gameover_struct
	stx	dcregister
	jsr	dc_select
	Mindexliststart
	Mindexlist	overobj_exit
	Mindexlist	overobj_entry
	Mindexlist	overobj_partnerselect

;*********************************************************************
;	gameover obj exit
;*********************************************************************
overobj_exit
	rts

;*********************************************************************
;	gameover entry program
;*********************************************************************

overobj_partnerselect

	jsr	dc_program
	dwnext	overobj_


;*********************************************************************
;	gameover entry program
;*********************************************************************

overobj_entry

	jsr	dc_program
	dwflag	overobj_demowait
	dwloop	overobj_scoredisp




;*********************************************************************
;	demo trigger wait
;*********************************************************************
overobj_demowait

	lda	cont0
	and	#button_L+button_R
	beq	.exit
	tyx
	dec	_dcflag,x		; next-mode

.exit	rts

;*********************************************************************
;	demo trigger wait
;*********************************************************************
overobj_scoredisp

	lda.l	gameover_scorepointer
	inc	a
	beq	.skip
	sta.l	gameover_scorepointer
.skip
	Mbitset	gameover_dispflag,ON_gameover_score

	lda	trig0
	and	#button_ok
	beq	.exit
	tyx
	dec	_dcflag,x		; next-mode

.exit	rts


;*********************************************************************
;
;*********************************************************************


	lda	kx_CorneriaHP
	beq	.corneria_over
	lda	player_friend
	bmi	.player_over

;--------------------------------------------------------------------
.continue_over
	Mset	gameover_status,idx_gameover_partner
	Mbitclr	gameover_dispflag,ON_gameover_score
	Mbitset	gameover_dispflag,ON_gameover_partner
	rts

;--------------------------------------------------------------------
.player_over
.corneria_over




;=====================================================================
;=====================================================================



