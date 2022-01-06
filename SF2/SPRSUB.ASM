;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         SPRSUB.ASM                                          ;
; AUTHOR:       YASUHIRO KAWAGUCHI                                  ;
; DESCRIPTION:  Code for generating sprites                         ;
; DATE CREATED: 1-2-95    	                                       ;
;                                                                   ;
;-------------------------------------------------------------------;

;*****************************************************************************
;*									*
;*			OAM Buffer Clear				* 
;*									*
;*****************************************************************************
oambufclr_data
	db	$e8
;=============================================================
;*							*
;*		OAM Single Buffer Clear	[single buffer] *
;*							*
;=============================================================
oamclear_SG_l
	shorta
	longi
	pha
	phx
	phy
	phb
	db7e

	a16

	km_cmpcheckgamemode	selectmissionmap
	BEQ	.SKIP
;* OAM MAIN *
	lda	#obj_clear
	sta	spritebuf1

	lda	#obj_offset!obj_pri0
	sta	spritebuf1+2
	blocktrans_sub	spritebuf1,spritebuf1+4,(obj_val-1)*4
.skip

;* OAM SUB *
	lda	#objsub_on
	sta	sprites_sub
	blocktrans_sub	sprites_sub,sprites_sub+2,(obj_val/4)-2

	a8
	plb
	ply
	plx
	pla
	rtl

;=============================================================
;*							*
;*			OAM Clear	[Double Buffer] *
;* Double buffer(sub) wo subete Clear			*
;=============================================================
oamclear_l
	shorta
	longi
	pha
	phx
	phy
	phb
	db7e

;* OAM MAIN *
	a16
	lda	#obj_clear	;zahyou clear
	sta	spritebuf1
;;;;	sta	spritebuf2

	lda	#obj_pri0!obj_offset
	sta	spritebuf1+2

;	sta	spritebuf2+2

	blocktrans_sub	spritebuf1,spritebuf1+4,((obj_val+objsub_val)*2-1)*4

;;;;	blocktrans_sub	spritebuf2,spritebuf2+4,(obj_val-1)*4

;* OAM SUB *
	lda	#objsub_on
	sta	sprites_sub
	sta	sprites_sub2
	blocktrans_sub	sprites_sub,sprites_sub+2,(obj_val/4)-2
	blocktrans_sub	sprites_sub2,sprites_sub2+2,(obj_val/4)-2

	a8
	plb
	ply
	plx
	pla
	rtl
;=============================================================
;*		OAM Clear For Double Buffer		*
;* Init :Yreg sprites pointer				*
;* data bank :7e						*
;* Double buffer(sub) wo kougoni Clear			*
;=============================================================
oamclear_DB_l
	shorta
	longi
	pha
	phx
	phy

	PHB
	db7e
;----- OAM Main Data clear ------
	a16
	lda	#obj_clear
	sta	sprites,y	;Y postion clear

	tya
	clc
	adc	#(sprites)&WM
	tax			;sprites source address
	clc
	adc	#4
	tay			;sprites dest address
	lda	#((obj_val-1)*4)-1
	km_mvn	sprites,sprites
;----- OAM Sub Data all on --------
	lda	#objsub_on
	sta.w	0,y		;sprites sub first data

	tyx
	tya
	clc
	adc	#2
	tay

	lda	#((obj_val/4)-2)-1
	km_mvn	sprites,sprites

	a8
	PLB
	ply
	plx
	pla
	rtl

;=============================================================
;*		OAM All Clear				*
;* Init :Yreg chyokusetu no sprite pointer	sta.w 0,y	*
;=============================================================
oamallclear_l
	km_PushAllReg
	a8
	lda	#$7e
	pha
	plb
	ai16
;----- OAM Main Data clear ------
	lda	#obj_clear
	sta.w	0,y	;Y postion clear
	tyx
	tya			;sprites source address
	clc
	adc	#4
	tay			;sprites dest address
	lda	#((obj_val-1)*4)-1
	km_mvn	sprites,sprites

;----- OAM Sub Data all on --------
	lda	#objsub_on
	sta.w	0,y		;sprites sub first data

	tyx
	tya
	clc
	adc	#2
	tay

	lda	#((obj_val/4)-2)-1
	km_mvn	sprites,sprites

	km_PullAllReg
	rtl
;*****************************************************************************
;*									*
;*		OBJ (Main,Sub) Data Set					* 
;*									*
;*****************************************************************************

;=====================================================================
;*								*
;*			Set Number (8*8)			*
;* Mem16 idx16							*
;* Data Bank:7e							*
;* Yreg:Sprites Pointer						*
;* kz_x1  :1 no kurai no (X,Y) Postion ;(1,10,100,... no jyun ni SET)*
;* kz_x2  :Game Score						*
;* kz_x3  :colour No+char base					*
;* kz_y1  :ketasuu							*
;* [Temporary]							*
;* kz_tpa :Chacter+Attribute						*
;=====================================================================
SetSprNumber_8x8
	php
	PHX
	a8
	km_setvar	kz_tpx,kz_x1
	km_setvar	kz_tpy,kz_x1+1
	a16
;* 1 no kurai *
	lda	kz_x2
	km_cpudivu16uf8_work	10
	lda	kamari
	ora	kz_x3
	sta	kz_tpa		;Character
	jsr	SetSprite_1

;* 10~10000 no kurai *
	ldx	kz_y1
	dex
	beq	.end
.loop
	km_substaval	kz_tpx,8

	lda	ksyou
	km_cpudivu16uf8_work	10
	lda	kamari
	ora	kz_x3
	sta	kz_tpa			;Character
	jsr	SetSprite_1
	dex
	bne	.loop
.end
	PLX
	plp
	rts
;=====================================================================
;*								*
;*			Set Number (8*16 char)			*
;* Mem16 idx16							*
;* Data Bank:7e							*
;* Yreg   :Sprites Pointer						*
;* Mem16 idx16							*
;* Data Bank:7e							*
;* Yreg:Sprites Pointer						*
;* kz_x1  :1 no kurai no (X,Y) Postion ;(1,10,100,... no jyun ni SET)*
;* kz_x2  :Game Score						*
;* kz_x3  :colour No+char base					*
;* kz_y1  :ketasuu							*
;* [Temporary]							*
;* kz_tpa :Chacter+Attribute						*
;* kz_tpx  :								*
;=====================================================================
SetSprNumber_8x16
	shorta
	longi
	php
	ai16
	PHX
;* 1 no kurai *
	lda	kz_x2
	km_cpudivu16uf8_work	10
	lda	kamari
	ora	kz_x3
	sta	kz_tpa			;Character
	jsr	SetSprNumber_8x16_sub
;* 10~10000 no kurai *
	ldx	kz_y1
	dex
	beq	.end
.loop
	km_substaval	kz_x1,8

	lda	ksyou
	km_cpudivu16uf8_work	10
	lda	kamari
	ora	kz_x3
	sta	kz_tpa			;Character
	jsr	SetSprNumber_8x16_sub
	dex
	bne	.loop
.end
	PLX
	plp
	rts

;*********************************************************************
;*			Set Number Sub (8*16 char)		*
;* [Initial]								*
;* kz_x1	:x,y zahyou (2 byte)					*
;* kz_tpa	:chracterNo & colour (2 byte)				*
;* [Temporary]							*
;* kz_tpx								*
;*********************************************************************
SetSprNumber_8x16_sub
	php
	a16
	longi
	phx
;* ue *
	km_SetSpriteXY	kz_x1

	lda	tpa
	km_hiba
	sta	kz_tpx

	km_lldm4x	tpa
	lda.l	ndata_0,x
	ora	kz_tpx
	km_setsprite

;* shita *
	lda	kz_x1
	clc
	adc	#$0800-$100
	km_SetSprite

	lda.l	ndata_0+2,x
	ora	kz_tpx
	km_setsprite
	plx
	plp
	rts

;=====================================================================
;*								*
;*			Set Number (16*16 char)			*
;* Data Bank:7e							*
;* Yreg   :Sprites Pointer						*
;* [Initial]								*
;* kz_x1  :1 no kurai no (X,Y) Postion ;(1,10,100,... no jyun ni SET)*
;* kz_x2  :Game Score						*
;* kz_x3  :colour No+char base					*
;* kz_y1  :ketasuu							*
;* [Temporary]							*
;* kz_tpa :Chacter+Attribute						*
;=====================================================================
SetSprNumber_16x16
	php
	ai16
	PHX
;* 1 no kurai *
	lda	kz_x2
	jsr	conv_objnumber

	a8
	km_setvar	kz_tpx,kz_x1
	km_setvar	kz_tpy,kz_x1+1
	jsr	SetSprite_16x16
	a16
;* 10~10000 no kurai *
	ldx	kz_y1
	dex
	beq	.end
.loop
	longa
	lda	ksyou
	jsr	conv_objnumber
	a8
	km_substaval	kz_tpx,16
	jsr	SetSprite_16x16
	a16
	dex
	bne	.loop
.end
	PLX
	plp
	rts
;=============================================================
;*		Convert Number to Obj Character		*
;* Initial	:Acc    <<< number				*
;*	:kz_x3  <<< chacter Base			*
;* OutPut	:kz_tpa <<< obj charcter			*
;=============================================================
conv_objnumber
	longa
	km_cpudivu16uf8_work	10
	lda	kamari
	asl	a
	cmp	#$0010
	bmi	.less8
	clc
	adc	#$0010
.less8
	clc
	adc	kz_x3
	sta	kz_tpa			;Character
	rts

;=====================================================================
;*			Set Sprite Character (8*8)		*
;* [Initial]								*
;* Input	:kz_tpx :x zahyou					*
;*	:kz_tpy :y zahyou					*
;*	:kz_tpa :char&Att					*
;=====================================================================
SetSprite_1
	php
	longi
	a8
	lda	kz_tpx
	km_SetSprite

	lda	kz_tpy
	km_SetSprite

	a16
	lda	kz_tpa
	km_SetSprite

	plp
	rts
;=====================================================================
;*			Set Sprite Character (8*8)		*
;* [Initial]								*
;* Input	:kz_tpx :cx zahyou					*
;*	:kz_tpy :cy zahyou					*
;*	:kz_tpa :char&Att					*
;=====================================================================
SetSprite_8x8
	php
	longi
	a8
	lda	kz_tpx
	sec
	sbc	#4
	km_SetSprite

	lda	kz_tpy
	sec
	sbc	#4+1
	km_SetSprite

	a16
	lda	kz_tpa
	km_SetSprite

	plp
	rts

;=====================================================================
;*	Set Sprite (16*16) = (X,Y),Char,Att			*
;* Input	:kz_tpx :x zahyou					*
;*	:kz_tpy :y zahyou					*
;*	:kz_tpa :char&Att					*
;* data bank 7e 							*
;=====================================================================
SetSprite_16x16
SetSprite_4
	php
	longi
;* oam sub set *
	a16
	km_bitcheckscreenflag	sprwbuf
	a8
	bne	.double
.single
	km_setspritesize1
	bra	.skip
.double
	km_setspritesizedb1
.skip

;* oam main set *
	lda	kz_tpx
	sec
	sbc	#8
	sta	sprites+0,y

	lda	kz_tpy
	sec
	sbc	#9
	sta	sprites+1,y

	a16
	lda	kz_tpa
	sta	sprites+2,y

	iny
	iny
	iny
	iny

	plp
	rts

;=====================================================================
;*	Set Sprite (32*16) = (X,Y),Char,Att			*
;* Input	:kz_tpx :cx zahyou	(center)			*
;*	:kz_tpy :cy zahyou	(center)			*
;*	:kz_tpa :char&Att					*
;* data bank 7e 							*
;=====================================================================
SetSprite_32x16
	php
	longi
;* oam sub set *
	a16
	km_bitcheckscreenflag	sprwbuf
	a8
	bne	.double
.single
	km_setspritesizesb2
	bra	.skip
.double
	km_setspritesizedb2
.skip

;* oam main set *
	lda	kz_tpx
	sta	sprites+4,y
	sec
	sbc	#16
	sta	sprites+0,y

	lda	kz_tpy
	sec
	sbc	#8+1
	sta	sprites+1,y
	sta	sprites+5,y

	a16
	lda	kz_tpa
	sta	sprites+2,y	;character
	inc	a
	inc	a
	sta	sprites+6,y	;character

	tya
	clc
	adc	#8
	tay

	plp
	rts

;=====================================================================
;*	Set Sprite (32*32) = (X,Y),Char,Att			*
;* Input	:kz_tpx :cx zahyou (8 BYTE)				*
;*	:kz_tpy :cy zahyou (8 BYTE)				*
;*	:kz_tpa :chacter pointer				*
;* Temp	:kz_x1,kz_y1,kz_z1					*
;* data bank 7e 							*
;=====================================================================
SetSprite_32x32
SetSprite_16
	phx
	php
	longi
;* Set OAM sub *
	a16
	km_bitcheckscreenflag	sprwbuf
	a8
	bne	.double
.single
	km_setspritesizesb4
	bra	.skip
.double
	km_setspritesizedb4
.skip

;* Set OAM Main *
	a16
	stz	kz_x1
	ldx	kz_tpa
	lda.l	Sprite32x32Data,x
	sta	kz_y1
	a8
	km_setval	kz_z1,4
.loop
;* Set Sprites Data *
	ldx	kz_x1
	lda	kz_tpx
	clc
	adc.l	sprite16xyhosei,x
	sta.w	sprites,y
	iny
	inx

	lda	kz_tpy
	clc
	adc.l	sprite16xyhosei,x
	sta.w	sprites,y
	iny
	inx
	stx	kz_x1
	
	a16
	ldx	kz_y1
	lda.l	Sprite32x32Data,x
	sta.w	sprites,y
	a8
	inx
	inx
	stx	kz_y1
	iny
	iny
	dec	kz_z1
	bne	.loop

	plp
	plx
	rts

sprite16xyhosei
	db	-16,-16-1
	db	0,-16-1
	db	-16,-1
	db	0,-1

;=====================================================================
;*		Block Trans Sprite Animation Routine		*
;* Input								*
;*	:kz_tpx :center x					*
;*	:kz_tpy :center y					*
;*	:kz_x2  :(kx_blockanmptr = animaton pointer)		*
;*	:kz_y2  :(kx_blockanmtm)  : <<< 0			*
;* Temp	:kz_x1,kz_tpa						*
;* data bank 7e 							*
;=====================================================================
BlockAnimeTrans
	PHX
	php
	ai16
	ldx	kz_x2		;kx_blockanmptr
	lda	kz_y2		;kx_blockanmtm
	cmp	#-1
	beq	.end		;No Display
	cmp	#-3
	beq	.blockset	;Onaji e wo zutto dasu !!

	bit	#$8000
	bne	.skip_initial	;not 1st
.initial
	ldx	kz_x2
	lda.l	SpriteBlockAnime,x
	tax
	bra	.set_pointer
.skip_initial
	lda	kz_y2		;kx_blockanmtm
	bit	#$8000
	beq	.initial
.main
	and	#$7fff
	dec	a
	bne	.setflag

;* next chart pointer *
	lda.l	SpriteBlockAnime+4,x
	sta	kz_y2		;kx_blockanmtm
	cmp	#-1
	beq	.end
	cmp	#-3
	beq	.blockset	;Onaji e wo zutto dasu !!
	cmp	#-4
	beq	.jump

	inx
	inx
	inx
	inx
	bra	.set_pointer

.jump
	lda.l	SpriteBlockAnime+6,x
	tax
.set_pointer
	stx	kz_x2		;kx_blockanmptr
	lda.l	SpriteBlockAnime,x
.setflag
	ora	#$8000
	sta	kz_y2		;kx_blockanmtm
.blockset
	lda.l	SpriteBlockAnime+2,x
	sta	kz_tpa
	jsr	BlockTransSpriteXYOFF
.end
	plp
	PLX
	rts










	IFEQ	1
Init_BlockAnimeTrans_l
	shorta
	longi
	a16
	stz	kx_blkanmlistptr
	stz	kx_blkanmfreeptr
	fmtfreelst.w	kx_blkanmfreeptr,kx_blkanmlist&WM,blkanmkazu,blkanmlen
	a8
	rtl

BlockAnimeTrans_l
	php
	ai16
	ldx	kx_blkanmlistptr
	beq	.end
.LOOP
	lda.w	kx_blkanmcx,x
	sta	kz_tpx
	lda.w	kx_blkanmcy,x
	sta	kz_tpy
	lda.w	kx_blkanminit,x
	sta	kz_tpa

	lda.w	kx_blkanmptr,x
	sta	kx_blockanmptr
	lda.w	kx_blkanmtm,x
	sta	kx_blockanmtm

	jsr	BlockAnimeTransSub

	lda	kx_blockanmptr
	sta.w	kx_blkanmptr,x
	lda	kx_blockanmtm
	sta.w	kx_blkanmtm,x

	lda.w	kx_blkanmnext,x
	tax
	bne	.LOOP
.end
	plp
	rtl
	ENDC

;=====================================================================
;*		Block Trans Sub Routine				*
;* Input								*
;*	:kz_tpa :chacter pointer				*
;* Temp	:kz_x1							*
;* data bank 7e 							*
;=====================================================================
BlockTransSpriteFix
	php
	ai16
;* set sprite sub *
	ldx	kz_tpa
	lda.l	SpriteBlockData,x
	tax

	lda.l	SpriteBlockData,x
	bit	#$8000
	beq	.skip
	and	#$7fff

	PHA
	km_bitcheckscreenflag	sprwbuf
	bne	.double
.single
	PLA
	jsr	BlockSprSize_sub
	bra	.skip
.double
	PLA
	jsr	BlockSprSize_double_sub
.skip

;* set sprite main *
	lda.l	SpriteBlockData,x
	and	#$7fff
	dec	a
	pha

	txa
	clc
	adc	#(SpriteBlockData+2)&WM
	tax

	tya
	clc
	adc	#sprites&WM
	tay

	pla
	km_mvn	SpriteBlockData,sprites

	tya
	sec
	sbc	#sprites&WM
	tay
	plp
	rts

;=====================================================================
;*		Block Trans Sub Routine				*
;* Input								*
;*	:kz_tpx :center x					*
;*	:kz_tpy :center y					*
;*	:kz_tpa :chacter pointer				*
;* Temp	:kz_x1							*
;* data bank 7e 							*
;=====================================================================
BlockTransSpriteXYOFF
	php
	ai16
;* set sprite sub *

	ldx	kz_tpa
	lda.l	SpriteBlockData,x
	tax		;Block Sprite Pointer

	lda.l	SpriteBlockData,x
	bit	#$8000
	beq	.skip
	and	#$7fff
	PHA
	km_bitcheckscreenflag	sprwbuf
	bne	.double
.single
	PLA
	jsr	BlockSprSize_sub
	bra	.skip
.double
	PLA
	jsr	BlockSprSize_double_sub
.skip

;* set sprite main *
	lda.l	SpriteBlockData,x
	and	#$7fff
	lsr	a
	lsr	a
	sta	kz_x1
.loop
	a8
	lda.l	SpriteBlockData+2,x
	clc
	adc	kz_tpx
	sta	sprites,y
	inx
	iny
	lda.l	SpriteBlockData+2,x
	clc
	adc	kz_tpy
	sta	sprites,y
	inx
	iny
	a16
	lda.l	SpriteBlockData+2,x
	sta	sprites,y
	inx
	inx
	iny
	iny
	dec	kz_x1
	bne	.loop

	plp
	rts

;=====================================================================
;*		SetBlock Trans SubRoutine			*
;* Init: kz_address (3 byte) :data address				*
;*       kcounter :data counter					*
;*       ksproffx :(X,Y) zahyou hosei				*
;=====================================================================
BlockTransSprOffSub
	longa
	longi

	tyx	;Xreg <<<< Yreg

	ldy	#0
.loop
	lda.l	[address],y
	clc
	adc	ksproffx
	sta	sprites,x
	inx
	inx
	iny
	iny

	lda.l	[address],y
	sta	sprites,x
	inx
	inx

	iny
	iny
	cpy	kcounter
	bne	.loop

	txy		;Yreg <--- Xreg
	a8
	rts

;*****************************************************************************
;*									*
;*			OBJ SUB Data Set				* 
;*									*
;*****************************************************************************
;=============================================================
;*		OAM SUB (Display flag) all on		*
;* data bank :7e						*
;=============================================================
oamsuballon_l
	shorta
	longi
	pha
	phx
	phy

	phb
	db7e
	a16
	lda	#objsub_on
	sta	sprites_sub
	blocktrans_sub	sprites_sub,sprites_sub+2,(obj_val/4)-2
	a8
	plb

	ply
	plx
	pla
	rtl

;=====================================================================
;*		Sprite Size Set	Sub routine	[single buffer]	*
;*				{Most Fast 4char mode Bit Set}	*
;* Init  :a16i16							*
;*       :Data Bank 7e						*
;*       :Yreg : sprites pointer					*
;=====================================================================
SetSprSize1
SetSprSize_sub
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	ai16
	tya				;2
	and	#001100b		;3
	lsr	a			;2
	tax				;2 	;table pointer :(*0,*4,*8,*c,...)---->(*0,*2,*4,*6)

	tya				;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	tay				;2	;(21) ;sprites sub pointer (0,1,2,3,..,31)

	lda.l	SpriteSizeFlag_1,x
	ora.w	sprites_sub,y
	sta.w	sprites_sub,y	;Set Sprsub pointer

	plp
	ply
	plx
	rts


;* !! Comment !! *
	IFEQ	1
	a16
	tya			;Yreg max < 512
	lsr	a
	ai8
	lsr	a
	pha
	and	#$3
	tax		;table pointer :(*0,*$4,*$8,*$c,...)---->(*0,*1,*2,*3)

	pla
	lsr	a
	lsr	a	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	tay		;sprites sub pointer (0,1,2,3,..,31)

	lda.l	SpriteSizeFlag,x
	ora.w	sprites_sub,y
	sta.w	sprites_sub,y	;Set Sprsub pointer
	ENDC


;=====================================================================
;*		Set Spites Size		[double buffer]		*
;* Yreg : sprites pointer		{Most Fast 4char mode Bit Set}	*
;=====================================================================
SetSprSize_double_sub_l
	ifne	kobjsub
	rtl
	endc

	phx
	phy
	php

	ai16
	tya
	cmp	#sprbuf2offs
	bmi	.buf1		;if < (128*4+128/4) THEN write buffer 1
.buf2
	sec				;2
	sbc	#sprbuf2offs		;3
	lsr	a			;2
	tay				;2
	and	#000110b		;3
	tax				;2	;table pointer :(*0,*4,*8,*c,...)---->(*0,*2,*4,*6)

	tya				;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	tay				;2;	;sprites sub pointer (0,1,2,3,..,31)

	lda.l	SpriteSizeFlag_1,x
	ora.w	sprites_sub2,y
	sta.w	sprites_sub2,y	;Set Sprsub pointer

	plp
	ply
	plx
	rtl
.buf1
	longa
	longi
	and	#001100b		;3
	lsr	a			;2
	tax				;2 	;table pointer :(*0,*4,*8,*c,...)---->(*0,*2,*4,*6)

	tya				;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	tay				;2	;(21) ;sprites sub pointer (0,1,2,3,..,31)

	lda.l	SpriteSizeFlag_1,x
	ora.w	sprites_sub,y
	sta.w	sprites_sub,y	;Set Sprsub pointer

	plp
	ply
	plx
	rtl


;* !! Comment !! *
	IFEQ	1
	ai16
	tya
	cmp	#(128*4)+(128/4)
	bmi	.buf1		;if < (128*4+128/4) THEN write buffer 1
.BUF2
	sec
	sbc	#(128*4)+(128/4)
	km_shiftRUA2		;oam (*0,*4,*8,*c)---->(*0,*1,*2,*3)
	pha
	and	#$0003
	tax			;loop counter

	pla
	km_shiftRUA2	;oam (*0,*16,*32,*48)---->(*0,*1,*2,*3)
	clc
	adc	#(128*4)+(128/4)
	tay			;set sprite sub pointer
	bra	.SET
.buf1
	km_shiftRUA2	;oam (*0,*4,*8,*c)---->(*0,*1,*2,*3)
	pha
	and	#3
	tax
	pla
	km_shiftRUA2	;oam (*0,*16,*32,*48)---->(*0,*1,*2,*3)
	tay		;sprites sub pointer (0,1,2,3,..,31)
.SET
	a8
	lda.l	SpriteSizeFlag,x
	ora.w	sprites_sub,y
	sta.w	sprites_sub,y
	ENDC


;=====================================================================
;*		Set Sprite Size	[1 char] 	{Single Buffer}	*
;* Yreg : sprites pointer						*
;=====================================================================
SetSprSize_sb1
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	a8
	lda	#SpriteSizeFlag_1>>16
	sta	kz_tempaddrl+2
	a16
	lda	#SpriteSizeFlag_1&WM
	sta	kz_tempaddrl
	jsr	SetSprSize_single

	plp
	ply
	plx
	rts
;=====================================================================
;*		Set Sprite Size	[2 char] 	{Single Buffer}	*
;* Yreg : sprites pointer						*
;=====================================================================
SetSprSize_sb2
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	a8
	lda	#SpriteSizeFlag_2>>16
	sta	kz_tempaddrl+2
	a16
	lda	#SpriteSizeFlag_2&WM
	sta	kz_tempaddrl
	jsr	SetSprSize_single

	plp
	ply
	plx
	rts


;=====================================================================
;*		Set Sprite Size	[3 char] 	{Single Buffer}	*
;* Yreg : sprites pointer						*
;=====================================================================
SetSprSize_sb3
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	a8
	lda	#SpriteSizeFlag_3>>16
	sta	kz_tempaddrl+2
	a16
	lda	#SpriteSizeFlag_3&WM
	sta	kz_tempaddrl
	jsr	SetSprSize_single

	plp
	ply
	plx
	rts
;=====================================================================
;*		Set Sprite Size	[4 char]  	{Single Buffer}*
;* Yreg : sprites pointer						*
;=====================================================================
SetSprSize_sb4
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	a8
	lda	#SpriteSizeFlag_4x4>>16
	sta	kz_tempaddrl+2
	a16
	lda	#SpriteSizeFlag_4x4&WM
	sta	kz_tempaddrl
	jsr	SetSprSize_single

	plp
	ply
	plx
	rts



;=====================================================================
;*		Set Sprite Size	[1 char] {Single&Double Buffer}	*
;* Yreg : sprites pointer						*
;=====================================================================
SetSprSize_db1
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	a8
	lda	#SpriteSizeFlag_1>>16
	sta	kz_tempaddrl+2
	a16
	lda	#SpriteSizeFlag_1&WM
	sta	kz_tempaddrl
	jsr	SetSprSize_multi

	plp
	ply
	plx
	rts
;=====================================================================
;*		Set Sprite Size	[2 char] {Single&Double Buffer}	*
;* Yreg : sprites pointer						*
;=====================================================================
SetSprSize_db2
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	a8
	lda	#SpriteSizeFlag_2>>16
	sta	kz_tempaddrl+2
	a16
	lda	#SpriteSizeFlag_2&WM
	sta	kz_tempaddrl
	jsr	SetSprSize_multi

	plp
	ply
	plx
	rts


;=====================================================================
;*		Set Sprite Size	[3 char] {Single&Double Buffer}	*
;* Yreg : sprites pointer						*
;=====================================================================
SetSprSize_db3
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	a8
	lda	#SpriteSizeFlag_3>>16
	sta	kz_tempaddrl+2
	a16
	lda	#SpriteSizeFlag_3&WM
	sta	kz_tempaddrl
	jsr	SetSprSize_multi

	plp
	ply
	plx
	rts
;=====================================================================
;*		Set Sprite Size	[4 char]  {Single&Double Buffer}*
;* Yreg : sprites pointer						*
;=====================================================================
SetSprSize_db4
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php

	a8
	lda	#SpriteSizeFlag_4x4>>16
	sta	kz_tempaddrl+2
	a16
	lda	#SpriteSizeFlag_4x4&WM
	sta	kz_tempaddrl
	jsr	SetSprSize_multi

	plp
	ply
	plx
	rts

;=====================================================================
;*		Sprite Size Set	Sub routine [For single buffer]	*
;* Init  :Yreg	: sprites pointer				*
;*       :kz_tempaddr: sprite sub flag pointer			*
;=====================================================================
SetSprSize_single
	longa
	longi

	tya				;2
	lsr	a			;2
	tax				;2
	and	#000110b		;3
	tay				;2	;table pointer :(*0,*4,*8,*c,...)---->(*0,*2,*4,*6)

	txa				;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	tax				;2;(23) ;sprites sub pointer (0,1,2,3,..,31)

	lda.w	[kz_tempaddrl],y
	ora	sprites_sub,x
	sta	sprites_sub,x	;Set Sprsub pointer
	rts

;=====================================================================
;*	Sprite Size Set	Sub routine	[single&double buffer]	*
;* Init  :Yreg	: sprites pointer				*
;*       :kz_tempaddr: sprite sub flag pointer			*
;=====================================================================
SetSprSize_multi
	longa
	longi
	tya
	cmp	#sprbuf2offs
	bmi	.buf1		;if < (128*4+128/4) THEN write buffer 1
.buf2
	sec				;2
	sbc	#sprbuf2offs		;3
	lsr	a			;2
	tax				;2
	and	#000110b		;3
	tay				;2	;table pointer :(*0,*4,*8,*c,...)---->(*0,*2,*4,*6)

	txa				;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	tax				;2;	;sprites sub pointer (0,1,2,3,..,31)

	lda.w	[kz_tempaddrl],y
	ora	sprites_sub2,x
	sta	sprites_sub2,x	;Set Sprsub pointer
	rts
.buf1
	longa
	longi
	lsr	a			;2
	tax
	and	#000110b		;3
	tay				;2 	;table pointer :(*0,*4,*8,*c,...)---->(*0,*2,*4,*6)

	txa				;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	tax				;2	;(21) ;sprites sub pointer (0,1,2,3,..,31)

	lda.w	[kz_tempaddrl],y
	ora	sprites_sub,x
	sta	sprites_sub,x	;Set Sprsub pointer
	rts

;!! Comment !!

	IFEQ	1
	lda	#0
	cpy	#(128*4)+(128/4)
	bmi	.buf1		;if < (128*4+128/4) THEN write buffer 1
.buf2
	lda	#(128*4)+(128/4)
.buf1
	sta	kx_sprdouble

	tya
	sec
	sbc	kx_sprdouble
	lsr	a
	pha
	and	#7
	tay		;table pointer :(*0,*4,*8,*c,...)---->(*0,*2,*4,*6)
	pla
	lsr	a
	lsr	a
	lsr	a	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	clc
	adc	kx_sprdouble
	tax		;sprites sub pointer (0,1,2,3,..,31)

	lda.w	[kz_tempaddrl],y
	ora	sprites_sub,x
	sta	sprites_sub,x	;Set Sprsub pointer
	rts
	ENDC

;=====================================================================
;*		Set Block Trans Spites Size (single buffer)	*
;* kono Routine wa BLOCK UNIT de OAM DATA no SIZE wo SET suru	*
;* Mem  : a16 i16 [init,exit]					*
;* Acc  : transfer value						*
;* Yreg : sprites pointer						*
;* Temp : kz_x1							*
;=====================================================================
BlockSprSize_sub
	ifne	kobjsub
	rts
	endc

	phx
	phy
	php
	ai16
	lsr	a			;2
	lsr	a			;2
	sta	kz_x1	;sprites no kazu	(max 128)


	tya				;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2
	lsr	a			;2	;oam (*0,*$10,*$20,*$30)---->(*0,*1,*2,*3) :(/16)
	tax				;2	;(21) ;sprites sub pointer (0,1,2,3,..,31)

	tya
	and	#001100b		;3
	lsr	a			;2	;(0,2,4,6)
	txy
	tax				;2 	;table pointer :(*0,*4,*8,*c,...)---->(*0,*2,*4,*6)
	bne	.getbottom		;if pointer is not bottom
;----------------------------------------------------------------------
.loop
	lda	kz_x1
	cmp	#8
	bmi	.blockset	;if kz_x1 (sprite value)< 8
	beq	.blockset	;if kz_x1 (sprite value)= 8

	sec
	sbc	#8
	sta	kz_x1	;dec sprites value counter

	ldx	#16	;Set size flag pointer
	lda.l	BlockSprSizeFlag,x
	ora	sprites_sub,y
	sta	sprites_sub,y	;Set Sprsub pointer
	iny
	iny
	bra	.loop
.blockset
	asl	a
	tax
	lda.l	BlockSprSizeFlag,x
	ora	sprites_sub,y
	sta	sprites_sub,y	;Set Sprsub pointer
	bra	.end
;----------------------------------------------------------------------
.getbottom
	lda.l	SpriteSizeFlag_1,x
	ora	sprites_sub,y
	sta	sprites_sub,y	;Set Sprsub pointer

	dec	kz_x1
	beq	.end		;If Size Flag set all end	
	inx
	inx
	cpx	#8
	bmi	.getbottom	;if size flag pointer < 8
	iny			;sprites sub pointer =+1
	bra	.loop
;----------------------------------------------------------------------
.end
	plp
	ply
	plx
	rts

;=====================================================================
;*		Set Block Trans Spites Size	[double buffer]	*
;* Acc  : transfer value						*
;* Yreg : sprites pointer						*
;=====================================================================
BlockSprSize_double_sub
	ifne	kobjsub
	rts
	endc

	longa
	longi
	phx
	phy
;* sprites no kazu *
	km_shiftRUA2	;tensou ryou /4
	sta	kwork	;sprite no kazu	(max 128)

;* OAM Double Buffer no slect*
	tya
	cmp	#(128*4)+(128/4)
	bmi	.buf1		;if < (128*4+128/4) THEN write buffer 1
.buf2
	sec
	sbc	#(128*4)+(128/4)
	km_shiftRUA2 	;OAM Size Flag Ptr (*0,*4,*8,*c)-->(*0,*1,*2,*3)
	PHA
	km_shiftRUA2	;Sub Addr Ptr(*0,*10h,*20h,..)--->(*0,*1,*2,..31)
	clc
	adc	#(128*4)+(128/4)
	tay		;sprites size sub pointer (0,1,2,3,..,31)
	bra	.skip
.buf1
	km_shiftRUA2 	;OAM Size Flag Ptr(*0,*4,*8,*c)---->(*0,*1,*2,*3)
	PHA		;PHA <-- Sprite Size
	km_shiftRUA2	;Sub Addr Ptr (*0,*10h,*20h,..)-->(*0,*1,*2,..31)
	tay		;sprites sub pointer (0,1,2,3,..,31)
;----------------------------------------------------------------------
.skip
	PLX		;Sprite Size flag pointer kari set
	txa
	and	#3
	tax
	bne	.set	;if pointer is not bottom
.loop
	lda	kwork
	cmp	#4
	bmi	.set	;if kwork (sprite no nokori kazu)< 4 ko

	ldx	#4	;Set size flag pointer

	lda	kwork
	sec
	sbc	#3
	sta	kwork	;dec sprites value counter
;----------------------------------------------------------------------
.set
	a8
	lda.l	SpriteSizeFlag,x
	ora	sprites_sub,y
	sta	sprites_sub,y	;Set Sprsub pointer
	a16
;----------------------------------------------------------------------
	dec	kwork

	lda	kwork
	beq	.end	;If Size Flag set all end	

	inx
	txa
	cmp	#4
	bmi	.set	;if size flag pointer < 3

	iny		;sprites sub pointer =+1
	ldx	#0
	bra	.loop
;----------------------------------------------------------------------
.end
	ai16
	ply
	plx
	rts


;=====================================================================
;*	    a		DUMMY DATA SET				*
;* mem  :sprite pointer wo sub data set no tugounoyoi katachi ni suru*  
;* Xreg :Table pointer						*
;* Yreg :sprites pointer						*
;=====================================================================
SetSprDummy_sub
	phx
	a16
	longi
;* Loop Counter *
	tya
	km_shiftRUA2 	;(*0,*4,*8,*c)---->(*0,*1,*2,*3)
	and	#3
	beq	.end
	dec	a
	tax

	lda.l	SprDummyTbl,x
	tax
;* Dummy Data Set *

	lda	#obj_clear
.loop	sta	sprites,y
	iny
	iny
	iny
	iny
	dex
	bne	.loop

.end	a8
	plx
	rts
;----------------------------------------
SprDummyTbl
	db	3	;3 kai Loop
	db	2	;2 kai loop
	db	1	;1 kai loop



;=============================================================================
;*									*
;*			Sprites Set Debug Mode				*
;*									*
;=============================================================================
;-----------------------------------------------------
;*	Display DEBUG Parameters Sub Routine	*
;* data bank 0					*
;-----------------------------------------------------
disp_alvar_l
	longa
	longi
;Display 1

	lda	#5
	sta	kcounter	;loop counter
.loop
	lda	kwork+2
	sta.l	sprites,x
	sec
	sbc	#8
	sta	kwork+2

	inx
	inx

	phx
	lda	kwork+0
	km_cpudivu16uf8_xy	10
	stx	kwork+0
	plx	

	tya
	clc
	adc	#(obj_offset+$30)!(colpal7<<9)!(pri3<<12)
	sta.l	sprites,x
	inx
	inx

	dec	kcounter
	beq	.exit
	brl	.loop
.exit
	rtl


;=====================================================================
;*		Sprites Size Flag Table				*
;=====================================================================
SpriteSizeFlag
	db	%00000010	;0
	db	%00001000	;4
	db	%00100000	;8
	db	%10000000	;c
	db	%10101010	;all
SpriteSizeFlagEnd
mm_SpriteSizeLen	equ	SpriteSizeFlagEnd-SpriteSizeFlag
;----------------------------------------------------------------------
SpriteSizeFlag_1	;(8 byte)
	dw	%0000000000000010
	dw	%0000000000001000
	dw	%0000000000100000
	dw	%0000000010000000

SpriteSizeFlag_2	;(8 byte)
	dw	%0000000000001010
	dw	%0000000000101000
	dw	%0000000010100000
	dw	%0000001010000000
SpriteSizeFlag_3	;(8 byte)
	dw	%0000000000101010
	dw	%0000000010101000
	dw	%0000001010100000
	dw	%0000101010000000
SpriteSizeFlag_4x4	;(8 byte)
	dw	%0000000010101010	;all
	dw	%0000001010101000
	dw	%0000101010100000
	dw	%0010101010000000
;----------------------------------------------------------------------
BlockSprSizeFlag	;(16 byte)
	dw	%0000000000000000	;0
	dw	%0000000000000010	;1
	dw	%0000000000001010	;2
	dw	%0000000000101010	;3
	dw	%0000000010101010	;4
	dw	%0000001010101010	;5
	dw	%0000101010101010	;6
	dw	%0010101010101010	;7
	dw	%1010101010101010	;8







