;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         WINDOWS.ASM                                         ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  Window hdmatabs set                                 ;
; DATE CREATED: 23-6-94                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
; colour windows
	
	incpub	windows

;initblack_l,setblack_l,setwindowtabs_l
;Check_KGwindow_l
;=====================================================================
;*								*
;*			MACRO Definition			*
;*								*
;=====================================================================
;---------------------------------------------------------------------
;*		MISSION Parameters				*
;---------------------------------------------------------------------
SetPlayerHeapPtr	macro	[player,obj1]
MYNARG	=	NARG
	CHK_NARG	2

	shorta
	longi
;* player heap pointer & player flag*
	km_plheapptr	{player},{obj1}

	lda	#{player}
	lsr	a	
	sta	kplayer

	endm
;---------------------------------------------------------------------
;*		Cockpit Parameters				*
;---------------------------------------------------------------------
SetBattWinStates	macro	[player,obj1]
MYNARG	=	NARG
	CHK_NARG	2
tmp_p1	=	0
tmp_p2	=	1

	shorta
	longi
;* player heap pointer & player flag*
	km_plheapptr	{player},{obj1}

	lda	#{player}
	lsr	a	
	sta	kplayer
	endm


;*********************************************************************
;*								*
;*		Initial	Window Parameters [Not Polygon Screen]	*
;*								*
;*********************************************************************
init_nopolywindows_l
	php
	a8i16
	phb
	db0

	jsl	initblack_l
	km_fadestepup

	km_clrwindowflag	windowwbuf
	jsl	find_window_pri_l
;* window *
	ldx	#xhdma_window&WM
	stx	ch5addra1tl
	lda	#xhdma_window>>16
	sta	ch5atbank

	lda	hdmaen_gc
	ora	#hdmaf_circle
	sta	hdmaen_gc
	plb
	plp
	rtl

;*********************************************************************
;*								*
;*			WINDOWS					*
;* Data Bank 7e							*
;* Y reg :Player Heap Pointer					*
;*********************************************************************
SetWindowTabs_l
	km_PushAllReg
	a8i16
	db7e
;---------------------------------------------------------------------
.onescreen
	SetPlayerHeapPtr	1,y
	jsr	SetCockpitWindow
;---------------------------------------------------------------------
.twoscreen
	km_bitcheckgameflag	battle
	beq	.end

	SetPlayerHeapPtr	2,y
	jsr	SetCockpitWindow
;---------------------------------------------------------------------
.end
	km_PullAllReg
	rtl

;=====================================================================
;*		Set h-dma tabs (window) 			*
;* Data Bank 7e							*
;* Y reg :player pointer						*
;* kz_x1	:hit flash repeat address				*
;* kz_x2	:circle flash repeat address				*
;* kz_tempaddrl :hdma table address					*
;=====================================================================
SetCockpitWindow
	shorta
	longi
;* Set Window Double buffer pointer *
	a16
	km_setval	kz_x1,0		;repeat
	km_setval	kz_x2,0		;no repeat

	km_bitcheckwindowflag	windowWbuf
	beq	.buffer1
.buffer2
	km_setval	kz_x1,htflbuflen/2	;repeat
	km_setval	kz_x2,circbuflen/2	;no repeat
.buffer1
	a8
;* h-dma table data bank *
	km_setval	kz_tempaddrl+2,$7e

;* Hit Flash Window *
	jsr	HitFlashWindow

;* Bom Circle Window *
	jsr	CircleWindow

;* Ring Out Window *
;;;;	jsr	RingOutWindow
	rts

;---------------------------------------------------------------------
;*			Hit Flash Window			* 
;* Init,Exit Memory Mode :mem8,idx16					*
;* Data Bank 7e							*
;* Yreg : Player Heap pointer					*
;---------------------------------------------------------------------
HitFlashWindow
	shorta
	longi
	sty	kpointer	;kpointer <--- Player Heap Pointer

;	s_jmp_alvarzero		B,y,exal_nohit,HitFlashWindowOff
;	s_jmp_alvarAND		B,y,exal_nohit,#exal_nohit_scrsplash,.Parameter
;	s_jmpnot_alvarAND	B,y,exal_nohit,#exal_nohit_scrflash,HitFlashWindowOff

	lda.w		exal_scrflash,y
	rlbeq		HitFlashWindowOff
	dec		a
	sta.w		exal_scrflash,y
.Parameter
	a16
	lda	#xhdma_htflhofs&WM
	clc
	adc	kz_x1
	sta	kz_tempaddrl
;---------------------------------------------------------------------------
	IFNE	kbattle
	test_screenmode	onescreen
	bne	.onescreenmode		;If battle mode
	jmp	.twoscreenmode
	ENDC

.onescreenmode
	alloc_window	hitflash,1	; x = hitflash
	lda	kz_tempaddrl
	sta	wm_hdma,x		;HDMA Table Set

	alloc_window	hitflash,2	; x = hitflash
	lda	kz_tempaddrl
	inc	a
	inc	a
	sta	wm_hdma,x		;HDMA Table Set

	ldy	#0			;HDMA Table Pointer
	km_sethdmatabs_reptwin	mission,MissHtflSta,MissHtflEnd
	alloc_window	hitflash,1	; x = hitflash
	bra	.SetRegister
;---------------------------------------------------------------------------
	IFNE	kbattle
.twoscreenmode
	lda	kplayer
	bit	#1
	bne	.player2
	alloc_window	hitflash,1	; x = hitflash

	lda	kz_tempaddrl
	sta	wm_hdma,x		;HDMA Table Set
	ldy	#0			;HDMA Table Init Pointer
	km_sethdmatabs_reptwin	battle,P1HtFlXSta,P1HtFlXEnd
	bra	.skip

.player2
	alloc_window	hitflash,2	; x = hitflash
	lda	kz_tempaddrl
	INC	A
	INC	A
	sta	wm_hdma,x		;HDMA Table Set
	ldy	#2			;HDMA Table Init Pointer
	km_sethdmatabs_reptwin	battle,P2HtFlXSta,P2HtFlXEnd
.skip
	ENDC
;============ Window Register Para Set ===============
.SetRegister
	a8
	ldy	kpointer		;kpointer <--- Player Work
	lda	#0
	sta	wm_w12sel,x	;2123h
	sta	wm_w34sel,x	;2124h

	lda	#00000011b
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#00010000b
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda	#00100011b
	sta	wm_cgadsub,x	;2131h	;bg1 bg2

	lda	#0
	sta	wm_coldata,x		;R,G,B wo tukau

	lda.w	exal_addcol_r,y
	ora	#20h
	sta	wm_coldata_r,x		;2132h	;Red

	lda.w	exal_addcol_g,y
	ora	#40h
	sta	wm_coldata_g,x		;2132h	;Green

	lda.w	exal_addcol_b,y
	ora	#80h
	sta	wm_coldata_b,x		;2132h	;Blue

	lda	wm_flags,x		;<<< Xreg ari
	ora	#wf_datarepeat
	sta	wm_flags,x		;window repeat flag on

	lda	#xhdma_htflhofs>>16
	sta	wm_hdma+2,x	;4304h		:hdma table address

	lda	#$20
	sta	wm_wobjsel,x	;2125h :window mask
	lda	#$0c
	sta	wm_wobjlog,x	;212bh :windoe logic
	lda	#$41
	sta	wm_chparams,x	;4350h :channel parameter set
	jmp	HitFlashWindowEnd

HitFlashWindowOff
	test_screenmode	onescreen
	beq	.battle		;If Cockpit Display

.mission	dealloc_window	hitflash,1	;if Hit Flash Window End
	dealloc_window	hitflash,2	;if Hit Flash Window End
	bra	HitFlashWindowEnd

.battle	lda	kplayer
	bne	.player2
	dealloc_window	hitflash,1	;if Hit Flash Window End
	bra	HitFlashWindowEnd
.player2
	dealloc_window	hitflash,2	;if Hit Flash Window End

HitFlashWindowEnd
	rts



;---------------------------------------------------------------------
;*			Circle Window				* 
;* Data Bank 7e							*
;* Yreg  :Player Heap Pointer					*
;* Input :								*
;* kx_circleCX   :Circle Center X postion	:(8 bit) :7e RAM	*
;* kx_circleCY   :Circle Center Y postion	:(8 bit) :7e RAM	*
;* kx_circleR    :Circle Max Radius		:(8 bit) :7e RAM	*
;* kx_circlestep :Circle Radius Step		:(8 bit) :7e RAM	*
;* kx_circlefade :Circle Fade Down Step	:(8 bit) :7e RAM	*
;* kx_circleadsub:Circle Window cgadd switch :(8 bit) :7e RAM	*
;* kx_circlecolR :Circle Colour RED		:(8 bit) :7e RAM	*
;* kx_circlecolG :Circle Colour GREEN	:(8 bit) :7e RAM	*
;* kx_circlecolB :Circle Colour BLUE 	:(8 bit) :7e RAM	*
;---------------------------------------------------------------------
CircleWindow
	shorta
	longi

;* Circle Window Test Mode *
	IFEQ	1
	km_testjoypad	x
	beq	.skip
	a16
	lda	#$80
	sta.w	kx_circleCX,y
	sta.w	kx_circleCY,y
	lda	#255
	sta.w	kx_circleR,y
	a8
	km_setval.w	kx_circlewindowmode,winm_open,y
	km_setval.w	kx_circleadsub,00000001b,y
	km_setval.w	kx_circlecolR,$1f,y
	km_setval.w	kx_circlecolG,$05,y
	km_setval.w	kx_circlecolB,$1f,y
	km_setval.w	kx_circlefade,8,y
	km_setval.w	kx_circlestep,8,y
.skip
	ENDC

	km_hib0
	lda.w	kx_circlewindowmode,y
	tax
	jmp	(.circletable,x)

.circletable
	dw	.nothing&WM
	dw	.opentrig&WM
	dw	.circle&WM
	dw	.close&WM
	dw	CircleWindowOFF&WM
;-------------------------------------------------------------------------
.nothing
	shorta
	rts
;;;	brl	CircleWindowEND
;-------------------------------------------------------------------------
.opentrig
	shorta
	a16
	lda	#0
	sta.w	kx_circleTR,y

;* circle buffer clear *
	PHX
	lda	#$0001
	ldx	#circbuflen
.loop
	sta	xhdma_circhofs-2,x
	dex
	dex
	bne	.loop
	PLX

	a8
	km_setval.w	kx_circlewindowmode,winm_cilcle,y
	rts
;-------------------------------------------------------------------------
.close
	shorta
	lda.w	kx_circlecolR,y
	jsr	.chase0
	sta.w	kx_circlecolR,y
.CheckGreen
	lda.w	kx_circlecolG,y
	jsr	.chase0
	sta.w	kx_circlecolG,y

.CheckBlue
	lda.w	kx_circlecolB,y
	jsr	.chase0
	sta.w	kx_circlecolB,y
.FadeFinishCheck
	lda.w	kx_circlecolR,y
	ora.w	kx_circlecolG,y
	ora.w	kx_circlecolB,y
	bne	.circle
	km_setval.w	kx_circlewindowmode,winm_off,y
	brl	CircleWindowOFF
;-------------------------------------------------------------------------
.chase0
	shorta
	beq	.chase0END
	sec
	sbc.w	kx_circlefade,y
	bpl	.chase0END
	lda	#0
.chase0END
	rts
;-------------------------------------------------------------------------
.circle
	shorta
	POLL_MARIO
	a16
	lda.w	kx_circleCX,y
	sta.l	m_bigx		;center X
	lda.w	kx_circleCY,y
	sta.l	m_bigy		;center Y
	lda.w	kx_circleTR,y
	sta.l	m_rotx		;Radius
	call_mario	mcalc_circle	;Circle (L,R) data calc

;* Radius Add *
	lda.w	kx_circleTR,y
	cmp.w	kx_circleR,y
	bcs	.NoAddRadius
.AddRadius
	clc
	adc.w	kx_circlestep,y
	sta.w	kx_circleTR,y
	bra	.skip1
.NoAddRadius
	km_setval.w	kx_circlewindowmode,winm_close,y
.skip1
;**** Set H-DMA Table Data ****
	lda	#xhdma_circhofs&WM
	clc
	adc	kz_x2
	sta	kz_tempaddrl

	sty	kpointer		;>>> PUSH Player Heap Pointer
;---------------------------------------------------------------------------
	longa
	longi
	test_screenmode	onescreen
	bne	.onescreenmode		;If battle mode
	jmp	.twoscreenmode
.onescreenmode
	alloc_window	circle,1	; x = circle
	lda	kz_tempaddrl
	sta	wm_hdma,x		;HDMA Table Set

	alloc_window	circle,2	; x = circle
	lda	kz_tempaddrl
	clc
	adc	#circbuflen/4
	sta	wm_hdma,x		;HDMA Table Set

	ldy	#0			;HDMA Table Pointer
	km_sethdmatabs_circwin	MissWinLine*2,MissWinXSta,MissWinXEnd,MissWinYSta
	alloc_window	circle,1	; x = circle

; Kawagoe ---->

;;;	lda	playpt1
;;;	sta	tpy
; <----

	jmp	.SetRegister
;---------------------------------------------------------------------
.twoscreenmode
	longa	
	longi
	lda	kplayer
	and	#$ff
	beq	.player1
	jmp	.player2
.player1
	alloc_window	circle,1	; x = cilcle window
	lda	kz_tempaddrl
	sta	wm_hdma,x

	ldy	#0
	km_sethdmatabs_circwin	P1WinLine,P1WinXSta,P1WinXEnd,P1WinYSta

; Kawagoe ---->

;;;	lda	playpt1
;;;	sta	tpy
; <----

	bra	.SetRegister
.player2
	alloc_window	circle,2	; x = cilcle window
	lda	kz_tempaddrl
	clc
	adc	#circbuflen/4
	sta	wm_hdma,x		;HDMA Table Set

	ldy	#circbuflen/4
	km_sethdmatabs_circwin	P2WinLine,P2WinXSta,P2WinXEnd,P2WinYSta

; Kawagoe ---->

;;;	lda	playpt2
;;;	sta	tpy
; <----

;============ Window Register Para Set ===============
.SetRegister
	a8
	UNPOLL_MARIO
; Kawagoe ------->>>>>

;;;	ldy	tpy
;;;	toheap	y,y

	ldy	kpointer		;<<< PULL Player Heap Pointer
	lda	#0
	sta	wm_w12sel,x	;2123h
	sta	wm_w34sel,x	;2124h

	lda	#00000011b
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#00010000b
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda.w	kx_circleadsub,y		;#00000011b kawagoe
;	lda	exal_circle_adsub,y
	sta	wm_cgadsub,x	;2131h	;bg1 bg2

;;;	lda	exal_circle_r,y	;#$3f
	lda.w	kx_circlecolR,y
	ora	#20h
	sta	wm_coldata_r,x	;2132h	;Red

;;;	lda	exal_circle_g,y	;#$45
	lda.w	kx_circlecolG,y
	ora	#40h
	sta	wm_coldata_g,x	;2132h	;Green

;;;	lda	exal_circle_b,y	;;#$9f
	lda.w	kx_circlecolB,y
	ora	#80h
	sta	wm_coldata_b,x	;2132h	;Blue

	lda	#xhdma_circhofs>>16
	sta	wm_hdma+2,x	;4304h		:hdma table address

	lda	#$20
	sta	wm_wobjsel,x	;2125h :window mask
	lda	#$0c
	sta	wm_wobjlog,x	;212bh :windoe logic
	lda	#$41
	sta	wm_chparams,x	;4350h :channel parameter set

	lda	wm_flags,x		;<<< Xreg ari
	and	#wf_datarepeat
	sta	wm_flags,x		;window repeat flag on

	jmp	CircleWindowEND


	IFEQ	1
; old lines	lda	#0
	sta	wm_w12sel,x	;2123h
	sta	wm_w34sel,x	;2124h
	lda	#00000011b
	sta	wm_ts,x		;212fh :bg1,bg2
	lda	#00010000b
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)
	lda	#00000011b
	sta	wm_cgadsub,x	;2131h	;bg1 bg2
	lda	#$3f
	sta	wm_coldata_r,x	;2132h	;Red
	lda	#$45
	sta	wm_coldata_g,x	;2132h	;Green
	lda	#$9f
	sta	wm_coldata_b,x	;2132h	;Blue
	lda	#xhdma_circhofs>>16
	sta	wm_hdma+2,x	;4304h		:hdma table address
	lda	#$20
	sta	wm_wobjsel,x	;2125h :window mask
	lda	#$0c
	sta	wm_wobjlog,x	;212bh :windoe logic
	lda	#$41
	sta	wm_chparams,x	;4350h :channel parameter set
	jmp	CircleWindowEND
	ENDC

;<<<<<--------------------

CircleWindowOFF
	tyx	;>>>> PULL X
	km_setval.w	kx_circlewindowmode,winm_nothing,y

	test_screenmode	onescreen
	beq	.battle			;If Cockpit Display

.mission	dealloc_window	circle,1	;if Hit Flash Window End
	dealloc_window	circle,2	;if Hit Flash Window End
	bra	CircleWindowEnd

.battle	lda	kplayer
	bne	.p2
	dealloc_window	circle,1
	bra	CircleWindowEND
.p2
	dealloc_window	circle,2
;---------------------------------------------------------------------------
CircleWindowEND
	rts

;=============================================================
;*		HDMA CILCLE SUBROUTINE			*
;* Data Bank :7e						*
;* X reg:Circle Data Pointer					*
;* Y reg:HDMA Table Pointer					*
;=============================================================
HDMACircle_sub	
	shorta
	longi
.loop
	lda.l	m_circlebuf,x
	sec
	sbc.l	m_circlebuf2,x		;(right side) -(left side) >=0
	bcs	.clip
;---------------------------------------
;(right side) < (left side) Case 
	lda.l	m_circlebuf2,x
	sta.l	[kz_tempaddrl],y	;left side data
	iny
	lda.l	m_circlebuf,x
	sta.l	[kz_tempaddrl],y	;right side data
	iny
	bra	.notclip
;---------------------------------------
;(Left Side)
.clip
	lda.l	m_circlebuf2,x
	cmp	kclipsx
	bcs	.notclipSX	;if SX clip not need (left side >= sx)

	lda	kclipsx
.notclipSX
	sta.l	[kz_tempaddrl],y
	iny
;---------------------------------------
;(Right Side)
	lda.l	m_circlebuf,x
	cmp	kclipex
	bcc	.notclipex	;(Right side < ex)
	lda	kclipex
.notclipex
	sta.l	[kz_tempaddrl],y
	iny
;---------------------------------------
.notclip
	inx
	inx
	dec	kcounter
	bne	.loop		;if Data Set End ===> jmp End
	rts


;=============================================================
;*			Pause Window		[PAUSE]	*
;* Data :Bank 7e						*
;* Yreg :Player Heap Pointer					*
;=============================================================
PauseWindow_l
	shorta
	longi
	km_pushallreg
	db7e

	IFNE	kbattle
	test_screenmode	onescreen
	bne	.onescreenmode		;If battle mode
	jmp	.twoscreenmode
	ENDC
;-------------------------------------------------------------------------
.onescreenmode
	km_jmpnotgameflag	pausedisable,.pausewindowoff
	jsr	.setbufferadr
	ldy	#0	;HDMA Table Pointer
	km_sethdmatabs_reptwin	mission,MissHtflSta,MissHtflEnd
	alloc_window	pausewindow,1	; x = hitflash
	jsr	PauseWindowSub
	brl	.PauseWindowEnd
;-------------------------------------------------------------------------
	IFNE	kbattle
.twoscreenmode
	km_jmpnotbattleflag	p12pauseflag,.pausewindowoff
	jsr	.setbufferadr

	ldy	#0	;HDMA Table Pointer
	km_sethdmatabs_reptwin	battle,P1HtFlXSta,P1HtFlXEnd
	km_sethdmatabs_reptwin	battle,P2HtFlXSta,P2HtFlXEnd

	alloc_window	pausewindow,1	; x = pause window
	jsr	PauseWindowSub
	alloc_window	pausewindow,2	; x = pause window
	jsr	PauseWindowSub
	bra	.PauseWindowEnd
	ENDC
;----------- Window Off ------------
.pausewindowoff
	dealloc_window	pausewindow,1	;Window Off
	dealloc_window	pausewindow,2	;Window Off
.PauseWindowEnd
	km_pullallreg
	rtl
;---------------------------------------------------------------------
;*		Pause hdma tabs buffer address set		*
;---------------------------------------------------------------------
.setbufferadr
	shorta
	longi

	php
	km_setval	kz_x1,0
	km_bitcheckwindowflag	windowwbuf
	beq	.buffer1
.buffer2
	km_setval	kz_x1,4
.buffer1
	a16
	lda	kz_x1
	and	#$ff
	clc
	adc	#xhdma_pausehofs&WM
	sta	kz_tempaddrl
	a8
	lda	#(xhdma_pausehofs>>16)
	sta	kz_tempaddrl+2

	alloc_window	pausewindow,1	; x = hitflash
	ldy	kz_tempaddrl
	sty	wm_hdma,x		;HDMA Table Set

	alloc_window	pausewindow,2	; x = hitflash
	ldy	kz_tempaddrl
	iny
	iny
	sty	wm_hdma,x		;HDMA Table Set

	plp	
	rts
;=============================================================
;*		Window Parametr Set		[Pause]	*
;* Xreg :Window reg parameter pointer			*
;* Yreg :HDMA Table pointer					*
;=============================================================
PauseWindowSub
	shorta
	longi
;============ Window Register Para Set ===============
	lda	#0
	sta	wm_w12sel,x	;2123h
	sta	wm_w34sel,x	;2124h

	lda	#%00000011
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#%00010000
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda	#%11000011
	sta	wm_cgadsub,x	;2131h	;1/2 bg1 bg2

	lda	#$3f	;23
	sta	wm_coldata_r,x	;2132h	;Red

	lda	#$5f	;43
	sta	wm_coldata_g,x	;2132h	;Green

	lda	#$9f	;83
	sta	wm_coldata_b,x	;2132h	;Blue

	lda	wm_flags,x
	ora	#wf_datarepeat
	sta	wm_flags,x	;window repeat flag on

	lda	#$20
	sta	wm_wobjsel,x	;2125h :window mask
	lda	#$0c
	sta	wm_wobjlog,x	;212bh :windoe logic
	lda	#$41
	sta	wm_chparams,x	;4350h :channel parameter set

	lda	#xhdma_pausehofs>>16
	sta	wm_hdma+2,x	;4354h		:hdma table address

	rts

;---------------------------------------------------------------------
;*			Set Window SFX Register			*
;* X reg = window params pointer					*
;---------------------------------------------------------------------
	IFEQ	1
SetWindowParams
	shorta
	longi
	phx		;>>> PUSH X
	phy		;>>> PUSH Y

	a16
	txy
	ldx	#kx_wm_w12swl&WM
	lda	#wm_sizeof-1
	km_mvn	kx_wm_w12swl,wm_w12sel
	a8
	ply		;>>> PULL Y
	plx		;>>> PULL X
	rts
	ENDC

;---------------------------------------------------------------------
;*			Ring Out Window				*
;* Data Bank 7e							*
;* Xreg : window work pointer					*
;* Yreg : HDMA table pointer ,player pointer				*
;* KHDMATbl	macro [reg,val,left,right,table name]			*
;---------------------------------------------------------------------
	IFEQ	1
RingOutWindow
	php
	shorta
	longi
	phx
	km_jmpnotflag	KRingOutTimer,KROutFlag,RingOutWindowOff,x
	stx	kpointer		;kpointer <--- Player Work

	a16
	lda	#xhdma_outhofs&WM
	clc
	adc	kz_x1
	sta	kz_tempaddrl
;---------------------------------------------------------------------------
	test_screenmode	onescreen
	bne	.onescreenmode
	jmp	.twoscreenmode
.onescreenmode
;* window table address set *
	alloc_window	outofbounds,1	; x = outofbounds

	lda	kz_tempaddrl
	sta	wm_hdma,x		;HDMA Table Set

	alloc_window	outofbounds,2	; x = outofbounds
	lda	kz_tempaddrl
	inc	a
	inc	a
	sta	wm_hdma,x		;HDMA Table Set

	ldy	#0			;HDMA Table Pointer
	km_sethdmatabs_reptwin	mission,MissHtflSta,MissHtflEnd
	alloc_window	outofbounds,1	; x = outofbounds
	bra	.SetRegister
.twoscreenmode
	lda	kplayer
	and	#1
	bne	.player2

	alloc_window	outofbounds,1	; x = outofbounds
	lda	kz_tempaddrl
	sta	wm_hdma,x		;HDMA Table Set

	ldy	#0			;HDMA Table Init Pointer
	km_sethdmatabs_reptwin	battle,P1HtFlXSta,P1HtFlXEnd
	bra	.skip
.player2
	alloc_window	outofbounds,2	; x = outofbounds
	lda	kz_tempaddrl
	INC	A
	INC	A
	sta	wm_hdma,x		;HDMA Table Set
	ldy	#2			;HDMA Table Init Pointer
	km_sethdmatabs_reptwin	battle,P2HtFlXSta,P2HtFlXEnd
.skip
;============ Window Register Para Set ===============
.SetRegister
	a8
	ldy	kpointer	;Yreg <--- Plyer Work Pointer

	lda	#0
	sta	wm_w12sel,x	;2123h
	sta	wm_w34sel,x	;2124h

	lda	#$00000011
	sta	wm_ts,x		;212fh :bg1,bg2

	lda	#%00010000
	sta	wm_cgswsel,x	;2130h	;col fix data (area in)

	lda	#%10000011
	sta	wm_cgadsub,x	;2131h	;col sub (bg1,bg2)

	ifeq	0
	lda.w	kringouttimer,y
	eor	#$ff
	and	#$0f
	ora	#%11100000
	sta	wm_coldata,x	;2132h	;Red Blue Green
	endc

	ifeq	1
	lda.w	kringouttimer,y
	eor	#$ff
	and	#$0f
	ora	#$20
	sta	wm_coldata_r,x	;2132h	;Red

	lda.w	kringouttimer,y
	eor	#$ff
	and	#$0f
	ora	#$40
	sta	wm_coldata_g,x	;2132h	;Green

	lda.w	kringouttimer,y
	eor	#$ff
	and	#$0f
	ora	#$80
	sta	wm_coldata_b,x	;2132h	;Blue
	endc

	lda	wm_flags,x
	ora	#wf_datarepeat
	sta	wm_flags,x		;repeat flag on

	lda	#xhdma_outhofs>>16
	sta	wm_hdma+2,x	;4304h	:hdma table address

	lda	#$20
	sta	wm_wobjsel,x	;2125h :window mask
	lda	#$0c
	sta	wm_wobjlog,x	;212bh :windoe logic
	lda	#$41
	sta	wm_chparams,x	;4350h :channel parameter set

	jmp	RingOutWindowEnd

RingOutWindowOff
	shorta
	test_screenmode	onescreen
	beq	.battle		;If Cockpit Display

.mission	dealloc_window	outofbounds,1	;if Hit Flash Window End
	dealloc_window	outofbounds,2	;if Hit Flash Window End
	bra	RingOutWindowEnd

.battle	lda	kplayer
	bne	.player2
	dealloc_window	outofbounds,1	;if Ring Out Window End
	bra	RingOutWindowEnd
.player2
	dealloc_window	outofbounds,2	;if Ring Out Window End
RingOutWindowEnd
	plx
	plp
	rts
	ENDC

;*********************************************************************
;*								*
;*		PLayer BOM Shot & Hit Flash			*
;*********************************************************************
	IFEQ	1
;-------------------------------------------------------------
;*		BOM Shoot Check				*
;* Data Bank 7e						*
;-------------------------------------------------------------
Check_KGwindow_l
	php
	phx
	phy

	a8i16
	ldx	playpt1
	ldy	al_sword2,x


; Kawagoe ---->>>>

	lda	exal_circle_flag,y
	bit	#exal_circle_flag_on
	beq	.nopushA_pl1
	and	#~exal_circle_flag_on
	sta	exal_circle_flag,y

;	km_testjoypad	A
;	beq	.nopushA_pl1

;<<<< ----

	lda	KBOMSHOT,y
	bmi	.nopushA_pl1
	ora	#kBomShotflag
	clc
	adc.l	CircleData
	sta	KBOMSHOT,y
.nopushA_pl1
	jsr	Check_BomShotSub

	ldx	playpt2
	ldy	al_sword2,x

	km_bitcheckgameflag	battle
	beq	.skip
.player2


; Kawagoe ---->>>>

	lda	exal_circle_flag,y
	bit	#exal_circle_flag_on
	beq	.nopushA_pl1
	and	#~exal_circle_flag_on
	sta	exal_circle_flag,y
;	km_testjoypad2	A
;	beq	.nopushA_pl2
;<<<< ----
	lda	KBOMSHOT,y
	bmi	.nopushA_pl2
	ora	#kBomShotflag
	clc
	adc.l	CircleData
	sta	KBOMSHOT,y
.nopushA_pl2
	jsr	Check_BomShotSub
.skip
;-------------------------------------------------------------
;*	Wepon damage check
;-------------------------------------------------------------
	ifeq	1
;----- Damage window check --
	jmpnotflag	KHITFLASH,#kdmgwinflag,.NoFlag,y
;----- Window timer set -----
	lda	KHITFLASH,y
	and	#~kdmgallflag
	dec	a
	bmi	.DMGwinEnd
	ora	#kdmgwinflag
	sta	KHITFLASH,y
	bra	.Noflag
.DMGwinEnd
	lda	#0
	sta	KHITFLASH,y	;Timer Dec
.NoFlag
;----- Hit check -----
;	s_jmpNOT_alsflag x,collide,.exit

	s_jmp_ifhitby	x,ENEMYWEAP,.hit
	s_jmp_ifhitby	x,FRIEND,.hit
	jmp	.exit

;----- hit damage ----
.hit
	lda	#DmgIntTm
	ora	#kdmgallflag
	sta	KHITFLASH,y

	kplsound	damage_l
	endc
;-------------------------------------------------------------
.exit
	ply
	plx
	plp
	rtl

;-------------------------------------------------------------
;*		BOM Shot Radius Set			*
;-------------------------------------------------------------
Check_BomShotSub
	shorta
	longi
	km_jmpnotflag	KBOMSHOT,kBomShotflag,.NoBom,y
	lda	KBOMSHOT,y
	and	#~kBomShotflag
	and	#~$80
	dec	a
	bpl	.Timerset
	beq	.Timerset

	lda	#0
	sta	KBOMSHOT,y
	bra	.NoBom
.Timerset
	ora	#kBomShotflag
	sta	KBOMSHOT,y
.NoBom
	rts

	ENDC


;*********************************************************************
;*								*
;*		Fade routine    (Black,White,Red)		*
;*								*
;*********************************************************************
initblack_l
	php
	a8i16

	km_qfadestepup
	km_setval	fade,0
	km_setval	stayblack,2

	IFEQ	1
	lda	#10
	sta	stayblack		;black wait time
	alloc_window	blackfade,1
	lda	#31	;max = 31 made
	sta	wm_val,x	;fade init
	stz	wm_ts,x
	alloc_window	blackfade,2
	lda	#31	;max = 31 made
	sta	wm_val,x	;fade init
	stz	wm_ts,x
	jsl	setblack_l
	a8
	stz	fade
;94/6/1 :kawaguchi
;fade in step value
	km_setval	kw_blackfadestep,4
	ENDC

	plp
	rtl


;--------------------------------------------------------
;black wait
;----------
setblack_l
	php
	a8i16
	lda	stayblack
	inc	a
	beq	.clrit
	dec	stayblack
.clrit
	plp
	rtl
;--------------------------------------------
	ifeq	1
	php
	a8i16
	lda	stayblack
	inc	a
	beq	.clrit

	alloc_window	blackfade,1
	txy
	alloc_window	blackfade,2

	lda	#0
	sta	wm_ts,x
	sta.w	wm_ts,y

	lda	#2
	sta	wm_cgswsel,x
	sta.w	wm_cgswsel,y

	lda	#%10100111
	sta	wm_cgadsub,x
	sta.w	wm_cgadsub,y

	lda	wm_val,x
	ora	#%11100000
	sta	wm_coldata,x
	sta.w	wm_coldata,y


	lda	stayblack
	bne	.blackit

	lda	wm_val,x
	beq	.decit
;-------------------------------------------------------
;94/6/1 ni henkou :kawaguchi
	sec
	sbc	kw_blackfadestep	;fade step
	bpl	.setval
	lda	#0
.setval
;-------------------------------------------------------
	sta	wm_val,x
	sta.w	wm_val,y
	bra	.end
.blackit
	lda	#0
	sta	wm_ts,x
	sta.w	wm_ts,y
	lda	#%11100111
	sta	wm_cgadsub,x
	sta.w	wm_cgadsub,y
	lda	#255
	sta	wm_coldata,x
	sta.w	wm_coldata,y

.decit
	dec	stayblack
.end	plp
	rtl
.clrit	dealloc_window	blackfade,1
	dealloc_window	blackfade,2
	jmp	.end

	endc
;--------------------------------------------------------
fadewhite_l
	jsr	fadewhite
	rtl
fadewhite
	php
	a8i16
	phx
	alloc_window	whitefade,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%00000111
	sta	wm_cgadsub,x
	lda	#%11100000
	ora	wm_val,x
	sta	wm_coldata,x
	lda	wm_val,x
	cmp	#31
	beq	.nc
	inc	a
	sta	wm_val,x
.nc	plx
	plp
	rts


;--------------------------------------------------------
flashturq_l
	php
	a8i16
	phx
	alloc_window	hitflash,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%00100111
	sta	wm_cgadsub,x
	stz	wm_coldata_r,x
	lda	#%11111
	sta	wm_coldata_g,x
	sta	wm_coldata_b,x

	stz	wm_coldata,x
	plx
	plp
	rtl
         
;--------------------------------------------------------
flashturq2_l
	php
	a8i16
	phx
	alloc_window	hitflash,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%00100111
	sta	wm_cgadsub,x
	stz	wm_coldata_r,x
	lda	#%111
	sta	wm_coldata_g,x
	sta	wm_coldata_b,x
	stz	wm_coldata,x
	plx
	plp
	rtl
	
	
;--------------------------------------------------------
flashred_l
	php
	a8i16
	phx
	alloc_window	hitflash,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%00100111
	sta	wm_cgadsub,x
	stz	wm_coldata,x
	lda	#31
	sta	wm_coldata_r,x
	stz	wm_coldata_g,x
	stz	wm_coldata_b,x
	plx
	plp
	rtl

;--------------------------------------------------------
dyingred_l
	php
	a8i16
	phx
	alloc_window	dyingred,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%00100111
	sta	wm_cgadsub,x
	stz	wm_coldata,x
	lda	#10
	sta	wm_coldata_r,x
	stz	wm_coldata_g,x
	stz	wm_coldata_b,x
	plx
	plp
	rtl

;--------------------------------------------------------
dyingredoff_l
	php
	a8i16
	phx
	dealloc_window	dyingred,1
	plx
	plp
	rtl



;--------------------------------------------------------
initfadewhite2norm_l
	php
	a8i16
	phx
	alloc_window	whitefade,1
	lda	#31
	sta	wm_val,x
	plx
	plp
	jsr	fadewhite2norm
	rtl

fadewhite2norm_l
	jsr	fadewhite2norm
	rtl
fadewhite2norm	
	php
	a8i16
	phx
	alloc_window	whitefade,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%00000111
	sta	wm_cgadsub,x
	lda	#%11100000
	ora	wm_val,x
	sta	wm_coldata,x
	lda	wm_val,x
	beq	.nc
	dec	a
	sta	wm_val,x
	plx
	plp
	rts
.nc	dealloc_window	whitefade,1
	plx
	plp
	rts

;--------------------------------------------------------

bossflash_l
	php
	a8i16
	phx
	alloc_window	dyingred,1
	stz	wm_ts,x
	lda	#2
	sta	wm_cgswsel,x
	lda	#%00100111
	sta	wm_cgadsub,x
	stz	wm_coldata_r,x
	lda	#%11111
	sta	wm_coldata_g,x
	sta	wm_coldata_b,x

	stz	wm_coldata,x
	plx
	plp
	rtl

;--------------------------------------------------------
;*****************************************************************************
;*									*
;*			Wipe Wait					*
;* Init  :kw_wipetimer <<< wipe timer					*
;* Break :X reg								*
;*****************************************************************************
kwipewait_l
	jsr	kwipewait
	rtl
kwipewait
;!!! tyuui !!! I flag (warikomi fiag wo motoni modoshite imautame tukaenai !!)
;;;;;;;	php
;;;;;;;	a8i16
	SHORTA
	LONGI
.wipeloop
	jsl	wipe_l
	jsl	find_window_pri_l
	jsl	do_sprites_l	;[sprites]

	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]

	km_decwipetimer
	bne	.wipeloop
.screenoff
	km_screenoff	;( SCREEN,IRQ,HDMA OFF )
	km_clrwipeclose	;Wipe Close Set

;;;;;;;	plp
	rts
;*****************************************************************************
;*									*
;*			Wipe Fade Wait					*
;* Init :kw_wipetimer <<< wipe timer						*
;*****************************************************************************
kwipefadewait_l
	jsr	kwipefadewait
	rtl
kwipefadewait
;!!! tyuui !!! I flag (warikomi fiag wo motoni modoshite imautame tukaenai !!)
;;;;;;;;	php
;;;;;;;;	a8i16

	SHORTA
	LONGI
.wipeloop
	ldx	kw_wipetimer
	dex
	stx	kw_wipetimer
	beq	.screenoff
	cpx	#16
	bpl	.wipeset
.fadestart
	km_fadestepdown
.wipeset
	jsl	wipe_l
	jsl	find_window_pri_l
	jsl	do_sprites_l		; [sprites]

	km_fadedowncheck
	bne	.wipeloop
.screenoff
	km_screenoff	;( SCREEN,IRQ,HDMA OFF )
	km_clrwipeclose	;(wipe close)
;;;;;;;;;	plp
 	rts

;=====================================================================
;*		Sound BGM Fade					*
;*								*
;=====================================================================
KBGMFade_l
	shorta
	longi
	stx	kw_wipetimer
	km_soundallstop
	km_fadestepdown
.sndfadeloop
	km_decwipetimer
	beq	.finishfade

	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]
	bra	.sndfadeloop
.finishfade
	km_screenoff	;( SCREEN,IRQ,HDMA OFF )
	km_clrwipeclose
	rtl

;=====================================================================
;*		Sound BGM Fade					*
;*								*
;=====================================================================
KBGMFade2_l
	ifeq	1
	shorta
	longi
	ldx	#16
	stx	kw_wipetimer
	km_soundallstop
.sndfadeloop
	lda	#iv_titleirq
	sta	trans_flag	;[irq flag]
	km_waittrans		;[irq wait]
	km_decwipetimer
	bne	.sndfadeloop
	rtl
	endc

;=====================================================================
;*								*
;*			Wipe Open Check				*
;*								*
;=====================================================================
check_wipeopen_l
	jsr	check_wipeopen
	rtl
check_wipeopen
	shorta
	longi
	km_decwipetimer
	bne	.exit
	dealloc_window	wipe,1
	dealloc_window	wipe,2
	km_clrwindowflag	wipeopen
.exit
	rts

;=====================================================================
;*								*
;*			Wipe Close Check			*
;*								*
;=====================================================================
check_wipeclose_l
	jsr	check_wipeclose
	rtl
check_wipeclose
	shorta
	longi
	km_soundallstop

	km_decwipetimer
	beq	.wipeend
	cpx	#16		;fade check
	bpl	.wipeset
	km_qfadestepdown
.wipeset
	jsl	wipe_l
	brl	.exit
.wipeend
	km_clrwipeclose		;window mode clear
.exit
	rts
;*********************************************************************
;*								*
;*			Fade Out				*
;* Input :(KW_FadeWaitTm :2 byte) moshi wait ga hituyou nara !!	*
;* Exit  :a8i16							*
;*       :clc/sec ... fade doing/fade finish				*
;*********************************************************************
kfadeout_l
	a16
	km_bitcheckwindowflag	fade
	beq	.exit
	km_bitcheckwindowflag	init
	bne	.initOK
	km_setwindowflag	init
	km_soundallstop
.initOK	km_dectimer0	KW_FadeWaitTm
	bne	.exit
.fadestart
	a8
	lda	fade
	beq	.fadefinished
	km_qfadestepdown
	bra	.exit
.fadefinished
	a16
	km_clrwindowflag	fade
	km_clrwindowflag	init
	a8
	sec
	rtl	
.exit
	a8
	clc
	rtl

;*********************************************************************
;*								*
;*			Wipe Close				*
;* Input :(KW_FadeWaitTm :2 byte) moshi wait ga hituyou nara !!	*
;* Exit  :a8i16							*
;*       :clc/sec ... fade doing/fade finish				*
;*********************************************************************
kwipeclose_l
	a16
	km_bitcheckwindowflag	wipeclose
	beq	.exit
	km_bitcheckwindowflag	init
	bne	.initOK
	km_setwindowflag	init

;!!'95/6/6 :fade out nakusu !! (iangaki)
;;;	km_soundallstop
	km_setsndflag	allstop

	km_initwipeclose	mission
.initOK
	ldx	kw_wipetimer
	dex
	stx	kw_wipetimer
	beq	.fadefinished
	dex
	bne	.exit
.screenblack
	a8
	km_screenblack
	bra	.exit
.fadefinished
	a16
	km_clrwindowflag	wipeclose
	km_clrwindowflag	init
	km_clrwipeclose
	a8
	sec
	rtl	
.exit
	a8
	clc
	rtl

	IFEQ	1
;=====================================================================
;*			SCREEN FADE IN				*
;* data bank 7e							*
;=====================================================================
fadesteptime equ	5
kscreenfadeIN_l
	shorta
	longi
	phb
	db7e
	lda	#fadesteptime
	sta	kx_screenfadetm
	stz	fade	;kw_screenfade
.fadein
	lda	#iv_titleirq
	sta	trans_flag		;[irq flag]
	km_waittrans			;[irq wait]

	dec	kx_screenfadetm
	bne	.fadein

	lda	#fadesteptime
	sta	kx_screenfadetm

	lda	fade	;kw_screenfade
	cmp	#$0f
	beq	.screenon
	inc	fade
	bra	.fadein

	inc	fade	;kw_screenfade

.screenon
	stz	kx_screenfadetm
	plb
	rtl

;=====================================================================
;*			SCREEN FADE OUT				*
;* data bank 7e							*
;=====================================================================
kscreenfadeOUT_l
	shorta
	longi

	phb
	db7e
	lda	#fadesteptime
	sta	kx_screenfadetm

.fadeout	lda	#iv_titleirq
	sta	trans_flag		;[irq flag]
	km_waittrans			;[irq wait]

	dec	kx_screenfadetm
	bne	.fadeout

	lda	#fadesteptime
	sta	kx_screenfadetm

	dec	fade	;kw_screenfade
	bpl	.fadeout

	km_screenoff
	stz	kx_screenfadetm
	plb
	rtl

	ENDC
