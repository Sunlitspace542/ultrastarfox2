;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                   STARFOX II - THE SEQUEL                          ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³ FILE:         CHART.ASM                                            ³
;³ AUTHOR:       Takumi Kawagoe(EDA)                                  ³
;³ DESCRIPTION:  Code for various weapons                             ³
;³ DATE CREATED: 24-2-93                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	INCPUB	chart

	SHORTA
	LONGI

gcofs	equ	20

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºstage no check no shikata       º
;º	a16                  º
;º	lda	KGameMapPtr  º
;º	cmp	#stg_stg6    º
;º	a8                   º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;LOCAL MACRO

end_chart	macro

	rtl

	endm

start_chartrou	macro

	SHORTA
	LONGI

	php

	endm

end_chartrou		macro

	plp
	rts

	endm


chartdat	macro	[switch,label,time1,time2]

MYNARG	=	NARG
	CHK_NARG	3,4


	db	chartswitch_{switch}


	IFC	"{switch}","between"

	dw	{time1}
	dw	{time2}

	ELSEIF

	dw	{time1}

	ENDC

	dw	CHARTROU.{label}&WM

	ENDM

end_chartdat	macro

	dw	0ffffH

	ENDM

; switch

chartswitch_trig	equ	0
chartswitch_after	equ	1	;(if C >= time)
chartswitch_before	equ	2	;(if C <  time)
chartswitch_between	equ	3	;(if timeA <= C < timeA)
chartswitch_always	equ	4	;always


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	SET GAME CLEAR CHART
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	s_start_strat

setclearseq_l	; mission mode

	PUSHYP

	a8i16

;	lda	#1
;	sta	andorfDEAD

	toheap	y,x

; set clear flag for map ( for Kawaguchi )

	s_set_var	B,currentlevel,#0ffh

	s_jmp_varEQ	B,andorfDEAD,#1,.endseq0
	s_jmp_varEQ	B,andorfDEAD,#255,.endseq0

	pl_test_planetmode	space
	rlbeq			.space

	lda	demoNoClear
	cmp	#demo_off
	rlbeq	.space


.planet	sp_jmpnot_playertype	x,ARWING,.rb

.aw	ct_set_chartptr		x,gameclear_CORE_AW,y
	jmp			.exit
.rb	ct_set_chartptr		x,gameclear_CORE_trans2AW,y
	jmp			.exit

;ENDING******
.endseq0	lda	#demo_endseq0
	sta	demoNoClear
	ct_set_chartptr		x,goto_endseq0,y
	bra			.exit
;************

.space	sp_jmpnot_playertype	x,ARWING,.spam

.spaw	ct_set_chartptr		x,clrawof_AW,y
	bra			.exit
.spam	ct_set_chartptr		x,clrawof_trans2AW,y



	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	pl_jmp_iftutumode	x,.room,y
	pl_jmp_ifinthesea	x,.marine
	sp_jmp_playertype	x,UFO,.rb_onshape
	sp_jmpnot_playertype	x,ARWING,.rb
.aw	ct_set_chartptr		x,gameclearAW
	jmp	.exit
.rb	;pl_jmp_ifoverheat	x,.rb_overheat,y
	rb_jmp_ifonshape	x,.rb_onshape
	sm_ifpartnerdead	.rb_onshape
.rb_onfield	ct_set_chartptr		x,gameclearRB,y
	jmp	.exit
.rb_onshape	ct_set_chartptr		x,gameclear_trans2AW,y
	bra	.exit
;.rb_overheat	ct_set_chartptr		x,gameclear_trans2AW_ov,y
;	bra	.exit
.room	ct_set_chartptr		x,gameclear_room,y
	bra	.exit
.marine	ct_set_chartptr		x,gameclear_marine,y
	bra	.exit
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC

.exit	PULLYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	TIME CHART ROUTINE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
timechart_l

;chartptr	equ	twork8	;3bytes
;chartptr_inc	equ	twork7	;2bytes
;chartheapptr	equ	twork6	;2bytes

	PUSHXYPB

	a8i16

	km_jmpgameflag		freeze,.exit

;	POLL_MARIO
;	lda.l	m_dustflags
;	sta	x1
;	UNPOLL_MARIO
;
;	lda	x1
;	printb	m_dustflag,kawagoe


;	BANK7E

	a8i16
	toheap	y,x


	sty	chartheapptr


	IFNE	debuginfo
	a16
	lda	exal_charttimer,y
	printh	CHARTTIME,kawagoe
	lda	exal_charttimer_work,y
	printh	CHARTTIME,kawagoe

	a8

;	lda	demomode
;	printh	demomode,kawagoe

	ENDC


	a16
	lda	exal_charttimer,y
	sta	charttimer
	lda	exal_chartptr+0,y
	sta	chartptr
	a8
	rlbeq	.exit

	lda	exal_chartptr+2,y
	sta	chartptr+2

;------------------------------------------------------------------------------

.loop	ldy	chartheapptr	; heap pointer

	lda	chartptr+2
	sta	x1+2
	a16
	lda	chartptr+0
	sta	x1+0

	lda	[x1]	; switch
	cmp	#03fffH
	rlbeq	.incexit
	cmp	#07fffH
	rlbeq	.incexit

	inc	x1

	and	#0ffH
	cmp	#chartswitch_always
	beq	.always
	cmp	#chartswitch_between
	beq	.between
	cmp	#chartswitch_after
	beq	.after
	cmp	#chartswitch_before
	beq	.before
	cmp	#chartswitch_trig
	beq	.trig

	jmp	.incexit

;------------------------------------------------------------------------------

.always
	lda	#5
	sta	chartptr_inc
	jmp	.jmplabel

.trig
	lda	#5
	sta	chartptr_inc
	lda	charttimer	;exal_charttimer,y
	cmp	[x1]	; time
	bne	.loopend
	jmp	.jmplabel


.after	;jmp ( time >= dat)
	lda	#5
	sta	chartptr_inc
	lda	charttimer	;exal_charttimer,y
	cmp	[x1]	; time
	bcc	.loopend
	jmp	.jmplabel


.before	;jmp ( time < dat)
	lda	#5
	sta	chartptr_inc
	lda	charttimer	;exal_charttimer,y
	cmp	[x1]	; time
	bcs	.loopend
	jmp	.jmplabel


.between	;jmp ( dat <= time < dat)

	lda	#7
	sta	chartptr_inc
	lda	charttimer	;exal_charttimer,y
	cmp	[x1]	; time
	bcc	.loopend

	inc	x1
	inc	x1

	cmp	[x1]	; time
	bcs	.loopend
	jmp	.jmplabel


.jmplabel
	inc	x1
	inc	x1
	lda	[x1]
	sta	tpx

	lda	#.return&WM
	dec	a
	pha
	a8
	jmp	(tpx)
.return	a16

.loopend	lda	chartptr
	clc
	adc	chartptr_inc
	sta	chartptr

	jmp	.loop


;------------------------------------------------------------------------------

.incexit	a16
	lda	exal_charttimer,y
	inc	a
	beq	.exit
	sta	exal_charttimer,y

	lda	exal_charttimer_work,y
	inc	a
	sta	exal_charttimer_work,y

.exit	a8
	PULLXYPB
	rtl

;-----------------------------------------------------------------------------

chart_specialbomb

	chartdat	between,wait_bomkey,2,bombtimer-1

	chartdat	trig,col2buffer_bomb,0

	chartdat	trig,chartoff,bombtimer+28
	chartdat	trig,decHP,2+bombtimer
	chartdat	trig,explode_bomb,bombtimer

	end_chartdat




;	chartdat	after,km_clrscreenflag_bgcolpal,0
;	chartdat	trig,col2buffer_bomb,0
;;	chartdat	trig,bomb_circle_on,0+12
;	chartdat	trig,chartoff,25+12
;	chartdat	trig,decHP,2+12
;	chartdat	trig,SEbomb0,1
;	chartdat	trig,SEbomb1,0+12

	end_chartdat

;-----------------------------------------------------------------------------
chart_starwolf


	chartdat	trig,radarOFF,0
	chartdat	trig,playercontroloff,0
	chartdat	trig,playercontrolon,100+15

	chartdat	between,km_keydisable,0,100+15
	chartdat	trig,km_keydisable_off,100+15

	chartdat	trig,displayON,100+15
	chartdat	trig,radarON_space,100+13
	chartdat	trig,displayOFF,100+13

	chartdat	trig,damagemeter,0
	chartdat	trig,demomodeend,95+15

	chartdat	after,chartoff,100+15

	end_chartdat

;-----------------------------------------------------------------------------
chart_credits

	chartdat	trig,fadeout,1

	chartdat	trig,km_keyenable_credit0,920h
	chartdat	trig,km_keyenable_credit1,970h
	chartdat	trig,km_keyenable_credit2,920h

	end_chartdat

;-----------------------------------------------------------------------------

chart_planetcanon

cpcofs	equ	10h

	chartdat	trig,planetcannon_scroll,0

	chartdat	trig,BGM_demo2,0afh

	chartdat	trig,planetcannon_circle_on,100h+cpcofs

	chartdat	trig,demomodenext,0c5h

	chartdat	trig,col2buffer,8

	chartdat	trig,planetcannon_flash_on,100h+cpcofs-5

;canon
	chartdat	between,col2white,0a8h,0afh
	chartdat	between,col2white,0a8h,0afh
	chartdat	between,colbackX2,0b0h,0c5h
;beam
	chartdat	between,col2whiteX2,0dah,0deh
	chartdat	between,colbackX2,0dfh,0f0h
	chartdat	between,colbackX2,0dfh,0f0h
;explode

	chartdat	between,col2whiteX2,104h+cpcofs,10ch+cpcofs
	chartdat	trig,col2bufPC,110h+cpcofs
	chartdat	after,colback,110h+cpcofs

	chartdat	trig,planetcannon_circle_decRGB,102h+cpcofs

	chartdat	trig,col2bufPC2,130h-4+cpcofs
	chartdat	trig,km_gameover,130h+cpcofs

	end_chartdat

;-----------------------------------------------------------------------------

chart_armada

	chartdat	trig,km_gameover,7ch+20

	end_chartdat

chart_taiman

	chartdat	trig,km_gameover,7ch

;	chartdat	trig,col2buffer,8
;	chartdat	between,col2white,48h,48h+4
;	chartdat	between,col2white,48h,48h+4
;	chartdat	after,colback,48h+4
;	chartdat	after,colback,48h+4

	end_chartdat


;chart_meteo
;
;	chartdat	trig,demomodeend,94	;50+30h
;	chartdat	after,chartoff,95	;50+31h
;	chartdat	trig,setbg_stage5,3dh
;	chartdat	between,meteo_addblue,31h,31h+8
;	chartdat	between,SEengine,31h,90
;
;	end_chartdat


chart_logo
	chartdat	trig,vscrollofs_off,0
;;;;	chartdat	trig,km_gameover,0c5h+30
	chartdat	trig,logoon,0d0h
	chartdat	trig,BGMlogofadeout,099h

	end_chartdat

chart_letsgo

	chartdat	trig,vscrollofs_off,0
	chartdat	trig,km_gameover,0c5h+30

;	chartdat	trig,logoon,0d0h
;	chartdat	trig,BGMlogofadeout,099h

	end_chartdat

chart_title

	chartdat	trig,coltitle,0eh	; col2buffer mo yaru

	chartdat	between,colbackX2,6bh,8bh

;;;	chartdat	between,title0_flash_on,0b6h,0bch

	chartdat	trig,demomodenext,0b6h

	chartdat	trig,demomodenext,0f9h

	chartdat	trig,demomodenext,0f9h+44

	chartdat	trig,demomodenext,147h

	chartdat	trig,demomodenext,1a0h

	chartdat	trig,km_gameover,1b9h

; color

	chartdat	between,col2white,0a9h,0a9h+16
	chartdat	between,colback,0a9h+16,0a9h+16+20h

	chartdat	between,col2white,13ah,13ah+4
	chartdat	between,colback,13ch+8,13ch+8+32

	chartdat	between,col2white,199h,199h+4
	chartdat	between,colback,199h+8,199h+8+32

	end_chartdat

;chart_logo
;
;	chartdat	after,vscrollofs_off,0
;	chartdat	trig,logoon,0c0h
;	chartdat	trig,BGMlogofadeout,099h
;
;	end_chartdat

chart_gameoverlogo

	chartdat	after,colbackX2,69h

	chartdat	trig,coltitle,0eh	; col2buffer mo yaru

	chartdat	trig,setdust_off,0

 	chartdat	after,chartoff,301

	chartdat	trig,km_gameover,300

	chartdat	trig,km_gameoverscore,100

	chartdat	trig,SEgameover_voice,48

	chartdat	trig,km_andorf_eye,40h

	end_chartdat

;-----------------------------------------------------------------------------

;chart_boss00
;	chartdat	trig,km_bossmeteron,128
;
;	chartdat	trig,plrblockoff,0
;	chartdat	between,playercolloff,0,128
;
;	chartdat	trig,foceroty0,128+1
;
;	chartdat	trig,stormbgcolor,25
;	chartdat	before,testbefore,20
;	chartdat	after,testafter,40
;	chartdat	between,testbetween,26,40
;	chartdat	always,testalways,0
;	chartdat	trig,dv_bossenter,10
;	chartdat	trig,removemap,10
;	chartdat	trig,testdemoviewoff,128
;	chartdat	trig,playercontroloff,1
;	chartdat	trig,playercontrolon,128
;	chartdat	after,setboss,170
;
;	chartdat	trig,setdust_raining,50
;
; sound
;	chartdat	trig,BGMstop,0
;	chartdat	trig,SEcallboss,15
;	chartdat	trig,BGMboss,30
;
;	end_chartdat

;-----------------------------------------------------------------------------

;chart_battlestart

	;chartdat	trig,plmode_ofaw,deg90	;3aH
	;chartdat	trig,testdemoviewoff,3aH
	;chartdat	trig,playercontrolon,3aH

	;chartdat	before,addrotx_ff,deg90
	;chartdat	before,addroty_1,deg90
	;chartdat	trig,addroty_end,deg90
	;chartdat	between,addrotz_ff,deg45,deg90

	;chartdat	before,setnullshape,1fH
	;chartdat	trig,setawshape,20H

	;chartdat	trig,chartoff,60H

	end_chartdat

;chart_battlestart2

	;chartdat	trig,plmode_csaw,deg90	;3aH
	;chartdat	trig,testdemoviewoff,3aH
	;chartdat	trig,chartoff,60H
	;chartdat	trig,playercontrolon,3aH

	;chartdat	before,addrotx_ff,deg90
	;chartdat	before,addroty_1,deg90
	;chartdat	trig,addroty_end,deg90
	;chartdat	between,addrotz_ff,deg45,deg90

	;chartdat	before,setnullshape,20H
	;chartdat	trig,setawshape,20H

;	chartdat	trig,plmode_csaw,3aH
;	chartdat	trig,testdemoviewoff,3aH
;	chartdat	trig,chartoff,3aH
;	chartdat	trig,playercontrolon,3aH
;
;	chartdat	before,addrotx_ff,deg90
;	chartdat	before,addroty_1,deg90
;	chartdat	trig,addroty_end,deg90
;	chartdat	trig,setawshape,20H


	end_chartdat


;chart_battlestart_again
;
;	chartdat	trig,playercontroloff,0
;	chartdat	trig,setnohit,0
;	chartdat	trig,playercontrolon,30
;	chartdat	after,chartoff,45
;	chartdat	always,camxofs0,45
;
;	end_chartdat




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CLERA DEMO CHART
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

chart_enemyhasgone_

	chartdat	trig,cockpitmodeoff,0

;	chartdat	trig,demomodenext,0
	chartdat	always,setnohitRISE,0
	chartdat	trig,playercontroloff,0
	chartdat	trig,km_hasgone,0
	chartdat	trig,BGMenemy_gone,0
	chartdat	trig,demoview_gone,8

	end_chartdat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CLERA DEMO CHART
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

chart_clear_d_sen

;	chartdat	trig,radarOFF,0

;	chartdat	trig,radarON,81
	chartdat	trig,disp_cleartime,0
	chartdat	trig,displayOFF,0

	chartdat	trig,colalart_off,0	; alart color off!

	chartdat	trig,setdust_cleardemo,0

	chartdat	trig,BGMstgclr,0

	chartdat	after,km_keydisable,0

	chartdat	always,horizonofs4,0

	chartdat	before,letsgo_whiteout,2

	chartdat	trig,col2buffer,8

	chartdat	trig,setbg_cleardemo,0

	chartdat	between,col2white,48h,48h+4
	chartdat	between,col2white,48h,48h+4
	chartdat	after,colback,48h+4
	chartdat	after,colback,48h+4

	chartdat	trig,BGMfadeout,94h
	chartdat	trig,km_stageclear,9ch

	chartdat	trig,msg_clear_d_sen,50h

	end_chartdat


chart_clear_kaitei

;;;;;	chartdat	trig,radarOFF,0

	chartdat	trig,colmarine,8
;;;;;	chartdat	trig,rasterON_sea,0
;;;;;	chartdat	trig,voffset_off,0

chart_clear_chika

	chartdat	trig,rasterON_sea,1	;5ch

	chartdat	trig,disp_cleartime,0
	chartdat	trig,displayOFF,0
	chartdat	trig,colalart_off,0	; alart color off!
	chartdat	after,km_keydisable,0
	chartdat	trig,BGMstgclr,0
	chartdat	before,letsgo_whiteout,2
;*	chartdat	trig,fadein,0
	chartdat	trig,setbg_cleardemo,0
	chartdat	trig,col2buffer,8
	chartdat	between,col2whiteYOKO,48h,48h+16+2
	chartdat	after,colback,48h+16+2
	chartdat	trig,BGMfadeout,94h
	chartdat	trig,km_stageclear,9ch-2	;WWWWWWWW
	chartdat	trig,msg_clear_chika,50h

	end_chartdat

chart_destruct_core

	chartdat	before,circle_off,8

;;;	chartdat	after,displayOFF,0

	chartdat	always,colalart_off,0	; alart color off!

;*	chartdat	trig,fadeout,4ch
;	chartdat	trig,BGMfadeout,0

	chartdat	trig,BGMqstgclr,1

	chartdat	after,setnullshape,0

;;;	chartdat	between,col2white,0,4

	chartdat	trig,cleardemo_startdemo,55h
	chartdat	after,letsgo_whiteout,4eh

	chartdat	after,addcol_white,54h

	chartdat	trig,SEstop_tr,55h


;;;;;	chartdat	before,letsgo_whiteout,2

;	chartdat	trig,destruct_flash_on,20
;	chartdat	trig,destruct_flash_on,50
;	chartdat	trig,destruct_flash_on,0
;	chartdat	trig,destruct_flash_on,10
;	chartdat	trig,destruct_flash_on,30

	end_chartdat

;chart_clrawof
;
;	chartdat	trig,demoview_gone,0
;	chartdat	after,plrrotx0,0
;	chartdat	after,setnullshape,0
;	chartdat	trig,BGMfadeout,48h
;	chartdat	trig,km_stageclear,50h
;
;	end_chartdat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ENDING DEMO CHART
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

chart_endseq0

ces0_cut1	equ	0a4h
ces0_cut2	equ	1a8h+20
ces0_cut3	equ	ces0_cut2+0d8h

	chartdat	after,km_clrscreenflag_bgcolpal,0

	;;;chartdat	before,letsgo_whiteout,2
;------------
	;;;chartdat	trig,setbg_space,0
;------------
	chartdat	trig,setdust_off,0
;------------
	chartdat	trig,rasterON_fire,0
;------------
	chartdat	before,colgray,8
;------------
; mae syori

	;;;chartdat	trig,circle_off,0
	;;;chartdat	before,letsgo_whiteout,4
	;;;chartdat	before,destruct_flash_RGB_D,3

	chartdat	before,colback,20h

;------------

	chartdat	trig,colwhite,5bh
	chartdat	trig,col2buffer,5bh
	chartdat	trig,col2bufblack_poly,5bh
	chartdat	between,colback,5bh,63h+5

	chartdat	between,letsgo_whiteout,099h,ces0_cut1
	chartdat	between,destruct_flash_RGB_D,09eh,ces0_cut1

	chartdat	trig,col2buffer,36h

	chartdat	between,col2white,44h,44h+4
	chartdat	trig,destruct_flash_on,44h+4
	chartdat	between,colback,44h+4,55h

	chartdat	trig,demomodenext,ces0_cut1

;------------

	chartdat	between,letsgo_whiteout,ces0_cut1,ces0_cut1+2
	chartdat	trig,setbg_sun,ces0_cut1+0
	chartdat	after,km_setscreenflag_bgcolpal,ces0_cut1+0

	chartdat	trig,col2buffer,ces0_cut1+8


	chartdat	after,km_clrscreenflag_bgcolpal,104h
	chartdat	between,col2white,104h,108h
	chartdat	between,colback,109h,120h
	chartdat	trig,endseq0_3_circle_on,100h
	chartdat	after,km_setscreenflag_bgcolpal,120h

	chartdat	between,col2whiteX2,164h,168h
	chartdat	between,colback,169h,16dh
	chartdat	between,colback,169h,16dh
	chartdat	trig,endseq0_0_circle_on,159h

	chartdat	trig,SEbig_explode,160h

	chartdat	between,col2whiteX2,138h+10h,13ch+10h
	chartdat	between,colbackX2,13ch+10h,168h+10h
	chartdat	trig,endseq0_1_circle_on,138h+10h

	chartdat	between,col2white,128h,12ch
	chartdat	between,colbackX2,12dh,138h
	chartdat	trig,endseq0_2_circle_on,126h

	;chartdat	between,destruct_circle_disappear,ces0_cut2,ces0_cut2+20h

	;chartdat	after,km_clrsces0_cut2+20h

	chartdat	after,km_clrscreenflag_bgcolpal,ces0_cut2-5
	;;;chartdat	between,col2white07,ces0_cut2-4,ces0_cut2
	;;;chartdat	between,col2white07,ces0_cut2-4,ces0_cut2

	chartdat	trig,col2buffer,ces0_cut2-5

;------------
; cut2 no hajime no white

	chartdat	trig,circle_off,ces0_cut2+1
	chartdat	trig,addcol_whitenodec,ces0_cut2
	chartdat	trig,deccol_slow,ces0_cut2+4

;------------

;	chartdat	trig,km_setscreenflag_bgcolpal,ces0_cut2+9

	chartdat	trig,demomodenext,ces0_cut2
	;chartdat	trig,endseq0_4_circle_on,ces0_cut2+1

	chartdat	trig,KSOUNDtrans_sdtlk,ces0_cut2


	chartdat	trig,BGM_demo,ces0_cut2+4

;------------
; message
	chartdat	trig,msg_endseq0_0,160h
	chartdat	trig,msg_endseq0_1,180h

;------------

	chartdat	trig,demomodenext,ces0_cut3	;280h
;;;;;;	chartdat	trig,setdust_on,ces0_cut3	;280h
	chartdat	trig,horizonofs_es0_4,ces0_cut3+1	;281h

	chartdat	between,col2whiteFULL07BLUE,3eeh,420h

;------------

;	chartdat	trig,fadeout,420h
;	chartdat	trig,demomodenext,428h
;	chartdat	trig,rasterOFF,428h
;	chartdat	trig,setbg_credit,428h
;	chartdat	trig,fadein,429h

	chartdat	trig,km_gameclear,428h

	chartdat	after,km_clrscreenflag_bgcolpal,3eeh

;;;;;	chartdat	trig,km_gameover,2a0h

;------------
; SE
	chartdat	trig,SEob_core_thud,4ch
	chartdat	trig,SEob_core_thud,68h
	chartdat	trig,BGMall_clear,ces0_cut1

	chartdat	trig,SEtalking01,ces0_cut2+5+40

	chartdat	trig,BGM_demo2,3a1h

;------------

	end_chartdat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	INTERMITION DEMO CHART
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;chart_interdemo_	; chart for start interdemo
;
;
;	chartdat	trig,setgotochika_director,30
;	chartdat	between,trapcheck,0,999
;
;	chartdat	trig,playercontroloff,1000
;	chartdat	trig,interdemo_trans,1001
;	chartdat	trig,interdemo_startdemo,20
;	chartdat	trig,chartoff,20
;
;	chartdat	trig,playercontroloff,0
;	chartdat	trig,interdemo_trans,1
;	chartdat	trig,interdemo_startdemo,20
;	chartdat	trig,chartoff,20
;
;	end_chartdat
;
;-----------------------------------------------------------------------------

chart_d_sen

;----------> end of inter demo
;
;	chartdat	trig,radarOFF,0
;
;	chartdat	trig,BGMstg2,0
;
;	chartdat	after,km_keydisable,0
;	chartdat	trig,setdust_off,0
;	chartdat	trig,demomodenext,90h
;	chartdat	trig,gotodemo_startnext,90h
;	chartdat	trig,chartoff,91h
;
;	chartdat	between,chartskip,10,80h
;
;<----------

;----------> skip
;
;	chartdat	trig,fadeout,1001h
;	chartdat	trig,fadein,1008h
;	chartdat	trig,demomodenext,1008h
;	chartdat	trig,gotodemo_startnext,1008h
;	chartdat	trig,chartoff,1009h
;
;<----------
	end_chartdat


;-----------------------------------------------------------------------------
;
;chart_enter_d_sen
;
;	chartdat	trig,radarON,0
;
;	chartdat	trig,BGMstg2,0
;
;	chartdat	trig,horizonofs6,0
;
;	chartdat	trig,demomodeend,20h
;	chartdat	after,chartoff,20h+1
;
;	end_chartdat
;
;-----------------------------------------------------------------------------
chart_goto_d_sen	;d_sen

	chartdat	trig,km_areaout_off,0
	chartdat	always,setnohitRISE,0
	chartdat	always,setnullshape,0
	chartdat	trig,demomodenext,70
	chartdat	trig,playercontroloff,0
	chartdat	trig,radarOFF,0
	chartdat	trig,BGMstg2,0
	chartdat	trig,km_keydisable,0

	chartdat	between,gotodemo_wait_startnext,0h,3fffh
	chartdat	trig,chartoff,200

;;	chartdat	between,nextskip,8,100

	end_chartdat

;-----------------------------------------------------------------------------
chart_goto_final	;final boss

	chartdat	trig,colalart_off,0	; alart color off!

	chartdat	always,setnullshape,0
	chartdat	trig,playercontroloff,0
	chartdat	after,km_keydisable,0
	chartdat	trig,radarOFF,0

	chartdat	trig,interdemo_startnext,09eh
	chartdat	trig,removemap,09eh
	chartdat	trig,chartoff,09eh

	chartdat	trig,colwhite,55h
	chartdat	trig,col2buffer,55h
	chartdat	trig,col2bufblack_poly,55h

	chartdat	between,colback,55h,62h

	chartdat	trig,final_circle_on,70h
	chartdat	after,col2white,70h


	chartdat	trig,BGMfadeout,0

	chartdat	trig,BGMandorf_tunnel,34h

;;;	chartdat	trig,msg_goto_final_0,60h

	end_chartdat

;-----------------------------------------------------------------------------
chart_goto_endseq0	;ending

cge_ofs0	equ	8

	chartdat	trig,BGMfadeout,20h

	chartdat	trig,demoview_goto_endseq0,20h
	chartdat	trig,playercontroloff,0
	chartdat	always,setnohitRISE,0

	chartdat	trig,trans2csaw,20
	chartdat	trig,radarOFF,5
	chartdat	always,colalart_off,0

	chartdat	trig,cleardemo_startdemo,0e0h+cge_ofs0

	chartdat	trig,removemap,0bfh
	chartdat	trig,make_gotoendseq0_last_ka,0c0h

	chartdat	after,km_clrscreenflag_bgcolpal,88h

	chartdat	trig,col2buffer,0eh
	chartdat	trig,col2bufgray,0eh
	chartdat	between,col2white,080h,0a0h

	chartdat	trig,g_es0_circle_on,90h
	chartdat	trig,circle_off,0c0h

	chartdat	trig,cockpitmodeoff,0	; player on!

	chartdat	after,colback_slow,0c0h+cge_ofs0

	chartdat	trig,colwhiteFULL,0bfh


;------------
; sound
	chartdat	trig,SOUNDPLACE_ROOM,0c2h
	chartdat	trig,KSOUNDtrans_music22,0c0h

;------------
; flash
	chartdat	trig,destruct_flash_on,50h
	chartdat	trig,destruct_flash_RGB_A,50h
	chartdat	trig,destruct_flash_on,60h
	chartdat	trig,destruct_flash_RGB_B,60h
	chartdat	trig,destruct_flash_on,84h
	chartdat	trig,destruct_flash_RGB_C,84h
	chartdat	trig,destruct_flash_on,88h
	chartdat	trig,destruct_flash_RGB_D,88h
;------------
; SE
	chartdat	trig,SEwhite_wipe,94h
	chartdat	trig,BGMescape,0c4h

	end_chartdat

;-----------------------------------------------------------------------------
chart_nextmap_final	;final boss

	chartdat	after,km_keydisable,0
	chartdat	between,gotodemo_wait_startnext,0h,3fffh

	end_chartdat

;-----------------------------------------------------------------------------
chart_nextmap_d_sen	;d_sen

	chartdat	trig,km_areaout_off,0

	chartdat	always,setnohitRISE,0
	chartdat	after,km_keydisable,0
	chartdat	between,gotodemo_wait_startnext,0h,3fffh
;;;	chartdat	between,nextskip,8,3fffh

	end_chartdat

;-----------------------------------------------------------------------------
chart_nextmap_kaitei	;kaitei

	chartdat	trig,km_areaout_off,0

	chartdat	always,setnohitRISE,0
	chartdat	trig,playercontroloff,0
	chartdat	trig,radarOFF,0
	chartdat	trig,BGMstg2,0
	chartdat	after,km_keydisable,0
	chartdat	between,gotodemo_wait_startnext,0h,3fffh
;;;;;	chartdat	between,nextskip,8,3fffh
	chartdat	after,swim2core,0

	end_chartdat
;-----------------------------------------------------------------------------
chart_nextmap_chika	;chika

	chartdat	trig,demoview_chika,0

	chartdat	trig,demomodenext,0
	chartdat	trig,km_areaout_off,0

	chartdat	always,setnohitRISE,0
	chartdat	trig,playercontroloff,0
	chartdat	trig,radarOFF,0
	chartdat	after,km_keydisable,0
	chartdat	between,gotodemo_wait_startnext,0h,3fffh
;;;;;;	chartdat	between,nextskip,8,3fffh

	end_chartdat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³NEXT MAP SKIP³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

chart_nextmap_skip

	chartdat	trig,fadeout,4001h
	chartdat	trig,fadein,4008h
	chartdat	trig,demomodenext,4008h
	chartdat	trig,interdemo_startnext,4008h
	chartdat	trig,chartoff,4008h

	end_chartdat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
chart_enter_chika

chart_chika

	chartdat	before,circle_off,8

	chartdat	trig,BGMstg2,0
	chartdat	always,setnohitRISE,0

;----------> end of inter demo

	chartdat	trig,radarOFF,0
	chartdat	trig,BGMstg2,0
	chartdat	after,km_keydisable,0
	chartdat	trig,demomodenext,2ch
	chartdat	trig,interdemo_startnext,2ch
	chartdat	trig,chartoff,2dh
;;;;;;	chartdat	between,nextskip,8,20h

;<----------

;----------> skip

	;chartdat	trig,fadeout,4001h
	;chartdat	trig,fadein,4008h
	;chartdat	trig,demomodenext,4008h
	;chartdat	trig,interdemo_startnext,4008h
	;chartdat	trig,chartoff,4009h

;<----------

	end_chartdat

chart_enter_d_sen

	chartdat	always,setnohitRISE,0
	chartdat	always,setnullshape,0

	chartdat	trig,radarOFF,0
	chartdat	after,km_keydisable,0
	chartdat	trig,demomodenext,1dh
	chartdat	trig,interdemo_startnext,1dh
	chartdat	trig,chartoff,1eh

	end_chartdat

chart_enter_kaitei
chart_kaitei

	chartdat	before,circle_off,8

	chartdat	always,setnohitRISE,0

;----------> end of inter demo

	chartdat	trig,radarOFF,0
	chartdat	trig,BGMstg2,0
	chartdat	after,km_keydisable,0
	chartdat	trig,demomodenext,45h
	chartdat	trig,interdemo_startnext,46h
	chartdat	trig,chartoff,47h
;;;;;;	chartdat	between,nextskip,8,30h

;<----------

;----------> skip

	;chartdat	trig,fadeout,4001h
	;chartdat	trig,fadein,4008h
	;chartdat	trig,demomodenext,4008h
	;chartdat	trig,interdemo_startnext,4008h
	;chartdat	trig,chartoff,4009h

;<----------

	end_chartdat


;----------> end of inter demo
;
;	chartdat	trig,BGMstg2,0
;
;	chartdat	after,km_keydisable,0
;	chartdat	trig,demomodenext,3dh
;	chartdat	trig,demomodenext,7bh
;	chartdat	trig,gotodemo_startnext,7bh
;	chartdat	trig,chartoff,7ch
;
;	chartdat	between,chartskip,8,74h
;
;<----------
;----------> skip
;
;	chartdat	trig,fadeout,1001h
;	chartdat	trig,fadein,1008h
;	chartdat	trig,demomodenext,1008h
;	chartdat	trig,gotodemo_startnext,1008h
;	chartdat	trig,chartoff,1009h
;<----------
;
;	end_chartdat

;-----------------------------------------------------------------------------

;chart_enter_chika

	;chartdat	trig,radarON,0

	;chartdat	trig,BGMstg2,0

	;chartdat	trig,horizonofs6,0

	;chartdat	trig,demomodeend,31h
	;chartdat	after,chartoff,31h+1

	end_chartdat

;-----------------------------------------------------------------------------
chart_start_d_sen
chart_start_chika

	chartdat	trig,radarON,0
	chartdat	trig,BGMstg2,0
	chartdat	trig,col2buffer,0eh
	chartdat	after,km_keydisable,0
	chartdat	trig,km_keydisable_off_room,10h+1
	chartdat	trig,demomodeend,10h
	chartdat	after,chartoff,10h+1

	end_chartdat

chart_start_kaitei

	chartdat	trig,radarON,0
	chartdat	trig,BGMstg2,0
	chartdat	trig,col2buffer,0eh
	chartdat	trig,demomodeend,24h
	chartdat	after,km_keydisable,0
	chartdat	trig,km_keydisable_off_room,24h+1
	chartdat	after,chartoff,24h+1

	end_chartdat

chart_start_final

	chartdat	trig,km_areaout_off,0
	chartdat	before,destruct_flash_RGB_D,2
	chartdat	before,letsgo_whiteout,3

	chartdat	trig,KSOUNDtrans_music18,0
	chartdat	trig,KSOUNDtrans_music18b,1
	chartdat	trig,BGMandorf_fight,2

	chartdat	trig,SOUNDPLACE_SPACE,5

	chartdat	trig,radarON,5
	chartdat	trig,radar_autorange,6
	chartdat	trig,demomodeend,71

	chartdat	after,km_keydisable,0
	chartdat	trig,km_keydisable_off_room,71+1
	chartdat	after,chartoff,71+1

	chartdat	trig,msg_goto_final_0,10
	chartdat	trig,msg_goto_final_1,70

	end_chartdat


chart_attack

	chartdat	trig,radarOFF,0
	chartdat	trig,radarON_space,40h+1

	chartdat	between,km_keydisable,0,40h+1
	chartdat	trig,km_keydisable_off,40h+1

;;;;	chartdat	trig,displayON,0+40h+1

	chartdat	trig,planetmode_space,0
	chartdat	trig,demomodeend,40h
	chartdat	after,chartoff,40h+1

	end_chartdat

chart_attackback

;	chartdat	trig,radarOFF,0
;	chartdat	trig,radarON_space,50h+1-8

	chartdat	trig,planetmode_space,0
	chartdat	trig,demomodeend,50h-8
	chartdat	after,chartoff,50h+1-8

	end_chartdat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	DEMO CHART
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
chart_suisei

cs_cut1	equ	0c0h-46-20

	chartdat	between,km_keydisable,0,140h-144+cs_cut1
	chartdat	trig,km_keydisable_off,140h-144+cs_cut1

	chartdat	trig,radarOFF,0
	chartdat	trig,damagemeter,0
	chartdat	trig,setdust_off,0

	chartdat	trig,demomodenext,1+45+cs_cut1
	chartdat	trig,demomodenext,1+45+50+cs_cut1
	chartdat	trig,demomodenext,1+45+50+40+cs_cut1
	chartdat	trig,demomodeend,1+45+50+40+25+cs_cut1

	chartdat	trig,setawshape,12ch-144+cs_cut1
	chartdat	trig,radarON,12ch-144+cs_cut1
	chartdat	after,chartoff,140h-144+cs_cut1
	chartdat	trig,col2buffer,10+cs_cut1

	chartdat	trig,setbg_missionextra1,1+45+50+40+cs_cut1
	chartdat	trig,col2buffer,10+cs_cut1


	end_chartdat

;-----------------------------------------------------------------------------
chart_scramble

;	chartdat	trig,km_bossmeteron,0
	chartdat	trig,km_gameover,180
	end_chartdat

;-----------------------------------------------------------------------------
chart_destruct

	chartdat	after,colbackX2,255
	chartdat	trig,col2buffer,254
	chartdat	trig,colfire,254	; col2buffer mo yaru
	chartdat	trig,colwhiteFULL,254


	chartdat	trig,col2buffer,182
	chartdat	between,col2white,185,249

	chartdat	trig,setdust_off,0
	chartdat	trig,setdust_off,0
	chartdat	trig,demomodenext,destruct_space_cam_time0

	chartdat	trig,destruct_col,177

	chartdat	trig,destruct_flash_on,177
	chartdat	trig,destruct_flash_RGB_A,178
	chartdat	trig,destruct_flash_RGB_B,179
	chartdat	trig,destruct_flash_RGB_C,180
	chartdat	trig,destruct_flash_RGB_D,181

	chartdat	trig,destruct_circle_on,185

	chartdat	trig,BGMfadeout,185
	chartdat	trig,SEbig_explode,185+2

	chartdat	after,destruct_circle_stop,207

	chartdat	trig,demomodenext,249
	chartdat	trig,setbg_gameover,250
	chartdat	trig,BGMstg2,250

	chartdat	trig,destruct_circle_addsub11,249
;************
	chartdat	trig,circle_off,250+1+5
;	chartdat	trig,col2buffer,250+1
;	chartdat	trig,colwhite,250+1
;	chartdat	after,colback,250+1

;	chartdat	after,destruct_circle_disappear,250+10

;************

	chartdat	after,chartoff,398+100+200
	chartdat	trig,km_gameover,350

	chartdat	trig,km_andorf_eye,140h

	end_chartdat

;-----------------------------------------------------------------------------

chart_playerdead

	chartdat	trig,cockpitmodeoff,0

;;	chartdat	trig,demomodenext,0
;;	chartdat	trig,col2buffer,0
	chartdat	always,setnohitRISE,0
;	chartdat	trig,makeyoulost,8
	chartdat	after,km_keydisable,0
	chartdat	trig,testdemoview,8
	chartdat	trig,playercontroloff,0
;;;	chartdat	trig,displayOFF,0

	chartdat	trig,BGMstop,0
	chartdat	trig,BGMplayerdown,20

	chartdat	trig,km_playerdead,60+15

	end_chartdat

chart_playerwin

;	chartdat	trig,BGMstepclr,15
;	chartdat	always,setnohitRISE,0
;	chartdat	trig,makeyouwin,8
;	chartdat	after,km_keydisable,0
;	chartdat	trig,testdemoview,0
;	chartdat	trig,playercontroloff,0
;	chartdat	trig,battleend,80-30

	end_chartdat

chart_clrawof_AW

cca_ofs	equ	10h

	chartdat	trig,displayOFF,13h+cca_ofs
	chartdat	trig,disp_cleartime,13h+cca_ofs

	chartdat	trig,cockpitmodeoff,0+cca_ofs
	chartdat	trig,demoview_clrawof,8+cca_ofs

	chartdat	trig,km_keydisable,0
	chartdat	always,setnohitRISE,0
	chartdat	trig,playercontroloff,0
	chartdat	trig,playertranslockoff,0

	chartdat	trig,BGMstepclr,cgt_wait0+cca_ofs

	chartdat	trig,SEport1_normal,0+cca_ofs

	chartdat	trig,setnullshape,60+16+cca_ofs
	chartdat	trig,clrawof_shape,60+16+cca_ofs
	chartdat	trig,SEport1_dush,60+16+cca_ofs
	chartdat	trig,km_stageclear,50h+20+8+8+8+cca_ofs

	end_chartdat


chart_clrawof_trans2AW

cgt_wait0	equ	5
cgt_wait1	equ	22

	chartdat	after,km_keydisable,0
	chartdat	always,setnohitRISE,0
	chartdat	trig,playercontroloff,0
	chartdat	trig,playertranslockoff,0
	chartdat	trig,BGMstepclr,cgt_wait0
	chartdat	trig,trans2csaw,cgt_wait0
	chartdat	trig,chart_clrawof_AW,cgt_wait0

	end_chartdat


;chart_gameclear_room
;
;	chartdat	trig,trans2rb,0
;
;chart_gameclear_marine
;
;	chartdat	trig,BGMfadeout,100h
;	chartdat	after,km_keydisable,0
;	chartdat	trig,km_stageclear,30h+18h
;	chartdat	always,setnohitRISE,0
;	chartdat	trig,playercontroloff,0
;	chartdat	trig,BGMstepclr,5
;	chartdat	trig,km_score,10
;
;	chartdat	trig,BGMfadeout,30h+18h
;	end_chartdat



chart_gameclear_CORE_trans2AW

	chartdat	trig,trans2ofaw,cgt_wait0

	chartdat	after,km_keydisable,0
	chartdat	always,setnohitRISE,0
	chartdat	trig,playercontroloff,0
	chartdat	trig,playertranslockoff,0
	chartdat	trig,BGMfadeout,20
	chartdat	trig,cleardemo_start_core,cgt_wait0+20

	end_chartdat



chart_gameclear_CORE_AW

	chartdat	after,km_keydisable,0
	chartdat	always,setnohitRISE,0
	chartdat	trig,playercontroloff,0
	chartdat	trig,playertranslock,0
	chartdat	trig,cleardemo_start_core,cgt_wait0
	chartdat	trig,BGMfadeout,0

;	chartdat	after,km_keydisable,0
;	chartdat	always,setnohitRISE,0
;	chartdat	trig,playercontroloff,20
;	chartdat	trig,playertranslock,0
;	chartdat	trig,cleardemo_start_core,cgt_wait0+20
;	chartdat	trig,BGMfadeout,0+20

	end_chartdat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
CHARTROU


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CHART TIMER
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.chartoff	LOCAL

	start_chartrou

.chartoff_enter

	ct_set_chartptr	x,off,y

	end_chartrou

;-----------------------------------------------------------------------------
;.chartskip	LOCAL
;
;	start_chartrou
;
;	testjoypad	start,ptrig
;	beq		.cs0
;
;	a16
;
;	lda	#4000h
;	sta	exal_charttimer,y
;
;.cs0	a8
;	end_chartrou
;
;-----------------------------------------------------------------------------
.wait_bomkey	LOCAL

	start_chartrou

	lda	bombexplode
	bne	.wbk1

	testjoypad		spfire,ptrig
	beq		.wbk0

.wbk1	a16

	lda	#bombtimer
	sta	exal_charttimer,y
	sta	charttimer

.wbk0	a8
	end_chartrou

;-----------------------------------------------------------------------------
.disp_cleartime	LOCAL

	start_chartrou

	lda	#1
	sta	gameclear_yjflag

	end_chartrou

;-----------------------------------------------------------------------------
.explode_bomb	LOCAL

	start_chartrou

	lda	#1
	sta	bombexplode

	end_chartrou

;-----------------------------------------------------------------------------
;.nextskip	LOCAL
;
;	start_chartrou
;
;	testjoypad	start,ptrig
;	beq		.cs0
;
;	ct_set_chartptr	x,nextmap_skip,y
;
;	ksound	demo_cancel
;
;	a16
;
;	lda	#4000h
;	sta	exal_charttimer,y
;	sta	charttimer
;
;.cs0	a8
;	end_chartrou
;
;-----------------------------------------------------------------------------
.chart_clrawof_AW	LOCAL

	start_chartrou

	ct_set_chartptr		x,clrawof_AW,y

	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	FADE IN & OUT
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.fadein	LOCAL
	start_chartrou

	km_setval	stayblack,4
	km_setval	fadedir,2
	km_setval	fade,6

	end_chartrou

.fadeout	LOCAL
	start_chartrou

	km_qfadestepdown

	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.vscrollofs_off	LOCAL

	start_chartrou

	sp_vscroll	x,off,y

	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.voffset_off	LOCAL

	start_chartrou

	lda	voffsetflag
	ora	#voffsetflag_p1off
	sta	voffsetflag

	end_chartrou


;.setbgtest	LOCAl
;
;	start_chartrou
;
;	a16
;
;	lda	#bg_missionstage6-bglists
;	sta	currentbg
;	lda	bgflags
;	ora	#bgf_bg
;	sta	bgflags
;	a8
;
;	end_chartrou


.horizonofs_es0_4	LOCAL

	start_chartrou
	a16
	lda	#SCR4_Hofs
	sta	player1_horizon_offset
	a8
	end_chartrou



.horizonofs6	LOCAL
	start_chartrou
	a16
	lda	#SCR6_Hofs
	sta	player1_horizon_offset
	a8
	end_chartrou


.horizonofs4	LOCAL
	start_chartrou
	a16
	lda	#SCR4_Hofs
	sta	player1_horizon_offset
	a8
	end_chartrou

;.horizonofs2	LOCAL
;	start_chartrou
;	a16
;	lda	#SCR6_Hofs
;	sta	player1_horizon_offset
;	a8
;	end_chartrou
;

;----------------------------------------------------------------------------------
; clear demo no BG wo set suru.

.setbg_cleardemo	LOCAL

	start_chartrou

	a16
	lda	clearmapbg
	bra	.setbg

.setbg_credit	LOCAl
	start_chartrou
	a16
	lda	#bg_titledemo-bglists
	bra	.setbg

.setbg_missionextra1	LOCAl
	start_chartrou
	a16
	lda	#bg_missionextra2-bglists
	bra	.setbg

.setbg_sun	LOCAl
	start_chartrou

	lda	voffsetflag
	and	#~voffsetflag_p1off&0ffffh
	sta	voffsetflag

	a16
	lda	#bg_sun-bglists
	bra	.setbg

;.setbg_space	LOCAl
;	start_chartrou
;	a16
;	lda	#bg_missionsos1-bglists
;	bra	.setbg
.setbg_gameover	LOCAl
	start_chartrou
	a16
	lda	#bg_missiongameover-bglists
.setbg	sta	currentbg
	lda	bgflags
	ora	#bgf_bg
	sta	bgflags
	a8

	end_chartrou


;.stormbgcolor	LOCAL
;
;	start_chartrou
;
;	lda	#bgdemo_boss_map1
;	sta	bgdemo_switch
;
;	end_chartrou
;

;.testbefore	LOCAL
;
;	start_chartrou
;
;	lda	gameframe
;;	printh	BEFORE,kawagoe
;
;	end_chartrou
;
;
;.testafter	LOCAL
;
;	start_chartrou
;
;	lda	gameframe
;	printh	AFTER,kawagoe
;
;	end_chartrou
;
;
;.testbetween	LOCAL
;
;	start_chartrou
;
;	lda	gameframe
;;	printh	BETWEEN,kawagoe
;
;	end_chartrou
;

;.testalways	LOCAL
;
;	start_chartrou
;
;	lda	gameframe
;;	printh	ALWAYS,kawagoe
;
;	end_chartrou
;


;.dv_RBclear_gnd	LOCAL
;
;	start_chartrou
;
;	c_view_inbetween	x,on
;	c_set_demoviewstrat	x,RBclear_gnd,y
;
;	end_chartrou
;.dv_bossenter	LOCAL
;
;	start_chartrou
;
;	c_set_demoviewstrat	x,bossenter,y
;
;	end_chartrou

.testdemoview	LOCAL

	start_chartrou

	c_set_demoviewstrat	x,playerdead,y

	c_view_inbetween	x,on

	end_chartrou

.demoview_chika	LOCAL

	start_chartrou

	c_set_demoviewstrat	x,chika,y

;;;;	c_view_inbetween	x,on

	end_chartrou

.demoview_gone	LOCAL

	start_chartrou

	c_set_demoviewstrat	x,enemyhasgone,y

	c_view_inbetween	x,on

	end_chartrou

.demoview_goto_endseq0	LOCAL

	start_chartrou

	c_set_demoviewstrat	x,goto_endseq0,y

	c_view_inbetween	x,on

	end_chartrou

.demoview_clrawof	LOCAL

	start_chartrou

	c_set_demoviewstrat	x,clrawof,y
	c_view_inbetween	x,on

	end_chartrou


.testdemoviewoff	LOCAL

	start_chartrou

	c_set_demoviewstrat	x,off,y

	c_view_inbetween	x,on

	end_chartrou


;TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST
;TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST
;TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST
;.testplayeroff	LOCAL
;
;	start_chartrou
;
;	s_set_strat	x,player_istrat
;
;	end_chartrou
;
;TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST
;TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST
;TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST


;.gmamestartdemoview_2	LOCAL
;
;	start_chartrou
;
;	c_set_demoviewstrat	x,gamestart_2,y
;
;	c_view_inbetween	x,on
;
;	end_chartrou
;

;.awcleardemoview_1	LOCAL
;
;	start_chartrou
;
;	c_set_demoviewstrat	x,awclear_1,y
;
;	c_view_inbetween	x,on
;
;	end_chartrou
;

;.addroty_end	LOCAL
;
;	start_chartrou
;
;.p2	a16
;	lda	p2_roty_init-1
;	bra	.set
;
;.p1	a16
;	lda	p1_roty_init-1
;.set	and	#0ff00H
;	sta	exal_roty,y
;	xba
;	a8
;	sta	al_roty,x
;	end_chartrou


;.addroty_1	LOCAL
;
;	start_chartrou
;
;	a16
;	lda	exal_roty,y
;	clc
;	adc	#100H
;	sta	exal_roty,y
;	xba
;	a8
;	sta	al_roty,x
;
;	end_chartrou

;.addrotx_ff	LOCAL
;
;	start_chartrou
;
;	a16
;	lda	exal_rotx,y
;	clc
;	adc	#-100H
;	sta	exal_rotx,y
;	xba
;	a8
;
;;	printh	ROTXXXXX,kawagoe
;	sta	al_rotx,x
;
;	end_chartrou


;.addrotz_ff	LOCAL
;
;	start_chartrou
;
;	s_add_alvar	B,x,al_rotz,#-1
;
;	end_chartrou
;

;.camxofs0	LOCAL
;
;	start_chartrou
;
;	a16
;	lda	#0
;	sta	exal_camXofs,y
;	sta	exal_camXofsbuf,y
;	sta	exal_sidevel,y
;	a8
;
;	end_chartrou

;--------------------------------------------------------------------------------------
;.setspeed30	LOCAL
;
;	start_chartrou
;
;	s_achase_alvar	B,y,exal_vel,#30,2
;	s_achase_alvar	B,x,al_vel,#0,2
;
;	end_chartrou
;
;--------------------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; set demomode
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.demomodenext	LOCAL

	start_chartrou

	inc	demomode

	a16
	lda	#0
	sta	exal_charttimer_work,y
	a8

	end_chartrou

.demomodeend	LOCAL

	start_chartrou

	stz	demomode
;;;;;	stz	demono

	end_chartrou

;--------------------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; title demo

.logoon	LOCAL
	start_chartrou

	lda	#titlerogo_start
	sta	titlerogo_flag

	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;--------------------------------------------------------------------------------------
;.transcamera	LOCAL
;
;	start_chartrou
;
;	s_achase_alvar2alvar	W,y,exal_camworldy,x,al_worldy,2
;	s_achase_alvar		W,y,exal_camZofs,#0,3
;
;	end_chartrou
;
;--------------------------------------------------------------------------------------
;.kaitei_facecore	LOCAL
;
;	start_chartrou
;
;	toheap	y,x
;
;	a16
;
;
;
;.kfr	lda	#pad_tright
;
;.kfl	lda	#pad_tleft
;.kfor	ora	exal_key_cont,y
;	sta	exal_key_cont,y
;	a8
;
;	end_chartrou
;
;--------------------------------------------------------------------------------------
.swim2core	LOCAL

	start_chartrou

	toheap	y,x

	a16

	lda	al_worldy,x
	cmp	#-100
	bmi	.s2cEND

;	lda	#pad_A!pad_Y!pad_UP
	lda	#pad_UP
	ora	exal_key_cont,y
	sta	exal_key_cont,y

	lda	gameframe
	and	#15
	bne	.s2cEND

	lda	#pad_Y
	ora	exal_key_trig,y
	sta	exal_key_trig,y

.s2cEND	a8

	end_chartrou

;--------------------------------------------------------------------------------------
; player control

.playercontroloff	LOCAL

	start_chartrou

	pl_control	x,off,y

	end_chartrou

.playercontrolon	LOCAL

	start_chartrou

	pl_control	x,on,y

	end_chartrou

.cockpitmodeoff	LOCAL

	start_chartrou

	sp_viewchange	off

	end_chartrou


;.pad_up	LOCAL
;
;	start_chartrou
;
;	a16
;	lda	#pad_up
;	ora	exal_key_cont,y
;	sta	exal_key_cont,y
;	a8
;
;	end_chartrou

;.pad_contYB	LOCAL
;
;	start_chartrou
;
;	a16
;	lda	#pad_B!pad_Y
;	ora	exal_key_cont,y
;	sta	exal_key_cont,y
;	a8
;
;	end_chartrou

;.pad_trigB	LOCAL
;
;	start_chartrou
;
;	a16
;	lda	#pad_B
;	ora	exal_key_trig,y
;	sta	exal_key_trig,y
;	a8
;
;	end_chartrou
;
;.pad_trigL	LOCAL
;
;	start_chartrou
;
;	a16
;	lda	#pad_tLeft
;	ora	exal_key_trig,y
;	sta	exal_key_trig,y
;	a8
;
;	end_chartrou
;
;--------------------------------------------------------------------------------
;.plrrotx0	LOCAL
;
;	start_chartrou
;
;	s_achase_alvar	W,y,exal_rotx,#0,2
;	s_achase_alvar	B,x,al_rotx,#0,2
;
;	end_chartrou
;
;--------------------------------------------------------------------------------
.trans2ofaw		LOCAL
	start_chartrou

	sp_trans_do	x,OF_ARWING,y

	end_chartrou

.trans2csaw		LOCAL
	start_chartrou

	sp_trans_do	x,CS_ARWING,y

	end_chartrou


.trans2rb		LOCAL
	start_chartrou
	sp_trans_do	x,ROBOT,y
	end_chartrou
;--------------------------------------------------------------------------------


.setnohit		LOCAL

	start_chartrou

	lda	#exal_nohit_mask
	sta	exal_nohit,y

	end_chartrou

.setnohitRISE	LOCAL

	start_chartrou

	lda	#exal_nohitRISE_mask
	sta	exal_nohitRISE,y

	end_chartrou
.playercollon	LOCAL

	start_chartrou

	end_chartrou


.playercolloff	LOCAL

	start_chartrou

	lda	exal_nohitRISE,y
	ora	#exal_nohitRISE_mask
	sta	exal_nohitRISe,y

	end_chartrou

.playertranslockoff	LOCAL

	start_chartrou

	sp_trans_lockoff	x,y

	end_chartrou


.playertranslock	LOCAL

	start_chartrou

	sp_trans_lock	x,y

	end_chartrou

;--------------------------------------------------------------------------------------
;shape

.setnullshape	LOCAL

	start_chartrou

	toheap	y,x

	s_set_alsflag	x,invisible

	s_set_alvar	W,x,al_shape,#nullshape

	sp_jmp_playertype	x,ARWING,.sns,y

	phx
	ldx	exal_jetLobjptr,y
	beq	.sns1

	;s_remove_obj	x

	s_set_alsflag	x,invisible

.sns1	ldx	exal_jetRobjptr,y
	beq	.sns2

	;s_remove_obj	x

	s_set_alsflag	x,invisible
.sns2	plx

.sns	end_chartrou

.setawshape		LOCAL

	start_chartrou

	pl_set_PILOTshape	x,x,shape_ARWING

	end_chartrou

;--------------------------------------------------------------------------------------
.damagemeter	LOCAL

	start_chartrou

	pl_damage_meter

	end_chartrou

;--------------------------------------------------------------------------------------
; player mode

.plmode_ofaw	LOCAL
.plmode_csaw	LOCAL

	start_chartrou

	s_copy_alvar2var	W,y,x1,exal_controlmode

	jsl			modechangesrou_l

;	pl_mode_change		x,of_Arwing0_init

	end_chartrou


;.plmode_csaw	LOCAL
;
;	start_chartrou
;
;	pl_mode_change		x,cs_Arwing0_init
;
;	end_chartrou

;.plmode_clearaw	LOCAL
;
;	start_chartrou
;
;	pl_mode_change		x,DM_AWC_0_0_init
;
;	end_chartrou
;
;.plmode_clearaw01	LOCAL
;
;	start_chartrou
;
;	pl_mode_change		x,DM_AWC_0_1
;
;	end_chartrou

;--------------------------------------------------------------------------------------
;.CKCT_overheat	LOCAL
;
;	start_chartrou
;
;	pl_jmpnot_ifoverheat	x,.ckct_ov,y
;	s_set_alvar	W,y,exal_charttimer,#1
;
;	end_chartrou
;
;
;.ckct_ov	ct_set_chartptr	x,gameclear_trans2AW_end,y
;
;	end_chartrou
;
;--------------------------------------------------------------------------------------

	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; set boss
.setboss	LOCAL
	a16
	lda	KgameMapPtr
	asl	a
	and	#0ffH
	cmp	#.bosstableend-.bosstable
	bcc	.cnt
	lda	#0
.cnt	PHX
	tax
	lda.l	.bosstable,x
	sta	tpx
	PLX
	a8
	jmp	(tpx)
.bosstable	DW	setDODORA&WM	;0
	DW	setDODORA&WM	;1
	DW	setDODORA&WM	;2
	DW	setPIERROT&WM	;3
	DW	setDODORA&WM	;4
	DW	setDODORA&WM	;5
	DW	setDODORA&WM	;6
	DW	setDODORA&WM	;7
	DW	setDODORA&WM	;8
	DW	setDODORA&WM	;9
.bosstableend
.bossseqend	LOCAL
	start_chartrou
	pl_endBOSSsequence
	end_chartrou
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	ENDC

.removemap	LOCAL

	start_chartrou
	PUSHXYP
	jsl	remove_map_l
	lda	#0
	sta	Numareas
	jsl	InitBlockmap_l

	PULLXYP
	end_chartrou

;--------------------------------------------------------------------------------------
.spweapbak	LOCAL

	start_chartrou

	end_chartrou

;--------------------------------------------------------------------------------------
;
;.plrblockoff	LOCAL
;
;	start_chartrou
;
;	pl_block	x,off,y
;
;	end_chartrou
;
;--------------------------------------------------------------------------------------
; skip clear demo
;
;.km_stageclear_anykey	LOCAL
;
;	start_chartrou
;
;	a16
;	lda	p_ptrig
;	bit	#pad_A!pad_B!pad_X!pad_Y!pad_start
;	a8
;
;	beq	.ksa0
;	km_setmissionsyori	stageclear
;
;.ksa0	end_chartrou
;
;
;--------------------------------------------------------------------------------------

.km_gameclear	LOCAL

	start_chartrou

	km_setmissionsyori	gameclear

	end_chartrou

;--------------------------------------------------------------------------------------

.km_andorf_eye	LOCAL


	start_chartrou

	end_chartrou

;--------------------------------------------------------------------------------------

.km_playerdead	LOCAL

	start_chartrou

	sm_jmp_if2screen	.kmpd_2p

	km_setmissionsyori	playerdown
.kmpd_2p
	end_chartrou

;--------------------------------------------------------------------------------------
; skip clear demo

.km_keyenable_credit0	LOCAL

	start_chartrou

	lda	Kdifficulty
	beq	.kkc0

	end_chartrou

.km_keyenable_credit1	LOCAL

	start_chartrou

	lda	Kdifficulty
	cmp	#1
	beq	.kkc0

	end_chartrou

.km_keyenable_credit2	LOCAL

	start_chartrou

	lda	Kdifficulty
	cmp	#2
	beq	.kkc0

	end_chartrou



.kkc0	km_setmissionflag	keycheckenable
	ksound	demo_off

	end_chartrou










.km_keydisable	LOCAL

	start_chartrou

	km_setgameflag		keydisable	;[for kawaguchi] :key disable
	km_clrmissionflag	parallel 	;[for kawaguchi] :parallel off

	end_chartrou

.km_keydisable_off_room	LOCAL

	start_chartrou

	km_clrgameflag		areaout		;[for kawaguchi] :area out check disable

	bra	.kkdo

.km_keydisable_off	LOCAL

	start_chartrou

.kkdo	km_clrgameflag		keydisable	;[for kawaguchi] :key disable
	km_setmissionflag	parallel 	;[for kawaguchi] :parallel off

	end_chartrou


;--------------------------------------------------------------------------------------
.km_areaout_off	LOCAL


	start_chartrou

	km_clrgameflag		areaout		;[for kawaguchi] :area out check disable

	end_chartrou

;--------------------------------------------------------------------------------------
; hasgone

.km_hasgone	LOCAL

	start_chartrou

	km_setmissionsyori	enemyrunawaytrig


	end_chartrou
;--------------------------------------------------------------------------------------
; score

;.km_score	LOCAL
;
;	start_chartrou
;
;	km_setgameflag		score
;
;	end_chartrou

;--------------------------------------------------------------------------------------
; score

.km_gameoverscore	LOCAL

	start_chartrou

	lda	#disp_gameoverscore
	sta	gameover_flag

	end_chartrou

;--------------------------------------------------------------------------------------
; blanking off

;.stay_black	LOCAL
;
;	start_chartrou
;
;	lda	#1
;	sta	stayblack
;
;	end_chartrou

;.stay_black_off	LOCAL
;
;	start_chartrou
;
;	lda	#-1
;	sta	stayblack
;	lda	#1
;	sta	fadedir
;
;	end_chartrou

;--------------------------------------------------------------------------------------
; for SPRITE,WIPE etc...

.km_gameover	LOCAL

	start_chartrou

	km_setmissionflag	godemofinish

	end_chartrou

.km_stageclear	LOCAL

	start_chartrou

	km_setmissionsyori	stageclear

	end_chartrou

.msg_stageclear	LOCAL

	start_chartrou

	lda	#1
	sta	gameclear_flag

	end_chartrou

;.km_bossmeteron	LOCAL
;
;	start_chartrou
;
;	a16
;	km_setmissionflag	bossappear
;	a8
;
;	end_chartrou

;.km_bossmeteroff	LOCAL
;
;	start_chartrou
;
;	a16
;	km_clrmissionflag	bossappear
;	a8
;
;	end_chartrou
;

;.km_reset	LOCAL	; goto title sequense
;
;	start_chartrou
;
;	km_setmissionsyori	gameallclear
;	km_clrmistotalflag	all
;	km_settmpgamemode	end
;	km_setgamesyori		rts
;
;	end_chartrou


;.scoreon	LOCAL
;
;	start_chartrou
;
;	km_setgameflag	score
;
;	end_chartrou
;
;--------------------------------------------------------------------------------------
.rasterOFF	LOCAL

	start_chartrou

	lda	#idx_no_raster
	sta	raster_control

	end_chartrou



.rasterON_fire	LOCAL

	start_chartrou

	lda	#idx_fire_raster
	sta	raster_control

	end_chartrou


.rasterON_sea	LOCAL

	start_chartrou

	a16
	lda	KGameMapPtr
	cmp	#stg_stg6
	a8
	bne	.ros

	lda	#idx_sea_raster
	sta	raster_control
.ros
	end_chartrou


;.rasterON_seaROOM	LOCAL
;
;	start_chartrou
;
;	lda	#idx_sea_raster
;	sta	raster_control
;
;	end_chartrou

;--------------------------------------------------------------------------------------
.radarON	LOCAL

	start_chartrou

	a16
	km_clrmissionflag	spriteoff
	km_clrmismapflag	autoradar		;[radar scale off]
	km_setscreenflag	halfadd			;[obj screen half add]
	km_setval		kx_radarscale,scale_ground	;[radar scale]
	a8

	sp_display		on

	end_chartrou


.radarON_space	LOCAL

	start_chartrou

	a16
	km_clrmissionflag	spriteoff
	km_setscreenflag	halfadd			;[obj screen half add]
	a8

	sp_display		on

	end_chartrou


.radar_autorange	LOCAL

	start_chartrou

	km_setmismapflag	autoradar

	end_chartrou

;--------------------------------------------------------------------------------------
.radarOFF	LOCAL
	start_chartrou

	a16
	km_setmissionflag	spriteoff
	a8

	sp_display		off

	end_chartrou

;--------------------------------------------------------------------------------------
.displayON	LOCAL

	start_chartrou

	sp_display	on

	end_chartrou

;--------------------------------------------------------------------------------------
.displayOFF	LOCAL

	start_chartrou

	sp_display	off

	end_chartrou

;--------------------------------------------------------------------------------------
; for DUST

; set	m_dustflags	:flags(see "dalcs.inc")
;	m_dustsprite
;	m_dustsize

;.setdust_raining	LOCAL
;
;	start_chartrou
;
;	storenasty
;	ramnastyoff
;
;	lda.l	m_dustflags
;	ora	#df_raining
;	and	#~df_sprites
;	sta.l	m_dustflags
;
;	restorenasty
;
;	end_chartrou
;
.setdust_off	LOCAL

	start_chartrou

	lda	demoflag
	ora	#demoflag_dustoff
	sta	demoflag


	storenasty
	ramnastyoff

	lda	#0
	sta.l	m_dustflags

	restorenasty

	end_chartrou



.setdust_on	LOCAL

	start_chartrou

	lda	demoflag
	and	#~demoflag_dustoff
	sta	demoflag

;	storenasty
;	ramnastyoff
;
;	lda	#0
;	sta.l	m_dustflags
;
;	restorenasty

	end_chartrou



.setdust_cleardemo	LOCAL

	start_chartrou

	storenasty
	ramnastyoff

	a16
	lda	clear_dustsprite
	sta.l	m_dustsprite
	lda	clear_dustflags
	sta.l	m_dustflags
	a8
	lda	clear_dustsize
	sta.l	m_dustsize

	restorenasty

	end_chartrou


;--------------------------------------------------------------------------------------
; SOUND

.KSOUNDtrans_music22		LOCAL

	start_chartrou

	Kbgminterrupt	music22

	end_chartrou

.KSOUNDtrans_sdtlk		LOCAL

	start_chartrou

	Kbgminterrupt	sdtlk

	end_chartrou

.KSOUNDtrans_music18		LOCAL

	start_chartrou

	Kbgminterrupt	music18

	end_chartrou

.KSOUNDtrans_music18b	LOCAL

	start_chartrou

	Kbgminterrupt	music18b

	end_chartrou

.BGM_demo	LOCAL

	start_chartrou

	KBGM	demo

	end_chartrou

.BGM_demo2	LOCAL

	start_chartrou

	KBGM	demo2

	end_chartrou

.BGMandorf_tunnel	LOCAL

	start_chartrou

	KBGM	androf_tunnel

	end_chartrou

.BGMandorf_fight	LOCAL

	start_chartrou

	KBGM	androf_fight

	end_chartrou

.BGMenemy_gone	LOCAL

	start_chartrou

	KBGM	ememy_gone

	end_chartrou

.BGMtobecont	LOCAL

	start_chartrou

	KBGM	gmover

	end_chartrou

.BGMplayerdown	LOCAL

	start_chartrou

	sm_jmp_if2screen	.Bpd

	KBGM	pldown

.Bpd	end_chartrou

.BGMboss	LOCAL

	start_chartrou

	KBGM	boss

	end_chartrou

.BGMstop	LOCAL

	start_chartrou

	KBGM	stop

	end_chartrou

.BGMfadeout	LOCAL

	start_chartrou

	KBGM	fadeout

	end_chartrou

.BGMlogofadeout	LOCAL
	start_chartrou
	lda	tiw_sprmode
	and	#0ffh
	cmp	#1
	bpl	.blfo0
	KBGM	fadeout
.Blfo0	end_chartrou



;.BGMdemo	LOCAL
;
;	start_chartrou
;
;	KBGM	demo
;
;	end_chartrou

.BGMstg2	LOCAL

	start_chartrou

	KBGM	stg2

	end_chartrou

.BGMqstgclr	LOCAL

	start_chartrou

;	lda	demoNoCLEAR
;	cmp	#demo_clear_d_sen
;	bne	.Bsc0
;
	KBGM	fadeout

;	bra	.Bsc
;
;.Bsc0	KBGM	stgclr

.Bsc	end_chartrou


.BGMstgclr	LOCAL

	start_chartrou

	KBGM	stgclr

	end_chartrou

.BGMall_clear	LOCAL

	start_chartrou

	KBGM	all_clear

	end_chartrou

.BGMescape	LOCAL

	start_chartrou

	KBGM	escape

	end_chartrou


;.SEcallboss	LOCAL
;
;	start_chartrou
;
;	ksound	boss_come
;
;	end_chartrou
;
.SEbig_explode	LOCAL

	start_chartrou

	ksound	big_explode

	end_chartrou

.SEstop_tr	LOCAL

	start_chartrou

	ksound	stop_tr2

	end_chartrou


.SEob_core_thud	LOCAL


	start_chartrou

	ksound	ob_core_thud

	end_chartrou


.SEwhite_wipe	LOCAL


	start_chartrou

	ksound	white_wipe

	end_chartrou


.SEtalking01	LOCAL

	start_chartrou

	kplsound	x,talking01

	end_chartrou


.SEbomb0	LOCAL

	start_chartrou

	kplsound	x,bomshoot

	end_chartrou

.SEbomb1	LOCAL

	start_chartrou

	kplsound	x,bomexplode

	end_chartrou

.SEport1_dush	LOCAL

	start_chartrou

	s_set_var	B,sdport1,#18h

	end_chartrou

.SEport1_normal	LOCAL

	start_chartrou

	s_set_var	B,sdport1,#%100

	end_chartrou

.BGMstepclr	LOCAL

	start_chartrou

	KBGM	stepclr

	end_chartrou



;.SEengine	LOCAL
;
;	start_chartrou
;
;	pl_SE_engine	x
;
;	end_chartrou
;

.SEgameover_voice	LOCAL

	start_chartrou

	ksound	gameover_voice

	end_chartrou

.SOUNDPLACE_ROOM	LOCAL

	start_chartrou

	km_setsndplace	ROOM

	end_chartrou

.SOUNDPLACE_SPACE	LOCAL

	start_chartrou

	km_setsndplace	SPACE
	KM_PUSHSNDPLACE

	end_chartrou
;-----------------------------------------------------------------------------
.planetmode_space	LOCAL

	start_chartrou

	pl_planetmode	space

	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	INTER DEMO SHAPE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;.interdemo_set_playerdummy	LOCAL
;
;	start_chartrou
;
;	s_make_obj	#nullshape,.scaod_exit
;	s_set_path	y,d_sen_playerdummy
;
;	s_copy_pos	y,x
;	s_copy_rots	y,x
;	s_set_strat	y,path_istrat
;	s_set_aldata	y,#1,#1
;	s_set_alsflag	y,colldisable
;
;.isp00	end_chartrou
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Go to Demo
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³ d_sen,chika no clear demo ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.interdemo_startdemo	LOCAL

	start_chartrou

	s_set_var	B,demoNo,demoNoNext
	bra		.idsd

; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³ d_sen,chika no clear demo ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.cleardemo_startdemo	LOCAL

	start_chartrou

	s_set_var	B,demoNo,demoNoClear
	bra		.idsd

;-----------------------------------------------------------------------------
; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³ d_sen,chika no tsunagi demo ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.idsd	s_set_var	B,demoNoNext,#0
	s_set_var	B,demomode,#1

	s_set_strat	x,INTERDEMOplayer_istrat
	s_set_alvar	W,x,al_shape,#nullshape

	end_chartrou

;--------------------------------------------------------------------------------
.interdemo_trans		LOCAL
	start_chartrou

	pl_test_planetmode	space
	beq		.skipt2s

	pl_test_planetmode	marine
	bne		.skipt2o

	sp_trans_do	x,ROBOT,y
	bra		.exitt2o
.skipt2s	sp_trans_do	x,CS_ARWING,y
	bra		.exitt2o
.skipt2o	sp_trans_do	x,OF_ARWING,y
.exitt2o
	end_chartrou


;-----------------------------------------------------------------------------
; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³ d_sen,chika no enter demo ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.gotodemo_wait_startnext	LOCAL

	start_chartrou

	s_jmp_varAND	B,demoflag,#demoflag_nextmap_start,.idsn

	end_chartrou

.gotodemo_startnext	LOCAL

	start_chartrou

.idsn	s_set_var	B,demoNo,demoNoNEXT
	s_set_var	B,demomode,#1

	s_set_strat	x,INTERDEMOplayer_istrat

;	s_set_var	W,mapptr,intermapptr
;	s_set_var	B,mapbank,intermapbank
;	s_set_var	W,intermapptr,#0
;	s_set_var	B,intermapbank,#0

	jmp	.chartoff_enter

	end_chartrou

;-----------------------------------------------------------------------------
; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³ d_sen,chika no enter demo ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.interdemo_startnext	LOCAL

	start_chartrou

	s_set_var	B,demoNo,#demo_wait
	s_set_var	B,demomode,#1

	s_set_strat	x,INTERDEMOplayer_istrat

	s_set_var	W,mapptr,intermapptr
	s_set_var	B,mapbank,intermapbank

	s_set_var	W,intermapptr,#0
	s_set_var	B,intermapbank,#0

	end_chartrou

;-----------------------------------------------------------------------------
; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³ space no clear demo  ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;.cleardemo_start_clrawof	LOCAL
;
;	start_chartrou
;
;	lda		#demo_clrawof
;	bra		.cdsc_enter

; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³ core no destruction demo  ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.cleardemo_start_core	LOCAL

	start_chartrou

	lda		#demo_destruct_core
.cdsc_enter	sta		demoNo

	jsl	makedirector_srou_l

	s_set_var	B,demomode,#1
	s_set_strat	x,CLEARDEMOplayer_istrat
	s_set_alvar	W,x,al_shape,#nullshape

	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CLEAR DEMO SHAPE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.clrawof_shape	LOCAL

	start_chartrou

	s_make_obj	#nullshape,.cas
	s_set_path	y,clrawof
	s_copy_pos	y,x
	s_copy_rots	y,x

	s_copy_alvar2alvar	B,y,al_vel,x,al_vel

	s_set_strat	y,path_istrat
	s_set_aldata	y,#1,#1
	s_set_alsflag	y,colldisable

.cas	end_chartrou
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	goto endseq0 no kabe
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.make_gotoendseq0_last_ka	LOCAL

	start_chartrou

	s_set_var	W,z1,#30+60
	jsr	.mglk
	s_set_var	W,z1,#30
	jsr	.mglk

	end_chartrou

;------------
.mglk
	s_make_obj	#last_ka,.mglkend

	s_set_path	y,goto_es0_last_ka
	s_set_strat	y,path_istrat

	s_add_roffs2pos	B,y,x,x,#0,#0,z1,0,1,0,last_ka_scale+2,last_ka_scale+2,last_ka_scale+2

	lda	#1
	sta.w	al_ap,y
	sta.w	al_hp,y

	s_set_alsflag	y,colldisable

.mglkend	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	COLOUR CHANGE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.coltitle	LOCAl

	start_chartrou

	jsl	cc_copy2buffer_l
	jsl	cc_setbuffer_title_l

	end_chartrou

.colfire	LOCAl

	start_chartrou

	jsl	cc_setbuffer_fire_l

	end_chartrou

.colmarine	LOCAL

	start_chartrou

	jsl	cc_marinecol_l

	end_chartrou


.col2bufblack_poly	LOCAL

	start_chartrou

	jsl	cc_setbuffer_black_l

	end_chartrou

.col2bufgray	LOCAL

	start_chartrou

	jsl	cc_setbuffer_gray_l

	end_chartrou

.col2bufPC	LOCAL

	start_chartrou

	jsl	cc_setbuffer_pc_l

	end_chartrou

.col2bufPC2	LOCAL

	start_chartrou

	jsl	cc_setbuffer_pc2_l

	end_chartrou

.colback_slow	LOCAL

	start_chartrou

	lda	gameframe
	and	#1
	bne	.cbs

	jsl	cc_bakbuffer_l
.cbs
	end_chartrou

.colback	LOCAL

	start_chartrou

	jsl	cc_bakbuffer_l

	end_chartrou

.colbackX2	LOCAL

	start_chartrou

	jsl	cc_bakbuffer_l
	jsl	cc_bakbuffer_l

	end_chartrou

;.colback07	LOCAL
;
;	start_chartrou
;
;	jsl	cc_bakbuffer07_l
;
;	end_chartrou

.col2whiteX2	LOCAL

	start_chartrou

	jsl	cc_addbuffer_white_l
	jsl	cc_addbuffer_white_l

	end_chartrou

.col2white	LOCAL

	start_chartrou

	jsl	cc_addbuffer_white_l

	end_chartrou

.col2whiteYOKO	LOCAL

	start_chartrou

	jsl	cc_addbuffer_whiteYOKO_l

	end_chartrou


.col2whiteFULL07	LOCAL

	start_chartrou

	jsl	cc_addbuffer_whiteFULL07_l

	end_chartrou

.col2whiteFULL07BLUE	LOCAL

	start_chartrou

	jsl	cc_addbuffer_whiteFULL07BLUE_l

	end_chartrou

.col2white07	LOCAL

	start_chartrou

	jsl	cc_addbuffer_white07_l

	end_chartrou

.colwhiteFULL	LOCAL

	start_chartrou

	jsl	cc_whitecolFULL_l

	end_chartrou


.colwhite	LOCAL

	start_chartrou

	jsl	cc_whitecol_l

	end_chartrou

.colgray	LOCAL

	start_chartrou

	jsl	cc_graycol_l

	end_chartrou

.col2buffer	LOCAL

	start_chartrou
	jsl	cc_copy2buffer_l
	end_chartrou

.col2buffer_bomb	LOCAL

	start_chartrou

	lda	playerctlmode
	cmp	#map_room
	beq	.c2bb
	jsl	cc_copy2buffer_l
.c2bb
	end_chartrou


.colalart_off	LOCAL

	start_chartrou

	lda	exal_paletteflag,y
	and	#~exal_paletteflag_alart
	sta	exal_paletteflag,y

	end_chartrou

;-----------------------------------------------------------------------------
.km_setscreenflag_bgcolpal	LOCAL
;ON
	start_chartrou

	pl_transcol	off

	end_chartrou

.km_clrscreenflag_bgcolpal	LOCAL
;OFF
	start_chartrou

	pl_transcol	off

	end_chartrou


.km_clrscreenflag_bgcolpal_final	LOCAL
;OFF
	start_chartrou

	km_clrscreenflag	bgcolpal

	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.taimanflag	LOCAL

	start_chartrou

;	lda	Kdifficulty
;	cmp	#2
;	bne	.tf0
;
;	lda	demotaiman
;	a16
;	and	#3
;	PHX
;	tax
;	lda.l	armada_taiman,x
;	PLX
;	and	#0ffh
;	cmp	exal_charttimer,y
;	a8
;	bne	.tf0
;
;
;	km_setmissionflag	godemofinish
;	lda	#0
;	sta	KEnemyNumber

.tf0
	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	COLOUR ADD & CIRCLE WINDOW
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.circle_off	LOCAL
	start_chartrou

	sm_circle_pri		x,off,y
	a16
	lda	#winm_off
	sta	kx_circlewindowmode,y
	a8

	end_chartrou

;.explodecircleon	LOCAL
;
;	start_chartrou
;
;	sm_circle_pri		x,off,y
;	sm_circle_on		x,#3,#2,#0
;	sm_circle_RGB		x,#31,#31,#31
;
;	sm_jmp_if1screen	.edo0
;	sm_circle_decRGB	x,#2,#4,#4
;	bra			.edo1
;.edo0	sm_circle_decRGB	x,#0,#4,#4
;.edo1
;
;	sm_circle_pri		x,on,y
;
;	end_chartrou



;.explodecirclepos	LOCAL
;
;	start_chartrou
;
;	sm_circle_objpos	x
;
;	end_chartrou


;.andboxdead_circle_on	LOCAL
;
;	start_chartrou
;
;	sm_circle_on		x,#%100011,#22,#0
;	sm_circle_pos		x,#80h,#80h
;	sm_circle_RGB		x,#31,#16,#16
;	sm_circle_decRGB	x,#0,#0,#0
;	sm_circle_pri		x,on,y
;
;	end_chartrou


.destruct_circle_on	LOCAL

	start_chartrou

	sm_circle_on		x,#%100001,#6,#0
	sm_circle_pos		x,#90h,#0a0h
	sm_circle_RGB		x,#31,#31,#31
	sm_circle_decRGB	x,#0,#0,#0
	sm_circle_pri		x,on,y

	end_chartrou

;------------

;.planetcannon_circle_on2	LOCAL
;
;	start_chartrou
;
;	sm_circle_on		x,#%100011,#8,#0
;	sm_circle_pos		x,#6eh,#62h
;	sm_circle_RGB		x,#31,#20,#20
;	sm_circle_decRGB	x,#4,#8,#8
;
;	end_chartrou


;.planetcannon_circle_onX	LOCAL
;
;	start_chartrou
;
;	sm_circle_on		x,#%100011,#8,#0
;	sm_circle_pos		x,#6eh,#62h
;	sm_circle_RGB		x,#31,#31,#31
;	sm_circle_decRGB	x,#1,#2,#2
;
;	end_chartrou

.planetcannon_circle_on	LOCAL

	start_chartrou

	sm_circle_on		x,#%100011,#2,#0
	sm_circle_pos		x,#6eh,#62h
	sm_circle_RGB		x,#31,#16,#16
	sm_circle_decRGB	x,#0,#0,#0

	end_chartrou


.planetcannon_circle_decRGB	LOCAL

	start_chartrou

	sm_circle_decRGB	x,#1,#1,#1

	end_chartrou


.planetcannon_scroll	LOCAL

	start_chartrou

	s_set_var	W,player1_horizon_offset,#SCR2_Hofs-60h
	s_set_var	W,player1hscroll_offset,#100h>>2+40h
	s_set_var	W,player1vscroll_offset,#0h

	end_chartrou

;------------
.endseq0_3_circle_on	LOCAL

	start_chartrou

	sm_circle_on		x,#%100011,#8,#0
	sm_circle_pos		x,#88h,#70h
	sm_circle_RGB		x,#31,#31,#31
	sm_circle_decRGB	x,#1,#2,#2

	end_chartrou


.endseq0_2_circle_on	LOCAL

	start_chartrou

	sm_circle_on		x,#%100011,#1,#0
	sm_circle_pos		x,#88h,#70h
	sm_circle_RGB		x,#31,#31,#31
	sm_circle_decRGB	x,#1,#2,#2

	end_chartrou

.endseq0_1_circle_on	LOCAL

	start_chartrou

	sm_circle_on		x,#%100011,#2,#0
	sm_circle_pos		x,#90h,#60h
	sm_circle_RGB		x,#31,#31,#31
	sm_circle_decRGB	x,#1,#2,#2

	end_chartrou

.endseq0_0_circle_on	LOCAL	; final

	start_chartrou

	sm_circle_on		x,#%100001,#2,#0
	sm_circle_pos		x,#78h,#68h
	sm_circle_RGB		x,#31,#31,#31
	sm_circle_decRGB	x,#0,#0,#0

	end_chartrou

;.endseq0_4_circle_on	LOCAL	; final
;
;	start_chartrou
;
;	sm_circle_pos		x,#78h,#98h
;	sm_circle_decRGB	x,#1,#2,#2
;
;	a16
;	lda	#50
;	sta.w	kx_circleTR,y
;	a8
;	end_chartrou


.g_es0_circle_on	LOCAL

	start_chartrou

	sm_circle_on		x,#%100001,#6,#0
	sm_circle_pos		x,#80h,#60h

	bra	.fco



.final_circle_on	LOCAL

	start_chartrou

	sm_circle_on		x,#%100011,#6,#0
	sm_circle_pos		x,#7eh,#3ch

.fco	sm_circle_RGB		x,#10,#10,#31
	sm_circle_decRGB	x,#0,#0,#0
	sm_circle_pri		x,on,y

	end_chartrou


.destruct_circle_addsub11	LOCAL

	start_chartrou

	lda	#%110011	;#%11
	sta	kx_circleadsub,y

	end_chartrou

.destruct_circle_disappear	LOCAL

	start_chartrou


	lda	kx_circlecolG,y
	beq	.dcd_g
	dec	a
.dcd_g	sta	kx_circlecolG,y

	lda	kx_circlecolB,y
	beq	.dcd_b
	dec	a
.dcd_b	sta	kx_circlecolB,y


	lda	kx_circlecolR,y
	beq	.dcd_r
	dec	a
.dcd_r	sta	kx_circlecolR,y


	end_chartrou



.destruct_circle_stop	LOCAL

	start_chartrou

	lda	#0
	sta	exal_circle_step,y

	end_chartrou


.destruct_circle_clear	LOCAL

	start_chartrou

	lda	#8
	sta	exal_circle_step,y
	lda	#2
	sta	kx_circlefade,y

	end_chartrou



.destruct_col	LOCAL

	start_chartrou
	jsl	cc_destructcol_l
	end_chartrou



.destruct_circle_coladd	LOCAL

	start_chartrou

	lda	kx_circlecolG,y
	inc	a
	inc	a
	bit	#0e0h
	beq	.dcc_g
	lda	#1fh
.dcc_g	sta	kx_circlecolG,y
	lda	kx_circlecolB,y
	inc	a
	bit	#0e0h
	beq	.dcc_b
	lda	#1fh

.dcc_b	sta	kx_circlecolB,y

	end_chartrou



;.andboxdead_flash_on	LOCAL
;
;	start_chartrou
;
;	lda	gameframe
;	and	#31
;	beq	.dfo
;
;	end_chartrou
;
.planetcannon_flash_on	LOCAL

	start_chartrou

	lda	#4
	sta	exal_scrflash,y

	lda	#8
	sta	exal_deccol_r,y
	sta	exal_deccol_g,y
	sta	exal_deccol_b,y

	lda	#31
	sta	exal_addcol_b,y
	sta	exal_addcol_g,y
	sta	exal_addcol_r,y
	jmp	.dn0


.destruct_flash_on	LOCAL

	start_chartrou

.dfo	lda		#7+3
	sta		exal_scrflash,y

	lda		#31
	sta		exal_addcol_b,y
	sta		exal_addcol_g,y
	sta		exal_addcol_r,y
	jmp		.dn0



.destruct_flash_RGB_A	LOCAL

	start_chartrou

	s_set_alvar	B,y,exal_addcol_r,#0
	s_set_alvar	B,y,exal_addcol_g,#31
	s_set_alvar	B,y,exal_addcol_b,#31
	jmp		.dn0

.destruct_flash_RGB_B	LOCAL

	start_chartrou

	s_set_alvar	B,y,exal_addcol_r,#31
	s_set_alvar	B,y,exal_addcol_g,#0
	s_set_alvar	B,y,exal_addcol_b,#31
	jmp		.dn0

.destruct_flash_RGB_C	LOCAL

	start_chartrou

	s_set_alvar	B,y,exal_addcol_r,#31
	s_set_alvar	B,y,exal_addcol_g,#31
	s_set_alvar	B,y,exal_addcol_b,#0
	jmp		.dn0


.addcol_whitenodec	LOCAL

	start_chartrou

	lda	#31
	sta	exal_scrflash,y

	bra	.acw

.addcol_white	LOCAL

	start_chartrou

.acw	lda	#0
	sta	exal_deccol_r,y
	sta	exal_deccol_g,y
	sta	exal_deccol_b,y
	lda	#31
	sta	exal_addcol_r,y
	sta	exal_addcol_g,y
	sta	exal_addcol_b,y

	end_chartrou


.destruct_flash_RGB_D	LOCAL

	start_chartrou

	s_set_alvar	B,y,exal_addcol_r,#31
	s_set_alvar	B,y,exal_addcol_g,#31
	s_set_alvar	B,y,exal_addcol_b,#31

	jmp		.dn0


.deccol_normal	LOCAL

	start_chartrou

.dn0	lda	#4
	sta	exal_deccol_r,y
	sta	exal_deccol_g,y
	sta	exal_deccol_b,y

	end_chartrou

.deccol_slow	LOCAL

	start_chartrou

	lda	#1
	sta	exal_deccol_r,y
	sta	exal_deccol_g,y
	sta	exal_deccol_b,y

	end_chartrou

.title0_flash_on	LOCAL

	start_chartrou

	lda		#7+3
	sta		exal_scrflash,y

	lda		#18
	sta		exal_addcol_r,y
	lda		#0
	sta		exal_addcol_b,y
	sta		exal_addcol_g,y

	jmp		.dn0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³white out addcol³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;.addcol_white	LOCAL
;
;	start_chartrou
;
;	lda	#20
;	sta	exal_scrflash,y
;	lda	#exal_scrflash_flag_lock!exal_scrflash_flag_white_fast
;	lda	#exal_scrflash_flag_white_fast
;	sta	exal_scrflash_flag,y
;
;	end_chartrou

;ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³Special bomb³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ

.bomb_circle_on	LOCAL

	start_chartrou

	s_and_alvar	B,y,exal_circle_flag,#~exal_circle_flag_pri

	sm_circle_on		x,#%100011,#16,#1
	sm_circle_RGB		x,#28,#31,#28
	sm_circle_decRGB	x,#2,#1,#1
	sm_circle_pri		x,on,y

	c_shock_cam	x,#080H,y


;	jsl	circle_objpos_srou_l
;	jsl	calc_scrpos_l
;	sm_circle_pos	x,#80h,#80h



;	lda	exal_circle_decr,y
;	printh	DECRED,kawagoe



	end_chartrou


;.bomb_circle_pos	LOCAL
;
;	start_chartrou
;
;	jsl	circle_objpos_srou_l
;
;	end_chartrou


;.bomb_circle_deccol	LOCAL
;
;	start_chartrou
;
;	sm_circle_decRGB	x,#1,#1,#1
;
;	end_chartrou


.decHP	LOCAL

	start_chartrou

	lda	p1_status
	ora	#p1_status_bom
	sta	p1_status

	end_chartrou

;.destruct_flash_coladd	LOCAL
;
;	start_chartrou
;
;	lda	#5
;	sta	tpx
;	lda	#7
;	sta	tpy
;	lda	#9
;	sta	tpz
;	jsr	decRBG_srou
;
;
;	end_chartrou
;



;.call_KGWindow_l	LOCAL
;
;	start_chartrou
;
;	jsl	Check_KGWindow_l
;
;	end_chartrou


.letsgo_whiteout	LOCAL

	start_chartrou

	lda	#100
	sta	exal_scrflash,y
	lda	#exal_scrflash_flag_set!exal_scrflash_flag_white!exal_scrflash_flag_white_fast
	sta	exal_scrflash_flag,y

	end_chartrou

;.meteo_addblue	LOCAL
;
;	start_chartrou
;
;	lda	#8
;	sta	exal_scrflash,y
;
;	s_set_alvar	B,y,exal_addcol_r,#8
;	s_set_alvar	B,y,exal_addcol_g,#20-5
;	s_set_alvar	B,y,exal_addcol_b,#31-5
;
;	end_chartrou



;.circlewindowoff	LOCAL
;
;	start_chartrou
;
;	km_setval.w	kx_circlewindowmode,winm_off,y
;
;	end_chartrou
;

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	for BATTLE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;.makeyoulost	LOCAL
;
;	start_chartrou
;	sm_jmp_if1screen	.myl
;	jsl	makeyoulost_srou_l
;.myl	end_chartrou
;
;.makeyouwin	LOCAL
;
;	start_chartrou
;	jsl	makeyouwin_srou_l
;	end_chartrou
;
;.battleend	LOCAL
;
;	start_chartrou
;
;	s_jmp_alsflag	x,player2,.bep2
;.bep1
;	s_or_var	B,p1_status,#p1_status_battleend
;	bra	.bepp
;.bep2
;	s_or_var	B,p2_status,#p2_status_battleend
;
;.bepp	end_chartrou
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	MAP POINTER
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;.map_andorf	LOCAl
;	start_chartrou
;
;	s_set_var	W,mapptr,#andorf_stg&07fffH
;	s_set_var	B,mapbank,#andorf_stg>>16
;
;	end_chartrou
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	SET CLEAR DEMO DIRECTOR
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;.setclrrbofdirector	LOCAL
;
;	start_chartrou
;
;	PHY
;	s_make_obj	#nullshape,.scaod_exit
;	s_set_path	y,clrrbofdirector
;	bra		.scaod_enter
;
;-----------------------------------------------------------------------------
;.setgotochika_director	LOCAL
;
;	start_chartrou
;
;	PHY
;	s_make_obj	#nullshape,.scaod_exit
;	s_set_path	y,gotochikadirector
;	bra		.scaod_enter
;
;-----------------------------------------------------------------------------
;.setdestruct_coredirector	LOCAL
;
;	start_chartrou
;
;	PHY
;	s_make_obj	#nullshape,.scaod_exit
;	s_set_path	y,destruct_coredirector
;	bra		.scaod_enter
;
;-----------------------------------------------------------------------------
;.setclrawofdirector	LOCAL
;
;	start_chartrou
;
;	PHY
;	s_make_obj	#nullshape,.scaod_exit
;	s_set_path	y,clrawofdirector
;	s_make_child	#childno_clrdemo
;.scaod_enter	s_copy_pos	y,x
;	s_set_strat	y,path_istrat
;	s_set_aldata	y,#1,#1
;.scaod_exit	PLY
;
;	end_chartrou
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	SET PLAYER'S BASE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;.setbase_clear	LOCAL
;
;	start_chartrou
;
;	PHY
;
;setbase_clear
;
;	s_make_obj	#base_0_F,.exitsetbase_clear
;	s_set_strat	y,path_istrat
;	s_set_path	y,base_clear
;	s_set_aldata	y,#1,#1
;	s_copy_rots	y,x
;	s_set_alvar	B,y,al_roty,#0
;	s_add_roffs2pos	B,y,x,x,#-8H,#-30,#30H,0,1,0,3,0,3
;	s_copy_rots	y,x
;
;.exitsetbase_clear
;
;	PLY
;	end_chartrou
;



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	RGB
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; in	tpx:R dec
;	tpy:G dec
;	tpz:B dec
;	idY:heap pointer
;decRBG_srou
;
;	s_start_strat
;
;	SHORTA
;	LONGI
;
;	lda	kx_circlecolR,y
;	beq	.ecpR
;	sec
;	sbc	tpx	;#4
;	bpl	.ecpR0
;	lda	#0
;.ecpR0	sta	kx_circlecolR,y
;.ecpR
;
;
;
;	lda	kx_circlecolG,y
;	beq	.ecpG
;	sec
;	sbc	tpy	;#8
;	bpl	.ecpG0
;	lda	#0
;.ecpG0	sta	kx_circlecolG,y
;.ecpG
;
;
;	lda	kx_circlecolB,y
;	beq	.ecpB
;	sec
;	sbc	tpz	;#8
;	bpl	.ecpB0
;	lda	#0
;.ecpB0	sta	kx_circlecolB,y
;.ecpB
;
;	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-------------------------------------------------------------------------
.msg_clear_d_sen	LOCAL

	start_chartrou

	lda	#plrmsg_clear_d_sen
	sta	tpx
	lda	#158
	sta	x1
	lda	#89	; pepper
	sta	x2

	jsl	msg_clear_srou_l

	end_chartrou

;-------------------------------------------------------------------------
.msg_clear_chika	LOCAL

	start_chartrou

	lda	#plrmsg_clear_chika
	sta	tpx
	lda	#152	; partner
	sta	x1
	lda	#86	; pepper
	sta	x2

	jsl	msg_clear_srou_l

	end_chartrou

;-------------------------------------------------------------------------
.msg_goto_final_0	LOCAL

	start_chartrou

	lda	Kdifficulty
	beq	.mgf0_140
	dec	a
	beq	.mgf0_141
.mgf0_142	lda	#142	; hard
	bra	.mgf_set
.mgf0_141	lda	#141	; normal
	bra	.mgf_set
.mgf0_140	lda	#140	; easy
	bra	.mgf_set

.msg_goto_final_1	LOCAL

	start_chartrou

	lda	Kdifficulty
	beq	.mgf0_143
	dec	a
	beq	.mgf0_144
.mgf0_145	lda	#145	; hard
	bra	.mgf_set
.mgf0_144	lda	#144	; normal
	bra	.mgf_set
.mgf0_143	lda	#143	; easy
	bra	.mgf_set

;.msg_goto_final_2	LOCAL
;
;	start_chartrou
;
;	lda	Kdifficulty
;	beq	.mgf0_142
;	dec	a
;	beq	.mgf0_139
;.mgf0_142	lda	#142	; hard
;	bra	.mgf_set
;.mgf0_139	lda	#139	; normal
;	bra	.mgf_set
;.mgf0_145	lda	#145	; easy
;	bra	.mgf_set


.mgf_set	sta	tpx
	PHP
	phx
	jsl	FriendMessage_l
	plx
	PLP

	end_chartrou

;-------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³endseq0 no message³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.msg_endseq0_0	LOCAL

	start_chartrou

	lda	Player_friend
	bmi	.me011

	a16
	and	#7
	clc
	adc	#183
	a8

	bra	.me01


.msg_endseq0_1	LOCAL

	start_chartrou

	lda	Player_friend
	bmi	.me011

	lda	p1_PILOTNo

	a16
	and	#7
	clc
	adc	#189

.me01
	a8
	phx
	jsl	FriendMessage_l
	plx

.me011
	end_chartrou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	DEMO DIRECTOR TABLE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


demodirector_tab

	dw	path_suiseidirector&WM
	dl	chart_suisei		;0
	dl	0

	dw	path_destructdirector&WM
	dl	chart_destruct		;1
	dl	0

	dw	path_destructdirector&WM
	dl	chart_destruct		;2(missile)
	dl	0

	dw	path_scrambledirector&WM
	dl	chart_scramble		;3
	dl	0

	dw	path_armadadirector&WM
	dl	chart_armada		;4
	dl	0

	dw	path_letsgodirector&WM
	dl	chart_letsgo		;5
	dl	0

	dw	path_titledirector&WM
	dl	chart_title		;6
	dl	0

	dw	path_logodirector&WM
	dl	chart_logo		;7
	dl	0

	dw	path_gameoverlogodirector&WM
	dl	chart_gameoverlogo		;8
	dl	0

	dw	path_d_sendirector&WM
	dl	chart_d_sen		;9
	dl	1000h

	dw	path_enter_d_sendirector&WM
	dl	chart_enter_d_sen		;10
	dl	0

	dw	path_chikadirector&WM
	dl	chart_chika		;11
	dl	1000h

	dw	path_enter_chikadirector&WM
	dl	chart_enter_chika		;12
	dl	1000h

	dw	path_clear_d_sendirector&WM
	dl	chart_clear_d_sen		;13
	dl	0

	dw	path_clear_chikadirector&WM
	dl	chart_clear_chika		;14
	dl	0

	dw	path_destruct_coredirector&WM
	dl	chart_destruct_core		;15
	dl	0

	dw	path_kaiteidirector&WM
	dl	chart_kaitei		;16
	dl	1000h

	dw	path_enter_kaiteidirector&WM
	dl	chart_enter_kaitei		;17
	dl	0

	dw	path_start_chikadirector&WM
	dl	chart_start_chika		;18
	dl	0

	dw	path_start_kaiteidirector&WM
	dl	chart_start_kaitei		;19
	dl	0

	dw	path_start_d_sendirector&WM
	dl	chart_start_d_sen		;20
	dl	0

	dw	path_start_finaldirector&WM
	dl	chart_start_final		;21
	dl	0

	dw	path_attackdirector&WM
	dl	chart_attack		;22
	dl	0

	dw	path_attackbackdirector&WM
	dl	chart_attackback		;23
	dl	0

	dw	path_endseq0director&WM
	dl	chart_endseq0		;24
	dl	0

	dw	path_taimandirector&WM
	dl	chart_taiman		;25
	dl	0

	dw	path_planetcannondirector&WM
	dl	chart_planetcanon		;26
	dl	0

	dw	path_clear_kaiteidirector&WM
	dl	chart_clear_kaitei		;27
	dl	0

	dw	path_creditseqdirector&WM
	dl	chart_credits		;28
	dl	0

	dw	path_starwolfdirector_demo&WM
	dl	chart_starwolf		;28
	dl	0

demodirector_tab_end

demodirector_tab_max	equ	(demodirector_tab_end-demodirector_tab)>>3


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
