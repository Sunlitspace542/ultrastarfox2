;;**** Read         d2_0.OBJ *****
;***********************************************************************
;	<< d2_0 >> OBJECT DATA
;***********************************************************************
;;	glb	SEQ_d2_0
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total    132 bytes
;;	OBJ-BLOCK data total    101 bytes
;;	OBJ-HV    data total    274 bytes
;;	OBJ-CA    data total    274 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL              781 bytes (30DH) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_d2_0
	dwcode	OBJ_d2_0
	dwcode	d2_0_S_0
	dwcode	d2_0_S_1
	dwcode	d2_0_S_2
	dwcode	d2_0_S_3

;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
d2_0_S_0	db	oam_okwait1,0
d2_0_S_3	db	oam_okwait2,0
	amsound	sport3_ryoukai_fox
	db	8,1
	db	4,2
	db	4,4
	db	32,5
	amstop
d2_0_S_1
	db	32,0
	db	8,1
	db	4,2
	db	4,4
	db	5,5
	db	5,4
	db	5,3
	db	5,4
	db	081h


;======================================



;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_d2_0
	dwcode	d2_0_0
	dwcode	d2_0_1
	dwcode	d2_0_2
	dwcode	d2_0_3
	dwcode	d2_0_4
	dwcode	d2_0_5
	dwcode	d2_0_6
	dwcode	d2_0_7
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
d2_0_0
	db	0,16
	dwcode	d2_0_HV_0
	dwcode	d2_0_CA_0
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_0_1
	db	0,18
	dwcode	d2_0_HV_1
	dwcode	d2_0_CA_1
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d2_0_2
	db	0,17
	dwcode	d2_0_HV_2
	dwcode	d2_0_CA_2
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
d2_0_3
	db	0,17
	dwcode	d2_0_HV_3
	dwcode	d2_0_CA_3
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
d2_0_4
	db	0,18
	dwcode	d2_0_HV_4
	dwcode	d2_0_CA_4
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d2_0_5
	db	0,19
	dwcode	d2_0_HV_5
	dwcode	d2_0_CA_5
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 02ah
d2_0_6
	db	0,16
	dwcode	d2_0_HV_6
	dwcode	d2_0_CA_6
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_0_7
	db	0,16
	dwcode	d2_0_HV_7
	dwcode	d2_0_CA_7
	db 0aah
	db 0aah
	db 0aah
	db 0aah
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
d2_0_HV_0
	db 010h,000h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_0_HV_1
	db 010h,000h
	db 000h,0f8h
	db 0f0h,0f8h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_0_HV_2
	db 0e1h,00fh
	db 010h,000h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_0_HV_3
	db 000h,010h
	db 0f0h,010h
	db 010h,000h
	db 000h,0f0h
	db 000h,000h
	db 0e1h,00fh
	db 0f0h,000h
	db 0f0h,0f0h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,0e0h
	db 0f0h,0e0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0e0h,0e0h
d2_0_HV_4
	db 0e1h,0ffh
	db 0e1h,00fh
	db 010h,000h
	db 000h,0f0h
	db 000h,010h
	db 000h,000h
	db 0f0h,010h
	db 0f0h,000h
	db 0f0h,0f0h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,0e0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_0_HV_5
	db 0e1h,00fh
	db 0e1h,0efh
	db 0e1h,0ffh
	db 010h,000h
	db 000h,0f0h
	db 000h,010h
	db 000h,000h
	db 0f0h,010h
	db 0f0h,000h
	db 0f0h,0f0h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,0e0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_0_HV_6
	db 010h,010h
	db 000h,010h
	db 0f0h,010h
	db 0e0h,010h
	db 010h,000h
	db 000h,000h
	db 0f0h,000h
	db 0e0h,000h
	db 010h,0f0h
	db 000h,0f0h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 010h,0e0h
	db 000h,0e0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_0_HV_7
	db 0e0h,010h
	db 0f0h,010h
	db 000h,010h
	db 010h,010h
	db 0e0h,000h
	db 0f0h,000h
	db 000h,000h
	db 010h,000h
	db 0e0h,0f0h
	db 0f0h,0f0h
	db 000h,0f0h
	db 010h,0f0h
	db 0e0h,0e0h
	db 0f0h,0e0h
	db 000h,0e0h
	db 010h,0e0h
;-----------------------------------------------------------------------
; CA charcterNO data
;-----------------------------------------------------------------------
d2_0_CA_0
	db 02ah,034h
	db 00ch,074h
	db 004h,074h
	db 000h,074h
	db 00eh,074h
	db 00ah,074h
	db 006h,074h
	db 002h,074h
	db 00eh,034h
	db 00ch,034h
	db 00ah,034h
	db 008h,034h
	db 006h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
d2_0_CA_1
	db 02ah,034h
	db 020h,074h
	db 020h,034h
	db 00ch,074h
	db 004h,074h
	db 000h,074h
	db 00eh,074h
	db 00ah,074h
	db 006h,074h
	db 002h,074h
	db 00eh,034h
	db 00ch,034h
	db 00ah,034h
	db 008h,034h
	db 006h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
d2_0_CA_2
	db 02ch,034h
	db 02ah,034h
	db 00ch,074h
	db 004h,074h
	db 000h,074h
	db 00eh,074h
	db 00ah,074h
	db 006h,074h
	db 002h,074h
	db 00eh,034h
	db 00ch,034h
	db 00ah,034h
	db 008h,034h
	db 006h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
d2_0_CA_3
	db 028h,074h
	db 028h,034h
	db 02ah,034h
	db 022h,074h
	db 024h,074h
	db 02ch,034h
	db 024h,034h
	db 022h,034h
	db 00ch,074h
	db 004h,074h
	db 000h,074h
	db 002h,074h
	db 002h,034h
	db 00ch,034h
	db 008h,034h
	db 004h,034h
	db 000h,034h
d2_0_CA_4
	db 02ch,034h
	db 02eh,034h
	db 02ah,034h
	db 022h,074h
	db 028h,074h
	db 024h,074h
	db 028h,034h
	db 024h,034h
	db 022h,034h
	db 00ch,074h
	db 004h,074h
	db 000h,074h
	db 002h,074h
	db 00ch,034h
	db 008h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
d2_0_CA_5
	db 026h,034h
	db 02ch,034h
	db 02eh,034h
	db 02ah,034h
	db 022h,074h
	db 028h,074h
	db 024h,074h
	db 028h,034h
	db 024h,034h
	db 022h,034h
	db 00ch,074h
	db 004h,074h
	db 000h,074h
	db 002h,074h
	db 00ch,034h
	db 008h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
d2_0_CA_6
	db 02eh,035h
	db 02ch,035h
	db 02ah,035h
	db 028h,035h
	db 00eh,035h
	db 00ch,035h
	db 00ah,035h
	db 008h,035h
	db 026h,035h
	db 024h,035h
	db 022h,035h
	db 020h,035h
	db 006h,035h
	db 004h,035h
	db 002h,035h
	db 000h,035h
d2_0_CA_7
	db 02eh,075h
	db 02ch,075h
	db 02ah,075h
	db 028h,075h
	db 00eh,075h
	db 00ch,075h
	db 00ah,075h
	db 008h,075h
	db 026h,075h
	db 024h,075h
	db 022h,075h
	db 020h,075h
	db 006h,075h
	db 004h,075h
	db 002h,075h
	db 000h,075h

;=======================================================================

