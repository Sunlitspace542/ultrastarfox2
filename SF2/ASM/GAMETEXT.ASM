	IFEQ	1

	IFEQ	GERMAN
pausetxt	TXT	14,<PAUSED>
	ELSEIF
pausetxt	TXT	14,<PAUSE>
	ENDC

	IFEQ	GERMAN
totalscoretxt	TXT	14,<TOTAL SCORE>
	ELSEIF
totalscoretxt	TXT	14,<GESAMTPUNKTZAHL>
	ENDC

	IFEQ	GERMAN
scoretxt	TXT	14,<SCORE>
	ELSEIF
scoretxt	TXT	14,<PUNKTE>
	ENDC

slashtxt	TXT	14,</>
percenttxt	TXT	14,<PERCENTAGE>

	IFEQ	GERMAN
	IFEQ	CONTEST
bonustxt	TXT	14,<BONUS 1 CREDIT>
	ELSEIF
bonustxt	TXT	14,<PERFECT BONUS 1OOOOO>
	ENDC
	ELSEIF
bonustxt	TXT	14,<BONUS 1 VERSUCH>
	ENDC

percenttxt2	TXT	14,<%>
perfecttxt	TXT	14,<PERFECT//>

	IFEQ	GERMAN
teamtxt	TXT	14,<SHIELD OF TEAMMATES>
	ELSEIF
teamtxt	TXT	14,<TEAM POWER>
	ENDC

frogtxt	TXT	14,<SLIPPY>
bunnytxt	TXT	14,<PEPPY>
cocktxt	TXT	14,<FALCO>
deadtxt	TXT	14,<IS DOWN>
stagetxt	TXT	14,<STAGE>
cesmintxt	TXT	2,<m>
cessectxt	TXT	2,<s>
scoretxt2	TXT	2,<score>

shieldbonustxt	TXT	14,<SHIELD BONUS    X1OO>
bombbonustxt		TXT	14,<BOMB BONUS      X1OOO>

;-------------------------------------------------------------------

helpsnd	=	0
downsnd	=	1
othersnd	=	2

message	MACRO	[person,english,japanese,sound]
	printf	"%tDW%t",*&WM,"%t; (",msgnum,") {english} ** {japanese}%n"
	DB	friend_{person}

	IFEQ	NARG-3
	db	othersnd
	ELSEIF
	DB	{sound}snd
	ENDC

	TXT	14,<{english}>,<{japanese}>
msgnum	=	msgnum+1
	ENDM

;-------------------------------------------------------------------

msgnum	=	1

	fopen	msgs.txt

	IFEQ	german
	include	INC\gamemsgs.inc
	ELSEIF
	include	INC\german.inc
	ENDC

	fclose	!

messages	include	msgs.txt

	ENDC


