;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º               Star Fox2                        º
;ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
;º     Nintendo.co.ltd EDA                        º
;º                                                º
;º     File  : tmacros.inc                        º
;º                                                º
;º     Descr : Kawagoe Takumi,s macro file        º
;º                                                º
;º     Author: Kawagoe Takumi Nintendo.co.ltd EDA º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PUSHYP	MACRO
	phy
	php
	ENDM

PULLYP	MACRO
	plp
	ply
	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PUSHXP	MACRO
	phx
	php
	ENDM

PULLXP	MACRO
	plp
	plx
	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PUSHXYP	MACRO
	phx
	phy
	php
	ENDM

PULLXYP	MACRO
	plp
	ply
	plx
	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PUSHXYPB	MACRO
	phb
	phx
	phy
	php
	ENDM

PULLXYPB	MACRO
	plp
	ply
	plx
	plb
	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
BANK7E	MACRO

;	IFNE	LONGA
;	error	<Must be in SHORTA>
;	ENDC

	lda	#7eH
	pha
	plb

	ENDM


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
CHK_SAMEOBJ		MACRO

	CHK_OBJ	\1
	CHK_OBJ	\2

	IFC	"\1","\2"
	error	<onaji obj wo tukattru!>
	ENDC

	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
toheap	MACRO	[obj,obj2]

MYNARG	=	NARG
	CHK_NARG	2

	IFC	"\1","\2"

	IFC	"\1","y"
	phx
	ldx	al_sword2,y
	txy
	plx
	ENDC

	IFC	"\1","x"
	phy
	ldy	al_sword2,x
	tyx
	ply
	ENDC

	ELSEIF


	IFC	"\1","x"
	ldx	al_sword2,y
	ENDC

	IFC	"\1","y"
	ldy	al_sword2,x
	ENDC


	ENDC

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

asrax	macro	[bit]
	cmp #1<<{bit}
	ror a
	endm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	PLAYER STRAT START
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; local macro

BGinitdat	macro	[stratmode,stratmode2,name]

	dw	{stratmode}&WM
	dw	{stratmode2}&WM
	;dw	{name}_Hofs	; H scroll(one screen mode)
	;dw	{name}_P1Hofs	; H scroll(two screen mode)
	;dw	{name}_P2Hofs	; H scroll(two screen mode)
	dw	{name}_VofsMAX
	dw	{name}_VofsRATE
;
;	;IFC	"0","{demomode}"
;	;dw	0
;	;ELSEIF
;	;dw	{demomode}&WM	;strat(demo mode)
;	;ENDC
;
	endm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
t_tranim_init	MACRO	[obj,tbl]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2


	EXG_IFY		{obj}


	a16
	lda	#{tbl}>>8
	sta	x1+1
	lda	#{tbl}&WM
	sta	x1
	a8

	jsl		initPLR_TRANSANIM_l


	EXG_IFY		{obj}

	stratmac_end

	ENDM


;--------------------------------------------------
t_tranim_do		MACRO	[obj,tbl,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3


	EXG_IFY		{obj}

	s_push_obj	x

	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC


	a16
	lda	exal_pilotNo,y


	IFNE	NARG-3
	ply
	ENDC


	and	#exal_pilotNo_plmask
	asl	a
	tax
	lda.l	{tbl},x
	sta	name
	a8

	s_pull_obj	x

	jsl		PLR_TRANSANIM_l

	EXG_IFY		{obj}

	stratmac_end

	ENDM
;--------------------------------------------------
;
;t_playerfly_mode	MACRO	[obj,name]
;
;	stratmac_start
;
;	EXG_IFY	{obj}
;
;	phy
;
; [SET EXALVARS]
;
;	ldy	al_sword2,x
;	s_set_alvar	W,y,exal_maxPmoveY,#{name}_PLRmaxY+{name}_seadepth	; player wldY limitter(MAN)
;	s_set_alvar	W,y,exal_minPmoveY,#{name}_PLRminY+{name}_seadepth	; player wldY limitter(MIN)
;
;	s_set_alvar	W,y,exal_midCmoveY,#-({name}_CAMmidY+{name}_seadepth)	; camera wldY limitter(MID)
;	s_set_alvar	B,y,exal_maxProtX,#{name}_PLRmaxrotX	; camera wldY limitter(MAX)
;	s_set_alvar	B,y,exal_minProtX,#{name}_PLRminrotX	; camera wldY limitter(MIN)
;
;	s_set_alvar	W,y,exal_altmeter_rate,#(({name}_BATTLEAREA_minY-{name}_BATTLEAREA_maxY+{name}_seadepth)/(altmeter_height/2))/2
;
; [ONE SCREEN & TWO SCREEN MODE]
;
;	test_screenmode	onescreen
;	beq		.two\@
;.one\@	;s_set_alvar	B,y,exal_camYofsMAX,#{name}_camYofsMAX_1	; camera max Y offset to Arwing
;	;s_set_alvar	B,y,exal_maxCrotX,#{name}_CAMmaxrotX_1	; camera wldY limitter(MAX)
;	;s_set_alvar	B,y,exal_minCrotX,#{name}_CAMminrotX_1	; camera wldY limitter(MIN)
;	;s_set_alvar	B,y,exal_camYofsrate,#{name}_camYofsrate_1
;	bra		.ot\@
;.two\@	;s_set_alvar	B,y,exal_camYofsMAX,#{name}_camYofsMAX		; camera max Y offset to Arwing
;	;s_set_alvar	B,y,exal_maxCrotX,#{name}_CAMmaxrotX	; camera wldY limitter(MAX)
;	;s_set_alvar	B,y,exal_minCrotX,#{name}_CAMminrotX	; camera wldY limitter(MIN)
;	;s_set_alvar	B,y,exal_camYofsrate,#{name}_camYofsrate
;.ot\@
;
; [SET RAM VALUE]
;
;	;s_set_var	W,BATTLEAREA_maxY,#{name}_BATTLEAREA_maxY-{name}_seadepth
;	;s_set_var	W,BATTLEAREA_minY,#{name}_BATTLEAREA_minY-{name}_seadepth
;	;s_set_var	W,seadepth,#{name}_seadepth
;
; -- vars init --
;
;	s_copy_alvar2alvar	B,y,exal_oldHP,x,al_HP
;
;
;	ply
;
;	EXG_IFY	{obj}
;
;	stratmac_end
;	ENDM

;-----------------------------------------------------------------------------
test_playerdead	macro	p1/p2
MYNARG	=	NARG
	CHK_NARG	1
	lda		p\1_status
	and		#p\1_status_HP0
	endm
;-----------------------------------------------------------------------------
test_playergameend	macro	p1/p2
MYNARG	=	NARG
	CHK_NARG	1
	lda		p\1_status
	and		#p\1_status_gameend
	endm
;-----------------------------------------------------------------------------
set_bg_mode	macro	[tab,num,idx,max]

	stratmac_start

	phy
	phx

	ldy	al_sword2,x

	;stx	tpx	; store

	ai16
	lda	{num}
	and	#0ffH
	cmp	#{max}+1
	bcc	.skip\@
	lda	#0
.skip\@	asl	a
	ta{idx}
	lda.l	{tab},{idx}
	tax

.aw\@	lda.l	{tab}&0ff0000H+0,{idx}
	sta	exal_controlmode,y
	sta	x1
	bra	.mode\@

.rb\@	lda.l	{tab}&0ff0000H+2,{idx}
	sta	exal_controlmode,y
	sta	x1
.mode\@

	;a8
	;phx
	;ldx	tpx
	;s_jmp_alsflag	{idx},player2,.p2\@
	;plx
	;lda		p1_gamestatus
	;bra		.pp\@
.p2\@	;plx
	;lda		p2_gamestatus
.pp\@	;a16

	;bne		.skip3\@

	;lda.l	{tab}&0ff0000H+12,{idx}
	;beq	.skip3\@
	;sta	x1


.skip3\@	;sm_jmp_if2screen	.skip1\@

.skip0\@	;lda.l	{tab}&0ff0000H+2,{idx}
	;bra	.skip2\@


.skip1\@	;lda.l	{tab}&0ff0000H+4,{idx}
.skip2\@	;sta	player1_horizon_offset
	;lda.l	{tab}&0ff0000H+6,{idx}
	;sta	player2_horizon_offset

	lda.l	{tab}&0ff0000H+4,{idx}
	sta	vscrollofsmax
	lda.l	{tab}&0ff0000H+6,{idx}
	sta	vscrollofsrate

	a8

	plx
	ply

	jsl	modechangesrou_l
	jmp	PLAYERMAIN.strat

	stratmac_end

	endm

;-----------------------------------------------------------------------------
pl_generaldynamics	macro	[obj,hobj]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1,2

	pl_jmpNOT_ifinthesea	x,.ground\@

	a16
	lda	#1
	sta	gd_gravity
	a8
	EXG_IFY		{obj}


	IFNE	NARG-2
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\2
	ENDC


	lda	exal_jmpstatus2,y
	phy
	and	#exal_jmpstatus2_Goff
	jsl	generaldynamics_l
	ply

	s_set_alvar	W,y,exal_getheight_WY,y1
	s_set_alvar	W,y,exal_slopenumB,closestslopenum


	IFNE	NARG-2
	ply
	ENDC


	EXG_IFY		{obj}

	s_bra	.copy\@


.ground\@
	a8

	EXG_IFY		{obj}

	IFNE	NARG-2
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\2
	ENDC

	lda	exal_gravity+1,y
	sta	gd_gravity


	lda	exal_jmpstatus2,y
	and	#exal_jmpstatus2_Goff
	phy
	jsl	generaldynamics_l
	ply

	s_set_alvar	W,y,exal_getheight_WY,y1
	s_set_alvar	W,y,exal_slopenumB,closestslopenum

	IFNE	NARG-2
	ply
	ENDC

	EXG_IFY		{obj}

.copy\@

	stratmac_end
	endm

;-----------------------------------------------------------------------------
;pl_MARINEgeneraldynamics	macro	[obj,hobj]
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	1,2
;
;	a16
;	lda	#1
;	sta	gd_gravity
;	a8
;
;	EXG_IFY		{obj}
;
;	IFEQ	NARG-2
;	CHK_SAMEOBJ	\1,\2
;	phy
;	ldy	al_sword2,x
;	ENDC
;
;
;	lda		exal_jmpstatus2,y
;
;	and	#exal_jmpstatus2_Goff
;	jsl	generaldynamics_l
;
;	IFEQ	NARG-3
;	ply
;	ENDC
;
;	EXG_IFY		{obj}
;
;	s_jmp_alsflag		x,player2,.p2\@
;.p1\@	s_copy_var2var		W,p1_getheight_WY,y1
;	bra			.pp\@
;.p2\@	s_copy_var2var		W,p2_getheight_WY,y1
;.pp\@
;
;	stratmac_end
;	endm
;
;-----------------------------------------------------------------------------

pl_planetmode	macro	[name]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1
	lda	planet_mode
	and	#~planet_mode_ALL
	ora	#pm_{name}
	sta	planet_mode

	stratmac_end
	endm


pl_test_planetmode	macro	[name]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1
	lda	planet_mode
	and	#planet_mode_ALL
	cmp	#pm_{name}
	stratmac_end
	endm


pl_jmp_planetmode	macro	[name,label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	lda	planet_mode
	and	#planet_mode_ALL
	cmp	#pm_{name}
	rlbeq	{label}

	stratmac_end
	endm

;-----------------------------------------------------------------------------
;pl_spline	macro	[obj,KEYalvar,Talvar,DATADR,rotyofs]
;
;	KEYalvar	: KEY  data pointer	(byte)
;	Talvar		: time counter(T)	(byte)
;	DATADRalvar	: spline data address	(word)
;
;	Out		: spl_x		worldx
;			: spl_y		worldy
;			: spl_z		worldz
;			: spl_divx	div worldx
;			: spl_divy	div worldy
;			: spl_divz	div worldz
;
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	5
;
;	phx
;	phy
;	EXG_IFY		{obj}
;
;	s_copy_var2var		B,y1,{rotyofs}
;	s_copy_alvar2var	B,x,x2,{KEYalvar}	;
;	s_copy_alvar2var	B,x,y2,{Talvar}		;
;	phx
;	txy
;	lda			y1		;roty offset
;	ldx			#{DATADR}&WM	; data address
;	ldy			#%11111111
;	jsl			spline_l
;	plx
;	s_set_alvar		B,x,al_pbyte1,x2
;	s_set_alvar		B,x,al_sbyte1,y2
;
;	ply
;	plx
;
;	stratmac_end
;	ENDM
;
;-----------------------------------------------------------------------------
;pl_spline_divrotx	macro	[divxvar,divyvar,var]
;	divxvar	(word)
;	divyvar	(word)
;	var	(byte)
;
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	3
;
;
;	a16
;	lda	{divxvar}
;	sta	y1
;	lda	{divyvar}
;	sta	x1
;	a8
;
;;	jsl	call_mcallarctan16_l
;
;	jsl	call_arctan16_l
;
;
;	lda	x1+1
;	nega
;	sta	{var}
;
;	stratmac_start
;	ENDM
;-----------------------------------------------------------------------------
;pl_spline_divroty	macro	[divxvar,divzvar,var]
;	divxvar	(word)
;	divzvar	(word)
;	var	(byte)
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	3
;
;
;	a16
;	lda	{divxvar}
;	sta	y1
;	lda	{divzvar}
;	sta	x1
;
;	jsl	call_arctan16_l
;
;;	jsl	call_mcallarctan16_l
;
;	a8
;
;
;	lda	x1+1	;.l	m_cnt+1
;	clc
;	adc	#-64+128
;	sta	{var}
;
;	PLMARIORAM_OFF
;
;	stratmac_end
;	ENDM
;-----------------------------------------------------------------------------
;pl_spline_divrotxEX	macro	[divxvar,divyvar,var]
;	divxvar	(word)
;	divyvar	(word)
;	var	(byte)
;
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	3
;
;	a16
;	lda	#4000H	;{divxvar}
;	sta.l	y1
;	lda	{divyvar}
;	sta.l	x1
;
;;	a8
;
;	jsl	call_arctan16_l
;;	jsl	call_mcallarctan16_l
;
;	a8
;
;
;	lda.l	x1+1	;m_cnt+1
;	nega
;	sta	{var}
;
;
;	stratmac_start
;	ENDM
;-----------------------------------------------------------------------------
;pl_jmp_varLESSus		MACRO	[size,var,value,label]
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	4
;	CHG_MODE	\1
;
;	lda.\0	\2
;	cmp	\3
;	CHG_MODEBACK	\1
;	rlbcc	\4
;		stratmac_end
;	ENDM
;-----------------------------------------------------------------------------
pl_abs_var	macro	[size,var]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	CHG_MODE	{size}
	lda	{var}
	bpl	.skip\@
	eor	#-1h
	inc	a
	sta	{var}
.skip\@
	CHG_MODEBACK	{size}
	stratmac_end
	endm
;-----------------------------------------------------------------------------
pl_eor_alvar	MACRO	; size,obj1,var,value
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4
	CHK_OBJ		\2
	CHG_MODE	\1
	s_lda.w	\3,\2
	eor	\4
	s_sta.w	\3,\2
	CHG_MODEback	\1
	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_p2_coltab	macro	[obj,coltab]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ		\1

	EXG_IFY	{obj}

	jsl	playercoltab_srou_l

	EXG_IFY	{obj}

	stratmac_end
	endm
;------------------------------------------------------------------------
pl_jmp_NOTLRkeydown	macro	[status,label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	lda	{status}
	and	#pad_tleft+pad_tright
	rlbeq	{label}
	stratmac_end
	endm
;------------------------------------------------------------------------
pl_jmp_LRkeydown	macro	[status,label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	lda	{status}
	and	#pad_tleft+pad_tright
	rlbne	{label}
	stratmac_end
	endm
;------------------------------------------------------------------------
pl_jmp_keydown	macro	[key,status,label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	testjoypad	{key},{status}
	s_bne	{label}
	stratmac_end

	endm
;------------------------------------------------------------------------
pl_jmp_NOTkeydown	macro	[key,status,label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3
	testjoypad	{key},{status}
	s_beq	{label}
	stratmac_end
	endm
;------------------------------------------------------------------------
sm_ifpartnerdead	macro	[label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	player_friend
	bit	#80h
	rlbne	{label}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
; check views.asm

pl_smult816A16	macro	[var,var16,var8]

;
;	var(16bit) = {var16(16bit) * var8(8bit)}/100H

;	using	:x1,x2,tpx,tpy,y1,y2 as temp
;	mode 	:a8i16

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	a16
	lda	{var8}
	sexa
	sta	x1
	lda	{var16}
	sta	x2
	a8

	jsl	Pcalc_muls161632_l

	lda	y1+1
	sta	{var}
	lda	y1+2
	sta	{var}+1

	stratmac_end

	endm
;--------------------------------------------------
pl_ldy_viewblk	macro	[obj1]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	;**s_jmp_alsflag	{obj1},player2,.skip0\@
	ldy	#viewblk1
	;**bra	.skip1\@
.skip0\@
	;**ldy	#viewblk2
.skip1\@

	endm
;----------------------------------------
pl_ldx_viewblk	macro	[obj1]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	;**s_jmp_alsflag	{obj1},player2,.skip0\@
	ldx	#viewblk1
	;**bra	.skip1\@
.skip0\@
	;**ldx	#viewblk2
.skip1\@
	stratmac_end
	endm
;----------------------------------------
; var3 <- var1(16bit)*var2(8bit)

pl_mult_168	macro	[var3,var1,var2]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3


	phx
	phy

	i8
	phb
	lda	#0
	pha
	plb
	mulslog168 {var1},{var2}
	plb

	i16

	ply
	plx

;	ldy	tpy
;	ldx	tpx

	lda	m4
	sta	{var3}+0
	lda	m5
	sta	{var3}+1

	stratmac_end
	endm

;----------------------------------------
pl_roty_xvec16div2	macro	[vecx2,vecz2,vecx,ang]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4

	s_set_var	W,x1,{vecx}
	s_set_var	W,z1,#0

	lda		{ang}
	jsl		rotate_16xz_l


	a16
	lda		x2
	asra
	sta		{vecx2}
	lda		z2
	asra
	sta		{vecz2}
	a8

	stratmac_end
	ENDM


;---------------------------------------------------------------
;pl_rotxy_zvec16	macro	[vecx2,vecy2,vecz2,vecz,angx,angy]
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	6
;
;	a16
;
;	lda	#0
;	sta	x1
;	sta	x2
;	sta	y1
;	sta	y2
;	lda	{vecz}
;	sta	z1
;	sta	z2
;
;	a8
;	lda	{angx}	;al_rotx,\4
;	jsl	rotate_16yz_l
;	a16
;	lda	x2
;	sta	x1
;	lda	y2
;	sta	y1
;	lda	z2
;	sta	z1
;
;	a8
;	lda	{angy}	;al_roty,\4
;	jsl	rotate_16xz_l
;
;	a16
;	lda	x2
;	sta	{vecx2}
;	lda	z2
;	sta	{vecz2}
;	lda	y2
;	sta	{vecy2}
;	a8
;
;	stratmac_end
;
;	ENDM
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;---------------------------------------------------------------------
;	macros for KEY
;---------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
pl_set_LASTLRkey	macro

	stratmac_start

	jsl	setlastLRflag_srou_l

	stratmac_end

	ENDM

;---------------------------------------------------------------------
pl_set_exalKEY	macro

	stratmac_start

	jsl	set_exalkey_l

	stratmac_end

	ENDM

;---------------------------------------------------------------------
pl_jmp_LASTLRkey	macro	[obj,Llabel,Rlabel,nolabel,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	4,5

	EXG_IFY	{obj}

	IFNE	NARG-5
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\5
	ENDC

	lda	exal_LASTLR,y

	IFNE	NARG-5
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#exal_LASTLR_L
	rlbne	{Llabel}

	bit	#exal_LASTLR_R
	rlbne	{Rlabel}

	jmp	{nolabel}

	stratmac_end

	ENDM
;---------------------------------------------------------------------
pl_jmp_LASTLdown	macro	[obj,Llabel,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_LASTLR,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#exal_LASTLR_L
	rlbne	{Llabel}

	stratmac_end

	ENDM

;---------------------------------------------------------------------
pl_jmp_LASTRdown	macro	[obj,Rlabel,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_LASTLR,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#exal_LASTLR_R
	rlbne	{Rlabel}

	stratmac_end

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;---------------------------------------------------------------------
;	macros for EXAL_KEYBUTTON
;---------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
TM_TESTEXBUTTON	MACRO	[obj,key,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-2
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\2
	ENDC

	IFEQ	pad_{key}>>8
	lda	exal_keybutton,y
	ELSEIF
	lda	exal_keybutton+1,y
	ENDC

	IFNE	NARG-2
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#padl_{key}

	stratmac_end

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; var <- var(16bit)*sin(ang8bit)
;
tf_sin_var16	macro	[size,var,angle]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_copy_var2var	B,x1,{angle}

	a16
	lda	{var}
	sta	x2
	a8

	jsl	calc_sin16_l

	CHG_MODE	{size}
	lda	y1+1
	sta	{var}
	CHG_MODEBACK	{size}

	stratmac_end

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; var <- var(16bit)*cos(ang8bit)
;
tf_cos_var16	macro	[size,var,angle]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_copy_var2var	B,x1,{angle}

	a16
	lda	{var}
	sta	x2
	a8

	jsl	calc_cos16_l

	CHG_MODE	{size}
	lda	y1+1
	sta	{var}
	CHG_MODEBACK	{size}

	stratmac_end

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	strat macros for PLAYER
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
pl_control	macro	[obj,onoff,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	IFC	"on","\2"
	s_or_alvar	B,y,exal_control,#exal_control_on
	ENDC

	IFC	"off","\2"
	s_and_alvar	B,y,exal_control,#exal_control_on^-1
	ENDC

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	ENDM






pl_jmp_ifcontroloff	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3
	EXG_IFY	{obj}
	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC
	lda	exal_control,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}
	bit	#exal_control_on
	rlbeq	{label}
	stratmac_end
	ENDM


pl_jmp_ifcontrolon	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3
	EXG_IFY	{obj}
	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC
	lda	exal_control,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}
	bit	#exal_control_on
	rlbne	{label}
	stratmac_end
	ENDM

;---------------------------------------------------------------------
; ARMER no ARM no kaiten no oto

pl_armrollsound	macro	[obj,onoff,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	IFC	"on","\2"
	s_or_alvar	B,y,exal_jetstatus,#exal_jetstatus_armrollsound
	ENDC

	IFC	"off","\2"
	s_and_alvar	B,y,exal_jetstatus,#exal_jetstatus_armrollsound^-1
	ENDC

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	ENDM

;--------------------------------------------------
pl_copy_alsflag	macro	[toobj,obj,flag]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_alsflag	{obj},{flag},.set\@
	s_clr_alsflag	{toobj},{flag}
	bra		.exit\@
.set\@	s_set_alsflag	{toobj},{flag}
.exit\@
	stratmac_end
	ENDM
;--------------------------------------------------
; MACRO for ARWING'S BRAKE

pl_jmpNOT_ifarmrollsound	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_jetstatus,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#exal_jetstatus_armrollsound
	rlbeq	{label}

	stratmac_end
	ENDM

;---------------------------------------------------------------------
; read controller

pl_playercontroller	macro	[obj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}

	jsl	playercontroller_srou_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;---------------------------------------------------------------------
;	strat macros for PLAYER
;---------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PL_DO_CTLandVIEW	macro	[obj,name]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY		{obj}

	;***sm_jmp_if1screen	.one\@
	;***s_jmpnot_alsflag	{obj},player2,.two\@

.one\@	jsl	{name}_CTL_l
	jsr	do_viewstrat_srou
	;***bra	.exit\@

.two\@	;***jsr	do_viewstrat_srou
	;***jsl	{name}_CTL_l


.exit\@	EXG_IFY		{obj}

	stratmac_end
	ENDM

;-------------------------------------------------------------
;pl_jmp_ifonescreen	macro	[label]
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	1
;	test_screenmode	onescreen
;	rlbne	{label}
;	stratmac_end
;	ENDM
;-------------------------------------------------------------
;pl_jmp_iftwoscreen	macro	[label];
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	1
;	test_screenmode	onescreen
;	rlbeq	{label}
;	stratmac_end
;	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	BOSS macro
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
pl_set_BOSSonflag	macro

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	0

	lda	BOSSstatus
	ora	#BOSSstatus_on
	sta	BOSSstatus

	stratmac_end
	ENDM

pl_set_BOSSonflag2	macro

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	0

	lda	BOSSstatus
	ora	#BOSSstatus_on2
	sta	BOSSstatus

	stratmac_end
	ENDM

pl_clr_BOSSonflag	macro

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	0

	lda	BOSSstatus
	and	#~BOSSstatus_on
	sta	BOSSstatus

	stratmac_end
	ENDM

pl_clr_BOSSonflag2	macro

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	0


	lda	BOSSstatus
	and	#~BOSSstatus_on2
	sta	BOSSstatus

	stratmac_end
	ENDM

;-------------------------------------------------------------
pl_jmp_ifBOSSon	macro	[label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	lda	BOSSstatus
	bit	#BOSSstatus_on
	rlbne	{label}
	stratmac_end
	ENDM

pl_jmp_ifBOSSon2	macro	[label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	lda	BOSSstatus
	bit	#BOSSstatus_on2
	rlbne	{label}
	stratmac_end
	ENDM

;-------------------------------------------------------------
pl_jmpNOT_ifBOSSon	macro	[label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	lda	BOSSstatus
	bit	#BOSSstatus_on
	rlbeq	{label}
	stratmac_end
	ENDM
;-------------------------------------------------------------
pl_set_BOSSdead	macro

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	0

	lda	BOSSstatus
	ora	#BOSSstatus_dead
	sta	BOSSstatus

	stratmac_end
	ENDM
;-------------------------------------------------------------
;
;pl_hpadd	macro	[obj]
;
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	1
;
;	IFC	"y","\1"
;	exg_xy
;	ENDC
;
;	jsl	player_hpadd_l
;
;	IFC	"y","\1"
;	exg_xy
;	ENDC
;
;	stratmac_end
;	ENDM
;
;-------------------------------------------------------------
test_PLtarget	macro	p1/p2
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda.l	\1_hudrot+1
	bit	#80H

	stratmac_end
	ENDM
;-------------------------------------------------------------
pl_nohittimer_dec	macro	[obj]		; value gameflame*2
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}

	jsl	decnohit_srou_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM


pl_coll_damage	macro	[obj]	;,nohittimevalue,camrotxshockvalue]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY		{obj}

	jsl	colldamage_srou_l

	EXG_IFY		{obj}

	stratmac_end

	ENDM

pl_set_nohitRISE	macro	[obj,value,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	{value}
	sta	exal_nohitRISE,y


	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end

	ENDM

;-------------------------------------------------------------
;pl_DMGMETER_init	macro	[obj,Num,hobj]
;
;;		Num :number of damage meter lamp
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	2,3
;
;	IFC	"y","\1"
;	phx
;	tyx
;	ENDC
;
;	IFNE	NARG-3
;	phy
;	ldy	al_sword2,x
;	ELSEIF
;	CHK_SAMEOBJ	\1,\3
;	ENDC
;
;	sm_jmp_if2screen	.battle\@
;
;.mission\@
;	lda	#{Num}*4
;	bra	.skip\@
;
;.battle\@	lda	#0	;{Num}*8
;.skip\@	sta	KHP,y
;
;	IFNE	NARG-3
;	ply
;	ENDC
;
;	IFC	"y","\1"
;	plx
;	ENDC
;
;	stratmac_end
;	ENDM
;-------------------------------------------------------------
pl_set_p1p2var	macro	[size,obj,var1,var2]

;		Num :number of damage meter lamp
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	4

	;***s_jmp_alsflag	{obj},player2,.p2\@

.p1\@	s_set_var	{size},p1_{var1},{var2}
	;***bra		.exit\@
.p2\@	;***s_set_var	{size},p2_{var1},{var2}

.exit\@

	stratmac_end
	ENDM
;--------------------------------------------------
pl_goto_height	macro	[obj,alvar,height,rate]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	4

	EXG_IFY	{obj}

	s_set_var	W,y1,{height}
	jsl		gotoheight_srou_l
	s_achase_alvar	B,x,{alvar},x1,{rate}

	EXG_IFY	{obj}

	stratmac_end
	ENDM
;--------------------------------------------------
; MACRO for SPACE ROBOT

pl_jet	macro	[obj,switch,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3


	IFC	"on","\2"

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC


	;;;jsl	makejet_srou_l
	lda	exal_jetstatus2,y
	ora	#exal_jetstatus2_on
	sta	exal_jetstatus2,y

	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}

	ENDC


	IFC	"off","\2"

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_jetstatus2,y
	and	#(exal_jetstatus2_on!exal_jetstatus2_Lset!exal_jetstatus2_Rset)^-1
	sta	exal_jetstatus2,y

	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}

	ENDC


	IFC	"check","\2"

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_jetstatus2,y

	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}

	bit	#exal_jetstatus2_on

	ENDC

	stratmac_end

	ENDM

;--------------------------------------------------
; MACRO for ARWING'S SPLASH!
pl_splash	macro	[obj,x,z,initcolanim,scale]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	5

	EXG_IFY		{obj}

	s_set_var	B,x1,{x}
	s_set_var	B,z1,{z}
	s_set_var	B,y1,{initcolanim}
	s_set_var	B,y2,{scale}
	stx		x2

	pl_jmp_ifonthe	x,water,.w\@
	pl_jmp_ifonthe	x,magma,.m\@
	jsl		makesmokeryusa_srou_l
	bra		.skip\@
.m\@	jsl		makeMsplashpool_srou_l
	bra		.skip\@
.w\@	jsl		makesplashpool_srou_l

.skip\@
	EXG_IFY		{obj}

	stratmac_end
	endm
;--------------------------------------------------
; MACRO for ARWING'S "SUPER"BOOST

pl_Sboost	macro	[obj,onoff]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2


	EXG_IFY		{obj}

	jsl	tp_boost{onoff}_srou_l

	EXG_IFY		{obj}


	stratmac_end
	ENDM
;--------------------------------------------------
; MACRO for ARWING'S "SUPER"BRAKE

pl_Sbrake	macro	[obj,onoff]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY		{obj}

	jsl	tp_brake{onoff}_srou_l

	EXG_IFY		{obj}

	stratmac_end
	ENDM

;--------------------------------------------------
; MACRO for ARWING'S BRAKE
;
;pl_jmp_ifbrakeTurn	macro	[obj,label,hobj]
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2,3
;
;	IFC	"y","\1"
;	phx
;	tyx
;	ENDC
;
;
;	IFC	"exal","\1"
;	lda	exal_control,y
;	ELSEIF
;	lda	exal_control,y
;
;	IFEQ	NARG-3
;	PHY
;	ldy	al_sword2,x
;	ELSEIF
;	CHK_SAMEOBJ	\1,\3
;	ENDC
;
;;	phy
;;	ldy	al_sword2,x
;
;	lda	exal_control,y
;
;	IFEQ	NARG-3
;	ply
;	ENDC
;
;
;	ENDC
;
;
;	IFC	"y","\1"
;	plx
;	ENDC
;
;	bit	#exal_control_brakeTurn
;	rlbne	{label}
;
;	stratmac_end
;	ENDM
;
;
;pl_jmpNOT_ifbrakeTurn	macro	[obj,label,hobj]
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2,3
;
;	IFC	"y","\1"
;	phx
;	tyx
;	ENDC
;
;
;	IFC	"exal","\1"
;	lda	exal_control,y
;	ELSEIF
;
;	IFEQ	NARG-3
;	PHY
;	ldy	al_sword2,x
;	ELSEIF
;	CHK_SAMEOBJ	\1,\3
;	ENDC
;;	phy
;;	ldy	al_sword2,x
;
;	lda	exal_control,y
;
;	IFEQ	NARG-3
;	ply
;	ENDC
;
;	ENDC
;
;	IFC	"y","\1"
;	plx
;	ENDC
;
;	bit	#exal_control_brakeTurn
;	rlbeq	{label}
;
;	stratmac_end
;	ENDM
;--------------------------------------------------
; MACRO for ROBOT'S JUMP

pl_jmp_ifjmp		macro	[obj,label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2

	s_jmpNOT_alsflag	{obj},ontheground,{label}

	stratmac_end
	ENDM



pl_jmpNOT_ifjmp	macro	[obj,label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2

	s_jmp_alsflag	{obj},ontheground,{label}

	stratmac_end
	ENDM

;--------------------------------------------------
; MACRO for PLAYER

pl_jmp_ifPLinSCREEN	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

;	phy
;	ldy	al_sword2,x
	lda	exal_enemyaltmeter_status,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	and	#3fH	; CUR TYPE 0 = inside screen
	rlbeq	{label}

	stratmac_end
	ENDM
;--------------------------------------------------
; MACRO for PLAYER

pl_jmpNOT_ifPLinSCREEN	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}


	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

;	phy
;	ldy	al_sword2,x
	lda	exal_enemyaltmeter_status,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	and	#3fH	; CUR TYPE 0 = inside screen
	rlbne	{label}


	stratmac_end
	ENDM
;--------------------------------------------------
; MACRO for ARWING'S BRAKE

pl_jmp_ifbrake	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	IFC	"y","\1"
	phx
	tyx
	ENDC

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

;	phy
;	ldy	al_sword2,x
	lda	exal_control,y

	IFNE	NARG-3
	ply
	ENDC


	IFC	"y","\1"
	plx
	ENDC

	bit	#exal_control_brake
	rlbne	{label}

	stratmac_end
	ENDM


;--------------------------------------------------
; MACRO for ARWING'S BRAKE

pl_jmpNOT_ifbrake	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	IFC	"y","\1"
	phx
	tyx
	ENDC


	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

;	phy
;	ldy	al_sword2,x
	lda	exal_control,y
	IFNE	NARG-3
	ply
	ENDC

	IFC	"y","\1"
	plx
	ENDC

	bit	#exal_control_brake
	rlbeq	{label}

	stratmac_end
	ENDM

;--------------------------------------------------
; MACRO for ARWING'S BOOST METER

pl_jmp_ifboostdisp	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_brake,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_brake_timer
	rlbne	{label}


	stratmac_end
	ENDM

pl_jmpnot_ifboostdisp	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_brake,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_brake_timer
	rlbeq	{label}


	stratmac_end
	ENDM

;--------------------------------------------------
; MACRO for ARWING'S BRAKE

pl_jmp_ifboost	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_control,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#exal_control_boost
	rlbne	{label}

	stratmac_end
	ENDM

;--------------------------------------------------
; MACRO for ARWING'S BRAKE

pl_jmpNOT_ifboost	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	IFC	"y","\1"
	phx
	tyx
	ENDC


	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

;	phy
;	ldy	al_sword2,x

	lda	exal_control,y


	IFNE	NARG-3
	ply
	ENDC

	IFC	"y","\1"
	plx
	ENDC

	bit	#exal_control_boost
	rlbeq	{label}

	stratmac_end
	ENDM

;--------------------------------------------------
; MACRO for ARWING'S BRAKE
;
;pl_jmp_ifoverheat	macro	[obj,label,hobj]
;
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2,3
;
;	IFC	"y","\1"
;	phx
;	tyx
;	ENDC
;
;
;	IFNE	NARG-3
;	PHY
;	ldy	al_sword2,x
;	ELSEIF
;	CHK_SAMEOBJ	\1,\3
;	ENDC
;
;
;	lda	exal_control,y
;
;	IFNE	NARG-3
;	ply
;	ENDC
;
;	IFC	"y","\1"
;	plx
;	ENDC
;
;	bit	#exal_control_overheat
;	rlbne	{label}
;
;	stratmac_end
;	ENDM
;
;--------------------------------------------------
; MACRO for ARWING'S BRAKE
;
;pl_jmpNOT_ifoverheat	macro	[obj,label,hobj]
;
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2,3
;
;	IFC	"y","\1"
;	phx
;	tyx
;	ENDC
;
;
;	IFNE	NARG-3
;	PHY
;	ldy	al_sword2,x
;	ELSEIF
;	CHK_SAMEOBJ	\1,\3
;	ENDC
;	lda	exal_control,y
;	IFNE	NARG-3
;	ply
;	ENDC
;
;	IFC	"y","\1"
;	plx
;	ENDC
;
;	bit	#exal_control_overheat
;	rlbeq	{label}
;
;	stratmac_end
;	ENDM
;
;--------------------------------------------------
; MACRO for PLAYER

pl_burn	macro	[obj,onoff,LCR,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\4
	ENDC

; LCR = L , R , C , ALL

	IFC	"on","\2"
	s_or_alvar	B,y,exal_dmgeffect,#exal_dmgeffect_burnning_{LCR}
	ENDC

	IFC	"off","\2"
	s_and_alvar	B,y,exal_dmgeffect,#exal_dmgeffect_burnning_{LCR}^-1
	ENDC


	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	ENDM
;--------------------------------------------------
pl_jmp_ifdush	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC
;	phy
;	ldy	al_sword2,x
	lda	exal_motiondir,y
	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#RB_dush!RB_dush2
	rlbne	{label}

	stratmac_end
	ENDM

;--------------------------------------------------
pl_jmpNOT_ifdush	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC
;	phy
;	ldy	al_sword2,x
	lda	exal_motiondir,y
	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#RB_dush
	rlbeq	{label}

	stratmac_end
	ENDM

;--------------------------------------------------
;pl_boostinc	macro
;	jsr	tp_boostinc
;	endm
;--------------------------------------------------
pl_PILOTNo	macro	[obj,plrtype,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	IFC	"y","\1"
	phx
	tyx
	ENDC

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC
;	phy
;	ldy	al_sword2,x
	lda	exal_pilotNo,y
	and	#exal_pilotNo_plmask^-1
	ora	#ep_{plrtype}
	sta	exal_shapeNo+1,y
	IFNE	NARG-3
	ply
	ENDC

	IFC	"y","\1"
	plx
	ENDC

	stratmac_end
	endm

pl_jmp_PILOT	macro	[obj,type,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	sp_jmp_PILOT	{obj},#ep_{type},{label},\4

	stratmac_end
	endm


pl_jmpNOT_PILOT	macro	[obj,type,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	sp_jmpnot_PILOT	{obj},#ep_{type},{label},\4

	stratmac_end
	endm



sp_jmp_PILOT	macro	[obj,type,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4


	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\4
	ENDC
	lda	exal_pilotNo,y

	IFNE	NARG-4
	ply
	ENDC


	EXG_IFY	{obj}


	cmp	{type}
	rlbeq	{label}
	stratmac_end
	endm


sp_jmpnot_PILOT	macro	[obj,type,label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\4
	ENDC

	lda	exal_pilotNo,y

	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	cmp	{type}
	rlbne	{label}
	stratmac_end
	endm

pl_jmp_shape	macro	[obj,type,label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\4
	ENDC

	lda	exal_pilotNo,y
	and	#%11111110
	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	cmp	#ep_{type}
	rlbeq	{label}
	stratmac_end
	endm

pl_jmpnot_shape	macro	[obj,type,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\4
	ENDC

	lda	exal_pilotNo,y
	and	#%11111110
	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	cmp	#ep_{type}
	rlbne	{label}
	stratmac_end
	endm


pl_lda_PILOTNoFSG	macro	[obj,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1,2


	EXG_IFY	{obj}

	IFNE	NARG-2
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\2
	ENDC

	lda	exal_pilotNo,y
	and	#%11111110

	IFNE	NARG-2
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	endm


;--------------------------------------------------
pl_set_PILOTshape	macro	[plobj,setobj,table]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY		{plobj}

	s_push_obj	x

	jsl	get_shapeNotoidx_W_l

	a16

	lda.l	{table},x
	s_pull_obj	x

	EXG_IFY		{plobj}

	sta.w	al_shape,{setobj}
	a8

	stratmac_end
	endm
;--------------------------------------------------
pl_SHAPEandCTLNo	macro	[obj,ctltype,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	IFC	"y","\1"
	phx
	tyx
	ENDC

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	#PMODE_{ctltype}
	sta	PMODE

	lda	#(st_{ctltype}<<4)!ct_{ctltype}
	sta	exal_shapeNo,y
	IFNE	NARG-3
	ply
	ENDC

	IFC	"y","\1"
	plx
	ENDC

	stratmac_end
	endm
;--------------------------------------------------
pl_set_area	macro	[obj,area]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2

	s_set_alvar	B,{obj},al_area,#{area}

	stratmac_end
	endm
;--------------------------------------------------
sp_jmp_playerctl	macro	[obj,type,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\4
	ENDC

;	phy
;	ldy	al_sword2,x
	lda	exal_shapeNo,y
	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_shapeNo_ctmask

	cmp	#ct_{type}
	rlbeq	{label}

	stratmac_end
	endm

;--------------------------------------------------
sp_jmp_playertype	macro	[obj,type,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\4
	ENDC

;	phy
;	ldy	al_sword2,x
	lda	exal_shapeNo,y
	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_shapeNo_stmask

	cmp	#type_{type}<<4
	rlbeq	{label}
	stratmac_end
	endm

;--------------------------------------------------
sp_weap_power	macro	[obj,switch,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	IFC	"off","\2"
	lda	exal_weap_powerflag,y
	ora	#exal_weap_powerflag_mi
	and	#~exal_weap_powerflag_pl
	sta	exal_weap_powerflag,y
	ENDC

	IFC	"on","\2"
	lda	exal_weap_powerflag,y
	ora	#exal_weap_powerflag_pl
	sta	exal_weap_powerflag,y
	ENDC


	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	endm

;--------------------------------------------------
;sp_jmp_playerdir	macro	[obj,1or2,labelcenter,labelleft,labelright]
;
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	5
;
;	EXG_IFY		{obj}
;
;	phy
;	ldy	#viewblk{1or2}
;;	jsl	calc_dir2player_srou_l
;	jsl	TSTRATsrous_l.getdirection
;	ply
;
;	EXG_IFY		{obj}
;
;	bit	#40H	; mae or usio?
;	rlbeq	{labelcenter}
;	bit	#80H	; left or right ?
;	rlbne	{labelright}
;	jmp	{labelleft}
;
;	stratmac_end
;
;	endm
;--------------------------------------------------
sp_jmp_playerfullHP	macro	[obj,label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	PHY
	toheap	y,x
	lda	exal_HP,y
	PLY

	EXG_IFY	{obj}

	cmp	P1_maxHP	;#player_HP
	rlbeq	{label}



	stratmac_end
	endm

;--------------------------------------------------
; Arwing ga kabe ni hit suruka douka no flag (tunnel mode)

sp_vscroll	macro	[obj,onoff,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC


	IFC	"on","\2"
	s_and_alvar		B,y,exal_VIEWflag3,#exal_VIEWflag3_vscrloff^-1
	ENDC

	IFC	"off","\2"
	s_or_alvar		B,y,exal_VIEWflag3,#exal_VIEWflag3_vscrloff
	ENDC


	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}

.exit\@
	stratmac_end
	endm



sp_jmp_ifvscrolloff	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda		exal_VIEWflag3,y

	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}

	bit		#exal_VIEWflag3_vscrloff
	rlbne		{label}

	stratmac_end
	endm
;--------------------------------------------------
; Arwing ga kabe ni hit suruka douka no flag (tunnel mode)

sp_hitwall	macro	[obj,onoff,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
;	PHY
;	toheap			y,x

	IFC	"on","\2"
	s_or_alvar		B,y,exal_CTLtype,#exal_CTLtype_hitwall
	ENDC

	IFC	"off","\2"
	s_and_alvar		B,y,exal_CTLtype,#exal_CTLtype_hitwall^-1
	ENDC

	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}

.exit\@
	stratmac_end
	endm



pl_jmp_ifhitwall	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
;	PHY
;	toheap		y,x
	lda		exal_CTLtype,y
	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}

	bit		#exal_CTLtype_hitwall
	rlbne		{label}

	stratmac_end
	endm




pl_jmpnot_ifhitwall	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
;	PHY
;	toheap		y,x
	lda		exal_CTLtype,y
	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}

	bit		#exal_CTLtype_hitwall
	rlbeq		{label}

	stratmac_end
	endm



sp_tunnel	macro	[obj,onoff]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2

	sp_hitwall	{obj},{onoff}

	stratmac_end
	endm


pl_jmp_iftunnel	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	IFNE	NARG-3
	pl_jmp_ifhitwall	{obj},{label}
	ELSEIF
	pl_jmp_ifhitwall	{obj},{label},{hobj}
	ENDC

	stratmac_end
	endm


pl_jmpnot_iftunnel	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2


	IFNE	NARG-3
	pl_jmpnot_ifhitwall	{obj},{label}
	ELSEIF
	pl_jmpnot_ifhitwall	{obj},{label},{hobj}
	ENDC

	stratmac_end
	endm


;--------------------------------------------------
; Kyo-sei-teki ni player wo transform saseru...

sp_trans_do	macro	[obj,type,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3


	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

;	lda	#0
;	sta	exal_translocktimer,y
	lda	exal_shapeNoNEXT,y
	and	#exal_shapeNo_ctmask^-1
	ora	#ct_{type}
	sta	exal_shapeNoNEXT,y

	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY	{obj}
.exit\@
	stratmac_end
	endm






sp_trans_lock	macro	[obj,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	s_or_alvar	B,y,exal_CTLtype,#exal_CTLtype_notrans

	IFNE	NARG-2
	PLY
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	endm





; transform kinshi flag no clear

sp_trans_lockoff	macro	[obj,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	s_and_alvar	B,y,exal_CTLtype,#(exal_CTLtype_notrans!exal_CTLtype_notransreally)^-1

	IFNE	NARG-2
	PLY
	ENDC

	EXG_IFY	{obj}
.exit\@
	stratmac_end
	endm

;--------------------------------------------------
; PLAYER no transform routine

pl_trans	macro	[obj,nextmode,sound]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{obj}

	lda	#ct_{nextmode}
	sta	x1

	jsl		settransform_srou_l

	bcc		.notrans\@
	kplsound	x,{sound}

.notrans\@

	EXG_IFY	{obj}

	stratmac_end
	endm

;--------------------------------------------------
sp_jmpNOT_playertype	macro	[obj,type,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shapeNo,y

	IFNE	NARG-4
	PLY
	ENDC

	EXG_IFY	{obj}

	and	#exal_shapeno_stmask
	cmp	#type_{type}<<4
	rlbne	{label}
	stratmac_end
	endm

;--------------------------------------------------
;pl_jmp_CTLNo		macro	[obj,type,label,hobj]
;
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	3,4
;
;	EXG_IFY	{obj}
;	IFNE	NARG-4
;	PHY
;	toheap	y,x
;	ELSEIF
;	CHK_SAMEOBJ	{obj},{hobj}
;	ENDC
;;	phy
;;	toheap	y,x
;	lda	exal_shapeNo,y
;	IFNE	NARG-4
;	ply
;	ENDC
;
;	EXG_IFY	{obj}
;
;	and	#exal_shapeNo_ctmask
;	cmp	#ct_{type}
;	rlbeq	{label}
;	stratmac_end
;	endm
;
;
;pl_jmpNOT_CTLNo	macro	[obj,type,label,hobj]
;
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	3,4
;
;	EXG_IFY	{obj}
;	IFNE	NARG-4
;	PHY
;	toheap	y,x
;	ELSEIF
;	CHK_SAMEOBJ	{obj},{hobj}
;	ENDC
;;	phy
;;	toheap	y,x
;	lda	exal_shapeNo,y
;	IFNE	NARG-4
;	ply
;	ENDC
;	EXG_IFY	{obj}
;
;	and	#exal_shapeNo_ctmask
;	cmp	#ct_{type}
;	rlbne	{label}
;	stratmac_end
;	endm

;------------------------------------------------------------------------
pl_turn	macro	[obj,onoff,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	IFC	"off","\2"
	s_or_alvar	B,y,exal_control,#exal_control_notturn
	ENDC

	IFC	"on","\2"
	s_and_alvar	B,y,exal_control,#exal_control_notturn^-1
	s_set_alvar	B,y,exal_noturn_trap,#0
	ENDC

	IFNE	NARG-3
	ply
	ENDC


	EXG_IFY	{obj}

	stratmac_end
	ENDM

pl_forceturn	macro	[obj,var,centerx,centery,centerz,width,height,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	7,8

	EXG_IFY	{obj}

	IFNE	NARG-6
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	pl_turn		x,off,y

	s_set_alvar	B,y,exal_forceroty,{var}

	a16
	lda	{centerx}
	sta	exal_forcecx,y
	lda	{centery}
	sta	exal_forcecy,y
	lda	{centerz}
	sta	exal_forcecz,y

	lda	{width}
	sta	exal_forcewidth,y
	lda	{height}
	sta	exal_forceheight,y
	a8

	IFNE	NARG-6
	ply
	ENDC


	EXG_IFY	{obj}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_block	macro	[obj,onoff,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	IFC	"off","\2"
	s_or_alvar	B,y,exal_blockflag,#exal_blockflag_off
	ENDC

	IFC	"on","\2"
	s_and_alvar	B,y,exal_blockflag,#exal_blockflag_off^-1
	ENDC

	IFNE	NARG-3
	ply
	ENDC


	EXG_IFY	{obj}

	stratmac_end
	ENDM

pl_jmp_ifblockoff	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_blockflag,y

	IFNE	NARG-3
	ply
	ENDC


	EXG_IFY	{obj}

	bit	#exal_blockflag_off
	rlbne	{label}

	stratmac_end
	ENDM

pl_jmpnot_ifblockoff	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_blockflag,y

	IFNE	NARG-3
	ply
	ENDC


	EXG_IFY	{obj}

	bit	#exal_blockflag_off
	rlbeq	{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------

pl_enter	macro	[obj,onoff,level,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	IFC	"on","\2"

		lda	exal_control2,y
		and	#(exal_control2_enter_mask)^-1
		ora	#exal_control2_enter_{level}
		sta	exal_control2,y

	ELSEIF

		s_and_alvar	B,y,exal_control2,#(exal_control2_enter_mask)^-1
;		s_and_alvar	B,y,exal_control2,#(exal_control2_enter_mask!exal_control2_enter_on)^-1

	ENDC


	IFNE	NARG-4
	ply
	ENDC


	EXG_IFY	{obj}

	stratmac_end
	ENDM



pl_enterpos	macro	[obj,posx,posy,posz,width,hobj]


	stratmac_start
MYNARG	=	NARG
	CHK_NARG	5,6

	EXG_IFY	{obj}

	IFNE	NARG-6
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	a16
	lda	{posx}
	sta	exal_enterposx,y
	lda	{posy}
	sta	exal_enterposy,y
	lda	{posz}
	sta	exal_enterposz,y
	lda	{width}
	sta	exal_enterwidth,y
	a8

	IFNE	NARG-6
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end

	ENDM

;--------------------------------------------------

pl_get_pilotTAB_ST	macro	[size,obj,var,table]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4

	EXG_IFY		{obj}

	phx

	jsl	get_pilotNotoidx_{size}_l

	CHG_MODE	{size}
	lda.l	{table},x
	sta	{var}
	CHG_MODEBACK	{size}

	stratmac_end
	ENDM


pgpt_C	macro	[size,obj,var,table]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4

	CHG_MODE	{size}
	lda.l	{table},x
	sta	{var}
	CHG_MODEBACK	{size}

	stratmac_end
	ENDM


pgpt_END	macro	[size,obj,var,table]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4

	CHG_MODE	{size}
	lda.l	{table},x
	sta	{var}
	CHG_MODEBACK	{size}

	plx

	EXG_IFY		{obj}

	stratmac_end
	ENDM

;--------------------------------------------------

pl_get_pilotTAB	macro	[size,obj,var,table]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4


	EXG_IFY		{obj}

	phx

	jsl	get_pilotNotoidx_{size}_l

	CHG_MODE	{size}
	lda.l	{table},x
	sta	{var}
	CHG_MODEBACK	{size}

	plx

	EXG_IFY		{obj}

	stratmac_end
	ENDM

;--------------------------------------------------
pl_get_shapeTAB	macro	[size,obj,var,table]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4


	EXG_IFY		{obj}

	phx

	jsl	get_shapeNotoidx_{size}_l

	CHG_MODE	{size}

	lda.l	{table},x
	sta	{var}

	CHG_MODEBACK	{size}

	plx

	EXG_IFY		{obj}


	stratmac_end
	ENDM


pl_get_shapeTAB_ST	macro	[size,obj,var,table]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4


	EXG_IFY		{obj}

	phx

	jsl	get_shapeNotoidx_{size}_l

	CHG_MODE	{size}

	lda.l	{table},x
	sta	{var}

	CHG_MODEBACK	{size}

	stratmac_end
	ENDM

pgst_C	macro	[size,obj,var,table]

	pgpt_C		{size},{obj},{var},{table}

	ENDM

pgst_END	macro	[size,obj,var,table]

	pgpt_END	{size},{obj},{var},{table}

	ENDM

;--------------------------------------------------
; StarFox I mode?

pl_jmp_ifturn	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_control,y
	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#exal_control_notturn
	rlbeq	{label}

	stratmac_end
	ENDM


pl_jmpNOT_ifturn	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_control,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#exal_control_notturn
	rlbne	{label}

	stratmac_end
	ENDM

;--------------------------------------------------
; MACRO FOR TUTU MODE(ARMER)

pl_jmp_iftutumode	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	pl_jmp_ifentermode	{obj},{label},{hobj}

	stratmac_end
	ENDM


pl_jmpnot_iftutumode	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	pl_jmpnot_ifentermode	{obj},{label},{hobj}

	stratmac_end
	ENDM


;--------------------------------------------------
; MACRO FOR ENTER MODE

pl_jmp_ifentermode	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_control2,y
	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_control2_enter_on

	rlbne	{label}

	stratmac_end
	ENDM


pl_jmpnot_ifentermode	macro	[obj,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_control2,y
	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_control2_enter_on

	rlbeq	{label}

	stratmac_end
	ENDM


pl_jmp_ifenter	macro	[obj,label,level,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_control2,y
	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_control2_enter_mask

	IFC	"0","{level}"
	rlbne	{label}
	ELSEIF
	cmp	#exal_control2_enter_{level}
	rlbeq	{label}
	ENDC


	stratmac_end
	ENDM


pl_jmpnot_ifenter	macro	[obj,label,level,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_control2,y
	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_control2_enter_mask

	IFC	"0","{level}"
	rlbeq	{label}
	ELSEIF
	cmp	#exal_control2_enter_{level}
	rlbne	{label}
	ENDC


	stratmac_end
	ENDM


pl_enterdist_set	macro	[obj,dist,label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{obj}

	a16
	lda	{dist}
	sta	x2
	jsl	checkenterdist_srou_l
	a8

	EXG_IFY	{obj}

	rlbcc	{label}

	stratmac_end

	ENDM


pl_enterdist_ifmore	macro	[obj,dist,label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{obj}

	a16
	lda	{dist}
	sta	x2
	jsl	checkenterdist_srou_l
	a8

	EXG_IFY	{obj}

	rlbcc	{label}

	stratmac_end

	ENDM


pl_enterdist_ifless	macro	[obj,dist,label]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{obj}

	a16
	lda	{dist}
	sta	x2
	jsl	checkenterdist_srou_l
	a8

	EXG_IFY	{obj}

	rlbcs	{label}

	stratmac_end

	ENDM


;--------------------------------------------------
pl_damage_meter	macro	;[HPmax,NUM]

; NUM=number of scale

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	0

;	sm_jmp_if2screen	.battle\@
;
;	test_screenmode	onescreen
;	beq	.battle\@

.mission\@	jsl	set_dmgmeterVAL_1_srou_l
;	bra	.exit\@
;
;.battle\@	lda	#{HPmax}/{NUM}	;=1scale HP
;	jsl	set_dmgmeterVAL_srou_l
;.exit\@
	stratmac_end
	endm
;--------------------------------------------------

pl_KEYaccl_alvars	macro	[size,obj1,alvar,obj2,acclalvar,accl,max,rate,inckey,deckey]

;	using : work0

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	10
;	CHG_MODE	{size}

.inc\@
	testjoypad	{inckey},pcont
	beq		.dec\@
	s_set_var	{size},work0,#{accl}
	bra		.set\@

.dec\@
	testjoypad	{deckey},pcont
	beq		.nk\@		; no key
	s_set_var	{size},work0,#-{accl}
	bra		.set\@
.nk\@
	s_set_var	{size},work0,#0

.set\@

	s_Fchase_alvar		{size},{obj2},{acclalvar},work0,{rate}
	s_add_alvars		{size},{obj1},{alvar},{obj2},{acclalvar}

	s_jmp_alvarPL		{size},{obj1},{alvar},.brpl\@

.brmi\@
	s_jmp_alvarMORE		{size},{obj1},{alvar},#-{max},.skip0\@
	s_set_alvar		{size},{obj1},{alvar},#-{max}
	s_bra			.skip0\@

.brpl\@
	s_jmp_alvarLESS		{size},{obj1},{alvar},#{max},.skip0\@
	s_set_alvar		{size},{obj1},{alvar},#{max}
	s_bra			.skip0\@

.skip0\@
;	CHG_MODEBACK	{size}

	stratmac_end

	ENDM

;--------------------------------------------------
;pl_oldposrots	macro	[obj,hobj]
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	1,2
;
;
;
;	EXG_IFY	{obj}
;
;	jsl	copy_camoldposrots_l
;
;	EXG_IFY	{obj}
;
;	stratmac_end
;	endm
;
;
;--------------------------------------------------
pl_set_rotyoffset	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

;	IFC	"y","\1"
;	phx
;	tyx
;	ENDC

	EXG_IFY	{obj}



;	a16
;	lda		{value2}
;	sta		y2
;	lda		{value}
;	sta		y1
;	a8

	jsl		set_rotyoffset_l

	EXG_IFY	{obj}

;	IFC	"y","\1"
;	plx
;	ENDC

	stratmac_end

	ENDM

;--------------------------------------------------
;pl_jmp_ifp2	macro	[obj,label]
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	2
;
;	s_jmp_alsflag	{obj},player2,{label}
;
;	stratmac_end
;
;	ENDM
;
;--------------------------------------------------
;pl_jmp_ifp1	macro	[obj,label]
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	2
;
;	s_jmpNOT_alsflag	{obj},player2,{label}
;
;	stratmac_end
;
;	ENDM
;
;--------------------------------------------------
sp_jmp_ifcockpit	macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_VIEWflag,y

	IFNE	NARG-3
	ply
	ENDC


	EXG_IFY	{obj}

	bit	#exal_VIEWflag_cpchg
	rlbne	.skip\@
	and	#exal_VIEWflag_cockpit
	rlbne	{label}


.skip\@
	stratmac_end

	ENDM


;--------------------------------------------------
sp_jmpNOT_ifcockpit	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_VIEWflag,y
	IFNE	NARG-3
	ply
	ENDC


	EXG_IFY	{obj}

	and	#exal_VIEWflag_cockpit
	rlbeq	{label}

	stratmac_end

	ENDM

;--------------------------------------------------
sp_jmp_ifhudon	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_hudrot+1,y
	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#40h
	rlbne	{label}


	stratmac_end

	ENDM

;--------------------------------------------------
sp_jmpNOT_ifhudon	macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_hudrot+1,y
	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#40h
	rlbeq	{label}

	stratmac_end

	ENDM

;--------------------------------------------------
sp_jmp_ifcockpitchg	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3


	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_VIEWflag,y
	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	bit	#exal_VIEWflag_cpchg
	rlbne	{label}

	stratmac_end

	ENDM

;--------------------------------------------------
pl_jmp_ifrolling	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

;	IFC	"y","\1"
;	phx
;	tyx
;	ENDC

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
;	phy
;	ldy	al_sword2,x
	lda	exal_control,y
	IFNE	NARG-3
	ply
	ENDC



	EXG_IFY	{obj}

;	IFC	"y","\1"
;	plx
;	ENDC
	bit	#exal_control_rolling
	rlbne	{label}
.skip\@
	stratmac_end

	ENDM

;AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;--------------------------------------------------
pl_jmp_ifrollstart	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}


	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

;	phy
;	ldy	al_sword2,x
	lda	exal_rollingoffset,y
	bpl	.pl\@
	nega
.pl\@
	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

;	printb	8,8
	cmp	#10
	rlbpl	{label}
.skip\@
	stratmac_end

	ENDM



;--------------------------------------------------
pl_jmp_iftransform	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_transflag,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_transflag_transform_really_flag
	rlbne	{label}


	stratmac_end

	ENDM

;--------------------------------------------------
pl_jmpNOT_iftransform	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3


	EXG_IFY	{obj}

	IFNE	NARG-3
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\3
	ENDC

	lda	exal_transflag,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	and	#exal_transflag_transform_really_flag
	rlbeq	{label}

	stratmac_end

	ENDM

;--------------------------------------------------
pl_set_transflag	macro	[obj,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}

	IFNE	NARG-2
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\2
	ENDC

	s_or_alvar	B,y,exal_transflag,#exal_transflag_transform_really_flag

	IFNE	NARG-2
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end

	ENDM

;--------------------------------------------------
pl_clr_transflag	macro	[obj,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}

	IFNE	NARG-2
	phy
	ldy	al_sword2,x
	ELSEIF
	CHK_SAMEOBJ	\1,\2
	ENDC

	s_and_alvar	B,y,exal_transflag,#exal_transflag_transform_really_flag^-1

	IFNE	NARG-2
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end

	ENDM

;--------------------------------------------------
pl_jmp_ifaltLMT	macro	[obj,flag,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3,4

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_xyzLMT,y

	IFNE	NARG-4
	ply
	ENDC

	bit	#exal_xyzLMT_{flag}
	rlbne	{label}

	stratmac_end

	ENDM
;--------------------------------------------------
pl_jmpNOT_ifaltLMT	macro	[obj,flag,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3,4

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_xyzLMT,y

	IFNE	NARG-4
	ply
	ENDC

	bit	#exal_xyzLMT_{flag}
	rlbeq	{label}

	stratmac_end

	ENDM
;--------------------------------------------------
;pl_jmp_exalvarAND	macro	[obj,exalvar,var,label,hobj]
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	4,5
;
;	EXG_IFY	{obj}
;
;	IFNE	NARG-5
;	PHY
;	toheap	y,x
;	ELSEIF
;	CHK_SAMEOBJ	{obj},{hobj}
;	ENDC
;;	phy
;;	ldy	al_sword2,x
;	lda	{exalvar},y
;	IFNE	NARG-5
;	ply
;	ENDC
;
;	EXG_IFY	{obj}
;
;	and	{var}
;	bne	{label}
;
;	stratmac_end
;
;	ENDM
;
;--------------------------------------------------
;pl_jmpNOT_exalvarAND	macro	[obj,exalvar,var,label]
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	4
;
;	EXG_IFY	{obj}
;
;	phy
;	ldy	al_sword2,x
;	lda	{exalvar},y
;	ply
;
;	EXG_IFY	{obj}
;
;	and	{var}
;	beq	{label}
;
;	stratmac_end
;
;	ENDM
;
;--------------------------------------------------
pl_mode_change	macro	[obj,name]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	a16
	lda		#{name}&WM
	sta		x1
	a8

	jsl		modechangesrou_l

	stratmac_end

	ENDM
;--------------------------------------------------
pl_jmp_ifplayerdead	macro	[obj,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	;***s_jmp_alsflag	x,player2,.p2\@

.p1\@	test_playerdead	p1
	rlbne		{label}
	;***bra		.skip\@

.p2\@	;***test_playerdead	p2
	;***rlbne		{label}
.skip\@
	stratmac_end

	ENDM
;--------------------------------------------------
pl_jmp_ifplayerHP0	macro	[obj,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	s_jmp_alvarZERO	B,x,al_HP,{label}

	stratmac_end

	ENDM
;--------------------------------------------------
pl_jmp_ifplayer2dead	macro	[label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	test_playerdead	p2
	rlbne		{label}

	stratmac_end

	ENDM
;--------------------------------------------------
pl_jmp_ifplayer1dead	macro	[label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	test_playerdead	p1
	rlbne		{label}

	stratmac_end

	ENDM
;--------------------------------------------------
pl_jmp_ifplayer2gameend	macro	[label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1
	test_playergameend	p2
	rlbne		{label}
	stratmac_end

	ENDM
;--------------------------------------------------
pl_jmp_ifplayer1gameend	macro	[label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1
	test_playergameend	p1
	rlbne		{label}
	stratmac_end

	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;---------------------------------------------------------------------
;	strat macros for CAMERA
;---------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
c_do_viewstrat	macro
	stratmac_start
	jsl		MAIN_VIEWBRANCH_L
	stratmac_end
	endm
;--------------------------------------------------
c_shock_cam	macro	[obj,value,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY		{obj}

;	s_jmp_alsflag	x,nohitaffect,.skip1\@
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
;	phy
;	ldy	al_sword2,x
	s_jmp_alvarNE		W,y,exal_camrotxtilt,#0,.skip\@
	s_set_alvar		W,y,exal_camrotxtilt,{value}
.skip\@
	IFNE	NARG-3
	ply
	ENDC
.skip1\@

	EXG_IFY		{obj}

	stratmac_end

	endm

;--------------------------------------------------
c_addcol_cam	macro	[obj,type,frame,switch,hobj]

; type	:dmg 	(when damageed)
;	:shield	(when rebound laser)
;	:explode(when explode)
; switch	:on/off (colour lock on or off=yu-sen ka dou ka)

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	4,5

	EXG_IFY		{obj}

	IFNE	NARG-5
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC


	lda	#{frame}
	sta	exal_scrflash,y

	lda	exal_scrflash_flag,y
	IFC	"{switch}","on"
	ora	#exal_scrflash_flag_{type}!exal_scrflash_flag_lock!exal_scrflash_flag_set
	ELSEIF
	ora	#exal_scrflash_flag_{type}!exal_scrflash_flag_set
	ENDC
	sta	exal_scrflash_flag,y


	IFNE	NARG-5
	ply
	ENDC

	EXG_IFY		{obj}

	stratmac_end
	ENDM

;--------------------------------------------------
c_add_Roffs2pos16		MACRO	[size,TO obj,POS obj,ROT obj,x,y,z,0/1,0/1,0/1 (x,y,z)rot on]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG  10

	a16

	lda	\5
	sta	x1
	sta	x2
	lda	\6
	sta	y1
	sta	y2
	lda	\7
	sta	z1
	sta	z2


	IFNE	\A
	a8
	s_lda.w	al_rotz,\4
	jsl	rotate_16yx_l
	a16
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1
	ENDC

	IFNE	\8
	a8
	s_lda.w	al_rotx,\4
	jsl	rotate_16yz_l
	a16
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1
	ENDC

	IFNE	\9
	a8
	s_lda.w	al_roty,\4
	jsl	rotate_16xz_l
	ENDC      


	a16
	lda	x2
	clc
	adc.w	al_worldx,\3
	s_sta.w	al_worldx,\2

	lda	z2
	clc
	adc.w	al_worldz,\3
	s_sta.w	al_worldz,\2

	lda	y2
	clc
	adc.w	al_worldy,\3
	s_sta.w	al_worldy,\2

	a8

	stratmac_end
	ENDM

;--------------------------------------------------
c_add_Rvaroffs2pos16		MACRO	[size,TOobj,POSobj,ROTXvar,ROTYvar,ROTZvar,x,y,z,0/1,0/1,0/1 (x,y,z)rot on]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG  12

	a16

	lda	{x}
	sta	x1
	sta	x2
	lda	{y}
	sta	y1
	sta	y2
	lda	{z}
	sta	z1
	sta	z2


	IFNE	\C
	a8
	lda	{ROTZvar}
	jsl	rotate_16yx_l
	a16
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1
	ENDC

	IFNE	\A
	a8
	lda	{ROTXvar}
	jsl	rotate_16yz_l
	a16
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1
	ENDC

	IFNE	\B
	a8
	lda	{ROTYvar}
	jsl	rotate_16xz_l
	ENDC      


	a16
	lda	x2
	clc
	adc.w	al_worldx,{POSobj}
	s_sta.w	al_worldx,{TOobj}

	lda	z2
	clc
	adc.w	al_worldz,{POSobj}
	s_sta.w	al_worldz,{TOobj}

	lda	y2
	clc
	adc.w	al_worldy,{POSobj}
	s_sta.w	al_worldy,{TOobj}

	a8

	stratmac_end
	ENDM


;--------------------------------------------------
c_add_Rvaroffs2pos		MACRO	[size,TOobj,POSobj,ROTXvar,ROTYvar,ROTZvar,x,y,z,0/1,0/1,0/1 (x,y,z)rot on]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG  12

	IFC	"\1","B"

	lda	{x}
	sta	x1
	sta	x2
	sexam	x2+1
	lda	{y}
	sta	y1
	sta	y2
	sexam	y2+1
	lda	{z}
	sta	z1
	sta	z2
	sexam	z2+1

	IFNE	\C
	lda.l	\6
	jsl	rotate_8yx_l
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1
	ENDC

	IFNE	\A
	lda.l	\4
	jsl	rotate_8yz_l
	lda	x2
	sta	x1
	lda	y2
	sta	y1
	lda	z2
	sta	z1
	ENDC

	IFNE	\B
	lda.l	\5
	jsl	rotate_8xz_l
	ENDC      


	a16
	lda	x2
	globalscale_a
	clc
	adc.w	al_worldx,{POSobj}
	s_sta.w	al_worldx,{TOobj}

	lda	z2
	globalscale_a
	clc
	adc.w	al_worldz,{POSobj}
	s_sta.w	al_worldz,{TOobj}

	lda	y2
	globalscale_a
	clc
	adc.w	al_worldy,{POSobj}
	s_sta.w	al_worldy,{TOobj}

	a8

	ENDC


	IFC	"\1","W"
	error	<I'm sorry WORD usage doesn't work here,>
	error	<use BYTE and SHIFT to get bigger values.>
	error	<Thankyou for your co-operation, Goodnight !>
	ENDC
	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;------------------------------------------------------------------------
;	LOOK macro
;------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
c_obj2obj_rotY	macro	[size,obj1,obj2,var]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4
	CHG_MODE	{size}


	lda.w	al_worldx,{obj2}
	sec
	sbc.w	al_worldx,{obj1}
	asra
	asra
	sta	x1

	lda.w	al_worldz,{obj2}
	sec
	sbc.w	al_worldz,{obj1}
	asra
	asra
	sta	y1


	jsl	call_arctan16_l
	

	lda	x1+1	;.l	m_cnt+1
	sec
	sbc.w	al_roty+1,{obj1}
	and	#0ffH
	sta	{var}


	CHG_MODEBACK	{size}
	stratmac_end
	endm


;------------------------------------------------------------------------
;do_cam_strat	macro
;	phy
;
;	ldy	al_sword2,x
;
;	lda	#(.return&0ff00H)>>8
;	pha
;	lda	#.return&0ffH
;	pha
;
;	lda	exal_camstratptr+1,y
;	pha
;	lda	exal_camstratptr,y
;	pha
;	rts
;.return\@
;	ply
;
;	endm
;------------------------------------------------------------------------
;c_setcockpit_pos	macro	[obj]
;	stratmac_start
;	phx
;	phy
;
;	pl_ldy_viewblk		x
;	s_add_roffs2pos		B,y,x,x,#0,#-14,#100,1,1,0
;
;.skip0\@
;	ply
;	plx
;	stratmac_end
;	ENDM
;------------------------------------------------------------------------
c_view_inbetween	macro	[obj,onoff]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	phy

	pl_ldy_viewblk	x

	IFC	"offtrig","\2"
	s_set_alsflag	y,sflag3
	ENDC

	IFC	"on","\2"
	s_set_alsflag	y,sflag1
	s_set_alsflag	y,sflag2
	ENDC

	IFC	"faston","\2"
	s_set_alsflag	y,sflag1
	s_set_alsflag	y,sflag2
	s_set_alsflag	y,sflag6
	ENDC

	IFC	"off","\2"
	s_clr_alsflag	y,sflag1
	s_clr_alsflag	y,sflag2
	ENDC

	ply

	EXG_IFY	{obj}


;	EXG_IFY	{obj}
;
;	IFNE	NARG-3
;	PHY
;	toheap	y,x
;	ELSEIF
;	CHK_SAMEOBJ	{obj},{hobj}
;	ENDC
;
;	IFC	"offtrig","\2"
;	s_or_alvar	B,y,exal_VIEWflag2,#exal_VIEWflag2_inbetofftrig
;	ENDC
;
;	IFC	"on","\2"
;	s_or_alvar	B,y,exal_VIEWflag,#exal_VIEWflag_inbetpos!exal_VIEWflag_inbetrot
;	ENDC
;
;	IFC	"off","\2"
;	s_AND_alvar	B,y,exal_VIEWflag,#(exal_VIEWflag_inbetpos!exal_VIEWflag_inbetrot)^-1
;	ENDC
;
;	IFNE	NARG-3
;	ply
;	ENDC
;
;	EXG_IFY	{obj}

	stratmac_end
	ENDM

c_pos_inbetween	macro	[obj,onoff]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	pl_ldy_viewblk	x

	IFC	"on","\2"
	s_set_alsflag	y,sflag1
	ENDC

	IFC	"faston","\2"
	s_set_alsflag	y,sflag1
	s_set_alsflag	y,sflag6
	ENDC

	IFC	"off","\2"
	s_clr_alsflag	y,sflag1
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	ENDM

c_rot_inbetween	macro	[obj,onoff]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	pl_ldy_viewblk	x

	IFC	"on","\2"
	s_set_alsflag	y,sflag2
	ENDC

	IFC	"faston","\2"
	s_set_alsflag	y,sflag2
	s_set_alsflag	y,sflag6
	ENDC

	IFC	"off","\2"
	s_clr_alsflag	y,sflag2
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
;c_viewinit	macro	[obj,onoff,hobj]
;
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2,3
;
;	EXG_IFY	{obj}
;
;	IFNE	NARG-3
;	PHY
;	toheap	y,x
;	ELSEIF
;	CHK_SAMEOBJ	{obj},{hobj}
;	ENDC
;;	phy
;;	ldy	al_sword2,x
;
;	IFC	"off","\2"
;	s_and_alvar	B,y,exal_VIEWflag2,#exal_VIEWflag2_initialNEXT^-1
;	ENDC
;
;	IFC	"on","\2"
;	s_or_alvar	B,y,exal_VIEWflag2,#exal_VIEWflag2_initialNEXT
;	ENDC
;
;	IFNE	NARG-3
;	ply
;	ENDC
;
;	EXG_IFY	{obj}
;
;	stratmac_end
;	ENDM

;------------------------------------------------------------------------
;c_jmp_ifviewinit	macro	[obj,label,hobj]
;
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2,3
;
;	EXG_IFY	{obj}
;
;	IFNE	NARG-3
;	PHY
;	toheap	y,x
;	ELSEIF
;	CHK_SAMEOBJ	{obj},{hobj}
;	ENDC
;;	phy
;;	ldy	al_sword2,x
;
;	lda	exal_VIEWflag2,y
;	IFNE	NARG-3
;	ply
;	ENDC
;
;	EXG_IFY	{obj}
;
;	and		#exal_VIEWflag2_initial
;	bne		{label}
;
;	stratmac_end
;	ENDM
;
;------------------------------------------------------------------------
;c_jmpNOT_ifviewinit	macro	[obj,label]
;
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2
;
;	EXG_IFY	{obj}
;
;	phy
;
;	ldy	al_sword2,x
;
;	lda	exal_VIEWflag2,y
;	ply
;
;	EXG_IFY	{obj}
;
;	bit		#exal_VIEWflag2_initial
;	rlbeq		{label}
;
;	stratmac_end
;	ENDM
;
;------------------------------------------------------------------------
c_setcockpit_rot	macro	[obj]
	stratmac_start

	phx
	phy

	pl_ldy_viewblk		x

	s_copy_alvar2var	W,y,x1,al_rotx+1
	s_copy_alvar2var	W,y,y1,al_roty+1

	s_neg_var		W,x1
	s_neg_var		W,y1

	s_set_alvar		B,x,al_rotx,x1
	s_set_alvar		B,x,al_roty,y1

.skip0\@
	ply
	plx


	stratmac_end
	endm



;------------------------------------------------------------------------
c_insidecockpit	macro	[obj,onoff,hobj]
	stratmac_start


MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

;	phy
;	ldy	al_sword2,x

	lda	exal_VIEWflag2,y

	IFC	"on","\2"
	ora	#exal_VIEWflag2_insidecockpit
	ENDC

	IFC	"off","\2"
	and	#exal_VIEWflag2_insidecockpit^-1
	ENDC

	sta	exal_VIEWflag2,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	endm



;------------------------------------------------------------------------

c_cockpitmode	macro	[onoff]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	lda	PMODE	; 0 ARWING
	and	#0ffh
	bne	.RB\@

	lda	playerimportflag
	and	#~pif_cockpit_on
	ora	#pif_cockpit_trig!pif_cockpit_{onoff}
	bra	.skip\@


.RB\@	lda	playerimportflag
	and	#~pif_cockpit_onRB
	ora	#pif_cockpit_trig!pif_cockpit_{onoff}RB

.skip\@	sta	playerimportflag



	stratmac_end

	ENDM
;------------------------------------------------------------------------

c_cockpitmode_change	macro

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	0

	lda	playerimportflag
	ora	#pif_cockpit_trig

	PHA

	lda	PMODE
	and	#0ffh
	bne	.RB\@

	PLA

	eor	#pif_cockpit_on
	bra	.skip\@
.RB\@	PLA
	eor	#pif_cockpit_onRB

.skip\@	sta	playerimportflag


	stratmac_end

	ENDM
;------------------------------------------------------------------------
;
;c_jmp_ifRBviewchg	macro	[obj,label,hobj]
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2,3
;	CHK_OBJ	{obj}
;	EXG_IFY	{obj}
;
;	IFNE	NARG-3
;	PHY
;	toheap	y,x
;	ELSEIF
;	CHK_SAMEOBJ	{obj},{hobj}
;	ENDC
;;	phy
;;	ldy	al_sword2,x
;	lda	exal_VIEWflag,y
;
;
;	IFNE	NARG-3
;	ply
;	ENDC
;
;	EXG_IFY	{obj}
;
;	and	#exal_VIEWflag_RBpushX
;	s_bne	{label}
;
;	stratmac_end
;
;	ENDM
;------------------------------------------------------------------------
;c_jmpNOT_ifRBviewchg	macro	[obj,label]
;	stratmac_start
;MYNARG	=	NARG
;	CHK_NARG	2
;	CHK_OBJ	{obj}
;	EXG_IFY	{obj}
;
;	ldy	al_sword2,x
;	lda	exal_VIEWflag,y
;
;	EXG_IFY	{obj}
;
;	and	#exal_VIEWflag_RBpushX
;	s_beq	{label}
;
;	stratmac_end
;
;	ENDM
;
;------------------------------------------------------------------------
c_calc_lookangle	macro	[size,obj,rotxout,rotyout,offsetx,offsety,offsetz]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	7

	EXG_IFY	{obj}

	s_set_var	B,x1,{offsetx}
	s_set_var	B,y1,{offsety}
	s_set_var	B,z1,{offsetz}

	phy

	ldy	#viewblk1

	jsl		cam_looksobj_l
	ply

	IFC	"B","\1"
	s_copy_var2var	B,{rotxout},x2+1
	s_copy_var2var	B,{rotyout},y2+1
	ENDC

	IFC	"W","\1"
	a16
	lda	x2
	sta	{rotxout}
	lda	y2
	sta	{rotyout}
	a8
	ENDC

	EXG_IFY	{obj}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
c_set_viewstrat	macro	[obj,pointer,demo]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY		{obj}

	IFC	"off","\2"

	phy
	ldy	al_sword2,x

	a16
	lda	#0
	sta	exal_viewstratptr,y
	a8
	sta	exal_viewstratptr+2,y

	ply

	ELSEIF

	jsl	VIEW_CHANGE_INIT_l
	phy
	ldy	al_sword2,x
	a8
	lda	#({pointer}_VIEW&0ff0000H)/10000H
	sta	exal_viewstratptr+2,y
	lda	exal_VIEWflag2,y
	IFEQ	NARG-3
	ora	#exal_VIEWflag2_demo
	ELSEIF
	and	#exal_VIEWflag2_demo^-1
	ENDC
	sta	exal_VIEWflag2,y
	a16
	lda	#{pointer}_VIEW&WM
	sta	exal_viewstratptr,y
	a8
	ply

	ENDC

	EXG_IFY		{obj}

	stratmac_end

	ENDM
;------------------------------------------------------------------------
c_jmp_viewstratEQ	macro	[obj,pointer,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY		{obj}

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
;	phy
;	ldy	al_sword2,x

	s_copy_alvar2var	B,y,x1,exal_VIEWstratptr+2
	s_copy_alvar2var	W,y,x2,exal_VIEWstratptr

	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY		{obj}

	s_jmp_varNE	B,x1,#({pointer}_VIEW&0ff0000H)/10000H,.skip\@
	s_jmp_varEQ	W,x2,#{pointer}_VIEW&WM,{label}
.skip\@

	stratmac_end

	ENDM
;------------------------------------------------------------------------
c_set_demoviewstrat	macro	[obj,pointer,hobj]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY		{obj}


	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	IFC	"off","\2"

	a16
	lda	#0
	sta	exal_demoviewstratptr,y
	a8
	sta	exal_demoviewstratptr+2,y

	ELSEIF
	lda	#(DVSTRAT_{pointer}&0ff0000H)/10000H
	sta	exal_demoviewstratptr+2,y
	a16
	lda	#(DVSTRAT_{pointer})&WM
	sta	exal_demoviewstratptr,y
	a8
	ENDC

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY		{obj}

	stratmac_end

	ENDM


c_jmp_ifdemoview	macro	[obj,label,hobj]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY		{obj}


	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC


	a16
	lda	exal_demoviewstratptr,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY		{obj}


	cmp	#0
	a8
	rlbne	{label}


	stratmac_end

	ENDM

c_jmpnot_ifdemoview	macro	[obj,label,hobj]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY		{obj}


	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC


	a16
	lda	exal_demoviewstratptr,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY		{obj}


	cmp	#0
	a8
	rlbeq	{label}


	stratmac_end

	ENDM


;------------------------------------------------------------------------
c_jmp_viewstratNE	macro	[obj,pointer,label,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY		{obj}

	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	s_copy_alvar2var	B,y,x1,exal_VIEWstratptr+2
	s_copy_alvar2var	W,y,x2,exal_VIEWstratptr

	IFNE	NARG-4
	ply
	ENDC

	EXG_IFY		{obj}

	s_jmp_varNE	B,x1,#({pointer}_VIEW&0ff0000H)/10000H,{label}
	s_jmp_varNE	W,x2,#{pointer}_VIEW&WM,{label}

	stratmac_end

	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;---------------------------------------------------------------------
;	strat macros for PLAYER's SOUND
;---------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;--------------------------------------------------
;pl_soundport		macro	[obj]
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	1
;
;	EXG_IFY	{obj}
;
;	s_jmp_alsflag	{obj},player2,.p2\@
;.p1\@	lda		p1_soundFX
;	sta.l		apu_port1
;	bra		.exit\@
;.p2\@	lda		p2_soundFX
;	sta.l		apu_port2
;.exit\@
;	EXG_IFY	{obj}
;
;	stratmac_end
;	ENDM
;--------------------------------------------------
pl_SE	macro	[obj,player1SE,player2SE]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3
	;***s_jmp_alsflag	{obj},player2,.p2\@
.p1\@	kplsound	{obj},{player1SE}
	;***bra		.exit\@
.p2\@	;***kplsound	{obj},{player2SE}
.exit\@
	stratmac_end
	ENDM
;--------------------------------------------------
pl_SE_Roboland	macro	[obj,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}

;	phy
;	ldy	al_sword2,x
;
;	s_jmpNOT_alvarAND	B,y,exal_jmpstatus2,#exal_jmpstatus2_top,.s\@



;	a16

	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	pl_jmp_ifinthesea	x,.sea\@

	a16
	lda	exal_vy,y

	IFNE	NARG-2
	ply
	ENDC

	cmp	#28H
	a8
	bcc	.s\@

.l\@
	jsl			SE_roboland_l_srou_l
	bra			.skip\@

.s\@
	jsl			SE_roboland_s_srou_l
	bra			.skip\@

.sea\@

	jsl			SE_robolandInSea_l_srou_l

.skip\@

	EXG_IFY	{obj}

	stratmac_end

	ENDM
;--------------------------------------------------
pl_SE_Robowalk	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}

	jsl	pl_SE_Robowalk_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM

;--------------------------------------------------
pl_SE_Roboswim	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}

	jsl	pl_SE_Roboswim_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM
;--------------------------------------------------
pl_SE_engine	macro	[obj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}
	jsl	ps_engine_start_l
	EXG_IFY	{obj}

	stratmac_end

	ENDM

;--------------------------------------------------
pl_SE_trans	macro	[obj]

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}
	jsl	pl_SE_transEND_l
	EXG_IFY	{obj}

	ENDM


pl_SE_transEND	macro	[obj,type,hobj]

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	IFC	"{type}","ROBOT"
	lda	#exal_transENDse_RB!exal_transENDse_mask!exal_transENDse_notEND
	ELSEIF
	lda	#exal_transENDse_mask!exal_transENDse_notEND
	ENDC
	sta	exal_transENDse,y

	IFNE	NARG-3
	ply
	ENDC


	EXG_IFY	{obj}

	stratmac_end

	ENDM

;--------------------------------------------------
pl_check_BOSSmode	macro
	stratmac_start
	lda	BOSSstatus
	bit	#BOSSstatus_on
	stratmac_end
	ENDM
;--------------------------------------------------
pl_fire_spweap	macro	[obj,nglabel]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	jsl	fire_AW_specialweapon_l
	rlbcc	{nglabel}

	EXG_IFY	{obj}

	stratmac_end

	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;MACRO for ROBOT
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
rb_set_motioncounter		macro	[obj,var]
	stratmac_start
	s_set_alvar	B,{obj},al_sbyte3,{var}
	stratmac_end
	ENDM

rb_inc_motioncounter		macro	[obj]
	stratmac_start

	lda		al_sbyte3,{obj}
	cmp		#255
	beq		.skip\@
	inc		a
	sta		al_sbyte3,{obj}
.skip\@
	stratmac_end
	ENDM

rb_jmp_motioncounterMORE	macro	[obj,var,label]
	stratmac_start

	lda		al_sbyte3,x
	cmp		{var}
	rlbcs		{label}

	stratmac_end
	ENDM

rb_jmp_motioncounterLESS	macro	[obj,var,label]
	stratmac_start

	lda		al_sbyte3,x
	cmp		{var}
	rlbcc		{label}

	stratmac_end
	ENDM

rb_jmpNOT_ifonshape		macro	[obj,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	s_jmp_alvarZERO		W,{obj},al_slopeptr,{label}

	stratmac_end
	ENDM


rb_jmp_ifonshape		macro	[obj,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	s_jmp_alvarnotZERO	W,{obj},al_slopeptr,{label}

	stratmac_end
	ENDM




rb_downofs	macro	[obj]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}
	jsr	set_exal2worldxyz_srou
	EXG_IFY	{obj}

	stratmac_end
	ENDM



rb_upofs	macro	[obj]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}
	jsr	set_worldxyz2exal_srou
	EXG_IFY	{obj}

	stratmac_end
	ENDM

rb_copyrobopos	macro	[obj,plrobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{plrobj}

	jsl	copyrobopos_srou_l

	EXG_IFY	{plrobj}

	stratmac_end

	ENDM


rb_plash	macro	[obj,var,hobj]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	sp_jmpNOT_playertype	{obj},ROBOT,.exit\@

;	cp{obj}		playpt1
;	beq		.do\@
;	cp{obj}		playpt2
;	bne		.exit\@

.do\@
	EXG_IFY		{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
;	PHY
;	ldy		al_sword2,x
	s_or_alvar	B,y,exal_robostatus,#exal_robostatus_plash
	s_set_alvar	B,y,exal_plashvel,{var}

	IFNE	NARG-3
	PLY
	ENDC

	EXG_IFY		{obj}

.exit\@
	stratmac_end

	ENDM



rb_set_legheight	macro	[plrobj,legobj,var,hobj]

	stratmac_start
MYNARG	=	NARG

	CHK_NARG	3,4


	EXG_IFY		{plrobj}


	s_push_obj	x

	s_push_obj	y
	ldy		al_sword2,x
	tyx
	s_pull_obj	y

	jmp_ifrightfoot	y,.R\@
.L\@	s_set_alvar	W,x,exal_Llegheight,{var}
	bra		.skip0\@

.R\@	s_set_alvar	W,x,exal_Rlegheight,{var}

.skip0\@


	s_pull_obj	x


	EXG_IFY		{plrobj}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
rb_get_bodypos	macro	[var,obj,hobj]

	stratmac_start
MYNARG	=	NARG

	CHK_NARG	2,3


	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	EXG_IFY		{obj}

	a16

	lda	exal_bodyofsy,y
	sexa
	clc
	nega
	adc	exal_worldy,y
	sta	{var}

	a8

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY		{obj}

	stratmac_end

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
set_centerflag	macro	[obj]

MYNARG	=	NARG
	CHK_NARG	1

	s_set_alsflag	{obj},sflag2

	endm


set_leftflag	macro	[obj]

MYNARG	=	NARG
	CHK_NARG	1

	s_clr_alsflag	{obj},sflag1

	endm


set_rightflag	macro	[obj]

MYNARG	=	NARG
	CHK_NARG	1

	s_set_alsflag	{obj},sflag1

	endm


jmp_ifleftfoot	macro	[obj,label]

MYNARG	=	NARG
	CHK_NARG	2

	s_jmpnot_alsflag	{obj},sflag1,{label}

	endm



jmp_ifrightfoot	macro	[obj,label]

MYNARG	=	NARG
	CHK_NARG	2

	s_jmp_alsflag	{obj},sflag1,{label}

	endm


jmp_ifleft	macro	[obj,label]

MYNARG	=	NARG
	CHK_NARG	2

	jmp_ifleftfoot	{obj},{label}

	endm

jmp_ifright	macro	[obj,label]

MYNARG	=	NARG
	CHK_NARG	2

	jmp_ifrightfoot	{obj},{label}

	endm

jmp_ifcenter	macro	[obj,label]

MYNARG	=	NARG
	CHK_NARG	2

	s_jmp_alsflag	{obj},sflag2,{label}

	endm


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;------------------------------------------------------------------------
;MACRO for using TSTRATsrous_l
;------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;tstrat_add_roffs2pos		macro	[toobj,posobj,rotobj,xofs,yofs,zofs,xon,yon,zon]
;;using	work0,1,2
;	stratmac_start
;
;MYNARG	=	NARG
;	CHK_NARG	9
;
;	s_set_var	B,x1,{xofs}
;	s_set_var	B,y1,{yofs}
;	s_set_var	B,z1,{zofs}
;
;	jsl	TSTRATsrous_l.calcroffs{toobj}{posobj}{rotobj}{xon}{yon}{zon}
;
;	stratmac_end
;	ENDM
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;------------------------------------------------------------------------
;MACRO for PLAYER'S TIMER using al_pword1
;------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;pl_set_timer	macro	[obj,value]
;pl_inc_timer	macro	[obj]
;pl_dec_timer	macro	[obj]
;pl_jmp_timerLESS	macro	[obj,value,label]
;pl_jmp_timerMORE	macro	[obj,value,label]
;pl_jmp_timerEQ	macro	[obj,value,label]
;pl_jmp_timerNE	macro	[obj,value,label]

;c_set_timer	macro	[obj,value]
;c_inc_timer	macro	[obj]
;c_dec_timer	macro	[obj]
;c_jmp_timerLESS	macro	[obj,value,label]
;c_jmp_timerMORE	macro	[obj,value,label]
;c_jmp_timerEQ	macro	[obj,value,label]
;c_jmp_timerNE	macro	[obj,value,label]
;------------------------------------------------------------------------
pl_set_timer	macro	[obj,value]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	s_set_alvar	W,{obj},al_pword1,{value}

	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_inc_timer	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	s_jmp_alvarEQ	W,{obj},al_pword1,#0ffffH,.exit\@
	s_add_alvar	W,{obj},al_pword1,#1
.exit\@
	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_dec_timer	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	s_jmp_alvarZERO	W,{obj},al_pword1,.exit\@
	s_add_alvar	W,{obj},al_pword1,#1
exit\@
	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_timerLESS	macro	[obj,value,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	shorta
	longi

	s_jmp_alvarLESS	W,{obj},al_pword1,{value},{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_timerMORE	macro	[obj,value,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_alvarMORE	W,{obj},al_pword1,{value},{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_timerEQ	macro	[obj,value,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_alvarEQ	W,{obj},al_pword1,{value},{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_timerNE	macro	[obj,value,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_alvarNE	W,{obj},al_pword1,{value},{label}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;------------------------------------------------------------------------
;MACRO for in the sea(seadepth)
;------------------------------------------------------------------------
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
pl_jmp_ifexistSEA	macro	[label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	a16
	lda	seadepth
	a8
	rlbne	{label}

	stratmac_end
	ENDM



pl_jmpnot_ifexistSEA	macro	[label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	a16
	lda	seadepth
	a8
	rlbeq	{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_check_inthesea	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}

	jsl	checkinthesea_srou_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
pl_set_intheseaflag	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	s_set_alsflag	{obj},sflag3

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_clr_intheseaflag	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	s_clr_alsflag	{obj},sflag3

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_ifcaminthesea		macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_VIEWflag2,y

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}
	bit	#exal_VIEWflag2_inthesea
	rlbne	{label}

	stratmac_end
	ENDM


pl_jmpNOT_ifcaminthesea	macro	[obj,label,hobj]


	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_VIEWflag2,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}
	bit	#exal_VIEWflag2_inthesea
	rlbeq	{label}

	stratmac_end
	ENDM

pl_jmp_ifcamintheseareally		macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_VIEWflag2,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}
	bit	#exal_VIEWflag2_intheseareally
	rlbne	{label}

	stratmac_end
	ENDM


pl_jmpNOT_ifcamintheseareally	macro	[obj,label,hobj]


	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_VIEWflag2,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}
	bit	#exal_VIEWflag2_intheseareally
	rlbeq	{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_ifinthesea	macro	[obj,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	lda	seatype
	cmp	#st_water
	bne	.exit\@
	s_jmp_alsflag	{obj},sflag3,{label}
.exit\@
	stratmac_end
	ENDM


pl_jmpNOT_ifinthesea	macro	[obj,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	lda	seatype
	cmp	#st_water
	rlbne	{label}
	s_jmpNOT_alsflag	{obj},sflag3,{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_UEpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},.skip\@
	ENDC

	EXG_IFY	{obj}

;	IFNE	NARG-4
;	PHY
;	toheap	y,x
;	ELSEIF
;	CHK_SAMEOBJ	{obj},{hobj}
;	ENDC

	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
;	IFNE	NARG-4
	ply
;	ENDC
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLue
	rlbcs	{label}
.skip\@
	stratmac_end
	ENDM

pl_jmpnot_UEpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},{label}
	ENDC

	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLue
	rlbcc	{label}

	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_jmp_KAOinpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},.skip\@
	ENDC

	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLkao
	rlbcs	{label}
.skip\@

	stratmac_end
	ENDM

pl_jmpnot_KAOinpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},{label}
	ENDC


	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLkao
	rlbcc	{label}


	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_jmp_ASHIinpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},.skip\@
	ENDC

	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLashi
	rlbcs	{label}

.skip\@
	stratmac_end
	ENDM

pl_jmpnot_ASHIinpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},{label}
	ENDC

	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLashi
	rlbcc	{label}

	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_jmp_ATAMAinpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},{label}
	ENDC

	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLatama
	rlbcs	{label}
	stratmac_end
	ENDM

pl_jmpnot_ATAMAinpool	macro	[obj,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLatama
	rlbcc	{label}
	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_jmp_ZENBUinpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},.skip\@
	ENDC

	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLzenbu
	rlbcs	{label}
.skip\@
	stratmac_end
	ENDM

pl_jmpnot_ZENBUinpool	macro	[obj,label,type]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	IFEQ	NARG-3
	pl_jmpnot_ifonthe	{obj},{type},{label}
	ENDC


	EXG_IFY	{obj}
	phy
	ldy	al_sword2,x
	lda	exal_robostatus,y
	ply
	EXG_IFY	{obj}
	and	#exal_robostatus_depthlevelmask
	cmp	#exal_robostatus_DLzenbu
	rlbcc	{label}
	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_jmp_ifonthe	macro	[obj,type,label,hobj]

MYNARG	=	NARG
	CHK_NARG	3,4


	EXG_IFY	{obj}
	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_pooltype,y
	IFNE	NARG-4
	ply
	ENDC
	EXG_IFY	{obj}

	cmp	#st_{type}
	rlbeq	{label}

.exit\@
	stratmac_end
	ENDM


pl_jmpnot_ifonthe	macro	[obj,type,label,hobj]

MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}
	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_pooltype,y
	IFNE	NARG-4
	ply
	ENDC
	EXG_IFY	{obj}

	cmp	#st_{type}
	rlbne	{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_iffloating	macro	[obj,label,hobj]

MYNARG	=	NARG
	CHK_NARG	2,3


	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_robostatus,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}


	bit	#exal_robostatus_floating
	rlbne	{label}

	stratmac_end
	ENDM


pl_jmpnot_iffloating	macro	[obj,label,hobj]

MYNARG	=	NARG
	CHK_NARG	2,3


	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_robostatus,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}


	bit	#exal_robostatus_floating
	rlbeq	{label}

	stratmac_end
	ENDM


;------------------------------------------------------------------------
pl_jmp_ifontheseatype	macro	[obj,type,label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_varEQ		B,seatype,#st_{type},{label}

.exit\@	stratmac_end
	ENDM


pl_jmpnot_ifontheseatype	macro	[obj,type,label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_varNE		B,seatype,#st_{type},{label}

	stratmac_end
	ENDM


;------------------------------------------------------------------------
pl_jmp_motionNoEQ	macro	[obj,motion,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}
	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_motionNo,y
	IFNE	NARG-4
	ply
	ENDC
	EXG_IFY	{obj}

	cmp	#m_{motion}
	rlbeq	{label}

	stratmac_end
	ENDM

pl_jmp_motionNoNE	macro	[obj,motion,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3,4

	EXG_IFY	{obj}
	IFNE	NARG-4
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_motionNo,y
	IFNE	NARG-4
	ply
	ENDC
	EXG_IFY	{obj}

	cmp	#m_{motion}
	rlbne	{label}

	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_jmp_iftransrising	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transrising
	rlbne	{label}


	stratmac_end
	ENDM

pl_jmp_iftransrising_w	macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transrising_w
	rlbne	{label}


	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmpnot_iftransrising	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transrising
	rlbeq	{label}

	stratmac_end
	ENDM

pl_jmpnot_iftransrising_w	macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transrising_w
	rlbeq	{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_clr_transrising	macro	[obj,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	and	#~(exal_status_transrising!exal_status_transrising_w)
	sta	exal_status,y
	IFNE	NARG-2
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_set_transrising	macro	[obj,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	and	#~exal_status_transrising_w
	ora	#exal_status_transrising
	sta	exal_status,y
	IFNE	NARG-2
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM

pl_set_transrising_w	macro	[obj,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_status,y
	ora	#exal_status_transrising_w
	sta	exal_status,y

	IFNE	NARG-2
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_jmp_iftransfalling	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transfalling
	rlbne	{label}


	stratmac_end
	ENDM

pl_jmp_iftransfalling_w	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transfalling_w
	rlbne	{label}


	stratmac_end
	ENDM

pl_jmp_iftransfalling_g	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transfalling_g
	rlbne	{label}


	stratmac_end
	ENDM


;------------------------------------------------------------------------
pl_jmpnot_iftransfalling	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transfalling
	rlbeq	{label}


	stratmac_end
	ENDM

pl_jmpnot_iftransfalling_w	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transfalling_w
	rlbeq	{label}


	stratmac_end
	ENDM

pl_jmpnot_iftransfalling_g	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	bit	#exal_status_transfalling_g
	rlbeq	{label}


	stratmac_end
	ENDM
;------------------------------------------------------------------------
pl_clr_transfalling	macro	[obj,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	and	#~(exal_status_transfalling!exal_status_transfalling_w!exal_status_transfalling_g)
	sta	exal_status,y
	IFNE	NARG-2
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
pl_set_transfalling	macro	[obj,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	and	#~(exal_status_transfalling!exal_status_transfalling_w)
	ora	#exal_status_transfalling
	sta	exal_status,y
	IFNE	NARG-2
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM

pl_set_transfalling_w	macro	[obj,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	ora	#exal_status_transfalling_w
	sta	exal_status,y
	IFNE	NARG-2
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM

pl_set_transfalling_g	macro	[obj,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}
	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC
	lda	exal_status,y
	ora	#exal_status_transfalling_g
	sta	exal_status,y
	IFNE	NARG-2
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
; SHIELD MACRO
;------------------------------------------------------------------------
pl_ROLLINGshield	macro	[obj,onoff,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shield,y

	IFC	"on","{onoff}"
	ora	#exal_shield_Rshield
	ELSEIF
	and	#exal_shield_Rshield^-1
	ENDC

	sta	exal_shield,y


	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM


pl_shield	macro	[obj,var,hobj]

; max 1fH

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shield,y
	and	#exal_shield_mask^-1
	sta	exal_shield,y

	lda	{var}
	and	#exal_shield_mask
	ora	exal_shield,y
	sta	exal_shield,y

	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	stratmac_end
	ENDM


pl_jmp_ifshield	macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shield,y

	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	and	#exal_shield_mask!exal_shield_Rshield
	rlbne	{label}

	stratmac_end
	ENDM


pl_jmpnot_ifshield	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shield,y

	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	and	#exal_shield_mask!exal_shield_Rshield
	rlbeq	{label}

	stratmac_end
	ENDM

pl_jmp_ifrollingshield	macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shield,y

	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	and	#exal_shield_Rshield
	rlbne	{label}

	stratmac_end
	ENDM


pl_jmpnot_ifrollingshield	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shield,y

	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	and	#exal_shield_Rshield
	rlbeq	{label}

	stratmac_end
	ENDM

pl_jmp_ifitemshield	macro	[obj,label,hobj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shield,y

	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	and	#exal_shield_mask
	rlbne	{label}

	stratmac_end
	ENDM


pl_jmpnot_ifitemshield	macro	[obj,label,hobj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}
	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_shield,y

	IFNE	NARG-3
	ply
	ENDC
	EXG_IFY	{obj}

	and	#exal_shield_mask
	rlbeq	{label}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;MACRO for GAME SEQUENCE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

pl_ifrestart	macro	[label]

	stratmac_start

	km_bitcheckgameflag	plreset
	beq	.skip\@
	km_clrgameflag		plreset
 	jmp	{label}
.skip\@
	stratmac_end
	endm
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

pl_endBOSSsequence	macro
	stratmac_start

	km_setmissionflag	bossdown	;gameover
 
	stratmac_end
	endm


;----------------------------------------------------------------------------------
pl_block_getpos	macro	[obj,xalvar,zalvar,xvar,zvar]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	5

	lda	{xalvar}+1,{obj}
	asra
;1024	asra
	sta	{xvar}

	lda	{zalvar}+1,{obj}
	asra
;1024	asra
	sta	{zvar}

	stratmac_end

	ENDM

;----------------------------------------------------------------------------------
pl_end_strat	macro

	stratmac_start

	jml	player_end_strat

	stratmac_end

	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;MACRO for CAMERA'S TIMER using al_pword1
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
c_set_timer	macro	[obj,value]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	s_set_alvar	W,{obj},al_pword1,{value}

	stratmac_end
	ENDM
;------------------------------------------------------------------------
c_inc_timer	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	s_jmp_alvarEQ	W,{obj},al_pword1,#0ffffH,.exit\@
	s_add_alvar	W,{obj},al_pword1,#1
.exit\@
	stratmac_end
	ENDM

;------------------------------------------------------------------------
c_dec_timer	macro	[obj]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	s_jmp_alvarZERO	W,{obj},al_pword1,.exit\@
	s_add_alvar	W,{obj},al_pword1,#1
.exit\@
	stratmac_end
	ENDM

;------------------------------------------------------------------------
c_jmp_timerLESS	macro	[obj,value,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_alvarLESS	W,{obj},al_pword1,{value},{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
c_jmp_timerMORE	macro	[obj,value,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_alvarMORE	W,{obj},al_pword1,{value},{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
c_jmp_timerEQ	macro	[obj,value,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_alvarEQ	W,{obj},al_pword1,{value},{label}

	stratmac_end
	ENDM

;------------------------------------------------------------------------
c_jmp_timerNE	macro	[obj,value,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_alvarNE	W,{obj},al_pword1,{value},{label}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	Enemy altmeter no macro
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
setenemymark		macro	[obj,1or2]
;setenemymark		macro	[obj,1or2,offdist]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	jsl	addEaltlist_p{1or2}_l

	EXG_IFY	{obj}

	stratmac_end
	ENDM

clrenemymark		macro	[1or2]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	s_push_obj	x
	s_push_obj	y

	a16
	lda		#0
	ldx		playpt{1or2}
	ldy		al_sword2,x
	sta		exal_enemyaltmeter_objptr,y

	a8
	s_set_alvar	W,y,exal_enemyaltmeter_OFFdist,#0

;**********************************************************************
	s_and_var		B,p1_markstatus,#p1_markstatus_on^-1
;**********************************************************************


	s_pull_obj	y
	s_pull_obj	x

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
sp_Ealtmeter_off	macro	[plobj]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	1


	EXG_IFY	{plobj}

	PHY

	ldy	al_sword2,x
	s_and_alvar	B,y,exal_enemyaltmeter_flag,#exal_enemyaltmeter_on^-1

	PLY

	EXG_IFY	{plobj}

	stratmac_end

	ENDM

sp_Ealtmeter_on	macro	[plobj]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	1


	EXG_IFY	{plobj}

	PHY

	ldy		al_sword2,x
	s_or_alvar	B,y,exal_enemyaltmeter_flag,#exal_enemyaltmeter_flag_on

	PLY

	EXG_IFY	{plobj}

	stratmac_end

	ENDM

sp_Ealtmeter_player	macro	[plobj]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	1


	EXG_IFY	{plobj}

	PHY

	ldy		al_sword2,x
	s_or_alvar	B,y,exal_enemyaltmeter_flag,#exal_enemyaltmeter_flag_player

	PLY

	EXG_IFY	{plobj}

	stratmac_end

	ENDM


sp_jmp_ifEaltmeterON	macro	[plobj,label]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	2


	EXG_IFY	{plobj}
	PHY
	ldy		al_sword2,x
	lda		exal_enemyaltmeter_flag,y
	PLY
	EXG_IFY	{plobj}

	bit	#exal_enemyaltmeter_flag_on
	rlbne	{label}

	stratmac_end

	ENDM


sp_jmp_ifEaltmeterOFF	macro	[plobj,label]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	2


	EXG_IFY	{plobj}
	PHY
	ldy		al_sword2,x
	lda		exal_enemyaltmeter_flag,y
	PLY
	EXG_IFY	{plobj}

	bit	#exal_enemyaltmeter_flag_on
	rlbeq	{label}

	stratmac_end

	ENDM

sp_jmp_ifEaltmeterPLR	macro	[plobj,label]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	2


	EXG_IFY	{plobj}
	PHY
	ldy		al_sword2,x
	lda		exal_enemyaltmeter_flag,y
	PLY
	EXG_IFY	{plobj}

	bit	#exal_enemyaltmeter_flag_player
	rlbne	{label}

	stratmac_end

	ENDM

sp_jmpNOT_ifEaltmeterPLR	macro	[plobj,label]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	2


	EXG_IFY	{plobj}
	PHY
	ldy		al_sword2,x
	lda		exal_enemyaltmeter_flag,y
	PLY
	EXG_IFY	{plobj}

	bit	#exal_enemyaltmeter_flag_player
	rlbne	{label}

	stratmac_end

	ENDM


sp_ifinseatrig	macro	[obj,label]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}
	phy
	toheap	y,x
	lda	exal_viewflag3,y
	ply
	EXG_IFY	{obj}

	bit	#exal_VIEWflag3_insea_trig
	rlbne	{label}

	stratmac_end

	ENDM

sp_ifoutseatrig	macro	[obj,label]

	s_start_strat

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}
	phy
	toheap	y,x
	lda	exal_viewflag3,y
	ply
	EXG_IFY	{obj}
	bit	#exal_VIEWflag3_outsea_trig
	rlbne	{label}

	stratmac_end

	ENDM


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	PLAYER no WEAPON no kazu wo huyasutokini tsukau macro
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; player no SPECIAL WEAPON no kazu wo fuyasu.
; if full spweapnum then goto addr

wm_addspweapnum		macro	[obj,value,addr]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{obj}

	lda	{value}
	sta	x1
	jsl	addspweapnum_srou_l

	EXG_IFY	{obj}

	rlbcs	{addr}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; player no boost wo up suru.

wm_boostheatup	macro	[obj,value,hobj]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	s_set_alvar	B,y,exal_boostheatup,{value}

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; player no SPECIAL WEAPON no pointer wo INC suru.
; Special weapon wo hassya(SHOOT) shitatoki tukau.

wm_incspweappnt		macro	[obj,plobj,alvar]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{plobj}

	jsl		incspweappnt_srou_l
	s_set_alvar	B,{obj},{alvar},x1

	EXG_IFY	{plobj}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; player no SPECIAL WEAPON no kazu wo fuyasu.

wm_getspweappnt		macro	[obj,var]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	jsl		getspweappnt_srou_l
	s_copy_var2var	B,{var},x1

	EXG_IFY	{obj}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; relative 2 player( pointer al_ptr = player's pointer )

wm_relative_player	macro	[obj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}
	jsl		weap_relative2player_srou_l
	EXG_IFY	{obj}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; player no SPECIAL WEAPON wo change suru.

wm_setspweaptype		macro	[obj,name]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY	{obj}

	phy
	ldy		al_sword2,x
	s_set_alvar	B,y,exal_spweap_TYPE,#spweap_{name}
	ply

	EXG_IFY	{obj}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; player no weapon wo level up suru....

wm_weaplevelup	macro	[obj,hobj]

; level = 0,1,2

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}

	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	exal_weap_level,y
	cmp	#3
	bcs	.skip\@
	inc	a
	sta	exal_weap_level,y

.skip\@
	IFNE	NARG-2
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	ENDM



wm_set_weaplevel	macro	[obj,level,hobj]

; level = 0,1,2,3

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1,2

	EXG_IFY	{obj}

	IFNE	NARG-2
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	lda	#exal_weap_level_{level}
	sta	exal_weap_level,y

	IFNE	NARG-2
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end
	ENDM

;-----------------------------------------------------------------------------
wm_find_enemynearobj		MACRO	[obj2,obj1,min,max,rangemax,rangexmax,label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	7
	CHK_OBJ	{obj2}
	CHK_OBJ	{obj1}

	EXG_IFY	{obj1}

	lda	{rangexmax}
	sta	z2

	lda	{rangemax}
	sta	z1

	a16
	lda	{min}
	sta	tpz
	lda	{max}
	sta	tpx

	s_jsl	find_enemynearobject_l
	EXG_IFY	{obj1}

	cpy	#0
	a8
	rlbeq	{label}
		stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; weapon(mission mode) no speed wo set suru...

wm_set_speed	macro	[obj,name]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFX	{obj}

	lda	#{name}VELaw
	sta	tpx
	lda	#{name}VELrb
	sta	tpy
	jsr	weap_set_speed

	EXG_IFX	{obj}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
sm_varadd_alvar	MACRO	size,obj1,var,alvar
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4
	CHK_OBJ	\2

	CHG_MODE	\1
	lda		\3
	clc		
	adc.w		\4,\2
	sta		\3
	CHG_MODEBACK	\1
	stratmac_end
	ENDM

sm_varsub_alvar	MACRO	size,obj1,var,alvar
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4
	CHK_OBJ	\2

	CHG_MODE	\1
	lda		\3
	sec		
	sbc.w		\4,\2
	sta		\3
	CHG_MODEBACK	\1
	stratmac_end
	ENDM

;-----------------------------------------------------------------------------
sm_jmp_ABSvarless	MACRO		[size,var,value,label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4
	CHG_MODE	{size}

	lda.\0	{var}
	bpl	.nneg\@
	nega
.nneg\@
	cmp	{value}
	CHG_MODEBACK	{size}
	beq	.exit\@
	rlbmi	{label}
.exit\@

	stratmac_end
	ENDM

;-----------------------------------------------------------------------------
sm_jmp_ABSvarmore	MACRO		[size,var,value,label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4
	CHG_MODE	{size}

	lda.\0	{var}
	bpl	.nneg\@
	nega
.nneg\@
	cmp	{value}
	CHG_MODEBACK	{size}
	beq	.\@
	rlbpl	{label}
.\@

	stratmac_end
	ENDM



;-----------------------------------------------------------------------------
sm_dist_contSE	MACRO	[obj1,obj2,name]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{obj1}

	jsl	TSTRATsrous_l.getcontSEdistance

	EXG_IFY	{obj1}

	cmp	#2
	beq	.far\@
	cmp	#1
	beq	.normal\@


.near\@	ksound	{name}_l
	bra	.exit\@
.normal\@	ksound	{name}_m
	bra	.exit\@
.far\@	ksound	{name}_s

.exit\@

	stratmac_end
	ENDM

;-----------------------------------------------------------------------------
sm_dist_trigSE	MACRO	[obj1,obj2,name]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{obj1}

	jsl	TSTRATsrous_l.gettrigSEdistance

	EXG_IFY	{obj1}

	cmp	#2
	beq	.far\@
	cmp	#1
	beq	.normal\@


.near\@	ksound	{name}_s
	bra	.exit\@
.normal\@	ksound	{name}_s
	bra	.exit\@
.far\@	ksound	{name}_s

.exit\@

	stratmac_end
	ENDM

;-----------------------------------------------------------------------------
sm_get_dist	MACRO		[var,obj1,obj2]

	stratmac_start
MYNARG	=	NARG
	CHK_NARG	3

	jsl	TSTRATsrous_l.getdistance

	IFNE	"z1","\1"
	s_copy_var2var	W,{var},z1
	ENDC

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;-----------------------------------------------------------------------------
sm_Fchase_alvar 	MACRO	size,obj1,alvar,value,rate,[label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	5,6
	CHG_MODE	\1

	lda	\3,\2
	cmp	\4
	CHG_MODEBACK	\1

	IFEQ	NARG-6
	CHG_MODEBACK	\1
	rlbeq	\6
	CHG_MODE	\1
	ELSEIF
	rlbeq	.skip\@
	ENDC

	CHG_MODE	\1
	Fchase_A	\4,\5
	sta	\3,\2

.skip\@
	CHG_MODEBACK	\1
	stratmac_end
	ENDM
;-----------------------------------------------------------------------------
sm_Fchase_var 	MACRO	size,var,value,rate,[label]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	4,5
	CHG_MODE	\1

	lda	\2
	cmp	\3
	CHG_MODEBACK	\1

	IFEQ	NARG-5
	CHG_MODEBACK	\1
	rlbeq	\5
	CHG_MODE	\1
	ELSEIF
	rlbeq	.skip\@
	ENDC

	CHG_MODE	\1
	Fchase_A	\3,\4
	sta	\2

.skip\@
	CHG_MODEBACK	\1
	stratmac_end
	ENDM
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; weapon ga slope ni hit sitaka?

sm_jmp_hitslope		macro	[obj,var,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY		{obj}

	lda	al_slopenum,x
	pha

	jsl	getheight_l

	pla
	sta	al_slopenum,x

	s_copy_var2var	W,{var},y1
	EXG_IFY		{obj}

	s_jmp_alvarEQ	B,{obj},al_slopetype,#st_wall,.exit\@

	s_jmp_alvarMORE	W,{obj},al_worldy,y1,{label}

.exit\@
	stratmac_end
	ENDM



sm_jmpNOT_hitslope		macro	[obj,var,label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY		{obj}

	lda	al_slopenum,x
	pha

	jsl		getheight_l

	pla
	sta	al_slopenum,x

	s_copy_var2var	W,{var},y1
	EXG_IFY		{obj}

	s_jmp_alvarEQ	B,{obj},al_slopetype,#st_wall,{label}

	s_jmp_alvarLESS	W,{obj},al_worldy,y1,{label}

.exit\@
	stratmac_end
	ENDM

;------------------------------------------------------------------------
sm_setport2_dist	macro	[obj,obj2,sofardist,fardist,neardist]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	5

	s_set_var	W,x1,#{sofardist}
	s_set_var	W,y1,#{fardist}
	s_set_var	W,z1,#{neardist}

	jsl	setport2dist_l

	stratmac_end
	ENDM

;------------------------------------------------------------------------
sm_jmp_ifhitanything		macro	[obj,label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY		{obj}
	jsl		hitsomething_snd_srou_l
	EXG_IFY		{obj}
	rlbcs	{label}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
sm_jmpnot_ifhitanything	macro	[obj,label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	EXG_IFY		{obj}
	jsl		hitsomething_srou_l
	EXG_IFY		{obj}
	rlbcc	{label}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
sm_arena_pos	macro	[obj,player,sizex,sizez,R]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	5

	EXG_IFY		{obj}

	s_set_var	W,ARENA_sizex,{sizex}
	s_set_var	W,ARENA_sizez,{sizez}
	s_set_var	W,ARENA_radius,{R}

	s_copy_alvar2var	W,x,ARENA_centerx,al_worldx
	s_copy_alvar2var	W,x,ARENA_centery,al_worldy
	s_copy_alvar2var	W,x,ARENA_centerz,al_worldz

	PHY

	s_set_objtobeplayer{player}	y

	jsl	moveARENA_srou_l2

	s_set_alvar	W,x,al_worldx,ARENA_centerx
;	s_set_alvar	W,x,al_worldy,ARENA_centery
	s_set_alvar	W,x,al_worldz,ARENA_centerz

	PLY

	EXG_IFY		{obj}

	stratmac_end

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	check screen mode
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
sm_jmp_ifmission	macro	[label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	sm_jmp_if1screen	{label}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
sm_jmp_ifbattle	macro	[label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	sm_jmp_if2screen	{label}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
sm_jmp_if1screen	macro	[label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	test_screenmode	onescreen
	rlbne	{label}

	stratmac_end

	ENDM

;------------------------------------------------------------------------
sm_jmp_if2screen	macro	[label]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	test_screenmode	onescreen
	rlbeq	{label}

	stratmac_end

	ENDM
;------------------------------------------------------------------------
sp_cockpit	macro	[switch]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	PMODE
	and	#0ffh
	bne	.RB\@

	lda	playerimportflag
	and	#~pif_cockpit_on
	ora	#pif_cockpit_trig!pif_cockpit_{switch}

	bra	.sta\@

.RB\@	lda	playerimportflag
	and	#~pif_cockpit_onRB
	ora	#pif_cockpit_trig!pif_cockpit_{switch}RB
.sta\@

	sta	playerimportflag

	stratmac_end

	ENDM

;------------------------------------------------------------------------
sp_cockpit_init	macro

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	0

	lda	playerimportflag
	ora	#pif_cockpit_trig
	sta	playerimportflag

	stratmac_end

	ENDM




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	CIRCLEWINDOW MACRO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
sm_circle_pri	macro	[obj,switch,hobj]


	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY	{obj}

	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC


	IFC	"on","{switch}"
	s_or_alvar	B,y,exal_circle_flag,#exal_circle_flag_pri
	ENDC
	IFC	"off","{switch}"
	s_and_alvar	B,y,exal_circle_flag,#~exal_circle_flag_pri
	ENDC


	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY	{obj}

	stratmac_end

	ENDM


sm_circle_on	macro	[obj,cgaddsub,step,fade]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	4

	EXG_IFY	{obj}

	a16
	lda	{step}
	sta	tpx
	a8

	lda	{cgaddsub}
	sta	tpy
	lda	{fade}
	sta	tpz

	jsl	circle_on_srou_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM


sm_circle_pos	macro	[obj,x,y]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	3

	EXG_IFY	{obj}

	a16
	lda	{x}
	sta	tpx
	lda	{y}
	sta	tpy
	a8

	jsl	circle_pos_srou_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM



sm_circle_objpos	macro	[obj]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	EXG_IFY	{obj}

	jsl	circle_objpos_srou_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM



sm_circle_RGB	macro	[obj,r,g,b]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	4

	EXG_IFY	{obj}

	lda	{r}
	sta	tpx
	lda	{g}
	sta	tpy
	lda	{b}
	sta	tpz

	jsl	circle_RGB_srou_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM


sm_circle_decRGB	macro	[obj,r,g,b]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	4

	EXG_IFY	{obj}

	lda	{r}
	sta	tpx
	lda	{g}
	sta	tpy
	lda	{b}
	sta	tpz

	jsl	circle_decRGB_srou_l

	EXG_IFY	{obj}

	stratmac_end

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	WARIZAN
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
tm_divs16816mac	macro		; \3.w = \1.w / \2.b	(a16i8)

	phx

	ai16


	ldx	\2
	bpl	\@2p

	txa
	eor	#$ffff
	inc	a
	tax

	lda	\1
	bpl	\@2n1p

	eor	#$ffff
	inc	a
	sta.l	wrdivl
	txa	;**
	sta.l	wrdivb
	jmp	\@3p

\@2n1p
	sta.l	wrdivl
	txa	;**
	sta.l	wrdivb
	jmp	\@3n

\@2p
	lda	\1
	bpl	\@2p1p
	eor	#$ffff
	inc	a
	sta.l	wrdivl
	txa	;**
	sta.l	wrdivb
	nop
\@3n
	nop
	nop
	nop
	nop
	nop
	lda	#0
	sec
	sbc.l	rddivlr
	jmp	\@exit

\@2p1p
	sta.l	wrdivl
	txa	;**
	sta.l	wrdivb
	nop
\@3p
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	lda.l	rddivlr
\@exit
	sta	\3

	a8i16

	plx


	endm

;------------------------------------------------------------------------
pilottab	macro	[size,name]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	IFC	"B","\1"
	byte	{name}FOX&BM
	byte	{name}FALCO&BM
	byte	{name}PEPPY&BM
	byte	{name}SLIPPY&BM
	byte	{name}GAL1&BM
	byte	{name}GAL2&BM
	ENDC

	IFC	"W","\1"
	word	{name}FOX&WM
	word	{name}FALCO&WM
	word	{name}PEPPY&WM
	word	{name}SLIPPY&WM
	word	{name}GAL1&WM
	word	{name}GAL2&WM
	ENDC

	stratmac_end
	ENDM


FOXpilottab	macro	[size,name]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	IFC	"B","\1"
	byte	{name}FOX&BM
	byte	{name}FOX&BM
	byte	{name}FOX&BM
	byte	{name}FOX&BM
	byte	{name}FOX&BM
	byte	{name}FOX&BM
	ENDC

	IFC	"W","\1"
	word	{name}FOX&WM
	word	{name}FOX&WM
	word	{name}FOX&WM
	word	{name}FOX&WM
	word	{name}FOX&WM
	word	{name}FOX&WM
	ENDC

	stratmac_end
	ENDM
;------------------------------------------------------------------------
pilottabNEG	macro	[size,name]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	IFC	"B","\1"
	byte	-{name}FOX
	byte	-{name}FALCO
	byte	-{name}PEPPY
	byte	-{name}SLIPPY
	byte	-{name}GAL1
	byte	-{name}GAL2
	ENDC

	IFC	"W","\1"
	word	-{name}FOX
	word	-{name}FALCO
	word	-{name}PEPPY
	word	-{name}SLIPPY
	word	-{name}GAL1
	word	-{name}GAL2
	ENDC

	stratmac_end
	ENDM
;------------------------------------------------------------------------
shapetab	macro	[size,name]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	IFC	"B","\1"
	byte	{name}FF
	byte	{name}SP
	byte	{name}GG
	ENDC

	IFC	"W","\1"
	word	{name}FF
	word	{name}SP
	word	{name}GG
	ENDC

	stratmac_end
	ENDM

shapetabNEG	macro	[size,name]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	IFC	"B","\1"
	byte	-{name}FF
	byte	-{name}SP
	byte	-{name}GG
	ENDC

	IFC	"W","\1"
	word	-{name}FF
	word	-{name}SP
	word	-{name}GG
	ENDC

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	DEBUG MACRO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
debug_bossmode	macro

	stratmac_start

;	IFNE	BOSSDEBUG

	testjoypad	A,pcont
	beq		.exit\@
	testjoypad	B,pcont
	beq		.exit\@
	testjoypad	X,pcont
	beq		.exit\@
	testjoypad	Y,pcont
	beq		.exit\@
	testjoypad	tright,pcont
	beq		.exit\@

	lda	#0
	sta	KEnemyNumber

.exit\@
;	ENDC

	stratmac_end
	ENDM


debug_gameclear	macro

	stratmac_start

;	IFNE	BOSSDEBUG

	testjoypad	A,pcont
	beq		.exit\@
	testjoypad	B,pcont
	beq		.exit\@
	testjoypad	X,pcont
	beq		.exit\@
	testjoypad	Y,pcont
	beq		.exit\@
	testjoypad	tleft,pcont
	beq		.exit\@

	ct_set_chartptr	x,gameclear

	lda	#0
	sta	KEnemyNumber

.exit\@
;	ENDC
	stratmac_end
	ENDM


debug_killboss	macro

	stratmac_start

	IFNE	BOSSDEBUG

	testjoypad	A,pcont
	beq		.exit\@
	testjoypad	B,pcont
	beq		.exit\@
	testjoypad	X,pcont
	beq		.exit\@
	testjoypad	Y,pcont
	beq		.exit\@
	testjoypad	tright,pcont
	beq		.exit\@

	s_set_alvar		B,x,al_HP,#0	;remove


.exit\@
	ENDC
	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	MACRO for voffset
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
c_vofsoff	macro	[obj]

	stratmac_start

MYNARG	=	NARG

	CHK_NARG	1

	;***s_jmp_alsflag	{obj},player2,.p2\@

.p1\@	lda	voffsetflag
	ora	#voffsetflag_p1off
	;***bra	.skip\@

.p2\@	;***lda	voffsetflag
	;***ora	#voffsetflag_p2off
.skip\@	sta	voffsetflag

	stratmac_end

	ENDM


c_vofson	macro	[obj]

	stratmac_start

MYNARG	=	NARG

	CHK_NARG	1

	;***s_jmp_alsflag	{obj},player2,.p2\@

.p1\@	lda	voffsetflag
	;and	#voffsetflag_p1off^-1
	;***bra	.skip\@

.p2\@	;***lda	voffsetflag
	;and	#voffsetflag_p2off^-1
.skip\@	sta	voffsetflag

	stratmac_end

	ENDM


set_vofsoff	macro	[player]

	stratmac_start

MYNARG	=	NARG

	CHK_NARG	1


	lda	voffsetflag
	ora	#voffsetflag_p{player}off
	sta	voffsetflag

	stratmac_end

	ENDM

set_vofson	macro	[player]

	stratmac_start

MYNARG	=	NARG

	CHK_NARG	1


	lda	voffsetflag
	and	#voffsetflag_p{player}off^-1
	sta	voffsetflag

	stratmac_end

	ENDM


test_vofsoff	macro	[1or2]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	voffsetflag
	and	#voffsetflag_p{1or2}off

	stratmac_end

	ENDM




;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	MACRO for CHART
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ct_set_chartptr	macro	[obj,pointer,hobj]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2,3

	EXG_IFY		{obj}


	IFNE	NARG-3
	PHY
	toheap	y,x
	ELSEIF
	CHK_SAMEOBJ	{obj},{hobj}
	ENDC

	IFC	"off","\2"

	a16
	lda	#0
	sta	exal_chartptr,y
	sta	exal_charttimer,y
	sta	exal_charttimer_skip,y
	a8
	sta	exal_chartptr+2,y

	ELSEIF
	lda	#(chart_{pointer}&0ff0000H)/10000H
	cmp	exal_chartptr+2,y
	beq	.skip0\@
	sta	exal_chartptr+2,y
.skip0\@	a16
	lda	#(chart_{pointer})&WM
	cmp	exal_chartptr,y
	beq	.skip1\@
	sta	exal_chartptr,y

	lda	#0
	sta	exal_charttimer,y
	sta	exal_charttimer_skip,y
.skip1\@	a8
	ENDC

	IFNE	NARG-3
	ply
	ENDC

	EXG_IFY		{obj}

	stratmac_end

	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	test value
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ldatestvalue	macro	[size,var]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2


	testjoypad	tleft,pcont
	beq		.skip\@

	testjoypad	tright,pcont
	beq		.skip\@

	testjoypad	left,pcont
	bne		.dec\@

	testjoypad	right,pcont
	beq		.skip\@


.inc\@	s_inc_var	{size},testcounter
	bra	.skip\@

.dec\@	s_dec_var	{size},testcounter

.skip\@
	s_copy_var2var	{size},{var},testcounter

	CHG_MODE	{size}
	lda		{var}
;	printh		< now testing >,kawagoe
	CHG_MODE	{size}

	stratmac_end

	ENDM


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
plabsa	macro	[var]

MYNARG	=	NARG
	CHK_NARG	0

	bpl	.skip\@
	nega
.skip\@

	endm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

byte16	macro	[data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13,data14,data15]

	byte	{data0}
	byte	{data1}
	byte	{data2}
	byte	{data3}
	byte	{data4}
	byte	{data5}
	byte	{data6}
	byte	{data7}
	byte	{data8}
	byte	{data9}
	byte	{data10}
	byte	{data11}
	byte	{data12}
	byte	{data13}
	byte	{data14}
	byte	{data15}

	endm


;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³macro of transform animation data³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tranimdec	macro	[shape0,shape1,shape2,init,nextmode]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	5

	dw	{shape0}		;anim0 shape
	db	{shape0}_maxframe	;anim0 max   frame
	db	0			;anim0 final frame
	db	-1			;anim0 add   frame
	db	{shape0}_maxframe-1	;anim0 init  frame
	dw	{shape1}		;anim1 shape frame
	db	{shape1}_maxframe	;anim1 max   frame
	db	0			;anim1 final frame
	db	-1			;anim1 add   frame
	db	{shape1}_maxframe-1	;anim1 init  frame
	dw	{nextmode}		;next mode
	dw	{shape2}		;next shape
	db	{init}			;next init frame

	stratmac_end

	ENDM

traniminc	macro	[shape0,shape1,shape2,init,nextmode]
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	5

	dw	{shape0}			;anim0 shape
	db	{shape0}_maxframe	;anim0 max   frame
	db	{shape0}_maxframe-1	;anim0 final frame
	db	1			;anim0 add   frame
	db	1			;anim0 init  frame

	dw	{shape1}			;anim1 shape frame
	db	{shape1}_maxframe	;anim1 max   frame
	db	{shape1}_maxframe-1	;anim1 final frame
	db	1			;anim1 add   frame
	db	1			;anim1 init  frame

	dw	{nextmode}
	dw	{shape2}		;next shape
	db	{init}			;next init frame
	stratmac_end

	ENDM


;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ alvar ---> zero ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       
ta_alvar2zero	macro	[obj,alvar,rate]

	stratmac_start

	lda	{alvar},{obj}

	IFNE	LONGA
	jsr	.perc{rate}W
	ELSEIF
	jsr	.perc{rate}B
	ENDC
	sta	{alvar},{obj}

	stratmac_end

	ENDM

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³set demomode demoNo & clear demoflag³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

set_demomode	macro	[name]

	stratmac_start

	s_set_var	B,demoflag,#0
	s_set_var	B,demomode,#1
	s_set_var	B,demoNo,#demo_{name}

	stratmac_end

	ENDM

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³starwolf has come!³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

starwolf_demo_on	macro

	stratmac_start

	lda	starwolf_demo
	ora	#starwolf_demo_on
	sta	starwolf_demo

	stratmac_end


	ENDM



pl_jmp_iftranscoloff		macro	[label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	plrcolflag
	bit	#plrcolflag_transoff
	rlbne	{label}

	stratmac_end

	ENDM

pl_transcol		macro	[switch]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	plrcolflag
	IFC	"off","\1"
	ora	#plrcolflag_transoff
	ELSEIF
	and	#~plrcolflag_transoff
	ENDC
	sta	plrcolflag

	stratmac_end

	ENDM

;--------------------------------------------------

sp_display	macro	[onoff]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	displayflag

	IFC	"off","\1"
	and	#~displayflag_on
	ELSEIF
	ora	#displayflag_on
	ENDC

	sta	displayflag

	stratmac_end
	ENDM



sp_ifdisplayON	macro	[label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	displayflag
	bit	#displayflag_on
	rlbne	{label}

	stratmac_end
	ENDM



sp_ifdisplayOFF	macro	[label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	displayflag
	bit	#displayflag_on
	rlbeq	{label}

	stratmac_end
	ENDM


;--------------------------------------------------

sp_ifviewchangeON	macro	[label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	playerexportflag
	bit	#pef_viewchange_on
	rlbne	{label}

	stratmac_end
	ENDM


sp_ifviewchangeOFF	macro	[label]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	playerexportflag
	bit	#pef_viewchange_on
	rlbeq	{label}

	stratmac_end
	ENDM


sp_viewchange	macro	[switch]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	playerexportflag

	IFC	"on","\1"
	ora	#pef_viewchange_on
	ELSEIF
	and	#~pef_viewchange_on
	ENDC

	sta	playerexportflag

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Tame homing ON
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
sp_tamehomon	macro

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	0

	lda	p_tamehom	; tame homing flag
	ora	#p_tamehom_p1
	sta	p_tamehom

	stratmac_end
	ENDM

sp_jmp_iftamehomon	macro	[lavel]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	p_tamehom	; tame homing flag
	bit	#p_tamehom_p1
	rlbne	{lavel}

	stratmac_end
	ENDM

sp_jmpnot_iftamehomon	macro	[lavel]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	1

	lda	p_tamehom	; tame homing flag
	bit	#p_tamehom_p1
	rlbeq	{lavel}

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; swap player1,2 parameter
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

sp_swapvar	macro	[size,var]

	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2

	CHG_MODE	\1

	lda	p1{var}
	PHA
	lda	p2{var}
	sta	p1{var}
	PLA
	sta	p2{var}


	CHG_MODEBACK	\1

	stratmac_end
	ENDM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;	end of file
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	end
