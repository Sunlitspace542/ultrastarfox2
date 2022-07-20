
  	INCPUB	blink

doblink	ai16
	lda	#$1f+($1f<<5)+($1f<<10)
	sta.l	blinkcol
	bra	stopall
doblink1	ai16
	lda	#$1f+($1f<<10)	; pink
	sta.l	blinkcol
	bra	stopall
doblink2	ai16
	lda	#$1f+($1f<<5)	; yellow
	sta.l	blinkcol
	bra	stopall
doblink3	ai16			; cyan
	lda	#($1f<<5)+($1f<<10)
	sta.l	blinkcol
	bra	stopall
doblink4	ai16			; green (sound loop crashed)
	lda	#($1f<<5)
	sta.l	blinkcol
	bra	stopall
stopall	a8
	lda	#0
	pha
	plb
	stx	blinkval
	stz	nmitimen
	stz	hdmaen
	disable
	stz	tm
	stz	ts
	stz	w12sel
	stz	w34sel		;wh0,1 set with hdma
	stz	wobjsel
	stz	wbglog
	stz	wobjlog
	stz	cgadsub
	stz	coldata
	stz	tmw
	stz	tsw
	stz	wh0
	stz	wh1
	stz	vmaddl
	stz	vmaddh
	lda	#$80
	sta	vmainc

; clear VRAM
	lda	#0
	ldx	#127*256
.li	sta	vmdatal
	dex
	bne	.li
	a8i16
	lda	#$f
	sta	inidisp
	i16
.again
	stz	cgadd
	lda	blinkcol
	sta	cgdata
	lda	blinkcol+1
	sta	cgdata





	ldx	#15
.waitx	ldy	#0		;wait about 1 frame
.wait	dey
	bne	.wait
	dex
	bne	.waitx



	stz	cgadd
	stz	cgdata
	stz	cgdata

	ldx	#10
.waitx2	ldy	#0		;wait about 1 frame
.wait2	dey
	bne	.wait2
	dex
	bne	.waitx2

	bra	.again




