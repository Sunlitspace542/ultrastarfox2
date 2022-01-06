;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: yajima.def				*
;*	Description	; Memory Alocation			*
;*	Date		: 1994.7.15				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************



;*********************************************************************
;	backup flag label
;	(( m_backupflags ))
;*********************************************************************

;------------------------------------- LOW Byte --------

backupflag_cameramode equ	1	; 1/cockpit 0/plane
backupflag_playerABXY equ	2
backupflag_playerUPDW equ	4
backupflag_soundmode	 equ	8	; 0/stereo 1/mono
backupflag_expert	 equ	16

;------------------------------------- HIGH Byte -------
backupflag_twinfox	 equ	100h
backupflag_twinfalco	 equ	200h
backupflag_twinpeppy	 equ	400h
backupflag_twinslippy equ	800h
backupflag_twinmiyu   equ   1000h
backupflag_twinfay    equ   2000h

backupflag_twinALL	 equ   3f00h	;;;;	


;*********************************************************************
; 	zero page address
;*********************************************************************

;------------------------------------------------
Xaddr		equ	textpt	; 4byte
Xwork0		equ	x1	; 2byte
Xwork1		equ	y1	; 2byte
Xwork2		equ	z1	; 2byte
Xwork3		equ	x2	; 2byte
Xwork4		equ	y2	; 2byte
Xwork5		equ	z2	; 2byte
Xwork6		equ	x3	; 2byte
Xwork7		equ	y3	; 2byte
Xwork8		equ	tpa	; 2byte	; library
Xwork9		equ	tpx	; 2byte ; library
Xwork10		equ	tpy	; 2byte ; library
;------------------------------------------------

;*********************************************************************
;	structure
;*********************************************************************

word_object_size	equ	42
word_object_total	equ	6

;=====================================================================
;
;
;
;
;
;
;*********************************************************************
;		*************************************************
; 100 - 1fff Ram	*************************************************
;		*************************************************
;*********************************************************************
;
;
;
;
;
;*********************************************************************
; 	frame work
;*********************************************************************

	alc	yajima_temp,2
	alc	yj_framecounter,2
	alc	gameframe_trigger,2


	alc	backup_sumwork,2
	alc	backup_jmpwork,2

;*********************************************************************
;	title work
;*********************************************************************

	alc	titlerogo_flag,2

titlerogo_start	equ	1

;*********************************************************************
;	raster parameter
;*********************************************************************

	alc	raster_control,2

;*********************************************************************
;	playerselect
;*********************************************************************

	alc	bpsel_index,2	
	alc	bpsel_fingeranime,2
	alc	player_owner,2	   .... 1p player
	alc	player_friend,2	   .... 2p player ( friend )
	alc	random_friend,2
	alc	objdraw,2

playerselectNo	equ	player_owner

;*********************************************************************
;	mapobj animation work
;*********************************************************************

	alc	enemyplanet_animecount,2

	alc	oam_centerX,2	; map object screen
	alc	oam_centerY,2
	alc	oam_animeNo,2
	alc	oam_tcount,2
	alc	oam_pointer,2
	alc	HPcorneria,2

;*********************************************************************
;	message
;*********************************************************************

	alc	pepper_message,2

;*********************************************************************
; 	gameover flag
;*********************************************************************

	alc	gameover_flag,2

Disp_gameoverscore	equ	1

	alc	gameover_dispflag,2

ON_gameover_partner	equ	1
ON_gameover_score	equ	2
ON_gameover_retry	equ	4
ON_gameover_sos1	equ	8
ON_gameover_sos2	equ	16
ON_gameover_sos3	equ	32

;*********************************************************************
; 	gameclear flag
;*********************************************************************

	alc	gameclear_flag,2


;*********************************************************************
; 	object control RAM
;*********************************************************************

	alc	sprite_offset,2
	alc	register,2		
	alc	sprite_register,2
	alc	sprite_start,2

;------------------------------------------------
;; sprite structure
	alc	Xlinklist_free,2
	alc	Xlinklist_root,2
	alc	word_free,4
	alc	word_root,4
	alc	word_object,word_object_size*word_object_total
	alc	objindex_table,12

;------------------------------------------------
stepup_work	equ	word_object
;------------------------------------------------

;*********************************************************************
; 	demo control RAM
;*********************************************************************

	alc	dcregister,2
	alc	bgdemo_switch,20
	alc	wipestruct,20
	alc	gameobjstruct,20

;
;
;
;
;
;*********************************************************************
;		*************************************************
; 7E bank RAM	*************************************************
;		*************************************************
;*********************************************************************

	xalc	sosdebug,2

	xalc	check_bestscore_mode,2
	xalc	starcolor_data,2
	xalc	initial_twin_player,2
	xalc	medal_counter,2
	xalc	medal_clear,2
	xalc	gameclear_yjflag,2
	xalc	titlestarcolor_fade,2

	xalc	SEQaddr,4
	xalc	OBJaddr,4
	xalc	meterswitch,2	; gameOBJ ON/OFF switch !!
	xalc	hellswitch,2	; hell/heaven

;*********************************************************************
;
;*********************************************************************

	xalc	pause_viewselect,2
pause_view1	equ	0
pause_view2	equ	1
	xalc	player1_keyconfig,2
	xalc	player2_keyconfig,2

;*********************************************************************
;	yj radar test
;*********************************************************************

	xalc	radarplayer_x,2
	xalc	radarplayer_z,2

	xalc	yjradarposH,2
	xalc	yjradarposV,2

;*********************************************************************
;	game meter
;*********************************************************************

	xalc	barnoize_counter,2
	xalc	videonoize_counter,2

;*********************************************************************
;	game meter
;*********************************************************************

	xalc	corneria_bombanime,2

;*********************************************************************
;	map message
;*********************************************************************

	xalc	mapicon_flag,2
	xalc	yajirushi_anime,2

	xalc	yajirushi_flag,2

OFF_enemyyaji	equ	0
OFF_zakoyaji		equ	0
OFF_missyaji		equ	0
ON_enemyyaji		equ	1
ON_zakoyaji		equ	2
ON_missyaji		equ	3


maptime_speedup	equ	1


	xalc	map_trigmessage,2

	xalc	double_message,8

	xalc	mapmessage_setcolor,2
	xalc	mapmessage_messageno,2
	xalc	mapmessage_messagestatus,2

	xalc	openface_count,2
	xalc	closeface_count,2
	xalc	faceobj_position,2
	xalc	faceobj_initpos,2

;----------------------------------------------
; openning map explain 
;----------------------------------------------

	xalc	mapexp_messageskipflag,2
					; mapexp (planet) message 
					; WO 1times skip saseru
					; 0 NORMAL
					; -1 1TIMES ONLY SKIP

	xalc	mapexp_kawaflag,2	; kawaguchi message flag
					; 0 OFF
					; 1 ON
	xalc	mapexp_kawanumber,8	; message 1or2or3or4
					;
	xalc	mapexp_special,2	; special message pointer
	xalc	mapexp_pointer,2
	xalc	mapexp_counter,2
	xalc	mapexp_work,2
	xalc	mapexp_objpos,2	
	xalc	mapexp_objcount,2
	xalc	mapexp_objNo,2
	xalc	mapexp_levelprog,2
	xalc	mapexp_planetlist,2
	xalc	mapexp_planettimer,2

	xalc	mapexp_demoflag,2	; demomessage check !!
	xalc	mapexp_nextobj,2
	xalc	mapexp_linecheck,2	; nextobj linecheck !!

	xalc	LVmessage_planetname,2

;*********************************************************************
;	backup RAM writecheck
;*********************************************************************

	xalc	backup_writeflag,2
	xalc	hiscore_number,2

;*********************************************************************
;	map corneria crash
;*********************************************************************

	xalc	map_corneriacrash_anime,2
	xalc	map_corneriacrash_offset,2
	xalc	map_corneriacrash_posX,2
	xalc	map_corneriacrash_posY,2


;*********************************************************************
;	gameover work
;*********************************************************************

	xalc	gameover_scorepointer,2
	xalc	gameover_score,2
	xalc	frashdata,2

;*********************************************************************
;	map sprite animation
;*********************************************************************

	xalc	faceshutter_count,2


;*********************************************************************
;	pausemap
;*********************************************************************

	xalc	pause_sprite,2		; sprite register
	xalc	pause_pointer,2		; ROM pointer
	xalc	pause_playeranime,2	; 
	xalc	pause_enemyanime,2	; 
	xalc	pause_stepupanime,2	; 
	xalc	pause_guardanime,2	; 
	xalc	pause_planetanime,2*7	; 
	xalc	pause_yarareanime,2



;*********************************************************************
; 	Window (Wipe) Buffer
;*********************************************************************

	xalc	wipe_work,20
	xalc	wipe_test,34


	xalc	wp_windowpointer,2	; 0 or 2
	xalc	wp_centerX,4
	xalc	wp_centerY,4
	xalc	wp_mainangle,4
	xalc	wp_mainzoom,4
	xalc	wp_rotspeed,4

;---------------------------------------------

	xalc	wp_clipXmin,2
	xalc	wp_clipXmax,2
	xalc	wp_clipYmin,2
	xalc	wp_clipYmax,2
	xalc	wp_total,2
	xalc	wp_world,4*4
	xalc	wp_rotate,4*9
	xalc	wp_tmprotate,4*9

;---------------------------------------------

	xalc	wipe_bufferA1,448
	xalc	wipe_bufferA2,448
	xalc	wipe_bufferB1,448
	xalc	wipe_bufferB2,448

;---------------------------------------------------------------------
	xalc	finalbeam_flag,2
	xalc	finalbeam_sx,2
	xalc	finalbeam_sy,2
	xalc	finalbeam_dx,2
	xalc	finalbeam_dy,2
;---------------------------------------------------------------------
;
;
;
;
;
;
;*********************************************************************
;		*************************************************
; 7F bank RAM	*************************************************
;		*************************************************
;*********************************************************************

	xxalc	Kenemy_backup,2

;*********************************************************************
;	VRAM 'kakikae' work
;*********************************************************************

	xxalc	textdraw_pointer,2	; BG draw pointer
	xxalc	textdraw,160		; BG draw buffer

;*********************************************************************
; 	player select 
;*********************************************************************


	xxalc	psel_p1scroll,2
	xxalc	psel_p2scroll,2
	xxalc	psel_p1speed,2
	xxalc	psel_p2speed,2
	xxalc	attrcount,2		; player select


;*********************************************************************
; 	raster RAM
;*********************************************************************

	xxalc	raster_chart,2
	xxalc	raster_timer,2

	xxalc	raster_counter,2*4	; raster program
	xxalc	raster_amp,2*3		; H-raster parameter
	xxalc	raster_freq,2*3
	xxalc	raster_speed,2*3
	xxalc	raster_Vadd,2
	xxalc	raster_Vcenter,2

	xxalc	raster_noizestart,2
	xxalc	raster_noizesize,2

	xxalc	Voffset_total,4	 ; raster Voffset
	xxalc	Voffset_add,4	 ; raster Voffset

;*********************************************************************
;		*************************************************
; Global Labels	*************************************************
;		*************************************************
;*********************************************************************

;---------------------------------------------------------------------

bgdemo_clear		equ	0
bgdemo_boss_map1	equ	1
bgdemo_boss_map2	equ	2
bgdemo_boss_map3	equ	3
bgdemo_boss_map4	equ	4
bgdemo_boss_map5	equ	5
bgdemo_boss_map6	equ	6
bgdemo_hell		equ	7
bgdemo_heaven	equ	8

;---------------------------------------------------------------------

gameclear_messagestart	equ	1
gameclear_messagemain	equ	2
gameclear_messageend		equ	3

;---------------------------------------------------------------------

;======================================================================
;======================================================================
;======================================================================
;======================================================================
;======================================================================




