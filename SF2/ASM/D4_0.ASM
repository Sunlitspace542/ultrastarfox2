;;**** Read         d4_0.OBJ *****
;***********************************************************************
;	<< d4_0 >> OBJECT DATA
;***********************************************************************
;;;	glb	SEQ_d4_0
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total     50 bytes
;;	OBJ-BLOCK data total     97 bytes
;;	OBJ-HV    data total    192 bytes
;;	OBJ-CA    data total    192 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL              531 bytes (213H) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_d4_0
	dwcode	OBJ_d4_0
	dwcode	d4_0_S_0
	dwcode	d4_0_S_1
	dwcode	d4_0_S_2
	dwcode	d4_0_S_3
	dwcode	d4_0_S_4
	dwcode	d4_0_S_5
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
d4_0_S_0
	db	1,0
	db	1,1
	db	1,2
	db	1,3
	db	1,4
	db	085h	; erase
d4_0_S_1
	db	1,4
	db	1,3
	db	1,2
	db	1,1
	db	1,0
	db	081h
d4_0_S_2
	db	3,5
	db	3,6
	db	3,7
	db	3,8
	db	085h	; erase
d4_0_S_3
	db	3,0ffh
	db	3,8
	db	3,7
	db	3,6
	db	3,5
	amstop

d4_0_S_4
	db	3,0
	db	3,1
	db	3,2
	db	3,3
	db	3,4
	db	085h	; erase
d4_0_S_5
	db	3,4
	db	3,3
	db	3,2
	db	3,1
	db	3,0
	amstop

;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_d4_0
	dwcode	d4_0_0
	dwcode	d4_0_1
	dwcode	d4_0_2
	dwcode	d4_0_3
	dwcode	d4_0_4
	dwcode	d4_0_5
	dwcode	d4_0_6
	dwcode	d4_0_7
	dwcode	d4_0_8
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
d4_0_0
	db	0,16
	dwcode	d4_0_HV_0
	dwcode	d4_0_CA_0
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d4_0_1
	db	0,12
	dwcode	d4_0_HV_1
	dwcode	d4_0_CA_1
	db 0aah
	db 0aah
	db 0aah
d4_0_2
	db	0,8
	dwcode	d4_0_HV_2
	dwcode	d4_0_CA_2
	db 0aah
	db 0aah
d4_0_3
	db	0,8
	dwcode	d4_0_HV_3
	dwcode	d4_0_CA_3
	db 0aah
	db 0aah
d4_0_4
	db	0,4
	dwcode	d4_0_HV_4
	dwcode	d4_0_CA_4
	db 0aah
d4_0_5
	db	0,18
	dwcode	d4_0_HV_5
	dwcode	d4_0_CA_5
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d4_0_6
	db	0,12
	dwcode	d4_0_HV_6
	dwcode	d4_0_CA_6
	db 0aah
	db 0aah
	db 0aah
d4_0_7
	db	0,12
	dwcode	d4_0_HV_7
	dwcode	d4_0_CA_7
	db 0aah
	db 0aah
	db 0aah
d4_0_8
	db	0,6
	dwcode	d4_0_HV_8
	dwcode	d4_0_CA_8
	db 0aah
	db 00ah
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
d4_0_HV_0
	db 010h,010h
	db 000h,010h
	db 0f0h,010h
	db 0e0h,010h
	db 010h,000h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,0f0h
	db 000h,000h
	db 0f0h,000h
	db 0f0h,0f0h
	db 0e0h,000h
	db 0e0h,0f0h
	db 000h,0e0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d4_0_HV_1
	db 0e0h,008h
	db 0f0h,008h
	db 000h,008h
	db 010h,008h
	db 0e0h,0f8h
	db 0e0h,0e8h
	db 0f0h,0f8h
	db 000h,0f8h
	db 010h,0f8h
	db 0f0h,0e8h
	db 000h,0e8h
	db 010h,0e8h
d4_0_HV_2
	db 010h,000h
	db 000h,000h
	db 0f0h,000h
	db 0e0h,000h
	db 010h,0f0h
	db 000h,0f0h
	db 0f0h,0f0h
	db 0e0h,0f0h
d4_0_HV_3
	db 010h,0f9h
	db 000h,0f9h
	db 0f0h,0f9h
	db 0e0h,0f9h
	db 010h,0f7h
	db 000h,0f7h
	db 0f0h,0f7h
	db 0e0h,0f7h
d4_0_HV_4
	db 010h,0f8h
	db 000h,0f8h
	db 0f0h,0f8h
	db 0e0h,0f8h
d4_0_HV_5
	db 020h,008h
	db 020h,0f8h
	db 020h,0e8h
	db 010h,008h
	db 010h,0e8h
	db 010h,0f8h
	db 000h,008h
	db 000h,0e8h
	db 000h,0f8h
	db 0f0h,008h
	db 0f0h,0e8h
	db 0f0h,0f8h
	db 0e0h,008h
	db 0e0h,0e8h
	db 0e0h,0f8h
	db 0d0h,008h
	db 0d0h,0f8h
	db 0d0h,0e8h
d4_0_HV_6
	db 0d0h,000h
	db 0e0h,000h
	db 0f0h,000h
	db 000h,000h
	db 010h,000h
	db 020h,000h
	db 0d0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0f0h
	db 000h,0f0h
	db 010h,0f0h
	db 020h,0f0h
d4_0_HV_7
	db 020h,0fah
	db 010h,0fah
	db 000h,0fah
	db 0f0h,0fah
	db 0e0h,0fah
	db 0d0h,0fah
	db 020h,0f7h
	db 010h,0f7h
	db 000h,0f7h
	db 0f0h,0f7h
	db 0e0h,0f7h
	db 0d0h,0f7h
d4_0_HV_8
	db 020h,0f8h
	db 0d0h,0f8h
	db 010h,0f8h
	db 000h,0f8h
	db 0f0h,0f8h
	db 0e0h,0f8h
;-----------------------------------------------------------------------
; CA charcterNO data
;-----------------------------------------------------------------------
d4_0_CA_0
	db 000h,0f4h
	db 001h,0b4h
	db 001h,0b4h
	db 000h,0b4h
	db 003h,074h
	db 003h,074h
	db 000h,074h
	db 004h,034h
	db 004h,034h
	db 004h,034h
	db 004h,034h
	db 003h,034h
	db 003h,034h
	db 001h,034h
	db 001h,034h
	db 000h,034h
d4_0_CA_1
	db 000h,0b4h
	db 001h,0f4h
	db 001h,0f4h
	db 000h,0f4h
	db 003h,034h
	db 000h,034h
	db 004h,074h
	db 004h,074h
	db 003h,074h
	db 001h,074h
	db 001h,074h
	db 000h,074h
d4_0_CA_2
	db 000h,0f4h
	db 001h,0b4h
	db 001h,0b4h
	db 000h,0b4h
	db 000h,074h
	db 001h,034h
	db 001h,034h
	db 000h,034h
d4_0_CA_3
	db 000h,0f4h
	db 001h,0b4h
	db 001h,0b4h
	db 000h,0b4h
	db 000h,074h
	db 001h,034h
	db 001h,034h
	db 000h,034h
d4_0_CA_4
	db 006h,034h
	db 006h,034h
	db 006h,034h
	db 006h,034h
d4_0_CA_5
	db 000h,0f4h
	db 003h,074h
	db 000h,074h
	db 001h,0b4h
	db 001h,034h
	db 004h,034h
	db 001h,0b4h
	db 001h,034h
	db 004h,034h
	db 001h,0b4h
	db 001h,034h
	db 004h,034h
	db 001h,0b4h
	db 001h,034h
	db 004h,034h
	db 000h,0b4h
	db 003h,034h
	db 000h,034h
d4_0_CA_6
	db 000h,0b4h
	db 001h,0f4h
	db 001h,0f4h
	db 001h,0f4h
	db 001h,0f4h
	db 000h,0f4h
	db 000h,034h
	db 001h,074h
	db 001h,074h
	db 001h,074h
	db 001h,074h
	db 000h,074h
d4_0_CA_7
	db 000h,0f4h
	db 001h,0b4h
	db 001h,0b4h
	db 001h,0b4h
	db 001h,0b4h
	db 000h,0b4h
	db 000h,074h
	db 001h,034h
	db 001h,034h
	db 001h,034h
	db 001h,034h
	db 000h,034h
d4_0_CA_8
	db 006h,034h
	db 006h,034h
	db 006h,034h
	db 006h,034h
	db 006h,034h
	db 006h,034h

;=======================================================================

