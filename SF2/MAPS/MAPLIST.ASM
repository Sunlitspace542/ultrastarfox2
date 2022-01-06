
	INCPUB	maplist

incmap	MACRO
	incfile	maps\\\1.asm
	ENDM

incmmap	MACRO
	incfile	maps\\mis\\\1.asm
	ENDM

incbmap	MACRO
	incfile	maps\\bat\\\1.asm
	ENDM
 
	mapdef	mapp	; player's map address

	INCMAP	MAPP

titlemap	incmap	titlemap
exp1map	incmmap	exp1
pldownmap	incmmap	pldown

stg1map	incmmap	stg1
stg2map	incmmap	stg2
stg3map	incmmap	stg3
stg4map	incmmap	stg4
stg5map	incmmap	stg5
stg6map	incmmap	stg6
ext1map	incmmap	ext1
ext2map	incmmap	ext2
ext3map	incmmap	ext3
ext4map	incmmap	ext4
sos1map	incmmap	sos1
sos2map	incmmap	sos2
sos3map	incmmap	sos3

titledemomap		incmmap	demo0
startenemydemomap	incmmap	demo1
dummy0demomap	incmmap	demo2
startarwingdemomap	incmmap	demo3
corneriafelldemomap	incmmap	demo4
dummy1demomap	incmmap	demo5
endingdemomap	incmmap	demo6
specialenemydemomap	incmmap	demo7
dummy2demomap	incmmap	demo8
cannondemomap	incmmap	demo9

tra1map	incmmap	tra1

;rdstg1map	incmmap	rdstg1
;bat1map	incbmap	bat1
;bat2map	incbmap	bat2
;bat3map	incbmap	bat3
;testmap	incmmap	test
;bat4map	incbmap	bat4
;bat5map	incbmap	bat5
;kmap	incmap	kmap
;tmap	incmap	tmap
;dmap	incmap	dmap
;emap	incmap	emap
;ymap	incmap	ymap
;typemap	incmmap	type
;groundmap	incmap	ground
;marinemap	incmap	marine
;spacemap	incmap	space
;desertmap	incmap	desert
;tunnelmap	incmap	tunnel
;megane3Dmap	incmap	megane3D
;titlemap	incmap	title		;Now Not Use
;gameovermap	incmap	gameover	;Now Not Use
;intromap	incmap	intro		;Now Not Use
;mapscr_map	incmap	mapscr		;Now Not Use

maps	=	*-mapbase
	?maps


