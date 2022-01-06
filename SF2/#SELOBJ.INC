ram Start *
	lda	#MMakePlanet>>16
	sta.l	mcodebank
	a16
	lda	#MMakePlanet&WM
	sta.l	mr15	; GO!
	a8
;* Mario Wait *
	km_waitmario
	endc

mm_blink
	a8
	kbug1
	blink	3
;*********************************************************************
;*********************************************************************

;*		Not Using Area			*

;*********************************************************************
;*********************************************************************



;*********************************************************************
;*								*
;*		Step Up Enemy Appear				*
;* Data Bank :7e							*
;*********************************************************************
	IFEQ	1
neutralcnt	equ	kz_x1
;-------------------------------------------------
mm_StepUpEnemyAppear
	shorta
	longi
	php
	lda	kx_stepupstock
	bne	.skip			;StepUp no zaico nashi

;* Enemy Stock = 0 *
	lda	kx_neutralplanetkazu
	clc
	adc	kx_clearplanetkazu
	cmp	kx_missionplanetkazu
	bne	.jmp_end

;* Mission Map CLear *
	km_setmismapflag	missionallclear
.jmp_end
	brl	.end
;* step up enemy appear Wait *
.skip
	lda	kx_stepupappeartm	;Appear Wait
	beq	.WaitEnd
	dec	a
	sta	kx_stepupappeartm
	brl	.end
;--------------------------------------------------------------------
.WaitEnd
	shorta
	lda	kx_stepupdemoptr
	beq	.normal_check
	cmp	#stupdm_demoend
	km_beq	.SetParams
	cmp	#stupdm_initial
	km_beq	.initial
	brl	.end
;--------------------------------------------------------------------
.initial
	km_setmismapstflag	stepupdemo	
	km_setval	kx_stepupdemoptr,stupdm_open
	brl	.end
;--------------------------------------------------------------------
.normal_check
;* enemy total no kazu >= 8 *
	shorta
	km_cmpcheck	kx_enemytotal,mm_enemymax	;(kalcs.inc)
	km_bpl	.end

;* Neutral no  hoshi no kazu wo Check *
	shorta
	lda	kx_neutralplanetkazu
	km_beq	.end
	dec	a
	beq	.neutral1	;neutral no kazu = 1
	bra	.check_stupkazu	;neutral no kazu >= 2

;* clear planet no kazu = planet no kazu-1 ka CHECK *
.neutral1
	shorta
	lda	kx_missionplanetkazu
	dec	a
	cmp	kx_clearplanetkazu
	km_bne	.end

;* neutral no kazu > stepup no kazu *
.check_stupkazu
	shorta
	lda	kx_neutralplanetkazu
	cmp	kx_stepuptotal
	km_beq	.end	;neutral no kazu = stepup no kazu
	km_bmi	.end	;neutral no kazu < stepup no kazu

;* neutral planet search *
.search_neutral
	a16
	ldx	kx_planetlistptr
.loop
	cpx	kx_corneriaptr
	km_beq	.end

	km_bitcheckflag.w	mmx_planetflag,mmpnf_neutral,x
	bne	.found_neutral
.nextplanet
	lda.w	mmx_planetnext,x
	tax
	bne	.loop
	brl	.end

;**** Sono Mokuteki no Planet ni sudeni StepUp Enemy ga mukatte iruka CHECK ****
;Xreg :Planet List Pointer
;Yreg :Enemy  List Pointer
.found_neutral
	longa
	ldy	kx_enlistptr
.loop2
	km_bitcheckflag.w	mmx_enflags,enfl_stepup,y
	beq	.nextenlist
.stepupenemy
	txa
	cmp.w	mmx_endestplanetptr,y
	beq	.nextplanet

.nextenlist
	lda.w	mmx_ennext,y
	beq	.search_end
	tay
	bne	.loop2
.search_end	;mokuteki Planet ni mukatteiru SteuUp Enemy nashi
	stx	kx_stepupdestptr

;* Mission Map ka Game tyuu ka Check *
	a8
	km_bitcheckmismapflag	missionstart
	km_bne	.SetParams

	km_setval	kx_stepupdemoptr,stupdm_initial
	km_setval	kx_stepupappeartm,5*8
	brl	.end
;-------------------------------------------------------------
;*		Enemy no Params Set			*
;-------------------------------------------------------------
.SetParams
;* step up no stock wo 1tu hrasu *
	a8
	dec	kx_stepupstock
	dec	kx_neutralplanetkazu
	inc	kx_stepuptotal
	
	a16
	km_setval	kx_stepupdemoptr,0
	km_clrmismapstflag	stepupdemo	

;* Enemy List P