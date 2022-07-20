
;---------------------------------------------------------------------
; listing mode equates

MAKE_SHAPE_REPORT	=	0	; generate shapes report (slow)
MAKE_STRAT_REPORT	=	0	; generate strategy macro report (f. slow)
TIMINGS		=	0	; generate timings report (fast)

;---------------------------------------------------------------------
; assemble equates

;---------------------------------------------------------------------
; display mode equates

PROGRESS_INDICATOR	=	0	; switch on progress indicator (fast)
ANSI		=	1	; ansi colour codes? (no time)
TITLE_BAR		=	0	; colourful title bar (fast) (ansi only)
TITLEBANKINFO	=	0	; info while assembling (only if ansi/progress/titlebar on)
RAMLEFT		=	1	; displays information on ram space

;-----------------------------------------------------------------------

	IFD	CANSI
ANSI	=	CANSI
	ENDC

	IFEQ	ANSI
TITLE_BAR	=	0
	ENDC

	IFND	filelist
	IFD	makefile
filelist	=	1
	fopen	+files.log
	printf	"%nOBJECT: %$initfile_str %n"
	fclose
	ELSEIF
filelist	=	0
	ENDC
	ENDC


	include	INC\macros.inc
	include	INC\kmacs.inc
	include	INC\tmacros.inc
	include	INC\ymacros.inc


totaltime	=	0
	gettime	starttime


	include	vars.inc
	include	INC\kvars.inc

	include INC\sound.inc
	include INC\sound2.inc

	include	INC\sfxregs.inc
	include	INC\soundequ.inc
	include	INC\structs.inc
	include	INC\alcs.inc
	include INC\mvars.inc	; 1994.10.7 append by H.Yajima


;---------------------------------------------------------
; sarcastic set up
;	send	$7d

;	fabcard	$290
	suppress expr

	ANSI_ON
	
	run	"initial_memory = %k"


	defend	"%00      %ie Error(s), %iw Warning(s). (%36",totaltime/100,".",totaltime-((totaltime/100)*100),"s%00)%n"
	deferror	"%00%31%01** %q%f%q (%l) %d: %e %u**%00 %n%s"



;---------------------------------------------------------

	IFD	makefile
	fileslog	<$(STDFILES)>
	ENDC



; -- Generate externs file --

	fclose

	fopen	externs.log

	printf	";-- Include file for externs and publics%n"

	fclose





	INCLUDE	ext\all.ext


