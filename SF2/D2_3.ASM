;;**** Read         d2_3.OBJ *****
;***********************************************************************
;	<< d2_3 >> OBJECT DATA
;***********************************************************************
;;	glb	SEQ_d2_3
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total     57 bytes
;;	OBJ-BLOCK data total     99 bytes
;;	OBJ-HV    data total    276 bytes
;;	OBJ-CA    data total    276 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL              708 bytes (2C4H) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_d2_3
	dwcode	OBJ_d2_3
	dwcode	d2_3_S_0
	dwcode	d2_3_S_1
	dwcode	d2_3_S_2
	dwcode	d2_3_S_3
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
d2_3_S_0	db	oam_okwait1,0
d2_3_S_3	db	oam_okwait2,0
	amsound	sport3_ryoukai_slippy
	db	4,1
	db	8,2
	db	4,3
	db	32,4
	amstop
d2_3_S_1
	db	32,0
	db	4,1
	db	8,2
	db	4,3
	db	6,4
	db	6,5
	db	6,1
	db	8,2
	db	4,3
	db	081h
;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_d2_3
	dwcode	d2_3_0
	dwcode	d2_3_1
	dwcode	d2_3_2
	dwcode	d2_3_3
	dwcode	d2_3_4
	dwcode	d2_3_5
	dwcode	d2_3_6
	dwcode	d2_3_7
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
d2_3_0
	db	0,16
	dwcode	d2_3_HV_0
	dwcode	d2_3_CA_0
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_3_1
	db	0,16
	dwcode	d2_3_HV_1
	dwcode	d2_3_CA_1
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_3_2
	db	0,16
	dwcode	d2_3_HV_2
	dwcode	d2_3_CA_2
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_3_3
	db	0,18
	dwcode	d2_3_HV_3
	dwcode	d2_3_CA_3
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d2_3_4
	db	0,20
	dwcode	d2_3_HV_4
	dwcode	d2_3_CA_4
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_3_5
	db	0,20
	dwcode	d2_3_HV_5
	dwcode	d2_3_CA_5
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_3_6
	db	0,16
	dwcode	d2_3_HV_6
	dwcode	d2_3_CA_6
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_3_7
	db	0,16
	dwcode	d2_3_HV_7
	dwcode	d2_3_CA_7
	db 0aah
	db 0aah
	db 0aah
	db 0aah
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
d2_3_HV_0
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
d2_3_HV_1
	db 000h,010h
	db 0f0h,010h
	db 010h,010h
	db 010h,000h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,000h
	db 0f0h,0f0h
	db 0f0h,0e0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0e0h,0e0h
d2_3_HV_2
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
	db 0f0h,0e0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0e0h,0e0h
d2_3_HV_3
	db 00fh,00fh
	db 0e1h,00fh
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
	db 0f0h,0e0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0e0h,0e0h
d2_3_HV_4
	db 00fh,0ffh
	db 0e1h,0ffh
	db 00fh,00fh
	db 0e1h,00fh
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
	db 0f0h,0e0h
	db 0e0h,010h
	db 0e0h,000h
	db 0e0h,0f0h
	db 0e0h,0e0h
d2_3_HV_5
	db 00fh,00fh
	db 00fh,0ffh
	db 0e1h,0ffh
	db 010h,010h
	db 0e1h,00fh
	db 000h,010h
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
d2_3_HV_6
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
d2_3_HV_7
	db 0e0h,0f0h
	db 0f0h,0f0h
	db 000h,0f0h
	db 010h,0f0h
	db 0e0h,0e0h
	db 0f0h,0e0h
	db 000h,0e0h
	db 010h,0e0h
	db 0e0h,010h
	db 0f0h,010h
	db 000h,010h
	db 010h,010h
	db 0e0h,000h
	db 0f0h,000h
	db 000h,000h
	db 010h,000h
;-----------------------------------------------------------------------
; CA charcterNO data
;-----------------------------------------------------------------------
d2_3_CA_0
	db 0ceh,074h
	db 0cch,074h
	db 0cah,074h
	db 0c8h,074h
	db 0c6h,074h
	db 0c4h,074h
	db 0c2h,074h
	db 0c0h,074h
	db 0ceh,034h
	db 0cch,034h
	db 0cah,034h
	db 0c8h,034h
	db 0c6h,034h
	db 0c4h,034h
	db 0c2h,034h
	db 0c0h,034h
d2_3_CA_1
	db 0e0h,074h
	db 0e0h,034h
	db 0cch,074h
	db 0c8h,074h
	db 0c4h,074h
	db 0c0h,074h
	db 0cah,074h
	db 0c6h,074h
	db 0c2h,074h
	db 0cah,034h
	db 0c6h,034h
	db 0c2h,034h
	db 0cch,034h
	db 0c8h,034h
	db 0c4h,034h
	db 0c0h,034h
d2_3_CA_2
	db 0cch,074h
	db 0e6h,074h
	db 0e2h,074h
	db 0c0h,074h
	db 0eah,074h
	db 0e8h,074h
	db 0e4h,074h
	db 0c2h,074h
	db 0eah,034h
	db 0e8h,034h
	db 0e4h,034h
	db 0c2h,034h
	db 0cch,034h
	db 0e6h,034h
	db 0e2h,034h
	db 0c0h,034h
d2_3_CA_3
	db 0ech,074h
	db 0ech,034h
	db 0cch,074h
	db 0e6h,074h
	db 0e2h,074h
	db 0c0h,074h
	db 0eah,074h
	db 0e8h,074h
	db 0e4h,074h
	db 0c2h,074h
	db 0eah,034h
	db 0e8h,034h
	db 0e4h,034h
	db 0c2h,034h
	db 0cch,034h
	db 0e6h,034h
	db 0e2h,034h
	db 0c0h,034h
d2_3_CA_4
	db 0ech,074h
	db 0ech,034h
	db 0eeh,074h
	db 0eeh,034h
	db 0cch,074h
	db 0e6h,074h
	db 0e2h,074h
	db 0c0h,074h
	db 0eah,074h
	db 0e8h,074h
	db 0e4h,074h
	db 0c2h,074h
	db 0eah,034h
	db 0e8h,034h
	db 0e4h,034h
	db 0c2h,034h
	db 0cch,034h
	db 0e6h,034h
	db 0e2h,034h
	db 0c0h,034h
d2_3_CA_5
	db 0eeh,074h
	db 0ech,074h
	db 0ech,034h
	db 0cch,074h
	db 0eeh,034h
	db 0e0h,074h
	db 0cah,074h
	db 0c8h,074h
	db 0c6h,074h
	db 0c4h,074h
	db 0c2h,074h
	db 0c0h,074h
	db 0e0h,034h
	db 0cch,034h
	db 0cah,034h
	db 0c8h,034h
	db 0c6h,034h
	db 0c4h,034h
	db 0c2h,034h
	db 0c0h,034h
d2_3_CA_6
	db 0eeh,035h
	db 0ech,035h
	db 0eah,035h
	db 0e8h,035h
	db 0ceh,035h
	db 0cch,035h
	db 0cah,035h
	db 0c8h,035h
	db 0e6h,035h
	db 0e4h,035h
	db 0e2h,035h
	db 0e0h,035h
	db 0c6h,035h
	db 0c4h,035h
	db 0c2h,035h
	db 0c0h,035h
d2_3_CA_7
	db 0e6h,075h
	db 0e4h,075h
	db 0e2h,075h
	db 0e0h,075h
	db 0c6h,075h
	db 0c4h,075h
	db 0c2h,075h
	db 0c0h,075h
	db 0eeh,075h
	db 0ech,075h
	db 0eah,075h
	db 0e8h,075h
	db 0ceh,075h
	db 0cch,075h
	db 0cah,075h
	db 0c8h,075h

;=======================================================================

