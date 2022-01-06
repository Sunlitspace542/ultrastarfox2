;;**** Read         d2_5.OBJ *****
;***********************************************************************
;	<< d2_5 >> OBJECT DATA
;***********************************************************************
;;	glb	SEQ_d2_5
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total    102 bytes
;;	OBJ-BLOCK data total     80 bytes
;;	OBJ-HV    data total    234 bytes
;;	OBJ-CA    data total    234 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL              650 bytes (28AH) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_d2_5
	dwcode	OBJ_d2_5
	dwcode	d2_5_S_0
	dwcode	d2_5_S_1
	dwcode	d2_5_S_2
	dwcode	d2_5_S_3
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
d2_5_S_0	db	oam_okwait1,0
d2_5_S_3	db	oam_okwait2,0
	amsound	sport3_ryoukai_gal_2
	db	4,1
	db	4,2
	db	4,3
	db	4,4
	db	32,5
	amstop
d2_5_S_1
	db	32,8
	db	8,9
	db	4,10
	db	4,11
	db	24,12
	db	24,13
	db	081h
;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_d2_5
	dwcode	d2_5_0
	dwcode	d2_5_1
	dwcode	d2_5_2
	dwcode	d2_5_3
	dwcode	d2_5_4
	dwcode	d2_5_5
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
d2_5_0
	db	0,17
	dwcode	d2_5_HV_0
	dwcode	d2_5_CA_0
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
d2_5_1
	db	0,19
	dwcode	d2_5_HV_1
	dwcode	d2_5_CA_1
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 02ah
d2_5_2
	db	0,19
	dwcode	d2_5_HV_2
	dwcode	d2_5_CA_2
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 02ah
d2_5_3
	db	0,20
	dwcode	d2_5_HV_3
	dwcode	d2_5_CA_3
	db 0a0h
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_5_4
	db	0,21
	dwcode	d2_5_HV_4
	dwcode	d2_5_CA_4
	db 0a0h
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
d2_5_5
	db	0,21
	dwcode	d2_5_HV_5
	dwcode	d2_5_CA_5
	db 00ah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
d2_5_HV_0
	db 008h,0fah
	db 000h,010h
	db 010h,010h
	db 000h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_5_HV_1
	db 008h,0fah
	db 000h,0f8h
	db 0f0h,0f8h
	db 000h,010h
	db 010h,010h
	db 000h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_5_HV_2
	db 000h,0f8h
	db 0f0h,0f8h
	db 008h,0fah
	db 010h,010h
	db 000h,010h
	db 000h,000h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_5_HV_3
	db 008h,017h
	db 008h,00fh
	db 000h,00fh
	db 008h,0fah
	db 010h,010h
	db 000h,010h
	db 000h,000h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_5_HV_4
	db 00eh,007h
	db 00eh,0ffh
	db 006h,0ffh
	db 006h,00fh
	db 008h,0fah
	db 010h,010h
	db 000h,010h
	db 000h,000h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_5_HV_5
	db 006h,0ffh
	db 006h,00fh
	db 016h,007h
	db 016h,0ffh
	db 008h,0fah
	db 010h,010h
	db 000h,010h
	db 000h,000h
	db 0f0h,010h
	db 0e0h,010h
	db 0f0h,000h
	db 010h,000h
	db 000h,0f0h
	db 010h,0f0h
	db 000h,0e0h
	db 010h,0e0h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
;-----------------------------------------------------------------------
; CA charcterNO data
;-----------------------------------------------------------------------
d2_5_CA_0
	db 062h,034h
	db 04eh,074h
	db 04ch,074h
	db 04ah,074h
	db 048h,074h
	db 046h,074h
	db 044h,074h
	db 042h,074h
	db 040h,074h
	db 04eh,034h
	db 04ch,034h
	db 04ah,034h
	db 048h,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h
d2_5_CA_1
	db 062h,034h
	db 060h,074h
	db 060h,034h
	db 04eh,074h
	db 04ch,074h
	db 04ah,074h
	db 048h,074h
	db 046h,074h
	db 044h,074h
	db 042h,074h
	db 040h,074h
	db 04eh,034h
	db 04ch,034h
	db 04ah,034h
	db 048h,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h
d2_5_CA_2
	db 060h,074h
	db 060h,034h
	db 062h,034h
	db 064h,074h
	db 066h,074h
	db 068h,074h
	db 066h,034h
	db 064h,034h
	db 068h,034h
	db 048h,074h
	db 046h,074h
	db 044h,074h
	db 042h,074h
	db 040h,074h
	db 048h,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h
d2_5_CA_3
	db 07fh,034h
	db 06fh,034h
	db 06ah,034h
	db 062h,034h
	db 064h,074h
	db 066h,074h
	db 068h,074h
	db 066h,034h
	db 064h,034h
	db 068h,034h
	db 048h,074h
	db 046h,074h
	db 044h,074h
	db 042h,074h
	db 040h,074h
	db 048h,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h
d2_5_CA_4
	db 07fh,034h
	db 06fh,034h
	db 06ah,034h
	db 06ch,034h
	db 062h,034h
	db 064h,074h
	db 066h,074h
	db 068h,074h
	db 066h,034h
	db 064h,034h
	db 068h,034h
	db 048h,074h
	db 046h,074h
	db 044h,074h
	db 042h,074h
	db 040h,074h
	db 048h,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h
d2_5_CA_5
	db 06ah,034h
	db 06ch,034h
	db 07eh,034h
	db 06eh,034h
	db 062h,034h
	db 064h,074h
	db 066h,074h
	db 068h,074h
	db 066h,034h
	db 064h,034h
	db 068h,034h
	db 048h,074h
	db 046h,074h
	db 044h,074h
	db 042h,074h
	db 040h,074h
	db 048h,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h

;=======================================================================

