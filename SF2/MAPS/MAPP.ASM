
mapp

	mapobj	0,400,-150,0000,nullshape,EXplayer_Istrat
	start_65816

	test_screenmode	onescreen
	beq		.continue
	switch		.noplayer2
.continue

	IFEQ	1
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ENDC

	end_65816

	mapobj	0,200,-50,0000,nullshape,EXplayer2_Istrat
;	setalvar	roty,deg180
.noplayer2
	mapend



