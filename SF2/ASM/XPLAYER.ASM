;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º FILE:                XPLAYER.ASM                   º
;º AUTHOR:              Takumi Kawagoe  		 º
;º                      Nintendo.co.ltd  EDA          º
;º DESCRIPTION  :       PLAYER CONTROL ROUTINE(part2) º
;º DATE CREATED :       30-4-93                       º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

	INCPUB	xplayer

	SHORTA
	LONGI

;---------------------------------------------------------------------------

effectpath_init_srou_l

	jsr	effectpath_init_srou

	rtl



effectpath_init_srou

	s_start_strat

	php

	a8i16

	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat

	pl_set_area	y,-1
	s_set_aldata	y,#1,#1
	s_set_alsflag	y,realobj

	s_copy_pos	y,x
	s_copy_rots	y,x

	s_set_alsflag	y,active
	s_clr_colltype	y,ENEMY1
	s_set_alsflag	y,colldisable

; sflag10 player2's child

;***	s_clr_alsflag		y,sflag10
;***	s_jmpnot_alsflag	x,player2,.exit
;***	s_set_alsflag		y,sflag10


.exit	plp

	rts


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                    º
;º      YOU LOST      º
;º                    º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
makeyoulost_srou_l
	s_start_strat
	PUSHYP
	a8i16
	s_make_obj	#nullshape,makeyouwin_srou_l.badobj
	s_set_path	y,youlost
	bra	makeyouwin_srou_l.enter
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                    º
;º      YOU WIN       º
;º                    º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
makeyouwin_srou_l
	s_start_strat
	PUSHYP
	a8i16
	s_make_obj	#nullshape,.badobj
	s_set_path	y,youwin
.enter	LOCAL
	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
	jsr	effectpath_init_srou
	PULLYP
	sec
	rtl
.badobj	LOCAL
	PULLYP
	clc
	rtl
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                                               ³
;³ umi no nakaka douka wo check suru..           ³
;³ use macro "pl_check_inthesea"(see tmacros.inc)³
;³                                               ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

checkinthesea_srou_l

seadepthoffset	equ	50
cis_flag		equ	work9
cis_flag_outsplash	equ	1<<7
cis_flag_innsplash	equ	1<<6
rcp_robostatus_bak	equ	work8
rcp_worldy		equ	work7
;rcp_sound		equ	work6

	s_start_strat

	PUSHXYP
	a8i16


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; freeze pros.
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	km_jmpnotgameflag	freeze,.exitfreeze

	pl_test_planetmode	marine
	rlbne			.exitfreeze

;-------------------------------------------------------------------

	toheap	y,x

	PHY	;-->>


	lda	exal_VIEWflag3,y
	and	#~(exal_VIEWflag3_outsea_trig!exal_VIEWflag3_insea_trig)
	sta	exal_VIEWflag3,y

	pl_ldy_viewblk	x




	a16
	lda.w	al_worldy,y

	PLY	;<<--

	sec
	sbc	SEADEPTH

	a8
	bmi	.Fon

;-------------------------------------------------------------------
.Fin
; transfall=on de,player suijyou,camera suityu- no jyoutai wa ERROR !

;	pl_jmpnot_iftransfalling	x,.notfall,y
;	pl_jmp_ifinthesea	x,.Fon
;.notfall

	lda	exal_VIEWflag2,y
	bit	#exal_VIEWflag2_inthesea
	bne	.Fset
	ora	#exal_VIEWflag2_inthesea
	sta	exal_VIEWflag2,y

	lda	exal_VIEWflag3,y
	ora	#exal_VIEWflag3_insea_trig
	sta	exal_VIEWflag3,y

	bra	.Fset

.Fon	lda	exal_VIEWflag2,y
	bit	#exal_VIEWflag2_inthesea
	beq	.Fset
	and	#~exal_VIEWflag2_inthesea
	sta	exal_VIEWflag2,y

	lda	exal_VIEWflag3,y
	ora	#exal_VIEWflag3_outsea_trig
	sta	exal_VIEWflag3,y

.Fset
;-------------------------------------------------------------------

	jmp	.exitdust

.exitfreeze
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	check start
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	toheap	y,x

; copy al_slopeptr --> exal_poolptr

	s_copy_alvar2alvar	W,y,exal_poolptr,x,al_slopeptr

	sp_jmp_playertype	x,ARWING,.ARWING,y

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; ROBOT ga pool no naka ni iruka check suru....
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.ROBOT

	rb_get_bodypos	rcp_worldy,x,y

; clear flags

	lda	exal_robostatus,y
	and	#exal_robostatus_depthlevelmask
	sta	rcp_robostatus_bak

	s_and_alvar		B,y,exal_robostatus,#exal_robostatus_depthlevelmask^-1
	jsl	checkYclip_srou_l
	rlbcc	.clrf

; set flag

	s_copy_alvar2var	W,y,y1,exal_pooldepth

; ZENBU?
	a16
	lda	rcp_worldy
	clc
	adc	#-15		;atama no o-kisa
	cmp	y1
	a8
	bpl	.ZENBU
; ATAMA?
	a16
	lda	rcp_worldy
	cmp	y1
	a8
	bpl	.ATAMA
; KAO?
	a16
	lda	rcp_worldy
	clc
	adc	#15		;atama no o-kisa
	cmp	y1
	a8
	bpl	.KAO
; ASHI?
	a16
	lda	rcp_worldy
	clc
	adc	#45		;ashi no nagasa
	cmp	y1
	a8
	bpl	.ASHI

; set flag & level

.UE	s_or_alvar	B,y,exal_robostatus,#exal_robostatus_DLue
	bra		.clrf
.ASHI	lda		#exal_robostatus_DLashi
	bra		.setf
.KAO	lda		#exal_robostatus_DLkao
	bra		.setf
.ATAMA	lda		#exal_robostatus_DLatama
	bra		.setf
.ZENBU

	pl_test_planetmode	marine
	rlbne			.Z0

	pl_jmp_ifinthesea	x,.Z0
	pl_set_intheseaflag	x

	kplsound		x,inmarine

.Z0	lda		#exal_robostatus_DLzenbu
.setf	ora		exal_robostatus,y
	sta		exal_robostatus,y
	s_set_clipping	x,pool1
	bra		.exitf

.clrf	s_set_clipping	x,off
	pl_clr_intheseaflag	x

.exitf	s_jmp_alvarZERO		B,x,al_vy,.nobodysplash

	toheap	y,x

;************

	lda	exal_robostatus,y
	and	#exal_robostatus_depthlevelmask

	cmp	rcp_robostatus_bak
	rlbeq	.nobodysplash
	sta	tpx

	lda	rcp_robostatus_bak
	cmp	tpx
	rlbeq	.nobodysplash
	bpl	.outck

.inck
	lda	rcp_robostatus_bak
	cmp	#exal_robostatus_DLkao
	rlbpl	.nobodysplash

	lda	tpx
	cmp	#exal_robostatus_DLkao
	rlbmi	.nobodysplash
	bra	.in

.outck
	lda	rcp_robostatus_bak
	cmp	#exal_robostatus_DLkao
	rlbcc	.nobodysplash
	lda	tpx
	cmp	#exal_robostatus_DLkao
	rlbpl	.nobodysplash


.out	s_jmp_alvarZERO		W,y,exal_poolptr,.nobssound
	kplsound		x,outmarine
	bra			.nobssound
.in	s_jmp_alvarZERO		W,y,exal_poolptr,.nobssound
	kplsound		x,inmarine

.nobssound
	s_set_vartobeobj	x2,x
	pl_splash		x,#0,#0,#0,#7

.nobodysplash


.exitCHECKPOOL

	jmp	.exitCHECKSEA

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; ARWING ga umi no naka ni irunoka check suru..
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.ARWING

	toheap	y,x

	s_set_var		B,cis_flag,#0

; now flag ON or OFF ?

	pl_jmpNOT_ifinthesea	x,.off

.on	jsr		.check
	rlbcs		.setseaf
	s_or_var	B,cis_flag,#cis_flag_outsplash
	bra		.clrseaf

.off	jsr		.check
	bcc		.clrseaf
	s_or_var	B,cis_flag,#cis_flag_outsplash


.setseaf
	pl_set_intheseaflag	x
	s_set_alvar		B,y,exal_pooltype,seatype
	s_set_alvar		B,y,exal_poolptr,#0
	bra			.seaeffect
.clrseaf

	pl_clr_intheseaflag	x

.endseaf



.seaeffect	pl_jmp_ifonthe	x,sand,.exitseaeffect,y

	lda		cis_flag
	bit		#cis_flag_innsplash
	rlbne		.inneffect
	bit		#cis_flag_outsplash
	rlbeq		.exitseaeffect

.outeffect
;	bra	.geneffect
	bra	.exitseaeffect

.inneffect
	kplsound	x,inmarine

.geneffect
	pl_splash	x,#0,#0,#0,#7
	s_and_alvar	B,y,eal_pbyte1,#roboJMP1_flag^-1


.exitseaeffect


	pl_jmpnot_iftransrising	x,.exitCHECKSEA,y

	s_set_clipping	x,pool1


.exitCHECKSEA

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	check VIEW!(only marine mode)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	pl_test_planetmode	marine
	rlbne			.exitviewck

; clear in(on)b the sea trigger( for path routine)

	s_and_alvar	B,y,exal_VIEWflag3,#~(exal_VIEWflag3_insea_trig!exal_VIEWflag3_outsea_trig)

	pl_ldy_viewblk	x
	a16
	lda.w	al_worldy,y
	sec
	sbc	SEADEPTH

	a8
	bmi	.onmarine

;-------------------------------------------------------------------

.inmarine	toheap		y,x

	s_jmp_alvarAND	B,y,exal_VIEWflag2,#exal_VIEWflag2_inthesea,.inmarine_on

	jsl		cc_marinecol_l

	s_or_alvar	B,y,exal_VIEWflag2,#exal_VIEWflag2_inthesea
	s_or_alvar	B,y,exal_VIEWflag3,#exal_VIEWflag3_insea_trig!exal_VIEWflag3_splash


.inmarine_on	s_or_alvar	B,y,exal_VIEWflag2,#exal_VIEWflag2_intheseareally

.notinreally	jmp		.exitviewck

;-------------------------------------------------------------------

.onmarine	toheap		y,x

	s_jmpnot_alvarAND	B,y,exal_VIEWflag2,#exal_VIEWflag2_inthesea,.onmarine_on

	s_and_alvar		B,y,exal_VIEWflag2,#exal_VIEWflag2_inthesea^-1

	jsl		cc_mistcol_l

	s_or_alvar	B,y,exal_VIEWflag3,#exal_VIEWflag3_outsea_trig!exal_VIEWflag3_splash
	kplsound	x,outmarine
	pl_splash	x,#0,#0,#0,#7

.onmarine_on	s_and_alvar	B,y,exal_VIEWflag2,#exal_VIEWflag2_intheseareally^-1

.notonreally

;-------------------------------------------------------------------
.exitviewck

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	set depth offset
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	lda	exal_depthno,y
	bmi	.depthend

	pl_jmpnot_ifinthesea	x,.depth0

	lda	#2
	sta	exal_depthno,y
	bra	.depthend

.depth0	s_set_alvar	B,y,exal_depthno,#0

.depthend

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Set depth Q
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	pl_test_planetmode	marine
	bne			.exitdepthQ

	pl_jmp_ifcamintheseareally	x,.depth_in

.depth_on	ramnastyoff
	setdepth	mist
	set_zdepthtable	sky
	ramnastyon
	bra		.exitdepthQ

.depth_in	ramnastyoff
	setdepth	night
	set_zdepthtable	marine
	ramnastyon

.exitdepthQ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; set dust flag
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	pl_test_planetmode	marine
	rlbne			.exitdust

	POLL_MARIO

	pl_jmp_ifcaminthesea	x,.insea

.onsea	a16

	lda	#-1500
	sta	stardustheight

	lda	SEADEPTH
	sta.l	shadowheight

	lda	#0	;#df_sprites
	sta.l	m_dustflags

	lda	#dusttable_kusa
	sta.l	m_dustsprite
	lda	#16
	bra	.unpoll


.insea	a16
	lda	#0
	sta.l	shadowheight

	lda.l	m_dustflags
	ora	#df_bubbles
	ora	#df_sprites
	sta.l	m_dustflags

	lda	#dusttable_awa
	sta.l	m_dustsprite
	lda	#16
.unpoll	sta.l	m_dustsize

	a8
	UNPOLL_MARIO

.exitdust

;-------------------------------------------------------------------
	PULLXYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.check
	a16
	lda	SEADEPTH
	a8
	beq	.checkOFF

	sp_jmp_playertype	x,ROBOT,.RBpos


.AWpos	a16
	lda	al_worldy,x

	bra	.add


.RBpos	a16
	lda	rcp_worldy
.add
	sec
	sbc	SEADEPTH
	a8
	bmi	.checkOFF

.checkON	sec	; in the sea
	rts

.checkOFF	clc	; not in the sea
	rts


makebubble_srou_l

;	in	:x1 offset x
;		:x2 pointer
;	using	:al_pword1 depth of sea
;		:al_pbyte1 offset x
;		:al_sword1 vy

	PUSHXYP

	s_start_strat

	a8i16

	s_count_childs	x,tpx

	lda	tpx
	cmp	#5
	rlbcs	.badobj


	sp_jmp_playertype	x,ARWING,.skip

	pl_jmpnot_ZENBUinpool	x,.badobj

.skip
	s_make_obj	#bubble,.badobj
	s_make_child	#childno_bubble

	a16
	tya
	sta.w	al_childrotobj,y
	a8


;************
	S_SET_ALSFLAG	Y,ACTIVE
;************

	pl_set_area	y,-1
	s_set_alptrs	y,.strat,hit_istrat,explode_istrat
	jsl		TSTRATsrous_l.initsprite

;	s_set_alvar	W,y,al_sword1,#-4	;vy
	s_set_alvar	W,y,al_sword2,x2	;pointer

	s_push_obj	x
	ldx		x2
	s_add_roffs2pos	B,y,x,x,x1,y1,z1,1,1,0
	s_pull_obj	x

	s_push_obj	y
	toheap		y,x
	s_copy_alvar2var	W,y,y1,exal_pooldepth
	s_pull_obj	y
	s_set_alvar	W,y,al_pword1,y1
	s_set_lifecnt	y,#10
	s_set_speed	y,#3
	s_set_alvar	B,y,al_rotx,#0
	s_add_rnd2pos	y,7,7,7
	s_set_alvar	B,y,al_pbyte1,gameframe
.badobj	PULLXYP
	rtl


.strat	s_set_strat	x,.strat2
	s_set_alvar	B,x,al_tx,#-5
	s_end_strat


.strat2	lda		gameframe
	clc
	adc		al_pbyte1,x
	and		#3
	sec
	sbc		#1
	bmi		.mi
	nega
.mi	sec
	sbc		#5
	sta		al_tx,x


	s_set_objtobealvar	y,x,al_ptr

	pl_jmp_ifcamintheseareally	y,.normal
	toheap			y,y
	s_copy_alvar2alvar	W,x,al_worldy,y,exal_pooldepth
	jmp			.life


.normal	toheap			y,y


	s_jmp_alvarZERO		B,y,exal_motiondir,.nochase

	s_set_objtobealvar	y,x,al_sword2
	s_achase_alvar2alvar	W,x,al_worldx,y,al_worldx,2
	s_achase_alvar2alvar	W,x,al_worldz,y,al_worldz,2
.nochase

	s_add_alvar	B,x,al_roty,#64
	s_gen_3Dvecs	x,al_roty,al_rotx,al_vel
	s_add_vecs2pos	x
	s_add_alvar	W,x,al_worldy,#-4

	s_jmp_higheralvar	x,al_pword1,.remove

.life	s_decbne_lifecnt	x,.alive
.remove	s_remove_obj		x
.alive	s_end_strat



;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º   ARWING'S Splash(wing)   º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makeMsplash_srou_l

	PUSHXYP

	a8i16

	s_make_obj	#msplash,makesplash_srou_l.badobj

	s_set_alptrs	y,.strat,hit_istrat,explode_istrat
	jmp		makesplash_srou_l.enter

.strat	;	LOCAL		; WARNING ! hoka demo tsukatte iruzo!!

	s_start_strat
	s_add_colanim	x,#1,#4,makesplash_srou_l.remove
	jmp	makesplash_srou_l.strat2

makesplash_srou_l

;	in	:x1 offset x
;		:z1 offset z
;		:z2 pos y
;		:y1 init colanim frame
;		:y2 size

	PUSHXYP

	a8i16

	s_make_obj	#splash,.badobj

	s_set_alptrs	y,.strat,hit_istrat,explode_istrat

.enter	LOCAL

	s_make_child	#childno_splash

	a16
	tya
	sta.w	al_childrotobj,y
	a8

;************
	S_SET_ALSFLAG	Y,ACTIVE
;************


	jsl		TSTRATsrous_l.initsprite
	s_sprite_obj	y,#0,y2
	s_init_colanim	y,y1
	s_add_roffs2pos	B,y,x,x,x1,#0,z1,0,1,1

	a16
	PHX
	toheap	x,x
	lda	exal_vx,x
	sta.w	al_vx,y
	lda	#0
	sta.w	al_vy,y
	lda	exal_vz,x
	sta.w	al_vz,y
	a8
	PLX

	s_set_alvar	B,x,al_tx,#4

.badobj	LOCAL
	PULLXYP
	rtl



.strat
	s_start_strat
	s_add_colanim	x,#1,#8,.remove

.strat2	LOCAL

	s_add_vecs2pos	x
	a16
	lda	al_vx,x
	jsl	perc62A_l
	sta	al_vx,x
	lda	al_vz,x
	jsl	perc62A_l
	sta	al_vz,x
	a8
	s_end_strat

.remove	LOCAL
	s_remove_obj		x
.end	s_end_strat





makehamon_srou_l

	s_start_strat

;	s_jmp_alvarZERO	W,x,al_slopeptr,.exit
	pl_jmp_ifonthe	x,magma,makeMhamon_srou_l
	pl_jmp_ifonthe	x,water,makeWhamon_srou_l

.exit	rtl

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                    º
;º   ROBOT'S hamon    º
;º                    º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
makeWhamon_srou_l

;	in	   : x1 < 0:left    >1:right
;	al_pbyte1  : work counter( for animation )
;	al_pbyte2  : x offset
;	sflag1	   : 0:L  1:R

	PUSHXYP
	a8i16
	s_make_obj	#splash,makesplashpool_srou_l.badobj
	s_set_var	B,y1,#7
	jmp		makeMhamon_srou_l.init

makeMhamon_srou_l


	PUSHXYP
	a8i16
	s_make_obj	#Msplash,makesplashpool_srou_l.badobj
	s_set_var	B,y1,#3

.init	LOCAL

	s_make_child	#childno_hamon

	a16
	tya
	sta.w		al_childrotobj,y
	a8

;************
	S_SET_ALSFLAG	Y,ACTIVE
;************

; offset x

	pl_get_shapeTAB		B,x,x2,hamonofstab

; L or R flag set

	s_jmp_varPL	B,x1,.R

.L	set_leftflag	y
	s_neg_var	B,x2
	bra		.LR
.R	set_rightflag	y

.LR	s_set_alvar	B,y,al_pbyte2,x2

	jsl		TSTRATsrous_l.initsprite

	s_init_colanim	y,y1

	s_set_alvar2rnd	y,al_pbyte1
	s_set_alptrs	y,.strat,hit_istrat,explode_istrat

	s_exg_objs
	jsr			.calcpos
	jsr			.setflag
	s_exg_objs

	s_set_alsflag		y,realobj
	s_set_alvartobeobj	y,al_ptr,x


.badobj	LOCAL
	PULLXYP
	rtl



.strat

; remove suruka douka check suru..

	s_set_objtobealvar	y,x,al_ptr

	pl_jmp_ZENBUinpool	y,.remove
	pl_jmpnot_ASHIinpool	y,.remove
	pl_jmp_ifonthe		y,GROUND,.remove
	pl_jmp_motionNoNE	y,stop,.remove
	sp_jmp_playertype	y,ARWING,.remove

	jsr	.calcpos
	jsr	.setflag

	s_add_rnd2pos		x,3,0,3

	lda		al_pbyte1,x
	dec		a
	sta		al_pbyte1,x
	and		#3
	nega
	clc
	adc		#-2
	sta		x1
	s_sprite_obj	x,#0,x1

	s_end_strat

.remove	s_remove_obj	x
	s_end_strat




.setflag	s_push_obj	x
	s_push_obj	y
	s_set_objtobealvar	y,x,al_ptr
	jmp_ifrightfoot		x,.Rflag
.Lflag	ldx		al_sword2,y
	s_or_alvar	B,x,exal_robostatus,#exal_robostatus_hamonL
	bra		.exitflag
.Rflag	ldx		al_sword2,y
	s_or_alvar	B,x,exal_robostatus,#exal_robostatus_hamonR
.exitflag	s_pull_obj	y
	s_pull_obj	x

	rts




.calcpos	s_copy_alvar2var	B,x,x1,al_pbyte2
	s_add_roffs2pos		B,x,y,y,x1,#0,#0,0,1,0
	s_push_obj		y
	s_push_obj		x
	ldx			al_sword2,y
	txy
	s_pull_obj		x
	s_copy_alvar2alvar	W,x,al_worldy,y,exal_pooldepth
	s_pull_obj		y

	rts



hamonofs_FF	equ	17	; mata no haba
hamonofs_SP	equ	20	; mata no haba
hamonofs_GG	equ	10	; mata no haba


hamonofstab	; mata no haba

	shapetab	B,hamonofs_



;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                          º
;º   effect for CLIPPING    º
;º                          º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makeclipeffect_l

	s_start_strat

	a8i16

	pl_jmp_ifonthe		x,magma,makeMsplashpool_srou_l
	pl_jmp_ifonthe		x,sand,.sand
	pl_jmp_zenbuinpool	x,.zenbu


	jmp			makesplashpool_srou_l
.zenbu
	jmp			makebubble_srou_l

.sand

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                          º
;º   ROBOT'S smoke(ryusa)   º
;º                          º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makesmokeryusa_srou_l
;	in	:x1 offsetx
;		:z1 offsetz
;		:y1 init colanim frame
;		:x2 leg(or body)'s pointer
	PUSHXYP
	a8i16


	s_count_childs	x,tpx

	lda	tpx
	cmp	#5
	rlbcs	.badobj


	s_make_obj	#smoke,.badobj
	s_make_child	#childno_smoke
	pl_jmpnot_ifonthe	x,sand,.normal,y
	s_set_alvar	B,y,al_pbyte2,#8
	s_set_var	B,y2,#2
	jmp		makesplashpool_srou_l.init
.normal	jsr		effectpath_init_srou

	a16
	PHX
	ldx	x2
	lda	al_worldx,x
	sta.w	al_worldx,y
	lda	al_worldz,x
	sta.w	al_worldz,y
	PLX
	tya
	sta.w		al_childrotobj,y
	PHY
	toheap		y,x
	lda	exal_getheight_WY,y
	PLY
	sta.w	al_worldy,y


	lda	player1_vx
	sta.w	al_vx,y
	clc
	adc.w	al_worldx,y
	sta.w	al_worldx,y

	lda	player1_vz
	sta.w	al_vz,y
	clc
	adc.w	al_worldz,y
	sta.w	al_worldz,y

	a8
	s_set_path	y,overheat

	lda	al_vel,x
	sta.w	al_vel,y

.badobj	PULLXYP
	rtl



;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                          º
;º   ROBOT'S splash(MAGMA)  º
;º                          º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makeMsplashpool_srou_l

;	in	:x1 offsetx
;		:z1 offsetz
;		:y1 init colanim frame
;		:x2 leg(or body)'s pointer
;		:y2 = al_tx

	PUSHXYP

	a8i16

	s_make_obj	#msplash,makesplashpool_srou_l.badobj
	s_set_alvar	B,y,al_pbyte2,#4
	s_set_var	B,y1,#0
	s_set_var	B,y2,#0
	jmp		makesplashpool_srou_l.init

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                          º
;º   ROBOT'S splash(POOL)   º
;º                          º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makesplashpool_srou_l

;	in	:x1 offsetx
;		:z1 offsetz
;		:y1 init colanim frame
;		:x2 leg(or body)'s pointer
;	al_sword2  <-- x2
;	al_pbyte1  : work counter( for animation )

	PUSHXYP

	a8i16

	s_make_obj	#splash,.badobj
	s_set_alvar	B,y,al_pbyte2,#8

.init	LOCAL

	s_make_child	#childno_splash

	a16
	tya
	sta.w		al_childrotobj,y
	a8

;************
	S_SET_ALSFLAG	Y,ACTIVE
;************

; splash wo tsukutta toiu trigger wo set suru....
; ( hoka no splash wo remove surutame.)


	s_set_alvar2rnd	y,al_sbyte1
	s_set_alvar	W,y,al_sword2,x2
	s_set_alptrs	y,.strat,hit_istrat,explode_istrat

	jsl		TSTRATsrous_l.initsprite
	s_sprite_obj	y,#0,y2

	jsr		.splashinit

.exit
.badobj	LOCAL
	PULLXYP
	rtl




.strat	LOCAL
	s_start_strat
	s_set_strat		x,.strat2
	s_set_objtobealvar	y,x,al_ptr
	s_add_alvars		W,x,al_worldx,y,al_vx
	s_add_alvars		W,x,al_worldz,y,al_vz
.strat2	s_copy_alvar2var	B,x,x1,al_pbyte2
	s_add_colanim		x,#1,x1,.remove
	s_end_strat

;--------------------------------------------------------------------------------
.remove
	s_remove_obj		x
	s_end_strat

;--------------------------------------------------------------------------------

.splashinit	LOCAL

	s_init_colanim		y,y1

	s_push_obj		y
	ldy			al_sword2,x


; seadepth > pooldepth ?

	a16
	lda			exal_pooldepth,y
;	cmp			exal_getheight_WY,y
;	bcc			.si0
;
;	lda			exal_pooldepth,y
;	bra			.si1
;.si0	lda			exal_getheight_WY,y
.si1	sta			y1

	a8

	s_pull_obj	y

	s_push_obj	x
	ldx	x2


; calc pos ( 127 > pos > -127

	a16
	lda	y1
	sec
	sbc	al_worldy,x

	bpl	.pospl
.posmi	cmp	#-127
	bcs	.sety
	lda	#-127
	bra	.sety
.pospl	cmp	#127
	bcc	.sety
	lda	#127
.sety	sta	y1
	a8

	s_add_roffs2pos	B,y,x,x,x1,y1,z1,0,1,1
	s_pull_obj	x
	s_set_alsflag	y,realobj

	rts


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                          º
;º    PLAYER'S SHIELD       º
;º                          º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makeshield_srou_l

	s_start_strat

	PUSHYP

	a8i16

	lda	Kenemynumber
	rlbeq	.badobj

	toheap	y,x

	lda	exal_shield,y
	bit	#exal_shield_mask
	beq	.badobj

	s_jmp_childalive	#childno_barrier,.badobj

	s_make_obj	#barrier,.badobj
	s_make_child	#childno_barrier

	jsr		effectpath_init_srou
	s_set_path	y,playershield

.makeok	PULLYP
	sec
	rtl

.badobj	PULLYP
	clc
	rtl


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º             º
;º  TAMETAME   º
;º             º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

maketametame_srou_l

	s_start_strat

	PUSHYP

	a8i16

	s_jmp_childalive	#childno_tametame,.badobj

	s_make_obj	#nullshape,.badobj
	s_make_child	#childno_tametame
	s_set_strat	y,path_istrat

;	a16
;	tya
;	sta.w	al_childrotobj,y
;	a8

	sp_jmp_playertype	x,ARWING,.70

.20	lda	#20
	bra	.setz

.70	lda	#70
.setz	sta.w	al_pword1+0,y
	lda	#0
	sta.w	al_pword1+1,y

	s_set_path	y,tametame

	jsr		effectpath_init_srou

.badobj	PULLYP

	rtl


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º      ARWING'S BOOST       º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makeboost_srou_l

	s_start_strat

	PUSHYP

	a8i16

	sp_jmp_ifcockpit	x,.badobj

	s_jmp_childalive	#childno_boost,.badobj

	s_make_childobjrotpos	#boost,#childno_boost,#0,#0,#-20,#0,#0,#0,path_istrat
	cpy		#0
	beq		.badobj

	s_set_path	y,boost

	jsr	effectpath_init_srou

.makeok	PULLYP
	sec
	rtl


.badobj	PULLYP
	clc
	rtl


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º     ARWING's Brake        º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makebrakeL_srou_l

	PUSHYP
	a8i16

	s_jmp_childalive	#childno_brakeL,makebrakeR_srou_l.failed

	jsr	makebrakeR_srou_l.getxpos
	s_neg_var	W,x1
	s_set_var	B,z1,#childno_brakeL
	bra	makebrakeR_srou_l.make

makebrakeR_srou_l

	PUSHYP
	a8i16

	s_jmp_childalive	#childno_brakeR,.failed

	jsr	.getxpos
	s_set_var	B,z1,#childno_brakeR

.make	LOCAL

	sp_jmp_ifcockpit	x,.failed

	jsr	.makeobj
	bcc	.failed

.ok	LOCAL
	PULLYP
	sec
	rtl

.failed	LOCAL
	PULLYP
	clc
	rtl



.getxpos	LOCAL
	s_start_strat
	pl_get_shapeTAB	W,x,x1,brake_Xofstab
	pl_get_shapeTAB	W,x,y1,brake_Yofstab
	rts





.makeobj	LOCAL

	s_jmp_childalive	z1,.badobj
	s_make_childobjrotpos	#boost,z1,x1,y1,#15,#0,#0,#0,path_istrat

	cpy		#0
	beq		.badobj

	s_set_path	y,brake

	jsr	effectpath_init_srou

	sec
	rts

.badobj	clc
	rts


brake_Xofstab_FF	equ	15	;30
brake_Xofstab_SP	equ	25
brake_Xofstab_GG	equ	15

brake_Yofstab_FF	equ	0
brake_Yofstab_SP	equ	10
brake_Yofstab_GG	equ	10

brake_Xofstab
	shapetab	W,brake_Xofstab_
brake_Yofstab
	shapetab	W,brake_Yofstab_


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º     TRANS LOCK SPARK      º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
maketranslockspark_srou_l
	s_start_strat
	PUSHYP
	toheap	y,x
	lda	exal_HP,y
	cmp	#3*4+1
	bcc	makedamagespark_srou_l.exit
	bra	makedamagespark_srou_l.enter
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º       DAMAGE SPARK        º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
makedamagespark_srou_l

	s_start_strat
	PUSHYP

.enter	LOCAL


	s_jmp_alvarEQ	W,x,al_shape,#nullshape,.exit
	s_jmp_alsflag	x,invisible,.exit

	s_jmp_alvarZERO		B,x,al_HP,.exit
	pl_jmp_iftransform	x,.exit
	sp_jmp_ifcockpit	x,.exit

	s_jmp_notandframe	#1,.exit

	s_make_childobj	#wallflash,0,path_istrat
	cpy		#0
	beq		.exit
	jsr		effectpath_init_srou
	s_set_path	y,damagespark

.exit	LOCAL
	PULLYP
	rtl



;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º     ARWING  Over heat     º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
makeoverheat_srou_l
	s_start_strat
	phx
	phy
	php
	a8i16

	s_count_childs	x,tpx

	lda	tpx
	cmp	#5
	rlbcs	.badobj

	pl_jmp_ZENBUinpool	x,.badobj
	s_make_obj	#smoke,.badobj
	s_make_child	#childno_overheat
	a16
	tya
	sta.w		al_childrotobj,y
	a8
	s_set_path	y,overheat
	jsr	effectpath_init_srou



	lda	al_vel,x
	asra
	sta	tpx
	asra
	clc
	adc	tpx
	sta.w	al_vel,y
	ksound		overheat
.badobj
.exit	plp
	ply
	plx
	rtl


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º   ARWING'S HEAL EFFECT    º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makehealeffect_srou_l	; work0 = player1(2)_hpadd

	s_start_strat

	PUSHYP

	a8i16

	s_jmp_childalive	#childno_healeffect,.badobj

;	s_set_var	B,z1,#0
;
;	sp_jmpnot_ifcockpit	x,.make
;
;	s_set_var	B,z1,#80

.make	s_make_childobjrotpos	#nullshape,#childno_healeffect,#0,#0,#0,#0,#0,#0,path_istrat

	cpy	#0
	beq	.badobj

	s_set_path	y,healeffect

	jsr		effectpath_init_srou

.badobj	PULLYP
	sec
	rtl


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º  Effect of special bomb   º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
makebomeffect_srou_l
	s_start_strat

	PUSHYP

	a8i16

	s_make_obj	#nullshape,.badobj

	s_set_strat	y,path_istrat
	s_set_path	y,bomeffect

	jsr		effectpath_init_srou

	s_clr_alsflag	y,active

.badobj	PULLYP
	rtl





;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º   ARWING'S HEAL MACHINE   º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makeheal_srou_l

	s_start_strat
	PUSHYP
	a8i16
	s_jmp_childalive	#childno_heal,.badobj
	s_make_obj	#nullshape,.badobj
	s_make_child	#childno_heal
	s_set_path	y,heal
.makeok	LOCAL
	jsr		effectpath_init_srou
	a16
	tya
	sta.w	al_childrotobj,y
	a8
;************
;	S_SET_ALSFLAG	Y,ACTIVE
;************
	PULLYP
	sec
	rtl

.badobj	LOCAL
	PULLYP
	clc
	rtl



;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                  º
;º    burnning      º
;º                  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

makeburnning_l

burntime	equ	100

	PUSHYP

	s_start_strat

	a8i16

	toheap	y,x

	km_jmpgameflag		freeze,.exit

	lda	KEnemyNumber
	rlbeq	.exit
	s_jmp_alvarZERO		B,x,al_HP,.exit

;--------------------------------------------------------------------------------------------------------
; set counter

	lda	exal_dmgeffect,y
	bit	#exal_dmgeffect_burnning_ALL
	beq	.noinc
; time out?
	lda	exal_dmgfxcounter,y
	inc	a
	sta	exal_dmgfxcounter,y
	cmp	#burntime
	beq	.firedown

; rolling?

	lda	exal_rollingoffset,y
	beq	.noinc
	bit	#1fH
	beq	.firedown
.noinc
;--------------------------------------------------------------------------------------------------------
; player no damage

	lda	exal_dmgeffect,y
	bit	#exal_dmgeffect_burnning_ALL
	beq	.cksmoke

	lda	gameframe
	and	#31
	bne	.nodamage


	lda	exal_nohit,y
	and	#exal_nohit_mask
	bne	.nodamage

	jsl	hit_effect_small_l
; dec HP

	lda	exal_HP,y
	bne	.dec
	sta	al_hp,x
	bra	.sta
.dec	dec	a
.sta	sta	exal_HP,y

.nodamage
;--------------------------------------------------------------------------------------------------------
; make smoke(ROBOT)

	sp_jmpnot_playertype	x,ROBOT,.cksmoke

;--------------------------------------------------------------------------------------------------------
; in pool?

	pl_jmpnot_KAOinpool	x,.nocooldown

; clr burnning flag & set smoke counter

.firedown	lda	exal_dmgeffect,y
	and	#exal_dmgeffect_burnning_ALL^-1
	ora	#exal_dmgeffect_smokemask
	sta	exal_dmgeffect,y
	lda	#0
	sta	exal_dmgfxcounter,y

.nocooldown

.cksmoke

; make smoke ?

	lda	exal_dmgeffect,y
	bit	#exal_dmgeffect_smokemask
	beq	.nosmoke

	dec	a
	sta	exal_dmgeffect,y

	s_jmp_andframe	#1,.nosmoke

	jsl	makeoverheat_srou_l

.nosmoke

;--------------------------------------------------------------------------------------------------------
	s_jmpnot_alvarAND	B,y,exal_dmgeffect,#exal_dmgeffect_burnning_ALL,.exit

	sp_jmp_playertype	x,ROBOT,.Con

.R
	s_jmp_ANDframe		#1,.L
	s_jmpnot_alvarAND	B,y,exal_dmgeffect,#exal_dmgeffect_burnning_R,.L
	s_set_var	W,tpx,#25
	jsr	.make

.L
	s_jmp_notANDframe	#1,.C
	s_jmpnot_alvarAND	B,y,exal_dmgeffect,#exal_dmgeffect_burnning_L,.C
	s_set_var	W,tpx,#-25
	jsr	.make

.C
	s_jmp_notANDframe	#1,.exit
	s_jmpnot_alvarAND	B,y,exal_dmgeffect,#exal_dmgeffect_burnning_C,.exit
.Con	s_set_var	W,tpx,#0
	jsr	.make

.exit	PULLYP
	sec
	rtl





.make	;in	tpx x offset

	s_push_obj	y

	s_set_var	B,x1+1,#0
	s_set_var2rnd	x1,#15

	s_set_var	W,y1,#0
	sp_jmpnot_playertype	x,ROBOT,.make2
	s_set_var	W,y1,#-10

.make2	a16
	lda	x1
	asra
	clc
	adc	y1
	sta	y1

	lda	x1
	clc
	adc	#-10
	sta	z1

	lda	x1
	clc
	adc	#-7
	clc
	adc	tpx	;#20
	sta	x1
	a8

	sp_jmpnot_ifcockpit	x,.domake

	s_add_var	W,y1,#-10
	s_set_var	W,z1,#30

.domake	s_make_childobjrotpos	#flame,#childno_flame,x1,y1,z1,#0,#0,#0,path_istrat

	cpy	#0
	rlbeq	.fail

	jsr	effectpath_init_srou

	s_set_path	y,burnning

.fail	s_pull_obj	y

	rts

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º      ARWING'S Spark       º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼



makesparkAML_srou_l

;	in	:z1=offset z

	PUSHYP
	a8i16
	toheap		y,x
	s_push_obj	x
	s_set_objtobealvar	x,y,exal_jetLobjptr
	bra	makesparkAMR_srou_l.enter


makesparkAMR_srou_l

;	in	:z1=offset z

	PUSHYP
	a8i16

	toheap		y,x
	s_push_obj	x
	s_set_objtobealvar	x,y,exal_jetRobjptr
.enter	LOCAL
	s_set_var	B,x1,#0
	s_set_var	B,y1,#0
	jsr		makespark
	s_pull_obj	x
	PULLYP

	rtl




makesparkC_srou_l

	PUSHXYP
	a8i16

	stx	x2

	toheap		y,x

	s_set_var		B,x1,#0
	s_set_var		B,y1,#0
	pl_get_shapetab		B,x,z1,nosez

	jsr	makespark
	bcc	.exit

.exit	LOCAL

	PULLXYP

	rtl


makesparkL_SMK_srou_l	; desert no toki
makesparkL_srou_l

	PUSHXYP
	a8i16
	stx	x2
	toheap		y,x
	jsr	getwingheadpos
	s_neg_var	W,x1
	jsr	makespark

.enter	LOCAL

	bcc	.exit


.exit	PULLXYP
	rtl




makesparkR_SMK_srou_l	; desert no toki
makesparkR_srou_l

	PUSHXYP
	a8i16
	stx	x2
	toheap		y,x
	jsr	getwingheadpos
	jsr	makespark

.enter	LOCAL

	bcc	.exit

.exit	PULLXYP
	rtl





;makewingspark
;	x1	:offset x
;	y1	:offset y
;	z1	:offset z
;	x2	:objpointer(position wo keisan suru)


makespark	LOCAL

	s_make_childobjrotpos	#wallflash,0,x1,y1,z1,#0,#0,#0,path_istrat

	cpy	#0
	beq	.badobj

	s_set_path	y,wingspark

	jsr	effectpath_init_srou

.exit	sec
	rts


.badobj	clc
	rts



getwingheadpos

	a8i16

	pl_get_shapeTAB_ST	W,x,x1,wingheadx
	pgst_C			W,x,y1,wingheady
	pgst_END		W,x,z1,wingheadz

	rts

wingheadx	shapetab	W,rwingheadx_
wingheady	shapetab	W,wingheady_
wingheadz	shapetab	W,wingheadz_


nosez	shapetab	W,noseheadz_




;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º       ARMER's Jet         º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
	SHORTA
	LONGI

;killjet_srou_l
;	rtl



;makejet_srou_l
;
;	rtl
;

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	s_start_strat
	phx
	phy
	php
	a8i16
.jetL	toheap	y,x
	s_jmp_alvarAND	B,y,exal_jetstatus2,#exal_jetstatus2_Lset,.jetLend
	jsr	.make_jetL
	bcc	.jetR
	s_or_alvar	B,y,exal_jetstatus2,#exal_jetstatus2_Lset
	bra		.jetR
.jetLend	s_set_objtobechild	y,x,#childno_armerjetL
	cpy	#0
	beq	.jetR
	s_set_alvar	B,y,al_count,#2
.jetR	toheap	y,x
	s_jmp_alvarAND	B,y,exal_jetstatus2,#exal_jetstatus2_Rset,.jetRend
	jsr	.make_jetR
	bcc	.exit
	s_or_alvar	B,y,exal_jetstatus2,#exal_jetstatus2_Rset
	bra		.exit
.jetRend	s_set_objtobechild	y,x,#childno_armerjetR
	cpy	#0
	beq	.exit
	s_set_alvar	B,y,al_count,#2
.exit	plp
	ply
	plx
	rtl
.make_jetL	s_jmp_alvarZERO	W,y,exal_jetLobjptr,.badobj
	jsr		.getpos
	PHY
	s_make_childobjrotpos	#boost,#childno_armerjetL,#0,#0,z1,#0,#0,#0,path_istrat
	cpy		#0
	rlbeq		.badobj2
	sty		tpy
	ply
	s_copy_alvar2var	W,y,y1,exal_jetLobjptr
	phy
	ldy		tpy
	bra			.makejet
.make_jetR	s_jmp_alvarZERO	W,y,exal_jetRobjptr,.badobj
	jsr		.getpos
	PHY
	s_make_childobjrotpos	#boost,#childno_armerjetR,#0,#0,z1,#0,#0,#0,path_istrat
	cpy		#0
	beq		.badobj2
	sty		tpy
	ply
	s_copy_alvar2var	W,y,y1,exal_jetRobjptr
	phy
	ldy		tpy
.makejet	s_set_alvar	W,y,al_childrotobj,y1
	s_set_path	y,armerjet
	jsr		effectpath_init_srou
	s_set_alvar	B,y,al_count,#2
	ply
	sec
	rts
.badobj2	ply
.badobj	clc
	rts
.getpos	s_start_strat
	pl_get_shapeTAB	W,x,z1,.jpdatz
	rts
.jpdatz	dw	jettailz_FF
	dw	jettailz_SP
	dw	jettailz_GG
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; strat for JET
;		: sflag1=0	left
;		;	 1	right
;		: al_sbyte1   : offset  X
;		: al_sbyte2   :		Y
;		: al_sbyte3   :		Z
;--------------------------------------------------------------------------
.jet_strat	s_start_strat
; player pointer
	s_set_objtobealvar	y,x,al_ptr
	s_copy_rots		x,y
; set rotx
	s_push_obj	x
	s_push_obj	y
	ldx		al_sword2,y
	lda		exal_jetrot,x
	s_pull_obj	y
	s_pull_obj	x
	sta		al_rotx,x
; set offset
	s_copy_alvar2var	B,x,x1,al_sbyte1
	s_copy_alvar2var	B,x,y1,al_sbyte2
	s_copy_alvar2var	B,x,z1,al_sbyte3
	s_add_roffs2pos		B,x,y,x,x1,y1,z1,1,1,0
	s_add_colanim		x,#1,#2
; jet off?
	pl_jet			y,check
	bne			.exit_jLR
	s_remove_obj		x
.exit_jLR
	s_end_strat

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º       ARMER's Arm         º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
;	sflag1		: Ljet or Rjet flag 0:L 1:R


	SHORTA
	LONGI

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
makeLRarm_srou_l

	rtl

	PUSHXYP
.L	ldy		al_sword2,x
	s_jmp_alvarAND	B,y,exal_jetstatus,#exal_jetstatus_legL0alive,.R
	pl_get_shapeTAB	W,x,x1,.posdatL
	jsr		.gen_arm
	bcc		.Lend
	pl_set_PILOTshape	x,y,shape_ARMER_ARM_L
	a16
	tya
	ldy		al_sword2,x
	sta		exal_jetLobjptr,y
	a8
	s_or_alvar	B,y,exal_jetstatus,#exal_jetstatus_legL0alive
.Lend
.R	ldy		al_sword2,x
	s_jmp_alvarAND	B,y,exal_jetstatus,#exal_jetstatus_legR0alive,.end
	pl_get_shapeTAB	W,x,x1,.posdatR
	jsr		.gen_arm
	bcc		.Rend
	pl_set_PILOTshape	x,y,shape_ARMER_ARM_R
	a16
	tya
	ldy		al_sword2,x
	sta		exal_jetRobjptr,y
	a8
	s_or_alvar	B,y,exal_jetstatus,#exal_jetstatus_legR0alive
.Rend
.end	PULLXYP
	rtl

.gen_arm		;in : work0 : 0=left 1=right
	s_make_childobjrotpos	#nullshape,0,x1,#0,#0,#0,#0,#0,path_istrat
	cpy	#0
	beq	.badobj

	s_set_path		y,armerarm
	jsr	effectpath_init_srou
	s_copy_alvar2alvar	W,y,al_coltab,x,al_coltab
	s_copy_alvar2alvar	W,y,al_depthoffset,x,al_depthoffset
	sec
	rts
.badobj	clc
	rts

.posdatL	shapetabNEG	W,jetofsx_
.posdatR	shapetab	W,jetofsx_
shape_ARMER_ARM_L	; in space Armer
	DW	a_wing	;a_ufo_l	; fox
	DW	c_wing	;C_UFO_L
	DW	b_wing	;B_UFO_L
shape_ARMER_ARM_R	; in space Armer
	DW	a_wing	;a_ufo_r	; fox
	DW	c_wing	;C_UFO_R
	DW	b_wing	;B_UFO_R
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                    º
;º   ROBOT'S GOTTUN   º
;º                    º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
makegottun_srou_l
	PUSHXYP
	a8i16
	s_make_obj		#boost,.badobj
	s_make_child	#childno_gottun
	a16
	tya
	sta.w		al_childrotobj,y
	a8
	jsl			TSTRATsrous_l.initsprite
	s_copy_pos		y,x
	s_add_alvar		W,y,al_worldy,#-20	; head pos
	s_set_alptrs		y,.strat,hit_istrat,explode_istrat
	s_set_alsflag		y,realobj
	s_init_colanim		y,#4
.badobj	PULLXYP
	rtl
.strat	LOCAL		; WARNING ! hoka demo tsukatte iruzo!!
	s_start_strat
	s_add_colanim		x,#1,#8,.remove
	s_end_strat
.remove	s_remove_obj		x
.end	s_end_strat
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           º
;º     ROBOT's Shadow        º
;º                           º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
	SHORTA
	LONGI

makeshadow_srou_l

	phx
	phy
	php

	a8i16

	pl_jmp_ifonthe	x,water,.exit
;	pl_jmp_KAOinpool	x,.exit
	rb_jmpNOT_ifonshape	x,.exit

	toheap		y,x

	s_jmp_alvarZERO	W,y,exal_getheight_WY,.exit

	s_jmp_childalive	#childno_shadow,.exit

;	s_jmp_alsflag		x,sflag5,.exit
;	s_set_alsflag		x,sflag5

	s_make_obj		#s_8,.exit

	s_make_child	#childno_shadow
	a16
	tya
	sta.w		al_childrotobj,y
	a8

;************
	S_SET_ALSFLAG	Y,ACTIVE
;************
	pl_set_area		y,-1
	s_set_alptrs		y,.strat,hit_istrat,explode_istrat
	s_set_alsflag		y,realobj

	jsl			plobjinit_srou_l

	s_set_alvar		B,y,al_rotx,#0
	s_set_alvar		B,y,al_roty,#0
	s_set_alvar		B,y,al_rotz,#0

	pl_copy_alsflag		y,x,player2

.exit	plp
	ply
	plx
	rtl

.strat
	s_start_strat

	lda	demomode
	bne	.finishup

	s_set_objtobealvar	y,x,al_ptr	;idY <-- player

	sp_jmp_playertype	y,ARWING,.finishup

	s_copy_pos	x,y
	jsl		getheight_l
	s_jmp_varZERO	W,y1,.finishup
	s_set_alvar	W,x,al_worldy,y1


	s_push_obj	x

	ldx	al_sword2,y
	a16
	lda	exal_pooldepth,x
	sta	y1
	a8
	s_pull_obj	x

	s_add_alvar	W,x,al_worldy,y1

	lda		#0
	sta		al_rotx,x
	sta		al_roty,x
	sta		al_roty,x

	pl_jmp_ifonthe	y,water,.finishup
;	pl_jmp_KAOinpool	y,.finishup

.end	s_end_strat



.finishup
;;;;	s_clr_alsflag	y,sflag5
	s_remove_obj	x
	s_end_strat


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                                          º
;º     ROBOT's explode(leg ga buttobu!)     º
;º                                          º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

brokenleg_istrat

	s_start_strat

	s_set_alsflag	x,shadow

	s_set_lifecnt	x,#50

	s_gen_3Dvecs	x,al_roty,al_rotx,al_vel
	s_set_alptrs	x,.strat,hit_istrat,explode_istrat
	s_set_aldata	x,#1,#1

	s_add_alvar	B,x,al_roty,#40

.strat
	s_init_anim		x,#8

;************
	s_jmp_notANDframe	#3,.noexp
	s_make_obj	#explosion,.exp0
	s_copy_pos	y,x
	s_set_alptrs	y,path_istrat,hit_istrat,explode_istrat
	s_set_path	y,p_explode_s
	s_set_aldata	y,#1,#1
	s_set_lifecnt	y,#50
.exp0
;*************
.noexp
	s_add_alvar		B,x,al_rotx,#20

	s_add_vecs2pos		x

	pl_test_planetmode	space
	beq			.hitg
	s_add_alvar		W,x,al_vy,#1

.hitg	a16
	lda	al_worldy,x
	clc
	adc	#20
	a8
	bpl	.remove

.life	s_decbne_lifecnt	x,.exit

.remove	s_set_alvar		B,x,al_HP,#0

.exit	s_end_strat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------
;
;  shoot weapon routine
;
;-------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

tp_checkshoot_l

	phx
	phy
	php
	a8i16


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Set rotation x


; find enemy

	stz	p1_firerotx

	sp_jmp_playertype	x,ROBOT,.walker

	lda	al_rotx,x
	sta	p1_firerotx

	jmp	.exitfrx

;---------------------------------------------------------------------------------------------
;	Find enemy (WALKER'S PLASMA)

.walker	PHX

	ldy	#0
	sty	tpy	; pointer


	wm_find_enemynearobj	y,x,#0,#7000,#10,#50,.cantfind

	sty	x1	; chase onj

.found

	ldx	dummyobj

	a16
	lda.w	al_vx,y
	asl	a
	asl	a
	clc
	adc.w	al_worldx,y
	sta	al_worldx,x
	lda.w	al_vy,y
	asl	a
	asl	a
	clc
	adc.w	al_worldy,y
	sta	al_worldy,x
	lda.w	al_vz,y
	asl	a
	asl	a
	clc
	adc.w	al_worldz,y
	sta	al_worldz,x
	a8

	s_copy_pos	x,y

	sty	tpy	; pointer

.cantfind

	PLX

;---------------------------------------------------------------------------------------------

	ldy	tpy
	beq	.nofind

;<calc angle>

	ldy	dummyobj

	stz	smvar_byte1
	s_jsl	Xanglexy_l

	a16
	adiv2
	sta	tpx
	adiv2
	clc
	adc	tpx
	a8

	xba
	sta	p1_firerotx

.nofind	lda	p1_firerotx
	clc
	adc	#25
	bmi	.mi
	cmp	#25*2
	bmi	.exitfrx

	lda	#25
	bra	.sta
.mi	lda	#-25
.sta	sta	p1_firerotx


.exitfrx


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; SPECIAL WEAPON

	s_jmp_childalive	#childno_barrier,.end_weapA
	s_jmp_childalive	#childno_heal,.end_weapA

	toheap		y,x

;------------ BOMB no check --------------
	a16
	lda	exal_chartptr+0,y
	a8
	rlbne	.end_weapA
;-----------------------------------------

.weapon_A

	s_jmp_alvarAND		B,y,exal_SPweaponstatus,#exal_SPweaponstatus_counter,.decSPcnt
	testjoypad		spfire,ptrig	;A,ptrig
	beq			.end_weapA

	phy
	jsr	arwing_fire_missile1
	ply
	lda	exal_SPweaponstatus,y
	and	#exal_SPweaponstatus_counter^-1

; !! decHP_srou_l demo set siteruzo!

	ora	#SPWEAPINT
	sta	exal_SPweaponstatus,y
	bra	.end_weapA
.decSPcnt	s_dec_alvar		B,y,exal_SPweaponstatus

.end_weapA

;-------------------------------------------------------------------

	toheap		y,x

	sp_jmp_playertype	x,ARWING,ARWING_WEAPON

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ROBOT_WEAPON

.weapon_Y	TESTJOYPAD	fire,ptrig	;Y,ptrig
	rlbeq		.exit_rfp

;************
	lda	demomode
	rlbne	.exit_rfp
;************

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³    PLASMA    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	km_jmpgameflag		freeze,.exit_rfp

	pl_ldy_viewblk	x

;;;;	s_copy_alvar2var	B,y,x1,al_rotx+1

	stz		x1

	s_neg_var	B,x1

	s_add_var	B,x1,#-4

	s_set_var	B,z1,#0
;------------
; adjust position for battle mode.

;	sm_jmp_if1screen	.onescr
;	s_jmpnot_alsflag	x,player2,.onescr
;	s_set_var	B,z1,#10
.onescr
;------------
	s_weapon_pos	#0,#0,z1

	s_weapon_rot	x1,#0
	s_fire_weapon	x,Pplasma,.exit_rfp

.exit_rfp	plp
	ply
	plx
	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- ARWING & ARMER --
ARWING_WEAPON

;----------------------------------------------------------------------------
.weapon_Y

	TESTJOYPAD	fire,ptrig
	beq		.noadd

	lda	exal_weaponstatus,y
	cmp	#40h
	bpl	.noadd
	clc
	adc	#10h
	sta	exal_weaponstatus,y

.noadd

; fire

	lda	exal_weaponstatus,y
	bit	#00fh
	bne	.clr
	bit	#0f0h
	beq	.weapon_end

	jsr	arwing_fire_laser1
	bcc	.weapon_end

	lda	exal_weaponstatus,y
	and	#0f0h
	sec
	sbc	#10h
	ora	#LASERINT
	sta	exal_weaponstatus,y


	bra		.weapon_end

.clr
	s_dec_alvar	B,y,exal_weaponstatus	;,#0f0h


.weapon_end	plp
	ply
	plx
	rtl

	IFEQ	1
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; -- ARWING & ARMER --
ARWING_WEAPON
;----------------------------------------------------------------------------
.weapon_Y	s_jmp_alvarZERO	B,y,exal_weaponstatus,.Ytrig
	TESTJOYPAD	fire,pcont	;Y,pcont
	beq		.clrstatus
	TESTJOYPAD	fire,pcont	;Y,ptrig
	beq		.noYtrig
	s_set_alvar	B,y,exal_weaponstatus,#LASERCONT*10H+LASERINT
.noYtrig	s_jmpNOT_alvarAND	B,y,exal_weaponstatus,#15,.fire
	s_sub_alvar	B,y,exal_weaponstatus,#1
	bra		.weapon_end
.fire	jsr		arwing_fire_laser1
	bcc		.weapon_end
	s_sub_alvar	B,y,exal_weaponstatus,#10H
	s_jmp_alvarZERO	B,y,exal_weaponstatus,.weapon_end
	s_or_alvar	B,y,exal_weaponstatus,#LASERINT
	bra		.weapon_end
.clrstatus	s_set_alvar	B,y,exal_weaponstatus,#0
	bra		.weapon_end
.Ytrig	TESTJOYPAD	fire,ptrig	;Y,ptrig
	beq		.weapon_end
	s_set_alvar	B,y,exal_weaponstatus,#LASERCONT*10H+LASERINT
	jsr		arwing_fire_laser1
.weapon_end	plp
	ply
	plx
	rtl
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
	ENDC

;----------------------------------------------------


	SHORTA
	LONGI

arwing_fire_missile1

	phx
	phy
	php

; --- FIRE! ---
	s_push_obj	x
	s_push_obj	y

	pl_ldy_viewblk	x
	tyx
	s_pull_obj	y

	a16
	lda		al_rotx,x
	xba
	sta		al_rotx,x
	lda		al_roty,x
	xba
	sta		al_roty,x
	lda		al_rotz,x
	xba
	sta		al_rotz,x
	a8

	s_add_roffs2pos		B,y,x,x,#0,#0,#100,1,1,0

	a16
	lda		al_rotx,x
	xba
	sta		al_rotx,x
	lda		al_roty,x
	xba
	sta		al_roty,x
	lda		al_rotz,x
	xba
	sta		al_rotz,x
	a8

	s_pull_obj	x

	s_weapon_rot	#0,#0
	s_weapon_pos	#0,#0,#0

	pl_fire_spweap	x,.exit

; adjust rotation of object just fired:

	phy

	ldy	al_sword2,x

	lda	exal_acclroty+1,y
	clc
	adc	exal_acclroty+1,y
	clc
	adc	exal_acclroty+1,y
	clc
	adc	exal_acclroty+1,y
	ply
	clc
	adc.w	al_roty,y
	sta.w	al_roty,y


.exit	plp
	ply
	plx
	rts


;-----------------------------------------------------------------------------

	SHORTA
	LONGI

arwing_fire_laser1	; -- fire laser1 --

afl_firezofs		equ	work7
afl_wxbuf		equ	work6
afl_wzbuf		equ	work5
afl_firelevel	equ	work4
afl_firepower	equ	work3

awlaseryofs		equ	5

	phx
	phy
	php

; -- FIRE PROS --

	a8i16

	toheap		y,x

	s_set_var	B,afl_firezofs,#0

;----------------------------------------------------------------------------
;powerd laser?
;
;
;	lda	#0
;	sta	afl_firepower
;
;	lda	exal_weap_power+1,y
;	cmp	#powermetermax
;	bne	.nopower
;	sta	afl_firepower
;
;	s_set_alvar	B,y,exal_weaponstatus,#0
;
;	jsr	.fire
;
;
;
;----------------------------------------------------------------------------

.nopower

;	a16
;	lda	#0
;	sta	exal_weap_power,y
;	a8

;----------------------------------------------------------------------------

	lda	exal_weap_level,y
	sta	afl_firelevel

	km_jmpgameflag		freeze,.failed

	sp_jmp_ifcockpit	x,.cocklaser

	jsr	.fire

	cpy	#0
	rlbeq	.failed
	jmp	.ok




.cocklaser	lda	afl_firelevel
	dec	a
	beq	.cockLV1
	dec	a
	beq	.cockLV2

.cockLV3	lda	#20
	bra	.cockfire
.cockLV2
.cockLV1	lda	#-20
.cockfire	sta	afl_firezofs


	pl_ldy_viewblk	x

	a16
	lda	al_worldx,x
	sta	afl_wxbuf
	lda	al_worldz,x
	sta	afl_wzbuf

	lda.w	al_worldx,y
	sta	al_worldx,x
	lda.w	al_worldz,y
	sta	al_worldz,x
	a8

	jsr	.fire

	a16
	lda	afl_wxbuf
	sta	al_worldx,x
	lda	afl_wzbuf
	sta	al_worldz,x
	a8

	cpy	#0
	beq	.failed

.ok
	plp
	ply
	plx
	sec
	rts

.failed
	plp
	ply
	plx
	clc
	rts



.fire	SHORTA
	LONGI


;------------
; adjust position for battle
;	s_jmpnot_alsflag	x,player2,.dofire
;	s_add_var		B,afl_firezofs,#-40
;.dofire
;------------

	s_weapon_rot	#0,#0

	lda	afl_firelevel
	dec	a
	rlbmi	.nofire
	rlbeq	.normal

	dec	a
	rlbeq	.twin0
	dec	a
	rlbeq	.ttwin0

;----------------------------------------------------------------------

.normal	s_weapon_pos	#0,#0,afl_firezofs
	s_fire_weapon	x,awlaser,.nofire
	jmp		.fired

;----------------------------------------------------------------------

.twin0	s_weapon_pos	#0,#0,afl_firezofs
	s_fire_weapon	x,awlaser_twin,.nofire
	bra		.fired

;----------------------------------------------------------------------

.ttwin0	s_weapon_pos	#0,#0,afl_firezofs
	s_fire_weapon	x,awlaser_twintwin,.nofire

;--------------------------------------------------------------------------------------

.fired	sec
	rts

.nofire	clc
	rts



;--------------------------------------------------------------------------------------
; POWERD LASER

	SHORTA
	LONGI

fire_powerd_srou_l	; -- fire powerd laser

	PUSHYP

	a8i16

	toheap	y,x

;----------------------------------------------------------------------------
; Power laser
;----------------------------------------------------------------------------
; check key
;----------------------------------------------------------------------------
.trig
;************
	pl_jmpnot_iftransform	x,.notrans
	sp_weap_power		x,off,y
.notrans
;************
	lda	demomode
	rlbne	.powerdown
;************

	testjoypad	fire,pcont
	beq		.notrig

	testjoypad	fire,ptrig
	bne		.notrig

; on trig
;************

	sp_weap_power	x,on,y
	bra	.cont

;************
.notrig

	lda	exal_weap_powerflag,y
	and	#~exal_weap_powerflag_fired
	sta	exal_weap_powerflag,y

;----------------------------------------------------------------------------
.cont
	lda	exal_weap_powerflag,y
	bit	#exal_weap_powerflag_fired
	rlbne	.nocont

	testjoypad	fire,ptrig
	bne		.fire

	testjoypad	fire,pcont
	rlbne		.nocont

.fire

; FIRE?
	lda	exal_weap_power+1,y
	cmp	P1_maxMETER
	bne	.powerdown

; FIRE!
	PHY
	s_weapon_rot	#0,#0
	s_weapon_pos	#0,#0,#0
	s_fire_weapon	x,awpowerdlaser_twintwin,.nofirePL

.nofirePL	PLY

	lda	exal_weap_powerflag,y
	ora	#exal_weap_powerflag_fired
	sta	exal_weap_powerflag,y

	s_set_alvar	B,y,exal_weaponstatus,#LASERINTPOWERD

	sp_jmp_playertype	x,ROBOT,.RBZ,y

	s_set_alvar	B,y,exal_camZofs_tame_accl,#5
	s_set_alvar	W,y,exal_camZofs_tame,#30
.RBZ

.powerdown
;************

	sp_weap_power	x,off,y

;************
.nocont


;----------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³powerdown pros³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
; power down?

	lda	exal_weap_powerflag,y
	bit	#exal_weap_powerflag_mi
	rlbeq	.nodown
;------------
; SE off?
	bit	#exal_weap_powerflag_SE
	beq	.noSEoff
	and	#~exal_weap_powerflag_SE
	sta	exal_weap_powerflag,y

	kplsound	x,charge_stop

.noSEoff
;------------
; remove tametame
;************
	PHY
	a8
	s_jmp_childdead		#childno_tametame,.notametame
	s_set_objtobechild	y,x,#childno_tametame
	s_remove_obj		y
.notametame	PLY

;************
;------------
; power down

	toheap	y,x

	lda	#0
	sta	exal_weap_power+0,y

	lda	exal_weap_power+1,y
	adiv2
	sta	exal_weap_power+1,y

	lda	exal_weap_power+1,y
	bne	.nodown


	lda	exal_weap_powerflag,y
	and	#~exal_weap_powerflag_mi
	sta	exal_weap_powerflag,y

	jmp	.fullpower

;------------
.nodown
;-----------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³power up pros³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
; power up?

	lda	exal_weap_powerflag,y
	bit	#exal_weap_powerflag_mi
	rlbne	.fullpower
	bit	#exal_weap_powerflag_pl
	rlbeq	.fullpower

;------------
; SE on?

	lda	exal_weap_power+1,y
	cmp	#8
	bcc	.noSEon

	jsl	maketametame_srou_l

	lda	exal_weap_powerflag,y
	bit	#exal_weap_powerflag_SE
	bne	.noSEon
	ora	#exal_weap_powerflag_SE
	sta	exal_weap_powerflag,y

	kplsound	x,shot_charge_start
.noSEon
;------------

	lda	exal_weap_power+1,y
	cmp	P1_maxMETER
	beq	.fullpower

	pl_get_pilottab	W,x,x1,powerlaser_tab

;------------
	a16

	lda	P1_maxMETER
	and	#0ffh
	xba
	sta	tpx

	lda	x1
	clc
	adc	exal_weap_power,y
	cmp	tpx	;#powermetermax<<8
	bcc	.setpower

	a8
	kplsound	x,shot_charge
	a16

	lda	P1_maxMETER-1
	and	#0ff00h
.setpower	sta	exal_weap_power,y
	a8

;------------
.fullpower

	PULLYP
	rtl

;--------------------------------------------------------------------------------------

powerlaser_tab	pilottab	W,powerlaserup_

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

fire_AW_specialweapon_l

	s_start_strat

	phx
	phy

	km_jmpgameflag		freeze,.ng

	toheap		y,x

	lda		exal_spweap_LMT,y
	bit		#pX_spweap_LMT_LMT
	rlbeq		.ng


;KAKAKAKAKAKKAKKAKAKAKAKAKKAKAKAKAKAKAKAKKAKAKKAKAKAKAKAK
;	bra	.dummy
;KAKAKAKAKAKKAKKAKAKAKAKAKKAKAKAKAKAKAKAKKAKAKKAKAKAKAKAK


	lda	exal_spweap_type,y
	asl	a
	cmp	#.weaptable_end-.weaptable
	rlbcs	.missile1

	s_push_obj	x
	a16
	and	#0ffH
	tax
	lda.l	.weaptable,x
	sta	x1
	a8
	s_pull_obj	x

	jmp	(x1)


.weaptable
	dw	.heal&WM		;0
	dw	.bomb&WM		;1
	dw	.dummy&WM		;2
	dw	.shield&WM		;3
	dw	.missile1&WM		;4

.weaptable_end

.bomb
	a16
	lda	exal_chartptr+0,y
	a8
	rlbne	.ng

	lda	exal_paletteflag,y
	bit	#exal_paletteflag_bomb!exal_paletteflag_bomb_normal
	rlbne	.ng

	ct_set_chartptr		x,specialbomb,y

	jsl	makebomeffect_srou_l

	stz	bombexplode	; explode trigger

	jmp	.ok

.missile1
	;;;;s_fire_weapon	x,MISSILE1,.ng
	jmp		.ok
.dummy
	;;;;s_fire_weapon	x,AWDUMMY,.ng
	jmp		.ok

.spreadplasma
	;;;;s_fire_weapon	x,SPREADPLASMA,.ng
	bra		.ok

.shield
	pl_jmp_ifshield	x,.ng,y
	pl_shield	x,#1fH,y
	bra		.ok

.heal
	pl_jmp_iftransfalling	x,.ng,y
	sp_jmp_playerfullHP	x,.ng
	jsl		makeheal_srou_l
	bcc		.ng

.ok	toheap	y,x

	lda		exal_spweap_LMT,y


;	IFEQ	debuginfo
	dec		a
;	ENDC

	sta		exal_spweap_LMT,y

	ply
	plx
	sec
	rtl

.ng
	ply
	plx
	clc
	rtl
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Arwing hits ground
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
surface_height	equ	0
Lwhit		equ	1
Rwhit		equ	2
Lwhit_room		equ	4
Rwhit_room		equ	8
ahs_surface_height	equ	work9
wingposxofs		equ	work8
wingposyofs		equ	work7
wingdmgsound		equ	work6	;%111(g l,c,r)
ahs_top_height	equ	work5


ARWINGhit_surface_l

	phx
	phy
	php

	a8i16

	toheap	y,x

	s_set_var	B,wingdmgsound,#0

;--------------------------------------------------------------------
; clear clip
	s_set_clipping	x,off

;--------------------------------------------------------------------

	pl_jmp_planetmode	space,.exit

;--------------------------------------------------------------------

	pl_jmp_iftransrising	x,.exit,y

;--------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; check for room
;
;	s_jmp_varNE	B,playerctlmode,#map_room,.nohittop
;	s_jmp_alvarAND	B,y,exal_xyzLMT,#exal_xyzLMT_top,.nohittop
;	s_add_alvar	W,y,exal_rotx,#-1800h
;	jsl		makesparkC_srou_l
;
;.nohittop
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;--------------------------------------------------------------------

	a16
	lda	exal_pooldepth,y
	nega
	sta	ahs_surface_height
	lda	exal_maxPmoveY,y
	sta	ahs_top_height
	a8

;--------------------------------------------------------------------
; check wing

	s_set_var	B,work1,#0

	ldy		dummyobj

;checkR
.R	s_set_var	B,wingposxofs,#35
	s_set_var	B,wingposyofs,#5
	jsr		.calc0

;--------------------------------------------------------------------
;ROOM
	s_jmp_varNE	B,playerctlmode,#map_room,.nohitroomR

	a16
	lda.w	al_worldy,y
	clc
	adc	ahs_top_height
	a8
	bpl	.nohitroomR
	s_or_var	B,work1,#Rwhit_room
	bra	.sparkR
.nohitroomR
;--------------------------------------------------------------------
	a16
	lda	ahs_surface_height
	clc
	adc.w	al_worldy,y
	a8
	bmi	.L
;--------------------------------------------------------------------
; set clip
	s_set_clipping	x,pool1

;--------------------------------------------------------------------

	s_or_var	B,work1,#Rwhit

	pl_jmp_ifinthesea	x,.end_R

	pl_jmp_ifonthe		x,sand,.sparkRSMK
	pl_jmpnot_ifonthe	x,ground,.splashR

.sparkR	jsl		makesparkR_srou_l
	bra		.sparkRsnd
.sparkRSMK	jsl		makesparkR_SMK_srou_l
.sparkRsnd
	s_or_var	B,wingdmgsound,#%00000001
	bra		.end_R

.splashR
	jsr		.makesplashR
	s_or_var	B,wingdmgsound,#%00000101
.end_R

;checkL
.L	a8
	s_set_var	B,wingposxofs,#-35
	s_set_var	B,wingposyofs,#5
	jsr	.calc0

;--------------------------------------------------------------------
;ROOM
	s_jmp_varNE	B,playerctlmode,#map_room,.nohitroomL

	a16
	lda.w	al_worldy,y
	clc
	adc	ahs_top_height
	a8
	bpl	.nohitroomL
	s_or_var	B,work1,#Lwhit_room
	bra	.sparkL
.nohitroomL
;--------------------------------------------------------------------
	a16
	lda	ahs_surface_height
	clc
	adc.w	al_worldy,y
	a8
	bmi	.effect

;--------------------------------------------------------------------
; set clip
	s_set_clipping	x,pool1

;--------------------------------------------------------------------

	s_or_var	B,work1,#Lwhit

	pl_jmp_ifinthesea	x,.end_L

	pl_jmp_ifonthe		x,sand,.sparkLSMK
	pl_jmpnot_ifonthe	x,ground,.splashL

.sparkL	jsl		makesparkL_srou_l
	bra		.sparkLsnd
.sparkLSMK	jsl		makesparkL_SMK_srou_l
.sparkLsnd
	s_or_var	B,wingdmgsound,#%00000010
	bra		.end_L
.splashL

	jsr	.makesplashL
	s_or_var	B,wingdmgsound,#%00000110

.end_L

.effect	a8
	lda	work1
	bit	#(Lwhit!Rwhit!Lwhit_room!Rwhit_room)
	beq	.exit

	toheap	y,x

	bit	#(Lwhit_room!Rwhit_room)
	beq	.rotxnorm
.rotxroom	lda	#18h
	bra	.rotxadd
.rotxnorm	lda	#-18h
.rotxadd	clc
	sta	exal_rotx+1,y

	lda		exal_rotztilt,y
	asra
	asra
	sta		exal_rotztilt,y

	pl_jmp_ifinthesea	x,.exit

	c_shock_cam	x,#40H,y


	jsr	.dmgsound

	plp
	ply
	plx
	sec
	rtl

.exit

	jsr	.dmgsound

	plp
	ply
	plx
	clc
	rtl


.calc0
	s_add_roffs2pos	B,y,x,x,wingposxofs,wingposyofs,#0,1,1,1

	rts


.makesplashR

	s_set_var	B,x1,#20
	bra		.mslr
.makesplashL
	s_set_var	B,x1,#-20

.mslr	s_set_var	B,z1,#0

	a16
	lda		ahs_surface_height
	nega
	sta		z2
	a8

	s_set_var	B,y2,#2	; size

	pl_jmp_ifonthe	x,magma,.magma

.water	s_set_var	B,y1,#3
	jsl		makesplash_srou_l
	bra		.done

.magma	s_set_var	B,y1,#0
	jsl		makeMsplash_srou_l

.done	rts




.dmgsound
	SHORTA
	LONGI

	km_jmpgameflag	freeze,.gse_n

	a16
	phx
	lda	wingdmgsound
	and	#%111
	asl	a
	tax
	lda.l	.tab,x
	sta	tpx
	a8
	plx
	jmp	(tpx)


.tab
	dw	.gse_n&WM	;dummy
	dw	.gse_r&WM
	dw	.gse_l&WM
	dw	.gse_c&WM

	dw	.wse_n&WM	;dummy
	dw	.wse_r&WM
	dw	.wse_l&WM
	dw	.wse_c&WM


.gse_c	kplsound	x,damage_s,nearC
	rts
.gse_l	kplsound	x,damage_s,nearL
	rts
.gse_r	kplsound	x,damage_s,nearR
	rts

.wse_c	kplsound	x,wingwaterdmg,nearC
	rts
.wse_l	kplsound	x,wingwaterdmg,nearL
	rts
.wse_r	kplsound	x,wingwaterdmg,nearR


.wse_n
.gse_n
	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; calc var (x2) * sin (x1)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	in	:x1 angle (8bit)
;		:x2 var   (16bit)
;	out	:y1(32bit)
;		:tpx,tpy = temp

calc_cos16_l

	SHORTA
	LONGI

	php

	a16
	lda	x1
	and	#0ffH
	PHX
	tax
	lda.l	costab,x
	jmp	calc_sin16_l.enter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; calc var (x2) * sin (x1)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	in	:x1 angle (8bit)
;		:x2 var   (16bit)
;	out	:y1(32bit)
;		:tpx,tpy = temp

calc_sin16_l

	SHORTA
	LONGI

	php

	a16
	lda	x1
	and	#0ffH
	PHX
	tax
	lda.l	sintab,x

.enter	LOCAL

	PLX
	sexa
	sta	x1
	plp

	jmp	Pcalc_muls161632_l

	SHORTA
	LONGI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Exact SIGNED 16 bit * 16 bit multiply with 32 bit accumulate
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	in	:x1(16bit)
;		:x2(16bit)
;	out	:y1(32bit)
;		:tpx,tpy = temp

	SHORTA
	LONGI

Pcalc_muls161632_l

	PUSHXYPB

	a8i16

	lda	#0
	pha
	plb

	a16i8

	muls161632mac	x1,x2,y1,tpx,tpy

	PULLXYPB

	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; player ga slope ni hit suru.
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	SHORTA
	LONGI

ARWINGhit_slope_l

	s_start_strat

	PUSHXYP

	a8i16

	toheap		y,x

; --- hit slope ---

	sm_jmp_hitslope	x,work0,.hit

;*******************************************************************

	lda	playerctlmode
	cmp	#map_room
	rlbne	.nohit0

	PHX

	a16
	ldx	dummyobj

	lda	exal_vx,y
	clc
	adc	exal_worldxold,y
	sta	al_worldx,x
	lda	exal_vy,y
	clc
	adc	exal_worldyold,y
	sta	al_worldy,x
	lda	exal_vz,y
	clc
	adc	exal_worldzold,y
	sta	al_worldz,x

	a8
	jsl	getheight_l
	a16
	lda	al_slopeptr,x
	sta	x1

	lda	al_slopetype,x
	and	#0ffh
	sta	x2
	a8

	TXY
	PLX

	toheap	y,x

	a16
	lda	al_worldy,x	; hight
	cmp	y1
	a8
	rlbmi	.nohit0

	lda	x2	; type
	cmp	#st_wall
	rlbeq	.nohit0

	lda	exal_blockmapstatus,y
	and	#~exal_blockmapstatus_SE
	sta	exal_blockmapstatus,y

	a16
	lda	x1	; ptr
	a8
	rlbeq	.nohit0

	a16
	lda	x1
	sta	al_slopeptr,x
	a8
	lda	x2
	sta	al_slopetype,x


;*******************************************************************

.hit
	pl_jmpnot_ifitemshield	x,.noshield

	jsl	reflectSE_srou_l

;;;	kplsound		x,shieldreflect


; flash
	s_jmp_alvarnotZERO	B,y,exal_nohitRISE,.nohit0

	jmp			.nohit0


.noshield	s_set_objtobealvar	y,x,al_slopeptr
	cpy			#0
	rlbeq			.nohit0

	s_jmp_alsflag	x,nohitaffect_really,.nohit0

	jsl		shock_wave_srou_l

	toheap		y,x

	lda	playerctlmode
	and	#0ffh
	cmp	#map_room
	beq	.norx
	s_add_alvar	W,y,exal_rotx,#-1800H
.norx

	IFNE	PLAYERHIT

	jsl	hit_effect_l

; --- dec HP ---

	s_set_objtobealvar	y,x,al_slopeptr

	s_copy_alvar2var	B,y,tpx,al_AP

	ELSEIF

	s_set_var	B,tpx,#0

	ENDC

;------------------------------------------------------------------------------------
; SP arwing ha damage hanbun
;
;	pl_lda_PILOTNoFSG	x
;	cmp	#ep_SP
;	bne	.noSP
;	lda	tpx
;	asr	a
;	sta	tpx
;.noSP
;------------------------------------------------------------------------------------
; decHP
	s_push_obj	y

	toheap	y,x
	lda	exal_HP,y
	beq	.kill
	sec
	sbc	tpx
	bpl	.seteHP
	lda	#0
.seteHP	sta	exal_HP,y
	bra	.HP

.kill	lda	#0
	sta	al_HP,x

.HP	s_pull_obj	y

;------------------------------------------------------------------------------------

.se	lda.w		al_AP,y
	cmp		#4
	bcc		.se_s

.se_l	kplsound	x,damage_l
	bra		.nohit0
.se_s	kplsound	x,damage_s


.nohit0	PULLXYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Arwing hits wall
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ARWINGhit_wall_l

	rtl

	IFEQ	1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
aww_ax	equ	work9
aww_az	equ	work7
aww_bx	equ	work6
aww_bz	equ	work4
aww_flag	equ	work3
aww_slopeptr	equ	work2
	s_start_strat
	PUSHXYP
	a8i16
	toheap			y,x
	pl_jmpnot_ifhitwall	x,.exit
;-------------------------------------------------------------------------------------
; if hit blockmap then exit.
;	s_jmp_alvarAND	B,y,exal_blockmapstatus,#exal_blockmapstatus_playerout,.exit
;-------------------------------------------------------------------------------------
	stz	aww_flag
	s_jmp_alvarNE	B,x,al_slopetype,#st_wall,.wing
	s_jmp_higher	x,y1,.wing
;-------------------------------------------------------------------------------------
;	a16
;	lda	al_worldx,x
;	sta	aww_ax
;	lda	al_worldz,x
;	sta	aww_az
;	lda	exal_worldxold,y
;	sta	aww_bx
;	lda	exal_worldzold,y
;	sta	aww_bz
;	ldy	dummyobj
;	lda	al_worldy,x
;	sta.w	al_worldy,y
;	a8
;.clamploop
;; center pos
;	a16
;	lda	aww_ax
;	clc
;	adc	aww_bx
;	adiv2
;	sta	aww_ax
;	sta.w	al_worldx,y
;	lda	aww_az
;	clc
;	adc	aww_bz
;	adiv2
;	sta	aww_az
;	sta.w	al_worldz,y
;	a8
;	s_exg_objs
;	jsl	getheight_l
;	s_exg_objs
;	a16
;	lda.w	al_slopeptr,y
;	beq	.endloop
;.out	inc	aww_flag
;	lda	aww_flag
;	bit	#0f8h
;	beq	.clamploop
;	lda	aww_bx
;	sta	al_worldx,x
;	lda	aww_bz
;	sta	al_worldz,x
;	bra	.endloop
;.in	lda.w	al_worldx,y
;	sta	al_worldx,x
;	lda.w	al_worldz,y
;	sta	al_worldz,x
;.endloop	a8

	toheap	y,x
	jsl	clamptoside_l
	a16
	lda	exal_worldxold,y
	sta	al_worldx,x
	lda	exal_worldzold,y
	sta	al_worldz,x
	lda	x1
	bne	.novx
	lda	al_vx,x
	clc
	adc	al_worldx,x
	sta	al_worldx,x
.novx	lda	z1
	bne	.novz
	lda	al_vz,x
	clc
	adc	al_worldz,x
	sta	al_worldz,x
.novz	a8
.wing
.SE	lda	aww_flag
	beq	.noSE
	s_or_alvar	B,y,exal_blockmapstatus,#exal_blockmapstatus_SE
	a16
	lda	exal_worldxold,y
	sta	al_worldx,x
	lda	exal_worldyold,y
	sta	al_worldy,x
	lda	exal_worldzold,y
	sta	al_worldz,x
	a8
.noSE
.exit	PULLXYP
	rtl
;-------------------------------------------------------------------------------------
; clamp Nose
;-------------------------------------------------------------------------------------
.clamp
; add clamp vector
	a16
	lda		x1
	clc
	adc		al_worldx,x
	sta		al_worldx,x
	lda		z1
	clc
	adc		al_worldz,x
	sta		al_worldz,x
	a8
	rts
;-------------------------------------------------------------------------------------
; Check wing
;-------------------------------------------------------------------------------------
.ckwing
	SHORTA
	LONGI
	PHY
	ldy	dummyobj
	s_copy_rots	y,x
	s_add_roffs2pos	B,y,x,x,x1,#20,#0,0,1,1
	s_push_obj	x
	tyx
	jsl		getheight_l
	s_jmp_alvarNE	B,x,al_slopetype,#st_wall,.ckend
	s_jmp_higher	x,y1,.ckend
	jsl	clamptoside_l
	jsr	.clamp
.ckend	s_pull_obj	x
	PLY
	rts
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Armer tutu clamp
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ARMERhit_tutu_l

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
aht_rotx	equ	work9
aht_zofs	equ	work8
aht_posy	equ	work7
	s_start_strat
	PUSHYP
	a8i16
	toheap	y,x
	s_copy_alvar2var	B,y,aht_rotx,exal_jetrot
.head	pl_get_shapetab	W,x,aht_zofs,jetnoseposz
	jsr		.checkhit
	bcc		.tail
	jsr		.spark
	bra		.exit
.tail	pl_get_shapetab	W,x,aht_zofs,jettailposz
	jsr		.checkhit
	bcc		.exit
	jsr		.spark
.exit	PULLYP
	rtl
.spark	s_copy_var2var	B,z1,aht_zofs
	jsl	makesparkAML_srou_l
	s_copy_var2var	B,z1,aht_zofs
	jsl	makesparkAMR_srou_l
	kplsound	x,damage_s
	c_shock_cam	x,#80H,y
	rts
;--------------------------------------------------------------------------------
.checkhit	s_copy_var2var	W,aht_posy,aht_zofs
	tf_sin_var16	W,aht_posy,aht_rotx
	a16
	lda		aht_posy
	asl		a
	clc
	adc		al_worldy,x
	sta		y1	;aht_posy
; tenjyo ni hit sita?
.yH	lda	exal_tutucenteryH,y
	sec
	sbc		y1	;aht_posy
	bmi	.yL
	bra	.hit
; yuka ni hit sita?
.yL	lda	exal_tutucenteryL,y
	sec
	sbc		y1	;aht_posy
	bpl	.nohit
.hit	clc
	adc	al_worldy,x
	sta	al_worldy,x
	lda	exal_vy,y
	bpl	.pvec
	clc
	adc	#-500H
	bra	.vec
.pvec	clc
	adc	#500H
.vec	nega
	sta	exal_vy,y
	a8
	lda	exal_jetrotx,y
	bpl	.jrpl
	nega
.jrpl	and	#40H
	asl	a
	sta	x1
	s_achase_alvar	B,y,exal_jetrotx,x1,1
	sec
	rts
.nohit	a8
	clc
	rts
;--------------------------------------------------------------------------------
jetposx_L	shapetab	B,jettailx_
jetposx_R	shapetabNEG	B,jettailx_
jettailposz	shapetab	W,jettailz_
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; suibotsu demo wo yaruka?
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	IFEQ	1

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
entersea_srou_l
	s_start_strat
	PUSHYP
; splash effect no test
	toheap	y,x
; sui botsu no splash wo tsukuruka?
	s_jmpnot_alvarAND	B,y,exal_VIEWflag3,#exal_VIEWflag3_splash,.exitsplash
	lda	exal_nohit,y
	bit	#exal_nohit_scrsplash
	bne	.chckreallyon
	ora	#exal_nohit_scrsplash
	sta	exal_nohit,y
	s_set_var	B,x1,#-10
	s_set_var	B,y1,#20
	s_set_var	B,z1,#20
	jsl	makedemosplash_srou_l
	s_set_var	B,x1,#0
	s_set_var	B,y1,#10
	s_set_var	B,z1,#20
	jsl	makedemosplash_srou_l
	s_set_var	B,x1,#10
	s_set_var	B,y1,#20
	s_set_var	B,z1,#20
	jsl	makedemosplash_srou_l
.chckreallyon	; really flag wo on ni suruka?
.exitsplash	PULLYP
	rtl
;******************************************************
adcoldat	macro	[r,g,b]
	db	20H+({r}&1fH)
	db	40H+({g}&1fH)
	db	80H+({b}&1fH)
	db	0
	endm
; splash color add data
splashaddcol	adcoldat	04H,04H,14H
	adcoldat	04H,04H,15H
	adcoldat	04H,04H,16H
	adcoldat	04H,04H,18H
	adcoldat	04H,04H,18H
	adcoldat	04H,04H,16H
	adcoldat	04H,04H,15H
	adcoldat	00H,00H,14H
	adcoldat	00H,00H,10H
	adcoldat	00H,00H,0cH
	adcoldat	00H,00H,08H
	adcoldat	00H,00H,04H
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	ENDC



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	noturn mode x limitter
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;----------------------------------------------------------------------------------

	s_start_strat

noturnxlmt_srou_l	; check player

ntlmt_fx	equ	work9
ntlmt_fz	equ	work8
ntlmt_cx	equ	work7	;center x
ntlmt_cz	equ	work5	;center z
ntlmt_width	equ	work4	;haba F
ntlmt_roty	equ	work2	;force roty


;	exal_forcecx		: idou no tyu-shin X
;	exal_forcecz		: idou no tyu-shin Z
;	exal_forcewidth		: idou no haba (hanbun)
;	exal_forcecy		: idou no tyu-shin Y
;	exal_forceheight	: idou no haba (y :hanbun)

	PUSHYP

	a8i16

	pl_jmp_ifturn	x,.exit

	toheap	y,x

;----------------------------------------------------------------------------------
; goto height

	sp_jmpNOT_playertype	x,ARWING,.noheight

	a16


;
;	lda	exal_forcecy,y
;	sec
;	sbc	exal_forceheight,y
;	cmp	al_worldy,x
;	bmi	.forcey
;
;	lda	exal_forcecy,y
;	clc
;	adc	exal_forceheight,y
;	cmp	al_worldy,x
;	bpl	.noheight
;
;.forcey
;	lda	exal_forcecy,y
;

	lda	#-40
	sta	y1

	jsl	gotoheight_srou_l

	a8

	s_set_alvar	W,y,exal_rotx,x1

	s_achase_alvar	W,x,al_worldy,#-40,3

.noheight
;	a8

;----------------------------------------------------------------------------------

	a16

	lda	exal_forcecx,y
	sta	ntlmt_cx
	lda	exal_forcecz,y
	sta	ntlmt_cz
	lda	exal_forcewidth,y
	sta	ntlmt_width
	lda	exal_forceroty,y
	and	#0ffH
	sta	ntlmt_roty

	a8


; cockpit mode no toki wa hirosaga 2bai..
;
;	sp_jmpnot_ifcockpit	x,.start,y
;	a16
;	lda	ntlmt_width
;	asl	a
;	sta	ntlmt_width
;	a8


.start	ldy	dummyobj
	s_copy_pos	y,x
	jsr		checkslantway_srou
	bcc		.exit
	s_copy_pos	x,y

	toheap	y,x

	a16
	lda	al_worldx,x
	sta	exal_worldx,y
	lda	al_worldz,x
	sta	exal_worldz,y
	a8


.exit	PULLYP
	rtl

;----------------------------------------------------------------------------------
;in :	idX = player's pointer
;	x1	center x
;	y1	center y
;	z1	center z
;	x2	width
;	y2	height
;	y3	forceroty
;out:	carry on : inside slant way

checkslantway_srou_l	; check in area?

	s_start_strat

	PUSHXYP

	a8i16

	toheap	y,x

;----------------------------------------------------------------------------------
; check height

	a16

	lda	y2
	bmi	.noheight

	lda	y1
	sec
	sbc	y2

	cmp	al_worldy,x
	bpl	.exitout

	lda	y1
	clc
	adc	y2

	cmp	al_worldy,x
	bmi	.exitout
.noheight
;----------------------------------------------------------------------------------
	a16
	lda	x1
	sta	ntlmt_cx
	lda	z1
	sta	ntlmt_cz
	lda	y3
	and	#0ffH
	sta	ntlmt_roty
	lda	x2
	sta	ntlmt_width
	a8
;----------------------------------------------------------------------------------

	ldy	dummyobj
	s_copy_pos	y,x
	jsr		checkslantway_srou
	bcs		.exitout

.exitinn	PULLXYP
	sec
	rtl

.exitout	PULLXYP
	clc
	rtl


;--------------------------------------------------------------------------
;in	ntlmt_cx	work7	;center x
;	ntlmt_cz	work6	;center z
;	ntlmt_width	work5	;haba
;	ntlmt_roty	work4	;haba
;in&out	dummyobj's worldx
;	dummyobj's worldz
;	dummyobj's worldy not change
;--------------------------------------------------------------------------

checkslantway_srou

	s_start_strat

	PUSHXYP

	ai16

	ldx	dummyobj

;--------------------------------------------------------------------------
; calc rc*2^(1/2) --> y1+1

	lda	ntlmt_width
	asl	a
	sta	x1
	lda	#16aH
	sta	x2
	jsl	Pcalc_muls161632_l

;----------------------------------------------------------------------------------
.check_area
	a8i16

	s_clr_alsflag	x,hitflash

	a16

	lda	al_worldx,x
	sta	x1
	sta	x2
	lda	al_worldz,x
	sta	z1
	sta	z2

	lda	ntlmt_roty

	rlbeq	.deg0
	cmp	#80H
	rlbeq	.deg0
	cmp	#40h
	rlbeq	.deg90
	cmp	#0c0h
	rlbeq	.deg90

	cmp	#20H
	rlbeq	.deg45
	cmp	#60H
	rlbeq	.deg135
	cmp	#0a0H
	rlbeq	.deg225
	cmp	#0e0H
	rlbeq	.deg315

;-----------------------------------------------------------------------------
.deg0	; check only x
.deg180	; check only x

.R0	lda	ntlmt_cx
	clc
	adc	ntlmt_width
	sec
	sbc	al_worldx,x
	bpl	.L0
	jmp	.adcxonly


.L0	lda	ntlmt_cx
	sec
	sbc	ntlmt_width
	sec
	sbc	al_worldx,x
	rlbmi	.exitout
	jmp	.adcxonly

;-----------------------------------------------------------------------------
.deg90	; check only z
.deg270	; check only z

.R90	lda	ntlmt_cz
	clc
	adc	ntlmt_width
	sec
	sbc	al_worldz,x
	bpl	.L90
	jmp	.adczonly


.L90	lda	ntlmt_cz
	sec
	sbc	ntlmt_width
	sec
	sbc	al_worldz,x
	rlbmi	.exitout
	jmp	.adczonly

;-----------------------------------------------------------------------------
.deg45

;front
	jsr	.F_45_225

.R45	lda	al_worldx,x
	clc
	adc	al_worldz,x
	sec
	sbc	ntlmt_fz	;#ntlmt_fr

	bmi	.L45

	jmp	.adcxneg

.L45	lda	al_worldx,x
	clc
	adc	al_worldz,x
	sec
	sbc	ntlmt_fx	;#ntlmt_fl

	rlbpl	.exitout

	jmp	.adczneg

;-----------------------------------------------------------------------------
.deg225	; hobo deg45

	jsr	.F_45_225

.R225	lda	al_worldx,x
	clc
	adc	al_worldz,x
	sec
	sbc	ntlmt_fx	;#ntlmt_fr

	bpl	.L225

	jmp	.adcxneg


.L225	lda	al_worldx,x
	clc
	adc	al_worldz,x
	sec
	sbc	ntlmt_fz	;#ntlmt_fl

	rlbmi	.exitout

	jmp	.adczneg

;-----------------------------------------------------------------------------
.deg315
	jsr	.F_135_315

.R315	lda	al_worldx,x
	sec
	sbc	al_worldz,x
	sec
	sbc	ntlmt_fx	;#ntlmt_fr

	bmi	.L315

	jmp	.adcz


.L315	lda	al_worldz,x
	sec
	sbc	al_worldx,x
	sec
	sbc	ntlmt_fz	;#ntlmt_fr

	rlbmi	.exitout

	jmp	.adcx

;-----------------------------------------------------------------------------
.deg135	; hobo deg315

	jsr	.F_135_315

.R135
	lda	al_worldx,x
	sec
	sbc	al_worldz,x
	clc
	adc	ntlmt_fz	;#ntlmt_fl

	rlbpl	.L135

	jmp	.adcz

.L135

	lda	al_worldz,x
	sec
	sbc	al_worldx,x
	clc
	adc	ntlmt_fx	;#ntlmt_fr

	bpl	.exitout

	jmp	.adcx

;----------------------------------------------------------------------------------
.adcxneg	nega
	asra
	pha
	clc
	adc	al_worldx,x
	sta	al_worldx,x
	pla
	bra	.adczonly
;----------------------------------------------------------------------------------
.adczneg	nega
	asra
	pha
	clc
	adc	al_worldz,x
	sta	al_worldz,x
	pla
	bra	.adcxonly

;----------------------------------------------------------------------------------
.negadcx	nega
.adcx	asra
	pha
	clc
	adc	al_worldx,x
	sta	al_worldx,x
	pla
	nega
	bra	.adczonly

;----------------------------------------------------------------------------------
.negadcz	nega
.adcz	asra
	pha
	clc
	adc	al_worldz,x
	sta	al_worldz,x
	pla
	nega

;----------------------------------------------------------------------------------
.adcxonly	clc
	adc	al_worldx,x
	sta	al_worldx,x
	bra	.flash
;----------------------------------------------------------------------------------
.adczonly	clc
	adc	al_worldz,x
	sta	al_worldz,x
;----------------------------------------------------------------------------------
.flash
	PULLXYP
	sec
	rts

;----------------------------------------------------------------------------------
.exitout	PULLXYP
	clc
	rts




;--------------------------------------------------------------------------

; calc fx deg45&225

;  fx=(X+Z)-Rc*2^(1/2)
;  fz=(X+Z)+Rc*2^(1/2)

.F_45_225
	LONGA
	LONGI

	jsr	.calcrc

; fc-rc*2^(1/2)

	lda	ntlmt_cz
	clc
	adc	ntlmt_cx
	clc
	adc	y1+1
	sta	ntlmt_fz

; calc fz

; +fc+rc*2^(1/2)

	lda	ntlmt_cz
	clc
	adc	ntlmt_cx
	sec
	sbc	y1+1
	sta	ntlmt_fx

	rts

;--------------------------------------------------------------------------

; calc fx

;  fx=-(X-Z)-Rc*2^(1/2)
;  fz=(X-Z)+Rc*2^(1/2)


.F_135_315
	LONGA
	LONGI

	jsr	.calcrc

; -fc+rc*2^(1/2)

	lda	ntlmt_cx
	sec
	sbc	ntlmt_cz
	clc
	adc	y1+1
	sta	ntlmt_fx

; calc fz

; +fc+rc*2^(1/2)

	lda	ntlmt_cz
	sec
	sbc	ntlmt_cx
	clc
	adc	y1+1
	sta	ntlmt_fz

	rts

;--------------------------------------------------------------------------
; calc rc*2^(1/2) --> y1+1
.calcrc
	LONGA
	LONGI

	lda	ntlmt_width
	sta	x1
	lda	#16aH
	sta	x2
	jsl	Pcalc_muls161632_l
	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Next Map Trapper
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Nextmap_trapper_srou_l
;in	core_x		: base's worldx
;	core_z		: base's worldz
;	core_roty	: base's roty
trap_width	equ	50
trap_length	equ	4000
trap_renge	equ	20	: incone range
	s_start_strat
	PHP
	a8i16
;----------------------------------------------------------------------------------
; player incone?
; get the relative position of the player to the current shape
	a16
	lda	al_worldx,x
	sec
	sbc	corex
	sta	x1
	lda	al_worldz,x
	sec
	sbc	corez
	sta	y1
	a8
	jsl	arctan16_l
	a8
	xba
	sta	x1
	lda	#trap_renge<<1	; get range & multiply it by 2
	sta	z1
	clc
	adc	coreroty	; add y rotation
	clc
	adc	x1		; sub angle returned by arctan
	cmp	z1	; double the range and compare (+- range)
	rlbcs	.exit
;----------------------------------------------------------------------------------
; force roty
	lda		coreroty
	clc
	adc		#deg180
	sta		y1
; force worldx,worldz
	a16
	lda		corex
	sta		x1
	lda		corez
	sta		z1
; haba(toriarzu 50)
	lda	#trap_width
	sta	x2
	jsl	checkslantway_srou_l
	rlbcc	.noslant
; trap no nagasa(toriarzu 2000)
	lda		corex
	sec
	sbc		al_worldx,x
	bpl		.pfcw0
	nega
.pfcw0	cmp		#trap_length
	rlbpl		.noslant
	lda		corez
	sec
	sbc		al_worldz,x
	bpl		.pfcw1
	nega
.pfcw1	cmp		#trap_length
	bpl		.noslant
	a8
; force roty
	lda		coreroty
	clc
	adc		#deg180
	sta		y1
	pl_forceturn	x,y1,corex,corez,#trap_width
	lda	demoflag
	ora	#demoflag_nextmap_trapped
	sta	demoflag
.noslant
;----------------------------------------------------------------------------------
.exit	PLP
	rtl
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC



	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENTER TUTU MODE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AWentertutu_srou_l
entertmp0	equ	work9+0
enterxofs	equ	work8
	s_start_strat
	PUSHYP
	toheap	y,x
;--------------------------------------------------------------------------------
	pl_jmpnot_ifentermode	x,.exit,y
;	s_jmpnot_alvarand	B,y,exal_control2,#exal_control2_enter_on,.exit
;--------------------------------------------------------------------------------
	sp_jmpnot_playertype	x,ARWING,.exit,y
;--------------------------------------------------------------------------------
	s_set_var	W,enterxofs,#0
;--------------------------------------------------------------------------------
; set enter pos (test)
	s_set_var	W,x1,#0
	s_set_var	W,z1,#enterbossz
	s_set_var	W,y1,#-2000
	pl_enterpos	x,x1,y1,z1,#200,y
;--------------------------------------------------------------------------------
; enter flag on ?
	pl_jmp_ifenter	x,.enterlv1,1,y
	pl_jmp_ifenter	x,.enterlv2,2,y
	pl_enterdist_ifmore	x,#6200,.exit	;8000,.exit
;	pl_jmp_ifenter	x,.mode_enter,0,y
	pl_enter	x,on,1,y
	pl_control	x,off
	s_set_alvar	B,y,exal_vel,#0
;;;	c_set_demoviewstrat	x,gototutu_0,y
;;;	c_set_demoviewstrat	x,risetutu_1,y
;;;	c_set_demoviewstrat	x,rollenter,y
	c_set_demoviewstrat	x,startenter,y
	c_view_inbetween	x,on,y
;;;	c_set_demoviewstrat	x,waitenter,y
	jsl		makering_srou_l
.noenter
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENTER TUTU MODE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;[mode:go to tutu]
.mode_enter
.enterlv1
;--------------------------------------------------------------------------------
	s_or_alvar	B,y,exal_vxvyvz,#exal_vxvyvz_ALL
;-------------------------------------------------------------------------------------
	jsr	.faceenter
;-------------------------------------------------------------------------------------
;goto enterposy	; set rotx
;rise?
	s_set_alvar	B,x,al_vel,#30
	s_set_alvar	B,y,exal_vel,#0
	pl_enterdist_ifmore	x,#4800,.nospeedup
	s_set_alvar	B,x,al_vel,#40
	s_set_alvar	B,y,exal_vel,#30
	pl_enterdist_ifless	x,#2500,.rise
	pl_enterdist_ifless	x,#3000,.nospeedup
	pl_Sboost	x,on
.nospeedup	s_set_var	W,x1,#0
	bra		.rotx
.rise	pl_Sboost	x,off
	s_set_alvar	B,x,al_vel,#70
	s_set_alvar	B,y,exal_vel,#0
	a16
	lda	exal_enterposy,y
	clc
	adc	#-1058-200	;-120
	sta	y1
	lda	#80	;200
	sta	z1
	a8
	jsl	gotoheight_srou_l
.rotx	s_achase_alvar	W,y,exal_rotx,x1,3
	s_copy_alvar2var	W,y,z1,exal_enterwidth
	pl_enterdist_ifmore	x,z1,.elv0_1
	pl_enter		x,on,2,y
	a16
	lda	al_worldx,x
	sec
	sbc	exal_enterposx,y
	sta	exal_worldxoffset,y
	lda	al_worldz,x
	sec
	sbc	exal_enterposz,y
	sta	exal_worldzoffset,y
.elv0_1
	a8
.enterlv0end
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	LOOP THE LOOP MODE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.enterlv2	pl_jmpnot_ifenter	x,.exit,2,y
;--------------------------------------------------------------------------------
	s_or_alvar	B,y,exal_vxvyvz,#exal_vxvyvz_ALL
;-------------------------------------------------------------------------------------
;	jsr		explode_enter
	s_set_alvar	B,x,al_vel,#40
	s_set_alvar	B,y,exal_vel,#0
	lda	exal_rotx+1,y
	clc
	adc	#40H
	rlbpl	.deg00_BF
.degC0_3F	s_and_alvar	W,y,exal_rotx,#(7ffH)^-1
	s_jmp_alvarEQ	W,y,exal_rotx,#4000H,.deg40
	s_sub_alvar	W,y,exal_rotx,#2*256		;8*256
	jmp		.adjust
.deg40	pl_Sboost	x,on
	s_achase_alvar2alvar	W,x,al_worldx,y,exal_enterposx,1
	s_achase_alvar2alvar	W,x,al_worldz,y,exal_enterposz,1
;----------------------------------------------------------------------------
; attack gate
	s_jmp_notandframe	#1,.nofire
	a16
	lda	al_worldy,x
	sec
	sbc	exal_enterposy,y
	clc
	adc	#1058-300
	bpl	.nofire
	clc
	adc	#600
	bpl	.explode
.fire	a8
	jsr	arwing_fire_laser1
	bra	.nofire
.explode	a8
	jsr	explode_enter
	s_set_var	B,plrseqflag,#1
.nofire
;----------------------------------------------------------------------------
	a16
	lda.w	al_worldy,x
	adc	#-enterendy
	a8
	rlbmi	.notrans
	s_set_alvar	B,x,al_vel,#0
	s_set_alvar	W,x,al_vx,#0
	s_set_alvar	W,x,al_vy,#0
	s_set_alvar	W,x,al_vz,#0
	s_set_alvar	W,y,exal_vx,#0
	s_set_alvar	W,y,exal_vy,#0
	s_set_alvar	W,y,exal_vz,#0
	sp_trans_do	x,ARMER,y
	sp_trans_lock	x,y
	pl_control	x,on,y
	pl_turn		x,on,y
;	sp_can_trans	x,y
	pl_enter	x,off,y
.notrans	jmp		.adjust
.deg00_BF	s_and_alvar	W,y,exal_rotx,#(3ffH)^-1
	s_sub_alvar	W,y,exal_rotx,#1*256	;4*256
.adjust	a16
	lda	exal_worldxoffset,y
	jsl	perc75A_l
	pha
	sec
	sbc	exal_worldxoffset,y
	clc
	adc	al_worldx,x
	sta	al_worldx,x
	pla
	sta	exal_worldxoffset,y
	lda	exal_worldzoffset,y
	jsl	perc75A_l
	pha
	sec
	sbc	exal_worldzoffset,y
	clc
	adc	al_worldz,x
	sta	al_worldz,x
	pla
	sta	exal_worldzoffset,y
	a8
.exit	PULLYP
	rtl
;----------------------------------------------------------------------------------
;set roty
.faceenter	s_start_strat
	phy
	toheap			y,x
	s_copy_alvar2var	W,y,x1,exal_enterposx
	s_copy_alvar2var	W,y,y1,exal_enterposy
	s_copy_alvar2var	W,y,z1,exal_enterposz
	s_add_var	W,y1,#-300
	jsl		obj2pos_srou_l
	s_achase_alvar	B,x,al_roty,y1+1,3
	ply
	rts
;----------------------------------------------------------------------------------
checkenterdist_srou_l	; in	x2: dist
			; out	x1: dist
	phy
	php
	toheap	y,x
	a16
	lda	exal_enterposx,y
	sec
	sbc	al_worldx,x
	sta	x1
	lda	exal_enterposz,y
	sec
	sbc	al_worldz,x
	sta	y1
	lda	x1
	bpl	.elv0plx
	nega
.elv0plx	cmp	x2
	bcs	.out
	lda	y1
	bpl	.elv0plz
	nega
.elv0plz	cmp	x2
	bcs	.out
.in	plp
	ply
	sec
	rtl
.out	plp
	ply
	clc
	rtl
;----------------------------------------------------------------------------------
makering_srou_l
;	rtl
;
;	IFEQ	1
	PUSHXYP
	a8i16
	s_make_obj	#yuka_to,.badobj
	s_set_aldata	y,#1,#1
;	s_copy_pos	y,x
;	s_set_alvar	W,y,al_worldx,#0
;	s_set_alvar	W,y,al_worldy,#enterbossy
;	s_set_alvar	W,y,al_worldz,#enterbossz
	s_set_alptrs	y,extragate_Istrat,hit_istrat,explode_istrat
	s_set_alsflag	y,realobj
	s_set_alsflag	y,nohitaffect
.badobj	PULLXYP
	rtl
;.strat	LOCAL
;	s_start_strat
;	s_end_strat
;
;	ENDC
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; y clip no ON OFF wo check suru...
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

checkYclip_srou_l

;	in	:idX player's pointer
;	out	:carry = 0 not water
;		:carry = 1 water!
;		:set depth to exal_pooldepth

; check on the pool

	s_start_strat

	PUSHXYP

	a8i16

	ldy	al_slopeptr,x
	rlbeq	.checksea

	lda	al_slopetype,x
	cmp	#st_ground
	rlbne	.ontheslope

	toheap	y,x

	a16
	lda	exal_getheight_WY,y
	sec
	sbc	SEADEPTH
	a8
	rlbpl	.checksea


	s_copy_alvar2alvar	B,y,exal_pooltype,x,al_slopetype
	jmp	.clrf

;-------------------------------------------------------------------------
; ground or sea?

.checksea

	toheap	y,x

	s_set_alvar		B,y,exal_pooltype,seatype

	pl_jmpnot_ifexistSEA	.clrf

	s_copy_var2var	W,y1,seadepth

	bra	.setclip

;-------------------------------------------------------------------------
; slope no ue

.ontheslope	a8

	s_push_obj		y
	ldy			al_sword2,x
	s_copy_alvar2alvar	B,y,exal_pooltype,x,al_slopetype
	s_pull_obj		y

	cmp			#st_water
	rlbeq			.slopedepth
	cmp			#st_magma
	rlbne			.clrf

.slopedepth	a16
	lda.w	al_pword1,y

	clc
	adc.w	al_worldy,y
	sta	y1

;-------------------------------------------------------------------------

.setclip	a8
	POLL_MARIO
;	s_jmp_alsflag	x,player2,.mc2

.mc1	a16
	lda	y1
	sta.l	m_poolclip1
;	bra	.mc
;.mc2	a16
;	lda	y1
;	sta.l	m_poolclip2
.mc	a8
	UNPOLL_MARIO

;-------------------------------------------------------------------------
; set depth
	toheap	y,x

	a16
	lda	y1
	sta	exal_pooldepth,y
	a8

	PULLXYP
	sec
	rtl

;-------------------------------------------------------------------------
.clrf
	toheap	y,x

	a16
	lda	#0
	sta	exal_pooldepth,y
	a8

	PULLXYP
	clc
	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	calc angle obj 2 pos
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	IFEQ	1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

obj2pos_srou_l	; in	x1	worldx
		;	y1	worldy
		;	z1	worldz
		; out	x1	rotx(16bit)
		;	y1	roty(16bit)

	s_start_strat

	PUSHYP

	a8
;	POLL_MARIO

	ldy	dummyobj

	a16
	lda	x1
	sta.w	al_worldx,y
	lda	y1
	sta.w	al_worldy,y
	lda	z1
	sta.w	al_worldz,y
	a8

	s_exg_objs
	s_obj2obj_3dangle	x,y,al_roty,al_rotx,0
	s_exg_objs

	a16
	lda.w	al_roty,y
	adc	#128
	xba
	and	#0ff00H
	sta	y1

	lda.w	al_rotx,y
	nega

	clc
;	adc	#128
;
	xba
	and	#0ff00H
	sta	x1

;	a16
;-------------------------------------------------
;	jsl	Xanglexy_l
;	a16
;	pha
;-------------------------------------------------
;	jsl	Yanglexy_l
;	a16
;	sta	Y1
;-------------------------------------------------
;	pla
;	sta	x1

	a8
;	UNPOLL_MARIO

	PULLYP

	rtl

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
explode_enter

	shorta
	longi

	PUSHXYP

	a8i16
	jsl		generateexplode2_l
	rlbcc		.exit

	toheap		x,x

	a16
	lda	exal_enterposx,x
	sta.w	al_worldx,y
	lda	exal_enterposy,x
	clc
	adc	#-1058-20	;+100
	sta.w	al_worldy,y
	lda	exal_enterposz,x
	sta.w	al_worldz,y
	a8

	s_add_rnd2pos	y,63,15,63,1,0,1
	s_set_alvar	B,y,al_tx,#0

.exit
	PULLXYP

	rts

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC


	IFEQ	1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
rebound_srou_l

	s_start_strat

	PUSHXYP

;-------------------------------------------------------------------------------------------------

	ldy	al_hitlist,x
	rlbeq	.exit

;-------------------------------------------------------------------------------------------------
; X hitter's pointer


.next	ldx.w	hl_alptr,y

	s_push_obj	y	;*

; X = hitter obj   Y = rebound obj

	s_jmpnot_colltype	x,LASER,.gotonext

	lda	al_roty,x
	clc
	adc	#deg180
	sta	y1

	lda	al_rotx,x
	nega
	sta	x1

	s_push_obj	x
	ldx		rbd_ptr

	lda	y1
	sec
	sbc	al_roty,x
	sta	y1


	cpx	playpt1
	bne	.notplayer
	cpx	playpt2
	bne	.notplayer

	pl_jmpnot_ifrollingshield	x,.fire

.notplayer

; rolling nara RANDOM ni suru.

	s_add_rnd2var	x1,#63
	s_add_rnd2var	y1,#63
	s_add_var	B,x1,#-32
	s_add_var	B,y1,#-32

.fire
	s_weapon_rot	x1,y1
	s_weapon_pos	#0,#0,#0

	s_fire_weapon	x,rebound
	s_pull_obj	x

; copy data

	s_copy_alvar2alvar	W,y,al_shape,x,al_shape

	s_copy_pos	y,x


; sprite

	s_sprite_obj		y,#0,#0

	s_jmpnot_alsflag	x,ssprite,.notsprite
	s_set_alsflag		y,ssprite
	s_copy_alvar2alvar	B,y,al_depthoffset,x,al_depthoffset
	s_copy_alvar2alvar	B,y,al_tx,x,al_tx

.notsprite

; sound on


	s_add_var		B,rbd_sound,#1


.gotonext

	s_pull_obj	y	;*


; battle mode no toki ha 1 patsu dake...


;	sm_jmp_if1screen	.continue
;
;	s_jmp_varnotzero	B,rbd_sound,.exit
;

.continue	a16
	lda.w	_next,y
	tay
	a8

	rlbne	.next

;-------------------------------------------------------------------------------------------------
.exit
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	PULLXYP
	rtl

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC







;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Block map system
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

blockmap_srou_l

bm_px	equ	work9
bm_bx	equ	work8
bm_pz	equ	work7
bm_bz	equ	work6
bm_flag	equ	work5+0
bm_pointer	equ	work5+1
bm_forceroty	equ	work4
bm_headroty	equ	work3
bm_clampflag	equ	work2

	s_start_strat

	PUSHXYP

	a8i16

	lda	demomode
	rlbne	.exit

	toheap	y,x

;----------------------------------------------------------------------------------
; flag off
	s_and_alvar	B,y,exal_blockmapstatus,#~exal_blockmapstatus_viewout

;----------------------------------------------------------------------------------

	pl_jmp_ifblockoff	x,.exit,y

	c_jmp_ifdemoview	x,.exit,y

;----------------------------------------------------------------------------------
; view out area?

.viewsolid
	s_push_obj	y
	pl_ldy_viewblk		x
	s_jmp_ifnotsolid	y,.vin
	s_pull_obj	y
	s_or_alvar	B,y,exal_blockmapstatus,#exal_blockmapstatus_viewout
	bra		.exitvs
.vin	s_pull_obj	y
.exitvs

;----------------------------------------------------------------------------------
;	lda	exal_blockmapstatus,y
;	bit	#%10
;	beq	.inc
;	and	#~exal_blockmapstatus_mask
;	bra	.sta
;
;.inc	inc	a
;.sta	sta	exal_blockmapstatus,y
;
;.check	and	#exal_blockmapstatus_mask
;	dec	a
;	beq	.B
;	dec	a
;	beq	.R
;
;.L	s_set_var	B,x1,#-40
;	s_set_var	B,z1,#0
;	jsr		.wingsolid
;	bcs		.Lend
;	s_and_alvar	B,y,exal_blockmapstatus,#exal_blockmapstatus_Lout^-1
;	bra		.exitxofs
;.Lend	s_or_alvar	B,y,exal_blockmapstatus,#exal_blockmapstatus_Lout
;	bra		.exitxofs
;
;.R	s_set_var	B,x1,#40
;	s_set_var	B,z1,#0
;	jsr		.wingsolid
;	bcs		.Rend
;	s_and_alvar	B,y,exal_blockmapstatus,#exal_blockmapstatus_Rout^-1
;	bra		.exitxofs
;.Rend	s_or_alvar	B,y,exal_blockmapstatus,#exal_blockmapstatus_Rout
;	bra		.exitxofs
;
;.B	s_set_var	B,x1,#0
;	s_set_var	B,z1,#-40
;	jsr		.wingsolid
;	bcs		.Bend
;	s_and_alvar	B,y,exal_blockmapstatus,#exal_blockmapstatus_Bout^-1
;	bra		.exitxofs
;
;.Bend	s_or_alvar	B,y,exal_blockmapstatus,#exal_blockmapstatus_Bout
;
;.exitxofs

;----------------------------------------------------------------------------------
	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	jmp	.notwall
	s_jmp_alvarNE	B,x,al_slopetype,#st_wall,.notwall
;	a16
;	lda	al_worldx,x
;	printh	WORLDX_WALL,kawagoe
;	lda	al_worldz,x
;	printh	WORLDZ_WALL,kawagoe
;	a8
	pl_block_getpos	x,al_worldx,al_worldz,bm_bx,bm_bz
	lda	exal_blockx,y
	cmp	bm_bx
	beq	.cnbxold
	sta	exal_blockxold,y
.cnbxold	lda	exal_blockz,y
	cmp	bm_bz
	beq	.cnbzold
	sta	exal_blockzold,y
.cnbzold	s_copy_alvar2alvar	B,y,exal_blockx,y,exal_blockxold
	s_copy_alvar2alvar	B,y,exal_blockz,y,exal_blockzold
	jmp		.insolid
.notwall
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC
;----------------------------------------------------------------------------------

	s_jmp_ifsolid	x,.insolid

;----------------------------------------------------------------------------------
; normal area

	pl_block_getpos	x,al_worldx,al_worldz,bm_bx,bm_bz

;************

	lda	exal_blockx,y
	cmp	bm_bx
	beq	.nbxold
	sta	exal_blockxold,y

.nbxold
	lda	exal_blockz,y
	cmp	bm_bz
	beq	.nbzold
	sta	exal_blockzold,y
.nbzold

;************

	s_set_alvar	B,y,exal_blockx,bm_bx
	s_set_alvar	B,y,exal_blockz,bm_bz

	s_and_alvar	B,y,exal_blockmapstatus,#~exal_blockmapstatus_playerout

	jmp		.exit

;----------------------------------------------------------------------------------
.insolid

; tell 2 status flag.....

	lda	exal_blockmapstatus,y
	bit	#exal_blockmapstatus_playerout
	bne	.SEoff
.SEon	ora	#exal_blockmapstatus_SE
.SEoff	ora	#exal_blockmapstatus_playerout
	sta	exal_blockmapstatus,y

	pl_block_getpos	x,al_worldx,al_worldz,bm_px,bm_pz

	s_copy_alvar2var	B,y,bm_bx,exal_blockx
	s_copy_alvar2var	B,y,bm_bz,exal_blockz

	jsr	bm_decideblock

	s_set_alvar		B,y,exal_blockx,bm_bx
	s_set_alvar		B,y,exal_blockz,bm_bz

	jsr	bm_calcforcedir_srou

	jsr	bm_forceroty_srou

.exit	PULLXYP
	rtl

;----------------------------------------------------------------------------------
;.wingsolid
;	sp_jmp_playertype	x,ARWING,.awws,y
;
;	asl	x1	; ROBOT
;
;.awws	s_push_obj		y
;	ldy	dummyobj
;	s_add_roffs2pos		B,y,x,x,x1,#0,z1,0,1,0,1,1,1
;	s_jmp_ifnotsolid	y,.wsin
;
;.wsout	s_pull_obj		y
;	sec
;	rts
;
;.wsin	s_pull_obj		y
;	clc
;	rts
;----------------------------------------------------------------------------------
bm_decideblock
	;in

	;idY	:heap pointer
	;	:bm_px
	;	:bm_pz
	;	:bm_bx
	;	:bm_bz

	s_start_strat

	PHY

	s_jmp_varEQ	B,bm_px,bm_bx,.decided
	s_jmp_varEQ	B,bm_pz,bm_bz,.decided

	s_set_var	B,bm_flag,#0

.pxbz	s_copy_var2var	B,tpx,bm_px
	s_copy_var2var	B,tpz,bm_bz
	jsr	.check
	bcs	.bxpz
	s_or_var	B,bm_flag,#1


.bxpz	s_copy_var2var	B,tpx,bm_bx
	s_copy_var2var	B,tpz,bm_pz
	jsr	.check
	bcs	.checked
	s_or_var	B,bm_flag,#2


.checked	lda	bm_flag
	beq	.decided
	cmp	#1
	beq	.bx2px
	cmp	#2
	beq	.bz2pz

	a16
	lda	bm_px
	jsr	.aslbm
	sec
	sbc	al_worldx,x
	bpl	.skip0
	nega
.skip0	sta	tpx
	lda	bm_pz
	jsr	.aslbm
	bpl	.skip1
	nega
.skip1	cmp	tpz
	a8
	bcc	.bz2pz


.bx2px	s_copy_var2var	B,bm_bx,bm_px
	bra		.decided
.bz2pz	s_copy_var2var	B,bm_bz,bm_pz

.decided
	PLY

	rts


.check	ldy	dummyobj

	a16
	lda	tpx
	jsr	.aslbm
	sta.w	al_worldx,y
	lda	tpz
	jsr	.aslbm
	sta.w	al_worldz,y
	a8

	s_jmp_ifsolid	y,.tpout

.tpin
	clc
	rts
.tpout
	sec
	rts


.aslbm	LOCAL

	LONGA
	xba
	and	#0ff00H
	asl	a
;REL	asl	a
	ora	#100H
	rts

;	LONGA
;	xba
;	and	#0ff00H
;	asl	a
;	asl	a
;	ora	#200H
;	rts
;----------------------------------------------------------------------------------
bm_calcforcedir_srou

	;in

	;idY 	:heap pointer
	;	:bm_px(8bit)
	;	:bm_pz(8bit)
	;	:bm_bx(8bit)
	;	:bm_bz(8bit)

	;out
	;	:bm_forceroty(8bit)
	;	:bm_headroty(16bit)

	s_start_strat

	s_set_var	B,bm_flag,#0	; flag

; check x
	lda	bm_px	; player
	sec
	sbc	bm_bx	; block
	inc	a
	and	#3
	sta	bm_pointer


; check z
	lda	bm_pz	; player
	sec
	sbc	bm_bz	; block
	inc	a
	and	#3
	asl	a
	asl	a
	ora	bm_pointer
	sta	bm_pointer

	PHX
	a16
	lda	bm_pointer
	and	#0fH

	tax

	a8

	lda.l	.tab,x
	sta	bm_forceroty

;----------------------------------------------------------------------------------
; set bm_headroty

	lda	bm_forceroty
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	and	#15
	sta	tpx

	lda	bm_forceroty
	sec
	sbc	exal_roty+1,y
;***
	sec
	sbc	exal_rotyoffset+1,y
;***
	rol	a
	rol	a

	PHX
	a16
	and	#1
	ora	tpx
	and	#15

	tax
	lda.l	.headtab-1,x
	and	#0ff00H
	sta	bm_headroty

	PLX
	a8

;----------------------------------------------------------------------------------

	PLX
	rts

.tab
	db	0e0H,000H,020H,00
	db	0c0H,0ffH,040H,00
	db	0a0H,080H,060H,00
	db	000H,000H,000H,00

.headtab
	db	0C0H,040H	;80
	db	0E0H,060H	;A0
	db	000H,080H	;C0
	db	020H,0A0H	;E0

	db	040H,0C0H	;00
	db	060H,0E0H	;20
	db	080H,000H	;40
	db	0A0H,020H	;60
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	SET ROTY & CLAMP vector
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	in 	A:force roty

at_cloampvec	equ	10

bm_xpl_flag	equ	1<<0
bm_xmi_flag	equ	1<<1
bm_zpl_flag	equ	1<<2
bm_zmi_flag	equ	1<<3

bm_forceroty_srou

	PUSHYP

	a8i16

	ldy	#0
	sty	x1
	sty	z1

	toheap	y,x

	sp_jmpnot_playertype	x,ARWING,.exit_roty

;----------------------------------------------------------------------------------

; inc roty no check

;	lda	inc_roty+1
	lda	exal_acclroty+1,y
	bne	.exit_roty

	s_set_var	B,inc_roty+0,#0

	lda		exal_roty+1,y

	pha
	s_achase_alvar	W,y,exal_roty,bm_headroty,3
	pla
	sec
	sbc		exal_roty+1,y
	asl		a
	asl		a
	asl		a
	nega
	sta		z1
	s_achase_alvar	B,y,exal_rotzhit,z1,2


	a16
	lda	bm_headroty
	sec
	sbc	exal_roty,y
	adiv2
	sta	y1
	a8

	s_achase_alvar	W,y,exal_rotyoffset,y1,3

.exit_roty

;-----------------------------------------------------------------------------------
;	CLAMP
.calcclamp

	toheap	y,x

	a16

	lda	#0
	sta	x1
	sta	z1

;----------------------------------------------------------------------------------
	lda	exal_blockx-1,y
	and	#0ff00H

	asl	a
;	asl	a	;1024

	sta	x2

	lda	exal_blockz-1,y
	and	#0ff00H

	asl	a
;	asl	a	;1024

	sta	z2
;----------------------------------------------------------------------------------
	PHX

	lda	bm_forceroty
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	and	#7
	tax

	lda.l	.clamptab,x
	sta	tpx		; flag

	PLX
;----------------------------------------------------------------------------------
.xpros	lda	tpx
	bit	#bm_xpl_flag
	bne	.xpl
	bit	#bm_xmi_flag
	beq	.zpros
.xmi	lda	x2
	ora	#blockmap_Resolution-1
	bra	.x
.xpl	lda	x2
.x	sec
	sbc	al_worldx,x
	sta	x1

;----------------------------------------------------------------------------------
.zpros	lda	tpx
	bit	#bm_zpl_flag
	bne	.zpl
	bit	#bm_zmi_flag
	beq	.exit_calcclamp
.zmi	lda	z2
	ora	#blockmap_Resolution-1
	bra	.z
.zpl	lda	z2
.z	sec
	sbc	al_worldz,x
	sta	z1

.exit_calcclamp
;-----------------------------------------------------------------------------------
	a8
	pl_jmp_iftransform	x,.AW
	sp_jmp_playertype	x,ARWING,.AW
;-----------------------------------------------------------------------------------
.RB	; set clamp
	a16
	lda	x1
	sta	exal_clampx,y
	sta	x1
	lda	z1
	sta	exal_clampz,y
	sta	z1
	bra	.add
;-----------------------------------------------------------------------------------
.AW	a16
.AWx0	lda	x1
; no asobi	asra
; no asobi	beq	.AWz0
	sta	x1

.AWz0	lda	z1
; no asobi	asra
; no asobi	beq	.AWend
	sta	z1
.AWend
;-----------------------------------------------------------------------------------
.add	lda	x1
	clc
	adc	al_worldx,x
	sta	al_worldx,x
	sta	exal_worldx,y
	lda	z1
	clc
	adc	al_worldz,x
	sta	al_worldz,x
	sta	exal_worldz,y
;-----------------------------------------------------------------------------------

.exit_clamp

;-----------------------------------------------------------------------------------
.exit	PULLYP

	rts

.clamptab	;	high 1:x 2:z low 1:x 2:z

	db	bm_zpl_flag		;00H(forceroty)
	db	bm_xmi_flag+bm_zpl_flag	;20H
	db	bm_xmi_flag		;40H
	db	bm_xmi_flag+bm_zmi_flag	;60H
	db	bm_zmi_flag		;80H
	db	bm_xpl_flag+bm_zmi_flag	;A0H
	db	bm_xpl_flag		;C0H
	db	bm_xpl_flag+bm_zpl_flag	;E0H

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; block map for camera
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;blockmap_cam_srou_l
;
;bcs_counter	equ	work9
;bcs_x	equ	work8
;bcs_z	equ	work7
;
;	s_start_strat
;
;	PUSHXYP
;
;	toheap	y,x
;
;	pl_jmp_ifblockoff	x,.inn,y
;
;	pl_ldx_viewblk	x
;
;	s_jmp_ifsolid	x,.inn
;
;.out	lda	exal_VIEWflag,y
;	ora	#exal_VIEWflag_blockout
;	bra	.sta
;
;.inn	lda	exal_VIEWflag,y
;	and	#~exal_VIEWflag_blockout
;.sta	sta	exal_VIEWflag,y
;
;
;.exit	PULLXYP
;
;	rtl
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; player vecs & pos --> pathobj
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
cp_playervecspos_l

	s_start_strat

	PHP

	a8i16

;	s_jmp_alsflag		x,player2,.posp2


.posp1	a16

	lda	al_worldx,x
	sta	player1_worldx
	lda	al_worldy,x
	sta	player1_worldy
	lda	al_worldz,x
	sta	player1_worldz

	a8

	sp_jmpnot_playertype	x,ARWING,.p1RB


.p1AW	a16

	lda	al_vx,x
	sta	player1_vx
	lda	al_vy,x
	sta	player1_vy
	lda	al_vz,x
	sta	player1_vz

	bra	.pospp

.p1RB	a16

	lda	al_mx,x
	sta	player1_vx
	lda	al_my,x
	sta	player1_vy
	lda	al_mz,x
	sta	player1_vz


	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	bra	.pospp
.posp2	a16
	lda	al_worldx,x
	sta	player2_worldx
	lda	al_worldy,x
	sta	player2_worldy
	lda	al_worldz,x
	sta	player2_worldz
	a8
	sp_jmpnot_playertype	x,ARWING,.p2RB
.p2AW	a16
	lda	al_vx,x
	sta	player2_vx
	lda	al_vy,x
	sta	player2_vy
	lda	al_vz,x
	sta	player2_vz
	bra	.pospp
.p2RB	a16
	lda	al_mx,x
	sta	player2_vx
	lda	al_my,x
	sta	player2_vy
	lda	al_mz,x
	sta	player2_vz
	bra	.pospp
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC



.pospp	PLP

	rtl






;makefriend_srou_l

	IFEQ	1

	PUSHYP
;make FRIEND

	s_make_obj	#c_wing,.gagag
	pl_set_area	y,-1
	s_copy_pos	y,x
	s_copy_rots	y,x
	s_set_strat	y,path_istrat
	s_set_path	y,superdragon_friend
	s_set_aldata	y,#1,#1

.gagag
;***********
	PULLYP

	ENDC

;	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	color change routine
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

cc_alart_l

	SHORTA
	LONGI

	PUSHXYPB

	a8i16

	BANK7E


	ldx	playpt1

	toheap	y,x

; -- bomb?

	lda	exal_paletteflag_bombtimer,y

	beq	.nobomb
	dec	a
	sta	exal_paletteflag_bombtimer,y
	beq	.boff

	lda	exal_paletteflag,y
	ora	#exal_paletteflag_bomb!exal_paletteflag_bomb_normal
	bra	.bsta

.boff	lda	exal_paletteflag,y
	and	#~exal_paletteflag_bomb
.bsta	sta	exal_paletteflag,y

.nobomb

; --
	lda	exal_paletteflag,y
; bomb
	bit	#exal_paletteflag_bomb
	bne	.bomb
	bit	#exal_paletteflag_bomb_normal
	bne	.bomboff
; alart
	bit	#exal_paletteflag_alart
	bne	.alart
	bit	#exal_paletteflag_normal
	bne	.off
	bra	.exit

.alart	lda	gameframe

	bit	#16+8
	bne	.off

.on	jsl	cc_addbuffer_alart_l
	bra	.exit

.bomb	jsl	cc_addbuffer_white_l
	bra	.exit

.bomboff
	jsl	cc_bakbuffer_l

	PULLXYPB

	rtl




.off	jsl	cc_bakbuffer_l
.exit
	PULLXYPB

	rtl



; destruct sequense no colour

cc_destructcol_l

ccdc_add_r	equ	10
ccdc_add_g	equ	10
ccdc_add_b	equ	10

	SHORTA
	LONGI

	PUSHXYP

	a8
	pl_transcol	off
	ai16

	ldx	#3*32-2

	lda	#ccdc_add_r
	sta	x1
	lda	#ccdc_add_g<<5
	sta	y1
	lda	#ccdc_add_b<<10
	sta	z1

.loop	;lda	kx_palette+4*32,x	; polygon color
	;jsr	.calc
	;sta	kx_palette+4*32,x	; polygon color
	dex
	dex
	bpl	.loop


	ldx	#1*32-2

	lda	#9
	sta	x1
	lda	#9<<5
	sta	y1
	lda	#9<<10
	sta	z1


.loop0	lda	kx_palette+7*32,x	; polygon color
	jsr	.deccalc
	sta	kx_palette+7*32,x	; polygon color
	dex
	dex
	bpl	.loop0


.exit	PULLXYP
	rtl





.calc	pha
	and	#%11111			;R
	clc
	adc	x1	;#ccdc_add_r
	bit	#~%11111
	beq	.setR
	lda	#%11111
.setR	sta	tpx


	pla
	pha
	and	#%1111100000		;G
	clc
	adc	y1	;#ccdc_add_g<<5
	bit	#~%1111111111
	beq	.setG
	lda	#%1111100000
.setG	sta	tpy


	pla
	and	#%111110000000000	;B
	clc
	adc	z1	;#ccdc_add_b<<10
	bit	#~%111111111111111
	beq	.setB
	lda	#%111110000000000
.setB

	ora	tpx
	ora	tpy

	rts












.deccalc	pha
	and	#%11111			;R
	sec
	sbc	x1
	bpl	.decsetR
	lda	#0
.decsetR	sta	tpx

	pla
	pha
	and	#%1111100000		;G
	sec
	sbc	y1
	bpl	.decsetG
	lda	#0
.decsetG	sta	tpy


	pla
	and	#%111110000000000	;B
	sec
	sbc	z1
	bpl	.decsetB
	lda	#0
.decsetB

	ora	tpx
	ora	tpy

	rts




; umi no naka no color nisuru.

cc_marinecol_l

	SHORTA
	LONGI

	PUSHXP

	ai16

	ldx	#1*32-2
.loop
	lda.l	paladdr+gamepal_marine*32,x	; marine  color
	sta	kx_palette+7*32,x	; polygon color

	lda.l	paladdr+gamepal_marine*32,x	; marine  color
	sta	kx_palette3+7*32,x	; polygon color

	dex
	dex
	bpl	.loop

.exit	PULLXP
	rtl


; umi no ue no color nisuru.

cc_mistcol_l

	LONGA
	LONGI
	PUSHXYP

	a8
	pl_transcol	off

	ai16
	ldx	#1*32-2

.loop	lda.l	paladdr+gamepal_mist*32,x	; mist  color
	sta	kx_palette+7*32,x	; polygon color
	sta	kx_palette3+7*32,x	; polygon color
	dex
	dex
	bpl	.loop
.exit	PULLXYP
	rtl


; night color

;cc_nightcol_l
;
;	LONGA
;	LONGI
;	PUSHXYP
;	ai16
;	ldx	#1*32-2
;
;.loop
;	lda.l	paladdr+gamepal_night*32,x	; mist  color
;
;	sta	kx_palette+7*32,x	; polygon color
;	sta	kx_palette3+7*32,x	; polygon color
;	dex
;	dex
;	bpl	.loop
;.exit	PULLXYP
;	rtl
;

; "d_sen" ni haittatoki
;
;cc_d_sen_l
;
;	LONGA
;	LONGI
;	PUSHXYP
;	ai16
;	ldx	#1*32-2
;
;	lda	kx_palette3+7*32+2*10,x
;.loop
;	sta	kx_palette+7*32,x	; polygon color
;	dex
;	dex
;	bpl	.loop
;.exit	PULLXYP
;	rtl




cc_copy2buffer_l

	SHORTA
	LONGI

	PUSHXYP
	a8i16

	toheap	y,x

.start	a16

;	ldx	#4*32-2
;.loop	lda.l	kx_palette+4*32,x
;	sta.l	kx_palette3+4*32,x
;	dex
;	dex
;	bpl	.loop


	ldx	#8*32-2
.loop	lda.l	kx_palette+0*32,x
	sta.l	kx_palette3+0*32,x
	dex
	dex
	bpl	.loop


.exit	PULLXYP
	rtl


cc_addbuffer_alart_l


	SHORTA
	LONGI

	PUSHXYP

	toheap	y,x

	a8i16

	pl_transcol	off

	ai16

	ldx	#7*32-2

.loop
;	lda	kx_palette+4*32,x
	lda	kx_palette+1*32,x

	pha
	and	#%11111
	bpl	.R
	lda	#0
.R	sta	x2


	pla
	pha

	and	#%1111100000
	sec
	sbc	#%100000
	bpl	.G

	lda	#0
.G	ora	x2
	sta	x2



	pla

	and	#%111110000000000
	sec
	sbc	#%10000000000
	sec
	sbc	#%10000000000

	bpl	.B
	lda	#0
.B	ora	x2

;	sta	kx_palette+4*32,x
	sta	kx_palette+1*32,x

	dex
	dex
	bpl	.loop


.exit	PULLXYP
	rtl



;cc_addbuffer_white_07_l	;' palette No.0-7
;
;
;	SHORTA
;	LONGI
;
;	PUSHXYP
;
;	ai16
;
bakbuff
;	toheap	y,x
;
;	ldx	#8*16
;	stx	tpz		; Num of color
;	ldx	#0*32
;
;	bra	cc_addbuffer_white_l.enter
;

cc_addbuffer_whiteFULL07_l	; palette No.0-7

	SHORTA
	LONGI

	PUSHXYP


	ai16
	pl_transcol	off
	toheap	y,x
	ldx	#7
	stx	tpz		; Num of color
	ldx	#1*32


;	ldx	#4*16
;	stx	tpz		; Num of color
;	ldx	#4*32

	lda	#%1111100000	;G
	sta	y2
	lda	#%111110000000000	;B
	bra	cc_addbuffer_white_l.enter2


cc_addbuffer_whiteFULL07BLUE_l	; palette No.0-7

	SHORTA
	LONGI

	PUSHXYP

	ai16

	pl_transcol	off

	toheap	y,x

	ldx	#7
	stx	tpz		; Num of color
	ldx	#1*32

;	ldx	#4*16
;	stx	tpz		; Num of color
;	ldx	#4*32

	lda	#%1111100000	;G
	sta	y2
	lda	#%111110000000000	;B
	sta	y3
	lda	#%11111	;R
	sta	y1

	lda	#1	; R
	sta	z1
	lda	#3<<10	;B
	sta	z2

	bra	cc_addbuffer_white_l.enter3


cc_addbuffer_white07_l	; palette No.0-7

	SHORTA
	LONGI

	PUSHXYP

	a8

	pl_transcol	off

	ai16

	toheap	y,x

	ldx	#7
	stx	tpz		; Num of color
	ldx	#1*32

;	ldx	#4*16
;	stx	tpz		; Num of color
;	ldx	#4*32

	bra	cc_addbuffer_white_l.enter

cc_addbuffer_white_l	; palette No.4-7

	SHORTA
	LONGI

	PUSHXYP

	a8

	pl_transcol	off

	ai16

	toheap	y,x

	ldx	#4		; pallet No
	stx	tpz		; Num of color

	ldx	#4*32		; start No


.enter	LOCAL
	lda	#%1110000000	;G
	sta	y2
	lda	#%111000000000000	;B


.enter2	LOCAL
	sta	y3

	lda	#%11111	;R
	sta	y1

; inc value

	lda	#3	; R
	sta	z1
	lda	#1<<10	;B
	sta	z2


.enter3	LOCAL

	a8
	pl_transcol	off
	a16

	stz	work0	; color No
	stx	work1	; start color No

;-----------------------------------------------------------------------------

.loop1	ldy	tpz

;-----------------------------------------------------------------------------

.loop0	LOCAL

;-----------------------------------------------------------------------------

	a8
	pl_transcol	off
	a16

	txa
	and	#31
	beq	.next

	lda	kx_palette,x

	pha

	and	#%11111
	clc
	adc	z1	;#%11
	cmp	y1
	bcc	.R
	lda	y1
.R	sta	x2

	pla
	pha

	and	#%1111100000
	clc
	adc	#%100000
	cmp	y2
	bcc	.G
	lda	y2

.G	ora	x2
	sta	x2

	pla

	and	#%111110000000000
	clc
	adc	z2	;#%10000000000
	cmp	y3
	bcc	.B

	lda	y3
.B	ora	x2
	sta	x2

	ora	x2
	sta	kx_palette,x

.next


;-----------------------------------------------------------------------------

	dey	; pallet counter
	beq	.endloop0

	txa
	clc
	adc	#16*2
	tax

	jmp	.loop0

;-----------------------------------------------------------------------------
.endloop0

; next color

	lda	work0
	inc	a
	inc	a
	sta	work0
	cmp	#32
	beq	.exit

	clc
	adc	work1
	tax

	jmp	.loop1

;-----------------------------------------------------------------------------


.exit	PULLXYP
	rtl








cc_setbuffer_black_l

	LONGA
	LONGI
	PUSHXYP
	toheap	y,x

	a8
	pl_transcol	off
	ai16
	ldx	#1*32-2

	lda	#0
.loop

	cpx	#2<<1
	beq	.zero
	cpx	#3<<1
	beq	.zero
	cpx	#4<<1
	beq	.zero
	cpx	#6<<1
	beq	.zero
	cpx	#7<<1
	beq	.zero
	cpx	#8<<1
	beq	.zero
	cpx	#0eh<<1
	beq	.zero

	sta	kx_palette3+7*32,x	; polygon color
.zero	dex
	dex
	bpl	.loop
.exit	PULLXYP
	rtl


cc_setbuffer_gray_l

	LONGA
	LONGI
	PUSHXYP
	toheap	y,x

	ai16
	ldx	#7*32-2
	lda	#1d27h
.loop	sta	kx_palette3,x	; polygon color
.zero	dex
	dex
	bpl	.loop
.exit	PULLXYP
	rtl





cc_setbuffer_pc_l	; planet cannon

	LONGA
	LONGI

	PUSHXYP
	toheap	y,x

	ai16
	ldx	#2
.loop	lda.l	.dat-2,x
	sta	kx_palette3+4*32,x	; polygon color
.zero	inx
	inx
	cpx	#32
	bne	.loop

	PULLXYP
	rtl




.dat	dw	7bdeh	;1
	dw	7b5eh	;2
	dw	7adeh	;3
	dw	7a5eh	;4
	dw	71dah	;5
	dw	6556h	;6
	dw	58d2h	;7
	dw	4c4eh	;8
	dw	3c4bh	;9
	dw	2c27h	;a
	dw	1c24h	;b
	dw	0800h	;c
	dw	71dah	;d
	dw	6556h	;e
	dw	0	;f


cc_setbuffer_pc2_l	; planet cannon(normal color)

	LONGA
	LONGI

	PUSHXYP
	toheap	y,x

	ai16
	ldx	#2
.loop	lda.l	.dat-2,x
	sta	kx_palette3+4*32,x	; polygon color
.zero	inx
	inx
	cpx	#32
	bne	.loop

	PULLXYP
	rtl

.dat	dw	7ff9h	;1
	dw	7febh	;2
	dw	7fe3h	;3
	dw	7f43h	;4
	dw	7ea3h	;5
	dw	7de3h	;6
	dw	7ce3h	;7
	dw	7463h	;8
	dw	5c63h	;9
	dw	4463h	;a
	dw	2c63h	;b
	dw	0c21h	;c
	dw	5b63h	;d
	dw	4f03h	;e
	dw	0	;f



;.dat	dw	7fffh	;1
;	dw	7f7fh	;2
;	dw	7effh	;3
;	dw	7e7bh	;4
;	dw	7df7h	;5
;	dw	7973h	;6
;	dw	6cefh	;7
;	dw	606bh	;8
;	dw	4c69h	;9
;	dw	3846h	;a
;	dw	2444h	;b
;	dw	0c21h	;c
;	dw	7dfbh	;d
;	dw	7d71h	;e
;	dw	0	;f




cc_graycol_l

	LONGA
	LONGI
	PUSHXYP

	toheap	y,x

	ai16

	lda	#1d27h
	bra	cc_whitecol_l.enter


cc_whitecolFULL_l

	LONGA
	LONGI
	PUSHXYP

	toheap	y,x

	a8
	pl_transcol	off

	ai16
	lda	#7fffh
	ldx	#4*32-2
	bra	cc_whitecol_l.loop

cc_whitecol_l

	LONGA
	LONGI
	PUSHXYP

	toheap	y,x

	a8
	pl_transcol	off

	ai16
	lda	#7fffh
.enter	LOCAL
	ldx	#3*32-2
.loop	LOCAL

	sta	kx_palette+4*32,x

	dex
	dex
	bpl	.loop
.exit	PULLXYP
	rtl




cc_andorfcol_l

	LONGA
	LONGI
	PUSHXYP

	a8
	pl_transcol	off

	ai16
	ldx	#1*32-2

.loop	lda	#0
	sta	kx_palette+7*32,x	; polygon color
	dex
	dex
	bpl	.loop

	lda	#%011110000000000
	sta	tpx


	ldx	#1*32-2

.loop2	lda	tpx
	sec
	sbc	#%10000000000
	sta	tpx
	sta	kx_palette+7*32,x	; white color
	dex
	dex
	bpl	.loop2

.exit	PULLXYP
	rtl


cc_bakbuffer07_l	; palette 0-7

	SHORTA
	LONGI

	PUSHXYP

	ai16

	toheap	y,x

	ldx	#8
	stx	tpz	; Num of color
	ldx	#0*32	; start No

	bra	cc_bakbuffer_l.enter


cc_bakbuffer_l	; palette 4-7

	SHORTA
	LONGI

	PUSHXYP

	ai16

	toheap	y,x

	ldx	#4
	stx	tpz	; Num of pallete

	ldx	#4*32	; start No

;------------

.enter	LOCAL

	a8
	pl_transcol	off
	ai16

	stz	tpx	; pallet counter
	stz	work0	; color  counter

	stx	work1	; start pallet No

;-----------------------------------------------------------------------------

.loop1
	ldy	tpz	; pallet

;-----------------------------------------------------------------------------

.loop0

;-----------------------------------------------------------------------------

	lda	kx_palette,x
	cmp	kx_palette3,x
	rlbeq	.next

;R1
	pha
	and	#31<<0
	sta	x1
;G1
	pla
	pha
	and	#31<<5
	sta	y1
;B1
	pla
	and	#31<<10
	sta	z1


	lda	kx_palette3,x

;R2
	pha
	and	#31<<0
	cmp	x1
	beq	.R2
	bmi	.decR2
	inc	x1
	bra	.R2
.decR2	dec	x1
.R2

;G2
	pla
	pha
	and	#31<<5
	cmp	y1
	beq	.G2
	bmi	.decG2
	lda	#1<<5
	bra	.addG2
.decG2	lda	#-(1<<5)
.addG2	clc
	adc	y1
	and	#31<<5
	sta	y1
.G2


;B2
	pla
	and	#31<<10
	cmp	z1
	beq	.B2
	bmi	.decB2
	lda	#1<<10
	bra	.addB2
.decB2	lda	#-(1<<10)
.addB2	clc
	adc	z1
	and	#31<<10
.B2

	ora	y1
	ora	x1

	sta	kx_palette,x

.next1	inc	tpx	; counter

.next

;-----------------------------------------------------------------------------

	dey	; pallet counter
	beq	.endloop0

	txa
	clc
	adc	#16*2
	tax

	jmp	.loop0

;-----------------------------------------------------------------------------
.endloop0

; next color

	lda	work0
	inc	a
	inc	a
	sta	work0
	cmp	#32
	beq	.exitloop

	clc
	adc	work1
	tax

	jmp	.loop1

;-----------------------------------------------------------------------------

.exitloop

	PULLXYP





	PUSHYP
	a16
	lda	tpx
	a8
	bne	.yet

	toheap	y,x
	lda	exal_paletteflag,y

	and	#~exal_paletteflag_bomb_normal
	sta	exal_paletteflag,y

	bit	#exal_paletteflag_alart
	bne	.yet
	and	#~exal_paletteflag_normal
	sta	exal_paletteflag,y

.yet
	PULLYP

	rtl



.exit	PULLXYP

	rtl




cc_setbuffer_title_l	; title

	LONGA
	LONGI

	PUSHXYP
	toheap	y,x

	ai16

	lda	#177fh
	sta	kx_palette+7*32+2
	lda	#0effh
	sta	kx_palette+7*32+4
	lda	#0a7eh
	sta	kx_palette+7*32+6
	lda	#061bh
	sta	kx_palette+7*32+8

	PULLXYP
	rtl


cc_setbuffer_fire_l	; title

	LONGA
	LONGI

	PUSHXYP
	toheap	y,x

	ai16

	lda	#177fh
	sta	kx_palette3+7*32+2
	lda	#0effh
	sta	kx_palette3+7*32+4
	lda	#0a7eh
	sta	kx_palette3+7*32+6
	lda	#061bh
	sta	kx_palette3+7*32+8

;	lda	#2ddah
;	sta	kx_palette3+7*32+2
;	lda	#2e1eh
;	sta	kx_palette3+7*32+4
;	lda	#2e9fh
;	sta	kx_palette3+7*32+6
;	lda	#333fh
;	sta	kx_palette3+7*32+8


	PULLXYP
	rtl





cc_addbuffer_whiteYOKO_l	; palette No.4-7

	SHORTA
	LONGI
	PUSHXYP

	a8
	pl_transcol	off
	ai16
	toheap	y,x
	ldx	#4*16
	stx	tpz		; Num of color
	ldx	#4*32

.enter	LOCAL
	lda	#%1110000000	;G
	sta	y2
	lda	#%111000000000000	;B

.enter2	LOCAL
	sta	y3
	lda	#%11111	;R
	sta	y1

; inc value

	lda	#3	; R
	sta	z1
	lda	#1<<10	;B
	sta	z2

.enter3	LOCAL
	a8
	pl_transcol	off
	a16
.loop	LOCAL
	txa
	and	#31
	beq	.next
	lda	kx_palette,x
	pha

	and	#%11111
	clc
	adc	z1	;#%11
	cmp	y1
	bcc	.R
	lda	y1
.R	sta	x2

	pla
	pha

	and	#%1111100000
	clc
	adc	#%100000
	cmp	y2
	bcc	.G
	lda	y2

.G	ora	x2
	sta	x2

	pla

	and	#%111110000000000
	clc
	adc	z2	;#%10000000000
	cmp	y3
	bcc	.B

	lda	y3
.B	ora	x2
	sta	x2

	ora	x2
	sta	kx_palette,x

.next	inx
	inx
	dec	tpz

	bpl	.loop


.exit	PULLXYP
	rtl



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	special BOM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	longa
	longi

decHP_srou_l

	PUSHXYPB

	a8i16

	BANK7E

	ldx	playpt1
	toheap	y,x
	lda	exal_SPweaponstatus,y
	and	#exal_SPweaponstatus_counter

	bne	.ck4
	lda	#5
	sta	exal_SPweaponstatus,y
.ck4	cmp	#5
	rlbne	.exit



.DO	ldy	allst

	a16

	lda	#7fffh
	sta	x3	; distance
	lda	dummyobj
	sta	y3	; store ptr


.findloop	a8

	tyx


	s_jmp_alsflag		x,specialbomb,.notdec
	s_jmp_alcollflag	x,firstframe,.notdec
	s_jmp_alsflag		x,colldisable,.notdec


;**** wolf wa dist check wo sinai ***>>>>

	a16

	lda	al_shape,x
	cmp	#wolf_eg
	beq	.itswolf
	cmp	#wolf_1_eg
	bne	.itsnotwolf
.itswolf

	a8

;rolling no toki wa ataru!

;	s_jmp_alsflag		x,nohitaffect,.notdec

	a16
	stz	x3	; store distance
	stx	y3	; store pointer
	a8

	bra	.exitloop

.itsnotwolf	a8

;************************************<<<<

	s_jmp_alcollflag	x,WEAPON,.notdec
	s_jmpnot_colltype	x,ENEMY1,.notdec
	s_jmp_colltype		x,FRIEND,.notdec
	s_jmp_colltype		x,LASER,.notdec
	s_jmp_alsflag		x,nohitaffect,.notdec


	ldy	playpt1
	jsl	xzdiffs_l


	pl_test_planetmode	space

	a16

	beq	.space


.ground	lda	rangexz
	bmi	.notdec
	cmp	#3000
	bra	.branch

.space	lda	rangexz
	bmi	.notdec
	cmp	#8000
.branch	bcs	.notdec

	cmp	x3
	bcs	.notdec

	sta	x3	; store distance
	stx	y3	; store pointer


.notdec	a8

	ldy	_next,x
	rlbne	.findloop


.exitloop
	ldx	y3
	cpx	dummyobj
	beq	.clear


;***************************************************************************
; wolf ha hanbun
;
;	s_jmp_alvarEQ	W,x,al_shape,#wolf,.wolf
;	s_jmp_alvarNE	W,x,al_shape,#wolf_1,.nwolf
;
;.wolf	lda	al_HP,x
;	sec
;	sbc	#10
;	bra	.dck
;.nwolf
;***************************************************************************
; dec HP & set flag

	lda	al_HP,x
	sec
	sbc	#20

.dck	beq	.dead
	bpl	.staHP

.dead	PHY
	s_set_resource	L,x,whendead,#pathexplode_istrat
	PLY


	lda	#0
.staHP	sta	al_HP,x


	s_set_alsflag	x,specialbomb
	s_set_alsflag	x,hitbyplayer1
	s_set_alsflag	x,hitflash
	s_jmpnot_alsflag	x,pathobj,.notdec
	s_set_alsflag		x,sflag7

	bra	.exit


.clear	a8

	lda	p1_status
	and	#~p1_status_bom
	sta	p1_status




;-------------------------
;clear alsflag specialbomb
;-------------------------

	ldy	allst

.clearloop	tyx

	s_clr_alsflag		x,specialbomb

	ldy	_next,x
	rlbne	.clearloop

;-------------------------

.exit	PULLXYPB

	rtl



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	BATTLE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

battle_judge_srou_l

	IFEQ	1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	s_start_strat

	PUSHYP

	a8i16

	sm_jmp_if1screen	.exit

	s_jmp_alsflag	x,player2,.p2

.p1	lda	p2_status
	bit	#p2_status_HP0
	beq	.exit

	lda	p1_status
	bit	#p1_status_win
	bne	.exit
	ora	#p1_status_win
	sta	p1_status

	bra	.win

.p2	lda	p1_status
	bit	#p1_status_HP0
	beq	.exit

	lda	p2_status
	bit	#p2_status_win
	bne	.exit
	ora	#p2_status_win
	sta	p2_status

.win	ct_set_chartptr	x,playerwin

.exit	PULLYP

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC

	rtl




	IFEQ	1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Sekkin on no check
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ



	PUSHYP

;----------------------------------------------------------------------------------

	toheap	y,x

	sp_jmp_playertype	x,ARWING,.exit,y
	pl_jmp_ifbrake		x,.exit,y

;----------------------------------------------------------------------------------


; z2 : distance	1st
; y2 : pointer	1st
; z3 : distance	2nd
; y3 : pointer	2nd


;-------------------------
;clear alsflag specialbomb
;-------------------------

	PHX

	a16
	lda	#7fffh
	sta	z2	; distance

	lda	dummyobj
	sta	y2	; pointer

	ldy	allst


.clearloop
	a8

	s_jmpnot_alsflag	y,pathobj,.next

	ldx	playpt1
	jsl	xzdiffs_l
	a16
	lda	rangexz
	bmi	.next
	cmp	z2
	bcs	.next

	PHA
	lda	z2
	sta	z3
	lda	y2
	sta	y3
	PLA

	sta	z2	; distance
	sty	y2	; pointer

.next	tyx

	ldy	_next,x
	rlbne	.clearloop

;-------------------------

	PLX

	toheap	y,x

	lda	z2
	cmp












	PLX

;-------------------------

.exit	PULLYP

	rtl






.SEpos	longa
	longi

; x2 : worldx
; z2 : worldz





;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	laser wo rebound suru.
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
rebound_srou_l

rbd_ptr	equ	x2
rbd_hlptr	equ	y2
rbd_sound	equ	z2

	s_start_strat

	PUSHXYP

	stx	rbd_ptr
	stz	rbd_sound

	s_jmpnot_alsflag	x,nohitaffect_really,.exit

;-------------------------------------------------------------------------------------------------

	ldy	al_hitlist,x
	rlbeq	.exit

;-------------------------------------------------------------------------------------------------
; X hitter's pointer


.next	ldx.w	hl_alptr,y

	s_push_obj	y	;*

; X = hitter obj   Y = rebound obj

	s_jmpnot_colltype	x,LASER,.gotonext

	s_jmp_alsflag	x,colldisable,.gotonext
	s_set_alsflag	x,colldisable

	lda	al_roty,x
	clc
	adc	#deg180
	sta	y1

	lda	al_rotx,x
	nega
	sta	x1

	s_push_obj	x
	ldx	rbd_ptr

	lda	y1
	sec
	sbc	al_roty,x
	sta	y1

	cpx	playpt1
	beq	.player
	cpx	playpt2
	bne	.notplayer

.player	pl_jmpnot_ifrollingshield	x,.fire

.notplayer

; rolling nara RANDOM ni suru.

	s_add_rnd2var	x1,#63
	s_add_rnd2var	y1,#63
	s_add_var	B,x1,#-32
	s_add_var	B,y1,#-32

.fire

	s_weapon_rot	x1,y1
	s_weapon_pos	#0,#0,#0

	s_fire_weapon	x,rebound
	s_pull_obj	x

; copy data


;----------------------------------------------------------------------------
; player no WEAPON dattara, resource no shape wo SET suru.
; soude nai tokiha , sono mama copy suru.

	PHY

	s_get_resource	W,x,x1,Pweapshape,.noresource

	a16
	lda	x1
	bra	.setshape
.noresource
	a16
	lda	al_shape,x
.setshape

	PLY

	sta.w	al_shape,y
	a8

;----------------------------------------------------------------------------

	s_copy_alvar2alvar	W,y,al_coltab,x,al_coltab
	s_copy_pos	y,x

; sprite

	s_jmpnot_alsflag	x,ssprite,.notsprite
	s_set_alsflag		y,ssprite
	s_copy_alvar2alvar	B,y,al_depthoffset,x,al_depthoffset
	s_copy_alvar2alvar	B,y,al_tx,x,al_tx

	s_set_speed		x,#60

.notsprite

; sound on

	s_add_var		B,rbd_sound,#1

.gotonext

	s_pull_obj	y

; battle mode no toki ha 1 patsu dake...

	test_screenmode		onescreen
	bne			.continue
	s_jmp_varnotzero	B,rbd_sound,.exit

.continue	a16
	lda.w	_next,y
	tay
	a8

	rlbne	.next

;-------------------------------------------------------------------------------------------------
.exit
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	PULLXYP
	rtl



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	friend shape
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

friendNo_shape_srou_l

; friend shape wo set suru.
;
;	in  : tpx
;	    : idx pointer
;
;	out : al_shape
;	    : al_coltab

	s_start_strat

	PUSHXYP

	ai16

	txy

	lda	tpx	; No (0-3)
	and	#3
	tax

	a8

	lda	#0
	stz	x1	; out

.loop

.player	cmp	p1_PILOTNo
	bne	.friend
	inc	a	; out

.friend	cmp	p2_PILOTNo	; = player_friend
	bne	.next
	inc	a	; out
	bra	.player

.next	dex
	bmi	.set
	inc	a	; out
	bra	.loop


.set	a16
	asl	a
	and	#0fh
	cmp	#6<<1
	bcc	.shape
	lda	#0

.shape	tax

	lda.l	wingman_AW_shape,x
	sta.w	al_shape,y

	lda.l	wingman_AW_col,x
	sta.w	al_coltab,y


	PULLXYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-----------------------------------------------------------------------------
;	PATH no 65816 code
;-----------------------------------------------------------------------------

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Dragon
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

superdragon00_path_l

	PUSHYP

	a8i16

;------------

	stz	x1

	ldy	al_hitlist,x
	rlbeq	.exit

	s_push_obj	x

;------------

.next	ldx.w	hl_alptr,y
	txy

	cpy	playpt1
	bne	.continue

	inc	x1
	bra	.endloop

.continue	a16
	lda.w	_next,y
	tay
	a8

	rlbne	.next

.endloop	s_pull_obj	x

;------------

.exit	PULLYP

	rtl






superdragon02_path_l

	s_start_strat

	lda	al_childroty,x
	sec
	sbc	al_roty,x
	bmi	.whpl

	s_add_alvar	B,x,al_roty,#-30
	s_add_alvar	B,x,al_childroty,#30
	bra		.whmi

.whpl	s_add_alvar	B,x,al_roty,#30
	s_add_alvar	B,x,al_childroty,#-30

.whmi

	rtl


superdragon01_path_l

	s_start_strat


	lda	al_skidy,x
	sec
	sbc	al_HP,x
	sta	tpx

	lda	al_skidy,x
	sta	al_HP,x

	lda	tpx
	cmp	#3
	bmi	.dec

	lda	#4
	sta	tpx

.dec	lda	al_HP,x
	sec
	sbc	tpx
	bpl	.sta
	lda	#0

.sta	sta	al_HP,x
	sta	al_skidy,x

	sta	bosshp

	rtl



;-----------------------------------------------------------------------------

clrawof_watch00_path_l

	s_start_strat

	ldy	#viewblk1

	lda.w	al_roty+1,y
	nega
	sec
	sbc	al_roty,x
	asra
	asra
	asra
	clc
	adc	al_roty,x
	sta	al_roty,x

	rtl





titlepilot00_path_l

	s_start_strat

	lda	P1_PILOTNo
	inc	a
	and	#7
	cmp	#6
	bmi	.sta
	lda	#0
.sta	sta	P1_PILOTNo

	rtl


;-----------------------------------------------------------------------------

gd_arwing_start00_path_l

	s_start_strat

	s_set_objtobevar	y,becomelastobj&WM
	s_add_roffs2pos		B,y,x,x,#0,#10,#80,0,1,0,6,6,6


	PHX
	lda	coreENTERroty

	a16
	and	#7
	tax
	lda.l	.dat,x
	a8
	PLX

	sta	z1

	lda	Kinitroty
	sta.w	al_roty,y
	lda	#0
	sta.w	al_rotx,y
	sta.w	al_rotz,y

	s_add_roffs2pos		B,y,y,y,#0,#0,z1,0,1,0,6,6,6

	rtl


.dat	db	-15	;0
	db	-10	;1
	db	0	;2
	db	10	;3
	db	20	;4
	db	10	;5
	db	0	;6
	db	-10	;7

;-----------------------------------------------------------------------------

es0_cam00_path_l

STARWOLFdirector00_path_l

	a16
	lda	player1vscroll_offset
	bpl	.pl
	stz	player1vscroll_offset
.pl

	stz	player1vscroll_offset

	ldy	#viewblk1
	lda.w	al_roty,y
	asra
	sta	tpy
	asra
	asra
	clc
	adc	tpy
	sta.w	al_roty,y
	a8

	rtl


;-----------------------------------------------------------------------------
letsgo_cam00_path_l

	a16
	ldy	#viewblk1

	lda.w	al_roty,y
	sec
	sbc	#-(deg90<<8)

	asra
	sta	tpy
	asra
	clc
	adc	tpy

;;;;	nega

	clc
	adc	#-(deg90<<8)
	sta.w	al_roty,y

	a8

	rtl

;-----------------------------------------------------------------------------

tametame00_path_l

	s_start_strat

	PHY

	ldy	pathplayer&WM

	sp_jmpnot_ifcockpit	y,.norm

	lda	#-1
	sta	al_tx,x


	IFEQ	1

	a16
	txa
	sta.w	al_childrotobj,x
	lda	#0
	sta	al_childz,x
	a8

	PHY
	ldy	#viewblk1
	s_copy_pos	x,y

	lda.w	al_rotx+1,y
	nega
	sta	al_rotx,x
	lda.w	al_roty+1,y
	sta	tpy
	PLY
	clc
	adc.w	al_roty,y
	asra
	sec
	sbc	tpy
	sta	al_roty,x

	s_add_roffs2pos	B,x,x,x,#0,#60,#120,1,1,1,1,0,1

	bra	.pb

	ENDC


.norm	a16
	tya
	sta.w	al_childrotobj,x
	lda	al_pword1,x
	sta	al_childz,x
	lda	#0
	sta	al_childy,x
	a8

.pb	toheap	y,y

	lda	exal_weap_power+1,y
	sta	al_pbyte1,x

	PLY

	rtl


playershield00_path_l

	s_start_strat

	s_add_alvar	B,x,al_childrotx,#8
	s_add_alvar	B,x,al_childrotz,#6

	lda	playerctlmode
	cmp	#map_room
	beq	.room

	pl_test_planetmode	space
	bne			.gd

.room	lda	demomode
	bne	.remove

.gd	s_set_objtobealvar	y,x,al_ptr

	toheap	y,y

	test_playerdead		1
	bne	.off

	lda	Kenemynumber
	bne	.cnt

.off	lda	exal_shield,y
	bit	#~1
	beq	.cnt
	lda	#1
	sta	exal_shield,y

.cnt	lda	exal_shield,y
	and	#exal_shield_mask
	sta	al_pbyte1,x
	bne	.alive
	lda	exal_shield,y
	and	#exal_shield_obj^-1
	sta	exal_shield,y
.alive
	rtl

.remove	lda	#0
	sta	al_pbyte1,x
	rtl



healeffect00_path_l

	s_start_strat

	PHX

	ldx	playpt1
 	toheap	y,x
	s_or_alvar	B,y,exal_circle_flag,#exal_circle_flag_Pri
 	s_set_alvar	B,y,kx_circlecolR,#16
 	s_set_alvar	B,y,kx_circlecolG,#16
 	s_set_alvar	B,y,kx_circlecolB,#31
 	s_set_alvar	B,y,exal_circle_decr,#3
 	s_set_alvar	B,y,exal_circle_decg,#3
 	s_set_alvar	B,y,exal_circle_decb,#4

	sp_jmpnot_ifcockpit	x,.exit,y

	a16
	lda	#8
	sta	exal_circle_step,y
	sta	kx_circlestep,y
	a8

	PLX
	rtl

.exit	PLX
	rtl



healeffect01_path_l

	PHY
	ldy	playpt1

	sp_jmpnot_ifcockpit	y,.noofs

	s_add_roffs2pos	B,x,y,y,#0,#0,#80,1,1,0

	PLY

	rtl


.noofs	a16
	lda.w	al_worldx,y
	sta	al_worldx,x
	lda.w	al_worldy,y
	sta	al_worldy,x
	lda.w	al_worldz,y
	sta	al_worldz,x
	a8
	PLY

	rtl

;---------------------------------------------------------------------------------
copy_player2_damage_l

	s_start_strat

	lda	p2_hp
	PHA

	bra	copy_player_damage_l.enter

copy_player_damage_l

	s_start_strat

	lda	p1_hp
	PHA

.enter	LOCAL

	s_set_alvar	B,x,al_pbyte1,#0
	s_set_alvar	W,x,al_depthoffset,#0

	PLA

	cmp	#3*4+1
	bcs	.exit

	s_set_alvar	B,x,al_pbyte1,#1

	lda	gameframe
	bit	#%100
	bne	.exit

	bit	#%1
	bne	.exit

	s_set_alvar	W,x,al_depthoffset,#3

.exit

	rtl

;---------------------------------------------------------------------------------





;---------------------------------------------------------------------------------
ASHI_player_L_path_l

	s_start_strat

	a16
	lda	P1_PilotNo
	and	#07h
	asl	a
	PHX
	tax

	lda.l	player_l_shape,x
	bra	SASHI_friend_L_path_l.enter3

;------------
SASHI_player_L_path_l

	s_start_strat

	a16
	lda	P1_PILOTNo
	bra	SASHI_friend_L_path_l.enter

;------------
SASHI_friend_L_path_l

	s_start_strat
	a16
	lda	player_friend

.enter	LOCAL

	and	#07h
	asl	a
	PHX
	tax

	lda.l	player_swim_l_shape,x

.enter3	LOCAL
	sta	tpx

	lda.l	pprb_posx,x
	nega
	bra	SASHI_friend_R_path_l.enter2

;---------------------------------------------------------------------------------
ASHI_player_R_path_l

	s_start_strat

	a16
	lda	P1_PILOTNo
	and	#07h
	asl	a
	PHX
	tax

	lda.l	player_r_shape,x
	bra	SASHI_friend_R_path_l.enter3

;------------
SASHI_player_R_path_l

	s_start_strat

	a16
	lda	P1_PILOTNo
	bra	SASHI_friend_R_path_l.enter

;------------
SASHI_friend_R_path_l

	s_start_strat
	a16
	lda	player_friend

.enter	LOCAL

	and	#07h
	asl	a
	PHX
	tax

	lda.l	player_swim_r_shape,x
.enter3	LOCAL
	sta	tpx

	lda.l	pprb_posx,x

.enter2	LOCAL

	sta	x1
	lda.l	wingman_RB_col,x
	sta	x2

	PLX

	lda	tpx
	sta	al_shape,x
	lda	x1
	sta	al_childx,x
	lda	x2
	sta	al_coltab,x

	rtl


;---------------------------------------------------------------------------
sd_swim00_path_l

	s_start_strat

	PUSHYP

	a16

	ldy	playpt1

	lda	al_worldy,x

	clc
	adc	#1500
	bmi	.sita
	cmp	#1500*2
	bpl	.ue


	lda.w	al_worldy,y
	sec
	sbc	al_worldy,x
	bpl	.sita

.ue	; ue ni iku

	lda	al_vy,x
	bpl	.neg
	bra	.add

.sita	; sita ni iku

	lda	al_vy,x
	bpl	.add
.neg	nega
.add	asl	a
	clc
	adc	al_worldy,x
	sta	al_worldy,x

	PULLYP

	rtl





	IFEQ	1
sd_swim00_path_l

	s_start_strat

	PUSHYP

	a16

	ldy	playpt1

	lda.w	al_worldy,y
	sec
	sbc	al_worldy,x
	clc
	adc	#700
	bmi	.pl
	cmp	#700*2
	bmi	.ck
	bra	.mi

.ck	lda	al_worldy+1,x
	clc
	adc	#1000>>8
	bmi	.mi

	cmp	#1000>>4
	bmi	.no

.pl	s_add_alvar	W,x,al_worldy,#-30
	bra	.noface
.mi	s_add_alvar	W,x,al_worldy,#30

.noface

.no	PULLYP

	rtl

	ENDC






;---------------------------------------------------------------------------

RB_SHAPE_friend_path_l	;friend

	s_start_strat
	a16
	lda	player_friend
	bra	RB_SHAPE_player_path_l.enter

RB_SHAPE_player_path_l	;player

	s_start_strat

	a16
	lda	p1_PILOTNo
.enter	LOCAL
	and	#7h
	asl	a
	PHX
	tax
	lda.l	player_RB_shape,x
	bra	cds_robo01_path_l.enter2


;---------------------------------------------------------------------------

cds_robo00F_path_l	;player

	s_start_strat
	a16
	lda	player_friend
	bra	cds_robo00_path_l.enter

cds_robo00_path_l	;player

	s_start_strat

	a16
	lda	p1_PILOTNo
.enter	LOCAL
	and	#7h
	asl	a
	PHX
	tax
	lda.l	wingman_RB_shape,x
	bra	cds_robo01_path_l.enter2


cds_robo01F_path_l	;player

	s_start_strat
	a16
	lda	player_friend
	bra	cds_robo01_path_l.enter

cds_robo01_path_l	; player

	s_start_strat

	a16
	lda	p1_PILOTNo
.enter	LOCAL
	and	#7h
	asl	a
	PHX
	tax
	lda.l	wingman_RB_1_shape,x

.enter2	LOCAL
	sta	tpx
	lda.l	wingman_RB_col,x
	PLX
	sta	al_coltab,x
	lda	tpx
	sta	al_shape,x

	rtl


;---------------------------------------------------------------------------
gd_arwing0_path_l

	s_start_strat

	PHY
	TXY

	s_set_alvar	B,x,al_vel,#50

	lda	coreENTERroty
	sta	al_ap,x

	a16
	and	#7
	tax
	a8

	lda.l	gd_arwing.irx,x
	sta.w	al_childrotx,y
	lda.l	gd_arwing.iry,x
	sta.w	al_pbyte1,y
	lda.l	gd_arwing.irz,x
	sta.w	al_childrotz,y

	lda.l	gd_arwing.rx,x
	sta.w	al_rotx,y
	lda.l	gd_arwing.ry,x
	sta.w	al_roty,y
	lda.l	gd_arwing.rz,x
	sta.w	al_rotz,y

	lda.l	gd_arwing.count,x
	sta.w	al_count,y

	a16
	txa
	asl	a
	tax

	lda.l	gd_arwing.x,x
	sta.w	al_childx,y
	clc
	adc.w	al_worldx,y
	sta.w	al_worldx,y


	lda.l	gd_arwing.y,x
	sta.w	al_childy,y
	clc
	adc.w	al_worldy,y
	sta.w	al_worldy,y


	lda.l	gd_arwing.z,x
	sta.w	al_childz,y
	clc
	adc.w	al_worldz,y
	sta.w	al_worldz,y

	a8

	TYX
	PLY

	rtl


;---------------------------------------------------------------------------
superdragon03_path_l

	s_start_strat

	a16
	lda	al_vx,x
	asl	a
	asl	a
	asl	a
	sta	al_vx,x

	lda	al_vz,x
	asl	a
	asl	a
	asl	a
	sta	al_vz,x

	a8

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; path command "P_PLRFORCEWAY" no routine.
; (See Pathkern.asm)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
P_PLRFORCEWAY_srou_l

	PHP

	a8i16

	lda	al_roty,x
	and	#~1fh
	clc
	adc	y3
	sta	y3
	sta	pathy3

; width = pathx1

	a16
	lda	al_worldx,x
	sta	x1
	lda	al_worldy,x
	sta	y1
	lda	al_worldz,x
	sta	z1

	lda	x2
	sta	pathx2
	lda	y2
	sta	pathy2
	lda	z2
	sta	pathz2

	pl_jmpNOT_ifturn	y,.pfcw2

	phx
	tyx
	jsl	checkslantway_srou_l
	plx

	rlbcc	.noslant
.pfcw2
	a16

;length = pathz1


	lda		al_worldx,x
	sec
	sbc.w		al_worldx,y
	bpl		.pfcw0
	nega
.pfcw0	cmp		pathz2
	bpl		.noslant


	lda		al_worldz,x
	sec
	sbc.w		al_worldz,y
	bpl		.pfcw1
	nega
.pfcw1	cmp		pathz2
	bpl		.noslant

	a16
	lda		al_worldx,x
	sta		x1
	lda		al_worldy,x
	sta		y1
	lda		al_worldz,x
	sta		z1
	a8

	pl_forceturn	y,pathy3,x1,y1,z1,pathx2,pathy2

.noslant
	a16
	lda	#0

;	sta	pathx1
;	sta	pathy1
;	sta	pathz1

	sta	pathx2
	sta	pathy2
	sta	pathz2

;	sta	pathx3
;	sta	pathy3
;	sta	pathz3


	PLP


	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Inc level call from path
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

inclevel_path_l

	s_start_strat

	SHORTA
	LONGI

	PHY
	ldy	playpt1
	toheap	y,y
	lda	#exal_nohitRISE_mask
	sta	exal_nohitRISE,y
	PLY

	lda	demoflag
	bit	#demoflag_nextmap_trapped
	bne	.noset
	ora	#demoflag_nextmap_inclevel!demoflag_nextmap_trapped
	sta	demoflag

.noset	rtl

;-------------------------------------------------------------------------
;	data table
;-------------------------------------------------------------------------
wingman_RB_1_shape

	dw	a_wing_1
	dw	a_wing_1
	dw	c_wing_1
	dw	c_wing_1
	dw	b_wing_1
	dw	b_wing_1

wingman_AW_col
wingman_RB_col

	dw	id_0_c
	dw	id_1_c
	dw	id_0_c
	dw	id_1_c
	dw	id_0_c
	dw	id_1_c

player_RB_shape

	dw	a_robo
	dw	a_robo
	dw	c_robo
	dw	c_robo
	dw	b_robo
	dw	b_robo

player_l_shape

	dw	a_ashi_l
	dw	a_ashi_l
	dw	c_ashi_l
	dw	c_ashi_l
	dw	b_ashi_l
	dw	b_ashi_l

player_r_shape

	dw	a_ashi_r
	dw	a_ashi_r
	dw	c_ashi_r
	dw	c_ashi_r
	dw	b_ashi_r
	dw	b_ashi_r

player_swim_l_shape

	dw	a_swim_l
	dw	a_swim_l
	dw	c_swim_l
	dw	c_swim_l
	dw	b_swim_l
	dw	b_swim_l

player_swim_r_shape

	dw	a_swim_r
	dw	a_swim_r
	dw	c_swim_r
	dw	c_swim_r
	dw	b_swim_r
	dw	b_swim_r

pprb_posy
	dw	-robotyofstab_FF
	dw	-robotyofstab_FF
	dw	-robotyofstab_SP
	dw	-robotyofstab_SP
	dw	-robotyofstab_GG
	dw	-robotyofstab_GG

pprb_posx	dw	ashiofsx_FF
	dw	ashiofsx_FF
	dw	ashiofsx_SP
	dw	ashiofsx_SP
	dw	ashiofsx_GG
	dw	ashiofsx_GG

;-------------------------------------------------------------------------------------------
cds_explosions
.rx	LOCAL

	db	-30
	db	-30
	db	-60
	db	-15
	db	-25	; chika
	db	-50	; chika

	db	10	; endseq0
	db	-10	; endseq0
	db	0	; endseq0

.ry	LOCAL

	db	-30
	db	60
	db	-10
	db	40
	db	50	; chika
	db	-00	; chika

	db	0	; endseq0
	db	0	; endseq0
	db	5	; endseq0

.x	LOCAL

	dw	0
	dw	0
	dw	0
	dw	0
	dw	0	; chika
	dw	0	; chika

	dw	4<<last_ka_scale	; endseq0
	dw	-4<<last_ka_scale	; endseq0
	dw	0	; endseq0

.y	LOCAL

	dw	0
	dw	0
	dw	0
	dw	0
	dw	0	; chika
	dw	0	; chika

	dw	-500	; endseq0
	dw	500	; endseq0
	dw	-100	; endseq0

.z	LOCAL

	dw	1000
	dw	2000
	dw	1500
	dw	2000
	dw	0	; chika
	dw	0	; chika

	dw	0	; endseq0
	dw	0	; endseq0
	dw	0	; endseq0

.count	LOCAL

	db	13
	db	11
	db	14
	db	20
	db	8	; chika
	db	8	; chika

	db	10	; endseq0
	db	10	; endseq0
	db	10	; endseq0

.vel	LOCAL

	db	80
	db	80
	db	80
	db	80
	db	60	; chika
	db	70	; chika

	db	90	; endseq0
	db	100	; endseq0
	db	90	; endseq0

;--------------------------------------------------------------------------
superdragon_garakuta

	dw	ryousan_big
	dw	ryousan_big
	dw	ryousan_big
	dw	batabata
	dw	ryousan_big
	dw	ryousan_big
	dw	yamori_b
	dw	ryousan_big

;--------------------------------------------------------------------------
es0_starfox

.x	LOCAL
	dw	-100	;fox
	dw	-300+100+100+100+100	;falco
	dw	-300+100+100+100+100+200	;peppy
	dw	0	;slippy
	dw	0	;gal1
	dw	0	;gal2

.y	LOCAL
	dw	-200	;fox
	dw	-50	;falco
	dw	-50	;peppy
	dw	0	;slippy
	dw	0	;gal1
	dw	0	;gal2

.z	LOCAL
	dw	-200	;fox
	dw	-700-100-100-100	;falco
	dw	-700-100-100-100-200	;peppy
	dw	0	;slippy
	dw	0	;gal1
	dw	0	;gal2


.rx	LOCAL
	db	0	;fox
	db	0	;falco
	db	0	;peppy
	db	0	;slippy
	db	0	;gal1
	db	0	;gal2

.ry	LOCAL
	db	8	;fox
	db	50	;falco
	db	50	;peppy
	db	0	;slippy
	db	0	;gal1
	db	0	;gal2

.rz	LOCAL
	db	0	;fox
	db	0	;falco
	db	0	;peppy
	db	0	;slippy
	db	0	;gal1
	db	0	;gal2

.count	LOCAL
	db	10	;fox
	db	20	;falco
	db	20	;peppy
	db	0	;slippy
	db	0	;gal1
	db	0	;gal2

.count1	LOCAL
	db	3dh	;fox
	db	1dh	;falco
	db	1dh	;peppy
	db	3dh	;slippy
	db	3dh	;gal1
	db	3dh	;gal2

.count2	LOCAL
	db	8	;fox
	db	8	;falco
	db	8	;peppy
	db	8	;slippy
	db	8	;gal1
	db	8	;gal2

.count3	LOCAL
	db	18h	;fox
	db	0eh	;falco
	db	0eh	;peppy
	db	10h	;slippy
	db	10h	;gal1
	db	10h	;gal2

.count4	LOCAL
	db	10h	;fox
	db	10h	;falco
	db	10h	;peppy
	db	10h	;slippy
	db	10h	;gal1
	db	10h	;gal2

.vel	LOCAL
	db	30	;fox
	db	40	;falco
	db	40	;peppy
	db	20	;slippy
	db	20	;gal1
	db	20	;gal2





;--------------------------------------------------------------------------
attackdirector

.rotxtab	LOCAL

	db	50
	db	-30
	db	20
	db	-30

	db	40
	db	-30
	db	-10
	db	40

.Ehighttab	LOCAL

eh50	equ	6394>>1
eh40	equ	6394>>1
eh30	equ	6394>>1
eh20	equ	3256>>1
eh10	equ	1653>>1

	dw	eh50
	dw	-eh30
	dw	eh20
	dw	-eh30

	dw	eh40
	dw	-eh30
	dw	-eh10
	dw	eh40


;--------------------------------------------------------------------------

armada_d_sen

armadacamdownvel	equ	3

.x	LOCAL
	dw	1200
	dw	150
	dw	-300	;1800
	dw	2500
	dw	1200
	dw	200


.y	LOCAL
	dw	-200+armadacamdownvel*60
	dw	armadacamdownvel*60+40
	dw	200+armadacamdownvel*60
	dw	500+armadacamdownvel*60
	dw	300+armadacamdownvel*60
	dw	-300+armadacamdownvel*60


.z	LOCAL
	dw	-1500-400
	dw	-900-300
	dw	-1500+3400-900
	dw	-1500+400
	dw	-1500-400
	dw	-1200-200-200

.vz	LOCAL
	dw	30
	dw	20
	dw	10
	dw	10
	dw	30
	dw	20

.vy	LOCAL
	dw	-5
	dw	0	;-1
	dw	-5
	dw	-5
	dw	0
	dw	0


;--------------------------------------------------------------------------
armada_ninja_warp

.nwx	LOCAL

	dw	400
	dw	-400
	dw	0
	dw	0

.nwy	LOCAL

	dw	0
	dw	0
	dw	-400
	dw	400


;--------------------------------------------------------------------------
armada_suisei

.x	LOCAL

	dw	2000	;d_sen
	dw	100	;stepup
	dw	500	;crusher
	dw	2000	;d_sen2
	dw	100	;dragon
	dw	2000	;
	dw	2000	;

.y	LOCAL

	dw	100	;d_sen
	dw	1800	;stepup
	dw	-1000	;crusher
	dw	100	;d_sen2
	dw	1800	;dragon
	dw	100	;
	dw	100	;

.z	LOCAL

	dw	-2000-873h	;d_sen
	dw	-2800		;stepup
	dw	-2000-873h	;crusher
	dw	-2000-873h	;d_sen2
	dw	-2800		;dragon
	dw	-2000-873h	;
	dw	-2000-873h	;

;--------------------------------------------------------------------------
destruct_g_buil0

.x	LOCAL

	dw	00800
	dw	00000
	dw	00400
	dw	00200
	dw	00000
	dw	-0200
	dw	-0500


.z	LOCAL

	dw	0500
	dw	0500
	dw	0400
	dw	0200
	dw	0000
	dw	0200
	dw	0400

;--------------------------------------------------------------------------
playershield

.tab	LOCAL

	db	8+128
	db	7+128
	db	6+128
	db	5+128

	db	6+128
	db	7+128
	db	6+128
	db	5+128

	db	4+128
	db	3+128
	db	2+128
	db	1+128

	db	2+128
	db	3+128
	db	2+128
	db	1+128

;--------------------------------------------------------------------------

superdragon_body

.hpdat	LOCAL

	db	15
	db	15
	db	15
	db	15
	db	15
	db	15
	db	15
	db	15
	db	15
	db	15
	db	15


	db	50	;0
	db	50	;1
	db	45	;2
	db	30	;3
	db	25	;4
	db	15	;5
	db	10	;6
	db	15	;7
	db	20	;8
	db	30	;9

.toguro_dat	LOCAL

	db	-60
	db	-50
	db	-40
	db	-20

	db	00
	db	30
	db	40
	db	50

	db	60

;--------------------------------------------------------------------------
title_bwing
;***********************************
.x	LOCAL

	dw	150
	dw	300
	dw	-300
;------------
	dw	-130	;a
	dw	50	;-20	;120	;b
	dw	-150	;c
;------------
	dw	-32+70+200+100-80+40	;d
	dw	-32+70+100+50		;e
	dw	-32+100+200+50-50	;f
;------------
	dw	-139			;10
	dw	-139-200		;11
	dw	title_cam_cut4_x+100	;12
;***********************************
;------------
.y	LOCAL

	dw	300
	dw	100
	dw	200
;------------
	dw	50
	dw	-10	;-50
	dw	50
;------------
	dw	148h-50
	dw	148h-100+100
	dw	148h+50-300+30-50	;+100
;------------
	dw	-67+200
	dw	-67+50
	dw	title_cam_cut4_y+100	; dead
;***********************************
;------------
.z	LOCAL

	dw	-200
	dw	-800
	dw	-700
;------------
	dw	5d9h-100	;a
	dw	5d9h-300	;b
	dw	5d9h-300	;c
;------------
	dw	-710+70+200-180-50
	dw	-710+50-100
	dw	-710+100+400-50
;------------
	dw	881h-(30*21)
	dw	881h-(30*10)
	dw	title_cam_cut4_z-100
;***********************************
;------------
.rotx	LOCAL

	db	-10
	db	-15
	db	-10
;------------
	db	2
	db	0+5
	db	0+5
;------------
	db	-20
	db	-20
	db	-20
;------------
	db	-10
	db	0
	db	0
;***********************************
;------------
.roty	LOCAL

	db	8
	db	8
	db	8
;------------
	db	0
	db	0
	db	-8
;------------
	db	0
	db	0
	db	0
;------------
	db	0
	db	0
	db	0
;***********************************
;------------
.count	LOCAL

	db	20
	db	15
	db	15
;------------
	db	60-40
	db	65-40
	db	72-40
;------------
	db	100
	db	100
	db	0
;------------
	db	25-7+1
	db	26-7
	db	26-7
;***********************************
;------------
.childx	LOCAL

	dw	5
	dw	10
	dw	10
;------------
	dw	5
	dw	0
	dw	0
;------------
	dw	15
	dw	0
	dw	0
;***********************************
;------------
.childy	LOCAL

	dw	5
	dw	-10
	dw	20
;------------
	dw	-8
	dw	0
	dw	0
;------------
	dw	15
	dw	-30
	dw	0
;***********************************
;------------
.childz	LOCAL

	dw	10+20
	dw	10
	dw	10
;------------
	dw	15
	dw	0
	dw	0
;------------
	dw	0
	dw	0
	dw	0
;***********************************
;------------
.crotz	LOCAL

	db	50
	db	-50
	db	-20
;------------
	db	30
	db	0
	db	0
;------------
	db	40
	db	-40
	db	40
;------------
;***********************************

;--------------------------------------------------------------------------
superdragon_demo

.dat0	LOCAL

	db	4
	db	-4
	db	3
	db	-3
	db	2
	db	-2
	db	1
	db	-1
	db	1
	db	-1

;--------------------------------------------------------------------------

suisei_friends

.x	LOCAL

	dw	0
	dw	100
	dw	0
	dw	100

	dw	700	; zako
	dw	200
	dw	1200

	dw	700<<1	; zako
	dw	200<<1
	dw	100

	dw	400	; zako
	dw	600+300
	dw	800

	dw	500	; zako



.y	LOCAL

	dw	0
	dw	0
	dw	0
	dw	0

	dw	2700	; zako
	dw	3000
	dw	3300

	dw	(2700-400)<<1	; zako
	dw	(3000-400)<<1
	dw	(3300-400)<<1

	dw	2800	; zako
	dw	2400
	dw	3900

	dw	-100	; zako

.z	LOCAL

	dw	0
	dw	0
	dw	0
	dw	0

	dw	-3000	; zako
	dw	-2600
	dw	-2000

	dw	-3000<<1	; zako
	dw	-2600<<1
	dw	-2000<<1

	dw	-3000	; zako
	dw	-2600
	dw	-2000

	dw	200	; zako

.count	LOCAL

	db	5
	db	15+3
	db	20+6
	db	25+9

	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0

.count2	LOCAL

	db	10
	db	20
	db	0
	db	0

	db	20
	db	10
	db	5
	db	30*2
	db	40+20
	db	50*2
	db	20
	db	0
	db	0
	db	20


.count4	LOCAL

	db	127
	db	127
	db	127
	db	127

	db	127
	db	127
	db	127
	db	127
	db	1
	db	127
	db	127
	db	127
	db	127
	db	127


.rx	LOCAL

	db	30+5
	db	30
	db	30
	db	30+5

	db	-30
	db	-30
	db	-30
	db	-30
	db	-30
	db	-30
	db	-30
	db	-30
	db	-30

	db	8


.ry	LOCAL

	db	deg180
	db	deg180
	db	deg180+5
	db	deg180

	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0


.rz	LOCAL

	db	20
	db	-40
	db	40
	db	-50

	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0

.crx	LOCAL

	db	-1
	db	-1
	db	0
	db	0

	db	-1
	db	0
	db	-1
	db	-1
	db	0
	db	-1
	db	0
	db	0
	db	0
	db	-1

.cry	LOCAL

	db	1
	db	-1
	db	1
	db	-1

	db	0
	db	1
	db	1
	db	0
	db	1
	db	1
	db	1
	db	-1
	db	0
	db	-2

.vel	LOCAL

	db	30
	db	30
	db	30
	db	30

	db	30
	db	30
	db	35
	db	30
	db	30
	db	35
	db	30
	db	30
	db	35
	db	20


pc_d_sen_beam

	dw	12<<4	;0
	dw	14<<4	;1
	dw	28<<4	;2
	dw	60<<4	;3
	dw	120<<4	;4
	dw	120<<4	;5
	dw	120<<4	;6
	dw	120<<4	;7
	dw	120<<4	;8
	dw	120<<4	;9

;--------------------------------------------------------------------------

suisei_enemy0

secamx	equ	0fff7h
secamy	equ	0fe7ah
secamz	equ	0f709h

suisei_enter_enemy2x	equ	(secamx-1200-200)&WM
suisei_enter_enemy2y	equ	(secamy+1200)&WM
suisei_enter_enemy2z	equ	(secamz+1000+400)&WM

suisei_enter_enemy1x	equ	(secamx-1200)&WM
suisei_enter_enemy1y	equ	(secamy+1300)&WM
suisei_enter_enemy1z	equ	(secamz+1000+1000)&WM

suisei_enter_enemy0x	equ	(secamx-1200)&WM
suisei_enter_enemy0y	equ	(secamy+1200)&WM
suisei_enter_enemy0z	equ	(secamz+1000)&WM


.x	LOCAL

	dw	suisei_enter_enemy0x
	dw	suisei_enter_enemy1x
	dw	suisei_enter_enemy2x

.y	LOCAL

	dw	suisei_enter_enemy0y
	dw	suisei_enter_enemy1y
	dw	suisei_enter_enemy2y

.z	LOCAL

	dw	suisei_enter_enemy0z
	dw	suisei_enter_enemy1z
	dw	suisei_enter_enemy2z

.rx	LOCAL

	db	-10
	db	-00
	db	10

.ry	LOCAL
	db	0a0h
	db	0b0h
	db	0a8h


;---------------------------------------------------------------------------------
gd_cam

.cx	LOCAL

	DW	-1a9h+200
	DW	-1a9h
	DW	-1a9h
	DW	-1a9h

	DW	1a9h
	DW	1a9h
	DW	1a9h
	DW	1a9h-200

.cy	LOCAL

	DW	0fda8h-100
	DW	0fda8h
	DW	0fda8h
	DW	0fda8h

	DW	0fda8h
	DW	0fda8h
	DW	0fda8h
	DW	0fda8h-100

.cz	LOCAL

	DW	109ah-300
	DW	109ah
	DW	109ah
	DW	109ah

	DW	109ah
	DW	109ah
	DW	109ah
	DW	109ah-300


.count	LOCAL

	db	2bh	;0
	db	22h	;1
	db	30h	;2
	db	32h	;3
	db	32h	;4
	db	30h	;5
	db	22h	;6
	db	2bh	;7

;---------------------------------------------------------------------------------
gd_arwing

.x	LOCAL

	DW	150
	DW	-450	;1**
	DW	-450	;2**
	DW	-100	;3**
	DW	100	;4**
	DW	450	;5**
	DW	450	;6**
	DW	-150

.y	LOCAL
	dw	50
	DW	-50	;1**
	DW	0	;2**
	DW	-150	;3**
	DW	-150	;4**
	DW	0	;5**
	DW	-50	;6**
	dw	50


.z	LOCAL
	dw	1200
	DW	200	;1**
	DW	-400	;2**
	DW	-700	;3**
	DW	-700	;4**
	DW	-400	;5**
	DW	200	;6**
	dw	1200

.rx	LOCAL
	db	12
	DB	16	;1**
	DB	12	;2**
	DB	12	;3**
	DB	12	;4**
	DB	12	;5**
	DB	16	;6**
	db	12

.ry	LOCAL

	db	128
	DB	128+40	;1**
	DB	-32	;2**
	DB	0	;3**
	DB	0	;4**
	DB	32	;5**
	db	128-40	;6**
	db	128

.rz	LOCAL

	db	0
	DB	-20	;1**
	DB	-30	;2**
	DB	-40	;3**
	DB	40	;4**
	DB	30	;5**
	DB	20	;6**
	db	0


.irx	LOCAL
	db	12
	DB	16	;1**
	DB	18	;2**
	DB	32	;3**
	DB	32	;4**
	DB	18	;5**
	DB	16	;6**
	db	12

.iry	LOCAL

	db	0
	DB	-2	;1
	DB	-4	;2**
	DB	-4	;3**
	DB	4	;4**
	DB	4	;5**
	DB	2	;6
	db	0

.irz	LOCAL

	db	0
	DB	0	;1**
	DB	0	;2**
	DB	0	;3**
	DB	0	;4**
	DB	0	;5**
	DB	0	;6**
	db	0

.count	LOCAL

	db	20
	DB	12
	DB	7	;2**
	DB	8	;3**
	DB	8	;4**
	DB	7	;5**
	DB	12	;6**
	db	20


.count2	LOCAL

	db	32
	DB	10	;1**
	DB	32	;2**
	DB	32	;3**
	DB	32	;4**
	DB	32	;5**
	DB	10	;6**
	db	32

.count3	LOCAL

	db	1
	DB	1	;1**
	DB	20	;2**
	DB	20	;3**
	DB	20	;4**
	DB	20	;5**
	DB	1	;6**
	db	1



;----------------------------------------------------------------------------
destruct_s_drop0

.cx	LOCAL

	dw	0300
	dw	0200
	dw	0100
	dw	0500
	dw	0900
	dw	1300
	dw	1700

.cy	LOCAL

	dw	-3400-800
	dw	-2800-800
	dw	-2000-800
	dw	-2500-800
	dw	-2500-800
	dw	-2700-800
	dw	-2300-800

.cz	LOCAL

	dw	-6000
	dw	-5100
	dw	-4000
	dw	-4500
	dw	-4700
	dw	-5500
	dw	-5900

.count	LOCAL

	db	58h
	db	50h
	db	4ch
	db	40h
	db	44h
	db	55h
	db	4ch

pc_d_sen_parts

.y	LOCAL

	dw	0
	dw	0
	dw	0
	dw	-55<<d_sen_scale

.z	LOCAL

	dw	(120+25)<<d_sen_scale
	dw	(033+25)<<d_sen_scale
	dw	(-90+25)<<d_sen_scale
	dw	(-40+25)<<d_sen_scale


;--------------------------------------------------------------------------------
title_cam

.x	LOCAL

	DW	-30
	DW	title_cam_cut3_x
	DW	title_cam_cut4_x+400
	DW	title_cam_cut5_x
	DW	title_cam_cut6_x
	dw	-1700	; title_ship_0
	dw	200	; title_ship_0

.y	LOCAL

	DW	0
	DW	title_cam_cut3_y
	DW	title_cam_cut4_y
	DW	title_cam_cut5_y
	DW	title_cam_cut6_y
	dw	200	; title_ship_0
	dw	800	; title_ship_0

.z	LOCAL

	DW	5a8h-30	;0
	DW	title_cam_cut3_z
	DW	title_cam_cut4_z
	DW	title_cam_cut5_z
	DW	title_cam_cut6_z
	dw	-2300	; title_ship_0
	dw	-2100	; title_ship_0

;------------------------------------------------------------------------------
sw_wolf

	dw	wolf
	dw	wolf_1
	dw	wolf_1
	dw	wolf_1

;------------------------------------------------------------------------------
es0_arwing4

.x	LOCAL
	dw	0ffc4h	;100
	dw	20	;ffc4h+50+100
	dw	-55<<base_scale	;+150
	dw	-55<<base_scale
	dw	55<<base_scale
	dw	55<<base_scale


.y	LOCAL
	dw	200
	dw	180
	dw	-50-30
	dw	50
	dw	60
	dw	-30	;125

.z	LOCAL
	dw	100
	dw	100
	dw	100
	dw	-50
	dw	0
	dw	0

.rx	LOCAL
	db	-32
	db	-32
	db	-10
	db	-30
	db	-32
	db	-16

.ry	LOCAL
	db	deg180-16
	db	deg180-13
	db	deg180	;-16-8
	db	deg180+32
	db	deg180
	db	deg180

.rz	LOCAL
	db	10
	db	40
	db	10
	db	-10
	db	-30
	db	-30

.count0	LOCAL		; kiran!
	db	1ah
	db	30h
	db	10h
	db	24h
	db	10h
	db	8

.count1	LOCAL
	db	8
	db	8
	db	8
	db	10
	db	8
	db	8

.count2	LOCAL
	db	32+8	;
	db	32+8	;
	db	32-20
	db	32+8	;
	db	32+8	;
	db	8+8

;------------------------------------------------------------------------------
Dand_ba_1

.cx	LOCAL
	dw	0
	dw	100<<3
	dw	0
	dw	-100<<3

.cz	LOCAL
	dw	-100<<3
	dw	0
	dw	100<<3
	dw	0
.cry	LOCAL
	db	deg180
	db	deg270
	db	deg0
	db	deg90

;------------------------------------------------------------------------------
gd_warp

.x	LOCAL

	dw	300
	dw	-300
	dw	100


.rx	LOCAL
	db	-5
	db	-5
	db	0

.ry	LOCAL
	db	8
	db	-8
	db	0


;------------------------------------------------------------------------------
superdragon

.hp	LOCAL

	db	16
	db	20
	db	30
;------------------------------------------------------------------------------
armada_taiman

.hp	LOCAL

	db	50
	db	52
	db	42
	db	20

.vel	LOCAL

	db	30
	db	42
	db	42
	db	120

;.flag	LOCAL
;
;	db	7ch
;	db	7ch
;	db	7ch
;	db	7ch

;--------------------------------------------------------------------------
es0_cam

.x	LOCAL

	dw	-150	;0
	dw	0	;1
	dw	0	;2
	dw	250	;3 letsgo_cam
	dw	0fbach	;4 pc_cam
	dw	es0_cam_4x
	dw	0	;6 es0_cam(dummy shape)
	dw	0fea2h	;7 es0_arwing2
	dw	0ffe2h	;8 es0_arwing2_friend2
	dw	0fed4h+70	;9 es0_fox5
	dw	0ff9ch+70	;10 es0_fox4
	dw	00082h+70	;11 es0_fox3
	dw	0ff7eh+70	;12 es0_fox2
	dw	0082h+70	;13 es0_fox1
	dw	70	;14 es0_arwing3
	dw	title_cam_cut4_x-50-500	;15 title_watch2
	dw	0fa24h	;16 superdragon_demo
	dw	title_cam_cut5_x-300+50	;17 superdragon_demo
	dw	title_cam_cut6_x-200	;18 superdragon_demo
	dw	0fec5h	;19 title_dragon_bwing2
	dw	-1500	;20 cds_iwa
	dw	1800	;21 cds_iwa
	dw	2	;22 scramble_arwing_d
	dw	55<<base_scale	; 23 acramble_arwing_p_c
	dw	-55<<base_scale	; 24 acramble_arwing_p
	dw	suisei_enter_camx	; 25 suisei_friend_enter
	dw	suisei_enter_camx	; 26 suisei_arwing_enter
	dw	destruct_space_camx	; 27 destructcam
	dw	destruct_ground_camx1	; 28 destructcam
	dw	03beh+500+500	;29 es0_base
	dw	suisei_into_camx-600	;30 suisei_arwing_enter


.y	LOCAL

	dw	-30	;0
	dw	5c0h	;1
	dw	0	;2
	dw	40	;3 letsgo_cam
	dw	0f789h	;4 pc_cam
	dw	es0_cam_4y
	dw	15<<base_scale	;6
	dw	00d90h	;7 es0_arwing2
	dw	04f8h	;8 es0_arwing2_friend2
	dw	(0ffceh+750)&WM	;9 es0_fox5
	dw	000c8h+750	;10 es0_fox4
	dw	(0ffceh+750)&WM	;11 es0_fox3
	dw	(0ff1ah+750)&WM	;12 es0_fox2
	dw	(0ff38h+750)&WM	;13 es0_fox1
	dw	750	;14 es0_arwing3
	dw	title_cam_cut4_y-20-200	;15 title_watch2
	dw	0fa24h	;16 superdragon_demo
	dw	title_cam_cut5_y-150	;17 superdragon_demo
	dw	title_cam_cut6_y-100	;18 superdragon_demo
	dw	0019h	;19 title_dragon_bwing2
	dw	50	;20 cds_iwa
	dw	0	;21 cds_iwa
	dw	0ah	;22 scramble_arwing_d
	dw	0	; 23 acramble_arwing_p_c
	dw	0	; 24 acramble_arwing_p
	dw	suisei_enter_camy-250	; 25 suisei_friend_enter
	dw	suisei_enter_camy-100	; 26 suisei_arwing_enter
	dw	destruct_space_camy	; 27 destructcam
	dw	destruct_ground_camy1	; 28 destructcam
	dw	0f875h-800-500-800	; 29 es0_base
	dw	suisei_into_camy	;30 suisei_arwing_enter

.z	LOCAL

	dw	0
	dw	09b8h	;1
	dw	0	;2
	dw	700	;3 letsgo_cam
	dw	0fbd8h	;4 pc_cam
	dw	es0_cam_4z	; 5
	dw	40<<base_scale	; 6
	dw	07f6h	;7 es0_arwing2
	dw	0940h	;8 es0_arwing2_friend2
	dw	(0fe70h+800)&WM	;9 es0_fox5
	dw	00190h+800	;10 es0_fox4
	dw	(0ff1ah+800)&WM	;11 es0_fox3
	dw	(0ff6ah+800)&WM	;12 es0_fox2
	dw	(0ff6ah+800)&WM	;13 es0_fox1
	dw	800	;14 es0_arwing3
	dw	title_cam_cut4_z-50+200	;15 title_watch2
	dw	0b94h	;16 superdragon_demo
	dw	title_cam_cut5_z+50+50	;17 superdragon_demo
	dw	title_cam_cut6_z	;18 superdragon_demo
	dw	0b18h	;19 title_dragon_bwing2
	dw	4000	;20 cds_iwa
	dw	5000	;21 cds_iwa
	dw	0648h	;22 scramble_arwing_d
	dw	40<<base_scale	; 23 acramble_arwing_p_c
	dw	40<<base_scale	; 24 acramble_arwing_p
	dw	suisei_enter_camz	; 25 suisei_friend_enter
	dw	suisei_enter_camz	; 26 suisei_arwing_enter
	dw	destruct_space_camz	; 27 destructcam
	dw	destruct_ground_camz1	; 28 destructcam
	dw	0f9ceh-1000-500	;29 es0_base
	dw	suisei_into_camz+100	;30 suisei_arwing_enter

.rx	LOCAL

	db	0	;0
	db	10	;1
	db	0	;2
	db	40	;3 letsgo_cam
	db	0	;4 pc_cam
	db	0	;5
	db	0	;6
	db	-15	;7 es0_arwing2
	db	75	;8 es0_arwing2_friend2
	db	-32	;9 es0_fox5
	db	-32	;10 es0_fox4
	db	-32	;11 es0_fox3
	db	-32	;12 es0_fox2
	db	-32	;13 es0_fox1
	db	-32	;14 es0_arwing3
	db	20	;title_watch2
	db	10h	;16 superdragon_demo
	db	0	;17 superdragon_demo
	db	30+8	;18 superdragon_demo
	db	0	;19 title_dragon_bwing2
	db	0	;20 cds_iwa
	db	0	;21 cds_iwa
	db	0	;22 scramble_arwing_d
	db	0	; 23 acramble_arwing_p_c
	db	0	; 24 acramble_arwing_p
	db	50	; 25 suisei_friend_enter
	db	0	; 26 suisei_arwing_enter
	db	0	; 27 destructcam
	db	0	; 28 destructcam
	db	0	; 29 es0_base
	db	0	;30 suisei_arwing_enter

.ry	LOCAL

	db	90+21	;0
	db	deg180	;1
	db	deg180	;2
	db	0	;3 letsgo_cam
	db	0	;4 pc_cam
	db	0	;5
	db	0	;6
	db	06dh	;7 es0_arwing2
	db	deg180+16	;8 es0_arwing2_friend2
	db	80h	;9 es0_fox5
	db	80h	;10 es0_fox4
	db	80h	;11 es0_fox3
	db	80h	;12 es0_fox2
	db	80h	;13 es0_fox1
	db	80h	;14 es0_arwing3
	db	deg180	;15 title_watch2
	db	88h	;16 superdragon_demo
	db	deg180	;17 superdragon_demo
	db	-20	;18 superdragon_demo
	db	-30	;19 title_dragon_bwing2
	db	0	;20 cds_iwa
	db	0	;21 cds_iwa
	db	12h	;22 scramble_arwing_d
	db	0	; 23 acramble_arwing_p_c
	db	0	; 24 acramble_arwing_p
	db	-12	; 25 suisei_friend_enter
	db	0	; 26 suisei_arwing_enter
	db	0	; 27 destructcam
	db	0	; 28 destructcam
	db	20	; 29 es0_base
	db	deg270	; 30 suisei_arwing_enter

.rz	LOCAL

	db	-32	;0
	db	0	;1
	db	0	;2
	db	0	;3 letsgo_cam
	db	0	;4 pc_cam
	db	0	;5
	db	0	;6
	db	0	;7 es0_arwing2
	db	0	;8 es0_arwing2_friend2
	db	0	;9 es0_fox5
	db	0	;10 es0_fox4
	db	0	;11 es0_fox3
	db	0	;12 es0_fox2
	db	0	;13 es0_fox1
	db	0	;14 es0_arwing3
	db	0	;15 title_watch2
	db	0	;16 superdragon_demo
	db	0	;17 superdragon_demo
	db	-10	;18 superdragon_demo
	db	-40	;19 title_dragon_bwing2
	db	0	;20 cds_iwa
	db	0	;21 cds_iwa
	db	1eh	;22 scramble_arwing_d
	db	0	; 23 acramble_arwing_p_c
	db	0	; 24 acramble_arwing_p
	db	-20	; 25 suisei_friend_enter
	db	0	; 26 suisei_arwing_enter
	db	0	; 27 destructcam
	db	0	; 28 destructcam
	db	0	; 29 es0_base
	db	40	;30 suisei_arwing_enter



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	end of file
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	end
