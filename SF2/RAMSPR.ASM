
;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         RAMSPR.ASM                                          ;
; AUTHOR:       YASUHIRO KAWAGUCHI                                  ;
; DESCRIPTION:  Code for generating sprites (heiko suru code)       ;
; DATE CREATED: 31-3-94                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
	incpub	ramspr

;SetSprDamageMeter_l
;Yajirushi_inRadar_l
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
missHpchroff	equ	$5
missHP0	equ	$2
missHP1	equ	$1
missHP2	equ	$1
missHP3	equ	$1
missHP4	equ	$0
;--------------------------------------------------------------------
	shorta
	longi

	IFEQ	1
SetSprDamageMeter_l
	phx
	storenasty
	nastyon

	a16
	ldx	#0		;(X,Y) Initial Pointer
.loop
;(X,Y)zahyo Set
	lda.l	SprDmMeterOffSet,x
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
	cmp	#3
	beq	.HP3		;HP = 3
	cmp	#2
	beq	.Hp2		;HP = 2
	bra	.HP1		;HP = 1
;-----------------------------------
.HP0
	lda	#missHP0
	bra	.SetCharacter
;-----------------------------------
.HP1
;	stz	kz_x1
;	lda	#missHP1
;	bra	.SetCharacter
;-----------------------------------
.HP2
;	stz	kz_x1
;	lda	#missHP2
;	bra	.SetCharacter
;-----------------------------------
.HP3
	stz	kz_x1
	lda	#missHP3
	bra	.SetCharacter
;-----------------------------------
.HPmore4
	km_substaval	kz_x1,4
	lda	#missHP4
;-----------------------------------
.SetCharacter
	km_SetSpriteChrA	missHpchroff,colpal3,pri2,noflip
;-----------------------------------
.StepCounter
	inx
	inx
	cpx	#20
	bne	.loop
;--------------------------------------------------------------------------
.end
	a8
	restorenasty
	plx
	rtl

SprDmMeterOffSet
	dw	$0000,$0008,$0010,$0018,$0020
	dw	$0800,$0808,$0810,$0818,$0820
	ENDC

;---------------------------------------------------------------------
;*								*
;*		Yajirushi Character Table			*
;---------------------------------------------------------------------
YajiTable
;all data = 32 byte
;data :OBJ character No&Attribute
	dw	0!obj_noflip,1!obj_noflip,2!obj_noflip,3!obj_noflip
	dw	4!obj_yflip,3!obj_yflip,2!obj_yflip,1!obj_yflip
	dw	0!obj_xyflip,1!obj_xyflip,2!obj_xyflip,3!obj_xyflip
	dw	4!obj_xflip,3!obj_xflip,2!obj_xflip,1!obj_xflip

;*********************************************************************
;*								*
;*		Set Sprites in Radar	[in parallel]		*
;* Data Bank 7e							*
;* Mem8,idx16							*
;* Yreg :sprites pointer						*
;*								*
;*********************************************************************
SetSprites_inRadar_l
	shorta
	longi
	km_bitcheckmissionflag	enemyrunaway
	km_bne	SetSprites_inRadarEnd

	storenasty
	nastyon
;=====================================================
;*		Yajirushi in Radar		*
;* Yreg :sprites pointer				*
;=====================================================
Yajirushi_inRadar
	a16
	lda	ksproffx
	sta	sprites,y	;Set obj (x,y) pos
	iny
	iny

;---- Get chr No from player 1 angle ----
	lda	kroty		;Get player angle
	clc
	adc	#8
	km_loba
	km_shiftRUA4
	asl	a
	tax
	lda.l	yajitable,x


	ifeq	1
	bmi	.YajiMore180
.YajiLess180
	clc
	adc	#8
	km_shiftRUA4
	cmp	#08
	bpl	.Yajijust180

	a16
	and	#$ff
	bra	.Yaji_End
.YajiMore180
	a16
	lda	#(yflip<<14)
	bra	.Yaji_End

.YajiMore180
	shorta
	nega
	clc
	adc	#8
	km_shiftRUA4
	cmp	#08
	beq	.YajiJust180
	a16
	and	#$ff
	ora	#(xflip<<14)
	endc

.Yaji_End
	longa
	clc
	adc	#(obj_offset+YajiChr)!(colpal0<<9)!(pri2<<12)	
	sta	sprites,y
	iny
	iny
	a8
;=====================================================
;	Enemy character in Radar		*
;* Alien List Check					*
;* Data Bank 7e					*
;* Mem8,idx16					*
;* Xreg :Alien pointer				*
;* Yreg :sprites pointer				*
;* (kwork+0)(kwork+2)(kwork+4) :(X,Y,Z)		*
;* kwork+6 :radar on charcater No			*
;* kwork+8 :check enmey radar in			*
;* kwork+10:character change 0/1 ... nashi/ ari	*
;* tmp work :kz_x1,kz_y1,kz_z1,kz_tpa,kz_textpt	*
;=====================================================
Enemy_inRadar
	ai16

;* run away flag ga sudeni tatte iruka check *
	km_bitcheckmissionflag	enemyrunaway
	km_bne	.not_enemygone
;===================== Alien List Check ======================
;* initial *
	km_setval	kwork+8,0
	km_setval	kwork+10,0

;* radara character (up/middle/down) change check *
	lda	kx_radarscale
	cmp	#1
	bpl	.not_charchange	;(radar scale >=1)
	inc	kwork+10
.not_charchange
;------------ Are There alien in alien list ? ----------
	ldx	allst		;alien pointer
	bne	.NextAlien	;if = 0 :alien nothing
;* No Alien *
	brl	.exit
;------------ Check Alien Radar ON/OFF -----------
.NextAlien
	km_loblda.w	al_radarobj,x
	bne	.SetAlien
;------------- Next pointer set & End Check ------------
.Set_next_pnt
	lda.w	_next,x
	tax
	bne	.NextAlien	;If haven't finished Alien List Check
	jmp	.exit

;======================== Alien Set ==========================
.SetAlien
	longa
	longi
;------ sprite character keep (kvars.inc ni label ari !!)-------
	sta	kz_tpa		;character No Keep
;------ sprites (x,y) coordinates set ------
	lda.w	al_worldx,x
	sec
	sbc	kpx
	sta	kz_x1		;(alien z pos)-(player z pos)

	lda	kpz
	sec
	sbc.w	al_worldz,x	;(player z pos) - (alien z pos)
	sta	kz_z1

;1994/12/26 :enemy radar in check
;* enmey ka douka check (kz_textpt... 0/1) *
	stz	kz_textpt
	lda	kz_tpa
	cmp	#ra_entrance
	beq	.emable_areacheck
	cmp	#ra_enemy
	bne	.notenemy
.emable_areacheck
	inc	kz_textpt	;enemy flag ON
.notenemy
	bit	#$80
	beq	.set
	and	#$7f
	xba
	ora	#ra_base
	sta	kz_tpa

	lda	kwork+10
	bne	.auto_scale
;*radar range 10000 or 20000 *
	dec	kz_tpa		;min char
	bra	.set
.auto_scale
;-------	radar height --------
	lda.w	al_worldy,x
	sec
	sbc	kpy
	sta	kz_y1
;;;;	lda	kz_y1
	cmp	#-mradar_hight
	bmi	.up
	cmp	#mradar_hight
	bpl	.down
	bra	.set
.up
	inc	kz_tpa
	bra	.set
.down
	dec	kz_tpa
	bra	.set
;***** Sprite Set ******
.set
	jsr	SetRadarSprite_sub
	bcs	.areaout
.areain
	lda	kz_textpt
	beq	.areaout	;Enemy ja nakattara !!
	inc	kwork+8		;subete area out shiteitara !!
.areaout
	brl	.Set_next_pnt
;-----------------------------------------------------
;* enemy ga nigetaka check *
.exit
	ifeq	kenemygone
	a16
;* zaco,missile ka douka check *
	km_bitcheckmismapflag	autoradar	;moshi planet (ground)dattara !!
	beq	.not_enemygone
;* Enemy ga subete nigeta ka check *
	lda	kwork+8
	bne	.not_enemygone		;(1pki demo radar no naka nara)!!

	km_bitcheckmissionflag	enemygonefreeze
	bne	.not_enemygone
.enemy_gone
	km_setmissionflag	enemyrunaway
	ENDC
.not_enemygone
	a8
;=====================================================
;		Building in Radar		*
;* Inert List Check					*
;* Xreg :Radar Map List pointer			*
;* Yreg :sprites pointer				*
;=====================================================
;'95/6/20 :comment :mou kotibutu wa dashite inai !!
	IFEQ	1
Build_inRadar
	ai16
;;;;	km_ldxrdmapptr

	ldx	#0
	lda	KRDMapBuffer+0,x
	and	#$ff
	km_beq	.exit		;No Object
	sta	kcounter
;---------------------------------------------------------------------
;------ sprites (x,y) coordinates set ------
.LOOP
	longa
	lda	KRDMapBuffer+2,x
	sec
	sbc	kpx
	dec	a
	sta	kz_x1
	lda	kpz
	sec
	sbc	KRDMapBuffer+4,x
	sta	kz_z1
	lda	KRDMapBuffer+6,x
;;;	ora	#obj_colpal5
	sta	kz_tpa
	jsr	SetRadarSprite_sub
.Set_next_pnt
	dec	kcounter
	beq	.exit
	txa
	clc
	adc	#RadarMapDataVal
	tax	
	brl	.LOOP
.exit
	a8

	ENDC
;=====================================================
;	 Out of Map waku in Radar		*
;* Xreg :Map Data Pointer				*
;* Yreg :sprites pointer				*
;* work+1:obj prio syusei				*
;=====================================================
MapWaku_inRadar
;* yajima sprite routine *
	km_bitcheckgameflag	battle
	bne	.notdisplay
	jsl	yjradar_l	;(For Yajima's)
.notdisplay

	IFEQ	1
	shorta
	longi
	km_bitcheckgameflag	noareaout
	km_bne	.MapWakuEnd
;*** Mission :OBJ pri = 1 ***
;*** Battle  :OBJ pri = 3 ***
	a16
	lda	#%0010000000000000
	sta	kwork		;Radar Waku = pri 3(For Mission)
	bra	.skip
.battle
	a16
	stz	kwork		;Radar Waku = Pri 1(for battle)
.skip
;--------------------------------------------------------------------------
	longa
	longi
	km_ldx	kmapptr
	lda.l	MapWakuTable,x
	tax
;------------ Are There Map Waku in area ? ----------
.next
	lda.l	MapWakuData,x
	cmp	#$8000		;END CODE Check
	km_beq	.exit
.MapSet	stx	kpointer
;------ Set Player 1 (x,y)&character ------
	lda.l	MapWakuData,x
	clc
	adc	kmapoffx
	sec
 	sbc	kpx		;(player x pos) - (map waku x pos)
; check in radar
	km_braareaout	kareaminX,kareamaxX,.Set_NextMap_pnt
	km_radarscale	128
	xba			;1dot = 128
	a8
	clc
	adc	ksproffx	;attention please!
	sta.w	sprites,y	;Set sprite x pos
	a16
	inx
	inx

	lda.l	MapWakuData,x
	clc
	adc	kmapoffz
	sec
	sbc	kpz		;(player z pos) - (map waku z pos)
	nega
;check in radar
	km_braareaout	kareaminZ,kareamaxZ,.Set_NextMap_pnt
	km_radarscale	128
	a8			;2
	xba			;3
	clc			;2
	adc	ksproffy	;4 ;(x,y) Hosei
	sta.w	sprites+1,y	;5 ;Set  sprite (x,y) pos
	a16			;2 ;20cycle

	iny
	iny

	inx
	inx
	lda.l	MapWakuData,x
	ora	kwork		;OBJ priority syusei
	sta.w	sprites,y	;Set  sprite character

	iny
	iny

.Set_NextMap_pnt
	lda	kpointer
	clc
	adc	#6
	tax
	jmp	.next

.MapWakuEnd

	ENDC
;**************************************************************************
;==========================================================================
;--------------------------------------------------------------------------
.exit
	a8
	restorenasty
SetSprites_inRadarEnd
	rtl

;=====================================================================
;*								*
;*		Set Radar Character				* 
;* a16i16								*
;*Init :kz_x1 :relative X						*
;*     :kz_z1 :relative Z						*
;*     :kz_tpa:character No						*
;* OutPut	:clc :Radar area IN					*
;*	:sec :Radar area Out					*
;* temporary work :kz_x2,kz_z2,kz_tpx,kz_tpy				*
;* Keep :Xreg (Alien Pointer)					*
;=====================================================================
SetRadarSprite_sub_l
	jsr	SetRadarSprite_sub
	RTL
;---------------------------------------------------------------------
SetRadarSprite_sub
	longa
	longi
	PHX		>>> Alien Pointer PUSH
;---------------------------------------------------------------------
	km_setvar	kz_x2,kz_x1
	km_setvar	kz_z2,kz_z1

	lda	kx_radarscale
	beq	.NormalScale
	bit	#$8000
	BNE	.ZOOM_up
;---------------------------------------------
.ZOOM_Down
	tax
.loop1
	lda	kz_x2
	km_asra
	sta	kz_x2

	lda	kz_z2
	km_asra
	sta	kz_z2
	dex
	bne	.loop1
	bra	.RadarOutCheck
;---------------------------------------------
.ZOOM_UP
	nega
	tax
.loop2
	asl	kz_x2
	asl	kz_z2
	dex
	bne	.loop2
;---------------------------------------------
.NormalScale
;---------------------------------------------
.RadarOutCheck
;check in radar
	lda	kz_x1
	km_asra		;<<<<
	km_braareaout	kx_radarmin,kx_radarmax,.End
; check in radar
	lda	kz_z1
	km_asra		;<<<<
	km_braareaout	kx_radarmin,kx_radarmax,.End

;* X zahyou *
	lda	kz_x2
;;;;	km_radarscale	128
	xba
	a8
	clc
	adc	ksproffx
	pha			;sprite X zahyou Push
	a16
;* Y zahyou *
	lda	kz_z2
;;;;	km_radarscale	128
	km_hiba			;Low byte = 0 :(hosei wo kuwaetemo Low byte wo henka sasenai tame)
	clc
	adc	ksproffx	;(X,Y)pos Hosei
	a8
	pla			;sprite X zahyou Pull
	a16
	sta.w	sprites,y	;Set sprite y pos
	iny
	iny
;---- Set Sprites Charcter --
	lda	kz_tpa
	km_SetSpriteChrA	0,colpal0,pri2,noflip

	plx
	clc		;radar area in
	rts

.end
	plx		<<< Alien Pointer PULL
	sec		;radar area out
	rts

;*********************************************************************
;*								*
;*			Map Waku Data				*
;*								*
;*********************************************************************
	IFEQ	1
MapWakuTable
	dw	(MapWakuData55-MapWakuData)	;0
	dw	(MapWakuData55-MapWakuData)	;2
	dw	(MapWakuData55-MapWakuData)	;4
	dw	(MapWakuData55-MapWakuData)	;6
	dw	(MapWakuData55-MapWakuData)	;8

;=====================================================================
;*		FIELD MAP AREA 	(10240*10240)	[5chr * 5chr]	*
;=====================================================================

;**** LABEL ****
rad1dotlength	equ	256>>radscale		;1dot no nagasa
wkhosei		equ	4*rad1dotlength		;waku no hosei (0.5 chr)
radlength		equ	8*rad1dotlength		;1 chr no nagasa
;---------------------------------------------------------------------------
MapWakuData
MapWakuData55
	ifeq	radscale
mapchr = 5
wakusx = (-(mapchr-1)*8*256)/2
wakusy = (-(mapchr-1)*8*256)/2

;1	(1dot.. 256 ,1chr .. 2048 (256*8)) 
mapoffset = 0
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = mapoffset+1

	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+2048*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;2 - 4
	REPT	mapchr-1
	dw	wakusx+0,wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+2048*(mapchr-1),wakusy+2048*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;5
	dw	wakusx+0,wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,yflip
mapoffset = 1
	REPT	mapchr-2
	dw	wakusx+2048*mapoffset,wakusy+2048*0
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+2048*(mapchr-1),wakusy+0
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------
;end code
	dw	$8000
;---------------------------------------------------------------------
;*		Scale 2 Times Ver				*
;---------------------------------------------------------------------
	elseif

mapchr = 5<<radscale
;wakusx = (-(mapchr-1)*8*256-4*256)/2	;4608
;wakusy = (-(mapchr-1)*8*256-4*256)/2
wakusx = -mapchr*radlength/2+wkhosei
wakusy = wakusx
;1	(1dot.. 128 ,1chr ..  (8dot*128)) 
mapoffset = 0
	dw	wakusx+radlength*mapoffset,wakusy+radlength*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,noflip

mapoffset = mapoffset+1
	REPT	mapchr-2
	dw	wakusx+radlength*mapoffset,wakusy+radlength*(mapchr-1)
	SprChrDataW	WakuChr1,colpal0,pri1,noflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+radlength*(mapchr-1),wakusy+radlength*(mapchr-1)
	SprChrDataW	WakuChr0,colpal0,pri1,xflip
;---------------------------------------------------------------------------
;2 - 9
	REPT	mapoffset	;mapchr-2
	dw	wakusx+0,wakusy+radlength*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,noflip

	dw	wakusx+radlength*(mapchr-1),wakusy+radlength*mapoffset
	SprChrDataW	WakuChr2,colpal0,pri1,xflip
mapoffset = mapoffset-1
	ENDR
;---------------------------------------------------------------------------
;10
mapoffset = 0
	dw	wakusx+radlength*mapoffset,wakusy
	SprChrDataW	WakuChr0,colpal0,pri1,yflip

mapoffset = mapoffset+1
	REPT	mapchr-2
	dw	wakusx+radlength*mapoffset,wakusy
	SprChrDataW	WakuChr1,colpal0,pri1,yflip
mapoffset = mapoffset+1
	ENDR

	dw	wakusx+radlength*mapoffset,wakusy
	SprChrDataW	WakuChr0,colpal0,pri1,xyflip
;---------------------------------------------------------------------------
;end code
	dw	$8000
	endc
MapWakuData55End

	ENDC


;=====================================================
;	Enemy character in Radar		*
;* Alien List Check					*
;=====================================================

	IFEQ	1
; Z zahyou  (check in radar)
	lda	kwork+4		;kpz
	sec
	sbc.w	al_worldz,x	;(player z pos) - (alien z pos)
	km_braareaout	#radar_min,#radar_max,.Set_next_pnt
	km_radarscale	128
	km_hiba
	sta.w	sprites,y	;Set sprite y pos

; X zahyou  (check in radar)
	lda.w	al_worldx,x
	sec
	sbc	kwork+0		;kpx
	km_braareaout	#radar_min,#radar_max,.Set_next_pnt
	km_radarscale	128
	xba
	km_loba
	ora.w	sprites,y	;ora X zahyo
	clc
	adc	ksproffx	;(X,Y)pos Hosei
	sta.w	sprites,y	;Set  sprite (x,y) pos

	iny
	iny
;-------	radar height --------
	lda.w	al_worldy,x
	sec
	sbc	kwork+2		;kpy
	cmp	#-fradar_hight
	bmi	.upper
	cmp	#-mradar_hight
	bmi	.up
	cmp	#fradar_hight
	bpl	.downer
	cmp	#mradar_hight
	bpl	.down
.normal
	lda	kz_z1
	ora	#$0200
	sta	kz_z1
	bra	.set
.upper
	lda	kz_z1
	bra	.set
.up
	lda	kz_z1
	bra	.set
.down
	lda	kz_z1
	ora	#$0400
	sta	kz_z1
	bra	.set
.downer
	lda	kz_z1
	ora	#$0400
	sta	kz_z1
	bra	.set
.set
	LDA	kz_z1
	AND	#$f1ff
	km_SetSpriteChrCol	0,pri2,noflip
	ENDC
