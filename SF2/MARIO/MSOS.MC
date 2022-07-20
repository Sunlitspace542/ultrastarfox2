;*********************************************************************
;*								*
;*	------------------------				*
;*		STARFOX 2					*
;*	------------------------				*
;*								*
;*	File 		: mytest.mc				*
;* 	Description	; mariochip yajima test			*
;*			;					*
;*	Date		: 1994.9.21				*
;*	Author		: H.Yajima				*
;*								*
;*********************************************************************
;
;
;
;
;
;
;
;------------------------------------------------------------------------
;grph_parameter	equ	m_dotpolygon
;temp_parameter	equ	m_dotpolygon
;------------------------------------------------------------------------
;;; <<<<< filling >>>>>
;	zmalc	m_ret,2
;	zmalc	return_address,2	
;	zmalc	point_counter,2		
;	zmalc	bottom_index,4		
;	zmalc	left_ex,2		
;	zmalc	right_ex,2		
;------------------------------------------------------------------------

;
;
;
;
;
;
;*********************************************************************
;
;*********************************************************************


mariotest

	MsetRAMB 0
	MsetROMB mariotest>>16
	Msetcolor 0fh

	Mtestline	20,20,100,20

;;	iwt	r1,#m_grph_parameter&xx
	iwt	r1,#0

	MsetdataB r1,3
	MsetdataB r1,20 ;x1
	MsetdataB r1,20 ;y1
	MsetdataB r1,80 ;x2
	MsetdataB r1,20 ;y2
	MsetdataB r1,20 ;x3
	MsetdataB r1,80 ;y3

	sm	[m_return_address],r10

	Mstoploop


	Mjsr	PolygonFilling



	rpix
	stop
	nop






;************************************************************************
;;wk_divisor	=	2
;;	rept	256-2
;;	dw	65536/wk_divisor
;;wk_divisor	=	wk_divisor + 1
;;	endr
;************************************************************************
;	division table
;************************************************************************

UDivTable	
	dw	0ffffh
	dw	0ffffh
	dw	32768
	dw	21845
	dw	16384
	dw	13107
	dw	10922
	dw	9362
	dw	8192
	dw	7281
	dw	6553
	dw	5957
	dw	5461
	dw	5041
	dw	4681
	dw	4369
	dw	4096
	dw	3855
	dw	3640
	dw	3449
	dw	3276
	dw	3120
	dw	2978
	dw	2849
	dw	2730
	dw	2621
	dw	2520
	dw	2427
	dw	2340
	dw	2259
	dw	2184
	dw	2114
	dw	2048
	dw	1985
	dw	1927
	dw	1872
	dw	1820
	dw	1771
	dw	1724
	dw	1680
	dw	1638
	dw	1598
	dw	1560
	dw	1524
	dw	1489
	dw	1456
	dw	1424
	dw	1394
	dw	1365
	dw	1337
	dw	1310
	dw	1285
	dw	1260
	dw	1236
	dw	1213
	dw	1191
	dw	1170
	dw	1149
	dw	1129
	dw	1110
	dw	1092
	dw	1074
	dw	1057
	dw	1040
	dw	1024
	dw	1008
	dw	992
	dw	978
	dw	963
	dw	949
	dw	936
	dw	923
	dw	910
	dw	897
	dw	885
	dw	873
	dw	862
	dw	851
	dw	840
	dw	829
	dw	819
	dw	809
	dw	799
	dw	789
	dw	780
	dw	771
	dw	762
	dw	753
	dw	744
	dw	736
	dw	728
	dw	720
	dw	712
	dw	704
	dw	697
	dw	689
	dw	682
	dw	675
	dw	668
	dw	661
	dw	655
	dw	648
	dw	642
	dw	636
	dw	630
	dw	624
	dw	618
	dw	612
	dw	606
	dw	601
	dw	595
	dw	590
	dw	585
	dw	579
	dw	574
	dw	569
	dw	564
	dw	560
	dw	555
	dw	550
	dw	546
	dw	541
	dw	537
	dw	532
	dw	528
	dw	524
	dw	520
	dw	516
	dw	512
	dw	508
	dw	504
	dw	500
	dw	496
	dw	492
	dw	489
	dw	485
	dw	481
	dw	478
	dw	474
	dw	471
	dw	468
	dw	464
	dw	461
	dw	458
	dw	455
	dw	451
	dw	448
	dw	445
	dw	442
	dw	439
	dw	436
	dw	434
	dw	431
	dw	428
	dw	425
	dw	422
	dw	420
	dw	417
	dw	414
	dw	412
	dw	409
	dw	407
	dw	404
	dw	402
	dw	399
	dw	397
	dw	394
	dw	392
	dw	390
	dw	387
	dw	385
	dw	383
	dw	381
	dw	378
	dw	376
	dw	374
	dw	372
	dw	370
	dw	368
	dw	366
	dw	364
	dw	362
	dw	360
	dw	358
	dw	356
	dw	354
	dw	352
	dw	350
	dw	348
	dw	346
	dw	344
	dw	343
	dw	341
	dw	339
	dw	337
	dw	336
	dw	334
	dw	332
	dw	330
	dw	329
	dw	327
	dw	326
	dw	324
	dw	322
	dw	321
	dw	319
	dw	318
	dw	316
	dw	315
	dw	313
	dw	312
	dw	310
	dw	309
	dw	307
	dw	306
	dw	304
	dw	303
	dw	302
	dw	300
	dw	299
	dw	297
	dw	296
	dw	295
	dw	293
	dw	292
	dw	291
	dw	289
	dw	288
	dw	287
	dw	286
	dw	284
	dw	283
	dw	282
	dw	281
	dw	280
	dw	278
	dw	277
	dw	276
	dw	275
	dw	274
	dw	273
	dw	271
	dw	270
	dw	269
	dw	268
	dw	267
	dw	266
	dw	265
	dw	264
	dw	263
	dw	262
	dw	261
	dw	260
	dw	259
	dw	258
	dw	257

;=====================================================================



;*********************************************************************
;	local macros
;*********************************************************************

;
;
;
;
;
;
;
;
;*********************************************************************
;
;	POLYGON FILLING
;
;*********************************************************************



;*********************************************************************
;	Polyygon Filling
;*********************************************************************

PolygonFilling


	Mstoploop


	ibt	r0,#UDivTable>>16
	romb

;=============== Check minimum y position ===============================

PolygonFilling2 



;;;	iwt	r0,#m_grph_parameter
	sub	r0
	ldb	[r0]		
	sm	[m_point_counter],r0	
;------------------------------------------------------------------------
	to	r3
	add	r0		
	sm	[m_bottom_index],r3
	move	r6,r3		
	to	r2
	ldb	[r3]		
	cache
;------------------------------------------------------------------------
PolygonFill_11	
	dec	r3
PolygonFill_12	
	dec	r3		
	beq	PolygonFill_20	
	nop
	ldb	[r3]		
	cmp	r2		
	bcs	PolygonFill_11	
	nop
;------------------------------------------------------------------------

	move	r6,r3		
	move	r2,r0		
	bra	PolygonFill_12
	dec	r3


PolygonFill_20
	move	r10,r6
	dec	r6
	to	r3
	ldb	[r6]
	move	r7,r3
	inc	r6
;------------------------------------------------------------------------

	Mstoploop

;************************************************************************
;************************************************************************

	cache
	link	#3
	XXiwt	r15,#SetLeftParam
	inc	r5		
	link	#3
	XXiwt	r15,#SetRightParam
	inc	r9		

;************************************************************************
;************************************************************************

PlotScanLine	from	r3
	to	r1
	hib			
	from	r7
	hib			
	to	r12
	sub	r1		
	bmi	PlotScanLine_2	
	inc	r12		
	move	r13,r15
;------------------------------------------------------------------------
PlotSCanLine_1	loop
	plot			
	bra	CheckNextLine
	nop
;------------------------------------------------------------------------
PlotScanLine_2	to	r12
	from	r1
	sub	r0		
	move	r1,r0
	inc	r12		
	move	r13,r15
;------------------------------------------------------------------------
	loop
	plot			

;************************************************************************
;************************************************************************

CheckNextLine	
	dec	r5		
	bne	CheckNextLine_2	
	nop
;------------------------------------------------------------------------
	lm	r3,[m_left_ex]	
	link	#4
	XXiwt	r15,#SetLeftParam
	nop
;------------------------------------------------------------------------
CheckNextLine_2 
	dec	r9		
	bne	CalcNextLine	
	nop
;------------------------------------------------------------------------
	lm	r7,[m_right_ex]	
	link	#4
	XXiwt	r15,#SetRightParam
	nop


CalcNextLine	with	r3
	add	r4		
	with	r7
	add	r8		
	XXiwt	r15,#PlotScanLine
	inc	r2		

;************************************************************************
;************************************************************************

SetLeftParam	
	lm	r0,[m_point_counter]
	dec	r0		
	bpl	SetLeftParam10
	sbk
;------------------------------------------------------------------------
SetLeftAbort	
	lm	r15,[m_return_address]	
	nop


SetLeftParam10	
	dec	r6
	dec	r6		
	bne	SetLeftParam11
	nop			
	lm	r6,[m_bottom_index]	
;------------------------------------------------------------------------
SetLeftParam11
	ldb	[r6]
	to	r5
	sub	r2		
	bcc	SetLeftParam12	
	nop
	bne	SetLeftParam13	
	nop


SetLeftParam12	dec	r6
	to	r3
	ldb	[r6]		
	bra	SetLeftParam	
	inc	r6


SetLeftParam13	
	dec	r6
	ldb	[r6]		
	inc	r6
	sm	[m_left_ex],r0	

;************************************************************************
;************************************************************************

SetLeftParam20
	from	r5
	to	r13
	add	r5		
	XXiwt	r12,#UDivTable
	from	r13
	to	r14
	add	r12		
;------------------------------------------------------------------------
SetLeftParam21
	ibt	r13,#0
	to	r12
	sub	r3		
	bcs	SetLeftParam22
	nop
	dec	r13
	with	r12
	not
	inc	r12
;------------------------------------------------------------------------
SetLeftParam22	
	getb			
	inc	r14
	umult	r12		
	to	r1
	hib			
	getb			
	umult	r12
	inc	r13
	bne	SetLeftParam23
	add	r1
	not
	inc	r0
;------------------------------------------------------------------------
SetLeftParam23
	move	r4,r0
	with	r3
	swap

;;;;	lm	r0,[clippingPointY]	
	ibt	r0,#$7F

	to	r3
	or	r3
	jmp	r11
	nop

;************************************************************************
;************************************************************************

SetRightParam	
	lm	r0,[m_point_counter]
	dec	r0		
	bpl	SetRightParam10
	sbk
;------------------------------------------------------------------------
SetRightAbort	
	lm	r15,[m_return_address]	
	nop

;************************************************************************
;************************************************************************

SetRightParam10 
	lm	r0,[m_bottom_index]
	inc	r10
	inc	r10		
	cmp	r10
	bcs	SetRightParam11
	nop			
	ibt	r10,#2		


SetRightParam11 
	ldb	[r10]		
	to	r9
	sub	r2		
	bcc	SetRightParam12	
	nop
	bne	SetRightParam13	
	nop


SetRightParam12 
	dec	r10
	to	r7
	ldb	[r10]		
	bra	SetRightParam	
	inc	r10


SetRightParam13 
	dec	r10
	ldb	[r10]		
	inc	r10
	sm	[m_right_ex],r0	

;************************************************************************
;************************************************************************

SetRightParam20 
	from	r9
	to	r13
	add	r9		
	XXiwt	r12,#UDivTable
	from	r13
	to	r14
	add	r12		
;------------------------------------------------------------------------
SetRightParam21 
	ibt	r13,#0
	to	r12
	sub	r7		
	bcs	SetRightParam22
	nop
	dec	r13
	with	r12
	not
	inc	r12
;------------------------------------------------------------------------
SetRightParam22 
	getb			
	inc	r14
	umult	r12		
	to	r1
	hib			
	getb			
	umult	r12
	inc	r13
	bne	SetRightParam23
	add	r1
	not
	inc	r0
;------------------------------------------------------------------------
SetRightParam23 
	move	r8,r0
	with	r7
	swap

;;;;	lm	r0,[clippingPointY]	
	ibt	r0,#$7F

	to	r7
	or	r7
	jmp	r11
	nop







;=====================================================================
;=====================================================================
;=====================================================================
; END END END END END END END END END END END END END END END END END
;=====================================================================
;=====================================================================

