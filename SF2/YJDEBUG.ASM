;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: yjdebug.asm				*
;* 	Description	: debug print message & value		*
;*	Date		: 1994.11.18				*
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
;
;
;
;
;
;---------------------------------------------------------------------
	longa
	longi
;*********************************************************************
;;	debug message
;*********************************************************************

debug_display

;----------------------------------------------
;;	lda.l	player_controltypeABXY
;;	printh	ABXY
;;	lda.l	player_controltype
;;	printh	conttype
;----------------------------------------------


	ifeq	1

	lda.l	raster_amp+2
	printh	amp
	lda.l	raster_freq+2
	printh	freq
	lda.l	raster_speed+2
	printh	speed

	lda.l	raster_timer
	printh	TIMER
	lda.l	raster_chart
	printh	TIMER

	endc



	ifne	AFdebugprint


;----------------------------------------------
;	RETRY FLAG
;----------------------------------------------
;;
;;	lda.l	kw_mistotalflag
;;	printh	retry
;;
;----------------------------------------------
; battle radar << program >>
;----------------------------------------------
;;
;;	lda.l	kpx
;;	printh	playerX
;;	lda.l	kpz
;;	printh	playerZ
;;
;----------------------------------------------
; raster AMP/FREQ/SPEED
;----------------------------------------------
;;
;; 	lda.l	raster_amp+2
;;	printh	rasteramp+2
;;	lda.l	raster_freq+2
;;	printh	rasterfreq+2
;;	lda.l	raster_amp+2
;;	printh	rasteramp+2
;;	lda.l	raster_freq+2
;;	printh	rasterfreq+2
;;	lda.l	raster_amp+2
;;	printh	rasteramp+2
;;	lda.l	raster_freq+2
;;	printh	rasterfreq+2
;;	lda.l	raster_speed+2
;;	printh	rasterspeed+2
;;
;----------------------------------------------
; raster debug
;----------------------------------------------
;;
;;	lda.l	player1hscroll
;;	printh	scrollH
;;	lda.l	player1vscroll
;;	printh	scrollV

;;	lda.l	raster_speed
;;	printh	rasterspeed
;;
;;
;;	lda.l	raster_amp+2
;;	printh	rasteramp2
;;	lda.l	raster_freq+2
;;	printh	rasterfreq2
;;	lda.l	raster_speed+2
;;	printh	rasterspeed2

;;
;----------------------------------------------
; game clear debug
;----------------------------------------------
;;	lda.l	gameclear_flag
;;	printh	gameclear
;----------------------------------------------
; wipe debug
;----------------------------------------------
;;	lda.l	wipestruct
;;	printh	wipe
;----------------------------------------------
; horizon / raster debug
;----------------------------------------------
;;	lda.l	player1_horizon
;;	printh	horizon
;;	lda.l	player1_horizon_wofs
;;	printh	debugscroll
;;	lda.l	voffsetflag
;;	printh	voffset
;----------------------------------------------
; game chyu message
;----------------------------------------------
;;	lda.l	pepper_message
;;	printd	message
;----------------------------------------------

	endc

	rts 

;====================================================================
;====================================================================
;END END END END END END END END END END END END END END END END END 
;====================================================================
;====================================================================

