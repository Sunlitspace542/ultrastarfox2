;;**** Read         d2_2.OBJ *****
;***********************************************************************
;	<< d2_2 >> OBJECT DATA
;***********************************************************************
;;	glb	SEQ_d2_2
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total    108 bytes
;;	OBJ-BLOCK data total    100 bytes
;;	OBJ-HV    data total    274 bytes
;;	OBJ-CA    data total    274 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL              756 bytes (2F4H) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_d2_2
	dwcode	OBJ_d2_2
	dwcode	d2_2_S_0
	dwcode	d2_2_S_1
	dwcode	d2_2_S_2
	dwcode	d2_2_S_3
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
d2_2_S_0	db	oam_okwait1,0
d2_2_S_3	db	oam_okwait2,0
	amsound	sport3_ryoukai_peppy
	db	8,1
	db	4,2
	db	4,3
	db	32,4
	amstop
d2_2_S_1
	db	32,0
	db	8,1
	db	4,2
	db	4,3
	db	32,4
	db	6,5
	db	6,4
	db	6,5
	db	6,4
	db	6,5
	db	081h
;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_d2_2
	dwcode	d2_2_0
	dwcode	d2_2_1
	dwcode	d2_2_2
	dwcode	d2_2_3
	dwcode	d2_2_4
	dwcode	d2_2_5
	dwcode	d2_2_6
	dwcode	d2_2_7
;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
d2_2_0
	db	0,16
	dwcode	d2_2_HV_0
	dwcode	d2_2_CA_0
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_2_1
	db	0,18
	dwcode	d2_2_HV_1
	dwcode	d2_2_CA_1
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d2_2_2
	db	0,16
	dwcode	d2_2_HV_2
	dwcode	d2_2_CA_2
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_2_3
	db	0,17
	dwcode	d2_2_HV_3
	dwcode	d2_2_CA_3
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 002h
d2_2_4
	db	0,18
	dwcode	d2_2_HV_4
	dwcode	d2_2_CA_4
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 00ah
d2_2_5
	db	0,20
	dwcode	d2_2_HV_5
	dwcode	d2_2_CA_5
	db 0aah
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_2_6
	db	0,16
	dwcode	d2_2_HV_6
	dwcode	d2_2_CA_6
	db 0aah
	db 0aah
	db 0aah
	db 0aah
d2_2_7
	db	0,16
	dwcode	d2_2_HV_7
	dwcode	d2_2_CA_7
	db 0aah
	db 0aah
	db 0aah
	db 0aah
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
d2_2_HV_0
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
d2_2_HV_1
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
d2_2_HV_2
	db 010h,000h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,010h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_2_HV_3
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
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,010h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_2_HV_4
	db 0e1h,00fh
	db 0e1h,0ffh
	db 010h,000h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,010h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_2_HV_5
	db 000h,0ech
	db 0f0h,0ech
	db 0e1h,00fh
	db 0e1h,0ffh
	db 010h,000h
	db 010h,010h
	db 010h,0f0h
	db 010h,0e0h
	db 000h,010h
	db 000h,000h
	db 000h,0f0h
	db 000h,0e0h
	db 0f0h,010h
	db 0f0h,000h
	db 0e0h,000h
	db 0f0h,0f0h
	db 0e0h,010h
	db 0e0h,0f0h
	db 0f0h,0e0h
	db 0e0h,0e0h
d2_2_HV_6
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
d2_2_HV_7
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
d2_2_CA_0
	db 08ch,074h
	db 088h,074h
	db 084h,074h
	db 080h,074h
	db 08eh,074h
	db 08ah,074h
	db 086h,074h
	db 082h,074h
	db 08eh,034h
	db 08ch,034h
	db 08ah,034h
	db 088h,034h
	db 086h,034h
	db 084h,034h
	db 082h,034h
	db 080h,034h
d2_2_CA_1
	db 0a0h,074h
	db 0a0h,034h
	db 08ch,074h
	db 088h,074h
	db 084h,074h
	db 080h,074h
	db 08eh,074h
	db 08ah,074h
	db 086h,074h
	db 082h,074h
	db 08eh,034h
	db 08ch,034h
	db 08ah,034h
	db 088h,034h
	db 086h,034h
	db 084h,034h
	db 082h,034h
	db 080h,034h
d2_2_CA_2
	db 0a4h,074h
	db 08ch,074h
	db 084h,074h
	db 080h,074h
	db 0a8h,074h
	db 0a6h,074h
	db 0a2h,074h
	db 082h,074h
	db 0a8h,034h
	db 0a6h,034h
	db 0a4h,034h
	db 0a2h,034h
	db 08ch,034h
	db 084h,034h
	db 082h,034h
	db 080h,034h
d2_2_CA_3
	db 0ach,034h
	db 0a4h,074h
	db 08ch,074h
	db 084h,074h
	db 080h,074h
	db 0a8h,074h
	db 0a6h,074h
	db 0a2h,074h
	db 082h,074h
	db 0a8h,034h
	db 0a6h,034h
	db 0a4h,034h
	db 0a2h,034h
	db 08ch,034h
	db 084h,034h
	db 082h,034h
	db 080h,034h
d2_2_CA_4
	db 0aeh,034h
	db 0ach,034h
	db 0a4h,074h
	db 08ch,074h
	db 084h,074h
	db 080h,074h
	db 0a8h,074h
	db 0a6h,074h
	db 0a2h,074h
	db 082h,074h
	db 0a8h,034h
	db 0a6h,034h
	db 0a4h,034h
	db 0a2h,034h
	db 08ch,034h
	db 084h,034h
	db 082h,034h
	db 080h,034h
d2_2_CA_5
	db 0aah,074h
	db 0aah,034h
	db 0aeh,034h
	db 0ach,034h
	db 0a4h,074h
	db 08ch,074h
	db 084h,074h
	db 080h,074h
	db 0a8h,074h
	db 0a6h,074h
	db 0a2h,074h
	db 082h,074h
	db 0a8h,034h
	db 0a6h,034h
	db 0a4h,034h
	db 0a2h,034h
	db 08ch,034h
	db 084h,034h
	db 082h,034h
	db 080h,034h
d2_2_CA_6
	db 0aeh,035h
	db 0ach,035h
	db 0aah,035h
	db 0a8h,035h
	db 08eh,035h
	db 08ch,035h
	db 08ah,035h
	db 088h,035h
	db 0a6h,035h
	db 0a4h,035h
	db 0a2h,035h
	db 0a0h,035h
	db 086h,035h
	db 084h,035h
	db 082h,035h
	db 080h,035h
d2_2_CA_7
	db 0aeh,075h
	db 0ach,075h
	db 0aah,075h
	db 0a8h,075h
	db 08eh,075h
	db 08ch,075h
	db 08ah,075h
	db 088h,075h
	db 0a6h,075h
	db 0a4h,075h
	db 0a2h,075h
	db 0a0h,075h
	db 086h,075h
	db 084h,075h
	db 082h,075h
	db 080h,075h

;=======================================================================

