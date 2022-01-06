;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: wipepaus.asm				*
;* 	Description	: wipe pause				*
;*	Date		: 1994.10.3				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;
;
;
;*******************************************************************
;	<<<<<< pause open >>>>>>
;*******************************************************************

wipepause_open
	jsr	dc_program
	dwnext	clear_fullclose
	dwnext	init_pausewipe
	dwloop	2,main_wipepause
	dwstop	main_wipepause

;=========== initialize =============================================

init_pausewipe

	jsr	set_param
	db	022h,022h,000h	; window switch
	db	00h,00h		; window logic
	db	00h		; 212dh
	db	00h,0dfh,0e2h	; 2130,31,32
	
	rts

;=========== main ==================================================

main_wipepause

	ifne	AFpauselook
	lda.l	cont0
	and	#button_X
	bne	.debug
	endc

	km_bitcheckmistotalflag finalbossbattle
	bne	.final
	km_bitcheckmissionflag wolfboss
 	bne	.final

;===========================================================
;	nomal
;===========================================================

	jsr	set_param
	db	022h,022h,000h	; window switch
	db	00h,00h		; window logic
	db	00h		; 212dh
	db	00h,0dfh,0e2h	; 2130,31,32

	jsr	swap_buffer
	ldy	#025*4		; start address
	ldx	#12*8		; loop count
	lda	#0c040h
	jmp	wipe_bufferset

;===========================================================
;	final boss
;===========================================================


.final	jsr	set_param
	db	022h,022h,000h	; window switch
	db	00h,00h		; window logic
	db	00h		; 212dh
	db	00h,0dfh,0e2h	; 2130,31,32

	jsr	swap_buffer
	ldy	#020*4		; start address
	ldx	#12*8		; loop count
	lda	#00001h
	jmp	wipe_bufferset

;===========================================================
;	debug
;===========================================================
.debug
	jsr	set_param
	db	022h,022h,000h	; window switch
	db	00h,00h		; window logic
	db	00h		; 212dh
	db	00h,000h,000h	; 2130,31,32

	jsr	swap_buffer
	ldy	#020*4		; start address
	ldx	#12*8		; loop count
	lda	#00001h
	jmp	wipe_bufferset
;===========================================================




;=========== main ==================================================

wait_wipepause

	rts

;*******************************************************************
; 	<<<<< pause close >>>>>>
;*******************************************************************

wipepause_close
	jsr	dc_program
	dwnext	clear_fullclose
	dwnext	offswitch
	dwwait	2
	dwstop	endofwipe

;===================================================================
;===================================================================
;;; END END END END END END END END END END END END END END END ;;;;
;===================================================================
;===================================================================
