; ******************************************************************
; ***
; *** Crunched palette definitions:
; *** (included from within alcs.inc)
; ***
; ******************************************************************

;--------------------------------------------------------------
defpac	macro
	IFND	__totpallen
__totpallen	=	0
	ENDC

\1	equ	$700000+palettes_base+__totpallen
__totpallen	=	__totpallen+(\2*32)
	endm
;--------------------------------------------------------------

	defpac	col_1_pac,4
	defpac	col_2_pac,4
	defpac	a0_pac,3
	defpac	a1_pac,3
	defpac	a2_pac,3
	defpac	a3_pac,3
	defpac	a4_pac,3
	defpac	a5_pac,3
	defpac	a6_pac,3
	defpac	a7_pac,3
	defpac	a8_pac,3
	defpac	a9_pac,2
	defpac	a11_pac,2
	defpac	a12_pac,3
	defpac	a13_pac,3
	defpac	a14_pac,3
	defpac	a15_pac,3
	defpac	a16_pac,2
	defpac	a17_pac,3
	defpac	a18_pac,3
	defpac	a19_pac,3
	defpac	a20_pac,3
	defpac	a21_pac,3
	defpac	a22_pac,3
	defpac	a23_pac,2
	defpac	a24_pac,2
	defpac	a25_pac,2
	defpac	a26_pac,2
	defpac	a27_pac,2
	defpac	a28_pac,2
	defpac	a29_pac,3
	defpac	a30_pac,3
	defpac	a31_pac,3

	defpac	b0_pac,16
	defpac	b1_pac,16
	defpac	b2_pac,16
	defpac	b3_pac,6
	defpac	b5_pac,16
	defpac	b7_pac,16
	defpac	b8_pac,16
	defpac	b9_pac,16
	defpac	b10_pac,8
	defpac	b11_pac,8
	defpac	b15_pac,8
	defpac	b16_pac,16

	defpac	c0_pac,16
	defpac	c1_pac,16

	defpac	w0_pac,8
	defpac	yaji_0_pac,4

;	defpac	a10_pac,3
;	defpac	c2_pac,16
;	defpac	b14_pac,16
;	defpac	c3_pac,16
;	defpac	c4_pac,16
;	defpac	c5_pac,16
;	defpac	test3d_pac,8
;	defpac	tm3_pac,3
;	defpac	rdfl_pac,12
;	defpac	tcol1_pac,16
;	defpac	tcol2_pac,16
;	defpac	tcol3_pac,16
