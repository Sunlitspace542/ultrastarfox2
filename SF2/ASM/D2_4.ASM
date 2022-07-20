;;**** Read         d2_4.OBJ *****
;***********************************************************************
;	<< d2_4 >> OBJECT DATA
;***********************************************************************
;;	glb	SEQ_d2_4
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total     79 bytes
;;	OBJ-BLOCK data total    316 bytes
;;	OBJ-HV    data total    762 bytes
;;	OBJ-CA    data total    890 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL             2047 bytes (7FFH) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_d2_4
	dwcode	OBJ_d2_4
	dwcode	d2_4_S_0
	dwcode	d2_4_S_1
	dwcode	d2_4_S_2
	dwcode	d2_4_S_3
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
d2_4_S_0	db	oam_okwait1,0
d2_4_S_3	db	oam_okwait2,0
	amsound	sport3_ryoukai_gal_1
	db	4,2
	db	12,3
	db	32,4
	amstop
d2_4_S_1
	db	32,0
	db	081h
;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_d2_4
	dwcode	d2_4_0
	dwcode	d2_4_1
	dwcode	d2_4_2
	dwcode	d2_4_3
	dwcode	d2_4_4
	dwcode	d2_4_5
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
d2_4_0
	db	0,18
	dwcode	d2_4_HV_0
	dwcode	d2_4_CA_0
	db 0a0h
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d2_4_1
	db	0,20
	dwcode	d2_4_HV_1
	dwcode	d2_4_CA_1
	db 0a0h
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_4_2
	db	0,21
	dwcode	d2_4_HV_2
	dwcode	d2_4_CA_2
	db 0a0h
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
d2_4_3
	db	0,20
	dwcode	d2_4_HV_3
	dwcode	d2_4_CA_3
	db 0a0h
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_4_4
	db	0,21
	dwcode	d2_4_HV_4
	dwcode	d2_4_CA_4
	db 000h
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
d2_4_5
	db	0,18
	dwcode	d2_4_HV_5
	dwcode	d2_4_CA_5
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
d2_4_HV_0
	db 010h,0f8h
	db 010h,0f0h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 000h,010h
	db 010h,010h
	db 000h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
d2_4_HV_1
	db 010h,0f8h
	db 010h,0f0h
	db 000h,0fch
	db 0f0h,0fch
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 000h,010h
	db 010h,010h
	db 000h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
d2_4_HV_2
	db 010h,0f8h
	db 010h,0f0h
	db 0f9h,00fh
	db 000h,0fch
	db 0f0h,0fch
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 000h,010h
	db 010h,010h
	db 000h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
d2_4_HV_3
	db 010h,0f7h
	db 010h,0efh
	db 0f9h,010h
	db 0f9h,000h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 0f0h,010h
	db 0f0h,000h
	db 0f0h,0f0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 010h,010h
	db 010h,000h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
d2_4_HV_4
	db 010h,0f7h
	db 010h,0efh
	db 00bh,018h
	db 00bh,010h
	db 0fbh,010h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 0f0h,010h
	db 0f0h,000h
	db 0f0h,0f0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
	db 010h,010h
	db 010h,000h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
d2_4_HV_5
	db 00fh,00fh
	db 00fh,0ffh
	db 010h,010h
	db 0e0h,010h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,010h
	db 0f0h,000h
	db 0f0h,0f0h
	db 0f0h,0e0h
	db 010h,000h
	db 010h,0f0h
	db 010h,0e0h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0e0h,0e0h
;-----------------------------------------------------------------------
; CA charcterNO data
;-----------------------------------------------------------------------
d2_4_CA_0
	db 03fh,034h
	db 02fh,034h
	db 00eh,034h
	db 00ch,034h
	db 00ah,034h
	db 008h,034h
	db 006h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
	db 00eh,074h
	db 00ch,074h
	db 00ah,074h
	db 008h,074h
	db 006h,074h
	db 004h,074h
	db 002h,074h
	db 000h,074h
d2_4_CA_1
	db 03fh,034h
	db 02fh,034h
	db 020h,074h
	db 020h,034h
	db 00eh,034h
	db 00ch,034h
	db 00ah,034h
	db 008h,034h
	db 006h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
	db 00eh,074h
	db 00ch,074h
	db 00ah,074h
	db 008h,074h
	db 006h,074h
	db 004h,074h
	db 002h,074h
	db 000h,074h
d2_4_CA_2
	db 03fh,034h
	db 02fh,034h
	db 028h,034h
	db 020h,074h
	db 020h,034h
	db 00eh,034h
	db 00ch,034h
	db 00ah,034h
	db 008h,034h
	db 006h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
	db 00eh,074h
	db 00ch,074h
	db 00ah,074h
	db 008h,074h
	db 006h,074h
	db 004h,074h
	db 002h,074h
	db 000h,074h
d2_4_CA_3
	db 03fh,034h
	db 02fh,034h
	db 02ah,034h
	db 028h,034h
	db 026h,074h
	db 024h,074h
	db 022h,074h
	db 026h,034h
	db 024h,034h
	db 022h,034h
	db 00ch,034h
	db 008h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
	db 00ch,074h
	db 008h,074h
	db 004h,074h
	db 002h,074h
	db 000h,074h
d2_4_CA_4
	db 03fh,034h
	db 02fh,034h
	db 03eh,034h
	db 02eh,034h
	db 02ch,034h
	db 026h,074h
	db 024h,074h
	db 022h,074h
	db 026h,034h
	db 024h,034h
	db 022h,034h
	db 00ch,034h
	db 008h,034h
	db 004h,034h
	db 002h,034h
	db 000h,034h
	db 00ch,074h
	db 008h,074h
	db 004h,074h
	db 002h,074h
	db 000h,074h
d2_4_CA_5
	db 0aeh,034h
	db 0ach,034h
	db 0a8h,074h
	db 0a8h,034h
	db 0aah,074h
	db 0a6h,074h
	db 0a4h,074h
	db 0a2h,074h
	db 0aah,034h
	db 0a6h,034h
	db 0a4h,034h
	db 0a2h,034h
	db 088h,074h
	db 084h,074h
	db 080h,074h
	db 088h,034h
	db 084h,034h
	db 080h,034h
