

	INCPUB	sgdata


	public	logtab8s

pbittab
	IFEQ	1
	rept	32	;num_col
	dw	$8080,$4040,$2020,$1010,$808,$404,$202,$101
	endr
	ENDC

pbittabn
	IFEQ	1
	rept	32	;num_col
	dw	$7f7f,~$4040,~$2020,~$1010,~$808,~$404,~$202,~$101
	endr
	ENDC


pxoftab
tbtv	=	0
ttx	=	0

pyoftab
tbtv	=	0

X_data_end


;************************************************

rndbyte	macro
rndval =	(rndval*91+$61d7)&$ffff
	db	rndval&255
	endm

rndval	=	$5a79

mrndtab
;	rept	256
;	rndbyte
;	endr


Intro256Pal
	incbinfile	data\nintendo.pal

;************************************************

ddbw	macro
	db	\1,\1
	endm

chardw	macro
	ifne	easytext
	db	\1,0
	elseif
	db	\1,\1
	endc

	endm

reciptab16s
	dw	0
	dw	32767
tv	=	2
	rept	254
	dw	32768/tv
tv	=	tv+1
	endr




;laser bolt positions
numlaserpos	equ	12
zv	=	256
dv	=	150
xv	=	90*zv
yv	=	50*zv
zv	=	zv+dv*(numlaserpos-1)
laserxytab


sm2	macro
	db	\1,\1,\2,\2,\3,\3,\4,\4,\5,\5,\6,\6,\7,\7,\8,\8
	endm

sm	macro
	db	\1,\2,\3,\4,\5,\6,\7,\8
	endm

c1	equ	$11
c2	equ	$22

b1	equ	10
b2	equ	13


shadestab

depthtabtab
	dw	night1&WM
	dw	mist1&WM
	dw	desert1&WM
	dw	marine1&WM


;Frames per second table BCD --------------
fpstab

sintab
	DB	0
	DB	3
	DB	6
	DB	9
	DB	12
	DB	15
	DB	18
	DB	21
	DB	24
	DB	27
	DB	30
	DB	33
	DB	36
	DB	39
	DB	42
	DB	45
	DB	48
	DB	51
	DB	54
	DB	57
	DB	59
	DB	62
	DB	65
	DB	67
	DB	70
	DB	73
	DB	75
	DB	78
	DB	80
	DB	82
	DB	85
	DB	87
	DB	89
	DB	91
	DB	94
	DB	96
	DB	98
	DB	100
	DB	102
	DB	103
	DB	105
	DB	107
	DB	108
	DB	110
	DB	112
	DB	113
	DB	114
	DB	116
	DB	117
	DB	118
	DB	119
	DB	120
	DB	121
	DB	122
	DB	123
	DB	123
	DB	124
	DB	125
	DB	125
	DB	126
	DB	126
	DB	126
	DB	126
	DB	126

costab
	DB	127
	DB	126
	DB	126
	DB	126
	DB	126
	DB	126
	DB	125
	DB	125
	DB	124
	DB	123
	DB	123
	DB	122
	DB	121
	DB	120
	DB	119
	DB	118
	DB	117
	DB	116
	DB	114
	DB	113
	DB	112
	DB	110
	DB	108
	DB	107
	DB	105
	DB	103
	DB	102
	DB	100
	DB	98
	DB	96
	DB	94
	DB	91
	DB	89
	DB	87
	DB	85
	DB	82
	DB	80
	DB	78
	DB	75
	DB	73
	DB	70
	DB	67
	DB	65
	DB	62
	DB	59
	DB	57
	DB	54
	DB	51
	DB	48
	DB	45
	DB	42
	DB	39
	DB	36
	DB	33
	DB	30
	DB	27
	DB	24
	DB	21
	DB	18
	DB	15
	DB	12
	DB	9
	DB	6
	DB	3
	DB	0
	DB	-3
	DB	-6
	DB	-9
	DB	-12
	DB	-15
	DB	-18
	DB	-21
	DB	-24
	DB	-27
	DB	-30
	DB	-33
	DB	-36
	DB	-39
	DB	-42
	DB	-45
	DB	-48
	DB	-51
	DB	-54
	DB	-57
	DB	-59
	DB	-62
	DB	-65
	DB	-67
	DB	-70
	DB	-73
	DB	-75
	DB	-78
	DB	-80
	DB	-82
	DB	-85
	DB	-87
	DB	-89
	DB	-91
	DB	-94
	DB	-96
	DB	-98
	DB	-100
	DB	-102
	DB	-103
	DB	-105
	DB	-107
	DB	-108
	DB	-110
	DB	-112
	DB	-113
	DB	-114
	DB	-116
	DB	-117
	DB	-118
	DB	-119
	DB	-120
	DB	-121
	DB	-122
	DB	-123
	DB	-123
	DB	-124
	DB	-125
	DB	-125
	DB	-126
	DB	-126
	DB	-126
	DB	-126
	DB	-126
	DB	-127
	DB	-126
	DB	-126
	DB	-126
	DB	-126
	DB	-126
	DB	-125
	DB	-125
	DB	-124
	DB	-123
	DB	-123
	DB	-122
	DB	-121
	DB	-120
	DB	-119
	DB	-118
	DB	-117
	DB	-116
	DB	-114
	DB	-113
	DB	-112
	DB	-110
	DB	-108
	DB	-107
	DB	-105
	DB	-103
	DB	-102
	DB	-100
	DB	-98
	DB	-96
	DB	-94
	DB	-91
	DB	-89
	DB	-87
	DB	-85
	DB	-82
	DB	-80
	DB	-78
	DB	-75
	DB	-73
	DB	-70
	DB	-67
	DB	-65
	DB	-62
	DB	-59
	DB	-57
	DB	-54
	DB	-51
	DB	-48
	DB	-45
	DB	-42
	DB	-39
	DB	-36
	DB	-33
	DB	-30
	DB	-27
	DB	-24
	DB	-21
	DB	-18
	DB	-15
	DB	-12
	DB	-9
	DB	-6
	DB	-3
	DB	0
	DB	3
	DB	6
	DB	9
	DB	12
	DB	15
	DB	18
	DB	21
	DB	24
	DB	27
	DB	30
	DB	33
	DB	36
	DB	39
	DB	42
	DB	45
	DB	48
	DB	51
	DB	54
	DB	57
	DB	59
	DB	62
	DB	65
	DB	67
	DB	70
	DB	73
	DB	75
	DB	78
	DB	80
	DB	82
	DB	85
	DB	87
	DB	89
	DB	91
	DB	94
	DB	96
	DB	98
	DB	100
	DB	102
	DB	103
	DB	105
	DB	107
	DB	108
	DB	110
	DB	112
	DB	113
	DB	114
	DB	116
	DB	117
	DB	118
	DB	119
	DB	120
	DB	121
	DB	122
	DB	123
	DB	123
	DB	124
	DB	125
	DB	125
	DB	126
	DB	126
	DB	126
	DB	126
	DB	126


sintab16
	dw $0000,$0324,$0647,$096A,$0C8B,$0FAB,$12C7,$15E1
	dw $18F8,$1C0B,$1F19,$2223,$2527,$2826,$2B1E,$2E10
	dw $30FB,$33DE,$36B9,$398C,$3C56,$3F16,$41CD,$447A
	dw $471C,$49B3,$4C3F,$4EBF,$5133,$539A,$55F4,$5842
	dw $5A81,$5CB3,$5ED6,$60EB,$62F1,$64E7,$66CE,$68A5
	dw $6A6C,$6C23,$6DC9,$6F5E,$70E1,$7254,$73B5,$7503
	dw $7640,$776B,$7883,$7989,$7A7C,$7B5C,$7C29,$7CE2
	dw $7D89,$7E1C,$7E9C,$7F08,$7F61,$7FA6,$7FD7,$7FF5
	dw $7FFF,$7FF5,$7FD7,$7FA6,$7F61,$7F08,$7E9C,$7E1C
	dw $7D89,$7CE2,$7C29,$7B5C,$7A7C,$7989,$7883,$776B
	dw $7640,$7503,$73B5,$7254,$70E1,$6F5E,$6DC9,$6C23
	dw $6A6C,$68A5,$66CE,$64E7,$62F1,$60EB,$5ED6,$5CB3
	dw $5A81,$5842,$55F4,$539A,$5133,$4EBF,$4C3F,$49B3
	dw $471C,$447A,$41CD,$3F16,$3C56,$398C,$36B9,$33DE
	dw $30FB,$2E10,$2B1E,$2826,$2527,$2223,$1F19,$1C0B
	dw $18F8,$15E1,$12C7,$0FAB,$0C8B,$096A,$0647,$0324
	dw $0000,$FCDC,$F9B9,$F696,$F375,$F055,$ED39,$EA1F
	dw $E708,$E3F5,$E0E7,$DDDD,$DAD9,$D7DA,$D4E2,$D1F0
	dw $CF05,$CC22,$C947,$C674,$C3AA,$C0EA,$BE33,$BB86
	dw $B8E4,$B64D,$B3C1,$B141,$AECD,$AC66,$AA0C,$A7BE
	dw $A57F,$A34D,$A12A,$9F15,$9D0F,$9B19,$9932,$975B
	dw $9594,$93DD,$9237,$90A2,$8F1F,$8DAC,$8C4B,$8AFD
	dw $89C0,$8895,$877D,$8677,$8584,$84A4,$83D7,$831E
	dw $8277,$81E4,$8164,$80F8,$809F,$805A,$8029,$800B
	dw $8001,$800B,$8029,$805A,$809F,$80F8,$8164,$81E4
	dw $8277,$831E,$83D7,$84A4,$8584,$8677,$877D,$8895
	dw $89C0,$8AFD,$8C4B,$8DAC,$8F1F,$90A2,$9237,$93DD
	dw $9594,$975B,$9932,$9B19,$9D0F,$9F15,$A12A,$A34D
	dw $A57F,$A7BE,$AA0C,$AC66,$AECD,$B141,$B3C1,$B64D
	dw $B8E4,$BB86,$BE33,$C0EA,$C3AA,$C674,$C947,$CC22
	dw $CF05,$D1F0,$D4E2,$D7DA,$DAD9,$DDDD,$E0E7,$E3F5
	dw $E708,$EA1F,$ED39,$F055,$F375,$F696,$F9B9,$FCDC
	dw $0000


intro_hp_string
	;db	"HP   ",3+"Z",0
intro_aw_string
	;db	"A",2+"Z",0
intro_loading_string
	;db	"LOADING",0
intro_empty_string
	;db	"BAY EMPTY",0



mycrapmask

mycrapchars


deffont	MACRO	[data]
	defs	1,"{data}"

__val	=	0
__v	=	128
__lp	=	0
	REPT	8

	IFNS	1,__lp," "
__val	=	__val+__v
	ENDC

__v	=	__v/2
__lp	=	__lp+1

	ENDR

	db	__val

	ENDM


	IFEQ	1
;--------------
; space
	db	4
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
;--------------
; numbers 26-35
	db	6
	deffont	<        >
	deffont	< ���    >
	deffont	<�  ��   >
	deffont	<� � �   >
	deffont	<��  �   >
	deffont	< ���    >
	deffont	<        >

	db	3
	deffont	<        >
	deffont	< �      >
	deffont	<��      >
	deffont	< �      >
	deffont	< �      >
	deffont	< �      >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ��     >
	deffont	<   �    >
	deffont	< ��     >
	deffont	<�       >
	deffont	<����    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<���     >
	deffont	<   �    >
	deffont	< ��     >
	deffont	<   �    >
	deffont	<���     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<�       >
	deffont	<�       >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<����    >
	deffont	<  �     >

	db	5
	deffont	<        >
	deffont	<����    >
	deffont	<�       >
	deffont	<���     >
	deffont	<   �    >
	deffont	<���     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< �      >
	deffont	<�       >
	deffont	<���     >
	deffont	<�  �    >
	deffont	< ��     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<����    >
	deffont	<   �    >
	deffont	<  �     >
	deffont	<  �     >
	deffont	<  �     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ��     >
	deffont	<�  �    >
	deffont	< ��     >
	deffont	<�  �    >
	deffont	< ��     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ��     >
	deffont	<�  �    >
	deffont	< ���    >
	deffont	<   �    >
	deffont	<  �     >
	deffont	<        >



; alphabet  -25
	db	5
	deffont	<        >
	deffont	< ��     >
	deffont	<�  �    >
	deffont	<����    >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<���     >
	deffont	<�  �    >
	deffont	<���     >
	deffont	<�  �    >
	deffont	<���     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ���    >
	deffont	<�       >
	deffont	<�       >
	deffont	<�       >
	deffont	< ���    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<���     >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<���     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<����    >
	deffont	<�       >
	deffont	<���     >
	deffont	<�       >
	deffont	<����    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<����    >
	deffont	<�       >
	deffont	<���     >
	deffont	<�       >
	deffont	<�       >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ��     >
	deffont	<�       >
	deffont	<� ��    >
	deffont	<�  �    >
	deffont	< ���    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<����    >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<���     >
	deffont	< �      >
	deffont	< �      >
	deffont	< �      >
	deffont	<���     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ���    >
	deffont	<   �    >
	deffont	<   �    >
	deffont	<�  �    >
	deffont	< ��     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<�  �    >
	deffont	<� �     >
	deffont	<��      >
	deffont	<� �     >
	deffont	<�  �    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<�       >
	deffont	<�       >
	deffont	<�       >
	deffont	<�       >
	deffont	<����    >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<�   �   >
	deffont	<�� ��   >
	deffont	<� � �   >
	deffont	<�   �   >
	deffont	<�   �   >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<�   �   >
	deffont	<��  �   >
	deffont	<� � �   >
	deffont	<�  ��   >
	deffont	<�   �   >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ��     >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	< ��     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<���     >
	deffont	<�  �    >
	deffont	<���     >
	deffont	<�       >
	deffont	<�       >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ��     >
	deffont	<�  �    >
	deffont	<�� �    >
	deffont	<� ��    >
	deffont	< ���    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<���     >
	deffont	<�  �    >
	deffont	<���     >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	< ��     >
	deffont	<�       >
	deffont	< ��     >
	deffont	<   �    >
	deffont	<���     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<�����   >
	deffont	<  �     >
	deffont	<  �     >
	deffont	<  �     >
	deffont	<  �     >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	<�  �    >
	deffont	< ��     >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<�   �   >
	deffont	<�   �   >
	deffont	<�   �   >
	deffont	< � �    >
	deffont	<  �     >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<�   �   >
	deffont	<�   �   >
	deffont	<� � �   >
	deffont	<� � �   >
	deffont	< � �    >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<�   �   >
	deffont	< � �    >
	deffont	<  �     >
	deffont	< � �    >
	deffont	<�   �   >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<�   �   >
	deffont	< � �    >
	deffont	<  �     >
	deffont	<  �     >
	deffont	<  �     >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<�����   >
	deffont	<   �    >
	deffont	<  �     >
	deffont	< �      >
	deffont	<�����   >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<����    >
	deffont	<        >
	deffont	<        >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	< ��     >
	deffont	<� �     >
	deffont	<� �     >
	deffont	< ��     >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<�       >
	deffont	<��      >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<��      >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	< ��     >
	deffont	<�       >
	deffont	<�       >
	deffont	< ��     >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<  �     >
	deffont	< ��     >
	deffont	<� �     >
	deffont	<� �     >
	deffont	< ��     >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	< �      >
	deffont	<� �     >
	deffont	<��      >
	deffont	< ��     >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	< ��     >
	deffont	<�       >
	deffont	<��      >
	deffont	<�       >
	deffont	<�       >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	< ��     >
	deffont	<� �     >
	deffont	< ��     >
	deffont	<  �     >
	deffont	<��      >

	db	4
	deffont	<        >
	deffont	<�       >
	deffont	<��      >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<        >

	db	2
	deffont	<        >
	deffont	<�       >
	deffont	<        >
	deffont	<�       >
	deffont	<�       >
	deffont	<�       >
	deffont	<        >

	db	3
	deffont	<        >
	deffont	< �      >
	deffont	<        >
	deffont	< �      >
	deffont	< �      >
	deffont	< �      >
	deffont	<�       >

	db	5
	deffont	<        >
	deffont	<�       >
	deffont	<� �     >
	deffont	<��      >
	deffont	<� �     >
	deffont	<�  �    >
	deffont	<        >

	db	2
	deffont	<        >
	deffont	<�       >
	deffont	<�       >
	deffont	<�       >
	deffont	<�       >
	deffont	<�       >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<        >
	deffont	< � �    >
	deffont	<� � �   >
	deffont	<� � �   >
	deffont	<� � �   >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	<��      >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	< �      >
	deffont	<� �     >
	deffont	<� �     >
	deffont	< �      >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	<��      >
	deffont	<� �     >
	deffont	<��      >
	deffont	<�       >
	deffont	<�       >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	< ��     >
	deffont	<� �     >
	deffont	< ��     >
	deffont	<  �     >
	deffont	<  �     >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	<���     >
	deffont	<�       >
	deffont	<�       >
	deffont	<�       >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	< ��     >
	deffont	<��      >
	deffont	<  �     >
	deffont	<��      >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	< �      >
	deffont	<���     >
	deffont	< �      >
	deffont	< �      >
	deffont	< �      >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<���     >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	<� �     >
	deffont	<� �     >
	deffont	<� �     >
	deffont	< �      >
	deffont	<        >

	db	6
	deffont	<        >
	deffont	<        >
	deffont	<�   �   >
	deffont	<� � �   >
	deffont	<� � �   >
	deffont	< � �    >
	deffont	<        >

	db	5
	deffont	<        >
	deffont	<        >
	deffont	<�  �    >
	deffont	< ��     >
	deffont	< ��     >
	deffont	<�  �    >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	<� �     >
	deffont	<� �     >
	deffont	< ��     >
	deffont	<  �     >
	deffont	<��      >

	db	5
	deffont	<        >
	deffont	<        >
	deffont	<����    >
	deffont	<  �     >
	deffont	< �      >
	deffont	<����    >
	deffont	<        >

	db	2
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<�       >
	deffont	<        >

	db	4
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<        >
	deffont	<����    >

	ENDC

;���������������������������������������������������������������������
; Game messages:
;���������������������������������������������������������������������

	string	temp[200];

M_GETWORD	MACRO	[word,source]

	defs	{word},""
mgw_finished	=	0
	REPT	15
	IFEQ	mgw_finished

; copy the source string
	defs	temp,"%${source}"
; extract the first character
	substr	0,1,temp
; shift the source string left one place
	substr	1,,{source}
; check for space
	IFS	temp,0," "
mgw_finished	=	1
	ELSEIF
; add the character to the word string
	defs	{word},"%${word}%$temp"
	ENDC

	ENDC

	ENDR

	ENDM

MSG	MACRO	[string]

	defs	2,"{string}"

	m_getword	1,2	; get first word out of string 2
	m_getword	3,2	; get first word out of string 2

	printf	"	dw	$",:$*&WM," (%$1,%$3)%n"

	run	" db FRIEND_%$1%n"

	run	" db SOUND_%$3%n"
;	db	0		; no sound yet

	run	" db %q%$2%q%n"	; display rest of string

	db	0		; zero terminate it

	ENDM








bitmasks	dw	1<<0
	dw	1<<1
	dw	1<<2
	dw	1<<3
	dw	1<<4
	dw	1<<5
	dw	1<<6
	dw	1<<7
	dw	1<<8
	dw	1<<9
	dw	1<<10
	dw	1<<11
	dw	1<<12
	dw	1<<13
	dw	1<<14
	dw	1<<15

;----------------------------
nintendomsg
	db	"NINTENDO",0
	db	"PRESENTS",0
gameovermsg
	db	"  GAME",0
	db	"  OVER",0
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
youwinmsg
	db	"YOU WIN",0
	db	"       ",0
youlostmsg
	db	"YOU LOST",0
	db	"       ",0
tobecontinuedmsg
	db	"  TO BE",0
	db	"CONTINUED",0
corneriafellmsg
	db	"CORNERIA",0
	db	"  FELL",0
;KAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKAKA
;-----------------------------
;-----------------------------
;eguchi's data
;-----------------------------
;-----------------------------
;-----------------------------
;-----------------------------




;-----------------------------
;-----------------------------



KENum_tab
;		e,n,h
	db	3,4,2		;planet1		
	db	3,3,3		;planet2		
	db	0,3,2		;planet3		
	db	3,2,5		;planet4		
	db	2,4,3		;planet5		
	db	0,3,2		;planet6		
;--------------
shape_null		equ	0
shape_sos_0		equ	1
shape_taigun		equ	2
shape_sos_1		equ	3
shape_sos_2		equ	4
shape_enkin		equ	5
shape_speed_s	equ	6
shape_kieru		equ	7
shape_kuru0_u	equ	8
shape_kuru1_u	equ	9
shape_jyouge		equ	10
shape_jyouge_1	equ	11
shape_bakugeki	equ	12
shape_dandou		equ	13
shape_miss2		equ	14
shape_enban		equ	15
shape_tate_m		equ	16
shape_hydra		equ	17
shape_hebi		equ	18
shape_ninja		equ	19
shape_shield		equ	20
shape_virus		equ	21
shape_wolf		equ	22
;--------------
SOS1_target
;	db	ba(h)			;KEnemyNumber=a+b
;1_00
	db	03h			;initial KEnemyNumber
;1_01
	db	03h			;initial KEnemyNumber
;1_02
	db	03h			;initial KEnemyNumber
;1_03
	db	03h			;initial KEnemyNumber
;1_04
	db	21h			;initial KEnemyNumber
;1_05
	db	31h			;initial KEnemyNumber
;1_06
	db	04h			;initial KEnemyNumber
;1_07
	db	04h			;initial KEnemyNumber
;1_08
	db	21h			;initial KEnemyNumber
;1_09
	db	31h			;initial KEnemyNumber
;1_0a
	db	21h			;initial KEnemyNumber
;1_0b
	db	22h			;initial KEnemyNumber
;1_0c
	db	05h			;initial KEnemyNumber
;1_0d
	db	05h			;initial KEnemyNumber
;1_0e
	db	31h			;initial KEnemyNumber
;1_0f
	db	22h			;initial KEnemyNumber
;1_10
	db	04h			;initial KEnemyNumber
;1_11
	db	23h			;initial KEnemyNumber
;1_12
	db	21h			;initial KEnemyNumber
;1_13
	db	21h			;initial KEnemyNumber
;1_14
	db	21h			;initial KEnemyNumber
;1_15
	db	41h			;initial KEnemyNumber
;1_16
	db	22h			;initial KEnemyNumber
;1_17
	db	21h			;initial KEnemyNumber
;1_18
	db	21h			;initial KEnemyNumber
;1_19
	db	41h			;initial KEnemyNumber
;1_1a
	db	31h			;initial KEnemyNumber
;1_1b
	db	21h			;initial KEnemyNumber
;1_1c
	db	01h			;initial KEnemyNumber
;1_1d
	db	01h			;initial KEnemyNumber
;1_1e
	db	01h			;initial KEnemyNumber
;1_1f
	db	01h			;initial KEnemyNumber
SOS1_target_shape_A
;1_00_a
	db	shape_sos_0		;shape a
;1_01_a
	db	shape_taigun		;shape a
;1_02_a
	db	shape_jyouge		;shape a
;1_03_a
	db	shape_speed_s		;shape a
;1_04_a
	db	shape_sos_1		;shape b
;1_05_a
	db	shape_jyouge		;shape a
;1_06_a
	db	shape_sos_0		;shape a
;1_07_a
	db	shape_taigun		;shape a
;1_08_a
	db	shape_jyouge		;shape a
;1_09_a
	db	shape_jyouge		;shape a
;1_0a_a
	db	shape_speed_s		;shape a
;1_0b_a
	db	shape_sos_0		;shape a
;1_0c_a
	db	shape_sos_0		;shape a
;1_0d_a
	db	shape_taigun		;shape a
;1_0e_a
	db	shape_sos_1		;shape b
;1_0f_a
	db	shape_jyouge		;shape a
;1_10_a
	db	shape_enkin		;shape a
;1_11_a
	db	shape_sos_0		;shape a
;1_12_a
	db	shape_bakugeki		;shape a
;1_13_a
	db	shape_sos_1		;shape b
;1_14_a
	db	shape_sos_2		;shape b
;1_15_a
	db	shape_sos_2		;shape b
;1_16_a
	db	shape_jyouge		;shape a
;1_17_a
	db	shape_bakugeki		;shape a
;1_18_a
	db	shape_kuru1_u		;shape b
;1_19_a
	db	shape_kuru1_u		;shape b
;1_1a_a
	db	shape_jyouge_1		;shape b
;1_1b_a
	db	shape_jyouge_1		;shape b
;1_1c_a
	db	shape_hebi		;shape a
;1_1d_a
	db	shape_hydra		;shape a
;1_1e_a
	db	shape_ninja		;shape a
;1_1f_a
	db	shape_shield		;shape a
SOS1_target_shape_B
;1_00_b
	db	shape_null		;shape b
;1_01_b
	db	shape_null		;shape b
;1_02_b
	db	shape_null		;shape b
;1_03_b
	db	shape_null		;shape b
;1_04_b
	db	shape_sos_0		;shape a
;1_05_b
	db	shape_taigun		;shape a
;1_06_b
	db	shape_null		;shape b
;1_07_b
	db	shape_kieru		;shape a
;1_08_b
	db	shape_speed_s		;shape a
;1_09_b
	db	shape_sos_0		;shape a
;1_0a_b
	db	shape_sos_0		;shape a
;1_0b_b
	db	shape_taigun		;shape a
;1_0c_b
	db	shape_null		;shape b
;1_0d_b
	db	shape_null		;shape b
;1_0e_b
	db	shape_taigun		;shape b
;1_0f_b
	db	shape_taigun		;shape a
;1_10_b
	db	shape_null		;shape b
;1_11_b
	db	shape_enkin		;shape a
;1_12_b
	db	shape_sos_0		;shape a
;1_13_b
	db	shape_speed_s		;shape a
;1_14_b
	db	shape_kieru		;shape a
;1_15_b
	db	shape_kieru		;shape a
;1_16_b
	db	shape_speed_s		;shape a
;1_17_b
	db	shape_taigun		;shape a
;1_18_b
	db	shape_kuru0_u		;shape a
;1_19_b
	db	shape_kuru0_u		;shape a
;1_1a_b
	db	shape_enkin		;shape a
;1_1b_b
	db	shape_speed_s		;shape a
;1_1c_b
	db	shape_null		;shape b
;1_1d_b
	db	shape_null		;shape b
;1_1e_b
	db	shape_null		;shape b
;1_1f_b
	db	shape_null		;shape b
;;--------------
;SOS1_target
;;	db	ba(h)			;KEnemyNumber=a+b
;;1_00
;	db	03h			;initial KEnemyNumber
;;1_01
;	db	03h			;initial KEnemyNumber
;;1_02
;	db	03h			;initial KEnemyNumber
;;1_03
;	db	03h			;initial KEnemyNumber
;;1_04
;	db	21h			;initial KEnemyNumber
;;1_05
;	db	03h			;initial KEnemyNumber
;;1_06
;	db	02h			;initial KEnemyNumber
;;1_07
;	db	21h			;initial KEnemyNumber
;;1_08
;	db	03h			;initial KEnemyNumber
;;1_09
;	db	21h			;initial KEnemyNumber
;;1_0a
;	db	04h			;initial KEnemyNumber
;;1_0b
;	db	01h			;initial KEnemyNumber
;;1_0c
;	db	12h			;initial KEnemyNumber
;;1_0d
;	db	13h			;initial KEnemyNumber
;;1_0e
;	db	22h			;initial KEnemyNumber
;;1_0f
;	db	31h			;initial KEnemyNumber
;;1_10
;	db	05h			;initial KEnemyNumber
;;1_11
;	db	13h			;initial KEnemyNumber
;;1_12
;	db	31h			;initial KEnemyNumber
;;1_13
;	db	21h			;initial KEnemyNumber
;;1_14
;	db	21h			;initial KEnemyNumber
;;1_15
;	db	13h			;initial KEnemyNumber
;;1_16
;	db	21h			;initial KEnemyNumber
;;1_17
;	db	05h			;initial KEnemyNumber
;;1_18
;	db	21h			;initial KEnemyNumber
;;1_19
;	db	41h			;initial KEnemyNumber
;;1_1a
;	db	05h			;initial KEnemyNumber
;;1_1b
;	db	41h			;initial KEnemyNumber
;;1_1c
;	db	01h			;initial KEnemyNumber
;;1_1d
;	db	01h			;initial KEnemyNumber
;;1_1e
;	db	01h			;initial KEnemyNumber
;;1_1f
;	db	01h			;initial KEnemyNumber
;SOS1_target_shape_A
;;1_00_a
;	db	shape_sos_0		;shape a
;;1_01_a
;	db	shape_taigun		;shape a
;;1_02_a
;	db	shape_speed_s		;shape a
;;1_03_a
;	db	shape_sos_0		;shape a
;;1_04_a
;	db	shape_sos_1		;shape b
;;1_05_a
;	db	shape_enkin		;shape a
;;1_06_a
;	db	shape_jyouge		;shape a
;;1_07_a
;	db	shape_sos_2		;shape b
;;1_08_a
;	db	shape_speed_s		;shape a
;;1_09_a
;	db	shape_jyouge_1		;shape b
;;1_0a_a
;	db	shape_sos_0		;shape a
;;1_0b_a
;	db	shape_bakugeki		;shape b
;;1_0c_a
;	db	shape_speed_s		;shape a
;;1_0d_a
;	db	shape_sos_0		;shape a
;;1_0e_a
;	db	shape_speed_s		;shape a
;;1_0f_a
;	db	shape_sos_1		;shape b
;;1_10_a
;	db	shape_sos_0		;shape a
;;1_11_a
;	db	shape_sos_0		;shape a
;;1_12_a
;	db	shape_sos_2		;shape b
;;1_13_a
;	db	shape_jyouge_1		;shape b
;;1_14_a
;	db	shape_kuru1_u		;shape b
;;1_15_a
;	db	shape_taigun		;shape a
;;1_16_a
;	db	shape_speed_s		;shape a
;;1_17_a
;	db	shape_enkin		;shape a
;;1_18_a
;	db	shape_bakugeki		;shape a
;;1_19_a
;	db	shape_kuru1_u		;shape b
;;1_1a_a
;	db	shape_taigun		;shape a
;;1_1b_a
;	db	shape_sos_2		;shape b
;;1_1c_a
;	db	shape_hebi		;shape a
;;1_1d_a
;	db	shape_hydra		;shape a
;;1_1e_a
;	db	shape_ninja		;shape a
;;1_1f_a
;	db	shape_shield		;shape a
;SOS1_target_shape_B
;;1_00_b
;	db	shape_null		;shape b
;;1_01_b
;	db	shape_null		;shape b
;;1_02_b
;	db	shape_null		;shape b
;;1_03_b
;	db	shape_null		;shape b
;;1_04_b
;	db	shape_sos_0		;shape a
;;1_05_b
;	db	shape_null		;shape b
;;1_06_b
;	db	shape_null		;shape b
;;1_07_b
;	db	shape_kieru		;shape a
;;1_08_b
;	db	shape_null		;shape b
;;1_09_b
;	db	shape_enkin		;shape a
;;1_0a_b
;	db	shape_null		;shape b
;;1_0b_b
;	db	shape_null		;shape a
;;1_0c_b
;	db	shape_jyouge		;shape b
;;1_0d_b
;	db	shape_enkin		;shape b
;;1_0e_b
;	db	shape_taigun		;shape b
;;1_0f_b
;	db	shape_taigun		;shape a
;;1_10_b
;	db	shape_null		;shape b
;;1_11_b
;	db	shape_jyouge_1		;shape b
;;1_12_b
;	db	shape_kieru		;shape a
;;1_13_b
;	db	shape_speed_s		;shape a
;;1_14_b
;	db	shape_kuru0_u		;shape a
;;1_15_b
;	db	shape_jyouge		;shape b
;;1_16_b
;	db	shape_jyouge		;shape b
;;1_17_b
;	db	shape_null		;shape b
;;1_18_b
;	db	shape_taigun		;shape b
;;1_19_b
;	db	shape_kuru0_u		;shape a
;;1_1a_b
;	db	shape_null		;shape b
;;1_1b_b
;	db	shape_kieru		;shape a
;;1_1c_b
;	db	shape_null		;shape b
;;1_1d_b
;	db	shape_null		;shape b
;;1_1e_b
;	db	shape_null		;shape b
;;1_1f_b
;	db	shape_null		;shape b
SOS2_target
;2_00
	db	01h			;initial KEnemyNumber
;2_01
	db	02h			;initial KEnemyNumber
;2_02
	db	02h			;initial KEnemyNumber
;2_03
	db	03h			;initial KEnemyNumber
;2_04
	db	04h			;initial KEnemyNumber
;2_05
	db	01h			;initial KEnemyNumber
;2_06
	db	24h			;initial KEnemyNumber
;2_07
	db	01h			;initial KEnemyNumber
;2_08
	db	03h			;initial KEnemyNumber
;2_09
	db	03h			;initial KEnemyNumber
;2_0a
	db	01h			;initial KEnemyNumber
;2_0b
	db	01h			;initial KEnemyNumber

SOS2_target_shape_A
;2_00_a
	db	shape_dandou		;shape a
;2_01_a
	db	shape_dandou		;shape a
;2_02_a
	db	shape_miss2		;shape a
;2_03_a
	db	shape_dandou		;shape a
;2_04_a
	db	shape_miss2		;shape a
;2_05_a
	db	shape_tate_m		;shape a
;2_06_a
	db	shape_miss2		;shape a
;2_07_a
	db	shape_enban		;shape a
;2_08_a
	db	shape_virus		;shape a
;2_09_a
	db	shape_virus		;shape a
;2_0a_a
	db	shape_wolf		;shape a
;2_0b_a
	db	shape_wolf		;shape a
SOS2_target_shape_B
;2_00_b
	db	shape_null		;shape b
;2_01_b
	db	shape_null		;shape b
;2_02_b
	db	shape_null		;shape b
;2_03_b
	db	shape_null		;shape b
;2_04_b
	db	shape_null		;shape b
;2_05_b
	db	shape_null		;shape b
;2_06_b
	db	shape_dandou		;shape b
;2_07_b
	db	shape_null		;shape b
;2_08_b
	db	shape_null		;shape b
;2_09_b
	db	shape_null		;shape b
;2_0a_b
	db	shape_null		;shape b
;2_0b_b
	db	shape_null		;shape b

;-----------
PLANET_RANDOM
	db	3,5,6,4,2,7,0,1
	db	6,2,4,3,0,5,7,1
	db	7,6,4,0,3,2,1,5
	db	1,0,3,2,4,5,7,6
	db	6,3,5,1,2,4,7,0
	db	6,7,4,5,1,2,0,3
	db	6,0,4,1,7,3,5,2
	db	2,6,5,3,7,1,4,0
	db	1,0,6,5,3,7,4,2
	db	0,6,3,1,4,7,5,2		;80
	db	1,2,0,4,3,7,5,6
	db	5,2,6,1,4,3,0,7		;96
	db	7,1,4,0,6,5,2,3		;104
	db	7,0,6,3,2,4,1,5		;112
	db	0,4,3,7,1,5,6,2		;120
	db	6,1,7,4,2,3,5,0		;128

SOS_RANDOM
	db	0,6,10,2,8,13,1,15,3,14,9,4		;0, 1, 2,3, 4,  ,6, ,8,9, 10,   ,   ,13,14, 15 	
	db	11,2,13,5,6,3,1,8,4,9,12,7		; , 1, 2,3, 4, 5,6,7,8,9,   , 11, 12,13,  ,  	
	db	10,14,0,8,15,5,3,13,1,4,12,9		;0, 1,  ,3, 4, 5, , ,8,9, 10,   , 12,13,14, 15	
	db	8,15,5,10,11,6,1,9,3,7,12,2		; , 1, 2,3,  , 5,6,7,8,9, 10, 11, 12,  ,  , 15	
	db	14,11,0,9,15,7,1,8,13,4,12,10		;0, 1,  , , 4,  , ,7,8,9, 10, 11, 12,13,14, 15	
	db	7,9,10,11,5,6,14,2,12,3,13,0		;0,  , 2,3,  , 5,6,7, ,9, 10, 11, 12,13,14,   	
	db	6,11,1,5,7,0,15,3,8,13,4,14		;0, 1,  ,3, 4, 5,6,7,8, ,   , 11,   ,13,14, 15	
	db	10,15,5,12,2,11,4,13,0,7,10,14		;0,  , 2, , 4, 5, ,7, , ,*10, 11, 12,13,14, 15	
	db	15,0,9,1,6,11,2,8,14,4,12,3		;0, 1, 2,3, 4,  ,6, ,8,9,   , 11, 12,  ,14, 15  	
	db	11,9,2,5,7,0,15,13,10,4,6,14		;0,  , 2, , 4, 5,6,7, ,9, 10, 11,   ,13,14, 15  	
	db	7,3,12,6,2,5,1,8			; , 1, 2,3,  , 5,6,7,8, ,   ,   , 12,  ,  ,   	

;;	db	0,6,10,2,8,13,1,7,3,14,9,4
;;	db	11,1,13,5,6,3,1,8,4,9,12,7
;;	db	10,14,0,8,15,5,3,13,1,10,15,9
;;	db	8,12,2,4,11,6,13,9,4,7,15,2
;;	db	14,11,0,9,15,7,1,8,13,4,12,10
;;	db	7,9,10,15,5,6,14,2,12,3,13,0
;;	db	6,11,1,5,7,0,15,3,8,13,4,14
;;	db	10,15,5,12,2,11,3,13,0,15,10,14
;;	db	12,0,9,1,6,11,2,8,14,4,12,3
;;	db	11,9,2,5,7,0,11,5,10,4,6,14
;;	db	7,3,12,6,2,5,1,8

EASY_MISS_RAND
	db	1,3,0,2,3,0,1,2,0,1,3,2,1,0,1,2
NORM_MISS_RAND
	db	3,1,5,2,4,0,5,2,3,4,0,3,2,4,1,5
HARD_MISS_RAND
	db	5,7,0,4,6,7,3,4,5,6,1,5,3,6,2,7	

VIRUS_SKILL
	db	8
WOLF_SKILL
	db	10

WOLFBOSS_SKILL
	db	11

NORM_STEP_RAND
	db	0,6,1,7,3,5,0,4,1,2,3,0,5,2,1,3
	db	7,0,6,2,4,1,7,2,6,0,3,1,5,2,4,3
HARD_STEP_RAND
	db	3,0,6,4,5,1,7,4,2,6,5,4,3,7,5,6
	db	0,2,4,7,1,5,7,3,6,1,4,7,6,0,5,2

hentai_posx
	dw	625<<2,-625<<2,1250<<2,-1250<<2
hentai_posy
	dw	300<<2,300<<2,600<<2,600<<2
hentai_posz
	dw	-625<<2,-625<<2,-1250<<2,-1250<<2
jumptab
	db	-100,-81,-64,-49,-36,-25,-16,-9,-4,-1
	db	1,4,9,16,25,36,49,64,81,100

div2_jumptab
	db	-50,-40,-32,-24,-18,-12,-8,-4,-2,0
	db	0,2,4,8,12,18,24,32,40,50

track_ang
	db	0,32,64,92,128,160,192,224
track_move
	db	0,10	;0
	db	-10,10	;1
	db	-10,0	;2
	db	-10,-10	;3
	db	0,-10	;4
	db	10,-10	;5
	db	10,0	;6
	db	10,10	;7
k_tori_tab1
	db	0,0,0,-8,-8,-8,-8,-8
k_tori_s_tab
	db	4,4,4,4,-4,-4,-4,-4
	db	-4,-4,-4,-4,4,4,4,4
nin_warp_y
	dw	0
	dw	0
nin_warp_x
	dw	400
	dw	-400
	dw	0
	dw	0
;eguchi end
i_tabsh
	dw	mark_0
	dw	mark_N
	dw	mark_i
	dw	mark_nn
	dw	mark_t
	dw	mark_e
	dw	mark_nn
	dw	mark_d
	dw	mark_o
i_tabx
	db	-70
	db	19
	db	18
	db	19
	db	19
	db	23
	db	23
	db	23
	db	0

fontshapes
	dw	chr_a&WM
	dw	chr_b&WM
	dw	chr_c&WM
	dw	chr_d&WM
	dw	chr_e&WM
	dw	chr_f&WM
	dw	chr_g&WM
	dw	chr_h&WM
	dw	chr_i&WM
	dw	chr_j&WM
	dw	chr_k&WM
	dw	chr_l&WM
	dw	chr_m&WM
	dw	chr_n&WM
	dw	chr_o&WM
	dw	chr_p&WM
	dw	chr_q&WM
	dw	chr_r&WM
	dw	chr_s&WM
	dw	chr_t&WM
	dw	chr_u&WM
	dw	chr_v&WM
	dw	chr_w&WM
	dw	chr_x&WM
	dw	chr_y&WM
	dw	chr_z&WM
fontnumbers
	dw	chr_0&WM
	dw	chr_1&WM
	dw	chr_2&WM
	dw	chr_3&WM
	dw	chr_4&WM
	dw	chr_5&WM
	dw	chr_6&WM
	dw	chr_7&WM
	dw	chr_8&WM
	dw	chr_9&WM
;-----------------------------
;-----------------------------
;-----------------------------

;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
; CREDITS SEQUENCE TABLE

CS_TEKI	MACRO	[shape,strat,x,y,z]
	dw	{shape}
	PADDR	p{strat}
	IFEQ	NARG-2
	dw	0,0,0
	ELSEIF
	dw	{x},{y},{z}
	ENDC
	ENDM

CS_VIEW	MACRO	[view,name]
	dw	0
	PADDR	p{view}
noname	=	0
	dw	({name})&WM
	ENDM

CS_END	MACRO
	dw	0,0
	ENDM

cseq_table
	IFEQ	0
	CS_TEKI	batabata,cs_batabata,1000,300,-1000
	CS_TEKI	batabata,cs_batabata,-1000,300,-1000
	CS_TEKI	batabata,cs_batabata,500,-200,-500
	CS_TEKI	batabata,cs_batabata,-500,-200,-500
	CS_TEKI	batabata,cs_batabata
;	CS_TEKI	nullshape,cs_batabata,0,-200,0
	CS_VIEW	cs_sweep_through_mae,batabata_name

	CS_TEKI	dandou,cs_stationary_left,-100,-700,0
	CS_TEKI	dandou,cs_stationary_right,700,0,200
	CS_TEKI	dandou,cs_stationary,-700,0,0
	CS_TEKI	dandou,cs_stationary,0,700,-200
	CS_TEKI	nullshape,cs_stationary,200,0,0
	CS_VIEW	cs_sweep_through,dandou_name

	CS_TEKI	sos_0,cs_stationary,-4000,300,-3000
	CS_TEKI	sos_0,cs_stationary,4000,300,-3000
	CS_TEKI	sos_0,cs_stationary_left,-2000,0,-1500
	CS_TEKI	sos_0,cs_stationary_right,2000,0,-1500
	CS_TEKI	sos_0,cs_stationary
	CS_VIEW	cs_sweep_up2,sos_0_name

	CS_TEKI	taigun,cs_stationary,-3000,-500,-1500
	CS_TEKI	taigun,cs_stationary,3000,-500,-1500
	CS_TEKI	taigun,cs_stationary_left,-1500,500,-800
	CS_TEKI	taigun,cs_stationary_right,1500,500,-800
	CS_TEKI	taigun,cs_stationary
	CS_VIEW	cs_sweep_down,taigun_name

	CS_TEKI	jyouge,cs_stationary,-6000,500,-3000
	CS_TEKI	jyouge,cs_stationary,6000,500,-3000
	CS_TEKI	jyouge,cs_stationary_left,-3000,-500,-1500
	CS_TEKI	jyouge,cs_stationary_right,3000,-500,-1500
	CS_TEKI	sos_1,cs_stationary
	CS_VIEW	cs_sweep_up2,sos_1_name

	CS_TEKI	nullshape,cs_demo_senkan,0,0,0
	CS_TEKI	nullshape,cs_stationary,0,-1200,1000
	CS_VIEW	cs_sweep_through_big,demo_senkan_name

	CS_TEKI	dragon_0,credits_dragon,0,0,0
	CS_TEKI	nullshape,cs_stationary
	CS_VIEW	cs_sweep_through,dragon_name

	CS_TEKI	wolf_1,cs_stationary,-300,-100,100
	CS_TEKI	wolf_1,cs_stationary_left,300,100,-100
	CS_TEKI	wolf_1,cs_stationary_right,200,-100,-100
	CS_TEKI	wolf,cs_stationary
	CS_VIEW	cs_sweep_through_close,wolf_name

	ENDC

	CS_TEKI	mask,cs_stationary
	CS_TEKI	nullshape,cs_stationary,0,-300,0

	IFNE	janglish
	CS_VIEW	cs_sweep_andorf,andorf_name
	ENDC
	
	IFEQ	janglish
	CS_VIEW	cs_sweep_andorf,andross_name
	ENDC



	CS_TEKI	theend_t,cs_theend,1050,0,5
	CS_TEKI	theend_h,cs_theend,650,0,10
	CS_TEKI	theend_e,cs_theend,250,0,15
	CS_TEKI	theend_e,cs_theend,-250,0,20
	CS_TEKI	theend_n,cs_theend,-650,0,25
	CS_TEKI	theend_d,cs_theend,-1050,0,30
	CS_TEKI	nullshape,cs_stationary,-100,0,0
	CS_VIEW	cs_nosweep,noname
	CS_END

cseq_table_norm
	CS_TEKI	enkin,cs_enkin,-1800,800,-2500
	CS_TEKI	enkin,cs_enkin,1800,800,-2500
	CS_TEKI	enkin,cs_enkin,-900,400,-1500
	CS_TEKI	enkin,cs_enkin,900,400,--1500
	CS_TEKI	enkin,cs_enkin,0,0,-300
	CS_VIEW	cs_sweep_through_mae,enkin_name

	CS_TEKI	miss2_1,cs_baramiss
	CS_TEKI	nullshape,cs_stationary,0,0,500
	CS_VIEW	cs_sweep_down,baramiss_name

	CS_TEKI	virus,cs_stationary,-1000,500,0
	CS_TEKI	virus,cs_stationary,1000,0,-1000
	CS_TEKI	virus,cs_stationary
	CS_VIEW	cs_sweep_down,virus_name

;	CS_TEKI	speed_s,cs_stationary,-2400,1300,-1000
	CS_TEKI	speed_lr,cs_speed_lr,-2400,1300,-1000
;	CS_TEKI	speed_s,cs_stationary,2400,1300,-1000
	CS_TEKI	speed_lr,cs_speed_lr,2400,1300,-1000
;	CS_TEKI	speed_s,cs_stationary,-1200,800,-500
	CS_TEKI	speed_lr,cs_speed_lr,-1200,800,-500
;	CS_TEKI	speed_s,cs_stationary,1200,800,-500
	CS_TEKI	speed_lr,cs_speed_lr,1200,800,-500
;	CS_TEKI	jyouge,cs_stationary,-1200,800,-500
;	CS_TEKI	jyouge,cs_stationary,1200,800,-500
;	CS_TEKI	speed_s,cs_stationary
	CS_TEKI	speed_lr,cs_speed_lr
	CS_TEKI	nullshape,cs_stationary,0,500,0
	CS_VIEW	cs_sweep_up2,speed_name

;	CS_TEKI	baku_r,cs_stationaryslow,-40<<bakugeki_scale,0,0
;	CS_TEKI	baku_l,cs_stationaryslow,40<<bakugeki_scale,0,0
	CS_TEKI	nullshape,cs_baku
	CS_TEKI	nullshape,cs_stationary,0,-500,0
	CS_VIEW	cs_sweep_through_big,baku_name

	CS_TEKI	ninja,cs_ninja
	CS_VIEW	cs_sweep_up2,ninja_name

;	CS_TEKI	stepup_0,cs_stationary_left,-1000,200,0
;	CS_TEKI	stepup_0,cs_stationary_right,1000,200,0
;	CS_TEKI	stepup_0,cs_stationary
	CS_TEKI	stepup_0,credits_stepup,0,0,0
	CS_VIEW	cs_sweep_down,stepup_0_name

	CS_TEKI	wolf_1,cs_stationary,-300,200,100
	CS_TEKI	wolf_1,cs_stationary_left,300,100,-100
	CS_TEKI	wolf_1,cs_stationary_right,-200,-100,-100
	CS_TEKI	wolf,cs_stationary
	CS_VIEW	cs_sweep_through_close,wolf_name

	CS_TEKI	mask,cs_andorf
	CS_TEKI	nullshape,cs_stationaryslow,0,-200,0

	IFNE	janglish
	CS_VIEW	cs_sweep_andorf,andorf_name
	ENDC
	
	IFEQ	janglish
	CS_VIEW	cs_sweep_andorf,andross_name
	ENDC

	CS_TEKI	theend_t,cs_theend,1050,0,5
	CS_TEKI	theend_h,cs_theend,650,0,10
	CS_TEKI	theend_e,cs_theend,250,0,15
	CS_TEKI	theend_e,cs_theend,-250,0,20
	CS_TEKI	theend_n,cs_theend,-650,0,25
	CS_TEKI	theend_d,cs_theend,-1050,0,30
	CS_TEKI	nullshape,cs_stationary,-100,0,0
	CS_VIEW	cs_nosweep,noname

cseq_table_hard

	CS_TEKI	jyouge,cs_stationary,-6000,500,-3000
	CS_TEKI	jyouge,cs_stationary,6000,500,-3000
	CS_TEKI	jyouge,cs_stationary_left,-3000,-500,-1500
	CS_TEKI	jyouge,cs_stationary_right,3000,-500,-1500
	CS_TEKI	jyouge_1,cs_stationary
	CS_VIEW	cs_sweep_up2,jyouge_1_name

	CS_TEKI	enban_1,cs_gattai
	CS_TEKI	nullshape,cs_stationary,0,-700,0
	CS_VIEW	cs_sweep_through_big,gattai_name

	CS_TEKI	tate_m_0,cs_toge
	CS_TEKI	nullshape,cs_stationary,0,-800,0
	CS_VIEW	cs_sweep_through_big,toge_name

	CS_TEKI	kuru0_u,cs_stationary_left,-2500,500,-2000
	CS_TEKI	kuru0_u,cs_stationary,2500,500,-2000
	CS_TEKI	kuru0_u,cs_stationary,-1200,-500,-1000
	CS_TEKI	kuru0_u,cs_stationary_right,1200,-500,-1000
	CS_TEKI	kuru1_u,cs_stationary
	CS_VIEW	cs_sweep_down,kuru0_name

	CS_TEKI	sos_2,cs_sos_2
	CS_VIEW	cs_sweep_up2,sos_2_name

	CS_TEKi	nullshape,credits_crusher
	CS_TEKI	nullshape,cs_stationary,0,-500,0
	CS_VIEW	cs_sweep_through_big,crusher_name


	CS_TEKI	wolf_1,cs_stationary,-300,200,100
	CS_TEKI	wolf_1,cs_stationary_left,300,100,-100
	CS_TEKI	wolf_1,cs_stationary_right,-200,-100,-100
	CS_TEKI	wolf,cs_stationary
	CS_VIEW	cs_sweep_through_close,wolf_name

	CS_TEKi	extra1_1,credits_suisei
	CS_TEKI	nullshape,cs_stationaryslow,0,-1000,0
	CS_VIEW	cs_sweep_through_big,suisei_name

	CS_TEKI	andorf_0,cs_monkey
	CS_TEKI	andorf_1,cs_monkey
	CS_TEKI	nullshape,cs_monkey,0,-300,0
	IFNE	janglish
	CS_VIEW	cs_sweep_andorf,andorf_name
	ENDC
	
	IFEQ	janglish
	CS_VIEW	cs_sweep_andorf,andross_name
	ENDC

	CS_TEKI	theend_t,cs_theend,1050,0,5
	CS_TEKI	theend_h,cs_theend,650,0,10
	CS_TEKI	theend_e,cs_theend,250,0,15
	CS_TEKI	theend_e,cs_theend,-250,0,20
	CS_TEKI	theend_n,cs_theend,-650,0,25
	CS_TEKI	theend_d,cs_theend,-1050,0,30
	CS_TEKI	nullshape,cs_stationary,-100,0,0
	CS_VIEW	cs_nosweep,noname



	printf	"cseq size = ",*-cseq_table,"%n"







;-------------------------------------------------------
;-------------------------------------------------------
;-------------------------------------------------------
;-------------------------------------------------------
;-------------------------------------------------------

	incfile	ASM\techdata.asm





;--------------------------------------------------
;--------------------------------------------------



