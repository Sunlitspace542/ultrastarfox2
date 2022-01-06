
	incpub	stratrou

wchrlen		equ	15*32



	

;*****************************************************************************
; removeweapons_l
; removes all objects with colltypes of laser or enemyweap
removeweapons_l
	php
	phy
	phx
	a8i16
	ldx	allst
	beq	.noals

.lp	ldy	_next,x

	s_jmp_colltype	x,ENEMYWEAP,.del
	s_jmpnot_colltype x,LASER,.nodel
.del
	s_set_alsflag	x,active
	s_kill_obj	x
.nodel
	tyx
	bne	.lp

.noals
	plx
	ply
	plp
	rtl




;*****************************************************************************

;-------------------------------------
;Calc sideways vectors
	shorta
	longi	
sidevecs_l
	sta	tmpz
	stx	tmpx
	sty	tmpy
	stz	y1
	stz	y1+1
	sec	
	lda	#64
	sbc	al_roty,x
	tax

	i8
	phb
	lda	#0
	pha
	plb

	inx
	lda	sintab,x
	sta	siny
	lda	costab,x
	sta	cosy
	mulslogmac	tmpz,siny
	ldx	#0
	sta	x1
	cmp	#0
	bpl	sidevec1
	dex
sidevec1
	stx	x1+1
	mulslogmac	tmpz,cosy
	ldx	#0
	sta	z1
	cmp	#0
	bpl	sidevec2
	dex
sidevec2
	stx	z1+1
	i16
	ldx	tmpx
	ldy	tmpy
	plb
	rtl

;-------------------------------------
;Calc front vectors
	shorta
	longi	
frontvecs_l
	sta	tmpz
	stx	tmpx
	sty	tmpy
	stz	y1
	stz	y1+1
	lda	al_roty,x
	tax

	i8

	phb
	lda	#0
	pha
	plb

	inx
	lda	sintab,x
	sta	siny
	lda	costab,x
	sta	cosy
	mulslogmac	tmpz,siny
	ldx	#0
	sta	x1
	cmp	#0
	bpl	fvec1
	dex
fvec1
	stx	x1+1
	mulslogmac	tmpz,cosy
	ldx	#0
	sta	z1
	cmp	#0
	bpl	fvec2
	dex
fvec2
	stx	z1+1
	i16
	ldx	tmpx
	ldy	tmpy
	plb
	rtl









;*****************************************************************************
;* count_shapes_l
;*
;* entry:	ai16
;*	A : shape.
;*
;* exit:		ai16
;*	A : number of shapes.
;*	uses Y,X
;*	
;*
	longa
	longi
count_shapes_l
	php
	ldy	allst
	stz	tpa
.findloop
	tyx
	cmp	al_shape,x
	bne	.nfound
	inc	tpa
.nfound	ldy	_next,x
	bne	.findloop	
.end
	lda	tpa
	plp
	rtl










;*****************************************************************************
;* fire_weapon
;*
;* entry: a8i16
;*	 A : weapon number.
;*	 X : object that fire it.
;*
;*
;* exit: a8i16
;*	 A : weapon number.
;*	 X : object that fire it.
;*
;*
;*

fire_weapon_l

	stx	tpx
	ai8
	amul3
	tax
	lda.l	weapons_data+4,x
	pha
	a16
	lda.l	weapons_data+2,x
	dec	a
	pha

	a8i16
	ldx	tpx
	rtl

.nofire	ldy	#0
	rtl




weaphdr	=	0
	include	weapons.inc





;*****************************************************************************
;* do_coll -	
;* 
;* entry:	a8i16	
;*	X   : obj1
;*	X1  : hit count affect.
;* 	TPA : frames per hit count affect. 
;*
;* exit:	a8i16	
;*	X   : obj1
;*	X1  : hit count affect.
;* 	TPA : frames per hit count affect. 
;*
;*


	SHORTA
	LONGI

do_coll_l


	s_decbne_alvar		B,x,al_collcount,.skip
.f2

	s_jmpNOT_varAND		B,pshipflags3,#psf3_intunnel,.ntun
	lda			x1
	cmp			#hardAP
	bne			.nhard
	asra
	sta			x1
.nhard
.ntun

	LDA	AL_HP,X	
	BMI	.o2c
	SEC
	SBC	X1
	BPL	.nnhc
	LDA	#0
.nnhc	STA	AL_HP,X
.o2c	s_set_alvar		B,x,al_collcount,tpa
.skip


;	a16
;	lda.l	svar_collx
;	sta.w	al_worldx,x
;	lda.l	svar_colly
;   	sta.w	al_worldy,x
;  	lda.l	svar_collz
; 	sta.w	al_worldz,x
;	a8

      	rtl






 

;*****************************************************************************
clearmap_l
	i16
	phx
	ldx	allst
	beq	.end

.loop	ldy	_next,x

	a8
	lda_sflags	x,playerobj
	and	#asf_playerobj
	bne	.next

	phy
	jsl	removedeadal_l
	ply
.next	tyx
	bne	.loop
.end

	plx
	rtl


;*****************************************************************************
clearrealobjmap_l
	i16
	phx
	ldx	allst
	beq	.end

.loop	ldy	_next,x

	a8
	lda_sflags	x,realobj
	and	#asf_realobj
	beq	.next

	phy
	jsl	removedeadal_l
	ply
.next	tyx
	bne	.loop
.end

	plx
	rtl

	
;*****************************************************************************
set_normcollptrsx_l
	
;;	a16
;;	lda	#hit_Istrat&WM
;;	sta	al_collstratptr,x
;;	lda	#explode_Istrat&WM
;;	sta	al_expstratptr,x


;;	a8
;;	lda	#hit_Istrat>>16
;;	sta	al_collstratptr+2,x
;;	lda	#explode_Istrat>>16
;;	sta	al_expstratptr+2,x

	rtl         	


;*****************************************************************************
set_normcollptrsy_l
	
;;	a16
;;	lda	#hit_Istrat&WM
;;	sta.w	al_collstratptr,y
;;	lda	#explode_Istrat&WM
;;	sta.w	al_expstratptr,y


;;	a8
;;	lda	#hit_Istrat>>16
;;	sta.w	al_collstratptr+2,y
;;	lda	#explode_Istrat>>16
;;	sta.w	al_expstratptr+2,y

	rtl         	

;*****************************************************************************
set_0collptrsx_l
;;	a16
;;	lda	#0
;;	sta	al_collstratptr,x
;;	sta	al_expstratptr,x

;;	a8
;;	sta	al_collstratptr+2,x
;;	sta	al_expstratptr+2,x
;;
	rtl         	

set_0collptrsy_l
;;	a16
;;	lda	#0
;;	sta.w	al_collstratptr,y
;;	sta.w	al_expstratptr,y
;;	a8
;;	sta.w	al_collstratptr+2,y
;;	sta.w	al_expstratptr+2,y

	rtl         	

;******************************************************************************
add2posobjyfobjx_l
	longa
	longi
	lda	al_worldx,x
	clc
	adc	x2
	sta.w	al_worldx,y
	lda	al_worldz,x
	clc
	adc	z2
	sta.w	al_worldz,y
	lda	al_worldy,x
	clc
	adc	y2
	sta.w	al_worldy,y
	rtl
;**********************************************************************************
	longa
perc56A_l
	asra
	sta	tpx
	asra
	asra
	asra
	clc
	adc	tpx
	rtl
perc62A_l
	asra
	sta	tpx
	asra
	asra
	clc
	adc	tpx
	rtl

perc75A_l
	asra
	sta	tpx
	asra
	clc
	adc	tpx
	rtl
perc87A_l
	asra
	sta	tpx
	asra
	sta	tpy
	asra
	clc
	adc	tpx
	clc
	adc	tpy
	rtl

perc93A_l
	asra
	sta	tpx
	asra
	sta	tpy
	asra
	sta	tpa
	asra
	clc	
	adc	tpa
	clc
	adc	tpx
	clc
	adc	tpy
	rtl











;**********************************************************************************
sr_set_expstrat_expx
;;	a16
;;	lda	#explode_Istrat&WM
;;	sta.l	alx_expstratptr,x
;;	a8
;;	lda	#explode_Istrat>>16
;;	sta.l	alx_expstratptr+2,x
	rtl

sr_set_expstrat_expy
;;	exg_xy
;;	a16
;;	lda	#explode_Istrat&WM
;;	sta.l	alx_expstratptr,x
;;	a8
;;	lda	#explode_Istrat>>16
;;	sta.l	alx_expstratptr+2,x
;;	exg_xy
	rtl



;**********************************************************************************
sr_banktoplayer
	a16
	lda		al_worldx,x
	sec
	sbc		player_posx
	sta		tpa
	asra			
	asra			
	asra			
	asra			
	asra			
	asra
	a8
	clc
	adc		al_rotz,x
	sta		al_rotz,x			


	s_jmp_notdelay	2,.fin,al1pt
	lda		tpa+1
	bmi		.nleft
	s_inc_alvar	B,x,al_roty
	bra		.dt
.nleft
	s_dec_alvar	B,x,al_roty
.dt

	a16
	lda		al_worldy,x
	sec
	sbc		player_posy
	a8

	bmi		.nup
	s_add_alvar	B,x,al_rotx,#1
	bra		.fin
.nup
	s_sub_alvar	B,x,al_rotx,#1
.fin
	rtl
;**********************************************************************************
sr_make_xyvec	
	lda	x1
	sta	trotx

	lda	z1
	sta	tmpz


	lda	#deg90
	sta	troty
	jsl	n3dvecs_l
	 
	a16
	lda	x1
	sta	al_vx,x

	lda	y1
	sta	al_vy,x

	stz	al_vz,x
	a8
	rtl




sr_keeprelto_playerX
	a16
	lda	playervelZ
	sec
	sbc	pviewvelz
	clc
	adc	al_worldz,x
	sta	al_worldz,x
	a8
	rtl

sr_keeprelto_playerY
	a16
	lda	playervelZ
	sec
	sbc	pviewvelz
	clc
	adc.w	al_worldz,y
	sta.w	al_worldz,y
	a8
	rtl


sr_zero_vecsX
	a16
	stz	al_vx,x
	stz	al_vy,x
	stz	al_vz,x
	a8
	
	stz	al_vel,x  
	rtl


sr_zero_vecsY
	a16
	lda	#0
	sta.w	al_vx,y
	sta.w	al_vy,y
	sta.w	al_vz,y
	a8
	
	sta.w	al_vel,y  
	rtl


;**********************************************************************************
	shorta
	longi
nextstate	
	s_next_state		x
	s_brl			jmptostrat
setstate0	s_set_state		x,#0
	s_brl			jmptostrat
setstate1	s_set_state		x,#1
	s_brl			jmptostrat
setstate2	s_set_state		x,#2
	s_brl			jmptostrat
setstate3	s_set_state		x,#3
	s_brl			jmptostrat
setstate4	s_set_state		x,#4
	s_brl			jmptostrat
setstate5	s_set_state		x,#5
	s_brl			jmptostrat
jmptostrat
	s_jmpto_strat			





	




;**********************************************************************************
gen_weapon_l
	s_set_alvar		B,y,al_type,#ATMISSILE
	s_set_alcollflag	y,WEAPON
	s_copy_rots		y,x
	s_set_alvar.w		B,y,al_rotz,#0

	s_add_Roffs2pos.w	B,y,x,x,svar_weapx,svar_weapy,svar_weapz,1,1,1,weapon_scale,weapon_scale,weapon_scale


	phx	
	
	ldx	svar_weapobj
	beq	.nrotobj
	a16
	lda	al_worldx,x
	sta	x2
	lda	al_worldy,x
	sta	y2
	lda	al_worldz,x
	sta	z2
	a8
	exg_xy
	jsl	Xanglexabs_l  
	clc
	adc	svar_weapRx
	sta	al_rotx,x
	jsl	Yanglexabs_l  
	nega
	clc
	adc	svar_weapRy
	sta	al_roty,x
	exg_xy
        	bra	.donerot
.nrotobj
	s_add_alvar		B,y,al_rotx,svar_weapRx
	s_add_alvar		B,y,al_roty,svar_weapRy
.donerot

	plx


	s_copy_alvar2alvar	B,y,al_sbyte1,y,al_rotx
	s_copy_alvar2alvar	B,y,al_sbyte2,y,al_roty


	s_copy_alvar2alvar	B,y,al_sbyte3,x,al_vel		; copy speed

	s_make_immune		



	rtl
;**********************************************************************************
	LONGI
	SHORTA
generatesmoke_l
	s_make_obj	#smoke,.badobj
	s_set_strat	y,smoke_istrat
	s_set_alsflag	y,notslope	
	s_set_alsflag	y,colldisable
	s_init_colanim	y,#0
	s_set_aldata	y,#hardHP,#hardAP
	s_sprite_obj	y,#0
	s_copy_pos	y,x
.badobj
	rtl



;**********************************************************************************


remove_map_l
	php

	ldx	allst
	beq	.nothingtoremove

.lp
	ldy.w	_next,x
	s_jmp_NOTalsflag	x,realobj,.nodel
	jsl	removeinert_l
	s_remove_obj	x
.nodel
	tyx
	bne	.lp

.nothingtoremove


.removeinerts
	ldx	inertlistptr
	beq	.finished

	l_rem.w	inertlistptr,inertfree

	bra	.removeinerts
.finished

	plp

	rtl


;**********************************************************************************


