	defend	" "
error	=	1
	printf	"%n"

	IFD	_CGX8
error	=	0
;------------------------------------------------
	printf	"Converting 256 colour CGX(",_NUMCHRS,") - %$1.cgx%n"
	run	"	output	%$1.chr"
	org	0,0
	run	"	inccol	%$1.cgx,0,_NUMCHRS*2"
	printf	"Writing RAW SFX CHR - %$1.chr%n"
;------------------------------------------------
;	makeCGX8
	ENDC

	IFD	_CGX4
error	=	0
;------------------------------------------------
	printf	"Converting 16 colour CGX(",_NUMCHRS,") - %$1.cgx%n"
	run	"	output	%$1.chr"
	org	0,0
	run	"	inccol	%$1.cgx,0,_NUMCHRS"
	printf	"Writing RAW SFX CHR - %$1.chr%n"
;------------------------------------------------
;	makeCGX4
	ENDC

	IFD	_CGX2
error	=	0
;------------------------------------------------
	printf	"Converting 4 colour CGX(",_NUMCHRS,") - %$1.cgx%n"
	run	"	output	%$1.chr"
	org	0,0
	run	"	inccol	%$1.cgx,0,_NUMCHRS/2"
	printf	"Writing RAW SFX CHR - %$1.chr%n"
;------------------------------------------------
;	makeCGX2
	ENDC

	IFD	_SCR
error	=	0
;------------------------------------------------
	IFD	_OFFSET
offset	=	of
	ELSEIF
offset	=	0
	ENDC
	run	"	output	%$1.pic"
	printf	"Converting SCREEN (",offset,"-",_NUMSCRS,")- %$1.scr%n"
	org	0,0
	run	"	inccol	%$1.scr,offset*64,_NUMSCRS*64"
	printf	"Writing RAW SFX PIC - %$1.pic%n"
;------------------------------------------------
;	makeSCR
	ENDC

	IFD	_COL
error	=	0
;------------------------------------------------
	printf	"Converting colour palettes - %$1.col%n"
	output	col.tmp
	org	0,0
	run	"	inccol	%$1.col,_STRT,_END"
	printf	"Writing RAW SFX COL - col.tmp%n"
;------------------------------------------------
;	makecol
	ENDC

	IFNE	error
	printf	"*****INVALID COMMAND PASSED TO MAKE.ASM*****%n"
	fail
	ENDC

