

;----------------------------------------------------------------
TD_START	MACRO
	printf	"	dw	",*-technical_data_text,"%n"
	ENDM

TD_TEXT	MACRO	[text]
	db	"{text}",0
	ENDM

TD_STE	MACRO	[text]
	IFEQ	NARG
	error	<no arguments specified for TD_STE>
	Mexit
	ENDC

	printf	"	dw	",*-technical_data_text,"%n"

td_colour	=	tdcol_YELLOW
td_flags	=	0
td_cnt	=	1

	REPT	NARG
	irs	1,"\1","\2","\3","\4","\5"
	IFNE	td_cnt-NARG

	run	" IFD tdflag_%$1"
	run	"td_flags = td_flags!tdflag_%$1"
	ENDC

	run	" IFD tdcol_%$1"
	run	"td_colour = tdcol_%$1"
	ENDC
	ENDC
td_cnt	=	td_cnt+1
	
	ENDR

	db	td_colour!td_Flags
	run 	" db	%q%$1%q,0"
	ENDM

TD_END	MACRO
	db	0
	ENDM



;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------

	IFEQ	1
	ENDC


	FOPEN	techdata.txt




technical_data_text
;	TD_STE	SMALL,GREY2,<CONNECTED>
;	TD_STE	SMALL,GREY2,<INITIALIZING SYSTEM>
	TD_STE	SMALL,GREY3,<EXECUTING SECURITY CROSS CHECK>
	TD_STE	GREEN,FLASH,LARGE,<ACCESS GRANTED>
	TD_STE	<>
	TD_STE	SMALL,GREY3,<EXECUTING STAFF ROLL SEQUENCE>
	TD_STE	<>
	TD_STE	<>

	TD_STE	LARGE,LIGHTGREY,<EXECUTIVE PRODUCER>
	TD_STE	<>
	TD_STE	<HIROSHI YAMAUCHI>
	TD_STE	<>

	TD_STE	LARGE,LIGHTRED,<PRODUCER>
	TD_STE	<>
	TD_STE	<SHIGERU MIYAMOTO>
	TD_STE	<>

	TD_STE	LARGE,LIGHTRED,<DIRECTOR>
	TD_STE	<>
	TD_STE	<KATSUYA EGUCHI>
	TD_STE	<>

	TD_STE	LARGE,LIGHTRED,<ASSISTANT DIRECTOR>
	TD_STE	<>
	TD_STE	<YOICHI YAMADA>
	TD_STE	<>

	TD_STE	LARGE,LIGHTBLUE,<PROGRAMMERS>
	TD_STE	<>
	TD_STE	<DYLAN CUTHBERT>
	TD_STE	<TAKUMI KAWAGOE>
	TD_STE	<YASUHIRO KAWAGUCHI>
	TD_STE	<>

	TD_STE	LARGE,LIGHTBLUE,<ASSISTANT PROGRAMMER>
	TD_STE	<>
	TD_STE	<HAJIME YAJIMA>
	TD_STE	<>
;;;;;
	TD_STE	LARGE,ORANGE,<PROGRAM ASSIST>
	TD_STE	<>
	TD_STE	<ARGONAUT SOFTWARE LTD>
	TD_STE	<>
;;;;;
	TD_STE	LARGE,ORANGE,<3D SYSTEM PROGRAMMERS>
	TD_STE	<>
	TD_STE	<PETE WARNES>
	TD_STE	<CARL GRAHAM>
	TD_STE	<>

	TD_STE	LARGE,ORANGE,<GRAPHIC DESIGNER>
	TD_STE	<>
	TD_STE	<MASANAO ARIMOTO>
	TD_STE	<>

	TD_STE	LARGE,ORANGE,<3D SHAPE DESIGNER>
	TD_STE	<>
	TD_STE	<TSUYOSHI WATANABE>
	TD_STE	<>

	TD_STE	LARGE,GREEN,<SOUND PROGRAMMER>
	TD_STE	<>
	TD_STE	<YOJI INAGAKI>
	TD_STE	<>

	TD_STE	LARGE,GREEN,<MUSIC COMPOSERS>
	TD_STE	<>
	TD_STE	<KOZUE ISHIKAWA>
	TD_STE	<YUMIKO KANKI>
	TD_STE	<>

	TD_STE	LARGE,LIGHTBLUE,<3D TOOL PROGRAMMER>
	TD_STE	<>
	TD_STE	<DAIKI IWAMOTO>
	TD_STE	<>

;	IFEQ	JANGLISH

	TD_STE	LARGE,ORANGE,<ENGLISH TRANSLATOR>
	TD_STE	<>
	TD_STE	<MARCUS LINDBLOM>
	TD_STE	<>
	
;	ENDC

	TD_STE	LARGE,WHITE,<SPECIAL THANKS TO>
	TD_STE	<>
;;;;;	TD_STE	<ARGONAUT SOFTWARE LTD>
	TD_STE	<TAKAYA IMAMURA>
	TD_STE	<DAN OWSEN>
	TD_STE	<KAYOMI MCDONALD>
	TD_STE	<ROBIN KROUSE>
	TD_STE	<ISAAC MARSHALL>
	TD_STE	<NINTENDO OF AMERICA>

;	TD_STE	<>
;	TD_STE	<>
;	TD_STE	<>
;	TD_STE	<>
	TD_STE	<>
	TD_STE	<>
	TD_STE	<>
	TD_STE	<>
	TD_STE	<>
	TD_STE	<>
	TD_STE	<>
	TD_STE	SPECIAL,FLASH,LIGHTRED,LARGE,<PUSH START>


	printf	"; end of file%n"

	FCLOSE	!

;-------------------------------------------------------------
technical_data
	include	techdata.txt
	dw	-1

