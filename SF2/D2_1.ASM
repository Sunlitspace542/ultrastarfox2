;;**** Read         d2_1.OBJ *****
;***********************************************************************
;	<< d2_1 >> OBJECT DATA
;***********************************************************************
;;	glb	SEQ_d2_1
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total     30 bytes
;;	OBJ-BLOCK data total    100 bytes
;;	OBJ-HV    data total    274 bytes
;;	OBJ-CA    data total    274 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL              678 bytes (2A6H) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_d2_1
	dwcode	OBJ_d2_1
	dwcode	d2_1_S_0
	dwcode	d2_1_S_1
	dwcode	d2_1_S_2
	dwcode	d2_1_S_3
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
d2_1_S_0	db	oam_okwait1,0
d2_1_S_3	db	oam_okwait2,0
	amsound	sport3_ryoukai_falco
	db	8,1
	db	4,2
	db	4,3
	db	32,4
	amstop
d2_1_S_1
	db	32,0
	db	8,1
	db	4,2
	db	4,3
	db	24,4
	db	24,5
	db	081h
;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_d2_1
	dwcode	d2_1_0
	dwcode	d2_1_1
	dwcode	d2_1_2
	dwcode	d2_1_3
	dwcode	d2_1_4
	dwcode	d2_1_5
	dwcode	d2_1_6
	dwcode	d2_1_7
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
d2_1_0
	db	0,16
	dwcode	d2_1_HV_0
	dwcode	d2_1_CA_0
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_1_1
	db	0,18
	dwcode	d2_1_HV_1
	dwcode	d2_1_CA_1
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d2_1_2
	db	0,16
	dwcode	d2_1_HV_2
	dwcode	d2_1_CA_2
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_1_3
	db	0,17
	dwcode	d2_1_HV_3
	dwcode	d2_1_CA_3
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
d2_1_4
	db	0,18
	dwcode	d2_1_HV_4
	dwcode	d2_1_CA_4
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d2_1_5
	db	0,20
	dwcode	d2_1_HV_5
	dwcode	d2_1_CA_5
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_1_6
	db	0,16
	dwcode	d2_1_HV_6
	dwcode	d2_1_CA_6
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_1_7
	db	0,16
	dwcode	d2_1_HV_7
	dwcode	d2_1_CA_7
	db 0aah
	db 0aah
	db 0aah
	db 0aah
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
d2_1_HV_0
	db 010h,010h
	db 010h,000h
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
d2_1_HV_1
	db 000h,0f8h
	db 0f0h,0f8h
	db 010h,010h
	db 010h,000h
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
d2_1_HV_2
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
d2_1_HV_3
	db 009h,00fh
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
d2_1_HV_4
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
d2_1_HV_5
	db 00fh,00fh
	db 00fh,0ffh
	db 0e0h,010h
	db 0e0h,000h
	db 000h,0f8h
	db 0f0h,0f8h
	db 010h,010h
	db 010h,000h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,010h
	db 0f0h,000h
	db 0f0h,0f0h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_1_HV_6
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
d2_1_HV_7
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
d2_1_CA_0
	db 04ch,074h
	db 048h,074h
	db 044h,074h
	db 040h,074h
	db 04eh,074h
	db 04ah,074h
	db 046h,074h
	db 042h,074h
	db 04eh,034h
	db 04ch,034h
	db 04ah,034h
	db 048h,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h
d2_1_CA_1
	db 060h,074h
	db 060h,034h
	db 04ch,074h
	db 048h,074h
	db 044h,074h
	db 040h,074h
	db 04eh,074h
	db 04ah,074h
	db 046h,074h
	db 042h,074h
	db 04eh,034h
	db 04ch,034h
	db 04ah,034h
	db 048h,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h
d2_1_CA_2
	db 068h,074h
	db 068h,034h
	db 06ah,074h
	db 066h,074h
	db 064h,074h
	db 062h,074h
	db 06ah,034h
	db 066h,034h
	db 064h,034h
	db 062h,034h
	db 048h,074h
	db 044h,074h
	db 040h,074h
	db 048h,034h
	db 044h,034h
	db 040h,034h
d2_1_CA_3
	db 06ch,034h
	db 068h,074h
	db 068h,034h
	db 06ah,074h
	db 066h,074h
	db 064h,074h
	db 062h,074h
	db 06ah,034h
	db 066h,034h
	db 064h,034h
	db 062h,034h
	db 048h,074h
	db 044h,074h
	db 040h,074h
	db 048h,034h
	db 044h,034h
	db 040h,034h
d2_1_CA_4
	db 06eh,034h
	db 06ch,034h
	db 068h,074h
	db 068h,034h
	db 06ah,074h
	db 066h,074h
	db 064h,074h
	db 062h,074h
	db 06ah,034h
	db 066h,034h
	db 064h,034h
	db 062h,034h
	db 048h,074h
	db 044h,074h
	db 040h,074h
	db 048h,034h
	db 044h,034h
	db 040h,034h
d2_1_CA_5
	db 06eh,034h
	db 06ch,034h
	db 04ch,034h
	db 048h,034h
	db 060h,074h
	db 060h,034h
	db 04ch,074h
	db 048h,074h
	db 044h,074h
	db 040h,074h
	db 04eh,074h
	db 04ah,074h
	db 046h,074h
	db 042h,074h
	db 04eh,034h
	db 04ah,034h
	db 046h,034h
	db 044h,034h
	db 042h,034h
	db 040h,034h
d2_1_CA_6
	db 06eh,035h
	db 06ch,035h
	db 06ah,035h
	db 068h,035h
	db 04eh,035h
	db 04ch,035h
	db 04ah,035h
	db 048h,035h
	db 066h,035h
	db 064h,035h
	db 062h,035h
	db 060h,035h
	db 046h,035h
	db 044h,035h
	db 042h,035h
	db 040h,035h
d2_1_CA_7
	db 06eh,075h
	db 06ch,075h
	db 06ah,075h
	db 068h,075h
	db 04eh,075h
	db 04ch,075h
	db 04ah,075h
	db 048h,075h
	db 066h,075h
	db 064h,075h
	db 062h,075h
	db 060h,075h
	db 046h,075h
	db 044h,075h
	db 042h,075h
	db 040h,075h

;=======================================================================

