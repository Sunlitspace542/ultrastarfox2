;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º FILE:                KPLAYER.ASM                          º
;º AUTHOR:              Yasuhiro Kawaguchi & Takumi Kawagoe  º
;º                      Nintendo.co.ltd  EDA                 º
;º DESCRIPTION:         PLAYER CONTROL ROUTINE(part2)        º
;º DATE CREATED:        30-4-93                              º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

	INCPUB	kplayer

	SHORTA
	LONGI

;------------------------------------------------------------------------

dushkey_time	equ	10h

;------------------------------------------------------------------------
;  shape table

shape_walkLtab

	dw	a_ashi_l
	dw	c_ashi_l
	dw	b_ashi_l

shape_walkrtab

	dw	a_ashi_r
	dw	c_ashi_r
	dw	b_ashi_r

shape_swimLtab

	dw	a_swim_l
	dw	c_swim_l
	dw	b_swim_l

shape_swimRtab

	dw	a_swim_r
	dw	c_swim_r
	dw	b_swim_r

;------------------------------------------------------------------------
RBwalkFstart_tab
	foxpilottab	W,abt_RBwalkFstart_
RBwalkF1_tab
	foxpilottab	W,abt_RBwalkF1_
RBwalkF2_tab
	foxpilottab	W,abt_RBwalkF2_
RBwalkBstart_tab
	foxpilottab	W,abt_RBwalkBstart_
RBwalkB1_tab
	foxpilottab	W,abt_RBwalkB1_
RBwalkB2_tab
	foxpilottab	W,abt_RBwalkB2_
RBturnL_tab
	pilottab	W,abt_RBturnL_
RBturnR_tab
	pilottab	W,abt_RBturnR_
RBwalkLstart_tab
	foxpilottab	W,abt_RBwalkL1_
RBwalkRstart_tab
	foxpilottab	W,abt_RBwalkR1_
RBwalkL1_tab
	foxpilottab	W,abt_RBwalkL1_
RBwalkR1_tab
	foxpilottab	W,abt_RBwalkR1_
RBwalkL2_tab
	foxpilottab	W,abt_RBwalkL2_
RBwalkR2_tab
	foxpilottab	W,abt_RBwalkR2_
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
roboleglength	equ	45

; direction of robot(exal_motiondir)

RBdir_mask		equ	3fH
RB_F		equ	1	;direction foward
RB_B		equ	2	;direction back
RB_L		equ	3	;direction left
RB_R		equ	4	;direction right
RB_S		equ	0	;direction stop
RB_dush		equ	1<<6	;push Y?
RB_dush2		equ	1<<7	;push Y?


rotyofspushLR	equ	38
rotyofswalkLR	equ	50

ONFIELD_ROBO_CTL_l

;	al_state is using for animation (See ROBOANIM_srou.animdrive)

	s_start_strat

	a8i16

	toheap	y,x


; ----------------------------------------------------------------------------------

; dusu counter

	lda	exal_dushkeybuffer,y
	sta	tpx

	lda	pcont+1
	and	#padl_up!padl_down!padl_left!padl_right
	sta	exal_dushkeybuffer,y

	and	tpx
	beq	.clrdc

	lda	exal_dushcounter,y
	inc	a
	cmp	#dushkey_time
	bmi	.stadc

	lda	#dushkey_time
	bra	.stadc

.clrdc
	lda	exal_dushkeybuffer,y
	beq	.noset

	a16
	lda	exal_animptrNEXT,y
	beq	.noset
	sta	exal_animptr,y
.noset	a8



	lda	#0
.stadc	sta	exal_dushcounter,y

; ----------------------------------------------------------------------------------

;	pl_boostinc

	pl_jmpnot_ifinthesea	x,.onground
	pl_jmp_KAOinpool	x,.inthesea

.onground	jsr	ROBOJMP_srou
	jsr	ROBOPLASH_srou
	bra	.jmpend

.inthesea	jsr	SUBMARINEJMP_srou

.jmpend	jsl	ROBOgottun_srou_l

	jsr	ontheground_trig_srou
	jsr	ROBOANIM_srou.setmotionANDvel
	jsr	ROBOANIM_srou.walkanimdriver

	jsl	blockmap_srou_l

	jsr	ROBO3dvecs_srou
	jsr	ROBOROTS_srou
	jsr	ROBOadjustfloat_srou
	jsr	makebodysplash_srou

	jsl	noturnxlmt_srou_l

	pl_p2_coltab	x,id_1_c

;------------------------------------------------------------------------------

	toheap	y,x


;------------------------------------------------------------------------------
; exal_rotyoffsetSHOCK --> 0

	s_set_alvar		B,y,exal_rotyoffsetSHOCK,#0

; exal_shockVEL --> 0

	s_set_alvar		B,y,exal_shockVEL,#0

;------------------------------------------------------------------------------
; damage of magma

	stz	x1	; damage HP

	pl_jmpnot_ASHIinpool	x,.nomgdmg,magma

.nomgtrig
	lda	exal_magmadmg,y
	bne	.mgcnt
	lda	#magmadmgint
.mgcnt	dec	a
	sta	exal_magmadmg,y
	cmp	#magmadmgint-1
	bne	.mgexit

.decHP	s_jmp_alsflag	x,nohitaffect,.mgexit

	lda	exal_HP,y
	bne	.decHP0
	sta	al_HP,x	; KILL player
	bra	.mgexit
.decHP0	dec	a
	sta	exal_HP,y
	jsl	hit_effect_small_l
	kplsound	x,damage_s
	bra	.mgexit

.nomgdmg	lda	#0
	sta	exal_magmadmg,y

.mgexit

;------------------------------------------------------------------------------
; in the magma?

	pl_jmpnot_KAOinpool	x,.noburn,magma
	pl_burn			x,on,c,y
.noburn

;------------------------------------------------------------------------------

; ROLLING OFF	
	IFNE	walkertwirl ; walker twirl
	jsl	RB_rolling_srou_l
	ELSEIF ; vanilla
	lda	#0
	sta	exal_rollingoffset,y
	ENDC

;------------------------------------------------------------------------------
; store old exal_motiondir

	s_copy_alvar2alvar	B,y,exal_motiondir,y,exal_motiondir


;------------------------------------------------------------------------------
; copy old vector

	s_copy_alvar2alvar	W,y,exal_vy,x,al_vy


	pl_trans	x,OF_ARWING,transRobo2Arwing

	rtl



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	set rotx,rotz
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ROBOROTS_srou

	PUSHYP

	s_start_strat

	a8i16

	toheap	y,x

;---------------------------------------------------------------------
.m_walkF2	s_jmp_alvarNE 		B,y,exal_motionNo,#m_walkF2,.endm_walkF2
	pl_get_pilotTAB		B,x,x1,RBheadrotxF2tab
	bra			.achaserotx
.endm_walkF2
;---------------------------------------------------------------------
.m_thrashF	s_jmp_alvarNE 		B,y,exal_motionNo,#m_thrashF,.endm_thrashF
	pl_get_pilotTAB		B,x,x1,RBheadrotxtFtab
	bra			.achaserotx
.endm_thrashF
;---------------------------------------------------------------------
	pl_get_pilotTAB		B,x,x1,RBheadrotxNORMtab
;---------------------------------------------------------------------
.achaserotx
	s_achase_alvar		B,x,al_rotx,x1,2

;------------------------------------------------------------------------------
; set rotz
	s_copy_alvar2alvar	B,x,al_rotz,y,exal_rotzoffset

;---------------------------------------------------------------------
	PULLYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ROBOT JUMP ROUTINE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

plashgrav	equ	40H

ROBOPLASH_srou	; hoka no OBJ ga PLAYER wo jmp saseru routine.(use path)

	PUSHXYP

	toheap	y,x

	;testjoypad	X,ptrig
	;rlbeq		.noX

	;rb_plash	x,#4	;macro	[obj,var]

;	s_or_alvar	B,y,exal_robostatus,#exal_robostatus_plash

.noX

; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³check trigger of plash³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	s_jmpNOT_alvarAND	B,y,exal_robostatus,#exal_robostatus_plash,.noflag

	jsr		ROBOJMP_srou.jmpsound_srou

	s_set_alvar	W,y,al_vy,#0
	s_and_alvar	B,y,exal_robostatus,#exal_robostatus_plash^-1
.noflag

; ÚÄÄÄÄÄÄ¿
; ³plash!³
; ÀÄÄÄÄÄÄÙ

	lda			exal_plashcounter,y
	clc
	adc			#plashgrav
	sta			exal_plashcounter,y
	bcc			.noclear

	s_beqdec_alvar		B,y,exal_plashvel,.noclear

.noclear
.zero

	a16
	lda		exal_plashvel,y
	sexa
	sta		x1
	lda		al_my,x
	sec
	sbc		x1
	sta		al_my,x
	a8

.nodec

	PULLXYP

	rts




squatframe		equ	1

jmpacclframe_FOX	equ	8	;normal 8
jmpacclframe_FALCO	equ	8	;normal 8
jmpacclframe_PEPPY	equ	8	;normal 8
jmpacclframe_SLIPPY	equ	8	;normal 8
jmpacclframe_GAL1	equ	8	;normal 8
jmpacclframe_GAL2	equ	8	;normal 8

;work RAM

jmpvel9		equ	work9
jmpvelmax		equ	work8
jmpvel1st		equ	work7
jmpvelincrate	equ	work6
jmpacclframe		equ	work5
jmpgravaccl		equ	work4


; --- Push B(trig) ? ---

ROBOJMP_srou

	PUSHXYP

	a8i16

;-----------------------------------------------------------------------------

.startz
	pl_get_pilotTAB_ST	W,x,jmpvelmax,jmpvelmax_tab
	pgpt_C			 W,x,jmpvel1st,jmpvel1st_tab
	pgpt_C			 W,x,jmpvelincrate,jmpvelincrate_tab
	pgpt_C			 W,x,jmpacclframe,jmpvelacclframe_tab
	pgpt_END		W,x,jmpgravaccl,jmpgravaccl_tab

	a16
	lda		jmpvelmax
	jsl		perc87A_l
	sta		jmpvel9
	a8

	toheap		y,x

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³Clear floating flag³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	s_and_alvar	B,y,exal_robostatus,#exal_robostatus_floating^-1

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³Clear jump flag³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	pl_jmp_ASHIinpool	x,.doclr
	s_jmpNOT_alsflag	x,ontheground,.notclr
.doclr	s_and_alvar		B,y,eal_pbyte1,#roboJMP1_flag^-1
.notclr

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³dec jump counter³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	s_beqdec_alvar		B,y,exal_jmpstatus,.start
.start

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³check trigger³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

; rolling jump
; R twice is lower than L twice, why?										

	IFNE	walkertwirl ; walker twirl
	lda	exal_rollingoffset,y
	cmp	#20H
	beq	.trigon
	cmp	#-20H
	beq	.trigon
	ENDC

	TESTJOYPAD		jump2,ptrig	;B,ptrig
	bne			.trigon
	TESTJOYPAD		jump,ptrig	;B,ptrig
	beq			.notrig

.trigon	s_jmp_alvarnotZERO	B,y,exal_plashvel,.jmpparam
	pl_jmp_KAOinpool	x,.jmpparam
	s_jmpNOT_alsflag	x,ontheground,.notrig

.jmpparam
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³set jump parameters & flags³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	jsr			.jmpsound_srou

	s_set_alvar		B,y,exal_jmpstatus,jmpacclframe	;time
	s_or_alvar		B,y,eal_pbyte1,#roboJMP1_flag		;flag
	s_set_alvar		W,y,exal_jmpvel,jmpvel1st
	s_set_alvar		W,y,exal_jmpHIGH,#0
	s_set_alvar		W,y,exal_gravity,#20

;ÚÄÄÄÄÄÄÄÄÄÄÄ¿
;³calc jmpvel³
;ÀÄÄÄÄÄÄÄÄÄÄÄÙ

.notrig
	;s_jmpNOT_alvarAND	B,y,eal_pbyte1,#roboJMP1_flag,.zero
	;s_jmp_alvarZERO		B,y,exal_jmpstatus,.zero

; --- inc vel ---

	testjoypad	jump2,pcont	;B,pcont
	bne		.pconton
	testjoypad	jump,pcont	;B,pcont
	bne		.pconton

; rolling jump?

	lda	exal_rollingoffset,y
	clc
	adc	#1eH
	cmp	#3cH
	bcc	.zero

.pconton	sm_Fchase_alvar	W,y,exal_jmpvel,jmpvelmax,jmpvelincrate

.zero	s_jmp_alvarNE	B,y,exal_jmpstatus,#0,.velp
	s_Fchase_alvar	W,y,exal_jmpvel,#0,1c0H

; on the ground?

	s_jmp_NOTalsflag	x,ontheground,.novel

;.zeroclr

;jumping now?

	s_jmpNOT_alvarAND	B,y,eal_pbyte1,#roboJMP1_flag,.velp
	s_AND_alvar		B,y,eal_pbyte1,#roboJMP1_flag^-1
	s_bra			.velp

.novel
	s_jmp_alvarMORE		W,y,exal_jmpvel,#-127<<8,.velp	; max falling speed
	s_set_alvar		W,y,exal_jmpvel,#-127<<8
.velp

; --- set worldy ---

	a16
	lda			exal_jmpvel+1,y
	sexa
	sta			y1
	a8

	a16
	lda	y1
	adiv2
	sta	y1
	a8
	s_set_alvar		W,x,al_my,y1

.nojmp

.exitjmp


.nosmoke

.exit


	ldy			al_sword2,x

;---------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄ¿
;³grav on³
;ÀÄÄÄÄÄÄÄÙ
	s_and_alvar	B,y,exal_jmpstatus2,#exal_jmpstatus2_Goff^-1

;---------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄ¿
;³set gravity³
;ÀÄÄÄÄÄÄÄÄÄÄÄÙ

	s_set_var	W,y1,#400H

	pl_jmpnot_ASHIinpool	x,.fcgrav

.fcgravf	s_set_var	W,y1,#100H

.fcgrav	sm_Fchase_alvar	W,y,exal_gravity,y1,jmpgravaccl

;---------------------------------------------------------------------------------
.checkclip

	pl_test_planetmode	marine
	rlbeq			.exitclip

	lda	exal_jmpstatus,y
	rlbne	.exitclip

.checkslopetype

;;;	pl_jmp_ifonthe		x,sand,.ryusapros,y

;---------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³pool no syori³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.poolpros

; in the pool ?

	pl_jmpnot_KAOinpool	x,.exitpool

	s_set_alvar		W,x,al_my,#0

	pl_jmpnot_ZENBUinpool	x,.floating

	s_set_alvar		W,x,al_my,#-1
	bra			.setmy

.floating	s_or_alvar	B,y,exal_robostatus,#exal_robostatus_floating

.setmy	s_copy_alvar2var	W,y,y1,exal_pooldepth
	s_Fchase_alvar		W,x,al_vy,#0,8
	s_set_alvar		W,y,exal_gravity,#0
	s_or_alvar		B,y,exal_jmpstatus2,#exal_jmpstatus2_Goff


.exitpool
	jmp	.exitclip

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ryu-sa no syori³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;.ryusapros
;
;	pl_jmpnot_ASHIinpool	x,.exitryusa
;
;	s_set_alvar	W,x,al_vy,#0
;	s_set_alvar	W,x,al_my,#0
;	s_set_alvar	W,y,exal_gravity,#0
;	s_or_alvar	B,y,exal_jmpstatus2,#exal_jmpstatus2_Goff
;
;	s_jmp_notandframe	#15,.exitryusa
;	s_set_alvar		W,x,al_my,#1
;
;	s_set_var	B,x1,#-13
;	jsr		.makeryusasmoke
;	s_set_var	B,x1,#13
;	jsr		.makeryusasmoke
;
;.exitryusa

;---------------------------------------------------------------------------------

.exitclip

;---------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄ¿
;³display³
;ÀÄÄÄÄÄÄÄÙ
	ldy			al_sword2,x
	s_copy_alvar2var	W,y,y1,exal_jmpHIGH
	s_jmp_alvarMORE		W,x,al_worldy,y1,.nosetHIGH
	s_copy_alvar2alvar	W,y,exal_jmpHIGH,x,al_worldy
.nosetHIGH	a16
	lda			exal_jmpHIGH,y
	nega
	a8

;---------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³slope ni atama wo utu syori³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


;---------------------------------------------------------------------------------

	PULLXYP

	rts


;.makeryusasmoke
;
;	s_set_var	B,z1,#0
;	s_set_var	B,y1,#3
;	stx		x2
;	s_add_rnd2var	x1,#7
;	jsl		makesmokeryusa_srou_l
;	rts
;

.jmpsound_srou	LOCAL

	kplsound	x,ROBOjmp
	rts



jmpvelmax_tab
	pilottabNEG	W,jmpvelmax_
jmpvel1st_tab
	pilottabNEG	W,jmpvel1st_
jmpvelincrate_tab
	pilottab	W,jmpvelincrate_
jmpvelacclframe_tab
	pilottab	W,jmpacclframe_
jmpgravaccl_tab
	pilottab	W,jmpgravaccl_



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	SUBMARINE JUMP ROUTINE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	exal_jmpvel	: jyousyou no sokudo
;	exal_jmpstatus	: jyousyou suru jikan
;	exal_jmpstatus2	: jump no trigger

; --- Push B(trig) ? ---

SUBMARINEJMP_srou

;Mjmpstatusinit_	equ	19	; jyou-syou jikan
;Mjmpvelinit		equ	2	; jump no syosoku (push B only)
;Mjmpvelinit0		equ	1	; jump no syosoku (push UP or DOWN)

;Mjmpstatusinit	equ	19
;Mjmpvelinit		equ	-1	;ex:2
;Mjmpvelinit0		equ	-1	;ex:0
;GRAVADD		equ	30H	; 20H(0-0ffH)



Mjmpwaitframe	equ	5	; max 15


;WORK RAM

Mjmpstatusinit	equ	work9	;1word
GRAVADD		equ	work8	;1word
Mjmpvelinit		equ	work7	;1word
Mjmpvelinit0		equ	work6	;1word
waterres		equ	work5	;resistance of water

	s_start_strat

	PUSHXYP

	a8i16

.startz
	pl_get_pilotTAB_ST	W,x,Mjmpstatusinit,Mjmpstatusinit_tab
	pgpt_C			W,x,GRAVADD,GRAVADD_tab
	pgpt_C			W,x,Mjmpvelinit,Mjmpvelinit_tab
	pgpt_C			W,x,Mjmpvelinit0,Mjmpvelinit_tab
	pgpt_END		W,x,waterres,waterres_tab

	toheap	y,x

;---------------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³umi ni ochita toki no syosokudo wo set suru.³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	pl_jmpnot_iftransfalling_w	x,.notfall,y
	s_set_alvar			W,y,exal_jmpvel,#500h

.notfall
;---------------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³sinkyaku jyo-tai no animation wo set suru.³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	testjoypad	jump2,pcont	;B,pcont
	bne		.animnext
	testjoypad	jump,pcont	;B,pcont
	beq		.anim0
.animnext
	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBswimming&WM
.anim0

;---------------------------------------------------------------------------------------
; jmp trigger

	s_and_alvar		B,y,exal_jmpstatus2,#exal_jmpstatus2_jmptrig^-1

	lda	exal_jmpstatus2,y
	and	#exal_jmpstatus2_ctrMASK
	sta	exal_jmpstatus2,y
	sta	x1
	beq	.jtcktrig

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³counter wo dec suru³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	s_sub_var		B,x1,#1<<4
	s_jmp_varnotZERO	B,x1,.jtnotrig
	s_or_alvar		B,y,exal_jmpstatus2,#exal_jmpstatus2_jmptrig
	s_bra			.jtnotrig

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³check trigger³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

.jtcktrig

.Btrigck
	testjoypad	jump2,ptrig	;B,ptrig
	bne		.Btrigon
	testjoypad	jump,ptrig	;B,ptrig
	beq		.jtnotrig
.Btrigon

	s_set_var	B,x1,#Mjmpwaitframe<<4
	s_jmp_alvarEQ	W,y,exal_animptrNEXT,#abt_RBswim&WM,.nosetptr
	s_set_alvar	W,y,exal_animptr,#abt_RBswim&WM
	s_and_alvar	B,y,exal_animflag,#exal_animflag_repeat^-1

.nosetptr	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBswim&WM


.jtnotrig
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³set exal_jmpstatus2³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	s_and_alvar	B,y,exal_jmpstatus2,#exal_jmpstatus2_ctrMASK^-1
	s_or_alvar	B,y,exal_jmpstatus2,x1

;---------------------------------------------------------------------------------------
;on the ground no toki B wo oshitenakereba,parameter wo CLEAR suru.

	s_jmpnot_alsflag	x,ontheground,.noclr
	testjoypad	jump,pcont	;B,pcont
	bne		.noclr
	testjoypad	jump2,pcont	;B,pcont
	bne		.noclr

	s_set_alvar	W,x,al_my,#0
	s_set_alvar	W,y,exal_jmpvel,#0
	s_set_alvar	B,y,exal_jmpstatus,#0

	s_bra		.noclr

.noclr
;---------------------------------------------------------------------------------------
; check trigger

	s_jmpNOT_alvarAND	B,y,exal_jmpstatus2,#exal_jmpstatus2_jmptrig,.notrig

	s_set_alvar	W,x,al_vy,#0
	s_set_alvar	B,y,exal_jmpcounter,#0
	s_set_alvar	B,y,exal_jmpstatus,Mjmpstatusinit
	s_or_alvar	B,y,eal_pbyte1,#roboJMP1_flag		;flag
	s_set_alvar	B,y,exal_gravcounter,#0

;---------------------------------------------------------------------------------------
; jyousyou sokudo wo set suru.

	s_jmp_alsflag		x,ontheground,.vel1
	testjoypad		UP,pcont
	bne			.vel0
	testjoypad		DOWN,pcont
	bne			.vel0
.vel1	s_set_alvar		W,y,exal_jmpvel,Mjmpvelinit
	s_jmp			.set
.vel0	s_set_alvar		W,y,exal_jmpvel,Mjmpvelinit0
	s_jmp			.set

.notrig	s_jmp_alvarnotZERO	B,y,exal_jmpstatus,.dec
	s_jmp_alvarAND		B,y,exal_jmpcounter,#7,.set
	sm_Fchase_alvar		W,y,exal_jmpvel,#0,waterres	;20H	;1<<8
	s_bra			.set

;---------------------------------------------------------------------------------------
; jyousyou sokudo wo decriment suru.

.dec	s_jmp_alvarMORE		B,y,exal_jmpstatus,#2,.set	;Mjmpvelinit<<1,.set
	s_jmp_alvarAND		B,y,exal_jmpstatus,#1,.set
	s_Fchase_alvar		W,y,exal_jmpvel,#-1,1<<8

;---------------------------------------------------------------------------------------
; exal_jmpvel wo al_mx ni copy suru.

.set
	a16
	lda	exal_jmpvel+1,y
	sexa
	sta	al_my,x
	a8

;---------------------------------------------------------------------------------------
; counter wo inc sitari, dec sitari.....

	testjoypad	jump2,pcont	;B,pcont
	bne		.decstate
	testjoypad	jump,pcont	;B,pcont
	bne		.decstate
	s_set_alvar	B,y,exal_jmpstatus,#0
.decstate	s_beqdec_alvar	B,y,exal_jmpstatus,.exit
.exit	s_inc_alvar	B,y,exal_jmpcounter

;----------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³gravity no on off wo set suru...³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


.gravnormal	s_and_alvar	B,y,exal_jmpstatus2,#exal_jmpstatus2_Goff^-1

;kokono wait ga mondai! vel 0 no tokini flag wo set site G wo ON ni suruka...!?

	s_jmp_alvarZERO		W,x,al_vy,.gravon

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³grav counter ga 0 wo koetara gravity wo on ni suru.³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lda			exal_gravcounter,y
	clc
	adc			GRAVADD
	sta			exal_gravcounter,y
	bcs			.gravon

;	s_jmpNOT_alvarAND	B,y,exal_jmpcounter,#7,.gravon

.gravoff	s_or_alvar		B,y,exal_jmpstatus2,#exal_jmpstatus2_Goff
.gravon

;----------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³clera jump flag³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	s_jmp_alvarnotZERO	B,y,exal_jmpvel,.jumping
	s_jmpnot_alsflag	x,ontheground,.jumping
	s_and_alvar		B,y,eal_pbyte1,#roboJMP1_flag^-1
.jumping
;----------------------------------------------------------------------------------









;----------------------------------------------------------------------------------
; suimen yori ueni ikanai syori....

	pl_jmpnot_ifinthesea	x,.exitsuimen

	s_and_alvar	B,y,exal_robostatus2,#exal_robostatus2_suimen^-1

	a16
	lda	#-RBseadepthofs
	sec
	sbc	SEADEPTH
	clc
	adc	al_worldy,x
	bpl	.exitsuimen

;	s_and_alvar	B,y,exal_vxvyvz,#exal_vxvyvz_vy^-1

	a16
	lda	#0
	sta	al_my,x
	a8

.exitsuimen	PULLXYP

	rts

Mjmpstatusinit_tab		; jyou-syou jikan
	pilottab	W,Sjmpframe_

GRAVADD_tab			; parameter of gravity
	pilottab	W,weight_is

Mjmpvelinit_tab		; syosokudo
	pilottabNEG	W,Sjmpvel1st_

Mjmpvelinit0_tab		; syosokudo(U or D)
	pilottabNEG	W,Sjmpvel1st0_

waterres_tab
	pilottab	W,waterres_

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	STRATROUTINES for ROBOT's moving
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; work ram

R3VmotionNo	equ	work0+0	; 1byte (= exal_motionNo)
R3VdirX	equ	work0+1	; 1byte (rotx buffer)
R3VdirY	equ	work1+0	; 1byte (roty buffer)
R3Vfric	equ	work1+1	; 1byte (friction)
R3Vaccl	equ	work2	; 1word	(accel)
R3Vtmp	equ	work3	; temp
R3V_vx	equ	work4	;
R3V_vz	equ	work5	;

ROBO3dvecs_srou

	s_start_strat


	PUSHXYP

	a8i16

;---------------------------------------------------------------------
; init friction

	s_set_var	B,R3Vfric,#$7f

;---------------------------------------------------------------------
	toheap	y,x

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	PLAYER no roty wo set suru
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	s_set_alvar		B,x,al_rotx,#0

;------------------------------------------------------------------------------

	pl_get_pilottab		B,x,x1,roboLRrotyinc_tab

;------------------------------------------------------------------------------
; Ryu-sa ni hamatta tokino syori...

	pl_jmpnot_ASHIinpool	x,.notinsand,sand

	lda		x1
	adiv2
	adiv2
	sta		x1
.notinsand

;---------------------------------------------------------------------
	IFNE	walkertwirl ; walker twirl code
	lda	exal_RBrollingoffset,y
	bne	.no_turn

	pl_jmp_LASTLRkey	x,.m_turnL,.m_turnR,.no_turn,y

;------------
.m_turnL
	s_achase_alvar	W,y,exal_rotyoffset,#RBrotyoffset<<8,2
	s_achase_alvar	B,y,exal_acclroty,x1,3

	bra		.end_turn
.endm_turnL
;------------
.m_turnR
	s_achase_alvar	W,y,exal_rotyoffset,#-RBrotyoffset<<8,2
	s_neg_var	B,x1
	s_achase_alvar	B,y,exal_acclroty,x1,3

	bra		.end_turn
.endm_turnR
;------------
.no_turn
	s_achase_alvar	B,y,exal_acclroty,#0,2
	s_achase_alvar	W,y,exal_rotyoffset,#0,2

;------------
.end_turn

	pl_jmp_ifturn		x,.turnon

	jsr			OF_AW_lrLR.forceroty
	bra			.setroty

.turnon	s_add_alvars		B,y,exal_roty+1,y,exal_acclroty

.setroty

	lda	exal_roty+1,y
	clc
	adc	exal_rotyoffset+1,y


	pha
	clc
	adc	exal_RBrollingoffset,y
	sta	al_roty,x
	pla
	nega
	clc
	adc	R3VdirY
	sta	R3VdirY


	s_copy_alvar2alvar	B,x,al_roty,y,exal_roty+1
	s_add_alvars		B,x,al_roty,y,exal_rotyoffset+1
	s_add_alvars		B,x,al_roty,y,exal_RBrollingoffset

.exitsetroty
	ELSEIF ; vanilla code starts here
	pl_jmp_LASTLRkey	x,.m_turnL,.m_turnR,.no_turn,y

;------------
.m_turnL	s_set_var	W,y1,#RBrotyoffset<<8
	sp_jmpNOT_ifcockpit	x,.mtL1,y
	s_set_var	W,y1,#RBrotyoffset_cock<<8
.mtL1	s_achase_alvar	W,y,exal_rotyoffset,y1,2
	s_achase_alvar	B,y,exal_acclroty,x1,3

	bra		.end_turn
.endm_turnL
;------------
.m_turnR	s_set_var	W,y1,#-(RBrotyoffset<<8)
	sp_jmpNOT_ifcockpit	x,.mtR1,y
	s_set_var	W,y1,#-(RBrotyoffset_cock<<8)
.mtR1	s_achase_alvar	W,y,exal_rotyoffset,y1,2
	s_neg_var	B,x1
	s_achase_alvar	B,y,exal_acclroty,x1,3

	bra		.end_turn
.endm_turnR
;------------
.no_turn
	s_achase_alvar	B,y,exal_acclroty,#0,1
	s_achase_alvar	W,y,exal_rotyoffset,#0,1

;------------
.end_turn

	pl_jmp_ifturn		x,.turnon

	jsr			OF_AW_lrLR.forceroty
	bra			.setroty

.turnon	s_add_alvars		B,y,exal_roty+1,y,exal_acclroty

.setroty
	lda	exal_rotyoffset+1,y
	clc
	adc	exal_roty+1,y
	sta	al_roty,x
	ENDC
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	calc player's vector
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	lda	#0

	sta	x1
	sta	x2
	sta	y1
	sta	y2
	sta	z1
	sta	z2

	toheap	y,x

	s_copy_alvar2var	B,y,R3VmotionNo,exal_motionNo

;---------------------------------------------------------------------

;get rotY(player's direction)

	lda	exal_jetroty,y
	sta	R3VdirY

;---------------------------------------------------------------------

	pl_jmpNOT_ifinthesea	x,.xdeg0
	s_jmp_alsflag		x,ontheground,.xdeg0

	lda	exal_motionNo,y
	cmp	#m_thrashL
	beq	.xdeg0
	cmp	#m_thrashR
	beq	.xdeg0

	s_push_obj	x
	s_push_obj	y
	s_set_objtobealvar	x,y,exal_jetLobjptr
	lda		al_rotx,x
	s_set_objtobealvar	x,y,exal_jetRobjptr
	clc
	adc		al_rotx,x
	asra
	s_pull_obj	y
	s_pull_obj	x

	clc
	adc	#-deg90
	bra	.setxdeg

.xdeg0	lda	#0
.setxdeg	sta	R3VdirX


;set rotx

	pl_jmpnot_ifjmp		x,.WALKING

	pl_jmp_ifinthesea	x,.SWIMMING

.WALKING
;---------------------------------------------------------------------
.branch	lda	exal_motiondir,y
	and	#RBdir_mask
	cmp	#RB_F
	beq	.foward
	cmp	#RB_B
	beq	.back
	cmp	#RB_L
	beq	.left
	cmp	#RB_R
	beq	.right
	jmp	.stop


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.foward	s_add_var	B,R3VdirY,#deg0
	bra		.fb
;---------------------------------------------------------------------
.back	s_add_var	B,R3VdirY,#deg180
;---------------------------------------------------------------------
.fb	pl_jmp_ifdush	x,.fbdush
	pl_get_pilottab		W,x,R3Vaccl,robospeedaccl_tab
	jmp		.cpvel
.fbdush	pl_get_pilottab		W,x,R3Vaccl,robospeeddushaccl_tab
	jmp		.cpvel
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.left	s_add_var	B,R3VdirY,#deg90
	bra		.lr
;---------------------------------------------------------------------
.right	s_add_var	B,R3VdirY,#-deg90
;---------------------------------------------------------------------
.lr	pl_jmp_ifdush	x,.lrdush
	pl_get_pilottab		W,x,R3Vaccl,robospeedLRaccl_tab
	jmp		.cpvel
.lrdush	pl_get_pilottab		W,x,R3Vaccl,robospeedLRdushaccl_tab
	jmp		.cpvel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


.SWIMMING
;---------------------------------------------------------------------

.branchS	lda	exal_motiondir,y
	and	#RBdir_mask

	cmp	#RB_F
	beq	.fowardS
	cmp	#RB_B
	beq	.backS
	cmp	#RB_L
	rlbeq	.leftS
	cmp	#RB_R
	rlbeq	.rightS
	jmp	.stop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.fowardS	;s_add_var	B,R3VdirY,#deg0
	;bra		.fbS
;---------------------------------------------------------------------
.backS	s_add_var	B,R3VdirY,#deg0
;---------------------------------------------------------------------
.fbS
	lda	exal_motionNo,y
	cmp	#m_thrashF
	beq	.fbdushS
	lda	#m_thrashB
	beq	.fbdushS

;	s_jmp_alvarEQ	B,y,exal_motionNo,#m_thrashF,.fbdushS
;	s_jmp_alvarEQ	B,y,exal_motionNo,#m_thrashB,.fbdushS

.fbS_n
	;pl_get_pilottab	W,x,R3Vaccl,robospeedthrashaccl_tab
	;jmp		.cpvel

.fbdushS	pl_get_pilottab	W,x,R3Vaccl,robospeedthrashFASTaccl_tab
	jmp		.cpvel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.leftS	s_add_var	B,R3VdirY,#deg90
	bra		.lrS
;---------------------------------------------------------------------
.rightS	s_add_var	B,R3VdirY,#-deg90
;---------------------------------------------------------------------
.lrS	;s_jmp_alvarZERO		B,y,exal_jmpstatus,.stop

	s_jmp_alvarEQ		B,y,exal_motionNo,#m_thrashL,.lrdushS
	s_jmp_alvarEQ		B,y,exal_motionNo,#m_thrashR,.lrdushS

.lrS_n	;pl_get_pilottab		W,x,R3Vaccl,robospeedLRaccl_tab
	;jmp		.cpvel
.lrdushS	pl_get_pilottab		W,x,R3Vaccl,robospeedLRthrashaccl_tab
	jmp		.cpvel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.stop	s_set_var		W,R3Vaccl,#0

	s_jmpnot_alsflag	x,ontheground,.air

	rb_jmp_ifonshape	x,.slope

.gnd	pl_get_pilottab		W,x,R3Vfric,robogndfric_tab
	bra			.s_0
.slope	pl_get_pilottab		W,x,R3Vfric,roboslopefric_tab
	bra			.s_0

.air	pl_jmp_ifinthesea	x,.wat
	pl_get_pilottab		W,x,R3Vfric,roboairfric_tab
	bra			.s_0

.wat	pl_get_pilottab		W,x,R3Vfric,robowatfric_tab

.s_0
	s_set_alvar	B,x,al_vel,#0
	s_set_alvar	B,y,exal_vel,#0

	jmp		.calcfric

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.cpvel	s_copy_alvar2alvar	B,x,al_vel,y,exal_vel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.end_dir

;---------------------------------------------------------------------

.m_brakeF
	s_jmp_varNE		B,R3VmotionNo,#m_brakeF,.endm_brakeF


	s_jmp_notandframe	#1,.endm_brakeF
	s_jmpnot_alsflag	x,ontheground,.endm_brakeF

	s_copy_alvar2var	W,y,x2,exal_jetLobjptr
	jsr			ontheground_trig_srou.makesmoke
	s_copy_alvar2var	W,y,x2,exal_jetRobjptr
	jsr			ontheground_trig_srou.makesmoke

.endm_brakeF

;---------------------------------------------------------------------
;set vel

.setvel

	ldy			dummyobj
	s_copy_alvar2alvar	B,y,al_vel,x,al_vel
	s_set_alvar		B,y,al_rotx,R3VdirX
	s_set_alvar		B,y,al_roty,R3VdirY
	s_set_alvar		B,y,al_rotz,#0

	s_exg_objs
	s_gen_3Dvecs		x,al_roty,al_rotx,al_vel
	s_exg_objs

;-----------------------------------------------------------------------------

	a16
	lda.w	al_vx,y
	xba
	and	#0ff00H
	sta	R3V_vx

	lda.w	al_vz,y
	xba
	and	#0ff00H
	sta	R3V_vz

	a8

;-----------------------------------------------------------------------------
; calc friction

.calcfric	toheap	y,x

	lda	R3Vfric
	cmp	#7fh
	rlbeq	.nofric

	s_copy_alvar2var	W,y,R3Vtmp,exal_vx

	pl_smult816A16	R3Vtmp,R3Vtmp,R3Vfric
	a16
	lda		R3Vtmp
	asl		a
	sta		exal_vx,y
	a8

	s_copy_alvar2var	W,y,R3Vtmp,exal_vz
	pl_smult816A16	R3Vtmp,R3Vtmp,R3Vfric
	a16
	lda		R3Vtmp
	asl		a
	sta		exal_vz,y
	a8

	jmp		.setvxvz

.nofric

;-----------------------------------------------------------------------------
; set vector

;************

	a16

.svx	lda	R3V_vx
	beq	.svxset	;exit
	bmi	.svxmi

.svxpl	lda	exal_vx,y
	bmi	.svxpladd1

	cmp	R3V_vx
	beq	.svxexit
	bcc	.svxpladd1
	lda	R3V_vx
	bra	.svxset
.svxpladd1	clc
	adc	R3Vaccl
	bra	.svxset


.svxmi	lda	exal_vx,y
	bpl	.svxmiadd1

	cmp	R3V_vx
	beq	.svxexit
	bcs	.svxmiadd1
	lda	R3V_vx
	bra	.svxset
.svxmiadd1	sec
	sbc	R3Vaccl

.svxset	sta	exal_vx,y

.svxexit

;************

	a16

.svz	lda	R3V_vz
	beq	.svzset	;exit
	bmi	.svzmi

.svzpl	lda	exal_vz,y
	bmi	.svzpladd1

	cmp	R3V_vz
	beq	.svzexit
	bcc	.svzpladd1
	lda	R3V_vz
	bra	.svzset
.svzpladd1	clc
	adc	R3Vaccl
	bra	.svzset


.svzmi	lda	exal_vz,y
	bpl	.svzmiadd1

	cmp	R3V_vz
	beq	.svzexit
	bcs	.svzmiadd1
	lda	R3V_vz
	bra	.svzset
.svzmiadd1	sec
	sbc	R3Vaccl

.svzset	sta	exal_vz,y

.svzexit

;	a8

;	sm_fchase_alvar		W,y,exal_vx,R3V_vx,R3Vaccl
;	sm_fchase_alvar		W,y,exal_vz,R3V_vz,R3Vaccl

;************

;	a16

;	lda	R3V_vx
;	printh	R3V_vx,kawagoe
;	lda	exal_vx,y
;	printh	exal_vx,kawagoe


;-----------------------------------------------------------------------------
.setvxvz	a16

	lda	exal_vx+1,y
	sexa
	sta	x1

	lda	exal_vz+1,y
	sexa
	sta	z1

	a8

;-----------------------------------------------------------------------------
;	Calcurate Robot's vector

	lda	exal_roty+1,y
	clc
	adc	exal_rotyoffset+1,y
	sta	tpy

	jsl	RB_gen3dvecs_l

;-----------------------------------------------------------------------------

.exit
;-----------------------------------------------------------------------------

	PULLXYP

	rts

;-----------------------------------------------------------------------------

RBheadrotxF2tab

	byte	0
	byte	0
	byte	5
	byte	5
	byte	20
	byte	20

RBheadrotxNORMtab

	byte	0
	byte	0
	byte	0
	byte	0
	byte	8
	byte	8

RBheadrotxtFtab

	byte	20
	byte	20
	byte	20
	byte	20
	byte	20
	byte	20

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ACHASE (limitter tuki)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ACHASElimit_srou_l
;	in	x1(16bit) ; chase value   (not change)
;		x2(16bit) ; current value
;		x3(16bit) ; value of limit(not change)
;	out	x2(16bit)
;
; sample for use
;	s_copy_alvar2var	W,y,x1,al_worldx
;	s_copy_alvar2var	W,x,x2,al_worldx
;	s_set_var		W,x3,#achaselimit_max>>1
;	jsr			ACHASElimit_srou
;	s_set_alvar		W,x,al_worldx,x2


	s_start_strat

	a16
	lda	x1
	sec
	sbc	x2
	bmi	.almi

.alpl	sec
	sbc	x3	;#achaselimit_max
	bcc	.achase
	lda	x1
	sec
	sbc	x3	;#achaselimit_max
	sta	x2
	bra	.exit_al

.almi	clc
	adc	x3	;#achaselimit_max
	bcs	.achase

	lda	x1
	clc
	adc	x3	;#achaselimit_max
	sta	x2
	bra	.exit_al

.exit_al

.achase	a8
	s_achase_var		W,x2,x1,1
;.exit_al
	a8
	rtl


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	STRATS for ROBOT's LEG
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	p1_leg_phase		: leg no phase
;	p1_leg_phasespeed	: leg no phase no speed
;	p2_leg_phase		: leg no phase
;	p2_leg_phasespeed	: leg no phase no speed
;	al_sword2	: other leg's alien pointer
;	al_pbyte1	: motionNo bak
;	al_pbyte2	: motion counter
;	al_pbyte3	: phase leg's phase = leg's phase+80H
;	al_sbyte4	: = al_animframe
;	al_sbyte3	: offset Z
;	al_sbyte2	: offset Y
;	al_sbyte1	: offset X
;	al_pword1+0	: rotx offset(thrash=bataashi no toki tsukau)
;	sflag1		: L leg or R leg flag 0:L 1:R
;	sflag2		: 0:walk shape 1:swim shape (animdriver de set suru.)

;leg_phase		equ	work5		: leg_phase
;leg_phasespeed	equ	work6		: leg_phasespeed

phasevel		equ		10
;RBleg_Xofs		equ		20	;25
RBleg_Yofs		equ		-30
RBleg_Yofsmin	equ		-5
RBleg_rotxmax	equ		40
RBleg_rotxmin	equ		14

RBlegL_Istrat	; kikiashi!

	s_start_strat
	set_leftflag		x
	s_set_strat		x,RBlegL_strat
	bra			RBlegR_Istrat.istrat

;-----------------------------------------------------------------
RBlegR_Istrat
	s_start_strat
	set_rightflag		x
	s_set_strat		x,RBlegR_strat

.istrat	LOCAL

	S_SET_ALSFLAG	x,ACTIVE

	pl_set_area	x,-1

	s_clr_alsflag	x,realobj
	s_clr_alsflag	x,sflag2

	s_set_objtobealvar	y,x,al_ptr
	s_copy_alvar2alvar	W,x,al_coltab,y,al_coltab
	s_copy_alvar2alvar	W,x,al_depthoffset,y,al_depthoffset

	s_clr_alsflag	x,shadow	; shadow on
	s_set_alsflag	x,colldisable
	s_set_alsflag	x,notslope
	s_set_colltype	x,FRIEND

	s_set_objtobealvar	y,x,al_ptr
	s_copy_rots		x,y

	s_end_strat


RBleg_xofstab	; mata no haba

	word	ashiofsx_FF	;A-WING
	word	ashiofsx_SP	;C-WING
	word	ashiofsx_GG	;B-WING

RBleg_yofstab	; atama no takasa

	word	ashiofsy_FF	;
	word	ashiofsy_SP	;
	word	ashiofsy_GG	;

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	pbyte1 = motion counter(for pchase)
;	pbyte2 = motionNo buffer
;	sbyte1 = rotx offset
;	sbyte2 = roty offset
;	sbyte3 = rotz offset
;	sbyte4 = animframe buffer (0-15)
;		 (display.asm no setPcur_chr de tukatteiru!)
;
;	sword1+0 = worldy offset
;	sword1+1 = worldz offset

;	sflag1	: 0=left leg 1=right leg

RALrxofs		equ	work0	;rot x offset
RALryofs		equ	work1	;rot y offset
RALrzofs		equ	work2	;rot z offset

animLeg_Xofs		equ	20
legrotyofsmax	equ	30H

;alvars

alQ_motioncounter	equ	al_pbyte1
alQ_statebak		equ	al_pbyte2


RBlegL_strat
RBlegR_strat

	s_start_strat

	s_set_alsflag	x,active
	s_set_alsflag	x,colldisable

;---------------------------------------------------------------------------------------------------
; cockpit mode?

	s_set_objtobealvar	y,x,al_ptr

;	s_clr_alsflag		x,invisible
;	s_jmpnot_alsflag	y,insidecockpit,.notcock
;	s_set_alsflag		x,invisible
;.notcock

;---------------------------------------------------------------------------------------------------
; player no flag wo copy suru.

	s_clr_alsflag		x,shadow

	pl_copy_alsflag		x,y,hitflash
	pl_copy_alsflag		x,y,insidecockpit
	pl_copy_alsflag		x,y,invisible

	s_copy_alvar2alvar	W,x,al_depthoffset,y,al_depthoffset

;---------------------------------------------------------------------------------------------------
; clip code wo copy suru.

	s_copy_alvar2alvar	B,x,al_clip,y,al_clip

;---------------------------------------------------------------------------------------------------
; if player is not WALKER then REMOVE

	sp_jmp_playertype	y,ROBOT,.start

	jmp			playerobjctremove

.start
;----------------------------------------------------------------------------

;player's exal_motionNo --> state

	a16
	lda	#0
	sta	RALrxofs
	sta	RALryofs
	sta	RALrzofs
	a8

	jsr	RS_setmotioncounter

	s_set_objtobealvar	y,x,al_ptr

	lda.w	al_HP,y
	bne	.notdead
	s_init_anim	x,#0
	s_set_state	x,#0

	s_set_alvar	B,x,al_childrotx,#0
	s_set_alvar	B,x,al_childrotz,#0
	s_set_alvar	B,x,al_childroty,#0

	s_end_strat


.notdead

;jump siteirutoki

	lda	al_stratstate,x
	sta	tpx

	phx

	ldx	#0

.loop	lda.l	RBlegprostab,x
	cmp	#0ffH
	beq	.set
	cmp	tpx
	beq	.set

	inx
	inx
	inx

	bra	.loop


.set	lda.l	RBlegprostab+1,x
	sta	x1+0
	lda.l	RBlegprostab+2,x
	sta	x1+1

	plx

	jmp	(x1)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;---------------------------------------------------------------------------------------------------
RS_walkLRrot
	s_push_obj	y
	s_push_obj	x

	s_set_objtobealvar	y,x,al_ptr

	s_jmp_ifstate 	x,m_walkL2,.wL2_0
	s_jmp_ifstate 	x,m_walkR2,.wR2_0
	s_jmp_ifstate 	x,m_walkL,.wL_0
	s_jmp_ifstate 	x,m_walkR,.wR_0

;-----------------------------------------------------------------------------

.wR_0	testjoypad	right,pcont
	rlbeq		.wLR_0000
	jmp_ifleftfoot	x,.RRR
	bra		.LLL
.wL_0	testjoypad	left,pcont
	rlbeq		.wLR_0000
	jmp_ifrightfoot	x,.RRR
	bra		.LLL

.LLL
	pl_get_shapeTAB	W,y,x1,RS_WLrotx_L_tab
	bra	.readlrrot

.RRR
	pl_get_shapeTAB	W,y,x1,RS_WLrotx_R_tab
	bra	.readlrrot

;-----------------------------------------------------------------------------
.wR2_0	jmp_ifleftfoot		x,.RRR2
	bra			.LLL2
.wL2_0	jmp_ifrightfoot		x,.RRR2
	bra			.LLL2

.LLL2	pl_get_shapeTAB	W,y,x1,RS_WL2rotx_L_tab
	bra	.readlrrot

.RRR2	pl_get_shapeTAB	W,y,x1,RS_WL2rotx_R_tab

.readlrrot

	a16
	lda.w	al_sbyte4,x
	and	#15
	clc
	adc	x1
	tax
	a8

	lda.l	RS_walkLRrottab&0ff0000H,x
	sta	x1
	lda.l	RS_walkLRrottab&0ff0000H+10H,x
	sta	y1
	lda.l	RS_walkLRrottab&0ff0000H+20H,x
	sta	z1
	bra	.LLLRRR

;-----------------------------------------------------------------------------
.wLR_0000	stz	x1
	stz	y1
	stz	z1
;-----------------------------------------------------------------------------
.LLLRRR
	s_pull_obj	x
	s_pull_obj	y

	s_jmp_IFstate 	x,m_walkL2,.wl2
	s_jmp_IFstate 	x,m_walkL,.wl2
	s_neg_var	B,y1
	s_neg_var	B,z1

.wr2
.wl2
	s_achase_alvar	B,x,al_childrotx,x1,1
	s_achase_alvar	B,x,al_childroty,y1,2
	s_achase_alvar	B,x,al_childrotz,z1,2

	jmp	RS_end_ALLstate

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_turnrot	s_set_objtobealvar	y,x,al_ptr

	toheap	y,y

	s_set_var		B,RALrzofs,#0
	s_achase_alvar		B,x,al_childrotx,#0,1
	s_achase_alvar		B,x,al_childrotz,#0,1

	s_cmp_anim	x,#0
	beq		.tr0


	s_achase_alvar2alvar	B,x,al_childroty,y,exal_rotyoffset+1,1


.tr0
	s_copy_alvar2var	B,y,y1,exal_acclroty

	lda	al_childroty,x
	sec
	sbc	y1

; al_childroty no limitter

	bpl	.plsb

.misb	cmp	#-legrotyofsmax	; max value
	bcs	.exitsb

	lda	#-legrotyofsmax
	bra	.sb

.plsb	cmp	#legrotyofsmax	; max value
	bcc	.exitsb

	lda	#legrotyofsmax
.sb
.exitsb	sta	al_childroty,x

	jmp	RS_end_ALLstate

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_thrashturnLrot
RS_thrashturnRrot

	jsr	RS_setthrashrot
	jmp	RS_walkrot_s

RS_thrashLrot
RS_thrashRrot

	lda	#-3
	sta	RALrzofs
	jmp	RS_walkrot_s

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_setTFrot	; thrash F no offset

	s_set_objtobealvar	y,x,al_ptr
	jsr			RS_setthrashrot
	s_add_var		B,RALrxofs,#40
	jmp			RS_walkrot_s

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_setTBrot	; thrash B no offset

	s_set_objtobealvar	y,x,al_ptr
	jsr			RS_setthrashrot
	s_add_var		B,RALrxofs,#-30
	jmp			RS_walkrot_s

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_setWbrakerot

	lda	#-5
	sta	RALrzofs
	jmp	RS_walkrot

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; walk start

RS_setWBstartrot
	
	jmp_ifrightfoot	x,.swbs0
	lda		#0
	bra		RS_setWFstartrot.swfs1
.swbs0	lda		#10
	bra		RS_setWFstartrot.swfs1

RS_setWFstartrot
	
	jmp_ifleftfoot	x,.swfs0
	lda		#0
	bra		.swfs1
.swfs0	LOCAL
	lda		#-10
.swfs1	LOCAL
	sta		RALrxofs
	s_set_var	B,RALryofs,#0
	s_set_var	B,RALrzofs,#0

	jmp	RS_walkrot

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_setWBrot
	s_push_obj	x
	a16
	lda	al_sbyte4,x
	and	#15
	tax
	a8

	lda.l	RSTAB_WBroty,x
	sta	RALryofs
	lda	#0
	sta	RALrxofs
	sta	RALrzofs
	s_pull_obj	x

	jmp	RS_walkrot

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_setWF2rot

	IFEQ	1

	jsr	RS_setwalkrot

	s_set_objtobealvar	y,x,al_ptr


;	PHX
;	a16
;	lda	al_sbyte4,x
;	and	#15
;	tax
;	a8
;	lda.l	RSTAB_WBroty,x
;	PLX
;	sta	RALryofs


	pl_jmp_LASTLRkey	y,.swf2_1,.swf2_0,.swf2_4

.swf2_0	lda	#14
	bra	.swf2_2
.swf2_1	lda	#-14
.swf2_2	sta	z1
	jmp_ifrightfoot	x,.swf2_3
	s_neg_var	B,z1
.swf2_3	s_add_var	B,RALrzofs,z1

.swf2_4	jmp		RS_walkrot

	ENDC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_setWFrot
	jsr	RS_setwalkrot



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_walkrot_s

	s_achase_alvar		B,x,al_childroty,RALryofs,3
	s_achase_alvar		B,x,al_childrotz,RALrzofs,3
	s_achase_alvar		B,x,al_childrotx,RALrxofs,3

	bra	RS_end_ALLstate
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_walkrot
	jmp_ifrightfoot		x,.no_negry
	s_neg_var		B,RALryofs
	s_neg_var		B,RALrzofs
.no_negry	s_set_objtobealvar	y,x,al_ptr

; walk Foward with left right

.wradd1	s_achase_alvar		B,x,al_childroty,RALryofs,1

.wradd2	s_achase_alvar		B,x,al_childrotz,RALrzofs,1	;3

.wradd3	s_achase_alvar		B,x,al_childrotx,RALrxofs,1	;3

.end_setWFrot
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

RS_end_ALLstate

;	jsr		RBleg_clamp_srou

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; Ryu-sa ni hamatta tokino syori...

	s_set_objtobealvar	y,x,al_ptr

	pl_jmpnot_ASHIinpool	y,.notinsand,sand

	s_set_alvar	B,x,al_childrotx,#0
	s_set_alvar	B,x,al_childrotz,#0

.notinsand
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	s_end_strat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_setwalkrot

	s_push_obj	x
	a16
	lda	al_sbyte4,x
	and	#15
	tax
	a8

	lda	#0
	sta	RALryofs
	lda.l	RSTAB_WFrotxFF,x
	sta	RALrxofs
	lda.l	RSTAB_WFrotzFF,x
	sta	RALrzofs

	s_pull_obj	x

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RS_setthrashrot

	s_jmp_andframe	#4,.stfrD
.stfrU	lda		#-50
	bra		.stfrUD
.stfrD	lda		#50
.stfrUD	sta		tpx
	jmp_ifrightfoot	x,.stfrLR
	s_neg_var	B,tpx
.stfrLR	s_add_var	B,RALrxofs,tpx
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


RS_walkLRrottab


RS_WLrotx_L_tab	dw	RS_WLrotx_L&WM
		dw	RS_WLrotx_L&WM
		dw	RS_WLrotx_L&WM

RS_WLrotx_R_tab	dw	RS_WLrotx_R&WM
		dw	RS_WLrotx_R&WM
		dw	RS_WLrotx_R&WM

RS_WL2rotx_L_tab	dw	RS_WL2rotx_L&WM
		dw	RS_WL2rotx_L&WM
		dw	RS_WL2rotx_L&WM

RS_WL2rotx_R_tab	dw	RS_WL2rotx_R&WM
		dw	RS_WL2rotx_R&WM
		dw	RS_WL2rotx_R&WM


;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5

;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
;RS_WLrotx_R_SP
;RS_WLroty_R_SP
;RS_WLrotz_R_SP
;RS_WLrotx_L_SP
;RS_WLroty_L_SP
;	byte16	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
;RS_WLrotz_L_SP
	byte16	00,00,00,00,00,00,00,00,00,40,20,10,00,00,00,00



;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
;RS_WLrotx_L	byte16	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
;RS_WLroty_L	byte16	00,00,00,00,00,00,00,00,00,00,50,00,00,00,00,00
;RS_WLrotz_L	byte16	00,00,00,00,00,00,00,00,00,00,25,00,00,00,00,00
;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
;RS_WLrotx_R	byte16	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
;RS_WLroty_R	byte16	00,00,00,00,00,00,00,00,00,00,-40,00,00,00,00,00
;RS_WLrotz_R	byte16	20,00,00,00,00,00,00,00,00,00,05,00,00,00,00,00




;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
RS_WLrotx_L	byte16	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
RS_WLroty_L	byte16	00,00,00,00,00,00,00,00,45,45,45,45,45,45,45,45
RS_WLrotz_L	byte16	20,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
RS_WLrotx_R	byte16	10,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
RS_WLroty_R	byte16	00,00,00,00,00,00,00,00,30,00,40,40,40,40,40,40
RS_WLrotz_R	byte16	25,25,25,25,25,25,25,25,00,00,-40,-40,-40,-40,-40,-40

;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
RS_WL2rotx_L	byte16	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
RS_WL2roty_L	byte16	00,00,00,00,00,00,00,00,00,00,40,00,00,00,00,00
RS_WL2rotz_L	byte16	40,20,20,20,20,20,20,20,20,20,-20,20,20,20,20,20

;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
RS_WL2rotx_R	byte16	10,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
RS_WL2roty_R	byte16	00,00,00,00,00,00,00,00,30,00,-8,40,40,40,40,40
RS_WL2rotz_R	byte16	25,25,25,25,25,25,25,25,00,00,-40,-40,-40,-40,-40,-40

;;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
;RS_WLrotx_L	byte16	00,00,00,00,00,00,00,00,00,00,-10,00,00,00,00,00
;RS_WLroty_L	byte16	00,00,00,00,00,00,00,00,45,45,45,45,45,45,45,45
;RS_WLrotz_L	byte16	20,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
;
;;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
;RS_WLrotx_R	byte16	10,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
;RS_WLroty_R	byte16	00,00,00,00,00,00,00,00,30,00,40,40,40,40,40,40
;RS_WLrotz_R	byte16	25,25,25,25,25,25,25,25,00,00,-40,-40,-40,-40,-40,-40
;
;;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
;RS_WL2rotx_L	byte16	00,00,00,00,00,00,00,00,00,00,-10,00,00,00,00,00
;RS_WL2roty_L	byte16	00,00,00,00,00,00,00,00,00,00,40,00,00,00,00,00
;RS_WL2rotz_L	byte16	40,20,20,20,20,20,20,20,20,20,-20,20,20,20,20,20
;
;;		0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
;RS_WL2rotx_R	byte16	10,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
;RS_WL2roty_R	byte16	00,00,00,00,00,00,00,00,30,00,-8,40,40,40,40,40
;RS_WL2rotz_R	byte16	25,25,25,25,25,25,25,25,00,00,-40,-40,-40,-40,-40,-40



RS_srou

;--------------------------------------------------------------------------------------------------
.brakeBrot	LOCAL
	s_set_objtobealvar	y,x,al_ptr

	jsr			.copyalrot2var
	jmp_ifrightfoot		x,.brakeBR

.brakeBL	LOCAL

	s_add_var	B,x1,#3
	s_add_var	B,y1,#0
	s_add_var	B,z1,#0
	bra		.brakeachase

.brakeBR	LOCAL
	s_add_var	B,x1,#3
	s_add_var	B,y1,#0
	s_add_var	B,z1,#0

.brakeachase	LOCAL

	s_achase_alvar	B,x,al_childrotx,x1,3
	s_achase_alvar	B,x,al_childroty,y1,3
	s_achase_alvar	B,x,al_childrotz,z1,3

.exitbrakeBrot

	rts

;--------------------------------------------------------------------------------------------------
.copyalrot2var	LOCAL

	s_copy_alvar2var	B,y,x1,al_rotx
	s_copy_alvar2var	B,y,y1,al_roty
	s_copy_alvar2var	B,y,z1,al_rotz

	rts

;--------------------------------------------------------------------------------------------------
.YZofs	LOCAL
;	FF,SP & GG de Y offset, Z offset no atai wo tyousei suru.
;	in	idY:player pointer

	pl_lda_PILOTNoFSG	y	;Y player's pointer
	cmp	#ep_FF
	beq	.FFYZofs
	cmp	#ep_SP
	beq	.SPYZofs
	cmp	#ep_GG
	beq	.GGYZofs
	bra	.exitYZofs

.FFYZofs	bra	.exitYZofs	;no pros.
.SPYZofs	;bra	.exitYZofs
.GGYZofs	lda	y1
	asra
	sta	y1
	lda	z1
	asra
	sta	z1
.exitYZofs	rts

;--------------------------------------------------------------------------------------------------

RS_setmotioncounter

	lda	al_stratstate,x		; state ga kawatta?
	cmp	alQ_statebak,x
	beq	.incmotioncounter

	sta	alQ_statebak,x
	lda	#0			; counter initial
	sta	alQ_motioncounter,x

.incmotioncounter

	lda	alQ_motioncounter,x
	inc	a
	beq	.noincmotioncounter
	sta	alQ_motioncounter,x

.noincmotioncounter

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;data table
RBlegprostab
	db	m_stop
	dw	RS_walkrot&WM
	db	m_walkFstart
	dw	RS_setWFstartrot&WM
	db	m_walkBstart
	dw	RS_setWBstartrot&WM
	db	m_walkF2
	dw	RS_setWF2rot&WM
	db	m_walkB2
	dw	RS_setWBrot&WM
	db	m_walkF1
	dw	RS_setWFrot&WM
	db	m_walkB1
	dw	RS_setWBrot&WM
	db	m_brakeF
	dw	RS_setWbrakerot&WM
	db	m_walkF
	dw	RS_setWFrot&WM
	db	m_walkB
	dw	RS_setWFrot&WM
	db	m_thrashF
	dw	RS_setTFrot&WM
	db	m_thrashB
	dw	RS_setTBrot&WM
	db	m_turnL
	dw	RS_turnrot&WM
	db	m_turnR
	dw	RS_turnrot&WM
	db	m_walkL
	dw	RS_walkLRrot&WM
	db	m_walkR
	dw	RS_walkLRrot&WM
	db	m_walkL2
	dw	RS_walkLRrot&WM
	db	m_walkR2
	dw	RS_walkLRrot&WM
	db	m_thrashL
	dw	RS_thrashLrot&WM
	db	m_thrashR
	dw	RS_thrashRrot&WM
	db	m_thrashturnL
	dw	RS_thrashturnLrot&WM
	db	m_thrashturnR
	dw	RS_thrashturnRrot&WM
	db	m_brakeB
	dw	RS_srou.brakeBrot&WM
	db	255
	dw	RS_end_ALLstate&WM

;--------------------------------------------------------------------------------------------------

RSTAB_wFrotzGG	;0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
	byte16	0,2,4,5,4,2,0,-1,-2,-3,-4,-6,-8,-10,-8,-5

RSTAB_wFrotzFF	;0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
	byte16	00,00,00,00,00,00,00,00,-5,-5,-5,-5,-5,-5,-5,-5

RSTAB_wFrotyGG	;0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
	byte16	06,08,10,10,10,10,10,10,08,06,04,02,00,00,02,04

RSTAB_wBroty		;0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
	byte16	-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10

RSTAB_wFrotxFF	;0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
	byte16	00,00,00,00,20,20,20,20,00,00,00,00,00,-35,-35,-35
;	byte16	00,00,00,00,10,10,10,10,00,00,00,00,00,-15,-15,-15

RSTAB_tFrotx		;0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
	byte16	40,40,40,40,40,40,40,40,40,40,40,40,40,40,50,60

;---------------------------------------------------------------------------------



	IFEQ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºAshi ga shape ni notte irutokino syoriº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
RBleg_clamp_srou
rcs_z	equ	work9
rcs_y	equ	work8
rcs_x	equ	work7
rcs_py	equ	work6	;player's height
rcl_slopenum	equ	work5	;closestslopenum
	s_start_strat
	rts
	PUSHXYP
	a8i16
	sm_jmp_if1screen	.do
.nopros	PULLXYP
	rts
.do
;-----------------------------------------------------------------------------
	s_set_objtobealvar	y,x,al_ptr
;-----------------------------------------------------------------------------
; get height & clamp
	jsl		getheight_l
	s_copy_var2var	W,rcl_slopenum,closestslopenum
	s_set_var	W,rcs_y,y1
	jsl		clamptoside_l
	s_set_var	W,rcs_x,x1
	s_set_var	W,rcs_z,z1
;-----------------------------------------------------------------------------
; store height
	s_push_obj	y
	s_push_obj	x
	ldx		al_sword2,y
	txy
	s_pull_obj	x
	jmp_ifrightfoot	x,.rh
.lh	s_set_alvar	W,y,exal_legLheight,rcs_y
	bra		.lr
.rh	s_set_alvar	W,y,exal_legRheight,rcs_y
.lr	s_varsub_alvar	W,y,rcs_y,exal_getheight_WY
	s_pull_obj	y
;-----------------------------------------------------------------------------
; wall or slope?
	a16
	lda		rcs_y
	sec
	sbc		rcs_py
	bpl		.pl
	nega
.pl	cmp		#30H
	a8
	bpl		.wall
.slope	s_set_var	W,rcs_x,#0
	s_set_var	W,rcs_z,#0
	bra		.done_ws
.wall	s_set_var	W,rcs_y,#0
.done_ws
;-----------------------------------------------------------------------------
; jump shiteitara nanimo shinai.
	pl_jmpnot_ifjmp	y,.nojump
	s_set_var	W,rcs_x,#0
	s_set_var	W,rcs_y,#0
	s_set_var	W,rcs_z,#0
.nojump
;-----------------------------------------------------------------------------
; body to onaji slope dattara clamp shinai.
	PHY
	PHX
	a16
	ldx	al_sword2,y
	txy
	PLX
	jmp_ifrightfoot	x,.sR
.sL	lda	rcl_slopenum
	sta	exal_slopenumL,y
	lda	exal_slopenumR,y
	bra	.ss
.sR	lda	rcl_slopenum
	sta	exal_slopenumR,y
	lda	exal_slopenumL,y
.ss	PLY
	cmp	rcl_slopenum
	a8
	bne	.doclamp
	a16
	lda.w	al_slopeptr,y
	cmp	al_slopeptr,x
	a8
	bne	.doclamp
	s_set_var	W,rcs_x,#0
	s_set_var	W,rcs_z,#0
.doclamp
;-----------------------------------------------------------------------------
; body ga shape ni notte itara clamp ha 0
	rb_jmpnot_ifonshape	y,.notonshape
	s_set_var	W,rcs_x,#0
	s_set_var	W,rcs_z,#0
.notonshape
.exit	PULLXYP
;  limitter of Y offset
	a16
	lda		rcs_y
	bmi		.miy
.ply	cmp		#30
	bcc		.yy
	lda		#30
	bra		.setyy
.miy	cmp		#-30
	bcs		.yy
	lda		#-30
.setyy	sta		rcs_y
.yy	a8
	s_add_alvar		W,x,al_childx,rcs_x
	s_add_alvar		W,x,al_childy,rcs_y
	s_add_alvar		W,x,al_childz,rcs_z
	ldy			al_ptr,x
	a16
	lda			rcs_x
	adiv2
	clc
	adc.w			al_mx,y
	sta.w			al_mx,y
	lda			rcs_z
	adiv2
	clc
	adc.w			al_mz,y
	sta.w			al_mz,y
	a8
	rts
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ROBOANIM_srou
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;using		al_sbyte1	as state
;		sflag5 (up,down to left,right no douji oshi de set suru)

robospeed		equ	work9+1
robospeedFAST	equ	work9+0
robospeedLR		equ	work8+1
robospeedthrash	equ	work8+0
robospeedthrashFAST	equ	work7+1

value_headshakeFF	equ	20
value_headshakeSP	equ	-15
value_headshakeGG	equ	-15
value_LRheadshake0FF	equ	20
value_LRheadshake1FF	equ	-10
value_LRheadshake0SP	equ	10
value_LRheadshake1SP	equ	-20
value_LRheadshake0GG	equ	-6
value_LRheadshake1GG	equ	2


value_headrotzofs	equ	15

legflag_changeflag	equ	1<<0	;work5 (in .animdriver)
legflag_resetflag	equ	1<<2	;work5 (in .animdriver)
motinNo_setflag	equ	1<<1	;work5 (in .animdriver)

; 2kaioshi no hajimaru counter no atai

animdush_num		equ	7	;(max7)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
.setmotionANDvel	LOCAL

	PUSHXYP

	a8i16

	toheap	y,x

	lda		#0
	sta		al_sbyte3,x

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³WARNING! VIEW wo kirikae siterutoki wa motion wa stop ni set suru...³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	s_jmp_alvarAND	B,y,exal_VIEWflag,#exal_VIEWflag_RBtrigX,.NOUPDOWN

; set roty offset

	jsr	.setlegrotyoffset	;(slyo)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; set dush flag
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºClear dushflagº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

	s_and_alvar	B,y,exal_motiondir,#RB_dush^-1

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º dush counter º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

; 2times dush no tameno counter wo inc suru...


; check dush counter

	lda		exal_animdush,y
	and		#exal_animdush_Cmask
	cmp		#animdush_num<<4
	bcs		.noincadc

; check dir

	lda		ptrig+1
	and		#(pad_up!pad_down!pad_left!pad_right)>>8
	and		exal_animdush,y
	beq		.noincadc
	s_or_alvar	B,y,exal_animdush,#exal_animdush_dush

.noincadc




; store old trig

	lda	ptrig+1
	and	#(pad_up!pad_down!pad_left!pad_right)>>8
	beq	.nooldtrig
	pha

	s_and_alvar	B,y,exal_animdush,#(exal_animdush_Kmask)^-1

	pla
	ora	exal_animdush,y
	sta	exal_animdush,y

.nooldtrig


;ÉÍÍÍÍÍÍÍ»
;ºY dush?º
;ÈÍÍÍÍÍÍÍ¼
	s_jmp_alvarAND	B,y,exal_animdush,#exal_animdush_dush,.dodush


	a16
	lda	pcont
	bit	#pad_dush!pad_dush2
	a8
	bne	.dodush

;ÉÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºDUSH counterº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍ¼
.dushcount
	lda	exal_dushcounter,y
	cmp	#dushkey_time
	bne	.nodush

.dodush	s_or_alvar	B,y,exal_motiondir,#RB_dush

.nodush

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; set animation pointer
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºClear motiondirº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

	s_and_alvar	B,y,exal_motiondir,#RBdir_mask^-1

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºUP wo oshitatokiº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

.up	testjoypad	up,pcont
	rlbeq		.dw

	jsr		.setlegrotyoffset	;(slyo)

	s_jmp_alsflag	x,ontheground,.groundU

;pool=gd	pl_jmp_KAOinpool	x,.thrashF,water
	pl_jmp_ifinthesea	x,.thrashF

;ÚÄÄÄÄÄÄ¿
;³ground³
;ÀÄÄÄÄÄÄÙ

.groundU

	pl_get_pilotTAB	W,x,x3,RBwalkF2_tab

	pl_jmpnot_ifdush	x,.Unormal

	s_set_alvar	W,y,exal_animptrNEXT,x3
	pl_get_pilottab	B,x,x1,robospeedFAST_tab

	bra		.Ufchase

.Unormal

	pl_get_pilotTAB_ST	W,x,x1,RBwalkFstart_tab
	pgpt_C			 W,x,x2,RBwalkF1_tab
	pgpt_END		W,x,x3,RBwalkF2_tab

	jsr		.check2dush
	jsr		.setanimptrfastnext
	pl_get_pilottab	B,x,x1,robospeed_tab

.Ufchase

	jsr		.Fchase_vel
	s_or_alvar	B,y,exal_motiondir,#RB_F

.upEX	jmp		.ud



;ÚÄÄÄÄÄÄÄÄÄÄ¿
;³in the sea³
;ÀÄÄÄÄÄÄÄÄÄÄÙ

.thrashF
	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBthrashF&WM
	s_or_alvar	B,y,exal_motiondir,#RB_F
	s_set_alvar	B,y,exal_motionNo,#m_thrashF
	jmp		.thrashFBspeed

;-----------------------------------------------------------------------------------
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºDOWN wo oshitatokiº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
.dw

	testjoypad	down,pcont
	rlbeq		.NOUPDOWN

	jsr		.setlegrotyoffset	;(slyo)

	s_jmp_alsflag	x,ontheground,.groundD

;;;;;	pl_jmp_KAOinpool	x,.thrashB
	pl_jmp_ifinthesea	x,.thrashB

;ÚÄÄÄÄÄÄ¿
;³ground³
;ÀÄÄÄÄÄÄÙ
.groundD
	pl_get_pilotTAB	W,x,x3,RBwalkB2_tab

	pl_jmpnot_ifdush	x,.Dnormal

	s_set_alvar	W,y,exal_animptrNEXT,x3
	pl_get_pilottab	B,x,x1,robospeedFAST_tab
	bra		.Dfchase
.Dnormal
	pl_get_pilotTAB_ST	W,x,x1,RBwalkBstart_tab
	pgpt_C			 W,x,x2,RBwalkB1_tab
	pgpt_END		W,x,x3,RBwalkB2_tab
	jsr		.setanimptrfastnext
	pl_get_pilottab	B,x,x1,robospeed_tab

.Dfchase
	jsr		.Fchase_vel

	s_or_alvar	B,y,exal_motiondir,#RB_B

.dwEX	jmp		.ud


;ÚÄÄÄÄÄÄÄÄÄÄ¿
;³in the sea³
;ÀÄÄÄÄÄÄÄÄÄÄÙ

.thrashB	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBthrashB&WM
	s_or_alvar	B,y,exal_motiondir,#RB_B
	s_set_alvar	B,y,exal_motionNo,#m_thrashB

;-----------------------------------------------------------------------------
.thrashFBspeed

	;(HERE!)s_jmp_alvarZERO		B,y,exal_jmpstatus,.tFBn
	pl_get_pilottab	B,x,x1,robospeedthrashFAST_tab
	;(HERE!)bra		.tFBn2
.tFBn	;(HERE!)pl_get_pilottab	B,x,x1,robospeedthrash_tab
.tFBn2	jsr		.Fchase_vel
	jmp		.ud

;-----------------------------------------------------------------------------
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºUP mo DOWN mo oshitenaitokiº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

; (up down)+(left right) no toki no legs no rotyoffset wo 0 ni suru

.NOUPDOWN
;	s_set_alvar	B,y,exal_jetroty,#0

	testjoypad	left,pcont
	bne		.noUDpushlr
	testjoypad	right,pcont
	bne		.noUDpushlr

	s_achase_alvar	B,x,al_sbyte2,#0,2

	s_set_var	B,x1,#0
	jsr		.Fchase_vel
.noUDpushlr
;-----------------------------------------------------------------------------------
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºLEFT ka RIGHT wo oshitatokiº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
.L
	testjoypad	left,pcont
	rlbeq	.R

	pl_get_pilottab	B,x,x1,robospeedLR_tab

	s_jmp_alsflag	x,ontheground,.Lg

;;;;;	pl_jmp_KAOinpool	x,.thrashL,water
	pl_jmp_ifinthesea	x,.thrashL
;ÚÄÄÄÄÄÄ¿
;³ground³
;ÀÄÄÄÄÄÄÙ

.Lg
	pl_get_pilotTAB	W,x,x3,RBwalkL2_tab

	pl_jmpnot_ifdush	x,.Ln

	s_set_alvar	W,y,exal_animptrNEXT,x3
	pl_get_pilottab	B,x,x1,robospeedLRFAST_tab
	bra		.Lfchase
.Ln
	pl_get_pilotTAB_ST	W,x,x1,RBwalkLstart_tab
	pgpt_C		 	 W,x,x2,RBwalkL1_tab
	pgpt_END		W,x,x3,RBwalkL2_tab

	jsr		.setanimptrfastnext
	pl_get_pilottab	B,x,x1,robospeedLR_tab

.Lfchase	;pl_get_pilottab	B,x,x2,robospeedLRaccl_tab
	jsr		.Fchase_vel

	s_jmp_alvarEQ	B,y,exal_motionNo,#m_brakeF,.ud

	s_or_alvar	B,y,exal_motiondir,#RB_L

	jmp		.ud




;ÚÄÄÄÄÄÄÄÄÄÄ¿
;³in the sea³
;ÀÄÄÄÄÄÄÄÄÄÄÙ

.thrashL	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBthrashL&WM
	s_or_alvar	B,y,exal_motiondir,#RB_L
	s_set_alvar	B,y,exal_motionNo,#m_thrashL
	jmp		.thrashLRspeed


.R	testjoypad	right,pcont
	rlbeq	.LR

	pl_get_pilottab	B,x,x1,robospeedLR_tab

	s_jmp_alsflag	x,ontheground,.Rg

;;;;;	pl_jmp_KAOinpool	x,.thrashR,water
	pl_jmp_ifinthesea	x,.thrashR

;ÚÄÄÄÄÄÄ¿
;³ground³
;ÀÄÄÄÄÄÄÙ

.Rg
	pl_get_pilotTAB		W,x,x3,RBwalkR2_tab

	pl_jmpnot_ifdush	x,.Rn

	s_set_alvar	W,y,exal_animptrNEXT,x3
	pl_get_pilottab	B,x,x1,robospeedLRFAST_tab
	bra		.Rfchase
.Rn
	pl_get_pilotTAB_ST	W,x,x1,RBwalkRstart_tab
	pgpt_C			W,x,x2,RBwalkR1_tab
	pgpt_END		W,x,x3,RBwalkR2_tab
	jsr		.setanimptrfastnext
	pl_get_pilottab	B,x,x1,robospeedLR_tab

.Rfchase	;pl_get_pilottab	B,x,x2,robospeedLRaccl_tab
	jsr		.Fchase_vel

	s_jmp_alvarEQ	B,y,exal_motionNo,#m_brakeF,.ud

	s_or_alvar	B,y,exal_motiondir,#RB_R

;.REX
;	ldy		al_sword2,x
;	s_set_alvar	B,y,exal_jetroty,#-64
	jmp		.ud

;ÚÄÄÄÄÄÄÄÄÄÄ¿
;³in the sea³
;ÀÄÄÄÄÄÄÄÄÄÄÙ

.thrashR	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBthrashR&WM
	s_or_alvar	B,y,exal_motiondir,#RB_R
	s_set_alvar	B,y,exal_motionNo,#m_thrashR

;-----------------------------------------------------------------------------------
.thrashLRspeed

	;(HERE!)s_jmp_alvarZERO	B,y,exal_jmpstatus,.tLRn
	pl_get_pilottab	B,x,x1,robospeedthrashFAST_tab
	;bra		.tLRn2
.tLRn	;pl_get_pilottab	B,x,x1,robospeedthrash_tab
.tLRn2	jsr		.Fchase_vel
	jmp		.ud

;-----------------------------------------------------------------------------------
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºtLEFT ka tRIGHT wo oshitatokiº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

.LR	pl_jmp_LASTLRkey	x,.tL,.tR,.noLR,y

.tL	s_jmp_alsflag		x,ontheground,.tLg
	pl_jmp_KAOinpool	x,.thrashtL,water
	pl_jmp_ifinthesea	x,.thrashtL
;ÚÄÄÄÄÄÄ¿
;³ground³
;ÀÄÄÄÄÄÄÙ
.tLg	pl_get_pilotTAB	W,x,x1,RBturnL_tab
	s_set_alvar	W,y,exal_animptrNEXT,x1

	jmp		.ud
;ÚÄÄÄÄÄÄÄÄÄÄ¿
;³in the sea³
;ÀÄÄÄÄÄÄÄÄÄÄÙ
.thrashtL	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBthrashturnL&WM
	jmp		.ud

.tR	s_jmp_alsflag		x,ontheground,.tRg
	pl_jmp_KAOinpool	x,.thrashtR,water
	pl_jmp_ifinthesea	x,.thrashtR
;ÚÄÄÄÄÄÄ¿
;³ground³
;ÀÄÄÄÄÄÄÙ
.tRg
	pl_get_pilotTAB	W,x,x1,RBturnR_tab
	s_set_alvar	W,y,exal_animptrNEXT,x1

	jmp		.ud
;ÚÄÄÄÄÄÄÄÄÄÄ¿
;³in the sea³
;ÀÄÄÄÄÄÄÄÄÄÄÙ
.thrashtR	s_set_alvar	W,y,exal_animptrNEXT,#abt_RBthrashturnR&WM
	jmp	.ud


.noLR

;-----------------------------------------------------------------------------------
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºJUMP shitatokiº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
.JUMP
;-----------------------------------------------------------------------------------
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºSTOP shitatokiº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
;NO KEY
.stop
	s_or_alvar	B,y,exal_motiondir,#RB_S


;------------
	pl_jmp_KAOinpool	x,.stopswim,water
	pl_jmpnot_ifinthesea	x,.dostop
.stopswim	s_set_alvar		B,y,exal_motionNo,#m_stop
;------------

.dostop	lda		exal_motionNo,y
	cmp		#m_stop
	beq		.dostop1
	cmp		#m_turnL
	beq		.dostop1
	cmp		#m_turnR
	bne		.dostop2

.dostop1	;s_set_speed	x,#0

.dostop2
	s_jmp_alvarEQ	W,y,exal_animptr,#abt_RBstopping&WM,.incdc	;.ud


	testjoypad	swim,pcont	;B,pcont
	rlbeq		.startstop
	s_jmp_alvarEQ	W,y,exal_animptrNEXT,#abt_RBswimming&WM,.incdc	;.ud
	bra		.startstop

.startstop
	s_set_alvar	W,y,exal_animptrNEXT,#0	;abt_RBstop&WM

;-----------------------------------------------------------------------------
.incdc

; 2times dush no tameno counter wo inc suru...

	ldy		al_sword2,x

	s_jmp_ANDframe	#1,.noincdc

	lda		exal_animdush,y
	and		#exal_animdush_Cmask!exal_animdush_Kmask
	cmp		#exal_animdush_Cmask
	bcs		.noincdc
	clc
	adc		#10H
	sta		exal_animdush,y

.noincdc	bra		.noclrdc

;-----------------------------------------------------------------------------

.ud

;-----------------------------------------------------------------------------
; 2times dush no tameno counter wo clear suru...

	ldy		al_sword2,x

	s_jmp_alvarAND	B,y,exal_animdush,#exal_animdush_dush,.noclrdc
	s_and_alvar	B,y,exal_animdush,#(exal_animdush_dush!exal_animdush_Cmask)^-1

.noclrdc

;-----------------------------------------------------------------------------
; ryu-sa ni haitta toki no syori...

	ldy		al_sword2,x

	s_jmp_alvarZERO	W,x,al_slopeptr,.notinryusa

	PHY
	a16
	ldy	al_slopeptr,x
	lda.w	al_shape,y
	PLY
	cmp	#on_d
	a8
	bne	.notinryusa


.veldiv	lda		exal_vel,y
	asra
;	sta		tpx
;	asra
;	asra
;	clc
;	adc		tpx
	sta		exal_vel,y
	bra		.notinryusa


.jmpp	pl_jmpnot_ASHIinpool	x,.notinryusa,sand
	pl_jmpnot_KAOinpool	x,.rvashi,sand

.rvkao	lda		exal_vel,y
	asra
	bra		.rv0
.rvashi	lda		exal_vel,y
.rv0	asra
	sta		exal_vel,y

.notinryusa
;----------------------------------------------------------------------------------


	PULLXYP

	rts

;-----------------------------------------------------------------------------------
.setanimptrfastnext
	s_start_strat

	a16
	lda		exal_animptrNEXT,y
	cmp		x3	;#abt_RBwalkF2&WM
	beq		.aptnext1
	cmp		x2	;#abt_RBwalkF1&WM
	beq		.aptfnexit
	cmp		x1	;#abt_RBwalkstart&WM
	beq		.aptnext1
	lda		x1	;#abt_RBwalkstart&WM
	bra		.aptfnsta
.aptnext1	lda		x2	;#abt_RBwalkF1&WM
.aptfnsta	sta		exal_animptrNEXT,y
.aptfnexit	a8

	rts

;-----------------------------------------------------------------------------------
.check2dush	; 2 kai oshi no dush wo check suru.

	lda	ptrig+1
	bit	#(pad_left!pad_right!pad_up!pad_down)>>8
	beq	.no2dush
	a16

	lda	exal_animptrBEFORE,y
	cmp	x2
	bne	.no2dush

	a8

	s_copy_var2var	W,x2,x3

.no2dush	a8
	rts

;-----------------------------------------------------------------------------------
.setlegrotyoffset	;(slyo)

;	set	:exal_jetroty

; (up down)+(left right) no toki no legs no rotyoffset wo kaesu.

	s_push_obj	y

	toheap	y,x

	s_set_var	B,y1,#0

	lda	pcont+1
	bit	#padl_up!padl_down
	beq	.slyo2
	bit	#padl_left
	beq	.slyo0
	lda	#rotyofspushLR
	bra	.slyo1
.slyo0	and	#padl_right
	beq	.slyo2
	lda	#-rotyofspushLR
.slyo1	sta	y1

	lda	pcont+1
	bit	#padl_down
	beq	.slyo2
	lda	y1
	nega
	sta	y1

.slyo2
	s_achase_alvar	B,y,exal_jetroty,y1,2

	s_pull_obj	y

	rts
;-----------------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	ANIMATION DRIVER
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

.walkanimdriver	LOCAL

	s_start_strat

;using
;	work6			:current animframe
;	work5			:L R change flag
;	work0,work1,work2	:use for temp
;	work3,work4		:temp


; work9	: tmp
; work8	: tmp
; work7	: tmp

	PUSHXYP

	a8i16


	lda	#0		; LR change flag
	sta	work5


	ldy	al_sword2,x
	s_push_obj	y
	s_push_obj	x

; read data

.NORMAL	a16


;RAM clear

	lda	#0
	sta	work0
	sta	work1
	sta	work2
	sta	work3
	sta	work4
	sta	work5
	sta	work6



	lda	exal_animptr,y
	tax

; read LRflag reset code?
; if first data = reset code (253) then set LRresetflag

	lda.l	abt_DATAS&0ff0000H,x	; frame No. or reset code?
	and	#255
	cmp	#253
	bne	.readdata

	lda	work5
	ora	#legflag_resetflag
	sta	work5
	inx

.readdata
	lda.l	abt_DATAS&0ff0000H,x
	lsr	a
	lsr	a
	sta	x1

	inx
	inx

	a8
;--------------------------------------------------------------------

	s_jmpnot_varAND	B,x1+1,#%00000001,.rd0

	lda.l	abt_DATAS&0ff0000H,x	; frame No.(right)
	sta	work0+0			;
	inx
.rd0
	s_jmpnot_varAND	B,x1+0,#%10000000,.rd1
	lda.l	abt_DATAS&0ff0000H,x	; frame No.(left)
	sta	work0+1
	inx
.rd1
;--------------------------------------------------------------------
	s_jmpnot_varAND	B,x1+0,#%01000000,.rd2
	lda.l	abt_DATAS&0ff0000H,x	; Y ofs(right)
	sta	work1+0			;
	inx
.rd2
	s_jmpnot_varAND	B,x1+0,#%00100000,.rd3
	lda.l	abt_DATAS&0ff0000H,x	; Y ofs(left)
	sta	work1+1			;
	inx
.rd3
;--------------------------------------------------------------------
	s_jmpnot_varAND	B,x1+0,#%00010000,.rd4
	lda.l	abt_DATAS&0ff0000H,x	; Z ofs(right)
	sta	work2+0			;
	inx
.rd4
	s_jmpnot_varAND	B,x1+0,#%00001000,.rd5
	lda.l	abt_DATAS&0ff0000H,x	; Z ofs(left)
	sta	work2+1			;
	inx
.rd5
;--------------------------------------------------------------------
	s_jmpnot_varAND	B,x1+0,#%00000100,.rd6
	lda.l	abt_DATAS&0ff0000H,x	; data1
	sta	work3			;
	inx
.rd6
;--------------------------------------------------------------------
	s_jmpnot_varAND	B,x1+0,#%00000010,.rd7
	lda.l	abt_DATAS&0ff0000H,x	; data2
	sta	work4+0			;
	inx
.rd7
	s_jmpnot_varAND	B,x1+0,#%00000001,.rd8
	lda.l	abt_DATAS&0ff0000H,x	; data3
	sta	work4+1			;
	inx
.rd8
;--------------------------------------------------------------------
	a16
	txa
	sta	exal_animptr,y
	a8

	lda.l	abt_DATAS&0ff0000H,x
	cmp	#254		;end code?(not swap L R)
	beq	.code254
	cmp	#255		;end code?
	beq	.code255
	bra	.noreset

.code254	lda	#0	; L R change flag off
	bra	.code000
.code255	lda	#legflag_changeflag	; L R change flag on
.code000	ora	#motinNo_setflag
	ora	work5
	sta	work5


; -- INC MOTION COUNTER  --

	a8

	stx			x1
	s_pull_obj		x
	s_push_obj		x
	rb_inc_motioncounter	x
	ldx			x1

;------------------------------------------------------------------------
; -- reset animpointer --

.reset	a16

	inx
; force
	lda.l	abt_DATAS&0ff0000H+0,x
	bne	.setNEXTptr1

; next ga set sareteiru?

	lda	exal_animptrNEXT,y	;motion --> motion
	bne	.setNEXTptr1

; repeat suru?

	lda.l	abt_DATAS&0ff0000H+4,x	; read repeat ptr
	beq	.setNEXTptr2stop

; repeat flag on?

	lda	exal_animflag,y
	bit	#exal_animflag_repeat	; repeat flag on?
	bne	.setNEXTptr2stop

	ora	#exal_animflag_repeat	; repeat flag on
	sta	exal_animflag,y

	lda.l	abt_DATAS&0ff0000H+4,x	; read repeat ptr
	bra	.setNEXTptr2

.setNEXTptr2stop

	lda.l	abt_DATAS&0ff0000H+2,x	; motion --> stop

.setNEXTptr1	PHA

	lda	exal_animflag,y
	and	#exal_animflag_repeat^-1
	sta	exal_animflag,y

	PLA

.setNEXTptr2	sta	exal_animptr,y
	lda	exal_animptrNEXT,y
	sta	exal_animptrBEFORE,y

.endNEXTptr

;------------------------------------------------------------------------------

	lda	work5
	ora	#legflag_resetflag
	sta	work5

;------------------------------------------------------------------------
.noreset
	a8

; -- SET MOTION No ! --

.chgmotionNo
	lda		work4+1	;exal_motionNoNEXT,y
	cmp		#m_dummy
	beq		.nosetmotionNo
	cmp		#m_max
	bcc		.setmotionNo
	lda		#0
.setmotionNo
	sta		exal_motionNo,y

.nosetmotionNo

;------------------------------------------------------------------------
; -- SET MOTION dir! --
;------------------------------------------------------------------------
	s_pull_obj	x
;------------------------------------------------------------------------

;	s_jmp_alsflag	x,player2,.p2sta
.p1sta
	s_jmpNOT_varAND	B,p1_legflag,#1,.p1staN
	a16

	lda	work0
	xba
	sta	work0
	lda	work1
	xba
	sta	work1
	lda	work2
	xba
	sta	work2
.p1staN
	a8
	lda	work5
	bit	#legflag_changeflag
	bne	.p1eor
	bit	#legflag_resetflag
	bne	.p1clr
	bra	.ppsta
.p1clr	s_and_var	B,p1_legflag,#1^-1
	bra	.ppsta
.p1eor	s_eor_var	B,p1_legflag,#1


;	bra	.ppsta
;
;.p2sta	a8
;	s_jmpNOT_varAND	B,p2_legflag,#1,.p2staN
;	a16
;	lda	work0
;	xba
;	sta	work0
;	lda	work1
;	xba
;	sta	work1
;	lda	work2
;	xba
;	sta	work2
;
;.p2staN	a8
;	lda	work5
;	bit	#legflag_changeflag
;	bne	.p2eor
;	bit	#legflag_resetflag
;	bne	.p2clr
;	bra	.ppsta
;.p2clr	s_and_var	B,p2_legflag,#1^-1
;	bra	.ppsta
;.p2eor	s_eor_var	B,p2_legflag,#1
;	bra	.ppsta

.ppsta
;------------------------------------------------------------------------
;-- set to leg pointer --

; tpx,y,z    tpx1,y1,z1

	s_copy_alvar2var	B,y,x1,exal_motionNo

	pl_get_shapeTAB_ST	W,x,work9,RBleg_xofstab
	pgst_END		W,x,work8,RBleg_yofstab

.doL	a8

	a16
	lda	exal_jetRobjptr,y
	pha

	lda	exal_jetLobjptr,y
	tay
	a8
	rlbeq	.nostateL


	s_init_anim	y,work0+0	;L
	s_set_alvar	B,y,al_sbyte4,work0+0

	a16
	lda	work9
	nega
	sta.w	al_childx,y

	lda	work1+0
	sexa
	clc
	adc	work8
	sta	tpy

	lda	work2+0
	sexa
	sta	tpz
	a8

;;;	s_set_alvar	W,y,al_childy,tpy
	s_achase_alvar	W,y,al_childy,tpy,1
	s_achase_alvar	W,y,al_childz,tpz,1

	s_set_state	y,x1

	s_jmp_varAND		B,work3,#ashiwalk,.swiml
.walkl	pl_set_pilotshape	x,y,shape_walkLtab
	s_clr_alsflag		y,sflag2
	bra			.wsl
.swiml	pl_set_pilotshape	x,y,shape_swimLtab
	s_set_alsflag		y,sflag2
.wsl

.nostateL


.doR
	pl_get_shapeTAB_ST	W,x,work9,RBleg_xofstab
	pgst_END		W,x,work8,RBleg_yofstab

	ply
	rlbeq	.nostateR

	s_init_anim	y,work0+1	;R
	s_set_state	y,x1

	a16
	lda	work9
	sta.w	al_childx,y

	lda	work1+1
	sexa
	clc
	adc	work8
	sta	tpy

	lda	work2+1
	sexa
	sta	tpz
	a8

	s_achase_alvar	W,y,al_childy,tpy,1
	s_achase_alvar	W,y,al_childz,tpz,1

	s_set_alvar	B,y,al_sbyte4,work0+1

	s_jmp_varAND		B,work3,#ashiwalk,.swimr
.walkr	pl_set_pilotshape	x,y,shape_walkRtab
	s_clr_alsflag		y,sflag2
	bra			.wsr
.swimr	pl_set_pilotshape	x,y,shape_swimRtab
	s_set_alsflag		y,sflag2

.wsr

.nostateR

;------------------------------------------------------------------------
; -- sound work4(16bit)--
; "RBwalksoundFIRST_flag" ga set sareteitara saisyo ha narasanai.

	s_jmp_alsflag		x,invisible,.nosound

.SEpoolswim	s_jmpNOT_varAND		B,work3,#RBswimpoolsound_flag,.SEswim

	pl_test_planetmode	marine
	rlbeq			.SEswim

	pl_jmpnot_KAOinpool	x,.SEswim
	lda		gameframe
	and		#7
	bne		.nosound
	kplsound	x,pool_swimming
	bra		.nosound


.SEswim	s_jmpNOT_varAND		B,work3,#RBswimsound_flag,.ashioto
	pl_SE_Roboswim		x
	bra			.nosound


.ashioto	s_jmpNOT_alsflag	x,sflag6,.ashioto1

	pl_SE_Robowalk		x

	s_clr_alsflag		x,sflag6

.ashioto1
	s_jmpNOT_varAND	B,work4+0,#RBwalksound_flag,.nosound
	s_set_alsflag	x,sflag6

.nosound

;------------------------------------------------------------------------
; -- pool splash work3(16bit)--

	toheap	y,x

; splash wo tsukutta trigger wo clear suru.

	pl_jmpnot_ASHIinpool	x,.nosplash

; read splash pos

	pl_get_shapetab		B,x,x1,hamonofstab

	stx	x2	;splash ni watasu pointer
	stx	x3

;-------------------------------------------------------------
; step no toki no splash

	lda	work3
	bit	#step_L_flag
	bne	.splashL
	bit	#step_R_flag
	beq	.nosplash

.splashR	bit	#bubble_flag
	bne	.bubbleR
	bra		.splashLR

.splashL	pha
	s_neg_var		B,x1
	pla
	bit	#bubble_flag
	bne	.bubbleL
.splashLR

; L to R no irekae wo suru?

	jsr			.checkswap
.makesplash
	s_set_var	B,z1,#0
	s_set_var	B,y1,#3
	jmp		.domake

;-------------------------------------------------------------

.bubbleR	s_copy_alvar2var	W,y,x2,exal_jetRobjptr
	s_copy_alvar2var	W,y,x3,exal_jetLobjptr
	bra			.bubbleLR
.bubbleL	s_copy_alvar2var	W,y,x2,exal_jetLobjptr
	s_copy_alvar2var	W,y,x3,exal_jetRobjptr

.bubbleLR

; L to R no irekae wo suru?

	jsr			.checkswap

;-------------------------------------------------------------
	s_set_var	B,x1,#0
	s_set_var	B,z1,#0
	s_set_var	B,y1,#0
	s_set_var	B,y2,#1
;-------------------------------------------------------------

.domake	jsl	makeclipeffect_l
	jmp	.nosplash

;-------------------------------------------------------------

.nosplash

;-----------------------------------------------------------------------------
;ÉÍÍÍÍÍÍÍÍÍÍÍÍ»
;ºROTZ of headº
;ÈÍÍÍÍÍÍÍÍÍÍÍÍ¼

	s_set_var	B,z1,#0

	lda		work4+0
	bit		#headrotzMI_flag
	bne		.mins_hz
	bit		#headrotzPL_flag
	beq		.thrash

.plus_hz	lda		#value_headrotzofs
	bra		.hz0
.mins_hz	lda		#-value_headrotzofs
.hz0	sta		z1


.p1orp2hz	;s_jmp_alsflag	x,player2,.p2hz

.p1hz	lda		p1_legflag

;	bra		.pphz
;.p2hz	lda		p2_legflag
;.pphz

	bit		#1
	beq		.thrash
	s_neg_var	B,z1

;-----------------------------------------------------------------------------
.thrash	pl_jmpnot_ifinthesea	x,.katamuki

	s_jmp_alsflag		x,ontheground,.katamuki

	lda	pcont+1
	bit	#padl_up!padl_down
	bne	.katamuki
	bit	#padl_left
	bne	.wL
	bit	#padl_right
	beq	.katamuki

.wR	lda	#-value_headrotzofs*2
	bra	.setw
.wL	lda	#value_headrotzofs*2
.setw	sta	z1
	bra	.achaseh

;-----------------------------------------------------------------------------
.katamuki	; enshinryoku

	toheap		y,x

	s_jmp_alvarNE	B,y,exal_motionNo,#m_walkF2,.k_4
	pl_jmp_LASTLRkey	x,.k_1,.k_0,.k_4,y
.k_0	lda	#-10
	bra	.k_2
.k_1	lda	#10
.k_2	clc
	adc	z1
	sta	z1
.k_4


;------------------------------------------------------------------------

.achaseh	s_achase_alvar	B,y,exal_rotzoffset,z1,2

;------------------------------------------------------------------------
;-- set head shake --


	s_set_var	W,y1,#0

	pl_jmp_KAOinpool	x,.achaseshake

	s_jmp_alvarEQ	B,y,exal_motionNo,#m_stop,.idling_shake

;	s_jmp_alvarEQ	B,y,exal_motionNo,#m_walkL,.walkLR1_shake
;	s_jmp_alvarEQ	B,y,exal_motionNo,#m_walkR,.walkLR1_shake
;	s_jmp_alvarEQ	B,y,exal_motionNo,#m_walkL2,.walkLR2_shake
;	s_jmp_alvarEQ	B,y,exal_motionNo,#m_walkR2,.walkLR2_shake
;
;.walkFB_shake

	s_set_var	W,y1,#-5

	lda	gameframe
	bit	#%100
	rlbne	.achaseshake

	s_set_var	W,y1,#5

	bra		.achaseshake

;.walkLR1_shake
;	s_jmp_varAND	B,work4+0,#headshake_flag,.doLR1shake1
;
;.doLR1shake0	pl_get_shapeTAB	W,x,y1,.LR1headshaketab0
;	jmp		.achaseshake
;
;.doLR1shake1	pl_get_shapeTAB	W,x,y1,.LR1headshaketab1
;	bra		.achaseshake
;
;.walkLR2_shake
;	s_jmp_varAND	B,work4+0,#headshake_flag,.doLR2shake1
;
;.doLR2shake0	pl_get_shapeTAB	W,x,y1,.LR2headshaketab0
;	bra		.achaseshake
;
;.doLR2shake1	pl_get_shapeTAB	W,x,y1,.LR2headshaketab1
;	bra		.achaseshake


.idling_shake

	toheap	y,x

	s_inc_alvar	B,y,exal_worldyofscounter
	a16
	lda	exal_worldyofscounter,y
	bit	#%1000
	bne	.yy1
	asl	a
.yy1	bit	#%100
	beq	.yy0
	eor	#3
.yy0	and	#3
	sta	y1

.achaseshake
	a8
	s_achase_alvar	W,y,exal_worldyoffset,y1,2

;------------------------------------------------------------------------
	s_pull_obj	y

	PULLXYP

	rts

;------------------------------------------------------------------------
; L to R no irekae wo suru?

.checkswap

;	s_jmp_alsflag		x,player2,.splash_p2
;
;.splash_p1	lda		p1_legflag
;	bra		.spflag
;.splash_p2	lda		p2_legflag
;.spflag

	lda		p1_legflag
	bit		#1
	rlbeq		.noswap
	s_neg_var	B,x1
	s_copy_var2var	W,x2,x3
.noswap	rts

;------------------------------------------------------------------------
.Fchase_vel	a8i16
	phy
	ldy		al_sword2,x
	s_set_alvar	B,y,exal_vel,x1

	ply
	rts
;------------------------------------------------------------------------
.headshaketab

	word	value_headshakeFF
	word	value_headshakeSP
	word	value_headshakeGG

.LRheadshaketab0	;if headshake_flag=0

	word	value_LRheadshake0FF
	word	value_LRheadshake0SP
	word	value_LRheadshake0GG

.LRheadshaketab1	;if headshake_flag=1

	word	value_LRheadshake1FF
	word	value_LRheadshake1SP
	word	value_LRheadshake1GG

.LR2headshaketab0	;if headshake_flag=0

	word	20
	word	20
	word	20

.LR2headshaketab1	;if headshake_flag=1

	word	-27
	word	-35
	word	-27

.LR1headshaketab0	;if headshake_flag=0

	word	20
	word	10
	word	20

.LR1headshaketab1	;if headshake_flag=1

	word	-27
	word	-20
	word	-20

;------------------------------------------------------------------------
;flag(data1)
ashiwalk		equ	1<<0	;0:walking shape 1:swimming shape
RBswimsound_flag	equ	1<<1	;1:on 0:off
headshake_flagUP	equ	1<<2	;1:up 0:
step_L_flag		equ	1<<3
step_R_flag		equ	1<<4
bubble_flag		equ	1<<5
RBswimpoolsound_flag	equ	1<<6	;1:on 0:off



;flag(data2)
RBwalksound_flag	equ	1<<0
headshake_flag	equ	1<<1
headrotzPL_flag	equ	1<<2
headrotzMI_flag	equ	1<<3
;bit 4 - 7 (data2)
rbF0	equ	0
rbFL	equ	1
rbL0	equ	2
rbBL	equ	3
rbB0	equ	4
rbBR	equ	5
rbR0	equ	6
rbFR	equ	7

;data2
bit	equ	%11100000


;ÚÄÄÄÄÄÄÄÄÄÄÄ¿
;³LOCAL MACRO³
;ÀÄÄÄÄÄÄÄÄÄÄÄÙ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
mkabtbit	macro

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	9

;	dw	(((\1+255)>>8)<<8)!(((\2+255)>>8)<<7)!(((\3+255)>>8)<<6)!(((\4+255)>>8)<<5)!(((\5+255)>>8)<<4)!(((\6+255)>>8)<<3)!(((\7+255)>>8)<<2)!(((\8+255)>>8)<<1)!(((\9+255)>>8))


abtbit0	=	(((\1&01h)>>0)!((\1&02h)>>1)!((\1&04h)>>2)!((\1&08h)>>3)!((\1&10h)>>4)!((\1&20h)>>5)!((\1&40h)>>6)!((\1&80h)>>7)*100H
abtbit1	=	(((\2&01h)>>0)!((\2&02h)>>1)!((\2&04h)>>2)!((\2&08h)>>3)!((\2&10h)>>4)!((\2&20h)>>5)!((\2&40h)>>6)!((\2&80h)>>7)*80H
abtbit2	=	((\3&01h)>>0)!((\3&02h)>>1)!((\3&04h)>>2)!((\3&08h)>>3)!((\3&10h)>>4)!((\3&20h)>>5)!((\3&40h)>>6)!((\3&80h)>>7)*40H
abtbit3	=	((\4&01h)>>0)!((\4&02h)>>1)!((\4&04h)>>2)!((\4&08h)>>3)!((\4&10h)>>4)!((\4&20h)>>5)!((\4&40h)>>6)!((\4&80h)>>7)*20H
abtbit4	=	((\5&01h)>>0)!((\5&02h)>>1)!((\5&04h)>>2)!((\5&08h)>>3)!((\5&10h)>>4)!((\5&20h)>>5)!((\5&40h)>>6)!((\5&80h)>>7)*10H
abtbit5	=	((\6&01h)>>0)!((\6&02h)>>1)!((\6&04h)>>2)!((\6&08h)>>3)!((\6&10h)>>4)!((\6&20h)>>5)!((\6&40h)>>6)!((\6&80h)>>7)*8
abtbit6	=	((\7&01h)>>0)!((\7&02h)>>1)!((\7&04h)>>2)!((\7&08h)>>3)!((\7&10h)>>4)!((\7&20h)>>5)!((\7&40h)>>6)!((\7&80h)>>7)*4
abtbit7	=	((\8&01h)>>0)!((\8&02h)>>1)!((\8&04h)>>2)!((\8&08h)>>3)!((\8&10h)>>4)!((\8&20h)>>5)!((\8&40h)>>6)!((\8&80h)>>7)*2
abtbit8	=	((\9&01h)>>0)!((\9&02h)>>1)!((\9&04h)>>2)!((\9&08h)>>3)!((\9&10h)>>4)!((\9&20h)>>5)!((\9&40h)>>6)!((\9&80h)>>7)

	dw	(abtbit0!abtbit1!abtbit2!abtbit3!abtbit4!abtbit5!abtbit6!abtbit7!abtbit8)<<2

	endm


mkabtbyte	macro

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	IFNE	\1&$ff

	byte	\1

	ENDC

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
abtfrm	macro	[Ldata,Rdata,LYofs,RYofs,LZofs,RZofs,data1,data2,data3,dir]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	10

	mkabtbit	{Rdata},{Ldata},{RYofs},{LYofs},{RZofs},{LZofs},{data1},(({data2}&0fH)+(RB_{dir}<<4)),{data3}
	mkabtbyte	{Rdata}
	mkabtbyte	{Ldata}
	mkabtbyte	{RYofs}
	mkabtbyte	{LYofs}
	mkabtbyte	{RZofs}
	mkabtbyte	{LZofs}
	mkabtbyte	{data1}		;flag
	mkabtbyte	(({data2}&0fH)+(RB_{dir}<<4))
	mkabtbyte	{data3}		;vx vy vz
	endm


abtend	macro	[code,forcenext,nokeynext,repeatnext]

	stratmac_start

MYNARG	=		NARG
	CHK_NARG	4

	byte	{code}	;end code
	word	{forcenext}&WM		;next 0:exal_animptr=exal_animptrNEXT
	word	{nokeynext}&WM
	word	{repeatnext}&WM

	ENDM


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º           Animation data                                                 º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

;animation data table

abt_DATAS
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk F start                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
abt_RBwalkFstart_FOX

	abtfrm	01,10,000,-14,000,000,%00000000,%0000,m_walkFstart,F
	abtend	255,0,abt_RBwalkstart_END,0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk F start END                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
abt_RBwalkstart_END

	abtfrm	00,02,000,000,000,000,%00010000,%0001,m_walkF,F
	;abtfrm	00,08,000,-14,000,000,%00000000,%0000,m_walkF,F
	abtfrm	00,09,000,-14,000,000,%00000000,%0000,m_walkF,F
	;abtfrm	00,10,000,-14,000,000,%00000000,%0000,m_walkF,F
	abtfrm	00,10,000,-00,000,000,%00000000,%0001,m_walkF,F
	abtend	255,0,abt_RBstopping,0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk F stop                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
abt_RBstopF
;		L  R  LY  RY  LZ  RZ          s

	;abtfrm	09,00,000,000,000,000,%00000000,%0000,m_walkF,F	;m_stop
	;abtfrm	10,00,000,000,000,000,%00000000,%0000,m_walkF,F	;m_stop
	abtfrm	00,00,000,000,000,000,%00000000,%0001,m_walkF,F	;m_stop
	abtend	255,abt_RBstopping,0,0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk F1                                                         ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

abt_RBwalkF1_FOX
;		L  R  LY  RY  LZ  RZ  data1     muki,vel

;	abtfrm	11,03,000,000,000,000,%00001000,%0000,m_walkF1,F
;	abtfrm	15,07,000,-10,000,000,%00000000,%0111,m_walkF1,F
;	ABTFRM	00,08,-06,000,000,000,%00000000,%0000,m_walkF1,F
;	abtend	255,0,abt_RBstopF,abt_RBwalkF1_FOX

	abtfrm	11,03,000,000,000,000,%00000000,%1000,m_walkF1,F
	abtfrm	13,05,000,-05,000,000,%00000000,%0000,m_walkF1,F
	abtfrm	15,07,000,-10,000,000,%00000000,%0110,m_walkF1,F
	abtfrm	00,08,-06,000,000,000,%00001000,%0001,m_walkF1,F
	abtend	255,0,abt_RBstopF,abt_RBwalkF1_FOX

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk F2                                                         ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

abt_RBwalkF2_FOX

;		L  R  LY  RY  LZ  RZ  data1     muki,vel

	abtfrm	11,03,000,000,000,000,%00000000,%1000,m_walkF2,F
	abtfrm	15,07,000,-10,000,000,%00001000,%0111,m_walkF2,F
	abtend	255,0,abt_RBstopF,abt_RBwalkF1_FOX

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk B start                                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

abt_RBwalkBstart_FOX

;	abtfrm	00,00,-14,000,000,000,%00000000,%0000,m_walkBstart,B
;	abtfrm	00,00,-14,000,000,000,%00000000,%0000,m_walkBstart,B
;	abtfrm	10,15,-14,000,000,000,%00000000,%0000,m_walkBstart,B
	abtfrm	10,15,000,000,000,000,%00000000,%0000,m_walkBstart,B

	abtend	255,0,abt_RBwalkBstart_END,0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk B start END                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

abt_RBwalkBstart_END

	abtfrm	11,00,000,000,000,000,%00001000,%0001,m_walkB,B
	abtfrm	10,00,-14,000,000,000,%00000000,%0001,m_walkB,B

	abtend	255,0,abt_RBstopping,0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk B1                                                         ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

abt_RBwalkB1_FOX
;		L  R  LY  RY  LZ  RZ  data1     muki,vel
	abtfrm	15,07,000,000,000,000,%00000000,%0100,m_walkB1,B
	abtfrm	11,03,000,000,000,000,%00001000,%0101,m_walkB1,B
	abtend	255,0,abt_RBstopB,abt_RBwalkB1_FOX

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk B2                                                         ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
abt_RBwalkB2_FOX
;		L  R  LY  RY  LZ  RZ  data1     muki,vel
	abtfrm	11,04,-02,-02,009,-03,%00000000,%0100,m_walkB2,B
	abtfrm	08,00,-16,000,009,003,%00001000,%0111,m_walkB2,B
	abtend	255,0,abt_RBwalkB1_FOX,0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           stop B                                                          ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
abt_RBstopB	;Back --> stop
;		L  R  LY  RY  LZ  RZ state
	abtfrm	00,01,000,000,000,000,%00000000,%0001,m_walkB,B	;m_stop
	abtend	255,abt_RBstopping,0,0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           turn                                                            ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
abt_RBturnL_FOX
abt_RBturnR_FOX
abt_RBturnL_FALCO
abt_RBturnR_FALCO
abt_RBturnL_GAL1
abt_RBturnR_GAL1
abt_RBturnL_GAL2
abt_RBturnR_GAL2

;		L  R  LY  RY  LZ  RZ  state  flag
	abtfrm	00,10,000,-16,000,-04,%00000000,%0000,m_turnR,S	; first sound off
	abtfrm	00,10,000,-18,000,-06,%00000000,%0000,m_turnR,S
	abtfrm	00,10,000,000,000,-02,%00001000,%0011,m_turnR,S

;		L  R  LY  RY  LZ  RZ  state  flag
	abtfrm	10,00,-16,000,-04,000,%00000000,%0000,m_turnR,S	; first sound off
	abtfrm	10,00,-18,000,-06,000,%00000000,%0000,m_turnR,S
	abtfrm	10,00,000,000,-02,000,%00010000,%0011,m_turnR,S

	abtend	254,0,abt_RBstopped,0

abt_RBturnL_PEPPY
abt_RBturnR_PEPPY
abt_RBturnL_SLIPPY
abt_RBturnR_SLIPPY

;		L  R  LY  RY  LZ  RZ  state  flag
	abtfrm	00,09,000,-16,000,-04,%00000000,%0000,m_turnR,S	; first sound off
	abtfrm	00,10,000,-18,000,-06,%00000000,%0000,m_turnR,S
	abtfrm	00,08,000,000,000,-02,%00001000,%0011,m_turnR,S

;		L  R  LY  RY  LZ  RZ  state  flag
	abtfrm	09,00,-16,000,-04,000,%00000000,%0000,m_turnR,S	; first sound off
	abtfrm	10,00,-18,000,-06,000,%00000000,%0000,m_turnR,S
	abtfrm	08,00,000,000,-02,000,%00010000,%0011,m_turnR,S

	abtend	254,0,abt_RBstopped,0
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk L                                                          ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

abt_RBwalkLstart_FOX
abt_RBwalkL1_FOX

	byte	253	; lr flag clear code

	abtfrm	10,00,-15,005,000,000,%00000000,%0000,m_walkL,L
	abtfrm	10,00,-18,008,000,000,%00001000,%0001,m_walkL,L

	abtfrm	00,10,000,-15,000,000,%00000000,%0010,m_walkL,L
	abtfrm	00,10,000,-18,000,000,%00000000,%0010,m_walkL,L
	ABTFRM	00,10,000,-22,000,000,%00010000,%0011,m_walkL,L

	abtend	254,0,abt_RBstopping,0



abt_RBwalkL2_FOX

;		R  L  RY  LY  LZ  RZ  state  flag

	byte	253	; lr flag clear code

	abtfrm	10,00,-15,005,000,000,%00000000,%0000,m_walkL2,L
	abtfrm	10,00,-18,008,000,000,%00001000,%0001,m_walkL2,L

	abtfrm	00,10,000,-20,000,000,%00000000,%0010,m_walkL2,L
	abtfrm	00,10,000,-23,000,000,%00010000,%0011,m_walkL2,L

	abtend	254,0,abt_RBwalkLRstopping,0


;		R  L  RY  LY  LZ  RZ  state  flag
;
;	byte	253	; lr flag clear code
;
;	abtfrm	10,00,-15,005,000,000,%00000000,%0000,m_walkL2,L
;	abtfrm	10,00,-18,008,000,000,%00000000,%0001,m_walkL2,L
;
;	abtfrm	00,10,000,-20,000,000,%00000000,%0010,m_walkL2,L
;	abtfrm	00,10,000,-23,000,000,%00000000,%0011,m_walkL2,L
;
;	abtend	254,0,abt_RBwalkLRstopping,0





;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           walk R                                                          ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

abt_RBwalkRstart_FOX
abt_RBwalkR1_FOX

	byte	253	; lr flag clear code

	abtfrm	00,10,000,-15,005,000,%00000000,%0000,m_walkR,R
	abtfrm	00,10,000,-18,008,000,%00001000,%0001,m_walkR,R

	abtfrm	10,00,-15,000,000,000,%00000000,%0010,m_walkR,R
	abtfrm	10,00,-18,000,000,000,%00000000,%0010,m_walkR,R
	abtfrm	10,00,-22,000,000,000,%00010000,%0011,m_walkR,R

	abtend	254,0,abt_RBstopping,0

abt_RBwalkR2_FOX

;		R  L  RY  LY  LZ  RZ  state  flag

	byte	253	; lr flag clear code

	abtfrm	00,10,000,-15,005,000,%00000000,%0000,m_walkR2,R
	abtfrm	00,10,000,-18,008,000,%00001000,%0001,m_walkR2,R

	abtfrm	10,00,-20,000,000,000,%00000000,%0010,m_walkR2,R
	abtfrm	10,00,-23,000,000,000,%00010000,%0011,m_walkR2,R

	abtend	254,0,abt_RBwalkLRstopping,0


abt_RBwalkLRstopping
;		L  R  LY  RY  LZ  RZ state

	abtfrm	00,00,010,010,000,000,%00011000,%00000000,m_stop,S
	abtend	254,0,abt_RBstopping,0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³           stop                                                            ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

abt_RBstopping
abt_dummy
abt_RBstopped
;		L  R  LY  RY  LZ  RZ state

	abtfrm	00,00,000,000,000,000,%00000000,%0000,m_stop,S
	abtend	254,0,abt_RBstopped,0

abt_RBbrakeF
;		L  R  LY  RY  LZ  RZ  data1     muki,vel
	abtfrm	12,12,020,020,000,000,%00000000,%0001,m_brakeF,F
	abtfrm	12,12,020,020,000,000,%00000000,%0001,m_brakeF,F
	abtfrm	12,12,020,020,000,000,%00000000,%0001,m_brakeF,F
	abtfrm	12,12,020,020,000,000,%00000000,%0001,m_brakeF,F
	abtfrm	12,12,020,020,000,000,%00000000,%0001,m_brakeF,F
	abtfrm	12,12,020,020,000,000,%00000000,%0001,m_brakeF,F
	abtfrm	12,12,000,000,000,000,%00000000,%0000,m_brakeF,F
	abtfrm	14,14,000,-05,000,000,%00000000,%0100,m_brakeF,F
	abtfrm	15,15,000,-09,000,000,%00000000,%0110,m_brakeF,F
	abtfrm	00,00,000,-10,000,000,%00000000,%0111,m_brakeF,F
	abtend	255,0,abt_RBstopF,0


abt_RBswim
;		L  R  LY  RY  LZ  RZ  data1     muki,vel
	abtfrm	00,00,000,000,-15,-15,%00000001,%0000,m_dummy,S	;walkF
	abtfrm	02,02,000,000,-15,-15,%00000001,%0000,m_dummy,S	;walkF
	abtfrm	04,04,000,000,-15,-15,%00000001,%0000,m_dummy,S	;walkF
	abtfrm	06,06,000,000,-15,-15,%00000011,%0000,m_dummy,S	;walkF
	abtfrm	08,08,000,000,-15,-15,%00000001,%0000,m_dummy,S	;walkF
	abtfrm	09,09,000,000,-15,-15,%00000001,%0000,m_dummy,S	;walkF
	abtfrm	10,10,000,000,-15,-15,%00000001,%0000,m_dummy,S	;walkF
	abtfrm	11,11,000,000,-15,-15,%00101001,%0000,m_dummy,S	;walkF
	abtfrm	12,12,000,000,-15,-15,%00110001,%0000,m_dummy,S	;walkF
	abtfrm	13,13,000,000,-15,-15,%00000001,%0000,m_dummy,S	;walkF
	abtend	255,0,abt_RBswimming,0

abt_RBswimming

;		L  R  LY  RY  LZ  RZ state
	abtfrm	13,13,000,000,-05,-05,%01000001,%0000,m_stop,S
	abtend	254,0,abt_RBswimstop,0

abt_RBthrashF	; bataashi

;		L  R  LY  RY  LZ  RZ state
	abtfrm	13,13,000,000,-08,-08,%01000001,%0000,m_thrashF,F
	abtend	255,0,abt_RBswimstop,0

abt_RBthrashB	; bataashi
;		L  R  LY  RY  LZ  RZ state
	abtfrm	13,13,000,000,000,000,%01000001,%0000,m_thrashB,B
	abtend	255,0,abt_RBswimstop,0

abt_RBthrashL	; bataashi

;		L  R  LY  RY  LZ  RZ state
;	byte	253	;LR flag clear code
	abtfrm	13,13,000,000,000,-15,%01000001,%0100,m_thrashL,L
	abtend	254,0,abt_RBswimming,0

abt_RBthrashR	; bataashi
;		L  R  LY  RY  LZ  RZ state
;	byte	253	;LR flag clear code
	abtfrm	13,13,000,000,-15,000,%01000001,%1000,m_thrashR,R
	abtend	254,0,abt_RBswimstop,0

abt_RBthrashturnL	;

;		L  R  LY  RY  LZ  RZ state

	abtfrm	00,07,000,000,-15,-15,%01000001,%0100,m_thrashturnL,L	;walkF
	abtfrm	01,08,000,000,-15,-15,%01000001,%0100,m_thrashturnL,L	;walkF
	abtfrm	02,09,000,000,-15,-15,%01000001,%0100,m_thrashturnL,L	;walkF
	abtfrm	03,10,000,000,-15,-15,%01000011,%0100,m_thrashturnL,L	;walkF
	abtfrm	04,11,000,000,-15,-15,%01000001,%0100,m_thrashturnL,L	;walkF
	abtfrm	05,12,000,000,-15,-15,%01000001,%0100,m_thrashturnL,L	;walkF
	abtfrm	06,13,000,000,-15,-15,%01110001,%0100,m_thrashturnL,L	;walkF

	abtend	255,0,abt_RBswimming,0

abt_RBthrashturnR	;
;		L  R  LY  RY  LZ  RZ state
	abtfrm	00,07,000,000,-15,-15,%01000001,%0100,m_thrashturnR,R	;walkF
	abtfrm	01,08,000,000,-15,-15,%01000001,%0100,m_thrashturnR,R	;walkF
	abtfrm	02,09,000,000,-15,-15,%01000001,%0100,m_thrashturnR,R	;walkF
	abtfrm	03,10,000,000,-15,-15,%01000011,%0100,m_thrashturnR,R	;walkF
	abtfrm	04,11,000,000,-15,-15,%01000001,%0100,m_thrashturnR,R	;walkF
	abtfrm	05,12,000,000,-15,-15,%01000001,%0100,m_thrashturnR,R	;walkF
	abtfrm	06,13,000,000,-15,-15,%01110001,%0100,m_thrashturnR,R	;walkF

	abtend	255,0,abt_RBswimstop,0

abt_RBswimstop

;		L  R  LY  RY  LZ  RZ state

	abtfrm	13,13,000,000,000,000,%00000001,%0000,m_stop,S
	abtfrm	14,14,000,000,000,000,%00000001,%0000,m_stop,S
	abtfrm	15,15,000,000,000,000,%00000001,%0000,m_stop,S
	abtend	254,0,abt_RBstopping,0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	REMOVE OBJECT ROUTINE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
playerobjctremove
	s_remove_obj	x
	s_set_alvar	W,x,al_shape,#nullshape	;c_wing
	s_end_strat
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	COPY HITFLASH
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
copy_hitflash_srou_l
;	in	idx:to   obj
;		idy:from obj
;
	stratmac_start
	s_jmp_alsflag	y,hitflash,.set
.clr	s_clr_alsflag	x,hitflash
	bra		.exit
.set	s_set_alsflag	x,hitflash
.exit
;	pl_copy_alsflag		x,y,hitflash

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	set ontheground trigger
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ontheground_trig_srou

	PUSHXYP

	s_start_strat

	a8i16

	ldy	al_sword2,x

	s_jmpNOT_alsflag	x,ontheground,.noground

.ground
	lda	#exal_robostatus_onthegroundtrig
	eor	exal_robostatus,y
	and	#exal_robostatus_onthegroundtrig
	sta	exal_robostatustrig,y

	lda	#exal_robostatus_onthegroundtrig
	ora	exal_robostatus,y
	sta	exal_robostatus,y

	bra	.effect
.noground
	lda	#exal_robostatus_onthegroundtrig^-1
	and	exal_robostatustrig,y
	sta	exal_robostatustrig,y

	lda	#exal_robostatus_onthegroundtrig^-1
	and	exal_robostatus,y
	sta	exal_robostatus,y


.effect	lda	exal_robostatustrig,y
	bit	#exal_robostatus_onthegroundtrig
	rlbeq	.nosmoke

;	jsl	makelegsmoke_srou_l

;	in	:x1 offsetx
;		:z1 offsetz
;		:y1 init colanim frame
;		:x2 leg(or body)'s pointer

;	pl_jmp_ZENBUinpool	x,.nosmoke


	s_copy_alvar2var	W,y,x2,exal_jetLobjptr
	jsr	.makesmoke
	s_copy_alvar2var	W,y,x2,exal_jetRobjptr
	jsr	.makesmoke

	c_shock_cam	x,#60H,y

	pl_SE_Roboland	x,y


	s_set_alvar	W,x,al_my,#0
	s_set_alvar	W,x,al_vy,#0
	s_set_alvar	B,y,exal_jmpstatus,#0
	s_set_alvar	W,y,exal_jmpvel,#0
	s_set_alvar	B,y,exal_plashvel,#0


.nosmoke


	PULLXYP
	rts



.makesmoke	LOCAL

	lda	#0
	sta	x1
	sta	z1

	lda	#0
	sta	y2	; size

	pl_jmp_ZENBUinpool	x,.bubble

	pl_jmp_ifonthe	x,water,.splash
	pl_jmp_ifonthe	x,magma,.msplash

.smoke	s_set_var	B,y1,#0	; first colanim
	jsl	makesmokeryusa_srou_l
	rts

.splash	s_set_var	B,y1,#3	; first colanim
	jsl	makesplashpool_srou_l
	rts

.msplash	s_set_var	B,y1,#0	; first colanim
	jsl	makeMsplashpool_srou_l
	rts

.bubble	pl_jmpnot_ifinthesea		x,.nobubble
	s_set_var	B,y1,#40
	s_set_var	B,x1,#0
	s_set_var	B,z1,#0
	jsl	makebubble_srou_l
.nobubble	rts









;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;GENERAL_INIT_L
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;.initsprite
;	s_set_alsflag		y,notslope
;	s_set_alsflag		y,colldisable
;	s_init_colanim		y,#0
;	s_set_aldata		y,#1,#1	;hardHP,#hardAP
;	s_set_alvartobeobj	y,al_ptr,x
;	s_sprite_obj		y,#0,#0
;	s_copy_pos		y,x
;	s_copy_rots		y,x
;	rtl
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;makeboss_l
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	SHORTA
;	LONGI
;
;	phx
;	phy
;	php
;
;	a8i16
;	lda		KgameMap
;	cmp		#0
;	beq		.map00
;	jmp		.map01
;
;.map00	s_make_obj	#spin_2,.badobj
;	s_set_alptrs	y,SPINBOSS_Istrat,hit_istrat,explode_istrat
;	s_clr_alsflag	y,realobj
;	s_set_aldata	y,#100,#1
;.badobj
;	jmp		.exit
;
;.map01	s_make_obj	#DRAGON_0,.badobj
;	s_set_alptrs	y,FIREDRAGON_Istrat,hit_istrat,explode_istrat
;	s_clr_alsflag	y,realobj
;	s_set_aldata	y,#100,#1
;
;	jmp		.exit
;
;.exit	plp
;	ply
;	plx
;	rtl

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                                                            º
;º	ROBOT no EFFECT no strat                         º
;º                                                            º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	library of KPLSOUND
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	idX : player's pointer
;

SE_roboland_l_srou_l
	s_start_strat

	PHP

	jsr			ckroboland
	bcs			SER_land2water

	kplsound		x,Roboland_l

	PLP

	rtl

SE_roboland_s_srou_l
	s_start_strat

	PHP

	jsr			ckroboland
	bcs			SER_land2water

	kplsound		x,Roboland_s

	PLP

	rtl

SER_land2water
	s_start_strat

	kplsound		x,wingwaterdmg

	PLP

	rtl


SE_RobolandInSea_s_srou_l
SE_RobolandInSea_l_srou_l
	s_start_strat

	PHP

	kplsound		x,RobolandInSea_l

	PLP

	rtl



ckroboland
	PHY
	toheap	y,x
	lda	exal_pooltype,y
	PLY

	cmp	#st_water
	beq	.wSE
	cmp	#st_magma
	beq	.wSE

.gSE	clc
	rts

.wSE	sec
	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³  parameter table  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

robospeed_tab
	pilottab	B,robospeed_

robospeedFAST_tab
	pilottab	B,robospeedFAST_

robospeedLR_tab
	pilottab	B,robospeedLR_

robospeedLRFAST_tab
	pilottab	B,robospeedLRFAST_

robospeedthrash_tab
	pilottab	B,robospeedthrash_

robospeedthrashFAST_tab
	pilottab	B,robospeedthrashFAST_

robospeedLRthrashaccl_tab
	pilottab	W,robospeedthrashLRaccl_

roboLRrotyinc_tab
	pilottab	B,roboLRrotyinc_

robospeedaccl_tab
	pilottab	W,robospeedaccl_

robospeeddushaccl_tab
	pilottab	W,robospeeddushaccl_

robogndfric_tab
	pilottab	W,robogndfric_

roboslopefric_tab
	pilottab	W,roboslopefric_

roboairfric_tab
	pilottab	W,roboairfric_

robowatfric_tab
	pilottab	W,robowatfric_

robospeedLRaccl_tab
	pilottab	W,robospeedLRaccl_

robospeedLRdushACCL_tab
	pilottab	W,robospeedLRdushaccl_

robospeedthrashaccl_tab
	pilottab	W,robospeedthrashaccl_

robospeedthrashFASTaccl_tab
	pilottab	W,robospeedthrashFASTaccl_

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	BOYOYON Pros
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RBboyoyon_srou

vydivmax	equ	15

	PUSHXYP

	s_start_strat

	a8i16

	ldy		al_sword2,x

	pl_jmpnot_KAOinpool	x,.normal

;----------------------------------------------------------------------------------

	pl_jmpnot_ifonthe	x,sand,.water,y

	a16

	lda	#0
	bra	.setpoolvy

.water	a8

	PHX

	pl_jmpnot_ZENBUinpool	x,.pukapuka

.yurayura	a16
	lda	gameframe
	lsr	a
	bra	.puka0

.pukapuka	a16
	lda	gameframe
.puka0	and	#15
	tax
	lda.l	.poolofsydat,x
	PLX


.setpoolvy
	sexa
	sta	exal_vyboyoyonY,y
	a8
	s_achase_alvar	W,y,exal_vydiv,#0,2

	jmp	.exit

.poolofsydat
	db	0
	db	1
	db	2
	db	3

	db	4
	db	3
	db	2
	db	1


	db	0
	db	-1
	db	-2
	db	-3

	db	-4
	db	-3
	db	-2
	db	-1


;----------------------------------------------------------------------------------
.normal	a16
;----------------------------------------------------------------------------------
; div Y wo store suru.

	lda		exal_vyold,y
	sec
	sbc		al_vy,x
	pha
	xba
	and		#0ff00H
	sta		y2
	pla
	bpl		.pl0
	nega
.pl0	xba
	and		#0ff00H
	sta		y1

;----------------------------------------------------------------------------------

	lda		exal_vydiv,y
	bpl		.pl1
	nega
.pl1	cmp		y1
	bcs		.nochange
	lda		y2
	sta		exal_vydiv,y

	a8

	lda		exal_vydiv+1,y
	bpl		.degmi
.degpl	lda		#deg90
	bra		.degset
.degmi	lda		#-deg90
.degset	sta		exal_vyphase,y
	a16

.nochange

	lda		al_vy,x
	sta		exal_vyold,y

;----------------------------------------------------------------------------------
; limitter

; get max value

	a8
	s_set_var	B,x1+0,#0
	pl_get_shapeTAB	B,x,x1+1,byynmaxtab
	a16

	lda		x1
	nega
	sta		x2


	lda		exal_vydiv,y
	bmi		.mi
.pl	cmp		x1	;#vydivmax<<8
	bcc		.nolmt
	lda		x1	;#vydivmax<<8
	bra		.setlmt

.mi	cmp		x2	;#-vydivmax<<8
	bcs		.nolmt
	lda		x2	;#-vydivmax<<8
.setlmt	sta		exal_vydiv,y

.nolmt

;----------------------------------------------------------------------------------

	a8
; phase
	s_add_alvar	B,y,exal_vyphase,#30
	s_fchase_alvar	W,y,exal_vydiv,#0,0a0H
.divy

;----------------------------------------------------------------------------------

	s_copy_alvar2var	B,y,y1,exal_vydiv+1
	s_set_var		B,z1,#0
	lda	exal_vyphase,y
	jsl	rotate_8yz_l

	s_set_alvar	W,y,exal_vyboyoyonY,y2

;----------------------------------------------------------------------------------
	s_achase_alvar	B,y,exal_poolofsy,#0,2


.exit	PULLXYP

	rts



byynmaxtab	;boyoyon no saidai no sinpuku.

	db	15	;FF
	db	13	;SP
	db	13	;GG

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	POOL nadono splash toka hamon tokawo tsukuru...
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
makebodysplash_srou

	PUSHXYP

	s_start_strat

	a8i16

	pl_jmpnot_KAOinpool	x,.nosplash

	pl_jmp_ZENBUinpool	x,.nosplash

	lda	#0
	sta	x1
	sta	z1
	s_add_rnd2var		x1,#15
	s_add_rnd2var		z1,#7


.exx	lda	x1
	bit	#8
	beq	.exz
	nega
	sta	x1

.exz	lda	z1
	bit	#4
	beq	.ex
	nega
	sta	z1
.ex


	s_set_var		B,y1,#4


;------------------------------------------------------------
	toheap	y,x

	pl_jmp_motionNoEQ	x,thrashturnL,.l,y
	pl_jmp_motionNoEQ	x,thrashturnR,.r,y

	lda	exal_motiondir,y
	and	#RBdir_mask
	beq	.stop
	cmp	#RB_L
	beq	.l
	cmp	#RB_R
	beq	.r
	cmp	#RB_F
	beq	.f
	cmp	#RB_B
	bne	.dirend


.b	s_add_var	B,z1,#13
	bra		.dirend
.f	s_add_var	B,z1,#-10
	bra		.dirend
.l	s_add_var	B,x1,#10
	bra		.dirend
.r	s_add_var	B,x1,#-10
	bra		.dirend

.stop

	JMP	.NOSPLASH

	s_set_var	B,y1,#6

.dirend

;------------------------------------------------------------

;.make

	ldy		dummyobj
	s_copy_pos	y,x
	s_copy_rots	y,x
	s_set_alvar	B,y,al_rotx,#0
	sty		x2

	s_set_var	B,y2,#1
	phy
	jsl		makeclipeffect_l
	ply
.nosplash

;------------------------------------------------------------------------------------------------
; stop shiteru tokino hamon

	toheap	y,x

	pl_jmp_ZENBUinpool	x,.nohamon0

	pl_jmp_ASHIinpool	x,.makehamon,magma
	pl_jmp_ASHIinpool	x,.makehamon,water

	jmp		.nohamon0

; clera jyouken

.makehamon

	pl_jmp_motionNoNE	x,stop,.nohamon0,y

.hamonR	s_jmp_alvarAND		B,y,exal_robostatus,#exal_robostatus_hamonR,.hamonL
	s_set_var		B,x1,#1
	jsl			makehamon_srou_l

.hamonL
	s_jmp_alvarAND		B,y,exal_robostatus,#exal_robostatus_hamonL,.nohamon0
	s_set_var		B,x1,#-1
	jsl			makehamon_srou_l

.nohamon0
	s_and_alvar	B,y,exal_robostatus,#(exal_robostatus_hamonL!exal_robostatus_hamonR)^-1

	pl_jmpnot_ZENBUinpool	x,.nobubble

;	s_jmp_notandframe	#48,.nobubble

	lda		gameframe
	and		#48
	bne		.nobubble

	lda		gameframe
	and		#4
	bne		.nobubble

	s_set_var	W,x1,#0
	s_set_var	W,z1,#0
	s_set_var	W,y1,#0

	stx		x2
	jsl		makebubble_srou_l
	ksound		ob_bubble1

.nobubble
;------------------------------------------------------------------------------------------------

	PULLXYP

	rts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	POOL ni uiteirutoki no atama no ichi wo hosei suru...
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ROBOadjustfloat_srou

	PUSHXYP

	s_start_strat

	a8i16

	s_set_var	B,y1,#0

	toheap	y,x

	pl_jmpnot_iffloating	x,.chase,y

	a16

	lda	exal_bodyofsy,y
	sexa
	nega
	clc
	adc	exal_worldy,y
	sta	y1

	lda	exal_pooldepth,y
	clc
	adc	#5
	sec
	sbc	y1	;al_worldy,x
	a8

	sta	y1


.chase	s_achase_alvar	B,y,exal_bodyfloatofsy,y1,1

	PULLXYP

	rts


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	slope ni atama wo utu tokino syori
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RBseadepthofs	equ	100

aht_rotx	equ	work9
aht_posy	equ	work8
aht_zofs	equ	work7

ROBOgottun_srou_l

	PUSHYP

	s_start_strat

	a8i16

;----------------------------------------------------------------------------------
	toheap	y,x

	s_or_alvar	B,y,exal_vxvyvz,#exal_vxvyvz_ALL

;----------------------------------------------------------------------------------
; slope ni atama wo utu syori...

	ldy			dummyobj
	s_copy_pos		y,x

	sp_jmp_playertype	x,UFO,.AMo

.RBo	s_add_alvar		W,y,al_worldy,#-10
	jmp			.getheight

;---------------------------------------------------------------------------
.AMo

	s_add_alvar		W,y,al_worldy,#-40

;	s_push_obj		y
;	s_copy_alvar2var	B,y,aht_rotx,exal_jetrot
;	s_pull_obj		y
;	pl_get_shapetab		W,x,aht_zofs,jetnoseposz
;
;	tf_sin_var16	W,aht_posy,aht_rotx
;
;	a16
;	lda		aht_posy
;	asl		a
;	clc
;	adc		al_worldy,x
;	sta.w		al_worldy,y
;	a8

;---------------------------------------------------------------------------

.getheight	s_exg_objs
	jsl			getheight_l
	s_exg_objs

;	a16
;	lda.w		al_slopeptr,y
;	printh		al_slopeH,kawagoe
;	lda		al_slopeptr,x
;	printh		al_slopeL,kawagoe
;	a8

;atamauchi no effect effect

	a16
	lda.w		al_slopeptr,y
	cmp		al_slopeptr,x
	a8
	rlbeq		.clrflag

	sp_jmp_playertype	x,UFO,.AM

;-------------------------------------------------------------------------------
.RB

;clear jump vector

	toheap		y,x
	a16
	lda		#0
	sta		al_my,x
	sta		exal_jmpvel,y
	a8
	sta		exal_jmpstatus,y
	bra		.flag


;-------------------------------------------------------------------------------
.AM

; atama ni slope ga nai?
;	a16
;	lda.w		al_slopeptr,y
;	printh		al_slopeH,kawagoe
;	lda.w		al_slopeptr,x
;	printh		al_slopeL,kawagoe

;clear Y vector

	toheap		y,x

	a16
	lda	#0
	sta	al_my,x

.amv	a8

;-------------------------------------------------------------------------------
.flag
;set flag & sound

;hitflash	test

;JJJ	s_set_alsflag	x,hitflash

	s_jmp_alvarAND	B,y,exal_robostatus2,#exal_robostatus2_atamauchi,.exitgottun
	s_or_alvar	B,y,exal_robostatus2,#exal_robostatus2_atamauchi
	jsl		SE_roboland_s_srou_l
;	jsl		makegottun_srou_l
	bra		.exitgottun

.clrflag
	toheap		y,x
	s_and_alvar	B,y,exal_robostatus2,#exal_robostatus2_atamauchi^-1

.exitgottun
;----------------------------------------------------------------------------------
; suimen yori ueni ikanai syori....

	IFEQ	1

	pl_jmpnot_ifinthesea	x,.exitsuimen

	s_and_alvar	B,y,exal_robostatus2,#exal_robostatus2_suimen^-1

	a16
	lda	#-RBseadepthofs
	sec
	sbc	SEADEPTH
	clc
	adc	al_worldy,x
	bpl	.exitsuimen

	s_and_alvar	B,y,exal_vxvyvz,#exal_vxvyvz_vy^-1

	a16
	lda	#0
	sta	al_my,x
;	sta	exal_jmpvel,y
	a8
;	sta	exal_jmpstatus,y

.exitsuimen
	ENDC


	PULLYP

	rtl

jetnoseposz	shapetab	W,jetheadz_



;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	WALKER(ARMER)'s rolling
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	IFNE	walkertwirl ; walker twirl
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	s_start_strat
RB_rolling_srou_l
	PUSHYP
	a8i16
	toheap	y,x
	jsr	set_rollingstatus
	lda	#20H
	sta	tpy
	lda	exal_rollingoffset,y
	bpl	.plroll
	lda	#-20H
	sta	tpy
.plroll	lda	exal_rollingoffset,y
	cmp	#20H
	beq	.rollNE
	cmp	#0e0H
	bne	.rollEQ
.rollNE	lda	exal_RBrollingoffset,y
	and	#0e0H
	bra	.addrby
.rollEQ	lda	exal_RBrollingoffset,y
	and	#0e0H
	beq	.noaddrby
.addrby	clc
	adc	tpy
	sta	exal_RBrollingoffset,y
.noaddrby	PULLYP
	rtl
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	ENDC
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	GENERAL DYNAMICS for WALKER
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
RB_generaldynamics_l

	s_start_strat

	PUSHYP

	a8i16

;----------------------------------------------------------------------------
	lda	demomode
	bne	.freeze
;----------------------------------------------------------------------------

	km_jmpgameflag	freeze,.freeze
	bra		.notfreeze

.freeze
	s_set_alvar	W,x,al_mx,#0
	s_set_alvar	W,x,al_mz,#0

.notfreeze

;----------------------------------------------------------------------------

	sp_jmp_playertype	x,UFO,.notkill

	pl_jmpnot_ifinthesea	x,.notkill

	pl_jmpnot_iftransfalling	x,.notkill,y

	a16
	lda	seadepth
	clc
	adc	#200
	cmp	al_worldy,x
	a8
	bpl	.notkill

	a16
	sta	al_worldy,x
	sta	exal_worldy,y
	lda	#0
	sta	al_vy,x
	sta	al_my,x
	a8

.notkill

;----------------------------------------------------------------------------
; ashi no center eno vector wo keisan suru.

	lda	exal_jetstatus,y
	and	#exal_jetstatus_ALL
	cmp	#exal_jetstatus_ALL
	rlbne	.noclamp

	toheap	y,x

	a16

	lda	exal_legLheight,y
	sec
	sbc	exal_legRheight,y
	bpl	.lrheight
	nega

.lrheight

	sec
	sbc	#30H

	bit	#8000H
	rlbeq	.cnt

	lda	#0
	sta	work_mx
	sta	work_mz
	jmp	.noclamp

.cnt

	PHX


	a16
	ldy	al_sword2,x


	ldx	exal_jetLobjptr,y

	lda	al_worldx,x
	sta	x1
	lda	al_worldz,x
	sta	z1
	ldx	exal_jetRobjptr,y
	lda	al_worldx,x
	clc
	adc	x1
	adiv2
	sta	x1
	lda	al_worldz,x
	clc
	adc	z1
	adiv2
	sta	z1

	PLX

	lda	x1
	sec
	sbc	al_worldx,x
	sta	work_mx

	lda	z1
	sec
	sbc	al_worldz,x
	sta	work_mz

.noclamp
	a16

	lda	exal_clampx,y
	clc
	adc	work_mx
	sta	work_mx

	lda	exal_clampz,y
	clc
	adc	work_mz
	sta	work_mz

	lda	#0
	sta	exal_clampx,y
	sta	exal_clampz,y

	a8
	toheap	y,x

;----------------------------------------------------------------------------

	rb_downofs		x

	pl_generaldynamics	x,y

	a16
	lda	al_slopeptr,x
	sta	slopeptrold
	a8
	lda	al_slopenum,x
	sta	slopenumold

	rb_upofs		x


;-------------------------------------------------------------------------
; reflect effect

	a8

	lda	dynamflag
	bit	#4
	beq	.noeffect

	lda	exal_blockmapstatus,y
	ora	#exal_blockmapstatus_SE
	sta	exal_blockmapstatus,y

.noeffect

;----------------------------------------------------------------------------
; calc robo's body pos

	jsl	RB_setbodypos_srou_l

;----------------------------------------------------------------------------

	jsr	RBboyoyon_srou

; boyoyon

	s_add_alvars	W,x,al_worldy,y,exal_vyboyoyonY

; head shake

	pl_jmp_KAOinpool	x,.noshake

	s_add_alvars	W,x,al_worldy,y,exal_worldyoffset

.noshake


; add depth of pool

	a16
	lda	exal_bodyofsy,y
	sexa
	nega
	clc
	adc	al_worldy,x
	sta	al_worldy,x

; add offset (floating)

	lda	exal_bodyfloatofsy,y
	sexa
	clc
	adc	al_worldy,x
	sta	al_worldy,x

	a8

	PULLYP

	rtl


RB_setbodypos_srou_l

	PUSHYP

	s_start_strat

; calc robo's body pos

	toheap	y,x

	a16

	lda	exal_bodyofsy,y
	sexa
	nega
	clc
	adc	exal_worldy,y
	sta	exal_bodyworldy,y


	lda	exal_bodyfloatofsy,y
	sexa
	clc
	adc	exal_bodyworldy,y
	sta	exal_bodyworldy,y

	a8

.exit	PULLYP

	rtl

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	end of file
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	strats_end

	end
