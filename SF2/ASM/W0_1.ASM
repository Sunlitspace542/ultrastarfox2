;;**** Read         w0_1.obj *****
;***********************************************************************
;	<< w0_1 >> OBJECT DATA
;***********************************************************************
;;	glb	SEQ_w0_1
;-----------------------------------------------------------------------
;;	OBJ-SEQ   data total     48 bytes
;;	OBJ-BLOCK data total     98 bytes
;;	OBJ-HV    data total     72 bytes
;;	OBJ-CA    data total    108 bytes
;;- - - - - - - - - - - - - - - - - - - - - - - - - 
;;	DATA TOTAL              326 bytes (146H) 
;-----------------------------------------------------------------------
; SEQ object table
;-----------------------------------------------------------------------
SEQ_w0_1
	dwcode	OBJ_w0_1
	dwcode	w0_1_S_0
	dwcode	w0_1_S_1
	dwcode	w0_1_S_2
	dwcode	w0_1_S_3
	dwcode	w0_1_S_4
	dwcode	w0_1_S_5
	dwcode	w0_1_S_6
	dwcode	w0_1_S_7
	dwcode	w0_1_S_8
	dwcode	w0_1_S_9
	dwcode	w0_1_S_X
;-----------------------------------------------------------------------
; SEQ object data
;-----------------------------------------------------------------------
w0_1_S_X	db	3,10
	db	081h
;-----------------------------------------------------------------------
w0_1_S_0	db	1,0
	amstop
w0_1_S_1	db	1,1
	amstop
w0_1_S_2	db	1,2
	amstop
w0_1_S_3	db	1,3
	amstop
w0_1_S_4	db	1,4
	amstop
w0_1_S_5	db	1,5
	amstop
w0_1_S_6	db	1,6
	amstop
w0_1_S_7	db	1,7
	amstop
w0_1_S_8	db	1,8
	amstop
w0_1_S_9	db	1,9
	amstop
;-----------------------------------------------------------------------
;
;
;
;
;
;
;
;-----------------------------------------------------------------------
; block object table
;-----------------------------------------------------------------------
OBJ_w0_1
	dwcode	w0_1_0
	dwcode	w0_1_1
	dwcode	w0_1_2
	dwcode	w0_1_3
	dwcode	w0_1_4
	dwcode	w0_1_5
	dwcode	w0_1_6
	dwcode	w0_1_7
	dwcode	w0_1_8
	dwcode	w0_1_9
	dwcode	w0_target

;-----------------------------------------------------------------------
; block object data
;-----------------------------------------------------------------------
w0_target	db	0,12
	dwcode	w0_target_hv
	dwcode	w0_target_ca
	db	0,0,0

w0_1_0
	db	0,6
	dwcode	w0_1_HV_0
	dwcode	w0_1_CA_0
	db 0aah
	db 00ah
w0_1_1
	db	0,3
	dwcode	w0_1_HV_1
	dwcode	w0_1_CA_1
	db 02ah
w0_1_2
	db	0,6
	dwcode	w0_1_HV_2
	dwcode	w0_1_CA_2
	db 0aah
	db 00ah
w0_1_3
	db	0,6
	dwcode	w0_1_HV_3
	dwcode	w0_1_CA_3
	db 0aah
	db 00ah
w0_1_4
	db	0,5
	dwcode	w0_1_HV_4
	dwcode	w0_1_CA_4
	db 0aah
	db 002h
w0_1_5
	db	0,6
	dwcode	w0_1_HV_5
	dwcode	w0_1_CA_5
	db 0aah
	db 00ah
w0_1_6
	db	0,6
	dwcode	w0_1_HV_5
	dwcode	w0_1_CA_6
	db 0aah
	db 00ah
w0_1_7
	db	0,4
	dwcode	w0_1_HV_6
	dwcode	w0_1_CA_7
	db 0aah
w0_1_8
	db	0,6
	dwcode	w0_1_HV_5
	dwcode	w0_1_CA_8
	db 0aah
	db 00ah
w0_1_9
	db	0,6
	dwcode	w0_1_HV_3
	dwcode	w0_1_CA_9
	db 0aah
	db 00ah
;-----------------------------------------------------------------------
; HV position data
;-----------------------------------------------------------------------
w0_1_HV_0
	db 000h,008h
	db 0f0h,008h
	db 000h,0e8h
	db 000h,0f8h
	db 0f0h,0f8h
	db 0f0h,0e8h
w0_1_HV_1
	db 0f8h,0f8h
	db 0f8h,008h
	db 0f8h,0e8h
w0_1_HV_2
	db 000h,008h
	db 0f0h,008h
	db 000h,0f8h
	db 0f0h,0f8h
	db 000h,0e8h
	db 0f0h,0e8h
w0_1_HV_3
	db 0f0h,008h
	db 000h,008h
	db 0f0h,0f8h
	db 000h,0f8h
	db 0f0h,0e8h
	db 000h,0e8h
w0_1_HV_4
	db 000h,008h
	db 0f0h,0f8h
	db 000h,0f8h
	db 0f0h,0e8h
	db 000h,0e8h
w0_1_HV_5
	db 000h,0e8h
	db 0f0h,0e8h
	db 000h,0f8h
	db 0f0h,0f8h
	db 000h,008h
	db 0f0h,008h
w0_1_HV_6
	db 000h,0f8h
	db 000h,008h
	db 000h,0e8h
	db 0f0h,0e8h
;-----------------------------------------------------------------------
; CA charcterNO data
;-----------------------------------------------------------------------
dbx	macro
	db	\1+40h,\2
	endm

w0_1_CA_0
	dbx 0a0h,0f6h
	dbx 0a0h,0b6h
	dbx 0a0h,076h
	dbx 0a2h,076h
	dbx 0a2h,036h
	dbx 0a0h,036h
w0_1_CA_1
	dbx 0a2h,076h
	dbx 0a6h,036h
	dbx 0a4h,036h
w0_1_CA_2
	dbx 0a8h,076h
	dbx 0a0h,0b6h
	dbx 0a0h,0f6h
	dbx 0a0h,036h
	dbx 0a0h,076h
	dbx 0a8h,036h
w0_1_CA_3
	dbx 0a8h,036h
	dbx 0a0h,0f6h
	dbx 0aah,036h
	dbx 0ach,036h
	dbx 0a8h,036h
	dbx 0a0h,076h
w0_1_CA_4
	dbx 0a6h,036h
	dbx 0a0h,0b6h
	dbx 0aeh,036h
	dbx 0a6h,0f6h
	dbx 0a6h,0b6h
w0_1_CA_5
	dbx 0a8h,076h
	dbx 0a0h,036h
	dbx 0a0h,076h
	dbx 0a0h,0b6h
	dbx 0a0h,0f6h
	dbx 0a8h,0b6h
w0_1_CA_6
	dbx 0a8h,076h
	dbx 0a0h,036h
	dbx 0a0h,076h
	dbx 0aeh,076h
	dbx 0a0h,0f6h
	dbx 0a0h,0b6h
w0_1_CA_7
	dbx 0a2h,076h
	dbx 0a6h,036h
	dbx 0a0h,076h
	dbx 0a8h,036h
w0_1_CA_8
	dbx 0a0h,076h
	dbx 0a0h,036h
	dbx 0ach,036h
	dbx 0ach,076h
	dbx 0a0h,0f6h
	dbx 0a0h,0b6h
w0_1_CA_9
	dbx 0a8h,036h
	dbx 0a0h,0f6h
	dbx 0a0h,0b6h
	dbx 0aeh,0b6h
	dbx 0a0h,036h
	dbx 0a0h,076h

;=======================================================================


w0_target_hv
	db	-18h,-8
	db	-10h,-8
	db	-8h,-8
	db	0,-8
	db	8,-8
	db	10h,-8
	db	-18h,0
	db	-10h,0
	db	-8h,0
	db	0,0
	db	8,0
	db	10h,0

w0_target_ca
	dbx	11h,36h
	dbx	12h,36h
	dbx	40h,36h
	dbx	13h,36h
	dbx	20h,36h
	dbx	11h,36h

	dbx	21h,36h
	dbx	22h,36h
	dbx	41h,36h
	dbx	23h,36h
	dbx	20h,36h+80h
	dbx	21h,36h


