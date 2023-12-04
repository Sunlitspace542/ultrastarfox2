
	include	externs.log


	IFNE	RAMLEFT

Zero_Page_free	=	$100-zmempt
Work_RAM_free	=	$2000-wmempt
Extended_RAM_free	=	$7f0000-xmempt
XExtended_RAM_free	=	$800000-xxmempt
Mario_RAM_free	=	(dec_base-(mmempt-$700000))
ZMario_RAM_free	=	$700200-zmmempt

	header	<------------------------------- MEMORY USAGE ---------------------------------->
	report	<Zero Page Free>,Zero_Page_free,$100
	report	<Work Ram Free>,Work_RAM_free,($2000-$300)
	report	<Extended Ram Free>,Extended_RAM_free,($7f0000-$7e2000)
	report	<Xxtended Ram Free>,XExtended_RAM_free,($800000-$7e0000)

	IFNE	zmmempt-$700000
	report	<ZMario Ram Free>,ZMario_RAM_free,($200)
	ENDC

	IFNE	mmempt-$700200
	report	<Mario Ram Free>,Mario_RAM_free,(dec_base-$200)
	ENDC

	IFD	no_of_shapes
	IFNE	no_of_shapes
	report	<No of Shapes>,no_of_shapes,no_of_shapes
	ENDC
	ENDC

	printf	"%n"
	header	<-------------------------------------------------------------------------------%n>

	ENDC

; Restored SASMX birthdays

	IFEQ	month-8
	IFEQ	day-6
	PRINTF	"Happy birthday Krister!%n"
	ENDC
	ENDC

	IFEQ	month-3
	IFEQ	day-30
	PRINTF	"Happy birthday Giles!%n"
	ENDC
	ENDC

	IFEQ	month-2
	IFEQ	day-18
	PRINTF	"Happy birthday Dylan!%n"
	ENDC
	ENDC

; Birthdays! (SASMX has them for the SF dev team, so why not for us?)

	IFEQ	day-5
	IFEQ	month-1
	printf	"%nHappy birthday UltraStarFox2!%n"
	ENDC
	ENDC

	IFEQ	day-26
	IFEQ	month-8
	printf	"%nHappy birthday Kando!%n"
	ENDC
	ENDC

	IFEQ	day-5
	IFEQ	month-4
	printf	"%nHappy birthday Sunlit!%n"
	ENDC
	ENDC

	IFEQ	day-22
	IFEQ	month-9
	printf	"%nHappy birthday Monika!%n"
	ENDC
	ENDC


;	gettime	endtime
;totaltime	=	endtime-starttime
;
;	FOPEN	lastasm.tmp
;	time	currenttime
;	printf	(currenttime>>24)&255,":",(currenttime>>16&255),"%n"
;	FCLOSE	!

	IFNE	filelist
	IFD	makefile
	FOPEN	+files.log
	printf	"%n"
	FCLOSE
	ENDC
	ENDC

