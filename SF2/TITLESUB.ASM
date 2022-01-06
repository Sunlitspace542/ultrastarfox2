;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         TITLESUB.ASM                                        ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  Title Screen Sub Routine                            ;
; DATE CREATED: 10-3-93                                             ;
;                                                                   ;
;-------------------------------------------------------------------;
	INCPUB	titlesub

;--------------------------------------------------------------------
printbinary_l
	jsr	printbinary
	rtl
;--------------------------------------------------------------------
VRAMClear_l
	jsr	VRAMClear
	rtl
;--------------------------------------------------------------------
Check_triggerUD_l
	jsr	Check_triggerUD
	rtl
;--------------------------------------------------------------------
Check_triggerLR_l
	jsr	Check_triggerLR
	rtl
;--------------------------------------------------------------------
autotrigger_l
	jsr	autotrigger
	rtl
;--------------------------------------------------------------------
Check_autotrig_l
	jsr	Check_autotrig
	rtl
;--------------------------------------------------------------------
Check_autotrigUD_l
	jsr	Check_autotrigUD
	rtl
;--------------------------------------------------------------------
Check_autotrigLR_l
	jsr	Check_autotrigLR
	rtl
;--------------------------------------------------------------------
Check_updwkey_l
	jsr	Check_updwkey
	rtl
;--------------------------------------------------------------------
Check_LRkey_l
	jsr	Check_LRkey
	rtl
;--------------------------------------------------------------------
mozaikufadeout_l
	jsr	mozaikufadeout
	rtl
;--------------------------------------------------------------------
mozaikufadein_l
	jsr	mozaikufadein
	rtl
;--------------------------------------------------------------------
;--------------------------------------------------------------------

;=====================================================================
;*			Print Binary Mode			*
;* Mem8,Idx16							*
;* Init Acc:value , Xreg:set postion					*
;=====================================================================
printbinary
	shorta
	longi
	phb
	km_db7e

	sta	kwork
	lda	#8
	sta	kwork+1
.loop
;(X,Y)
	a16
	txa
	km_SetSprite
	a8
;(character)
	asl	kwork
	bcs	.one
.zero
	lda	#0
	bra	.SetChar
.one
	lda	#1
.SetChar
	km_SetSpriteChrA	0,colpal0,pri3,noflip

	dec	kwork+1
	beq	.end
	a16
	txa
	clc
	adc	#8
	tax
	a8
	bra	.loop
.end
	plb
	rts

;=====================================================================
;*			VRAM ALL Clear				*
;* mem8 ,idx16							*
;* Dtata Bank:0							*
;=====================================================================
VRAMClear
	shorta
	longi

	lda	#%10000000
	sta	vmainc
	ldx	#0
	stx	vmaddl

	lda	#%00001001
	sta	ch0params	;data kotei
	lda	#vmdatal&$ff
	sta	ch0addrb
	ldx	#clear_data&WM	;clear data address
	stx	ch0addra1tl
	lda	#clear_data>>16
	sta	ch0atbank	;clear data bank
	ldx	#0
	stx	ch0dataddrl	;data value 10000h byte
	lda	#1
	sta	mdmaen
	rts
clear_data
	dw	0

;=====================================================================
;*		Check AUTO TRIGGER  	[UP,DOWN,LEFT,RIGHT]	*
;* 1 PLAYER ONLY							*
;* Init :key_tatemaxptr1,key_yokomaxptr1				*
;* Exit :key_tateptr1,key_yokoptr1,keyflag				*
;=====================================================================
Check_autotrig
	shorta
	longi
	phb
	db7e
;---------------------------------------------------------------------
	km_autotrigread		;[KEY STATES READ]
;---------------------------------------------------------------------
	km_TESTautotrig	UP
	bne		.up
	km_TESTautotrig	DOWN
	bne		.down
	km_TESTautotrig	Left
	bne		.left
	km_TESTautotrig	Right
	bne		.right
	brl		.exit
;---------------------------------------------------------------------
.up
	lda	key_tateptr1
	dec	a
	bpl	.skip_up
	lda	key_tatemaxptr1
	dec	a
.skip_up
	sta	key_tateptr1	;keyptr
;	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.down
	lda	key_tateptr1	;keyptr
	inc	a
	cmp	key_tatemaxptr1	;keymaxptr
	bne	.skip_down
	lda	#0
.skip_down
	sta	key_tateptr1	;keyptr

;	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.left
	lda	key_yokoptr1	;keyptr
	dec	a
	bpl	.skip_left
	lda	key_yokomaxptr1	;keymaxptr
	dec	a
.skip_left
	sta	key_yokoptr1	;keyptr
;	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.right
	lda	key_yokoptr1	;keyptr
	inc	a
	cmp	key_yokomaxptr1	;keymaxptr
	bne	.skip_right
	lda	#0
.skip_right
	sta	key_yokoptr1	;keyptr
;	km_setflag	keyflag,key_push

;---------------------------------------------------------------------
.sound
	km_setflag	keyflag,key_push
	ksound	cursor
;---------------------------------------------------------------------
.exit
	plb
	rts

;=====================================================================
;*		AUTO TRIGGER READ		[KEY CHECK]	*
;* Mem 8								*
;* Init: autokeycheck:(check key states)				*
;=====================================================================
autotrigger
	shorta
;* dec timer *
	km_dectimer0	autokeytm

;* clear trigger flag *
	km_clrflag	autotrig,triggerflag

;* KEY CHECK *
	km_bitcheckflag	keystates,%00001111
	bne	.pushkey
.resetautokey
	sta	autotrig
	stz	autokeytm
	rts
.pushkey
	bit	autotrig
	sta	autotrig
	beq	.anotherkeypush

.samekeypush
	lda	autokeytm
	bne	.end

.anotherkeypush
	km_setflag	autotrig,triggerflag
	km_setval	autokeytm,triggerrepeat
.end
	rts


;=====================================================================
;*		Check AUTO TRIGGER  (UP,DOWN)	[KEY CHECK]	*
;* 1 PLAYER ONLY							*
;* Init :keymaxptr 							*
;* Exit :keyptr,keyflag						*
;=====================================================================
Check_autotrigUD
	shorta
	longi
	phb
	db7e
;---------------------------------------------------------------------
	km_autotrigread		;[KEY STATES READ]
;---------------------------------------------------------------------
	km_TESTautotrig	UP
	bne		.up
	km_TESTautotrig	DOWN
	bne		.down
	bra		.exit
;---------------------------------------------------------------------
.up
	lda	key_tateptr1	;keyptr
	dec	a
	bpl	.skip_up
	lda	key_tatemaxptr1	;keymaxptr
	dec	a
.skip_up
	sta	key_tateptr1	;keyptr
	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.down
	lda	key_tateptr1	;keyptr
	inc	a
	cmp	key_tatemaxptr1	;keymaxptr
	bne	.skip_down
	lda	#0
.skip_down
	sta	key_tateptr1	;keyptr

	km_setflag	keyflag,key_push
;---------------------------------------------------------------------
.sound
	ksound	cursor
;---------------------------------------------------------------------
.exit
	plb
	rts
;=====================================================================
;*		Check AUTO TRIGGER  (UP,DOWN)	[KEY CHECK]	*
;* 1 PLAYER ONLY							*
;* Init :keymaxptr 							*
;* Exit :keyptr,keyflag						*
;=====================================================================
Check_autotrigLR
	shorta
	longi
	phb
	db7e
;---------------------------------------------------------------------
	km_autotrigread		;[KEY STATES READ]
;---------------------------------------------------------------------
	km_TESTautotrig	Left
	bne		.left
	km_TESTautotrig	Right
	bne		.right
	bra		.exit
;---------------------------------------------------------------------
.left
	lda	key_yokoptr1	;keyptr
	dec	a
	bpl	.skip_left
	lda	key_yokomaxptr1	;keymaxptr
	dec	a
.skip_left
	sta	key_yokoptr1	;keyptr
	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.right
	lda	key_yokoptr1	;keyptr
	inc	a
	cmp	key_yokomaxptr1	;keymaxptr
	bne	.skip_down
	lda	#0
.skip_down
	sta	key_yokoptr1	;keyptr

	km_setflag	keyflag,key_push
;---------------------------------------------------------------------
.sound
	ksound	cursor
;---------------------------------------------------------------------
.exit
	plb
	rts


;=====================================================================
;*		Check TRIGGER  (UP,DOWN)	[KEY CHECK]	*
;* 1 PLAYER ONLY							*
;* Init :keymaxptr 							*
;* Exit :keyptr,keyflag						*
;=====================================================================
Check_triggerUD
	shorta
	longi
	phb
	db7e
;---------------------------------------------------------------------
	km_TESTjoypad	UP
	bne		.up
	km_TESTjoypad	DSel
	bne		.down
	bra		.exit
;---------------------------------------------------------------------
.up
	lda	key_tateptr1	;keyptr
	dec	a
	bpl	.skip_up
	lda	key_tatemaxptr1	;keymaxptr
	dec	a
.skip_up
	sta	key_tateptr1	;keyptr
	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.down
	lda	key_tateptr1	;keyptr
	inc	a
	cmp	key_tatemaxptr1	;keymaxptr
	bne	.skip_down
	lda	#0
.skip_down
	sta	key_tateptr1	;keyptr

	km_setflag	keyflag,key_push
;---------------------------------------------------------------------
.sound
	ksound	cursor
;---------------------------------------------------------------------
.exit
	plb
	rts

;=====================================================================
;*		Check TRIGGER  (Left,Right)	[KEY CHECK]	*
;* 1 PLAYER ONLY							*
;* Init :keymaxptr 							*
;* Exit :keyptr,keyflag						*
;=====================================================================
Check_triggerLR
	shorta
	longi
	phb
	db7e
	km_clrflag	keyflag,key_push
;---------------------------------------------------------------------
	km_TESTjoypad	Left
	bne		.left
	km_TESTjoypad	Right
	bne		.right
	bra		.exit
;---------------------------------------------------------------------
.left
	lda	key_yokoptr1	;keyptr
	dec	a
	bpl	.skip_left
	lda	key_yokomaxptr1	;keymaxptr
	dec	a
.skip_left
	sta	key_yokoptr1	;keyptr
	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.right
	lda	key_yokoptr1	;keyptr
	inc	a
	cmp	key_yokomaxptr1	;keymaxptr
	bne	.skip_down
	lda	#0
.skip_down
	sta	key_yokoptr1	;keyptr
	km_setflag	keyflag,key_push
;---------------------------------------------------------------------
.sound
	ksound	cursor
;---------------------------------------------------------------------
.exit
	plb
	rts

;=====================================================================
;*		Check KEY  (UP,DOWN)		[KEY CHECK]	*
;* Init :keymaxptr 							*
;=====================================================================
Check_updwkey
	shorta
	longi

	km_clrflag	keyflag,key_push

	testjoypad	up
	bne		.up
	testjoypad	down
	bne		.down
	bra		.exit
;---------------------------------------------------------------------
.up
	lda	keyptr
	dec	a
	bpl	.skip_up
	lda	keymaxptr
	dec	a
.skip_up
	sta	keyptr
	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.down
	lda	keyptr
	inc	a
	cmp	keymaxptr
	bne	.skip_down
	lda	#0
.skip_down
	sta	keyptr

	km_setflag	keyflag,key_push
;---------------------------------------------------------------------
.sound
	ksound	cursor
;---------------------------------------------------------------------
.exit
	rts
;=====================================================================
;*		Check KEY  (LEFT,RIGHT)		[KEY CHECK]	*
;* Init :keymaxptr 							*
;=====================================================================
Check_LRkey
	shorta
	longi

	km_clrflag	keyflag,key_push

	testjoypad	left
	bne		.left
	testjoypad	right
	bne		.right
	bra		.exit
;---------------------------------------------------------------------
.left
	lda	keyptr
	dec	a
	bpl	.skip_left
	lda	keymaxptr
	dec	a
.skip_left
	sta	keyptr
	km_setflag	keyflag,key_push
	bra	.sound
;---------------------------------------------------------------------
.right
	lda	keyptr
	inc	a
	cmp	keymaxptr
	bne	.skip_right
	lda	#0
.skip_right
	sta	keyptr

	km_setflag	keyflag,key_push
;---------------------------------------------------------------------
.sound
	ksound	cursor
;---------------------------------------------------------------------
.exit
	rts

;=====================================================================
;*			MOZAIKU FADEOUT				*
;* data bank 7e							*
;=====================================================================
mozaikufadeout
	php
	phb
	db7e
	a8i16
	lda	#%10000111
	sta	kw_mozaikuflag
	lda	#%00000000
	sta	kw_mozaikunumber

	lda	kw_tmbackup
	and	#$0f
	sta	kw_tm		;[obj wo kesu]
.mozaiku
	lda	#iv_titleirq
	sta	trans_flag	;[irq pointer]
	km_waittrans		;[irq wait]

	lda	kx_mozaikutimer
	dec	a
	sta	kx_mozaikutimer
	bpl	.mozaiku

	lda	#1
	sta	kx_mozaikutimer

	lda	kw_mozaikunumber
	clc
	adc	#%00010000
	sta	kw_mozaikunumber
	cmp	#%11110000
	bne	.mozaiku

	lda	#%10000000
	sta	kw_mozaikuflag
	stz	kw_mozaikunumber

	lda	kw_tmbackup
	sta	kw_tm

	lda	#iv_titleirq
	sta	trans_flag	;[irq pointer]
	km_waittrans		;[irq wait]

	stz	kw_mozaikuflag

	plb
	plp
	rts

;=====================================================================
;*			MOZAIKU FADEIN				*
;* data bank 7e							*
;=====================================================================
mozaikufadein
	php
	phb
	db7e

	a8i16
	lda	#%10000111
	sta	kw_mozaikuflag
	lda	#%11110000
	sta	kw_mozaikunumber
	lda	kw_tmbackup
	and	#$0f
	sta	kw_tm

.mozaiku
	lda	#iv_titleirq
	sta	trans_flag	;[irq pointer]
	km_waittrans		;[irq wait]

	lda	kx_mozaikutimer
	dec	a
	sta	kx_mozaikutimer
	bpl	.mozaiku

	lda	#1
	sta	kx_mozaikutimer

	lda	kw_mozaikunumber
	sec
	sbc	#%00010000
	sta	kw_mozaikunumber
	cmp	#%00000000
	bne	.mozaiku

	lda	#%10000000
	sta	kw_mozaikuflag
	stz	kw_mozaikunumber
	lda	kw_tmbackup
	sta	kw_tm
	lda	#iv_titleirq
	sta	trans_flag	;[irq pointer]
	km_waittrans		;[irq wait]

	stz	kw_mozaikuflag
	plb
	plp
	rts

;*********************************************************************
;*								*
;*		Initial Mission Result Screen			*
;*********************************************************************
Init_MRScreen_l
	shorta
	longi
	phb
	db0
	screen_off
	disable			;IRQ disable

	jsr	Initial_MRPPUreg

	jsr	Set_MRBG1CGX
	jsr	Set_MRBG1SCR

	jsr	Set_MRBG2CGX
	jsr	Set_MRBG2SCR

	jsr	Set_MRBG3CGX
	jsr	Set_MRBG3SCR

	jsr	Set_MRCOL

	plb
	rtl

;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
Initial_MRPPUreg
	shorta

	lda	#%00001001
	sta	bgmode		;BG mode 1 ,8*8 dot ,BG3 prio off

	lda	#(mr_bg1_scr>>8)&$fc!1	;BG1 SCR ,screen 1
	sta	bg1sc				   
	lda	#(mr_bg2_scr>>8)&$fc
	sta	bg2sc			;BG2 SCR ,screen 1
	lda	#(mr_bg3_scr>>8)&$fc
	sta	bg3sc			;BG3 SCR ,screen 1

	lda	#(mr_bg1_cgx>>12)!((mr_bg2_cgx>>8)&$f0)
	sta	bg12nba			;BG1,BG2

	lda	#(mr_bg3_cgx>>12)
	sta	bg34nba			;BG3

	lda	#(mr_obj_cgx>>13)
	sta	objsel			;OBJ

	lda	#%00010111
	sta	tm			;BG1,BG2,OBJ display
	sta	kw_tm
	sta	kw_tmbackup

;OBJ Screen Add (to BG2&BG3)

	alloc_window	hitflash,1	; x = hitflash
	lda	#%00000110
	sta.w	wm_ts,x		;212dh
	lda	#%00000010
	sta.w	wm_cgswsel,x	;2130h
	lda	#%00010000
	sta.w	wm_cgadsub,x	;2131h

;* H-V SCROOLL *
	jsl	init_mmhvscroll_l

	lda	#%00000000
	sta	hdmaen_gc
	rts
;=====================================================================
;*			Initial BG1 Character Data		*
;=====================================================================
Set_MRBG1CGX
	decvramnotrans	0,mr_bg1_cgx,b0_ccr,(512*32)
	rts
;=====================================================================
;*			Initial BG1 Screen Data			*
;=====================================================================
Set_MRBG1SCR
	decvramnotrans	0,mr_bg1_scr,b6_pcr,$1000
	rts
;=====================================================================
;*			Initial BG2 Character Data		*
;=====================================================================
Set_MRBG2CGX
	rts
;=====================================================================
;*			Initial BG2 Screen Data			*
;=====================================================================
Set_MRBG2SCR
	decvramnotrans	0,mr_bg2_scr,b0_pcr,$800

	a16
	ldx	#0
	ldy	#0
	km_setval	kz_x1,($20*$1d*2)
	jsl	kcopyscreen_sub_l

;* Battle Ship *
	km_setval	kz_x1,$10
	km_setval	kz_y1,$0f
	km_setval	kz_z1,$6d
	km_setvar.l	kz_tpa,kx_initbattleshipkazu
	jsl	Clear_BGKakikaeBuffer_l

;* Planet *
	km_setval	kz_x1,$10
	km_setval	kz_y1,$11
	km_setval	kz_z1,$7d
	km_setvar.l	kz_tpa,kx_initplanetkazu
	jsl	Clear_BGKakikaeBuffer_l

;* Partner Continue *
	km_bitcheckmistotalflag	partner1
	beq	.no_partnercontinue

	km_setval	kz_x1,$10
	km_setval	kz_y1,$17
	km_setval	kz_z1,$fa
	km_setval	kz_tpa,6
	jsl	Set_BGKakikaeBuffer_l
.no_partnercontinue

;* Bonus Params Clear *
	lda.l	kx_result
	cmp	#kre_gameclear
	beq	.GameClear

	km_setval	kz_x1,$02
	km_setval	kz_y1,$12
	km_setval	kz_z1,$131
	km_setval	kz_tpa,($1d-$02+$01)
	km_setval	kcounter,6
.LOOP
	jsl	Clear_BGKakikaeBuffer_l

	inc	kz_y1
	dec	kcounter
	bne	.LOOP
	bra	.END

.GameClear
	phb
	db7e
;* time limit *
	km_setval	kz_x1,$0a	;[top x zahyou]
	km_setval	kz_y1,$13	;[top y zahyou]
	km_setval	kz_z1,$93	;[character hosei]

	lda	kdifficulty
	asl	a
	tax

	lda.l	timebonustbl,x		;[kazu]
	sta	kwork
	ldx	#3			;[ketasuu]
	jsl	SetBGNumber_8x8_l


	km_setval	kz_x1,$12	;[top x zahyou]
	lda	kwork
	ldx	#3			;[ketasuu]
	jsl	SetBGNumber_8x8_l


;* corneria damage *
	km_setval	kz_x1,$10	;[top x zahyou]
	km_setval	kz_y1,$15	;[top y zahyou]
	km_setval	kz_z1,$93	;[character hosei]
	lda	#100
	ldx	#3			;[ketasuu]
	jsl	SetBGNumber_8x8_l
	plb
.END
	a8
	rts

;=====================================================================
;*			Initial BG3 Character Data		*
;=====================================================================
Set_MRBG3CGX
	decvramnotrans	0,mr_bg3_cgx,b9_ccr,(256*16)
	rts
;=====================================================================
;*			Initial BG3 Screen Data			*
;=====================================================================
Set_MRBG3SCR
	decvramnotrans	0,mr_bg3_scr,b4_pcr,$800
	rts
;=====================================================================
;*			Initial OBJ Character Data		*
;=====================================================================
Set_MROBJCGX
	decvramnotrans	0,mr_obj_cgx,e0_ccr,($200*32)
	rts

;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_MRCOL
	decrunch_palettes
	dmacgram	0,0,b0_pac,$200
	km_IRQdmaRAMtoRAM	b0_pac,kx_palette,$200
	km_IRQdmaRAMtoRAM	b9_pac,kx_palette4,$100
	rts



;*********************************************************************
;*								*
;*		Initial HI Score Screen				*
;*********************************************************************
Init_HIScreen_l
	shorta
	longi
	phb
	db0
	screen_off
	disable			;IRQ disable

	jsr	Initial_HIPPUreg
	jsr	Set_HIBG2CGX
	jsr	Set_HIBG2SCR
	jsr	Set_HICOL

	plb
	rtl
;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
Initial_HIPPUreg
	shorta
	jsr	Initial_MRPPUreg
	rts
;=====================================================================
;*			Initial BG1 Character Data		*
;=====================================================================
Set_HIBG1CGX
	decvramnotrans	0,mr_bg1_cgx,b0_ccr,(512*32)
	rts
;=====================================================================
;*			Initial BG1 Screen Data			*
;=====================================================================
Set_HIBG1SCR
	rts
;=====================================================================
;*			Initial BG2 Character Data		*
;=====================================================================
Set_HIBG2CGX
	rts
;=====================================================================
;*			Initial BG2 Screen Data			*
;=====================================================================
Set_HIBG2SCR
	decvramnotrans	0,hs_bg2_scr,b5_pcr,$800
	a16
	ldx	#0
	ldy	#0
	km_setval	kz_x1,($20*$1d*2)
	jsl	kcopyscreen_sub_l
	a8
	rts
;=====================================================================
;*			Initial BG3 Character Data		*
;=====================================================================
Set_HIBG3CGX
	rts
;=====================================================================
;*			Initial BG3 Screen Data			*
;=====================================================================
Set_HIBG3SCR
	rts
;=====================================================================
;*			Initial OBJ Character Data		*
;=====================================================================
Set_HIOBJCGX
	decvramnotrans	0,mr_obj_cgx,e1_ccr,($100*32)
	rts

;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_HICOL
	decrunch_palettes
	dmacgram	0,0,b0_pac,$200
	rts

;*********************************************************************
;*								*
;*	   	Initial HI Score Screen				*
;*********************************************************************
Init_HSScreen_l
	shorta
	longi
	phb
	db0
	screen_off
	disable			;IRQ disable

	jsr	Initial_HSPPUreg
	jsr	Set_HSBG2CGX
	jsr	Set_HSBG2SCR
	jsr	Set_MRBG3CGX
	jsr	Set_MRBG3SCR
	jsr	Set_HSCOL

	plb
	rtl
;=====================================================================
;*			Initial PPU Register			*
;=====================================================================
Initial_HSPPUreg
	shorta

	lda	#%00001001
	sta	bgmode		;BG mode 1 ,8*8 dot ,BG3 prio off

	lda	#(hs_bg1_scr>>8)&$fc	;BG1 SCR ,screen 1
	sta	bg1sc				   
	lda	#(hs_bg2_scr>>8)&$fc
	sta	bg2sc			;BG2 SCR ,screen 1
	lda	#(hs_bg3_scr>>8)&$fc
	sta	bg3sc			;BG3 SCR ,screen 1

	lda	#(hs_bg1_cgx>>12)!((hs_bg2_cgx>>8)&$f0)
	sta	bg12nba			;BG1,BG2

	lda	#(hs_bg3_cgx>>12)
	sta	bg34nba			;BG3

	lda	#(hs_obj_cgx>>13)
	sta	objsel			;OBJ
	lda	#%00010110
	sta	tm			;BG1,BG2,OBJ display
	sta	kw_tm
	sta	kw_tmbackup

;OBJ Screen Add (to BG2)
	lda	#%00000010
	sta	ts
	lda	#%00000010
	sta	cgswsel
	lda	#%00010000
	sta	cgadsub

;* H-V SCROOLL *
	jsl	init_mmhvscroll_l
	lda	#%00000000
	sta	hdmaen_gc
	rts

;=====================================================================
;*			Initial BG1 Character Data		*
;=====================================================================
Set_HSBG1CGX
	rts
;=====================================================================
;*			Initial BG1 Screen Data			*
;=====================================================================
Set_HSBG1SCR
	rts
;=====================================================================
;*			Initial BG2 Character Data		*
;=====================================================================
Set_HSBG2CGX
	decvramnotrans	0,hs_bg2_cgx,b0_ccr,(512*32)
	rts
;=====================================================================
;*			Initial BG2 Screen Data			*
;=====================================================================
Set_HSBG2SCR
	decvramnotrans	0,hs_bg2_scr,b2_pcr,$800
	a16
	ldx	#0
	ldy	#0
	km_setval	kz_x1,($20*$1d*2)
	jsl	kcopyscreen_sub_l
	a8
	rts

;=====================================================================
;*			Initial OBJ Character Data		*
;=====================================================================
Set_HSOBJCGX
	decvramnotrans	0,mr_obj_cgx,e1_ccr,($100*32)
	rts
;=====================================================================
;*			Initial Color Data			*
;=====================================================================
Set_HSCOL
	decrunch_palettes
	dmacgram	0,0,b0_pac,$200
	rts
;*****************************************************************************
;*									*
;*									*
;*			OAM DATA TABLE					*
;*									*
;*									*
;*****************************************************************************
;=====================================================================
;*			Title Sprites Data			*
;=====================================================================
titx	equ	$20
tity	equ	$18
titchr	equ	$0
TitSPrData
	km_datacnt	W,TitSprData
	SpriteDataB	titx+0*8,tity+0*8,(titchr+conf_9)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+1*8,tity+0*8,(titchr+conf_5)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+2*8,tity+0*8,(titchr+conf_bar)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+3*8,tity+0*8,(titchr+conf_0)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+4*8,tity+0*8,(titchr+conf_9)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+5*8,tity+0*8,(titchr+conf_bar)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+6*8,tity+0*8,(titchr+conf_1)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+7*8,tity+0*8,(titchr+conf_2)&BM,colpal0,pri3,noflip

	SpriteDataB	titx+0*8,tity+1*8,(titchr+conf_p)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+1*8,tity+1*8,(titchr+conf_m)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+3*8,tity+1*8,(titchr+conf_0)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+4*8,tity+1*8,(titchr+conf_7)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+5*8,tity+1*8,(titchr+conf_bar)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+6*8,tity+1*8,(titchr+conf_3)&BM,colpal0,pri3,noflip
	SpriteDataB	titx+7*8,tity+1*8,(titchr+conf_0)&BM,colpal0,pri3,noflip

TitSPrDataEND
;----------------------------------------------------------------------------------------------
mmx	=	$60
mmy	=	$40
ty = 2
MMapSelSprData
	km_datacnt	W,MMapSelSprData

	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_v,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	mmx+04*8,mmy+ty*8,titchr+conf_m,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_i,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+04*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+05*8,mmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	mmx+06*8,mmy+ty*8,titchr+conf_i,colpal0,pri3,noflip
	SpriteDataB	mmx+07*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_m,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_c,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_b,colpal0,pri3,noflip
	SpriteDataB	mmx+04*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+05*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+06*8,mmy+ty*8,titchr+conf_h,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_l,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_d,colpal0,pri3,noflip
	SpriteDataB	mmx+04*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+05*8,mmy+ty*8,titchr+conf_r,colpal0,pri3,noflip
	SpriteDataB	mmx+06*8,mmy+ty*8,titchr+conf_d,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_m,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+04*8,mmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	mmx+05*8,mmy+ty*8,titchr+conf_r,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_f,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_r,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+04*8,mmy+ty*8,titchr+conf_u,colpal0,pri3,noflip
	SpriteDataB	mmx+05*8,mmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	mmx+06*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip

ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_1,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_2,colpal0,pri3,noflip
ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_3,colpal0,pri3,noflip

ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_o,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_4,colpal0,pri3,noflip

ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_x,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_1,colpal0,pri3,noflip

ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_x,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_2,colpal0,pri3,noflip

ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_x,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_3,colpal0,pri3,noflip

ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_x,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_4,colpal0,pri3,noflip

ty = ty+1
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_d,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_m,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_o,colpal0,pri3,noflip


MMapSelSprDataEnd

;----------------------------------------------------------------------------------------------
mmx	=	$30
mmy	=	$80
ty = 0
PlanetStepSprData
	km_datacnt	W,PlanetStepSprData
;Planet Step
	SpriteDataB	mmx+00*8,mmy+ty*8,titchr+conf_p,colpal0,pri3,noflip
	SpriteDataB	mmx+01*8,mmy+ty*8,titchr+conf_l,colpal0,pri3,noflip
	SpriteDataB	mmx+02*8,mmy+ty*8,titchr+conf_a,colpal0,pri3,noflip
	SpriteDataB	mmx+03*8,mmy+ty*8,titchr+conf_n,colpal0,pri3,noflip
	SpriteDataB	mmx+04*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+05*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip

	SpriteDataB	mmx+07*8,mmy+ty*8,titchr+conf_s,colpal0,pri3,noflip
	SpriteDataB	mmx+08*8,mmy+ty*8,titchr+conf_t,colpal0,pri3,noflip
	SpriteDataB	mmx+09*8,mmy+ty*8,titchr+conf_e,colpal0,pri3,noflip
	SpriteDataB	mmx+10*8,mmy+ty*8,titchr+conf_p,colpal0,pri3,noflip
PlanetStepSprDataEND

;----------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------


;--------------------------------------------------------------------
;=====================================================================
;=====================================================================
	ifeq	1
	shorta
	longi


	lda.l	KCGXTransTimer
	beq	.timer0
	dec	a
	sta.l	KCGXTransTimer
	bra	.skip
.timer0
	lda	#10
	sta.l	KCGXTransTimer

	lda.l	KCGXTransPtr
	inc	a
	and	#$03
	sta.l	KCGXTransPtr
.skip
	lda	#0
	xba
	lda.l	KCGXTransPtr
	asl	a
	clc
	adc.l	KCGXTransPtr
	tax

	a16
	lda.l	CGXtensouTable+0,x
	tay
	a8
	lda.l	CGXtensouTable+2,x

	rtl
;---------------------------------------------------------------------------
CGXtensouTable
	dl	KCGXTransBuffer+0
	dl	KCGXTransBuffer+64*32
	dl	KCGXTransBuffer+128*32
	dl	KCGXTransBuffer+192*32
	endc



