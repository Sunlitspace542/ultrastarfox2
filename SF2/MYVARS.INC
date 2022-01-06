;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX2 					*
;*	------------------------				*
;*								*
;*	File 		: myvars.mc				*
;*	Description	; marioRAM alocate			*
;*	Date		: 1994.10.11				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;*********************************************************************
;	debug work area
;*********************************************************************

	malc	m_yajimaDB,8
	malc	m_yjtest,0
	malc	m_testcount,2

	malc	m_dpolywork,2


	malc	m_rainflag,2		; rain flag 
	malc	m_rainbuffer,0	; rain buffer
	
;*********************************************************************
;	message & score draw works
;*********************************************************************

	malc	m_dispmes_x1,2
	malc	m_dispmes_y1,2
	malc	m_dispmes_color,2
	malc	m_dispmes_index,2

;*********************************************************************
;	gameover score display
;*********************************************************************

	malc	m_gameover_score,2
	malc	m_gameover_damage,2
	malc	m_gameover_test,8


;*********************************************************************
;	title mariochip program
;*********************************************************************

	malc	m_titlemessage,2
	malc	m_titlecursor,2
	malc	m_titlefacedisp,2
	malc	m_yjmessage_rts,2
	malc	m_yjmessage_pointer,2

;*********************************************************************
;	gamemessage
;*********************************************************************

	malc	m_barnoize_counter,2
	malc	m_videonoize_counter,2

;*********************************************************************
;	gamemessage
;*********************************************************************

	malc	m_gamemessageheight,2
	malc	m_gamemessagetype,2
	malc	m_gamemessagecolor,2
	malc	m_gamemessage_sizeX,2
	malc	m_gamemessage_cornerX,2

;*********************************************************************
;	library work
;*********************************************************************

	malc	m_yjrandom,2
	malc	m_gameframe_trigger,2
	malc	m_conttrigger,2	; key controller trigger

	malc	m_returnaddr,2	; JSR -> return address
	malc	m_rtl,4		; JSL -> return address (+0)
				;     -> return bank	(+2)

	malc	m_gyoulimit,2	; ( mprintWWstring ) gyou limit
	malc	m_gyoucount,2	; (	//	   )      count


;*********************************************************************
;	draw face program
;*********************************************************************

	malc	m_facerts,2

	malc	m_y1_boxdraw,2
	malc	m_height_boxdraw,2

;*********************************************************************
;	map message program
;*********************************************************************


	malc	m_mapmessage_rts,2	; RTS work

	malc	m_mapmessage_color,2	; mapmessgae color

	malc	m_mapmessage_faceflag,2

	malc	m_mapmessage_mode,2	; opendemo / map
	malc	m_mapmessage_mouth,2	; mouth move
	malc	m_messageend,2		; message END flag
	malc	m_playernumber,4	; p1No/p2No
	malc	m_partnernumber,2	; partner

	malc	m_mapmessageNo,2	; message display Number
	malc	m_mapmessage_counter,2	; message INC counter
	malc	m_mapBG1scrollX,2	; message BG scroll X
	malc	m_mapBG1scrollY,2	; message BG scroll Y

	malc	m_messagetimer,2	; message display timeinit

	malc	m_redpepper_anime,2

;-------------------------------------------------
; mapmessage work
;-------------------------------------------------

	malc	m_subrts,2	; mapmessage sub program

	malc	m_mapcursor,2
	malc	m_planetno,2
	malc	m_planetstep,2
	malc	m_message_sos,2
	malc	m_message_guard,2
	malc	m_message_stepup,2
	malc	m_planet_stepup,2
	malc	m_mapcursorX,2
	malc	m_mapcursorY,2
	malc	m_playerNo,2
	malc	m_mapstatus,2
;-------------------------------------------------




;=========================================================================
;=========================================================================


