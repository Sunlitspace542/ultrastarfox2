
sprbank	macro
	defs	$1,"\1"
cpa	=	0
	endm

cps	=	0

defspr	macro
\1_spr	=	cps
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+1
	endm

defspr_hi	macro
\1_spr	=	cps!(1<<7)
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+1
	endm


defsprabs	macro	[name,x,y]
{name}_spr	=	cps
	dw	(\$1+(({x})*8)+(256*8*({y})))&$ffff
	db	(\$1+(({x})*8)+(256*8*({y})))>>16
cps	=	cps+1
	endm

defsprabs_hi	macro	[name,x,y]
{name}_spr	=	cps!(1<<7)
	dw	(\$1+(({x})*8)+(256*8*({y})))&$ffff
	db	(\$1+(({x})*8)+(256*8*({y})))>>16
cps	=	cps+1
	endm

defsprdoub	macro
\1_spr	=	cps
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+2
	endm

defspr64	macro
\1_spr	=	cps
	dw	(\$1+((cpa&3)*64)+(256*64*((cpa&15)/4)))&$ffff
	db	(\$1+((cpa&3)*64)+(256*64*((cpa&15)/4)))>>16
cpa	=	cpa+1
cps	=	cps+1
	endm

defspr64_hi	macro
\1_spr	=	cps!(1<<7)
	dw	(\$1+((cpa&3)*64)+(256*64*((cpa&15)/4)))&$ffff
	db	(\$1+((cpa&3)*64)+(256*64*((cpa&15)/4)))>>16
cpa	=	cpa+1
cps	=	cps+1
	endm

defsprdoub_hi	macro
\1_spr	=	cps!(1<<7)
	dw	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))&$ffff
	db	(\$1+((cpa&7)*32)+(256*32*((cpa&31)/8)))>>16
cps	=	cps+1
cpa	=	cpa+2
	endm

;------------------------------------------------------------------------
textureaddrtab
	sprbank	msprites1
;spt_0.cgx
	defsprabs	smoke1,0,0	;0
	defsprabs	smoke2,4,0	;1
	defsprabs	smoke3,8,0	;2
	defsprabs	smoke4,12,0	;3
	defsprabs	smoke5,16,0	;4
	defsprabs	smoke6,20,0	;5
	defsprabs	smoke7,24,0	;6
	defsprabs	smoke8,28,0	;7

	defsprabs	splash1,0,4	;8
	defsprabs	splash2,4,4	;9
	defsprabs	splash3,8,4	;10
	defsprabs	splash4,12,4	;11
	defsprabs	splash5,16,4	;12
	defsprabs	splash6,20,4	;13
	defsprabs	splash7,24,4	;14
	defsprabs	splash8,28,4	;15

	defsprabs	boost1,0,8	;16
	defsprabs	boost2,4,8	;17
	defsprabs	boost3,8,8	;18
	defsprabs	boost4,12,8	;19
	defsprabs	lava1,16,8	;20
	defsprabs	lava2,20,8	;21
	defsprabs	resupply1,24,8	;22
	defsprabs	resupply2,28,8	;23

	defsprabs	resupply3,0,12		;24
	defsprabs	novabomb1,4,12		;25
	defsprabs	homing1,8,12
	defsprabs	novabomb3,12,12		;27
	defsprabs	smallexplosion1,16,12	;28
	defsprabs	smallexplosion2,20,12	;29
	defsprabs	plasma1,24,12		;30
	defsprabs	plasma2,28,12		;31
;------------------------------------------------------------------------
; 64x64 sprite
	sprbank	msprites2
;spt_2.cgx
	defsprabs	tame1,0,0
	defsprabs	tame2,4,0
	defsprabs	largeexplosion2,08,0
	defsprabs	largeexplosion3,16,0
	defsprabs	largeexplosion4,24,0

	defsprabs	tame3,0,4
	defsprabs	tame4,4,4

	defsprabs	largeexplosion5,00,8
	defsprabs	largeexplosion6,08,8
	defsprabs	tama2,16,8
	defsprabs	tama4,20,8
	defsprabs	kakomu1,16,12
	defsprabs	kakomu2,20,12
	defsprabs	largeexplosion8,24,8
;------------------------------------------------------------------------
;spt_4.cgx
	sprbank	msprites3

	defsprabs	fox1,0,0
	defsprabs	fox2,4,0
	defsprabs	falco1,8,0
	defsprabs	falco2,12,0
	defsprabs	msgopening1,16,0
	defsprabs	msgopening2,20,0
	defsprabs	msgopening3,24,0
	defsprabs	msgopening4,28,0

	defsprabs	peppy1,0,5
	defsprabs	peppy2,4,5
	defsprabs	slippy1,8,5
	defsprabs	slippy2,12,5
	defsprabs	enemydata,16,5
	defsprabs	pepper1,20,5
	defsprabs	pepper2,24,5
	defsprabs	andross1,28,5

	defsprabs	pony1,0,10
	defsprabs	pony2,4,10
	defsprabs	girl1,8,10
	defsprabs	girl2,12,10
	defsprabs	andross2,16,10
	defsprabs	pepper3,20,10
	defsprabs	pepper4,24,10
	defsprabs	explain,28,10



;------------------------------------------------------------------------
;  *       *	      *
; ***     ***     ***
; ***     ***     ***    ALL 'hi' definitions should follow this
; ***     ***     ***   
; ***     ***     ***
; ***     ***     ***
;  *       *	      *
;
;  *       *	      *
; ***     ***     ***
;  *       *	      *
;------------------------------------------------------------------------

	IFNE	cps-128		; PAD OUT THE TABLE
	REPT	128-cps
	dw	0
	db	0
	ENDR
	ENDC

cps	=	128
;------------------------------------------------------------------------
	sprbank	msprites1
;spt_1.cgx
	defsprabs_hi	iwa0_ue,0,0		;0
	defsprabs_hi	iwa0_yoko,4,0		;1
	defsprabs_hi	rechargeair1,8,0	;2
	defsprabs_hi	rechargeair2,12,0	;3
	defsprabs_hi	iwa1_ue,16,0		;4
	defsprabs_hi	iwa1_yoko,20,0		;5
	defsprabs_hi	meramera1,24,0		;6
	defsprabs_hi	meramera2,28,0		;7

	defsprabs_hi	tank,0,4	;0
	defsprabs_hi	container,4,4	;1
	defsprabs_hi	eye,8,4	        ;2
	defsprabs_hi	way,12,4	;3
	defsprabs_hi	magmaball1,16,4	;4
	defsprabs_hi	wallflash1,20,4	;5
	defsprabs_hi	wallflash2,24,4	;6
	defsprabs_hi	magmaball2,28,4	;7

	defsprabs_hi	dokuro1,0,8	;0
	defsprabs_hi	dokuro2,4,8	;1
	defsprabs_hi	msplash1,8,8	;2
	defsprabs_hi	msplash2,12,8	;3
	defsprabs_hi	msplash3,16,8	;4
	defsprabs_hi	msplash4,20,8	;5
	defsprabs_hi	kirakira1,24,8	;6
	defsprabs_hi	kirakira2,28,8	;7

	defsprabs_hi	meteo,0,12		;0
	defsprabs_hi	core,4,12		;1
	defsprabs_hi	miss,8,12		;2
	defsprabs_hi	maru,12,12		;3
	defsprabs_hi	batsu,16,12		;4
	defsprabs_hi	switchon,20,12		;5
	defsprabs_hi	switchoff,24,12		;6
	defsprabs_hi	kikai,28,12		;7

	sprbank	msprites2
;spt_3.cgx

;label,x,y
	defsprabs_hi	sfmark,0,0	;(label,x,y)
	defsprabs_hi	homing2,16,0
	defsprabs_hi	kinoko0,20,0
	defsprabs_hi	firemark1,24,0
	defsprabs_hi	firemark2,28,0

	defsprabs_hi	firemark3,0,04
	defsprabs_hi	firemark4,4,04
	defsprabs_hi	takoashi,8,04
	defsprabs_hi	enemybomb1,12,04
	defsprabs_hi	andorossbox1,16,04
	defsprabs_hi	enemybomb2,24,04
	defsprabs_hi	rope1,28,04

	defsprabs_hi	rope2,00,08
	defsprabs_hi	kusa,04,08
	defsprabs_hi	wakame1,08,08
	defsprabs_hi	wakame2,12,08
	defsprabs_hi	bubble1,24,08
	defsprabs_hi	bubble2,28,08

	defsprabs_hi	kinoko2,00,12
	defsprabs_hi	inumark,4,12
	defsprabs_hi	sarumark,8,12
	defsprabs_hi	flower1,12,12
	defsprabs_hi	flower2,16,12
	defsprabs_hi	help,20,12
	defsprabs_hi	thanks,24,12
	defsprabs_hi	kinoko1,28,12
;------------------------------------------------------------------------
;spt_5.cgx
	sprbank	msprites3

	defsprabs_hi	wolfdead,0,0
	defsprabs_hi	wolf1,4,0
	defsprabs_hi	wolf2,8,0
	defsprabs_hi	pig1,12,0
	defsprabs_hi	kakusan1,16,0
	defsprabs_hi	kakusan2,20,0
	defsprabs_hi	twin1,24,0
	defsprabs_hi	twin2,28,0

	defsprabs_hi	pig2,0,5
	defsprabs_hi	monkey1,4,5
	defsprabs_hi	monkey2,8,5
	defsprabs_hi	chameleon1,12,5
	defsprabs_hi	shield1,16,4
	defsprabs_hi	shield2,20,4
	defsprabs_hi	heart1,24,4
	defsprabs_hi	heart2,28,4

	defsprabs_hi	chameleon2,0,10
	defsprabs_hi	pigdead,4,10
	defsprabs_hi	monkeydead,8,10
	defsprabs_hi	chameleondead,12,10

	defsprabs_hi	titlechar1,16,7
	defsprabs_hi	titlechar2,20,7
	defsprabs_hi	titlechar3,16,11
	defsprabs_hi	titlechar4,20,11
	defsprabs_hi	bigmeteo,24,8

	IFEQ	1
	defsprabs_hi	planet4,8,4
	defsprabs_hi	planet6,0,8
	defsprabs_hi	shadow,8,8
	defsprabs_hi	corneria,16,8

	defsprabs_hi	p_1up1,24,0
	defsprabs_hi	p_1up2,28,0
	defsprabs_hi	dummy1,24,4
	defsprabs_hi	dummy2,28,4
	ENDC
;------------------------------------------------------------------------
texturexytab
	dw	texturexy0&WM
	dw	texturexy1&WM
	dw	texturexy2&WM
	dw	texturexy3&WM
	dw	texturexy4&WM
	dw	texturexy5&WM
	dw	texturexy6&WM
	dw	texturexy7&WM
	dw	texturexy8&WM
	dw	texturexy9&WM
	dw	texturexy10&WM
	dw	texturexy11&WM


texturexy0
	db	31,31
	db	31,0
	db	0,0
	db	0,31
	db	31,31

texturexy1
	db	63,63
	db	63,0
	db	0,0
	db	0,63
	db	63,63

texturexy2
	db	63,31
	db	0,31
	db	63,31
	db	63,0
	db	0,0

texturexy3
	db	31,63
	db	0,0
	db	31,0
	db	31,63
	db	0,63

texturexy4
	db	31,127
	db	0,0
	db	31,0
	db	31,127
	db	0,127

texturexy5
	db	127,31
	db	127,0
	db	0,0
	db	0,31
	db	127,31

texturexy6
	dw	$3f3f
	db	0,0
	db	63,0
	db	63,63
	db	0,63

texturexy7
	db	31,31
	db	0,0
	db	31,0
	db	31,31
	db	0,31

texturexy8	dw	$1f1f
	db	31,0
	db	0,0
	db	0,31
	db	31,31

texturexy9	db	31,63
	db	0,0
	db	31,0
	db	31,39
	db	0,39

texturexy10	db	31,31
	db	0,0
	db	127,0	;63,0	;31,0	;127,0
	db	127,127	;63,63	;31,127	;127,127
	db	0,127	;0,63	;0,127	;0,127

texturexy11
	db	15,7
	db	31,0
	db	0,0
	db	0,7
	db	31,7


