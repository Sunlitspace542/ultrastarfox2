;;**** Read         d4_1.OBJ *****
;***********************************************************************
;	<< d4_1 >> OBJECT DATA
;***********************************************************************
;;;	glb	SEQ_d4_1
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total     63 bytes
;;	OBJ-BLOCK data total    159 bytes
;;	OBJ-HV    data total    404 bytes
;;	OBJ-CA    data total    462 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL             1088 bytes (440H) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_d4_1
	dwcode	OBJ_d4_1
	dwcode	d4_1_S_0
	dwcode	d4_1_S_1
	dwcode	d4_1_S_2
	dwcode	d4_1_S_3
	dwcode	d4_1_S_4
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
d4_1_S_0
	db	16,0
	db	16,1
	db	16,2
	db	16,3
	db	16,4
	db	081h
d4_1_S_1
	amsound	sport3_boost
.sos	db	1,8
	db	1,9
	db	1,10
	db	1,9
	amjmp	.sos


d4_1_S_2
	db	48,12
	db	48,13
	db	48,14
	db	081h
d4_1_S_3
	db	16,6
	db	081h
d4_1_S_4
	db	12,16
	db	12,19
	db	12,16
	db	12,19
	db	12,16
	db	12,19
	db	12,16
	db	12,19
	db	12,16
	db	108,19
	db	081h
;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_d4_1
	dwcode	d4_1_0
	dwcode	d4_1_1
	dwcode	d4_1_2
	dwcode	d4_1_3
	dwcode	d4_1_4
	dwcode	d4_1_5
	dwcode	d4_1_6
	dwcode	d4_1_7
	dwcode	d4_1_8
	dwcode	d4_1_9
	dwcode	d4_1_10
	dwcode	d4_1_11
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
d4_1_0
	db	0,9
	dwcode	d4_1_HV_0
	dwcode	d4_1_CA_0
	db 0aah
	db 0aah
	db 002h
d4_1_1
	db	0,9
	dwcode	d4_1_HV_0
	dwcode	d4_1_CA_1
	db 0aah
	db 0aah
	db 002h
d4_1_2
	db	0,10
	dwcode	d4_1_HV_1
	dwcode	d4_1_CA_2
	db 0aah
	db 0aah
	db 00ah
d4_1_3
	db	0,10
	dwcode	d4_1_HV_1
	dwcode	d4_1_CA_3
	db 0aah
	db 0aah
	db 00ah
d4_1_4
	db	0,10
	dwcode	d4_1_HV_2
	dwcode	d4_1_CA_4
	db 0aah
	db 0aah
	db 00ah
d4_1_5
	db	0,10
	dwcode	d4_1_HV_2
	dwcode	d4_1_CA_5
	db 0aah
	db 0aah
	db 00ah
d4_1_6
	db	0,24
	dwcode	d4_1_HV_3
	dwcode	d4_1_CA_6
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d4_1_7
	db	0,24
	dwcode	d4_1_HV_4
	dwcode	d4_1_CA_7
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d4_1_8
	db	0,24
	dwcode	d4_1_HV_5
	dwcode	d4_1_CA_8
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d4_1_9
	db	0,24
	dwcode	d4_1_HV_6
	dwcode	d4_1_CA_9
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d4_1_10
	db	0,24
	dwcode	d4_1_HV_7
	dwcode	d4_1_CA_10
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d4_1_11
	db	0,34
	dwcode	d4_1_HV_8
	dwcode	d4_1_CA_11
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
d4_1_HV_0
	db 0f0h,000h
	db 020h,000h
	db 010h,000h
	db 000h,000h
	db 0e0h,0f8h
	db 010h,0f0h
	db 000h,0f0h
	db 0f0h,0f0h
	db 0d0h,0f8h
d4_1_HV_1
	db 010h,0f0h
	db 020h,000h
	db 010h,000h
	db 000h,000h
	db 0f0h,000h
	db 020h,0f0h
	db 000h,0f0h
	db 0f0h,0f0h
	db 0e0h,0f8h
	db 0d0h,0f8h
d4_1_HV_2
	db 0f0h,0f0h
	db 020h,000h
	db 010h,000h
	db 000h,000h
	db 0f0h,000h
	db 0e0h,000h
	db 010h,0f0h
	db 000h,0f0h
	db 0e0h,0f0h
	db 0d0h,0f0h
d4_1_HV_3
	db 000h,000h
	db 010h,000h
	db 020h,000h
	db 000h,010h
	db 010h,010h
	db 020h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0d0h,000h
	db 0f0h,010h
	db 0e0h,010h
	db 0d0h,010h
	db 000h,0f0h
	db 010h,0f0h
	db 020h,0f0h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0d0h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 020h,0e0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 0d0h,0e0h
d4_1_HV_4
	db 0fah,000h
	db 00ah,000h
	db 01ah,000h
	db 0fah,010h
	db 00ah,010h
	db 01ah,010h
	db 0f1h,000h
	db 0e1h,000h
	db 0d1h,000h
	db 0f1h,010h
	db 0e1h,010h
	db 0d1h,010h
	db 0fah,0f0h
	db 00ah,0f0h
	db 01ah,0f0h
	db 0f1h,0f0h
	db 0e1h,0f0h
	db 0d1h,0f0h
	db 0fah,0e0h
	db 00ah,0e0h
	db 01ah,0e0h
	db 0f1h,0e0h
	db 0e1h,0e0h
	db 0d1h,0e0h
d4_1_HV_5
	db 0f6h,000h
	db 004h,000h
	db 014h,000h
	db 0f6h,010h
	db 004h,010h
	db 014h,010h
	db 0f2h,000h
	db 0e2h,000h
	db 0d2h,000h
	db 0f2h,010h
	db 0e2h,010h
	db 0d2h,010h
	db 0f6h,0f0h
	db 004h,0f0h
	db 014h,0f0h
	db 0f2h,0f0h
	db 0e2h,0f0h
	db 0d2h,0f0h
	db 0f6h,0e0h
	db 004h,0e0h
	db 014h,0e0h
	db 0f2h,0e0h
	db 0e2h,0e0h
	db 0d2h,0e0h
d4_1_HV_6
	db 000h,000h
	db 010h,000h
	db 020h,000h
	db 000h,010h
	db 010h,010h
	db 020h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0d0h,000h
	db 0f0h,010h
	db 0e0h,010h
	db 0d0h,010h
	db 000h,0f0h
	db 010h,0f0h
	db 020h,0f0h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0d0h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 020h,0e0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 0d0h,0e0h
d4_1_HV_7
	db 000h,000h
	db 010h,000h
	db 020h,000h
	db 000h,010h
	db 010h,010h
	db 020h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0d0h,000h
	db 0f0h,010h
	db 0e0h,010h
	db 0d0h,010h
	db 000h,0f0h
	db 010h,0f0h
	db 020h,0f0h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0d0h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 020h,0e0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 0d0h,0e0h
d4_1_HV_8
	db 0c8h,0f0h
	db 0f8h,000h
	db 0e8h,000h
	db 0d8h,000h
	db 0c8h,000h
	db 0b8h,000h
	db 0e8h,0f0h
	db 0d8h,0f0h
	db 0b8h,0f0h
	db 0a8h,0f0h
	db 000h,000h
	db 010h,000h
	db 020h,000h
	db 000h,010h
	db 010h,010h
	db 020h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0d0h,000h
	db 0f0h,010h
	db 0e0h,010h
	db 0d0h,010h
	db 000h,0f0h
	db 010h,0f0h
	db 020h,0f0h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0d0h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 020h,0e0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 0d0h,0e0h
;-----------------------------------------------------------------------
; CA charcterNO data
;-----------------------------------------------------------------------
d4_1_CA_0
	db 0a0h,028h
	db 0a6h,028h
	db 0a4h,028h
	db 0a2h,028h
	db 088h,028h
	db 08eh,028h
	db 08ch,028h
	db 08ah,028h
	db 086h,028h
d4_1_CA_1
	db 0a0h,026h
	db 0a6h,026h
	db 0a4h,026h
	db 0a2h,026h
	db 088h,026h
	db 08eh,026h
	db 08ch,026h
	db 08ah,026h
	db 086h,026h
d4_1_CA_2
	db 0c0h,028h
	db 0cah,028h
	db 0c8h,028h
	db 0c6h,028h
	db 0c4h,028h
	db 0c2h,028h
	db 0aeh,028h
	db 0ach,028h
	db 0aah,028h
	db 0a8h,028h
d4_1_CA_3
	db 0c0h,026h
	db 0cah,026h
	db 0c8h,026h
	db 0c6h,026h
	db 0c4h,026h
	db 0c2h,026h
	db 0aeh,026h
	db 0ach,026h
	db 0aah,026h
	db 0a8h,026h
d4_1_CA_4
	db 0e0h,028h
	db 0eeh,028h
	db 0ech,028h
	db 0eah,028h
	db 0e8h,028h
	db 0e6h,028h
	db 0e4h,028h
	db 0e2h,028h
	db 0ceh,028h
	db 0cch,028h
d4_1_CA_5
	db 0e0h,026h
	db 0eeh,026h
	db 0ech,026h
	db 0eah,026h
	db 0e8h,026h
	db 0e6h,026h
	db 0e4h,026h
	db 0e2h,026h
	db 0ceh,026h
	db 0cch,026h
d4_1_CA_6
	db 00ah,0cdh
	db 008h,0cdh
	db 006h,0cdh
	db 004h,0cdh
	db 002h,0cdh
	db 000h,0cdh
	db 00ah,08dh
	db 008h,08dh
	db 006h,08dh
	db 004h,08dh
	db 002h,08dh
	db 000h,08dh
	db 00ah,04dh
	db 008h,04dh
	db 006h,04dh
	db 00ah,00dh
	db 008h,00dh
	db 006h,00dh
	db 004h,04dh
	db 002h,04dh
	db 000h,04dh
	db 004h,00dh
	db 002h,00dh
	db 000h,00dh
d4_1_CA_7
	db 00ah,0cdh
	db 008h,0cdh
	db 006h,0cdh
	db 004h,0cdh
	db 002h,0cdh
	db 000h,0cdh
	db 00ah,08dh
	db 008h,08dh
	db 006h,08dh
	db 004h,08dh
	db 002h,08dh
	db 000h,08dh
	db 00ah,04dh
	db 008h,04dh
	db 006h,04dh
	db 00ah,00dh
	db 008h,00dh
	db 006h,00dh
	db 004h,04dh
	db 002h,04dh
	db 000h,04dh
	db 004h,00dh
	db 002h,00dh
	db 000h,00dh
d4_1_CA_8
	db 00ah,0cdh
	db 008h,0cdh
	db 006h,0cdh
	db 004h,0cdh
	db 002h,0cdh
	db 000h,0cdh
	db 00ah,08dh
	db 008h,08dh
	db 006h,08dh
	db 004h,08dh
	db 002h,08dh
	db 000h,08dh
	db 00ah,04dh
	db 008h,04dh
	db 006h,04dh
	db 00ah,00dh
	db 008h,00dh
	db 006h,00dh
	db 004h,04dh
	db 002h,04dh
	db 000h,04dh
	db 004h,00dh
	db 002h,00dh
	db 000h,00dh
d4_1_CA_9
	db 00ah,0cdh
	db 008h,0cdh
	db 006h,0cdh
	db 004h,0cdh
	db 002h,0cdh
	db 000h,0cdh
	db 00ah,08dh
	db 008h,08dh
	db 006h,08dh
	db 004h,08dh
	db 002h,08dh
	db 000h,08dh
	db 00ah,04dh
	db 008h,04dh
	db 006h,04dh
	db 00ah,00dh
	db 008h,00dh
	db 006h,00dh
	db 004h,04dh
	db 002h,04dh
	db 000h,04dh
	db 004h,00dh
	db 002h,00dh
	db 000h,00dh
d4_1_CA_10
	db 00ah,0cdh
	db 008h,0cdh
	db 006h,0cdh
	db 004h,0cdh
	db 002h,0cdh
	db 000h,0cdh
	db 00ah,08dh
	db 008h,08dh
	db 006h,08dh
	db 004h,08dh
	db 002h,08dh
	db 000h,08dh
	db 00ah,04dh
	db 008h,04dh
	db 006h,04dh
	db 00ah,00dh
	db 008h,00dh
	db 006h,00dh
	db 004h,04dh
	db 002h,04dh
	db 000h,04dh
	db 004h,00dh
	db 002h,00dh
	db 000h,00dh
d4_1_CA_11
	db 0e0h,026h
	db 0eeh,026h
	db 0ech,026h
	db 0eah,026h
	db 0e8h,026h
	db 0e6h,026h
	db 0e4h,026h
	db 0e2h,026h
	db 0ceh,026h
	db 0cch,026h
	db 00ah,0cdh
	db 008h,0cdh
	db 006h,0cdh
	db 004h,0cdh
	db 002h,0cdh
	db 000h,0cdh
	db 00ah,08dh
	db 008h,08dh
	db 006h,08dh
	db 004h,08dh
	db 002h,08dh
	db 000h,08dh
	db 00ah,04dh
	db 008h,04dh
	db 006h,04dh
	db 00ah,00dh
	db 008h,00dh
	db 006h,00dh
	db 004h,04dh
	db 002h,04dh
	db 000h,04dh
	db 004h,00dh
	db 002h,00dh
	db 000h,00dh

;=======================================================================

