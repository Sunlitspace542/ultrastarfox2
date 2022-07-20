;                            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ  StarFox II ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                              º
;º  Copyright Argonaut Software Limited, 1993.                            º
;º  All Rights Reserved.                                                  º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Filename:     OLSMACS.INC                                             º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Description:  Macros for the 'object list system'                     º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Date:         14/10/93.                                               º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Author:       Dylan Cuthbert                                          º
;ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
;º  Modification list:                                                    º
;º                                                                        º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

ols_id		=	200
ols_object_id	=	ols_id+0
ols_wait_id		=	ols_id+2
ols_goto_id		=	ols_id+4
ols_positions_id	=	ols_id+6
ols_link_id		=	ols_id+8
ols_pathobj_id	=	ols_id+10
ols_linkend_id	=	ols_id+12
ols_inertpath_id	=	ols_id+14


ols_object	MACRO	[shape,strategy]
	db	ols_object_id

	dw	{shape}&WM
	dw	{strategy}&WM
	db	{strategy}>>16
	
	
	ENDM

ols_pathobj	MACRO	[shape,path]
	db	ols_pathobj_id

	dw	{shape}&WM
	dw	path_{path}
	
	
	ENDM

ols_inertpath	MACRO	[shape,path]
	db	ols_inertpath_id

	dw	{shape}&WM
	dw	path_{path}
	
	
	ENDM

_olsw_alldead	=	0
_olsw_onedead	=	1

ols_wait	MACRO	[condition,strategy]
	db	ols_wait_id
	IFND	_olsw_{condition}
	error	<OLS_WAIT: Unrecognised condition!>
	mexit
	ELSEIF
	db	_olsw_{condition}
	ENDC
	
	ENDM

_olsg_ifnotsos1	=	1
_olsg_ifnotsos2	=	2
_olsg_ifnotsos3	=	3

ols_goto	MACRO	[condition,address]
	db	ols_goto_id


	IFEQ	NARG-1
	db	0
	ELSEIF
	IFND	_olsg_{condition}
	error	<OLS_GOTO: Unrecognised condition!>
	mexit
	ELSEIF
	db	_olsg_{condition}
	ENDC
	ENDC

	dw	{address}&$7fff

	ENDM

ols_positions MACRO	[numpos]
	db	ols_positions_id

	IFEQ	NARG-1
	IFNE	(({numpos})&-{numpos})-({numpos})
	error	<OLS_POSITION: Argument must be power of 2!>
	mexit
	ENDC
	db	{numpos}
	ELSEIF
	error	<OLS_POSITIONS: Invalid Argument!>
	mexit
	ENDC
	ENDM

ols_pos	MACRO	[x,y,z]
	dw	{x},{y},{z}
	ENDM

	STRING	linklabel[10]

ols_linkstart	MACRO
	db	ols_link_id

	defs	linklabel,".link\@"
	
	run	" dw %$linklabel","&$7fff"
	
	ENDM

ols_linkend	MACRO

	db	ols_linkend_id
\$linklabel
	
	
	ENDM


