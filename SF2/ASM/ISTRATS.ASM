;***************************************************************************
;*                              -----------                                *
;*                              StarGlider                                 *
;*                              -----------                                *
;*                                                                         *
;*                           SuperNES version.                             *
;*                                                                         *
;*                           Argonaut Software.      		      *	   
;*_________________________________________________________________________*
;*                                                                         *
;*   File: ISTRATS.ASM                                                     *
;*_________________________________________________________________________*
;*                                                                         *
;*  Descr: Definitions for istrats referenced in the maps                  *
;*_________________________________________________________________________*
;*                                                                         *
;*   Date: 6/24/92                                                         *
;*_________________________________________________________________________*
;*                                                                         *
;* Author:   Dylan Cuthbert.                                               *
;*                                                                         *
;***************************************************************************


	IFND	real_istrats
real_istrats =	1
	ENDC

ci	=	0
cs	=	0

;---------------------------------------------------------------

def_istrat	MACRO

	IFNE	real_istrats
; table of istrats:

is_\1_istrat	equ	ci
	dw	\1_istrat&WM
	db	\1_istrat>>16

	IFEQ	NARG-1
	db	is_nullshape
sh_\1_istrat	=	is_nullshape
	ELSEIF
	db	is_\2
sh_\1_istrat	equ	is_\2
	ENDC


	IFNE	MAKE_SHAPE_REPORT
	FOPEN	+status.doc
	IFND	tmpfirst
tmpfirst
	printf	"[10]","***** STRATEGY NAME (_ISTRAT) ******** SHAPE NAME ****%n"
	ENDC
	printf	"[10]","* ","[31,.]\1"," * ","[16]\2"," *%n"
	FCLOSE
	ENDC

ci	=	ci+1
	IFEQ	ci-256
	fail	; oops .. too many Istrats defined
	ENDC

	ELSEIF
; symbols of istrats only:

is_\1_istrat	equ	ci
	IFEQ	NARG-1
sh_\1_istrat	=	is_nullshape
	ELSEIF
sh_\1_istrat	equ	is_\2
	ENDC

ci	=	ci+1

;;	printf	"is_\1_istrat%n"

	ENDC
	ENDM

;---------------------------------------------------------------

def_shape	MACRO
	IFNE	real_istrats
; real shapes:
is_\1	equ	cs
	dw	\1&WM
cs	=	cs+1
	IFEQ	cs-256
	fail	; oops .. too many shapes defined
	ENDC

	ELSEIF
; symbols only:

is_\1	equ	cs
cs	=	cs+1

	ENDC
	ENDM

;---------------------------------------------------------------


	IFNE	real_istrats
	public	shapes
shapes
	ELSEIF
	extern	shapes
	ENDC


	IFNE	real_istrats
	public	istrats
istrats
	ELSEIF
	extern	istrats
	ENDC


	IFNE	real_istrats

	IFNE	MAKE_SHAPE_REPORT
	FOPEN	+status.doc
	PRINTF	"[10]","[54,*]","%n"
	FCLOSE
	ENDC

	ENDC


number_of_map_istrats	=	ci
;	?number_of_map_istrats

number_of_map_shapes	=	cs
;	?number_of_map_shapes








