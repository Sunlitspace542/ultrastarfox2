;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         SYSSTRAT.ASM                                        ;
; AUTHOR:       Dylan Cuthbert                                      ;
; DESCRIPTION:  Strategy system code                                ;
; DATE CREATED: 16-2-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;

	INCPUB	sysstrat

;	strats_start

;---------------------------------
pre_explode_istrat
	s_start_strat
	s_get_resource	L,x,tjmp,WhenDead,explode_istrat
	jmp.l	[tjmp]
;---------------------------------
explode_istrat
	s_start_strat
	s_jmp_NOTalsflag	x,olsobj,.notols
	dec	olsobjs_num
	inc	olsobj_dead

	jsl	checkolslinks_l
.notols

	s_jmp_alsflag	x,dontexplode,.dontexplode

	test_screenmode	onescreen
	bne		.sound1

	jsl	explode_sound_plr2_l
.sound1	jsl	explode_sound_plr1_l

	s_set_alsflag	x,notslope
	s_set_alsflag	x,active

	s_make_obj	#nullshape,.nocando
	s_set_alsflag	y,colldisable
	s_sprite_obj	y,#0
	s_set_alsflag	y,active
	s_set_alsflag	y,notslope
	s_set_alsflag	y,noviewcheck

;---- 65816
; change the explosion length according to size

	a16
	phy

	ldy	al_shape,x
	phx
	tyx

	stz	svar_word1

	lda.l	sh_xmax,x
	cmp.l	sh_ymax,x
	bcs	.usex
	lda.l	sh_ymax,x
.usex	asl	a

	cmp	#expsize_small
	lbcc	.small
	cmp	#expsize_medium
	lbcc	.medium
	cmp	#expsize_large
	lbcc	.large
.FOlarge

	plx

	a8

	jsr	make_explosion_particles

.nodo
	ply
	s_set_alvar		B,y,al_count1,#8
	s_set_alvar		W,y,al_shape,#explosion4&WM
;	s_set_alvar		W,x,al_shape,#expl_8&WM
	s_set_alvar		W,x,al_shape,#nullshape b_tank_2&WM
;	s_set_strat		x,Lexplode_strat
	s_set_strat		x,explode_strat
	s_jmp			.end
.large	longa
	sec
	sbc	#expsize_large
	sta	x1
	lda.l	sh_shift,x
	and	#255
	beq	.l_noshift
.l_shiftitdown
	lsr	x1
	dec	a
	bne	.l_shiftitdown
.l_noshift
	lda	x1
	plx
	ply
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	a8
	sta	al_tx,y

	s_set_alvar		B,y,al_count1,#8
	s_set_alvar		W,y,al_shape,#explosion3&WM
;	s_set_alvar		W,x,al_shape,#expl_8&WM
	s_set_alvar		W,x,al_shape,#nullshape b_tank_2&WM
	s_set_strat		x,explode_strat
	s_jmp			.end

.medium	longa
	sec
	sbc	#expsize_medium
	sta	x1
	lda.l	sh_shift,x
	and	#255
	beq	.m_noshift
.m_shiftitdown
	lsr	x1
	dec	a
	bne	.m_shiftitdown
.m_noshift
	lda	x1
	plx
	ply
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	a8
	sta	al_tx,y

	s_set_alvar		B,y,al_count1,#6
	s_set_alvar		W,y,al_shape,#explosion2&WM
;	s_set_alvar		W,x,al_shape,#expl_6&WM
	s_set_alvar		W,x,al_shape,#nullshape b_tank_2&WM
	s_set_strat		x,explode_strat
	s_jmp			.end

.small	longa
	sec
	sbc	#expsize_small
	sta	x1
	lda.l	sh_shift,x
	and	#255
	beq	.s_noshift
.s_shiftitdown
	lsr	x1
	dec	a
	bne	.s_shiftitdown
.s_noshift
	lda	x1
	plx
	ply
	lsr	a
	lsr	a
	lsr	a
	a8
	sta	al_tx,y		; set size of sprite

	s_set_alvar		B,y,al_count1,#4
	s_set_alvar		W,y,al_shape,#explosion&WM
;	s_set_alvar		W,x,al_shape,#expl_4&WM
	s_set_alvar		W,x,al_shape,#nullshape b_tank_2&WM
	s_set_strat		x,explode_strat


.end
	s_set_alvar		B,y,al_count,#0
	s_init_colanim		y,#0
	s_copy_pos		y,x
	s_set_alvar		B,y,al_hp,#1
	s_set_alsflag		y,colldisable
	s_set_alptrs		y,explode_strat,hit_istrat,explode_istrat
	s_sub_alvar		W,y,al_worldy,svar_word1

.dontexplode
.nocando
;;	s_set_alvar	B,x,al_hp,#1
;;	s_set_alsflag	x,colldisable
;;	s_set_alflag	x,exp
;;	s_set_alvar	B,x,al_count,#0
;;	s_set_alvar	B,x,al_count1,#8

	jsl	murderfamily_l
	jsl	removeinert_l

	s_remove_obj	x
	s_end_strat

;---------------------------------
explode_strat
	s_start_strat

	ldy	playpt1
	sp_jmpnot_playertype	y,ARWING,.novecadd

	a16

	lda	player1_vx
	asl	a
;	asl	a
;	asl	a
	nega
	clc
	adc	al_worldx,x
	sta	al_worldx,x

	lda	player1_vz
	asl	a
;	asl	a
;	asl	a
	nega
	clc
	adc	al_worldz,x
	sta	al_worldz,x
	a8
.novecadd
;	s_particle_data	x,0,0,0
	s_inc_alvar	B,x,al_count
	s_cmp_alvars	B,x,al_count,x,al_count1
	s_bpl		.chkrem
	s_add_colanim	x,#1,#8
	s_end_Strat

.chkrem
	s_jmpNOT_alsflag	x,partobj,.noparticles
	s_particle_data	x,0,0,0
	s_set_strat	x,.here
	s_set_alvar	B,x,al_count,#64
.here	s_start_strat
	s_beqdec_alvar	B,x,al_count,.noparticles
	s_end_strat

.noparticles
	jml	remove_strat
;---------------------------------
remove_strat
	s_set_alsflag	x,invisible
	s_remove_obj	x
	s_end_strat


;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;�  Hit strategy                        �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
hit_istrat
	s_start_strat

	s_jmp_alsflag	x,nohitaffect_really,.nohploss

	ldy	al_hitlist,x
	s_beq	.nohploss

;--- Loop through the hit list for offending blocks --
.nxthit
	sty	hit_hlptr

	a16
	lda.w	hl_alptr,y
	tay
	a8
	lbeq	.nohploss1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; no hit affect?
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	s_jmp_alsflag	x,nohitflash,.dontflash
	s_set_alsflag	x,hitflash
.dontflash

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; is this enemy actually a friend?
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	s_jmpNOT_colltype	y,FRIEND,.notafriend
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; if this friend is a laser then it is the player's laser
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	s_jmpNOT_colltype	y,LASER,.notlaser
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; set the hitbyplayer flags
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	s_jmp_alsflag		y,player2,.notp1
	s_set_alsflag		x,hitbyplayer1
	bra			.notlaser
.notp1	s_set_alsflag		x,hitbyplayer2


.notlaser
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; only knock hp off if the hitter isn't a friend
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	s_jmp_colltype		x,FRIEND,.nohploss1


.notafriend
	lda.w	al_ap,y
	sta	hit_ap

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; if object has colltype of OBJECT then zero the AP
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	s_jmpNOT_colltype	y,OBJECT,.notobj
	stz	hit_ap
.notobj

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; if the start_hit resource has been set and hl_flags|firstframe,
; jump to that routine
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	phy
	ldy	hit_hlptr
	lda.w	hl_flags,y
	and	#hf_firstframe	; first frame?
	beq	.nostart

	lda.w	hl_flags,y
	and	#~hf_firstframe
	sta.w	hl_flags,y

; set a special collision flag for path objects

	s_jmp_NOTalsflag	x,pathobj,.notapath
	s_set_alsflag		x,sflag7
.notapath

	s_get_resource	L,x,tjmp,start_hit,.nostart
	ply
	phy
	lda	#.nohitstrat>>16
	pha
	pea	(.nohitstrat-1)&WM
	jmp.l	[tjmp]
.nostart
	ply

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; if the while_hit resource has been set, jump to that routine
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	phy
	s_get_resource	L,x,tjmp,while_hit,.nohitstrat
	ply
	phy

	lda.w	hl_count,y
	sta	hit_framecount

	lda	#.nohitstrat>>16
	pha
	pea	(.nohitstrat-1)&WM
	jmp.l	[tjmp]
.nohitstrat
	ply

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Knock off the hitpoints
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lda	al_hp,x
	sec
	sbc.w	hit_ap
	sta	al_hp,x
	bpl	.nohploss1
	lda	#0
	sta	al_hp,x

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; and back round for the next block
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

.nohploss1
	ldy	hit_hlptr
	a16
	lda.w	_next,y
	tay
	a8
	lbne	.nxthit

.nohploss
	s_jmp_alsflag	x,active,.dontfreeze
	km_jmpnotgameflag	freeze,.dontfreeze
	s_end_strat
.dontfreeze
	s_jmpto_strat	x

;--------------------------------------------------------------------
; smoke strategy
smoke_istrat
	s_start_strat
	s_add_colanim	x,#1,#8,.remove
	s_end_strat
.remove	s_remove_obj	x
	s_end_strat



;--------------------------------------------------------------
; this makes copies of all the current bg, music and level data
; so you can restore them if you die
; x = map position to restart at
; a = map bank to restart at


	shorta
	longi
set_restart_position_l
	stx	maprestart
	sta	maprestartbank
	ldx	currentbg
	stx	restartbg
	ldx	lastpalfade
	stx	restartpalfade

; also have to copy the map language's various stacks
	phb
	lda	#$7e	; ram bank
	pha
	plb

	ldx	mapjsrptr
	stx	maprestartjsrptr&WM
	ldx	nummapjsr
	stx	maprestartnumjsr&WM
	ldx	nummaploops
	stx	maprestartnumloops&WM

	ldx	#15*3-1
.copystack1	lda	mapjsrstk,x
	sta	maprestartjsrstk,x
	dex
	bpl	.copystack1

	ldx	#2*4-1
.copystack2	lda	mapaddrs,x
	sta	maprestartaddrs,x
	lda	maploops,x
	sta	maprestartloops,x
	dex
	bpl	.copystack2


	plb
	rtl

	longi
restart_l
	php
	phb
	a8
	lda	#0
	pha
	plb

	disable

	a8i16
	lda	maprestartbank
	sta	mapbank
	ldx	maprestart
	stx	mapptr

; have to copy the map language's various stacks back in
	phb
	lda	#$7e	; ram bank
	pha
	plb

	ldx	maprestartjsrptr&WM
	stx	mapjsrptr
	ldx	maprestartnumjsr&WM
	stx	nummapjsr
	ldx	maprestartnumloops&WM
	stx	nummaploops

	ldx	#15*3-1
.copystack1	lda	maprestartjsrstk&WM,x
	sta	mapjsrstk,x
	dex
	bpl	.copystack1

	ldx	#2*4-1
.copystack2	lda	maprestartaddrs&WM,x
	sta	mapaddrs,x
	lda	maprestartloops&WM,x
	sta	maploops,x
	dex
	bpl	.copystack2

	plb


	jsl	initgame_l
	jsl	initblack_l
	jsl	find_window_pri_l

	jsl	playerstart_init_l

	lda	#50
	sta	stagecnt

	a16
	lda	restartbg
	jsl	setbg_l
	jsl	setbginfo_l
;	jsl	setrestartfade_l

	a8
	lda	#1
	sta	fadedir
	stz	fade

	plb
	plp
	enable
	rtl



;----------------------------------------------------
;----------------------------------------------------
	


initgame_strats_l

	a16
;	stz	outdist
	stz	outvx
	stz	outvy
	stz	outvz
	stz	showtype


	lda	#0
	sta.l	m_bossmaxHP	; disable boss hit count meter

	a8i16


	phb
	lda	#$7e
	pha
	plb

;------------------------------------------------------------------------------
; create dummy object
	ldx	allst
	s_make_obj	#nullshape,.badobj
	sty		dummyobj
	s_setnoremove_behind	y
	s_clr_alsflag		y,realobj
	s_set_alsflag		y,playerobj
	s_set_alvar		B,y,al_area,#-1
	bra		.ok
.badobj
   	blink
.ok
	sty	playpt1
	sty	playpt2


	ldx	allst		;do all strategies
.stratlp	stz	aldead
	jsl	do_strat_l
	lda	aldead
	bne	.killal
	ldy	_next,x
.killed	tyx
	bne	.stratlp
	bra	.cont
.killal	ldy	_next,x
	jsl	removedeadal_l
	bra	.killed
.cont

	jsl	init_hitlist_l

;------------------------------------------------------------------------------

	s_set_objtobevar	x,playpt1
	beq			.nopl1
	s_clr_alsflag		x,realobj
	s_set_alsflag		x,playerobj
.nopl1
	s_set_objtobevar	x,playpt2
	beq			.nopl2
	s_clr_alsflag		x,realobj
	s_set_alsflag		x,playerobj
.nopl2


;------------------------------------------------------------------------------
	plb
	
	rtl



;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
init_hitlist_l
	php
	phb
	a8
	lda	#$7e
	pha
	plb
	ai16

	fmtfreelst.w	hitlistfree,hitlist&WM,number_hl,hl_sizeof

	plb
	plp
	rtl
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

playerstart_init_l
	a8
	rtl


;------------------------------------------------------------------------------
; this routine requires the exploding object in X
	SHORTA
	LONGI
make_explosion_particles
	phy
	s_make_obj	#nullshape,.nodo
	s_particle_data		y,7,30,30
	s_set_alsflag		y,active
	s_set_alsflag		y,notslope
	s_set_alsflag		y,noviewcheck
	s_set_alvar		B,y,al_count1,#2
	s_set_alsflag		y,colldisable
	s_set_strat		y,explode_strat
	s_copy_pos		y,x
	s_sub_alvar		W,y,al_worldy,svar_word1
.nodo
	ply
	rts

;*****************************************************************************

;*****************************************************************************

