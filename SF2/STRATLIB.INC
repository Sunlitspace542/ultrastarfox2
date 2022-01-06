;***************************************************************************
;*                                                                         *
;*                              StartGlider                                *
;*                              -----------                                *
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                           Argonaut Software.      		      *	   
;*                                                                         *
;*_________________________________________________________________________*
;*                                                                	      *
;*   File: STRATLIB.ASM                                                    *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: EXTRA STRATEGY MACROS.                                          *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 11/2/92                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:		Dylan Cuthbert      				      *	
;*                                                                         *
;***************************************************************************


make_resource	MACRO	[resourcename]
		IFND	mr_count
mr_count		=	1
		ENDC
r_{resourcename}	=	mr_count
mr_count		=	mr_count+1
		ENDM


;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                             ³
;³ Pre-defined Resource Types  ³
;³                             ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	make_resource	fireobj
	make_resource	debrisshape
	make_resource	pathstart
	make_resource	poslist
	make_resource	while_hit
	make_resource	start_hit
	make_resource	end_hit
	make_resource	viewpos	; pointer to heap allocated copy of viewblk
	make_resource	sounddistance
	make_resource	Pweapshape	; player no weapon no shape.(Kawagoe)
	make_resource	enemySEtype	; hit sitatokino SE
	make_resource	WhenDead
	make_resource	enemyRBDSEtype	; rebound sitatokino SE


; ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
; ³ extra strategy macros:  ³
; ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;--------------- Memory macros -------------------------------
; sobj = stack's object (normally same as obj)
; s_mpush		MACRO		[size,sobj,obj,alvar] | [size,sobj,A] | [size,sobj,mem] | [size,sobj,X] | [size,sobj,Y]
; s_mpull		MACRO		[size,sobj,obj,alvar] | [size,sobj,A] | [size,sobj,mem] | [size,sobj,X] | [size,sobj,Y]
; mobj = alien to resource track, Y|X is set to allocated memory address
; s_alloc		MACRO		[mobj,Y|X,amount]
; s_free		MACRO		[mobj,Y|X]
; s_realloc		MACRO		[mobj,memobj,newamount]
; s_freeall		MACRO		[mobj]

;--------------- Resource macros -----------------------------
; To cope with the increasing demand on alien variables these
; resource macros have been created.  Resources are stored on
; the heap per alien, so you don't have to create alien variables
; just because one or two aliens need them.  Use the macro
; make_resource to create more resource types.
; s_get_resource jumps to [label] if the resource doesn't exist
; s_set_resource creates a resource entry if resource doesn't already exist
; Note: the other index register is destroyed or set to a result.
;
; s_set_resource	MACRO		[size,obj,resource,Y|X|A|mem]
; s_get_resource	MACRO		[size,obj,Y|X|A|mem,resource,label]
; s_del_resource	MACRO		[obj,resource]
;
;	s_get_resource	W,x,A,sounddistance,.error
;
;	s_set_resource	W,x,sounddistance,A

;--------------- Animation macros ----------------------------
;
; s_init_anim	MACRO		obj1,frame
; s_init_colanim	MACRO		obj1,colframe
; s_add_colanim	MACRO		obj1,amount,maxframes[,label][,firstframe][NOJUMP,firstframe]
; s_add_anim		MACRO		obj1,amount,maxframes[,label][,firstframe][NOJUMP,firstframe]
; s_cmp_anim		MACRO		obj1,value
; s_cmp_colanim	MACRO		obj1,value

;--------------- Hitflag macros ------------------------------
;
; s_test_hitflags	MACRO		obj1,mask (e.g. #HF1...HF8)
; s_clr_hitflags	MACRO		obj1,mask (e.g. #HF1...HF8)
; s_jmp_ifhitby	MACRO		obj1,colltype or shape,address
;--------------- Miscellaneous -------------------------------
;
; s_implode		MACRO		obj1,strat
; s_bemother		MACRO		obj1
; s_move_objtoend	MACRO		obj
; s_set_path		MACRO		obj,pathname
; s_set_pstrat	MACRO		obj1
; s_text_obj		MACRO		[obj,text,colour[,size]]
; s_sprite_obj	MACRO		[obj,colour,size]
; s_score		MACRO		[score]
; s_playercontroller	MACRO
; s_rotate_16bit	MACRO		rotates 16 bit x1,y1,z1 with 16 bit matxw-zw

;--------------- Strategy mode changing macros ---------------
;
; s_mode_table	MACRO
; s_mode_entry	MACRO		routine name[,labelname]
; s_mode_label	MACRO		label name
; s_mode_change	MACRO		obj,((ABS modenumber OR #+/-offset)|obj,alvar)
; s_mode_table_end	MACRO

;--------------- Colour table macros -------------------------
;
; s_set_coltab	MACRO	obj,colour table
; s_clr_coltab	MACRO	obj

;--------------- Boss HP Meter Macros ------------------------
;
; s_set_bossmaxHP	MACRO	maxHP | obj,alvar
; s_add_bossHP	macro	([var] | [obj,alvar]), ([offset | []  ] | [obj2,alvar])
; s_add_bossmaxHP	macro	([var] | [obj,alvar]), ([offset | []  ] | [obj2,alvar])

;--------------- Extended Children Macros -----------------------
;
; s_make_childobjrotpos	MACRO	shape,child,x,y,z,rotx,roty,rotz,#strategy ptr,[colltype]
; s_rotpos_child		MACRO	childobj
; s_rotpos_allchildren	MACRO	motherobj
; s_set_childs_sflag		MACRO	motherobj,sflag[,rangebegin,rangeend]|[,child num]
; s_clr_childs_sflag		MACRO	motherobj,sflag[,rangebegin,rangeend]|[,child num]
; s_jmp_childrendead		MACRO	motherobj[,rangebegin,rangeend]|[,child num],label

;--------------- Plane clipping macros -----------------------
;
; s_set_clipping		MACRO	obj,planenum

;--------------- Blockmap macros for checking the map --------
;
; s_jmp_ifsolid		MACRO	obj,label
; s_jmp_ifnotsolid		MACRO	obj,label

;--------------------------------------------------------------------------
; the following macros allow an object to lock its position relative
; to another object (the position is relative to the rotation of
; of the object being locked to)
;
; s_lock_obj must be called once only to initialise the position
; s_track_obj must be called every frame, this will update the object's position
;
; if a shape wants to change its relative position it must change
; childx, childy, childz, or to change its angle it should change
; childrotx, childroty, childrotz
; obviously this object cannot be a child object any more.
;
; s_lock_obj			MACRO	[obj1,obj2]
; s_track_obj		MACRO	[obj1,rate]

;--------------------------------------------------------------------------




;--------------------------------------------------------------------------
; s_implode		MACRO		obj1,strat
s_implode	MACRO
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	s_set_alvar	W,\1,al_ptr,\2
	s_set_strat	\1,#implode_istrat&WM
	
	stratmac_end
	endm


;--------------------------------------------------------------------------
; s_bemother		MACRO		obj1

s_bemother	MACRO
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	1

	phx
	phy
	php

	IFC	"y","\1"
	tyx
	ENDC

	s_jsl	bemother_l

	plp
	ply
	plx
	
	
	stratmac_end
	endm

;--------------------------------------------------------------------------
; s_init_anim		MACRO		obj1,frame

s_init_anim		MACRO
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	\1

	lda	\2
	ora	#128
	s_sta	al_animframe,\1

	stratmac_end
	endm

;--------------------------------------------------------------------------
; s_init_colanim	MACRO		obj1,colframe

s_init_colanim	MACRO
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	\1

	lda	\2
	ora	#128
	s_sta	al_colframe,\1

	stratmac_end
	endm

;--------------------------------------------------------------------------
; s_add_colanim	MACRO		obj1,amount,maxframes[,label][,firstframe][NOJUMP,firstframe]
sac_NOJUMP	=	12345

s_add_colanim	MACRO
	stratmac_start

	IFLT	NARG-3
	fail	; strategy parameter error
	ENDC

	CHK_OBJ	\1

; set up the init frame value
	IFEQ	NARG-5
if	=	1
	ELSEIF
if	=	0
	ENDC


	s_lda	al_colframe,\1
	clc
	adc	\2

	IFEQ	if
	bmi	.ok\@
	clc
	adc	\3
	ELSEIF
	cmp	\5
	bmi	.ok\@
	clc
	adc	\3
	sec
	sbc	\5
	ENDC
.ok\@
	and	#127

; set up the jmp condition
jmp	=	0
	IFGE	NARG-4
	IFD	sac_\4
jmp	=	0
	ELSEIF
jmp	=	1
	ENDC
	ENDC


	IFNE	jmp
	cmp	\3
	bcc	.ok2\@
	lda	\3
	dec	a
	ora	#128
	s_sta	al_colframe,\1
	jmp	\4
.ok2\@
	ELSEIF
	cmp	\3
	bcc	.ok2\@
	sec
	sbc	\3
	IFNE	if
	clc
	adc	\5
	ENDC
.ok2\@
	ENDC

	ora	#128

	s_sta	al_colframe,\1

		
	stratmac_end
	endm


;--------------------------------------------------------------------------
; s_add_anim	MACRO		obj1,amount,maxframes[,label][,firstframe][NOJUMP,firstframe]

s_add_anim	MACRO
	stratmac_start

	IFLT	NARG-3
	fail	; strategy parameter error
	ENDC

	CHK_OBJ	\1

; set up the init frame value
	IFEQ	NARG-5
if	=	1
	ELSEIF
if	=	0
	ENDC


	s_lda	al_animframe,\1
	clc
	adc	\2

	IFEQ	if
	bmi	.ok\@
	clc
	adc	\3
	ELSEIF
	cmp	\5
	bmi	.ok\@
	lda	\5
;	clc
;	adc	\3
;	sec
;	sbc	\5
	ENDC
.ok\@
	and	#127

; set up the jmp condition
jmp	=	0
	IFGE	NARG-4
	IFD	sac_\4
jmp	=	0
	ELSEIF
jmp	=	1
	ENDC
	ENDC


	IFNE	jmp
	cmp	\3
	bcc	.ok2\@
	lda	\3
	dec	a
	ora	#128
	s_sta	al_animframe,\1
	jmp	\4
.ok2\@
	ELSEIF
	cmp	\3
	bcc	.ok2\@
	sec
	sbc	\3
	IFNE	if
	clc
	adc	\5
	ENDC
.ok2\@
	ENDC

	ora	#128

	s_sta	al_animframe,\1

		
	stratmac_end
	endm



;--------------------------------------------------------------------------
; s_cmp_anim		MACRO		obj1,value

s_cmp_anim		MACRO
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	\1

	s_lda	al_animframe,\1
	and	#127
	cmp	\2

	stratmac_end
	endm


;--------------------------------------------------------------------------
; s_cmp_colanim	MACRO		obj1,value

s_cmp_colanim	MACRO
	stratmac_start
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	\1

	s_lda	al_colframe,\1
	and	#127
	cmp	\2
		
	stratmac_end
	endm


;--------------------------------------------------------------------------
; s_test_hitflags	MACRO		obj1,mask (e.g. #HF1...HF8)

s_test_hitflags	MACRO
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	\1

	lda.\0	al_hitflags,\1
	and	\2

	stratmac_end
	endm


;--------------------------------------------------------------------------
; s_clr_hitflags	MACRO		obj1,mask (e.g. #HF1...HF8)

s_clr_hitflags	MACRO
	stratmac_start

MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	\1

	lda	\2
	eor	#-1
	and	al_hitflags,\1
	sta.\0	al_hitflags,\1

	stratmac_end
	endm


;--------------------------------------------------------------------------
; s_mode_table	MACRO
; begins a table of modes

s_mode_table	MACRO
	stratmac_start

	a16
	lda	#(.table\@)&WM
	sta	tempaddrl
	a8
	lda	#(.table\@)>>16
	sta	tempaddrl+2

	jml	jumptostate_l

.table\@
smt_modenum	=	0
	stratmac_end
	ENDM

;--------------------------------------------------------------------------
; s_mode_entry	MACRO		routine name

s_mode_entry	MACRO
	stratmac_start
	IFGE	NARG-2
\2	equ	smt_modenum
	ENDC

	db	(\1)>>16
	dw	((\1)-1)&WM

	db	0

smt_modenum	=	smt_modenum+1

	stratmac_end
	ENDM

;--------------------------------------------------------------------------
; s_mode_label	MACRO		label name

s_mode_label		MACRO
	stratmac_start
\1	equ	smt_modenum
	stratmac_end
		ENDM

;--------------------------------------------------------------------------
; s_mode_change	MACRO		obj,A|((ABS modenumber OR #+/-offset)|obj,alvar)

s_mode_change	MACRO
MYNARG	=	NARG
	stratmac_start

	remhash	2,\2

	CHK_OBJ	\1
	CHK_NARG	2
	EXG_IFY	\1

	run	" IFND sabo_%$2"

	defs	$1,"[1]\2"
	getmval	<\2>

	IFNE	smc
	IFEQ	smc-1
	lda	#\2
	s_jsl	modechangeadd_l
	ELSEIF
	IFEQ	smc-2
	lda.\0	\3,\2
	s_jsl	modechangeadd_l
	ELSEIF
	lda.\0	\3,\2
	eor	#-1
	inc	a
	s_jsl	modechangeadd_l
	ENDC
	ENDC
	ELSEIF
	IFC	"\2","A"
	sta	al_stratstate,x
	ELSEIF
	IFC	"\2","a"
	sta	al_stratstate,x
	ELSEIF
	lda	\2
	sta	al_stratstate,x
	ENDC
	ENDC
	ENDC

	ELSEIF
	lda.\0	\3,\2
	sta	al_stratstate,x
	ENDC

	EXG_IFY	\1

	stratmac_end
		ENDM

getmval	MACRO
smc	=	0
	IFC	"\$1","+"
smc	=	1
	IFC	"\1","+x"
smc	=	2
	ENDC
	IFC	"\1","+y"
smc	=	2
	ENDC
	ENDC
	IFC	"\$1","-"
smc	=	1
	IFC	"\1","-x"
smc	=	3
	ENDC
	IFC	"\1","-y"
smc	=	3
	ENDC
	ENDC
	ENDM

chg_mode_a	MACRO
	phy
	a16
	and	#255
	asl	a
	asl	a
	tay
	lda.l	[tempaddrl],y
	sta	al_stratptr,x
	iny
	iny
	a8
	lda.l	[tempaddrl],y
	sta	al_stratptr+2,x
	ply
	ENDM

;--------------------------------------------------------------------------
; s_mode_table_end	MACRO

s_mode_table_end	MACRO
	IFGE	smt_modenum-257
	run	" error <Too many modes!!!!!  (",smt_modenum,")>"
	ENDC
		ENDM

;--------------------------------------------------------------------------
; s_move_objtoend	MACRO	obj

s_move_objtoend	MACRO
MYNARG	=	NARG
	stratmac_start
	CHK_OBJ		\1
	CHK_NARG	1
	EXG_IFY		\1
	s_jsl	moveobjtoend_l
	EXG_IFY		\1
	stratmac_end
		ENDM
;--------------------------------------------------------------------------
; s_set_coltab	MACRO	obj,colour table

s_set_coltab	MACRO
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	\1
	a16
	lda	\2
	s_sta	al_coltab,\1
	a8
	ENDM

;--------------------------------------------------------------------------
; s_clr_coltab	MACRO	obj

s_clr_coltab	MACRO
MYNARG	=	NARG
	CHK_NARG	1
	CHK_OBJ	\1
	a16
	lda	#0
	s_sta	al_coltab,\1
	a8
	ENDM



;--------------------------------------------------------------------------
; s_set_bossmaxHP	MACRO	maxHP | obj,alvar

s_set_bossmaxHP	MACRO	[value,alvar]

	stratmac_start

	IFEQ	NARG-1
	lda	{value}
	sta.l	m_bossmaxHP
	ELSEIF
	IFEQ	NARG-2
	CHK_OBJ	{value}
	s_copy_alvar2var.l	B,{value},m_bossmaxHP,{alvar}
	ELSEIF

	printf	"%m maxHP | obj,alvar"
	ENDC
	
	ENDC

	lda	#0
	sta.l	m_bossHP

	stratmac_end
		ENDM

;--------------------------------------------------------------------------
; s_add_bossHP	macro	([var] | [obj,alvar]), ([offset | []  ] | [obj2,alvar])

sabo_x		=	1
sabo_y		=	2


remhash	macro	[stringnum,string]
	defs	{stringnum},"{string}"
	IFS	{stringnum},0,"#"
	substr	1,,{stringnum}
	ENDC

	IFS	{stringnum},0,"$"
	substr	1,,{stringnum}
	ENDC

	IFS	{stringnum},0,"%"
	substr	1,,{stringnum}
	ENDC

	endm



s_add_bossHP	macro

	stratmac_start

	lda.l	m_bossHP

	remhash	1,\1
	remhash	2,\2
	remhash	3,\3

	run	" IFD sabo_%$1"
	clc
	adc.\0	\2,\1

	IFEQ	NARG-2
	ELSEIF

	run	" IFD sabo_%$3"
 	clc
	adc.\0	\4,\3
	ELSEIF
	clc
	adc	\3
	ENDC
	ENDC


	ELSEIF
	clc
	adc.\0		\1

	IFEQ	NARG-1
	ELSEIF
	run	" IFD sabo_%$2"
	clc
	adc.\0	\3,\2
	ELSEIF
	clc
	adc	\2
	ENDC
	ENDC
	ENDC

	sta.l	m_bossHP

	stratmac_end

	endm

;--------------------------------------------------------------------------
; s_add_bossmaxHP	macro	([var] | [obj,alvar]), ([offset | []  ] | [obj2,alvar])

sabo_x		=	1
sabo_y		=	2

s_add_bossmaxHP	macro

	stratmac_start

	remhash	1,\1
	remhash	2,\2
	remhash	3,\3

	lda.l	m_bossmaxHP

	run	" IFD sabo_%$1"
	clc
	adc.\0	\2,\1

	IFEQ	NARG-2
	ELSEIF
	run	" IFD sabo_%$3"
	clc
	adc.\0	\4,\3
	ELSEIF
	clc
	adc	\3
	ENDC
	ENDC


	ELSEIF
	clc
	adc.\0		\1

	IFEQ	NARG-1
	ELSEIF
	run	" IFD sabo_%$2"
	clc
	adc.\0	\3,\2
	ELSEIF
	clc
	adc	\2
	ENDC
	ENDC
	ENDC

	sta.l	m_bossmaxHP

	stratmac_end

	endm


;-----------------------------------------------------------------------------
; s_make_childobjrotpos	MACRO	shape,child,x,y,z,rotx,roty,rotz,#strategy ptr,[colltype]
childscale	=	3

s_make_childobjrotpos	MACRO	[shape,child,x,y,z,rotx,roty,rotz,strat,colltype]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG    	9,10

	s_make_obj	{shape},.\@
	s_make_child	{child}
	exg_xy
	s_set_strat	x,{strat}
	IFEQ		NARG-10
	s_set_colltype	x,{colltype}
	ENDC
	IFNC		"{x}","#0"
	s_set_alvar	W,x,al_childx,{x}
	ENDC
	IFNC		"{y}","#0"
	s_set_alvar	W,x,al_childy,{y}
	ENDC
	IFNC		"{z}","#0"
	s_set_alvar	W,x,al_childz,{z}
	ENDC
	IFNC		"{rotx}","#0"
	s_set_alvar	B,x,al_childrotx,{rotx}
	ENDC
	IFNC		"{roty}","#0"
	s_set_alvar	B,x,al_childroty,{roty}
	ENDC
	IFNC		"{rotz}","#0"
	s_set_alvar	B,x,al_childrotz,{rotz}
	ENDC
;	s_set_alvar	W,x,al_childrotobj,#0
	exg_xy
.\@
	stratmac_end
	ENDM

;-----------------------------------------------------------------------------
; s_rotpos_child	MACRO	childobj
; sets the child to the position specified in alx_childx,alx_childy...

s_rotpos_child	MACRO	[child]
	stratmac_start
MYNARG	=	NARG
	CHK_NARG    	1
	exg_ify		{child}
	s_jsl		child_rotpos_l
	exg_ify		{child}
	stratmac_end
	ENDM

;-----------------------------------------------------------------------------
; s_rotpos_allchildren	MACRO	motherobj

s_rotpos_allchildren		MACRO	[motherobj]
	stratmac_start
	exg_ify	{motherobj}

	s_jsl	rotpos_allchildren_l

	exg_ify	{motherobj}
	stratmac_end
	ENDM

;-----------------------------------------------------------------------------
; s_set_childs_sflag	MACRO	motherobj,sflag[,rangebegin,rangeend]|[,child num]

s_set_childsflag	MACRO	[motherobj,sflag,begin,end]
	stratmac_start
	exg_ify	{motherobj}
	phy
	IFEQ	NARG-3
	s_set_objtobechild	y,x,{begin}
	s_chk_objptr		y,.pla\@
	s_set_alsflag		y,{sflag}
.pla\@
	ELSEIF
	lda	{begin}
	dec	a
.nxt\@
	inc	a
	sta	tpa
	pha
	s_set_objtobechild	y,x,tpa
	s_chk_objptr		y,.pla\@
	s_set_alsflag		y,{sflag}
.pla\@
	pla
	cmp	{end}
	bne	.nxt\@
	ENDC

	ply
	exg_ify	{motherobj}
	stratmac_end
		ENDM


;-----------------------------------------------------------------------------
; s_clr_childs_sflag	MACRO	motherobj,sflag[,rangebegin,rangeend]|[,child num]

s_clr_childsflag	MACRO	[motherobj,sflag,begin,end]
	stratmac_start
	exg_ify	{motherobj}
	phy
	IFEQ	NARG-3
	s_set_objtobechild	y,x,{begin}
	s_chk_objptr		y,.pla\@
	s_clr_alsflag		y,{sflag}
.pla\@
	ELSEIF
	lda	{begin}
	dec	a
.nxt\@
	inc	a
	sta	tpa
	pha
	s_set_objtobechild	y,x,tpa
	s_chk_objptr		y,.pla\@
	s_clr_alsflag		y,{sflag}
.pla\@
	pla
	cmp	{end}
	bne	.nxt\@
	ENDC

	ply
	exg_ify	{motherobj}
	stratmac_end
		ENDM

;-----------------------------------------------------------------------------
; s_jmp_childrendead	MACRO	motherobj[,rangebegin,rangeend]|[,child num],label

s_jmp_childrendead	MACRO	[motherobj,begin,end,jump]
	stratmac_start
	exg_ify	{motherobj}
	phy
	IFEQ	NARG-3
	s_set_objtobechild	y,x,{begin}
	cpy	#0
	bne	.out\@
	ply
	exg_ify	{motherobj}
	s_jmp	{end}	
	ELSEIF
	lda	{begin}
	dec	a
.nxt\@
	inc	a
	sta	tpa
	pha
	s_set_objtobechild	y,x,tpa
	pla
	cpy	#0
	bne	.out\@
	cmp	{end}
	bne	.nxt\@
	ply
	exg_ify	{motherobj}
	s_jmp	{jump}
	ENDC
.out\@

	ply
	exg_ify	{motherobj}
	stratmac_end
		ENDM

;-----------------------------------------------------------------------------
s_set_path	MACRO	[obj,path]

	s_set_alvar	W,{obj},al_sword2,#path_{path}

	ENDM
;-----------------------------------------------------------------------------
s_set_pstrat	MACRO	[obj]

	a16
	s_lda	al_strat,{obj}
	sta	newplayerstrat
	a8
	s_lda	al_strat+2,{obj}
	sta	newplayerstrat+2

	ENDM
;-----------------------------------------------------------------------------
s_text_obj	MACRO	[obj,text,colour,size]
MYNARG	=	NARG
	CHK_NARG	3,4
	CHK_OBJ		{obj}

	s_set_alsflag	{obj},textobj
	s_set_alsflag	{obj},colldisable
	s_set_alvar	B,{obj},al_depthoffset,{colour}
	s_set_alvar	W,{obj},al_coltab,{text}&WM
	IFEQ	NARG-3
	s_set_alvar	B,{obj},al_tx,#0
	ELSEIF
	s_set_alvar	B,{obj},al_tx,{size}
	ENDC

	ENDM
;-----------------------------------------------------------------------------
s_sprite_obj	MACRO	[obj,colour,size]
MYNARG	=	NARG
	CHK_NARG	2,3
	CHK_OBJ		{obj}

	s_set_alsflag	{obj},ssprite
	s_set_alvar	B,{obj},al_depthoffset,{colour}

	IFEQ	NARG-2
	s_set_alvar	B,{obj},al_tx,#0
	ELSEIF
	s_set_alvar	B,{obj},al_tx,{size}
	ENDC

	ENDM
;-----------------------------------------------------------------------------
smp_B	=	1
smp_W	=	2
smp_D	=	3
smpo_A	=	1
smpo_X	=	2
smpo_Y	=	2
s_mpush	MACRO	[size,sobj,obj,var] ; | [size,sobj,A] | [size,sobj,mem] | [size,sobj,X] | [size,sobj,Y]
MYNARG	=	NARG
	CHK_NARG	3,4
	CHK_OBJ		{sobj}

	IFEQ	smp_{size}-smp_B
; byte push
	IFEQ	NARG-3
	IFD	smpo_{obj}
	IFNE	smpo_{obj}-smpo_A
	t{obj}a
	ENDC
	ELSEIF
	lda	{obj}
	ENDC
	ENDC

	IFEQ	NARG-4
	s_lda	{var},{obj}
	ENDC

	sta	stackdata
	a16
	lda	al_stackptr,{sobj}
	s_jsl	smpush_l
	sta	al_stackptr,{sobj}
	a8
	ENDC

	IFEQ	smp_{size}-smp_W

	a16

	IFEQ	NARG-3
	IFD	smpo_{obj}
	IFNE	smpo_{obj}-smpo_A
	t{obj}a
	ENDC
	ELSEIF
	lda	{obj}
	ENDC
	ENDC

	IFEQ	NARG-4
	s_lda	{var},{obj}
	ENDC

	sta	stackdata
	lda	al_stackptr,{sobj}
	s_jsl	smpush_l
	sta	al_stackptr,{sobj}
	a8
	ENDC

	IFEQ	smp_{size}-smp_D

	IFEQ	NARG-3
	IFD	smpo_{obj}
	error	"unable to D mode with A,X or Y"
	ELSEIF
	lda	{obj}
	sta	stackdata
	a16
	lda	{obj}+1
	sta	stackdata+1
	ENDC
	ENDC

	IFEQ	NARG-4
	s_lda	{var},{obj}
	sta	stackdata
	a16
	s_lda	{var}+1,{obj}
	sta	stackdata+1
	ENDC

	lda	al_stackptr,{sobj}
	s_jsl	smpush_l
	sta	al_stackptr,{sobj}
	a8
	ENDC


	ENDM
;-----------------------------------------------------------------------------

s_mpull	MACRO	[size,sobj,obj,var] ; | [size,sobj,A] | [size,sobj,mem] | [size,sobj,X] | [size,sobj,Y]
MYNARG	=	NARG
	CHK_NARG	3,4
	CHK_OBJ		{sobj}

	
	a16
	lda	al_stackptr,{sobj}
	s_jsl	smpull_l
	sta	al_stackptr,{sobj}

	IFEQ	smp_{size}-smp_B
; byte pull
	a8

	lda	stackdata

	IFEQ	NARG-3
	IFD	smpo_{obj}
	IFNE	smpo_{obj}-smpo_A
	ta{obj}
	ENDC
	ELSEIF
	sta	{obj}
	ENDC
	ENDC

	IFEQ	NARG-4
	s_sta	{var},{obj}
	ENDC

	ENDC

	IFEQ	smp_{size}-smp_W
; word pull
	lda	stackdata

	IFEQ	NARG-3
	IFD	smpo_{obj}
	IFNE	smpo_{obj}-smpo_A
	ta{obj}
	ENDC
	ELSEIF
	sta	{obj}
	ENDC
	ENDC

	IFEQ	NARG-4
	s_sta	{var},{obj}
	ENDC

	a8
	ENDC

	IFEQ	smp_{size}-smp_D

	IFEQ	NARG-3
	IFD	smpo_{obj}
	error	"unable to D mode with A,X or Y"
	ELSEIF
	lda	stackdata
	sta	{obj}
	a8
	lda	stackdata+2
	sta	{obj}+2
	ENDC
	ENDC

	IFEQ	NARG-4
	lda	stackdata
	s_sta	{var},{obj}
	a8
	lda	stackdata+2
	s_sta	{var}+2,{obj}
	ENDC

	ENDC

	ENDM
;-----------------------------------------------------------------------------
s_alloc	MACRO	[mobj,dest,amount]
MYNARG	=	NARG
	CHK_NARG	3
	CHK_OBJ		{mobj}
	CHK_OBJ		{dest}

	a16
	lda	{amount}
	EXG_IFY	{mobj}
	s_jsl	salloc_l
	EXG_IFY	{mobj}
	ta{dest}
	a8
	
	ENDM
;-----------------------------------------------------------------------------
s_realloc	MACRO	[mobj,memobj,amount]
MYNARG	=	NARG
	CHK_NARG	3
	CHK_OBJ		{mobj}
	CHK_OBJ		{memobj}
sr_amounta	=	1

	IFC	"{mobj}","{memobj}"
	error	<s_realloc: Index registers mustn't be the same!>
	ENDC

	remhash	1,{amount}
	a16
	run	" IFND sr_amount%$1"
	lda	{amount}
	ENDC
	EXG_IFY	{mobj}
	s_jsl	srealloc_l
	EXG_IFY	{mobj}
	ta{memobj}
	a8
	
	ENDM
;-----------------------------------------------------------------------------
s_free	MACRO	[mobj,source]
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ		{mobj}
	CHK_OBJ		{source}

	a16
	t{source}a
	EXG_IFY	{mobj}
	s_jsl	sfree_l
	EXG_IFY	{mobj}
	a8
	
	ENDM
;-----------------------------------------------------------------------------
s_score	MACRO	[score]
MYNARG	=	NARG
	CHK_NARG	1
	IFNE	CONTEST
	a16
	lda.l	playerscore
	clc
	adc	{score}
	sta.l	playerscore
	a8
	ENDC
	ENDM
;-----------------------------------------------------------------------------
s_playercontroller	MACRO
MYNARG	=	NARG
	CHK_NARG	0

	phy
	s_jmp_alsflag	x,player2,.copy2\@

	a16
	lda	trig0
	ldy	cont0
	bra	.set\@

.copy2\@	a16
	lda	trig1
	ldy	cont1
.set\@
	sta	ptrig
	sty	pcont

	a8

	ply

	ENDM
;-----------------------------------------------------------------------------
s_jmp_ifhitby	MACRO	[obj,mask,addr]
MYNARG	=	NARG
	CHK_NARG	3

	s_jmp_NOTalsflag	{obj},collide,.nh\@

	EXG_IFY	{obj}

	phx
	phy

	a16

	s_lda	al_hitlist,x	; pointer to list
	beq	.nowt\@
	tax
.nc\@
	remhash	1,{mask}
	run	" IFD colltype_%$1"
	ldy.w	hl_alptr,x
	s_jmpNOT_colltype	y,{mask},.no\@
	bra	.f\@
	
	ELSEIF
	ldy.w	hl_alptr,x
	lda.w	al_shape,y
	cmp	{mask}
	bne	.no\@
	ENDC
.f\@
	a8
	ply
	plx
	EXG_IFY	{obj}
	s_jmp	{addr}
	
.no\@	LONGA
	lda.w	_next,x
	tax
	bne	.nc\@

.nowt\@
	a8
	ply
	plx

	EXG_IFY	{obj}

.nh\@
		ENDM


;-----------------------------------------------------------------------------
s_freeall	MACRO	[mobj]
MYNARG	=	NARG
	CHK_NARG	1
	CHK_OBJ		{mobj}

	EXG_IFY	{mobj}

	s_jsl	sallfree_l

	EXG_IFY	{mobj}
	ENDM

;-----------------------------------------------------------------------------
s_lock_obj	MACRO	[obj1,obj2]
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	{obj1}
	CHK_OBJ	{obj2}

	a16
	s_lda	al_worldx,{obj1}
	sec
	s_sbc	al_worldx,{obj2}
	s_sta	al_childx,{obj1}

	sta	x1
	
	s_lda	al_worldy,{obj1}
	sec
	s_sbc	al_worldy,{obj2}
	s_sta	al_childy,{obj1}

	sta	y1

	s_lda	al_worldz,{obj1}
	sec
	s_sbc	al_worldz,{obj2}
	s_sta	al_childz,{obj1}

	sta	z1

	t{obj2}a
	s_sta	al_childrotobj,{obj1}

	a8
	s_lda	al_rotx,{obj1}
	sec
	s_sbc	al_rotx,{obj2}
	s_sta	al_childrotx,{obj1}

	s_lda	al_rotx,{obj2}
	eor	#255
	inc	a
	sta	matxw+1
	stz	matxw
	
	s_lda	al_roty,{obj1}
	sec
	s_sbc	al_roty,{obj2}
	s_sta	al_childroty,{obj1}

	s_lda	al_roty,{obj2}
	eor	#255
	inc	a
	sta	matyw+1
	stz	matyw

	s_lda	al_rotz,{obj1}
	sec
	s_sbc	al_rotz,{obj2}
	s_sta	al_childrotz,{obj1}

	s_lda	al_rotz,{obj2}
	eor	#255
	inc	a
	sta	matzw+1
	stz	matzw

	phx
	phy

	s_jsl	crotmat16_l	; create matrix for rotation

	a16
	copymat16	mat,wmat	; copy matrix

	s_jsl		wmatrotp16_l	; use world rotate routine

	i16

	ply
	plx

	a16
	lda	bigx
	s_sta	al_childx,{obj1}
	lda	bigy
	s_sta	al_childy,{obj1}
	lda	bigz
	s_sta	al_childz,{obj1}
	a8

	s_set_alsflag	{obj1},locked


	ENDM

;-----------------------------------------------------------------------------
s_track_obj	MACRO	[obj1,rate]
MYNARG	=	NARG
	CHK_NARG	2
	CHK_OBJ	{obj1}

	EXG_IFY	{obj1}
	phy

	a16
	s_lda	al_childx,x
	sta	x1

	s_lda	al_childy,x
	sta	y1

	s_lda	al_childz,x
	sta	z1

	ldy.w	al_childrotobj,x

	a8
;	lda.w	al_rotx,y
	stz	matxw+1
	stz	matxw

	lda.w	al_roty,y
	sta	matyw+1
	stz	matyw

;	lda.w	al_rotz,y
	stz	matzw+1
	stz	matzw

	s_rotate_16bit

	a16
	lda.w	al_worldx,y
	clc
	adc	bigx
	sta	bigx

	lda.w	al_worldy,y
	clc
	adc	bigy
	sta	bigy

	lda.w	al_worldz,y
	clc
	adc	bigz
	sta	bigz

	a8
	s_achase_alvar	W,x,al_worldx,bigx,{rate}
	s_achase_alvar	W,x,al_worldy,bigy,{rate}
	s_achase_alvar	W,x,al_worldz,bigz,{rate}

;	lda.w	al_rotx,y
;	clc
;	adc	al_childrotx,x
;	sta	al_rotx,x

	lda.w	al_roty,y
	clc
	adc	al_childroty,x
	sta	al_roty,x

;	lda.w	al_rotz,y
;	clc
;	adc	al_childrotz,x
;	sta	al_rotz,x

	ply
	EXG_IFY	{obj1}

	ENDM

;-----------------------------------------------------------------------------

; this rotates 16 bit x1,y1,z1 with the 16 bit angles in matxw-zw into bigx-z
s_rotate_16bit	MACRO
	savemode
	phx
	phy
	a8
	poll_mario

	s_jsl	crotmatyxz16_l	; create matrix for rotation

	a16
	copymat16	mat,wmat	; copy matrix

	s_jsl		wmatrotp16_l	; use world rotate routine

	a8i16

	unpoll_mario
	ply
	plx
	returnmode
		ENDM
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------

s_get_resource	MACRO	[size,obj,dest,resource,label]
sgr_sizeb	=	1
sgr_sizew	=	2
sgr_sizel	=	3
sgr_desta	=	1
sgr_destx	=	2
sgr_desty	=	2
sgr_longa	=	LONGA
MYNARG	=	NARG
	CHK_NARG	5
	CHK_OBJ	{obj}

	IFND	sgr_size{size}
	error	<s_get_resource: invalid size specified.>
	ENDC

	IFC	"{obj}","{dest}"
	error	<s_get_resource: obj and destination cannot be the same!>
	ENDC

	EXG_IFY	{obj}
; scan resources for specified resource

	lda	#r_{resource}
	s_jsl	scanresources_l
	SHORTA
	cpy	#0
	bne	.con\@

	EXG_IFY	{obj}
	IFNE	sgr_longa-LONGA
	IFEQ	sgr_longa
	a8
	ELSEIF
	a16
	ENDC
	ENDC
	jml	{label}

.con\@	SHORTA

	IFEQ	sgr_size{size}-sgr_sizeb
	  lda	heap+1,y
	  IFND	sgr_dest{dest}
	    sta	{dest}
	  ELSEIF
	    IFNE	sgr_dest{dest}-sgr_desta
	      error	<s_get_resource: Destination can only be A or memory in B size!>
	    ENDC
	  ENDC
	ENDC

	IFEQ	sgr_size{size}-sgr_sizew
	  a16
	  lda	heap+1,y
	  IFND	sgr_dest{dest}
	    sta	{dest}
	  ELSEIF
	    IFEQ	sgr_dest{dest}-sgr_destx
	      tay
	    ENDC
	  ENDC
	  a8
	ENDC

	IFEQ	sgr_size{size}-sgr_sizel
	  IFD	sgr_dest{dest}
	    error	<s_get_resource: Only memory destination is available with L>
	  ELSEIF
	    a16
	    lda	heap+1,y
	    sta {dest}
	    a8
	    lda	heap+3,y
	    sta	{dest}+2
	  ENDC
	ENDC
.exit\@
	EXG_IFY	{obj}

	IFNE	sgr_longa-LONGA
	IFEQ	sgr_longa
	a8
	ELSEIF
	a16
	ENDC
	ENDC
		ENDM


;-----------------------------------------------------------------------------

s_set_resource	MACRO	[size,obj,resource,dest]
sgr_sizeb	=	1
sgr_sizew	=	2
sgr_sizel	=	3
sgr_desta	=	1
sgr_destx	=	2
sgr_desty	=	2
sgr_longa	=	LONGA
MYNARG	=	NARG
	CHK_NARG	4
	CHK_OBJ	{obj}

	IFND	sgr_size{size}
	error	<s_get_resource: invalid size specified.>
	ENDC

	IFC	"{obj}","{dest}"
	error	<s_get_resource: obj and destination cannot be the same!>
	ENDC

	EXG_IFY	{obj}
; scan resources for specified resource

	remhash	1,{dest}

	run	" IFD sgr_dest%$1"
	  IFEQ sgr_size{size}-sgr_sizeW
	    a16
	    IFNE	sgr_dest{dest}-sgr_desta
	      tya
	    ENDC
	    pha
	    a8
	  ELSEIF
	    pha
	  ENDC
	ENDC
	lda	#r_{resource}
	s_jsl	setresource_l
	SHORTA

	IFEQ	sgr_size{size}-sgr_sizeb
	  run " IFND sgr_dest%$1"
	    lda	{dest}
	    sta	heap+1,y
	  ELSEIF
	    IFNE	sgr_dest{dest}-sgr_desta
	      error	<s_set_resource: Source can only be A or memory in B size!>
	    ENDC
	    pla
	    sta	heap+1,y
	  ENDC
	ENDC

	IFEQ	sgr_size{size}-sgr_sizew
	  a16
	  run " IFND sgr_dest%$1"
	    lda	{dest}
	    sta	heap+1,y
	  ELSEIF
	    pla
	    sta	heap+1,y
	  ENDC
	  a8
	ENDC

	IFEQ	sgr_size{size}-sgr_sizel
	  run " IFD sgr_dest%$1"
	    error	<s_get_resource: Only memory destination is available with L>
	  ELSEIF
	    a16
	    defs	1,"{dest}"
	    IFS	1,0,"#"
	      lda	{dest}&WM
	      sta	heap+1,y
	      a8
	      lda	{dest}>>16
	      sta	heap+3,y
	    ELSEIF
	      lda	{dest}
	      sta	heap+1,y
	      a8
	      lda	{dest}+2
	      sta	heap+3,y
	    ENDC
	  ENDC
	ENDC
.exit\@
	EXG_IFY	{obj}

	IFNE	sgr_longa-LONGA
	IFEQ	sgr_longa
	a8
	ELSEIF
	a16
	ENDC
	ENDC

		ENDM



;-----------------------------------------------------------------------------
s_set_clipping	MACRO	[obj,clip]
	s_set_alvar	B,{obj},al_clip,#plane_{clip}
		ENDM
;-----------------------------------------------------------------------------

s_jmp_ifsolid	MACRO	[obj,label]

	a16
	s_lda	al_worldx,{obj}
	sta	x1
	s_lda	al_worldz,{obj}
	sta	z1

	jsl	CheckBlockMap_l

	a8
	lda	x1
	lbne	{label}

		ENDM

s_jmp_ifnotsolid	MACRO	[obj,label]

	a16
	s_lda	al_worldx,{obj}
	sta	x1
	s_lda	al_worldz,{obj}
	sta	z1

	jsl	CheckBlockMap_l

	a8
	lda	x1
	lbeq	{label}

		ENDM
;-----------------------------------------------------------------------------


