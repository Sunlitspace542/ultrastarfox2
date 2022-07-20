;-------------------------------------------------------------------;
;                                                                   ;
;                    STARFOX II - THE SEQUEL                        ;
;                                                                   ;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
;                                                                   ;
; FILE:         HDMATABS.ASM                                        ;
; AUTHOR:       Yasuhiro Kawaguchi                                  ;
; DESCRIPTION:  HDMA TABLES		                               ;
; DATE CREATED: 18-4-94                                             ;
;                                                                   ;
;-------------------------------------------------------------------;

	INCPUB	hdmatabs

;*********************************************************************
;*								*
;*			HDMA ENABEL SWITCH			*
;*								*
;*********************************************************************
; starfox 2:
;hdmaf_inidisp	equ	%00000010
hdmaf_tm		equ	%00000010
;hdmaf_bg2scroll	equ	%00000100
hdmaf_bg2vscroll	equ	%00000100
hdmaf_bg2hscroll	equ	%00001000
hdmaf_hvofs		equ	%00010000
hdmaf_circle         equ     %00100000

; not using: (starfox 1)
hdmaf_bg2hofs	equ	%00000100
hdmaf_win		equ	%00001000
hdmaf_bg2vofs	equ	%00010000

;*********************************************************************
;*								*
;*			WINDOW TABLES				*
;*								*
;*********************************************************************
;(Normal Screen)
xhdma_window
	db	112+128
hdmawindow1
	dw	hdmawindowoff&WM

	db	112+128
hdmawindow2
	dw	hdmawindowoff&WM

	db	1			;dummy
	dw	hdmawindowoff&WM
	db	0			;end code
;---------------------------------------------------------------------
;(For One Player)
xhdma_window_mission
	db	15			;saisyo (blanking)
	dw	hdmawindowoff&WM

	db	(bitmapheight_1*8)/2+128 ;Player 1 (Line + data flag)
hdmawindow_mission1
	dw	hdmawindowoff&WM

	db	(bitmapheight_1*8)/2+128 ;Player 1 (Line + data flag)
hdmawindow_mission2
	dw	hdmawindowoff&WM

	db	1			;dummy
	dw	hdmawindowoff&WM
	db	0			;end code
;---------------------------------------------------------------------
; window hdma -- indirect mode to allow redefinable table on the fly
;(For Two Player)
xhdma_window_battle
	db	15			;saisyo (blanking)
	dw	hdmawindowoff&WM
	db	bitmapvheight*8+128	;Player 1 (Line + data flag)
hdmawindow_battle1
	dw	hdmawindowoff&WM
	db	8			;sakaime
	dw	hdmawindowoff&WM
	db	bitmapvheight*8+128	;player 2 (Line + data flag) 
hdmawindow_battle2
	dw	hdmawindowoff&WM
	db	1			;dummy
	dw	hdmawindowoff&WM
	db	0			;end code
;----------------------------------------------------------------------
;=== Window ON data ===
;hdmawindowon
;	dw	$FF00
;	dw	$FF00
;=== Window OFF data ===
;hdmawindowoff
;	dw	0001
;	dw	0001

;*********************************************************************
;*								*
;*			HV SCROLL TABLE				*
;*								*
;*********************************************************************
scrolloff
	dw	0
	dw	0
;=====================================================================
;*			VSCROLL					*
;=====================================================================
xhdma_bg2vscroll_mis
 	db	15
xh_vscrolladr0_mis
	dw	scrolloff&WM
	db	bitmapvheight*8
xh_vscrolladr1_mis
	dw	xh_vscrolltbl1&WM
	db	bitmapvheight*8
xh_vscrolladr2_mis
	dw	xh_vscrolltbl2&WM
	db	0
;------------------------------------------
xhdma_bg2vscroll_bat
;(405 byte) = ($195 BYTE)
	db	15
xh_vscrolladr0_bat
	dw	scrolloff&WM
	db	bitmapvheight*8
xh_vscrolladr1_bat
	dw	xh_vscrolltbl1&WM
	db	8
	dw	scrolloff&WM
	db	bitmapvheight*8
xh_vscrolladr2_bat
	dw	xh_vscrolltbl2&WM
	db	0

;=====================================================================
;*			HSCROLL					*
;=====================================================================
xhdma_bg2hscroll_mis
;(405 byte) = ($195 BYTE)
	db	15
xh_hscrolladr0_mis
	dw	scrolloff&WM
	db	bitmapvheight*8
xh_hscrolladr1_mis
	dw	xh_hscrolltbl1&WM
	db	bitmapvheight*8
xh_hscrolladr2_mis
	dw	xh_hscrolltbl2&WM
	db	0
;------------------------------------------
xhdma_bg2hscroll_bat
;(405 byte) = ($195 BYTE)
	db	15
xh_hscrolladr0_bat
	dw	scrolloff&WM
	db	bitmapvheight*8
xh_hscrolladr1_bat
	dw	xh_hscrolltbl1&WM
	db	8
	dw	scrolloff&WM
	db	bitmapvheight*8
xh_hscrolladr2_bat
	dw	xh_hscrolltbl2&WM
	db	0
;-------------------------------------------
;* mission map select *
xhdma_bg1hvscroll_mismap
	db	(30-15)*8
	dw	xh_hscrolltbl1&WM
	db	15*8
	dw	xh_hscrolltbl1&WM
	db	0

xhdma_bg2hvscroll_mismap
	db	5*8+3
	dw	scrolloff&WM
	db	(24-10)*8
	dw	xh_hscrolltbl2&WM
	db	10*8
	dw	xh_hscrolltbl2&WM
	db	0

;-------------------------------------------


;*********************************************************************
;*								*
;*			HV OFFSET TABLE				*
;*								*
;*********************************************************************
xhdma_hvofs
	db	bitmapvheight*8+16+4-1
	dw	((_hvofs_base1>>5)&31)<<3
	db	1
xh_hvofs
	dw	((_hvofs_base2>>5)&31)<<3
	db	0			;end code

;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
	IFEQ	0
xhdma_inidisp
	db	12
	db	$80

	db	95	;makes 190
xinidisp1	db	$80

	db	45
xinidisp2	db	$80
	db	50
xinidisp1a	db	$80

	db	127
	db	$80
	db	0


xhdma_inidisp2
	db	47
	db	$80

	db	127
xinidisp3	db	$f
	db	2
xinidisp4	db	$f
	db	120
	db	$80	; turn off below sphere
	db	0

xhdma_inidisp3
	db	15
	db	$80
	db	70
xinidisp5	db	$f
	db	127
xinidisp6	db	$f	; 100 = 200 scanlines of visiblescreen
	db	3
xinidisp7	db	$f	; 100 = 200 scanlines of visiblescreen
	db	100
	db	$80	
	db	0

	ENDC


	IFEQ	1
xhdma_window
xhdma_wv0	db	0
	db	0
xhdma_wv1	db	0
	db	0

	db	30
	db	2<<4	; window 1 enable for bg1
	db	100
	db	0
	db	0

xhdma_bg2hofs1
	rept	250
	db	1
	dw	128
	endr
	db	0

xhdma_bg2hofs2
	rept	250
	db	1
	dw	128
	endr
	db	0


xhdma_bg2vofs
	db	10
	dw	0
	rept	250
	db	1
	dw	0
	endr
	db	0

	ENDC

;hdma_end	equ	(*-ramstart)+$28000


;xhdma_s	=	xhdma_tables
;xhdmaalc	macro
;\1	=	xhdma_s
;xhdma_s	=	xhdma_s+\2
;	endm
;
;	xhdmaalc	xhdma_start,0
;	xhdmaalc	xhdma_inidisp,hdma_inidisplen
;	xhdmaalc	xhdma_inidisp2,hdma_inidisp2len
;	xhdmaalc	xhdma_inidisp3,hdma_inidisp3len
;	xhdmaalc	xhdma_window,hdma_windowlen
;	xhdmaalc	xhdma_bg2hofs1,hdma_bg2hofslen
;	xhdmaalc	xhdma_bg2hofs2,hdma_bg2hofs2len
;	xhdmaalc	xhdma_wh0l,hdma_wh0llen
;	xhdmaalc	xhdma_wh0r,hdma_wh0rlen
;	xhdmaalc	xhdma_wh1l,hdma_wh1llen
;	xhdmaalc	xhdma_wh1r,hdma_wh1rlen
;	xhdmaalc	xhdma_bg2vofs,hdma_bg2vofslen
;	xhdmaalc	xhdma_end,0
;
;	IFGE	(xhdma_s-xhdma_start)-xhdma_max
;	progress_off
;	printf	"Error: XHDMA tables too large in %$6.%n"
;	progress_on
;	ENDC
;
;hdmadef	macro
;x\1	equ	((\1-hdma_start)+xhdma_start)
;	endm
;
;	hdmadef	inidisp1
;	hdmadef	inidisp2
;	hdmadef	inidisp3
;	hdmadef	inidisp4
;	hdmadef	inidisp5
;	hdmadef	inidisp6
;	hdmadef	hdma_wv0
;	hdmadef	hdma_wv1
;	hdmadef	hdma_wh0ld
;	hdmadef	hdma_wh0rd
;	hdmadef	hdma_wh1ld
;	hdmadef	hdma_wh1rd
;	hdmadef	inidisp1a
;
;	IFEQ	1
;xinidisp1	equ	((inidisp1-hdma_inidisp)+xhdma_inidisp)
;xinidisp2	equ	((inidisp2-hdma_inidisp)+xhdma_inidisp)
;
;xinidisp3	equ	((inidisp3-hdma_inidisp2)+xhdma_inidisp2)
;xinidisp4	equ	((inidisp4-hdma_inidisp2)+xhdma_inidisp2)
;
;xinidisp5	equ	((inidisp5-hdma_inidisp3)+xhdma_inidisp3)
;xinidisp6	equ	((inidisp6-hdma_inidisp3)+xhdma_inidisp3)
;
;xhdma_wv0	equ	((hdma_wv0-hdma_start)+xhdma_start)
;xhdma_wv1	equ	((hdma_wv1-hdma_start)+xhdma_start)
;	ENDC
;
;*********************************************************************
;*								*
;*			NOT USING AREA				*
;*								*
;*********************************************************************
	IFEQ	1
;=====================================================================
;*			Window					*
;=====================================================================
;Not Useing Now
;94/6/15 
	IFEQ	1
xhdma_circhofs
	REPT	224
	dw	0
	ENDR
xhdma_htflhofs
	REPT	16
	dw	0
	ENDR
xhdma_outhofs
	REPT	16
	dw	0
	ENDR

xhdma_pausehofs
	REPT	16
	dw	0
	ENDR

;hdma_start	equ	(*-ramstart)+$28000
xhdma_start
xhdma_wh0wh1_1	db	15
	dw	0ff00h
	rept	192
	db	1
	dw	0ff00h
	endr
	db	0

xhdma_wh0wh1_2	db	15
	dw	0ff00h
	rept	192
	db	1
	dw	0ff00h
	endr
	db	0

	ENDC
;=====================================================================
;*			H-V SCROLL				*
;=====================================================================
	IFEQ	1

xhdma_seahscroll
	db	15
	dw	bg2voff
	db	(bitmapvheight+1)*8+128
xh_seahscrolladr1
	REPT	(bitmapvheight+1)*8
	dw	$0
	ENDR
	db	bitmapvheight*8+128
xh_seahscrolladr2
	REPT	(bitmapvheight)*8
	dw	$0
	ENDR
	db	0
;---------------------------------------------------------------------
;(10 byte)
xhdma_bg2hscroll_normal
	db	15
	dw	bg2voff
	db	(bitmapvheight+1)*8
xh_hscrolladr1_normal
	dw	0
	db	bitmapvheight*8
xh_hscrolladr2_normal
	dw	0
	db	0

;=====================================================================
;*			For Battle				*
;=====================================================================
xhdma_bg2vscroll_bat
	db	15
	dw	bg2voff

	db	bitmapvheight*8+128
xh_p1vscrolladr
	dw	0		;xh_p1marinevscroll&WM	;xh_player1vscroll&WM

	db	8
xh_halfscrolladr
	dw	xh_halfvscroll&WM
	db	bitmapvheight*8+128
xh_p2vscrolladr
	dw	0		;xh_p2marinevscroll&WM	;xh_player2vscroll&WM
	db	0
;------------------------------------------------------------------------
xh_player1hscroll
	dw	bg2voff
xh_halfhscroll
	dw	bg2voff
xh_player2hscroll
	dw	bg2voff

xh_player1vscroll
xh_halfvscroll
xh_player2vscroll
	dw	bg2voff

xh_p1marinevscroll
	REPT	bitmapheight*8
	dw	0
	ENDR
xh_p2marinevscroll
	REPT	bitmapheight*8
	dw	0
	ENDR
xh_p1marinehscroll
	REPT	bitmapheight*8
	dw	0
	ENDR

xh_p2marinehscroll
	REPT	bitmapheight*8
	dw	0
	ENDR
;---------------------------------------------------------------------
xhdma_bg2vscroll_one
	db	1
	dw	xh_player1vscroll_one&WM	;xh_p1marinevscroll&WM
	db	0				;end code

xh_player1vscroll_one
	dw	0
;------------------------------------------------------------------------
xhdma_bg2hscroll_one
	db	1
	dw	xh_player1hscroll_one&WM	;xh_p1marinevscroll&WM
	db	0				;end code
xh_player1hscroll_one
	dw	0

;=====================================================================
;*		Battle Player Select H,V SCROLL			*
;=====================================================================
	IFEQ	1
bg2hoffp1_bps	=	0
bg2voffp1_bps	=	-24
bg2hoffp2_bps	=	0
bg2voffp2_bps	=	-152

xhdma_bg2hvscroll_bps
	db	16*8
xh_p1hscrolladr_bps
	dw	bg2hoffp1_bps
xh_p1vscrolladr_bps
	dw	bg2voffp1_bps

	db	1
xh_p2hscrolladr_bps
	dw	bg2hoffp2_bps
xh_p2vscrolladr_bps
	dw	bg2voffp2_bps

	db	0
	ENDC
;---------------------------------------------------------------------
;*		TEST Version		28/10/93		*
;---------------------------------------------------------------------
	IFEQ	1
;kono version ha hvscroll no H-DMA SET wo 1 channel de shiteiru.
; scroll hdma -- indirect mode to allow redefinable table on the fly
;
bg2hvscrolloff	equ	0
bg2hscrolloff	equ	0
bg2vscrolloff	equ	0

;**** H-DMA Table [SCROLL] *****
xhdma_bg2scroll
	db	bitmapvheight*8+16+4-1
xh_player1scroll
	dw	xh_player1hvscroll&WM
	db	1
xh_player2scroll
	dw	xh_player2hvscroll&WM
	db	0			;end code
;***** H-DMA Data *****
xh_player1hvscroll
	dw	bg2hscrolloff
	dw	bg2vscrolloff
xh_player2hvscroll
	dw	bg2hscrolloff
	dw	bg2vscrolloff

;***** H-DMA Table [HV offset] *****
xhdma_hvofs
	db	bitmapvheight*8+16+4-1
	dw	((hvofs_base1>>5)&31)<<3
	db	1
	dw	((hvofs_base2>>5)&31)<<3
	db	0	;end code
	endc
	ENDC
;*************************************************************************
;*************************************************************************
;*************************************************************************
	ENDC
