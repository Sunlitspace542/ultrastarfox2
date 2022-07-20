
	incpub	coltabs


;Colour tables ----------------------------------------------------
HYPER_C
	COLNORM	14,14
	COLNORM	4,4
	COLNORM	7,7
	COLNORM	8,8



WHITE_C
	rept	128
	COLNORM	14,14
	endr

BLACK_C
	rept	64
	COLNORM	9,9
	endr	
RED_C
;	rept	110
;	COLNORM	4,4
;	endr	


;=====================================================================
;*			ID Colour Number 0			* 
;=====================================================================
ID_0_C
	COLLITE	$0,0		; 00
	COLLITE	$1,1		; 01
	COLLITE	$2,2		; 02
	COLLITE	$3,3		; 03
	COLLITE	$4,4		; 04
	COLLITE	$5,5		; 05
	COLLITE	$6,6		; 06
	COLLITE	$7,7		; 07
	COLLITE	$8,8		; 08
	COLLITE	$9,9		; 09
	COLDEPTH	$0	; 10
	COLDEPTH	$1	; 11
	COLDEPTH	$2	; 12
	COLDEPTH	$3	; 13
	COLDEPTH	$4	; 14
	COLDEPTH	$5	; 15
	COLDEPTH	$6	; 16
	COLDEPTH	$7	; 17
	COLDEPTH	$8	; 18
	COLDEPTH	$9	; 19
	COLDEPTH	$a	; 20
	COLDEPTH	$b	; 21
	COLDEPTH	$c	; 22
	COLDEPTH	$d	; 23
	COLDEPTH	$e	; 24
	COLDEPTH	$f	; 25
	COLDEPTH	$10	; 26
	COLDEPTH	$11	; 27
	COLDEPTH	$12	; 28
	COLDEPTH	$13	; 29
	COLDEPTH	$14	; 30
	COLDEPTH	$15	; 31
	COLDEPTH	$16	; 32
	COLDEPTH	$17	; 33
	COLDEPTH	$18	; 34
	COLDEPTH	$19	; 35
	COLDEPTH	$1a	; 36
	COLDEPTH	$1b	; 37
	COLDEPTH	$1c	; 38
	COLDEPTH	$1d	; 39
	COLDEPTH	$1e	; 40
	COLDEPTH	$1f	; 41
	COLANIM	CA_0		; 42
	COLANIM	CA_1		; 43
	COLANIM	CA_2		; 44
	COLANIM	CA_3		; 45
	COLANIM	CA_4		; 46
	COLANIM	CA_5		; 47
	COLNORM	$9,$9		; 48	;color 9,9 dither
	COLNORM	$9,$a		; 49
	COLNORM	$a,$a		; 50
	COLNORM	$a,$b		; 51
	COLNORM	$b,$b		; 52
	COLNORM	$b,$c		; 53
	COLNORM	$c,$c		; 54
	COLNORM	$c,$d		; 55
	COLNORM	$d,$d		; 56
	COLNORM	$d,$e		; 57
	COLNORM	$e,$e		; 58
	COLNORM	$1,$1		; 59
	COLNORM	$1,$2		; 60
	COLNORM	$2,$2		; 61
	COLNORM	$2,$3		; 62
	COLNORM	$3,$3		; 63
	COLNORM	$3,$4		; 64
	COLNORM	$4,$4		; 65
	COLNORM	$5,$5		; 66
	COLNORM	$5,$6		; 67
	COLNORM	$6,$6		; 68
	COLNORM	$6,$7		; 69
	COLNORM	$7,$7		; 70
	COLNORM	$7,$8		; 71
	COLNORM	$8,$8		; 72
	COLNORM	$f,$f		; 73
	COLANIM	CA_6		; 74
	COLNORM	$0,$0		; 75
	COLANIM	CA_7		; 76

	COLTEXT	sfmark_spr,5	; 77 :dummy
	COLTEXT	sfmark_spr,5	; 78 :dummy
	COLTEXT	sfmark_spr,5	; 79 :dummy
	COLTEXT	sfmark_spr,5	; 80 :dummy
	COLTEXT	sfmark_spr,5	; 81 :dummy
	COLTEXT	sfmark_spr,5	; 82 :dummy
	COLTEXT	sfmark_spr,5	; 83 :dummy
	COLTEXT	sfmark_spr,5	; 84 :dummy
	COLTEXT	sfmark_spr,5	; 85 :dummy
	COLTEXT	sfmark_spr,5	; 86 :dummy
	COLTEXT	sfmark_spr,5	; 87 :dummy
	COLTEXT	sfmark_spr,5	; 88 :dummy
	COLTEXT	sfmark_spr,5	; 89 :dummy

	COLANIM	charalabel_a1	; 90
	COLANIM	resupply_a1	; 91
	COLTEXT	kikai_spr,0	; 92
	COLTEXT	sfmark_spr,5	; 93
	COLTEXT	sfmark_spr,5	; 94 :dummy
	COLTEXT	kinoko0_spr,0	; 95
	COLANIM	firemark_a1,8	; 96
	COLTEXT	takoashi_spr,0	; 97
	COLTEXT	sarumark_spr	; 98
	COLANIM	ryuusa_a1,0	; 99	;dummy
	COLANIM	rope_a1,0	; 100	;dummy
	COLanim	wakame_a1,0	; 101 
	COLTEXT	dokuro1_spr,0	; 102	;dummy
	COLTEXT	flower1_spr,0	; 103
	COLTEXT	flower2_spr,0	; 104
	COLTEXT	kinoko1_spr,0	; 105
	COLTEXT	kinoko2_spr,0	; 106
	COLTEXT	inumark_spr,0	; 107
	COLTEXT	iwa0_ue_spr,0	; 108
	COLTEXT	iwa0_yoko_spr,0	; 109
	COLTEXT	iwa1_ue_spr,0	; 110
	COLTEXT	iwa1_yoko_spr,0 ; 111
	COLTEXT	miss_spr	; 112
	COLTEXT	container_spr,0	; 113
	COLANIM	switch_a1,0	; 114
	COLTEXT	andorossbox1_spr,1	; 115
	COLANIM	bubble_a1,0	; 116
	COLTEXT	meteo_spr,0	; 117
	COLTEXT	kusa_spr,0	; 118
	COLANIM lava_a1,0	; 119
	COLANIM	item_a1,0	; 120
	COLANIM	kaifuku_a1,0	; 121
	COLTEXT	tank_spr,0	; 122
	COLANIM	plasma1_a1,0	; 123
	COLTEXT	eye_spr,0	; 124	;dummy
	COLTEXT	way_spr,0	; 125
	COLTEXT	core_spr,0	; 126
	COLTEXT	batsu_spr,0	; 127
	COLTEXT	maru_spr,0	; 128
	COLTEXT	kakomu1_spr,0	; 129
	COLTEXT	kakomu2_spr,0	; 130
	COLANIM	maskeye1_a1	; 131
	COLANIM	maskeye2_a1	; 132

;=====================================================================
;*			ID Colour Number 1			* 
;=====================================================================
ID_1_C
	COLLITE	$0,0		; 00
	COLLITE	$1,1		; 01
	COLLITE	$3,3		; 02
	COLLITE	$2,2		; 03
	COLLITE	$5,5		; 04
	COLLITE	$4,4		; 05
	COLLITE	$7,7		; 06
	COLLITE	$6,6		; 07
	COLLITE	$9,9		; 08
	COLLITE	$8,8		; 09
	COLDEPTH	$0	; 10
	COLDEPTH	$1	; 11
	COLDEPTH	$2	; 12
	COLDEPTH	$3	; 13
	COLDEPTH	$4	; 14
	COLDEPTH	$5	; 15
	COLDEPTH	$6	; 16
	COLDEPTH	$7	; 17
	COLDEPTH	$8	; 18
	COLDEPTH	$9	; 19
	COLDEPTH	$a	; 20
	COLDEPTH	$12	; 21
	COLDEPTH	$13	; 22
	COLDEPTH	$14	; 23
	COLDEPTH	$15	; 24
	COLDEPTH	$16	; 25
	COLDEPTH	$17	; 26
	COLDEPTH	$18	; 27
	COLDEPTH	$b	; 28
	COLDEPTH	$c	; 29
	COLDEPTH	$d	; 30
	COLDEPTH	$e	; 31
	COLDEPTH	$f	; 32
	COLDEPTH	$10	; 33
	COLDEPTH	$11	; 34
	COLDEPTH	$19	; 35
	COLDEPTH	$1a	; 36
	COLDEPTH	$1b	; 37
	COLDEPTH	$1c	; 38
	COLDEPTH	$1d	; 39
	COLDEPTH	$1e	; 40
	COLDEPTH	$1f	; 41
	COLANIM	CA_0		; 42
	COLANIM	CA_1		; 43
	COLANIM	CA_2		; 44
	COLANIM	CA_3		; 45
	COLANIM	CA_4		; 46
	COLANIM	CA_5		; 47
	COLNORM	$9,$9		; 48 
	COLNORM	$9,$a		; 49 
	COLNORM	$a,$a		; 50 
	COLNORM	$a,$b		; 51 
	COLNORM	$b,$b		; 52 
	COLNORM	$b,$c		; 53 
	COLNORM	$c,$c		; 54 
	COLNORM	$c,$d		; 55 
	COLNORM	$d,$d		; 56 
	COLNORM	$d,$e		; 57 
	COLNORM	$e,$e		; 58 
	COLNORM	$1,$1		; 59 
	COLNORM	$1,$2		; 60 
	COLNORM	$2,$2		; 61 
	COLNORM	$2,$3		; 62 
	COLNORM	$3,$3		; 63 
	COLNORM	$3,$4		; 64 
	COLNORM	$4,$4		; 65 
	COLNORM	$5,$5		; 66 
	COLNORM	$5,$6		; 67 
	COLNORM	$6,$6		; 68 
	COLNORM	$6,$7		; 69 
	COLNORM	$7,$7		; 70 
	COLNORM	$7,$8		; 71 
	COLNORM	$8,$8		; 72 
	COLNORM	$f,$f		; 73

	COLANIM	CA_6		; 74
	COLNORM	$0,$0		; 75
	COLANIM	CA_1		; 76

	COLTEXT	sfmark_spr,5	; 77 :dummy
	COLTEXT	sfmark_spr,5	; 78 :dummy
	COLTEXT	sfmark_spr,5	; 79 :dummy
	COLTEXT	sfmark_spr,5	; 80 :dummy
	COLTEXT	sfmark_spr,5	; 81 :dummy
	COLTEXT	sfmark_spr,5	; 82 :dummy
	COLTEXT	sfmark_spr,5	; 83 :dummy
	COLTEXT	sfmark_spr,5	; 84 :dummy
	COLTEXT	sfmark_spr,5	; 85 :dummy
	COLTEXT	sfmark_spr,5	; 86 :dummy
	COLTEXT	sfmark_spr,5	; 87 :dummy
	COLTEXT	sfmark_spr,5	; 88 :dummy
	COLTEXT	sfmark_spr,5	; 89 :dummy
	COLANIM	charalabel_a1	; 90
	COLANIM	resupply_a1	; 91
	COLTEXT	sfmark_spr,5	; 92 :dummy
	COLTEXT	sfmark_spr,5	; 93
	COLTEXT	sfmark_spr,5	; 94 :dummy
	COLTEXT	kinoko0_spr,0	; 95
	COLANIM	firemark_a1,8	; 96
	COLTEXT	takoashi_spr,0	; 97
	COLTEXT	sarumark_spr	; 98
	COLANIM	ryuusa_a1,0	; 99
	COLANIM	rope_a1,0	; 100
	COLanim	wakame_a1,0	; 101 
	COLTEXT	sfmark_spr,5	; 102 :dummy
	COLTEXT	flower1_spr,0	; 103
	COLTEXT	flower2_spr,0	; 104
	COLTEXT	kinoko1_spr,0	; 105
	COLTEXT	kinoko2_spr,0	; 106
	COLTEXT	inumark_spr,0	; 107
	COLTEXT	iwa1_ue_spr,0	; 108
	COLTEXT	iwa1_yoko_spr,0	; 109
	COLLITE	$0,0		; 110
	COLLITE	$0,0		; 111
	COLTEXT	sfmark_spr,5	; 112 :dummy;kouji_spr,0
	COLTEXT	container_spr,0	; 113
	COLTEXT	sfmark_spr,5	; 114 :dummy
	COLTEXT	dokuro1_spr,2	; 115 :dummy
	COLANIM	bubble_a1,0	; 116
	COLTEXT	meteo_spr,0	; 117
	COLTEXT	kusa_spr,0	; 118
	COLANIM lava_a1,0	; 119
	COLANIM	item_a1,0	; 120
	COLTEXT	tank_spr,0	; 121 :dummy
	COLTEXT	tank_spr,0	; 122
	COLANIM	plasma1_a1,0	; 123
	COLTEXT	eye_spr,0	; 124
	COLTEXT	way_spr,0	; 125
	COLTEXT	core_spr,0	; 126
	COLTEXT	batsu_spr,0	; 127
	COLTEXT	maru_spr,0	; 128
	COLTEXT	kakomu1_spr,0	; 129
	COLTEXT	kakomu2_spr,0	; 130

;=====================================================================
;*			ID Colour Number 2			* 
;=====================================================================
ID_2_C
	COLLITE	$2,2		; 00
	COLLITE	$6,6		; 01
	COLLITE	$0,0		; 02
	COLLITE	$3,3		; 03
	COLLITE	$4,4		; 04
	COLLITE	$5,5		; 05
	COLLITE	$1,1		; 06
	COLLITE	$7,7		; 07
	COLLITE	$8,8		; 08
	COLLITE	$9,9		; 09
	COLDEPTH	$0	; 10
	COLDEPTH	$1	; 11
	COLDEPTH	$b	; 12
	COLDEPTH	$c	; 13
	COLDEPTH	$d	; 14
	COLDEPTH	$e	; 15
	COLDEPTH	$f	; 16
	COLDEPTH	$10	; 17
	COLDEPTH	$11	; 18
	COLDEPTH	$9	; 19
	COLDEPTH	$a	; 20
	COLDEPTH	$2	; 21
	COLDEPTH	$3	; 22
	COLDEPTH	$4	; 23
	COLDEPTH	$5	; 24
	COLDEPTH	$6	; 25
	COLDEPTH	$7	; 26
	COLDEPTH	$8	; 27
	COLDEPTH	$12	; 28
	COLDEPTH	$13	; 29
	COLDEPTH	$14	; 30
	COLDEPTH	$15	; 31
	COLDEPTH	$16	; 32
	COLDEPTH	$17	; 33
	COLDEPTH	$18	; 34
	COLDEPTH	$19	; 35
	COLDEPTH	$1a	; 36
	COLDEPTH	$1b	; 37
	COLDEPTH	$1c	; 38
	COLDEPTH	$1d	; 39
	COLDEPTH	$1e	; 40
	COLDEPTH	$1f	; 41
	COLANIM	CA_0		; 42
	COLANIM	CA_1		; 43
	COLANIM	CA_2		; 44
	COLANIM	CA_3		; 45
	COLANIM	CA_4		; 46
	COLANIM	CA_5		; 47
	COLNORM	$9,$9		; 48 
	COLNORM	$9,$a		; 49 
	COLNORM	$a,$a		; 50 
	COLNORM	$a,$b		; 51 
	COLNORM	$b,$b		; 52 
	COLNORM	$b,$c		; 53 
	COLNORM	$c,$c		; 54 
	COLNORM	$c,$d		; 55 
	COLNORM	$d,$d		; 56 
	COLNORM	$d,$e		; 57 
	COLNORM	$e,$e		; 58 
	COLNORM	$1,$1		; 59 
	COLNORM	$1,$2		; 60 
	COLNORM	$2,$2		; 61 
	COLNORM	$2,$3		; 62 
	COLNORM	$3,$3		; 63 
	COLNORM	$3,$4		; 64 
	COLNORM	$4,$4		; 65 
	COLNORM	$5,$5		; 66 
	COLNORM	$5,$6		; 67 
	COLNORM	$6,$6		; 68 
	COLNORM	$6,$7		; 69 
	COLNORM	$7,$7		; 70 
	COLNORM	$7,$8		; 71 
	COLNORM	$8,$8		; 72 
	COLNORM	$f,$f		; 73

	IFEQ	1
	COLTEXT	sfmark_spr,5	; 74 :dummy
	COLTEXT	sfmark_spr,5	; 75 :dummy
	COLTEXT	sfmark_spr,5	; 76 :dummy
	COLTEXT	sfmark_spr,5	; 77 :dummy
	COLTEXT	sfmark_spr,5	; 78 :dummy
	COLTEXT	sfmark_spr,5	; 79 :dummy
	COLTEXT	sfmark_spr,5	; 80 :dummy
	COLTEXT	sfmark_spr,5	; 81 :dummy
	COLTEXT	sfmark_spr,5	; 82 :dummy
	COLTEXT	sfmark_spr,5	; 83 :dummy
	COLTEXT	sfmark_spr,5	; 84 :dummy
	COLTEXT	sfmark_spr,5	; 85 :dummy
	COLTEXT	sfmark_spr,5	; 86 :dummy
	COLTEXT	sfmark_spr,5	; 87 :dummy
	COLTEXT	sfmark_spr,5	; 88 :dummy
	COLTEXT	sfmark_spr,5	; 89 :dummy
	COLANIM	charalabel_a1	; 90
	COLANIM	resupply_a1	; 91
	COLTEXT	sfmark_spr,5	; 92 :dummy
	COLTEXT	sfmark_spr,5	; 93
	COLTEXT	sfmark_spr,5	; 94 :dummy
	COLLITE	$3,3		; 95
	COLANIM	firemark_a1,8	; 96
	COLTEXT	takoashi_spr,0	; 97
	COLTEXT	sarumark_spr	; 98
	COLANIM	ryuusa_a1,0	; 99
	COLANIM	rope_a1,0	; 100
	COLanim	wakame_a1,0	; 101 
	COLTEXT	sfmark_spr,5	; 102 :dummy
	COLTEXT	flower1_spr,0	; 103
	COLTEXT	flower2_spr,0	; 104
	COLLITE	$2,2		; 105
	COLLITE	$3,3		; 106
	COLTEXT	inumark_spr,0	; 107
	COLTEXT	iwa0_ue_spr,0	; 108
	COLTEXT	iwa0_yoko_spr,0	; 109
	COLLITE	$1,1		; 110
	COLLITE	$1,1		; 111
	COLTEXT	sfmark_spr,5	; 112 :dummy;kouji_spr,0
	COLTEXT	container_spr,0	; 113
	COLTEXT	sfmark_spr,5	; 114 :dummy
	COLTEXT	dokuro1_spr,2	; 115
	COLANIM	bubble_a1,0	; 116
	COLTEXT	meteo_spr,0	; 117
	COLTEXT	kusa_spr,0	; 118
	COLANIM lava_a1,0	; 119
	COLANIM	item_a1,0	; 120
	COLTEXT	tank_spr,0	; 121 :dummy
	COLTEXT	tank_spr,0	; 122
	COLANIM	plasma1_a1,0	; 123
	COLTEXT	eye_spr,0	; 124
	COLTEXT	way_spr,0	; 125
	COLTEXT	core_spr,0	; 126
	COLTEXT	batsu_spr,0	; 127
	COLTEXT	maru_spr,0	; 128
	COLTEXT	kakomu1_spr,0	; 129
	COLTEXT	kakomu2_spr,0	; 130
	ENDC

;=====================================================================
;*			ID Colour Number 3			* 
;=====================================================================
ID_3_C
	COLLITE	$0,0		; 00
	COLLITE	$1,1		; 01
	COLLITE	$2,2		; 02
	COLLITE	$3,3		; 03
	COLLITE	$4,4		; 04
	COLLITE	$5,5		; 05
	COLLITE	$6,6		; 06
	COLLITE	$7,7		; 07
	COLLITE	$8,8		; 08
	COLLITE	$9,9		; 09
	COLDEPTH	$0	; 10
	COLDEPTH	$1	; 11
	COLDEPTH	$2	; 12
	COLDEPTH	$3	; 13
	COLDEPTH	$4	; 14
	COLDEPTH	$5	; 15
	COLDEPTH	$6	; 16
	COLDEPTH	$7	; 17
	COLDEPTH	$8	; 18
	COLDEPTH	$9	; 19
	COLDEPTH	$a	; 20
	COLDEPTH	$b	; 21
	COLDEPTH	$c	; 22
	COLDEPTH	$d	; 23
	COLDEPTH	$e	; 24
	COLDEPTH	$f	; 25
	COLDEPTH	$10	; 26
	COLDEPTH	$11	; 27
	COLDEPTH	$12	; 28
	COLDEPTH	$13	; 29
	COLDEPTH	$14	; 30
	COLDEPTH	$15	; 31
	COLDEPTH	$16	; 32
	COLDEPTH	$17	; 33
	COLDEPTH	$18	; 34
	COLDEPTH	$19	; 35
	COLDEPTH	$1a	; 36
	COLDEPTH	$1b	; 37
	COLDEPTH	$1c	; 38
	COLDEPTH	$1d	; 39
	COLDEPTH	$1e	; 40
	COLDEPTH	$1f	; 41
	COLANIM	CA_0		; 42
	COLANIM	CA_1		; 43
	COLANIM	CA_2		; 44
	COLANIM	CA_3		; 45
	COLANIM	CA_4		; 46
	COLANIM	CA_5		; 47
	COLNORM	$9,$9		; 48	;color 9,9 dither
	COLNORM	$9,$a		; 49
	COLNORM	$a,$a		; 50
	COLNORM	$a,$b		; 51
	COLNORM	$b,$b		; 52
	COLNORM	$b,$c		; 53
	COLNORM	$c,$c		; 54
	COLNORM	$c,$d		; 55
	COLNORM	$d,$d		; 56
	COLNORM	$d,$e		; 57
	COLNORM	$e,$e		; 58
	COLNORM	$1,$1		; 59
	COLNORM	$1,$2		; 60
	COLNORM	$2,$2		; 61
	COLNORM	$2,$3		; 62
	COLNORM	$3,$3		; 63
	COLNORM	$3,$4		; 64
	COLNORM	$4,$4		; 65
	COLNORM	$5,$5		; 66
	COLNORM	$5,$6		; 67
	COLNORM	$6,$6		; 68
	COLNORM	$6,$7		; 69
	COLNORM	$7,$7		; 70
	COLNORM	$7,$8		; 71
	COLNORM	$8,$8		; 72
	COLNORM	$f,$f		; 73
	COLANIM	CA_6		; 74


	IFEQ	1
	COLTEXT	sfmark_spr,5	; 75 :dummy
	COLTEXT	sfmark_spr,5	; 76 :dummy
	COLTEXT	sfmark_spr,5	; 77 :dummy
	COLTEXT	sfmark_spr,5	; 78 :dummy
	COLTEXT	sfmark_spr,5	; 79 :dummy
	COLTEXT	sfmark_spr,5	; 80 :dummy
	COLTEXT	sfmark_spr,5	; 81 :dummy
	COLTEXT	sfmark_spr,5	; 82 :dummy
	COLTEXT	sfmark_spr,5	; 83 :dummy
	COLTEXT	sfmark_spr,5	; 84 :dummy
	COLTEXT	sfmark_spr,5	; 85 :dummy
	COLTEXT	sfmark_spr,5	; 86 :dummy
	COLTEXT	sfmark_spr,5	; 87 :dummy
	COLTEXT	sfmark_spr,5	; 88 :dummy
	COLTEXT	sfmark_spr,5	; 89 :dummy

	COLLITE	$0,0		; 90
	COLLITE	$0,0		; 91
	COLLITE	$0,0		; 92
	COLLITE	$0,0		; 93
	COLLITE	$0,0		; 94
	COLLITE	$0,0		; 95
	COLLITE	$0,0		; 96
	COLLITE	$0,0		; 97
	COLLITE	$0,0		; 98
	COLLITE	$0,0		; 99
	COLLITE	$0,0		; 100
	COLLITE	$0,0		; 101
	COLLITE	$0,0		; 102
	COLLITE	$0,0		; 103
	COLLITE	$0,0		; 104
	COLLITE	$0,0		; 105
	COLLITE	$0,0		; 106
	COLLITE	$0,0		; 107
	COLLITE	$0,0		; 108
	COLLITE	$0,0		; 109
	COLLITE	$0,0		; 110
	COLLITE	$0,0		; 111
	COLLITE	$0,0		; 112
	COLLITE	$0,0		; 113
	COLLITE	$0,0		; 114
	COLLITE	$0,0		; 115
	COLLITE	$0,0		; 116
	COLLITE	$0,0		; 117
	COLLITE	$0,0		; 118
	COLLITE	$0,0		; 119
	COLLITE	$0,0		; 120
	COLLITE	$0,0		; 121
	COLLITE	$0,0		; 122
	COLLITE	$0,0		; 123
	COLLITE	$0,0		; 124
	COLLITE	$0,0		; 125
	COLTEXT	core_spr,0	; 126
	COLTEXT	batsu_spr,0	; 127
	COLTEXT	maru_spr,0	; 128
	COLTEXT	kakomu1_spr,0	; 129
	COLTEXT	kakomu2_spr,0	; 130
	ENDC

	IFEQ	1

	COLLITE	$3,$3		; 00
	COLLITE	$7,$7		; 01
	COLLITE	$2,$2		; 02
	COLLITE	$0,$0		; 03
	COLLITE	$4,$4		; 04
	COLLITE	$5,$5		; 05
	COLLITE	$6,$6		; 06
	COLLITE	$1,$1		; 07
	COLLITE	$8,$8		; 08
	COLLITE	$9,$9		; 09
	COLDEPTH	$0	; 10
	COLDEPTH	$1	; 11
	COLDEPTH	$12	; 12
	COLDEPTH	$13	; 13
	COLDEPTH	$14	; 14
	COLDEPTH	$15	; 15
	COLDEPTH	$16	; 16
	COLDEPTH	$17	; 17
	COLDEPTH	$18	; 18
	COLDEPTH	$9	; 19
	COLDEPTH	$a	; 20
	COLDEPTH	$b	; 21
	COLDEPTH	$c	; 22
	COLDEPTH	$d	; 23
	COLDEPTH	$e	; 24
	COLDEPTH	$f	; 25
	COLDEPTH	$10	; 26
	COLDEPTH	$11	; 27
	COLDEPTH	$2	; 28
	COLDEPTH	$3	; 29
	COLDEPTH	$4	; 30
	COLDEPTH	$5	; 31
	COLDEPTH	$6	; 32
	COLDEPTH	$7	; 33
	COLDEPTH	$8	; 34
	COLDEPTH	$19	; 35
	COLDEPTH	$1a	; 36
	COLDEPTH	$1b	; 37
	COLDEPTH	$1c	; 38
	COLDEPTH	$1d	; 39
	COLDEPTH	$1e	; 40
	COLDEPTH	$1f	; 41
	COLANIM	CA_0		; 42
	COLANIM	CA_1		; 43
	COLANIM	CA_2		; 44
	COLANIM	CA_3		; 45
	COLANIM	CA_4		; 46
	COLANIM	CA_5		; 47
	COLNORM	$9,$9		; 48 
	COLNORM	$9,$a		; 49 
	COLNORM	$a,$a		; 50 
	COLNORM	$a,$b		; 51 
	COLNORM	$b,$b		; 52 
	COLNORM	$b,$c		; 53 
	COLNORM	$c,$c		; 54 
	COLNORM	$c,$d		; 55 
	COLNORM	$d,$d		; 56 
	COLNORM	$d,$e		; 57 
	COLNORM	$e,$e		; 58 
	COLNORM	$1,$1		; 59 
	COLNORM	$1,$2		; 60 
	COLNORM	$2,$2		; 61 
	COLNORM	$2,$3		; 62 
	COLNORM	$3,$3		; 63 
	COLNORM	$3,$4		; 64 
	COLNORM	$4,$4		; 65 
	COLNORM	$5,$5		; 66 
	COLNORM	$5,$6		; 67 
	COLNORM	$6,$6		; 68 
	COLNORM	$6,$7		; 69 
	COLNORM	$7,$7		; 70 
	COLNORM	$7,$8		; 71 
	COLNORM	$8,$8		; 72 
	COLNORM	$f,$f		; 73
	COLTEXT	sfmark_spr,5	; 74 :dummy
	COLTEXT	sfmark_spr,5	; 75 :dummy
	COLTEXT	sfmark_spr,5	; 76 :dummy
	COLTEXT	sfmark_spr,5	; 77 :dummy
	COLTEXT	sfmark_spr,5	; 78 :dummy
	COLTEXT	sfmark_spr,5	; 79 :dummy
	COLTEXT	sfmark_spr,5	; 80 :dummy
	COLTEXT	sfmark_spr,5	; 81 :dummy
	COLTEXT	sfmark_spr,5	; 82 :dummy
	COLTEXT	sfmark_spr,5	; 83 :dummy
	COLTEXT	sfmark_spr,5	; 84 :dummy
	COLTEXT	sfmark_spr,5	; 85 :dummy
	COLTEXT	sfmark_spr,5	; 86 :dummy
	COLTEXT	sfmark_spr,5	; 87 :dummy
	COLTEXT	sfmark_spr,5	; 88 :dummy
	COLTEXT	sfmark_spr,5	; 89 :dummy
	COLANIM	charalabel_a1	; 90
	COLANIM	resupply_a1	; 91
	COLDEPTH	$6 	; 92
	COLTEXT	sfmark_spr,5	; 93
	COLTEXT	sfmark_spr,5	; 94 :dummy
	COLDEPTH	$12	; 95
	COLANIM	firemark_a1,8	; 96
	COLTEXT	takoashi_spr,0	; 97
	COLTEXT	sarumark_spr	; 98
	COLANIM	ryuusa_a1,0	; 99
	COLANIM	rope_a1,0	; 100
	COLanim	wakame_a1,0	; 101 
	COLTEXT	sfmark_spr,5	; 102 :dummy
	COLTEXT	flower1_spr,0	; 103
	COLTEXT	flower2_spr,0	; 104
	COLDEPTH	$b	; 105
	COLDEPTH	$12	; 106
	COLTEXT	inumark_spr,0	; 107
	COLTEXT	iwa0_ue_spr,0	; 108
	COLTEXT	iwa0_yoko_spr,0	; 109
	COLDEPTH	$2	; 110
	COLDEPTH	$2 	; 111
	COLDEPTH	$2 	; 112
	COLTEXT	container_spr,0	; 113
	COLTEXT	sfmark_spr,5	; 114 :dummy
	COLTEXT	dokuro1_spr,2	; 115
	COLANIM	bubble_a1,0	; 116
	COLTEXT	meteo_spr,0	; 117
	COLTEXT	kusa_spr,0	; 118
	COLANIM lava_a1,0	; 119
	COLANIM	item_a1,0	; 120
	COLTEXT	star_spr,11	; 121
	COLTEXT	tank_spr,0	; 122
	COLANIM	plasma1_a1,0	; 123
	COLTEXT	eye_spr,0	; 124
	COLDEPTH	$8 	; 125
	COLTEXT	core_spr,0	; 126
	COLTEXT	batsu_spr,0	; 127
	COLTEXT	maru_spr,0	; 128
	ENDC
;=====================================================================
;*			ID Colour Number 4			* 
;=====================================================================
ID_4_C
	ifeq	1
	COLLITE	$0,0
	COLLITE	$1,1
	COLLITE	$0,0
	COLLITE	$3,3
	COLLITE	$4,4
	COLLITE	$5,5
	COLLITE	$1,1
	COLLITE	$7,7
	COLLITE	$8,8
	COLLITE	$9,9
	COLDEPTH	$0
	COLDEPTH	$1
	COLDEPTH	$2
	COLDEPTH	$3
	COLDEPTH	$4
	COLDEPTH	$5
	COLDEPTH	$6
	COLDEPTH	$7
	COLDEPTH	$8
	COLDEPTH	$9
	COLDEPTH	$a
	COLDEPTH	$0
	COLDEPTH	$1
	COLDEPTH	$2
	COLDEPTH	$3
	COLDEPTH	$4
	COLDEPTH	$5
	COLDEPTH	$6
	COLDEPTH	$12
	COLDEPTH	$13
	COLDEPTH	$14
	COLDEPTH	$15
	COLDEPTH	$16
	COLDEPTH	$17
	COLDEPTH	$18
	COLDEPTH	$19
	COLDEPTH	$1a
	COLDEPTH	$1b
	COLDEPTH	$1c
	COLDEPTH	$1d
	COLDEPTH	$1e
	COLDEPTH	$1f
	COLANIM	CA_0
	COLANIM	CA_1
	COLANIM	CA_2
	COLANIM	CA_3
	COLANIM	CA_4
	COLANIM	CA_5
	endc

;=====================================================================
;*			ID Colour Number 5			* 
;=====================================================================
	IFEQ	1
ID_5_C

	COLLITE	$0,$0	; 00
	COLLITE	$1,$1	; 01
	COLLITE	$2,$2	; 02
	COLLITE	$0,$0	; 03
	COLLITE	$4,$4	; 04
	COLLITE	$5,$5	; 05
	COLLITE	$6,$6	; 06
	COLLITE	$1,$1	; 07
	COLLITE	$8,$8	; 08
	COLLITE	$9,$9	; 09
	COLDEPTH	; 10
	COLDEPTH	; 11
	COLDEPTH	; 12
	COLDEPTH	; 13
	COLDEPTH	; 14
	COLDEPTH	; 15
	COLDEPTH	; 16
	COLDEPTH	; 17
	COLDEPTH	; 18
	COLDEPTH	; 19
	COLDEPTH	; 20
	COLDEPTH	; 21
	COLDEPTH	; 22
	COLDEPTH	; 23
	COLDEPTH	; 24
	COLDEPTH	; 25
	COLDEPTH	; 26
	COLDEPTH	; 27
	COLDEPTH	; 28
	COLDEPTH	; 29
	COLDEPTH	; 30
	COLDEPTH	; 31
	COLDEPTH	; 32
	COLDEPTH	; 33
	COLDEPTH	; 34
	COLDEPTH	; 35
	COLDEPTH	; 36
	COLDEPTH	; 37
	COLDEPTH	; 38
	COLDEPTH	; 39
	COLDEPTH	; 40
	COLDEPTH	; 41
	COLANIM	CA_0	; 42
	COLANIM	CA_3	; 43
	COLANIM	CA_2	; 44
	COLANIM	CA_1	; 45
	COLANIM	CA_4	; 46
	COLANIM	CA_5	; 47
	ENDC
;=====================================================================
;*			ID Colour Number 6			* 
;=====================================================================
	IFEQ	1
ID_6_C
	COLLITE	$0,0		; 00
	COLLITE	$1,1		; 01
	COLLITE	$2,2		; 02
	COLLITE	$3,3		; 03
	COLLITE	$4,4		; 04
	COLLITE	$5,5		; 05
	COLLITE	$6,6		; 06
	COLLITE	$7,7		; 07
	COLLITE	$8,8		; 08
	COLLITE	$9,9		; 09
	COLNORM	$9,$9		; 10	;color 9,9 dither
	COLNORM	$9,$a		; 11
	COLNORM	$a,$a		; 12
	COLNORM	$a,$b		; 13
	COLNORM	$b,$b		; 14
	COLNORM	$b,$c		; 15
	COLNORM	$c,$c		; 16
	COLNORM	$c,$d		; 17
	COLNORM	$d,$d		; 18
	COLNORM	$d,$e		; 19
	COLNORM	$e,$e		; 20
	COLNORM	$1,$1		; 21
	COLNORM	$1,$2		; 22
	COLNORM	$2,$2		; 23
	COLNORM	$2,$3		; 24
	COLNORM	$3,$3		; 25
	COLNORM	$3,$4		; 26
	COLNORM	$4,$4		; 27
	COLNORM	$5,$5		; 28
	COLNORM	$5,$6		; 29
	COLNORM	$6,$6		; 30
	COLNORM	$6,$7		; 31
	COLNORM	$7,$7		; 32
	COLNORM	$7,$8		; 33
	COLNORM	$8,$8		; 34
	COLNORM	$f,$f		; 35

	ENDC
CA_0
	DB	4
	COLNORM	$e,$e
	COLNORM	$7,$7
	COLNORM	$2,$2
	COLNORM	$f,$f
CA_1
	DB	4
	COLNORM	$4,$4
	COLNORM	$3,$3
	COLNORM	$2,$2
	COLNORM	$1,$1


CA_2
	DB	4
	COLNORM	$8,$8
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
CA_3
	DB	4
	COLNORM	$e,$e
	COLNORM	$d,$d
	COLNORM	$c,$c
	COLNORM	$b,$b
CA_4	
	DB	4
	COLNORM	$4,$e
	COLNORM	$6,$8
	COLNORM	$2,$8
	COLNORM	$1,$3
CA_5	
	DB	4
	COLNORM	$0,$e
	COLNORM	$0,$7
	COLNORM	$0,$2
	COLNORM	$0,$f

CA_6	;Dodora (dylan)
	DB	8
	COLNORM	$8,$8	;blue
	COLNORM	$7,$7
	COLNORM	$6,$6
	COLNORM	$5,$5
	COLNORM	$4,$4	;red
	COLNORM	$3,$3
	COLNORM	$2,$2
	COLNORM	$1,$1


CA_7
	DB	4
	COLNORM	$e,$e
	COLNORM	$f,$f
	COLNORM	$e,$e
	COLNORM	$f,$f

explode_c	COLANIM	explode_a1
explode2_c	COLANIM	explode2_a1
explode3_c	COLANIM	explode3_a1


explode_a1	db	2
;	COLTEXT	largeexplosion1_spr,6
	COLTEXT	largeexplosion2_spr,6
;	COLTEXT	smallexplosion1_spr
	COLTEXT	smallexplosion2_spr

explode2_a1	db	8
	COLTEXT	smallexplosion1_spr,0
	COLTEXT	largeexplosion2_spr,6
	COLTEXT	largeexplosion3_spr,6
	COLTEXT	largeexplosion4_spr,6
	COLTEXT	largeexplosion5_spr,6
	COLTEXT	largeexplosion6_spr,6
	COLTEXT	largeexplosion8_spr,6
	COLTEXT	smallexplosion2_spr,0
explode3_a1	db	8
	COLTEXT	smallexplosion1_spr,0
	COLTEXT	largeexplosion2_spr,6
	COLTEXT	largeexplosion3_spr,6
	COLTEXT	largeexplosion4_spr,6
	COLTEXT	largeexplosion5_spr,6
	COLTEXT	largeexplosion6_spr,6
	COLTEXT	largeexplosion8_spr,6
	COLTEXT	smallexplosion2_spr,0

tametame_c	COLANIM	tametame_a1
tametame_a1	db	4
	COLTEXT	tame1_spr,0
	COLTEXT	tame2_spr,0
	COLTEXT	tame3_spr,0
	COLTEXT	tame4_spr,0

tamatama_c	COLANIM	tamatama_a1
tamatama_a1	db	4
	COLTEXT	tame1_spr,0
	COLTEXT	tama2_spr,0
	COLTEXT	tame3_spr,0
	COLTEXT	tama4_spr,0

bullet_c	COLANIM	bullet_a1
ebullet_c	COLANIM	ebullet_a1

bullet_a1	db	8
	COLNORM	14,14
	COLNORM	8,8
	COLNORM	14,14
	COLNORM	7,7
	COLNORM	14,14
	COLNORM	8,8
	COLNORM	14,14
	COLNORM	6,6

Ebullet_a1	db	4
	COLNORM	$e,$e
	COLNORM	$3,$3
	COLNORM	$e,$e
	COLNORM	$4,$4



;*******************
;**** spt_0.cgx ****
;*******************
;------------
smoke_c	COLANIM	smoke_a1

smoke_a1	db	8
	COLTEXT	smoke1_spr
	COLTEXT	smoke2_spr
	COLTEXT	smoke3_spr
	COLTEXT	smoke4_spr
	COLTEXT	smoke5_spr
	COLTEXT	smoke6_spr
	COLTEXT	smoke7_spr
	COLTEXT	smoke8_spr
;------------
jet_c	COLANIM	jet_a1
jet_a1	db	4
	COLTEXT	boost1_spr
	COLTEXT	boost2_spr
	COLTEXT	boost3_spr
	COLTEXT	boost4_spr

;------------
boost_c	COLANIM	boost_a1
boost_a1	db	4
	COLTEXT	boost1_spr
	COLTEXT	boost2_spr
	COLTEXT	boost3_spr
	COLTEXT	boost4_spr
;------------
bossball_c	COLANIM	bossball_a1
bossball_a1	db	2
	COLTEXT	boost3_spr
	COLTEXT	boost4_spr
;------------
plasma1_c	COLANIM	plasma1_a1

plasma1_a1	db	2
	COLTEXT	plasma1_spr
	COLTEXT	plasma2_spr
;------------
splash_c	COLANIM	splash_a1
splash_a1	db	8
	COLTEXT	splash1_spr
	COLTEXT	splash2_spr
	COLTEXT	splash3_spr
	COLTEXT	splash4_spr
	COLTEXT	splash5_spr
	COLTEXT	splash6_spr
	COLTEXT	splash7_spr
	COLTEXT	splash8_spr
;------------
resupply_a1
	db	4
	COLTEXT	resupply1_spr,0
	COLTEXT	resupply2_spr,0
	COLTEXT	resupply3_spr,0
	COLTEXT	resupply3_spr,0
;------------


WHITEFONT_C
	COLNORM	14,14
	COLNORM	14,14
	COLNORM	14,14
	COLNORM	14,14

;*********************************************************************
;*			Soft Ware Sprite			*
;*********************************************************************
;*****************
;*** spt_1.cgx ***
;*****************
item_00_c	COLANIM	item_00_a1
item_00_a1	db	2
	COLTEXT	rechargeair1_spr
	COLTEXT	rechargeair2_spr
;------------
msplash_c	COLANIM	msplash_a1
msplash_a1	db	4
	COLTEXT	msplash1_spr
	COLTEXT	msplash2_spr
	COLTEXT	msplash3_spr
	COLTEXT	msplash4_spr
;------------
lava_a1	db	4
	COLTEXT	lava2_spr
	COLTEXT	lava1_spr
	COLTEXT	msplash2_spr
	COLTEXT	msplash3_spr
;------------
magmaball_c	COLANIM	magmaball_a1
magmaball_a1	db	2
	COLTEXT	magmaball1_spr
	COLTEXT	magmaball2_spr
;------------
wallflash_c	COLANIM	wallflash_a1
wallflash_a1	db	2
	COLTEXT	wallflash1_spr
	COLTEXT	wallflash2_spr
;------------
kirakira_c	COLANIM	kirakira_a1
kirakira_a1	db	2
	COLTEXT	kirakira1_spr
	COLTEXT	kirakira2_spr
;------------
meteo_c	COLTEXT	meteo_spr
;------------
meramera_c	COLANIM	meramera_a1
flame_c	COLANIM	meramera_a1
meramera_a1	db	2
	COLTEXT	meramera1_spr
	COLTEXT	meramera2_spr
;------------
charalabel_a1
	IFEQ	1
	db	6
	COLTEXT	fox_spr

	COLTEXT	falco_spr
	COLTEXT	peppy_spr
	COLTEXT	slippy_spr
	COLTEXT	lady_spr
	COLTEXT	robo_spr
	ENDC
;------------
bomb_c	COLANIM	bomb_a1
bomb_a1
	db	2
	COLTEXT	novabomb1_spr
	COLTEXT	novabomb3_spr
;------------
switch_a1
	db	4
	COLTEXT	switchon_spr
	COLTEXT	switchoff_spr
	COLTEXT	batsu_spr
	COLTEXT	maru_spr

;------------
dokuro_c	COLANIM	dokuro_a1
dokuro_a1	db	2
	COLTEXT	dokuro1_spr
	COLTEXT	dokuro2_spr
;-------------


;******************
;*** spt_2.cgx ****
;******************

;******************
;*** spt_3.cgx ****
;******************
ringlaser_c	COLANIM	rope_a1
;------------
kaifuku_a1
	db	2
	COLTEXT	help_spr
	COLTEXT	thanks_spr
;------------
rope_a1
	db	2
	COLTEXT	rope1_spr
	COLTEXT	rope2_spr
;------------
ryuusa_a1
	ifeq	1
	db	4
	COLTEXT	ryuusa1_spr
	COLTEXT	ryuusa2_spr
	COLTEXT	ryuusa3_spr
	COLTEXT	ryuusa4_spr
	endc
;------------
firemark_a1
	db	4
	COLTEXT	firemark1_spr
	COLTEXT	firemark2_spr
	COLTEXT	firemark3_spr
	COLTEXT	firemark4_spr
;------------
enemybomb_c	COLANIM	enemybomb_a1
enemybomb_a1
	db	2
	COLTEXT	enemybomb1_spr
	COLTEXT	enemybomb2_spr

;------------

bubble_c	COLANIM	bubble_a1
bubble_a1
	db	2
	COLTEXT	bubble1_spr
	COLTEXT	bubble2_spr
;------------
kusa_c	COLTEXT	kusa_spr
;------------
fire_c
	COLANIM	firemark_a1
;------------

wakame_c	COLANIM	wakame_a1
wakame_a1
	db	2
	COLTEXT	wakame1_spr
	COLTEXT	wakame2_spr
;------------
;******************
;*** spt_5.cgx ****
;******************
item_a1
	db	16
	COLTEXT	kakusan1_spr
	COLTEXT	kakusan2_spr
	COLTEXT	homing1_spr
	COLTEXT	homing2_spr
	COLTEXT	shield1_spr
	COLTEXT	shield2_spr
	COLTEXT	kakusan1_spr	;dummy
	COLTEXT	kakusan2_spr	;dummy
	COLTEXT	twin1_spr
	COLTEXT	twin2_spr
	COLTEXT	heart1_spr
	COLTEXT	heart2_spr
	COLTEXT	rechargeair1_spr
	COLTEXT	rechargeair2_spr
;---------------------------------
fieryfont_c
	COLTEXT	iwa1_ue_spr,0	; 110
	COLTEXT	iwa1_ue_spr,0	; 110
	COLTEXT	iwa0_ue_spr,0	; 108
	COLTEXT	iwa0_ue_spr,0	; 108
;---------------------------------
maskeye1_a1	db	8
	COLNORM	2,2
	COLNORM	3,3
	COLNORM	9,9
	COLNORM	9,9
	COLNORM	2,2
	COLNORM	3,3
	COLNORM	9,9
	COLNORM	9,9

maskeye2_a1	db	8
	COLNORM	2,2
	COLNORM	3,3
	COLNORM	2,2
	COLNORM	3,3
	COLNORM	9,9
	COLNORM	9,9
	COLNORM	9,9
	COLNORM	9,9
;---------------------------------
bigmeteo_c	COLTEXT	bigmeteo_spr,1
;---------------------------------
;---------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------

	incfile	ASM\defspr.asm

dbh	macro
	db	$\1,$\2,$\3,$\4,$\5,$\6,$\7,$\8
	endm

defshadestab	macro
	dw	shades\1_0&WM
	dw	shades\1_1&WM
	dw	shades\1_2&WM
	dw	shades\1_3&WM
	dw	shades\1_4&WM
	dw	shades\1_5&WM
	dw	shades\1_6&WM
	dw	shades\1_7&WM
	dw	shades\1_8&WM
	dw	shades\1_9&WM
	dw	shades\1_9&WM
	dw	shades\1_9&WM
;	dw	shades\1_a&WM
;	dw	shades\1_b&WM
	endm
;----------------------------------------------------------------------------
paladdr
	defgamepal	night,p_col.col,0,1
	defgamepal	marine,p_col.col,1,2
	defgamepal	magma,p_col.col,2,3
	defgamepal	mist,p_col.col,3,4
	defgamepal	sun,p_col.col,4,5
;;;;	defgamepal	title,p_col.col,5,6

	ifeq	1
palwood
	rgbw	0,0,0
gs	=	1			; wood
	rept	7
	rgbw	gs,gs,0
	rgbw	gs/2,gs/2,0
gs	=	gs+4
	endr
	rgbw	31,31,0
	endc
;
;;3D light source dither palette
;;(1)
;	ifeq	0		; THE WINNER
;
;	rgbw	0,0,0
;
;	rgbw	26,3,0		; reds
;	rgbw	16,2,0
;	rgbw	8,1,0
;
;;	rgbw	8,8,0		; yellows
;	rgbw	18,16,0
;	rgbw	26,26,0
;
;	rgbw	6,20,0		; greens
;	rgbw	2,12,0
;;	rgbw	0,8,0
;
;	rgbw	0,10,26		; blues
;	rgbw	0,4,16
;	rgbw	0,0,8
;
;	rgbw	3,3,3		; greys
;	rgbw	6,6,6
;	rgbw	10,10,10
;	rgbw	14,14,14
;	rgbw	20,20,20
;
;	endc

;Nintendo 3d pal  -----------------------------------------------

	IFEQ	1
	rgbw	0,0,0
	rgbw	$14,0,0
	rgbw	$1c,4,4
	rgbw	$1f,$c,$c
	rgbw	$3,$9,$19
	rgbw	$8,$e,$1e
	rgbw	$d,$13,$1f
	rgbw	$00,$1f,$6
	rgbw	$1f,$1f,$0a
	rgbw	4,4,4
	rgbw	9,9,9
	rgbw	$e,$e,$e
	rgbw	$14,$14,$14
	rgbw	$19,$19,$19
	rgbw	$1f,$1f,$1f
	rgbw	0,0,0
	ENDC


paladdrend

numpals	equ	(paladdrend-paladdr)>>5

shadestab2_0
	defshadestab	0
shadestab2_1
	defshadestab	1
shadestab2_2
	defshadestab	2
shadestab2_3
	defshadestab	3



depthtabs
; the actual colour values for the depth tabs
	incfile	ASM\coltab.asm

	incfile	ASM\light.asm

;------------------------------------------------------
def_depthz	macro	[name,1,2,3,4]

	db	-{1}/256,-{2}/256,-{3}/256,0
depth_{name}	equ	dn
dn	=	dn+1
	endm

def_depthz_same	macro	[name,1]
	IFEQ	{1}-1
	db	-$40,-$50,-$50,0
	ELSEIF
	IFEQ	{1}-2
	db	0,-$40,-$50,0
	ELSEIF
	IFEQ	{1}-3
	db	0,0,-$40,0
	ELSEIF
	IFEQ	{1}-4
	db	0,0,0,0
	ELSEIF
	progress_off
	printf	"def_depthz_same.... values 1-4 only are accepted%n"
	progress_on
	ENDC
	ENDC
	ENDC
	ENDC

depth_{name}	=	dn
dn	=	dn+1

	endm

dn	=	0
;------------------------------------------------------
depthtables
; the actual z distance values for depths

	def_depthz_same	1,1
	def_depthz_same	2,2
	def_depthz_same	3,3
	def_depthz_same	4,4
	def_depthz	normal,$a00,$d00,$f00
	def_depthz	ground,1300,1800,2000
	def_depthz	mist,1536,2048,2560
	def_depthz	sky,1536,2048,2560
	def_depthz	marine,1536,2048,2560
	def_depthz	space,8000,10000,12000
;;	def_depthz	space,5500,7000,8000
;;;	def_depthz	space,2200,2700,3200
	def_depthz	tunnel,500,750,1000
	def_depthz	tutu,1800,2000,3000
	def_depthz	explain,30000,31000,32000
	def_depthz	large,3500,3600,3700








