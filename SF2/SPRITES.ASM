;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         SPRITES.ASM                                         ;
; AUTHOR:       YASUHIRO KAWAGUCHI                                  ;
; DESCRIPTION:  Code for generating sprites                         ;
; DATE CREATED: 17-3-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;

	INCPUB	sprites


;*********************************************************************
;*		Define Main File Name				*
;*********************************************************************
;* temp *
;init_sprites_l,do_sprites_l
;oamclear_l,oamsuballon_l

;* title *
;bps_sprcursor,bps_arwing,bps_boost,bps_pilot
;Sprites_selectbattleplayer_l,SprOKMes_BFS
;sprok_bfs_sub,sprcursor_bfs,sprturnarwing,turnarwing_sub
;Sprites_selectbattlefield_l

;* GAME *
;Sprites_mission_l,Sprites_battle_l
;SetSprScoreMeter,BattleSprites
;Enemy_inRadar,Build_inRadar,MapWaku_inRadar
;RingOut,SetPlayerAim,SetEnemyNumber
;P1P2_inRadar

;*********************************************************************
;*		Sprites Special Macros				*
;*********************************************************************
MissionPlayerStates	macro	[player,obj1]
	s_set_objtobeplayer{player}	{obj1}
	lda.w	al_worldx,{obj1}
	sta	kpx
	lda.w	al_worldy,{obj1}
	sta	kpy
	lda.w	al_worldz,{obj1}
	sta	kpz
	ENDM
;------------------------------------------------------
;*		Set Radar States	[MISSION]*
;------------------------------------------------------
MissionRadarStates	macro	[player,obj1]
	ai16
	s_set_objtobeplayer{player}	{obj1}
	lda.w	al_worldx,{obj1}
	sta	kpx
	lda.w	al_worldy,{obj1}
	sta	kpy
	lda.w	al_worldz,{obj1}
	sta	kpz

	lda	#DelWakuMin
	sta	kareaminX
	sta	kareaminZ
	lda	#DelWakuMax
	sta	kareamaxX
	sta	kareamaxZ

	lda	#p{player}mapoffx
	sta	kmapoffx
	lda	#p{player}mapoffz
	sta	kmapoffz

	lda	#missradoffxy
	sta	ksproffx
	a8
	lda	#Bfwakuptr{player}
	sta	kmapptr

	lda.w	al_roty,{obj1}
	sta	kroty

	ENDM
;------------------------------------------------------
;*		Set Ring Out States	[MISSION]*
;------------------------------------------------------
MissionRingOutStates	macro	[player,obj1]
	shorta
	longi
	lda	#{player}
	lsr	a
	sta	kplayer

	km_plheapptr	{player},{obj1}
	lda	#missringoutoffx
	sta	ksproffx
	lda	#missringoutoffy
	sta	ksproffy

	lda	#Bfwakuptr{player}
	sta	kmapptr

	phx
	ldx	#BFRingOutMin{player}
	stx	kareaminX
	stx	kareaminZ
	ldx	#BFRingOutMax{player}
	stx	kareamaxX
	stx	kareamaxZ
	plx

	ENDM
;------------------------------------------------------
;*	Set Syoujyun States		[MISSION]*
;------------------------------------------------------
MissionTargetStates	macro	[player]
;*** target postion ***
	lda	p{player}_TargetX
	sec
	sbc	#08
	sta	ktargetx		;syoujyun no X zahyo

	lda	p{player}_TargetY
	sec
	sbc	#08
	sta	ktargety		;syoujyun no Y zahyo

	km_player	{player},x
	endm
;------------------------------------------------------
;*	Enemy Number States		[MISSION]*
;------------------------------------------------------
MissionEnemyNumberStates	macro

	lda	#missenemyoffx
	sta	ksproffx
	lda	#missenemyoffy
	sta	ksproffy
	ENDM

;-----------------------------------------------------
;*		Set Radar States	[BATTLE]*
;* Xreg :player Work Pointer				*
;-----------------------------------------------------
BattleRadarStates	macro	[player,obj1]
	ai16
	s_set_objtobeplayer{player}	{obj1}	;player work pointer

	lda.w	al_worldx,{obj1}
	sta	kpx
	lda.w	al_worldy,{obj1}
	sta	kpy
	lda.w	al_worldz,{obj1}
	sta	kpz

;	lda	#DelWakuMin
;	sta	kareaminX		;area check X zahyo min
;	sta	kareaminZ		;area check X zahyo max
;	lda	#DelWakuMax
;	sta	kareamaxX		;area check X zahyo max
;	sta	kareamaxZ		;area check X zahyo max

;	lda	#p{player}mapoffx
;	sta	kmapoffx		;area waku offset postion X
;	lda	#p{player}mapoffz
;	sta	kmapoffz		;area waku offset postion Z

	a8
;	lda	#Bfwakuptr{player}
;	sta	kmapptr

	lda.w	al_roty,{obj1}
	sta	kroty

	lda	#p{player}radoffx
	sta	ksproffx
	lda	#p{player}radoffy
	sta	ksproffy

	ENDM
;-----------------------------------------------------
;*		Set Ring Out States	[BATTLE]*
;* Xreg :player Work Pointer				*
;-----------------------------------------------------
BattleRingOutStates	macro	[player,obj1]

	lda	#{player}
	lsr	a
	sta	kplayer

	km_plheapptr	{player},{obj1}	;Xreg <--- player pointer
	lda	#p{player}scroffx
	sta	ksproffx
	lda	#p{player}scroffy
	sta	ksproffy

;	phx	;player heap pointer push
;	ldx	#BFRingOutMin{player}
;	stx	kareaminX
;	stx	kareaminZ
;	ldx	#BFRingOutMax{player}
;	stx	kareamaxX
;	stx	kareamaxZ
;	plx	;player heap pointer pull

	ENDM
;-----------------------------------------------------
;*	Set Syoujyun States		[BATTLE]*
;-----------------------------------------------------
BattleTargetStates	macro	[player]

	MissionTargetStates	{player}
	endm

;=====================================================================
;*								*
;*	Debug Mode (Walker 1dot Move)				*
;=====================================================================
kbug_playerpos
	IFEQ	1
	php
	phx
	phb
	ai16
	db7e
	km_testjoypad2	UDLR
	beq	.end

	stz	kz_x1
	stz	kz_y1

	km_testjoypad2	UP
	beq	.notup
	inc	kz_y1
.notup
	km_testjoypad2	Down
	beq	.notdown
	dec	kz_y1
.notdown

	km_testjoypad2	Left
	beq	.notleft
	dec	kz_x1
.notleft
	km_testjoypad2	Right
	beq	.notright
	inc	kz_x1
.notRight
	km_plheapptr	1,x
	lda	exal_worldx,x
	clc
	adc	kz_x1
	sta	exal_worldx,x

	lda	exal_worldz,x
	clc
	adc	kz_y1
	sta	exal_worldz,x
.end
	plb
	plx
	plp
	ENDC
	rtl
;*****************************************************************************
;*									*
;*			PROGRAM START					*
;*									*
;*****************************************************************************
;*********************************************************************
;*								*
;*		Initialise Game Obj				*
;*								*
;*********************************************************************
init_sprites_l
	php
	a8i16
	phb
	db0

;=============== OAM CLEAR &Sprites Display on ===============
	oamallclear	;(for double buffer)
	oamsuballon	;sprites
	dmaoaram	0,0,sprites,(128*4)+(128/4)

;=============== Initial CGX ,COL ============================
	km_ldxspritemode
	jsr	(.JmpSpriteTable,x)

	plb
	plp
	rtl
;--------------------------------------------------------------------
.JmpSpriteTable
	dw	.nosprinit&WM	;nosprite
	dw	.title&WM	;title
	dw	.missionmap&WM	;mission map
	dw	.explain&WM	;explain
	dw	.maingame&WM	;mission
	dw	.missplayer&WM	;selectmissionplayer
	dw	.nosprinit&WM	;mission pause
	dw	.gameover&WM	;mission game over
	dw	.result&WM	;mission result screen
	dw	.record&WM	;Hiscore Display
	dw	.hiscoreinput&WM ;Hiscore Input Display
	dw	.continue&WM	;mission game contiune

	dw	.battlegame&WM	;battle
	dw	.batfield&WM	;selectbattlefield
	dw	.nosprinit&WM	;selectbattleplayer
	dw	.nosprinit&WM	;battle pause
	dw	.typeselect&WM	;type select
;------------------------------------------------------------------------
.nosprinit
	shorta
	longi
	rts
;------------------------------------------------------------------------
.title
	shorta
	longi

	ldx	vram_obj_cgx

	lda.l	medal_clear	;xalc
	beq	.Andross_face
.FOX_face
	decxvramnotrans	0,e8_ccr,(128*$20)
	bra	.common
.Andross_face
	decxvramnotrans	0,e6_ccr,(128*$20)
.common
	a16
	lda	vram_obj_cgx
	clc
	adc	#128*16
	tax
	a8
	decxvramnotrans	0,e9_ccr,(64*$20)
;* obj initial (yajima) *
	jsl	init_titleobj_l

	rts
;------------------------------------------------------------------------
.missionmap
	shorta
	longi
	decvramnotrans	0,mm_obj_cgx,e3_ccr,512*$20
	rts
;------------------------------------------------------------------------
.explain
	shorta
	longi
;* obj initial (yajima) *
	jsl	init_missobj_l
;* obj cgx (anm chr pattern) transfer (yajima) *
	ldx	vram_obj_cgx
	decxvramnotrans	0,w0_ccr,(192*$20)
	rts

;------------------------------------------------------------------------
.maingame
	shorta
	longi

	ldx	vram_obj_cgx
	decxvramnotrans	0,w0_ccr,(192*$20)

	km_decrunchcgx	w1
	km_IRQdmaMRAMtoRAM	bitmapdecbase,SwapCGXBuffer1,2*swapsprlen
	km_IRQdmaromVRAM	bitmapdecbase,swapsprvram,swapsprlen

;* obj initial (yajima) *
	jsl	init_gameobj_l
	rts
;------------------------------------------------------------------------
.missplayer
	shorta
	longi
	km_decrunchcgx	e2,0
	km_decrunchcgx	e1,$6000
	rts
;------------------------------------------------------------------------
	shorta
	longi
.gameover
	jsl	gameover_init_l

	ldx	vram_obj_cgx
	decxvramnotrans	0,e5_ccr,(192*$20)

;	km_stxval	mgv_handLanmptr,sprblockanm_AndorosHandL
;	km_stxval	mgv_handRanmptr,sprblockanm_AndorosHandR
	km_stxval	mgv_eyeanmptr,sprblockanm_AndorosEye

	ldx	#0
	stx	mgv_eyeanmtm

;	stx	mgv_handLanmtm
;	stx	mgv_handRanmtm
	rts
;------------------------------------------------------------------------
.continue
	shorta
	longi
	jsl	continue_init_l
;	km_dmacgx4VRAM	0,kawaguti_cgx,$6800,$30
	rts
;------------------------------------------------------------------------
	shorta
	longi
.result
	decvramnotrans	0,mr_obj_cgx,e0_ccr,512*$20

	IFEQ	1
	ldy	#0
	ldx	#13
.loop
	lda	#($1b+4)*8+($0a*8-1)<<8
	sta	sprites,y

	km_ldasprchr	$0e,colpal0,pri2,noflip,0
	sta	sprites,y

	iny
	iny
	iny
	iny
	dex
	bne	.loop
	ENDC
	rts
;------------------------------------------------------------------------
.hiscoreinput
.record
	shorta
	longi
	decvramnotrans	0,mr_obj_cgx,e1_ccr,256*32
	rts
;------------------------------------------------------------------------
.battlegame
	shorta
	longi

;	ldx	vram_obj_cgx
;	decxvramnotrans	0,w0_ccr,(192*$20)
;	km_dmaromVRAM	0,w5_cgx,(_obj_cgx+$a0*16),(32*32)

	rts

;------------------------------------------------------------------------
.batfield
	shorta
	longi
	rts
;------------------------------------------------------------------------
.typeselect
	shorta
	longi
	rts
;------------------------------------------------------------------------
;*****************************************************************************
;*									*
;*									*
;*			Set Game Sprites				*
;* Data Bank 7e								*
;*									*
;*****************************************************************************
do_sprites_l
	a8i16
 	phb
	db7e
;-------------------------------------------------------------
;*		Frame Timer				*
;-------------------------------------------------------------
	a16
	lda	Winctimer
	and	#15
	sta	kx_16FrameTm
	and	#7
	sta	kx_8FrameTm
	and	#3
	sta	kx_4FrameTm
	and	#1
	sta	kx_2frameTm

	lda	kx_16frameTm
	bne	.skip16frame
	inc	kx_16GframeTm
.skip16frame
	lda	kx_8frameTm
	bne	.skip8frame
	inc	kx_8GframeTm
.skip8frame
	lda	kx_4frameTm
	bne	.skip4frame
	inc	kx_4GframeTm
.skip4frame
	lda	kx_2frameTm
	bne	.skip2frame
	inc	kx_2GframeTm
.skip2frame
	a8
;-------------------------------------------------------------
;*		Sprites Display Check			*
;-------------------------------------------------------------
	test_screenmode	nosprites
	beq	.Display_sprites	;If sprites set
	plb
	rtl
;-------------------------------------------------------------
;*		Sprites Buffer Check			*
;-------------------------------------------------------------
.Display_sprites
	km_bitcheckscreenflag	sprwbuf
	bne	.doublebuf
;=====================================================================
;*			SINGLE BUFFER				*
;=====================================================================
.singlebuf

	jsl	oamclear_SG_l

	ldy	#0
	sty	sprpointer
;(tuneni buffer1 wo transfer)
	km_clrscreenflag	oamtensou
	bra	.screenselect

;=====================================================================
;*			DOUBLE BUFFER				*
;=====================================================================
.doublebuf
;scrreenflag	oamtensou
;(0... buffer2 write,buffer1 transfer)
;(1... buffer1 write,buffer2 transfer)

;'94/11/8 :oamtensou no flag no iti idou !!
;;;;	km_eorscreenflag	oamtensou

	ldy	#oambuf1
	km_bitcheckscreenflag	oamtensou
	bne	.WriteBuf1
.WriteBuf2	ldy	#oambuf2
.WriteBuf1
	sty	sprpointer	;Initial sprites pointer

;**** OAM RAM Clear ****
	oamclear_DB		;OAM double Buffer Clear
;=====================================================================
;*		Screen Select	[one screen,two screen]		*
;=====================================================================
.screenselect
	km_ldxspritemode
	jsr	(.JmpSpriteTable,x)

;* OAM Transfer Buffer Swapping *
	a16
	km_bitcheckscreenflag	sprwbuf
	beq	.end
	km_eorscreenflag	oamtensou
.end
	a8
	plb
	rtl
;---------------------------------------------------------------------
.JmpSpriteTable
	km_gamespritemode	nosprite
	km_gamespritemode	title
	km_gamespritemode	selectmissionmap
	km_gamespritemode	explain
	km_gamespritemode	mission
	km_gamespritemode	selectmissionplayer
	km_gamespritemode	missionpause
	km_gamespritemode	missiongameover
	km_gamespritemode	missionresult
	km_gamespritemode	record
	km_gamespritemode	hiscoreinput
	km_gamespritemode	missioncontiune

	km_gamespritemode	battle
	km_gamespritemode	selectbattlefield
	km_gamespritemode	selectbattleplayer
	km_gamespritemode	battlepause
	km_gamespritemode	typesel

;*********************************************************************
;*			No Sprites				*
;*********************************************************************
Sprites_nosprite_l
	shorta
	longi
	rts

	shorta
	longi
Sprites_record_l
	rts

	shorta
	longi
Sprites_hiscoreinput_l
	php
	a16
	jsr	disp_yubi
	plp
	rts

;*********************************************************************
;*			Mission Result Sprites			*
;* Data Bank 7e							*
;* Yreg :spites poionter						*
;*********************************************************************
Sprites_missionresult_l
	php
	a16

	lda	mre_mainspriteoff
	bne	.disp_yubi

	jsr	setrankmeter
	jsr	setrank

	jsr	setsprresult_sub
	jsr	setsprpilot_sub
	jsr	setsprrecord_sub


	IFEQ	1
	jsr	setsprcorneria_sub
	jsr	setsprresult_sub
	jsr	setsprbattleship_sub
	jsr	setsprplanet_sub
	jsr	setsprenemy_sub
	jsr	setsprmissile_sub
	ENDC

	plp
	rts
.disp_yubi
	jsr	disp_yubi
	jsr	disp_expert
	plp
	rts

;---------------------------------------------------------------------
;*								*
;*			Display RANK				*
;* Input   :mre_meter :(0~50) / 10 --> (*,A,B,C,D,E)			*
;*								*
;---------------------------------------------------------------------
	longa
	longi
setrank
	lda	mre_rankflag
	beq	.END
	dec	a
	beq	.Rank
.Kirari
	km_setval	kz_tpx,$10*8
	km_setval	kz_tpy,$06*8+4
	km_stxvar	kz_x2,mre_kirarianmptr
	km_stxvar	kz_y2,mre_kirarianmtm
	jsr	BlockAnimeTrans
	km_stxvar	mre_kirarianmptr,kz_x2
	km_stxvar	mre_kirarianmtm,kz_y2
.Rank
	km_setval	kz_tpx,$10*8
	km_setval	kz_tpy,$06*8+4
	ldx	mre_rank
	lda.l	ksprranktbl,x
	sta	kz_tpa	
	jsr	SetSprite_32x32
.END
	rts

ksprranktbl
	dw	spr32x32_rankE
	dw	spr32x32_rankD
	dw	spr32x32_rankC
	dw	spr32x32_rankB
	dw	spr32x32_rankA
	dw	spr32x32_rankS

;---------------------------------------------------------------------
;*			Display RANK Meter			*
;*  Input : mre_metertimer :bar meter kakikae timer			* 
;*        : mre_meter ;rank meter (0~50)				*
;---------------------------------------------------------------------
	longa
	longi
setrankmeter
	lda	mre_meterflag
	beq	.END

	km_setvar	mre_metertmp,mre_meter
	km_setval	mre_meteroffx,$04*8+4
	sta	mre_meterx
	km_setval	mre_meteroffy,($0a*8)

.LOOP
	lda	mre_metertmp
	beq	.End
	cmp	#4
	bcc	.SetLast
	beq	.SetLast
	sec
	sbc	#4
	sta	mre_metertmp
	km_setval	mre_meterptr,8
	jsr	SetMeterSprite_sub

	km_addstaval	mre_meterx,16
	BRA	.LOOP

.SetLast
	lda	mre_metertmp
	asl	a
	sta	mre_meterptr
	jsr	SetMeterSprite_sub
.End
	rts

;---------------------------------------------------------------------
;*		Set Rank Meter Bar Sub Routine			*
;---------------------------------------------------------------------
	longa
	longi
SetMeterSprite_sub
;(X zahyou)
	lda	mre_meterx
	sta	kz_tpx
;(Y zahyou)
	lda	mre_meteroffy
	sta	kz_tpy

;(Character)
	ldx	mre_meterptr
	lda.l	rankmetertbl,x
	sta	kz_tpa
	jsr	SetSprite_16x16
	rts

rankmetertbl
	SprChrDataW	$0f,colpal0,pri2,noflip,0
	SprChrDataW	$e8,colpal0,pri2,noflip,0
	SprChrDataW	$ea,colpal0,pri2,noflip,0
	SprChrDataW	$ec,colpal0,pri2,noflip,0
	SprChrDataW	$ee,colpal0,pri2,noflip,0

;=====================================================================
;*			Display Yubi				*
;=====================================================================
	longa
	longi
disp_yubi
	lda	mre_fingeron
	beq	.end	
	km_setval	kz_tpx,$0d*8
	km_lldx	key_tateptr1
	km_loblda.l	.yubiYtbl,x
	sta	kz_tpy
	lda	mre_kettei
	sta	kz_tpa
	jsl	yjresult_main_l		;(yajima)
.end
	rts

.yubiYtbl
	DB	$0f*8-1
	DB	$12*8-1


;=====================================================================
;*			Display Expert				*
;=====================================================================
	longa
	longi
disp_expert
	lda	mre_expertdisplay
	beq	.end	

	km_setval	kz_tpx,$10*8
	km_setval	kz_tpy,$10*8
	km_stxvar	kz_x2,mre_expertanmptr
	km_stxvar	kz_y2,mre_expertanmtm
	jsr	BlockAnimeTrans
	km_stxvar	mre_expertanmptr,kz_x2
	km_stxvar	mre_expertanmtm,kz_y2

.end
	rts
;=====================================================================
;*			Display Record				*
;=====================================================================
	longa
	longi
setsprrecord_sub
	lda	mre_recordflag
	beq	.end

	lda	mre_HiscoreFlag
	beq	.end

	km_setval	kz_tpx,$0b*8+4
	km_setval	kz_tpy,$19*8
	km_stxvar	kz_x2,kx_blockanmptr
	km_stxvar	kz_y2,kx_blockanmtm
	jsr	BlockAnimeTrans
	km_stxvar	kx_blockanmptr,kz_x2
	km_stxvar	kx_blockanmtm,kz_y2
.end
	rts

;=====================================================================
;*		Display Corneria				*
;=====================================================================
	longa
	longi
setsprcorneria_sub
	km_setval	kz_tpx,$17*8+4
	km_setval	kz_tpy,$08*8+4

	lda	kx_CorneriaDamage
	cmp	#corneriaAttentionDamage
	bmi	.blue
	cmp	#corneriaDangerDamage
	bmi	.Attention
.Danger
	km_bitcheckflag16	kx_8GframeTm,%1
	bne	.red
	bra	.blue
.Attention
	lda	kx_4GframeTm
	and	#7
	cmp	#4
	bpl	.red
	bra	.blue
.red
	lda	#spr32x32_CorneriaRE
	bra	.setcorneria
.blue
	lda	#spr32x32_CorneriaBL
.setcorneria
	sta	kz_tpa	
	jsr	SetSprite_16
	rts
;=====================================================================
;*								*
;*		Display Pilot					*
;*								*
;=====================================================================
	longa
	longi
setsprpilot_sub

;* sand pattern check *
	km_bitcheckflag16	kx_4GframeTm,%1
	bne	.sand2
.sand1
	lda	#spr32x32_sand1
	bra	.skip_deadp1
.sand2
	lda	#spr32x32_sand2
.skip_deadp1
	sta	kz_tpa
	sta	kwork

;**** main pilot ****
	km_bitcheckflag	kx_p1_pilotNo,$80
	beq	.not_p1dead
;(sand)
	km_setval	kz_tpx,$04*8+10
	km_setval	kz_tpy,$07*8-1
	jsr	SetSprite_32x32
.not_p1dead

;(main)
	km_setval	kz_tpx,$04*8+12-2
	km_setval	kz_tpy,$07*8-1

	lda	kx_p1_pilotNo
	and	#$7f
	tax
	km_loblda.l	MR_PilotTable,x
	sta	kz_tpa
	jsr	SetSprite_32x32

;**** partner pilot ****
	km_bitcheckflag	kx_p2_pilotNo,$80
	beq	.not_p2dead
;(sand)
	km_setval	kz_tpx,$09*8+2
	km_setval	kz_tpy,$07*8-1
	lda	kwork
	sta	kz_tpa
	jsr	SetSprite_32x32
.not_p2dead

;(main)
	km_setval	kz_tpx,$08*8+4+8-2
	km_setval	kz_tpy,$07*8-1

	lda	kx_p2_pilotNo
	and	#$7f
	tax
	km_loblda.l	MR_PilotTable,x
	sta	kz_tpa
	jsr	SetSprite_32x32
	rts
;--------------------------------------------------------------------
MR_PilotTable
	db	spr32x32_FOX
	db	spr32x32_FALCO
	db	spr32x32_PEPPY
	db	spr32x32_SLIPPY
	db	spr32x32_MYU
	db	spr32x32_FAY
;=====================================================================
;*								*
;*		Display Mission Result				*
;*								*
;=====================================================================
	longa
	longi
setsprresult_sub
	ldx	kx_result
	km_loblda.l	MR_ResultTbl,x
	sta	kz_tpa
	jsr	BlockTransSpriteFix
	rts
MR_ResultTbl
	db	sprblock_corneriafell
	db	sprblock_ShootDown
	db	sprblock_MissionClear

;=====================================================================
;*								*
;*		Set Battle Ship					*
;*								*
;=====================================================================
	longa
	longi
setsprbattleship_sub
	ldx	#0
;* clear battle ship *
	km_bitcheckflag16	kx_4GframeTm,%1
	bne	.red
.blue
	km_ldasprchr	$44,colpal2,pri2,noflip,0
	bra	.skip_colour
.red
	km_ldasprchr	$44,colpal3,pri2,noflip,0
.skip_colour
	sta	kz_tpa

	lda	kx_initbattleshipkazu
	sec
	sbc	kx_battleshipkazu
	beq	.normal_battleship
	sta	kcounter

	jsr	mr_setbsresult
;---------------------------------------------------------------------
.normal_battleship

	lda	kx_battleshipkazu
	beq	.end
	sta	kcounter
	km_setsprchr	kz_tpa,$4c,colpal2,pri2,noflip,0
	jsr	mr_setbsresult
;---------------------------------------------------------------------
.end
	rts

;---------------------------------------------------------------------
;*		Battle Ship Result Display			*
;---------------------------------------------------------------------
	longa
	longi
mr_setbsresult
.loop
	km_loblda.l	mr_bsposxtbl,x
	sta	kz_tpx
	km_loblda.l	mr_bsposytbl,x
	sta	kz_tpy
	jsr	SetSprite_32x16
	inx
	dec	kcounter
	bne	.loop
	rts

;---------------------------------------------------------------------
;*			Zahyou Table				*
;---------------------------------------------------------------------
mr_bstcx	equ	$03*8+4
mr_bstcy	equ	$14*8-1

mr_bsposxtbl
	db	mr_bstcx+$00*8
	db	mr_bstcx+$03*8-2
	db	mr_bstcx+$06*8-2
	db	mr_bstcx+$09*8-2

mr_bsposytbl
	db	mr_bstcy+$00*8
	db	mr_bstcy+$00*8
	db	mr_bstcy+$00*8
	db	mr_bstcy+$00*8
	db	mr_bstcy+$00*8
	db	mr_bstcy+$00*8

;=====================================================================
;*								*
;*		Set Planet					*
;*								*
;=====================================================================
	longa
	longi
setsprplanet_sub
	ldx	#0
;* clear battle ship *
	km_bitcheckflag16	kx_8GframeTm,%1
	bne	.rescue2
	km_ldasprchr	$40,colpal3,pri2,noflip,0
	bra	.skip
.rescue2
	km_ldasprchr	$40,colpal2,pri2,noflip,0
.skip
	sta	kz_tpa

	lda	kx_initplanetkazu
	sec
	sbc	kx_planetkazu
	beq	.senryou_planet
	sta	kcounter
	jsr	mr_setplresult
;---------------------------------------------------------------------
.senryou_planet
	lda	kx_planetkazu
	beq	.end
	sta	kcounter
	km_setsprchr	kz_tpa,$48,colpal7,pri2,noflip,0
	jsr	mr_setplresult
;---------------------------------------------------------------------
.end
	rts

;---------------------------------------------------------------------
;*		Battle Ship Result Display			*
;---------------------------------------------------------------------
	longa
	longi
mr_setplresult
.loop
	km_loblda.l	mr_plposxtbl,x
	sta	kz_tpx
	km_loblda.l	mr_plposytbl,x
	sta	kz_tpy
	jsr	SetSprite_32x16
	inx
	dec	kcounter
	bne	.loop
	rts
;---------------------------------------------------------------------
;*			Zahyou Table				*
;---------------------------------------------------------------------
mr_pltcx	equ	$03*8+4
mr_pltcy	equ	$0f*8

mr_plposxtbl
	db	mr_pltcx+$00*8
	db	mr_pltcx+$03*8+4
	db	mr_pltcx+$07*8
	db	mr_pltcx+$0a*8+4
	db	mr_pltcx+$0e*8
	db	mr_pltcx+$11*8+4

mr_plposytbl
	db	mr_pltcy+$00*8
	db	mr_pltcy+$00*8
	db	mr_pltcy+$00*8
	db	mr_pltcy+$00*8
	db	mr_pltcy+$00*8
	db	mr_pltcy+$00*8



;-------------------------------------------------------------
;*			Zaco Enemy			*
;-------------------------------------------------------------
	longa
	longi
setsprenemy_sub
	km_setval	kz_tpx,$1a*8-2
	km_setval	kz_tpy,$14*8

	km_bitcheckflag16	kx_4GframeTm,%1
	bne	.enemy2
	km_ldasprchr	$2a,colpal2,pri2,noflip,0
	bra	.skip
.enemy2
	km_ldasprchr	$2a,colpal3,pri2,noflip,0
.skip
	sta	kz_tpa
	jsr	SetSprite_16x16
	rts
;-------------------------------------------------------------
;*			Missile				*
;-------------------------------------------------------------
	longa
	longi
setsprmissile_sub
	km_setval	kz_tpx,$14*8-2
	km_setval	kz_tpy,$14*8

	km_bitcheckflag16	kx_4GframeTm,%1
	bne	.enemy2
	km_ldasprchr	$0a,colpal5,pri2,noflip,0
	bra	.skip
.enemy2
	km_ldasprchr	$0a,colpal6,pri2,noflip,0
.skip
	sta	kz_tpa
	jsr	SetSprite_16x16
	rts



;*********************************************************************
;*	Set Sprites in Game Over		[Game Over]	*
;* Data Bank 7e							*
;* Yreg :spites poionter						*
;*********************************************************************
Sprites_missiongameover_l
	shorta
	longi

	ldy	sprpointer
	jsl	gameover_obj_l

	ai16
;* eye *
	km_setval	kz_tpx,$10*8+4
	km_setval	kz_tpy,$0a*8+2
	km_stxvar	kz_x2,mgv_eyeanmptr
	km_stxvar	kz_y2,mgv_eyeanmtm
	jsr	BlockAnimeTrans
	km_stxvar	mgv_eyeanmptr,kz_x2
	km_stxvar	mgv_eyeanmtm,kz_y2

	IFEQ	1
;* hand R *
	km_setval	kz_tpx,05*8
	km_setval	kz_tpy,11*8
	km_stxvar	kz_x2,mgv_handRanmptr
	km_stxvar	kz_y2,mgv_handRanmtm
	jsr	BlockAnimeTrans
	km_stxvar	mgv_handRanmptr,kz_x2
	km_stxvar	mgv_handRanmtm,kz_y2

;* hand L *
	km_setval	kz_tpx,(32-5)*8
	km_setval	kz_tpy,11*8
	km_stxvar	kz_x2,mgv_handLanmptr
	km_stxvar	kz_y2,mgv_handLanmtm
	jsr	BlockAnimeTrans
	km_stxvar	mgv_handLanmptr,kz_x2
	km_stxvar	mgv_handLanmtm,kz_y2
	ENDC

	a8
	sty	sprpointer
	rts

;*********************************************************************
;*	Set Sprites in Continue		[Game Continue]		*
;* Data Bank 7e							*
;* Yreg :spites poionter						*
;*********************************************************************
Sprites_missioncontiune_l
	shorta
	longi

	ldy	sprpointer
	jsl	continue_obj_l
	sty	sprpointer
	rts

;*********************************************************************
;*	Set Sprites (message & Map)in Pause	[PAUSE]		*
;* Data Bank 7e							*
;* Yreg :spites poionter						*
;*********************************************************************
Sprites_missionpause_l
	SHORTA
	LONGI

	ldy	sprpointer
	jsl	main_pausemap_l

;* Pause cursor *
	km_bitcheckmistotalflag	finalbossbattle
	bne	.end
	km_bitcheckmissionflag	wolfboss
	bne	.end

;* Cursor Yajirushi *
	km_setval	kz_x1,$a*8	;X zahyou
	km_lldx	key_tateptr1
	lda.l	pausecursorYtbl,x
	sta	kz_x1+1			;Y zahyou

	a16
	km_setspriteXY	kz_x1
	km_SetSpriteChrVal	$8,colpal0,pri3,noflip

	km_addstaval	kz_x1,$800

	km_setspriteXY	kz_x1
	km_SetSpriteChrVal	$8,colpal0,pri3,yflip

;---- CorneriaDamage (%) -----
	jsr	SetSprCorneriaHP

.end
	sty	sprpointer
	rts

pausecursorYtbl
	db	$13*8
	db	$14*8+4
	db	$16*8

;*********************************************************************
;*			TITLE SPRITES				*
;* data bank :7e							*
;* mem8,idx16							*
;* Yreg :sprites pointer						*
;*********************************************************************
Sprites_title_l
	shorta
	longi
	jsl	main_titleobj_l

	IFEQ	1
;game select init screen display
	BlockTransSPrites	TitSPrData
	lda	tiw_sprmode
	bne	.levelsel
	BlockTransSPrites	GameSelSprData
	bra	.skip
;-----------------------------------------------------------------------
.levelsel
	lda	tiw_gamemode
	bne	.battle
.mission
	BlockTransSprites	MLevelSelSprData
	bra	.skip
.battle
	BlockTransSprites	BatMapSelSprData
;-----------------------------------------------------------------------
.skip

;game select mark set
	lda	#$40
	sta	sprites,y	;[X zahyo]
	iny

	lda	key_tateptr1	;keyptr
	km_multa16
	clc
	adc	#$40		;[y zahyo]
	sta	sprites,y
	iny
	km_SetSpriteChrVal	conf_cursor,colpal0,pri3,noflip	;[character]

	endc
;---------------------------------------------------------------------
	rts

;*********************************************************************
;*		MISSION MAP SELECT (ROM Access Enable)		*
;* data bank :7e							*
;* mem8,idx16							*
;* Yreg :sprites pointer						*
;*********************************************************************
	shorta
	longi
Sprites_selectmissionmap_l
	ldy	sprpointer
;=====================================================================
;*			Frame Timer Set				*
;=====================================================================
;----------------------------------------------
;* 2 frame oki 3 pattern *
;* enemy jet pointer (Zaco Enemy Jet Pointer) *
	lda	kx_2frameTm
	bne	.notbsjet

	lda	mmx_jetptr
	inc	a
	inc	a
	cmp	#3*2
	bne	.settm
	lda	#0
.settm	sta	mmx_jetptr	;0,2,4,0,2,4,....

;* 2 frame oki 4 pattern *
	lda	mmx_expzacojetptr
	inc	a
	inc	a
	and	#$7
	sta	mmx_expzacojetptr	;0,2,4,6,0,2,4,6,....
.notbsjet
;----------------------------------------------
;(4 frame oki 3 pattern)
	lda	kx_4frameTm
	bne	.not4f3ptm

	lda	mmw_4f3pptr
	inc	a
	cmp	#3
	bne	.set4f3ptm
	lda	#0
.set4f3ptm	sta	mmw_4f3pptr	;0,1,2,0,1,2,...
.not4f3ptm
;----------------------------------------------
;* clock animation pointer *	;(8 frame oki 4 pattern) 
	km_bitcheckmismapfzflag	timefreeze
	bne	.nochange_submeter
	lda	kx_8frameTm
	bne	.nochange_submeter
	lda	mmx_clocksubptr
	inc	a
	inc	a
	and	#7
	sta	mmx_clocksubptr
.nochange_submeter
;----------------------------------------------
;----------------------------------------------
;----------------------------------------------
;----------------------------------------------
;----------------------------------------------------------------------
;* spped up timer *
	km_bitcheckmismapstflag	speedup
	bne	.speedup
.normal
	ldx	#1
	bra	.settimer
.speedup
	ldx	#8
.settimer
	stx	mm_speeduptimer

;=====================================================================
;*		Pause tyuu shika danai				*
;=====================================================================
	km_bitcheckgameflag	pauseon
	beq	.notpause
	km_setval	kz_tpx,$70
	km_setval	kz_tpy,$60
	km_stxvar	kz_x2,kx_blockanmptr
	km_stxvar	kz_y2,kx_blockanmtm
	jsr	BlockAnimeTrans
	km_stxvar	kx_blockanmptr,kz_x2
	km_stxvar	kx_blockanmtm,kz_y2
.notpause

;=====================================================================
;*		Pause tyuu mo deteiru				*
;=====================================================================
;**** yajirushi (for mission map explain :yajima's) *****
	shorta
	jsr	yajirushi_animation	; demo yajirushi animetion

;--------------------------------------
;* warp suru ok or no *
	lda	mmx_warpseltrig
	beq	.notdisp_warpsel
	lda	mmw_4f3pptr
	beq	.notdisp_warpsel

	a16
	lda	#(($19*8-4)<<8)+$13*8
	ldx	mmx_warpselect
	beq	.yes
.no
	lda	#(($1a*8)<<8)+$13*8
.yes
	km_setsprite

	lda	mmw_4f3pptr
	asl	a
	tax
	lda.l	spr_warpselChrtbl,x
	km_setsprite
	a8
.notdisp_warpsel
;--------------------------------------
;* (Zaco&Missile) Enemy no kazu *
	jsr	disp_enemykazu

;============== Player States ==============
	a16
	km_bitcheckmistotalflag	explain1
	bne	.NoPlayer
	jsr	mm_DisplayFox

;***** Player HP *****
	longa
	lda	p1_hp
	and	#$3f
	sta	kz_x1	;HP

	ldx	kx_p1_TypePtr
	lda.l	map_HPtamaPosTbl,x
	sta	kz_x2	;(X,Y) offset postion
	a8
	jsl	SetSprDamageMeter_l	;(ramspr.asm)
	a16

;**** ITEM *****
	longa
	km_setval	kz_tpx,$14*8+5
	km_setval	kz_tpy,$19*8+6
	km_lldasla	p1_spweap_type
	tax
	lda.l	mm_SpecialWeaponTbl,x
	sta	kz_tpa
	jsr	SetSprite_16x16
;-------------------------------------------------------------------------
.NoPlayer
;**** clock sub meter ***
	longa
	ldx	mmx_clocksubptr
	km_SetSpriteImXY	$1e*8,$17*8
	lda.l	ClockSubData1,x
	km_SetSprite
	km_SetSpriteImXY	$1e*8,$18*8
	lda.l	ClockSubData2,x
	km_SetSprite
;-------------------------------------------------------------------------
	longa
;***** CorneriaDamage ******
	IFEQ	1
	a16
	lda	kx_CorneriaDamage
	cmp	#100
	beq	.damage100

	km_setval	kz_x1,5*8+($18*8-1)<<8
	km_setvar	kz_x2,kx_CorneriaDamage
	km_setval	kz_y1,2

	lda	kw_mmBGMPtr
	clc
	adc	#4
	asl	a
	tax	

	lda.l	objcolpaltable,x
	clc
	adc	#$a0!obj_pri3
	sta	kz_x3
	jsr	SetSprNumber_16x16
	bra	.skip_damage
.damage100
	km_setval	kz_tpx,$02*8
	km_setval	kz_tpy,$17*8-1
	km_setsprchar	kz_tpa,$80,colpal6,pri3,noflip,mm_obj_offset
	jsr	SetSprite_32x16
.skip_damage
	ENDC

;=====================================================================
;*		Pause tyuu wa denai				*
;=====================================================================
;* pause check *
	a8
	IFEQ	1
	lda	mmx_pausescroll
	beq	.disp_obj
	cmp	#scrl_openscrollwait
	beq	.disp_obj
	cmp	#scrl_closefinish
	beq	.disp_obj
	brl	.end
.disp_obj
	ENDC
;***** Corneria HP Meter *****
;* HP Meter (yajima's)
	shorta
;;;;;	jsr	mapobjset_yajima

;******************************* cursor *********************************
	a16
	km_bitcheckmismapflag	battleplayer
	km_bne	.nodisp_encountmode
	km_bitcheckflag16	mmx_cursorflag,curf_warpselect
	km_bne	.hit
	km_bitcheckflag16	mmx_cursorflag,curf_demo
	km_bne	.demo
	km_bitcheckmismapfzflag	cursorfreeze
	km_bne	.notdisplay_cursor
	km_bitcheckflag16	mmx_cursorflag2,curf2_hitplanet
	bne	.hit
;------------------------------------------------------------------------
.nohit
;* small cursor *
	a8
	lda	mmx_curposX
	sta	oam_centerX	; <- position X
	lda	mmx_curposY
	dec	a
	sta	oam_centerY	; <- position Y
	lda	#cd_objanime_smallcursor
	sta	oam_animeNo	; animation No
	lda	mmx_curanmtm
	sta	oam_tcount	; animation Timer
	a16
	jsr	set_kawaobj
	a8
	brl	.skipcursor
;------------------------------------------------------------------------
.hit
;* big cursor *
	a8
	lda	mmx_bigcurposX
	sta	oam_centerX	; <- position X
	lda	mmx_bigcurposY
	dec	a
	sta	oam_centerY	; <- position Y
	lda	#cd_objanime_bigcursor
	sta	oam_animeNo	; animation No
	lda	mmx_curanmtm
	sta	oam_tcount	; animation Timer
	a16
	jsr	set_kawaobj

;**** planet name *****
	longa
	lda	mmx_planetname
	km_multa16
	clc
	adc	#$16a
	sta	kz_x1		;get char pointer

	a8
	lda	mmx_bigcurposY
	cmp	#$80
	bcs	.name_up
.name_down
	clc
	adc	#16
	bra	.skip_ypos
.name_up
	sec
	sbc	#25
.skip_ypos
	sta	kz_tpa+1

.xpostion
	lda	mmx_bigcurposX
	clc
	adc	#-28
	sta	kz_tpa

	a16
	ldx	#5
.loop
	lda	#8
	clc
	adc	kz_tpa
	sta	kz_tpa
	km_SetSprite	kz_tpa
	km_SetSpriteChrVar	kz_x1,0,colpal0,pri2,noflip,mm_obj_offset
	inc	kz_x1
	dex
	bne	.loop
.NotDisplayName
	a8
	bra	.skipcursor
;------------------------------------------------------------------------
.demo
	longa
	ldx	#0
	km_setval	kcounter,4
.loop_demo
	lda	mmx_curdemox+1,x
	cmp	#clip_cursorsx
	bmi	.skip_demo
	cmp	#clip_cursorex
	bpl	.skip_demo
	sta	kz_tpx

	lda	mmx_curdemoy+1,x
	cmp	#clip_cursorsy
	bmi	.skip_demo
	cmp	#clip_cursorey
	bpl	.skip_demo
	sta	kz_tpy

	lda	mmx_curdemochar,x
	sta	kz_tpa
	jsr	SetSprite_16x16
.skip_demo
	txa
	clc
	adc	#curdemoworklen
	tax
	dec	kcounter
	bne	.loop_demo
	a8
;============================================================================
.skipcursor
	shorta
	lda	mmx_curanmtm
	inc	a
	and	#$f
	sta	mmx_curanmtm

.notdisplay_cursor
;============================================================================
;* destination *
	km_bitcheckflag16	mmx_cursorflag,curf_destdisp
	km_beq	.NotdestDisplay

	dec	mmx_destmarktm
	bne	.nochangepattern

	lda	mmx_destmarkptr
	eor	#1
	sta	mmx_destmarkptr
	km_setval	mmx_destmarktm,4
.nochangepattern
	km_SetSpriteSize1
	a16
	km_SetSpriteC4XY	mmx_arwingdestposX,mmx_arwingdestposY
	lda	mmx_destmarkptr
	km_SetSpriteCol		$4c,pri2,noflip,mm_obj_offset
	a8
.NotdestDisplay
;----------------------------------------------------------------------------
.nodisp_encountmode
;********** Arwing Display *********
.ArwingDisplay
	a16
	km_bitcheckflag16.w	mmx_arwingflag,mmf_notdisplay
	a8
	bne	.ArwingNotDisplay
	lda	mmx_arwinganmptr
	sec
	sbc	#5
	cmp	#7
	bcs	.pri_jet
.pri_arwing
	jsr	mm_disparwing
	jsr	mm_dispjet
	bra	.skip_arwing
.pri_jet
	jsr	mm_dispjet
	jsr	mm_disparwing
.skip_arwing

;********** Partner Display *********
.PartnerDisplay
	km_bitcheckmistotalflag	partner1
	bne	.skip_partner
	km_bitcheckflag16.w	mmx_partnerflag,mmf_notdisplay
	bne	.skip_partner

	lda	mmx_partneranmptr
	sec
	sbc	#5
	cmp	#7
	bcs	.pri_partnerjet
.pri_partner
	jsr	mm_disppartner
	jsr	mm_disppartnerjet
	bra	.skip_partner
.pri_partnerjet
	jsr	mm_disppartnerjet
	jsr	mm_disppartner
.skip_partner
.ArwingNotDisplay
;-------------------------------------------------------------------------
;******* Display Object *********
	jsr	DispEnemy
;---------------------------------------------------------------------
	a16
	km_bitcheckmismapflag	battleplayer
	bne	.skip_aaa

;* Planet dokuro *
	jsr	disp_senryouplanet

;;;;	jsr	enemymissilebase
;* Battle Ship no Zaico *
	jsr	DispBSZaico
.skip_aaa
;---------------------------------------------------------------------
.end
	a16
	tya
	lsr	a
	lsr	a
	sta	sprkazu

	a8
	sty	sprpointer
	rts


;*********************************************************************
;*								*
;*			Fox Team no kao				*
;*								*
;*********************************************************************
	longa
	longi
mm_DisplayFox

	km_setval	kz_tpx,$a*8-6+8
	km_setval	kz_tpy,$19*8+6
.p1_alive
	km_loblda	p1_hp
	cmp	#12+1
	bcs	.genki
	
	lda	mmw_pldangertm
	inc	a
	sta	mmw_pldangertm
	cmp	#16
	bcc	.genki
	beq	.danger
	stz	mmw_pldangertm
.danger
	km_ldasprchr	$64,colpal3,pri2,noflip,mm_obj_offset
	sta	kz_tpa
	jsr	SetSprite_16x16
.genki
	lda	p1_pilotNo
	and	#$7f
	asl	a
	km_adcsprchr	$20,colpal0,pri2,noflip,mm_obj_offset
	sta	kz_tpa
.set_player1
	jsr	SetSprite_16x16

;* partner *
	km_setval	kz_tpx,$0c*8+5
	km_setval	kz_tpy,$19*8+6

	km_bitcheckmistotalflag	partner1	;p1dead
	beq	.partner
.p1_dead
	lda	kx_8frameTm
	lsr	a
	asl	a
	tax
	lda.l	.deadtbl,x
	km_adcsprchr	$80,colpal0,pri2,noflip,mm_obj_offset
	bra	.set_partner
.partner
	lda	p2_pilotNo
	and	#$7f
	asl	a
	km_adcsprchr	$20,colpal0,pri2,noflip,mm_obj_offset
.set_partner
	sta	kz_tpa
	jsr	SetSprite_16x16


	rts

.deadtbl
	dw	obj_noflip
	dw	obj_xyflip
	dw	obj_yflip
	dw	obj_xflip
;---------------------------------------------------------------------
	IFEQ	1
;****** mother ship ******
	shorta
	km_bitcheckmismapflag	battleplayer
	km_bne	.nodisp_mothership

	km_setvar	kz_tpx,kx_mshipx
	km_setvar	kz_tpy,kx_mshipy
	a16
	km_setsprchar	kz_tpa,$12c,colpal0,pri2,noflip,mm_obj_offset
	a8
	jsr	SetSprite_16x16
.nodisp_mothership
	ENDC
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;*		Data
;---------------------------------------------------------------------
ClockSubData1
	SprChrDataW	$16f,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$17f,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$19f,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$18f,colpal0,pri3,yflip,mm_obj_offset

ClockSubData2
	SprChrDataW	$16f,colpal0,pri3,yflip,mm_obj_offset
	SprChrDataW	$18f,colpal0,pri3,noflip,mm_obj_offset
	SprChrDataW	$19f,colpal0,pri3,yflip,mm_obj_offset
	SprChrDataW	$17f,colpal0,pri3,yflip,mm_obj_offset
;=====================================================================
;*			Senryou Sareteiru Planet		*
;=====================================================================
disp_senryouplanet
	php
	ai16
	km_bitcheckscreenflag	objcolpal
	beq	.end

	ldx	kx_planetlistptr
.loop
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_planet,x
	beq	.next
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_dakkan,x
	bne	.demo
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_complete,x
	bne	.next
	km_bitcheckflag16.w	mmx_planetflag,mmpnf_senryou,x
	beq	.next
	lda.w	mmx_planetcx,x
	sta	kz_tpx
	lda.w	mmx_planetcy,x
	sta	kz_tpy

	jsr	Disp_MissileCountDown

	phx
	lda.w	mmx_stage,x
	asl	a
	tax
	lda.l	senryoutypetbl,x
	sta	kz_tpa
	jsr	SetSprite_32x32

	plx
	bra	.next
.demo
	km_loblda.w	mmx_planetcx,x
	sta	oam_centerX	; <- position X
	km_loblda.w	mmx_planetcy,x
	sta	oam_centerY	; <- position Y
	lda.w	mmx_dokuroanm,x
	sta	oam_animeNo	; animation No
	lda.w	mmx_timer2,x
	sta	oam_tcount	; animation Timer
	inc.w	mmx_timer2,x

	jsr	set_kawaobj

.next
	lda.w	mmx_planetnext,x
	tax
	bne	.loop
.end
	plp
	rts

senryoutypetbl
	dw	spr32x32_SenryouPlanet_S&WM
	dw	spr32x32_SenryouPlanet_L&WM
	dw	spr32x32_SenryouPlanet_S&WM
	dw	spr32x32_SenryouPlanet_M&WM
	dw	spr32x32_SenryouPlanet_S&WM
	dw	spr32x32_SenryouPlanet_L&WM

;---------------------------------------------------------------------
;*			Missile CountDown			*	
;---------------------------------------------------------------------
	longa
	longi
Disp_MissileCountDown
;'95/7/3
;	km_bitcheckmismapevflag	misbornfreeze
;	bne	.NotTimeWait

	lda.w	mmx_psos,x
	cmp	#enbase_wait
	bne	.NotTimeWait
	lda.w	mmx_soswaittm,x
	cmp	#6*60
	bcs	.NotTimeWait
	cmp	#10
	bcc	.NotDispTime

;* Time Display*
	sta	kz_x1
	km_setval	kz_y1,60
	jsl	kdivu16u8_l
	km_adcsprchr	$0e0,colpal0,pri2,noflip,mm_obj_offset
	sta	kz_tpa

	lda	kz_tpy
	PHA	;>>> Push
	clc
	adc	#8
	sta	kz_tpy
	jsr	SetSprite_8x8
	PLA	<<< Pull
	sta	kz_tpy
.NotDispTime

;* Missile *
	km_ldasprchr	sproff_missile,colpal0,pri2,noflip,mm_obj_offset
	sta	kz_tpa
	jsr	SetSprite_8x8
.NotTimeWait
	rts
;=====================================================================
;*		Enemy no kazu					*
;* Temp :kz_x1,kz_y1,kz_z1,kz_tpa,kz_tpx,kz_tpy			*
;=====================================================================
typeAX	equ	$0b*8+4
typeAY	equ	$19*8+2+1
typeBX	equ	$11*8+4
typeBY	equ	$19*8+2+1
;------------------------------------------------------------------------
disp_enemykazu
	php
	a16
	lda	mapicon_flag
	beq	.end

	km_bitcheckmismapfzflag	cursorfreeze
	bne	.end

	km_bitcheckflag16	mmx_cursorflag,curf_demo
	beq	.SetEnemyInfo
.end
	plp
	rts

	longa
	longi
.SetEnemyInfo
	ldx	kx_enarrivetmptr
	lda.w	mmx_enstackptr,x	;(0,1,2,3,...,14,15)
	tax
	a8
	lda.w	EEnemyNumber_0,x
	pha
	and	#$f
	sta	EEnemyKazuA	;Low Bit
	pla
	km_shiftRUA4
	sta	EEnemyKazuB	;Hi Bit
	lda.w	EEnemyShapeA_0,x
	sta	EEnemyTypeA
	lda.w	EEnemyShapeB_0,x
	sta	EEnemyTypeB

	lda	EEnemyKazuA
	bne	.Live_Enemy
	lda	EEnemyKazuB
	sta	EEnemyKazuA
	lda	EEnemyTypeB
	sta	EEnemyTypeA

	stz	EEnemyKazuB
.Live_Enemy
;------------------------------------------------------------------------
;* enemy total number *
	SHORTA
	ldx	kx_enarrivetmptr
	lda.w	mmx_enposy+1,x
	sta	kz_tpy
	lda.w	mmx_enposx+1,x
	cmp	#$80
	bcc	.leftside
.rightside
	sec
	sbc	#16
	sta	kz_tpx
	a16
	lda.w	mmx_enkazu,x
	km_adcsprchr	sproff_number,colpal3,pri2,noflip,0
	sta	kz_tpa
	jsr	SetSprite_8x8

;* target yajirushi *
	lda	kz_tpx
	clc
	adc	#4
	sta	kz_tpx

	km_setsprchr	kz_tpa,$82,colpal0,pri2,xflip,0
	jsr	SetSprite_16x16
	bra	.skip_target

	shorta
.leftside
	clc
	adc	#16
	sta	kz_tpx
	a16
	lda.w	mmx_enkazu,x
	km_adcsprchr	sproff_number,colpal3,pri2,noflip,0
	sta	kz_tpa
	jsr	SetSprite_8x8

;* target yajirushi *
	lda	kz_tpx
	sec
	sbc	#4
	sta	kz_tpx

	km_setsprchr	kz_tpa,$82,colpal0,pri2,noflip,0
	jsr	SetSprite_16x16
.skip_target
;------------------------------------------------------------------------
	LONGA
	lda	EEnemyKazuA	;Low Bit
	km_beq	.Not_typeA
;* enemy A*
	lda	EEnemyTypeA
	asl	a
	tax
	lda.l	mm_enemytbl,x
	and	#$7fff
	km_adcsprchr	0,colpal0,pri3,noflip,mm_obj_offset
	sta	kz_tpa
	km_setval	kz_tpx,typeAX
	km_setval	kz_tpy,typeAY
	jsr	SetSprite_16x16
;* jet A*
	lda.l	mm_enemytbl,x
	and	#$8000
	beq	.nojetA
	ldx	mmx_expzacojetptr
	beq	.nojetA
	lda.l	mm_enemyjettbl,x
	sta	kz_tpa
	km_setval	kz_tpx,typeAX+4
	km_setval	kz_tpy,typeAY-4
	jsr	SetSprite_16x16
.nojetA
* waku A*
	km_setval	kz_tpx,typeAX
	km_setval	kz_tpy,typeAY

	ldx	kx_enarrivetmptr

	lda.w	mmx_entype,x
	asl	a
	sta	kpointer

	lda	kx_8GframeTm
	and	#1
	adc	kpointer
	asl	a
	tax
	lda.l	mm_enemytypetbl,x
	sta	kz_tpa
	sta	ksource
	jsr	SetSprite_32x32

;* name A *
	km_setval	kz_tpx,typeAX-16
	km_setval	kz_tpy,typeAY-24

	ldx	kpointer
	lda.l	mm_enemynametbl,x
	sta	kz_tpa
	sta	koffset
	ldx	#4
	jsr	SetSprite_Name

;* kazu A*
	km_SetSpriteImXY	typeAX+2*8,typeAY+4
	lda	EEnemyKazuA	;Low Bit
	km_adcsprchr	sproff_bignumber,colpal0,pri3,noflip,mm_obj_offset
	km_setsprite

.Not_typeA
;------------------------------------------------------------------------
	LONGA
	lda	EEnemyKazuB	;Low Bit
	beq	.Not_typeB
;* enemy B *
	lda	EEnemyTypeB
	asl	a
	tax
	lda.l	mm_enemytbl,x
	and	#$7fff
	km_adcsprchr	0,colpal0,pri3,noflip,mm_obj_offset
	sta	kz_tpa
	km_setval	kz_tpx,typeBX
	km_setval	kz_tpy,typeBY
	jsr	SetSprite_16x16
;* jet B *
	lda.l	mm_enemytbl,x
	and	#$8000
	beq	.nojetB
	ldx	mmx_expzacojetptr
	beq	.nojetB
	lda.l	mm_enemyjettbl,x
	sta	kz_tpa
	km_setval	kz_tpx,typeBX+4
	km_setval	kz_tpy,typeBY-4
	jsr	SetSprite_16x16
.nojetB
* waku *
	km_setval	kz_tpx,typeBX
	km_setval	kz_tpy,typeBY
	km_setvar	kz_tpa,ksource
	jsr	SetSprite_32x32

;* name B *
	km_setval	kz_tpx,typeBX-16
	km_setval	kz_tpy,typeBY-24
	km_setvar	kz_tpa,koffset
	ldx	#4
	jsr	SetSprite_Name

;* kazu *
	km_SetSpriteImXY	typeBX+2*8,typeBY+4
	lda	EEnemyKazuB	;Low Bit
	km_adcsprchr	sproff_bignumber,colpal0,pri3,noflip,mm_obj_offset
	km_setsprite
.Not_typeB
;------------------------------------------------------------------------
	plp
	rts
;---------------------------------------------------------------------
;*		Set Sprite Name					*		
;* Input	:Xreg :moji suu						*
;*	:kz_tpx :Top X zahyou					*
;*	:kz_tpy :Top Y zahyou					*
;*	:kz_tpa :Top Name					*
;---------------------------------------------------------------------
SetSprite_Name
.loop
	a8
	lda	kz_tpx
	km_setsprite
	clc
	adc	#8
	sta	kz_tpx
	lda	kz_tpy
	km_setsprite
	a16
	lda	kz_tpa
	km_setsprite
	inc	kz_tpa
	dex
	bne	.loop
	rts

;=====================================================================
;*								*
;*		Battle Ship no Zaico Display			*
;* Yreg :Sprite Pointer						*
;=====================================================================
DispBSZaico
	a16
	longi
	ldx	kx_battleshipzaico
	beq	.end
	stx	kz_x1

	ldx	#0
.loop
	km_setspritesize1

	lda.l	BS_ZaicoData,x
	km_SetSprite
	km_SetSpriteChrVal	$40,colpal3,pri2,noflip,mm_obj_offset
	inx
	inx
	dec	kz_x1
	bne	.loop
.end
	a8
	rts

BS_ZaicoData
	db	(enemybaseX-10-8)&BM,(enemybaseY+16-1-8)&BM ;0
	db	(enemybaseX-16-8)&BM,(enemybaseY+10-1-8)&BM ;1
	db	(enemybaseX+00-8)&BM,(enemybaseY+18-1-8)&BM ;2
	db	(enemybaseX-18-8)&BM,(enemybaseY+00-1-8)&BM ;3

;=====================================================================
;*								*
;*			Display Battle Ship			*
;=====================================================================
	IFEQ	1
DispBattleShip
	a16
	longi
	ldx	kx_enlistptr
	km_beq	.end
.loop
	km_bitcheckflag16.w	mmx_enflags,(enfl_battleship),x
	km_beq	.next
	km_bitcheckflag16.w	mmx_enflags,(enfl_invisible!enfl_child),x
	km_bne	.next
	km_bitcheckflag.w	mmx_enflags,enfl_demo,x
	bne	.anime_demo
;------------------------------------------------------
;* battle ship main *
.setbattleship
	a8
	lda.w	mmx_enposx+1,x
	sta	oam_centerX	; <- position X
	lda.w	mmx_enposy+1,x
	sta	oam_centerY	; <- position X
	lda	#cd_objanime_battleship
	sta	oam_animeNo	; animation No
	lda	mmx_enbaseanmptr	;battle base de timer wo set shiteiru !!
	sta	oam_tcount	; animation Timer
	a16
	jsr	set_kawaobj

;**** Battle Ship Jet ****
	longa
	km_bitcheckflag.w	mmx_enflags2,enfl2_nojet,x
	km_bne	.next
;(sub)
	km_setspritesizesb2
;(char)
	lda	mmx_jetptr
	clc
	adc	#$6a!obj_colpal7!obj_pri2!mm_obj_offset
	sta.w	sprites+2,y
	sta.w	sprites+6,y
;(pos)
	a8
	lda	oam_centerY
	sec
	sbc	#13+1
	xba
	lda	oam_centerX
	dec	a
	a16
	sta.w	sprites+0,y	; <- Jet Pos (x1,y1)
	a8
	xba
	dec	a
	xba
	sec
	sbc	#07
	a16
	sta.w	sprites+4,y	; <- Jet Pos (x2,y2)

	tya
	clc
	adc	#8
	tay
	bra	.next
;----------------------------------------------------------------
;* demo animation (yajima's) *
.anime_demo
	longa
	lda.w	mmx_enanmpatt,x
	beq	.next
	cmp	#-1
	beq	.appeardemo
	km_bitcheckmismapfzflag	timefreeze
	bne	.next

	lda	#1
;;;;	jsl	kspeedupA_l
	clc
	adc.w	mmx_enanmtm,x
	sta.w	mmx_enanmtm,x
	jsr	mapanime_set
	bra	.next
;----------------------------------------------------------------
.appeardemo
	longa
	PHX	;>>>> PUSH Xreg 
.loop1
	km_loblda.w	mmx_enposx+1,x
	sta	kz_tpx
	km_loblda.w	mmx_enposy+1,x
	sta	kz_tpy

	lda	#$68!obj_colpal4
	sta	kz_tpa
	km_bitcheckflag16.w	mmx_enflags,enfl_child,x
	beq	.skip1	
	lda	#$68!obj_colpal5!obj_pri2
	sta	kz_tpa
.skip1
	jsr	SetSprite_16x16

	lda.w	mmx_enchildlinkptr,x
	tax
	bne	.loop1
	PLX	;<<<<< Pull Xreg
;========================================================
.next
	longa
	lda.w	mmx_ennext,x
	beq	.end
	tax
	brl	.loop

.end
	a8
	rts
	ENDC

;---------------------------------------------------------------------
;*			Display Teki Missile Kichi		*
;---------------------------------------------------------------------
	IFEQ	1
enemymissilebase
	longa
	longi
	ldx	kx_planetlistptr
.loop
	km_bitcheckflag16.w	mmx_planetflag,(mmpnf_corneria!mmpnf_mothership!mmpnf_battleship!mmpnf_complete),x
	bne	.next

.display
	km_setspritesize1
	a8
	lda.w	mmx_planetcx,x
	km_SetSpriteC4X
	lda.w	mmx_planetcy,x
	sec
	sbc	#8
	km_SetSpriteC4Y
	a16
	km_SetSpriteChrVal	$80,colpal0,pri2,noflip,mm_obj_offset

.next
	longa
	lda.w	mmx_planetnext,x
	beq	.end
	tax
	bra	.loop

.end
	a8
	rts
	ENDC

;=====================================================================
;*								*
;*		Display Sprite Arwing				*
;*								*
;=====================================================================
mm_disparwing
;* arwing *
;* (kz_x1,kz_x2) <<<<< (X,Y) Postion 
	a8
	lda	mmx_arwingposx+1
	sta	kz_tpx
	lda	mmx_arwingposy+1
	sta	kz_tpy

;* X flip check *
;mmx_arwinganmptr = kuru kru pattern (16) pointer :0 ~ 15
	ldx	#0
	stx	kz_tpa		;character base

	lda	mmx_arwinganmptr
	bit	#8		;pattern 8 ~ 15 check
	bne	.noflip1
	inx
.noflip1
	lda	p1_pilotNo
	and	#1
	asl	a		;0/1 ... Blue / Red Arwing 
;Xreg =0/1 ... noflip / flip
	dex
	bne	.noflip2
	clc
	adc	#obj_xflip_h
.noflip2
	clc
	adc	#obj_pri2_h
	sta	kz_tpa+1
	jsr	SetSprite_4

	rts

;=====================================================================
;*		Display Sprite Arwing Jet			*
;=====================================================================
	shorta
	longi
mm_dispjet
	km_bitcheckflag16	 mmx_arwingflag,mmf_go
	beq	.NoJet
;----------------------------------
	IFEQ	1
;* Jet Animation Pointer *
	lda	kx_2frameTm
	bne	.NoChangeJet
	lda	mmx_jetanmptr
	inc	a
	cmp	#3
	bne	.skip
	lda	#0
.skip
	sta	mmx_jetanmptr
.NoChangeJet
;----------------------------------
	shorta
	km_setvar	kz_x1,mmx_jetanmptr
	beq	.NoJet
	km_bitcheckflag16	 mmx_cursorflag,curf_gospup
	beq	.skip1
	inc	kz_x1
.skip1

	a16
	km_lldasla	kz_x1		;(2,4,6)
	tax
	ENDC

	ldx	mmx_jetptr
	beq	.NoJet

	a16
	lda.l	arjettbl_char,x
	sta	kz_tpa
	a8

	ldx	mmx_arwinganmptr
	lda.l	arjettbl_x,x
	clc
	adc	mmx_arwingposx+1
	sta	kz_tpx

	lda.l	arjettbl_y,x
	clc
	adc	mmx_arwingposy+1
	sta	kz_tpy

	jsr	SetSprite_4

.NoJet
	rts


;=====================================================================
;*								*
;*		Display Sprite Partner Arwing			*
;*								*
;=====================================================================
mm_disppartner
;* arwing *
;* (kz_x1,kz_x2) <<<<< (X,Y) Postion 
	a8
	lda	mmx_partnerposx+1
	sta	kz_tpx
	lda	mmx_partnerposy+1
	sta	kz_tpy

;* X flip check *
;mmx_arwinganmptr = kuru kru pattern (16) pointer :0 ~ 15
	ldx	#2
	stx	kz_tpa	;character base

	lda	mmx_partneranmptr
	bit	#8		;pattern 8 ~ 15 check
	bne	.noflip1
	dex
.noflip1
	lda	p2_pilotNo
	and	#1
	asl	a		;0/1 ... Blue / Red Arwing 
;Xreg =0/1 ... noflip / flip
	dex
	bne	.noflip2
	clc
	adc	#obj_xflip_h
.noflip2
	clc
	adc	#obj_pri2_h
	sta	kz_tpa+1
	jsr	SetSprite_4

	rts

;=====================================================================
;*		Display Sprite Arwing Jet			*
;=====================================================================
mm_disppartnerjet
	shorta
	longi
	km_bitcheckflag16	 mmx_partnerflag,mmf_go
	beq	.end
	ldx	mmx_jetptr
	beq	.end

	a16
	lda.l	arjettbl_char,x
	sta	kz_tpa
	a8

	ldx	mmx_partneranmptr
	lda.l	arjettbl_x,x
	clc
	adc	mmx_partnerposx+1
	sta	kz_tpx

	lda.l	arjettbl_y,x
	clc
	adc	mmx_partnerposy+1
	sta	kz_tpy

	jsr	SetSprite_4
.end
	rts

;*********************************************************************
;*		Enemy Sprite Set				*
;* Xreg :Enemy List Pointer						*
;* Yreg :Sprite Pointer						*
;*********************************************************************
DispEnemy
	a16
	longi

	stz	map_corneriacrash_offset	;(for yajima)
	inc	map_corneriacrash_anime		;(for yajima)

	ldx	kx_enlistptr	;no enemy
	km_beq	.noenemy

.loop
	longa
;* Encount Player Check *
;moshi battle mode ni haitta toki kienai OBJ no Check *
	km_bitcheckmismapflag	battleplayer
	beq	.not_encountplayer

	km_bitcheckflag16.w	mmx_enflags,(enfl_satellite!enfl_itemplanet),x
	bne	.not_encountplayer

	km_bitcheckflag16.w	mmx_enflags,enfl_encountplayer,x
	km_beq	.nextenemy

.not_encountplayer

	km_bitcheckflag16.w	mmx_enflags,(enfl_invisible),x	;!enfl_child
	km_bne	.nextenemy

;* zahyou *
	a8
	lda.w	mmx_enposx+1,x
	sta	kz_tpx
	lda.w	mmx_enposy+1,x
	sta	kz_tpy
	a16

;* Display Type Check *
	km_bitcheckflag.w	mmx_enflags,enfl_demo,x
	bne	.anime_demo
	km_bitcheckflag.w	mmx_enflags2,enfl2_fix,x
	bne	.anime_fix

;=====================================================================
;*			Normal Enemy Display			*
;=====================================================================
	jsr	kurukuru_enemy
	brl	.nextenemy

;=====================================================================
;*		Demo Animation					*
;=====================================================================
;* demo animation (yajima's) *
.anime_demo
	longa

	lda.w	mmx_enanmpatt,x
	beq	.skip_anime	;No Spite
	cmp	#-1
	km_beq	.appeardemo	;

.display_enable
;	lda	#1
;	jsl	kspeedupA_l
;	clc

	lda.w	mmx_enanmtm,x
	inc	a
	cmp.w	mmx_enanmmax,x
	bcc	.not_maxtm
	sta	kz_x1

	km_bitcheckflag16.w	mmx_enflags2,enfl2_anmloop,x
	beq	.skip_anime
	lda	kz_x1
	sec
	sbc.w	mmx_enanmmax,x
.not_maxtm
	sta.w	mmx_enanmtm,x
	jsr	mapanime_set

	km_bitcheckflag16.w	mmx_enflags,enfl_battleship,x
	beq	.skip_anime
	jsr	Disp_BSjet
.skip_anime
	bra	.nextenemy
;=====================================================================
;*			Fix Sprite				*
;=====================================================================
.anime_fix
	a16
	lda.w	mmx_enanmpatt,x
	beq	.nextenemy
	sta	kz_tpa
	jsr	SetSprite_4
	bra	.nextenemy

;-------------------------------------------------------------
;*	Battle Ship or Taiman Appear Demo 1 (Dot Move)	*
;-------------------------------------------------------------
	longa
	longi
.appeardemo
	PHX	;>>>> PUSH Xreg 
	lda	mmx_expzacojetptr
	sta	kpointer
.loop1
	a8
	lda.w	mmx_enposx+1,x
	sec
	sbc	#4
	km_setsprite
	lda.w	mmx_enposy+1,x
	sec
	sbc	#5
	km_setsprite

	a16
	phx
	ldx	kpointer
	lda.l	.spritedata,x
	km_setsprite
	plx
	

	IFEQ	1
	lda	kpointer
	dec	a
	dec	a
	and	#7
	sta	kpointer

	lda.w	mmx_enchildlinkptr,x
	tax
	bne	.loop1
	ENDC

	PLX	;<<<<< Pull Xreg
	bra	.nextenemy

;---------------------------------------------------------------------
;* next enmy set *
	longa
	longi
.nextenemy
	lda.w	mmx_ennext,x
	beq	.loopend
	tax
	brl	.loop
.loopend
.noenemy
	a8
	rts

.spritedata
	SprChrDataW	sproff_warpdot+0,colpal4,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_warpdot+1,colpal4,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_warpdot+2,colpal4,pri2,noflip,mm_obj_offset
	SprChrDataW	sproff_warpdot+1,colpal4,pri2,noflip,mm_obj_offset

;=====================================================================
;*			Enemy Kurukru Rotation			*
;* Init:								*
;*     : Xreg   :Enemy List Pointer					*
;*     : kz_tpx :center X zahyo					*
;*     : kz_tpy :center Y zahyo					*
;*     : kz_x1  :rotation angle (0~7)				*
;*     : kz_x2  :base charcter					*
;*     : kz_z2  :temp work :0/1 ... Jet display OFF/ON		*
;* Temp:								*
;*     : kz_x3  :temp work						*
;*     : kz_y3  :temp work						*
;=====================================================================
	longa
	longi
kurukuru_enemy
	PHX
	PHP

	phx
	lda.w	mmx_entype,x
	asl	a
	tax
	jmp	(.spritetbl,x)
.spritetbl
	dw	.sosenemy&WM	;zaco1
	dw	.sosenemy&WM	;zaco2
	dw	.sosenemy&WM	;zaco3
	dw	.sosenemy&WM	;missile
	dw	.special&WM	;taiman
	dw	.virus&WM	;virus
	dw	.wolf&WM	;wolf
	dw	.battleship&WM	;battleship
	dw	.mothership&WM	;mothership
	dw	.satellite&WM	;satellite
	dw	.sosenemy&WM	;finalboss   :dummy
	dw	.sosenemy&WM	;item planet :dummy
;-----------------------------------------------------------
	longa
	longi
.mothership
	plx
	a16
	km_setsprchr	kz_tpa,$12c,colpal0,pri2,noflip,mm_obj_offset
	jsr	SetSprite_16x16
	brl	.end
;-----------------------------------------------------------
	longa
	longi
.battleship
	plx
	jsr	Disp_PCBattleship
	jsr	Disp_Pcannon
	brl	.end
;-----------------------------------------------------------
	longa
	longi
.satellite
	plx

;* Pointer *
	lda.w	mmx_enwaittm,x
	sta	kz_x3

	lda	kx_houdaiangle
	lsr	a
	tax

;*** tame dama ***
	km_bitcheckflag16	kx_satelliteflag,safl_tamedama
	beq	.tamenashi
	a8
	lda	mmx_jetptr
	beq	.tamenashi
	lda.l	TameDamaXYTbl,x
	clc
	adc	kz_tpx
	km_setsprite

	lda.l	TameDamaXYTbl+1,x
	clc
	adc	kz_tpy
	dec	a
	km_setsprite
	a16
	ldx	mmx_jetptr
	lda.l	TameDamaCharTbl,x
	km_setsprite
.tamenashi
;*** houdai ***
	ldx	kx_houdaiangle
	a8
	lda.l	HoudaiTbl,x
	clc
	adc	kz_tpx
	km_setsprite

	lda.l	HoudaiTbl+1,x
	clc
	adc	kz_tpy
	dec	a
	km_setsprite
	a16
	lda.l	HoudaiTbl+2,x
	km_setsprite

;* charge *
	km_bitcheckflag16	kx_satelliteflag,safl_charge
	beq	.tame_ok
	lda	kz_x3
	cmp	#sa_chargeanmtm
	bcs	.tame_ok

	km_stxvar	kz_x2,kx_sachargeanmptr
	km_stxvar	kz_y2,kx_sachargeanmtm
	jsr	BlockAnimeTrans
	km_stxvar	kx_sachargeanmptr,kz_x2
	km_stxvar	kx_sachargeanmtm,kz_y2
.tame_ok

;* torituki animation *
	km_bitcheckflag16	kx_satelliteflag,safl_toritukitrig
	beq	.base

	km_stxvar	kz_x2,kx_satoritukianmptr
	km_stxvar	kz_y2,kx_satoritukianmtm
	jsr	BlockAnimeTrans
	km_stxvar	kx_satoritukianmptr,kz_x2
	km_stxvar	kx_satoritukianmtm,kz_y2
	cpx	#-1
	km_bne	.end
	km_clrflag16	kx_satelliteflag,safl_toritukitrig
;* satellite base *
.base
	ldx	kx_satellitetype
	lda.l	Satellitetbl,x
	sta	kz_tpa
	jsr	SetSprite_16x16
	brl	.end
;-----------------------------------------------------------
;* character data set *
	longa
	longi
.virus
	plx
	lda	kx_4GframeTm
	and	#3
	asl	a
	tax
	lda.l	SprVirusTbl,x
	sta	kz_tpa
	jsr	SetSprite_8x8
	brl	.end
;-----------------------------------------------------------
;* character data set *
	longa
	longi
.special
	plx
	ldx	mmx_expzacojetptr
	lda.l	SprSpecialTbl,x
	sta	kz_tpa
	jsr	SetSprite_16x16
	brl	.end
;-----------------------------------------------------------
;* character data set *
	longa
	longi
.wolf
	plx
	ldx	mmx_expzacojetptr
	lda.l	SprWolfTbl,x
	sta	kz_tpa
	jsr	SetSprite_8x8
	brl	.end
;-----------------------------------------------------------
;* zahyou set *
	longa
	longi
.sosenemy
	plx
	stx	kpointer
	a8
	lda.w	mmx_enposx+1,x
	sec
	sbc	#4
	sta	kz_tpx
	km_setsprite	;X zahyou

	lda.w	mmx_enposy+1,x
	sec
	sbc	#4+1
	sta	kz_tpy
	km_setsprite	;Y zahyou

	a16
	longa
	lda.w	mmx_enangY+1,x
	clc
	adc	#8
	km_loba
	km_divu32
	sta	kz_x1		;angle	(0~7)

	km_bitcheckflag16.w	mmx_enflags,enfl_missile,x
	bne	.missile
.normal
	longa
	km_SetSpriteChrVal	sproff_zaco1,colpal0,pri2,noflip,mm_obj_offset
	bra	.SetEnemyJet
.missile
	longa
	PHX
	lda	kz_x1
	asl	a
	tax
	lda.l	kurukurutbl,x
	km_setsprite
	PLX
;--------------------------------
;* Enemy Jet Pointer *
	longa
.SetEnemyJet
	km_bitcheckflag16.w	mmx_enflags2,enfl2_nojet,x
	bne	.JetOFF
	lda	mmx_jetptr
	beq	.JetOFF

	a8
	ldx	kz_x1	;maede set shitearu !!!
	lda	kz_tpx
	clc
	adc.l	EnemyJetXData,x
	km_SetSprite	;X zahyou

	lda	kz_tpy
	clc
	adc.l	EnemyJetYData,x
	km_SetSprite	;Y zahyou

	a16
	ldx	mmx_jetptr
	lda.l	EnemyJetData,x
	km_setsprite
.JetOFF
;--------------------------------
;* Corneria Explosion (yajima's) *
	ldx	kpointer
	km_bitcheckflag16.w	mmx_enflags,enfl_zaco,x
	beq	.end
	bit	#enfl_attackcorneria
	beq	.end
	lda.w	mmx_endestx,x
	sta	map_corneriacrash_posx
	lda.w	mmx_endesty,x
	sta	map_corneriacrash_posy
	jsr	corneria_crash
;--------------------------------
.end
	PLP
	PLX
	rts


;=====================================================================
;*		Display Battle Ship (Planet cannon Charge)	*
;* Init:								*
;*     : Xreg   :Planet List Pointer					*
;*     : Yreg   :sprite pointer					*
;=====================================================================
	longa
	longi
Disp_PCBattleship
	PHX
	lda.w	mmx_enlinkptr,x
	tax

	lda.w	mmx_planetcannontm,x
	cmp	#chargestep2
	bmi	.4g
.8g
	lda	kx_8GframeTm
	bra	.check_colour
.4g
	lda	kx_4GframeTm
.check_colour
	and	#1
	bne	.blue
.normal_colour
	km_ldasprchr	sproff_battleship,colpal1,pri2,noflip,mm_obj_offset
	bra	.skip
.blue
	km_ldasprchr	sproff_battleship,colpal0,pri2,noflip,mm_obj_offset
.skip
	sta	kz_tpa
	jsr	SetSprite_16x16
	PLX
	rts
;=====================================================================
;*		Display Planet Canon Tame			*
;* Init:								*
;*     : Xreg   :Planet List Pointer					*
;*     : Yreg   :sprite pointer					*
;=====================================================================
	longa
	longi
Disp_Pcannon
		PHX
	lda.w	mmx_enlinkptr,x
	sta	mmx_cannonListPtr
	tax

	km_bitcheckflag16.w	mmx_battleshipflag,mmbsf_cannonareain,x
	beq	.end

	lda.w	mmx_planetcannonchart,x
	asl	a
	tax
	jsr	(.table,x)
.end
		PLX
	rts
.table
	dw	pcsprite_nothing&WM
	dw	pcsprite_charge&WM
	dw	pcsprite_fire&WM
	dw	pcsprite_exptrig&WM
	dw	pcsprite_explode&WM
	dw	pcsprite_damagewait&WM
	dw	pcsprite_finish&WM
;--------------------------------------------------------------------------
	longa
pcsprite_nothing
	rts

	longa
pcsprite_finish
;pc_PlanetcannonWait (mismap.asm de clear)
	km_clrmismapstflag	corneriaexplode
	rts
;--------------------------------------------------------------------------
	longa
pcsprite_damagewait
	dec	mmx_cannonExplodeCnt
	beq	.finish
	rts
.finish
	ldx	mmx_cannonListPtr
	inc.w	mmx_planetcannonchart,x
	rts
;--------------------------------------------------------------------------
	longa
pcsprite_exptrig
	ksound	corneria_explode
	km_setmismapstflag	corneriaexplode

	km_setval	mmx_cannonExplodeX1,$5*8+($11*8)<<8
	km_setval	mmx_cannonExplodeX2,$3*8+($10*8)<<8
	km_setval	mmx_cannonExplodeX3,$6*8+($14*8)<<8
	km_setval	mmx_cannonExplodeX4,$3*8+($13*8)<<8

	lda	#cd_objanime_cannonexplode
	sta	mmx_cannonExplodeptr1
	sta	mmx_cannonExplodeptr2
	sta	mmx_cannonExplodeptr3
	sta	mmx_cannonExplodeptr4

	a8
	km_setval	mmx_cannonExplodeEn1,$f*0
	km_setval	mmx_cannonExplodeEn2,$f*1
	km_setval	mmx_cannonExplodeEn3,$f*2
	km_setval	mmx_cannonExplodeEn4,$f*3

	a16
	ldx	mmx_cannonListPtr
	PHY
	lda.w	mmx_bslinkptr,x
	tay
	jsl	SetAttackPoint_l
	PLY

	inc.w	mmx_planetcannonchart,x
	rts
;--------------------------------------------------------------------------
	longa
pcsprite_explode
	stz	mmx_cannonExplodeCnt

	ldx	#0
.loop
	a8
	lda	mmx_cannonExplodeptr1,x
	inc	a
	bne	.skip

	inc	mmx_cannonExplodeCnt
	bra	.next
.skip
	lda	mmx_cannonExplodeEn1,x
	beq	.objset
	dec	a
	sta	mmx_cannonExplodeEn1,x
.next
	a16
	txa
	clc
	adc	#5
	tax
	cpx	#5*4
	bne	.loop

	lda	mmx_cannonExplodeCnt
	cmp	#4
	bne	.skipaaa

	ldx	mmx_cannonListPtr
	inc.w	mmx_planetcannonchart,x
	km_setval	mmx_cannonExplodeCnt,5	;damage counter initial
.skipaaa
	rts

.objset
	shorta
	lda	mmx_cannonExplodeX1,x
	sta	oam_centerX
	lda	mmx_cannonExplodeY1,x
	sta	oam_centerY
	lda	mmx_cannonExplodeptr1,x
	sta	oam_animeNo	; animation No

	lda	mmx_cannonExplodetm1,x
	sta	oam_tcount	; animation Timer
	inc	a
	sta	mmx_cannonExplodetm1,x
	cmp	#42
	bne	.skipbbb
	lda	#-1
	sta	mmx_cannonExplodeptr1,x
.skipbbb
	a16
	jsr	set_kawaobj
	brl	.next
;--------------------------------------------------------------------------
	longa
pcsprite_fire
	ldx	mmx_cannonListPtr
	a8
	lda.w	mmx_planetcx,x
	sec
	sbc	#10
	sta	oam_centerX	; <- position X

	lda.w	mmx_planetcy,x
	clc
	adc	#12
	sta	oam_centerY	; <- position Y

	lda.w	mmx_pwork1,x
	sta	oam_animeNo	; animation No

	lda.w	mmx_pwork2,x
	sta	oam_tcount	; animation Timer
	inc	a
	sta.w	mmx_pwork2,x
	cmp	#36
	bne	.skipa
	inc.w	mmx_planetcannonchart,x
.skipa
	a16
	jsr	set_kawaobj
	rts
;--------------------------------------------------------------------------
	longa
pcsprite_charge

	ldx	mmx_cannonListPtr
	lda.w	mmx_planetcx,x
	sec
	sbc	#10-3
	sta	kz_tpx

	lda.w	mmx_planetcy,x
	clc
	adc	#12-4
	sta	kz_tpy

	phx		;>>>>>>
	lda.w	mmx_planetcannontm,x
	tax
	km_ldasprchr	$68,colpal7,pri2,noflip,mm_obj_offset
	cpx	#8*60
	bpl	.set
	ina
	ina
	cpx	#6*60
	bpl	.set
	ina
	ina
	cpx	#2*60
	bpl	.set
	ina
	ina
.set
	sta	kz_tpa
	plx		;<<<<<<

	jsr	SetSprite_16x16
	
	lda.w	mmx_pwork1,x
	sta	kz_x2
	lda.w	mmx_pwork2,x
	sta	kz_y2

	jsr	BlockAnimeTrans

	lda	kz_x2
	sta.w	mmx_pwork1,x
	lda	kz_y2
	sta.w	mmx_pwork2,x
	rts

;=====================================================================
;*		Display Battle Ship Jet				*
;* Init:								*
;*     : Xreg   :Enemy List Pointer					*
;=====================================================================
	longa
	longi
Disp_BSjet
;**** Battle Ship Jet ****
	km_bitcheckflag.w	mmx_enflags2,enfl2_nojet,x
	bne	.NotDisplay
	lda	mmx_jetptr
	beq	.NotDisplay
;(sub)
	km_setspritesizesb1
;(char)
	phx
	ldx	mmx_jetptr
	lda.l	BSJetData,x
	sta.w	sprites+2,y
	plx

;(pos)
	a8
	lda	oam_centerY
	sec
	sbc	#16+1-2
	xba
	lda	oam_centerX
	sec
	sbc	#2
	a16
	sta.w	sprites+0,y	; <- Jet Pos (x1,y1)

	tya
	clc
	adc	#8
	tay
.NotDisplay
	rts

;*********************************************************************
;*		MISSION EXPLAIN					*
;* data bank :7e							*
;* mem8,idx16							*
;* Yreg :sprites pointer						*
;*********************************************************************
Sprites_explain_l
	shorta
	longi
	jsl	missobj_l
	rts

;*********************************************************************
;*								*
;*		Display ONE Screen Cockpit			*
;* data bank :7e							*
;* mem8,idx16							*
;* Yreg :sprites pointer						*
;*********************************************************************
Sprites_mission_l
	shorta
	longi
;* display enable wait *
	lda	sprdispwait
	beq	.enable
	dec	a
	sta	sprdispwait
	brl	.end
;---------------------------------------------------------------------
.enable
	km_bitcheckmissionflag	spriteoff
	km_bne	.nosprite

;* obj radar scale Set *
;!! kono set wa initgame_l no routine yori maeni oku !!
	jsr	SetRadarScale
	jsl	gameobj_l	;(For yajima)

;* MEMO :MISSION START no toki ni message wo daasu tame *
;*      :hokano OBJ wa keshiteoku *
	lda	meterswitch	;subeteno obj wo kesu
	km_beq	.end

;-------------------------------------------------------------
;*		Sprites Set		[mission]	*
;-------------------------------------------------------------
.setsprites

;----- Syoujyun --------
;* OBJ no Priority wo narubeku takaku !! *
	MissionTargetStates	1
	jsr	SetSyoujyunMark

;-----  Kotei Data -----
	BlockTransSpritesBigDouble	SpritesMissionData

;----- Mission Target kazu -----
	lda	gameobjstruct
	cmp	#idx_demo_targetcount
	beq	.skip	;moshi BIG Number Display no toki !!
	MissionEnemyNumberStates
	jsr	SetEnemyNumber
.skip

;* syousuu *
	a16
	lda	kx_GameTmAdd
	km_cpudivu16uf8_work	decimaltm
	km_setvar	kz_x2,ksyou
	km_setvar	kx_YJGameTm,ksyou
	km_setval	kz_x1,$17*8-1+4+($2*8+1)<<8
	km_setsprchr	kz_x3,$30,colpal0,pri3,noflip
	km_setval	kz_y1,1
	a8
	jsr	SetSprNumber_8x8

;----- Radar Mask ----
; normal chr *
	SetSprXYChr_Im	($18*8),2*8,sprmask,colpal0,pri0,noflip
	SetSprXYChr_Im	($18*8),3*8,sprmask,colpal0,pri0,noflip
	SetSprXYChr_Im	($18*8),4*8,sprmask,colpal0,pri0,noflip
;----- Radar Mask ----
	BlockTransSpritesBigDouble	SpriteMaskData

;----- Radar ---------
	MissionRadarStates	1,x
	jsl	SetSprites_inRadar_l

;----- Ring Out ------
	MissionRingOutStates 1,x
	jsr	RingOut

;---- CorneriaDamage (%) -----
	jsr	SetSprCorneriaHP

;---- score ----
	a16
	km_setval	kz_x1,($c*8-2+($2*8+1)<<8)
	km_setvar	kz_x2,kx_basicscore	;kw_totalscore1
	km_setsprchr	kz_x3,$30,colpal1,pri3,noflip
	km_setval	kz_y1,5
	a8
	jsr	SetSprNumber_8x8
;---- Game Timer ----
	a16
;* Clock *
	km_setval	kz_tpx,$13*8-1+4
	km_setval	kz_tpy,$2*8+1+4+2
	km_setsprchr	kz_tpa,$84,colpal1,pri2,noflip
	jsr	SetSprite_16x16

;* time *
	km_setval	kz_x1,$15*8-1+4+($2*8+1)<<8
	km_setvar	kz_x2,kw_GameTimer
	km_setsprchr	kz_x3,$30,colpal0,pri3,noflip
	km_setval	kz_y1,2
	a8
	jsr	SetSprNumber_8x8

;* . hyouji *
	SetSprXYChr_Im	$16*8-1+4,$2*8+1+2,$3e,colpal0,prio3,noflip

;-------------------------------------------------------------
;*			COMMON				*
;-------------------------------------------------------------
.common
;----- HP ------
	km_plheapptr	1,x	;player heap pointer set
	a16
	lda	khp,x
	and	#$3f
	sta	kz_x1	;HP

	PHX
	lda	p1_pilotNo
	and	#$ff
	lsr	a
	asl	a
	tax
	lda.l	mis_HPtamaPosTbl,x
	sta	kz_x2	;(X,Y) offset postion
	a8
	PLX
	jsl	SetSprDamageMeter_l

;* '94/10/5 :kono flag clear wa kanarazu hituyou !! *
;* konoflag ga tatteirutoki wa sprite wo hyouji !!*
	km_clrflag	KHP,kdmgflag,x	;[For Kawagoe]


;----- Special Weapon ----
	jsr	SetSpecialWeapon

;----- boost name ------
;	km_player	1,x
;	pl_jmpnot_ifboostdisp	x,.notdisplay
;	BlockTransSpritesBigDouble	SprBoostData
;

.notdisplay
.nosprite
	sty	sprpointer

;=================== Debug Mode ========================
	ifne	kginfo
	jsr	SprDbugMode1
	endc

.end
	rts

;=====================================================================
;*								*
;*			Damage Meter	[MISSION]		*
;* Mem16 idx16							*
;* Data Bank:7e							*
;* Init :kz_x1 = player HP						*
;*      :kz_x2 = HP postion offset					*
;* Yreg:Sprites Pointer						*
;* KHP   : Max 40	b7:flag	:b0-b5 (HP)				*
;=====================================================================
missHpchroff	equ	5

tama_blu	equ	0
tama_yel	equ	1
tama_red	equ	2
;--------------------------------------------------------------------
	shorta
	longi
SetSprDamageMeter_l
	phx
	a16
	lda	p1_pilotNo
	lsr	a
	asl	a
	and	#$00ff
	tax

	lda.l	TamaCountTbl,x
	sta	kz_tpx

	lda.l	SprDmMeterOffSet,x
	tax
.loop
;(X,Y)zahyo Set
	lda.l	HPDAMATbl,x
	clc
	adc	kz_x2
	sta	sprites,y
	iny
	iny
;---------------------------------
;HP set
	lda	kz_x1
	beq	.HP0		;HP = 0
	cmp	#4
	bpl	.HPmore4	;HP >= 4
;-----------------------------------
.HP3
	stz	kz_x1
	lda	#tama_yel
	bra	.SetCharacter
;-----------------------------------
.HP0
	lda	#tama_red
	bra	.SetCharacter
;-----------------------------------
.HPmore4
	lda	kz_x1
	sec
	sbc	#4
	sta	kz_x1

	lda	#tama_blu
;-----------------------------------
.SetCharacter
	km_SetSpriteChrA	missHpchroff,colpal3,pri2,noflip
;-----------------------------------
.StepCounter
	inx
	inx
	dec	kz_tpx
	bne	.loop
;--------------------------------------------------------------------------
.end
	a8
	plx
	rtl

TamaCountTbl
	dw	ff_hp/4	;Fox,Falco
	dw	sp_hp/4	;Peppy,Slippy
	dw	mf_hp/4	;Myu,Fay

SprDmMeterOffSet
	dw	(HpType1-HPDAMATbl)&WM
	dw	(HpType2-HPDAMATbl)&WM
	dw	(HpType3-HPDAMATbl)&WM

;* Fox,Falco *
HPDAMATbl
HpType1
	dw	$0000,$0008,$0010,$0018
	dw	$0800,$0808,$0810,$0818
;* Peppy,Slippy *
HpType2
	dw	$0000,$0008,$0010,$0018,$0020
	dw	$0800,$0808,$0810,$0818,$0820
;* Myu,Fay *
HpType3
	dw	$0000,$0008,$0010
	dw	$0800,$0808,$0810


;---------------------------------------------------------------------
;*								*
;*			Set Radar Scale				*
;* Tmp Work :kz_x1,kz_z1,kz_tpa,kz_tpx,kz_tpy			*
;* kz_y1    :Enemy Cout (0 ... no enemy)				*
;---------------------------------------------------------------------
	shorta
	longi
SetRadarScale
	phb
	db7e
	a16
;* initial *
	stz	kz_tpy
	stz	kz_y1
	stz	kz_tpa
	stz	kz_tpx
	MissionPlayerStates	1,x

;* enemy gone *
	km_bitcheckmissionflag	enemyrunaway
	km_bne	.end

;* radar scale check *
	km_bitcheckmismapflag	autoradar
	km_beq	.SetRadarScale	;if radar scale fix then .SetRadarScale

;********** Enemy List Check ************
	ldx	allst		;alien pointer
	km_beq	.CheckEnemyGone	;No Alien
;------------ Check Alien Radar ON/OFF Chara -----------
.NextAlien
	km_loblda.w	al_radarobj,x
	beq	.Set_next_pnt
	cmp	#ra_enemy	;radar = enemy ?
	beq	.SetAlien
;------------- Next pointer set & End Check ------------
.Set_next_pnt
	lda.w	_next,x
	tax
	bne	.NextAlien	;If haven't finished Alien List Check
	brl	.CheckEnemyGone

;======================== Alien Set ==========================
	longa
	longi
.SetAlien
	inc	kz_y1

;------ sprites (x,y) coordinates set ------
	lda.w	al_worldx,x
	sec
	sbc	kpx
	bpl	.checkX
	km_nega
.checkX
	cmp	kz_tpx
	bcc	.skipX
	sta	kz_tpx
.skipX
;---------------------------
	lda.w	al_worldz,x
	sec
		sbc	kpz
	bpl	.checkZ
	km_nega
.checkZ
	cmp	kz_tpy
	bcc	.skipZ
	sta	kz_tpy
.skipZ
	brl	.Set_next_pnt
;---------------------------------------------------------------------------
.CheckEnemyGone
	ifeq	kenemygone

	km_bitcheckmissionflag	enemygonefreeze
	bne	.notenemygone
	lda	kenemynumber		;mission clear ?
	beq	.notenemygone
	lda	kz_y1			;enemy ga sonzai suru ?
	bne	.notenemygone

	km_setmissionflag	enemyrunaway
	bra	.end
.notenemygone

	endc
;---------------------------------------------------------------------------
.CalcSpaceRadarScale
	km_setval	kx_radarscale,2	;initial scale

	lda	kz_tpx
	cmp	kz_tpy
	bcs	.biggerX
	lda	kz_tpy
.biggerX
	cmp	#radarlen_1
	bcs	.SetRadarScale
	dec	kx_radarscale
	cmp	#radarlen_0
	bcs	.SetRadarScale
	dec	kx_radarscale
;---------------------------------------------------------------------------
.SetRadarScale
;	km_setval	kz_tpy,(radar_max)
	km_setval	kz_tpy,(radar_max/2)	;<<<<<

	lda	kx_radarscale
	beq	.NotZoom
	bit	#$8000
	BNE	.ZOOM_up
.zoom_down
	tax
.loop1
	asl	kz_tpy
	dex
	bne	.loop1
	bra	.notzoom
.zoom_up
	nega
	tax
.loop2
	lsr	kz_tpy
	dex
	bne	.loop2
.notzoom
	lda	kz_tpy
	sta	kx_radarmin
	asl	a
	sta	kx_radarmax
;---------------------------------------------------------------------------
.end
	a8
	plb
	rts





;-------------------------------------------------------------
;*			BOSS				*
;-------------------------------------------------------------
	IFEQ	1
.boss
	brl	.common

;;;;	jsr	BossSprites

;* yajima san set (hell.asm)* 
;	phy
;	setdepth	night
;	km_setgamepal	night
;	ply

	a8
	lda	kw_swork+16
	beq	.bbb
	dec	a
	sta	kw_swork+16
	bra	.skip
.bbb
	lda	#1
	sta	kw_swork+16

	lda	kw_swork+18
	inc	a
	and	#3
	sta	kw_swork+18
	beq	.night
	dec	a
	beq	.mist
	dec	a
	beq	.marine
	dec	a
	beq	.desert
.night
	setdepth	night
	bra	.skip
.mist
	setdepth	mist
	bra	.skip
.desert
	setdepth	desert
	bra	.skip
.marine
	setdepth	marine
	bra	.skip
.skip

	ENDC


;*********************************************************************
;*		Corneria HP Display				*
;* Init :								*
;* data bank :7e							*
;* Yreg :Sprite Pointer						*
;*********************************************************************
SetSprCorneriaHP
	a16
	longi
	km_bitcheckmistotalflag	finalbossbattle
	km_bne	.end
	km_bitcheckmissionflag	wolfboss
	km_bne	.end
;----------------------------------------------------
;* Corneria Damage >= 90 then Always Display *
	lda	kx_CorneriaDamage
	cmp	#corneriaDangerDamage
	bcs	.AlwaysDisplay

	km_bitcheckmissionflag	pause
	bne	.AlwaysDisplay
;----------------------------------------------------
;* Timer Check *
;;;	km_bitcheckmismapflag	attackcorneria
	km_bitcheckscreenflag	damagetrig
	beq	.TimeCheck
.AlwaysDisplay
	km_setval	msx_CorneriaDispTm,60
.TimeCheck
	lda	msx_CorneriaDispTm
	km_beq	.end
	dec	a
	sta	msx_CorneriaDispTm
;----------------------------------------------------
;**** Planet no hyouji ****
	a8
	km_setval	kz_tpx,$4*8+2
	km_setval	kz_tpy,$4*8+1
	km_stxval	kz_tpa,spr32x32_corneria
	jsr	SetSprite_32x32
	a16

;* Corneria Flash *
	lda	kx_CorneriaDamage
	cmp	#corneriaDangerDamage
	bcc	.skip2		Corneria Damage < 80

	km_bitcheckmissionflag	pause
	bne	.Colour_RED

	lda	kx_2frameTm
	bne	.skip1
	km_eorflag16	kspriteflag,sf_corneriaflash
.skip1
	km_bitcheckflag16	kspriteflag,sf_corneriaflash
	beq	.skip2
.Colour_RED
	a8
	lda	sprites-13,y
	ora	#obj_colpal2_h
	sta	sprites-13,y
	sta	sprites-9,y
	sta	sprites-5,y
	sta	sprites-1,y
	a16
.skip2

;**** Corneria Damage no hyouji ****
	lda	kx_CorneriaDamage
	cmp	#100
	beq	.damage100
	sta	kz_x2
	km_setval	kz_x1,($6*8+4)<<8+(4*8-2)
	km_setsprchr	kz_x3,$30,colpal0,pri3,noflip
	km_setval	kz_y1,2	;[ketasuu]
	jsr	SetSprNumber_8x8
;* % no hyouji *
	km_setsprite	#($6*8+4-1)<<8+(5*8-2)
	km_SetSpriteChrVal	$9,colpal0,pri3,noflip
	bra	.end
.damage100
	km_setval	kz_x1,($6*8+4)<<8+(4*8-2+4)
	km_setsprchr	kz_x3,$30,colpal0,pri3,noflip
	km_setval	kz_y1,3	;[ketasuu]
	km_setval	kz_x2,100
	jsr	SetSprNumber_8x8
;* % no hyouji *
	km_setsprite	#($6*8+4-1)<<8+(5*8-2+4)
	km_SetSpriteChrVal	$9,colpal0,pri3,noflip

.end
	a8
	rts
;*********************************************************************
;*		Special	Weapon Display				*
;* Init :								*
;* data bank :7e							*
;* Xreg :Heap Pointer						*
;* Yreg :Sprite Pointer						*
;*********************************************************************
sprweaponx	equ	2*8+2+8
sprweapony	equ	$18*8+8-1
;-------------------------------
SetSpecialWeapon
	php
	a16
	longi
	lda.w	exal_spweap_lmt,x
	and	#%00001111
	beq	.end

;* "item" label *
	km_setval	kz_tpx,sprweaponx-10+16
	km_setval	kz_tpy,sprweapony-16+8
	km_setsprchr	kz_tpa,$40,colpal0,pri3,noflip
	jsr	SetSprite_32x16

;* weapon type *
	km_setval	kz_tpx,sprweaponx
	km_setval	kz_tpy,sprweapony

	phx
	km_lldasla.w	exal_spweap_type,x
	tax
	lda.l	SpecialWeaponTbl,x
	sta	kz_tpa
	plx
	jsr	SetSprite_16x16

;* weapon no kazu *
	km_setval	kz_x1,((sprweapony-8)<<8+sprweaponx+12-1)
	lda.w	exal_spweap_lmt,x
	and	#%00001111
	ora	#obj_colpal1
	sta	kz_tpa
	jsr	SetSprNumber_8x16_sub
.end
	plp
	rts



;=====================================================================
;*								*
;*			BOSS Sprites				*
;* Data Bank 7e							*
;* Yreg :sprites pointer						*
;=====================================================================
	IFEQ	1
BossSprites
	shorta
	longi

	km_lldaslx	kw_BossPtr
	jmp	(.bosstable,x)
;--------------------------------------------------------------------
.boss_init
	lda	#$20
	sta	kw_BossMeterDMAsw
	brl	.boss_next
;---------------------------------------------------------------------
;**** VRAM Clear *****
.boss_clear
	shorta
	longi
	lda	kw_BossMeterDMAsw
	km_bne	.boss_exit

	lda	#$20
	sta	kw_BossMeterDMAsw
	brl	.boss_next
;---------------------------------------------------------------------
;***** CGX Transfer *****
.boss_trans
	shorta
	longi

	lda	kw_BossMeterDMAsw
	km_bne	.boss_set

	lda	#$20
	sta	kw_BossMeterDMAsw
	brl	.boss_next
;---------------------------------------------------------------------
.boss_full
	shorta
	longi

	lda	kx_BossMeterPtr
	inc	a
	sta	kx_BossMeterPtr
	cmp	#24
	bne	.skip1
	inc	kw_bossptr
.skip1
	brl	.boss_set
;---------------------------------------------------------------------
.boss_main
	shorta
	longi

;;;	ldx	bossptr
;;;	lda.w	al_hp,x

	lda	kx_bosshp
	km_divu4
	sta	kx_BossMeterPtr
;---------------------------------------------------------------------
;----- boss meter ----
.boss_set
	a16
;*** boss name ***
	km_SetSpriteImXY	$c0-6,$10+2
	km_SetSpriteChrVal	bossmoji_b,colpal0,pri3,noflip
	km_SetSpriteImXY	$c8-6,$10+2
	km_SetSpriteChrVal	bossmoji_o,colpal0,pri3,noflip
	km_SetSpriteImXY	$d0-6,$10+2
	km_SetSpriteChrVal	bossmoji_s,colpal0,pri3,noflip
	km_SetSpriteImXY	$d8-6,$10+2
	km_SetSpriteChrVal	bossmoji_s,colpal0,pri3,noflip

;*** boss meter ***

	SetSprXYChr_im	$d8,$10,$9c,colpal5,pri3,noflip
	SetSprXYChr_im	$d0,$18,$9d,colpal5,pri3,noflip
	SetSprXYChr_im	$d8,$18,$9e,colpal5,pri3,noflip

	lda	kx_BossMeterPtr
	and	#$ff
	km_multa6
	tax
	km_SetSpriteSizeDouble
	km_SetSpriteImXY	$e0,$10
	lda.l	.bossmeter+0,x
	km_SetSprite

	km_SetSpriteSizeDouble
	km_SetSpriteImXY	$e0,$20
	lda.l	.bossmeter+2,x
	km_SetSprite

	km_SetSpriteSizeDouble
	km_SetSpriteImXY	$d0,$20
	lda.l	.bossmeter+4,x
	km_SetSprite
	a8
	bra	.boss_exit
;---------------------------------------------------------------------
.boss_next
	a16
	stz	kw_dmasaddr
	stz	kw_dmadaddr
	a8
	inc	kw_bossptr
;---------------------------------------------------------------------
.boss_exit
	rts

;---------------------------------------------------------------------
;*		BOSS Sprites Sequence Table			*
;---------------------------------------------------------------------
.bosstable
	dw	.boss_init&WM
	dw	.boss_clear&WM
	dw	.boss_trans&WM
	dw	.boss_full&WM
	dw	.boss_main&WM
	dw	.boss_set&WM
;---------------------------------------------------------------------
;*		BOSS Sprites Meter Table			*
;* MAX HP = 96							*
;* BOSS METER MAX = 24 pattern					*
;* Total Byte = 150 byte						*
;---------------------------------------------------------------------
.bossmeter
;00 :Empty
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal6,pri3,xyflip
;-----------------------------------------------------
;01
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$ae,colpal5,pri3,xyflip
;02
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$ac,colpal5,pri3,xyflip
;03
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$aa,colpal5,pri3,xyflip
;04
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$a8,colpal5,pri3,xyflip
;05
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$a6,colpal5,pri3,xyflip
;06
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$a4,colpal5,pri3,xyflip
;07
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$a2,colpal5,pri3,xyflip
;08
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;-----------------------------------------------------
;09
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a2,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;10
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a4,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;11
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a6,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;12
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a8,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;13
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$aa,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;14
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$ac,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;15
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$ae,colpal6,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;16
	SprChrDataW	$a0,colpal6,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;-----------------------------------------------------
;17
	SprChrDataW	$ae,colpal5,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;18
	SprChrDataW	$ac,colpal5,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;19
	SprChrDataW	$aa,colpal5,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;20
	SprChrDataW	$a8,colpal5,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;21
	SprChrDataW	$a6,colpal5,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;22
	SprChrDataW	$a4,colpal5,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;23
	SprChrDataW	$a2,colpal5,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip
;24 :FULL
	SprChrDataW	$a0,colpal5,pri3,noflip
	SprChrDataW	$a0,colpal5,pri3,yflip
	SprChrDataW	$a0,colpal5,pri3,xyflip

	ENDC
;=====================================================================
;*								*
;*		Mission Game Round Over				*
;*								*
;=====================================================================
	ifeq	1
MissionGameOver
	shorta
	longi

	km_bitcheckmissionflag	timeup
	beq	.nottimeup
	lda	#$0
	sta	ksproffx
	lda	#$40
	sta	ksproffy
	BlockTransSpritesOffset	TimeUpData
.nottimeup
	plb
	rtl
	ENDC


;*********************************************************************
;*		Pause Sprites Set (Battle)	[PAUSE]		*
;* Data Bank 7e							*
;* Yreg :spites poionter						*
;*********************************************************************
Sprites_battlepause_l
	SHORTA
	LONGI
	rts

;*********************************************************************
;*			Type Select Sprites			*
;* Data Bank 7e							*
;* Yreg :spites poionter						*
;*********************************************************************
Sprites_typesel_l
	shorta
	longi
	rts

	IFEQ	1
;---- waku ----
	km_lldx	tsx_keyyokoptr
	lda.l	.wakutable,x
	sta	tsx_wakuposx
	km_setval	tsx_wakuposY,$a*8

	km_SetSpriteXY_ImOff	tsx_wakuposX,tsx_wakuposY,-40,-30
	km_SetSpriteChrVal	$c,colpal3,pri3,noflip

	km_SetSpriteXY_ImOff	tsx_wakuposX,tsx_wakuposY,32,-30
	km_SetSpriteChrVal	$c,colpal3,pri3,xflip

	km_SetSpriteXY_ImOff	tsx_wakuposX,tsx_wakuposY,-40,22
	km_SetSpriteChrVal	$c,colpal3,pri3,yflip

	km_SetSpriteXY_ImOff	tsx_wakuposX,tsx_wakuposY,32,22
	km_SetSpriteChrVal	$c,colpal3,pri3,xyflip

;--- aicon ---
	lda	tsx_keytateflag
	and	#3
	asl	a
	a16
	and	#$ff
	tax
	lda.l	.aicontable_ply,x
	sta	tsx_aiconposx
	a8
	jsr	.setaicon_sub

;--- cont ---
	lda	#95
	sta	tsx_aiconposx
	lda	#63
	sta	tsx_aiconposy

	km_bitcheck	tsx_keytateflag,4
	beq	.skip1
	lda	#87
	sta	tsx_aiconposy
.skip1
	jsr	.setaicon_sub

;--- return ---
	lda	#175
	sta	tsx_aiconposx

	lda	#63
	sta	tsx_aiconposy

	km_bitcheck	tsx_keytateflag,8
	beq	.skip2
	lda	#87
	sta	tsx_aiconposy
.skip2
	jsr	.setaicon_sub

	rts
;-----------------------------------------------
.wakutable
	db	6*8,6*8+10*8,6*8+10*8*2
.aicontable_ply
	db	15,55,15,71,15,87
;-----------------------------------------------
.setaicon_sub
	shorta
	longi
	km_SetSpriteXY_ImOff	tsx_aiconposX,tsx_aiconposY,0,0	;($37<<8+15)
	km_setspritesizeDouble_l
	km_SetSpriteChrVal	0,colpal0,pri3,noflip

	km_SetSpriteXY_ImOff	tsx_aiconposX,tsx_aiconposY,16,0;($37<<8+15+16)
	km_setspritesizeDouble_l
	km_SetSpriteChrVal	2,colpal0,pri3,noflip
	rts
	ENDC

;*****************************************************************************
;*									*
;*									*
;*			Display TWO Screen Cockpit			*
;*									*
;* data bank :7e								*
;* mem8,idx16								*
;* Yreg :sprites pointer							*
;*									*
;*****************************************************************************
Sprites_battle_l
	shorta
	longi
	IFEQ	1
;-------------------------------------------------------------
;*	If Game Over then No Sprites			*
;-------------------------------------------------------------
	km_bitcheckbattleflag	GameOver
	beq	.setsprites
	jmp	.RoundOver_battle
;=============================================================
;*		Sprites Data Set			*
;* [ Radar,Game Timer,Enemy Number,RingOut ]			*
;=============================================================
.setsprites
;* obj radar scale Set *

	ldy	sprpointer

;********* Kotei Data ***********
	BlockTransSprites		SpritesBattleData
	BlockTransSpritesBigDouble	SpritesBattleData4

;********* Player 1 States *******
;----- HP ------
	km_plheapptr	1,x	;player heap pointer set
	a16
	lda	khp,x
	and	#$3f
	sta	kz_x1	;HP

	lda	#$19*8+($0c*8)<<8
	sta	kz_x2	;(X,Y) offset postion
	a8
	jsl	SetSprDamageMeter_l
;* '94/10/5 :kono flag clear wa kanarazu hituyou !! *
;* konoflag ga tatteirutoki wa sprite wo hyouji !!*
	km_clrflag	KHP,kdmgflag,x	;[For Kawagoe]
;----- Game Timer -----
	a16
	km_setval	kz_x1,($1b*8+4+($3*8-2)<<8)
	km_setvar	kz_x2,kw_GameTimer
	km_setval	kz_x3,obj_colpal0
	km_setval	kz_y1,3
	a8
	jsr	SetSprNumber_8x8

;********* Player 2 States *******
;----- HP ------
	km_plheapptr	2,x	;player heap pointer set
	a16
	lda	khp,x
	and	#$3f
	sta	kz_x1	;HP

	lda	#$02*8+($019*8)<<8
	sta	kz_x2	;(X,Y) offset postion
	a8
	jsl	SetSprDamageMeter_l	;[For Kawagoe]

;* '94/10/5 :kono flag clear wa kanarazu hituyou !! *
;* konoflag ga tatteirutoki wa sprite wo hyouji !!*
	km_clrflag	KHP,kdmgflag,x
;----- Game Timer -----
	a16
	km_setval	kz_x1,($4*8+4+($10*8-2)<<8)
	km_setvar	kz_x2,kw_GameTimer
	km_setval	kz_x3,obj_colpal0
	km_setval	kz_y1,3
	a8
	jsr	SetSprNumber_8x8

;======== Game Timer ========================
;;;;	jsl	SprGameTimer_l
;======== waku ==============================
;	jsl	timer_waku

;********* Radar & RingOut &Enemy Number **********
	jsr	BattleSprites

	sty	sprpointer
;*********************** Debug Mode ****************************
;;;	kbugapuport

;===================== Debug Mode ========================
	ifne	kginfo
	jsr	SprDbugMode1
	endc
.end
	rts
;=============================================================
;*		Battle Game Round Over			*
;=============================================================
.RoundOver_battle
	shorta
	longi
	km_bitcheckbattleflag	timeup
	beq	.end

	lda	#p1scroffx
	sta	ksproffx
	lda	#p1scroffy
	sta	ksproffy
	BlockTransSpritesOffset	RoundOverData
	BlockTransSpritesOffset	TotalData


	lda	#p2scroffx
	sta	ksproffx
	lda	#p2scroffy
	sta	ksproffy
	BlockTransSpritesOffset	RoundOverData
	
BlockTransSpritesOffset	TotalData
;---- score ----
	IFEQ	1
	a16
	lda.l	Kroundscore1
	sta	kwork
	lda	#$30a0
	sta	kwork+2
	jsr	SetSprNumber

	lda.l	Khpscore1
	sta	kwork
	lda	#$3ca0
	sta	kwork+2
	jsr	SetSprNumber

	lda.l	Kringoutscore1
	sta	kwork
	lda	#$48a0
	sta	kwork+2
	jsr	SetSprNumber

	lda.l	Kroundtotalscore1
	sta	kwork
	lda	#$58a0
	sta	kwork+2
	jsr	SetSprNumber_BIG
	a8

;;;	BlockTransSpritesOffset	TimeUpData
	lda	#p2scroffx
	sta	ksproffx
	lda	#p2scroffy
	sta	ksproffy

	BlockTransSpritesOffset	RoundOverData
	BlockTransSpritesOffset	TotalData
;;;	BlockTransSpritesOffset	TimeUpData
	a16
	lda.l	Kroundscore2
	sta	kwork
	lda	#$98d0
	sta	kwork+2
	jsr	SetSprNumber

	lda.l	Khpscore2
	sta	kwork
	lda	#$a4d0
	sta	kwork+2
	jsr	SetSprNumber

	lda.l	Kringoutscore2
	sta	kwork
	lda	#$b0d0
	sta	kwork+2
	jsr	SetSprNumber

	lda.l	Kroundtotalscore2
	sta	kwork
	lda	#$c0d0
	sta	kwork+2
	a8
	jsr	SetSprNumber_BIG
	ENDC

	ENDC
	rts

;=====================================================================
;*								*
;*			World Map Radar		[MISSION,BATTLE]*
;* Data Bank :7e bank						*
;* Yregister :sprites pointer					*
;=====================================================================
	IFEQ	1
BattleSprites
	longi
;===== Player 1 ======
	BattleRadarStates	1,x
	jsl	SetSprites_inRadar_l
	BattleTargetStates	1
	jsr	SetSyoujyunMark

	ifeq	1
;;;	jsr	SetEnemyNumber
	BattleRingOutStates 1,x
	jsr	BattleRound
	jsr	RingOut
	endc
;===== Player 2 ======
	IFEQ	1
	BattleRadarStates	2,x
	jsl	SetSprites_inRadar_l
	BattleTargetStates	2
	jsr	SetSyoujyunMark
	ENDC

	ifeq	1
;;;	jsr	SetEnemyNumber
	BattleRingOutStates 2,x
	jsr	BattleRound
	jsr	RingOut
	endc

;===== Player 1 & 2 ======
	jsr	P1P2_inRadar
	rts
	ENDC
;*****************************************************************************
;*									*
;*									*
;*			SUB ROUTINE START	[MISSION]  [BATTLE]	*
;*									*
;*									*
;*****************************************************************************
;=====================================================
;*		BattleRound Display		*
;* data bank 7e					*
;* X reg :player heap pointer			*
;* Yreg :sprite pointer				*
;=====================================================
BattleRound
	shorta
	longi
	rts

	IFEQ	1
	lda	Kx_GameRoundTm
	beq	.exit
	dec	a
	sta	Kx_GameRoundTm
	and	#0f
	cmp	#8
	bpl	.exit

	BlockTransSpritesOffset	RoundData


	km_SetSpriteImXY_Off	$e*8,$4*8

	km_lldx	Kw_GameRound
	lda.l	RoundTable,x
	km_SetSpriteChrA	$30,colpal0,pri3,noflip
.exit
	rts
RoundTable
	db	0
	db	3
	db	2
	db	1
	ENDC

;=============================================================
;*		Ring Out				*
;* Data Bank :7e						*
;* X reg :player heap pointer				*
;* Y reg :sprite pointer					*
;* KRingOutTimer (heap RAM)	:b7 0/1.. Ring IN /Ring OUT	*
;=============================================================
	shorta
	longi
RingOut
;* Area Out No Syori Nuki Check (Map de Set) *
	km_bitcheckgameflag	areaout
	km_beq	.RingOutExit
;------------- Area Out Check ---------------
.RingOutCheck
	a16
	PHX
	CheckArea
	beq	.RingIn
	bra	.RingOut

;	a16
;	lda	kpx
;	sec
;	sbc	kmapoffx
;	km_braareaout	kareaminX,kareamaxX,.RingOut
;	lda	kpz
;	sec
;	sbc	kmapoffz
;	km_braareaout	kareaminZ,kareamaxZ,.RingOut

;********* Area in **********
;--------- Ring Return Check & Flag Clear ----------
.RingIn
	PLX
	a8
;	km_bitcheckgameflag	battle
;	km_bne	.battle_in

.battle_in
	km_jmpnotflag	KRingOutTimer,KROutFlag,.RingOutExit,x
	km_clrflag		KRingOutTimer,KROutFlag,x
	brl	.RingOutExit

;******** Ring Out **********
;------ Check Start Ring Out  --------
.RingOut
	PLX
	a8
	km_jmpflag	KRingOutTimer,KROutFlag,.DecTimer,x

	km_bitcheckgameflag	battle
	km_bne	.battle_out
.mission_out
	km_setval	KRingOutSecTm,second,x	  ; 1 secon time (15)
;;;;;;	km_setval	KRingOutTimer,ROIntTm,x   ;Set Ring Out Time
	km_setflag	KRingOutTimer,KROutFlag,x ;Set Ring Out Flag
	bra	.RingOutSound
.battle_out
	km_setval	KRingOutSecTm,second,x	  ; 1 secon time (15)
	km_setflag	KRingOutTimer,KROutFlag,x ;Set Ring Out Flag
	bra	.RingOutSound

;========  dec (time & second) ,Game Over Check =========
.DecTimer
	shorta
;----- second check -----
	s_decbne_alvar	B,x,KringOutSecTm,.RingOutSound
	km_setval	KRingOutSecTm,second,x		; 1 secon time (15)

;----- Time check -----
;	km_fdec_alvar	B,x,KRingOutTimer,KROutFlag
;	bpl	.NotTimeUp
;* Time UP *
;	km_setflag	KGMOVER,RingOutFlag,x
;
;	inc	KRINGOUT,x
;	s_set_alvar	B,x,KRingOutTimer,#10	;Ring Out Timer <--- 10
;	kplsound	x,nosound0f
;	jmp	.RingOutExit
;If not Game Over then Set Ring Out Timer & Ring Out Fllag
;.NotTimeUp
;	ora	#KROutFlag
;	sta	KRingOutTimer,x	;Dec Time Set

;================== Sound ===================
.RingOutSound
	lda	KRingOutsecTm,x
	cmp	#15
	bne	.nosound		;if 1 second past
.sound
 	kplsound	x,ringoutcount


;	lda	KRingOutTimer,x
;	and	#KROutFlag^(-1)
;	cmp	#6
;	bmi	.Less5sec	; if Ring Out Count <= 5
;.More5sec
; 	kplsound	x,ringoutcount
;
;	bra	.nosound
;.Less5sec
;	kplsound	x,ringoutless5

.nosound

.CountCheck
;	lda	KRingOutsecTm,x
;	cmp	#5
;	beq	.sound		;if 1 second past
;
;	cmp	#10
;	beq	.sound		;if 1 second past
;
;	cmp	#9
;	beq	.sound		;if 1 second past
;	cmp	#12
;	beq	.sound		;if 1 second past


;======================== Set Sprites ============================
	shorta
	longi
;====== Ring Out Time =======
.RingOutTime
	IFEQ	1
	a16
	lda	KRingOutTimer,x
	and	#$ff
	and	#KROutFlag^-1
	km_cpudivu16uf8	work,10

	a8
.1sec
;up chr
	km_SetSpriteImXY_Off	RoutTimeoffX+8,RoutTimeoffY
	lda	kamari
	km_SetSpriteChrA	ROutTMChrUp,colpal0,pri2,noflip
;down chr
	km_SetSpriteImXY_Off	RoutTimeoffX+8,RoutTimeoffY+8
	lda	kamari
	km_SetSpriteChrA	ROutTMChrDw,colpal0,pri2,noflip
;10sec
;up chr
	km_SetSpriteImXY_Off	RoutTimeoffX,RoutTimeoffY
	lda	ksyou
	km_SetSpriteChrA	ROutTmChrUp,colpal0,pri2,noflip
;down chr
	km_SetSpriteImXY_Off	RoutTimeoffX,RoutTimeoffY+8
	lda	ksyou
	km_SetSpriteChrA	ROutTmChrDw,colpal0,pri2,noflip
	ENDC

	IFEQ	1
;======= Return Ring Mes =======
	s_cmp_alvar	B,x,KRingOutSecTm,#6
	bpl	.appear
	jmp	.RingOutExit
;return chr
	ifeq	1
	SetSprSize_sub_DB
	SetSprXYChr_Im	P1RetMarkoffX,P1RetMarkoffY,ROutRetChr,colpal0,objpri2,noflip
	endc
;========== Return Mark Check ==============
.appear
	kplm_obj2field_rotY	W,x,kangle

	lda	kangle
	bpl	.plas
	jmp	.minus
.plas
	cmp	#$18
	bpl	.skip1		;0<= angle <33
	jmp	.noturnL
.skip1
	cmp	#$40		;33<= angle <90
	bpl	.skip2
	jmp	.smallturnL
.skip2
	cmp	#$60		;90<= angle <135
	bmi	.middleturnL
.bigturnL	
	SetSprXYOffChr_Im	RetMarkoffX-$30,RetMarkoffY+0,retmarkchr+0,colpal0,pri2,xflip
	SetSprXYOffChr_Im	RetMarkoffX-$30,RetMarkoffY+8,retmarkchr+0,colpal0,pri2,xyflip
.middleturnL
	SetSprXYOffChr_Im	RetMarkoffX-$28,RetMarkoffY+0,retmarkchr+0,colpal0,pri2,xflip
	SetSprXYOffChr_Im	RetMarkoffX-$28,RetMarkoffY+8,retmarkchr+0,colpal0,pri2,xyflip
.smallturnL
	SetSprXYOffChr_Im	RetMarkoffX-$20,RetMarkoffY+0,retmarkchr+0,colpal0,pri2,xflip
	SetSprXYOffChr_Im	RetMarkoffX-$20,RetMarkoffY+8,retmarkchr+0,colpal0,pri2,xyflip

	jmp	.RingOutExit
;-------------------------------------------------------------------------------------
.minus
	cmp	#$e8
	bmi	.skip3
	jmp	.noturnR
.skip3
	cmp	#$c0
	bmi	.skip4
	jmp	.smallturnR
.skip4
	cmp	#$a0
	bpl	.middleturnR
.bigturnR
	SetSprXYOffChr_Im	RetMarkoffX+$38,RetMarkoffY+0,retmarkchr+0,colpal0,pri2,noflip
	SetSprXYOffChr_Im	RetMarkoffX+$38,RetMarkoffY+8,retmarkchr+0,colpal0,pri2,yflip
.middleturnR
	SetSprXYOffChr_Im	RetMarkoffX+$30,RetMarkoffY+0,retmarkchr+0,colpal0,pri2,noflip
	SetSprXYOffChr_Im	RetMarkoffX+$30,RetMarkoffY+8,retmarkchr+0,colpal0,pri2,yflip
.smallturnR
	SetSprXYOffChr_Im	RetMarkoffX+$28,RetMarkoffY+0,retmarkchr+0,colpal0,pri2,noflip
	SetSprXYOffChr_Im	RetMarkoffX+$28,RetMarkoffY+8,retmarkchr+0,colpal0,pri2,yflip
	jmp	.RingOutExit
;-------------------------------------------------------------------------------------
.noturnL
.noturnR
	BlockTransSpritesOffset	SprModoreData
;--------------------------------------------------------------
	ENDC
.RingOutExit
	a8
	rts

;=====================================================
;*		Syoujyun Mark Set		*
;* Data Bank 7e					*
;* Xreg :player Pouinter				*
;* Yreg :sprites pointer				*
;=====================================================
SetSyoujyunMark
	shorta
	longi
;;;;;;	pl_jmpNOT_ifcockpit	x,.exit

	sp_jmpNOT_ifhudon	x,.exit

	lda	ktargetx
	sta	sprites+4,y
	sta	sprites+12,y
	sec
	sbc	#8
	sta	sprites+0,y
	sta	sprites+8,y

	lda	ktargety
	sta	sprites+9,y
	sta	sprites+13,y
	sec
	sbc	#8
	sta	sprites+1,y
	sta	sprites+5,y

	a16
	km_ldasprchr	aimbigchroff,colpal0,pri3,noflip
	sta	sprites+2,y
	km_ldasprchr	aimbigchroff,colpal0,pri3,xflip
	sta	sprites+6,y
	km_ldasprchr	aimbigchroff,colpal0,pri3,yflip
	sta	sprites+10,y
	km_ldasprchr	aimbigchroff,colpal0,pri3,xyflip
	sta	sprites+14,y

	tya
	clc
	adc	#4*4	;4 char bun no pointer idou
	tay
	a8
.exit
	rts

;=====================================================
;*		Enemy Number			*
;* Data Bank 7e					*
;* Yreg :sprites pointer				*
;* KEnemyNumber :Enemy rest Number			*
;=====================================================
;memo :ndata_ (oamdata.asm:yajima's)
;Att = 0,pri3
;------------------------------------
EnemyoffX		equ	0
EnemyoffY		equ	0
missenemyoffx	equ	$10*8-4
missenemyoffy	equ	$3*8
enemynumchr		equ	$40
;------------------------------------
SetEnemyNumber
	php
	a16
	longi
;	lda	KEnemyNumber
;	km_loba
;	km_cpudivu16uf8_work	10
	
;* 1 no kurai *
	a8
	lda	ksproffx
;	clc
;	adc	#EnemyoffX
	sta	kz_x1

	lda	ksproffy
;	clc
;	adc	#EnemyoffY
	sta	kz_x1+1

	a16
	lda	KEnemyNumber
;;;	lda	kamari
	ora	#obj_colpal2
	sta	kz_tpa
	jsr	SetSprNumber_8x16_sub

;* 10 no kurai *
;	km_substaval	kz_x1,8
;	lda	ksyou
;	ora	#obj_colpal2
;	sta	kz_tpa
;	jsr	SetSprNumber_8x16_sub

	plp
	rts

;=====================================================
;*	Set enemy player in Radar		*
;*    Player2 character in Player 1 Radar		*
;*    Player1 character in Player 2 Radar		*
;* kpx,kpy,kpz :player 2 world coordinate		*
;* Xreg :player 1 alien pointer			*
;* Yreg :sprites pointer				*
;=====================================================
;	lda	al_worldx,x
;	printh	<player1X>
;	lda	al_worldz,x
;	printh	<player1Z>
;	lda	kpx
;	printh	<player2X>
;	lda	kpz
;	printh	<player2Z>

;	lda	kz_x1
;	printh	<x zahyou>
;	lda	kz_z1
;	printh	<z zahyou>
;	lda	kz_tpx
;	printh	<abs x>
;	lda	kz_tpy
;	printh	<abs z>

	IFEQ	1
P1P2_inRadar
	a16
	longi
	s_set_objtobeplayer1	x
	km_setval	kx_radarscale,-1

	lda	kpx
	sec
	sbc	al_worldx,x
	sta	kz_x1

	lda	al_worldz,x
	sec
	sbc	kpz
	sta	kz_z1

	km_absstavar	kz_tpx,kz_x1
	km_absstavar	kz_tpy,kz_z1

;* Check Radar Scale *
	lda	#radar_max/4
	cmp	kz_tpx
	bcc	.Over_Scale1
	cmp	kz_tpy
	bcc	.Over_Scale1
	km_setval	kx_radarscale,-1	;-2
.Over_Scale1
;	lda	#(radar_max-radar_max/2)
;	cmp	kz_tpx
;	bcc	.Over_Scale2
;	cmp	kz_tpy
;	bcs	.Normal
;.Over_Scale2
;	inc	kx_radarscale
;.normal
	a8

;;;	lda	kx_radarscale
;;;	printh	radarscale

	jsr	SetRadarScale
	a16
;---- X zahyo radar in check -----
	lda	kz_x1
	km_brlareaout	kx_radarmin,kx_radarmax,.JmpOutOfRadar

;	lda	kz_x1
;	xba
;	sta	kwork		;playerX (2-1)
;	lda	kz_x1
;	nega
;	xba
;	sta	kwork+2
;---- z zahyo radar in check -----
	lda	kz_z1
	km_brlareaout	kx_radarmin,kx_radarmax,.JmpOutOfRadar

;	lda	kz_z1
;	xba
;	a8
;	sta	kwork+1		;playerZ (1-2)
;	a16
;	lda	kz_z1
;	nega
;	xba
;	a8
;	sta	kwork+3

;-------	radar height --------
;28/3/94 :takasa niyoru player no character oyobi att wo kaenai
	IFEQ	1
	a16
	lda	al_worldy,x
	sec  
	sbc	kpy

	cmp	#-mradar_hight
	bmi	.up
	cmp	#mradar_hight
	bpl	.down
.normal
	lda	#colpal1<<9
	sta	kwork+4		;p1 radar enemy col = white
	sta	kwork+6		;p2 radar enemy col = white
	bra	.player1
.up   ;p1Y higher than p2Y
	lda	#colpal2<<9
	sta	kwork+4		;p1 radar enemy col = blue
	lda	#colpal0<<9
	sta	kwork+6		;p2 radar enemy col = red 
	bra	.player1
.down ;p2Y higher than p1Y
	lda	#colpal0<<9	;p1 radar enemy col = red
	sta	kwork+4
	lda	#colpal2<<9	;p2 radar enemy col = blue
	sta	kwork+6
	bra	.player1
	ENDC
;===========  Player 1 Radar ============
.player1
	a16
	km_setval	kz_tpa,(ra_base!obj_colpal3)
	km_setval	ksproffx,(p1radoffx+p1radoffy<<8)
	jsl	SetRadarSprite_sub_l

;;;;	km_SetSpriteXY_ImOff	kwork,kwork+1,p1radoffx,p1radoffy
;;;;	SetSprCol_ImChr	EnshipChr,kwork+4,pri1,noflip
;;;;	km_SetSpriteChrVal	EnshipChr,colpal0,pri3,noflip
;===========  Player 2 ===========
.player2
	km_negstavar	kz_x1
	km_negstavar	kz_z1
	km_setval	kz_tpa,(ra_base!obj_colpal3)
	km_setval	ksproffx,(p2radoffx+p2radoffy<<8)
	jsl	SetRadarSprite_sub_l

;;	km_SetSpriteXY_ImOff	kwork+2,kwork+3,p2radoffx,p2radoffy
;;	SetSprCol_ImChr	EnshipChr,kwork+6,pri1,noflip
;;	km_SetSpriteChrVal	EnshipChr,colpal0,pri3,noflip
	a8

.exit
.JmpOutOfRadar
	a8
	rts
	ENDC


;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
	IFEQ	1
	s_set_objtobeplayer1	x
	stz	kwork+2
	stz	kwork+6
;*  rerative X zahyou *
	lda	kpx
	sec
	sbc	al_worldx,x
	sta	kwork
	sta	kz_x1
	sbc	#0
	sta	kwork+2

	lda	kwork+0
	clc
	adc	#(radar_max/4)&WM
	sta	kwork+0
	lda	kwork+2
	adc	#(radar_max/4)>>16
	sta	kwork+2

;*  rerative Z zahyou *
	lda	al_worldz,x
	sec
	sbc	kpz
	sta	kwork+4
	sbc	#0
	sta	kwork+6
	sta	kz_z1

	lda	kwork+4
	clc
	adc	#(radar_max/4)&WM
	sta	kwork+4
	lda	kwork+6
	adc	#(radar_max/4)>>16
	sta	kwork+6

;* radar scale *
	km_setval	kx_radarscale,-2
	lda	#(radar_max/4*2)&WM
	sta	kwork+8
	lda	#(radar_max/4*2)>>16
	sta	kwork+10

;* Radar Area IN Check *
	lda	kwork+2
	bmi	.BigRange
	lda	kwork
	sec
	sbc	kwork+8
	lda	kwork+2
	sbc	kwork+10
	bmi	.Skip
.BigRange
	km_setval	kx_radarscale,2
.Skip
	ENDC
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------

;=====================================================================
;*		GAME Timer Display				*
;* Yreg :spr pointer							*
;=====================================================================
SprGameTimer_l
	php
	a16
	longi

	PHX
	lda	kx_TotalTime	;'94/9/8 :kw_GameTimer
	km_stxval	kz_x2,4	;ketasuu
	jsr	convHextoDecimal

	ldx	#3
	lda	#$16*8+($2*8)<<8
	sta	kz_x1
.loop
	km_loblda	kx_DecimalBuffer,x
	sta	kz_tpa
	jsr	SetSprNumber_8x16_sub

	km_substaval	kz_x1,8
	dex
	bpl	.loop

	PLX
	plp
	rtl
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
	IFEQ	1
;* 100 second timer *
	phy
	lda	kw_Gametimer	;'94/9/8 :kw_GameTimer
	bpl	.skip
	lda	#0		;moshi MINUS TIME ni nattara 0 ni suru
.skip
	km_cpudivu16uf8_xy	100
	stx	kwork+0		;X (syou)
	tya			;Y (amari)
	km_cpudivu16uf8_work	10
				;ksyou	;10 sec
				;kamari	:01 sec
	ply
;1 seconds
	lda	#$16*8+($2*8)<<8
	sta	kz_x1
	lda	kamari
	sta	kz_tpa
	jsr	SetSprBigNumber

;10 seconds
	km_substaval	kz_x1,8
	lda	ksyou
	sta	kz_tpa
	jsr	SetSprBigNumber

;100 seconds
	km_substaval	kz_x1,8
	lda	kwork+0
	sta	kz_tpa
	jsr	SetSprBigNumber


	plp
	rtl

	ENDC
;****************************************************************************
;****************************************************************************
;****************************************************************************
;'94/9/2 ni syoukyo
	IFEQ	1
;========= Semicolon Flashing Check ======
	lda	SecondTimer
	cmp	#(second+1)/2	;8
	bpl	.SetNoFlash
.SetFlash
	SetSprXYChr_Im		SprSmcolOffX,SprTmOffY,SprSmFlChr,colpal0,pri3,noflip
	jmp	.TimeSet

.SetNoFlash
	SetSprXYChr_Im		SprSmcolOffX,SprTmOffY,SprSmNfChr,colpal0,pri3,noflip

;======= Time Change ======================
.TimeSet
	a16
	phy
;-------- Convert 60 Min&60 sec --------
	lda	kw_GameTimer
	bpl	.skip
	lda	#0		;moshi MINUS TIME ni nattara 0 ni suru
.skip
	km_cpudivu16uf8	xy,60
	stx	kwork+0		;X (syou)
	tya			;Y (amari)
	km_cpudivu16uf8	work,10
				;ksyou	;10 sec
				;kamari	:01 sec
	ply
;1 seconds
	km_SetSpriteImXY	SprS01TmOffX,SprTmOffY
	lda	kamari
	km_SetSpriteChrA	SprTimeChr,colpal0,pri3,noflip

;	lda	kamari
;	cmp	#9
;	beq	.Set10sec	;If 10 sec set
;	jmp	.TimerSetEnd
;10 seconds
.Set10sec
	km_SetSpriteImXY	SprS10TmOffX,SprTmOffY

	lda	ksyou
	km_SetSpriteChrA	SprTimeChr,colpal0,3,0

;	lda	ksyou
;	cmp	#5
;	beq	.Set01min	;If 01 min set
;	jmp	.TimerSetEnd
.Set01min
	lda	kwork+0
	km_cpudivu16uf8	work,10
				;ksyou	;10 min
				;kamari	:01 min
;1 minutes
	km_SetSpriteImXY	SprM01TmOffX,SprTmOffY
	lda	kamari
	km_SetSpriteChrA	SprTimeChr,colpal0,3,0

;	lda	kamari
;	cmp	#9
;	beq	.Set10min
;	jmp	.TimerSetEnd
.Set10min
;10 minutes
	km_SetSpriteImXY	SprM10TmOffX,SprTmOffY
	lda	ksyou
	km_SetSpriteChrA	SprTimeChr,colpal0,3,0
.TimerSetEnd
	a8
	ENDC




;*********************************************************************
;*								*
;*		Mission Player Select Sprites			*
;* mem8,idx16				 [Mission Player Select]*
;* Data Bank:7e							*
;*********************************************************************
Sprites_selectmissionplayer_l
	shorta
	longi
	IFEQ	1
;---------------------------------------------------------------------
;**** Player 1 ****
	km_bitcheckmisplflag	config
	km_bne	.noplayer1

	lda	bps_keyptr1
	cmp	#$ff
	km_beq	.noplayer1
	sta	keyptr		;KEY POINTER
	lda	#cursoroffp1x_bps
	sta	bps_ksproffx	;X zahyou
	lda	#cursoroffp1y_bps
	sta	bps_ksproffy	;Y zahyou
	lda	#$84
	sta	bps_ksprchr

;* player select cursor *
;	km_blocktrans	bps_OKflag1,bps_OKflag,12
;	jsr	bps_sprcursor	;[select cursor]
;	km_blocktrans	bps_OKflag,bps_OKflag1,12
.noplayer1
;---------------------------------------------------------------------
;**** Player 2 ****
	lda	bps_keyptr2
	cmp	#$ff
	km_beq	.noplayer2
	sta	keyptr
	lda	bps_OKflag2
	sta	bps_OKflag
	lda	#cursoroffp2x_bps
	sta	bps_ksproffx
	lda	#cursoroffp2y_bps
	sta	bps_ksproffy
	lda	#$82
	sta	bps_ksprchr

	km_blocktrans	bps_OKflag2,bps_OKflag,12
;* player select cursor *
	jsr	bps_sprcursor		;[select cursor]

;* player OBJ *

	km_blocktrans	bps_OKflag,bps_OKflag2,12
.noplayer2


	ENDC
;---------------------------------------------------------------------
	jsl	pselect_l
;---------------------------------------------------------------------
	sty	sprpointer
	rts


;*********************************************************************
;*								*
;*		Battle Player Select Sprites			*
;* mem8,idx16				 [Battle Player Select] *
;* Data Bank:7e							*
;*********************************************************************
Sprites_selectbattleplayer_l
	shorta
	longi
	IFEQ	1
;---------------------------------------------------------------------
;**** Player 1 ****
	lda	bps_keyptr1
	cmp	#$ff
	km_beq	.noplayer1
	sta	keyptr
	lda	#cursoroffp1x_bps
	sta	bps_ksproffx
	lda	#cursoroffp1y_bps
	sta	bps_ksproffy
	lda	#$8c
	sta	bps_ksprchr
	km_blocktrans	bps_OKflag1,bps_OKflag,12
;* player select cursor *
	jsr	bps_sprcursor		;[select cursor]
;* player OBJ *
	jsr	bps_arwing		;[arwing]
	jsr	bps_pilot		;[pilot]
	jsr	bps_boost		;[boost]

	km_blocktrans	bps_OKflag,bps_OKflag1,12
.noplayer1
;---------------------------------------------------------------------
;**** Player 2 ****
	lda	bps_keyptr2
	cmp	#$ff
	km_beq	.noplayer2
	sta	keyptr
	lda	bps_OKflag2
	sta	bps_OKflag
	lda	#cursoroffp2x_bps
	sta	bps_ksproffx
	lda	#cursoroffp2y_bps
	sta	bps_ksproffy
	lda	#$8e
	sta	bps_ksprchr

	km_blocktrans	bps_OKflag2,bps_OKflag,12
;* player select cursor *
	jsr	bps_sprcursor		;[select cursor]
;* player OBJ *
	jsr	bps_arwing		;[arwing]
	jsr	bps_pilot		;[pilot]
	jsr	bps_boost		;[boost]

	km_blocktrans	bps_OKflag,bps_OKflag2,12
.noplayer2
;---------------------------------------------------------------------
	ENDC
	sty	sprpointer
	rts

;=====================================================================
;*		cursor Display		[battle player select]	*
;* mem8 idx16							*
;* data bank 7e							*
;=====================================================================
cursoroffp1x_bps	equ	$8*8+8
cursoroffp1y_bps	equ	$c*8-3
cursoroffp2x_bps	equ	$7*8+8
cursoroffp2y_bps	equ	$f*8+3
;----------------------------------------
bps_sprcursor
	shorta
	longi
	IFEQ	1
;bfs_cursortm :ue 4bit ha 5flame ni 1 kai timer,shita 4bit ha pattern pointer 
;* Color Chang Timer *
	lda	bps_cursortm
	clc
	adc	#%00010000
	and	#%01110011
	sta	bps_cursortm
	and	#%01110000	;5 flame ni 1 kai flash pattern wo kaeru
	cmp	#%01010000
	bne	.nochange1	;moshi color wo kaeru nara

	lda	bps_cursortm
	and	#%00001111
	inc	a
	cmp	#3
	bne	.set1
	lda	#0
.set1	sta	bps_cursortm	;0,1,2
.nochange1
;----------------------------------------------------------------------
	km_SetSpriteSizeDouble

	km_bitcheckflag	bps_OKflag,fbfs_ok
	beq	.NOK
.OK
	lda	#$15*8
	km_SetSpriteX
	bra	.SetYpostion	
.NOK
	km_lldx	keyptr
	lda.l	bpscursorXpostbl,x
	clc
	adc	bps_ksproffx
	km_SetSprite
.SetYpostion
	sta	kwork+2		;X postion Keep
	km_SetSpriteY	bps_ksproffy

.SetCharacter
	a16
	lda	bps_cursortm
	and	#%00000011
	asl	a
	tax				;colour flashing pointer
	lda	bps_ksprchr
	and	#$ff
	ora.l	bpscursorflashtbl,x
	sta	kwork

	km_bitcheckgameflag	battle
	beq	.nohosei
	km_addval	kwork,((_obj_cgx-mp_obj_cgx)>>6)
.nohosei
	lda	kwork
	km_SetSpriteChrCol	0,pri3,noflip,mp_obj_offset

;* shita selct cursor *

	ifeq	1
	km_SetSpriteSizeDouble
	a8
	lda	bps_ksproffy
	clc
	adc	#$1e
	xba
	clc
	adc	kwork+2
	a16
	km_setspriteXY
	lda	kwork
	km_SetSpriteChrCol	0,pri3,noflip,mp_obj_offset
	endc

	a8
;----------------------------------------------------------------------
	ENDC
	rts

	IFEQ	1
bpscursorXpostbl
	db	00*8	
	db	02*8	
	db	04*8	
	db	06*8	
	db	08*8	
	db	10*8	
	db	12*8	

bpscursorflashtbl
	dw	obj_colpal0
	dw	obj_colpal2
	dw	obj_colpal3

	ENDC
;=====================================================================
;*			ARWING Display				*
;* Data Bank :7e							*
;* Xreg :Data Table Pointer						*
;* Yreg :Sprites Pointer						*
;=====================================================================
bps_aroffx	equ	$c0
bps_aroffy	equ	$44
;--------------------------------------------------------------------
bps_arwing
	shorta
	longi
	rts

	IFEQ	1
	km_incptr	B,bps_arwingvelxptr,#(bps_arveltblxEND-bps_arveltblx)/2
	km_ldaslx  bps_arwingvelxptr
	lda.l	bps_arveltblx,x
	stz	bps_arwingvelx

	km_incptr	B,bps_arwingvelyptr,#(bps_arveltblyEND-bps_arveltbly)/2
	km_ldaslx  bps_arwingvelyptr
	lda.l	bps_arveltbly,x
	sta	bps_arwingvely

	lda	bps_arwingoffx
	clc
	adc	bps_arwingvelx
	sta	bps_arwingoffx

	lda	bps_arwingoffy
	clc
	adc	bps_arwingvely
	sta	bps_arwingoffy


	km_ldaslx	keyptr
	a16
	lda.l	ArwingOAMData,x
	tax
	a8
	BlockCopySprOffBig	ArwingOAMData,bps_arwingoffx,bps_arwingoffy
	rts

bps_arveltblX
	db	02,02,02,02
	db	01,01,01,01,01,01,01,01
	db	01,01,01,01,01,01,01,01

	db	-1,-1,-1,-1,-1,-1,-1,-1
	db	-1,-1,-1,-1,-1,-1,-1,-1
	db	-2,-2,-2,-2
	db	-2,-2,-2,-2
	db	-1,-1,-1,-1,-1,-1,-1,-1
	db	-1,-1,-1,-1,-1,-1,-1,-1

	db	01,01,01,01,01,01,01,01
	db	01,01,01,01,01,01,01,01
	db	02,02,02,02
bps_arveltblXEND

bps_arveltbly
	dw	01,01,01,01,01,00,01,00
	dw	-1,00,-1,00,-1,-1,-1,-1
	dw	-1,-1,-1,-1,-1,-0,-1,-0
	dw	01,00,01,00,01,01,01,01
bps_arveltblyEND

	ENDC
;=====================================================================
;*		Arwing Boost Animation				*
;=====================================================================
bps_boost
	shorta
	longi
;* Boost Animation Pointer Set *

	lda	bps_boostptr
	inc	a
	and	#3
	sta	bps_boostptr
	km_lldx	bps_boostptr

	lda.l	boostchrtbl,x
	sta	kwork

;Set Sprites *
	km_SetSpriteSizeDouble_l

	km_lldx	keyptr
;* X zahyou *
	lda	bps_arwingoffx
	clc
	adc	#12
	clc
	adc.l	boostposhoseiX,x
	sta	bps_boostoffx
	km_SetSpriteX
;* Y zahyou *
	lda	bps_arwingoffy
	clc
	adc	#$fc
	clc
	adc.l	boostposhoseiY,x
	sta	bps_boostoffy
	km_SetSpriteY

	lda	kwork
	km_SetSpriteChrA	0,colpal3,pri3,noflip

	rts
boostposhoseiX
	db	0,0,12,12,7,7
boostposhoseiY
	db	0,0,0,0,-6,-6
boostchrtbl
	db	0,2,4,6
;=====================================================================
;*			Pilot Display				*
;* Data Bank :7e							*
;* Yreg :Sprites Pointer						*
;=====================================================================
bps_pltoffx	equ	-8		;arwing tono Xpostion syusei
bps_pltoffy	equ	-$10		;arwing tono Ypostion syusei

pilotFox	equ	$0a0
pilotFalco	equ	$0b5
pilotPeppy	equ	$100
pilotSlippy	equ	$130
;------------------------------------------
bps_pilot
	rts

	IFEQ	1
	shorta
	longi

	km_ldaslx	keyptr

	lda	bps_arwingoffx
 	clc
	adc.l	pilotsyuseitbl,x
	sta	bps_pilotoffx

	lda	bps_arwingoffy
 	clc
	adc.l	pilotsyuseitbl+1,x
	sta	bps_pilotoffy

	a16
	lda.l	PilotOAMData,x
	tax
	a8
	BlockCopySprOff	PilotOAMData,bps_pilotoffx,bps_pilotoffy

	ifeq	1
	lda	bps_pilotmovptr
	inc	a
	cmp	#(bps_pilottblEND-bps_pilottbl)/2
	bne	.set
	lda	#0
.set	sta	bps_pilotmovptr
	endc
	rts

pilotsyuseitbl
	db	bps_pltoffx+0,bps_pltoffy+0
	db	bps_pltoffx+0,bps_pltoffy+0
	db	bps_pltoffx-8,bps_pltoffy-4
	db	bps_pltoffx-8,bps_pltoffy-4
	db	bps_pltoffx+0,bps_pltoffy+0
	db	bps_pltoffx+0,bps_pltoffy+0

	ENDC

;*********************************************************************
;*								*
;*		Battle Field Select Sprites			*
;* mem8,idx16				  [Battle Field Select] *
;* Data Bank:7e							*
;*********************************************************************
Sprites_selectbattlefield_l
	shorta
	longi
	IFEQ	1
;---------------------------------------------------------------------------
	jsr	sprcursor_bfs	;Map select cursor
	jsr	sprturnarwing	;MAP no mawari wo tonndeiru.
	jsr	sprOKmes_bfs	;MAP select OK
;---------------------------------------------------------------------------
;;;;	BlockTransSPrites	TestSPrData
	a8
;------------------------------------------------------------------------
	sty	sprpointer
	ENDC
	rts

;=====================================================================
;*			OK message display			*
;* Data Bank 7e							*
;* Yreg sprites pointer						*
;=====================================================================
	IFEQ	1
SprOKMes_BFS
	shorta
	longi

 	lda	bfs_OKflag
	and	#fbfs_ok
	bne	.pushA		;message display ON dattara
	jmp	.end
.pushA
 	lda	bfs_OKflag
	and	#fbfs_OKptrmax
	cmp	#fbfs_OKInitptr
 	beq	.init
	cmp	#fbfs_OKanmptr
	beq	.anime
	cmp	#fbfs_OKflashptr
	beq	.flash
	cmp	#fbfs_OKcancelptr
	beq	.OK_cancel
	jmp	.end
;----------------------------------------------------------------------
.init	;[init aicon]
	lda	#fbfs_okanmopentm
	sta	bfs_okanmtm
	stz	bfs_okanmptr

	inc	bfs_OKflag
;----------------------------------------------------------------------
.anime	;[open aicon]
	lda	bfs_okanmtm
	beq	.anmchange
	dec	a
	sta	bfs_okanmtm
	bra	.setsprites
.anmchange
;timer = 0
	lda	#fbfs_okanmopentm
	sta	bfs_okanmtm

	lda	bfs_OKanmptr
	inc	a
	sta	bfs_OKanmptr
	cmp	#fbfs_OKAnmPatNumber
	bne	.setsprites
	lda	bfs_OKflag
	inc	a
	and	#(fbfs_buttondisable)^-1
	sta	bfs_OKflag
;----------------------------------------------------------------------
.flash	;[flash aicon]
	lda	bfs_okanmtm
	beq	.skip2
	dec	a
	sta	bfs_okanmtm
	bra	.setsprites
.skip2
	lda	#fbfs_OKflashTM
	sta	bfs_okanmtm

	lda	bfs_OKanmptr
	and	#$f
	cmp	#3
	beq	.flash2
.flash1
	and	#%11110000
	ora	#3
	sta	bfs_OKanmptr
	bra	.setsprites
.flash2
	and	#%11110000
	ora	#4
	sta	bfs_OKanmptr
	bra	.setsprites
;----------------------------------------------------------------------
.OK_cancel	;[close aicon]
	lda	bfs_okanmtm
	beq	.patternchange2
	dec	a
	sta	bfs_okanmtm
	bra	.setsprites
.patternchange2
	lda	#fbfs_okanmclosetm
	sta	bfs_okanmtm

	lda	bfs_OKanmptr
	dec	a
	sta	bfs_OKanmptr
	cmp	#0
	bne	.setsprites
;* OK cancell Flag Set *
	km_setflag	bfs_OKflag,fbfs_cancel		;Cancell Flag ON
;----------------------------------------------------------------------
.setsprites
	jsr	sprok_bfs_sub
;---------------------------------------------------------------------
.end
	i16
	rts
;=====================================================================
;*		Dsiplay OK message sub routine			*
;=====================================================================
sprok_bfs_sub
	shorta
	longi

	km_lldx	key_tateptr1
	lda.l	bfs_OKYposHosei,x
	sta	kwork

	km_lldx	bfs_okanmptr
	lda.l	bfs_sprOKchrval
	km_ppumults15s7	x

	lda.l	bfs_sprOKchrval
	sta	kcounter
;---- x zahyo ---
.loop
	lda.l	bfs_sprOKchrdata+0,x
	km_SetSprite
;--- y zahyo ----
	lda.l	bfs_sprOKchrdata+1,x
	clc
	adc	kwork
	km_SetSprite
;--- character ----
	a16
	lda.l	bfs_sprOKchrdata+2,x
	km_SetSprite

	txa
	clc
	adc	#4
	tax

	a8
	lda	kcounter
	sec
	sbc	#4
	sta	kcounter
	bne	.loop
	rts
;=====================================================================
;*		Map Course Select cursor			*
;* Data Bank 7e							*
;* Yreg sprites pointer						*
;=====================================================================
cursoroffx_bfs	equ	2*8
cursoroffy_bfs	equ	7*8-1

sprcursor_bfs
	shorta
	longi
;bfs_cursortm :ue 4bit ha 5flame ni 1 kai timer,shita 4bit ha pattern pointer 
	lda	bfs_cursortm
	clc
	adc	#$10
	and	#%01110011
	sta	bfs_cursortm
	and	#%01110000	;5 flame ni 1 kai flash pattern wo kaeru
	cmp	#%01010000
	bne	.nochange1

	lda	bfs_cursortm
	and	#%00001111
	inc	a
	cmp	#3
	bne	.set1
	lda	#0
.set1
	sta	bfs_cursortm
.nochange1
;----------------------------------------------------------------------
	lda	bfs_cursortm
	and	#3
	cmp	#2
	bne	.patternUL
	jmp	.noset
;----------------------------------------------------------------------
.patternUL
	km_lldx	key_tateptr1
	km_SetSprite	#cursoroffx_bfs
	lda.l	bfscursorYpostbl,x
	clc
	adc	#cursoroffy_bfs
	km_SetSprite

	lda	bfs_cursortm
	and	#1
	sta	kwork
	km_SetSpriteChrA	$cc,colpal3,pri3,noflip
;----------------------------------------------------------------------
.patternUR
	km_SetSprite	#cursoroffx_bfs+8
	lda.l	bfscursorYpostbl,x
	clc
	adc	#cursoroffy_bfs
	km_SetSprite
	lda	kwork
	km_SetSpriteChrA	$cc,colpal3,pri3,xflip
;----------------------------------------------------------------------
.patternDL
	km_SetSprite	#cursoroffx_bfs
	lda.l	bfscursorYpostbl,x
	clc
	adc	#cursoroffy_bfs+$18
	km_SetSprite
	lda	kwork
	km_SetSpriteChrA	$cc,colpal3,pri3,yflip
;----------------------------------------------------------------------
.patternDR
	km_SetSprite	#cursoroffx_bfs+8
	lda.l	bfscursorYpostbl,x
	clc
	adc	#cursoroffy_bfs+$18
	km_SetSprite
	lda	kwork
	km_SetSpriteChrA	$cc,colpal3,pri3,xyflip
;----------------------------------------------------------------------
.noset
	rts

bfs_OKYposHosei
bfscursorYpostbl
	db	00*8	
	db	05*8
	db	10*8	
	db	15*8	

;=====================================================================
;*		Arwing turn around select map	[MAIN]		*
;* Data Bank 7e							*
;* Yreg :sprites pointer						*
;*								*
;=====================================================================
sprturnarwing
	shorta
	longi
;--------------------------------------------------------------------
;* arwing bnoost animation *
	jsr	SetBoostAinmPointer	;[animation]
;--------------------------------------------------------------------
;* awing 1 *
	a16
	lda	rarwingx1
	sta	rarwingx	;(x,y)
	lda	rarwingptr1
	sta	rarwingmvptr	;move sequence pointer
	a8

	jsr	turnarwingmove	;[move]
	jsr	SetSprTArwing	;[sprites]

	a16
	lda	rarwingx
	sta	rarwingx1	;(x,y)
	lda	rarwingmvptr
	sta	rarwingptr1	;move sequence pointer
	a8
;--------------------------------------------------------------------
;* awing 2 *
	a16
	lda	rarwingx2
	sta	rarwingx	;(x,y)
	lda	rarwingptr2
	sta	rarwingmvptr	;move sequence pointer
	a8

	jsr	turnarwingmove	;[move]
	jsr	SetSprTArwing	;[sprites]

	a16
	lda	rarwingx
	sta	rarwingx2	;(x,y)
	lda	rarwingmvptr
	sta	rarwingptr2	;move sequence pointer
	a8
;--------------------------------------------------------------------
.exit
	rts
;=====================================================================
;*								*
;*		Arwing BOOST Animation		[Animation]	*
;*								*
;=====================================================================
;---------------------------------------------------------------------
;boostanmfl  (xalc) :1 byte
;b0-b1 :Boost Animation Pointer	(0-3)pattern
;b4-b5 :animation timer		4 game flame ni 1kai kaeru
;---------------------------------------------------------------------
SetBoostAinmPointer
	shorta
	longi

	PHB
	db7e
;******  boost animation *********
;* anim timer check*
	lda	boostanmfl
	clc
	adc	#%00010000
	and	#%00110011
	sta	boostanmfl
	and	#%00110000
	bne	.exit	;4 flame ni 1 kai animation wo kaeru
;* anim pointer change *
	km_incptr	B,boostanmfl,#3

;---------------------------------------------------------------------
.exit
	PLB
	rts

;=====================================================================
;*		Set Small Arwing	[Set Sprites]		*
;* data bank 7e							*
;* a8i16								*
;* rarwingx		;arwing base postion X (1 byte)			*
;* rarwingy		;arwing base postion Y (1 byte)			*
;* rarwingptr	;arwing base character pointer (1 byte)		*
;=====================================================================
;----------------------------------------------------------------------------
;arwingchrtabl no naiyou	(6 byte /1unit)
	;DW	:(X,Y)front arwing hos hosei
	;DW	:back arwing chara No + Att
	;DW	:front arwing chara No + Att
;----------------------------------------------------------------------------
SetSprTArwing
	shorta
	longi

	phb
	db7e

	km_multvar6	rarwingptr,x
;back arwing set
	a16
	km_SetSpriteXY	rarwingx

	lda	boostanmfl
	and	#3
	clc
	adc.l	arwingchrtabl+2,x
	km_setsprite
;front arwing set
	lda	rarwingx
	clc
	adc.l	arwingchrtabl+0,x
	km_SetSpriteXY

	lda.l	arwingchrtabl+4,x
	km_setsprite
	a8

	plb
	rts
;----------------------------------------------------------------------------
arwingchrtabl
rarwingpos	equ	8
;* migi *
	db		rarwingpos,0	;migi
	SprChrDataB	$c1,colpal3,pri3,xflip
	SprChrDataB	$c0,colpal3,pri3,xflip
;* hidari *
	db		-rarwingpos,0	;hidari
	SprChrDataB	$c1,colpal3,pri3,noflip
	SprChrDataB	$c0,colpal3,pri3,noflip
;* shita *
	db		0,rarwingpos	;shita
	SprChrDataB	$c5,colpal3,pri3,noflip
	SprChrDataB	$c4,colpal3,pri3,noflip
;* ue *
	db		0,-rarwingpos	;ue
	SprChrDataB	$c5,colpal3,pri3,yflip
	SprChrDataB	$c4,colpal3,pri3,yflip

;=====================================================================
;*		Turn Arwing sequence 			[MOVE]	*
;* input,output :							*
;*	   :rarwingptr:(ue,shita,migi,hidari) no chr pointer	*
;*	   :rarwingx						*
;*	   :rarwingy						*
;*	   ;rarwingmvtm						*
;*         (moshi timer = 0 ni nattara arwing no idouhoukou wo kaeru)*
;=====================================================================
turnarwingmove
	shorta
	longi
	phb
	db7e

	lda	rarwingmvtm	;arwing move timer = 0 ?
	beq	.resettimer
	dec	a
	sta	rarwingmvtm

	km_multvar6	rarwingmvptr,x
	bra	.rarwingmove
;----------------------------------------------------------------------
;moshi timer = 0 ni nattara kokoni kuru
.resettimer
	km_incptr	B,rarwingmvptr,#4
	km_multvar6	rarwingmvptr,x

	lda.l	rarwinglocustbl+0,x
	sta	rarwingmvtm		;move timer reset

	a16
	lda.l	rarwinglocustbl+1,x
	clc
	adc	rarwinghosx
	sta	rarwingx
	a8
.rarwingmove
	a16
	lda.l	rarwinglocustbl+3,x
	sta	rarwingmvx		;move speed
	a8
	lda.l	rarwinglocustbl+5,x
	sta	rarwingptr		;move direction
;---------------------------------------------------------------------------
;arwing base
	lda	rarwingx
	clc
	adc	rarwingmvx
	sta	rarwingx

	lda	rarwingy
	clc
	adc	rarwingmvy
	sta	rarwingy

	plb
	rts
;=====================================================================
;*			Table Data				*
;=====================================================================
rarwinglocustbl
;---------------------------------------------------------------------
rarwingspeedh	equ	2	;2(arimoto),3(yamada)
rarwingspeedv	equ	2	;2(arimoto),2(yamada)

rarwinghcnt	equ	17*8
rarwingvcnt	equ	4*8
;---------------------------------------------------------------------
	db	rarwinghcnt/rarwingspeedh	;0:counter
	db	4*8				;1:init pos x
	db	6*8				;2:init pos y
	db	rarwingspeedh			;3:speed X
	db	0				;4:speed Y
	db	0				;5:direction

	db	rarwingvcnt/rarwingspeedv
	db	$16*8				;1:init pos x
	db	6*8				;2:init pos y
	db	0
	db	rarwingspeedv
	db	2

	db	rarwinghcnt/rarwingspeedh
	db	$16*8				;1:init pos x
	db	$0b*8-1				;2:init pos y
	db	-rarwingspeedh
	db	0
	db	1

	db	rarwingvcnt/rarwingspeedv
	db	04*8				;1:init pos x
	db	$0b*8				;2:init pos y
	db	0
	db	-rarwingspeedv
	db	3

	ENDC
;*********************************************************************
;*								*
;*
;*								*
;*********************************************************************
	ifeq	1
;******  boost animation flame  *********
	lda	rarwinganmfl
	clc
	adc	#$10
	and	#%00110011
	sta	rarwinganmfl
	and	#%00110000	;4 flame ni 1 kai animation wo kaeru
	bne	.nochange

	lda	rarwinganmfl
	inc	a
	cmp	#3
	bne	.anmflameset
	lda	#0
.anmflameset
	sta	rarwinganmfl	;boost patern wo kaeru
.nochange
;--------------------------------------------------------------------
;key check
	km_bitcheckflag	autotrig,triggerflag
	beq	.skip	;moshi trigger flag ga tatte inakattara
	km_bitcheckflag	autotrig,padl_UD
	beq	.skip	;moshi ue shita no key wo oshite inakattara

;moshi key (up down) wo oshite itara arwing no postion idou
	jsl	Init_fieldselsprites_l
.skip
;--------------------------------------------------------------------
;arwing 1 set
	a16
	lda	rarwingx1
	sta	rarwingx
	lda	rarwingptr1
	sta	rarwingptr
	a8

	jsr	turnarwing_sub

	a16
	lda	rarwingx
	sta	rarwingx1
	lda	rarwingptr
	sta	rarwingptr1
;arwing 2 set
	lda	rarwingx2
	sta	rarwingx
	lda	rarwingptr2
	sta	rarwingptr
	a8

	jsr	turnarwing_sub

	a16
	lda	rarwingx
	sta	rarwingx2
	lda	rarwingptr
	sta	rarwingptr2
	a8
	rts
;=====================================================================
;*		Arwing turn around select map subroutine	*
;=====================================================================
;---------------------------------------------------------------------
rarwingspeedh	equ	2	;2(arimoto),3(yamada)
rarwingspeedv	equ	2	;2(arimoto),2(yamada)

rarwinghcnt	equ	17*8
rarwingvcnt	equ	4*8
rarwingpos	equ	8
;---------------------------------------------------------------------
turnarwing_sub
	shorta
	longi

	lda	#0
	xba

	lda	rarwingptr
	km_multa8
	clc
	adc	rarwingptr
	tax

	lda	rarwingtm	;arwing move timer = 0 ?
	bne	.rarwingmove

.resettimer	lda.l	rarwinglocustbl+3,x
	clc
	adc	rarwingx
	sta	rarwingx		; X zahyou hosei

	lda.l	rarwinglocustbl+4,x
	clc
	adc	rarwingy
	sta	rarwingy		;Y zahyou hosei

	lda	rarwingptr
	inc	a
	and	#3
	sta	rarwingptr
	km_multa8
	clc
	adc	rarwingptr	;*9 (9 bai)
	tax
	lda.l	rarwinglocustbl+0,x
	sta	rarwingtm

.rarwingmove
	a16
	lda.l	rarwinglocustbl+1,x
	sta	rarwingmvx
	lda.l	rarwinglocustbl+3,x
	sta	rarwinghosx
	lda.l	rarwinglocustbl+5,x
	sta	rarwingbase1
	lda.l	rarwinglocustbl+7,x
	sta	rarwingbase2
	a8
;----------------------------------------------------
;back arwing set
	lda	rarwingx
	clc
	adc	rarwingmvx
	sta	rarwingx
	sta	sprites,y
	iny

	km_ldx	key_tateptr1

	lda	rarwingy
	clc
	adc	rarwingmvy
	sta	rarwingy
	clc
	adc.l	yhoseitbl,x
	sta	sprites,y
	iny
	
	a16
	lda	rarwinganmfl
	and	#3
	clc
	adc	rarwingbase1
	sta	sprites,y
	a8
	iny
	iny
;---------------------------------------------------------------------------
;front arwing set
	lda	rarwinghosx
	clc
	adc	rarwingx
	sta	sprites,y
	iny

	lda	rarwinghosy
	clc
	adc	rarwingy
	clc
	adc.l	yhoseitbl,x
	sta	sprites,y
	iny

	a16
	lda	rarwingbase2
	sta	sprites,y
	a8
	iny
	iny

	dec	rarwingtm
	rts
;-------------------------------------------------------------------
rarwinglocustbl
	db		rarwinghcnt/rarwingspeedh	;1 byte
	db		rarwingspeedh,0			;2 byte
	db		rarwingpos,0			;2 byte
	SprChrDataB	$c1,colpal3,pri3,xflip		;2 byte
	SprChrDataB	$c0,colpal3,pri3,xflip		;2 byte

	db		rarwingvcnt/rarwingspeedv
	db		0,rarwingspeedv
	db		0,rarwingpos
	SprChrDataB	$c5,colpal3,pri3,noflip
	SprChrDataB	$c4,colpal3,pri3,noflip

	db		rarwinghcnt/rarwingspeedh
	db		-rarwingspeedh,00
	db		-rarwingpos,0
	SprChrDataB	$c1,colpal3,pri3,noflip
	SprChrDataB	$c0,colpal3,pri3,noflip

	db		rarwingvcnt/rarwingspeedv
	db		0,-rarwingspeedv
	db		0,-rarwingpos
	SprChrDataB	$c5,colpal3,pri3,yflip
	SprChrDataB	$c4,colpal3,pri3,yflip
;----------------------------------------------------------------------
yhoseitbl
	db	$00
	db	$28
	db	$50
	db	$78


	endc
;*********************************************************************
;*								*
;*			Soft Ware Sprites			*
;* Data Bank 7e							*
;*********************************************************************
;=============================================================
;*			Wave				*
;* Init Mode :a16i16						*
;* Exit Mode :a8i16						*
;* Data Bank :7e						*
;* X register:table pointer					*
;=============================================================
draw_Wave_p1_l
	ifeq	1
	php
	phb
	db7e
;===== Anim Flame Calculate ======
	ai16
	lda	ksws_wavetimer
	inc	a
	cmp	#6
	bmi	.skip1
	lda	#0
.skip1
	sta	ksws_wavetimer
;===== move timer ======
	lda	ksws_wavemovtimer
	clc
	adc	#1
	cmp	#$38
	bne	.skip2
	lda	#0
.skip2
	sta	ksws_wavemovtimer
;===== Set Soft Ware Sprites Parameter ======
	ldx	#0
	lda.l	sws_wavetable_pos,x
Set_wave
; (X,Y) zahyou
	sta.l	m_xc		;x zahyo
	inx
	inx

	lda.l	sws_wavetable_pos,x
	clc
	adc	ksws_wavemovtimer
	sta.l	m_yc		;y zahyo

	inx
	inx
	txa
	sta	kswspointer	;data pointer keep
; picture pointer
	lda	ksws_wavetimer
	asl	a
	tax
	lda.l	sws_wavetable_anm,x
;	lda.l	sws_thundertable_anm,x
;	lda	#test5_spr&WM
	sta.l	msprite		;soft ware sprite name
; sprites size
	lda	#32
	sta.l	m_sprsize  	;source size (8*8,16*16,32*32,64*64)
	lda	#32
	sta.l	m_sprxscale	;dest   size (8*8,16*16,32*32,64*64)

	lda	#0
	sta.l	mspr_pal

	call_mario	musprite

;===== Set End Check =====
	ldx	kswspointer
	lda.l	sws_wavetable_pos,x
	bmi	.exit
	jmp	Set_wave
.exit
	a8
	plb
	plp
	endc
	rtl

	ifeq	1
sws_wavetable_pos
	dw	$10,$28	;1
	dw	$30,$28	;2
	dw	$50,$28	;3
	dw	$70,$28	;4
	dw	$90,$28	;5
	dw	$b0,$28	;6
	dw	$ffff	;endcode

sws_wavetable_anm
	dw	wave1_spr&WM	;1
	dw	wave2_spr&WM	;2
	dw	wave3_spr&WM	;3
	dw	wave4_spr&WM	;4
	dw	wave3_spr&WM	;5
	dw	wave2_spr&WM	;6

;sws_THUNDERtable_anm

;	dw	thunder1_spr&WM	;1
;	dw	thunder2_spr&WM	;2
;	dw	thunder3_spr&WM	;3
;	dw	thunder4_spr&WM	;4
;	dw	thunder5_spr&WM	;5
;	dw	thunder6_spr&WM	;6
	endc
;=====================================================
;		Building in Radar		*
;=====================================================
	ifeq	1
Build_inRadar
	ai16	;Memory mode 16bit,Index mode 16bit

;------------ Are There targets in area ? ----------

	ldx	inertlistptr
	bne	.next		;if = 0 :target nothing

	jmp	.exit

;------------ Check Target shape name -----------
.next
	lda.w	i_shape,x
	cmp	#bu_5&WM
	beq	.player1		;if shape = (Building 5)
	cmp	#bu_6&WM
	beq	.player1		;if shape = (Building 6)
	cmp	#bu_7&WM
	beq	.player1		;if shape = (Building 7)

;------------- Next pointer check & set ------------
.Set_next_pnt
	lda.w	_next,x
	tax
	bne	.next

	jmp	.exit
;==================== Player 1 ========================
.player1
;------ sprites (x,y) coordinates set ------
	jmpflag.l	KRadarFlag,#P1RadModeFl,.player2

	longa
	longi

	lda	p1z
	sec
	sbc.w	i_worldz,x	;(player z pos) - (target z pos)

; check in radar
	cmp	#radar_max
	bpl	.player2
	cmp	#radar_min
	bmi	.player2
	clc
	adc	#p1radoffy<<8
	and	#$0ff00
	sta.w	sprites,y	;Set sprite y pos

	lda.w	i_worldx,x
	sec
	sbc	p1x
;check in radar
	cmp	#radar_max
	bpl	.player2
	cmp	#radar_min
	bmi	.player2
	xba
	and	#$00ff
	clc
	adc	#p1radoffx
	ora.w	sprites,y
	sta.w	sprites,y	;Set  sprite x pos

	iny
	iny

;---- Set Sprites Charcter --
	SetSprChr_Im	BuildChr,colpal0,pri1,noflip
;================== Player 2 ====================
.player2
	jmpflag.l	KRadarFlag,#P2RadModeFl,.Set_next_pnt2
;------ sprites (x,y) coordinates set ------
	lda	p2z
	sec
	sbc.w	i_worldz,x

; check in radar
	cmp	#radar_max
	bpl	.Set_next_pnt2
	cmp	#radar_min
	bmi	.Set_next_pnt2

	clc
	adc	#p2radoffy<<8
	and	#$0ff00
	sta.w	sprites,y	;Set sprite y pos

	lda.w	i_worldx,x
	sec
	sbc	p2x
; check in radar
	cmp	#radar_max
	bpl	.Set_next_pnt2
	cmp	#radar_min
	bmi	.Set_next_pnt2

	xba
	and	#$00ff
	clc
	adc	#p2radoffx
	ora.w	sprites,y
	sta.w	sprites,y	;Set sprite x pos

	iny
	iny

;---- Set Sprites Charcter --
	SetSprChr_Im	BuildChr,colpal0,pri1,noflip

.Set_next_pnt2
	jmp	.Set_next_pnt
.exit
	a8
;=====================================================
;		Item in Radar			*
;=====================================================
Item_inRadar
	ai16	;Memory mode 16bit,Index mode 16bit
;------------ Are There targets in area ? ----------

	ldx	inertlistptr
	bne	.next		;if = 0 :target nothing

	jmp	.exit

;------------ Check Target shape name -----------
.next
	PHX
	lda.w	i_shape,x
	cmp	#training&WM
	beq	.player1		;if shape = (Ring)

;------------- Next pointer check & set ------------
.Set_next_pnt
	PLX
	lda.w	_next,x
	tax
	bne	.next

	jmp	.exit
;==================== Player 1 ========================
.player1

;	a8
;	lda.w	i_flags,x
;	bit	#if_exists
;	a16
;	beq	.Set_next_pnt

;------ sprites (x,y) coordinates set ------
	km_jmpflag.l	KRadarFlag,P1RadModeFl,.player2

	longa
	longi

;;;;	lda.w	i_alienptr,x
;;;;	tax

	lda	p1z
	sec
	sbc.w	i_worldz,x	;(player z pos) - (target z pos)

; check in radar
	cmp	#radar_max
	bpl	.player2
	cmp	#radar_min
	bmi	.player2
	clc
	adc	#p1radoffy<<8
	and	#$0ff00
	sta.w	sprites,y	;Set sprite y pos

	lda.w	i_worldx,x
	sec
	sbc	p1x
;check in radar
	cmp	#radar_max
	bpl	.player2
	cmp	#radar_min
	bmi	.player2
	xba
	and	#$00ff
	clc
	adc	#p1radoffx
	ora.w	sprites,y
	sta.w	sprites,y	;Set  sprite x pos

	iny
	iny

;---- Set Sprites Charcter --
	km_SetSpriteChrVal	ItemChr,colpal0,pri1,noflip
;================== Player 2 ====================
.player2
	km_jmpflag.l	KRadarFlag,P2RadModeFl,.Set_next_pnt2

;------ sprites (x,y) coordinates set ------
	lda	p2z
	sec
	sbc.w	i_worldz,x

; check in radar
	cmp	#radar_max
	bpl	.Set_next_pnt2
	cmp	#radar_min
	bmi	.Set_next_pnt2

	clc
	adc	#p2radoffy<<8
	and	#$0ff00
	sta.w	sprites,y	;Set sprite y pos

	lda.w	i_worldx,x
	sec
	sbc	p2x
; check in radar
	cmp	#radar_max
	bpl	.Set_next_pnt2
	cmp	#radar_min
	bmi	.Set_next_pnt2

	xba
	and	#$00ff
	clc
	adc	#p2radoffx
	ora.w	sprites,y
	sta.w	sprites,y	;Set sprite x pos

	iny
	iny

;---- Set Sprites Charcter --
	km_SetSpriteChrVal	ItemChr,colpal0,pri1,noflip

.Set_next_pnt2
	jmp	.Set_next_pnt
.exit
	a8
;=====================================================
;	 Out of Map waku in Radar		*
;=====================================================
MapWaku1_inRadar
	ai16	;Memory mode 16bit,Index mode 16bit
	ldx	#0
;------------ Are There targets in area ? ----------
.next
	lda.l	MapWakuData,x
	cmp	#$8000
	bne	.player1

	jmp	.exit
;==================== Player 1 ========================
.player1
	stx	kpointer

	km_jmpflag.l	KRadarFlag,P1RadModeFl,.player2

;------ Set Player 1 (x,y)&character ------
	lda.l	MapWakuData,x
	sec
	sbc	p1x		;(player z pos) - (target z pos)
; check in radar
	cmp	#DelWakuMax
	bpl	.player2
	cmp	#DelWakuMin
	bmi	.player2

	xba			;1dot = 256
	clc
	adc	#p1radoffx

	and	#$00ff
	sta.w	sprites,y	;Set sprite x pos

	inx
	inx

	lda.l	MapWakuData,x
	sec
	sbc	p1z
	nega
;check in radar
	cmp	#DelWakuMax
	bpl	.player2
	cmp	#DelWakuMax
	bmi	.player2
	and	#$0ff00
	clc
	adc	#p1radoffy<<8
	ora.w	sprites,y
	sta.w	sprites,y	;Set  sprite y pos

	iny
	iny

	inx
	inx
	lda.l	MapWakuData,x
	sta.w	sprites,y	;Set  sprite character

	iny
	iny

;============================ Player2 ==============================
.player2
	km_jmpflag.l	KRadarFlag,P2RadModeFl,.Set_next_pnt2
;------ Set Player 2 (x,y)&character ------
	ldx	kpointer
	lda.l	MapWakuData,x
	sec
	sbc	p2x	;(player z pos) - (target z pos)
; check in radar
	cmp	#radar_max
	bpl	.Set_next_pnt2
	cmp	#radar_min
	bmi	.Set_next_pnt2
	xba			;1dot = 256
	clc
	adc	#p2radoffx
	and	#$00ff
	sta.w	sprites,y	;Set sprite x pos

	inx
	inx

	lda.l	MapWakuData,x
	sec
	sbc	p2z
	nega
;check in radar
	cmp	#radar_max
	bpl	.Set_next_pnt2
	cmp	#radar_min
	bmi	.Set_next_pnt2
	and	#$0ff00
	clc
	adc	#p2radoffy<<8
	ora.w	sprites,y
	sta.w	sprites,y	;Set  sprite y pos

	iny
	iny

	inx
	inx
	lda.l	MapWakuData,x
	sta.w	sprites,y	;Set  sprite character

	iny
	iny

.Set_next_pnt2
	lda	kpointer
	clc
	adc	#6
	tax
	jmp	.next
;--------------------------------------------------------
.exit
	sty	sprpointer
	a8

	endc
	rts

;-----------------------------------------------------
;*	Set World Map in Radar			*
;-----------------------------------------------------
wmap_inRadar

	ifeq	1
;=========== PLayer 1 Map in Radar ============

	ai16

	ldx	#0
	ldy	sprpointer

	lda	p1x
	xba
	and	#$00f0
	shiftRUA16
	sta	kwork+0		;sprites character X pos

	lda	p1z
	nega
	xba
	and	#$00f0
	sta	kwork+2		;sprites character Y pos

;-------- sprites (x,y) postion set ---------
.loop
	lda	p1x
	nega
	lsr	a
	xba
	and	#$0007
	sta	kwork+4

	lda	p1z
	lsr	a
	and	#$0700
	ora	kwork+4
	clc
	adc.l	MapHosei,x
	sta	sprites,y

	inx
	inx
	iny
	iny

;-------- sprites character set -------------
	lda	kwork+0
	clc
	adc.l	MapHosei,x
	and	#$000f
	sta	kwork+4

	inx
	inx
	phx

	lda	kwork+2
	clc
	adc.l	MapHosei,x
	and	#$00f0
	ora	kwork+4
	asl	a
	tax		;spr char data pointer

	lda.l	map_data,x
	sta	sprites,y

	plx
	inx
	inx

	iny
	iny

	lda.l	MapHosei,x
	cmp	#$0ffff
	bne	.loop		;Loop until SprChr set end

	sty	sprpointer

	a8
	endc
	rts

;-----------------------------------------------------
;*	Set World Map (pl1) in Radar		*
;-----------------------------------------------------
wmap1_inRadar
;1 dot mov = 256 

	ifeq	1
;=========== PLayer 1 Map in Radar ============

	ai16

	lda	p1x
	tax
	and	#$0fff
	bne	.skip1		;if p1x = *000h then hosei:p1x <-- p1x+1

	lda	p1x
	inc	a
	tax
.skip1
	txa
	nega
	xba			;div 256
	a8
	lsr	a
	and	#$07
	sta	kwork+0		;sprites x pos hosei

	lda	p1z+1
	lsr	a
	and	#$07
	sta	kwork+1		;sprites y pos hosei

	lda	p1x+1
	and	#$0f0
	shiftRUA16
	sta	kwork+2		;sprites character X pos

	a16
	lda	p1z
	tax
	and	#$0fff
	bne	.skip2		;if p1z = *000h then p1z <-- p1z+1

	lda	p1z
	inc	a
	tax
.skip2
	txa
	nega
	xba
	a8
	and	#$0f0
	sta	kwork+3		;sprites character Y pos

	ldx	#0
	ldy	sprpointer
;-------- sprites (x,y) postion set ---------
	lda.l	RMap1Hosei,x
.loop
	clc
	adc	kwork+0
	sta	sprites,y

	inx
	iny

	lda.l	RMap1Hosei,x
	clc
	adc	kwork+1
	sta	sprites,y

	inx
	iny

;-------- sprites character set -------------
	lda	kwork+2
	clc
	adc.l	RMap1Hosei,x
	and	#$0f
	sta	kwork+4

	inx
	phx

	lda	kwork+3
	clc
	adc.l	RMap1Hosei,x
	and	#$0f0
	ora	kwork+4
	a16
	and	#$00ff
	asl	a
	tax		;spr char data pointer

	lda.l	map_data,x
	sta	sprites,y

	plx
	inx

	iny
	iny

	a8
	lda.l	RMap1Hosei,x
	bne	.loop		;Loop until SprChr set end

	sty	sprpointer



	endc
	rts
;-----------------------------------------------------
;*	Set World Map(Pl2)  in Radar		*
;-----------------------------------------------------
wmap2_inRadar
;=========== PLayer 1 Map in Radar ============
	ifeq	1
	ai16

	lda	p2x
	tax
	and	#$0fff
	bne	.skip1		;if p1z = *000h then p1x <-- p1x+1

	lda	p2x
	inc	a
	tax
.skip1
	txa
	nega
	xba
	a8
	lsr	a
	and	#$07
	sta	kwork+0		;sprites x pos hosei

	lda	p2z+1
	lsr	a
	and	#$07
	sta	kwork+1		;sprites y pos hosei

	lda	p2x+1
	and	#$0f0
	shiftRUA16
	sta	kwork+2		;sprites character X pos

	a16
	lda	p2z
	tax
	and	#$0fff
	bne	.skip2		;if p1z = *000h then p1z <-- p1z+1

	lda	p2z
	inc	a
	tax
.skip2
	txa
	nega
	xba
	a8
	and	#$0f0
	sta	kwork+3		;sprites character Y pos

	ldx	#0
	ldy	sprpointer
;-------- sprites (x,y) postion set ---------

	lda.l	RMap2Hosei,x
.loop
	clc
	adc	kwork+0
	sta	sprites,y

	inx
	iny

	lda.l	RMap2Hosei,x
	clc
	adc	kwork+1
	sta	sprites,y

	inx
	iny

;-------- sprites character set -------------

	lda	kwork+2
	clc
	adc.l	RMap2Hosei,x
	and	#$0f
	sta	kwork+4

	inx
	phx

	lda	kwork+3
	clc
	adc.l	RMap2Hosei,x
	and	#$0f0
	ora	kwork+4
	a16
	and	#$00ff
	asl	a
	tax		;spr char data pointer

	lda.l	map_data,x
	sta	sprites,y

	plx
	inx

	iny
	iny

	a8
	lda.l	RMap2Hosei,x
	bne	.loop		;Loop until SprChr set end

	sty	sprpointer
	endc
	rts

;*********************************************************************
;*								*
;*		Relative Rot Radar				*
;*********************************************************************
enship_chr	equ	$3d
upper_chr	equ	$4d
up_chr	equ	$4e
normal_chr	equ	$4e
low_chr	equ	$4e
lower_chr	equ	$4f

red_rad	equ	$0
whi_rad	equ	$1<<9
blu_rad	equ	$2<<9

;=====================================================
;	Set Player2 in P1 Radar			*
;=====================================================
Renpl_inP1Radar
	ai16
	ldy	sprpointer
;------------ Check Target shape name -----------
	lda.l	m_dlptr
.next
	tax
;		lda.l	dl_shape,x
;		cmp	#arwing_red

	lda.l	dl_tscrollx,x
	cmp	#2		;player2 ? (dl_tscrollx =2)
	beq	.set
.pntcheck
	lda.l	dl_next,x
	bne	.next		;if = 0 :target nothing
	jmp	.exit
;-----------------------------------------------------------
.outofradar
	bra	.pntcheck
;-----------------------------------------------------------
.set
	lda.l	dl_x,x
	sta	kwork+0
	cmp	#mid_rdmode
	bpl	.outofRadar
	cmp	#-mid_rdmode
	bmi	.outofradar
	beq	.outofradar

	lda.l	dl_z,x
	nega
	sta	kwork+2
	cmp	#mid_rdmode
	bpl	.outofRadar
	cmp	#-mid_rdmode
	bmi	.outofradar
	beq	.outofradar
;---------------------------------------------------
	lda.l	dl_y,x
	cmp	#-100
	bmi	.up
	cmp	#100
	bpl	.down
.normal
	lda	#enship_chr
	ora	#whi_rad
	sta	kwork+4
	bra	.mid
.up
	lda	#enship_chr
	sta	kwork+4
	bra	.mid
.down
	lda	#enship_chr
	ora	#blu_rad
	sta	kwork+4
;-------------------------------------------------------------
.mid	;rang R max = [3840]	:(RANGE R max= 5100) becouse div 1 byte
	longa
	lda	kwork+0	;x
	km_cpudivs15uf8	RelRadRange	;1DOT=192 (R=3840)
	clc
	adc	ksproffx
	sta	kwork+0

	lda	kwork+2	;y
	km_cpudivs15uf8	RelRadRange	;1DOT=192 (R=3840)
	clc
	adc	ksproffy
	sta	kwork+2

	km_SetSpriteXY	kwork+0,kwork+2
	lda	kwork+4
	km_SetSpriteChrCol	0,pri3,noflip
;;;	SetSprEnemy	kwork+4,pri3,noflip
	jmp	.pntcheck

;---------------------------------------------------
.exit
	sty	sprpointer
	a8
	rts
;=====================================================
;	Set Player1 in P2 Radar			*
;=====================================================
Renpl_inP2Radar
	ai16
	ldy	sprpointer
;------------ Check Target shape name -----------
	lda.l	m_dlptr
.next
	tax
;		lda.l	dl_shape,x
;		cmp	#arwing
;		cmp	#friendship_4
;		beq	.set

	lda.l	dl_tscrollx,x
	cmp	#1		;player 1 ? (dl_tscroll = 1)
	beq	.set
.pntcheck
	lda.l	dl_next,x
	bne	.next		;if = 0 :target nothing
	jmp	.exit
;-----------------------------------------------------------
.outofradar
	bra	.pntcheck
;-----------------------------------------------------------
.set
	lda.l	dl_x,x
	sta	kwork+0
	cmp	#mid_rdmode
	bpl	.outofRadar
	cmp	#-mid_rdmode
	bmi	.outofradar
	beq	.outofradar

	lda.l	dl_z,x
	nega
	sta	kwork+2
	cmp	#mid_rdmode
	bpl	.outofRadar
	cmp	#-mid_rdmode
	bmi	.outofradar
	beq	.outofradar
;---------------------------------------------------
	lda.l	dl_y,x
	cmp	#-100
	bmi	.up
	cmp	#100
	bpl	.down
.normal
	lda	#enship_chr
	ora	#whi_rad
	sta	kwork+4
	bra	.mid
.up
	lda	#enship_chr
	sta	kwork+4
	bra	.mid
.down
	lda	#enship_chr
	ora	#blu_rad
	sta	kwork+4
;-------------------------------------------------------------
.mid	;rang R max = [3840]	:(RANGE R max= 5100):::/(255)
	longa
	lda	kwork+0	;x
	km_cpudivs15uf8	RelRadRange	;1DOT=192 (R=3840)
	clc
	adc	ksproffx
	sta	kwork+0

	lda	kwork+2	;y
	km_cpudivs15uf8	RelRadRange	;1DOT=192 (R=3840)
	clc
	adc	ksproffy
	sta	kwork+2

	km_SetSpriteXY	kwork+0,kwork+2
	lda	kwork+4
	km_SetSpriteChrCol	0,pri3,noflip
;;;	SetSprEnemy	kwork+0,kwork+2,kwork+4,3,0
	jmp	.pntcheck

;************* Range Change Mode ***************
	ifeq	1
.check0
	cmp	#near_rdmode
	bpl	.check1
	cmp	#-near_rdmode
	bmi	.check1
	beq	.check1
	jmp	.near_rdmodeX
.check1
	cmp	#mid_rdmode
	bpl	.check2
	cmp	#-mid_rdmode
	bmi	.check2
	beq	.check2
	jmp	.middle_rdmodeX

.check2
	cmp	#far_rdmode
	bpl	.out_radar
	cmp	#-far_rdmode
	bmi	.out_radar
	beq	.out_radar
	jmp	.far_rdmodeX
.out_radar
	jmp	.pntcheck
;---------------------------------------------------
.near_rdmodeX
	lda	#01
	sta	kflag
	
      	bra	.Set_Zpos
.middle_rdmodeX
	lda	#02
	sta	kflag
	bra	.Set_Zpos
.far_rdmodeX
	lda	#04
	sta	kflag
;---------------------------------------------------
.Set_Zpos
	lda.l	dl_z,x
	nega
	sta	kwork+2
	cmp	#near_rdmode
	bpl	.check3
	cmp	#-near_rdmode
	bmi	.check3
	beq	.check3
	jmp	.near_rdmodeZ
.check3
	cmp	#mid_rdmode
	bpl	.check4
	cmp	#-mid_rdmode
	bmi	.check4
	beq	.check4
	jmp	.middle_rdmodeZ
.check4
	cmp	#far_rdmode
	bpl	.out_radarZ
	cmp	#-far_rdmode
	bmi	.out_radarZ
	beq	.out_radarZ
	jmp	.far_rdmodeZ
.out_radarZ
	jmp	.pntcheck
;---------------------------------------------------
.near_rdmodeZ
	lda	kflag
	ora	#01
	sta	kflag

	bra	.SetPlZpos
.middle_rdmodeZ
	lda	kflag
	ora	#02
	sta	kflag
	bra	.SetPlZpos
.far_rdmodeZ
	lda	kflag
	ora	#04
	sta	kflag
.SetPlZpos
	lda	kflag
	cmp	#04
	bmi	.skip0
	jmp	.far
.skip0
	cmp	#02
	bmi	.near
	jmp	.mid
;---------------------------------------------------
.near	;rang R max = [2560]
	longa
	lda	kwork+0	;x
	kdivs16u8	#128	;#64
	clc
	adc	ksproffx
	sta	kwork+4

	lda	kwork+2	;y
	kdivs16u8	#128	;#64
	clc
	adc	ksproffy
	sta	kwork+5
	a8
	SetSprXYChr	kwork+4,kwork+5,#$3D,0,3,0
	a16
	jmp	.pntcheck
;---------------------------------------------------
.mid	;rang R max = [2560]
	longa
	lda	kwork+0	;x
	kdivs16u8	#128
	clc
	adc	ksproffx
	sta	kwork+4

	lda	kwork+2	;y
	kdivs16u8	#128
	clc
	adc	ksproffy
	sta	kwork+5
	a8
	SetSprXYChr	kwork+4,kwork+5,#$3D,0,3,0

	a16
	jmp	.pntcheck
;---------------------------------------------------
.far	;range R max = [5120]
	longa

	lda	kwork+0	;x
	kdivs16u8	#255
	clc
	adc	ksproffx
	sta	kwork+4

	lda	kwork+2	;y
	kdivs16u8	#255
	clc
	adc	ksproffy
	sta	kwork+5
	a8
	SetSprXYChr	kwork+4,kwork+5,#$3f,0,3,0
	a16
	jmp	.pntcheck
	endc
;---------------------------------------------------
.exit
	sty	sprpointer
	a8
	rts

;=====================================================
;		Enemy in Radar			*
;=====================================================
	IFEQ	1
Renemy_inRadar
	ai16	;Memory mode 16bit,Index mode 16bit

	ldx	#(m_drawlist+2)&WM

	lda	#0
	sta	kcounter
;------------ Are There targets in area ? ----------
	ldy	allst
	bne	.next		;if = 0 :target nothing

	jmp	.exit
;------------ Check Target shape name -----------
.next
	lda.w	al_shape,y
;------------- Next pointer check & set ------------
.Set_next_pnt
	lda.w	_next,y
	tay
	bne	.next

	jmp	.searchend
;----------------------- Player 1 ------------------
.player1
;enemy X
	lda.w	al_worldx,y
	sta.l	rl_x,x
;enemy Y
	lda.w	al_worldy,y
	sta.l	rl_y,x
;enemy Z
	lda.w	al_worldz,y
	sta.l	rl_z,x
;enemy pointer
	tya
	sta.l	rl_alptr,x
;inc enemy number
	inc	kcounter

;Set next radar list pointer
	txa
	clc
	adc	#rl_sizeof
	tax
	jmp	.Set_next_pnt
;---------------------------------------------------------------
.searchend	;kcounter = enemy number
	longa
	lda	kcounter
	bne	.skip
	jmp	.exit
.skip
	sta.l	m_drawlist

	s_set_objtobeplayer2	x
	lda	al_worldx,x
	sta.l	m_viewposx
	lda	al_worldy,x
	sta.l	m_viewposy
	lda	al_worldz,x
	sta.l	m_viewposz

	call_mario	mradarrot
;---------------------------------------------------------------
	ai16
	ldx	#(m_drawlist+2)&WM
	ldy	sprpointer
.setsprites
	lda.l	rl_outx,x
	cmp	#mid_rdmode
	bpl	.outofRadar
	cmp	#-mid_rdmode
	bmi	.outofradar
	beq	.outofradar
	sta	kwork+0

	lda.l	rl_outz,x
	nega
	cmp	#mid_rdmode
	bpl	.outofRadar
	cmp	#-mid_rdmode
	bmi	.outofradar
	beq	.outofradar
	sta	kwork+2

	lda	#$3f
	sta	kwork+4
	jmp	.mid
.outofradar
	jmp	.outofradar2

;-------------------------------------------------------------
.mid	;rang R max = [3840]	:(RANGE R max= 5100) becouse div 1 byte
	longa
	lda	kwork+0	;x
	km_cpudivs15uf8	RelRadRange	;1DOT=192 (R=3840)
	clc
	adc	ksproffx
	sta	kwork+0

	lda	kwork+2	;y
	km_cpudivs15uf8	RelRadRange	;1DOT=192 (R=3840)
	clc
	adc	ksproffy
	sta	kwork+2

	km_SetSpriteXY	kwork+0,kwork+2
	lda	#kwork+4
	km_SetSpriteChrCol	0,pri3,noflip
;;;	SetSprEnemy	kwork+0,kwork+2,kwork+4,3,0

.outofradar2
	dec	kcounter
	beq	.sprsetend

	txa
	clc
	adc	#rl_sizeof
	tax

	jmp	.setsprites
.sprsetend
	sty	sprpointer
;---------------------------------------------------------------
.exit
	a8
	rts

;=====================================================
;	Set Item in Radar			*
;=====================================================
Ritem_inRadar
	ai16
	ldy	sprpointer
;------------ Are There targets in Radar area ? ----------
	lda.l	m_dlptr
.next
	tax
	lda.l	dl_shape,x
	cmp	#training&WM
	beq	.player1		;if shape = (ring) 

.pntcheck
	lda.l	dl_next,x
	bne	.next		;if = 0 :target nothing
	jmp	.exit

;-----------------------------------------------------------
.outofradar
	bra	.pntcheck
;-----------------------------------------------------------
.player1
	lda.l	dl_x,x
	sta	kwork+0
	cmp	#mid_rdmode
	bpl	.outofRadar
	cmp	#-mid_rdmode
	bmi	.outofradar
	beq	.outofradar

	lda.l	dl_z,x
	nega
	sta	kwork+2
	cmp	#mid_rdmode
	bpl	.outofRadar
	cmp	#-mid_rdmode
	bmi	.outofradar
	beq	.outofradar
;-------------------------------------------------------------
;upper:>1536 , up>512 , 512>normal>-512 ,-512>low ,-1536>lower

	lda.l	dl_y,x
	cmp	#-150
	bmi	.upper
	cmp	#-80
	bmi	.up
	cmp	#150
	bpl	.lower
	cmp	#80
	bpl	.low	
.normal
	lda	#normal_chr
	ora	#whi_rad
	sta	kwork+4		;chr =$0e,col =(white)
	bra	.mid
.upper
	lda	#upper_chr		;chr =$0d,col =(red)
	sta	kwork+4
	bra	.mid
.up
	lda	#up_chr
	sta	kwork+4		;chr =$0e,col =(red)
	bra	.mid
.low
	lda	#low_chr
	ora	#blu_rad		;chr =$0e,col =(blue)
	sta	kwork+4
	bra	.mid
.lower
	lda	#lower_chr
	ora	#blu_rad		;chr =$0f,col =(blue)
	sta	kwork+4
;-------------------------------------------------------------
.mid	;rang R max = [3840]	:(RANGE R max= 5100) becouse div 1 byte
	longa
	lda	kwork+0	;x
	km_cpudivs15uf8	RelRadRange	;1DOT=192 (R=3840)
	clc
	adc	ksproffx
	sta	kwork+0

	lda	kwork+2	;y
	km_cpudivs15uf8	RelRadRange	;1DOT=192 (R=3840)
	clc
	adc	ksproffy
	sta	kwork+2

	km_SetSpriteXY	kwork+0,kwork+2
	lda	kwork+4
	km_SetSpriteChrCol	0,pri3,noflip
;;	SetSprEnemy	kwork+0,kwork+2,kwork+4,3,0
	jmp	.pntcheck

;---------------------------------------------------
.exit
	sty	sprpointer
	a8
	rts
	ENDC



	ifeq	1
;=====================================================
;*		Ring Out			*
;* Ring out Count,Return mark			*
;=====================================================
RingOut
	shorta
	longi
;======================= Player1 =====================
;--------- Area Out In Check -----------
	a16
	s_set_objtobeplayer1	x

	lda	al_worldx,x
	cmp	#RingOutMax
	bpl	.P1RingOut
	cmp	#RingOutMin
	bmi	.P1RingOut

	lda	al_worldz,x
	cmp	#RingOutMax
	bpl	.P1RingOut
	cmp	#RingOutMin
	bmi	.P1RingOut

;********* Area in **********
;--------- Ring Return Check & Flag Clear ----------
	a8
	jmpnotflag	P1RingOutTm,#KROutFlag,RingOutPlayer2

	clsflag		P1RingOutTm,#KROutFlag
	jmp	RingOutPlayer2

;******** Ring Out **********
;------ Check Start Ring Out  --------
.P1RingOut
	a8
	jmpflag	P1RingOutTm,#KROutFlag,.P1DecTimer

;---- Initial Timer -----
	lda	#second
	sta	P1SecTm		;reset 1 secon time (15)

	lda	#ROIntTm
	sta	P1RingOutTm	;Set Init Time(10) & Flag($80)
	jmp	.P1RingOutSound

;======== Player 1 dec timer & Game Over Check=========
.P1DecTimer
	lda	P1SecTm
	bne	.P1RingOutSound	;if 1 second past

	lda	#second
	sta	P1SecTm		;reset 1 secon time (15)

	lda	P1RingOutTm
	and	#KROutFlag^(-1)
	dec	a
	bpl	.P1NoGameOver

;If Game Over then Game Over FLag Set
	km_plheapptrSD	x,y
	setflag	KGMOVER,#RingOutFlag,y

	lda	#0
	sta	P1RingOutTm	;Ring Out Timer <--- 0
	jmp	RingOutExit

.P1NoGameOver
	ora	#KROutFlag
	sta	P1RingOutTm	;Dec Time Set

;================== Sound ===================
.P1RingOutSound
	lda	P1RingOutTm
	and	#KROutFlag^(-1)
	cmp	#6
	bmi	.P1CountCheck	; if Ring Out Count < 6

	lda	P1SecTm
	bra	.P1Count1secPast
.P1CountCheck
	lda	P1SecTm
	cmp	#3
	beq	.sound		;if 1 second past
	cmp	#6
	beq	.sound		;if 1 second past
	cmp	#9
	beq	.sound		;if 1 second past
	cmp	#12
	beq	.sound		;if 1 second past
.P1Count1secPast
	cmp	#15
	beq	.sound		;if 1 second past
	bra	.nosound
.sound
	kplsound	x,ringoutcount
.nosound

;************************ Sprites Set ********************************
	shorta
	longi
	ldy	sprpointer
;====== Ring Out Time =======
.P1RingOutTime
	a16
	lda.l	P1RingOutTm
	and	#$ff
	and	#KROutFlag^-1
	kdivu16u8	work,#10
	a8
.1sec
;up chr
	SetSprXY_Im	P1RoutTimeoffX+8,P1RoutTimeoffY
	lda	kamari
	SetSprChr_Acc	ROutTMChrUp,colpal0,pri2,noflip
;down chr
	SetSprXY_Im	P1RoutTimeoffX+8,P1RoutTimeoffY+8
	lda	kamari
	SetSprChr_Acc	ROutTMChrDw,colpal0,pri2,noflip
;10sec
;up chr
	SetSprXY_Im	P1RoutTimeoffX,P1RoutTimeoffY
	lda	ksyou
	SetSprChr_Acc	ROutTmChrUp,colpal0,pri2,noflip
;down chr
	SetSprXY_Im	P1RoutTimeoffX,P1RoutTimeoffY+8
	lda	ksyou
	SetSprChr_Acc	ROutTmChrDw,colpal0,pri2,noflip

;======= Return Ring Mes =======
	lda.l	P1SecTm
	cmp	#6
	bpl	.appear
	jmp	.notappear

;return chr
	ifeq	1
	SetSprSize_sub_DB
	SetSprXYChr_Im	P1RetMarkoffX,P1RetMarkoffY,ROutRetChr,colpal0,pri2,noflip
	endc
;========== Return Mark Check ==============
.appear
	km_obj2field_rotY	W,x,kangle

	lda	kangle
	bpl	.plas
	jmp	.minus
.plas
	cmp	#$18
	bpl	.skip1
	jmp	.noturnL
.skip1
	cmp	#$40
	bmi	.smallturnL
	cmp	#$60
	bmi	.middleturnL
.bigturnL	
	SetSprXYChr_Im	P1RetMarkoffX-$30,P1RetMarkoffY+0,$a6,colpal0,pri2,xflip
	SetSprXYChr_Im	P1RetMarkoffX-$30,P1RetMarkoffY+8,$a6,colpal0,pri2,xyflip
.middleturnL
	SetSprXYChr_Im	P1RetMarkoffX-$28,P1RetMarkoffY+0,$a6,colpal0,pri2,xflip
	SetSprXYChr_Im	P1RetMarkoffX-$28,P1RetMarkoffY+8,$a6,colpal0,pri2,xyflip
.smallturnL
	SetSprXYChr_Im	P1RetMarkoffX-$20,P1RetMarkoffY+0,$a6,colpal0,pri2,xflip
	SetSprXYChr_Im	P1RetMarkoffX-$20,P1RetMarkoffY+8,$a6,colpal0,pri2,xyflip
.noturnL
	jmp	.P1SpritesEnd

.minus
	cmp	#$e8
	bmi	.skip2
	jmp	.noturnR
.skip2
	cmp	#$c0
	bpl	.smallturnR
	cmp	#$a0
	bpl	.middleturnR
.bigturnR
	SetSprXYChr_Im	P1RetMarkoffX+$28,P1RetMarkoffY+0,$a6,colpal0,pri2,noflip
	SetSprXYChr_Im	P1RetMarkoffX+$28,P1RetMarkoffY+8,$a6,colpal0,pri2,yflip
.middleturnR
	SetSprXYChr_Im	P1RetMarkoffX+$20,P1RetMarkoffY+0,$a6,colpal0,pri2,noflip
	SetSprXYChr_Im	P1RetMarkoffX+$20,P1RetMarkoffY+8,$a6,colpal0,pri2,yflip
.smallturnR
	SetSprXYChr_Im	P1RetMarkoffX+$18,P1RetMarkoffY+0,$a6,colpal0,pri2,noflip
	SetSprXYChr_Im	P1RetMarkoffX+$18,P1RetMarkoffY+8,$a6,colpal0,pri2,yflip
.noturnR
.notappear
.P1SpritesEnd
	sty	sprpointer
;***********************************************************************
RingOutPlayer2
;======================= Player2 =====================
;--------- Area Out In Check -----------
	a16
	s_set_objtobeplayer2	x

	lda	al_worldx,x
	cmp	#RingOutMax
	bpl	.p2RingOut
	cmp	#RingOutMin
	bmi	.p2RingOut

	lda	al_worldz,x
	cmp	#RingOutMax
	bpl	.p2RingOut
	cmp	#RingOutMin
	bmi	.p2RingOut

;********* Area in **********
;--------- Ring Return Check & Flag Clear ----------
	a8
	jmpnotflag	P2RingOutTm,#KROutFlag,RingOutExit

	clsflag		P2RingOutTm,#KROutFlag
	jmp	RingOutExit

;******** Ring Out **********
;------ Check Start Ring Out  --------
.p2RingOut
	a8
	jmpflag	P2RingOutTm,#KROutFlag,.p2DecTimer

;---- Initial Timer -----
	lda	#second
	sta	P2SecTm		;reset 1 secon time (15)

	lda	#ROIntTm
	sta	P2RingOutTm	;Set Init Time(10) & Flag($80)
	jmp	.p2RingOutSound

;======== Player 1 dec timer & Game Over Check=========
.p2DecTimer
	lda	P2SecTm
	bne	.p2RingOutSound	;if 1 second past

	lda	#second
	sta	P2SecTm		;reset 1 secon time (15)

	lda	P2RingOutTm
	and	#KROutFlag^(-1)
	dec	a
	bpl	.p2NoGameOver

;If Game Over then Game Over FLag Set
	km_plheapptrSD	x,y
	setflag	KGMOVER,#RingOutFlag,y

	lda	#0
	sta	P2RingOutTm	;Ring Out Timer <--- 0
	jmp	RingOutExit

.p2NoGameOver
	ora	#KROutFlag
	sta	p2RingOutTm	;Dec Time Set

;================== Sound ===================
.p2RingOutSound
	lda	P2RingOutTm
	and	#KROutFlag^(-1)
	cmp	#6
	bmi	.p2CountCheck	; if Ring Out Count < 6

	lda	P2SecTm
	bra	.p2Count1secPast
.p2CountCheck
	lda	P2SecTm
	cmp	#3
	beq	.sound		;if 1 second past
	cmp	#6
	beq	.sound		;if 1 second past
	cmp	#9
	beq	.sound		;if 1 second past
	cmp	#12
	beq	.sound		;if 1 second past
.p2Count1secPast
	cmp	#15
	beq	.sound		;if 1 second past
	bra	.nosound
.sound
	kplsound	x,ringoutcount
.nosound

;************************ Sprites Set ********************************
	shorta
	longi
	ldy	sprpointer
;====== Ring Out Time =======
.p2RingOutTime
	a16
	lda.l	P2RingOutTm
	and	#$ff
	and	#KROutFlag^-1
	kdivu16u8	work,#10
	a8
.1sec
;up chr
	SetSprXY_Im	P2RoutTimeoffX+8,P2RoutTimeoffY
	lda	kamari
	SetSprChr_Acc	ROutTMChrUp,colpal0,pri2,noflip
;down chr
	SetSprXY_Im	P2RoutTimeoffX+8,P2RoutTimeoffY+8
	lda	kamari
	SetSprChr_Acc	ROutTMChrDw,colpal0,pri2,noflip
;10sec
;up chr
	SetSprXY_Im	P2RoutTimeoffX,P2RoutTimeoffY
	lda	ksyou
	SetSprChr_Acc	ROutTmChrUp,colpal0,pri2,noflip
;down chr
	SetSprXY_Im	P2RoutTimeoffX,P2RoutTimeoffY+8
	lda	ksyou
	SetSprChr_Acc	ROutTmChrDw,colpal0,pri2,noflip

;======= Return Ring Mes =======
	lda.l	P2SecTm
	cmp	#6
	bpl	.appear
	jmp	.notappear

	ifeq	1
;return chr
	SetSprSize_sub_DB
	SetSprXYChr_Im	p2RetMarkoffX,p2RetMarkoffY,ROutRetChr,colpal0,pri2,noflip
	endc
;========== Return Mark Check ==============
.appear
	km_obj2field_rotY	W,x,kangle

	lda	kangle
	bpl	.plas
	jmp	.minus
.plas
	cmp	#$18
	bpl	.skip1
	jmp	.noturnL
.skip1
	cmp	#$40
	bmi	.smallturnL
	cmp	#$60
	bmi	.middleturnL
.bigturnL	
	SetSprXYChr_Im	P2RetMarkoffX-$30,p2RetMarkoffY+0,$a6,colpal0,pri2,xflip
	SetSprXYChr_Im	P2RetMarkoffX-$30,p2RetMarkoffY+8,$a6,colpal0,pri2,xyflip
.middleturnL
	SetSprXYChr_Im	p2RetMarkoffX-$28,p2RetMarkoffY+0,$a6,colpal0,pri2,xflip
	SetSprXYChr_Im	p2RetMarkoffX-$28,p2RetMarkoffY+8,$a6,colpal0,pri2,xyflip
.smallturnL
	SetSprXYChr_Im	p2RetMarkoffX-$20,p2RetMarkoffY+0,$a6,colpal0,pri2,xflip
	SetSprXYChr_Im	p2RetMarkoffX-$20,p2RetMarkoffY+8,$a6,colpal0,pri2,xyflip
.noturnL
	jmp	.p2SpritesEnd

.minus
	cmp	#$e8
	bmi	.skip2
	jmp	.noturnR
.skip2
	cmp	#$c0
	bpl	.smallturnR
	cmp	#$a0
	bpl	.middleturnR
.bigturnR
	SetSprXYChr_Im	p2RetMarkoffX+$28,p2RetMarkoffY+0,$a6,colpal0,pri2,noflip
	SetSprXYChr_Im	p2RetMarkoffX+$28,p2RetMarkoffY+8,$a6,colpal0,pri2,yflip
.middleturnR
	SetSprXYChr_Im	p2RetMarkoffX+$20,p2RetMarkoffY+0,$a6,colpal0,pri2,noflip
	SetSprXYChr_Im	p2RetMarkoffX+$20,p2RetMarkoffY+8,$a6,colpal0,pri2,yflip
.smallturnR
	SetSprXYChr_Im	p2RetMarkoffX+$18,p2RetMarkoffY+0,$a6,colpal0,pri2,noflip
	SetSprXYChr_Im	p2RetMarkoffX+$18,p2RetMarkoffY+8,$a6,colpal0,pri2,yflip
.noturnR
.notappear
.p2SpritesEnd
	sty	sprpointer
;--------------------------------------------------------------
RingOutExit
	a8
	rts

	endc

;*************************************************************************
;=====================================================
;*		Timer Waku set			*
;=====================================================
	IFEQ	1
timer_waku
	ai16
	ldy	sprpointer
	BlockTransSprites	SprGameTimerWaku
	sty	sprpointer
	a8
	rtl
	ENDC
;***************************************************************************
;=============================================================
;*	Set Sprites (message & Map)in Pause	[PAUSE]	*
;* Data Bank 7e						*
;* Yreg :spites poionter					*
;=============================================================
	IFEQ	1
SetPauseSpr_l
	SHORTA
	LONGI
	phb
	db7e
	ldy	sprpointer
;-------------------------------------------------------------
;*	Set Sprites Double Buffer Pointer	[mission]*
;-------------------------------------------------------------
;(0... buffer2 write ,1... buffer1 write)

	km_eorscreenflag	oamtensou

	ldy	#oambuf1
	km_bitcheckscreenflag	oamtensou
	bne	.WriteBuf1
.WriteBuf2	ldy	#oambuf2
.WriteBuf1
	sty	sprpointer	;Initial sprites pointer
;-------------------------------------------------------------
;*		OAM RAM Clear		[mission]	*
;-------------------------------------------------------------
	oamclear_DB		;OAM double Buffer Clear
	oamsuballon			;sprites
;-------------------------------------------------------------
;*
;-------------------------------------------------------------
	ldy	sprpointer

;================== Pause Player 1 ==========================
;	km_bitcheckgameflag	p1pauseflag
;	bne	.PausePlayer1
;	jmp	.Checkplayer2
.PausePlayer1
;----------- Set Pause Message &MAP --------
	ai16
	sty	ksource
	SetSprBlockXYChr_Im	SprRadSelMesP1

;----------- Set Select Waku ---------------
	stz	kwork
	checkflag.l	KRadarFlag,#P1radmodeFl
	beq	.setwaku

	lda	#$0030
	sta	kwork
.setwaku
	ldx	#0
	CopyPauseChr.l	SprRadSelWakuP1,Sprites,kwork

;------------ Set Sprites Size ---------------
	sty	kdest

	lda	ksource
	clc
	adc	#PauseMesVal
	tay	; Set source address for 4chr mode
.loop
	jsl	ChangeSprSize_Big		;Set Sprites sub data 
	ai16
	tya
	clc
	adc	#4
	tay
	cpy	kdest
	bne	.loop
	a8
;================== Pause Player 2 ==========================
.Checkplayer2
;	km_bitcheckgameflag	p2pauseflag
;	bne	.PausePlayer2
;	jmp	.exit
.PausePlayer2
;----------- Set OAM data (message &MAP)
	ai16
	sty	ksource
	SetSprBlockXYChr_Im	SprRadSelMesP2

;----------- Set Select Waku ---------------
	stz	kwork
	checkflag.l	KRadarFlag,#P2radmodeFl
	beq	.setwakuP2

	lda	#$0030
	sta	kwork
.setwakuP2
	ldx	#0
	CopyPauseChr.l	SprRadSelWakuP2,Sprites,kwork

;----------------- Set Sprites Size ----------------------
	sty	kdest

	lda	ksource
	clc
	adc	#PauseMesVal
	tay	; Set source address for 4chr mode
.loop2
	jsl	ChangeSprSize_Big		;Set Sprites sub data 
	ai16
	tya
	clc
	adc	#4
	tay
	cpy	kdest
	bne	.loop2
;------------ Push Start Message --------------
	a8
	lda	PushStartTm
	inc	a
	sta	PushStartTm
	and	#$1f
	cmp	#018
	bpl	.exit

	km_bitcheckgameflag	p1pauseflag
	beq	.PushStartP2
.PushStartP1
	SetSprBlockXYChr_Im	SprPushStartP1
	bra	.exit
.PushStartP2
	SetSprBlockXYChr_Im	SprPushStartP2
;---------------------------------------------------
.exit
	sty	sprpointer
	a8
	plb
	rtl
	ENDC
;***************************************************************************
;***************************************************************************
;*******************************************************************
;*******************************************************************

;******************** Relative Radar **************************
	ifeq	1
	shorta
	longi
	jmpnotflag.l	KRadarFlag,#P2radmodeFl,.skip2

	a16
	lda	#p2radoffx
	sta	ksproffx
	lda	#p2radoffy
	sta	ksproffy
	a8
	jsr	Renpl_inP2Radar
	jsr	Renemy_inRadar
	jsr	Ritem_inRadar
.skip2
	endc


;*********************************************************************
;*		Player 1 Relative Rotation Radar		*
;*********************************************************************
do_spritesP1Radar_l
	rtl

	ifeq	1

	php
	a8i16
	PHB
	DB7E
	test_screenmode	nosprites
	bne	.ok_cockpit
	plb
	plp
	rtl
.ok_cockpit

;======== Special Enemy Check ===========
;-----------------------------------------------------------------------
	checkflag.l	KRadarFlag,#P1radmodeFl
	beq	.exit
	a16
	lda	#p1radoffx
	sta	ksproffx
	lda	#p1radoffy
	sta	ksproffy
	a8
	jsr	Renpl_inP1Radar
	jsr	Ritem_inRadar
.exit
;;;;;;	eorflag	kgameflag,#oamtransflag

;********************* Debug Mode *****************************
;======== Debug Mode ========================
	PLB
	plp
	rtl
	ENDC

;*********************************************************************
;			Mujirushi Radar				*
;*********************************************************************
;======== Player 1 Radar ==================
	ifeq	1
	s_set_objtobeplayer1	x
	jsr	set_playerpos
	setradaroff	p1radoffx,p1radoffy

	checkflag.l	KRadarFlag,#RadarModeP1
	bne	.RelativeRadarP1

	jsr	ABSRadar
	jmp	.player2
.RelativeRadarP1
;;;;	jsr	RelRadar
.player2
	endc

;======== absolute radar ====================

	ifeq	1
	jsr	myship_inRadar		;My PLayer
	jsr	enship_inRadar		;Another PLayer
	jsr	Enemy_inRadar		;Enemy
	jsr	Build_inRadar		;Building
	jsr	Item_inRadar		;Item
	jsr	MapWaku1_inRadar	;Area Waku
	endc

	ifeq	1
	jsr	wmap1_inRadar		;Map 1
	endc

	ifeq	1
	jsr	wmap2_inRadar		;Map 2
	endc
;======== relative rotation radar ===========
	ifeq	1
	jsr	Renpl_inRadar
	jsr	Ritem_inRadar
	endc


;****************************************************************************
;****************************************************************************
;****************************************************************************
;****************************************************************************

;*			NOT USEING AREA				*
;*			NOT USEING AREA				*
;*			NOT USEING AREA				*
;*			NOT USEING AREA				*

;****************************************************************************
;****************************************************************************
;****************************************************************************
;****************************************************************************
;=====================================================
;*		Enemy Number			*
;* Data Bank 7e					*
;* Yreg :sprites pointer				*
;* KEnemyNumber :Enemy rest Number			*
;=====================================================
	IFEQ	1

;====== Enemy Count =======
	a16
	stz	kcounter
;------------ Are There targets in area ? ----------
	ldx	inertlistptr
	bne	.next		;if = 0 :target nothing
	jmp	.exit
;------------ Check Target shape name -----------
.next
;Building Shapes
	lda.w	i_shape,x
	ldx	allst		;alien pointer
	bne	.next	;if = 0 :alien nothing
	jmp	.exit
;------------ Check Alien shape name -----------
.Next
	lda.w	al_shape,x
	cmp	#phoenix&WM
	beq	.FindShape
	cmp	#ship_0&WM
	beq	.FindShape
	cmp	#takoashi&WM
	beq	.FindShape
	cmp	#mimizu&WM
	beq	.FindShape
	cmp	#kao&WM
	beq	.FindShape
	cmp	#batta_0&WM
	beq	.FindShape
	cmp	#q&WM
	beq	.FindShape		;if shape = (q)
	cmp	#zaco_0&WM
	beq	.FindShape		;if shape = (zaco_0)
	cmp	#zaco_1&WM
	beq	.FindShape		;if shape = (zaco_1)
	cmp	#zaco_2&WM
	beq	.FindShape		;if shape = (zaco_2)

	cmp	#robo_0&WM
	beq	.FindShape		;if shape = (robo_0)
	cmp	#robo_1&WM
	beq	.FindShape		;if shape = (robo_1)

	cmp	#batta_0&WM
	beq	.FindShape		;if shape = (batta_0)

	cmp	#gun_walk&WM
	beq	.FindShape		;if shape = (gun_walk)
	cmp	#gun_shot&WM
	beq	.FindShape		;if shape = (gun_shot)
	cmp	#gun_pose&WM
	beq	.FindShape		;if shape = (gun_pose)
	cmp	#gun_look&WM
	beq	.FindShape		;if shape = (gun_look)
	cmp	#dacho&WM
	beq	.FindShape		;if shape = (dacho)
	jmp	.Set_next_pnt
.FindShape
	inc	Kcounter
;------------- Next pointer check & set ------------
.Set_next_pnt
	lda.w	_next,x
	tax
	beq	.exit
	jmp	.next
.exit
	a8
	lda	kcounter
;;;	sta	KEnemyNumber
	bne	.skip
;	km_setgameflag	bossappear
	km_clrflag		KRingOutTimer,KROutFlag,x
.skip

;=====================================================================
;*			Set Sprite Size				*
;=====================================================================
ChangeSprSize_Big
	ai16
	phx
	phy

	tya
	kshiftRUA2	;;oam (*0,*4,*8,*c)---->(*0,*1,*2,*3)
	tay
	and	#3
	tax
	sec
	lda	#0
.loop
	rol	a
	rol	a
	dex
	bpl	.loop
	tax		;Keep OAM size bit
	tya
	kshiftRUA2
	tay		;Set sprites sub pointer ;sarani 4de waru
	a8
	txa
	ora	sprites_sub,y
	sta	sprites_sub,y

	ply
	plx
	rtl
;=====================================================================
;*			Set Sprite Size		[double buffer]	*
;=====================================================================
ChangeSprSize_Big_DB
	ai16
	tya
	cmp	#(128*4)+(128/4)
	bpl	.buf2		;if >= (128*4+128/4) THEN write buffer 2
.buf1
	kshiftRUA2	;oam (*0,*4,*8,*c)---->(*0,*1,*2,*3)
	tay
	and	#3
	tax
	sec
	lda	#0
.loop
	rol	a
	rol	a
	dex
	bpl	.loop
	tax		;Keep OAM size bit
	tya
	kshiftRUA2
	tay		;Set sprites sub pointer
.SetSprsubBuf1
	a8
	txa
	ora	sprites_sub,y
	sta	sprites_sub,y
	jmp	.SetSprsubEND
;--------------------------------------------------------------------
.buf2
	longa
	sec
	sbc	#(128*4)+(128/4)

	kshiftRUA2	;div4 :oam 1 unit=4 byte
	tay
	and	#$03
	tax
	sec
	lda	#0
.loop2
	rol	a
	rol	a
	dex
	bpl	.loop2
	tax
	tya
	kshiftRUA2
	clc
	adc	#(128*4)+(128/4)
	tay
.SetSprsubBUF2
	a8
	txa
	ora	sprites_sub,y
	sta	sprites_sub,y

.SetSprsubEND
	rts

	ENDC


;*****************************************************************************
;*****************************************************************************
;*****************************************************************************
;*****************************************************************************
;*									*
;*			DEBUG MODE					*
;*									*
;*****************************************************************************
;*****************************************************************************
;*****************************************************************************
;*****************************************************************************
	ifne	kginfo
SprDbugMode1
	IFEQ	0
	shorta
	longi
	km_pushallreg
	db7e

	km_bitcheckgameflag	keydisable
	bne	.END

;--------- Sprites value ------------
	a8
	km_bitcheckscreenflag	oamtensou
	beq		.buf2
.buf1
	a16
	lda	sprpointer
	lsr	a
	lsr	a
	bra	.sprnumberEND	
.buf2
	a16
	lda	sprpointer
	sec
	sbc	#(obj_val*4)+(obj_val/4)
	lsr	a
	lsr	a
.sprnumberEND
;	cmp	#129
;	bcc	.numberOK
;	jmp	.spr_blink
.numberOK
	printd	sprites
.END
	a8
	km_pullallreg
	ENDC
	rts

.spr_blink
	a8
	kbug4
	blink	3

	endc

	incfile	sprsub.asm
