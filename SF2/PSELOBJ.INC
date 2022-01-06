;;**** Read           f2.OBJ *****
;***********************************************************************
;	<< f2 >> OBJECT DATA
;***********************************************************************
;;	OBJ-SEQ   data total      2 bytes
;;	OBJ-BLOCK data total     48 bytes
;;	OBJ-HV    data total     58 bytes
;;	OBJ-CA    data total    116 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL              224 bytes (E0H) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_f2
	dwcode	OBJ_f2
	dwcode	f2n0
	dwcode	f2n1
	dwcode	f2n2
	dwcode	f2n3
	dwcode	f2n4
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
f2n0	db	20h,0,84h
f2n1	db	1,1,84h
f2n2	db	1,2,84h
f2n3	db	1,3,84h
f2n4	db	1,4,84h
f2n5	db	1,5,84h
;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_f2
	dwcode	f2_0
	dwcode	f2_1
	dwcode	f2_2
	dwcode	f2_3
	dwcode	f2_4
	dwcode	f2_5
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
f2_0
	db	0,9
	dwcode	f2_HV_0
	dwcode	f2_CA_0
f2_1
	db	0,10
	dwcode	f2_HV_1
	dwcode	f2_CA_1
f2_2
	db	0,10
	dwcode	f2_HV_2
	dwcode	f2_CA_2
f2_3
	db	0,9
	dwcode	f2_HV_0
	dwcode	f2_CA_3
f2_4
	db	0,10
	dwcode	f2_HV_1
	dwcode	f2_CA_4
f2_5
	db	0,10
	dwcode	f2_HV_2
	dwcode	f2_CA_5
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
f2_HV_0
	db 0e0h,0f8h
	db 0d0h,0f8h
	db 020h,000h
	db 010h,000h
	db 000h,000h
	db 0f0h,000h
	db 010h,0f0h
	db 000h,0f0h
	db 0f0h,0f0h
f2_HV_1
	db 0e0h,0f8h
	db 0d0h,0f8h
	db 020h,000h
	db 010h,000h
	db 000h,000h
	db 0f0h,000h
	db 020h,0f0h
	db 010h,0f0h
	db 000h,0f0h
	db 0f0h,0f0h
f2_HV_2
	db 020h,000h
	db 010h,000h
	db 000h,000h
	db 0f0h,000h
	db 0e0h,000h
	db 010h,0f0h
	db 000h,0f0h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0d0h,0f0h
;-----------------------------------------------------------------------
; CA charcterNO data
;-----------------------------------------------------------------------
dbax	macro
	db	\1+40h,\2
	endm

f2_CA_0
	dbax 022h,038h
	dbax 020h,038h
	dbax 040h,038h
	dbax 02eh,038h
	dbax 02ch,038h
	dbax 02ah,038h
	dbax 028h,038h
	dbax 026h,038h
	dbax 024h,038h
f2_CA_1
	dbax 044h,038h
	dbax 042h,038h
	dbax 064h,038h
	dbax 062h,038h
	dbax 060h,038h
	dbax 04eh,030h
	dbax 04ch,038h
	dbax 04ah,038h
	dbax 048h,038h
	dbax 046h,038h
f2_CA_2
	dbax 088h,038h
	dbax 086h,038h
	dbax 084h,038h
	dbax 082h,038h
	dbax 080h,038h
	dbax 06eh,038h
	dbax 06ch,038h
	dbax 06ah,038h
	dbax 068h,038h
	dbax 066h,038h
f2_CA_3
	dbax 022h,036h
	dbax 020h,036h
	dbax 040h,036h
	dbax 02eh,036h
	dbax 02ch,036h
	dbax 02ah,036h
	dbax 028h,036h
	dbax 026h,036h
	dbax 024h,036h
f2_CA_4
	dbax 044h,036h
	dbax 042h,036h
	dbax 064h,036h
	dbax 062h,036h
	dbax 060h,036h
	dbax 04eh,036h
	dbax 04ch,036h
	dbax 04ah,036h
	dbax 048h,036h
	dbax 046h,036h
f2_CA_5
	dbax 088h,036h
	dbax 086h,036h
	dbax 084h,036h
	dbax 082h,036h
	dbax 080h,036h
	dbax 06eh,036h
	dbax 06ch,036h
	dbax 06ah,036h
	dbax 068h,036h
	dbax 066h,036h

;=======================================================================

