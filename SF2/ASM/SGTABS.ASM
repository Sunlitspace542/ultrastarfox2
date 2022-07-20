;
; MATHS TABLES
;

	incpub	sgtabs
tabstart
;	?tabstart 
	incbinfile data\etabs.dat

alogtab8ul	equ tabstart
alogtab8uh 	equ tabstart+256
logtab8u 	equ tabstart+256*2
logtab8s	equ tabstart+256*3
alogtab8s 	equ tabstart+256*4
alogtab8sl 	equ tabstart+256*5
nalogtab8s 	equ tabstart+256*6
nalogtab8sl equ tabstart+256*7
muldivtab 	equ tabstart+256*8

	FOPEN	msgtable.tmp

	IFNE	JANGLISH
	include	MSG\japanese.msg
	fileslog MSG\english.msg
	ELSEIF
	include	MSG\english.msg
	fileslog MSG\japanese.msg
	ENDC	

	FCLOSE	!

	fileslog	MSG\japanese.msg
	fileslog	MSG\english.msg

messagetable	include	msgtable.tmp
