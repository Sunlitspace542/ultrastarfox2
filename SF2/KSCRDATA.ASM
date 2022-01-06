;kscrdata.asm
;*********************************************************************
;*			Data Table				*	
;*********************************************************************
;---------------------------------------------------------------------
;		Time (0~9) Character Data			*
;---------------------------------------------------------------------
timertable
	ifeq	1
	calcbgchar	timerchar,$20,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$21,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$22,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$23,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$24,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$25,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$26,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$27,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$28,0,1,0
	dw	timerchar
	calcbgchar	timerchar,$29,0,1,0
	dw	timerchar
	endc

;------ BitMap Timer No Table ------
	ifeq	0
BmTmNoTable
	dw	RTmtop+0
	dw	RTmtop+1
	dw	RTmtop+2
	dw	RTmtop+3
	dw	RTmtop+4
	dw	RTmtop+5
	dw	RTmtop+6
	dw	RTmtop+7
	dw	RTmtop+8
	dw	RTmtop+9
	endc
;---------------------------------------------------------------------
;*		Damage Mater Table				*
;---------------------------------------------------------------------
HPTable
	db	$0d	;0/4	;empty
	db	$1e	;1/4	; |
	db	$1d	;2/4	; |
	db	$0f	;3/4	; |
	db	$0e	;4/4	;full


	ifeq	1
;hp = 0
	db	RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	0
;hp = 1
	db	RP1HPred,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	0
;hp = 2
	db	RP1HPred,RP1HPred,RP1HPbla,RP1HPbla,RP1HPbla
	db	RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	0
;hp = 3
	db	RP1HPred,RP1HPred,RP1HPred,RP1HPbla,RP1HPbla
	db	RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	0
;hp = 4
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPbla
	db	RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	0
;hp = 5
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu
	db	RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	0
;hp = 6
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu
	db	RP1HPblu,RP1HPbla,RP1HPbla,RP1HPbla,RP1HPbla
	db	0
;hp = 7
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu
	db	RP1HPblu,RP1HPblu,RP1HPbla,RP1HPbla,RP1HPbla
	db	0
;hp = 8
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPbla,RP1HPbla
	db	0
;hp = 9
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPbla
	db	0
;hp = 10
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu
	db	RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu,RP1HPblu
	db	0

	endc

;---------------------------------------------------------------------
;*		Circle Window Radius Table			*
;---------------------------------------------------------------------
	IFEQ	1
CircleData
	dw	(CircleDataSta-CircleData-2)/2
	dw	$0000,$0010,$0020,$0030,$0040,$0050,$0060,$0068
	dw	$0070,$0078,$0080,$0088,$0090,$0098,$00a0,$00a8
	dw	$00b0,$00b8,$00c0,$00c0,$00c0,$00c0,$00c0,$00c0
	dw	$00c0,$00c0,$00c0,$00c0,$00c0,$00c0,$00c0,$00c0
	dw	$00c0,$00c0,$00b8,$00b0,$00a0,$0098,$0090,$0088
	dw	$0080,$0078,$0070,$0068,$0060,$0058,$0050,$0048
	dw	$0040,$0038,$0030,$0028,$0020,$0018,$0010,$0008
	dw	$0007,$0005,$0003,$0001,$0000,$0000,$0000,$0000
	dw	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
CircleDataSta
	ENDC
;---------------------------------------------------------------------
;*			Boost Meter Table			*
;---------------------------------------------------------------------
	ifeq	1
boostfcha	equ	$30
boosttable
;0
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
;1
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+7,0,1,0
	dw	boostchar
;2
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+6,0,1,0
	dw	boostchar
;3
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+5,0,1,0
	dw	boostchar
;4
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+4,0,1,0
	dw	boostchar
;5
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+3,0,1,0
	dw	boostchar
;6
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+2,0,1,0
	dw	boostchar
;7
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+1,0,1,0
	dw	boostchar
;8
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;9
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+7,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;10
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+6,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;11
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+5,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;12
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+4,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;13
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+3,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;14
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+2,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;15
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+1,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;16
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;17
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+7,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;18
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+6,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;19
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+5,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;20
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+4,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;21
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+3,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;22
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+2,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;23
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+1,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;24
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;25
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+7,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;26
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+6,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;27
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+5,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;28
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+4,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;29
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+3,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;30
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+2,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;31
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+1,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;32
	calcbgchar	boostchar,boostfcha+8,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;33
	calcbgchar	boostchar,boostfcha+7,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;34
	calcbgchar	boostchar,boostfcha+6,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;35
	calcbgchar	boostchar,boostfcha+5,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;36
	calcbgchar	boostchar,boostfcha+4,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;37
	calcbgchar	boostchar,boostfcha+3,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;38
	calcbgchar	boostchar,boostfcha+2,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;39
	calcbgchar	boostchar,boostfcha+1,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
;40
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
  	calcbgchar	boostchar,boostfcha+0,0,1,0
	dw	boostchar
	endc
